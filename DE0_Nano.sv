
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module DE0_Nano(


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input                           CLOCK_50,

//////////// LED //////////
output logic       [7:0]        LED,

//////////// KEY //////////
input              [1:0]        KEY,

//////////// SW //////////
input              [3:0]        SW

/* //////////// SDRAM //////////
output logic       [12:0]       DRAM_ADDR,
output logic       [1:0]        DRAM_BA,
output logic                    DRAM_CAS_N,
output logic                    DRAM_CKE,
output logic                    DRAM_CLK,
output logic                    DRAM_CS_N,
inout             [15:0]        DRAM_DQ,
output logic       [1:0]        DRAM_DQM,
output logic                    DRAM_RAS_N,
output logic                    DRAM_WE_N,

//////////// EPCS //////////
output logic                    EPCS_ASDO,
input                           EPCS_DATA0,
output logic                    EPCS_DCLK,
output logic                    EPCS_NCSO,

//////////// Accelerometer and EEPROM //////////
output logic                    G_SENSOR_CS_N,
input                           G_SENSOR_INT,
output logic                    I2C_SCLK,
inout                           I2C_SDAT,

//////////// ADC //////////
output logic                    ADC_CS_N,
output logic                    ADC_SADDR,
output logic                    ADC_SCLK,
input                           ADC_SDAT,

//////////// 2x13 GPIO Header //////////
inout             [12:0]        GPIO_2,
input              [2:0]        GPIO_2_IN,

//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
inout             [33:0]        GPIO_0,
input              [1:0]        GPIO_0_IN,

//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
inout             [33:0]        GPIO_1,
input              [1:0]        GPIO_1_IN
 */
);

//=======================================================
//  PARAMETER declarations
//=======================================================
localparam logic [3:0] Zero   = 4'b0000;
localparam logic [3:0] One    = 4'b0001;
localparam logic [3:0] Two    = 4'b0010;
localparam logic [3:0] Three  = 4'b0011;
localparam logic [3:0] Four   = 4'b0100;
localparam logic [3:0] Five   = 4'b0101;
localparam logic [3:0] Six    = 4'b0110;
localparam logic [3:0] Seven  = 4'b0111;
localparam logic [3:0] Eight  = 4'b1000;
localparam logic [3:0] Nine   = 4'b1001;
localparam logic [3:0] Ten    = 4'b1010;
localparam logic [3:0] Eleven  = 4'b1011;
localparam logic [3:0] Twelve  = 4'b1100;
localparam logic [3:0] Thirteen  = 4'b1101;
localparam logic [3:0] Fourteen  = 4'b1110;
localparam logic [3:0] Fifhteen  = 4'b1111;


//=======================================================
//  REG/WIRE declarations
//=======================================================

// Inputs
wire [31:0] enables1;
wire [31:0] enables2;
wire fsm_rst; // reset for FSM
wire fsm_restart; // restart for FSM
wire puf1_rst; // reset for PUF 1
wire puf2_rst; // reset for PUF 2

// Outputs
wire [7:0] response1;
wire [7:0] response2;
wire [7:0] done1;
wire [7:0] done2;
wire all_done1;
wire all_done2;

//=======================================================
//  Structural coding
//=======================================================

//Instantiate the PUF module

 puf_parallel parallel_scheme1 (
        .enable (enables1),
        .challenge (puf1_counter),
        .out (response1),
        .done (done1),
        .clock (CLOCK_50),
        .reset (puf1_rst),
        .all_done (all_done1)
        );

puf_parallel parallel_scheme2 (
        .enable (enables2),
        .challenge (puf2_counter),
        .out (response2),
        .done (done2),
        .clock (CLOCK_50),
        .reset (puf2_rst),
        .all_done (all_done2)
        );

//Create an FSM to view the results of both PUF

typedef enum logic [1:0] { START, PUF1, PUF2, HALT } state_t;

state_t ps;  //present state
state_t ns;  //next state

//Arcs

logic arc_rst_puf1;
logic arc_puf1_puf2;
logic arc_puf2_puf1;
logic arc_puf2_halt;
logic arc_halt_rst;

assign arc_rst_puf1 = ((ps == START) && ~KEY[0]);
assign arc_puf1_puf2   = ((ps == PUF1) && ~KEY[1]);
assign arc_puf2_puf1   = ((ps == PUF2) && ~KEY[0]);
assign arc_puf2_halt  = ((ps == PUF2) && ~KEY[0] && (puf1_counter == 8'b11111111));
assign arc_halt_rst = ((ps == HALT) && (fsm_restart));

//Next state logic

// Use SW as PUF reset and restart
assign fsm_rst = SW[0]; //reset the FSM
assign fsm_restart = SW[1]; //restart the FSM

always_comb begin : next_state_calc
    unique case (ps)
        START: begin
            if (arc_rst_puf1) ns = PUF1;
            else ns = START;
        end
        PUF1: begin
            if (arc_puf1_puf2) ns = PUF2;
            else ns = PUF1;
        end
        PUF2: begin
            if (arc_puf2_halt) ns = HALT;
            else if (arc_puf2_puf1) ns = PUF1;
            else ns = PUF2;
        end
        HALT:begin
            if (arc_halt_rst) ns = START;
            else ns = HALT;
        end
    endcase
end

// Next State FF
always_ff @(posedge CLOCK_50, posedge fsm_rst ) begin : PS_FF
    if (fsm_rst) ps <= START; //On reset always start at START
    else ps <= ns;         //present state becomes next state
end

// Implement counters to go thru all challenges
logic [7:0] puf1_counter;
logic [7:0] puf2_counter;

always_ff @( posedge CLOCK_50, posedge fsm_rst ) begin : SC_Counters
    if (fsm_rst) begin
        puf1_counter <= '0;
        puf2_counter <= '0;
    end
    else begin
        if (arc_puf1_puf2) puf1_counter <= puf1_counter + 1'b1;
        if (arc_puf2_puf1) puf2_counter <= puf2_counter + 1'b1;
    end
end

// Assign the LED to show the current SC response
assign LED = (ps == PUF1) ? response1 :
             (ps == PUF2) ? response2 :
             '0;

// generate the PUF reset after each challenge
assign puf1_rst = (ps == START) || (ps == PUF2) || (ps == HALT);
assign puf2_rst = (ps == START) || (ps == PUF1) || (ps == HALT);

// generate the enables
assign enables1 = {32{(ps == PUF1)}}; //enables are set only in PUF1
assign enables2 = {32{(ps == PUF2)}}; //enables are set only in PUF2


endmodule


