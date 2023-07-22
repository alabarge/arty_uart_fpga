echo off
if exist ..\vivado (
   echo Warning, The ..\vivado folder will be deleted - CTRL+C to exit
   pause
   rmdir /s /q ..\vivado
)
mkdir ..\vivado
cd ..\vivado
C:\Xilinx\Vivado\2022.2\bin\unwrapped\win64.o\vvgl.exe C:\Xilinx\Vivado\2022.2\bin\vivado.bat -mode gui -source ..\script\make_proj.tcl
