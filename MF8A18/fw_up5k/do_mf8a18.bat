set PROJ=test

del %PROJ%.lst
del %PROJ%.obj
del %PROJ%.rom

mf8a18 %PROJ%.bas

copy %PROJ%.rom %PROJ%.hex
del %PROJ%.rom
del %PROJ%.obj

hex2mem  %PROJ%.hex > %PROJ%.mem
copy test.mem ..\build\rv32i.mem 


