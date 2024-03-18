module fulladder(input logic signed a, b, cin,
				 output logic signed s, cout);

 assign s=a^b^cin;
 assign cout= a&b|b&cin|cin&a;
  
endmodule

module NbitFulladder(input logic signed [7:0] a, b,
					 input logic signed cin,
					 output logic signed [7:0] s,
					 output logic signed cout );
wire [6:0] c;
  
fulladder i_0 (a[0],b[0],cin,s[0],c[0]);
fulladder i_1 (a[1],b[1],c[0],s[1],c[1]);
fulladder i_2 (a[2],b[2],c[1],s[2],c[2]);
fulladder i_3 (a[3],b[3],c[2],s[3],c[3]);
fulladder i_4 (a[4],b[4],c[3],s[4],c[4]);
fulladder i_5 (a[5],b[5],c[4],s[5],c[5]);
fulladder i_6 (a[6],b[6],c[5],s[6],c[6]);
fulladder i_7 (a[7],b[7],c[6],s[7],cout);
  
endmodule

module mux2(input logic signed [7:0] d0, d1,
			input logic s,
            output logic signed [7:0] y);
  
assign y = s ? d1 : d0;
  
endmodule

module mux4(input logic signed [7:0] d0, d1, d2, d3,
			input logic [1:0] s,
			output logic signed [7:0] y);
  
  assign y = s[1] ?
  (s[0] ? d3 : d2):
  (s[0] ? d1 : d0);
  
endmodule

module ALU (
    input logic signed [7:0] a,
    input logic signed [7:0] b,
    input logic [1:0] alu_control,
    output logic signed [7:0] result
);

    logic signed [7:0] add_result;
    logic signed [7:0] and_result;
    logic signed [7:0] or_result;

    wire [7:0] selected_b;

    NbitFulladder adder (
        .a(a),
        .b(selected_b),
        .cin(alu_control[0]),
        .s(add_result),
        .cout()
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

endmodule
