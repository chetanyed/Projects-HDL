class env extends uvm_env;
`uvm_component_utils(env)

agent a;
scoreboard sco;
apb_coverage_model cov_gp;

function new(string path="env",uvm_component parent=null);
super.new(path,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
a=agent::type_id::create("a",this);
sco=scoreboard::type_id::create("sco",this);
cov_gp=apb_coverage_model::type_id::create("cov_gp",this);
endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
a.mon.send.connect(sco.recv);
a.mon.send.connect(cov_gp.analysis_export);
endfunction
endclass