// Code your design here
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: vamsi
// 
// Create Date: 29.05.2023 21:42:01
// Design Name: 
// Module Name: smart_traffic_light_controller
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
// main module

module smart_traffic_light_controller(
    output MR,
    output MY,
    output MG,
    output SR,
    output SY,
    output SG,
    input reset,
    input C,
    input Clk
);

    wire TS, TL, ST;

    timer part1 (
        .TS(TS),
        .TL(TL),
        .ST(ST),
        .Clk(Clk)
    );

    fsm part2 (
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

endmodule

// TIMER MODULE:
`timescale 1ns / 1ps

module timer(
    output TS,
    output TL,
    input ST,
    input Clk
);

    integer value;

    assign TS = (value >= 4);
    assign TL = (value >= 14);

    always @ (posedge ST or posedge Clk) begin
        if (ST == 1) begin
            value = 0;
        end else begin
            value = value + 1;
        end
    end

endmodule

// FSM MODULE
`timescale 1ns / 1ps

module fsm(
    output MR,
    output MY,
    output MG,
    output SR,
    output SY,
    output SG,
    output ST,
    input TS,
    input TL,
    input C,
    input reset,
    input Clk
);

    reg [5:0] state;
    reg ST_reg;

    parameter mainroadgreen = 6'b001100;
    parameter mainroadyellow = 6'b010100;
    parameter sideroadgreen = 6'b100001;
    parameter sideroadyellow = 6'b100010;

    assign MR = state[5];
    assign MY = state[4];
    assign MG = state[3];
    assign SR = state[2];
    assign SY = state[1];
    assign SG = state[0];
    assign ST = ST_reg;

    initial begin
        state = mainroadgreen;
        ST_reg = 0;
    end

    always @ (posedge Clk) begin
        if (reset) begin
            state = mainroadgreen;
            ST_reg = 1;
        end else begin
            ST_reg = 0;
            case (state)
                mainroadgreen: begin
                    if (TL & C) begin
                        state = mainroadyellow;
                        ST_reg = 1;
                    end
                end
                mainroadyellow: begin
                    if (TS) begin
                        state = sideroadgreen;
                        ST_reg = 1;
                    end
                end
                sideroadgreen: begin
                    if (TL | ~C) begin
                        state = sideroadyellow;
                        ST_reg = 1;
                    end
                end
                sideroadyellow: begin
                    if (TS) begin
                        state = mainroadgreen;
                        ST_reg = 1;
                    end
                end
            endcase
        end
    end

endmodule