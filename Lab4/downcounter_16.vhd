library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity downcounter_16 is
	PORT ( 	clk    : in  STD_LOGIC; -- clock to be divided
			reset  : in  STD_LOGIC; -- active-high reset
			enable : in  STD_LOGIC; -- active-high enable
			zero   : out STD_LOGIC; -- creates a positive pulse every time current_count hits zero
                                    -- useful to enable another device, like to slow down a counter
			frequency_select : in std_logic_vector(3 downto 0)
        );
end downcounter_16;


architecture Behaviour of downcounter_16 is 


	component downcounter is
	 Generic ( period : natural); -- number to count       
		PORT ( clk    : in  STD_LOGIC; -- clock to be divided
			   reset  : in  STD_LOGIC; -- active-high reset
			   enable : in  STD_LOGIC; -- active-high enable
			   zero   : out STD_LOGIC; -- creates a positive pulse every time current_count hits zero
									   -- useful to enable another device, like to slow down a counter
			   value  : out STD_LOGIC_VECTOR(integer(ceil(log2(real(period)))) - 1 downto 0) -- outputs the current_count value, if needed
			 );
	end component;


	type array_type is array (0 to 15) of natural;
	
	constant periods : array_type := ((97656),(9766),(3906),(1953),(1302),(977),(488),(326),(244),(195),(163),(140),(122),(109),(98),(65)
	);
	signal zeros_from_downcounters : std_logic_vector(15 downto 0);
	
begin

	downcounters: for i in 0 to 15 generate
	begin
		downcounter_ins: downcounter
		generic map(period => periods(i))
		port map (
				clk 		=> clk,
				reset 		=> reset,
				enable 		=> '1',
				zero		=> zeros_from_downcounters(i),
				value 		=> open
		);
	end generate;
	
	zero <= zeros_from_downcounters(to_integer(unsigned(frequency_select)));
		

end Behaviour;


