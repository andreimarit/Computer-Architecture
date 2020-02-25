----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2019 01:53:15 AM
-- Design Name: 
-- Module Name: MemoryUnit - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MemoryUnit is
	port(
			clk: in std_logic;--
			ALURes : in std_logic_vector(15 downto 0);
			WriteData: in std_logic_vector(15 downto 0);
			MemWrite: in std_logic;			
			MemData:out std_logic_vector(15 downto 0);
			ALURes2 :out std_logic_vector(15 downto 0));
end MemoryUnit;

architecture Behavioral of MemoryUnit is

signal Address: std_logic_vector(6 downto 0);
type ram_type is array (0 to 7) of std_logic_vector(15 downto 0);
signal RAM:ram_type:=(
		X"000A",
		X"000B",
		X"000C",
		X"000D",
		X"ABCD",
		X"AAAA",
		X"FAAA",
		others =>X"0000");
begin

Address<=ALURes(6 downto 0);

process(clk) 			
begin
	if(rising_edge(clk)) then
		if MemWrite='1' then
				RAM(conv_integer(Address))<=WriteData;			
			end if;	
	end if;
	MemData<=RAM(conv_integer(Address));
end process;

ALURes2<=ALURes;

end Behavioral;