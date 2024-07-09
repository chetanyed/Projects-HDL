
module write_back (
    input clk,rst,ResultSrcW,
    input [31:0] PCplus4W,ALUresultW,ReadDataW,
    output [31:0] ResultW
);

mux2 #(32) result_mux(.d0(ALUresultW),
                     .d1(ReadDataW),
                     .sel(ResultSrcW),
                     .y(ResultW));

    endmodule
