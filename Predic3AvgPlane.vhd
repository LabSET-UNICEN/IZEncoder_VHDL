-------------------------------------------------------------------------------
--
--  This file is part of the ImageZero Encoder.
--
--  Description:  
--    predict3AvgPlane component of IZ Encoder
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

entity Predictor3AvgPlane is
    generic (N: integer:= 8);
    port ( x, y, xy : in std_logic_vector (N-1 downto 0);
            p : out std_logic_vector (N-1 downto 0));
end Predictor3AvgPlane;

architecture Behavioral of Predictor3AvgPlane is

    signal x3,y3: std_logic_vector(N downto 0);
    signal xy2: std_logic_vector(N downto 0);
    
    signal r_par: std_logic_vector(N+1 downto 0);
    
    signal r_par2: std_logic_vector(N+1 downto 0);
        
begin

        x3 <= (x&'0') + x; -- 3x (N+1bits)
        y3 <= (y&'0') + y; -- 3y (N+1 bits)
        r_par <= ('0'&x3) + y3 + x"02"; -- (N+2 bits)
   
        xy2 <= (xy&'0'); -- 2xy
        
        r_par2 <= r_par - xy2; 
        -- 3x + 3y +2 - 2xy  

        p <= r_par2(N+1 downto 2) ; -- (3x + 3y - 2xy + 2) >>2 
        
end Behavioral;
