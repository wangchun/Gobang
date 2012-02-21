{**********************************************************}
{                                                          }
{        五子棋    版本 5.0    王纯    1998年8月6日        }
{                                                          }
{     Gobang   Version 5.0   Wang Chun   August 6 1998     }
{                                                          }
{**********************************************************}

{主模块}

{关闭运行时间输入输出检查}
{$I-}
Program Gobang;

Uses
	Crt, Dos, Graph, Graphics, XMS, Playing;

{本过程用来重画主菜单的桌面}
Procedure MainMenu;
Var
	X, Y: Integer;
	Value: Byte;
	PictureWidth: Word;
Begin
	PictureWidth := GetPictureWidth(ImageHandle, PicTitle);
	DisplayPicture(ImageHandle, PicTitle, 320 - PictureWidth Div 2, 60, NormalPut)
End;

{本过程用来得到游戏者参数}
Procedure PlayingGame(NumOfPlayer: Byte);
Var
	Y: Integer;
	I, J, Winner: Byte;
	PictureHandle, PictureWidth, PictureHeight: Word;
	InKey: Char;
	First: Boolean;
	NameBlack, NameWhite: String;
	ListCaption: Array[1..4] Of ListStr;
	ListEnabled: Array[1..4] Of Boolean;
Begin
	If NumOfPlayer = 1 Then First := MessageBox('是否要让计算机先行？', '五子棋', 2, 200, 180, 240, 120, True, True, True);
	ShowChineseInputLine;
	If (NumOfPlayer = 2) Or ((NumOfPlayer = 1) And Not First) Then
	Begin
		NameBlack := InputBox('请输入黑方的姓名：', '五子棋', '黑方', 2, 200, 180, 240, 120, 24, True, True, True);
		If NameBlack = #27 Then
		Begin
			HideChineseInputLine;
			Exit
		End
	End
	Else
	Begin
		NameBlack := '计算机'
	End;
	If (NumOfPlayer = 2) Or ((NumOfPlayer = 1) And First) Then
	Begin
		NameWhite := InputBox('请输入白方的姓名：', '五子棋', '白方', 2, 200, 180, 240, 120, 24, True, True, True);
		If NameWhite = #27 Then
		Begin
			HideChineseInputLine;
			Exit
		End
	End
	Else
	Begin
		NameWhite := '计算机'
	End;
	HideChineseInputLine;
	If (NameBlack = '计算机(入门)') Or (NameBlack = '计算机(简单)') Or (NameBlack = '计算机(一般)') Or (NameBlack =
		'计算机(困难)') Then
	Begin
		ClearKeyboardBuffer;
		SetStatusLine('无效的输入');
		MessageBox('黑方所用姓名为保留姓名。', '五子棋', 2, 200, 180, 240, 120, False, True, True);
		Exit
	End;
	If (NameWhite = '计算机(入门)') Or (NameWhite = '计算机(简单)') Or (NameWhite = '计算机(一般)') Or (NameWhite =
		'计算机(困难)') Then
	Begin
		ClearKeyboardBuffer;
		SetStatusLine('无效的输入');
		MessageBox('白方所用姓名为保留姓名。', '五子棋', 2, 200, 180, 240, 120, False, True, True);
		Exit
	End;
	If NameBlack = NameWhite Then
	Begin
		ClearKeyboardBuffer;
		SetStatusLine('无效的输入');
		MessageBox('黑方与白方的姓名不能相同。', '五子棋', 2, 200, 180, 240, 120, False, True, True);
		Exit
	End;
	If NumOfPlayer = 1 Then
	Begin
		ListCaption[1] := '入门';
		ListCaption[2] := '简单';
		ListCaption[3] := '一般';
		ListCaption[4] := '困难';
		For I := 1 To 4 Do ListEnabled[I] := True;
		PictureHandle := CreateWindow('请选择：', 2, 15, 320, 120, 80, 110, True, True);
		I := ListBox(PictureHandle, 4, 3, ListCaption, ListEnabled, True);
		Case I Of
			0:
			Begin
				DestroyWindow(PictureHandle);
				Exit
			End;
			1:
			Begin
				MaxDepth := 1;
				ValueNum := 1
			End;
			2:
			Begin
				MaxDepth := 3;
				ValueNum := 3
			End;
			3:
			Begin
				MaxDepth := 4;
				ValueNum := 4
			End;
			4:
			Begin
				MaxDepth := 5;
				ValueNum := 5
			End
		End;
		DestroyWindow(PictureHandle);
		If NameBlack = '计算机' Then NameBlack := NameBlack + '(' + ListCaption[I] + ')';
		If NameWhite = '计算机' Then NameWhite := NameWhite + '(' + ListCaption[I] + ')'
	End;
	SetStatusLine('请稍候……');
	PictureWidth := GetPictureWidth(ImageHandle, PicTitle);
	PictureHeight := GetPictureHeight(ImageHandle, PicTitle);
	For Y := 6 DownTo 0 Do
	Begin
		DisplayPicture(ImageHandle, PicTitle, 320 - PictureWidth Div 2, Y * 10, NormalPut);
		Delay(25)
	End;
	For Y := 1 To PictureHeight Div 10 - 1 Do
	Begin
		PictureHandle := CopyPicture(ImageHandle, PicTitle, Y * 10, PictureHeight - 1);
		DisplayPicture(PictureHandle, 0, 320 - PictureWidth Div 2, 0, NormalPut);
		DeletePicture(PictureHandle);
		Delay(25)
	End;
	DrawChessboard;
	ClearKeyboardBuffer;
	MessageBox('注意：本游戏不支持禁手。', '五子棋', 2, 200, 180, 240, 120, False, True, True);
	ClearKeyboardBuffer;
	Winner := Play(NumOfPlayer, First);
	If Winner = 0 Then SetStatusLine('平局，按<ESC>键继续……');
	If Winner = 1 Then SetStatusLine(NameBlack + '赢了！按<ESC>键继续……');
	If Winner = 2 Then SetStatusLine(NameWhite + '赢了！按<ESC>键继续……');
	SaveResult(NameBlack, NameWhite, Winner);
	Repeat
		InKey := ReadKey
	Until InKey = #27;
	DisplayHistory
End;

{本过程用来显示游戏封面}
Procedure Title;
Var
	I: Integer;
	PictureWidth, PictureHeight: Word;
	Regs: Registers;
Begin
	Regs.AH := $02;
	Intr($16, Regs);
	If Regs.AL And $2 <> 0 Then Exit;
	Regs.AX := $1201;
	Regs.BL := $36;
	Intr($10, Regs);
	SetStatusLine('请稍候……');
	PictureWidth := GetPictureWidth(ImageHandle, PicWC);
	PictureHeight := GetPictureHeight(ImageHandle, PicWC);
	DisplayPicture(ImageHandle, PicWC, 320 - PictureWidth Div 2, 240 - PictureHeight Div 2, NormalPut);
	SetRGBPalette(PaletteColor(3), 0, 0, 0);
	SetRGBPalette(PaletteColor(11), 0, 0, 0);
	SetRGBPalette(PaletteColor(14), 0, 0, 0);
	Regs.AX := $1200;
	Regs.BL := $36;
	Intr($10, Regs);
	For I := 1 To 20 Do
	Begin
		SetRGBPalette(PaletteColor(3), 48 * I Div 20, 48 * I Div 20, 0);
		SetRGBPalette(PaletteColor(11), 63 * I Div 20, 63 * I Div 20, 0);
		Delay(50)
	End;
	Delay(1000);
	SetRGBPalette(PaletteColor(14), 63, 63, 63);
	Delay(2000);
	For I := 19 DownTo 0 Do
	Begin
		SetRGBPalette(PaletteColor(3), 48 * I Div 20, 48 * I Div 20, 0);
		SetRGBPalette(PaletteColor(11), 63 * I Div 20, 63 * I Div 20, 0);
		SetRGBPalette(PaletteColor(14), 63 * I Div 20, 63 * I Div 20, 63 * I DIv 20);
		Delay(50)
	End;
	SetFillStyle(SolidFill, 0);
	Bar(0, 0, 639, 459);
	SetRGBPalette(PaletteColor(3), 0, 42, 42);
	SetRGBPalette(PaletteColor(11), 21, 63, 63);
	SetRGBPalette(PaletteColor(14), 63, 63, 21)
End;

{本函数用来操作主菜单}
Function UserChoose: Byte;
Var
	InKey: Char;
	Choose: Byte;
	Size, MenuHandle: Word;
	Buffer: Pointer;
Begin
	Size := ImageSize(248, 0, 391, 19);
	GetMem(Buffer, Size);
	If Buffer = Nil Then FatalError('Out Of Memory!');
	MenuHandle := CreateWindow('', 1, 16, 243, 280, 154, 114, False, True);
	WriteChinese('人机对弈', 264, 293, 0, -1, 16);
	WriteChinese('双人对弈', 264, 317, 0, -1, 16);
	WriteChinese('电脑对弈', 264, 341, 0, -1, 16);
	WriteChinese('结束游戏', 264, 365, 0, -1, 16);
	Choose := 1;
	GetImage(248, 291, 391, 310, Buffer^);
	PutImage(248, 291, Buffer^, NotPut);
	SetStatusLine('        ★  五 子 棋    版本 5.0    程序设计：王纯    1998年8月6日  ★        ');
	Repeat
		InKey := ReadKey;
		If InKey = #0 Then
		Begin
			InKey := ReadKey;
			Case InKey Of
				#72:
				Begin
					PutImage(248, 267 + Choose * 24, Buffer^, NormalPut);
					Choose := (Choose + 2) Mod 4 + 1;
					GetImage(248, 267 + Choose * 24, 391, 286 + Choose * 24, Buffer^);
					PutImage(248, 267 + Choose * 24, Buffer^, NotPut)
				End;
				#80:
				Begin
					PutImage(248, 267 + Choose * 24, Buffer^, NormalPut);
					Choose := Choose Mod 4 + 1;
					GetImage(248, 267 + Choose * 24, 391, 286 + Choose * 24, Buffer^);
					PutImage(248, 267 + Choose * 24, Buffer^, NotPut)
				End
			End
		End
	Until InKey = #13;
	DestroyWindow(MenuHandle);
	FreeMem(Buffer, Size);
	UserChoose := Choose
End;

{本过程用来显示游戏简介}
Procedure ComputerPlay;
Var
	I: Integer;
	PictureHandle, PictureWidth, PictureHeight: Word;
	ListCaption: Array[1..4] Of ListStr;
	ListEnabled: Array[1..4] Of Boolean;
Begin
	ListCaption[1] := '入门';
	ListCaption[2] := '简单';
	ListCaption[3] := '一般';
	ListCaption[4] := '困难';
	For I := 1 To 4 Do ListEnabled[I] := True;
	PictureHandle := CreateWindow('请选择：', 2, 15, 320, 120, 80, 110, True, True);
	Case ListBox(PictureHandle, 4, 3, ListCaption, ListEnabled, True) Of
		0:
		Begin
			DestroyWindow(PictureHandle);
			Exit
		End;
		1:
		Begin
			MaxDepth := 1;
			ValueNum := 1
		End;
		2:
		Begin
			MaxDepth := 3;
			ValueNum := 3
		End;
		3:
		Begin
			MaxDepth := 4;
			ValueNum := 4
		End;
		4:
		Begin
			MaxDepth := 5;
			ValueNum := 5
		End
	End;
	DestroyWindow(PictureHandle);
	SetStatusLine('请稍候……');
	PictureWidth := GetPictureWidth(ImageHandle, PicTitle);
	PictureHeight := GetPictureHeight(ImageHandle, PicTitle);
	For I := 6 DownTo 0 Do
	Begin
		DisplayPicture(ImageHandle, PicTitle, 320 - PictureWidth Div 2, I * 10, NormalPut);
		Delay(25)
	End;
	For I := 1 To PictureHeight Div 10 - 1 Do
	Begin
		PictureHandle := CopyPicture(ImageHandle, PicTitle, I * 10, PictureHeight - 1);
		DisplayPicture(PictureHandle, 0, 320 - PictureWidth Div 2, 0, NormalPut);
		DeletePicture(PictureHandle);
		Delay(25)
	End;
	DeletePicture(PictureHandle);
	DrawChessboard;
	Play(0, False);
	SetStatusLine('按任意键继续……');
	ClearKeyboardBuffer;
	ReadKey;
	SetFillStyle(SolidFill, 0);
	Bar(0, 0, 639, 459);
	DisplayHistory
End;

{本过程用来重放刚刚进行过的比赛}
Procedure Review;
Begin
	DrawChessboard;
	Replay;
	SetStatusLine('按任意键继续……');
	ClearKeyboardBuffer;
	ReadKey;
	DisplayHistory
End;

{本过程用来确定是否真要退出游戏}
Function EndGame: Boolean;
Begin
	EndGame := MessageBox('结束游戏吗？', '五子棋', 2, 200, 180, 240, 120, True, True, True)
End;

{游戏初始化}
Procedure Init;
Var
	GraphDriver, GraphMode, ErrorCode: Integer;
Begin
	Randomize;
	If Not TestXMS Then
	Begin
		Writeln('XMS Driver Not Installed.');
		Halt
	End;
	GraphDriver := VGA;
	GraphMode := VGAHi;
	InitGraph(GraphDriver, GraphMode, '');
	ErrorCode := GraphResult;
	If ErrorCode <> grOk Then
	Begin
		Writeln('Graphics Error: ', GraphErrorMsg(ErrorCode));
		Halt;
	End;
	SetRGBPalette(PaletteColor(6), 42, 42, 0);
	ClearDevice
End;

{执行游戏}
Procedure Run;
Var
	CanDone: Boolean;
	Choose: Byte;
	Regs: Registers;
Begin
	Title;
	CanDone := False;
	Choose := 0;
	Repeat
		ClearKeyboardBuffer;
		MainMenu;
		Choose := UserChoose;
		Case Choose Of
			1: PlayingGame(1);
			2: PlayingGame(2);
			3:
			Begin
				Regs.AH := $02;
				Intr($16, Regs);
				If Regs.AL And $2 <> 0 Then Review Else ComputerPlay
			End;
			4: CanDone := EndGame
		End
	Until CanDone;
	CanDone := True
End;

{游戏结束}
Procedure Done;
Begin
	DeletePicture(ImageHandle);
	GraphicsDone;
	FreeAllXMS;
	CloseGraph;
	Writeln('See You Next Time!')
End;

Begin
	Init;
	Run;
	Done
End.