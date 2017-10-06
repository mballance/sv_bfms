

class axi4_seq_base `axi4_plist extends uvm_sequence #(axi4_seq_item);
	typedef axi4_seq_base `axi4_params this_t;
	`uvm_object_param_utils(this_t)
	
	static const string report_id = "axi4_seq_base";
	
	function new(string name="axi4_seq_base");
		super.new(name);
	endfunction
	
	task body();
		`uvm_error(report_id, "base-class body task not overridden");
	endtask
	
endclass



