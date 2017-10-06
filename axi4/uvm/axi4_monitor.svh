

class axi4_monitor `axi4_plist extends uvm_monitor;

	uvm_analysis_port #(axi4_seq_item)			ap;

	typedef axi4_monitor `axi4_params this_t;
	typedef axi4_config `axi4_params  cfg_t;
	
	cfg_t									m_cfg;
	
	const string report_id = "axi4_monitor";
	
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
		// TODO: implement axi4_monitor run_phase
	endtask
	
	
endclass


