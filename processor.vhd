----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:59:46 12/01/2016 
-- Design Name: 
-- Module Name:    Processor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

PACKAGE processor_pkg IS
	TYPE ROM IS ARRAY (0 TO 131) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	TYPE RAM IS ARRAY (0 TO 36) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
END processor_pkg;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.processor_pkg.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity processor is
port(
	clr: in std_logic;
	clk_slow: in std_logic;

	di_vld: in std_logic;
	din: in std_logic_vector(63 downto 0);	
	ukey: in std_logic_vector(127 downto 0);
	
	dout_enc: out std_logic_vector(63 downto 0);
	dout_dec: out std_logic_vector(63 downto 0)
);
end processor;

architecture Behavioral of processor is
   
function ALUOperation(	
	op_code: std_logic_vector(2 downto 0);
	oprand1: std_logic_vector(31 downto 0);
	oprand2: std_logic_vector(31 downto 0))
return std_logic_vector is 

variable ALUResult: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	
begin
case op_code is
	when "000"=> ALUResult := oprand1 + oprand2;   	-- add/addi
	when "001"=> ALUResult := oprand1 - oprand2;   	-- sub/subi
	when "010"=> ALUResult := oprand1 and oprand2; 	-- and/andi
	when "011"=> ALUResult := oprand1 or oprand2;  	-- or/ori
	when "100"=> ALUResult := oprand1 nor oprand2;  -- nor 
	when "101"=> 
		case oprand2(4 downto 0) is
			when "00001" => ALUResult := oprand1(30 downto 0) & '0';
			when "00010" => ALUResult := oprand1(29 downto 0) & "00";
			when "00011" => ALUResult := oprand1(28 downto 0) & "000";
			when "00100" => ALUResult := oprand1(27 downto 0) & "0000";
			when "00101" => ALUResult := oprand1(26 downto 0) & "00000";
			when "00110" => ALUResult := oprand1(25 downto 0) & "000000";
			when "00111" => ALUResult := oprand1(24 downto 0) & "0000000";
			when "01000" => ALUResult := oprand1(23 downto 0) & "00000000";
			when "01001" => ALUResult := oprand1(22 downto 0) & "000000000";
			when "01010" => ALUResult := oprand1(21 downto 0) & "0000000000";
			when "01011" => ALUResult := oprand1(20 downto 0) & "00000000000";
			when "01100" => ALUResult := oprand1(19 downto 0) & "000000000000";
			when "01101" => ALUResult := oprand1(18 downto 0) & "0000000000000";
			when "01110" => ALUResult := oprand1(17 downto 0) & "00000000000000";
			when "01111" => ALUResult := oprand1(16 downto 0) & "000000000000000";
			when "10000" => ALUResult := oprand1(15 downto 0) & "0000000000000000";
			when "10001" => ALUResult := oprand1(14 downto 0) & "00000000000000000";
			when "10010" => ALUResult := oprand1(13 downto 0) & "000000000000000000";
			when "10011" => ALUResult := oprand1(12 downto 0) & "0000000000000000000";
			when "10100" => ALUResult := oprand1(11 downto 0) & "00000000000000000000";
			when "10101" => ALUResult := oprand1(10 downto 0) & "000000000000000000000";
			when "10110" => ALUResult := oprand1(9 downto 0) & "0000000000000000000000";
			when "10111" => ALUResult := oprand1(8 downto 0) & "00000000000000000000000";
			when "11000" => ALUResult := oprand1(7 downto 0) & "000000000000000000000000";
			when "11001" => ALUResult := oprand1(6 downto 0) & "0000000000000000000000000";
			when "11010" => ALUResult := oprand1(5 downto 0) & "00000000000000000000000000";
			when "11011" => ALUResult := oprand1(4 downto 0) & "000000000000000000000000000";
			when "11100" => ALUResult := oprand1(3 downto 0) & "0000000000000000000000000000";
			when "11101" => ALUResult := oprand1(2 downto 0) & "00000000000000000000000000000";
			when "11110" => ALUResult := oprand1(1 downto 0) & "000000000000000000000000000000";
			when "11111" => ALUResult := oprand1(0) & "0000000000000000000000000000000";
			when others => ALUResult := oprand1;
		end case;-- shift left
	when "110"=> 
		case oprand2(4 downto 0) is
			when "00001" => ALUResult := '0' & oprand1(31 downto 1);
			when "00010" => ALUResult := "00" & oprand1(31 downto 2);
			when "00011" => ALUResult := "000" & oprand1(31 downto 3);
			when "00100" => ALUResult := "0000" & oprand1(31 downto 4);
			when "00101" => ALUResult := "00000" & oprand1(31 downto 5);
			when "00110" => ALUResult := "000000" & oprand1(31 downto 6);
			when "00111" => ALUResult := "0000000" & oprand1(31 downto 7);
			when "01000" => ALUResult := "00000000" & oprand1(31 downto 8);
			when "01001" => ALUResult := "000000000" & oprand1(31 downto 9);
			when "01010" => ALUResult := "0000000000" & oprand1(31 downto 10);
			when "01011" => ALUResult := "00000000000" & oprand1(31 downto 11);
			when "01100" => ALUResult := "000000000000" & oprand1(31 downto 12);
			when "01101" => ALUResult := "0000000000000" & oprand1(31 downto 13);
			when "01110" => ALUResult := "00000000000000" & oprand1(31 downto 14);
			when "01111" => ALUResult := "000000000000000" & oprand1(31 downto 15);
			when "10000" => ALUResult := "0000000000000000" & oprand1(31 downto 16);
			when "10001" => ALUResult := "00000000000000000" & oprand1(31 downto 17);
			when "10010" => ALUResult := "000000000000000000" & oprand1(31 downto 18);
			when "10011" => ALUResult := "0000000000000000000" & oprand1(31 downto 19);
			when "10100" => ALUResult := "00000000000000000000" & oprand1(31 downto 20);
			when "10101" => ALUResult := "000000000000000000000" & oprand1(31 downto 21);
			when "10110" => ALUResult := "0000000000000000000000" & oprand1(31 downto 22);
			when "10111" => ALUResult := "00000000000000000000000" & oprand1(31 downto 23);
			when "11000" => ALUResult := "000000000000000000000000" & oprand1(31 downto 24);
			when "11001" => ALUResult := "0000000000000000000000000" & oprand1(31 downto 25);
			when "11010" => ALUResult := "00000000000000000000000000" & oprand1(31 downto 26);
			when "11011" => ALUResult := "000000000000000000000000000" & oprand1(31 downto 27);
			when "11100" => ALUResult := "0000000000000000000000000000" & oprand1(31 downto 28);
			when "11101" => ALUResult := "00000000000000000000000000000" & oprand1(31 downto 29);
			when "11110" => ALUResult := "000000000000000000000000000000" & oprand1(31 downto 30);
			when "11111" => ALUResult := "0000000000000000000000000000000" & oprand1(31);
			when others => ALUResult := oprand1;
		end case;  -- shift right
	when others=> ALUResult := "00000000000000000000000000000000";
end case;
return ALUResult;
end ALUOperation;

signal RF_Ram: RAM;
signal Mem_Ram: RAM;
CONSTANT InsMemory: ROM := (
	"00000000000000000101000000010000",
	"00000000000000000100000000010000",
	"00000000000000000100100000010000",
	"00000000000000000000100000010000",
	"00000000000000000001000000010000",
	"00000100000100010000000001001110",
	"00000100000100100000000000011010",
	"00000100000100110000000000000100",
	"00011101000010110000000000000110",
	"00000001011000010101100000010000",
	"00000001011000100001100000010000",
	"00010100011011010000000000000011",
	"00011000011011100000000000011101",
	"00000001101011100010000000010000",
	"00000000100000100010100000010000",
	"00011101001011000000000000000010",
	"00000001100001010011000000010000",
	"00001100101011100000000000011111",
	"00000000000000000110100000010000",
	"00000000000001100011100000010000",
	"00101001101011100000000000000101",
	"00010100111011110000000000000001",
	"00011000111100000000000000011111",
	"00000001111100000011100000010000",
	"00000101101011010000000000000001",
	"00110000000000000000000000010100",
	"00100001000001000000000000000110",
	"00100001001001110000000000000010",
	"00000000000001000000100000010000",
	"00000000000001110001000000010000",
	"00000101000010000000000000000001",
	"00000101001010010000000000000001",
	"00000101010010100000000000000001",
	"00101101000100100000000000000001",
	"00000000000000000100000000010000",
	"00101101001100110000000000000001",
	"00000000000000000100100000010000",
	"00101001010100010000000000000001",
	"00110000000000000000000000001000",
	"00011100000000010000000000000000",
	"00011100000000100000000000000001",
	"00000000000000000001100000010000",
	"00000100000111100000000000011010",
	"00000000000000000010000000010000",
	"00000000000000000010100000010000",
	"00011100011111110000000000000110",
	"00000000001111110010000000010000",
	"00011100011111110000000000000111",
	"00000000010111110010100000010000",
	"00000100011000110000000000000010",
	"00000000100000000011000000010100",
	"00000000101000000011100000010100",
	"00000000100001110011100000010010",
	"00000000101001100011000000010010",
	"00000000110001110100000000010000",
	"00001100101001110000000000011111",
	"00000000000000000011000000010000",
	"00000000000010000100100000010000",
	"00101000110001110000000000000101",
	"00010101001010100000000000000001",
	"00011001001010110000000000011111",
	"00000001010010110100100000010000",
	"00000100110001100000000000000001",
	"00110000000000000000000000111010",
	"00011100011111110000000000000110",
	"00000001001111110010000000010000",
	"00000000100000000011000000010100",
	"00000000101000000011100000010100",
	"00000000100001110011100000010010",
	"00000000101001100011000000010010",
	"00000000110001110110000000010000",
	"00001100100001110000000000011111",
	"00000000000000000011000000010000",
	"00000000000011000110100000010000",
	"00101000110001110000000000000101",
	"00010101101010100000000000000001",
	"00011001101010110000000000011111",
	"00000001010010110110100000010000",
	"00000100110001100000000000000001",
	"00110000000000000000000001001010",
	"00011100011111110000000000000111",
	"00000001101111110010100000010000",
	"00000100011000110000000000000010",
	"00101000011111100000000000000001",
	"00110000000000000000000000110010",
	"00100000000001000000000000100000",
	"00100000000001010000000000100001",
	"00011100000001000000000000000000",
	"00011100000001010000000000000001",
	"00000100000000110000000000011000",
	"00011100011010000000000000000111",
	"00000000101010000011100000010001",
	"00001100100010010000000000011111",
	"00000000000000000100000000010000",
	"00000000000001110101100000010000",
	"00101001000010010000000000000101",
	"00011001011011000000000000000001",
	"00010101011011010000000000011111",
	"00000001100011010101100000010000",
	"00000101000010000000000000000001",
	"00110000000000000000000001011111",
	"00000000100000000100000000010100",
	"00000001011000000100100000010100",
	"00000000100010010100100000010010",
	"00000001000010110100000000010010",
	"00000001000010010010100000010000",
	"00011100011010000000000000000110",
	"00000000100010000011000000010001",
	"00001100101010010000000000011111",
	"00000000000000000100000000010000",
	"00000000000001100101000000010000",
	"00101001000010010000000000000101",
	"00011001010011000000000000000001",
	"00010101010011010000000000011111",
	"00000001100011010101000000010000",
	"00000101000010000000000000000001",
	"00110000000000000000000001101111",
	"00000001010000000100000000010100",
	"00000000101000000100100000010100",
	"00000001010010010100100000010010",
	"00000000101010000100000000010010",
	"00000001000010010010000000010000",
	"00001000011000110000000000000010",
	"00101000011000000000000000000001",
	"00110000000000000000000001011010",
	"00011100011010000000000000000111",
	"00000000101010000010100000010001",
	"00011100011010000000000000000110",
	"00000000100010000010000000010001",
	"00100000000001000000000000100010",
	"00100000000001010000000000100011",
	"11111111111111111111111111111111");

signal ReadAddress: STD_LOGIC_VECTOR(31 DOWNTO 0);	--INSMem parameters

begin
	
process(clr, clk_slow)

variable RdReg1: STD_LOGIC_VECTOR(4 DOWNTO 0);--RF parameters 
variable RdReg2: STD_LOGIC_VECTOR(4 DOWNTO 0);
variable WrtReg: STD_LOGIC_VECTOR(4 DOWNTO 0);

variable ALUOP: STD_LOGIC_VECTOR(2 DOWNTO 0);--ALU parameters
variable oprand1: STD_LOGIC_VECTOR(31 DOWNTO 0);
variable oprand2: STD_LOGIC_VECTOR(31 DOWNTO 0);
variable opcode: STD_LOGIC_VECTOR(5 DOWNTO 0);
variable func: STD_LOGIC_VECTOR(5 DOWNTO 0);

--signal ReadAddress: STD_LOGIC_VECTOR(31 DOWNTO 0);	--INSMem parameters
variable Instruction: STD_LOGIC_VECTOR(31 DOWNTO 0);

variable Address: STD_LOGIC_VECTOR(31 DOWNTO 0);	--DataMem parameters

variable imm: STD_LOGIC_VECTOR(15 DOWNTO 0);
variable se_imm: STD_LOGIC_VECTOR(31 DOWNTO 0);
variable JumpAddr: STD_LOGIC_VECTOR(31 DOWNTO 0);

begin 	
if (clr = '0') then
	ReadAddress <= (OTHERS=>'0');
	RF_Ram(0) <= (OTHERS=>'0');
	Mem_Ram(36)<= (OTHERS=>'0');
	Mem_Ram(6)<="10110111111000010101000101100011";
	Mem_Ram(7)<="01010110000110001100101100011100";
	Mem_Ram(8)<="11110100010100000100010011010101";
	Mem_Ram(9)<="10010010100001111011111010001110";
	Mem_Ram(10)<="00110000101111110011100001000111";
	Mem_Ram(11)<="11001110111101101011001000000000";
	Mem_Ram(12)<="01101101001011100010101110111001";
	Mem_Ram(13)<="00001011011001011010010101110010";
	Mem_Ram(14)<="10101001100111010001111100101011";
	Mem_Ram(15)<="01000111110101001001100011100100";
	Mem_Ram(16)<="11100110000011000001001010011101";
	Mem_Ram(17)<="10000100010000111000110001010110";
	Mem_Ram(18)<="00100010011110110000011000001111";
	Mem_Ram(19)<="11000000101100100111111111001000";
	Mem_Ram(20)<="01011110111010011111100110000001";
	Mem_Ram(21)<="11111101001000010111001100111010";
	Mem_Ram(22)<="10011011010110001110110011110011";
	Mem_Ram(23)<="00111001100100000110011010101100";
	Mem_Ram(24)<="11010111110001111110000001100101";
	Mem_Ram(25)<="01110101111111110101101000011110";
	Mem_Ram(26)<="00010100001101101101001111010111";
	Mem_Ram(27)<="10110010011011100100110110010000";
	Mem_Ram(28)<="01010000101001011100011101001001";
	Mem_Ram(29)<="11101110110111010100000100000010";
	Mem_Ram(30)<="10001101000101001011101010111011";      
	Mem_Ram(31)<="00101011010011000011010001110100";
	
else 
   if(clk_slow'EVENT AND clk_slow = '1') then	 
	if(di_vld = '0') then
		Mem_Ram(0) <= din(63 DOWNTO 32);
		Mem_Ram(1) <= din(31 DOWNTO 0);
		Mem_Ram(2) <= ukey(31 DOWNTO 0);
		Mem_Ram(3) <= ukey(63 DOWNTO 32);
		Mem_Ram(4) <= ukey(95 DOWNTO 64);
		Mem_Ram(5) <= ukey(127 DOWNTO 96);
	else
		Instruction(31 DOWNTO 0) := InsMemory(CONV_INTEGER(ReadAddress));
		
			if (Instruction(31 DOWNTO 26) /= "111111") then
				opcode(5 DOWNTO 0) := Instruction(31 DOWNTO 26);
				RdReg1(4 DOWNTO 0) := Instruction(25 DOWNTO 21);
				RdReg2(4 DOWNTO 0) := Instruction(20 DOWNTO 16);
				WrtReg(4 DOWNTO 0) := Instruction(15 DOWNTO 11);
				func(5 DOWNTO 0) := Instruction(5 DOWNTO 0);
				imm(15 DOWNTO 0) := Instruction(15 DOWNTO 0);			
				JumpAddr := ReadAddress + '1';
			
				if (imm(15) = '0') then
					se_imm := "0000000000000000" & imm(15 DOWNTO 0);
				else
					se_imm := "1111111111111111" & imm(15 DOWNTO 0);			
				end if;
				
				case opcode(5 downto 0) is 		
					when "000000" =>
						case func(5 downto 0) is 
							when "010000" => ALUOP(2 DOWNTO 0) := "000";-- add
							when "010001" => ALUOP(2 DOWNTO 0) := "001";-- sub
							when "010010" => ALUOP(2 DOWNTO 0) := "010";-- and
							when "010011" => ALUOP(2 DOWNTO 0) := "011";-- or
							when "010100" => ALUOP(2 DOWNTO 0) := "100";-- nor
							when others => null;
						end case;
						
						oprand1(31 DOWNTO 0) := RF_Ram(CONV_INTEGER(RdReg1));
						oprand2(31 DOWNTO 0) := RF_Ram(CONV_INTEGER(RdReg2));
						RF_Ram(CONV_INTEGER(WrtReg)) <= ALUOperation(ALUOP,oprand1,oprand2);
						ReadAddress <= ReadAddress + '1';
						
					when "000001" =>	--Add Imm R[rt] = R[rs] + SignExtImm
						oprand1(31 DOWNTO 0) := RF_Ram(CONV_INTEGER(RdReg1));
						oprand2(31 DOWNTO 0) := se_imm(31 DOWNTO 0);
						ALUOP(2 DOWNTO 0) := "000";
						RF_Ram(CONV_INTEGER(RdReg2)) <= ALUOperation(ALUOP,oprand1,oprand2);
						ReadAddress <= ReadAddress+ '1';
					
					when "000010" =>	--Sub Imm. Unsighed R[rt] = R[rs] + SignExtImm
						oprand1(31 DOWNTO 0) := RF_Ram(CONV_INTEGER(RdReg1));
						oprand2(31 DOWNTO 0) := se_imm(31 DOWNTO 0);
						ALUOP(2 DOWNTO 0) := "001";
						RF_Ram(CONV_INTEGER(RdReg2)) <= ALUOperation(ALUOP,oprand1,oprand2);
						ReadAddress <= ReadAddress + '1';
						
					when "000011" =>	--AND Imm. Unsighed R[rt] = R[rs] + SignExtImm
						oprand1(31 DOWNTO 0) := RF_Ram(CONV_INTEGER(RdReg1));
						oprand2(31 DOWNTO 0) := se_imm(31 DOWNTO 0);
						ALUOP(2 DOWNTO 0) := "010";
						RF_Ram(CONV_INTEGER(RdReg2)) <= ALUOperation(ALUOP,oprand1,oprand2);
						ReadAddress <= ReadAddress + '1';
					
					when "000100" => --OR Imm. Unsighed R[rt] = R[rs] + SignExtImm
						oprand1(31 DOWNTO 0) := RF_Ram(CONV_INTEGER(RdReg1));
						oprand2(31 DOWNTO 0) := se_imm(31 DOWNTO 0);
						ALUOP(2 DOWNTO 0) := "011";
						RF_Ram(CONV_INTEGER(RdReg2)) <= ALUOperation(ALUOP,oprand1,oprand2);
						ReadAddress <= ReadAddress + '1';
					
					when "000101" => --Shift left by immediate bits
						oprand1(31 DOWNTO 0) := RF_Ram(CONV_INTEGER(RdReg1));
						oprand2(31 DOWNTO 0) := se_imm(31 DOWNTO 0);
						ALUOP(2 DOWNTO 0) := "101";
						RF_Ram(CONV_INTEGER(RdReg2)) <= ALUOperation(ALUOP,oprand1,oprand2);
						ReadAddress <= ReadAddress + '1';
					
					when "000110" => --Shift right by immediate bits
						oprand1(31 DOWNTO 0) := RF_Ram(CONV_INTEGER(RdReg1));
						oprand2(31 DOWNTO 0) := se_imm(31 DOWNTO 0);
						ALUOP(2 DOWNTO 0) := "110";
						RF_Ram(CONV_INTEGER(RdReg2)) <= ALUOperation(ALUOP,oprand1,oprand2);
						ReadAddress <= ReadAddress + '1';
					
					when "000111" =>	--Load Word R[rt] = M[R[rs]+SignExtImm]
						oprand1(31 DOWNTO 0) := RF_Ram(CONV_INTEGER(RdReg1));
						oprand2(31 DOWNTO 0) := se_imm(31 DOWNTO 0);
						ALUOP(2 DOWNTO 0) := "000";
						Address(31 DOWNTO 0) := ALUOperation(ALUOP,oprand1,oprand2);
						RF_Ram(CONV_INTEGER(RdReg2)) <= Mem_Ram(CONV_INTEGER(Address));
						ReadAddress <= ReadAddress + '1';

					when "001000" =>	--Store Word M[R[rs]+SignExtImm] = R[rt]
						oprand1(31 DOWNTO 0) := RF_Ram(CONV_INTEGER(RdReg1));
						oprand2(31 DOWNTO 0) := se_imm(31 DOWNTO 0);
						ALUOP(2 DOWNTO 0) := "000";
						Address(31 DOWNTO 0) := ALUOperation(ALUOP,oprand1,oprand2);
						Mem_Ram(CONV_INTEGER(Address)) <= RF_Ram(CONV_INTEGER(RdReg2));
						ReadAddress <= ReadAddress + '1';
					
					when "001001" =>	--Branch if less than if(R[rs]<R[rt]) PC=PC+1+BrachAddr
						if (RF_Ram(CONV_INTEGER(RdReg1))(31) = RF_Ram(CONV_INTEGER(RdReg2))(31)) then--compare MSB
							if (RF_Ram(CONV_INTEGER(RdReg1)) < RF_Ram(CONV_INTEGER(RdReg2))) then
								ReadAddress <= ReadAddress + '1' + se_imm(29 DOWNTO 0);
							end if;	
						elsif (RF_Ram(CONV_INTEGER(RdReg1))(31) = '1') then
							ReadAddress <= ReadAddress + '1' + se_imm(29 DOWNTO 0);
						else
							ReadAddress <= ReadAddress + '1';
						end if;
					
					when "001010" => --Branch On Equal if(R[rs]==R[rt]) PC=PC+1+BrachAddr
						if (RF_Ram(CONV_INTEGER(RdReg1)) = RF_Ram(CONV_INTEGER(RdReg2))) then
							ReadAddress <= ReadAddress + '1' + se_imm(29 DOWNTO 0);
						else
							ReadAddress <= ReadAddress + '1';
						end if;	
					
					when "001011" => --Branch if not equal if(R[rs]!=R[rt]) PC=PC+1+BrachAddr
						if (RF_Ram(CONV_INTEGER(RdReg1)) /= RF_Ram(CONV_INTEGER(RdReg2))) then
							ReadAddress <= ReadAddress + '1' + se_imm(29 DOWNTO 0);
						else
							ReadAddress <= ReadAddress + '1';
						end if;	
					
					when "001100" => --Jump PC = JumpAddr
						ReadAddress(31 DOWNTO 0) <= JumpAddr(31 DOWNTO 26) & Instruction(25 DOWNTO 0);
						
					when others => null;		
				end case;
			end if;
		end if;
	 end if;
	 


end if;	
end process; 

dout_enc(63 DOWNTO 32) <= Mem_Ram(32);
dout_enc(31 DOWNTO 0) <= Mem_Ram(33);
dout_dec(63 DOWNTO 32) <= Mem_Ram(34);
dout_dec(31 DOWNTO 0) <= Mem_Ram(35);


end Behavioral;