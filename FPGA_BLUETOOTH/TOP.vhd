library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP is
    Port ( SWITCH_TOP : in  STD_LOGIC;
           ECHO_TOP : in  STD_LOGIC;
			  CLK: in STD_LOGIC;
           TRIGGER_TOP : out  STD_LOGIC;
           TX_TOP : out  STD_LOGIC);
end TOP;

architecture Behavioral of TOP is

	COMPONENT control_hc_sr04
	PORT(
		Clk : IN std_logic;
		ECO : IN std_logic;
		DISPARO : IN std_logic;          
		TRIGGER : OUT std_logic;
		DATA : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT tx_bluetooth
	PORT(
		DPSwitch : IN std_logic_vector(7 downto 0);
		Switch_1 : IN std_logic;
		Clk : IN std_logic;          
		IO_P1 : OUT std_logic
		);
	END COMPONENT;
	
	signal bus_data: std_logic_vector(7 downto 0);

begin

	Inst_control_hc_sr04: control_hc_sr04 PORT MAP(
		Clk => CLK,
		ECO => ECHO_TOP,
		TRIGGER => TRIGGER_TOP,
		DATA => bus_data,
		DISPARO => SWITCH_TOP
	);
	
	Inst_tx_bluetooth: tx_bluetooth PORT MAP(
		IO_P1 => TX_TOP,
		DPSwitch => bus_data,
		Switch_1 => SWITCH_TOP,
		Clk => CLK
	);

end Behavioral;

