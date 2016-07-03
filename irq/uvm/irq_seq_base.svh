

class irq_seq_base `irq_plist extends uvm_sequence #(irq_seq_item);
	typedef irq_seq_base `irq_params this_t;
	`uvm_object_param_utils(this_t)
	
	static const string report_id = "irq_seq_base";
	
	function new(string name="irq_seq_base");
		super.new(name);
	endfunction
	
	task body();
		`uvm_error(report_id, "base-class body task not overridden");
	endtask
	
endclass



