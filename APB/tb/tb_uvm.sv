
`include "apb_pkg.svh"
import apb_pkg::*;
import uvm_pkg::*;
   
`include"uvm_macros.svh"

module tb;

  apb_if vif();

slave apb_slave (vif);

initial begin
    vif.pclk<=0;
end

always #5 vif.pclk<=~vif.pclk;

initial begin
  uvm_config_db#(virtual apb_if)::set(null,"*","vif",vif);
    run_test("test");
end

initial begin
    $dumpfile("dumb.vcd");
    $dumpvars;
end
endmodule
