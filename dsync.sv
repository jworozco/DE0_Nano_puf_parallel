`timescale 1ns/1ps

/*
* Company: Santa Clara University
* Engineer: Jonathan Trinh
*
* Create Date: 10/16/2019 07:40:38 PM
* Design Name:
* Module Name: dual synchronizer
* Project Name: Implementation of Dual Synchronizer
* Target Devices: Intel FPGA
* Tool Versions:
* Description: apply dsync to inputs and output the sync version to the input clk
*
* Dependencies: clock and reset
*
* Revision:
* Revision 0.01 - File Created
* Additional Comments:
*
*/

module dsync    (
//----------Output Ports--------------
  output logic dsync,
  //------------Input Ports--------------
  input d,
  input clk,
  input reset
  );

  logic dff;
//-------------Code Starts Here-------
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        dff <= 1'b0;
        dsync <= 1'b0;
    end
    else begin
        dff <= d;
        dsync <= dff;
    end
  end

endmodule
