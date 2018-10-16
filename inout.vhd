----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:05:57 12/05/2016 
-- Design Name: 
-- Module Name:    inout - Behavioral 
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

entity final_inout is
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
end final_inout;

architecture Behavioral of final_inout is
	signal state : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal enc_state : STD_LOGIC;
   signal o: STD_LOGIC_VECTOR(31 DOWNTO 0);
   signal digit : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal led_bn: STD_LOGIC_VECTOR(7 DOWNTO 0);	
	signal data_vld_botton_cnt : STD_LOGIC_VECTOR(10 DOWNTO 0);
	signal key_vld_botton_cnt : STD_LOGIC_VECTOR(10 DOWNTO 0);
	signal dout_botton_cnt : STD_LOGIC_VECTOR(10 DOWNTO 0);
	signal enc_botton_cnt : STD_LOGIC_VECTOR(10 DOWNTO 0);
	signal work_botton_cnt : STD_LOGIC_VECTOR(10 DOWNTO 0);
	signal ukey_o	  : STD_LOGIC_VECTOR(127 DOWNTO 0);
	signal din_o	  : STD_LOGIC_VECTOR(63 downto 0);

begin
	process(clk_slow,clr)
	begin 
    if(clr='0') then
     enc_botton_cnt <= (OTHERS=>'0');
	  enc<='1'; 
	  enc_indicate<="01";
	  enc_state<='0';
	  else 
	  if(clk_slow'EVENT AND clk_slow='1')THEN
				IF (enc_botton='1') THEN
				  IF (enc_botton_cnt <"11111111111") THEN enc_botton_cnt<=enc_botton_cnt+'1'; END IF;
				ELSE IF (enc_botton='0' and enc_botton_cnt ="11111111111") THEN
					  CASE enc_state IS
				WHEN '0'=>  enc<='0';enc_state<='1';enc_indicate<="10";
				WHEN '1'=>  enc<='1';enc_state<='0';enc_indicate<="01";
				WHEN OTHERS=> null;
				END CASE;
					  enc_botton_cnt<= (OTHERS=>'0');			  
					  end if;
				end if;     
			end if;			
		end if;
	end process;
	
	process(clk_slow,clr)
	begin 
    if(clr='0') then
     work_botton_cnt <= (OTHERS=>'0');
	  work<='0'; 
	  else 
	  if(clk_slow'EVENT AND clk_slow='1')THEN
				IF (work_botton='1') THEN
				  IF (work_botton_cnt <"11111111111") THEN work<='1';work_botton_cnt<=work_botton_cnt+'1'; END IF;
				ELSE IF (work_botton='0' and work_botton_cnt ="11111111111") THEN
                 work<='0';
					  work_botton_cnt<= (OTHERS=>'0');			  
					  end if;
				end if;     
			end if;			
		end if;
	end process;
	
	process(clk_slow,clr)
   begin 
    if(clr='0') then
		state(3 DOWNTO 0)<= (OTHERS=>'1');
      key_vld_botton_cnt<= (OTHERS=>'0');		
	   data_vld_botton_cnt<= (OTHERS=>'0');
      dout_botton_cnt<= (OTHERS=>'0');
		ukey_o(127 DOWNTO 0) <= (OTHERS=>'0');
		din_o(63 downto 0) <= (OTHERS=>'0');
		di_vld <='0';
    else 
	 if(clk_slow'EVENT AND clk_slow='1')THEN
		IF (key_vld_botton='1') THEN
	      IF (key_vld_botton_cnt <"11111111111") THEN key_vld_botton_cnt<=key_vld_botton_cnt+'1'; END IF;
      END IF;
		IF (data_vld_botton='1') THEN
	      IF (data_vld_botton_cnt <"11111111111") THEN data_vld_botton_cnt<=data_vld_botton_cnt+'1'; END IF;
      END IF;
		IF (dout_botton='1') THEN
	      IF (dout_botton_cnt <"11111111111") THEN dout_botton_cnt<=dout_botton_cnt+'1'; END IF;
      END IF;
		
		IF (key_vld_botton='0' AND key_vld_botton_cnt ="11111111111") THEN  --insert ukey
				CASE state(3 DOWNTO 0) IS
				WHEN "0000"=>  ukey_o(15 DOWNTO 0)<=in_switch(15 DOWNTO 0);state(2 DOWNTO 0)<="001";
				WHEN "0001"=>  ukey_o(31 DOWNTO 16)<=in_switch(15 DOWNTO 0);state(2 DOWNTO 0)<="010";
				WHEN "0010"=>  ukey_o(47 DOWNTO 32)<=in_switch(15 DOWNTO 0);state(2 DOWNTO 0)<="011";
				WHEN "0011"=>  ukey_o(63 DOWNTO 48)<=in_switch(15 DOWNTO 0);state(2 DOWNTO 0)<="100";
				WHEN "0100"=>  ukey_o(79 DOWNTO 64)<=in_switch(15 DOWNTO 0);state(2 DOWNTO 0)<="101";
				WHEN "0101"=>  ukey_o(95 DOWNTO 80)<=in_switch(15 DOWNTO 0);state(2 DOWNTO 0)<="110";
				WHEN "0110"=>  ukey_o(111 DOWNTO 96)<=in_switch(15 DOWNTO 0);state(2 DOWNTO 0)<="111";
				WHEN "0111"=>  ukey_o(127 DOWNTO 112)<=in_switch(15 DOWNTO 0);state(2 DOWNTO 0)<="000";
				WHEN OTHERS=>  ukey_o(15 DOWNTO 0)<=in_switch(15 DOWNTO 0);state(3 DOWNTO 0)<="0001";di_vld <='0';
				END CASE;
				key_vld_botton_cnt <=(OTHERS=>'0');
		END IF;
		   	 
		IF (data_vld_botton='0' AND data_vld_botton_cnt ="11111111111") THEN --insert din
				CASE state(3 DOWNTO 0) IS
				WHEN "1000"=>  din_o(15 DOWNTO 0)<=in_switch(15 DOWNTO 0);state(1 DOWNTO 0)<="01";
				WHEN "1001"=>  din_o(31 DOWNTO 16)<=in_switch(15 DOWNTO 0);state(1 DOWNTO 0)<="10";
				WHEN "1010"=>  din_o(47 DOWNTO 32)<=in_switch(15 DOWNTO 0);state(1 DOWNTO 0)<="11";
				WHEN "1011"=>  din_o(63 DOWNTO 48)<=in_switch(15 DOWNTO 0);state(1 DOWNTO 0)<="00";
				WHEN OTHERS=> din_o(15 DOWNTO 0)<=in_switch(15 DOWNTO 0);state(3 DOWNTO 0)<="1001";di_vld <='0';
				END CASE;
			   data_vld_botton_cnt <=(OTHERS=>'0');
		END IF;
		
		IF (dout_botton='0' AND dout_botton_cnt ="11111111111") THEN --run
		      di_vld<='1';  
				CASE state(3 DOWNTO 0) IS
				WHEN "1100"=>  state(1 DOWNTO 0)<="01";
				WHEN "1101"=>  state(1 DOWNTO 0)<="00";
				WHEN OTHERS=>  state(3 DOWNTO 0)<="1101";
				END CASE;
			   dout_botton_cnt <=(OTHERS=>'0');
		END IF;
    end if;	 
	 end if;	
   end process;
	
		process(state,clr,din_o,ukey_o,dout)
	begin
		IF(clr='0') THEN
			led_indicate(3 DOWNTO 0) <= (OTHERS=>'0');
			o(31 DOWNTO 0)<=(OTHERS=>'0');
		else
			CASE state(3 DOWNTO 0) IS
			   WHEN "0000"=>  o(31 DOWNTO 0)<=ukey_o(127 DOWNTO 96);led_indicate(3 DOWNTO 0)<="1000";
				WHEN "0001"=>  o(31 DOWNTO 0)<=ukey_o(31 DOWNTO 0);led_indicate(3 DOWNTO 0)<="0001";
				WHEN "0010"=>  o(31 DOWNTO 0)<=ukey_o(31 DOWNTO 0);led_indicate(3 DOWNTO 0)<="0001";
				WHEN "0011"=>  o(31 DOWNTO 0)<=ukey_o(63 DOWNTO 32);led_indicate(3 DOWNTO 0)<="0010";
				WHEN "0100"=>  o(31 DOWNTO 0)<=ukey_o(63 DOWNTO 32);led_indicate(3 DOWNTO 0)<="0010";
				WHEN "0101"=>  o(31 DOWNTO 0)<=ukey_o(95 DOWNTO 64);led_indicate(3 DOWNTO 0)<="0100";
				WHEN "0110"=>  o(31 DOWNTO 0)<=ukey_o(95 DOWNTO 64);led_indicate(3 DOWNTO 0)<="0100";
				WHEN "0111"=>  o(31 DOWNTO 0)<=ukey_o(127 DOWNTO 96);led_indicate(3 DOWNTO 0)<="1000";
				
				WHEN "1000"=>  o(31 DOWNTO 0)<=din_o(63 DOWNTO 32);led_indicate(3 DOWNTO 0)<="0010";
				WHEN "1001"=>  o(31 DOWNTO 0)<=din_o(31 DOWNTO 0);led_indicate(3 DOWNTO 0)<="0001";
				WHEN "1010"=>  o(31 DOWNTO 0)<=din_o(31 DOWNTO 0);led_indicate(3 DOWNTO 0)<="0001";
				WHEN "1011"=>  o(31 DOWNTO 0)<=din_o(63 DOWNTO 32);led_indicate(3 DOWNTO 0)<="0010";
				
				WHEN "1100"=>  o(31 DOWNTO 0)<=dout(63 DOWNTO 32);led_indicate(3 DOWNTO 0)<="0010";
				WHEN "1101"=>  o(31 DOWNTO 0)<=dout(31 DOWNTO 0);led_indicate(3 DOWNTO 0)<="0001";
				WHEN OTHERS=> o(31 DOWNTO 0)<=(OTHERS=>'0');led_indicate(3 DOWNTO 0)<=(OTHERS=>'0');
			END CASE;
		end if;
	end process;
	
	process(clr,clk_slow,o)
   begin
      IF(clr='0') THEN
			  led_bn(7 DOWNTO 0)<="11111111";
      ELSIF(clk_slow'EVENT AND clk_slow='1') THEN
            CASE led_bn(7 DOWNTO 0) IS
				WHEN "11111110"=>  digit(3 DOWNTO 0)<=o(7 DOWNTO 4);led_bn(7 DOWNTO 0)<="11111101";
				WHEN "11111101"=>  digit(3 DOWNTO 0)<=o(11 DOWNTO 8);led_bn(7 DOWNTO 0)<="11111011";
				WHEN "11111011"=>  digit(3 DOWNTO 0)<=o(15 DOWNTO 12);led_bn(7 DOWNTO 0)<="11110111";
				WHEN "11110111"=>  digit(3 DOWNTO 0)<=o(19 DOWNTO 16);led_bn(7 DOWNTO 0)<="11101111";
				WHEN "11101111"=>  digit(3 DOWNTO 0)<=o(23 DOWNTO 20);led_bn(7 DOWNTO 0)<="11011111";
				WHEN "11011111"=>  digit(3 DOWNTO 0)<=o(27 DOWNTO 24);led_bn(7 DOWNTO 0)<="10111111";
				WHEN "10111111"=>  digit(3 DOWNTO 0)<=o(31 DOWNTO 28);led_bn(7 DOWNTO 0)<="01111111";
				WHEN "01111111"=>  digit(3 DOWNTO 0)<=o(3 DOWNTO 0);led_bn(7 DOWNTO 0)<="11111110";
				WHEN OTHERS=> digit(3 DOWNTO 0)<="0000";led_bn(7 DOWNTO 0)<="11111110";
		      END CASE;
        END IF;
	END PROCESS;
	
	process(digit)	 
	begin
      CASE digit IS
		WHEN "0000"=>  led_segment(6 DOWNTO 0)<="0000001";
		WHEN "0001"=>  led_segment(6 DOWNTO 0)<="1001111";
		WHEN "0010"=>  led_segment(6 DOWNTO 0)<="0010010";
		WHEN "0011"=>  led_segment(6 DOWNTO 0)<="0000110";
		WHEN "0100"=>  led_segment(6 DOWNTO 0)<="1001100";
		WHEN "0101"=>  led_segment(6 DOWNTO 0)<="0100100";
		WHEN "0110"=>  led_segment(6 DOWNTO 0)<="0100000";
		WHEN "0111"=>  led_segment(6 DOWNTO 0)<="0001111";
		WHEN "1000"=>  led_segment(6 DOWNTO 0)<="0000000";
		WHEN "1001"=>  led_segment(6 DOWNTO 0)<="0000100";
		WHEN "1010"=>  led_segment(6 DOWNTO 0)<="0001000";
		WHEN "1011"=>  led_segment(6 DOWNTO 0)<="1100000";
		WHEN "1100"=>  led_segment(6 DOWNTO 0)<="0110001";
		WHEN "1101"=>  led_segment(6 DOWNTO 0)<="1000010";
		WHEN "1110"=>  led_segment(6 DOWNTO 0)<="0110000";
		WHEN "1111"=>  led_segment(6 DOWNTO 0)<="0111000";
		WHEN OTHERS=> led_segment(6 DOWNTO 0)<="1111111";
		END CASE;
	
	END PROCESS;
 
	led_an(7 DOWNTO 0) <= led_bn(7 DOWNTO 0);
	ukey(127 DOWNTO 0) <= ukey_o(127 DOWNTO 0);
	din(63 DOWNTO 0) <= din_o(63 DOWNTO 0);

end Behavioral;
