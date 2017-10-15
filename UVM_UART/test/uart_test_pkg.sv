package uart_test_pkg;

import uvm_pkg::*;

`include "uvm_macros.svh"

`include "uart_agent_cfg.sv"
`include "uart_env_cfg.sv"

`include "uart_transaction.sv"
`include "uart_driver.sv"
`include "uart_monitor.sv"
`include "uart_sequencer.sv"
`include "uart_test_sequences.sv"
`include "uart_agent.sv"
`include "uart_agent_top.sv"

`include "uart_scoreboard.sv"
//`include "uart_coverage.sv"
`include "uart_coverage_subscriber.sv"
`include "uart_virtual_sequencer.sv"
`include "uart_tb.sv"

`include "uart_virtual_sequences.sv"
`include "uart_test_lib.sv"

endpackage
