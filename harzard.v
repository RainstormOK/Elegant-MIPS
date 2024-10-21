module hazard ( input       [4:0]   RsD, RtD, RsE, RtE,
                input               RegWriteE, RegWriteM, RegWriteW,
                input       [4:0]   WriteRegE, WriteRegM, WriteRegW,
                output reg  [1:0]   ForwardAD, ForwardBD, ForwardAE, ForwardBE,
                input               MemtoRegE, MemtoRegM,
                output              StallF, StallD,
                input               BranchD,
                output              FlushE);

    always @(*) begin
        if      ((RsE != 0) && (RsE == WriteRegM) && RegWriteM)
            ForwardAE <= 2'b10;
        else if ((RsE != 0) && (RsE == WriteRegW) && RegWriteW)
            ForwardAE <= 2'b01;
        else
            ForwardAE <= 2'b00;
    end

    always @(*) begin
        if      ((RtE != 0) && (RtE == WriteRegM) && RegWriteM) 
            ForwardBE <= 2'b10;
        else if ((RtE != 0) && (RtE == WriteRegW) && RegWriteW)
            ForwardBE <= 2'b01;
        else
            ForwardAE <= 2'b00;
    end

    wire LWStall;
    assign LWStall = ((RsD == RtE) || (RtD == RtE)) && MemtoRegE;

    always @(*) begin
        if      ((RsD != 0) && (RsD == WriteRegM) && RegWriteM)
            ForwardAD <= 2'b10;
        else if ((RsD != 0) && (RsD == WriteRegW) && RegWriteW)
            ForwardAD <= 2'b01;
        else
            ForwardAD <= 2'b00;
    end

    always @(*) begin
        if      ((RtD != 0) && (RtD == WriteRegM) && RegWriteM)
            ForwardBD <= 2'b10;
        else if ((RtD != 0) && (RtD == WriteRegW) && RegWriteW)
            ForwardBD <= 2'b01;
        else
            ForwardBD <= 2'b00;
    end

    wire BranchStall;
    assign BranchStall = 
                BranchD && RegWriteE && (RsD == WriteRegE || RtD == WriteRegE)
                    ||
                BranchD && MemtoRegM && (RsD == WriteRegM || RtD == WriteRegM);

    assign {StallF, StallD,
            FlushE} = {3{LWStall || BranchStall}};
endmodule