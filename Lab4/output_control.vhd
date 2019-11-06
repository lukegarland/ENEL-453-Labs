library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity Output_control is
    Port ( 	
			clk                           	: in std_logic;
			reset                         	: in std_logic;
			freq_up							: in std_logic;
			freq_dn							: in std_logic;
			amp_up							: in std_logic;
			amp_dn							: in std_logic;
			
			wave_value_in					: in std_logic_vector(8 downto 0);
			wave_select						: in std_logic_vector(1 downto 0);
			
			next_value						: out std_logic_vector(8 downto 0);
			wave_value_out					: out std_logic_vector(8 downto 0)
         );
           
end Output_control;



architecture Behaviour of Output_control is 


component downcounter_16 is
	PORT ( 	clk    : in  STD_LOGIC; -- clock to be divided
			reset  : in  STD_LOGIC; -- active-high reset
			enable : in  STD_LOGIC; -- active-high enable
			zero   : out STD_LOGIC; -- creates a positive pulse every time current_count hits zero
                                    -- useful to enable another device, like to slow down a counter
			frequency_select : in std_logic_vector(3 downto 0)
        );
end component;
	
	

signal fetch_next_value	: std_logic;
signal next_value_i		: std_logic_vector(8 downto 0);
signal frequency_step 	: std_logic_vector(3 downto 0);
signal amplitude_step	: std_logic_vector(3 downto 0);

type amplitude_factors is array (0 to 15) of integer;

constant amp_steps: amplitude_factors:= ((32),(64),(96),(128),(160),(192),(224),(256),(288),(320),(352),(384),(416),(448),(480),(511)
);
signal scaled_amplitude : integer;

begin

downcounter_ins: downcounter_16
	port map(
		clk 				=> clk,
		reset				=> reset,
		enable 				=> '1',
		zero				=> fetch_next_value,
		frequency_select 	=> frequency_step
	);

	scaled_amplitude <= to_integer(unsigned(wave_value_in)*amp_steps(to_integer(unsigned(amplitude_step))));

	get_LUT_value: process(clk,reset) begin
		if(rising_edge(clk)) then
			-- look to see if next value must be fetched from LUT
			if(fetch_next_value = '1') then
				next_value_i <= std_logic_vector(to_unsigned(to_integer(unsigned(next_value_i)) + 1, next_value_i'length));
				-- add 1 to next_value_i
			end if;
			
			-- write last waveform value to output (to DAC)
			if((wave_select="00")) then
				--amplitude scaling
				wave_value_out <= std_logic_vector(to_unsigned(scaled_amplitude,wave_value_out'length));
			else
				wave_value_out <= std_logic_vector(to_unsigned(to_integer(unsigned(wave_value_in)),wave_value_out'length));
			
			end if;
		end if;
	end process;
	
	frequency_amplitude_check: process(clk) begin
		
		if (rising_edge(clk)) then
			--check frequency and amplitude buttons
			if (freq_up = '1') then
				frequency_step <= std_logic_vector(to_unsigned(to_integer(unsigned(frequency_step)) + 1, frequency_step'length));
			end if;
			if (freq_dn = '1') then
				frequency_step <= std_logic_vector(to_unsigned(to_integer(unsigned(frequency_step)) - 1, frequency_step'length));
			end	if;	
			
			if (amp_up = '1') then
				amplitude_step <= std_logic_vector(to_unsigned(to_integer(unsigned(amplitude_step)) + 1, amplitude_step'length));
			end if;
			if (amp_dn = '1') then
				amplitude_step <= std_logic_vector(to_unsigned(to_integer(unsigned(amplitude_step)) - 1, amplitude_step'length));
			end if;	
			
		end if;
		
	
	
	end process;
	
	
	
	
	next_value <= next_value_i;
	
	


end Behaviour;

