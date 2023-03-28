-------------------------------------------------------------------------
-- Justin Templeton, Jacob Lyons
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 10/09/2022 : Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oInstAddrNext   : out std_logic_vector(N-1 downto 0); -- ???
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is
 
  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)
  
  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  signal s_ALUin2, s_Ext, s_ExtPre, s_aluOUT, s_WriteBack, s_ALUin1, s_ReadA, s_ReadB_Reg_Out, s_ReadA_Reg_Out, s_ReadB, s_PC_in, s_PC_out, PC_WB, s_PC_4, s_addrJAL, s_PC_inFinal, s_PC_temp, s_Inst_Reg_Out, s_DMemAddr_WB, s_DMemOut_WB, s_ALUin2Temp, s_ALUin1Temp, s_ExecB, s_ExecA, IF_PC, s_PC_plus4, s_PC_plus4DECODE, s_PC_plus4_4, s_PC_plus4_3, s_PC_plus4_2, s_Branchin1Temp, s_Branchin2Temp, s_ALUEXMEMIN, s_DMEMorDATA, sssss   : std_logic_vector(31 downto 0);
  signal s_ctrlIn : std_logic_vector(31 downto 26);
  signal s_rsIn, s_rsInPost : std_logic_vector(25 downto 21);
  signal s_rdIn, s_rdInPost : std_logic_vector(20 downto 16);
  signal s_rtIn, s_rtInPost : std_logic_vector(15 downto 11);
  signal s_immIn : std_logic_vector(15 downto 0);
  signal s_ALUOP, s_ALUOP1, s_ALUOP0 : std_logic_vector(14 downto 0);
  signal s_repl, s_replFinal, s_repl1  : std_logic_vector(23 downto 16);
  signal s_fetchIn : std_logic_vector(25 downto 0);
  signal Ov1, Ov2, Ju1, Ju2 : std_logic;
  signal s_control2ALUCont, s_inst_Lo : std_logic_vector(5 downto 0);
  signal s_writeMux, s_writeMux2, s_writeRegTemp, s_writeRegEXMEM, s_writeRegMEMWB, s_writeRegTempMAX : std_logic_vector(4 downto 0);
  signal s_RegDst, s_jump, s_memRead, s_mem2Reg, s_ALUEn, s_ALUSrc, s_ALUZero, s_branch, s_imm_S, s_Shift, s_jumpAL, s_branchE, s_branchNE, s_jumpRegister, s_ZeroTrue, s_haltseen, s_haltseen2, s_haltseen3, s_haltseen4, s_ALUSrc1, s_ALUSrc2  : std_logic;
  signal  WB_out_MEMWB, WB_out_EXMEM, WB_out_IDEX, M_out_EXMEM, M_out_IDEX, EX_out_IDEX, s_allJBrJr, s_memWrite, s_RegWriteBack, s_PC_WriteEn, s_IDEX_Mux, s_IF_ID_Write, s_jumpALseen, s_jumpALseen1, s_jumpALseen2, s_jumpALseen3, s_RegWriteBack1, s_memWrite1, s_RegDst1, s_CarryUSELESS, s_mem2Reg1, s_mem2Reg2, s_mem2Reg3, s_haltseen1, s_mem2Reg0, s_Shift1, s_Shift2, s_ALUZeroLEGACY, Ov1IDEX, s_Ov_EXMEM, s_Ov_MEMWB, s_jrForward, s_JandB,  s_JALandBrnach, s_memRead2, s_memRead1        : std_logic;
  signal s_ALUmuxA, s_ALUmuxB, s_branchA, s_branchB : std_logic_vector(1 downto 0);



  component regfile is
  port(i_rs          : in std_logic_vector(4 downto 0);
     i_rd            : in std_logic_vector(4 downto 0);
     i_rt            : in std_logic_vector(4 downto 0);
     i_data	     : in std_logic_vector(31 downto 0);
     i_clk	     : in std_logic;
     writeEn	     : in std_logic;
     i_reset	     : in std_logic;
     o_rs	     : out std_logic_vector(31 downto 0);
     o_rt	     : out std_logic_vector(31 downto 0));
  end component;
  component NbitReg_struct is
  generic(N : integer := 32);
  port(i_Reg            : in std_logic_vector(N-1 downto 0);
        o_Reg            : out std_logic_vector(N-1 downto 0);
	r_Reg            : in std_logic;
	c_Reg            : in std_logic;
	e_Reg            : in std_logic);

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
       jumpAL       : out std_logic;
       branchE 	    : out std_logic;
       branchNE     : out std_logic;
       imm_S        : out std_logic;
       regWrite     : out std_logic);   -- Data value output
  end component;

 component alu_control is 
  port(i_InstLo       : in std_logic_vector(5 downto 0);     -- Instruction Input
       o_Inst       : in std_logic_vector(5 downto 0);     -- Value from Control Block (bits 31 to 26)
       ALUEN        : in std_logic;     -- 1 if R-type, 0 when taking from Imm
       ALUOp        : out std_logic_vector(14 downto 0);
       ALUContJump  : out std_logic;
       jumpRegister : out std_logic;
       is_Shift     : out std_logic);     -- Signal sent to ALU
 end component;
  
  component alu is
  port(A            : in std_logic_vector(31 downto 0);     -- Instruction Input
       B            : in std_logic_vector(31 downto 0);     -- Value from Control Block (bits 31 to 26)
       ALUOp        : in std_logic_vector(14 downto 0);
       repl         : in std_logic_vector(23 downto 16);
       O 	    : out std_logic_vector(31 downto 0);
       Overflow     : out std_logic;
       Zero         : out std_logic);     -- Signal sent to ALU
  end component;

  component mux2t1_N is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
  end component;

  component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  component signExtend is 
  port(i_N             : in std_logic_vector(15 downto 0);
       imm_S           : in std_logic;
       imm_O           : out std_logic_vector(31 downto 0));  
  end component;

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

component fetchLogic is						--Instantiate this once all of the below values are known on the main processor (Zero from the ALU is likely to be last)

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

end component;


component adder_N is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_C          : in std_logic;
       i_X1         : in std_logic_vector(N-1 downto 0);
       i_X2         : in std_logic_vector(N-1 downto 0);
       o_S          : out std_logic_vector(N-1 downto 0);
       o_C          : out std_logic);

end component;


  component equals5to1 is
    port(i_A         : in std_logic_vector(4 downto 0);
         i_B         : in std_logic_vector(4 downto 0);
         o_Equals    : out std_logic);
  end component;


  component reg_if_id is
  port(i_PC_4          : in std_logic_vector(31 downto 0);
     i_Inst          : in std_logic_vector(31 downto 0);
     i_clk	     : in std_logic;
     i_IF_Flush	     : in std_logic;
     i_reset	     : in std_logic;
     i_IFID_Hazard   : in std_logic;
     o_Inst_Out	     : out std_logic_vector(31 downto 0);
     o_PC_4_Out	     : out std_logic_vector(31 downto 0));
  end component;

  component reg_id_ex is
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
     i_ALUOP         : in std_logic_vector(14 downto 0);
     i_ALUSrc        : in std_logic;
     i_Shift         : in std_logic;
     i_Ov1         : in std_logic;
     i_PC4_2       : in std_logic_vector(31 downto 0);
     i_IF_Flush   : in std_logic;
     i_jumpandbranch  : in std_logic;
     i_loadword  : in std_logic;
     o_loadword  : out std_logic;
     o_jumpandbranch  : out std_logic;
     o_PC4_2	     : out std_logic_vector(31 downto 0);
     o_Ov1      : out std_logic;
     o_Shift      : out std_logic;
     o_ALUSrc        : out std_logic;
     o_ALUOP         : out std_logic_vector(14 downto 0);
     o_repl          : out std_logic_vector(7 downto 0);
     o_mem2Reg1	     : out std_logic;
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
  end component;

  component reg_ex_mem is
  port(i_ALU2Reg         : in std_logic_vector(31 downto 0);
     i_ALUIn2          : in std_logic_vector(31 downto 0);
     i_clk	     : in std_logic;
     i_reset	     : in std_logic;
     i_WB_in	     : in std_logic;
     i_M_in	     : in std_logic;
     i_halt2         : in std_logic;
     i_JAL2          : in std_logic;
     i_mem2Reg2       : in std_logic;
     i_Ov_EXMEM      : in std_logic;
     i_PC4_3       : in std_logic_vector(31 downto 0);
     i_IF_Flush   : in std_logic;
     i_loadword  : in std_logic;
     o_loadword  : out std_logic;
     o_PC4_3	     : out std_logic_vector(31 downto 0);
     o_Ov_EXMEM      : out std_logic;
     o_mem2Reg2 	     : out std_logic;
     o_JAL2 	     : out std_logic;
     o_halt2	     : out std_logic;
     o_WB_out	     : out std_logic;
     o_M_out	     : out std_logic;
     i_writeRegEXMEM             : in std_logic_vector(4 downto 0);
     o_writeRegEXMEM             : out std_logic_vector(4 downto 0);
     o_DMEMAddr	     : out std_logic_vector(31 downto 0);
     o_DMEMData	     : out std_logic_vector(31 downto 0));
  end component;


  component reg_mem_wb is
  port(i_DMEM_DATA     : in std_logic_vector(31 downto 0);
     i_DMEM_ADDR     : in std_logic_vector(31 downto 0);
     i_clk	     : in std_logic;
     i_reset	     : in std_logic;
     i_WB_in	     : in std_logic;
     i_writeRegMEMWB : in std_logic_vector(4 downto 0);
     i_halt3         : in std_logic;
     i_JAL3          : in std_logic;
     i_mem2Reg3       : in std_logic;
     i_Ov_MEMWB      : in std_logic;
     i_PC4_4       : in std_logic_vector(31 downto 0);
     i_IF_Flush   : in std_logic;
     o_PC4_4	     : out std_logic_vector(31 downto 0);
     o_Ov_MEMWB      : out std_logic;
     o_mem2Reg3      : out std_logic;
     o_JAL3 	     : out std_logic;
     o_halt3	     : out std_logic;
     o_writeRegMEMWB : out std_logic_vector(4 downto 0);
     o_WB_out	     : out std_logic;
     o_DMEM_ADDR     : out std_logic_vector(31 downto 0);
     o_DMEM_DATA     : out std_logic_vector(31 downto 0));
  end component;









  component equals32to1 is
  port(i_A         : in std_logic_vector(31 downto 0);
       i_B         : in std_logic_vector(31 downto 0);
       o_Equals    : out std_logic);
  end component;


begin

  --Splits the instruction into small pieces for easier digestion
  s_ctrlIn		<= s_Inst_Reg_Out(31 downto 26);
  s_rsIn		<= s_Inst_Reg_Out(25 downto 21);
  s_repl		<= s_Inst_Reg_Out(23 downto 16);
  s_rdIn		<= s_Inst_Reg_Out(15 downto 11);
  s_rtIn		<= s_Inst_Reg_Out(20 downto 16);
  s_immIn		<= s_Inst_Reg_Out(15 downto 0);
  s_fetchIn		<= s_Inst_Reg_Out(25 downto 0);
  s_inst_Lo	        <= s_Inst_Reg_Out(5 downto 0);
  s_Ov_EXMEM <= Ov1IDEX and Ov2;
  s_jump <= Ju1 or Ju2;
  oALUOut <= s_aluOUT;
  s_ZeroTrue <= (s_branchE and s_ALUZero) or (s_branchNE and not s_ALUZero);
  s_branch <= s_branchE or s_branchNE;



  CONTR: control
  port map(i_Inst => s_ctrlIn,
       regDst     => s_RegDst,
       contJump   => Ju1,
       memRead    => s_memRead,
       jumpAL     => s_jumpALseen,
       mem2Reg    => s_mem2Reg,
       ALUEn      => s_ALUEn,
       o_Inst     => s_control2ALUCont,
       memWrite   => s_memWrite,
       ALUSrc     => s_ALUSrc,
       branchE 	  => s_branchE,
       branchNE   => s_branchNE,
       imm_S      => s_imm_S,
       regWrite   => s_RegWriteBack);   
  ALUCONT: alu_control
    port map(i_InstLo =>  s_inst_Lo,
       o_Inst     => s_control2ALUCont,
       ALUEN      => s_ALUEn,
       ALUOp      => s_ALUOP,   
       ALUContJump => Ju2,
       jumpRegister => s_jumpRegister,
       is_Shift  => s_Shift);  


with s_jumpAL select 
  s_RegWrData <= s_PC_plus4_4 when '1',  --delete
  s_WriteBack when others;

with s_jumpAL select
  s_RegWrAddr <= b"11111" when '1',
  s_writeMux when others;




with s_ALUSrc2 select
   s_ALUin2 <= s_Ext when '1',
   s_ReadB_Reg_Out when others ;

with s_Shift2 select  --FIX
   s_ALUin1 <= s_Ext when '1',
   s_ReadA_Reg_Out when others;


Ov1 <= '1' when (s_ctrlIn = b"000000" and s_inst_Lo = b"100000") or (s_ctrlIn = b"000000" and s_inst_Lo = b"100010") or (s_ctrlIn = b"001000") else '0';

  REG: regfile
    port map(i_rs => s_rsIn,
       i_rt       => s_rtIn,
       i_rd       => s_RegWrAddr,
       i_data	  => s_RegWrData,
       i_clk	  => iCLK,
       writeEn	  => s_RegWr,
       i_reset	  => iRST,
       o_rs	  => s_ReadA,
       o_rt	  => s_ReadB);
  SIGN_EXT: signExtend
  port map(i_N	  => s_immIn,
       imm_S	  => s_imm_S,
       imm_O	  => s_ExtPre);

  ALU2: alu
  port map(A      => s_ALUin1,
       B          => s_ALUin2,
       ALUOp      => s_ALUOP1, 
       repl	  => s_replFinal,
       O 	  => s_aluOUT,
       Overflow   => Ov2,
       Zero       => s_ALUZeroLEGACY);

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  
  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  with s_ctrlIn select
  s_haltseen <= '1' when "010100",
  '0' when others;
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 
 


  with iRST select 
  s_PC_inFinal <= x"00400000" when '1',
  IF_PC when others;




  PC: NbitReg_struct --register for PC
  generic map(N => 32)
  port map(i_Reg    => s_PC_inFinal,
        o_Reg       => s_NextInstAddr,
	r_Reg       => '0',
	c_Reg       => iCLK,
	e_Reg       => '1');


  ADD_PC: adder_N 
  generic map(N => 32)
  port map(  --PC+4
	i_C    	=> '0',
	i_X1	=> s_NextInstAddr,
	i_X2	=> x"00000004",
	o_S 	=> s_PC_plus4,
	o_C	=> s_CarryUSELESS);

  s_allJBrJr <= s_jumpRegister or s_jump or s_branch;

  with s_allJBrJr select 
  IF_PC <= s_PC_plus4 when '0',
  s_PC_temp when others;



 FETCH: fetchLogic
    port map(i_Instruction	=> s_fetchIn,
             i_Sign_Ext		=> s_ExtPre,
             i_Branch		=> s_branch,
             i_Zero		=> s_ZeroTrue,
             i_Jump		=> s_jump,			--Value of the Jump control signal
             i_jr               => s_jumpRegister,		
             i_PC_4             => s_PC_plus4DECODE,
             i_JR_Reg           => s_ReadA,
             i_JR_RegForward    => s_PC_plus4_3,
             i_jrForwardSignal  => s_jumpALseen3,
             o_Pc    		=>  s_PC_temp);



  REG1_IF_ID: reg_if_id
  port map(i_PC_4    => s_PC_plus4,  
     i_Inst          => s_Inst,    
     i_clk	     => iCLK,    
     i_IF_Flush	     => s_allJBrJr,  
     i_reset	     => iRST, 
     i_IFID_Hazard   => '1', 
     o_Inst_Out	     => s_Inst_Reg_Out, 
     o_PC_4_Out	     => s_PC_plus4DECODE);




  s_DMemWr <= M_out_EXMEM; --MAKES SENSE BUT DOUBLE CHECK
  s_RegWr <= WB_out_MEMWB;
  s_writeMux <= s_writeRegMEMWB;
 
  

  REG_ID_EX2: reg_id_ex
  port map(i_ReadB       => s_ReadB,   
     i_ReadA         => s_ReadA, 
     i_SignExt       => s_ExtPre,
     i_rs            => s_rsIn, 
     i_rt            => s_rtIn, 
     i_rd            => s_rdIn, 
     i_clk           => iCLK,	    
     i_reset         => iRST,	     
     i_WB_in	     => s_RegWriteBack,    --double check 
     i_M_in	     => s_memWrite, --double check 
     i_EX_in         => s_RegDst,   --double check 
     i_halt1         => s_haltseen,
     i_JAL1           => s_jumpALseen,
     i_mem2Reg1       => s_mem2Reg,
     i_repl          => s_repl,
     i_ALUOP         => s_ALUOP,
     i_ALUSrc        => s_ALUSrc,
     i_Shift         => s_Shift,
     i_Ov1         => Ov1,
     i_PC4_2      => s_PC_plus4DECODE,
     i_jumpandbranch => s_branch,
     i_loadword  => s_memRead,
     o_loadword  => s_memRead1,
     o_jumpandbranch => s_JandB,
     i_IF_Flush => s_allJBrJr,
     o_PC4_2	  => s_PC_plus4_2,
     o_Ov1         => Ov1IDEX,
     o_Shift         => s_Shift2,
     o_ALUSrc        => s_ALUSrc2,
     o_ALUOP         =>  s_ALUOP1,
     o_repl          => s_replFinal,
     o_mem2Reg1       => s_mem2Reg1,
     o_halt1	     => s_haltseen2,
     o_JAL1           => s_jumpALseen2,
     o_WB_out	     => WB_out_IDEX,   
     o_M_out	     => M_out_IDEX,  
     o_EX_out        => EX_out_IDEX, 
     o_rs            => s_rsInPost,   
     o_rt 	     => s_rtInPost, 
     o_rd            => s_rdInPost, 
     o_ReadB	     => s_ReadB_Reg_Out,  
     o_SignExt       => s_Ext,  
     o_ReadA	     => s_ReadA_Reg_Out);

  with EX_out_IDEX select  --CHANGE FROM REGDST 
  s_writeRegTemp <= s_rdInPost when '1',
  s_rtInPost when others;



  MUX222: mux2t1_N
  port map(i_S     => s_JALandBrnach,
       i_D0        => s_aluOUT,
       i_D1        => s_PC_plus4_2,
       o_O        => s_ALUEXMEMIN);

  s_JALandBrnach <= s_JandB or s_jumpALseen2;
  with M_out_IDEX select
  sssss <= s_ReadB_Reg_Out when '1',
  s_ALUin2 when others;

  with s_jumpALseen2 select
  s_writeRegTempMAX <= b"11111" when '1',
  s_writeRegTemp when others;


  REG_EX_MEM3: reg_ex_mem
  port map(i_ALU2Reg      => s_ALUEXMEMIN,      
     i_ALUIn2         => sssss,  
     i_clk            => iCLK,    
     i_reset	      => iRST,   
     i_WB_in	      => WB_out_IDEX,  
     i_M_in	      => M_out_IDEX,  
     i_halt2         =>  s_haltseen2,
     i_JAL2           => s_jumpALseen2,
     i_mem2Reg2       => s_mem2Reg1,
     i_Ov_EXMEM      => s_Ov_EXMEM,
     i_PC4_3      => s_PC_plus4_2,
     i_IF_Flush => s_allJBrJr,
     i_loadword  => s_memRead1,
     o_loadword => s_memRead2,
     o_PC4_3	  => s_PC_plus4_3,
     o_Ov_EXMEM      => s_Ov_MEMWB,
     o_mem2Reg2       => s_mem2Reg2,
     o_JAL2           => s_jumpALseen3,
     o_halt2	     =>  s_haltseen3,
     o_WB_out	      => WB_out_EXMEM,  
     o_M_out	      => M_out_EXMEM,  
     i_writeRegEXMEM  => s_writeRegTempMAX,          
     o_writeRegEXMEM  => s_writeRegEXMEM,        
     o_DMEMAddr	      => s_DMemAddr, 
     o_DMEMData	      => s_DMemData);
  
  with s_memRead2 select
  s_DMEMorDATA <= s_DMemOut when '1',
  s_DMemAddr when others;



  REG_MEM_WB4: reg_mem_wb
  port map(i_DMEM_DATA    => s_DMemOut, 
     i_DMEM_ADDR      => s_DMemAddr, 
     i_clk	      => iCLK,    
     i_reset	      => iRST, 
     i_WB_in	      => WB_out_EXMEM, 
     i_writeRegMEMWB  => s_writeRegEXMEM, 
     i_halt3          =>  s_haltseen3,
     i_JAL3           => s_jumpALseen3,
     i_mem2Reg3       => s_mem2Reg2,
     i_Ov_MEMWB      => s_Ov_MEMWB,
     i_PC4_4      => s_PC_plus4_3,
     i_IF_Flush => s_allJBrJr,
     o_PC4_4	  => s_PC_plus4_4,
     o_Ov_MEMWB      => s_Ovfl,
     o_mem2Reg3       => s_mem2Reg3,
     o_JAL3           => s_jumpAL,
     o_halt3	      =>  s_Halt,
     o_writeRegMEMWB  => s_writeRegMEMWB, 
     o_WB_out	      => WB_out_MEMWB, 
     o_DMEM_ADDR      => s_DMemAddr_WB, 
     o_DMEM_DATA      => s_DMemOut_WB);


with s_mem2Reg3 select
  s_WriteBack  <= s_DMemOut_WB when '1',
  s_DMemAddr_WB when others;




  EQ: equals32to1
  port map(i_A       =>  s_ReadA,
       i_B           =>  s_ReadB,
       o_Equals      => s_ALUZero);



end structure;

