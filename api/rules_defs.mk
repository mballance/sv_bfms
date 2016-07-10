
ifneq (1,$(RULES))

SV_BFMS_API_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

CFLAGS += -I$(SV_BFMS_API_DIR)/c -I$(SV_BFMS_API_DIR)/../utils/c
CXXFLAGS += -I$(SV_BFMS_API_DIR)/c -I$(SV_BFMS_API_DIR)/../utils/c

SV_BFMS_API_SRC = \
  sv_bfms_rw_api_if.c
  
LIBSV_BFMS_DPI := libsv_bfms_dpi.o

else

vpath %.c $(SV_BFMS_API_DIR)/c

$(LIBSV_BFMS_DPI) : $(SV_BFMS_API_SRC:.c=.o)
	$(Q)rm -f $@
	$(Q)$(LD) -r -o $@ $^

endif