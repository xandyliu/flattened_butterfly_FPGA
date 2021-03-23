`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: GaTech ECE
// Engineer: Xingyang (Xandy) Liu
// 
// Create Date: 04/07/2019 01:45:51 PM
// Design Name: 
// Module Name: route_compute
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


module route_compute #(
    parameter NODE_PER_ROW = 4,
    parameter NODE_PER_COL = 4,
    
    parameter DESTID_W = $clog2(NODE_PER_ROW*NODE_PER_ROW),
    parameter OUTPORT = NODE_PER_ROW + NODE_PER_COL -1,
    
    parameter curr_dim0 = 1,
    parameter curr_dim1 = 1
)(
    input valid,
    input [DESTID_W-1:0] dest_node,
    output reg [0:OUTPORT-1] request_vec
    );

localparam OUTPORT_IDX_W = $clog2(OUTPORT);
localparam DIM0_W = $clog2(NODE_PER_ROW);
localparam DIM1_W = $clog2(NODE_PER_COL);

wire [DIM0_W-1:0] dim0_idx;
wire [DIM1_W-1:0] dim1_idx;
reg [0: OUTPORT_IDX_W-1] outport_idx;
wire [0:OUTPORT-1] outport_onehot;

assign dim0_idx = dest_node[0 +: DIM0_W];
assign dim1_idx = dest_node[DIM0_W +: DIM1_W];

always@(*) begin
    if(dim0_idx < curr_dim0) begin
        outport_idx <= {{(OUTPORT_IDX_W - DIM0_W){1'b0}}, dim0_idx}; // W
    end
    else if (dim0_idx > curr_dim0) begin
        outport_idx <= {{(OUTPORT_IDX_W - DIM0_W){1'b0}}, (dim0_idx-1) }; // E
    end
    else begin
        if(dim1_idx < curr_dim1) begin
            outport_idx <= {{(OUTPORT_IDX_W - DIM1_W){1'b0}}, dim1_idx} + 2**DIM0_W - 1; // S
        end
        else if (dim1_idx > curr_dim1) begin
            outport_idx <= {{(OUTPORT_IDX_W - DIM1_W){1'b0}}, dim1_idx} + 2**DIM0_W - 2; // N
        end
        else begin
            outport_idx <= OUTPORT-1; // local outport
        end
    end
end

always @ (*) begin
    if (~valid) begin
        request_vec <= 0;
    end
    else begin
        request_vec <= outport_onehot;
    end
end

to_onehot #(
    .IDX_W(OUTPORT_IDX_W),
    .OUTPORT(OUTPORT)
) to_onehot_inst (
    .idx_i(outport_idx),
    .onehot_o(outport_onehot)
    );

endmodule

module to_onehot #(
    parameter IDX_W = 3,
    parameter OUTPORT = 7
) (
    input [0:IDX_W-1] idx_i,
    output reg [0:OUTPORT-1] onehot_o
    );

genvar i;
for ( i=0; i<OUTPORT; i = i+1) begin
    always@(*)begin
        if(idx_i == i) begin
            onehot_o[i] <= 'b1;
        end
        else begin
            onehot_o[i] <= 'b0;
        end
    end
end

endmodule
