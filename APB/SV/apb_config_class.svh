class apb_config_class extends uvm_object;
  `uvm_object_utils(apb_config_class)
    
    function new(string path="config");
        super.new(path);
    endfunction

uvm_active_passive_enum is_active =UVM_ACTIVE;

endclass