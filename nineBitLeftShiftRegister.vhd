--------------------------------------------------------------------------------
-- Title         : 3-bit Shift Register
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : threeBitShiftRegister.vhd
-- Author        : Rami Abielmona  <rabielmo@site.uottawa.ca>
-- Created       : 2003/05/17
-- Last modified : 2007/09/25
-------------------------------------------------------------------------------
-- Description : This file creates a 3-bit shift register as defined in the VHDL 
--		 Synthesis lecture. The architecture is done at the RTL 
--		 abstraction level and the implementation is done in structural
--		 VHDL.
-------------------------------------------------------------------------------
-- Modification history :
-- 2003.05.17 	R. Abielmona		Creation
-- 2004.09.22 	R. Abielmona		Ported for CEG 3550
-- 2007.09.25 	R. Abielmona		Modified copyright notice
-------------------------------------------------------------------------------
-- This file is copyright material of Rami Abielmona, Ph.D., P.Eng., Chief Research
-- Scientist at Larus Technologies.  Permission to make digital or hard copies of part
-- or all of this work for personal or classroom use is granted without fee
-- provided that copies are not made or distributed for profit or commercial
-- advantage and that copies bear this notice and the full citation of this work.
-- Prior permission is required to copy, republish, redistribute or post this work.
-- This notice is adapted from the ACM copyright notice.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nineBitShiftLeftRegister IS
	PORT(
		i_resetBar, i_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_shift			: IN STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(8 DOWNTO 0); --IN--
		output			: OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
		
END nineBitShiftLeftRegister;

ARCHITECTURE rtl OF nineBitShiftLeftRegister IS
	SIGNAL int_Value, int_notValue, int_output : STD_LOGIC_VECTOR(8 downto 0); --int_Value for internal shift, output for parallel out
	
	SIGNAL d8, d7, d6, d5, d4, d3 , d2, d1, d0 : STD_LOGIC; --INTERNAL INPUTS--

	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

--concurrent signal assignment--
d8 <= (int_Value(7) and i_shift ) or (not(i_shift) and i_Value(8));
d7 <= (int_Value(6) and i_shift ) or (not(i_shift) and i_Value(7));
d6 <= (int_Value(5) and i_shift ) or (not(i_shift) and i_Value(6));
d5 <= (int_Value(4) and i_shift ) or (not(i_shift) and i_Value(5));
d4 <= (int_Value(3) and i_shift ) or (not(i_shift) and i_Value(4));
d3 <= (int_Value(2) and i_shift ) or (not(i_shift) and i_Value(3));
d2 <= (int_Value(1) and i_shift ) or (not(i_shift) and i_Value(2));
d1 <= (int_Value(0) and i_shift ) or (not(i_shift) and i_Value(1));
d0 <= '0' or (not(i_shift) and i_Value(0));

msb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => d8,
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(8),
	          o_qBar => int_notValue(8));

bsev: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => d7,
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(7),
	          o_qBar => int_notValue(7));

bsix: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => d6,
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(6),
	          o_qBar => int_notValue(6));

bfive: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => d5,
			  i_enable => i_load,
			  i_clock => i_clock,
			  o_q => int_Value(5),
	          o_qBar => int_notValue(5));

bfour: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => d4,
			  i_enable => i_load,
			  i_clock => i_clock,
			  o_q => int_Value(4),
	          o_qBar => int_notValue(4));

bthree: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => d3,
			  i_enable => i_load,
			  i_clock => i_clock,
			  o_q => int_Value(3),
			  o_qBar => int_notValue(3));
			
btwo: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => d2,
			  i_enable => i_load,
			  i_clock => i_clock,
			  o_q => int_Value(2),
	          o_qBar => int_notValue(2));			
			
bone: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => d1,
			  i_enable => i_load,
			  i_clock => i_clock,
			  o_q => int_Value(1),
	          o_qBar => int_notValue(1));	

bzero: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => d0, 
			  i_enable => i_load,
			  i_clock => i_clock,
			  o_q => int_Value(0),
	         o_qBar => int_notValue(0));
	

	-- Output Driver
	output <= int_Value;

END rtl;
