-- --- from lab instructions pages 9 to 11
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_switch_logic IS
END tb_switch_logic;

ARCHITECTURE behavior OF tb_switch_logic IS

-- Component Declaration for the UUT

    COMPONENT switch_logic
    PORT(
        switches_inputs : IN std_logic_vector(2 downto 0);
        outputs : OUT std_logic_vector(2 downto 0) -- ;
        -- clk : IN std_logic;
        -- reset : in std_logic
    );
    END COMPONENT;
    
    --Inputs
    signal switches_inputs : std_logic_vector(2 downto 0) := (others => '0');
    
    --Outputs
    signal outputs : std_logic_vector(2 downto 0);
    
    BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: switch_logic PORT MAP (
        switches_inputs => switches_inputs,
        outputs => outputs --,
        -- clk => clk,
        -- reset => reset
    );
    
	 A_process: process
	 begin
	 
		switches_inputs(0) <= '0';
		
		wait for 20 ns;
		
		switches_inputs(0) <= '1';
		
		wait for 20 ns;
		
	 end process;
	 
	 B_process: process
	 begin
	 
		switches_inputs(1) <= '0';
		
		wait for 40 ns;
		
		switches_inputs(1) <= '1';
		
		wait for 40 ns;
	 end process;
	 
	 C_process: process
	 begin
		switches_inputs(2) <= '0';
		
		wait for 80 ns;
		
		switches_inputs(2) <= '1';
		
		wait for 80 ns;
	 end process;
	 
	 
	 -- Stimulus process here
    -- Stimulus process 
--    stim_proc: process 
--    begin
--      -- hold reset state for 100 ns. 
--      wait for 100 ns;
--
--      -- Set all inputs to 0 
--      switches_inputs(0) <= '0';  --A 
--      switches_inputs(1) <= '0';  --B 
--      switches_inputs(2) <= '0';  --C
--      -- alternative syntax for the 3 above lines is
--      -- switches_inputs <= "000";  -- ABC
--      
--      wait for 50 ns;
--
--      -- Test an input combination 
--      switches_inputs(0) <= '1';  --A 
--      switches_inputs(1) <= '0';  --B 
--      switches_inputs(2) <= '0';  --C
--
--      wait for 100 ns;
--      
--      -- Add more tests to comprehensively test the circuit 
--      -- Set all inputs to 0 
--      switches_inputs(0) <= '0';  --A 
--      switches_inputs(1) <= '0';  --B 
--      switches_inputs(2) <= '0';  --C
--      -- alternative syntax for the 3 above lines is
--      -- switches_inputs <= "000";  -- ABC
--      
--      wait for 50 ns;
--
--      -- Test an input combination 
--      switches_inputs(0) <= '1';  --A 
--      switches_inputs(1) <= '0';  --B 
--      switches_inputs(2) <= '0';  --C      
--		wait;	-- Keeps it from restarting 
--    end process;

END;
