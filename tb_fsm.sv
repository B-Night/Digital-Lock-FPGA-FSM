`timescale 1ns/1ps

module tb_fsm;

    // Test signals
    logic       clk;
    logic       rstn;
    logic       valid_key;
    logic [3:0] key_code;
    logic       password_match;

    // Outputs from FSM
    logic       load_new_pin;
    logic       load_enter_pin;
    logic       clear_entered;
    logic [1:0] current_digit;
    logic [3:0] current_state;

    // Device under test
    fsm uut (
        .clk(clk),
        .rstn(rstn),
        .valid_key(valid_key),
        .key_code(key_code),
        .password_match(password_match),
        .load_new_pin(load_new_pin),
        .load_enter_pin(load_enter_pin),
        .clear_entered(clear_entered),
        .current_digit(current_digit),
        .current_state(current_state)
    );

    // Clock generator (20ns period)
    initial clk = 0;
    always begin
        #10 clk <= ~clk;
    end

    // Helper task to simulate a clean button press between clock edges
	task press_key(input logic [3:0] code);
        	begin
            		@(posedge clk); #1; // Wait for a clock edge plus a tiny hold time
            		valid_key <= 1'b1;
            		key_code  <= code;
            		@(posedge clk); #1; // Keep pressed until next clock edge has passed
            		valid_key <= 1'b0;
            		key_code  <= 4'h0;
        	end
    	endtask

    // Test sequence
    initial begin
        $display("--- STARTING FSM CONTROL UNIT TEST ---");
        
        // Initialization
        rstn           = 1'b0;
        valid_key      = 1'b0;
        key_code       = 4'h0;
        password_match = 1'b0;
        #25; 
        rstn = 1'b1;
        #5;
        $display("[%0t ns] State: UNLOCKED (Expected: 0), State value: %d", $time, current_state);

        // =====================================================================
        // SEQUENCE 1: Program a New PIN (Press 'E' -> Enter 4 digits)
        // =====================================================================
        $display("\n--- SEQUENCE 1: Programming New PIN ---");
        
        press_key(4'hE); // Press 'E' to configure new pin
        $display("[%0t ns] State: NEW_PIN_1 (Expected: 1), State value: %d", $time, current_state);
        
        press_key(4'h1); // 1st digit
        $display("[%0t ns] State: NEW_PIN_2 (Expected: 2), State value: %d", $time, current_state);
        
        press_key(4'h2); // 2nd digit
        $display("[%0t ns] State: NEW_PIN_3 (Expected: 3), State value: %d", $time, current_state);
        
        press_key(4'h3); // 3rd digit
        $display("[%0t ns] State: NEW_PIN_4 (Expected: 4), State value: %d", $time, current_state);
        
        press_key(4'h4); // 4th digit -> returns to unlocked
        $display("[%0t ns] State: UNLOCKED (Expected: 0), State value: %d", $time, current_state);

        // =====================================================================
        // SEQUENCE 2: Lock the device and test a WRONG PIN
        // =====================================================================
        $display("\n--- SEQUENCE 2: Locking and Wrong PIN Test ---");
        
        press_key(4'hB); // Press 'B' to Lock
        $display("[%0t ns] State: LOCKED_1 (Expected: 5), State value: %d", $time, current_state);
        
        press_key(4'h9); // 1st wrong digit
        press_key(4'h9); // 2nd wrong digit
        press_key(4'h9); // 3rd wrong digit
        press_key(4'hC); // 4th digit is 'C' -> moves to WAIT_C
        $display("[%0t ns] State: WAIT_C (Expected: 9), State value: %d", $time, current_state);
	password_match = 1'b0;
        @(posedge clk); #5; // Wait for clock edge to evaluate WAIT_C
        $display("[%0t ns] State: LOCKED_1 (Expected: 5), State value: %d, Clear active: %b", $time, current_state, clear_entered);
       
        
        // Simulate comparator result (No Match)
        password_match = 1'b0;
        #20; // Let clock evaluate WAIT_C -> should jump back to LOCKED_1
        $display("[%0t ns] State: LOCKED_1 (Expected: 5), State value: %d, Clear active: %b", $time, current_state, clear_entered);

        // =====================================================================
        // SEQUENCE 3: Enter the CORRECT PIN to unlock
        // =====================================================================
        $display("\n--- SEQUENCE 3: Correct PIN Unlock Test ---");
        
        press_key(4'h1); // 1st correct digit
        press_key(4'h2); // 2nd correct digit
        press_key(4'h3); // 3rd correct digit
        press_key(4'hC); // 4th digit is 'C' -> moves to WAIT_C
        $display("[%0t ns] State: WAIT_C (Expected: 9), State value: %d", $time, current_state);
        password_match = 1'b1;
        @(posedge clk); #5; // Wait for clock edge to evaluate WAIT_C
        $display("[%0t ns] State: UNLOCKED (Expected: 0), State value: %d", $time, current_state);
        
        // Simulate comparator result (Success Match!)
        password_match = 1'b1;
        #20; // Let clock evaluate WAIT_C -> should jump to UNLOCKED
        $display("[%0t ns] State: UNLOCKED (Expected: 0), State value: %d", $time, current_state);

        $display("\n--- FSM VERIFICATION COMPLETE ---");
        $stop;
    end

endmodule
