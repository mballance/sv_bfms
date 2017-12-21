

class hella_cache_master_monitor `hella_cache_master_plist extends uvm_monitor;

	typedef hella_cache_master_seq_item `hella_cache_master_params  seq_i_t;
	typedef hella_cache_master_monitor `hella_cache_master_params this_t;
	typedef hella_cache_master_config `hella_cache_master_params  cfg_t;
	
	uvm_analysis_port #(seq_i_t)			ap;
	
	cfg_t									m_cfg;
	
	const string report_id = "hella_cache_master_monitor";
	
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
		// TODO: implement hella_cache_master_monitor run_phase
	endtask
	
	
endclass


