module array_multipliyer_tb;
    reg [15:0] a, b;
    wire [31:0] product;
    reg [31:0] expected_product;
    integer i, error_count;
    reg clk;
    reg [15:0] test_cases [0:9][1:0]; // Store test cases
    
    // Instantiate the array multiplier
    Array_Multiplier uut (
        .a(a),
        .b(b),
        .product(product)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize variables
        clk = 0;
        error_count = 0;
        
        // Initialize test cases array
        initialize_test_cases();
        // Run all test cases
        for (i = 0; i < 10; i = i + 1) begin
            a = test_cases[i][0];
            b = test_cases[i][1];
            expected_product = a * b;
            
            #20; // Wait for propagation delay
            
            $display("%0t\t%h\t%h\t%h\t%h\t%s",
                    $time, a, b, expected_product, product,
                    (product === expected_product) ? "PASS" : "FAIL");
            
            if (product !== expected_product) begin
                error_count = error_count + 1;
                $display("ERROR: Test case %0d failed!", i);
                $display("       A = %d (%h), B = %d (%h)", a, a, b, b);
                $display("       Expected: %d (%h)", expected_product, expected_product);
                $display("       Got:      %d (%h)", product, product);
            end
        end
        
        // Display final results
        $display("----------------------------------------------------------------");
        $display("TEST SUMMARY:");
        $display("Total test cases: 10");
        $display("Passed: %0d", 10 - error_count);
        $display("Failed: %0d", error_count);
        
        if (error_count == 0) begin
            $display("✓ ALL TESTS PASSED!");
        end else begin
            $display("✗ SOME TESTS FAILED!");
        end
        $display("================================================");
        
        #100 $finish;
    end
    
    // Task to initialize test cases
    task initialize_test_cases;
        begin
            // Test case 0: Random values
            test_cases[0][0] = 16'h1234;
            test_cases[0][1] = 16'h5678;
            
            // Test case 1: Maximum values
            test_cases[1][0] = 16'hFFFF;
            test_cases[1][1] = 16'hFFFF;
            
            // Test case 2: Minimum values
            test_cases[2][0] = 16'h0000;
            test_cases[2][1] = 16'h0000;
            
            // Test case 3: One operand zero
            test_cases[3][0] = 16'hABCD;
            test_cases[3][1] = 16'h0000;
            
            // Test case 4: One operand one
            test_cases[4][0] = 16'h1234;
            test_cases[4][1] = 16'h0001;
            
            // Test case 5: Powers of two
            test_cases[5][0] = 16'h0100;
            test_cases[5][1] = 16'h0020;
            
            // Test case 6: Mixed values
            test_cases[6][0] = 16'h00FF;
            test_cases[6][1] = 16'hFF00;
            
            // Test case 7: Medium values
            test_cases[7][0] = 16'h3A2F;
            test_cases[7][1] = 16'h1B4C;
            
            // Test case 8: Negative numbers (two's complement)
            test_cases[8][0] = 16'h8001; // -32767
            test_cases[8][1] = 16'h0002;
            
            // Test case 9: Another random case
            test_cases[9][0] = 16'h7FFF;
            test_cases[9][1] = 16'h00FF;
        end
    endtask
    
    // Additional monitoring for debugging
    initial begin
        $monitor("Time=%0t: A=%h (%d) B=%h (%d) Product=%h (%d) Expected=%h (%d)",
                $time, a, a, b, b, product, product, expected_product, expected_product);
    end
    
    // Waveform dumping for Vivado
    initial begin
        $dumpfile("array_multiplier_tb.vcd");
        $dumpvars(0, array_multipliyer_tb);
    end
    
    // Timeout protection
    initial begin
        #2000;
        $display("ERROR: Simulation timeout!");
        $finish;
    end
    
endmodule