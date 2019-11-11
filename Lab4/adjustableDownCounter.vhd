library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity adjustableDownCounter is
	PORT (  period : in  STD_LOGIC_VECTOR(12 downto 0); -- number to count (will be a value from the distance measurer)
			  clk    : in  STD_LOGIC; -- clock to be divided
           reset  : in  STD_LOGIC; -- active-high reset
           enable : in  STD_LOGIC; -- active-high enable
           zero   : out STD_LOGIC -- creates a positive pulse every time current_count hits zero
                                   -- useful to enable another device, like to slow down a counter
         );
end adjustableDownCounter;

architecture Behavioral of adjustableDownCounter is
signal current_count : STD_LOGIC_VECTOR(12 downto 0);
  
BEGIN
   
   count: process(clk) begin
     if (rising_edge(clk)) then 
       if (reset = '1') then 
          current_count <= (others => '0');
          zero          <= '0';
       elsif (enable = '1') then 
          if (current_count = "0000000000000") then
            current_count <= std_logic_vector(to_unsigned(to_integer(unsigned(period)) - 1, current_count'length));
            zero          <= '1';
          else 
            current_count <= std_logic_vector(to_unsigned(to_integer(unsigned(current_count)) - 1, current_count'length));
            zero          <= '0';
          end if;
       else 
          zero <= '0';
       end if;
     end if;
   end process;
   
END Behavioral;
