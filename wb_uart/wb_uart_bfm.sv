/****************************************************************************
 * wb_uart_bfm.sv
 ****************************************************************************/
 
`ifndef WB_UART_BFM_NAME
`define WB_UART_BFM_NAME wb_uart_bfm
`endif

/**
 * Module: wb_uart_bfm
 * 
 * TODO: Add module documentation
 */
interface `WB_UART_BFM_NAME (
		input			clk,
		input			rstn,
		wb_if.slave		s,
		output			int_o,
		output			stx_pad_o,
		input			srx_pad_i,
		output			rts_pad_o,
		input			cts_pad_i,
		output			dtr_pad_o,
		input			dsr_pad_i,
		input			ri_pad_i,
		input			dcd_pad_i		
		);
	import uvm_pkg::*;
	import wb_uart_agent_pkg::*;
	
	wb_uart_agent		agent;
	
	reg[2:0]		addr;
	reg[7:0]		data;
	reg req, req_1;
	
	always @(posedge clk) begin
		if (rstn == 0) begin
			req <= 0;
			req_1 <= 0;
			addr <= 0;
			data <= 0;
		end else begin
			if (s.CYC) begin
				req <= 1;
				addr <= s.ADR[3:2];
				data <= s.DAT_W[7:0];
			end else begin
				req <= 0;
			end
			req_1 <= req;
		end
		
		if (req && s.WE) begin
			if (s.ADR[3:2] == 0) begin
				if (agent == null) begin
					void'(uvm_config_db #(wb_uart_agent)::get(uvm_top, $psprintf("%m"),
							wb_uart_config::report_id, agent));
				end
				
				if (agent != null) begin
					agent.recv(s.DAT_W[7:0]);
				end else begin
					$display("char: %c", s.DAT_W[7:0]);
				end
			end
		end
	end
	
	assign s.ERR = 0;
	assign s.DAT_R = 0;
	assign s.ACK = req;

endinterface


