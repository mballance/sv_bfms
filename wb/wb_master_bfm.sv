/****************************************************************************
 * wb_master_bfm.sv
 ****************************************************************************/
 
interface wb_master_bfm_core #(
		parameter int WB_ADDR_WIDTH=32, 
		parameter int WB_DATA_WIDTH=32
		) (
		input						clk,
		input						rstn
		);
	
	reg							reset = 0;
	reg							reset_done = 0;
	
	reg[WB_DATA_WIDTH-1:0]		write_data_buf;
	reg[WB_DATA_WIDTH-1:0]		read_data_buf;
	reg							req = 0;
	reg							ack = 0;
	
	reg[WB_ADDR_WIDTH-1:0]		ADR_r;
	reg[WB_ADDR_WIDTH-1:0]		ADR_rs;
	reg[2:0]					CTI_r;
	reg[2:0]					CTI_rs;
	reg[1:0]					BTE_r;
	reg[1:0]					BTE_rs;
	reg[WB_DATA_WIDTH-1:0]		DAT_W_rs;
	reg							CYC_rs;
	reg[(WB_DATA_WIDTH/8)-1:0]	SEL_r;
	reg[(WB_DATA_WIDTH/8)-1:0]	SEL_rs;
	reg							STB_rs;
	reg							WE_r;
	reg							WE_rs;
	wire[WB_DATA_WIDTH-1:0]		DAT_R;


	
	reg[1:0] state;

	`ifdef BFM_NONBLOCK
		initial begin
			wb_master_bfm_register();
		end
	`endif	

	// BFM State machine
	always @(posedge clk) begin
		if (rstn == 0) begin
			state <= 0;
			req = 0;
			reset <= 1;
			ADR_rs <= 0;
			CTI_rs <= 0;
			BTE_rs <= 0;
			DAT_W_rs <= 0;
			CYC_rs <= 0;
			SEL_rs <= 0;
			STB_rs <= 0;
			WE_rs  <= 0;
		end else begin
			if (reset == 1) begin
`ifdef BFM_NONBLOCK
				wb_master_bfm_reset();
`endif
				reset_done <= 1;
				reset <= 0;
			end
			case (state)
				0: begin
					if (req) begin
						STB_rs <= 1;
						CYC_rs <= 1;
						ADR_rs <= ADR_r;
						CTI_rs <= CTI_r;
						BTE_rs <= BTE_r;
						WE_rs <= WE_r;
						if (WE_r) begin
							DAT_W_rs <= write_data_buf;
						end else begin
							DAT_W_rs <= 0;
						end
						SEL_rs <= SEL_r;
						state <= 1;
						req = 0;
					end
				end
				
				1: begin
					if (master.ACK) begin
						`ifdef BFM_NONBLOCK						
							wb_master_bfm_acknowledge(master.ERR);
						`else
							ack = 1;
						`endif
						if (!WE_r) begin
							read_data_buf = DAT_R;
						end
						
						STB_rs <= 0;
						CYC_rs <= 0;
						ADR_rs <= 0;
						CTI_rs <= 0;
						BTE_rs <= 0;
						SEL_rs <= 0;

						state <= 0;
					end
				end
			endcase
		end
	end
		
	task wb_master_bfm_get_parameters(
		output int unsigned			ADDRESS_WIDTH,
		output int unsigned			DATA_WIDTH);
		ADDRESS_WIDTH = WB_ADDR_WIDTH;
		DATA_WIDTH = WB_DATA_WIDTH;
	endtask
	`ifndef BFM_NONBLOCK
		export "DPI-C" task wb_master_bfm_get_parameters;
	`endif	
	
	task wb_master_bfm_set_data(
		int unsigned				idx,
		int unsigned				data);
		write_data_buf = data;
	endtask
	`ifndef BFM_NONBLOCK
		export "DPI-C" task wb_master_bfm_set_data;
	`endif
	
	task wb_master_bfm_get_data(
		input int unsigned				idx,
		output int unsigned				data);
		data = read_data_buf;
	endtask
	`ifndef BFM_NONBLOCK
		export "DPI-C" task wb_master_bfm_get_data;
	`endif	
	
	task wb_master_bfm_request(
		longint unsigned 			ADR,
		byte unsigned				CTI,
		byte unsigned				BTE,
		int unsigned				SEL,
		byte unsigned				WE);
`ifndef BFM_NONBLOCK
			// Wait for reset
			while (reset_done == 0) begin
				@(posedge clk);
			end
`endif
		ADR_r = ADR;
		CTI_r = CTI;
		BTE_r = BTE;
		SEL_r = SEL;
		WE_r = WE;
		req = 1;
		// non-SC BFM version blocks waiting for completion
`ifndef BFM_NONBLOCK
			ack = 0; // TODO: should check?
			do begin
				@(posedge clk);
			end while (ack == 0);
			ack = 0;
`endif
	endtask
	`ifdef BFM_NONBLOCK
		export "DPI-C" task wb_master_bfm_request;
	`endif	

	`ifdef BFM_NONBLOCK
		import "DPI-C" context task wb_master_bfm_acknowledge(
				byte unsigned			ERR
			);
	
		import "DPI-C" context task wb_master_bfm_reset();
	

		import "DPI-C" context task wb_master_bfm_register();
	`else
	
	`endif
endinterface

/**
 * Module: wb_master_bfm
 * 
 * TODO: Add module documentation
 */
interface wb_master_bfm #(
		parameter int			WB_ADDR_WIDTH = 32,
		parameter int			WB_DATA_WIDTH = 32
		) (
		input					clk,
		input					rstn,
		wb_if.master			master
		);

	wb_master_bfm_core #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) u_core (
			.clk(clk),
			.rstn(rstn));
	
	
	assign master.ADR = u_core.ADR_rs;
//	assign master.ADR = 'h28; // u_core.ADR_rs;
	assign master.CTI = u_core.CTI_rs;
	assign master.BTE = u_core.BTE_rs;
	assign master.DAT_W = u_core.DAT_W_rs;
	assign u_core.DAT_R = master.DAT_R;
	assign master.CYC = u_core.CYC_rs;
	assign master.SEL = u_core.SEL_rs;
	assign master.STB = u_core.STB_rs;
	assign master.WE  = u_core.WE_rs;	
	

endinterface

