`timescale 1ns / 1ns

module tb_phase_ctrl();
reg clk, rst_n;
reg send_signal;
wire gen_en, phase_ctrl;
wire ram_clk;
wire [7:0] ram_rd_data;
wire ram_en;
wire [7:0] ram_addr;
wire ram_we;
wire [7:0] ram_wr_data;
wire ram_rst;
initial begin
    clk=1;
    rst_n=0;
    send_signal=0;
    #10
    rst_n=1;
    send_signal=1;
end

always begin 
 #5  // 100MHz
 clk=~clk;
end

//always begin 
// #62500000  // 100MHz
// send_signal=~send_signal;
//end

Phase_Ctrl uut(
    .clk        (clk),
    .rst_n      (rst_n),
    .send_signal(send_signal),
    .gen_en     (gen_en),
    .phase_ctrl (phase_ctrl),
    .ram_clk    (ram_clk),
    .ram_rd_data(ram_rd_data),
    .ram_en     (ram_en),
    .ram_addr   (ram_addr),
    .ram_we     (ram_we),
    .ram_wr_data(ram_wr_data),
    .ram_rst    (ram_rst)
);

blk_mem_gen_0 your_instance_name (
  .clkb(ram_clk),    // input wire clkb
  .enb(ram_en),      // input wire enb
  .web(ram_we),      // input wire [0 : 0] web
  .addrb(ram_addr),  // input wire [7 : 0] addrb
  .dinb(ram_wr_data),    // input wire [7 : 0] dinb
  .doutb(ram_rd_data)  // output wire [7 : 0] doutb
);
endmodule