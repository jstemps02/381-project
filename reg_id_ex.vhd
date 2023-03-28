library IEEE;
use IEEE.std_logic_1164.all;

entity reg_id_ex is
port(i_ReadB         : in std_logic_vector(31 downto 0);
     i_ReadA          : in std_logic_vector(31 downto 0);
     i_SignExt        : in std_logic_vector(31 downto 0);
     i_rs             : in std_logic_vector(4 downto 0);
     i_rt          : in std_logic_vector(4 downto 0);
     i_rd         : in std_logic_vector(4 downto 0);
     i_clk	     : in std_logic;
     i_reset	     : in std_logic;
     i_WB_in	     : in std_logic;
     i_M_in	     : in std_logic;
     i_EX_in         : in std_logic;
     i_halt1         : in std_logic;
     i_JAL1          : in std_logic;
     i_mem2Reg1      : in std_logic;
     i_repl          : in std_logic_vector(7 downto 0);
     i_ALUOP          : in std_logic_vector(14 downto 0);
     i_ALUSrc          : in std_logic;
     i_Shift         : in std_logic;
     i_IF_Flush   : in std_logic;
     i_Ov1         : in std_logic;
     i_PC4_2       : in std_logic_vector(31 downto 0);
     i_jumpandbranch  : in std_logic;
     i_loadword  : in std_logic;
     o_loadword  : out std_logic;
     o_jumpandbranch  : out std_logic;
     o_PC4_2	     : out std_logic_vector(31 downto 0);
     o_Ov1      : out std_logic;
     o_Shift      : out std_logic;
     o_ALUSrc      : out std_logic;
     o_ALUOP          : out std_logic_vector(14 downto 0);
     o_repl          : out std_logic_vector(7 downto 0);
     o_mem2Reg1      : out std_logic;
     o_JAL1 	     : out std_logic;
     o_halt1	     : out std_logic;
     o_WB_out	     : out std_logic;
     o_M_out	     : out std_logic;
     o_EX_out        : out std_logic;
     o_rs             : out std_logic_vector(4 downto 0);
     o_rt          : out std_logic_vector(4 downto 0);
     o_rd         : out std_logic_vector(4 downto 0);
     o_ReadB	     : out std_logic_vector(31 downto 0);
     o_SignExt       : out std_logic_vector(31 downto 0);
     o_ReadA	     : out std_logic_vector(31 downto 0));

end reg_id_ex;

architecture structural of reg_id_ex is
	



	component FivebitReg_struct is
	port(i_Reg       : in std_logic_vector(4 downto 0);
        o_Reg            : out std_logic_vector(4 downto 0);
	r_Reg            : in std_logic;
	c_Reg            : in std_logic;
	e_Reg            : in std_logic);

	end component;

	component EightbitReg_struct is
	port(i_Reg            : in std_logic_vector(7 downto 0);
        o_Reg            : out std_logic_vector(7 downto 0);
	r_Reg            : in std_logic;
	c_Reg            : in std_logic;
	e_Reg            : in std_logic);
	end component;

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
 

	component FifteenbitReg_struct is
	port(i_Reg            : in std_logic_vector(14 downto 0);
        o_Reg            : out std_logic_vector(14 downto 0);
	r_Reg            : in std_logic;
	c_Reg            : in std_logic;
	e_Reg            : in std_logic);
	end component;

signal s_reset : std_logic;

begin

s_reset <= i_reset;

 Reg_SignExt: nbitreg_struct port map(
              i_Reg    => i_SignExt,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_SignExt);
 Reg_ReadB: nbitreg_struct port map(
              i_Reg    => i_ReadB,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_ReadB);

 Reg_ReadA: nbitreg_struct port map(
              i_Reg    => i_ReadA,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_ReadA);
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
 Reg_EX: OnebitReg_struct port map(
              i_Reg    => i_EX_in,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_EX_out);
 Reg_RS: FivebitReg_struct port map(
              i_Reg    => i_rs,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_rs);
 Reg_RT: FivebitReg_struct port map(
              i_Reg    => i_rt,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_rt);
 Reg_RD: FivebitReg_struct port map(
              i_Reg    => i_rd,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_rd);

 Reg_HALT1: OnebitReg_struct port map(
              i_Reg    => i_halt1,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_halt1);
 Reg_JAL1: OnebitReg_struct port map(
              i_Reg    => i_JAL1,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_JAL1);
 Reg_mem2Reg1: OnebitReg_struct port map(
              i_Reg    => i_mem2Reg1,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_mem2Reg1);

 Reg_REPL: EightbitReg_struct port map(
              i_Reg    => i_repl,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_repl);

 Reg_ALUOP: FifteenbitReg_struct port map(
              i_Reg    => i_ALUOP,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_ALUOP);


 Reg_ALUSrc: OnebitReg_struct port map(
              i_Reg    => i_ALUSrc,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_ALUSrc);

 Reg_Shift: OnebitReg_struct port map(
              i_Reg    => i_Shift,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_Shift);


 Reg_Ov1: OnebitReg_struct port map(
              i_Reg    => i_Ov1,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_Ov1);

 Reg_PC_4_2: nbitreg_struct port map(
              i_Reg    => i_PC4_2,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_PC4_2);


 Reg_JandB: OnebitReg_struct port map(
              i_Reg    => i_jumpandbranch,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_jumpandbranch);
 Reg_LW1: OnebitReg_struct port map(
              i_Reg    => i_loadword,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_loadword);


end structural;
