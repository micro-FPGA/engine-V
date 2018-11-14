library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity echoloop is
	port(
		flash_ss	: out std_logic; 	-- 16
		tx	: out std_logic; 			-- 15
		rx	: in std_logic 				-- 14
		--
	);
end echoloop;

architecture rtl of echoloop is

begin
    flash_ss <= '1';
	tx       <= rx;
end;
