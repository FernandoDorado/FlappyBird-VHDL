library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_DRIVER	 is
    Port ( RED_IN: in STD_LOGIC_VECTOR(2 downto 0);
			  GRN_IN: in STD_LOGIC_VECTOR(2 downto 0);
			  BLUE_IN: in STD_LOGIC_VECTOR(1 downto 0);
			  clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;	
           HS : out  STD_LOGIC;
           VS : out  STD_LOGIC;
			  eje_xO: OUT STD_LOGIC_VECTOR (9 downto 0);
			  eje_yO: OUT STD_LOGIC_VECTOR (9 downto 0);
			  refresh : out STD_LOGIC;
			  RED_OUT : out STD_LOGIC_VECTOR (2 downto 0);
			  GRN_OUT : out STD_LOGIC_VECTOR (2 downto 0);
			  BLUE_OUT : out STD_LOGIC_VECTOR (1 downto 0));
end VGA_DRIVER;

architecture Behavioral of VGA_DRIVER is

--Declaramos las señales
signal clk_pixel,p_clk_pixel,blankH,blankV,resetSH,resetSV,enableV : STD_LOGIC;
signal eje_x, eje_y: STD_LOGIC_VECTOR (9 downto 0);


--Declaramos los componentes



component COMPARADOR is
	Generic (Nbit: integer :=8;
		End_Of_Screen: integer :=10;
		Start_Of_Pulse: integer :=20;
		End_Of_Pulse: integer := 30;
		End_Of_Line: integer := 40);
	Port ( clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		data : in STD_LOGIC_VECTOR (Nbit-1 downto 0);
		O1 : out STD_LOGIC;
		O2 : out STD_LOGIC;
		O3 : out STD_LOGIC);
end component;


component CONTADOR is
	 Generic (Nbit: INTEGER := 8);
	Port ( clk : in STD_LOGIC;
	reset : in STD_LOGIC;
	enable : in STD_LOGIC;
	resets : in STD_LOGIC;
   Q : out STD_LOGIC_VECTOR (Nbit-1 downto 0));
end component;

begin
enableV <= clk_pixel AND resetSH;
refresh<=resetSV;
eje_xO<=eje_x;
eje_yO<=eje_y;

contH: CONTADOR 
	generic map (Nbit=> 10)
	port map(
		clk => clk,
		reset => reset,
		enable => clk_pixel,
		resets => resetSH,
		Q=> eje_x
	);
contV: CONTADOR 
	generic map (Nbit=> 10)
	port map(
		clk => clk,
		reset => reset,
		enable => enableV,
		resets => resetSV,
		Q => eje_y
	);
	
compH: COMPARADOR
	generic map (
		Nbit => 10,
		End_Of_Screen=> 639,
		Start_Of_Pulse => 655,
		End_Of_Pulse => 751,
		End_Of_Line => 799
	)
	port map(
		clk => clk,
		reset => reset,
		data => eje_x,
		O1 => blankH,
		O2 => HS,
		O3 => resetSH
	);
	
compV: COMPARADOR
	generic map (
		Nbit => 10,
		End_Of_Screen=> 479,
		Start_Of_Pulse => 489,
		End_Of_Pulse => 491,
		End_Of_Line => 520
	)
	port map(
		clk => clk,
		reset => reset,
		data => eje_y,
		O1 => blankV,
		O2 => VS,
		O3 => resetSV
	);


--Genero la frecuencia del pixel
p_clk_pixel <= not clk_pixel;
div_frec:process(clk,reset) is 
begin
	if (reset='1') then
		clk_pixel<='0';
	elsif (rising_edge(clk)) then
		clk_pixel<= p_clk_pixel;
	end if;
end process;

gen_color:process(BlankH, BlankV, RED_in, GRN_in,BLUE_in)
begin
	if (BlankH='1' or BlankV='1') then
		RED_OUT<=(others => '0'); GRN_OUT<=(others => '0'); 	BLUE_OUT<=(others => '0');
	else
		RED_OUT<=RED_IN; GRN_OUT<=GRN_IN; BLUE_OUT<=BLUE_IN;
	end if;
end process;

end Behavioral;

