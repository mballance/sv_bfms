

class generic_sram_byte_en_monitor `GENERIC_SRAM_BYTE_EN_PLIST extends uvm_monitor;

	uvm_analysis_port #(generic_sram_byte_en_seq_item)			ap;

	typedef generic_sram_byte_en_monitor `GENERIC_SRAM_BYTE_EN_PARAMS this_t;
	typedef generic_sram_byte_en_config `GENERIC_SRAM_BYTE_EN_PARAMS cfg_t;
	
	cfg_t									m_cfg;
	
	const string report_id = "generic_sram_byte_en_monitor";
	
	`uvm_component_param_utils(this_t)
	
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
		// TODO: implement generic_sram_byte_en_monitor run_phase
	endtask
	
	
endclass


