/*
 * vmon_uart_agent.c
 *
 *  Created on: Aug 17, 2018
 *      Author: ballance
 */
#include "uart_agent_dev.h"
#include "vmon_monitor.h"

void uart_agent_dev_init(uex_dev_t *devh) {
	// Nothing to do
}

// Message format is:
// devid
// type (rx=0,tx=1)
// seed,
// sz

void uart_agent_dev_tx(uint32_t id, uint32_t seed, uint32_t sz, uint8_t stride) {
	uart_agent_dev_t *dev = (uart_agent_dev_t *)uex_get_device(id);
	uintptr_t ep = (uintptr_t)dev->base.addr;
	uint8_t data[16];
	uint8_t i=0;

	data[i++] = (id >> 0);
	data[i++] = (id >> 8);
	data[i++] = (id >> 16);
	data[i++] = (id >> 24);
	data[i++] = 1; // Tx
	data[i++] = (seed >> 0);
	data[i++] = (seed >> 8);
	data[i++] = (seed >> 16);
	data[i++] = (seed >> 24);
	data[i++] = (sz >> 0);
	data[i++] = (sz >> 8);
	data[i++] = (sz >> 16);
	data[i++] = (sz >> 24);

	vmon_monitor_fixedlen_msg(ep, FIXEDLEN_16, data);
}

void uart_agent_dev_rx(uint32_t id, uint32_t seed, uint32_t sz, uint8_t stride) {
	uart_agent_dev_t *dev = (uart_agent_dev_t *)uex_get_device(id);
	uintptr_t ep = (uintptr_t)dev->base.addr;
	uint8_t data[16];
	uint8_t i=0;

	data[i++] = (id >> 0);
	data[i++] = (id >> 8);
	data[i++] = (id >> 16);
	data[i++] = (id >> 24);
	data[i++] = 0; // Rx
	data[i++] = (seed >> 0);
	data[i++] = (seed >> 8);
	data[i++] = (seed >> 16);
	data[i++] = (seed >> 24);
	data[i++] = (sz >> 0);
	data[i++] = (sz >> 8);
	data[i++] = (sz >> 16);
	data[i++] = (sz >> 24);

	vmon_monitor_fixedlen_msg(ep, FIXEDLEN_16, data);
}


