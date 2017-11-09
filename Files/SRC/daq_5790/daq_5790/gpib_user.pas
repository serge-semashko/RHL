{ ******************************************************* }
{ Borland Delphi Run-time Library }
{ Win32 ADLINK GPIB Interface Unit }
{ }
{ Copyright (c) 2005, ADLINK TECHNOLOGY INC. }
{ ******************************************************* }

unit gpib_user;

interface

uses Windows;

Const
  GPIB_MAX_NUM_BOARDS = 16;
  GPIB_MAX_NUM_DESCRIPTORS = $1000;
  gpib_addr_max = 30; // max address for primary/secondary gpib addresses

  // ibsta_bit_numbers
  DCAS_NUM = 0;
  DTAS_NUM = 1;
  LACS_NUM = 2;
  TACS_NUM = 3;
  ATN_NUM = 4;
  CIC_NUM = 5;
  REM_NUM = 6;
  LOK_NUM = 7;
  CMPL_NUM = 8;
  EVENT_NUM = 9;
  SPOLL_NUM = 10;
  RQS_NUM = 11;
  SRQI_NUM = 12;
  END_NUM = 13;
  TIMO_NUM = 14;
  ERR_NUM = 15;

  // IBSTA status bits (returned by all functions)
  // ibsta_bits
  DCAS = $1; // device clear state
  DTAS = $2; // device trigger state
  LACS = $4; // GPIB interface is addressed as Listener
  TACS = $8; // GPIB interface is addressed as Talker
  ATN = $10; // Attention is asserted
  CIC = $20; // GPIB interface is Controller-in-Charge
  REM = $40; // remote state
  LOK = $80; // lockout state
  CMPL = $100; // I/O is complete
  EVENT = $200; // DCAS, DTAS, or IFC has occurred
  SPOLL = $400; // board serial polled by busmaster
  RQS = $800; // Device requesting service
  SRQI = $1000; // SRQ is asserted
  ENDgpib = $2000; // EOI or EOS encountered
  TIMO = $4000; // Time limit on I/O or wait function exceeded
  ERR = $8000; // Function call terminated on error

  // IBERR error codes
  // iberr_code
  EDVR = 0; // system error
  ECIC = 1; // not CIC
  ENOL = 2; // no listeners
  EADR = 3; // CIC and not addressed before I/O
  EARG = 4; // bad argument to function call
  ESAC = 5; // not SAC
  EABO = 6; // I/O operation was aborted
  ENEB = 7; // non-existent board (GPIB interface offline)
  EDMA = 8; // DMA hardware error detected
  EOIP = 10; // new I/O attempted with old I/O in progress
  ECAP = 11; // no capability for intended opeation
  EFSO = 12; // file system operation error
  EBUS = 14; // bus error
  ESTB = 15; // lost serial poll bytes
  ESRQ = 16; // SRQ stuck on
  ETAB = 20; // Table Overflow

  // Timeout values and meanings
  // gpib_timeout
  TNONE = 0; // Infinite timeout (disabled)
  T10us = 1; // Timeout of 10 usec (ideal)
  T30us = 2; // Timeout of 30 usec (ideal)
  T100us = 3; // Timeout of 100 usec (ideal)
  T300us = 4; // Timeout of 300 usec (ideal)
  T1ms = 5; // Timeout of 1 msec (ideal)
  T3ms = 6; // Timeout of 3 msec (ideal)
  T10ms = 7; // Timeout of 10 msec (ideal)
  T30ms = 8; // Timeout of 30 msec (ideal)
  T100ms = 9; // Timeout of 100 msec (ideal)
  T300ms = 10; // Timeout of 300 msec (ideal)
  T1s = 11; // Timeout of 1 sec (ideal)
  T3s = 12; // Timeout of 3 sec (ideal)
  T10s = 13; // Timeout of 10 sec (ideal)
  T30s = 14; // Timeout of 30 sec (ideal)
  T100s = 15; // Timeout of 100 sec (ideal)
  T300s = 16; // Timeout of 300 sec (ideal)
  T1000s = 17; // Timeout of 1000 sec (maximum)

  // End-of-string (EOS) modes for use with ibeos
  // eos_flags
  EOS_MASK = $1C00;
  REOS = $0400; // Terminate reads on EOS
  XEOS = $800; // assert EOI when EOS char is sent
  BIN = $1000; // Do 8-bit compare on EOS

  // GPIB Bus Control Lines bit vector
  // bus_control_line
  ValidDAV = $01;
  ValidNDAC = $02;
  ValidNRFD = $04;
  ValidIFC = $08;
  ValidREN = $10;
  ValidSRQ = $20;
  ValidATN = $40;
  ValidEOI = $80;
  ValidALL = $FF;
  BusDAV = $0100; // DAV  line status bit
  BusNDAC = $0200; // NDAC line status bit
  BusNRFD = $0400; // NRFD line status bit
  BusIFC = $0800; // IFC  line status bit
  BusREN = $1000; // REN  line status bit
  BusSRQ = $2000; // SRQ  line status bit
  BusATN = $4000; // ATN  line status bit
  BusEOI = $8000; // EOI  line status bit

  // ibask_option
  IbaPAD = $1;
  IbaSAD = $2;
  IbaTMO = $3;
  IbaEOT = $4;
  IbaPPC = $5; // board only
  IbaREADDR = $6; // device only
  IbaAUTOPOLL = $7; // board only
  IbaCICPROT = $8; // board only
  IbaIRQ = $9; // board only
  IbaSC = $A; // board only
  IbaSRE = $B; // board only
  IbaEOSrd = $C;
  IbaEOSwrt = $D;
  IbaEOScmp = $E;
  IbaEOSchar = $F;
  IbaPP2 = $10; // board only
  IbaTIMING = $11; // board only
  IbaDMA = $12; // board only
  IbaReadAdjust = $13;
  IbaWriteAdjust = $14;
  IbaEventQueue = $15; // board only
  IbaSPollBit = $16; // board only
  IbaSpollBit2 = $16; // board only
  IbaSendLLO = $17; // board only
  IbaSPollTime = $18; // device only
  IbaPPollTime = $19; // board only
  IbaEndBitIsNormal = $1A;
  IbaUnAddr = $1B; // device only
  IbaHSCableLength = $1F; // board only
  IbaIst = $20; // board only
  IbaRsv = $21; // board only
  IbaBNA = $200; // device only
  IbaBaseAddr = $201; // device only

  // ibconfig_option
  IbcPAD = $1;
  IbcSAD = $2;
  IbcTMO = $3;
  IbcEOT = $4;
  IbcPPC = $5; // board only
  IbcREADDR = $6; // device only
  IbcAUTOPOLL = $7; // board only
  IbcCICPROT = $8; // board only
  IbcIRQ = $9; // board only
  IbcSC = $A; // board only
  IbcSRE = $B; // board only
  IbcEOSrd = $C;
  IbcEOSwrt = $D;
  IbcEOScmp = $E;
  IbcEOSchar = $F;
  IbcPP2 = $10; // board only
  IbcTIMING = $11; // board only
  IbcDMA = $12; // board only
  IbcReadAdjust = $13;
  IbcWriteAdjust = $14;
  IbcEventQueue = $15; // board only
  IbcSPollBit = $16; // board only
  IbcSpollBit2 = $16; // board only
  IbcSendLLO = $17; // board only
  IbcSPollTime = $18; // device only
  IbcPPollTime = $19; // board only
  IbcEndBitIsNormal = $1A;
  IbcUnAddr = $1B; // device only
  IbcHSCableLength = $1F; // board only
  IbcIst = $20; // board only
  IbcRsv = $21; // board only
  IbcLON = $22; // board only
  IbcBNA = $200; // device only
  IbcBaseAddr = $201; // device only

  // t1_delays
  T1_DELAY_2000ns = 1;
  T1_DELAY_500ns = 2;
  T1_DELAY_350ns = 3;

Type
  F64 = Double;
  F32 = Single;
  I32 = Longint;
  U32 = Cardinal;
  I16 = Smallint;
  U16 = Word;
  U8 = Byte;
  I8 = ShortInt;

implementation

end.
