// Author: David Foster
// Last modified: 10/11/2016
// Module name: pc
// Module Desc: 32-bit (default) program counter
// Inputs: 
//		NextPC - 32-bit (default) bit next value
//		Clk - system clock
// Outputs: PC - current value of PC
// Internal parameters: 
//		1st:WIDTH - size of address, defaults to 32
// Function: standard Program Counter

module pc(
	NextPC, 
	Clk, 
	PC
);
parameter WIDTH = 32;


input [WIDTH-1:0] NextPC;
input Clk;

output [WIDTH-1:0] PC;

wire [WIDTH-1:0] NextPC;
wire Clk;
reg [WIDTH-1:0] PC;

always @ (posedge Clk)
begin
		PC = NextPC;
end
endmodule
