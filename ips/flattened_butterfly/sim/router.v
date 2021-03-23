`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: GaTech ECE
// Engineer: Xingyang (Xandy) Liu
// 
// Create Date: 04/05/2019 01:09:27 PM
// Design Name: 
// Module Name: router
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

module router #(
    parameter DATA_W = 8,
    parameter FIFO_DEPTH = 8,
    parameter NODE_PER_ROW = 4,
    parameter NODE_PER_COL = 4,
    parameter INPORT = 7, //including local port
    parameter OUTPORT = 7, //including local port
    
    parameter curr_dim0 = 0,
    parameter curr_dim1 = 0
) (
    input clk,
    input rst,
    
    input [0:INPORT-1] valid_i,
    input [0:INPORT*DATA_W-1] data_i,
    input [0:OUTPORT-1] off_sigs_i,
    
    output reg [0:OUTPORT-1] valid_o,
    output [0:OUTPORT*DATA_W-1] data_o,
    output [0:INPORT-1] off_sigs_o
    );

localparam DIM0_W = $clog2(NODE_PER_ROW);
localparam DIM1_W = $clog2(NODE_PER_COL);

wire [0:INPORT*DATA_W-1] fifo_o;
reg [0:INPORT-1] rd_en;
wire [0:INPORT-1] fifo_invalid;
wire [0:INPORT*OUTPORT-1] request_inport;
wire [0:OUTPORT*INPORT-1] request_outport, grant_outport;

genvar v, w;
integer i, j;

// rd_en
always@(*) begin
    for(i = 0; i<INPORT; i=i+1) begin
        rd_en[i] = 'd0;
        for(j = 0; j<OUTPORT; j=j+1) begin
            rd_en[i] = rd_en[i] | grant_outport[j*INPORT+i];
        end
    end
end

// valid_o
always@(*) begin
    for(i = 0; i<OUTPORT; i=i+1) begin
        valid_o[i] = 'd0;
        for(j = 0; j<INPORT; j=j+1) begin
            valid_o[i] = valid_o[i] | grant_outport[i*INPORT+j];
        end
    end
end

// transform request_inport to request_outport

for(v = 0; v<OUTPORT; v=v+1) begin
    for(w = 0; w<INPORT; w=w+1) begin
        assign request_outport[INPORT*v + w] = request_inport[OUTPORT*w + v];
    end
end    

for(v = 0; v<INPORT; v=v+1) begin
    fifo #( .DATA_W(DATA_W), .DEPTH(FIFO_DEPTH)
    ) fifo_inst ( .clk(clk), .rst(rst),
        .wr_en(valid_i[v]),
        .rd_en(rd_en[v]),
        .data_i(data_i[DATA_W*v +: DATA_W]),
        .empty(fifo_invalid[v]),
        .almost_full(off_sigs_o[v]),
        .data_o(fifo_o[DATA_W*v +: DATA_W])
        );
end

for(v = 0; v<INPORT; v=v+1) begin
    route_compute #( 
        .NODE_PER_ROW(NODE_PER_ROW), .NODE_PER_COL(NODE_PER_COL),
        .curr_dim0(curr_dim0), .curr_dim1(curr_dim1)
    ) route_compute_inst (
        .valid(~fifo_invalid[v]),
        .dest_node(fifo_o[DATA_W*v +: DIM0_W+DIM1_W]), 
        .request_vec(request_inport[OUTPORT*v +: OUTPORT])
        );
end

for(v = 0; v<OUTPORT; v=v+1) begin
    roundrobin_arbiter #(
        .INPORT(INPORT)
    ) rr_arbiter_inst ( .clk(clk), .rst(rst),
        .off_sig(off_sigs_i[v]),
        .requests(request_outport[v*INPORT +: INPORT]),
        .grants_out(grant_outport[v*INPORT +: INPORT])
        );
end

xbar #( .DATA_W(DATA_W),
        .INPORT(INPORT),
        .OUTPORT(OUTPORT)
) xbar_inst (
    .select_array(grant_outport),
    .data_i_array(fifo_o),
    .data_o_array(data_o)
    );

 
endmodule
