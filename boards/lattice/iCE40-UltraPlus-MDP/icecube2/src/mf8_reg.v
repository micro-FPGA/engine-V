/*
 * Copyright 2018 MicroFPGA UG
 * Copyright 2019 The Regents of the University of California
 * Apache 2.0 License
 */


module mf8_reg(Clk, Reset, Wr, Rd_Addr, Rr_Addr, Data_In, Rd_Data, Rr_Data, Z);
	input Clk;
	input Reset;
	input Wr;
	input [4:0] Rd_Addr;
	input [4:0] Rr_Addr;
	input [7:0] Data_In;
	output [7:0] Rd_Data;
	output [7:0] Rr_Data;
	output [15:0] Z;
	reg    [15:0] Z;

	// Write Address Buffer
	reg [4:0] RAM_Write_Address;
	always @(posedge Clk) begin
		RAM_Write_Address <= Rd_Addr;
	end

	// RAM D
	reg [7:0] RAMD [31:0];
	reg [7:0] RAMD_Out;

	always @(posedge Clk) begin
		if (Wr) RAMD[RAM_Write_Address] <= Data_In;
		RAMD_Out <= RAMD[Rd_Addr];
	end

	// RAM R
	reg [7:0] RAMR [31:0];
	reg [7:0] RAMR_Out;

	always @(posedge Clk) begin
		if (Wr) RAMR[RAM_Write_Address] <= Data_In;
		RAMR_Out <= RAMR[Rr_Addr];
	end

	// Bypass
	reg [7:0] Write_Data;
	reg Bypass_D;
	reg Bypass_R;
	always @(posedge Clk) begin
		Bypass_D <= Wr & (RAM_Write_Address == Rd_Addr);
		Bypass_R <= Wr & (RAM_Write_Address == Rr_Addr);
		Write_Data <= Data_In;
	end

	assign Rd_Data = Bypass_D? Write_Data : RAMD_Out;
	assign Rr_Data = Bypass_R? Write_Data : RAMR_Out;

	// Z Register
	always @(posedge Clk) begin
		if (Wr & RAM_Write_Address == 5'b11110) begin
			Z[7:0]	<= Data_In;
		end
		if (Wr & RAM_Write_Address == 5'b11111) begin
			Z[15:8]	<= Data_In;
		end
	end
endmodule
