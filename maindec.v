module maindec (input   [5:0] OpD,
                output          MemtoRegD, MemWriteD,
                output          BranchD, ALUSrcD,
                output          RegDstD, RegWriteD,
                output          JumpD,
                output  [1:0]   ALUOpD);
    
    reg [8:0] ControlsD;

    assign {RegWriteD, RegDstD, ALUSrcD,
            BranchD, MemWriteD,
            MemtoRegD, JumpD,
            ALUOpD} = Controls;

    always @(*) begin
        case(OpD)
            6'b000000:  Controls <= 9'b110000010;   // R-type
            6'b100011:  Controls <= 9'b101001000;   // LW
            6'b101011:  Controls <= 9'b001010000;   // SW
            6'b000100:  Controls <= 9'b000100001;   // BEQ
            6'b111111:  Controls <= 9'b000100001;   // BBT
            6'b001000:  Controls <= 9'b101000000;   // ADDI
            6'b000010:  Controls <= 9'b000000100;   // J
            6'b111110:  Controls <= 9'b110000010;   // CMP
            default:    Controls <= 9'bxxxxxxxxx;   // ???
        endcase
    end
endmodule