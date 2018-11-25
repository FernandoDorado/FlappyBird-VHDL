library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GenSprites is

    Port ( eje_x : in  STD_LOGIC_VECTOR (9 downto 0);
           eje_y : in  STD_LOGIC_VECTOR (9 downto 0);
           data : in  STD_LOGIC_VECTOR (2 downto 0);
			  posy: in STD_LOGIC_VECTOR (9 downto 0);
			  direc : out STD_LOGIC_VECTOR (9 downto 0);
           RED : out  STD_LOGIC_VECTOR (2 downto 0);
           GRN : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE : out  STD_LOGIC_VECTOR (1 downto 0));
			  
end GenSprites;

architecture Behavioral of GenSprites is

signal ejeyaux,ejexaux: std_logic_vector(4 downto 0);

begin

ejeyaux<=std_logic_vector(unsigned(eje_y(4 downto 0))-unsigned(posy(4 downto 0))); --Creamos ejes auxiliares cuyo origen es el punto donde empieza el sprite
ejexaux<=std_logic_vector(unsigned(eje_x(4 downto 0))-191);				  --Con cada pixel aumentamos una dirección hasta llegar a las esquinas del final que sería la última dirección

direc<=(ejeyaux(4 downto 0) & ejexaux(4 downto 0)); 

dibujaCoe:process(eje_x,eje_y,posy,data) 
begin 
	if((unsigned(eje_x)>191 and unsigned(eje_x)<223) and (unsigned(eje_y)>unsigned(posy) and unsigned(eje_y)<unsigned(posy)+32)) then
		RED(0)<=data(2);
		RED(1)<=data(2);
		RED(2)<=data(2);
		GRN(0)<=data(1);
		GRN(1)<=data(1);
		GRN(2)<=data(1);
		BLUE(0)<=data(0);
		BLUE(1)<=data(0);
	else 
	   RED <= "000";
	   GRN <= "000";
	   BLUE <= "00";	
	end if;
end process;

end Behavioral;

