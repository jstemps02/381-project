library IEEE;
use IEEE.std_logic_1164.all;

entity and5 is
  port(i_1         : in std_logic_vector(4 downto 0);
       i_2         : in std_logic_vector(4 downto 0);
       o_And       : out std_logic_vector(4 downto 0));
end and5;

architecture structural of and5 is
begin
o_And <= i_1 and i_2;
  
end structural;
