module dff (
    input  logic d,
    input  logic clk,
    output logic q,
    output logic qn
);

`ifdef SYNTHESIS

    // FPGA implementation: use a real clocked flip-flop.
    always_ff @(posedge clk) begin
        q <= d;
    end

    assign qn = ~q;

`else

    // QuestaSim implementation: structural master-slave DFF.
    logic clk_not;
    logic q_master;
    logic qn_master;

    // Clock inverter
    inv_delay u_inv_clk (
        .a(clk),
        .y(clk_not)
    );

    // Master latch
    d_latch u_master (
        .d(d),
        .en(clk_not),
        .q(q_master),
        .qn(qn_master)
    );

    // Slave latch
    d_latch u_slave (
        .d(q_master),
        .en(clk),
        .q(q),
        .qn(qn)
    );

`endif

endmodule
