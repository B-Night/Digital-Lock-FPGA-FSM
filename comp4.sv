`timescale 1ns/1ps

module comp4 (
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic       equal
);

    // Internal wires for bit-matching results
    logic bit0_match;
    logic bit1_match;
    logic bit2_match;
    logic bit3_match;
    
    logic and_lower;
    logic and_upper;

    // Check each bit pair using XNOR gates
    xnor2_delay u_xnor0 (.a(a[0]), .b(b[0]), .y(bit0_match));
    xnor2_delay u_xnor1 (.a(a[1]), .b(b[1]), .y(bit1_match));
    xnor2_delay u_xnor2 (.a(a[2]), .b(b[2]), .y(bit2_match));
    xnor2_delay u_xnor3 (.a(a[3]), .b(b[3]), .y(bit3_match));

    // Combine results structurally using 2-input AND gates
    and2_delay u_and_low (
        .a(bit0_match),
        .b(bit1_match),
        .y(and_lower)
    );

    and2_delay u_and_high (
        .a(bit2_match),
        .b(bit3_match),
        .y(and_upper)
    );

    and2_delay u_and_last (
        .a(and_lower),
        .b(and_upper),
        .y(equal)
    );

endmodule
