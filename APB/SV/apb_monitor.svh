class monitor extends uvm_monitor;
`uvm_component_utils(monitor) 
uvm_analysis_port #(transaction) send;
transaction req;
virtual apb_if aif;   

function new(string path="MON",uvm_component parent=null);
        super.new(path,parent);
    endfunction 

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
req=transaction::type_id::create("req");
send=new("send",this);
  if(!uvm_config_db #(virtual apb_if)::get(this,"","vif",aif))
`uvm_error("MON","unable to access interface")

endfunction

virtual task run_phase (uvm_phase phase);
forever begin
  @(posedge aif.pclk);
  if(!aif.prst)begin
req.op=rst;
`uvm_info("MON","RESET DETECTED",UVM_NONE)
send.write(req);
end

  if(aif.prst && aif.pwrite)begin
    @(posedge aif.pready);
req.psel=aif.psel;
req.Pwrite=aif.pwrite;
req.op=write;
req.Pwdata=aif.pwdata;
req.Paddr=aif.paddr;
req.pslverr=aif.pslverr;
    `uvm_info("MON",$sformatf("[WRITE] Data:%0h, Addr:%0h, slverr:%0d",req.Pwdata,req.Paddr,req.pslverr),UVM_NONE)
send.write(req);
end

  if(aif.prst && !aif.pwrite)begin
    @(posedge aif.pready );
    req.psel=aif.psel;
    req.Pwrite=aif.pwrite;
    req.op=read;
    req.Prdata=aif.prdata;
    req.Paddr=aif.paddr;
    req.pslverr=aif.pslverr;
    `uvm_info("MON",$sformatf("[READ] Data:%0h, Addr:%0h, slverr:%0d",req.Prdata,req.Paddr,req.pslverr),UVM_NONE)
    send.write(req);
    end
end

endtask 
endclass 