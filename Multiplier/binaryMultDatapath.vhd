LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity binaryMultDatapath is 
	
	port (
		--inputs
		i_A : IN STD_LOGIC_VECTOR(8 downto 0); 
		i_B : IN STD_LOGIC_VECTOR(8 downto 0);
		
		--control signals
		resetBar : IN STD_LOGIC; 
		shft_A, shft_B : IN STD_LOGIC; 
		loadReg : IN STD_LOGIC;
		Psel : IN STD_LOGIC;
		en_P : IN STD_LOGIC;
		
		--clock
		clk : IN STD_LOGIC;
		
		--outputs
		o_product : OUT STD_LOGIC_VECTOR(17 downto 0);
		
		z : OUT STD_LOGIC;
		b0 : OUT STD_LOGIC);
	
end binaryMultDatapath;

architecture rtl of binaryMultDatapath is 

	component nineBitShiftRightRegister 
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_shift			: IN STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(8 DOWNTO 0);
			output			: OUT STD_lOGIC_VECTOR(8 DOWNTO 0));
	end component;
	
	component eighteenBitLeftShiftRegister
		port (
			resetBar : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			IN1 : IN STD_LOGIC_VECTOR(8 downto 0);
			shft_A, loadReg: IN STD_LOGIC; 
			o_reg : OUT STD_LOGIC_VECTOR(17 downto 0));
	end component; 
	
	component eighteenBitAdder
		PORT(
			i_Cin : 	IN STD_LOGIC; -- signal from control path. 
			i_A, i_B		: IN	STD_LOGIC_VECTOR(17 downto 0);
			
			o_carryOut		: OUT	STD_LOGIC;
			o_Sum			: OUT	STD_LOGIC_VECTOR(17 downto 0));
	
	end component;

	component eighteenBitRegister
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(17 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(17 downto 0));	
	end component; 

	COMPONENT enARdFF_2 IS
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	end COMPONENT;

	signal s_regA, s_sum, s_product : STD_LOGIC_VECTOR(17 downto 0);
	signal s_regB : STD_LOGIC_VECTOR(8 downto 0);
	signal s_regP : STD_LOGIC_VECTOR(17 downto 0);
	signal add_cout : STD_LOGIC;
	signal o_Z, o_B0, not_z, not_b0 : STD_LOGIC;
	signal i_Z : STD_LOGIC;
	
	begin 
	
	--change behavioural into structural if possible. 
	with Psel select 
		s_regP <= s_sum when '1', "000000000000000000" when others;
	
	i_Z <= (s_regB(8) or s_regB(7) or s_regB(6) or s_regB(5) or s_regB(4) or s_regB(3) or s_regB(2) or s_regB(1) or s_regB(0));
	
	regA: eighteenBitLeftShiftRegister 
		port map (
			resetBar => resetBar, 
			clk => clk, 
			IN1 => i_A, 
			shft_A => shft_A, 
			loadReg => loadReg,
			o_reg => s_regA);
		
	regB: nineBitShiftRightRegister
		PORT MAP(
			i_resetBar => resetBar, 
			i_load => loadReg,	
			i_clock => clk,			
			i_shift => shft_B,			
			i_Value => i_B,			
			output => s_regB);
			
	add18: eighteenBitAdder
		PORT MAP(
			i_Cin => '0',	
			i_A => s_regA, 
			i_B => s_product,
			o_carryOut => add_cout, 
			o_Sum => s_sum);
	
	reg18: eighteenBitRegister
		PORT MAP(
			i_resetBar => resetBar, 
			i_load => en_P,
			i_clock => clk,			
			i_Value => s_regP,			
			o_Value =>	s_product);	
		
	regZ: enARdFF_2
		PORT MAP(
			i_resetBar => resetBar,
			i_d => i_Z,
			i_enable => '1',
			i_clock => clk,
			o_q => o_Z,
			o_qBar => not_z);			

	--output drivers		
	
	z <= o_Z; 
	b0 <= s_regB(0);	
	o_product <= s_product;

end rtl;
	
	