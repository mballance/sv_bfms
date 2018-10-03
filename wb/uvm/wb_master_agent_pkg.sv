
`include "uvm_macros.svh"

`define wb_master_plist  /* #(parameter int ADDRESS_WIDTH=32, parameter int DATA_WIDTH=32) */
`define wb_master_params /* #(ADDRESS_WIDTH, DATA_WIDTH) */
`define wb_master_vif_t virtual wb_master_bfm_core `wb_master_params

package wb_master_agent_pkg;
	import uvm_pkg::*;
	import sv_bfms_api_pkg::*;
`ifdef HAVE_HDL_VIRTUAL_INTERFACE
	import wb_master_api_pkg::*;
`else
	typedef class wb_master_driver;
		
	int unsigned		path_id_map[string];
	wb_master_driver 	id_driver_map[int unsigned];
`endif

	`include "wb_master_rw_api.svh"
	`include "wb_master_config.svh"
	`include "wb_master_seq_item.svh"
	`include "wb_master_driver.svh"
	`include "wb_master_monitor.svh"
	`include "wb_master_seq_base.svh"
	`include "wb_master_reg_adapter.svh"
	`include "wb_master_agent.svh"

	/****************************************************************
	 * Interface methods for DPI-based integration
	 ****************************************************************/
`ifndef HAVE_HDL_VIRTUAL_INTERFACE

	import "DPI-C" context function int unsigned wb_master_bfm_pkg_init();
	int unsigned _init = wb_master_bfm_pkg_init();

	function automatic int unsigned wb_master_bfm_register_hvl(string path);
		int unsigned id = path_id_map.size();
		path_id_map[path] = id;
		return id;
	endfunction
	export "DPI-C" function wb_master_bfm_register_hvl;
	
	task automatic wb_master_bfm_reset_hvl(int unsigned id);
		id_driver_map[id].reset();
	endtask
	export "DPI-C" task wb_master_bfm_reset_hvl;
	
	import "DPI-C" context task wb_master_bfm_set_data_hvl(
			int unsigned		id,
			int unsigned		idx,
			longint unsigned	data);
	
	import "DPI-C" context task wb_master_bfm_get_data_hvl(
			int unsigned			id,
			int unsigned			idx,
			output longint unsigned	data);
	
	import "DPI-C" context task wb_master_bfm_request_hvl(
			int unsigned		id,
			longint unsigned	ADR,
			byte unsigned		CTI,
			byte unsigned		BTE,
			int unsigned		SEL,
			byte unsigned		WE);
	
	task automatic wb_master_bfm_response_hvl(
			int unsigned		id,
			byte unsigned		ERR);
		id_driver_map[id].response(ERR);
	endtask
	export "DPI-C" task wb_master_bfm_response_hvl;
	
`endif
	
endpackage



