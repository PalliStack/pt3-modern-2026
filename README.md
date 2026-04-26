# ?? Project: PT3-Modern-Pack-2026

**Integrating Ubuntu 22.04 + Dual PT3 Cards (8 Tuners) + mirakc + EPGStation + KonomiTV.**

*Modernized & Bug-Fixed for 2026 standards by **PalliStack**.*

## ?뙚 Key Modernization Features (訝삠겒?얌빰?뽪찣??

### ?눐?눉 English
- **Refactored PT3 Driver:** Migrated to `dma_alloc_coherent` for high-speed, stable memory management.
- **IOMMU/DMAR Support:** Added `pci_alloc_irq_vectors` and explicit MSI mapping to resolve boot delays and DMAR faults on HP/Dell servers.
- **Modern Kernel Support:** Fully compatible with Linux Kernel 5.15+ (Ubuntu 22.04 LTS) and 6.x.
- **Multi-Card Bug Fix:** Resolved issues where `/dev/pt3video*` nodes were not created in multi-card environments.

### ?눓?눝 ?ζ쑍沃?- **?ゃ깢?▲궚?욍꺁?녈궛?뺛굦?욾T3?됥꺀?ㅳ깘:** 遙섌잆겎若됧츣?쀣걼?▲깴?ょ??녴겗?잆굙??dma_alloc_coherent`?며㎉烏뚣?- **?욁꺂?곥궖?쇈깋?먦궛岳??:** 筽뉑빊?싥겗?ャ꺖?됬뮥罌껁겎`/dev/pt3video*`?롢꺖?됥걣鵝쒏닇?뺛굦?ゃ걚?뤻죱?믦㎗黎뷩?n- **?겹깙?⒲깳?쇈궭 (`card_number`):** ?뉎깘?ㅳ궧?ㅳ꺍?뉎긿??궧??궕?뺛궩?껁깉?믤뎸?뺛겎?뉐츣?쇻굥艅잒꺗?믦옙?졼?- **DMA若됧츣?㎯겗?묇툓:** ?됥꺀?ㅳ깘??꺖?됪셽??깳?㏂꺁??뎴?뽳펷?뺛꺀?겹깳?녈깇?쇈궥?㎯꺍竊됥겓野얇걲?뗥츎若싨㎯굮凉룟뙑??
## ?룛截?Architecture Design (?㏂꺖??깇??긽?ｈÞ鼇?

```text
================================================================================
     [ LEGACY / ?㏛툟餓?]                       [ MODERN 2026 / 轝▽툟餓?]
================================================================================

   +--------------------------+             +--------------------------+
   |   Docker Compose V1      |    ----->   |   Docker Compose V2      |
   |  (docker-compose.yml)    |             |      (compose.yaml)      |
   +--------------------------+             +--------------------------+
               |                                         |
               v                                         v
   +--------------------------+             +--------------------------+
   |   Node.js 16 (LTS)       |    ----->   |   Node.js 24 (Latest)    |
   |   Vue 2.x (Old UI)       |             |   Vue 3.5 (Modern UI)    |
   |   Inversify (Heavy DI)   |             |   Pinia / TanStack Query |
   +--------------------------+             +--------------------------+
               |                                         |
               v                                         v
   +--------------------------+             +--------------------------+
   |   MariaDB 10.x           |    ----->   |   MariaDB 11.4 (LTS)     |
   |   Basic Indexing         |             |   High-Perf UTF8MB4      |
   +--------------------------+             +--------------------------+
               |                                         |
               v                                         v
   +--------------------------+             +--------------------------+
   |   PT3_DVB Driver (Legacy)|             |   PT3_CHAR (Refactored)  |
   |   Legacy PCI Alloc       |    ----->   |   Modern DMA (Coherent)  |
   |   /dev/dvb/adapterX      |             |   /dev/pt3video0~7       |
   +--------------------------+             +--------------------------+

================================================================================
     "CLUTTERED & LEGACY"                      "STREAMLINED & OPTIMIZED"
================================================================================
```

## ?뫅?랅윂?Installation Recipe (?ㅳ꺍?밤깉?쇈꺂?с궥??

### 1截뤴깵 Install Dependencies (堊앭춼?㏘퓗??궎?녈궧?덀꺖??
```bash
sudo apt update
sudo apt install -y dkms linux-headers-$(uname -r) build-essential git
```

### 2截뤴깵 Clone and Build (??꺆?쇈꺍?ⓦ깛?ャ깋)
```bash
git clone https://github.com/PalliStack/pt3-modern-2026.git
cd pt3-modern-2026
make
```

### 3截뤴깵 Install and Load (?ㅳ꺍?밤깉?쇈꺂?ⓦ꺆?쇈깋)
```bash
sudo make install
sudo depmod -a
sudo modprobe pt3_drv
```

### 4截뤴깵 Verify (閻븃첀)
```bash
ls -l /dev/pt3video*
dmesg | grep PT3
```

## ?뵩 Troubleshooting (?덀꺀?뽧꺂?룔깷?쇈깇?ｃ꺍??

### DMA Allocation Failure (DMA?꿨퐪鸚길븮)
If the driver loads but not all tuners are visible (e.g., only 4 instead of 8), it is likely due to **contiguous memory fragmentation**.
- **Symptoms:** `dmesg` shows `fail allocate consistent`.
- **Solution:** Clear the kernel page cache to free up contiguous physical memory:
  ```bash
  sudo sync
  sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
  sudo modprobe -r pt3_drv
  sudo modprobe pt3_drv
  ```

## ?뱶 Acknowledgments
This project is a **modernized fork** of the original [m-tsudo/pt3](https://github.com/m-tsudo/pt3). 

*Maintained by **PalliStack** | 2026 Engineering Archive*
