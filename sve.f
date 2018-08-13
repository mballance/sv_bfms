
+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

+incdir+${UVMDEV}/src
${UVMDEV}/src/uvmdev_pkg.sv

+incdir+${SV_BFMS}/api/sv
-f ${SV_BFMS}/api/sv/sv.f
-f ${SV_BFMS}/api/sv/sv_dpi.f
-f ${SV_BFMS}/utils/sv/sv.f

-f ${SV_BFMS}/event/event.f
-f ${SV_BFMS}/event/uvm/uvm.f

-f ${SV_BFMS}/generic_rom/uvm/uvm.f

-f ${SV_BFMS}/generic_rom/sv.f
-f ${SV_BFMS}/generic_sram_byte_en/uvm/uvm.f
-f ${SV_BFMS}/generic_sram_byte_en/sv.f

-F ${SV_BFMS}/generic_sram_line_en_master/uvm/sve.F
${SV_BFMS}/generic_sram_line_en_master/generic_sram_line_en_master_bfm.sv

-F ${SV_BFMS}/hella_cache_master/uvm/sve.F
${SV_BFMS}/hella_cache_master/hella_cache_master_bfm.sv

-f ${SV_BFMS}/uart/uvm/uvm.f
-f ${SV_BFMS}/uart/uvm/uart_agent_dev/uart_agent_dev.f
-f ${SV_BFMS}/uart/sv.f

-f ${SV_BFMS}/wb/wb.f
-f ${SV_BFMS}/wb/uvm/uvm.f

-f ${SV_BFMS}/wb_uart/uvm/uvm.f
-f ${SV_BFMS}/wb_uart/wb_uart.f

-F ${SV_BFMS}/irq/uvm/sve.F
${SV_BFMS}/irq/irq_bfm.sv
