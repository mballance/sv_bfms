

class wb_master_seq_base extends uvm_sequence #(wb_master_seq_item);
	`uvm_object_utils(wb_master_seq_base);
	
	static const string report_id = "wb_master_seq_base";
	
	function new(string name="wb_master_seq_base");
		super.new(name);
	endfunction
	
	task body();
		`uvm_error(report_id, "base-class body task not overridden");
	endtask
	
endclass



