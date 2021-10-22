--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:26:02 09/08/2021
-- Design Name:   
-- Module Name:   /media/omar/FILES/Omar/U/cursos/E6/lab/hc-sr04/hc_sr04/uart_tx_test.vhd
-- Project Name:  hc_sr04
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart_tx
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
 
ENTITY uart_tx_test IS
END uart_tx_test;
 
ARCHITECTURE behavior OF uart_tx_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_tx
    PORT(
         datos : IN  std_logic_vector(7 downto 0);
         datosOut : OUT  std_logic_vector(7 downto 0);
         clk : IN  std_logic;
         enable : IN  std_logic;
         txOcupado : OUT  std_logic;
         txHecho : OUT  std_logic;
         txSerial : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal datos : std_logic_vector(7 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal enable : std_logic := '1';

 	--Outputs
   signal datosOut : std_logic_vector(7 downto 0);
   signal txOcupado : std_logic;
   signal txHecho : std_logic;
   signal txSerial : std_logic;

   -- Clock period definitions
   constant clk_period : time := 83 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_tx PORT MAP (
          datos => datos,
          datosOut => datosOut,
          clk => clk,
          enable => enable,
          txOcupado => txOcupado,
          txHecho => txHecho,
          txSerial => txSerial
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		enable<='1';
		datos<="10101010";
		wait for 10ns;
		enable<='0';
		wait for clk_period;
		enable<='1';

      wait;
   end process;

END;
