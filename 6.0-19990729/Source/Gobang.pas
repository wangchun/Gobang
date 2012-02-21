{**********************************************************}
{                                                          }
{         五子棋   版本6.1   王纯   1999年10月20日         }
{                                                          }
{    Gobang   Version 6.1   Wang Chun   October 20 1999    }
{                                                          }
{**********************************************************}

{$M 32768, 0, 8192}
{$G+}
Program Gobang;

Uses
	Crt, Dos, Strings, Graph, Printer, Graphics, PlayGame;

Const
	LastUpdate = '1999年10月20日';

Procedure Game(NumPlayer: Integer);
Var
	InKey: Char;
	Flag, FirstFlag, BlackFlag, WhiteFlag: Boolean;
	I, J, Result: Integer;
	D1, D2, D3, D4, T1, T2, T3, T4, Year, Month, Day, DayOfWeek, Hour, Minute, Second, Sec100, LastDraw: Word;
	T: TPlayerInfo;
	History: THistory;
	Window: TWindow;
	S, Str: String;
	Manual: Text;
	F: File Of THistory;
	ManualMap: Array[0..14, -1..1] Of String[75];
Begin
	If NumPlayer = 1 Then
	Begin
		Repeat
			S := InputBox('请输入你的姓名：', '', Title, 240, 186, 160, 108, wsBorder Or wsCaption Or wsSize, 24, True, True);
			If S = '计算机' Then
				ShowMessage('不能使用“计算机”作为你的姓名。', mbOK Or mbIconExclamation, 0);
			If S = '' Then
				ShowMessage('没有名字可不行！', mbOK Or mbIconExclamation, 0)
		Until (S <> '计算机') And (S <> '');
		If S = #0 Then Exit;
		PlayerInfo[cmBlack].Name := '计算机';
		PlayerInfo[cmBlack].InputDevice := idComputer;
		PlayerInfo[cmWhite].Name := S;
		PlayerInfo[cmWhite].InputDevice := idMouse;
		Window.Caption := '请选择先行者';
		Window.Style := wsBorder Or wsCaption Or wsSize;
		Window.Color := clDefault;
		Window.Width := 120;
		If Length(PlayerInfo[cmBlack].Name) * 8 + 20 > Window.Width Then
			Window.Width := Length(PlayerInfo[cmBlack].Name) * 8 + 20;
		If Length(PlayerInfo[cmWhite].Name) * 8 + 20 > Window.Width Then
			Window.Width := Length(PlayerInfo[cmWhite].Name) * 8 + 20;
		Window.Height := 82;
		Window.Left := (DesktopWindow.Width - Window.Width) Div 2;
		Window.Top := (DesktopWindow.Height - Window.Height) Div 2;
		CreateWindow(Window);
		FirstFlag := True;
		DrawButton(Window, PlayerInfo[cmBlack].Name, 0, 0, Window.ClientWidth, 26, False, Flag);
		DrawButton(Window, PlayerInfo[cmWhite].Name, 0, 26, Window.ClientWidth, 26, False, Not Flag);
		While True Do
		Begin
			Flag := False;
			ClearKeyboardBuffer;
			Case ReadKey Of
				#0:
				Case ReadKey Of
					#15: If GetKeyboardFlag = kfShift Then Flag := True;
					#72, #80: If GetKeyboardFlag = kfNone Then Flag := True
				End;
				#9: If GetKeyboardFlag = kfNone Then Flag := True;
				#13: If GetKeyboardFlag = kfNone Then Break;
				#27:
				If GetKeyboardFlag = kfNone Then
				Begin
					DestroyWindow(Window);
					Exit
				End;
				#32:
				If GetKeyboardFlag = kfNone Then
				Begin
					If FirstFlag Then
						DrawButton(Window, PlayerInfo[cmBlack].Name, 0, 0, Window.ClientWidth, 26, True, True)
					Else
						DrawButton(Window, PlayerInfo[cmWhite].Name, 0, 26, Window.ClientWidth, 26, True, True);
					While Port[$60] <> $B9 Do ClearKeyboardBuffer;
					If FirstFlag Then
						DrawButton(Window, PlayerInfo[cmBlack].Name, 0, 0, Window.ClientWidth, 26, False, True)
					Else
						DrawButton(Window, PlayerInfo[cmWhite].Name, 0, 26, Window.ClientWidth, 26, False, True);
					Break
				End
			End;
			If Flag Then
			Begin
				FirstFlag := Not FirstFlag;
				DrawButton(Window, PlayerInfo[cmBlack].Name, 0, 0, Window.ClientWidth, 26, False, FirstFlag);
				DrawButton(Window, PlayerInfo[cmWhite].Name, 0, 26, Window.ClientWidth, 26, False, Not FirstFlag);
			End
		End;
		DestroyWindow(Window);
		If Not FirstFlag Then
		Begin
			T := PlayerInfo[cmBlack];
			PlayerInfo[cmBlack] := PlayerInfo[cmWhite];
			PlayerInfo[cmWhite] := T
		End
	End
	Else
	Begin
		Repeat
			Repeat
				S := InputBox('请输入黑方姓名：', '', Title, 240, 186, 160, 108, wsBorder Or wsCaption Or wsSize, 24, True, True);
				If S = '计算机' Then
					ShowMessage('不能使用“计算机”作为黑方姓名。', mbOK Or mbIconExclamation, 0);
				If S = '' Then
					ShowMessage('没有名字可不行！', mbOK Or mbIconExclamation, 0)
			Until (S <> '计算机') And (S <> '');
			If S = #0 Then Exit;
			PlayerInfo[cmBlack].Name := S;
			PlayerInfo[cmBlack].InputDevice := idMouse;
			Repeat
				S := InputBox('请输入白方姓名：', '', Title, 240, 186, 160, 108, wsBorder Or wsCaption Or wsSize, 24, True, True);
				If S = '计算机' Then
					ShowMessage('不能使用“计算机”作为白方姓名。', mbOK Or mbIconExclamation, 0);
				If S = '' Then
					ShowMessage('没有名字可不行！', mbOK Or mbIconExclamation, 0)
			Until (S <> '计算机') And (S <> '');
			If S = #0 Then Exit;
			PlayerInfo[cmWhite].Name := S;
			PlayerInfo[cmWhite].InputDevice := idMouse;
			If PlayerInfo[cmBlack].Name = PlayerInfo[cmWhite].Name Then
				ShowMessage('黑方与白方的姓名不能相同。', mbOK Or mbIconExclamation, 0)
		Until PlayerInfo[cmBlack].Name <> PlayerInfo[cmWhite].Name
	End;
	For I := cmBlack To cmWhite Do
		If PlayerInfo[I].InputDevice <> idComputer Then
			While True Do
			Begin
				Window.Caption := '请选择' + PlayerInfo[I].Name + '的输入设备';
				Window.Style := wsBorder Or wsCaption Or wsSize;
				Window.Color := clDefault;
				Window.Width := Length(Window.Caption) * 8 + 24;
				Window.Height := 108;
				Window.Left := (DesktopWindow.Width - Window.Width) Div 2;
				Window.Top := (DesktopWindow.Height - Window.Height) Div 2;
				CreateWindow(Window);
				DrawButton(Window, DeviceName[idMouse], 0, 0, Window.ClientWidth, 26, False, PlayerInfo[I].InputDevice = idMouse);
				DrawButton(Window, DeviceName[idArrow], 0, 26, Window.ClientWidth, 26, False, PlayerInfo[I].InputDevice = idArrow);
				DrawButton(Window, DeviceName[idLetter], 0, 52, Window.ClientWidth, 26, False, PlayerInfo[I].InputDevice = idLetter);
				While True Do
				Begin
					Flag := False;
					ClearKeyboardBuffer;
					Case ReadKey Of
						#0:
						Begin
							Case ReadKey Of
								#15: If GetKeyboardFlag = kfShift Then PlayerInfo[I].InputDevice := (PlayerInfo[I].InputDevice + 1) Mod 3 + 1;
								#72: If GetKeyboardFlag = kfNone Then PlayerInfo[I].InputDevice := (PlayerInfo[I].InputDevice + 1) Mod 3 + 1;
								#80: If GetKeyboardFlag = kfNone Then PlayerInfo[I].InputDevice := PlayerInfo[I].InputDevice Mod 3 + 1
							End
						End;
						#9: If GetKeyboardFlag = kfNone Then PlayerInfo[I].InputDevice := PlayerInfo[I].InputDevice Mod 3 + 1;
						#13: If GetKeyboardFlag = kfNone Then Break;
						#27:
						If GetKeyboardFlag = kfNone Then
						Begin
							DestroyWindow(Window);
							Exit
						End;
						#32:
						If GetKeyboardFlag = kfNone Then
						Begin
							Case PlayerInfo[I].InputDevice Of
								idMouse: DrawButton(Window, DeviceName[idMouse], 0, 0, Window.ClientWidth, 26, True, True);
								idArrow: DrawButton(Window, DeviceName[idArrow], 0, 26, Window.ClientWidth, 26, True, True);
								idLetter: DrawButton(Window, DeviceName[idLetter], 0, 52, Window.ClientWidth, 26, True, True);
							End;
							While Port[$60] <> $B9 Do ClearKeyboardBuffer;
							Case PlayerInfo[I].InputDevice Of
								idMouse: DrawButton(Window, DeviceName[idMouse], 0, 0, Window.ClientWidth, 26, False, True);
								idArrow: DrawButton(Window, DeviceName[idArrow], 0, 26, Window.ClientWidth, 26, False, True);
								idLetter: DrawButton(Window, DeviceName[idLetter], 0, 52, Window.ClientWidth, 26, False, True);
							End;
							Break
						End
					End;
					DrawButton(Window, DeviceName[idMouse], 0, 0, Window.ClientWidth, 26, False, PlayerInfo[I].InputDevice = idMouse);
					DrawButton(Window, DeviceName[idArrow], 0, 26, Window.ClientWidth, 26, False, PlayerInfo[I].InputDevice = idArrow);
					DrawButton(Window, DeviceName[idLetter], 0, 52, Window.ClientWidth, 26, False, PlayerInfo[I].InputDevice = idLetter)
				End;
				DestroyWindow(Window);
				If (Not MouseEnabled) And (PlayerInfo[I].InputDevice = idMouse) Then
					ShowMessage('未安装鼠标驱动程序。', mbOK Or mbIconExclamation, 0)
				Else
					Break
			End;
	For I := 63 DownTo 0 Do
	Begin
		SetDefaultPalette(I);
		MicrosecondDelay(5000)
	End;
	Window.Caption := '';
	Window.Style := wsNone;
	Window.Color := clDefault;
	Window.Width := 384;
	Window.Height := 384;
	Window.Left := (DesktopWindow.Width - Window.Width) Div 2;
	Window.Top := (DesktopWindow.Height - Window.Height) Div 2;
	CreateWindow(Window);
	ShowPicture(Window, '棋盘', 0, 0);
	For I := 0 To 63 Do
	Begin
		SetDefaultPalette(I);
		MicrosecondDelay(5000)
	End;
	GetDate(D1, D2, D3, D4);
	GetTime(T1, T2, T3, T4);
	Result := Play(Window);
	Case Hi(Result) Of
		0: S := '';
		1: S := PlayerInfo[Lo(Result) Mod 2 + 1].Name + '长连，';
		2: S := PlayerInfo[Lo(Result) Mod 2 + 1].Name + '双三禁手，';
		3: S := PlayerInfo[Lo(Result) Mod 2 + 1].Name + '双四禁手，';
		4: S := PlayerInfo[Lo(Result) Mod 2 + 1].Name + '认输，';
	End;
	Case Lo(Result) Of
		cmNone: S := S + '平局';
		cmBlack: S := S + PlayerInfo[Lo(Result)].Name + '赢了';
		cmWhite: S := S + PlayerInfo[Lo(Result)].Name + '赢了'
	End;
	SetStatusLine(S + ' - 按<ESC>键继续');
	GetTime(Hour, Minute, Second, Sec100);
	LastDraw := Sec100;
	Flag := False;
	Repeat
		InKey := #0;
		GetTime(Hour, Minute, Second, Sec100);
		If (Sec100 + 100 - LastDraw) Mod 100 >= 50 Then
		Begin
			If Flag Then
			Begin
				For I := 0 To 14 Do
					For J := 0 To 14 Do
						If FlagMap[I, J] Then DrawChessman(Window, I, J, cmNone)
			End
			Else
			Begin
				For I := 0 To 14 Do
					For J := 0 To 14 Do
						If FlagMap[I, J] Then DrawChessman(Window, I, J, Chessboard[I, J])
			End;
			Flag := Not Flag;
			LastDraw := Sec100
		End;
		If KeyPressed Then
		Begin
			InKey := ReadKey;
			If InKey = #0 Then ReadKey
		End
	Until (InKey = #27) And (GetKeyboardFlag = kfNone);
	For I := 0 To 14 Do
		For J := 0 To 14 Do
			If FlagMap[I, J] Then DrawChessman(Window, I, J, Chessboard[I, J]);
	SetStatusLine(#0);
	If ShowMessage('要将本次比赛保存到棋谱文件' + ManualFile + '吗？', mbYesNo Or mbIconQuestion, 0) = idYes Then
	Begin
		Assign(Manual, ManualFile);
		If FSearch(ManualFile, '') = '' Then
		Begin
			Rewrite(Manual);
			Writeln(Manual, Title + '棋谱文件');
			Writeln(Manual)
		End
		Else
		Begin
			Append(Manual)
		End;
		Writeln(Manual, '黑方：' + PlayerInfo[cmBlack].Name);
		Writeln(Manual, '白方：' + PlayerInfo[cmWhite].Name);
		Str := '比赛时间：';
		Str := Str + IntToStr(D1) + '年' + IntToStr(D2) + '月' + IntToStr(D3) + '日，';
		Str := Str + '星期' + Copy('日一二三四五六', D4 * 2 + 1, 2) + '  ';
		Str := Str + IntToStr(T1) + '时';
		If T2 >= 10 Then Str := Str + IntToStr(T2) + '分' Else Str := Str + '0' + IntToStr(T2) + '分';
		If T3 >= 10 Then Str := Str + IntToStr(T3) + '.' Else Str := Str + '0' + IntToStr(T3) + '.';
		If T4 >= 10 Then Str := Str + IntToStr(T4) + '秒' Else Str := Str + '0' + IntToStr(T4) + '秒';
		Writeln(Manual, Str);
		For I := 1 To 226 Do
		Begin
			If (GameRecord[I, 1] < 0) Or (GameRecord[I, 2] < 0) Then Break;
			If I <> 1 Then Write(Manual, ' ');
			Write(Manual, Chr(GameRecord[I, 1] + 65) + IntToStr(GameRecord[I, 2]))
		End;
		Writeln(Manual);
		Writeln(Manual, S);
		Writeln(Manual);
		Close(Manual)
	End;
	Assign(F, HistoryFile);
	If FSearch(HistoryFile, '') = '' Then
	Begin
		Rewrite(F);
		FillChar(History.Name, SizeOf(History.Name), 0);
		History.Name := '计算机';
		FillChar(History.Result, SizeOf(History.Result), 0);
		Write(F, History);
		Seek(F, 0)
	End
	Else
	Begin
		Reset(F)
	End;
	BlackFlag := False;
	WhiteFlag := False;
	For I := 0 To FileSize(F) - 1 Do
	Begin
		Read(F, History);
		If History.Name = PlayerInfo[cmBlack].Name Then
		Begin
			Case Lo(Result) Of
				cmBlack: Inc(History.Result[1]);
				cmNone: Inc(History.Result[0]);
				cmWhite: Inc(History.Result[-1])
			End;
			Seek(F, FilePos(F) - 1);
			Write(F, History);
			BlackFlag := True
		End;
		If History.Name = PlayerInfo[cmWhite].Name Then
		Begin
			Case Lo(Result) Of
				cmBlack: Inc(History.Result[-1]);
				cmNone: Inc(History.Result[0]);
				cmWhite: Inc(History.Result[1])
			End;
			Seek(F, FilePos(F) - 1);
			Write(F, History);
			WhiteFlag := True
		End
	End;
	If Not BlackFlag Then
	Begin
		FillChar(History.Name, SizeOf(History.Name), 0);
		History.Name := PlayerInfo[cmBlack].Name;
		FillChar(History.Result, SizeOf(History.Result), 0);
		Case Lo(Result) Of
			cmBlack: History.Result[1] := 1;
			cmNone: History.Result[0] := 1;
			cmWhite: History.Result[-1] := 1
		End;
		Write(F, History)
	End;
	If Not WhiteFlag Then
	Begin
		FillChar(History.Name, SizeOf(History.Name), 0);
		History.Name := PlayerInfo[cmWhite].Name;
		FillChar(History.Result, SizeOf(History.Result), 0);
		Case Lo(Result) Of
			cmBlack: History.Result[-1] := 1;
			cmNone: History.Result[0] := 1;
			cmWhite: History.Result[1] := 1
		End;
		Write(F, History)
	End;
	Close(F);
	If ShowMessage('是否需要游戏将刚才的比赛打印为棋谱？', mbYesNo Or mbIconQuestion, 1) = idYes Then
	Begin
		ShowMessage('准备好后按“确定”按钮开始打印，如果使用中文打印机，请关闭打印机的中文打印功能。', mbOK Or mbIconAsterisk, 0);
		If PlayerInfo[cmBlack].InputDevice = idComputer Then PlayerInfo[cmBlack].Name := 'COMPUTER';
		If PlayerInfo[cmWhite].InputDevice = idComputer Then PlayerInfo[cmWhite].Name := 'COMPUTER';
		If PlayerInfo[cmBlack].InputDevice <> idComputer Then
		Begin
			Flag := PlayerInfo[cmBlack].Name = 'COMPUTER';
			For I := 1 To Length(PlayerInfo[cmBlack].Name) Do
				If Ord(PlayerInfo[cmBlack].Name[I]) > 160 Then Flag := True;
			While Flag Do
			Begin
				Repeat
					S := InputBox('黑方的姓名不能被正确打印。', PlayerInfo[cmBlack].Name, Title, 240, 178, 160, 124, wsBorder Or wsCaption Or
						wsSize, 24, True, False);
					If S = 'COMPUTER' Then
						ShowMessage('不能使用“COMPUTER”作为你的姓名。', mbOK Or mbIconExclamation, 0);
					If S = '' Then
						ShowMessage('没有名字可不行！', mbOK Or mbIconExclamation, 0)
				Until (S <> 'COMPUTER') And (S <> '');
				PlayerInfo[cmBlack].Name := S;
				Flag := PlayerInfo[cmBlack].Name = 'COMPUTER';
				For I := 1 To Length(PlayerInfo[cmBlack].Name) Do
					If Ord(PlayerInfo[cmBlack].Name[I]) > 160 Then Flag := True
			End
		End;
		If PlayerInfo[cmWhite].InputDevice <> idComputer Then
		Begin
			Flag := PlayerInfo[cmWhite].Name = 'COMPUTER';
			For I := 1 To Length(PlayerInfo[cmWhite].Name) Do
				If Ord(PlayerInfo[cmWhite].Name[I]) > 160 Then Flag := True;
			While Flag Do
			Begin
				Repeat
					S := InputBox('白方的姓名不能被正确打印。', PlayerInfo[cmWhite].Name, Title, 240, 178, 160, 124, wsBorder Or wsCaption Or
						wsSize, 24, True, False);
					If S = 'COMPUTER' Then
						ShowMessage('不能使用“COMPUTER”作为你的姓名。', mbOK Or mbIconExclamation, 0);
					If S = '' Then
						ShowMessage('没有名字可不行！', mbOK Or mbIconExclamation, 0)
				Until (S <> 'COMPUTER') And (S <> '');
				PlayerInfo[cmWhite].Name := S;
				Flag := PlayerInfo[cmWhite].Name = 'COMPUTER';
				For I := 1 To Length(PlayerInfo[cmWhite].Name) Do
					If Ord(PlayerInfo[cmWhite].Name[I]) > 160 Then Flag := True
			End
		End;
		ManualMap[0, -1] := '  �  ';
		For I := 1 To 13 Do ManualMap[0, -1] := ManualMap[0, -1] + '  �  ';
		ManualMap[0, -1] := ManualMap[0, -1] + '  �  ';
		ManualMap[0, 0] := '  韧�';
		For I := 1 To 13 Do ManualMap[0, 0] := ManualMap[0, 0] + '屯贤�';
		ManualMap[0, 0] := ManualMap[0, 0] + '屯�  ';
		ManualMap[0, 1] := '';
		For I := 0 To 14 Do ManualMap[0, 1] := ManualMap[0, 1] + '     ';
		For I := 1 To 13 Do
		Begin
			ManualMap[I, -1] := '  �  ';
			For J := 1 To 13 Do ManualMap[I, -1] := ManualMap[I, -1] + '  �  ';
			ManualMap[I, -1] := ManualMap[I, -1] + '  �  ';
			ManualMap[I, 0] := '  悄�';
			For J := 1 To 13 Do ManualMap[I, 0] := ManualMap[I, 0] + '哪拍�';
			ManualMap[I, 0] := ManualMap[I, 0] + '哪�  ';
			ManualMap[I, 1] := '  �  ';
			For J := 1 To 13 Do ManualMap[I, 1] := ManualMap[I, 1] + '  �  ';
			ManualMap[I, 1] := ManualMap[I, 1] + '  �  ';
		End;
		ManualMap[14, -1] := '';
		For I := 0 To 14 Do ManualMap[14, -1] := ManualMap[14, -1] + '     ';
		ManualMap[14, 0] := '  赏�';
		For I := 1 To 13 Do ManualMap[14, 0] := ManualMap[14, 0] + '屯淹�';
		ManualMap[14, 0] := ManualMap[14, 0] + '屯�  ';
		ManualMap[14, 1] := '  �  ';
		For I := 1 To 13 Do ManualMap[14, 1] := ManualMap[14, 1] + '  �  ';
		ManualMap[14, 1] := ManualMap[14, 1] + '  �  ';
		For I := 1 To 226 Do
		Begin
			If (GameRecord[I, 1] < 0) Or (GameRecord[I, 2] < 0) Then Break;
			If Odd(I) Then
			Begin
				Case ManualMap[GameRecord[I, 2], -1, GameRecord[I, 1] * 5 + 3] Of
					' ': Str := '赏屯�';
					'�': Str := '赏贤�';
					'�': Str := '赏释�'
				End;
				Delete(ManualMap[GameRecord[I, 2], -1], GameRecord[I, 1] * 5 + 1, 5);
				Insert(Str, ManualMap[GameRecord[I, 2], -1], GameRecord[I, 1] * 5 + 1);
				Str := IntToStr(I);
				While Length(Str) < 3 Do Str := '0' + Str;
				Case ManualMap[GameRecord[I, 2], 0, GameRecord[I, 1] * 5 + 1] Of
					' ': Str := '�' + Str;
					'�': Str := '�' + Str;
					'�': Str := '�' + Str
				End;
				Case ManualMap[GameRecord[I, 2], 0, GameRecord[I, 1] * 5 + 5] Of
					' ': Str := Str + '�';
					'�': Str := Str + '�';
					'�': Str := Str + '�'
				End;
				Delete(ManualMap[GameRecord[I, 2], 0], GameRecord[I, 1] * 5 + 1, 5);
				Insert(Str, ManualMap[GameRecord[I, 2], 0], GameRecord[I, 1] * 5 + 1);
				Case ManualMap[GameRecord[I, 2], 1, GameRecord[I, 1] * 5 + 3] Of
					' ': Str := '韧屯�';
					'�': Str := '韧淹�';
					'�': Str := '韧送�'
				End;
				Delete(ManualMap[GameRecord[I, 2], 1], GameRecord[I, 1] * 5 + 1, 5);
				Insert(Str, ManualMap[GameRecord[I, 2], 1], GameRecord[I, 1] * 5 + 1)
			End
			Else
			Begin
				Case ManualMap[GameRecord[I, 2], -1, GameRecord[I, 1] * 5 + 3] Of
					' ': Str := '谀哪�';
					'�': Str := '谀聊�';
					'�': Str := '谀心�'
				End;
				Delete(ManualMap[GameRecord[I, 2], -1], GameRecord[I, 1] * 5 + 1, 5);
				Insert(Str, ManualMap[GameRecord[I, 2], -1], GameRecord[I, 1] * 5 + 1);
				Str := IntToStr(I);
				While Length(Str) < 3 Do Str := '0' + Str;
				Case ManualMap[GameRecord[I, 2], 0, GameRecord[I, 1] * 5 + 1] Of
					' ': Str := '�' + Str;
					'�': Str := '�' + Str;
					'�': Str := '�' + Str
				End;
				Case ManualMap[GameRecord[I, 2], 0, GameRecord[I, 1] * 5 + 5] Of
					' ': Str := Str + '�';
					'�': Str := Str + '�';
					'�': Str := Str + '�'
				End;
				Delete(ManualMap[GameRecord[I, 2], 0], GameRecord[I, 1] * 5 + 1, 5);
				Insert(Str, ManualMap[GameRecord[I, 2], 0], GameRecord[I, 1] * 5 + 1);
				Case ManualMap[GameRecord[I, 2], 1, GameRecord[I, 1] * 5 + 3] Of
					' ': Str := '滥哪�';
					'�': Str := '滥履�';
					'�': Str := '滥夷�'
				End;
				Delete(ManualMap[GameRecord[I, 2], 1], GameRecord[I, 1] * 5 + 1, 5);
				Insert(Str, ManualMap[GameRecord[I, 2], 1], GameRecord[I, 1] * 5 + 1)
			End
		End;
		For I := 1 To 32 Do Write(Lst, ' ');
		Writeln(Lst, 'GOBANG  MANUAL');
		For I := 1 To 32 Do Write(Lst, ' ');
		Writeln(Lst, '==============');
		S := 'Black: ' + PlayerInfo[cmBlack].Name;
		While Length(S) < 61 Do S := S + ' ';
		S := S + '<<< LEGEND >>>';
		Writeln(Lst, S);
		S := 'White: ' + PlayerInfo[cmWhite].Name;
		While Length(S) < 58 Do S := S + ' ';
		S := S + '赏屯屯屯�  谀哪哪哪�';
		Writeln(Lst, S);
		S := 'Date: ';
		S := S + IntToStr(D1) + '-' + IntToStr(D2) + '-' + IntToStr(D3) + ', ' + Copy('SunMonTueWedThuFriSat', D4 * 3 + 1, 3);
		While Length(S) < 58 Do S := S + ' ';
		S := S + '� BLACK �  � WHITE �';
		Writeln(Lst, S);
		S := 'Time: ';
		S := S + IntToStr(T1) + ':';
		Str := IntToStr(T2);
		If Length(Str) = 1 Then Str := '0' + Str;
		S := S + Str + ':';
		Str := IntToStr(T3);
		If Length(Str) = 1 Then Str := '0' + Str;
		S := S + Str + '.';
		Str := IntToStr(T4);
		If Length(Str) = 1 Then Str := '0' + Str;
		S := S + Str;
		While Length(S) < 58 Do S := S + ' ';
		S := S + '韧屯屯屯�  滥哪哪哪�';
		Writeln(Lst, S);
		For I := 14 DownTo 0 Do
			For J := -1 To 1 Do
			Begin
				S := ManualMap[I, J];
				If J = 0 Then
				Begin
					If I < 9 Then S := ' ' + IntToStr(I + 1) + ' ' + S Else S := IntToStr(I + 1) + ' ' + S
				End
				Else
				Begin
					S := '   ' + S
				End;
				Writeln(Lst, S)
			End;
		Write(Lst, '   ');
		For I := 0 To 14 Do
			Write(Lst, '  ' + Chr(I + 65) + '  ');
		Writeln(Lst);
		Writeln(Lst);
		S := 'Result: ';
		If Lo(Result) = cmNone Then
			S := S + 'Nobody wins the game.'
		Else
			S := S + PlayerInfo[Lo(Result)].Name + ' wins the game.';
		Writeln(Lst, S);
		If Hi(Result) = 4 Then
		Begin
			If Lo(Result) = cmBlack Then Writeln(Lst, PlayerInfo[cmWhite].Name + ' breaks the game.');
			If Lo(Result) = cmWhite Then Writeln(Lst, PlayerInfo[cmBlack].Name + ' breaks the game.')
		End
		Else
		Begin
			If Lo(Result) <> cmNone Then
			Begin
				Write(Lst, 'Chessmen: ');
				Flag := False;
				For I := 0 To 14 Do
					For J := 0 To 14 Do
						If FlagMap[I, J] Then
						Begin
							If Flag Then Write(Lst, ' ') Else Flag := True;
							Write(Lst, Chr(I + 65) + IntToStr(J + 1))
						End;
				Writeln(Lst)
			End
		End;
		Writeln(Lst);
		For I := 1 To 17 Do
			Write(Lst, ' ');
		Writeln(Lst, '*** THIS MANUAL IS PRINTED BY GOBANG 6.1 ***', #12)
	End;
	For I := 63 DownTo 0 Do
	Begin
		SetDefaultPalette(I);
		MicrosecondDelay(5000)
	End;
	DestroyWindow(Window);
	For I := 0 To 63 Do
	Begin
		SetDefaultPalette(I);
		MicrosecondDelay(5000)
	End
End;

Procedure ShowHistory;
Var
	Flag: Boolean;
	InKey: Char;
	I, J, M1, M2, LineCount, TopRow, RowCount: Longint;
	History, P1, P2: PHistory;
	T: THistory;
	Window: TWindow;
	F: File;
Begin
	If FSearch(HistoryFile, '') = '' Then
	Begin
		ShowMessage('历史记录不存在。', mbOK Or mbIconHand, 0);
		Exit
	End;
	SetStatusLine('按<ESC>键返回。');
	Window.Caption := '历史记录';
	Window.Style := wsBorder Or wsCaption Or wsSize;
	Window.Color := clDefault;
	Window.Width := 474;
	Window.Height := 324;
	Window.Left := (DesktopWindow.Width - Window.Width) Div 2;
	Window.Top := (DesktopWindow.Height - Window.Height) Div 2;
	CreateWindow(Window);
	Assign(F, HistoryFile);
	Reset(F, SizeOf(THistory));
	LineCount := FileSize(F);
	History := AllocMemory(LineCount * SizeOf(THistory));
	BlockRead(F, History^, LineCount);
	Close(F);
	Repeat
		Flag := True;
		For I := 0 To LineCount - 2 Do
		Begin
			P1 := GetMemoryPtr(History, I * SizeOf(THistory));
			P2 := GetMemoryPtr(History, (I + 1) * SizeOf(THistory));
			M1 := P1^.Result[1] * 3 + P1^.Result[0];
			M2 := P2^.Result[1] * 3 + P2^.Result[0];
			If (M1 < M2) Or ((M1 = M2) And (P1^.Name > P2^.Name) And (P1^.Name <> '计算机')) Then
			Begin
				T := P1^;
				P1^ := P2^;
				P2^ := T;
				Flag := False
			End
		End;
	Until Flag;
	DrawButton(Window, '名次', 0, 0, 48, 22, False, False);
	DrawButton(Window, '姓名', 48, 0, 208, 22, False, False);
	DrawButton(Window, '赢', 256, 0, 48, 22, False, False);
	DrawButton(Window, '输', 304, 0, 48, 22, False, False);
	DrawButton(Window, '平', 352, 0, 48, 22, False, False);
	DrawButton(Window, '总分', 400, 0, 48, 22, False, False);
	DrawBorder(Window, 0, 22, Window.ClientWidth, Window.ClientHeight - 22, clWhite, True);
	Flag := True;
	TopRow := 0;
	RowCount := (Window.ClientHeight - 22) Div 18;
	While True Do
	Begin
		If Flag Then
			For I := 0 To RowCount - 1 Do
			Begin
				BarWnd(Window, 2, I * 18 + 25, Window.ClientWidth - 19, I * 18 + 40, clWhite);
				If TopRow + I < LineCount Then
				Begin
					T := PHistory(GetMemoryPtr(History, (TopRow + I) * SizeOf(THistory)))^;
					If T.Name = '计算机' Then
					Begin
						WriteStringWnd(Window, IntToStr(TopRow + I + 1), 24, I * 18 + 25, clRed, CenterText);
						WriteStringWnd(Window, T.Name, 152, I * 18 + 25, clRed, CenterText);
						WriteStringWnd(Window, IntToStr(T.Result[1]), 280, I * 18 + 25, clRed, CenterText);
						WriteStringWnd(Window, IntToStr(T.Result[-1]), 328, I * 18 + 25, clRed, CenterText);
						WriteStringWnd(Window, IntToStr(T.Result[0]), 376, I * 18 + 25, clRed, CenterText);
						WriteStringWnd(Window, IntToStr(T.Result[1] * 3 + T.Result[0]), 424, I * 18 + 25, clRed, CenterText)
					End
					Else
					Begin
						WriteStringWnd(Window, IntToStr(TopRow + I + 1), 24, I * 18 + 25, clBlack, CenterText);
						WriteStringWnd(Window, T.Name, 152, I * 18 + 25, clBlack, CenterText);
						WriteStringWnd(Window, IntToStr(T.Result[1]), 280, I * 18 + 25, clBlack, CenterText);
						WriteStringWnd(Window, IntToStr(T.Result[-1]), 328, I * 18 + 25, clBlack, CenterText);
						WriteStringWnd(Window, IntToStr(T.Result[0]), 376, I * 18 + 25, clBlack, CenterText);
						WriteStringWnd(Window, IntToStr(T.Result[1] * 3 + T.Result[0]), 424, I * 18 + 25, clBlack, CenterText)
					End
				End
			End;
		DrawVScroll(Window, Window.ClientWidth - 18, 24, Window.ClientHeight - 26, TopRow, RowCount, LineCount - RowCount);
		Flag := False;
		ClearKeyboardBuffer;
		Case ReadKey Of
			#0:
			Begin
				InKey := ReadKey;
				Case InKey Of
					#71, #119:
					If (TopRow > 0) And (((InKey = #71) And (GetKeyboardFlag = kfNone)) Or ((InKey = #119) And (GetKeyboardFlag = kfCtrl)))
						Then
					Begin
						TopRow := 0;
						Flag := True
					End;
					#72:
					If (TopRow > 0) And (GetKeyboardFlag = kfNone) Then
					Begin
						Dec(TopRow);
						Flag := True
					End;
					#73:
					If (TopRow > 0) And (GetKeyboardFlag = kfNone) Then
					Begin
						Dec(TopRow, RowCount - 1);
						If TopRow < 0 Then TopRow := 0;
						Flag := True
					End;
					#79, #117:
					If (TopRow < LineCount - RowCount) And (((InKey = #79) And (GetKeyboardFlag = kfNone)) Or ((InKey = #117) And
						(GetKeyboardFlag = kfCtrl))) Then
					Begin
						TopRow := LineCount - RowCount;
						Flag := True
					End;
					#80:
					If (TopRow < LineCount - RowCount) And (GetKeyboardFlag = kfNone) Then
					Begin
						Inc(TopRow);
						Flag := True
					End;
					#81:
					If (TopRow < LineCount - RowCount) And (GetKeyboardFlag = kfNone) Then
					Begin
						Inc(TopRow, RowCount - 1);
						If TopRow > LineCount - RowCount Then TopRow := LineCount - RowCount;
						Flag := True
					End;
				End
			End;
			#27: If GetKeyboardFlag = kfNone Then Break
		End
	End;
	FreeMemory(History);
	DestroyWindow(Window)
End;

Procedure Introduce;
Var
	InKey: Char;
	I, P, TopRow, Len, StrLength, RowCount, LineLen, LineCount: Integer;
	Window: TWindow;
	HelpText: PChar;
	F: File;
	LineStr: Array[0..82] Of Char;
Begin
	Assign(F, HelpFile);
	If FSearch(HelpFile, '') = '' Then
	Begin
		ShowMessage('说明文件不存在。', mbOK Or mbIconHand, 0);
		Exit
	End;
	Reset(F, 1);
	StrLength := FileSize(F);
	HelpText := AllocMemory(StrLength + 1);
	FillChar(HelpText^, StrLength + 1, 0);
	BlockRead(F, HelpText^, StrLength);
	Close(F);
	SetStatusLine('按<ESC>键返回。');
	Window.Caption := '使用说明';
	Window.Style := wsBorder Or wsCaption Or wsSize;
	Window.Color := clDefault;
	Window.Width := 544;
	Window.Height := 322;
	Window.Left := (DesktopWindow.Width - Window.Width) Div 2;
	Window.Top := (DesktopWindow.Height - Window.Height) Div 2;
	CreateWindow(Window);
	LineLen := (Window.ClientWidth - 24) Shr 3;
	RowCount := (Window.ClientHeight - 4) Div 18;
	TopRow := 0;
	LineCount := 0;
	P := 0;
	While P < StrLength Do
	Begin
		StrLCopy(LineStr, HelpText + P, 82);
		Len := Length(CopyChinese(StrPas(LineStr), LineLen));
		Inc(P, Len);
		Inc(LineCount)
	End;
	DrawMemo(Window, HelpText, 0, 0, Window.ClientWidth, Window.ClientHeight, 0, LineCount, StrLength);
	While True Do
	Begin
		ClearKeyboardBuffer;
		Case ReadKey Of
			#0:
			Begin
				InKey := ReadKey;
				Case InKey Of
					#71, #119:
					If (TopRow > 0) And (((InKey = #71) And (GetKeyboardFlag = kfNone)) Or ((InKey = #119) And (GetKeyboardFlag = kfCtrl)))
						Then
					Begin
						TopRow := 0;
						DrawMemo(Window, HelpText, 0, 0, Window.ClientWidth, Window.ClientHeight, TopRow, LineCount, StrLength);
					End;
					#72:
					If (TopRow > 0) And (GetKeyboardFlag = kfNone) Then
					Begin
						Dec(TopRow);
						DrawMemo(Window, HelpText, 0, 0, Window.ClientWidth, Window.ClientHeight, TopRow, LineCount, StrLength);
					End;
					#73:
					If (TopRow > 0) And (GetKeyboardFlag = kfNone) Then
					Begin
						Dec(TopRow, RowCount - 1);
						If TopRow < 0 Then TopRow := 0;
						DrawMemo(Window, HelpText, 0, 0, Window.ClientWidth, Window.ClientHeight, TopRow, LineCount, StrLength);
					End;
					#79, #117:
					If (TopRow < LineCount - RowCount) And (((InKey = #79) And (GetKeyboardFlag = kfNone)) Or ((InKey = #117) And
						(GetKeyboardFlag = kfCtrl))) Then
					Begin
						TopRow := LineCount - RowCount;
						DrawMemo(Window, HelpText, 0, 0, Window.ClientWidth, Window.ClientHeight, TopRow, LineCount, StrLength);
					End;
					#80:
					If (TopRow < LineCount - RowCount) And (GetKeyboardFlag = kfNone) Then
					Begin
						Inc(TopRow);
						DrawMemo(Window, HelpText, 0, 0, Window.ClientWidth, Window.ClientHeight, TopRow, LineCount, StrLength);
					End;
					#81:
					If (TopRow < LineCount - RowCount) And (GetKeyboardFlag = kfNone) Then
					Begin
						Inc(TopRow, RowCount - 1);
						If TopRow > LineCount - RowCount Then TopRow := LineCount - RowCount;
						DrawMemo(Window, HelpText, 0, 0, Window.ClientWidth, Window.ClientHeight, TopRow, LineCount, StrLength);
					End;
				End
			End;
			#27: If GetKeyboardFlag = kfNone Then Break
		End
	End;
	DestroyWindow(Window);
	FreeMemory(HelpText)
End;

Procedure About;
Var
	Window: TWindow;
Begin
	SetStatusLine('按任意键返回。');
	Window.Caption := '关于' + Title;
	Window.Style := wsBorder Or wsCaption Or wsSize;
	Window.Color := clDefault;
	Window.Width := 320;
	Window.Height := 240;
	Window.Left := (DesktopWindow.Width - Window.Width) Div 2;
	Window.Top := (DesktopWindow.Height - Window.Height) Div 2;
	CreateWindow(Window);
	ShowPicture(Window, '图标', 12, 12);
	ShowPicture(Window, '标题', 76, 10);
	WriteStringWnd(Window, '版本 6.1', 140, 12, clBlack, LeftText);
	WriteStringWnd(Window, '版权所有(C)  王纯', 76, 32, clBlack, LeftText);
	WriteStringWnd(Window, '1996年—1999年  保留所有权利', 76, 52, clBlack, LeftText);
	WriteStringWnd(Window, '    本游戏是免费软件，你可以复制它而', 12, 82, clBlack, LeftText);
	WriteStringWnd(Window, '不必事先通知作者。若有错误报告、修改', 12, 102, clBlack, LeftText);
	WriteStringWnd(Window, '建议或想得到源代码，可与作者联系。', 12, 122, clBlack, LeftText);
	WriteStringWnd(Window, '    联系地址：天津市耀华中学', 12, 142, clBlack, LeftText);
	WriteStringWnd(Window, '              实验五年一班  王纯', 12, 162, clBlack, LeftText);
	WriteStringWnd(Window, '    邮政编码：300040', 12, 182, clBlack, LeftText);
	If ReadKey = #0 Then ReadKey;
	DestroyWindow(Window)
End;

Function MainMenu: Integer;
Const
	ItemStr: Array[1..6] Of String = ('人 机 对 弈', '双 人 对 弈', '历 史 记 录', '使 用 说 明', '版 权 信 息', '退 出 游 戏');
Var
	InKey: Char;
	Choose: Integer;
	Window: TWindow;
Begin
	SetStatusLine(#0);
	Window.Caption := '';
	Window.Style := wsBorder Or wsFlat Or wsSize;
	Window.Color := clDefault;
	Window.Width := 128;
	Window.Height := 160;
	Window.Left := (DesktopWindow.Width - Window.Width) Div 2;
	Window.Top := (DesktopWindow.Height - Window.Height) * 3 Div 4;
	CreateWindow(Window);
	Choose := 1;
	BarWnd(Window, 0, 6, Window.ClientWidth - 1, 25, clNavy);
	WriteStringWnd(Window, ItemStr[1], Window.ClientWidth Div 2, 8, clWhite, CenterText);
	WriteStringWnd(Window, ItemStr[2], Window.ClientWidth Div 2, 32, clBlack, CenterText);
	WriteStringWnd(Window, ItemStr[3], Window.ClientWidth Div 2, 56, clBlack, CenterText);
	WriteStringWnd(Window, ItemStr[4], Window.ClientWidth Div 2, 80, clBlack, CenterText);
	WriteStringWnd(Window, ItemStr[5], Window.ClientWidth Div 2, 104, clBlack, CenterText);
	WriteStringWnd(Window, ItemStr[6], Window.ClientWidth Div 2, 128, clBlack, CenterText);
	Repeat
		ClearKeyboardBuffer;
		InKey := ReadKey;
		If InKey = #0 Then
			Case ReadKey Of
				#72:
				If GetKeyboardFlag = kfNone Then
				Begin
					BarWnd(Window, 0, Choose * 24 - 18, Window.ClientWidth - 1, Choose * 24 + 1, Window.Color);
					WriteStringWnd(Window, ItemStr[Choose], Window.ClientWidth Div 2, Choose * 24 - 16, clBlack, CenterText);
					Choose := (Choose + 4) Mod 6 + 1;
					BarWnd(Window, 0, Choose * 24 - 18, Window.ClientWidth - 1, Choose * 24 + 1, clNavy);
					WriteStringWnd(Window, ItemStr[Choose], Window.ClientWidth Div 2, Choose * 24 - 16, clWhite, CenterText);
				End;
				#80:
				If GetKeyboardFlag = kfNone Then
				Begin
					BarWnd(Window, 0, Choose * 24 - 18, Window.ClientWidth - 1, Choose * 24 + 1, Window.Color);
					WriteStringWnd(Window, ItemStr[Choose], Window.ClientWidth Div 2, Choose * 24 - 16, clBlack, CenterText);
					Choose := Choose Mod 6 + 1;
					BarWnd(Window, 0, Choose * 24 - 18, Window.ClientWidth - 1, Choose * 24 + 1, clNavy);
					WriteStringWnd(Window, ItemStr[Choose], Window.ClientWidth Div 2, Choose * 24 - 16, clWhite, CenterText);
				End;
			End
	Until ((InKey = #13) Or (InKey = #27)) And (GetKeyboardFlag = kfNone);
	If InKey = #27 Then Choose := 6;
	DestroyWindow(Window);
	MainMenu := Choose
End;

Procedure Init;
Var
	I, J: Integer;
	P: Pointer;
	T: PChar;
	Dir: DirStr;
	Name: NameStr;
	Ext: ExtStr;
	ValueStr, ShapeStr: String[11];
Begin
	ExitProc := @TextFatalExit;
	Title := '五子棋';
	UpdateDate := LastUpdate;
	FSplit(ParamStr(0), Dir, Name, Ext);
	If (Dir[Length(Dir)] <> ':') And (Dir[Length(Dir)] <> '\') Then Dir := Dir + '\';
	DataFile := Dir + 'GOBANG.DAT';
	HistoryFile := Dir + 'HISTORY.DAT';
	ManualFile := Dir + 'MANUAL.TXT';
	HelpFile := Dir + 'README.TXT';
	If FSearch(DataFile, '') = '' Then RunError(302);
	ASCFont := LoadResource(DataFile, '英文字库', rtBinary);
	HZKFont := LoadResource(DataFile, '中文字库', rtBinary);
	P := LoadResource(DataFile, '棋谱', rtText);
	T := P;
	For I := 1 To NumManual Do
	Begin
		ShapeStr[0] := #11;
		For J := 1 To 11 Do
			ShapeStr[J] := T[J - 1];
		T := StrPos(T, CrLf) + 2;
		ValueStr[0] := Chr(StrPos(T, CrLf) - T);
		For J := 1 To Length(ValueStr) Do
			ValueStr[J] := T[J - 1];
		Manual[I].Value := StrToInt(ValueStr);
		For J := -5 To 5 Do
			Case ShapeStr[J + 6] Of
				'_': Manual[I].Shape[J] := 0;
				'O': Manual[I].Shape[J] := 1;
				'X': Manual[I].Shape[J] := 2;
				'|': Manual[I].Shape[J] := 3;
				'?', ' ': Manual[I].Shape[J] := 4
			End
	End;
	FreeMemory(P);
	For I := 63 DownTo 0 Do
	Begin
		SetSystemPalette(I);
		MicrosecondDelay(5000)
	End;
	EnableGraphics(True);
	ExitProc := @GraphicsFatalExit;
	If GetKeyboardFlag And kfShift = 0 Then
	Begin
		SetDefaultPalette(0);
		ClearDevice;
		P := LoadResource(DataFile, '标志', rtPicture);
		PutPictureWnd(DesktopWindow, P, 320 - GetPictureWidth(P) Div 2, 240 - GetPictureHeight(P) Div 2);
		FreeMemory(P);
		For I := 0 To 63 Do
		Begin
			SetDefaultPalette(I);
			MicrosecondDelay(5000)
		End;
		MicrosecondDelay(2000000);
		For I := 63 DownTo 0 Do
		Begin
			SetDefaultPalette(I);
			MicrosecondDelay(5000)
		End
	End;
	SetDefaultPalette(0);
	ClearDevice;
	ShowPicture(DesktopWindow, '背景上部', 0, 0);
	ShowPicture(DesktopWindow, '背景下部', 0, 240);
	StatusWindow.Caption := '';
	StatusWindow.Style := wsBorder;
	StatusWindow.Color := clDefault;
	StatusWindow.Left := 0;
	StatusWindow.Height := 24;
	StatusWindow.Top := DesktopWindow.Height - StatusWindow.Height;
	StatusWindow.Width := DesktopWindow.Width;
	CreateWindow(StatusWindow);
	Inc(StatusWindow.ClientLeft, 4);
	Dec(StatusWindow.ClientWidth, 8);
	SetStatusLine(#0);
	For I := 0 To 63 Do
	Begin
		SetDefaultPalette(I);
		MicrosecondDelay(5000)
	End
End;

Procedure Run;
Begin
	While True Do
		Case MainMenu Of
			1: Game(1);
			2: Game(2);
			3: ShowHistory;
			4: Introduce;
			5: About;
			6: If ShowMessage('真要退出吗？', mbYesNo Or mbIconQuestion, 1) = idYes Then Break
		End
End;

Procedure Done;
Var
	I: Integer;
Begin
	For I := 63 DownTo 0 Do
	Begin
		SetDefaultPalette(I);
		MicrosecondDelay(5000)
	End;
	DestroyWindow(StatusWindow);
	FreeMemory(ASCFont);
	FreeMemory(HZKFont);
	EnableGraphics(False);
	ExitProc := @TextFatalExit;
	SetSystemPalette(0);
	For I := 0 To 63 Do
	Begin
		SetSystemPalette(I);
		MicrosecondDelay(5000)
	End
End;

Begin
	Init;
	Run;
	Done
End.