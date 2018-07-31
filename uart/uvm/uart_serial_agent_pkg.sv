
`include "uvm_macros.svh"

`define uart_serial_plist
`define uart_serial_params 
`define uart_serial_vif_t virtual uart_serial_bfm_core `uart_serial_params

package uart_serial_agent_pkg;
	import uvm_pkg::*;
	import uart_serial_api_pkg::*;

	`include "uart_serial_config.svh"
	`include "uart_serial_seq_item.svh"
	`include "uart_serial_driver.svh"
	`include "uart_serial_monitor.svh"
	`include "uart_serial_seq_base.svh"
	`include "uart_serial_tx_seq.svh"
	`include "uart_serial_agent.svh"
endpackage



