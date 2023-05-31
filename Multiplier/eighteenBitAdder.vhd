LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity eighteenBitAdder is 

	port (
		i_Cin 		: IN STD_LOGIC;
		i_A, i_B 	: IN STD_LOGIC_VECTOR(17 downto 0);
		o_carryOut	: OUT	STD_LOGIC;
		o_Sum			: OUT	STD_LOGIC_VECTOR(17 downto 0));
		
end eighteenBitAdder;

architecture rtl of eighteenBitAdder is 

	component nineBitAdder
		PORT(
			i_Cin : 	IN STD_LOGIC; -- signal from control path. 
			i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(8 downto 0);
			
			o_CarryOut		: OUT	STD_LOGIC;
			o_Sum			: OUT	STD_LOGIC_VECTOR(8 downto 0));
	
	end component;
	
	signal i_pA0, i_pA1, i_pB0, i_pB1 : STD_LOGIC_VECTOR(8 downto 0); --partial inputs
	signal p_sum0, p_sum1 : STD_LOGIC_VECTOR(8 downto 0); --partial sums
	signal out_sum : STD_LOGIC_VECTOR(17 downto 0);
	signal c_out : STD_LOGIC; 
	signal c_out_passthrough: STD_LOGIC;
	
	begin 
	
	--concurrent signal assignment
	i_pA1 <= i_A(17 downto 9);
	i_pA0 <= i_A(8 downto 0);
	
	i_pB1 <= i_B(17 downto 9);
	i_pB0 <= i_B(8 downto 0);
	
	out_sum(17 downto 9) <= p_sum1; 
	out_sum(8 downto 0) <= p_sum0;
	
	add1: nineBitAdder --adder containing the msb.
		port map (
			i_Cin =>	c_out_passthrough,
			i_Ai => i_pA1,
			i_Bi => i_pB1,	
			o_CarryOut	=> c_out,
			o_Sum =>	p_sum1);
	
	add0: nineBitAdder --adder containing the lsb.
		port map (
			i_Cin =>	i_Cin,	
			i_Ai => i_pA0,
			i_Bi => i_pB0,	
			o_CarryOut	=> c_out_passthrough,
			o_Sum => p_sum0);
	
	--Output drivers
	o_carryOut <= c_out; 
	o_Sum <= out_sum;
	
end rtl; 