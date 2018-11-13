unit Main_Futty;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ImgList, ToolWin, ComCtrls, StdCtrls, ExtCtrls, ActnList, Buttons, jpeg,
  StdActns, PlatformDefaultStyleActnCtrls, ActnMan, ActnCtrls, ActnMenus,
  ExtActns, System.Actions, Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    sb: TStatusBar;
    Panel1: TPanel;
    Timer1: TTimer;
    ActionMainMenuBar1: TActionMainMenuBar;
    BalloonHint1: TBalloonHint;
    Memo1: TMemo;
    ActionToolBar1: TActionToolBar;
    ActionManager1: TActionManager;
    FileOpen1: TFileOpen;
    FileSaveAs1: TFileSaveAs;
    FileExit1: TFileExit;
    Action5: TAction;
    Action6: TAction;
    Action12: TAction;
    Action13: TAction;
    browseOnlineHelp: TBrowseURL;
    actAbout: TAction;
    actAuto: TAction;
    btnTX: TBitBtn;
    btnRX: TButton;
    EditTX: TEdit;
    EditRX: TEdit;
    EditCMP: TEdit;
    btnCMP: TButton;
    cb1: TCheckBox;
    cbArrow: TCheckBox;
    EditDeviceName: TEdit;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FTQuitExecute(Sender: TObject);
    procedure Action12Execute(Sender: TObject);
    procedure sbDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure FormResize(Sender: TObject);
    procedure btnTXClick(Sender: TObject);
    procedure btnRXClick(Sender: TObject);
    procedure btnCMPClick(Sender: TObject);
    procedure Action6Execute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FileOpen1Accept(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
      DevicePresent: boolean;
      DeviceIndex : DWord;
//    procedure ee_CS(value: integer);
//    procedure ee_SCL(value: integer);
//    procedure ee_MOSI(value: integer);
//    function  ee_MISO: integer;

//    procedure spi_CS(value: integer);
//    procedure spi_SCL(value: integer);
//    procedure spi_MOSI(value: integer);
//    function  spi_MISO: integer;
//    function  spi_xfer(value: byte): byte;

    procedure LoadMCS(filename: string);

    procedure Status(msg: string);
    procedure update_actions;
    procedure set_percent(last, value: integer);

    function Open_FTDI: boolean;

    procedure readuart;

  public
    { Public declarations }
    TF: TFileStream;

  end;

var
  Form1: TForm1;

implementation

uses
  D2XXUnit // FTDI D2XX Library

//,  TF_FTDI
;


{$R *.DFM}

procedure TForm1.FileOpen1Accept(Sender: TObject);
begin
  memo1.Lines.LoadFromFile(FileOpen1.Dialog.FileName);
  if memo1.Lines.Count>1 then
  begin
    editTX.Text := Memo1.Lines[0];
    editCMP.Text := Memo1.Lines[1];
  end;
  if memo1.Lines.Count>2 then
  begin
    editDeviceName.Text := Memo1.Lines[2];
  end;
  memo1.Lines.Clear;

end;

procedure TForm1.FormResize(Sender: TObject);
begin
   //sb.Panels[1].Width := width - 130;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  S : AnsiString;
  I : Integer;
  //LV : TListItem;
begin
  Timer1.Enabled := True;
  Memo1.Clear;
  FT_Enable_Error_Report := false; // Error reporting = on
  //FileSaveAs1.Dialog.InitialDir := ExtractFilePath(Application.ExeName);
  //OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName);

//  Open_FTDI;


end;

function TForm1.Open_FTDI: boolean;
var
  DeviceName,
  S : AnsiString;
  I : Integer;
  //LV : TListItem;
begin
//  speed := 3;
  DevicePresent := False;

  GetFTDeviceCount;
  S := IntToStr(FT_Device_Count);
//  Caption := 'FTerm - '+S+' Device(s) Present ...';
  DeviceIndex := 0;

//If (FT_Device_Count = 1) or (FT_Device_Count = 2) then
If (FT_Device_Count > 0) then
begin
  // Auto connect
  DeviceIndex := 0;

  For I := 0 to FT_Device_Count-1 do
  Begin
//    LV := ListView1.Items.Add;
//    LV.Caption := 'Device '+IntToStr(I);
//    GetFTDeviceSerialNo( 0 );
    //LV.SubItems.Add(FT_Device_String);
    if (GetFTDeviceDescription ( I ) = FT_OK) then
    begin
      memo1.lines.Add(inttostr(i) + ' ' + FT_Device_String);
    end;
  End;
  DeviceIndex := 3;
  GetFTDeviceDescription ( 1 );
  //Caption := FT_Device_String;
//  If Open_USB_Device_By_Serial_Number('00SIZYHG') = FT_OK then
//  If Open_USB_Device_By_Serial_Number(FT_Device_String) = FT_OK then
    //Caption := Selected_Device_Description;
//  DeviceIndex := 3;
//  GetFTDeviceDescription ( DeviceIndex );

//  If Open_USB_Device_By_Device_Description(FT_Device_String) = FT_OK then

  DeviceName := 'Digilent USB Device B';
  if EditDeviceName.Text <> '' then DeviceName := EditDeviceName.Text;

  //If Open_USB_Device_By_Device_Description('Arrow USB Blaster B') = FT_OK then

  if cbArrow.Checked then DeviceName := 'Embedded FlashPro5 C';

  If Open_USB_Device_By_Device_Description(DeviceName) = FT_OK then
  Begin
      sb.panels[1].text := 'Autoconnected to device: ' + DeviceName;

      FT_Enable_Error_Report := true;
      FT_Current_Baud := FT_BAUD_115200;
      Set_USB_Device_BaudRate;

      Reset_USB_Device;     // warning - this will destroy any pending data.
      Set_USB_Device_TimeOuts(50,50); // read and write timeouts = 500mS

//      Set_USB_Device_LatencyTimer(2);

      FT_Enable_Error_Report := true; // Error reporting = on

      DevicePresent := True;
  End else begin
      //Caption := 'Error can not connect..';
      sb.panels[1].text := 'Not connected..';
  end;
end;



end;

procedure TForm1.readuart;
Var
    PortStatus : FT_Result;
    bytes_read, i: integer;
begin
//FT_Enable_Error_Report := false; // Disable Error Reporting

//sbStatusBar1.Panels[0].Text := 'Waiting for Data ...';

PortStatus := Get_USB_Device_QueueStatus;

If PortStatus <> FT_OK then     // Device no longer present ...
  Begin
    //memo1.lines.Add('RX Device status: ' + inttostr(PortStatus));
    Exit;
  End;

//  memo1.lines.Add(inttostr(FT_Q_Bytes) );

//   bytes_read := Read_USB_Device_Buffer(FT_In_Buffer_Size);
   bytes_read := Read_USB_Device_Buffer(FT_Q_Bytes);

   sb.Panels[0].Text := 'Received ' + inttostr(bytes_read) + ' bytes';

   //EditRX.Text := '';
   for i:= 0 to bytes_read-1 do begin
      memo1.Lines.Text := memo1.Lines.Text + char(FT_In_Buffer[i]);
      //EditRX.Text := EditRX.Text + char(FT_In_Buffer[i]);

      //memo1.Lines.Add(inttohex(FT_In_Buffer[i]  ,2 ));
   end;


end;

procedure TForm1.sbDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
  const Rect: TRect);
begin
   //StatusBar.Canvas.Pen.Style := psClear;

   StatusBar.Canvas.Brush.Style := bsSolid;
   //StatusBar.Canvas.Brush.Color := sbColor;
   StatusBar.Canvas.Brush.Color := clRed;
   StatusBar.Canvas.Pen.Style := psSolid;
   StatusBar.Canvas.Pen.Color := StatusBar.Canvas.Brush.Color;

   StatusBar.Canvas.Rectangle(Rect.Left, Rect.Top, Rect.Right, rect.Bottom)
end;

procedure TForm1.set_percent(last, value: integer);
var
  p: integer;
begin
  sb.Panels[1].Text := 'Done ' + inttostr((value * 100) div (last)) + ' %';
end;

procedure TForm1.Status(msg: string);
begin
  sb.Panels[0].Text := msg;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
Var PortStatus : FT_Result;  S : AnsiString; DeviceIndex : DWord;  I : Integer;
begin

if DevicePresent then
begin
  PortStatus := Get_USB_Device_QueueStatus;
  If PortStatus = FT_OK then
    Begin   // Device has been Unplugged
     //if cb1.Checked then btnCMP.OnClick(self);
      readuart;
    end;

end;

Exit; //debug

FT_Enable_Error_Report := False; // Turn off error dialog
If Not DevicePresent then
  Begin
  //pnlSTAT.Color := clYellow;
  //pnlSTAT.Caption := 'unknown';
  PortStatus := Close_USB_Device; // In case device was already open
//  PortStatus := Open_USB_Device;  // Try and open device
  PortStatus := Open_USB_Device_By_Device_Description('Arrow USB Blaster B');

  If PortStatus = FT_OK then      // Device is Now Present !
    Begin
    DevicePresent := True;
    Caption := 'FTerm - UART Connected ...';

      FT_Current_Baud := FT_BAUD_115200;
      Set_USB_Device_BaudRate;
      Set_USB_Device_LatencyTimer(2);


//    Memo1.Enabled := True;
//    FTPort_Configure.Enabled := True;
//    FTSendFile.Enabled := True;
//    FTReceiveFile.Enabled := True;
    sleep(500);
    Reset_USB_Device;     // warning - this will destroy any pending data.
    Set_USB_Device_TimeOuts(50,50); // read and write timeouts = 500mS
    memo1.Lines.Add('Device attached..');

    //btnCMP.OnClick(self);

    End;
  End
else
  Begin
  PortStatus := Get_USB_Device_QueueStatus;
  If PortStatus <> FT_OK then
    Begin   // Device has been Unplugged
    DevicePresent := False;
    Caption := 'FTerm - UART DISCONNECTED ...';
//    Memo1.Enabled := False;
    //pnlSTAT.Color := clYellow;
    //pnlSTAT.Caption := 'unknown';
//    FTSendFile.Enabled := False;
//    FTReceiveFile.Enabled := False;
//    FTPort_Configure.Enabled := False;
    End else begin
     memo1.Lines.Add('.');
     //if cb1.Checked then btnCMP.OnClick(self);


      readuart;

    end;


  End;

end;

procedure TForm1.update_actions;
begin
end;

procedure TForm1.FTQuitExecute(Sender: TObject);
begin
If DevicePresent then Close_USB_Device;
Close;
end;

procedure TForm1.LoadMCS(filename: string);
begin
end;

procedure TForm1.btnTXClick(Sender: TObject);
var
  i, j, k: integer;
  len,
  retval: integer;
  s: string;
begin
    /////////////////////////////////
    ///  snipped to send a byte

    // Buffer to send to UART

    s := EditTX.Text;
    len := length(EditTX.Text);

    for i := 1 to len do
      begin
        FT_Out_Buffer[i-1] := ord(s[i]);
      end;

    // Function to send
    retval := Write_USB_Device_Buffer(
      len // 4 byte only to transmit
    );

    if FT_IO_Status <> FT_OK then
    begin
        Memo1.Lines.Add('TX Device Status: '+ inttostr(FT_IO_Status));
    end else begin
      // check how many bytes transmitted
      if retval <> len then begin
        Memo1.Lines.Add('Tried: '+ inttostr(len) +' Actual Bytes ' + inttostr(retval));
      end;
    end;

    ////////////////////////////////


//    Get_USB_Device_Status();
//    Memo1.Lines.Add('Bytes ' + inttostr(FT_Q_Bytes) + ' ' +  inttostr(FT_TxQ_Bytes));


end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 editRX.Text := '';
 //pnlSTAT.Color := clYellow;
 //pnlSTAT.Caption := 'unknown';

 memo1.Lines.Clear;
 Application.ProcessMessages;

 Open_FTDI;

 btnCMP.OnClick(self);

 Close_USB_Device;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Open_FTDI;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 Close_USB_Device;
end;

procedure TForm1.Action5Execute(Sender: TObject);
begin
// pnlSTAT.Color := clYellow;
// pnlSTAT.Caption := 'unknown';
 Application.ProcessMessages;

 Open_FTDI;
end;

procedure TForm1.Action6Execute(Sender: TObject);
begin
  // Close
  Close_USB_Device;

end;

procedure TForm1.btnRXClick(Sender: TObject);
Var
    PortStatus : FT_Result;
    bytes_read, i: integer;
begin
//FT_Enable_Error_Report := false; // Disable Error Reporting

//sbStatusBar1.Panels[0].Text := 'Waiting for Data ...';

PortStatus := Get_USB_Device_QueueStatus;

If PortStatus <> FT_OK then     // Device no longer present ...
  Begin
    memo1.lines.Add('RX Device status: ' + inttostr(PortStatus));
    Exit;
  End;

//  memo1.lines.Add(inttostr(FT_Q_Bytes) );

//   bytes_read := Read_USB_Device_Buffer(FT_In_Buffer_Size);
   bytes_read := Read_USB_Device_Buffer(FT_Q_Bytes);

   sb.Panels[0].Text := 'Received ' + inttostr(bytes_read) + ' bytes';

   EditRX.Text := '';
   for i:= 0 to bytes_read-1 do begin
      //memo1.Lines.Text := memo1.Lines.Text + char(FT_In_Buffer[i]);
      EditRX.Text := EditRX.Text + char(FT_In_Buffer[i]);
      //memo1.Lines.Add(inttohex(FT_In_Buffer[i]  ,2 ));
   end;

end;

procedure TForm1.btnCMPClick(Sender: TObject);
begin
  //
  btnTX.OnClick(self);
  sleep(50);
  btnRX.OnClick(self);

  if EditRX.Text=EditCMP.Text then
  begin
    //pnlSTAT.Color := clGreen;
    //pnlSTAT.Caption := 'OKAY';
  end else begin
    //pnlSTAT.Color := clRed;
    //pnlSTAT.Caption := 'FAILED';
  end;



end;

procedure TForm1.Action12Execute(Sender: TObject);
begin
  Cycle_USB_Port;
end;

end.
