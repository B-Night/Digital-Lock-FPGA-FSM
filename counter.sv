`timescale 1ns/1ps
`timescale 1ns/1ps

module counter (
    input  logic       clk,
    input  logic       rstn,
    input  logic       count_enable,
    output logic [1:0] count
);

    // Internal wires
    logic [1:0] next_count;
    logic [1:0] reg_in;
    logic [1:0] qn_dummy;
    
    logic       count0_inv;
    logic       count1_inv;
    logic       toggle_bit1;

    // Inverter count bits
    inv_delay inv_b0 (
        .a(count[0]),
        .y(count0_inv)
    );

    inv_delay inv_b1 (
        .a(count[1]),
        .y(count1_inv)
    );

    // Next state logic for Bit 0
    mux2to1_Nbit #(.N(1)) mux_bit0 (
        .A(count[0]),
        .B(count0_inv),
        .s(count_enable),
        .Y(next_count[0])
    );

    // Structural AND gate for Bit 1 control
    and2_delay u_and_toggle (
        .a(count_enable),
        .b(count[0]),
        .y(toggle_bit1)
    );

    // Next state logic for Bit 1
    mux2to1_Nbit #(.N(1)) mux_bit1 (
        .A(count[1]),
        .B(count1_inv),
        .s(toggle_bit1),
        .Y(next_count[1])
    );

    // Synchronous reset block
    mux2to1_Nbit #(.N(2)) mux_reset_block (
        .A(2'b00),
        .B(next_count),
        .s(rstn),
        .Y(reg_in)
    );

    // Store counter state
    dff ff0 (
        .d(reg_in[0]),
        .clk(clk),
        .q(count[0]),
        .qn(qn_dummy[0])
    );

    dff ff1 (
        .d(reg_in[1]),
        .clk(clk),
        .q(count[1]),
        .qn(qn_dummy[1])
    );

endmodule

