module testbench;

    logic [3:0] A1, A2, A3;
    logic WE;
    logic [31:0] WD3;
    logic [31:0] RD1, RD2;

    bit clk;

    RegisterFile dut (
        .clk(clk),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WE(WE),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2)
    );

    always forever #10 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

        A1 = 1;
        A2 = 2;
        A3 = 3;
        WE = 0;
        #10;

        // Write to register at A3 address
        A1 = 1;
        A2 = 2;
        A3 = 3;
        WE = 1;
        WD3 = 32'hABCDE123;
        #10;
        WE = 0;

        // Read from registers at A1 and A2 addresses
        A1 = 2;
        A2 = 3;
        WE = 0;
        #10;
      
        A1 = 2;
        A2 = 3;
        WE = 0;
        #10;

        $finish;
    end

endmodule
