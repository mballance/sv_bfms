

class irq_driver `irq_plist extends uvm_driver #(irq_seq_item);
	
	typedef irq_driver `irq_params this_t;
	typedef irq_config `irq_params cfg_t;
	
	`uvm_component_param_utils (this_t);

	const string report_id = "irq_driver";
	
	uvm_analysis_port #(irq_seq_item)		ap;
	
	cfg_t													m_cfg;
	
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
	
	task run_phase(uvm_phase phase);
		irq_seq_item		item = irq_seq_item::type_id::create("item");
		
		forever begin
			m_cfg.vif.irq_bfm_wait_irq();
			
			$display("IRQ");
			
			ap.write(item);
			
			m_cfg.vif.irq_bfm_debounce(m_cfg.debounce_cnt);

//			seq_item_port.get_next_item(item);
//			// TODO: execute the sequence item
//			item.print();
//			
//			// Send the item to the analysis port
//			ap.write(item);
//			
//			seq_item_port.item_done();
		end
	endtask
endclass



