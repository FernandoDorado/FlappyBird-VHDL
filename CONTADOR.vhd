library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity contador is
	 Generic (Nbit: INTEGER := 8);
	Port ( clk : in STD_LOGIC;
	reset : in STD_LOGIC;
	enable : in STD_LOGIC;
	resets : in STD_LOGIC;
	Q : out STD_LOGIC_VECTOR (Nbit-1 downto 0));
end contador;

architecture Behavioral of contador is

	signal cont: UNSIGNED(Nbit-1 downto 0);
	signal p_cont: UNSIGNED(Nbit-1 downto 0);
begin


sinc: process(clk,reset)
	begin
		if(reset='1') then
			cont<=(others=>'0');
		elsif(rising_edge(clk)) then
			cont<=p_cont;
		end if;
	end process;


comb: process(enable,resets,cont)
	begin
		if(resets='1') then
			p_cont<=(others=>'0');
		elsif(enable='1') then
			p_cont<=cont+1;
		else
			p_cont<=cont;
		end if;
	end process;
	
	Q<=STD_LOGIC_VECTOR(cont);

end Behavioral;

