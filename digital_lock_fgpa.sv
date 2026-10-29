`timescale 1ns/1ps

module digital_lock_fpga (
    input  logic        CLK_100MHZ,
    input  logic [15:0] SW,          // 16-bit switch array matching urbana.xdc
    input  logic [3:0]  BTN,         // 4-bit button array matching urbana.xdc
    output logic [15:0] LED          // 16-bit LED array matching urbana.xdc
);

    logic state;
    logic [3:0] key_slice;
    logic       valid_key_pulse;
    logic       hardware_reset_n;

    // Connect the 4 lowest switches to the hex key code bus
    assign key_slice = SW[3:0];  
    
    // Urbana buttons are physically Active-High (1 when pressed, 0 when released)
    assign valid_key_pulse  = BTN[0]; // Gives '1' when BTN0 is pressed
    assign hardware_reset_n = ~BTN[1]; // Gives '1' when BTN1 is released (Run)

    // Instantiate digital lock
    digital_lock #(
        .SYSTEM_DIVISOR(100000)
    ) u_lock (
        .clk       (CLK_100MHZ),
        .rstn      (hardware_reset_n),
        .key       (key_slice),
        .valid_key (valid_key_pulse),
        .state     (state)
    );

    // Lock state at LED[0]
    assign LED[0]    = state; 
    assign LED[15:1] = 15'b0; // Rest is off

endmodule
