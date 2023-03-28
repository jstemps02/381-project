-------------------------------------------------------------------------
-- Jacob Lyons jplyons1
-------------------------------------------------------------------------


-- sll2_32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural VHDL implementation of a 
-- shifter that shifts the input left by 2.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity sll2_32 is

  port(i_In     : in std_logic_vector(31 downto 0);	--Value input before shifting
       o_Out    : out std_logic_vector(31 downto 0));	--Value output after shifting

end sll2_32;

architecture structural of sll2_32 is

begin

   o_Out(31) <= i_In(29);
   o_Out(30) <= i_In(28);
   o_Out(29) <= i_In(27);
   o_Out(28) <= i_In(26);
   o_Out(27) <= i_In(25);
   o_Out(26) <= i_In(24);
   o_Out(25) <= i_In(23);
   o_Out(24) <= i_In(22);
   o_Out(23) <= i_In(21);
   o_Out(22) <= i_In(20);
   o_Out(21) <= i_In(19);
   o_Out(20) <= i_In(18);
   o_Out(19) <= i_In(17);
   o_Out(18) <= i_In(16);
   o_Out(17) <= i_In(15);
   o_Out(16) <= i_In(14);
   o_Out(15) <= i_In(13);
   o_Out(14) <= i_In(12);
   o_Out(13) <= i_In(11);
   o_Out(12) <= i_In(10);
   o_Out(11) <= i_In(9);
   o_Out(10) <= i_In(8);
   o_Out(9) <= i_In(7);
   o_Out(8) <= i_In(6);
   o_Out(7) <= i_In(5);
   o_Out(6) <= i_In(4);
   o_Out(5) <= i_In(3);
   o_Out(4) <= i_In(2);
   o_Out(3) <= i_In(1);
   o_Out(2) <= i_In(0);
   o_Out(1) <= '0';
   o_Out(0) <= '0';
  
end structural;
