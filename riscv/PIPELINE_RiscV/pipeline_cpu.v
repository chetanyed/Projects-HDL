`include "fetch_cycle.v"
`include "decode_cycle.v"
`include "execution_cycle.v"
`include "memory_cycle.v"
`include "write_back.v"
`include "hazard_unit.v"
`include "branch_detection.v"
module pipeline_cpu (
    input clk,rst
);
wire PCsrcE;
wire [31:0]PCtargetE,PCtargetE2,stalled_PC,instrD,PCD,PCplus4D,PCplus4E,PCplus4M,PCplus4W,ResultW,PCE,ALUresultM,ALUresultW,WriteDataM,ReadDataW,RD1E,RD2E,ImmextE;
wire RegwriteM,RegwriteW,RegwriteE,ALUsrcE,MemwriteE,MemwriteM,BranchE,ResultsrcE,ResultsrcM,ResultsrcW,stalled_PCsrcE,branch_sel,Flush,PCsrcE2;
wire [4:0] RDW,RDE,RDM,RS1E,RS2E;
wire [2:0] ALUcontrolE;
wire [1:0] ForwardAE,ForwardBE;
fetch_mod fetch(.clk(clk),
                .rst(rst),
                .PCsrcE(PCsrcE2),
                .PCtargetE(PCtargetE2),
                .Flush(Flush),
                .instrD(instrD),
                .PCD(PCD),
                .PCplus4D(PCplus4D)
                );

decode_mod decode(.clk(clk),
                  .rst(rst),
                  .RegwriteW(RegwriteW),
                  .instrD(instrD),
                  .PCD(PCD),
                  .PCplus4D(PCplus4D),
                  .ResultW(ResultW),
                  .RDW(RDW),
                  .RegwriteE(RegwriteE),
                  .ALUsrcE(ALUsrcE),
                  .MemwriteE(MemwriteE),
                  .BranchE(BranchE),
                  .ResultsrcE(ResultsrcE),
                  .ALUcontrolE(ALUcontrolE),
                  .RD1E(RD1E),
                  .RD2E(RD2E),
                  .PCE(PCE),
                  .PCplus4E(PCplus4E),
                  .ImmextE(ImmextE),
                  .RdE(RDE),
                  .RS1E(RS1E),
                  .RS2E(RS2E)
                  );

execution_mod execute (.clk(clk),
                       .rst(rst),
                       .regWriteE(RegwriteE),
                       .ALUsrcE(ALUsrcE),
                       .MemwriteE(MemwriteE),
                       .BranchE(BranchE),
                       .ResultSrcE(ResultsrcE),
                       .ALUcontrolE(ALUcontrolE),
                       .RD1E(RD1E),
                       .RD2E(RD2E),
                       .PCE(PCE),
                       .PCplus4E(PCplus4E),
                       .ImmextE(ImmextE),
                       .Rde(RDE),
                       .ForwardAE(ForwardAE),
                       .ForwardBE(ForwardBE),
                       .ResultW(ResultW),
                       .PCtargetE(PCtargetE),
                       .ALUresultM(ALUresultM),
                       .WriteDataM(WriteDataM),
                       .PCplus4M(PCplus4M),
                       .RdM(RDM),
                       .PCsrcE(PCsrcE),
                       .RegWriteM(RegwriteM),
                       .ResultSrcM(ResultsrcM),
                       .MemwriteM(MemwriteM)
                       );

Memory_mod Memory(.clk(clk),
                  .rst(rst),
                  .ALUresultM(ALUresultM),
                  .WriteDataM(WriteDataM),
                  .PCplus4M(PCplus4M),
                  .RdM(RDM),
                  .RegWriteM(RegwriteM),
                  .ResultSrcM(ResultsrcM),
                  .MemwriteM(MemwriteM),
                  .RegWriteW(RegwriteW),
                  .ResultSrcW(ResultsrcW),
                  .ReadDataW(ReadDataW),
                  .ALUresultW(ALUresultW),
                  .PCplus4W(PCplus4W),
                  .RdW(RDW)
                  );

write_back writeback(.clk(clk),
                     .rst(rst),
                     .ResultSrcW(ResultsrcW),
                     .PCplus4W(PCplus4W),
                     .ALUresultW(ALUresultW),
                     .ReadDataW(ReadDataW),
                     .ResultW(ResultW)
                     );

Hazard_unit Hazard(.RS1E(RS1E),
                   .RS2E(RS2E),
                   .RdM(RDM),
                   .RdW(RDW),
                   .rst(rst),
                   .RegwriteM(RegwriteM),
                   .RegwriteW(RegwriteW),
                   .ForwardAE(ForwardAE),
                   .ForwardBE(ForwardBE)
                   );

Branch_Handling Branch(.clk(clk),
                       .rst(rst),
                       .PCsrcE(PCsrcE),
                       .PCtargetE(PCtargetE),
                       .stalled_PC(stalled_PC),
                       .stalled_PCsrcE(stalled_PCsrcE),
                       .sel(branch_sel),
                       .Flush(Flush));

mux2 #(1) Branch_Mux(.d0(PCsrcE),
                .d1(stalled_PCsrcE),
                .sel(branch_sel),
                .y(PCsrcE2));

mux2 #(32) Branch_MuxPC(.d0(PCtargetE),
                .d1(stalled_PC),
                .sel(branch_sel),
                .y(PCtargetE2));



endmodule
