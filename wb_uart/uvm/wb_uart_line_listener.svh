/****************************************************************************
 * wb_uart_line_listener.svh
 ****************************************************************************/

/**
 * Class: wb_uart_line_listener
 * 
 * TODO: Add class documentation
 */
class wb_uart_line_listener extends uvm_subscriber #(wb_uart_seq_item);
	`uvm_component_utils(wb_uart_line_listener)
	
	string				m_buffer;

	function new(string name="wb_uart_line_listener", uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void write(wb_uart_seq_item t);
		if (t.m_data == "\n") begin
			$display("MSG: %s", m_buffer);
			m_buffer = "";
		end else begin
			m_buffer = {m_buffer, t.m_data};
		end
	endfunction

endclass


