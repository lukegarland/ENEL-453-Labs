library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity error_ctrl is

port( 
		DP_in                   	: out  STD_LOGIC_VECTOR (5 downto 0);
		Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5		: out STD_LOGIC_VECTOR (3 downto 0);
		bcd 								: in std_logic_vector(15 downto 0);
		voltage_mode 					: in std_logic
    );
end entity;

architecture rtl of error_ctrl is
begin

	error_message: process(bcd, voltage_mode)
		begin 
		if (to_integer(unsigned(bcd)) = 33169) then --33169 is the error code ("1111111111111" in bcd converted to unsigned)
			-- ERROR CASE
			Num_Hex0 <= "1011"; --r
			Num_Hex1 <= "1100";	--o
			Num_Hex2 <= "1011";	--r
			Num_Hex3 <= "1011";	--r
			Num_Hex4 <= "1010"; --E
			Num_Hex5 <= "1111";  -- blank this display   
			DP_in <=  "000000";

		else

			Num_Hex0 <= bcd(3  downto  0); 
			Num_Hex1 <= bcd(7  downto  4);
			Num_Hex2 <= bcd(11 downto  8);

			if(bcd(15 downto 12) = "0000" and voltage_mode = '0' ) then
				--Blank 4th digit if distance mode is enabled, and digit is 0 
				Num_Hex3 <= "1111";
			else 	
				Num_Hex3 <= bcd(15 downto 12);
			end if;

			Num_Hex4 <= "1111";  -- blank this display
			Num_Hex5 <= "1111";  -- blank this display  

			if (voltage_mode = '0') then
				-- Decimal location for distance mode
				DP_in <=  "000100";
			else 
				DP_in <= "001000";-- position of the decimal point in the display for voltage
			end if;

		end if;


		end process error_message;


end;
