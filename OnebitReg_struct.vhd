library IEEE;
use IEEE.std_logic_1164.all;

entity OnebitReg_struct is
   port(i_Reg            :  in std_logic;
        o_Reg            : out std_logic;
	r_Reg            : in std_logic;
	c_Reg            : in std_logic;
	e_Reg            : in std_logic);

end OnebitReg_struct;

architecture structural of OnebitReg_struct is

    component dffg is
       port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
    end component;

  
begin

      REGI: dffg port map(
	i_D => i_Reg, -- component => internal
        o_Q => o_Reg,
	i_RST => r_Reg,
	i_CLK => c_Reg,
	i_WE => e_Reg);
 

end structural;
