

class hella_cache_master_driver `hella_cache_master_plist 
		extends uvm_driver #(hella_cache_master_seq_item `hella_cache_master_params)
		implements hella_cache_master_api;
	
	typedef hella_cache_master_driver `hella_cache_master_params this_t;
	typedef hella_cache_master_config `hella_cache_master_params cfg_t;
	typedef hella_cache_master_seq_item `hella_cache_master_params seq_i_t;
	
	`uvm_component_param_utils (this_t);

	const string report_id = "hella_cache_master_driver";
	
	uvm_analysis_port #(seq_i_t)					ap;
	
	cfg_t											m_cfg;

	localparam MAX_TAG = 24;
	bit										m_tag_active[MAX_TAG+1];
	seq_i_t									m_req_rsp_data[MAX_TAG+1];
	int unsigned							m_last_tag;
	semaphore								m_tag_sem[MAX_TAG+1];
	event									m_complete_ev;
	mailbox #(seq_i_t)						m_nack_q = new();
	semaphore								m_req_sem = new(1);
	int unsigned							m_replay = 0;
	
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
		
		foreach (m_req_rsp_data[i]) begin
			m_req_rsp_data[i] = seq_i_t::type_id::create();
		end
		
		foreach (m_tag_sem[i]) begin
			m_tag_sem[i] = new(0);
		end
		
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		ap = new("ap", this);
		
		m_cfg = cfg_t::get_config(this);
	
		// Provide the callback path
		m_cfg.vif.api = this;
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction
	
	task alloc_tag(bit is_read, output int unsigned tag);
		int tag_t = -1;
		
//		$display("--> alloc_tag");
		
		while (tag_t == -1) begin
			// See if there is an available tag
			if (is_read) begin
				for (int i=MAX_TAG; i>=0; i--) begin
					if (m_tag_active[i] == 0) begin
						tag_t = i;
						m_tag_active[i] = 1;
						break;
					end
				end
			end else begin
				for (int i=0; i<=MAX_TAG; i++) begin
					if (m_tag_active[i] == 0) begin
						tag_t = i;
						m_tag_active[i] = 1;
						break;
					end
				end
			end
			
			if (tag_t == -1) begin
				@(m_complete_ev);
			end
		end
		
		tag = tag_t;
//		$display("<-- alloc_tag %0d", tag);
	endtask
	
//	task rsp_thread();
//		// For now, run the response thread here
//		int unsigned nack, tag, typ;
//		longint unsigned data;
//		
//		forever begin
//			m_cfg.vif.hella_cache_master_bfm_recv_rsp(
//					nack, tag, typ, data);
//		
////			$display("-- Recv tag=%0d nack=%0d", tag, nack);
//			
//			if (nack) begin
//				if (m_req_rsp_data[tag].valid) begin
//					m_nack_q.put(m_req_rsp_data[tag]);
//					m_replay++;
//				end else begin
//					int real_id = -1;
//					$display("Warning: NACK of a completed access");
//					for (int i=0; i<MAX_TAG+1; i++) begin
//						if (m_req_rsp_data[i].valid) begin
//							real_id = i;
//							break;
//						end
//					end
//					
//					if (real_id != -1) begin
//						$display("Note: Retrying with ID %0d", real_id);
//						m_nack_q.put(m_req_rsp_data[real_id]);
//					end else begin
//						$display("FATAL: Failed to find ID");
//					end
////					m_cfg.vif.hella_cache_master_bfm_clear_kill();
//				end
//			end else begin
//				int real_tag = tag;
//				
//				if (!m_req_rsp_data[real_tag].valid) begin
//					$display("Error: ACK of a completed access %0d", tag); 
//				end
//				m_req_rsp_data[tag].data = data;
//				m_req_rsp_data[tag].valid = 0;
////				$display("%0t %0s: Access Done: addr='h%08h tag=%0d data='h%08h",
////						$time, get_full_name(), m_req_rsp_data[tag].addr, tag, data);
//				->m_complete_ev;
//				m_tag_sem[tag].put(1);
//				
////				if (m_replay > 0) begin
////					m_replay--;
////					if (!m_replay) begin
////						m_cfg.vif.hella_cache_master_bfm_clear_kill();
////					end
////				end
//			end
//		end
//	endtask
	
//	task nack_thread();
//		seq_i_t item;
//		`hella_cache_master_vif_t vif = m_cfg.vif;
//		forever begin
//			m_nack_q.get(item);
//		
////			$display("%0t %0s: Received NACK item - addr='h%08h tag=%0d data='h%08h",
////					$time, get_full_name(), item.addr, item.tag, item.data);
//			m_req_sem.get(1);
//			vif.hella_cache_master_bfm_send_req(
//					item.addr, item.tag, item.cmd,
//					item.typ, item.data, item.data_mask);
//			m_req_sem.put(1);
//		end
//	endtask
	
	task wait_rsp(
		input int unsigned			tag,
		output longint unsigned		data);
		// Wait for complete
//		$display("--> m_tag_sem[%0d].get", tag);
		m_tag_sem[tag].get(1);
		m_tag_active[tag] = 0;
		data = m_req_rsp_data[tag].data;
//		$display("<-- m_tag_sem[%0d].get", tag);
		
		// TODO: pass back values
	endtask	
	
	task run_phase(uvm_phase phase);
		seq_i_t		item;
		`hella_cache_master_vif_t vif = m_cfg.vif;
		
//		fork
//			rsp_thread();
//			nack_thread();
//		join_none
		
		forever begin
			seq_item_port.get_next_item(item);
			// TODO: execute the sequence item
//			item.print();
			
			m_req_rsp_data[item.tag].addr      = item.addr;
			m_req_rsp_data[item.tag].data      = item.data;
			m_req_rsp_data[item.tag].data_mask = item.data_mask;
			m_req_rsp_data[item.tag].tag       = item.tag;
			m_req_rsp_data[item.tag].cmd       = item.cmd;
			m_req_rsp_data[item.tag].typ       = item.typ;
			if (item.cmd == seq_i_t::M_XWR) begin
				m_req_rsp_data[item.tag].valid     = 0;
				m_tag_sem[item.tag].put(1); // Writes are posted
			end else begin
				m_req_rsp_data[item.tag].valid     = 1;
			end
			
			// Send the item to the analysis port
			ap.write(item);

			m_req_sem.get(1);
			vif.hella_cache_master_bfm_send_req(
					item.addr, item.tag, item.cmd,
					item.typ, item.data, item.data_mask);
			m_req_sem.put(1);
			
			seq_item_port.item_done();
		end
	endtask
	
	virtual function void bfm_rsp(
			int unsigned		tag,
			int unsigned		typ,
			longint unsigned	data);
		if (m_req_rsp_data[tag].valid) begin
			m_req_rsp_data[tag].data = data;
			m_req_rsp_data[tag].valid = 0;
			->m_complete_ev;
			m_tag_sem[tag].put(1);		
		end
	endfunction
	
endclass



