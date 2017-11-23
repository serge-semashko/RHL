Attribute VB_Name = "GPIB"
'*********************************************************************
'
'  GPIB Library
'
'  File: Adgpib.bas
'
'
' This file contains the Visual BASIC (32 bit) declarations for all
' GPIB library commands.
'
'
'***********************************************************************

Option Explicit

' GPIB globals
Global ibsta As Integer
Global iberr As Integer
Global ibcnt As Integer
Global ibcntl As Long

' GPIB Commands
Global Const GTL = &H1
Global Const SDC = &H4
Global Const PPC = &H5
Global Const GETT = &H8
Global Const TCT = &H9
Global Const LLO = &H11
Global Const DCL = &H14
Global Const PPU = &H15
Global Const SPE = &H18
Global Const SPD = &H19
Global Const UNL = &H3F
Global Const UNT = &H5F
Global Const PPE = &H60
Global Const PPD = &H70


' Bit specifiers for ibsta status variable and wait mask
Global Const EERR = &H8000  ' Error detected
Global Const TIMO = &H4000  ' Timeout
Global Const EEND = &H2000  ' EOI or EOS detected
Global Const SRQI = &H1000  ' SRQ detected by CIC
Global Const RQS = &H800    ' Device needs service
Global Const SPOLL = &H400  ' Board has been serially polled
Global Const eevent = &H200 ' An event has occured
Global Const CMPL = &H100   ' I/O completed
Global Const LOK = &H80     ' Local lockout state
Global Const RREM = &H40    ' Remote state
Global Const CIC = &H20     ' Controller-in-Charge
Global Const AATN = &H10    ' Attention asserted
Global Const TACS = &H8     ' Talker active
Global Const LACS = &H4     ' Listener active
Global Const DTAS = &H2     ' Device trigger state
Global Const DCAS = &H1     ' Device clear state


' Error codes returned to IBERR variable
Global Const EDVR = 0     ' DOS error
Global Const ECIC = 1     ' Board must be CIC for this function
Global Const ENOL = 2     ' No listeners detected
Global Const EADR = 3     ' Board not addressed correctly
Global Const EARG = 4     ' Invalid argument passed to function
Global Const ESAC = 5     ' Function requires GPIB board to be SC
Global Const EABO = 6     ' I/O operation aborted
Global Const ENEB = 7     ' Invalid board specified
Global Const EOIP = 10    ' I/O operation already running
Global Const ECAP = 11    ' Board does not have requested capability
Global Const EFSO = 12    ' Error returned from file system
Global Const EBUS = 14    ' Command error on bus
Global Const ESTB = 15    ' Serial poll response byte lost
Global Const ESRQ = 16    ' SRQ is still asserted
Global Const ETAB = 20    ' No device responding with ETAB

Global Const EINT = 247   ' No interrupt configured on board.
Global Const EWMD = 248   ' Windows is not in enhanced mode
Global Const EVDD = 249   ' CBGPIB.386 is not installed
Global Const EOVR = 250   ' Buffer overflow
Global Const ESML = 251   ' Two library calls running simultaneously
Global Const ECFG = 252   ' Board type doesn't match GPIB.CFG
Global Const ETMR = 253   ' No Windows timers available
Global Const ESLC = 254   ' No Windows selectors available
Global Const EBRK = 255   ' Ctrl-Break pressed, exiting program


' EOS mode bits
Global Const BIN = &H1000
Global Const XEOS = &H800
Global Const REOS = &H400


' Timeout code for ibtmo function
Global Const TNONE = 0      ' No timeout
Global Const T10us = 1      ' 10 usec
Global Const T30us = 2      ' 30 usec
Global Const T100us = 3     ' 100 usec
Global Const T300us = 4     ' 300 usec
Global Const T1ms = 5       ' 1 msec
Global Const T3ms = 6       ' 3 msec
Global Const T10ms = 7      ' 10 msec
Global Const T30ms = 8      ' 30 msec
Global Const T100ms = 9     ' 100 msec
Global Const T300ms = 10    ' 300 msec
Global Const T1s = 11       ' 1 sec
Global Const T3s = 12       ' 3 sec
Global Const T10s = 13      ' 10 sec
Global Const T30s = 14      ' 30 sec
Global Const T100s = 15     ' 100 sec
Global Const T300s = 16     ' 300 sec
Global Const T1000s = 17    ' 1000 sec

'  IBLN Constants
Global Const NO_SAD = 0
Global Const ALL_SAD = -1


' Miscellaneous
Global Const S = &H8             ' parallel poll bit
Global Const LF = &HA            ' linefeed character
Global Const NOADDR = &HFFFF     'Terminator for address list
Global Const NULLend = 0         'Send() EOTMODE - Do nothing at the end of a transfer.
Global Const NLend = 1           'Send() EOTMODE - Send NL with EOI after a transfer.
Global Const DABend = 2          'Send() EOTMODE - Send EOI with the last DAB.
Global Const STOPend = &H100     'Receive()( termination
Global Const EventDTAS = 1       'used by IBEVENT()
Global Const EventDCAS = 2       'used by IBEVENT()


' The following constants are used with ibconfig() to select a
' configurable option.
Global Const IbcPAD = &H1             ' Primary address
Global Const IbcSAD = &H2             ' Secondary address
Global Const IbcTMO = &H3             ' Timeout
Global Const IbcEOT = &H4             ' Send EOI with last byte
Global Const IbcPPC = &H5             ' Parallel Poll Configure
Global Const IbcREADDR = &H6          ' Repeat Addressing
Global Const IbcAUTOPOLL = &H7        ' Disable automatic serial poll
Global Const IbcCICPROT = &H8         ' Use CIC Protocol
Global Const IbcIRQ = &H9             ' Interrupt level (or 0 for none)
Global Const IbcSC = &HA              ' Board is system controller
Global Const IbcSRE = &HB             ' Assert SRE for dev calls
Global Const IbcEOSrd = &HC           ' Terminate read on EOS
Global Const IbcEOSwrt = &HD          ' Send EOI with EOS
Global Const IbcEOScmp = &HE          ' Use 7 or 8-bit compare with EOS
Global Const IbcEOSchar = &HF         ' EOS character
Global Const IbcPP2 = &H10            ' Use PP mode 2
Global Const IbcTIMING = &H11         ' Normal, High or Very High Speed
Global Const IbcDMA = &H12            ' DMA channel (or 0 for none)
Global Const IbcReadAdjust = &H13     ' Swap bytes on read
Global Const IbcWriteAdjust = &H14    ' Swap bytes on write
Global Const IbcEventQueue = &H15     ' Use event queue
Global Const IbcSPollBit = &H16       ' Serial poll bit used
Global Const IbcSendLLO = &H17        ' Automatically send LLO
Global Const IbcSPollTime = &H18      ' Serial poll timeout
Global Const IbcPPollTime = &H19      ' Parallel poll timeout
Global Const IbcNoEndBitOnEos = &H1A  ' Don't set end bit on EOS
Global Const IbcIst = &H20            ' Changes individual status
Global Const IbcRsv = &H21            ' Changes serial poll status byte
Global Const IbcLON = &H22            ' Don't set end bit on EOS
Global Const IbcBNA = &H200           ' A device's access board.
Global Const IbcBaseAddr = &H201      ' A GPIB board's base I/O address.


' These are provided for compatability with NI's library
Global Const IbaPAD = &H1
Global Const IbaSAD = &H2
Global Const IbaTMO = &H3
Global Const IbaEOT = &H4
Global Const IbaPPC = &H5
Global Const IbaREADDR = &H6
Global Const IbaAUTOPOLL = &H7
Global Const IbaCICPROT = &H8
Global Const IbaIRQ = &H9
Global Const IbaSC = &HA
Global Const IbaSRE = &HB
Global Const IbaEOSrd = &HC
Global Const IbaEOSwrt = &HD
Global Const IbaEOScmp = &HE
Global Const IbaEOSchar = &HF
Global Const IbaPP2 = &H10
Global Const IbaTIMING = &H11
Global Const IbaDMA = &H12
Global Const IbaReadAdjust = &H13
Global Const IbaWriteAdjust = &H14
Global Const IbaEventQueue = &H15
Global Const IbaSPollBit = &H16
Global Const IbaSendLLO = &H17
Global Const IbaSPollTime = &H18
Global Const IbaPPollTime = &H19
Global Const IbaNoEndBitOnEos = &H1A
Global Const IbaBNA = &H200
Global Const IbaBaseAddr = &H201

' CBI config items - Don't exist in NI software
Global Const IbaBoardType = &H300
Global Const IbaChipType = &H301
Global Const IbaSlotNum = &H302
Global Const IbaPCIIndex = &H303
Global Const IbaBaseAdr2 = &H304
Global Const IbaUseFIFOs = &H305


' These bits specify which lines can be monitored by IBLINES
Global Const ValidDAV = &H1
Global Const ValidNDAC = &H2
Global Const ValidNRFD = &H4
Global Const ValidIFC = &H8
Global Const ValidREN = &H10
Global Const ValidSRQ = &H20
Global Const ValidATN = &H40
Global Const ValidEOI = &H80

' These bits specify the current state of each GPIB line
Global Const BusDAV = &H100
Global Const BusNDAC = &H200
Global Const BusNRFD = &H400
Global Const BusIFC = &H800
Global Const BusREN = &H1000
Global Const BusSRQ = &H2000
Global Const BusATN = &H4000
Global Const BusEOI = &H8000

' GPIB-32.DLL routines
Declare Function ibask32 Lib "Gpib-32.dll" Alias "ibask" (ByVal ud As Long, ByVal opt As Long, value As Long) As Long
Declare Function ibbna32 Lib "Gpib-32.dll" Alias "ibbnaA" (ByVal ud As Long, sstr As Any) As Long
Declare Function ibcac32 Lib "Gpib-32.dll" Alias "ibcac" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibclr32 Lib "Gpib-32.dll" Alias "ibclr" (ByVal ud As Long) As Long
Declare Function ibcmd32 Lib "Gpib-32.dll" Alias "ibcmd" (ByVal ud As Long, sstr As Any, ByVal cnt As Long) As Long
Declare Function ibcmda32 Lib "Gpib-32.dll" Alias "ibcmda" (ByVal ud As Long, sstr As Any, ByVal cnt As Long) As Long
Declare Function ibconfig32 Lib "Gpib-32.dll" Alias "ibconfig" (ByVal ud As Long, ByVal opt As Long, ByVal v As Long) As Long
Declare Function ibdev32 Lib "Gpib-32.dll" Alias "ibdev" (ByVal bdid As Long, ByVal pad As Long, ByVal sad As Long, ByVal tmo As Long, ByVal eot As Long, ByVal eos As Long) As Long
Declare Function ibdma32 Lib "Gpib-32.dll" Alias "ibdma" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibeos32 Lib "Gpib-32.dll" Alias "ibeos" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibeot32 Lib "Gpib-32.dll" Alias "ibeot" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibfind32 Lib "Gpib-32.dll" Alias "ibfindA" (sstr As Any) As Long
Declare Function ibgts32 Lib "Gpib-32.dll" Alias "ibgts" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibist32 Lib "Gpib-32.dll" Alias "ibist" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function iblines32 Lib "Gpib-32.dll" Alias "iblines" (ByVal ud As Long, v As Long) As Long
Declare Function ibln32 Lib "Gpib-32.dll" Alias "ibln" (ByVal ud As Long, ByVal pad As Long, ByVal sad As Long, ln As Long) As Long
Declare Function ibloc32 Lib "Gpib-32.dll" Alias "ibloc" (ByVal ud As Long) As Long
Declare Function iblock32 Lib "Gpib-32.dll" Alias "iblock" (ByVal ud As Long) As Long
Declare Function ibonl32 Lib "Gpib-32.dll" Alias "ibonl" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibpad32 Lib "Gpib-32.dll" Alias "ibpad" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibpct32 Lib "Gpib-32.dll" Alias "ibpct" (ByVal ud As Long) As Long
Declare Function ibppc32 Lib "Gpib-32.dll" Alias "ibppc" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibrd32 Lib "Gpib-32.dll" Alias "ibrd" (ByVal ud As Long, sstr As Any, ByVal cnt As Long) As Long
Declare Function ibrda32 Lib "Gpib-32.dll" Alias "ibrd" (ByVal ud As Long, sstr As Any, ByVal cnt As Long) As Long
Declare Function ibrdf32 Lib "Gpib-32.dll" Alias "ibrdfA" (ByVal ud As Long, sstr As Any) As Long
Declare Function ibrpp32 Lib "Gpib-32.dll" Alias "ibrpp" (ByVal ud As Long, sstr As Any) As Long
Declare Function ibrsc32 Lib "Gpib-32.dll" Alias "ibrsc" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibrsp32 Lib "Gpib-32.dll" Alias "ibrsp" (ByVal ud As Long, sstr As Any) As Long
Declare Function ibrsv32 Lib "Gpib-32.dll" Alias "ibrsv" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibsad32 Lib "Gpib-32.dll" Alias "ibsad" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibsic32 Lib "Gpib-32.dll" Alias "ibsic" (ByVal ud As Long) As Long
Declare Function ibsre32 Lib "Gpib-32.dll" Alias "ibsre" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibstop32 Lib "Gpib-32.dll" Alias "ibstop" (ByVal ud As Long) As Long
Declare Function ibtmo32 Lib "Gpib-32.dll" Alias "ibtmo" (ByVal ud As Long, ByVal v As Long) As Long
Declare Function ibtrg32 Lib "Gpib-32.dll" Alias "ibtrg" (ByVal ud As Long) As Long
Declare Function ibwait32 Lib "Gpib-32.dll" Alias "ibwait" (ByVal ud As Long, ByVal mask As Long) As Long
Declare Function ibwrt32 Lib "Gpib-32.dll" Alias "ibwrt" (ByVal ud As Long, sstr As Any, ByVal cnt As Long) As Long
Declare Function ibwrta32 Lib "Gpib-32.dll" Alias "ibwrt" (ByVal ud As Long, sstr As Any, ByVal cnt As Long) As Long
Declare Function ibwrtf32 Lib "Gpib-32.dll" Alias "ibwrtfA" (ByVal ud As Long, sstr As Any) As Long
Declare Function gpib_get_globals32 Lib "Gpib-32.dll" Alias "gpib_get_globals" (ibsta As Integer, iberr As Integer, ibcnt As Integer, ibcntl As Long) As Long
Declare Sub AllSpoll32 Lib "Gpib-32.dll" Alias "AllSpoll" (ByVal ud As Long, arg1 As Any, arg2 As Any)
Declare Sub DevClear32 Lib "Gpib-32.dll" Alias "DevClear" (ByVal ud As Long, ByVal v As Long)
Declare Sub DevClearList32 Lib "Gpib-32.dll" Alias "DevClearList" (ByVal ud As Long, arg1 As Any)
Declare Sub EnableLocal32 Lib "Gpib-32.dll" Alias "EnableLocal" (ByVal ud As Long, arg1 As Any)
Declare Sub EnableRemote32 Lib "Gpib-32.dll" Alias "EnableRemote" (ByVal ud As Long, arg1 As Any)
Declare Sub FindLstn32 Lib "Gpib-32.dll" Alias "FindLstn" (ByVal ud As Long, arg1 As Any, arg2 As Any, ByVal limit As Long)
Declare Sub FindRQS32 Lib "Gpib-32.dll" Alias "FindRQS" (ByVal ud As Long, arg1 As Any, result As Long)
Declare Sub PassControl32 Lib "Gpib-32.dll" Alias "PassControl" (ByVal ud As Long, ByVal addr As Long)
Declare Sub PPoll32 Lib "Gpib-32.dll" Alias "PPoll" (ByVal ud As Long, result As Long)
Declare Sub PPollConfig32 Lib "Gpib-32.dll" Alias "PPollConfig" (ByVal ud As Long, ByVal addr As Long, ByVal line As Long, ByVal sense As Long)
Declare Sub PPollUnconfig32 Lib "Gpib-32.dll" Alias "PPollUnconfig" (ByVal ud As Long, arg1 As Any)
Declare Sub RcvRespMsg32 Lib "Gpib-32.dll" Alias "RcvRespMsg" (ByVal ud As Long, arg1 As Any, ByVal cnt As Long, ByVal term As Long)
Declare Sub ReadStatusByte32 Lib "Gpib-32.dll" Alias "ReadStatusByte" (ByVal ud As Long, ByVal addr As Long, result As Long)
Declare Sub Receive32 Lib "Gpib-32.dll" Alias "Receive" (ByVal ud As Long, ByVal addr As Long, arg1 As Any, ByVal cnt As Long, ByVal term As Long)
Declare Sub ReceiveSetup32 Lib "Gpib-32.dll" Alias "ReceiveSetup" (ByVal ud As Long, ByVal addr As Long)
Declare Sub ResetSys32 Lib "Gpib-32.dll" Alias "ResetSys" (ByVal ud As Long, arg1 As Any)
Declare Sub Send32 Lib "Gpib-32.dll" Alias "Send" (ByVal ud As Long, ByVal addr As Long, sstr As Any, ByVal cnt As Long, ByVal term As Long)
Declare Sub SendCmds32 Lib "Gpib-32.dll" Alias "SendCmds" (ByVal ud As Long, sstr As Any, ByVal cnt As Long)
Declare Sub SendDataBytes32 Lib "Gpib-32.dll" Alias "SendDataBytes" (ByVal ud As Long, sstr As Any, ByVal cnt As Long, ByVal term As Long)
Declare Sub SendIFC32 Lib "Gpib-32.dll" Alias "SendIFC" (ByVal ud As Long)
Declare Sub SendList32 Lib "Gpib-32.dll" Alias "SendList" (ByVal ud As Long, arg1 As Any, arg2 As Any, ByVal cnt As Long, ByVal term As Long)
Declare Sub SendLLO32 Lib "Gpib-32.dll" Alias "SendLLO" (ByVal ud As Long)
Declare Sub SendSetup32 Lib "Gpib-32.dll" Alias "SendSetup" (ByVal ud As Long, arg1 As Any)
Declare Sub SetRWLS32 Lib "Gpib-32.dll" Alias "SetRWLS" (ByVal ud As Long, arg1 As Any)
Declare Sub TestSRQ32 Lib "Gpib-32.dll" Alias "TestSRQ" (ByVal ud As Long, arg1 As Integer)
Declare Sub TestSys32 Lib "Gpib-32.dll" Alias "TestSys" (ByVal ud As Long, arg1 As Any, arg2 As Any)
Declare Sub WaitSRQ32 Lib "Gpib-32.dll" Alias "WaitSRQ" (ByVal ud As Long, arg1 As Integer)
Declare Sub Trigger32 Lib "Gpib-32.dll" Alias "Trigger" (ByVal ud As Long, ByVal addr As Long)
Declare Sub TriggerList32 Lib "Gpib-32.dll" Alias "TriggerList" (ByVal ud As Long, arg1 As Any)

Sub copy_ibglobals()
    Call gpib_get_globals32(ibsta, iberr, ibcnt, ibcntl)
End Sub

'************************
' 488.1 Functions
'************************

Sub ibask(ByVal ud As Integer, ByVal opt As Integer, rval As Integer)
  Dim res As Long

    Call ibask32(ud, opt, res)
    rval = Long2Int(res)
    Call copy_ibglobals
End Sub

Sub ibbna(ByVal ud As Integer, ByVal udname As String)
    Call ibbna32(ud, ByVal udname)
    Call copy_ibglobals
End Sub

Sub ibcac(ByVal ud As Integer, ByVal v As Integer)
    Call ibcac32(ud, v)
    Call copy_ibglobals
End Sub

Sub ibclr(ByVal ud As Integer)
' Check to see if GPIB Global variables are registered
    Call ibclr32(ud)
    Call copy_ibglobals
End Sub

Sub ibcmd(ByVal ud As Integer, ByVal buf As String)
   Dim cnt As Long
    Call ibcmd32(ud, ByVal buf, cnt)
    Call copy_ibglobals
End Sub

Sub ibcmda(ByVal ud As Integer, ByVal buf As String)
    Dim cnt As Long
    Call ibcmda32(ud, ByVal buf, cnt)
    Call copy_ibglobals
End Sub

Sub ibconfig(ByVal bdid As Integer, ByVal opt As Integer, ByVal v As Integer)
    Call ibconfig32(bdid, opt, v)
    Call copy_ibglobals
End Sub

Sub ibdev(ByVal bdid As Integer, ByVal pad As Integer, ByVal sad As Integer, ByVal tmo As Integer, ByVal eot As Integer, ByVal eos As Integer, ud As Integer)
    ud = Long2Int(ibdev32(bdid, pad, sad, tmo, eot, eos))
    Call copy_ibglobals
End Sub


Sub ibdma(ByVal ud As Integer, ByVal v As Integer)
    Call ibdma32(ud, v)
    Call copy_ibglobals
End Sub

Sub ibeos(ByVal ud As Integer, ByVal v As Integer)
    Call ibeos32(ud, v)
    Call copy_ibglobals
End Sub

Sub ibeot(ByVal ud As Integer, ByVal v As Integer)
    Call ibeot32(ud, v)
    Call copy_ibglobals
End Sub


Sub ibfind(ByVal udname As String, ud As Integer)
    ud = Long2Int(ibfind32(ByVal udname))
    Call copy_ibglobals
End Sub

Sub ibgts(ByVal ud As Integer, ByVal v As Integer)
    Call ibgts32(ud, v)
    Call copy_ibglobals
End Sub

Sub ibist(ByVal ud As Integer, ByVal v As Integer)
    Call ibist32(ud, v)
    Call copy_ibglobals
End Sub

Sub iblines(ByVal ud As Integer, lines As Integer)
   Dim reslines As Long

    Call iblines32(ud, reslines)
    lines = Long2Int(reslines)
    Call copy_ibglobals
End Sub

Sub ibln(ByVal ud As Integer, ByVal pad As Integer, ByVal sad As Integer, ln As Integer)
    Dim resln As Long

    Call ibln32(ud, pad, sad, resln)
    ln = Long2Int(resln)
    Call copy_ibglobals
End Sub

Sub ibloc(ByVal ud As Integer)
    Call ibloc32(ud)
    Call copy_ibglobals
End Sub

Sub ibonl(ByVal ud As Integer, ByVal v As Integer)
    Call ibonl32(ud, v)
    Call copy_ibglobals
End Sub

Sub ibpad(ByVal ud As Integer, ByVal v As Integer)
    Call ibpad32(ud, v)
    Call copy_ibglobals
End Sub

Sub ibpct(ByVal ud As Integer)
    Call ibpct32(ud)
    Call copy_ibglobals
End Sub



Sub ibppc(ByVal ud As Integer, ByVal v As Integer)
    Call ibppc32(ud, v)
    Call copy_ibglobals
End Sub

Sub ibrd(ByVal ud As Integer, buf As String)
    Dim cnt As Long
    cnt = CLng(Len(buf))
    Call ibrd32(ud, ByVal buf, cnt)
    Call copy_ibglobals
End Sub

Sub ibrda(ByVal ud As Integer, buf As String)
    Dim cnt As Long
    cnt = CLng(Len(buf))
    Call ibrda32(ud, ByVal buf, cnt)
    Call copy_ibglobals
End Sub

Sub ibrdf(ByVal ud As Integer, ByVal filename As String)
    Call ibrdf32(ud, ByVal filename)
    Call copy_ibglobals
End Sub

Sub ibrdi(ByVal ud As Integer, ibuf() As Integer, ByVal cnt As Long)
    Call ibrd32(ud, ibuf(0), cnt)
    Call copy_ibglobals
End Sub

Sub ibrdia(ByVal ud As Integer, ibuf() As Integer, ByVal cnt As Long)
    Call ibrda32(ud, ibuf(0), cnt)
    Call copy_ibglobals
End Sub



Sub ibrpp(ByVal ud As Integer, ppr As Integer)
    Static res_str As String * 2

    Call ibrpp32(ud, ByVal res_str)
    ppr = Asc(res_str)
    Call copy_ibglobals
End Sub

Sub ibrsc(ByVal ud As Integer, ByVal v As Integer)
    Call ibrsc32(ud, v)
    Call copy_ibglobals
End Sub

Sub ibrsp(ByVal ud As Integer, spr As Integer)
    Static res_str As String * 2

    Call ibrsp32(ud, ByVal res_str)
    spr = Asc(res_str)
    Call copy_ibglobals
End Sub

Sub ibrsv(ByVal ud As Integer, ByVal v As Integer)
    Call ibrsv32(ud, v)
    Call copy_ibglobals
End Sub

Sub ibsad(ByVal ud As Integer, ByVal v As Integer)
    Call ibsad32(ud, v)
    Call copy_ibglobals
End Sub

Sub ibsic(ByVal ud As Integer)
    Call ibsic32(ud)
    Call copy_ibglobals
End Sub

Sub ibsre(ByVal ud As Integer, ByVal v As Integer)
    Call ibsre32(ud, v)
    Call copy_ibglobals
End Sub

Sub ibstop(ByVal ud As Integer)
    Call ibstop32(ud)
    Call copy_ibglobals
End Sub

Sub ibtmo(ByVal ud As Integer, ByVal v As Integer)
    Call ibtmo32(ud, v)
    Call copy_ibglobals
End Sub

Sub ibtrg(ByVal ud As Integer)
' Check to see if GPIB Global variables are registered
    Call ibtrg32(ud)
    Call copy_ibglobals
End Sub

Sub ibwait(ByVal ud As Integer, ByVal mask As Integer)
    Call ibwait32(ud, mask)
    Call copy_ibglobals
End Sub

Sub ibwrt(ByVal ud As Integer, ByVal buf As String)
    Dim cnt As Long
    cnt = CLng(Len(buf))
    Call ibwrt32(ud, ByVal buf, cnt)
    Call copy_ibglobals
End Sub

Sub ibwrta(ByVal ud As Integer, ByVal buf As String)
    Dim cnt As Long
    cnt = CLng(Len(buf))
    Call ibwrta32(ud, ByVal buf, cnt)
    Call copy_ibglobals
End Sub

Sub ibwrtf(ByVal ud As Integer, ByVal filename As String)
    Call ibwrtf32(ud, ByVal filename)
    Call copy_ibglobals
End Sub

Sub ibwrti(ByVal ud As Integer, ByRef ibuf() As Integer, ByVal cnt As Long)
    Call ibwrt32(ud, ibuf(0), cnt)
    Call copy_ibglobals
End Sub

Sub ibwrtia(ByVal ud As Integer, ByRef ibuf() As Integer, ByVal cnt As Long)
    Call ibwrta32(ud, ibuf(0), cnt)
    Call copy_ibglobals
End Sub



Function ilask(ByVal ud As Integer, ByVal opt As Integer, rval As Integer) As Integer
    Dim res As Long
    ilask = Long2Int(ibask32(ud, opt, res))
    rval = Long2Int(res)
    Call copy_ibglobals
End Function

Function ilbna(ByVal ud As Integer, ByVal udname As String) As Integer
    ilbna = Long2Int(ibbna32(ud, ByVal udname))
    Call copy_ibglobals
End Function

Function ilcac(ByVal ud As Integer, ByVal v As Integer) As Integer
    ilcac = Long2Int(ibcac32(ud, v))
    Call copy_ibglobals
End Function

Function ilclr(ByVal ud As Integer) As Integer
    ilclr = Long2Int(ibclr32(ud))
    Call copy_ibglobals
End Function

Function ilcmd(ByVal ud As Integer, ByVal buf As String, ByVal cnt As Long) As Integer
    ilcmd = Long2Int(ibcmd32(ud, ByVal buf, cnt))
    Call copy_ibglobals
End Function

Function ilcmda(ByVal ud As Integer, ByVal buf As String, ByVal cnt As Long) As Integer
    ilcmda = Long2Int(ibcmda32(ud, ByVal buf, cnt))
    Call copy_ibglobals
End Function

Function ilconfig(ByVal bdid As Integer, ByVal opt As Integer, ByVal v As Integer) As Integer
    ilconfig = Long2Int(ibconfig32(bdid, opt, v))
    Call copy_ibglobals
End Function

Function ildev(ByVal bdid As Integer, ByVal pad As Integer, ByVal sad As Integer, ByVal tmo As Integer, ByVal eot As Integer, ByVal eos As Integer) As Integer
    ildev = Long2Int(ibdev32(bdid, pad, sad, tmo, eot, eos))
    Call copy_ibglobals
End Function


Function ildma(ByVal ud As Integer, ByVal v As Integer) As Integer
    ildma = Long2Int(ibdma32(ud, v))
    Call copy_ibglobals
End Function

Function ileos(ByVal ud As Integer, ByVal v As Integer) As Integer
    ileos = Long2Int(ibeos32(ud, v))
    Call copy_ibglobals
End Function

Function ileot(ByVal ud As Integer, ByVal v As Integer) As Integer
    ileot = Long2Int(ibeot32(ud, v))
    Call copy_ibglobals
End Function


Function ilfind(ByVal udname As String) As Integer
    ilfind = Long2Int(ibfind32(ByVal udname))
    Call copy_ibglobals
End Function

Function ilgts(ByVal ud As Integer, ByVal v As Integer) As Integer
    ilgts = Long2Int(ibgts32(ud, v))
    Call copy_ibglobals
End Function

Function ilist(ByVal ud As Integer, ByVal v As Integer) As Integer
    ilist = Long2Int(ibist32(ud, v))
    Call copy_ibglobals
End Function


Function illines(ByVal ud As Integer, lines As Integer) As Integer
    Dim reslines As Long
    illines = Long2Int(iblines32(ud, reslines))
    lines = Long2Int(reslines)
    Call copy_ibglobals
End Function

Function illn(ByVal ud As Integer, ByVal pad As Integer, ByVal sad As Integer, ln As Integer) As Integer
    Dim resln As Long
    illn = Long2Int(ibln32(ud, pad, sad, resln))
    ln = Long2Int(resln)
    Call copy_ibglobals
End Function

Function illoc(ByVal ud As Integer) As Integer
    illoc = Long2Int(ibloc32(ud))
    Call copy_ibglobals
End Function

Function ilonl(ByVal ud As Integer, ByVal v As Integer) As Integer
    ilonl = Long2Int(ibonl32(ud, v))
    Call copy_ibglobals
End Function

Function ilpad(ByVal ud As Integer, ByVal v As Integer) As Integer
    ilpad = Long2Int(ibpad32(ud, v))
    Call copy_ibglobals
End Function

Function ilpct(ByVal ud As Integer) As Integer
    ilpct = Long2Int(ibpct32(ud))
    Call copy_ibglobals
End Function



Function ilppc(ByVal ud As Integer, ByVal v As Integer) As Integer
    ilppc = Long2Int(ibppc32(ud, v))
    Call copy_ibglobals
End Function

Function ilrd(ByVal ud As Integer, buf As String, ByVal cnt As Long) As Integer
    ilrd = Long2Int(ibrd32(ud, ByVal buf, cnt))
    Call copy_ibglobals
End Function

Function ilrda(ByVal ud As Integer, buf As String, ByVal cnt As Long) As Integer
    ilrda = Long2Int(ibrda32(ud, ByVal buf, cnt))
    Call copy_ibglobals
End Function

Function ilrdf(ByVal ud As Integer, ByVal filename As String) As Integer
    ilrdf = Long2Int(ibrdf32(ud, ByVal filename))
    Call copy_ibglobals
End Function

Function ilrdi(ByVal ud As Integer, ibuf() As Integer, ByVal cnt As Long) As Integer
    ilrdi = Long2Int(ibrd32(ud, ibuf(0), cnt))
    Call copy_ibglobals
End Function

Function ilrdia(ByVal ud As Integer, ibuf() As Integer, ByVal cnt As Long) As Integer
    ilrdia = Long2Int(ibrda32(ud, ibuf(0), cnt))
    Call copy_ibglobals
End Function



Function ilrpp(ByVal ud As Integer, ppr As Integer) As Integer
    Static tmp_str As String * 2

    ilrpp = Long2Int(ibrpp32(ud, ByVal tmp_str))
    ppr = Asc(tmp_str)
    Call copy_ibglobals
End Function

Function ilrsc(ByVal ud As Integer, ByVal v As Integer) As Integer
    ilrsc = Long2Int(ibrsc32(ud, v))
    Call copy_ibglobals
End Function

Function ilrsp(ByVal ud As Integer, spr As Integer) As Integer
    Static tmp_str As String * 2
    ilrsp = Long2Int(ibrsp32(ud, ByVal tmp_str))
    spr = Asc(tmp_str)
    Call copy_ibglobals
End Function

Function ilrsv(ByVal ud As Integer, ByVal v As Integer) As Integer
    ilrsv = Long2Int(ibrsv32(ud, v))
    Call copy_ibglobals
End Function

Function ilsad(ByVal ud As Integer, ByVal v As Integer) As Integer
    ilsad = Long2Int(ibsad32(ud, v))
    Call copy_ibglobals
End Function

Function ilsic(ByVal ud As Integer) As Integer
    ilsic = Long2Int(ibsic32(ud))
    Call copy_ibglobals
End Function

Function ilsre(ByVal ud As Integer, ByVal v As Integer) As Integer
    ilsre = Long2Int(ibsre32(ud, v))
    Call copy_ibglobals
End Function

Function ilstop(ByVal ud As Integer) As Integer
    ilstop = Long2Int(ibstop32(ud))
    Call copy_ibglobals
End Function

Function iltmo(ByVal ud As Integer, ByVal v As Integer) As Integer
    iltmo = Long2Int(ibtmo32(ud, v))
    Call copy_ibglobals
End Function

Function iltrg(ByVal ud As Integer) As Integer
    iltrg = Long2Int(ibtrg32(ud))
    Call copy_ibglobals
End Function

Function ilwait(ByVal ud As Integer, ByVal mask As Integer) As Integer
    ilwait = Long2Int(ibwait32(ud, mask))
    Call copy_ibglobals
End Function

Function ilwrt(ByVal ud As Integer, ByVal buf As String, ByVal cnt As Long) As Integer
    ilwrt = Long2Int(ibwrt32(ud, ByVal buf, cnt))
    Call copy_ibglobals
End Function

Function ilwrta(ByVal ud As Integer, ByVal buf As String, ByVal cnt As Long) As Integer
    ilwrta = Long2Int(ibwrta32(ud, ByVal buf, cnt))
    Call copy_ibglobals
End Function

Function ilwrtf(ByVal ud As Integer, ByVal filename As String) As Integer
    ilwrtf = Long2Int(ibwrtf32(ud, ByVal filename))
    Call copy_ibglobals
End Function

Function ilwrti(ByVal ud As Integer, ByRef ibuf() As Integer, ByVal cnt As Long) As Integer
    ilwrti = Long2Int(ibwrt32(ud, ibuf(0), cnt))
    Call copy_ibglobals
End Function

Function ilwrtia(ByVal ud As Integer, ByRef ibuf() As Integer, ByVal cnt As Long) As Integer
    ilwrtia = Long2Int(ibwrta32(ud, ibuf(0), cnt))
    Call copy_ibglobals
End Function

'************************
' 488.2 Subroutines
'************************

Sub AllSpoll(ByVal ud As Integer, addrs() As Integer, results() As Integer)
    Call AllSpoll32(ud, addrs(0), results(0))
    Call copy_ibglobals
End Sub

Sub DevClear(ByVal ud As Integer, ByVal addr As Integer)
    Call DevClear32(ud, addr)
    Call copy_ibglobals
End Sub

Sub DevClearList(ByVal ud As Integer, addrs() As Integer)
    Call DevClearList32(ud, addrs(0))
    Call copy_ibglobals
End Sub

Sub EnableLocal(ByVal ud As Integer, addrs() As Integer)
    Call EnableLocal32(ud, addrs(0))
    Call copy_ibglobals
End Sub

Sub EnableRemote(ByVal ud As Integer, addrs() As Integer)
    Call EnableRemote32(ud, addrs(0))
    Call copy_ibglobals
End Sub

Sub FindLstn(ByVal ud As Integer, addrs() As Integer, results() As Integer, ByVal limit As Integer)
    Call FindLstn32(ud, addrs(0), results(0), limit)
    Call copy_ibglobals
End Sub

Sub FindRQS(ByVal ud As Integer, addrs() As Integer, result As Integer)
   Dim tmpresult As Long

    Call FindRQS32(ud, addrs(0), tmpresult)
    result = Long2Int(tmpresult)
    Call copy_ibglobals
End Sub

Sub PassControl(ByVal ud As Integer, ByVal addr As Integer)
    Call PassControl32(ud, addr)
    Call copy_ibglobals
End Sub

Sub Ppoll(ByVal ud As Integer, result As Integer)
    Dim tmpresult As Long
    Call PPoll32(ud, tmpresult)
    result = Long2Int(tmpresult)
    Call copy_ibglobals
End Sub

Sub PpollConfig(ByVal ud As Integer, ByVal addr As Integer, ByVal lline As Integer, ByVal sense As Integer)
    Call PPollConfig32(ud, addr, lline, sense)
    Call copy_ibglobals
End Sub

Sub PpollUnconfig(ByVal ud As Integer, addrs() As Integer)
    Call PPollUnconfig32(ud, addrs(0))
    Call copy_ibglobals
End Sub

Sub RcvRespMsg(ByVal ud As Integer, buf As String, ByVal term As Integer)
    Dim cnt As Long
    cnt = CLng(Len(buf))
    Call RcvRespMsg32(ud, ByVal buf, cnt, term)
    Call copy_ibglobals
End Sub

Sub ReadStatusByte(ByVal ud As Integer, ByVal addr As Integer, result As Integer)
    Dim tmpresult As Long
    Call ReadStatusByte32(ud, addr, tmpresult)
    result = Long2Int(tmpresult)
    Call copy_ibglobals
End Sub

Sub Receive(ByVal ud As Integer, ByVal addr As Integer, buf As String, ByVal term As Integer)
    Dim cnt As Long

    cnt = CLng(Len(buf))
    Call Receive32(ud, addr, ByVal buf, cnt, term)
    Call copy_ibglobals
End Sub

Sub ReceiveSetup(ByVal ud As Integer, ByVal addr As Integer)
    Call ReceiveSetup32(ud, addr)
    Call copy_ibglobals
End Sub

Sub ResetSys(ByVal ud As Integer, addrs() As Integer)
    Call ResetSys32(ud, addrs(0))
    Call copy_ibglobals
End Sub

Sub Send(ByVal ud As Integer, ByVal addr As Integer, ByVal buf As String, ByVal term As Integer)
    Dim cnt As Long
    cnt = CLng(Len(buf))
    Call Send32(ud, addr, ByVal buf, cnt, term)
    Call copy_ibglobals
End Sub

Sub SendCmds(ByVal ud As Integer, ByVal cmdbuf As String)
    Dim cnt As Long

    cnt = CLng(Len(cmdbuf))
    Call SendCmds32(ud, ByVal cmdbuf, cnt)
    Call copy_ibglobals
End Sub

Sub SendDataBytes(ByVal ud As Integer, ByVal buf As String, ByVal term As Integer)
    Dim cnt As Long

    cnt = CLng(Len(buf))
    Call SendDataBytes32(ud, ByVal buf, cnt, term)
    Call copy_ibglobals
End Sub

Sub SendIFC(ByVal ud As Integer)
    Call SendIFC32(ud)
    Call copy_ibglobals
End Sub

Sub SendList(ByVal ud As Integer, addr() As Integer, ByVal buf As String, ByVal term As Integer)
    Dim cnt As Long

    cnt = CLng(Len(buf))
    Call SendList32(ud, addr(0), ByVal buf, cnt, term)
    Call copy_ibglobals
End Sub

Sub SendLLO(ByVal ud As Integer)
    Call SendLLO32(ud)
    Call copy_ibglobals
End Sub

Sub SendSetup(ByVal ud As Integer, addrs() As Integer)
    Call SendSetup32(ud, addrs(0))
    Call copy_ibglobals
End Sub

Sub SetRWLS(ByVal ud As Integer, addrs() As Integer)
    Call SetRWLS32(ud, addrs(0))
    Call copy_ibglobals
End Sub

Sub TestSRQ(ByVal ud As Integer, result As Integer)
        Call TestSRQ32(ud, result)
    Call copy_ibglobals
End Sub

Sub TestSys(ByVal ud As Integer, addrs() As Integer, results() As Integer)
    Call TestSys32(ud, addrs(0), results(0))
    Call copy_ibglobals
End Sub

Sub Trigger(ByVal ud As Integer, ByVal addr As Integer)
    Call Trigger32(ud, addr)
    Call copy_ibglobals
End Sub

Sub TriggerList(ByVal ud As Integer, addrs() As Integer)
    Call TriggerList32(ud, addrs(0))
    Call copy_ibglobals
End Sub

Sub WaitSRQ(ByVal ud As Integer, result As Integer)
    Call WaitSRQ32(ud, result)
    Call copy_ibglobals
End Sub


Private Function Long2Int(Valu As Long) As Integer

  If (Valu And &H8000&) = 0 Then
      Long2Int = Valu And &HFFFF&
  Else
    Long2Int = &H8000 Or (Valu And &H7FFF&)
  End If

End Function




