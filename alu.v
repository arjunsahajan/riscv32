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

	parameter R_INSRUCTIONS = 7'b0110011;
	parameter I_INSTRUCTIONS_JALR = 7'b1100111;
	parameter I_INSTRUCTIONS_LB_TO_LHU = 7'b0000011;
	parameter I_INSTRUCTIONS_ADDI_TO_SRAI =  7'b0010011;
	
	parameter ADD_SUB_FUNCT3 = 3'b000;
	parameter SLL_FUNCT3 = 3'b001;
	parameter SLT_FUNCT3 = 3'b010;
	parameter SLTU_FUNCT3 = 3'b011;
	parameter XOR_FUNCT3 = 3'b100;
	parameter SRL_SRA_FUNCT3 = 3'b101;
	parameter OR_FUNCT3 = 3'b110;
	parameter AND_FUNCT3 = 3'b111;
	
	parameter ADD_FUNCT7 = 7'b0000000;
	parameter SUB_FUNCT7 = 7'b0100000;
	parameter SRL_FUNCT7 = 7'b0000000;
	parameter SRA_FUNCT7 = 7'b0100000;
	
	reg [31:0] alu_temp = 0;               
	wire [2:0] func3 = {iw_in[14:12]};     
	wire [6:0] func7 = {iw_in[31:25]};      
	wire [4:0] shamt = {iw_in[24:20]};      
	wire [6:0] opcde = {iw_in[6:0]};        
	wire [6:0] i1    = {iw_in[31:25]};     

	always @ (*)
		begin                              
			case (opcde)
        
				R_INSRUCTIONS:                                                             
            begin
					case (func3)
						ADD_SUB_FUNCT3:                                                         
							begin
								case (func7)
									ADD_FUNCT7: alu_temp = rs1_data_in + rs2_data_in; 
									
									SUB_FUNCT7: alu_temp = rs1_data_in - rs2_data_in;       
                           
									default:    alu_temp = 32'b0;                     
                        endcase
							end
							
						SLL_FUNCT3: alu_temp = rs1_data_in << (rs2_data_in & 16'h1F);
						
						SLT_FUNCT3:
						begin
						  if (signed'(rs1_data_in) < signed'(rs2_data_in))
								 alu_temp = 32'd1;
							else
								 alu_temp = 32'd0;
						end
						
						SLTU_FUNCT3:
						begin
							if (rs1_data_in < rs2_data_in)
								 alu_temp = 32'd1;                                     
							else
								 alu_temp = 32'd0;
						end
						
						XOR_FUNCT3: rs1_data_in ^ rs2_data_in;
						
						SRL_SRA_FUNCT3:
						begin
							case(funct7)
								SRL_FUNCT7: alu_temp = rs1_data_in >> rs2_data_in;
								
								SRA_FUNCT7: alu_temp = rs1_data_in >>> rs2_data_in;
								
								default:    alu_temp = 32'b0;
							endcase
						end
						
						OR_FUNCT3: alu_temp = rs1_data_in | rs2_data_in;
						
						AND_FUNCT3: rs1_data_in & rs2_data_in;
						
						default: alu_temp = 32'b0; 
						
					endcase
				end
				
				I_INSTRUCTIONS_JALR: alu_temp = pc_in + 32'd4;
				
				I_INSTRUCTIONS_LB_TO_LHU:
				
				I_INSTRUCTIONS_ADDI_TO_SRAI:

			endcase
		end

endmodule
