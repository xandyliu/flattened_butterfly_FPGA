`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: GaTech ECE
// Engineer: Xingyang (Xandy) Liu
// 
// Create Date: 04/10/2019 12:45:03 PM
// Design Name: 
// Module Name: xbar
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


module xbar #(
    parameter DATA_W = 8,
    parameter INPORT = 5,
    parameter OUTPORT = 5
) (
    input [0:OUTPORT*INPORT-1] select_array,
    input [0:INPORT*DATA_W-1] data_i_array,
    output [0:OUTPORT*DATA_W-1] data_o_array
    );

genvar i;
for (i = 0; i < OUTPORT; i = i+1) begin
    MUX #(
        .DATA_W(DATA_W),
        .INPORT(INPORT),
        .OUTPORT(OUTPORT)
    ) MUX_inst(
        .select(select_array[i*INPORT +: INPORT]), 
        .data_i(data_i_array), 
        .data_o(data_o_array[i*DATA_W +: DATA_W])
        );
end

endmodule

module MUX #(
    parameter DATA_W = 8,
    parameter INPORT = 5,
    parameter OUTPORT = 5
) (
    input [0:INPORT-1] select,
    input [0:INPORT*DATA_W-1] data_i,
    output reg [0:DATA_W-1] data_o
    );

integer i;

always @ (*) begin
    data_o = 'd0;
    for(i = 0; i < INPORT; i = i+1) begin
        if (select[i]) begin
            data_o = data_i[i*DATA_W +: DATA_W];
        end
    end
end

endmodule

