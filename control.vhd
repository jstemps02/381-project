-------------------------------------------------------------------------
-- Justin Templeton
-------------------------------------------------------------------------


-- control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file represents a control block for a single cycle MIPS processor
--
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity control is

  port(i_Inst       : in std_logic_vector(31 downto 26);     -- Instruction Input
       regDst       : out std_logic;     -- Reset input
       contJump     : out std_logic;     -- Write enable input
       memRead      : out std_logic;     -- Data value input
       jumpAL       : out std_logic;     -- Data value input
       mem2Reg      : out std_logic;     -- Data value input
       ALUEn        : out std_logic;     -- Data value input
       o_Inst       : out std_logic_vector(5 downto 0);
       memWrite     : out std_logic;     -- Data value input
       ALUSrc       : out std_logic;
       branchE 	    : out std_logic;
       branchNE     : out std_logic;
       imm_S        : out std_logic;
       regWrite     : out std_logic);   -- Data value output

end control;

architecture mixed of control is
  
begin

with i_Inst select 
 jumpAL <= '1' when b"000011", --jal
	'0' when others;

with i_Inst select 
 ALUSrc <= '0' when b"000000", --rtype
	'1' when b"001000", --addi
	'1' when b"001001", --addiu
	'1' when b"001100", --andi
	'1' when b"001111", --lui
	'1' when b"001110", --xori
	'1' when b"001101", --ori
	'1' when b"001010", --slti
	'1' when b"101011", --sw
	'1' when b"100011", --lw
	'0' when b"000100", --beq
	'0' when b"000101", --bne
	'X' when b"000010", --j
	'X' when b"000011", --jal
	'X' when b"011111", --repl.qb
	'X' when others;

with i_Inst select 
 regWrite <= '1' when b"000000", --rtype
	'1' when b"001000", --addi
	'1' when b"001001", --addiu
	'1' when b"001100", --andi
	'1' when b"001111", --lui
	'1' when b"001110", --xori
	'1' when b"001101", --ori
	'1' when b"001010", --slti
	'0' when b"101011", --sw
	'1' when b"100011", --lw
	'0' when b"000100", --beq
	'0' when b"000101", --bne
	'0' when b"000010", --j
	'1' when b"000011", --jal
	'1' when b"011111", --repl.qb
	'X' when others;

with i_Inst select 
 memWrite <= '0' when b"000000", --rtype
	'0' when b"001000", --addi
	'0' when b"001001", --addiu
	'0' when b"001100", --andi
	'0' when b"001111", --lui
	'0' when b"001110", --xori
	'0' when b"001101", --ori
	'0' when b"001010", --slti
	'1' when b"101011", --sw
	'0' when b"100011", --lw
	'0' when b"000100", --beq
	'0' when b"000101", --bne
	'0' when b"000010", --j
	'0' when b"000011", --jal
	'0' when b"011111", --repl.qb
	'X' when others;
with i_Inst select 
 memRead <= '0' when b"000000", --rtype
	'0' when b"001000", --addi
	'0' when b"001001", --addiu
	'0' when b"001100", --andi
	'0' when b"001111", --lui
	'0' when b"001110", --xori
	'0' when b"001101", --ori
	'0' when b"001010", --slti
	'0' when b"101011", --sw
	'1' when b"100011", --lw
	'0' when b"000100", --beq
	'0' when b"000101", --bne
	'0' when b"000010", --j
	'0' when b"000011", --jal
	'0' when b"011111", --repl.qb
	'X' when others;
with i_Inst select 
 mem2Reg <= '0' when b"000000", --rtype
	'0' when b"001000", --addi
	'0' when b"001001", --addiu
	'0' when b"001100", --andi
	'0' when b"001111", --lui
	'0' when b"001110", --xori
	'0' when b"001101", --ori
	'0' when b"001010", --slti
	'0' when b"101011", --sw
	'1' when b"100011", --lw
	'X' when b"000100", --beq
	'X' when b"000101", --bne
	'X' when b"000010", --j
	'X' when b"000011", --jal
	'0' when b"011111", --repl.qb
	'X' when others;
with i_Inst select 
 branchE <= '0' when b"000000", --rtype
	'0' when b"001000", --addi
	'0' when b"001001", --addiu
	'0' when b"001100", --andi
	'0' when b"001111", --lui
	'0' when b"001110", --xori
	'0' when b"001101", --ori
	'0' when b"001010", --slti
	'0' when b"101011", --sw
	'0' when b"100011", --lw
	'1' when b"000100", --beq
	'0' when b"000101", --bne
	'X' when b"000010", --j
	'X' when b"000011", --jal
	'0' when b"011111", --repl.qb
	'X' when others;

with i_Inst select 
 branchNE <= '0' when b"000000", --rtype
	'0' when b"001000", --addi
	'0' when b"001001", --addiu
	'0' when b"001100", --andi
	'0' when b"001111", --lui
	'0' when b"001110", --xori
	'0' when b"001101", --ori
	'0' when b"001010", --slti
	'0' when b"101011", --sw
	'0' when b"100011", --lw
	'0' when b"000100", --beq
	'1' when b"000101", --bne
	'X' when b"000010", --j
	'X' when b"000011", --jal
	'0' when b"011111", --repl.qb
	'X' when others;

with i_Inst select 
 contJump <= '0' when b"000000", --rtype
	'0' when b"001000", --addi
	'0' when b"001001", --addiu
	'0' when b"001100", --andi
	'0' when b"001111", --lui
	'0' when b"001110", --xori
	'0' when b"001101", --ori
	'0' when b"001010", --slti
	'0' when b"101011", --sw
	'0' when b"100011", --lw
	'0' when b"000100", --beq
	'0' when b"000101", --bne
	'1' when b"000010", --j
	'1' when b"000011", --jal
	'0' when b"011111", --repl.qb
	'X' when others;

with i_Inst select 
 regDst <= '1' when b"000000", --rtype
	'0' when b"001000", --addi
	'0' when b"001001", --addiu
	'0' when b"001100", --andi
	'0' when b"001111", --lui
	'0' when b"001110", --xori
	'0' when b"001101", --ori
	'0' when b"001010", --slti
	'0' when b"101011", --sw
	'0' when b"100011", --lw
	'0' when b"000100", --beq
	'0' when b"000101", --bne
	'X' when b"000010", --j
	'X' when b"000011", --jal
	'1' when b"011111", --repl.qb
	'X' when others;
with i_Inst select 
 ALUEn <= '1' when b"000000", --rtype
	'0' when b"001000", --addi
	'0' when b"001001", --addiu
	'0' when b"001100", --andi
	'0' when b"001111", --lui
	'0' when b"001110", --xori
	'0' when b"001101", --ori
	'0' when b"001010", --slti
	'0' when b"101011", --sw
	'0' when b"100011", --lw
	'0' when b"000100", --beq
	'0' when b"000101", --bne
	'X' when b"000010", --j
	'X' when b"000011", --jal
	'0' when b"011111", --repl.qb
	'X' when others;

with i_Inst select 
 imm_S <= 'X' when b"000000", --rtype
	'1' when b"001000", --addi
	'1' when b"001001", --addiu
	'0' when b"001100", --andi
	'0' when b"001111", --lui
	'0' when b"001110", --xori
	'0' when b"001101", --ori
	'1' when b"001010", --slti
	'1' when b"101011", --sw
	'1' when b"100011", --lw
	'1' when b"000100", --beq
	'1' when b"000101", --bne
	'X' when b"000010", --j
	'X' when b"000011", --jal
	'X' when b"011111", --repl.qb
	'X' when others;


with i_Inst select 
 o_Inst <= "111111" when b"000000", --rtype
	b"100000" when b"001000", --addi
	b"100001" when b"001001", --addiu
	b"100100" when b"001100", --andi
	b"001111" when b"001111", --lui
	b"100110" when b"001110", --xori
	b"100101" when b"001101", --ori
	b"101010" when b"001010", --slti
	b"101011" when b"101011", --sw
	b"100011" when b"100011", --lw
	b"000100" when b"000100", --beq
	b"000101" when b"000101", --bne
	b"111111" when b"000010", --j
	b"111111" when b"000011", --jal
	b"011111" when b"011111", --repl.qb
	b"111111" when others;


--   r_IF_SETTING : process (i_Inst) is
--   begin
--      if i_Inst = b"000000" then --rtype
-- 	ALUSrc    <= '0';	
-- 	regWrite  <= '1';
-- 	memWrite  <= '0';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0';
-- 	branch    <= '0';
-- 	jump      <= '0';
-- 	regDst    <= '1';
--         ALUEn     <= '1';
--         imm_S     <= '1';
-- 	o_Inst     <= b"100000";

--      elsif i_Inst = b"001000" then --addi
-- 	ALUSrc    <= '1';	
-- 	regWrite  <= '1';
-- 	memWrite  <= '0';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0';
-- 	branch    <= '0';
-- 	jump      <= '0';
-- 	regDst    <= '0';
--         ALUEn     <= '0';
--         imm_S     <= '1';
-- 	o_Inst     <= b"100000"; 

--      elsif i_Inst = b"001001" then --addiu
-- 	ALUSrc    <= '1';	
-- 	regWrite  <= '1';
-- 	memWrite  <= '0';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0';
-- 	branch    <= '0';
-- 	jump      <= '0';
-- 	regDst    <= '0';
--         ALUEn     <= '0'; 
-- 	imm_S     <= '0'; --zero extend
-- 	o_Inst     <= b"100001"; 

--     --  elsif i_Inst = b"000000" then --addu
-- 	-- ALUSrc    <= '0';	
-- 	-- regWrite  <= '1';
-- 	-- memWrite  <= '0';
-- 	-- memRead   <= '0';
-- 	-- mem2Reg   <= '0';
-- 	-- branch    <= '0';
-- 	-- jump      <= '0';
-- 	-- regDst    <= '1';
--     --     ALUEn     <= '1';
--     --     imm_S     <= '0';
-- 	-- ALUOp     <= b"100001";
--     --  elsif i_Inst = b"000000" then --and
-- 	-- ALUSrc    <= '0';	
-- 	-- regWrite  <= '1';
-- 	-- memWrite  <= '0';
-- 	-- memRead   <= '0';
-- 	-- mem2Reg   <= '0';
-- 	-- branch    <= '0';
-- 	-- jump      <= '0';
-- 	-- regDst    <= '1';
--     --     ALUEn     <= '1';
--     --     imm_S     <= '1';
-- 	-- ALUOp     <= b"100100";

--      elsif i_Inst = b"001100" then --andi
-- 	ALUSrc    <= '1';	
-- 	regWrite  <= '1';
-- 	memWrite  <= '0';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0';
-- 	branch    <= '0';
-- 	jump      <= '0';
-- 	regDst    <= '0';
--         ALUEn     <= '0';
--         imm_S     <= '0';
-- 	o_Inst     <= b"100100"; 
     
--      elsif i_Inst = b"001111" then --lui
-- 	ALUSrc    <= '1';	
-- 	regWrite  <= '1';
-- 	memWrite  <= '0';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0';
-- 	branch    <= '0';
-- 	jump      <= '0';
-- 	regDst    <= '0';
--         ALUEn     <= '0';
--         imm_S     <= '0';
-- 	o_Inst     <= b"001111"; 
     

--     --  elsif i_Inst = b"000000" then --nor
-- 	-- ALUSrc    <= '0';	
-- 	-- regWrite  <= '1';
-- 	-- memWrite  <= '0';
-- 	-- memRead   <= '0';
-- 	-- mem2Reg   <= '0';
-- 	-- branch    <= '0';
-- 	-- jump      <= '0';
-- 	-- regDst    <= '1';
--     --     ALUEn     <= '1';
--     --     imm_S     <= '0';
-- 	-- ALUOp     <= b"000000"; --not used

--     --  elsif i_Inst = b"000000" then --xor
-- 	-- ALUSrc    <= '0';	
-- 	-- regWrite  <= '1';
-- 	-- memWrite  <= '0';
-- 	-- memRead   <= '0';
-- 	-- mem2Reg   <= '0';
-- 	-- branch    <= '0';
-- 	-- jump      <= '0';
-- 	-- regDst    <= '1';
--     --     ALUEn     <= '1';
--     --     imm_S     <= '0';
-- 	-- ALUOp     <= b"000000"; --not used


--      elsif i_Inst = b"001110" then --xori
-- 	ALUSrc    <= '1';	
-- 	regWrite  <= '1';
-- 	memWrite  <= '0';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0';
-- 	branch    <= '0';
-- 	jump      <= '0';
-- 	regDst    <= '0';
--         ALUEn     <= '0';
--         imm_S     <= '0';
-- 	o_Inst     <= b"100110"; 

--     --  elsif i_Inst = b"000000" then --or
-- 	-- ALUSrc    <= '0';	
-- 	-- regWrite  <= '1';
-- 	-- memWrite  <= '0';
-- 	-- memRead   <= '0';
-- 	-- mem2Reg   <= '0';
-- 	-- branch    <= '0';
-- 	-- jump      <= '0';
-- 	-- regDst    <= '1';
--     --     ALUEn     <= '1';
--     --     imm_S     <= '0';
-- 	-- ALUOp     <= b"000000"; --not used

--      elsif i_Inst = b"001101" then --ori
-- 	ALUSrc    <= '1';	
-- 	regWrite  <= '1';
-- 	memWrite  <= '0';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0';
-- 	branch    <= '0';
-- 	jump      <= '0';
-- 	regDst    <= '0';
--         ALUEn     <= '0';
--         imm_S     <= '0';
-- 	o_Inst     <= b"100101"; 

--     --  if i_Inst = b"000000" then --slt
-- 	-- ALUSrc    <= '0';	
-- 	-- regWrite  <= '1';
-- 	-- memWrite  <= '0';
-- 	-- memRead   <= '0';
-- 	-- mem2Reg   <= '0';
-- 	-- branch    <= '0';
-- 	-- jump      <= '0';
-- 	-- regDst    <= '1';
--     --     ALUEn     <= '1';
--     --     imm_S     <= '1';
-- 	-- ALUOp     <= x"20";

--      elsif i_Inst = b"001010" then --slti
-- 	ALUSrc    <= '1';	
-- 	regWrite  <= '1';
-- 	memWrite  <= '0';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0';
-- 	branch    <= '0';
-- 	jump      <= '0';
-- 	regDst    <= '0';
--         ALUEn     <= '0';
--         imm_S     <= '0';
-- 	o_Inst     <= b"101010"; 

-- --sll
-- --srl
-- --sra
--      elsif i_Inst = b"101011" then --sw
-- 	ALUSrc    <= '1';	
-- 	regWrite  <= '0';
-- 	memWrite  <= '1';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0';
-- 	branch    <= '0';
-- 	jump      <= '0';
-- 	regDst    <= '0';
--         ALUEn     <= '0';
--         imm_S     <= '0';
-- 	o_Inst     <= b"000000"; --not used

--      elsif i_Inst = b"100011" then --lw
-- 	ALUSrc    <= '1';	
-- 	regWrite  <= '1';
-- 	memWrite  <= '0';
-- 	memRead   <= '1';
-- 	mem2Reg   <= '1';
-- 	branch    <= '0';
-- 	jump      <= '0';
-- 	regDst    <= '0';
--         ALUEn     <= '0';
--         imm_S     <= '0';
-- 	o_Inst     <= b"000000"; --not used

-- --sub

--      elsif i_Inst = b"000100" then --beq
-- 	ALUSrc    <= '1';	
-- 	regWrite  <= '0';
-- 	memWrite  <= '0';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0'; --x
-- 	branch    <= '1';
-- 	jump      <= '0';
-- 	regDst    <= '1';
--         ALUEn     <= '0';
--         imm_S     <= '1';
-- 	o_Inst     <= b"010110"; --do sub, check if equal


--      elsif i_Inst = b"000101" then --bne
-- 	ALUSrc    <= '1';	
-- 	regWrite  <= '0';
-- 	memWrite  <= '0';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0'; --x
-- 	branch    <= '1';
-- 	jump      <= '0';
-- 	regDst    <= '1';
--         ALUEn     <= '0';
--         imm_S     <= '1';
-- 	o_Inst     <= b"010110"; --do sub, check if not equal


--      elsif i_Inst = b"000101" then --j
-- 	ALUSrc    <= '1'; --x
-- 	regWrite  <= '0';
-- 	memWrite  <= '0';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0'; --x
-- 	branch    <= '1'; --x
-- 	jump      <= '1';
-- 	regDst    <= '1'; --x
--         ALUEn     <= '0';
--         imm_S     <= '1';
-- 	o_Inst     <= b"000000"; 

--      elsif i_Inst = b"000101" then --jal
-- 	ALUSrc    <= '1'; --x
-- 	regWrite  <= '0';
-- 	memWrite  <= '0';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0'; --x
-- 	branch    <= '1'; --x
-- 	jump      <= '1';
-- 	regDst    <= '1'; --x
--         ALUEn     <= '0';
--         imm_S     <= '1';
-- 	o_Inst     <= b"000000"; 

-- --jr

--      elsif i_Inst = b"011111" then --repl.qb
-- 	ALUSrc    <= '1'; --x
-- 	regWrite  <= '1';
-- 	memWrite  <= '0';
-- 	memRead   <= '0';
-- 	mem2Reg   <= '0'; 
-- 	branch    <= '0'; 
-- 	jump      <= '0';
-- 	regDst    <= '0';
--         ALUEn     <= '0';
--         imm_S     <= '0';
-- 	o_Inst     <= b"011111"; 

--      end if;
--   end process r_IF_SETTING;
  
end mixed;
