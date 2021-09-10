library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux is
    Port ( dato_1 : in  STD_LOGIC_VECTOR (7 downto 0);
           dato_2 : in  STD_LOGIC_VECTOR (7 downto 0);
           senal_1 : in  STD_LOGIC;
           senal_2 : in  STD_LOGIC;
           salida_vector : out  STD_LOGIC_VECTOR (7 downto 0);
           salida_bit : out  STD_LOGIC_VECTOR(1 downto 0));
end mux;

architecture Behavioral of mux is
	signal estado_1: std_logic_vector(1 downto 0);
begin
	
	elegir: process (senal_1,senal_2)
	begin
		if (senal_1='1') then
			estado_1 <= "00";
		else 
			if (senal_2='1') then
				estado_1 <= "01";
			end if;
		end if;
		
	end process elegir;
	
	with estado_1 select
      salida_vector <= dato_1 when "00",
                       dato_2 when "01",
							  "11111111" when others;
		with estado_1 select
      salida_bit <= "01" when "00",
                    "10" when "01",
						  "00" when others;
end Behavioral;

