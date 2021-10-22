library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_i2c is
	generic(t_cont: integer:= 30;--24 ciclos equivalentes a 2.5us
			  escribir: std_logic_vector:= X"D0";
			  leer: std_logic_vector:= X"D1";
			  acelr: std_logic_vector:= X"3F";
			  giros: std_logic_vector:= X"47";
			  num_bit: integer:= 8;
			  t_scl: integer := 61);-- 61 ciclos equivalentes a 5.063us
			  
    Port ( activ: in STD_LOGIC;
			  sda : inout  STD_LOGIC;
           scl : out  STD_LOGIC;
           clk : in  STD_LOGIC;
			  datos_1 : out  STD_LOGIC_VECTOR (num_bit-1 downto 0);
           datos_2 : out  STD_LOGIC_VECTOR (num_bit-1 downto 0));
end control_i2c;

architecture Behavioral of control_i2c is
	
	type i2c is (idle,start,ingreso_com,ack,pulso,ingreso_regis,ack_2,start_2,ingreso_com_2,ack_3,info,ack_4,info_2,nack,stop,envio);
	signal estado: i2c:= idle;
	signal conteo: integer range 0 to t_scl:= 0;
	signal cont: integer range 0 to t_cont:= 0;
	signal sig_scl: std_logic:= '1';
	signal pas_scl: std_logic:= '0';
	signal paso: std_logic:= '0';
	signal indice: integer range 0 to num_bit-1:= 0;
	signal cargador_1: std_logic_vector(num_bit-1 downto 0):= (others=>'0');
	signal cargador_2: std_logic_vector(num_bit-1 downto 0):= (others=>'0');

begin
	reloj_sda: process(clk,sig_scl)
	begin
		if (rising_edge(clk)) then
			case estado is
				when idle =>
					sda <= '1';
					if (activ = '0') then 
						paso <= '1';
						if (cont < t_cont) then
							cont <= cont + 1;
							estado <= idle;
						else
							cont <= 0;
							pas_scl <= sig_scl;
							estado <= start;
						end if;
					else 
						estado <= idle;
					end if;
				when start =>
					sda <= '0';
					if (pas_scl = '1' and sig_scl = '0') then
						if (cont < t_cont) then
							cont <= cont + 1;
							estado <= start;
						else
							cont <= 0;
							pas_scl <= sig_scl;
							estado <= ingreso_com;
						end if;
					else
						estado <= start;
					end if;
				when ingreso_com =>	
					sda <= escribir(indice);
					if (pas_scl = '0' and sig_scl = '1') then
						pas_scl <= sig_scl;
						estado <= ingreso_com;
					elsif (pas_scl = '1' and sig_scl = '0') then
						if (indice < num_bit-1) then
							pas_scl <= sig_scl;
							indice <= indice + 1;
							estado <= ingreso_com;
						else
							pas_scl <= sig_scl;
							indice <= 0;
							sda <= 'Z';
							estado <= ack;
						end if;						
					else
						estado <= ingreso_com;
					end if;
				when ack => 
					if (sig_scl = '1') then
						if (sda = '0') then
							pas_scl <= sig_scl;
							estado <= ack;
						else
							estado <= stop;
						end if;
					elsif (pas_scl = '1' and sig_scl = '0') then
						pas_scl <= sig_scl;
						estado <= ingreso_regis;
					else
						estado <= ack;
					end if;
					
				when ingreso_regis =>	
					sda <= giros(indice);
					if (pas_scl = '0' and sig_scl = '1') then
						pas_scl <= sig_scl;
						estado <= ingreso_regis;
					elsif (pas_scl = '1' and sig_scl = '0') then
						if (indice < num_bit-1) then
							pas_scl <= sig_scl;
							indice <= indice + 1;
							estado <= ingreso_regis;
						else
							pas_scl <= sig_scl;
							indice <= 0;
							sda <= 'Z';
							estado <= ack_2;
						end if;						
					else
						estado <= ingreso_regis;
					end if;
					
				when ack_2 => 
					if (sig_scl = '1') then
						if (sda = '0') then
							pas_scl <= sig_scl;
							estado <= ack_2;
						else
							estado <= stop;
						end if;
					elsif (pas_scl = '1' and sig_scl = '0') then
						if (cont < t_cont) then
							cont <= cont + 1;
							estado <= ack_2;
						else
							cont <= 0;
							pas_scl <= sig_scl;
							sda <= '1';
							estado <= start_2;
						end if;
					else
						estado <= ack_2;
					end if;
					
				when start_2 =>
					if (pas_scl = '0' and sig_scl = '1') then
						if (cont < t_cont) then
							cont <= cont + 1;
							estado <= start_2;
						else
							cont <= 0;
							pas_scl <= sig_scl;
							sda <= '0';
							estado <= start_2;
						end if;
					elsif (pas_scl = '1' and sig_scl = '0') then
						pas_scl <= sig_scl;
						estado <= ingreso_com_2;
					else
						estado <= start_2;
					end if;
				when ingreso_com_2 =>	
					sda <= leer(indice);
					if (pas_scl = '0' and sig_scl = '1') then
						pas_scl <= sig_scl;
						estado <= ingreso_com_2;
					elsif (pas_scl = '1' and sig_scl = '0') then
						if (indice < num_bit-1) then
							pas_scl <= sig_scl;
							indice <= indice + 1;
							estado <= ingreso_com_2;
						else
							pas_scl <= sig_scl;
							indice <= 0;
							sda <= 'Z';
							estado <= ack_3;
						end if;						
					else
						estado <= ingreso_com_2;
					end if;
				when ack_3 => 
					if (sig_scl = '1') then
						if (sda = '0') then
							pas_scl <= sig_scl;
							estado <= ack_3;
						else
							estado <= stop;
						end if;
					elsif (pas_scl = '1' and sig_scl = '0') then
						pas_scl <= sig_scl;
						estado <= info;
					else
						estado <= ack_3;
					end if;
				when info =>
					if (pas_scl = '0' and sig_scl = '1') then
						pas_scl <= sig_scl;
						cargador_1(indice) <= sda;
						estado <= info;
					elsif (pas_scl = '1' and sig_scl = '0') then
						if (indice < num_bit-1) then
							pas_scl <= sig_scl;
							indice <= indice + 1;
							estado <= info;
						else
							pas_scl <= sig_scl;
							indice <= 0;
							sda <= '0'; 
							estado <= ack_4;
						end if;
					else
						estado <= info;
					end if;	
				 when ack_4 =>
					if (pas_scl = '0' and sig_scl = '1') then
							sda <= '0';
							pas_scl <= sig_scl;
							estado <= ack_4;
					elsif (pas_scl = '1' and sig_scl = '0') then
						pas_scl <= sig_scl;
						estado <= info_2;
					else
						estado <= ack_4;
					end if;
				when info_2 =>
					if (pas_scl = '0' and sig_scl = '1') then
						pas_scl <= sig_scl;
						cargador_2(indice) <= sda;
						estado <= info_2;
					elsif (pas_scl = '1' and sig_scl = '0') then
						if (indice < num_bit-1) then
							pas_scl <= sig_scl;
							indice <= indice + 1;
							estado <= info_2;
						else
							pas_scl <= sig_scl;
							indice <= 0;
							sda <= '1';
							estado <= nack;
						end if;
					else
						estado <= info_2;
					end if;		
				when nack =>
					if (pas_scl = '0' and sig_scl = '1') then
							sda <= '1';
							pas_scl <= sig_scl;
							estado <= nack;
					elsif (pas_scl = '1' and sig_scl = '0') then
						pas_scl <= sig_scl;
						estado <= stop;
					else
						estado <= nack;
					end if;
				when stop =>
					sda <= '0';
					if (pas_scl = '0' and sig_scl = '1') then
						pas_scl <= sig_scl;
						paso <= '0';
						sda <= '1';
						estado <= envio;
					else
						estado <= stop;
					end if;
				when envio =>
					datos_1 <= cargador_1;
					datos_2 <= cargador_2;
					estado <= idle;
				when others =>
					estado <= idle;
			end case;
		end if;
	end process reloj_sda;
	
	reloj_scl: process(clk,paso)
	begin 
		if (rising_edge(clk) and paso = '1') then 
			if (conteo < t_scl) then
				conteo <= conteo + 1;
			else
				conteo <= 0;
				sig_scl <= not sig_scl;
			end if;
		end if;
	end process reloj_scl;

scl <= sig_scl when paso = '1' else
       '1';

end Behavioral;

