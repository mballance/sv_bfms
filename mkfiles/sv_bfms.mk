
SV_BFMS_MKFILES_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
SV_BFMS_DIR := $(abspath $(SV_BFMS_MKFILES_DIR)/..)

ifneq (1,$(RULES))

SV_BFMS_JAR := $(SV_BFMS_DIR)/lib/sv_bfms.jar
SV_BFMS_DEPS = $(CHISELLIB_JAR) $(STD_PROTOCOL_IF_JAR)

else # Rules

endif

