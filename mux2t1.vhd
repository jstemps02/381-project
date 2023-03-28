-------------------------------------------------------------------------
-- Jacob Lyons jplyons1
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- 2to1muxStructural.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural VHDL implementation of a 
-- 2-to-1 Multiplexer
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is

  port(i_S          : in std_logic;
       i_D0         : in std_logic;
       i_D1         : in std_logic;
       o_O          : out std_logic);

end mux2t1;

architecture structural of mux2t1 is

  signal A, B, C : std_logic;

  component andg2 is

    port(i_A          : in std_logic;
      i_B          : in std_logic;
      o_F          : out std_logic);
  end component;

  component invg is

  port(i_A          : in std_logic;
      o_F          : out std_logic);
  end component;

  component org2 is

    port(i_A          : in std_logic;
      i_B          : in std_logic;
      o_F          : out std_logic);
  end component;

begin
    L1: invg port map(i_A => i_S, o_F => A);
    L2: andg2 port map(i_A => i_S, i_B => i_D1, o_F => B);
    L3: andg2 port map(i_A => A, i_B => i_D0, o_F => C);
    L4: org2 port map(i_A => B, i_B => C, o_F => o_O);
  
end structural;
