
-- VHDL Instantiation Created from source file control_multisensor.vhd -- 08:40:48 09/20/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT control_multisensor
	PORT(
		data_1 : IN std_logic_vector(7 downto 0);
		data_2 : IN std_logic_vector(7 downto 0);
		clk : IN std_logic;
		switch_data : IN std_logic;          
		data_out : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_control_multisensor: control_multisensor PORT MAP(
		data_1 => ,
		data_2 => ,
		clk => ,
		switch_data => ,
		data_out => 
	);


