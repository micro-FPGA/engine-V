// Quiz, what does 60 mean in this context?
// Answer: A3P060 :)
#device 60
//
//
//

#include riscv.inc

#include brd_mdp.inc
//#include brd_sf2.inc
//#include brd_s7m.inc

//
// Start here
//
	WREG := 0; ZERO := WREG; // simulator friendly version, can save 2 bytes in FPGA !
	WREG := $FF
	FF   := WREG;

#include spi_boot.inc

//#include ramclear.inc
//#include raminit.inc	

	PC.lo := ZERO;
	PC.hi := ZERO;

//======================================
//
// Main Loop
//	

	goto MainStart
MISALIGN_LD:
	WREG := 4
	goto misaling_ldst
MISALIGN_ST:
	WREG := 6
misaling_ldst:
	oldPC := PC
	PC.lo := Z.lo 
	PC.hi := Z.hi
	goto mtvec_mtval

Store_0:
	RD0 := 0;
Store_RD_BYTE:
	RD1 := 0;
Store_RD_WORD:
	RD2 := 0;
	RD3 := 0;

Store_RD:

// xxxx_xxxx xxxx_xxxx xxxx_4321 0xxx_xxxx
// x432 10xx
//  	Z.lo := I1
//	swap Z.lo
//	lsr Z.lo
//	and Z.lo, $78
//	if not I0.7 then skip; Z.lo := Z.lo or $04;

  	Z.lo := I1
	swap Z.lo
	//lsr Z.lo
	and Z.lo, $F0
	if not I0.7 then skip; Z.lo := Z.lo or $08;


	// rd = 0? If so do not store it!
	if Z.lo = $00 then MainLoop
	// Store RD to r1..r31
	Z.Hi := RRH; // Register save area
	RAM[Z] := RD0; 
	RAM[Z+1] := RD1;
	RAM[Z+2] := RD2;
	RAM[Z+3] := RD3; 

	repeat
MainLoop:
//
// Fetch new instruction word into I0..I3
//
        WREG := PC.lo
	if not WREG.1 then NextPC
// Misaligned jump!
	WREG := 0; // Misaligned jump
mtvec_mtval:
	Z.hi  := CRH
	// store mtval
	Z.lo := $30
	RAM[Z] := PC.lo; //
	RAM[Z+1] := PC.hi
mtvec_mepc:
	// store mepc
	Z.lo := $10
	RAM[Z] := oldPC.lo; //
	RAM[Z+1] := oldPC.hi
mtvec_ecause:
	goto go_mtvec_ecause
//
NextPC:
        //PC := PC+4;
        PC.lo := PC.lo+4;
	ADC PC.hi, ZERO

MainStart:
//
// Thread switching should appear here for hardware multithreaded support
//

	oldPC := PC
	Z := PC;



	I0 := RAM[Z];
	I1 := RAM[Z+1];
	I2 := RAM[Z+2]; 
	I3 := RAM[Z+3];

//
// Start instruction decoding and emulation
//
       if I0.2 then goto I_XX_XX1
//
// need load rs1
//

// xxxx_xxxx xxxx_xxxx xxxx_4321 0xxx_xxxx
// x432 10xx

LD_rs1:
//        Z.lo := I2
//	swap Z.lo
//	lsr Z.lo
//	Z.lo := Z.lo and $78
//	if not I1.7 then skip; Z.lo := Z.lo or $04;

        Z.lo := I2
	swap Z.lo
	//lsr Z.lo
	Z.lo := Z.lo and $F0
	if not I1.7 then skip; Z.lo := Z.lo or $08;

//
	Z.Hi := RRH; // Register save area
	RS1_0 := RAM[Z]; 
	RS1_1 := RAM[Z+1]; 
	RS1_2 := RAM[Z+2];
	RS1_3 := RAM[Z+3]; 

        if I0.5 then goto I_X1_XX0
//
I_0X_XX0:
I_XX_XX0:
I_IMMED:
// Get immed 11:0 and sign extend	
	RD3 := $FF; // 
	RD2 := $FF; // 
	RD0 := I2; SWAP RD0; RD0 := RD0 and $0F;
	SWAP I3;
	RD1 := I3;          RD1 := RD1 or $F0;
	I3 := I3 and $F0;   RD0 := RD0 or I3;
	if RD1.3 then goto imm12_p
	RD1 := RD1 and $0F;
	RD2 := 0;
	RD3 := 0; 
imm12_p:  
// 12 bit immed in RD	
        if not I0.4 then goto I_00_0X1 // JALR >>

// IMM ALU
        if I1.6 then goto LOGIC
// 0XX
        if I1.5 then goto DO_SLT
// 00X
        if I1.4 then goto DO_SLLI
// 000
// ADDI
// 32 bit ADD
Do_ADDI:
        RD0 := RD0 + RS1_0
        ADC RD1, RS1_1
        ADC RD2, RS1_2
        ADC RD3, RS1_3
	goto Store_RD

LOGIC:
        if I1.5 then goto OR_AND
        if I1.4 then goto Do_SR
Do_XOR:
        RD0 := RD0 xor RS1_0
        RD1 := RD1 xor RS1_1
        RD2 := RD2 xor RS1_2
        RD3 := RD3 xor RS1_3
	goto Store_RD

OR_AND:
        if I1.4 then goto DO_AND
Do_OR:
        RD0 := RD0 or RS1_0
        RD1 := RD1 or RS1_1
        RD2 := RD2 or RS1_2
        RD3 := RD3 or RS1_3
	goto Store_RD
Do_AND:
        RD0 := RD0 and RS1_0
        RD1 := RD1 and RS1_1
        RD2 := RD2 and RS1_2
        RD3 := RD3 and RS1_3
	goto Store_RD

Do_SLL:
	RD0 := RS2_0
//	Goto Do_SLLI	
DO_SLLI:
	RD0 := RD0 and $1F;
asm
	breq Store_RS1
end
	repeat
		ADD RS1_0, RS1_0
		ADC RS1_1, RS1_1
		ADC RS1_2, RS1_2
		ADC RS1_3, RS1_3

		ADD RD0,FF
	until FLAGS.1
//	until --RD0;

Store_RS1:
	RD0 := RS1_0;
	RD1 := RS1_1;
	RD2 := RS1_2;
	RD3 := RS1_3;
	goto Store_RD

Do_XOR_AND:
	if I1.5 then goto OR_AND // bit 
	if not I1.4 then goto Do_XOR // bit 
// SRL SRA
	RD0 := RS2_0
	RD1 := I3
	swap RD1
//	goto Do_SR

//
// SRLI, SRAI
//
Do_SR:
	RD0 := RD0 and $1F;
asm
	breq Store_RS1
end

// SRLI/SRAI?
	// I3.6 > RD1.3 !
	if not RD1.2 then goto DO_SRLI
// SRAI
	repeat
		ASR RS1_3
		ROR RS1_2
		ROR RS1_1
		ROR RS1_0
		ADD RD0,FF
	until FLAGS.1
//	until --RD0;

	goto Store_RS1

//
Do_SRLI:
	repeat
		LSR RS1_3
		ROR RS1_2
		ROR RS1_1
		ROR RS1_0
		ADD RD0,FF
	until FLAGS.1
//	until --RD0;

	goto Store_RS1


//
// SLTI, SLTIU
//
DO_SLT:
	if I1.4 then goto Do_SLTIU
	WREG := $80;	
	RS1_3 := RS1_3 + WREG
	RD3 := RD3 + WREG
Do_SLTIU:
        SUB RS1_0, RD0
        SBC RS1_1, RD1
        SBC RS1_2, RD2
        SBC RS1_3, RD3
asm
	brcs Store_1
end

	goto Store_0
Store_1:
	RD0 := 1;
	goto Store_RD_BYTE


// LOAD
// RS1 loaded, RD immed
I_00_0X1:
	//
	if not I0.6 then goto Do_Loads

// JALR
	ADD RS1_0, RD0
	ADC RS1_1, RD1

	//PC := PC+4
	PC.lo := PC.lo+4
	ADC PC.hi, ZERO

	RD0 := PC.lo
	RD1 := PC.hi

	AND RS1_0, $FE	// JALR TEST !
	
	PC.lo := RS1_0
	PC.hi := RS1_1

	WREG := 4
	SUB PC.lo, WREG
	SBC PC.hi, ZERO

	// Store return PC
	goto Store_RD_WORD


Do_LOADS:
	Z.Lo := RS1_0;
	Z.Hi := RS1_1;
	Z.Lo := Z.lo + RD0
	ADC Z.Hi, RD1
// Load from memory
	RD0 := RAM[Z];
        if I1.4 then goto I_LD_H // 
        if I1.5 then goto I_LD_W // 
// LB, LBU
	if I1.6 then goto Store_RD_BYTE
	if not RD0.7 then goto Store_RD_BYTE
	RD1 := $FF
//	goto I_LH
I_LH:
// sign extend
	if not RD1.7 then goto Store_RD_WORD
	RD2 := $FF;
	RD3 := $FF;
	goto Store_RD

I_LD_W:
	if Zlo.0 then MISALIGN_LD
	if Zlo.1 then MISALIGN_LD

	RD1 := RAM[Z+1]; 
	RD2 := RAM[Z+2]; 
	RD3 := RAM[Z+3];
	goto Store_RD	
//

I_LD_H:
	if Zlo.0 then MISALIGN_LD

	RD1 := RAM[Z+1]; 
	if not I1.6 then goto I_LH // 
// LHU UNSIGNED
        goto Store_RD_WORD	

// 
I_X1_XX0:

// SYSTEM also here !!
  
 
// JALR ??
      if not I0.6 then goto not_JALR
//      if not I0.5 then goto not_JALR
I_11:
      if     I0.4 then goto Do_SYS
      if     I0.3 then goto not_JALR
      if not I0.2 then goto not_JALR
      goto I_IMMED

//
//
//
Do_SYS:

#include system.inc

	goto Store_RD

not_JALR:

//      if I0.6 then goto I_11_XX0 // branches
	if I0.6 then goto Load_RS2 // branches !

// STORE
I_01_XX0:
// RS1 is loaded

	if I0.4 then goto Load_RS2; //STORE
//
// RS1 is loaded
//
//I_01_1X0:

//	Goto Load_RS2

STORE:	
  	RD0 := I1
	add RD0,RD0
	and RD0,$1E
	if not I0.7 then skip; RD0 := RD0 or $01;

	wreg := i3
	swap wreg
	and wreg,$E0;
	or RD0, wreg

	RD1 := I3;
	swap RD1
	and RD1, $07
	if not I3.7 then skip; RD1 := RD1 or $F8; // sign extend!

	RS1_0 := RS1_0 + RD0
	ADC RS1_1, RD1

// Load RS2
Load_RS2:
//

// xxxx_xxx4 3210_xxxx xxxx_xxxx xxxx_xxxx
// x432 10xx
//        Z.lo := I2
//	lsr Z.lo
//	lsr Z.lo
//        if not I3.0 then skip; Z.lo := Z.lo or $40;
//	Z.lo := Z.lo and $7C

        Z.lo := I2
	//lsr Z.lo
	lsr Z.lo
        if not I3.0 then skip; Z.lo := Z.lo or $80;
	Z.lo := Z.lo and $F8

// Makes Dhrystone slower on single cycle RAM
//	if not FLAGS.1 then Load_RS2_RAM
//	RS2_0 := 0	
//	RS2_1 := 0	
//	RS2_2 := 0	
//	RS2_3 := 0	
//   	goto Load_RS2_Done

// TODO R0 ZERO !!
Load_RS2_RAM:
	Z.Hi := RRH; // Register save area
	RS2_0 := RAM[Z]; 
	RS2_1 := RAM[Z+1];
	RS2_2 := RAM[Z+2];
	RS2_3 := RAM[Z+3]; 
Load_RS2_Done:
// Branches?
//	if I0.6 then goto Do_Branch

	if not I0.6 then alustore

// branches
Do_Branch:
//
// Check condition
//
// signed?	
	if I1.5 then goto UNSIG
// signed trick
	wreg := $80
	xor RS1_3, wreg
	xor RS2_3, wreg
UNSIG:	
	SUB RS1_0, RS2_0
	SBC RS1_1, RS2_1
	SBC RS1_2, RS2_2
	SBC RS1_3, RS2_3
	
	if not I1.6 then goto BNE_BEQ
	if     I1.4 then goto is_BGE
// BLT
asm
	brcs Take_Branch
end	
	goto MainLoop

// BGEU
is_BGE:
asm
	brcs main_l1;   //brcc Take_Branch
end	
//	goto MainLoop

Take_Branch:
	add i1,i1
	and i1, $1E // bits 4..1
	swap i3
	wreg := i3
	and wreg, $E0
	or i1, wreg	// 7..1
	and i3,$0f
	if not i3.3 then skip
	or i3,$10	// merge bit 12
	and i3,$17
	if not i0.7 then skip
	or i3,$08	// merge bit 11
	if not i3.4 then skip
	or i3,$E0	// sign extend 16 bit
	add PC.lo, i1
	adc PC.hi, i3
	goto MainStart

BNE_BEQ:
	or RS1_0, RS1_1
	or RS1_0, RS1_2
	or RS1_0, RS1_3
	if not I1.4 then goto is_BEQ	
// BNE
asm
	brne Take_Branch
end	
main_l1:
	goto MainLoop

is_BEQ:
asm
	breq Take_Branch
end	
	goto MainLoop


// Store or ALU ?
alustore:
	if not I0.4 then goto Do_Store

	RD0 := RS2_0
	RD1 := RS2_1
	RD2 := RS2_2
	RD3 := RS2_3
//
// check ALU 
	if I1.6 then goto Do_XOR_AND // bit 14
	if I1.5 then goto Do_SLT // bit 13
	if I1.4 then goto Do_SLL // bit 12

Do_AddSub:
	if not I3.6 then goto Do_ADDI	
// SUB OK
        SUB RS1_0, RS2_0
        SBC RS1_1, RS2_1
        SBC RS1_2, RS2_2
        SBC RS1_3, RS2_3

	goto Store_RS1


Do_Store:
// store to RS1
	Z.Lo := RS1_0
	Z.Hi := RS1_1
// 
	if I1.4 then goto I_SH_SW
	if I1.5 then goto I_SH_SW
// Store byte
I_SB:

	RAM[Z] := RS2_0; 
#include txuart.inc	

	goto MainLoop
//
I_SH_SW:
	if Zlo.0 then MISALIGN_ST
	if I1.4 then goto ST_LOW16
I_SW:
	if Zlo.1 then MISALIGN_ST
	RAM[Z+3] := RS2_3; 
	RAM[Z+2] := RS2_2; 
ST_LOW16:
	RAM[Z] := RS2_0; 
	RAM[Z+1] := RS2_1; 
	goto MainLoop

//
//
// LUI/AUIPC/JAL/JALR/FENCE
I_XX_XX1:
       if I0.4 then goto I_XX_1X1  // -> AUIPC/LUI
// JAL/JALR/FENCE
I_XX_0X1:
	if not I0.5 then goto MainLoop // -> FENCE
I_X1_0X1:
// JAL/JALR
	if not I0.3 then goto LD_rs1  // JALR >>
// JAL

	swap I3
	AND I3, $F7
	if not I2.4 then skip
	OR I3, $08 // 7654 11 10 9 8
	swap I2
	AND I2,$0E // xxxx 3 2 1 _
	RS1_0 := I3
	RS1_0 := RS1_0 and $F0
	RS1_0 := RS1_0 or I2 // 7..1 x
	RS1_1 := I1
	RS1_1 := RS1_1 and $F0 // 15..12
	I3 := I3 and $0F
	RS1_1 := RS1_1 or I3
	// 
Store_RET:
	PC.lo := PC.lo+4	
	ADC PC.hi, ZERO
		RD0 := PC.lo
		RD1 := PC.hi
	ADD PC.lo, RS1_0
	ADC PC.hi, RS1_1
		WREG := 8
		SUB PC.lo, WREG
		SBC PC.hi, ZERO
	goto Store_RD_WORD

// AUIPC/LUI
I_XX_1X1:
	// Load IMMED, clear lower bits
	RD3 := I3; // copy bits 31..24	
	RD2 := I2; // copy bits 23..16
	RD1 := I1; // copy bits 15..8
	RD1 := RD1 and $F0; // clear bits 11..8
	RD0 := 0;  // clear bits 7..0
        if I0.5 then goto Store_RD

// AUIPC

	RD0 := PC.lo;
	RD1 := RD1 + PC.hi
	goto Store_RD
//
//
//


	until false;
//
//
//






