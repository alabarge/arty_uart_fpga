library ieee;
use ieee.std_logic_1164.all;

package fpga_ver is

   constant C_BUILD_MAJOR     : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_MINOR     : std_logic_vector(7 downto 0)   := X"00";
   constant C_BUILD_NUM       : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_INC       : std_logic_vector(7 downto 0)   := X"03";
   constant C_BUILD_SYSID     : std_logic_vector(31 downto 0)  := X"00000401";
   constant C_BUILD_VER_HEX   : std_logic_vector(31 downto 0)  := X"01000103";
   constant C_BUILD_TIME      : string                         := "12:20";
   constant C_BUILD_DATE      : string                         := "15.JAN.23";
   constant C_BUILD_USER      : string                         := "Aaron";
   constant C_BUILD_STR       : string                         := "1.0.1.3";
   constant C_BUILD_LO        : string                         := "1.0.1 build 3";
   constant C_BUILD_HI        : string                         := "1.0.1 build 3, 12:20 15.JAN.23 0x00000401 [Aaron] 9aad47f3843cb1c2*";
   constant C_BUILD_STRING    : string                         := " (2023/01/15)";
   constant C_BUILD_EPOCH     : integer                        := 1673814050;
   constant C_BUILD_EPOCH_HEX : std_logic_vector(31 downto 0)  := X"63C46022";
   constant C_BUILD_DATE_HEX  : std_logic_vector(31 downto 0)  := X"20230115";
   constant C_BUILD_TIME_HEX  : std_logic_vector(31 downto 0)  := X"00122050";
   constant C_BUILD_GIT_REV   : string                         := "9aad47f3843cb1c2*";
   constant C_BUILD_GIT_AUTH  : string                         := "Aaron ";
   constant C_BUILD_GIT_EMAIL : string                         := "aaron@omniware.us";
   constant C_BUILD_GIT_DATE  : string                         := "  Sat Jan 14 07:45:50 2023 -0800";

end fpga_ver;
