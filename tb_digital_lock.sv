`timescale 1ns/1ps

module tb_digital_lock;

    logic       clk;
    logic       rstn;
    logic       valid_key;
    logic [3:0] key;

    logic       state;


    // DEVICE UNDER TEST
    digital_lock #(
        .SYSTEM_DIVISOR(2)
    ) uut (
        .clk       (clk),
        .rstn      (rstn),
        .key       (key),
        .valid_key (valid_key),
        .state     (state)
    );


    // CLOCK
    initial clk = 1'b0;

    always begin
        #10 clk = ~clk;
    end


    // KEY PRESS
    task press_key(input logic [3:0] code);
        begin
            key       = code;
            valid_key = 1'b1;

            repeat (10) @(posedge clk);

            valid_key = 1'b0;
            key       = 4'h0;

            repeat (10) @(posedge clk);
        end
    endtask


    // TEST
    initial begin

        $display("--- STARTING COMPLETE DIGITAL LOCK SYSTEM TEST ---");

        // Reset
        rstn      = 1'b0;
        key       = 4'h0;
        valid_key = 1'b0;

        #100;

        rstn = 1'b1;

        repeat (5) @(posedge clk);

        $display("[%0t ns] Reset released.", $time);

        assert (!$isunknown(state))
            else $error("[FAIL] State is unknown after reset!");


        // PHASE 1: PROGRAM PIN 1234
        $display("\n--- PHASE 1: Programming PIN 1234 ---");

        press_key(4'hE);
        press_key(4'h1);
        press_key(4'h2);
        press_key(4'h3);
        press_key(4'h4);

        $display("[%0t ns] PIN programming finished.", $time);

        assert (state == 1'b0)
            else $error("[FAIL] Lock should be UNLOCKED after programming!");


        // PHASE 2: LOCK
        $display("\n--- PHASE 2: Locking ---");

        press_key(4'hB);

        $display("[%0t ns] Lock command sent.", $time);

        assert (state == 1'b1)
            else $error("[FAIL] Lock should be LOCKED after pressing B!");


        // PHASE 3: WRONG PIN 9999
        $display("\n--- PHASE 3: Wrong PIN 9999 ---");

        press_key(4'h9);
        press_key(4'h9);
        press_key(4'h9);
        press_key(4'h9);
        press_key(4'hC);

        $display("[%0t ns] Wrong PIN finished.", $time);

        assert (state == 1'b1)
            else $error("[FAIL] Lock should remain LOCKED after wrong PIN!");


        // PHASE 4: CORRECT PIN 1234
        $display("\n--- PHASE 4: Correct PIN 1234 ---");

        press_key(4'h1);
        press_key(4'h2);
        press_key(4'h3);
        press_key(4'h4);
        press_key(4'hC);

        $display("[%0t ns] Correct PIN finished.", $time);

        assert (state == 1'b0)
            else $error("[FAIL] Lock should be UNLOCKED after correct PIN!");


        // COMPLETE
        if (state == 1'b0)
    		$display("\n--- SYSTEM VERIFICATION COMPLETE: ALL CHECKS PASSED ---");
	    else
    		$display("\n--- SYSTEM VERIFICATION FAILED ---");

        $stop;

    end

endmodule
