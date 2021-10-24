library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity transmiso_tx is
	 generic(
			  num_datos: integer := 6;
			  t_bit: integer:= 104;
			  t_bit_extend: integer:= 12000;
			  bits_datos: integer:= 8);	
	 		
    Port ( data_1 : in  STD_LOGIC_VECTOR (bits_datos-1 downto 0);--distancia ultrasonico 1
           data_2 : in  STD_LOGIC_VECTOR (bits_datos-1 downto 0);--distancia ultrasonico 2
			  data_3 : in  STD_LOGIC_VECTOR (bits_datos-1 downto 0);--acelerometro, primer byte
			  data_4 : in  STD_LOGIC_VECTOR (bits_datos-1 downto 0);--acelerometro, segundo byte
			  data_5 : in  STD_LOGIC_VECTOR (bits_datos-1 downto 0);--giroscopio, primer byte
			  data_6 : in  STD_LOGIC_VECTOR (bits_datos-1 downto 0);--giroscopio, segundo byte
           activador : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           tx : out  STD_LOGIC);
end transmiso_tx;

architecture Behavioral of transmiso_tx is

	type serial is (idle,start,datos,stop,stop_extend);
	signal estado: serial:= idle;
	signal cargador_1: std_logic_vector(bits_datos-1 downto 0):= (others =>'0');
	signal cargador_2: std_logic_vector(bits_datos-1 downto 0):= (others =>'0');
	signal cargador_3: std_logic_vector(bits_datos-1 downto 0):= (others =>'0');
	signal cargador_4: std_logic_vector(bits_datos-1 downto 0):= (others =>'0');
	signal cargador_5: std_logic_vector(bits_datos-1 downto 0):= (others =>'0');
	signal cargador_6: std_logic_vector(bits_datos-1 downto 0):= (others =>'0');
	signal conteo: integer range 0 to t_bit:= 0;
	signal select_senal: integer range 0 to num_datos:= 0;
	signal salida: std_logic_vector(bits_datos-1 downto 0):= (others =>'0');
	signal indice: integer range 0 to bits_datos-1:= 0;
	signal conteo_extend: integer range 0 to t_bit_extend:= 0;
	
begin
	reloj: process(clk)
	begin
		if (rising_edge(clk)) then	
			case estado is
				when idle =>
					conteo <= 0;
					select_senal <= 0;
					conteo_extend <= 0;
					tx <= '1';
					if (activador = '0') then
						cargador_1 <= data_1;
						cargador_2 <= data_2;
						cargador_3 <= data_3;
						cargador_4 <= data_4;
						cargador_5 <= data_5;
						cargador_6 <= data_6;
						estado <= start;
					else
						estado <= idle;
					end if;
				when start =>
					tx <= '0';
					if (conteo < t_bit) then
						conteo <= conteo + 1;
						estado <= start;
					else
						if (select_senal = 0) then
							salida <= cargador_1;
							conteo <= 0;
							estado <= datos;
						elsif (select_senal = 1) then
							salida <= cargador_2;
							conteo <= 0;
							estado <= datos;
						elsif (select_senal = 2) then
							salida <= cargador_3;
							conteo <= 0;
							estado <= datos;
						elsif (select_senal = 3) then
							salida <= cargador_4;
							conteo <= 0;
							estado <= datos;
						elsif (select_senal = 4) then
							salida <= cargador_5;
							conteo <= 0;
							estado <= datos;
						elsif (select_senal = 5) then
							salida <= cargador_6;
							conteo <= 0;
							estado <= datos;
						end if;
					end if;
				when datos =>
					tx <= salida(indice);
					if (conteo < t_bit) then
						conteo <= conteo + 1;
						estado <= datos;
					else
						if (indice < bits_datos-1) then
							conteo <= 0;
							indice <= indice + 1;
							estado <= datos;
						else
							if (select_senal = 5) then
								conteo <= 0;
								indice <= 0;
								estado <= stop_extend;
							else
								conteo <= 0;
								indice <= 0;
								estado <= stop;
							end if;
						end if;
					end if;
				when stop =>
					tx <= '1';
					if (conteo < t_bit) then
						conteo <= conteo + 1;
						estado <= stop;
					else
						conteo <= 0;
						select_senal <= select_senal + 1;
						estado <= start;			
					end if;
				when stop_extend =>
					tx <= '1';
					if (conteo_extend < t_bit_extend) then
						conteo_extend <= conteo_extend + 1;
						estado <= stop_extend;
					else
						conteo_extend <= 0;
						estado <= idle;						
					end if;
				when others =>
					estado <= idle;
			end case;
		end if;
	end process reloj;
end Behavioral;

