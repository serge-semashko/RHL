{ ******************************************************* }
{ Borland Delphi Run-time Library }
{ Win32 ADLINK GPIB Interface Unit }
{ }
{ Copyright (c) 2005, ADLINK TECHNOLOGY INC. }
{ ******************************************************* }

unit Adgpib;

interface

uses Windows, gpib_user;

Const
  NOADDR = $FFFF;
  // tells RcvRespMsg() to stop on EOI
  STOPend = $100;

  // sad_special_address
  NO_SAD = 0;
  ALL_SAD = -1;

Type
  send_eotmode = (NULLend, NLend, DABend);
  Tsend_eotmodes = set of send_eotmode;
  Addr4882_t = U16;
  ssize_t = I32;
  size_t = U32;

  (* Type declarations for exported 488.2 Global Variables *)
  Tibsta = function: integer; stdcall;
  Tiberr = function: integer; stdcall;
  Tibcnt = function: integer; stdcall;
  Tibcntl = function: Longint; stdcall;

  TGpibNotifyCallback = function(a: integer; b: integer; c: integer; d: Longint;
    e: Pointer): integer; stdcall;

function ibsta(): integer; stdcall;
function iberr(): integer; stdcall;
function ibcnt(): integer; stdcall;
function ibcntl(): integer; stdcall;

function MakeAddr(pad: Cardinal; sad: Cardinal): Addr4882_t;
function GetPAD(address: Addr4882_t): Cardinal;
function GetSAD(address: Addr4882_t): Cardinal;

{ IEEE 488 Function Prototypes }
function ibask(ud: integer; option: integer; value: PINT): integer; stdcall;
function ibbna(ud: integer; board_name: PChar): integer; stdcall;
function ibbnaA(ud: integer; board_name: PChar): integer; stdcall;
function ibbnaW(ud: integer; board_name: WChar): integer; stdcall;
function ibcac(ud: integer; synchronous: integer): integer; stdcall;
function ibclr(ud: integer): integer; stdcall;
function ibcmd(ud: integer; const cmd: Pointer; cnt: Longint): integer; stdcall;
function ibcmda(ud: integer; const cmd: Pointer; cnt: Longint)
  : integer; stdcall;
function ibconfig(ud: integer; option: integer; value: integer)
  : integer; stdcall;
function ibdev(board_index: integer; pad: integer; sad: integer; timo: integer;
  send_eoi: integer; eosmode: integer): integer; stdcall;
function ibdma(ud: integer; v: integer): integer; stdcall;
function ibeot(ud: integer; v: integer): integer; stdcall;
function ibeos(ud: integer; v: integer): integer; stdcall;
function ibfind(const dev: PChar): integer; stdcall;
function ibfindA(const dev: PChar): integer; stdcall;
function ibfindW(const dev: PChar): integer; stdcall;
function ibgts(ud: integer; shadow_handshake: integer): integer; stdcall;
function ibist(ud: integer; ist: integer): integer; stdcall;
function iblines(ud: integer; line_status: PUCHAR): integer; stdcall;
function ibln(ud: integer; pad: integer; sad: integer; found_listener: PUCHAR)
  : integer; stdcall;
function ibloc(ud: integer): integer; stdcall;
function ibonl(ud: integer; onl: integer): integer; stdcall;
function ibpad(ud: integer; v: integer): integer; stdcall;
function ibpct(ud: integer): integer; stdcall;
function ibppc(ud: integer; v: integer): integer; stdcall;
function ibrd(ud: integer; buf: Pointer; count: Longint): integer; stdcall;
function ibrda(ud: integer; buf: Pointer; count: Longint): integer; stdcall;
function ibrdf(ud: integer; const file_path: PChar): integer; stdcall;
function ibrdfA(ud: integer; const file_path: PChar): integer; stdcall;
function ibrdfW(ud: integer; const file_path: PChar): integer; stdcall;
function ibrpp(ud: integer; ppr: PChar): integer; stdcall;
function ibrsc(ud: integer; v: integer): integer; stdcall;
function ibrsp(ud: integer; spr: PChar): integer; stdcall;
function ibrsv(ud: integer; v: integer): integer; stdcall;
function ibsad(ud: integer; v: integer): integer; stdcall;
function ibsic(ud: integer): integer; stdcall;
function ibsre(ud: integer; v: integer): integer; stdcall;
function ibstop(ud: integer): integer; stdcall;
function ibtmo(ud: integer; v: integer): integer; stdcall;
function ibtrg(ud: integer): integer; stdcall;
function ibwait(ud: integer; mask: integer): integer; stdcall;
function ibwrt(ud: integer; const buf: Pointer; count: Longint)
  : integer; stdcall;
function ibwrta(ud: integer; const buf: Pointer; count: Longint)
  : integer; stdcall;
function ibwrtf(ud: integer; const file_path: PChar): integer; stdcall;
function ibwrtfA(ud: integer; const file_path: PChar): integer; stdcall;
function ibwrtfW(ud: integer; const file_path: PChar): integer; stdcall;

function gpib_get_globals(pibsta: PINT; piberr: PINT; pibcnt: PINT;
  ibcntl: PINT): integer; stdcall;
function gpib_error_string(iberr: integer): PChar;

{ IEEE 488.2 Function Prototypes }
procedure AllSPoll2(board_desc: integer; const addressList: array of Pointer;
  resultList: array of Byte); stdcall;
procedure AllSpoll(board_desc: integer; const addressList: Pointer;
  resultList: array of Byte); stdcall;
procedure DevClear(board_desc: integer; address: Addr4882_t); stdcall;
procedure DevClearList(board_desc: integer;
  const addressList: Pointer); stdcall;
procedure EnableLocal(board_desc: integer; const addressList: Pointer); stdcall;
procedure EnableRemote(board_desc: integer;
  const addressList: Pointer); stdcall;
procedure FindLstn(board_desc: integer; const padList: Pointer;
  resultList: Pointer; maxNumResults: integer); stdcall;
procedure FindRQS(board_desc: integer; const addressList: Pointer;
  result: PByte); stdcall;
procedure PassControl(board_desc: integer; address: Addr4882_t); stdcall;
procedure PPoll(board_desc: integer; result: PByte); stdcall;
procedure PPollConfig(board_desc: integer; address: Addr4882_t;
  dataLine: integer; lineSense: integer); stdcall;
procedure PPollUnconfig(board_desc: integer;
  const addressList: Pointer); stdcall;
procedure RcvRespMsg(board_desc: integer; buffer: Pointer; count: Longint;
  termination: integer); stdcall;
procedure ReadStatusByte(board_desc: integer; address: Addr4882_t;
  result: PByte); stdcall;
procedure Receive(board_desc: integer; address: Addr4882_t; buffer: Pointer;
  count: Longint; termination: integer); stdcall;
procedure ReceiveSetup(board_desc: integer; address: Addr4882_t); stdcall;
procedure ResetSys(board_desc: integer; const addressList: Pointer); stdcall;
procedure Send(board_desc: integer; address: Addr4882_t; const buffer: Pointer;
  count: Longint; eot_mode: integer); stdcall;
procedure SendCmds(board_desc: integer; const cmds: Pointer;
  count: Longint); stdcall;
procedure SendDataBytes(board_desc: integer; const buffer: Pointer;
  count: Longint; eotmode: integer); stdcall;
procedure SendIFC(board_desc: integer); stdcall;
procedure SendLLO(board_desc: integer); stdcall;
procedure SendList(board_desc: integer; const addressList: Pointer;
  const buffer: Pointer; count: Longint; eotmode: integer); stdcall;
procedure SendSetup(board_desc: integer; const addressList: Pointer); stdcall;
procedure SetRWLS(board_desc: integer; const addressList: Pointer); stdcall;
procedure TestSRQ(board_desc: integer; result: PByte); stdcall;
procedure TestSys(board_desc: integer; addrlist: PWORD;
  resultList: array of Byte); stdcall;
procedure Trigger(board_desc: integer; address: Addr4882_t); stdcall;
procedure TriggerList(board_desc: integer; const addressList: Pointer); stdcall;
procedure WaitSRQ(board_desc: integer; result: PByte); stdcall;

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

function MakeAddr(pad: Cardinal; sad: Cardinal): Addr4882_t;
Var
  address: Addr4882_t;
Begin
  address := (pad and $FF);
  address := address or (sad shl 8) and $FF00;
  result := address;
  Exit;
end;

function GetPAD(address: Addr4882_t): Cardinal;
Begin
  result := address and $FF;
  Exit;
end;

function GetSAD(address: Addr4882_t): Cardinal;
Begin
  result := (address shr 8) and $FF;
  Exit;
end;

end.
