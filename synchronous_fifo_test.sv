module synchronous_fifo_tb;  
   reg clk_write =1'b0; 
   reg clk_read = 1'b0;
   reg write;
   reg read;  
   reg datain;  
   wire dataout;  
   wire err;
  
   // Instantiate FIFO  
   synchronous_fifo uut (  
      .clk_write(clk_write),  
      .clk_read(clk_read),  
      .write(write),  
      .read(read),  
      .datain(datain),  
      .dataout(dataout),
      .err(err)
   );  
  always #2 clk_write = ~clk_write;
  always #1 clk_read = ~clk_read;
   // Test stimulus  
   initial begin  
      read = 1'b1;
      #5;
      read = 1'b0;
      write = 1'b1;
      datain = 1'b1;
      #5;
      write = 1'b0;
      read = 1'b1;
      #5;
      $finish;  
   end  
   initial begin
    $monitor("write=%b, read=%b, datain=%b, dataout=%b, dut.datain=%b", write, read, datain, dataout, uut.data1); 
  end
endmodule
