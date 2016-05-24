

class generic_rom_seq_base extends uvm_sequence #(generic_rom_seq_item);
	`uvm_object_utils(generic_rom_seq_base);
	
	static const string report_id = "generic_rom_seq_base";
	
	function new(string name="generic_rom_seq_base");
		super.new(name);
	endfunction
	
	task body();
		`uvm_error(report_id, "base-class body task not overridden");
	endtask
	
endclass



