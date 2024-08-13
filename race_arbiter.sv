`timescale 1ns/1ps

/*
* Company: Santa Clara University
* Engineer: Jonathan Trinh
*
* Create Date: 10/17/2019 02:15:09 PM
* Design Name:
* Module Name: race_arbiter
* Project Name: Implementation of Delay Based Physical Unclonable Function
* Target Devices: Intel Max 10, Xilinx Spartan 7
* Tool Versions:
* Description: The race_arbiter determines which signal finished first. If
* fin1 is asserted first, then the output is 1. If fin2 is asserted
* first, then output is 0. If both are 1, then behavior is unknown.
*
* Dependencies:
*
* Revision:
* Revision 0.01 - File Created
* Additional Comments:
*
*/

module race_arbiter(
  output logic out,
  output logic done,
  input reset, fin1, fin2
  );

  /* verilator lint_off UNOPTFLAT */
  logic cnt1_done, cnt2_done, winner /* synthesis keep */ ;
  /* verilator lint_on UNOPTFLAT */

  assign cnt1_done = (fin1 & ~ cnt2_done) === 1'b1;
  assign cnt2_done = (fin2 & ~ cnt1_done) === 1'b1;
  assign winner = cnt1_done | ~ cnt2_done;
  assign done = (fin1 | fin2)? 1'b1 : 1'b0;

  always_comb begin
    if (reset == 1'b1) begin
      out = 1'bX;
    end
    else begin
      out = winner;
    end
  end

endmodule
