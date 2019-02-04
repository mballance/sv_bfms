
SV_BFMS_SCRIPTS_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SV_BFMS_DIR := $(abspath $(SV_BFMS_SCRIPTS_DIR)/..)
PACKAGES_DIR ?= $(SV_BFMS_DIR)/packages
LIB_DIR = $(SV_BFMS_DIR)/lib

# Must support dual modes: 
# - build dependencies if this project is the active one
# - rely on the upper-level makefile to resolve dependencies if we're not
-include $(PACKAGES_DIR)/packages.mk
include $(SV_BFMS_DIR)/etc/ivpm.info

# ?
#include $(SV_BFMS_DIR)/mkfiles/sv_bfms.mk

SV_BFMS_SRC := \
  $(wildcard $(SV_BFMS_DIR)/src/sv_bfms/axi4/*.scala) \
  $(wildcard $(SV_BFMS_DIR)/src/sv_bfms/axi4/qvip/*.scala) \
  $(wildcard $(SV_BFMS_DIR)/src/sv_bfms/generic_sram_line_en_master/*.scala) \
  $(wildcard $(SV_BFMS_DIR)/src/sv_bfms/uart/*.scala) 

RULES := 1

ifeq (true,$(PHASE2))
build : $(SV_BFMS_JAR)

clean : 
	$(Q)rm -rf $(CHISELLIB_DIR)/build $(LIB_DIR)
else

clean : $(sv_bfms_clean_deps)
	$(MAKE) -f $(SV_BFMS_SCRIPTS_DIR)/ivpm.mk PHASE2=true clean

build : $(sv_bfms_deps)
	$(MAKE) -f $(SV_BFMS_SCRIPTS_DIR)/ivpm.mk PHASE2=true build
endif


$(SV_BFMS_JAR) : $(SV_BFMS_SRC) $(SV_BFMS_DEPS)
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)$(DO_CHISELC) 
	$(Q)touch $@

release : build
	$(Q)rm -rf $(CHISELLIB_DIR)/build
	$(Q)mkdir -p $(CHISELLIB_DIR)/build/chisellib
	$(Q)cp -r \
          $(CHISELLIB_DIR)/lib \
          $(CHISELLIB_DIR)/etc \
          $(CHISELLIB_DIR)/build/chisellib
	$(Q)cd $(CHISELLIB_DIR)/build ; \
		tar czf chisellib-$(version).tar.gz chisellib
	$(Q)rm -rf $(CHISELLIB_DIR)/build/chisellib

#include $(SV_BFMS_DIR)/mkfiles/sv_bfms.mk
-include $(PACKAGES_DIR)/packages.mk

