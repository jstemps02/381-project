library IEEE;
use IEEE.std_logic_1164.all;

entity or5to1 is
  port(i_N         : in std_logic_vector(4 downto 0);
       o_Or        : out std_logic);
end or5to1;

architecture structural of or5to1 is
begin

o_Or <= i_N(0) or i_N(1) or i_N(2) or i_N(3) or i_N(4);

end structural;
