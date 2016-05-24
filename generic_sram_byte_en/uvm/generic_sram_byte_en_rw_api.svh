/****************************************************************************
 * generic_sram_byte_en_rw_api.svh
 ****************************************************************************/

/**
 * Class: generic_sram_byte_en_rw_api
 * 
 * TODO: Add class documentation
 */
typedef class generic_sram_byte_en_agent;
class generic_sram_byte_en_rw_api extends sv_bfms_rw_api_if;
	generic_sram_byte_en_agent			m_agent;

	function new(generic_sram_byte_en_agent agent);
		m_agent = agent;
	endfunction

	virtual task write8(
			bit[31:0]			addr,
			bit[7:0]			data);
		m_agent.write8(addr, data);
	endtask
	
	virtual task read8(
			bit[31:0]			addr,
			output bit[7:0]		data);
		m_agent.read8(addr, data);
	endtask
	
	virtual task write32(
			bit[31:0]			addr,
			bit[31:0]			data);
		m_agent.write32(addr, data);
	endtask
	
	virtual task read32(
			bit[31:0]			addr,
			output bit[31:0]	data);
		m_agent.read32(addr, data);
	endtask

endclass


