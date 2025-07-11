// Code your design here
// Code your design here
// Code your design here
// Code your design here
// Code your design here
// Code your design here
`include "apb_master.svh"
`include "apb_slave.svh"

module apb_interface (
    input pclk,prst,
    input trans,w_r,
    input ext_wait,ext_pready,
    input [7:0] apb_addr,apb_write_data,
    output [7:0] apb_read_data_out

);

wire w_psel,w_penable,w_pslverr,w_pwrite,w_pready,pready_out;
wire [7:0] w_paddr,w_pwdata,w_prdata;

  assign pready_out=(ext_wait===1'b1)?ext_pready:w_pready;

master mast (.pclk(pclk),
             .prst(prst),
             .trns(trans),
             .w_r(w_r),
             .apb_addr(apb_addr),
             .apb_write_data(apb_write_data),
             .prdata(w_prdata),
             .pready(pready_out),
             .pslverr(w_pslverr),
             .psel(w_psel),
             .penable(w_penable),
             .pwrite(w_pwrite),
             .paddr(w_paddr),
             .pwdata(w_pwdata),
             .apb_read_data_out(apb_read_data_out)
);

slave slv(.pclk(pclk),
          .prst(prst),
          .pwrite(w_pwrite),
          .psel(w_psel),
          .penable(w_penable),
          .paddr(w_paddr),
          .pwdata(w_pwdata),
          .prdata(w_prdata),
          .pready(w_pready),
          .pslverr(w_pslverr)
);










endmodule