Unit ChessLib;

Interface

Const
	KeyESC = $011B;
	KeyUpArrow = $4800;
	KeyDownArrow = $5000;
	KeyLeftArrow = $4B00;
	KeyRightArrow = $4D00;
	KeyEnter = $1C0D;
	KeySpace = $3920;
	LeftButton = 0;
	RightButton = 1;

Function CheckMouse: Boolean;
Function GetMousePosition: Longint;
Function IsMouseDown (Button: Byte): Boolean;
Function IsMouseUp (Button: Byte): Boolean;
Function PaletteColor (Color: Byte): Byte;
Function ReadKeyboard: Word;
Procedure ClearKeyboardBuffer;
Procedure DrawButton (Left, Top, Right, Bottom: Integer; Caption: String; IsDown: Boolean);
Procedure SetMouseCursor (State: Boolean);
Procedure SetMouseCursorImage (Image: Byte);
Procedure SetStateLine (Prompt: String; Color: Word);

Implementation

Uses Dos, Graph, Chinese;

Function CheckMouse: Boolean;
Var
	Regs: Registers;
Begin
	Regs.AX := 0;
	Intr ($33, Regs);
	If Regs.AX = 65535 Then CheckMouse := True Else CheckMouse := False
End;

Function GetMousePosition: Longint;
Var
	Regs: Registers;
Begin
	Regs.AX := 3;
	Intr ($33, Regs);
	GetMousePosition := Regs.CX + Regs.DX * $10000
End;

Function IsMouseDown (Button: Byte): Boolean;
Var
	Regs: Registers;
Begin
	Regs.AX := 5;
	Regs.BX := Button;
	Intr ($33, Regs);
	If Regs.BX <> 0 Then IsMouseDown := True Else IsMouseDown := False;
End;

Function IsMouseUp (Button: Byte): Boolean;
Var
	Regs: Registers;
Begin
	Regs.AX := 6;
	Regs.BX := Button;
	Intr ($33, Regs);
	If Regs.BX <> 0 Then IsMouseUp := True Else IsMouseUp := False;
End;

Function PaletteColor (Color: Byte): Byte;
Begin
	If Color < 8 Then PaletteColor := Color Else PaletteColor := Color + 48;
	If Color = 6 Then paletteColor := 20;
End;

Function ReadKeyboard: Word;
Var
	Regs: Registers;
Begin
	Regs.AH := 1;
	Intr ($16, Regs);
	If Regs.Flags And fZero = 0 Then
	Begin
		ReadKeyboard := Regs.AX;
	End
	Else
	Begin
		ReadKeyboard := 0;
	End
End;

Procedure ClearKeyboardBuffer;
Var
	Regs: Registers;
Begin
	Regs.AX := $0C00;
	Intr ($21, Regs);
End;

Procedure DrawButton (Left, Top, Right, Bottom: Integer; Caption: String; IsDown: Boolean);
Var
	ChessLibChinese: TChinese;
Begin
	SetColor (Black);
	SetLineStyle (SolidLn, 0, NormWidth);
	Rectangle (Left, Top, Right, Bottom);
	ChessLibChinese.FontDirectory := '';
	ChessLibChinese.FontType := ChineseFont;
	ChessLibChinese.ForeColor := Black;
	ChessLibChinese.BackColor := Transparent;
	ChessLibChinese.FontWidth := NormalSize;
	ChessLibChinese.FontHeight := NormalSize;
	If IsDown Then
	Begin
		Rectangle (Left + 1, Top + 1, Right - 1, Bottom - 1);
		SetColor (DarkGray);
		Rectangle (Left + 2, Top + 2, Right - 2, Bottom - 2);
		SetFillStyle (SolidFill, LightGray);
		Bar (Left + 3, Top + 3, Right - 2, Bottom - 2);
		ChessLibChinese.WriteChineseXY ((Left + Right - Length (Caption) * 8) Div 2 + 1, (Top + Bottom - 16) Div 2 + 1, Caption)
	End
	Else
	Begin
		SetColor (White);
		Line (Left + 1, Top + 1, Right - 2, Top + 1);
		Line (Left + 2, Top + 2, Right - 3, Top + 2);
		Line (Left + 1, Top + 2, Left + 1, Bottom - 2);
		Line (Left + 2, Top + 3, Left + 2, Bottom - 3);
		SetColor (DarkGray);
		Line (Left + 2, Bottom - 2, Right - 2, Bottom - 2);
		Line (Left + 1, Bottom - 1, Right - 1, Bottom - 1);
		Line (Right - 2, Top + 2, Right - 2, Bottom - 3);
		Line (Right - 1, Top + 1, Right - 1, Bottom - 2);
		SetFillStyle (SolidFill, LightGray);
		Bar (Left + 3, Top + 3, Right - 3, Bottom - 3);
		ChessLibChinese.WriteChineseXY ((Left + Right - Length (Caption) * 8) Div 2, (Top + Bottom - 16) Div 2, Caption)
	End
End;

Procedure SetMouseCursor (State: Boolean);
Var
	Regs: Registers;
Begin
	If State Then
	Begin
		Regs.AX := 1;
		Intr ($33, Regs);
	End
	Else
	Begin
		Regs.AX := 2;
		Intr ($33, Regs);
	End
End;

Procedure SetMouseCursorImage (Image: Byte);
Var
	Regs: Registers;
	ImageMasks: Array [0..31] Of Word;
Begin
	Case Image Of
		0:
		Begin
			ImageMasks [0] := $3FFF;
			ImageMasks [1] := $1FFF;
			ImageMasks [2] := $0FFF;
			ImageMasks [3] := $07FF;
			ImageMasks [4] := $03FF;
			ImageMasks [5] := $01FF;
			ImageMasks [6] := $00FF;
			ImageMasks [7] := $007F;
			ImageMasks [8] := $003F;
			ImageMasks [9] := $001F;
			ImageMasks [10] := $01FF;
			ImageMasks [11] := $10FF;
			ImageMasks [12] := $30FF;
			ImageMasks [13] := $F87F;
			ImageMasks [14] := $F87F;
			ImageMasks [15] := $FC7F;
			ImageMasks [16] := $0000;
			ImageMasks [17] := $4000;
			ImageMasks [18] := $6000;
			ImageMasks [19] := $7000;
			ImageMasks [20] := $7800;
			ImageMasks [21] := $7C00;
			ImageMasks [22] := $7E00;
			ImageMasks [23] := $7F00;
			ImageMasks [24] := $7F80;
			ImageMasks [25] := $7C00;
			ImageMasks [26] := $6C00;
			ImageMasks [27] := $4600;
			ImageMasks [28] := $0600;
			ImageMasks [29] := $0300;
			ImageMasks [30] := $0300;
			ImageMasks [31] := $0000;
		End;
		1:
		Begin
			ImageMasks [0] := $FFFF;
			ImageMasks [1] := $FFFF;
			ImageMasks [2] := $FFFF;
			ImageMasks [3] := $FFFF;
			ImageMasks [4] := $FFFF;
			ImageMasks [5] := $FFFF;
			ImageMasks [6] := $FFFF;
			ImageMasks [7] := $FFFF;
			ImageMasks [8] := $FFFF;
			ImageMasks [9] := $FFFF;
			ImageMasks [10] := $FFFF;
			ImageMasks [11] := $FFFF;
			ImageMasks [12] := $FFFF;
			ImageMasks [13] := $FFFF;
			ImageMasks [14] := $FFFF;
			ImageMasks [15] := $FFFF;
			ImageMasks [16] := $0000;
			ImageMasks [17] := $0000;
			ImageMasks [18] := $0000;
			ImageMasks [19] := $0000;
			ImageMasks [20] := $0000;
			ImageMasks [21] := $0000;
			ImageMasks [22] := $0000;
			ImageMasks [23] := $FFFE;
			ImageMasks [24] := $0000;
			ImageMasks [25] := $0000;
			ImageMasks [26] := $0000;
			ImageMasks [27] := $0000;
			ImageMasks [28] := $0000;
			ImageMasks [29] := $0000;
			ImageMasks [30] := $0000;
			ImageMasks [31] := $0000;
		End;
		2:
		Begin
			ImageMasks [0] := $FFFF;
			ImageMasks [1] := $FFFF;
			ImageMasks [2] := $FFFF;
			ImageMasks [3] := $FFFF;
			ImageMasks [4] := $FFFF;
			ImageMasks [5] := $FFFF;
			ImageMasks [6] := $FFFF;
			ImageMasks [7] := $FFFF;
			ImageMasks [8] := $FFFF;
			ImageMasks [9] := $FFFF;
			ImageMasks [10] := $FFFF;
			ImageMasks [11] := $FFFF;
			ImageMasks [12] := $FFFF;
			ImageMasks [13] := $FFFF;
			ImageMasks [14] := $FFFF;
			ImageMasks [15] := $FFFF;
			ImageMasks [16] := $0000;
			ImageMasks [17] := $0000;
			ImageMasks [18] := $0008;
			ImageMasks [19] := $0010;
			ImageMasks [20] := $0020;
			ImageMasks [21] := $0040;
			ImageMasks [22] := $0080;
			ImageMasks [23] := $0100;
			ImageMasks [24] := $0200;
			ImageMasks [25] := $0400;
			ImageMasks [26] := $0800;
			ImageMasks [27] := $1000;
			ImageMasks [28] := $2000;
			ImageMasks [29] := $0000;
			ImageMasks [30] := $0000;
			ImageMasks [31] := $0000;
		End;
		3:
		Begin
			ImageMasks [0] := $FFFF;
			ImageMasks [1] := $FFFF;
			ImageMasks [2] := $FFFF;
			ImageMasks [3] := $FFFF;
			ImageMasks [4] := $FFFF;
			ImageMasks [5] := $FFFF;
			ImageMasks [6] := $FFFF;
			ImageMasks [7] := $FFFF;
			ImageMasks [8] := $FFFF;
			ImageMasks [9] := $FFFF;
			ImageMasks [10] := $FFFF;
			ImageMasks [11] := $FFFF;
			ImageMasks [12] := $FFFF;
			ImageMasks [13] := $FFFF;
			ImageMasks [14] := $FFFF;
			ImageMasks [15] := $FFFF;
			ImageMasks [16] := $0100;
			ImageMasks [17] := $0100;
			ImageMasks [18] := $0100;
			ImageMasks [19] := $0100;
			ImageMasks [20] := $0100;
			ImageMasks [21] := $0100;
			ImageMasks [22] := $0100;
			ImageMasks [23] := $0100;
			ImageMasks [24] := $0100;
			ImageMasks [25] := $0100;
			ImageMasks [26] := $0100;
			ImageMasks [27] := $0100;
			ImageMasks [28] := $0100;
			ImageMasks [29] := $0100;
			ImageMasks [30] := $0100;
			ImageMasks [31] := $0000;
		End;
		4:
		Begin
			ImageMasks [0] := $FFFF;
			ImageMasks [1] := $FFFF;
			ImageMasks [2] := $FFFF;
			ImageMasks [3] := $FFFF;
			ImageMasks [4] := $FFFF;
			ImageMasks [5] := $FFFF;
			ImageMasks [6] := $FFFF;
			ImageMasks [7] := $FFFF;
			ImageMasks [8] := $FFFF;
			ImageMasks [9] := $FFFF;
			ImageMasks [10] := $FFFF;
			ImageMasks [11] := $FFFF;
			ImageMasks [12] := $FFFF;
			ImageMasks [13] := $FFFF;
			ImageMasks [14] := $FFFF;
			ImageMasks [15] := $FFFF;
			ImageMasks [16] := $0000;
			ImageMasks [17] := $0000;
			ImageMasks [18] := $2000;
			ImageMasks [19] := $1000;
			ImageMasks [20] := $0800;
			ImageMasks [21] := $0400;
			ImageMasks [22] := $0200;
			ImageMasks [23] := $0100;
			ImageMasks [24] := $0080;
			ImageMasks [25] := $0040;
			ImageMasks [26] := $0020;
			ImageMasks [27] := $0010;
			ImageMasks [28] := $0008;
			ImageMasks [29] := $0000;
			ImageMasks [30] := $0000;
			ImageMasks [31] := $0000;
		End
	End;
	Regs.AX := 9;
	Regs.BX := 0;
	Regs.CX := 0;
	Regs.ES := Seg (ImageMasks);
	Regs.DX := Ofs (ImageMasks);
	Intr ($33, Regs);
End;

Procedure SetStateLine (Prompt: String; Color: Word);
Var
	ChessLibChinese: TChinese;
Begin
	If Length (Prompt) > 78 Then Prompt := Copy (Prompt, 1, 75) + '...';
	SetFillStyle (SolidFill, Color);
	Bar (0, 460, 639, 479);
	ChessLibChinese.FontDirectory := '';
	ChessLibChinese.FontType := ChineseFont;
	ChessLibChinese.FontWidth := NormalSize;
	ChessLibChinese.FontHeight := NormalSize;
	ChessLibChinese.ForeColor := Black;
	ChessLibChinese.BackColor := Transparent;
	ChessLibChinese.WriteChineseXY (8, 462, Prompt)
End;

End.
