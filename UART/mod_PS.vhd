library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity mod_PS is
	 generic(
				HZ_reloj: integer:= 12000000; --Frecuencia del reloj a utilizar.
				Bits_data: integer:= 8;       -- Número de bits a enviar.
				BaudRate: integer:= 115200;     -- Bits por segundo. 
				tiempo_bit: integer:= 104		-- Tiempo de espera por bit, reloj/baudrate
	 );
    Port (  IO_P1: out  STD_LOGIC;--IO_P1(0)= datos; 
				IO_P2: out  STD_LOGIC;--IO_P1(1)= indicador de datos;
				LED: out STD_LOGIC_VECTOR (7 downto 0);
				DPSwitch: in STD_LOGIC_VECTOR (7 downto 0);
				Switch: in STD_LOGIC;
            Clk : in  STD_LOGIC);
	end mod_PS;

architecture Behavioral of mod_PS is	
	 type uart_tx is (idle,data,start,stop);
	 signal estado: uart_tx:= idle;
	 
    signal conteo: integer range 0 to tiempo_bit-1:= 0;
	 signal puente: std_logic_vector (7 downto 0):= (others => '0');
	 signal indice: integer range 0 to Bits_data-1:= 0;
begin
	
	reloj: process(Clk)
   begin
        if (rising_edge(Clk)) then
            case estado is
					when idle =>
						IO_P1 <= '1'; 
						conteo <= 0;
						indice <= 0;
						puente <= (others => '0');
						if (Switch = '0') then
							puente <= DPSwitch;
							LED <= puente;
							estado <= start;
						else
							estado <= idle;
						end if;
						
					when start =>
						IO_P1 <= '0'; 
						IO_P2 <= '1';
						if (conteo <  tiempo_bit-1) then
							conteo <= conteo + 1;
							estado <= start;
						else
							conteo <= 0;
							estado <= data;
						end if;
					when data =>
						IO_P1 <= puente(indice);
						if (conteo < tiempo_bit-1) then
							conteo <= conteo + 1;
							estado <= data;
						else
							conteo <= 0;
							if (indice<Bits_data-1) then 							
								indice <= indice + 1;
								estado <= data;	
							else		
								indice <= 0;
								estado <= stop;
							end if;
						end if;
					when stop =>
						IO_P1 <= '1';
						if (conteo < tiempo_bit-1) then
							conteo <= conteo + 1;
							estado <= stop;
						else
							conteo <= 0;
							IO_P2 <= '0';
							estado <= idle;							
						end if;
					when others =>
						estado <= idle;
				end case;
        end if;
    end process reloj;
	  
end Behavioral;

