library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Lab5 is
port(
		clk 			: in 	std_logic;
		reset			: in 	std_logic;
		AM_FM_Select	: in 	std_logic;
		R2R_Output		: out 	std_logic_vector(5 downto 0);
		HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 	: out STD_LOGIC_VECTOR (7 downto 0)
);
end Lab5;


architecture Behaviour of Lab5 is 


	component Phase_Accumulator is 

	Port (
		clk					: in std_logic;
		reset				: in std_logic;
		AM_FM_Select		: in std_logic;
		voltage_in 			: in std_logic_vector(11 downto 0);
		index				: out std_logic_vector(15 downto 0)
	);

	end component;
		
	component sine_LUT is 

	Port (
			reset			: in std_logic;
			value_in 		: in std_logic_vector(15 downto 0);
			sine_value		: out std_logic_vector(5 downto 0)

	);

	end component;
	
	component Amp_Modulation is 

	Port (
			reset				: in std_logic;
			sine_value_in 		: in std_logic_vector(5 downto 0);
			voltage_in		 	: in std_logic_vector(11 downto 0);
			AM_FM_Select		: in std_logic;
			R2R_OUT				: out std_logic_vector(5 downto 0)

	);

	end component;

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
				clk                        	: in std_logic;
				reset                      	: in std_logic;
				AM_FM_Select				: in std_logic;	
			
				reset_sync                 	: inout std_logic;
				AM_FM_Select_sync			: out std_logic

			 );
			   
	end component;

	signal voltage_value_output				: std_logic_vector(11 downto 0);
	signal reset_sync, AM_FM_Select_sync	: std_logic;
	signal Sine_Index						: std_logic_vector(15 downto 0);
	signal R2R_Output_i, sine_value			: std_logic_vector(5 downto 0);
	
	
begin


	R2R_Output <= R2R_Output_i;
	
	Amp_Modulation_ins: Amp_Modulation
						port map(
								reset				=> reset_sync,
								sine_value_in 		=> sine_value,
								voltage_in	 		=> voltage_value_output,
								AM_FM_Select		=> AM_FM_Select_sync,
								R2R_OUT				=> R2R_Output_i
						);
						
	phase_accumulator_ins: Phase_Accumulator
							port map(
							
								clk					=> clk,
								reset				=> reset_sync,
								AM_FM_Select		=> AM_FM_Select_sync,
								voltage_in 			=> voltage_value_output,
								index				=> Sine_Index
							);



	sine_LUT_ins: sine_LUT
				Port map(
						reset		=> reset_sync,	
						value_in 	=> Sine_Index,
						sine_value	=> sine_value
				);




	distance_measurer: 	voltmeter
						port map(
								clk				=>	clk,
								reset           =>	reset_sync,             
								value_output    =>	voltage_value_output,             
								HEX0			=>	HEX0,
								HEX1			=>	HEX1,
								HEX2			=>	HEX2,
								HEX3			=>	HEX3,
								HEX4			=>	HEX4,
								HEX5			=>	HEX5,
								selectSig 		=> '0'
							
						);
	sync_inputs:	Synchronize_inputs
					port map(
							clk 				=> 	clk,
							reset				=>	reset,
							AM_FM_Select		=> 	AM_FM_Select,
							reset_sync			=>	reset_sync,
							AM_FM_Select_sync	=>	AM_FM_Select_sync
					);

end Behaviour;


