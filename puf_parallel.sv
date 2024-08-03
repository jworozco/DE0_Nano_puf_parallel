`timescale 1ns / 1ps

/*
* Company: Santa Clara University
* Engineer: Jonathan Trinh
*
* Create Date: 02/10/2020 05:01:25 PM
* Design Name:
* Module Name: puf_parallel
* Project Name: Delay-based Physical Unclonable Function Implementation
* Target Devices: Digilent S7-25, S7-50 (Xilinx Spartan 7)
* Tool Versions:
* Description: Parallel PUF scheme. It takes an 8-bit input and fans them out to
*              8 different subblocks each with a 1-bit output. These outputs are
*              concatenated to form an 8-bit output.
*
* Dependencies: puf_parallel_subblock
*
* Revision:
* Revision 0.01 - File Created
* Additional Comments:
*
*/


module puf_parallel(
  output [7:0] out,
  output [7:0] done,
  output all_done,
  input [7:0] challenge,
  input [31:0] enable,
  input clock,reset
  );

  assign all_done = &done[7:0];

   puf_parallel_subblock block0(
    .enable (enable[31:0]),
    .challenge (challenge[7:0]),
    .out (out[0]),
    .done (done[0]),
    .clock (clock),
    .reset (reset)
    );
   puf_parallel_subblock block1(
    .enable (enable[31:0]),
    .challenge (challenge[7:0]),
    .out (out[1]),
    .done (done[1]),
    .clock (clock),
    .reset (reset)
    );
   puf_parallel_subblock block2(
    .enable (enable[31:0]),
    .challenge (challenge[7:0]),
    .out (out[2]),
    .done (done[2]),
    .clock (clock),
    .reset (reset)
    );
   puf_parallel_subblock block3(
    .enable (enable[31:0]),
    .challenge (challenge[7:0]),
    .out (out[3]),
    .done (done[3]),
    .clock (clock),
    .reset (reset)
    );
   puf_parallel_subblock block4(
    .enable (enable[31:0]),
    .challenge (challenge[7:0]),
    .out (out[4]),
    .done (done[4]),
    .clock (clock),
    .reset (reset)
    );
   puf_parallel_subblock block5(
    .enable (enable[31:0]),
    .challenge (challenge[7:0]),
    .out (out[5]),
    .done (done[5]),
    .clock (clock),
    .reset (reset)
    );
   puf_parallel_subblock block6(
    .enable (enable[31:0]),
    .challenge (challenge[7:0]),
    .out (out[6]),
    .done (done[6]),
    .clock (clock),
    .reset (reset)
    );
   puf_parallel_subblock block7(
    .enable (enable[31:0]),
    .challenge (challenge[7:0]),
    .out (out[7]),
    .done (done[7]),
    .clock (clock),
    .reset (reset)
    );


endmodule
