library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_hc_sr04 is
	  generic(
				HZ_reloj: integer:= 12000000; --Frecuencia del reloj a utilizar.
				Pulso_trigger: integer := 120;--Conteo equivalente a 10us.
				Bits_data: integer:= 8;       -- Numero de bits a enviar.
				Conteo_max: integer:= 139200; -- variable obtendida por variable 'centimetro'*'distancia_max'
				distancia_max: integer:= 200; --Distancia maxima en cm.
				tiempo_sonico: integer:= 2400;--Tiempo de espera envio del ultrasonico, rafaga de 8 pulsos a 40KHz = 200us
				centimetro: integer:= 348     --Conteo equivalente a un cm. 
	 );	
    Port ( Clk : in  STD_LOGIC;										--							
			  ECO: in  STD_LOGIC;										--
			  TRIGGER: out	STD_LOGIC;									----------> Daos explicados en el archivo TOP.vhdl	
			  DATA: out STD_LOGIC_VECTOR(Bits_data-1 downto 0);--
           DISPARO : in  STD_LOGIC);								--
end control_hc_sr04;

architecture Behavioral of control_hc_sr04 is
	type uart_tx is (idle,trig,espera,echo,conteo,envio);--Inicialización de maquinad de estados 
	signal estado: uart_tx:= idle;
	signal distancia: integer range 0 to distancia_max:= 0;
	signal sumador: integer range 0 to centimetro:= 0;
	signal contador: integer range 0 to Conteo_max:= 0;
begin
	ultrasonico: process(Clk)--se ingresa valores en lista de activación de este processo
	begin
		if(rising_edge(Clk)) then-- cuando se detecte un pulso acendente se ejecuta codigo planteado
			case estado is
				when idle => -- Estado de espera de la maquina de estados, variables puestas en estado bajo esperando DISPARO = '0'
					distancia<= 0;
					contador <= 0;
					TRIGGER <= '0';
					sumador <= 0;
					if (DISPARO = '0') then
						estado <= trig;
					else
						estado <= idle;
					end if;
				when trig => --Proceso el cual se envia un pulso de duración de 10us
					TRIGGER <= '1';
					if(contador < Pulso_trigger) then
						contador <= contador + 1;
						estado <= trig;
					else
						contador <= 0;
						TRIGGER <= '0';
						estado <= espera;
					end if;	
				when espera=> --Se espera el cual el modulo HC-sr04 envia su pulso, tiempo necesario para no tener estados extraños
					if(contador < tiempo_sonico) then
						contador <= contador + 1;
						estado <= espera;
					else
						contador <= 0;
						estado <= echo;
					end if;	
				when echo => --Se inicia conteo del tiempo en lato de la señal echo, conteo de tiempo se guardara.
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
				when conteo => --Acá se inicia el conteo de cm, esto viendo cuantas propociones de cm caben en la variable contador del-
					if (contador > 0) then --proceso anterior. 
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
				when envio => --Se envian la variable de cm proporcionales obtenidos del proceso anterior
					DATA <= std_logic_vector(to_unsigned(distancia,DATA'length));
					estado <= idle;
				when others => --En vista de diferentes caso no previstos se toma una medida de retorno al idle
					estado <= idle; 
			end case;
		end if;
	end process ultrasonico;
end Behavioral;

