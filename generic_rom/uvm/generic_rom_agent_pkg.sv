
`include "uvm_macros.svh"

`define GENERIC_ROM_AGENT_PLIST  #(parameter int ADDRESS_WIDTH=10, DATA_WIDTH=32)
`define GENERIC_ROM_AGENT_PARAMS #(ADDRESS_WIDTH, DATA_WIDTH)

package generic_rom_agent_pkg;
	import uvm_pkg::*;
	
	`include "generic_rom_config.svh"
	`include "generic_rom_seq_item.svh"
	`include "generic_rom_driver.svh"
	`include "generic_rom_monitor.svh"
	`include "generic_rom_seq_base.svh"
	`include "generic_rom_agent.svh"
endpackage



