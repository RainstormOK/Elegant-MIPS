module mips (   input           clk, reset,
                output  [31:0]  PC,
                input   [31:0]  Instr,
                output          MemWrite,
                output  [31:0]  ALUOut, WriteData,
                input   [31:0]  ReadData);

    controller c (  InstrD[31:26], InstrD[5:0],
                    MemtoRegD, MemWriteD,
                    PCSrcD, ALUSrcD,
                    RegDstD, RegWriteD,
                    JumpD,
                    ALUControlD,
                        RsD[4:0], RtD[4:0], RsE[4:0], RtE[4:0],
                        RegWriteE, RegWriteM, RegWriteW,
                        WriteRegE[4:0], WriteRegM[4:0], WriteRegW[4:0],
                        ForwardAD, ForwardBD, ForwardAE, ForwardBE,
                        MemtoRegE, MemtoRegM,
                        StallF, StallD,
                        BranchD,
                        FlushE);
endmodule