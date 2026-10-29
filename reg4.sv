`timescale 1ns/1ps

module reg4 #(
    parameter logic [3:0] RESET_VALUE = 4'h0
) (
    input  logic       clk,
    input  logic       rstn,
    input  logic       load,
    input  logic [3:0] d,
    output logic [3:0] q
);

    logic [3:0] d_next;
    logic [3:0] d_reg;
    logic [3:0] qn_dummy;

    // Select between the current value and new data
    mux2to1_Nbit #(.N(4)) mux_load (
        .A(q),
        .B(d),
        .s(load),
        .Y(d_next)
    );

    // Select reset value or normal operation
    mux2to1_Nbit #(.N(4)) mux_rst (
        .A(RESET_VALUE),
        .B(d_next),
        .s(rstn),
        .Y(d_reg)
    );

    // Four DFFs store the register value
    dff ff0 (
        .d(d_reg[0]),
        .clk(clk),
        .q(q[0]),
        .qn(qn_dummy[0])
    );

    dff ff1 (
        .d(d_reg[1]),
        .clk(clk),
        .q(q[1]),
        .qn(qn_dummy[1])
    );

    dff ff2 (
        .d(d_reg[2]),
        .clk(clk),
        .q(q[2]),
        .qn(qn_dummy[2])
    );

    dff ff3 (
        .d(d_reg[3]),
        .clk(clk),
        .q(q[3]),
        .qn(qn_dummy[3])
    );

endmodule
