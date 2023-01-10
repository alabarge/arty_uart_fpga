..\..\..\utils\fw_ver.exe ..\build.inc ..\build.h ..\..\..\.git
echo f|xcopy ..\build.h ..\share\build.h /F /Y /R
echo f|xcopy ..\cp_srv\cp_msg.h ..\share\cp_msg.h /F /Y /R
