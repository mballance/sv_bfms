
`include "uvm_macros.svh"

`define axi4_plist  #(parameter int ADDR_WIDTH=32, parameter int DATA_WIDTH=32, parameter int ID_WIDTH=4)
`define axi4_params #(ADDR_WIDTH, DATA_WIDTH, ID_WIDTH)
`define axi4_vif_t virtual axi4_bfm `axi4_params

package axi4_agent_pkg;
	import uvm_pkg::*;

	`include "axi4_config.svh"
	`include "axi4_seq_item.svh"
	`include "axi4_driver.svh"
	`include "axi4_monitor.svh"
	`include "axi4_seq_base.svh"
	`include "axi4_agent.svh"
endpackage



