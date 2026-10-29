`timescale 1ns/1ps
`timescale 1ns/1ps

module tb_counter;

    // Test signals
    logic       clk;
    logic       rstn;
    logic       count_enable;
    logic [1:0] count;

    // Device under test
    counter uut (
        .clk(clk),
        .rstn(rstn),
        .count_enable(count_enable),
        .count(count)
    );

    // Clock generator (20ns period)
    initial clk = 0;
    always begin
        #10 clk <= ~clk;
    end

    // Test sequence
    initial begin
        $display("--- STARTING COUNTER STRUCTURAL TEST ---");

        // Case 1: Apply synchronous reset
        $display("[%0t ns] Case 1: Active low reset (rstn=0, count_enable=0). Expecting count=00", $time);
        rstn         = 1'b0;
        count_enable = 1'b0;
        #25; // Wait past first rising clock edge

        // Case 2: Release reset and verify it holds 00 when count_enable is 0
        $display("[%0t ns] Case 2: Release reset (rstn=1, count_enable=0). Expecting count=00", $time);
        rstn         = 1'b1;
        count_enable = 1'b0;
        #20;

        // Case 3: Enable counting and watch it step through all states
        $display("[%0t ns] Case 3: Enable counting (count_enable=1)", $time);
        count_enable = 1'b1;
        #20; // Clock edge 3 -> count should become 01
        $display("[%0t ns] Count is now: %b (Expected: 01)", $time, count);
        
        #20; // Clock edge 4 -> count should become 10
        $display("[%0t ns] Count is now: %b (Expected: 10)", $time, count);
        
        #20; // Clock edge 5 -> count should become 11
        $display("[%0t ns] Count is now: %b (Expected: 11)", $time, count);
        
        #20; // Clock edge 6 -> count should wrap around to 00
        $display("[%0t ns] Count is now: %b (Expected: 00 - wrapped around)", $time, count);

        // Case 4: Disable counting and verify it holds its value
        $display("[%0t ns] Case 4: Disabling count (count_enable=0). Expecting count to freeze", $time);
        count_enable = 1'b0;
        #20; // Clock edge 7 passes -> count should stay at 00
        
        // Let's count up one step again to test reset override
        count_enable = 1'b1;
        #20; // count becomes 01

        // Case 5: Synchronous reset override during active counting
        $display("[%0t ns] Case 5: Applying reset while count_enable=1. Reset should win", $time);
        rstn = 1'b0;
        #20; // Clock edge passes -> count should drop to 00 synch

        // Clean up and finish safely
        rstn         = 1'b1;
        count_enable = 1'b0;
        #20;

        $display("--- TEST COMPLETE ---");
        $stop;
    end

endmodule

