# 🚀 Project: PT3-Modern-Pack-2026

**Integrating Ubuntu 22.04 + Dual PT3 Cards (8 Tuners) + mirakc + EPGStation + KonomiTV.**

*Modernized for 2026 standards by **PalliStack**.*

## 🌟 Key Modernization Features (主な現代化機能)

### 🇬🇧 English
- **Refactored PT3 Driver:** Migrated to `dma_alloc_coherent` for high-speed, stable memory management.
- **Kernel 6.x Support:** Fully compatible with latest Ubuntu 22.04/24.04 kernels.
- **Structured Logging:** Switched from `printk` to `dev_info` for easier multi-device debugging.
- **Secure IOCTL:** Implemented `access_ok` checks for hardened kernel-user communication.

### 🇯🇵 日本語
- **リファクタリングされたPT3ドライバ:** 高速で安定したメモリ管理のために`dma_alloc_coherent`へ移行。
- **カーネル 6.x 対応:** 最新のUbuntu 22.04/24.04カーネルと完全な互換性を確保。\n- **構造化ロギング:** 複数デバイスのデバッグを容易にするため、`printk`から`dev_info`へ刷新。
- **セキュアIOCTL:** カーネル・ユーザー間の通信保護のため、`access_ok`チェックを実装。

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
ls -l /dev/pt3video*
dmesg | grep PT3
```

## 🛠️ Bug Fixes & Improvements (バグ修正と改善)

- **Fixed Device Node Creation:** Resolved issues where `/dev/pt3video*` nodes were not automatically created in multi-card environments.
- **Added `card_number` Parameter:** Enabled manual indexing offset for flexible device management.
- **Robust Resource Cleanup:** Fixed a logic bug that prevented cleaning up device slots upon failed hardware probes.
- **Improved DMA Stability:** Optimized buffer allocation logic to better handle contiguous memory fragmentation.

## 📜 Acknowledgments
This project is a **modernized fork** of the original [m-tsudo/pt3](https://github.com/m-tsudo/pt3). 

*Maintained by **PalliStack** | 2026 Engineering Archive*
