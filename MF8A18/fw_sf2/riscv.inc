// Microcode Mnemonics for RISC-V 

var ZERO: byte @R0;
var FF: byte @R1;

var ECAUSE: byte @R9;
var PC: word @R10;
var oldPC: word @R12;

// Instruction word
var I0: byte @R16;
var I1: byte @R17;
var I2: byte @R18;
var I3: byte @R19;

// Destination work area
var RD0: byte @R20;
var RD1: byte @R21;
var RD2: byte @R22;
var RD3: byte @R23;

var RS2_0: byte @R24;
var RS2_1: byte @R25;
var RS2_2: byte @R26;
var RS2_3: byte @R27;

var TEMP: byte @R28;
// 29 is WREG
var Z: word @W30;
var Zlo: byte @R30;
var Zhi: byte @R31;


var RS1_0: byte @R12;
var RS1_1: byte @R13;
var RS1_2: byte @R14;
var RS1_3: byte @R15;



const RRH = $F1;
const CRH = $F2;






	

