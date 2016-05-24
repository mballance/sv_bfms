

class generic_rom_monitor `GENERIC_ROM_AGENT_PLIST extends uvm_monitor;

	uvm_analysis_port #(generic_rom_seq_item)			ap;
	
	typedef generic_rom_monitor `GENERIC_ROM_AGENT_PARAMS this_t;
	typedef generic_rom_config  `GENERIC_ROM_AGENT_PARAMS cfg_t;
	
	cfg_t										m_cfg;
	
	const string report_id = "generic_rom_monitor";
	
	`uvm_component_utils(generic_rom_monitor)
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		// Obtain the config object
		m_cfg = cfg_t::get_config(this);
	
		// Create the analysis port
		ap = new("ap", this);

	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
		// TODO: implement generic_rom_monitor run_phase
	endtask
	
	
endclass


