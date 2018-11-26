set PATH=..\dll;%PATH%
copy ..\images\zephyr-philo.mem ..\build_mss\riscv.mem
cd ..\build_mss 
start engine-v.exe

