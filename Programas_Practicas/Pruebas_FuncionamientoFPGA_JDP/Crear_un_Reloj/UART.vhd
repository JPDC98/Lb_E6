library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART is
    Port ( Clk : in  STD_LOGIC;
           LED : out  STD_LOGIC_VECTOR (1 downto 0));
end UART;

architecture Behavioral of UART is

COMPONENT modulo1_PS
	PORT(
		entrada_datos_paralelos : IN std_logic_vector(7 downto 0);
		pushdisparo_modulo1_ps : IN std_logic;
		clk : IN std_logic;          
		indicador_bit : OUT std_logic;
		salida_datos_serie : OUT std_logic
		);
	END COMPONENT;

	signal c1: std_logic_vector (7 downto 0)
	signal c2: std_logic;
	
begin 

	Inst_modulo1_PS: modulo1_PS PORT MAP(
		entrada_datos_paralelos => c1,
		pushdisparo_modulo1_ps => LED[0],
		indicador_bit => LED[1],
		salida_datos_serie => c2,
		clk => Clk
	);

end Behavioral;

