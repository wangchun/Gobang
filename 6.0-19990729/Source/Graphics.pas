{**********************************************************}
{                                                          }
{         五子棋   版本6.1   王纯   1999年10月20日         }
{                                                          }
{    Gobang   Version 6.1   Wang Chun   October 20 1999    }
{                                                          }
{**********************************************************}

{图形模块}

{$G+}
Unit Graphics;

Interface

Uses
	Crt, Dos, Strings, Graph;

Type
	PByte = ^Byte;
	PWord = ^Word;
	PInteger = ^Integer;
	PLongint = ^Longint;
	TWideChar = Array[0..1] Of Char;
	TPrompt = Record
		Code: String[6];
		Page: Integer;
		MaxPage: Integer;
		ChooseWord: Array[1..256] Of TWideChar;
	End;
	TPalette = Array[0..15] Of Longint;
	TResName = Array[0..31] Of Char;
	TResType = Word;
	PResContent = ^TResContent;
	TResContent = Record
		Name: TResName;
		ResType: TResType;
		Offset: Longint;
		Size: Longint;
	End;
	TCaption = String[64];
	TWindow = Record
		Picture: Pointer;
		Caption: TCaption;
		Style: Word;
		Color: Shortint;
		Left, Top, Width, Height, ClientLeft, ClientTop, ClientWidth, ClientHeight: Integer;
	End;

Const
	CrLf = #13#10;
	BufSize = 64000;
	imCode = 1;
	imSpell = 2;
	imEnglish = 6;
	kfNone = 0;
	kfShift = 1;
	kfCtrl = 2;
	kfAlt = 4;
	idOK = 1;
	idCancel = 2;
	idAbort = 3;
	idRetry = 4;
	idIgnore = 5;
	idYes = 6;
	idNo = 7;
	mbOK = 0;
	mbOKCancel = 1;
	mbAbortRetryIgnore = 2;
	mbYesNoCancel = 3;
	mbYesNo = 4;
	mbRetryCancel = 5;
	mbIconHand = 16;
	mbIconQuestion = 32;
	mbIconExclamation = 48;
	mbIconAsterisk = 64;
	wsNone = 0;
	wsBorder = 1;
	wsFlat = 2;
	wsCaption = 4;
	wsSize = 8;
	rtBinary: TResType = 0;
	rtText: TResType = 1;
	rtImage: TResType = 2;
	rtPicture: TResType = 3;
	clTransparent = -1;
	clBlack = 0;
	clMaroon = 1;
	clGreen = 2;
	clOlive = 3;
	clNavy = 4;
	clPurple = 5;
	clTeal = 6;
	clGray = 7;
	clSilver = 8;
	clRed = 9;
	clLime = 10;
	clYellow = 11;
	clBlue = 12;
	clFuchsia = 13;
	clAqua = 14;
	clWhite = 15;
	clDefault = 16;
	DefPal: TPalette = ($000000, $0000AA, $00AA00, $00AAAA, $AA0000, $AA00AA, $AAAA00, $808080, $C0C0C0, $8080FF, $80FF80,
		$80FFFF, $FF8080, $FF80FF, $FFFF80, $FFFFFF);
	SysPal: TPalette = ($000000, $A80000, $00A800, $A8A800, $0000A8, $A800A8, $0054A8, $A8A8A8, $545454, $FF5454, $54FF54,
		$FFFF54, $5454FF, $FF54FF, $54FFFF, $FFFFFF);

Var
	MouseEnabled, ChineseEnabled, WideEnabled, SingleQuotationFlag, DoubleQuotationFlag: Boolean;
	InputMethod: Integer;
	ASCFont, HZKFont, InputMethodData: Pointer;
	DesktopWindow, StatusWindow: TWindow;
	DataFile, HelpFile, HistoryFile, ManualFile: PathStr;
	Title: TCaption;
	UpdateDate: String[14];
	StatusPrompt: String[78];

Procedure TextFatalExit;
Procedure GraphicsFatalExit;
Procedure EnableGraphics(State: Boolean);
Function GetMemoryPtr(P: Pointer; Start: Longint): Pointer;
Function AllocMemory(Size: Longint): Pointer;
Procedure FreeMemory(P: Pointer);
Procedure MicrosecondDelay(Microsecond: Longint);
Function GetPaletteColor(Color: Shortint): Byte;
Procedure SetDefaultPalette(Value: Byte);
Procedure SetSystemPalette(Value: Byte);
Function GetResourceSize(FileName: PathStr; ResName: PChar; ResType: TResType): Longint;
Function LoadResource(FileName: PathStr; ResName: PChar; ResType: TResType): Pointer;
Function CopyPicture(Picture: Pointer; Top, Bottom: Word): Pointer;
Function GetPictureWidth(Picture: Pointer): Word;
Function GetPictureHeight(Picture: Pointer): Word;
Function GetPicture(X, Y, Width, Height: Word): Pointer;
Procedure PutPicture(Picture: Pointer; X, Y: Word);
Procedure DrawBorder(Var Window: TWindow; X, Y, Width, Height: Integer; Color: Shortint; State: Boolean);
Procedure DrawButton(Var Window: TWindow; Caption: TCaption; X, Y, Width, Height: Integer; State, Focus: Boolean);
Procedure DrawEdit(Var Window: TWindow; Source, User: PChar; X, Y, Width, Height: Integer; TopRow, LineCount, SourceLen,
	UserLen: Word);
Procedure DrawMemo(Var Window: TWindow; S: PChar; X, Y, Width, Height: Integer; TopRow, LineCount, StrLength: Word);
Procedure DrawVScroll(Var Window: TWindow; X, Y, Height, Value, Len, Max: Integer);
Procedure DrawWindow(Var Window: TWindow; Width: Word);
Procedure CreateWindow(Var Window: TWindow);
Procedure DestroyWindow(Var Window: TWindow);
Function GetPictureWnd(Var Window: TWindow; X, Y, Width, Height: Integer): Pointer;
Procedure PutPictureWnd(Var Window: TWindow; Picture: Pointer; X, Y: Integer);
Procedure WriteStringWnd(Var Window: TWindow; S: String; X, Y: Integer; Color: Shortint; Justify: Word);
Procedure PutPixelWnd(Var Window: TWindow; X, Y: Integer; Color: Shortint);
Function GetPixelWnd(Var Window: TWindow; X, Y: Integer): Shortint;
Procedure LineWnd(Var Window: TWindow; X1, Y1, X2, Y2: Integer; Color: Shortint; Style, Pattern, Thickness: Word);
Procedure RectangleWnd(Var Window: TWindow; X1, Y1, X2, Y2: Integer; Color: Shortint; Style, Pattern, Thickness: Word);
Procedure BarWnd(Var Window: TWindow; X1, Y1, X2, Y2: Integer; Color: Shortint);
Function CopyChinese(S: String; Count: Integer): String;
Procedure WriteCharacter(Code, X, Y: Word; Color: Shortint);
Procedure WriteString(S: String; X, Y: Word; Color: Shortint);
Procedure SetStatusLine(Prompt: String);
Function StrToInt(S: String): Longint;
Function IntToStr(N: Longint): String;
Function RealToStr(N: Real; Width, Decimals: Word): String;
Function PtrToStr(P: Pointer): String;
Function GetKeyboardFlag: Integer;
Procedure ClearKeyboardBuffer;
Function MessageBox(Prompt: String; Caption: TCaption; Flag, Style, DefBtn: Word): Integer;
Function InputBox(Prompt, Default: String; Caption: TCaption; X, Y, Width, Height: Integer; Style, MaxLen: Word;
	CanCancel, ChineseInput: Boolean): String;
Procedure ShowPicture(Var Window: TWindow; ResName: PChar; X, Y: Integer);
Function ShowMessage(Prompt: String; Flag, DefBtn: Word): Integer;

Implementation

Procedure EGAVGADriverProc; External; {$L EGAVGA.OBJ}

Procedure MemoryError;
Begin
	RunError(300);
End;

Function ErrorStr(ExitCode: Integer; Language: Boolean): String;
Begin
	If Language Then
		Case ExitCode Of
			1: ErrorStr := '指定DOS系统服务功能号无效';
			2: ErrorStr := '指定的文件不存在';
			3: ErrorStr := '指定的路径不存在';
			4: ErrorStr := '打开的文件过多';
			5: ErrorStr := '文件访问错误';
			6: ErrorStr := '文件句柄无效';
			12: ErrorStr := '文件访问无效';
			15: ErrorStr := '错误的驱动器名';
			16: ErrorStr := '不能删除当前目录';
			17: ErrorStr := '不能重命名交叉驱动器';
			18: ErrorStr := '没有更多的被查找的文件';
			100: ErrorStr := '磁盘读错误';
			101: ErrorStr := '磁盘写错误';
			102: ErrorStr := '文件未被分配';
			103: ErrorStr := '文件未被打开';
			104: ErrorStr := '文件未被读打开';
			105: ErrorStr := '文件未被写打开';
			106: ErrorStr := '数字格式无效';
			150: ErrorStr := '磁盘被写保护';
			151: ErrorStr := '驱动器请求结构长度无效';
			152: ErrorStr := '磁盘未准备好';
			154: ErrorStr := '数据循环冗余校验错误';
			156: ErrorStr := '磁盘定位错误';
			157: ErrorStr := '未知的介质类型';
			158: ErrorStr := '扇区未找到';
			159: ErrorStr := '打印机无纸';
			160: ErrorStr := '设备写错误';
			161: ErrorStr := '设备读错误';
			162: ErrorStr := '硬件错误';
			200: ErrorStr := '除数为零';
			201: ErrorStr := '下标越界';
			202: ErrorStr := '堆栈空间溢出';
			203: ErrorStr := '堆空间不足';
			204: ErrorStr := '指针操作无效';
			205: ErrorStr := '浮点上溢';
			206: ErrorStr := '浮点下溢';
			207: ErrorStr := '浮点操作无效';
			208: ErrorStr := '未安装覆盖管理器';
			209: ErrorStr := '读覆盖文件错误';
			210: ErrorStr := '对象未被初始化';
			211: ErrorStr := '不能调用抽象的方法';
			212: ErrorStr := '流注册错误';
			213: ErrorStr := '集合序号溢出';
			214: ErrorStr := '集合溢出';
			215: ErrorStr := '溢出';
			216: ErrorStr := '一般保护故障';
			300: ErrorStr := '内存溢出';
			301: ErrorStr := '指定的资源不存在';
			302: ErrorStr := '数据文件' + DataFile + '不存在';
			Else ErrorStr := '未知错误'
		End
	Else
		Case ExitCode Of
			1: ErrorStr := 'Invalid function number';
			2: ErrorStr := 'File not found';
			3: ErrorStr := 'Path not found';
			4: ErrorStr := 'Too many open files';
			5: ErrorStr := 'File access denied';
			6: ErrorStr := 'Invalid file handle';
			12: ErrorStr := 'Invalid file access code';
			15: ErrorStr := 'Invalid drive number';
			16: ErrorStr := 'Cannot remove current directory';
			17: ErrorStr := 'Cannot rename across drives';
			18: ErrorStr := 'No more files';
			100: ErrorStr := 'Disk read error';
			101: ErrorStr := 'Disk write error';
			102: ErrorStr := 'File not assigned';
			103: ErrorStr := 'File not open';
			104: ErrorStr := 'File not open for input';
			105: ErrorStr := 'File not open for output';
			106: ErrorStr := 'Invalid numeric format';
			150: ErrorStr := 'Disk is write-protected';
			151: ErrorStr := 'Bad drive request struct length';
			152: ErrorStr := 'Drive not ready';
			154: ErrorStr := 'CRC error in data';
			156: ErrorStr := 'Disk seek error';
			157: ErrorStr := 'Unknown media type';
			158: ErrorStr := 'Sector Not Found';
			159: ErrorStr := 'Printer out of paper';
			160: ErrorStr := 'Device write fault';
			161: ErrorStr := 'Device read fault';
			162: ErrorStr := 'Hardware failure';
			200: ErrorStr := 'Division by zero';
			201: ErrorStr := 'Range check error';
			202: ErrorStr := 'Stack overflow error';
			203: ErrorStr := 'Heap overflow error';
			204: ErrorStr := 'Invalid pointer operation';
			205: ErrorStr := 'Floating point overflow';
			206: ErrorStr := 'Floating point underflow';
			207: ErrorStr := 'Invalid floating point operation';
			208: ErrorStr := 'Overlay manager not installed';
			209: ErrorStr := 'Overlay file read error';
			210: ErrorStr := 'Object not initialized';
			211: ErrorStr := 'Call to abstract method';
			212: ErrorStr := 'Stream registration error';
			213: ErrorStr := 'Collection index out of range';
			214: ErrorStr := 'Collection overflow error';
			215: ErrorStr := 'Arithmetic overflow error';
			216: ErrorStr := 'General Protection fault';
			300: ErrorStr := 'Out of memory';
			301: ErrorStr := 'Resource not found';
			302: ErrorStr := 'Data file ' + DataFile + ' not found';
			Else ErrorStr := 'Unknown error'
		End
End;

{$F+}
Procedure TextFatalExit;
Var
	ErrorMessage: String;
Begin
	If ExitCode = 0 Then Exit;
	EnableGraphics(False);
	SetSystemPalette(63);
	ErrorMessage := 'Runtime error ' + IntToStr(ExitCode) + ' at ' + PtrToStr(ErrorAddr) + '.' + CrLf;
	ErrorMessage := ErrorMessage + ErrorStr(ExitCode, False) + '.';
	Writeln(ErrorMessage);
	ExitCode := 0;
	ErrorAddr := Nil
End;

Procedure GraphicsFatalExit;
Var
	I: Integer;
	ErrorMessage: String;
Begin
	If ExitCode = 0 Then Exit;
	ExitProc := @TextFatalExit;
	SetDefaultPalette(63);
	ErrorMessage := '实时错误' + IntToStr(ExitCode) + '在内存地址' + PtrToStr(ErrorAddr) + '。' + CrLf;
	ErrorMessage := ErrorMessage + ErrorStr(ExitCode, True) + '。';
	MessageBox(ErrorMessage, '错误', mbOK Or mbIconHand, wsCaption Or wsBorder, 0);
	EnableGraphics(False);
	SetSystemPalette(63);
	ErrorMessage := 'Runtime error ' + IntToStr(ExitCode) + ' at ' + PtrToStr(ErrorAddr) + '.' + CrLf;
	ErrorMessage := ErrorMessage + ErrorStr(ExitCode, False) + '.';
	Writeln(ErrorMessage);
	ExitCode := 0;
	ErrorAddr := Nil
End;

{$F-}
Procedure EnableGraphics(State: Boolean);
Var
	GraphDriver, GraphMode: Integer;
Begin
	If State Then
	Begin
		GraphDriver := VGA;
		GraphMode := VGAHi;
		InitGraph(GraphDriver, GraphMode, '')
	End
	Else
	Begin
		CloseGraph
	End
End;

Function GetMemoryPtr(P: Pointer; Start: Longint): Pointer; Assembler;
Asm
	MOV AX, Start.Word[0]
	MOV DX, AX
	AND AX, 000FH
	AND DX, 0FFF0H
	ADD DX, Start.Word[2]
	JC @@1
	ROR DX, 4
	ADD DX, P.Word[2]
	JNC @@2
@@1:
	XOR AX, AX
	XOR DX, DX
@@2:
End;

Function AllocMemory(Size: Longint): Pointer; Assembler;
Asm
	MOV AX, Size.Word[0]
	MOV DX, Size.Word[2]
	ADD AX, 0FH
	ADC DX, 00H
	CMP DX, 0AH
	JGE @@1
	AND AX, 0FFF0H
	ADD AX, DX
	ROR AX, 4
	MOV BX, AX
	MOV AH, 48H
	INT 21H
	JNC @@2
@@1:
	CALL MemoryError
	XOR AX, AX
@@2:
	XOR DX, DX
	XCHG AX, DX
End;

Procedure FreeMemory(P: Pointer); Assembler;
Asm
	MOV AH, 49H
	MOV ES, P.Word[2]
	INT 21H
End;

Procedure MicrosecondDelay(Microsecond: Longint); Assembler;
Asm
	MOV AH, 86H
	MOV CX, Microsecond.Word[2]
	MOV DX, Microsecond.Word[0]
	INT 15H
End;

Function GetPaletteColor(Color: Shortint): Byte; Assembler;
Asm
	MOV AL, Color
	CMP AL, 06H
	JNZ @@1
	MOV AL, 14H
@@1:
	TEST AL, 08H
	JZ @@2
	ADD AL, 30H
@@2:
End;

Procedure SetDefaultPalette(Value: Byte);
Var
	I: Byte;
	Pal: Longint;
Begin
	For I := 0 To 15 Do
	Begin
		Port[$3C8] := GetPaletteColor(I);
		Pal := DefPal[I];
		Asm
			MOV BX, Pal.Word[0]
			MOV CX, Pal.Word[2]
			MOV CH, Value
			MOV DX, 03C9H
			MOV AL, BL
			MUL CH
			ROL AL, 1
			AND AL, 1
			ADD AL, AH
			OUT DX, AL
			MOV AL, BH
			MUL CH
			ROL AL, 1
			AND AL, 1
			ADD AL, AH
			OUT DX, AL
			MOV AL, CL
			MUL CH
			ROL AL, 1
			AND AL, 1
			ADD AL, AH
			OUT DX, AL
		End
	End;
	Asm
		MOV AX, 0FF0FH
		MOV BL, 8BH
		MOV CX, 8480H
		MOV DX, 8081H
		INT 10H
	End
End;

Procedure SetSystemPalette(Value: Byte);
Var
	I: Byte;
	Pal: Longint;
Begin
	For I := 0 To 15 Do
	Begin
		Port[$3C8] := GetPaletteColor(I);
		Pal := SysPal[I];
		Asm
			MOV BX, Pal.Word[0]
			MOV CX, Pal.Word[2]
			MOV CH, Value
			MOV DX, 03C9H
			MOV AL, BL
			MUL CH
			ROL AL, 1
			AND AL, 1
			ADD AL, AH
			OUT DX, AL
			MOV AL, BH
			MUL CH
			ROL AL, 1
			AND AL, 1
			ADD AL, AH
			OUT DX, AL
			MOV AL, CL
			MUL CH
			ROL AL, 1
			AND AL, 1
			ADD AL, AH
			OUT DX, AL
		End
	End;
	Asm
		MOV AX, 0FF0FH
		MOV BL, 8BH
		MOV CX, 7170H
		MOV DX, 7074H
		INT 10H
	End
End;

Function GetResourceSize(FileName: PathStr; ResName: PChar; ResType: TResType): Longint;
Var
	Flag: Boolean;
	I, ResCount: Word;
	P: Pointer;
	Content: TResContent;
	F: File;
Begin
	GetResourceSize := -1;
	Assign(F, FileName);
	Reset(F, 1);
	BlockRead(F, ResCount, SizeOf(ResCount));
	Flag := False;
	P := AllocMemory(SizeOf(TResContent) * ResCount);
	BlockRead(F, GetMemoryPtr(P, 0)^, SizeOf(TResContent) * ResCount);
	Flag := True;
	For I := 0 To ResCount - 1 Do
	Begin
		Content := PResContent(GetMemoryPtr(P, SizeOf(TResContent) * I))^;
		If (Content.ResType = ResType) And (StrComp(Content.Name, ResName) = 0) Then
		Begin
			GetResourceSize := Content.Size;
			Flag := False;
			Break
		End
	End;
	FreeMemory(P);
	Close(F);
End;

Function LoadResource(FileName: PathStr; ResName: PChar; ResType: TResType): Pointer;
Var
	Flag: Boolean;
	I, ResCount: Word;
	Count: Longint;
	P: Pointer;
	Content: TResContent;
	F: File;
Begin
	Assign(F, FileName);
	Reset(F, 1);
	BlockRead(F, ResCount, SizeOf(ResCount));
	Flag := False;
	P := AllocMemory(SizeOf(TResContent) * ResCount);
	BlockRead(F, P^, SizeOf(TResContent) * ResCount);
	Flag := True;
	For I := 0 To ResCount - 1 Do
	Begin
		Content := PResContent(GetMemoryPtr(P, SizeOf(TResContent) * I))^;
		If (Content.ResType = ResType) And (StrComp(Content.Name, ResName) = 0) Then
		Begin
			Flag := False;
			Break
		End
	End;
	FreeMemory(P);
	If Flag Then
	Begin
		Close(F);
		RunError(301)
	End;
	P := AllocMemory(Content.Size);
	Count := Content.Size;
	Seek(F, Content.Offset);
	Repeat
		If Count > BufSize Then
		Begin
			BlockRead(F, GetMemoryPtr(P, Content.Size - Count)^, BufSize);
			Dec(Count, BufSize)
		End
		Else
		Begin
			BlockRead(F, GetMemoryPtr(P, Content.Size - Count)^, Count);
			Count := 0
		End
	Until Count = 0;
	Close(F);
	LoadResource := P
End;

Function CopyPicture(Picture: Pointer; Top, Bottom: Word): Pointer;
Var
	I, LineSize: Word;
	Result, Source, Dest: Pointer;
Begin
	LineSize := ((GetPictureWidth(Picture) + 7) Shr 1) And $FFFC;
	Result := AllocMemory((Bottom - Top + 1) * LineSize + 4);
	PWord(GetMemoryPtr(Result, 0))^ := GetPictureWidth(Picture);
	PWord(GetMemoryPtr(Result, 2))^ := Bottom - Top + 1;
	For I := Top To Bottom Do
	Begin
		Source := GetMemoryPtr(Picture, Longint(I) * LineSize + 4);
		Dest := GetMemoryPtr(Result, Longint(I - Top) * LineSize + 4);
		Asm
			PUSH DS
			CLD
			MOV CX, LineSize
			MOV DI, Dest.Word[0]
			MOV ES, Dest.Word[2]
			MOV SI, Source.Word[0]
			MOV DS, Source.Word[2]
			REPNE MOVSB
			POP DS
		End
	End;
	CopyPicture := Result
End;

Function GetPictureWidth(Picture: Pointer): Word;
Begin
	GetPictureWidth := PWord(GetMemoryPtr(Picture, 0))^
End;

Function GetPictureHeight(Picture: Pointer): Word;
Begin
	GetPictureHeight := PWord(GetMemoryPtr(Picture, 2))^
End;

Function GetPicture(X, Y, Width, Height: Word): Pointer; Assembler;
Var
	J: Byte;
	I: Word;
	Picture: Pointer;
Asm
	MOV AX, Width
	ADD AX, 0007H
	SHR AX, 1
	AND AX, 0FFFCH
	MUL Height
	ADD AX, 4
	ADC DX, 0
	PUSH DX
	PUSH AX
	CALL AllocMemory
	MOV Picture.Word[2], DX
	MOV Picture.Word[0], 0
	TEST DX, DX
	JZ @@5
	PUSH Picture.Word[2]
	PUSH 0000H
	PUSH 0000H
	PUSH 0000H
	CALL GetMemoryPtr
	MOV DI, DX
	MOV SI, AX
	MOV ES, DI
	MOV DX, Width
	MOV ES:[SI], DX
	MOV DX, Height
	MOV ES:[SI + 2], DX
	ADD SI, 4
	MOV CX, X
	AND CX, 0007H
	MOV AX, Y
	MOV I, AX
@@1:
	MOV J, 0
@@2:
	MOV AX, I
	MOV DX, AX
	SHL AX, 6
	SHL DX, 4
	ADD AX, DX
	MOV BX, X
	SHR BX, 3
	ADD BX, AX
	MOV DX, 03CEH
	MOV AH, J
	MOV AL, 04H
	OUT DX, AX
	MOV DX, Width
	ADD DX, 0007H
	SHR DX, 3
	ADD DX, BX
	MOV AX, 0A000H
	MOV ES, AX
	MOV CH, ES:[BX]
@@3:
	INC BX
	MOV AX, 0A000H
	MOV ES, AX
	MOV AL, ES:[BX]
	MOV AH, CH
	MOV CH, AL
	SHL AX, CL
	MOV ES, DI
	MOV ES:[SI], AH
	INC SI
	JNZ @@4
	ADD DI, 1000H
@@4:
	CMP BX, DX
	JNZ @@3
	MOV AL, J
	INC AL
	MOV J, AL
	CMP AL, 4
	JNZ @@2
	MOV AX, I
	INC AX
	MOV I, AX
	MOV DX, Y
	ADD DX, Height
	CMP AX, DX
	JNZ @@1
@@5:
	MOV DX, Picture.Word[2]
	MOV AX, Picture.Word[0]
End;

Procedure PutPicture(Picture: Pointer; X, Y: Word); Assembler;
Var
	J, Rotate: Byte;
	I, T, Width, Height: Word;
Asm
	PUSH Picture.Word[2]
	PUSH Picture.Word[0]
	PUSH 0000H
	PUSH 0000H
	CALL GetMemoryPtr
	MOV ES, DX
	MOV BX, AX
	MOV AX, ES:[BX]
	MOV Width, AX
	MOV AX, ES:[BX + 2]
	MOV Height, AX
	ADD BX, 4
	MOV DI, DX
	MOV SI, BX
	MOV AX, X
	AND AL, 07H
	MOV Rotate, AL
	MOV AH, AL
	MOV AL, 03H
	MOV DX, 03CEH
	OUT DX, AX
	MOV AX, X
	MOV BX, AX
	ADD BX, Width
	DEC BX
	SHR AX, 3
	SHR BX, 3
	CMP AX, BX
	JZ @@14
	MOV AX, Y
	MOV I, AX
	MOV CH, Rotate
	TEST CH, CH
	JZ @@9
@@1:
	MOV J, 0
@@2:
	MOV DX, I
	MOV AX, DX
	SHL DX, 6
	SHL AX, 4
	ADD AX, DX
	MOV DX, X
	SHR DX, 3
	ADD AX, DX
	MOV T, AX
	MOV DX, 03C4H
	MOV AH, 1
	MOV CL, J
	SHL AH, CL
	MOV AL, 2
	OUT DX, AX
	MOV DX, 03CEH
	MOV AH, CL
	MOV AL, 4
	OUT DX, AX
	MOV CH, Rotate
	MOV DH, 1
	MOV CL, CH
	SHL DH, CL
	DEC DH
	MOV CL, CH
	NEG CL
	AND CL, 07H
	MOV AL, 1
	SHL AL, CL
	DEC AL
	NOT AL
	MOV BX, 0A000H
	MOV ES, BX
	MOV BX, T
	MOV DL, ES:[BX]
	AND AL, DL
	MOV CL, CH
	ROL AL, CL
	MOV ES, DI
	MOV DL, ES:[SI]
	MOV CH, DH
	NOT CH
	AND CH, DL
	OR AL, CH
	MOV BX, 0A000H
	MOV ES, BX
	MOV BX, T
	MOV ES:[BX], AL
	AND DL, DH
@@3:
	MOV BX, I
	MOV CX, BX
	SHL BX, 6
	SHL CX, 4
	ADD BX, CX
	MOV AX, X
	ADD AX, Width
	SHR AX, 3
	ADD BX, AX
	MOV AX, T
	INC AX
	MOV T, AX
	CMP AX, BX
	JZ @@5
	INC SI
	JNZ @@4
	ADD DI, 1000H
@@4:
	MOV ES, DI
	MOV CL, DL
	MOV DL, ES:[SI]
	MOV CH, DH
	NOT CH
	AND CH, DL
	OR CL, CH
	MOV CH, BL
	MOV BX, 0A000H
	MOV ES, BX
	MOV BX, AX
	MOV ES:[BX], CL
	AND DL, DH
	JMP @@3
@@5:
	INC SI
	JNZ @@6
	ADD DI, 1000H
@@6:
	MOV ES, DI
	MOV CX, X
	ADD CX, Width
	AND CX, 0007H
	JZ @@7
	MOV BL, ES:[SI]
	MOV CH, DH
	NOT CH
	AND CH, BL
	OR CH, DL
	NEG CL
	AND CL, 07H
	MOV DH, 1
	SHL DH, CL
	DEC DH
	MOV BX, 0A000H
	MOV ES, BX
	MOV BX, AX
	MOV DL, ES:[BX]
	MOV CL, Rotate
	ROL DH, CL
	ROL DL, CL
	MOV CL, DH
	NOT CL
	AND CH, CL
	MOV CL, DL
	AND CL, DH
	OR CH, CL
	MOV ES:[BX], CH
@@7:
	MOV BX, X
	MOV CX, Width
	MOV AX, CX
	ADD CX, BX
	SHR BX, 3
	SHR CX, 3
	SUB CX, BX
	ADD AX, 7
	SHR AX, 3
	CMP AX, CX
	JZ @@8
	INC SI
	JNZ @@8
	ADD DI, 1000H
@@8:
	MOV AL, J
	INC AL
	MOV J, AL
	CMP AL, 4
	JNZ @@2
	MOV AX, I
	INC AX
	MOV I, AX
	MOV BX, Y
	MOV CX, Height
	ADD BX, CX
	CMP AX, BX
	JNZ @@1
	JMP @@16
@@9:
	MOV J, 0
@@10:
	MOV DX, I
	MOV BX, DX
	SHL DX, 6
	SHL BX, 4
	ADD BX, DX
	MOV DX, X
	SHR DX, 3
	ADD BX, DX
	MOV DX, 03C4H
	MOV AH, 1
	MOV CL, J
	SHL AH, CL
	MOV AL, 2
	OUT DX, AX
	MOV DX, 03CEH
	MOV AH, CL
	MOV AL, 4
	OUT DX, AX
	MOV CX, BX
	MOV BX, I
	MOV DX, BX
	SHL BX, 4
	SHL DX, 6
	ADD DX, BX
	MOV BX, X
	ADD BX, Width
	SHR BX, 3
	ADD DX, BX
	MOV T, DX
@@11:
	MOV ES, DI
	MOV AL, ES:[SI]
	MOV DX, 0A000H
	MOV ES, DX
	MOV BX, CX
	MOV ES:[BX], AL
	INC CX
	INC SI
	JNZ @@12
	ADD DI, 1000H
@@12:
	CMP CX, T
	JNZ @@11
	MOV AX, X
	ADD AX, Width
	AND AX, 0007H
	JZ @@13
	MOV DX, CX
	NEG AL
	AND AL, 07H
	MOV AH, 1
	MOV CL, AL
	SHL AH, CL
	DEC AH
	MOV ES, DI
	MOV AL, ES:[SI]
	MOV BX, 0A000H
	MOV ES, BX
	MOV BX, DX
	MOV DL, ES:[BX]
	AND DL, AH
	NOT AH
	AND AH, AL
	OR DL, AH
	MOV ES:[BX], DL
	INC SI
	JNZ @@13
	ADD DI, 1000H
@@13:
	MOV AL, J
	INC AL
	MOV J, AL
	CMP AL, 4
	JNZ @@10
	MOV AX, I
	INC AX
	MOV I, AX
	MOV BX, Y
	MOV CX, Height
	ADD BX, CX
	CMP AX, BX
	JNZ @@9
	JMP @@16
@@14:
	MOV DX, 03CEH
	MOV AX, 0003H
	OUT DX, AX
	MOV DX, Y
	MOV BX, DX
	SHL DX, 6
	SHL BX, 4
	ADD BX, DX
	MOV DX, X
	SHR DX, 3
	ADD BX, DX
	MOV CX, Y
	ADD CX, Height
	MOV AX, CX
	SHL CX, 6
	SHL AX, 4
	ADD AX, CX
	ADD AX, DX
	MOV T, AX
	MOV CX, Width
	NEG CL
	AND CL, 07H
	MOV CH, 1
	SHL CH, CL
	DEC CH
	NOT CH
	MOV CL, Rotate
@@15:
	MOV DX, 03C4H
	MOV AX, 0102H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0004H
	OUT DX, AX
	MOV ES, DI
	MOV AL, ES:[SI]
	AND AL, CH
	SHR AL, CL
	MOV DX, 0A000H
	MOV ES, DX
	MOV AH, ES:[BX]
	MOV DH, CH
	NOT DH
	ROR DH, CL
	AND AH, DH
	OR AL, AH
	MOV ES:[BX], AL
	INC SI
	MOV DX, 03C4H
	MOV AX, 0202H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0104H
	OUT DX, AX
	MOV ES, DI
	MOV AL, ES:[SI]
	AND AL, CH
	SHR AL, CL
	MOV DX, 0A000H
	MOV ES, DX
	MOV AH, ES:[BX]
	MOV DH, CH
	NOT DH
	ROR DH, CL
	AND AH, DH
	OR AL, AH
	MOV ES:[BX], AL
	INC SI
	MOV DX, 03C4H
	MOV AX, 0402H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0204H
	OUT DX, AX
	MOV ES, DI
	MOV AL, ES:[SI]
	AND AL, CH
	SHR AL, CL
	MOV DX, 0A000H
	MOV ES, DX
	MOV AH, ES:[BX]
	MOV DH, CH
	NOT DH
	ROR DH, CL
	AND AH, DH
	OR AL, AH
	MOV ES:[BX], AL
	INC SI
	MOV DX, 03C4H
	MOV AX, 0802H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0304H
	OUT DX, AX
	MOV ES, DI
	MOV AL, ES:[SI]
	AND AL, CH
	SHR AL, CL
	MOV DX, 0A000H
	MOV ES, DX
	MOV AH, ES:[BX]
	MOV DH, CH
	NOT DH
	ROR DH, CL
	AND AH, DH
	OR AL, AH
	MOV ES:[BX], AL
	INC SI
	ADD BX, 80
	CMP BX, T
	JNZ @@15
@@16:
	MOV DX, 03C4H
	MOV AX, 0F02H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0003H
	OUT DX, AX
End;

Procedure DrawBorder(Var Window: TWindow; X, Y, Width, Height: Integer; Color: Shortint; State: Boolean);
Begin
	If State Then
	Begin
		LineWnd(Window, X, Y, X + Width - 2, Y, clGray, SolidLn, 0, 1);
		LineWnd(Window, X, Y, X, Y + Height - 2, clGray, SolidLn, 0, 1);
		LineWnd(Window, X + Width - 1, Y, X + Width - 1, Y + Height - 1, clWhite, SolidLn, 0, 1);
		LineWnd(Window, X, Y + Height - 1, X + Width - 1, Y + Height - 1, clWhite, SolidLn, 0, 1);
		LineWnd(Window, X + 1, Y + 1, X + Width - 3, Y + 1, clBlack, SolidLn, 0, 1);
		LineWnd(Window, X + 1, Y + 1, X + 1, Y + Height - 3, clBlack, SolidLn, 0, 1);
		LineWnd(Window, X + Width - 2, Y + 1, X + Width - 2, Y + Height - 2, clSilver, SolidLn, 0, 1);
		LineWnd(Window, X + 1, Y + Height - 2, X + Width - 2, Y + Height - 2, clSilver, SolidLn, 0, 1);
		If Color <> clTransparent Then
			BarWnd(Window, X + 2, Y + 2, X + Width - 3, Y + Height - 3, Color)
	End
	Else
	Begin
		RectangleWnd(Window, X, Y, X + Width - 1, Y + Height - 1, clBlack, SolidLn, 0, 1);
		LineWnd(Window, X + 1, Y + 1, X + Width - 3, Y + 1, clWhite, SolidLn, 0, 1);
		LineWnd(Window, X + 1, Y + 1, X + 1, Y + Height - 3, clWhite, SolidLn, 0, 1);
		LineWnd(Window, X + Width - 2, Y + 1, X + Width - 2, Y + Height - 2, clBlack, SolidLn, 0, 1);
		LineWnd(Window, X + 1, Y + Height - 2, X + Width - 2, Y + Height - 2, clBlack, SolidLn, 0, 1);
		LineWnd(Window, X + 2, Y + 2, X + Width - 4, Y + 2, clSilver, SolidLn, 0, 1);
		LineWnd(Window, X + 2, Y + 2, X + 2, Y + Height - 4, clSilver, SolidLn, 0, 1);
		LineWnd(Window, X + Width - 3, Y + 2, X + Width - 3, Y + Height - 3, clGray, SolidLn, 0, 1);
		LineWnd(Window, X + 2, Y + Height - 3, X + Width - 3, Y + Height - 3, clGray, SolidLn, 0, 1);
		If Color <> clTransparent Then
			BarWnd(Window, X + 2, Y + 2, X + Width - 3, Y + Height - 3, Color)
	End
End;

Procedure DrawButton(Var Window: TWindow; Caption: TCaption; X, Y, Width, Height: Integer; State, Focus: Boolean);
Begin
	If State Then
	Begin
		RectangleWnd(Window, X, Y, X + Width - 1, Y + Height - 1, clBlack, SolidLn, 0, 1);
		RectangleWnd(Window, X + 1, Y + 1, X + Width - 2, Y + Height - 2, clGray, SolidLn, 0, 1);
		RectangleWnd(Window, X + 2, Y + 2, X + Width - 3, Y + Height - 3, clGray, SolidLn, 0, 1);
		BarWnd(Window, X + 2, Y + 2, X + Width - 3, Y + Height - 3, clSilver);
		WriteStringWnd(Window, Caption, X + Width Shr 1 + 1, Y + Height Shr 1 - 7, clBlack, CenterText)
	End
	Else
	Begin
		DrawBorder(Window, X, Y, Width, Height, clSilver, State);
		WriteStringWnd(Window, Caption, X + Width Shr 1, Y + Height Shr 1 - 8, clBlack, CenterText)
	End;
	If Focus Then
		RectangleWnd(Window, X + 4, Y + 4, X + Width - 5, Y + Height - 5, clBlack, UserBitLn, $5555, 1)
End;

Procedure DrawEdit(Var Window: TWindow; Source, User: PChar; X, Y, Width, Height: Integer; TopRow, LineCount, SourceLen,
	UserLen: Word);
Var
	I, J, P, Len, LineLen, RowCount: Word;
	SourceStr, UserStr: String[82];
	LineStr: Array[0..82] Of Char;
Begin
	RowCount := (Height - 4) Div 36;
	DrawBorder(Window, X, Y, Width, Height, clTransparent, True);
	DrawVScroll(Window, X + Width - 18, Y + 2, Height - 4, TopRow, RowCount, LineCount - RowCount);
	LineLen := (Width - 24) Div 8;
	If LineLen > 80 Then LineLen := 80;
	P := 0;
	For I := 0 To TopRow + RowCount - 1 Do
	Begin
		StrLCopy(LineStr, Source + P, 82);
		SourceStr := CopyChinese(StrPas(LineStr), LineLen);
		Len := Length(SourceStr);
		StrLCopy(LineStr, User + P, 82);
		UserStr := Copy(StrPas(LineStr), 1, Len);
		Inc(P, Len);
		If P > SourceLen Then
			SourceStr := Copy(SourceStr, 1, Len - P + SourceLen);
		If P > UserLen Then
			UserStr := Copy(UserStr, 1, Len - P + UserLen);
		If Len >= 2 Then
		Begin
			If Copy(SourceStr, Len - 1, 2) = CrLf Then
				SourceStr := Copy(SourceStr, 1, Len - 2);
			If Copy(UserStr, Len - 1, 2) = CrLf Then
				UserStr := Copy(UserStr, 1, Len - 2)
		End;
		If I >= TopRow Then
		Begin
			BarWnd(Window, X + 2, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 2, X + Width - 19,
				Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 19, clTeal);
			WriteStringWnd(Window, SourceStr, X + 4, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 3, clWhite, LeftText);
			BarWnd(Window, X + 2, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 20, X + Width - 19,
				Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 37, clWhite);
			J := 1;
			While J <= Length(UserStr) Do
			Begin
				If J < Length(UserStr) Then
				Begin
					If (UserStr[J] In [#161..#247]) And (UserStr[J + 1] In [#161..#254]) Then
					Begin
						If (SourceStr[J] <> UserStr[J]) Or (SourceStr[J + 1] <> UserStr[J + 1]) Then
						Begin
							If J = 1 Then
								BarWnd(Window, X + 2, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 20, X + 19,
									Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 37, clMaroon);
							If J = LineLen - 1 Then
								BarWnd(Window, (J - 1) Shl 3 + X + 4, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 20,
									(J - 1) Shl 3 + X + 21, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 37, clMaroon);
							If (J > 1) And (J < LineLen - 1) Then
								BarWnd(Window, (J - 1) Shl 3 + X + 4, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 20, (J - 1) Shl 3 + X + 19,
									Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 37, clMaroon);
							WriteStringWnd(Window, UserStr[J] + UserStr[J + 1], (J - 1) Shl 3 + X + 4,
								Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 21, clWhite, LeftText)
						End
						Else
						Begin
							WriteStringWnd(Window, UserStr[J] + UserStr[J + 1], (J - 1) Shl 3 + X + 4,
								Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 21, clBlack, LeftText)
						End;
						Inc(J)
					End
					Else
					Begin
						If SourceStr[J] <> UserStr[J] Then
						Begin
							If J = 1 Then
								BarWnd(Window, X + 2, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 20, X + 11,
									Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 37, clMaroon);
							If J = LineLen Then
								BarWnd(Window, (J - 1) Shl 3 + X + 4, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 20,
									(J - 1) Shl 3 + X + 13, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 37, clMaroon);
							If (J > 1) And (J < LineLen) Then
								BarWnd(Window, (J - 1) Shl 3 + X + 4, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 20, (J - 1) Shl 3 + X + 11,
									Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 37, clMaroon);
							WriteStringWnd(Window, UserStr[J], (J - 1) Shl 3 + X + 4, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 21, clWhite,
								LeftText)
						End
						Else
						Begin
							WriteStringWnd(Window, UserStr[J], (J - 1) Shl 3 + X + 4, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 21, clBlack,
								LeftText)
						End
					End
				End
				Else
				Begin
					If SourceStr[J] <> UserStr[J] Then
					Begin
						If J = 1 Then
							BarWnd(Window, X + 2, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 20, X + 11,
								Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 37, clMaroon);
						If J = LineLen Then
							BarWnd(Window, (J - 1) Shl 3 + X + 4, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 20, (J - 1) Shl 3 + X + 13,
								Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 37, clMaroon);
						If (J > 1) And (J < LineLen) Then
							BarWnd(Window, (J - 1) Shl 3 + X + 4, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 20, (J - 1) Shl 3 + X + 11,
								Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 37, clMaroon);
						WriteStringWnd(Window, UserStr[J], (J - 1) Shl 3 + X + 4, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 21, clWhite,
							LeftText)
					End
					Else
					Begin
						WriteStringWnd(Window, UserStr[J], (J - 1) Shl 3 + X + 4, Y + (I - TopRow) Shl 5 + (I - TopRow) Shl 2 + 21, clBlack,
							LeftText)
					End
				End;
				Inc(J)
			End
		End
	End;
	If (Height - 4) Mod 36 <> 0 Then
		BarWnd(Window, X + 2, Y + RowCount Shl 5 + RowCount Shl 2 + 2, X + Width - 19, Y + Height - 3, clSilver)
End;

Procedure DrawMemo(Var Window: TWindow; S: PChar; X, Y, Width, Height: Integer; TopRow, LineCount, StrLength: Word);
Var
	I, P, T, LineLen, RowCount: Word;
	Str: String[82];
	LineStr: Array[0..82] Of Char;
Begin
	RowCount := (Height - 4) Div 18;
	DrawBorder(Window, X, Y, Width, Height, clTransparent, True);
	DrawVScroll(Window, X + Width - 18, Y + 2, Height - 4, TopRow, RowCount, LineCount - RowCount);
	LineLen := (Width - 24) Div 8;
	If LineLen > 80 Then LineLen := 80;
	P := 0;
	For I := 0 To TopRow + RowCount - 1 Do
	Begin
		StrLCopy(LineStr, S + P, 82);
		Str := CopyChinese(StrPas(LineStr), LineLen);
		T := Length(Str);
		Inc(P, T);
		If P > StrLength Then
			Str := Copy(Str, 1, T - P + StrLength);
		If T >= 2 Then
			If Copy(Str, T - 1, 2) = CrLf Then
				Str := Copy(Str, 1, T - 2);
		If I >= TopRow Then
		Begin
			T := (I - TopRow) Shl 1;
			Inc(T, Y + 2 + T Shl 3);
			BarWnd(Window, X + 2, T, X + Width - 19, T + 17, clWhite);
			WriteStringWnd(Window, Str, X + 4, T + 1, clBlack, LeftText)
		End
	End;
	If (Height - 4) Mod 18 <> 0 Then
		BarWnd(Window, X + 2, Y + RowCount Shl 4 + RowCount + RowCount + 2, X + Width - 19, Y + Height - 3, clWhite)
End;

Procedure DrawVScroll(Var Window: TWindow; X, Y, Height, Value, Len, Max: Integer);
Var
	I, Top, Bottom: Integer;
Begin
	DrawBorder(Window, X, Y, 16, 16, clSilver, False);
	DrawBorder(Window, X, Y + Height - 16, 16, 16, clSilver, False);
	PutPixelWnd(Window, X + 7, Y + 6, clGray);
	LineWnd(Window, X + 6, Y + 7, X + 8, Y + 7, clGray, SolidLn, 0, 1);
	LineWnd(Window, X + 5, Y + 8, X + 9, Y + 8, clGray, SolidLn, 0, 1);
	LineWnd(Window, X + 4, Y + 9, X + 10, Y + 9, clGray, SolidLn, 0, 1);
	LineWnd(Window, X + 5, Y + 10, X + 11, Y + 10, clWhite, SolidLn, 0, 1);
	LineWnd(Window, X + 4, Y + Height - 10, X + 10, Y + Height - 10, clGray, SolidLn, 0, 1);
	LineWnd(Window, X + 5, Y + Height - 9, X + 9, Y + Height - 9, clGray, SolidLn, 0, 1);
	LineWnd(Window, X + 6, Y + Height - 8, X + 8, Y + Height - 8, clGray, SolidLn, 0, 1);
	PutPixelWnd(Window, X + 7, Y + Height - 7, clGray);
	LineWnd(Window, X + 8, Y + Height - 7, X + 10, Y + Height - 9, clWhite, SolidLn, 0, 1);
	LineWnd(Window, X + 8, Y + Height - 6, X + 11, Y + Height - 9, clWhite, SolidLn, 0, 1);
	If Max <= 0 Then
	Begin
		For I := 16 To Height - 17 Do
		Begin
			If I And $0001 = 0 Then
			Begin
				LineWnd(Window, X, Y + I, X + 15, Y + I, clWhite, UserBitLn, $5555, 1);
				LineWnd(Window, X, Y + I, X + 15, Y + I, clSilver, UserBitLn, $AAAA, 1)
			End
			Else
			Begin
				LineWnd(Window, X, Y + I, X + 15, Y + I, clSilver, UserBitLn, $5555, 1);
				LineWnd(Window, X, Y + I, X + 15, Y + I, clWhite, UserBitLn, $AAAA, 1)
			End
		End
	End
	Else
	Begin
		Top := (Height - 32) * Value Div (Max + Len) + 16;
		Bottom := (Height - 32) * (Value + Len) Div (Max + Len) + 15;
		DrawBorder(Window, X, Y + Top, 16, Bottom - Top + 1, clSilver, False);
		For I := 16 To Top - 1 Do
		Begin
			If I And $0001 = 0 Then
			Begin
				LineWnd(Window, X, Y + I, X + 15, Y + I, clWhite, UserBitLn, $5555, 1);
				LineWnd(Window, X, Y + I, X + 15, Y + I, clSilver, UserBitLn, $AAAA, 1)
			End
			Else
			Begin
				LineWnd(Window, X, Y + I, X + 15, Y + I, clSilver, UserBitLn, $5555, 1);
				LineWnd(Window, X, Y + I, X + 15, Y + I, clWhite, UserBitLn, $AAAA, 1)
			End
		End;
		For I := Bottom + 1 To Height - 17 Do
		Begin
			If I And $0001 = 0 Then
			Begin
				LineWnd(Window, X, Y + I, X + 15, Y + I, clWhite, UserBitLn, $5555, 1);
				LineWnd(Window, X, Y + I, X + 15, Y + I, clSilver, UserBitLn, $AAAA, 1)
			End
			Else
			Begin
				LineWnd(Window, X, Y + I, X + 15, Y + I, clSilver, UserBitLn, $5555, 1);
				LineWnd(Window, X, Y + I, X + 15, Y + I, clWhite, UserBitLn, $AAAA, 1)
			End
		End
	End
End;

Procedure DrawWindow(Var Window: TWindow; Width: Word);
Var
	Left, Top, Right, Bottom, ClientLeft, ClientTop, ClientRight, ClientBottom: Integer;
Begin
	Left := Window.Left + (Window.Width - Width) Shr 1;
	Top := Window.Top;
	Right := Left + Width - 1;
	Bottom := Top + Window.Height - 1;
	ClientLeft := Left + Window.ClientLeft - Window.Left;
	ClientTop := Window.ClientTop;
	ClientRight := Width + ClientLeft - Window.Width + Window.ClientWidth - 1;
	ClientBottom := ClientTop + Window.ClientHeight - 1;
	If Window.Color <> clTransparent Then
		BarWnd(DesktopWindow, ClientLeft, ClientTop, ClientRight, ClientBottom, Window.Color);
	If Window.Style And wsCaption <> 0 Then
	Begin
		If Window.Style And wsFlat <> 0 Then
		Begin
			BarWnd(DesktopWindow, ClientLeft, ClientTop - 22, ClientRight, ClientTop - 3, clPurple);
			LineWnd(DesktopWindow, ClientLeft, ClientTop - 2, ClientRight, ClientTop - 2, Window.Color, SolidLn, 0, 1);
			LineWnd(DesktopWindow, ClientLeft, ClientTop - 1, ClientRight, ClientTop - 1, Window.Color, SolidLn, 0, 1);
			If (Width = Window.Width) And (Window.Caption <> '') Then
			Begin
				WriteStringWnd(DesktopWindow, Window.Caption, ClientLeft + 2, ClientTop - 20, clWhite, LeftText);
				WriteStringWnd(DesktopWindow, Window.Caption, ClientLeft + 3, ClientTop - 20, clWhite, LeftText)
			End
		End
		Else
		Begin
			BarWnd(DesktopWindow, ClientLeft, ClientTop - 22, ClientRight, ClientTop - 3, clNavy);
			LineWnd(DesktopWindow, ClientLeft, ClientTop - 2, ClientRight, ClientTop - 2, clSilver, SolidLn, 0, 1);
			LineWnd(DesktopWindow, ClientLeft, ClientTop - 1, ClientRight, ClientTop - 1, clSilver, SolidLn, 0, 1);
			If (Width = Window.Width) And (Window.Caption <> '') Then
			Begin
				WriteStringWnd(DesktopWindow, Window.Caption, ClientLeft + 2, ClientTop - 20, clWhite, LeftText);
				WriteStringWnd(DesktopWindow, Window.Caption, ClientLeft + 3, ClientTop - 20, clWhite, LeftText)
			End
		End
	End;
	If Window.Style And wsBorder <> 0 Then
	Begin
		If Window.Style And wsFlat <> 0 Then
		Begin
			RectangleWnd(DesktopWindow, Left, Top, Right, Bottom, clPurple, SolidLn, 0, 1);
			RectangleWnd(DesktopWindow, Left + 3, Top + 3, Right - 3, Bottom - 3, clPurple, SolidLn, 0, 1);
			RectangleWnd(DesktopWindow, Left + 1, Top + 1, Right - 1, Bottom - 1, clFuchsia, SolidLn, 0, 1);
			RectangleWnd(DesktopWindow, Left + 2, Top + 2, Right - 2, Bottom - 2, clFuchsia, SolidLn, 0, 1)
		End
		Else
		Begin
			LineWnd(DesktopWindow, Left, Top, Right - 1, Top, clSilver, SolidLn, 0, 1);
			LineWnd(DesktopWindow, Left, Top, Left, Bottom - 1, clSilver, SolidLn, 0, 1);
			LineWnd(DesktopWindow, Left, Bottom, Right, Bottom, clBlack, SolidLn, 0, 1);
			LineWnd(DesktopWindow, Right, Top, Right, Bottom, clBlack, SolidLn, 0, 1);
			LineWnd(DesktopWindow, Left + 1, Top + 1, Right - 2, Top + 1, clWhite, SolidLn, 0, 1);
			LineWnd(DesktopWindow, Left + 1, Top + 1, Left + 1, Bottom - 2, clWhite, SolidLn, 0, 1);
			LineWnd(DesktopWindow, Left + 1, Bottom - 1, Right - 1, Bottom - 1, clGray, SolidLn, 0, 1);
			LineWnd(DesktopWindow, Right - 1, Top + 1, Right - 1, Bottom - 1, clGray, SolidLn, 0, 1);
			RectangleWnd(DesktopWindow, Left + 2, Top + 2, Right - 2, Bottom - 2, clSilver, SolidLn, 0, 1);
			RectangleWnd(DesktopWindow, Left + 3, Top + 3, Right - 3, Bottom - 3, clSilver, SolidLn, 0, 1)
		End
	End
End;

Procedure CreateWindow(Var Window: TWindow);
Var
	I: Integer;
Begin
	Window.Picture := GetPictureWnd(DesktopWindow, Window.Left, Window.Top, Window.Width, Window.Height);
	If Window.Picture = Nil Then Exit;
	If Window.Color = clDefault Then
	Begin
		If Window.Style And wsBorder = 0 Then
		Begin
			Window.Color := clTransparent
		End
		Else
		Begin
			If Window.Style And wsFlat <> 0 Then Window.Color := clWhite Else Window.Color := clSilver
		End
	End;
	If Window.Style And wsBorder = 0 Then
	Begin
		Window.ClientLeft := Window.Left;
		Window.ClientTop := Window.Top;
		Window.ClientWidth := Window.Width;
		Window.ClientHeight := Window.Height;
	End
	Else
	Begin
		Window.ClientLeft := Window.Left + 4;
		Window.ClientTop := Window.Top + 4;
		Window.ClientWidth := Window.Width - 8;
		Window.ClientHeight := Window.Height - 8;
	End;
	If Window.Style And wsCaption <> 0 Then
	Begin
		Inc(Window.ClientTop, 22);
		Dec(Window.ClientHeight, 22)
	End;
	If Window.Style And wsSize <> 0 Then
	Begin
		I := 16;
		While I < Window.Width Do
		Begin
			DrawWindow(Window, I);
			MicrosecondDelay(10000);
			Inc(I, 12)
		End
	End;
	DrawWindow(Window, Window.Width)
End;

Procedure DestroyWindow(Var Window: TWindow);
Var
	I, Index, Left, Top, Height: Integer;
	Size: Word;
	TopPicture, BottomPicture: Pointer;
	Buffer: Pointer;
	Regs: Registers;
Begin
	If Window.Picture = Nil Then Exit;
	If Window.Style And wsSize <> 0 Then
		For I := 0 To Window.Height Div 10 Do
		Begin
			TopPicture := CopyPicture(Window.Picture, I + I Shl 2, I + I Shl 2 + 4);
			BottomPicture := CopyPicture(Window.Picture, Window.Height - I - I Shl 2 - 5, Window.Height - I - I Shl 2 - 1);
			PutPictureWnd(DesktopWindow, TopPicture, Window.Left, Window.Top + I + I Shl 2);
			PutPictureWnd(DesktopWindow, BottomPicture, Window.Left, Window.Top + Window.Height - I - I Shl 2 - 5);
			FreeMemory(TopPicture);
			FreeMemory(BottomPicture);
			MicrosecondDelay(10000)
		End;
	PutPictureWnd(DesktopWindow, Window.Picture, Window.Left, Window.Top);
	FreeMemory(Window.Picture);
	Window.Picture := Nil
End;

Function GetPictureWnd(Var Window: TWindow; X, Y, Width, Height: Integer): Pointer;
Begin
	GetPictureWnd := GetPicture(Window.ClientLeft + X, Window.ClientTop + Y, Width, Height)
End;

Procedure PutPictureWnd(Var Window: TWindow; Picture: Pointer; X, Y: Integer);
Begin
	PutPicture(Picture, Window.ClientLeft + X, Window.ClientTop + Y)
End;

Procedure WriteStringWnd(Var Window: TWindow; S: String; X, Y: Integer; Color: Shortint; Justify: Word);
Begin
	Case Justify Of
		LeftText: WriteString(S, Window.ClientLeft + X, Window.ClientTop + Y, Color);
		CenterText: WriteString(S, Window.ClientLeft + X - Length(S) Shl 2, Window.ClientTop + Y, Color);
		RightText: WriteString(S, Window.ClientLeft + X - Length(S) Shl 3, Window.ClientTop + Y, Color)
	End
End;

Procedure PutPixelWnd(Var Window: TWindow; X, Y: Integer; Color: Shortint);
Begin
	PutPixel(Window.ClientLeft + X, Window.ClientTop + Y, Color)
End;

Function GetPixelWnd(Var Window: TWindow; X, Y: Integer): Shortint;
Begin
	GetPixelWnd := GetPixel(Window.ClientLeft + X, Window.ClientTop + Y)
End;

Procedure LineWnd(Var Window: TWindow; X1, Y1, X2, Y2: Integer; Color: Shortint; Style, Pattern, Thickness: Word);
Begin
	SetColor(Color);
	SetLineStyle(Style, Pattern, Thickness);
	Line(Window.ClientLeft + X1, Window.ClientTop + Y1, Window.ClientLeft + X2, Window.ClientTop + Y2)
End;

Procedure RectangleWnd(Var Window: TWindow; X1, Y1, X2, Y2: Integer; Color: Shortint; Style, Pattern, Thickness: Word);
Begin
	SetColor(Color);
	SetLineStyle(Style, Pattern, Thickness);
	Rectangle(Window.ClientLeft + X1, Window.ClientTop + Y1, Window.ClientLeft + X2, Window.ClientTop + Y2)
End;

Procedure BarWnd(Var Window: TWindow; X1, Y1, X2, Y2: Integer; Color: Shortint);
Begin
	SetFillStyle(SolidFill, Color);
	Bar(Window.ClientLeft + X1, Window.ClientTop + Y1, Window.ClientLeft + X2, Window.ClientTop + Y2)
End;

Function CopyChinese(S: String; Count: Integer): String;
Var
	I: Integer;
	Flag: Boolean;
Begin
	I := Pos(CrLf, S);
	If (I > 0) And (I <= Count + 1) Then
	Begin
		CopyChinese := Copy(S, 1, I - 1) + CrLf
	End
	Else
	Begin
		If Count >= Length(S) Then
		Begin
			CopyChinese := S
		End
		Else
		Begin
			Flag := False;
			For I := 1 To Count Do
				If Flag Then Flag := False Else Flag := (S[I] > #160) And (S[I] < #248);
			If Flag Then CopyChinese := Copy(S, 1, Count - 1) Else CopyChinese := Copy(S, 1, Count)
		End
	End
End;

Procedure WriteCharacter(Code, X, Y: Word; Color: Shortint); Assembler;
Var
	T, Rotate: Byte;
Asm
	MOV AX, Code
	TEST AH, AH
	JZ @@1
	SUB AX, 0A1A1H
	SHL AX, 1
	XOR DX, DX
	XCHG DL, AL
	XCHG AH, AL
	MOV BX, AX
	SHL AX, 5
	MOV CX, AX
	ADD AX, CX
	ADD AX, CX
	SUB AX, BX
	SUB AX, BX
	ADD AX, DX
	ADD AX, HZKFont.Word[2]
	JMP @@2
@@1:
	ADD AX, ASCFont.Word[2]
@@2:
	MOV DI, AX
	XOR SI, SI
	MOV BX, Y
	MOV DX, BX
	SHL BX, 6
	SHL DX, 4
	ADD BX, DX
	MOV DX, X
	SHR DX, 3
	ADD BX, DX
	MOV DX, X
	AND DL, 07H
	MOV Rotate, DL
	MOV CL, DL
	NEG CL
	AND CL, 07H
	MOV AL, 1
	SHL AL, CL
	DEC AL
	MOV T, AL
	AND Code, 0FF00H
	JZ @@17
	TEST DL, DL
	JZ @@12
@@3:
	MOV DX, 03C4H
	MOV AX, 0102H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0004H
	OUT DX, AX
	MOV ES, DI
	MOV AX, ES:[SI]
	MOV CL, Rotate
	ROR AX, CL
	MOV CH, AL
	MOV CL, T
	AND AL, CL
	NOT CL
	AND CH, CL
	MOV DX, 0A000H
	MOV ES, DX
	MOV DX, AX
	NOT DX
	AND DX, ES:[BX]
	TEST Color, 01H
	JZ @@4
	OR DX, AX
@@4:
	MOV ES:[BX], DX
	MOV DH, CH
	NOT DH
	AND DH, ES:[BX + 2]
	TEST Color, 01H
	JZ @@5
	OR DH, CH
@@5:
	MOV ES:[BX + 2], DH
	MOV DX, 03C4H
	MOV AX, 0202H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0104H
	OUT DX, AX
	MOV ES, DI
	MOV AX, ES:[SI]
	MOV CL, Rotate
	ROR AX, CL
	MOV CH, AL
	MOV CL, T
	AND AL, CL
	NOT CL
	AND CH, CL
	MOV DX, 0A000H
	MOV ES, DX
	MOV DX, AX
	NOT DX
	AND DX, ES:[BX]
	TEST Color, 02H
	JZ @@6
	OR DX, AX
@@6:
	MOV ES:[BX], DX
	MOV DH, CH
	NOT DH
	AND DH, ES:[BX + 2]
	TEST Color, 02H
	JZ @@7
	OR DH, CH
@@7:
	MOV ES:[BX + 2], DH
	MOV DX, 03C4H
	MOV AX, 0402H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0204H
	OUT DX, AX
	MOV ES, DI
	MOV AX, ES:[SI]
	MOV CL, Rotate
	ROR AX, CL
	MOV CH, AL
	MOV CL, T
	AND AL, CL
	NOT CL
	AND CH, CL
	MOV DX, 0A000H
	MOV ES, DX
	MOV DX, AX
	NOT DX
	AND DX, ES:[BX]
	TEST Color, 04H
	JZ @@8
	OR DX, AX
@@8:
	MOV ES:[BX], DX
	MOV DH, CH
	NOT DH
	AND DH, ES:[BX + 2]
	TEST Color, 04H
	JZ @@9
	OR DH, CH
@@9:
	MOV ES:[BX + 2], DH
	MOV DX, 03C4H
	MOV AX, 0802H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0304H
	OUT DX, AX
	MOV ES, DI
	MOV AX, ES:[SI]
	MOV CL, Rotate
	ROR AX, CL
	MOV CH, AL
	MOV CL, T
	AND AL, CL
	NOT CL
	AND CH, CL
	MOV DX, 0A000H
	MOV ES, DX
	MOV DX, AX
	NOT DX
	AND DX, ES:[BX]
	TEST Color, 08H
	JZ @@10
	OR DX, AX
@@10:
	MOV ES:[BX], DX
	MOV DH, CH
	NOT DH
	AND DH, ES:[BX + 2]
	TEST Color, 08H
	JZ @@11
	OR DH, CH
@@11:
	MOV ES:[BX + 2], DH
	ADD BX, 80
	ADD SI, 0002H
	CMP SI, 0020H
	JNZ @@3
	JMP @@22
@@12:
	MOV CL, Color
	MOV DX, 03C4H
	MOV AX, 0102H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0004H
	OUT DX, AX
	MOV ES, DI
	MOV AX, ES:[SI]
	MOV DX, 0A000H
	MOV ES, DX
	MOV DX, AX
	NOT DX
	AND DX, ES:[BX]
	TEST CL, 01H
	JZ @@13
	OR DX, AX
@@13:
	MOV ES:[BX], DX
	MOV DX, 03C4H
	MOV AX, 0202H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0104H
	OUT DX, AX
	MOV ES, DI
	MOV AX, ES:[SI]
	MOV DX, 0A000H
	MOV ES, DX
	MOV DX, AX
	NOT DX
	AND DX, ES:[BX]
	TEST CL, 02H
	JZ @@14
	OR DX, AX
@@14:
	MOV ES:[BX], DX
	MOV DX, 03C4H
	MOV AX, 0402H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0204H
	OUT DX, AX
	MOV ES, DI
	MOV AX, ES:[SI]
	MOV DX, 0A000H
	MOV ES, DX
	MOV DX, AX
	NOT DX
	AND DX, ES:[BX]
	TEST CL, 04H
	JZ @@15
	OR DX, AX
@@15:
	MOV ES:[BX], DX
	MOV DX, 03C4H
	MOV AX, 0802H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0304H
	OUT DX, AX
	MOV ES, DI
	MOV AX, ES:[SI]
	MOV DX, 0A000H
	MOV ES, DX
	MOV DX, AX
	NOT DX
	AND DX, ES:[BX]
	TEST CL, 08H
	JZ @@16
	OR DX, AX
@@16:
	MOV ES:[BX], DX
	ADD BX, 80
	ADD SI, 0002H
	CMP SI, 0020H
	JNZ @@12
	JMP @@22
@@17:
	MOV DX, 03C4H
	MOV AX, 0102H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0004H
	OUT DX, AX
	MOV ES, DI
	MOV AL, ES:[SI]
	XOR AH, AH
	MOV CL, Rotate
	ROR AX, CL
	MOV DX, 0A000H
	MOV ES, DX
	MOV DX, AX
	NOT DX
	AND DX, ES:[BX]
	TEST Color, 01H
	JZ @@18
	OR DX, AX
@@18:
	MOV ES:[BX], DX
	MOV DX, 03C4H
	MOV AX, 0202H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0104H
	OUT DX, AX
	MOV ES, DI
	MOV AL, ES:[SI]
	XOR AH, AH
	MOV CL, Rotate
	ROR AX, CL
	MOV DX, 0A000H
	MOV ES, DX
	MOV DX, AX
	NOT DX
	AND DX, ES:[BX]
	TEST Color, 02H
	JZ @@19
	OR DX, AX
@@19:
	MOV ES:[BX], DX
	MOV DX, 03C4H
	MOV AX, 0402H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0204H
	OUT DX, AX
	MOV ES, DI
	MOV AL, ES:[SI]
	XOR AH, AH
	MOV CL, Rotate
	ROR AX, CL
	MOV DX, 0A000H
	MOV ES, DX
	MOV DX, AX
	NOT DX
	AND DX, ES:[BX]
	TEST Color, 04H
	JZ @@20
	OR DX, AX
@@20:
	MOV ES:[BX], DX
	MOV DX, 03C4H
	MOV AX, 0802H
	OUT DX, AX
	MOV DX, 03CEH
	MOV AX, 0304H
	OUT DX, AX
	MOV ES, DI
	MOV AL, ES:[SI]
	XOR AH, AH
	MOV CL, Rotate
	ROR AX, CL
	MOV DX, 0A000H
	MOV ES, DX
	MOV DX, AX
	NOT DX
	AND DX, ES:[BX]
	TEST Color, 08H
	JZ @@21
	OR DX, AX
@@21:
	MOV ES:[BX], DX
	ADD BX, 80
	ADD SI, 0001H
	CMP SI, 0010H
	JNZ @@17
@@22:
	MOV DX, 03C4H
	MOV AX, 0F02H
	OUT DX, AX
End;

Procedure WriteString(S: String; X, Y: Word; Color: Shortint);
Var
	Flag: Boolean;
	StrLen: Byte;
	I, Code: Word;
Begin
	StrLen := Length(S);
	I := 1;
	While I <= StrLen Do
	Begin
		Flag := I = StrLen;
		If Not Flag Then
			Flag := Not ((S[I] In [#161..#247]) And (S[I + 1] In [#161..#254]));
		If Flag Then Code := Ord(S[I]) Else Code := Ord(S[I]) Shl 8 + Ord(S[I + 1]);
		WriteCharacter(Code, X + (I - 1) Shl 3, Y, Color);
		If Not Flag Then Inc(I);
		Inc(I)
	End
End;

Procedure SetStatusLine(Prompt: String);
Begin
	StatusPrompt := Prompt;
	If ChineseEnabled Then Exit;
	BarWnd(StatusWindow, 0, 0, StatusWindow.ClientWidth - 1, StatusWindow.ClientHeight - 1, StatusWindow.Color);
	If StatusPrompt = #0 Then
	Begin
		Prompt := '★            版本 6.1    版权所有(C)    王纯    ' + UpdateDate + '  ★';
		ShowPicture(StatusWindow, '标题', (StatusWindow.ClientWidth - Length(Prompt) * 8) Div 2 + 32, 0);
		WriteStringWnd(StatusWindow, Prompt, StatusWindow.ClientWidth Div 2, 0, clBlack, CenterText)
	End
	Else
	Begin
		WriteStringWnd(StatusWindow, StatusPrompt, 0, 0, clBlack, LeftText)
	End
End;

Function StrToInt(S: String): Longint;
Var
	I: Longint;
	Code: Integer;
Begin
	StrToInt := 0;
	Val(S, I, Code);
	If Code = 0 Then StrToInt := I
End;

Function IntToStr(N: Longint): String;
Var
	S: String[11];
Begin
	Str(N, S);
	IntToStr := S
End;

Function RealToStr(N: Real; Width, Decimals: Word): String;
Var
	S: String;
Begin
	Str(N:Width:Decimals, S);
	RealToStr := S
End;

Function PtrToStr(P: Pointer): String;
Const
	HexStr: String[16] = '0123456789ABCDEF';
Var
	S: String[9];
Begin
	S[0] := #09;
	S[1] := HexStr[Seg(P^) And $F000 Shr $0C + 1];
	S[2] := HexStr[Seg(P^) And $0F00 Shr $08 + 1];
	S[3] := HexStr[Seg(P^) And $00F0 Shr $04 + 1];
	S[4] := HexStr[Seg(P^) And $000F + 1];
	S[5] := #58;
	S[6] := HexStr[Ofs(P^) And $F000 Shr $0C + 1];
	S[7] := HexStr[Ofs(P^) And $0F00 Shr $08 + 1];
	S[8] := HexStr[Ofs(P^) And $00F0 Shr $04 + 1];
	S[9] := HexStr[Ofs(P^) And $000F + 1];
	PtrToStr := S
End;

Function GetKeyboardFlag: Integer;
Var
	KeyboardFlag: Integer;
	Regs: Registers;
Begin
	KeyboardFlag := 0;
	Regs.AH := $02;
	Intr($16, Regs);
	If Regs.AL And $03 <> 0 Then KeyboardFlag := KeyboardFlag Or kfShift;
	If Regs.AL And $04 <> 0 Then KeyboardFlag := KeyboardFlag Or kfCtrl;
	If Regs.AL And $08 <> 0 Then KeyboardFlag := KeyboardFlag Or kfAlt;
	GetKeyboardFlag := KeyboardFlag
End;

Procedure ClearKeyboardBuffer; Assembler;
Asm
	MOV AX, 0C00H
	INT 21H
End;

Procedure DrawPromptLine(Var Prompt: TPrompt);
Var
	I: Integer;
	S: String[50];
Begin
	BarWnd(StatusWindow, 0, 0, StatusWindow.ClientWidth - 1, StatusWindow.ClientHeight - 1, StatusWindow.Color);
	If WideEnabled Then
		WriteStringWnd(StatusWindow, '全角', 0, 0, clBlack, LeftText)
	Else
		WriteStringWnd(StatusWindow, '半角', 0, 0, clBlack, LeftText);
	Case InputMethod Of
		imCode: WriteStringWnd(StatusWindow, '【区位】', 40, 0, clNavy, LeftText);
		imSpell: WriteStringWnd(StatusWindow, '【拼音】', 40, 0, clNavy, LeftText);
		imEnglish: WriteStringWnd(StatusWindow, '【英文】', 40, 0, clNavy, LeftText)
	End;
	If InputMethod = imEnglish Then
	Begin
		ShowPicture(StatusWindow, '标题', 136, 0);
		WriteStringWnd(StatusWindow, '版本 6.1    版权所有(C)  王纯    ' + UpdateDate, 216, 0, clBlack, LeftText)
	End
	Else
	Begin
		WriteStringWnd(StatusWindow, Prompt.Code, 112, 0, clBlack, LeftText);
		S[0] := #0;
		For I := 1 To 10 Do
		Begin
			If Prompt.ChooseWord[Prompt.Page * 10 + I, 0] = #0 Then Break;
			S[I * 5 - 4] := Chr(I Mod 10 + 48);
			S[I * 5 - 3] := ':';
			S[I * 5 - 2] := Prompt.ChooseWord[Prompt.Page * 10 + I, 0];
			S[I * 5 - 1] := Prompt.ChooseWord[Prompt.Page * 10 + I, 1];
			S[I * 5] := ' ';
			Inc(S[0], 5)
		End;
		WriteStringWnd(StatusWindow, S, 200, 0, clBlack, LeftText)
	End
End;

Procedure EnableChinese(State: Boolean);
Var
	Prompt: TPrompt;
Begin
	If ChineseEnabled <> State Then
	Begin
		ChineseEnabled := State;
		If ChineseEnabled Then
		Begin
			WideEnabled := False;
			InputMethod := imEnglish;
			SingleQuotationFlag := True;
			DoubleQuotationFlag := True;
			InputMethodData := LoadResource(DataFile, '拼音输入法', rtText);
			FillChar(Prompt, SizeOf(Prompt), 0);
			DrawPromptLine(Prompt)
		End
		Else
		Begin
			FreeMemory(InputMethodData);
			SetStatusLine(StatusPrompt)
		End
	End
End;

Function ChineseReadKey(Var Window: TWindow; Position, Scroll: Integer): Char;
Var
	Caret, ChooseFlag, InputFlag: Boolean;
	InKey: Char;
	N: Integer;
	Hour, Minute, Second, Sec100, LastDraw: Word;
	Str1, Str2: PChar;
	Regs: Registers;
	Character: TWideChar;
	Prompt: TPrompt;
	T: Array[0..8] Of Char;
Begin
	GetTime(Hour, Minute, Second, Sec100);
	LastDraw := (Sec100 + 50) Mod 100;
	Caret := False;
	If ChineseEnabled Then
	Begin
		ChooseFlag := False;
		FillChar(Character, SizeOf(Character), 0);
		FillChar(Prompt, SizeOf(Prompt), 0);
		While True Do
		Begin
			SetWriteMode(XorPut);
			Repeat
				GetTime(Hour, Minute, Second, Sec100);
				If (Sec100 + 100 - LastDraw) Mod 100 >= 50 Then
				Begin
					Caret := Not Caret;
					LineWnd(Window, (Position - Scroll) Shl 3 + 11, Window.ClientHeight - 28, (Position - Scroll) Shl 3 + 11,
						Window.ClientHeight - 13, clWhite, SolidLn, 0, 1);
					LineWnd(Window, (Position - Scroll) Shl 3 + 12, Window.ClientHeight - 28, (Position - Scroll) Shl 3 + 12,
						Window.ClientHeight - 13, clWhite, SolidLn, 0, 1);
					LastDraw := Sec100
				End
			Until KeyPressed;
			SetWriteMode(NormalPut);
			InKey := ReadKey;
			If ChooseFlag And (InKey = ' ') Then InKey := '1';
			Case InKey Of
				#0:
				Begin
					InKey := ReadKey;
					Case InKey Of
						#102: WideEnabled := Not WideEnabled;
						#109:
						Begin
							InputMethod := imEnglish;
							ChooseFlag := False;
							Prompt.Code := '';
							FillChar(Prompt.ChooseWord, SizeOf(Prompt.ChooseWord), 0)
						End;
						#104:
						Begin
							InputMethod := imCode;
							ChooseFlag := False;
							Prompt.Code := '';
							FillChar(Prompt.ChooseWord, SizeOf(Prompt.ChooseWord), 0)
						End;
						#105:
						Begin
							InputMethod := imSpell;
							ChooseFlag := False;
							Prompt.Code := '';
							FillChar(Prompt.ChooseWord, SizeOf(Prompt.ChooseWord), 0)
						End;
						Else
						Begin
							Character[0] := #0;
							Character[1] := InKey;
							Break
						End
					End
				End;
				#8:
				Begin
					FillChar(Prompt.ChooseWord, SizeOf(Prompt.ChooseWord), 0);
					If (InputMethod = imEnglish) Or (Prompt.Code = '') Then
					Begin
						Character[0] := InKey;
						Break
					End
					Else
					Begin
						Dec(Prompt.Code[0])
					End;
					If InputMethod = imSpell Then
					Begin
						InputFlag := False;
						ChooseFlag := Prompt.Code <> '';
						Prompt.Page := 0;
						Prompt.MaxPage := 0;
						If ChooseFlag Then
						Begin
							StrPCopy(T, CrLf + Prompt.Code + ' ');
							Str1 := StrPos(InputMethodData, T);
							If Assigned(Str1) Then
							Begin
								Inc(Str1, 9);
								InputFlag := True
							End
						End;
						If InputFlag Then
						Begin
							Str2 := StrPos(Str1, CrLf);
							FillChar(Prompt.ChooseWord, SizeOf(Prompt.ChooseWord), 0);
							StrLCopy(@Prompt.ChooseWord, Str1, Str2 - Str1);
							Prompt.MaxPage := (StrLen(@Prompt.ChooseWord) - 1) Div 20;
						End
					End
				End;
				'0'..'9', '-' ,'=':
				Begin
					If InputMethod <> imCode Then
					Begin
						If ChooseFlag Then
						Begin
							If InKey = ' ' Then InKey := '1';
							Case InKey Of
								'-': If Prompt.Page > 0 Then Dec(Prompt.Page);
								'=': If Prompt.Page < Prompt.MaxPage Then Inc(Prompt.Page);
								'0'..'9':
								Begin
									N := Ord(InKey) - 48;
									If N = 0 Then N := 10;
									Inc(N, Prompt.Page * 10);
									If Prompt.ChooseWord[N, 1] <> #0 Then
									Begin
										Character := Prompt.ChooseWord[N];
										ChooseFlag := False;
										Prompt.Code := '';
										Break
									End
								End
							End
						End
						Else
						Begin
							Character[0] := InKey;
							Break
						End
					End
					Else
					Begin
						InputFlag := True;
						If (Prompt.Code = '') And (InKey = '9') Then InputFlag := False;
						If Length(Prompt.Code) = 1 Then
						Begin
							If (Prompt.Code[1] = '0') And (InKey = '0') Then InputFlag := False;
							If (Prompt.Code[1] = '8') And (InKey > '7') Then InputFlag := False
						End;
						If Length(Prompt.Code) = 1 Then
						Begin
							If (Prompt.Code[1] = '0') And (InKey = '0') Then InputFlag := False;
							If (Prompt.Code[1] = '9') And (InKey > '4') Then InputFlag := False
						End;
						If InputFlag Then
						Begin
							Prompt.Code := Prompt.Code + ' ';
							Prompt.Code[Length(Prompt.Code)] := InKey;
							If Length(Prompt.Code) = 4 Then
							Begin
								Character[0] := Chr(StrToInt(Copy(Prompt.Code, 1, 2)) + 160);
								Character[1] := Chr(StrToInt(Copy(Prompt.Code, 3, 2)) + 160);
								DrawPromptLine(Prompt);
								Prompt.Code := '';
								Break
							End
						End
					End
				End;
				'a'..'z':
				Begin
					If (InputMethod = imSpell) And (Length(Prompt.Code) < 6) Then
					Begin
						InputFlag := False;
						Inc(Prompt.Code[0]);
						Prompt.Code[Length(Prompt.Code)] := InKey;
						StrPCopy(T, CrLf + Prompt.Code + ' ');
						Str1 := StrPos(InputMethodData, T);
						If Assigned(Str1) Then
						Begin
							Inc(Str1, 9);
							InputFlag := True
						End
						Else
						Begin
							StrPCopy(T, CrLf + Prompt.Code);
							Str1 := StrPos(InputMethodData, T);
							If Assigned(Str1) Then
							Begin
								FillChar(Prompt.ChooseWord, SizeOf(Prompt.ChooseWord), 0);
								Prompt.Page := 0;
								Prompt.MaxPage := 0;
								ChooseFlag := True
							End
							Else
							Begin
								Dec(Prompt.Code[0])
							End
						End;
						If InputFlag Then
						Begin
							ChooseFlag := True;
							Str2 := StrPos(Str1, CrLf);
							FillChar(Prompt.ChooseWord, SizeOf(Prompt.ChooseWord), 0);
							StrLCopy(@Prompt.ChooseWord, Str1, Str2 - Str1);
							Prompt.Page := 0;
							Prompt.MaxPage := (StrLen(@Prompt.ChooseWord) - 1) Div 20
						End
					End
					Else
					Begin
						If InputMethod <> imSpell Then
						Begin
							Character[0] := InKey;
							Break
						End
					End
				End;
				Else
				Begin
					Character[0] := InKey;
					Break
				End
			End;
			DrawPromptLine(Prompt)
		End;
		If WideEnabled And (Character[0] In [#32..#126]) Then
		Begin
			Case Character[0] Of
				' ': Character := #161#161;
				'\': Character := #161#162;
				'.': Character := #161#163;
				'''':
				Begin
					If SingleQuotationFlag Then Character := #161#174 Else Character := #161#175;
					SingleQuotationFlag := Not SingleQuotationFlag
				End;
				'"':
				Begin
					If DoubleQuotationFlag Then Character := #161#176 Else Character := #161#177;
					DoubleQuotationFlag := Not DoubleQuotationFlag
				End;
				Else
				Begin
					Character[1] := Chr(128 + Ord(Character[0]));
					Character[0] := #163
				End
			End
		End;
		ChineseReadKey := Character[0];
		If Character[1] <> #0 Then
		Begin
			Regs.AH := $05;
			Regs.CX := Ord(Character[1]);
			Intr($16, Regs)
		End
	End
	Else
	Begin
		SetWriteMode(XorPut);
		Repeat
			GetTime(Hour, Minute, Second, Sec100);
			If (Sec100 + 100 - LastDraw) Mod 100 >= 50 Then
			Begin
				Caret := Not Caret;
				LineWnd(Window, (Position - Scroll) Shl 3 + 11, Window.ClientHeight - 28, (Position - Scroll) Shl 3 + 11,
					Window.ClientHeight - 13, clWhite, SolidLn, 0, 1);
				LineWnd(Window, (Position - Scroll) Shl 3 + 12, Window.ClientHeight - 28, (Position - Scroll) Shl 3 + 12,
					Window.ClientHeight - 13, clWhite, SolidLn, 0, 1);
				LastDraw := Sec100
			End
		Until KeyPressed;
		ChineseReadKey := ReadKey
	End;
	SetWriteMode(XorPut);
	If Caret Then
	Begin
		LineWnd(Window, (Position - Scroll) Shl 3 + 11, Window.ClientHeight - 28, (Position - Scroll) Shl 3 + 11,
			Window.ClientHeight - 13, clWhite, SolidLn, 0, 1);
		LineWnd(Window, (Position - Scroll) Shl 3 + 12, Window.ClientHeight - 28, (Position - Scroll) Shl 3 + 12,
			Window.ClientHeight - 13, clWhite, SolidLn, 0, 1)
	End;
	SetWriteMode(NormalPut)
End;

Function MessageBox(Prompt: String; Caption: TCaption; Flag, Style, DefBtn: Word): Integer;
Var
	BtnCount, CurBtn: Byte;
	I, LineCount, Len, MaxLen: Integer;
	InKey: Char;
	Window: TWindow;
	S, T: String;
	BtnCaption: Array[1..3] Of TCaption;
Begin
	Case Flag And $000F Of
		mbOK:
		Begin
			BtnCount := 1;
			BtnCaption[1] := '确定'
		End;
		mbOKCancel:
		Begin
			BtnCount := 2;
			BtnCaption[1] := '确定';
			BtnCaption[2] := '取消'
		End;
		mbAbortRetryIgnore:
		Begin
			BtnCount := 3;
			BtnCaption[1] := '放弃';
			BtnCaption[2] := '重试';
			BtnCaption[3] := '忽略'
		End;
		mbYesNoCancel:
		Begin
			BtnCount := 3;
			BtnCaption[1] := '是';
			BtnCaption[2] := '否';
			BtnCaption[3] := '取消'
		End;
		mbYesNo:
		Begin
			BtnCount := 2;
			BtnCaption[1] := '是';
			BtnCaption[2] := '否'
		End;
		mbRetryCancel:
		Begin
			BtnCount := 2;
			BtnCaption[1] := '重试';
			BtnCaption[2] := '取消'
		End;
	End;
	CurBtn := DefBtn;
	If CurBtn >= BtnCount Then CurBtn := 0;
	Window.Width := 24;
	Window.Height := 66;
	If Style And wsCaption <> 0 Then Inc(Window.Height, 22);
	S := Prompt;
	MaxLen := 0;
	LineCount := 0;
	While S <> '' Do
	Begin
		T := CopyChinese(S, 36);
		Len := Length(T);
		Delete(S, 1, Len);
		If Len >= 2 Then
			If Copy(T, Len - 1, 2) = CrLf Then T := Copy(T, 1, Len - 2);
		If Len > MaxLen Then MaxLen := Len;
		Inc(Window.Height, 18);
		Inc(LineCount)
	End;
	Inc(Window.Width, MaxLen Shl 3);
	If Flag And $0070 <> 0 Then
	Begin
		Inc(Window.Width, 40);
		If LineCount <= 1 Then
			Inc(Window.Height, 18)
	End;
	If Window.Width < Length(Caption) Shl 3 + 12 Then
		Window.Width := Length(Caption) Shl 3 + 12;
	Case BtnCount Of
		1: If Window.Width < 104 Then Window.Width := 104;
		2: If Window.Width < 184 Then Window.Width := 184;
		3: If Window.Width < 264 Then Window.Width := 264
	End;
	Window.Left := (640 - Window.Width) Shr 1;
	Window.Top := (480 - Window.Height) Shr 1;
	Window.Caption := Caption;
	Window.Style := Style Or wsBorder;
	Window.Color := clDefault;
	CreateWindow(Window);
	Case Flag And $0070 Of
		mbIconHand:
		Begin
			If Window.Style And wsFlat <> 0 Then
				ShowPicture(Window, '消息框白底手形图标', 8, 8)
			Else
				ShowPicture(Window, '消息框灰底手形图标', 8, 8)
		End;
		mbIconQuestion:
		Begin
			If Window.Style And wsFlat <> 0 Then
				ShowPicture(Window, '消息框白底问号图标', 8, 8)
			Else
				ShowPicture(Window, '消息框灰底问号图标', 8, 8)
		End;
		mbIconExclamation:
		Begin
			If Window.Style And wsFlat <> 0 Then
				ShowPicture(Window, '消息框白底叹号图标', 8, 8)
			Else
				ShowPicture(Window, '消息框灰底叹号图标', 8, 8)
		End;
		mbIconAsterisk:
		Begin
			If Window.Style And wsFlat <> 0 Then
				ShowPicture(Window, '消息框白底星形图标', 8, 8)
			Else
				ShowPicture(Window, '消息框灰底星形图标', 8, 8)
		End
	End;
	S := Prompt;
	For I := 0 To LineCount - 1 Do
	Begin
		T := CopyChinese(S, 36);
		Len := Length(T);
		Delete(S, 1, Len);
		If Len >= 2 Then
			If Copy(T, Len - 1, 2) = CrLf Then T := Copy(T, 1, Len - 2);
		If Flag And $0070 <> 0 Then
			WriteStringWnd(Window, T, 48, I Shl 4 + I + I + 8, clBlack, LeftText)
		Else
			WriteStringWnd(Window, T, 8, I Shl 4 + I + I + 8, clBlack, LeftText)
	End;
	Case BtnCount Of
		1:
		Begin
			DrawButton(Window, BtnCaption[1], Window.ClientWidth Shr 1 - 32, Window.ClientHeight - 34, 64, 26, False, True);
			While True Do
			Begin
				ClearKeyboardBuffer;
				Case ReadKey Of
					#0: ReadKey;
					#13, #27: If GetKeyboardFlag = kfNone Then Break;
					#32:
					If GetKeyboardFlag = kfNone Then
					Begin
						DrawButton(Window, BtnCaption[1], Window.ClientWidth Shr 1 - 32, Window.ClientHeight - 34, 64, 26, True, True);
						Repeat
							ClearKeyboardBuffer
						Until Port[$60] = $B9;
						DrawButton(Window, BtnCaption[1], Window.ClientWidth Shr 1 - 32, Window.ClientHeight - 34, 64, 26, False, True);
						Break
					End
				End
			End;
			MessageBox := idOK
		End;
		2:
		Begin
			DrawButton(Window, BtnCaption[1], Window.ClientWidth Shr 1 - 72, Window.ClientHeight - 34, 64, 26, False, CurBtn = 0);
			DrawButton(Window, BtnCaption[2], Window.ClientWidth Shr 1 + 8, Window.ClientHeight - 34, 64, 26, False, CurBtn = 1);
			While True Do
			Begin
				ClearKeyboardBuffer;
				Case ReadKey Of
					#0:
					Case ReadKey Of
						#15:
						If GetKeyboardFlag = kfShift Then
						Begin
							CurBtn := (CurBtn + 1) And 1;
							DrawButton(Window, BtnCaption[1], Window.ClientWidth Shr 1 - 72, Window.ClientHeight - 34, 64, 26, False, CurBtn = 0);
							DrawButton(Window, BtnCaption[2], Window.ClientWidth Shr 1 + 8, Window.ClientHeight - 34, 64, 26, False, CurBtn = 1)
						End;
						#75:
						If (CurBtn = 1) And (GetKeyboardFlag = kfNone) Then
						Begin
							CurBtn := 0;
							DrawButton(Window, BtnCaption[1], Window.ClientWidth Shr 1 - 72, Window.ClientHeight - 34, 64, 26, False, CurBtn = 0);
							DrawButton(Window, BtnCaption[2], Window.ClientWidth Shr 1 + 8, Window.ClientHeight - 34, 64, 26, False, CurBtn = 1)
						End;
						#77:
						If (CurBtn = 0) And (GetKeyboardFlag = kfNone) Then
						Begin
							CurBtn := 1;
							DrawButton(Window, BtnCaption[1], Window.ClientWidth Shr 1 - 72, Window.ClientHeight - 34, 64, 26, False, CurBtn = 0);
							DrawButton(Window, BtnCaption[2], Window.ClientWidth Shr 1 + 8, Window.ClientHeight - 34, 64, 26, False, CurBtn = 1)
						End
					End;
					#9:
					If GetKeyboardFlag = kfNone Then
					Begin
						CurBtn := (CurBtn + 1) And 1;
						DrawButton(Window, BtnCaption[1], Window.ClientWidth Shr 1 - 72, Window.ClientHeight - 34, 64, 26, False, CurBtn = 0);
						DrawButton(Window, BtnCaption[2], Window.ClientWidth Shr 1 + 8, Window.ClientHeight - 34, 64, 26, False, CurBtn = 1)
					End;
					#13: If GetKeyboardFlag = kfNone Then Break;
					#27:
					If GetKeyboardFlag = kfNone Then
					Begin
						CurBtn := 1;
						Break
					End;
					#32:
					If GetKeyboardFlag = kfNone Then
					Begin
						DrawButton(Window, BtnCaption[CurBtn + 1], Window.ClientWidth Shr 1 - 72 + CurBtn Shl 6 + CurBtn Shl 4,
							Window.ClientHeight - 34, 64, 26, True, True);
						Repeat
							ClearKeyboardBuffer
						Until Port[$60] = $B9;
						DrawButton(Window, BtnCaption[CurBtn + 1], Window.ClientWidth Shr 1 - 72 + CurBtn Shl 6 + CurBtn Shl 4,
							Window.ClientHeight - 34, 64, 26, False, True);
						Break
					End
				End
			End;
			Case Flag And $000F Of
				mbOKCancel: If CurBtn = 0 Then MessageBox := idOK Else MessageBox := idCancel;
				mbYesNo: If CurBtn = 0 Then MessageBox := idYes Else MessageBox := idNo;
				mbRetryCancel: If CurBtn = 0 Then MessageBox := idRetry Else MessageBox := idCancel
			End
		End;
		3:
		Begin
			DrawButton(Window, BtnCaption[1], Window.ClientWidth Shr 1 - 112, Window.ClientHeight - 34, 64, 26, False, CurBtn = 0);
			DrawButton(Window, BtnCaption[2], Window.ClientWidth Shr 1 - 32, Window.ClientHeight - 34, 64, 26, False, CurBtn = 1);
			DrawButton(Window, BtnCaption[3], Window.ClientWidth Shr 1 + 48, Window.ClientHeight - 34, 64, 26, False, CurBtn = 2);
			While True Do
			Begin
				ClearKeyboardBuffer;
				Case ReadKey Of
					#0:
					Case ReadKey Of
						#15:
						If GetKeyboardFlag = kfShift Then
						Begin
							CurBtn := (CurBtn + 2) Mod 3;
							DrawButton(Window, BtnCaption[1], Window.ClientWidth Shr 1 - 112, Window.ClientHeight - 34, 64, 26, False, CurBtn = 0);
							DrawButton(Window, BtnCaption[2], Window.ClientWidth Shr 1 - 32, Window.ClientHeight - 34, 64, 26, False, CurBtn = 1);
							DrawButton(Window, BtnCaption[3], Window.ClientWidth Shr 1 + 48, Window.ClientHeight - 34, 64, 26, False, CurBtn = 2)
						End;
						#75:
						If (CurBtn <> 0) And (GetKeyboardFlag = kfNone) Then
						Begin
							Dec(CurBtn);
							DrawButton(Window, BtnCaption[1], Window.ClientWidth Shr 1 - 112, Window.ClientHeight - 34, 64, 26, False, CurBtn = 0);
							DrawButton(Window, BtnCaption[2], Window.ClientWidth Shr 1 - 32, Window.ClientHeight - 34, 64, 26, False, CurBtn = 1);
							DrawButton(Window, BtnCaption[3], Window.ClientWidth Shr 1 + 48, Window.ClientHeight - 34, 64, 26, False, CurBtn = 2)
						End;
						#77:
						If (CurBtn <> 2) And (GetKeyboardFlag = kfNone) Then
						Begin
							Inc(CurBtn);
							DrawButton(Window, BtnCaption[1], Window.ClientWidth Shr 1 - 112, Window.ClientHeight - 34, 64, 26, False, CurBtn = 0);
							DrawButton(Window, BtnCaption[2], Window.ClientWidth Shr 1 - 32, Window.ClientHeight - 34, 64, 26, False, CurBtn = 1);
							DrawButton(Window, BtnCaption[3], Window.ClientWidth Shr 1 + 48, Window.ClientHeight - 34, 64, 26, False, CurBtn = 2)
						End
					End;
					#9:
					If GetKeyboardFlag = kfNone Then
					Begin
						CurBtn := (CurBtn + 1) Mod 3;
						DrawButton(Window, BtnCaption[1], Window.ClientWidth Shr 1 - 112, Window.ClientHeight - 34, 64, 26, False, CurBtn = 0);
						DrawButton(Window, BtnCaption[2], Window.ClientWidth Shr 1 - 32, Window.ClientHeight - 34, 64, 26, False, CurBtn = 1);
						DrawButton(Window, BtnCaption[3], Window.ClientWidth Shr 1 + 48, Window.ClientHeight - 34, 64, 26, False, CurBtn = 2)
					End;
					#13: If GetKeyboardFlag = kfNone Then Break;
					#27:
					If GetKeyboardFlag = kfNone Then
					Begin
						CurBtn := 3;
						Break
					End;
					#32:
					If GetKeyboardFlag = kfNone Then
					Begin
						DrawButton(Window, BtnCaption[CurBtn + 1], Window.ClientWidth Shr 1 - 112 + CurBtn Shl 6 + CurBtn Shl 4,
							Window.ClientHeight - 34, 64, 26, True, True);
						Repeat
							ClearKeyboardBuffer
						Until Port[$60] = $B9;
						DrawButton(Window, BtnCaption[CurBtn + 1], Window.ClientWidth Shr 1 - 112 + CurBtn Shl 6 + CurBtn Shl 4,
							Window.ClientHeight - 34, 64, 26, False, True);
						Break
					End
				End
			End;
			Case Flag And $000F Of
				mbYesNoCancel:
				Case CurBtn Of
					0: MessageBox := idYes;
					1: MessageBox := idNo;
					2, 3: MessageBox := idCancel
				End;
				mbAbortRetryIgnore:
				Case CurBtn Of
					0, 3: MessageBox := idAbort;
					1: MessageBox := idRetry;
					2: MessageBox := idIgnore
				End
			End
		End
	End;
	DestroyWindow(Window)
End;

Function InputBox(Prompt, Default: String; Caption: TCaption; X, Y, Width, Height: Integer; Style, MaxLen: Word;
	CanCancel, ChineseInput: Boolean): String;
Var
	I, Len, PromptLen, Position, Scroll: Integer;
	InKey, NextKey: Char;
	Window: TWindow;
	S, T: String;
Begin
	If MaxLen = 0 Then MaxLen := 255;
	If ChineseInput Then EnableChinese(True);
	Window.Caption := Caption;
	Window.Style := Style Or wsBorder;
	Window.Color := clDefault;
	Window.Left := X;
	Window.Top := Y;
	Window.Width := Width;
	Window.Height := Height;
	CreateWindow(Window);
	PromptLen := (Window.ClientWidth - 16) Shr 3;
	S := Prompt;
	I := 0;
	While S <> '' Do
	Begin
		T := CopyChinese(S, PromptLen);
		Len := Length(T);
		Delete(S, 1, Len);
		If Len >= 2 Then
			If Copy(T, Len - 1, 2) = CrLf Then T := Copy(T, 1, Len - 2);
		WriteStringWnd(Window, T, 8, I Shl 4 + I + I + 8, clBlack, LeftText);
		Inc(I)
	End;
	DrawBorder(Window, 8, Window.ClientHeight - 32, Window.ClientWidth - 16, 24, clWhite, True);
	PromptLen := (Window.ClientWidth - 24) Shr 3;
	Position := 0;
	Scroll := 0;
	S := CopyChinese(Default, MaxLen);
	WriteStringWnd(Window, CopyChinese(S, PromptLen), 12, Window.ClientHeight - 28, clBlack, LeftText);
	While True Do
	Begin
		InKey := ChineseReadKey(Window, Position, Scroll);
		Case InKey Of
			#0:
			Case ReadKey Of
				#71:
				If GetKeyboardFlag = kfNone Then
				Begin
					Position := 0;
					Scroll := 0;
					BarWnd(Window, 10, Window.ClientHeight - 30, Window.ClientWidth - 11, Window.ClientHeight - 11, clWhite);
					WriteStringWnd(Window, CopyChinese(S, PromptLen), 12, Window.ClientHeight - 28, clBlack, LeftText)
				End;
				#75:
				If (Position > 0) And (GetKeyboardFlag = kfNone) Then
				Begin
					If Length(CopyChinese(S, Position - 1)) = Position - 1 Then
						Dec(Position)
					Else
						Dec(Position, 2);
					If Position <= Scroll Then
					Begin
						If PromptLen <= 30 Then
							Dec(Scroll, (PromptLen + 2) Div 3)
						Else
							Dec(Scroll, 10);
						If Scroll < 0 Then Scroll := 0;
						T := S;
						If Scroll <> 0 Then
						Begin
							If Length(CopyChinese(S, Scroll)) < Scroll Then
							Begin
								Delete(T, 1, Scroll + 1);
								Insert(#32, T, 1)
							End
							Else
							Begin
								Delete(T, 1, Scroll)
							End
						End;
						BarWnd(Window, 10, Window.ClientHeight - 30, Window.ClientWidth - 11, Window.ClientHeight - 11, clWhite);
						WriteStringWnd(Window, CopyChinese(T, PromptLen), 12, Window.ClientHeight - 28, clBlack, LeftText)
					End
				End;
				#77:
				If (Position < Length(S)) And (GetKeyboardFlag = kfNone) Then
				Begin
					If Position + 1 = Length(S) Then
					Begin
						Inc(Position)
					End
					Else
					Begin
						If (S[Position + 1] In [#161..#247]) And (S[Position + 2] In [#161..#254]) Then
							Inc(Position, 2)
						Else
							Inc(Position)
					End;
					If Position > PromptLen + Scroll Then
					Begin
						If PromptLen <= 30 Then
							Inc(Scroll, (PromptLen + 2) Div 3)
						Else
							Inc(Scroll, 10);
						T := S;
						If Scroll <> 0 Then
						Begin
							If Length(CopyChinese(S, Scroll)) < Scroll Then
							Begin
								Delete(T, 1, Scroll + 1);
								Insert(#32, T, 1)
							End
							Else
							Begin
								Delete(T, 1, Scroll)
							End
						End;
						BarWnd(Window, 10, Window.ClientHeight - 30, Window.ClientWidth - 11, Window.ClientHeight - 11, clWhite);
						WriteStringWnd(Window, CopyChinese(T, PromptLen), 12, Window.ClientHeight - 28, clBlack, LeftText)
					End
				End;
				#79:
				If GetKeyboardFlag = kfNone Then
				Begin
					Position := Length(S);
					If Length(S) <= PromptLen Then
					Begin
						Scroll := 0
					End
					Else
					Begin
						If PromptLen <= 30 Then
							Scroll := Position - PromptLen + (PromptLen + 2) Div 3 - 1
						Else
							Scroll := Position - PromptLen + 9
					End;
					If Scroll < 0 Then Scroll := 0;
					T := S;
					If Scroll <> 0 Then
					Begin
						If Length(CopyChinese(S, Scroll)) < Scroll Then
						Begin
							Delete(T, 1, Scroll + 1);
							Insert(#32, T, 1)
						End
						Else
						Begin
							Delete(T, 1, Scroll)
						End
					End;
					BarWnd(Window, 10, Window.ClientHeight - 30, Window.ClientWidth - 11, Window.ClientHeight - 11, clWhite);
					WriteStringWnd(Window, CopyChinese(T, PromptLen), 12, Window.ClientHeight - 28, clBlack, LeftText)
				End;
				#83:
				If (Position <> Length(S)) And (GetKeyboardFlag = kfNone) Then
				Begin
					If Position + 1 = Length(S) Then
					Begin
						Delete(S, Position + 1, 1)
					End
					Else
					Begin
						If (S[Position + 1] In [#161..#247]) And (S[Position + 2] In [#161..#254]) Then
							Delete(S, Position + 1, 2)
						Else
							Delete(S, Position + 1, 1)
					End;
					T := S;
					If Scroll <> 0 Then
					Begin
						If Length(CopyChinese(S, Scroll)) < Scroll Then
						Begin
							Delete(T, 1, Scroll + 1);
							Insert(#32, T, 1)
						End
						Else
						Begin
							Delete(T, 1, Scroll)
						End
					End;
					BarWnd(Window, 10, Window.ClientHeight - 30, Window.ClientWidth - 11, Window.ClientHeight - 11, clWhite);
					WriteStringWnd(Window, CopyChinese(T, PromptLen), 12, Window.ClientHeight - 28, clBlack, LeftText)
				End
			End;
			#8:
			If (Position <> 0) And (GetKeyboardFlag = kfNone) Then
			Begin
				If Length(CopyChinese(S, Position - 1)) = Position - 1 Then
				Begin
					Delete(S, Position, 1);
					Dec(Position)
				End
				Else
				Begin
					Delete(S, Position - 1, 2);
					Dec(Position, 2)
				End;
				If Position <= Scroll Then
				Begin
					If PromptLen <= 30 Then
						Dec(Scroll, (PromptLen + 2) Div 3)
					Else
						Dec(Scroll, 10)
				End;
				If Scroll < 0 Then Scroll := 0;
				T := S;
				If Scroll <> 0 Then
				Begin
					If Length(CopyChinese(S, Scroll)) < Scroll Then
					Begin
						Delete(T, 1, Scroll + 1);
						Insert(#32, T, 1)
					End
					Else
					Begin
						Delete(T, 1, Scroll)
					End
				End;
				BarWnd(Window, 10, Window.ClientHeight - 30, Window.ClientWidth - 11, Window.ClientHeight - 11, clWhite);
				WriteStringWnd(Window, CopyChinese(T, PromptLen), 12, Window.ClientHeight - 28, clBlack, LeftText);
			End;
			#13: If GetKeyboardFlag = kfNone Then Break;
			#27:
			If CanCancel And (GetKeyboardFlag = kfNone) Then
			Begin
				S := #0;
				Break
			End;
			#32..#255:
			If (InKey In [#161..#247]) And KeyPressed Then
			Begin
				If Length(S) < MaxLen - 1 Then
				Begin
					Insert(InKey + ReadKey, S, Position + 1);
					Inc(Position, 2);
					If Position > PromptLen + Scroll Then
					Begin
						If PromptLen <= 30 Then
							Inc(Scroll, (PromptLen + 2) Div 3)
						Else
							Inc(Scroll, 10)
					End;
					T := S;
					If Scroll <> 0 Then
					Begin
						If Length(CopyChinese(S, Scroll)) < Scroll Then
						Begin
							Delete(T, 1, Scroll + 1);
							Insert(#32, T, 1)
						End
						Else
						Begin
							Delete(T, 1, Scroll)
						End
					End;
					BarWnd(Window, 10, Window.ClientHeight - 30, Window.ClientWidth - 11, Window.ClientHeight - 11, clWhite);
					WriteStringWnd(Window, CopyChinese(T, PromptLen), 12, Window.ClientHeight - 28, clBlack, LeftText);
				End
				Else
				Begin
					ClearKeyboardBuffer
				End
			End
			Else
			Begin
				If Length(S) < MaxLen Then
				Begin
					Insert(InKey, S, Position + 1);
					Inc(Position);
					If Position > PromptLen + Scroll Then
					Begin
						If PromptLen <= 30 Then
							Inc(Scroll, (PromptLen + 2) Div 3)
						Else
							Inc(Scroll, 10)
					End;
					T := S;
					If Scroll <> 0 Then
					Begin
						If Length(CopyChinese(S, Scroll)) < Scroll Then
						Begin
							Delete(T, 1, Scroll + 1);
							Insert(#32, T, 1)
						End
						Else
						Begin
							Delete(T, 1, Scroll)
						End
					End;
					BarWnd(Window, 10, Window.ClientHeight - 30, Window.ClientWidth - 11, Window.ClientHeight - 11, clWhite);
					WriteStringWnd(Window, CopyChinese(T, PromptLen), 12, Window.ClientHeight - 28, clBlack, LeftText);
				End
			End
		End
	End;
	DestroyWindow(Window);
	If ChineseInput Then EnableChinese(False);
	InputBox := S
End;

Procedure ShowPicture(Var Window: TWindow; ResName: PChar; X, Y: Integer);
Var
	P: Pointer;
Begin
	P := LoadResource(DataFile, ResName, rtPicture);
	PutPictureWnd(Window, P, X, Y);
	FreeMemory(P)
End;

Function ShowMessage(Prompt: String; Flag, DefBtn: Word): Integer;
Begin
	ShowMessage := MessageBox(Prompt, Title, Flag, wsBorder Or wsCaption Or wsSize, DefBtn)
End;

Var
	Regs: Registers;
Begin
	Randomize;
	DirectVideo := False;
	RegisterBGIDriver(@EGAVGADriverProc);
	Regs.AX := $0000;
	Intr($33, Regs);
	MouseEnabled := Regs.AX <> 0;
	ChineseEnabled := False;
	StatusPrompt := '';
	DesktopWindow.Picture := Nil;
	DesktopWindow.Caption := '';
	DesktopWindow.Style := 0;
	DesktopWindow.Color := clBlack;
	DesktopWindow.Left := 0;
	DesktopWindow.Top := 0;
	DesktopWindow.Width := 640;
	DesktopWindow.Height := 480;
	DesktopWindow.ClientLeft := 0;
	DesktopWindow.ClientTop := 0;
	DesktopWindow.ClientWidth := 640;
	DesktopWindow.ClientHeight := 480
End.