unit I8000;

interface

type PSingle=^Single;
type PWord=^Word;
type PDWord=^LongInt;


// Digital Input/Output
function DigitalOut_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function DigitalIn_8K( dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function DigitalOutReadBack_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function DigitalBitOut_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;

// Analog Input/Output
function AnalogIn_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function AnalogInAll_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;

function AnalogInFsr_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function AnalogInHex_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;

function AnalogOut_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function AnalogOutReadBack_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;

// Alarm
function SetAlarmConnect_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function SetAlarmLimitValue_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function ReadAlarmLimitValue_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function ClearLatchAlarm_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function ReadAlarmMode_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function SetAlarmMode_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function ReadAlarmStatus_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;

// configuration
function ReadConfigurationStatus_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function SetConfigurationStatus_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function SetStartUpValue_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function ReadStartUpValue_8K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;


// **********************************************************
// **********************************************************
implementation


// Digital Input/Output
function DigitalOut_8K;                 external 'I7000.DLL' name 'DigitalOut_8K';
function DigitalIn_8K;                  external 'I7000.DLL' name 'DigitalIn_8K';
function DigitalOutReadBack_8K;         external 'I7000.DLL' name 'DigitalOutReadBack_8K';
function DigitalBitOut_8K;              external 'I7000.DLL' name 'DigitalBitOut_8K';

// Analog Input/Output
function AnalogIn_8K;                   external 'I7000.DLL' name 'AnalogIn_8K';
function AnalogInAll_8K;                external 'I7000.DLL' name 'AnalogInAll_8K';
function AnalogOut_8K;                  external 'I7000.DLL' name 'AnalogOut_8K';
function AnalogOutReadBack_8K;          external 'I7000.DLL' name 'AnalogOutReadBack_8K';
function AnalogInFsr_8K;                external 'I7000.DLL' name 'AnalogInFsr_8K';
function AnalogInHex_8K;                external 'I7000.DLL' name 'AnalogInHex_8K';

// Alarm
function SetAlarmConnect_8K;            external 'I7000.DLL' name 'SetAlarmConnect_8K';
function SetAlarmLimitValue_8K;         external 'I7000.DLL' name 'SetAlarmLimitValue_8K';
function ReadAlarmLimitValue_8K;        external 'I7000.DLL' name 'ReadAlarmLimitValue_8K';
function ClearLatchAlarm_8K;            external 'I7000.DLL' name 'ClearLatchAlarm_8K';
function ReadAlarmMode_8K;              external 'I7000.DLL' name 'ReadAlarmMode_8K';
function SetAlarmMode_8K;               external 'I7000.DLL' name 'SetAlarmMode_8K';
function ReadAlarmStatus_8K;            external 'I7000.DLL' name 'ReadAlarmStatus_8K';

// Configuration
function ReadConfigurationStatus_8K;    external 'I7000.DLL' name 'ReadConfigurationStatus_8K';
function SetConfigurationStatus_8K;     external 'I7000.DLL' name 'ReadConfigurationStatus_8K';
function SetStartUpValue_8K;            external 'I7000.DLL' name 'SetStartUpValue_8K';
function ReadStartUpValue_8K;           external 'I7000.DLL' name 'ReadStartUpValue_8K';

end.

