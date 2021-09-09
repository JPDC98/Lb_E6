library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity uart_rx is

 generic(
				HZ_reloj: integer:= 12000000; --Frecuencia del reloj a utilizar.
				Bits_data: integer:= 8;       -- Numero de bits a enviar.
				BaudRate: integer:= 115200;     -- Bits por segundo. 
				tiempo_bit: integer:= 104;		-- Tiempo de espera por bit, reloj/baudrate
				tiempo_mbit: integer:= 52
	 );
    Port (  --IO_P1: out  STD_LOGIC;--IO_P1(0)= datos; 
				IO_P2: in  STD_LOGIC;--Entrada de datos
				LED: out STD_LOGIC_VECTOR (7 downto 0);
				--DPSwitch: in STD_LOGIC_VECTOR (7 downto 0);
				Switch_2: in STD_LOGIC;
            Clk : in  STD_LOGIC);

end uart_rx;

architecture Behavioral of uart_rx is

	type uart_tx is (idle,data,start,stop);
	signal estado: uart_tx:= idle; 
	
   signal conteo: integer range 0 to tiempo_bit-1:= 0;
	signal info: std_logic_vector (7 downto 0):= (others => '0');
	signal indice: integer range 0 to Bits_data-1:= 0;

begin

reloj: process(Clk)
    begin
        if (rising_edge(Clk)) then
            case estado is
					when idle =>
						if (IO_P2 = '1') then
							estado <= idle;
						else
							conteo <= 0;
							indice <= 0;
							info <= (others => '0');
							estado <= start;							
						end if;
						if (Switch_2 = '0') then
							LED <= info;
						end if;
					when start =>
						if (conteo <  tiempo_mbit-1) then
							conteo <= conteo + 1;
							estado <= start;
						else
							if (IO_P2 = '0') then
								conteo <= 0;
								estado <= data;
							else
								estado <= idle;
							end if;
						end if;
					when data =>
						if (conteo < tiempo_bit-1) then
							conteo <= conteo + 1;
							estado <= data;
						else
							info(indice)<= IO_P2;
							conteo <= 0;
							if (indice < Bits_data-1) then
								indice <= indice + 1;
								estado <= data;
							else
								conteo <= 0;
								estado <= stop;
							end if;
						end if;
					when stop =>
						if (conteo < tiempo_bit-1) then
							conteo <= conteo + 1;
							estado <= stop;
						else
							if (IO_P2 = '1') then
								conteo <= 0;
								estado <= idle;
							else
								info <= "10101010";
							end if;				
						end if;
					when others =>
						estado <= idle;
				end case;
        end if;
    end process reloj;

end Behavioral;

