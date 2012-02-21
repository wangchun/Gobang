{**********************************************************}
{                                                          }
{        五子棋    版本 5.0    王纯    1998年8月6日        }
{                                                          }
{     Gobang   Version 5.0   Wang Chun   August 6 1998     }
{                                                          }
{**********************************************************}

{图形模块}

{关闭运行时间输入输出检查}
{$I-}
Unit Graphics;

Interface

Uses
	Crt, Dos, Graph, XMS;

Type
	InputMethodDataType = Record
		Code: String[6];
		Character: String
	End;
	ListStr = String[32];
	PicListStr = String[16];

Var
	CurInputMethod: Integer;
	IsChineseInput, CurInputState, IsQuotation1, IsQuotation2: Boolean;
	LastChineseKey: Char;
	ChineseFontHandle, EnglishFontHandle, ChineseInputHandle, InputMethodHandle: Word;
	InputMethodCode: Array[1..417] Of String[6];

{关闭图形模块}
Procedure GraphicsDone;
{致命错误处理}
Procedure FatalError(Message: String);
{调色板转换}
Function PaletteColor(Color: Byte): Byte;
{返回图片文件的图片数}
Function GetPictureFrame(Handle: Word): Integer;
{返回指定图片的偏移量}
Function GetPictureOffset(Handle, Number: Word): Longint;
{返回图片宽度}
Function GetPictureWidth(Handle, Number: Word): Word;
{返回图片高度}
Function GetPictureHeight(Handle, Number: Word): Word;
{从磁盘读入图片到扩充内存}
Function LoadPicture(FileName: String): Word;
{将图片的指定行复制到另一图片}
Function CopyPicture(SourceHandle, Number, StartRow, EndRow: Word): Word;
{保存屏幕上指定矩形区域上的显示内容到扩充内存}
Function SavePicture(Left, Top, Right, Bottom: Integer): Word;
{显示指定图片}
Procedure DisplayPicture(Handle, Number: Word; Left, Top: Integer; BitBlt: Word);
{删除扩充内存中的图片}
Function DeletePicture(Handle: Word): Boolean;
{返回指定窗口的索引号}
Function GetWindowIndex(Handle: Word): Integer;
{重画指定窗口}
Procedure DrawWindow(Index, Left, Right: Integer);
{建立窗口}
Function CreateWindow(Caption: String; BorderStyle, BackColor, Left, Top, Width, Height: Integer; IsCaption, IsSize: Boolean):
	Word;
{删除窗口}
Function DestroyWindow(Handle: Word): Boolean;
{返回窗口左边界}
Function GetWindowLeft(Handle: Word): Integer;
{返回窗口上边界}
Function GetWindowTop(Handle: Word): Integer;
{返回窗口宽度}
Function GetWindowWidth(Handle: Word): Integer;
{返回窗口高度}
Function GetWindowHeight(Handle: Word): Integer;
{返回窗口客户区左边界}
Function GetWindowClientLeft(Handle: Word): Integer;
{返回窗口客户区上边界}
Function GetWindowClientTop(Handle: Word): Integer;
{返回窗口客户区宽度}
Function GetWindowClientWidth(Handle: Word): Integer;
{返回窗口客户区高度}
Function GetWindowClientHeight(Handle: Word): Integer;
{清除键盘缓冲区}
Procedure ClearKeyboardBuffer;
{返指定汉字字符串前面指定数目个字符}
Function GetChinese(ChineseString: String; Count: Integer): String;
{显示汉字}
Procedure WriteChinese(Character: String; X, Y, ForeColor, BackColor, Interval: Integer);
{在指定区域内显示汉字}
Procedure WriteText(Character: String; Top, Left, Right, ForeColor, BackColor: Integer);
{显示中文输入提示行}
Procedure ShowChineseInputLine;
{隐藏中文输入提示行}
Procedure HideChineseInputLine;
{设置状态行}
Procedure SetStatusLine(Prompt: String);
{显示信息框}
Function MessageBox(Prompt, Caption: String; BorderStyle, Left, Top, Width, Height: Integer; IsButton, IsCaption, IsSize:
	Boolean): Boolean;
{显示输入框}
Function InputBox(Prompt, Caption, Default: String; BorderStyle, Left, Top, Width, Height, MaxLen: Integer;	CanCancel,
	IsCaption, IsSize: Boolean): String;
{在指定窗口执行列表框操作}
Function ListBox(Handle, Count, Default: Word; Var Caption: Array Of ListStr; Var Enabled: Array Of Boolean; CanCancel: Boolean
	): Word;
{在指定窗口执行图形列表框操作}
Function PictureListBox(Handle, Count, Default, PicHandle: Word; Var Number: Array Of Integer; Var Caption: Array Of PicListStr
	; IsCaption, CanCancel: Boolean): Word;

Implementation

Type
	WindowType = Record
		Handle: Word;
		Caption: String[32];
		BorderStyle, BackColor, Left, Top, Width, Height, ClientLeft, ClientTop, ClientWidth, ClientHeight: Integer;
		IsCaption, IsSize: Boolean;
	End;

Var
	Window: Array[1..32] Of WindowType;

Procedure GraphicsDone;
Var
	I: Integer;
Begin
	HideChineseInputLine;
	For I := 32 DownTo 1 Do If Window[I].Handle <> 0 Then DestroyWindow(Window[I].Handle);
	FreeXMS(InputMethodHandle);
	FreeXMS(ChineseFontHandle);
	FreeXMS(EnglishFontHandle)
End;

Procedure FatalError(Message: String);
Begin
	GraphicsDone;
    FreeAllXMS;
    CloseGraph;
    Writeln(Message);
    Halt
End;

Function PaletteColor(Color: Byte): Byte;
Begin
	If Color < 8 Then PaletteColor := Color Else PaletteColor := Color + 48;
	If Color = 6 Then PaletteColor := 20;
End;

Function GetPictureFrame(Handle: Word): Integer;
Var
	I: Word;
	Offset: Longint;
    Buffer: Pointer;
Begin
	Offset := 0;
    GetMem(Buffer, 4);
    If Buffer = Nil Then FatalError('Out Of Memory!');
    I := 0;
    Repeat
        I := I + 1;
        ReadFromXMS(Handle, Offset, Buffer^, 4);
        Offset := Offset + ImageSize(0, 0, MemW[Seg(Buffer^):Ofs(Buffer^)], MemW[Seg(Buffer^):Ofs(Buffer^) + 2]);
		If MemW[Seg(Buffer^):Ofs(Buffer^)] = 0 Then Break;
	Until False;
    FreeMem(Buffer, 4);
	GetPictureFrame := I - 1
End;

Function GetPictureOffset(Handle, Number: Word): Longint;
Var
	I: Word;
	Offset: Longint;
    Buffer: Pointer;
Begin
	Offset := 0;
    GetMem(Buffer, 4);
    If Buffer = Nil Then FatalError('Out Of Memory!');
	For I := 1 To Number Do
    Begin
		ReadFromXMS(Handle, Offset, Buffer^, 4);
        Offset := Offset + ImageSize(0, 0, MemW[Seg(Buffer^):Ofs(Buffer^)], MemW[Seg(Buffer^):Ofs(Buffer^) + 2])
    End;
    FreeMem(Buffer, 4);
	GetPictureOffset := Offset
End;

Function GetPictureWidth(Handle, Number: Word): Word;
Var
	Result: Word;
Begin
	ReadFromXMS(Handle, GetPictureOffset(Handle, Number), Result, 2);
	GetPictureWidth := Result + 1
End;

Function GetPictureHeight(Handle, Number: Word): Word;
Var
	Result: Word;
Begin
	ReadFromXMS(Handle, GetPictureOffset(Handle, Number) + 2, Result, 2);
    GetPictureHeight := Result + 1
End;

Function LoadPicture(FileName: String): Word;
Var
	I, Handle, Result, Size: Word;
	PictureFile: File;
	Buffer: Pointer;
Begin
	Assign(PictureFile, FileName);
    Reset(PictureFile);
	If IOResult <> 0 Then FatalError('Error Open File ' + FileName + '!');
	Size := (FileSize(PictureFile) + 1) Div 8 + 1;
    Handle := AllocXMS(Size);
    GetMem(Buffer, 1024);
    If Buffer = Nil Then FatalError('Out Of Memory!');
    For I := 1 To Size Do
	Begin
        FillChar(Buffer^, 1024, 0);
		BlockRead(PictureFile, Buffer^, 8, Result);
        If IOResult <> 0 Then
	    Begin
    		Close(PictureFile);
			FatalError('Error Reading File ' + FileName + '!')
		End;
		WriteToXMS(Handle, Longint(I - 1) * 1024, Buffer^, 1024)
	End;
	FreeMem(Buffer, 1024);
	Close(PictureFile);
	LoadPicture := Handle
End;

Function CopyPicture(SourceHandle, Number, StartRow, EndRow: Word): Word;
Var
	DestHandle, Width, Height, ImageWidth, ImageHeight, LineSize, PictureSize: Word;
    Offset: Longint;
    Buffer: Pointer;
Begin
	Offset := GetPictureOffset(SourceHandle, Number);
	Width := GetPictureWidth(SourceHandle, Number);
    Height := GetPictureHeight(SourceHandle, Number);
	ImageWidth := Width - 1;
    ImageHeight := EndRow - StartRow;
    LineSize := (Width + 7) Div 8 * 4;
	PictureSize := ImageSize(0, 0, ImageWidth, ImageHeight);
    DestHandle := AllocXMS((PictureSize + 1) Div 1024 + 1);
	WriteToXMS(DestHandle, 0, ImageWidth, 2);
	WriteToXMS(DestHandle, 2, ImageHeight, 2);
	GetMem(Buffer, LineSize * (ImageHeight + 1) + 2);
	If Buffer = Nil Then FatalError('Out Of Memory!');
    FillChar(Buffer^, LineSize * (ImageHeight + 1) + 2, 0);
	ReadFromXMS(SourceHandle, Offset + StartRow * LineSize + 4, Buffer^, LineSize * (ImageHeight + 1));
	WriteToXMS(DestHandle, 4, Buffer^, LineSize * (ImageHeight + 1) + 2);
	FreeMem(Buffer, LineSize * (ImageHeight + 1) + 2);
	CopyPicture := DestHandle
End;

Function SavePicture(Left, Top, Right, Bottom: Integer): Word;
Var
	I, Handle, Size: Word;
    Buffer: Pointer;
Begin
	Size := ImageSize(Left, Top, Right, Bottom);
    Handle := AllocXMS((Size + 1) Div 1024 + 1);
	GetMem(Buffer, Size);
    If Buffer = Nil Then FatalError('Out Of Memory!');
	GetImage(Left, Top, Right, Bottom, Buffer^);
	WriteToXMS(Handle, 0, Buffer^, Size);
	I := 0;
	WriteToXMS(Handle, Size, I, 2);
	FreeMem(Buffer, Size);
	SavePicture := Handle
End;

Procedure DisplayPicture(Handle, Number: Word; Left, Top: Integer; BitBlt: Word);
Var
	I, Width, Height, Size: Word;
    Offset: Longint;
	Buffer: Pointer;
Begin
	Offset := GetPictureOffset(Handle, Number);
	Width := GetPictureWidth(Handle, Number);
   	Height := GetPictureHeight(Handle, Number);
	Size := ImageSize(0, 0, Width - 1, Height - 1);
	GetMem(Buffer, Size);
    If Buffer = Nil Then FatalError('Out Of Memory!');
	ReadFromXMS(Handle, Offset, Buffer^, Size);
	PutImage(Left, Top, Buffer^, BitBlt);
	FreeMem(Buffer, Size)
End;

Function DeletePicture(Handle: Word): Boolean;
Begin
	DeletePicture := FreeXMS(Handle)
End;

Function GetWindowIndex(Handle: Word): Integer;
Var
	I: Integer;
Begin
	GetWindowIndex := 0;
	For I := 1 To 32 Do If Window[I].Handle = Handle Then Break;
    If Window[I].Handle <> Handle Then Exit;
    GetWindowIndex := I
End;

Procedure DrawWindow(Index, Left, Right: Integer);
Var
	Top, Bottom, ClientLeft, ClientTop, ClientRight, ClientBottom: Integer;
Begin
	Top := Window[Index].Top;
	Bottom := Top + Window[Index].Height - 1;
	ClientLeft := Left;
	ClientTop := Window[Index].ClientTop;
	ClientRight := Right;
	ClientBottom := ClientTop + Window[Index].ClientHeight - 1;
	If Window[Index].BorderStyle <> 0 Then
	Begin
		ClientLeft := ClientLeft + 5;
		ClientRight := ClientRight - 5
	End;
	If Window[Index].BackColor >= 0 Then
	Begin
		SetFillStyle(SolidFill, Window[Index].BackColor);
		Bar(ClientLeft, ClientTop, ClientRight, ClientBottom)
	End;
	If Window[Index].IsCaption Then
	Begin
		SetFillStyle(SolidFill, 1);
		Bar(ClientLeft, ClientTop - 20, ClientRight, ClientTop - 1)
	End;
	Case Window[Index].BorderStyle Of
		1:
		Begin
			SetColor(5);
			Rectangle(Left, Top, Right, Bottom);
			If Window[Index].IsCaption Then SetColor(13);
			Rectangle(Left + 4, Top + 4, Right - 4, Bottom - 4);
			SetColor(13);
			Rectangle(Left + 1, Top + 1, Right - 1, Bottom - 1);
			Rectangle(Left + 2, Top + 2, Right - 2, Bottom - 2);
			Rectangle(Left + 3, Top + 3, Right - 3, Bottom - 3);
		End;
		2:
		Begin
			SetColor(7);
			Rectangle(Left + 4, Top + 4, Right - 4, Bottom - 4);
			Rectangle(Left + 3, Top + 3, Right - 3, Bottom - 3);
			Rectangle(Left + 2, Top + 2, Right - 2, Bottom - 2);
			Rectangle(Left, Top, Right - 1, Top);
			Rectangle(Left, Top, Left, Bottom - 1);
			SetColor(0);
			Rectangle(Right, Top, Right, Bottom);
			Rectangle(Left, Bottom, Right, Bottom);
			SetColor(15);
			Rectangle(Left + 1, Top + 1, Right - 2, Top + 1);
			Rectangle(Left + 1, Top + 1, Left + 1, Bottom - 2);
			SetColor(8);
			Rectangle(Right - 1, Top + 1, Right - 1, Bottom - 1);
			Rectangle(Left + 1, Bottom - 1, Right - 1, Bottom - 1)
		End
	End
End;

Function CreateWindow(Caption: String; BorderStyle, BackColor, Left, Top, Width, Height: Integer; IsCaption, IsSize: Boolean):
	Word;
Var
	I, CurLeft, CurRight, Right, Bottom: Integer;
	CreateFlag: Boolean;
	Size, Handle: Word;
	Buffer: Pointer;
	WindowText: String;
Begin
	CreateWindow := 0;
	Handle := SavePicture(Left, Top, Left + Width - 1, Top + Height - 1);
	If Handle = 0 Then Exit;
	CreateFlag := False;
	For I := 1 To 32 Do
		If Window[I].Handle = 0 Then
		Begin
			CreateFlag := True;
			Window[I].Caption := Caption;
			Window[I].BorderStyle := BorderStyle;
			If BackColor In [0..15] Then Window[I].BackColor := BackColor;
			If BackColor = 16 Then
				Case BorderStyle Of
					0: Window[I].BackColor := -1;
					1: Window[I].BackColor := 15;
					2: Window[I].BackColor := 7
				End;
			Window[I].Handle := Handle;
			Window[I].Left := Left;
			Window[I].Top := Top;
			Window[I].Width := Width;
			Window[I].Height := Height;
			If BorderStyle = 0 Then
			Begin
				Window[I].ClientLeft := Left;
				If IsCaption Then Window[I].ClientTop := Top + 20 Else Window[I].ClientTop := Top;
				Window[I].ClientWidth := Width;
				If IsCaption Then Window[I].ClientHeight := Height - 20 Else Window[I].ClientHeight := Height
			End
			Else
			Begin
				Window[I].ClientLeft := Left + 5;
				If IsCaption Then Window[I].ClientTop := Top + 25 Else Window[I].ClientTop := Top + 5;
				Window[I].ClientWidth := Width - 10;
				If IsCaption Then Window[I].ClientHeight := Height - 30 Else Window[I].ClientHeight := Height - 10
			End;
			Window[I].IsCaption := IsCaption;
			Window[I].IsSize := IsSize;
			Break
		End;
	If Not CreateFlag Then Exit;
	Right := Left + Width - 1;
	If IsSize Then
	Begin
		CurLeft := (Left + Right) Div 2 - 10;
		CurRight := (Left + Right) Div 2 + 10;
		While (CurLeft > Left) And (CurRight < Right) Do
		Begin
			DrawWindow(I, CurLeft, CurRight);
			CurLeft := CurLeft - 10;
			CurRight := CurRight + 10;
			Delay(20)
		End
	End;
	DrawWindow(I, Left, Right);
	WindowText := Caption;
	If Length(WindowText) > (Window[I].ClientWidth - 4) Div 8 Then
		WindowText := GetChinese(WindowText, (Window[I].ClientWidth - 4) Div 8 - 3) + '...';
	If IsCaption And (Caption <> '') Then
		WriteChinese(WindowText, Window[I].ClientLeft + 2, Window[I].ClientTop - 18, 15, -1, 0);
	CreateWindow := Handle
End;

Function DestroyWindow(Handle: Word): Boolean;
Var
	I, Index, Left, Top, Height: Integer;
    TopHandle, BottomHandle, Size: Word;
    Buffer: Pointer;
Begin
	DestroyWindow := True;
    Index := GetWindowIndex(Handle);
	If Index = 0 Then
    Begin
		DestroyWindow := False;
		Exit
	End;
	Left := Window[Index].Left;
	Top := Window[Index].Top;
	Height := Window[Index].Height;
	If Window[Index].IsSize Then
    	For I := 0 To Window[Index].Height Div 20 Do
        Begin
        	TopHandle := CopyPicture(Handle, 0, I * 10, I * 10 + 9);
            BottomHandle := CopyPicture(Handle, 0, Height - I * 10 - 10, Height - I * 10 - 1);
			DisplayPicture(TopHandle, 0, Left, Top + I * 10, NormalPut);
            DisplayPicture(BottomHandle, 0, Left, Top + Height - I * 10 - 10, NormalPut);
            DeletePicture(TopHandle);
            DeletePicture(BottomHandle);
            Delay(20)
	    End;
    DisplayPicture(Handle, 0, Left, Top, NormalPut);
	DeletePicture(Handle);
    Window[Index].Handle := 0
End;

Function GetWindowBackColor(Handle: Word): Integer;
Var
	I: Integer;
Begin
	GetWindowBackColor := -1;
    I := GetWindowIndex(Handle);
	If I = 0 Then Exit;
    GetWindowBackColor := Window[I].BackColor
End;

Function GetWindowLeft(Handle: Word): Integer;
Var
	I: Integer;
Begin
	GetWindowLeft := -1;
    I := GetWindowIndex(Handle);
	If I = 0 Then Exit;
    GetWindowLeft := Window[I].Left
End;

Function GetWindowTop(Handle: Word): Integer;
Var
	I: Integer;
Begin
	GetWindowTop := -1;
    I := GetWindowIndex(Handle);
	If I = 0 Then Exit;
    GetWindowTop := Window[I].Top
End;

Function GetWindowWidth(Handle: Word): Integer;
Var
	I: Integer;
Begin
	GetWindowWidth := -1;
    I := GetWindowIndex(Handle);
	If I = 0 Then Exit;
    GetWindowWidth := Window[I].Width
End;

Function GetWindowHeight(Handle: Word): Integer;
Var
	I: Integer;
Begin
	GetWindowHeight := -1;
    I := GetWindowIndex(Handle);
	If I = 0 Then Exit;
    GetWindowHeight := Window[I].Height
End;

Function GetWindowClientLeft(Handle: Word): Integer;
Var
	I: Integer;
Begin
	GetWindowClientLeft := -1;
    I := GetWindowIndex(Handle);
	If I = 0 Then Exit;
    GetWindowClientLeft := Window[I].ClientLeft
End;

Function GetWindowClientTop(Handle: Word): Integer;
Var
	I: Integer;
Begin
	GetWindowClientTop := -1;
    I := GetWindowIndex(Handle);
	If I = 0 Then Exit;
    GetWindowClientTop := Window[I].ClientTop
End;

Function GetWindowClientWidth(Handle: Word): Integer;
Var
	I: Integer;
Begin
	GetWindowClientWidth := -1;
    I := GetWindowIndex(Handle);
	If I = 0 Then Exit;
    GetWindowClientWidth := Window[I].ClientWidth
End;

Function GetWindowClientHeight(Handle: Word): Integer;
Var
	I: Integer;
Begin
	GetWindowClientHeight := -1;
    I := GetWindowIndex(Handle);
	If I = 0 Then Exit;
    GetWindowClientHeight := Window[I].ClientHeight
End;

Procedure ClearKeyboardBuffer;
Var
	Regs: Registers;
Begin
	Regs.AX := $0C00;
    Intr($21, Regs)
End;

Function GetChinese(ChineseString: String; Count: Integer): String;
Var
	I: Integer;
	ChineseFlag: Boolean;
Begin
	If Count >= Length(ChineseString) Then
	Begin
		GetChinese := ChineseString
	End
	Else
	Begin
		ChineseFlag := False;
		For I := 1 To Count Do
			If ChineseFlag Then ChineseFlag := False Else ChineseFlag := (ChineseString[I] > #160) And (ChineseString[I] < #248);
		If ChineseFlag Then GetChinese := Copy(ChineseString, 1, Count - 1) Else GetChinese := Copy(ChineseString, 1, Count)
    End
End;

Procedure WriteChinese(Character: String; X, Y, ForeColor, BackColor, Interval: Integer);
Var
	I, J, K, IntervalSum: Integer;
    EnglishBuffer: Array[0..15] Of Byte;
	ChineseBuffer: Array[0..15] Of Word;
	AWord: String;
Begin
	If Length(Character) = 0 Then Exit;
	IntervalSum := 0;
	I := 1;
	Repeat
		AWord := Copy(Character, I, 2);
        If I = Length(Character) Then AWord := AWord + #0;
		If (AWord[1] > #160) And (AWord[1] < #248) And (AWord[2] > #160) And (AWord[2] < #255) And (I < Length(Character)) Then
		Begin
			ReadFromXMS(ChineseFontHandle, (Longint(Ord(AWord[1]) - 161) * 94 + Ord(AWord[2]) - 161) * 32, ChineseBuffer, 32);
			For J := 0 To 15 Do
            Begin
            	ChineseBuffer[J] := Swap(ChineseBuffer[J]);
                For K := 0 To 15 Do
                	If ChineseBuffer[J] Shr K And 1 = 1 Then
					Begin
						If ForeColor >= 0 Then PutPixel(X - K + I * 8 + IntervalSum + 7, Y + J, ForeColor)
                    End
					Else
					Begin
						If BackColor >= 0 Then PutPixel(X - K + I * 8 + IntervalSum + 7, Y + J, BackColor)
                    End
			End;
			I := I + 1
        End
        Else
        Begin
            ReadFromXMS(EnglishFontHandle, Longint(Ord(AWord[1]) * 16), EnglishBuffer, 16);
			For J := 0 To 15 Do
                For K := 0 To 7 Do
                	If EnglishBuffer[J] Shr K And 1 = 1 Then
                    Begin
						If ForeColor >= 0 Then PutPixel(X - K + I * 8 + IntervalSum - 1, Y + J, ForeColor)
                    End
                    Else
					Begin
						If BackColor >= 0 Then PutPixel(X - K + I * 8 + IntervalSum - 1, Y + J, BackColor)
					End
		End;
		I := I + 1;
		IntervalSum := IntervalSum + Interval
    Until I > Length(Character)
End;

Procedure WriteText(Character: String; Top, Left, Right, ForeColor, BackColor: Integer);
Var
	I, J, K, Line, Max: Integer;
    TextString, Part: String;
Begin
	I := 1;
    Line := 0;
    Max := (Right - Left) Div 8;
    TextString := Character + #0;
    Repeat
        J := I;
		Repeat
			K := J - I;
			If (TextString[J] In [#161..#247]) And (TextString[J + 1] In [#161..#254]) Then J := J + 1;
			If (TextString[J] = #13) Or (TextString[J] = #0) Then Break;
			J := J + 1
		Until J > Max + I;
        Part := Copy(Character, I, K);
		WriteChinese(Part, Left, Top + Line * 16, ForeColor, BackColor, 0);
		I := I + K;
        If Character[I] = #13 Then I := I + 2;
        Line := Line + 1
    Until I >= Length(Character)
End;

Function ChineseReadKey: Char;
Var
    I, ChoosePage, MaxChoosePage, Num1, Num2, ValCode: Integer;
    IsFinish, IsChooseWord, InputFlag: Boolean;
	InKey, Result: Char;
    Code, Str1, Str2: String;
	ChooseWord: Array[1..256] Of String[2];
Begin
	If LastChineseKey <> #0 Then
	Begin
		ChineseReadKey := LastChineseKey;
		LastChineseKey := #0;
		Exit
	End;
	If Not IsChineseInput Then
	Begin
		ChineseReadKey := ReadKey;
		Exit
	End;
	IsChooseWord := False;
	IsFinish := False;
	Code := '';
	Repeat
		InKey := ReadKey;
		If IsChooseWord And (InKey = ' ') Then InKey := '1';
		Case InKey Of
			#0:
			Begin
				InKey := ReadKey;
				Case InKey Of
					#102:
					Begin
						CurInputState := Not CurInputState;
						If CurInputState Then WriteChinese('全角', 8, 462, 0, 7, 0) Else WriteChinese('半角', 8, 462, 0, 7, 0)
					End;
					#109:
					Begin
						CurInputMethod := 0;
						WriteChinese('【英文】', 48, 462, 0, 7, 0);
						SetFillStyle(SolidFill, 7);
						Bar(120, 462, 638, 478);
						IsChooseWord := False;
						Code := ''
					End;
					#104:
					Begin
						CurInputMethod := 1;
						WriteChinese('【区位】', 48, 462, 0, 7, 0);
						SetFillStyle(SolidFill, 7);
						Bar(120, 462, 638, 478);
						IsChooseWord := False;
						Code := '';
					End;
					#105:
					Begin
						CurInputMethod := 2;
						WriteChinese('【拼音】', 48, 462, 0, 7, 0);
						SetFillStyle(SolidFill, 7);
						Bar(120, 462, 638, 478);
						IsChooseWord := False;
						Code := ''
					End;
					Else
					Begin
						LastChineseKey := InKey;
						IsFinish := True;
						Result := #0
					End
				End
			End;
			#8:
			Begin
				If (CurInputMethod = 0) Or (Code = '') Then
				Begin
					IsFinish := True;
					Result := InKey
				End
				Else
				Begin
					Code := Copy(Code, 1, Length(Code) - 1);
					SetFillStyle(SolidFill, 7);
					Bar(120 + Length(Code) * 8, 462, 127 + Length(Code) * 8, 478)
				End;
				If (CurInputMethod = 2) Then
				Begin
					InputFlag := False;
					For I := 1 To 417 Do
						If InputMethodCode[I] = Code Then
						Begin
							InputFlag := True;
							Break
						End;
					If Code = '' Then InputFlag := False;
					If InputFlag Then
					Begin
						ReadFromXMS(InputMethodHandle, Longint(I - 1) * 256, Str2, 256);
						IsChooseWord := True;
						ChoosePage := 0;
						MaxChoosePage := (Length(Str2) - 1) Div 20;
						For I := 1 To 256 Do
							If I > Length(Str2) Div 2 Then ChooseWord[I] := '' Else ChooseWord[I] := Copy(Str2, I * 2 - 1, 2);
						SetFillStyle(SolidFill, 7);
						Bar(200, 462, 638, 478);
						For I := 1 To 10 Do
						Begin
							Str(I Mod 10, Str1);
							Str1 := Str1 + ':' + ChooseWord[ChoosePage * 10 + I];
							WriteChinese(Str1, 160 + I * 40, 462, 0, 7, 0)
						End
					End
					Else
					Begin
						IsChooseWord := False;
						SetFillStyle(SolidFill, 7);
						Bar(200, 462, 638, 478)
					End
				End
			End;
			'0'..'9', '-' ,'=':
			Begin
				If CurInputMethod <> 1 Then
				Begin
					If IsChooseWord Then
					Begin
						If InKey = ' ' Then InKey := '1';
						Case InKey Of
							'-':
								If ChoosePage > 0 Then
								Begin
									ChoosePage := ChoosePage - 1;
									SetFillStyle(SolidFill, 7);
									Bar(200, 462, 638, 478);
									For I := 1 To 10 Do
									Begin
										Str(I Mod 10, Str1);
										Str1 := Str1 + ':' + ChooseWord[ChoosePage * 10 + I];
										WriteChinese(Str1, 160 + I * 40, 462, 0, -1, 0)
									End
								End;
							'=':
								If ChoosePage < MaxChoosePage Then
								Begin
									ChoosePage := ChoosePage + 1;
									SetFillStyle(SolidFill, 7);
									Bar(200, 462, 638, 478);
									For I := 1 To 10 Do
									Begin
										Str(I Mod 10, Str1);
										Str1 := Str1 + ':' + ChooseWord[ChoosePage * 10 + I];
										WriteChinese(Str1, 160 + I * 40, 462, 0, -1, 0)
									End
								End;
							'0'..'9':
							Begin
								Val(InKey, Num1, ValCode);
								If Num1 = 0 Then Num1 := 10;
								Num1 := Num1 + ChoosePage * 10;
								If Num1 <> 0 Then
									If ChooseWord[Num1] <> '' Then
									Begin
										IsFinish := True;
										Result := ChooseWord[Num1][1];
										LastChineseKey := ChooseWord[Num1][2];
										SetFillStyle(SolidFill, 7);
										Bar(120, 462, 638, 478);
										IsChooseWord := False;
										Code := ''
									End
							End
						End
					End
					Else
					Begin
						IsFinish := True;
						Result := InKey
					End
				End
				Else
				Begin
					InputFlag := True;
					If Length(Code) Mod 2 = 1 Then
					Begin
						If (Copy(Code, Length(Code), 1) = '0') And (InKey = '0') Then InputFlag := False;
						If (Copy(Code, Length(Code), 1) = '9') And (InKey > '4') Then InputFlag := False
					End;
					If InputFlag Then
					Begin
						Code := Code + ' ';
						Code[Length(Code)] := InKey;
						If Length(Code) = 4 Then
						Begin
							Val(Copy(Code, 1, 2), Num1, ValCode);
							Val(Copy(Code, 3, 2), Num2, ValCode);
							IsFinish := True;
							Result := Chr(Num1 + 160);
							LastChineseKey := Chr(Num2 + 160);
							SetFillStyle(SolidFill, 7);
							Bar(120, 462, 638, 478);
							Code := ''
						End
					End
				End
			End;
			'a'..'z':
			Begin
				If (CurInputMethod = 2) And (Length(Code) < 6) Then
				Begin
					InputFlag := False;
					Code := Code + ' ';
					Code[Length(Code)] := InKey;
					For I := 1 To 417 Do
						If InputMethodCode[I] = Code Then
						Begin
							InputFlag := True;
							Break
						End;
					If InputFlag Then
					Begin
						ReadFromXMS(InputMethodHandle, Longint(I - 1) * 256, Str2, 256);
						IsChooseWord := True;
						ChoosePage := 0;
						MaxChoosePage := (Length(Str2) - 1) Div 20;
						For I := 1 To 256 Do
							If I > Length(Str2) Div 2 Then ChooseWord[I] := '' Else ChooseWord[I] := Copy(Str2, I * 2 - 1, 2);
						SetFillStyle(SolidFill, 7);
						Bar(200, 462, 638, 478);
						For I := 1 To 10 Do
						Begin
							Str(I Mod 10, Str1);
							Str1 := Str1 + ':' + ChooseWord[ChoosePage * 10 + I];
							WriteChinese(Str1, 160 + I * 40, 462, 0, -1, 0)
						End
					End
					Else
					Begin
						IsChooseWord := False;
						SetFillStyle(SolidFill, 7);
						Bar(200, 462, 638, 478)
					End
				End
				Else
				Begin
					If CurInputMethod <> 2 Then
					Begin
						IsFinish := True;
						Result := InKey
					End
				End
			End;
			Else
			Begin
				IsFinish := True;
				Result := InKey
			End
		End;
		WriteChinese(Code, 120, 462, 0, 7, 0)
	Until IsFinish;
	SetFillStyle(SolidFill, 7);
	Bar(120, 462, 638, 478);
	If CurInputState And (Result In [#32..#126]) Then
	Begin
		Case Result Of
			' ':
			Begin
				LastChineseKey := #161;
				Result := #161
			End;
			'.':
			Begin
				LastChineseKey := #163;
				Result := #161
			End;
			'~':
			Begin
				LastChineseKey := #162;
				Result := #161
			End;
			'''':
			Begin
				If IsQuotation2 Then LastChineseKey := #174 Else LastChineseKey := #175;
				Result := #161;
				IsQuotation2 := Not IsQuotation2
			End;
			'"':
			Begin
				If IsQuotation1 Then LastChineseKey := #176 Else LastChineseKey := #177;
				Result := #161;
				IsQuotation1 := Not IsQuotation1
			End;
			Else
			Begin
				LastChineseKey := Chr(128 + Ord(Result));
				Result := #163;
			End
		End
	End;
	ChineseReadKey := Result
End;

Procedure ShowChineseInputLine;
Begin
	ChineseInputHandle := CreateWindow('', 0, -1, 0, 460, 640, 20, False, False);
	SetColor(15);
	Line(0, 460, 638, 460);
	Line(0, 460, 0, 478);
	SetColor(8);
	Line(0, 479, 639, 479);
	Line(639, 460, 639, 479);
	SetFillStyle(SolidFill, 7);
	Bar(1, 461, 638, 478);
	If CurInputState Then WriteChinese('全角', 8, 462, 0, -1, 0) Else WriteChinese('半角', 8, 462, 0, -1, 0);
	Case CurInputMethod Of
		0: WriteChinese('【英文】', 48, 462, 0, -1, 0);
		1: WriteChinese('【区位】', 48, 462, 0, -1, 0);
		2: WriteChinese('【拼音】', 48, 462, 0, -1, 0)
	End;
	IsQuotation1 := True;
	IsQuotation2 := True;
	IsChineseInput := True;
	LastChineseKey := #0
End;

Procedure HideChineseInputLine;
Begin
	IsChineseInput := False;
	If ChineseInputHandle <> 0 Then DestroyWindow(ChineseInputHandle);
	ChineseInputHandle := 0
End;

Procedure SetStatusLine(Prompt: String);
Begin
	If Length(Prompt) > 78 Then Prompt := Copy(Prompt, 1, 75) + '...';
	SetColor(15);
	Line(0, 460, 638, 460);
	Line(0, 460, 0, 478);
	SetColor(8);
	Line(0, 479, 639, 479);
	Line(639, 460, 639, 479);
	SetFillStyle(SolidFill, 7);
	Bar(1, 461, 638, 478);
	WriteChinese(Prompt, 8, 462, 0, -1, 0)
End;

Function MessageBox(Prompt, Caption: String; BorderStyle, Left, Top, Width, Height: Integer; IsButton, IsCaption, IsSize:
	Boolean): Boolean;
Var
	CenterX, ClientLeft, ClientTop, ClientRight, ClientBottom: Integer;
	Choose: Boolean;
	InKey: Char;
	Size, DialogHandle: Word;
    YesBuffer, NoBuffer: Pointer;
Begin
	Choose := True;
	DialogHandle := CreateWindow(Caption, BorderStyle, 16, Left, Top, Width, Height, IsCaption, IsSize);
    ClientLeft := GetWindowClientLeft(DialogHandle);
    ClientTop := GetWindowClientTop(DialogHandle);
    ClientRight := ClientLeft + GetWindowClientWidth(DialogHandle) - 1;
    ClientBottom := ClientTop + GetWindowClientHeight(DialogHandle) - 1;
    CenterX := (ClientLeft + ClientRight) Div 2;
    If IsButton Then
	Begin
    	SetFillStyle(SolidFill, 2);
		Bar(CenterX - 60, ClientBottom - 30, CenterX - 10, ClientBottom - 10);
        Bar(CenterX + 10, ClientBottom - 30, CenterX + 60, ClientBottom - 10);
        SetColor(0);
		Rectangle(CenterX - 61, ClientBottom - 31, CenterX - 9, ClientBottom - 9);
		Rectangle(CenterX + 9, ClientBottom - 31, CenterX + 61, ClientBottom - 9);
		WriteChinese('是', CenterX - 43, ClientBottom - 28, 13, -1, 0);
		WriteChinese('否', CenterX + 27, ClientBottom - 28, 13, -1, 0);
		Size := ImageSize(0, 0, 50, 20);
    	GetMem(YesBuffer, Size);
        If YesBuffer = Nil Then FatalError('Out Of Memory!');
        GetMem(NoBuffer, Size);
        If NoBuffer = Nil Then FatalError('Out Of Memory!');
	    Choose := True;
	    GetImage(CenterX - 60, ClientBottom - 30, CenterX - 10, ClientBottom - 10, YesBuffer^);
	    GetImage(CenterX + 10, ClientBottom - 30, CenterX + 60, ClientBottom - 10, NoBuffer^);
    	PutImage(CenterX - 60, ClientBottom - 30, YesBuffer^, NotPut);
    End;
    WriteText(Prompt, ClientTop + 8, ClientLeft + 8, ClientRight - 8, 0, -1);
	Repeat
    	InKey := ReadKey;
		If Not IsButton And (InKey = #27) Then Break;
        If InKey = #0 Then
        Begin
			InKey := ReadKey;
			If IsButton Then
				Case InKey Of
					#75:
						If Choose = False Then
                        Begin
                            Choose := True;
                            PutImage(CenterX - 60, ClientBottom - 30, YesBuffer^, NotPut);
                            PutImage(CenterX + 10, ClientBottom - 30, NoBuffer^, NormalPut)
                        End;
            	    #77:
                    	If Choose = True Then
                        Begin
                            Choose := False;
                            PutImage(CenterX - 60, ClientBottom - 30, YesBuffer^, NormalPut);
							PutImage(CenterX + 10, ClientBottom - 30, NoBuffer^, NotPut)
                        End
				End
        End
    Until InKey = #13;
	If IsButton Then
	Begin
		FreeMem(YesBuffer, Size);
		FreeMem(NoBuffer, Size);
	End;
    DestroyWindow(DialogHandle);
    MessageBox := Choose
End;

Function InputBox(Prompt, Caption, Default: String; BorderStyle, Left, Top, Width, Height, MaxLen: Integer;	CanCancel,
	IsCaption, IsSize: Boolean): String;
Var
	I, ClientLeft, ClientTop, ClientRight, ClientBottom: Integer;
	InKey: Char;
	DialogHandle: Word;
	Input: String;
Begin
	DialogHandle := CreateWindow(Caption, BorderStyle, 16, Left, Top, Width, Height, IsCaption, IsSize);
	ClientLeft := GetWindowClientLeft(DialogHandle);
	ClientTop := GetWindowClientTop(DialogHandle);
	ClientRight := ClientLeft + GetWindowClientWidth(DialogHandle) - 1;
	ClientBottom := ClientTop + GetWindowClientHeight(DialogHandle) - 1;
	WriteText(Prompt, ClientTop + 8, ClientLeft + 8, ClientRight - 8, 0, -1);
	SetColor(9);
	Line(ClientLeft + 8, ClientBottom - 8, ClientRight - 8, ClientBottom - 8);
	SetColor(12);
	Line(ClientLeft + MaxLen * 8 + 6, ClientBottom - 30, ClientLeft + MaxLen * 8 + 10, ClientBottom - 30);
	Line(ClientLeft + MaxLen * 8 + 6, ClientBottom - 29, ClientLeft + MaxLen * 8 + 10, ClientBottom - 29);
	Line(ClientLeft + MaxLen * 8 + 7, ClientBottom - 28, ClientLeft + MaxLen * 8 + 9, ClientBottom - 28);
	Line(ClientLeft + MaxLen * 8 + 7, ClientBottom - 27, ClientLeft + MaxLen * 8 + 9, ClientBottom - 27);
	PutPixel(ClientLeft + MaxLen * 8 + 8, ClientBottom - 26, 9);
	Input := Default;
	WriteChinese(Input, ClientLeft + 8, ClientBottom - 24, 0, -1, 0);
	I := Length(Input);
	Repeat
		Repeat
			InKey := ChineseReadKey;
			If InKey = #0 Then ChineseReadKey
		Until InKey <> #0;
		If (InKey = #8) And (I > 0) Then
		Begin
			I := I - 1;
			SetFillStyle(SolidFill, GetWindowBackColor(DialogHandle));
			If I <> 0 Then
				If (Input[Length(Input) - 1] In [#161..#247]) And (Input[Length(Input)] In [#161..#254]) Then
				Begin
					Bar(ClientLeft + I * 8 + 8, ClientBottom - 24, Left + I * 8 + 23, ClientBottom - 9);
					I := I - 1
				End;
			Input := Copy(Input, 1, I);
			Bar(ClientLeft + I * 8 + 8, ClientBottom - 24, ClientLeft + I * 8 + 15, ClientBottom - 9);
			WriteChinese(Input, ClientLeft + 8, ClientBottom - 24, 0, GetWindowBackColor(DialogHandle), 0)
		End;
		If (InKey >= #32) And (I < MaxLen) Then
		Begin
			I := I + 1;
			Input := Input + ' ';
			Input[I] := InKey;
			WriteChinese(Input, ClientLeft + 8, ClientBottom - 24, 0, GetWindowBackColor(DialogHandle), 0)
		End;
		If CanCancel And (InKey = #27) Then
		Begin
			Input := #27;
			Break
		End
	Until InKey = #13;
	DestroyWindow(DialogHandle);
	InputBox := Input
End;

Function NumberInputBox(Left, Top: Integer; Max: Longint; CanCancel: Boolean): Longint;
Var
    Num, ValCode: Integer;
    InKey: Char;
    PictureHandle, DialogHandle: Word;
    Value: Longint;
    ValueStr: String;
Begin
	Value := 0;
	DialogHandle := CreateWindow('', 0, 16, Left, Top, 160, 240, False, False);
	PictureHandle := LoadPicture('CALC.IMG');
	If (GetPictureWidth(PictureHandle, 0) <> 160) Or (GetPictureHeight(PictureHandle, 0) <> 240) Then
        If Not MessageBox('图形文件CALC.IMG被非法修改，是否继续？', '', 1, 200, 180, 240, 120, True, False, False) Then
			FatalError('');
	DisplayPicture(PictureHandle, 0, Left, Top, NormalPut);
	DeletePicture(PictureHandle);
	WriteChinese('0', Left + 122, Top + 25, 15, 7, 0);
    Repeat
    	Repeat
	    	InKey := ReadKey;
            If InKey = #0 Then ReadKey
        Until InKey <> #0;
        Case InKey Of
            #8:
			Begin
				Value := Value Div 10;
                SetFillStyle(SolidFill, 0);
                Bar(Left + 27, Top + 25, Left + 130, Top + 40);
		        Str(Value, ValueStr);
		        WriteChinese(ValueStr, Left + 130 - Length(ValueStr) * 8, Top + 25, 15, -1, 0);
				SetFillStyle(SolidFill, 0);
				Bar(Left + 16, Top + 50, Left + 142, Top + 59);
        		SetFillStyle(SolidFill, 9);
				If Value <> 0 Then Bar(Left + 16, Top + 50, Left + 16 + Round(Value / Max * 126), Top + 59)
			End;
			#27:
				If CanCancel Then
                Begin
                	Value := -1;
                    Break
    	        End;
        	'0'..'9':
			Begin
                Val(InKey, Num, ValCode);
                Value := Value * 10 + Num;
                If Value > Max Then Value := Max;
		        Str(Value, ValueStr);
		        WriteChinese(ValueStr, Left + 130 - Length(ValueStr) * 8, Top + 25, 15, 0, 0);
				SetFillStyle(SolidFill, 0);
				Bar(Left + 16, Top + 50, Left + 142, Top + 59);
				SetFillStyle(SolidFill, 9);
		        If Value <> 0 Then Bar(Left + 16, Top + 50, Left + 16 + Round(Value / Max * 126), Top + 59)
            End
		End
	Until InKey = #13;
	DestroyWindow(DialogHandle);
	NumberInputBox := Value
End;

Function ListBox(Handle, Count, Default: Word; Var Caption: Array Of ListStr; Var Enabled: Array Of Boolean; CanCancel: Boolean
	): Word;
Var
	Left, Top, Right, Bottom: Integer;
	HasChange: Boolean;
	InKey: Char;
	I, TextLine, Line, Cols, Rows, Row, RowScroll: Word;
	Buffer: Pointer;
    ListText: String;
Begin
	Left := GetWindowClientLeft(Handle);
    Top := GetWindowClientTop(Handle);
    Right := Left + GetWindowClientWidth(Handle) - 1;
    Bottom := Top + GetWindowClientHeight(Handle) - 1;
    GetMem(Buffer, ImageSize(Left, 0, Right, 19));
    If Buffer = Nil Then FatalError('Out Of Memory!');
    Rows := (Bottom - Top + 1) Div 20;
    Cols := (Right - Left + 1) Div 8;
    Row := Default;
    If Row > Rows Then RowScroll := Row - Rows Else RowScroll := 0;
    Line := Row - RowScroll;
	SetFillStyle(SolidFill, 15);
    For I := RowScroll + 1 To Count Do
    Begin
		TextLine := I - RowScroll;
		ListText := GetChinese(Caption[I - 1], Cols);
		Bar(Left, Top + TextLine * 20 - 20, Right, Top + TextLine * 20 - 1);
		If Enabled[I - 1] Then
        	WriteChinese(ListText, Left, Top + TextLine * 20 - 18, 0, -1, 0)
        Else
        	WriteChinese(ListText, Left, Top + TextLine * 20 - 18, 8, -1, 0);
        If TextLine = Rows Then Break
    End;
	GetImage(Left, Top + Line * 20 - 20, Right, Top + Line * 20 - 1, Buffer^);
    PutImage(Left, Top + Line * 20 - 20, Buffer^, NotPut);
    Repeat
    	ClearKeyboardBuffer;
    	InKey := ReadKey;
        Case InKey Of
            #0:
            Begin
				InKey := ReadKey;
                HasChange := False;
                Case InKey Of
					#72:
						If Row > 1 Then
						Begin
							PutImage(Left, Top + Line * 20 - 20, Buffer^, NormalPut);
							If Line = 1 Then
							Begin
                            	HasChange := True;
								RowScroll := RowScroll - 1
                            End;
                            Row := Row - 1;
                            Line := Row - RowScroll;
                            If HasChange Then
                            Begin
	                            SetFillStyle(SolidFill, 15);
                                For I := RowScroll + 1 To Count Do
                                Begin
                                	TextLine := I - RowScroll;
									ListText := GetChinese(Caption[I - 1], Cols);
                                    Bar(Left, Top + TextLine * 20 - 20, Right, Top + TextLine * 20 - 1);
									If Enabled[I - 1] Then
										WriteChinese(ListText, Left, Top + TextLine * 20 - 18, 0, -1, 0)
									Else
										WriteChinese(ListText, Left, Top + TextLine * 20 - 18, 8, -1, 0);
									If TextLine = Rows Then Break
                                End
                            End;
                            GetImage(Left, Top + Line * 20 - 20, Right, Top + Line * 20 - 1, Buffer^);
                        	PutImage(Left, Top + Line * 20 - 20, Buffer^, NotPut);
	                    End;
                    #80:
                    	If Row < Count Then
    	                Begin
                           	PutImage(Left, Top + Line * 20 - 20, Buffer^, NormalPut);
							If Line = Rows Then
                            Begin
                            	HasChange := True;
								RowScroll := RowScroll + 1
                            End;
                            Row := Row + 1;
                            Line := Row - RowScroll;
							If HasChange Then
							Begin
								SetFillStyle(SolidFill, 15);
								For I := RowScroll + 1 To Count Do
                                Begin
            	                	TextLine := I - RowScroll;
                	                ListText := GetChinese(Caption[I - 1], Cols);
                                    Bar(Left, Top + TextLine * 20 - 20, Right, Top + TextLine * 20 - 1);
									If Enabled[I - 1] Then
										WriteChinese(ListText, Left, Top + TextLine * 20 - 18, 0, -1, 0)
						        	Else
										WriteChinese(ListText, Left, Top + TextLine * 20 - 18, 8, -1, 0);
						    	    If TextLine = Rows Then Break
                                End
                            End;
                            GetImage(Left, Top + Line * 20 - 20, Right, Top + Line * 20 - 1, Buffer^);
                        	PutImage(Left, Top + Line * 20 - 20, Buffer^, NotPut);
        	            End
                End
            End;
			#27: If CanCancel Then Break;
			#13: If Not Enabled[Row - 1] Then InKey := #0
		End
	Until InKey = #13;
    FreeMem(Buffer, ImageSize(Left, 0, Right, 19));
    If InKey = #13 Then ListBox := Row Else ListBox := 0
End;

Function PictureListBox(Handle, Count, Default, PicHandle: Word; Var Number: Array Of Integer; Var Caption: Array Of PicListStr
	; IsCaption, CanCancel: Boolean): Word;
Var
	Left, Top, Right, Bottom: Integer;
    HasChange: Boolean;
    InKey: Char;
    DisplayLeft, I, PicWidth, PicHeight, PicCol, CurCol, Col, Cols, ColScroll: Word;
Begin
	Left := GetWindowClientLeft(Handle);
    Top := GetWindowClientTop(Handle);
    Right := Left + GetWindowClientWidth(Handle) - 1;
    Bottom := Top + GetWindowClientHeight(Handle) - 1;
	PicWidth := GetPictureWidth(PicHandle, 0);
	PicHeight := GetPictureHeight(PicHandle, 0);
	Cols := (Right - Left + 1) Div (PicWidth + 16);
	Col := Default;
    If Col > Cols Then ColScroll := Col - Cols Else ColScroll := 0;
    CurCol := Col - ColScroll;
    HasChange := True;
    Repeat
    	If HasChange Then
        Begin
	    	SetColor(9);
	    	For I := ColScroll + 1 To Count Do
		    Begin
    		    PicCol := I - ColScroll;
		        DisplayPicture(PicHandle, Number[I - 1], Left + (PicWidth + 16) * (PicCol - 1) + 8, Top + 8, NormalPut);
				If IsCaption Then
	    	    Begin
            		SetFillStyle(SolidFill, 15);
                    DisplayLeft := Left + (PicWidth + 16) * PicCol;
                    Bar(DisplayLeft - PicWidth - 16, Top + PicHeight + 16, DisplayLeft - 1, Top + PicHeight + 31);
					DisplayLeft := Left + (PicWidth + 16) * (PicCol - 1) + PicWidth Div 2 - Length(Caption[I - 1]) * 4 + 8;
					WriteChinese(Caption[I - 1], DisplayLeft, Top + PicHeight + 16, 0, -1, 0)
				End;
				If PicCol = Cols Then Break
    		End;
            DisplayLeft := Left + (PicWidth + 16) * CurCol;
            Rectangle(DisplayLeft - PicWidth - 9, Top + 7, DisplayLeft - 8, Top + PicHeight + 8)
        End;
        ClearKeyboardBuffer;
    	InKey := ReadKey;
        HasChange := False;
        Case InKey Of
        	#0:
            Begin
                InKey := ReadKey;
                Case InKey Of
                    #75:
                    	If Col > 1 Then
	                    Begin
                        	SetColor(15);
							DisplayLeft := Left + (PicWidth + 16) * CurCol;
							Rectangle(DisplayLeft - PicWidth - 9, Top + 7, DisplayLeft - 8, Top + PicHeight + 8);
							If CurCol = 1 Then
							Begin
                            	HasChange := True;
                                ColScroll := ColScroll - 1
                            End;
                            Col := Col - 1;
                            CurCol := Col - ColScroll;
                            If Not HasChange Then
                            Begin
	                            SetColor(9);
					            DisplayLeft := Left + (PicWidth + 16) * CurCol;
					            Rectangle(DisplayLeft - PicWidth - 9, Top + 7, DisplayLeft - 8, Top + PicHeight + 8)
                            End
    	                End;
                    #77:
        				If Col < Count Then
	                    Begin
                        	SetColor(15);
							DisplayLeft := Left + (PicWidth + 16) * CurCol;
							Rectangle(DisplayLeft - PicWidth - 9, Top + 7, DisplayLeft - 8, Top + PicHeight + 8);
							If CurCol = Cols Then
							Begin
                            	HasChange := True;
								ColScroll := ColScroll + 1
                            End;
                            Col := Col + 1;
                            CurCol := Col - ColScroll;
                            If Not HasChange Then
                            Begin
                            	SetColor(9);
					            DisplayLeft := Left + (PicWidth + 16) * CurCol;
					            Rectangle(DisplayLeft - PicWidth - 9, Top + 7, DisplayLeft - 8, Top + PicHeight + 8)
                            End
    	                End
                End
            End;
            #27: If CanCancel Then Break
        End
	Until InKey = #13;
	If InKey = #13 Then PictureListBox := Col Else PictureListBox := 0
End;

Var
    I, Result: Word;
    Buffer: Pointer;
    InputMethodLine: String;
    InputMethodFile: File Of InputMethodDataType;
    ChineseFontFile, EnglishFontFile: File;
    InputMethodFileData: InputMethodDataType;
Begin
	Assign(ChineseFontFile, 'HZK16');
    Assign(EnglishFontFile, 'ASC16');
    Assign(InputMethodFile, 'PY.IMF');
    GetMem(Buffer, 1024);
    If Buffer = Nil Then FatalError('Out Of Memory!');
    Reset(ChineseFontFile);
    If IOResult <> 0 Then FatalError('Error Open File HZK16!');
	ChineseFontHandle := AllocXMS(262);
	For I := 0 To 261 Do
	Begin
		BlockRead(ChineseFontFile, Buffer^, 8, Result);
		If IOResult <> 0 Then
		Begin
        	Close(ChineseFontFile);
			FatalError('Error Reading File HZK16!')
        End;
        WriteToXMS(ChineseFontHandle, Longint(I) * 1024, Buffer^, 1024)
   	End;
    Close(ChineseFontFile);
    Reset(EnglishFontFile);
    If IOResult <> 0 Then FatalError('Error Open File ASC16!');
    EnglishFontHandle := AllocXMS(4);
	For I := 0 To 3 Do
    Begin
   		BlockRead(EnglishFontFile, Buffer^, 8, Result);
        If IOResult <> 0 Then
		Begin
        	Close(EnglishFontFile);
			FatalError('Error Reading File ASC16!')
        End;
		WriteToXMS(EnglishFontHandle, Longint(I) * 1024, Buffer^, 1024)
	End;
    Close(EnglishFontFile);
    FreeMem(Buffer, 1024);
    For I := 1 To 32 Do Window[I].Handle := 0;
    InputMethodHandle := AllocXMS(105);
    Reset(InputMethodFile);
	If IOResult <> 0 Then FatalError('Error Open File PY.IMF!');
    For I := 1 To 417 Do
    Begin
    	Read(InputMethodFile, InputMethodFileData);
		If IOResult <> 0 Then
        Begin
        	Close(InputMethodFile);
			FatalError('Error Reading File PY.IMF!')
        End;
        InputMethodCode[I] := InputMethodFileData.Code;
		WriteToXMS(InputMethodHandle, Longint(I - 1) * 256, InputMethodFileData.Character, 256)
	End;
	Close(InputMethodFile)
End.