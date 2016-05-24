

class generic_rom_driver `GENERIC_ROM_AGENT_PARAMS extends uvm_driver #(generic_rom_seq_item);
	
	typedef generic_rom_driver `GENERIC_ROM_AGENT_PARAMS this_t;
	typedef generic_rom_config `GENERIC_ROM_AGENT_PARAMS cfg_t;

	`uvm_component_param_utils(this_t)
	
	const string report_id = "generic_rom_driver";
	
	uvm_analysis_port #(generic_rom_seq_item)		ap;
	
	cfg_t											m_cfg;
	
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
		generic_rom_seq_item		item;
		
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



