class test extends uvm_test;

`uvm_component_utils(test)
reset_seq rst_test;
write_readB bulk_test;
r_w_err_insertion_bulk bulk_err_test;
err_data err_test;
read_data read_test;
write_data write_test;
env e;
real coverage_percentage;
function new(string path="test",uvm_component parent=null);
super.new(path, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
e=env::type_id::create("e",this);
err_test=err_data::type_id::create("err_test");
bulk_err_test=r_w_err_insertion_bulk::type_id::create("bulk_error_test");
  bulk_test=write_readB::type_id::create("bulk_test");
endfunction
  
virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
endfunction

virtual task run_phase(uvm_phase phase);

phase.raise_objection(this);
fork
bulk_err_test.start(e.a.seqr);
bulk_test.start(e.a.seqr);
//err_test.start(e.a.seqr);  
join
phase.drop_objection(this);

endtask 
  
  
function void check_phase(uvm_phase phase);
    super.check_phase(phase);

   
    coverage_percentage = e.cov_gp.cg.get_inst_coverage();

    if (coverage_percentage < 100.0)
      `uvm_warning("COVERAGE_CHECK", $sformatf("Functional coverage incomplete: %0.2f%% achieved.", coverage_percentage))
    else
      `uvm_info("COVERAGE_CHECK", "Functional coverage goal met: 100%", UVM_LOW)
  endfunction
  



endclass