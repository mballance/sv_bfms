/****************************************************************************
 * hella_cache_master_api_pkg.sv
 ****************************************************************************/

/**
 * Package: hella_cache_master_api_pkg
 * 
 * TODO: Add package documentation
 */
package hella_cache_master_api_pkg;
	
	interface class hella_cache_master_api;
		
		pure virtual function void bfm_rsp(
			int unsigned		tag,
			int unsigned		typ,
			longint unsigned	data);
		
	endclass

endpackage


