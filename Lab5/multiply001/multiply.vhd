library work, ieee;
use ieee.std_logic_1164.all;

entity multiply is
	port ( 
			dataa		: in std_logic_vector (7 downto 0);
			datab		: in std_logic_vector (7 downto 0);
			result	: out std_logic_vector (15 downto 0)
		);
end multiply;
architecture behavioral of multiply is
component mult is
	port
	(
		dataa		: in std_logic_vector (7 downto 0);
		datab		: in std_logic_vector (7 downto 0);
		result		: out std_logic_vector (15 downto 0)
	);
end component;

begin
mult_ins: mult port map(
	dataa=>dataa,
	datab=>datab,
	result=>result);
end behavioral;