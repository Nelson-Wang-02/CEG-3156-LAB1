LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity nineBitMultiplier is 

	port (
		clock : IN STD_LOGIC;
		resetBar : IN STD_LOGIC;
		IN1, IN2 : IN STD_LOGIC_VECTOR(8 downto 0);
		en_mult : IN STD_LOGIC;
		o_product : OUT STD_LOGIC_VECTOR(17 downto 0));

end nineBitMultiplier;

architecture rtl of nineBitMultiplier is 

	component binaryMultControlPath  

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
		
	end component; 

	component binaryMultDatapath
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
	
	end component;
	
	signal o_z, o_b0 : STD_LOGIC;
	signal o_shftA, o_shftB, o_Psel, o_enP, o_loadReg : STD_LOGIC;
	
	signal prod : STD_LOGIC_VECTOR(17 downto 0);
	
	begin 
	
	controlPath: binaryMultControlPath
		port map (
			--inputs
			i_resetBar => resetBar,
			b0 => o_b0,
			en_mult => en_mult,
			z => o_z,
			clk => clock,
			
			--outputs
			loadReg => o_loadReg,
			en_P => o_enP, 
			Psel => o_Psel,
			shft_A => o_shftA, 
			shft_B => o_shftB);
	
	dataPath: binaryMultDatapath
		port map (
		
			i_A => IN1,
			i_B => IN2,
			
			--control signal inputs
			resetBar => resetBar,
			shft_A => o_shftA, 
			shft_B => o_shftB,
			loadReg => o_loadReg,
			Psel => o_Psel, 
			en_P => o_enP, 
			
			--clock
			clk => clock,
			
			--outputs
			o_product => prod, 
			z => o_z,
			b0 => o_b0);
	
	--output driver
	o_product <= prod;
	
end rtl; 


