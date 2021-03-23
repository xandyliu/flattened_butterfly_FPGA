`timescale 1ns / 1ps

module input_buffer_tb();

    parameter DATA_W = 8;
    parameter SLOTS = 5;
    parameter mem_file = "test.mem";

/**************Internal signal declarations*****/
reg clk = 1'b0;
reg en = 1'b0;
reg [DATA_W-1:0]data;
reg [DATA_W-1:0]data_buf[SLOTS-1:0];
wire data_stored;
integer addr =0;

/**************DUT******************************/
output_buffer dut(
	.clk(clk),
	.en(en),
	.data(data),
	.data_stored(data_stored)
	);
/**************STIMULI******************************/
initial begin
	$readmemb(mem_file,data_buf);
	//# 10;
	en = 1'b1;
	data <= data_buf[addr];
	# 10;
	data <= data_buf[addr];
	# 10;
	data <= data_buf[addr];
	# 10;
	data <= data_buf[addr];
	# 10;
	data <= data_buf[addr];
	# 10;
	en = 1'b0;	

end

/*****Address generator Generator******/
always @(posedge clk ) begin
	if (en == 1 ) begin
		if(addr < SLOTS -1) addr <= addr + 1;
		else addr <= 0;
	end
end

/*****Clk Generator******/
always 
	 #5 clk <= !clk;


endmodule 