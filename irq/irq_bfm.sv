/****************************************************************************
 * irq_bfm.sv
 ****************************************************************************/

/**
 * Interface: irq_bfm
 * 
 * TODO: Add interface documentation
 */
interface irq_bfm (
		input			clk,
		input			rstn,
		input			irq
		);
	
	reg				reset_done = 0;
	reg				reset_start = 0;
	
	always @(posedge clk) begin
		if (rstn == 0) begin
			reset_start <= 1;
		end else begin
			if (reset_start) begin
				reset_done <= 1;
				reset_start <= 0;
			end
		end
	end
	
	task irq_bfm_wait_irq();
		do begin
			@(posedge clk);
		end while (reset_done != 1 || irq != 1);
	endtask
	
	task irq_bfm_debounce(int cnt);
		for (int i=0; i<cnt; i++) begin
			@(posedge clk);
		end
	endtask


endinterface


