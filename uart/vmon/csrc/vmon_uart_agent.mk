
VMON_UART_AGENT_CSRC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SRC_DIRS += $(VMON_UART_AGENT_CSRC_DIR)

VMON_UART_AGENT_SRC = $(notdir $(wildcard $(VMON_UART_AGENT_CSRC_DIR)/*.c))

else # Rules

libvmon_uart_agent.o : $(VMON_UART_AGENT_SRC:.c=.o)
	$(Q)$(LD) -r -o $@ $(VMON_UART_AGENT_SRC:.c=.o)

endif
