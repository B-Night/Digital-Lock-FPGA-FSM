`timescale 1ns/1ps
`timescale 1ns/1ps

module tb_d_latch;

    // Test signals
    logic d;
    logic en;
    logic q;
    logic qn;

    // Device under test
    d_latch uut (
        .d(d),
        .en(en),
        .q(q),
        .qn(qn)
    );

    // Test sequence
    initial begin
        $display("--- STARTING D-LATCH TEST ---");

        // Case 1: Initialization
        $display("[%0t ns] Case 1: Initialization (en=0, d=0)", $time);
        en = 0; d = 0; #20;

        // Case 2: Transparent mode (en=1, d=0 -> q=0)
        $display("[%0t ns] Case 2: Transparent mode (en=1, d=0)", $time);
        en = 1; d = 0; #20;

        // Case 3: Transparent mode (en=1, d=1 -> q=1)
        $display("[%0t ns] Case 3: Transparent mode (en=1, d=1)", $time);
        d = 1; #20;

        // Case 4: Hold mode when d=1 (q should stay 1)
        $display("[%0t ns] Case 4: Hold mode when d=1 (en=0)", $time);
        en = 0; #20;

        // Case 5: Change d during hold mode (q should not change)
        $display("[%0t ns] Case 5: Changing d while in hold mode", $time);
        d = 0; #20;
        d = 1; #20;

        // Case 6: Open latch when d=0 (q should become 0)
        $display("[%0t ns] Case 6: Opening latch when d=0", $time);
        d = 0; en = 1; #20;

        // Case 7: Hold mode when d=0 (q should stay 0)
        $display("[%0t ns] Case 7: Hold mode when d=0 (en=0)", $time);
        en = 0; #20;

        // Case 8: Change d during hold mode again (q should not change)
        $display("[%0t ns] Case 8: Changing d while in hold mode again", $time);
        d = 1; #20;

        // Edge case: Fast transitions (glitch test)
        $display("[%0t ns] Edge Case: Fast transitions / glitch test", $time);
        en = 1; #5;
        d = 0;  #5;
        d = 1;  #5;
        
        // Edge case: Disable en at the exact same time as d changes
        $display("[%0t ns] Edge Case: Disabling en at the exact same time as d changes", $time);
        en = 0; d = 0; #20;

        $display("--- TEST COMPLETE ---");
        $stop;
    end

endmodule
