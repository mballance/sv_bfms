
`include "uvm_macros.svh"

`define generic_sram_line_en_master_plist  #(parameter int NUM_ADDR_BITS=32, parameter int NUM_DATA_BITS=32)
`define generic_sram_line_en_master_params #(NUM_ADDR_BITS, NUM_DATA_BITS)
`define generic_sram_line_en_master_vif_t virtual generic_sram_line_en_master_core `generic_sram_line_en_master_params

package generic_sram_line_en_master_agent_pkg;
	import uvm_pkg::*;

	`include "generic_sram_line_en_master_config.svh"
	`include "generic_sram_line_en_master_seq_item.svh"
	`include "generic_sram_line_en_master_driver.svh"
	`include "generic_sram_line_en_master_monitor.svh"
	`include "generic_sram_line_en_master_seq_base.svh"
	`include "generic_sram_line_en_master_agent.svh"
endpackage



