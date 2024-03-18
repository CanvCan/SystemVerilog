module testbench;
  
  	logic [3:0] a;
  	logic [3:0] b;
    logic [1:0] alu_control;
  
  	logic [3:0] result;
    logic flag_zero;
    logic flag_negative;
    logic flag_carry;
    logic flag_overflow;

    ALU dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .flag_zero(flag_zero),
        .flag_negative(flag_negative),
        .flag_carry(flag_carry),
        .flag_overflow(flag_overflow)
    );

    initial begin
      
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
      	
        // carry and negative
        a =  4'b1011; // -5
        b =  4'b1111; // -1
        alu_control = 2'b00; 
        // 11010 ~ -6
        #10;
      
      	// overflow and negative
        a =  4'b0001; // 1
        b =  4'b0111; // 7
        alu_control = 2'b00; 
        // 11000 ~ -8 !!!
        #10;
      
        // zero and carry
        a =  4'b0001; // 1
        b =  4'b0001; // 1
        alu_control = 2'b01; 
        // 10000 ~ 0 !!!
        #10;
      	
      	// zero
        a =  4'b1010; // 10
        b =  4'b0101; // 5
        alu_control = 2'b10; 
        // 0000
        #10;


        $finish;  
    end
endmodule
