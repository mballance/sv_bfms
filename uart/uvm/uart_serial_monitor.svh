

class uart_serial_monitor `uart_serial_plist extends uvm_monitor;

	uvm_analysis_port #(uart_serial_seq_item)			ap;

	typedef uart_serial_monitor `uart_serial_params this_t;
	typedef uart_serial_config `uart_serial_params  cfg_t;
	
	uart_serial_seq_item m_item = uart_serial_seq_item::type_id::create("item");
	
	cfg_t									m_cfg;
	
	const string report_id = "uart_serial_monitor";
	
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
	
	task rx_done(byte unsigned data);
		m_item.data = data;
		ap.write(m_item);
	endtask
	
endclass


