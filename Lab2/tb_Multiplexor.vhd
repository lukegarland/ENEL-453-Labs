-- Multiplexor testbench file
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tb_Multiplexor is
end tb_Multiplexor;

architecture Behavioral of tb_Multiplexor is 


component Multiplexor is 
	port(
			selectLine : in std_logic;
			input1 : in std_logic_vector(11 downto 0);
			input2 : in std_logic_vector(11 downto 0);
			muxOutput : out std_logic_vector(11 downto 0)
		 );
End component;
signal input1: std_logic_Vector(11 downto 0);
signal input2: std_logic_vector(11 downto 0);
signal selectLine : std_logic;
signal muxOutput : std_logic_vector(11 downto 0);

begin 

-- Test values
input1 <= "000100001011";
input2 <= "101010101010";

-- UUT : unit under test
multiplexor_ins: Multiplexor port map(
											selectLine => selectLine,
											input1	  => input1,
											input2     => input2,
											muxOutput  => muxOutput
											);
								  
	select_process: process
	begin
			selectLine <= '0';
			wait for 50 ns;
			selectLine <= '1';
			wait for 100 ns;
	end process;

	
end Behavioral;
	