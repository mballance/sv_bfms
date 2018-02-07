/****************************************************************************
 * uart_serial_bfm.sv
 ****************************************************************************/

/**
 * Interface: uart_serial_bfm
 * 
 * TODO: Add interface documentation
 */
interface uart_serial_bfm (
		input				clk_i,
		input				rst_i,
		output				stx_pad_o,
		input				srx_pad_i,
		output				rts_pad_o,
		input				cts_pad_i,
		output				dtr_pad_o,
		input				dsr_pad_i,
		input				ri_pad_i,
		input				dcd_pad_i
		);
	//pragma attribute uart_serial_bfm partition_interface_xif
	parameter BFM_ID = "uart_serial_bfm";
	
	uart_serial_bfm_core u_core(
			.clk_i(clk_i),
			.rst_i(rst_i)
		);
	
	assign stx_pad_o = u_core.stx_pad_r;
	assign u_core.srx_pad_i = srx_pad_i;

endinterface

interface uart_serial_bfm_core(input clk_i, input rst_i);
	//pragma attribute uart_serial_bfm_core partition_interface_xif
		
	wire srx_pad_i;
		
	bit clk_16x               = 0;
	bit[15:0] clk_16x_divisor = ((50000000/115200)/16);
	bit[15:0] clk_16x_cnt     = 0;
	bit reset_done = 0;
	bit reset_begin = 0;
	
	bit [1:0] n_stop_bits     = 1;
	bit       parity_en       = 0;
	bit [3:0] n_bits          = 8;
	
	always @(posedge clk_i) begin
		if (rst_i == 1) begin
			clk_16x_cnt <= 0;
			clk_16x <= 0;
			reset_begin <= 1;
		end else begin
			if (reset_begin) begin
				reset_done <= 1;
				reset_begin <= 0;
			end
			if (clk_16x_cnt == clk_16x_divisor) begin
				clk_16x_cnt <= 0;
				clk_16x <= 1;
			end else begin
				clk_16x_cnt <= clk_16x_cnt+1;
				clk_16x <= 0;
			end
		end
	end

	bit[3:0]  rx_clk_cnt      = 0;
	bit[2:0]  rx_state = 0;
	bit[3:0]  rx_bit_cnt = 0;
	bit[7:0]  rx_data;
	bit       rx_done;
	bit[7:0]  rx_bits_received = 0;
	bit       rx_data_sample = 0;
	
	// Rx state machine
	always @(posedge clk_i) begin
		if (rst_i == 1) begin
			rx_clk_cnt <= 0;
			rx_state <= 0;
			rx_bit_cnt <= 0;
			rx_data <= 0;
			rx_bits_received <= 0;
			rx_done <= 0;
		end else begin
			if (clk_16x) begin
				case (rx_state)
					0: begin // Wait for start bit
						if (srx_pad_i == 0) begin
							//							$display("%t: beginning of start bit", $time);
							rx_clk_cnt <= 0;
							rx_state <= 1;
							rx_data <= 0;
						end
					end
					
					1: begin // Wait for start bit to end
						if (rx_clk_cnt == 15) begin
							rx_clk_cnt <= 0;
							rx_bits_received <= 0;
							rx_state <= 2;
							//							$display("%t: end of start bit", $time);
						end else begin
							rx_clk_cnt <= rx_clk_cnt + 1;
						end
					end
					
					2: begin // Wait for data mid-bit
						if (rx_clk_cnt == 7) begin
							//							$display("%t: sample data bit %0d", $time, srx_pad_i);
							// TODO: hard-coded for 8-bit
							rx_data <= {srx_pad_i, rx_data[7:1]};
							rx_bits_received <= rx_bits_received + 1;
							rx_data_sample <= 1;
							rx_state <= 3;
						end
						rx_clk_cnt <= rx_clk_cnt + 1;
					end
					
					3: begin // Wait for end-bit
						rx_data_sample <= 0;
						if (rx_clk_cnt == 15) begin
							rx_clk_cnt <= 0;
							if (rx_bits_received == n_bits) begin
								if (parity_en) begin
									// Receive parity bit
									rx_state <= 4;
								end else begin
									//									$display("Rx Done");
									rx_done <= 1;
									// Back to beginning
									//									if (agent == null) begin
									//										void'(uvm_config_db #(uart_serial_agent)::get(uvm_top,
									//													$psprintf("%m"), uart_serial_config::report_id, agent));
									//									end
									//									if (agent != null) begin
									//										agent.recv(rx_data);
									//									end
									rx_state <= 0;
								end
							end else begin
								rx_state <= 2;
							end
						end else begin
							rx_clk_cnt <= rx_clk_cnt + 1;
						end
					end
					
					4: begin // Wait for parity mid-bit
						// TODO:
					end
					
					5: begin // Wait for parity end-bit
						// TODO:
					end
					
					//					6: begin // Wait for stop mid-bit
					//						if (rx_clk_cnt == 7) begin
					//							if (srx_pad_i !=
					//						end else begin
					//							rx_clk_cnt <= rx_clk_cnt + 1;
					//						end
					//					end
					//					
					//					7: begin // Wait for stop end-bit
					//						if (rx_clk_cnt == 15) begin
					//							// Done!
					//							rx_state <= 0;
					//						end else begin
					//							rx_clk_cnt <= rx_clk_cnt + 1;
					//						end
					//					end
							
				endcase
			end
		end
	end
	
	// Tx state machine
	bit[3:0]  tx_clk_cnt      = 0;
	bit[2:0]  tx_state = 0;
	bit[3:0]  tx_bit_cnt = 0;
	bit[7:0]  tx_data;
	bit[7:0]  tx_bits_transmitted = 0;
	bit       tx_data_sample = 0;
	bit       tx_start = 0;
	bit       tx_done = 0;
	bit       stx_pad_r = 1;
	
	always @(posedge clk_i) begin
		if (rst_i == 1) begin
			tx_start <= 0;
			tx_done <= 0;
			stx_pad_r <= 1;
		end else begin
			if (clk_16x) begin
				case (tx_state)
					0: begin
						if (tx_start) begin
							//							$display("%t: Begin Tx", $time);
							tx_state <= 1;
							stx_pad_r <= 0;
							tx_bit_cnt <= 0;
							tx_start <= 0;
						end
					end
				
					// Wait for end of the start bit
					1: begin
						if (tx_bit_cnt == 15) begin
							tx_state <= 2;
							tx_bits_transmitted <= 0;
						end
						tx_bit_cnt <= tx_bit_cnt + 1;
					end
				
					// Begin tx data bit
					2: begin
						stx_pad_r <= tx_data[0];
						tx_data <= {1'b0, tx_data[7:1]};
// TODO:						tx_data >>= 1;
						tx_state <= 3;
						tx_bit_cnt <= tx_bit_cnt + 1;
						//						$display("%t: Begin Data Bit %0d", $time, tx_bits_transmitted);
					end
				
					// Complete tx data bit
					3: begin
						if (tx_bit_cnt == 15) begin
							if (tx_bits_transmitted == 7) begin
								stx_pad_r <= 1;
								tx_state <= 4;
							end else begin
								tx_state <= 2;
								tx_bits_transmitted <= tx_bits_transmitted + 1;
							end
						end
						tx_bit_cnt <= tx_bit_cnt + 1;
					end
					
					// Complete stop bit
					4: begin
						if (tx_bit_cnt == 15) begin
							//							$display("%t: End stop bit", $time);
							tx_done <= 1;
							tx_state <= 0;
						end
						tx_bit_cnt <= tx_bit_cnt + 1;
					end
					
				endcase
			end
		end
	end		
		
	task uart_serial_bfm_do_tx(input byte unsigned data);
		
		// Ensure we do a reset
		while (reset_done == 0) begin
			@(posedge clk_i);
		end
		
		// Now, do transmit
		tx_data = data;
		tx_start = 1;
		tx_done = 0;
		
		while (tx_done == 0) begin
			@(posedge clk_i);
		end
		
	endtask
	
	task automatic uart_serial_bfm_do_rx(
		output byte unsigned 	data, 
		output byte unsigned 	valid, 
		input int 				timeout=-1);
		int count = 0;
		// Ensure we do a reset
		while (reset_done == 0) begin
			@(posedge clk_i);
		end

		while (rx_done == 0) begin
			@(posedge clk_i);
			if (timeout != -1 && ++count > timeout) begin
				break;
			end
		end
		
		valid = rx_done;
		rx_done = 0;
		
		// Wait for data to be available
		data = rx_data;
	endtask	
	
	task automatic uart_serial_bfm_wait_for_rx(input int byte_time);
		while (reset_done == 0) begin
			@(posedge clk_i);
		end

		repeat (byte_time * 10 * 16) begin // 10 bits per byte ; 16 clocks per bit
			while (clk_16x == 1) @(posedge clk_i);
			
			while (clk_16x == 0) @(posedge clk_i);
		end
	endtask
		
	task uart_serial_bfm_set_clkdiv(bit[15:0] div);
		clk_16x_divisor = div;
	endtask
		
endinterface
