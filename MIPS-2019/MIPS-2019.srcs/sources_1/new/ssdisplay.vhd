
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ssdisplay is
    Port ( d0 : in STD_LOGIC_VECTOR (3 downto 0);
           d1 : in STD_LOGIC_VECTOR (3 downto 0);
           d2 : in STD_LOGIC_VECTOR (3 downto 0);
           d3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           reset: in STD_LOGIC);
end ssdisplay;

architecture Behavioral of ssdisplay is

signal sel: STD_LOGIC_VECTOR(15 DOWNTO 0);
signal tempD: STD_LOGIC_VECTOR(3 DOWNTO 0);
signal cnt: STD_LOGIC_VECTOR(15 DOWNTO 0);
begin
--counter
counter: process(clk, reset)
begin 
    if rising_edge(clk) then
        sel <= sel + 1;
     end if;
     if reset='1' then sel<=X"0000";
     end if;
     end process;
     
--mux with digits
mux4_1: process(sel(15 downto 14))
begin
		case sel(15 DOWNTO 14)  is
			when "00"	=> tempD <= d0; 
			when "01"	=> tempD <= d1; 
			when "10"	=> tempD <= d2; 
			when others	=> tempD <= d3; 
		end case;
	end process;

--mux with AN
mux4_2: process(sel(15 downto 14))
begin
		case sel(15 DOWNTO 14) is
			when "00"	=>  an <= "1110";
			when "01"	=>  an <= "1101";
			when "10"	=>  an <= "1011";
			when others	=>  an <= "0111";
		end case;
	end process;

--DCD
process (tempD)
begin
       case tempD is
        when "0000"=> cat <="1000000";  -- '0' ----0000001
        when "0001"=> cat <="1111001";  -- '1' ----1001111
        when "0010"=> cat <="0100100";  -- '2' ----0010010
        when "0011"=> cat <="0110000";  -- '3' ----0000110
        when "0100"=> cat <="0011001";  -- '4' ----1001100
        when "0101"=> cat <="0010010";  -- '5' ----0100100
        when "0110"=> cat <="0000010";  -- '6' ----0100000
        when "0111"=> cat <="1111000";  -- '7' ----0001111
        when "1000"=> cat <="0000000";  -- '8' ----0000000
        when "1001"=> cat <="0010000";  -- '9' ----0000100
        when "1010"=> cat <="0001000";  -- 'A' ----0001000
        when "1011"=> cat <="0000011";  -- 'b' ----1100000
        when "1100"=> cat <="1000110";  -- 'C' ----0110001
        when "1101"=> cat <="0100001";  -- 'd' ----1000010
        when "1110"=> cat <="0000110";  -- 'E' ----0110000
        when "1111"=> cat <="0001110";  -- 'F' ----0111000
        when others =>  NULL;
      end case;
end process;       

end Behavioral;
