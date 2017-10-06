
SV_BFMS_SRC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SV_BFMS_LIB := sv_bfms.jar
SV_BFMS_SRC := $(wildcard $(SV_BFMS_SRC_DIR)/sv_bfms/*.scala)
SV_BFMS_DEPS := $(CHISELLIB) $(STD_PROTOCOL_IF_LIB)

else # Rules

$(SV_BFMS_LIB) : $(SV_BFMS_SRC) $(SV_BFMS_DEPS)
	$(Q)$(CHISELC) -o $@ $(SV_BFMS_SRC) $(foreach l,$(SV_BFMS_DEPS),-L$(l))

endif
