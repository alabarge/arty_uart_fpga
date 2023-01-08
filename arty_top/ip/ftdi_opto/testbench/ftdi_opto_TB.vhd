library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

use work.pck_fio.all;
use work.pck_tb.all;

-- Test Bench Entity
entity ftdi_opto_tb is
end ftdi_opto_tb;

architecture tb_arch of ftdi_opto_tb is

-- 32-Bit Control Register
signal opto_CONTROL        : std_logic_vector(31  downto 0) := X"00000000";
alias  xl_TX_HEAD          : std_logic_vector(1 downto 0) is opto_CONTROL(1 downto 0);
alias  xl_RX_TAIL          : std_logic_vector(1 downto 0) is opto_CONTROL(3 downto 2);
alias  xl_PIPE_INT         : std_logic is opto_CONTROL(25);
alias  xl_DMA_REQ          : std_logic is opto_CONTROL(26);
alias  xl_RX_INT           : std_logic is opto_CONTROL(27);
alias  xl_TX_INT           : std_logic is opto_CONTROL(28);
alias  xl_PIPE_RUN         : std_logic is opto_CONTROL(29);
alias  xl_FTDI_RUN         : std_logic is opto_CONTROL(30);
alias  xl_ENABLE           : std_logic is opto_CONTROL(31);

-- Stimulus signals - signals mapped to the input and inout ports of tested entity
signal clk                 : std_logic := '0';
signal reset_n             : std_logic := '0';
signal m1_rd_waitreq       : std_logic := '0';
signal m1_readdata         : std_logic_vector(31 downto 0);
signal m1_rd_datavalid     : std_logic := '1';
signal read_n              : std_logic := '1';
signal write_n             : std_logic := '1';
signal address             : std_logic_vector(11 downto 0) := X"000";
signal writedata           : std_logic_vector(31 downto 0) := X"00000000";
signal fsdo                : std_logic := '1';
signal fscts               : std_logic := '1';

-- Observed signals - signals mapped to the output ports of tested entity
signal m1_read             : std_logic := '0';
signal m1_rd_address       : std_logic_vector(31 downto 0) := X"00000000";
signal m1_rd_burstcount    : std_logic_vector(15 downto 0) := X"0000";
signal readdata            : std_logic_vector(31 downto 0) := X"00000000";
signal irq                 : std_logic := '0';
signal fsclk               : std_logic := '0';
signal fsdi                : std_logic := '1';
signal test_bit            : std_logic := '0';
signal debug               : std_logic_vector(3 downto 0) := "0000";

signal fsclk_r0            : std_logic;
signal tx_start            : std_logic;
signal bit_cnt             : integer range 0 to 16 := 0;

-- constants
constant C_CLK_PERIOD:     TIME :=  10.000 ns;    -- 100 MHz

begin

   --
   -- Unit Under Test
   --
   FTDI_OPTO_I : entity work.opto_top
   port map (
      -- Avalon Memory-Mapped Slave
      clk                  => clk,
      reset_n              => reset_n,
      read_n               => read_n,
      write_n              => write_n,
      address              => address,
      readdata             => readdata,
      writedata            => writedata,
      irq                  => irq,
      -- Avalon Memory-Mapped Read Master
      m1_read              => m1_read,
      m1_rd_address        => m1_rd_address,
      m1_readdata          => m1_readdata,
      m1_rd_waitreq        => m1_rd_waitreq,
      m1_rd_burstcount     => m1_rd_burstcount,
      m1_rd_datavalid      => m1_rd_datavalid,
      -- Memory Head-Tail Pointers
      head_addr            => X"0000",
      tail_addr            => open,
      -- Exported Signals
      fsclk                => fsclk,
      fscts                => fscts,
      fsdo                 => fsdo,
      fsdi                 => fsdi,
      test_bit             => test_bit,
      debug                => debug
   );

   --
   -- Clocks
   --

   --
   -- 100 MHZ
   --
   process begin
      clk <= '1';
      wait for C_CLK_PERIOD/2;
      clk <= '0';
      wait for C_CLK_PERIOD/2;
   end process;

   --
   -- Reset
   --
   process begin
      reset_n <= '0';
      wait for 10*C_CLK_PERIOD;
      reset_n <= '1';
      wait;
   end process;

   --
   -- Generate FSCTS
   --
   process begin
      wait until reset_n = '1';
      bit_cnt  <= 0;
      fscts    <= '1';
      tx_start <= '0';
      loop
         wait until rising_edge(clk);
         fsclk_r0       <= fsclk;
         if (fsdi = '0' and fsclk = '1' and fsclk_r0 = '0' and bit_cnt = 0) then
            fscts       <= '1';
            bit_cnt     <= 1;
            tx_start    <= '1';
         elsif (fsclk = '1' and fsclk_r0 = '0' and bit_cnt = 1) then
            fscts       <= '0';
            bit_cnt     <= 2;
         elsif (fsclk = '1' and fsclk_r0 = '0' and bit_cnt = 12) then
            fscts       <= '1';
            bit_cnt     <= 0;
            tx_start    <= '0';
         elsif (fsclk = '1' and fsclk_r0 = '0' and tx_start = '1') then
            fscts       <= fscts;
            bit_cnt     <= bit_cnt + 1;
         else
            fscts       <= fscts;
            bit_cnt     <= bit_cnt;
         end if;
      end loop;
   end process;

   --
   -- Main Process
   --
   process

   procedure BUS_WR(addr: in std_logic_vector(11 downto 0);
                    data: in std_logic_vector(31 downto 0)) is
   begin
      wait until rising_edge(clk);
      wait for (1 ns);
      write_n     <= '0';
      address     <= addr;
      writedata   <= data;
      wait until rising_edge(clk);
      wait for (1 ns);
      write_n     <= '1';
      address     <= (others => '0');
      writedata   <= (others => '0');
   end;

   procedure BUS_RD(addr: in std_logic_vector(11 downto 0)) is
   begin
      wait until rising_edge(clk);
      wait for (1 ns);
      read_n      <= '0';
      address     <= addr;
      wait until rising_edge(clk);
      wait for (1 ns);
      read_n      <= '1';
      address     <= (others => '0');
   end;


   begin

      wait until reset_n = '1';

      -- Enable module
      xl_ENABLE       <= '1';
      BUS_WR(X"000", opto_CONTROL);  -- CONTROL

      wait for 100 ns;

      -- Fill Message
      BUS_WR(X"400", X"50018383");
      BUS_WR(X"401", X"201C07BE");
      BUS_WR(X"402", X"00000A83");
      BUS_WR(X"403", X"55AA1234");
      BUS_WR(X"404", X"00000401");
      BUS_WR(X"405", X"00001F0C");
      BUS_WR(X"406", X"0000039F");
      BUS_WR(X"407", X"00020400");

      -- Register Setup
      xl_TX_HEAD     <= "01";
      xl_RX_TAIL     <= "00";
      xl_PIPE_INT    <= '0';
      xl_DMA_REQ     <= '0';
      xl_RX_INT      <= '1';
      xl_TX_INT      <= '0';
      xl_PIPE_RUN    <= '0';
      xl_FTDI_RUN    <= '1';

      BUS_WR(X"004", X"03000000");  -- ADDRESS BEGIN
      BUS_WR(X"005", X"03007FFF");  -- ADDRESS END
      BUS_WR(X"006", X"00000001");  -- PACKET COUNT
      BUS_WR(X"000", opto_CONTROL);  -- CONTROL

      BUS_RD(X"001");               -- VERSION

      wait;

   end process;

end tb_arch;

