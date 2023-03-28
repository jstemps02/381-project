library IEEE;
use IEEE.std_logic_1164.all;

entity equals32to1 is
  port(i_A         : in std_logic_vector(31 downto 0);
       i_B         : in std_logic_vector(31 downto 0);
       o_Equals    : out std_logic);
end equals32to1;

architecture structural of equals32to1 is
  signal s_N         : std_logic_vector(31 downto 0);
  signal s_Xor_temp  : std_logic_vector(31 downto 0);
  signal s_Not_equal : std_logic;



  component or32to1 is
    port(i_N         : in std_logic_vector(31 downto 0);
         o_Or       : out std_logic);
  end component;

  component xorg2 is

    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

begin



s_Xor_temp <= i_A xor i_B;

  IS_NOT_ZERO: or32to1 port map(
	i_N    	=> s_Xor_temp,
	o_Or	=> s_Not_equal);

  IS_ZERO: xorg2 port map(
	i_A	=> s_Not_equal,
	i_B	=> '1',
	o_F	=> o_Equals);

end structural;
