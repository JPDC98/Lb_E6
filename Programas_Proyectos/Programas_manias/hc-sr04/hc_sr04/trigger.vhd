
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;	

entity trigger is
	 generic(
				trigger_cont: integer:=120
				);
    Port ( clk_trigger : in  STD_LOGIC;
           enable_trigger : in  STD_LOGIC;
           in_trigger : in  STD_LOGIC;
			  bussyT: out STD_LOGIC:='1';-- Indica cuando se encuentre ocupado estado 0 y cuando es libre estado 1
           out_trigger : out  STD_LOGIC:='0');
			  
end trigger;

architecture Behavioral of trigger is
type trigger is (idle,start,stop);
signal estado:trigger:= idle;
signal t_contador: integer range 0 to 200:=0; --contador para 10uS
begin
	process(clk_trigger)
	begin
		if(rising_edge(clk_trigger)) then
			case estado is
				when idle=>
					out_trigger<='0';
					bussyT<='1';--NO esta realizando nada 
					t_contador<= 0;
					if(enable_trigger='1' and in_trigger='0') then
						estado<=start;
						bussyT<='0';--Empieza el pulso de 10us
					else
						estado<=idle;
					end if;
				when start=>
					out_trigger<='1';
					if(t_contador<trigger_cont+1)then
						t_contador<=t_contador+1;
						estado<=start;
					else
						out_trigger<='0';
						t_contador<=0;
						bussyT<='1';
						estado<=stop;
					end if;	
				when stop=>
					if(in_trigger='0')then
						estado<=stop;
					else
						estado<=idle;
					end if;
				when others=>
					estado<= idle;
			end case;			
		end if;
	end process;

end Behavioral;

