library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity amplitude_frequency_step_control is
    Port ( 	
			clk                           	: in std_logic;
			reset							: in std_logic;
			freq_up							: in std_logic;
			freq_dn							: in std_logic;
			amp_up							: in std_logic;
			amp_dn							: in std_logic;
			frequency_step					: inout std_logic_vector(3 downto 0);
			amplitude_step					: inout std_logic_vector(3 downto 0)
         );
           
end amplitude_frequency_step_control;

architecture Behavioural of amplitude_frequency_step_control is 

begin

	frequency_amplitude_check: process(clk) begin
		
		if (rising_edge(clk)) then
			--check frequency and amplitude buttons to increase/decrease them
			
			if (reset = '1') then
				frequency_step <= (others => '0');
				amplitude_step <= (others => '0');
			else
				if (freq_up = '1') then
					frequency_step <= std_logic_vector(resize(unsigned(frequency_step) + 1, frequency_step'length));
				end if;
				if (freq_dn = '1') then
					frequency_step <= std_logic_vector(resize(unsigned(frequency_step) - 1, frequency_step'length));
				end	if;	
				
				if (amp_up = '1') then
					amplitude_step <= std_logic_vector(resize(unsigned(amplitude_step) + 1, amplitude_step'length));
				end if;
				if (amp_dn = '1') then
					amplitude_step <= std_logic_vector(resize(unsigned(amplitude_step) - 1, amplitude_step'length));
				end if;	
			end if;
		end if;
		
	
	
	end process;
	
	
	
	
	

end Behavioural;

