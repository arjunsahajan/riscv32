module alu
(
	input clk,  															
	input reset, wb_en_in,                             
	input [4:0] wb_reg_in,
	input [31:0] pc_in, iw_in, rs1_data_in, rs2_data_in,    
	input w_en_in,                                          

	output reg [31:0] alu_out, iw_out, pc_out,              
	output reg [4:0] wb_reg_out,
	output wk_en_out,

	output w_en_out,                                        
	output reg [31:0] rs2_data_out,                        

	output df_ex_enable,     				
	output reg [4:0] df_ex_reg,         
	output reg [31:0] df_ex_data       
);

	parameter ADD_SUB = 7'b0110011;
	
	parameter ADD_SUB_FUNCT3 = 3'b000;
	
	parameter ADD_FUNCT7 = 7'b0000000;
	parameter SUB_FUNCT7 = 7'b0100000;
	
	reg [31:0] alu_temp = 0;               
	wire [2:0] func3 = {iw_in[14:12]};     
	wire [6:0] func7 = {iw_in[31:25]};      
	wire [4:0] shamt = {iw_in[24:20]};      
	wire [6:0] opcde = {iw_in[6:0]};        
	wire [6:0] i1    = {iw_in[31:25]};     

	always @ (*)
		begin                              
			case (opcde)
        
				ADD_SUB:                                                             
            begin
					case (func3)
						ADD_SUB_FUNCT3:                                                         
							begin
								case (func7)
									ADD_FUNCT7: alu_temp = rs1_data_in + rs2_data_in;       
									SUB_FUNCT7: alu_temp = rs1_data_in - rs2_data_in;       
                           default:    alu_temp = rs1_data_in;                     
                        endcase
							end
					endcase
				end
			endcase
		end

endmodule
