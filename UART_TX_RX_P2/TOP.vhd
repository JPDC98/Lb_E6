library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP is

	 generic(
				Num_display: integer:= 3;     -- Número de Displays 
				segment_display: integer:= 8; -- Cantidad de segmentos que tiene el display 
				bits_in_out_data: integer:= 8 -- Cantidad de bits de salida del sistema
	 );	
    Port ( PUSH_1 : in  STD_LOGIC;
			  PUSH_2 : in  STD_LOGIC;
			  PUSH_3 : in  STD_LOGIC;		
			  SALIDA_P1: out  STD_LOGIC;
			  SALIDA_P5: out  STD_LOGIC;
			  SALIDA_P2: in  STD_LOGIC;
			  SALIDA_P6: in  STD_LOGIC;
           DATOS_TX : in  STD_LOGIC_VECTOR (bits_in_out_data-1 downto 0);
			  DISPLAY: out  STD_LOGIC_VECTOR (segment_display-1 downto 0);
			  enable : out  STD_LOGIC_VECTOR (Num_display-1 downto 0);
           CLK : in  STD_LOGIC;
           DATOS_RX : out  STD_LOGIC_VECTOR (bits_in_out_data-1 downto 0));
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
	
	COMPONENT uart_tx2
	PORT(
		DPSwitch : IN std_logic_vector(3 downto 0);
		Switch_1 : IN std_logic;
		Clk : IN std_logic;          
		IO_P1 : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT uart_rx2
	PORT(
		IO_P2 : IN std_logic;
		Clk : IN std_logic;          
		salida_datos : OUT std_logic_vector(3 downto 0);
		salida_bit : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT mux
	PORT(
		dato_1 : IN std_logic_vector(7 downto 0);
		dato_2 : IN std_logic_vector(3 downto 0);
		senal_1 : IN std_logic;
		senal_2 : IN std_logic;          
		salida_vector : OUT std_logic_vector(7 downto 0);
		salida_bit : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT view_data
	PORT(
		activar : IN std_logic_vector(1 downto 0);
		Switch_3 : IN std_logic;
		clk : IN std_logic;          
		enable : OUT std_logic_vector(2 downto 0);
		Display : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	signal salida_datos_rx: std_logic_vector(7 downto 0);
	signal salida_datos_rx2: std_logic_vector(3 downto 0);
	signal salida_bit_rx:  std_logic;
	signal salida_bit_rx2:  std_logic;
	signal union : std_logic_vector (1 downto 0);
	signal entrada_dato_tx2: std_logic_vector(3 downto 0);
	signal mascara: std_logic_vector(7 downto 0);
	
begin
	
	mascara <= DATOS_TX and "00001111";
	entrada_dato_tx2 <= mascara(3 downto 0);
	
	Inst_uart_tx: uart_tx PORT MAP(
		IO_P1 => SALIDA_P1,
		DPSwitch => DATOS_TX,
		Switch_1 => PUSH_1,
		Clk => CLK
	);
	
	Inst_uart_rx: uart_rx PORT MAP(
		IO_P2 => SALIDA_P2,
		salida_datos => salida_datos_rx,
		salida_bit => salida_bit_rx,
		Clk => CLK
	);
	
	Inst_uart_tx2: uart_tx2 PORT MAP(
		IO_P1 => SALIDA_P5,
		DPSwitch => entrada_dato_tx2,
		Switch_1 => PUSH_2,
		Clk => CLK
	);
	
	Inst_uart_rx2: uart_rx2 PORT MAP(
		IO_P2 => SALIDA_P6,
		salida_datos => salida_datos_rx2,
		salida_bit => salida_bit_rx2,
		Clk => CLK
	);
	
	Inst_mux: mux PORT MAP(
		dato_1 => salida_datos_rx,
		dato_2 => salida_datos_rx2,
		senal_1 =>  salida_bit_rx,
		senal_2 => salida_bit_rx2,
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

