LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity binaryMultControlPath is 

	port (
		i_resetBar : IN STD_LOGIC;
		b0 : IN STD_LOGIC;  
		en_mult : IN STD_LOGIC; 
		z : IN STD_LOGIC; 
		clk : IN STD_LOGIC; 
		loadReg : OUT STD_LOGIC;
		en_P : OUT STD_LOGIC;
		Psel : OUT STD_LOGIC;
		shft_A, shft_B : OUT STD_LOGIC);
		
end binaryMultControlPath; 

architecture rtl of binaryMultControlPath is 

	component ARdFF_0
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);	
	end component;
	
	component ARdFF 
		PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);	
	end component;
	
	signal o_s1, o_s2, o_s3, o_s4, o_s5 : STD_LOGIC; 
	signal no_s1, no_s2, no_s3, no_s4, no_s5 : STD_LOGIC;
	signal i_s1, i_s2, i_s3, i_s4, i_s5 : STD_LOGIC;
	
	begin 
	
	i_s1 <= (o_s1 and not(en_mult)) or (not(en_mult) and o_s4);
	i_s2 <= (o_s1 and b0 and en_mult) or (z and b0 and o_s5);
	i_s3 <= (z and not(b0) and o_s5) or o_s2 or (o_s1 and en_mult and not(b0));
	i_s4 <= (not(z) and o_s5) or (o_s4 and en_mult);
	i_s5 <= o_s3;

	s1: ARdFF_0
		PORT MAP (
			i_resetBar => i_resetBar,
			i_d => i_s1,		
			i_clock => clk,		
			o_q => o_s1, 
			o_qBar => no_s1);			
		
	s2: ARdFF 
		PORT MAP(
			i_resetBar => i_resetBar,
			i_d => i_s2,		
			i_clock => clk,	
			o_q => o_s2, 
			o_qBar => no_s2);
	
	s3: ARdFF 
		PORT MAP(
			i_resetBar => i_resetBar,
			i_d => i_s3,		
			i_clock => clk,		
			o_q => o_s3, 
			o_qBar => no_s3);

	s4: ARdFF 
		PORT MAP(
			i_resetBar => i_resetBar,
			i_d => i_s4,		
			i_clock => clk,		
			o_q => o_s4, 
			o_qBar => no_s4);
			
	s5: ARdFF 
		PORT MAP(
			i_resetBar => i_resetBar,
			i_d => i_s5,		
			i_clock => clk,		
			o_q => o_s5, 
			o_qBar => no_s5);
			
	--output drivers
	shft_A <= o_s3; 
	shft_B <= o_s3;
	en_P <= o_s2 or o_s1;
	Psel <= o_s2;
	loadReg <= o_s1 or o_s3;
			
end rtl; 