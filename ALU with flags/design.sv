module fulladder(input logic a, b, cin,
				 output logic s, cout);

 assign s=a^b^cin;
 assign cout= a&b|b&cin|cin&a;
  
endmodule

module NbitFulladder(input logic [3:0] a, b,
					 input logic cin,
                     output logic [3:0] s,
					 output logic cout );
wire [2:0] c;
  
fulladder i_0 (a[0],b[0],cin,s[0],c[0]);
fulladder i_1 (a[1],b[1],c[0],s[1],c[1]);
fulladder i_2 (a[2],b[2],c[1],s[2],c[2]);
fulladder i_3 (a[3],b[3],c[2],s[3],cout);

endmodule

module mux2(input logic [3:0] d0, d1,
			input logic s,
            output logic [3:0] y);
  
assign y = s ? d1 : d0;
  
endmodule

module mux4(input logic [3:0] d0, d1, d2, d3,
			input logic [1:0] s,
            output logic [3:0] y);
  
  assign y = s[1] ?
  (s[0] ? d3 : d2):
  (s[0] ? d1 : d0);
  
endmodule

module zeroController(input logic [3:0] result,
				      output logic flag);
  
  assign flag = (result == 4'b0000) ? 1'b1 : 1'b0;
  
endmodule

module negativeController(input logic [3:0] result,
				          output logic flag);

  assign flag = (result[3] == 1'b1) ? 1'b1 : 1'b0;
  
endmodule

module carryController(input logic [1] alu_control,
                       input cout,
				       output logic flag);

  assign flag = (~alu_control&cout == 1) ? 1'b1 : 1'b0;
  
endmodule

module overflowController(
    input logic [3:0] a, b, s,
    input logic [1:0] alu_control,
    output logic flag
);

  assign flag = ~(alu_control[0] ^ a[3] ^ b[3]) & (a[3] ^ s[3]) & (~alu_control[1]);

endmodule


module ALU (
    input logic [3:0] a,
    input logic [3:0] b,
    input logic [1:0] alu_control,
    output logic [3:0] result,
    output logic flag_zero,
    output logic flag_negative,
    output logic flag_carry,
    output logic flag_overflow
);

    logic [3:0] add_result;
    logic [3:0] and_result;
    logic [3:0] or_result;
    logic [3:0] selected_b;
    logic cout;

    NbitFulladder adder (
        .a(a),
        .b(selected_b),
        .cin(alu_control[0]),
        .s(add_result),
        .cout(cout)
    );

    mux2 select_b_mux (
        .d0(b),
        .d1(~b),
        .s(alu_control[0]), 
        .y(selected_b)
    );

    assign and_result = a & b;
    assign or_result = a | b;

    mux4 result_mux (
        .d0(add_result),
        .d1(add_result),
        .d2(and_result),
        .d3(or_result),
        .s(alu_control),
        .y(result)
    );
  
    zeroController ctrl_zero (
        .result(result),
        .flag(flag_zero)
    );
  
    negativeController ctrl_negative (
        .result(result),
        .flag(flag_negative)
    );

    carryController ctrl_carry (
        .alu_control(alu_control[1]),
        .cout(cout),
        .flag(flag_carry)
    );
  
    overflowController ctrl_overflow (
        .a(a),
        .b(b),
        .s(add_result),
        .alu_control(alu_control),
        .flag(flag_overflow)
    );

endmodule