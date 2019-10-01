--Generic Averager Testbench
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_generic_averager is 
end tb_generic_averager;

architecture tb_behaviour of tb_generic_averager is

component generic_averager is 
generic(samples_to_avg : integer);
	port(
			clk   : in  std_logic;
			EN    : in  std_logic;
			reset : in  std_logic;
			Din   : in  std_logic_vector(11 downto 0);
			Q     : out std_logic_vector(11 downto 0)
		
		);
end component;

Signal	 clk   : std_logic;
Signal	 EN    : std_logic;
Signal	 reset : std_logic;
Signal	 Din   : std_logic_vector(11 downto 0);
Signal	 Q     : std_logic_vector(11 downto 0);

constant clk_period : time := 10 ns;
begin 
UUT: generic_averager 
generic map (samples_to_avg => 32)
port map
			(
				clk 	=> clk,
				EN 		=> EN,
				reset 	=> reset,
				Din 	=> Din,
				Q 		=> Q
			);
			
	clk_process: process
	begin 
			EN <= '1';
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
			
	end process;
	
	reset_process: process
	begin 
			reset <= '1';
			wait for clk_period*2; --hold reset for 2 clock cycles.
			reset<='0';
			wait;
	end process;
	
	Data_in_process: process(clk)
	variable data_in	: integer := 0;
	begin
			--cycle through data inputs of 0 to 15
			--true average is 7.5
			
			if (data_in = 16) then 
			data_in := 0;
			end if;
			Din <= std_logic_vector(to_unsigned(data_in, Din'length));
			data_in := data_in + 1;			
	end process;
	
end tb_behaviour;