`timescale 1ns/1ps

module mux2to1_Nbit #(parameter N=1)
                (   input  logic [N-1:0] A,
                    input  logic [N-1:0] B,
                    input  logic s,
                    output logic [N-1:0] Y
                );


    // Generate N bit 2-1 mux
    genvar i;
    generate
        for (i = 0; i < N; i++) begin : gen_2_1_mux
            mux2to1_slice ms (
                .a(A[i]),
                .b(B[i]),
                .s(s),
                .y(Y[i])
            );
        end
    endgenerate

endmodule
