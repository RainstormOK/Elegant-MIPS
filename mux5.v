module mux5 #(parameter WIDTH = 8)
             (  input   [WIDTH-1:0] d0, d1, d2, d3, d4,
                input   [3:0]       s,
                output  [WIDTH-1:0] y);

    assign y = s[3] ? d4 : (s[2] ? d3 : (s[1] ? d2 : (s[0] ? d1 : d0)));
endmodule