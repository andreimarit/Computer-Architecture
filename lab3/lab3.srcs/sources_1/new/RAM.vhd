library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity DataMemory is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           regWr : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0));
end DataMemory;

architecture Behavioral of DataMemory is

type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
signal regis_file : reg_array :=(
B"000_011_100_010_0_000",--ADD
B"000_100_101_011_0_001",--SUB
B"000_011_000_100_1_010",--SHIFT_LEFT
B"000_011_000_100_1_011",--SHIFT_RIGHT
--B"000_011_101_010_0_101",--AND
--B"000_011_101_010_0_110",--OR
--B"000_011_100_010_0_111",--XOR
B"001_010_011_0000101",--ADDIMM
B"010_011_010_0000110",--LOADWORD
B"100_100_101_011_0000101",--BEQ
B"011_011_010_0000111"--STOREWORD
--ANDImm
--ORImm
--Jump
);

begin
    process(regWr)
    begin
            if regWr = '1' then
                regis_file(conv_integer(wa)) <= wd;
            end if;
    end process;
    
    rd1 <= regis_file(conv_integer(ra1));
    



end Behavioral;
