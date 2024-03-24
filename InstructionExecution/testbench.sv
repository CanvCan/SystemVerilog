module testbench();

    logic [13:0] instruction;
    logic clk;
  
    logic flag_zero;
    logic flag_negative;
    logic flag_carry;
    logic flag_overflow;

    dataPath dut (
        .instruction(instruction),
        .clk(clk),
        .flag_zero(flag_zero),
        .flag_negative(flag_negative),
        .flag_carry(flag_carry),
        .flag_overflow(flag_overflow)
    );
  
    initial begin
        clk = 0;
        forever #10 clk = ~clk; 
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

        instruction = 14'b00_1010_1111_0000; //15
      	#10
      
      	instruction = 14'b00_1010_0000_1111; //15
      	#10
      
      	instruction = 14'b01_1010_0001_0001; //0 and carry/zero
      	#10
      
      	instruction = 14'b01_1010_0001_0001; //0 and carry/zero
      	#10
      	
      	instruction = 14'b01_1010_0000_0001; //-1 and negative
      	#10
      	
      	instruction = 14'b01_1010_0000_0001; //-1 and negative
      	#10

        $finish;
    end

endmodule
