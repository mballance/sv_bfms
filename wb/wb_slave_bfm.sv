/****************************************************************************
 * wb_slave_bfm.sv
 ****************************************************************************/

/**
 * Interface: wb_slave_bfm
 * 
 * TODO: Add interface documentation
 */
interface wb_slave_bfm #(
		parameter int			WB_ADDR_WIDTH=32,
		parameter int			WB_DATA_WIDTH=32
		) (
		input			clk,
		input			rstn,
		wb_if.slave		slave);
	
	


endinterface


