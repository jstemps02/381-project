library IEEE;
use IEEE.std_logic_1164.all;

entity xor5 is
  port(i_1         : in std_logic_vector(4 downto 0);
       i_2         : in std_logic_vector(4 downto 0);
       o_Xor       : out std_logic_vector(4 downto 0));
end xor5;

architecture structural of xor5 is
begin
o_Xor <= i_1 xor i_2;
  
end structural;
