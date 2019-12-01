
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_multiply is
end tb_multiply;

architecture behavior of tb_multiply is
	signal		dataa		:  std_logic_vector (7 downto 0):=(others=>'0');
	signal		datab		:  std_logic_vector (7 downto 0):=(others=>'0');
	signal		result		:  std_logic_vector (15 downto 0);
	signal	 	check 		: string(1 to 4) := "pass";

	component multiply
		port(
			dataa		: in std_logic_vector (7 downto 0);
			datab		: in std_logic_vector (7 downto 0);
			result		: out std_logic_vector(15 downto 0)
			);
		end component;
 
 begin
	multiply_ins: multiply port map(
		dataa=>dataa,
		datab=>datab,
		result=>result);
	data_process: process
	begin
	for i in 0 to integer(2**real(datab'length)-1.0) loop
		datab<=std_logic_vector(to_unsigned(i,datab'length));			--generating value for dataa
		wait for 20 ns;			
		for k in 0 to integer(2**real(dataa'length)-1.0) loop
			dataa<=std_logic_vector(to_unsigned(k,dataa'length));		--generating value for datab
			wait for 20 ns;
		end loop;
	end loop;
	wait;
	end process;

	check_process: process
    begin
		if real(to_integer(unsigned(result)))/= real(to_integer(unsigned(dataa)))* real(to_integer(unsigned(datab))) then  
		check<="fail";  
		end if;
		-------------------------------------------STOPing the simulation-------------------------------------------------
		if(datab/=std_logic_vector(to_unsigned(integer(2**real(datab'length)-1.0),datab'length))) then
		wait for 20 ns;		
		else
		report check;
		wait;
		end if;
		------------------------------------------------------------------------------------------------------------------
	end process;
end;
