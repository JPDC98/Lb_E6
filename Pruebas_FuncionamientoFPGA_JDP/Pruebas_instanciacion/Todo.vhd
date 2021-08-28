----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:32:40 08/28/2021 
-- Design Name: 
-- Module Name:    Todo - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Todo is
    Port ( DPSwitch : in  STD_LOGIC_VECTOR (7 downto 0);
           LED : out  STD_LOGIC_VECTOR (7 downto 0));
end Todo;

architecture Behavioral of Todo is

		
	COMPONENT Entrada_parte1
	PORT(
		Entradas : IN std_logic_vector(7 downto 0);          
		salida1 : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Salida_parte2
	PORT(
		entrada_2 : IN std_logic_vector(7 downto 0);          
		Salidas : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	signal a : std_logic_vector (7 downto 0);
	
begin

	Inst_Entrada_parte: Entrada_parte1 PORT MAP(
		Entradas => DPSwitch,
		salida1 => a
	);

	Inst_Salida_parte: Salida_parte2 PORT MAP(
		entrada_2 => a,
		Salidas => LED 
	);

end Behavioral;

