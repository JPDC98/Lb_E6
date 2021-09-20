
-- VHDL Instantiation Created from source file control_hc_sr04.vhd -- 02:10:25 09/20/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT control_hc_sr04
	PORT(
		Clk : IN std_logic;
		ECO : IN std_logic;
		DISPARO : IN std_logic;          
		TRIGGER : OUT std_logic;
		DATA : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_control_hc_sr04: control_hc_sr04 PORT MAP(
		Clk => ,
		ECO => ,
		TRIGGER => ,
		DATA => ,
		DISPARO => 
	);


