`timescale 1ns/1ps

module mux2to1_slice
  (   input  logic a,
      input  logic b,
      input  logic s,
      output logic y
      );

   logic 	   u1_out;
   logic 	   u2_out;
   logic 	   s_inv;


   nand2_delay U0 (
                   .a(s),
                   .b(s),
                   .y(s_inv)
		   );

   nand2_delay U1 (
                   .a(a),
                   .b(s_inv),
                   .y(u1_out)
		   );

   nand2_delay U2 (
                   .a(b),
                   .b(s),
                   .y(u2_out)
		   );

   nand2_delay U3 (
                   .a(u1_out),
                   .b(u2_out),
                   .y(y)
		   );


endmodule