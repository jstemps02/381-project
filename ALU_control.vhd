-------------------------------------------------------------------------
-- Justin Templeton
-------------------------------------------------------------------------


-- ALU_control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file represents a control block for a single cycle MIPS processor
--
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_control is

  port(i_InstLo       : in std_logic_vector(5 downto 0);     -- Instruction Input
       o_Inst       : in std_logic_vector(5 downto 0);     -- Value from Control Block (bits 31 to 26)
       ALUEN        : in std_logic;     -- 1 if R-type, 0 when taking from Imm
       ALUOp        : out std_logic_vector(14 downto 0);
       jumpRegister : out std_logic;
       ALUContJump  : out std_logic;
       is_Shift     : out std_logic);     -- Signal sent to ALU

end ALU_control;



architecture mixed of ALU_control is

signal operator : std_logic_vector(5 downto 0); 
signal s_ALUOpR, s_ALUOpIJ, s_ALUOP : std_logic_vector(14 downto 0);
signal OvEn2, OvEn1, ALUContJump1, ALUContJump2, jumpRegister1, jumpRegister2 : std_logic;
begin
with ALUEN select
	s_ALUOP <= s_ALUOpR when '1',
	s_ALUOpIJ when others;

with i_InstLo select 
   s_ALUOpR <= b"101000000000000" when b"100000", --add/addi
	    b"100000000000000" when b"100001", --addu/addiu
      b"000000010000000" when b"100100", --and/andi
   --   b"000100000000000" when b"111111",--not
      b"000000100000000" when b"100111", --nor
      b"000001000000000" when b"100110",  --xor/xori
      b"000010000000000" when b"100101", --or/ori
      b"011000000000000" when b"100010",  --sub
      b"010000000000000" when b"100011",  --subu
      b"000000001000000" when b"000000",  --sll
      b"000000000100000" when b"000010",  --srl
      b"000000000010000" when b"000011",  --sra
      b"000000000000100" when b"001111",  --lui
      b"101000000000000" when b"101011",  --sw
      b"000000000000010" when b"101010",  --slt   
      b"011000000000000" when b"000100",  --beq 
      b"011000000000000" when b"000101",  --bne
      b"000000000000001" when b"011111",  --repl.qb
      b"000000000000000" when b"001000",  --jr
      b"000000001000000" when b"001011", -- movn

      b"000000000000000" when others;


with o_Inst select 
   s_ALUOpIJ <= b"101000000000000" when b"100000", --add/addi
	    b"100000000000000" when b"100001", --addu/addiu
      b"000000010000000" when b"100100", --and/andi
   --   b"000100000000000" when b"111111",--not
      b"000000100000000" when b"100111", --nor
      b"000001000000000" when b"100110",  --xor/xori
      b"000010000000000" when b"100101", --or/ori
      b"000000001010000" when b"000000",  --sll
      b"000000000100000" when b"000010",  --srl

      b"000000000000100" when b"001111",  --lui
      b"101000000000000" when b"101011",  --sw
      b"101000000000000" when b"100011",  --lw
      b"000000000000010" when b"101010",  --slt   
      b"011000000000000" when b"000100",  --beq 
      b"011000000000000" when b"000101",  --bne
      b"000000000000001" when b"011111",  --repl.qb

      b"000000000000000" when b"000011",  --jal
      b"000000000000000" when others;
  
with i_InstLo select 
   jumpRegister1 <= '1' when b"001000", --jr
	'0' when others;

with o_Inst select 
   jumpRegister2 <= '1' when b"111111", --jr
	'0' when others;


with i_InstLo select 
   ALUContJump1 <= '1' when b"001000", --jal
	'0' when others;

with o_Inst select 
   ALUContJump2 <= '1' when b"000000", --jal
	'0' when others;
ALUContJump <= ALUContJump1 and ALUContJump2;
jumpRegister <= jumpRegister2 and jumpRegister1;
is_Shift <= s_ALUOP(4) or s_ALUOP(6) or s_ALUOP(5);
ALUOP <= s_ALUOP;
end mixed;
