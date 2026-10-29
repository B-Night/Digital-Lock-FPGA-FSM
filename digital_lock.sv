`timescale 1ns/1ps

module digital_lock #(
    parameter int SYSTEM_DIVISOR = 1000000
) (
    input  logic       clk,
    input  logic       rstn,
    input  logic [3:0] key,
    input  logic       valid_key,
    output logic       state
);

    logic clean_valid_key;

    logic [3:0] current_state;
    logic [1:0] current_digit;

    logic load_new_pin;
    logic load_enter_pin;
    logic clear_entered;

    logic [3:0] new_pin_0;
    logic [3:0] new_pin_1;
    logic [3:0] new_pin_2;
    logic [3:0] new_pin_3;

    logic [3:0] entered_pin_0;
    logic [3:0] entered_pin_1;
    logic [3:0] entered_pin_2;
    logic [3:0] entered_pin_3;

    logic [15:0] stored_pin;
    logic [15:0] entered_pin;

    logic password_match;
    logic [3:0] digit_enable;


    // Debounced one-cycle key event
    debouncer #(
        .SAMPLE_DIVISOR(SYSTEM_DIVISOR)
    ) u_debouncer (
        .clk       (clk),
        .rstn      (rstn),
        .btn_in    (valid_key),
        .pulse_out (clean_valid_key)
    );


    // FSM
    fsm u_fsm (
        .clk             (clk),
        .rstn            (rstn),
        .valid_key       (clean_valid_key),
        .key_code        (key),
        .password_match  (password_match),
        .load_new_pin    (load_new_pin),
        .load_enter_pin  (load_enter_pin),
        .clear_entered   (clear_entered),
        .current_digit   (current_digit),
        .current_state   (current_state)
    );


    // 2-to-4 decoder

    decoder2to4 u_decoder (
        .a  (current_digit),
        .en (load_new_pin | load_enter_pin),
        .y  (digit_enable)
    );


    // Stored PIN
    reg4 new_pin_reg0 (
        .clk  (clk),
        .rstn (rstn),
        .load (load_new_pin & digit_enable[0]),
        .d    (key),
        .q    (new_pin_0)
    );

    reg4 new_pin_reg1 (
        .clk  (clk),
        .rstn (rstn),
        .load (load_new_pin & digit_enable[1]),
        .d    (key),
        .q    (new_pin_1)
    );

    reg4 new_pin_reg2 (
        .clk  (clk),
        .rstn (rstn),
        .load (load_new_pin & digit_enable[2]),
        .d    (key),
        .q    (new_pin_2)
    );

    reg4 new_pin_reg3 (
        .clk  (clk),
        .rstn (rstn),
        .load (load_new_pin & digit_enable[3]),
        .d    (key),
        .q    (new_pin_3)
    );


    // Entered PIN
    reg4 entered_pin_reg0 (
        .clk  (clk),
        .rstn (rstn),
        .load (load_enter_pin & digit_enable[0]),
        .d    (key),
        .q    (entered_pin_0)
    );

    reg4 entered_pin_reg1 (
        .clk  (clk),
        .rstn (rstn),
        .load (load_enter_pin & digit_enable[1]),
        .d    (key),
        .q    (entered_pin_1)
    );

    reg4 entered_pin_reg2 (
        .clk  (clk),
        .rstn (rstn),
        .load (load_enter_pin & digit_enable[2]),
        .d    (key),
        .q    (entered_pin_2)
    );

    reg4 entered_pin_reg3 (
        .clk  (clk),
        .rstn (rstn),
        .load (load_enter_pin & digit_enable[3]),
        .d    (key),
        .q    (entered_pin_3)
    );

    // PIN comparison
    assign stored_pin = {
        new_pin_3,
        new_pin_2,
        new_pin_1,
        new_pin_0
    };

    assign entered_pin = {
        entered_pin_3,
        entered_pin_2,
        entered_pin_1,
        entered_pin_0
    };

    comp16 u_comp16 (
        .a  (stored_pin),
        .b  (entered_pin),
        .equal (password_match)
    );


    // External lock state
    always_comb begin
        if (current_state >= 4'd5)
            state = 1'b1;
        else
            state = 1'b0;
    end

endmodule
