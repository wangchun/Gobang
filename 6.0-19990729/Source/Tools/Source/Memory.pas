{$G+}
{$I-}
Unit Memory;

Interface

Function GetMemoryPtr(P: Pointer; Start: Longint): Pointer;
Function AllocMemory(Size: Longint): Pointer;
Procedure FreeMemory(P: Pointer);

Var
	MemoryError: Procedure;

Implementation

Function GetMemoryPtr(P: Pointer; Start: Longint): Pointer; Assembler;
Asm
	MOV AX, Start.Word[0]
	MOV DX, AX
	AND AX, 000FH
	AND DX, 0FFF0H
	ADD DX, Start.Word[2]
	JC @@1
	ROR DX, 4
	ADD DX, P.Word[2]
	JNC @@2
@@1:
	XOR AX, AX
	XOR DX, DX
@@2:
End;

Function AllocMemory(Size: Longint): Pointer; Assembler;
Asm
	MOV AX, Size.Word[0]
	MOV DX, Size.Word[2]
	ADD AX, 0FH
	ADC DX, 00H
	CMP DX, 0AH
	JGE @@1
	AND AX, 0FFF0H
	ADD AX, DX
	ROR AX, 4
	MOV BX, AX
	MOV AH, 48H
	INT 21H
	JNC @@2
@@1:
	XOR AX, AX
	MOV DX, MemoryError.Word[0]
	OR DX, MemoryError.Word[2]
	JZ @@2
	CALL MemoryError
@@2:
	XOR DX, DX
	XCHG AX, DX
End;

Procedure FreeMemory(P: Pointer); Assembler;
Asm
	MOV AH, 49H
	MOV ES, P.Word[2]
	INT 21H
End;

Begin
	Asm
		MOV AX, 5803H
		MOV BX, 0001H
		INT 21H
		MOV AX, 5801H
		MOV BX, 0081H
		INT 21H
	End
End.