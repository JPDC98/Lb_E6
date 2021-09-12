--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:35:01 09/09/2021
-- Design Name:   
-- Module Name:   /media/omar/FILES/Omar/U/cursos/E6/lab/hc-sr04/hc_sr04/top_test.vhd
-- Project Name:  hc_sr04
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: hc_sr04_top
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
 
ENTITY top_test IS
END top_test;
 
ARCHITECTURE behavior OF top_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT hc_sr04_top
    PORT(
         clk12 : IN  std_logic;
         enable_top : IN  std_logic;
         echo_top : IN  std_logic;
         trigger_top : OUT  std_logic;
         uartTx_top : OUT  std_logic;
         txOcupado_top : OUT  std_logic;
			--provisional
			datos_out:out STD_LOGIC_VECTOR(23 downto 0);
         datos_top : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk12 : std_logic := '0';
   signal enable_top : std_logic := '0';
   signal echo_top : std_logic := '0';

 	--Outputs
	signal datos_out:STD_LOGIC_VECTOR(23 downto 0);
   signal trigger_top : std_logic;
   signal uartTx_top : std_logic;
   signal txOcupado_top : std_logic;
   signal datos_top : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk12_period : time := 83 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: hc_sr04_top PORT MAP (
          clk12 => clk12,
          enable_top => enable_top,
          echo_top => echo_top,
          trigger_top => trigger_top,
          uartTx_top => uartTx_top,
			 datos_out=>datos_out,
          txOcupado_top => txOcupado_top,
          datos_top => datos_top
        );

   -- Clock process definitions
   clk12_process :process
   begin
		clk12 <= '0';
		wait for clk12_period/2;
		clk12 <= '1';
		wait for clk12_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk12_period*10;
		enable_top<='1';
		wait for clk12_period;
		enable_top<='0';
		wait for clk12_period;
		enable_top<='1';
		wait for 50 us;
		echo_top<='1';
		wait for 11 ms;
		echo_top<='0';

      wait;
   end process;

END;
