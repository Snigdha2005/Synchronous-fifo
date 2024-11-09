`include "C:/Users/SnigdhaYS/Downloads/UART_adder/synchronous fifo/synchronous fifo.srcs/sources_1/new/param.v"

module FullDetector(  
   input wire [1:0] write_pointer,  
   input wire [1:0] read_pointer,  
   input wire clk_write,  
   input wire write,  
   output reg full  
);  
  
   reg [1:0] read_pointer_sync;  
  
   // Dual-flip-flop synchronizer for the read pointer in the write domain  
   always @(posedge clk_write) begin  
      read_pointer_sync <= read_pointer;  
   end  
  
   // Full condition detection using Gray code pointers  
   always @(posedge clk_write) begin  
      full <= (write_pointer == read_pointer_sync) && write;  
   end  
endmodule
