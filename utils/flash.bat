cmd /c mb-objcopy -O srec ..\mb\arty_fw\Release\arty_fw.elf arty_fw.elf.srec
cmd /c bootgen -arch fpga -image srecimage.bif -w -o srec.bin -interface spi
cmd /c program_flash -f srec.bin -offset 0x600000 -flash_type s25fl128sxxxxxx0-spi-x1_x2_x4 -blank_check -verify -url TCP:127.0.0.1:3121
cmd /c bootgen -arch fpga -image bootimage.bif -w -o boot.bin -interface spi
cmd /c program_flash -f boot.bin -offset 0x0 -flash_type s25fl128sxxxxxx0-spi-x1_x2_x4 -blank_check -verify -url TCP:127.0.0.1:3121
