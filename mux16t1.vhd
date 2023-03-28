library IEEE;
use IEEE.std_logic_1164.all;

entity mux16to1 is
  port(i_S             : in std_logic_vector(3 downto 0);
       i_M0            : in std_logic_vector(31 downto 0);
       i_M1            : in std_logic_vector(31 downto 0);
       i_M2            : in std_logic_vector(31 downto 0);
       i_M3            : in std_logic_vector(31 downto 0);
       i_M4            : in std_logic_vector(31 downto 0);
       i_M5            : in std_logic_vector(31 downto 0);
       i_M6            : in std_logic_vector(31 downto 0);
       i_M7            : in std_logic_vector(31 downto 0);
       i_M8            : in std_logic_vector(31 downto 0);
       i_M9            : in std_logic_vector(31 downto 0);
       i_M10            : in std_logic_vector(31 downto 0);
       i_M11            : in std_logic_vector(31 downto 0);
       i_M12            : in std_logic_vector(31 downto 0);
       i_M13            : in std_logic_vector(31 downto 0);
       i_M14            : in std_logic_vector(31 downto 0);
       i_M15            : in std_logic_vector(31 downto 0);
       o_O             : out std_logic_vector(31 downto 0));

end mux16to1;

architecture dataflow of mux16to1 is
begin 
with i_S select
   o_O <= i_M0 when b"0000",
	i_M1 when b"0001",
	i_M2 when b"0010",
	i_M3 when b"0011",
	i_M4 when b"0100",
	i_M5 when b"0101",
	i_M6 when b"0110",
	i_M7 when b"0111",
	i_M8 when b"1000",
	i_M9 when b"1001",
	i_M10 when b"1010",
	i_M11 when b"1011",
	i_M12 when b"1100",
	i_M13 when b"1101",
	i_M14 when b"1110",
	i_M15 when b"1111",
   	x"00000000" when others;

end dataflow;