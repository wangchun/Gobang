{$M 2048, 0, 0}
{$I-}
Program ResMaker;

Uses
	Strings, Memory;

Const
	ResBinary = 0;
	ResText = 1;
	ResImage = 2;
	ResPicture = 3;

Type
	TResName = Array[0..31] Of Char;
	TResType = Word;
	PResContent = ^TResContent;
	TResContent = Record
		Name: TResName;
		ResType: TResType;
		Offset: Longint;
		Size: Longint;
	End;

Var
	Flag: Boolean;
	I, J, ResCount, NumRead, NumWritten: Word;
	CurOffset: Longint;
	Ptr, FileNamePtr: Pointer;
	SourceFile: Text;
	Content: PResContent;
	S: String;
	ResFile, DestFile: File;
	FileName: ^String;
	Buf: Array[1..2048] Of Char;
Begin
	Writeln('Resource Maker   Version 1.00   Wang Chun   February 10 1999');
	If ParamCount <> 2 Then
	Begin
		Writeln('Usage: RESMAKER <Project File> <Resource File>');
		Halt
	End;
	Writeln;
	Writeln('Reading Project File...');
	Assign(SourceFile, ParamStr(1));
	Assign(DestFile, ParamStr(2));
	Reset(SourceFile);
	If IOResult <> 0 Then
	Begin
		Writeln('Fatal Error: Cannot Open Project File ' + ParamStr(1));
		Halt
	End;
	Readln(SourceFile, ResCount);
	Readln(SourceFile);
	Ptr := AllocMemory(SizeOf(TResContent) * ResCount);
	If Ptr = Nil Then
	Begin
		Writeln('Fatal Error: Out Of Memory');
		Halt
	End;
	FileNamePtr := AllocMemory(SizeOf(S) * ResCount);
	If FileNamePtr = Nil Then
	Begin
		Writeln('Fatal Error: Out Of Memory');
		FreeMemory(Ptr);
		Halt
	End;
	CurOffset := SizeOf(ResCount) + SizeOf(TResContent) * ResCount;
	For I := 1 To ResCount Do
	Begin
		Readln(SourceFile, S);
		FileName := GetMemoryPtr(FileNamePtr, SizeOf(S) * (I - 1));
		FileName^ := S;
		Assign(ResFile, FileName^);
		Reset(ResFile, 1);
		If IOResult <> 0 Then
		Begin
			FreeMemory(FileNamePtr);
			FreeMemory(Ptr);
			Writeln('Fatal Error: Cannot Open File ' + S);
			Halt
		End;
		Content := GetMemoryPtr(Ptr, SizeOf(TResContent) * (I - 1));
		Readln(SourceFile, S);
		If IOResult <> 0 Then
		Begin
			FreeMemory(FileNamePtr);
			FreeMemory(Ptr);
			Writeln('Fatal Error: Invalid File Format');
			Halt
		End;
		If Length(S) >= 32 Then
		Begin
			S := Copy(S, 1, 15);
			Writeln('Error: The Name ' + S + ' Is Too Long');
		End;
		FillChar(Content^.Name, SizeOf(Content^.Name), 0);
		StrPCopy(Content^.Name, S);
		Readln(SourceFile, S);
		If IOResult <> 0 Then
		Begin
			FreeMemory(FileNamePtr);
			FreeMemory(Ptr);
			Writeln('Fatal Error: Invalid File Format');
			Halt
		End;
		For J := 1 To Length(S) Do S[J] := UpCase(S[J]);
		Flag := True;
		If S = 'BINARY' Then
		Begin
			Content^.ResType := ResBinary;
			Flag := False
		End;
		If S = 'TEXT' Then
		Begin
			Content^.ResType := ResText;
			Flag := False
		End;
		If S = 'PICTURE' Then
		Begin
			Content^.ResType := ResPicture;
			Flag := False
		End;
		If S = 'IMAGE' Then
		Begin
			Content^.ResType := ResImage;
			Flag := False
		End;
		If Flag Then
		Begin
			Content^.ResType := ResBinary;
			Writeln('Error: The Type ' + S + ' Is Invalid')
		End;
		Content^.Offset := CurOffset;
		Content^.Size := FileSize(ResFile);
		CurOffset := CurOffset + Content^.Size;
		Close(ResFile);
		If IOResult <> 0 Then Writeln('Warning: Cannot Close File ' + FileName^);
		Readln(SourceFile);
		If IOResult <> 0 Then
		Begin
			FreeMemory(FileNamePtr);
			FreeMemory(Ptr);
			Writeln('Fatal Error: Invalid File Format');
			Halt
		End
	End;
	Close(SourceFile);
	If IOResult <> 0 Then Writeln('Warning: Cannot Close File ' + ParamStr(1));
	Writeln('Creating Resource File...');
	Rewrite(DestFile, 1);
	If IOResult <> 0 Then
	Begin
		FreeMemory(FileNamePtr);
		FreeMemory(Ptr);
		Writeln('Fatal Error: Cannot Create File ' + ParamStr(2));
		Halt
	End;
	BlockWrite(DestFile, ResCount, SizeOf(ResCount));
	If IOResult <> 0 Then
	Begin
		FreeMemory(FileNamePtr);
		FreeMemory(Ptr);
		Writeln('Error: Invalid Write File ' + ParamStr(2));
		Halt
	End;
	BlockWrite(DestFile, GetMemoryPtr(Ptr, 0)^, SizeOf(TResContent) * ResCount);
	If IOResult <> 0 Then
	Begin
		FreeMemory(FileNamePtr);
		FreeMemory(Ptr);
		Writeln('Error: Invalid Write File ' + ParamStr(2));
		Halt
	End;
	For I := 1 To ResCount Do
	Begin
		FileName := GetMemoryPtr(FileNamePtr, SizeOf(S) * (I - 1));
		Content := GetMemoryPtr(Ptr, SizeOf(TResContent) * (I - 1));
		Writeln('Adding File ' + FileName^ + '(' + StrPas(Content^.Name) + ')...');
		Assign(ResFile, FileName^);
		Reset(ResFile, 1);
		If IOResult <> 0 Then
		Begin
			FreeMemory(FileNamePtr);
			FreeMemory(Ptr);
			Writeln('Fatal Error: Cannot Open File ' + FileName^);
			Halt
		End;
		Repeat
			BlockRead(ResFile, Buf, SizeOf(Buf), NumRead);
			BlockWrite(DestFile, Buf, NumRead, NumWritten);
		Until (NumRead = 0) or (NumWritten <> NumRead);
		Close(ResFile);
		If IOResult <> 0 Then Writeln('Warning: Cannot Close File ' + FileName^)
	End;
	Close(DestFile);
	If IOResult <> 0 Then Writeln('Warning: Cannot Close File ' + ParamStr(2));
	FreeMemory(FileNamePtr);
	FreeMemory(Ptr);
	Writeln('Complete!')
End.