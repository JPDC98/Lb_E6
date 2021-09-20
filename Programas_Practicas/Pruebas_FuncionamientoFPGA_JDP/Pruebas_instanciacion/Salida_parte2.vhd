----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:15:39 08/28/2021 
-- Design Name: 
-- Module Name:    Salida_parte2 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Salida_parte2 is
    Port ( entrada_2 : in  STD_LOGIC_VECTOR (7 downto 0);
           Salidas : out  STD_LOGIC_VECTOR (7 downto 0));
end Salida_parte2;

architecture Behavioral of Salida_parte2 is

begin

	Salidas <= entrada_2;

end Behavioral;

