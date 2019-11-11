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
    signal counter : STD_LOGIC_VECTOR (8 downto 0):="000000001";
	
begin


--LFSR Sources:
--https://surf-vhdl.com/how-to-implement-an-lfsr-in-vhdl/
--http://www.ece.ualberta.ca/~elliott/ee552/studentAppNotes/1999f/Drivers_Ed/lfsr.html
count_LFSR : process (clk, reset) begin 

  if rising_edge(clk) then 
    if(reset='1') then
      counter   <= "000000001"; --(others=>'1');
    else
      counter(8) <= counter(0);
      counter(7) <= counter(3) xor counter(8); -- optimum tap is 3 and 8
	  counter(6) <= counter(7);
      counter(5) <= counter(6);
      counter(4) <= counter(5);
      counter(3) <= counter(4);
      counter(2) <= counter(3);
	  counter(1) <= counter(2);
      counter(0) <= counter(1);
    end if; 
  end if; 
end process count_LFSR; 


  
    compare : process(counter, input_value)
    begin    
        if (counter < input_value) then
            output_voltage <= '1';
        else 
            output_voltage <= '0';
        end if;
    end process compare;


end Behavioral;
