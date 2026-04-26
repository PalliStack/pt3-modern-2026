# 🚀 Project: PT3-Modern-Pack-2026

**Integrating Ubuntu 22.04 + Dual PT3 Cards (8 Tuners) + mirakc + EPGStation + KonomiTV.**

*Modernized & Bug-Fixed for 2026 standards by **PalliStack**.*

## 🌟 Key Modernization Features (主な現代化機能)

### 🇬🇧 English
- **Refactored PT3 Driver:** Migrated to `dma_alloc_coherent` for high-speed, stable memory management.
- **IOMMU/DMAR Support:** Added `pci_alloc_irq_vectors` and explicit MSI mapping to resolve boot delays and DMAR faults on HP/Dell servers.
- **Modern Kernel Support:** Fully compatible with Linux Kernel 5.15+ (Ubuntu 22.04 LTS) and 6.x.
- **Multi-Card Bug Fix:** Resolved issues where `/dev/pt3video*` nodes were not created in multi-card environments.
- **New Parameter (`card_number`):** Added support for manual device index offsets.
- **DMA Stability:** Enhanced logic to handle memory fragmentation during driver load.

### 🇯🇵 日本語
- **リファクタリングされたPT3ドライバ:** 高速で安定したメモリ管理のために`dma_alloc_coherent`へ移行。
- **IOMMU/DMAR対応:** `pci_alloc_irq_vectors`と明示的なMSIマッピングを追加し、HP/Dellサーバーでの起動遅延やDMARフォルトを解決。
- **最新カーネル対応:** Linux Kernel 5.15+ (Ubuntu 22.04 LTS) および 6.x に完全対応。
- **マルチカードバグ修正:** 複数枚のカード環境で`/dev/pt3video*`ノードが作成されない問題を解決。
- **新パラメータ (`card_number`):** デバイスインデックスのオフセットを手動で指定する機能を追加。
- **DMA安定性の向上:** ドライバロード時のメモリ断片化（フラグメンテーション）に対する安定性を強化。

## 🏗️ Architecture Design (アーキテクチャ設計)

```text
================================================================================
     [ LEGACY / 旧世代 ]                       [ MODERN 2026 / 次世代 ]
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

## 👨‍🍳 Installation Recipe (インストールレシピ)

### 1️⃣ Install Dependencies (依存関係のインストール)
```bash
sudo apt update
sudo apt install -y dkms linux-headers-$(uname -r) build-essential git
```

### 2️⃣ Clone and Build (クローンとビルド)
```bash
git clone https://github.com/PalliStack/pt3-modern-2026.git
cd pt3-modern-2026
make
```

### 3️⃣ Install and Load (インストールとロード)
```bash
sudo make install
sudo depmod -a
sudo modprobe pt3_drv
```

### 4️⃣ Verify (確認)
```bash
./harness.sh all
```

## 🔧 Troubleshooting (トラブルシューティング)

### DMA Allocation Failure (DMA割当失敗)
If the driver loads but not all tuners are visible (e.g., only 4 instead of 8), it is likely due to **contiguous physical memory fragmentation**.
- **Symptoms:** `dmesg` shows `fail dma_alloc_coherent`.
- **Solution:** Clear the kernel page cache to free up contiguous physical memory:
  ```bash
  sudo sync
  sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
  sudo modprobe -r pt3_drv
  sudo modprobe pt3_drv
  ```

## 📜 Acknowledgments
This project is a **modernized fork** of the original [m-tsudo/pt3](https://github.com/m-tsudo/pt3). 

*Maintained by **PalliStack** | 2026 Engineering Archive*
