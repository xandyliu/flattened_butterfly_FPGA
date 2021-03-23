`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: GaTech ECE
// Engineer: Xingyang (Xandy) Liu
// 
// Create Date: 04/09/2019 09:25:02 PM
// Design Name: 
// Module Name: roundrobin_arbiter
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


module roundrobin_arbiter #(
    parameter INPORT = 5
)(
    input clk,
    input rst,
    input off_sig,
    input [0:INPORT-1] requests,
    output [0:INPORT-1] grants_out
    );

wire [0:INPORT-1] grants_raw, grants_masked, mask, requests_masked, grants;
reg [0:INPORT-1] grants_reg;

assign mask = ~((grants_reg - 1) | grants_reg );

assign requests_masked = requests & mask;

assign grants = (grants_masked == 0) ? grants_raw : grants_masked;

assign grants_out = (off_sig == 1'b1) ? 'd0 : grants;

always @ (posedge clk) begin
    if (rst) begin
        grants_reg <= 0;
    end
    else begin
        if(off_sig) begin
            grants_reg <= grants_reg;
        end
        else begin
            grants_reg <= grants;
        end
    end
end

// priority arbiter
assign grants_raw = requests & (-requests);

// priority arbiter
assign grants_masked = requests_masked & (-requests_masked);

endmodule