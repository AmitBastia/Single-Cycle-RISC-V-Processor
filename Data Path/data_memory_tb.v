`timescale 1ns / 1ps

module RISC_V_Testbench;

    reg clk;
    reg reset;

    wire zero;

    wire [31:0] PC;
    wire [31:0] WriteData;
    wire [31:0] ReadData;
    wire [31:0] ALUResult;

    // Control signals
    wire PCSrc;
    wire jump;
    wire ALUSrc;
    wire RegWrite;
    wire MemWrite;

    wire [1:0] ResultSrc;
    wire [1:0] ImmSrc;

    wire [2:0] ALUControl;

    // Instruction
    wire [31:0] instruction;


    //================================================
    // Instruction Memory
    //================================================

    Instruction_Memory IM (
        .A(PC),
        .RD(instruction)
    );


    //================================================
    // Control Unit
    //================================================

    Control_Unit CU (
        .op(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7b5(instruction[30]),

        .zero(zero),

        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),

        .ResultSrc(ResultSrc),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl)
    );


    //================================================
    // Datapath
    //================================================

    Data_Path datapath (
        .clk(clk),
        .reset(reset),

        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),

        .ResultSrc(ResultSrc),
        .ALUControl(ALUControl),
        .ImmSrc(ImmSrc),

        .instruction(instruction),

        .zero(zero),

        .PC(PC),
        .WriteData(WriteData),
        .ReadData(ReadData),
        .ALUResult(ALUResult)
    );


    //================================================
    // Clock
    //================================================

    initial begin
        clk = 0;

        forever #5 clk = ~clk;
    end


    //================================================
    // Reset
    //================================================

    initial begin

        reset = 1;

        #12;

        reset = 0;

        #100;

        $finish;

    end


    //================================================
    // Waveform
    //================================================

    initial begin

        $dumpfile("dump.vcd");
        $dumpvars(0, RISC_V_Testbench);

    end


endmodule