
class uart_serial_tx_seq extends uart_serial_seq_base;
	
	`uvm_object_utils(uart_serial_tx_seq)
	
	byte unsigned				data[$];
	
	
	/****************************************************************
	 * new()
	 ****************************************************************/
	function new(string name="uart_serial_tx_seq");
		super.new(name);
	endfunction
	
	/****************************************************************
	 * body()
	 ****************************************************************/
	task body();
		uart_serial_seq_item item =
			uart_serial_seq_item::type_id::create("item");
	
		for (int i=0; i<data.size(); i++) begin
			item.data = data[i];
			start_item(item);
			finish_item(item);
		end
	endtask

endclass



