class agent extends uvm_agent;

`uvm_component_utils(agent)
driver drv;
monitor mon;
uvm_sequencer #(transaction) seqr;
apb_config_class conf;

function new(string path="agent",uvm_component parent=null);
  super.new(path,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
conf=apb_config_class::type_id::create("conf");
mon=monitor::type_id::create("mon",this);

  if(conf.is_active==UVM_ACTIVE)begin
drv=driver::type_id::create("drv",this);
seqr=uvm_sequencer#(transaction)::type_id::create("seqr",this);
end
endfunction

  virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);

    if(conf.is_active==UVM_ACTIVE)begin
    drv.seq_item_port.connect(seqr.seq_item_export);
end
endfunction


endclass