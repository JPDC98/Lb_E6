library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Librerias que posiblemente sean de utilidad.
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity modulo1_PS is --PS significa Paralelo a Serie
    Port ( LED : out  STD_LOGIC;
           Clk : in  STD_LOGIC);
end modulo1_PS;

architecture Behavioral of modulo1_PS is
	signal cuenta: integer range 0 to 12000000;
	signal senal_bit: std_logic := '0';
	
begin

	reloj: process(Clk)
	begin
		if (rising_edge(Clk)) then
			if(cuenta < 12000000) then
				cuenta <= cuenta + 1;
			else
				cuenta <= 0;
				senal_bit <= not senal_bit;
			end if;
		end if;
	end process;
	
	periodo: process(senal_bit)
	begin
		LED <= senal_bit;
	end process;
	
end Behavioral;

