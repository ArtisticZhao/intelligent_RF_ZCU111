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
#include "xparameters.h"
#include "xscugic.h"
#include "xil_exception.h"

#include "xbram_hw.h"
#include "axi_bpsk_ctrl.h"

///    ÷–∂œœ‡πÿ---------------------------------
#define INT_CFG0_OFFSET			0x00000C00
#define RAM1_DONE_INT_ID        121
#define RAM2_DONE_INT_ID        122
#define INTC_DEVICE_ID 			XPAR_SCUGIC_0_DEVICE_ID
#define INT_TYPE_RISING_EDGE    0x03
#define INT_TYPE_HIGHLEVEL      0x01
#define INT_TYPE_MASK           0x03

static XScuGic INTCInst;

static int Intc_Init(u16 DeviceId);
static void BPSK_tx_done_intr_Handler(void *param);
void IntcTypeSetup(XScuGic *InstancePtr, int intId, int intType);

// bram ---------------------------------
u32 const empty_frame[] = {
		0x1acffc1d, 0xff480ec0, 0x9a0d70bc, 0x8e2c93ad, 0xa7b746ce, 0x5a977dcc, 0x32a2bf3e, 0x0a10f188,
		0x94cdeab1, 0xfe901d81, 0x341ae179, 0x1c59275b, 0x4f6e8d9c, 0xb52efb98, 0x65457e7c, 0x1421e311,
		0x299bd563, 0xfd203b02, 0x6835c2f2, 0x38b24eb6, 0x9edd1b39, 0x6a5df730, 0xca8afcf8, 0x2843c622,
		0x5337aac7, 0xfa407604, 0xd06b85e4, 0x71649d6d, 0x3dba3672, 0xd4bbee61, 0x9515f9f0, 0x50878c44,
		0xa66f558f, 0xf480ec09, 0xa0d70bc8, 0xe2c93ada, 0x7b746ce5, 0xa977dcc3
};
u32 data=0x00000001;
int wr_cnt=0;
int main()
{
    init_platform();

    print("Hello World\n\r");



	for(int i=0; i<38*4; i+=4){
		XBram_WriteReg(XPAR_BRAM_0_BASEADDR,i,empty_frame[wr_cnt]) ;
		wr_cnt++;
	}
	print("BRAM0 write OK!\n\r");
	wr_cnt=0;

	for(int i=0; i<38*4; i+=4){
		if(wr_cnt!=0){
			XBram_WriteReg(XPAR_BRAM_0_BASEADDR + 0x100,i,empty_frame[wr_cnt]^data) ;
		}else{
			XBram_WriteReg(XPAR_BRAM_0_BASEADDR + 0x100,i,empty_frame[wr_cnt]) ;
		}
		wr_cnt++;
	}
	print("BRAM1 write OK!\n\r");

	wr_cnt=0;
	data++;
	for(int i=0; i<38*4; i+=4){
		if(wr_cnt!=0){
			XBram_WriteReg(XPAR_BRAM_0_BASEADDR + 0x200,i,empty_frame[wr_cnt]^data) ;
		}else{
			XBram_WriteReg(XPAR_BRAM_0_BASEADDR + 0x200,i,empty_frame[wr_cnt]) ;
		}
		wr_cnt++;
	}
	print("BRAM2 write OK!\n\r");

	Intc_Init(INTC_DEVICE_ID);
	print("Configuring interrupt OK!\n\r");

	AXI_BPSK_CTRL_mWriteReg(XPAR_AXI_BPSK_CTRL_0_S00_AXI_BASEADDR, AXI_BPSK_CTRL_S00_AXI_SLV_REG0_OFFSET, 0x00000001);
	print("Sending empty!\n\r");
	sleep(5);
	AXI_BPSK_CTRL_mWriteReg(XPAR_AXI_BPSK_CTRL_0_S00_AXI_BASEADDR, AXI_BPSK_CTRL_S00_AXI_SLV_REG1_OFFSET, 0x00000001);
	print("starting send ram1!\n\r");
    while(1);
    cleanup_platform();
    return 0;
}

int Intc_Init(u16 DeviceId)
{
    XScuGic_Config *IntcConfig;
    int status;

    // Interrupt controller initialisation
    IntcConfig = XScuGic_LookupConfig(DeviceId);
    status = XScuGic_CfgInitialize(&INTCInst, IntcConfig, IntcConfig->CpuBaseAddress);
    if(status != XST_SUCCESS) return XST_FAILURE;

    // Call to interrupt setup
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
                                 (Xil_ExceptionHandler)XScuGic_InterruptHandler,
                                 &INTCInst);
    Xil_ExceptionEnable();

    // Connect SW1~SW3 interrupt to handler
    status = XScuGic_Connect(&INTCInst,
    						 RAM1_DONE_INT_ID,
                             (Xil_ExceptionHandler)BPSK_tx_done_intr_Handler,
                             (void *)1);
    if(status != XST_SUCCESS) return XST_FAILURE;

    status = XScuGic_Connect(&INTCInst,
    						 RAM2_DONE_INT_ID,
                             (Xil_ExceptionHandler)BPSK_tx_done_intr_Handler,
                             (void *)2);
    if(status != XST_SUCCESS) return XST_FAILURE;


    if(status != XST_SUCCESS) return XST_FAILURE;

    // Set interrupt type of SW1~SW2 to rising edge
    IntcTypeSetup(&INTCInst, RAM1_DONE_INT_ID, INT_TYPE_RISING_EDGE);
    IntcTypeSetup(&INTCInst, RAM2_DONE_INT_ID, INT_TYPE_RISING_EDGE);

    // Enable SW1~SW2 interrupts in the controller
    XScuGic_Enable(&INTCInst, RAM1_DONE_INT_ID);
    XScuGic_Enable(&INTCInst, RAM2_DONE_INT_ID);


    return XST_SUCCESS;
}

void IntcTypeSetup(XScuGic *InstancePtr, int intId, int intType)
{
    int mask;

    intType &= INT_TYPE_MASK;
    mask = XScuGic_DistReadReg(InstancePtr, INT_CFG0_OFFSET + (intId/16)*4);
    mask &= ~(INT_TYPE_MASK << (intId%16)*2);
    mask |= intType << ((intId%16)*2);
    XScuGic_DistWriteReg(InstancePtr, INT_CFG0_OFFSET + (intId/16)*4, mask);
}

static void BPSK_tx_done_intr_Handler(void *param)
{
    int sw_id = (int)param;
    if(sw_id==1){
    	AXI_BPSK_CTRL_mWriteReg(XPAR_AXI_BPSK_CTRL_0_S00_AXI_BASEADDR, AXI_BPSK_CTRL_S00_AXI_SLV_REG1_OFFSET, 0x00000000);
    	wr_cnt=0;
    	data++;
		for(int i=0; i<38*4; i+=4){
			if(wr_cnt!=0){
				XBram_WriteReg(XPAR_BRAM_0_BASEADDR + 0x200,i,empty_frame[wr_cnt]^data) ;
			}else{
				XBram_WriteReg(XPAR_BRAM_0_BASEADDR + 0x200,i,empty_frame[wr_cnt]) ;
			}
			wr_cnt++;
		}
    	AXI_BPSK_CTRL_mWriteReg(XPAR_AXI_BPSK_CTRL_0_S00_AXI_BASEADDR, AXI_BPSK_CTRL_S00_AXI_SLV_REG2_OFFSET, 0x00000001);
    }else{
    	AXI_BPSK_CTRL_mWriteReg(XPAR_AXI_BPSK_CTRL_0_S00_AXI_BASEADDR, AXI_BPSK_CTRL_S00_AXI_SLV_REG2_OFFSET, 0x00000000);
    	wr_cnt=0;
    	data++;
    	for(int i=0; i<38*4; i+=4){
			if(wr_cnt!=0){
				XBram_WriteReg(XPAR_BRAM_0_BASEADDR + 0x100,i,empty_frame[wr_cnt]^data) ;
			}else{
				XBram_WriteReg(XPAR_BRAM_0_BASEADDR + 0x100,i,empty_frame[wr_cnt]) ;
			}
			wr_cnt++;
		}
		AXI_BPSK_CTRL_mWriteReg(XPAR_AXI_BPSK_CTRL_0_S00_AXI_BASEADDR, AXI_BPSK_CTRL_S00_AXI_SLV_REG1_OFFSET, 0x00000001);
    }
    printf("RAM%d tx done!\n\r", sw_id);
}
