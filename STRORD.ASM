;STRORD

STACK1			SEGMENT PARA STACK
STACK_AREA		DW		100H DUP(?)
STACK_BOTTOM	EQU 	$-STACK_AREA
STACK1			ENDS

DATA1		SEGMENT PARA
STR_LEN		EQU		10
STR			DB		STR_LEN DUP(?),'14231006','$'
NEW_LINE	DB		0DH,0AH,'$'
DATA1		ENDS

CODE1		SEGMENT	PARA
			ASSUME	CS:CODE1, DS:DATA1, SS:STACK1

MAIN		PROC	FAR
			MOV		AX,		STACK1
			MOV		SS,		AX
			MOV		SP,		STACK_BOTTOM
			MOV		AX,		DATA1
			MOV		DS,		AX

			MOV		CX,		STR_LEN
			MOV		DI,		OFFSET STR
INPUT:		MOV		AH,		1
			INT		21H
			MOV		[DI],	AL
			INC		DI
			LOOP	INPUT
			
			MOV		DX,		OFFSET NEW_LINE
			MOV		AH,		9
			INT		21H
			MOV		DX,		OFFSET STR
			MOV		AH,		9
			INT		21H
			MOV		DX,		OFFSET NEW_LINE
			MOV		AH,		9
			INT		21H

			CALL	STRSORT

			MOV		AX,		4C00H
			INT		21H
MAIN		ENDP

STRSORT		PROC
			MOV		CX,		STR_LEN+8
			DEC		CX

LP:			MOV		BX,		1
			MOV		SI,		OFFSET STR
			PUSH	CX

SUBLP:		MOV		AL,		BYTE PTR [SI]
			CMP		AL,		BYTE PTR [SI+1]
			JBE		CONTINUE
			XCHG	AL,		BYTE PTR [SI+1]
			MOV		[SI],	AL
			MOV		BX,		0

CONTINUE:	INC		SI
			LOOP	SUBLP
			POP		CX
			DEC		CX
			CMP		BX,		1
			JZ		PRINT
			JMP		SHORT LP

PRINT:		MOV		DX,		OFFSET STR
			MOV		AH,		9
			INT		21H
			RET
STRSORT		ENDP

CODE1		ENDS
			END		MAIN