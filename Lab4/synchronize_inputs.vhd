library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Synchronize_inputs is
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
           
end Synchronize_inputs;


architecture Behaviour of Synchronize_inputs is 


component sync_registers is 
	generic(bits : integer := 1;
			num_of_registers: integer := 2);
	Port (
			clk       : in  std_logic;
			reset     : in  std_logic;
			enable    : in  std_logic;
			d_input  : in  std_logic_vector(bits-1 downto 0);
			q_output : out std_logic_vector(bits-1 downto 0)	
	);

end component;


signal freq_up_sync	: std_logic;
signal freq_dn_sync	: std_logic;
signal amp_up_sync	: std_logic;
signal amp_dn_sync	: std_logic;


component switch_change is 
    Port ( 	
			clk                           	: in std_logic;
			reset                         	: in std_logic;
			freq_up							: in std_logic;
			freq_dn							: in std_logic;
			amp_up							: in std_logic;
			amp_dn							: in std_logic;
			freq_up_pulse					: out std_logic;
			freq_dn_pulse					: out std_logic;
			amp_up_pulse					: out std_logic;
			amp_dn_pulse					: out std_logic
         );
end component;

begin


sync_reset: sync_registers
	generic map(bits => 1,
				num_of_registers=>2)
	port map (
		 clk      	=> clk,
		 reset    	=> reset,
		 enable   	=> '1',
		 d_input(0)	=> reset,
		 q_output(0) 	=> reset_sync
);

sync_amp_freq_select: sync_registers
	generic map(bits => 1,
				num_of_registers=>2)
	port map (
		 clk   	   		=> clk,
		 reset  		=> reset_sync,
		 enable   		=> '1',
		 d_input(0)		=> amp_freq_select,
		 q_output(0)	=> amp_freq_select_sync
);

sync_freq_up: sync_registers
	generic map(bits => 1,
				num_of_registers=>2)
	port map (
		 clk   	   		=> clk,
		 reset  		=> reset_sync,
		 enable   		=> '1',
		 d_input(0)		=> freq_up,
		 q_output(0)	=> freq_up_sync
);

sync_freq_dn: sync_registers
	generic map(bits => 1,
				num_of_registers=>2)
	port map (
		 clk   	   		=> clk,
		 reset  		=> reset_sync,
		 enable   		=> '1',
		 d_input(0)		=> freq_dn,
		 q_output(0)	=> freq_dn_sync
);


sync_amp_up: sync_registers
	generic map(bits => 1,
				num_of_registers=>2)
	port map (
		 clk   	   		=> clk,
		 reset  		=> reset_sync,
		 enable   		=> '1',
		 d_input(0)		=> amp_up,
		 q_output(0)	=> amp_up_sync
);

sync_amp_dn: sync_registers
	generic map(bits => 1,
				num_of_registers=>2)
	port map (
		 clk   	   		=> clk,
		 reset  		=> reset_sync,
		 enable   		=> '1',
		 d_input(0)		=> amp_dn,
		 q_output(0)	=> amp_dn_sync
);


sync_wave_select: sync_registers
	generic map(bits => 2,
				num_of_registers=>2)
	port map (
		 clk      	=> clk,
		 reset    	=> reset_sync,
		 enable   	=> '1',
		 d_input  	=> wave_select,
		 q_output 	=> wave_select_sync
);


switch_change_detector: switch_change
	port map(
	
			clk             => clk,
			reset           => reset_sync,
			freq_up			=> freq_up_sync,
			freq_dn			=> freq_dn_sync,
			amp_up			=> amp_up_sync,
			amp_dn			=> amp_dn_sync,
			freq_up_pulse	=> freq_up_sync_pulse,
			freq_dn_pulse	=> freq_dn_sync_pulse,
			amp_up_pulse	=> amp_up_sync_pulse,
			amp_dn_pulse	=> amp_dn_sync_pulse
	);




end Behaviour;