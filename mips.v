module mips (   input           clk, reset,
                output  [31:0]  PCF,
                input   [31:0]  InstrF,
                output          MemWriteM,
                output  [31:0]  ALUOutM, WriteDataM,
                input   [31:0]  ReadDataM,
                output  [31:0]      PCW,
                output              RegWriteW,
                output  [4:0]       WriteRegW,
                output  [31:0]      ResultW);

    wire [31:0] InstrD;
    wire MemtoRegW, PCSrcD, ALUSrcE, RegDstE, JumpD;
    wire [2:0] ALUControlE;
    wire [4:0] RsD, RtD, RsE, RtE;
    wire RegWriteE, RegWriteM;
    wire [4:0] WriteRegE, WriteRegM;
    wire [1:0] ForwardAD, ForwardBD, ForwardAE, ForwardBE;
    wire MemtoRegE, MemtoRegM;
    wire StallF, StallD, BranchD, FlushE, ConditionD;

    controller c (  clk, reset,
                    InstrD[31:26], InstrD[5:0],
                    MemtoRegW, MemWriteM,
                    PCSrcD, ALUSrcE,
                    RegDstE,
                                RegWriteW,
                    JumpD,
                    ALUControlE,
                        RsD, RtD, RsE, RtE,
                        RegWriteE, RegWriteM, 
                        WriteRegE, WriteRegM, WriteRegW,
                        ForwardAD, ForwardBD, ForwardAE, ForwardBE,
                        MemtoRegE, MemtoRegM,
                        StallF, StallD,
                                BranchD,
                        FlushE,
                            ConditionD);
    
    datapath dp (   clk, reset,
                    InstrF,
                    InstrD,
                    MemtoRegW, MemWriteM,
                    PCSrcD, ALUSrcE,
                    RegDstE,
                                RegWriteW,
                    JumpD,
                    ALUControlE,
                        RsD, RtD, RsE, RtE,
                        RegWriteE, RegWriteM, 
                        WriteRegE, WriteRegM, WriteRegW,
                        ForwardAD, ForwardBD, ForwardAE, ForwardBE,
                        MemtoRegE, MemtoRegM,
                        StallF, StallD,
                        BranchD,
                        FlushE,
                            ConditionD,
                                    WriteDataM,
                                    ReadDataM,
                                    PCF,
                                        PCW,
                                        ResultW, ALUOutM);
endmodule