module controller ( input   [5:0]   OpD, FunctD,    
                    output          MemtoRegW, MemWriteM,
                    output          PCSrcD, ALUSrcE,
                    output          RegDstE,
                                                RegWriteW,
                    output          JumpD,
                    output  [2:0]   ALUControlE,
                    input   [4:0]       RsD, RtD, RsE, RtE,
                    output              RegWriteE, RegWriteM, 
                    input   [4:0]       WriteRegE, WriteRegM, WriteRegW,
                    output              ForwardAD, ForwardBD,
                    output  [1:0]       ForwardAE, ForwardBE,
                    output              MemtoRegE, MemtoRegM,
                    output              StallF, StallD,
                    output                      BranchD,
                    output              FlushE,
                    input                   ConditionD);
    
    maindec md (OpD,
                MemtoRegD, MemWriteD,
                BranchD, ALUSrcD,
                RegDstD, RegWriteD,
                JumpD,
                ALUOpD);
    
    aludec ad ( FunctD, ALUOpD, ALUControlD);

    assign PCSrcD = BranchD & ConditionD;

    hazard h (  RsD, RtD, RsE, RtE,
                RegWriteE, RegWriteM, RegWriteW,
                WriteRegE, WriteRegM, WriteRegW,
                ForwardAD, ForwardBD, ForwardAE, ForwardBE,
                MemtoRegE, MemtoRegM,
                StallF, StallD,
                BranchD,
                FlushE);
    
    floprc #(8) de (clk, reset, FlushE,
                    {RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD},
                    {RegWriteE, MemtoRegE, MemWriteE, ALUControlE, ALUSrcE, RegDstE});
    
    flopr #(3) em ( clk, reset,
                    {RegWriteE, MemtoRegE, MemWriteE},
                    {RegWriteM, MemtoRegM, MemWriteM});
    
    flopr #(2) mw ( clk, reset,
                    {RegWriteM, MemtoRegM},
                    {RegWriteW, MemtoRegW});
endmodule