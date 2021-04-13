module rf_sin_gen_v1_0_M_AXIS #
       (
           parameter integer PHASE_STEP = 32'd916455424
       )(
           input wire  M_AXIS_ACLK,
           input wire  M_AXIS_ARESETN,
           output wire [256-1 : 0] M_AXIS_TDATA,
           output wire M_AXIS_TVALID,
           input  wire M_AXIS_TREADY,

           input wire gen_en,
           input wire phase_ctrl
       );


wire [16-1 : 0] M01_AXIS_PHASE_TDATA;
wire [16-1 : 0] M02_AXIS_PHASE_TDATA;
wire [16-1 : 0] M03_AXIS_PHASE_TDATA;
wire [16-1 : 0] M04_AXIS_PHASE_TDATA;
wire [16-1 : 0] M05_AXIS_PHASE_TDATA;
wire [16-1 : 0] M06_AXIS_PHASE_TDATA;
wire [16-1 : 0] M07_AXIS_PHASE_TDATA;
wire [16-1 : 0] M08_AXIS_PHASE_TDATA;
wire [16-1 : 0] M09_AXIS_PHASE_TDATA;
wire [16-1 : 0] M10_AXIS_PHASE_TDATA;
wire [16-1 : 0] M11_AXIS_PHASE_TDATA;
wire [16-1 : 0] M12_AXIS_PHASE_TDATA;
wire [16-1 : 0] M13_AXIS_PHASE_TDATA;
wire [16-1 : 0] M14_AXIS_PHASE_TDATA;
wire [16-1 : 0] M15_AXIS_PHASE_TDATA;
wire [16-1 : 0] M16_AXIS_PHASE_TDATA;

wire  M01_AXIS_PHASE_TVALID;
wire  M02_AXIS_PHASE_TVALID;
wire  M03_AXIS_PHASE_TVALID;
wire  M04_AXIS_PHASE_TVALID;
wire  M05_AXIS_PHASE_TVALID;
wire  M06_AXIS_PHASE_TVALID;
wire  M07_AXIS_PHASE_TVALID;
wire  M08_AXIS_PHASE_TVALID;
wire  M09_AXIS_PHASE_TVALID;
wire  M10_AXIS_PHASE_TVALID;
wire  M11_AXIS_PHASE_TVALID;
wire  M12_AXIS_PHASE_TVALID;
wire  M13_AXIS_PHASE_TVALID;
wire  M14_AXIS_PHASE_TVALID;
wire  M15_AXIS_PHASE_TVALID;
wire  M16_AXIS_PHASE_TVALID;

wire [16-1 : 0] M01_AXIS_DDS_TDATA;
wire [16-1 : 0] M02_AXIS_DDS_TDATA;
wire [16-1 : 0] M03_AXIS_DDS_TDATA;
wire [16-1 : 0] M04_AXIS_DDS_TDATA;
wire [16-1 : 0] M05_AXIS_DDS_TDATA;
wire [16-1 : 0] M06_AXIS_DDS_TDATA;
wire [16-1 : 0] M07_AXIS_DDS_TDATA;
wire [16-1 : 0] M08_AXIS_DDS_TDATA;
wire [16-1 : 0] M09_AXIS_DDS_TDATA;
wire [16-1 : 0] M10_AXIS_DDS_TDATA;
wire [16-1 : 0] M11_AXIS_DDS_TDATA;
wire [16-1 : 0] M12_AXIS_DDS_TDATA;
wire [16-1 : 0] M13_AXIS_DDS_TDATA;
wire [16-1 : 0] M14_AXIS_DDS_TDATA;
wire [16-1 : 0] M15_AXIS_DDS_TDATA;
wire [16-1 : 0] M16_AXIS_DDS_TDATA;
wire M_AXIS_PHASE_TREADY;
assign M_AXIS_PHASE_TREADY = 1;
assign M_AXIS_TDATA = {M16_AXIS_DDS_TDATA, M15_AXIS_DDS_TDATA , M14_AXIS_DDS_TDATA, M13_AXIS_DDS_TDATA, M12_AXIS_DDS_TDATA, M11_AXIS_DDS_TDATA, M10_AXIS_DDS_TDATA, M09_AXIS_DDS_TDATA, M08_AXIS_DDS_TDATA, M07_AXIS_DDS_TDATA, M06_AXIS_DDS_TDATA, M05_AXIS_DDS_TDATA, M04_AXIS_DDS_TDATA, M03_AXIS_DDS_TDATA, M02_AXIS_DDS_TDATA, M01_AXIS_DDS_TDATA};

phase_gen_16 #(
                 .step(PHASE_STEP)
             ) phase_gen (
                 .M01_AXIS_ACLK(M_AXIS_ACLK),
                 .M01_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M01_AXIS_TDATA(M01_AXIS_PHASE_TDATA),
                 .M01_AXIS_TVALID(M01_AXIS_PHASE_TVALID),
                 .M01_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M02_AXIS_ACLK(M_AXIS_ACLK),
                 .M02_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M02_AXIS_TDATA(M02_AXIS_PHASE_TDATA),
                 .M02_AXIS_TVALID(M02_AXIS_PHASE_TVALID),
                 .M02_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M03_AXIS_ACLK(M_AXIS_ACLK),
                 .M03_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M03_AXIS_TDATA(M03_AXIS_PHASE_TDATA),
                 .M03_AXIS_TVALID(M03_AXIS_PHASE_TVALID),
                 .M03_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M04_AXIS_ACLK(M_AXIS_ACLK),
                 .M04_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M04_AXIS_TDATA(M04_AXIS_PHASE_TDATA),
                 .M04_AXIS_TVALID(M04_AXIS_PHASE_TVALID),
                 .M04_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M05_AXIS_ACLK(M_AXIS_ACLK),
                 .M05_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M05_AXIS_TDATA(M05_AXIS_PHASE_TDATA),
                 .M05_AXIS_TVALID(M05_AXIS_PHASE_TVALID),
                 .M05_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M06_AXIS_ACLK(M_AXIS_ACLK),
                 .M06_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M06_AXIS_TDATA(M06_AXIS_PHASE_TDATA),
                 .M06_AXIS_TVALID(M06_AXIS_PHASE_TVALID),
                 .M06_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M07_AXIS_ACLK(M_AXIS_ACLK),
                 .M07_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M07_AXIS_TDATA(M07_AXIS_PHASE_TDATA),
                 .M07_AXIS_TVALID(M07_AXIS_PHASE_TVALID),
                 .M07_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M08_AXIS_ACLK(M_AXIS_ACLK),
                 .M08_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M08_AXIS_TDATA(M08_AXIS_PHASE_TDATA),
                 .M08_AXIS_TVALID(M08_AXIS_PHASE_TVALID),
                 .M08_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M09_AXIS_ACLK(M_AXIS_ACLK),
                 .M09_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M09_AXIS_TDATA(M09_AXIS_PHASE_TDATA),
                 .M09_AXIS_TVALID(M09_AXIS_PHASE_TVALID),
                 .M09_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M10_AXIS_ACLK(M_AXIS_ACLK),
                 .M10_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M10_AXIS_TDATA(M10_AXIS_PHASE_TDATA),
                 .M10_AXIS_TVALID(M10_AXIS_PHASE_TVALID),
                 .M10_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M11_AXIS_ACLK(M_AXIS_ACLK),
                 .M11_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M11_AXIS_TDATA(M11_AXIS_PHASE_TDATA),
                 .M11_AXIS_TVALID(M11_AXIS_PHASE_TVALID),
                 .M11_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M12_AXIS_ACLK(M_AXIS_ACLK),
                 .M12_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M12_AXIS_TDATA(M12_AXIS_PHASE_TDATA),
                 .M12_AXIS_TVALID(M12_AXIS_PHASE_TVALID),
                 .M12_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M13_AXIS_ACLK(M_AXIS_ACLK),
                 .M13_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M13_AXIS_TDATA(M13_AXIS_PHASE_TDATA),
                 .M13_AXIS_TVALID(M13_AXIS_PHASE_TVALID),
                 .M13_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M14_AXIS_ACLK(M_AXIS_ACLK),
                 .M14_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M14_AXIS_TDATA(M14_AXIS_PHASE_TDATA),
                 .M14_AXIS_TVALID(M14_AXIS_PHASE_TVALID),
                 .M14_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M15_AXIS_ACLK(M_AXIS_ACLK),
                 .M15_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M15_AXIS_TDATA(M15_AXIS_PHASE_TDATA),
                 .M15_AXIS_TVALID(M15_AXIS_PHASE_TVALID),
                 .M15_AXIS_TREADY(M_AXIS_PHASE_TREADY),

                 .M16_AXIS_ACLK(M_AXIS_ACLK),
                 .M16_AXIS_ARESETN(M_AXIS_ARESETN),
                 .M16_AXIS_TDATA(M16_AXIS_PHASE_TDATA),
                 .M16_AXIS_TVALID(M16_AXIS_PHASE_TVALID),
                 .M16_AXIS_TREADY(M_AXIS_PHASE_TREADY),
                 .gen_en(gen_en),
                 .phase_ctrl(phase_ctrl)
             );
dds_compiler_0 dds1 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M01_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M01_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tvalid(M_AXIS_TVALID),    // output wire m_axis_data_tvalid
                   .m_axis_data_tdata(M01_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds2 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M02_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M02_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M02_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds3 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M03_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M03_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M03_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds4 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M04_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M04_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M04_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds5 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M05_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M05_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M05_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds6 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M06_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M06_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M06_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds7 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M07_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M07_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M07_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds8 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M08_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M08_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M08_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds9 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M09_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M09_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M09_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds10 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M10_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M10_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M10_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds11 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M11_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M11_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M11_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds12 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M12_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M12_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M12_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds13 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M13_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M13_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M13_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds14 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M14_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M14_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M14_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds15 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M15_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M15_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M15_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );

dds_compiler_0 dds16 (
                   .aclk(M_AXIS_ACLK),                                // input wire aclk
                   .s_axis_phase_tvalid(M16_AXIS_PHASE_TVALID),  // input wire s_axis_phase_tvalid
                   .s_axis_phase_tdata(M16_AXIS_PHASE_TDATA),    // input wire [15 : 0] s_axis_phase_tdata
                   .m_axis_data_tdata(M16_AXIS_DDS_TDATA)      // output wire [15 : 0] m_axis_data_tdata
               );
endmodule
