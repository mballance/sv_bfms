

/**
 * Class: generic_sram_byte_en_config
 * Provides configuration information for agent generic_sram_byte_en
 */
class generic_sram_byte_en_config #(parameter int ADDRESS_WIDTH=32, parameter int DATA_WIDTH=32) extends uvm_object;
	
	typedef generic_sram_byte_en_config #(ADDRESS_WIDTH, DATA_WIDTH) this_t;
	`uvm_object_param_utils (this_t)
		
	typedef virtual `GENERIC_SRAM_BYTE_EN_BFM_NAME #(ADDRESS_WIDTH, DATA_WIDTH) vif_t;
	
	vif_t				vif;
	
	static const string report_id = "generic_sram_byte_en_config";
	
	// TODO: Add virtual interface handles

	// Specify the config values
	bit					has_monitor		= 1;
	bit					has_driver		= 1;
	bit					has_sequencer	= 1;

	
	/**
	 * Function: get_config
	 * Convenience function that obtains the config object from the
	 * UVM configuration database and reports an error if not present
	 */
	static function generic_sram_byte_en_config::this_t get_config(
			uvm_component			comp,
			string					cfg_name = "generic_sram_byte_en_config");
		this_t cfg;
		
		if (!uvm_config_db #(this_t)::get(comp, "", cfg_name, cfg)) begin
			comp.uvm_report_error(report_id,
				$psprintf("%s has no config associated with id %s",
					comp.get_full_name(), cfg_name),, `__FILE__, `__LINE__);
			return null;
		/*
		 */
		end
		
		return cfg;
	endfunction

endclass



