echo Running verilator for RV32I compliance test case: %1
@echo off
copy ..\images\%1.mem ..\build_mss\riscv.mem

cd ..\build_mss 
set PATH=..\dll;%PATH%
engine-v.exe >output.sig_listing
python ..\scripts\extract_sig.py output.sig_listing >output.sig

@copy output.sig ..\signatures\%1.signature
cd ..
cd run_mss
fc ..\signatures\%1.signature ..\references\%1.reference_output  >> RV32I_Compliance.txt
