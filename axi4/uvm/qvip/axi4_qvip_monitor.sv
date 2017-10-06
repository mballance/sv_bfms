/****************************************************************************
 * axi4_qvip_monitor.sv
 ****************************************************************************/

/**
 * Module: axi4_qvip_monitor
 * 
 * TODO: Add module documentation
 */
module axi4_qvip_monitor #(
		parameter int ADDR_WIDTH=32,
		parameter int DATA_WIDTH=32,
		parameter int ID_WIDTH=4,
		parameter int USER_WIDTH=1,
		parameter int REGION_MAP_SIZE=16) (
		// clock and reset signals
		input                            ACLK,
		input                            ARESETn,
		// write address channel signals
		input                           AWVALID,
		input [ADDR_WIDTH - 1:0]        AWADDR,
		input [2:0]                     AWPROT,
		input [3:0]                     AWREGION,
		input [7:0]                     AWLEN,
		input [2:0]                     AWSIZE,
		input [1:0]                     AWBURST,
		input                           AWLOCK,
		input [3:0]                     AWCACHE,
		input [3:0]                     AWQOS,
		input [ID_WIDTH - 1:0]          AWID,
		input [USER_WIDTH - 1:0]        AWUSER,
		input                            AWREADY,
		// read address channel signals
		input                           ARVALID,
		input [ADDR_WIDTH - 1:0]        ARADDR,
		input [2:0]                     ARPROT,
		input [3:0]                     ARREGION,
		input [7:0]                     ARLEN,
		input [2:0]                     ARSIZE,
		input [1:0]                     ARBURST,
		input                           ARLOCK,
		input [3:0]                     ARCACHE,
		input [3:0]                     ARQOS,
		input [ID_WIDTH - 1:0]          ARID,
		input [USER_WIDTH - 1:0]        ARUSER,
		input                            ARREADY,
		// read channel (data) signals
		input                            RVALID,
		input [DATA_WIDTH - 1:0]         RDATA,
		input [1:0]                      RRESP,
		input                            RLAST,
		input [ID_WIDTH - 1:0]           RID,
		input [USER_WIDTH - 1:0]         RUSER,
		input                           RREADY,
		// write channel signals
		input                           WVALID,
		input [DATA_WIDTH - 1:0]        WDATA,
		input [(DATA_WIDTH / 8) - 1:0]  WSTRB,
		input                           WLAST,
		input [USER_WIDTH - 1:0]        WUSER,
		input                            WREADY,
		// write response channel signals
		input                            BVALID,
		input [1:0]                      BRESP,
		input [ID_WIDTH - 1:0]           BID,
		input [USER_WIDTH - 1:0]         BUSER,
		input                           BREADY		
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

	assign axi4_if.AWVALID = AWVALID;
	assign axi4_if.AWADDR = AWADDR;
	assign axi4_if.AWPROT = AWPROT;
	assign axi4_if.AWREGION = AWREGION;
	assign axi4_if.AWLEN = AWLEN;
	assign axi4_if.AWSIZE = AWSIZE;
	assign axi4_if.AWBURST = AWBURST;
	assign axi4_if.AWLOCK = AWLOCK;
	assign axi4_if.AWCACHE = AWCACHE;
	assign axi4_if.AWQOS = AWQOS;
	assign axi4_if.AWID = AWID;
	assign axi4_if.AWUSER = AWUSER;

	assign axi4_if.ARVALID = ARVALID;
	assign axi4_if.ARADDR = ARADDR;
	assign axi4_if.ARPROT = ARPROT;
	assign axi4_if.ARREGION = ARREGION;
	assign axi4_if.ARLEN = ARLEN;
	assign axi4_if.ARSIZE = ARSIZE;
	assign axi4_if.ARBURST = ARBURST;
	assign axi4_if.ARLOCK = ARLOCK;
	assign axi4_if.ARCACHE = ARCACHE;
	assign axi4_if.ARQOS = ARQOS;
	assign axi4_if.ARID = ARID;
	assign axi4_if.ARUSER = ARUSER;

	assign axi4_if.RREADY = RREADY;
	assign axi4_if.WVALID = WVALID;
	assign axi4_if.WDATA = WDATA;
	assign axi4_if.WSTRB = WSTRB;
	assign axi4_if.WLAST = WLAST;
	assign axi4_if.WUSER = WUSER;

	assign axi4_if.BREADY = BREADY;

endmodule


