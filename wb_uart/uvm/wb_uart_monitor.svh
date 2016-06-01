

class wb_uart_monitor extends uvm_monitor;

	uvm_analysis_port #(wb_uart_seq_item)			ap;
	
	wb_uart_config									m_cfg;
	
	const string report_id = "wb_uart_monitor";
	
	`uvm_component_utils(wb_uart_monitor)
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		// Obtain the config object
		m_cfg = wb_uart_config::get_config(this);
	
		// Create the analysis port
		ap = new("ap", this);

	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
		// TODO: implement wb_uart_monitor run_phase
	endtask
	
	
endclass


