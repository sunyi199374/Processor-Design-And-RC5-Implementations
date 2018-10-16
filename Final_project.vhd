----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:05:44 12/05/2016 
-- Design Name: 
-- Module Name:    Final_project - Behavioral 
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Final_project is
   PORT(
      clr, clk	: IN     STD_LOGIC;
      enc_botton : IN     STD_LOGIC;  -- Encryption or decryption?
		in_switch: in STD_LOGIC_VECTOR(15 DOWNTO 0);
      data_vld_botton: IN     STD_LOGIC; 
      key_vld_botton:  IN     STD_LOGIC;
      dout_botton:  IN     STD_LOGIC; 
      work_botton: IN     STD_LOGIC;		
		enc_indicate: out STD_LOGIC_VECTOR(1 DOWNTO 0);
      led_indicate: out STD_LOGIC_VECTOR(3 DOWNTO 0);
		led_an: out STD_LOGIC_VECTOR(7 DOWNTO 0);
		led_segment: out STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
end Final_project;

architecture Behavioral of Final_project is

	COMPONENT final_inout is
		PORT(
      clr	: IN     STD_LOGIC;
      clk_slow	: in STD_LOGIC;
		in_switch: in STD_LOGIC_VECTOR(15 DOWNTO 0);
		key_vld_botton:  IN     STD_LOGIC;
      data_vld_botton: IN     STD_LOGIC; 
		work_botton: IN     STD_LOGIC; 
      dout_botton:  IN     STD_LOGIC;	
      enc_botton : IN     STD_LOGIC;		
		dout	  : in     STD_LOGIC_VECTOR(63 downto 0);
		enc : out     STD_LOGIC;
		work : out     STD_LOGIC;	
      di_vld  :  out     STD_LOGIC;	
      ukey	  : out     STD_LOGIC_VECTOR(127 DOWNTO 0);
	   din	  : out     STD_LOGIC_VECTOR(63 downto 0);		
      led_indicate: out STD_LOGIC_VECTOR(3 DOWNTO 0);
		enc_indicate: out STD_LOGIC_VECTOR(1 DOWNTO 0);
		led_an: out STD_LOGIC_VECTOR(7 DOWNTO 0);
		led_segment: out STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
			
	end COMPONENT;
	
	COMPONENT Processor is
    port(
					clr: in std_logic;
					clk_slow: in std_logic;

					di_vld: in std_logic;
					din: in std_logic_vector(63 downto 0);	
					ukey: in std_logic_vector(127 downto 0);
					
					dout_enc: out std_logic_vector(63 downto 0);
					dout_dec: out std_logic_vector(63 downto 0)
			);
	end COMPONENT;
	
	COMPONENT Processor2 is
    port(
					clr: in std_logic;
					
					work: in std_logic;
               di_vld: in std_logic;
					din: in std_logic_vector(63 downto 0);	
					ukey: in std_logic_vector(127 downto 0);
					
					dout_step: out std_logic_vector(31 DOWNTO 0)
			);
	end COMPONENT;
	
	signal clk_slow: std_logic;
	signal clk_count : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal ukey	  : STD_LOGIC_VECTOR(127 DOWNTO 0);
	signal din	  : STD_LOGIC_VECTOR(63 downto 0);
   signal dout	  : STD_LOGIC_VECTOR(63 downto 0);
	signal di_vld : STD_LOGIC;
	signal enc: STD_LOGIC;
	signal work: STD_LOGIC;
	signal sel: STD_LOGIC;
	
	signal dout_enc: std_logic_vector(63 downto 0);
	signal dout_dec: std_logic_vector(63 downto 0);
	signal dout_step: std_logic_vector(31 downto 0);


begin

   U0: final_inout      PORT MAP(clr=>clr, clk_slow=>clk_slow, in_switch=>in_switch, led_an=>led_an, led_segment=>led_segment,
	                             key_vld_botton=>key_vld_botton, data_vld_botton=>data_vld_botton, work_botton=>work_botton,
										  work=>work,
						             dout_botton=>dout_botton, enc=>enc, enc_botton=>enc_botton, enc_indicate=>enc_indicate,
                               led_indicate=>led_indicate, di_vld=>di_vld, ukey=>ukey, din=>din, dout=>dout);
   U1: Processor        PORT MAP(clr=>clr, clk_slow=>clk_slow, di_vld=>di_vld, 
	                                ukey=>ukey, din=>din,dout_enc=>dout_enc,dout_dec=>dout_dec);
	U2: Processor2        PORT MAP(work=>work, clr=>clr, di_vld=>di_vld, ukey=>ukey, din=>din,dout_step=>dout_step);


	process(clk,clr)
	begin
	  	if (clr='0') then
		  clk_count<= (OTHERS=>'0');
		  clk_slow<='0';
		  else IF (clk'EVENT AND clk='1') THEN
         if (clk_count ="11111111") then
				clk_count <="00000000";
				clk_slow <=not clk_slow;
			else clk_count <= clk_count+'1';
			end if;
		end if; 	
	  end if;
	end process;
	sel<=in_switch(15); 
	process(clk,clr)
	begin
	  IF (clk'EVENT AND clk='1') THEN
         if (sel='1') then
			dout<=dout_step&dout_step;
			else if(enc='0') then dout<=dout_dec;
			     else dout<=dout_enc;
		        end if; 	
	      end if;
		end if;
	end process;


end Behavioral;

