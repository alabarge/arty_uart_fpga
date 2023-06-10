library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_regs is
   generic (
      C_S_AXI_DATA_WIDTH   : integer   := 32;
      C_S_AXI_ADDR_WIDTH   : integer   := 16
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
      cpu_RXD              : in    std_logic_vector(7 downto 0);
      cpu_TXD              : out   std_logic_vector(7 downto 0);
      cpu_ADDR             : out   std_logic_vector(11 downto 0);
      cpu_WE               : out   std_logic;
      cpu_RE               : out   std_logic;
      uart_CONTROL         : out   std_logic_vector(31 downto 0);
      uart_INT_REQ         : in    std_logic_vector(2 downto 0);
      uart_INT_ACK         : out   std_logic_vector(2 downto 0);
      uart_STATUS          : in    std_logic_vector(31 downto 0);
      uart_TICKS           : out   std_logic_vector(15 downto 0);
      uart_PTR_STA         : in    std_logic_vector(31 downto 0);
      uart_PTR_CTL         : out   std_logic_vector(31 downto 0)
   );
end uart_regs;

architecture rtl of uart_regs is

--
-- CONSTANTS
--
constant C_UART_VERSION    : std_logic_vector(7 downto 0)  := X"02";

-- default is enable
constant C_UART_CONTROL    : std_logic_vector(31 downto 0) := X"80000000";

-- 81.247969MHz / 115200 baudrate
constant C_UART_TICKS      : std_logic_vector(15 downto 0) := X"02C1";

constant C_NUM_REG         : integer := 8;

--
-- SIGNAL DECLARATIONS
--

signal wrCE                : std_logic_vector(C_NUM_REG-1 downto 0);
signal rdCE                : std_logic_vector(C_NUM_REG-1 downto 0);

signal axi_rvalid_cnt      : integer range 0 to 3;

--
-- MAIN CODE
--
begin

   --
   -- COMBINATORIAL OUTPUTS
   --

   -- Read/Write BlockRAM
   cpu_TXD              <= s_axi_wdata(7 downto 0);
   cpu_ADDR             <= s_axi_awaddr(13 downto 2);

   cpu_WE               <= '1' when (s_axi_awaddr(12) = '1' and s_axi_awready = '1') else '0';
   cpu_RE               <= '1' when (s_axi_araddr(12) = '1' and (s_axi_rvalid = '1' or s_axi_rready = '1')) else '0';

   -- unsued AXI-Lite signals :
   -- s_axi_awprot, s_axi_arprot, s_axi_wstrb and
   s_axi_bresp          <= "00";
   s_axi_rresp          <= "00";

   --
   --  AXI-LITE WRITE SIGNALING
   --

   s_axi_wready         <= s_axi_awready;

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
   --  READ VALID, DELAYED BY TWO CLOCKS
   --
   process(all) begin
      if (s_axi_aresetn = '0') then
         s_axi_rvalid      <= '0';
         axi_rvalid_cnt    <= 0;
      elsif rising_edge(s_axi_aclk) then
         if (s_axi_arvalid = '1' and s_axi_arready = '1' and
             axi_rvalid_cnt = 0) then
            axi_rvalid_cnt  <= axi_rvalid_cnt + 1;
         elsif (axi_rvalid_cnt = 1) then
            axi_rvalid_cnt  <= axi_rvalid_cnt + 1;
         elsif (axi_rvalid_cnt = 2) then
            s_axi_rvalid    <= '1';
            axi_rvalid_cnt  <= 0;
         else
            s_axi_rvalid    <= '0';
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
         uart_CONTROL         <= C_UART_CONTROL;
         uart_INT_ACK         <= (others => '0');
         uart_TICKS           <= C_UART_TICKS;
         uart_PTR_CTL         <= (others => '0');
      elsif (rising_edge(s_axi_aclk)) then
         if (wrCE(0) = '1') then
            uart_CONTROL      <= s_axi_wdata;
         elsif (wrCE(3) = '1') then
            uart_INT_ACK      <= s_axi_wdata(2 downto 0);
         elsif (wrCE(4) = '1') then
            uart_TICKS        <= s_axi_wdata(15 downto 0);
         elsif (wrCE(6) = '1') then
            uart_PTR_CTL      <= s_axi_wdata;
         else
            uart_CONTROL      <= uart_CONTROL;
            uart_INT_ACK      <= (others => '0');
            uart_TICKS        <= uart_TICKS;
            uart_PTR_CTL      <= uart_PTR_CTL;
         end if;
      end if;
   end process;

   --
   -- READ REGISTERS AND BLOCKRAM
   --
   process (all) begin
      if (s_axi_aresetn = '0') then
         s_axi_rdata       <= (others => '0');
      elsif (rdCE(0) = '1') then
         s_axi_rdata       <= uart_CONTROL;
      elsif (rdCE(1) = '1') then
         s_axi_rdata       <= uart_STATUS;
      elsif (rdCE(2) = '1') then
         s_axi_rdata       <= X"000000" & C_UART_VERSION;
      elsif (rdCE(3) = '1') then
         s_axi_rdata       <= X"0000000" & '0' & uart_INT_REQ;
      elsif (rdCE(4) = '1') then
         s_axi_rdata       <= X"0000" & uart_TICKS;
      elsif (rdCE(5) = '1') then
         s_axi_rdata       <= uart_PTR_STA;
      elsif (rdCE(6) = '1') then
         s_axi_rdata       <= uart_PTR_CTL;
      --
      -- READ BLOCKRAM
      --
      elsif (cpu_RE = '1') then
         s_axi_rdata       <= X"000000" & cpu_RXD;
      else
         s_axi_rdata       <= (others => '0');
      end if;
   end process;

end rtl;
