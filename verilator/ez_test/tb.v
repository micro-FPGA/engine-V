`timescale 1 ns / 1 ps

module tb (
`ifdef VERILATOR
	input clk
`endif
);
`ifndef VERILATOR
	reg clk = 1;
	always #10 clk = ~clk;
`endif

	reg resetn = 0;
	integer resetn_cnt = 0;

	reg uresetn = 0;
	integer uresetn_cnt = 0;

	integer cycle = 0;

	wire trap;

	initial begin
		$write("\n\rRISC-V Soft CPU Contest 2018\n\r");
		$write("Verilator main testbench\n\r\n\r");
	end

	always @(posedge clk) begin
		cycle <= cycle + 1;
	end

	always @(posedge clk) begin
		if (resetn_cnt < 200)
			resetn_cnt <= resetn_cnt + 1;
		else
			resetn <= 1;
	end

	wire UART_RX_wire;
	wire [7:0] UART_rx_byte;
	wire UART_rx_rdy;
	wire uart_baud_4x;

	MF8A18_SoC soc (
		.clk		(clk),
		.resetn		(resetn),
		.UART_TXD       (UART_RX_wire)
	);

	baudgen baud115200 (
		.clk		(clk),
		.tick           (uart_baud_4x)
	);

	rx uart_rx_inst (
		.res_n		(uresetn),
		.rx		(UART_RX_wire),
		.clk		(uart_baud_4x),		 /* Baud Rate x 4 (4 posedge's per bit) */
		.rx_byte	(UART_rx_byte),
		.rdy		(UART_rx_rdy)
	);

	always @(posedge clk) begin
		if (cycle > 1*50*1000000) begin
			$display("Finished...\n\r");
			$finish;			
		end
	end

	always @(posedge uart_baud_4x) begin
		if (uresetn_cnt < 2)
			uresetn_cnt <= uresetn_cnt + 1;
		else
			uresetn <= 1;

		if (UART_rx_rdy) begin
			$write("%c", UART_rx_byte);
		end
	end



endmodule
