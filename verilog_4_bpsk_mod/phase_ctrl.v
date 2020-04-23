
module Phase_Ctrl #(
           parameter integer data_width = 8,
           parameter integer frame_length = 150,
           parameter integer addr_width = 8,
           parameter integer ref_clk_freq = 100000000,
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
localparam                       S_FIRST_READ = 2; //start bit
localparam                       S_SEND_BYTE  = 3; //data bits
localparam                       S_SEND_READ  = 4; //stop bit

// state machine reg
reg[2:0]                         state;
reg[2:0]                         bit_cnt;//bit counter
reg[15:0]                        cycle_cnt; //baud counter
// 启动信号捕获与转换
reg          start_rd_d0;
reg          start_rd_d1;
wire         pos_start_rd;
assign pos_start_rd = ~start_rd_d1 & start_rd_d0;

//延时两拍，采start_rd信号的上升沿
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        start_rd_d0 <= 1'b0;
        start_rd_d1 <= 1'b0;
    end
    else begin
        start_rd_d0 <= send_signal;
        start_rd_d1 <= start_rd_d0;
    end
end
// ---------------------------状态机控制-------------------------------
always @(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        state <= S_IDLE;
    end else begin
        case (state)
            S_IDLE:
                if (send_signal) begin
                    state <= S_FIRST_READ;
                end else begin
                    state <= S_IDLE;
                end
            S_FIRST_READ:
                state <= S_SEND_BYTE;
            S_SEND_BYTE:
                if (bit_cnt == 7'd0)
                    if(ram_addr == frame_length)
                        state <= S_IDLE;
                    else
                        if (cycle_cnt == CYCLE - 1)
                            state <= S_SEND_READ;
                        else
                            state <= S_SEND_BYTE;
                else 
                    state <= S_SEND_BYTE;
                
            S_SEND_READ:
                state <= S_SEND_BYTE;
        endcase
    end
end
// --------------------------BRAM读取控制------------------------------
reg [data_width-1 : 0]  data;  // 将要发送的数据
assign  ram_rst = 1'b0;
assign  ram_clk= clk;
always @(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        data <= 8'hAA;
        ram_en <= 1'b0;
        ram_addr <= 8'd0;
        ram_we <= 4'd0;
        ram_en <= 1'b1;
    end else begin
        case (state)
            S_FIRST_READ: begin
//                data <= ram_rd_data;
                ram_addr <=  8'd0 ;
            end
            S_SEND_READ: begin
                data <= ram_rd_data;
                if (ram_addr == frame_length-1)
                    ram_addr <= 8'd0 ;
                else
                    ram_addr <= ram_addr + 8'd1 ;
            end
            S_IDLE:
                ram_addr <= 8'd0;
            default: begin
                data <= data;
                ram_addr <= ram_addr;
            end
        endcase
    end
end
// --------------------------串行相位控制信号控制------------------------
// 波特率发生器
wire baud;
assign baud=cycle_cnt == CYCLE;
always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        cycle_cnt <= 16'd0;
    else if(state != S_SEND_BYTE && state != S_SEND_READ)
        cycle_cnt <= 16'd0;
    else if(cycle_cnt != CYCLE)
        cycle_cnt <= cycle_cnt + 16'd1;
    else
        cycle_cnt <= 16'd0;
end
// 字节波特率控制器

always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
    begin
        bit_cnt <= 3'd7;
    end
    else if(state == S_SEND_BYTE || state == S_SEND_READ)
        if(cycle_cnt == CYCLE - 1)
            if (bit_cnt != 3'd0)
                bit_cnt <= bit_cnt - 3'd1;
            else
                bit_cnt <= 3'd7;
        else
            bit_cnt <= bit_cnt;
    else
        bit_cnt <= 3'd7;
end
// 相位控制信号控制
always@(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        phase_ctrl <= 1'b1;
    else
        if(state == S_SEND_BYTE)
            if (cycle_cnt == CYCLE - 1)
                if (data[bit_cnt])
                    phase_ctrl <= ~phase_ctrl;
                else
                    phase_ctrl <= phase_ctrl;
            else
                phase_ctrl <= phase_ctrl;
        else
            phase_ctrl <= phase_ctrl;
end
// 使能信号
assign gen_en = 1; // (state == S_SEND_BYTE || state == S_SEND_READ);
endmodule
