library IEEE;
use IEEE.std_logic_1164.all;

entity reg_ex_mem is
port(i_ALU2Reg         : in std_logic_vector(31 downto 0);
     i_ALUIn2          : in std_logic_vector(31 downto 0);
     i_clk	     : in std_logic;
     i_reset	     : in std_logic;
     i_WB_in	     : in std_logic;
     i_M_in	     : in std_logic;
     i_halt2         : in std_logic;
     i_JAL2          : in std_logic;
     i_mem2Reg2      : in std_logic;
     i_Ov_EXMEM      : in std_logic;
     i_PC4_3       : in std_logic_vector(31 downto 0);
     i_IF_Flush   : in std_logic;
     i_loadword  : in std_logic;
     o_loadword  : out std_logic;
     o_PC4_3	     : out std_logic_vector(31 downto 0);
     o_Ov_EXMEM      : out std_logic;
     o_mem2Reg2      : out std_logic;
     o_JAL2 	     : out std_logic;
     o_halt2	     : out std_logic;
     o_WB_out	     : out std_logic;
     o_M_out	     : out std_logic;
     i_writeRegEXMEM             : in std_logic_vector(4 downto 0);
     o_writeRegEXMEM             : out std_logic_vector(4 downto 0);
     o_DMEMAddr	     : out std_logic_vector(31 downto 0);
     o_DMEMData	     : out std_logic_vector(31 downto 0));

end reg_ex_mem;

architecture structural of reg_ex_mem is
	
	component nbitreg_struct is
		generic(N : integer := 32);
		port(i_Reg       : in std_logic_vector(31 downto 0);
       		o_Reg            : out std_logic_vector(31 downto 0);
		r_Reg            : in std_logic;
		c_Reg            : in std_logic;
		e_Reg            : in std_logic);
	end component;
	component OnebitReg_struct is
		port(i_Reg       : in std_logic;
       		o_Reg            : out std_logic;
		r_Reg            : in std_logic;
		c_Reg            : in std_logic;
		e_Reg            : in std_logic);
	end component;
	component FivebitReg_struct is
	port(i_Reg       : in std_logic_vector(4 downto 0);
        o_Reg            : out std_logic_vector(4 downto 0);
	r_Reg            : in std_logic;
	c_Reg            : in std_logic;
	e_Reg            : in std_logic);

	end component;
signal s_reset : std_logic;

begin

s_reset <= i_reset;

 Reg_ALUVal: nbitreg_struct port map(
              i_Reg    => i_ALU2Reg,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_DMEMAddr);

 Reg_ReadB_AROUND: nbitreg_struct port map(
              i_Reg    => i_ALUIn2,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_DMEMData);
 Reg_WB: OnebitReg_struct port map(
              i_Reg    => i_WB_in,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_WB_out);
 Reg_M: OnebitReg_struct port map(
              i_Reg    => i_M_in,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_M_out);
 Reg_WriteRegEXMEM: FivebitReg_struct port map(
              i_Reg    => i_writeRegEXMEM,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_writeRegEXMEM);
 Reg_HALT2: OnebitReg_struct port map(
              i_Reg    => i_halt2,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_halt2);
 Reg_JAL2: OnebitReg_struct port map(
              i_Reg    => i_JAL2,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_JAL2);
 Reg_mem2Reg2: OnebitReg_struct port map(
              i_Reg    => i_mem2Reg2,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_mem2Reg2);
 Reg_OvEXMEM: OnebitReg_struct port map(
              i_Reg    => i_Ov_EXMEM,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_Ov_EXMEM);

 Reg_PC_4_3: nbitreg_struct port map(
              i_Reg    => i_PC4_3,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_PC4_3);

 Reg_LW2: OnebitReg_struct port map(
              i_Reg    => i_loadword,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_loadword);

end structural;
