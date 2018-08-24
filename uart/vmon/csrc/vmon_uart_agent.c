/*
 * vmon_uart_agent.c
 *
 *  Created on: Aug 17, 2018
 *      Author: ballance
 */
#include "vmon_monitor.h"

// Message format is:
// type (rx=0,tx=1), seed, sz

void uart_agent_dev_tx(uint32_t id, uint32_t seed, uint32_t sz) {
	uint8_t data[16];
	uint8_t i=0;

	data[i++] = 1; // Tx
	data[i++] = (seed >> 0);
	data[i++] = (seed >> 8);
	data[i++] = (seed >> 16);
	data[i++] = (seed >> 24);
	data[i++] = (sz >> 0);
	data[i++] = (sz >> 8);
	data[i++] = (sz >> 16);
	data[i++] = (sz >> 24);

	vmon_monitor_fixedlen_msg(id, FIXEDLEN_16, data);
}

void uart_agent_dev_rx(uint32_t id, uint32_t seed, uint32_t sz) {
	uint8_t data[16];
	uint8_t i=0;

	data[i++] = 0; // Rx
	data[i++] = (seed >> 0);
	data[i++] = (seed >> 8);
	data[i++] = (seed >> 16);
	data[i++] = (seed >> 24);
	data[i++] = (sz >> 0);
	data[i++] = (sz >> 8);
	data[i++] = (sz >> 16);
	data[i++] = (sz >> 24);

	vmon_monitor_fixedlen_msg(id, FIXEDLEN_16, data);
}


