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
    logic [31:0] registers [0:15] = '{16'h0, 16'h1, 
                                      16'h2, 16'h3,
                                      16'h4, 16'h5, 
                                      16'h6, 16'h7,
                                      16'h8, 16'h9, 
                                      16'hA, 16'hB,
                                      16'hC, 16'hD, 
                                      16'hE, 16'hF};

    always_ff @(posedge clk) begin
        if (WE) begin
            registers[A3] <= WD3;
        end
        RD1 <= registers[A1];
        RD2 <= registers[A2];
    end

endmodule
