

/**
 * Class: wb_uart_agent
 */
class wb_uart_agent extends uvm_agent;

	`uvm_component_utils(wb_uart_agent)

	const string report_id = "wb_uart_agent";

	wb_uart_driver								m_driver;
	uvm_sequencer #(wb_uart_seq_item)			m_seqr;
	wb_uart_monitor								m_monitor;
	
	uvm_analysis_port #(wb_uart_seq_item)		m_mon_out_ap;
	uvm_analysis_port #(wb_uart_seq_item)		m_drv_out_ap;
	
	wb_uart_config								m_cfg;
	
	wb_uart_seq_item							m_recv_item;
	
	string										m_buffer;
	
	
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
		
		m_recv_item = wb_uart_seq_item::type_id::create("m_recv_item");
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		// Obtain the config object for this agent
		m_cfg = wb_uart_config::get_config(this);
	
		uvm_config_db #(wb_uart_agent)::set(uvm_top, m_cfg.vif_path,
				wb_uart_config::report_id, this);
		
		if (m_cfg.has_driver) begin
			m_driver = wb_uart_driver::type_id::create("m_driver", this);
			
			// Create driver analysis port
			m_drv_out_ap = new("m_drv_out_ap", this);
		end
		
		if (m_cfg.has_sequencer) begin
			m_seqr = new("m_seqr", this);
		end
	
		if (m_cfg.has_monitor) begin
			m_monitor = wb_uart_monitor::type_id::create("m_monitor", this);
			
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
	
	task recv(bit[7:0]	data);
		m_recv_item.m_data = data;
		m_mon_out_ap.write(m_recv_item);
	endtask

endclass



