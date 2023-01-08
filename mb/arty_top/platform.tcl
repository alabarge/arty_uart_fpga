# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct D:\ARTY-I\arty_uart_fpga\mb\arty_top\platform.tcl
# 
# OR launch xsct and run below command.
# source D:\ARTY-I\arty_uart_fpga\mb\arty_top\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {arty_top}\
-hw {D:\ARTY-I\arty_uart_fpga\arty_top\pr_ddr\arty_top.xsa}\
-out {D:/ARTY-I/arty_uart_fpga/mb}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {arty_top}
platform generate -quick
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform config -updatehw {D:/ARTY-I/arty_uart_fpga/arty_top/pr_ddr/arty_top.xsa}
platform clean
platform generate
platform active {arty_top}
platform config -updatehw {D:/ARTY-I/arty_uart_fpga/arty_top/pr_ddr/arty_top.xsa}
platform clean
platform generate
platform config -updatehw {D:/ARTY-I/arty_uart_fpga/arty_top/pr_ddr/arty_top.xsa}
platform clean
platform generate
platform config -updatehw {D:/ARTY-I/arty_uart_fpga/arty_top/pr_ddr/arty_top.xsa}
platform clean
platform generate
platform config -updatehw {D:/ARTY-I/arty_uart_fpga/arty_top/pr_ddr/arty_top.xsa}
platform clean
platform generate
platform config -updatehw {D:/ARTY-I/arty_uart_fpga/arty_top/pr_ddr/arty_top.xsa}
platform clean
platform generate
platform config -updatehw {D:/ARTY-I/arty_uart_fpga/arty_top/pr_ddr/arty_top.xsa}
platform clean
platform generate
platform config -updatehw {D:/ARTY-I/arty_uart_fpga/arty_top/pr_ddr/arty_top.xsa}
platform clean
platform generate
platform active {arty_top}
platform config -updatehw {D:/ARTY-I/arty_uart_fpga/arty_top/pr_ddr/arty_top.xsa}
platform clean
platform generate
platform config -updatehw {D:/ARTY-I/arty_uart_fpga/arty_top/pr_ddr/arty_top.xsa}
platform clean
platform generate
platform active {arty_top}
platform config -updatehw {D:/ARTY-I/arty_uart_fpga/arty_top/pr_ddr/arty_top.xsa}
platform clean
platform generate
platform active {arty_top}
platform config -updatehw {D:/ARTY-I/arty_uart_fpga/arty_top/pr_ddr/arty_top.xsa}
platform clean
platform generate
platform clean
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
