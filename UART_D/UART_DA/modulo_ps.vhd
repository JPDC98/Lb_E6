library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
	generic( clock: integer:= 12000000;--Frecuencia de reloj
				baudRate: integer := 115200;--Velocidad de uart
				nbits: integer:=8;-- Cantidad de bits a enviar
				tiempoBit:integer := 104-- clock/baudRate=104.1667 Tiempo de cada bit	
	);
    Port ( datos : in  STD_LOGIC_VECTOR (7 downto 0);--Entrada en paralelo de datos
           datosOut: out STD_LOGIC_VECTOR(7 downto 0);--Datos en paralelo
			  clk : in  STD_LOGIC;--Entrada de reloj 12MHz			  
			  enable: in STD_LOGIC;--Habilitador de envio SW1
			  txOcupado: out STD_LOGIC;--Se coloca en estado alto mientras envia			 
           txSerial : out  STD_LOGIC);--Salida TX del uart
end uart_tx;

architecture Behavioral of uart_tx is
	type uart_tx is (idle,start,data,stop);
	signal estados:uart_tx:=idle;
	signal t_Bit: integer range 0 to tiempoBit-1:=0;-- contador de tiempo de bit
	signal n_Bit: integer range 0 to nbits-1:=0;--contador de posicion de bit
	signal byte_Uart: STD_LOGIC_VECTOR(7 downto 0):=(others => '0');-- copia los dato de la entrada paralela
begin

	uartTx: process(clk)
	begin 
		if(rising_edge(clk)) then
			case estados is 
				when idle=>
					txSerial<='1';
					t_Bit<=0;
					n_Bit<=0;
					byte_Uart<=(others => '0');
					if(enable='0') then
						byte_Uart<=datos;
						datosOut<=datos;
						estados<=start;
					else 
						estados<=idle;
					end if;
					
				when start=>
					txOcupado<='1';
					txSerial<='0';
					if(t_Bit<tiempoBit-1) then
						t_Bit<=t_Bit+1;
						estados<=start;
					else
						t_Bit<=0;
						estados<=data;
					end if;						
				
				when data=>
					txSerial<=byte_Uart(n_Bit);
					if(t_Bit<tiempoBit-1)then
						t_Bit<=t_Bit+1;
						estados<=data;
					else
						t_Bit<=0;
						if(n_Bit<nbits-1) then
							n_Bit<=n_Bit+1;
							estados<=data;
						else
							n_Bit<=0;
							estados<=stop;
						end if;
					end if;						
				
				when stop=>
					txSerial<='1';
					if(t_Bit<tiempoBit-1)then
						t_Bit<=t_Bit+1;
						estados<=stop;
					else
						t_Bit<=0;
						txOcupado<='0';
						estados<=idle;
					end if;					
				when others=>
					estados<=idle;
			end case;
		end if;	
	end process uartTx;
end Behavioral;

