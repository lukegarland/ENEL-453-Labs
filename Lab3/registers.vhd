library ieee;
use ieee.std_logic_1164.all;

--The problem with the reset in this file was that if the reset was supposed to be synchronous then the line: "if reset = '1' then" and the line underneath
--should be under the rising CLK edge code. (I made this change so that it is synchronous)

-- If it was suppose to be asynchronous then the reset signals needs to be included in the process list as the process is constantly checking the value of reset 

entity registers is

generic(bits : integer := 1);
 
port( 
	  clk       : in  std_logic;
	  reset     : in  std_logic;
	  enable    : in  std_logic;
     d_inputs  : in  std_logic_vector(bits-1 downto 0);
	  q_outputs : out std_logic_vector(bits-1 downto 0)	
    );
end entity;

architecture rtl of registers is
begin

   process (clk)
   begin
		if (rising_edge(clk)) then
		   if reset = '1' then
				q_outputs <= (others=>'0');
			end if;
		   if (enable = '1') then
            q_outputs <= d_inputs;
			end if;
      end if;
   end process;

end;
