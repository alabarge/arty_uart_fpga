library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arty_top_tb is
end arty_top_tb;

architecture rtl of arty_top_tb is

--
-- CONSTANTS
--

--
-- COMPONENTS
--

--
-- SIGNAL DECLARATIONS
--

signal CLK12MHZ            : std_logic    := '0';
signal sys_clk_i           : std_logic    := '0';
signal reset               : std_logic    := '0';
signal ddr3_sdram_addr     : std_logic_vector(13 downto 0)  := (others => '0');
signal ddr3_sdram_ba       : std_logic_vector(2 downto 0)   := (others => '0');
signal ddr3_sdram_cas_n    : std_logic;
signal ddr3_sdram_ck_n     : std_logic_vector(0 to 0)       := (others => '0');
signal ddr3_sdram_ck_p     : std_logic_vector(0 to 0)       := (others => '0');
signal ddr3_sdram_cke      : std_logic_vector(0 to 0)       := (others => '0');
signal ddr3_sdram_cs_n     : std_logic_vector(0 to 0)       := (others => '0');
signal ddr3_sdram_dm       : std_logic_vector(1 downto 0)   := (others => '0');
signal ddr3_sdram_dq       : std_logic_vector(15 downto 0)  := (others => '0');
signal ddr3_sdram_dqs_n    : std_logic_vector(1 downto 0)   := (others => '0');
signal ddr3_sdram_dqs_p    : std_logic_vector(1 downto 0)   := (others => '0');
signal ddr3_sdram_odt      : std_logic_vector(0 to 0)       := (others => '0');
signal ddr3_sdram_ras_n    : std_logic    := '0';
signal ddr3_sdram_reset_n  : std_logic    := '0';
signal ddr3_sdram_we_n     : std_logic    := '0';
signal iUART_RXD           : std_logic    := '0';
signal oUART_TXD           : std_logic    := '0';
signal iUART_STDOUT_RXD    : std_logic    := '0';
signal oUART_STDOUT_TXD    : std_logic    := '0';
signal qspi_flash_io0_io   : std_logic    := '0';
signal qspi_flash_io1_io   : std_logic    := '0';
signal qspi_flash_io2_io   : std_logic    := '0';
signal qspi_flash_io3_io   : std_logic    := '0';
signal qspi_flash_ss_io    : std_logic    := '0';
signal led_4bits_tri_o     : std_logic_vector(3 downto 0)   := (others => '0');
signal led0_rgb            : std_logic_vector(2 downto 0)   := (others => '0');
signal led1_rgb            : std_logic_vector(2 downto 0)   := (others => '0');
signal vp_in               : std_logic    := '0';
signal vn_in               : std_logic    := '0';
signal vauxp0              : std_logic    := '0';
signal vauxn0              : std_logic    := '0';
signal vauxp1              : std_logic    := '0';
signal vauxn1              : std_logic    := '0';
signal vauxp2              : std_logic    := '0';
signal vauxn2              : std_logic    := '0';
signal vauxp8              : std_logic    := '0';
signal vauxn8              : std_logic    := '0';
signal vauxp9              : std_logic    := '0';
signal vauxn9              : std_logic    := '0';
signal vauxp10             : std_logic    := '0';
signal vauxn10             : std_logic    := '0';
signal vauxp3              : std_logic    := '0';
signal vauxn3              : std_logic    := '0';
signal tp1                 : std_logic    := '0';
signal tp2                 : std_logic    := '0';
signal tp3                 : std_logic    := '0';
signal tp4                 : std_logic    := '0';


--
-- MAIN CODE
--

begin

   CLK12MHZ             <= not CLK12MHZ after 83.333 ns;
   sys_clk_i            <= not sys_clk_i after 5 ns;
   reset                <= '1' after 100 ns;

   --
   -- COMBINATORIAL OUTPUTS
   --

   --
   -- VIVADO BLOCK DESIGN
   --
   fpga : entity work.arty_top
      port map (
         CLK12MHZ                      => CLK12MHZ,
         sys_clk_i                     => sys_clk_i,
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
         led_4bits_tri_o(3 downto 0)   => led_4bits_tri_o,
         qspi_flash_io0_io             => qspi_flash_io0_io,
         qspi_flash_io1_io             => qspi_flash_io1_io,
         qspi_flash_io2_io             => qspi_flash_io2_io,
         qspi_flash_io3_io             => qspi_flash_io3_io,
         qspi_flash_ss_io              => qspi_flash_ss_io,
         reset                         => reset,
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
         Vaux3_0_v_n                   => vauxn3,
         Vaux3_0_v_p                   => vauxp3,
         iUART_RXD                     => iUART_RXD,
         oUART_TXD                     => oUART_TXD,
         iUART_STDOUT_RXD              => iUART_STDOUT_RXD,
         oUART_STDOUT_TXD              => oUART_STDOUT_TXD
      );

end rtl;