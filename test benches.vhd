--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:54:28 12/12/2016
-- Design Name:   
-- Module Name:   C:/Xilinx/Users/processor_simulation/project_test.vhd
-- Project Name:  processor_simulation
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: processor
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY project_test IS
END project_test;
 
ARCHITECTURE behavior OF project_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT processor
    PORT(
         clr : IN  std_logic;
         clk_slow : IN  std_logic;
         di_vld : IN  std_logic;
         din : IN  std_logic_vector(63 downto 0);
         ukey : IN  std_logic_vector(127 downto 0);
         dout_enc : OUT  std_logic_vector(63 downto 0);
         dout_dec : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clr : std_logic := '0';
   signal clk_slow : std_logic := '0';
   signal di_vld : std_logic := '0';
   signal din : std_logic_vector(63 downto 0) := (others => '0');
   signal ukey : std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal dout_enc : std_logic_vector(63 downto 0);
   signal dout_dec : std_logic_vector(63 downto 0);

   -- Clock period definitions
   constant clk_slow_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: processor PORT MAP (
          clr => clr,
          clk_slow => clk_slow,
          di_vld => di_vld,
          din => din,
          ukey => ukey,
          dout_enc => dout_enc,
          dout_dec => dout_dec
        );

   -- Clock process definitions
   clk_slow_process :process
   begin
		clk_slow <= '0';
		wait for clk_slow_period/2;
		clk_slow <= '1';
		wait for clk_slow_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      clr<='0';
		di_vld<='0';
		wait for 20ns;
		clr<='1';	
		din<=(OTHERS=>'0');
		ukey<=(OTHERS=>'0');
		wait for 20ns;
		di_vld<='1';
      wait for 160000ns;
		wait;


      -- insert stimulus here 

      wait;
   end process;

END;
