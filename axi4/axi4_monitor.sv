/****************************************************************************
 * axi4_monitor.sv
 ****************************************************************************/
 

/**
 * Module: axi4_monitor
 * 
 * TODO: Add module documentation
 */
module axi4_monitor #(
		parameter int AXI4_ADDRESS_WIDTH=32,
		parameter int AXI4_DATA_WIDTH=128,
		parameter int AXI4_ID_WIDTH=4
		) (
		input			clk,
		input			rstn,
		axi4_if.monitor	monitor
		);

	// Just a shell

endmodule


