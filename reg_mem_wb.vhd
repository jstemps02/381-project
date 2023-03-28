library IEEE;
use IEEE.std_logic_1164.all;

entity reg_mem_wb is
port(i_DMEM_DATA     : in std_logic_vector(31 downto 0);
     i_DMEM_ADDR     : in std_logic_vector(31 downto 0);
     i_clk	     : in std_logic;
     i_reset	     : in std_logic;
     i_WB_in	     : in std_logic;
     i_writeRegMEMWB : in std_logic_vector(4 downto 0);
     i_halt3         : in std_logic;
     i_JAL3          : in std_logic;
     i_mem2Reg3          : in std_logic;
     i_Ov_MEMWB      : in std_logic;
     i_PC4_4       : in std_logic_vector(31 downto 0);
     i_IF_Flush   : in std_logic;
     o_PC4_4	     : out std_logic_vector(31 downto 0);
     o_Ov_MEMWB      : out std_logic;
     o_mem2Reg3 	     : out std_logic;
     o_JAL3 	     : out std_logic;
     o_halt3	     : out std_logic;
     o_writeRegMEMWB : out std_logic_vector(4 downto 0);
     o_WB_out	     : out std_logic;
     o_DMEM_ADDR     : out std_logic_vector(31 downto 0);
     o_DMEM_DATA     : out std_logic_vector(31 downto 0));


end reg_mem_wb;

architecture structural of reg_mem_wb is
	



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

 Reg_DMEM_OUT: nbitreg_struct port map(
              i_Reg    => i_DMEM_DATA,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_DMEM_DATA);

 Reg_DMEM_AROUND: nbitreg_struct port map(
              i_Reg    => i_DMEM_ADDR,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_DMEM_ADDR);
 Reg_WB: OnebitReg_struct port map(
              i_Reg    => i_WB_in,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_WB_out);
 Reg_WriteRegMEMWB: FivebitReg_struct port map(
              i_Reg    => i_writeRegMEMWB,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_writeRegMEMWB);

 Reg_HALT3: OnebitReg_struct port map(
              i_Reg    => i_halt3,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_halt3);
 Reg_JAL3: OnebitReg_struct port map(
              i_Reg    => i_JAL3,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_JAL3);
 Reg_mem2Reg3: OnebitReg_struct port map(
              i_Reg    => i_mem2Reg3,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_mem2Reg3);

 Reg_OvMEMWB: OnebitReg_struct port map(
              i_Reg    => i_Ov_MEMWB,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_Ov_MEMWB);
 Reg_PC_4_4: nbitreg_struct port map(
              i_Reg    => i_PC4_4,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => '1',
	      o_Reg    => o_PC4_4);


end structural;
