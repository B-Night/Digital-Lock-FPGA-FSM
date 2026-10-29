`timescale 1ns/1ps
`timescale 1ns/1ps

module tb_dff;

    // Test signals
    logic d;
    logic clk;
    logic q;
    logic qn;

    // Device under test
    dff uut (
        .d(d),
        .clk(clk),
        .q(q),
        .qn(qn)
    );

    // Clock generator (20ns period)
    always begin
        clk = 0; #10;
        clk = 1; #10;
    end

    // Test sequence
    initial begin
        $display("--- STARTING D-FLIP-FLOP TEST ---");

        // Case 1: Initialization
        $display("[%0t ns] Case 1: Initialization (d=0)", $time);
        d = 0; #25; 

        // Case 2: Stable high over rising edge
        $display("[%0t ns] Case 2: Setting d=1 (should capture at next rising edge)", $time);
        d = 1; #20; 

        // Case 3: Stable low over rising edge
        $display("[%0t ns] Case 3: Setting d=0 (should capture at next rising edge)", $time);
        d = 0; #20;

        // Edge case 1: Multiple d changes during low clock phase
        $display("[%0t ns] Edge Case 1: Changing d multiple times during LOW clock phase", $time);
        #5;  d = 1; 
        #3;  d = 0; 
        #4;  d = 1; // Stable value before rising edge
        #10; // Wait over edge

        // Edge case 2: Multiple d changes during high clock phase
        $display("[%0t ns] Edge Case 2: Changing d multiple times during HIGH clock phase", $time);
        #5;  d = 0;
        #3;  d = 1;
        #4;  d = 0; // Should not capture until next rising edge
        #10;

        // Edge case 3: Input glitch on d
        $display("[%0t ns] Edge Case 3: Input glitch on d", $time);
        #2;  d = 1; #2; d = 0; 
        #16;

        // Edge case 4: Setup/Hold timing test
        $display("[%0t ns] Edge Case 4: Setup/Hold timing test near clock edge", $time);
        #9;  d = 1; // 1ns before rising edge
        #20;
        #10; d = 0; // Exactly at rising edge
        #20;

        $display("--- TEST COMPLETE ---");
        $stop;
    end

endmodule
