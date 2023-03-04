..\..\..\..\utils\fpga_ver.exe ..\..\fpga_build.inc ..\..\fpga_build.h ..\..\fpga_build.vhd ..\..\..\..\.git
echo f|xcopy ..\..\fpga_build.vhd ..\..\..\ip\stamp\hdl\fpga_build.vhd /F /Y /R
echo f|xcopy ..\..\fpga_build.h ..\..\..\..\mb\arty_fw\share\fpga_build.h /F /Y /R
