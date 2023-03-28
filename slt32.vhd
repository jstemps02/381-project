library IEEE;
use IEEE.std_logic_1164.all;

entity slt32 is
  port(i_sltA         : in std_logic_vector(31 downto 0);
       i_sltB         : in std_logic_vector(31 downto 0);
       o_slt          : out std_logic_vector(31 downto 0));
end slt32;



architecture structural of slt32 is

  component addsub_n is
  generic(N : integer := 32);
  port(nAdd_Sub    : in std_logic;
       i_A         : in std_logic_vector(N-1 downto 0);
       i_B         : in std_logic_vector(N-1 downto 0);
       o_S         : out std_logic_vector(N-1 downto 0);
       o_C         : out std_logic);
  end component;

signal s_C, msb : std_logic;
signal temp : std_logic_vector(31 downto 0);
begin
SUB: addsub_n
port MAP(nAdd_Sub => '1',
       i_A  => i_sltA,
       i_B  => i_sltB,
       o_S   => temp,
       o_C   => s_C);

msb <= temp(31);
with msb select o_slt <= 
    x"00000001" when '1',
    x"00000000" when others;
  
end structural;