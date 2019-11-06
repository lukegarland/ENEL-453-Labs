-- Multiplexor VHDL Code
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux4to1 is
	Generic ( busWidth : integer := 9); -- number to count       
	port(
	 selectLine : in std_logic_vector(1 downto 0);
	 input1 : in std_logic_vector(busWidth - 1 downto 0);
	 input2 : in std_logic_vector(busWidth - 1 downto 0);
	 input3 : in std_logic_vector(busWidth - 1 downto 0);
	 input4 : in std_logic_vector(busWidth - 1 downto 0);
	 muxOutput : out std_logic_vector(busWidth - 1 downto 0)
	 );
end Mux4to1;

architecture Behaviour of Mux4to1 is
	begin
		with selectLine select
			muxOutput <= 	input1 when "00",
							input2 when "01",
							input3 when "10",
							input4 when others;
					 
end Behaviour;
