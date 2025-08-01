

// pclk,prst->global signals
//trns->have to initiate a transfer
//w_r->write or read(1-0)
//dummy signals->for the cpu or bridge
//pwrite->write singal given to slave
//pready->input from slave indicating i am ready (handshaking)
//psel,penable -state deciding signals
//paddr,pwdata-> to slave
//prdata-> from slave(data read)





module master (
    input logic pclk,prst,
    input logic trns,w_r,
    input logic [31:0] apb_addr,apb_write_data, //dummy signal
    input logic [31:0] prdata,
    input logic pready,pslverr,
    output logic psel,penable,pwrite,
    output logic paddr,pwdata,
    output logic [31:0] apb_read_data_out
);

localparam IDLE=3'b001,SETUP=3'b010,ACCESS=3'b100;
reg [2:0] new_state,present_state;

  always @(posedge pclk or negedge prst) begin
    if(!prst)
      present_state<=IDLE;
    
    else
       present_state<=new_state;
end

  always_comb begin
case(present_state) 

IDLE: begin 
    penable=0;
    psel=1'b0;
    if(trns && prst)begin
    new_state=SETUP;
    end
    
    else
        new_state=IDLE;
end

SETUP:begin
    penable=0;
    if(trns) begin
    pwrite=w_r;
    psel=1'b1;
    paddr=apb_addr;
    pwdata=apb_write_data;
    new_state=ACCESS;
    end
    else
    new_state=IDLE;
end

ACCESS:begin
  if(trns) begin 
    penable=1'b1;
      if(pready && !pslverr)begin
      if(!pwrite)begin
        apb_read_data_out=prdata;
        new_state=SETUP;
      end
    end
     else
      new_state<=ACCESS;
  end
    
 else
   penable=1'b0;
   new_state=IDLE;
end
 
default:new_state=IDLE;
endcase
end




endmodule
