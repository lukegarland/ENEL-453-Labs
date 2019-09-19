--Test bench for sequential logic test.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_sequential_switch_logic IS
END tb_sequential_switch_logic;

ARCHITECTURE behavior OF tb_sequential_switch_logic IS

-- Component Declaration for the UUT
	constant clk_period:time:=10 ns;
	
    COMPONENT switch_logic
    PORT(
        switches_inputs : IN std_logic_vector(2 downto 0);
        outputs : OUT std_logic_vector(2 downto 0) ;
        clk : IN std_logic;
		reset : in std_logic
    );
    END COMPONENT;
    
    --Inputs
    signal switches_inputs : std_logic_vector(2 downto 0) := (others => '0');
    
    --Outputs
    signal outputs : std_logic_vector(2 downto 0);
    
	signal clk, reset : std_logic;
	
    BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: switch_logic PORT MAP (
        switches_inputs => switches_inputs,
        outputs => outputs,
        clk => clk,
        reset => reset
    );
    
    -- Stimulus process here
	clk_process : process
	begin 
	reset <= '0';
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
	
	end process;
	
	
	A_process: process
		begin
			switches_inputs(0)<= '0';
			wait for 20 ns;
			switches_inputs(0)<= '1';
			wait for 20 ns;
		end process;
			
	B_process: process
		begin 
			switches_inputs(1)<= '0';
			wait for 40 ns;
			switches_inputs(1)<= '1';
			wait for 40 ns;
		end process;
		
	C_process: process
		begin
			switches_inputs(2) <= '0';
			wait for 80 ns;
			switches_inputs(2) <= '1';
			wait for 80 ns;
		end process;
		
			
			

END;
