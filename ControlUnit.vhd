-------------------------------------------------------------------------------
--
--  This file is part of the ImageZero Encoder.
--
--  Description:  
--    Control Unit of IZ Encoder
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

entity ControlUnit is
    generic ( height:integer:=5; Width:integer:=5);
    Port ( clk, rst : in std_logic;
           start: in std_logic;
           rst_cx: out std_logic;
           en_regs: out std_logic;
           done: out std_logic;
           cnt_x: out std_logic_vector (log2sup(Height)-1 downto 0);
           cnt_y: out std_logic_vector (log2sup(Width)-1 downto 0));
end ControlUnit;

architecture Behavioral of ControlUnit is

    -- Signals for image addresses 
    signal next_cntx, reg_cntx: std_logic_vector(log2sup(Height)-1 downto 0);
    signal next_cnty, reg_cnty: std_logic_vector(log2sup(Width)-1 downto 0);
    
	-- Counters for pixels signals
	signal rst_cntx, inc_cntx: std_logic;
	signal rst_cnty, inc_cnty: std_logic;
	
	type states is (inactive, do_proc, gen_done);
	signal next_state, state : states;

begin


    next_cntx <= (others => '0') when (rst_cntx='1') else
                 (reg_cntx+1) when (inc_cntx='1')else reg_cntx;   


    next_cnty <= (others => '0') when (rst_cnty='1') else
                 (reg_cnty+1) when (inc_cnty='1')else reg_cnty;   

    preg: process (clk, rst)
    begin
        if (rst='1') then
            state <= inactive;
            reg_cntx <= (others => '0');
            reg_cnty <= (others => '0');
        elsif (rising_edge(clk)) then
            state <= next_state;
            reg_cntx <= next_cntx;
            reg_cnty <= next_cnty;
        end if; 
    end process;
    

    state_mach: process(start, state, reg_cntx, reg_cnty)
	begin
	     rst_cntx <= '0';
	     rst_cnty <= '0';
	     inc_cntx <= '0';
	     inc_cnty <= '0';
	     rst_cx <= '0';
	     en_regs <= '0';
	     next_state <= state;	     
	     case state is
	       when inactive =>
	           if (start='1') then
	               rst_cnty <= '1';
	               rst_cntx <= '1';
	               rst_cx <= '1';
	               en_regs <= '1';
	               next_state <= do_proc;
	           end if;
	       when do_proc =>
	           en_regs <= '1';
	           if (reg_cnty=Width-1) then
                   rst_cnty <= '1';
                   if (reg_cntx=Height-1) then
                       rst_cntx <= '1';
                       next_state <= gen_done;
                   else
                       inc_cntx <= '1';     
                   end if;
               else 
                    inc_cnty <= '1';
               end if;
            when gen_done => 
                if (start='1') then
                    next_state <= do_proc;
                    rst_cnty <= '1';
                    rst_cntx <= '1';
                    rst_cx <= '1';
                    en_regs <= '1';
	            else
	                next_state <= inactive;
	            end if;   
	       when others =>
	     end case;  
	    end process;

    done <= '1' when (state = gen_done) else '0';
    cnt_x <= reg_cntx;
    cnt_y <= reg_cnty;

end Behavioral;
