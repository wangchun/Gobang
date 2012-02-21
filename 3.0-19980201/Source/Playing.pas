Unit Playing;

Interface

Const
	LibNumber = 78;

Function GetFirst (IsMouse: Boolean): Boolean;
Function GetName: String;
Function Play (NumOfPlayer, BlackInput, WhiteInput: Byte; First, IsMouse: Boolean): Byte;
Procedure DisplayHistory;
Procedure DrawChessboard;
Procedure SaveResult (NameBlack, NameWhite: String; Winner: Byte);

Implementation

Uses Crt, Graph, Chinese, ChessLib;

Type
	LibType = Record
		Shape: Array [0..4] Of Byte;
		Result: Byte;
	End;

Var
	Chessboard: Array [0..18, 0..18] Of Byte;
	Part: Array [0..4] Of Byte;
	IsExistMouse: Boolean;
	Lib: Array [1..LibNumber] Of LibType;

Function IsExistLib (Player: Byte; Method: Word): Boolean;
Var
	J: Byte;
	IsSame: Boolean;
	LibData: Array [0..4] Of Byte;
Begin
	IsExistLib := False;
	IsSame := True;
	For J := 0 To 4 Do
	Begin
		If Lib [Method].Shape [J] = 0 Then LibData [J] := 0;
		If Lib [Method].Shape [J] = 1 Then LibData [J] := Player + 1;
		If Lib [Method].Shape [J] = 2 Then LibData [J] := (Player + 1) Mod 2 + 1;
		If LibData [J] <> Part [J] Then IsSame := False
	End;
	If IsSame Then IsExistLib := True
End;

Function ReadLib (Player: Byte; Method: Word): Byte;
Var
	J: Byte;
	IsSame: Boolean;
	LibData: Array [0..4] Of Byte;
Begin
	IsSame := True;
	For J := 0 To 4 Do
	Begin
		If Lib [Method].Shape [J] = 0 Then LibData [J] := 0;
		If Lib [Method].Shape [J] = 1 Then LibData [J] := Player + 1;
		If Lib [Method].Shape [J] = 2 Then LibData [J] := (Player + 1) Mod 2 + 1;
		If LibData [J] <> Part [J] Then IsSame := False
	End;
	If IsSame Then ReadLib := Lib [Method].Result
End;

Function Search (Player: Byte): Byte;
Var
	Method: Word;
	X, Y, ResultX, ResultY: Shortint;
	Times, MouseCursor, I, Result: Byte;
Begin
	MouseCursor := 1;
	For Method := 1 To LibNumber Do
	Begin
		If IsExistMouse And (Method Mod 6 = 1) Then
		Begin
			SetMouseCursorImage (MouseCursor);
			MouseCursor := MouseCursor + 1;
			If MouseCursor = 5 Then MouseCursor := 1;
			Delay (15)
		End;
		For Y := 0 To 14 Do
			For X := 0 To 14 Do
			Begin
				For I := 0 To 4 Do Part [I] := Chessboard [X + I, Y];
				If IsExistLib (Player, Method) Then
				Begin
					Result := ReadLib (Player, Method);
					ResultX := X + Result;
					ResultY := Y;
					If Chessboard [ResultX, ResultY] = 0 Then
					Begin
						Search := ResultX + ResultY * 16;
						Exit
					End
				End;
				For I := 0 To 4 Do Part [I] := Chessboard [X, Y + I];
				If IsExistLib (Player, Method) Then
				Begin
					Result := ReadLib (Player, Method);
					ResultX := X;
					ResultY := Y + Result;
					If Chessboard [ResultX, ResultY] = 0 Then
					Begin
						Search := ResultX + ResultY * 16;
						Exit
					End
				End;
				For I := 0 To 4 Do Part [I] := Chessboard [X + I, Y - I];
				If IsExistLib (Player, Method) Then
				Begin
					Result := ReadLib (Player, Method);
					ResultX := X + Result;
					ResultY := Y - Result;
					If Chessboard [ResultX, ResultY] = 0 Then
					Begin
						Search := ResultX + ResultY * 16;
						Exit
					End
				End;
				For I := 0 To 4 Do Part [I] := Chessboard [X + I, Y + I];
				If IsExistLib (Player, Method) Then
				Begin
					Result := ReadLib (Player, Method);
					ResultX := X + Result;
					ResultY := Y + Result;
					If Chessboard [ResultX, ResultY] = 0 Then
					Begin
						Search := ResultX + ResultY * 16;
						Exit
					End
				End
			End
	End;
	If IsExistMouse Then SetMouseCursorImage (0);
	Times := 0;
	For X := 0 To 14 Do
		For Y := 0 To 14 Do
			If Chessboard [X, Y] = 0 Then Times := Times + 1;
	If Times = 225 Then
	Begin
		Search := 119;
		Exit
	End;
	If Random (Times) = 0 Then
	Begin
		Repeat
			ResultX := Random (15);
			ResultY := Random (15)
		Until Chessboard [ResultX, ResultY] = 0;
	End
	Else
	Begin
		Times := 0;
		Repeat
			ResultX := Random (5) + 5;
			ResultY := Random (5) + 5;
			Times := Times + 1
		Until (Chessboard [ResultX, ResultY] = 0) Or (Times >= 16);
		If Times >= 16 Then
		Begin
			Repeat
				ResultX := Random (15);
				ResultY := Random (15)
			Until Chessboard [ResultX, ResultY] = 0
		End
	End;
	Search := ResultX + ResultY * 16
End;

Function ComputerMove (Player: Byte): Byte;
Begin
	ComputerMove := Search (Player);
	SetMouseCursorImage (0)
End;

Function CheckPartWin (Player: Byte): Boolean;
Var
	I: Shortint;
Begin
	CheckPartWin := False;
	For I := -4 To 0 Do
		If (Part [I] = Player) And (Part [I + 1] = Player) And (Part [I + 2] = Player) Then
			If (Part [I + 3] = Player) And (Part [I + 4] = Player) Then CheckPartWin := True;
End;

Function CheckWin (Player, X, Y: Byte): Boolean;
Var
	I: Shortint;
Begin
	CheckWin := False;
	For I := -4 To 4 Do Part [I] := Chessboard [X + I, Y];
	If CheckPartWin (Player + 1) Then CheckWin := True;
	For I := -4 To 4 Do Part [I] := Chessboard [X, Y + I];
	If CheckPartWin (Player + 1) Then CheckWin := True;
	For I := -4 To 4 Do Part [I] := Chessboard [X + I, Y + I];
	If CheckPartWin (Player + 1) Then CheckWin := True;
	For I := -4 To 4 Do Part [I] := Chessboard [X + I, Y - I];
	If CheckPartWin (Player + 1) Then CheckWin := True;
End;

Procedure DrawSquareCursor (X, Y: Byte; Style: Boolean);
Begin
	If Style Then SetColor (Black) Else SetColor (Cyan);
	SetLineStyle (SolidLn, 0, NormWidth);
	If IsExistMouse Then SetMouseCursor (False);
	Line (X * 24 + 142, Y * 24 + 62, X * 24 + 147, Y * 24 + 62);
	Line (X * 24 + 157, Y * 24 + 62, X * 24 + 162, Y * 24 + 62);
	Line (X * 24 + 142, Y * 24 + 82, X * 24 + 147, Y * 24 + 82);
	Line (X * 24 + 157, Y * 24 + 82, X * 24 + 162, Y * 24 + 82);
	Line (X * 24 + 142, Y * 24 + 62, X * 24 + 142, Y * 24 + 67);
	Line (X * 24 + 142, Y * 24 + 77, X * 24 + 142, Y * 24 + 82);
	Line (X * 24 + 162, Y * 24 + 62, X * 24 + 162, Y * 24 + 67);
	Line (X * 24 + 162, Y * 24 + 77, X * 24 + 162, Y * 24 + 82);
	If IsExistMouse Then SetMouseCursor (True);
End;

Function GetFirst (IsMouse: Boolean): Boolean;
Var
	X, Y: Integer;
	KeyCode: Word;
	IsSelected: Boolean;
	PlayingChinese: TChinese;
Begin
	SetStateLine ('选择先行者', Cyan);
	SetColor (Blue);
	SetLineStyle (SolidLn, 0, ThickWidth);
	SetFillStyle (SolidFill, LightBlue);
	Bar (240, 200, 400, 280);
	Rectangle (240, 200, 400, 280);
	PlayingChinese.FontDirectory := '';
	PlayingChinese.FontType := ChineseFont;
	PlayingChinese.ForeColor := White;
	PlayingChinese.BackColor := Transparent;
	PlayingChinese.FontWidth := NormalSize;
	PlayingChinese.FontHeight := NormalSize;
	PlayingChinese.WriteChineseXY (256, 216, '计算机为哪一方？');
	SetColor (White);
	SetLineStyle (SolidLn, 0, NormWidth);
	SetFillStyle (SolidFill, Black);
	FillEllipse (288, 256, 8, 8);
	SetFillStyle (SolidFill, White);
	FillEllipse (352, 256, 8, 8);
	PlayingChinese.WriteChineseXY (285, 249, 'B');
	PlayingChinese.ForeColor := Black;
	PlayingChinese.WriteChineseXY (349, 249, 'W');
	SetMouseCursor (True);
	IsSelected := False;
	Repeat
		X := 0;
		Y := 0;
		Repeat
			KeyCode := ReadKeyboard;
			If IsMouse Then
			Begin
				If IsMouseDown (LeftButton) Then
				Begin
					X := GetMousePosition Mod $10000;
					Y := GetMousePosition Div $10000;
					If ((X - 288) * (X - 288) + (Y - 256) * (Y - 256)) <= 64 Then
					Begin
						GetFirst := True;
						IsSelected := True
					End;
					If ((X - 352) * (X - 352) + (Y - 256) * (Y - 256)) <= 64 Then
					Begin
						GetFirst := False;
						IsSelected := True
					End
				End
			End
		Until (KeyCode <> 0) Or IsSelected;
		ClearKeyboardBuffer;
		If UpCase (Chr (KeyCode And $FF)) = 'B' Then
		Begin
			GetFirst := True;
			IsSelected := True
		End;
		If UpCase (Chr (KeyCode And $FF)) = 'W' Then
		Begin
			GetFirst := False;
			IsSelected := True
		End
	Until IsSelected;
	ClearKeyboardBuffer;
	If IsMouse Then SetMouseCursor (False)
End;

Function GetInput (Player, Mode: Byte; X, Y: Shortint): Byte;
Var
	MouseX, MouseY: Integer;
	InKey: Char;
	KeyCode: Word;
	IsFinish: Boolean;
Begin
	Case Mode Of
		0:
		Begin
			IsFinish := False;
			DrawSquareCursor (X, Y, True);
			Repeat
				InKey := UpCase (ReadKey);
				Case InKey Of
					#27:
					Begin
						GetInput := 255;
						Exit
					End;
					' ':
						If Chessboard [X, Y] = 0 Then IsFinish := True;
					'W':
					Begin
						If Y > 0 Then
						Begin
							DrawSquareCursor (X, Y, False);
							Y := Y - 1;
							DrawSquareCursor (X, Y, True)
						End
					End;
					'S':
					Begin
						If Y < 14 Then
						Begin
							DrawSquareCursor (X, Y, False);
							Y := Y + 1;
							DrawSquareCursor (X, Y, True)
						End
					End;
					'A':
					Begin
						If X > 0 Then
						Begin
							DrawSquareCursor (X, Y, False);
							X := X - 1;
							DrawSquareCursor (X, Y, True)
						End
					End;
					'D':
					Begin
						If X < 14 Then
						Begin
							DrawSquareCursor (X, Y, False);
							X := X + 1;
							DrawSquareCursor (X, Y, True)
						End
					End;
				End
			Until IsFinish;
			DrawSquareCursor (X, Y, False);
			GetInput := X + Y * 16
		End;
		1:
		Begin
			IsFinish := False;
			DrawSquareCursor (X, Y, True);
			Repeat
				Repeat
					KeyCode := ReadKeyboard;
				Until KeyCode > 0;
				ClearKeyboardBuffer;
				Case KeyCode Of
					KeyESC:
					Begin
						GetInput := 255;
						Exit
					End;
					KeyEnter:
						If Chessboard [X, Y] = 0 Then IsFinish := True;
					KeyUpArrow:
					Begin
						If Y > 0 Then
						Begin
							DrawSquareCursor (X, Y, False);
							Y := Y - 1;
							DrawSquareCursor (X, Y, True)
						End
					End;
					KeyDownArrow:
					Begin
						If Y < 14 Then
						Begin
							DrawSquareCursor (X, Y, False);
							Y := Y + 1;
							DrawSquareCursor (X, Y, True)
						End
					End;
					KeyLeftArrow:
					Begin
						If X > 0 Then
						Begin
							DrawSquareCursor (X, Y, False);
							X := X - 1;
							DrawSquareCursor (X, Y, True)
						End
					End;
					KeyRightArrow:
					Begin
						If X < 14 Then
						Begin
							DrawSquareCursor (X, Y, False);
							X := X + 1;
							DrawSquareCursor (X, Y, True)
						End
					End;
				End
			Until IsFinish;
			DrawSquareCursor (X, Y, False);
			GetInput := X + Y * 16
		End;
		2:
		Begin
			IsFinish := IsMouseDown (LeftButton);
			IsFinish := False;
			Repeat
				If IsMouseDown (LeftButton) Then
				Begin
					MouseX := GetMousePosition Mod $10000;
					MouseY := GetMousePosition Div $10000;
					If (MouseX >= 140) And (MouseX < 500) Then X := (MouseX - 140) Div 24 Else X := -1;
					If (MouseY >= 60) And (MouseY < 420) Then Y := (MouseY - 60) Div 24 Else Y := -1;
					If (X >= 0) And (Y >= 0) And (Chessboard [X, Y] = 0) Then IsFinish := True
				End;
				If IsMouseDown (RightButton) Then
				Begin
					GetInput := 255;
					Exit
				End
			Until IsFinish;
			GetInput := X + Y * 16
		End;
		3:
			GetInput := ComputerMove (Player)
	End
End;

Procedure InitLibrary;
Var
	I, J, Code: Integer;
	LibraryFile: Text;
	ReadResult: String;
Begin
	Assign (LibraryFile, 'WZQ.DAT');
	Reset (LibraryFile);
	For I := 1 To LibNumber Do
	Begin
		Readln (LibraryFile, ReadResult);
		For J := 0 To 4 Do
		Begin
			If Copy (ReadResult, J + 1, 1) = '_' Then Lib [I].Shape [J] := 0;
			If Copy (ReadResult, J + 1, 1) = 'O' Then Lib [I].Shape [J] := 1;
			If Copy (ReadResult, J + 1, 1) = 'X' Then Lib [I].Shape [J] := 2;
		End;
		ReadResult := Copy (ReadResult, 6, Length (ReadResult) - 5);
		Val (ReadResult, Lib [I].Result, Code)
	End;
	Close (LibraryFile)
End;

Function Play (NumOfPlayer, BlackInput, WhiteInput: Byte; First, IsMouse: Boolean): Byte;
Var
	InputData, Step: Byte;
	X, Y: Shortint;
	StepString: String;
Begin
	If NumOfPlayer = 1 Then
	Begin
		If First Then BlackInput := 3 Else WhiteInput := 3;
		InitLibrary
	End;
	IsExistMouse := IsMouse;
	Step := 1;
	X := 0;
	Y := 0;
	Repeat
		Str (Step : 3, StepString);
		If IsExistMouse Then SetMouseCursor (False);
		SetStateLine ('第' + StepString + '回合，黑方走棋', Cyan);
		If IsExistMouse Then SetMouseCursor (True);
		InputData := GetInput (0, BlackInput, X, Y);
		If InputData = 255 Then
		Begin
			Play := 2;
			Exit
		End;
		X := InputData Mod 16;
		Y := InputData Div 16;
		Chessboard [X, Y] := 1;
		SetColor (Black);
		SetLineStyle (SolidLn, 0, NormWidth);
		SetFillStyle (SolidFill, Black);
		If IsMouse Then SetMouseCursor (False);
		FillEllipse (X * 24 + 152, Y * 24 + 72, 8, 8);
		If IsMouse Then SetMouseCursor (True);
		If CheckWin (0, X, Y) Then
		Begin
			Play := 1;
			Exit
		End;
		If Step = 113 Then
		Begin
			Play := 0;
			Exit
		End;
		Str (Step : 3, StepString);
		If IsExistMouse Then SetMouseCursor (False);
		SetStateLine ('第' + StepString + '回合，白方走棋', Cyan);
		If IsExistMouse Then SetMouseCursor (True);
		InputData := GetInput (1, WhiteInput, X, Y);
		If InputData = 255 Then
		Begin
			Play := 1;
			Exit
		End;
		X := InputData Mod 16;
		Y := InputData Div 16;
		Chessboard [X, Y] := 2;
		SetColor (White);
		SetLineStyle (SolidLn, 0, NormWidth);
		SetFillStyle (SolidFill, White);
		If IsMouse Then SetMouseCursor (False);
		FillEllipse (X * 24 + 152, Y * 24 + 72, 8, 8);
		If IsMouse Then SetMouseCursor (True);
		If CheckWin (1, X, Y) Then
		Begin
			Play := 2;
			Exit
		End;
		Step := Step + 1
	Until False;
End;

Procedure DrawChessboard;
Var
	I, X, Y: Shortint;
Begin
	SetRGBPalette (PaletteColor (Blue), 0, 42, 42);
	SetRGBPalette (PaletteColor (Cyan), 0, 0, 0);
	SetRGBPalette (PaletteColor (DarkGray), 0, 0, 0);
	SetStateLine ('请稍候……', Blue);
	SetFillStyle (SolidFill, Black);
	Bar (0, 0, 639, 459);
	SetFillStyle (InterleaveFill, Cyan);
	For I := 9 DownTo 0 Do Bar (141 + I, 61 + I, 500 + I, 420 + I);
	SetFillStyle (SolidFill, Cyan);
	Bar (140, 60, 499, 419);
	SetColor (DarkGray);
	SetLineStyle (SolidLn, 0, ThickWidth);
	For I := 0 To 14 Do
	Begin
		Line (152, I * 24 + 72, 487, I * 24 + 72);
		Line (I * 24 + 152, 72, I * 24 + 152, 407);
	End;
	For X := -4 To 18 Do
		For Y := -4 To 18 Do
			Chessboard [X, Y] := 3;
	For X := 0 To 14 Do
		For Y := 0 To 14 Do
			Chessboard [X, Y] := 0;
	SetRGBPalette (PaletteColor (Cyan), 0, 42, 42);
	SetStateLine ('黑方走棋', Cyan);
	SetRGBPalette (PaletteColor (Blue), 0, 0, 42);
	SetRGBPalette (PaletteColor (DarkGray), 21, 21, 21);
End;

Function GetName: String;
Var
	InKey: Char;
	PlayerName: String;
	PlayingChinese: TChinese;
Begin
	PlayingChinese.FontDirectory := '';
	PlayingChinese.FontType := EnglishFont;
	PlayingChinese.ForeColor := Black;
	PlayingChinese.BackColor := Transparent;
	PlayingChinese.FontWidth := NormalSize;
	PlayingChinese.FontHeight := NormalSize;
	PlayingChinese.CurrentX := 152;
	PlayingChinese.CurrentY := 462;
	PlayerName := '';
	Repeat
		InKey := ReadKey;
		If (InKey >= #32) And (InKey < #128) And (Length (PlayerName) < 20) Then
		Begin
			PlayerName := PlayerName + InKey;
			PlayingChinese.WriteChinese (InKey);
		End;
		If (InKey = #8) And (Length (PlayerName) > 0) Then
		Begin
			PlayerName := Copy (PlayerName, 1, Length (PlayerName) - 1);
			PlayingChinese.CurrentX := PlayingChinese.CurrentX - 8;
			SetFillStyle (SolidFill, Cyan);
			Bar (PlayingChinese.CurrentX, 460, PlayingChinese.CurrentX + 7, 479)
		End;
	Until (InKey = #13) And (PlayerName <> 'Computer') And (PlayerName <> '');
	GetName := PlayerName
End;

Procedure DisplayHistory;
Var
	Lines: Byte;
	Win, Defeat, Draw: Word;
	WinStr, DefeatStr, DrawStr, Total, PlayerName: String;
	HistoryFile: Text;
	PlayingChinese: TChinese;
Begin
	SetStateLine ('按任意键继续……', Cyan);
	SetFillStyle (SolidFill, Black);
	Bar (0, 0, 639, 459);
	PlayingChinese.FontDirectory := '';
	PlayingChinese.FontType := ChineseFont;
	PlayingChinese.FontWidth := 48;
	PlayingChinese.FontHeight := 32;
	PlayingChinese.ForeColor := Yellow;
	PlayingChinese.BackColor := Transparent;
	PlayingChinese.WriteChineseXY (224, 0, '历史记录');
	PlayingChinese.FontWidth := NormalSize;
	PlayingChinese.FontHeight := NormalSize;
	PlayingChinese.ForeColor := LightMagenta;
	PlayingChinese.WriteChineseXY (144, 48, '姓名');
	PlayingChinese.WriteChineseXY (392, 48, '胜');
	PlayingChinese.WriteChineseXY (440, 48, '败');
	PlayingChinese.WriteChineseXY (488, 48, '平');
	PlayingChinese.WriteChineseXY (536, 48, '积分');
	PlayingChinese.ForeColor := White;
	Assign (HistoryFile, 'HISTORY.DAT');
	Reset (HistoryFile);
	Lines := 0;
	Repeat
		Readln (HistoryFile, PlayerName);
		Readln (HistoryFile, Win);
		Readln (HistoryFile, Defeat);
		Readln (HistoryFile, Draw);
		Str (Win, WinStr);
		Str (Defeat, DefeatStr);
		Str (Draw, DrawStr);
		Str (Win * 3 + Draw, Total);
		If PlayerName = 'Computer' Then PlayingChinese.ForeColor := LightRed;
		PlayingChinese.WriteChineseXY (160 - Length (PlayerName) * 4, Lines * 16 + 80, PlayerName);
		PlayingChinese.WriteChineseXY (400 - Length (WinStr) * 4, Lines * 16 + 80, WinStr);
		PlayingChinese.WriteChineseXY (448 - Length (DefeatStr) * 4, Lines * 16 + 80, DefeatStr);
		PlayingChinese.WriteChineseXY (496 - Length (DrawStr) * 4, Lines * 16 + 80, DrawStr);
		PlayingChinese.WriteChineseXY (552 - Length (Total) * 4, Lines * 16 + 80, Total);
		If PlayerName = 'Computer' Then PlayingChinese.ForeColor := White;
		Lines := Lines + 1;
		If Lines = 20 Then
		Begin
			Lines := 0;
			Repeat
			Until KeyPressed;
			ClearKeyboardBuffer;
			SetFillStyle (SolidFill, Black);
			Bar (0, 80, 639, 459)
		End
	Until Eoln (HistoryFile);
	Close (HistoryFile);
End;

Procedure SaveResult (NameBlack, NameWhite: String; Winner: Byte);
Var
	Win, Defeat, Draw: Word;
	PlayerName: String;
	IsExistBlack, IsExistWhite: Boolean;
	HistoryFile, OldHistoryFile: Text;
Begin
	Assign (OldHistoryFile, 'HISTORY.DAT');
	Rename (OldHistoryFile, 'HISTORY.TMP');
	Assign (HistoryFile, 'HISTORY.DAT');
	Reset (OldHistoryFile);
	Rewrite (HistoryFile);
	IsExistBlack := False;
	IsExistWhite := False;
	Repeat
		Readln (OldHistoryFile, PlayerName);
		Readln (OldHistoryFile, Win);
		Readln (OldHistoryFile, Defeat);
		Readln (OldHistoryFile, Draw);
		If (PlayerName = NameBlack) Or (PlayerName = NameWhite) Then
		Begin
			If PlayerName = NameBlack Then
			Begin
				IsExistBlack := True;
				If Winner = 0 Then Draw := Draw + 1;
				If Winner = 1 Then Win := Win + 1;
				If Winner = 2 Then Defeat := Defeat + 1;
				Writeln (HistoryFile, PlayerName);
				Writeln (HistoryFile, Win);
				Writeln (HistoryFile, Defeat);
				Writeln (HistoryFile, Draw)
			End;
			If PlayerName = NameWhite Then
			Begin
				IsExistWhite := True;
				If Winner = 0 Then Draw := Draw + 1;
				If Winner = 1 Then Defeat := Defeat + 1;
				If Winner = 2 Then Win := Win + 1;
				Writeln (HistoryFile, PlayerName);
				Writeln (HistoryFile, Win);
				Writeln (HistoryFile, Defeat);
				Writeln (HistoryFile, Draw)
			End
		End
		Else
		Begin
			Writeln (HistoryFile, PlayerName);
			Writeln (HistoryFile, Win);
			Writeln (HistoryFile, Defeat);
			Writeln (HistoryFile, Draw)
		End
	Until Eoln (OldHistoryFile);
	Erase (OldHistoryFile);
	If Not IsExistBlack Then
	Begin
		Draw := 0;
		Win := 0;
		Defeat := 0;
		If Winner = 0 Then Draw := 1;
		If Winner = 1 Then Win := 1;
		If Winner = 2 Then Defeat := 1;
		Writeln (HistoryFile, NameBlack);
		Writeln (HistoryFile, Win);
		Writeln (HistoryFile, Defeat);
		Writeln (HistoryFile, Draw)
	End;
	If Not IsExistWhite Then
	Begin
		Draw := 0;
		Win := 0;
		Defeat := 0;
		If Winner = 0 Then Draw := 1;
		If Winner = 1 Then Defeat := 1;
		If Winner = 2 Then Win := 1;
		Writeln (HistoryFile, NameWhite);
		Writeln (HistoryFile, Win);
		Writeln (HistoryFile, Defeat);
		Writeln (HistoryFile, Draw)
	End;
	Close (HistoryFile)
End;

End.
