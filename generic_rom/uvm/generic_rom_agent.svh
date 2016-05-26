

/**
 * Class: generic_rom_agent
 */
class generic_rom_agent `GENERIC_ROM_AGENT_PLIST extends uvm_agent;
	
	typedef generic_rom_agent `GENERIC_ROM_AGENT_PARAMS this_t;
	
	`uvm_component_param_utils(this_t)
	
	typedef generic_rom_driver `GENERIC_ROM_AGENT_PARAMS  drv_t;
	typedef generic_rom_monitor `GENERIC_ROM_AGENT_PARAMS mon_t;
	typedef generic_rom_config  `GENERIC_ROM_AGENT_PARAMS cfg_t;
	typedef generic_rom_rw_api  `GENERIC_ROM_AGENT_PARAMS api_t;

	const string report_id = "generic_rom_agent";

	drv_t											m_driver;
	uvm_sequencer #(generic_rom_seq_item)			m_seqr;
	mon_t											m_monitor;
	
	uvm_analysis_port #(generic_rom_seq_item)		m_mon_out_ap;
	uvm_analysis_port #(generic_rom_seq_item)		m_drv_out_ap;
	
	cfg_t											m_cfg;
	
	api_t 											m_api;
	
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
		m_api = new(this);
	endfunction
	
	function sv_bfms_rw_api_if get_api();
		return m_api;
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		// Obtain the config object for this agent
		m_cfg = cfg_t::get_config(this);
		
		if (m_cfg.has_driver) begin
			m_driver = drv_t::type_id::create("m_driver", this);
			
			// Create driver analysis port
			m_drv_out_ap = new("m_drv_out_ap", this);
		end
		
		if (m_cfg.has_sequencer) begin
			m_seqr = new("m_seqr", this);
		end
	
		if (m_cfg.has_monitor) begin
			m_monitor = mon_t::type_id::create("m_monitor", this);
			
			// Create the monitor analysis port
			m_mon_out_ap = new("m_mon_out_ap", this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		// Connect the driver and sequencer
		if (m_cfg.has_driver && m_cfg.has_sequencer) begin
			m_driver.seq_item_port.connect(m_seqr.seq_item_export);
		end
		
		if (m_cfg.has_monitor) begin
			// Connect the monitor to the monitor AP
			m_monitor.ap.connect(m_mon_out_ap);
		end
		
		if (m_cfg.has_driver) begin
			// Connect the driver to the driver AP
			m_driver.ap.connect(m_drv_out_ap);
		end
		
	endfunction

	virtual task write8(
			bit[31:0]			addr,
			bit[7:0]			data);
		m_cfg.vif.generic_rom_write8(addr, data);
	endtask
	
	virtual task read8(
			bit[31:0]			addr,
			output bit[7:0]		data);
		m_cfg.vif.generic_rom_read8(addr, data);
	endtask
	
	virtual task write32(
			bit[31:0]			addr,
			bit[31:0]			data);
		m_cfg.vif.generic_rom_write32(addr, data);
	endtask
	
	virtual task read32(
			bit[31:0]			addr,
			output bit[31:0]	data);
		m_cfg.vif.generic_rom_read32(addr, data);
	endtask
	
endclass



