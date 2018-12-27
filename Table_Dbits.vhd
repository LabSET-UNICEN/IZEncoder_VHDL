------------------------------------------------------------------------------
--
--  This file is part of the ImageZero Encoder.
--
--  Description:  
--    dBits components definition
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

entity Table_Dbits is
    Port ( i : in std_logic_vector (7 downto 0);
           o : out std_logic_vector (7 downto 0));
end Table_Dbits;

architecture Behavioral of Table_Dbits is

    type  mtable_dbits is array (0 to 255) of std_logic_vector (7 downto 0);
    
    signal table_db: mtable_dbits:= (
                x"00",x"06",x"02",x"1c",x"1d",x"3c",x"3d",x"3e",
                x"3f",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"06",x"00",x"01",x"02",x"0e",x"3c",x"01",x"3e",
                x"3f",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"0e",x"00",x"01",x"02",x"06",x"3c",x"3d",x"3e",
                x"3f",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"3c",x"0e",x"00",x"01",x"02",x"06",x"3d",x"3e",
                x"3f",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"3c",x"3d",x"06",x"00",x"01",x"02",x"0e",x"3e",
                x"3f",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"3c",x"3d",x"0e",x"00",x"01",x"02",x"06",x"3e",
                x"3f",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"3c",x"3d",x"3e",x"0e",x"00",x"01",x"02",x"06",
                x"3f",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"3c",x"3d",x"3e",x"3f",x"06",x"00",x"01",x"02",
                x"0e",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"3e",x"3f",x"1c",x"1d",x"1e",x"06",x"00",x"01",
                x"02",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00");

begin

    o <= table_db(conv_integer(i));
    
end Behavioral;
