module input_buffer 
#(
    parameter DATA_W = 8,
    parameter TEST_CASES = 5,
    parameter mem_file = "test.mem"
) 
(
	input clk,    // Clock
	input en, // Clock Enable
	input rst,
	output [DATA_W-1:0] data,
	output valid
);

reg [DATA_W-1:0] test_buf [TEST_CASES-1:0];
reg valid_reg = 1'b0;
reg [DATA_W-1:0] dataout;
integer address = 0;

initial begin
	$readmemb(mem_file,test_buf);
end


always @(posedge clk) begin 
	if (rst == 1) begin
		valid_reg <= 1'b0;
		address <= 0;
		dataout <= { DATA_W {1'b0} };
	end
	else if(en == 0) begin
		valid_reg <= 1'b1;
		dataout <= test_buf[address];
/*		if(address == TEST_CASES-1) address <= 0;
		else address <= address + 1;*/
		address <= (address == TEST_CASES-1) ? 0 : address + 1; 
	end
	else valid_reg <= 1'b0;
end

assign valid = valid_reg;
assign data = dataout;

endmodule