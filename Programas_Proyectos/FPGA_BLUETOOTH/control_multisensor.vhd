library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity control_multisensor is
	 generic(
				HZ_reloj: integer:= 12000000; --Frecuencia del reloj a utilizar.
				Bits_data: integer:= 8;       -- N?mero de bits a enviar.
				BaudRate: integer:= 9600;     -- Bits por segundo. 
				conteo_espera: integer:= 36000;-- Equivalente a 3ms.
				tiempo_bit: integer:= 1250		-- Tiempo de espera por bit, reloj/baudrate
	 );	
    Port ( data_1 : in  STD_LOGIC_VECTOR (Bits_data-1 downto 0);
           data_2 : in  STD_LOGIC_VECTOR (Bits_data-1 downto 0);
           data_out : out  STD_LOGIC_VECTOR (Bits_data-1 downto 0));
end control_multisensor;

architecture Behavioral of control_multisensor is
	signal conteo: std_logic:= '0';
begin
	 reloj: process(data_1,data_2)
    begin
			if (conteo = '1') then 
				data_out <= data_1;
				conteo <= not conteo;
			else
				data_out <= data_2;
				conteo <= not conteo;
			end if;
    end process reloj;
end Behavioral;

