// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Module Name: smart_traffic_light_controller_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module smart_traffic_light_controller_tb;

    reg TS;
    reg TL;
    reg Clk;
    reg C;
    reg reset;

    // Outputs
    wire MR;
    wire MY;
    wire MG;
    wire SR;
    wire SY;
    wire SG;
    wire ST;

    // Instantiate the Unit Under Test (UUT)
    fsm dut (
        .MR(MR), 
        .MY(MY), 
        .MG(MG), 
        .SR(SR), 
        .SY(SY), 
        .SG(SG), 
        .ST(ST), 
        .TS(TS), 
        .TL(TL), 
        .C(C), 
        .reset(reset), 
        .Clk(Clk)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);

        // Initialize Inputs
        TS = 0;
        TL = 0;
        C = 0;
        reset = 1;
        Clk = 0;

        // Wait for some time
        #100;
        
        // Apply test vectors
        TS = 0; TL = 1; C = 1; reset = 0;
        #100;
        
        TS = 0; TL = 0; C = 0; reset = 1;
        #100;
        
        TS = 1; TL = 1; C = 0; reset = 0;
        #100;
        
        // End of test
        $finish;
    end

    // Clock generation
    always #50 Clk = ~Clk; // Clock period of 100ns

endmodule