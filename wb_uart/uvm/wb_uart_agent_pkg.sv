
`include "uvm_macros.svh"

`ifndef WB_UART_BFM_NAME
	`define WB_UART_BFM_NAME wb_uart_bfm
`endif

package wb_uart_agent_pkg;
	import uvm_pkg::*;
	import sv_bfms_api_pkg::*;
	
	`include "wb_uart_config.svh"
	`include "wb_uart_seq_item.svh"
	`include "wb_uart_driver.svh"
	`include "wb_uart_monitor.svh"
	`include "wb_uart_seq_base.svh"
	`include "wb_uart_line_listener.svh"
	`include "wb_uart_agent.svh"
endpackage



