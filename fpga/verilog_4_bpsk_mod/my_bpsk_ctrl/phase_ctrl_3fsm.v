module Phase_Ctrl_2 #(
           parameter integer data_width = 8,
           parameter integer frame_length = 150,
           parameter integer addr_width = 8,
           parameter integer ref_clk_freq = 128000000,
           parameter integer baudrate = 9600
       )(
           input                            clk        , //时钟信号
           input                            rst_n      , //复位信号
           // send 启动信号
           input                            send_signal,
           // phase ctrl
           output                           gen_en     ,
           output reg                       phase_ctrl ,
           // RAM端口
           output                           ram_clk    , //RAM时钟
           input        [data_width-1 : 0]  ram_rd_data, //RAM中读出的数据
           output  reg                      ram_en     , //RAM使能信号
           output  reg  [addr_width-1 : 0]  ram_addr   , //RAM地址
           output  reg  [0:0]               ram_we     , //RAM读写控制信号 1写 0读
           output  reg  [data_width-1 : 0]  ram_wr_data, //RAM写数据
           output                           ram_rst      //RAM复位信号,高电平有效
       );

//calculates the clock cycle for baud rate
localparam                       CYCLE = ref_clk_freq / baudrate;
//state machine code
localparam                       S_IDLE       = 1;
localparam                       S_LOAD_DATA  = 2;
localparam                       S_SEND_CTRL  = 3;
localparam                       S_SEND_WAIT  = 4;

reg[2:0]                         current_state;
reg[2:0]                         next_state;
reg[2:0]                         bit_cnt;//bit counter
reg[15:0]                        cycle_cnt; //baud counter

reg [7:0]                        init_cnt;

// ---------------------- 三段式状态机 -------------------
// #1
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        current_state <= S_IDLE;
    else 
        current_state <= next_state;
end 
// #2
always @(*) begin
    next_state = S_IDLE;
    case (current_state)
        S_IDLE: 
            if(send_signal == 1'd1)
                next_state <= S_SEND_CTRL;
            else
                next_state <= S_IDLE;
        S_LOAD_DATA:
            if(send_signal == 1'd1)
                next_state <= S_SEND_WAIT;
            else
                next_state <= S_IDLE;
        S_SEND_CTRL:
            if(send_signal == 1'd1)
                next_state <= S_SEND_WAIT;
            else
                next_state <= S_IDLE;

        S_SEND_WAIT:
            if (cycle_cnt == CYCLE)
                    next_state <= S_SEND_CTRL;
                else if (cycle_cnt == CYCLE-3 && bit_cnt == 3'd0)
                    next_state <= S_LOAD_DATA;
                else 
                    next_state <= S_SEND_WAIT;
    endcase
end
//  地址计数器
reg [data_width-1 : 0]  data;  // 将要发送的数据
assign  ram_rst = 1'b0;
assign  ram_clk= clk;
always @(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        data <= 8'h0;
        ram_en <= 1'b0;
        ram_addr <= 8'd0;
        ram_we <= 4'd0;
        ram_en <= 1'b1;
    end else begin
        if (current_state == S_LOAD_DATA) begin
            data <= ram_rd_data;
            if (ram_addr == frame_length-1)
                ram_addr <= 8'd0 ;
            else
                ram_addr <= ram_addr + 8'd1;
        end else begin
            data <= data;
            ram_addr <= ram_addr;
        end
    end
end
//  位控制器
always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
    begin
        bit_cnt <= 3'd7;
    end
	else if(current_state == S_SEND_CTRL)
		bit_cnt <= bit_cnt - 3'd1;
	else
		bit_cnt <= bit_cnt;
end
wire baud;
assign baud = current_state == S_SEND_CTRL;
// 波特率发生器
always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        cycle_cnt <= 0;
    else if(current_state == S_IDLE)
        cycle_cnt <= 16'd0;
    else if(cycle_cnt != CYCLE)
        cycle_cnt <= cycle_cnt + 16'd1;
    else
        cycle_cnt <= 16'd0;
end
// 并转串
always@(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        phase_ctrl <= 1'b1;
    end else
        if(current_state == S_SEND_CTRL) begin
            // 这个IF实现 NRZM编码
            if (ram_rd_data[bit_cnt])  
                phase_ctrl <= ~phase_ctrl;
            else
                phase_ctrl <= phase_ctrl;
        end else begin
            phase_ctrl <= phase_ctrl;
        end
end
assign gen_en = current_state != S_IDLE;
endmodule
