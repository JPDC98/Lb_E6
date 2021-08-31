library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



entity mod_PS is
	 generic(
				HZ_reloj: integer:= 12000000; --Frecuencia del reloj a utilizar.
				Bits_data: integer:= 8;       -- Número de bits a enviar.
				tiempo_mbit: integer:= 52;     -- Tiempo medio de un bit. 
				tiempo_bit: integer:= 104		-- Tiempo de espera por bit.
	 );
    Port (  IO_P1: out  STD_LOGIC_VECTOR (1 downto 0):= "11";--IO_P1(0) = datos ; IO_P1(1)= dato listo;
				LED: out STD_LOGIC_VECTOR (7 downto 0);
				DPSwitch: in STD_LOGIC_VECTOR (7 downto 0);
				Switch: in STD_LOGIC;
            Clk : in  STD_LOGIC);
	end mod_PS;

architecture Behavioral of mod_PS is	
	 type uart_tx is (idle,data,start,stop);
	 signal estado: uart_tx:= idle;
	 
    signal conteo: integer range 0 to tiempo_bit;
	 signal puente: std_logic_vector (Bits_data-1 downto 0);
	 signal indice: integer range 0 to Bits_data-1;
begin
	puente <= DPSwitch;
	LED <= puente;
	
	reloj: process(Clk,Switch)
    begin
        if (rising_edge(Clk)) then
            case estado is
					when idle =>
						IO_P1(0)<= '1';
						IO_P1(1)<= '0';
						conteo <= 0;
						indice <= 0;
						if (Switch = '0') then
							IO_P1(0)<= '0';
							estado <= start;
						else	
							estado <= idle;	
						end if;
					when start =>
						if (conteo > tiempo_bit-1) then		
								conteo <= 0;
								estado <= data;
						else
							conteo <= conteo + 1;
							estado <= start;
						end if;
						
					when data =>
						IO_P1(0)<= puente(indice);
						if (conteo > tiempo_bit-1) then
							conteo <= 0;
							indice <= indice + 1;
							if (indice > Bits_data-1) then
								indice <= 0;
								estado <= stop;
							else
								indice <= indice + 1;
								estado <= data;
							end if;
						else	
							conteo <= conteo + 1;
							estado <= data;
						end if;
					when stop =>
						if (conteo > tiempo_bit) then
							conteo <= 0;
							estado <= idle;
						else
							IO_P1(0)<= '1';
							IO_P1(1)<= '1';
							conteo <= conteo + 1;
							estado <= stop;
						end if;
					when others =>
						estado <= idle;
				end case;
        end if;
    end process;
	  
end Behavioral;

