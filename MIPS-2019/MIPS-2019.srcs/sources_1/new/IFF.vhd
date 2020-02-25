----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2019 10:22:25 AM
-- Design Name: 
-- Module Name: IFF - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFF is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           j_address : in STD_LOGIC_VECTOR(15 downto 0);
           br_address : in STD_LOGIC_VECTOR(15 downto 0);
           j_select : in STD_LOGIC;
           br_select : in STD_LOGIC;
           PC : out STD_LOGIC_VECTOR(15 downto 0);
           instruction : out STD_LOGIC_VECTOR(15 downto 0));         
end IFF;

architecture Behavioral of IFF is
signal sum: STD_LOGIC_VECTOR (15 downto 0);
signal mux_br: STD_LOGIC_VECTOR (15 downto 0);
signal mux_j: STD_LOGIC_VECTOR (15 downto 0);
signal PC_address: STD_LOGIC_VECTOR (15 downto 0);
type rom_array is array (0 to 31) of std_logic_vector(15 downto 0);
signal Matrix : rom_array :=(
B"011_001_101_0000000",--StoreWord r2(r1 din regF) din memorie devine r5
B"000_000_010_100_0_000",--ADD r0+r2->r4
B"000_001_100_011_0_000",--ADD r1+r4->r3
B"000_011_001_110_0_001",--SUB r3-r1->r6
B"000_011_110_101_0_000",--ADD r3+r6->r5
B"000_101_011_010_0_000",--ADD r5+r3->r2
B"000_010_111_000_0_001",--SUB r2-r7->r0
B"100_111_000_0000100",--BEQ if r7=r0, jump to PC + 4
B"000_000_111_010_0_001",--SUB r0-r7->r2
B"100_010_111_0000010",--BEQ if r2=r7, jump to PC + 2
B"000_111_000_100_0_000",--ADD r7+r0->r4
B"111_0000000000011", --jump to instr 6 
B"000_101_010_000_0_100",--AND r5 and r2 => r0
B"000_011_000_110_1_010",--SHIFT_LEFT_LOGIC r3 (r0 but DON'T CARE) r6, we practically multiply r3 by 2
B"000_100_110_011_1_011",--SHIFT_RIGHT_LOGIC r4 (r6 but DON'T CARE) r3, we divide r0 with 2
B"000_011_111_000_0_000",--ADD r3+r7->r0
B"000_110_100_111_0_111",--SET_ON_LESS_THAN r6 r4 r7   THIS MEANS if r6 < r4 then r7:=1, else r7:=0
B"001_111_011_0001010",--ADDIMM r7 r3 A    r3:=r7+A;
B"010_111_011_0000100",--LOADWORD r3:=mem[r7+4]
B"000_011_111_000_0_000",--ADD r3+r7->r0
B"000_011_110_001_0_101",--OR r3 r6 =>r1
B"000_001_000_010_0_110",--XOR r1 r0 =>r2
B"111_0000000000000",--JUMP jump to the first instr 
-------RS----RT----RD
----R-TYPE
--B"000_011_100_010_0_000",--ADD
--B"000_100_101_011_0_001",--SUB
--B"000_011_000_100_1_010",--SHIFT_LEFT_LOGIC
--B"000_011_000_100_1_011",--SHIFT_RIGHT_LOGIC
--B"000_011_101_010_0_100",--AND
--B"000_011_101_010_0_101",--OR
--B"000_011_100_010_0_110",--XOR
--B"000_011_100_010_0_111",--SET_ON_LESS_THAN
----I-TYPE
--------RS--RT------
--B"001_010_011_0000101",--ADDIMM
--B"010_011_010_0000110",--LOADWORD
--B"011_011_010_0000110",--STOREWORD
--B"100_100_101_0000101",--BEQ
--B"101_010_011_0000101",--ANDIMM
--B"110_010_011_0000101",--ORIMM
----J-TYPE
--B"111_0000000000000"--JUMP
others => X"FFFF");

begin

sum<= PC_address + 1;

process(clk,mux_j)
    begin
    if rising_edge(clk) then
    PC_address<=mux_j;
    end if;
end process;

instruction<=Matrix(conv_integer(PC_address));

with j_select select mux_j<=
    j_address when '1',
    mux_br when '0';
    
with br_select select mux_br<=
    br_address when '1',
    sum when '0'; 
PC<= sum;
end Behavioral;


