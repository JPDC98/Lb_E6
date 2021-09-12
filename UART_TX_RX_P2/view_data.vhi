
-- VHDL Instantiation Created from source file view_data.vhd -- 13:35:05 09/12/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT view_data
	PORT(
		activar : IN std_logic_vector(1 downto 0);
		Switch_3 : IN std_logic;
		clk : IN std_logic;          
		enable : OUT std_logic_vector(2 downto 0);
		Display : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_view_data: view_data PORT MAP(
		activar => ,
		Switch_3 => ,
		clk => ,
		enable => ,
		Display => 
	);


