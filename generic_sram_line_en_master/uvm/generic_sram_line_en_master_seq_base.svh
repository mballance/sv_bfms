

class generic_sram_line_en_master_seq_base `generic_sram_line_en_master_plist extends uvm_sequence #(generic_sram_line_en_master_seq_item);
	typedef generic_sram_line_en_master_seq_base `generic_sram_line_en_master_params this_t;
	`uvm_object_param_utils(this_t)
	
	static const string report_id = "generic_sram_line_en_master_seq_base";
	
	function new(string name="generic_sram_line_en_master_seq_base");
		super.new(name);
	endfunction
	
	task body();
		`uvm_error(report_id, "base-class body task not overridden");
	endtask
	
endclass



