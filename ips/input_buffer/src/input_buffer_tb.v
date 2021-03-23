`timescale 1ns / 1ps

module input_buffer_tb();

    parameter DATA_W = 8;
    parameter TEST_CASES = 5;
    parameter mem_file = "test.mem";

/**************Internal signal declarations*****/
reg clk = 1'b0;
reg en = 1'b0;


wire [DATA_W-1:0]data;
wire valid;



/**************DUT******************************/
input_buffer dut(
	.clk(clk),
	.en(en),
	.data(data),
	.valid(valid)
	);
/**************STIMULI******************************/
initial begin
	# 10;
	en = 1'b1;
	# 15;
	# 30;
	# 20;
	# 20;
	# 10;
	en = 1'b0;	

end

/*****Address generator Generator******/
/*always @(posedge clk ) begin
	if (en == 1 && m_axis_tready == 1) begin
		if(addr < buf_depth -1) addr <= addr + 1;
		else addr <= { buf_addr_size {1'b0} };
	end
end*/

/*****Clk Generator******/
always 
	 #5 clk <= !clk;


endmodule 