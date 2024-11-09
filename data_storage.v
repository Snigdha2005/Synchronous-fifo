`include "param.v"
module data_storage #(parameter N = 4)(
    input clk,
    input flag, 
    input data_write, 
    input [`N-1:0] data,
    input [`N-1:0] write_in,
    input [`N-1:0] read_in,
    output reg data_read,
    output reg [`N-1:0] dataout
    );
    wire [`N-1:0] data_write_en;
    wire [`N-1:0] data_read_en;
    assign data_write_en = write_in & ( {write_in[0], write_in[`N-1:1]} );
    assign data_read_en = read_in & ( {read_in[0], read_in[`N-1:1]} );
    always @(posedge clk) begin
        if (flag == 1'b0) begin
            for(int i = 0; i < `N; i = i+1) begin
                if (data_write_en[i] == 1'b1) begin
                    dataout <= data;
                    dataout[i] = data_write;
                    break;
                end
            end
        end
        else begin
            for(int i = 0; i < `N; i = i+1) begin
                if (data_read_en[i] == 1'b1) begin
                    data_read = data[i];
                end
            end
        end
     end              
endmodule