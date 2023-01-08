library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fpga_ver.all;

entity stamp_regs is
   generic (
      C_S_AXI_DATA_WIDTH   : integer   := 32;
      C_S_AXI_ADDR_WIDTH   : integer   := 5
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
end stamp_regs;

architecture rtl of stamp_regs is

--
-- TYPES
--

--
-- CONSTANTS
--

constant C_NUM_REG         : integer := 8;

--
-- SIGNAL DECLARATIONS
--

signal wrCE                : std_logic_vector(C_NUM_REG-1 downto 0);
signal rdCE                : std_logic_vector(C_NUM_REG-1 downto 0);

signal stamp_TEST          : std_logic_vector(31 downto 0);

--
-- MAIN CODE
--
begin

   --
   -- COMBINATORIAL OUTPUTS
   --

   -- unsued AXI-Lite signals :
   -- s_axi_awprot, s_axi_arprot, s_axi_wstrb and
   s_axi_bresp    <= "00";
   s_axi_rresp    <= "00";

   --
   --  AXI-LITE WRITE SIGNALING
   --
   --
   --  WRITE ADDRESS AND DATA READY SIGNAL
   --
   process(all) begin
      if (s_axi_aresetn = '0') then
         s_axi_awready     <= '0';
      elsif rising_edge(s_axi_aclk) then
         if (s_axi_awready  = '0' and
            (s_axi_awvalid = '1' and s_axi_wvalid = '1') and
            (s_axi_bvalid  = '0' or  s_axi_bready = '1')) then
            s_axi_awready  <= '1';
         else
            s_axi_awready  <= '0';
         end if;
      end if;
   end process;

   s_axi_wready      <= s_axi_awready;

   --
   --  WRITE RETURN READY
   --
   process(all) begin
      if (s_axi_aresetn = '0') then
         s_axi_bvalid      <= '0';
      elsif rising_edge(s_axi_aclk) then
         if (s_axi_awready = '1') then
            s_axi_bvalid   <= '1';
         elsif (s_axi_bready = '1') then
            s_axi_bvalid   <= '0';
         end if;
     end if;
   end process;

   --
   --  AXI-LITE READ SIGNALING
   --

   s_axi_arready     <= not s_axi_rvalid;

   --
   --  READ VALID
   --
   process(all) begin
      if (s_axi_aresetn = '0') then
         s_axi_rvalid      <= '0';
      elsif rising_edge(s_axi_aclk) then
         if (s_axi_arvalid = '1' and s_axi_arready = '1') then
            s_axi_rvalid   <= '1';
         elsif (s_axi_rready = '1') then
            s_axi_rvalid   <= '0';
         end if;
     end if;
   end process;

   --
   -- READ-WRITE REGISTER STROBES
   --
   process (all) begin
      for i in 0 to wrCE'length-1 loop
         if (to_integer(unsigned(s_axi_awaddr(C_S_AXI_ADDR_WIDTH-1 downto 2))) = i and
             s_axi_awready = '1') then
            wrCE(i) <= '1';
         else
            wrCE(i) <= '0';
         end if;
      end loop;
      for i in 0 to rdCE'length-1 loop
         if (to_integer(unsigned(s_axi_araddr(C_S_AXI_ADDR_WIDTH-1 downto 2))) = i and
             (s_axi_rvalid = '1' or s_axi_rready = '1')) then
            rdCE(i) <= '1';
         else
            rdCE(i) <= '0';
         end if;
      end loop;
    end process;

   --
   -- WRITE REGISTERS
   --
   process (all) begin
      if (s_axi_aresetn = '0') then
         stamp_TEST     <= (others => '0');
      elsif (rising_edge(s_axi_aclk)) then
         if (wrCE(5) = '1') then
            stamp_TEST  <= s_axi_wdata;
         else
            stamp_TEST  <= stamp_TEST;
         end if;
      end if;
   end process;

   --
   -- READ REGISTERS
   --
   process (all) begin
      if (s_axi_aresetn = '0') then
         s_axi_rdata       <= (others => '0');
      elsif (rdCE(0) = '1') then
         s_axi_rdata    <= C_BUILD_SYSID;
      elsif (rdCE(1) = '1') then
         s_axi_rdata    <= C_BUILD_EPOCH_HEX;
      elsif (rdCe(2) = '1') then
         s_axi_rdata    <= C_BUILD_DATE_HEX;
      elsif (rdCE(3) = '1') then
         s_axi_rdata    <= C_BUILD_TIME_HEX;
      elsif (rdCE(4) = '1') then
         s_axi_rdata    <= C_BUILD_MAJOR & C_BUILD_MINOR & C_BUILD_NUM & C_BUILD_INC;
      elsif (rdCE(5) = '1') then
         s_axi_rdata    <= stamp_TEST;
      else
         s_axi_rdata    <= (others => '0');
      end if;
   end process;

end rtl;
