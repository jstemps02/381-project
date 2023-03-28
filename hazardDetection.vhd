-------------------------------------------------------------------------
-- Jacob Lyons jplyons1
-------------------------------------------------------------------------

-- hazardDetection.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural VHDL implementation of
-- the multi-cycle CPU's hazard detection 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity hazardDetection is					

  port(	i_IF_ID_Rs	: in std_logic_vector(4 downto 0);	--IF/ID.rs
	i_IF_ID_Rt	: in std_logic_vector(4 downto 0);	--IF/ID.rt
	i_ID_EX_Rt	: in std_logic_vector(4 downto 0);	--ID/EX.rt
       	i_ID_EX_Read  	: in std_logic;				--ID/EX's M (MemRead)
       	o_IF_ID_Write	: out std_logic;			--Write enable to IF/ID
       	o_PC_Write	: out std_logic;			--Write enable to PC
       	o_ID_EX_Select	: out std_logic);			--Used at the select value for the MUX after control (Selects between control (0, no stall) and 000000000 (1, stall))

end hazardDetection;

architecture structural of hazardDetection is

  signal s_stall : std_logic;	--If 1, stall
  signal s_equals1 : std_logic; --ID/EX.rt == IF/ID.rs
  signal s_equals2 : std_logic;	--ID/EX.rt == IF/ID.rt

  component equals5to1 is
    port(i_A         : in std_logic_vector(4 downto 0);
         i_B         : in std_logic_vector(4 downto 0);
         o_Equals    : out std_logic);
  end component;

begin

  EQ_1: equals5to1 port map(		--ID/EX.rt == IF/ID.rs				
	i_A    		=> i_ID_EX_Rt,
	i_B		=> i_IF_ID_Rs,
	o_Equals	=> s_equals1);

  EQ_2: equals5to1 port map(		--ID/EX.rt == IF/ID.rt	(Is the destination of EX load the same as one of the source registers of the ID-stage instruction?			
	i_A    		=> i_ID_EX_Rt,
	i_B		=> i_IF_ID_Rt,
	o_Equals	=> s_equals2);

  s_stall <= (s_equals1 or s_equals2) and i_ID_EX_Read;	--Stall the pipeline if true

  o_ID_EX_Select <= s_stall; 				--Output to the MUX after control. If 1, select 000000000 (sets all control values as 0). If 0, select the control values

  o_IF_ID_Write <= not s_stall; 			--If there is a stall, IF/ID register must remain unchanged, so disable writing to it

  o_PC_Write <= not s_stall; 				--If there is a stall, PC register must remain unchanged, so disable writing to it

end structural;
