#!/bin/bash
# PT3 Modernization Harness 2026

set -e

echo "========================================"
echo "   PT3 Modernization Harness 2026       "
echo "========================================"

STAGE=${1:-1}

run_stage_1() {
    echo "--- Stage 1: Harness Init ---"
    KVER=$(uname -r)
    echo "Current Kernel: $KVER"

    # Check kernel headers
    if [ ! -d "/lib/modules/$KVER/build" ]; then
        echo "ERROR: Kernel headers not found for $KVER"
        echo "Please install: sudo apt-get install linux-headers-$KVER"
        exit 1
    fi

    # Conflict Scan
    echo "Scanning for pt3_dvb (earth_pt3) conflicts..."
    if lsmod | grep -q "earth_pt3"; then
        echo "Found earth_pt3. Unloading..."
        sudo modprobe -r earth_pt3 || echo "Warning: Could not unload earth_pt3"
    fi

    # Safety-Net
    echo "Initializing Safety-Net..."
    mkdir -p /tmp/pt3_backup
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    cp -r . "/tmp/pt3_backup/pt3_$TIMESTAMP"
    echo "Backup created in /tmp/pt3_backup/pt3_$TIMESTAMP"
}

run_stage_3() {
    echo "--- Stage 3: Autonomous Build Loop ---"
    MAX_RETRIES=5
    RETRY=0
    
    while [ $RETRY -lt $MAX_RETRIES ]; do
        echo "Build Attempt $((RETRY+1))..."
        if make -j$(nproc); then
            echo "Build Success!"
            return 0
        else
            echo "Build Failed. Parsing error logs..."
            # Simple auto-debug: if it's a known common error, we might try to fix it.
            # For now, we report and let the AI handle it.
            RETRY=$((RETRY+1))
            if [ $RETRY -lt $MAX_RETRIES ]; then
                echo "Waiting for AI instructions to rewrite code..."
                # In a real autonomous loop, the AI would read the logs and edit files here.
                exit 2 # Signal failure to AI
            fi
        fi
    done
    return 1
}

run_stage_4() {
    echo "--- Stage 4: System Integration ---"
    sudo make install
    sudo depmod -a
    echo "Applying udev rules..."
    if [ -f etc/99-pt3.rules ]; then
        sudo cp etc/99-pt3.rules /etc/udev/rules.d/
        sudo udevadm control --reload-rules
        sudo udevadm trigger
    fi
    echo "Loading module..."
    sudo modprobe pt3_drv || sudo insmod pt3_drv.ko
}

run_stage_5() {
    echo "--- Stage 5: Health Check ---"
    echo "Checking device nodes..."
    ls -l /dev/pt3video* || echo "No device nodes found yet."
    echo "Dmesg log (PT3):"
    dmesg | grep -i PT3 | tail -n 20
}

run_stage_6() {
    echo "--- Stage 6: IOMMU/DMAR Validation ---"
    echo "Checking for DMAR/INTR-REMAP faults..."
    FAULTS=$(dmesg | grep -E "DMAR|INTR-REMAP" | grep "01:00.0" || true)
    if [ -z "$FAULTS" ]; then
        echo "SUCCESS: No IOMMU faults detected for PT3 device."
    else
        echo "WARNING: IOMMU faults detected:"
        echo "$FAULTS"
        echo "Check if IOMMU is enabled in BIOS and kernel parameters."
    fi
}

case $STAGE in
    1) run_stage_1 ;;
    3) run_stage_3 ;;
    4) run_stage_4 ;;
    5) run_stage_5 ;;
    6) run_stage_6 ;;
    all)
        run_stage_1
        run_stage_3
        run_stage_4
        run_stage_5
        run_stage_6
        ;;
    *) echo "Invalid stage" ;;
esac
