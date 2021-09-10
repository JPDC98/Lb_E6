
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity echo is
	generic( max_cont: integer:=283487);
    Port ( clk_echo : in  STD_LOGIC;
           pulse_echo : in  STD_LOGIC;--entrada del pulso proporcional 
           enable_echo : in  STD_LOGIC;--habilita el modulo
			  read_echo: in STD_LOGIC;--indica que se ha leido y se puede limpiar la salida
			  bussy: out STD_LOGIC:='1';--0 para ocupado, 1 para desocupado
			  done: out STD_LOGIC:='0';-- pulso que indica que se a terminado de contar el pulso del sensor 
           conteo : out  STD_LOGIC_VECTOR (23 downto 0));
end echo;

architecture Behavioral of echo is
	type echo is(idle,start,read_data,doneEcho,waitDown);
	signal estado: echo:=idle;
	signal t_contador: integer range 0 to 500000:=0;
	signal t_cont:integer range 0 to 3:=0;
	--signal flag: STD_LOGIC:='0';
begin
	process(clk_echo)
	begin
		if(rising_edge(clk_echo)) then 
			case estado is
				when idle=>
					bussy<='1';--indica que no esta recibiendo nada
					conteo<=x"000000";
					t_contador<=0;
					done<='0';
					t_cont<=0;
					if(pulse_echo='1' and enable_echo='1') then 
						estado<=start;
						bussy<='0';	
					else
						estado<=idle;
					end if;
				when start=>
						if(pulse_echo='0')then							
							estado<=doneEcho;
							conteo<=	STD_LOGIC_VECTOR(to_unsigned(t_contador,conteo'length));
							--flag<='0';--Lectura valida
						elsif(t_contador>max_cont) then
							estado<=doneEcho;
							conteo<=	STD_LOGIC_VECTOR(to_unsigned(t_contador,conteo'length));
							--flag<='1';--Lectura invalida
						else
							t_contador<=t_contador+1;
							conteo<=	STD_LOGIC_VECTOR(to_unsigned(t_contador,conteo'length));
							estado<=start;
						end if;	
				
				when doneEcho=>
					done<='1';
					if(t_cont<1)then
						t_cont<=t_cont+1;
					else
						t_cont<=0;
						done<='0';
						estado<=read_data;
					end if;
				
				when read_data=>
					if(read_echo='0') then
						estado<=read_data;							
					else
						conteo<=x"000000";
						estado<=waitDown;
					end if;
				when waitDown=>
					if(pulse_echo='1')then
						estado<=waitDown;
					else
						estado<=idle;
					end if;
				when others=>
					estado<=idle;
			end case;
		end if;
	end process;
end Behavioral;

