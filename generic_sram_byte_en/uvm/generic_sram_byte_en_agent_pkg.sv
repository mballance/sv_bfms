
`include "uvm_macros.svh"

`define GENERIC_SRAM_BYTE_EN_PLIST  #(parameter int ADDRESS_WIDTH=10, DATA_WIDTH=32)
`define GENERIC_SRAM_BYTE_EN_PARAMS #(ADDRESS_WIDTH, DATA_WIDTH)

`ifndef GENERIC_SRAM_BYTE_EN_BFM_NAME
	`define GENERIC_SRAM_BYTE_EN_BFM_NAME generic_sram_byte_en_bfm
`endif

package generic_sram_byte_en_agent_pkg;
	import uvm_pkg::*;
	import sv_bfms_api_pkg::*;

	`include "generic_sram_byte_en_rw_api.svh"
	`include "generic_sram_byte_en_config.svh"
	`include "generic_sram_byte_en_seq_item.svh"
	`include "generic_sram_byte_en_driver.svh"
	`include "generic_sram_byte_en_monitor.svh"
	`include "generic_sram_byte_en_seq_base.svh"
	`include "generic_sram_byte_en_agent.svh"
endpackage



