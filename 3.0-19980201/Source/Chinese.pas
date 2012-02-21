Unit Chinese;

Interface

Const
	Transparent = -1;
    NormalSize = 16;
    ChineseFont = 0;
    EnglishFont = 1;

Type
	TChinese = Object
    	Public
        ForeColor, BackColor: Shortint;
		FontType: Byte;
        CurrentX, CurrentY: Integer;
		FontWidth, FontHeight: Integer;
        FontDirectory: String;
       	Procedure WriteChinese (TextString: String);
        Procedure WriteChineseXY (X, Y: Integer; TextString: String);
        Private
        Procedure OutChineseCharacter (TextString: String);
		Procedure OutEnglishCharacter (TextString: String);
    End;

Implementation

Uses Graph;

Type
	EnglishFontDataArray = Array [0..15] Of Byte;
	ChineseFontDataArray = Array [0..15] Of Word;

Procedure TChinese.WriteChinese (TextString: String);
Var
	I: Integer;
    Character: String;
Begin
    If Length (FontDirectory) > 0 Then
		If FontDirectory [Length (FontDirectory)] <> '\' Then FontDirectory := FontDirectory + '\';
    I := 1;
    Repeat
		Character := Copy (TextString, I, 1);
        I := I + 1;
        If (Character [1] > #160) And (Copy (TextString, I, 1) > #160) And (FontType = ChineseFont) Then
        Begin
        	Character := Character + Copy (TextString, I, 1);
            I := I + 1;
            OutChineseCharacter (Character);
            CurrentX := CurrentX + FontWidth
        End
        Else
        Begin
          	OutEnglishCharacter (Character);
          	CurrentX := CurrentX + FontWidth Div 2
        End
	Until I > Length (TextString);
End;

Procedure TChinese.WriteChineseXY (X, Y: Integer; TextString: String);
Begin
	CurrentX := X;
    CurrentY := Y;
    WriteChinese (TextString)
End;

Procedure TChinese.OutChineseCharacter (TextString: String);
Var
	I, J: Integer;
	X, Y: Integer;
	Width, Height: Integer;
    FontFileName: String;
    FontFile: File Of ChineseFontDataArray;
    FontData: ChineseFontDataArray;
Begin
    FontFileName := FontDirectory + 'HZK16';
    Assign (FontFile, FontFileName);
    Reset (FontFile);
    Seek (FontFile, (Ord (TextString [1]) - 161) * 94 + Ord (TextString [2]) - 161);
    Read (FontFile, FontData);
    Close (FontFile);
	If (FontWidth = NormalSize) And (FontWidth = NormalSize) Then
    Begin
    	For I := 0 To 15 Do
        Begin
        	FontData [I] := (FontData [I] And $FF) * $100 + (FontData [I] And $FF00) Div $100;
            For J := 0 To 15 Do
            	If ((FontData [I] Shr J) And 1 = 1) Then
                Begin
                	If ForeColor >= 0 Then PutPixel (CurrentX + 15 - J, CurrentY + I, ForeColor)
                End
                Else
                Begin
                	If BackColor >= 0 Then PutPixel (CurrentX + 15 - J, CurrentY + I, BackColor)
                End
        End
    End
	Else
    Begin
      	Width := FontWidth Div NormalSize;
        Height := FontHeight Div NormalSize;
    	For I := 0 To 15 Do
    	Begin
           	FontData [I] := (FontData [I] And $FF) * $100 + (FontData [I] And $FF00) Div $100;
			Y := CurrentY + I * FontHeight Div NormalSize;
            For J := 0 To 15 Do
            Begin
            	X := CurrentX + (15 - J) * FontWidth Div NormalSize;
            	If ((FontData [I] Shr J) And 1 = 1) Then
                Begin
                	If ForeColor >= 0 Then
                    Begin
                        SetFillStyle (SolidFill, ForeColor);
						Bar (X, Y, X + Width, Y + Height)
                    End
                End
                Else
            	Begin
                	If BackColor >= 0 Then
                    Begin
                    	SetFillStyle (SolidFill, BackColor);
            			Bar (X, Y, X + Width, Y + Height)
                    End
                End
            End
        End
    End
End;

Procedure TChinese.OutEnglishCharacter (TextString: String);
Type
	FontDataArray = Array [0..15] Of Byte;
Var
	I, J: Integer;
	X, Y: Integer;
	Width, Height: Integer;
    FontFileName: String;
    FontFile: File Of EnglishFontDataArray;
    FontData: EnglishFontDataArray;
Begin
    FontFileName := FontDirectory + 'ASC16';
    Assign (FontFile, FontFileName);
    Reset (FontFile);
    Seek (FontFile, Ord (TextString [1]));
    Read (FontFile, FontData);
    Close (FontFile);
	If (FontWidth = NormalSize) And (FontWidth = NormalSize) Then
	Begin
    	For I := 0 To 15 Do
            For J := 0 To 7 Do
            	If ((FontData [I] Shr J) And 1 = 1) Then
                Begin
                	If ForeColor >= 0 Then PutPixel (CurrentX + 7 - J, CurrentY + I, ForeColor)
                End
                Else
                Begin
                	If BackColor >= 0 Then PutPixel (CurrentX + 7 - J, CurrentY + I, BackColor)
                End
    End
    Else
    Begin
      	Width := FontWidth Div NormalSize;
        Height := FontHeight Div NormalSize;
    	For I := 0 To 15 Do
    	Begin
			Y := CurrentY + I * FontHeight Div NormalSize;
            For J := 0 To 7 Do
            Begin
            	X := CurrentX + (7 - J) * FontWidth Div NormalSize;
            	If ((FontData [I] Shr J) And 1 = 1) Then
                Begin
                	If ForeColor >= 0 Then
                    Begin
                    	SetFillStyle (SolidFill, ForeColor);
						Bar (X, Y, X + Width, Y + Height)
                    End
                End
                Else
                Begin
                	If BackColor >= 0 Then
                	Begin
                    	SetFillStyle (SolidFill, BackColor);
            			Bar (X, Y, X + Width, Y + Height)
                    End
                End
            End
        End
    End
End;

End.