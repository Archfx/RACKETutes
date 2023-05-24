`include "adder.v"
`default_nettype none

module tb_adder;
reg [31:0] a;
reg [31:0] b;
wire [31:0] c;

adder adder(
    .a (a),
    .b (b),
    .c (c)
);



initial begin
    #1 a<=32'd10;b<=32'd15;

    #10
    $display (c);
    $finish(2);
end

endmodule
`default_nettype wire