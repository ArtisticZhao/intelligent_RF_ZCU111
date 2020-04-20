`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/19 17:54:19
// Design Name: 
// Module Name: tb_16
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_16();
reg aclk, arstn;
reg tready;
wire  tv0;
wire  tv1;
wire  tv2;
wire  tv3;
wire  tv4;
wire  tv5;
wire  tv6;
wire  tv7;
wire  tv8;
wire  tv9;
wire  tv10;
wire  tv11;
wire  tv12;
wire  tv13;
wire  tv14;
wire  tv15;
wire	[15:0]	td0;
wire	[15:0]	td1;
wire	[15:0]	td2;
wire	[15:0]	td3;
wire	[15:0]	td4;
wire	[15:0]	td5;
wire	[15:0]	td6;
wire	[15:0]	td7;
wire	[15:0]	td8;
wire	[15:0]	td9;
wire	[15:0]	td10;
wire	[15:0]	td11;
wire	[15:0]	td12;
wire	[15:0]	td13;
wire	[15:0]	td14;
wire	[15:0]	td15;
initial begin
    aclk=1;
    arstn=0;
    tready=1;
    #10
    arstn=1;
end

always begin 
 #1
 aclk=~aclk;
end
phase_gen_16 uut(
    
    .M01_AXIS_ACLK(aclk),
    .M01_AXIS_ARESETN(arstn),
    .M01_AXIS_TVALID(tv0),
    .M01_AXIS_TDATA(td0),
    .M01_AXIS_TREADY(tready), 

    .M02_AXIS_ACLK(aclk),
    .M02_AXIS_ARESETN(arstn),
    .M02_AXIS_TVALID(tv1),
    .M02_AXIS_TDATA(td1),
    .M02_AXIS_TREADY(tready), 
    
    .M03_AXIS_ACLK(aclk),
    .M03_AXIS_ARESETN(arstn),
    .M03_AXIS_TVALID(tv2),
    .M03_AXIS_TDATA(td2),
    .M03_AXIS_TREADY(tready), 

    .M04_AXIS_ACLK(aclk),
    .M04_AXIS_ARESETN(arstn),
    .M04_AXIS_TVALID(tv3),
    .M04_AXIS_TDATA(td3),
    .M04_AXIS_TREADY(tready), 

    .M05_AXIS_ACLK(aclk),
    .M05_AXIS_ARESETN(arstn),
    .M05_AXIS_TVALID(tv4),
    .M05_AXIS_TDATA(td4),
    .M05_AXIS_TREADY(tready), 

    .M06_AXIS_ACLK(aclk),
    .M06_AXIS_ARESETN(arstn),
    .M06_AXIS_TVALID(tv5),
    .M06_AXIS_TDATA(td5),
    .M06_AXIS_TREADY(tready), 

    .M07_AXIS_ACLK(aclk),
    .M07_AXIS_ARESETN(arstn),
    .M07_AXIS_TVALID(tv6),
    .M07_AXIS_TDATA(td6),
    .M07_AXIS_TREADY(tready), 

    .M08_AXIS_ACLK(aclk),
    .M08_AXIS_ARESETN(arstn),
    .M08_AXIS_TVALID(tv7),
    .M08_AXIS_TDATA(td7),
    .M08_AXIS_TREADY(tready), 

    .M09_AXIS_ACLK(aclk),
    .M09_AXIS_ARESETN(arstn),
    .M09_AXIS_TVALID(tv8),
    .M09_AXIS_TDATA(td8),
    .M09_AXIS_TREADY(tready), 

    .M10_AXIS_ACLK(aclk),
    .M10_AXIS_ARESETN(arstn),
    .M10_AXIS_TVALID(tv9),
    .M10_AXIS_TDATA(td9),
    .M10_AXIS_TREADY(tready), 

    .M11_AXIS_ACLK(aclk),
    .M11_AXIS_ARESETN(arstn),
    .M11_AXIS_TVALID(tv10),
    .M11_AXIS_TDATA(td10),
    .M11_AXIS_TREADY(tready), 

    .M12_AXIS_ACLK(aclk),
    .M12_AXIS_ARESETN(arstn),
    .M12_AXIS_TVALID(tv11),
    .M12_AXIS_TDATA(td11),
    .M12_AXIS_TREADY(tready), 

    .M13_AXIS_ACLK(aclk),
    .M13_AXIS_ARESETN(arstn),
    .M13_AXIS_TVALID(tv12),
    .M13_AXIS_TDATA(td12),
    .M13_AXIS_TREADY(tready), 

    .M14_AXIS_ACLK(aclk),
    .M14_AXIS_ARESETN(arstn),
    .M14_AXIS_TVALID(tv13),
    .M14_AXIS_TDATA(td13),
    .M14_AXIS_TREADY(tready), 

    .M15_AXIS_ACLK(aclk),
    .M15_AXIS_ARESETN(arstn),
    .M15_AXIS_TVALID(tv14),
    .M15_AXIS_TDATA(td14),
    .M15_AXIS_TREADY(tready), 

    .M16_AXIS_ACLK(aclk),
    .M16_AXIS_ARESETN(arstn),
    .M16_AXIS_TVALID(tv15),
    .M16_AXIS_TDATA(td15),
    .M16_AXIS_TREADY(tready)
);
endmodule
