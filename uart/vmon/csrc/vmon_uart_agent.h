/*
 * vmon_uart_agent.h
 *
 *  Created on: Aug 17, 2018
 *      Author: ballance
 */

#ifndef INCLUDED_VMON_UART_AGENT_H
#define INCLUDED_VMON_UART_AGENT_H
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Instruct the external agent to send in
 */
void uart_agent_dev_tx(uint32_t id, uint32_t seed, uint32_t sz);

void uart_agent_dev_rx(uint32_t id, uint32_t seed, uint32_t sz);

#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_VMON_UART_AGENT_H */
