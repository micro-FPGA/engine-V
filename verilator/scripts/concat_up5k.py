
spiFile = open('spiflash.bin','wb')

# 128KB is reserved for bitstream
bitFile = open('../bitstream/mf8a18_rv32i.bin','rb')
bitData = bitFile.read(0x20000)

riscvFile = open('riscv.bin','rb')
riscvData = riscvFile.read(32768)

spiFile.write(bitData)

spiFile.seek(0x20000)
spiFile.write(riscvData)

nullData = bytearray([0])
spiFile.seek(0x27fff)
spiFile.write(nullData)

spiFile.close
bitFile.close

