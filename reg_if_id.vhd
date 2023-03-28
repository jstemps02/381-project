library IEEE;
use IEEE.std_logic_1164.all;

entity reg_if_id is
port(i_PC_4          : in std_logic_vector(31 downto 0);
     i_Inst          : in std_logic_vector(31 downto 0);
     i_clk	     : in std_logic;
     i_IF_Flush	     : in std_logic;
     i_reset	     : in std_logic;
     i_IFID_Hazard   : in std_logic;
     o_Inst_Out	     : out std_logic_vector(31 downto 0);
     o_PC_4_Out	     : out std_logic_vector(31 downto 0));

end reg_if_id;

architecture structural of reg_if_id is
	
	component nbitreg_struct is
		generic(N : integer := 32);
		port(i_Reg       : in std_logic_vector(31 downto 0);
       		o_Reg            : out std_logic_vector(31 downto 0);
		r_Reg            : in std_logic;
		c_Reg            : in std_logic;
		e_Reg            : in std_logic);
	end component;
signal s_reset : std_logic;
signal s_inst_temp : std_logic_vector(31 downto 0);

begin

s_reset <= i_reset;

s_inst_temp <= i_Inst when i_IF_Flush = '0' else x"00000000";


 PC4: nbitreg_struct port map(
              i_Reg    => i_PC_4,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => i_IFID_Hazard,
	      o_Reg    => o_PC_4_Out);

 Instruct: nbitreg_struct port map(
              i_Reg    => s_inst_temp,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => i_IFID_Hazard,
	      o_Reg    => o_Inst_Out);



end structural;
