
-- VHDL Instantiation Created from source file uart_rx.vhd -- 13:30:59 09/12/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT uart_rx
	PORT(
		IO_P2 : IN std_logic;
		Clk : IN std_logic;          
		salida_datos : OUT std_logic_vector(7 downto 0);
		salida_bit : OUT std_logic
		);
	END COMPONENT;

	Inst_uart_rx: uart_rx PORT MAP(
		IO_P2 => ,
		salida_datos => ,
		salida_bit => ,
		Clk => 
	);


