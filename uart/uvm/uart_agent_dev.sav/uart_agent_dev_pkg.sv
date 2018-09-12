/****************************************************************************
 * uart_agent_dev_pkg.sv
 ****************************************************************************/
`include "uvm_macros.svh"
`include "uvmdev_macros.svh"


/**
 * Package: uart_agent_dev_pkg
 * 
 * TODO: Add package documentation
 */
package uart_agent_dev_pkg;
	import uvm_pkg::*;
	import uvmdev_pkg::*;
	import vmon_client_pkg::*;
	import uart_serial_agent_pkg::*;

	`include "uart_agent_dev.svh"

endpackage


