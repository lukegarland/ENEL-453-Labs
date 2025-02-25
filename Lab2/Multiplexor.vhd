-- Multiplexor VHDL Code
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiplexor is
	port(
	 selectLine : in std_logic;
	 input1 : in std_logic_vector(11 downto 0);
	 input2 : in std_logic_vector(11 downto 0);
	 muxOutput : out std_logic_vector(11 downto 0)
	 );
end Multiplexor;

architecture BEHAVIOR of Multiplexor is
	begin
	
		muxOutput <= input1 when selectLine = '0'
					 else input2 when selectLine = '1';
					 
end BEHAVIOR;
