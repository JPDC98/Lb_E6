
-- VHDL Instantiation Created from source file moduloAudio.vhd -- 12:17:19 10/24/2021
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT moduloAudio
	PORT(
		clk : IN std_logic;
		distancia : IN std_logic_vector(7 downto 0);          
		salida_alarma : OUT std_logic
		);
	END COMPONENT;

	Inst_moduloAudio: moduloAudio PORT MAP(
		clk => ,
		distancia => ,
		salida_alarma => 
	);


