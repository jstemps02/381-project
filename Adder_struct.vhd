library IEEE;
use IEEE.std_logic_1164.all;

entity adder_struct is

  port(i_X1             : in std_logic;
       i_X2             : in std_logic;
       i_C              : in std_logic;
       o_S              : out std_logic;
       o_C              : out std_logic);

end adder_struct;

architecture structural of adder_struct is

    component xorg2 is
  	port(i_A          : in std_logic;
        i_B          : in std_logic;
        o_F          : out std_logic);
    end component;

    component andg2 is
  	port(i_A     : in std_logic;
        i_B          : in std_logic;
        o_F          : out std_logic);
    end component;

    component org2 is
  	port(i_A     : in std_logic;
        i_B          : in std_logic;
        o_F          : out std_logic);
    end component;

 -- Signal to carry stored weight

  signal s_X1         : std_logic;
  signal s_X2         : std_logic;
  signal s_iC	      : std_logic;

  signal s_XP1	      : std_logic;

  signal s_AP1	      : std_logic;

  signal s_AP2	      : std_logic;
  signal s_oS	      : std_logic;
  signal s_oC	      : std_logic;
  
begin
  s_iC <= i_C;
  X_1: xorg2
     port MAP(i_A	=> i_X1,
	      i_B	=> i_X2,
	      o_F	=> s_XP1);
  A_1: andg2
     port MAP(i_A	=> i_X1,
	      i_B	=> i_X2,
	      o_F	=> s_AP1);
  A_2: andg2
     port MAP(i_A	=> s_XP1,
	      i_B	=> s_iC,
	      o_F	=> s_AP2);
  X_2: xorg2
     port MAP(i_A	=> s_XP1,
	      i_B	=> s_iC,
	      o_F	=> s_oS);
  O_1: org2
     port MAP(i_A	=> s_AP1,
	      i_B	=> s_AP2,
	      o_F	=> s_oC);
 o_C <= s_oC;
 o_S <= s_oS;

end structural;