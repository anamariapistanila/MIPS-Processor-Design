----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2020 05:29:57 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    Port ( clk : in STD_LOGIC;
           Alu_Res : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR(15 downto 0);
           en: in std_logic;
           Alu_Res_out :out std_logic_vector(15 downto 0));
end MEM;

architecture Behavioral of MEM is
type RAM_mem is array(0 to 15) of std_logic_vector(15 downto 0);
signal ram: RAM_mem:=(x"0002",x"0007",x"000E",x"0005",x"0009",x"0003",x"000E",x"000B",x"0004",x"0006",x"000D",x"0001",x"000A",x"0003",x"0003",others=>x"0000");


begin
  -- Data Memory
    process(clk) 			
    begin
        if rising_edge(clk) then
            if en = '1' and MemWrite='1' then
                ram(conv_integer(Alu_res(3 downto 0))) <= RD2;			
            end if;
        end if;
    end process;

    -- outputs
    MemData <= ram(conv_integer(Alu_res(3 downto 0)));
    Alu_res_out <= Alu_res;
end Behavioral;

