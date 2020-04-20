`timescale 1 ns / 1 ps

module phase_gen_v1_0_M00_AXIS #
       (
           // Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
           parameter integer C_M_AXIS_TDATA_WIDTH	= 16,
           // Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
           parameter integer C_M_START_COUNT	= 32,
           
           // 相位累加器步长, 通过此步长控制产生信号的频率  step = Fout/Fs * 2^32
            parameter integer PHASE_STEP = 32'd67108864,
            parameter integer  TOTAL_COUNTERS = 4'd12,  // 相位累加器的个数
            parameter integer  OFFSET = 4
       )
       (
           // Global ports
           input wire  M_AXIS_ACLK,
           //
           input wire  M_AXIS_ARESETN,
           // Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted.
           output wire  M_AXIS_TVALID,
           // TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
           output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
           // TREADY indicates that the slave can accept a transfer in the current cycle.
           input wire  M_AXIS_TREADY
           
       );

// function called clogb2 that returns an integer which has the
// value of the ceiling of the log base 2.
function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
            bit_depth = bit_depth >> 1;
    end
endfunction

// WAIT_COUNT_BITS is the width of the wait counter.
localparam integer WAIT_COUNT_BITS = clogb2(C_M_START_COUNT-1);

// Define the states of state machine
// The control state machine oversees the writing of input streaming data to the FIFO,
// and outputs the streaming data from the FIFO
parameter [1:0] IDLE = 2'b00,        // This is the initial/idle state

          INIT_COUNTER  = 2'b01, // This state initializes the counter, once
          // the counter reaches C_M_START_COUNT count,
          // the state machine changes state to SEND_STREAM
          SEND_STREAM   = 2'b10; // In this state the


// stream data is output through M_AXIS_TDATA
// State variable
reg [1:0] mst_exec_state;

// AXI Stream internal signals
//wait counter. The master waits for the user defined number of clock cycles before initiating a transfer.
reg [WAIT_COUNT_BITS-1 : 0] 	count;
//streaming data valid
wire  	axis_tvalid;
//streaming data valid delayed by one clock cycle
reg  	axis_tvalid_delay;

//FIFO implementation signals
reg [32-1 : 0] 	stream_data_out;
wire  	tx_en;

reg [31:0] phase_counter;
// I/O Connections assignments

assign M_AXIS_TVALID = axis_tvalid_delay;
assign M_AXIS_TDATA	 = stream_data_out[31:16];


// Control state machine implementation
always @(posedge M_AXIS_ACLK)
begin
    if (!M_AXIS_ARESETN)
        // Synchronous reset (active low)
    begin
        mst_exec_state <= IDLE;
        count    <= 0;
    end
    else
    case (mst_exec_state)
        IDLE:
            // The slave starts accepting tdata when
            // there tvalid is asserted to mark the
            // presence of valid streaming data
            //if ( count == 0 )
            //  begin
            mst_exec_state  <= INIT_COUNTER;
        //  end
        //else
        //  begin
        //    mst_exec_state  <= IDLE;
        //  end

        INIT_COUNTER:
            // The slave starts accepting tdata when
            // there tvalid is asserted to mark the
            // presence of valid streaming data
            if ( count == C_M_START_COUNT - 1 )
            begin
                mst_exec_state  <= SEND_STREAM;
            end
            else
            begin
                count <= count + 1;
                mst_exec_state  <= INIT_COUNTER;
            end

        SEND_STREAM:
            // The example design streaming master functionality starts
            // when the master drives output tdata from the FIFO and the slave
            // has finished storing the S_AXIS_TDATA
            mst_exec_state <= SEND_STREAM;
    endcase
end


//tvalid generation
//axis_tvalid is asserted when the control state machine's state is SEND_STREAM and
//number of output streaming data is less than the NUMBER_OF_OUTPUT_WORDS.
assign axis_tvalid = mst_exec_state == SEND_STREAM;

// AXI tlast generation
// axis_tlast is asserted number of output streaming data is NUMBER_OF_OUTPUT_WORDS-1
// (0 to NUMBER_OF_OUTPUT_WORDS-1)



// Delay the axis_tvalid and axis_tlast signal by one clock cycle
// to match the latency of M_AXIS_TDATA
always @(posedge M_AXIS_ACLK)
begin
    if (!M_AXIS_ARESETN)
    begin
        axis_tvalid_delay <= 1'b0;
    end
    else
    begin
        axis_tvalid_delay <= axis_tvalid;
    end
end


// 相位累加器

always@(posedge M_AXIS_ACLK)
begin
    if(!M_AXIS_ARESETN)
    begin
        phase_counter <= 0;
    end
    else
        if (tx_en)
            // read pointer is incremented after every read from the FIFO
            // when FIFO read signal is enabled.
        begin
            phase_counter <= phase_counter + TOTAL_COUNTERS*PHASE_STEP;
        end
        else
            phase_counter <= phase_counter;
end


//FIFO read enable generation

assign tx_en = M_AXIS_TREADY && axis_tvalid;

// Streaming output data is read from FIFO
always @( posedge M_AXIS_ACLK )
begin
    if(!M_AXIS_ARESETN)
    begin
        stream_data_out <= 0;
    end
    else
        stream_data_out <= phase_counter + OFFSET*PHASE_STEP;

end


endmodule
