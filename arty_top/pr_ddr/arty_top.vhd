library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.lib_pkg.all;

entity arty_top is
   port(
      -- Global Signals
      clk12mhz             : in    std_logic;
      clk100mhz            : in    std_logic;
      ext_resetn           : in    std_logic;

      -- DRAM Interface
      ddr3_sdram_addr      : out   std_logic_vector(13 downto 0);
      ddr3_sdram_ba        : out   std_logic_vector(2 downto 0);
      ddr3_sdram_cas_n     : out   std_logic;
      ddr3_sdram_ck_n      : out   std_logic_vector(0 to 0);
      ddr3_sdram_ck_p      : out   std_logic_vector(0 to 0);
      ddr3_sdram_cke       : out   std_logic_vector(0 to 0);
      ddr3_sdram_cs_n      : out   std_logic_vector(0 to 0);
      ddr3_sdram_dm        : out   std_logic_vector(1 downto 0);
      ddr3_sdram_dq        : inout std_logic_vector(15 downto 0);
      ddr3_sdram_dqs_n     : inout std_logic_vector(1 downto 0);
      ddr3_sdram_dqs_p     : inout std_logic_vector(1 downto 0);
      ddr3_sdram_odt       : out   std_logic_vector(0 to 0);
      ddr3_sdram_ras_n     : out   std_logic;
      ddr3_sdram_reset_n   : out   std_logic;
      ddr3_sdram_we_n      : out   std_logic;

      -- CM UART
      iCM_UART_RXD         : in    std_logic;
      oCM_UART_TXD         : out   std_logic;
      
      -- STDOUT UART
      iSTDIO_UART_RXD      : in    std_logic;
      oSTDIO_UART_TXD      : out   std_logic;

      -- QSPI
      qspi_flash_io0_io    : inout std_logic;
      qspi_flash_io1_io    : inout std_logic;
      qspi_flash_io2_io    : inout std_logic;
      qspi_flash_io3_io    : inout std_logic;
      qspi_flash_ss_io     : inout std_logic;

      -- GPIO
      gpo_tri_o            : out   std_logic_vector(7 downto 0);
      gpi_tri_i            : in    std_logic_vector(3 downto 0);
      led0_rgb             : out   std_logic_vector(2 downto 0);
      led1_rgb             : out   std_logic_vector(2 downto 0);

      -- MICRO OLED
      oOLED_SCK            : out   std_logic;
      oOLED_MOSI           : out   std_logic;
      oOLED_SS             : out   std_logic;
      oOLED_RST            : out   std_logic;
      oOLED_DC             : out   std_logic;
      
      -- XADC
      vp_in                : in    std_logic;
      vn_in                : in    std_logic;
      vauxp0               : in    std_logic;
      vauxn0               : in    std_logic;
      vauxp1               : in    std_logic;
      vauxn1               : in    std_logic;
      vauxp2               : in    std_logic;
      vauxn2               : in    std_logic;
      vauxp8               : in    std_logic;
      vauxn8               : in    std_logic;
      vauxp9               : in    std_logic;
      vauxn9               : in    std_logic;
      vauxp10              : in    std_logic;
      vauxn10              : in    std_logic;
      vauxp11              : in    std_logic;
      vauxn11              : in    std_logic;

      -- Test Points
      hw_tp                : out   std_logic_vector(3 downto 0);
      sw_tp                : out   std_logic_vector(3 downto 0)

   );
end arty_top;

architecture rtl of arty_top is

--
-- CONSTANTS
--

--
-- COMPONENTS
--

--
-- SIGNAL DECLARATIONS
--

signal reset_cnt           : unsigned(10 downto 0);
signal sys_rst_n           : std_logic;
signal heartbeat_count     : unsigned(25 downto 0);
signal heartbeat           : std_logic;
signal watchdog            : std_logic;
signal watchdog_r0         : std_logic;

--
-- MAIN CODE
--

begin

   --
   -- COMBINATORIAL OUTPUTS
   --

   led1_rgb(0)          <= '0';
   led1_rgb(1)          <= heartbeat;
   led1_rgb(2)          <= '0';
   led0_rgb(0)          <= '0';
   led0_rgb(1)          <= '0';
   led0_rgb(2)          <= '0';

   hw_tp(0)             <= heartbeat;
   hw_tp(1)             <= watchdog;
   hw_tp(2)             <= sys_rst_n;
   hw_tp(3)             <= '0';

   --
   -- VIVADO BLOCK DESIGN
   --
   u0 : entity work.mb_design_wrapper
      port map (
         clk100mhz                     => clk100mhz,
         ddr3_sdram_addr(13 downto 0)  => ddr3_sdram_addr(13 downto 0),
         ddr3_sdram_ba(2 downto 0)     => ddr3_sdram_ba(2 downto 0),
         ddr3_sdram_cas_n              => ddr3_sdram_cas_n,
         ddr3_sdram_ck_n(0)            => ddr3_sdram_ck_n(0),
         ddr3_sdram_ck_p(0)            => ddr3_sdram_ck_p(0),
         ddr3_sdram_cke(0)             => ddr3_sdram_cke(0),
         ddr3_sdram_cs_n(0)            => ddr3_sdram_cs_n(0),
         ddr3_sdram_dm(1 downto 0)     => ddr3_sdram_dm(1 downto 0),
         ddr3_sdram_dq(15 downto 0)    => ddr3_sdram_dq(15 downto 0),
         ddr3_sdram_dqs_n(1 downto 0)  => ddr3_sdram_dqs_n(1 downto 0),
         ddr3_sdram_dqs_p(1 downto 0)  => ddr3_sdram_dqs_p(1 downto 0),
         ddr3_sdram_odt(0)             => ddr3_sdram_odt(0),
         ddr3_sdram_ras_n              => ddr3_sdram_ras_n,
         ddr3_sdram_reset_n            => ddr3_sdram_reset_n,
         ddr3_sdram_we_n               => ddr3_sdram_we_n,
         gpo_tri_o                     => gpo_tri_o,
         gpi_tri_i                     => gpi_tri_i,
         oled_tri_o(0)                 => oOLED_SCK,
         oled_tri_o(1)                 => oOLED_MOSI,
         oled_tri_o(2)                 => oOLED_SS,
         oled_tri_o(3)                 => oOLED_RST,
         oled_tri_o(4)                 => oOLED_DC,
         sw_tp_tri_o                   => sw_tp,
         qspi_flash_io0_io             => qspi_flash_io0_io,
         qspi_flash_io1_io             => qspi_flash_io1_io,
         qspi_flash_io2_io             => qspi_flash_io2_io,
         qspi_flash_io3_io             => qspi_flash_io3_io,
         qspi_flash_ss_io              => qspi_flash_ss_io,
         resetn                        => sys_rst_n,
         watchdog                      => watchdog,
         Vp_Vn_0_v_n                   => vn_in,
         Vp_Vn_0_v_p                   => vp_in,
         Vaux0_0_v_n                   => vauxn0,
         Vaux0_0_v_p                   => vauxp0,
         Vaux1_0_v_n                   => vauxn1,
         Vaux1_0_v_p                   => vauxp1,
         Vaux2_0_v_n                   => vauxn2,
         Vaux2_0_v_p                   => vauxp2,
         Vaux8_0_v_n                   => vauxn8,
         Vaux8_0_v_p                   => vauxp8,
         Vaux9_0_v_n                   => vauxn9,
         Vaux9_0_v_p                   => vauxp9,
         Vaux10_0_v_n                  => vauxn10,
         Vaux10_0_v_p                  => vauxp10,
         Vaux11_0_v_n                  => vauxn11,
         Vaux11_0_v_p                  => vauxp11,
         cm_uart_rxd                   => iCM_UART_RXD,
         cm_uart_txd                   => oCM_UART_TXD,
         stdio_uart_rxd                => iSTDIO_UART_RXD,
         stdio_uart_txd                => oSTDIO_UART_TXD
      );

   --
   -- System Reset, 100MHZ
   --
   process(ext_resetn, clk100mhz) begin
      if (ext_resetn = '0') then
          reset_cnt        <= (others => '0');
          sys_rst_n        <= '0';
      elsif (rising_edge(clk100mhz)) then
         watchdog_r0       <= watchdog;
         if (watchdog_r0 = '0' and watchdog = '1') then
          reset_cnt        <= (others => '0');
          sys_rst_n        <= '0';
         -- hold reset low for ~10 microseconds then set high
         elsif (reset_cnt(10) = '1') then
            sys_rst_n      <= '1';
         else
            sys_rst_n      <= '0';
            reset_cnt      <= reset_cnt + 1;
         end if;
      end if;
   end process;

   --
   -- Heartbeat, 100MHZ
   --
   process(sys_rst_n, clk100mhz) begin
      if (sys_rst_n = '0') then
          heartbeat_count     <= (others => '0');
          heartbeat           <= '0';
      elsif (rising_edge(clk100mhz)) then
          if (heartbeat_count(24) = '1') then
              heartbeat_count <= (others => '0');
              heartbeat       <= not heartbeat;
          else
              heartbeat_count <= heartbeat_count + 1;
          end if;
      end if;
   end process;

end rtl;