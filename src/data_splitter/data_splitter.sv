
module data_splitter #(
    parameter DATA_W = 8,
    parameter NODE_PER_ROW = 4,
    parameter NODE_PER_COL = 4

) (
    input clk,
    input rst,
    
    input [0:NODE_PER_ROW*NODE_PER_COL-1] valid_i_NoC,
    input [0:DATA_W*NODE_PER_ROW*NODE_PER_COL-1] data_i_NoC,
    input [0:NODE_PER_ROW*NODE_PER_COL-1] off_sigs_i_NoC,
    
    output  valid_o_NoC[0:NODE_PER_ROW*NODE_PER_COL-1],
    output [0:DATA_W-1] data_o_NoC[NODE_PER_ROW*NODE_PER_COL],
    output  off_sigs_o_NoC[0:NODE_PER_ROW*NODE_PER_COL-1]
    );

genvar i,j;
reg [0:DATA_W-1]  data_out       [NODE_PER_ROW*NODE_PER_COL];
reg               off_sigs_out   [NODE_PER_ROW*NODE_PER_COL];
reg               valid_out      [NODE_PER_ROW*NODE_PER_COL];

for (i = 0; i < NODE_PER_ROW*NODE_PER_COL; i++) begin
    always_ff @(posedge clk) begin : proc_1
        if(rst) begin
               data_out[i]     <= 0; 
               valid_out[i]    <= 0;  
               off_sigs_out[i] <= 0;  
             end
        else begin
                valid_out[i]      <= valid_i_NoC[i];   
                off_sigs_out[i]   <= off_sigs_i_NoC[i];   
                if(valid_i_NoC[i] == 1) begin
                   data_out[i]    <= data_i_NoC[i*DATA_W +: DATA_W];
                end
             end      
        end
end

for (j = 0; j < NODE_PER_ROW*NODE_PER_COL; j++) begin
    assign data_o_NoC[j]     = data_out[j];
    assign off_sigs_o_NoC[j] = off_sigs_out[j];
    assign valid_o_NoC[j]    = valid_out[j];
end


endmodule