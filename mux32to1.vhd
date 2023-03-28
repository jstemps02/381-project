library IEEE;
use IEEE.std_logic_1164.all;

entity mux32to1 is
  port(i_S             : in std_logic_vector(4 downto 0);
       i_M             : in std_logic_vector(31 downto 0);
       o_O             : out std_logic);

end mux32to1;

architecture dataflow of mux32to1 is
begin 
with i_S select
   o_O <= i_M(0) when b"00000",
	i_M(1) when b"00001",
	i_M(2) when b"00010",
	i_M(3) when b"00011",
	i_M(4) when b"00100",
	i_M(5) when b"00101",
	i_M(6) when b"00110",
	i_M(7) when b"00111",
	i_M(8) when b"01000",
	i_M(9) when b"01001",
	i_M(10) when b"01010",
	i_M(11) when b"01011",
	i_M(12) when b"01100",
	i_M(13) when b"01101",
	i_M(14) when b"01110",
	i_M(15) when b"01111",
	i_M(16) when b"10000",
	i_M(17) when b"10001",
	i_M(18) when b"10010",
	i_M(19) when b"10011",
	i_M(20) when b"10100",
	i_M(21) when b"10101",
	i_M(22) when b"10110",
	i_M(23) when b"10111",
	i_M(24) when b"11000",
	i_M(25) when b"11001",
	i_M(26) when b"11010",
	i_M(27) when b"11011",
	i_M(28) when b"11100",
	i_M(29) when b"11101",
	i_M(30) when b"11110",
	i_M(31) when b"11111",
   	'0' when others;

end dataflow;