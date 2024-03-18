module testbench();
  
    reg clk;
    reg x;
    reg reset;
    wire y;
    wire q;

    circuit dut(
        .clk(clk),
        .x(x),
        .y(y),
        .reset(reset),
        .q(q)
    );
  
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
  
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
      
        x = 0;
        #10; 
        x = 1;
        #10; 
      
        reset = 1;
        #10;
        reset = 0;
        #10
      
        x = 0;
        #10; 
        x = 1;
        #10; 
        x = 0;
        #10; 
        x = 1;
        #10; 
        x = 0;
        #10; 
        x = 1;
        #10; 
        x = 0;
        #10; 
        x = 1;
        #10; 
        x = 0;
        #10; 
        x = 1;
      
        $finish;
    end
  
endmodule
