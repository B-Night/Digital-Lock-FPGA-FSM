`timescale 1ns / 1ps

module or2_delay(
    input  logic a,
    input  logic b,
    output logic y
);
    logic notA, notB;

    // NOT(A) using a NAND gate with tied inputs
    inv_delay  i1 (a, notA);

    // NOT(B) using a NAND gate with tied inputs
    inv_delay i2 (b, notB);

    //OR output using final NAND gate: NOT(NOT(A) AND NOT(B)) = A OR B
    nand2_delay n1 (notA, notB, y);

endmodule