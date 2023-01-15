..\..\..\utils\fw_ver.exe ..\build.inc ..\build.h ..\..\..\.git
echo f|xcopy ..\build.h ..\share\build.h /F /Y /R
echo f|xcopy ..\cp_srv\cp_msg.h ..\share\cp_msg.h /F /Y /R
echo f|xcopy ..\daq_srv\daq_msg.h ..\share\daq_msg.h /F /Y /R
echo f|xcopy ..\..\arty_top\mb_cpu\standalone_mb_cpu\bsp\mb_cpu\include\xparameters.h ..\share\xparameters.h /F /Y /R
