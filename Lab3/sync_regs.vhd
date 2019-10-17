library ieee;
use ieee.std_logic_1164.all;


entity sync_registers is 
generic(bits : integer := 1;
		num_of_registers: integer := 2);
Port (
		clk       : in  std_logic;
		reset     : in  std_logic;
		enable    : in  std_logic;
		d_input  : in  std_logic_vector(bits-1 downto 0);
		q_output : out std_logic_vector(bits-1 downto 0)	
);

end sync_registers;

architecture Behavioral of sync_registers is


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



	type array_type is array (1 to num_of_registers+1) of STD_LOGIC_VECTOR (bits-1 downto 0);
	
	signal sync_data  : array_type;
	
	
	
	begin


	syncs: for i in 1 to num_of_registers generate
	begin
		regs: registers 
		generic map(bits => bits)
		port map(
						clk	 => clk,
						reset => reset,
						enable => enable,
						d_inputs => sync_data(i),
						q_outputs => sync_data(i+1)
		);
	
	end generate;
sync_data(1) <= d_input;	
q_output <= sync_data(num_of_registers+1);

end;