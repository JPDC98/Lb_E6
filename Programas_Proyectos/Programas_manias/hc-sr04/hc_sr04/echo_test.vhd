--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:24:46 09/08/2021
-- Design Name:   
-- Module Name:   /media/omar/FILES/Omar/U/cursos/E6/lab/hc-sr04/hc_sr04/echo_test.vhd
-- Project Name:  hc_sr04
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: echo
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
 
ENTITY echo_test IS
END echo_test;
 
ARCHITECTURE behavior OF echo_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT echo
    PORT(
         clk_echo : IN  std_logic;
         pulse_echo : IN  std_logic;
         enable_echo : IN  std_logic;
         read_echo : IN  std_logic;
         bussy : OUT  std_logic;
         conteo : OUT  std_logic_vector(23 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_echo : std_logic := '0';
   signal pulse_echo : std_logic := '0';
   signal enable_echo : std_logic := '0';
   signal read_echo : std_logic := '0';

 	--Outputs
   signal bussy : std_logic;
   signal conteo : std_logic_vector(23 downto 0);

   -- Clock period definitions
   constant clk_echo_period : time := 83 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: echo PORT MAP (
          clk_echo => clk_echo,
          pulse_echo => pulse_echo,
          enable_echo => enable_echo,
          read_echo => read_echo,
          bussy => bussy,
          conteo => conteo
        );

   -- Clock process definitions
   clk_echo_process :process
   begin
		clk_echo <= '0';
		wait for clk_echo_period/2;
		clk_echo <= '1';
		wait for clk_echo_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_echo_period*10;

      -- insert stimulus here 
		 read_echo<='0';
		 enable_echo<='1';
		 wait for 10 ns;
		 pulse_echo <='1';
		 wait for 15 ms;
		 pulse_echo <='0';
		 wait for 166 ns;
		 read_echo<='1';
		 wait for 83 ns;
		 read_echo<='0';
	

      wait;
   end process;

END;
