
typedef class uart_serial_driver;
typedef class uart_serial_agent;

`ifdef HAVE_HDL_VIRTUAL_INTERFACE
class uart_serial_api_impl extends uart_serial_api `uart_serial_plist;
	uart_serial_driver `uart_serial_params  m_drv;
	uart_serial_monitor `uart_serial_params m_monitor;
	
	virtual task reset();
		m_drv.reset();
	endtask
		
	virtual task tx_done();
		m_drv.tx_done();
	endtask
		
	virtual task rx_done(byte unsigned data);
		m_monitor.rx_done(data);
	endtask
	
endclass
`endif

/**
 * Class: uart_serial_agent
 */
class uart_serial_agent `uart_serial_plist extends uvm_agent;
	
	typedef uart_serial_agent  `uart_serial_params this_t;
	`uvm_component_param_utils (this_t)


	const string report_id = "uart_serial_agent";
	
	typedef uart_serial_driver `uart_serial_params 	drv_t;
	typedef uart_serial_config `uart_serial_params 	cfg_t;
	typedef uart_serial_monitor `uart_serial_params	mon_t;

	drv_t											m_driver;
	uvm_sequencer #(uart_serial_seq_item)			m_seqr;
	mon_t											m_monitor;

	uvm_analysis_port #(uart_serial_seq_item)		m_mon_out_ap;
	uvm_analysis_port #(uart_serial_seq_item)		m_drv_out_ap;
	
	cfg_t											m_cfg;
	
	uart_serial_seq_item							m_recv_item;
`ifdef HAVE_HDL_VIRTUAL_INTERFACE
	uart_serial_api_impl `uart_serial_params		m_api_impl;
`endif
	
	class recv_monitor extends uvm_subscriber #(uart_serial_seq_item);
		mailbox #(byte unsigned)		mbox = new();
		
		function new(string name, uvm_component parent=null);
			super.new(name, parent);
		endfunction

		/**
		 * Function: write
		 *
		 * Override from class 
		 */
		function void write(input uart_serial_seq_item t);
			void'(mbox.try_put(t.data));
		endfunction
		
	endclass
	
	recv_monitor								m_recv_monitor;
	
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		m_recv_item = uart_serial_seq_item::type_id::create("m_recv_item");
	
		// Obtain the config object for this agent
		m_cfg = cfg_t::get_config(this);
	
		uvm_config_db #(uart_serial_agent)::set(uvm_top, m_cfg.vif_path,
				uart_serial_config::report_id, this);
		
		if (m_cfg.has_driver) begin
			m_driver = drv_t::type_id::create("m_driver", this);
			
			// Create driver analysis port
			m_drv_out_ap = new("m_drv_out_ap", this);
		end
		
		if (m_cfg.has_sequencer) begin
			m_seqr = new("m_seqr", this);
		end

		$display("UART: has_monitor=%0d", m_cfg.has_monitor);
		if (m_cfg.has_monitor) begin
			m_monitor = mon_t::type_id::create("m_monitor", this);
			
			// Create the monitor analysis port
			m_mon_out_ap = new("m_mon_out_ap", this);
			
			m_recv_monitor = new("m_recv_monitor", this);
		end
		
`ifdef HAVE_HDL_VIRTUAL_INTERFACE
		m_api_impl = new();
		m_api_impl.m_drv = m_driver;
		m_api_impl.m_monitor = m_monitor;
		m_cfg.vif.m_api = m_api_impl;
`endif
		
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
			m_monitor.ap.connect(m_recv_monitor.analysis_export);
		end
		
		if (m_cfg.has_driver) begin
			// Connect the driver to the driver AP
			m_driver.ap.connect(m_drv_out_ap);
		end
		
	endfunction
	
	task putc(bit[7:0] data);
		uart_serial_tx_seq seq = uart_serial_tx_seq::type_id::create("seq");
		seq.data.push_back(data);
		seq.start(m_seqr);
	endtask
	
	task getc(
		output bit[7:0] data, 
		output bit valid, 
		input int timeout=-1);
		
		// TODO: handle timeout
		m_recv_monitor.mbox.get(data);
	endtask

	// Internal method
	task recv(bit[7:0] data);
		m_recv_item.data = data;
		m_mon_out_ap.write(m_recv_item);
	endtask

endclass



