library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

use work.pck_fio.all;
use work.pck_tb.all;

-- Test Bench Entity
entity uart_tb is
end uart_tb;

architecture tb_arch of uart_tb is

signal clk                 : std_logic := '0';
signal reset_n             : std_logic := '0';
signal read_n              : std_logic := '1';
signal write_n             : std_logic := '1';
signal address             : std_logic_vector(7 downto 0)  := (others => '0');
signal readdata            : std_logic_vector(31 downto 0) := (others => '0');
signal writedata           : std_logic_vector(31 downto 0) := (others => '0');
signal irq                 : std_logic := '0';
signal rxd                 : std_logic := '1';
signal txd                 : std_logic := '1';
signal term                : std_logic := '0';
signal txen                : std_logic := '0';
signal led                 : std_logic := '0';

signal ramp                : unsigned(11 downto 0) := X"000";
signal sout                : unsigned(11 downto 0) := X"000";
signal sck_r0              : std_logic := '0';
signal ad_bit_cnt          : integer range 0 to 32 := 0;

-- constants
constant C_CLK_PERIOD:     TIME :=  10.000 ns;    -- 100 MHz

begin

   --
   -- Unit Under Test
   --
   UART_TOP_I : entity work.uart_top
   port map (
      clk                  => clk,
      reset_n              => reset_n,
      read_n               => read_n,
      write_n              => write_n,
      address              => address,
      readdata             => readdata,
      writedata            => writedata,
      irq                  => irq,
      rxd                  => rxd,
      txd                  => txd,
      led                  => led,
      term                 => term,
      txen                 => txen
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
   -- TXD-RXD Loopback
   --
   process begin
      wait until reset_n = '1';
      loop
         wait until rising_edge(clk);
         rxd   <= txd;
      end loop;
   end process;

   --
   -- Main Process
   --
   process

   procedure BUS_WR(addr: in std_logic_vector(7 downto 0);
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

   procedure BUS_RD(addr: in std_logic_vector(7 downto 0)) is
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

      -- message to transmit
      BUS_WR(X"80", X"03020100");
      BUS_WR(X"81", X"07060504");
      BUS_WR(X"82", X"0B0A0908");
      BUS_WR(X"83", X"0F0E0D0C");
      BUS_WR(X"84", X"13121110");
      BUS_WR(X"85", X"17161514");
      BUS_WR(X"86", X"1B1A1918");
      BUS_WR(X"87", X"1F1E1D1C");

      -- transmit 32 bytes
      -- 10ms timeout
      BUS_WR(X"00", X"D8280020");

      -- 0ms timeout
      -- BUS_WR(X"00", X"D8000020");

      wait;

   end process;

end tb_arch;

