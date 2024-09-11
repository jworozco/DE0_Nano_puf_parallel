`timescale 1ns/1ps
import puf_pkg::*;
/*
* Company: Ulatina
* Engineer: Jose W Orozco
*
* Create Date: 13/8/2024 03:22:41 PM
* Design Name: fsm.sv
* Module Name: fsm
* Project Name: PUF select to enable use of limited resource of the FPGA
* Target Devices: Altera DE0_Nano
* Tool Versions: 23
* Description: FSM switches between PUF1 and PUF2
*
* Dependencies:
*
* Revision:
* Revision 0.01 - File Created
* Additional Comments:
*
*/

module fsm (
  input clk, // Clock input
  input fsm_rst, // reset for FSM
  input fsm_restart, // restart for FSM
  input [1:0] KEY, // Key inputs
  output state_t ps,  //present state
  // Implement counters to go thru all challenges
  output logic [7:0] puf1_counter,
  output logic [7:0] puf2_counter
  );

//Create Present and Next state variables

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
always_ff @(posedge clk, posedge fsm_rst ) begin : PS_FF
    if (fsm_rst) ps <= START; //On reset always start at START
    else ps <= ns;         //present state becomes next state
end


always_ff @( posedge clk, posedge fsm_rst ) begin : SC_Counters
    if (fsm_rst) begin
        puf1_counter <= '0;
        puf2_counter <= '0;
    end
    else begin
        if (arc_puf1_puf2) puf1_counter <= puf1_counter + 1'b1;
        if (arc_puf2_puf1) puf2_counter <= puf2_counter + 1'b1;
    end
end


endmodule
