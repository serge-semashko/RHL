unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    ComComboBox: TComboBox;
    Label4: TLabel;
    BaudRateComboBox: TComboBox;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label5: TLabel;
    Address: TEdit;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Label2: TLabel;
    edCh: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure OpenCom;
    procedure ComComboBoxChange(Sender: TObject);
    procedure BaudRateComboBoxChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  iRet, iStatus : Integer;
  iCount        : Integer;
  wRet          : Word ;

implementation

Uses I7000,I7000u,dcon_pc;

Var
   bCfgChg , bComOpen : Boolean ;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
     
     ComComboBox.ItemIndex      := 0 ;
     BaudRateComboBox.ItemIndex := 4 ;

     gcDataBit  := Char(8);      // 8 data bit
     gcParity   := Char(0);      // Non Parity
     gcStopBit  := Char(0);      // One Stop Bit
     bCOMOpen   := False;
     bCfgChg    := False;
     gszSend    := StrAlloc( 100 );
     gszReceive := StrAlloc( 100 );
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     if bComOpen then
        Close_Com( gcPort );
     Close;
end;

Procedure TForm1.OpenCom;
Var
   iRet , iConfirm : Integer ;

Begin
     gcPort := Char(ComComboBox.ItemIndex + 1 );      // Setting Com Port
     gdwBaudRate := StrToInt( BaudRateComboBox.Text );

    iRet := Open_Com(gcPort, gdwBaudRate, gcDataBit, gcParity, gcStopBit);
    If iRet > 0 Then
    Begin
        Beep;
        iConfirm := MessageDlg('OPEN_COM Error Code:' + IntToStr(iRet) + #13 + IGetErrorString(iRet) + #13 + 'Quit this demo?'
                               , mtConfirmation , [mbYes,mbNo] , 0 );
        If iConfirm = mrYes Then
           Close;
    End;

    bComOpen := True;
    bCfgChg  := False;
end;

procedure TForm1.ComComboBoxChange(Sender: TObject);
begin
     bCfgChg := True;
end;

procedure TForm1.BaudRateComboBoxChange(Sender: TObject);
begin
     bCfgChg := True;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
    cntVal:DWord;
begin

    wRet := DCON_Read_Counter(gcPort , StrToInt('$' + Address.Text) , -1 ,StrToInt('$' + edCh.Text),  0, 200, @cntVal);


    If wRet <> 0 Then
    Begin
        Beep;
       
        Close_Com (gcPort);
        Exit;
    end;
    //for digital in
    Edit1.Text := IntToHex( cntVal , 0 );
    
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     StrDispose(gszSend);
     StrDispose(gszReceive);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     gcPort := Char(ComComboBox.ItemIndex + 1 );
     if bCfgChg and bComOpen then  // Reopen Com port
     begin
        Close_Com(gcPort);
        bComOpen := False;
     end;
      if Not bComOpen then
        OpenCom;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
    Close_Com(gcPort);
    bComOpen := False;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
    wRet :=    DCON_Clear_Counter(gcPort, StrToInt('$' + Address.Text) , -1 , StrToInt('$' + edCh.Text),  0, 200);
   
end;

end.
