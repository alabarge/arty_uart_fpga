library ieee;
use ieee.std_logic_1164.all;

package fpga_ver is

   constant C_BUILD_MAJOR     : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_MINOR     : std_logic_vector(7 downto 0)   := X"00";
   constant C_BUILD_NUM       : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_INC       : std_logic_vector(7 downto 0)   := X"04";
   constant C_BUILD_SYSID     : std_logic_vector(31 downto 0)  := X"00000401";
   constant C_BUILD_PID       : std_logic_vector(7 downto 0)   := X"00";
   constant C_BUILD_MAP       : std_logic_vector(11 downto 0)  := X"000";
   constant C_BUILD_LOGIC     : std_logic_vector(11 downto 0)  := X"000";
   constant C_BUILD_MAP_DATE  : std_logic_vector(31 downto 0)  := X"00000000";
   constant C_BUILD_VER_HEX   : std_logic_vector(31 downto 0)  := X"01000104";
   constant C_BUILD_TIME      : string                         := "08:27";
   constant C_BUILD_DATE      : string                         := "30.JUN.23";
   constant C_BUILD_USER      : string                         := "Aaron";
   constant C_BUILD_STR       : string                         := "1.0.1.4";
   constant C_BUILD_LO        : string                         := "1.0.1 build 4";
   constant C_BUILD_HI        : string                         := "1.0.1 build 4, 08:27 30.JUN.23 0x00000401 [Aaron] 279d1e27e59c42cc*";
   constant C_BUILD_STRING    : string                         := " (2023/06/30)";
   constant C_BUILD_EPOCH     : integer                        := 1688138847;
   constant C_BUILD_EPOCH_HEX : std_logic_vector(31 downto 0)  := X"649EF45F";
   constant C_BUILD_DATE_HEX  : std_logic_vector(31 downto 0)  := X"20230630";
   constant C_BUILD_TIME_HEX  : std_logic_vector(31 downto 0)  := X"00082727";
   constant C_BUILD_GIT_REV   : string                         := "279d1e27e59c42cc*";
   constant C_BUILD_GIT_AUTH  : string                         := "Aaron ";
   constant C_BUILD_GIT_EMAIL : string                         := "aaron@omniware.us";
   constant C_BUILD_GIT_DATE  : string                         := "  Mon Jun 12 15:53:15 2023 -0700";

end fpga_ver;
