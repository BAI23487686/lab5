module tb_KEY_DEBOUNCE;  

// Parameters and Inputs  
reg sys_clk;  
reg sys_rst_n;  
reg key_in;  
wire key_flag;  

// Instantiate the KEY_DEBOUNCE module  
KEY_DEBOUNCE #(  
    .CNT_MAX(20'd999_999) // 设定计数器的最大值  
) uut (  
    .sys_clk(sys_clk),  
    .sys_rst_n(sys_rst_n),  
    .key_in(key_in),  
    .key_flag(key_flag)  
);  

// Clock Generation  
initial begin  
    sys_clk = 0;  
    forever #10 sys_clk = ~sys_clk; // 50MHz clock  
end  

// Test Procedure  
initial begin  
    // Initialize Inputs  
    sys_rst_n = 0; // Start with reset  
    key_in = 1;    // Key not pressed  
    
    // Release reset  
    #20 sys_rst_n = 1; // Release reset after 20 ns  

    // Test Case: Simulate Button Press  
    #100;  // Wait for 100 ns  
    key_in = 0; // Simulate key press (active low)  
    #2000000;   // Wait sufficient time for 20ms debounce (2,000,000 ns or 20ms)  
    key_in = 1; // Release key  
    #500000;    // Wait for additional time to observe key_flag, this can be adjusted  

    // Additional Key Press Simulation  
    #50000; // Wait 50ns  
    key_in = 0; // Press key again  
    #2000000;  // Wait for 20ms debounce  
    key_in = 1; // Release key  
    #500000;   // Wait for flag to reset  

    // Finish Simulation  
    #100;  
    $finish; // End simulation  
end  

// Monitor Key Flag  
initial begin  
    $monitor("Time: %0dns, key_in: %b, key_flag: %b", $time, key_in, key_flag);  
end  

endmodule