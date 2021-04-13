`timescale 1ns / 1ps

module tb_phase_gen_ctrl();
reg gen_en, phase_ctrl;
reg aclk, arstn, tready;
wire [15:0] tdata;
wire tvalid;

wire [15:0] sin_tdata;
wire sin_tvalid;
initial begin
    aclk=1;
    arstn=0;
    tready=1;
    gen_en=1;
    phase_ctrl=0;
    #10
    arstn=1;
end
always begin
    #1
     aclk=~aclk;
end
always begin
    #1000
     gen_en=~gen_en;
end
always begin
    #100
     phase_ctrl=~phase_ctrl;
end
phase_gen_v1_0_M00_AXIS uut(

                            .M_AXIS_ACLK(aclk),
                            .M_AXIS_ARESETN(arstn),
                            .M_AXIS_TVALID(tvalid),
                            .M_AXIS_TDATA(tdata),
                            .M_AXIS_TREADY(tready),
                            .gen_en(gen_en),
                            .phase_ctrl(phase_ctrl)
                        );
// 调用一个  DDS Compiler IP 设置为  sine LUT 模式  phase width 16  赋值宽度为8                        
dds_compiler_0 uut1 (
  .aclk(aclk),                                // input wire aclk
  .s_axis_phase_tvalid(tvalid),  // input wire s_axis_phase_tvalid
  .s_axis_phase_tdata(tdata),    // input wire [15 : 0] s_axis_phase_tdata
  .m_axis_data_tvalid(sin_tvalid),    // output wire m_axis_data_tvalid
  .m_axis_data_tdata(sin_tdata)      // output wire [15 : 0] m_axis_data_tdata
);
endmodule
