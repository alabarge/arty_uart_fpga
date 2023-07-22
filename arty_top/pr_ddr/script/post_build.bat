echo f|xcopy .\system.runs\impl_1\arty_top.bit .\output_files\arty_top.bit /F /Y /R
echo f|xcopy ..\..\fpga_build.h .\output_files\fpga_build.h /F /Y /R
echo f|xcopy ..\..\fpga_build.vhd .\output_files\fpga_build.vhd /F /Y /R
echo \n | ..\..\..\..\utils\fpga_checksum.exe  .\output_files\arty_top.bit .\output_files\arty_top_checksum.txt
echo \n | ..\..\..\..\utils\fpga_crc32.exe  .\output_files\arty_top.bit .\output_files\arty_top_crc32.txt
echo \n | CertUtil -hashfile .\output_files\arty_top.bit MD5 > .\output_files\arty_top_md5.txt
..\..\..\..\utils\fpga_post_ver.exe .\output_files\arty_top_checksum.txt .\output_files\arty_top_crc32.txt .\output_files\arty_top_md5.txt .\output_files\fpga_build.h .\output_files\fpga_version.h
echo f|xcopy .\output_files\fpga_version.h ..\..\..\..\mb\arty_fw\share\fpga_version.h /F /Y /R
