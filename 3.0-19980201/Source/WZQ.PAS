Program ChessFive;

Uses Crt, Graph, ChessLib, Chinese, Playing;

Var
	IsMouse: Boolean;
	WhiteInput, BlackInput: Byte;
	ChessChinese: TChinese;

Procedure Initialize;
Var
	GraphDriver, GraphMode, ErrorCode: Integer;
Begin
	Randomize;
	GraphDriver := VGA;
	GraphMode := VGAHi;
	InitGraph (GraphDriver, GraphMode, '');
	ErrorCode := GraphResult;
	If ErrorCode <> grOk Then
	Begin
		Writeln ('Graphics error: ', GraphErrorMsg (ErrorCode));
		Halt;
	End;
	BlackInput := 0;
	WhiteInput := 1;
	ChessChinese.FontDirectory := '';
	ClearDevice
End;

Function Title: Byte;
Var
	Select, Value: Byte;
	X, Y: Integer;
	KeyCode: Word;
Begin
	SetFillStyle (SolidFill, Black);
	Bar (0, 0, 639, 459);
	IsMouse := CheckMouse;
	If IsMouse Then	SetMouseCursorImage (0);
	SetStateLine ('正在初始化主菜单，请稍候……', Cyan);
	SetRGBPalette (PaletteColor (Cyan), 0, 42, 42);
	SetRGBPalette (PaletteColor (Magenta), 0, 0, 0);
	SetRGBPalette (PaletteColor (LightGreen), 0, 0, 0);
	SetRGBPalette (PaletteColor (LightCyan), 0, 0, 0);
	SetRGBPalette (PaletteColor (LightRed), 0, 0, 0);
	SetRGBPalette (PaletteColor (LightMagenta), 0, 0, 0);
	SetRGBPalette (PaletteColor (Yellow), 0, 0, 0);
	SetRGBPalette (PaletteColor (White), 0, 0, 0);
	ChessChinese.FontType := ChineseFont;
	ChessChinese.FontWidth := 80;
	ChessChinese.FontHeight := 80;
	ChessChinese.BackColor := Transparent;
	ChessChinese.ForeColor := Magenta;
	ChessChinese.WriteChineseXY (204, 100, '五子棋');
	ChessChinese.WriteChineseXY (203, 99, '五子棋');
	ChessChinese.WriteChineseXY (202, 98, '五子棋');
	ChessChinese.WriteChineseXY (201, 97, '五子棋');
	ChessChinese.ForeColor := LightMagenta;
	ChessChinese.WriteChineseXY (200, 96, '五子棋');
	SetColor (Yellow);
	SetLineStyle (SolidLn, 0, ThickWidth);
	Line (200, 192, 440, 192);
	For Value := 0 To 63 Do
	Begin
		SetRGBPalette (PaletteColor (Magenta), Value * 42 Div 63, 0, Value * 42 Div 63);
		SetRGBPalette (PaletteColor (LightMagenta), Value, Value * 21 Div 63, Value);
		SetRGBPalette (PaletteColor (Yellow), Value, Value, Value * 21 Div 63);
		Delay (20)
	End;
	ChessChinese.ForeColor := LightRed;
	ChessChinese.FontWidth := 24;
	ChessChinese.FontHeight := 24;
	ChessChinese.WriteChineseXY (272, 216, '版本 3.0');
	ChessChinese.FontWidth := NormalSize;
	ChessChinese.FontHeight := NormalSize;
	ChessChinese.ForeColor := White;
	ChessChinese.WriteChineseXY (296, 272, '人机对弈');
	ChessChinese.WriteChineseXY (296, 292, '双人对弈');
	ChessChinese.WriteChineseXY (296, 312, '输入选择');
	SetColor (LightGreen);
	Rectangle (518, 412, 639, 459);
	SetLineStyle (SolidLn, 0, 2);
	Line (518, 436, 639, 436);
	ChessChinese.ForeColor := LightCyan;
	ChessChinese.FontWidth := NormalSize;
	ChessChinese.FontHeight := NormalSize;
	ChessChinese.WriteChineseXY (523, 417, '程序设计：王纯');
	ChessChinese.WriteChineseXY (527, 440, '1998年2月1日');
	Delay (120);
	SetRGBPalette (PaletteColor (LightGreen), Value * 21 Div 63, Value, Value * 21 Div 63);
	SetRGBPalette (PaletteColor (LightCyan), Value * 21 Div 63, Value, Value);
	SetRGBPalette (PaletteColor (LightRed), Value, Value * 21 Div 63, Value * 21 Div 63);
	SetRGBPalette (PaletteColor (White), Value, Value, Value);
	Delay (600);
	ChessChinese.ForeColor := Yellow;
	ChessChinese.WriteChineseXY (272, 272, '√');
	Select := 0;
	If IsMouse Then
	Begin
		SetStateLine ('按<ESC>键或鼠标右键退出', Cyan);
		SetMouseCursor (True)
	End
	Else
	Begin
		SetStateLine ('按<ESC>键退出', Cyan)
	End;
	ClearKeyboardBuffer;
	Repeat
		Repeat
			KeyCode := ReadKeyboard;
			If IsMouse Then
			Begin
				If IsMouseDown (LeftButton) Then
				Begin
					X := GetMousePosition Mod $10000;
					Y := GetMousePosition Div $10000;
					If (X >= 270) And (X < 360) And (Y >= 270) And (Y < 330) Then
					Begin
						Select := (Y - 270) Div 20;
						If X < 290 Then SetMouseCursor (False);
						ChessChinese.ForeColor := Black;
						ChessChinese.WriteChineseXY (272, 272, '√');
						ChessChinese.WriteChineseXY (272, 292, '√');
						ChessChinese.WriteChineseXY (272, 312, '√');
						ChessChinese.ForeColor := Yellow;
						ChessChinese.WriteChineseXY (272, 272 + Select * 20, '√');
						SetMouseCursor (True);
						Repeat
							X := GetMousePosition Mod $10000;
							Y := GetMousePosition Div $10000;
							If (X >= 270) And (X < 360) And (Y >= 270) And (Y < 330) Then
								If Select <> (Y - 270) Div 20 Then
								Begin
									Select := (Y - 270) Div 20;
									If X < 290 Then SetMouseCursor (False);
									ChessChinese.ForeColor := Black;
									ChessChinese.WriteChineseXY (272, 272, '√');
									ChessChinese.WriteChineseXY (272, 292, '√');
									ChessChinese.WriteChineseXY (272, 312, '√');
									ChessChinese.ForeColor := Yellow;
									ChessChinese.WriteChineseXY (272, 272 + Select * 20, '√');
									SetMouseCursor (True);
								End
						Until IsMouseUp (LeftButton);
						X := GetMousePosition Mod $10000;
						Y := GetMousePosition Div $10000;
						If (X >= 270) And (X < 360) And (Y >= 270) And (Y < 330) Then
						Begin
							Title := Select + 1;
							SetMouseCursor (False);
							Exit
						End
					End
				End;
				If IsMouseDown (RightButton) Then
				Begin
					Repeat
					Until IsMouseUp (RightButton);
					SetMouseCursor (False);
					Title := 0;
					Exit
				End
			End
		Until KeyCode <> 0;
		ClearKeyboardBuffer;
		If KeyCode = KeyESC Then
		Begin
			If IsMouse Then SetMouseCursor (False);
			Title := 0;
			Exit
		End;
		If (KeyCode = KeyUpArrow) Or (KeyCode = KeyDownArrow) Then
		Begin
			If (KeyCode = KeyUpArrow) Then Select := (Select + 2) Mod 3;
			If (KeyCode = KeyDownArrow) Then Select := (Select + 1) Mod 3;
			If IsMouse Then
			Begin
				X := GetMousePosition Mod $10000;
				Y := GetMousePosition Div $10000;
				If (X >= 250) And (X < 290) And (Y >= 250) And (Y < 330) Then SetMouseCursor (False);
			End;
			ChessChinese.ForeColor := Black;
			ChessChinese.WriteChineseXY (272, 272, '√');
			ChessChinese.WriteChineseXY (272, 292, '√');
			ChessChinese.WriteChineseXY (272, 312, '√');
			ChessChinese.ForeColor := Yellow;
			ChessChinese.WriteChineseXY (272, 272 + Select * 20, '√');
			If IsMouse Then SetMouseCursor (True);
		End
	Until (KeyCode = KeyEnter) Or (KeyCode = KeySpace);
	If IsMouse Then SetMouseCursor (False);
	Title := Select + 1;
End;

Procedure PlayingGame (NumOfPlayer: Byte);
Var
	I, J, Winner: Byte;
	InKey: Char;
	First: Boolean;
	NameBlack, NameWhite: String;
Begin
	If NumOfPlayer = 1 Then First := GetFirst (IsMouse);
	SetColor (Black);
	SetLineStyle (SolidLn, 0, NormWidth);
	For I := 0 To 7 Do
	Begin
		For J := 0 To 79 Do Line (J * 8 + I, 0, J * 8 + I, 459);
		Delay (50)
	End;
	If (NumOfPlayer = 2) Or ((NumOfPlayer = 1) And Not First) Then
	Begin
		SetStateLine ('请输入黑方的姓名：', Cyan);
		NameBlack := GetName
	End
	Else
	Begin
		NameBlack := 'Computer'
	End;
	If (NumOfPlayer = 2) Or ((NumOfPlayer = 1) And First) Then
	Begin
		SetStateLine ('请输入白方的姓名：', Cyan);
		NameWhite := GetName
	End
	Else
	Begin
		NameWhite := 'Computer'
	End;
	If NameBlack = NameWhite Then
	Begin
		ClearKeyboardBuffer;
		SetStateLine ('黑方与白方的姓名不能相同。', Cyan);
		Exit
	End;
	DrawChessboard;
	ClearKeyboardBuffer;
	If IsMouse Then SetMouseCursor (True);
	Winner := Play (NumOfPlayer, BlackInput, WhiteInput, First, IsMouse);
	If IsMouse Then SetMouseCursor (False);
	If Winner = 0 Then SetStateLine ('平局，按<ESC>键继续……', Cyan);
	If Winner = 1 Then SetStateLine ('黑方赢了！按<ESC>键继续……', Cyan);
	If Winner = 2 Then SetStateLine ('白方赢了！按<ESC>键继续……', Cyan);
	If IsMouse Then SetMouseCursor (True);
	SaveResult (NameBlack, NameWhite, Winner);
	Repeat
		InKey := ReadKey
	Until InKey = #27;
	If IsMouse Then SetMouseCursor (False);
	DisplayHistory;
	ClearKeyboardBuffer;
	Repeat
	Until KeyPressed;
End;

Function GetEnvironmentButton (X, Y: Integer): Byte;
Begin
	GetEnvironmentButton := 0;
	If (X >= 120) And (X <= 200) Then
	Begin
		If (Y >= 120) And (Y <= 160) Then GetEnvironmentButton := 1;
		If (Y >= 200) And (Y <= 240) Then GetEnvironmentButton := 2;
		If (Y >= 280) And (Y <= 320) Then GetEnvironmentButton := 3;
	End;
	If (X >= 440) And (X <= 520) Then
	Begin
		If (Y >= 120) And (Y <= 160) Then GetEnvironmentButton := 4;
		If (Y >= 200) And (Y <= 240) Then GetEnvironmentButton := 5;
		If (Y >= 280) And (Y <= 320) Then GetEnvironmentButton := 6;
	End
End;

Procedure EnvironmentSetting;
Var
	SelectBlack, SelectWhite, DownButton, Column: Byte;
	X, Y: Integer;
	KeyCode: Word;
Begin
	SetFillStyle (SolidFill, DarkGray);
	Bar (0, 0, 639, 459);
	ChessChinese.ForeColor := Yellow;
	ChessChinese.BackColor := Transparent;
	ChessChinese.FontWidth := NormalSize;
	ChessChinese.FontHeight := NormalSize;
	ChessChinese.WriteChineseXY (136, 80, '黑  方');
	ChessChinese.WriteChineseXY (456, 80, '白  方');
	DrawButton (120, 120, 200, 160, '字母键', BlackInput = 0);
	DrawButton (120, 200, 200, 240, '方向键', BlackInput = 1);
	DrawButton (120, 280, 200, 320, '鼠标器', BlackInput = 2);
	DrawButton (440, 120, 520, 160, '字母键', WhiteInput = 0);
	DrawButton (440, 200, 520, 240, '方向键', WhiteInput = 1);
	DrawButton (440, 280, 520, 320, '鼠标器', WhiteInput = 2);
	SelectBlack := BlackInput;
	SelectWhite := WhiteInput;
	Column := 0;
	ChessChinese.ForeColor := White;
	ChessChinese.WriteChineseXY (216, 120, '<W>上  <A>左  <S>下  <D>右');
	ChessChinese.WriteChineseXY (276, 144, '<Space>确定');
	ChessChinese.WriteChineseXY (268, 212, '<Enter>键确定');
	If IsMouse Then
	Begin
		SetMouseCursor (False);
		SetStateLine ('请选择输入设备，按<ESC>键或鼠标右键返回', Cyan);
		SetMouseCursor (True)
	End
	Else
	Begin
		SetStateLine ('请选择输入设备，按<ESC>键返回', Cyan);
	End;
	If IsMouse Then SetMouseCursor (True);
	ClearKeyboardBuffer;
	Repeat
		Repeat
			KeyCode := ReadKeyboard;
			If IsMouse Then
			Begin
				If IsMouseDown (LeftButton) Then
				Begin
					X := GetMousePosition Mod $10000;
					Y := GetMousePosition Div $10000;
					DownButton := GetEnvironmentButton (X, Y);
					If DownButton > 0 Then
					Begin
						SetMouseCursor (False);
						Case DownButton Of
							1:
							Begin
								DrawButton (120, 120, 200, 160, '字母键', True);
								DrawButton (120, 200, 200, 240, '方向键', False);
								DrawButton (120, 280, 200, 320, '鼠标器', False);
							End;
							2:
							Begin
								DrawButton (120, 120, 200, 160, '字母键', False);
								DrawButton (120, 200, 200, 240, '方向键', True);
								DrawButton (120, 280, 200, 320, '鼠标器', False);
							End;
							3:
							Begin
								DrawButton (120, 120, 200, 160, '字母键', False);
								DrawButton (120, 200, 200, 240, '方向键', False);
								DrawButton (120, 280, 200, 320, '鼠标器', True);
							End;
							4:
							Begin
								DrawButton (440, 120, 520, 160, '字母键', True);
								DrawButton (440, 200, 520, 240, '方向键', False);
								DrawButton (440, 280, 520, 320, '鼠标器', False);
							End;
							5:
							Begin
								DrawButton (440, 120, 520, 160, '字母键', False);
								DrawButton (440, 200, 520, 240, '方向键', True);
								DrawButton (440, 280, 520, 320, '鼠标器', False);
							End;
							6:
							Begin
								DrawButton (440, 120, 520, 160, '字母键', False);
								DrawButton (440, 200, 520, 240, '方向键', False);
								DrawButton (440, 280, 520, 320, '鼠标器', True);
							End;
						End;
						If DownButton < 4 Then SelectBlack := DownButton - 1 Else SelectWhite := DownButton - 4;
						SetMouseCursor (True);
					End;
				End;
				If IsMouseDown (RightButton) Then
				Begin
					Repeat
					Until IsMouseUp (RightButton);
					If (Not IsMouse) And ((SelectBlack = 2) Or (SelectWhite = 2)) Then
					Begin
						KeyCode := 0;
						SetStateLine ('没有安装鼠标驱动程序，按任意键继续', Cyan);
						Repeat
						Until KeyPressed;
						SetStateLine ('请选择输入设备，按<ESC>键返回', Cyan)
					End
					Else
					Begin
						SetMouseCursor (False);
						BlackInput := SelectBlack;
						WhiteInput := SelectWhite;
						Exit
					End
				End
			End
		Until KeyCode <> 0;
		ClearKeyboardBuffer;
		If (KeyCode = KeyLeftArrow) Or (KeyCode = KeyRightArrow) Then Column := (Column + 1) Mod 2;
		If (KeyCode = KeyUpArrow) Or (KeyCode = KeyDownArrow) Then
		Begin
			If KeyCode = KeyUpArrow Then
			Begin
				If Column = 0 Then SelectBlack := (SelectBlack + 2) Mod 3 Else SelectWhite := (SelectWhite + 2) Mod 3;
			End;
			If KeyCode = KeyDownArrow Then
			Begin
				If Column = 0 Then SelectBlack := (SelectBlack + 1) Mod 3 Else SelectWhite := (SelectWhite + 1) Mod 3;
			End;
			SetMouseCursor (False);
			If Column = 0 Then
			Begin
				Case SelectBlack Of
					0:
					Begin
						DrawButton (120, 120, 200, 160, '字母键', True);
						DrawButton (120, 200, 200, 240, '方向键', False);
						DrawButton (120, 280, 200, 320, '鼠标器', False);
					End;
					1:
					Begin
						DrawButton (120, 120, 200, 160, '字母键', False);
						DrawButton (120, 200, 200, 240, '方向键', True);
						DrawButton (120, 280, 200, 320, '鼠标器', False);
					End;
					2:
					Begin
						DrawButton (120, 120, 200, 160, '字母键', False);
						DrawButton (120, 200, 200, 240, '方向键', False);
						DrawButton (120, 280, 200, 320, '鼠标器', True);
					End;
				End
			End
			Else
			Begin
				Case SelectWhite Of
					0:
					Begin
						DrawButton (440, 120, 520, 160, '字母键', True);
						DrawButton (440, 200, 520, 240, '方向键', False);
						DrawButton (440, 280, 520, 320, '鼠标器', False);
					End;
					1:
					Begin
						DrawButton (440, 120, 520, 160, '字母键', False);
						DrawButton (440, 200, 520, 240, '方向键', True);
						DrawButton (440, 280, 520, 320, '鼠标器', False);
					End;
					2:
					Begin
						DrawButton (440, 120, 520, 160, '字母键', False);
						DrawButton (440, 200, 520, 240, '方向键', False);
						DrawButton (440, 280, 520, 320, '鼠标器', True);
					End;
				End
			End;
			SetMouseCursor (True)
		End;
		If (KeyCode = KeyESC) And (Not IsMouse) And ((SelectBlack = 2) Or (SelectWhite = 2)) Then
		Begin
			KeyCode := 0;
			SetMouseCursor (False);
			SetStateLine ('没有安装鼠标驱动程序，按任意键继续', Cyan);
			Repeat
			Until KeyPressed;
			SetStateLine ('请选择输入设备，按<ESC>键返回', Cyan);
			SetMouseCursor (True)
		End
	Until KeyCode = KeyESC;
	If IsMouse Then SetMouseCursor (False);
	BlackInput := SelectBlack;
	WhiteInput := SelectWhite;
End;

Var
	Select: Byte;
Begin
	Initialize;
	Repeat
		Select := Title;
		Case Select Of
			1:
				PlayingGame (1);
			2:
				PlayingGame (2);
			3:
				EnvironmentSetting;
		End
	Until Select = 0;
	CloseGraph;
	Writeln ('See you next time!');
End.
