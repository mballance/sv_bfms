
ifneq (1,$(RULES))

SV_BFMS_API_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SV_BFMS_API_SRC = \
  sv_bfms_rw_api_if.cpp
  
LIBSV_BFMS_DPI := libsv_bfms_dpi.o

SRC_DIRS += $(SV_BFMS_API_DIR)/c $(SV_BFMS_API_DIR)/../utils/c

else

$(LIBSV_BFMS_DPI) : $(SV_BFMS_API_SRC:.cpp=.o)
	$(Q)rm -f $@
	$(Q)$(LD) -r -o $@ $^

endif