`timescale 1ns/1ps

module decoder2to4 (
    input  logic [1:0] a,  // 2-bit select input (current_digit)
    input  logic       en, // Enable signal (load_new_pin | load_enter_pin)
    output logic [3:0] y   // 4-bit one-hot encoded output (digit_enable)
);

    // Inverted select signals
    logic a0_inv;
    logic a1_inv;

    // Internal structural delay wires
    logic w0, w1, w2, w3;

    // Primitives to invert the address bits
    inv_delay inv0 (.a(a[0]), .y(a0_inv));
    inv_delay inv1 (.a(a[1]), .y(a1_inv));

    // Decode combination logic step 1 (Address matching)
    and2_delay and_dec0 (.a(a1_inv), .b(a0_inv), .y(w0)); // 00
    and2_delay and_dec1 (.a(a1_inv), .b(a[0]),   .y(w1)); // 01
    and2_delay and_dec2 (.a(a[1]),   .b(a0_inv), .y(w2)); // 10
    and2_delay and_dec3 (.a(a[1]),   .b(a[0]),   .y(w3)); // 11

    // Decode combination logic step 2 (Gating with Enable signal)
    and2_delay and_en0 (.a(w0), .b(en), .y(y[0]));
    and2_delay and_en1 (.a(w1), .b(en), .y(y[1]));
    and2_delay and_en2 (.a(w2), .b(en), .y(y[2]));
    and2_delay and_en3 (.a(w3), .b(en), .y(y[3]));

endmodule

