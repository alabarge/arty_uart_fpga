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
   constant C_BUILD_TIME      : string                         := "08:21";
   constant C_BUILD_DATE      : string                         := "10.JUN.23";
   constant C_BUILD_USER      : string                         := "Aaron";
   constant C_BUILD_STR       : string                         := "1.0.1.2";
   constant C_BUILD_LO        : string                         := "1.0.1 build 2";
   constant C_BUILD_HI        : string                         := "1.0.1 build 2, 08:21 10.JUN.23 0x00000401 [Aaron] 787cd59c1a891c18*";
   constant C_BUILD_STRING    : string                         := " (2023/06/10)";
   constant C_BUILD_EPOCH     : integer                        := 1686410478;
   constant C_BUILD_EPOCH_HEX : std_logic_vector(31 downto 0)  := X"648494EE";
   constant C_BUILD_DATE_HEX  : std_logic_vector(31 downto 0)  := X"20230610";
   constant C_BUILD_TIME_HEX  : std_logic_vector(31 downto 0)  := X"00082118";
   constant C_BUILD_GIT_REV   : string                         := "787cd59c1a891c18*";
   constant C_BUILD_GIT_AUTH  : string                         := "Aaron ";
   constant C_BUILD_GIT_EMAIL : string                         := "aaron@omniware.us";
   constant C_BUILD_GIT_DATE  : string                         := "  Sat Jun 10 06:55:47 2023 -0700";

end fpga_ver;
