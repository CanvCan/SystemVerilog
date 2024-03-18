module circuit(
    input clk, x, reset,
    output reg q,
    output reg y
);
    wire state;
    wire d;

    xor gate(d, x, state);

    flop ff(
        .D(d),
        .clk(clk),
        .reset(reset),
        .q(state)
    );

    always @(posedge clk)
    begin
        q <= state;
        y <= q ^ x;
    end
endmodule

module flop(
    input D, clk, reset,
    output reg q
);
    initial q <= 0;
    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            q <= 0;
        end
        else
        begin
            q <= D;
        end
    end
endmodule
