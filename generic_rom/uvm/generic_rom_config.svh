

/**
 * Class: generic_rom_config
 * Provides configuration information for agent generic_rom
 */
class generic_rom_config `GENERIC_ROM_AGENT_PLIST extends uvm_object;
	typedef generic_rom_config `GENERIC_ROM_AGENT_PARAMS this_t;
	
	typedef virtual `GENERIC_ROM_BFM_NAME #(ADDRESS_WIDTH, DATA_WIDTH) vif_t;
	
	`uvm_object_param_utils (this_t)
	
	static const string report_id = "generic_rom_config";
	
	vif_t				vif;
	
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
	static function this_t get_config(
			uvm_component			comp,
			string					cfg_name = "generic_rom_config");
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



