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

entity branch_Forward is	--Used for data hazards					

  port(	i_ID_EX_Rd	: in std_logic_vector(4 downto 0);	--Rd value of ID/EX
	i_EX_MEM_Rd	: in std_logic_vector(4 downto 0);	--Rd value of EX/MEM (Write Reg)
        i_BranchA  	: in std_logic_vector(4 downto 0);	--Rd value of MEM/WB (Write Reg)
        i_BranchB	: in std_logic_vector(4 downto 0);	--Rd value of MEM/WB (Write Reg)

	o_ForwardBranch_A	: out std_logic_vector(1 downto 0);	--Output as the control of the middle MUX before MEM/WB

		--o_ForwardA = 00 	from ID/EX 	The first ALU input comes directly from the register file.
		--o_ForwardA = 10 	from EX/MEM 	The first ALU input is forwarded from the previous result of the ALU.
		--o_ForwardA = 01 	from MEM/WB 	The first ALU input is forwarded from the data memory or from a previous result of the  ALU.

	o_ForwardBranch_B	: out std_logic_vector(1 downto 0));	--Output as the control of the top MUX before MEM/WB

		--o_ForwardB = 00 	from ID/EX 	The second ALU input comes directly from the register file.
		--o_ForwardB = 10 	from EX/MEM 	The second ALU input is forwarded from the previous result of the ALU.
		--o_ForwardB = 01 	from MEM/WB 	The second ALU input is forwarded from the data memory or from a previous result of the ALU.

end branch_Forward;







architecture structural of branch_Forward is

signal s_Equals_A1, s_Equals_A2, s_Equals_B1, s_Equals_B2	:  std_logic;



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

  EX_A1_EQ: equals5to1 port map(	--EX/MEM.WriteReg == ID/EX.Rs				
	i_A    	=> i_ID_EX_Rd,
	i_B	=> i_BranchA,
	o_Equals => o_ForwardBranch_A(0));

  EX_A2_EQ: equals5to1 port map(	--EX/MEM.WriteReg == ID/EX.Rt
	i_A    	=> i_EX_MEM_Rd,
	i_B	=> i_BranchA,
	o_Equals	=> o_ForwardBranch_A(1));


  EX_B1_EQ: equals5to1 port map(	--EX/MEM.WriteReg == ID/EX.Rs				
	i_A    	=> i_ID_EX_Rd,
	i_B	=> i_BranchB,
	o_Equals	=> o_ForwardBranch_B(0));

  EX_B2_EQ: equals5to1 port map(	--EX/MEM.WriteReg == ID/EX.Rt
	i_A    	=> i_EX_MEM_Rd,
	i_B	=> i_BranchB,
	o_Equals	=>o_ForwardBranch_B(1));

 

end structural;