library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity COLUMNA is
	 Generic (pos_inicial : unsigned := "1001011111");
    Port ( eje_x : in  STD_LOGIC_VECTOR (9 downto 0);
           eje_y : in  STD_LOGIC_VECTOR (9 downto 0);
			  gapY : in STD_LOGIC_VECTOR(9 downto 0);
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
end COLUMNA;

architecture Behavioral of COLUMNA is
signal p_marcador: STD_lOGIC; 
signal direc, p_direc : unsigned (2 downto 0);
signal columnaX, p_columnaX : unsigned (9 downto 0);
type TipoEstado is (Reposo, Start, Act_ColumnaX, Act_Direc, Nueva_Columna);
signal estado, p_estado : TipoEstado;


begin

dir <= std_logic_vector(direc);--Esta señal se indica de incrementar la dirección a leer posteriormente
										 --Nos será de utilidad para leer el coe que usaremos para la posición vertical de los huecos de las columnas (GapY)

--Maquina de estados encargada del movimiento de la columna
comb: process(estado,refresh,button,GapY,columnaX,muerte,direc)
begin
p_estado<=estado;
p_columnaX<=columnaX;


case estado is

	when reposo => --Juego parado
		p_columnaX<=columnaX;
		p_direc <= direc;
		p_marcador <='0';
		if(button='1') then --Cuando pulsamos el botón comienza nuestro juego y las columnas empiezan a moverse.
			p_estado<=Start;
			p_marcador <='0';
			p_direc <= direc;
		else 
			p_estado<=reposo;
			p_direc <= direc;
			p_marcador <='0';
		end if;	
		
	when Start =>
		p_columnaX<=columnaX; --Actualizamos la posición x cada refresco de pantalla
		p_direc <= direc;
		p_marcador <='0';
		if (refresh='1') then
				p_estado <= Act_ColumnaX;
				p_marcador <='0';
				p_direc <= direc;
		else 
				p_estado<=estado;
				p_marcador <='0';
				p_direc <= direc;
		end if;
		
	when Act_ColumnaX => --En este estados estamos actualizando la posición de la columna
	if (muerte='0') then --Cuando no se ha producido la colisión
		if (ColumnaX<100) then --Fin barrido columna 
			p_estado <= Act_Direc; --Voy al estado de Act_Direct ya que en el 
			p_marcador <='0';
			p_direc <= direc;
		else --Reducimos la posición del eje x de la columna y volvemos al estado inicial 
			p_ColumnaX<=ColumnaX-3; --Velocidad de columna
			p_estado <= Start;
			p_direc <= direc;
			p_marcador <='0';
		end if;
	else --Cuando se ha producido muerte congelamos la posición de la columna
		p_ColumnaX <= ColumnaX;
		p_estado <= Act_ColumnaX;
		p_direc <= direc;
		p_marcador <='0';
	end if;
		
	when Act_Direc => --Incremento la dirección cuando voy a generar una nueva columna
		p_direc <= direc+1;
		p_estado <= Nueva_Columna;
		p_marcador <='0';
	
	when Nueva_Columna =>
		p_ColumnaX <= "1001011111"; 		
		p_estado <= Start;
		p_direc <= direc;
		p_marcador <='1'; --Incremento en 1 el marcador ya que cuando generamos una nueva columna el pájaro acaba de atravesar la anterior. 
	
	when others =>
		p_ColumnaX <= ColumnaX;
		p_estado <= Reposo;
		p_direc <= direc;
		p_marcador <='0';
end case;

end process;



sinc: process(reset,clk) is
begin 
	if(reset='1') then --Cuando reseteo vuelvo a la posicion de partida
		estado<=reposo;
		direc <= "000"; 
		columnaX<=pos_inicial;
		marcador<='0';
	elsif (rising_edge(clk)) then --Actualizo las señales de forma síncrona
		estado<=p_estado;
		direc<=p_direc;
		columnaX<=p_columnaX;
		marcador<=p_marcador;
	end if;
end process;

--Dibujamos la columna mediante un bloque dibuja combinacional 
dibuja_col: process (eje_x, eje_y, gapY,columnaX)
begin
	if ((unsigned(eje_x)>=columnaX and unsigned(eje_x)<columnaX+42) and (unsigned(eje_y)<unsigned(GapY)-40 or unsigned(eje_y)>unsigned(GapY)+160)) then --Límites geométricos de la columna
		RED <= "000";
		GRN <= "110";
		BLUE <= "00";
	--Limite geometrico boca de la columna:
	elsif ((unsigned(eje_x)>=columnaX-12 and unsigned(eje_x)<columnaX+54) and ((unsigned(eje_y)<unsigned(GapY) and unsigned(eje_y)>unsigned(GapY)-40) or ((unsigned(eje_y)>unsigned(GapY)+120) and unsigned(eje_y)<unsigned(GapY)+160))) then
		RED <= "000";
		GRN <= "110";
		BLUE <= "00";
	--Todo lo que no sea columnas le asigno el color negro
	else
		RED <= "000";
		GRN <= "000";
		BLUE <= "00";
	end if;

end process;

end Behavioral;

