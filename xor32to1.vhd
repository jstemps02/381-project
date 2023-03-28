library IEEE;
use IEEE.std_logic_1164.all;

entity xor32to1 is
  port(i_N         : in std_logic_vector(31 downto 0);
       o_Xor       : out std_logic);
end xor32to1;

architecture structural of xor32to1 is
signal temp1, temp2, temp3 : std_logic;
begin


temp1 <= i_N(0) xor i_N(1) xor i_N(2) xor i_N(3) xor i_N(4) xor i_N(5) xor i_N(6) xor i_N(7) xor i_N(8) xor i_N(9);
temp2 <= i_N(10) xor i_N(11) xor i_N(12) xor i_N(13) xor i_N(14) xor i_N(15) xor i_N(16) xor i_N(17) xor i_N(18) xor i_N(19);
temp3 <= i_N(20) xor i_N(21) xor i_N(22) xor i_N(23) xor i_N(24) xor i_N(25) xor i_N(26) xor i_N(27) xor i_N(28) xor i_N(29) xor i_N(30) xor i_N(31);

o_Xor <= temp1 xor temp2 xor temp3;
end structural;
