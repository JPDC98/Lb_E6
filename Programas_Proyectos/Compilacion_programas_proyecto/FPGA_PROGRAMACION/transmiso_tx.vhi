
-- VHDL Instantiation Created from source file transmiso_tx.vhd -- 23:06:44 10/19/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT transmiso_tx
	PORT(
		data_1 : IN std_logic_vector(7 downto 0);
		data_2 : IN std_logic_vector(7 downto 0);
		activador : IN std_logic;
		clk : IN std_logic;          
		tx : OUT std_logic
		);
	END COMPONENT;

	Inst_transmiso_tx: transmiso_tx PORT MAP(
		data_1 => ,
		data_2 => ,
		activador => ,
		clk => ,
		tx => 
	);


