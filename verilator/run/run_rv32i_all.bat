cd ..\signatures
del * /q
cd ..\run
del RV32I_Compliance.txt

call runverilator.bat I-IO-01 

call runverilator.bat I-RF_size-01 
call runverilator.bat I-RF_width-01 
call runverilator.bat I-RF_x0-01 

call runverilator.bat I-ECALL-01 
call runverilator.bat I-EBREAK-01 

call runverilator.bat I-MISALIGN_JMP-01 
call runverilator.bat I-MISALIGN_LDST-01 

call runverilator.bat I-CSRRW-01 
call runverilator.bat I-CSRRS-01 
call runverilator.bat I-CSRRC-01 

call runverilator.bat I-CSRRWI-01 
call runverilator.bat I-CSRRSI-01 
call runverilator.bat I-CSRRCI-01 


call runverilator.bat I-ADD-01 
call runverilator.bat I-ADDI-01
call runverilator.bat I-AND-01
call runverilator.bat I-ANDI-01

call runverilator.bat I-SUB-01 

call runverilator.bat I-SLT-01 
call runverilator.bat I-SLTU-01 
call runverilator.bat I-SLTI-01 
call runverilator.bat I-SLTIU-01 


call runverilator.bat I-OR-01
call runverilator.bat I-ORI-01 
call runverilator.bat I-XOR-01
call runverilator.bat I-XORI-01 


call runverilator.bat I-AUIPC-01
call runverilator.bat I-LUI-01

call runverilator.bat I-BEQ-01
call runverilator.bat I-BNE-01

call runverilator.bat I-BLT-01
call runverilator.bat I-BGE-01
call runverilator.bat I-BLTU-01
call runverilator.bat I-BGEU-01


call runverilator.bat I-LB-01
call runverilator.bat I-LH-01
call runverilator.bat I-LW-01
call runverilator.bat I-LBU-01
call runverilator.bat I-LHU-01

call runverilator.bat I-SB-01
call runverilator.bat I-SH-01
call runverilator.bat I-SW-01

call runverilator.bat I-JAL-01
call runverilator.bat I-JALR-01

call runverilator.bat I-NOP-01
call runverilator.bat I-FENCE.I-01
call runverilator.bat I-DELAY_SLOTS-01
call runverilator.bat I-ENDIANESS-01

call runverilator.bat I-SLTI-01 
call runverilator.bat I-SLTIU-01 

call runverilator.bat I-SLLI-01 
call runverilator.bat I-SRLI-01 
call runverilator.bat I-SRAI-01 

call runverilator.bat I-SLL-01 
call runverilator.bat I-SLT-01 
call runverilator.bat I-SLTU-01 
call runverilator.bat I-SRL-01 
call runverilator.bat I-SRA-01 

exit 0
