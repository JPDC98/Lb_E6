library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_3_byte is
	--generic();
	port( clk: in STD_LOGIC;
			data: in STD_LOGIC_VECTOR(23 downto 0);--Entrada de 3 bytes S1
			data0: in STD_LOGIC_VECTOR(23 downto 0);--Entrada de 3 bytes S2
			enable: in STD_LOGIC; -- Habilitador para primer envio S1
			enable0: in STD_LOGIC; -- Habilitador para primer envio S2
			uartReady: in STD_LOGIC;-- Pulso desde el uart indicando que se termino la transmision de 1 byte
			dataCopy: out STD_LOGIC:='0';-- pulso indicando que se copiaron los datos del eco del S1
			--dataCopy0: out STD_LOGIC:='0';-- pulso indicando que se copiaron los datos del eco del S2
			enableRx: out STD_LOGIC:='0';-- pulso para habilitar el envio del byte
			dataOut: out STD_LOGIC_VECTOR(7 downto 0):=x"00"-- salida de 1 byte de 3
	);
end control_3_byte;

architecture Behavioral of control_3_byte is
	type control is (idle,start,byte0,byte1,byte2,byte00,byte01,byte02,en,en0);
	signal byte_0,byte_1,byte_2,byte_00,byte_01,byte_02: STD_LOGIC_VECTOR(7 downto 0):=x"00";
	signal data_3_byte,data_3_byte0: STD_LOGIC_VECTOR(23 downto 0);
	signal estado0: integer range 0 to 7:=0;
	signal estado: control:=idle;
	signal contador,sensorDataIn: integer range 0 to 3:=0;
	
	
begin
	process (clk)
		begin
			if(rising_edge(clk))then
				case estado is
				
					when idle=>
					
						dataCopy<='0';
						enableRx<='0';
						dataOut<=x"00";
						contador<=0;
						
						
						if(enable='1' and sensorDataIn=0)then
							data_3_byte<=data;
							sensorDataIn<=sensorDataIn+1;
							estado<=en0;
						elsif(enable0='1' and sensorDataIn=0) then
							data_3_byte0<=data0;
							sensorDataIn<=sensorDataIn+1;
							estado<=en;
						--elsif(sensorDataIn=2) then
						--	estado<=start;
						elsif(uartReady='1' and estado0=0) then 
							estado<=byte1;
						elsif(uartReady='1' and estado0=1) then 
							estado<=byte2;
						elsif(uartReady='1' and estado0=2) then
							estado<=byte00;
						elsif(uartReady='1' and estado0=3) then
							estado<=byte01;
						elsif(uartReady='1' and estado0=4) then
							estado<=byte02;
						else 
							estado<=idle;
						end if;
					when en=>
						if(enable='0') then 
							estado<=en;
						else 
							data_3_byte<=data;
							sensorDataIn<=sensorDataIn+1;
							estado<=start;
						end if;						
							
					when en0=>
						if(enable0='0') then
							estado<= en0;
						else
							data_3_byte0<=data0;
							sensorDataIn<=sensorDataIn+1;
							estado<=start;
						end if;						
					when start=>
						--data_Out<=data_3_byte;
						byte_0<=data_3_byte(7 downto 0);
						byte_1<=data_3_byte(15 downto 8);
						byte_2<=data_3_byte(23 downto 16);
						byte_00<=data_3_byte0(7 downto 0);
						byte_01<=data_3_byte0(15 downto 8);
						byte_02<=data_3_byte0(23 downto 16);
						dataCopy<='1';--Indica a los dos sensores que se copiaron los datos del conteo
						if(contador<1) then 
							contador<=contador+1;
							estado<=start;
						else						
							estado<=byte0;
							contador<=0;
							dataCopy<='0';
							sensorDataIn<=0;
							
						end if;
						
					when byte0=>
						dataOut<=byte_0;
						enableRx<='1';
						if(contador<1)then
							contador<=contador+1;
							estado<=byte0;
						else
							enableRx<='0';
							estado0<=0;
							estado<=idle;
							contador<=0;
						end if;
						
					when byte1=>
						dataOut<=byte_1;
						enableRx<='1';
						if(contador<1)then
							contador<=contador+1;
							estado<=byte1;
						else
							enableRx<='0';
							estado0<=1;
							estado<=idle;
							contador<=0;
						end if;	
						
					when byte2=>	
						dataOut<=byte_2;
						enableRx<='1';
						if(contador<1)then
							contador<=contador+1;
							estado<=byte2;
						else
							enableRx<='0';
							estado0<=2;
							estado<=idle;
							contador<=0;
						end if;
						
					when byte00=>	
						dataOut<=byte_00;
						enableRx<='1';
						if(contador<1)then
							contador<=contador+1;
							estado<=byte00;
						else
							enableRx<='0';
							estado0<=3;
							estado<=idle;
							contador<=0;
						end if;
						
					when byte01=>	
						dataOut<=byte_01;
						enableRx<='1';
						if(contador<1)then
							contador<=contador+1;
							estado<=byte01;
						else
							enableRx<='0';
							estado0<=4;
							estado<=idle;
							contador<=0;
						end if;
						
					when byte02=>	
						dataOut<=byte_02;
						enableRx<='1';
						if(contador<1)then
							contador<=contador+1;
							estado<=byte02;
						else
							enableRx<='0';
							estado0<=5;
							estado<=idle;
							contador<=0;
							sensorDataIn<=0;							
						end if;						
					when others=>
						estado<=idle;
				end case;
			end if;
	end process;
end Behavioral;