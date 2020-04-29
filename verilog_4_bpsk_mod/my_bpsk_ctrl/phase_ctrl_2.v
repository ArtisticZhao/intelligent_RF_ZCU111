module Phase_Ctrl_2 #(
           parameter integer data_width = 8,
           parameter integer frame_length = 150,
           parameter integer addr_width = 8,
           parameter integer ref_clk_freq = 128000000,
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
localparam                       S_LOAD_DATA  = 2;
localparam                       S_CTRL_CHANGE= 3;
localparam                       S_WAIT       = 4;

reg[2:0]                         state;
reg[2:0]                         bit_cnt;//bit counter
reg[15:0]                        cycle_cnt; //baud counter

reg [7:0]                        init_cnt;

// ------------------------״̬��-----------------------------
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)begin
        state <= S_IDLE;
        init_cnt <= 0;
    end
    else begin
        case(state) 
            S_IDLE:
                if (init_cnt == 8'd100)
                    state <= S_LOAD_DATA;
                else begin
                    state <= S_IDLE;
                    init_cnt <= init_cnt + 8'd1;
                end
            S_LOAD_DATA:
                state <= S_WAIT;
            S_CTRL_CHANGE:
                state <= S_WAIT;
            S_WAIT:
                if (cycle_cnt == CYCLE)
                    state <= S_CTRL_CHANGE;
                else if (cycle_cnt == CYCLE-3 && bit_cnt == 3'd0)
                    state <= S_LOAD_DATA;
                else 
                    state <= state;
            default:
                state <= S_IDLE;
        endcase
    end
end


// --------------------------BRAM��ȡ����------------------------------
reg [data_width-1 : 0]  data;  // ��Ҫ���͵�����
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
        if (state == S_LOAD_DATA) begin
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
// ----------------û�ø���Ĳ����ʷ�����------------------
always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        cycle_cnt <= 16'd0;
    else if(state == S_IDLE)
        cycle_cnt <= 16'd0;
    else if(cycle_cnt != CYCLE)
        cycle_cnt <= cycle_cnt + 16'd1;
    else
        cycle_cnt <= 16'd0;
end
// -------------------��λ�ź�����, ���ղ�����---------------
// ��λ�����źſ���
always@(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        phase_ctrl <= 1'b1;
        bit_cnt <= 3'd7;
    end else
        if(state == S_CTRL_CHANGE) begin
            // ���IFʵ�� NRZM����
            if (data[bit_cnt])  
                phase_ctrl <= ~phase_ctrl;
            else
                phase_ctrl <= phase_ctrl;
            // �ź�λ��������
            if (bit_cnt != 3'd0)
                bit_cnt <= bit_cnt - 3'd1;
            else
                bit_cnt <= 3'd7;
        end else begin
            phase_ctrl <= phase_ctrl;
            bit_cnt <= bit_cnt;
        end
end
assign gen_en = state != S_IDLE;
endmodule