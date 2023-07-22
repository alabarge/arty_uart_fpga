rmdir /s /q .\release
echo f|xcopy .\output_files\arty_top.bit .\release\ARTY_S7_B_FPGA_Project.bit /F /Y /R
echo f|xcopy .\output_files\arty_top_v*.bit .\release\arty_top_v*.bit /F /Y /R
echo f|xcopy .\output_files\fpga_version.h .\release\fpga_version.h /F /Y /R
echo f|xcopy .\output_files\fpga_build.h .\release\fpga_build.h /F /Y /R
echo f|xcopy .\output_files\fpga_build.vhd .\release\fpga_build.vhd /F /Y /R
echo f|xcopy .\output_files\arty_top_crc32.txt .\release\arty_top_crc32.txt /F /Y /R
echo f|xcopy .\output_files\arty_top_checksum.txt .\release\arty_top_checksum.txt /F /Y /R
echo f|xcopy .\output_files\arty_top_md5.txt .\release\arty_top_md5.txt /F /Y /R
if exist ".\arty_top_release_*.zip" del /F arty_top_release_*.zip
cd release
..\..\..\..\..\utils\fpga_zip.exe
