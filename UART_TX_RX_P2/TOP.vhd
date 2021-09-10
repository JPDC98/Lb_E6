library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP is
    Port ( PUSH_1 : in  STD_LOGIC;
			  PUSH_2 : in  STD_LOGIC;
			  PUSH_3 : in  STD_LOGIC;		
			  SALIDA_P1: out  STD_LOGIC;
			  SALIDA_P5: out  STD_LOGIC;
			  SALIDA_P2: in  STD_LOGIC;
			  SALIDA_P6: in  STD_LOGIC;
           DATOS_TX : in  STD_LOGIC_VECTOR (7 downto 0);
			  DISPLAY: out  STD_LOGIC_VECTOR (7 downto 0);
			  enable : out  STD_LOGIC_VECTOR (2 downto 0);
           CLK : in  STD_LOGIC;
           DATOS_RX : out  STD_LOGIC_VECTOR (7 downto 0));
end TOP;

architecture Behavioral of TOP is
	COMPONENT uart_tx
	PORT(
		DPSwitch : IN std_logic_vector(7 downto 0);
		Switch_1 : IN std_logic;
		Clk : IN std_logic;          
		IO_P1 : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT uart_rx
	PORT(
		IO_P2 : IN std_logic;
		Clk : IN std_logic;          
		salida_datos : OUT std_logic_vector(7 downto 0);
		salida_bit : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT mux
	PORT(
		dato_1 : IN std_logic_vector(7 downto 0);
		dato_2 : IN std_logic_vector(7 downto 0);
		senal_1 : IN std_logic;
		senal_2 : IN std_logic;          
		salida_vector : OUT std_logic_vector(7 downto 0);
		salida_bit : out  STD_LOGIC_VECTOR(1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT view_data
	PORT(
		activar : IN  std_logic_vector(1 downto 0);
		Switch_3 : IN std_logic;
		clk : IN std_logic;          
		enable : OUT std_logic_vector(2 downto 0);
		Display : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	signal salida_rx1 : std_logic_vector (7 downto 0);
	signal salida_rx2 : std_logic_vector (7 downto 0);
	signal salidaB_rx1 : std_logic;
	signal salidaB_rx2 : std_logic;
	signal union : std_logic_vector (1 downto 0);
	
begin

	Inst_uart_tx_1: uart_tx PORT MAP(
		IO_P1 => SALIDA_P1,
		DPSwitch => DATOS_TX,
		Switch_1 => PUSH_1,
		Clk => CLK
	);
	
	Inst_uart_tx_2: uart_tx PORT MAP(
		IO_P1 => SALIDA_P5,
		DPSwitch => DATOS_TX,
		Switch_1 => PUSH_2,
		Clk => CLK
	);

	Inst_uart_rx_1: uart_rx PORT MAP(
		IO_P2 => SALIDA_P2,
		salida_datos => salida_rx1,
		salida_bit => salidaB_rx1,
		Clk => CLK
	);
	
	Inst_uart_rx_2: uart_rx PORT MAP(
		IO_P2 => SALIDA_P6,
		salida_datos => salida_rx2,
		salida_bit => salidaB_rx2,
		Clk => CLK
	);
	
	Inst_mux: mux PORT MAP(
		dato_1 => salida_rx1,
		dato_2 => salida_rx2,
		senal_1 => salidaB_rx1,
		senal_2 => salidaB_rx2,
		salida_vector => DATOS_RX,
		salida_bit => union
	);
	
	Inst_view_data: view_data PORT MAP(
		activar => union,
		Switch_3 => PUSH_3,
		clk => CLK,
		enable => enable,
		Display => DISPLAY
	);
	
end Behavioral;

