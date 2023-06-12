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

-- constants
constant C_CLK_PERIOD:           TIME :=  12.308 ns;    -- 81.247969 MHz
constant C_S_AXI_DATA_WIDTH:     integer := 32;
constant C_S_AXI_ADDR_WIDTH:     integer := 16;

signal s_axi_aclk          : std_logic := '0';
signal s_axi_aresetn       : std_logic := '0';
signal s_axi_awaddr        : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
signal s_axi_awprot        : std_logic_vector(2 downto 0) := (others => '0');
signal s_axi_awvalid       : std_logic := '0';
signal s_axi_awready       : std_logic := '0';
signal s_axi_wdata         : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal s_axi_wstrb         : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0) := (others => '0');
signal s_axi_wvalid        : std_logic := '0';
signal s_axi_wready        : std_logic := '0';
signal s_axi_bresp         : std_logic_vector(1 downto 0) := (others => '0');
signal s_axi_bvalid        : std_logic := '0';
signal s_axi_bready        : std_logic := '0';
signal s_axi_araddr        : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
signal s_axi_arprot        : std_logic_vector(2 downto 0) := (others => '0');
signal s_axi_arvalid       : std_logic := '0';
signal s_axi_arready       : std_logic := '0';
signal s_axi_rdata         : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
signal s_axi_rresp         : std_logic_vector(1 downto 0) := (others => '0');
signal s_axi_rvalid        : std_logic := '0';
signal s_axi_rready        : std_logic := '0';
signal irq                 : std_logic := '0';
signal rxd                 : std_logic := '0';
signal txd                 : std_logic := '0';

begin

   --
   -- Unit Under Test
   --
   UART_TOP_I : entity work.uart_top
   port map (
      s_axi_aclk        => s_axi_aclk,
      s_axi_aresetn     => s_axi_aresetn,
      s_axi_awaddr      => s_axi_awaddr,
      s_axi_awprot      => s_axi_awprot,
      s_axi_awvalid     => s_axi_awvalid,
      s_axi_awready     => s_axi_awready,
      s_axi_wdata       => s_axi_wdata,
      s_axi_wstrb       => s_axi_wstrb,
      s_axi_wvalid      => s_axi_wvalid,
      s_axi_wready      => s_axi_wready,
      s_axi_bresp       => s_axi_bresp,
      s_axi_bvalid      => s_axi_bvalid,
      s_axi_bready      => s_axi_bready,
      s_axi_araddr      => s_axi_araddr,
      s_axi_arprot      => s_axi_arprot,
      s_axi_arvalid     => s_axi_arvalid,
      s_axi_arready     => s_axi_arready,
      s_axi_rdata       => s_axi_rdata,
      s_axi_rresp       => s_axi_rresp,
      s_axi_rvalid      => s_axi_rvalid,
      s_axi_rready      => s_axi_rready,
      irq               => irq,
      rxd               => rxd,
      txd               => txd
   );

   --
   -- Clocks
   --

   --
   -- 81 MHZ
   --
   process begin
      s_axi_aclk <= '1';
      wait for C_CLK_PERIOD/2;
      s_axi_aclk <= '0';
      wait for C_CLK_PERIOD/2;
   end process;

   --
   -- Reset
   --
   process begin
      s_axi_aresetn <= '0';
      wait for 10*C_CLK_PERIOD;
      s_axi_aresetn <= '1';
      wait;
   end process;

   --
   -- TXD-RXD Loopback
   --
   process begin
      wait until s_axi_aresetn = '1';
      loop
         wait until rising_edge(s_axi_aclk);
         rxd   <= txd;
      end loop;
   end process;

   --
   -- Main Process
   --
   process

   procedure BUS_WR(addr: in std_logic_vector(15 downto 0);
                    data: in std_logic_vector(31 downto 0)) is
   begin
      wait until rising_edge(s_axi_aclk);
      wait for (1 ns);
      s_axi_awvalid  <= '1';
      s_axi_awaddr   <= addr;
      s_axi_wdata    <= data;
      s_axi_wvalid   <= '1';
      s_axi_wstrb    <= "1111";
      s_axi_bready   <= '1';
      wait until rising_edge(s_axi_aclk);
      wait until rising_edge(s_axi_aclk);
      wait for (1 ns);
      s_axi_awvalid  <= '0';
      s_axi_awaddr   <= (others => '0');
      s_axi_wdata    <= (others => '0');
      s_axi_wvalid   <= '0';
      s_axi_wstrb    <= "0000";
      s_axi_bready   <= '0';
   end;

   procedure BUS_RD(addr: in std_logic_vector(15 downto 0)) is
   begin
      wait until rising_edge(s_axi_aclk);
      wait for (1 ns);
      s_axi_arvalid  <= '1';
      s_axi_rready   <= '1';
      s_axi_araddr   <= addr;
      wait until rising_edge(s_axi_aclk);
      wait until rising_edge(s_axi_aclk);
      wait for (1 ns);
      s_axi_arvalid  <= '0';
      s_axi_rready   <= '0';
      s_axi_araddr   <= (others => '0');
   end;


   begin

      wait until s_axi_aresetn = '1';

      -- message to transmit
      BUS_WR(X"4000", X"00000000");
      BUS_WR(X"4004", X"00000001");
      BUS_WR(X"4008", X"00000002");
      BUS_WR(X"400C", X"00000003");
      BUS_WR(X"4010", X"00000004");
      BUS_WR(X"4014", X"00000005");
      BUS_WR(X"4018", X"00000006");
      BUS_WR(X"401C", X"00000007");

      BUS_WR(X"4020", X"00000008");
      BUS_WR(X"4024", X"00000009");
      BUS_WR(X"4028", X"0000000A");
      BUS_WR(X"402C", X"0000000B");
      BUS_WR(X"4030", X"0000000C");
      BUS_WR(X"4034", X"0000000D");
      BUS_WR(X"4038", X"0000000E");
      BUS_WR(X"403C", X"0000000F");

      BUS_WR(X"4040", X"00000010");
      BUS_WR(X"4044", X"00000011");
      BUS_WR(X"4048", X"00000012");
      BUS_WR(X"404C", X"00000013");
      BUS_WR(X"4050", X"00000014");
      BUS_WR(X"4054", X"00000015");
      BUS_WR(X"4058", X"00000016");
      BUS_WR(X"405C", X"00000017");

      BUS_WR(X"4060", X"00000018");
      BUS_WR(X"4064", X"00000019");
      BUS_WR(X"4068", X"0000001A");
      BUS_WR(X"406C", X"0000001B");
      BUS_WR(X"4070", X"0000001C");
      BUS_WR(X"4074", X"0000001D");
      BUS_WR(X"4078", X"0000001E");
      BUS_WR(X"407C", X"0000001F");

      -- transmit 32 bytes
      BUS_WR(X"0018", X"00000020");

      -- 10ms timeout interrupt
--      BUS_WR(X"0000", X"D000A000");

      -- 32 characters received interrupt
      BUS_WR(X"0000", X"D0000020");

      wait for 3 ms;

      -- clear all interrupts
      BUS_WR(X"000C", X"00000007");

      BUS_RD(X"4000");
      BUS_RD(X"4004");
      BUS_RD(X"4008");
      BUS_RD(X"400C");
      BUS_RD(X"4010");
      BUS_RD(X"4014");
      BUS_RD(X"4018");
      BUS_RD(X"401C");

      BUS_RD(X"4020");
      BUS_RD(X"4024");
      BUS_RD(X"4028");
      BUS_RD(X"402C");
      BUS_RD(X"4030");
      BUS_RD(X"4034");
      BUS_RD(X"4038");
      BUS_RD(X"403C");

      BUS_RD(X"4040");
      BUS_RD(X"4044");
      BUS_RD(X"4048");
      BUS_RD(X"404C");
      BUS_RD(X"4050");
      BUS_RD(X"4054");
      BUS_RD(X"4058");
      BUS_RD(X"405C");

      BUS_RD(X"4060");
      BUS_RD(X"4064");
      BUS_RD(X"4068");
      BUS_RD(X"406C");
      BUS_RD(X"4070");
      BUS_RD(X"4074");
      BUS_RD(X"4078");
      BUS_RD(X"407C");

      wait;

   end process;

end tb_arch;

