
-- VHDL Instantiation Created from source file control_ultrasonico.vhd -- 23:05:59 10/19/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT control_ultrasonico
	PORT(
		echo : IN std_logic;
		activador : IN std_logic;
		clk : IN std_logic;          
		trigg : OUT std_logic;
		LED : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_control_ultrasonico: control_ultrasonico PORT MAP(
		echo => ,
		activador => ,
		trigg => ,
		LED => ,
		clk => 
	);


