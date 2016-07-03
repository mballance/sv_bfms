

class irq_monitor `irq_plist extends uvm_monitor;

	uvm_analysis_port #(irq_seq_item)			ap;

	typedef irq_monitor `irq_params this_t;
	typedef irq_config `irq_params  cfg_t;
	
	cfg_t									m_cfg;
	
	const string report_id = "irq_monitor";
	
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
		// TODO: implement irq_monitor run_phase
	endtask
	
	
endclass


