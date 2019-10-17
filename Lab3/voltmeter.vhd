library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
entity Voltmeter is
    Port ( clk                           : in  STD_LOGIC;
           reset                         : in  STD_LOGIC;
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0);
			  selectSig							  : in STD_LOGIC;
			  shortEnable						  : in STD_LOGIC
          );
           
end Voltmeter;

architecture Behavioral of Voltmeter is

Signal A, Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5 :   STD_LOGIC_VECTOR (3 downto 0):= (others=>'0');   
Signal DP_in:   STD_LOGIC_VECTOR (5 downto 0);
Signal ADC_read,rsp_data,q_outputs_1 : STD_LOGIC_VECTOR (11 downto 0);
Signal voltage,  mux_out: STD_LOGIC_VECTOR (12 downto 0);
Signal busy: STD_LOGIC;
signal response_valid_out_i1,response_valid_out_i2: STD_LOGIC_VECTOR(0 downto 0);
Signal bcd: STD_LOGIC_VECTOR(15 DOWNTO 0);
Signal Q_temp1 : std_logic_vector(11 downto 0);
Signal distance_output: std_logic_vector(12 downto 0);



component sync_registers is 
generic(bits : integer := 1;
		num_of_registers: integer := 2);
Port (
		clk       : in  std_logic;
		reset     : in  std_logic;
		enable    : in  std_logic;
		d_input  : in  std_logic_vector(bits-1 downto 0);
		q_output : out std_logic_vector(bits-1 downto 0)	

);
end component;


Component SevenSegment is
    Port( Num_Hex0, Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 : in  STD_LOGIC_VECTOR (3 downto 0);
          Hex0,Hex1,Hex2,Hex3,Hex4,Hex5                         : out STD_LOGIC_VECTOR (7 downto 0);
          DP_in                                                 : in  STD_LOGIC_VECTOR (5 downto 0)
			);
End Component ;




Component ADC_Conversion is --FOR SIMULATION THIS NEEDS TO BE test_DE10_Lite instead of ADC_Conversion
    Port( MAX10_CLK1_50      : in STD_LOGIC;
          response_valid_out : out STD_LOGIC;
          ADC_out            : out STD_LOGIC_VECTOR (11 downto 0)
         );
End Component ;




Component binary_bcd IS
   PORT(
      clk     : IN  STD_LOGIC;                      --system clock
      reset   : IN  STD_LOGIC;                      --active low asynchronus reset
      ena     : IN  STD_LOGIC;                      --latches in new binary number and starts conversion
      binary  : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);  --binary number to convert
      busy    : OUT STD_LOGIC;                      --indicates conversion in progress
      bcd     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)   --resulting BCD number
		);           
END Component;




Component registers is
   generic(bits : integer);
   port
     ( 
		clk       : in  std_logic;
		reset     : in  std_logic;
		enable    : in  std_logic;
		d_inputs  : in  std_logic_vector(bits-1 downto 0);
		q_outputs : out std_logic_vector(bits-1 downto 0)  
     );
END Component;



Component generic_averager is
generic(samples_to_avg : integer);
	port(
		clk, reset 	: in std_logic;
		Din 		: in  std_logic_vector(11 downto 0);
		EN  		: in  std_logic; -- response_valid_out
		Q  			: out std_logic_vector(11 downto 0)
		);
  end Component;

Component Multiplexor is
	port(
	 selectLine : in std_logic;
	 input1 	: in std_logic_vector(12 downto 0);
	 input2 	: in std_logic_vector(12 downto 0);
	 muxOutput	: out std_logic_vector(12 downto 0)
	 );
  end component;

component voltage2distance is
	port(
			clk            :  IN    STD_LOGIC;                                
			reset          :  IN    STD_LOGIC;                                
			voltage        :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);                           
			distance       :  OUT   STD_LOGIC_VECTOR(12 DOWNTO 0);
			shortEnable	   :  IN 	STD_LOGIC
	);
	end component;

begin

	ave :   generic_averager
			generic map(samples_to_avg =>128)
			port map(
					  clk       => clk,
					  reset     => reset,
					  Din       => q_outputs_1,
					  EN        => response_valid_out_i2(0),
					  Q         => Q_temp1
				  );


	-- Multiplexor declaring code
	mult : multiplexor
			  port map(
						  selectLine => selectSig,
						  input1	 	 => distance_output,
						  input2     => voltage,
						  muxOutput  => mux_out
						  );
						  
	   
	sync_adc: sync_registers
				generic map(bits => 12,
							num_of_registers=>2)
				port map (
					 clk       => clk,
					 reset     => reset,
					 enable    => '1',
					 d_input  => ADC_read,
					 q_output => q_outputs_1			
				
					);
	   
		  sync_enable: sync_registers
				generic map(bits => 1,
							num_of_registers=>2)
				port map (
					 clk       => clk,
					 reset     => reset,
					 enable    => '1',
					 d_input  => response_valid_out_i1,
					 q_output => response_valid_out_i2			
				
				);
	   
					   
	SevenSegment_ins: SevenSegment  
					  PORT MAP( Num_Hex0 => Num_Hex0,
								Num_Hex1 => Num_Hex1,
								Num_Hex2 => Num_Hex2,
								Num_Hex3 => Num_Hex3,
								Num_Hex4 => Num_Hex4,
								Num_Hex5 => Num_Hex5,
								Hex0     => Hex0,
								Hex1     => Hex1,
								Hex2     => Hex2,
								Hex3     => Hex3,
								Hex4     => Hex4,
								Hex5     => Hex5,
								DP_in    => DP_in
							  );
										 
	ADC_Conversion_ins:  ADC_Conversion  PORT MAP(      -- THIS NEEDS TO BE ADC_Conversion when not simulating.
										 MAX10_CLK1_50       => clk,
										 response_valid_out  => response_valid_out_i1(0),
										 ADC_out             => ADC_read);
	 
	 
	voltage2distance_ins: voltage2distance
	Port Map (
				clk			=>   	clk,                 
				reset       =>      reset,     
				voltage 	=>		voltage,
				distance 	=>		distance_output,
				shortEnable => 		shortEnable
	);

	binary_bcd_ins: binary_bcd                               
	   PORT MAP(
		  clk      => clk,                          
		  reset    => reset,                                 
		  ena      => '1',                           
		  binary   => mux_out,    
		  busy     => busy,                         
		  bcd      => bcd         
	);
		  
		   
	LEDR(9 downto 0) <= Q_temp1(11 downto 2); -- gives visual display of upper binary bits to the LEDs on board

	-- in line below, can change the scaling factor (i.e. 2500), to calibrate the voltage reading to a reference voltmeter
	voltage <= std_logic_vector(resize(unsigned(Q_temp1)*2500*2/4096,voltage'length));  -- Converting ADC_read a 12 bit binary to voltage readable numbers

		  
	error_message: process(bcd, selectSig)
		begin 
		if (to_integer(unsigned(bcd)) = 33169) then --33169 is the 8191 in BCD which the number for the error

			Num_Hex0 <= "1011"; 
			Num_Hex1 <= "1100";
			Num_Hex2 <= "1011";
			Num_Hex3 <= "1011";
			Num_Hex4 <= "1010";  
			Num_Hex5 <= "1111";  -- blank this display   
			DP_in <=  "000000";

		else

			Num_Hex0 <= bcd(3  downto  0); 
			Num_Hex1 <= bcd(7  downto  4);
			Num_Hex2 <= bcd(11 downto  8);

			if(bcd(15 downto 12) = "0000" and selectSig = '0' ) then
				Num_Hex3 <= "1111";
			else 	
				Num_Hex3 <= bcd(15 downto 12);
			end if;

			Num_Hex4 <= "1111";  -- blank this display
			Num_Hex5 <= "1111";  -- blank this display  

			if (selectSig = '0') then
				DP_in <=  "000100";
			else 
				DP_in <= "001000";-- position of the decimal point in the display
			end if;

		end if;


		end process error_message;

	  
end Behavioral;