library ieee;
use ieee.std_logic_1164.all;

package fpga_ver is

   constant C_BUILD_MAJOR     : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_MINOR     : std_logic_vector(7 downto 0)   := X"00";
   constant C_BUILD_NUM       : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_INC       : std_logic_vector(7 downto 0)   := X"05";
   constant C_BUILD_SYSID     : std_logic_vector(31 downto 0)  := X"00000401";
   constant C_BUILD_PID       : std_logic_vector(7 downto 0)   := X"00";
   constant C_BUILD_MAP       : std_logic_vector(11 downto 0)  := X"000";
   constant C_BUILD_LOGIC     : std_logic_vector(11 downto 0)  := X"000";
   constant C_BUILD_MAP_DATE  : std_logic_vector(31 downto 0)  := X"00000000";
   constant C_BUILD_VER_HEX   : std_logic_vector(31 downto 0)  := X"01000105";
   constant C_BUILD_TIME      : string                         := "09:40";
   constant C_BUILD_DATE      : string                         := "13.MAR.23";
   constant C_BUILD_USER      : string                         := "Aaron";
   constant C_BUILD_STR       : string                         := "1.0.1.5";
   constant C_BUILD_LO        : string                         := "1.0.1 build 5";
   constant C_BUILD_HI        : string                         := "1.0.1 build 5, 09:40 13.MAR.23 0x00000401 [Aaron] 70f5293310aa6cc0*";
   constant C_BUILD_STRING    : string                         := " (2023/03/13)";
   constant C_BUILD_EPOCH     : integer                        := 1678725625;
   constant C_BUILD_EPOCH_HEX : std_logic_vector(31 downto 0)  := X"640F51F9";
   constant C_BUILD_DATE_HEX  : std_logic_vector(31 downto 0)  := X"20230313";
   constant C_BUILD_TIME_HEX  : std_logic_vector(31 downto 0)  := X"00094025";
   constant C_BUILD_GIT_REV   : string                         := "70f5293310aa6cc0*";
   constant C_BUILD_GIT_AUTH  : string                         := "Aaron ";
   constant C_BUILD_GIT_EMAIL : string                         := "aaron@omniware.us";
   constant C_BUILD_GIT_DATE  : string                         := "  Sat Mar 4 06:58:17 2023 -0800";

end fpga_ver;
