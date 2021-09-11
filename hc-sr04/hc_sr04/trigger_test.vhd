--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:27:35 09/10/2021
-- Design Name:   
-- Module Name:   /media/omar/FILES/Omar/U/cursos/E6/lab/hc-sr04/hc_sr04/trigger_test.vhd
-- Project Name:  hc_sr04
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: trigger
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
 
ENTITY trigger_test IS
END trigger_test;
 
ARCHITECTURE behavior OF trigger_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT trigger
    PORT(
         clk_trigger : IN  std_logic;
         enable_trigger : IN  std_logic;
         in_trigger : IN  std_logic;
         bussyT : OUT  std_logic;
         out_trigger : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_trigger : std_logic := '0';
   signal enable_trigger : std_logic := '0';
   signal in_trigger : std_logic := '1';

 	--Outputs
   signal bussyT : std_logic;
   signal out_trigger : std_logic;

   -- Clock period definitions
   constant clk_trigger_period : time := 83 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: trigger PORT MAP (
          clk_trigger => clk_trigger,
          enable_trigger => enable_trigger,
          in_trigger => in_trigger,
          bussyT => bussyT,
          out_trigger => out_trigger
        );

   -- Clock process definitions
   clk_trigger_process :process
   begin
		clk_trigger <= '0';
		wait for clk_trigger_period/2;
		clk_trigger <= '1';
		wait for clk_trigger_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_trigger_period*10;
	enable_trigger<='1';
	wait for 10 ns;
	in_trigger<='0';
	wait for 100 us;
	in_trigger<='1';
      wait;
   end process;

END;
