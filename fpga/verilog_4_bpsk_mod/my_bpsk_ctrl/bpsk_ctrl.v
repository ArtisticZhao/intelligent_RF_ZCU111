module BPSK_Ctrl #(
           parameter integer data_width = 8,
           parameter integer frame_length = 150,
           parameter integer addr_width = 8,
           parameter integer ref_clk_freq = 128000000,
           parameter integer baudrate = 9600
       )(
           input                            clk        , //时钟信号
           input                            rst_n      , //复位信号
           input                            send_signal, // send 启动信号

           // RAM端口
           output                           ram_clk    , //RAM时钟
           input        [data_width-1 : 0]  ram_rd_data, //RAM中读出的数据
           output  reg                      ram_en     , //RAM使能信号
           output  reg  [addr_width-1 : 0]  ram_addr   , //RAM地址
           output  reg  [0:0]               ram_we     , //RAM读写控制信号 1写 0读
           output  reg  [data_width-1 : 0]  ram_wr_data, //RAM写数据
           output                           ram_rst    , //RAM复位信号,高电平有效

           // phase ctrl
           output                           gen_en     ,
           output reg                       phase_ctrl 
       );
//calculates the clock cycle for baud rate
localparam                       CYCLE = ref_clk_freq / baudrate;
//state machine code
localparam      [2:0]            S_IDLE       = 4'b000,
                                 S_READ_DATA  = 4'b001,
                                 S_CTRL_TOGGLE= 4'b010,
                                 S_SEND_WAIT  = 4'b100;

reg [2:0]  current_state;
reg [2:0]  next_state;

reg [1:0] read_count;
reg toggle_count;
reg [2:0]                         bit_cnt;//bit counter
reg [15:0]                        cycle_cnt; //baud counter

// 一段 同步状态转移
always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) 
        current_state <= S_IDLE;
    else 
        current_state <= next_state;
end

// 二段 组合状态
always @ (*) begin
    next_state = S_IDLE;
    case (current_state) 
        S_IDLE:
            if (send_signal) 
                next_state = S_READ_DATA;
            else 
                next_state = S_IDLE;
        S_READ_DATA:
            if (read_count == 2'd2)
                next_state = S_CTRL_TOGGLE;
            else
                next_state = S_READ_DATA;
        S_CTRL_TOGGLE:
            if (toggle_count == 1'd1)
                next_state = S_SEND_WAIT;
            else
                next_state = S_CTRL_TOGGLE;
        S_SEND_WAIT:
            if (cycle_cnt == CYCLE)
                next_state = S_CTRL_TOGGLE;
            else if (cycle_cnt == CYCLE-3 && bit_cnt == 3'd0)
                next_state = S_READ_DATA;
            else 
                next_state = S_SEND_WAIT;
        default:
            next_state = S_IDLE;
    endcase
end

// 三段 业务逻辑
reg [7:0] data;
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 8'h0;
        ram_en <= 1'b0;
        ram_addr <= 8'd0;
        ram_we <= 4'd0;
        ram_en <= 1'b1;
        read_count <= 2'd0;
    end
    else if (current_state == S_READ_DATA) begin
        if (read_count > 2'd2)
            read_count <= 2'd0;
        else begin
            if (read_count == 2'd0)
                ram_addr <= ram_addr + 8'd1;
            else 
                data <= ram_rd_data;
            read_count <= read_count + 2'd1;
        end
    end
    else begin
        data <= data;
        ram_addr <= ram_addr;
    end
end

// ----------------没得感情的波特率发生器------------------
always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        cycle_cnt <= 16'd0;
    else if(cycle_cnt != CYCLE)
        cycle_cnt <= cycle_cnt + 16'd1;
    else
        cycle_cnt <= 16'd0;
end

// 相位控制信号控制
always@(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        phase_ctrl <= 1'b1;
        bit_cnt <= 3'd7;
    end else
        if(state == S_CTRL_TOGGLE) begin
            // 这个IF实现 NRZM编码
            if (data[bit_cnt])  
                phase_ctrl <= ~phase_ctrl;
            else
                phase_ctrl <= phase_ctrl;
            // 信号位数计数器
            if (bit_cnt != 3'd0)
                bit_cnt <= bit_cnt - 3'd1;
            else
                bit_cnt <= 3'd7;
        end else begin
            phase_ctrl <= phase_ctrl;
            bit_cnt <= bit_cnt;
        end
end
assign gen_en = current_state != S_IDLE;
endmodule