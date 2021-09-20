
-- VHDL Instantiation Created from source file tx_bluetooth.vhd -- 09:39:08 09/20/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT tx_bluetooth
	PORT(
		DPSwitch_1 : IN std_logic_vector(7 downto 0);
		DPSwitch_2 : IN std_logic_vector(7 downto 0);
		Switch_1 : IN std_logic;
		Clk : IN std_logic;          
		IO_P1 : OUT std_logic
		);
	END COMPONENT;

	Inst_tx_bluetooth: tx_bluetooth PORT MAP(
		IO_P1 => ,
		DPSwitch_1 => ,
		DPSwitch_2 => ,
		Switch_1 => ,
		Clk => 
	);


