--Top Level Testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tb_Lab4 is
end tb_Lab4;

architecture Behavioral of tb_Lab4 is 
	
component Lab4_Wave_Gen is 
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
End component;

signal clk 										:	STD_LOGIC;
signal reset						 			:	STD_LOGIC;
signal amp_freq_select						:  STD_LOGIC;
signal freq_up, freq_dn					 	:  STD_LOGIC;
signal amp_up, amp_dn					 	:  STD_LOGIC;
signal wave_select							:  STD_LOGIC_VECTOR(1 downto 0);



signal HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 	:	STD_LOGIC_VECTOR (7 downto 0);
signal DAC_1_Out, DAC_2_Out				:  STD_LOGIC;

constant clk_period : time := 10 ns;

begin 
Lab4_Wave_Gen_ins: Lab4_Wave_gen port map(
									clk   =>		   clk ,
									reset	=>		   reset,
									amp_freq_select => amp_freq_select,
									freq_up => freq_up,
									freq_dn => freq_dn,
									amp_up => amp_up,
									amp_dn => amp_dn,
									wave_select => wave_select,
									HEX0	=> 		HEX0,
									HEX1	=> 		HEX1,
									HEX2	=> 		HEX2,
									HEX3	=> 		HEX3,
									HEX4	=> 		HEX4,
									HEX5	=> 		HEX5,
									DAC_1_Out => DAC_1_Out,
									DAC_2_Out => DAC_2_Out
								  );
								  
	clk_process: process
	begin
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
			
	end process;
	
	reset_process: process
	begin
			reset <= '0';
			wait for clk_period;
			reset <= '1';
			wait for clk_period*4; -- resets for 4 CLK cycles
			reset <= '0';
			wait;
			
	end process;
	
	amp_freq_select_process: process
	begin
			amp_freq_select <= '0';
			wait for 1000 ns;
			amp_freq_select <= '1';
			wait for 1000 ns;
	end process;
	
	freq_up_process: process
	begin
			freq_up <= '0';
			wait for 200 ns;
			freq_up <= '1';
			wait for 200 ns;
	end process;
	
	freq_dn_process: process
	begin
			freq_dn <= '0';
			wait for 500 ns;
			freq_dn <= '1';
			wait for 500 ns;
	end process;
	
	amp_up_process: process
	begin
			amp_up <= '0';
			wait for 100 ns;
			amp_up <= '1';
			wait for 100 ns;
	end process;
	
	amp_dn_process: process
	begin
			amp_dn <= '0';
			wait for 400 ns;
			amp_dn <= '1';
			wait for 400 ns;
	end process;
	
	wave_select_process: process
	begin
			wave_select <= "00";
			wait for 4000 ns;
			wave_select <= "01";
			wait for 4000 ns;
			wave_select <= "10";
			wait for 4000 ns;
			wave_select <= "11";
			wait for 4000 ns;
	end process;
	
end Behavioral;
	