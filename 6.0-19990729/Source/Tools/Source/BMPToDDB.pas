Program BMPToDDB;

Uses
	Dos;

Var
	Width, Height: Word;

Procedure SetDefaultPalette;
	Function GetPaletteColor(Color: Integer): Integer;
	Begin
		If Color >= 8 Then GetPaletteColor := Color + 48 Else GetPaletteColor := Color;
		If Color = 6 Then GetPaletteColor := 20
	End;
Const
	DefaultPalette: Array[0..15, (Red, Green, Blue)] Of Integer =
	(($00, $00, $00), ($2A, $00, $00), ($00, $2A, $00), ($2A, $2A, $00),
	($00, $00, $2A), ($2A, $00, $2A), ($00, $2A, $2A), ($20, $20, $20),
	($30, $30, $30), ($3F, $15, $15), ($15, $3F, $15), ($3F, $3F, $15),
	($00, $00, $3F), ($3F, $00, $3F), ($00, $3F, $3F), ($3F, $3F, $3F));
Var
	I: Integer;
Begin
	For I := 0 To 15 Do
	Begin
		Port[$3C8] := GetPaletteColor(I);
		Port[$3C9] := DefaultPalette[I, Red];
		Port[$3C9] := DefaultPalette[I, Green];
		Port[$3C9] := DefaultPalette[I, Blue]
	End
End;

Procedure DisplayBitmap(BitmapFileName: String);
Const
	BI_RGB  = 0;
	BI_RLE8 = 1;
	BI_RLE4 = 2;
Type
	TBitmapFileHeader = Record
		bfType: Integer;
		bfSize: Longint;
		bfReserved1: Integer;
		bfReserved2: Integer;
		bfOffBits: Longint
	End;
	TBitmapInfoHeader = Record
		biSize: Longint;
		biWidth: Longint;
		biHeight: Longint;
		biPlanes: Integer;
		biBitCount: Integer;
		biCompression: Longint;
		biSizeImage: Longint;
		biXPelsPerMeter: Longint;
		biYPelsPerMeter: Longint;
		biClrUsed: Longint;
		biClrImportant: Longint
	End;
	TRGBQuad = record
		rgbBlue: Byte;
		rgbGreen: Byte;
		rgbRed: Byte;
		rgbReserved: Byte
	End;
	TBitmapInfo = Record
		bmiHeader: TBitmapInfoHeader;
		bmiColors: Array[0..15] Of TRGBQuad
	End;
Var
	I, J, K, T: Word;
	BitmapFileHeader: TBitmapFileHeader;
	BitmapInfo: TBitmapInfo;
	Buffer: Longint;
	BitmapFile: File;
	Color: Array[0..7] Of Byte;
	ColorBit: Array[0..3] Of Byte;
Begin
	Assign(BitmapFile, BitmapFileName);
	Reset(BitmapFile, 1);
	BlockRead(BitmapFile, BitmapFileHeader, SizeOf(BitmapFileHeader));
	BlockRead(BitmapFile, BitmapInfo, SizeOf(BitmapInfo));
	If BitmapFileHeader.bfType <> 19778 Then
	Begin
		Asm
			MOV AX, 0003H
			INT 10H
		End;
		Writeln('Invalid file format.');
		Halt
	End;
	If (BitmapInfo.bmiHeader.biWidth > 640) Or (BitmapInfo.bmiHeader.biWidth < 0) Then
	Begin
		Asm
			MOV AX, 0003H
			INT 10H
		End;
		Writeln('Width is too large.');
		Halt
	End;
	If (BitmapInfo.bmiHeader.biHeight > 480) Or (BitmapInfo.bmiHeader.biHeight < 0) Then
	Begin
		Asm
			MOV AX, 0003H
			INT 10H
		End;
		Writeln('Height is too large.');
		Halt
	End;
	If (BitmapInfo.bmiHeader.biBitCount <> 4) Then
	Begin
		Asm
			MOV AX, 0003H
			INT 10H
		End;
		Writeln('Must be 16 colors.');
		Halt
	End;
	If (BitmapInfo.bmiHeader.biCompression <> BI_RGB) Then
	Begin
		Asm
			MOV AX, 0003H
			INT 10H
		End;
		Writeln('Bitmap cannot be compressed.');
		Halt
	End;
	Width := BitmapInfo.bmiHeader.biWidth;
	Height := BitmapInfo.bmiHeader.biHeight;
	For J := BitmapInfo.bmiHeader.biHeight - 1 DownTo 0 Do
		For I := 0 To (BitmapInfo.bmiHeader.biWidth + 7) Shr 3 - 1 do
		Begin
			BlockRead(BitmapFile, Buffer, SizeOf(Buffer));
			Color[0] := Buffer And $000000F0 Shr 4;
			Color[1] := Buffer And $0000000F;
			Color[2] := Buffer And $0000F000 Shr 12;
			Color[3] := Buffer And $00000F00 Shr 8;
			Color[4] := Buffer And $00F00000 Shr 20;
			Color[5] := Buffer And $000F0000 Shr 16;
			Color[6] := Buffer And $F0000000 Shr 28;
			Color[7] := Buffer And $0F000000 Shr 24;
			If I = (BitmapInfo.bmiHeader.biWidth + 7) Shr 3 - 1 Then
				If BitmapInfo.bmiHeader.biWidth Mod 8 <> 0 Then
					For K := 7 DownTo BitmapInfo.bmiHeader.biWidth Mod 8 Do Color[K] := 0;
			FillChar(ColorBit, SizeOf(ColorBit), 0);
			For K := 0 To 7 Do ColorBit[0] := ColorBit[0] Shl 1 + Color[K] And $01;
			For K := 0 To 7 Do ColorBit[1] := ColorBit[1] Shl 1 + Color[K] And $02 Shr 1;
			For K := 0 To 7 Do ColorBit[2] := ColorBit[2] Shl 1 + Color[K] And $04 Shr 2;
			For K := 0 To 7 Do ColorBit[3] := ColorBit[3] Shl 1 + Color[K] And $08 Shr 3;
			T := J Shl 6 + J Shl 4 + I;
			Port[$3C4] := 2;
			Port[$3C5] := 1;
			Mem[$A000:T] := ColorBit[0];
			Port[$3C4] := 2;
			Port[$3C5] := 2;
			Mem[$A000:T] := ColorBit[1];
			Port[$3C4] := 2;
			Port[$3C5] := 4;
			Mem[$A000:T] := ColorBit[2];
			Port[$3C4] := 2;
			Port[$3C5] := 8;
			Mem[$A000:T] := ColorBit[3]
		End;
	Port[$3C5] := $0F;
	Close(BitmapFile)
End;

Procedure Init;
Var
	GraphDriver, GraphMode, ErrorCode: Integer;
Begin
	Writeln('BMP To DDB    Version 1.20    Wang Chun    February 10 1999');
	If ParamCount <> 2 Then
	Begin
		Writeln('Usage: BMPTODDB <BMP File> <DDB File>');
		Halt
	End;
	Asm
		MOV AX, 0012H
		INT 10H
	End;
	SetDefaultPalette
End;

Procedure Run;
Var
	I, J: Word;
	F: File;
Begin
	DisplayBitmap(ParamStr(1));
	Assign(F, ParamStr(2));
	Rewrite(F, 1);
	BlockWrite(F, Width, SizeOf(Width));
	BlockWrite(F, Height, SizeOf(Height));
	For I := 0 To Height - 1 Do
	Begin
		For J := 0 To 3 Do
		Begin
			Port[$3CE] := 4;
			Port[$3CF] := J;
			BlockWrite(F, Ptr($A000, I * 80)^, (Width + 7) Div 8)
		End
	End;
	Close(F);
End;

Procedure Done;
Begin
	Asm
		MOV AX, 0003H
		INT 10H
	End
End;

Begin
	Init;
	Run;
	Done
End.