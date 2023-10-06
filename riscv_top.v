module riscv_top
(
	input clk,
	input pre_pre_reset,
	
	output [31: 0] alu_out
);

	reg reset, pre_reset;

	always @(posedge clk)
	begin
		pre_reset <= pre_pre_reset;
		reset <= pre_reset;
	end

	alu ALU
	(
		.clk(clk),
		.reset(reset),
		.rs1_data_in(rs1_data_in),
		.rs2_data_in(rs2_data_in),
		
		.alu_out(alu_out)
	);

endmodule
