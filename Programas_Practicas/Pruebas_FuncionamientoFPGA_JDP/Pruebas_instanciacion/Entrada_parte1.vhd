----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:13:25 08/28/2021 
-- Design Name: 
-- Module Name:    Entrada_parte1 - Behavioral 
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

entity Entrada_parte1 is
    Port ( Entradas : in  STD_LOGIC_VECTOR (7 downto 0);
           salida1 : out  STD_LOGIC_VECTOR (7 downto 0));
end Entrada_parte1;

architecture Behavioral of Entrada_parte1 is

begin

	salida1 <= Entradas;

end Behavioral;

