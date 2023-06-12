library ieee;
use ieee.std_logic_1164.all;

package fpga_ver is

   constant C_BUILD_MAJOR     : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_MINOR     : std_logic_vector(7 downto 0)   := X"00";
   constant C_BUILD_NUM       : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_INC       : std_logic_vector(7 downto 0)   := X"03";
   constant C_BUILD_SYSID     : std_logic_vector(31 downto 0)  := X"00000401";
   constant C_BUILD_PID       : std_logic_vector(7 downto 0)   := X"00";
   constant C_BUILD_MAP       : std_logic_vector(11 downto 0)  := X"000";
   constant C_BUILD_LOGIC     : std_logic_vector(11 downto 0)  := X"000";
   constant C_BUILD_MAP_DATE  : std_logic_vector(31 downto 0)  := X"00000000";
   constant C_BUILD_VER_HEX   : std_logic_vector(31 downto 0)  := X"01000103";
   constant C_BUILD_TIME      : string                         := "13:44";
   constant C_BUILD_DATE      : string                         := "12.JUN.23";
   constant C_BUILD_USER      : string                         := "Aaron";
   constant C_BUILD_STR       : string                         := "1.0.1.3";
   constant C_BUILD_LO        : string                         := "1.0.1 build 3";
   constant C_BUILD_HI        : string                         := "1.0.1 build 3, 13:44 12.JUN.23 0x00000401 [Aaron] 96cd518290b0ca68*";
   constant C_BUILD_STRING    : string                         := " (2023/06/12)";
   constant C_BUILD_EPOCH     : integer                        := 1686602691;
   constant C_BUILD_EPOCH_HEX : std_logic_vector(31 downto 0)  := X"648783C3";
   constant C_BUILD_DATE_HEX  : std_logic_vector(31 downto 0)  := X"20230612";
   constant C_BUILD_TIME_HEX  : std_logic_vector(31 downto 0)  := X"00134451";
   constant C_BUILD_GIT_REV   : string                         := "96cd518290b0ca68*";
   constant C_BUILD_GIT_AUTH  : string                         := "Aaron ";
   constant C_BUILD_GIT_EMAIL : string                         := "aaron@omniware.us";
   constant C_BUILD_GIT_DATE  : string                         := "  Sat Jun 10 09:21:32 2023 -0700";

end fpga_ver;
