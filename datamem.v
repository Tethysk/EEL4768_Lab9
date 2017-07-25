// Author: David Foster
// Last modified: 4/10/2016
// Module name: datamem
// Module Desc: data memory for single-cycle 32-bit RISC system
// Inputs: 	address - 32-bit address 
//			datain -
//			WE - 
//			clk -
//			writebyte -
//			writehalfword - 
// Outputs: data - 32-bit data located at memory address specified by addr, provided asynchronously
// Internal parameters:
//		STARTADDR - 32-bit starting address for the memory
//		LENGTH - number of bytes in the memory
// Notes: As RISC instruction memory, only addresses evenly divisible by 4 are expected. The module
// will truncate the lower to bits and only provide instructions that are aligned.

module datamem(
address,		// 32-bit memory address
datain,			// 32-bit memory contents
WE,				// Write enable
clk,			// clock, positive transition causes data write when WE = 1
writebyte, 		// write only a byte 
writehalfword, 	// write only a halfword
data			// 32-bit output
);
parameter STARTADDR = 32'h1000_0000;
parameter LENGTH = 32'h0000_1000;

input [31:0] address, datain;
input WE, clk, writebyte, writehalfword;
output [31:0] data;
wire [31:0] address, datain;
wire [31:0] data;
wire WE, clk, writebyte, writehalfword;

reg [7:0] memory[STARTADDR:STARTADDR+LENGTH -1];

assign	data = {memory[address+3],memory[address+2],memory[address+1],memory[address]};  // truncate so that address is 4-byte aligned

always @(posedge clk)
begin
	if (WE === 1) begin
		if (writebyte === 1) begin
			memory[address] = datain[7:0];
		end else if (writehalfword === 1) begin
			{memory[address+1],memory[address]} = datain[15:0];
		end else begin
			{memory[address+3],memory[address+2],memory[address+1],memory[address]} = datain;
		end
	end
end

endmodule