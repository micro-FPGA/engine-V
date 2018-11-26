// HAABBB G@@AAA
//
// Transmit Only UART implementation
//
//	RAM[Z] := RS2_0; 
	// stupid way to exclude CPI
//        WREG := Z.hi
//	WREG := WREG-$C0
//	if not FLAGS.1 then
        if not Zhi.7 then not_uart
        if     Zhi.5 then not_uart
	
		temp := 10; // number of bits	
		UART_TX = ZERO;	// Start bit
		repeat
			wreg := UART_BAUDCONST; 
			repeat 
				ADD wreg,FF
			until FLAGS.1
//			until --wreg; // Bit delay 115200 50MHz
			UART_TX = RS2_0; // transmit bit
			ROR RS2_0;
			OR RS2_0, $80	// insert STOP bit
			ADD temp,FF
		until FLAGS.1
//		until --temp;
		Goto MainLoop
//	end;
not_uart:

//
//
//


