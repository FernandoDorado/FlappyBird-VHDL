library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity master is
    Port ( button : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  clk : in STD_LOGIC;
           RED : out  STD_LOGIC_VECTOR (2 downto 0);
           GRN : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE : out  STD_LOGIC_VECTOR (1 downto 0);
           HS : out  STD_LOGIC;
           VS : out  STD_LOGIC;
			  A : out  STD_LOGIC;
           B : out  STD_LOGIC;
           C : out  STD_LOGIC;
           D : out  STD_LOGIC;
           E : out  STD_LOGIC;
           F : out  STD_LOGIC;
           G : out  STD_LOGIC;
           DP : out  STD_LOGIC;
           AN : out  STD_LOGIC_VECTOR(3 downto 0));
end master;

architecture Behavioral of master is

--DECLARACION COMPONENTES--

COMPONENT marcador is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  enable : in STD_LOGIC; 
           A : out  STD_LOGIC;
           B : out  STD_LOGIC;
           C : out  STD_LOGIC;
           D : out  STD_LOGIC;
           E : out  STD_LOGIC;
           F : out  STD_LOGIC;
           G : out  STD_LOGIC;
           DP : out  STD_LOGIC;
           AN : out  STD_LOGIC_VECTOR(3 downto 0));
END COMPONENT;

COMPONENT BirdSprites
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
  );
END COMPONENT;

COMPONENT GenSprites is
    Port ( 
			  eje_x : in  STD_LOGIC_VECTOR (9 downto 0);
           eje_y : in  STD_LOGIC_VECTOR (9 downto 0);
           data : in  STD_LOGIC_VECTOR (2 downto 0);
			  posy: in STD_LOGIC_VECTOR (9 downto 0);
			  direc : out STD_LOGIC_VECTOR (9 downto 0);
           RED : out  STD_LOGIC_VECTOR (2 downto 0);
           GRN : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE : out  STD_LOGIC_VECTOR (1 downto 0));			  
END COMPONENT;

COMPONENT RomGap
	PORT ( clka : IN STD_LOGIC;
	        addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	        douta : OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END COMPONENT;

COMPONENT RomGap2
	PORT ( clka : IN STD_LOGIC;
			  addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	        douta : OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END COMPONENT;

component BIRD is
	Port (  reset : in STD_LOGIC;
			  clk : in STD_LOGIC;
			  refresh: in STD_LOGIC;
			  button : in STD_LOGIC;
			  muerte : in STD_LOGIC;
			  posY_bird : out STD_LOGIC_VECTOR);
end component;

component VGA_DRIVER is
	Port ( RED_IN : in STD_LOGIC_VECTOR(2 downto 0);
			  GRN_IN : in STD_LOGIC_VECTOR(2 downto 0);
			  BLUE_IN : in STD_LOGIC_VECTOR(1 downto 0);
			  clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           HS : out  STD_LOGIC;
           VS : out  STD_LOGIC;
			  eje_xO : out STD_LOGIC_VECTOR (9 downto 0);
			  eje_yO : out STD_LOGIC_VECTOR (9 downto 0);
			  refresh : out STD_LOGIC;
			  RED_OUT : out STD_LOGIC_VECTOR (2 downto 0);
			  GRN_OUT : out STD_LOGIC_VECTOR (2 downto 0);
			  BLUE_OUT : out STD_LOGIC_VECTOR (1 downto 0));
end component;

component COLUMNA is
	Generic (pos_inicial : unsigned);
	Port ( eje_x : in  STD_LOGIC_VECTOR (9 downto 0);
           eje_y : in  STD_LOGIC_VECTOR (9 downto 0);
			  gapY :in STD_LOGIC_VECTOR(9 downto 0);
           button : in  STD_LOGIC;
			  refresh : in STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  muerte : in STD_LOGIC;
			  marcador : out STD_LOGIC; 
			  dir : out STD_LOGIC_VECTOR (2 downto 0);
           RED : out  STD_LOGIC_VECTOR (2 downto 0);
           GRN : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE : out  STD_LOGIC_VECTOR (1 downto 0));
end component;

component DIBUJA is
	Port ( clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  posY_bird : in STD_LOGIC_VECTOR (9 downto 0);
			  RED_bird : in  STD_LOGIC_VECTOR (2 downto 0);
           GRN_bird : in  STD_LOGIC_VECTOR (2 downto 0);
           BLUE_bird : in  STD_LOGIC_VECTOR (1 downto 0);
           RED_col : in  STD_LOGIC_VECTOR (2 downto 0);
           GRN_col : in  STD_LOGIC_VECTOR (2 downto 0);
           BLUE_col : in  STD_LOGIC_VECTOR (1 downto 0);
			  RED_col2 : in  STD_LOGIC_VECTOR (2 downto 0);
           GRN_col2 : in  STD_LOGIC_VECTOR (2 downto 0);
           BLUE_col2 : in  STD_LOGIC_VECTOR (1 downto 0);
			  eje_x: IN STD_LOGIC_VECTOR (9 downto 0);
			  eje_y: IN STD_LOGIC_VECTOR (9 downto 0);
           RED : out  STD_LOGIC_VECTOR (2 downto 0);
           GRN : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE : out  STD_LOGIC_VECTOR (1 downto 0);
			  muerte : out STD_LOGIC);
end component;
	


--DECLARACION SEÑALES--
--Para la diferenciación de las señales: hemos llamado "s_xxx" a las señales internas de nuestro master, estas señales se encargan de conectar los diferentes bloques que hemos creado entre ellos. 
signal s_eje_x, s_eje_y, s_posY_bird : std_logic_vector (9 downto 0);
signal s_dir1,s_dir2, s_data_bird : std_logic_vector (2 downto 0); 
signal s_refresh, s_muerte: std_logic;
signal RED_int, GRN_int, RED_bird, RED_col, RED_col2, GRN_col, GRN_col2, GRN_bird : std_logic_vector (2 downto 0);
signal BLUE_int, BLUE_bird, BLUE_col, BLUE_col2 : std_logic_vector (1 downto 0);
signal Gap1,Gap2, s_dir_bird : std_logic_vector (9 downto 0); --Variable que indica la posición del hueco de la columna. 
signal enable_marcador1, enable_marcador2, enable: STD_LOGIC;


begin

enable <= enable_marcador1 or enable_marcador2; --Genero la señal enable que se produce cuando creo una nueva columna. 

marcadorr: marcador
	Port Map(clk => clk,
           reset => reset,
			  enable => enable, --Entra la señal que indica cuando tiene que incrementarse el contador. 
           A => A,
           B => B,
           C => C,
           D => D,
           E => E,
           F => F,
           G => G,
           DP => DP,
           AN => AN
			  );
			  
sprite : GenSprites
    Port Map(
				 eje_x=>s_eje_x,
				 eje_y=>s_eje_y,
				 data=>s_data_bird,
				 posy=>s_posy_bird,
				 direc=> s_dir_bird,
				 RED=>RED_bird,
				 GRN=>GRN_bird,
				 BLUE=>BLUE_bird
				 );	
				 
--Memoria para dibujar el Sprite de nuestro pájaro.
memBird : BirdSprites
  PORT MAP (
    clka => clk,
    addra => s_dir_bird,
    douta => s_data_bird
  );			
  
--Memorias para indicar la posición del hueco de nuestra columna. 
mem1 : RomGap
	PORT MAP (
			 clka => clk,
		  	 addra => s_dir1, --Me indica la dirección en la que leer el hueco de la columna. 
			 douta =>  Gap1); --Leo el dato de nuestra memoria en la posición que corresponda. 
			 
mem2 : RomGap2
	PORT MAP (
			 clka => clk,
		  	 addra => s_dir2, --Me indica la dirección en la que leer el hueco de la columna. 
			 douta =>  Gap2); --Leo el dato de nuestra memoria en la posición que corresponda.
					 
pajaro : BIRD
	port map ( 
			  reset => reset,
			  clk => clk,
			  refresh => s_refresh,
			  button => button,
			  muerte => s_muerte,
			  posY_bird => s_posY_bird
			  );
			  
columna1 : COLUMNA
	generic map (pos_inicial => "1001011111")
	port map ( eje_x => s_eje_x,
           eje_y => s_eje_y,
			  gapY => Gap1, --Le entra desde la memoria la posición del hueco de la columna. 
           button => button,
			  refresh => s_refresh,
           clk => clk,
           reset => reset,
			  muerte => s_muerte,
			  marcador => enable_marcador1,
			  dir => s_dir1, --Me indica la dirección en la que leer el hueco de la columna. 
           RED => RED_col,
           GRN => GRN_col,
           BLUE => BLUE_col 
			  );
			  
columna2 : COLUMNA
	generic map (pos_inicial => "0101010100")
	port map ( eje_x => s_eje_x,
           eje_y => s_eje_y,
			  gapY => Gap2,
           button => button,
			  refresh => s_refresh,
           clk => clk,
           reset => reset,
			  marcador => enable_marcador2,
			  muerte => s_muerte,
			  dir => s_dir2,			  
           RED => RED_col2,
           GRN => GRN_col2,
           BLUE => BLUE_col2 
			  );
			  
dibujo : DIBUJA
	port map ( clk => clk,
			  reset => reset,
			  RED_bird => RED_bird,
           GRN_bird => GRN_bird,
           BLUE_bird => BLUE_bird,
           RED_col => RED_col,
           GRN_col => GRN_col,
           BLUE_col => BLUE_col,
			  RED_col2 => RED_col2,
			  GRN_col2 => GRN_col2,
			  BLUE_col2 => BLUE_col2,
           RED => RED_int,
           GRN => GRN_int,
           BLUE => BLUE_int,
			  eje_x => s_eje_x,
			  eje_y => s_eje_y,
			  muerte => s_muerte,
			  posY_bird => s_posY_bird
			  );
			  
driver : VGA_DRIVER
	port map ( RED_IN => RED_int,
			  GRN_IN => GRN_int,
			  BLUE_IN => BLUE_int,
			  clk => clk,
           reset => reset,
           HS => HS,
           VS => VS,
			  eje_xO => s_eje_x,
			  eje_yO => s_eje_y,
			  refresh => s_refresh,
			  RED_OUT => RED,
			  GRN_OUT => GRN,
			  BLUE_OUT => BLUE
			  );
end Behavioral;