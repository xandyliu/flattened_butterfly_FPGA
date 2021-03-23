`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: GaTech ECE
// Engineer: Xingyang (Xandy) Liu
// 
// Create Date: 04/07/2019 11:53:15 AM
// Design Name: 
// Module Name: fifo
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


module fifo #(
    parameter DATA_W = 8,
    parameter DEPTH = 8
)(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [0:DATA_W-1] data_i,
    output empty,
    output almost_full,
    output [0:DATA_W-1] data_o
    );
    
localparam ADDR_W = $clog2(DEPTH);

reg [0:DATA_W-1] fifo_memory [0 : DEPTH-1];

reg [0:ADDR_W-1] wr_addr;
reg [0:ADDR_W-1] rd_addr;

wire [0:ADDR_W-1] wr_addr_plus_one, wr_addr_plus_two;
wire wr_valid, rd_valid, full;

assign wr_valid =(full) ? 0 : wr_en;
assign rd_valid =(empty) ? 0 : rd_en;

genvar i;
    
always@(posedge clk) begin
    if(rst) begin
        wr_addr <= 0;
        rd_addr <= 0;
    end
    else begin
        if(wr_valid) begin
            wr_addr <= wr_addr + 1; 
        end
        if(rd_valid) begin
            rd_addr <= rd_addr + 1;
        end
    end
end

generate begin
for(i = 0; i < DEPTH; i = i+1) begin
    always@(posedge clk)
        if(rst) begin
            fifo_memory[i] <= 0;        
        end
        else begin
            if((wr_addr == i) & (wr_valid)) begin
                fifo_memory[i] <= data_i;    
            end
        end
    end
end
endgenerate

assign data_o = fifo_memory[rd_addr];

assign empty = (wr_addr == rd_addr) ? 1:0;
assign wr_addr_plus_one = wr_addr + 1;
assign wr_addr_plus_two = wr_addr + 2;
assign full = (wr_addr_plus_one == rd_addr) ? 1:0;
assign almost_full = (wr_addr_plus_two == rd_addr) ? 1:full;

endmodule
