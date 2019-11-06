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
	
component amplitude_frequency_step_control is
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
end component;

signal fetch_next_value	: std_logic;
signal next_value_i		: std_logic_vector(8 downto 0);
signal frequency_step 	: std_logic_vector(3 downto 0);
signal amplitude_step	: std_logic_vector(3 downto 0);

type amplitude_factors is array (0 to 15) of integer;

constant amp_steps: amplitude_factors:= ((32),(64),(96),(128),(160),(192),(224),(256),(288),(320),(352),(384),(416),(448),(480),(511));

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

amplitude_frequency_control_ins: amplitude_frequency_step_control
	port map(
		clk					=> clk,
		reset				=> reset,
		freq_up				=> freq_up,
		freq_dn				=> freq_dn,
		amp_up				=> amp_up,
		amp_dn				=> amp_dn,
		frequency_step		=> frequency_step,
		amplitude_step		=> amplitude_step
	);




	get_LUT_value: process(clk,reset) begin
		if(rising_edge(clk)) then
			-- look to see if next value must be fetched from LUT
			if(fetch_next_value = '1') then
				next_value_i <= std_logic_vector(resize(unsigned(next_value_i) + 1, next_value_i'length));
				-- add 1 to next_value_i if downcounter is finished
			end if;
			

		end if;
	end process;
	
	
	scale_amplitude_and_write_to_DAC: process(wave_select, scaled_amplitude) begin
		if((wave_select="00")) then
			--scale amplitude if square wave is selected, then write to DAC
			wave_value_out <= std_logic_vector(to_unsigned(scaled_amplitude,wave_value_out'length));
		else
			wave_value_out <= std_logic_vector(resize(unsigned(wave_value_in),wave_value_out'length));
		
		end if;
	end process;
	
	
	-- end process;
	-- scale the amplitude according to the output from amplitude_frequency_control
	scaled_amplitude <= to_integer(unsigned(wave_value_in)*amp_steps(to_integer(unsigned(amplitude_step))));

	
	
	next_value <= next_value_i;
	
	


end Behaviour;

