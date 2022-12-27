----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2020 05:27:37 PM
-- Design Name: 
-- Module Name: Bloc_registre - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Bloc_registre is
    Port ( RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           CLK : in STD_LOGIC;
           REG_WR : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           en: in std_logic);
end Bloc_registre;

architecture Behavioral of Bloc_registre is
type reg is array(0 to 15) of std_logic_vector(15 downto 0);
signal my_reg:reg:=(x"0000",x"0000",x"0000",x"0000",others=>x"0000");

begin
process(clk)
begin
if rising_edge(clk) then
if reg_wr='1' then
if en='1' then
my_reg(conv_integer(wa))<=wd;
end if;
end if;
end if;
end process;

rd1<=my_reg(conv_integer(ra1));
rd2<=my_reg(conv_integer(ra2));



end Behavioral;
