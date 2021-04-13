module BPSK_Ctrl #(
           parameter integer data_width = 8,
           parameter integer frame_length = 150,
           parameter integer addr_width = 8,
           parameter integer ref_clk_freq = 128000000,
           parameter integer baudrate = 9600
       )(
           input                            clk        , //ʱ���ź�
           input                            rst_n      , //��λ�ź�
           input                            send_signal, // send �����ź�

           // RAM�˿�
           output                           ram_clk    , //RAMʱ��
           input        [data_width-1 : 0]  ram_rd_data, //RAM�ж���������
           output  reg                      ram_en     , //RAMʹ���ź�
           output  reg  [addr_width-1 : 0]  ram_addr   , //RAM��ַ
           output  reg  [0:0]               ram_we     , //RAM��д�����ź� 1д 0��
           output  reg  [data_width-1 : 0]  ram_wr_data, //RAMд����
           output                           ram_rst    , //RAM��λ�ź�,�ߵ�ƽ��Ч

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

// һ�� ͬ��״̬ת��
always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) 
        current_state <= S_IDLE;
    else 
        current_state <= next_state;
end

// ���� ���״̬
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

// ���� ҵ���߼�
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

// ----------------û�ø���Ĳ����ʷ�����------------------
always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        cycle_cnt <= 16'd0;
    else if(cycle_cnt != CYCLE)
        cycle_cnt <= cycle_cnt + 16'd1;
    else
        cycle_cnt <= 16'd0;
end

// ��λ�����źſ���
always@(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        phase_ctrl <= 1'b1;
        bit_cnt <= 3'd7;
    end else
        if(state == S_CTRL_TOGGLE) begin
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
assign gen_en = current_state != S_IDLE;
endmodule