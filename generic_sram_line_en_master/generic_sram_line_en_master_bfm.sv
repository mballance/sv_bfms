/****************************************************************************
 * generic_sram_line_en_master_bfm.sv
 ****************************************************************************/

interface generic_sram_line_en_master_core #(
		parameter int	NUM_ADDR_BITS=32,
		parameter int	NUM_DATA_BITS=32
		) (
			input									clk,
			input									rstn
		);
	bit 						reset_entry = 0;
	bit							reset_done = 0;
	bit[NUM_ADDR_BITS-1:0]		addr;
	bit[NUM_DATA_BITS-1:0]		write_data;
	wire[NUM_DATA_BITS-1:0]		read_data;
	bit							write_en;
	bit							read_en;
	bit[NUM_ADDR_BITS-1:0]		addr_val;
	bit[NUM_DATA_BITS-1:0]		data_val;
	bit							rnw;
	bit							access_start;
	bit							access_ack;
	bit[1:0]					state;
	
	
	
	always @(posedge clk or rstn) begin
		if (rstn == 0) begin
			reset_entry <= 1;
			reset_done <= 0;
			addr <= 0;
			write_data <= 0;
			write_en <= 0;
			read_en <= 0;
			state <= 0;
		end else begin
			if (reset_entry) begin
				reset_entry <= 0;
				reset_done <= 1;
			end
		
			case (state)
				0: begin
					if (access_start) begin
						addr <= addr_val;
						read_en <= rnw;
						write_en <= !rnw;
						if (!rnw) begin
							write_data <= data_val;
						end
						state <= 1;
						access_start = 0; 
					end
				end
				
				1: begin
					if (rnw) begin
						data_val = read_data;
					end
					read_en <= 0;
					write_en <= 0;
					addr <= 0;
					write_data <= 0;
					state <= 0;
					access_ack = 1;
				end
			endcase
		end
	end
	
	task automatic write(
		bit[NUM_ADDR_BITS-1:0]	addr,
		bit[NUM_DATA_BITS-1:0]	data);
		while (!reset_done) begin
			@(posedge clk);
		end
	
		addr_val = addr;
		data_val = data;
		rnw = 0;
		access_start = 1;
		
		while (!access_ack) begin
			@(posedge clk);
		end
		access_ack = 0;
	endtask

	task automatic read(
		bit[NUM_ADDR_BITS-1:0]			addr,
		output bit[NUM_DATA_BITS-1:0]	data);
		while (!reset_done) begin
			@(posedge clk);
		end
	
		addr_val = addr;
		rnw = 1;
		access_start = 1;
		
		while (!access_ack) begin
			@(posedge clk);
		end
		data = data_val;
		access_ack = 0;
	endtask
	
endinterface

/**
 * Interface: generic_sram_line_en_master_bfm
 * 
 * TODO: Add interface documentation
 */
interface generic_sram_line_en_master_bfm #(
		parameter int	NUM_ADDR_BITS=32,
		parameter int	NUM_DATA_BITS=32
		) (
			input									clk,
			input									rstn,
			generic_sram_line_en_if.sram_client		client
		);

	generic_sram_line_en_master_core #(
		.NUM_ADDR_BITS  (NUM_ADDR_BITS ), 
		.NUM_DATA_BITS  (NUM_DATA_BITS )
		) u_core (
		.clk            (clk           ), 
		.rstn           (rstn          ));

	assign client.addr = u_core.addr;
	assign client.write_data = u_core.write_data;
	assign client.write_en = u_core.write_en;
	assign client.read_en = u_core.read_en;
	assign u_core.read_data = client.read_data;
endinterface


