`timescale 1ns/1ps

module tb_reg4;

    // Test signals
    logic       clk;
    logic       rstn;
    logic       load;
    logic [3:0] d;
    logic [3:0] q;

    // Device under test
    reg4 #(
        .RESET_VALUE(4'b1111) // Testing a non-zero reset value
    ) uut (
        .clk(clk),
        .rstn(rstn),
        .load(load),
        .d(d),
        .q(q)
    );

    // Clock generator (20ns period)
	initial clk = 0;
    	always begin
        	#10 clk <= ~clk;
    	end


    // Test sequence
    initial begin
        $display("--- STARTING REG4 STRUCTURAL TEST ---");

        // Case 1: Active low synchronous reset test
        $display("[%0t ns] Case 1: Applying synchronous reset (rstn=0)", $time);
        rstn = 1'b0;
        load = 1'b0;
        d    = 4'b1;
        #25; // Wait past first rising clock edge

        // Case 2: Release reset and verify old value is held (load=0)
        $display("[%0t ns] Case 2: Releasing reset (rstn=1, load=0) - Value should hold RESET_VALUE", $time);
        rstn = 1'b1;
        d    = 4'b10; // Changing input d, but load is 0
        #20;

        // Case 3: Load new data into register (load=1)
        $display("[%0t ns] Case 3: Loading data (load=1, d=1'b1)", $time);
        load = 1'b1;
        d    = 4'b11;
        #20;

        // Case 4: Disable load and ensure data persists
        $display("[%0t ns] Case 4: Disabling load (load=0) - Data 4'h9 should lock", $time);
        load = 1'b0;
        d    = 4'b100; // Change input data while load is disabled
        #20;

        // Case 5: Verify synchronous reset during active load
        $display("[%0t ns] Case 5: Testing synchronous reset override while load=1", $time);
        load = 1'b1;
        d    = 4'b1001;
        #10;
        rstn = 1'b0; // Pull reset low right before the next rising edge
        #20;

        // Clean up and finish
        rstn = 1'b1;
        load = 1'b0;
        #20;

        $display("--- TEST COMPLETE ---");
        $stop;
    end

endmodule
