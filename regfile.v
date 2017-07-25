// Author: David Foster
// Last modified: 4/1/2016
// Module name: regfile
// Module Desc: 32 32-bit registers for RISC processor
//		two asynchronous read ports, one synchronous write port
// Inputs: 
//		input1 - 5 bit index for read port 1
//		input2 - 5 bit index for read port 2
//		writeReg - 5 bit index for write port
//		writeEN - bit enabling write on clock edge
//		writeData - 32-bit data for write port
//		clk	- clock for writing to register file
// Outputs: 
//		data1 - 32-bit output port 1
//		data2 - 32-bit output port 2
// Internal parameters:
//		none
// Notes: The write port stores data on the positive clock edge.
//			To more accurately mimic the MIPS, register 0 is hard-wired to 0


module regfile(
	input1,
	input2,
	writeReg,
	writeEN,
	clk,
	writeData,
	data1,
	data2
);

// inputs and outputs are decribed in the header comment
input [4:0] input1;
input [4:0] input2;
input writeEN;
input clk;
input [4:0] writeReg;
input [31:0] writeData;
output [31:0] data1;
output [31:0] data2;

wire [4:0] input1;
wire [4:0] writeReg;
wire [4:0] input2;
wire writeEN;
wire clk;
wire [31:0] writeData;
reg [31:0] data1;
reg [31:0] data2;

reg [31:0] registers[31:0];

initial begin  // hard-wire register 0 to 0
 registers[0] = 32'h0000_0000;
end

// write to a register if write is enabled on a positive clock edge
always @(posedge clk)
	begin
		if (writeEN === 1 & writeReg !== 5'b00000)
			registers[writeReg] = writeData;	
	end

// asynchronously output two registers 
always @(*)
begin
	data1 = registers[input1];
	data2 = registers[input2];
end

		
endmodule