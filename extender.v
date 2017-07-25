// Author: David Foster
// Last modified: 3/20/2016
// Module name: extender
// Module Desc: extends an input value to 32 bits
// Inputs: 
//		D - 16 bit number to extend
//		Sign - extends number as a signed value if 1, unsigned if 0
//		Byte - extends D as 8 bit input if 1 (bits 7:0), as 16 bit if 0
// Outputs: Y - 32 bit extended output
// Internal parameters: none
// Function: signed/unsigned extension of 1 or 2 byte input

module extender(
D,
Sign,
Byte,
Y
);

input [15:0] D;
input Sign, Byte;
output [31:0] Y;
wire [15:0] D;
wire Sign, Byte;
wire [31:0] Y;

assign Y = Sign ? (Byte ?{ {24{D[7]}},D[7:0]}:{{16{D[15]}},D[15:0]}):(Byte?{24'b0,D[7:0]}:{16'b0,D[15:0]});

endmodule