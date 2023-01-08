..\utils\fpga_ver.exe .\ip\pr_ddr\fpga_build.inc .\pr_ddr\fpga_build.h .\pr_ddr\fpga_build.vhd ..\.git
echo f|xcopy .\pr_ddr\fpga_build.vhd .\ip\pr_ddr\fpga_build.vhd /F /Y /R
echo f|xcopy .\pr_ddr\fpga_build.vhd .\ip\stamp\hdl\fpga_build.vhd /F /Y /R
echo f|xcopy .\pr_ddr\fpga_build.h ..\mb\ddr_fw\share\fpga_build.h /F /Y /R
