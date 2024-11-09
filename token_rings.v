`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.10.2024 22:17:28
// Design Name: 
// Module Name: token_rings
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

`include "param.v"
module token_rings #(parameter N = 4)(
    input clk,
    input en,
    input [`N-1:0] datain,
    output reg [`N-1:0] data
    );
    reg temp;
    always @(posedge clk) begin
    if (en == 1'b1) begin
        temp = datain[0];
        data <= {temp, datain[`N-1:1]};
//        $display("in always block");
        end
    else begin
        data <= datain;
        end
    end
endmodule
