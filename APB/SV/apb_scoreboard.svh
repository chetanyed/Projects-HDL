class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)
uvm_analysis_imp #(transaction,scoreboard) recv;
  bit[31:0] golden [128]='{default:0};
bit [31:0] data_rd=0;    

  function new(string path="SCO",uvm_component parent=null);
        super.new(path,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
recv=new("recv",this);
endfunction


virtual function void write(transaction req);

if(req.op==rst)begin
`uvm_info("SCO","RESET_STATE",UVM_NONE);
end

  else if(req.op==write)begin
if(req.pslverr)begin
    `uvm_info("SCO","Slave error detectod-inavlid write transaction",UVM_NONE)
end

else begin
    golden[req.Paddr]=req.Pwdata;
  `uvm_info("SCO",$sformatf("[SCO WRITE] Addr:%0h data:%0h golden_data:%0h",req.Paddr,req.Pwdata,golden[req.Paddr]),UVM_NONE)
end
end


  else if (req.op==read) begin
    if(req.pslverr)begin
        `uvm_info("SCO","Slave error detectod-inavlid read transaction",UVM_NONE);
    end
    else begin
        data_rd=golden[req.Paddr];
        if(data_rd==req.Prdata)begin
          `uvm_info("SCO",$sformatf("[SCO:READ DATA MATCH ] Addr:%0h read_data:%0h read_data_golden:%0h",req.Paddr,req.Prdata,golden[req.Paddr]),UVM_NONE)
        end
        else begin
          `uvm_info("SCO",$sformatf("[SCO:READ DATA MISMATCH ] Addr:%0h data:%0h read_data_golden:%0h",req.Paddr,req.Prdata,golden[req.Paddr]),UVM_NONE)
        end
        end
    end
endfunction

endclass 