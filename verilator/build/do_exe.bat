del a.exe
del *.o

..\bin\verilator.exe --exe -Wno-fatal --compiler msvc --cc --top-module tb -I../hdl ../hdl/tb.v ../hdl/tb.cc

set VERI=..\bin
set INC=%VERI%\include
gcc -I .\obj_dir -I %INC%  %INC%\verilated.cpp  .\obj_dir\Vtb.cpp .\obj_dir\Vtb__Syms.cpp ../hdl/tb.cc -lstdc++

del *.o

copy a.exe engine-v.exe
del a.exe