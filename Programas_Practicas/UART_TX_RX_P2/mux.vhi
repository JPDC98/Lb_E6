
-- VHDL Instantiation Created from source file mux.vhd -- 13:34:20 09/12/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT mux
	PORT(
		dato_1 : IN std_logic_vector(7 downto 0);
		dato_2 : IN std_logic_vector(3 downto 0);
		senal_1 : IN std_logic;
		senal_2 : IN std_logic;          
		salida_vector : OUT std_logic_vector(7 downto 0);
		salida_bit : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;

	Inst_mux: mux PORT MAP(
		dato_1 => ,
		dato_2 => ,
		senal_1 => ,
		senal_2 => ,
		salida_vector => ,
		salida_bit => 
	);


