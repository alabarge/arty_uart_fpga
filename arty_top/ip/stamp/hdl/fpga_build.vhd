library ieee;
use ieee.std_logic_1164.all;

package fpga_ver is

   constant C_BUILD_PID       : std_logic_vector(7 downto 0)   := X"1E";
   constant C_BUILD_MAP       : std_logic_vector(11 downto 0)  := X"001";
   constant C_BUILD_LOGIC     : std_logic_vector(11 downto 0)  := X"003";
   constant C_BUILD_INC       : std_logic_vector(7 downto 0)   := X"06";
   constant C_BUILD_MAP_DATE  : std_logic_vector(31 downto 0)  := X"20230720";
   constant C_BUILD_VER_HEX   : std_logic_vector(31 downto 0)  := X"1E001003";
   constant C_BUILD_TIME      : string                         := "11:49";
   constant C_BUILD_DATE      : string                         := "20.JUL.23";
   constant C_BUILD_USER      : string                         := "Aaron";
   constant C_BUILD_STR       : string                         := "30.1.3.6";
   constant C_BUILD_LO        : string                         := "30.1.3 build 6";
   constant C_BUILD_HI        : string                         := "30.1.3 build 6, 11:49 20.JUL.23 [Aaron] fa7172b6c591bf80*";
   constant C_BUILD_STRING    : string                         := " (2023/07/20)";
   constant C_BUILD_EPOCH     : integer                        := 1689878952;
   constant C_BUILD_EPOCH_HEX : std_logic_vector(31 downto 0)  := X"64B981A8";
   constant C_BUILD_DATE_HEX  : std_logic_vector(31 downto 0)  := X"20230720";
   constant C_BUILD_TIME_HEX  : std_logic_vector(31 downto 0)  := X"00114912";
   constant C_BUILD_GIT_REV   : string                         := "fa7172b6c591bf80*";
   constant C_BUILD_GIT_AUTH  : string                         := "Aaron ";
   constant C_BUILD_GIT_EMAIL : string                         := "aaron@omniware.us";
   constant C_BUILD_GIT_DATE  : string                         := "  Thu Jul 20 08:56:22 2023 -0700";

end fpga_ver;
