LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity binaryMultDatapath is 
	
	port (
		--inputs
		i_A : IN STD_LOGIC_VECTOR(17 downto 0); 
		i_B : IN STD_LOGIC_VECTOR(8 downto 0);
		
		--control signals
		shft_A, shift_B : IN STD_LOGIC; 
		en_mult : IN STD_LOGIC;
		clr_P : IN STD_LOGIC;
		en_P : IN STD_LOGIC;
		
		--outputs
		o_product : OUT STD_LOGIC_VECTOR(17 downto 0);
		
		z, b0 : OUT STD_LOGIC);
	
end binaryMultDatapath;

architecture rtl of binaryMultDatapath is 





	begin 
	
	
	