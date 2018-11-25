library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity BIRD is
    Port ( reset: in STD_LOGIC;
			  clk: in STD_LOGIC;
			  refresh: in STD_LOGIC;
			  button : in STD_LOGIC;
			  muerte : in STD_LOGIC;
			  posY_bird : out STD_LOGIC_VECTOR (9 downto 0));
end BIRD;

architecture Behavioral of BIRD is

signal arriba, p_arriba : std_logic;
signal vY, p_vY : integer; 
constant gravity : integer :=1;	
constant posX : unsigned (9 downto 0) :="0010111111"; --Esta es la posición de partida de nuestro pajaro
signal p_posY, posY : unsigned (9 downto 0);
type TipoEstado is (Start, Reposo,subir, ActualizarPosY, ActualizarVy); 
signal estado, p_estado : TipoEstado;

begin
posY_bird <= std_logic_vector(posY); 
comb : process (estado, refresh, button, posY, vY, arriba,muerte) --Hacemos maq. de estados para realizar el movimiento del pajaro. 
begin
	--Actualizo las variables--
	p_estado <= estado;
	p_arriba <= arriba;
	p_posy<=posY;
	p_vY<=Vy;	
	
	case estado is
		when reposo => --Estado en el que el juego se encuentra detenido. Para iniciar nuestro juegos pulsamos el botón. 
			p_posy<=posY;
			p_vY<=Vy;
			if(button='1') then
				p_estado<=Start;
			else 
				p_estado<=reposo;
			end if;			
			
		when start => --En este estado comienza nuestro juego: 
			p_posy<=posY;
			p_vY<=Vy;		
			if (refresh='1') then
				p_estado <= ActualizarPosY; --actualizo la Posición del eje Y cuando se produce un refresco de pantalla
			elsif (button='1' AND arriba='0') then --Si pulsamos el boton y no estamos subiendo con el pájaro vamos al estado para iniciar la trayectoria de subida.
				p_estado <= subir;
			else 
				p_estado <= estado;
			end if;
			
		when subir => --En este estado entramos cuando hemos pulsado el boton y aumentaremos la velocidad del pajaro
			p_arriba <= '1';
			p_vY <= 10; 
			p_estado <= Start; --Volvemos al inicio del juego 
			
			
		when ActualizarPosY =>
		if (muerte='0') then  --Si no se ha producido la colisión seguimos jugando y actualizamos las posiciones
			if (arriba='1') then
				p_posY <= posY-vY;  --Cuando subo aumento la posicion (El eje y aumenta hacia abajo)
			else
				p_posY <= posY+vY;  --Reduzco la posición
			end if;
			   p_estado <= ActualizarVy;
		else 
			p_posY <= posY; --Congelamos el juego cuando se ha producido la colisión
			p_estado <= ActualizarPosY; --Mantengo posY
		end if;
			
		when ActualizarVy =>  --Actualizo la velocidad del pajaro
			if (arriba='1') then --Cuando quiero que suba el pajaro(He pulsado el boton)
				if (vY > gravity) then 
					p_vY <= vY-gravity; --Desaceleramos el pájaro
				else 
					p_arriba<='0';  
				end if;
			else
				   p_vY<=vY+gravity; --Aceleramos el pájaro cuando no pulsemos el botón
			end if;	
			p_estado <= Start; --Volvemos al estado inicial
			
		when others =>
			p_posy<=posY;
			p_vY<=Vy;
			p_estado<=Start;
			p_arriba<=arriba;
	end case;
end process;			


--Actualizamos las variables
sinc: process (reset,clk) is 
begin
	if (reset='1') then
		estado <= reposo;
		vY<=0;
		posY<="0011111010"; --Posición vertical en la que comienza el pájaro. 
		arriba<='0';
	elsif (rising_edge(clk)) then --Actualizamos las variables de forma síncrona. 
		estado <= p_estado;
		vY <= p_vY;
		posy <= p_posY;
		arriba <= p_arriba;
	end if;
end process;

end Behavioral;

