module controller ( input   [5:0]   OpD, FunctD,
                    output          MemtoRegD, MemWriteD,
                    output          PCSrcD, ALUSrcD,
                    output          RegDstD, RegWriteD,
                    output          JumpD,
                    output  [2:0]   ALUControlD,
                    input   [4:0]       RsD, RtD, RsE, RtE,
                    output              RegWriteE, RegWriteM, RegWriteW,
                    input   [4:0]       WriteRegE, WriteRegM, WriteRegW,
                    output              ForwardAD, ForwardBD,
                    output  [1:0]       ForwardAE, ForwardBE,
                    output              MemtoRegE, MemtoRegM,
                    output              StallF, StallD,
                    output                  BranchD,
                    output              FlushE);
    
    wire [1:0]  ALUOpD;
    wire        ConditionD;

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
endmodule