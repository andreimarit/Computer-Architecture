library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IDU is
  Port ( clk: in STD_LOGIC;
         instruction : in STD_LOGIC_VECTOR(15 downto 0);
         WriteData: in STD_LOGIC_VECTOR(15 downto 0);
         RegWrite : in STD_LOGIC;
         --RegDst: in STD_LOGIC;
         WriteAddress : in STD_LOGIC_VECTOR (2 downto 0);
         ExtOp: in STD_LOGIC;
         ReadD1: out STD_LOGIC_VECTOR (15 downto 0);
         ReadD2: out STD_LOGIC_VECTOR (15 downto 0);
         Ext_Imm: out STD_LOGIC_VECTOR (15 downto 0);
         Funct: out STD_LOGIC_VECTOR (2 downto 0);
         SA: out STD_LOGIC);
end IDU;

architecture Behavioral of IDU is

component RegisterFile is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           regWr : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;
--------------------------------SIGNALS-----------------------------------------
--signal WriteAddress: STD_LOGIC_VECTOR (2 downto 0);
--signal ReadAddress1: std_logic_vector(2 downto 0);
--signal ReadAddress2: std_logic_vector(2 downto 0);
signal ExtImm: std_logic_vector(15 downto 0);
begin
--with RegDst select WriteAddress<=
--    instruction(9 downto 7) when '0',
--    instruction(6 downto 4) when '1';
Funct <= instruction(2 downto 0);
SA<=instruction(3);
Ext_Imm<=ExtImm;

process(ExtOp,Instruction)   
begin
	case (ExtOp) is
		when '1' => 	
				case (Instruction(6)) is
					when '0' => ExtImm <= B"000000000" & Instruction(6 downto 0);
					when '1' =>  ExtImm <=	B"111111111" & Instruction(6 downto 0);
					when others => ExtImm <= ExtImm;
				end case;
		when others => ExtImm <= B"000000000" & Instruction(6 downto 0);
	end case;
end process;

REG_F_PORTING: RegisterFile port map (instruction(12 downto 10), instruction(9 downto 7), WriteAddress, WriteData, clk,RegWrite, ReadD1, ReadD2);

end Behavioral;
