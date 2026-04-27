/*******************************************************************************
   earthsoft PT3 Linux driver

   This program is free software; you can redistribute it and/or modify it
   under the terms and conditions of the GNU General Public License,
   version 3, as published by the Free Software Foundation.

   This program is distributed in the hope it will be useful, but WITHOUT
   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
   more details.

   The full GNU General Public License is included in this distribution in
   the file called "COPYING".

 *******************************************************************************/

#ifndef		__PT3_PCI_H__
#define		__PT3_PCI_H__

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)
void * pt3_vzalloc(unsigned long size);
#else
#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,2,0)
#include <linux/vmalloc.h>
#endif
#define pt3_vzalloc vzalloc
#endif

extern int debug;

#define PT3_PRINTK(dev, verbose, level, fmt, args...) \
	do { \
		if (verbose <= debug) { \
			if (dev) { \
				dev_printk(level, dev, "PT3: " fmt, ##args); \
			} else { \
				printk(level "PT3: " fmt, ##args); \
			} \
		} \
	} while (0)

static inline int pt3_copy_from_user(void *to, const void __user *from, unsigned long n)
{
#if LINUX_VERSION_CODE < KERNEL_VERSION(5,0,0)
	if (unlikely(!access_ok(VERIFY_READ, from, n)))
#else
	if (unlikely(!access_ok(from, n)))
#endif
		return -EFAULT;
	return copy_from_user(to, from, n);
}

static inline int pt3_copy_to_user(void __user *to, const void *from, unsigned long n)
{
#if LINUX_VERSION_CODE < KERNEL_VERSION(5,0,0)
	if (unlikely(!access_ok(VERIFY_WRITE, to, n)))
#else
	if (unlikely(!access_ok(to, n)))
#endif
		return -EFAULT;
	return copy_to_user(to, from, n);
}

#define REGS_VERSION	0x00	/*	R		Version */
#define REGS_BUS		0x04	/*	R		Bus */
#define REGS_SYSTEM_W	0x08	/*	W		System */
#define REGS_SYSTEM_R	0x0c	/*	R		System */
#define REGS_I2C_W		0x10	/*	W		I2C */
#define REGS_I2C_R		0x14	/*	R		I2C */
#define REGS_RAM_W		0x18	/*	W		RAM */
#define REGS_RAM_R		0x1c	/*	R		RAM */
#define REGS_DMA_DESC_L	0x40	/* + 0x18*	W		DMA */
#define REGS_DMA_DESC_H	0x44	/* + 0x18*	W		DMA */
#define REGS_DMA_CTL	0x48	/* + 0x18*	W		DMA */
#define REGS_TS_CTL		0x4c	/* + 0x18*	W		TS */
#define REGS_STATUS		0x50	/* + 0x18*	R		DMA / FIFO / TS */
#define REGS_TS_ERR		0x54	/* + 0x18*	R		TS */

#endif
