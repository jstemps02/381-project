library IEEE;
use IEEE.std_logic_1164.all;

entity or32to1 is
  port(i_N         : in std_logic_vector(31 downto 0);
       o_Or       : out std_logic);
end or32to1;

architecture structural of or32to1 is
signal temp1, temp2, temp3 : std_logic;
begin


temp1 <= i_N(0) or i_N(1) or i_N(2) or i_N(3) or i_N(4) or i_N(5) or i_N(6) or i_N(7) or i_N(8) or i_N(9);
temp2 <= i_N(10) or i_N(11) or i_N(12) or i_N(13) or i_N(14) or i_N(15) or i_N(16) or i_N(17) or i_N(18) or i_N(19);
temp3 <= i_N(20) or i_N(21) or i_N(22) or i_N(23) or i_N(24) or i_N(25) or i_N(26) or i_N(27) or i_N(28) or i_N(29) or i_N(30) or i_N(31);

o_Or <= temp1 or temp2 or temp3;
end structural;
