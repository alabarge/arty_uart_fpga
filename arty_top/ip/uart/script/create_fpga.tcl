source settings.tcl

# don't do anything if the build folder already exists
# otherwise, create the folder
if {[file exists $build_dir]} {
    puts "ERROR: Build directory already exists. Remove and try again. Aborting."
	exit
} else {
    file mkdir $build_dir
}

cd $build_dir

# create the project
create_project -part $fpga_device -force $project_name

set_property target_language VHDL [current_project]

# add the rtl files
add_files $src_dir/uart_top.vhd
read_vhdl -vhdl2008 $src_dir/uart_regs.vhd
read_vhdl -vhdl2008 $src_dir/uart_irq.vhd
read_vhdl -vhdl2008 $src_dir/uart_ctl.vhd
read_vhdl -vhdl2008 $src_dir/uart_rx.vhd
read_vhdl -vhdl2008 $src_dir/uart_tx.vhd

# import the Xilinx IP
add_files $xci_dir/uart_rx_ram/uart_rx_ram.xci
add_files $xci_dir/uart_tx_ram/uart_tx_ram.xci

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
