-------------------------------------------------------------------------
-- Justin Templeton & Jacob Lyons
-------------------------------------------------------------------------


-- mips.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file represents a control block for a single cycle MIPS processor
--
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mips is

 -- port();     -- Processor ins and outs
    

end mips;

architecture mixed of mips is
  
  component regfile is
  port(i_rs            : in std_logic_vector(4 downto 0);
     i_rd            : in std_logic_vector(4 downto 0);
     i_rt            : in std_logic_vector(4 downto 0);
     i_data	     : in std_logic_vector(31 downto 0);
     i_clk	     : in std_logic;
     writeEn	     : in std_logic;
     i_reset	     : in std_logic;
     o_rs	     : out std_logic_vector(31 downto 0);
     o_rt	     : out std_logic_vector(31 downto 0));
  end component;

  component control is 
  port(i_Inst       : in std_logic_vector(31 downto 26);     -- Instruction Input
       regDst       : out std_logic;     -- Reset input
       jump         : out std_logic;     -- Write enable input
       memRead      : out std_logic;     -- Data value input
       mem2Reg      : out std_logic;     -- Data value input
       ALUEn        : out std_logic;     -- Data value input
       o_Inst       : out std_logic_vector(5 downto 0);
       memWrite     : out std_logic;     -- Data value input
       ALUSrc       : out std_logic;
       branch 	    : out std_logic;
       imm_S        : out std_logic;
       regWrite     : out std_logic);   -- Data value output
  end component;

 component alu_control is 
 port(i_InstLo       : in std_logic_vector(5 downto 0);     -- Instruction Input
       o_Inst       : in std_logic_vector(5 downto 0);     -- Value from Control Block (bits 31 to 26)
       ALUEN        : in std_logic;     -- 1 if R-type, 0 when taking from Imm
       ALUOp        : out std_logic_vector(12 downto 0));     -- Signal sent to ALU
 end component;
  
  component alu is
  port(A            : in std_logic_vector(31 downto 0);     -- Instruction Input
       B            : in std_logic_vector(31 downto 0);     -- Value from Control Block (bits 31 to 26)
       ALUOp        : in std_logic_vector(12 downto 0);
       O 	    : out std_logic_vector(31 downto 0));     -- Signal sent to ALU
  end component;

  component mux2t1_N is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
  end component;

  component signExtend is 
  port(i_N             : in std_logic_vector(15 downto 0);
       imm_S           : in std_logic;
       imm_O           : out std_logic_vector(31 downto 0));  
  end component;

  component mem is
  generic(ADDR_WIDTH : integer := 10; DATA_WIDTH : integer := 32);
  port( clk		: in std_logic;
        addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
	data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
	we		: in std_logic := '1';
	q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
  end component;  
begin 

end mixed;