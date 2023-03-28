library IEEE;
use IEEE.std_logic_1164.all;

entity regfile is
port(i_rs            : in std_logic_vector(4 downto 0);
     i_rd            : in std_logic_vector(4 downto 0);
     i_rt            : in std_logic_vector(4 downto 0);
     i_data	     : in std_logic_vector(31 downto 0);
     i_clk	     : in std_logic;
     writeEn	     : in std_logic;
     i_reset	     : in std_logic;
     o_rs	     : out std_logic_vector(31 downto 0);
     o_rt	     : out std_logic_vector(31 downto 0));

end regfile;

architecture structural of regfile is
	
	component nbitreg_struct is
		generic(N : integer := 32);
		port(i_Reg       : in std_logic_vector(31 downto 0);
       		o_Reg            : out std_logic_vector(31 downto 0);
		r_Reg            : in std_logic;
		c_Reg            : in std_logic;
		e_Reg            : in std_logic);
	end component;

	component decoder5to32 is
		port(i_S             : in std_logic_vector(4 downto 0);
  		     i_En             : in std_logic;
    		     o_O             : out std_logic_vector(31 downto 0));
	end component;

	component mux32to1 is
 		 port(i_S             : in std_logic_vector(4 downto 0);
     		 i_M             : in std_logic_vector(31 downto 0);
     		 o_O             : out std_logic);
	end component;
signal decodeOut : std_logic_vector(31 downto 0);
signal decodeOutMod : std_logic_vector(31 downto 0);
signal regOut : std_logic_vector(1023 downto 0);
begin
  DECI: decoder5to32 port map(
	i_S => i_rd,
	i_En => writeEn,
	o_O => decodeOut);
  G_NReg: for i in 1 to 32 generate
    REGN: nbitreg_struct port map(
              i_Reg    => i_data,      -- All instances share the same select input.
              r_Reg    => i_reset,  -- ith instance's data 0 input hooked up to ith data 0 input.
              c_Reg    => i_clk,  -- ith instance's data 1 input hooked up to ith data 1 input.
              e_Reg    => decodeOutMod(i -1),
	      o_Reg    => regOut(((i*32) -1) downto ((i * 32) - 32)));  -- ith instance's data output hooked up to ith data output.
  end generate G_NReg;

decodeOutMod <= decodeOut and x"FFFF_FFFE";



  G_NMUX1: for i in 0 to 31 generate
    MUX1: mux32to1 port map(
 	i_S => i_rt,
        i_M(0) => regOut(i), -- 0, 32,64,96,
	i_M(1) => regOut(i + 1 * 32), -- 32,33, 63,97
	i_M(2) => regOut(i + 2 * 32),
	i_M(3) => regOut(i + 3 * 32),
	i_M(4) => regOut(i + 4 * 32),
	i_M(5) => regOut(i + 5 * 32),
	i_M(6) => regOut(i + 6 * 32),
	i_M(7) => regOut(i + 7 * 32),
	i_M(8) => regOut(i + 8 * 32),
	i_M(9) => regOut(i + 9 * 32),
	i_M(10) => regOut(i + 10 * 32),
	i_M(11) => regOut(i + 11 * 32),
	i_M(12) => regOut(i + 12 * 32),
	i_M(13) => regOut(i + 13 * 32),
	i_M(14) => regOut(i + 14 * 32),
	i_M(15) => regOut(i + 15 * 32),
	i_M(16) => regOut(i + 16 * 32),
	i_M(17) => regOut(i + 17 * 32),
	i_M(18) => regOut(i + 18 * 32),
	i_M(19) => regOut(i + 19 * 32),
	i_M(20) => regOut(i + 20 * 32),
	i_M(21) => regOut(i + 21 * 32),
	i_M(22) => regOut(i + 22 * 32),
	i_M(23) => regOut(i + 23 * 32),
	i_M(24) => regOut(i + 24 * 32),
	i_M(25) => regOut(i + 25 * 32),
	i_M(26) => regOut(i + 26 * 32),
	i_M(27) => regOut(i + 27 * 32),
	i_M(28) => regOut(i + 28 * 32),
	i_M(29) => regOut(i + 29 * 32),
	i_M(30) => regOut(i + 30 * 32),
	i_M(31) => regOut(i + 31 * 32),
        o_O => o_rt(i));
  end generate G_NMUX1;

  G_NMUX2: for i in 0 to 31 generate
    MUX2: mux32to1 port map(
	i_S    => i_rs,
        i_M(0) => regOut(i),
	i_M(1) => regOut(i + 1 * 32),
	i_M(2) => regOut(i + 2 * 32),
	i_M(3) => regOut(i + 3 * 32),
	i_M(4) => regOut(i + 4 * 32),
	i_M(5) => regOut(i + 5 * 32),
	i_M(6) => regOut(i + 6 * 32),
	i_M(7) => regOut(i + 7 * 32),
	i_M(8) => regOut(i + 8 * 32),
	i_M(9) => regOut(i + 9 * 32),
	i_M(10) => regOut(i + 10 * 32),
	i_M(11) => regOut(i + 11 * 32),
	i_M(12) => regOut(i + 12 * 32),
	i_M(13) => regOut(i + 13 * 32),
	i_M(14) => regOut(i + 14 * 32),
	i_M(15) => regOut(i + 15 * 32),
	i_M(16) => regOut(i + 16 * 32),
	i_M(17) => regOut(i + 17 * 32),
	i_M(18) => regOut(i + 18 * 32),
	i_M(19) => regOut(i + 19 * 32),
	i_M(20) => regOut(i + 20 * 32),
	i_M(21) => regOut(i + 21 * 32),
	i_M(22) => regOut(i + 22 * 32),
	i_M(23) => regOut(i + 23 * 32),
	i_M(24) => regOut(i + 24 * 32),
	i_M(25) => regOut(i + 25 * 32),
	i_M(26) => regOut(i + 26 * 32),
	i_M(27) => regOut(i + 27 * 32),
	i_M(28) => regOut(i + 28 * 32),
	i_M(29) => regOut(i + 29 * 32),
	i_M(30) => regOut(i + 30 * 32),
	i_M(31) => regOut(i + 31 * 32),
        o_O  => o_rs(i));

end generate G_NMUX2;

end structural;