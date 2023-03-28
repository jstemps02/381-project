library IEEE;
use IEEE.std_logic_1164.all;

entity equals5to1 is
  port(i_A         : in std_logic_vector(4 downto 0);
       i_B         : in std_logic_vector(4 downto 0);
       o_Equals    : out std_logic);
end equals5to1;

architecture structural of equals5to1 is
  signal s_N         : std_logic_vector(4 downto 0);
  signal s_Xor_temp  : std_logic_vector(4 downto 0);
  signal s_Not_equal : std_logic;

  component xor5 is
    port(i_1       : in std_logic_vector(4 downto 0);
         i_2       : in std_logic_vector(4 downto 0);
         o_Xor     : out std_logic_vector(4 downto 0));
  end component;

  component or5to1 is
    port(i_N         : in std_logic_vector(4 downto 0);
         o_Or       : out std_logic);
  end component;

  component xorg2 is

    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

begin

  XOR_5: xor5 port map(
	i_1    	=> i_A,
	i_2	=> i_B,
	o_Xor	=> s_Xor_temp);

  IS_NOT_ZERO: or5to1 port map(
	i_N    	=> s_Xor_temp,
	o_Or	=> s_Not_equal);

  IS_ZERO: xorg2 port map(
	i_A	=> s_Not_equal,
	i_B	=> '1',
	o_F	=> o_Equals);

end structural;
