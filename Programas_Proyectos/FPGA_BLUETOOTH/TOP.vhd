library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP is
	 generic(
				HZ_reloj: integer:= 12000000; --Frecuencia del reloj a utilizar.
				Bits_data: integer:= 8        -- N?mero de bits a enviar.
	 );	
    Port ( SWITCH_TOP : in  STD_LOGIC; --Se�al de bloqueo 
           ECHO_TOP : in  STD_LOGIC;   --Se�al de tiempo alto, proporcional a distancia
			  CLK: in STD_LOGIC;				--Reloj de 12MHz interno de la FPGA
           TRIGGER_TOP : out  STD_LOGIC;--Entrada se�al de activacici�n m�dulo ultras�nico
           TX_TOP : out  STD_LOGIC);	--Salida serial de datos de 8 bits
end TOP;

architecture Behavioral of TOP is

	COMPONENT control_hc_sr04 --Controlador del modulo ultrasonico HC-04
	PORT(
		Clk : IN std_logic;
		ECO : IN std_logic;
		DISPARO : IN std_logic;          
		TRIGGER : OUT std_logic;
		DATA : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	COMPONENT tx_bluetooth  --Conmutador y gestionador de informacion de entrada de modulos HC-04 a modulo bluetooth
	PORT(
		DPSwitch_1 : IN std_logic_vector(7 downto 0);
		DPSwitch_2 : IN std_logic_vector(7 downto 0);
		Switch_1 : IN std_logic;
		Clk : IN std_logic;          
		IO_P1 : OUT std_logic
		);
	END COMPONENT;

	signal bus_data_1: std_logic_vector(Bits_data-1 downto 0);
	signal bus_data_2: std_logic_vector(Bits_data-1 downto 0);

begin
	bus_data_2<= "00011000"; --Datos fantasma que proporcionara el segundo HC-04  
	Inst_control_hc_sr04: control_hc_sr04 PORT MAP(
		Clk => CLK,
		ECO => ECHO_TOP,
		TRIGGER => TRIGGER_TOP,
		DATA => bus_data_1,
		DISPARO => SWITCH_TOP
	);

	Inst_tx_bluetooth: tx_bluetooth PORT MAP(
		IO_P1 => TX_TOP,
		DPSwitch_1 => bus_data_1,
		DPSwitch_2 => bus_data_2,
		Switch_1 => SWITCH_TOP,
		Clk => CLK
	);

end Behavioral;

