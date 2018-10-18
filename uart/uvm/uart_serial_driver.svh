

class uart_serial_driver `uart_serial_plist extends uvm_driver #(uart_serial_seq_item);
	
	typedef uart_serial_driver `uart_serial_params this_t;
	typedef uart_serial_config `uart_serial_params cfg_t;
	
	`uvm_component_param_utils (this_t);

	const string report_id = "uart_serial_driver";
	
	uvm_analysis_port #(uart_serial_seq_item)		ap;
	
	cfg_t													m_cfg;
	bit												m_reset;
	semaphore										m_reset_sem = new(0);
	semaphore										m_tx_done_sem = new(0);
	
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		ap = new("ap", this);
		
		m_cfg = cfg_t::get_config(this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction
	
	task reset();
		if (!m_reset) begin
			m_reset = 1;
			m_reset_sem.put(1);
		end
	endtask
	
	task tx_done();
		m_tx_done_sem.put(1);
	endtask
	
	task run_phase(uvm_phase phase);
		uart_serial_seq_item		item;
		
		forever begin
			if (!m_reset) begin
				m_reset_sem.get(1);
			end
			
			seq_item_port.get_next_item(item);
			// TODO: execute the sequence item
//			item.print();
		
`ifdef HAVE_HDL_VIRTUAL_INTERFACE
			m_cfg.vif.uart_serial_bfm_do_tx(item.data);
`endif
			
			// Send the item to the analysis port
			ap.write(item);
			
			// Wait for tx to complete
			m_tx_done_sem.get(1);
			
			seq_item_port.item_done();
		end
	endtask
endclass



