LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity multiplexer2x1_1bit is 
	port (
	
		i_A, i_B, i_sel : IN STD_LOGIC;
		i_out : OUT STD_LOGIC);
		
end multiplexer2x1_1bit;

architecture rtl of multiplexer2x1_1bit is 

	signal choice : STD_LOGIC;
	
	begin 
	
	choice <= (i_sel and i_A) or (not(i_sel) and i_B);
	
	i_out <= choice; 
	
end rtl;