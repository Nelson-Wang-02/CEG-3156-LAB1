LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eighteenBitRegister IS
	PORT(
		i_resetBar, i_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(17 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(17 downto 0));
END eighteenBitRegister;

ARCHITECTURE rtl OF eighteenBitRegister IS
	SIGNAL int_Value0, int_Value1, o_Value0, o_Value1 : STD_LOGIC_VECTOR(8 downto 0);
	
	COMPONENT nineBitRegister 
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(8 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(8 downto 0));
	END COMPONENT;

BEGIN

	int_Value1 <= i_Value(17 downto 9); 
	int_Value0 <= i_Value(8 downto 0); 
	
	reg1: nineBitRegister
		PORT MAP(
			i_resetBar => i_resetBar, 
			i_load => i_load,	
			i_clock => i_clock,			
			i_Value => int_Value1,			
			o_Value =>o_Value1);	
	

	reg0: nineBitRegister
		PORT MAP(
			i_resetBar => i_resetBar, 
			i_load => i_load,	
			i_clock => i_clock,			
			i_Value => int_Value0,			
			o_Value =>	o_Value0);	

	-- Output Driver
	o_Value(17 downto 9) <= o_Value1;
	o_Value(8 downto 0) <= o_Value0;

END rtl;
