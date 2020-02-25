----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2019 03:08:41 AM
-- Design Name: 
-- Module Name: EXU - Behavioral
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

entity ExecutionUnit is
Port(
	PC:in std_logic_vector(15 downto 0);
	RD1: in std_logic_vector(15 downto 0);
	RD2: in std_logic_vector(15 downto 0);
	Ext_Imm: in std_logic_vector(15 downto 0);
	func: in std_logic_vector(2 downto 0);
	sa: in std_logic;
	ALUSrc: in std_logic;
	ALUOp: in std_logic_vector(2 downto 0);
	BranchAddress: out std_logic_vector(15 downto 0);
	ALURes: out std_logic_vector(15 downto 0);
	ZeroSignal: out std_logic);
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is

signal ALU_temp:std_logic_vector(15 downto 0);
signal ALU_signal: std_logic_vector(3 downto 0);
signal ALUResAux:std_logic_vector(15 downto 0);
signal extimm_signal: std_logic_vector(15 downto 0);
begin

--branchaddress
BranchAddress<=PC+Ext_Imm;--<=PC+extimm_signal
extimm_signal<=Ext_Imm(13 downto 0)&"00";


with ALUSrc select ALU_temp<=
    RD2 when '0',
	Ext_Imm when others;

process(ALUOp,func)
begin
	case (ALUOp) is
		when "000"=>
				case (Func) is
					when "000"=> ALU_signal<="0000"; 	    -----ADD-----
					when "001"=> ALU_signal<="0001";		-----SUB-----
					when "010"=> ALU_signal<="0010";		-----SLL-----
					when "011"=> ALU_signal<="0011";		-----SRL-----
					when "100"=> ALU_signal<="0100";		-----AND-----
					when "101"=> ALU_signal<="0101";		-----OR-----
					when "110"=> ALU_signal<="0110";		-----XOR-----
					when "111"=> ALU_signal<="0111";		-----SetOnLessThan-----
					when others=> ALU_signal<="0000";	-----OTHERS-----
				end case;
		when "001"=> ALU_signal<="0000";		-----ADDI-----LW---SW
		
		when "100"=> ALU_signal<="0001";		-----BEQ-----!!!!!!!!!!!!!!!!!!!!!!!!
		when "101"=> ALU_signal<="0100";		-----ANDI-----
		when "110"=> ALU_signal<="0101";		-----ORI-----
		when "111"=> ALU_signal<="1000";		-----JUMP-----
		when others=> ALU_signal<="0000";	
	end case;
end process;

process(ALU_signal,RD1,ALU_temp,SA)
begin
	case(ALU_signal) is
		when "0000" => ALUResAux<=RD1+ALU_temp;   -----ADD-----LW----SW
					
		when "0001" => ALUResAux<=RD1-ALU_temp;	  -----SUB-----
								
		when "0010" => 				-----SLL-----
					case (SA) is
						when '1' => ALUResAux<=RD1(14 downto 0) & "0";
						when others => ALUResAux<=RD1;	
					end case;
								
		when "0011" => 				-----SRL-----
					case (SA) is
						when '1' => ALUResAux<="0" & RD1(15 downto 1);
						when others => ALUResAux<=RD1;
					end case;
								
		when "0100" => ALUResAux<=RD1 and ALU_temp;		-----AND-----
								
		when "0101" => ALUResAux<=RD1 or ALU_temp;		-----OR-----
										
		when "0110" => ALUResAux<=RD1 xor ALU_temp;		-----XOR-----
							
		when "0111" =>   -----SET ON LESS THAN-----
					if RD1<ALU_temp then
						ALUResAux<=X"0001";
					else ALUResAux<=X"0000";
					end if;			
		when "1000" => ALUResAux<=X"0000";		-----JUMP-----
					
		when others => ALUResAUx<=X"0000";		-----OTHERS-----
	end case;
end process;
if (AluResAux=X"0000") then zeroSignal<='1';
else zeroSignal<='0';
process(ALUResAux)
begin
	case (ALUResAux) is					-----ZERO SIGNAL-----
		when X"0000" => ZeroSignal<='1';
		when others => ZeroSignal<='0';
	end case;
end process;


ALURes<=ALUResAux;			-----ALU_OUT-----


end Behavioral;

