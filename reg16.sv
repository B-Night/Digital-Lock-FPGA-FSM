`timescale 1ns/1ps

module reg16 #(
    parameter logic [15:0] RESET_VALUE = 16'h0000
) (
    input  logic        clk,
    input  logic        rstn,
    input  logic        load,
    input  logic [15:0] d,
    output logic [15:0] q
);

    // Instantiate four 4-bit registers, parallel
    reg4 #(.RESET_VALUE(RESET_VALUE[3:0]))   reg0 (.clk(clk), .rstn(rstn), .load(load), .d(d[3:0]),   .q(q[3:0]));
    reg4 #(.RESET_VALUE(RESET_VALUE[7:4]))   reg1 (.clk(clk), .rstn(rstn), .load(load), .d(d[7:4]),   .q(q[7:4]));
    reg4 #(.RESET_VALUE(RESET_VALUE[11:8]))  reg2 (.clk(clk), .rstn(rstn), .load(load), .d(d[11:8]),  .q(q[11:8]));
    reg4 #(.RESET_VALUE(RESET_VALUE[15:12])) reg3 (.clk(clk), .rstn(rstn), .load(load), .d(d[15:12]), .q(q[15:12]));

endmodule

