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

entity adder_Nmod is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_C          : in std_logic;
       i_X1         : in std_logic_vector(N-1 downto 0);
       i_X2         : in std_logic_vector(N-1 downto 0);
       o_S          : out std_logic_vector(N-1 downto 0);
       o_C          : out std_logic);

end adder_Nmod;

architecture structural of adder_Nmod is

  component adder_struct is
    port(i_C                  : in std_logic;
         i_X1                 : in std_logic;
         i_X2                 : in std_logic;
         o_S                  : out std_logic;
         o_C                  : out std_logic);
  end component;
  signal temp : std_logic_vector(N downto 0);

begin
  
  -- Instantiate N mux instances.
  G_NBit_ADDER: for i in 0 to N-1 generate
    ADDERI: adder_struct port map(
              i_C      => temp(i),      -- All instances share the same select input.
              i_X1     => i_X1(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_X2     => i_X2(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_S      => o_S(i),  -- ith instance's data output hooked up to ith data output.
	      o_C      => temp(i+1));
  end generate G_NBit_ADDER;
  temp(0) <= i_C;
  o_C <= temp(N) xor temp(N-1);
  
end structural;
