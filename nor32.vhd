library IEEE;
use IEEE.std_logic_1164.all;

entity nor32 is
  port(i_1         : in std_logic_vector(31 downto 0);
       i_2         : in std_logic_vector(31 downto 0);
       o_Nor       : out std_logic_vector(31 downto 0));
end nor32;

architecture structural of nor32 is
begin
o_Nor <= not (i_1 or i_2);
  
end structural;
