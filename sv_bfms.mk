
SV_BFMS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

QVIP_ENABLED := $(call has_plusarg,tool.qvip,$(PLUSARGS))


ifeq (true,$(QVIP_ENABLED))
  QVIP_PROTOCOLS := $(sort $(call get_plusarg,tool.qvip.protocol,$(PLUSARGS)))
  VLOG_DEFINES += QUESTA_VIP_ENABLED
  BUILD_PRECOMPILE_TARGETS += $(foreach p,$(QVIP_PROTOCOLS),qvip.$(p).sv)
  VLOG_INCLUDES += $(QUESTA_MVC_HOME)/questa_mvc_src/sv $(QUESTA_MVC_HOME)/include
  VLOG_INCLUDES += $(foreach p,$(QVIP_PROTOCOLS),$(QUESTA_MVC_HOME)/questa_mvc_src/sv/$(p))
endif

else # Rules

qvip.%.sv : 
	$(Q)echo '`include "questa_mvc_svapi.svh"' > $@
	$(Q)echo '`include "mvc_pkg.sv"' >> $@
	$(Q)pkg=`cd $(QUESTA_MVC_HOME)/questa_mvc_src/sv/$*; ls *_pkg.sv`; \
		echo '`include "'$${pkg}'"' >> $@

endif
