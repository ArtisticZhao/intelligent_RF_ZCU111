
`timescale 1 ns / 1 ps

	module axi_bpsk_ctrl_v1_0 #
	(
		// Users to add parameters here
        parameter integer data_width   = 32,
        parameter integer frame_length = 38,
        parameter integer addr_width   = 32,
        parameter integer ref_clk_freq = 128000000,
        parameter integer baudrate     = 9600,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
        input   wire                     clk          , //时钟信号
        input   wire                     rst_n        , //复位信号
        output  wire                     ram_clk      , //RAM时钟
        input   wire [data_width-1 : 0]  ram_rd_data  , //RAM中读出的数据
        output  wire                     ram_en       , //RAM使能信号
        output  wire [addr_width-1 : 0]  ram_addr     , //RAM地址
        output  wire [3:0]               ram_we       , //RAM读写控制信号 1写 0读
        output  wire [data_width-1 : 0]  ram_wr_data  , //RAM写数据
        output  wire                     ram_rst       , //RAM复位信号,高电平有效
        output  wire [1:0]				 interrupt_num ,   // 01b=使用ram1发射 10b=使用ram2发射 
        output  wire                     gen_en        ,
        output  wire                     phase_ctrl    ,
        output  wire                     baud          ,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
// Instantiation of Axi Bus Interface S00_AXI
	axi_bpsk_ctrl_v1_0_S00_AXI # ( 
        .data_width   (data_width  ),
        .frame_length (frame_length),
        .addr_width   (addr_width  ),
        .ref_clk_freq (ref_clk_freq),
        .baudrate     (baudrate    ),
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) axi_bpsk_ctrl_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),
		.clk          (clk          ), 
		.rst_n        (rst_n        ), 
		.ram_clk      (ram_clk      ), 
		.ram_rd_data  (ram_rd_data  ), 
		.ram_en       (ram_en       ), 
		.ram_addr     (ram_addr     ), 
		.ram_we       (ram_we       ), 
		.ram_wr_data  (ram_wr_data  ), 
		.ram_rst      (ram_rst      ),
		.interrupt_num(interrupt_num),   
		.gen_en       (gen_en       ),
		.phase_ctrl   (phase_ctrl   ),
		.baud         (baud         )
	);

	// Add user logic here

	// User logic ends

	endmodule
