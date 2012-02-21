{**********************************************************}
{                                                          }
{        五子棋    版本 5.0    王纯    1998年8月6日        }
{                                                          }
{     Gobang   Version 5.0   Wang Chun   August 6 1998     }
{                                                          }
{**********************************************************}

{游戏模块}

{关闭运行时间输入输出检查}
{$I-}
Unit Playing;

Interface

Uses
	Crt, Graph, Graphics;

Const
	LibNumber = 85;
	MaxValueNum = 10;
	MaxRecord = 256;
	PicWC = 0;
	PicTitle = 1;
	PicHistory = 2;
	PicBlackMan = 3;
	PicWhiteMan = 4;
	PicManMask = 5;

Var
	MaxDepth, ValueNum: Byte;
	ImageHandle, SquareHandle: Word;

{游戏主循环}
Function Play(NumOfPlayer: Byte; First: Boolean): Byte;
{重放刚刚进行过的比赛}
Procedure Replay;
{显示历史记录}
Procedure DisplayHistory;
{重画棋盘}
Procedure DrawChessboard;
{保存历史记录}
Procedure SaveResult(NameBlack, NameWhite: String; Winner: Byte);

Implementation

Type
	RecordType = Record
		PlayerName: String[24];
		Win: Word;
		Defeat: Word;
		Draw: Word
	End;
	LibType = Record
		Shape: Array[-5..5] Of Byte;
		Value: Longint
	End;

Var
	ChessRecord: Array[1..226] Of Byte;
	Chessboard: Array[-5..19, -5..19] Of Byte;
	Part: Array[-5..5] Of Byte;
	Lib: Array[1..LibNumber] Of LibType;

Function GetPartValue(Player: Byte): Longint;
Var
	I, J, K: Integer;
	IsSame1, IsSame2: Boolean;
	Result: Longint;
	ShapeValue: Array[0..4] Of Integer;
Begin
	Result := 0;
	ShapeValue[0] := 0;
	ShapeValue[1] := Player + 1;
	ShapeValue[2] := (Player + 1) Mod 2 + 1;
	ShapeValue[3] := 3;
	ShapeValue[4] := 4;
	For I := 1 To LibNumber Do
	Begin
		IsSame1 := True;
		IsSame2 := True;
		For J := -5 To 5 Do
		Begin
			K := ShapeValue[Lib[I].Shape[J]];
			If K <> 4 Then
			Begin
				If K <> Part[J] Then IsSame1 := False;
				If K <> Part[-J] Then IsSame2 := False
			End;
			If Not (IsSame1 Or IsSame2) Then Break
		End;
		If IsSame1 Then Result := Result + Lib[I].Value;
		If IsSame2 Then Result := Result + Lib[I].Value
	End;
	GetPartValue := Result
End;

Function CalcValue(Player: Byte; X, Y: Integer): Longint;
Var
	I, Method: Integer;
	Result: Longint;
Begin
	Result := 0;
	For I := -5 To 5 Do Part[I] := Chessboard[X + I, Y];
	Result := Result + GetPartValue(Player);
	For I := -5 To 5 Do Part[I] := Chessboard[X, Y + I];
	Result := Result + GetPartValue(Player);
	For I := -5 To 5 Do Part[I] := Chessboard[X + I, Y + I];
	Result := Result + GetPartValue(Player);
	For I := -5 To 5 Do Part[I] := Chessboard[X + I, Y - I];
	Result := Result + GetPartValue(Player);
	CalcValue := Result
End;

Function CheckPartWin(Player: Byte): Boolean;
Var
	I: Shortint;
Begin
	CheckPartWin := False;
	For I := -4 To 0 Do
		If (Part[I] = Player) And (Part[I + 1] = Player) And (Part[I + 2] = Player) Then
			If (Part[I + 3] = Player) And (Part[I + 4] = Player) Then
			Begin
				CheckPartWin := True;
				Exit
			End
End;

Function CheckWin(Player, X, Y: Byte): Boolean;
Var
	I: Shortint;
Begin
	CheckWin := False;
	For I := -4 To 4 Do Part[I] := Chessboard[X + I, Y];
	If CheckPartWin(Player + 1) Then
	Begin
		CheckWin := True;
		Exit
	End;
	For I := -4 To 4 Do Part[I] := Chessboard[X, Y + I];
	If CheckPartWin(Player + 1) Then
	Begin
		CheckWin := True;
		Exit
	End;
	For I := -4 To 4 Do Part[I] := Chessboard[X + I, Y + I];
	If CheckPartWin(Player + 1) Then
	Begin
		CheckWin := True;
		Exit
	End;
	For I := -4 To 4 Do Part[I] := Chessboard[X + I, Y - I];
	If CheckPartWin(Player + 1) Then
	Begin
		CheckWin := True;
		Exit
	End
End;

Function IsChessman(X, Y: Integer): Boolean;
Var
	Result: Boolean;
Begin
	IsChessman := True;
	Result := (Chessboard[X + 1, Y] = 1) Or (Chessboard[X + 1, Y] = 2);
	If Result Then Exit;
	Result := Result Or (Chessboard[X - 1, Y] = 1) Or (Chessboard[X - 1, Y] = 2);
	If Result Then Exit;
	Result := Result Or (Chessboard[X, Y + 1] = 1) Or (Chessboard[X, Y + 1] = 2);
	If Result Then Exit;
	Result := Result Or (Chessboard[X, Y - 1] = 1) Or (Chessboard[X, Y - 1] = 2);
	If Result Then Exit;
	Result := Result Or (Chessboard[X + 1, Y + 1] = 1) Or (Chessboard[X + 1, Y + 1] = 2);
	If Result Then Exit;
	Result := Result Or (Chessboard[X - 1, Y - 1] = 1) Or (Chessboard[X - 1, Y - 1] = 2);
	If Result Then Exit;
	Result := Result Or (Chessboard[X + 1, Y - 1] = 1) Or (Chessboard[X + 1, Y - 1] = 2);
	If Result Then Exit;
	Result := Result Or (Chessboard[X - 1, Y + 1] = 1) Or (Chessboard[X - 1, Y + 1] = 2);
	IsChessman := Result
End;

Function Search(Player, Depth: Byte; X, Y: Integer; CurValue: Longint): Longint;
Var
	I, J, K, L: Integer;
	Value, Max: Longint;
	ValueX, ValueY: Array[1..MaxValueNum] Of Integer;
	MaxValue: Array[1..MaxValueNum] Of Longint;
Begin
	If Depth > MaxDepth Then
	Begin
		If Depth Mod 2 = 1 Then Search := CalcValue(Player, X, Y) Else Search := -CalcValue(Player, X, Y)
	End
	Else
	Begin
		For I := 1 To ValueNum Do MaxValue[I] := -MaxLongint;
		For J := 0 To 14 Do
			For I := 0 To 14 Do
				If (Chessboard[I, J] = 0) And IsChessman(I, J) Then
				Begin
					Chessboard[I, J] := Player + 1;
					Value := CalcValue(Player, I, J);
					For K := 1 To ValueNum Do
						If Value > MaxValue[K] Then
						Begin
							For L := ValueNum - Depth DownTo K Do
							Begin
								MaxValue[L + 1] := MaxValue[L];
								ValueX[L + 1] := ValueX[L];
								ValueY[L + 1] := ValueY[L]
							End;
							MaxValue[K] := Value;
							ValueX[K] := I;
							ValueY[K] := J;
							Break
						End;
					Chessboard[I, J] := 0
				End;
		If MaxValue[1] >= 900000 Then
		Begin
			Search := CurValue;
			Exit
		End;
		Max := -MaxLongint;
		For I := 1 To ValueNum - Depth + 1 Do
		Begin
			If MaxValue[I] <> -MaxLongint Then
			Begin
				If (I >= ValueNum - Depth) And (MaxValue[I] < 0) Then Break;
				Chessboard[ValueX[I], ValueY[I]] := Player + 1;
				Value := Search((Player + 1) Mod 2, Depth + 1, ValueX[I], ValueY[I], MaxValue[I]);
				Chessboard[ValueX[I], ValueY[I]] := 0;
				If Value > Max Then Max := Value
			End
		End;
		If Depth Mod 2 = 0 Then Search := -Max Else Search := Max;
		If Max = -MaxLongint Then Search := CurValue
	End
End;

Function ComputerMove(Player, Step: Byte): Byte;
Var
	I, J, K, L: Integer;
	Value, Max: Longint;
	X, Y, ValueX, ValueY: Array[1..MaxValueNum] Of Integer;
	SearchValue, MaxValue: Array[1..MaxValueNum] Of Longint;
Begin
	If Step = 1 Then
	Begin
		ComputerMove := 119;
		Exit
	End;
	If Step = 225 Then
		For J := 0 To 14 Do
			For I := 0 To 14 Do
				If Chessboard[I, J] = 0 Then
				Begin
					ComputerMove := I + J * 16;
					Exit
				End;
	For I := 1 To ValueNum Do MaxValue[I] := -MaxLongint;
	For J := 0 To 14 Do
		For I := 0 To 14 Do
			If (Chessboard[I, J] = 0) And IsChessman(I, J) Then
			Begin
				Chessboard[I, J] := Player + 1;
				Value := CalcValue(Player, I, J);
				For K := 1 To ValueNum Do
					If Value > MaxValue[K] Then
					Begin
						For L := ValueNum - 1 DownTo K Do
						Begin
							MaxValue[L + 1] := MaxValue[L];
							ValueX[L + 1] := ValueX[L];
							ValueY[L + 1] := ValueY[L]
						End;
						MaxValue[K] := Value;
						ValueX[K] := I;
						ValueY[K] := J;
						Break
					End;
				Chessboard[I, J] := 0
			End;
	If MaxValue[1] >= 900000 Then
	Begin
		ComputerMove := ValueX[1] + ValueY[1] * 16;
		Exit
	End;
	Max := -MaxLongint;
	For I := 1 To ValueNum Do SearchValue[I] := -MaxLongint;
	For I := 1 To ValueNum Do
	Begin
		If MaxValue[I] <> -MaxLongint Then
		Begin
			If (I >= ValueNum - 1) And (MaxValue[I] < 0) Then Break;
			Chessboard[ValueX[I], ValueY[I]] := Player + 1;
			Value := Search((Player + 1) Mod 2, 2, ValueX[I], ValueY[I], MaxValue[I]);
			Chessboard[ValueX[I], ValueY[I]] := 0;
			For K := 1 To ValueNum Do
				If Value > SearchValue[K] Then
				Begin
					For L := ValueNum - 1 DownTo K Do
					Begin
						SearchValue[L + 1] := SearchValue[L];
						X[L + 1] := X[L];
						Y[L + 1] := Y[L]
					End;
					SearchValue[K] := Value;
					X[K] := ValueX[K];
					Y[K] := ValueY[K];
					Break
				End
		End
	End;
	For K := 2 To ValueNum Do If SearchValue[K] < SearchValue[K - 1] Then Break;
	L := Random(K - 1) + 1;
	ComputerMove := X[L] + Y[L] * 16
End;

Procedure DrawSquareCursor(X, Y: Byte; Style: Boolean);
Begin
	If Style Then
	Begin
		SquareHandle := SavePicture(X * 24 + 142, Y * 24 + 62, X * 24 + 162, Y * 24 + 82);
		SetColor(0);
		SetLineStyle(SolidLn, 0, NormWidth);
		Line(X * 24 + 142, Y * 24 + 62, X * 24 + 147, Y * 24 + 62);
		Line(X * 24 + 157, Y * 24 + 62, X * 24 + 162, Y * 24 + 62);
		Line(X * 24 + 142, Y * 24 + 82, X * 24 + 147, Y * 24 + 82);
		Line(X * 24 + 157, Y * 24 + 82, X * 24 + 162, Y * 24 + 82);
		Line(X * 24 + 142, Y * 24 + 62, X * 24 + 142, Y * 24 + 67);
		Line(X * 24 + 142, Y * 24 + 77, X * 24 + 142, Y * 24 + 82);
		Line(X * 24 + 162, Y * 24 + 62, X * 24 + 162, Y * 24 + 67);
		Line(X * 24 + 162, Y * 24 + 77, X * 24 + 162, Y * 24 + 82)
	End
	Else
	Begin
		If SquareHandle <> 0 Then
		Begin
			DisplayPicture(SquareHandle, 0, X * 24 + 142, Y * 24 + 62, NormalPut);
			DeletePicture(SquareHandle);
			SquareHandle := 0
		End
	End
End;

Function GetInput(Player, Mode, Step: Byte; X, Y: Shortint): Byte;
Var
	MouseX, MouseY: Integer;
	InKey: Char;
	IsFinish: Boolean;
Begin
	Case Mode Of
		0:
		Begin
			IsFinish := False;
			DrawSquareCursor(X, Y, True);
			Repeat
				InKey := UpCase(ReadKey);
				Case InKey Of
					#27:
						If MessageBox('真要认输吗？', '五子棋', 2, 200, 180, 240, 120, True, True, True) Then
						Begin
							GetInput := 255;
							Exit
						End;
					' ':
						If Chessboard[X, Y] = 0 Then IsFinish := True;
					'W':
					Begin
						If Y > 0 Then
						Begin
							DrawSquareCursor(X, Y, False);
							Y := Y - 1;
							DrawSquareCursor(X, Y, True)
						End
					End;
					'S':
					Begin
						If Y < 14 Then
						Begin
							DrawSquareCursor(X, Y, False);
							Y := Y + 1;
							DrawSquareCursor(X, Y, True)
						End
					End;
					'A':
					Begin
						If X > 0 Then
						Begin
							DrawSquareCursor(X, Y, False);
							X := X - 1;
							DrawSquareCursor(X, Y, True)
						End
					End;
					'D':
					Begin
						If X < 14 Then
						Begin
							DrawSquareCursor(X, Y, False);
							X := X + 1;
							DrawSquareCursor(X, Y, True)
						End
					End;
				End
			Until IsFinish;
			DrawSquareCursor(X, Y, False);
			GetInput := X + Y * 16
		End;
		1:
		Begin
			IsFinish := False;
			DrawSquareCursor(X, Y, True);
			Repeat
				InKey := ReadKey;
				Case InKey Of
					#0:
					Begin
						InKey := ReadKey;
						Case InKey Of
							#72:
							Begin
								If Y > 0 Then
								Begin
									DrawSquareCursor(X, Y, False);
									Y := Y - 1;
									DrawSquareCursor(X, Y, True)
								End
							End;
							#80:
							Begin
								If Y < 14 Then
								Begin
									DrawSquareCursor(X, Y, False);
									Y := Y + 1;
									DrawSquareCursor(X, Y, True)
								End
							End;
							#75:
							Begin
								If X > 0 Then
								Begin
									DrawSquareCursor(X, Y, False);
									X := X - 1;
									DrawSquareCursor(X, Y, True)
								End
							End;
							#77:
							Begin
								If X < 14 Then
								Begin
									DrawSquareCursor(X, Y, False);
									X := X + 1;
									DrawSquareCursor(X, Y, True)
								End
							End
						End
					End;
					#13: If Chessboard[X, Y] = 0 Then IsFinish := True;
					#27:
						If MessageBox('真要认输吗？', '五子棋', 2, 200, 180, 240, 120, True, True, True) Then
						Begin
							GetInput := 255;
							Exit
						End
				End
			Until IsFinish;
			DrawSquareCursor(X, Y, False);
			GetInput := X + Y * 16
		End;
		2: GetInput := ComputerMove(Player, Step)
	End
End;

Function Play(NumOfPlayer: Byte; First: Boolean): Byte;
Var
	InKey: Char;
	InputData, Step, BlackInput, WhiteInput: Byte;
	X, Y: Shortint;
	StepString: String;
Begin
	BlackInput := 0;
	WhiteInput := 1;
	FillChar(ChessRecord, SizeOf(ChessRecord), 255);
	If NumOfPlayer = 1 Then
		If First Then
		Begin
			BlackInput := 2;
			WhiteInput := 1
		End
		Else
		Begin
			BlackInput := 1;
			WhiteInput := 2
		End;
	If NumOfPlayer = 0 Then
	Begin
		BlackInput := 2;
		WhiteInput := 2
	End;
	SetLineStyle(SolidLn, 0, NormWidth);
	Step := 1;
	X := 7;
	Y := 7;
	Repeat
		If (NumOfPlayer = 0) And KeyPressed Then
		Begin
			InKey := ReadKey;
			If InKey = #0 Then ReadKey;
			If InKey = #27 Then Exit
		End;
		Str(Step:3, StepString);
		SetStatusLine('第' + StepString + '回合，黑方走棋');
		InputData := GetInput(0, BlackInput, Step, X, Y);
		ChessRecord[Step * 2 - 1] := InputData;
		If InputData = 255 Then
		Begin
			Play := 2;
			Exit
		End;
		X := InputData Mod 16;
		Y := InputData Div 16;
		Chessboard[X, Y] := 1;
		DisplayPicture(ImageHandle, PicManMask, X * 24 + 144, Y * 24 + 64, AndPut);
		DisplayPicture(ImageHandle, PicBlackMan, X * 24 + 144, Y * 24 + 64, OrPut);
		If CheckWin(0, X, Y) Then
		Begin
			Play := 1;
			Exit
		End;
		If Step = 225 Then
		Begin
			Play := 0;
			Exit
		End;
		Step := Step + 1;
		If (NumOfPlayer = 0) And KeyPressed Then
		Begin
			InKey := ReadKey;
			If InKey = #0 Then ReadKey;
			If InKey = #27 Then Exit
		End;
		Str(Step:3, StepString);
		SetStatusLine('第' + StepString + '回合，白方走棋');
		InputData := GetInput(1, WhiteInput, Step, X, Y);
		ChessRecord[Step * 2] := InputData;
		If InputData = 255 Then
		Begin
			Play := 1;
			Exit
		End;
		X := InputData Mod 16;
		Y := InputData Div 16;
		Chessboard[X, Y] := 2;
		DisplayPicture(ImageHandle, PicManMask, X * 24 + 144, Y * 24 + 64, AndPut);
		DisplayPicture(ImageHandle, PicWhiteMan, X * 24 + 144, Y * 24 + 64, OrPut);
		If CheckWin(1, X, Y) Then
		Begin
			Play := 2;
			Exit
		End;
		Step := Step + 1
	Until False
End;

Procedure Replay;
Var
	I: Byte;
	StepString: String;
Begin
	If ChessRecord[1] = 254 Then
	Begin
		MessageBox('无法重放！', '五子棋', 2, 200, 180, 240, 120, False, True, True);
		Exit
	End;
	I := 1;
	SetLineStyle(SolidLn, 0, NormWidth);
	Repeat
		If I Mod 2 = 0 Then
		Begin
			Str(I + 1:3, StepString);
			SetStatusLine('第' + StepString + '回合，黑方走棋');
			DisplayPicture(ImageHandle, PicManMask, ChessRecord[I] Mod 16 * 24 + 144, ChessRecord[I] Div 16 * 24 + 64, AndPut);
			DisplayPicture(ImageHandle, PicWhiteMan, ChessRecord[I] Mod 16 * 24 + 144, ChessRecord[I] Div 16 * 24 + 64, OrPut)
		End
		Else
		Begin
			Str(I + 1:3, StepString);
			SetStatusLine('第' + StepString + '回合，白方走棋');
			DisplayPicture(ImageHandle, PicManMask, ChessRecord[I] Mod 16 * 24 + 144, ChessRecord[I] Div 16 * 24 + 64, AndPut);
			DisplayPicture(ImageHandle, PicBlackMan, ChessRecord[I] Mod 16 * 24 + 144, ChessRecord[I] Div 16 * 24 + 64, OrPut)
		End;
		I := I + 1;
		ClearKeyboardBuffer;
		If ReadKey = #27 Then Exit
	Until ChessRecord[I] = 255
End;

Procedure DrawChessboard;
Var
	I: Integer;
	X, Y: Shortint;
Begin
	SetStatusLine('请稍候……');
	SetRGBPalette(PaletteColor(6), 0, 0, 0);
	SetRGBPalette(PaletteColor(14), 0, 0, 0);
	SetFillStyle(SolidFill, 0);
	Bar(0, 0, 639, 459);
	SetFillStyle(SolidFill, 6);
	Bar(132, 52, 507, 427);
	SetColor(14);
	For I := 0 To 179 Do Line(I * 2 + 140, 60, 140, I * 2 + 60);
	For I := 0 To 179 Do Line(499 - I * 2, 419, 499, 419 - I * 2);
	SetColor(0);
	Rectangle(139, 59, 500, 420);
	Line(132, 52, 139, 59);
	Line(507, 52, 500, 59);
	Line(132, 427, 139, 420);
	Line(507, 427, 500, 420);
	SetFillStyle(SolidFill, 14);
	FloodFill(140, 56, 0);
	FloodFill(136, 60, 0);
	SetColor(0);
	SetLineStyle(SolidLn, 0, ThickWidth);
	For I := 0 To 14 Do
	Begin
		Line(152, I * 24 + 72, 487, I * 24 + 72);
		Line(I * 24 + 152, 72, I * 24 + 152, 407);
	End;
	SetLineStyle(SolidLn, 0, NormWidth);
	For X := -4 To 18 Do
		For Y := -4 To 18 Do
			Chessboard[X, Y] := 3;
	For X := 0 To 14 Do
		For Y := 0 To 14 Do
			Chessboard[X, Y] := 0;
	SetFillStyle(SolidFill, 0);
	FillEllipse(224, 144, 5, 5);
	FillEllipse(224, 336, 5, 5);
	FillEllipse(416, 144, 5, 5);
	FillEllipse(416, 336, 5, 5);
	FillEllipse(320, 240, 5, 5);
	SetRGBPalette(PaletteColor(6), 42, 42, 0);
	SetRGBPalette(PaletteColor(14), 63, 63, 21)
End;

Procedure DisplayHistory;
Var
	Flag: Boolean;
	I, Line, RecordNum, PictureWidth: Word;
	WinStr, DefeatStr, DrawStr, Total: String;
	UserData: RecordType;
	HistoryFile: File Of RecordType;
	RecordData: Array[1..MaxRecord] Of RecordType;
Begin
	SetStatusLine('按任意键继续……');
	SetFillStyle(SolidFill, 0);
	Bar(0, 0, 639, 459);
	Assign(HistoryFile, 'HISTORY.DAT');
	Reset(HistoryFile);
	If IOResult <> 0 Then
	Begin
		SetFillStyle(SolidFill, 0);
		Bar(0, 0, 639, 459);
		Exit
	End;
	PictureWidth := GetPictureWidth(ImageHandle, PicHistory);
	DisplayPicture(ImageHandle, PicHistory, 320 - PictureWidth Div 2, 0, NormalPut);
	WriteChinese('姓名', 144, 75, 13, -1, 0);
	WriteChinese('胜', 392, 75, 13, -1, 0);
	WriteChinese('败', 440, 75, 13, -1, 0);
	WriteChinese('平', 488, 75, 13, -1, 0);
	WriteChinese('积分', 536, 75, 13, -1, 0);
	Line := 0;
	Repeat
		Line := Line + 1;
		Read(HistoryFile, RecordData[Line]);
		If IOResult <> 0 Then
		Begin
			Close(HistoryFile);
			FatalError('Error Reading File HISTORY.TMP!')
		End
	Until Eof(HistoryFile);
	Repeat
		Flag := True;
		For I := 1 To Line - 1 Do
		Begin
			If RecordData[I].Win * 2 + RecordData[I].Draw < RecordData[I + 1].Win * 2 + RecordData[I + 1].Draw Then
			Begin
				UserData := RecordData[I];
				RecordData[I] := RecordData[I + 1];
				RecordData[I + 1] := UserData;
				Flag := False
			End;
			If RecordData[I].Win * 2 + RecordData[I].Draw = RecordData[I + 1].Win * 2 + RecordData[I + 1].Draw Then
				If RecordData[I].Win + RecordData[I].Draw + RecordData[I].Defeat < RecordData[I + 1].Win + RecordData[I + 1].
					Draw + RecordData[I].Defeat Then
				Begin
					UserData := RecordData[I];
					RecordData[I] := RecordData[I + 1];
					RecordData[I + 1] := UserData;
					Flag := False
				End
		End
	Until Flag;
	For I := 1 To Line Do
	Begin
		Str(RecordData[I].Win, WinStr);
		Str(RecordData[I].Defeat, DefeatStr);
		Str(RecordData[I].Draw, DrawStr);
		Str(RecordData[I].Win * 2 + RecordData[I].Draw, Total);
		If (RecordData[I].PlayerName = '计算机(入门)') Or (RecordData[I].PlayerName = '计算机(简单)') Or (RecordData[I].
			PlayerName = '计算机(一般)') Or (RecordData[I].PlayerName =	'计算机(困难)') Then
		Begin
			WriteChinese(RecordData[I].PlayerName, 160 - Length(RecordData[I].PlayerName) * 4, I * 16 + 100, 12, -1, 0);
			WriteChinese(WinStr, 400 - Length(WinStr) * 4, I * 16 + 100, 12, -1, 0);
			WriteChinese(DefeatStr, 448 - Length(DefeatStr) * 4, I * 16 + 100, 12, -1, 0);
			WriteChinese(DrawStr, 496 - Length(DrawStr) * 4, I * 16 + 100, 12, -1, 0);
			WriteChinese(Total, 552 - Length(Total) * 4, I * 16 + 100, 12, -1, 0);
		End
		Else
		Begin
			WriteChinese(RecordData[I].PlayerName, 160 - Length(RecordData[I].PlayerName) * 4, I * 16 + 100, 15, -1, 0);
			WriteChinese(WinStr, 400 - Length(WinStr) * 4, I * 16 + 100, 15, -1, 0);
			WriteChinese(DefeatStr, 448 - Length(DefeatStr) * 4, I * 16 + 100, 15, -1, 0);
			WriteChinese(DrawStr, 496 - Length(DrawStr) * 4, I * 16 + 100, 15, -1, 0);
			WriteChinese(Total, 552 - Length(Total) * 4, I * 16 + 100, 15, -1, 0);
		End;
		If I Mod 20 = 0 Then
		Begin
			ClearKeyboardBuffer;
			ReadKey;
			SetFillStyle(SolidFill, 0);
			Bar(0, 100, 639, 459)
		End
	End;
	Close(HistoryFile);
	ClearKeyboardBuffer;
	ReadKey;
	SetFillStyle(SolidFill, 0);
	Bar(0, 0, 639, 459)
End;

Procedure SaveResult(NameBlack, NameWhite: String; Winner: Byte);
Var
	UserData: RecordType;
	IsExistBlack, IsExistWhite: Boolean;
	HistoryFile, OldHistoryFile: File Of RecordType;
Begin
	Assign(OldHistoryFile, 'HISTORY.DAT');
	Reset(OldHistoryFile);
	If IOResult <> 0 Then
	Begin
		Rewrite(OldHistoryFile);
		If IOResult <> 0 Then FatalError('Error Open File HISTORY.DAT!');
		UserData.PlayerName := '计算机(入门)';
		UserData.Draw := 0;
		UserData.Win := 0;
		UserData.Defeat := 0;
		Write(OldHistoryFile, UserData);
		If IOResult <> 0 Then
		Begin
			Close(OldHistoryFile);
			FatalError('Error Writing File HISTORY.DAT!')
		End;
		UserData.PlayerName := '计算机(简单)';
		Write(OldHistoryFile, UserData);
		If IOResult <> 0 Then
		Begin
			Close(OldHistoryFile);
			FatalError('Error Writing File HISTORY.DAT!')
		End;
		UserData.PlayerName := '计算机(一般)';
		Write(OldHistoryFile, UserData);
		If IOResult <> 0 Then
		Begin
			Close(OldHistoryFile);
			FatalError('Error Writing File HISTORY.DAT!')
		End;
		UserData.PlayerName := '计算机(困难)';
		Write(OldHistoryFile, UserData);
		If IOResult <> 0 Then
		Begin
			Close(OldHistoryFile);
			FatalError('Error Writing File HISTORY.DAT!')
		End
	End;
	Close(OldHistoryFile);
	Rename(OldHistoryFile, 'HISTORY.TMP');
	If IOResult <> 0 Then FatalError('Error Rename File HISTORY.DAT!');
	Assign(HistoryFile, 'HISTORY.DAT');
	Reset(OldHistoryFile);
	If IOResult <> 0 Then FatalError('Error Open File HISTORY.TMP!');
	Rewrite(HistoryFile);
	If IOResult <> 0 Then FatalError('Error Open File HISTORY.DAT!');
	IsExistBlack := False;
	IsExistWhite := False;
	Repeat
		Read(OldHistoryFile, UserData);
		If IOResult <> 0 Then
		Begin
			Close(HistoryFile);
			Close(OldHistoryFile);
			FatalError('Error Reading File HISTORY.TMP!')
		End;
		If (UserData.PlayerName = NameBlack) Or (UserData.PlayerName = NameWhite) Then
		Begin
			If UserData.PlayerName = NameBlack Then
			Begin
				IsExistBlack := True;
				If Winner = 0 Then UserData.Draw := UserData.Draw + 1;
				If Winner = 1 Then UserData.Win := UserData.Win + 1;
				If Winner = 2 Then UserData.Defeat := UserData.Defeat + 1;
				Write(HistoryFile, UserData);
				If IOResult <> 0 Then
				Begin
					Close(HistoryFile);
					Close(OldHistoryFile);
					FatalError('Error Writing File HISTORY.DAT!')
				End
			End;
			If UserData.PlayerName = NameWhite Then
			Begin
				IsExistWhite := True;
				If Winner = 0 Then UserData.Draw := UserData.Draw + 1;
				If Winner = 1 Then UserData.Defeat := UserData.Defeat + 1;
				If Winner = 2 Then UserData.Win := UserData.Win + 1;
				Write(HistoryFile, UserData);
				If IOResult <> 0 Then
				Begin
					Close(HistoryFile);
					Close(OldHistoryFile);
					FatalError('Error Writing File HISTORY.DAT!')
				End
			End
		End
		Else
		Begin
			Write(HistoryFile, UserData);
			If IOResult <> 0 Then
			Begin
				Close(HistoryFile);
				Close(OldHistoryFile);
				FatalError('Error Writing File HISTORY.DAT!')
			End
		End
	Until Eof(OldHistoryFile);
	Erase(OldHistoryFile);
	If Not IsExistBlack Then
	Begin
		UserData.Draw := 0;
		UserData.Win := 0;
		UserData.Defeat := 0;
		If Winner = 0 Then UserData.Draw := 1;
		If Winner = 1 Then UserData.Win := 1;
		If Winner = 2 Then UserData.Defeat := 1;
		UserData.PlayerName := NameBlack;
		Write(HistoryFile, UserData);
		If IOResult <> 0 Then
		Begin
			Close(HistoryFile);
			FatalError('Error Writing File HISTORY.DAT!')
		End
	End;
	If Not IsExistWhite Then
	Begin
		UserData.Draw := 0;
		UserData.Win := 0;
		UserData.Defeat := 0;
		If Winner = 0 Then UserData.Draw := 1;
		If Winner = 1 Then UserData.Defeat := 1;
		If Winner = 2 Then UserData.Win := 1;
		UserData.PlayerName := NameWhite;
		Write(HistoryFile, UserData);
		If IOResult <> 0 Then
		Begin
			Close(HistoryFile);
			FatalError('Error Writing File HISTORY.DAT!')
		End
	End;
	Close(HistoryFile)
End;

Var
	I, J: Integer;
	LibraryFile: Text;
	ShapeStr: String;
Begin
	ImageHandle := LoadPicture('WZQ.IMG');
	SquareHandle := 0;
	Assign(LibraryFile, 'WZQ.DAT');
	Reset(LibraryFile);
	If IOResult <> 0 Then FatalError('Error Open File WZQ.DAT');
	For I := 1 To LibNumber Do
	Begin
		Readln(LibraryFile, ShapeStr);
		If IOResult <> 0 Then FatalError('Error Reading File WZQ.DAT');
		Readln(LibraryFile, Lib[I].Value);
		If IOResult <> 0 Then FatalError('Error Reading File WZQ.DAT');
		For J := -5 To 5 Do
			Case ShapeStr[J + 6] Of
				'_': Lib[I].Shape[J] := 0;
				'O': Lib[I].Shape[J] := 1;
				'X': Lib[I].Shape[J] := 2;
				'|': Lib[I].Shape[J] := 3;
				'?', ' ': Lib[I].Shape[J] := 4
			End
	End;
	Close(LibraryFile);
	ChessRecord[1] := 254
End.