
`include "uvm_macros.svh"

`define hella_cache_master_plist  #(parameter int NUM_ADDR_BITS=32, parameter int NUM_DATA_BITS=32, parameter int NUM_TAG_BITS=7)
`define hella_cache_master_params #(NUM_ADDR_BITS, NUM_DATA_BITS, NUM_TAG_BITS)
`define hella_cache_master_vif_t virtual hella_cache_master_bfm_core `hella_cache_master_params

package hella_cache_master_agent_pkg;
	import uvm_pkg::*;
	import sv_bfms_api_pkg::*;
	import hella_cache_master_api_pkg::*;

	`include "hella_cache_master_config.svh"
	`include "hella_cache_master_seq_item.svh"
	`include "hella_cache_master_driver.svh"
	`include "hella_cache_master_monitor.svh"
	`include "hella_cache_master_seq_base.svh"
	`include "hella_cache_master_agent.svh"
    `include "hella_cache_master_access_seq.svh" 
    `include "hella_cache_master_rw_api.svh"
	
`ifndef HAVE_HDL_VIRTUAL_INTERFACE
	int unsigned				m_path_id_map[string];
	int unsigned				m_id_idx = 0;
	
	function int unsigned hella_cache_master_bfm_register(string path); 
		$display("hella_cache_master_bfm_register(%0s)", path);
		m_path_id_map[path] = m_id_idx;
		return m_id_idx++;
	endfunction
	export "DPI-C" function hella_cache_master_bfm_register;
	
`endif
endpackage



