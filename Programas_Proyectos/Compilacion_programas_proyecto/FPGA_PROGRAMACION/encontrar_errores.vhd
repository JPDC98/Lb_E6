library ieee; 
use ieee.std_logic_1164.all;

entity encontrar_errores is (
	a: bit_vector (0 to 3);
	b: out std_logic_vector (3 to 0);
	c: in bit_vector (5 downto 0))
end encontrar_errores;

architecture incorrecto of encontrar_errores 
	begin
	etiqueta: process
		begin 
		if c = x"F" then
			b <= a;
		else
			b <= '0101';
		end if
	end process;
end incorrecto;

