library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Lab4_Wave_Gen is
    Port ( 	
			clk                        : in std_logic;
			reset                      : in std_logic;
			amp_freq_select				: in std_logic;
			freq_up							: in std_logic;
			freq_dn							: in std_logic;
			amp_up							: in std_logic;
			amp_dn							: in std_logic;
			wave_select						: in std_logic_vector(1 downto 0);
			
			HEX0,HEX1,HEX2,HEX3,HEX4,HEX5	: out std_logic_vector(7 downto 0);
			DAC_1_Out						: out std_logic;
			DAC_2_Out						: out std_logic
         );
           
end Lab4_Wave_Gen;


architecture Behaviour of Lab4_Wave_Gen is 

	component voltmeter is 
		Port ( 	
				clk                           	: in  STD_LOGIC;
				reset                         	: in  STD_LOGIC;
				value_output                   	: out STD_LOGIC_VECTOR (11 downto 0);
				HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 	: out STD_LOGIC_VECTOR (7 downto 0);
				selectSig						: in STD_LOGIC

			 );
           
	end component;
	

	component Synchronize_inputs is
		Port ( 	
				clk                           	: in std_logic;
				reset                         	: in std_logic;
				amp_freq_select					: in std_logic;
				freq_up							: in std_logic;
				freq_dn							: in std_logic;
				amp_up							: in std_logic;
				amp_dn							: in std_logic;
				wave_select						: in std_logic_vector(1 downto 0);
			
				reset_sync                     	: inout std_logic;
				amp_freq_select_sync			: out std_logic;
				freq_up_sync_pulse				: out std_logic;
				freq_dn_sync_pulse				: out std_logic;
				amp_up_sync_pulse				: out std_logic;
				amp_dn_sync_pulse				: out std_logic;
				wave_select_sync				: out std_logic_vector(1 downto 0)
			 );
			   
			   
	end component;


	--use these signals for switch and button inputs as 
	--they are syncronized and 
	signal reset_sync				: std_logic;
	signal amp_freq_select_sync 	: std_logic;
	signal freq_up_sync_pulse		: std_logic;
	signal freq_dn_sync_pulse		: std_logic;
	signal amp_up_sync_pulse		: std_logic;
	signal amp_dn_sync_pulse		: std_logic;
	signal wave_select_sync			: std_logic_vector(1 downto 0);


begin 



	distance_measurer: 	voltmeter
						port map(
								clk				=>	clk,
								reset           =>	reset_sync,             
								value_output    =>	open,             
								HEX0			=>	HEX0,
								HEX1			=>	HEX1,
								HEX2			=>	HEX2,
								HEX3			=>	HEX3,
								HEX4			=>	HEX4,
								HEX5			=>	HEX5,
								selectSig 		=> '0'
							
						);


	Syncronize_inputs_ins:	Synchronize_inputs
							port map(
								clk                     => clk,
								reset                   => reset,
								amp_freq_select			=> amp_freq_select,
								freq_up					=> freq_up,
								freq_dn					=> freq_dn,
								amp_up					=> amp_up,
								amp_dn					=> amp_dn,
								wave_select				=> wave_select,
							
								reset_sync		     	=> reset_sync,
								amp_freq_select_sync	=> amp_freq_select_sync,
								freq_up_sync_pulse		=> freq_up_sync_pulse,
								freq_dn_sync_pulse		=> freq_dn_sync_pulse,
								amp_up_sync_pulse		=> amp_up_sync_pulse,
								amp_dn_sync_pulse		=> amp_dn_sync_pulse,
								wave_select_sync		=> wave_select_sync
							);



end Behaviour;