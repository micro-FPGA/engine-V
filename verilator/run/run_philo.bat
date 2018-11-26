set PATH=..\dll;%PATH%
copy ..\images\zephyr-philo.bin ..\build\riscv.bin
cd ..\build 

python ..\scripts\concat_up5k.py
python ..\scripts\bin2hex.py > ..\build\spiflash.hex

start engine-v.exe

