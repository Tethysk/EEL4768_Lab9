// Author: David Foster
// Last modified: 11/10/2016
// Module name: instmem
// Module Desc: instruction memory for single-cycle 32-bit RISC system
// Inputs: addr - 32-bit address 
// Outputs: data - 32-bit data located at memory address specified by addr, provided asynchronously
// Internal parameters:
//		STARTADDR - 32-bit starting address for the memory
//		LENGTH - number of bytes in the memory
// Notes: As RISC instruction memory, only addresses evenly divisible by 4 are expected. The module
// will truncate the lower to bits and only provide instructions that are aligned.



module instmem(
addr,	// 32-bit memory address
data	// 32-bit memory contents
);
parameter STARTADDR = 32'h0040_0000;
parameter LENGTH = 32'h0000_1000; // in bytes

input [31:0] addr;
output [31:0] data;
wire [31:0] addr;
wire [31:0] data;

// Note that since the memory is accessed in groups of 4-bytes, the address is internally divided by 4.
reg [7:0] memory[STARTADDR:STARTADDR+LENGTH -1];

// instruction stored as little endian
assign	data = {memory[{addr[31:2],2'b11}],memory[{addr[31:2],2'b10}],memory[{addr[31:2],2'b01}],memory[{addr[31:2],2'b00}]};  


endmodule




