library IEEE;
use IEEE.std_logic_1164.all;

entity and32to1 is
  port(i_N         : in std_logic_vector(31 downto 0);
       o_And       : out std_logic);
end and32to1;

architecture structural of and32to1 is
signal temp1, temp2, temp3 : std_logic;
begin


temp1 <= i_N(0) and i_N(1) and i_N(2) and i_N(3) and i_N(4) and i_N(5) and i_N(6) and i_N(7) and i_N(8) and i_N(9);
temp2 <= i_N(10) and i_N(11) and i_N(12) and i_N(13) and i_N(14) and i_N(15) and i_N(16) and i_N(17) and i_N(18) and i_N(19);
temp3 <= i_N(20) and i_N(21) and i_N(22) and i_N(23) and i_N(24) and i_N(25) and i_N(26) and i_N(27) and i_N(28) and i_N(29) and i_N(30) and i_N(31);

o_And <= temp1 and temp2 and temp3;
end structural;