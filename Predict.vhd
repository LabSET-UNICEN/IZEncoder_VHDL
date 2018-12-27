-------------------------------------------------------------------------------
--
--  This file is part of the ImageZero Encoder.
--
--  Description:  
--    Predict of IZ Encoder
--
-- 	To use predict3avgplane -> T_Predict=0;
-- 	To use predict3alpha -> T_Predict=1;
-- 	To use predict3avg -> T_Predict=2;
--  To use predict3med -> T_Predict=3;
--  To use predict3plane -> T_Predict=4;
--
--  Author(s): 	Martín Vázquez, martin.o.vazquez@gmail.com
--	Date: 12/12/2018	
--	
--	  
--
-------------------------------------------------------------------------------
--
--  Copyright (c) 2018 LabSET
--
--  This source file may be used and distributed without restriction provided
--  that this copyright statement is not removed from the file and that any
--  derivative work contains the original copyright notice and the associated
--  disclaimer.
--
--  This source file is free software: you can redistribute it and/or modify it
--  under the terms of the GNU Lesser General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or (at your
--  option) any later version.
--
--  This source file is distributed in the hope that it will be useful, but
--  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
--  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
--  for more details.
--
--  You should have received a copy of the GNU Lesser General Public License
--  along with the ImageZero Encoder.  If not, see http://www.gnu.org/licenses
--
------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.my_package.all;

entity Predict is
    generic (N: integer:= 8; T_Predict:integer:=1);
    port ( mode_predict : in std_logic_vector (1 downto 0);
           x, y, xy : in std_logic_vector (N-1 downto 0);
           p : out std_logic_vector (N-1 downto 0));
end Predict;

architecture Behavioral of Predict is


    component Predictor3AvgPlane 
        generic (N: integer:= 8);
        port ( x, y, xy : in std_logic_vector (N-1 downto 0);
                p : out std_logic_vector (N-1 downto 0));
    end component;

    component Predictor3Alpha 
        generic (N: integer:= 8);
        port ( x, y, xy : in std_logic_vector (N-1 downto 0);
                p : out std_logic_vector (N-1 downto 0));
    end component;

    component Predictor3Avg 
        generic (N: integer:= 8);
        port ( x, y, xy : in std_logic_vector (N-1 downto 0);
                p : out std_logic_vector (N-1 downto 0));
    end component;
    
    component Predictor3Med 
        generic (N: integer:= 8);
        port ( x, y, xy : in std_logic_vector (N-1 downto 0);
                p : out std_logic_vector (N-1 downto 0));
    end component;

    component Predictor3Plane 
        generic (N: integer:= 8);
        port ( x, y, xy : in std_logic_vector (N-1 downto 0);
                p : out std_logic_vector (N-1 downto 0));
    end component;

    signal pred_rest: std_logic_vector(N-1 downto 0);
     

begin

   ECondPredAvgPl: if (T_Predict=0) generate
            EPredictRestA_Pl: Predictor3AvgPlane generic map (N => N)
                                        port map ( x => x, y => y, 
                                                   xy => xy, p => pred_rest);
   end generate;                                                

   ECondPredAlpha: if (T_Predict=1) generate
            EPredictRestAlpha: Predictor3Alpha generic map (N => N)
                                        port map ( x => x, y => y, 
                                                   xy => xy, p => pred_rest);
   end generate; 
   
   ECondPredAvg: if (T_Predict=2) generate
               EPredictRestAvg: Predictor3Avg generic map (N => N)
                                           port map ( x => x, y => y, 
                                                      xy => xy, p => pred_rest);
   end generate; 
   
   ECondPredMed: if (T_Predict=3) generate
               EPredictRestMed: Predictor3Med generic map (N => N)
                                           port map ( x => x, y => y, 
                                                      xy => xy, p => pred_rest);
   end generate; 

   ECondPredPlane: if (T_Predict=4) generate
               EPredictRestPlane: Predictor3Plane generic map (N => N)
                                           port map ( x => x, y => y, 
                                                      xy => xy, p => pred_rest);
   end generate; 
        
   p <= (others => '0') when (mode_predict="00") else 
         x when (mode_predict="01") else 
         y when (mode_predict="10") else
         pred_rest; -- para el resto de los casos (mode_predict="11")
        

end Behavioral;
