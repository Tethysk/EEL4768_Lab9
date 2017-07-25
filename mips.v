/* Author: David Foster
   Last Modified: 4/17/2016
   Module Name: mips
   Module Desc: 32 bit single-cycle datapath for simplified MIPS
   Inputs: 
  		CLK - system clk
  		resetPC - sets program counter to start of stored program
   Outputs: none
   Internal parameters:
  		none
   Notes: Implements basic instructions. Needs additional HW for link-type operations
*/

`include "instmem.v"
`include "regfile.v"
`include "extender.v"
`include "pc.v"
`include "datamem.v"
`include "muxes.v"
`include "alu.v"
`include "controlunit.v"


module mips(
input CLK,
input reset
);

wire [31:0] wNextPC;
wire [31:0] wPC;
wire [31:0] wInstr;  // 32-bit undecoded instruction from inst. mem.
wire [31:0] wExtImm; // extended immediate value from instruction
wire [31:0] wDataMem; // direct output of data memory
wire [31:0] wDataMemExt; // byte or half word extended data from data mem
wire wDataExtSign, wDataExtByte, wImmExtSign;
wire CLK, resetPC;
wire [31:0] wResult,wALUResult;
wire [1:0] wMemMUXS; // select line for memMUX, 0 for direct ALU value, 1 for extended version
wire wBranchMUXS;
wire [31:0] wNonJumpAddr;  // routes calculated PC destination to branch MUX before PC
wire [4:0] wRegDest;
wire [1:0] wRegDestMUXS;
wire [1:0] wJumpMUXS;
wire [31:0] wData1, wData2, wInA, wInB;
wire wAluSrcAMUXS,wAluSrcBMUXS;
wire wRegWriteEN;
wire [3:0] wAluOp;
wire wZero;
wire wDataWriteEN;
wire wDataWriteByte; 
wire wDataWriteHalf;


pc pccounter(
.NextPC (wNextPC),
.Clk	(CLK),
.PC		(wPC)
);

instmem #(32'h0040_0000,4096) instMemory(
	.addr	(wPC),
	.data	(wInstr)
);

extender immExtender(
	.D		(wInstr[15:0]),
	.Sign	(wImmExtSign),
	.Byte	(1'b0),
	.Y		(wExtImm)
);

extender dataExtender(
	.D		(wDataMem[15:0]),
	.Sign	(wDataExtSign),
	.Byte	(wDataExtByte),
	.Y		(wDataMemExt)
);

mux41 memMUX(
	.D0	(wDataMem),   
	.D1 (wDataMemExt),
	.D2 (wALUResult),
	.D3 (PC+4),
	.S	(wMemMUXS),
	.Y	(wResult)
);

mux21 branchMUX(
	.D0	(wPC + 4),
	.D1	(wPC + 4 + (wExtImm<<2)),
	.S	(wBranchMUXS && wZero),
	.Y	(wNonJumpAddr)
);

mux41 jumpMUX(
	.D0	(wNonJumpAddr),
	.D1	(wInstr[25:0]<<2),  // jump is in multiple of instruction length in bytes
	.D2 (wData1),
	.D3 (32'h00400000),
	.S	(wJumpMUXS),
	.Y	(wNextPC)
);

mux41 #(5) regDestMUX(   // routing registers needs only 5 bits
	.D0		(wInstr[20:16]),	// reg t
	.D1		(wInstr[15:11]),	// reg d
	.D2		(5'd31),            // reg $ra
	.S		(wRegDestMUXS), 
	.Y		(wRegDest)
);

mux21 aluSrcAMUX(
	.D0		(wData1),	// direct from register file
	.D1		({27'b0,wInstr[10:6]}),	// number of bits to shift
	.S		(wAluSrcAMUXS),
	.Y		(wInA)
);

mux21 aluSrcBMUX(
	.D0		(wData2),	// direct from register file
	.D1		(wExtImm),	// extended immediate value
	.S		(wAluSrcBMUXS),
	.Y		(wInB)
);

regfile registerFile(
	.input1 (wInstr[25:21]),
	.input2 (wInstr[20:16]),
	.writeReg (wRegDest),
	.writeEN (wRegWriteEN),
	.clk (CLK),
	.writeData (wResult),
	.data1 (wData1),
	.data2 (wData2)
);

alu mipsalu(
	.inA		(wInA),
	.inB		(wInB),	
	.operation	(wAluOp),
	.result	( wALUResult), 
	.zero (wZero)
);

datamem #(32'h1001_0000,4096) dataMemory(
	.address (wALUResult),		
	.datain (wData2),			
	.WE (wDataWriteEN),				
	.clk (CLK),			
	.writebyte (wDataWriteByte), 		 
	.writehalfword (wDataWriteHalf), 	
	.data (wDataMem)			
);

controlunit mipsControlUnit(
.opcode (wInstr[31:26]),
.funct (wInstr[5:0]),
.rt0 (wInstr[16]),
.reset (reset),
.regDestMUXS (wRegDestMUXS), 
.regWriteEN (wRegWriteEN),
.aluSrcAMUXS (wAluSrcAMUXS), 
.aluSrcBMUXS (wAluSrcBMUXS), 
.aluOp (wAluOp),
.dataWriteEN (wDataWriteEN),
.dataWriteByte (wDataWriteByte),
.dataWriteHalf (wDataWriteHalf),
.immExtSign (wImmExtSign),
.dataExtSign (wDataExtSign),
.dataExtByte (wDataExtByte),
.memMUXS (wMemMUXS),	 
.branchMUXS (wBranchMUXS),	
.jumpMUXS (wJumpMUXS) 
);

endmodule























