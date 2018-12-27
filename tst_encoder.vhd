------------------------------------------------------------------------------
--
--  This file is part of the ImageZero Encoder.
--
--  Description:  
--    testbench for ImageZero Encoder
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

use IEEE.STD_LOGIC_TEXTIO.ALL; 
use std.textio.ALL;

entity tst_encoder is
--  Port ( );
end tst_encoder;

architecture Behavioral of tst_encoder is
 
    component encoder_IZ 
        generic (M_pixel: integer:=24; N_comp:integer:=8; N_comp_add:integer:=1; Height:integer:=5;
                 Width:integer:=5; T_predict:integer:=0);
        port ( clk, rst : in std_logic;
               start: in std_logic;
               v_pix: in std_logic_vector(M_pixel-1 downto 0);
               done: out std_logic; 
               db_out: out std_logic_vector(7 downto 0);
               dcount_out: out std_logic_vector(3 downto 0);
               nl_out: out std_logic_vector(3 downto 0);
               r_out, g_out, b_out : out std_logic_vector (N_comp-1 downto 0)); 
    end component; 
    
    constant M_pixel:integer:=24;
    constant N_comp:integer:=8;
    constant N_comp_add: integer:=1;
    constant Height:integer:=10;
    constant Width:integer:=10;
    constant T_predict:integer:=0;
     
-- inputs
    signal clk, rst, start: std_logic;
    signal v_pix:  std_logic_vector(M_pixel-1 downto 0);

-- outputs
    signal done: std_logic;


    signal db_out: std_logic_vector(7 downto 0);
    signal dcount_out:  std_logic_vector(3 downto 0);
    signal nl_out:  std_logic_vector(3 downto 0);
    signal r_out, g_out, b_out :  std_logic_vector (N_comp-1 downto 0); 
    
     
     
begin

    uut: encoder_IZ 
            generic map (M_pixel => M_pixel, N_comp => N_comp, N_comp_add => N_comp_add, 
                            Height => Height, Width => Width, T_predict => T_predict)
            port map (clk => clk, rst => rst, start => start, v_pix => v_pix,
                       done => done, 
                       db_out => db_out, dcount_out => dcount_out,
                       nl_out => nl_out, r_out => r_out, 
                       g_out => g_out, b_out => b_out); 
                       --v_out => v_out);                
    
    pclk: process 
    begin
        clk <= '0';
        wait for 20 ns;
        clk <= '1';
        wait for 20 ns;
    end process;

    prst: process
    begin 
        rst <= '0';
        wait for 5 ns;
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait;
    end process;

    pstart: process
    begin 
        start <= '0';
        wait for 45 ns;
        start <= '1';
        wait for 20 ns;
        start <= '0';
        wait;
    end process;

   ppix: process
        file in_file : text is in "D:/input_iz";
        variable  rd_line : line;
        variable rd_r, rd_g, rd_b: std_logic_vector(N_comp-1 downto 0);
        
        file out_file : TEXT open write_mode is "D:/output_iz";
        variable separator, wr_line1, wr_line2, wr_line3, wr_line4 : line;
           
           
  
   begin 

        wait for 35 ns;
     
        while (not endfile (in_file)) loop
           
           readline (in_file, rd_line);
           
           hread(rd_line, rd_r);
           hread(rd_line, rd_g);
           hread(rd_line, rd_b);
                               
           v_pix(M_pixel-1 downto 2*N_comp) <= rd_r;
           v_pix(2*N_comp-1 downto N_comp) <= rd_g;
           v_pix(N_comp-1 downto 0) <= rd_b;
                                          
           wait for 40 ns;
           
           -- aca ya puedo escribir
           write(separator,string'("---------"));
           
           write(wr_line1,db_out);
           write(wr_line1,string'("    "));
           write(wr_line1,dcount_out);
           writeline(out_file,wr_line1);
           
           write(wr_line2,r_out);
           write(wr_line2,string'("    "));
           write(wr_line2,nl_out);
           writeline(out_file,wr_line2);
                     
           write(wr_line3,g_out);
           write(wr_line3,string'("    "));
           write(wr_line3,nl_out);
           writeline(out_file,wr_line3);
          
           write(wr_line4,b_out);
           write(wr_line4,string'("    "));
           write(wr_line4,nl_out);
           writeline(out_file,wr_line4);
           writeline(out_file,separator);
           
        end loop;
       
        wait;
    end process;


end Behavioral;
