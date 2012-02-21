VERSION 2.00
Begin Form FormChess 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00000000&
   BorderStyle     =   0  'None
   Caption         =   "五子棋"
   ClientHeight    =   6795
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9480
   FontBold        =   -1  'True
   FontItalic      =   0   'False
   FontName        =   "System"
   FontSize        =   12
   FontStrikethru  =   0   'False
   FontUnderline   =   0   'False
   ForeColor       =   &H00FFFFFF&
   Height          =   7200
   Icon            =   WZQ4.FRX:0000
   Left            =   0
   MaxButton       =   0   'False
   ScaleHeight     =   3000
   ScaleMode       =   0  'User
   ScaleWidth      =   4000
   Top             =   0
   Width           =   9600
   Begin Timer TimerWhite 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   480
      Top             =   0
   End
   Begin Timer TimerBlack 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   0
      Top             =   0
   End
   Begin PictureBox PictureHistory 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "System"
      FontSize        =   12
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   1335
      HelpContextID   =   7
      Left            =   0
      ScaleHeight     =   3000
      ScaleMode       =   0  'User
      ScaleWidth      =   4000
      TabIndex        =   19
      Top             =   1920
      Visible         =   0   'False
      Width           =   1335
   End
   Begin Frame FrameWhite 
      BackColor       =   &H00FFFFFF&
      Caption         =   "白方(&W)："
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "System"
      FontSize        =   12
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      ForeColor       =   &H00000000&
      Height          =   1815
      Left            =   5520
      TabIndex        =   10
      Top             =   3240
      Visible         =   0   'False
      Width           =   2775
      Begin TextBox TextWhite 
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "System"
         FontSize        =   12
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   420
         HelpContextID   =   6
         Left            =   960
         MaxLength       =   6
         TabIndex        =   16
         Top             =   1200
         Width           =   1575
      End
      Begin OptionButton OptionWhite 
         Caption         =   "方向键"
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "System"
         FontSize        =   12
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   375
         HelpContextID   =   6
         Index           =   0
         Left            =   240
         TabIndex        =   11
         Top             =   360
         Width           =   1095
      End
      Begin OptionButton OptionWhite 
         Caption         =   "字母键"
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "System"
         FontSize        =   12
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   375
         HelpContextID   =   6
         Index           =   1
         Left            =   1440
         TabIndex        =   12
         Top             =   360
         Value           =   -1  'True
         Width           =   1095
      End
      Begin OptionButton OptionWhite 
         Caption         =   "鼠标器"
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "System"
         FontSize        =   12
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   375
         HelpContextID   =   6
         Index           =   2
         Left            =   240
         TabIndex        =   13
         Top             =   720
         Width           =   1095
      End
      Begin OptionButton OptionWhite 
         Caption         =   "计算机"
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "System"
         FontSize        =   12
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   375
         HelpContextID   =   6
         Index           =   3
         Left            =   1440
         TabIndex        =   14
         Top             =   720
         Width           =   1095
      End
      Begin Label LabelWhite 
         Caption         =   "姓名："
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "System"
         FontSize        =   12
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   255
         Left            =   240
         TabIndex        =   15
         Top             =   1260
         Width           =   735
      End
   End
   Begin Frame FrameBlack 
      BackColor       =   &H00FFFFFF&
      Caption         =   "黑方(&B)："
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "System"
      FontSize        =   12
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      ForeColor       =   &H00000000&
      Height          =   1815
      Left            =   1320
      TabIndex        =   3
      Top             =   3240
      Visible         =   0   'False
      Width           =   2775
      Begin TextBox TextBlack 
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "System"
         FontSize        =   12
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   420
         HelpContextID   =   6
         Left            =   840
         MaxLength       =   6
         TabIndex        =   9
         Top             =   1200
         Width           =   1695
      End
      Begin OptionButton OptionBlack 
         Caption         =   "计算机"
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "System"
         FontSize        =   12
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   375
         HelpContextID   =   6
         Index           =   3
         Left            =   1440
         TabIndex        =   7
         Top             =   720
         Width           =   1095
      End
      Begin OptionButton OptionBlack 
         Caption         =   "鼠标器"
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "System"
         FontSize        =   12
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   375
         HelpContextID   =   6
         Index           =   2
         Left            =   240
         TabIndex        =   6
         Top             =   720
         Width           =   1095
      End
      Begin OptionButton OptionBlack 
         Caption         =   "字母键"
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "System"
         FontSize        =   12
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   375
         HelpContextID   =   6
         Index           =   1
         Left            =   1440
         TabIndex        =   5
         Top             =   360
         Width           =   1095
      End
      Begin OptionButton OptionBlack 
         Caption         =   "方向键"
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "System"
         FontSize        =   12
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   375
         HelpContextID   =   6
         Index           =   0
         Left            =   240
         TabIndex        =   4
         Top             =   360
         Value           =   -1  'True
         Width           =   1095
      End
      Begin Label LabelBlack 
         Caption         =   "姓名："
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "System"
         FontSize        =   12
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   255
         Left            =   120
         TabIndex        =   8
         Top             =   1260
         Width           =   735
      End
   End
   Begin CommandButton CommandMainMenu 
      Caption         =   "历史记录"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "System"
      FontSize        =   12
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   495
      HelpContextID   =   4
      Index           =   1
      Left            =   4080
      TabIndex        =   1
      Top             =   3720
      Visible         =   0   'False
      Width           =   1455
   End
   Begin CommandButton CommandMainMenu 
      Caption         =   "结束游戏"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "System"
      FontSize        =   12
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   495
      HelpContextID   =   8
      Index           =   2
      Left            =   4080
      TabIndex        =   2
      Top             =   4200
      Visible         =   0   'False
      Width           =   1455
   End
   Begin CommandButton CommandMainMenu 
      Caption         =   "开始游戏"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "System"
      FontSize        =   12
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   495
      HelpContextID   =   3
      Index           =   0
      Left            =   4080
      TabIndex        =   0
      Top             =   3240
      Visible         =   0   'False
      Width           =   1455
   End
   Begin PictureBox PictureSwap 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H00FFFFFF&
      Height          =   1359
      Left            =   0
      ScaleHeight     =   600
      ScaleMode       =   0  'User
      ScaleWidth      =   1800
      TabIndex        =   18
      TabStop         =   0   'False
      Top             =   0
      Visible         =   0   'False
      Width           =   4266
   End
   Begin PictureBox PictureChessboard 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "System"
      FontSize        =   12
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      ForeColor       =   &H00FFFFFF&
      Height          =   5436
      Left            =   1896
      ScaleHeight     =   2400
      ScaleMode       =   0  'User
      ScaleWidth      =   2400
      TabIndex        =   17
      Top             =   680
      Visible         =   0   'False
      Width           =   5688
   End
End
Option Explicit

Declare Function FloodFill Lib "GDI" (ByVal hDC As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal crColor As Long) As Integer
Declare Function BitBlt Lib "GDI" (ByVal hDestDC As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal nWidth As Integer, ByVal nHeight As Integer, ByVal hSrcDC As Integer, ByVal XSrc As Integer, ByVal YSrc As Integer, ByVal dwRop As Long) As Integer
Declare Sub SetCursorPos Lib "User" (ByVal X As Integer, ByVal Y As Integer)
Declare Function GetFocus Lib "User" () As Integer

Const SRCCOPY = &HCC0020
Const SRCAND = &H8800C6
Const SRCPAINT = &HEE0086

Dim KeyboardX As Integer
Dim KeyboardY As Integer
Dim MoveX As Integer
Dim MoveY As Integer
Dim CurrentInput As Integer
Dim IsExit As Integer
Dim IsFocus As Integer
Dim Chessboard(-6 To 20, -6 To 20) As Integer
Dim ChessboardPart(-6 To 6) As Integer
Dim HistoryName() As String * 6
Dim HistoryTotal() As Long
Dim HistoryWin() As Long
Dim HistoryFailure() As Long
Dim HistoryMark() As Long
Dim ShapeLibrary() As Integer
Dim ValueLibrary() As Long

Sub CalculateMove (CurrentPlayer As Integer)
    Dim I As Integer
    Dim J As Integer
    Dim SwapVariant As Integer
    Dim IsSwap As Integer
    Dim CurrentValue As Long
    Dim Number As Integer
    Dim Result As Integer
    ReDim Value(1 To 225) As Integer
    ReDim X(1 To 225) As Integer
    ReDim Y(1 To 225) As Integer
    If Val(PictureChessboard.Tag) = 0 Then
	MoveX = 7
	MoveY = 7
    Else
	Number = 0
	For J = 0 To 14
	    For I = 0 To 14
		If Chessboard(I, J) = 0 Then
		    CurrentValue = GetValue(CurrentPlayer, I, J)
		    Number = Number + 1
		    Value(Number) = CurrentValue
		    X(Number) = I
		    Y(Number) = J
		End If
		DoEvents
	    Next
	Next
	Do
	    IsSwap = False
	    For I = 1 To Number - 1
		If Value(I) < Value(I + 1) Then
		    SwapVariant = Value(I)
		    Value(I) = Value(I + 1)
		    Value(I + 1) = SwapVariant
		    SwapVariant = X(I)
		    X(I) = X(I + 1)
		    X(I + 1) = SwapVariant
		    SwapVariant = Y(I)
		    Y(I) = Y(I + 1)
		    Y(I + 1) = SwapVariant
		    IsSwap = True
		End If
	    Next
	    DoEvents
	Loop While IsSwap
	For I = 1 To Number
	    Chessboard(X(I), Y(I)) = CurrentPlayer
	    If CheckWin(CurrentPlayer, X(I), Y(I)) >= 0 Then
		MoveX = X(I)
		MoveY = Y(I)
		Chessboard(X(I), Y(I)) = 0
		Exit Sub
	    End If
	    Chessboard(X(I), Y(I)) = 0
	Next
	MoveX = X(1)
	MoveY = Y(1)
    End If
End Sub

Function CheckPart (CurrentPlayer As Integer) As Integer
    Dim I As Integer
    Dim J As Integer
    For I = -6 To 6
	If ChessboardPart(I) = 1 Or ChessboardPart(I) = 2 Then
	    If ChessboardPart(I) = CurrentPlayer Then ChessboardPart(I) = 1 Else ChessboardPart(I) = 2
	End If
    Next
    For J = -5 To 0
	If ChessboardPart(J) = 1 Then
	    If ChessboardPart(J + 1) = 1 Then
		If ChessboardPart(J + 2) = 1 Then
		    If ChessboardPart(J + 3) = 1 Then
			If ChessboardPart(J + 4) = 1 Then
			    If ChessboardPart(J + 5) = 1 Then
				CheckPart = 6
				Exit Function
			    End If
			End If
		    End If
		End If
	    End If
	End If
    Next
    For J = -4 To 0
	If ChessboardPart(J) = 1 Then
	    If ChessboardPart(J + 1) = 1 Then
		If ChessboardPart(J + 2) = 1 Then
		    If ChessboardPart(J + 3) = 1 Then
			If ChessboardPart(J + 4) = 1 Then
			    CheckPart = 5
			    Exit Function
			End If
		    End If
		End If
	    End If
	End If
    Next
    For I = -6 To 6
	If ChessboardPart(I) = 0 Then
	    ChessboardPart(I) = 1
	    For J = -6 To 0
		If ChessboardPart(J) = 0 Then
		    If ChessboardPart(J + 1) = 1 Then
			If ChessboardPart(J + 2) = 1 Then
			    If ChessboardPart(J + 3) = 1 Then
				If ChessboardPart(J + 4) = 1 Then
				    If ChessboardPart(J + 5) = 1 Then
					If ChessboardPart(J + 6) = 0 Then
					    CheckPart = 4
					    Exit Function
					Else
					    CheckPart = 14
					    Exit Function
					End If
				    End If
				End If
			    End If
			End If
		    End If
		End If
	    Next
	    For J = -5 To 0
		If ChessboardPart(J) = 1 Then
		    If ChessboardPart(J + 1) = 1 Then
			If ChessboardPart(J + 2) = 1 Then
			    If ChessboardPart(J + 3) = 1 Then
				If ChessboardPart(J + 4) = 1 Then
				    If ChessboardPart(J + 5) = 0 Then
					CheckPart = 14
					Exit Function
				    End If
				End If
			    End If
			End If
		    End If
		End If
	    Next
	    If I > -6 And I < 6 Then
		For J = -5 To 0
		    If ChessboardPart(J) = 0 Then
			If ChessboardPart(J + 1) = 1 Then
			    If ChessboardPart(J + 2) = 1 Then
				If ChessboardPart(J + 3) = 1 Then
				    If ChessboardPart(J + 4) = 1 Then
					If ChessboardPart(J + 5) = 0 Then
					    CheckPart = 3
					    Exit Function
					End If
				    End If
				End If
			    End If
			End If
		    End If
		Next
	    End If
	    ChessboardPart(I) = 0
	End If
    Next
End Function

Function CheckWin (CurrentPlayer As Integer, X As Integer, Y As Integer) As Integer
    Dim I As Integer
    Dim Result As Integer
    For I = -4 To 4
	If I = 0 Then
	    Select Case DoCheckWin(CurrentPlayer, X, Y)
		Case -2
		    Result = -2
		Case 1
		    If Result = 0 Then Result = 1
		Case 2
		    If Result <> -2 Then Result = 2
	    End Select
	Else
	    If X + I >= 0 And X + I < 15 And Chessboard(X, Y) = CurrentPlayer Then
		Select Case DoCheckWin(CurrentPlayer, X + I, Y)
		    Case -2
			Result = -2
		    Case 1
			If Result = 0 Then Result = 1
		    Case 2
			If Result <> -2 Then Result = 2
		End Select
	    End If
	    If Y + I >= 0 And Y + I < 15 And Chessboard(X, Y) = CurrentPlayer Then
		Select Case DoCheckWin(CurrentPlayer, X, Y + I)
		    Case -2
			Result = -2
		    Case 1
			If Result = 0 Then Result = 1
		    Case 2
			If Result <> -2 Then Result = 2
		End Select
	    End If
	    If X + I >= 0 And X + I < 15 And Y + I >= 0 And Y + I < 15 And Chessboard(X, Y) = CurrentPlayer Then
		Select Case DoCheckWin(CurrentPlayer, X + I, Y + I)
		    Case -2
			Result = -2
		    Case 1
			If Result = 0 Then Result = 1
		    Case 2
			If Result <> -2 Then Result = 2
		End Select
	    End If
	    If X - I >= 0 And X - I < 15 And Y + I >= 0 And Y + I < 15 And Chessboard(X, Y) = CurrentPlayer Then
		Select Case DoCheckWin(CurrentPlayer, X - I, Y + I)
		    Case -2
			Result = -2
		    Case 1
			If Result = 0 Then Result = 1
		    Case 2
			If Result <> -2 Then Result = 2
		End Select
	    End If
	End If
    Next
    CheckWin = Result
End Function

Sub CommandMainMenu_Click (Index As Integer)
    Dim I As Integer
    Select Case Index
	Case 0
	    For I = 0 To 2
		CommandMainMenu(I).Enabled = False
	    Next
	    Line (CommandMainMenu(0).Left - 130, CommandMainMenu(0).Top - 130)-(CommandMainMenu(0).Left + CommandMainMenu(0).Width * 3 + 130, CommandMainMenu(0).Top + CommandMainMenu(0).Height + 130), RGB(0, 0, 0), BF
	    TextBlack.Text = ""
	    TextWhite.Text = ""
	    FrameBlack.Visible = True
	    FrameWhite.Visible = True
	    DrawWidth = 5
	    DrawStyle = 6
	    For I = 0 To 250 Step 10
		Line (FrameBlack.Left - I / 2, FrameBlack.Top - I / 2)-(FrameWhite.Left + FrameWhite.Width + I / 2, FrameWhite.Top + FrameWhite.Height + I / 2), RGB(255 - I, 255 - I, 255 - I), B
	    Next
	    FontName = "宋体"
	    FontSize = UserToPixelX(75)
	    DrawWidth = 3
	    DrawStyle = 0
	    Line (3050, 2450)-(3950, 2750), RGB(0, 255, 0), B
	    DrawWidth = 2
	    Line (3050, 2600)-(3950, 2600), RGB(0, 255, 0)
	    ForeColor = RGB(0, 255, 255)
	    CurrentX = 3500 - TextWidth("程序设计：王纯") / 2
	    CurrentY = 2525 - TextHeight("程序设计：王纯") / 2
	    Print "程序设计：王纯"
	    CurrentX = 3500 - TextWidth("1998年5月5日") / 2
	    CurrentY = 2675 - TextHeight("1998年5月5日") / 2
	    Print "1998年5月5日"
	Case 1
	    If ShowHistory() Then
		PictureHistory.Tag = ""
		PictureHistory.Visible = True
		For I = 0 To 2
		    CommandMainMenu(I).Visible = False
		Next
		Do
		    DoEvents
		Loop Until PictureHistory.Tag = "*"
		For I = 0 To 2
		    CommandMainMenu(I).Visible = True
		Next
		PictureHistory.Visible = False
	    End If
	Case 2
	    End
    End Select
End Sub

Sub CommandMainMenu_KeyPress (Index As Integer, KeyAscii As Integer)
    If KeyAscii = 27 Then End
End Sub

Function CompareShape (ShapeNumber As Integer)
    Dim I As Integer
    Dim Result1 As Integer
    Dim Result2 As Integer
    Result1 = True
    For I = -5 To 5
	If ShapeLibrary(ShapeNumber, I) <> 4 Then
	    If ChessboardPart(I) <> ShapeLibrary(ShapeNumber, I) Then
		Result1 = False
		Exit For
	    End If
	End If
    Next
    Result2 = True
    For I = -5 To 5
	If ShapeLibrary(ShapeNumber, I) <> 4 Then
	    If ChessboardPart(-I) <> ShapeLibrary(ShapeNumber, I) Then
		Result2 = False
		Exit For
	    End If
	End If
    Next
    CompareShape = Result1 Or Result2
End Function

Function ComputerMove ()
    Dim I As Integer
    Dim J As Integer
    Dim Value As Single
    Dim Ret As Integer
    Dim CurrentPlayer As Integer
    If Tag = "黑方" Then CurrentPlayer = 1 Else CurrentPlayer = 2
    Do
	CalculateMove CurrentPlayer
	Ret = SetChessman(MoveX, MoveY)
    Loop Until Ret
    ComputerMove = Ret
End Function

Function DoCheckWin (CurrentPlayer As Integer, X As Integer, Y As Integer) As Integer
    Dim I As Integer
    Dim Times As Integer
    ReDim PartNumber(1 To 4) As Integer
    For I = -6 To 6
	ChessboardPart(I) = Chessboard(X + I, Y)
    Next
    If ChessboardPart(-2) <> 0 Or ChessboardPart(-1) <> 0 Or ChessboardPart(1) <> 0 Or ChessboardPart(2) <> 0 Then PartNumber(1) = CheckPart(CurrentPlayer)
    For I = -6 To 6
	ChessboardPart(I) = Chessboard(X, Y + I)
    Next
    If ChessboardPart(-2) <> 0 Or ChessboardPart(-1) <> 0 Or ChessboardPart(1) <> 0 Or ChessboardPart(2) <> 0 Then PartNumber(2) = CheckPart(CurrentPlayer)
    For I = -6 To 6
	ChessboardPart(I) = Chessboard(X + I, Y + I)
    Next
    If ChessboardPart(-2) <> 0 Or ChessboardPart(-1) <> 0 Or ChessboardPart(1) <> 0 Or ChessboardPart(2) <> 0 Then PartNumber(3) = CheckPart(CurrentPlayer)
    For I = -6 To 6
	ChessboardPart(I) = Chessboard(X + I, Y - I)
    Next
    If ChessboardPart(-2) <> 0 Or ChessboardPart(-1) <> 0 Or ChessboardPart(1) <> 0 Or ChessboardPart(2) <> 0 Then PartNumber(4) = CheckPart(CurrentPlayer)
	If PartNumber(1) = 6 Or PartNumber(2) = 6 Or PartNumber(3) = 6 Or PartNumber(4) = 6 Then
	DoCheckWin = -2
	Exit Function
    End If
    Times = 0
    For I = 1 To 4
	If PartNumber(I) >= 3 And PartNumber(I) < 10 Then Times = Times + 1
    Next
    If Times >= 2 Then
	If CurrentPlayer = 1 Then
	    DoCheckWin = -2
	    Exit Function
	Else
	    DoCheckWin = 1
	End If
    End If
    Times = 0
    For I = 1 To 4
	If PartNumber(I) = 14 Or PartNumber(I) = 5 Then Times = Times + 1
    Next
    If Times >= 2 Then
	If CurrentPlayer = 1 Then
	    DoCheckWin = -2
	    Exit Function
	Else
	    DoCheckWin = 1
	End If
    End If
    If PartNumber(1) = 4 Or PartNumber(2) = 4 Or PartNumber(3) = 4 Or PartNumber(4) = 4 Then DoCheckWin = 1
    If PartNumber(1) = 5 Or PartNumber(2) = 5 Or PartNumber(3) = 5 Or PartNumber(4) = 5 Then DoCheckWin = 2
End Function

Sub DrawChessboard ()
    Dim I As Integer
    Dim Ret As Integer
    PictureChessboard.FillStyle = 0
    PictureChessboard.ForeColor = RGB(255, 255, 0)
    PictureChessboard.Line (2400, 0)-(2350, 50)
    PictureChessboard.Line (2350, 50)-(50, 50)
    PictureChessboard.Line (50, 50)-(50, 2350)
    PictureChessboard.Line (50, 2350)-(0, 2400)
    PictureChessboard.FillColor = RGB(255, 255, 0)
    Ret = FloodFill(PictureChessboard.hDC, 0, 0, RGB(255, 255, 0))
    PictureChessboard.ForeColor = RGB(128, 128, 0)
    PictureChessboard.Line (2400, 0)-(2350, 50)
    PictureChessboard.Line (2350, 50)-(2350, 2350)
    PictureChessboard.Line (2350, 2350)-(50, 2350)
    PictureChessboard.Line (50, 2350)-(0, 2400)
    PictureChessboard.FillColor = RGB(128, 128, 0)
    Ret = FloodFill(PictureChessboard.hDC, UserToPixelX(2400) - 1, UserToPixelY(2400) - 1, RGB(128, 128, 0))
    PictureChessboard.DrawStyle = 5
    PictureChessboard.Line (50, 50)-(2350, 2350), RGB(192, 192, 0), BF
    PictureChessboard.DrawStyle = 0
    PictureChessboard.ForeColor = RGB(128, 128, 128)
    PictureChessboard.Line (0, 0)-(50, 50)
    PictureChessboard.Line (2400, 0)-(2350, 50)
    PictureChessboard.Line (2400, 2400)-(2350, 2350)
    PictureChessboard.Line (0, 2400)-(50, 2350)
    PictureChessboard.FillStyle = 1
    PictureChessboard.Line (50, 50)-(2350, 2350), RGB(128, 128, 128), B
    PictureChessboard.DrawWidth = 2
    For I = 0 To 14
	PictureChessboard.Line (150, I * 150 + 150)-(2250, I * 150 + 150)
	PictureChessboard.Line (I * 150 + 150, 150)-(I * 150 + 150, 2250)
    Next
    PictureChessboard.DrawWidth = 1
End Sub

Sub DrawKeyboardCursor ()
    PictureChessboard.DrawMode = 7
    PictureChessboard.DrawWidth = 2
    PictureChessboard.DrawStyle = 6
    PictureChessboard.ForeColor = RGB(255, 255, 255)
    PictureChessboard.Line (KeyboardX * 150 + 80, KeyboardY * 150 + 80)-(KeyboardX * 150 + 100, KeyboardY * 150 + 80)
    PictureChessboard.Line (KeyboardX * 150 + 80, KeyboardY * 150 + 80)-(KeyboardX * 150 + 80, KeyboardY * 150 + 100)
    PictureChessboard.Line (KeyboardX * 150 + 220, KeyboardY * 150 + 80)-(KeyboardX * 150 + 200, KeyboardY * 150 + 80)
    PictureChessboard.Line (KeyboardX * 150 + 220, KeyboardY * 150 + 80)-(KeyboardX * 150 + 220, KeyboardY * 150 + 100)
    PictureChessboard.Line (KeyboardX * 150 + 80, KeyboardY * 150 + 220)-(KeyboardX * 150 + 100, KeyboardY * 150 + 220)
    PictureChessboard.Line (KeyboardX * 150 + 80, KeyboardY * 150 + 220)-(KeyboardX * 150 + 80, KeyboardY * 150 + 200)
    PictureChessboard.Line (KeyboardX * 150 + 220, KeyboardY * 150 + 220)-(KeyboardX * 150 + 220, KeyboardY * 150 + 200)
    PictureChessboard.Line (KeyboardX * 150 + 220, KeyboardY * 150 + 220)-(KeyboardX * 150 + 200, KeyboardY * 150 + 220)
    PictureChessboard.DrawWidth = 1
    PictureChessboard.DrawMode = 13
End Sub

Sub Form_Activate ()
    Title
End Sub

Sub Form_Click ()
    If PictureChessboard.Tag = "*" Then PictureChessboard.Tag = ""
End Sub

Sub Form_KeyPress (KeyAscii As Integer)
    If PictureChessboard.Tag = "*" Then PictureChessboard.Tag = ""
End Sub

Sub Form_Load ()
    Dim I As Integer
    Dim HelpFileName As String
    Randomize
    HelpFileName = App.Path
    If HelpFileName <> "" Then
	If Right$(HelpFileName, 1) <> ":" And Right$(HelpFileName, 1) <> "\" Then HelpFileName = HelpFileName + "\"
    End If
    App.HelpFile = HelpFileName + "WZQ4.HLP"
    Move 0, 0, Screen.Width, Screen.Height
    Scale (0, 0)-(4000, 3000)
    InitializeLibrary
    PictureHistory.Move 0, 0, 4000, 3000
    PictureHistory.Scale (0, 0)-(4000, 3000)
    PictureChessboard.Move 800, 300, 2400, 2400
    PictureChessboard.Scale (0, 0)-(2400, 2400)
    CommandMainMenu(0).Move (ScaleWidth - CommandMainMenu(0).Width * 3) / 2, 1700
    CommandMainMenu(1).Move CommandMainMenu(0).Left + CommandMainMenu(0).Width, 1700
    CommandMainMenu(2).Move CommandMainMenu(1).Left + CommandMainMenu(1).Width, 1700
    FrameBlack.Move ScaleWidth / 2 - FrameBlack.Width, CommandMainMenu(0).Top + CommandMainMenu(0).Height + 125
    FrameWhite.Move ScaleWidth / 2, CommandMainMenu(0).Top + CommandMainMenu(0).Height + 125
End Sub

Function GetValue (CurrentPlayer As Integer, X As Integer, Y As Integer) As Long
    Dim I As Integer
    Dim J As Integer
    Dim K As Integer
    Dim Result As Long
    ReDim Part(1 To 4, -5 To 5) As Integer
    For I = -5 To 5
	Select Case Chessboard(X + I, Y)
	    Case 0
		Part(1, I) = 0
	    Case 1
		Part(1, I) = CurrentPlayer
	    Case 2
		Part(1, I) = 3 - CurrentPlayer
	    Case 3
		Part(1, I) = 3
	End Select
	Select Case Chessboard(X, Y + I)
	    Case 0
		Part(2, I) = 0
	    Case 1
		Part(2, I) = CurrentPlayer
	    Case 2
		Part(2, I) = 3 - CurrentPlayer
	    Case 3
		Part(2, I) = 3
	End Select
	Select Case Chessboard(X + I, Y + I)
	    Case 0
		Part(3, I) = 0
	    Case 1
		Part(3, I) = CurrentPlayer
	    Case 2
		Part(3, I) = 3 - CurrentPlayer
	    Case 3
		Part(3, I) = 3
	End Select
	Select Case Chessboard(X + I, Y - I)
	    Case 0
		Part(4, I) = 0
	    Case 1
		Part(4, I) = CurrentPlayer
	    Case 2
		Part(4, I) = 3 - CurrentPlayer
	    Case 3
		Part(4, I) = 3
	End Select
    Next
    For I = 1 To 4
	For K = -5 To 5
	    ChessboardPart(K) = Part(I, K)
	Next
	For J = 1 To UBound(ValueLibrary)
	    If CompareShape(J) Then Result = Result + ValueLibrary(J)
	Next
    Next
    GetValue = Result
End Function

Sub InitializeLibrary ()
    Dim I As Integer
    Dim J As Integer
    Const Total = 58
    ReDim Shape(1 To Total) As String
    ReDim ValueLibrary(1 To Total) As Long
    ReDim ShapeLibrary(1 To Total, -5 To 5) As Integer
    Shape(1) = "???X_ XXX??-200"
    Shape(2) = "??XX_ XX???-200"
    Shape(3) = "|???? ?????-5"
    Shape(4) = "?|??? ?????-10"
    Shape(5) = "??|?? ?????-15"
    Shape(6) = "???|? ?????-20"
    Shape(7) = "????| ?????-50"
    Shape(8) = "????O ?????20"
    Shape(9) = "???O? ?????10"
    Shape(10) = "??O?? ?????5"
    Shape(11) = "?O??? ?????2"
    Shape(12) = "????X ?????15"
    Shape(13) = "???X? ?????8"
    Shape(14) = "??X?? ?????4"
    Shape(15) = "?X??? ?????1"
    Shape(16) = "????? OOO_?100"
    Shape(17) = "????O OO_??100"
    Shape(18) = "???OO O_???100"
    Shape(19) = "??OOO _????100"
    Shape(20) = "????? XXX_?90"
    Shape(21) = "????X XX_??90"
    Shape(22) = "???XX X_???90"
    Shape(23) = "??XXX _????90"
    Shape(24) = "????_ OOO_?500"
    Shape(25) = "???_O OO_??500"
    Shape(26) = "????_ XXX_?300"
    Shape(27) = "???_X XX_??300"
    Shape(28) = "????? OOO??25"
    Shape(29) = "????O OO???25"
    Shape(30) = "????? XXX??25"
    Shape(31) = "????X XX???25"
    Shape(32) = "????? _OOO?100"
    Shape(33) = "????? _OOO_300"
    Shape(34) = "????? _XXX?80"
    Shape(35) = "????? _XXX_250"
    Shape(36) = "????? O_OOO-50"
    Shape(37) = "????? OO???20"
    Shape(38) = "????O O????20"
    Shape(39) = "????? XX???15"
    Shape(40) = "????X X????15"
    Shape(41) = "????? XXXO?-20"
    Shape(42) = "????? OOOX?20"
    Shape(43) = "????? X_XX?80"
    Shape(44) = "????? O_OO?100"
    Shape(45) = "????? XX_X?80"
    Shape(46) = "????? OO_O?100"
    Shape(47) = "????? X_XX_300"
    Shape(48) = "????? O_OO_400"
    Shape(49) = "????? XX_X_300"
    Shape(50) = "????? OO_O_400"
    Shape(51) = "?XXX_ X????-200"
    Shape(52) = "????_ OOOX?100"
    Shape(53) = "?OOOO ?????16000"
    Shape(54) = "??OOO O????16000"
    Shape(55) = "???OO OO???16000"
    Shape(56) = "?XXXX ?????15000"
    Shape(57) = "??XXX X????15000"
    Shape(58) = "???XX XX???15000"
    For I = 1 To Total
	For J = 1 To 11
	    Select Case Mid$(Shape(I), J, 1)
		Case "_"
		    ShapeLibrary(I, J - 6) = 0
		Case "O"
		    ShapeLibrary(I, J - 6) = 1
		Case "X"
		    ShapeLibrary(I, J - 6) = 2
		Case "|"
		    ShapeLibrary(I, J - 6) = 3
		Case "?", " "
		    ShapeLibrary(I, J - 6) = 4
	    End Select
	Next
	ValueLibrary(I) = Val(Right$(Shape(I), Len(Shape(I)) - 11))
    Next
End Sub

Sub OptionBlack_KeyPress (Index As Integer, KeyAscii As Integer)
    Dim I As Integer
    If KeyAscii = 27 Then
	FrameBlack.Visible = False
	FrameWhite.Visible = False
	Line (FrameBlack.Left - 130, FrameBlack.Top - 130)-(FrameWhite.Left + FrameWhite.Width + 130, FrameWhite.Top + FrameWhite.Height + 130), RGB(0, 0, 0), BF
	FontName = "宋体"
	FontSize = UserToPixelX(75)
	DrawWidth = 3
	Line (3050, 2450)-(3950, 2750), RGB(0, 255, 0), B
	DrawWidth = 2
	Line (3050, 2600)-(3950, 2600), RGB(0, 255, 0)
	ForeColor = RGB(0, 255, 255)
	CurrentX = 3500 - TextWidth("程序设计：王纯") / 2
	CurrentY = 2525 - TextHeight("程序设计：王纯") / 2
	Print "程序设计：王纯"
	CurrentX = 3500 - TextWidth("1998年5月5日") / 2
	CurrentY = 2675 - TextHeight("1998年5月5日") / 2
	Print "1998年5月5日"
	For I = 0 To 2
	    CommandMainMenu(I).Enabled = True
	Next
	DrawWidth = 5
	DrawStyle = 6
	For I = 0 To 250 Step 10
	    Line (CommandMainMenu(0).Left - I / 2, CommandMainMenu(0).Top - I / 2)-(CommandMainMenu(0).Left + CommandMainMenu(0).Width * 3 + I / 2, CommandMainMenu(0).Top + CommandMainMenu(0).Height + I / 2), RGB(255 - I, 255 - I, 255 - I), B
	Next
    End If
    If KeyAscii = 13 Then PlayGame
End Sub

Sub OptionWhite_KeyPress (Index As Integer, KeyAscii As Integer)
    Dim I As Integer
    If KeyAscii = 27 Then
	FrameBlack.Visible = False
	FrameWhite.Visible = False
	Line (FrameBlack.Left - 130, FrameBlack.Top - 130)-(FrameWhite.Left + FrameWhite.Width + 130, FrameWhite.Top + FrameWhite.Height + 130), RGB(0, 0, 0), BF
	FontName = "宋体"
	FontSize = UserToPixelX(75)
	DrawWidth = 3
	Line (3050, 2450)-(3950, 2750), RGB(0, 255, 0), B
	DrawWidth = 2
	Line (3050, 2600)-(3950, 2600), RGB(0, 255, 0)
	ForeColor = RGB(0, 255, 255)
	CurrentX = 3500 - TextWidth("程序设计：王纯") / 2
	CurrentY = 2525 - TextHeight("程序设计：王纯") / 2
	Print "程序设计：王纯"
	CurrentX = 3500 - TextWidth("1998年5月5日") / 2
	CurrentY = 2675 - TextHeight("1998年5月5日") / 2
	Print "1998年5月5日"
	For I = 0 To 2
	    CommandMainMenu(I).Enabled = True
	Next
	DrawWidth = 5
	DrawStyle = 6
	For I = 0 To 250 Step 10
	    Line (CommandMainMenu(0).Left - I / 2, CommandMainMenu(0).Top - I / 2)-(CommandMainMenu(0).Left + CommandMainMenu(0).Width * 3 + I / 2, CommandMainMenu(0).Top + CommandMainMenu(0).Height + I / 2), RGB(255 - I, 255 - I, 255 - I), B
	Next
    End If
    If KeyAscii = 13 Then PlayGame
End Sub

Sub PictureChessboard_KeyDown (KeyCode As Integer, Shift As Integer)
    Dim Ret As Integer
    If Shift Then Exit Sub
    If CurrentInput = 0 Then
	Select Case KeyCode
	    Case 38
		If KeyboardY > 0 Then
		    DrawKeyboardCursor
		    KeyboardY = KeyboardY - 1
		    DrawKeyboardCursor
		    PictureChessboard.Refresh
		End If
	    Case 40
		If KeyboardY < 14 Then
		    DrawKeyboardCursor
		    KeyboardY = KeyboardY + 1
		    DrawKeyboardCursor
		    PictureChessboard.Refresh
		End If
	    Case 37
		If KeyboardX > 0 Then
		    DrawKeyboardCursor
		    KeyboardX = KeyboardX - 1
		    DrawKeyboardCursor
		    PictureChessboard.Refresh
		End If
	    Case 39
		If KeyboardX < 14 Then
		    DrawKeyboardCursor
		    KeyboardX = KeyboardX + 1
		    DrawKeyboardCursor
		    PictureChessboard.Refresh
		End If
	    Case 13
		MoveX = KeyboardX
		MoveY = KeyboardY
	End Select
    End If
End Sub

Sub PictureChessboard_KeyPress (KeyAscii As Integer)
    Dim Ret As Integer
    KeyAscii = Asc(UCase$(Chr$(KeyAscii)))
    If KeyAscii = 27 Then
	IsExit = True
    Else
	If CurrentInput = 1 Then
	    Select Case KeyAscii
		Case Asc("W")
		    If KeyboardY > 0 Then
			DrawKeyboardCursor
			KeyboardY = KeyboardY - 1
			DrawKeyboardCursor
			PictureChessboard.Refresh
		    End If
		Case Asc("S")
		    If KeyboardY < 14 Then
			DrawKeyboardCursor
			KeyboardY = KeyboardY + 1
			DrawKeyboardCursor
			PictureChessboard.Refresh
		    End If
		Case Asc("A")
		    If KeyboardX > 0 Then
			DrawKeyboardCursor
			KeyboardX = KeyboardX - 1
			DrawKeyboardCursor
			PictureChessboard.Refresh
		    End If
		Case Asc("D")
		    If KeyboardX < 14 Then
			DrawKeyboardCursor
			KeyboardX = KeyboardX + 1
			DrawKeyboardCursor
			PictureChessboard.Refresh
		    End If
		Case 32
		    MoveX = KeyboardX
		    MoveY = KeyboardY
	    End Select
	End If
    End If
End Sub

Sub PictureChessboard_MouseDown (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim Ret As Integer
    If Button = 1 And Shift = 0 And CurrentInput = 2 Then
	MoveX = Int((X - 75) / 150)
	MoveY = Int((Y - 75) / 150)
    End If
End Sub

Sub PictureHistory_Click ()
    PictureHistory.Tag = "*"
End Sub

Sub PictureHistory_KeyDown (KeyCode As Integer, Shift As Integer)
    PictureHistory.Tag = "*"
End Sub

Sub PlayGame ()
    Dim I As Integer
    Dim J As Integer
    Dim Ret As Integer
    If OptionBlack(3).Value And OptionWhite(3).Value Then MsgBox "计算机与计算机下棋，比赛结果将不能存盘。", 64, "五子棋"
    If Not OptionBlack(3).Value Then
	Do While InStr(TextBlack.Text, " ")
	    TextBlack.Text = Left$(TextBlack.Text, InStr(TextBlack.Text, " ") - 1) + Right$(TextBlack.Text, Len(TextBlack.Text) - InStr(TextBlack.Text, " "))
	Loop
	Do While InStr(TextBlack.Text, "　")
	    TextBlack.Text = Left$(TextBlack.Text, InStr(TextBlack.Text, "　") - 1) + Right$(TextBlack.Text, Len(TextBlack.Text) - InStr(TextBlack.Text, "　") - 1)
	Loop
	For I = 1 To Len(TextBlack.Text)
	    If Mid$(TextBlack.Text, I, 1) <= Chr$(160) Then
		MsgBox "姓名不能用半角字符！", 48, "五子棋"
		Exit Sub
	    End If
	Next
	If TextBlack.Text = "" Then MsgBox "黑方没有输入姓名，比赛结果将不能存盘。", 64, "五子棋"
	If TextWhite.Text = "计算机" Then
	    MsgBox "姓名不能为“计算机”！", 48, "五子棋"
	    Exit Sub
	End If
	If TextWhite.Text = "黑方" Then
	    MsgBox "姓名不能为“黑方”！", 48, "五子棋"
	    Exit Sub
	End If
	If TextWhite.Text = "白方" Then
	    MsgBox "姓名不能为“白方”！", 48, "五子棋"
	    Exit Sub
	End If
    Else
	TextBlack.Text = "计算机"
    End If
    If Not OptionWhite(3).Value Then
	Do While InStr(TextWhite.Text, " ")
	    TextWhite.Text = Left$(TextWhite.Text, InStr(TextWhite.Text, " ") - 1) + Right$(TextWhite.Text, Len(TextWhite.Text) - InStr(TextWhite.Text, " "))
	Loop
	Do While InStr(TextWhite.Text, "　")
	    TextWhite.Text = Left$(TextWhite.Text, InStr(TextWhite.Text, "　") - 1) + Right$(TextWhite.Text, Len(TextWhite.Text) - InStr(TextWhite.Text, "　") - 1)
	Loop
	For I = 1 To Len(TextWhite.Text)
	    If Mid$(TextWhite.Text, I, 1) <= Chr$(160) Then
		MsgBox "姓名不能用半角字符！", 48, "五子棋"
		Exit Sub
	    End If
	Next
	If TextWhite.Text = "" Then MsgBox "白方没有输入姓名，比赛结果将不能存盘。", 64, "五子棋"
	If TextWhite.Text = "计算机" Then
	    MsgBox "姓名不能为“计算机”！", 48, "五子棋"
	    Exit Sub
	End If
    Else
	TextWhite.Text = "计算机"
    End If
    If TextBlack.Text <> "计算机" And TextBlack.Text = TextWhite.Text Then MsgBox "黑方与白方姓名相同，比赛结果将不能存盘。", 64, "五子棋"
    Line (FrameBlack.Left - 130, FrameBlack.Top - 130)-(FrameWhite.Left + FrameWhite.Width + 130, FrameWhite.Top + FrameWhite.Height + 130), RGB(0, 0, 0), BF
    Line (3000, 2400)-(4000, 2800), RGB(0, 0, 0), BF
    FrameBlack.Visible = False
    FrameWhite.Visible = False
    For I = 0 To 2
	CommandMainMenu(I).Visible = False
    Next
    DrawChessboard
    DrawWidth = 25
    PictureSwap.Move 800, 300, 2400, 2400
    PictureSwap.Scale (0, 0)-(2400, 2400)
    PictureSwap.DrawWidth = 25
    PictureSwap.Cls
    PictureChessboard.Tag = "*"
    HelpContextID = 7
    For I = 0 To 1700 Step 50
	Circle (2000, 1500), I, RGB(0, 0, 0)
	PictureSwap.Circle (1200, 1200), I, RGB(255, 255, 255)
	Ret = BitBlt(PictureSwap.hDC, 0, 0, UserToPixelX(2400), UserToPixelY(2400), PictureChessboard.hDC, 0, 0, SRCAND)
	Ret = BitBlt(hDC, UserToPixelX(800), UserToPixelY(300), UserToPixelX(2400), UserToPixelY(2400), PictureSwap.hDC, 0, 0, SRCPAINT)
	DoEvents
	If PictureChessboard.Tag <> "*" Then Exit For
    Next
    HelpContextID = 0
    For I = -5 To 19
	For J = -5 To 19
	    Chessboard(I, J) = 3
	Next
    Next
    For I = 0 To 14
	For J = 0 To 14
	    Chessboard(I, J) = 0
	Next
    Next
    PictureChessboard.Visible = True
    Cls
    FontName = "System"
    FontSize = 12
    ForeColor = RGB(255, 255, 255)
    FontSize = UserToPixelX(120)
    ForeColor = RGB(0, 255, 255)
    CurrentX = 400 - TextWidth("黑方") / 2
    CurrentY = 300
    Print "黑方"
    CurrentX = 3600 - TextWidth("白方") / 2
    CurrentY = 300
    Print "白方"
    FontSize = UserToPixelX(60)
    ForeColor = RGB(255, 0, 255)
    CurrentX = 100
    CurrentY = 600
    If TextBlack.Text <> "" Then Print "姓名：" + TextBlack.Text
    CurrentX = 3300
    CurrentY = 600
    If TextWhite.Text <> "" Then Print "姓名：" + TextWhite.Text
    Tag = "黑方"
    DrawWidth = 3
    Line (200, 500)-(600, 500), RGB(255, 255, 0)
    PictureChessboard.Tag = "0"
    KeyboardX = 7
    KeyboardY = 7
    IsExit = False
    TimerBlack.Tag = "0"
    TimerWhite.Tag = "0"
    FontTransparent = False
    ForeColor = RGB(255, 0, 255)
    CurrentX = 100
    CurrentY = 1000
    Print "用时：0秒"
    CurrentX = 3300
    CurrentY = 1000
    Print "用时：0秒"
    FontTransparent = True
    Refresh
    HelpContextID = 8
    Do
	FontTransparent = False
	CurrentX = 2000 - TextWidth("第" + Format$(Val(PictureChessboard.Tag) + 1) + "回合") / 2
	CurrentY = 100
	ForeColor = RGB(255, 255, 255)
	Print "第" + Format$(Val(PictureChessboard.Tag) + 1) + "回合"
	FontTransparent = True
	Refresh
	If Tag = "黑方" Then
	    TimerBlack.Enabled = True
	    TimerWhite.Enabled = False
	    If OptionBlack(0).Value Then CurrentInput = 0
	    If OptionBlack(1).Value Then CurrentInput = 1
	    If OptionBlack(2).Value Then CurrentInput = 2
	    If OptionBlack(3).Value Then CurrentInput = 3
	    If CurrentInput = 3 Then
		HelpContextID = 9
		Ret = ComputerMove()
		HelpContextID = 8
		If IsExit Then
		    If MsgBox("真要退出吗？", 36, "五子棋") = 6 Then
			TimerBlack.Enabled = False
			TimerWhite.Enabled = False
			PictureChessboard.Visible = False
			Title
			Exit Sub
		    Else
			IsExit = False
		    End If
		End If
	    Else
		If CurrentInput < 2 Then DrawKeyboardCursor
		Do
		    MoveX = -1
		    MoveY = -1
		    Do
			DoEvents
			If IsExit Then
			    If MsgBox("真要退出吗？", 36, "五子棋") = 6 Then
				TimerBlack.Enabled = False
				TimerWhite.Enabled = False
				PictureChessboard.Visible = False
				Title
				Exit Sub
			    Else
				IsExit = False
			    End If
			End If
		    Loop While MoveX < 0 Or MoveY < 0
		    Ret = SetChessman(MoveX, MoveY)
		Loop Until Ret
		If CurrentInput < 2 Then DrawKeyboardCursor
	    End If
	Else
	    TimerBlack.Enabled = False
	    TimerWhite.Enabled = True
	    If OptionWhite(0).Value Then CurrentInput = 0
	    If OptionWhite(1).Value Then CurrentInput = 1
	    If OptionWhite(2).Value Then CurrentInput = 2
	    If OptionWhite(3).Value Then CurrentInput = 3
	    If CurrentInput = 3 Then
		HelpContextID = 9
		Ret = ComputerMove()
		HelpContextID = 8
		If IsExit Then
		    If MsgBox("真要退出吗？", 36, "五子棋") = 6 Then
			TimerBlack.Enabled = False
			TimerWhite.Enabled = False
			PictureChessboard.Visible = False
			Title
			Exit Sub
		    Else
			IsExit = False
		    End If
		End If
	    Else
		If CurrentInput < 2 Then DrawKeyboardCursor
		Do
		    MoveX = -1
		    MoveY = -1
		    Do
			DoEvents
			If IsExit Then
			    If MsgBox("真要退出吗？", 36, "五子棋") = 6 Then
				TimerBlack.Enabled = False
				TimerWhite.Enabled = False
				PictureChessboard.Visible = False
				Title
				Exit Sub
			    Else
				IsExit = False
			    End If
			End If
		    Loop While MoveX < 0 Or MoveY < 0
		    Ret = SetChessman(MoveX, MoveY)
		Loop Until Ret
		If CurrentInput < 2 Then DrawKeyboardCursor
	    End If
	End If
    Loop Until Ret = 1
    TimerBlack.Enabled = False
    TimerWhite.Enabled = False
    PictureChessboard.Visible = False
    If ShowHistory() Then
	PictureHistory.Tag = ""
	PictureHistory.Visible = True
	Do
	    DoEvents
	Loop Until PictureHistory.Tag = "*"
	Cls
	PictureHistory.Visible = False
    End If
    Title
End Sub

Sub SaveResult (ResultName As String, Result As Integer)
    Dim I As Integer
    Dim IsExist As Integer
    Dim FileName As String
    Dim SaveName As String * 6
    Dim PlayerName As String * 6
    Dim UsefulValue As Long
    FileName = App.Path
    If FileName <> "" Then
	If Right$(FileName, 1) <> ":" And Right$(FileName, 1) <> "\" Then FileName = FileName + "\"
    End If
    FileName = FileName + "WZQ.DAT"
    SaveName = ResultName
    Open FileName For Binary As #1
    IsExist = 0
    For I = 1 To LOF(1) \ 18
	Get #1, , PlayerName
	Get #1, , UsefulValue
	Get #1, , UsefulValue
	Get #1, , UsefulValue
	If PlayerName = SaveName Then IsExist = 1
    Next
    Close #1
    Open FileName For Binary As #1
    ReDim HistoryName(1 To LOF(1) \ 18 + 1 - IsExist) As String * 6
    ReDim HistoryTotal(1 To LOF(1) \ 18 + 1 - IsExist) As Long
    ReDim HistoryWin(1 To LOF(1) \ 18 + 1 - IsExist) As Long
    ReDim HistoryFailure(1 To LOF(1) \ 18 + 1 - IsExist) As Long
    For I = 1 To LOF(1) \ 18
	Get #1, , HistoryName(I)
	Get #1, , HistoryTotal(I)
	Get #1, , HistoryWin(I)
	Get #1, , HistoryFailure(I)
	If HistoryName(I) = SaveName Then
	    HistoryTotal(I) = HistoryTotal(I) + 1
	    Select Case Result
		Case -1
		    HistoryFailure(I) = HistoryFailure(I) + 1
		Case 1
		    HistoryWin(I) = HistoryWin(I) + 1
	    End Select
	End If
    Next
    If IsExist = 0 Then
	HistoryName(LOF(1) \ 18 + 1) = SaveName
	HistoryTotal(LOF(1) \ 18 + 1) = 1
	Select Case Result
	    Case -1
		HistoryFailure(I) = 1
	    Case 1
		HistoryWin(I) = 1
	End Select
    End If
    Close #1
    Open FileName For Binary As #1
    For I = 1 To UBound(HistoryName)
	Put #1, , HistoryName(I)
	Put #1, , HistoryTotal(I)
	Put #1, , HistoryWin(I)
	Put #1, , HistoryFailure(I)
    Next
    Close #1
End Sub

Function SetChessman (X As Integer, Y As Integer) As Integer
    Dim Result As Integer
    Dim CurrentPlayer As Integer
    If Tag = "黑方" Then CurrentPlayer = 1 Else CurrentPlayer = 2
    SetChessman = 0
    If X < 0 Or Y < 0 Or X > 14 Or Y > 14 Then Exit Function
    If Tag = "黑方" Then
	If Chessboard(X, Y) = 0 Then
	    PictureChessboard.FillStyle = 0
	    PictureChessboard.FillColor = RGB(0, 0, 0)
	    PictureChessboard.Circle (X * 150 + 150, Y * 150 + 150), 50, RGB(0, 0, 0)
	    Chessboard(X, Y) = 1
	    If GetFocus() = PictureChessboard.hWnd And OptionBlack(3).Value Then SetCursorPos UserToPixelX(X * 150 + 950), UserToPixelY(Y * 150 + 450)
	    Tag = "白方"
	    DrawWidth = 3
	    Line (200, 500)-(600, 500), RGB(0, 0, 0)
	    Line (3400, 500)-(3800, 500), RGB(255, 255, 0)
	    PictureChessboard.Tag = Format$(Val(PictureChessboard.Tag) + 1)
	    SetChessman = -1
	Else
	    Exit Function
	End If
    Else
	If Chessboard(X, Y) = 0 Then
	    PictureChessboard.FillStyle = 0
	    PictureChessboard.FillColor = RGB(255, 255, 255)
	    PictureChessboard.Circle (X * 150 + 150, Y * 150 + 150), 50, RGB(255, 255, 255)
	    Chessboard(X, Y) = 2
	    If GetFocus() = PictureChessboard.hWnd And OptionWhite(3).Value Then SetCursorPos UserToPixelX(X * 150 + 950), UserToPixelY(Y * 150 + 450)
	    Tag = "黑方"
	    DrawWidth = 3
	    Line (200, 500)-(600, 500), RGB(255, 255, 0)
	    Line (3400, 500)-(3800, 500), RGB(0, 0, 0)
	    PictureChessboard.Tag = Format$(Val(PictureChessboard.Tag) + 1)
	    SetChessman = -1
	Else
	    Exit Function
	End If
    End If
    If Val(PictureChessboard.Tag) = 225 Then
	MsgBox "平局", 0, "五子棋"
	If TextBlack.Text <> "" And TextWhite.Text <> "" And TextBlack.Text <> TextWhite.Text Then
	    SaveResult Format$(TextBlack.Text), 0
	    SaveResult Format$(TextWhite.Text), 0
	End If
	SetChessman = 1
    Else
	Result = CheckWin(CurrentPlayer, X, Y)
	If Result = -2 Or Result = 2 Then
	    Result = Result \ 2
	    If CurrentPlayer = 1 Then Result = -Result
	Else
	    Result = 0
	End If
	Select Case Result
	    Case -1
		If TextBlack.Text = "" Or TextBlack.Text = TextWhite.Text Then
		    MsgBox "黑方赢了！", 0, "五子棋"
		Else
		    MsgBox TextBlack.Text + "赢了！", 0, "五子棋"
		    If TextBlack.Text <> "" And TextWhite.Text <> "" And TextBlack.Text <> TextWhite.Text Then
			SaveResult Format$(TextBlack.Text), 1
			SaveResult Format$(TextWhite.Text), -1
		    End If
		End If
		SetChessman = 1
	    Case 1
		If TextWhite.Text = "" Or TextBlack.Text = TextWhite.Text Then
		    MsgBox "白方赢了！", 0, "五子棋"
		Else
		    MsgBox TextWhite.Text + "赢了！", 0, "五子棋"
		    If TextBlack.Text <> "" And TextWhite.Text <> "" And TextBlack.Text <> TextWhite.Text Then
			SaveResult Format$(TextBlack.Text), -1
			SaveResult Format$(TextWhite.Text), 1
		    End If
		End If
		SetChessman = 1
	End Select
    End If
    KeyboardX = X
    KeyboardY = Y
    PictureChessboard.Refresh
End Function

Function ShowHistory ()
    Dim I As Integer
    Dim IsSwap As Integer
    Dim FileName As String
    Dim PlayerName As String * 6
    Dim UsefulValue As Long
    FileName = App.Path
    If FileName <> "" Then
	If Right$(FileName, 1) <> ":" And Right$(FileName, 1) <> "\" Then FileName = FileName + "\"
    End If
    FileName = FileName + "WZQ.DAT"
    Open FileName For Binary As #1
    If LOF(1) < 18 Then
	MsgBox "无历史记录。", 64, "五子棋"
	ShowHistory = False
	Close #1
	Exit Function
    End If
    ReDim HistoryName(1 To LOF(1) \ 18) As String * 6
    ReDim HistoryTotal(1 To LOF(1) \ 18) As Long
    ReDim HistoryWin(1 To LOF(1) \ 18) As Long
    ReDim HistoryFailure(1 To LOF(1) \ 18) As Long
    ReDim HistoryMark(1 To LOF(1) \ 18) As Long
    For I = 1 To UBound(HistoryName)
	Get #1, , HistoryName(I)
	Get #1, , HistoryTotal(I)
	Get #1, , HistoryWin(I)
	Get #1, , HistoryFailure(I)
	HistoryMark(I) = HistoryTotal(I) * 1 + HistoryWin(I) * 2 - HistoryFailure(I) * 1
    Next
    Close #1
    Do
	IsSwap = False
	For I = 1 To UBound(HistoryName) - 1
	    If HistoryMark(I) < HistoryMark(I + 1) Then
		PlayerName = HistoryName(I)
		HistoryName(I) = HistoryName(I + 1)
		HistoryName(I + 1) = PlayerName
		UsefulValue = HistoryTotal(I)
		HistoryTotal(I) = HistoryTotal(I + 1)
		HistoryTotal(I + 1) = UsefulValue
		UsefulValue = HistoryWin(I)
		HistoryWin(I) = HistoryWin(I + 1)
		HistoryWin(I + 1) = UsefulValue
		UsefulValue = HistoryFailure(I)
		HistoryFailure(I) = HistoryFailure(I + 1)
		HistoryFailure(I + 1) = UsefulValue
		UsefulValue = HistoryMark(I)
		HistoryMark(I) = HistoryMark(I + 1)
		HistoryMark(I + 1) = UsefulValue
		IsSwap = True
	    End If
	Next
    Loop While IsSwap
    PictureHistory.Cls
    PictureHistory.FontName = "黑体"
    PictureHistory.FontBold = True
    PictureHistory.FontSize = UserToPixelX(240)
    PictureHistory.CurrentX = (PictureHistory.Width - PictureHistory.TextWidth("历史记录")) / 2
    PictureHistory.CurrentY = 100
    PictureHistory.ForeColor = RGB(255, 255, 0)
    PictureHistory.Print "历史记录"
    PictureHistory.ForeColor = RGB(0, 255, 255)
    PictureHistory.FontName = "宋体"
    PictureHistory.FontBold = True
    PictureHistory.FontSize = UserToPixelX(120)
    PictureHistory.CurrentX = 800 - PictureHistory.TextWidth("姓名") / 2
    PictureHistory.CurrentY = 500
    PictureHistory.Print "姓名"
    PictureHistory.CurrentX = 1800 - PictureHistory.TextWidth("比赛次数") / 2
    PictureHistory.CurrentY = 500
    PictureHistory.Print "比赛次数"
    PictureHistory.CurrentX = 2300 - PictureHistory.TextWidth("胜") / 2
    PictureHistory.CurrentY = 500
    PictureHistory.Print "胜"
    PictureHistory.CurrentX = 2700 - PictureHistory.TextWidth("败") / 2
    PictureHistory.CurrentY = 500
    PictureHistory.Print "败"
    PictureHistory.CurrentX = 3100 - PictureHistory.TextWidth("平") / 2
    PictureHistory.CurrentY = 500
    PictureHistory.Print "平"
    PictureHistory.CurrentX = 3600 - PictureHistory.TextWidth("积分") / 2
    PictureHistory.CurrentY = 500
    PictureHistory.Print "积分"
    PictureHistory.FontSize = UserToPixelX(90)
    PictureHistory.FontBold = False
    For I = 1 To 10
	If HistoryName(I) = "计算机" Then PictureHistory.ForeColor = RGB(255, 255, 0) Else PictureHistory.ForeColor = RGB(255, 0, 255)
	PictureHistory.FontName = "Times New Roman"
	PictureHistory.FontBold = True
	PictureHistory.CurrentX = 100 - PictureHistory.TextWidth(Format$(I))
	PictureHistory.CurrentY = I * 150 + 600
	PictureHistory.Print Format$(I)
	PictureHistory.FontName = "宋体"
	PictureHistory.FontBold = False
	PictureHistory.CurrentX = 800 - PictureHistory.TextWidth(HistoryName(I)) / 2
	PictureHistory.CurrentY = I * 150 + 600
	PictureHistory.Print HistoryName(I)
	PictureHistory.FontName = "Times New Roman"
	PictureHistory.FontBold = True
	PictureHistory.CurrentX = 1800 - PictureHistory.TextWidth(Format$(HistoryTotal(I))) / 2
	PictureHistory.CurrentY = I * 150 + 600
	PictureHistory.Print HistoryTotal(I)
	PictureHistory.CurrentX = 2300 - PictureHistory.TextWidth(Format$(HistoryWin(I))) / 2
	PictureHistory.CurrentY = I * 150 + 600
	PictureHistory.Print HistoryWin(I)
	PictureHistory.CurrentX = 2700 - PictureHistory.TextWidth(Format$(HistoryFailure(I))) / 2
	PictureHistory.CurrentY = I * 150 + 600
	PictureHistory.Print HistoryFailure(I)
	PictureHistory.CurrentX = 3100 - PictureHistory.TextWidth(Format$(HistoryTotal(I) - HistoryWin(I) - HistoryFailure(I))) / 2
	PictureHistory.CurrentY = I * 150 + 600
	PictureHistory.Print HistoryTotal(I) - HistoryWin(I) - HistoryFailure(I)
	PictureHistory.CurrentX = 3600 - PictureHistory.TextWidth(Format$(HistoryMark(I))) / 2
	PictureHistory.CurrentY = I * 150 + 600
	PictureHistory.Print HistoryMark(I)
	If UBound(HistoryName) = I Then Exit For
    Next
    ShowHistory = True
End Function

Sub TextBlack_KeyPress (KeyAscii As Integer)
    Dim I As Integer
    If KeyAscii = 27 Then
	FrameBlack.Visible = False
	FrameWhite.Visible = False
	Line (FrameBlack.Left - 130, FrameBlack.Top - 130)-(FrameWhite.Left + FrameWhite.Width + 130, FrameWhite.Top + FrameWhite.Height + 130), RGB(0, 0, 0), BF
	FontName = "宋体"
	FontSize = UserToPixelX(75)
	DrawWidth = 3
	Line (3050, 2450)-(3950, 2750), RGB(0, 255, 0), B
	DrawWidth = 2
	Line (3050, 2600)-(3950, 2600), RGB(0, 255, 0)
	ForeColor = RGB(0, 255, 255)
	CurrentX = 3500 - TextWidth("程序设计：王纯") / 2
	CurrentY = 2525 - TextHeight("程序设计：王纯") / 2
	Print "程序设计：王纯"
	CurrentX = 3500 - TextWidth("1998年5月5日") / 2
	CurrentY = 2675 - TextHeight("1998年5月5日") / 2
	Print "1998年5月5日"
	For I = 0 To 2
	    CommandMainMenu(I).Enabled = True
	Next
	DrawWidth = 5
	DrawStyle = 6
	For I = 0 To 250 Step 10
	    Line (CommandMainMenu(0).Left - I / 2, CommandMainMenu(0).Top - I / 2)-(CommandMainMenu(0).Left + CommandMainMenu(0).Width * 3 + I / 2, CommandMainMenu(0).Top + CommandMainMenu(0).Height + I / 2), RGB(255 - I, 255 - I, 255 - I), B
	Next
	KeyAscii = 0
    End If
    If KeyAscii = 13 Then
	PlayGame
	KeyAscii = 0
    End If
End Sub

Sub TextWhite_KeyPress (KeyAscii As Integer)
    Dim I As Integer
    If KeyAscii = 27 Then
	FrameBlack.Visible = False
	FrameWhite.Visible = False
	Line (FrameBlack.Left - 130, FrameBlack.Top - 130)-(FrameWhite.Left + FrameWhite.Width + 130, FrameWhite.Top + FrameWhite.Height + 130), RGB(0, 0, 0), BF
	FontName = "宋体"
	FontSize = UserToPixelX(75)
	DrawWidth = 3
	Line (3050, 2450)-(3950, 2750), RGB(0, 255, 0), B
	DrawWidth = 2
	Line (3050, 2600)-(3950, 2600), RGB(0, 255, 0)
	ForeColor = RGB(0, 255, 255)
	CurrentX = 3500 - TextWidth("程序设计：王纯") / 2
	CurrentY = 2525 - TextHeight("程序设计：王纯") / 2
	Print "程序设计：王纯"
	CurrentX = 3500 - TextWidth("1998年5月5日") / 2
	CurrentY = 2675 - TextHeight("1998年5月5日") / 2
	Print "1998年5月5日"
	For I = 0 To 2
	    CommandMainMenu(I).Enabled = True
	Next
	DrawWidth = 5
	DrawStyle = 6
	For I = 0 To 250 Step 10
	    Line (CommandMainMenu(0).Left - I / 2, CommandMainMenu(0).Top - I / 2)-(CommandMainMenu(0).Left + CommandMainMenu(0).Width * 3 + I / 2, CommandMainMenu(0).Top + CommandMainMenu(0).Height + I / 2), RGB(255 - I, 255 - I, 255 - I), B
	Next
	KeyAscii = 0
    End If
    If KeyAscii = 13 Then
	PlayGame
	KeyAscii = 0
    End If
End Sub

Sub TimerBlack_Timer ()
    FontTransparent = False
    ForeColor = RGB(255, 0, 255)
    CurrentX = 100
    CurrentY = 1000
    If Val(TimerBlack.Tag) < 60 Then
	Print "用时：" + TimerBlack.Tag + "秒"
    Else
	Print "用时：" + Format$(Val(TimerBlack.Tag) \ 60) + "分" + Format$(Val(TimerBlack.Tag) Mod 60, "00") + "秒"
    End If
    FontTransparent = True
    TimerBlack.Tag = Format$(Val(TimerBlack.Tag) + 1)
End Sub

Sub TimerWhite_Timer ()
    FontTransparent = False
    ForeColor = RGB(255, 0, 255)
    CurrentX = 3300
    CurrentY = 1000
    If Val(TimerWhite.Tag) < 60 Then
	Print "用时：" + TimerWhite.Tag + "秒"
    Else
	Print "用时：" + Format$(Val(TimerWhite.Tag) \ 60) + "分" + Format$(Val(TimerWhite.Tag) Mod 60, "00") + "秒"
    End If
    FontTransparent = True
    TimerWhite.Tag = Format$(Val(TimerWhite.Tag) + 1)
End Sub

Sub Title ()
    Dim I As Integer
    Dim Ret As Integer
    Dim ColorValue As Integer
    Dim StartTime As Single
    HelpContextID = 9
    Cls
    PictureSwap.Cls
    PictureSwap.DrawWidth = 1
    PictureSwap.Move 1100, 600, 1800, 600
    PictureSwap.Scale (0, 0)-(1800, 600)
    PictureSwap.FontName = "黑体"
    PictureSwap.FontSize = UserToPixelX(450)
    Do
	StartTime = Timer
	DoEvents
    Loop Until StartTime < 86395
    Do
	PictureSwap.DrawMode = 13
	PictureSwap.CurrentX = 0
	PictureSwap.CurrentY = 0
	PictureSwap.ForeColor = RGB(255, 0, 255)
	PictureSwap.Print "五子棋"
	ColorValue = (Timer - StartTime) * 255 / 3
	If ColorValue > 255 Then ColorValue = 255
	PictureSwap.DrawMode = 9
	PictureSwap.Line (0, 0)-(1800, 600), RGB(ColorValue, 0, ColorValue), BF
	Ret = BitBlt(hDC, UserToPixelX(1100), UserToPixelY(400), UserToPixelX(1800), UserToPixelY(600), PictureSwap.hDC, 0, 0, SRCCOPY)
	Refresh
	DoEvents
    Loop Until StartTime + 3 < Timer
    PictureSwap.DrawMode = 13
    CurrentX = 1100
    CurrentY = 400
    FontName = "黑体"
    FontSize = UserToPixelX(450)
    ForeColor = RGB(255, 0, 255)
    Print "五子棋"
    DrawWidth = 3
    Line (1100, 1050)-(2900, 1050), RGB(255, 255, 0)
    ForeColor = RGB(255, 0, 0)
    FontName = "宋体"
    FontSize = UserToPixelX(120)
    CurrentX = (ScaleWidth - TextWidth("版本 4.0")) / 2
    CurrentY = 1200
    Print "版本 4.0"
    ForeColor = RGB(0, 0, 255)
    FontName = "Times New Roman"
    FontSize = UserToPixelX(120)
    CurrentX = (ScaleWidth - TextWidth("for Windows")) / 2
    CurrentY = 1400
    Print "for Windows"
    FontName = "宋体"
    FontSize = UserToPixelX(75)
    Line (3050, 2450)-(3950, 2750), RGB(0, 255, 0), B
    DrawWidth = 2
    Line (3050, 2600)-(3950, 2600), RGB(0, 255, 0)
    ForeColor = RGB(0, 255, 255)
    CurrentX = 3500 - TextWidth("程序设计：王纯") / 2
    CurrentY = 2525 - TextHeight("程序设计：王纯") / 2
    Print "程序设计：王纯"
    CurrentX = 3500 - TextWidth("1998年5月5日") / 2
    CurrentY = 2675 - TextHeight("1998年5月5日") / 2
    Print "1998年5月5日"
    For I = 0 To 2
	CommandMainMenu(I).Enabled = True
	CommandMainMenu(I).Visible = True
    Next
    Refresh
    DrawWidth = 5
    DrawStyle = 6
    For I = 0 To 250 Step 10
	Line (CommandMainMenu(0).Left - I / 2, CommandMainMenu(0).Top - I / 2)-(CommandMainMenu(0).Left + CommandMainMenu(0).Width * 3 + I / 2, CommandMainMenu(0).Top + CommandMainMenu(0).Height + I / 2), RGB(255 - I, 255 - I, 255 - I), B
    Next
    HelpContextID = 0
End Sub

Function UserToPixelX (UserValue As Integer) As Integer
    UserToPixelX = UserValue * Screen.Width / Screen.TwipsPerPixelX / ScaleWidth
End Function

Function UserToPixelY (UserValue As Integer) As Integer
    UserToPixelY = UserValue * Screen.Width / Screen.TwipsPerPixelY / ScaleWidth
End Function

