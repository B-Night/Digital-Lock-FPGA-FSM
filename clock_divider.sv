`timescale 1ns/1ps

module clock_divider #(
    parameter int DIVISOR = 500000
) (
    input  logic rst_n,
    input  logic clk_in,
    output logic clk_out
);

    logic [$clog2(DIVISOR)-1:0] counter;

    always_ff @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            counter <= DIVISOR - 1;
            clk_out <= 1'b0;
        end else begin
            if (counter == 0) begin
                counter <= DIVISOR - 1;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter - 1;
            end
        end
    end

endmodule
