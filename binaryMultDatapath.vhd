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
		en_mult : IN STD_LOGIC;
		loadReg : IN STD_LOGIC;
		clr_P : IN STD_LOGIC;
		en_P : IN STD_LOGIC;
		
		--clock
		clk : IN STD_LOGIC;
		
		--outputs
		o_product : OUT STD_LOGIC_VECTOR(17 downto 0);
		
		z, b0 : OUT STD_LOGIC);
	
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
			i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(8 downto 0);
			
			o_CarryOut		: OUT	STD_LOGIC;
			o_Sum			: OUT	STD_LOGIC_VECTOR(8 downto 0));
	
	end component;

	component eighteenBitRegister
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));	
	end component; 

	signal s_regA, s_sum, s_product : STD_LOGIC_VECTOR(17 downto 0);
	signal s_regB : STD_LOGIC_VECTOR(8 downto 0);
	signal add_cout : STD_LOGIC;
	
	begin 
	
	regA: eighteenBitLeftShiftRegister 
		port map (
			resetBar => resetBar, 
			clk => clk, 
			IN1 => i_A, 
			shft_A => shft_A, 
			loadReg => loadReg,
			o_reg => s_regA, 		
		);
		
	regB: nineBitShiftRightRegister
		PORT MAP(
			i_resetBar => resetBar, 
			i_load => loadReg,	
			i_clock => clk,			
			i_shift => shft_B,			
			i_Value => i_B,			
			output => s_regB);
			
	add18: eighteenBitAdder
		PORT(
			i_Cin => '0',	
			i_Ai => s_regA, 
			i_Bi => s_product,
			
			o_CarryOut => add_cout, 
			o_Sum => s_sum);
	
	reg18: eighteenBitregister
	
end rtl;
	
	