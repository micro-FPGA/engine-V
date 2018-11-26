	temp := 10; // number of bits	
	UART_TX = ZERO;	// Start bit
	repeat
		wreg := UART_BAUDCONST; 
		repeat 
			ADD wreg,FF
		until FLAGS.1
		UART_TX = RS2_0; // transmit bit
		ROR RS2_0;
		OR RS2_0, $80	// insert STOP bit
		ADD temp,FF
	until FLAGS.1


