
class hella_cache_master_seq_item `hella_cache_master_plist extends uvm_sequence_item;
	typedef hella_cache_master_seq_item `hella_cache_master_params this_t;
	`uvm_object_param_utils(this_t)
	
	const string report_id = "hella_cache_master_seq_item";
	
	typedef enum {
		MT_B = 0,
		MT_H = 1,
		MT_W = 2,
		MT_D = 3,
		MT_BU,
		MT_HU,
		MT_WU
	} type_e;
	
	typedef enum {
		M_XRD = 0, // int load
		M_XWR,     // int store
		M_PFR,     // prefetch with intent to read
		M_PFW,     // prefetch with intent to write
		M_XA_SWAP,   // Swap request
		M_FLUSH_ALL, // Flush all lines
		M_XLR,       // Load-reserve request
		M_XSC,       // 7  - store-conditional request
		M_XA_ADD,
		M_XA_XOR,
		M_XA_OR,
		M_XA_AND,
		M_XA_MIN,
		M_XA_MAX,
		M_XA_MINU,
		M_XA_MAXU,
		M_FLUSH,      // 16 - Write back dirty data and cede R/W permissions
		M_PWR,        // partial (masked) store
		M_PRODUCE,    // write back dirty data and cede R/W permissions
		M_CLEAN,      // write back dirty data and retain R/W permissions
		M_SFENCE      // flush TLB
	} cmd_e;
	
	rand bit[NUM_ADDR_BITS-1:0]			addr;
	rand bit[NUM_DATA_BITS-1:0]			data;
	rand bit[(NUM_DATA_BITS/8)-1:0]		data_mask;
	rand bit[NUM_TAG_BITS-1:0]			tag;
	rand cmd_e							cmd;
	rand type_e							typ;
	
	bit									valid;
	
	// TODO: Declare fields here
	
	function new(string name="hella_cache_master_seq_item");
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
		hella_cache_master_seq_item rhs_;
		
		if (!$cast(rhs_, rhs)) begin
			return 0;
		end
		
		ret &= super.do_compare(rhs, comparer);
		
		// TODO: implement comparison logic
	
		return ret;
	endfunction

	function void do_copy(uvm_object rhs);
		hella_cache_master_seq_item rhs_;
		
		if (!$cast(rhs_, rhs)) begin
			`uvm_error(report_id, "Cast failed in do_copy()");
			return;
		end
		
		super.do_copy(rhs);
		
		// TODO: copy item-specific fields
		
	endfunction
			
endclass



