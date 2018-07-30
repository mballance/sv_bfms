/****************************************************************************
 * uart_serial_api_pkg.sv
 ****************************************************************************/

/**
 * Package: uart_serial_api_pkg
 * 
 * TODO: Add package documentation
 */
package uart_serial_api_pkg;

`ifdef HAVE_HDL_VIRTUAL_INTERFACE
	class uart_serial_api;
		
		virtual task reset();
		endtask
		
		virtual task tx_done();
		endtask
		
		virtual task rx_done(byte unsigned data);
		endtask
		
	endclass
`endif


endpackage


