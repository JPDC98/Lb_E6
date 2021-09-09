library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP is
    Port ( PUSH_1 : in  STD_LOGIC;
           PUSH_2 : in  STD_LOGIC;
			  SALIDA_P1: out  STD_LOGIC;
			  SALIDA_P2: in  STD_LOGIC;
           DATOS_TX : in  STD_LOGIC_VECTOR (7 downto 0);
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
		Switch_2 : IN std_logic;
		Clk : IN std_logic;          
		LED : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

begin

	Inst_uart_tx: uart_tx PORT MAP(
		IO_P1 => SALIDA_P1,
		DPSwitch => DATOS_TX,
		Switch_1 => PUSH_1,
		Clk => CLK
	);
	
	Inst_uart_rx: uart_rx PORT MAP(
		IO_P2 => SALIDA_P2,
		LED => DATOS_RX,
		Switch_2 => PUSH_2  ,
		Clk => CLK
	);

end Behavioral;

