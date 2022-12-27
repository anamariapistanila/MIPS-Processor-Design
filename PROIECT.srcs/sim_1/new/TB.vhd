----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2020 05:33:45 PM
-- Design Name: 
-- Module Name: TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB is
--  Port ( );
end TB;

architecture Behavioral of TB is

signal Clk:  std_logic;
signal  Rst :  std_logic;
signal  En :  std_logic ;
signal Alu_Out : std_logic_vector(15 downto 0);
signal PC : std_logic_vector(15 downto 0);
signal Data1 :  std_logic_vector(15 downto 0);
signal Data2 :  std_logic_vector(15 downto 0);
signal Ext_imm:std_logic_vector(15 downto 0);
signal Instr:std_logic_vector(15 downto 0);
signal AluOp:std_logic_vector(2 downto 0);
signal MemData:std_logic_vector(15 downto 0);


constant CLK_PERIOD : TIME := 10 ns;
begin

DUT : entity Work.modul_principal port map(
    Clk     => Clk,
    Rst     => Rst,
   En =>En,
   Alu_Out =>Alu_Out,
   PC =>PC,
   Data1=>Data1,
   Data2=>Data2,
   Ext_imm_out=>Ext_Imm,
   Instr =>Instr,
   AluOpOut=>AluOp,
   MemData=>MemData);


 gen_clk: process
 begin
     Clk <= '0';
     wait for (CLK_PERIOD/2);
     Clk <= '1';
     wait for (CLK_PERIOD/2);
 end process gen_clk;
                                             
 gen_vect_test1: process

 begin
    Rst <= '1';
    wait for CLK_PERIOD;
    Rst <= '0';
    En<='1';

  
  wait;
 end process gen_vect_test1;    



end Behavioral;
