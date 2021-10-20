library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP is
  generic( 
			  bits_datos: integer := 8);
    Port ( ACTIV : in STD_LOGIC;
			  TRIG_1 : out  STD_LOGIC;
           TRIG_2 : out  STD_LOGIC;
           ECO_1 : in  STD_LOGIC;
           ECO_2 : in  STD_LOGIC;
           TX : out  STD_LOGIC;
           CLK : in  STD_LOGIC);
end TOP;

architecture Behavioral of TOP is

	COMPONENT control_ultrasonico
	PORT(
		echo : IN std_logic;
		activador : IN std_logic;
		clk : IN std_logic;          
		trigg : OUT std_logic;
		dato : OUT std_logic_vector(bits_datos-1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT transmiso_tx
	PORT(
		data_1 : IN std_logic_vector(bits_datos-1 downto 0);
		data_2 : IN std_logic_vector(bits_datos-1 downto 0);
		activador : IN std_logic;
		clk : IN std_logic;          
		tx : OUT std_logic
		);
	END COMPONENT;
	
	signal un_dato_1: std_logic_vector(bits_datos-1 downto 0):= (others =>'0');
	signal un_dato_2: std_logic_vector(bits_datos-1 downto 0):= (others =>'0');

begin

	Inst_control_ultrasonico_1: control_ultrasonico PORT MAP(
		echo => ECO_1,
		activador => ACTIV,
		trigg => TRIG_1,
		dato => un_dato_1,
		clk => CLK 
	);
	
	Inst_control_ultrasonico_2: control_ultrasonico PORT MAP(
		echo => ECO_2,
		activador => ACTIV,
		trigg => TRIG_2,
		dato => un_dato_2,
		clk => CLK
	);

	Inst_transmiso_tx: transmiso_tx PORT MAP(
		data_1 => un_dato_1,
		data_2 => un_dato_2,
		activador => ACTIV,
		clk => CLK,
		tx => TX
	);

end Behavioral;

