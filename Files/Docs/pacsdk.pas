unit PACSDK;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

function  _pac_inp(addr : integer) : byte;  cdecl;
procedure _pac_outp(addr: integer; data : integer); cdecl;
function  _pac_slot_inp(slot : integer; addr: integer) : byte; cdecl;
procedure _pac_slot_outp(slot : integer; addr: integer; data : integer); cdecl;
  
//** System Functions:
procedure pac_EnableLEDs(pin : integer; flag : integer); cdecl;
procedure pac_GetSDKVersion(sdkver : PChar); cdecl; 
procedure pac_GetCPUVersion(cpuver : PChar); cdecl;
procedure pac_GetSerialNumber(serialnum : pchar); cdecl;
function  pac_GetModuleName(slot : integer; strName : PChar) : integer; cdecl; 
function pac_GetModuleType(slot : Byte) : integer; cdecl; 
function pac_GetRotaryID() : integer; cdecl; 
function pac_ModuleExists(hPort : integer; slot : integer) : integer;cdecl; 


//** Backplane API
procedure pac_ChangeSlot(slotNo : integer); cdecl;
procedure pac_GetBackplaneID(backplaneVersion : PChar); cdecl;
function pac_GetBatteryLevel(batteryNo : integer) : integer; cdecl;
function pac_GetDIPSwitch() : integer; cdecl; 
function pac_GetSlotCount() : Word; cdecl; 


//** Memory API
function pac_GetMemorySize(mem_type : integer) : dword; cdecl; 
function pac_ReadMemory(addr : dword; buf : pbyte; len : dword; mem_type : integer) : integer; cdecl;
function pac_WriteMemory(addr : dword; buf : pbyte; len : dword; mem_type : integer) : integer; cdecl; 
procedure pac_EnableEEPROM(bEnable : integer); cdecl; 

//** Watch Dog Timer Functions (under constructions)
procedure pac_DisableWatchDog(wdt : integer); cdecl;
procedure pac_RefreshWatchDog(wdt : integer); cdecl;
function pac_EnableWatchDog(wdt : integer; value : dword) : integer; cdecl;
function pac_GetWatchDogState(wdt : integer) : integer; cdecl;
function pac_GetWatchDogTime(wdt : integer) : dword; cdecl;
function pac_SetWatchDogTime(wdt : integer; value : dword) : integer; cdecl;


//** UART API
function uart_Open(ConnectionString : PChar) : integer; cdecl;
function uart_Close(hPort : integer) : integer; cdecl;
function uart_Send(hPort : integer; buf : PChar) : integer; cdecl;
function uart_Recv(hPort : integer; buf : PChar) : integer; cdecl;
function uart_SendCmd(hPort : integer; cmd : PChar; szResult : PChar) : integer; cdecl;
function uart_SendExt(hPort : integer; cmd : PChar; length : integer) : integer; cdecl;
function uart_RecvExt(hPort : integer; result : PChar; length : integer) : integer; cdecl;
function uart_SendCmdExt(hPort : integer; cmd : PChar; out_len : integer; result : PChar; in_len : integer) : integer; cdecl;
function uart_BinSend(hPort : integer; buf : pbyte; length : integer) : integer; cdecl;
function uart_BinRecv(hPort : integer; buf : pbyte; length : integer) : integer; cdecl;
function uart_BinSendCmd(hPort : integer; cmd_buf : pbyte; cmd_length : integer; result_buf : pbyte; resul_len : integer) : integer; cdecl;
procedure uart_SetTimeOut(hPort : integer; msec : dword; ctoType : integer); cdecl;
procedure uart_EnableCheckSum(hPort : integer; bEnable : integer); cdecl;
procedure uart_SetTerminator(hPort : integer; term : PChar); cdecl;

//**PAC Local/Remote IO API
function  pac_RemoteIO(iAddress : integer) : integer;
function  pac_WriteDO(hPort : integer; iSlot : integer; iDO_TotalCh : integer; lDO_Value: dword) : integer;  cdecl;
function  pac_WriteDOBit(hPort : integer; slot : integer; do_totalch : integer; ichannel : integer; bitvalue : integer) : integer;  cdecl;
function  pac_ReadDO(hPort : integer; slot:integer; do_totalch:integer; dovalue:pdword): dword; cdecl;
function  pac_ReadDI(hPort : integer; slot:integer; di_totalch:integer;divalue:pdword): integer; cdecl;
function  pac_ReadDILatch(hPort : integer; slot:integer; ditotalch:integer; latchtype:integer; latchvalue: pdword) : integer; cdecl;
function  pac_ClearDILatch(hPort : integer; slot:integer) : integer; cdecl;
function  pac_ReadDICNT(hPort : integer; slot:integer; ich:integer; ditotal:integer; countervalue: pdword): integer; cdecl;
function  pac_ClearDICNT(hPort : integer; slot: integer; ich:integer; ditotal:integer):integer; cdecl;
function  pac_ReadDIO(hport:integer; slot:integer; ditotal:integer; dototal:integer; divalue:pdword; dovalue:pdword):integer; cdecl;
function  pac_ReadDIOLatch(hPort : integer; slot:integer; ditotal: integer; dototal:integer; latchtype:integer; dilatchvalue:pdword; dolatchvalue: pdword) : integer; cdecl;
function  pac_ClearDIOLatch(hPort : integer; slot:integer): integer; cdecl;
function  pac_WriteAO(hPort : integer; s:integer; ich:integer; aototal:integer; fv: single):integer; cdecl;
function  pac_ReadAO(hPort : integer; s:integer; ich:integer; aototal:integer; fv: psingle):integer; cdecl;
function  pac_ReadAI(hPort : integer; s:integer; ich:integer; aitotal:integer; fv: psingle):integer; cdecl;
function  pac_ReadAIHex(hPort : integer; s:integer; ich:integer; aototal:integer; iv: pinteger):integer; cdecl;
function  pac_ReadAIAll(hPort : integer; s:integer; fvarr: psingle):integer; cdecl;
function  pac_ReadAIAllHex(hPort : integer; s:integer; ivarr: pinteger):integer; cdecl;
function  pac_ReadCNT(hPort : integer; s:integer; ich:integer; countervalue: pdword):integer; cdecl;
function  pac_ClearCNT(hPort : integer; s:integer; ich:integer):integer; cdecl;
function  pac_ReadCNTOverflow(hPort : integer; s:integer; ich:integer; overflow:pinteger):integer; cdecl;


function pac_ReadModuleSafeValueDO(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl;
function pac_WriteModuleSafeValueDO(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl;
function pac_ReadModuleSafeValueAO(hPort : integer; slot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl;
function pac_WriteModuleSafeValueAO(hPort : integer; slot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl;

function pac_ReadModulePowerOnValueDO(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl; //PowerON status is 0ff and ruturn the 0 of powerOn value even the powerON value isn't 0 saved on fram
function pac_WriteModulePowerOnValueDO(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl; //PowerOn value large 0 means the PowerOn value is enabled

function pac_ReadModulePowerOnValueAO(hPort : integer; slot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl;
function pac_WriteModulePowerOnValueAO(hPort : integer; slot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl;

function pac_WriteDO_MF(hPort : integer; iAddressSlot : integer; iDO_TotalCh : integer; lDO_Value : dword):integer; cdecl;
function pac_ReadDIO_MF(hPort : integer; iAddressSlot : integer; iDI_TotalCh : integer; iDO_TotalCh : integer; lDI_Value : dword; lDO_Value : dword):integer; cdecl;
function pac_ReadDI_MF(hPort : integer; iAddressSlot : integer; iDI_TotalCh : integer; lDI_Value : dword):integer; cdecl;
function pac_ReadDO_MF(hPort : integer; iAddressSlot : integer; iDO_TotalCh : integer; lDO_Value : dword):integer; cdecl;

function pac_ReadDICNT_MF(hPort : integer; iAddressSlot : integer; iChannel : integer; iDI_TotalCh : integer; lCounter_Value : dword):integer; cdecl;
function pac_ClearDICNT_MF(hPort : integer; iAddressSlot : integer; iChannel : integer; iDI_TotalCh : integer):integer; cdecl;

function pac_ReadModulePowerOnValueDO_MF(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl;
function pac_WriteModulePowerOnValueDO_MF(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl;

function pac_ReadModuleSafeValueDO_MF(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl;
function pac_WriteModuleSafeValueDO_MF(hPort : integer; slot : integer; iDO_TotalCh : integer; lData : dword):integer; cdecl;

function pac_WriteAO_MF(hPort : integer; iAddressSlot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl;
function pac_WriteModulePowerOnValueAO_MF(hPort : integer; iAddressSlot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl;
function pac_WriteModuleSafeValueAO_MF(hPort : integer; iAddressSlot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl;

function pac_ReadAIAllExt(hPort : integer; slot : integer; fValue : single; Buff_Len : integer; Channel : integer):integer; cdecl;
function pac_ReadAIAllHexExt(hPort : integer; slot : integer; iValue : dword; Buff_Len : integer; Channel : integer):integer; cdecl;





//** Error Handling API 
function pac_GetLastError() : dword; cdecl;
procedure pac_SetLastError(error_no : dword); cdecl;
procedure pac_ClearLastError(); cdecl;
procedure pac_GetErrorMessage(messageID : dword; buf : PChar); cdecl;
implementation


function  _pac_inp(addr : integer) : byte;  cdecl external 'PACSDK.dll';
procedure _pac_outp(addr: integer; data : integer); cdecl external 'PACSDK.dll';
 

function  _pac_slot_inp(slot : integer; addr: integer) : byte; cdecl external 'PACSDK.dll';
procedure _pac_slot_outp(slot : integer; addr: integer; data : integer); cdecl external 'PACSDK.dll';

procedure pac_ChangeSlot(slotNo : integer); cdecl external 'PACSDK.dll';
function pac_GetModuleName(slot : integer; strName : PChar) : integer; cdecl external 'PACSDK.dll';
 
//** System Functions: 

function pac_GetModuleType(slot : Byte) : integer; cdecl; external 'PACSDK.dll';
function pac_GetRotaryID() : integer; cdecl; external 'PACSDK.dll';
procedure pac_GetSerialNumber(serialnum : pchar); cdecl; external 'PACSDK.dll';
procedure pac_GetSDKVersion(sdkver : PChar); cdecl; external 'PACSDK.dll';

//** Backplane API (15 api not yet included)
function pac_GetDIPSwitch() : integer; cdecl; external 'PACSDK.dll';
function pac_GetSlotCount() : Word; cdecl; external 'PACSDK.dll';
procedure pac_GetBackplaneID(backplaneVersion : PChar); cdecl; external 'PACSDK.dll';

//** Memory API
function pac_GetMemorySize(mem_type : integer) : dword; cdecl; external 'PACSDK.dll';
function pac_ReadMemory(addr : dword; buf : pbyte; len : dword; mem_type : integer) : integer; cdecl; external 'PACSDK.dll';
function pac_WriteMemory(addr : dword; buf : pbyte; len : dword; mem_type : integer) : integer; cdecl; external 'PACSDK.dll';
procedure pac_EnableEEPROM(bEnable : integer); cdecl; external 'PACSDK.dll';

//** Watch Dog Timer Functions (under constructions)
function pac_EnableWatchDog(wdt : integer; value : dword) : integer; cdecl; external 'PACSDK.dll';
procedure pac_DisableWatchDog(wdt : integer); cdecl; external 'PACSDK.dll';
procedure pac_RefreshWatchDog(wdt : integer); cdecl; external 'PACSDK.dll';
function pac_GetWatchDogState(wdt : integer) : integer; cdecl; external 'PACSDK.dll';
function pac_GetWatchDogTime(wdt : integer) : dword; cdecl; external 'PACSDK.dll';
function pac_SetWatchDogTime(wdt : integer; value : dword) : integer; cdecl; external 'PACSDK.dll';

//** UART API
function uart_Open(ConnectionString : PChar) : integer; cdecl external 'PACSDK.dll';
function uart_Close(hPort : integer) : integer; cdecl external 'PACSDK.dll';
function uart_SendCmd(hPort : integer; cmd : PChar; szResult : PChar) : integer; cdecl external 'PACSDK.dll';
function uart_Write(hPort : integer; buf : PChar) : integer; cdecl; external 'PACSDK.dll';
function uart_Read(hPort : integer; buf : PChar) : integer; cdecl; external 'PACSDK.dll';
function uart_Send(hPort : integer; buf : PChar) : integer; cdecl; external 'PACSDK.dll';
function uart_Recv(hPort : integer; buf : PChar) : integer; cdecl; external 'PACSDK.dll';
procedure uart_SetTimeOut(hPort : integer; msec : dword; ctoType : integer); cdecl; external 'PACSDK.dll';
procedure uart_EnableCheckSum(hPort : integer; bEnable : integer); cdecl; external 'PACSDK.dll';
procedure uart_SetTerminator(hPort : integer; term : PChar); cdecl; external 'PACSDK.dll';

//** Error Handling API (no need to write demos)
function pac_GetLastError() : dword; cdecl; external 'PACSDK.dll';
procedure pac_SetLastError(error_no : dword); cdecl; external 'PACSDK.dll';
procedure pac_ClearLastError(); cdecl; external 'PACSDK.dll';
procedure pac_GetErrorMessage(messageID : dword; buf : PChar); cdecl; external 'PACSDK.dll';


//** PAC Local/Remote IO API
function pac_RemoteIO(iAddress : integer) : integer;
begin
	result := iAddress + $1000;
end;

function pac_WriteDO(hPort : integer; iSlot : integer; iDO_TotalCh : integer; lDO_Value: dword) : integer;  cdecl external 'PACSDK.dll';
function pac_WriteDOBit(hPort : integer; slot : integer; do_totalch : integer; ichannel : integer; bitvalue : integer) : integer;  cdecl external 'PACSDK.dll';
function pac_ReadDO(hPort:integer; slot:integer; do_totalch:integer; dovalue:pdword): dword; cdecl external 'PACSDK.dll';
function pac_ReadDI(hPort:integer; slot:integer; di_totalch:integer;divalue:pdword): integer; cdecl external 'PACSDK.dll' name 'pac_ReadDI';
function pac_ReadDILatch(hPort : integer; slot:integer; ditotalch:integer; latchtype:integer; latchvalue: pdword) : integer; cdecl external 'PACSDK.dll';
function pac_ClearDILatch(hPort : integer; slot:integer) : integer; cdecl external 'PACSDK.dll';
function pac_ReadDICNT(hPort : integer; slot:integer; ich:integer; ditotal:integer; countervalue: pdword): integer; cdecl external 'PACSDK.dll';
function pac_ClearDICNT(hPort : integer; slot: integer; ich:integer; ditotal:integer):integer; cdecl external 'PACSDK.dll';
function pac_ReadDIO(hport:integer; slot:integer; ditotal:integer; dototal:integer; divalue:pdword; dovalue:pdword):integer; cdecl external 'PACSDK.dll';
function pac_ReadDIOLatch(hPort : integer; slot:integer; ditotal: integer; dototal:integer; latchtype:integer; dilatchvalue:pdword; dolatchvalue: pdword) : integer; cdecl external 'PACSDK.dll';
function pac_ClearDIOLatch(hPort : integer; slot:integer): integer; cdecl external 'PACSDK.dll';
function pac_WriteAO(hPort : integer; s:integer; ich:integer; aototal:integer; fv: single):integer; cdecl external 'PACSDK.dll';
function pac_ReadAO(hPort : integer; s:integer; ich:integer; aototal:integer; fv: psingle):integer; cdecl external 'PACSDK.dll';
function pac_ReadAI(hPort : integer; s:integer; ich:integer; aitotal:integer; fv: psingle):integer; cdecl external 'PACSDK.dll';
function pac_ReadAIHex(hPort : integer; s:integer; ich:integer; aototal:integer; iv: pinteger):integer; cdecl external 'PACSDK.dll';
function pac_ReadAIAll(hPort : integer; s:integer; fvarr: psingle):integer; cdecl external 'PACSDK.dll';
function pac_ReadAIAllHex(hPort : integer; s:integer; ivarr: pinteger):integer; cdecl external 'PACSDK.dll';
function pac_ReadCNT(hPort : integer; s:integer; ich:integer; countervalue: pdword):integer; cdecl external 'PACSDK.dll';
function pac_ClearCNT(hPort : integer; s:integer; ich:integer):integer; cdecl external 'PACSDK.dll';
function pac_ReadCNTOverflow(hPort : integer; s:integer; ich:integer; overflow:pinteger):integer; cdecl external 'PACSDK.dll';
function pac_ReadModuleSafeValueDO(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl external 'PACSDK.dll';
function pac_WriteModuleSafeValueDO(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl external 'PACSDK.dll';
function pac_ReadModuleSafeValueAO(hPort : integer; slot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl external 'PACSDK.dll';
function pac_WriteModuleSafeValueAO(hPort : integer; slot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl external 'PACSDK.dll';

function pac_ReadModulePowerOnValueDO(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl external 'PACSDK.dll'; 
function pac_WriteModulePowerOnValueDO(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl external 'PACSDK.dll';

function pac_ReadModulePowerOnValueAO(hPort : integer; slot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl external 'PACSDK.dll';
function pac_WriteModulePowerOnValueAO(hPort : integer; slot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl external 'PACSDK.dll';

function pac_WriteDO_MF(hPort : integer; iAddressSlot : integer; iDO_TotalCh : integer; lDO_Value : dword):integer; cdecl external 'PACSDK.dll';
function pac_ReadDIO_MF(hPort : integer; iAddressSlot : integer; iDI_TotalCh : integer; iDO_TotalCh : integer; lDI_Value : dword; lDO_Value : dword):integer; cdecl external 'PACSDK.dll';
function pac_ReadDI_MF(hPort : integer; iAddressSlot : integer; iDI_TotalCh : integer; lDI_Value : dword):integer; cdecl external 'PACSDK.dll';
function pac_ReadDO_MF(hPort : integer; iAddressSlot : integer; iDO_TotalCh : integer; lDO_Value : dword):integer; cdecl external 'PACSDK.dll';

function pac_ReadDICNT_MF(hPort : integer; iAddressSlot : integer; iChannel : integer; iDI_TotalCh : integer; lCounter_Value : dword):integer; cdecl external 'PACSDK.dll';
function pac_ClearDICNT_MF(hPort : integer; iAddressSlot : integer; iChannel : integer; iDI_TotalCh : integer):integer; cdecl external 'PACSDK.dll';

function pac_ReadModulePowerOnValueDO_MF(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl external 'PACSDK.dll';
function pac_WriteModulePowerOnValueDO_MF(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl external 'PACSDK.dll';

function pac_ReadModuleSafeValueDO_MF(hPort : integer; slot : integer; iDO_TotalCh : integer; lValue : dword):integer; cdecl external 'PACSDK.dll';
function pac_WriteModuleSafeValueDO_MF(hPort : integer; slot : integer; iDO_TotalCh : integer; lData : dword):integer; cdecl external 'PACSDK.dll';

function pac_WriteAO_MF(hPort : integer; iAddressSlot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl external 'PACSDK.dll';
function pac_WriteModulePowerOnValueAO_MF(hPort : integer; iAddressSlot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl external 'PACSDK.dll';
function pac_WriteModuleSafeValueAO_MF(hPort : integer; iAddressSlot : integer; iChannel : integer; iAO_TotalCh : integer; fValue : single):integer; cdecl external 'PACSDK.dll';

function pac_ReadAIAllExt(hPort : integer; slot : integer; fValue : single; Buff_Len : integer; Channel : integer):integer; cdecl external 'PACSDK.dll';
function pac_ReadAIAllHexExt(hPort : integer; slot : integer; iValue : dword; Buff_Len : integer; Channel : integer):integer; cdecl external 'PACSDK.dll';
end.
