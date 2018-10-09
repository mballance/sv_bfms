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
	parameter DATA_WIDTH    = 128,
	parameter INIT_FILE     = ""
) (
	input                           i_clk,
	input      [DATA_WIDTH-1:0]     i_write_data,
	input                           i_write_enable,
	input      [ADDRESS_WIDTH-1:0]  i_address,
	input      [DATA_WIDTH/8-1:0]   i_byte_enable,
	output reg [DATA_WIDTH-1:0]     o_read_data
);                                                     

    reg [DATA_WIDTH-1:0]   mem  [(2**ADDRESS_WIDTH)-1:0];
    integer i;
    localparam OFFSET_HIGH_BIT = (ADDRESS_WIDTH + $clog2(DATA_WIDTH) - 1);
    localparam OFFSET_LOW_BIT = ($clog2(DATA_WIDTH/8));

    initial begin
	    $display("SRAM %m: OFFSET_HIGH_BIT=%0d OFFSET_LOW_BIT=%0d",
    			OFFSET_HIGH_BIT, OFFSET_LOW_BIT);
	    
	    u_core.mem = new[(2**ADDRESS_WIDTH)*(DATA_WIDTH/8)];
    end

    generic_sram_byte_en_bfm_core u_core ();
    assign u_core.mem_size = (2**ADDRESS_WIDTH)*(DATA_WIDTH/8);
    
    always @(posedge i_clk) begin
    	// read
   		automatic bit[DATA_WIDTH-1:0] rdata = 0;
   		automatic bit[ADDRESS_WIDTH+$clog2(DATA_WIDTH/8)-1:0] addr = {i_address, {$clog2(DATA_WIDTH/8){1'b0}}};
    		
   		for (int i=DATA_WIDTH/8-1; i>=0; i--) begin
   			rdata <<= 8;
   			rdata |= u_core.mem[addr+i];
   		end
   		o_read_data <= i_write_enable ? {DATA_WIDTH{1'd0}} : rdata;
    
    	// write
    	if (i_write_enable == 1) begin
    		automatic bit[ADDRESS_WIDTH+$clog2(DATA_WIDTH/8)-1:0] addr = {i_address, {$clog2(DATA_WIDTH/8){1'b0}}};
    		
    		for (i=0; i<DATA_WIDTH/8; i++) begin
    			if (i_byte_enable[i]) begin
    				u_core.mem[addr+i] = (i_write_data >> 8*i);
    			end
    		end            
    	end
    end
    
endinterface

interface generic_sram_byte_en_bfm_core;
	bit[7:0]			mem[];
	wire[31:0]			mem_size;
	reg                 little_endian = 1;

	task generic_sram_byte_en_bfm_write8(
		longint unsigned	offset,
		int unsigned 		data);
		mem[offset] = data;
	endtask
    
	task generic_sram_byte_en_bfm_write16(
		longint unsigned 	offset,
		int unsigned 		data);
		if (little_endian) begin
			for (int i=0; i<2; i++) begin
				mem[offset+i] = data >> 8*i;
			end
		end else begin
			for (int i=0; i<2; i++) begin
				mem[offset+2-i-1] = data >> 8*i;
			end
		end
	endtask
    
	task generic_sram_byte_en_bfm_write32(
		longint unsigned	offset,
		int unsigned 		data);
		if (little_endian) begin
			for (int i=0; i<4; i++) begin
				mem[offset+i] = data >> 8*i;
			end
		end else begin
			for (int i=0; i<4; i++) begin
				mem[offset+4-i-1] = data >> 8*i;
			end
		end
	endtask
	
	task generic_sram_byte_en_bfm_read32(
		longint unsigned	offset,
		output int unsigned data);
		data = 0;
		if (little_endian) begin
			for (int i=0; i<4; i++) begin
				data <<= 8;
				data |= mem[offset+i];
			end
		end else begin
			for (int i=3; i>=0; i--) begin
				data <<= 8;
				data |= mem[offset+i];
			end
		end
	endtask
    
	task generic_sram_byte_en_bfm_read16(
		longint unsigned 	offset,
		output int unsigned data);
		data = 0;
		if (little_endian) begin
			for (int i=0; i<2; i++) begin
				data <<= 8;
				data |= mem[offset+i];
			end
		end else begin
			for (int i=1; i>=0; i--) begin
				data <<= 8;
				data |= mem[offset+i];
			end
		end
	endtask
    
	task generic_sram_byte_en_bfm_read8(
		longint unsigned 	offset,
		output int unsigned data);
		data = mem[offset];
	endtask

endinterface

