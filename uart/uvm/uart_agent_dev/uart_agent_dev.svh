/****************************************************************************
 * uart_agent_dev.svh
 ****************************************************************************/

/**
 * Class: uart_agent_dev
 * 
 * TODO: Add class documentation
 */
class uart_agent_dev extends uvm_object implements uvmdev_if;
	`uvm_object_utils(uart_agent_dev)
	
	uart_serial_agent			m_agent;
	uvmdev_mem_if				m_mem_if;

	virtual task init(uvmdev_mgr mgr, int unsigned id);
		uvm_object		dev_data;
		
		dev_data = mgr.get_dev_data(id);
		m_mem_if = mgr.get_mem_if();
		
		if (!$cast(m_agent, dev_data)) begin
			`uvm_fatal(get_name(), "Failed to cast dev_data to uart_serial_agent");
		end
	endtask
	
	task tx_rand_data(int unsigned seed, int unsigned bytes);
		uart_serial_tx_seq	tx_seq = uart_serial_tx_seq::type_id::create();

		tx_seq.data.push_back(0);
		
		for (int i=0; i<bytes; i++) begin
			seed ^= (seed << 13);
			seed ^= (seed >> 17);
			seed ^= (seed << 5);
			
			tx_seq.data[0] = seed;
			tx_seq.start(m_agent.m_seqr);
		end
	endtask

endclass


