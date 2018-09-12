

class generic_sram_byte_en_driver `GENERIC_SRAM_BYTE_EN_PLIST extends uvm_driver #(generic_sram_byte_en_seq_item);
	
	typedef generic_sram_byte_en_driver `GENERIC_SRAM_BYTE_EN_PARAMS this_t;
	typedef generic_sram_byte_en_config `GENERIC_SRAM_BYTE_EN_PARAMS cfg_t;
	
	`uvm_component_param_utils (this_t);

	const string report_id = "generic_sram_byte_en_driver";
	
	uvm_analysis_port #(generic_sram_byte_en_seq_item)		ap;
	
	cfg_t													m_cfg;
	
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	virtual task write8(
		bit[31:0]			addr,
		bit[7:0]			data);
//		m_agent.write8(addr, data);
	endtask
	
	virtual task read8(
		bit[31:0]			addr,
		output bit[7:0]		data);
//		m_agent.read8(addr, data);
	endtask
	
	virtual task write32(
		bit[31:0]			addr,
		bit[31:0]			data);
//		m_agent.write32(addr, data);
	endtask
	
	virtual task read32(
		bit[31:0]			addr,
		output bit[31:0]	data);
//		m_agent.read32(addr, data);
	endtask	
	

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		ap = new("ap", this);
		
		m_cfg = cfg_t::get_config(this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
		generic_sram_byte_en_seq_item		item;
		
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



