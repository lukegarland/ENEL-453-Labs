-- --- Seven segment component
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity SevenSegment is
    Port ( DP_in                                                 			: in  STD_LOGIC_VECTOR (5 downto 0);
           Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5	: in  STD_LOGIC_VECTOR (3 downto 0);
           HEX0, HEX1, HEX2, HEX3, HEX4, HEX5                   			: out STD_LOGIC_VECTOR (7 downto 0)
          );
end SevenSegment;


architecture Behavioral of SevenSegment is
--Note that component declaration comes after architecture and before begin (common source of error).

	type HexNumberInput is array (5 downto 0) of STD_LOGIC_VECTOR (3 downto 0);
	type HexNumberOutput is array (5 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
	
	signal HexInput  : HexNumberInput;
	signal HexOutput : HexNumberOutput;

   Component SevenSegment_decoder is 
      port(  H     : out STD_LOGIC_VECTOR (7 downto 0);
             input : in  STD_LOGIC_VECTOR (3 downto 0);
             DP    : in  STD_LOGIC                               
          );                  
   end  Component;
   
	begin
--Note that port mapping begins after begin (common source of error).

	HexInput  <= (0 => Num_Hex0, 1 => Num_Hex1, 2 => Num_Hex3, 3 => Num_Hex4, 4 => Num_Hex4, 5 => Num_Hex5);
		
	Decoder: for i in 0 to 5 generate
	begin
		decoderX: SevenSegment_decoder port map(H => HexOutput(i),
															input => HexInput(i),
															DP => DP_in(i)
															);
	end generate;
	
			
	Hex0 <= HexOutput(0);
	Hex1 <= HexOutput(1);
	Hex2 <= HexOutput(2);
	Hex3 <= HexOutput(3);
	Hex4 <= HexOutput(4);
	Hex5 <= HexOutput(5);
	
end Behavioral;