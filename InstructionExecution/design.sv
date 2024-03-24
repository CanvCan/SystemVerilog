module RegisterFile (
    input  logic clk,        // Clock signal
    input  logic [3:0] A1,   // Address for read port 1
    input  logic [3:0] A2,   // Address for read port 2
    input  logic [3:0] A3,   // Address for write port
    input  logic        WE,  // Write enable signal
    input  logic [31:0] WD3, // Data to be written
    output logic [31:0] RD1, // Data read from read port 1
    output logic [31:0] RD2  // Data read from read port 2
);

    // Internal register file storage
    logic [31:0] registers [0:15] = '{32'h0, 32'h1, 
                                      32'h2, 32'h3,
                                      32'h4, 32'h5, 
                                      32'h6, 32'h7,
                                      32'h8, 32'h9, 
                                      32'hA, 32'hB,
                                      32'hC, 32'hD, 
                                      32'hE, 32'hF};

    always_ff @(posedge clk) begin
        if (WE) begin
            registers[A3] <= WD3;
        end
        RD1 <= registers[A1];
        RD2 <= registers[A2];
    end

endmodule

module fulladder(input logic signed a, b, cin,
				 output logic signed s, cout);

 assign s=a^b^cin;
 assign cout= a&b|b&cin|cin&a;
  
endmodule

module NbitFulladder (
    input logic [31:0] a, b,
    input logic cin,
    output logic [31:0] s,
    output logic cout
);

   logic [31:0] c;

    genvar i;
    generate
      for (i = 0; i < 32; i++) begin : fulladder_loop
            fulladder fulladder_inst (
                .a(a[i]),
                .b(b[i]),
                .cin(i == 0 ? cin : c[i-1]),
                .s(s[i]),
                .cout(c[i])
            );
        end
    endgenerate
  
    assign cout = c[31];

endmodule

module mux2(input logic [31:0] d0, d1,
			input logic s,
            output logic [31:0] y);
  
assign y = s ? d1 : d0;
  
endmodule

module mux4(input logic [31:0] d0, d1, d2, d3,
			input logic [1:0] s,
            output logic [31:0] y);
  
  assign y = s[1] ?
  (s[0] ? d3 : d2):
  (s[0] ? d1 : d0);
  
endmodule

module ALU (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [1:0] alu_control,
    output logic [31:0] result,
    output logic flag_zero,
    output logic flag_negative,
    output logic flag_carry,
    output logic flag_overflow
);

    logic [31:0] add_result;
    logic [31:0] and_result;
    logic [31:0] or_result;
    logic [31:0] selected_b;
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
  
    assign flag_negative = result[31];
    assign flag_zero = (~|result);
    assign flag_carry = cout & ~alu_control[1];
    assign flag_overflow = ~(alu_control[0] ^ a[31] ^ b[31]) & 
           (a[31] ^ result[31]) & (~alu_control[1]);

endmodule

module dataPath (
  input logic [13:0] instruction,
  input logic clk,
  output logic flag_zero,
  output logic flag_negative,
  output logic flag_carry, 
  output logic flag_overflow
);

  logic WE = 1;

  wire [31:0] rd1, rd2;
  wire [31:0] add_result;
  
  RegisterFile registerfile (
      .clk(clk),
      .A1(instruction[7:4]),
      .A2(instruction[3:0]),
      .A3(instruction[11:8]),
      .WE(WE),
      .WD3(add_result),
      .RD1(rd1),
      .RD2(rd2)
  );
  
  ALU alu (
        .a(rd1),
        .b(rd2),
        .alu_control(instruction[13:12]),
        .result(add_result),
        .flag_zero(flag_zero),
        .flag_negative(flag_negative),
        .flag_carry(flag_carry),
        .flag_overflow(flag_overflow)
  );

endmodule
