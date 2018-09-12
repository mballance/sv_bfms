/****************************************************************************
 * uart_agent_dev.svh
 ****************************************************************************/

/**
 * Class: uart_agent_dev
 * 
 * TODO: Add class documentation
 */
class uart_agent_dev extends uvm_object implements uvmdev_if, vmon_client_ep_if;
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
	
	task tx(int unsigned seed, int unsigned bytes, int stride=1);
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
	
	task rx(int unsigned seed, int unsigned bytes, int stride=1);
		byte unsigned data;
		bit valid;
	
		$display("--> agent.rx bytes=%0d", bytes);
		for (int i=0; i<bytes; i+=stride) begin
			seed ^= (seed << 13);
			seed ^= (seed >> 17);
			seed ^= (seed << 5);
			for (int j=1; j<stride; j++) begin
				// Skip bytes that we won't see
				seed ^= (seed << 13);
				seed ^= (seed >> 17);
				seed ^= (seed << 5);
			end
			m_agent.getc(data, valid);
			
			if (data != (seed & 'hff)) begin
				`uvm_error(get_name(), $sformatf("Data receive failed ; expected 'h%02h ; received 'h%02h",
						(seed & 'hff), data));
			end
		end
		$display("<-- agent.rx bytes=%0d", bytes);
	endtask

	// VMON message processing function
	virtual function void process_msg(byte unsigned ep, vmon_databuf data);
		int i=4; // First part of the message is the device id
		byte unsigned op = data.get8();
		int unsigned seed = data.get32();
		int unsigned sz = data.get32();
		
		if (op == 0) begin
			fork
				rx(seed, sz);
			join_none
		end else if (op == 1) begin
			fork
				tx(seed, sz);
			join_none
		end else begin
			$display("uart_agent_dev: unknown operation %0d", op);
		end
	endfunction

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
`uvmdev_task_decl_3(uart_agent_dev, tx, uint32_t, uint32_t, uint32_t)

/**
 * uart_agent_dev_rx(seed, sz)
 */
`uvmdev_task_decl_3(uart_agent_dev, rx, uint32_t, uint32_t, uint32_t)

