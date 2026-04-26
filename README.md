# 🚀 PT3-Modern-Pack-2026

Modernized PT3 Character Driver for Linux Kernel 6.x+

```text
================================================================================
   PT3 MODERN 2026 ARCHITECTURE
================================================================================
[ USER SPACE ]       [ KERNEL SPACE (Modernized) ]       [ HARDWARE ]
      |                         |                             |
      |   pt3_copy_from_user    |      dma_alloc_coherent     |
 [ IOCTL ] ------------------> [ DRIVER CORE ] ------------> [ PT3 FPGA ]
      |    (access_ok check)    |    (DMA API v2.0)           |
      |                         |                             |
      |     PT3_PRINTK()        |                             |
      | <---------------------- [ LOGGING SUB ]               |
      |    (dev_info/err)       |                             |
================================================================================
```

## Features
- **DMA-coherent API migration**: Replaced legacy `pci_alloc_consistent` with `dma_alloc_coherent` for enhanced stability on modern kernels.
- **Structured device-based logging**: Integrated `dev_info`, `dev_err`, and `dev_dbg` for precise hardware-linked diagnostics.
- **IOCTL security reinforcement**: Implemented mandatory `access_ok()` checks for all user-space memory transfers.
- **Integrated Harness Engineering**: Includes automated deployment scripts for environment discovery and recursive build loops.

## Credits
Forked and modernized from [m-tsudo/pt3](https://github.com/m-tsudo/pt3). Special thanks to the original author for the foundational work.

## License
GPL v3.0 - See `COPYING` for details.
