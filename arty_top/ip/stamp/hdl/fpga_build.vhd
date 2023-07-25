library ieee;
use ieee.std_logic_1164.all;

package fpga_ver is

   constant C_BUILD_PID       : std_logic_vector(7 downto 0)   := X"1E";
   constant C_BUILD_MAP       : std_logic_vector(11 downto 0)  := X"001";
   constant C_BUILD_LOGIC     : std_logic_vector(11 downto 0)  := X"003";
   constant C_BUILD_INC       : std_logic_vector(7 downto 0)   := X"07";
   constant C_BUILD_MAP_DATE  : std_logic_vector(31 downto 0)  := X"20230720";
   constant C_BUILD_VER_HEX   : std_logic_vector(31 downto 0)  := X"1E001003";
   constant C_BUILD_TIME      : string                         := "08:33";
   constant C_BUILD_DATE      : string                         := "22.JUL.23";
   constant C_BUILD_USER      : string                         := "Aaron";
   constant C_BUILD_STR       : string                         := "30.1.3.7";
   constant C_BUILD_LO        : string                         := "30.1.3 build 7";
   constant C_BUILD_HI        : string                         := "30.1.3 build 7, 08:33 22.JUL.23 [Aaron] 67baf32557c6d55c*";
   constant C_BUILD_STRING    : string                         := " (2023/07/22)";
   constant C_BUILD_EPOCH     : integer                        := 1690039990;
   constant C_BUILD_EPOCH_HEX : std_logic_vector(31 downto 0)  := X"64BBF6B6";
   constant C_BUILD_DATE_HEX  : std_logic_vector(31 downto 0)  := X"20230722";
   constant C_BUILD_TIME_HEX  : std_logic_vector(31 downto 0)  := X"00083310";
   constant C_BUILD_GIT_REV   : string                         := "67baf32557c6d55c*";
   constant C_BUILD_GIT_AUTH  : string                         := "Aaron ";
   constant C_BUILD_GIT_EMAIL : string                         := "aaron@omniware.us";
   constant C_BUILD_GIT_DATE  : string                         := "  Sat Jul 22 08:29:29 2023 -0700";

end fpga_ver;
