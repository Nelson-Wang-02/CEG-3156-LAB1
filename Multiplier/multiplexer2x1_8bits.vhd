LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity multiplexer2x1_8bits is 
	port (
	
		i_A, i_B : IN STD_LOGIC_VECTOR(7 downto 0);
		i_sel : IN STD_LOGIC;
		i_out : OUT STD_LOGIC_VECTOR(7 downto 0));
		
end multiplexer2x1_8bits;

architecture rtl of multiplexer2x1_8bits is 

	component multiplexer2x1_1bit is 
		port (
		
			i_A, i_B, i_sel : IN STD_LOGIC;
			i_out : OUT STD_LOGIC);
			
	end component;
	
	signal o_out : STD_LOGIC_VECTOR(7 downto 0); 
	
	begin
	
	m7: multiplexer2x1_1bit
		port map (
			i_A => i_A(7),
			i_B => i_B(7),
			i_sel => i_sel,
			i_out => o_out(7));

	m6: multiplexer2x1_1bit
		port map (
			i_A => i_A(6),
			i_B => i_B(6),
			i_sel => i_sel,
			i_out => o_out(6));

	m5: multiplexer2x1_1bit
		port map (
			i_A => i_A(5),
			i_B => i_B(5),
			i_sel => i_sel,
			i_out => o_out(5));		
			
	m4: multiplexer2x1_1bit
		port map (
			i_A => i_A(4),
			i_B => i_B(4),
			i_sel => i_sel,
			i_out => o_out(4));	
			
	m3: multiplexer2x1_1bit
		port map (
			i_A => i_A(3),
			i_B => i_B(3),
			i_sel => i_sel,
			i_out => o_out(3));	

	m2: multiplexer2x1_1bit
		port map (
			i_A => i_A(2),
			i_B => i_B(2),
			i_sel => i_sel,
			i_out => o_out(2));
			
	m1: multiplexer2x1_1bit
		port map (
			i_A => i_A(1),
			i_B => i_B(1),
			i_sel => i_sel,
			i_out => o_out(1));
			
	m0: multiplexer2x1_1bit
		port map (
			i_A => i_A(0),
			i_B => i_B(0),
			i_sel => i_sel,
			i_out => o_out(0));
	
	--output driver
	i_out <= o_out;
	
end rtl;