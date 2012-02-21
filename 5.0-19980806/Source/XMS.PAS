{**********************************************************}
{                                                          }
{        五子棋    版本 5.0    王纯    1998年8月6日        }
{                                                          }
{     Gobang   Version 5.0   Wang Chun   August 6 1998     }
{                                                          }
{**********************************************************}

{扩充内存模块}

{关闭运行时间输入输出检查}
{$I-}
Unit XMS;

Interface

Uses
	Dos, Graph;

Type
    XMSMove = Record
    	ByteCount: Longint;
        SourceHandle: Word;
        SourceOffset: Longint;
        DestinationHandle: Word;
		DestinationOffset: Longint;
	End;

Var
	XMSHandle: Array[1..256] Of Word;

{测试扩充内存是否安装}
Function TestXMS: Boolean;
{释放扩充内存块}
Function FreeXMS(Handle: Word): Boolean;
{释放所有已申请的扩充内存块}
Procedure FreeAllXMS;
{分配扩充内存块}
Function AllocXMS(Size: Word): Word;
{从扩充内存复制数据到常规内存}
Procedure ReadFromXMS(Handle: Word; BlockOffset: Longint; Var Buffer; ByteCount: Longint);
{将常规内存数据复制到扩充内存}
Procedure WriteToXMS(Handle: Word; BlockOffset: Longint; Var Buffer; ByteCount: Longint);

Implementation

Var
	XMSEntry: Pointer;

Function TestXMS: Boolean;
Var
	Regs: Registers;
Begin
	Regs.AX := $4300;
	Intr($2F, Regs);
    If Regs.AL = 0 Then TestXMS := False Else TestXMS := True
End;

Function FreeXMS(Handle: Word): Boolean;
Var
	I, IsSuccess: Word;
Begin
	Asm
    	MOV AH, 0AH
    	MOV DX, Handle
        CALL XMSEntry
		MOV IsSuccess, AX
	End;
    If IsSuccess = 0 Then
	Begin
		FreeXMS := False
	End
	Else
	Begin
        For I := 1 To 256 Do
        	If XMSHandle[I] = Handle Then
			Begin
                XMSHandle[I] := 0;
				Break
			End;
		FreeXMS := True
    End
End;

Procedure FreeAllXMS;
Var
	I: Word;
Begin
	For I := 1 To 256 Do If XMSHandle[I] <> 0 Then FreeXMS(XMSHandle[I])
End;

Function AllocXMS(Size: Word): Word;
Var
	I, Handle, IsSuccess: Word;
Begin
	Asm
        MOV AH, 09H
    	MOV DX, Size
        CALL XMSEntry
 		MOV Handle, DX
        MOV IsSuccess, AX
	End;
    If IsSuccess = 0 Then
	Begin
    	FreeAllXMS;
    	CloseGraph;
    	Writeln('Cannot Get Extended Memory!');
        Halt
	End;
	For I := 1 To 256 Do
    	If XMSHandle[I] = 0 Then
		Begin
			XMSHandle[I] := Handle;
			Break
    	End;
	AllocXMS := Handle
End;

Procedure ReadFromXMS(Handle: Word; BlockOffset: Longint; Var Buffer; ByteCount: Longint);
Var
	IsSuccess, BlockSeg, BlockOfs: Word;
	Block: XMSMove;
Begin
	Block.ByteCount := ByteCount;
    Block.SourceHandle := Handle;
    Block.SourceOffset := BlockOffset;
    Block.DestinationHandle := 0;
    Block.DestinationOffset := Seg(Buffer) * 65536 + Ofs(Buffer);
    BlockSeg := Seg(Block);
	BlockOfs := Ofs(Block) + (BlockSeg - DSeg) * 16;
	Asm
    	MOV AH, 0BH
        MOV SI, BlockOfs
        CALL XMSEntry
		MOV IsSuccess, AX
	End;
    If IsSuccess = 0 Then
	Begin
    	FreeAllXMS;
    	CloseGraph;
    	Writeln('Cannot Operate Extended Memory!');
        Halt
	End
End;

Procedure WriteToXMS(Handle: Word; BlockOffset: Longint; Var Buffer; ByteCount: Longint);
Var
	IsSuccess, BlockSeg, BlockOfs: Word;
	Block: XMSMove;
Begin
	Block.ByteCount := ByteCount;
    Block.SourceHandle := 0;
	Block.SourceOffset := Seg(Buffer) * 65536 + Ofs(Buffer);
    Block.DestinationHandle := Handle;
    Block.DestinationOffset := BlockOffset;
    BlockSeg := Seg(Block);
    BlockOfs := Ofs(Block) + (BlockSeg - DSeg) * 16;
	Asm
    	MOV AH, 0BH
        MOV SI, BlockOfs
        CALL XMSEntry
		MOV IsSuccess, AX
    End;
	If IsSuccess = 0 Then
	Begin
    	FreeAllXMS;
    	CloseGraph;
    	Writeln('Cannot Operate Extended Memory!');
        Halt
	End
End;

Var
	I: Word;
	Regs: Registers;
Begin
    For I := 1 To 256 Do XMSHandle[I] := 0;
	Regs.AX := $4310;
    Intr($2F, Regs);
    XMSEntry := Ptr(Regs.ES, Regs.BX)
End.