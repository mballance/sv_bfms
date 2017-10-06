
SV_BFMS_SRC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SV_BFMS_JAR := sv_bfms.jar
SV_BFMS_DEPS = $(CHISELLIB_JAR) $(STD_PROTOCOL_IF_LIB)

SV_BFMS_SRC := \
	$(wildcard $(SV_BFMS_SRC_DIR)/sv_bfms/axi4/*.scala) \
	$(wildcard $(SV_BFMS_SRC_DIR)/sv_bfms/axi4/qvip/*.scala)

else # Rules

$(SV_BFMS_JAR) : $(SV_BFMS_DEPS) $(SV_BFMS_SRC)
	$(Q)$(DO_CHISELC)

endif
