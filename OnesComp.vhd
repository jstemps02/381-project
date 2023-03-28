library IEEE;
use IEEE.std_logic_1164.all;

entity OnesComp is
port(i_N                  : in std_logic;
     o_O                  : out std_logic);

end OnesComp;

architecture structural of OnesComp is
    component invg is
    port(i_A                  : in std_logic;
         o_F                  : out std_logic);
    end component;
begin
  N_1: invg
     port MAP(i_A	=> i_N,
	      o_F	=> o_O);


end structural;