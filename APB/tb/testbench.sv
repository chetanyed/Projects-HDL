// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples



interface apb_if(input pclk);
  
  logic trans,w_r;
  logic ext_wait,ext_pready;
  logic [7:0] apb_addr,apb_write_data;
  logic [7:0] apb_read_data_out;
  
  
  task apb_write_no_wait(input [7:0] wdata,input [7:0] waddr);
    @(negedge pclk);
    trans<=1'b1;
    w_r<=1'b1;
    apb_addr<=waddr;
    apb_write_data<=wdata;
    repeat (3) @(posedge pclk);
    trans<=1'b0;
    w_r<=1'bx;
    apb_addr<=8'hxx;
    apb_write_data<=8'hxx;
  endtask
  
  
    task apb_write_wait(input [7:0] wdata,input [7:0] waddr);
    @(negedge pclk);
    trans<=1'b1;
    w_r<=1'b1;
    apb_addr<=waddr;
    apb_write_data<=wdata;
    repeat(2) @(posedge pclk);
    @(negedge pclk);
    ext_wait<=1'b1;
    ext_pready<=1'b0;
    @(negedge pclk);
    ext_wait<=1'b0;
    @(posedge pclk);
    trans<=1'b0;
    w_r<=1'bx;
    apb_addr<=8'hxx;
    apb_write_data<=8'hxx;
    ext_wait<=1'b0;
    ext_pready<=1'bx;
  endtask
  
  
  task apb_read_no_wait(input [7:0] raddr, output int read_data);
    @(negedge pclk);
    trans<=1'b1;
    w_r<=1'b0;
    apb_addr<=raddr;
    repeat(3) @(posedge pclk);
    read_data=apb_read_data_out;
    trans<=1'b0;
    w_r<=1'bx;
    apb_addr<=8'hxx;
  endtask
  
  
  task apb_read_wait(input [7:0] raddr,output int read_data);
    @(negedge pclk);
    trans<=1'b1;
    w_r<=1'b0;
    apb_addr<=raddr;
    repeat(2) @(posedge pclk);
    @(negedge pclk);
    ext_wait<=1'b1;
    ext_pready<=1'b0;
    @(posedge pclk);
    ext_wait<=1'b0;
    @(negedge pclk);
    read_data<=apb_read_data_out;
    @(posedge pclk);
    trans<=1'b0;
    w_r<=1'bx;
    apb_addr<=8'hxx;
    ext_wait<=1'b0;
    ext_pready<=1'bx;
    
  endtask

endinterface
  



module tb;

bit pclk=0,prst;

int read_data;
apb_if aif(pclk);

task check(input [7:0] read_data, input [7:0] expected);
   if(read_data==expected)begin
     $display("%0t [APB] CORRECT DATA READ: %0d",$realtime,read_data);
   end
   else
     $display("%0t [APB] MISMATCH DATA_READ:%0d, EXPECTED:%0d",$time,read_data,expected);
endtask 
  
  task reset_test();
    prst<=1'b0;
    repeat(2) @(posedge pclk);
    prst<=1'b1;
  endtask

apb_interface apb(.pclk(pclk),
                  .prst(prst),
                  .trans(aif.trans),
                  .w_r(aif.w_r),
                  .ext_wait(aif.ext_wait),
                  .ext_pready(aif.ext_pready),
                  .apb_addr(aif.apb_addr),
                  .apb_write_data(aif.apb_write_data),
                  .apb_read_data_out(aif.apb_read_data_out)
                  );
  
always #5 pclk=~pclk;
initial begin
  $display("APB_TEST");

  $display("RESET_TEST_BEGIN");
   reset_test();
   $display("RESET_TEST_END");
   
    for(int i=0;i<32;i++)begin
      $display("%0t [APB] WRITE WITH NO WAIT STATE BEGINS",$realtime);
      aif.apb_write_no_wait(3*i,i);
      $display("%0t [APB] WRITE WITH WAIT STATE BEGINS",$realtime);
      aif.apb_write_wait(i+32,i+32);
    end
  repeat(3) @(posedge pclk);
        for(int i=0;i<32;i++)begin
          $display("%0t [APB] READ WITH NO WAIT STATE BEGINS",$realtime);
          aif.apb_read_no_wait(i,read_data);
          $display("%0t [APB] CHECKING READ DATA TO EXPECTED DATA",$realtime);
          check(read_data,3*i);
          $display("%0t [APB] READ WITH WAIT STATE BEGINS",$realtime);
          aif.apb_read_wait(i+32,read_data);
          $display("%0t [APB] CHECKING READ DATA TO EXPECTED DATA", $realtime);
          check(read_data,i+32);
    end
  $display("APB_TEST_END");
end

initial begin

  $monitor("%0t [APB] TRANSFER:%0d, WRITE_READ:%0d,EXT_PREADY:%0d, READ_DATA:%0d",$realtime,aif.trans,aif.w_r,aif.ext_pready,aif.apb_read_data_out);

end
  
  
initial begin
  $dumpvars;
  $dumpfile("dump.vcd");
  #6000;
  $finish;
  
end

endmodule
    
