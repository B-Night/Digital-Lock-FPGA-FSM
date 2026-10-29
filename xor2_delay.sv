`timescale 1ns / 1ps

module xor2_delay ( 
	input logic a,   // First input 
	input logic b,   // Second input 
	output logic y   // Output 
	); 

logic u1_out, u2_out, u3_out;

nand2_delay u1 (.a(a), .b(b), .y(u1_out));

nand2_delay u2 (.a(a), .b(u1_out), .y(u2_out));

nand2_delay u3 (.a(b), .b(u1_out), .y(u3_out));

nand2_delay u4 (.a(u2_out), .b(u3_out), .y(y));

endmodule