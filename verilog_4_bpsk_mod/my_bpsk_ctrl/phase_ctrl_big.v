module Phase_Ctrl_2 #(
        parameter integer ref_clk_freq = 128000000,
        parameter integer baudrate = 9600
    )

    (
        input                            clk        , //时钟信号
        input                            rst_n      , //复位信号
        // send 启动信号
        input                            send_signal,
        // phase ctrl
        output                           gen_en     ,
        output reg                       phase_ctrl
        
//        input [1199:0]                   data
    );
//calculates the clock cycle for baud rate
localparam                       CYCLE = ref_clk_freq / baudrate;
reg[12:0]                         bit_cnt;//bit counter
reg[15:0]                        cycle_cnt; //baud counter
wire [1199:0] data;
assign data = 1200'h1acffc1dff480ec09a0d70bc8e2c93ada7b746ce5a977dcc32a2bf3e0a10f18894cdeab1fe901d81341ae1791c59275b4f6e8d9cb52efb9865457e7c1421e311299bd563fd203b026835c2f238b24eb69edd1b396a5df730ca8afcf82843c6225337aac7fa407604d06b85e471649d6d3dba3672d4bbee619515f9f050878c44a66f558ff480ec09a0d70bc8e2c93ada7b746ce5a977;

// ----------------没得感情的波特率发生�?------------------
always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        cycle_cnt <= 16'd0;
    else if(cycle_cnt != CYCLE)
        cycle_cnt <= cycle_cnt + 16'd1;
    else
        cycle_cnt <= 16'd0;
end

//  位控制器
always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
    begin
        bit_cnt <= 12'd1199;
    end
	else if(cycle_cnt == CYCLE)
        if (bit_cnt == 12'd0)
            bit_cnt <= 12'd1199;
        else
		    bit_cnt <= bit_cnt - 3'd1;
	else
		bit_cnt <= bit_cnt;
end
// 并转�?
wire baud;
assign baud = cycle_cnt == CYCLE;
always@(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0) begin
        phase_ctrl <= 1'b1;
    end else
        if(cycle_cnt == CYCLE) begin
            // 这个IF实现 NRZM编码
            if (data[bit_cnt])  
                phase_ctrl <= ~phase_ctrl;
            else
                phase_ctrl <= phase_ctrl;
        end else begin
            phase_ctrl <= phase_ctrl;
        end
end    
endmodule