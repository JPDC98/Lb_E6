library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity moduloAudio is
	generic(clk12:integer:=6000000;--Divide el ciclo en 1 segundo 500 ms bajo 500 ms alto cambiar si se desea un ciclo mas rapido
			  m50:integer:=50;
			  m100:integer:=100;
			  m150:integer:=150;
			  m200:integer:=200
				);

    Port ( clk:in STD_LOGIC;
			  distancia : in  STD_LOGIC_VECTOR (7 downto 0);
           salida_alarma : out  STD_LOGIC);
end moduloAudio;

architecture Behavioral of moduloAudio is
	signal dist:std_logic_vector(7 downto 0);
	signal contador_clk_div: integer range 0 to clk12:=0;
	signal contador_distancia: integer range 0 to 255:=0;
	signal t_bajo,t_bajocnt: integer range 0 to 10:=0;-- t_alto,t_altocnt
	signal clk_div: STD_LOGIC:='0';

begin
------------------Divisor de reloj------------------------------
	process(clk)
		begin
			if(rising_edge(clk)) then 
				dist<=distancia;
				contador_distancia<=to_integer(unsigned(dist));
				if(contador_distancia>m150 and contador_distancia<m200) then
					--t_alto<=1;
					t_bajo<=5;
				elsif(contador_distancia>m100 and contador_distancia<m150)then
					--t_alto<=1;
					t_bajo<=4;
				elsif(contador_distancia>m50 and contador_distancia<m100)then
					--t_alto<=1;
					t_bajo<=3;
				elsif(contador_distancia>0 and contador_distancia<m50)then
					--t_alto<=1;
					t_bajo<=2;
				else
					--t_alto<=0;
					t_bajo<=0;
				end if;
				
				if(contador_clk_div=clk12)then
					contador_clk_div<=0;
					clk_div<=not(clk_div);
					--salida_alarma<=clk_div;
				else
					contador_clk_div<=contador_clk_div+1;
				end if;
			end if;
	end process;
---------------------------------------------------------------

	process(clk_div)
		begin
			if(rising_edge(clk_div))then
				if(t_bajo/=0)then
					if(t_bajocnt<=t_bajo)then
						salida_alarma<='0';
						t_bajocnt<=t_bajocnt+1;
					else
						salida_alarma<='1';
						t_bajocnt<=0;
					end if;	
				else
					salida_alarma<='0';
				end if;
			end if;
				
		end process;


end Behavioral;

