 interface apb_if;
     logic pclk,prst,pwrite;
     logic psel;
     logic penable;
     logic [32:0] paddr;
     logic [32:0] pwdata;
     logic [32:0] prdata;
     logic pready,pslverr;


     //modport slave (
     //input pclk,prst,pwrite,psel,penable,paddr,pwdata,
     //output pready,pslverr,prdata
     //);

     //modport master 
     //output pclk,prst,pwrite,psel,penable,paddr,pwdata,
     //input pready,pslverr,prdata
     //);
endinterface
