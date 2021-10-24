
-- VHDL Instantiation Created from source file control_i2c.vhd -- 17:52:11 10/23/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT control_i2c
	PORT(
		activ : IN std_logic;
		clk : IN std_logic;    
		sda : INOUT std_logic;      
		scl : OUT std_logic;
		datos_1 : OUT std_logic_vector(7 downto 0);
		datos_2 : OUT std_logic_vector(7 downto 0);
		datos_3 : OUT std_logic_vector(7 downto 0);
		datos_4 : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_control_i2c: control_i2c PORT MAP(
		activ => ,
		sda => ,
		scl => ,
		clk => ,
		datos_1 => ,
		datos_2 => ,
		datos_3 => ,
		datos_4 => 
	);


