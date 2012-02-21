{**********************************************************}
{                                                          }
{         五子棋   版本6.1   王纯   1999年10月20日         }
{                                                          }
{    Gobang   Version 6.1   Wang Chun   October 20 1999    }
{                                                          }
{**********************************************************}

{游戏模块}

{$G+}
Unit PlayGame;

Interface

Uses
	Crt, Dos, Strings, Graph, Graphics;

Const
	MaxDepth = 5;
	MaxNumValue = 5;
	NumManual = 85;
	Least = 3;
	Saving = 3;
	cmNone = 0;
	cmBlack = 1;
	cmWhite = 2;
	cmBorder = 3;
	idComputer = 0;
	idMouse = 1;
	idArrow = 2;
	idLetter = 3;
	Direction: Array[1..4, 1..2] Of Integer = ((0, 1), (1, 1), (1, 0), (1, -1));
	ValueStandard: Array[1..4, 1..4] Of Real = ((0.01, 0.05, 0.2, 1), (0.5, 2, 20, 0), (30, 200, 0, 0), (1000000, 0, 0, 0));
	DeviceName: Array[idComputer..idLetter] Of String[6] = ('计算机', '鼠标器', '方向键', '字母键');

Type
	TManual = Record
		Shape: Array[-5..5] Of Byte;
		Value: Longint
	End;
	PHistory = ^THistory;
	THistory = Record
		Name: String[24];
		Result: Array[-1..1] Of Word
	End;
	TPlayerInfo = Record
		Name: String[24];
		InputDevice: Integer
	End;

Var
	StartFlag: Boolean;
	ResultX, ResultY: Integer;
	Value, MaxValue: Real;
	Part: Array[-5..5] Of Byte;
	FlagMap: Array[0..14, 0..14] Of Boolean;
	GameRecord: Array[1..226, 1..2] Of Shortint;
	Chessboard: Array[-5..19, -5..19] Of Integer;
	Map: Array[0..16, 0..16] Of Integer;
	Manual: Array[1..NumManual] Of TManual;
	PlayerInfo: Array[cmBlack..cmWhite] Of TPlayerInfo;
	ValueMap: Array[1..15, 1..15] Of Real;

Function Play(Var Window: TWindow): Integer;
Procedure DrawChessman(Var Window: TWindow; X, Y, Chessman: Integer);

Implementation

Function ExistChessman1(X, Y: Integer): Boolean;
Begin
	ExistChessman1 := True;
	If Map[X + 1, Y] <> 0 Then Exit;
	If Map[X - 1, Y] <> 0 Then Exit;
	If Map[X, Y + 1] <> 0 Then Exit;
	If Map[X, Y - 1] <> 0 Then Exit;
	If Map[X + 1, Y + 1] <> 0 Then Exit;
	If Map[X + 1, Y - 1] <> 0 Then Exit;
	If Map[X - 1, Y - 1] <> 0 Then Exit;
	If Map[X - 1, Y + 1] <> 0 Then Exit;
	ExistChessman1 := False
End;

Procedure Calc1(Player: Integer);
Var
	I, J, K, L, M, N: Integer;
	T: Real;
	SS: Set Of Byte;
	S1: Array[1..5] Of Byte;
	S2: Array[1..5] Of Real;
	F: Array[1..2, 1..15, 1..15, 1..4, 1..4] Of Integer;
Begin
	FillChar(ValueMap, SizeOf(ValueMap), 0);
	FillChar(F, SizeOf(F), 0);
	For I := 1 To 15 Do
		For J := 1 To 15 Do
			For K := 1 To 4 Do
				If (I + Direction[K, 1] Shl 2 In [1..15]) And (J + Direction[K, 2] Shl 2 In [1..15]) Then
				Begin
					For L := 0 To 4 Do
						S1[L + 1] := Map[I + Direction[K, 1] * L, J + Direction[K, 2] * L];
					SS := [];
					For L := 1 To 5 Do
						Include(SS, S1[L]);
					SS := SS - [0];
					If (SS = [1]) Or (SS = [2]) Then
					Begin
						If SS = [1] Then M := 1 Else M := 2;
						N := 0;
						For L := 1 To 5 Do
							If S1[L] <> 0 Then Inc(N);
						For L := 0 To 4 Do
							If S1[L + 1] = 0 Then Inc(F[M, I + Direction[K, 1] * L, J + Direction[K, 2] * L, N, K])
					End
				End;
	For I := 1 To 15 Do
		For J := 1 To 15 Do
			For M := 1 To 2 Do
			Begin
				If M = Player Then T := 1 Else T := 0.9;
				For N := 1 To 4 Do
					For K := 1 To 4 Do
						If F[M, I, J, N, K] <> 0 Then
							ValueMap[I, J] := ValueMap[I, J] + ValueStandard[N, F[M, I, J, N, K]]
			End
End;

Function Calc2(Player: Integer): Real;
Var
	I, J, K, L, M, N: Integer;
	T: Real;
	SS: Set Of Byte;
	S1: Array[1..5] Of Byte;
	S2: Array[1..5] Of Real;
	F: Array[1..2, 1..15, 1..15, 1..4, 1..4] Of Integer;
Begin
	FillChar(F, SizeOf(F), 0);
	For I := 1 To 15 Do
		For J := 1 To 15 Do
			For K := 1 To 4 Do
				If (I + Direction[K, 1] Shl 2 In [1..15]) And (J + Direction[K, 2] Shl 2 In [1..15]) Then
				Begin
					For L := 0 To 4 Do
						S1[L + 1] := Map[I + Direction[K, 1] * L, J + Direction[K, 2] * L];
					SS := [];
					For L := 1 To 5 Do
						Include(SS, S1[L]);
					SS := SS - [0];
					If (SS = [1]) Or (SS = [2]) Then
					Begin
						If SS = [1] Then M := 1 Else M := 2;
						N := 0;
						For L := 1 To 5 Do
							If S1[L] <> 0 Then Inc(N);
						For L := 0 To 4 Do
							If S1[L + 1] = 0 Then Inc(F[M, I + Direction[K, 1] * L, J + Direction[K, 2] * L, N, K])
					End
				End;
	T := 0;
	For I := 1 To 15 Do
		For J := 1 To 15 Do
			For M := 1 To 2 Do
			Begin
				For N := 1 To 4 Do
					For K := 1 To 4 Do
						If F[M, I, J, N, K] <> 0 Then
							If M = Player Then
								T := T + ValueStandard[N, F[M, I, J, N, K]]
							Else
								T := T - ValueStandard[N, F[M, I, J, N, K]]
			End;
	Calc2 := T
End;

Function HasWin(Player: Integer): Boolean;
Var
	I, J, K, L: Integer;
	SS: Set Of Byte;
	S: Array[1..5] Of Byte;
Begin
	For I := 1 To 15 Do
		For J := 1 To 15 Do
			For K := 1 To 4 Do
				If (I + Direction[K, 1] Shl 2 In [1..15]) And (J + Direction[K, 2] Shl 2 In [1..15]) Then
				Begin
					For L := 0 To 4 Do
						S[L + 1] := Map[I + Direction[K, 1] * L, J + Direction[K, 2] * L];
					SS := [];
					For L := 1 To 5 Do
						Include(SS, S[L]);
					If (SS = [Player]) Then
					Begin
						HasWin := True;
						Exit
					End
				End;
	HasWin := False
End;

Function Search1(Depth, Player: Integer; Mark: Real): Real;
Var
	I, J, K, M, MI, MJ, ST, MW: Integer;
	Max2, Min, Min2: Real;
	SS2: Array[1..Saving] Of Real;
	SS: Array[1..Saving, 1..2] Of Integer;
Begin
	If (Depth >= MaxDepth) Then
	Begin
		Search1 := Calc2(1);
		Exit
	End;
	Calc1(Player);
	ST := 0;
	Max2 := 0;
	For I := 1 To 15 Do
		For J := 1 To 15 Do
			If (Map[I, J] = 0) And (ValueMap[I, J] > 0) Then
			Begin
				If ST = Saving Then
				Begin
					If (ValueMap[I, J] > Min2) Then
					Begin
						M := MW;
						SS2[M] := ValueMap[I, J];
						If SS2[M] > Max2 Then
						Begin
							Max2 := SS2[M];
							MI := I;
							MJ := J
						End;
						SS[M, 1] := I;
						SS[M, 2] := J;
						Min2 := SS2[1];
						MW := 1;
						For K := 2 To ST Do
							If SS2[K] < Min2 Then
							Begin
								Min2 := SS2[K];
								MW := K
							End
					End
				End
				Else
				Begin
					Inc(ST);
					SS[ST, 1] := I;
					SS[ST, 2] := J;
					SS2[ST] := ValueMap[I, J];
					If ValueMap[I, J] > Max2 Then
					Begin
						MI := I;
						MJ := J;
						Max2 := ValueMap[I, J]
					End;
					Min2 := SS2[1];
					MW := 1;
					For K := 2 To ST Do
						If SS2[K] < Min2 Then
						Begin
							Min2 := SS2[K];
							MW := K
						End
				End
			End;
	For I := 1 To ST Do
		For J := I + 1 To ST Do
			If SS2[I] < SS2[J] Then
			Begin
				M := SS[I, 1];
				SS[I, 1] := SS[J, 1];
				SS[J, 1] := M;
				M := SS[I, 2];
				SS[I, 2] := SS[J, 2];
				SS[J, 2] := M;
				Min := SS2[I];
				SS2[I] := SS2[J];
				SS2[J] := Min
			End;
	If StartFlag Then
	Begin
		ST := 2;
		StartFlag := False
	End;
	If ST > Least Then ST := Least;
	Max2 := -1E10;
	If Not Odd(Depth) Then Max2 := 1E10;
	For M := 1 To ST Do
	Begin
		I := SS[M, 1];
		J := SS[M, 2];
		Map[I, J] := Player;
		If HasWin(Player) Then
		Begin
			If Odd(Depth) Then Search1 := 1E10 Else Search1 := -1E10;
			If Depth = 1 Then
			Begin
				ResultX := I;
				ResultY := J
			End;
			Map[I, J] := 0;
			Exit
		End;
		Min := Search1(Depth + 1, 3 - Player, Max2);
		Map[I, J] := 0;
		If Odd(Depth) Then
		Begin
			If Min > Max2 Then
			Begin
				Max2 := Min;
				If Depth = 1 Then
				Begin
					ResultX := I;
					ResultY := J
				End
			End;
			If Max2 >= Mark Then
			Begin
				Search1 := Max2;
				Exit
			End
		End
		Else
		Begin
			If Min < Max2 Then Max2 := Min;
			If Max2 <= Mark Then
			Begin
				Search1 := Max2;
				Exit
			End
		End
	End;
	Search1 := Max2
End;

Procedure ComputerMove1(Var X, Y: Integer);
Var
	I, J: Integer;
	M: Real;
Begin
	For I := 1 To 15 Do
		For J := 1 To 15 Do
			If (Map[I, J] = 0) And ExistChessman1(I, J) Then
			Begin
				Map[I, J] := 1;
				If HasWin(1) Then
				Begin
					X := I - 1;
					Y := J - 1;
					Exit
				End;
				Map[I, J] := 0
			End;
	For I := 1 To 15 Do
		For J := 1 To 15 Do
			If (Map[I, J] = 0) And ExistChessman1(I, J) Then
			Begin
				Map[I, J] := 2;
				If HasWin(2) Then
				Begin
					X := I - 1;
					Y := J - 1;
					Exit
				End;
				Map[I, J] := 0
			End;
	Value := Search1(1, 1, 1E20);
	If Value = -1E10 Then
	Begin
		Calc1(1);
		M := -1;
		For I := 1 To 15 Do
			For J := 1 To 15 Do
				If Map[I, J] = 0 Then
				Begin
					If ValueMap[I, J] > M Then
					Begin
						M := ValueMap[I, J];
						ResultX := I;
						ResultY := J
					End
				End
	End;
	X := ResultX - 1;
	Y := ResultY - 1
End;

Function ExistChessman2(X, Y: Integer): Boolean;
Begin
	ExistChessman2 := True;
	If Chessboard[X + 1, Y] In [cmBlack, cmWhite] Then Exit;
	If Chessboard[X - 1, Y] In [cmBlack, cmWhite] Then Exit;
	If Chessboard[X, Y + 1] In [cmBlack, cmWhite] Then Exit;
	If Chessboard[X, Y - 1] In [cmBlack, cmWhite] Then Exit;
	If Chessboard[X + 1, Y + 1] In [cmBlack, cmWhite] Then Exit;
	If Chessboard[X + 1, Y - 1] In [cmBlack..cmWhite] Then Exit;
	If Chessboard[X - 1, Y - 1] In [cmBlack, cmWhite] Then Exit;
	If Chessboard[X - 1, Y + 1] In [cmBlack..cmWhite] Then Exit;
	ExistChessman2 := False
End;

Function CheckLine(Player, X, Y, Dir, State: Integer): Boolean;
Var
	Flag: Boolean;
	I, S: Integer;
	Line: Longint;
	T: Array[-5..5] Of Integer;
	F: Array[-5..5] Of Boolean;
Begin
	CheckLine := False;
	If Chessboard[X, Y] <> Player Then Exit;
	Line := 0;
	For I := -5 To 5 Do
	Begin
		T[I] := Chessboard[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I];
		S := T[I];
		If (Player = cmWhite) And (T[I] = cmBlack) Then S := cmWhite;
		If (Player = cmWhite) And (T[I] = cmWhite) Then S := cmBlack;
		Line := Line Shl 2 + S
	End;
	FillChar(F, SizeOf(F), False);
	Case State Of
		3:
		Begin
			S := Line And $0FFF00 Shr 8;
			If (S = $0114) Or (S = $0144) Then
			Begin
				F[-3] := True;
				If S = $0144 Then F[-2] := True;
				If S = $0114 Then F[-1] := True;
				F[0] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			S := Line And $03FFC0 Shr 6;
			If (S = $0114) Or (S = $0144) Then
			Begin
				F[-2] := True;
				If S = $0144 Then F[-1] := True;
				If S = $0114 Then F[0] := True;
				F[1] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			S := Line And $00FFF0 Shr 4;
			If (S = $0114) Or (S = $0144) Then
			Begin
				F[-1] := True;
				If S = $0144 Then F[0] := True;
				If S = $0114 Then F[1] := True;
				F[2] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			S := Line And $003FFC Shr 2;
			If (S = $0114) Or (S = $0144) Then
			Begin
				F[0] := True;
				If S = $0144 Then F[1] := True;
				If S = $0114 Then F[2] := True;
				F[3] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			If Line And $03FF00 Shr 8 = $0054 Then
			Begin
				F[-2] := True;
				F[-1] := True;
				F[0] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			If Line And $00FFC0 Shr 6 = $0054 Then
			Begin
				F[-1] := True;
				F[0] := True;
				F[1] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			If Line And $003FF0 Shr 4 = $0054 Then
			Begin
				F[0] := True;
				F[1] := True;
				F[2] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End
		End;
		4:
		Begin
			S := Line And $3FFF00 Shr 8;
			If (S = $0454) Or (S = $0514) Or (S = $544) Then
			Begin
				F[-4] := True;
				If S <> $0454 Then F[-3] := True;
				If S <> $0514 Then F[-2] := True;
				If S <> $0544 Then F[-1] := True;
				F[0] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			S := Line And $0FFFC0 Shr 6;
			If (S = $0454) Or (S = $0514) Or (S = $544) Then
			Begin
				F[-3] := True;
				If S <> $0454 Then F[-2] := True;
				If S <> $0514 Then F[-1] := True;
				If S <> $0544 Then F[0] := True;
				F[1] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			S := Line And $03FFF0 Shr 4;
			If (S = $0454) Or (S = $0514) Or (S = $544) Then
			Begin
				F[-2] := True;
				If S <> $0454 Then F[-1] := True;
				If S <> $0514 Then F[0] := True;
				If S <> $0544 Then F[1] := True;
				F[2] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			S := Line And $00FFFC Shr 2;
			If (S = $0454) Or (S = $0514) Or (S = $544) Then
			Begin
				F[-1] := True;
				If S <> $0454 Then F[0] := True;
				If S <> $0514 Then F[1] := True;
				If S <> $0544 Then F[2] := True;
				F[3] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			S := Line And $003FFF;
			If (S = $0454) Or (S = $0514) Or (S = $544) Then
			Begin
				F[0] := True;
				If S <> $0454 Then F[1] := True;
				If S <> $0514 Then F[2] := True;
				If S <> $0544 Then F[3] := True;
				F[4] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			If Line And $0FFF00 Shr 8 = $0154 Then
			Begin
				F[-3] := True;
				F[-2] := True;
				F[-1] := True;
				F[0] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			If Line And $03FFC0 Shr 6 = $0154 Then
			Begin
				F[-2] := True;
				F[-1] := True;
				F[0] := True;
				F[1] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			If Line And $00FFF0 Shr 4 = $0154 Then
			Begin
				F[-1] := True;
				F[0] := True;
				F[1] := True;
				F[2] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End;
			If Line And $003FFC Shr 2 = $0154 Then
			Begin
				F[0] := True;
				F[1] := True;
				F[2] := True;
				F[3] := True;
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End
		End;
		5:
		Begin
			S := 1;
			F[0] := True;
			For I := -1 DownTo -4 Do
			Begin
				If T[I] <> Player Then Break;
				F[I] := True;
				Inc(S)
			End;
			For I := 1 To 4 Do
			Begin
				If T[I] <> Player Then Break;
				F[I] := True;
				Inc(S)
			End;
			If S = 5 Then
			Begin
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End
		End;
		6:
		Begin
			S := 1;
			F[0] := True;
			For I := -1 DownTo -5 Do
			Begin
				If T[I] <> Player Then Break;
				F[I] := True;
				Inc(S)
			End;
			For I := 1 To 5 Do
			Begin
				If T[I] <> Player Then Break;
				F[I] := True;
				Inc(S)
			End;
			If S > 5 Then
			Begin
				For I := -5 To 5 Do
					If F[I] Then FlagMap[X + Direction[Dir, 1] * I, Y + Direction[Dir, 2] * I] := F[I];
				CheckLine := True;
				Exit
			End
		End
	End
End;

Function CheckWin(Player, X, Y, LX, LY: Integer): Integer;
Var
	I, J: Integer;
Begin
	CheckWin := cmNone;
	FillChar(FlagMap, SizeOf(FlagMap), False);
	For I := 1 To 4 Do
		If CheckLine(Player, X, Y, I, 5) Then
		Begin
			CheckWin := Player;
			Exit
		End;
	If Player = cmBlack Then
	Begin
		FillChar(FlagMap, SizeOf(FlagMap), False);
		For I := 1 To 4 Do
			If CheckLine(Player, X, Y, I, 6) Then
			Begin
				CheckWin := 259 - Player;
				Exit
			End;
		J := 0;
		For I := 1 To 4 Do
			If CheckLine(Player, LX, LY, I, 3) Then Inc(J);
		If J >= 2 Then
		Begin
			CheckWin := 515 - Player;
			Exit
		End;
		If J = 1 Then FillChar(FlagMap, SizeOf(FlagMap), False);
		J := 0;
		For I := 1 To 4 Do
			If CheckLine(Player, LX, LY, I, 4) Then Inc(J);
		If J >= 2 Then
		Begin
			CheckWin := 771 - Player;
			Exit
		End;
		If J = 1 Then FillChar(FlagMap, SizeOf(FlagMap), False)
	End
End;

Function GetPartValue(Player: Byte): Longint;
Var
	I, J, K: Integer;
	IsSame1, IsSame2: Boolean;
	Result: Longint;
	ShapeValue: Array[0..4] Of Integer;
Begin
	Result := 0;
	ShapeValue[0] := 0;
	ShapeValue[1] := Player;
	ShapeValue[2] := 3 - Player;
	ShapeValue[3] := 3;
	ShapeValue[4] := 4;
	For I := 1 To NumManual Do
	Begin
		IsSame1 := True;
		IsSame2 := True;
		For J := -5 To 5 Do
		Begin
			K := ShapeValue[Manual[I].Shape[J]];
			If K <> 4 Then
			Begin
				If K <> Part[J] Then IsSame1 := False;
				If K <> Part[-J] Then IsSame2 := False
			End;
			If Not (IsSame1 Or IsSame2) Then Break
		End;
		If IsSame1 Then Result := Result + Manual[I].Value;
		If IsSame2 Then Result := Result + Manual[I].Value
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

Function Search2(Player, Depth: Byte; X, Y: Integer; CurValue: Longint): Longint;
Var
	I, J, K, L, NumValue: Integer;
	V, Max: Longint;
	VX, VY: Array[1..MaxNumValue] Of Integer;
	MaxValue: Array[1..MaxNumValue] Of Longint;
Begin
	If Depth > MaxDepth Then
	Begin
		If Depth Mod 2 = 1 Then Search2 := CalcValue(Player, X, Y) Else Search2 := -CalcValue(Player, X, Y)
	End
	Else
	Begin
		NumValue := MaxDepth - Depth + 2;
		If NumValue > MaxNumValue Then NumValue := MaxNumValue;
		For I := 1 To NumValue Do MaxValue[I] := -MaxLongint;
		For J := 0 To 14 Do
			For I := 0 To 14 Do
				If (Chessboard[I, J] = 0) And ExistChessman2(I, J) Then
				Begin
					Chessboard[I, J] := Player;
					If Lo(CheckWin(Player, I, J, X, Y)) = 3 - Player Then
						V := -MaxLongint
					Else
						V := CalcValue(Player, I, J);
					For K := 1 To NumValue Do
						If V > MaxValue[K] Then
						Begin
							For L := NumValue - Depth DownTo K Do
							Begin
								MaxValue[L + 1] := MaxValue[L];
								VX[L + 1] := VX[L];
								VY[L + 1] := VY[L]
							End;
							MaxValue[K] := V;
							VX[K] := I;
							VY[K] := J;
							Break
						End;
					Chessboard[I, J] := cmNone
				End;
		If MaxValue[1] >= 900000 Then
		Begin
			Search2 := CurValue;
			Exit
		End;
		If MaxValue[1] = -MaxLongint Then
		Begin
			If Odd(Depth) Then Search2 := -MaxLongint Else Search2 := MaxLongint;
			Exit
		End;
		Max := -MaxLongint;
		For I := 1 To NumValue - Depth + 1 Do
		Begin
			If MaxValue[I] <> -MaxLongint Then
			Begin
				If (I >= NumValue - Depth) And (MaxValue[I] < 0) Then Break;
				Chessboard[VX[I], VY[I]] := Player;
				V := Search2(3 - Player, Depth + 1, VX[I], VY[I], MaxValue[I]);
				Chessboard[VX[I], VY[I]] := 0;
				If V > Max Then Max := V
			End
		End;
		If Odd(Depth) Then Search2 := Max Else Search2 := -Max;
		If Max = -MaxLongint Then Search2 := CurValue
	End
End;

Procedure DrawChessman(Var Window: TWindow; X, Y, Chessman: Integer);
Var
	Flag: Boolean;
Begin
	If Chessman = cmNone Then
	Begin
		Flag := True;
		If (X = 7) And (Y = 7) Then
		Begin
			Flag := False;
			ShowPicture(Window, '棋盘1', X * 24 + 23, 344 - Y * 24)
		End;
		If ((X = 3) And (Y = 3)) Or ((X = 3) And (Y = 11)) Or ((X = 11) And (Y = 3)) Or ((X = 11) And (Y = 11)) Then
		Begin
			Flag := False;
			ShowPicture(Window, '棋盘1', X * 24 + 23, 344 - Y * 24)
		End;
		If (X = 0) And (Y = 0) Then
		Begin
			Flag := False;
			ShowPicture(Window, '棋盘2', X * 24 + 23, 344 - Y * 24)
		End;
		If (X = 14) And (Y = 0) Then
		Begin
			Flag := False;
			ShowPicture(Window, '棋盘3', X * 24 + 23, 344 - Y * 24)
		End;
		If (X = 0) And (Y = 14) Then
		Begin
			Flag := False;
			ShowPicture(Window, '棋盘4', X * 24 + 23, 344 - Y * 24)
		End;
		If (X = 14) And (Y = 14) Then
		Begin
			Flag := False;
			ShowPicture(Window, '棋盘5', X * 24 + 23, 344 - Y * 24)
		End;
		If Flag And (X = 0) Then
		Begin
			Flag := False;
			ShowPicture(Window, '棋盘6', X * 24 + 23, 344 - Y * 24)
		End;
		If Flag And (X = 14) Then
		Begin
			Flag := False;
			ShowPicture(Window, '棋盘7', X * 24 + 23, 344 - Y * 24)
		End;
		If Flag And (Y = 0) Then
		Begin
			Flag := False;
			ShowPicture(Window, '棋盘8', X * 24 + 23, 344 - Y * 24)
		End;
		If Flag And (Y = 14) Then
		Begin
			Flag := False;
			ShowPicture(Window, '棋盘9', X * 24 + 23, 344 - Y * 24)
		End;
		If Flag Then ShowPicture(Window, '棋盘0', X * 24 + 23, 344 - Y * 24)
	End;
	If Chessman = cmBlack Then ShowPicture(Window, '黑色棋子', X * 24 + 23, 344 - Y * 24);
	If Chessman = cmWhite Then ShowPicture(Window, '白色棋子', X * 24 + 23, 344 - Y * 24)
End;

Procedure DrawSquareCursor(Var Window: TWindow; X, Y: Integer; Var P: Pointer);
Const
	Left = 31;
	Bottom = 352;
Begin
	If Assigned(P) Then
	Begin
		PutPictureWnd(Window, P, Left + X * 24 - 10, Bottom - Y * 24 - 10);
		FreeMemory(P);
		P := Nil
	End
	Else
	Begin
		P := GetPictureWnd(Window, Left + X * 24 - 10, Bottom - Y * 24 - 10, 21, 21);
		LineWnd(Window, X * 24 + 21, 342 - Y * 24, X * 24 + 25, 342 - Y * 24, clBlack, SolidLn, 0, 1);
		LineWnd(Window, X * 24 + 41, 342 - Y * 24, X * 24 + 37, 342 - Y * 24, clBlack, SolidLn, 0, 1);
		LineWnd(Window, X * 24 + 21, 362 - Y * 24, X * 24 + 25, 362 - Y * 24, clBlack, SolidLn, 0, 1);
		LineWnd(Window, X * 24 + 41, 362 - Y * 24, X * 24 + 37, 362 - Y * 24, clBlack, SolidLn, 0, 1);
		LineWnd(Window, X * 24 + 21, 342 - Y * 24, X * 24 + 21, 346 - Y * 24, clBlack, SolidLn, 0, 1);
		LineWnd(Window, X * 24 + 21, 362 - Y * 24, X * 24 + 21, 358 - Y * 24, clBlack, SolidLn, 0, 1);
		LineWnd(Window, X * 24 + 41, 342 - Y * 24, X * 24 + 41, 346 - Y * 24, clBlack, SolidLn, 0, 1);
		LineWnd(Window, X * 24 + 41, 362 - Y * 24, X * 24 + 41, 358 - Y * 24, clBlack, SolidLn, 0, 1)
	End
End;

Procedure ComputerMove2(Player: Integer; Var X, Y: Integer);
Var
	I, J, K, L: Integer;
	V, Max: Longint;
	MoveX, MoveY, ValueX, ValueY: Array[1..MaxNumValue] Of Integer;
	SearchValue, MaxValue: Array[1..MaxNumValue] Of Longint;
Begin
	For I := 1 To MaxNumValue Do MaxValue[I] := -MaxLongint;
	For J := 0 To 14 Do
		For I := 0 To 14 Do
			If (Chessboard[I, J] = cmNone) And ExistChessman2(I, J) Then
			Begin
				Chessboard[I, J] := Player;
				K := Lo(CheckWin(Player, I, J, X, Y));
				If K = Player Then
				Begin
					X := I;
					Y := J;
					Exit
				End;
				If K = 3 - Player Then V := -MaxLongint;
				If K = cmNone Then V := CalcValue(Player, I, J);
				For K := 1 To MaxNumValue Do
					If V > MaxValue[K] Then
					Begin
						For L := MaxNumValue - 1 DownTo K Do
						Begin
							MaxValue[L + 1] := MaxValue[L];
							ValueX[L + 1] := ValueX[L];
							ValueY[L + 1] := ValueY[L]
						End;
						MaxValue[K] := V;
						ValueX[K] := I;
						ValueY[K] := J;
						Break
					End;
				Chessboard[I, J] := cmNone
			End;
	If MaxValue[1] = -MaxLongint Then
	Begin
		Repeat
			X := Random(15);
			Y := Random(15)
		Until Chessboard[X, Y] = cmNone;
		Exit
	End;
	Max := -MaxLongint;
	For I := 1 To MaxNumValue Do SearchValue[I] := -MaxLongint;
	For I := 1 To MaxNumValue Do
	Begin
		If MaxValue[I] <> -MaxLongint Then
		Begin
			If (I >= MaxNumValue - 1) And (MaxValue[I] < 0) Then Break;
			Chessboard[ValueX[I], ValueY[I]] := Player;
			V := Search2(3 - Player, 2, ValueX[I], ValueY[I], MaxValue[I]);
			Chessboard[ValueX[I], ValueY[I]] := 0;
			For K := 1 To MaxNumValue Do
				If V > SearchValue[K] Then
				Begin
					For L := MaxNumValue - 1 DownTo K Do
					Begin
						SearchValue[L + 1] := SearchValue[L];
						MoveX[L + 1] := MoveX[L];
						MoveY[L + 1] := MoveY[L]
					End;
					SearchValue[K] := V;
					MoveX[K] := ValueX[K];
					MoveY[K] := ValueY[K];
					Break
				End
		End
	End;
	For K := 2 To MaxNumValue Do If SearchValue[K] < SearchValue[K - 1] Then Break;
	L := Random(K - 1) + 1;
	X := MoveX[L];
	Y := MoveY[L]
End;

Procedure GetInput(Var Window: TWindow; Player: Integer; Var X, Y: Integer);
Var
	InKey: Char;
	I, J, T: Integer;
	P: Pointer;
	Regs: Registers;
	ValueTable: Array[0..14, 0..14] Of Longint;
Begin
	P := Nil;
	Case PlayerInfo[Player].InputDevice Of
		idMouse:
		Begin
			Regs.AX := $0005;
			Regs.BX := $0000;
			Intr($33, Regs);
			Regs.AX := $0001;
			Intr($33, Regs);
			While True Do
			Begin
				Regs.AX := $0005;
				Regs.BX := $0000;
				Intr($33, Regs);
				If Regs.BX <> 0 Then
				Begin
					X := (Integer(Regs.CX) - Window.Left + 5) Div 24 - 1;
					Y := (388 - Integer(Regs.DX) + Window.Top) Div 24 - 1;
					If (X >= 0) And (X < 15) And (Y >= 0) And (Y < 15) Then
						If Chessboard[X, Y] = cmNone Then Break
				End;
				If KeyPressed Then
				Begin
					InKey := ReadKey;
					If InKey = #0 Then ReadKey;
					If (InKey = #27) And (GetKeyboardFlag = kfNone) Then
					Begin
						X := -1;
						Y := -1;
						Regs.AX := $0002;
						Intr($33, Regs);
						If ShowMessage('此时退出比赛将被判负。' + CrLf + '真要退出吗？', mbYesNo Or mbIconQuestion, 1) = idYes Then
						Begin
							Regs.AX := $0001;
							Intr($33, Regs);
							Break
						End;
						Regs.AX := $0001;
						Intr($33, Regs)
					End
				End
			End;
			Regs.AX := $0002;
			Intr($33, Regs)
		End;
		idArrow:
		Begin
			DrawSquareCursor(Window, X, Y, P);
			While True Do
			Begin
				InKey := ReadKey;
				DrawSquareCursor(Window, X, Y, P);
				Case InKey Of
					#0:
					Case ReadKey Of
						#77: If (X < 14) And (GetKeyboardFlag = kfNone) Then Inc(X);
						#75: If (X > 0) And (GetKeyboardFlag = kfNone) Then Dec(X);
						#72: If (Y < 14) And (GetKeyboardFlag = kfNone) Then Inc(Y);
						#80: If (Y > 0) And (GetKeyboardFlag = kfNone) Then Dec(Y)
					End;
					#13: If (Chessboard[X, Y] = cmNone) And (GetKeyboardFlag = kfNone) Then Break;
					#27:
					If GetKeyboardFlag = kfNone Then
						If ShowMessage('此时退出比赛将被判负。' + CrLf + '真要退出吗？', mbYesNo Or mbIconQuestion, 1) = idYes Then
						Begin
							X := -1;
							Y := -1;
							Exit
						End
				End;
				DrawSquareCursor(Window, X, Y, P)
			End
		End;
		idLetter:
		Begin
			DrawSquareCursor(Window, X, Y, P);
			While True Do
			Begin
				InKey := UpCase(ReadKey);
				DrawSquareCursor(Window, X, Y, P);
				Case InKey Of
					#0: ReadKey;
					#32: If (Chessboard[X, Y] = cmNone) And (GetKeyboardFlag = kfNone) Then Break;
					'D': If (X < 14) And (GetKeyboardFlag = kfNone) Then Inc(X);
					'A': If (X > 0) And (GetKeyboardFlag = kfNone) Then Dec(X);
					'W': If (Y < 14) And (GetKeyboardFlag = kfNone) Then Inc(Y);
					'S': If (Y > 0) And (GetKeyboardFlag = kfNone) Then Dec(Y);
					#27:
					If GetKeyboardFlag = kfNone Then
						If ShowMessage('此时退出比赛将被判负。' + CrLf + '真要退出吗？', mbYesNo Or mbIconQuestion, 1) = idYes Then
						Begin
							X := -1;
							Y := -1;
							Exit
						End
				End;
				DrawSquareCursor(Window, X, Y, P)
			End
		End;
		idComputer:
		Begin
			T := 0;
			For I := 0 To 14 Do
				For J := 0 To 14 Do
					If Chessboard[I, J] <> cmNone Then Inc(T);
			If (T = 1) Or (T = 2) Then
			Begin
				Repeat
					X := Random(5) + 5;
					Y := Random(5) + 5
				Until (Chessboard[X, Y] = cmNone) And ExistChessman2(X, Y);
				Exit
			End;
			If Player = cmBlack Then
			Begin
				For I := 0 To 14 Do
					For J := 0 To 14 Do
						Map[I + 1, J + 1] := Chessboard[I, J]
			End
			Else
			Begin
				For I := 0 To 14 Do
					For J := 0 To 14 Do
						Case Chessboard[I, J] Of
							cmNone: Map[I + 1, J + 1] := 0;
							cmBlack: Map[I + 1, J + 1] := 2;
							cmWhite: Map[I + 1, J + 1] := 1
						End
			End;
			ComputerMove1(X, Y);
			Chessboard[X, Y] := Player;
			If Lo(CheckWin(Player, X, Y, X, Y)) = 3 - Player Then
			Begin
				Chessboard[X, Y] := cmNone;
				ComputerMove2(Player, X, Y)
			End;
			Chessboard[X, Y] := cmNone
		End
	End
End;

Function Play(Var Window: TWindow): Integer;
Var
	I, J, T, X, Y: Integer;
	Regs: Registers;
Begin
	Play := cmNone;
	For I := -5 To 19 Do
		For J := -5 To 19 Do
			If (I >= 0) And (I < 15) And (J >= 0) And (J < 15) Then
				Chessboard[I, J] := cmNone
			Else
				Chessboard[I, J] := cmBorder;
	For I := 1 To 226 Do
	Begin
		GameRecord[I, 1] := -1;
		GameRecord[I, 2] := -1
	End;
	StartFlag := True;
	FillChar(Map, SizeOf(Map), 0);
	X := 7;
	Y := 7;
	Chessboard[X, Y] := cmBlack;
	DrawChessman(Window, X, Y, cmBlack);
	GameRecord[1, 1] := X;
	GameRecord[1, 2] := Y;
	Regs.AX := $0004;
	Regs.CX := Window.Left + 31 + X * 24;
	Regs.DX := Window.Top + 352 - Y * 24;
	Intr($33, Regs);
	For I := 2 To 225 Do
	Begin
		If (PlayerInfo[cmBlack].InputDevice <> idMouse) Or (PlayerInfo[cmWhite].InputDevice <> idMouse) Then
		Begin
			Regs.AX := $0004;
			Regs.CX := Window.Left + 31 + X * 24;
			Regs.DX := Window.Top + 352 - Y * 24;
			Intr($33, Regs)
		End;
		If Odd(I) Then
		Begin
			T := cmBlack;
			SetStatusLine('第' + IntToStr((I + 1) Div 2) + '手，' + PlayerInfo[cmBlack].Name + '走棋。')
		End
		Else
		Begin
			T := cmWhite;
			SetStatusLine('第' + IntToStr((I + 1) Div 2) + '手，' + PlayerInfo[cmWhite].Name + '走棋。')
		End;
		GetInput(Window, T, X, Y);
		If (X < 0) Or (Y < 0) Then
		Begin
			Play := T Mod 2 + 1025;
			Exit
		End;
		Chessboard[X, Y] := T;
		DrawChessman(Window, X, Y, T);
		GameRecord[I, 1] := X;
		GameRecord[I, 2] := Y;
		T := CheckWin(T, X, Y, X, Y);
		If T <> 0 Then
		Begin
			Play := T;
			Exit
		End
	End
End;

End.