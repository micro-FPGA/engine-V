del a.exe
del *.o

..\bin\verilator.exe --exe -Wno-fatal --compiler msvc --cc --top-module tb -I../hdl_mss ../hdl_mss/tb.v ../hdl_mss/tb.cc

set VERI=..\bin
set INC=%VERI%\include
gcc -I .\obj_dir -I %INC%  %INC%\verilated.cpp  .\obj_dir\Vtb.cpp .\obj_dir\Vtb__Syms.cpp ../hdl_mss/tb.cc -lstdc++

del *.o

copy a.exe engine-v.exe
del a.exe
