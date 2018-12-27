------------------------------------------------------------------------------
--
--  This file is part of the ImageZero Encoder.
--
--  Description:  
-- 		Coder component with priorities 
-- 
-- 		N: input size (depends on the selected predictor) 
-- 		For predict3avgplane, N=9
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

entity PriorityEncoder is
    generic (N:integer:=9);
    port ( i : in std_logic_vector(N-1 downto 0);
           o : out std_logic_vector (3 downto 0));
end PriorityEncoder;

architecture Behavioral of PriorityEncoder is

begin

   ECondPredictAvgPlane:   if (N=9) generate --  predict3avgplane 
                                o <=  x"9" when (i(8)='1') else 
                                      x"8" when (i(7)='1') else
                                      x"7" when (i(6)='1') else
                                      x"6" when (i(5)='1') else
                                      x"5" when (i(4)='1') else
                                      x"4" when (i(3)='1') else
                                      x"3" when (i(2)='1') else
                                      x"2" when (i(1)='1') else
                                      x"1" when (i(0)='1') else
                                      x"0";
                            end generate;
    
    ECondPredictRest:   if (N/=9) generate -- others predictors must be calculated
                            o <= x"0";
                        end generate;    
    
end Behavioral;
