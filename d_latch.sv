module d_latch (
    input  logic d,   
    input  logic en,  
    output logic q,   
    output logic qn   
);

    // Internal signals
    logic w_top;
    logic w_bot;

    // Ingngångssteg
    nand u1 (w_top, d, en);
    nand u2 (w_bot, w_top, en);

    // Minnescell
    nand u3 (q, w_top, qn);
    nand u4 (qn, w_bot, q);

endmodule
