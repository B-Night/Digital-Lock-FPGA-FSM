`timescale 1ns/1ps

module and2_delay ( 
	input logic a,   // First input 
	input logic b,   // Second input 
	output logic y   // Output 
	); 

logic u1_out;

nand2_delay u1 (.a(a), .b(b), .y(u1_out));

nand2_delay u2 (.a(u1_out), .b(u1_out), .y(y));

endmodule
