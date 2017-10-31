{*******************************************************}
{       Borland Delphi Run-time Library                 }
{       Win32 ADLINK GPIB Interface Unit                }
{                                                       }
{       Copyright (c) 2005, ADLINK TECHNOLOGY INC.      }
{*******************************************************}

unit Adgpib;

interface

uses Windows, gpib_user;

Const
    NOADDR = $ffff;
    //tells RcvRespMsg() to stop on EOI
    STOPend = $100;

    //sad_special_address
    NO_SAD = 0;
    ALL_SAD = -1;

Type
    send_eotmode = (NULLend, NLend, DABend);
    Tsend_eotmodes = set of send_eotmode;
    Addr4882_t = U16;
    ssize_t    = I32;
    size_t     = U32;

    (* Type declarations for exported 488.2 Global Variables *)
    Tibsta  = function : integer ; stdcall;
    Tiberr  = function : integer ; stdcall;
    Tibcnt  = function : integer ; stdcall;
    Tibcntl = function : Longint ; stdcall;

    TGpibNotifyCallback = function(a:Integer; b:Integer; c:Integer; d:Longint; e:Pointer):Integer; stdcall;

function ibsta(): Integer ; stdcall;
function iberr(): Integer ; stdcall;
function ibcnt(): Integer ; stdcall;
function ibcntl(): Integer ; stdcall;

function MakeAddr(pad: Cardinal;sad:Cardinal):Addr4882_t;
function GetPAD(address:Addr4882_t):Cardinal;
function GetSAD(address:Addr4882_t):Cardinal;

{ IEEE 488 Function Prototypes }
function ibask(ud:Integer;option:Integer;value:PINT): Integer ; stdcall;
function ibbna(ud:Integer;board_name:PChar): Integer ; stdcall;
function ibbnaA(ud:Integer;board_name:PChar): Integer ; stdcall;
function ibbnaW(ud:Integer;board_name:WChar): Integer ; stdcall;
function ibcac(ud:Integer;synchronous:Integer): Integer ; stdcall;
function ibclr(ud:Integer): Integer ; stdcall;
function ibcmd(ud:Integer;const cmd: Pointer;cnt:Longint): Integer ; stdcall;
function ibcmda(ud:Integer;const cmd: Pointer;cnt:Longint): Integer ; stdcall;
function ibconfig(ud:Integer;option:Integer;value:Integer): Integer ; stdcall;
function ibdev(board_index:Integer;pad:Integer;sad:Integer;timo:Integer;send_eoi:Integer;eosmode:Integer): Integer ; stdcall;
function ibdma(ud:Integer;v:Integer): Integer ; stdcall;
function ibeot(ud:Integer;v:Integer): Integer ; stdcall;
function ibeos(ud:Integer;v:Integer): Integer ; stdcall;
function ibfind(const dev: PChar): Integer ; stdcall;
function ibfindA(const dev: PChar): Integer ; stdcall;
function ibfindW(const dev: PChar): Integer ; stdcall;
function ibgts(ud:Integer;shadow_handshake:Integer): Integer ; stdcall;
function ibist(ud:Integer;ist:Integer): Integer ; stdcall;
function iblines(ud:Integer;line_status:PUCHAR): Integer ; stdcall;
function ibln(ud:Integer;pad:Integer;sad:Integer;found_listener:PUCHAR): Integer ; stdcall;
function ibloc(ud:Integer): Integer ; stdcall;
function ibonl(ud:Integer;onl:Integer): Integer ; stdcall;
function ibpad(ud:Integer;v:Integer): Integer ; stdcall;
function ibpct(ud:Integer): Integer ; stdcall;
function ibppc(ud:Integer;v:Integer): Integer ; stdcall;
function ibrd(ud:Integer;buf:Pointer;count:Longint): Integer ; stdcall;
function ibrda(ud:Integer;buf:Pointer;count:Longint): Integer ; stdcall;
function ibrdf(ud:Integer;const file_path: PChar): Integer ; stdcall;
function ibrdfA(ud:Integer;const file_path: PChar): Integer ; stdcall;
function ibrdfW(ud:Integer;const file_path: PChar): Integer ; stdcall;
function ibrpp(ud:Integer;ppr:PChar): Integer ; stdcall;
function ibrsc(ud:Integer;v:Integer): Integer ; stdcall;
function ibrsp(ud:Integer;spr:PChar): Integer ; stdcall;
function ibrsv(ud:Integer;v:Integer): Integer ; stdcall;
function ibsad(ud:Integer;v:Integer): Integer ; stdcall;
function ibsic(ud:Integer): Integer ; stdcall;
function ibsre(ud:Integer;v:Integer): Integer ; stdcall;
function ibstop(ud:Integer): Integer ; stdcall;
function ibtmo(ud:Integer;v:Integer): Integer ; stdcall;
function ibtrg(ud:Integer): Integer ; stdcall;
function ibwait(ud:Integer;mask:Integer): Integer ; stdcall;
function ibwrt(ud:Integer;const buf: Pointer;count:Longint): Integer ; stdcall;
function ibwrta(ud:Integer;const buf: Pointer;count:Longint): Integer ; stdcall;
function ibwrtf(ud:Integer;const file_path: PChar): Integer ; stdcall;
function ibwrtfA(ud:Integer;const file_path: PChar): Integer ; stdcall;
function ibwrtfW(ud:Integer;const file_path: PChar): Integer ; stdcall;

function gpib_get_globals(pibsta:PINT;piberr:PINT;pibcnt:PINT;ibcntl:PINT): Integer ; stdcall;
function gpib_error_string(iberr:Integer): PChar;

{IEEE 488.2 Function Prototypes}
procedure AllSPoll2(board_desc:Integer;const addressList: array of Pointer; resultList: array of Byte); stdcall;
procedure AllSpoll(board_desc:Integer;const addressList: Pointer; resultList: array of Byte); stdcall;
procedure DevClear(board_desc:Integer;address: Addr4882_t); stdcall;
procedure DevClearList(board_desc:Integer;const addressList: Pointer); stdcall;
procedure EnableLocal(board_desc:Integer;const addressList: Pointer); stdcall;
procedure EnableRemote(board_desc:Integer;const addressList: Pointer); stdcall;
procedure FindLstn(board_desc:Integer;const padList: Pointer;resultList: Pointer; maxNumResults:Integer); stdcall;
procedure FindRQS(board_desc:Integer;const addressList: Pointer; result:PByte); stdcall;
procedure PassControl(board_desc:Integer;address:Addr4882_t); stdcall;
procedure PPoll(board_desc:Integer;result:PByte); stdcall;
procedure PPollConfig(board_desc:Integer;address:Addr4882_t;dataLine:Integer;lineSense:Integer); stdcall;
procedure PPollUnconfig(board_desc:Integer;const addressList: Pointer); stdcall;
procedure RcvRespMsg(board_desc:Integer;buffer:Pointer;count:Longint;termination:Integer); stdcall;
procedure ReadStatusByte(board_desc:Integer;address:Addr4882_t;result:PByte); stdcall;
procedure Receive(board_desc:Integer;address:Addr4882_t; buffer:Pointer;count:Longint;termination:Integer); stdcall;
procedure ReceiveSetup(board_desc:Integer;address:Addr4882_t); stdcall;
procedure ResetSys(board_desc:Integer;const addressList: Pointer); stdcall;
procedure Send(board_desc:Integer;address:Addr4882_t;const buffer: Pointer;count:Longint;eot_mode:Integer); stdcall;
procedure SendCmds(board_desc:Integer;const cmds: Pointer;count:Longint); stdcall;
procedure SendDataBytes(board_desc:Integer;const buffer: Pointer;count:Longint;eotmode:Integer); stdcall;
procedure SendIFC(board_desc:Integer); stdcall;
procedure SendLLO(board_desc:Integer); stdcall;
procedure SendList(board_desc:Integer;const addressList: Pointer; const buffer: Pointer;count:Longint;eotmode:Integer); stdcall;
procedure SendSetup(board_desc:Integer;const addressList: Pointer); stdcall;
procedure SetRWLS(board_desc:Integer;const addressList: Pointer); stdcall;
procedure TestSRQ(board_desc:Integer;result:PByte); stdcall;
procedure TestSys(board_desc:Integer;addrlist:PWORD;resultList: array of Byte); stdcall;
procedure Trigger(board_desc:Integer;address:Addr4882_t); stdcall;
procedure TriggerList(board_desc:Integer;const addressList: Pointer); stdcall;
procedure WaitSRQ(board_desc:Integer;result:PByte); stdcall;

implementation

function ibsta; external 'gpib-32.dll' name 'user_ibsta';
function iberr; external 'gpib-32.dll' name 'user_iberr';
function ibcnt; external 'gpib-32.dll' name 'user_ibcnt';
function ibcntl; external 'gpib-32.dll' name 'user_ibcntl';

{ Externals from gpib-32.dll }
function ibask; external 'gpib-32.dll' name 'ibask';
function ibbna; external 'gpib-32.dll' name 'ibbnaA';
function ibbnaA; external 'gpib-32.dll' name 'ibbnaA';
function ibbnaW; external 'gpib-32.dll' name 'ibbnaW';
function ibcac; external 'gpib-32.dll' name 'ibcac';
function ibclr; external 'gpib-32.dll' name 'ibclr';
function ibcmd; external 'gpib-32.dll' name 'ibcmd';
function ibcmda; external 'gpib-32.dll' name 'ibcmda';
function ibconfig; external 'gpib-32.dll' name 'ibconfig';
function ibdev; external 'gpib-32.dll' name 'ibdev';
function ibdma; external 'gpib-32.dll' name 'ibdma';
function ibeot; external 'gpib-32.dll' name 'ibeot';
function ibeos; external 'gpib-32.dll' name 'ibeos';
function ibfind; external 'gpib-32.dll' name 'ibfindA';
function ibfindA; external 'gpib-32.dll' name 'ibfindA';
function ibfindW; external 'gpib-32.dll' name 'ibfindW';
function ibgts; external 'gpib-32.dll' name 'ibgts';
function ibist; external 'gpib-32.dll' name 'ibist';
function iblines; external 'gpib-32.dll' name 'iblines';
function ibln; external 'gpib-32.dll' name 'ibln';
function ibloc; external 'gpib-32.dll' name 'ibloc';
function ibonl; external 'gpib-32.dll' name 'ibonl';
function ibpad; external 'gpib-32.dll' name 'ibpad';
function ibpct; external 'gpib-32.dll' name 'ibpct';
function ibppc; external 'gpib-32.dll' name 'ibppc';
function ibrd; external 'gpib-32.dll' name 'ibrd';
function ibrda; external 'gpib-32.dll' name 'ibrda';
function ibrdf; external 'gpib-32.dll' name 'ibrdfA';
function ibrdfA; external 'gpib-32.dll' name 'ibrdfA';
function ibrdfW; external 'gpib-32.dll' name 'ibrdfW';
function ibrpp; external 'gpib-32.dll' name 'ibrpp';
function ibrsc; external 'gpib-32.dll' name 'ibrsc';
function ibrsp; external 'gpib-32.dll' name 'ibrsp';
function ibrsv; external 'gpib-32.dll' name 'ibrsv';
function ibsad; external 'gpib-32.dll' name 'ibsad';
function ibsic; external 'gpib-32.dll' name 'ibsic';
function ibsre; external 'gpib-32.dll' name 'ibsre';
function ibstop; external 'gpib-32.dll' name 'ibstop';
function ibtmo; external 'gpib-32.dll' name 'ibtmo';
function ibtrg; external 'gpib-32.dll' name 'ibtrg';
function ibwait; external 'gpib-32.dll' name 'ibwait';
function ibwrt; external 'gpib-32.dll' name 'ibwrt';
function ibwrta; external 'gpib-32.dll' name 'ibwrta';
function ibwrtf; external 'gpib-32.dll' name 'ibwrtfA';
function ibwrtfA; external 'gpib-32.dll' name 'ibwrtfA';
function ibwrtfW; external 'gpib-32.dll' name 'ibwrtfW';
function gpib_get_globals; external 'gpib-32.dll' name 'gpib_get_globals';
function gpib_error_string; external 'gpib-32.dll' name 'gpib_error_string';

procedure AllSPoll2; external 'gpib-32.dll' name 'AllSPoll';
procedure AllSpoll; external 'gpib-32.dll' name 'AllSpoll';
procedure DevClear; external 'gpib-32.dll' name 'DevClear';
procedure DevClearList; external 'gpib-32.dll' name 'DevClearList';
procedure EnableLocal; external 'gpib-32.dll' name 'EnableLocal';
procedure EnableRemote; external 'gpib-32.dll' name 'EnableRemote';
procedure FindLstn; external 'gpib-32.dll' name 'FindLstn';
procedure FindRQS; external 'gpib-32.dll' name 'FindRQS';
procedure PassControl; external 'gpib-32.dll' name 'PassControl';
procedure PPoll; external 'gpib-32.dll' name 'PPoll';
procedure PPollConfig; external 'gpib-32.dll' name 'PPollConfig';
procedure PPollUnconfig; external 'gpib-32.dll' name 'PPollUnconfig';
procedure RcvRespMsg; external 'gpib-32.dll' name 'RcvRespMsg';
procedure ReadStatusByte; external 'gpib-32.dll' name 'ReadStatusByte';
procedure Receive; external 'gpib-32.dll' name 'Receive';
procedure ReceiveSetup; external 'gpib-32.dll' name 'ReceiveSetup';
procedure ResetSys; external 'gpib-32.dll' name 'ResetSys';
procedure Send; external 'gpib-32.dll' name 'Send';
procedure SendCmds; external 'gpib-32.dll' name 'SendCmds';
procedure SendDataBytes; external 'gpib-32.dll' name 'SendDataBytes';
procedure SendIFC; external 'gpib-32.dll' name 'SendIFC';
procedure SendLLO; external 'gpib-32.dll' name 'SendLLO';
procedure SendList; external 'gpib-32.dll' name 'SendList';
procedure SendSetup; external 'gpib-32.dll' name 'SendSetup';
procedure SetRWLS; external 'gpib-32.dll' name 'SetRWLS';
procedure TestSRQ; external 'gpib-32.dll' name 'TestSRQ';
procedure TestSys; external 'gpib-32.dll' name 'TestSys';
procedure Trigger; external 'gpib-32.dll' name 'Trigger';
procedure TriggerList; external 'gpib-32.dll' name 'TriggerList';
procedure WaitSRQ; external 'gpib-32.dll' name 'WaitSRQ';

function MakeAddr(pad: Cardinal;sad:Cardinal):Addr4882_t;
Var
   address:Addr4882_t;
Begin
   address := (pad and $ff);
   address := address or (sad shl 8) and $ff00;
   Result := address;
   Exit;
end;

function GetPAD(address:Addr4882_t):Cardinal;
Begin
   Result := address and $ff;
   Exit;
end;

function GetSAD(address:Addr4882_t):Cardinal;
Begin
   Result := (address shr 8) and $ff;
   Exit;
end;

end.
