
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity hc_sr04_top is
		port(
			clk12: in STD_LOGIC;
			enable_top: in STD_LOGIC;
			echo_top: in STD_LOGIC;
			trigger_top: out STD_LOGIC;
			uartTx_top: out STD_LOGIC;
			txOcupado_top:out STD_LOGIC;
			trigger_state:out STD_LOGIC;
			---provisional:
			--	datos_out:out STD_LOGIC_VECTOR(23 downto 0);
			estado: out std_logic;
			estado_bussyech: out std_logic;
			estado_bussytri: out std_logic
			--datos_top:  out STD_LOGIC_VECTOR (7 DOWNTO 0)		
		);
end hc_sr04_top;

architecture Behavioral of hc_sr04_top is
--signal clk_int: std_logic;
	signal bussyEcho,bussyTrig,readEcho,doneEcho,doneUart,enableRxControl,tr_out: std_logic:='0'; 
	signal controlData:STD_LOGIC_VECTOR(7 DOWNTO 0):=x"00";
	signal echoData:STD_LOGIC_VECTOR(23 DOWNTO 0):=x"000000";
--------------------------------------------------------------------------------
	COMPONENT uart_tx
	PORT(
		datos : IN std_logic_vector(7 downto 0);
		clk : IN std_logic;
		enable : IN std_logic;          
		--datosOut : OUT std_logic_vector(7 downto 0);
		txOcupado : OUT std_logic;
		txHecho : OUT std_logic;
		txSerial : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT trigger
	PORT(
		clk_trigger : IN std_logic;
		enable_trigger : IN std_logic;
		in_trigger : IN std_logic;          
		bussyT : OUT std_logic;
		out_trigger : OUT std_logic
		);
	END COMPONENT;
	
	
	COMPONENT echo
	PORT(
		clk_echo : IN std_logic;
		pulse_echo : IN std_logic;
		enable_echo : IN std_logic;
		read_echo : IN std_logic;          
		bussy : OUT std_logic;
		done : OUT std_logic;
		conteo : OUT std_logic_vector(23 downto 0)
		);
	END COMPONENT;
	
	COMPONENT control_3_byte
	PORT(
		clk : IN std_logic;
		data : IN std_logic_vector(23 downto 0);
		enable : IN std_logic;
		uartReady : IN std_logic;   
--provisional
		--data_Out: OUT std_logic_vector(23 downto 0);
		
		dataCopy : OUT std_logic;
		enableRx : OUT std_logic;
		dataOut : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
-------------------------------------------------------------------------------- 

begin
estado<=enable_top;
trigger_top<=tr_out;
trigger_state<=tr_out;
estado_bussyech<=bussyEcho;
estado_bussytri<=bussyTrig;

uart_tx_0: uart_tx port map(
			datos=>controlData,
			clk=>clk12,
			enable=>enableRxControl,
			--datosOut=>datos_top,
			txOcupado=>txOcupado_top,
			txHecho=>doneUart,
			txSerial=>uartTx_top		
			);
trigger_0: trigger port map(			   
			  
		clk_trigger =>clk12 ,
		enable_trigger => bussyEcho ,
		in_trigger => enable_top ,
		bussyT => bussyTrig,
		out_trigger => tr_out		  
			  
				);
echo_0: echo port map(
			  clk_echo =>clk12,
           pulse_echo =>echo_top,--entrada del pulso proporcional 
           enable_echo =>bussyTrig,--habilita el modulo
			  read_echo=>readEcho,--indica que se ha leido y se puede limpiar la salida
			  bussy=>bussyEcho,--0 para ocupado, 1 para desocupado
			  done=>doneEcho,-- pulso que indica que se a terminado de contar el pulso del sensor 
           conteo =>echoData
       );
control: control_3_byte port map(
			clk=>clk12,
			data=>echoData,--Entrada de 3 bytes
			enable=>doneEcho, -- Habilitador para primer envio
			uartReady=>doneUart,-- Pulso desde el uart indicando que se termino la transmision de 1 byte
			--provisional
			--data_Out=>datos_out,
			dataCopy=>readEcho,-- pulso indicando que se copiaron los datos del echo del hcsr04
			enableRx=>enableRxControl,-- pulso para habilitar el envio del byte
			dataOut=>controlData-- salida de 1 byte de 3
	
       );

end Behavioral;

