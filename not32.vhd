library IEEE;
use IEEE.std_logic_1164.all;

entity not32 is
  port(i_n         : in std_logic_vector(31 downto 0);
       o_Not       : out std_logic_vector(31 downto 0));
end not32;

architecture structural of not32 is
begin
o_Not <= not i_n;
  
end structural;