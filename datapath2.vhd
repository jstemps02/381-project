library IEEE;
use IEEE.std_logic_1164.all;

entity datapath2 is
port(in_input        : in std_logic_vector(31 downto 0);
     in_clk	     : in std_logic;
     in_reset	     : in std_logic;
     finalDataOut    : out std_logic_vector(31 downto 0));


end datapath2;

architecture structural of datapath2 is
	component mem
	generic(ADDR_WIDTH : integer := 10; DATA_WIDTH : integer := 32);
   	port(	clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
	end component;

	component ALU_control is

  	port(i_InstLo       : in std_logic_vector(5 downto 0);     -- Instruction Input
        o_Inst       : in std_logic_vector(5 downto 0);     -- Value from Control Block (bits 31 to 26)
        ALUEN        : in std_logic;     -- 1 if R-type, 0 when taking from Imm
        ALUOp        : out std_logic_vector(14 downto 0);
        OvEn	    : out std_logic;
        ALUContJump  : out std_logic);     -- Signal sent to ALU
	end component;
	
	component control is
  	port(i_Inst       : in std_logic_vector(31 downto 26);     -- Instruction Input
       regDst       : out std_logic;     -- Reset input
       contJump     : out std_logic;     -- Write enable input
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

	component alu is 
  		port(A        : in std_logic_vector(31 downto 0);     -- Instruction Input
      		 B            : in std_logic_vector(31 downto 0);     -- Value from Control Block (bits 31 to 26)
      		 ALUOp        : in std_logic_vector(14 downto 0);
      		 repl         : in std_logic_vector(23 downto 16);
      		 O 	    : out std_logic_vector(31 downto 0);
      		 Overflow     : out std_logic;
      		 Zero         : out std_logic);     -- Signal sent to ALU
    	end component;

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

	component signExtend is 
		  port( i_N              : in std_logic_vector(15 downto 0);
			imm_S            : in std_logic;
  		        imm_O            : out std_logic_vector(31 downto 0));
	end component;

	component mux2t1_N is
 		port(i_S          : in std_logic;
      		     i_D0         : in std_logic_vector(32-1 downto 0);
      		     i_D1         : in std_logic_vector(32-1 downto 0);
     		     o_O         : out std_logic_vector(32-1 downto 0));

	end component;

signal in_opcode : std_logic_vector(5 downto 0);
signal in_rs, in_rt, in_rd, s_WR : std_logic_vector(4 downto 0);
signal i_imm : std_logic_vector(15 downto 0);
signal s_repl         :  std_logic_vector(23 downto 16);
signal ExtOut : std_logic_vector(31 downto 0);
signal readA : std_logic_vector(31 downto 0);
signal readB : std_logic_vector(31 downto 0);
signal mOut : std_logic_vector(31 downto 0);
signal output, s_inALUA : std_logic_vector(31 downto 0);
signal memIn : std_logic_vector(9 downto 0);
signal dataOut : std_logic_vector(31 downto 0);
signal mLoopBack : std_logic_vector(31 downto 0);

signal s_ALUOp	: std_logic_vector(14 downto 0);
signal s_ALUEN, s_regDst, s_memRead, s_mem2Reg, s_memWrite, s_ALUSrc, s_branch, s_imm_S, s_regWrite, s_CLK, s_OvEn, s_ALUContJump, s_contJump, s_overflowPre, s_Overflow, s_Zero, s_isShift: std_logic;
signal s_o_Inst, s_i_InstLo : std_logic_vector(5 downto 0);

begin

in_opcode <= in_input(31 downto 26);
in_rs <= in_input(25 downto 21);
in_rt <= in_input(20 downto 16);
in_rd <= in_input(15 downto 11);
i_imm <= in_input(15 downto 0);
s_repl <= in_input(23 downto 16);
s_i_InstLo <= in_input(5 downto 0);


s_Overflow <= s_overflowPre and s_OvEn;

s_isShift <= s_ALUOp(6) or s_ALUOp(5) or s_ALUOp(4);


with s_isShift select
s_inALUA <= ExtOut when '1',
readA when others; 

  DUT1: control
  port map(i_Inst  =>  in_opcode,  -- Instruction Input
       regDst      => s_regDst,     -- Reset input
       contJump    => s_contJump,     -- Write enable input
       memRead     => s_memRead,     -- Data value input
       mem2Reg     => s_mem2Reg,     -- Data value input
       ALUEn       => s_ALUEN,     -- Data value input
       o_Inst      => s_o_Inst,
       memWrite    => s_memWrite,    -- Data value input
       ALUSrc      => s_ALUSrc,
       branch 	   => s_branch,
       imm_S       => s_imm_S,
       regWrite    => s_regWrite);   -- Data value output);

  DUT2: ALU_control
  port map(i_InstLo => s_i_InstLo,
  o_Inst => s_o_Inst,
  ALUEN => s_ALUEN,
  ALUOp => s_ALUOp,
  OvEn  => s_OvEn,
  ALUContJump => s_ALUContJump);
	SED: signExtend 
	port MAP(
		i_N => i_imm,
		imm_S => s_imm_S,
		imm_O => ExtOut);
	REG: regfile
	port MAP(i_rs => in_rs,
   		     i_rd  => s_WR,
  		     i_rt  => in_rt,
  		     i_data => mLoopBack,
  		     i_clk => in_clk,
    		     writeEn => s_regWrite,
  		     i_reset => in_reset,
  		     o_rs => readA,
  		     o_rt => readB);

	with s_regDst select 
	s_WR <= in_rt when '0',
	in_rd when others;
	
	
	ALU2: alu
	port map(
  		A     => s_inALUA,
      		B     => mOut,     -- Value from Control Block (bits 31 to 26)
      		ALUOp  => s_ALUOp,
      		repl  => s_repl,
      		O     => output,
      		Overflow  => s_overflowPre,
      		Zero      => s_Zero);	

	MUX1: mux2t1_N
	port MAP(i_D0  => readB,
      	  	      i_D1  => ExtOut,
		      i_S   => s_ALUSrc,
		      o_O  => mOut);

	memIn <= output(11 downto 2);
	MEM1: mem
	port MAP(clk	=> in_clk,
		addr	=> memIn,
		data	=> readB,
		we	=> s_memWrite,
		q	=> dataOut);

	MUX2: mux2t1_N
	port MAP(i_D0  => output,
      	  	      i_D1  => dataOut,
		      i_S   => s_mem2Reg,
		      o_O  => mLoopBack);
	finalDataOut <= mLoopBack;


end structural;
