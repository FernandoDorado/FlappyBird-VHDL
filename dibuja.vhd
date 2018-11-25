library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DIBUJA is
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
			  muerte : OUT STD_LOGIC);
end DIBUJA;

architecture Behavioral of DIBUJA is

signal muerto, p_muerte : std_logic;

begin
muerte <= muerto;

colision : process (posY_bird,RED_bird,GRN_col,GRN_col2,muerto)
begin

	if(((RED_bird and GRN_col)/="000") or ((RED_bird and GRN_col2)/="000"))then --Cuando se produce esta condición detectamos la colisión del pajaro con alguna de las 2 columnas.  
		p_muerte<='1';
	elsif (unsigned(posY_bird)<6 or unsigned(posY_bird)>447) then --Entramos cuando el pájaro sale fuera de los límites del escenario. 
		p_muerte<='1';
	else
		p_muerte<=muerto;
	end if;
	

end process;

--En este bloque combinacional elegimos que pintar en cada momento
comb: process (eje_x,eje_y,RED_col,BLUE_col,GRN_col,RED_col2,posY_bird,BLUE_bird,RED_bird,GRN_bird,GRN_col2,BLUE_col2) 
begin

	--Representamos el RGB del pajaro sin el fondo del pájaro. Los valores del RGB de nuestro pajaro en las condiciones estan elegidos dado el sprite del pájaro para que no se obvie ningún color
	if (unsigned(eje_x)>191 and unsigned(eje_x)<223 and unsigned(eje_y)>unsigned(posY_bird) and unsigned(eje_y)<unsigned(posY_bird)+32 and BLUE_bird /="11" ) then 
		RED<=RED_bird;
		BLUE<=BLUE_bird;
		GRN<=GRN_bird;	
	--Usamos esta línea auxiliar de representación del pájaro para que nos pinte tambíen el color blanco de su sprite; 
	elsif (unsigned(eje_x)>191 and unsigned(eje_x)<223 and unsigned(eje_y)>unsigned(posY_bird) and unsigned(eje_y)<unsigned(posY_bird)+32 and RED_bird="111" and GRN_bird="111") then  
		RED<=RED_bird;
		BLUE<=BLUE_bird;
		GRN<=GRN_bird;	
	--Como nuestras columnas son verdes, si el GRN_col>0 (es diferente de negro) el RGB de salida será el de nuestras columnas. 
	elsif(unsigned(GRN_col)>0)then
		RED<=RED_col;
		BLUE<=BLUE_col;
		GRN<=GRN_col;	
	elsif(unsigned(GRN_col2)>0)then
		RED<=RED_col2;
		BLUE<=BLUE_col2;
		GRN<=GRN_col2;	
	else --Todo lo que no sea columnas/pájaro lo pinto como el fondo de nuestro juego. 
		RED<="001";
		BLUE<="11";
		GRN<="100";
	end if; 
	
end process;

--Bloque síncrono de actualización de variables. 
sinc: process (reset,clk) is
begin
	if (reset='1') then
		muerto <= '0';
	elsif (rising_edge(clk)) then
		muerto <= p_muerte;
	end if;
end process;

end Behavioral;

