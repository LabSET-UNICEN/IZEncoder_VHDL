------------------------------------------------------------------------------
--
--  This file is part of the ImageZero Encoder.
--
--  Description:  
-- 		N bits register 
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

entity reg is
    generic (N: integer:= 8);
    Port ( clk, rst, en : in std_logic;
           i: in std_logic_vector(N-1 downto 0); 
           q : out std_logic_vector (N-1 downto 0));
end reg;

architecture Behavioral of reg is

signal r: std_logic_vector(N-1 downto 0);

begin

    process (clk, rst)
    begin
        if (rst='1') then
            r <= (others => '0');
        elsif rising_edge(clk) then
            if (en='1')  then
                r <= i; 
            end if;
        end if;
    end process;

    q<= r;
    
end Behavioral;
