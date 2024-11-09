`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2024 03:45:53
// Design Name: 
// Module Name: token_rings_tb
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


module token_rings_tb;
    reg clk = 1'b0;
    reg en = 1'b0;
    reg [3:0] datain; 
    wire [3:0] data;
    token_rings dut(clk, en, datain, data);
    always #2 clk = ~clk;
    initial begin
        repeat(5) begin
//        #2;
        en = 1'b1;
        datain = $random % 16;
        #3;
        end
        $finish;
    end
    initial begin
    $monitor("%b %b %b", datain, data, datain[0]);
    end
endmodule
