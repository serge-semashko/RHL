Option Strict Off
Option Explicit On 
Imports System.Runtime.InteropServices

Module GPIB

    Public ibsta As Integer
    Public iberr As Integer
    Public ibcnt As Integer
    Public ibcntl As Integer

    Public buf As String

    Public bytebuf() As Byte

    Public Const UNL As Short = &H3FS
    Public Const UNT As Short = &H5FS
    Public Const GTL As Short = &H1S
    Public Const SDC As Short = &H4S
    Public Const PPC As Short = &H5S
    Public Const GGET As Short = &H8S
    Public Const TCT As Short = &H9S
    Public Const LLO As Short = &H11S
    Public Const DCL As Short = &H14S
    Public Const PPU As Short = &H15S
    Public Const SPE As Short = &H18S
    Public Const SPD As Short = &H19S
    Public Const PPE As Short = &H60S
    Public Const PPD As Short = &H70S

    Public Const EERR As Short = &H8000S
    Public Const TIMO As Short = &H4000S
    Public Const EEND As Short = &H2000S
    Public Const SRQI As Short = &H1000S
    Public Const RQS As Short = &H800S
    Public Const CMPL As Short = &H100S
    Public Const LOK As Short = &H80S
    Public Const RREM As Short = &H40S
    Public Const CIC As Short = &H20S
    Public Const AATN As Short = &H10S
    Public Const TACS As Short = &H8S
    Public Const LACS As Short = &H4S
    Public Const DTAS As Short = &H2S
    Public Const DCAS As Short = &H1S

    Public Const EDVR As Short = 0
    Public Const ECIC As Short = 1
    Public Const ENOL As Short = 2
    Public Const EADR As Short = 3
    Public Const EARG As Short = 4
    Public Const ESAC As Short = 5
    Public Const EABO As Short = 6
    Public Const ENEB As Short = 7
    Public Const EDMA As Short = 8
    Public Const EOIP As Short = 10

    Public Const ECAP As Short = 11
    Public Const EFSO As Short = 12
    Public Const EBUS As Short = 14
    Public Const ESTB As Short = 15
    Public Const ESRQ As Short = 16
    Public Const ETAB As Short = 20
    Public Const ELCK As Short = 21

    Public Const BIN As Short = &H1000S
    Public Const XEOS As Short = &H800S
    Public Const REOS As Short = &H400S

    Public Const TNONE As Short = 0
    Public Const T10us As Short = 1
    Public Const T30us As Short = 2
    Public Const T100us As Short = 3
    Public Const T300us As Short = 4
    Public Const T1ms As Short = 5
    Public Const T3ms As Short = 6
    Public Const T10ms As Short = 7
    Public Const T30ms As Short = 8
    Public Const T100ms As Short = 9
    Public Const T300ms As Short = 10
    Public Const T1s As Short = 11
    Public Const T3s As Short = 12
    Public Const T10s As Short = 13
    Public Const T30s As Short = 14
    Public Const T100s As Short = 15
    Public Const T300s As Short = 16
    Public Const T1000s As Short = 17

    Public Const ALL_SAD As Short = -1
    Public Const NO_SAD As Short = 0

    Public Const IbcPAD As Short = &H1S
    Public Const IbcSAD As Short = &H2S
    Public Const IbcTMO As Short = &H3S
    Public Const IbcEOT As Short = &H4S
    Public Const IbcPPC As Short = &H5S
    Public Const IbcREADDR As Short = &H6S
    Public Const IbcAUTOPOLL As Short = &H7S
    Public Const IbcCICPROT As Short = &H8S
    Public Const IbcIRQ As Short = &H9S
    Public Const IbcSC As Short = &HAS
    Public Const IbcSRE As Short = &HBS
    Public Const IbcEOSrd As Short = &HCS
    Public Const IbcEOSwrt As Short = &HDS
    Public Const IbcEOScmp As Short = &HES
    Public Const IbcEOSchar As Short = &HFS
    Public Const IbcPP2 As Short = &H10S
    Public Const IbcTIMING As Short = &H11S
    Public Const IbcDMA As Short = &H12S
    Public Const IbcReadAdjust As Short = &H13S
    Public Const IbcWriteAdjust As Short = &H14S
    Public Const IbcSendLLO As Short = &H17S
    Public Const IbcSPollTime As Short = &H18S
    Public Const IbcPPollTime As Short = &H19S
    Public Const IbcEndBitIsNormal As Short = &H1AS
    Public Const IbcUnAddr As Short = &H1BS
    Public Const IbcSignalNumber As Short = &H1CS
    Public Const IbcHSCableLength As Short = &H1FS
    Public Const IbcIst As Short = &H20S
    Public Const IbcRsv As Short = &H21S
    Public Const IbcLON As Short = &H22S

    Public Const IbaPAD As Short = &H1S
    Public Const IbaSAD As Short = &H2S
    Public Const IbaTMO As Short = &H3S
    Public Const IbaEOT As Short = &H4S
    Public Const IbaPPC As Short = &H5S
    Public Const IbaREADDR As Short = &H6S
    Public Const IbaAUTOPOLL As Short = &H7S
    Public Const IbaCICPROT As Short = &H8S
    Public Const IbaIRQ As Short = &H9S
    Public Const IbaSC As Short = &HAS
    Public Const IbaSRE As Short = &HBS
    Public Const IbaEOSrd As Short = &HCS
    Public Const IbaEOSwrt As Short = &HDS
    Public Const IbaEOScmp As Short = &HES
    Public Const IbaEOSchar As Short = &HFS
    Public Const IbaPP2 As Short = &H10S
    Public Const IbaTIMING As Short = &H11S
    Public Const IbaDMA As Short = &H12S
    Public Const IbaReadAdjust As Short = &H13S
    Public Const IbaWriteAdjust As Short = &H14S
    Public Const IbaSendLLO As Short = &H17S
    Public Const IbaSPollTime As Short = &H18S
    Public Const IbaPPollTime As Short = &H19S
    Public Const IbaEndBitIsNormal As Short = &H1AS
    Public Const IbaUnAddr As Short = &H1BS
    Public Const IbaSignalNumber As Short = &H1CS
    Public Const IbaHSCableLength As Short = &H1FS
    Public Const IbaIst As Short = &H20S
    Public Const IbaRsv As Short = &H21S
    Public Const IbaBNA As Short = &H200S
    Public Const IbaBaseAddr As Short = &H201S
    Public Const IbaDmaChannel As Short = &H202S
    Public Const IbaIrqLevel As Short = &H203S
    Public Const IbaBaud As Short = &H204S
    Public Const IbaParity As Short = &H205S
    Public Const IbaStopBits As Short = &H206S
    Public Const IbaDataBits As Short = &H207S
    Public Const IbaComPort As Short = &H208S
    Public Const IbaComIrqLevel As Short = &H209S
    Public Const IbaComPortBase As Short = &H20AS
    Public Const IbaSingleCycleDma As Short = &H20BS
    Public Const IbaSlotNumber As Short = &H20CS
    Public Const IbaLPTNumber As Short = &H20DS
    Public Const IbaLPTType As Short = &H20ES

    Public Const NULLend As Short = &H0S
    Public Const NLend As Short = &H1S
    Public Const DABend As Short = &H2S

    Public Const STOPend As Short = &H100S

    Public Const ValidEOI As Short = &H80S
    Public Const ValidATN As Short = &H40S
    Public Const ValidSRQ As Short = &H20S
    Public Const ValidREN As Short = &H10S
    Public Const ValidIFC As Short = &H8S
    Public Const ValidNRFD As Short = &H4S
    Public Const ValidNDAC As Short = &H2S
    Public Const ValidDAV As Short = &H1S
    Public Const BusEOI As Short = &H8000S
    Public Const BusATN As Short = &H4000S
    Public Const BusSRQ As Short = &H2000S
    Public Const BusREN As Short = &H1000S
    Public Const BusIFC As Short = &H800S
    Public Const BusNRFD As Short = &H400S
    Public Const BusNDAC As Short = &H200S
    Public Const BusDAV As Short = &H100S

    Public Const NOADDR As Short = &HFFFFS
	
	
    Public Const TIMMEDIATE As Short = -1
	Public Const TINFINITE As Short = -2
	Public Const MAX_LOCKSHARENAME_LENGTH As Short = 64

    Function copy_ibglobals()
        Call gpib_get_globals32(ibsta, iberr, ibcnt, ibcntl)
    End Function


    Declare Function ibask32 Lib "Gpib-32.dll" Alias "ibask" (ByVal ud As Integer, ByVal opt As Integer, ByRef value As Integer) As Integer
    Declare Function ibbna32 Lib "Gpib-32.dll" Alias "ibbnaA" (ByVal ud As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String) As Integer
    Declare Function ibcac32 Lib "Gpib-32.dll" Alias "ibcac" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function ibclr32 Lib "Gpib-32.dll" Alias "ibclr" (ByVal ud As Integer) As Integer
    Declare Function ibcmd32 Lib "Gpib-32.dll" Alias "ibcmd" (ByVal ud As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String, ByVal cnt As Integer) As Integer
    Declare Function ibcmda32 Lib "Gpib-32.dll" Alias "ibcmda" (ByVal ud As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String, ByVal cnt As Integer) As Integer
    Declare Function ibconfig32 Lib "Gpib-32.dll" Alias "ibconfig" (ByVal ud As Integer, ByVal opt As Integer, ByVal v As Integer) As Integer
    Declare Function ibdev32 Lib "Gpib-32.dll" Alias "ibdev" (ByVal bdid As Integer, ByVal pad As Integer, ByVal sad As Integer, ByVal tmo As Integer, ByVal eot As Integer, ByVal eos As Integer) As Integer
    Declare Function ibdma32 Lib "Gpib-32.dll" Alias "ibdma" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function ibeos32 Lib "Gpib-32.dll" Alias "ibeos" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function ibeot32 Lib "Gpib-32.dll" Alias "ibeot" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function ibfind32 Lib "Gpib-32.dll" Alias "ibfindA" (<MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String) As Integer
    Declare Function ibgts32 Lib "Gpib-32.dll" Alias "ibgts" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function ibist32 Lib "Gpib-32.dll" Alias "ibist" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function iblines32 Lib "Gpib-32.dll" Alias "iblines" (ByVal ud As Integer, ByRef v As Integer) As Integer
    Declare Function ibln32 Lib "Gpib-32.dll" Alias "ibln" (ByVal ud As Integer, ByVal pad As Integer, ByVal sad As Integer, ByRef ln As Integer) As Integer
    Declare Function ibloc32 Lib "Gpib-32.dll" Alias "ibloc" (ByVal ud As Integer) As Integer
    Declare Function ibonl32 Lib "Gpib-32.dll" Alias "ibonl" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function ibpad32 Lib "Gpib-32.dll" Alias "ibpad" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function ibpct32 Lib "Gpib-32.dll" Alias "ibpct" (ByVal ud As Integer) As Integer
    Declare Function ibppc32 Lib "Gpib-32.dll" Alias "ibppc" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function ibrd32 Lib "Gpib-32.dll" Alias "ibrd" (ByVal ud As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String, ByVal cnt As Integer) As Integer
    Declare Function ibrda32 Lib "Gpib-32.dll" Alias "ibrda" (ByVal ud As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String, ByVal cnt As Integer) As Integer
    Declare Function ibrdf32 Lib "Gpib-32.dll" Alias "ibrdfA" (ByVal ud As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String) As Integer
    Declare Function ibrpp32 Lib "Gpib-32.dll" Alias "ibrpp" (ByVal ud As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String) As Integer
    Declare Function ibrsc32 Lib "Gpib-32.dll" Alias "ibrsc" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function ibrsp32 Lib "Gpib-32.dll" Alias "ibrsp" (ByVal ud As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String) As Integer
    Declare Function ibrsv32 Lib "Gpib-32.dll" Alias "ibrsv" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function ibsad32 Lib "Gpib-32.dll" Alias "ibsad" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function ibsic32 Lib "Gpib-32.dll" Alias "ibsic" (ByVal ud As Integer) As Integer
    Declare Function ibsre32 Lib "Gpib-32.dll" Alias "ibsre" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function ibstop32 Lib "Gpib-32.dll" Alias "ibstop" (ByVal ud As Integer) As Integer
    Declare Function ibtmo32 Lib "Gpib-32.dll" Alias "ibtmo" (ByVal ud As Integer, ByVal v As Integer) As Integer
    Declare Function ibtrg32 Lib "Gpib-32.dll" Alias "ibtrg" (ByVal ud As Integer) As Integer
    Declare Function ibwait32 Lib "Gpib-32.dll" Alias "ibwait" (ByVal ud As Integer, ByVal mask As Integer) As Integer
    Declare Function ibwrt32 Lib "Gpib-32.dll" Alias "ibwrt" (ByVal ud As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String, ByVal cnt As Integer) As Integer
    Declare Function ibwrta32 Lib "Gpib-32.dll" Alias "ibwrta" (ByVal ud As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String, ByVal cnt As Integer) As Integer
    Declare Function ibwrtf32 Lib "Gpib-32.dll" Alias "ibwrtfA" (ByVal ud As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String) As Integer

    Declare Function gpib_get_globals32 Lib "Gpib-32.dll" Alias "gpib_get_globals" (ByRef ibsta As Integer, ByRef iberr As Integer, ByRef ibcnt As Integer, ByRef ibcntl As Long) As Long

    Declare Sub AllSpoll32 Lib "Gpib-32.dll" Alias "AllSpoll" (ByVal ud As Integer, ByRef arg1 As Long, ByRef arg2 As Long)
    Declare Sub DevClear32 Lib "Gpib-32.dll" Alias "DevClear" (ByVal ud As Integer, ByVal v As Integer)
    Declare Sub DevClearList32 Lib "Gpib-32.dll" Alias "DevClearList" (ByVal ud As Integer, ByRef arg1 As Long)
    Declare Sub EnableLocal32 Lib "Gpib-32.dll" Alias "EnableLocal" (ByVal ud As Integer, ByRef arg1 As Long)
    Declare Sub EnableRemote32 Lib "Gpib-32.dll" Alias "EnableRemote" (ByVal ud As Integer, ByRef arg1 As Long)
    Declare Sub FindLstn32 Lib "Gpib-32.dll" Alias "FindLstn" (ByVal ud As Integer, ByRef arg1 As Short, ByRef arg2 As Short, ByVal limit As Integer)
    Declare Sub FindRQS32 Lib "Gpib-32.dll" Alias "FindRQS" (ByVal boardID As Long, ByVal arg1 As Long, ByVal result As Long)
    Declare Sub PassControl32 Lib "Gpib-32.dll" Alias "PassControl" (ByVal ud As Integer, ByVal addr As Integer)
    Declare Sub PPoll32 Lib "Gpib-32.dll" Alias "PPoll" (ByVal ud As Integer, ByRef result As Integer)
    Declare Sub PPollConfig32 Lib "Gpib-32.dll" Alias "PPollConfig" (ByVal ud As Integer, ByVal addr As Integer, ByVal line As Integer, ByVal sense As Integer)
    Declare Sub PPollUnconfig32 Lib "Gpib-32.dll" Alias "PPollUnconfig" (ByVal ud As Integer, ByRef arg1 As Long)
    Declare Sub RcvRespMsg32 Lib "Gpib-32.dll" Alias "RcvRespMsg" (ByVal ud As Integer, ByRef arg1 As Long, ByVal cnt As Integer, ByVal term As Integer)
    Declare Sub ReadStatusByte32 Lib "Gpib-32.dll" Alias "ReadStatusByte" (ByVal ud As Integer, ByVal addr As Integer, ByRef result As Integer)
    Declare Sub Receive32 Lib "Gpib-32.dll" Alias "Receive" (ByVal ud As Integer, ByVal addr As Integer, ByRef arg1 As Long, ByVal cnt As Integer, ByVal term As Integer)
    Declare Sub ReceiveSetup32 Lib "Gpib-32.dll" Alias "ReceiveSetup" (ByVal ud As Integer, ByVal addr As Integer)
    Declare Sub ResetSys32 Lib "Gpib-32.dll" Alias "ResetSys" (ByVal ud As Integer, ByRef arg1 As Long)
    Declare Sub Send32 Lib "Gpib-32.dll" Alias "Send" (ByVal ud As Integer, ByVal addr As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String, ByVal cnt As Integer, ByVal term As Integer)
    Declare Sub SendCmds32 Lib "Gpib-32.dll" Alias "SendCmds" (ByVal ud As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String, ByVal cnt As Integer)
    Declare Sub SendDataBytes32 Lib "Gpib-32.dll" Alias "SendDataBytes" (ByVal ud As Integer, <MarshalAsAttribute(UnmanagedType.VBByRefStr)> ByRef sstr As String, ByVal cnt As Integer, ByVal term As Integer)
    Declare Sub SendIFC32 Lib "Gpib-32.dll" Alias "SendIFC" (ByVal ud As Integer)
    Declare Sub SendList32 Lib "Gpib-32.dll" Alias "SendList" (ByVal ud As Integer, ByRef arg1 As Long, ByRef arg2 As Long, ByVal cnt As Integer, ByVal term As Integer)
    Declare Sub SendLLO32 Lib "Gpib-32.dll" Alias "SendLLO" (ByVal ud As Integer)
    Declare Sub SendSetup32 Lib "Gpib-32.dll" Alias "SendSetup" (ByVal ud As Integer, ByRef arg1 As Long)
    Declare Sub SetRWLS32 Lib "Gpib-32.dll" Alias "SetRWLS" (ByVal ud As Integer, ByRef arg1 As Long)
    Declare Sub TestSys32 Lib "Gpib-32.dll" Alias "TestSys" (ByVal ud As Integer, ByRef arg1 As Long, ByRef arg2 As Long)
    Declare Sub Trigger32 Lib "Gpib-32.dll" Alias "Trigger" (ByVal ud As Integer, ByVal addr As Integer)
    Declare Sub TriggerList32 Lib "Gpib-32.dll" Alias "TriggerList" (ByVal ud As Integer, ByRef arg1 As Long)

    Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Integer)

    Sub AllSpoll(ByVal ud As Short, ByRef addrs() As Short, ByRef results() As Short)
        ' Call the 32-bit DLL.
        Call AllSpoll32(ud, addrs(0), results(0))

        Call copy_ibglobals()
    End Sub

    Sub DevClear(ByVal ud As Short, ByVal addr As Short)
        Call DevClear32(ud, addr)
        Call copy_ibglobals()
    End Sub

    Sub DevClearList(ByVal ud As Short, ByRef addrs() As Short)
        Call DevClearList32(ud, addrs(0))
        Call copy_ibglobals()
    End Sub

    Sub EnableLocal(ByVal ud As Short, ByRef addrs() As Short)
        Call EnableLocal32(ud, addrs(0))
        Call copy_ibglobals()
    End Sub

    Sub EnableRemote(ByVal ud As Short, ByRef addrs() As Short)
        Call EnableRemote32(ud, addrs(0))
        Call copy_ibglobals()
    End Sub

    Sub FindLstn(ByVal ud As Short, ByRef addrs() As Short, ByRef results() As Short, ByVal limit As Short)
        Call FindLstn32(ud, addrs(0), results(0), limit)
        Call copy_ibglobals()
    End Sub

    Sub FindRQS(ByVal ud As Short, ByRef addrs() As Short, ByRef result As Short)
        Dim tmpresult As Integer
        Call FindRQS32(ud, addrs(0), tmpresult)
        result = ConvertLongToInt(tmpresult)
        Call copy_ibglobals()
    End Sub

    Sub ibask(ByVal ud As Short, ByVal opt As Short, ByRef rval As Short)
        Dim tmprval As Integer
        Call ibask32(ud, opt, tmprval)
        rval = ConvertLongToInt(tmprval)
    End Sub

    Sub ibbna(ByVal ud As Short, ByVal udname As String)
        Call ibbna32(ud, udname)
        Call copy_ibglobals()
    End Sub

    Sub ibcac(ByVal ud As Short, ByVal v As Short)
        Call ibcac32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub ibclr(ByVal ud As Short)
        Call ibclr32(ud)
        Call copy_ibglobals()
    End Sub

    Sub ibcmd(ByVal ud As Short, ByVal buf As String)
        Dim cnt As Integer
        cnt = CInt(Len(buf))
        Call ibcmd32(ud, buf, cnt)
        Call copy_ibglobals()
    End Sub

    Sub ibcmda(ByVal ud As Short, ByVal buf As String)
        Dim cnt As Integer
        cnt = CInt(Len(buf))
        Call ibcmd32(ud, buf, cnt)
        Call copy_ibglobals()
    End Sub

    Sub ibconfig(ByVal bdid As Short, ByVal opt As Short, ByVal v As Short)
        Call ibconfig32(bdid, opt, v)
        Call copy_ibglobals()
    End Sub

    Sub ibdev(ByVal bdid As Short, ByVal pad As Short, ByVal sad As Short, ByVal tmo As Short, ByVal eot As Short, ByVal eos As Short, ByRef ud As Short)
        ud = ConvertLongToInt(ibdev32(bdid, pad, sad, tmo, eot, eos))
        Call copy_ibglobals()
    End Sub


    Sub ibdma(ByVal ud As Short, ByVal v As Short)
        Call ibdma32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub ibeos(ByVal ud As Short, ByVal v As Short)
        Call ibeos32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub ibeot(ByVal ud As Short, ByVal v As Short)
        Call ibeot32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub ibfind(ByVal udname As String, ByRef ud As Short)
        ud = ConvertLongToInt(ibfind32(udname))
        Call copy_ibglobals()
    End Sub

    Sub ibgts(ByVal ud As Short, ByVal v As Short)
        Call ibgts32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub ibist(ByVal ud As Short, ByVal v As Short)
        Call ibist32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub iblines(ByVal ud As Short, ByRef lines As Short)
        Dim tmplines As Integer
        Call iblines32(ud, tmplines)
        lines = ConvertLongToInt(tmplines)
        Call copy_ibglobals()
    End Sub

    Sub ibln(ByVal ud As Short, ByVal pad As Short, ByVal sad As Short, ByRef ln As Short)
        Dim tmpln As Integer
        Call ibln32(ud, pad, sad, tmpln)
        ln = ConvertLongToInt(tmpln)
        Call copy_ibglobals()
    End Sub

    Sub ibloc(ByVal ud As Short)
        Call ibloc32(ud)
        Call copy_ibglobals()
    End Sub

    Sub ibonl(ByVal ud As Short, ByVal v As Short)
        Call ibonl32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub ibpad(ByVal ud As Short, ByVal v As Short)
        Call ibpad32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub ibpct(ByVal ud As Short)
        Call ibpct32(ud)
        Call copy_ibglobals()
    End Sub

    Sub ibppc(ByVal ud As Short, ByVal v As Short)
        Call ibppc32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub ibrd(ByVal ud As Short, ByRef buf As String)
        Dim cnt As Integer
        cnt = CInt(Len(buf))
        Call ibrd32(ud, buf, cnt)
        Call copy_ibglobals()
    End Sub

    Sub ibrda(ByVal ud As Short, ByRef buf As String)
        Dim cnt As Integer
        cnt = CInt(Len(buf))
        Call ibrd32(ud, buf, cnt)
        Call copy_ibglobals()
    End Sub

    Sub ibrdf(ByVal ud As Short, ByVal filename As String)
        Call ibrdf32(ud, filename)
        Call copy_ibglobals()
    End Sub

    Sub ibrdi(ByVal ud As Short, ByRef ibuf() As Short, ByVal cnt As Integer)
        Call ibrd32(ud, ibuf(0), cnt)
        Call copy_ibglobals()
    End Sub

    Sub ibrdia(ByVal ud As Short, ByRef ibuf() As Short, ByVal cnt As Integer)
        Call ibrd32(ud, ibuf(0), cnt)
        Call copy_ibglobals()
    End Sub



    Sub ibrpp(ByVal ud As Short, ByRef ppr As Short)
        Static tmp_str As New VB6.FixedLengthString(2)

        Call ibrpp32(ud, tmp_str.Value)
        ppr = Asc(tmp_str.Value)
        Call copy_ibglobals()
    End Sub

    Sub ibrsc(ByVal ud As Short, ByVal v As Short)
        Call ibrsc32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub ibrsp(ByVal ud As Short, ByRef spr As Short)
        Static tmp_str As New VB6.FixedLengthString(2)
        Call ibrsp32(ud, tmp_str.Value)
        spr = Asc(tmp_str.Value)
        Call copy_ibglobals()
    End Sub

    Sub ibrsv(ByVal ud As Short, ByVal v As Short)
        Call ibrsv32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub ibsad(ByVal ud As Short, ByVal v As Short)
        Call ibsad32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub ibsic(ByVal ud As Short)
        Call ibsic32(ud)
        Call copy_ibglobals()
    End Sub

    Sub ibsre(ByVal ud As Short, ByVal v As Short)
        Call ibsre32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub ibstop(ByVal ud As Short)
        Call ibstop32(ud)
        Call copy_ibglobals()
    End Sub

    Sub ibtmo(ByVal ud As Short, ByVal v As Short)
        Call ibtmo32(ud, v)
        Call copy_ibglobals()
    End Sub

    Sub ibtrg(ByVal ud As Short)
        Call ibtrg32(ud)
        Call copy_ibglobals()
    End Sub

    Sub ibwait(ByVal ud As Short, ByVal mask As Short)
        Call ibwait32(ud, mask)
        Call copy_ibglobals()
    End Sub

    Sub ibwrt(ByVal ud As Short, ByVal buf As String)
        Dim cnt As Integer
        cnt = CInt(Len(buf))
        Call ibwrt32(ud, buf, cnt)
        Call copy_ibglobals()
    End Sub

    Sub ibwrta(ByVal ud As Short, ByVal buf As String)
        Dim cnt As Integer
        cnt = CInt(Len(buf))
        Call ibwrt32(ud, buf, cnt)
        Call copy_ibglobals()
    End Sub

    Sub ibwrtf(ByVal ud As Short, ByVal filename As String)
        Call ibwrtf32(ud, filename)
        Call copy_ibglobals()
    End Sub

    Sub ibwrti(ByVal ud As Short, ByRef ibuf() As Short, ByVal cnt As Integer)
        Call ibwrt32(ud, ibuf(0), cnt)
        Call copy_ibglobals()
    End Sub

    Sub ibwrtia(ByVal ud As Short, ByRef ibuf() As Short, ByVal cnt As Integer)
        Call ibwrt32(ud, ibuf(0), cnt)
        Call copy_ibglobals()
    End Sub

    Function ilask(ByVal ud As Short, ByVal opt As Short, ByRef rval As Short) As Short
        Dim tmprval As Integer
        ilask = ConvertLongToInt(ibask32(ud, opt, tmprval))
        rval = ConvertLongToInt(tmprval)
        Call copy_ibglobals()
    End Function

    Function ilbna(ByVal ud As Short, ByVal udname As String) As Short
        ilbna = ConvertLongToInt(ibbna32(ud, udname))
        Call copy_ibglobals()
    End Function

    Function ilcac(ByVal ud As Short, ByVal v As Short) As Short
        ilcac = ConvertLongToInt(ibcac32(ud, v))
        Call copy_ibglobals()
    End Function

    Function ilclr(ByVal ud As Short) As Short
        ilclr = ConvertLongToInt(ibclr32(ud))
        Call copy_ibglobals()
    End Function

    Function ilcmd(ByVal ud As Short, ByVal buf As String, ByVal cnt As Integer) As Short
        ilcmd = ConvertLongToInt(ibcmd32(ud, buf, cnt))
        Call copy_ibglobals()
    End Function

    Function ilcmda(ByVal ud As Short, ByVal buf As String, ByVal cnt As Integer) As Short
        ilcmda = ConvertLongToInt(ibcmd32(ud, buf, cnt))
        Call copy_ibglobals()
    End Function

    Function ilconfig(ByVal bdid As Short, ByVal opt As Short, ByVal v As Short) As Short
        ilconfig = ConvertLongToInt(ibconfig32(bdid, opt, v))
        Call copy_ibglobals()
    End Function

    Function ildev(ByVal bdid As Short, ByVal pad As Short, ByVal sad As Short, ByVal tmo As Short, ByVal eot As Short, ByVal eos As Short) As Short
        ildev = ConvertLongToInt(ibdev32(bdid, pad, sad, tmo, eot, eos))
        Call copy_ibglobals()
    End Function


    Function ildma(ByVal ud As Short, ByVal v As Short) As Short
        ildma = ConvertLongToInt(ibdma32(ud, v))
        Call copy_ibglobals()
    End Function

    Function ileos(ByVal ud As Short, ByVal v As Short) As Short
        ileos = ConvertLongToInt(ibeos32(ud, v))
        Call copy_ibglobals()
    End Function

    Function ileot(ByVal ud As Short, ByVal v As Short) As Short
        ileot = ConvertLongToInt(ibeot32(ud, v))
        Call copy_ibglobals()
    End Function


    Function ilfind(ByVal udname As String) As Short
        ilfind = ConvertLongToInt(ibfind32(udname))
        Call copy_ibglobals()
    End Function

    Function ilgts(ByVal ud As Short, ByVal v As Short) As Short
        ilgts = ConvertLongToInt(ibgts32(ud, v))
        Call copy_ibglobals()
    End Function

    Function ilist(ByVal ud As Short, ByVal v As Short) As Short
        ilist = ConvertLongToInt(ibist32(ud, v))
        Call copy_ibglobals()
    End Function

    Function illines(ByVal ud As Short, ByRef lines As Short) As Short
        Dim tmplines As Integer
        illines = ConvertLongToInt(iblines32(ud, tmplines))
        lines = ConvertLongToInt(tmplines)
        Call copy_ibglobals()
    End Function

    Function illn(ByVal ud As Short, ByVal pad As Short, ByVal sad As Short, ByRef ln As Short) As Short
        Dim tmpln As Integer
        illn = ConvertLongToInt(ibln32(ud, pad, sad, tmpln))
        ln = ConvertLongToInt(tmpln)
        Call copy_ibglobals()
    End Function

    Function illoc(ByVal ud As Short) As Short
        illoc = ConvertLongToInt(ibloc32(ud))
        Call copy_ibglobals()
    End Function

    Function ilonl(ByVal ud As Short, ByVal v As Short) As Short
        ilonl = ConvertLongToInt(ibonl32(ud, v))
        Call copy_ibglobals()
    End Function

    Function ilpad(ByVal ud As Short, ByVal v As Short) As Short
        ilpad = ConvertLongToInt(ibpad32(ud, v))
        Call copy_ibglobals()
    End Function

    Function ilpct(ByVal ud As Short) As Short
        ilpct = ConvertLongToInt(ibpct32(ud))
        Call copy_ibglobals()
    End Function

    Function ilppc(ByVal ud As Short, ByVal v As Short) As Short
        ilppc = ConvertLongToInt(ibppc32(ud, v))
        Call copy_ibglobals()
    End Function

    Function ilrd(ByVal ud As Short, ByRef buf As String, ByVal cnt As Integer) As Short
        Dim x As Long
        ilrd = ConvertLongToInt(ibrd32(ud, buf, cnt))
        Call copy_ibglobals()
    End Function

    Function ilrda(ByVal ud As Short, ByRef buf As String, ByVal cnt As Integer) As Short
        ilrda = ConvertLongToInt(ibrd32(ud, buf, cnt))
        Call copy_ibglobals()
    End Function

    Function ilrdf(ByVal ud As Short, ByVal filename As String) As Short
        ilrdf = ConvertLongToInt(ibrdf32(ud, filename))
        Call copy_ibglobals()
    End Function

    Function ilrdi(ByVal ud As Short, ByRef ibuf() As Short, ByVal cnt As Integer) As Short
        ilrdi = ConvertLongToInt(ibrd32(ud, ibuf(0), cnt))
        Call copy_ibglobals()
    End Function

    Function ilrdia(ByVal ud As Short, ByRef ibuf() As Short, ByVal cnt As Integer) As Short
        ilrdia = ConvertLongToInt(ibrd32(ud, ibuf(0), cnt))
        Call copy_ibglobals()
    End Function

    Function ilrpp(ByVal ud As Short, ByRef ppr As Short) As Short
        Static tmp_str As New VB6.FixedLengthString(2)
        ilrpp = ConvertLongToInt(ibrpp32(ud, tmp_str.Value))
        ppr = Asc(tmp_str.Value)
        Call copy_ibglobals()
    End Function

    Function ilrsc(ByVal ud As Short, ByVal v As Short) As Short
        ilrsc = ConvertLongToInt(ibrsc32(ud, v))
        Call copy_ibglobals()
    End Function

    Function ilrsp(ByVal ud As Short, ByRef spr As Short) As Short
        Static tmp_str As New VB6.FixedLengthString(2)
        ilrsp = ConvertLongToInt(ibrsp32(ud, tmp_str.Value))
        spr = Asc(tmp_str.Value)
        Call copy_ibglobals()
    End Function

    Function ilrsv(ByVal ud As Short, ByVal v As Short) As Short
        ilrsv = ConvertLongToInt(ibrsv32(ud, v))
        Call copy_ibglobals()
    End Function

    Function ilsad(ByVal ud As Short, ByVal v As Short) As Short
        ilsad = ConvertLongToInt(ibsad32(ud, v))
        Call copy_ibglobals()
    End Function

    Function ilsic(ByVal ud As Short) As Short
        ilsic = ConvertLongToInt(ibsic32(ud))
        Call copy_ibglobals()
    End Function

    Function ilsre(ByVal ud As Short, ByVal v As Short) As Short
        ilsre = ConvertLongToInt(ibsre32(ud, v))
        Call copy_ibglobals()
    End Function

    Function ilstop(ByVal ud As Short) As Short
        ilstop = ConvertLongToInt(ibstop32(ud))
        Call copy_ibglobals()
    End Function

    Function iltmo(ByVal ud As Short, ByVal v As Short) As Short
        iltmo = ConvertLongToInt(ibtmo32(ud, v))
        Call copy_ibglobals()
    End Function

    Function iltrg(ByVal ud As Short) As Short
        iltrg = ConvertLongToInt(ibtrg32(ud))
        Call copy_ibglobals()
    End Function

    Function ilwait(ByVal ud As Short, ByVal mask As Short) As Short
        ilwait = ConvertLongToInt(ibwait32(ud, mask))
        Call copy_ibglobals()
    End Function

    Function ilwrt(ByVal ud As Short, ByVal buf As String, ByVal cnt As Integer) As Short
        ilwrt = ConvertLongToInt(ibwrt32(ud, buf, cnt))
        Call copy_ibglobals()
    End Function

    Function ilwrta(ByVal ud As Short, ByVal buf As String, ByVal cnt As Integer) As Short
        ilwrta = ConvertLongToInt(ibwrt32(ud, buf, cnt))
        Call copy_ibglobals()
    End Function

    Function ilwrtf(ByVal ud As Short, ByVal filename As String) As Short
        ilwrtf = ConvertLongToInt(ibwrtf32(ud, filename))
        Call copy_ibglobals()
    End Function

    Function ilwrti(ByVal ud As Short, ByRef ibuf() As Short, ByVal cnt As Integer) As Short
        ilwrti = ConvertLongToInt(ibwrt32(ud, ibuf(0), cnt))
        Call copy_ibglobals()
    End Function

    Function ilwrtia(ByVal ud As Short, ByRef ibuf() As Short, ByVal cnt As Integer) As Short
        ilwrtia = ConvertLongToInt(ibwrt32(ud, ibuf(0), cnt))
        Call copy_ibglobals()
    End Function

    Sub PassControl(ByVal ud As Short, ByVal addr As Short)
        Call PassControl32(ud, addr)
        Call copy_ibglobals()
    End Sub

    Sub Ppoll(ByVal ud As Short, ByRef result As Short)
        Dim tmpresult As Integer
        Call PPoll32(ud, tmpresult)
        result = ConvertLongToInt(tmpresult)
        Call copy_ibglobals()
    End Sub

    Sub PpollConfig(ByVal ud As Short, ByVal addr As Short, ByVal lline As Short, ByVal sense As Short)
        Call PPollConfig32(ud, addr, lline, sense)
        Call copy_ibglobals()
    End Sub

    Sub PpollUnconfig(ByVal ud As Short, ByRef addrs() As Short)
        Call PPollUnconfig32(ud, addrs(0))
        Call copy_ibglobals()
    End Sub

    Sub RcvRespMsg(ByVal ud As Short, ByRef buf As String, ByVal term As Short)
        Dim cnt As Integer
        cnt = CInt(Len(buf))
        Call RcvRespMsg32(ud, buf, cnt, term)
        Call copy_ibglobals()
    End Sub

    Sub ReadStatusByte(ByVal ud As Short, ByVal addr As Short, ByRef result As Short)
        Dim tmpresult As Integer
        Call ReadStatusByte32(ud, addr, tmpresult)
        result = ConvertLongToInt(tmpresult)
        Call copy_ibglobals()
    End Sub

    Sub Receive(ByVal ud As Short, ByVal addr As Short, ByRef buf As String, ByVal term As Short)
        Dim cnt As Integer
        cnt = CInt(Len(buf))
        Call Receive32(ud, addr, buf, cnt, term)
        Call copy_ibglobals()
    End Sub

    Sub ReceiveSetup(ByVal ud As Short, ByVal addr As Short)
        Call ReceiveSetup32(ud, addr)
        Call copy_ibglobals()
    End Sub

    Sub ResetSys(ByVal ud As Short, ByRef addrs() As Short)
        Call ResetSys32(ud, addrs(0))
        Call copy_ibglobals()
    End Sub

    Sub Send(ByVal ud As Short, ByVal addr As Short, ByVal buf As String, ByVal term As Short)
        Dim cnt As Integer
        cnt = CInt(Len(buf))
        Call Send32(ud, addr, buf, cnt, term)
        Call copy_ibglobals()
    End Sub

    Sub SendCmds(ByVal ud As Short, ByVal cmdbuf As String)
        Dim cnt As Integer
        cnt = CInt(Len(cmdbuf))
        Call SendCmds32(ud, cmdbuf, cnt)
        Call copy_ibglobals()
    End Sub

    Sub SendDataBytes(ByVal ud As Short, ByVal buf As String, ByVal term As Short)
        Dim cnt As Integer
        cnt = CInt(Len(buf))
        Call SendDataBytes32(ud, buf, cnt, term)
        Call copy_ibglobals()
    End Sub

    Sub SendIFC(ByVal ud As Short)
        Call SendIFC32(ud)
        Call copy_ibglobals()
    End Sub

    Sub SendList(ByVal ud As Short, ByRef addr() As Short, ByVal buf As String, ByVal term As Short)
        Dim cnt As Integer
        cnt = CInt(Len(buf))
        Call SendList32(ud, addr(0), buf, cnt, term)
        Call copy_ibglobals()
    End Sub

    Sub SendLLO(ByVal ud As Short)
        Call SendLLO32(ud)
        Call copy_ibglobals()
    End Sub

    Sub SendSetup(ByVal ud As Short, ByRef addrs() As Short)
        Call SendSetup32(ud, addrs(0))
        Call copy_ibglobals()
    End Sub

    Sub SetRWLS(ByVal ud As Short, ByRef addrs() As Short)
        Call SetRWLS32(ud, addrs(0))
        Call copy_ibglobals()
    End Sub

    Sub TestSRQ(ByVal ud As Short, ByRef result As Short)
        Call ibwait(ud, 0)
        If ibsta And &H1000S Then
            result = 1
        Else
            result = 0
        End If
    End Sub

    Sub TestSys(ByVal ud As Short, ByRef addrs() As Short, ByRef results() As Short)
        Call TestSys32(ud, addrs(0), results(0))
        Call copy_ibglobals()
    End Sub

    Sub Trigger(ByVal ud As Short, ByVal addr As Short)
        Call Trigger32(ud, addr)
        Call copy_ibglobals()
    End Sub

    Sub TriggerList(ByVal ud As Short, ByRef addrs() As Short)
        Call TriggerList32(ud, addrs(0))
        Call copy_ibglobals()
    End Sub

    Sub WaitSRQ(ByVal ud As Short, ByRef result As Short)
        Call ibwait(ud, &H5000S)
        If ibsta And &H1000S Then
            result = 1
        Else
            result = 0
        End If
    End Sub

    Private Function ConvertLongToInt(ByRef LongNumb As Integer) As Short
        If (LongNumb And &H8000) = 0 Then
            ConvertLongToInt = LongNumb And &HFFFF
        Else
            ConvertLongToInt = &H8000S Or (LongNumb And &H7FFF)
        End If
    End Function

End Module