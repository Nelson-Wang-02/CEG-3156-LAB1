LIBRARY ieee;
USE ieee.std_logic_1664.ALL;

ENTITY fpAdder IS
	PORT( ExpA, ExpB 				: IN	STD_LOGIC_VECTOR(6 downto 0);
			MntssaA, MantssaB		: IN STD_LOGIC_VECTOR(7 downto 0);
			clk						: IN STD_LOGIC;
			reset						: IN STD_LOGIC;
			signA, signB			: IN STD_LOGIC;
			ExpOUT 					: OUT STD_LOGIC_VECTOR(6 downto 0);
			MntssaOUT				: OUT STD_LOGIC_VECTOR(7 downto 0);
			signOUT 					: OUT STD_LOGIC;
			Overflow 				: OUT STD_LOGIC);
	END fpAdder;
	
	)