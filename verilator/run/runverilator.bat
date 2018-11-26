echo Running verilator for RV32I compliance test case: %1
@echo off
copy ..\images\%1.bin ..\build\riscv.bin
cd ..\build 

python ..\scripts\concat_up5k.py
python ..\scripts\bin2hex.py > ..\build\spiflash.hex

set PATH=..\dll;%PATH%
engine-v.exe >output.sig_listing
python ..\scripts\extract_sig.py output.sig_listing >output.sig

@copy output.sig ..\signatures\%1.signature
cd ..
cd run
fc ..\signatures\%1.signature ..\references\%1.reference_output  >> RV32I_Compliance.txt
