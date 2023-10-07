module riscv_top
(
	input clk,
	input pre_pre_reset,
	input [31: 0] iw,
	input [31: 0] rs1_data_in,
	input [31: 0] rs2_data_in,
	
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
		.iw_in(iw_in),
		.rs1_data_in(rs1_data_in),
		.rs2_data_in(rs2_data_in),
		
		.alu_out(alu_out)
	);

endmodule
