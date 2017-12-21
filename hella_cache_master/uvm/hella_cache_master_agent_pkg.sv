
`include "uvm_macros.svh"

`define hella_cache_master_plist  #(parameter int NUM_ADDR_BITS=32, parameter int NUM_DATA_BITS=32, parameter int NUM_TAG_BITS=7)
`define hella_cache_master_params #(NUM_ADDR_BITS, NUM_DATA_BITS, NUM_TAG_BITS)
`define hella_cache_master_vif_t virtual hella_cache_master_bfm_core `hella_cache_master_params

package hella_cache_master_agent_pkg;
	import uvm_pkg::*;
	import sv_bfms_api_pkg::*;

	`include "hella_cache_master_config.svh"
	`include "hella_cache_master_seq_item.svh"
	`include "hella_cache_master_driver.svh"
	`include "hella_cache_master_monitor.svh"
	`include "hella_cache_master_seq_base.svh"
	`include "hella_cache_master_agent.svh"
    `include "hella_cache_master_access_seq.svh" 
    `include "hella_cache_master_rw_api.svh"
endpackage



