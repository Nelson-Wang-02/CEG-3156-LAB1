Library ieee;
Use ieee.std_logic.ALL;

ENTITY eightBitAdder IS
	PORT( i_x,i_y :IN STD_LOGIC_VECTOR(7 downto 0);
			i_cin 	: IN STD_LOGIC;
			o_sum		: OUT STD_LOGIC_VECTOR(6 downto 0);
			o_sign	: OUT STD_LOGIC);
	END eightBitAdder;
	
ARCHITECTURE structure OF eightBitAdder IS

COMPONENT oneBitAdder
	PORT(	i_x,i_y 	: IN STD_LOGIC;
			i_cin 	: IN STD_LOGIC;
			o_sum		: OUT STD_LOGIC;
			o_sign	: OUT STD_LOGIC);
	END COMPONENT;
	
	SIGNAL int_c: STD_LOGIC_VECTOR(7 downto 0);
	BEGIN
	
	adder_0: oneBitAdder
		PORT MAP( i_x => i_x(0),
					i_y => i_y(0),
					i_cin => i_cin,
					o_sum => o_sum(0),
					o_cout => int_c(0));
					
	adder_1: oneBitAdder
		PORT MAP( i_x => i_x(1),
					i_y => i_y(1),
					i_cin => int_c(0),
					o_sum => o_sum(1),
					o_cout => int_c(1));
					
	adder_2: oneBitAdder
		PORT MAP( i_x => i_x(2),
					i_y => i_y(2),
					i_cin => int_c(1),
					o_sum => o_sum(2),
					o_cout => int_c(2));
	
	adder_3: oneBitAdder
		PORT MAP( i_x => i_x(3),
					i_y => i_y(3),
					i_cin => int_c(2),
					o_sum => o_sum(3),
					o_cout => int_c(3));
					
	adder_4 oneBitAdder
		PORT MAP( i_x => i_x(4),
					i_y => i_y(4),
					i_cin => int_c(3),
					o_sum => o_sum(4),
					o_cout => int_c(4));				
					
					
	adder_5 oneBitAdder
		PORT MAP( i_x => i_x(5),
					i_y => i_y(5),
					i_cin => int_c(4),
					o_sum => o_sum(5),
					o_cout => int_c(5));				
					
	adder_6: oneBitAdder
		PORT MAP( i_x => i_x(6),
					i_y => i_y(6),
					i_cin => int_c(5),
					o_sum => o_sum(6),
					o_cout => int_c(6));		
					
	adder_7: oneBitAdder
		PORT MAP( i_x => i_x(7),
					i_y => i_y(7),
					i_cin => int_c(6),
					o_sum => o_sum(7),
					o_cout => int_c(7));				
END structure;
					
					
					
					
					
	