/****************************************************************************
 * hella_cache_master_access_seq.svh
 ****************************************************************************/

/**
 * Class: hella_cache_master_access_seq
 * 
 * TODO: Add class documentation
 */
class hella_cache_master_access_seq`hella_cache_master_plist extends hella_cache_master_seq_base`hella_cache_master_params;
	typedef hella_cache_master_access_seq `hella_cache_master_params this_t;
	typedef hella_cache_master_seq_item `hella_cache_master_params seq_t;
	typedef hella_cache_master_agent `hella_cache_master_params agent_t;
	`uvm_object_param_utils (this_t)

	rand bit[NUM_ADDR_BITS-1:0]			addr;
	rand bit[NUM_DATA_BITS-1:0]			data;
	rand bit[(NUM_DATA_BITS/8)-1:0]		data_mask;
	rand seq_t::cmd_e					cmd;
	rand seq_t::type_e					typ;

	/**
	 * Task: body
	 *
	 * Override from class 
	 */
	task body();
		seq_t seq_i = seq_t::type_id::create();
		uvm_component p = get_sequencer().get_parent();
		agent_t agent;
		bit is_read;
		
		$cast(agent, p);
		
		seq_i.addr = addr;
		seq_i.data = data;
		seq_i.data_mask = data_mask;
		seq_i.cmd = cmd;
		seq_i.typ = typ;
		
		if (cmd == seq_t::M_XRD) begin
			is_read = 1;
		end else begin
			is_read = 0;
		end
		
		// TODO: select an ID
		agent.m_driver.alloc_tag(is_read, seq_i.tag);

		start_item(seq_i);
		finish_item(seq_i);
		
		// TODO: wait for response
		agent.m_driver.wait_rsp(
				seq_i.tag,
				data);

	endtask

endclass


