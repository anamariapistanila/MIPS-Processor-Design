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

entity modul_principal is
    Port ( clk : in STD_LOGIC;
           en : in std_logic;
           Rst : in std_logic;
   Alu_Out : out std_logic_vector(15 downto 0);
   PC : out std_logic_vector(15 downto 0);
   Data1 : out std_logic_vector(15 downto 0);
   Data2 : out std_logic_vector(15 downto 0);
   Ext_imm_out : out std_logic_vector(15 downto 0);
   Instr : out std_logic_vector(15 downto 0);
   AluOpOut : out std_logic_vector(2 downto 0);
   MemData : out std_logic_vector( 15 downto 0));
   
end modul_principal;

architecture Behavioral of modul_principal is

signal read1,read2:std_logic_vector(15 downto 0):=x"0000";

--if fetch
signal instr1:std_logic_vector(15 downto 0);
signal next_instr:std_logic_vector(15 downto 0);

--unitate control

signal RegDst,ExtOp,ALUSrc,Branch,Jump,MemWrite,MemtoReg,RegWrite: std_logic;
signal ALUOp:std_logic_vector(2 downto 0);
signal Ext_imm:std_logic_vector(15 downto 0);
signal func:std_logic_vector(2 downto 0);
signal sa:std_logic;

--final
signal br_address:std_logic_vector(15 downto 0);
signal alu_res_out:std_logic_vector(15 downto 0);
signal alu_res_final:std_logic_vector(15 downto 0);
signal Zero_final:std_logic;
signal Write_Data_out:std_logic_vector(15 downto 0);
signal Read_Data_out:std_logic_vector(15 downto 0);
signal PcSrc_out:std_logic;
signal jr_address:std_logic_vector(15 downto 0);
signal bgtf:std_logic;
signal Bgt_final:std_logic;
signal PcSrc_out1:std_logic;
signal PcSrc_final:std_logic;


component Instr_Fetch is
    Port ( clk : in STD_LOGIC;
          reset : in STD_LOGIC;
           en : in STD_LOGIC;
           jump : in STD_LOGIC;
           pcSrc : in STD_LOGIC;
           jmp_address : in STD_LOGIC_VECTOR (15 downto 0);
           br_address : in STD_LOGIC_VECTOR (15 downto 0);
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           next_instruction : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component ID is
    Port ( clk : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (15 downto 0);
           Write_Data : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           Func : out STD_LOGIC_VECTOR (2 downto 0);
           Sa : out STD_LOGIC;
           en:in std_logic);
end component;

component EX is
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
end component;


component MEM is
    Port ( clk : in STD_LOGIC;
           Alu_Res : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR(15 downto 0);
           Alu_Res_Out : out STD_LOGIC_VECTOR (15 downto 0);
           en : in std_logic);
end component;

begin

process(instr1(15 downto 13))
begin
RegDst<='0';ExtOp<='0';ALUSrc<='0';Branch<='0';Jump<='0';MemWrite<='0';MemtoReg<='0';RegWrite<='0';ALUOp<="000";bgtf<='0';
case (instr1(15 downto 13)) is
when "000"=>RegDst<='1';RegWrite<='1';ALUOp<="000"; --tip R
when "001"=>ExtOp<='1';Branch<='1';ALUOp<="010";  --BEQ
when "010"=>ExtOp<='1';ALUSrc<='1';MemtoReg<='1';RegWrite<='1';ALUOp<="001"; --LW
when "011"=>ALUSrc<='1';RegWrite<='1';ALUOp<="011"; --ANDI
when "100"=>ExtOp<='1';ALUSrc<='1';RegWrite<='1';ALUOp<="001"; --ADDI
when "101"=>Jump<='1'; --JUMP
when "110"=>ExtOp<='1';bgtf<='1';ALUOp<="100"; --BGT
when "111"=>ExtOp<='1';ALUSrc<='1';MemWrite<='1';ALUOp<="001"; --SW
when others=>RegDst<='0';ExtOp<='0';ALUSrc<='0';Branch<='0';Jump<='0';MemWrite<='0';MemtoReg<='0';RegWrite<='0';ALUOp<="000";bgtf<='0';
end case;
end process;

 -- WriteBack unit
    with MemtoReg select
        Write_Data_out <= Read_Data_out when '1',
              ALU_res_final when '0',
              (others => '0') when others;
              
PcSrc_out<=Branch and Zero_final;
PcSrc_out1<=bgtf and Bgt_final;
PcSrc_final<=PcSrc_out or PcSrc_out1;
jr_address<=next_instr(15 downto 13) & instr1(12 downto 0);

Instruction_Fetch: Instr_Fetch port map(clk=>clk,reset=>rst,en=>en,jump=>Jump,pcSrc=>PcSrc_final,jmp_address=>jr_address,br_address=>br_address,instruction=>instr1,next_instruction=>next_instr);
D: ID port map(clk=>clk,Instr=>instr1,Write_Data=>Write_Data_out,RegWrite=>RegWrite,RegDst=>RegDst,ExtOp=>ExtOp,RD1=>read1,RD2=>read2,Ext_Imm=>Ext_imm,Func=>func,Sa=>sa,en=>en);
E: EX port map(Next_instr=>next_instr,RD1=>read1,RD2=>read2,Ext_Imm=>Ext_imm,Func=>func,Sa=>sa,ALUSrc=>ALUsrc,ALUOp=>ALUOp,Branch_address=>br_address,AluRes=>alu_res_out,Zero=>Zero_final,Bgt_Flag=>Bgt_final);
Me: MEM port map(clk=>clk,Alu_Res=>alu_res_out,RD2=>read2,MemWrite=>MemWrite,MemData=>Read_Data_out,Alu_Res_Out=>alu_res_final,en=>en);


Alu_out<=Write_Data_out;
Ext_imm_out<=Ext_imm;
MemData<=Read_Data_out;
AluOpout<=AluOp;
Data1<=read1;
Data2<=read2;
Instr<=instr1;
Pc<=next_instr;


end Behavioral;
