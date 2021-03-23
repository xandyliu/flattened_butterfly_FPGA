module output_buffer 
#(
    parameter DATA_W = 8,
    parameter SLOTS = 5
) 
(
	input clk,    // Clock
	input en, // Clock Enable
	input rst,
	input [DATA_W-1:0] data,
	output data_stored
);

reg [DATA_W-1:0] out_buf [SLOTS-1:0];
reg stored_reg = 1'b0;
reg [DATA_W-1:0] dataout;
integer address = 0;
//integer j = 0;
integer i = 0;

initial begin
	for (i = 0; i < SLOTS; i= i+1) begin
		out_buf[i] <= {DATA_W {1'b0}};
	end
end


always @(posedge clk) begin 
	if (rst == 1) begin
		stored_reg <= 1'b0;
		address <= 0;
		for (i = 0; i < SLOTS; i= i+1) begin
			out_buf[i] <= {DATA_W {1'b0}};
		end
	end
	else if(en == 1) begin
		stored_reg <= 1'b1;
        out_buf[address] <= data;
		address <= (address == SLOTS-1) ? 0 : address + 1; 
	end
	else stored_reg <= 1'b0;
end

assign data_stored = stored_reg;

endmodule