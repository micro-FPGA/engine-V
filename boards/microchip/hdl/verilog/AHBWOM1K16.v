`timescale 1 ns / 1 ns // timescale for following modules


// --------------------------------------------------------------------------------
//  Company: 
//  Engineer: 
//  
//  Create Date: 18.11.2018 16:46:49
//  Design Name: 
//  Module Name: AHBWOM1K16 - Behavioral
//  Project Name: 
//  Target Devices: 
//  Tool Versions: 
//  Description: 
//  
//  Dependencies: 
//  
//  Revision:
//  Revision 0.01 - File Created
//  Additional Comments:
//  
// --------------------------------------------------------------------------------
//  Uncomment the following library declaration if using
//  arithmetic functions with Signed or Unsigned values
// use IEEE.NUMERIC_STD.ALL;
//  Uncomment the following library declaration if instantiating
//  any Xilinx leaf cells in this code.
// library UNISIM;
// use UNISIM.VComponents.all;

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

