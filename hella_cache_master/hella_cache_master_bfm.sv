/****************************************************************************
 * hella_cache_master_bfm.sv
 ****************************************************************************/

/**
 * Interface: hella_cache_master_bfm
 * 
 * TODO: Add interface documentation
 */
interface hella_cache_master_bfm #(
		parameter int		NUM_ADDR_BITS=32,
		parameter int		NUM_DATA_BITS=32,
		parameter int		NUM_TAG_BITS=7
		)(
		input							clock,
		input							reset,
		output [NUM_ADDR_BITS-1:0]		req_addr,
		input							req_ready,
		output							req_valid,
		output [NUM_TAG_BITS-1:0]		req_tag,
		output [4:0]					req_cmd,
		output [2:0]					req_typ,
		output [NUM_DATA_BITS-1:0]		req_data,
		output [(NUM_DATA_BITS/8)-1:0]	req_data_mask,
		output							req_kill,
		input							rsp_valid,
		input							rsp_nack,
		input  [NUM_TAG_BITS-1:0]		rsp_tag,
		input  [2:0]					rsp_typ,
		input  [NUM_DATA_BITS-1:0]		rsp_data
		);

	hella_cache_master_bfm_core #(
		.NUM_ADDR_BITS  (NUM_ADDR_BITS ), 
		.NUM_DATA_BITS  (NUM_DATA_BITS ), 
		.NUM_TAG_BITS   (NUM_TAG_BITS  )
		) u_core (
		.clock          (clock         ), 
		.reset          (reset         )
		);

	assign req_addr = u_core.req_addr;
	assign u_core.req_ready = req_ready;
	assign req_valid = u_core.req_valid;
	assign req_tag = u_core.req_tag;
	assign req_cmd = u_core.req_cmd;
	assign req_typ = u_core.req_typ;
	assign req_data = u_core.req_data;
	assign req_data_mask = u_core.req_data_mask;
	assign req_kill = (rsp_nack | u_core.req_kill);
	assign u_core.rsp_valid = rsp_valid;
	assign u_core.rsp_nack = rsp_nack;
	assign u_core.rsp_tag = rsp_tag;
	assign u_core.rsp_typ = rsp_typ;
	assign u_core.rsp_data = rsp_data;

endinterface

interface hella_cache_master_bfm_core #(
		parameter int		NUM_ADDR_BITS=32,
		parameter int		NUM_DATA_BITS=32,
		parameter int		NUM_TAG_BITS=7
		)(
		input			clock,
		input			reset
		);
	
	reg [NUM_ADDR_BITS-1:0]		req_addr = 0;
	wire						req_ready;
	reg							req_valid = 0;
	reg [NUM_TAG_BITS-1:0]		req_tag = 0;
	reg [4:0]					req_cmd = 0;
	reg [2:0]					req_typ = 0;
	reg [NUM_DATA_BITS-1:0]		req_data = 0;
	reg [(NUM_DATA_BITS/8)-1:0]	req_data_mask = 0;
	reg							req_kill = 0;
	wire						rsp_valid;
	wire						rsp_nack;
	wire  [NUM_TAG_BITS-1:0]	rsp_tag;
	wire  [2:0]					rsp_typ;
	wire  [NUM_DATA_BITS-1:0]	rsp_data;
	
	task hella_cache_master_bfm_clear_kill();
		req_kill = 0;
	endtask
	
	task hella_cache_master_bfm_send_req(
		longint unsigned	addr,
		longint unsigned	tag,
		int unsigned		cmd,
		int unsigned		typ,
		longint	unsigned	data,
		int unsigned		data_mask);
		
		// Wait for reset
		while (reset == 1) begin
			@(posedge clock);
		end

		$display("Assign req_cmd=%0d req_typ=%0d", req_cmd, req_typ);
		req_addr = addr;
		req_valid = 1;
		req_tag = tag;
		req_cmd = cmd;
		req_typ = typ;
		req_data_mask = data_mask;
	
		// Wait for ready
		do begin
			@(posedge clock);
		end while (req_ready == 0);
		
		// Write data is driven post-VALID
		req_data = data;
	
		req_addr = 0;
		req_valid = 0;
		req_tag = 0;
		req_cmd = 0;
		req_typ = 0;
		req_data_mask = 0;
		req_kill = 0;
		
		@(posedge clock);
	endtask
		
	task hella_cache_master_bfm_recv_rsp(
		output int unsigned		nack,
		output int unsigned		tag,
		output int unsigned		typ,
		output longint unsigned	data);
		
		// Wait for reset
		while (reset == 1) begin
			@(posedge clock);
		end

		while (rsp_valid == 0 && rsp_nack == 0) begin
			@(posedge clock);
		end
	
		nack = rsp_nack;
		tag = rsp_tag;
		typ = rsp_typ;
		data = rsp_data;
		
		if (nack) begin
			req_kill = 1;
		end
		
		@(posedge clock);
	endtask

endinterface

