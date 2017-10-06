/****************************************************************************
 * axi4_master_bfm.sv
 ****************************************************************************/

/**
 * Module: axi4_master_bfm
 * 
 * TODO: Add module documentation
 */
module axi4_master_bfm #(
			parameter int AXI4_ADDRESS_WIDTH=32,
			parameter int AXI4_DATA_WIDTH=128,
			parameter int AXI4_ID_WIDTH=4,
			parameter int AXI4_MAX_BURST_LENGTH=16
		) (
			input			clk,
			input			rstn,
			axi4_if.master	master
		);
	reg									reset = 0;
	
	bit[AXI4_DATA_WIDTH-1:0]			wdata_buf[AXI4_MAX_BURST_LENGTH];
	reg									aw_req = 0;
	reg[(AXI4_ADDRESS_WIDTH-1):0]		AWADDR_r;
	reg[(AXI4_ADDRESS_WIDTH-1):0]		AWADDR_rs;
	reg[(AXI4_ID_WIDTH-1):0]			AWID_r;
	reg[(AXI4_ID_WIDTH-1):0]			AWID_rs;
	reg[7:0]							AWLEN_r;
	reg[7:0]							AWLEN_rs;
	reg[2:0]							AWSIZE_r;
	reg[2:0]							AWSIZE_rs;
	reg[1:0]							AWBURST_r;
	reg[1:0]							AWBURST_rs;
	reg[3:0]							AWCACHE_r;
	reg[3:0]							AWCACHE_rs;
	reg[2:0]							AWPROT_r;
	reg[2:0]							AWPROT_rs;
	reg[3:0]							AWQOS_r;
	reg[3:0]							AWQOS_rs;
	reg[3:0]							AWREGION_r;
	reg[3:0]							AWREGION_rs;
	reg									AWVALID_r;

	bit[AXI4_DATA_WIDTH-1:0]			rdata_buf[AXI4_MAX_BURST_LENGTH];
	reg									ar_req = 0;
	reg									ac_ack = 0;
	reg[(AXI4_ADDRESS_WIDTH-1):0]		ARADDR_r;
	reg[(AXI4_ADDRESS_WIDTH-1):0]		ARADDR_rs;
	reg[(AXI4_ID_WIDTH-1):0]			ARID_r;
	reg[(AXI4_ID_WIDTH-1):0]			ARID_rs;
	reg[7:0]							ARLEN_r;
	reg[7:0]							ARLEN_rs;
	reg[2:0]							ARSIZE_r;
	reg[2:0]							ARSIZE_rs;
	reg[1:0]							ARBURST_r;
	reg[1:0]							ARBURST_rs;
	reg[3:0]							ARCACHE_r;
	reg[3:0]							ARCACHE_rs;
	reg[2:0]							ARPROT_r;
	reg[2:0]							ARPROT_rs;
	reg[3:0]							ARREGION_r;
	reg[3:0]							ARREGION_rs;
	reg									ARVALID_r;
	
	assign master.AWVALID = AWVALID_r;
	assign master.AWADDR = AWADDR_rs;
	assign master.AWID = AWID_rs;
	assign master.AWLEN = AWLEN_rs;
	assign master.AWSIZE = AWSIZE_rs;
	assign master.AWBURST = AWBURST_rs;
	assign master.AWCACHE = AWCACHE_rs;
	assign master.AWPROT = AWPROT_rs;
	assign master.AWQOS = AWQOS_rs;
	assign master.AWREGION = AWREGION_rs;

	assign master.ARVALID = ARVALID_r;
	assign master.ARADDR = ARADDR_rs;
	assign master.ARID = ARID_rs;
	assign master.ARLEN = ARLEN_rs;
	assign master.ARSIZE = ARSIZE_rs;
	assign master.ARBURST = ARBURST_rs;
	assign master.ARCACHE = ARCACHE_rs;
	assign master.ARPROT = ARPROT_rs;
	assign master.ARREGION = ARREGION_rs;
	
	
	
	task axi4_master_bfm_get_parameters(
			output int unsigned ADDRESS_WIDTH,
			output int unsigned DATA_WIDTH,
			output int unsigned ID_WIDTH);
			ADDRESS_WIDTH = AXI4_ADDRESS_WIDTH;
			DATA_WIDTH = AXI4_DATA_WIDTH;
			ID_WIDTH = AXI4_ID_WIDTH;
	endtask
	export "DPI-C" task axi4_master_bfm_get_parameters;

`ifdef BFM_NONBLOCK
	import "DPI-C" context task axi4_master_bfm_rresp(
		int unsigned					RRESP);
	import "DPI-C" context task axi4_master_bfm_clk_ack();
	import "DPI-C" context task axi4_master_bfm_register();
	import "DPI-C" context task axi4_master_bfm_bresp(
			int unsigned resp);
	import "DPI-C" context task axi4_master_bfm_reset();
`endif
	
	task axi4_master_bfm_has_been_reset(
		output int unsigned was_reset);
		was_reset = reset;
	endtask
	export "DPI-C" task axi4_master_bfm_has_been_reset;
	

`ifdef BFM_NONBLOCK
	initial begin
		axi4_master_bfm_register();
	end
`endif

	// AW state machine
	reg[2:0]				aw_state;
	reg[7:0]				write_count;
	reg[7:0]				write_len;
	always @(posedge clk) begin
		if (rstn != 1) begin
			aw_state <= 0;
			reset <= 1;
			write_count <= 0;
			write_len <= 0;
		end else begin
			if (reset == 1) begin
				axi4_master_bfm_reset();
				reset <= 0;
			end
				
			case (aw_state)
				0: begin
					if (aw_req) begin
						AWADDR_rs <= AWADDR_r;
						AWID_rs <= AWID_r;
						AWBURST_rs <= AWBURST_r;
						AWCACHE_rs <= AWCACHE_r;
						AWLEN_rs <= AWLEN_r;
						AWPROT_rs <= AWPROT_r;
						AWQOS_rs <= AWQOS_r;
						AWREGION_rs <= AWREGION_r;
						AWSIZE_rs <= AWSIZE_r;
						write_count <= 0;
						write_len <= AWLEN_r;

						AWVALID_r <= 1;
						aw_state <= 1;
						aw_req = 0;
					end
				end
				
				1: begin
					if (master.AWVALID && master.AWREADY) begin
						AWVALID_r <= 0;
						aw_state <= 2;
					end
				end
			
				// 
				2: begin
					if (master.WREADY && master.WVALID) begin
						if (write_count == write_len) begin
							aw_state <= 3;
						end else begin
							write_count <= write_count + 1;
						end
					end
				end
				
				3: begin
					if (master.BREADY && master.BVALID) begin
						aw_state <= 0;
						axi4_master_bfm_bresp(master.BRESP);
					end
				end
			endcase
		end
	end
	
	assign master.WDATA = (aw_state == 2)?wdata_buf[write_count]:0;
	assign master.WVALID = (aw_state == 2);
	assign master.WLAST = (aw_state == 2 && write_count == write_len);
	assign master.BREADY = (aw_state == 3);
	assign master.WSTRB  = 'hf;
	
	task axi4_master_bfm_aw_valid(
		longint unsigned				AWADDR,
		int unsigned					AWID,
		byte unsigned					AWLEN,
		byte unsigned					AWSIZE,
		byte unsigned					AWBURST,
		byte unsigned					AWCACHE,
		byte unsigned					AWPROT,
		byte unsigned					AWQOS,
		byte unsigned					AWREGION);
		aw_req = 1;
		AWADDR_r = AWADDR;
		AWID_r = AWID;
		AWLEN_r = AWLEN;
		AWSIZE_r = AWSIZE;
		AWBURST_r = AWBURST;
		AWCACHE_r = AWCACHE;
		AWPROT_r = AWPROT;
		AWQOS_r = AWQOS;
		AWREGION_r = AWREGION;
	endtask
	export "DPI-C" task axi4_master_bfm_aw_valid;
	
	task axi4_master_bfm_set_data(
		int unsigned					idx,
		int unsigned					data);
		wdata_buf[idx] = data;
	endtask
	export "DPI-C" task axi4_master_bfm_set_data;

	// AR state machine
	reg[2:0]				ar_state;
	reg[7:0]				read_count = 0;
	always @(posedge clk) begin
		if (rstn != 1) begin
			ar_state <= 0;
			read_count <= 0;
		end else begin
			case (ar_state)
				0: begin
					if (ar_req) begin
						ARADDR_rs <= ARADDR_r;
						ARID_rs <= ARID_r;
						ARBURST_rs <= ARBURST_r;
						ARCACHE_rs <= ARCACHE_r;
						ARLEN_rs <= ARLEN_r;
						ARPROT_rs <= ARPROT_r;
						ARREGION_rs <= ARREGION_r;
						ARSIZE_rs <= ARSIZE_r;

						ARVALID_r <= 1;
						ar_state <= 1;
						ar_req = 0;
					end
				end
				
				1: begin
					if (master.ARVALID && master.ARREADY) begin
						ARVALID_r <= 0;
						ar_state <= 2;
					end
				end
			
				// Receive data
				2: begin
					if (master.RREADY && master.RVALID) begin
						rdata_buf[read_count] = master.RDATA;
						if (master.RLAST) begin
							read_count <= 0;
							ar_state <= 0;
`ifdef BFM_NONBLOCK							
							axi4_master_bfm_rresp(master.RRESP);
`else
							ar_ack = 1;
`endif
						end else begin
							read_count <= read_count + 1;
						end
					end
				end
			endcase
		end
	end
	
	assign master.RREADY = (ar_state == 2);
	
	task axi4_master_bfm_ar_valid(
		longint unsigned				ARADDR,
		int unsigned					ARID,
		byte unsigned					ARLEN,
		byte unsigned					ARSIZE,
		byte unsigned					ARBURST,
		byte unsigned					ARCACHE,
		byte unsigned					ARPROT,
		byte unsigned					ARREGION);
		ar_req = 1;
		ARADDR_r = ARADDR;
		ARID_r = ARID;
		ARLEN_r = ARLEN;
		ARSIZE_r = ARSIZE;
		ARBURST_r = ARBURST;
		ARCACHE_r = ARCACHE;
		ARPROT_r = ARPROT;
		ARREGION_r = ARREGION;
`ifndef BFM_NONBLOCK
		ar_ack = 0; // TODO: should check?
		do begin
			@(posedge clk);
		end while (ar_ack == 0);
		ar_ack = 0;
`endif
	endtask
	export "DPI-C" task axi4_master_bfm_ar_valid;

	
	task axi4_master_bfm_get_data(
		int unsigned					idx,
		output int unsigned				data);
		data = rdata_buf[idx];
	endtask
	export "DPI-C" task axi4_master_bfm_get_data;

	reg clk_req = 0;
	reg clk_req_state = 0;
	
	task axi4_master_bfm_clk_req();
		clk_req = 1;
	endtask
	export "DPI-C" task axi4_master_bfm_clk_req;

	
	always @(posedge clk) begin
		case (clk_req_state)
			0: begin
				if (clk_req) begin
					clk_req = 0;
					clk_req_state <= 1;
				end
			end
			1: begin
				axi4_master_bfm_clk_ack();
				clk_req_state <= 0;
			end
		endcase
	end
	

endmodule

