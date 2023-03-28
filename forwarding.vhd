-------------------------------------------------------------------------
-- Jacob Lyons jplyons1
-------------------------------------------------------------------------


-- forwarding.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural VHDL implementation of
-- the CPU's forwarding unit
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity forwarding is	--Used for data hazards					

  port(	i_ID_EX_Rs	: in std_logic_vector(4 downto 0);	--Rs value of ID/EX
        i_ID_EX_Rt	: in std_logic_vector(4 downto 0);	--Rt value of ID/EX
	i_EX_MEM_Rd	: in std_logic_vector(4 downto 0);	--Rd value of EX/MEM (Write Reg)
        i_MEM_WB_Rd	: in std_logic_vector(4 downto 0);	--Rd value of MEM/WB (Write Reg)
	i_EX_MEM_WB	: in std_logic;				--WB value of EX/MEM (Reg Write)
        i_MEM_WB_WB	: in std_logic;				--WB value of MEM/WB (Reg Write)

	o_Forward_A	: out std_logic_vector(1 downto 0);	--Output as the control of the middle MUX before MEM/WB

		--o_ForwardA = 00 	from ID/EX 	The first ALU input comes directly from the register file.
		--o_ForwardA = 10 	from EX/MEM 	The first ALU input is forwarded from the previous result of the ALU.
		--o_ForwardA = 01 	from MEM/WB 	The first ALU input is forwarded from the data memory or from a previous result of the  ALU.

	o_Forward_B	: out std_logic_vector(1 downto 0));	--Output as the control of the top MUX before MEM/WB

		--o_ForwardB = 00 	from ID/EX 	The second ALU input comes directly from the register file.
		--o_ForwardB = 10 	from EX/MEM 	The second ALU input is forwarded from the previous result of the ALU.
		--o_ForwardB = 01 	from MEM/WB 	The second ALU input is forwarded from the data memory or from a previous result of the ALU.

end forwarding;

architecture structural of forwarding is

  signal s_And_Ex_5		: std_logic;			--EX/MEM.WriteReg != 0
  signal s_And_Ex		: std_logic;			--EX/MEM.RegWrite && EX/MEM.WriteReg != 0
  signal s_And_Mem_5		: std_logic;			--MEM/WB.WriteReg != 0
  signal s_And_Mem		: std_logic;			--MEM/WB.RegWrite && MEM/WB.WriteReg != 0
  signal s_Equals_1		: std_logic;			--EX/MEM.WriteReg == ID/EX.Rs
  signal s_Equals_2		: std_logic;			--EX/MEM.WriteReg == ID/EX.Rt
  signal s_Equals_3		: std_logic;			--MEM/WB.WriteReg == ID/EX.Rs
  signal s_Equals_4		: std_logic;			--MEM/WB.WriteReg == ID/EX.Rt
  signal s_ex_hazard_A		: std_logic;			--1 if hazard is present, will output 01
  signal s_ex_hazard_B		: std_logic;			--1 if hazard is present, will output 01
  signal s_not_ex_hazard_A	: std_logic;			--0 if hazard is present, used for mem hazard
  signal s_not_ex_hazard_B	: std_logic;			--0 if hazard is present, used for mem hazard
  signal s_mem_A_Imm1		: std_logic;			
  signal s_mem_B_Imm1		: std_logic;				



  component andg2 is
    port(i_A         : in std_logic;
         i_B         : in std_logic;
         o_F         : out std_logic);
  end component;

  component or5to1 is
    port(i_N         : in std_logic_vector(4 downto 0);
         o_Or       : out std_logic);
  end component;

  component equals5to1 is
    port(i_A         : in std_logic_vector(4 downto 0);
         i_B         : in std_logic_vector(4 downto 0);
         o_Equals    : out std_logic);
  end component;

  component and5 is
    port(i_1         : in std_logic_vector(4 downto 0);
         i_2         : in std_logic_vector(4 downto 0);
         o_And       : out std_logic_vector(4 downto 0));
  end component;

  component xorg2 is
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

begin

  --EX Hazards

  AND_EX: or5to1 port map(			--EX/MEM.WriteReg != 0			
	i_N    	=> i_EX_MEM_Rd,
	o_Or	=> s_And_Ex_5);

  s_And_Ex <= i_EX_MEM_WB and s_And_Ex_5; 	--EX/MEM.RegWrite && EX/MEM.WriteReg != 0

  EX_A_EQ: equals5to1 port map(	--EX/MEM.WriteReg == ID/EX.Rs				
	i_A    	=> i_EX_MEM_Rd,
	i_B	=> i_ID_EX_Rs,
	o_Equals	=> s_Equals_1);

  EX_B_EQ: equals5to1 port map(	--EX/MEM.WriteReg == ID/EX.Rt
	i_A    	=> i_EX_MEM_Rd,
	i_B	=> i_ID_EX_Rt,
	o_Equals	=> s_Equals_2);

  EX_A: andg2 port map(			--if(EX/MEM.RegWrite && EX/MEM.WriteReg != 0 && EX/MEM.WriteReg == ID/EX.Rs)
	i_A    	=> s_And_Ex,		
	i_B	=> s_Equals_1,
	o_F	=> s_ex_hazard_A);

  EX_B: andg2 port map(			--if(EX/MEM.RegWrite && EX/MEM.WriteReg != 0 && EX/MEM.WriteReg == ID/EX.Rt)
	i_A    	=> s_And_Ex,
	i_B	=> s_Equals_2,
	o_F	=> s_ex_hazard_B);

  o_Forward_A(1) <= s_ex_hazard_A;
  o_Forward_B(1) <= s_ex_hazard_B;

  --MEM Hazards

  AND_MEM: or5to1 port map(			--MEM/WB.WriteReg != 0			
	i_N    	=> i_MEM_WB_Rd,
	o_Or	=> s_And_Mem_5);

  s_And_Mem <= i_MEM_WB_WB and s_And_Mem_5; 	--MEM/WB.RegWrite && MEM/WB.WriteReg != 0

  MEM_A_EQ: equals5to1 port map(	--MEM/WB.WriteReg == ID/EX.Rs				
	i_A    	=> i_MEM_WB_Rd,
	i_B	=> i_ID_EX_Rs,
	o_Equals	=> s_Equals_3);

  MEM_B_EQ: equals5to1 port map(	--MEM/WB.WriteReg == ID/EX.Rt
	i_A    	=> i_MEM_WB_Rd,
	i_B	=> i_ID_EX_Rt,
	o_Equals	=> s_Equals_4);

  MEM_A_IMM: andg2 port map(		--if(MEM/WB.RegWrite && MEM/WB.WriteReg != 0 && MEM/WB.WriteReg == ID/EX.Rs)
	i_A    	=> s_And_Mem,		
	i_B	=> s_Equals_3,
	o_F	=> s_mem_A_Imm1);

  MEM_B_IMM: andg2 port map(		--if(MEM/WB.RegWrite && MEM/WB.WriteReg != 0 && MEM/WB.WriteReg == ID/EX.Rt)
	i_A    	=> s_And_Mem,
	i_B	=> s_Equals_4,
	o_F	=> s_mem_B_Imm1);

  NOT_EX_A: xorg2 port map(		--!(EX HAZARD A) (acts as a not gate)
	i_A    	=> '1',		
	i_B	=> s_ex_hazard_A,
	o_F	=> s_not_ex_hazard_A);

  NOT_EX_B: xorg2 port map(		--!(EX HAZARD B) (acts as a not gate)
	i_A    	=> '1',		
	i_B	=> s_ex_hazard_B,
	o_F	=> s_not_ex_hazard_B);

  MEM_A: andg2 port map(		--if(MEM/WB.RegWrite && MEM/WB.WriteReg != 0 && MEM/WB.WriteReg == ID/EX.Rs && !(EX HAZARD A))
	i_A    	=> s_mem_A_Imm1,		
	i_B	=> s_not_ex_hazard_A,
	o_F	=> o_Forward_A(0));

  MEM_B: andg2 port map(		--if(MEM/WB.RegWrite && MEM/WB.WriteReg != 0 && MEM/WB.WriteReg == ID/EX.Rt && !(EX HAZARD B))
	i_A    	=> s_mem_B_Imm1,
	i_B	=> s_not_ex_hazard_B,
	o_F	=> o_Forward_B(0));

end structural;
