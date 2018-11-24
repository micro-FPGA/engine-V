/*
 * Copyright 2018 MicroFPGA UG
 * Apache 2.0 License
 */

module AHBWOM1K16 (
   CLK,
   HADDR,
   HWDATA,
   HWRITE,
   addr,
   data,
   we);
 

input   CLK; 
input   [31:0] HADDR; 
input   [31:0] HWDATA; 
input   HWRITE; 
output   [9:0] addr; 
output   [15:0] data; 
output   we; 

reg     [9:0] addr; 
wire    [15:0] data; 
reg     we; 

assign data = HWDATA[15:0]; 

always @(posedge CLK)
   begin : process_1
   addr <= HADDR[11:2];   
   we <= HWRITE;   
   end


endmodule // module AHBWOM1K16

