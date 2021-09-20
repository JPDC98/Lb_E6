library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_hc_sr04 is
	  generic(
				HZ_reloj: integer:= 12000000; --Frecuencia del reloj a utilizar.
				Pulso_trigger: integer := 120;--Conteo equivalente a 10us.
				Bits_data: integer:= 8;       -- N?mero de bits a enviar.
				Conteo_max: integer:= 139200;  --Conteo de distancia max a medir.
				distancia_max: integer:= 200; --Distancia maxima en cm a medir.
				tiempo_sonico: integer:= 2400;--Tiempo de espera envio ultrasonico
				tiempo_descanso: integer:= 2400;--Tiempo contra sobrecarga del ultrasonido.
				centimetro: integer:= 348     --Conteo equivalente a un cm. 
	 );	
    Port ( Clk : in  STD_LOGIC;
			  ECO: in  STD_LOGIC;
			  TRIGGER: out	STD_LOGIC;
			  DATA: out STD_LOGIC_VECTOR(Bits_data-1 downto 0);
           DISPARO : in  STD_LOGIC);
end control_hc_sr04;

architecture Behavioral of control_hc_sr04 is
	type uart_tx is (idle,trig,espera,echo,conteo,envio);
	signal estado: uart_tx:= idle;
	signal distancia: integer range 0 to distancia_max:= 0;
	signal sumador: integer range 0 to centimetro:= 0;
	signal contador: integer range 0 to Conteo_max:= 0;
begin
	ultrasonico: process(Clk)
	begin
		if(rising_edge(Clk)) then
			case estado is
				when idle =>
					distancia<= 0;
					contador <= 0;
					TRIGGER <= '0';
					sumador <= 0;
					if (DISPARO = '0') then
						estado <= trig;
					else
						estado <= idle;
					end if;
				when trig =>
					TRIGGER <= '1';
					if(contador < Pulso_trigger) then
						contador <= contador + 1;
						estado <= trig;
					else
						contador <= 0;
						TRIGGER <= '0';
						estado <= espera;
					end if;	
				when espera=>
					if(contador < tiempo_sonico) then
						contador <= contador + 1;
						estado <= espera;
					else
						contador <= 0;
						estado <= echo;
					end if;	
				when echo =>
					if(ECO = '1') then
						if (contador < Conteo_max) then
							contador <= contador + 1;
						else
							contador <= 0;
							estado <= conteo;
						end if;
					else
						if (contador = 0) then
							estado <= echo;
						else
							estado <= conteo;
						end if;
					end if;				
				when conteo =>
					if (contador > 0) then 
						contador <= contador - 1;
						if(sumador < centimetro) then
							sumador <= sumador + 1;
						else
							sumador <= 0;
							distancia <= distancia + 1;
						end if;
					else
						contador <= 0;
						estado <= envio;
					end if;	
				when envio =>
					DATA <= std_logic_vector(to_unsigned(distancia,DATA'length));
					estado <= idle;
				when others =>
					estado <= idle;
			end case;
		end if;
	end process ultrasonico;
end Behavioral;

