library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Amp_Modulation is 

Port (
		reset				: in std_logic;
		sine_value_in 		: in std_logic_vector(4 downto 0);
		voltage_in 	: in std_logic_vector(11 downto 0);
		AM_FM_Select		: in std_logic;
		R2R_OUT				: out std_logic_vector(4 downto 0)

);

end Amp_Modulation;

architecture Behaviour of Amp_Modulation is 



begin

	process(reset, sine_value_in, voltage_in, AM_FM_Select) begin
			if (reset = '1') then 
				R2R_OUT <= (others => '0');
			else 
				if (AM_FM_Select = '1') then
					R2R_OUT <= sine_value_in;
				else 
					R2R_OUT <= std_logic_vector(to_signed(((to_integer(signed(sine_value_in)) * to_integer(unsigned(voltage_in))*883)/512)/4096, R2R_OUT'length));
				end if;
			end if;
			
	end process;
	





end Behaviour;
