
module Phase_Ctrl #(
           parameter integer data_width = 8,
           parameter integer frame_length = 150,
           parameter integer addr_width = 8,
           parameter integer ref_clk_freq = 100000000,
           parameter integer baudrate = 9600
       )(
           input                            clk        , //ʱ���ź�
           input                            rst_n      , //��λ�ź�
           // send �����ź�
           input                            send_signal,
           // phase ctrl
           output                           gen_en     ,
           output reg                       phase_ctrl ,
           // RAM�˿�
           output                           ram_clk    , //RAMʱ��
           input        [data_width-1 : 0]  ram_rd_data, //RAM�ж���������
           output  reg                      ram_en     , //RAMʹ���ź�
           output  reg  [addr_width-1 : 0]  ram_addr   , //RAM��ַ
           output  reg  [0:0]               ram_we     , //RAM��д�����ź� 1д 0��
           output  reg  [data_width-1 : 0]  ram_wr_data, //RAMд����
           output                           ram_rst      //RAM��λ�ź�,�ߵ�ƽ��Ч
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
// �����źŲ�����ת��
reg          start_rd_d0;
reg          start_rd_d1;
wire         pos_start_rd;
assign pos_start_rd = ~start_rd_d1 & start_rd_d0;

//��ʱ���ģ���start_rd�źŵ�������
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
// ---------------------------״̬������-------------------------------
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
// --------------------------BRAM��ȡ����------------------------------
reg [data_width-1 : 0]  data;  // ��Ҫ���͵�����
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
// --------------------------������λ�����źſ���------------------------
// �����ʷ�����
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
// �ֽڲ����ʿ�����

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
// ��λ�����źſ���
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
// ʹ���ź�
assign gen_en = 1; // (state == S_SEND_BYTE || state == S_SEND_READ);
endmodule
