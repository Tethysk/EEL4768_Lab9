// Author: David Foster
// Last modified: 11/10/2016
// Module name: alu
// Version 1.1
// Module Desc: ALU for single-cycle 32-bit RISC system
// Inputs: 	inA - One 32-bit operand input 
//			inB - Second 32-bit operand input
//			operation - 4-bit alu operation, see alu_ops.txt for listing 
// Outputs: result - 32-bit calculated result based on inputs and operation
//			zero - set to 1 when the result is 0, used for branching
// Internal parameters:
//		alu_ops.txt provides alphanumeric names for 4-bit operations

module alu(
input [31:0] inA,
input [31:0] inB,
input [3:0] operation,
output [31:0] result, 
output zero
);
`include "alu_ops.txt"  // provides parameters for more readable operations
wire [31:0] inA, inB;
wire [3:0] operation;
wire zero;
reg [31:0] result;

always @ (inA or inB or operation)
begin
	case(operation)
		OP_ADD:  result = inA+inB;
		OP_SUB:  result = inA-inB;
		OP_AND:  result = inA & inB;
		OP_OR :  result = inA | inB;
		OP_XOR:  result = inA ^ inB;
		OP_NOR:  result = inA ~| inB;
		OP_SLT:  result = ($signed(inA)<$signed(inB))?32'b1:32'b0;
		OP_SLTU: result = (inA<inB)?32'b1:32'b0;
		OP_SLL:  result = inB << inA[4:0];
		OP_SRL:  result = inB >> inA[4:0];
		OP_SRA:  result = $signed(inB) >>> inA[4:0];
		OP_INA:  result = inA;
		OP_LUI:  result = {inB[15:0],16'b0};
		OP_NOP1: result = inA;
		OP_NOP2: result = inA;
		OP_NOP3: result = inA;
	endcase
end

assign zero = (result == 32'b0)?1:0;

endmodule