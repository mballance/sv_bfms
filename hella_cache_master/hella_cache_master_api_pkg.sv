/****************************************************************************
 * hella_cache_master_api_pkg.sv
 ****************************************************************************/

/**
 * Package: hella_cache_master_api_pkg
 * 
 * TODO: Add package documentation
 */
package hella_cache_master_api_pkg;
	
	class hella_cache_master_api;
		
		virtual function void bfm_rsp(
			int unsigned		tag,
			int unsigned		typ,
			longint unsigned	data);
		endfunction

		function void call_bfm_rsp(
			int unsigned		tag,
			int unsigned		typ,
			longint unsigned	data);
			bfm_rsp(tag, typ, data);
		endfunction
		
	endclass

endpackage


