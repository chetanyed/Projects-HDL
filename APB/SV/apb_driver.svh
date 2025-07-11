class driver extends uvm_driver #(transaction);
    
    `uvm_component_utils(driver)
    virtual apb_if aif;
    transaction req;
    function new(string path="DRV",uvm_component parent=null);
        super.new(path,parent);
    endfunction 

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        req=transaction::type_id::create("req");
      if(!uvm_config_db #(virtual apb_if)::get(this,"","vif",aif))
           `uvm_error("DRV","unable to access interface")
    endfunction

    task rst_dut();
        repeat(5)begin
        aif.prst<=1'b0;
        aif.pwrite<=1'b0;
        aif.psel<=1'b0;
        aif.penable<=1'b0;
        aif.paddr<='h0;
        aif.pwdata<='h0;
          `uvm_info("DRV","RESET_PHASE",UVM_MEDIUM)
        
        @(posedge aif.pclk);
        end
    endtask


    virtual task run_phase(uvm_phase phase);
       rst_dut();
      forever begin 
      seq_item_port.get_next_item(req);

       if(req.op==rst)begin
        aif.prst<=1'b0;
        aif.pwrite<=1'b0;
        aif.psel<=1'b0;
        aif.penable<=1'b0;
        aif.paddr<='h0;
        aif.pwdata<='h0;
        @(posedge aif.pclk);
      end

    else if(req.op==write)begin
      
        aif.psel<=1'b1;
        aif.pwrite<=1'b1;
        aif.prst<=1'b1;
        aif.paddr<=req.Paddr;
        aif.pwdata<=req.Pwdata;
      @(posedge aif.pclk);
        aif.penable<=1'b1;
      `uvm_info("DRV",$sformatf("mode:%0s addr:%0h wdata:%0h rdata:%0h pslverr:%0d",req.op.name(),req.Paddr,req.Pwdata,req.Prdata,req.pslverr),UVM_NONE)
      @(posedge aif.pclk);
        aif.penable<=1'b0;
        req.pslverr<=aif.pslverr;
    end

    else if(req.op==read)begin
        aif.psel<=1'b1;
        aif.pwrite<=1'b0;
        aif.prst<=1'b1;
        aif.paddr<=req.Paddr;
      @(posedge aif.pclk);
        aif.penable<=1'b1;
      `uvm_info("DRV",$sformatf("mode:%0s addr:%0h rdata:%0h pslverr:%0d",req.op.name(),req.Paddr,req.Prdata,req.pslverr),UVM_NONE)
      @(posedge aif.pclk);
        aif.penable<=1'b0;
        req.pslverr<=aif.pslverr;
        req.Prdata<=aif.prdata;
    end
   seq_item_port.item_done();
      end
    endtask

endclass 