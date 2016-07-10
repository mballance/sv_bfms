

class uart_serial_seq_base `uart_serial_plist extends uvm_sequence #(uart_serial_seq_item);
	typedef uart_serial_seq_base `uart_serial_params this_t;
	`uvm_object_param_utils(this_t)
	
	static const string report_id = "uart_serial_seq_base";
	
	function new(string name="uart_serial_seq_base");
		super.new(name);
	endfunction
	
	task body();
		`uvm_error(report_id, "base-class body task not overridden");
	endtask
	
endclass



