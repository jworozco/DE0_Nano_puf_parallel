`timescale 1ns / 1ps

/*
* Company: Santa Clara University
* Engineer: Abby Aguirre
*
* Create Date: 02/10/2020 03:39:47 PM
* Design Name:
* Module Name: puf_parallel_subblock
* Project Name: Delay-based Physical Unclonable Function Implementation
* Target Devices: Digilent S7-25, S7-50 (Xilinx Spartan 7)
* Tool Versions:
* Description: A subblock that takes an 8-bit input, runs a race between two ring
*              oscillators, and outputs 1-bit that is random
*
* Dependencies:
*
* Revision:
* Revision 0.01 - File Created
* Additional Comments:
*
*/


module puf_parallel_subblock(

  output out, done,
  input [7:0] challenge,
  input [31:0] enable,
  input clock, reset
  );

  // a 32 bit bus: each stems from the output of each ro
  logic [31:0] ro_out /* synthesis keep */;
  // output of muxes that go into the counters
  logic first_mux_out, second_mux_out /* synthesis keep */;
  // outputs of the counters that go into the race arbiter
  logic fin1, fin2 /* synthesis keep */;
  // for debug, output of the counters
  logic [21:0] pmc1_out, pmc2_out /* synthesis keep */;

   ring_osc first_ro[15:0] (
    .enable (enable[15:0]),
    .ro_out (ro_out[15:0])
    );    // An array of 16 ring oscillators that go into the first mux
   ring_osc second_ro[15:0] (
    .enable (enable[31:16]),
    .ro_out (ro_out[31:16])
    ); // An array of 16 ring oscillators that go into the second mux

   mux_16to1 first_mux (
    .in (ro_out[15:0]),
    .sel (challenge[3:0]),
    .out (first_mux_out)
    );

   mux_16to1 second_mux (
    .in (ro_out[31:16]),
    .sel (challenge[7:4]),
    .out (second_mux_out)
    );

   post_mux_counter pmc1 (
    .out (pmc1_out),
    .finished (fin1),
    .enable (enable[0]),
    .clk (first_mux_out),
    .reset (reset)
    );

   post_mux_counter pmc2 (
    .out (pmc2_out),
    .finished (fin2),
    .enable (enable[0]),
    .clk (second_mux_out),
    .reset (reset));

   race_arbiter arb (
    .fin1 (fin1),
    .fin2 (fin2),
    .reset (reset),
    .out (out),
    .done (done)
    );

endmodule
