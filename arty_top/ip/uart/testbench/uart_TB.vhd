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
constant C_CLK_PERIOD:           TIME :=  10.000 ns;    -- 100 MHz
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
   -- 100 MHZ
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
      BUS_WR(X"1000", X"00000000");
      BUS_WR(X"1004", X"00000004");
      BUS_WR(X"1008", X"00000008");
      BUS_WR(X"100C", X"0000000C");
      BUS_WR(X"1010", X"00000010");
      BUS_WR(X"1014", X"00000014");
      BUS_WR(X"1018", X"00000018");
      BUS_WR(X"101C", X"0000001C");

      -- transmit 32 bytes
      BUS_WR(X"0018", X"00000020");

      -- 10ms timeout interrupt
--      BUS_WR(X"0000", X"D000A000");

      -- 32 characters received interrupt
      BUS_WR(X"0000", X"D0000020");

      wait;

   end process;

end tb_arch;

