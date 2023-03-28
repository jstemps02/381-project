-------------------------------------------------------------------------
-- Jacob Lyons jplyons1
-------------------------------------------------------------------------


-- fetchLogic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural VHDL implementation of
-- the CPU's fetch logic
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fetchLogic is						--Instantiate this once all of the below values are known on the main processor (Zero from the ALU is likely to be last)

  port(i_Instruction	: in std_logic_vector(25 downto 0);	--Last 26 bits of the input instruction
       i_Sign_Ext	: in std_logic_vector(31 downto 0);	--Output of the sign extender
       i_Branch		: in std_logic;				--Branch control value
       i_Zero		: in std_logic;				--Branch control value
       i_Jump		: in std_logic;				--Value of the Jump control signal
       i_jr             : in std_logic;		
       i_PC_4           : in std_logic_vector(31 downto 0);
       i_JR_Reg         : in std_logic_vector(31 downto 0);
       i_JR_RegForward    : in std_logic_vector(31 downto 0);
       i_jrForwardSignal : in std_logic;		
       o_Pc    		: out std_logic_vector(31 downto 0));	--Next PC value to use, will be i_PC + 4 unless there is a branch

end fetchLogic;

architecture structural of fetchLogic is

  signal s_PC_4, s_post_jump   	: std_logic_vector(31 downto 0); 	--PC + 4
  signal s_Mux_In	: std_logic_vector(31 downto 0); 	--Value that goes into the branch mux
  signal s_Shifted_Inst : std_logic_vector(27 downto 0); 	--Instruction after being shifted left 2
  signal s_Shifted_Sign : std_logic_vector(31 downto 0); 	--Sign-extended value after being shifted left 2
  signal s_Jump_Address : std_logic_vector(31 downto 0); 	--Jump address
  signal s_ALU_Result 	: std_logic_vector(31 downto 0); 	--Result of the right (ALU) adder
  signal s_Mux_Result_1	: std_logic_vector(31 downto 0); 	--Result of the first MUX in the fetch logic
  signal s_Branch_Zero	: std_logic;				--Result of the and gate that ands the Zero output of the ALU with the Branch control value
  signal s_Carry	: std_logic;				--Adder carry values; are not used for anything
  signal s_JR_VAL : std_logic_vector(31 downto 0);

  component adder_N is
    generic(N : integer := 32);
    port(i_C        	: in std_logic;
         i_X1       	: in std_logic_vector(N-1 downto 0);
         i_X2       	: in std_logic_vector(N-1 downto 0);
         o_S        	: out std_logic_vector(N-1 downto 0);
         o_C        	: out std_logic);
  end component;

  component sll2_32 is
    port(i_In     	: in std_logic_vector(31 downto 0);	--Value input before shifting
         o_Out    	: out std_logic_vector(31 downto 0));	--Value output after shifting
  end component;

  component sll2_26 is
    port(i_In     	: in std_logic_vector(25 downto 0);	--Value input before shifting
         o_Out    	: out std_logic_vector(27 downto 0));	--Value output after shifting
  end component;

  component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;


  component mux2t1_N is
    generic(N : integer := 32);
    port(i_S    	: in std_logic;
         i_D0   	: in std_logic_vector(N-1 downto 0);
         i_D1   	: in std_logic_vector(N-1 downto 0);
         o_O    	: out std_logic_vector(N-1 downto 0));
  end component;

begin
 s_PC_4 <= i_PC_4;
 s_jump_Address <= s_PC_4(31 downto 28) & i_Instruction(25 downto 0) & "00";



  SL2_2 : sll2_32 port map(
	i_In	=> i_Sign_Ext,
	o_Out	=> s_Shifted_Sign);

  ADD_ALU: adder_N port map(
	i_C     => '0',
	i_X1	=> s_Shifted_Sign,
	i_X2	=> s_PC_4,
	o_S 	=> s_ALU_Result,
      	o_C	=> s_Carry);

  BRANCH_ZERO_AND: andg2 port map(
	i_A     => i_Branch,
       	i_B     => i_Zero,
       	o_F     => s_Branch_Zero);

  MUX1: mux2t1_N port map(
	i_S	=> s_Branch_Zero,
	i_D0	=> s_PC_4,
	i_D1	=> s_ALU_Result,
	o_O	=> s_Mux_Result_1);

  MUX2: mux2t1_N port map(
	i_S	=> i_Jump,
	i_D0	=> s_Mux_Result_1,
	i_D1	=> s_Jump_Address,
	o_O	=> s_post_jump);

 with i_jr select
   o_PC <= s_post_jump when '0',
   s_JR_VAL when others;

  with i_jrForwardSignal select
    s_JR_VAL <= i_JR_Reg when '0',
    i_JR_RegForward when others;


end structural;
