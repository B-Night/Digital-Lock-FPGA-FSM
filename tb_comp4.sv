`timescale 1ns/1ps

module tb_comp4;

    // Test signals
    logic [3:0] a;
    logic [3:0] b;
    logic       equal;

    // Device under test
    comp4 uut (
        .a(a),
        .b(b),
        .equal(equal)
    );

    // Test sequence
    initial begin
        $display("--- STARTING COMP4 COMBINATORIAL TEST ---");

        // Case 1: Both inputs are zero (matching)
        a = 4'b0000; b = 4'b0000; #20;
        $display("[%0t ns] Case 1: a=%b, b=%b -> equal=%b (Expected: 1)", $time, a, b, equal);

        // Case 2: Inputs do not match (single bit difference)
        a = 4'b0001; b = 4'b0000; #20;
        $display("[%0t ns] Case 2: a=%b, b=%b -> equal=%b (Expected: 0)", $time, a, b, equal);

        // Case 3: Inputs match with a standard hex code (4'h9 -> 1001)
        a = 4'b1001; b = 4'b1001; #20;
        $display("[%0t ns] Case 3: a=%b, b=%b -> equal=%b (Expected: 1)", $time, a, b, equal);

        // Case 4: Inputs do not match (completely different values)
        a = 4'b1111; b = 4'b0101; #20;
        $display("[%0t ns] Case 4: a=%b, b=%b -> equal=%b (Expected: 0)", $time, a, b, equal);

        // Case 5: Inputs match on all ones (4'hF -> 1111)
        a = 4'b1111; b = 4'b1111; #20;
        $display("[%0t ns] Case 5: a=%b, b=%b -> equal=%b (Expected: 1)", $time, a, b, equal);

        $display("--- TEST COMPLETE ---");
        $stop;
    end

endmodule

