module testbench;
  
    logic [7:0] a;
    logic [7:0] b;
    logic [1:0] alu_control;
    logic [7:0] result;

    ALU dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result)
    );

    initial begin
      
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
      	
        // addition
        a =  8'b01001010; //  74
        b = -8'd12; // -12
        alu_control = 2'b00; 
        // 62
        #10;
        
        // substraction
        a = 8'sb01001010; //  74
        b = 8'sb00101100; //  44
        alu_control = 2'b01; 
        #10;
        // 30
      	
      	// substraction
        a =  8'sb01001010; //   74
        b = -8'd52; // -52
        alu_control = 2'b01; 
        #10;
        // 126
      
        // AND
        a = 8'sb01001010;
        b = 8'sb00100111;
        alu_control = 2'b10; 
        #10;
        // 00000010 ~ 2
      
        // OR
        a =  8'sb01001010;
        b = -8'sb11100000;
        alu_control = 2'b11; 
        #10;
        // 11101010 ~ -22 or 234

        $finish;  
    end
endmodule
