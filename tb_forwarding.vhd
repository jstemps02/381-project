-------------------------------------------------------------------------
-- Jacob Lyons
-------------------------------------------------------------------------

-- tb_forwarding.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file represents the forwarding module of a multi-
-- cycle processor
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_forwarding is
  generic(gCLK_HPER   : time := 50 ns);
end tb_forwarding;

architecture behavior of tb_forwarding is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component forwarding is				
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

  end component;

  -- Temporary signals to connect to the dff component.
signal s_ID_EX_Rs, s_ID_EX_Rt, s_EX_MEM_Rd, s_MEM_WB_Rd : std_logic_vector(4 downto 0);
signal s_Forward_A, s_Forward_B : std_logic_vector(1 downto 0);
signal s_CLK, s_EX_MEM_WB, s_MEM_WB_WB : std_logic;
begin

  DUT1: forwarding
  port map(i_ID_EX_Rs => s_ID_EX_Rs,
	   i_ID_EX_Rt => s_ID_EX_Rt,
	   i_EX_MEM_Rd => s_EX_MEM_Rd,
	   i_MEM_WB_Rd => s_MEM_WB_Rd,
	   i_EX_MEM_WB => s_EX_MEM_WB,
	   i_MEM_WB_WB => s_MEM_WB_WB,
	   o_Forward_A => s_Forward_A,
	   o_Forward_B => s_Forward_B);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
 P_CLK: process
 begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin

    --EX hazards

    s_ID_EX_Rs  <= b"01000";	--ForwardA = 10
    s_ID_EX_Rt  <= b"00000";	--ForwardB = 00
    s_EX_MEM_Rd <= b"01000";
    s_MEM_WB_Rd <= b"00000";
    s_EX_MEM_WB <= '1';
    s_MEM_WB_WB <= '0';

    wait for cCLK_PER;

    s_ID_EX_Rs  <= b"00000";	--ForwardA = 00
    s_ID_EX_Rt  <= b"01000";	--ForwardB = 10
    s_EX_MEM_Rd <= b"01000";
    s_MEM_WB_Rd <= b"00000";
    s_EX_MEM_WB <= '1';
    s_MEM_WB_WB <= '0';

    wait for cCLK_PER;

    s_ID_EX_Rs  <= b"01000";	--ForwardA = 10
    s_ID_EX_Rt  <= b"01000";	--ForwardB = 10
    s_EX_MEM_Rd <= b"01000";
    s_MEM_WB_Rd <= b"00000";
    s_EX_MEM_WB <= '1';
    s_MEM_WB_WB <= '0';

    wait for cCLK_PER;

    -- MEM hazards

    s_ID_EX_Rs  <= b"01000";	--ForwardA = 01
    s_ID_EX_Rt  <= b"00000";	--ForwardB = 00
    s_EX_MEM_Rd <= b"00000";
    s_MEM_WB_Rd <= b"01000";
    s_EX_MEM_WB <= '0';
    s_MEM_WB_WB <= '1';

    wait for cCLK_PER;

    s_ID_EX_Rs  <= b"00000";	--ForwardA = 00
    s_ID_EX_Rt  <= b"01000";	--ForwardB = 01
    s_EX_MEM_Rd <= b"00000";
    s_MEM_WB_Rd <= b"01000";
    s_EX_MEM_WB <= '0';
    s_MEM_WB_WB <= '1';

    wait for cCLK_PER;

    s_ID_EX_Rs  <= b"01000";	--ForwardA = 01
    s_ID_EX_Rt  <= b"01000";	--ForwardB = 01
    s_EX_MEM_Rd <= b"00000";
    s_MEM_WB_Rd <= b"01000";
    s_EX_MEM_WB <= '0';
    s_MEM_WB_WB <= '1';

    wait for cCLK_PER;

    -- EX hazards override MEM hazards

    s_ID_EX_Rs  <= b"01000";	--ForwardA = 10
    s_ID_EX_Rt  <= b"00000";	--ForwardB = 00
    s_EX_MEM_Rd <= b"01000";
    s_MEM_WB_Rd <= b"01000";
    s_EX_MEM_WB <= '1';
    s_MEM_WB_WB <= '1';

    wait for cCLK_PER;

    s_ID_EX_Rs  <= b"00000";	--ForwardA = 00
    s_ID_EX_Rt  <= b"01000";	--ForwardB = 10
    s_EX_MEM_Rd <= b"01000";
    s_MEM_WB_Rd <= b"01000";
    s_EX_MEM_WB <= '1';
    s_MEM_WB_WB <= '1';

    wait for cCLK_PER;

    s_ID_EX_Rs  <= b"01000";	--ForwardA = 10
    s_ID_EX_Rt  <= b"01000";	--ForwardB = 10
    s_EX_MEM_Rd <= b"01000";
    s_MEM_WB_Rd <= b"01000";
    s_EX_MEM_WB <= '1';
    s_MEM_WB_WB <= '1';

    wait for cCLK_PER;

    -- No hazards (because last statement not equal)

    s_ID_EX_Rs  <= b"01001";	--ForwardA = 00
    s_ID_EX_Rt  <= b"01001";	--ForwardB = 00
    s_EX_MEM_Rd <= b"00000";
    s_MEM_WB_Rd <= b"01000";
    s_EX_MEM_WB <= '1';
    s_MEM_WB_WB <= '1';

    wait for cCLK_PER;

    s_ID_EX_Rs  <= b"01001";	--ForwardA = 00
    s_ID_EX_Rt  <= b"01001";	--ForwardB = 00
    s_EX_MEM_Rd <= b"01000";
    s_MEM_WB_Rd <= b"00000";
    s_EX_MEM_WB <= '1';
    s_MEM_WB_WB <= '1';

    wait for cCLK_PER;

    -- No hazards (because WB is 0)

    s_ID_EX_Rs  <= b"11000";	--ForwardA = 00
    s_ID_EX_Rt  <= b"11000";	--ForwardB = 00
    s_EX_MEM_Rd <= b"00000";
    s_MEM_WB_Rd <= b"00000";
    s_EX_MEM_WB <= '0';
    s_MEM_WB_WB <= '0';

    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
