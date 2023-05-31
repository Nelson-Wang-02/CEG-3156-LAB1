LIBRARY ieee;
USE ieee.std_logic_1664.ALL;

ENTITY fpAdder IS
	PORT( GClk, GReset			: IN STD_LOGIC;
			ExpA, ExpB 				: IN	STD_LOGIC_VECTOR(6 downto 0);
			MntssaA, MntssaB		: IN STD_LOGIC_VECTOR(7 downto 0);
			clk						: IN STD_LOGIC;
			reset						: IN STD_LOGIC;
			signA, signB			: IN STD_LOGIC;
			ExpOUT 					: OUT STD_LOGIC_VECTOR(6 downto 0);
			MntssaOUT				: OUT STD_LOGIC_VECTOR(7 downto 0);
			signOUT 					: OUT STD_LOGIC;
			Overflow 				: OUT STD_LOGIC);
	END fpAdder;
	
	)
	
	ARCHITECTURE rtl of fpAdder IS
	
	COMPONENT sevenBitRegister 
		PORT(
			i_reset					: IN STD_LOGIC;
			i_clk						: IN STD_LOGIC;
			i_load 					: IN STD_LOGIC;
			i_E						: IN STD_LOGIC_VECTOR(6 downto 0);
			o_E						: OUT STD_LOGIC_VECTOR(6 downto 0);
				);
	END COMPONENT;
	
	COMPONENT SRLatch
		PORT(
			i_s						: IN STD_LOGIC;
			i_r						: IN STD_LOGIC;
			o_q						: IN STD_LOGIC;
			);
	END SRLatch;
	
	COMPONENT eightBitComplementer
		PORT(
			i_x						: IN STD_LOGIC;
			i_E						: IN STD_LOGIC_VECTOR(7 downto 0);
			o_q						: OUT STD_LOGIC_VECTOR(7 downto 0);
		)
	END eightBitComplementer;
	
	COMPONENT eightBitAdder
		PORT(
			i_A						: IN STD_LOGIC_VECTOR(7 downto 0);
			i_B						: IN STD_LOGIC_VECTOR(7 downto 0);
			i_cin						: IN STD_LOGIC;
			o_sign					: OUT STD_LOGIC;
			o_sum						: OUT STD_LOGIC_VECTOR(6 downto 0));
	END eightBitAdder;
	
	COMPONENT sevenBitDownCounter
		PORT(
			i_x						: IN STD_LOGIC_VECTOR(6 downto 0);
			i_load					: IN STD_LOGIC;
			i_count					: IN STD_LOGIC;
			o_zero					: OUT STD_LOGIC;
			o_q						: OUT STD_LOGIC_VECTOR(6 downto 0));
	END sevenBitDownCounter;
	
	COMPONENT sevenBitMux
		PORT(
			i_A						: IN STD_LOGIC_VECTOR(6 downto 0);
			i_B						: IN STD_LOGIC_VECTOR(6 downto 0);
			i_sel						: IN STD_LOGIC;
			o_q						: OUT STD_LOGIC_VECTOR(6 downto 0));
	END sevenBitMux;
	
	COMPONENT sevenBitUpCounter
		PORT(
			i_x						: IN STD_LOGIC_VECTOR(6 downto 0);
			i_load					: IN STD_LOGIC;
			i_countU					: IN STD_LOGIC;
			o_q						: OUT STD_LOGIC_VECTOR(6 downto 0)
			);
	END sevenBitUpCounter;
	
	COMPONENT nineBitShiftRegister
		PORT(
			i_x						: IN STD_LOGIC_VECTOR(7 downto 0);
			i_shift					: IN STD_LOGIC;
			i_load					: IN STD_LOGIC;
			i_clear					: IN STD_LOGIC;
			o_q						: OUT STD_LOGIC_VECTOR(7 downto 0));
	END nineBitShiftRegister;
	
	COMPONENT nineBitAdder
		PORT(
			i_A						: IN STD_LOGIC_VECTOR(8 downto 0);
			i_B 						: IN STD_LOGIC_VECTOR(8 downto 0);
			o_cout					: OUT STD_LOGIC;
			o_q						: OUT STD_LOGIC_VECTOR(8 downto 0));
	END nineBitAdder;
	
	COMPONENT fpAdderControlPath IS
	PORT(
			i_reset, i_clock																: IN STD_LOGIC;
			i_sign, i_notless9, i_zero, i_coutFz									: IN STD_LOGIC;
			o_load1, o_load2, o_load3, o_load4, o_load5, o_load6, o_load7 	: OUT STD_LOGIC;
			o_shiftR3, o_shiftR4, o_shiftR5											: OUT STD_LOGIC;
			o_on21, o_on22																	: OUT STD_LOGIC;
			o_clear3, o_clear4, o_flag_0, o_flag_1, o_cin						: OUT STD_LOGIC;
			o_countU7, o_countD6, o_done												: OUT STD_LOGIC;
			o_states																			: OUT STD_LOGIC_VECTOR(9 downto 0));
			
	END COMPONENT;
	
	--datapath signals
	SIGNAL int_Ex, int_Ey																: STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL int_XcomplIn, int_YcomplIn												: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL int_XcomplOut, int_YcomplOut												: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL int_Ediff																		: STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL int_InComparator																: STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL int_FLAG																		: STD_LOGIC;
	SIGNAL int_Ez																			: STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL int_REz																			: STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL int_Fx, int_Fy																: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL int_ShiftFx, int_ShiftFy													: STD_LOGIC_VECTOR(8 downto 0);
	SIGNAL int_sum																			: STD_LOGIC_VECTOR(8 downto 0);
	SIGNAL int_RFz																			: STD_LOGIC_VECTOR(8 downto 0);
	
	
	--control path signals
	SIGNAL int_load1, int_load2, int_load3, int_load4, int_load5, int_load6, int_load7	: STD_LOGIC;
	SIGNAL int_on21, int_on22																				: STD_LOGIC;
	SIGNAL int_flag0, int_flag1																			: STD_LOGIC;
	SIGNAL int_clear3, int_clear4, int_clear5															: STD_LOGIC;
	SIGNAL int_shiftR3, int_shiftR4, int_shiftR5														: STD_LOGIC;
	SIGNAL int_countD6, int_countU7																		: STD_LOGIC;
	SIGNAL int_sign, int_zero, int_coutFz, int_notLess9, int_done, int_cin					: STD_LOGIC;
	SIGNAL int_states 																						: STD_LOGIC_VECTOR(9 downto 0);

	
	BEGIN
	
	int_XcomplIn <= 0 AND int_Ex;
	int_YcomplIn <= 0 AND int_Ey;
	int_Fx <= 1 AND MntssaA;
	int_Fy <= 1 AND MntssaB;
	
	fbAdderController: fpAdderControlPath
		PORT MAP(
			i_reset => GReset,
			i_clock => GClk,
			i_sign => int_sign,
			i_notless9 => int_notLess9,
			i_zero => int_zero,
			i_coutFz => int_coutFz,
			o_load1 => int_load1,
			o_load2 => int_load2,
			o_load3 => int_load3,
			o_load4 => int_load4,
			o_load5 => int_load5,
			o_load6 => int_load6,
			o_load7 => int_load7,
			o_shiftR3 => int_shiftR3,
			o_shiftR4 => int_shiftR4,
			o_shiftR5 => int_shiftR5,
			o_on21 => int_on21,
			o_on22 => int_on22,
			o_clear3 => int_clear3,
			o_clear4 => int_clear4,
			'0' => int_clear5,
			o_flag_0 => int_flag0,
			o_flag_1 => int_flag1,
			o_cin => int_cin,
			o_countU7 => int_countU7,
			o_countD6 => int_countD6,
			o_done => int_done,
			o_states => int_states);
			
			
	Ex: sevenBitRegister
		PORT MAP(
			i_reset => GReset,
			i_clk	=> GClk,
			i_load => int_load1,
			i_E => ExpA,
			o_E =>int_Ex);
			
	Ey: sevenBitRegister
		PORT MAP(
			i_reset => GReset,
			i_clk	=> GClk,
			i_load => int_load2,
			i_E => ExpB,
			o_E => int_Ey);
	
	
	SRLatch: SRLatch
		PORT MAP(
		i_s => int_flag1,
		i_r => int_flag0,
		o_q => int_FLAG );
		
	XCompl: eightBitComplementer
		PORT MAP(
			i_x => int_XcomplIn,
			i_e => int_on21,
			o_q => int_xComplOut);
	
	YCompl: eightBitComplementer
		PORT MAP(
			i_x => int_YcomplIn,
			i_e => int_on22,
			o_q => int_YComplOut);
			
	Adder: eightBitAdder
		PORT MAP(
			i_A => int_xComplOut,
			i_B => int_YComplOut,
			i_cin => int_cin,
			i_sign => int_sign,
			o_sum => int_Ediff);
	
	CounterD: sevenBitDownCounter
		PORT MAP(
			i_x => int_Ediff,
			i_load => int_load6,	
			i_count => int_countD6,					
			o_zero => int_zero,					
			o_q => int_InComparator	);
	
	MUX: sevenBitMux
		PORT MAP(
			i_A =>int_Ex,
			i_B => int_Ey,
			i_sel => int_FLAG,
			o_q =>int_Ez
			);
	
	CounterU: sevenBitUpCounter
		PORT MAP(
			i_x => int_Ez,
			i_countU => int_countU7,
			i_load => int_load7,
			o_q => int_Rez);
			
	FX; nineBitShiftRegister
		PORT MAP(
			i_x => int_Fx,
			i_shift => int_shiftR3,
			i_load => int_load3,
			i_clear => int_clear3,
			o_q => int_shiftFx);
			
	FY: nineBitShiftRegister
		PORT MAP(
			i_x => int_Fy,
			i_shift => int_shiftR4,
			i_load => int_load4,
			i_clear => int_clear4,
			o_q => int_shiftFy);
			
	Normalizer: nineBitShiftRegister
		PORT MAP(
			i_x => int_sum,
			i_shift => int_shiftR5,
			i_load => int_load5,
			i_clear => int_clear5,
			o_q => int_RFz);
	
	MntssaAdd: nineBitAdder
		PORT MAP(
			i_A => int_shiftFx,
			i_B => int_shiftFy,
			o_cout => int_coutFz,
			o_q => int_sum);
	
	COMPONENT nineBitShiftRegister
		PORT(
			i_x						: IN STD_LOGIC_VECTOR(7 downto 0);
			i_shift					: IN STD_LOGIC;
			i_load					: IN STD_LOGIC;
			i_clear					: IN STD_LOGIC;
			o_q						: OUT STD_LOGIC_VECTOR(7 downto 0));
	END nineBitShiftRegister;
	
	COMPONENT nineBitAdder
		PORT(
			i_A						: IN STD_LOGIC_VECTOR(8 downto 0);
			i_B 						: IN STD_LOGIC_VECTOR(8 downto 0);
			o_coutFz					: OUT STD_LOGIC;
			o_q						: OUT STD_LOGIC_VECTOR(8 downto 0));
	END nineBitAdder;
	
	SignOUT <= SignA WHEN (ExpA>ExpB) ELSE
					SignB WHEN (ExpA < ExpB) ELSE
					SignA WHEN (MntssaA > MntssaB) ELSE
					SignB WHEN (MntssaA < MntssaB) ELSE
					SignA;
					
	END rtl;

	