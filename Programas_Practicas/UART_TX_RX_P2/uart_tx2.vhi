
-- VHDL Instantiation Created from source file uart_tx2.vhd -- 13:31:50 09/12/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT uart_tx2
	PORT(
		DPSwitch : IN std_logic_vector(3 downto 0);
		Switch_1 : IN std_logic;
		Clk : IN std_logic;          
		IO_P1 : OUT std_logic
		);
	END COMPONENT;

	Inst_uart_tx2: uart_tx2 PORT MAP(
		IO_P1 => ,
		DPSwitch => ,
		Switch_1 => ,
		Clk => 
	);


