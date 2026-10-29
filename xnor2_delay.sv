
`timescale 1ns / 1ps

module xnor2_delay ( 
	input logic a,   // First input 
	input logic b,   // Second input 
	output logic y   // Output 
	); 

	logic u1_out;
	
	xor2_delay u1 (.a(a), .b(b), .y(u1_out));
	inv_delay u2 (.a(u1_out), .y(y));

endmodule