
class axi4_seq_item `axi4_plist extends uvm_sequence_item;
	typedef axi4_seq_item `axi4_params this_t;
	`uvm_object_param_utils(this_t)
	
	const string report_id = "axi4_seq_item";
	
	rand bit								is_write;
	rand bit[((AXI4_ADDRESS_WIDTH)-1):0]	addr;
	rand bit[((AXI4_DATA_WIDTH)-1:0]		data[];
	
	// TODO: Declare fields here
	
	function new(string name="axi4_seq_item");
		super.new(name);
	endfunction

	// TODO: Declare do_print, do_compare, do_copy methods

	function void do_print(uvm_printer printer);
		if (printer.knobs.sprint == 0) begin
			$display(convert2string());
		end else begin
			printer.m_string = convert2string();
		end
	endfunction

	function bit do_compare(uvm_object rhs, uvm_comparer comparer);
		bit ret = 1;
		axi4_seq_item rhs_;
		
		if (!$cast(rhs_, rhs)) begin
			return 0;
		end
		
		ret &= super.do_compare(rhs, comparer);
		
		// TODO: implement comparison logic
	
		return ret;
	endfunction

	function void do_copy(uvm_object rhs);
		axi4_seq_item rhs_;
		
		if (!$cast(rhs_, rhs)) begin
			`uvm_error(report_id, "Cast failed in do_copy()");
			return;
		end
		
		super.do_copy(rhs);
		
		// TODO: copy item-specific fields
		
	endfunction
			
endclass



