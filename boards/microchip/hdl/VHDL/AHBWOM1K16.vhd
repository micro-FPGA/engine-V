----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.11.2018 16:46:49
-- Design Name: 
-- Module Name: AHBWOM1K16 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AHBWOM1K16 is
    Port ( CLK : in STD_LOGIC;
           HADDR : in STD_LOGIC_VECTOR (31 downto 0);
           HWDATA : in STD_LOGIC_VECTOR (31 downto 0);
           HWRITE : in STD_LOGIC;
           addr : out STD_LOGIC_VECTOR (9 downto 0);
           data : out STD_LOGIC_VECTOR (15 downto 0);
           we : out STD_LOGIC);
end AHBWOM1K16;

architecture Behavioral of AHBWOM1K16 is

begin
    data <= HWDATA(15 downto 0);

process (CLK)
    begin
    if CLK'event and CLK = '1' then
        addr <= HADDR(11 downto 2);
        we   <= HWRITE;
    end if;
end process;


end Behavioral;
