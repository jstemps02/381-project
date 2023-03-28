library IEEE;
use IEEE.std_logic_1164.all;

entity subu32 is
  port(i_subA         : in std_logic_vector(31 downto 0);
       i_subB         : in std_logic_vector(31 downto 0);
       o_sub          : out std_logic_vector(31 downto 0));
end subu32;



architecture structural of subu32 is

  component adder_N is
  generic(N : integer := 32);
  port(i_C          : in std_logic;
       i_X1         : in std_logic_vector(N-1 downto 0);
       i_X2         : in std_logic_vector(N-1 downto 0);
       o_S          : out std_logic_vector(N-1 downto 0);
       o_C          : out std_logic);
  end component;

  component OnesComp_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_N         : in std_logic_vector(N-1 downto 0);
       o_O         : out std_logic_vector(N-1 downto 0));
  end component;

signal s_C, msb : std_logic;
signal temp, outSigned : std_logic_vector(31 downto 0);
begin

ONC: OnesComp_N
  port map(i_N   => i_subB,
       o_O       =>  temp);
SUB: adder_N
port map(     i_C      => '0',      -- All instances share the same select input.
              i_X1     => i_subA,  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_X2     => temp,  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_S      => outSigned,  -- ith instance's data output hooked up to ith data output.
	      o_C      => s_C);
ONC2: OnesComp_N
  port map(i_N   => outSigned,
       o_O       =>  o_sub);

end structural;