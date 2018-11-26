////////////////////////////////////
	Z.hi  := CRH
        Z.lo  := $10		 // mepc 	
	TEMP  := 0;
	
	// EBREAK/ECALL ?
	WREG := I1
	WREG := WREG and $70
	if WREG=0 then
		if not I3.4 then SYS_xxx0_xxxx_xxxx
SYS_xxxx_xxxx_xxxx: 		         
		if I3.5 then do_exec  // MRET
		// WFI
		TEMP := $80

		
SYS_xxx0_xxxx_xxxx:
// ECALL/EBREAK
		RAM[Z] := PC.lo	         // mepc
		RAM[Z+1] := PC.hi        // 

		WREG := $03		 // ECALL/EBREAK
		if I2.4 then skip
			or WREG, $08
		if temp=0 then skip
			wreg := 7	 // MTIMER intterrupt	
		Z.lo   := $23;
		RAM[Z] := TEMP;		 // Interrupt flag
go_mtvec_ecause:
	        Z.lo   := $20		 // mcause
		RAM[Z] := WREG	         // 
go_mtvec:
	        Z.lo   := $50		 // mtvec
do_exec:
		PC.lo  := RAM[Z]         // 
		PC.hi  := RAM[Z+1]         // 

		goto MainStart
	end 
//////////////////////////////////////////////


	Z.lo := I2
	and Z.lo, $F0

//	if I3=$34 then

//	end

	if I3.7 then
	     Z.lo := Z.lo or $4
	end

	//
	// read CSR
	//
	RD0 := RAM[Z]; 
	RD1 := RAM[Z+1];
	RD2 := RAM[Z+2];
	RD3 := RAM[Z+3]; 
//
// CSR loaded
//
	if  not  I1.6 then goto csr_notimm
// todo get 5 bit immed value
	RS1_0 := i2; 
	RS1_0 := RS1_0 and $0F; 
	add RS1_0, RS1_0
	if not I1.7 then skip; 
	sub RS1_0,FF 
	RS1_1 := 0;	
	RS1_2 := 0;
	RS1_3 := 0;
csr_notimm:
	if not I1.5 then goto CSR_WRITE
	if     I1.4 then goto Do_CSRRC
// Set Bits
	// Set Bits
	RS1_0 := RS1_0 or RD0
	RS1_1 := RS1_1 or RD1
	RS1_2 := RS1_2 or RD2
	RS1_3 := RS1_3 or RD3
	goto CSR_WRITE
Do_CSRRC:
	WREG := $FF
	RS1_0 := RS1_0 xor WREG	
	RS1_1 := RS1_1 xor WREG	
	RS1_2 := RS1_2 xor WREG	
	RS1_3 := RS1_3 xor WREG	

	RS1_0 := RS1_0 and RD0
	RS1_1 := RS1_1 and RD1
	RS1_2 := RS1_2 and RD2
	RS1_3 := RS1_3 and RD3
CSR_WRITE:
//
// Write back here
// 
	// write CSR
	RAM[Z+3] := RS1_3; 
	RAM[Z+2] := RS1_2; 
	RAM[Z+1] := RS1_1; 
	RAM[Z] := RS1_0
//////////////////////////////////

