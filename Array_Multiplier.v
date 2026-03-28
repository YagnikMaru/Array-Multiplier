`timescale 1ns / 1ps

module Array_Multiplier(
  input wire [15:0] a,
    input wire [15:0] b,
    output wire [31:0] product
    );
     wire [15:0] pp [15:0]; 
    wire [31:0] sum [15:0]; 

    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : PARTIAL_PRODUCTS
            for (j = 0; j < 16; j = j + 1) begin : AND_GATES
                assign pp[i][j] = a[j] & b[i];
            end
        end
    endgenerate
    
    // First stage - initialize with first partial product
    assign sum[0] = {16'b0, pp[0]};
    
    // Array of adders for summation
    generate
        for (i = 1; i < 16; i = i + 1) begin : ADDER_ARRAY
            wire [31:0] shifted_pp = {pp[i], {i{1'b0}}}; // Shift left by i bits
            assign sum[i] = sum[i-1] + shifted_pp;
        end
    endgenerate
    
    // Final product
    assign product = sum[15];
    
endmodule
