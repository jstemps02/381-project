library IEEE;
use IEEE.std_logic_1164.all;

entity or32 is
  port(i_1         : in std_logic_vector(31 downto 0);
       i_2         : in std_logic_vector(31 downto 0);
       o_Or        : out std_logic_vector(31 downto 0));
end or32;

architecture structural of or32 is
begin
o_Or <= i_1 or i_2;
  
end structural;