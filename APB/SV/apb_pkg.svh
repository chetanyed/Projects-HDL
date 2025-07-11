package apb_pkg;

  timeunit 1ns;
  timeprecision 100ps;
  import uvm_pkg::*;
   
  `include"uvm_macros.svh"
  `include "apb_config_class.svh"
  `include "apb_sequences.svh"
  `include "apb_driver.svh"
  `include "apb_monitor.svh"
  `include "apb_scoreboard.svh"
  `include "apb_agent.svh"
  `include "apb_coverage.svh"
  `include "apb_env.svh"
  `include "apb_test.svh"


endpackage
