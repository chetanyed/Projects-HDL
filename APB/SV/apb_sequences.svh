
typedef enum bit [1:0] {read=2'b00, write=2'b01, rst=2'b11  } opr_mode;

class transaction extends uvm_sequence_item;

  

  rand opr_mode op;
logic psel,penable;
logic         Pwrite;
rand logic [31:0] Paddr;
rand logic [31:0] Pwdata;

// output signals for monitor

logic pready;
logic pslverr;
logic [31:0] Prdata;

`uvm_object_utils_begin(transaction)
`uvm_field_int(Pwrite,UVM_ALL_ON)
`uvm_field_int(Paddr,UVM_ALL_ON)
`uvm_field_int(Pwdata,UVM_ALL_ON)
`uvm_field_int(pready,UVM_ALL_ON)
`uvm_field_int(pslverr,UVM_ALL_ON)
`uvm_field_int(Prdata,UVM_ALL_ON)
`uvm_field_enum(opr_mode,op,UVM_DEFAULT)
`uvm_object_utils_end

constraint correct_data {Paddr<=127;}

  constraint error_data  {Paddr>127; op!=rst;}
  
  constraint error_insertion {Paddr dist { ['h0:32'h0000007f]:/5,[32'h00000080:32'hffffffff]:/1};  op dist {[0:1]:/1, 3:=0};  }



function new(string path="transaction");
    
    super.new(path);
    
endfunction
endclass


class write_data extends uvm_sequence #(transaction);

  `uvm_object_utils(write_data)

transaction req;


 function new(string path="write_data");
    super.new(path);
endfunction

virtual task body();
repeat(15) begin
req=transaction::type_id::create("req");
req.correct_data.constraint_mode(1);
req.error_data.constraint_mode(0);

start_item(req);
assert (req.randomize);
req.op=write;
finish_item(req);
end
endtask
endclass

class read_data extends uvm_sequence #(transaction);

`uvm_object_utils(read_data)

transaction req;


function new(string path="read_data");
    super.new(path);
endfunction

virtual task body();
repeat(15) begin
req=transaction::type_id::create("req");
req.correct_data.constraint_mode(1);
req.error_data.constraint_mode(0);
start_item(req);
  assert (req.randomize);

req.op=read;
finish_item(req);
end
endtask
endclass

class err_data extends uvm_sequence #(transaction);

  `uvm_object_utils(err_data)

transaction req;

  function new(string path="err_data");
    super.new(path);
endfunction

virtual task body();
repeat(128) begin
req=transaction::type_id::create("req");
req.correct_data.constraint_mode(0);
req.error_data.constraint_mode(1);
req.error_insertion.constraint_mode(0);
start_item(req);
assert (req.randomize);
finish_item(req);
end
endtask
endclass

class write_readB extends uvm_sequence #(transaction);

`uvm_object_utils(write_readB)

transaction req;
int burst_write_count=0;
int burst_read_count=0;

function  new(string path="write_readb");
    super.new(path);
endfunction

virtual task body();

  repeat(128) begin
req=transaction::type_id::create("req");
req.correct_data.constraint_mode(0);
req.error_data.constraint_mode(0);
req.error_insertion.constraint_mode(0);
start_item(req);
req.Pwrite=1'b1;
req.Paddr=burst_write_count;
req.Pwdata=$urandom;
req.op=opr_mode'(1);
finish_item(req);
burst_write_count++;
end

  repeat(128) begin
req=transaction::type_id::create("req");
req.correct_data.constraint_mode(0);
req.error_data.constraint_mode(0);
req.error_insertion.constraint_mode(0);
start_item(req);
req.Pwrite=1'b0;
req.Paddr=burst_read_count;
req.op=opr_mode'(0);
finish_item(req);
burst_read_count++;
end
endtask
endclass

class r_w_err_insertion_bulk extends uvm_sequence #(transaction);

`uvm_object_utils(r_w_err_insertion_bulk)

transaction req;


  function  new(string path="bulk_error");
    super.new(path);
endfunction

virtual task body();

  repeat(128) begin
req=transaction::type_id::create("req");
req.correct_data.constraint_mode(0);
req.error_data.constraint_mode(0);
    req.error_insertion.constraint_mode(1);
start_item(req);
assert (req.randomize);
req.op=opr_mode'(1);
finish_item(req);
end

  repeat(128) begin
req=transaction::type_id::create("req");
    req.correct_data.constraint_mode(0);
req.error_data.constraint_mode(0);
  req.error_insertion.constraint_mode(1);
start_item(req);
assert (req.randomize);
req.op=opr_mode'(0);
finish_item(req);
end
endtask
endclass








class reset_seq extends uvm_sequence #(transaction);
    `uvm_object_utils(reset_seq)
    function new(string path="rst_seq");
        super.new(path);
    endfunction 

virtual task body();
repeat(15) begin
req=transaction::type_id::create("req");
req.correct_data.constraint_mode(1);
req.error_data.constraint_mode(0);
start_item(req);
  assert (req.randomize);
req.op=rst;
finish_item(req);
end
endtask
endclass

