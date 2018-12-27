------------------------------------------------------------------------------
--
--  This file is part of the ImageZero Encoder.
--
--  Description:  
--    dCount components definition
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

entity Table_Dcount is
    Port ( i : in std_logic_vector (7 downto 0);
           o : out std_logic_vector (3 downto 0));
end Table_Dcount;

architecture Behavioral of Table_Dcount is

    type  mtable_dcount is array (0 to 255) of std_logic_vector (3 downto 0);
    
    signal table_dc: mtable_dcount:= (
                    x"1",x"3",x"2",x"5",x"5",x"6",x"6",x"6",
                    x"6",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"3",x"2",x"2",x"2",x"4",x"6",x"6",x"6",
                    x"6",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"4",x"2",x"2",x"2",x"3",x"6",x"6",x"6",
                    x"6",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"6",x"4",x"2",x"2",x"2",x"3",x"6",x"6",
                    x"6",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    
                    x"6",x"6",x"3",x"2",x"2",x"2",x"4",x"6",
                    x"6",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"6",x"6",x"4",x"2",x"2",x"2",x"3",x"6",
                    x"6",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"6",x"6",x"6",x"4",x"2",x"2",x"2",x"3",
                    x"6",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"6",x"6",x"6",x"6",x"3",x"2",x"2",x"2",
                    x"4",x"0",x"0",x"0",x"0",x"0",x"0",x"0",   
                    
                    x"6",x"6",x"5",x"5",x"5",x"3",x"2",x"2",
                    x"2",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",
                    x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0");
begin

    o <= table_dc(conv_integer(i));
    
end Behavioral;
