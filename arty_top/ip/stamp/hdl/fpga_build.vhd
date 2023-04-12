library ieee;
use ieee.std_logic_1164.all;

package fpga_ver is

   constant C_BUILD_MAJOR     : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_MINOR     : std_logic_vector(7 downto 0)   := X"00";
   constant C_BUILD_NUM       : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_INC       : std_logic_vector(7 downto 0)   := X"02";
   constant C_BUILD_SYSID     : std_logic_vector(31 downto 0)  := X"00000401";
   constant C_BUILD_PID       : std_logic_vector(7 downto 0)   := X"00";
   constant C_BUILD_MAP       : std_logic_vector(11 downto 0)  := X"000";
   constant C_BUILD_LOGIC     : std_logic_vector(11 downto 0)  := X"000";
   constant C_BUILD_MAP_DATE  : std_logic_vector(31 downto 0)  := X"00000000";
   constant C_BUILD_VER_HEX   : std_logic_vector(31 downto 0)  := X"01000102";
   constant C_BUILD_TIME      : string                         := "07:19";
   constant C_BUILD_DATE      : string                         := "12.APR.23";
   constant C_BUILD_USER      : string                         := "Aaron";
   constant C_BUILD_STR       : string                         := "1.0.1.2";
   constant C_BUILD_LO        : string                         := "1.0.1 build 2";
   constant C_BUILD_HI        : string                         := "1.0.1 build 2, 07:19 12.APR.23 0x00000401 [Aaron] 8ffdd9c97ae54cb3*";
   constant C_BUILD_STRING    : string                         := " (2023/04/12)";
   constant C_BUILD_EPOCH     : integer                        := 1681309190;
   constant C_BUILD_EPOCH_HEX : std_logic_vector(31 downto 0)  := X"6436BE06";
   constant C_BUILD_DATE_HEX  : std_logic_vector(31 downto 0)  := X"20230412";
   constant C_BUILD_TIME_HEX  : std_logic_vector(31 downto 0)  := X"00071950";
   constant C_BUILD_GIT_REV   : string                         := "8ffdd9c97ae54cb3*";
   constant C_BUILD_GIT_AUTH  : string                         := "Aaron ";
   constant C_BUILD_GIT_EMAIL : string                         := "aaron@omniware.us";
   constant C_BUILD_GIT_DATE  : string                         := "  Wed Mar 15 16:03:01 2023 -0700";

end fpga_ver;
