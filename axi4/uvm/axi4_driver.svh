

class axi4_driver `axi4_plist extends uvm_driver #(axi4_seq_item);
	
	typedef axi4_driver `axi4_params this_t;
	typedef axi4_config `axi4_params cfg_t;
	
	`uvm_component_param_utils (this_t);

	const string report_id = "axi4_driver";
	
	uvm_analysis_port #(axi4_seq_item)		ap;
	
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
		axi4_seq_item		item;
		
		forever begin
			seq_item_port.get_next_item(item);
			// TODO: execute the sequence item
			item.print();
			
			// Send the item to the analysis port
			ap.write(item);
			
			seq_item_port.item_done();
		end
	endtask
endclass



