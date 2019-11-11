library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity SquareWaveGenerator is
	Port(
			CLK                        : in STD_LOGIC;
			reset                      : in STD_LOGIC;
			amplitudeOrFrequencySelect : in STD_LOGIC;
			genericAveragerValue      : in STD_LOGIC_VECTOR(11 downto 0);
			digitalWaveValue           : out STD_LOGIC_VECTOR(8 downto 0)
		);
end SquareWaveGenerator;


architecture Behavior of squareWaveGenerator is

Signal enableForIndexIncrementing : STD_LOGIC;
Signal indexForLUT                : STD_LOGIC_VECTOR(8 downto 0);
Signal periodInternal 				 : STD_LOGIC_VECTOR(12 downto 0);

type array_1d is array (0 to 511) of integer;
constant squareWaveLUT : array_1d := (0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1, 1);

constant Herz440 : STD_logic_vector(12 downto 0) := "0000011011110";

component adjustableDownCounter is
	Port(
			period : in STD_LOGIC_VECTOR(12 downto 0);
			CLK    : in STD_LOGIC;
			reset  : in STD_LOGIC;
         enable : in  STD_LOGIC; -- active-high enable
         zero   : out STD_LOGIC -- creates a positive pulse every time current_count hits zero
                                   -- useful to enable another device, like to slow down a counter
		 );
end component adjustableDownCounter;


begin

adjustableDownCounter_INS : adjustableDownCounter
	port map(
				period => periodInternal,
				CLK => CLK,
				reset => reset,
				enable => '1',
				zero => enableForIndexIncrementing
				);
				
process(clk, enableForIndexIncrementing, indexForLUT)
	begin
		if(rising_edge(CLK)) then
			if (enableForIndexIncrementing = '1') then
				indexForLUT <=  std_logic_vector(to_unsigned(to_integer(unsigned(indexForLUT)) + 1, indexForLUT'length));
			else
				indexForLUT <= indexForLUT;
			end if;
		end if;
end process;


process(clk, amplitudeOrFrequencySelect, genericAveragerValue, indexForLUT)
	begin
	if(rising_edge(CLK)) then
		if (reset = '1') then
			digitalWaveValue <= (others => '0');
		else
			if (amplitudeOrFrequencySelect = '1') then
				periodInternal <= Herz440;
				digitalWaveValue <= std_logic_vector(to_unsigned(squareWaveLUT(to_integer(unsigned(indexForLUT))) * (to_integer(unsigned(genericAveragerValue)))*(512*(1780)/1024)/(4096),digitalWaveValue'length));
			else
			
				periodInternal <= std_logic_vector(to_unsigned(to_integer(unsigned(genericAveragerValue))*274/1024,periodInternal'length));
				digitalWaveValue <= std_logic_vector(to_unsigned(squareWaveLUT(to_integer(unsigned(indexForLUT)))*511,digitalWaveValue'length));
			end if;
		end if;
	end if;
end process;

end Behavior;

