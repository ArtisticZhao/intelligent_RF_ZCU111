/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xbram_hw.h"
#include "xgpio.h"

#define AXI_GPIO_DEV_ID                  XPAR_AXI_GPIO_0_DEVICE_ID
#define GPIO_CHANNEL       1

XGpio            axi_gpio_inst;                 //PL 端 AXI GPIO 驱动实例

u32 const empty_frame[] = {
		0x1acffc1d, 0xff480ec0, 0x9a0d70bc, 0x8e2c93ad, 0xa7b746ce, 0x5a977dcc, 0x32a2bf3e, 0x0a10f188,
		0x94cdeab1, 0xfe901d81, 0x341ae179, 0x1c59275b, 0x4f6e8d9c, 0xb52efb98, 0x65457e7c, 0x1421e311,
		0x299bd563, 0xfd203b02, 0x6835c2f2, 0x38b24eb6, 0x9edd1b39, 0x6a5df730, 0xca8afcf8, 0x2843c622,
		0x5337aac7, 0xfa407604, 0xd06b85e4, 0x71649d6d, 0x3dba3672, 0xd4bbee61, 0x9515f9f0, 0x50878c44,
		0xa66f558f, 0xf480ec09, 0xa0d70bc8, 0xe2c93ada, 0x7b746ce5, 0xa977dcc3
};
int main()
{
    init_platform();
    int wr_cnt=0;
    print("Hello World\n\r");
    for(int i=0; i<38*4; i+=4){
    	XBram_WriteReg(XPAR_BRAM_0_BASEADDR,i,empty_frame[wr_cnt]) ;
    	wr_cnt++;
    }
    print("BRAM write OK!\n\r");
    u32 data;
    for(int i=0; i<38*4; i+=4){
		data = XBram_ReadReg(XPAR_BRAM_0_BASEADDR,i) ;
		printf("%d: %x\n\r", i/4, data);
	}
    // AXI GPIO
    int Status;
    Status = XGpio_Initialize(&axi_gpio_inst, XPAR_AXI_GPIO_0_DEVICE_ID);
	if (Status != XST_SUCCESS)  {
	  xil_printf("Gpio Initialization Failed\r\n");
	  return XST_FAILURE;
	}
	/*  设置gpio的信号方向，设置0为输出，设置1为输入.*/
	XGpio_SetDataDirection(&axi_gpio_inst, GPIO_CHANNEL, 0);
	XGpio_DiscreteWrite(&axi_gpio_inst, GPIO_CHANNEL, 0x1);   // 使能send signal
    while(1);
    cleanup_platform();
    return 0;
}
