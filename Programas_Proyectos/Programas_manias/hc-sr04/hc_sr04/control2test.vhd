--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:51:28 09/10/2021
-- Design Name:   
-- Module Name:   /media/omar/FILES/Omar/U/cursos/E6/lab/hc-sr04/hc_sr04/control2test.vhd
-- Project Name:  hc_sr04
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: control_3_byte
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
 
ENTITY control2test IS
END control2test;
 
ARCHITECTURE behavior OF control2test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_3_byte
    PORT(
         clk : IN  std_logic;
         data : IN  std_logic_vector(23 downto 0);
         data0 : IN  std_logic_vector(23 downto 0);
         enable : IN  std_logic;
         enable0 : IN  std_logic;
         uartReady : IN  std_logic;
         dataCopy : OUT  std_logic;
         enableRx : OUT  std_logic;
         dataOut : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal data : std_logic_vector(23 downto 0) := (others => '0');
   signal data0 : std_logic_vector(23 downto 0) := (others => '0');
   signal enable : std_logic := '0';
   signal enable0 : std_logic := '0';
   signal uartReady : std_logic := '0';

 	--Outputs
   signal dataCopy : std_logic;
   signal enableRx : std_logic;
   signal dataOut : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_3_byte PORT MAP (
          clk => clk,
          data => data,
          data0 => data0,
          enable => enable,
          enable0 => enable0,
          uartReady => uartReady,
          dataCopy => dataCopy,
          enableRx => enableRx,
          dataOut => dataOut
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
--------------------------------------------
		uartReady<='0';
		data<=x"125687";
		wait for 20 ns;
		enable<='1';
		wait for 2*clk_period;
		enable<='0';
		wait for 50 ns;
		data0<=x"897563";
		wait for 30 ns;
		enable0<='1'; 
		wait for 2*clk_period;
		enable0<='0';
		wait for 600 ns;
		--Respuesta del uart--
		--2do byte
		uartReady<='1';
		wait for clk_period;
		uartReady<='0';
		wait for 20 us;
		--3er byte
		uartReady<='1';
		wait for clk_period;
		uartReady<='0';
		wait for 20 us;
		--4to byte
		uartReady<='1';
		wait for clk_period;
		uartReady<='0';
		wait for 20 us;
		--5to byte
		uartReady<='1';
		wait for clk_period;
		uartReady<='0';
		wait for 20 us;
		--6to byte
		uartReady<='1';
		wait for clk_period;
		uartReady<='0';
		wait for 20 us;
-------------------------------------------------  
		uartReady<='0';
		data0<=x"897563";
		wait for 30 ns;
		enable0<='1'; 
		wait for 2*clk_period;
		enable0<='0';
		wait for 50 ns;
		data<=x"568235";
		wait for 20 ns;
		enable<='1';
		wait for 2*clk_period;
		enable<='0';
		
		wait for 600 ns;
		--Respuesta del uart--
		--2do byte
		uartReady<='1';
		wait for clk_period;
		uartReady<='0';
		wait for 20 us;
		--3er byte
		uartReady<='1';
		wait for clk_period;
		uartReady<='0';
		wait for 20 us;
		--4to byte
		uartReady<='1';
		wait for clk_period;
		uartReady<='0';
		wait for 20 us;
		--5to byte
		uartReady<='1';
		wait for clk_period;
		uartReady<='0';
		wait for 20 us;
		--6to byte
		uartReady<='1';
		wait for clk_period;
		uartReady<='0';
		wait for 20 us;    
		end process;

END;
