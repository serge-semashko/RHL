unit I87000;

interface

type PSingle=^Single;
type PWord=^Word;
type PDWord=^LongInt;


// Digital Input/Output
function DigitalOut_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function DigitalBitOut_87K( dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function DigitalOutReadBack_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function DigitalIn_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function DigitalInLatch_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function ClearDigitalInLatch_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;

// Counter
function DigitalInCounterRead_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function ClearDigitalInCounter_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;

// Analog Input/Output
function AnalogOut_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function AnalogOutReadBack_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function AnalogIn_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function AnalogInAll_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function AnalogInFsr_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function AnalogInHex_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;


// configuration
function ReadConfigurationStatus_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function SetConfigurationStatus_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;

//set power on or asfe or startup value 
function ReadStartUpValue_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;
function SetStartUpValue_87K(dwBuf:PDWord; fBuf:PSingle; szSend:PChar; szReceive:PChar): Word; StdCall;




// **********************************************************
// **********************************************************
implementation


// Digital Input/Output
function DigitalOut_87K;                external 'I7000.DLL' name 'DigitalOut_87K';
function DigitalBitOut_87K;             external 'I7000.DLL' name 'DigitalBitOut_87K';
function DigitalOutReadBack_87K;        external 'I7000.DLL' name 'DigitalOutReadBack_87K';
function DigitalIn_87K;                 external 'I7000.DLL' name 'DigitalIn_87K';
function DigitalInLatch_87K;            external 'I7000.DLL' name 'DigitalInLatch_87K';
function ClearDigitalInLatch_87K;       external 'I7000.DLL' name 'ClearDigitalInLatch_87K';
function AnalogIn_87K;                  external 'I7000.DLL' name 'AnalogIn_87K';
function AnalogInAll_87K;               external 'I7000.DLL' name 'AnalogInAll_87K';

// Counter
function DigitalInCounterRead_87K;      external 'I7000.DLL' name 'DigitalInCounterRead_87K';
function ClearDigitalInCounter_87K;     external 'I7000.DLL' name 'ClearDigitalInCounter_87K';

// Analog Input/Output
function AnalogOut_87K;                 external 'I7000.DLL' name 'AnalogOut_87K';
function AnalogOutReadBack_87K;         external 'I7000.DLL' name 'AnalogOutReadBack_87K';
function AnalogInFsr_87K;               external 'I7000.DLL' name 'AnalogInFsr_87K';
function AnalogInHex_87K;               external 'I7000.DLL' name 'AnalogInHex_87K';

// configuration
function ReadConfigurationStatus_87K;   external 'I7000.DLL' name 'ReadConfigurationStatus_87K';
function SetConfigurationStatus_87K;    external 'I7000.DLL' name 'SetConfigurationStatus_87K';

//set power on or asfe or startup value 
function ReadStartUpValue_87K;          external 'I7000.DLL' name 'ReadStartUpValue_87K';
function SetStartUpValue_87K;           external 'I7000.DLL' name 'SetStartUpValue_87K';

end.

