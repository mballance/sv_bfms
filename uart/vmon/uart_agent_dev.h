/*
 * uart_agent_dev.h
 *
 *  Created on: Aug 17, 2018
 *      Author: ballance
 */

#ifndef INCLUDED_UART_AGENT_DEV_H
#define INCLUDED_UART_AGENT_DEV_H
#include <uex.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct uart_agent_dev_s {
	uex_dev_t			base;

} uart_agent_dev_t;

void uart_agent_dev_init(uex_dev_t *devh);

#define UART_AGENT_DEV_STATIC_INIT(__name, __ep) { \
	.base = UEX_DEV_STATIC_INIT(__name, __ep, uart_agent_dev_init) \
}

/**
 * Instruct the external agent to send in
 */
void uart_agent_dev_tx(uint32_t id, uint32_t seed, uint32_t sz, uint8_t stride);

void uart_agent_dev_rx(uint32_t id, uint32_t seed, uint32_t sz, uint8_t stride);

#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_UART_AGENT_DEV_H */
