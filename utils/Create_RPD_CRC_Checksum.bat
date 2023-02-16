::Use this batch file to generate the ciob_fpga.rpd file from CIOB_C_FPGA_Project.pof FPGA file. It also generates the crc and checksum for 
::the .rpd file.
C:\altera\13.1\quartus\bin\quartus_cpf -c CIOB_C_FPGA_Project.pof ciob_fpga.rpd
C:\altera\13.1\quartus\bin\quartus_sh --tcl_eval set file "ciob_fpga.rpd"; puts "$file -> [checksum $file -algorithm crc32]"
FPGA_Checksum.exe
pause


