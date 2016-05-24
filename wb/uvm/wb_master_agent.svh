

/**
 * Class: wb_master_agent
 */
class wb_master_agent extends uvm_agent;

	`uvm_component_utils(wb_master_agent)

	const string report_id = "wb_master_agent";

	wb_master_driver								m_driver;
	uvm_sequencer #(wb_master_seq_item)			m_seqr;
	wb_master_monitor								m_monitor;
	
	uvm_analysis_port #(wb_master_seq_item)		m_mon_out_ap;
	uvm_analysis_port #(wb_master_seq_item)		m_drv_out_ap;
	
	wb_master_config								m_cfg;
	
	
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		// Obtain the config object for this agent
		m_cfg = wb_master_config::get_config(this);
		
		if (m_cfg.has_driver) begin
			m_driver = wb_master_driver::type_id::create("m_driver", this);
			
			// Create driver analysis port
			m_drv_out_ap = new("m_drv_out_ap", this);
		end
		
		if (m_cfg.has_sequencer) begin
			m_seqr = new("m_seqr", this);
		end
	
		if (m_cfg.has_monitor) begin
			m_monitor = wb_master_monitor::type_id::create("m_monitor", this);
			
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

endclass



