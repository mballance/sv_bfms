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
	int							m_stream;

	virtual task init(uvmdev_mgr mgr, int unsigned id);
		uvm_object		dev_data;
		
		m_stream = $create_transaction_stream($sformatf("uart_agent_dev(%0d)", id));
		
		dev_data = mgr.get_dev_data(id);
		m_mem_if = mgr.get_mem_if();
		
		if (!$cast(m_agent, dev_data)) begin
			`uvm_fatal(get_name(), "Failed to cast dev_data to uart_serial_agent");
		end
	endtask
	
	task tx(int unsigned seed, int unsigned bytes);
		uart_serial_tx_seq	tx_seq = uart_serial_tx_seq::type_id::create();
		int th = $begin_transaction(m_stream, "tx");
		$add_attribute(th, seed, "seed");
		$add_attribute(th, bytes, "bytes");

		tx_seq.data.push_back(0);
		
		for (int i=0; i<bytes; i++) begin
			int th_b = $begin_transaction(m_stream, $sformatf("byte %0d", i),, th);
			seed ^= (seed << 13);
			seed ^= (seed >> 17);
			seed ^= (seed << 5);
			
			$add_attribute(th_b, seed, "data");
			tx_seq.data[0] = seed;
			tx_seq.start(m_agent.m_seqr);
			$end_transaction(th_b);
			$free_transaction(th_b);
		end
		$end_transaction(th);
		$free_transaction(th);
	endtask
	
	task rx(int unsigned seed, int unsigned bytes);
		byte unsigned data;
		bit valid;
		int th = $begin_transaction(m_stream, "rx");
		$add_attribute(th, seed, "seed");
		$add_attribute(th, bytes, "bytes");
	
		$display("--> agent.rx bytes=%0d", bytes);
		for (int i=0; i<bytes; i++) begin
			int th_b = $begin_transaction(m_stream, $sformatf("byte %0d", i),, th);
			seed ^= (seed << 13);
			seed ^= (seed >> 17);
			seed ^= (seed << 5);
			m_agent.getc(data, valid);
			$add_attribute(th_b, data, "data");
			
			if (data != (seed & 'hff)) begin
				`uvm_error(get_name(), $sformatf("Data receive failed ; expected 'h%02h ; received 'h%02h",
						(seed & 'hff), data));
			end
			$end_transaction(th_b);
			$free_transaction(th_b);
		end
		$end_transaction(th);
		$free_transaction(th);
		$display("<-- agent.rx bytes=%0d", bytes);
	endtask

endclass

task automatic generate_data(
	int unsigned		seed,
	int unsigned		addr,
	int unsigned		sz);
	uvmdev_mem_if mem_if = uvmdev_mgr::inst().get_mem_if();
	
	for (int i=0; i<sz; i++) begin
		byte unsigned data;
		
		seed ^= (seed << 13);
		seed ^= (seed >> 17);
		seed ^= (seed << 5);
		
		data = seed;
		$display("write: 'h%08h='h%02h", addr+i, data);
		mem_if.write8(data, addr+i);
	end
endtask

task automatic check_data(
	int unsigned		seed,
	int unsigned		addr,
	int unsigned		sz);
	uvmdev_mem_if mem_if = uvmdev_mgr::inst().get_mem_if();
	
	$display("--> check_data seed='h%08h addr='h%08h sz=%0d", seed, addr, sz);
	
	for (int i=0; i<sz; i++) begin
		byte unsigned exp_data, data;
		
		seed ^= (seed << 13);
		seed ^= (seed >> 17);
		seed ^= (seed << 5);
		
		exp_data = seed;
		mem_if.read8(data, addr+i);
		
		if (data != exp_data) begin
			`uvm_error("checkdata", $sformatf("'h%08h: expect 'h%02h ; receive 'h%02h",
					addr+i, exp_data, data));
		end
	end
	
	$display("<-- check_data seed='h%08h addr='h%08h sz=%0d", seed, addr, sz);
endtask

/**
 * uart_agent_dev_tx(seed, sz)
 */
`uvmdev_task_decl_2(uart_agent_dev, tx, uint32_t, uint32_t)

/**
 * uart_agent_dev_rx(seed, sz)
 */
`uvmdev_task_decl_2(uart_agent_dev, rx, uint32_t, uint32_t)

