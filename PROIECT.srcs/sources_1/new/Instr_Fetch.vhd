----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2020 05:24:37 PM
-- Design Name: 
-- Module Name: Instr_Fetch - Behavioral
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

entity Instr_Fetch is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en : in STD_LOGIC;
           jump : in STD_LOGIC;
           pcSrc : in STD_LOGIC;
           jmp_address : in STD_LOGIC_VECTOR (15 downto 0);
           br_address : in STD_LOGIC_VECTOR (15 downto 0);
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           next_instruction : out STD_LOGIC_VECTOR (15 downto 0));
end Instr_Fetch;

architecture Behavioral of Instr_Fetch is
type ROM is array(0 to 24) of std_logic_vector(15 downto 0);
signal my_rom: ROM:=(
B"100_000_001_0001111", --addi $1,$0,15
B"100_000_010_0000000", --addi $2,$0,0
B"100_000_011_0000000", --addi $3,$0,0
B"100_000_100_0000000", --addi $4,$0,0
B"001_001_010_0001001",  --et: beq $1,$2,9(fib)
B"010_010_011_0000000",  --lw $3,0($2)
B"011_011_101_0000001",  --andi $5,$3,1
B"100_000_110_0000001",  --addi $6,$0,1
B"001_110_101_0000010",  --beq $6,$5,2(suma)
B"100_010_010_0000001",  --addi $2,$2,1
B"101_0000000000100",    -- j 4(et)
B"000_100_011_100_0_000", --suma: add $4,$4,$3
B"100_010_010_0000001",  --addi $2,$2,1
B"101_0000000000100",    -- j 4(et)
B"100_000_001_0000000",  --fib: addi $1,$0,0
B"100_000_010_0000001",  --addi $2,$0,1
B"000_001_010_101_0_000",  -- sumafib: add $5,$1,$2
B"001_100_101_0000100",   --beq $4,$5,4(final)
B"110_101_100_0000101",   --bgt $5,$4,5(exit)
B"100_010_001_0000000",   --addi $1,$2,0
B"100_101_010_0000000",   --addi $2,$5,0
B"101_0000000010000",     -- j 16(sumafib)
B"111_000_100_0010001",   --final: sw $4,17($0)
B"100_000_110_0000001",   --addi $6,$0,1
B"100_000_110_0000000", --exit: addi $6,$0,0
others => x"0000"
);

signal PC : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal PC_Aux, Next_Addr, mux1, mux2: STD_LOGIC_VECTOR(15 downto 0);

begin
  -- Program Counter
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                PC <= (others => '0');
            elsif en = '1' then
                PC <= Next_Addr;
            end if;
        end if;
    end process;

    -- Instruction OUT
    Instruction <= my_rom(conv_integer(PC(7 downto 0)));

    -- PC incremented
    next_instruction <= PC + 1;
 

    -- MUX Branch
    process(PCSrc, PC_Aux, br_address)
    begin
        case PCSrc is 
            when '1' => mux1 <= br_address;
            when others => mux1 <= PC+1;
        end case;
    end process;	

     -- MUX Jump
    process(jump, mux1, jmp_address)
    begin
        case jump is
            when '1' => Next_Addr <= jmp_address;
            when others => Next_Addr <= mux1;
        end case;
    end process;

end Behavioral;
