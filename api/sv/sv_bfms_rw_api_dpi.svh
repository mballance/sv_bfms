/****************************************************************************
 * sv_bfms_rw_api_dpi.svh
 ****************************************************************************/

typedef class sv_bfms_rw_api_dpi;

// package-scope items
sv_bfms_rw_api_dpi			m_dpi_mgr = new();

/**
 * Class: sv_bfms_rw_api_dpi
 * 
 * TODO: Add class documentation
 */
class sv_bfms_rw_api_dpi;
	sv_bfms_rw_api_if			m_default;
	sv_bfms_rw_api_if			m_map[chandle];

	function new();
	endfunction
	
	static function void set_default(sv_bfms_rw_api_if api);
		m_dpi_mgr.m_default = api;
	endfunction

	task write8(
		chandle				hndl,
		int unsigned		addr,
		byte unsigned		data);
		sv_bfms_rw_api_if api;
		
		if (m_map.exists(hndl)) begin
			api = m_map[hndl];
		end else begin
			api = m_default;
		end
		
		if (api != null) begin
			api.write8(addr, data);
		end else begin
			$display("Error: No api available to perform write to 'h%08h (%0s:%0d)",
					addr, `__FILE__, `__LINE__);
		end
	endtask
	
	task read8(
		chandle					hndl,
		int unsigned			addr,
		output byte unsigned	data);
		sv_bfms_rw_api_if api;
		
		if (m_map.exists(hndl)) begin
			api = m_map[hndl];
		end else begin
			api = m_default;
		end
		
		if (api != null) begin
			api.read8(addr, data);
		end else begin
			$display("Error: No api available to perform read to 'h%08h (%0s:%0d)",
					addr, `__FILE__, `__LINE__);
		end
	endtask	
	
	task write32(
		chandle				hndl,
		int unsigned		addr,
		int unsigned		data);
		sv_bfms_rw_api_if api;
		
		if (m_map.exists(hndl)) begin
			api = m_map[hndl];
		end else begin
			api = m_default;
		end
		
		if (api != null) begin
			api.write32(addr, data);
		end else begin
			$display("Error: No api available to perform write to 'h%08h (%0s:%0d)",
					addr, `__FILE__, `__LINE__);
		end
	endtask
	
	task read32(
		chandle				hndl,
		int unsigned		addr,
		output int unsigned	data);
		sv_bfms_rw_api_if api;
		
		if (m_map.exists(hndl)) begin
			api = m_map[hndl];
		end else begin
			api = m_default;
		end
		
		if (api != null) begin
			api.read32(addr, data);
		end else begin
			$display("Error: No api available to perform read to 'h%08h (%0s:%0d)",
					addr, `__FILE__, `__LINE__);
		end
	endtask	
	
endclass

// Initialization function to obtain the SV Scope
import "DPI-C" context function int _sv_bfms_rw_api_init();

int 						m_dpi_mgr_init = _sv_bfms_rw_api_init();

task _sv_bfms_rw_api_write8(
		chandle				hndl,
		int unsigned		addr,
		byte unsigned		data);
  m_dpi_mgr.write8(hndl, addr, data);
endtask
export "DPI-C" task _sv_bfms_rw_api_write8;
	
task _sv_bfms_rw_api_read8(
		chandle					hndl,
		int unsigned			addr,
		output byte unsigned	data);
m_dpi_mgr.read8(hndl, addr, data);
endtask
export "DPI-C" task _sv_bfms_rw_api_read8;

task _sv_bfms_rw_api_write32(
	chandle				hndl,
	int unsigned		addr,
	int unsigned		data);
	m_dpi_mgr.write32(hndl, addr, data);
endtask
export "DPI-C" task _sv_bfms_rw_api_write32;
	
task _sv_bfms_rw_api_read32(
	chandle				hndl,
	int unsigned		addr,
	output int unsigned	data);
	m_dpi_mgr.read32(hndl, addr, data);
endtask
export "DPI-C" task _sv_bfms_rw_api_read32;

