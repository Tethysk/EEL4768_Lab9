// Author: Matthew Otto
// Last modified: 2017/07/31
// Module name: mips_tb
// Module Desc: test bench for mips.v
// Internal parameters:
//		none
//	Test Vector Files:
//		copy_table.txt - contains test vectors
//		copy_table_data.txt - contains data for the test vector
 
`include "mips.v"
module mips_tb();

 reg CLK, wReset;
 reg [15:0] tick = 0;
 reg [15:0] i;
 reg [31:0] instructions[ 0:1023];
 reg [63:0] pMem[0:16];
 reg [31:0] memAddr;
 
 parameter INSTADDR = 32'h0040_0000;
 parameter INSTSIZE = 4096;
 
 parameter DATAADDR = 32'h1000_0000;
 parameter DATASIZE = 4096;
 
initial begin // set all registers and memory initially to 0xFF
	i=0;
	memAddr=0;

	for (i=0; i<INSTSIZE;i=i+1)
	   uut.instMemory.memory[INSTADDR+i] = 8'hFF;
	
	for (i=0; i<DATASIZE;i=i+1)
	   uut.dataMemory.memory[DATAADDR+i] = 8'hFF;
	
	for (i=1; i<32;i=i+1)
	   uut.registerFile.registers[i] = 32'hFFFFFFFF;
	   
end
 
initial begin // initialize instruction memory and programemAddrmemory
    $dumpfile ("mips.vcd"); 
	$dumpvars; 
	
	$readmemh("copy_table.txt", instructions);
	$readmemh("copy_table_data.txt", pMem);
	
	//load in instruction memory
	i = 0;
	while (instructions[i][0] !== 1'bX) begin
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
	
	// load programemAddrmemory
	i = 0;
	while (instructions[i][0] !== 1'bX) begin
		uut.dataMemory.memory[pMem[i][63:32]] = pMem[i][7:0];
		uut.instMemory.memory[pMem[i][63:32]+1] = pMem[i][15:8];
		uut.instMemory.memory[pMem[i][63:32]+2] = pMem[i][23:16];
		uut.instMemory.memory[pMem[i][63:32]+3] = pMem[i][31:24];
		i = i+1;
	end
end 
 
// Operate the clock
always begin
	CLK = 0;
	#5
	CLK = 1;
	#5
	
	//display low registers
	$display("Tick %0d PC:%h Inst:%h Next:%h", tick, uut.wPC, uut.wInstr, uut.wNextPC);
	//$display("    R 0:  0 %h", uut.registerFile.registers[0]);
	//$display("    R 1: at %h", uut.registerFile.registers[1]);
	//$display("    R 2: v0 %h", uut.registerFile.registers[2]);
	//$display("    R 3: v1 %h", uut.registerFile.registers[3]);
	//$display("    R 4: v2 %h", uut.registerFile.registers[4]);
	//$display("    R 5: v3 %h", uut.registerFile.registers[5]);
	//$display("    R 6: v4 %h", uut.registerFile.registers[6]);
	//$display("    R 7: v5 %h", uut.registerFile.registers[7]);	
	
	// t0-t7 registers
	for (i=8;i<16;i=i+1) begin
		//$display("    R%2d: t%0d %h", i, i-8, uut.registerFile.registers[i]);
	end
	
	// s0-s7 registers
	for (i=16;i<24;i=i+1) begin
		//$display("    R%2d: s%0d %h", i, i-16, uut.registerFile.registers[i]);
	end
		
//  display high registers
//	$display("    R24: t8 %h", uut.registerFile.registers[24]);
//	$display("    R25: t9 %h", uut.registerFile.registers[25]);
//	$display("    R26: k0 %h", uut.registerFile.registers[26]);
//	$display("    R27: k1 %h", uut.registerFile.registers[27]);
//	$display("    R28: gp %h", uut.registerFile.registers[28]);
//	$display("    R29: sp %h", uut.registerFile.registers[29]);
//	$display("    R30: fp %h", uut.registerFile.registers[30]);
//	$display("    R31: ra %h", uut.registerFile.registers[31]);

	$display("Address          +0       +4       +8       +c      +10      +14      +18      +1c");
    memAddr= 32'h10010000;
    for (i = 0; i < 3; i = i + 1) begin
        $display("%8h | %2h%2h%2h%2h %2h%2h%2h%2h %2h%2h%2h%2h %2h%2h%2h%2h %2h%2h%2h%2h %2h%2h%2h%2h %2h%2h%2h%2h %2h%2h%2h%2h", memAddr,
            uut.dataMemory.memory[memAddr+3], uut.dataMemory.memory[memAddr+2], uut.dataMemory.memory[memAddr+1], uut.dataMemory.memory[memAddr],
            uut.dataMemory.memory[memAddr+7], uut.dataMemory.memory[memAddr+6], uut.dataMemory.memory[memAddr+5], uut.dataMemory.memory[memAddr+4],
            uut.dataMemory.memory[memAddr+11], uut.dataMemory.memory[memAddr+10], uut.dataMemory.memory[memAddr+9], uut.dataMemory.memory[memAddr+8],
            uut.dataMemory.memory[memAddr+15], uut.dataMemory.memory[memAddr+14], uut.dataMemory.memory[memAddr+13], uut.dataMemory.memory[memAddr+12],
            uut.dataMemory.memory[memAddr+19], uut.dataMemory.memory[memAddr+18], uut.dataMemory.memory[memAddr+17], uut.dataMemory.memory[memAddr+16],
            uut.dataMemory.memory[memAddr+23], uut.dataMemory.memory[memAddr+22], uut.dataMemory.memory[memAddr+21], uut.dataMemory.memory[memAddr+20],
            uut.dataMemory.memory[memAddr+27], uut.dataMemory.memory[memAddr+26], uut.dataMemory.memory[memAddr+26], uut.dataMemory.memory[memAddr+25],
            uut.dataMemory.memory[memAddr+31], uut.dataMemory.memory[memAddr+30], uut.dataMemory.memory[memAddr+29], uut.dataMemory.memory[memAddr+28],
        );
       
        memAddr= memAddr+ 6'h20;
    end
	tick = tick+1;
//  Add code to print a specific set of memory addresses fromemAddrdata memory.	
	
end

// Reset programemAddrcounter and terminate after specified time
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