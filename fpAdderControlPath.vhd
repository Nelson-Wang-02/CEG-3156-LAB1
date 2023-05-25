Library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpAdderControlPath IS
	PORT(
			i_reset, i_clock																: IN STD_LOGIC;
			i_sign, i_notless9, i_zero, i_coutFz									: IN STD_LOGIC;
			o_load1, o_load2, o_load3, o_load4, o_load5, o_load6, o_load7 	: OUT STD_LOGIC;
			o_shiftR3, o_shiftR4, o_shiftR5											: OUT STD_LOGIC;
			o_on21, o_on22																	: OUT STD_LOGIC;
			o_clear3, o_clear4, o_flag_0, o_flag_1, o_cin						: OUT STD_LOGIC;
			o_countU7, o_countD6, o_done												: OUT STD_LOGIC;
			o_states																			: OUT STD_LOGIC_VECTOR(0 to 9));
			
END fpAdderControlPath;

ARCHITECTURE rtl of fpAdderControlPath IS

COMPONENT enASDFF
		PORT(
				i_resetBar, i_d, i_enable, i_clk 		: IN STD_LOGIC;
				o_q, o_qbar									: OUT STD_LOGIC);
				
END COMPONENT;

SIGNAL state, d : STD_LOGIC_VECTOR(0 to 9);

BEGIN
	d(0) <= '0';
	d(1) <= state(0);
	d(2) <= state(1) AND i_sign;
	d(3) <= state(2) AND i_notless9;
	d(4) <= (i_notless9 AND i_zero) OR (i_zero AND state(4));
	d(5) <= state(1) AND NOT(i_sign) AND i_notless9;
	d(6) <= (state(1) AND NOT(i_sign) AND NOT(i_notless9) AND NOT(i_zero)) OR (NOT(i_zero) AND state(6)));
	d(7) <= (state(1) AND NOT(i_sign) AND NOT(i_notless9) AND NOT(i_zero)) OR (i_zero AND state(6)) OR (state(2) AND NOT(i_notless9) AND i_zero) OR state(3) OR (i_zero AND state(4)) OR state(5));
	d(8) <= (state(7) AND i_coutFz);
	d(9) <= state(8) OR state(9) OR (state(7) AND NOT(i_coutFz));
	
	s0: enASDFF
		PORT MAP(
						i_resetBar => i_reset,
						i_d => d(0),
						i_enable => 1,
						i_clk => i_clock,
						o_q => state(0)
						);
						
	s1: enASDFF
		PORT MAP(
						i_resetBar => i_reset,
						i_d => d(1),
						i_enable => 1,
						i_clk => i_clock,
						o_q => state(1)
						);
						
	s2: enASDFF
		PORT MAP(
						i_resetBar => i_reset,
						i_d => d(2),
						i_enable => 1,
						i_clk => i_clock,
						o_q => state(2)
						);
						
	s3: enASDFF
		PORT MAP(
						i_resetBar => i_reset,
						i_d => d(3),
						i_enable => 1,
						i_clk => i_clock,
						o_q => state(3)
						);
						
	s4: enASDFF
		PORT MAP(
						i_resetBar => i_reset,
						i_d => d(4),
						i_enable => 1,
						i_clk => i_clock,
						o_q => state(4)
						);
						
	s5: enASDFF
		PORT MAP(
						i_resetBar => i_reset,
						i_d => d(5),
						i_enable => 1,
						i_clk => i_clock,
						o_q => state(5)
						);
						
	s6: enASDFF
		PORT MAP(
						i_resetBar => i_reset,
						i_d => d(6),
						i_enable => 1,
						i_clk => i_clock,
						o_q => state(6)
						);
						
	s7: enASDFF_1
		PORT MAP(
						i_resetBar => i_reset,
						i_d => d(7),
						i_enable => 1,
						i_clk => i_clock,
						o_q => state(7)
						);
						
	s8: enASDFF
		PORT MAP(
						i_resetBar => i_reset,
						i_d => d(8),
						i_enable => 1,
						i_clk => i_clock,
						o_q => state(8)
						);
						
	s9: enASDFF
		PORT MAP(
						i_resetBar => i_reset,
						i_d => d(9),
						i_enable => 1,
						i_clk => i_clock,
						o_q => state(9)
						);
	
		o_states <= state;
		
		o_load1 <= state(0);
		o_load2 <= state(0);
		o_load3 <= state(0);
		o_load4 <= state(0);
		
		o_on22 <= state(1);
		o_flag_0 <= state(1);
		
		o_on21 <= state(2);
		o_flag_1 <= state(2);
		
		o_clear3 <= state(3);
		
		o_shiftR3 <= state(4);
		
		o_clear4 <= state(5);
		
		o_shiftR4 <= state(6);
		
		o_load5 <= state(7);
		o_load7 <= state(7);
		
		o_shiftR5 <= state(8);
		o_countU7 <= state(8);
		
		o_done <= state(9);
		
		o_cin <= state(1) OR state(2);
		o_load6 <= state(1) OR state(2);
		
		o_countD6 <= state(4) OR state(6);
		
END rtl;
						
						
		
						