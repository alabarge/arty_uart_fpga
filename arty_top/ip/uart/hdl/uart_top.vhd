library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_top is
   generic (
      C_S_AXI_DATA_WIDTH   : integer   := 32;
      C_S_AXI_ADDR_WIDTH   : integer   := 8
   );
   port (
      s_axi_aclk           : in    std_logic;
      s_axi_aresetn        : in    std_logic;
      s_axi_awaddr         : in    std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      s_axi_awprot         : in    std_logic_vector(2 downto 0);
      s_axi_awvalid        : in    std_logic;
      s_axi_awready        : out   std_logic;
      s_axi_wdata          : in    std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      s_axi_wstrb          : in    std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
      s_axi_wvalid         : in    std_logic;
      s_axi_wready         : out   std_logic;
      s_axi_bresp          : out   std_logic_vector(1 downto 0);
      s_axi_bvalid         : out   std_logic;
      s_axi_bready         : in    std_logic;
      s_axi_araddr         : in    std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      s_axi_arprot         : in    std_logic_vector(2 downto 0);
      s_axi_arvalid        : in    std_logic;
      s_axi_arready        : out   std_logic;
      s_axi_rdata          : out   std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      s_axi_rresp          : out   std_logic_vector(1 downto 0);
      s_axi_rvalid         : out   std_logic;
      s_axi_rready         : in    std_logic;
      irq                  : out   std_logic;
      rxd                  : in    std_logic;
      txd                  : out   std_logic
   );
end entity uart_top;

architecture rtl of uart_top is

--
-- SIGNAL DECLARATIONS
--
   signal uart_CONTROL     : std_logic_vector(31 downto 0);
   signal uart_INT_REQ     : std_logic_vector(2 downto 0);
   signal uart_INT_ACK     : std_logic_vector(2 downto 0);
   signal uart_STATUS      : std_logic_vector(31 downto 0);
   signal uart_TICKS       : std_logic_vector(15 downto 0);
   signal uart_int         : std_logic_vector(2 downto 0);

   signal cpu_RXD          : std_logic_vector(31 downto 0);
   signal cpu_TXD          : std_logic_vector(31 downto 0);
   signal cpu_ADDR         : std_logic_vector(6 downto 0);
   signal cpu_WE           : std_logic;
   signal cpu_RE           : std_logic;

--
-- MAIN CODE
--
begin

   --
   -- REGISTER FILE
   --
   UART_REGS_I: entity work.uart_regs
   generic map (
      C_S_AXI_DATA_WIDTH   => C_S_AXI_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH   => C_S_AXI_ADDR_WIDTH
   )
   port map (
      s_axi_aclk           => s_axi_aclk,
      s_axi_aresetn        => s_axi_aresetn,
      s_axi_awaddr         => s_axi_awaddr,
      s_axi_awprot         => s_axi_awprot,
      s_axi_awvalid        => s_axi_awvalid,
      s_axi_awready        => s_axi_awready,
      s_axi_wdata          => s_axi_wdata,
      s_axi_wstrb          => s_axi_wstrb,
      s_axi_wvalid         => s_axi_wvalid,
      s_axi_wready         => s_axi_wready,
      s_axi_bresp          => s_axi_bresp,
      s_axi_bvalid         => s_axi_bvalid,
      s_axi_bready         => s_axi_bready,
      s_axi_araddr         => s_axi_araddr,
      s_axi_arprot         => s_axi_arprot,
      s_axi_arvalid        => s_axi_arvalid,
      s_axi_arready        => s_axi_arready,
      s_axi_rdata          => s_axi_rdata,
      s_axi_rresp          => s_axi_rresp,
      s_axi_rvalid         => s_axi_rvalid,
      s_axi_rready         => s_axi_rready,
      cpu_RXD              => cpu_RXD,
      cpu_TXD              => cpu_TXD,
      cpu_ADDR             => cpu_ADDR,
      cpu_WE               => cpu_WE,
      cpu_RE               => cpu_RE,
      uart_CONTROL         => uart_CONTROL,
      uart_INT_REQ         => uart_INT_REQ,
      uart_INT_ACK         => uart_INT_ACK,
      uart_STATUS          => uart_STATUS,
      uart_TICKS           => uart_TICKS
   );

   --
   -- UART TX-RX STATE MACHINE
   --
   UART_CTL_I: entity work.uart_ctl
   port map (
      clk                  => s_axi_aclk,
      reset_n              => s_axi_aresetn,
      int                  => uart_int,
      cpu_RXD              => cpu_RXD,
      cpu_TXD              => cpu_TXD,
      cpu_ADDR             => cpu_ADDR,
      cpu_WE               => cpu_WE,
      cpu_RE               => cpu_RE,
      uart_CONTROL         => uart_CONTROL,
      uart_STATUS          => uart_STATUS,
      uart_TICKS           => uart_TICKS,
      rxd                  => rxd,
      txd                  => txd
   );

   --
   -- INTERRUPTS
   --
   UART_IRQ_I: entity work.uart_irq
   generic map (
      C_NUM_INT            => 3
   )
   port map (
      clk                  => s_axi_aclk,
      reset_n              => s_axi_aresetn,
      int_req              => uart_INT_REQ,
      int_ack              => uart_INT_ACK,
      int                  => uart_int,
      irq                  => irq
   );

end rtl;
