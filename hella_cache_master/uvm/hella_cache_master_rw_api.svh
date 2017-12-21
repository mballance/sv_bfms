/****************************************************************************
 * hella_cache_master_rw_api.svh
 ****************************************************************************/

/**
 * Class: hella_cache_master_rw_api
 * 
 * TODO: Add class documentation
 */
class hella_cache_master_rw_api `hella_cache_master_plist extends sv_bfms_rw_api_if;

	typedef hella_cache_master_agent `hella_cache_master_params agent_t;
	typedef hella_cache_master_access_seq `hella_cache_master_params seq_t;
	typedef hella_cache_master_seq_item `hella_cache_master_params seq_i_t;
	
	agent_t				m_agent;

	function new(agent_t agent);
		m_agent = agent;
	endfunction

	virtual task write8(
		bit[31:0]			addr,
		bit[7:0]			data);
		seq_t seq = seq_t::type_id::create();
		seq.addr = addr;
		seq.data = {data, data, data, data, data, data, data, data};
//		seq.data <<= (8*(addr & 7));
//		seq.data_mask = (1 << (addr & 7));
		seq.cmd = seq_i_t::M_XWR;
		seq.typ = seq_i_t::MT_B;
		
		seq.start(m_agent.m_seqr);
	endtask
	
	virtual task read8(
		bit[31:0]			addr,
		output bit[7:0]		data);
		seq_t seq = seq_t::type_id::create();
		seq.addr = addr;
		seq.cmd = seq_i_t::M_XRD;
		seq.typ = seq_i_t::MT_B;
		
		seq.start(m_agent.m_seqr);
		
		data = seq.data;
	endtask

	virtual task write16(
		bit[31:0]			addr,
		bit[15:0]			data);
		seq_t seq = seq_t::type_id::create();
		seq.addr = addr;
		seq.data = {data, data, data, data};
		seq.cmd = seq_i_t::M_XWR;
		seq.typ = seq_i_t::MT_H;
		
		seq.start(m_agent.m_seqr);
	endtask
	
	virtual task read16(
		bit[31:0]			addr,
		output bit[15:0]	data);
		seq_t seq = seq_t::type_id::create();
		seq.addr = addr;
		seq.cmd = seq_i_t::M_XWR;
		seq.typ = seq_i_t::MT_H;
		
		seq.start(m_agent.m_seqr);
		
		data = seq.data;
	endtask
	
	virtual task write32(
		bit[31:0]			addr,
		bit[31:0]			data);
		seq_t seq = seq_t::type_id::create();
		seq.addr = addr;
		seq.data = {data, data};
//		if (addr & 2) begin
//			seq.data <<= 32;
//		end
//		seq.data_mask = (addr & 2)?'hf0:'h0f;
		seq.cmd = seq_i_t::M_XWR;
		seq.typ = seq_i_t::MT_W;
		
		seq.start(m_agent.m_seqr);
	endtask
	
	virtual task read32(
		bit[31:0]			addr,
		output bit[31:0]	data);
		seq_t seq = seq_t::type_id::create();
		seq.addr = addr;
//		seq.data = data;
//		if (addr & 2) begin
//			seq.data <<= 32;
//		end
//		seq.data_mask = (addr & 2)?'hf0:'h0f;
		seq.cmd = seq_i_t::M_XRD;
		seq.typ = seq_i_t::MT_W;
		
		seq.start(m_agent.m_seqr);
	
		data = seq.data;
	endtask	

endclass


