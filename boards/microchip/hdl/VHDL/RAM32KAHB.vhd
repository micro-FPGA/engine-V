----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2018 21:24:04
-- Design Name: 
-- Module Name: RAM32KAHB - Behavioral
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

entity RAM32KAHB is Port ( 
           maddr               : in std_logic_vector(15 downto 0);
           mwdata              : in std_logic_vector(7 downto 0);
           mrdata              : out std_logic_vector(7 downto 0);
           mwrite              : in std_logic;
           mread               : in std_logic;
           mready              : out std_logic;
           -- AHB Bus
           HADDR : out STD_LOGIC_VECTOR (31 downto 0);
           HTRANS : out STD_LOGIC_VECTOR (1 downto 0);
           HWRITE : out STD_LOGIC;
           HSIZE : out STD_LOGIC_VECTOR (1 downto 0);
           HWDATA : out STD_LOGIC_VECTOR (31 downto 0);
           HSEL : out STD_LOGIC;
           HMASTLOCK : out STD_LOGIC;
           HREADY_OUT : out STD_LOGIC;
           HREADY : in STD_LOGIC;
           HRDATA : in STD_LOGIC_VECTOR (31 downto 0);
           HRESP : in STD_LOGIC;
           --
           Clk : in STD_LOGIC
           );
end RAM32KAHB;

architecture Behavioral of RAM32KAHB is

signal mwdata_s: std_logic_vector(7 downto 0);


begin
    HREADY_OUT <= HREADY;
    mready     <= HREADY;
    --
    HWDATA(31 downto 16) <= X"0000";
    -- Latch write DATA 
    HWDATA(15 downto 8)  <= mwdata_s;
    HWDATA (7 downto 0)  <= mwdata_s;
     
	process (Clk)
    begin
       if Clk'event and Clk = '1' then
           mwdata_s <= mwdata;
       end if;    
    end process;    
    HSIZE <= "00"; -- Byte transfers only
    
    HSEL <= '1';
    HTRANS(0) <= '0';
    HTRANS(1) <= mread or mwrite;
    HWRITE    <= mwrite;
    
    HADDR(0) <= maddr(0);
    HADDR(1) <= '0';
    HADDR(15 downto 2) <= maddr(14 downto 1);
     
    HADDR(31 downto 16) <= X"2000"; -- eSRAM
    -- input mux
    mrdata <= HRDATA(7 downto 0) when maddr(0) = '0' else HRDATA(15 downto 8);
    
    
    
    

end Behavioral;
