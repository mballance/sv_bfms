/****************************************************************************
 * generic_rom_bfm.sv
 ****************************************************************************/
 
`ifndef GENERIC_ROM_BFM_NAME
`define GENERIC_ROM_BFM_NAME generic_rom_bfm
`endif

/**
 * Module: generic_rom
 * 
 * TODO: Add module documentation
 */
interface `GENERIC_ROM_BFM_NAME #(
			parameter int ADDRESS_WIDTH	= 32,
			parameter int DATA_WIDTH	= 32,
			parameter INIT_FILE = ""
		) (
			input						i_clk,
			input [ADDRESS_WIDTH-1:0]	i_address,
			output [DATA_WIDTH-1:0]		o_read_data
		);
	reg[DATA_WIDTH-1:0]				rom[(2**ADDRESS_WIDTH)-1:0];
	reg								init[(2**ADDRESS_WIDTH)-1:0];
	reg[ADDRESS_WIDTH-1:0]			read_addr;
	reg[DATA_WIDTH-1:0]				read_data;
	localparam OFFSET_HIGH_BIT = (ADDRESS_WIDTH + $clog2(DATA_WIDTH) - 1);
	localparam OFFSET_LOW_BIT  = ($clog2(DATA_WIDTH/8));
	localparam report_uninit   = 0;
	
	initial begin
		$display("OFFSET_HIGH_BIT=%0d ADDRESS_WIDTH=%0d", OFFSET_HIGH_BIT, ADDRESS_WIDTH);
		for (int i=0; i<(2**ADDRESS_WIDTH); i++) begin
			init[i] = 0;
		end
	end

    task generic_rom_write8(
    	longint unsigned	offset,
    	int unsigned 		data);
    	automatic bit[DATA_WIDTH-1:0] tmp = rom[offset >> 2];
    	tmp &= ~('hff << offset[2:0]);
    	tmp |= (data << offset[2:0]);
    	rom[offset] = tmp;
    endtask
    export "DPI-C" task generic_rom_write8;
    
    task generic_rom_write16(
    	longint unsigned 	offset,
    	int unsigned 		data);
    	rom[offset] = data;
    endtask
    export "DPI-C" task generic_rom_write16;
    
    task generic_rom_write32(
    	longint unsigned	offset,
    	int unsigned 		data);
    	if (offset[OFFSET_HIGH_BIT:2] < (2**ADDRESS_WIDTH)-1) begin
	    	rom[offset[OFFSET_HIGH_BIT:2]] = data;
	    	init[offset[OFFSET_HIGH_BIT:2]] = 1;
    	end else begin
	    	$display("Error: rom(32)[%0d] = 'h%08h", offset[(ADDRESS_WIDTH-1):2], data);
    	end
    endtask
    export "DPI-C" task generic_rom_write32;
	
    task generic_rom_read32(
    	longint unsigned	offset,
    	output int unsigned data);
    	if (offset[OFFSET_HIGH_BIT:2] < (2**ADDRESS_WIDTH)-1) begin
	    	data = rom[offset[OFFSET_HIGH_BIT:2]];
    	end else begin
	    	$display("Error: rom(32)[%0d]", offset[(ADDRESS_WIDTH-1):2]);
    	end
    endtask
    export "DPI-C" task generic_rom_read32;
    
    task generic_rom_read16(
    	longint unsigned 	offset,
    	output int unsigned data);
    	data = rom[offset];
    endtask
    export "DPI-C" task generic_rom_read16;
    
    task generic_rom_read8(
    	longint unsigned 	offset,
    	output int unsigned data);
    	data = rom[offset];
    endtask
    export "DPI-C" task generic_rom_read8;
   
`ifdef SV_BFMS_EN_DPI
    import "DPI-C" context task generic_rom_register();
`endif
    
    initial begin
    	$display("generic_rom_bfm %m: DATA_WIDTH=%0d ADDRESS_WIDTH=%0d",
    			DATA_WIDTH, ADDRESS_WIDTH);
`ifdef SV_BFMS_EN_DPI
    	generic_rom_register();
`endif    
    end


	always @(posedge i_clk) begin
//		read_addr <= i_address;
//		read_data <= rom[read_addr];
		read_data <= rom[i_address];
		
		if (report_uninit && init[i_address] == 0) begin
			$display("%m: Address 'h%08h uninitialized @ %t", 
					(i_address << OFFSET_LOW_BIT), $time);
		end
	end

	assign o_read_data = read_data;
endinterface

