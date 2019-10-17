-- Voltmeter TestBench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tb_voltmeter is
end tb_voltmeter;

architecture Behavioral of tb_voltmeter is 
	
component voltmeter is 
    Port ( clk                           : in  STD_LOGIC;
           reset                         : in  STD_LOGIC;
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0);
			  voltage_mode						  : in STD_LOGIC;
			  shortEnable						  : in STD_LOGIC
          );
End component;

signal clk 										:	STD_LOGIC;
signal reset						 			:	STD_LOGIC;
signal voltage_mode							:  STD_LOGIC;
signal shortEnable							:  STD_LOGIC;
signal HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 	:	STD_LOGIC_VECTOR (7 downto 0);
signal LEDR                          	:	STD_LOGIC_VECTOR (9 downto 0);

constant clk_period : time := 10 ns;

begin 
voltmeter_ins: Voltmeter port map(
									clk   =>		   clk ,
									reset	=>		   reset,
									LEDR	=>		   LEDR,
									HEX0	=> 		HEX0,
									HEX1	=> 		HEX1,
									HEX2	=> 		HEX2,
									HEX3	=> 		HEX3,
									HEX4	=> 		HEX4,
									HEX5	=> 		HEX5,
									voltage_mode =>   voltage_mode,
									shortEnable => shortEnable
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
	
	short_Enable: process
	begin
			shortEnable <= '0';
			wait for 1000 ns;
			shortEnable <= '1';
			wait for 1000 ns;
	end process;
	
	voltage_Mode_process: process
	begin
			voltage_mode <= '0';
			wait for 2000 ns;
			voltage_mode <= '1';
			wait for 2000 ns;
	end process;
	
end Behavioral;
	