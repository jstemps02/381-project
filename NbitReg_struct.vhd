library IEEE;
use IEEE.std_logic_1164.all;

entity NbitReg_struct is
generic(N : integer := 16);
port(i_Reg            : in std_logic_vector(N-1 downto 0);
        o_Reg            : out std_logic_vector(N-1 downto 0);
	r_Reg            : in std_logic;
	c_Reg            : in std_logic;
	e_Reg            : in std_logic);

end NbitReg_struct;

architecture structural of NbitReg_struct is

    component dffg is
       port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
    end component;

  
begin
  NBitReg: for i in 0 to N-1 generate
      REGI: dffg port map(
	i_D => i_Reg(i), -- component => internal
        o_Q => o_Reg(i),
	i_RST => r_Reg,
	i_CLK => c_Reg,
	i_WE => e_Reg);
  end generate NBitReg;

end structural;