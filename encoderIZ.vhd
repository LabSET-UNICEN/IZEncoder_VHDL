-------------------------------------------------------------------------------
--
--  This file is part of the ImageZero Encoder.
--
--  Description:  
--    Top level of IZ Encoder
--
--  M_pixel: pixel depth in bits(includes the components R, G, B)
--  N_comp: size of pixel component,  N_Comp*3 = M_Pixel
--
-- N_comp_add: number of added bits for pixel preocessing (depends on the predictor used)
-- For predict3avgplane, N_comp_add is 1, this value is always less than 8
--
-- Width: Image Width (in pixels)
-- Height: Image Height (in pixels)
-- T_Predict: Pixel predictor 
--
-- To use predict3avgplane -> T_Predict=0;
-- To use predict3alpha -> T_Predict=1;
-- To use predict3avg -> T_Predict=2;
-- To use predict3med -> T_Predict=3;
-- To use predict3plane -> T_Predict=4;
--
--  Author(s): 	Martín Vázquez, martin.o.vazquez@gmail.com
--	Date: 12/12/2018	
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

entity encoder_IZ is
    generic (M_pixel: integer:=24; N_comp:integer:=8; N_comp_add:integer:=1;
             height:integer:=512; Width:integer:=512; T_predict: integer:=0);
    port ( clk, rst : in std_logic;
           start: in std_logic;
           v_pix: in std_logic_vector(M_pixel-1 downto 0);
           done: out std_logic;
            
db_out: out std_logic_vector(7 downto 0);
dcount_out: out std_logic_vector(3 downto 0);
nl_out: out std_logic_vector(3 downto 0);
r_out, g_out, b_out : out std_logic_vector (N_comp-1 downto 0));  

          
end encoder_IZ;


architecture Behavioral of encoder_IZ is

    component ControlUnit 
        generic ( height:integer:=5; Width:integer:=5);
        Port ( clk, rst : in std_logic;
               start: in std_logic;
               rst_cx: out std_logic;
               en_regs: out std_logic;
               done: out std_logic;
               cnt_x: out std_logic_vector (log2sup(height)-1 downto 0);
               cnt_y: out std_logic_vector (log2sup(Width)-1 downto 0));
    end component;
    
    component reg 
        generic (N: integer:= 8);
        Port ( clk, rst, en : in std_logic;
               i: in std_logic_vector(N-1 downto 0); 
               q : out std_logic_vector (N-1 downto 0));
    end component;
    
    component Predict 
        generic (N: integer:= 8; T_predict:integer:=0);
        port ( mode_predict : in std_logic_vector (1 downto 0);
               x, y, xy : in std_logic_vector (N-1 downto 0);
               p : out std_logic_vector (N-1 downto 0));
    end component;
    
    component PriorityEncoder 
        generic (N:integer:=9);
        port ( i : in std_logic_vector(N-1 downto 0);
               o : out std_logic_vector (3 downto 0));
    end component;
    
    component Table_Dbits 
        Port ( i : in std_logic_vector (7 downto 0);
               o : out std_logic_vector (7 downto 0));
    end component;

    component Table_Dcount 
        Port ( i : in std_logic_vector (7 downto 0);
               o : out std_logic_vector (3 downto 0));
    end component;


    -- to set N_comp_add leading 0's 
    signal  zeros: std_logic_vector(N_comp_add-1 downto 0);
     
    -- control signals
    signal en_regs: std_logic;
    signal rst_cx: std_logic;

    -- signals to determine the pixel position to process
    signal cnt_x: std_Logic_vector(log2sup(height)-1 downto 0);
    signal cnt_y: std_Logic_vector(log2sup(Width)-1 downto 0); 

    -- predictor type
    signal mode_predict: std_logic_vector(1 downto 0);

    -- corresponding to predictors
    signal predict_r, predict_g, predict_b: std_logic_vector(N_comp+N_comp_add-1 downto 0);

    -- pixeles con procesamiento de predictores
    signal pix_sub_r, pix_sub_g, pix_sub_b: std_logic_vector(N_comp+N_comp_add-1 downto 0);

    -- forward transform pixels
    signal pix_fwt_r, pix_fwt_g, pix_fwt_b: std_logic_vector(N_comp+N_comp_add-1 downto 0);

    --  unsigned pixels
    signal pix_us_r, pix_us_g, pix_us_b: std_logic_vector(N_comp+N_comp_add-1 downto 0);
    
    -- nls in algorithm  
    signal nl, nl_r, nl_g, nl_b, nl_rg:std_logic_vector(3 downto 0); -- va de 0 a 15, 
        
    signal next_cx, reg_cx: std_logic_vector(7 downto 0);

    signal dbits: std_logic_vector(7 downto 0);
    signal dcount: std_logic_vector(3 downto 0);
    
    
    type Tline_pixels is array(0 to Width+2) of std_logic_vector(N_comp+N_comp_add-1 downto 0);
    signal pixels_r, pixels_g, pixels_b: Tline_pixels;

begin

    uCtrl: ControlUnit generic map (height => height, Width => Width)
                        port map (clk => clk, rst => rst, start => start, 
                                   rst_cx => rst_cx, en_regs => en_regs, done => done, 
                                   cnt_x => cnt_x, cnt_y => cnt_y); 


   
    -- ======================== 
    -- FIFO generation of latests Width+1 pixels and the current
    -- ============
    
    zeros <= (others => '0');
    
    pixels_r(0) <= (zeros&v_pix(M_pixel-1 downto 2*N_comp));
    pixels_g(0) <= (zeros&v_pix(2*N_comp-1 downto N_comp));
    pixels_b(0) <= (zeros&v_pix(N_comp-1 downto 0));
    
    GenLinePixels: for I in 0 to Width+1 generate  -- va desde 0 a Width+1

        eregRed: reg generic map (N => N_comp+N_comp_add)
                     port map ( clk => clk, rst => rst, 
                          en => en_regs, i => pixels_r(I), q =>pixels_r(I+1));
        
        eregGreen: reg generic map (N => N_comp+N_comp_add)
                       port map ( clk => clk, rst => rst, 
                        en => en_regs, i => pixels_g(I), q =>pixels_g(I+1));
              
        eregBlue: reg generic map (N => N_comp+N_comp_add)
                     port map ( clk => clk, rst => rst, 
                     en => en_regs, i => pixels_b(I), q =>pixels_b(I+1));
                                                              
    end generate;
    
    -- ========================
    -- Prediction
    -- ========================
        -- position analysis          
        mode_predict <= "00" when (cnt_x=0 and cnt_y=0) else
                        "01" when (cnt_x=0) else
                        "10" when (cnt_y=0) else
                        "11"; -- caso cnt_x /= 0 y cnt_y /= 0      


    -- component predictions
        ePredictR: Predict generic map (N => N_comp+N_comp_add, T_predict => T_predict)
                    port map (mode_predict => mode_predict, 
                            x =>  pixels_r(2), y => pixels_r(Width+1),
                            xy => pixels_r(Width+2), p => predict_r);
                
        ePredictG: Predict generic map (N => N_comp+N_comp_add)
                    port map (mode_predict => mode_predict, 
                            x =>  pixels_g(2), y => pixels_g(Width+1),
                            xy => pixels_g(Width+2), p => predict_g);
                                
        ePredictB: Predict generic map (N => N_comp+N_comp_add)
                    port map (mode_predict => mode_predict, 
                            x =>  pixels_b(2), y => pixels_b(Width+1),
                            xy => pixels_b(Width+2), p => predict_b);
            
   
    
   
    pix_sub_r <= pixels_r(1) - predict_r;
    pix_sub_g <= pixels_g(1) - predict_g;
    pix_sub_b <= pixels_b(1) - predict_b;
	
	-- forward transform
    pix_fwt_r <= pix_sub_r;
    pix_fwt_g <= pix_sub_g - pix_sub_r;
    pix_fwt_b <= pix_sub_b - pix_sub_r;
   
    -- to unsigned
    pix_us_r <= (pix_fwt_r(N_comp+N_comp_add-2 downto 0)&'0') when (pix_fwt_r(N_comp+N_comp_add-1)='0') else 
                --((not (pix_fwt_r(N_comp-2 downto 0))&'0')+1);
                (not (pix_fwt_r(N_comp+N_comp_add-2 downto 0))&'1');
    
    pix_us_g <= (pix_fwt_g(N_comp+N_comp_add-2 downto 0)&'0') when (pix_fwt_g(N_comp+N_comp_add-1)='0') else 
                (not (pix_fwt_g(N_comp+N_comp_add-2 downto 0))&'1');
                    
    pix_us_b <= (pix_fwt_b(N_comp+N_comp_add-2 downto 0)&'0') when (pix_fwt_b(N_comp+N_comp_add-1)='0') else 
                (not (pix_fwt_b(N_comp+N_comp_add-2 downto 0))&'1');

                                                        
    -- nl calculation
    EEncR: PriorityEncoder generic map (N => N_comp+N_comp_add)
                            port map ( i => pix_us_r, o => nl_r);
        
    EEncG: PriorityEncoder generic map (N => N_comp+N_comp_add)
                           port map ( i => pix_us_g, o => nl_g);
                   
    EEncB: PriorityEncoder generic map (N => N_comp+N_comp_add)
                           port map ( i => pix_us_b, o => nl_b);
                           
    nl_rg <=    nl_r when (nl_r>nl_g) else
                nl_g;
                
    nl <=   nl_b when (nl_b>nl_rg) else
            nl_rg;                                   
    
    -- cx calculation
    next_cx <= x"77" when (rst_cx='1') else
                (reg_cx(3 downto 0)&nl);
                
    Eregister_cx: reg generic map (N => 8)
                        port map (clk => clk, rst=> rst,  
                                    en => en_regs, i => next_cx, q => reg_cx);            


   
     Etable_db: Table_Dbits port map (i => next_cx, o => dbits);            

     Etable_dcount: Table_Dcount port map (i => next_cx, o => dcount);            


	db_out <= dbits;
	dcount_out <= dcount;
   
	r_out <=  pix_us_r(N_comp-1 downto 0);
	g_out <=  pix_us_g(N_comp-1 downto 0);
	b_out <=  pix_us_b(N_comp-1 downto 0);
            
	nl_out <= nl;
   
        
end Behavioral;
