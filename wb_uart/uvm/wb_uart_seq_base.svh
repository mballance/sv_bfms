

class wb_uart_seq_base extends uvm_sequence #(wb_uart_seq_item);
	`uvm_object_utils(wb_uart_seq_base);
	
	static const string report_id = "wb_uart_seq_base";
	
	function new(string name="wb_uart_seq_base");
		super.new(name);
	endfunction
	
	task body();
		`uvm_error(report_id, "base-class body task not overridden");
	endtask
	
endclass



