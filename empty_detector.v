`include "C:/Users/SnigdhaYS/Downloads/UART_adder/synchronous fifo/synchronous fifo.srcs/sources_1/new/param.v"

module empty_detector (  
   input wire [1:0] write_pointer,  
   input wire [1:0] read_pointer,  
   input wire clk_read,  
   input wire read,  
   output reg empty  
);  
  
   reg [1:0] write_pointer_sync;  
  
   // Dual-flip-flop synchronizer for the write pointer in the read domain  
   always @(posedge clk_read) begin  
      write_pointer_sync <= write_pointer;  
   end  
  
   // Empty condition detection using Gray code pointers  
   always @(posedge clk_read) begin  
      empty <= (write_pointer_sync == read_pointer) && read;  
   end  
endmodule
