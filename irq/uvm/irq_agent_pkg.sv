
`include "uvm_macros.svh"

`define irq_plist  
`define irq_params 
`define irq_vif_t virtual irq_bfm `irq_params

package irq_agent_pkg;
	import uvm_pkg::*;

	`include "irq_config.svh"
	`include "irq_seq_item.svh"
	`include "irq_driver.svh"
	`include "irq_monitor.svh"
	`include "irq_seq_base.svh"
	`include "irq_agent.svh"
endpackage



