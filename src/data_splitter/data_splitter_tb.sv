module data_splitter_tb ();

    parameter DATA_W = 8;
    parameter NODE_PER_ROW = 4;
    parameter NODE_PER_COL = 4;


    reg clk = 0;
    reg rst = 0;
    
    reg [0:NODE_PER_ROW*NODE_PER_COL-1] valid_i_NoC = 0;
    reg [0:DATA_W*NODE_PER_ROW*NODE_PER_COL-1] data_i_NoC = 0;
    reg [0:NODE_PER_ROW*NODE_PER_COL-1] off_sigs_i_NoC = 0;
    
    wire  valid_o_NoC[0:NODE_PER_ROW*NODE_PER_COL-1];
    wire [0:DATA_W-1] data_o_NoC[NODE_PER_ROW*NODE_PER_COL];
    wire  off_sigs_o_NoC[0:NODE_PER_ROW*NODE_PER_COL-1];


data_splitter 
#(
    .DATA_W(DATA_W),
    .NODE_PER_ROW(NODE_PER_ROW),
    .NODE_PER_COL(NODE_PER_COL)
) 
dut(
    .clk(clk),
    .rst(rst),   
    .valid_i_NoC(valid_i_NoC),
    .data_i_NoC(data_i_NoC),
    .off_sigs_i_NoC(off_sigs_i_NoC),
    .valid_o_NoC(valid_o_NoC),
    .data_o_NoC(data_o_NoC),
    .off_sigs_o_NoC(off_sigs_o_NoC)
    );

initial begin 
    valid_i_NoC = {NODE_PER_ROW*NODE_PER_COL {1'b1}};
    data_i_NoC = 128'hf0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0;
    #10;
    valid_i_NoC = 0;
    off_sigs_i_NoC = {NODE_PER_ROW*NODE_PER_COL {1'b1}};
    #10;
    rst = 1;
end


always begin : proc_1
    #5;
    clk = ~clk;
end

endmodule