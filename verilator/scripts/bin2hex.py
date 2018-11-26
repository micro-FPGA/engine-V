
binFile = open('spiflash.bin','rb')
binaryData = binFile.read(163840)
for i in range(0,163839):
	print ("%02x" %binaryData[i])
binFile.close