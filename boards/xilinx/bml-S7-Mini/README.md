
This was the first MF8A18 and engine-V was initially developed and tested, SPI Flash boot for Lattice was first working and debugged with S7-Mini, then ported to Lattice MDP.

NOTE: Board support files for S7-mini will be updated and hopefully pushed to Xilinx board part file repo.

Provided here is minimal board file, it includes only SPI flash and system clock configuration only.

https://github.com/blackmesalabs/s7_mini_fpga

Help needed: 

Original schematic had FTDI_0 as net names, they go to FTDI UART dongle that we do not have for testing (we use fly wires to TE0790 always!) so we can not verify with real hardware that we have the uart mapped correctly for this 6 pin cable.



