

class hella_cache_master_seq_base `hella_cache_master_plist extends uvm_sequence #(hella_cache_master_seq_item `hella_cache_master_params);
	typedef hella_cache_master_seq_base `hella_cache_master_params this_t;
	`uvm_object_param_utils(this_t)
	
	static const string report_id = "hella_cache_master_seq_base";
	
	function new(string name="hella_cache_master_seq_base");
		super.new(name);
	endfunction
	
	task body();
		`uvm_error(report_id, "base-class body task not overridden");
	endtask
	
endclass



