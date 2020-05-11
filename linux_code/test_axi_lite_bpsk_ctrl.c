/*
 * Copyright (c) 2012 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 * 在这里其实没怎么搞懂Linux驱动是怎么回事, 可以通过devmem对AXI总线进行读写,
 * 参考着devmem的源码, 写下这一小段code.
 * 由于bpsk发射的工作需要中断配合, 接下来我会测试Linux下的中断使用.
 * https://fpga.org/2013/05/28/how-to-design-and-access-a-memory-mapped-device-part-two/
 * 上面这篇文章似乎包含了代码的全部细节.
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>

#define BPSK_CTRL_BASE_ADDRESS     0x00a0001000
#define BRAM_BASE_ADDRESS     	   0x00a0000000

uint32_t const empty_frame[] = {
		0x1acffc1d, 0xff480ec0, 0x9a0d70bc, 0x8e2c93ad, 0xa7b746ce, 0x5a977dcc, 0x32a2bf3e, 0x0a10f188,
		0x94cdeab1, 0xfe901d81, 0x341ae179, 0x1c59275b, 0x4f6e8d9c, 0xb52efb98, 0x65457e7c, 0x1421e311,
		0x299bd563, 0xfd203b02, 0x6835c2f2, 0x38b24eb6, 0x9edd1b39, 0x6a5df730, 0xca8afcf8, 0x2843c622,
		0x5337aac7, 0xfa407604, 0xd06b85e4, 0x71649d6d, 0x3dba3672, 0xd4bbee61, 0x9515f9f0, 0x50878c44,
		0xa66f558f, 0xf480ec09, 0xa0d70bc8, 0xe2c93ada, 0x7b746ce5, 0xa977dcc3
};

int main()
{
	void *bpsk_map_base, *bpsk_virt_addr;
	off_t bpsk_target;
	void *bram_map_base, *bram_virt_addr;
	off_t bram_target;

	unsigned page_size, mapped_size, offset_in_page;
	int fd;
	unsigned width = 8 * sizeof(int);

	bpsk_target = BPSK_CTRL_BASE_ADDRESS;
	bram_target = BRAM_BASE_ADDRESS;
	width = 32;
	fd = open("/dev/mem", O_RDWR | O_SYNC);
	// map bpsk
	mapped_size = page_size = getpagesize();
	offset_in_page = (unsigned)bpsk_target & (page_size - 1);
	if (offset_in_page + width > page_size) {
		/* This access spans pages.
		 * Must map two pages to make it possible: */
		mapped_size *= 2;
	}
	bpsk_map_base = mmap(NULL,
				mapped_size,
				(PROT_READ | PROT_WRITE),
				MAP_SHARED,
				fd,
				bpsk_target & ~(off_t)(page_size - 1));
	if (bpsk_map_base == MAP_FAILED)
		printf("failed to mmap bpsk\n");
	else
		printf("OK to mmap bpsk\n");

	bpsk_virt_addr = (char*)bpsk_map_base + offset_in_page;

	// map bram
	mapped_size = page_size = getpagesize();
	offset_in_page = (unsigned)bram_target & (page_size - 1);
	if (offset_in_page + width > page_size) {
		/* This access spans pages.
		 * Must map two pages to make it possible: */
		mapped_size *= 2;
	}
	bram_map_base = mmap(NULL,
				mapped_size,
				(PROT_READ | PROT_WRITE),
				MAP_SHARED,
				fd,
				bram_target & ~(off_t)(page_size - 1));
	if (bram_map_base == MAP_FAILED)
		printf("failed to mmap bram\n");
	else
		printf("OK to mmap bram\n");

	bram_virt_addr = (char*)bram_map_base + offset_in_page;

	// write empty frame
	int wr_cnt = 0;
	for(int i=0; i<38*4; i+=4){
		*(volatile uint32_t*)(bram_virt_addr + i) = empty_frame[wr_cnt];
		wr_cnt++;
	}
	printf("bram init ok!\n");
	*(volatile uint32_t*)(bpsk_virt_addr) = 0x01;  // start send
	sleep(300);
	close(fd);
    printf("Hello World\n");

    return 0;
}
