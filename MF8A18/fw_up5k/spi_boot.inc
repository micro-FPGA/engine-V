
	RD3 := ZERO;         // for verilator and simulation

	SPI_CS  := FF;
	SPI_SCK := ZERO;

////////////////////
	SPI_CS  := ZERO
	RD0 := $AB; // wakeup !
		wreg := 0
		repeat
			SPI_MOSI := RD0;
				SPI_SCK := FF;
			ADD RD0, RD0
        			SPI_SCK := ZERO;
			//inc wreg;
			SUB WREG,FF
		until wreg.3;
	SPI_CS  := FF
////////////////////

	RD0 := $03;  // first byte
	RD1 := SPI_ADDR3;  //second byte to transmit

	SPI_CS  := ZERO
	// we start at fake high address so we are at 0 when we get first byte
	Z.lo := $FC; 
	Z.hi := $FF;

bootloop:
		wreg := 0
		repeat
			RD2 := SPI_MISO; // Get SPI data
			AND RD2, 1;      // only one 1 bit
			ADD RD3, RD3
			OR RD3, RD2	
			SPI_MOSI := RD0;
				SPI_SCK := FF;
			ADD RD1, RD1
			ADC RD0, RD0
        			SPI_SCK := ZERO;
			//inc wreg;
			SUB WREG,FF			
		until wreg.3;

		RAM[Z] := RD3;
		ADD Z.lo, 1
		SBC Z.hi, FF
	if Zhi.6 then bootloop
	if not Zhi.7 then bootloop

	SPI_CS  := FF;

