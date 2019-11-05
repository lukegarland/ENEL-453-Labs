library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DAC is
    Generic ( width : integer := 9);
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           input_value : in STD_LOGIC_VECTOR (width-1 downto 0);
           output_voltage : out STD_LOGIC
          );
end DAC;

architecture Behavioral of DAC is
    signal counter : STD_LOGIC_VECTOR (9 downto 0);
        
begin
    count : process(clk,reset)
    begin
        if( reset = '1') then
            counter <= (others => '0');
        elsif (rising_edge(clk)) then 
            counter <= counter + '1';
        end if;
    end process;
  
    compare : process(counter, input_value)
    begin    
        if (counter < input_value) then
            output_voltage <= '1';
        else 
            output_voltage <= '0';
        end if;
    end process;
  
end Behavioral;
