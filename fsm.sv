`timescale 1ns/1ps

module fsm (
    input  logic       clk,
    input  logic       rstn,
    input  logic       valid_key,
    input  logic [3:0] key_code,
    input  logic       password_match,

    output logic       load_new_pin,
    output logic       load_enter_pin,
    output logic       clear_entered,
    output logic [1:0] current_digit,
    output logic [3:0] current_state
);

    // FSM STATES
    localparam logic [3:0]
        UNLOCKED  = 4'd0,
        NEW_PIN_1 = 4'd1,
        NEW_PIN_2 = 4'd2,
        NEW_PIN_3 = 4'd3,
        NEW_PIN_4 = 4'd4,
        LOCKED_1  = 4'd5,
        LOCKED_2  = 4'd6,
        LOCKED_3  = 4'd7,
        LOCKED_4  = 4'd8,
        WAIT_C    = 4'd9;

    // SPECIAL KEYS
    localparam logic [3:0]
        KEY_B = 4'hB,
        KEY_C = 4'hC,
        KEY_E = 4'hE;

    // STATE REGISTERS
    logic [3:0] state_reg;
    logic [3:0] next_state;

    assign current_state = state_reg;


    // 1. STATE REGISTER
    always_ff @(posedge clk) begin
        if (!rstn) begin
            state_reg <= UNLOCKED;
        end
        else begin
            state_reg <= next_state;
        end
    end


    // 2. NEXT-STATE LOGIC

    always_comb begin

        // DEFAULT: stay in current state
        next_state = state_reg;

        case (state_reg)

            // UNLOCKED
            UNLOCKED: begin

                if (valid_key && (key_code == KEY_E))
                    next_state = NEW_PIN_1;

                else if (valid_key && (key_code == KEY_B))
                    next_state = LOCKED_1;

            end


            // PROGRAM NEW PIN
            NEW_PIN_1: begin
                if (valid_key)
                    next_state = NEW_PIN_2;
            end

            NEW_PIN_2: begin
                if (valid_key)
                    next_state = NEW_PIN_3;
            end

            NEW_PIN_3: begin
                if (valid_key)
                    next_state = NEW_PIN_4;
            end

            NEW_PIN_4: begin
                if (valid_key)
                    next_state = UNLOCKED;
            end


            // ENTER PIN WHILE LOCKED
            LOCKED_1: begin
                if (valid_key)
                    next_state = LOCKED_2;
            end

            LOCKED_2: begin
                if (valid_key)
                    next_state = LOCKED_3;
            end

            LOCKED_3: begin
                if (valid_key)
                    next_state = LOCKED_4;
            end

            LOCKED_4: begin
                if (valid_key)
                    next_state = WAIT_C;
            end


            // WAIT FOR C TO CHECK PIN
            WAIT_C: begin

                if (valid_key && (key_code == KEY_C)) begin

                    if (password_match)
                        next_state = UNLOCKED;
                    else
                        next_state = LOCKED_1;

                end

            end


            // INVALID STATE
            default: begin
                next_state = UNLOCKED;
            end

        endcase
    end


    // 3. CONTROL OUTPUTS
    always_comb begin

        // Default values
        load_new_pin   = 1'b0;
        load_enter_pin = 1'b0;
        clear_entered  = 1'b0;
        current_digit  = 2'b00;

        case (state_reg)

            // PROGRAMMING NEW PIN

            NEW_PIN_1: begin
                current_digit = 2'd0;
                load_new_pin  = valid_key;
            end

            NEW_PIN_2: begin
                current_digit = 2'd1;
                load_new_pin  = valid_key;
            end

            NEW_PIN_3: begin
                current_digit = 2'd2;
                load_new_pin  = valid_key;
            end

            NEW_PIN_4: begin
                current_digit = 2'd3;
                load_new_pin  = valid_key;
            end


            // ENTERING PIN WHILE LOCKED
            LOCKED_1: begin
                current_digit  = 2'd0;
                load_enter_pin = valid_key;
            end

            LOCKED_2: begin
                current_digit  = 2'd1;
                load_enter_pin = valid_key;
            end

            LOCKED_3: begin
                current_digit  = 2'd2;
                load_enter_pin = valid_key;
            end

            LOCKED_4: begin
                current_digit  = 2'd3;
                load_enter_pin = valid_key;
            end


            // WRONG PIN
            WAIT_C: begin

                if (valid_key &&
                    (key_code == KEY_C) &&
                    !password_match) begin

                    clear_entered = 1'b1;

                end

            end


            default: begin
                // Keep default values
            end

        endcase
    end

endmodule
