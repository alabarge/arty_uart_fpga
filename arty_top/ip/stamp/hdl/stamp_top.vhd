library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stamp_top is
   generic (
      C_S_AXI_DATA_WIDTH   : integer   := 32;
      C_S_AXI_ADDR_WIDTH   : integer   := 16
   );
   port (
      s_axi_aclk        : in    std_logic;
      s_axi_aresetn     : in    std_logic;
      s_axi_awaddr      : in    std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      s_axi_awprot      : in    std_logic_vector(2 downto 0);
      s_axi_awvalid     : in    std_logic;
      s_axi_awready     : out   std_logic;
      s_axi_wdata       : in    std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      s_axi_wstrb       : in    std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
      s_axi_wvalid      : in    std_logic;
      s_axi_wready      : out   std_logic;
      s_axi_bresp       : out   std_logic_vector(1 downto 0);
      s_axi_bvalid      : out   std_logic;
      s_axi_bready      : in    std_logic;
      s_axi_araddr      : in    std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      s_axi_arprot      : in    std_logic_vector(2 downto 0);
      s_axi_arvalid     : in    std_logic;
      s_axi_arready     : out   std_logic;
      s_axi_rdata       : out   std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      s_axi_rresp       : out   std_logic_vector(1 downto 0);
      s_axi_rvalid      : out   std_logic;
      s_axi_rready      : in    std_logic
   );
end stamp_top;

architecture rtl of stamp_top is

--
-- SIGNAL DECLARATIONS
--

--
-- MAIN CODE
--
begin

   --
   -- COMBINATORIAL OUTPUTS
   --

   --
   -- REGISTER FILE
   --
   STAMP_REGS_I: entity work.stamp_regs
   generic map (
      C_S_AXI_DATA_WIDTH   => C_S_AXI_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH   => C_S_AXI_ADDR_WIDTH
   )
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
      s_axi_rready      => s_axi_rready
   );

end rtl;
