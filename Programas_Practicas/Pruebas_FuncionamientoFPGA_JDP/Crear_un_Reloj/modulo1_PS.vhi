
-- VHDL Instantiation Created from source file modulo1_PS.vhd -- 18:25:42 08/28/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT modulo1_PS
	PORT(
		entrada_datos_paralelos : IN std_logic_vector(7 downto 0);
		pushdisparo_modulo1_ps : IN std_logic;
		clk : IN std_logic;          
		indicador_bit : OUT std_logic;
		salida_datos_serie : OUT std_logic
		);
	END COMPONENT;

	Inst_modulo1_PS: modulo1_PS PORT MAP(
		entrada_datos_paralelos => ,
		pushdisparo_modulo1_ps => ,
		indicador_bit => ,
		salida_datos_serie => ,
		clk => 
	);


