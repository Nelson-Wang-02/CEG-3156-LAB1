LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity eighteenBitLeftShiftRegister is 
	
	port (
		resetBar : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		IN1 : IN STD_LOGIC_VECTOR(8 downto 0);
		shft_A, loadReg: IN STD_LOGIC; 
		o_reg : OUT STD_LOGIC_VECTOR(17 downto 0));
	
end eighteenBitLeftShiftRegister;

architecture rtl of eighteenBitLeftShiftRegister is 

	component nineBitShiftLeftRegister_2 
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_shift			: IN STD_LOGIC;
			i_serialVal    : IN STD_LOGIC; --serial value in
			i_Value			: IN	STD_LOGIC_VECTOR(8 DOWNTO 0); 
			output			: OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
	end component; 

	component nineBitShiftLeftRegister 
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_shift			: IN STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(8 DOWNTO 0); 
			output			: OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
	end component; 

	signal shiftInVal : STD_LOGIC;
	signal regOut0, regOut1 : STD_LOGIC_VECTOR(8 downto 0);

	begin
	
	--concurrent signal assignment
	shiftInVal <= regOut0(8);
	
	reg1: nineBitShiftLeftRegister_2 
		port map(
			i_resetBar => resetBar,
			i_load => loadReg,	
			i_clock => clk,			
			i_shift => shft_A,			
			i_serialVal => shiftInVal,    
			i_Value => "000000000",			
			output => regOut1);
	
	
	reg0: nineBitShiftLeftRegister 
		port map(
			i_resetBar => resetBar, 
			i_load => loadReg,	
			i_clock => clk,			
			i_shift => shft_A,			
			i_Value => IN1,			
			output => regOut0);
	
	--output driver
	o_reg(17 downto 9) <= regOut1;
	o_reg(8 downto 0) <= regOut0;

end rtl; 