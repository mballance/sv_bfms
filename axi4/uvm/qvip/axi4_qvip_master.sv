/****************************************************************************
 * axi4_qvip_master.sv
 ****************************************************************************/

/**
 * Module: axi4_qvip_master
 * 
 * TODO: Add module documentation
 */
module axi4_qvip_master #(
		parameter int ADDR_WIDTH=32,
		parameter int DATA_WIDTH=32,
		parameter int ID_WIDTH=4,
		parameter int USER_WIDTH=1,
		parameter int REGION_MAP_SIZE=16) (
		// clock and reset signals
		input                            ACLK,
		input                            ARESETn,
		// write address channel signals
		output                           AWVALID,
		output [ADDR_WIDTH - 1:0]        AWADDR,
		output [2:0]                     AWPROT,
		output [3:0]                     AWREGION,
		output [7:0]                     AWLEN,
		output [2:0]                     AWSIZE,
		output [1:0]                     AWBURST,
		output                           AWLOCK,
		output [3:0]                     AWCACHE,
		output [3:0]                     AWQOS,
		output [ID_WIDTH - 1:0]          AWID,
		output [USER_WIDTH - 1:0]        AWUSER,
		input                            AWREADY,
		// read address channel signals
		output                           ARVALID,
		output [ADDR_WIDTH - 1:0]        ARADDR,
		output [2:0]                     ARPROT,
		output [3:0]                     ARREGION,
		output [7:0]                     ARLEN,
		output [2:0]                     ARSIZE,
		output [1:0]                     ARBURST,
		output                           ARLOCK,
		output [3:0]                     ARCACHE,
		output [3:0]                     ARQOS,
		output [ID_WIDTH - 1:0]          ARID,
		output [USER_WIDTH - 1:0]        ARUSER,
		input                            ARREADY,
		// read channel (data) signals
		input                            RVALID,
		input [DATA_WIDTH - 1:0]         RDATA,
		input [1:0]                      RRESP,
		input                            RLAST,
		input [ID_WIDTH - 1:0]           RID,
		input [USER_WIDTH - 1:0]         RUSER,
		output                           RREADY,
		// write channel signals
		output                           WVALID,
		output [DATA_WIDTH - 1:0]        WDATA,
		output [(DATA_WIDTH / 8) - 1:0]  WSTRB,
		output                           WLAST,
		output [USER_WIDTH - 1:0]        WUSER,
		input                            WREADY,
		// write response channel signals
		input                            BVALID,
		input [1:0]                      BRESP,
		input [ID_WIDTH - 1:0]           BID,
		input [USER_WIDTH - 1:0]         BUSER,
		output                           BREADY		
		);
	import uvm_pkg::*;
	
	typedef virtual mgc_axi4 #(ADDR_WIDTH, DATA_WIDTH, 
		DATA_WIDTH, ID_WIDTH, USER_WIDTH, REGION_MAP_SIZE) axi4_if_t;
	
	mgc_axi4 #(ADDR_WIDTH, DATA_WIDTH, DATA_WIDTH, 
			ID_WIDTH, USER_WIDTH, REGION_MAP_SIZE) axi4_if(ACLK, ARESETn);
	
	assign axi4_if.AWREADY = AWREADY;
	assign axi4_if.ARREADY = ARREADY;
	assign axi4_if.RVALID  = RVALID;
	assign axi4_if.RDATA   = RDATA;
	assign axi4_if.RRESP   = RRESP;
	assign axi4_if.RLAST   = RLAST;
	assign axi4_if.RID     = RID;
	assign axi4_if.RUSER   = RUSER;
	assign axi4_if.WREADY  = WREADY;
	assign axi4_if.BVALID  = BVALID;
	assign axi4_if.BRESP   = BRESP;
	assign axi4_if.BID     = BID;
	assign axi4_if.BUSER   = BUSER;

	assign AWVALID  = axi4_if.AWVALID;
	assign AWADDR   = axi4_if.AWADDR;
	assign AWPROT   = axi4_if.AWPROT;
	assign AWREGION = axi4_if.AWREGION;
	assign AWLEN    = axi4_if.AWLEN;
	assign AWSIZE   = axi4_if.AWSIZE;
	assign AWBURST  = axi4_if.AWBURST;
	assign AWLOCK   = axi4_if.AWLOCK;
	assign AWCACHE  = axi4_if.AWCACHE;
	assign AWQOS    = axi4_if.AWQOS;
	assign AWID     = axi4_if.AWID;
	assign AWUSER   = axi4_if.AWUSER;

	assign ARVALID  = axi4_if.ARVALID;
	assign ARADDR   = axi4_if.ARADDR;
	assign ARPROT   = axi4_if.ARPROT;
	assign ARREGION = axi4_if.ARREGION;
	assign ARLEN    = axi4_if.ARLEN;
	assign ARSIZE   = axi4_if.ARSIZE;
	assign ARBURST  = axi4_if.ARBURST;
	assign ARLOCK   = axi4_if.ARLOCK;
	assign ARCACHE  = axi4_if.ARCACHE;
	assign ARQOS    = axi4_if.ARQOS;
	assign ARID     = axi4_if.ARID;
	assign ARUSER   = axi4_if.ARUSER;

	assign RREADY   = axi4_if.RREADY;
	assign WVALID   = axi4_if.WVALID;
	assign WDATA    = axi4_if.WDATA;
	assign WSTRB    = axi4_if.WSTRB;
	assign WLAST    = axi4_if.WLAST;
	assign WUSER    = axi4_if.WUSER;

	assign BREADY   = axi4_if.BREADY;

	initial begin
		axi4_if.axi4_set_master_abstraction_level(1'b0, 1'b1);
	end

endmodule


