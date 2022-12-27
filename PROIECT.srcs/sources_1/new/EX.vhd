----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2020 05:28:49 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
    Port ( Next_instr : in STD_LOGIC_VECTOR (15 downto 0);
           RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           Func : in STD_LOGIC_VECTOR (2 downto 0);
           Sa : in STD_LOGIC;
           ALUSrc:std_logic;
           ALUOp:std_logic_vector(2 downto 0);
           Branch_address : out STD_LOGIC_VECTOR (15 downto 0);
           AluRes : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC;
           Bgt_Flag:out STD_LOGIC);
end EX;

architecture Behavioral of EX is


signal ALU_Intrare:std_logic_vector(15 downto 0);
signal ALU_Ctrl:std_logic_vector(2 downto 0);
signal Alu_Res_Aux:std_logic_vector(15 downto 0):=(others=>'0');
signal semn:std_logic;
signal Zero_Aux:std_logic;
signal Bgt_Flag_Aux:std_logic;




begin

Branch_address<=Next_instr+Ext_Imm;

 with ALUSrc select
        ALU_Intrare<= RD2 when '0', 
	              Ext_Imm when '1',
	              (others => '0') when others;
	              
semn<='0' when RD1(15)='0' else '1';

 process(ALUOp, Func)
        begin
            case ALUOp is
                when "000" =>
                            case Func is
                                when "000" => ALU_Ctrl <= "000"; --ADD
                                when "001" => ALU_Ctrl <= "001"; -- SUB
                                when "010" => ALU_Ctrl <= "010"; -- SLL
                                when "011" => ALU_Ctrl <= "011"; -- SRL
                                when "100" => ALU_Ctrl <= "100"; -- AND
                                when "101" => ALU_Ctrl <= "101"; -- OR
                                when "110" => ALU_Ctrl <= "110"; -- XOR
                                when "111" => ALU_Ctrl <= "111"; -- SRA
                                when others => ALU_Ctrl <= "000";
                            end case;
                when "001" => ALU_Ctrl <= "000"; --ADDI/LW/SW
                when "010" => ALU_Ctrl <= "001"; --BEQ 
                when "011" => ALU_Ctrl <= "100"; --ANDI 
                when "100" => ALU_Ctrl  <="001"; --BGT
                when others => ALU_Ctrl <="000"; 
            end case;
        end process;
        
 process (ALU_Ctrl, RD1, Alu_Intrare, sa, ALU_Res_Aux)
              begin
                  case ALU_Ctrl is
                      when "000" => Alu_Res_Aux <= RD1 + ALU_Intrare; -- ADUNARE
                      when "001" => Alu_Res_Aux <= RD1 - ALU_Intrare; -- SCADERE
                                  if(Alu_Res_Aux(15)='0') then Bgt_Flag_Aux<='1';
                                  else Bgt_Flag_Aux<='0';
                                  end if;         
                      when "010" => 
                              if ( sa = '1') then                  -- SLL
                                  Alu_Res_Aux(15 downto 1) <= RD1 (14 downto 0);
                                  Alu_Res_Aux(0) <= '0';
                              else
                                  Alu_Res_Aux <= RD1;
                              end if;
                      when "011" =>
                              if ( sa = '1') then                  -- SRL
                                  Alu_Res_Aux(14 downto 0) <= RD1 (15 downto 1);
                                  Alu_Res_Aux(15) <= '0';
                              else
                                  Alu_Res_Aux <= RD1;
                              end if;
                      when "100" => Alu_Res_Aux <= RD1 and ALU_Intrare; -- AND
                      when "101" => Alu_Res_Aux <= RD1 or ALU_Intrare; -- OR
                      when "110" => Alu_Res_Aux<= RD1 xor  ALU_Intrare; -- XOR
                      when "111" =>  if ( sa = '1') then                  -- SRA
                      
                                                       Alu_Res_Aux(14 downto 0) <= RD1 (15 downto 1);
                                                       Alu_Res_Aux(15) <= semn;
                                                   else
                                                       Alu_Res_Aux <= RD1;
                                                   end if;
                            
                      when others => Alu_Res_Aux <= x"0000";
                      end case;
                      
                      
                          case (Alu_Res_Aux) is                    -----ZERO SIGNAL-----
                              when X"0000" => Zero_Aux<='1';
                              when others => Zero_Aux<='0';
                          end case;
                          
              end process;
AluRes<=Alu_Res_Aux;
Zero<=Zero_Aux;
Bgt_Flag<=Bgt_Flag_Aux;
end Behavioral;
