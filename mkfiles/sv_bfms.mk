
SV_BFMS_MKFILES_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
SV_BFMS_DIR := $(abspath $(SV_BFMS_MKFILES_DIR)/..)

SV_BFMS := $(SV_BFMS_DIR)
export SV_BFMS

ifneq (1,$(RULES))

SV_BFMS_JAR := $(SV_BFMS_DIR)/lib/sv_bfms.jar
SV_BFMS_DEPS = $(CHISELLIB_JARS) $(STD_PROTOCOL_IF_JARS)
SV_BFMS_JARS = $(SV_BFMS_JAR) $(SV_BFMS_DEPS)

else # Rules

endif

