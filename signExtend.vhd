library IEEE;
use IEEE.std_logic_1164.all;

entity signExtend is
  port( i_N             : in std_logic_vector(15 downto 0);
	imm_S             : in std_logic;
        imm_O             : out std_logic_vector(31 downto 0));

end signExtend;


architecture structural of signExtend is

component mux2t1_struct is

  port(i_D0             : in std_logic;
       i_D1             : in std_logic;
       i_S              : in std_logic;
       o_OM             : out std_logic);
	end component;
signal MSB : std_logic;

begin
  M_1: mux2t1_struct
        port MAP(i_D0   => '0',
                 i_D1   => i_N(15),
       		 i_S    => imm_S,
        	 o_OM   => MSB);
 

imm_O(0) <= i_N(0);
imm_O(1) <= i_N(1);
imm_O(2) <= i_N(2);
imm_O(3) <= i_N(3);
imm_O(4) <= i_N(4);
imm_O(5) <= i_N(5);
imm_O(6) <= i_N(6);
imm_O(7) <= i_N(7);
imm_O(8) <= i_N(8);
imm_O(9) <= i_N(9);
imm_O(10) <= i_N(10);
imm_O(11) <= i_N(11);
imm_O(12) <= i_N(12);
imm_O(13) <= i_N(13);
imm_O(14) <= i_N(14);
imm_O(15) <= i_N(15);
imm_O(16) <= MSB;
imm_O(17) <= MSB;
imm_O(18) <= MSB;
imm_O(19) <= MSB;
imm_O(20) <= MSB;
imm_O(21) <= MSB;
imm_O(22) <= MSB;
imm_O(23) <= MSB;
imm_O(24) <= MSB;
imm_O(25) <= MSB;
imm_O(26) <= MSB;
imm_O(27) <= MSB;
imm_O(28) <= MSB;
imm_O(29) <= MSB;
imm_O(30) <= MSB;
imm_O(31) <= MSB;



end structural;