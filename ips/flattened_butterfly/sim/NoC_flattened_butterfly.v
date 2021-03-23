`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: GaTech ECE
// Engineer: Xingyang (Xandy) Liu
// 
// Create Date: 04/12/2019 05:25:55 PM
// Design Name: 
// Module Name: NoC_flattened_butterfly
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


module NoC_flattened_butterfly #(
    parameter DATA_W = 8,
    parameter FIFO_DEPTH = 8,
    parameter NODE_PER_ROW = 4,
    parameter NODE_PER_COL = 4

) (
    input clk,
    input rst,
    
    input [0:NODE_PER_ROW*NODE_PER_COL-1] valid_i_NoC,
    input [0:DATA_W*NODE_PER_ROW*NODE_PER_COL-1] data_i_NoC,
    input [0:NODE_PER_ROW*NODE_PER_COL-1] off_sigs_i_NoC,
    
    output [0:NODE_PER_ROW*NODE_PER_COL-1] valid_o_NoC,
    output [0:DATA_W*NODE_PER_ROW*NODE_PER_COL-1] data_o_NoC,
    output [0:NODE_PER_ROW*NODE_PER_COL-1] off_sigs_o_NoC
    
    );

localparam INPORT = NODE_PER_ROW + NODE_PER_COL -1; //including local port
localparam OUTPORT = NODE_PER_ROW + NODE_PER_COL -1; //including local port

localparam L_I = INPORT - 1; // use last port for local port
localparam L_O = OUTPORT - 1; // use last port for local port

localparam TOTAL_NODES = NODE_PER_ROW*NODE_PER_COL;

genvar i, j, k, m, n;

wire[0:INPORT-1] valid_i[0:TOTAL_NODES-1];
wire[0:INPORT*DATA_W-1] data_i[0:TOTAL_NODES-1];
wire[0:OUTPORT-1] off_sigs_i[0:TOTAL_NODES-1];

wire[0:OUTPORT-1] valid_o[0:TOTAL_NODES-1];
wire[0:OUTPORT*DATA_W-1] data_o[0:TOTAL_NODES-1];
wire[0:INPORT-1] off_sigs_o[0:TOTAL_NODES-1];

//// connect routers {W,E,S,N,L}
// connect local ports
for (i = 0; i < TOTAL_NODES; i = i+1) begin
    assign off_sigs_i[i][L_O] = off_sigs_i_NoC[i];
    assign valid_i[i][L_I] = valid_i_NoC[i];
    assign data_i[i][L_I*DATA_W +: DATA_W] = data_i_NoC[DATA_W*i +: DATA_W];
    
    assign off_sigs_o_NoC[i] = off_sigs_o[i][L_I];
    assign valid_o_NoC[i] = valid_o[i][L_O];
    assign data_o_NoC[DATA_W*i +: DATA_W] = data_o[i][L_O*DATA_W +: DATA_W];
end

for (j = 0; j < NODE_PER_COL; j = j+1) begin
    for (i = 0; i < NODE_PER_ROW; i = i+1) begin // [j*NODE_PER_ROW+i]
        for (k = 0; k < NODE_PER_ROW; k = k+1) begin // [j*NODE_PER_ROW+k] dim0
            if (k < i) begin
                localparam i_idx = k;
                localparam o_idx = i - 1;
                assign off_sigs_i[j*NODE_PER_ROW+i][i_idx] = off_sigs_o[j*NODE_PER_ROW+k][o_idx];
                assign valid_i[j*NODE_PER_ROW+i][i_idx] = valid_o[j*NODE_PER_ROW+k][o_idx];
                assign data_i[j*NODE_PER_ROW+i][i_idx*DATA_W +: DATA_W] = data_o[j*NODE_PER_ROW+k][o_idx*DATA_W +: DATA_W];
            end
            else if (k > i) begin
                localparam i_idx = k - 1;
                localparam o_idx = i;
                assign off_sigs_i[j*NODE_PER_ROW+i][i_idx] = off_sigs_o[j*NODE_PER_ROW+k][o_idx];
                assign valid_i[j*NODE_PER_ROW+i][i_idx] = valid_o[j*NODE_PER_ROW+k][o_idx];
                assign data_i[j*NODE_PER_ROW+i][i_idx*DATA_W +: DATA_W] = data_o[j*NODE_PER_ROW+k][o_idx*DATA_W +: DATA_W];
            end
        end
        for (k = 0; k < NODE_PER_COL; k = k+1) begin // [k*NODE_PER_ROW+i] dim1
            if (k < j) begin
                localparam i_idx = k + NODE_PER_ROW - 1;
                localparam o_idx = j + NODE_PER_ROW - 2;
                assign off_sigs_i[j*NODE_PER_ROW+i][i_idx] = off_sigs_o[k*NODE_PER_ROW+i][o_idx];
                assign valid_i[j*NODE_PER_ROW+i][i_idx] = valid_o[k*NODE_PER_ROW+i][o_idx];
                assign data_i[j*NODE_PER_ROW+i][i_idx*DATA_W +: DATA_W] = data_o[k*NODE_PER_ROW+i][o_idx*DATA_W +: DATA_W];
            end
            else if (k > j) begin
                localparam i_idx = k + NODE_PER_ROW - 2;
                localparam o_idx = j + NODE_PER_ROW - 1;
                assign off_sigs_i[j*NODE_PER_ROW+i][i_idx] = off_sigs_o[k*NODE_PER_ROW+i][o_idx];
                assign valid_i[j*NODE_PER_ROW+i][i_idx] = valid_o[k*NODE_PER_ROW+i][o_idx];
                assign data_i[j*NODE_PER_ROW+i][i_idx*DATA_W +: DATA_W] = data_o[k*NODE_PER_ROW+i][o_idx*DATA_W +: DATA_W];
            end
        end
    end
end

/*
//{W,E,S,N,L}
localparam W_I = 0;
localparam W_O = 0;
localparam E_I = 1;
localparam E_O = 1;
localparam S_I = 2;
localparam S_O = 2;
localparam N_I = 3;
localparam N_O = 3;
// connect W ports
for (j = 0; j < NODE_PER_COL; j = j+1) begin
    for (i = 1; i < NODE_PER_ROW; i = i+1) begin
        assign off_sigs_i[j*NODE_PER_ROW+i][W_O] = off_sigs_o[j*NODE_PER_ROW+i-1][E_I];
        assign valid_i[j*NODE_PER_ROW+i][W_I] = valid_o[j*NODE_PER_ROW+i-1][E_O];
        assign data_i[j*NODE_PER_ROW+i][W_I*DATA_W +: DATA_W] = data_o[j*NODE_PER_ROW+i-1][E_O*DATA_W +: DATA_W];
    end
    // i = 0
    assign off_sigs_i[j*NODE_PER_ROW+0][W_O] = 0;
    assign valid_i[j*NODE_PER_ROW+0][W_I] = 0;
    assign data_i[j*NODE_PER_ROW+0][W_I*DATA_W +: DATA_W] = 0;
end


// connect E ports
for (j = 0; j < NODE_PER_COL; j = j+1) begin
    for (i = 0; i < NODE_PER_ROW-1; i = i+1) begin
        assign off_sigs_i[j*NODE_PER_ROW+i][E_O] = off_sigs_o[j*NODE_PER_ROW+i+1][W_I];
        assign valid_i[j*NODE_PER_ROW+i][E_I] = valid_o[j*NODE_PER_ROW+i+1][W_O];
        assign data_i[j*NODE_PER_ROW+i][E_I*DATA_W +: DATA_W] = data_o[j*NODE_PER_ROW+i+1][W_O*DATA_W +: DATA_W];
    end
    // i = NODE_PER_ROW-1
    assign off_sigs_i[j*NODE_PER_ROW+NODE_PER_ROW-1][E_O] = 0;
    assign valid_i[j*NODE_PER_ROW+NODE_PER_ROW-1][E_I] = 0;
    assign data_i[j*NODE_PER_ROW+NODE_PER_ROW-1][E_I*DATA_W +: DATA_W] = 0;
end

// connect S ports
for (j = 1; j < NODE_PER_COL; j = j+1) begin
    for (i = 0; i < NODE_PER_ROW; i = i+1) begin
        assign off_sigs_i[j*NODE_PER_ROW+i][S_O] = off_sigs_o[(j-1)*NODE_PER_ROW+i][N_I];
        assign valid_i[j*NODE_PER_ROW+i][S_I] = valid_o[(j-1)*NODE_PER_ROW+i][N_O];
        assign data_i[j*NODE_PER_ROW+i][S_I*DATA_W +: DATA_W] = data_o[(j-1)*NODE_PER_ROW+i][N_O*DATA_W +: DATA_W];
    end
end
// j = 0
for (i = 0; i < NODE_PER_ROW; i = i+1) begin
    assign off_sigs_i[0*NODE_PER_ROW+i][S_O] = 0;
    assign valid_i[0*NODE_PER_ROW+i][S_I] = 0;
    assign data_i[0*NODE_PER_ROW+i][S_I*DATA_W +: DATA_W] = 0;
end

// connect N ports
for (j = 0; j < NODE_PER_COL-1; j = j+1) begin
    for (i = 0; i < NODE_PER_ROW; i = i+1) begin
        assign off_sigs_i[j*NODE_PER_ROW+i][N_O] = off_sigs_o[(j+1)*NODE_PER_ROW+i][S_I];
        assign valid_i[j*NODE_PER_ROW+i][N_I] = valid_o[(j+1)*NODE_PER_ROW+i][S_O];
        assign data_i[j*NODE_PER_ROW+i][N_I*DATA_W +: DATA_W] = data_o[(j+1)*NODE_PER_ROW+i][S_O*DATA_W +: DATA_W];
    end
end
// j = NODE_PER_COL-1
for (i = 0; i < NODE_PER_ROW; i = i+1) begin
    assign off_sigs_i[(NODE_PER_COL-1)*NODE_PER_ROW+i][N_O] = 0;
    assign valid_i[(NODE_PER_COL-1)*NODE_PER_ROW+i][N_I] = 0;
    assign data_i[(NODE_PER_COL-1)*NODE_PER_ROW+i][N_I*DATA_W +: DATA_W] = 0;
end
*/

for (j = 0; j < NODE_PER_COL; j = j+1) begin
    for (i = 0; i < NODE_PER_ROW; i = i+1) begin
        router #( 
            .DATA_W(DATA_W),
            .FIFO_DEPTH(FIFO_DEPTH),
            .NODE_PER_ROW(NODE_PER_ROW),
            .NODE_PER_COL(NODE_PER_COL),
            .INPORT(INPORT),
            .OUTPORT(OUTPORT),
            
            .curr_dim0(i), .curr_dim1(j)
        ) router_inst
            ( .clk(clk), .rst(rst),
            .valid_i(valid_i[j*NODE_PER_ROW+i]), 
            .data_i(data_i[j*NODE_PER_ROW+i]), 
            .off_sigs_i(off_sigs_i[j*NODE_PER_ROW+i]),
            
            .valid_o(valid_o[j*NODE_PER_ROW+i]), 
            .data_o(data_o[j*NODE_PER_ROW+i]), 
            .off_sigs_o(off_sigs_o[j*NODE_PER_ROW+i])
            );
    end
end

endmodule
