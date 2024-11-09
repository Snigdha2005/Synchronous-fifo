`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2024 07:45:38
// Design Name: 
// Module Name: write_read_data
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
module synchronous_fifo(
    input clk_write, 
    input clk_read,
    input write, 
    input read,
    input datain,
    output dataout,
    output err
    );
    wire write_en;
    wire read_en;
    reg [`N-1:0] write_in;
    reg [`N-1:0] write_out;
    reg [`N-1:0] read_in;
    reg [`N-1:0] read_out;
    reg [1:0] write_pointer;
    reg [1:0] read_pointer;
    reg [`N-1:0] data, data1;
    wire flag;
    wire full, empty;
    assign write_en = write & (~full);
    assign read_en = read & (~empty);
    assign err = (write & (~write_en)) | (read & (~read_en));
    assign flag = (write == 1'b1) ? 1'b0:1'b1;
    token_rings write_ring(clk_write, write_en, write_in, write_out);
    token_rings read_ring(clk_read, read_en, read_in, read_out);
    data_storage data_fifo(clk_write, flag, datain, data, write_in, read_in, dataout, data1);
    FullDetector full_detector(write_pointer, read_pointer, clk_write, write, full);
    empty_detector EmptyDetector(write_pointer, read_pointer, clk_read, read, empty);
    
    always @(write_en) write_in = write_out;
    always @(read_en) read_in = read_out;
    always @(data1) data = data1;
    
    always @(write_in) begin
        for(int i = 0; i < `N; i = i + 1) begin
            if (write_in[i] == 1'b1) 
                begin 
                write_pointer = i;
                break;
                end
        end
    end
    always @(read_in) begin
        for(int i = 0; i < `N; i = i + 1) begin
            if (read_in[i] == 1'b1) 
                begin 
                read_pointer = i + 2;
                break;
                end
        end
    end
    
endmodule
