`timescale 1ns/1ps

module comp16 (
    input  logic [15:0] a,
    input  logic [15:0] b,
    output logic        equal
);

    // Wires for the 4 individual digit matches
    logic digit0_match;
    logic digit1_match;
    logic digit2_match;
    logic digit3_match;

    logic and_lower;
    logic and_upper;

    // 1. Instantiate four parallel 4-bit comparators
    comp4 comp_dig0 (.a(a[3:0]),   .b(b[3:0]),   .equal(digit0_match));
    comp4 comp_dig1 (.a(a[7:4]),   .b(b[7:4]),   .equal(digit1_match));
    comp4 comp_dig2 (.a(a[11:8]),  .b(b[11:8]),  .equal(digit2_match));
    comp4 comp_dig3 (.a(a[15:12]), .b(b[15:12]), .equal(digit3_match));

    // 2. Combine the results
    and2_delay u_and_low (
        .a(digit0_match),
        .b(digit1_match),
        .y(and_lower)
    );

    and2_delay u_and_high (
        .a(digit2_match),
        .b(digit3_match),
        .y(and_upper)
    );

    // Final output
    and2_delay u_and_final (
        .a(and_lower),
        .b(and_upper),
        .y(equal)
    );

endmodule
