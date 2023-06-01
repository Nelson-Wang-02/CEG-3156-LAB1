LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity fp_multiplier is 
	port (
		i_A, i_B : IN STD_LOGIC_VECTOR(15 downto 0); --16 bit floating point numbers: 1 sign bit, 7-bit exponent, 8-bit mantissa (9 bits including implicit 1).
		GClock : IN STD_LOGIC;
		GResetBar : IN STD_LOGIC;
		en_mult : IN STD_LOGIC;
		o_result : OUT STD_LOGIC_VECTOR(15 downto 0)); --16-bit fp output

end fp_multiplier; 

architecture rtl of fp_multiplier is 

	component enARdFF_2 
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);	
	
	end component;

	component nineBitRegister --for mantissa
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(8 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(8 downto 0));
	end component;
		
	component sevenBitRegister --for exponent
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(6 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(6 downto 0));
	end component;

	component sevenBitAdder
		PORT(
			i_Cin : 	IN STD_LOGIC; -- signal from control path. 
			i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(6 downto 0);
			
			o_CarryOut		: OUT	STD_LOGIC;
			o_Sum			: OUT	STD_LOGIC_VECTOR(6 downto 0));
	end component;
	
	component eightBitSubtractor IS
		PORT(
			i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(7 downto 0);
			
			o_CarryOut		: OUT	STD_LOGIC;
			o_Diff			: OUT	STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component nineBitMultiplier --for mantissa

		port (
			clock : IN STD_LOGIC;
			resetBar : IN STD_LOGIC;
			IN1, IN2 : IN STD_LOGIC_VECTOR(8 downto 0);
			en_mult : IN STD_LOGIC;
			o_product : OUT STD_LOGIC_VECTOR(17 downto 0));
	
	end component;
	
	component multiplexer2x1_1bit
		port (
			i_A, i_B, i_sel : IN STD_LOGIC;
			i_out : OUT STD_LOGIC);
			
	end component;
	
	component multiplexer2x1_8bits 
		port (
			i_A, i_B : IN STD_LOGIC_VECTOR(7 downto 0);
			i_sel : IN STD_LOGIC;
			i_out : OUT STD_LOGIC_VECTOR(7 downto 0));
		
	end component;

	--Sign signals
	signal o_signA, o_signB, o_sign : STD_LOGIC; 
	signal not_signA, not_signB : STD_LOGIC;
	
	--Exponent signals
	signal o_expA, o_expB : STD_LOGIC_VECTOR(6 downto 0);
	signal o_expCout1, o_expCout0 : STD_LOGIC;
	signal o_sum1 : STD_LOGIC_VECTOR(7 downto 0);
	signal o_sum0 : STD_LOGIC_VECTOR(6 downto 0);
	signal o_diff : STD_LOGIC_VECTOR(7 downto 0);
	signal o_fDiff : STD_LOGIC_VECTOR(6 downto 0);
	signal o_subCout : STD_LOGIC;
	
	signal o_muxOut1 : STD_LOGIC;
	signal i_muxOut1 : STD_LOGIC_VECTOR(6 downto 0);
	
	signal int_mantA, int_mantB : STD_LOGIC_VECTOR(8 downto 0);
	signal reg_mantA, reg_mantB : STD_LOGIC_VECTOR(8 downto 0);
	signal prod_mant : STD_LOGIC_VECTOR(17 downto 0);
	signal mux_mant1, mux_mant0 : STD_LOGIC_VECTOR(7 downto 0);
	signal o_mant : STD_LOGIC_VECTOR(7 downto 0);
	
	begin 
	
	--concurrent signal assignment 

	o_sign <= o_signA xor o_signB; --sign bits
	o_sum1(7) <= o_expCout1; 
	
	o_fDiff <= o_diff(6 downto 0); --only 7 bits needed from subtractor
	
	int_mantA <= '1' & i_A(7 downto 0); --include implicit 1
	int_mantB <= '1' & i_A(7 downto 0);
	
	i_muxOut1 <= "000000" & o_muxOut1;

	mux_mant0 <= prod_mant(15 downto 8);
	mux_mant1 <= prod_mant(16 downto 9);
	
	
	-- sign registers
	s1: enARdFF_2 
		PORT MAP(
			i_resetBar => GResetBar,
			i_d => i_A(15),		
			i_enable => en_mult,	
			i_clock => GClock,		
			o_q => o_signA, 
			o_qBar => not_signA);	
	
	s0: enARdFF_2 
		PORT MAP(
			i_resetBar => GResetBar,
			i_d => i_B(15),		
			i_enable => en_mult,	
			i_clock => GClock,		
			o_q => o_signB, 
			o_qBar => not_signB);
	
	--Exponent Operations
	e1: sevenBitRegister 
		port map(
			i_resetBar => GResetBar,
			i_load => en_mult,	
			i_clock => GClock,		
			i_Value => i_A(14 downto 8),			
			o_Value => o_expA);
	
	e0: sevenBitRegister 
		port map(
			i_resetBar => GResetBar,
			i_load => en_mult,	
			i_clock => GClock,		
			i_Value => i_B(14 downto 8),			
			o_Value => o_expB);	
			
	addExp1: sevenBitAdder
		PORT MAP(
			i_Cin => '0', 	
			i_Ai => o_expA, 
			i_Bi => o_expB,
			o_CarryOut => o_expCout1,
			o_Sum => o_sum1(6 downto 0));		
			
	subExp1: eightBitSubtractor
		PORT MAP(
			i_Ai => o_sum1, 
			i_Bi => "00111111",	--63 in binary
			o_CarryOut => o_subCout,
			o_Diff => o_diff);		
	
	addExp0: sevenBitAdder
		PORT MAP(
			i_Cin => '0', 	
			i_Ai => o_fDiff, 
			i_Bi => i_muxOut1,
			o_CarryOut => o_expCout0,
			o_Sum => o_sum0);	
	
	mux1: multiplexer2x1_1bit
		port map (
			i_A => '1', 
			i_B => '0', 
			i_sel => prod_mant(17),
			i_out => o_muxOut1);
			
	--Mantissa Operations
	
	m1: nineBitRegister 
		PORT MAP(
			i_resetBar => GResetBar, 
			i_load => en_mult, 
			i_clock => GClock,
			i_Value => int_mantA,
			o_Value => reg_mantA);
	
	m0: nineBitRegister 
		PORT MAP(
			i_resetBar => GResetBar, 
			i_load => en_mult, 
			i_clock => GClock,
			i_Value => int_mantB,
			o_Value => reg_mantB);

	mantMult: nineBitMultiplier
		port map (
			clock => GClock,
			resetBar => GResetBar,
			IN1 => reg_mantA, 
			IN2 => reg_mantB,
			en_mult=> en_mult,
			o_product => prod_mant);
	
	mantMux: multiplexer2x1_8bits 
		port map(
			i_A => mux_mant1, 
			i_B => mux_mant0, 
			i_sel => prod_mant(17),
			i_out => o_mant);
	
	--output driver
	o_result(15) <= o_sign; --sign bit
	o_result(14 downto 8) <= o_sum0; --Exponent
	o_result(7 downto 0) <= o_mant;
	
	
end rtl; 