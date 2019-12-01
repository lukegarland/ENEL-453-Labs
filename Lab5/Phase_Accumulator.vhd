library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Phase_Accumulator is 

Port (
	clk					: in std_logic;
	reset				: in std_logic;
	AM_FM_Select		: in std_logic;
	voltage_in 			: in std_logic_vector(11 downto 0);
	index				: out std_logic_vector(15 downto 0)
);

end Phase_Accumulator;

architecture Behaviour of Phase_Accumulator is 


signal increment_by 	: integer;
constant base_increment	: integer := 838;
signal index_i			: std_logic_vector(15 downto 0);


begin

	calc_LUT_index: process(clk,reset, increment_by) begin
		if(rising_edge(clk)) then
			if (reset = '1') then 
				index_i <= (others => '0');
			else 
				if (AM_FM_Select = '1') then
					index_i <= std_logic_vector(to_unsigned(to_integer(unsigned(index_i)) + increment_by + base_increment , index_i'length));
					-- index_i <= index_i + increment_by + base_increment
				else 
					index_i <= std_logic_vector(to_unsigned(to_integer(unsigned(index_i)) + 852 , index_i'length));

				end if;
			end if;
			
		end if;
	end process;
	

		increment_by <= to_integer(45*unsigned(voltage_in)/4096);
	

	index <= index_i;


end Behaviour;
