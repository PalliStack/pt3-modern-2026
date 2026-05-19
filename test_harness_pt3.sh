#!/bin/bash
# PT3 Test Harness: IOMMU Delay Injection and Load/Unload Stress Test
# Run this script as root.

set -e

DRIVER="pt3_drv"
MODULE_FILE="./pt3_drv.ko"
TEST_ITERATIONS=100

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "=========================================================="
echo " PT3 Test Harness"
echo " 1. DMA Allocation Tracking"
echo " 2. Load/Unload (insmod/rmmod) Stress Test"
echo " 3. IOMMU Delay Injection via bpftrace"
echo "=========================================================="

# Check if bpftrace is available
if ! command -v bpftrace &> /dev/null; then
    echo "Warning: bpftrace not found. Advanced delay injection will be skipped."
fi

echo "[*] Compiling the driver..."
make clean
make

if [ ! -f "$MODULE_FILE" ]; then
    echo "Error: Driver module not found."
    exit 1
fi

# 1. bpftrace script for DMA tracking and Delay Injection
cat << 'EOF' > pt3_bpf_test.bt
#!/usr/bin/bpftrace

// Track DMA Allocation and Free
kprobe:dma_alloc_coherent
{
    @alloc_count[comm] = count();
}

kprobe:dma_free_coherent
{
    @free_count[comm] = count();
}

// Inject artificial delay into DMA ready polling to simulate IOMMU latency
kprobe:pt3_dma_ready
{
    printf("Simulating IOMMU latency (delaying 10ms)...\n");
    mdelay(10);
}

// Track timeout schedules
kprobe:schedule_timeout_interruptible
{
    @timeout_calls[comm] = count();
}

interval:s:5
{
    printf("\n--- DMA Stats (5s) ---\n");
    print(@alloc_count);
    print(@free_count);
    print(@timeout_calls);
}
EOF
chmod +x pt3_bpf_test.bt

echo "[*] Starting bpftrace in the background..."
if command -v bpftrace &> /dev/null; then
    ./pt3_bpf_test.bt > bpf_trace_output.log &
    BPF_PID=$!
    sleep 2 # wait for bpf to attach
fi

echo "[*] Starting Load/Unload Stress Test ($TEST_ITERATIONS iterations)..."
for i in $(seq 1 $TEST_ITERATIONS); do
    echo -ne "Iteration $i / $TEST_ITERATIONS\r"
    
    # Load module
    insmod $MODULE_FILE
    sleep 0.2
    
    # Simulate device access if device node exists
    if [ -e /dev/pt3video0 ]; then
        # Read from device to trigger DMA
        timeout 0.5 cat /dev/pt3video0 > /dev/null 2>&1 || true
    fi
    
    # Unload module
    rmmod $DRIVER
    sleep 0.1
    
    # Check for memory leaks in dmesg or system instability
    if dmesg | tail -n 20 | grep -i "fail dma_alloc"; then
        echo -e "\n[!] ERROR: DMA Allocation failure detected at iteration $i!"
        break
    fi
    if dmesg | tail -n 20 | grep -i "deadlock"; then
        echo -e "\n[!] ERROR: Deadlock detected at iteration $i!"
        break
    fi
done

echo -e "\n[*] Stress Test Completed."

if [ ! -z "$BPF_PID" ]; then
    echo "[*] Stopping bpftrace..."
    kill -SIGINT $BPF_PID
    sleep 2
    echo "================ BPF Trace Results ================"
    cat bpf_trace_output.log
fi

echo "=========================================================="
echo " Test harness execution finished. Check dmesg for details."
echo "=========================================================="
