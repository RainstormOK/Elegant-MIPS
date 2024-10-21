module datapath (   input           clk, reset,
                    input   [31:0]  InstrD
                    input           MemtoRegW, MemWriteM,
                    input           PCSrcD, ALUSrcE,
                    input           RegDstE,
                    input                       RegWriteW,
                    input           JumpD,
                    input   [2:0]   ALUControlE,
                    output  [4:0]       RsD, RtD, RsE, RtE,
                    input               RegWriteE, RegWriteM,
                    output  [4:0]       WriteRegE, WriteRegM, WriteRegW,
                    input   [1:0]       ForwardAD, ForwardBD, ForwardAE, ForwardBE,
                    input               MemtoRegE, MemtoRegM,
                    input               StallF, StallD,
                    input                       BranchD,
                    input               FlushE,
                    output                  ConditionD,
                    output  [31:0]                  WriteDataM,
                    input   [31:0]                  ReadDataM,
                    output  [31:0]                  PCF,
                    output  [31:0]                      PCW,
                    output  [31:0]                      ResultW);
    
    mux3 #(32) muxPC (  PCPlus4F, PCBranchD, PCJumpD,
                        {JumpD, PCSrcD},
                        PC);
    
    assign PCPlus4F = PCF + 4;

    assign {RsD, RtD, RdD} = InstrD[25:11];

    regfile rf (clk,
                RegWriteW,
                RsD, RtD, RdD,
                ResultW,
                RsDataD, RtDataD);

    assign SignImmD = {16{InstrD[15]},InstrD[15:0]};
    assign PCBranchD = PCPlus4D + (SignImmD << 2);
    assign PCJumpD = {PCPlus4D[31:28], InstrD[25:0], 2'b00};

    mux3 #(32) muxCompareDataA (RsDataD, ResultW, ALUOutM,
                                ForwardAD,
                                CompareDataA);

    mux3 #(32) muxCompareDataB (RtDataD, ResultW, ALUOutM,
                                ForwardBD,
                                CompareDataB);

    branchcond bc ( InstrD[31:26],
                    ConditionD,
                    CompareDataA, CompareDataB,
                    RtD);
    
    mux3 #(32) muxSrcAE (   RsDataE, ResultW, ALUOutM,
                            ForwardAE,
                            SrcAE);

    mux3 #(32) muxSrcBPE (  RtDataE, ResultW, ALUOutM,
                            ForwardBE,
                            SrcBPE);
    
    mux2 #(32) muxSrcBE (   SrcBPE, SignImmE,
                            ALUSrcE,
                            SrcBE);
    
    alu a ( SrcAE, SrcBE,
            ALUControlE,
            ALUOutE);
    
    mux2 #(5) muxWriteRegE (RtE, RdE,
                            RegDstE,
                            WriteRegE);
    
    mux2 #(32) muxResultW ( AluOutW, ReadDataW,
                            MemtoRegW,
                            ResultW);

    flopenr #(32) wf (  clk, reset, ~StallF,
                        PC,
                        PCF);    
    
    flopenrc #(96) fd ( clk, reset, PCSrcD | JumpD, ~StallD,
                        {InstrF, PCPlus4F, PCF},
                        {InstrD, PCPlus4D, PCD});
    
    floprc #(143) de (   clk, reset, FlushE,
                        {RsDataD, RtDataD, RsD, RtD, RdD, SignImmD, PCD},
                        {RsDataE, RtDataE, RsE, RtE, RtE, SignImmE, PCE});
    
    flopr #(101) em (clk, reset,
                    {ALUOutE, WriteDataE, WriteRegE, PCE},
                    {ALUOutM, WriteDataM, WriteRegM, PCM});

    flopr #(101) mw (clk, reset,
                    {ReadDataM, ALUOutM, WriteRegM, PCM},
                    {ReadDataW, AluOutW, WriteRegW, PCW});
endmodule