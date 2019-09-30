--Generic Averager

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_averager is

generic(samples_to_avg : integer := 16);
	port (
		  clk   : in  std_logic;
		  EN    : in  std_logic;
		  reset : in  std_logic;
		  Din   : in  std_logic_vector(11 downto 0);
		  Q     : out std_logic_vector(11 downto 0));
		  
	end generic_averager;

architecture rtl of generic_averager is

-- create a type for an array of registers.
type reg_array is array (samples_to_avg downto 1) of std_logic_vector(11 downto 0 );

-- declare array of registers 
signal regs : reg_array;
--declare temp16 (value after the last 16 inputs have been added together)
signal tmp16 : std_logic_vector(15 downto 0);

begin

shift_reg : process(clk, reset)
variable temp_values: integer := 0;
	begin
		if(reset = '1') then
			
			
			-- reset all registers to 0
			reset_loop : for i in 1 to samples_to_avg loop
				regs(i) 	<= (others => '0');
			end loop reset_loop;
			
			
			Q <= (others => '0');
			
			
			
			
		elsif rising_edge(clk) then
			if EN = '1' then
			
			regs(1)				<= 	Din;
			--shift register output by 1 to next input
			regs(samples_to_avg downto 2) 	<= 	regs(samples_to_avg-1 downto 1);
					
			-- start loop to add all registers together
			temp_values := 0;
			sum_loop : for i in 1 to samples_to_avg loop
		
			temp_values := temp_values + to_integer(unsigned(regs(i)));
		
		end loop sum_loop;
		
		-- output pin <= answer
 		tmp16 <= std_logic_vector(to_unsigned(temp_values, tmp16'length));
		Q <= tmp16(15 downto 4);

			end if;
		end if;
	end process shift_reg;



end rtl;
