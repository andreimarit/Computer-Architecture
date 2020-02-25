library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           RX: in STD_LOGIC;
           TX: out STD_LOGIC);
end test_env;

architecture Behavioral of test_env is
--------------------------------------COMPONENTS--------------------------------
component mpgnew 
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component ;

component ssdisplay 
    Port ( d0 : in STD_LOGIC_VECTOR (3 downto 0);
           d1 : in STD_LOGIC_VECTOR (3 downto 0);
           d2 : in STD_LOGIC_VECTOR (3 downto 0);
           d3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           reset: in STD_LOGIC);
end component;

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

component IFF is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           j_address : in STD_LOGIC_VECTOR(15 downto 0);
           br_address : in STD_LOGIC_VECTOR(15 downto 0);
           j_select : in STD_LOGIC;
           br_select : in STD_LOGIC;
           PC : out STD_LOGIC_VECTOR(15 downto 0);
           instruction : out STD_LOGIC_VECTOR(15 downto 0));         
end component;

component IDU is
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
end component;

component ControlUnit is
Port( Instr:in std_logic_vector(2 downto 0);
	 RegDst: out std_logic;
	 ExtOp: out std_logic;
	 ALUSrc: out std_logic;
	 Branch: out std_logic;
	 Jump: out std_logic;
	 ALUOp: out std_logic_vector(2 downto 0);
	 MemWrite: out std_logic;
	 MemtoReg: out std_logic;
	 RegWrite: out std_logic);
end component;

component ExecutionUnit is
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
end component;

component MemoryUnit is
	port(
			clk: in std_logic;--
			ALURes : in std_logic_vector(15 downto 0);
			WriteData: in std_logic_vector(15 downto 0);
			MemWrite: in std_logic;			
			MemData:out std_logic_vector(15 downto 0);
			ALURes2 :out std_logic_vector(15 downto 0));
end component;

component FSM is
Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       baud_en : in STD_LOGIC;
       tx_data : in STD_LOGIC_VECTOR(7 downto 0);
       tx_en:in std_logic;
       tx_rdy : out STD_LOGIC;
       tx : out STD_LOGIC);
end component;
--------------------------------------SIGNALS-----------------------------
signal RESET: STD_LOGIC;
signal counter : STD_LOGIC_VECTOR (15 downto 0); --this is the counter
signal en: STD_LOGIC; --when press button
--for Display
signal digits: STD_LOGIC_VECTOR (15 downto 0);
--for ALU
signal sum : STD_LOGIC_VECTOR(15 downto 0);
--IFF
signal IFF_PC_signal : STD_LOGIC_VECTOR(15 downto 0);
signal IFF_instruction_signal: STD_LOGIC_VECTOR(15 downto 0);

signal PC_signal : STD_LOGIC_VECTOR(15 downto 0);
signal instruction_signal: STD_LOGIC_VECTOR(15 downto 0);
--IDU

signal IDU_PC_signal : STD_LOGIC_VECTOR(15 downto 0);
signal IDU_instruction_signal: STD_LOGIC_VECTOR(15 downto 0);

signal WriteAddress_signal : STD_LOGIC_VECTOR (2 downto 0);
signal ExtImm: std_logic_vector(15 downto 0);
signal ReadD1: STD_LOGIC_VECTOR (15 downto 0);
signal ReadD2: STD_LOGIC_VECTOR (15 downto 0);
signal WriteData_signal: STD_LOGIC_VECTOR(15 downto 0);
signal SA: STD_LOGIC;
signal funct: STD_LOGIC_VECTOR(2 downto 0);
SIGNAL RegWrite_signal: STD_LOGIC;

--signal IDU_PC_signal: STD_LOGIC_VECTOR(15 downto 0);
--signal IDU_ReadData1:STD_LOGIC_VECTOR (15 downto 0);
--signal IDU_ReadData2:STD_LOGIC_VECTOR (15 downto 0);
--signal IDU_ExtImm: std_logic_vector(15 downto 0);
--signal IDU_funct:STD_LOGIC_VECTOR(2 downto 0);
--signal IDU_instr_1: std_logic_vector(2 downto 0);
--signal IDU_instr_2: std_logic_vector(2 downto 0);
--CONTROL UNIT SIGNALS
--Instr= instruction_signal
signal RegDst_signal:  std_logic;
signal	 ExtOp_signal:  std_logic;
signal	 ALUSrc_signal: std_logic;
signal	 Branch_signal:  std_logic;
signal	 Jump_signal:  std_logic;
signal	 ALUOp_signal:  std_logic_vector(2 downto 0);
signal	 MemWrite_signal: std_logic;
signal	 MemtoReg_signal:  std_logic;
--RegWrite= RegisterWrite_signal
signal IDU_instr_1: std_logic_vector(2 downto 0);
signal IDU_instr_2: std_logic_vector(2 downto 0);

---------EXECUTION UNIT SIGNALS
signal Branch_address: std_logic_vector(15 downto 0);
signal Jump_address: std_logic_vector(15 downto 0);

signal EXU_PC_signal: STD_LOGIC_VECTOR(15 downto 0);
signal EXU_ReadData1:STD_LOGIC_VECTOR (15 downto 0);
signal EXU_ReadData2:STD_LOGIC_VECTOR (15 downto 0);
signal EXU_ExtImm: std_logic_vector(15 downto 0);
signal EXU_funct:STD_LOGIC_VECTOR(2 downto 0);
signal EXU_instr_1: std_logic_vector(2 downto 0);
signal EXU_instr_2: std_logic_vector(2 downto 0);
signal EXU_SA: STD_LOGIC;
signal EXU_RegDst_signal: std_logic;
signal EXU_ALUSrc_signal: std_logic;
signal EXU_Branch_signal: std_logic;
signal EXU_ALUOp_signal : std_logic_vector(2 downto 0);
signal EXU_MemWrite_signal: std_logic;
signal EXU_MemtoReg_signal: std_logic;
signal EXU_RegWrite_signal: std_logic;

signal ALURes_signal:std_logic_vector(15 downto 0);
signal Zero_Signal: std_logic;
signal	 Branch_Zero:  std_logic;
--------MEMORY SIGNALS------
signal MEM_MemWrite_signal: std_logic;
signal MEM_MemtoReg_signal: std_logic;
signal MEM_RegWrite_signal: std_logic;
signal MEM_Branch_signal: std_logic;
signal MEM_Jump_address: std_logic_vector(15 downto 0);
signal MEM_Zero_Signal: std_logic;
signal MEM_ALURes_signal:std_logic_vector(15 downto 0);
signal MEM_ReadD2: STD_LOGIC_VECTOR (15 downto 0);
signal MemoryData_OUT:std_logic_vector(15 downto 0);
signal ALURes2_signal:std_logic_vector(15 downto 0);
signal MemorytoRegister:std_logic_vector(15 downto 0);
signal MEM_WriteAddress_signal : STD_LOGIC_VECTOR (2 downto 0);
signal MEM_Branch_address: std_logic_vector(15 downto 0);
-------WB SIGNALS--------------
signal WB_MemtoReg_signal: std_logic;
signal WB_RegWrite_signal: std_logic;
signal WB_MemoryData_OUT:std_logic_vector(15 downto 0);
signal WB_ALURes2_signal:std_logic_vector(15 downto 0);
signal WB_WriteAddress_signal : STD_LOGIC_VECTOR (2 downto 0);
-------FSM SIGNALS------
signal fsm_nr:std_logic_vector(13 downto 0);
signal baud_enable:std_logic;
signal tx_en_signal:std_logic;
signal tx_rdy_signal:std_logic;
signal tx_data_signal:std_logic_vector(7 downto 0);
signal en_fsm:std_logic;
signal TX_rdy_OUT : STD_LOGIC;
signal TX_OUT: STD_LOGIC;


begin
--portmaps
M1: mpgnew  port map(btn(0), clk, en);
M2: mpgnew  port map(btn(1), clk, RESET);

display: ssdisplay port map( digits(3 downto 0),digits(7 downto 4),digits(11 downto 8),digits(15 downto 12), clk, cat, an, RESET);

--counter--
   process(clk, en)
begin
    if rising_edge(clk) then
       if en = '1' then
         counter <= counter+1;
         end if;
      end if;
 end process;
 
--MUX for FPGA's MODE
process(sw(7 downto 4))
begin
    case sw(7 downto 4) is
        when "0001" => digits <= IDU_instruction_signal;
        when "0011" => digits <= IDU_PC_signal;
        when "0111" => digits <= Jump_address;
         when "1111" => digits <= EXU_PC_signal;
        -------------------------------
        when "0000" => digits <= IFF_instruction_signal;
        when "0010" => digits <= IFF_PC_signal;
        when "0100" => digits <= ReadD1;
        when "0110" => digits <= ReadD2;
        when "1000" => digits <= ExtImm;
        when "1010" => digits <= ALURes_signal;
        when "1100" => digits <= MemoryData_OUT;
        when "1110" => digits <= MemorytoRegister;--WriteData_signal;
        when others => digits <= X"FFFF";    
        end case;
 end process;
---IFF
IFF_in: IFF port map(en, RESET, Jump_address, MEM_Branch_address, Jump_signal, Branch_Zero, IFF_PC_signal, IFF_instruction_signal);  
--IDU
IDU_in : IDU port map (en, IDU_instruction_signal, MemorytoRegister, RegWrite_signal, WB_WriteAddress_signal, ExtOp_signal , ReadD1, ReadD2, ExtImm, funct, SA);
MCU: ControlUnit port map (IDU_instruction_signal(15 downto 13), RegDst_signal, ExtOp_signal, ALUSrc_signal,Branch_signal,Jump_signal, ALUOp_signal, MemWrite_signal, MemtoReg_signal,RegWrite_signal);
--EXU
EXU : ExecutionUnit port map(EXU_PC_signal,EXU_ReadData1,EXU_ReadData2,EXU_ExtImm,EXU_funct,EXU_SA,EXU_ALUSrc_signal,EXU_ALUOp_signal,Branch_address,ALURes_signal,Zero_Signal);
--MEM
MEM: MemoryUnit port map(en, MEM_ALURES_signal, MEM_ReadD2, MEM_MemWrite_signal, MemoryData_OUT, ALURes2_signal);

Jump_address<=IDU_PC_signal(15 downto 14) & IDU_instruction_signal(12 downto 0) & "0";
Branch_Zero<=MEM_Branch_signal and MEM_Zero_Signal;

with MEM_MemtoReg_signal select MemorytoRegister<=
    WB_MemoryData_OUT when '1',
    WB_ALURes2_signal when '0';

with EXU_RegDst_signal select WriteAddress_signal<=
    EXU_instr_1 when '0',
    EXU_instr_2 when '1';

IDU_instr_1<=IDU_instruction_signal(9 downto 7);
IDU_instr_2<=IDU_instruction_signal(6 downto 4);

--MUX FOR LEDS
process(RegDst_signal,ExtOp_signal,ALUSrc_signal,Branch_signal,Jump_signal,MemWrite_signal,MemtoReg_signal,RegWrite_signal,sw,ALUOp_signal)
begin
	if sw(0)='0' then		
		led(7)<=RegDst_signal;
		led(6)<=ExtOp_signal;
		led(5)<=ALUSrc_signal;
		led(4)<=Branch_signal;
		led(3)<=Jump_signal;
		led(2)<=MemWrite_signal;
		led(1)<=MemtoReg_signal;
		led(0)<=RegWrite_signal;		
	else
		led(2 downto 0)<=ALUOp_signal(2 downto 0);
		led(7 downto 3)<="00000";
	end if;
end process;	

--IFF_IDU: 
process (clk, en)
begin
if rising_edge(clk) then
    if en = '1' then
        IDU_PC_signal<=IFF_PC_signal;
        IDU_instruction_signal<=IFF_instruction_signal;
    end if;
end if;
end process; 

--IDU_EXU: 
process (en)
begin
if rising_edge(clk) then
if en = '1' then
EXU_PC_signal<=IDU_PC_signal;
EXU_ReadData1<=ReadD1;
EXU_ReadData2<=ReadD2;
EXU_ExtImm<=ExtImm;
EXU_funct<=funct;
EXU_instr_1<=IDU_instr_1;
EXU_instr_2<=IDU_instr_2;
EXU_SA<=SA;
EXU_RegDst_signal<=RegDst_signal;
EXU_ALUSrc_signal<=ALUSrc_signal;
EXU_Branch_signal<=Branch_signal;
EXU_ALUOp_signal<= ALUOp_signal; 
EXU_MemWrite_signal<=MemWrite_signal;
EXU_MemtoReg_signal<=MemtoReg_signal;
EXU_RegWrite_signal<=RegWrite_signal;
end if;
end if;
end process;

--EXU_MEM: 
process (en)
begin
if rising_edge(clk) then
if en = '1' then
MEM_MemWrite_signal<=EXU_MemWrite_signal;
MEM_Branch_signal<=EXU_Branch_signal;
MEM_RegWrite_signal<=EXU_RegWrite_signal;
MEM_MemtoReg_signal<=EXU_MemtoReg_signal;
MEM_Branch_address<=Branch_address;
MEM_Zero_Signal<=Zero_Signal;
MEM_ReadD2<=EXU_ReadData2;
MEM_ALURes_signal<=ALURes_signal;
MEM_WriteAddress_signal<=WriteAddress_signal;
end if;
end if;
end process;

--MEM_WB: 
process (en)
begin
if rising_edge(clk) then 
if en = '1' then
WB_RegWrite_signal<=MEM_RegWrite_signal;
WB_MemtoReg_signal<=MEM_MemtoReg_signal;
WB_MemoryData_OUT<=MemoryData_OUT;
WB_ALURes2_signal<=ALURes2_signal;
WB_WriteAddress_signal<=MEM_WriteAddress_signal;
end if;
end if;
end process;

------------------------FSM----------
M3: mpgnew  port map(btn(2), clk, en_fsm);
FSM_port: FSM port map(clk,RESET,baud_enable,tx_data_signal,tx_en_signal,TX_rdy_OUT,TX_OUT);

tx_data_signal<= sw(15 downto 8);
process(clk)
begin
if rising_edge(clk) then
    if fsm_nr="10100010110000" --10416=28B0
       then baud_enable<='1';
            fsm_nr<="00000000000000";
       else 
       baud_enable<='0';
       fsm_nr<=fsm_nr+1;
       end if;
       end if;
end process;

process(clk, baud_enable, en_fsm)
begin

       if rising_edge(clk) then
            if en_fsm='1' then tx_en_signal<='1'; 
            end if;
            if baud_enable='1' then 
            tx_en_signal<='0';
            end if;
       end if;
end process;

end Behavioral;