//////////////////////////////////////////////////////////////////
//                                                              //
//  Generic Library SRAM with per byte write enable             //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Configurable depth and width. The DATA_WIDTH must be a      //
//  multiple of 8.                                              //
//                                                              //
//  Author(s):                                                  //
//      - Conor Santifort, csantifort.amber@gmail.com           //
//                                                              //
//////////////////////////////////////////////////////////////////
//                                                              //
// Copyright (C) 2010 Authors and OPENCORES.ORG                 //
//                                                              //
// This source file may be used and distributed without         //
// restriction provided that this copyright statement is not    //
// removed from the file and that any derivative work contains  //
// the original copyright notice and the associated disclaimer. //
//                                                              //
// This source file is free software; you can redistribute it   //
// and/or modify it under the terms of the GNU Lesser General   //
// Public License as published by the Free Software Foundation; //
// either version 2.1 of the License, or (at your option) any   //
// later version.                                               //
//                                                              //
// This source is distributed in the hope that it will be       //
// useful, but WITHOUT ANY WARRANTY; without even the implied   //
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      //
// PURPOSE.  See the GNU Lesser General Public License for more //
// details.                                                     //
//                                                              //
// You should have received a copy of the GNU Lesser General    //
// Public License along with this source; if not, download it   //
// from http://www.opencores.org/lgpl.shtml                     //
//                                                              //
//////////////////////////////////////////////////////////////////

`ifndef GENERIC_SRAM_BYTE_EN_BFM_NAME
`define GENERIC_SRAM_BYTE_EN_BFM_NAME generic_sram_byte_en_bfm
`endif

interface `GENERIC_SRAM_BYTE_EN_BFM_NAME #(
	parameter ADDRESS_WIDTH = 7,
	parameter DATA_WIDTH    = 128
) (
	input                           i_clk,
	input      [DATA_WIDTH-1:0]     i_write_data,
	input                           i_write_enable,
	input							i_read_enable,
	input      [ADDRESS_WIDTH-1:0]  i_address,
	input      [DATA_WIDTH/8-1:0]   i_byte_enable,
	output reg [DATA_WIDTH-1:0]     o_read_data
);                                                     

reg [DATA_WIDTH-1:0]   mem  [(2**ADDRESS_WIDTH)-1:0];
reg                    init [(2**ADDRESS_WIDTH)-1:0];
integer i;
localparam OFFSET_HIGH_BIT = (ADDRESS_WIDTH + $clog2(DATA_WIDTH) - 1);
localparam OFFSET_LOW_BIT = ($clog2(DATA_WIDTH/8));
localparam report_uninit = 0;

initial begin
	$display("generic_sram_byte_en_bfm %m: DATA_WIDTH=%0d ADDRESS_WIDTH=%0d OFFSET_HIGH=%0d OFFSET_LOW=%0d",
			DATA_WIDTH, ADDRESS_WIDTH, OFFSET_HIGH_BIT, OFFSET_LOW_BIT);
	for (i=0; i<(2**ADDRESS_WIDTH); i++) begin
		init[i] = 0;
	end
end

always @(posedge i_clk) begin
    // read
    o_read_data <= i_write_enable ? {DATA_WIDTH{1'd0}} : mem[i_address];
    
    // write
    if (i_write_enable) begin
        for (i=0;i<DATA_WIDTH/8;i=i+1) begin
            mem[i_address][i*8+0] <= i_byte_enable[i] ? i_write_data[i*8+0] : mem[i_address][i*8+0] ;
            mem[i_address][i*8+1] <= i_byte_enable[i] ? i_write_data[i*8+1] : mem[i_address][i*8+1] ;
            mem[i_address][i*8+2] <= i_byte_enable[i] ? i_write_data[i*8+2] : mem[i_address][i*8+2] ;
            mem[i_address][i*8+3] <= i_byte_enable[i] ? i_write_data[i*8+3] : mem[i_address][i*8+3] ;
            mem[i_address][i*8+4] <= i_byte_enable[i] ? i_write_data[i*8+4] : mem[i_address][i*8+4] ;
            mem[i_address][i*8+5] <= i_byte_enable[i] ? i_write_data[i*8+5] : mem[i_address][i*8+5] ;
            mem[i_address][i*8+6] <= i_byte_enable[i] ? i_write_data[i*8+6] : mem[i_address][i*8+6] ;
            mem[i_address][i*8+7] <= i_byte_enable[i] ? i_write_data[i*8+7] : mem[i_address][i*8+7] ;
        end            
//    	$display("%t %m write: address='h%08h data='h%08h byte_enable='h%02h memory='h%08h",
//    			$time, int'(i_address) << 2, i_write_data, i_byte_enable, mem[i_address]);
		init[i_address] = 1;
    end else begin
    	if (report_uninit && init[i_address] == 0 && i_address != 0) begin
    		$display("%m: Address 'h%08h uninitialized @ %t", 
    				(i_address << OFFSET_LOW_BIT), $time);
    	end
    end
end
    
    task generic_sram_byte_en_write8(
    	longint unsigned	offset,
    	int unsigned 		data);
    	automatic bit[DATA_WIDTH-1:0] tmp = mem[offset[OFFSET_HIGH_BIT:OFFSET_LOW_BIT]];
    	tmp &= ~('hff << 8*(DATA_WIDTH/8-offset[OFFSET_LOW_BIT-1:0]-1));
    	tmp |= (data << 8*(DATA_WIDTH/8-offset[OFFSET_LOW_BIT-1:0]-1));
    	mem[offset[OFFSET_HIGH_BIT:OFFSET_LOW_BIT]] = tmp;
    endtask
    export "DPI-C" task generic_sram_byte_en_write8;
    
    task generic_sram_byte_en_write16(
    	longint unsigned 	offset,
    	int unsigned 		data);
    	mem[offset] = data;
    endtask
    export "DPI-C" task generic_sram_byte_en_write16;
    
    task generic_sram_byte_en_write32(
    	longint unsigned	offset,
    	int unsigned 		data);
    	if (offset[OFFSET_HIGH_BIT:OFFSET_LOW_BIT] < (2**ADDRESS_WIDTH)-1) begin
	    	mem[offset[OFFSET_HIGH_BIT:OFFSET_LOW_BIT]] = data;
    	end else begin
    		$display("Error: ram(32)[%0d] = 'h%08h (offset='h%08h)", 
    				offset[OFFSET_HIGH_BIT:OFFSET_LOW_BIT], data, offset);
    	end
    endtask
    export "DPI-C" task generic_sram_byte_en_write32;
	
    task generic_sram_byte_en_read32(
    	longint unsigned	offset,
    	output int unsigned data);
    	data = mem[offset[OFFSET_HIGH_BIT:2]];
    endtask
    export "DPI-C" task generic_sram_byte_en_read32;
    
    task generic_sram_byte_en_read16(
    	longint unsigned 	offset,
    	output int unsigned data);
    	data = mem[offset];
    endtask
    export "DPI-C" task generic_sram_byte_en_read16;
    
    task generic_sram_byte_en_read8(
    	longint unsigned 	offset,
    	output int unsigned data);
    	automatic bit[DATA_WIDTH-1:0] tmp = mem[offset[OFFSET_HIGH_BIT:OFFSET_LOW_BIT]];
    	data = ((tmp >> 8*((DATA_WIDTH/8)-offset[OFFSET_LOW_BIT-1:0]-1)) & 'hFF);
    endtask
    export "DPI-C" task generic_sram_byte_en_read8;

`ifdef SV_BFMS_EN_DPI
    import "DPI-C" context task generic_sram_byte_en_register();
    
    initial begin
    	generic_sram_byte_en_register();
    end    
`endif
    

endinterface

