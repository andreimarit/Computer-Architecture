----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/07/2019 08:37:53 AM
-- Design Name: 
-- Module Name: FSM_R - Behavioral
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

entity FSM_R is
    Port (clk: in STD_LOGIC;
    RX_RDY: out std_logic;
    RX_DATA: out std_logic_Vector(7 downto 0);
    BAUD_EN: IN STD_LOGIC;
    rst:in std_logic;
    rx:in std_logic );
end FSM_R;

architecture Behavioral of FSM_R is
type state_type is (idle,start, bits, stop,waits);
signal state: state_type;
signal BIT_CNT:std_logic_vector(2 downto 0):="000";
signal BAUD_CNT: std_logic_vector (3 downto 0) :="0000";

begin
 
 process(state)   
 begin 
    case state is
            when idle => RX_RDY <='0';
            when start => RX_RDY <='0';
            when bits => RX_RDY <='0';
            when stop => RX_RDY <='1';
            when waits => RX_RDY <='1';
    end case;  
end process;  


process(CLK, RST, RX)
begin
    if (RST='1') then
    state <= idle;
    elsif (CLK='1' and CLK'event) then
        if(BAUD_EN='1') then
            case state is
                when idle => BAUD_CNT <= "0000";
                            BIT_CNT<="000";
                         if (RX='0') then 
                            state <=start;
                         end if;
                when start => 
                         if (RX='1') then
                        state <=idle;
                        elsif (RX='0' and BAUD_CNT ="0111") then
                        state <=bits;
                        elsif(BAUD_CNT < "0111") then
                        BAUD_CNT <= BAUD_CNT + 1;
                        state <= start;
                        end if;
               when bits => BAUD_CNT <= BAUD_CNT+1;
                             if(BIT_CNT < "111" and BAUD_CNT="1111") then
                                                        BAUD_CNT <= BAUD_CNT + 1;
                                                        RX_DATA(conv_integer(BIT_CNT))<=RX;
                                                        BIT_CNT<=BIT_CNT+1;
                                                        BAUD_CNT <="0000";
                                                        state <= bits;
                             elsif (BIT_CNT ="111" and BAUD_CNT ="1111") then
                                                        state <=stop;
                                                        BAUD_CNT<="0000";
                                                        end if;
               when stop => if (BAUD_CNT <"1111") then 
                                               BAUD_CNT <= BAUD_CNT + 1;
                                               state <= stop;
                            elsif (BAUD_CNT ="1111") then
                                               state <= waits;
                                               BAUD_CNT<="0000";
                            end if;
               when waits => if (BAUD_CNT <"0111") then
                                                 BAUD_CNT <= BAUD_CNT + 1;
                                                 state <= waits;
                            elsif(BAUD_CNT ="0111") then
                                                 state <=idle;
                                                 end if;
               when others => state <= idle;
               end case;
          end if;
          end if;
 end process;
         


end Behavioral;

