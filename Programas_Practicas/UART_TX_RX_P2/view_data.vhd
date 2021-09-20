library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity view_data is
	 
	 generic(
				HZ_reloj: integer:= 12000000; --Frecuencia del reloj a utilizar.
				HZ_mux: integer:= 120;       -- Veces por segundo
				periodo_t: integer:= 100000  -- Tiempo de espera por bit, HZ_reloj/HZ_mux
	 );
	 
    Port ( activar : in  STD_LOGIC_VECTOR (1 downto 0);
			  Switch_3 : in STD_LOGIC;
			  clk: in STD_LOGIC;
           enable : out  STD_LOGIC_VECTOR (2 downto 0);
           Display : out  STD_LOGIC_VECTOR (7 downto 0));
end view_data;

architecture Behavioral of view_data is
	signal conteo: integer range 0 to periodo_t:= 0;
	signal num_dis: integer range 0 to 5:= 0;
	signal mensaje_1: std_logic_vector (7 downto 0);
	signal mensaje_2: std_logic_vector (7 downto 0);
	signal salto: std_logic_vector (7 downto 0);
begin
	reloj: process(clk)
	begin
		if (rising_edge(clk)) then
			if (conteo < periodo_t) then
				conteo <= conteo + 1;
			else
				conteo <= 0;
				if (num_dis<2) then
					num_dis <= num_dis + 1;
				else
					num_dis <= 0;
				end if;
			end if;
		end if; 
	end process reloj;

	with Switch_3 select
      Display <= salto when '0',
               "11111111" when '1',
               "11111111" when others;
	
	with activar select
      salto <= mensaje_1 when "01",
               mensaje_2 when "10",
               "11111111" when others;
	
	with num_dis select
      enable <= "110" when 0,
                "101" when 1,
					 "011" when 2,
                "111" when others;
					 
	with num_dis select
      mensaje_1 <="10011111" when 0,
                  "11101111" when 1,
					   "10000011" when 2,
                  "11111111" when others;
						
	with num_dis select
      mensaje_2 <="00100101" when 0,
                  "11101111" when 1,
					   "10000011" when 2,
                  "11111111" when others;
end Behavioral;

