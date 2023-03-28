library IEEE;
use IEEE.std_logic_1164.all;

entity decoder5to32 is
  port(i_S             : in std_logic_vector(4 downto 0);
       i_En             : in std_logic;
       o_O             : out std_logic_vector(31 downto 0));

end decoder5to32;

architecture dataflow of decoder5to32 is

signal internmed  : std_logic_vector(31 downto 0);
begin 

with i_S select
   internmed <= x"0000_0001" when b"00000",
    x"0000_0002" when b"00001",
    x"0000_0004" when b"00010",
    x"0000_0008" when b"00011",
    x"0000_0010" when b"00100",
    x"0000_0020" when b"00101",
    x"0000_0040" when b"00110",
    x"0000_0080" when b"00111",
    x"0000_0100" when b"01000",
    x"0000_0200" when b"01001",
    x"0000_0400" when b"01010",
    x"0000_0800" when b"01011",
    x"0000_1000" when b"01100",
    x"0000_2000" when b"01101",
    x"0000_4000" when b"01110",
    x"0000_8000" when b"01111",
    x"0001_0000" when b"10000",
    x"0002_0000" when b"10001",
    x"0004_0000" when b"10010",
    x"0008_0000" when b"10011",
    x"0010_0000" when b"10100",
    x"0020_0000" when b"10101",
    x"0040_0000" when b"10110",
    x"0080_0000" when b"10111",
    x"0100_0000" when b"11000",
    x"0200_0000" when b"11001",
    x"0400_0000" when b"11010",
    x"0800_0000" when b"11011",
    x"1000_0000" when b"11100",
    x"2000_0000" when b"11101",
    x"4000_0000" when b"11110",
    x"8000_0000" when b"11111",


    x"0000_0000" when others;

with i_En select
 o_O <= internmed when '1',
 x"0000_0000" when others;

    
end dataflow;