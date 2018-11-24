/*
 * Copyright 2018 MicroFPGA UG
 * Apache 2.0 License
 */


module mf8_pcs(Clk, Reset_n, Offs_In, Pause, RJmp, NPC, PC);
	input		Clk;
	input		Reset_n;
	input	[11:0]	Offs_In;
	input		Pause;
	input		RJmp;
	output	[11:0]	NPC;
	output	[11:0]	PC;


	reg 	[8:0]	PC_i;
	wire	[8:0]	NPC_i;
	wire	[8:0]	inc_or_nop;
	wire	[8:0]	real_offset;


	assign	NPC[8:0] = NPC_i;
	assign	PC[8:0]	 = PC_i;

	assign	NPC[11:9] = 3'b000;
	assign	PC[11:9]  = 3'b000;

	assign	inc_or_nop	= {8'b00000000 , ( ~Pause)};
	assign	real_offset	= (RJmp == 1'b0) ? (inc_or_nop)	: (Offs_In[8:0]);
	assign	NPC_i	= PC_i + real_offset;

	assign	inc_or_nop	= {8'b00000000 , ( ~Pause)};

	always @(posedge Clk or negedge Reset_n) begin
		if (Reset_n == 1'b0) begin
			PC_i[8:0]	<= 9'b000000000;
		end else begin
			PC_i[8:0]	<= NPC_i;
		end
	end
endmodule
