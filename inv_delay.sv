// Inverts the insignal
`timescale 1ns/1ps

module inv_delay (
    input  logic a,
    output logic y
);

nand2_delay inv(
.a(a),
.b(a),
.y(y)
);

endmodule