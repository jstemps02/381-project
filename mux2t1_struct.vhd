library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_struct is

  port(i_D0             : in std_logic;
       i_D1             : in std_logic;
       i_S              : in std_logic;
       o_OM              : out std_logic);

end mux2t1_struct;

architecture structural of mux2t1_struct is

    component invg is
  	port(i_A          : in std_logic;
        o_F          : out std_logic);
    end component;

    component andg2 is
        port(i_A	: in std_logic;
        i_B		: in std_logic;
        o_F		: out std_logic);
    end component;

    component org2 is
        port(i_A	: in std_logic;
        i_B		: in std_logic;
        o_F		: out std_logic);
    end component;

 -- Signal to carry stored weight
  signal s_N1         : std_logic;
  -- Signals to carry delayed X
  signal s_A1, s_A2   : std_logic;
  
begin
  N_1: invg
     port MAP(i_A	=> i_S,
              o_F       => s_N1);

  A_1: andg2
     port MAP(i_A	=> i_D1,
	      i_B	=> i_S,
	      o_F	=> s_A1);
  A_2: andg2
     port MAP(i_A	=> i_D0,
	      i_B	=> s_N1,
	      o_F	=> s_A2);
  O_1: org2
     port MAP(i_A	=> s_A1,
	      i_B	=> s_A2,
	      o_F	=> o_OM);

end structural;