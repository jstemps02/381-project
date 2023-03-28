-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity OnesComp_N is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_N         : in std_logic_vector(N-1 downto 0);
       o_O         : out std_logic_vector(N-1 downto 0));

end OnesComp_N;

architecture structural of OnesComp_N is

  component OnesComp is
    port(i_N                  : in std_logic;
         o_O                  : out std_logic);
  end component;

begin

  -- Instantiate N mux instances.
  G_NBit_OCN: for i in 0 to N-1 generate
    OCN: OnesComp port map(
              i_N     => i_N(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              o_O      => o_O(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_OCN;
  
end structural;