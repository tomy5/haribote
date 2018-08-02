; naskfunc
; TAB=4

section .text
	GLOBAL io_hlt, io_cli, io_sti, io_stihtl
	GLOBAL io_in8, io_in16, io_in32
	GLOBAL io_out8, io_out16, io_out32
	GLOBAL io_load_eflags, io_store_eflags
	GLOBAL load_gdtr, load_idtr
	;GLOBAL write_mem8

io_hlt: ; void io_hlt(void);
	HLT
	RET

io_cli:	; void io_cli(void);
	CLI
	RET

io_sti: ; void io_sti(void);
	STI
	RET

io_stihtl: ; void io_stihtl(void);
	STI
	HLT
	RET

io_in8:	; int io_in8(int port);
	MOV EDX, [ESP+4] ; port
	MOV EAX, 0
	IN AL, DX
	RET

io_in16: ; int io_in16(int port);
	MOV EDX, [ESP+4] ; port
	MOV EAX, 0
	IN AX, DX
	RET

io_in32: ; int io_in32(int port);
	MOV EDX, [ESP+4] ; port
	MOV EAX, 0
	IN EAX, DX
	RET

io_out8: ; void io_out8(int port, int data);
	MOV EDX, [ESP+4] ; port
	MOV EAX, [ESP+8] ; data
	OUT DX, AL
	RET

io_out16: ; void io_out16(int port, int data);
	MOV EDX, [ESP+4] ; port
	MOV EAX, [ESP+8] ; data
	OUT DX, AX
	RET

io_out32: ; void io_out32(int port, int data);
	MOV EDX, [ESP+4] ; port
	MOV EAX, [ESP+8] ; data
	OUT DX, EAX
	RET

io_load_eflags: ; int io_load_eflags(void)
	PUSHFD ; PUSH EFLAGS という意味
	POP EAX
	RET

io_store_eflags: ; void io_store_eflags(int eflags);
	MOV EAX, [ESP+4]
	PUSH EAX
	POPFD ; POP EFLAGS という意味
	RET

load_gdtr:		; void load_gdtr(int limit, int addr);
	MOV		AX,[ESP+4]		; limit
	MOV		[ESP+6],AX
	LGDT	[ESP+6]
	RET

load_idtr:		; void load_idtr(int limit, int addr);
	MOV		AX,[ESP+4]		; limit
	MOV		[ESP+6],AX
	LIDT	[ESP+6]
	RET

; これは使わない関数
;write_mem8: ; void write_mem8(int addr, int data);
	;MOV		ECX,[ESP+4]		; [ESP+4]にaddrが入っているのでそれをECXに読み込む
	;MOV		AL,[ESP+8]		; [ESP+8]にdataが入っているのでそれをALに読み込む
	;MOV		[ECX],AL
	;RET
