`timescale 1 ns / 1 ps

module phase_gen_16(
    
    input wire  M01_AXIS_ACLK,
    input wire  M01_AXIS_ARESETN,
    output wire  M01_AXIS_TVALID,
    output wire [16-1 : 0] M01_AXIS_TDATA,
    input wire  M01_AXIS_TREADY, 

    input wire  M02_AXIS_ACLK,
    input wire  M02_AXIS_ARESETN,
    output wire  M02_AXIS_TVALID,
    output wire [16-1 : 0] M02_AXIS_TDATA,
    input wire  M02_AXIS_TREADY, 
    
    input wire  M03_AXIS_ACLK,
    input wire  M03_AXIS_ARESETN,
    output wire  M03_AXIS_TVALID,
    output wire [16-1 : 0] M03_AXIS_TDATA,
    input wire  M03_AXIS_TREADY, 

    input wire  M04_AXIS_ACLK,
    input wire  M04_AXIS_ARESETN,
    output wire  M04_AXIS_TVALID,
    output wire [16-1 : 0] M04_AXIS_TDATA,
    input wire  M04_AXIS_TREADY, 

    input wire  M05_AXIS_ACLK,
    input wire  M05_AXIS_ARESETN,
    output wire  M05_AXIS_TVALID,
    output wire [16-1 : 0] M05_AXIS_TDATA,
    input wire  M05_AXIS_TREADY, 

    input wire  M06_AXIS_ACLK,
    input wire  M06_AXIS_ARESETN,
    output wire  M06_AXIS_TVALID,
    output wire [16-1 : 0] M06_AXIS_TDATA,
    input wire  M06_AXIS_TREADY, 

    input wire  M07_AXIS_ACLK,
    input wire  M07_AXIS_ARESETN,
    output wire  M07_AXIS_TVALID,
    output wire [16-1 : 0] M07_AXIS_TDATA,
    input wire  M07_AXIS_TREADY, 

    input wire  M08_AXIS_ACLK,
    input wire  M08_AXIS_ARESETN,
    output wire  M08_AXIS_TVALID,
    output wire [16-1 : 0] M08_AXIS_TDATA,
    input wire  M08_AXIS_TREADY, 

    input wire  M09_AXIS_ACLK,
    input wire  M09_AXIS_ARESETN,
    output wire  M09_AXIS_TVALID,
    output wire [16-1 : 0] M09_AXIS_TDATA,
    input wire  M09_AXIS_TREADY, 

    input wire  M10_AXIS_ACLK,
    input wire  M10_AXIS_ARESETN,
    output wire  M10_AXIS_TVALID,
    output wire [16-1 : 0] M10_AXIS_TDATA,
    input wire  M10_AXIS_TREADY, 

    input wire  M11_AXIS_ACLK,
    input wire  M11_AXIS_ARESETN,
    output wire  M11_AXIS_TVALID,
    output wire [16-1 : 0] M11_AXIS_TDATA,
    input wire  M11_AXIS_TREADY, 

    input wire  M12_AXIS_ACLK,
    input wire  M12_AXIS_ARESETN,
    output wire  M12_AXIS_TVALID,
    output wire [16-1 : 0] M12_AXIS_TDATA,
    input wire  M12_AXIS_TREADY, 

    input wire  M13_AXIS_ACLK,
    input wire  M13_AXIS_ARESETN,
    output wire  M13_AXIS_TVALID,
    output wire [16-1 : 0] M13_AXIS_TDATA,
    input wire  M13_AXIS_TREADY, 

    input wire  M14_AXIS_ACLK,
    input wire  M14_AXIS_ARESETN,
    output wire  M14_AXIS_TVALID,
    output wire [16-1 : 0] M14_AXIS_TDATA,
    input wire  M14_AXIS_TREADY, 

    input wire  M15_AXIS_ACLK,
    input wire  M15_AXIS_ARESETN,
    output wire  M15_AXIS_TVALID,
    output wire [16-1 : 0] M15_AXIS_TDATA,
    input wire  M15_AXIS_TREADY, 

    input wire  M16_AXIS_ACLK,
    input wire  M16_AXIS_ARESETN,
    output wire  M16_AXIS_TVALID,
    output wire [16-1 : 0] M16_AXIS_TDATA,
    input wire  M16_AXIS_TREADY
);
parameter [31:0] step = 32'd419430400;
parameter [4:0]  total = 5'd16;

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(0)
) g1 (
    .M_AXIS_ACLK(M01_AXIS_ACLK),
    .M_AXIS_ARESETN(M01_AXIS_ARESETN),
    .M_AXIS_TVALID(M01_AXIS_TVALID),
    .M_AXIS_TDATA(M01_AXIS_TDATA),
    .M_AXIS_TREADY(M01_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(1)
) g2 (
    .M_AXIS_ACLK(M02_AXIS_ACLK),
    .M_AXIS_ARESETN(M02_AXIS_ARESETN),
    .M_AXIS_TVALID(M02_AXIS_TVALID),
    .M_AXIS_TDATA(M02_AXIS_TDATA),
    .M_AXIS_TREADY(M02_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(2)
) g3 (
    .M_AXIS_ACLK(M03_AXIS_ACLK),
    .M_AXIS_ARESETN(M03_AXIS_ARESETN),
    .M_AXIS_TVALID(M03_AXIS_TVALID),
    .M_AXIS_TDATA(M03_AXIS_TDATA),
    .M_AXIS_TREADY(M03_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(3)
) g4 (
    .M_AXIS_ACLK(M04_AXIS_ACLK),
    .M_AXIS_ARESETN(M04_AXIS_ARESETN),
    .M_AXIS_TVALID(M04_AXIS_TVALID),
    .M_AXIS_TDATA(M04_AXIS_TDATA),
    .M_AXIS_TREADY(M04_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(4)
) g5 (
    .M_AXIS_ACLK(M05_AXIS_ACLK),
    .M_AXIS_ARESETN(M05_AXIS_ARESETN),
    .M_AXIS_TVALID(M05_AXIS_TVALID),
    .M_AXIS_TDATA(M05_AXIS_TDATA),
    .M_AXIS_TREADY(M05_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(5)
) g6 (
    .M_AXIS_ACLK(M06_AXIS_ACLK),
    .M_AXIS_ARESETN(M06_AXIS_ARESETN),
    .M_AXIS_TVALID(M06_AXIS_TVALID),
    .M_AXIS_TDATA(M06_AXIS_TDATA),
    .M_AXIS_TREADY(M06_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(6)
) g7 (
    .M_AXIS_ACLK(M07_AXIS_ACLK),
    .M_AXIS_ARESETN(M07_AXIS_ARESETN),
    .M_AXIS_TVALID(M07_AXIS_TVALID),
    .M_AXIS_TDATA(M07_AXIS_TDATA),
    .M_AXIS_TREADY(M07_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(7)
) g8 (
    .M_AXIS_ACLK(M08_AXIS_ACLK),
    .M_AXIS_ARESETN(M08_AXIS_ARESETN),
    .M_AXIS_TVALID(M08_AXIS_TVALID),
    .M_AXIS_TDATA(M08_AXIS_TDATA),
    .M_AXIS_TREADY(M08_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(8)
) g9 (
    .M_AXIS_ACLK(M09_AXIS_ACLK),
    .M_AXIS_ARESETN(M09_AXIS_ARESETN),
    .M_AXIS_TVALID(M09_AXIS_TVALID),
    .M_AXIS_TDATA(M09_AXIS_TDATA),
    .M_AXIS_TREADY(M09_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(9)
) g10 (
    .M_AXIS_ACLK(M10_AXIS_ACLK),
    .M_AXIS_ARESETN(M10_AXIS_ARESETN),
    .M_AXIS_TVALID(M10_AXIS_TVALID),
    .M_AXIS_TDATA(M10_AXIS_TDATA),
    .M_AXIS_TREADY(M10_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(10)
) g11 (
    .M_AXIS_ACLK(M11_AXIS_ACLK),
    .M_AXIS_ARESETN(M11_AXIS_ARESETN),
    .M_AXIS_TVALID(M11_AXIS_TVALID),
    .M_AXIS_TDATA(M11_AXIS_TDATA),
    .M_AXIS_TREADY(M11_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(11)
) g12 (
    .M_AXIS_ACLK(M12_AXIS_ACLK),
    .M_AXIS_ARESETN(M12_AXIS_ARESETN),
    .M_AXIS_TVALID(M12_AXIS_TVALID),
    .M_AXIS_TDATA(M12_AXIS_TDATA),
    .M_AXIS_TREADY(M12_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(12)
) g13 (
    .M_AXIS_ACLK(M13_AXIS_ACLK),
    .M_AXIS_ARESETN(M13_AXIS_ARESETN),
    .M_AXIS_TVALID(M13_AXIS_TVALID),
    .M_AXIS_TDATA(M13_AXIS_TDATA),
    .M_AXIS_TREADY(M13_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(13)
) g14 (
    .M_AXIS_ACLK(M14_AXIS_ACLK),
    .M_AXIS_ARESETN(M14_AXIS_ARESETN),
    .M_AXIS_TVALID(M14_AXIS_TVALID),
    .M_AXIS_TDATA(M14_AXIS_TDATA),
    .M_AXIS_TREADY(M14_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(14)
) g15 (
    .M_AXIS_ACLK(M15_AXIS_ACLK),
    .M_AXIS_ARESETN(M15_AXIS_ARESETN),
    .M_AXIS_TVALID(M15_AXIS_TVALID),
    .M_AXIS_TDATA(M15_AXIS_TDATA),
    .M_AXIS_TREADY(M15_AXIS_TREADY)
);

phase_gen_v1_0_M00_AXIS #(
    .PHASE_STEP(step),
    .TOTAL_COUNTERS(total),
    .OFFSET(15)
) g16 (
    .M_AXIS_ACLK(M16_AXIS_ACLK),
    .M_AXIS_ARESETN(M16_AXIS_ARESETN),
    .M_AXIS_TVALID(M16_AXIS_TVALID),
    .M_AXIS_TDATA(M16_AXIS_TDATA),
    .M_AXIS_TREADY(M16_AXIS_TREADY)
);
endmodule