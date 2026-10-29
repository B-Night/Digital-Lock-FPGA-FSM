`timescale 1ns/1ps

module debouncer #(
    parameter int SAMPLE_DIVISOR = 1000000
) (
    input  logic clk,
    input  logic rstn,
    input  logic btn_in,
    output logic pulse_out
);

    localparam int COUNTER_WIDTH =
        (SAMPLE_DIVISOR <= 1) ? 1 : $clog2(SAMPLE_DIVISOR);

    logic [COUNTER_WIDTH-1:0] counter;

    logic btn_sync1;
    logic btn_sync2;

    logic button_state;

    always_ff @(posedge clk) begin
        if (!rstn) begin
            counter      <= '0;
            btn_sync1    <= 1'b0;
            btn_sync2    <= 1'b0;
            button_state <= 1'b0;
            pulse_out    <= 1'b0;
        end else begin

            // Synchronize the asynchronous button input.
            btn_sync1 <= btn_in;
            btn_sync2 <= btn_sync1;

            // Default: no key event.
            pulse_out <= 1'b0;

            // Sample the button at the desired sampling frequency.
            if (counter == SAMPLE_DIVISOR - 1) begin
                counter <= '0;

                // Detect Released -> Pressed.
                if (btn_sync2 && !button_state) begin
                    pulse_out <= 1'b1;
                end

                button_state <= btn_sync2;

            end else begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule
