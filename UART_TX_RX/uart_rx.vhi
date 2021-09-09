
-- VHDL Instantiation Created from source file uart_rx.vhd -- 16:44:30 09/09/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT uart_rx
	PORT(
		IO_P2 : IN std_logic;
		Switch_2 : IN std_logic;
		Clk : IN std_logic;          
		LED : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_uart_rx: uart_rx PORT MAP(
		IO_P2 => ,
		LED => ,
		Switch_2 => ,
		Clk => 
	);


