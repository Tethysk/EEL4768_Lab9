// Author: David Foster
// Last modified: 11/15/2016
// Module name: register
// Module Desc: 32-bit (default) PIPO regsiter with write enable
// Inputs: 
//		dataIn - 32-bit (default) bit input value
//		dataOut - 32-bit (default) bit output value
//		clk - system clock
// Outputs: PC - current value of PC
// Internal parameters: 
//		1st:WIDTH - size of address, defaults to 32
// Function: standard Program Counter

module register(
	input wire [WIDTH-1:0] dataIn, 
	output reg [WIDTH-1:0] dataOut, 
	input clk, 
	input writeEN
);
parameter WIDTH = 32;


always @ (posedge clk)
begin
	if (clk == 1)
		dataOut = dataIn;
end
endmodule
