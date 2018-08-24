/****************************************************************************
 * vmon_uart_agent_ep_listener.svh
 ****************************************************************************/

/**
 * Class: vmon_uart_agent_ep_listener
 * 
 * TODO: Add class documentation
 */
class vmon_uart_agent_ep_listener implements vmon_client_ep_if;

	function new();

	endfunction
	
	function void process_msg(byte unsigned ep, vmon_databuf data);
	endfunction


endclass


