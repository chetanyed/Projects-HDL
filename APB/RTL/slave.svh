// Code your design here
// Code your design here
`include "interface.svh"
module slave (
   apb_if vif
// input logic pclk,prst,penable,psel,pwrite \\for APB wrapper test
// input logic [31:0] paddr,pwdata
// output logic pready,pslverr
   // output [31:0] prdata
);

  reg [31:0] mem [0:127]='{default:0};
 
  always_ff @(negedge vif.pclk or negedge vif.prst) begin
    if(!vif.prst)begin
      vif.pready<=0;
      vif.prdata<='hx;
      vif.pslverr<=1'b0;      
    end
    
    else if(vif.psel && vif.penable)begin
      if(vif.paddr<32'h0000003f)begin
          vif.pready<=1'b1;
          if(vif.pwrite)
             mem[vif.paddr]<=vif.pwdata;
         else
             vif.prdata<=mem[vif.paddr];
                                end
      else begin
        vif.pslverr<=1'b1;
        vif.pready<=1'b1;
            end
                                       end
    
    else begin
      vif.pready<=1'b0;
      vif.pslverr<=1'b0;
         end
                                                     end    
endmodule
