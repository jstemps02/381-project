-------------------------------------------------------------------------
-- Justin Templeton
-------------------------------------------------------------------------


-- alu.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file represents a control block for a single cycle MIPS processor
--
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity alu is

  port(A            : in std_logic_vector(31 downto 0);     -- Instruction Input
       B            : in std_logic_vector(31 downto 0);     -- Value from Control Block (bits 31 to 26)
       ALUOp        : in std_logic_vector(14 downto 0);
       repl         : in std_logic_vector(23 downto 16);
       O 	    : out std_logic_vector(31 downto 0);
       Overflow     : out std_logic;
       Zero         : out std_logic);     -- Signal sent to ALU
    

end alu;

architecture mixed of alu is





  component addsub_nmod is
  generic(N : integer := 32);
  port(nAdd_Sub    : in std_logic;
       i_A         : in std_logic_vector(N-1 downto 0);
       i_B         : in std_logic_vector(N-1 downto 0);
       o_S         : out std_logic_vector(N-1 downto 0);
       o_C         : out std_logic);
  end component;

  component and32 is
  port(i_1         : in std_logic_vector(31 downto 0);
       i_2         : in std_logic_vector(31 downto 0);
       o_And       : out std_logic_vector(31 downto 0));
  end component;

  component or32 is
  port(i_1         : in std_logic_vector(31 downto 0);
       i_2         : in std_logic_vector(31 downto 0);
       o_Or       : out std_logic_vector(31 downto 0));
  end component;

  component nor32 is
  port(i_1         : in std_logic_vector(31 downto 0);
       i_2         : in std_logic_vector(31 downto 0);
       o_Nor       : out std_logic_vector(31 downto 0));
  end component;

  component not32 is
  port(i_n         : in std_logic_vector(31 downto 0);
       o_Not       : out std_logic_vector(31 downto 0));
  end component;

  component xor32 is
  port(i_1         : in std_logic_vector(31 downto 0);
       i_2         : in std_logic_vector(31 downto 0);
       o_Xor       : out std_logic_vector(31 downto 0));
  end component;
  
  component barrelShift is 
  port(i_S	: in std_logic_vector(4 downto 0);	--Selects how much to shift
       i_Left   : in std_logic;				--0 for right, 1 for left
       i_Op	: in std_logic;				--0 for logical, 1 for arithmetic shifting
       i_In     : in std_logic_vector(31 downto 0);	--Value input before shifting
       o_Out    : out std_logic_vector(31 downto 0));	--Value output after shifting
  end component;

  component slt32 is 
  port(i_sltA         : in std_logic_vector(31 downto 0);
       i_sltB         : in std_logic_vector(31 downto 0);
       o_slt          : out std_logic_vector(31 downto 0));
  end component;
  component and32to1 is
  port(i_N         : in std_logic_vector(31 downto 0);
       o_And       : out std_logic);
  end component;

signal s_add, s_sub, s_sign, s_not, s_or, s_xor, s_nor, s_and, s_sll, s_srl, s_sra, s_lui, s_jump, s_slt :  std_logic;	
signal s_Zero, s_Overflow, s_repl, s_addOrSub :  std_logic;	

signal s_ALUOP : std_logic_vector(14 downto 0);
signal shamt : std_logic_vector(4 downto 0);
signal s_replqb : std_logic_vector(7 downto 0);
signal s_Out, s_A, s_B, s_o_slt : std_logic_vector(31 downto 0);
signal s_adderSum, s_AND_O, s_OR_O, s_XOR_O, s_NOR_O, s_NOT_O, s_Shift_O, s_LUI_O, s_repl_o, s_Out_Neg : std_logic_vector(31 downto 0);
begin

s_ALUOP <= ALUOP;  

s_add <= ALUOp(14);
s_sub <= ALUOp(13);
s_sign <= ALUOp(12);
s_not <= ALUOp(11);
s_or <= ALUOp(10);
s_xor <= ALUOp(9);
s_nor <= ALUOp(8);
s_and <= ALUOp(7);
s_sll <= ALUOp(6);
s_srl <= ALUOp(5);
s_sra <= ALUOp(4);
s_jump <= ALUOp(3);
s_lui <= ALUOp(2); 
s_slt <= ALUOp(1); 
s_repl <= ALUOp(0); 
shamt <= A(10 downto 6);
s_A <= A;
s_B <= B;
Zero <= s_Zero;
--Overflow <= ((s_A(31) and s_B(31)) and not s_adderSum(31)) or (not s_A(31) and not s_B(31) and s_adderSum(31));

Overflow <= s_Overflow;


O <= s_Out;
s_replqb <= repl;
s_Out_Neg <= not S_Out;

s_addOrSub <= not s_add; 
ADD_2: addsub_nmod
port MAP(nAdd_Sub => s_addOrSub,
       i_A  => s_A,
       i_B  => s_B,
       o_S   => s_adderSum,
       o_C   => s_Overflow);

s_AND_O <= s_A and s_B;

OR_1: or32
port MAP(i_1 => s_A,
       i_2   => s_B,
       o_Or  => s_OR_O);

XOR_1: xor32
port MAP(i_1 => s_A,
       i_2   => s_B,
       o_Xor => s_XOR_O);

NOR_1: nor32
port MAP(i_1 => s_A,
       i_2   => s_B,
       o_Nor => s_NOR_O);

NOT_1: not32
port MAP(i_n => s_A,
       o_Not => s_NOT_O);
BS_1: barrelShift
port MAP(i_S  => shamt,	--Selects how much to shift
       i_Left => s_sll,	--0 for right, 1 for left
       i_Op   => s_sra,	--ALUOp(5) is s_sra	--0 for logical, 1 for arithmetic shifting
       i_In   => s_B,	--Value input before shifting
       o_Out  => s_Shift_O);	--Value output after shifting


s_LUI_O(31 downto 16) <= s_B(15 downto 0);
s_LUI_O(15 downto 0) <= x"0000";

s_repl_o(7 downto 0) <= s_replqb;
s_repl_o(15 downto 8) <= s_replqb;
s_repl_o(23 downto 16) <= s_replqb;
s_repl_o(31 downto 24) <= s_replqb;

SLT_1: slt32
port map(i_sltA     =>   s_A,
       i_sltB       =>   s_B,
       o_slt        =>   s_o_slt);

Z_Flag: and32to1 
  port map(i_N    =>  s_Out_Neg,
       o_And      =>  s_Zero);

with s_ALUOP select 
    s_Out <= s_AND_O when b"000000010000000",
	S_OR_O when  b"000010000000000", --or
	s_XOR_O when b"000001000000000", --xor
	s_NOR_O when b"000000100000000", --nor
	s_adderSum when b"101000000000000", --add
	s_adderSum when b"100000000000000", --addu
	s_adderSum when b"011000000000000", --sub
	s_adderSum when b"010000000000000", --subu
	s_Shift_O when b"000000001000000", --sll
	s_Shift_O when b"000000000100000", --srl
	s_Shift_O when b"000000000010000", --sra
	s_LUI_O when b"000000000000100", -- lui 
	s_NOT_O when b"000100000000000", --not
	s_o_slt when b"000000000000010", --slt
        s_repl_o when b"000000000000001", --repl
	x"00000000" when others;



end mixed;
