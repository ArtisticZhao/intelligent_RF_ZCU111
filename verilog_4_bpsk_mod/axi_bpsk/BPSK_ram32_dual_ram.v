module BAUD_GEN
#(
	parameter BAUD_RATE = 16'd9600,
	parameter FLL_CNTL_PARAM = 24'd1280000,
	parameter FLL_CNTL_FREQ = 16'd100,
	parameter BAUD_INITIAL = 24'd96
)
(
	input wire clk,
	input wire nrst,
	output reg cntl_clk_out
);

localparam MAX_VCO_CNT = 24'sd65536;
localparam MIN_VCO_CNT = 24'sd16;
wire[23:0] baud_cnt_ref;
assign baud_cnt_ref = BAUD_RATE/FLL_CNTL_FREQ;

reg[23:0] baud_vco;
reg[23:0] baud_vco_cnt_loc;
always @(posedge clk)
if(!nrst) begin
	baud_vco_cnt_loc <= 24'h0;
end
else begin
	if(baud_vco_cnt_loc < FLL_CNTL_PARAM) begin
		baud_vco_cnt_loc <= baud_vco_cnt_loc + baud_vco;
		cntl_clk_out <= 1'b0;
	end
	else begin
		baud_vco_cnt_loc <= baud_vco_cnt_loc - FLL_CNTL_PARAM;
		cntl_clk_out <= 1'b1;
	end
end
reg[23:0] baud_counter;
reg[23:0] clk_counter;
reg signed[23:0] baud_err;
wire cntl_flag;
assign cntl_flag = (clk_counter==FLL_CNTL_PARAM);

always @(posedge clk)
if(!nrst) begin
	baud_counter <= 24'b0;
	clk_counter <= 24'b1;
	baud_err <= 24'sd0;
end
else begin
	clk_counter <= clk_counter + 24'h1;
	if(cntl_clk_out) begin
		baud_counter<= baud_counter + 24'h1;
	end
	if(clk_counter == FLL_CNTL_PARAM)
	begin
		baud_err <= $signed(baud_cnt_ref) - $signed(baud_counter);
		baud_counter <= 24'b0;
		clk_counter <= 24'b0;
	end
end
wire signed[23:0] baud_err_k,baud_vco_temp;
assign baud_err_k = (baud_err >>> 'd1)+(baud_err >>> 'd2);
assign baud_vco_temp = $signed(baud_vco) +baud_err_k;
always @(posedge clk)
if(!nrst) begin
	baud_vco <= BAUD_INITIAL;
end
else begin
	if(cntl_flag) begin
		if(baud_vco_temp >= MAX_VCO_CNT) baud_vco <= $unsigned(MAX_VCO_CNT);
		else if(baud_vco_temp <= MIN_VCO_CNT) baud_vco <= $unsigned(MIN_VCO_CNT);
		else baud_vco <= $unsigned(baud_vco_temp);
	end
end
endmodule

module BITSTREAM_GEN #(
    parameter integer data_width = 32
)
(
	input wire clk,
	input wire nrst,
	input wire[data_width-1:0] byte_in,
	input wire byte_latch,
	input wire en,
	output reg bit_out,
	output reg is_empty
);
reg[data_width-1:0] byte_buffer1,byte_buffer2;
reg[data_width-1:0] idx_cnt;
reg ping_pong;
always @(posedge clk)
if(!nrst) begin
	idx_cnt <= 8'd0;
	byte_buffer1 <= 32'd0;
	byte_buffer2 <= 32'd0;
	ping_pong <= 1'b0;
	bit_out <= 1'b0;
	is_empty <= 1'b1;
end
else begin
	if(byte_latch) begin
		if(ping_pong) byte_buffer1 <= byte_in;
		else byte_buffer2 <= byte_in;
	end
	if(en) begin
		if(idx_cnt != 8'd0) begin
			idx_cnt <= idx_cnt - 8'd1;
			is_empty <= 1'b0;
		end
		else begin
			ping_pong <= ~ping_pong;
			is_empty <= 1'b1;
			idx_cnt <= 8'd31;
		end
		bit_out <= (ping_pong)?byte_buffer2[idx_cnt]:byte_buffer1[idx_cnt];
	end 
	
end
endmodule 

module BPSK_Ctrl
#(
           parameter integer data_width = 32,
           parameter integer frame_length = 38,
           parameter integer addr_width = 32,
           parameter integer ref_clk_freq = 128000000,
           parameter integer baudrate = 9600
)
(
           input                            clk        , //ʱ���ź�
           input                            rst_n      , //��λ�ź�
           input                            power_on, //��=1ʱ����������, �����֡

           // RAM�˿�
           output                           ram_clk    , //RAMʱ��
           input        [data_width-1 : 0]  ram_rd_data, //RAM�ж���������
           output  wire                     ram_en     , //RAMʹ���ź�
           output  reg  [addr_width-1 : 0]  ram_addr   , //RAM��ַ
           
           output  reg  [3:0]               ram_we     , //RAM��д�����ź� 1д 0��
           output  reg  [data_width-1 : 0]  ram_wr_data, //RAMд����
           output  reg                      ram_rst    , //RAM��λ�ź�,�ߵ�ƽ��Ч

		   // ˫�������  �����˫���� ��ʵ������4Kram�Ŀռ�, �����Ϊ���� 0~148Ϊ��֡   256~404Ϊram1  512~660Ϊram2
		   input [1:0]                      dual_ram_num    , //01b=ʹ��ram1���� 10b=ʹ��ram2���� 00b=��֡����ram0
		   output [1:0]						interrupt_num ,   // 01b=ʹ��ram1���� 10b=ʹ��ram2���� 
           // phase ctrl
           output reg                       gen_en     ,
           output reg                       phase_ctrl ,
           output reg                       baud
	
);
localparam EMPTY_FRAME_BASEADDR = 32'h0;
localparam RAM1_BASEADDR = 32'h100;
localparam RAM2_BASEADDR = 32'h200;

wire bit_signal;
wire clk_baud;
reg ram_latch_enable;
reg [data_width-1:0] data;
BAUD_GEN baud_inst
(
	.clk(clk),
	.nrst(rst_n),
	.cntl_clk_out(clk_baud)
);
// ���ｫ����һ��4800k���ź�, ��������
always @ (posedge clk) begin
    if(!rst_n)
        baud <= 1'd0;
    else
    if (clk_baud)
        baud <= ~baud;
end
BITSTREAM_GEN #(
    .data_width(data_width)
) bitstream_inst
(
	.clk(clk),
	.nrst(rst_n),
	.byte_in(data),
	.byte_latch(ram_latch_enable),
	.is_empty(ram_en),
	.en(clk_baud & power_on),
	.bit_out(bit_signal)
);

assign ram_clk = clk;
reg ram_en_legacy;
always @ (posedge clk) begin
    if (!rst_n) begin
        data <= 32'h0;
        ram_addr <= 32'd0;
        ram_we <= 4'd0;
        ram_wr_data <= 32'd0;
        ram_rst <= 1'b0;
    end
    else begin
		ram_en_legacy <= ram_en;
    	if(!ram_en_legacy & ram_en) ram_latch_enable <= 1'b1;
		else ram_latch_enable <= 1'b0;
		
		if(ram_latch_enable) begin
			if (ram_addr == 32'd152-32'd4 || ram_addr == RAM1_BASEADDR+32'd152-32'd4 || ram_addr == RAM2_BASEADDR+32'd152-32'd4) begin
				case(dual_ram_num) //01b=ʹ��ram1���� 10b=ʹ��ram2���� 00b=��֡����ram0
					2'b00:
						ram_addr <= EMPTY_FRAME_BASEADDR; 
					2'b01:
						ram_addr <= RAM1_BASEADDR;
					2'b10:
						ram_addr <= RAM2_BASEADDR;
					default:
						ram_addr <= EMPTY_FRAME_BASEADDR;
				endcase
			end
    		else ram_addr <= ram_addr + 32'd4;  // ������Ȼ��32λһ����, ����Ѱַ����8bit��!!
		end
		data <= ram_rd_data;
    end
end

// �����ж��ź�, ����ж��źŻ����һ������֡�ĳ���, ������źŽ���ʱ(�½���)ʱʵ�ʵ����ݻ�û�з������,�������ʱ���л�ram��ַ��û�������.
wire interrupt_ram1;
wire interrupt_ram2;
assign interrupt_ram1 = (ram_addr == RAM1_BASEADDR+32'd152-32'd4) && power_on;
assign interrupt_ram2 = (ram_addr == RAM2_BASEADDR+32'd152-32'd4) && power_on;
assign interrupt_num = {interrupt_ram2, interrupt_ram1};

always @(posedge clk)
if(!rst_n) begin
	phase_ctrl <= 1'b0;
end
else begin
	if(bit_signal & clk_baud) phase_ctrl <= ~phase_ctrl;
	gen_en <= power_on;
end
endmodule
