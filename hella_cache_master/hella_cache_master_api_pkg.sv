/****************************************************************************
 * hella_cache_master_api_pkg.sv
 ****************************************************************************/

/**
 * Package: hella_cache_master_api_pkg
 * 
 * TODO: Add package documentation
 */
package hella_cache_master_api_pkg;

`ifdef HAVE_HDL_VIRTUAL_INTERFACE
	class hella_cache_master_api;
		
		virtual task rst();
		endtask
		
		virtual task rsp(
			int unsigned		tag,
			int unsigned		typ,
			longint unsigned	data);
		endtask

	endclass
`endif

endpackage


