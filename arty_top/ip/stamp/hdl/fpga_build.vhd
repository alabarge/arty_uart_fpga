library ieee;
use ieee.std_logic_1164.all;

package fpga_ver is

   constant C_BUILD_MAJOR     : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_MINOR     : std_logic_vector(7 downto 0)   := X"00";
   constant C_BUILD_NUM       : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_INC       : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_SYSID     : std_logic_vector(31 downto 0)  := X"00000401";
   constant C_BUILD_PID       : std_logic_vector(7 downto 0)   := X"00";
   constant C_BUILD_MAP       : std_logic_vector(11 downto 0)  := X"000";
   constant C_BUILD_LOGIC     : std_logic_vector(11 downto 0)  := X"000";
   constant C_BUILD_MAP_DATE  : std_logic_vector(31 downto 0)  := X"00000000";
   constant C_BUILD_VER_HEX   : std_logic_vector(31 downto 0)  := X"01000101";
   constant C_BUILD_TIME      : string                         := "09:55";
   constant C_BUILD_DATE      : string                         := "07.JUN.23";
   constant C_BUILD_USER      : string                         := "Aaron";
   constant C_BUILD_STR       : string                         := "1.0.1.1";
   constant C_BUILD_LO        : string                         := "1.0.1 build 1";
   constant C_BUILD_HI        : string                         := "1.0.1 build 1, 09:55 07.JUN.23 0x00000401 [Aaron] 8b2955ee280f254a*";
   constant C_BUILD_STRING    : string                         := " (2023/06/07)";
   constant C_BUILD_EPOCH     : integer                        := 1686156927;
   constant C_BUILD_EPOCH_HEX : std_logic_vector(31 downto 0)  := X"6480B67F";
   constant C_BUILD_DATE_HEX  : std_logic_vector(31 downto 0)  := X"20230607";
   constant C_BUILD_TIME_HEX  : std_logic_vector(31 downto 0)  := X"00095527";
   constant C_BUILD_GIT_REV   : string                         := "8b2955ee280f254a*";
   constant C_BUILD_GIT_AUTH  : string                         := "Aaron ";
   constant C_BUILD_GIT_EMAIL : string                         := "aaron@omniware.us";
   constant C_BUILD_GIT_DATE  : string                         := "  Tue Jun 6 10:09:16 2023 -0700";

end fpga_ver;
