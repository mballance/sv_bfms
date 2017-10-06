/****************************************************************************
 * axi4_monitor.sv
 ****************************************************************************/
 
`ifdef QUESTA_VIP_ENABLED
	`include "qvip.axi4.sv"
`endif

/**
 * Module: axi4_monitor_bfm
 * 
 * TODO: Add module documentation
 */
module axi4_monitor_bfm #(
		parameter int AXI4_ADDRESS_WIDTH=32,
		parameter int AXI4_DATA_WIDTH=128,
		parameter int AXI4_ID_WIDTH=4
		) (
		input			clk,
		input			rstn,
		axi4_if.monitor	monitor
		);

`ifdef QUESTA_VIP_ENABLED

`else
		
`endif


endmodule


