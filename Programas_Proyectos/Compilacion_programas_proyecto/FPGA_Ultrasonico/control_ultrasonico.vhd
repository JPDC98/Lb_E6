
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_ultrasonico is
	 generic(
			  distancia_max: integer := 200; --distancia maxima en cm
			  t_trigg: integer := 120; -- equivalente a 10us
			  t_max_echo : integer:= 24000000; -- ciclos equivalentes a tiempo maximo de pulso echo 200ms
			  t_cm_us: integer := 706; -- ciclos equivalentes a 14.71us equivalentes a 1cm
			  f_reloj: integer:= 12000000);
			  
    Port ( echo : in  STD_LOGIC;
			  activador: in STD_LOGIC;
           trigg : out  STD_LOGIC;
           dato : out  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC);
end control_ultrasonico;

architecture Behavioral of control_ultrasonico is

	type control is (idle,disparo,eco,contar,calculo,envio);
	signal estado: control:= idle;
	signal conteo: integer range 0 to t_max_echo:= 0;
	signal pulsos: integer range 0 to t_max_echo:= 0;
	signal distancia: integer range 0 to distancia_max:= 0;
	
begin
	reloj:process (clk)
	begin
		if(rising_edge(clk)) then
			case estado is
				when idle =>
					conteo <= 0;
					trigg <= '0';	
					pulsos <= 0;
					if (activador = '0') then
						estado <= disparo;
					else 
						estado <= idle;
					end if;
				when disparo =>
					trigg <= '1';
					if (conteo < t_trigg) then
						conteo <= conteo + 1;
						estado <= disparo;
					else	
						trigg <= '0';
						conteo <= 0;
						estado <= eco;
					end if;
				when eco =>
					if (echo = '1') then
						estado <= contar;
					else
						estado <= eco;
					end if;
				when contar =>
					if (echo = '1') then
						pulsos <= pulsos  + 1;
					else 
						distancia <= 0;
						estado <= calculo;
					end if;
				when calculo =>
					if (pulsos > 0) then 
						pulsos <= pulsos - 1;
						if (conteo < t_cm_us) then
							conteo <= conteo + 1;
							estado <= calculo;
						else 	
							if (distancia < distancia_max) then
								distancia <= distancia + 1;
								conteo <= 0;
								estado <= calculo;
							else
								distancia <= distancia_max;
								conteo <= 0;
								pulsos <= 0;
								estado <= envio;
							end if;
						end if;
					else 
						pulsos <= 0;
						estado <= envio;
					end if;
				when envio =>
					dato <= std_logic_vector(to_unsigned(distancia,dato'length));
					estado <= idle;
				when others =>
					estado <= idle;
			end case;
		end if;
	end process reloj;

end Behavioral;

