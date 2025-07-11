class apb_coverage_model extends uvm_subscriber #(transaction);
`uvm_component_utils(apb_coverage_model)



  
  transaction tr;

covergroup cg;
  
  option.per_instance=1;

  cg_addr:coverpoint tr.Paddr{
     // bins addr_min = {[0:0]};
  //bins addr_max = {[127:127]};
  bins addr_range[] = {[0:127]};
  //bins addr_invalid = {[128:$]};
	  }


// cg_rdata:coverpoint tr.Prdata{
//       bins rdata_min = {[0:0]};
// 	  bins rdata_max = {32'hFFFFFFFF};
// 	  bins rdata_8bit_range = {[0:(2**8)-1]};
// 	  bins rdata_16bit_range = {[(2**8):(2**16)-1]};
//       bins rdata_24bit_range = {[(2**16):(2**24)-1]};
//       bins rdata_32bit_range = {[(2**24):$]};
// 	  }

// cg_wdata:coverpoint tr.Pwdata{
//       bins wdata_min = {[0:0]};
// 	  bins wdata_max = {32'hFFFFFFFF};
// 	  bins wdata_8bit_range = {[0:(2**8)-1]};
// 	  bins wdata_16bit_range = {[(2**8):(2**16)-1]};
//       bins wdata_24bit_range = {[(2**16):(2**24)-1]};
//       bins wdata_32bit_range = {[(2**24):$]};
// 	  }



cg_w_r:coverpoint tr.Pwrite{
      bins write = {1};
	  bins read  = {0};
	  }

cg_slverr:coverpoint tr.pslverr{
     bins pslverr_assert = {1};
	 bins pslverr_not_assert = {0};
	 }


cg_ready:coverpoint tr.pready{
     bins pready_assert = {1};
	 bins pready_not_assert = {0};
	 }



cg_psel:coverpoint tr.psel{
     bins psel_assert = {1};
	 }
cg_enable:coverpoint tr.penable{
     bins penable_assert = {1};
	 }


cc_addr_slv_w_r:cross  cg_w_r, cg_addr;


endgroup
  
  function new(string name ="apb_coverage_model", uvm_component parent);
  super.new(name,parent);
  cg =new;
  endfunction

  //Build Phase
  function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  tr=transaction::type_id::create("tr"); 
  endfunction


  function void write(transaction t);
  tr=t;
    `uvm_info("COVERAGE",$sformatf("Got transaction for coverage"),UVM_LOW)
  cg.sample();
  endfunction 

//   virtual function void write_R(apb_transaction tr2);
//   tr = tr2;
//   `uvm_info("COVERAGE",$sformatf("Got read transaction for coverage"),UVM_LOW)

//   cg.sample();
//   endfunction


  endclass