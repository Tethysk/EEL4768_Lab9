// Author: David Foster
// Last modified: 3/21/2017
// Module name: mux21
// Module Desc: 2 to 1 32-bit (default) multiplexer
// Inputs: 
//		D0, D1 - n bit data inputs
//		S - 1 bit select line 
// Outputs: Y - n bit switched output
// Internal parameters: WIDTH, number of bits per input/output
// Function: standard MUX

module mux21(
D0,
D1,
S,
Y
);

parameter WIDTH = 32;

input [WIDTH-1:0] D0;
input [WIDTH-1:0] D1;
input S;
output [WIDTH-1:0] Y;
wire [WIDTH-1:0] D0;
wire [WIDTH-1:0] D1; 
wire S;
wire [WIDTH-1:0] Y;

assign Y = S ? D1 : D0;
endmodule

// Author: David Foster
// Last modified: 3/21/2017
// Module name: mux41
// Module Desc: 4 to 1 32-bit (default) multiplexer
// Inputs: 
//		D0, D1, D2, D3 -  data inputs
//		S - 2 bit select line 
// Outputs: Y -  switched output
// Internal parameters: WIDTH - bit size of inputs/output
// Function: standard MUX

module mux41(
D0,	// input for S = 00
D1, // input for S = 01
D2, // input for S = 10
D3, // input for S = 11
S,  // 2-bit select line
Y	// switched output
);

parameter WIDTH = 32;

input [WIDTH-1:0] D0;
input [WIDTH-1:0] D1;
input [WIDTH-1:0] D2;
input [WIDTH-1:0] D3;  
input [1:0] S;
output [WIDTH-1:0] Y;
wire [WIDTH-1:0] D0;
wire [WIDTH-1:0] D1;
wire [WIDTH-1:0] D2;
wire [WIDTH-1:0] D3;
wire [WIDTH-1:0] Y;
wire [1:0] S;

assign Y = S[1]?(S[0]? D3:D2):(S[0]?D1:D0);
endmodule








