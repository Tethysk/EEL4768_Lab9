// Author: David Foster
// Last modified: 4/19/2016
// Module name: mips_tb
// Module Desc: test bench for mips.v
// Internal parameters:
//		none
//	Test Vector Files:
//		prog1.txt - contains test vectors
 
`include "mips.v"
module mips_tb();

 reg CLK, wReset;
 reg [15:0] tick = 0;
 reg [15:0] i;	
 reg [31:0] instructions[ 0:1023];
 
 parameter INSTADDR = 32'h0040_0000;
 parameter INSTSIZE = 4096;
 
 parameter DATAADDR = 32'h1000_0000;
 parameter DATASIZE = 4096;
 
initial begin // set all registers and memory initially to 0xFF
	for (i=0; i<INSTSIZE;i=i+1)
	   uut.instMemory.memory[INSTADDR+i] = 8'hFF;
	for (i=0; i<DATASIZE;i=i+1)
	   uut.dataMemory.memory[DATAADDR+i] = 8'hFF;
	for (i=1; i<32;i=i+1)
	   uut.registerFile.registers[i] = 32'hFFFFFFFF;
end
 
initial begin // initialize instruction memory with assembly program
    $dumpfile ("mips.vcd"); 
	$dumpvars; 
	$readmemh("prog1.txt", instructions);
	i = 0;    // used to increment index into program and instruction memory
	while (instructions[i][0] !== 1'bX)
	begin
		uut.instMemory.memory[INSTADDR+i*4] = instructions[i][7:0];
//		$display("Addr: %h  Inst:%h", INSTADDR+i,instructions[i][7:0]);
		uut.instMemory.memory[INSTADDR+i*4+1] = instructions[i][15:8];
//		$display("Addr: %h  Inst:%h", INSTADDR+i+1,instructions[i][15:8]);
		uut.instMemory.memory[INSTADDR+i*4+2] = instructions[i][23:16];
//		$display("Addr: %h  Inst:%h", INSTADDR+i+2,instructions[i][23:16]);
		uut.instMemory.memory[INSTADDR+i*4+3] = instructions[i][31:24];
//		$display("   Addr: %h  Inst:%h", INSTADDR+i*4,instructions[i] );
		i = i+1;
	end
end 
 
// Operate the clock
always begin
	CLK = 0;
	#5
	CLK = 1;
	#5
	$display("Tick %0d PC:%h Inst:%h Next:%h", tick, uut.wPC, uut.wInstr, uut.wNextPC);
//  display low registers
//		$display("    R 0:  0 %h", uut.registerFile.registers[0]);
//		$display("    R 1: at %h", uut.registerFile.registers[1]);
//		$display("    R 2: v0 %h", uut.registerFile.registers[2]);
//		$display("    R 3: v1 %h", uut.registerFile.registers[3]);
//		$display("    R 4: v2 %h", uut.registerFile.registers[4]);
//		$display("    R 5: v3 %h", uut.registerFile.registers[5]);
//		$display("    R 6: v4 %h", uut.registerFile.registers[6]);
//		$display("    R 7: v5 %h", uut.registerFile.registers[7]);	
	for (i=8;i<16;i=i+1) // t0-t7 registers
		begin
//			$display("    R%2d: t%0d %h", i, i-8, uut.registerFile.registers[i]);
		end
	for (i=16;i<24;i=i+1) // s0-s7 registers
		begin
			$display("    R%2d: s%0d %h", i, i-16, uut.registerFile.registers[i]);
		end
//  display high registers
//		$display("    R24: t8 %h", uut.registerFile.registers[24]);
//		$display("    R25: t9 %h", uut.registerFile.registers[25]);
//		$display("    R26: k0 %h", uut.registerFile.registers[26]);
//		$display("    R27: k1 %h", uut.registerFile.registers[27]);
//		$display("    R28: gp %h", uut.registerFile.registers[28]);
//		$display("    R29: sp %h", uut.registerFile.registers[29]);
//		$display("    R30: fp %h", uut.registerFile.registers[30]);
//		$display("    R31: ra %h", uut.registerFile.registers[31]);
	tick = tick+1;
//  Add code to print a specific set of memory addresses from data memory.	
	
end

// Reset program counter and terminate after specified time
initial begin
	wReset = 1;
	#8
	wReset = 0;
	#80
	$finish;
end
	
mips uut(
.CLK (CLK),
.reset (wReset)
);

endmodule