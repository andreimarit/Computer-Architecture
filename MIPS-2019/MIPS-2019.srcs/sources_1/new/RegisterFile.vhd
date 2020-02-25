library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity RegisterFile is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           regWr : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is

type reg_array is array (0 to 7) of std_logic_vector (15 downto 0);
signal regis_file : reg_array :=(
    X"0000",
    X"0002",
    X"0005",
    X"0009",
    X"000D",
    X"00A3",
    X"0004",
    X"0001",
    others => X"FEFE");

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if regWr = '1' then
                regis_file(conv_integer(wa)) <= wd;
            end if;
        end if;
    end process;
    
    rd1 <= regis_file(conv_integer(ra1));
    rd2 <= regis_file(conv_integer(ra2)); 



end Behavioral;
