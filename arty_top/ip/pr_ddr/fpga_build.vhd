library ieee;
use ieee.std_logic_1164.all;

package fpga_ver is

   constant C_BUILD_MAJOR     : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_MINOR     : std_logic_vector(7 downto 0)   := X"00";
   constant C_BUILD_NUM       : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_INC       : std_logic_vector(7 downto 0)   := X"01";
   constant C_BUILD_SYSID     : std_logic_vector(31 downto 0)  := X"00000401";
   constant C_BUILD_VER_HEX   : std_logic_vector(31 downto 0)  := X"01000101";
   constant C_BUILD_TIME      : string                         := "08:30";
   constant C_BUILD_DATE      : string                         := "28.DEC.22";
   constant C_BUILD_USER      : string                         := "Aaron";
   constant C_BUILD_STR       : string                         := "1.0.1.1";
   constant C_BUILD_LO        : string                         := "1.0.1 build 1";
   constant C_BUILD_HI        : string                         := "1.0.1 build 1, 08:30 28.DEC.22 0x00000401 [Aaron] ";
   constant C_BUILD_STRING    : string                         := " (2022/12/28)";
   constant C_BUILD_EPOCH     : integer                        := 1672245027;
   constant C_BUILD_EPOCH_HEX : std_logic_vector(31 downto 0)  := X"63AC6F23";
   constant C_BUILD_DATE_HEX  : std_logic_vector(31 downto 0)  := X"20221228";
   constant C_BUILD_TIME_HEX  : std_logic_vector(31 downto 0)  := X"00083027";
   constant C_BUILD_GIT_REV   : string                         := "";
   constant C_BUILD_GIT_AUTH  : string                         := "";
   constant C_BUILD_GIT_EMAIL : string                         := "";
   constant C_BUILD_GIT_DATE  : string                         := "";

end fpga_ver;
