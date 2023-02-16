load_package flow
execute_module -tool cpf -args "-c -o bitstream_compression=on ./output_files/de0_top.sof ./output_files/de0_top.rbf"
exec script/post_build.bat
