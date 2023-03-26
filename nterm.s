	include	fefunc.h
	.DATA
_STRCRLF:
	.DC.B	13
	.DC.B	10
	.DC.B	0
	.EVEN
	.DATA
_STRTAB:
	.DC.B	9
	.DC.B	0
	.BSS
_data:
	.DS.B	64512
	.BSS
_ai:
	.DS.B	4
	.BSS
_bi:
	.DS.B	4
	.BSS
_ci:
	.DS.B	4
	.BSS
_bd:
	.DS.B	4
	.BSS
_dload_flg:
	.DS.B	4
	.BSS
_fc:
	.DS.B	4
	.BSS
_loop:
	.DS.B	4
	.BSS
_rs_in:
	.DS.B	2
	.BSS
_rs_out:
	.DS.B	2
	.BSS
_up:
	.DS.B	2
	.BSS
_in_data:
	.DS.B	2
	.BSS
_fname:
	.DS.B	24
	.BSS
_out_data:
	.DS.B	2
	.BSS
_up_filename:
	.DS.B	24
*
*
*_main
*
*
	.XREF	__main
	.XDEF	_main
	.TEXT
_main:
~~_main:
	BRA	L1
L2:
	JSR	_b_init
	MOVE.L	#96,-(SP)
	JSR	_width
	ADDQ.L	#4,SP
	MOVE.L	#1,-(SP)
	MOVE.L	#3,-(SP)
	JSR	_LEDMOD
	ADDQ.L	#8,SP
	MOVE.L	#L4,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	CLR.L	-(SP)
	MOVE.L	#30,-(SP)
	MOVE.L	#1,-(SP)
	JSR	_console
	LEA	12(SP),SP
	MOVE.L	#L6,-(SP)
	MOVE.L	#L5,-(SP)
	JSR	_b_fopen
	ADDQ.L	#8,SP
	MOVE.L	D0,_ai
	MOVE.L	#1,_dload_flg
L7:
	MOVE.L	#1,D0
	BEQ	L8
	JSR	_in
	JSR	_out
	BRA	L7
L8:
	CLR.L	-(SP)
	JSR	_b_exit
	ADDQ.L	#4,SP
L3:
	UNLK	A6
	RTS
L1:
	LINK	A6,#0
	BRA	L2

*
*
*_mode
*
*
	.GLOBL	_mode
	.TEXT
_mode:
~~_mode:
	BRA	L9
L10:
	MOVE.L	A6,D0
	ADD.L	#-256,D0
	MOVE.L	D0,-(SP)
	JSR	_b_inkeyS
	ADDQ.L	#4,SP
	MOVE.L	D0,-(SP)
	MOVE.L	#_out_data,-(SP)
	MOVE.L	#2,-(SP)
	JSR	_b_strncpy
	LEA	12(SP),SP
	MOVE.L	#_out_data,-(SP)
	JSR	_asc
	ADDQ.L	#4,SP
	MOVE.B	D0,_rs_out
	MOVE.B	_rs_out,D0
	ANDI.L	#$FF,D0
	ADD.L	#1+__ctype,D0
	MOVE.L	D0,A0
	MOVE.B	(A0),D0
	EXT.W	D0
	EXT.L	D0
	AND.L	#2,D0
	BEQ	L10000
	MOVE.B	_rs_out,D0
	ANDI.L	#$FF,D0
	MOVE.L	#32,D1
	SUB.L	D1,D0
	BRA	L10001
L10000:
	MOVE.B	_rs_out,D0
L10001:
	MOVE.B	D0,_rs_out
	MOVE.B	_rs_out,D0
	ANDI.L	#$FF,D0
	BRA	L13
L14:
	JSR	_download_off
	BRA	L12
L15:
	JSR	_down_load
	BRA	L12
L16:
	JSR	_term_mode
	BRA	L12
L17:
	JSR	_term_end
	BRA	L12
L18:
	JSR	_up_load
	BRA	L12
L19:
	JSR	_x_down
	BRA	L12
L13:
CMPI.L	#65,D0
	BEQ	L14
CMPI.L	#68,D0
	BEQ	L15
CMPI.L	#77,D0
	BEQ	L16
CMPI.L	#81,D0
	BEQ	L17
CMPI.L	#85,D0
	BEQ	L18
CMPI.L	#88,D0
	BEQ	L19
	BRA	L12
L12:
L11:
	UNLK	A6
	RTS
L9:
	LINK	A6,#-256
	BRA	L10

*
*
*_in
*
*
	.GLOBL	_in
	.TEXT
_in:
~~_in:
	BRA	L20
L21:
	JSR	_LOF232C
	MOVE.L	D0,_bd
	MOVE.L	_bd,D0
	BNE	L23
	BRA	L22
L23:
	MOVE.L	_ai,-(SP)
	JSR	_b_fgetc
	ADDQ.L	#4,SP
	MOVE.B	D0,_rs_in
	MOVE.B	_rs_in,D0
	ANDI.L	#$ff,D0
	MOVE.L	D0,-(SP)
	MOVE.L	A6,D0
	ADD.L	#-256,D0
	MOVE.L	D0,-(SP)
	JSR	_b_chrS
	ADDQ.L	#8,SP
	MOVE.L	D0,-(SP)
	MOVE.L	#_in_data,-(SP)
	MOVE.L	#2,-(SP)
	JSR	_b_strncpy
	LEA	12(SP),SP
	MOVE.L	#_in_data,-(SP)
	JSR	_b_sprint
	ADDQ.L	#4,SP
	MOVE.L	#8,-(SP)
	MOVE.L	A6,D0
	ADD.L	#-256,D0
	MOVE.L	D0,-(SP)
	JSR	_b_chrS
	ADDQ.L	#8,SP
	MOVE.L	D0,-(SP)
	MOVE.L	#15677,-(SP)
	MOVE.L	#_in_data,-(SP)
	JSR	_b_strcmp
	LEA	12(SP),SP
	TST.L	D0
	BEQ	L24
	MOVE.L	#L25,-(SP)
	JSR	_b_sprint
	ADDQ.L	#4,SP
	MOVE.L	#29,-(SP)
	MOVE.L	A6,D0
	ADD.L	#-256,D0
	MOVE.L	D0,-(SP)
	JSR	_b_chrS
	ADDQ.L	#8,SP
	MOVE.L	D0,-(SP)
	JSR	_b_sprint
	ADDQ.L	#4,SP
	MOVE.L	#29,-(SP)
	MOVE.L	A6,D0
	ADD.L	#-256,D0
	MOVE.L	D0,-(SP)
	JSR	_b_chrS
	ADDQ.L	#8,SP
	MOVE.L	D0,-(SP)
	JSR	_b_sprint
	ADDQ.L	#4,SP
L24:
	MOVE.L	_dload_flg,D0
	BNE	L26
	MOVE.L	_bi,-(SP)
	MOVE.B	_rs_in,D0
	ANDI.L	#$ff,D0
	MOVE.L	D0,-(SP)
	JSR	_b_fputc
	ADDQ.L	#8,SP
L26:
L22:
	UNLK	A6
	RTS
L20:
	LINK	A6,#-256
	BRA	L21

*
*
*_out
*
*
	.GLOBL	_out
	.TEXT
_out:
~~_out:
	BRA	L27
L28:
	MOVE.L	A6,D0
	ADD.L	#-256,D0
	MOVE.L	D0,-(SP)
	JSR	_b_inkey0
	ADDQ.L	#4,SP
	MOVE.L	D0,-(SP)
	MOVE.L	#_out_data,-(SP)
	MOVE.L	#2,-(SP)
	JSR	_b_strncpy
	LEA	12(SP),SP
	MOVE.L	#L30,-(SP)
	MOVE.L	#15677,-(SP)
	MOVE.L	#_out_data,-(SP)
	JSR	_b_strcmp
	LEA	12(SP),SP
	TST.L	D0
	BEQ	L31
	BRA	L29
L31:
	MOVE.L	#27,-(SP)
	MOVE.L	A6,D0
	ADD.L	#-256,D0
	MOVE.L	D0,-(SP)
	JSR	_b_chrS
	ADDQ.L	#8,SP
	MOVE.L	D0,-(SP)
	MOVE.L	#15677,-(SP)
	MOVE.L	#_out_data,-(SP)
	JSR	_b_strcmp
	LEA	12(SP),SP
	TST.L	D0
	BEQ	L32
	JSR	_mode
	BRA	L29
L32:
	MOVE.L	#22,-(SP)
	MOVE.L	A6,D0
	ADD.L	#-256,D0
	MOVE.L	D0,-(SP)
	JSR	_b_chrS
	ADDQ.L	#8,SP
	MOVE.L	D0,-(SP)
	MOVE.L	#15677,-(SP)
	MOVE.L	#_out_data,-(SP)
	JSR	_b_strcmp
	LEA	12(SP),SP
	TST.L	D0
	BEQ	L33
	JSR	_help
	BRA	L29
L33:
	MOVE.L	#_out_data,-(SP)
	JSR	_asc
	ADDQ.L	#4,SP
	MOVE.B	D0,_rs_out
	MOVE.L	_ai,-(SP)
	MOVE.B	_rs_out,D0
	ANDI.L	#$ff,D0
	MOVE.L	D0,-(SP)
	JSR	_b_fputc
	ADDQ.L	#8,SP
L29:
	UNLK	A6
	RTS
L27:
	LINK	A6,#-256
	BRA	L28

*
*
*_term_end
*
*
	.GLOBL	_term_end
	.TEXT
_term_end:
~~_term_end:
	BRA	L34
L35:
	MOVE.L	#L37,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	A6,D0
	ADD.L	#-294,D0
	MOVE.L	D0,-(SP)
	JSR	_b_inkeyS
	ADDQ.L	#4,SP
	MOVE.L	D0,-(SP)
	MOVE.L	A6,D0
	ADD.L	#-34,D0
	MOVE.L	D0,-(SP)
	MOVE.L	#33,-(SP)
	JSR	_b_strncpy
	LEA	12(SP),SP
	MOVE.L	A6,D0
	ADD.L	#-34,D0
	CMP.L	#L38,D0
	BNE	L40
	MOVE.L	A6,D0
	ADD.L	#-34,D0
	CMP.L	#L39,D0
	BNE	L40
	MOVE.L	#L41,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	JSR	_b_fcloseall
	CLR.L	-(SP)
	JSR	_b_exit
	ADDQ.L	#4,SP
L40:
	MOVE.L	#L42,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
L36:
	UNLK	A6
	RTS
L34:
	LINK	A6,#-294
	BRA	L35

*
*
*_up_load
*
*
	.GLOBL	_up_load
	.TEXT
_up_load:
~~_up_load:
	BRA	L43
L44:
	MOVE.L	_dload_flg,D0
	BNE	L46
	MOVE.L	_bi,-(SP)
	JSR	_b_fclose
	ADDQ.L	#4,SP
	MOVE.L	#1,_dload_flg
L46:
	MOVE.L	#1,-(SP)
	JSR	_color
	ADDQ.L	#4,SP
	MOVE.L	#-1,-(SP)
	MOVE.L	#_up_filename,-(SP)
	MOVE.L	#23,-(SP)
	MOVE.L	#L47,-(SP)
	JSR	_b_input
	LEA	16(SP),SP
	MOVE.L	#3,-(SP)
	JSR	_color
	ADDQ.L	#4,SP
	MOVE.L	#L48,-(SP)
	MOVE.L	#_up_filename,-(SP)
	JSR	_b_fopen
	ADDQ.L	#8,SP
	MOVE.L	D0,_ci
L51:
	MOVE.L	_ci,-(SP)
	JSR	_b_fgetc
	ADDQ.L	#4,SP
	MOVE.B	D0,_up
	MOVE.B	_up,D0
	ANDI.L	#$FF,D0
	CMP.L	#10,D0
	BNE	L10003
	CLR.L	D0
	BRA	L10004
L10003:
	MOVE.L	#1,D0
L10004:
	MOVE.B	_up,D1
	ANDI.L	#$FF,D1
	CMP.L	#26,D1
	BNE	L10005
	CLR.L	D1
	BRA	L10006
L10005:
	MOVE.L	#1,D1
L10006:
	AND.L	D1,D0
	BEQ	L52
	MOVE.L	_ai,-(SP)
	MOVE.B	_up,D0
	ANDI.L	#$ff,D0
	MOVE.L	D0,-(SP)
	JSR	_b_fputc
	ADDQ.L	#8,SP
	MOVE.L	D0,_fc
L52:
	JSR	_in
L49:
	MOVE.B	_up,D0
	ANDI.L	#$FF,D0
	CMP.L	#26,D0
	BNE	L51
L50:
	MOVE.L	_ci,-(SP)
	JSR	_b_fclose
	ADDQ.L	#4,SP
L45:
	UNLK	A6
	RTS
L43:
	LINK	A6,#0
	BRA	L44

*
*
*_down_load
*
*
	.GLOBL	_down_load
	.TEXT
_down_load:
~~_down_load:
	BRA	L53
L54:
	MOVE.L	_dload_flg,D0
	BNE	L56
	JSR	_beep
	MOVE.L	#L57,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	BRA	L55
L56:
	MOVE.L	#2,-(SP)
	JSR	_color
	ADDQ.L	#4,SP
	MOVE.L	#-1,-(SP)
	MOVE.L	#_fname,-(SP)
	MOVE.L	#23,-(SP)
	MOVE.L	#L58,-(SP)
	JSR	_b_input
	LEA	16(SP),SP
	MOVE.L	#L59,-(SP)
	MOVE.L	#_fname,-(SP)
	JSR	_b_fopen
	ADDQ.L	#8,SP
	MOVE.L	D0,_bi
	CLR.L	_dload_flg
	MOVE.L	#10,-(SP)
	JSR	_color
	ADDQ.L	#4,SP
	MOVE.L	#L60,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#_STRCRLF,-(SP)
	JSR	_b_sprint
	ADDQ.L	#4,SP
	MOVE.L	#3,-(SP)
	JSR	_color
	ADDQ.L	#4,SP
L55:
	UNLK	A6
	RTS
L53:
	LINK	A6,#0
	BRA	L54

*
*
*_download_off
*
*
	.GLOBL	_download_off
	.TEXT
_download_off:
~~_download_off:
	BRA	L61
L62:
	MOVE.L	_dload_flg,D0
	BNE	L64
	MOVE.L	_bi,-(SP)
	JSR	_b_fclose
	ADDQ.L	#4,SP
	BRA	L65
L64:
	JSR	_beep
	MOVE.L	#L66,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	BRA	L63
L65:
	MOVE.L	#10,-(SP)
	JSR	_color
	ADDQ.L	#4,SP
	MOVE.L	#L67,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#3,-(SP)
	JSR	_color
	ADDQ.L	#4,SP
	MOVE.L	#1,_dload_flg
L63:
	UNLK	A6
	RTS
L61:
	LINK	A6,#0
	BRA	L62

*
*
*_x_down
*
*
	.GLOBL	_x_down
	.TEXT
_x_down:
~~_x_down:
	BRA	L68
L69:
	MOVE.L	#1,-12(A6)
	CLR.L	-20(A6)
	MOVE.L	#1,D0
	MOVE.B	D0,-36(A6)
	MOVE.L	#21,D0
	MOVE.B	D0,-37(A6)
	MOVE.L	#4,D0
	MOVE.B	D0,-38(A6)
	MOVE.L	#6,D0
	MOVE.B	D0,-39(A6)
	MOVE.L	_ai,-(SP)
	JSR	_b_fclose
	ADDQ.L	#4,SP
	MOVE.L	D0,_fc
	MOVE.L	#-1,-(SP)
	JSR	_SET232C
	ADDQ.L	#4,SP
	MOVE.L	D0,-24(A6)
	MOVE.L	-24(A6),D0
	AND.L	#65023,D0
	MOVE.L	D0,-28(A6)
	MOVE.L	-28(A6),-(SP)
	JSR	_SET232C
	ADDQ.L	#4,SP
	MOVE.L	#L72,-(SP)
	MOVE.L	#L71,-(SP)
	JSR	_b_fopen
	ADDQ.L	#8,SP
	MOVE.L	D0,_ai
	MOVE.L	_dload_flg,D0
	BNE	L73
	MOVE.L	_bi,-(SP)
	JSR	_b_fclose
	ADDQ.L	#4,SP
	MOVE.L	#1,_dload_flg
L73:
L74:
	JSR	_LOF232C
	TST.L	D0
	BLE	L75
	MOVE.L	_ai,-(SP)
	JSR	_b_fgetc
	ADDQ.L	#4,SP
	MOVE.B	D0,_rs_in
	BRA	L74
L75:
	MOVE.L	#7,-(SP)
	JSR	_color
	ADDQ.L	#4,SP
	MOVE.L	#-1,-(SP)
	MOVE.L	A6,D0
	ADD.L	#-64,D0
	MOVE.L	D0,-(SP)
	MOVE.L	#23,-(SP)
	MOVE.L	#L76,-(SP)
	JSR	_b_input
	LEA	16(SP),SP
	MOVE.L	#3,-(SP)
	JSR	_color
	ADDQ.L	#4,SP
	MOVE.B	-37(A6),-40(A6)
	MOVE.L	_ai,-(SP)
	MOVE.B	-40(A6),D0
	ANDI.L	#$ff,D0
	MOVE.L	D0,-(SP)
	JSR	_b_fputc
	ADDQ.L	#8,SP
	MOVE.L	D0,_fc
L77:
	MOVE.L	#1,D0
	BEQ	L78
	CLR.L	-16(A6)
	CLR.L	-8(A6)
L79:
	JSR	_LOF232C
	TST.L	D0
	BNE	L80
	MOVE.L	-8(A6),D0
	ADDQ.L	#1,D0
	MOVE.L	D0,-8(A6)
	JSR	_LOF232C
	TST.L	D0
	BEQ	L10007
	CLR.L	D0
	BRA	L10008
L10007:
	MOVE.L	#1,D0
L10008:
	MOVE.L	-8(A6),D1
	CMP.L	#500000,D1
	BGE	L10009
	CLR.L	D1
	BRA	L10010
L10009:
	MOVE.L	#1,D1
L10010:
	AND.L	D1,D0
	BEQ	L81
	CLR.L	-8(A6)
	MOVE.L	_ai,-(SP)
	MOVE.B	-40(A6),D0
	ANDI.L	#$ff,D0
	MOVE.L	D0,-(SP)
	JSR	_b_fputc
	ADDQ.L	#8,SP
	MOVE.L	D0,_fc
L81:
	BRA	L79
L80:
	CLR.L	-4(A6)
	MOVE.L	_ai,-(SP)
	JSR	_b_fgetc
	ADDQ.L	#4,SP
	MOVE.B	D0,_rs_in
	MOVE.B	_rs_in,D0
	CMP.B	-38(A6),D0
	BNE	L82
	BRA	L78
L82:
	MOVE.B	_rs_in,D0
	CMP.B	-36(A6),D0
	BEQ	L83
	MOVE.L	#2,-16(A6)
L83:
	MOVE.L	_ai,-(SP)
	JSR	_b_fgetc
	ADDQ.L	#4,SP
	MOVE.B	D0,-33(A6)
	MOVE.L	_ai,-(SP)
	JSR	_b_fgetc
	ADDQ.L	#4,SP
	MOVE.B	D0,-34(A6)
	MOVE.B	-33(A6),D0
	ANDI.L	#$FF,D0
	MOVE.B	-34(A6),D1
	ANDI.L	#$FF,D1
	ADD.L	D1,D0
	CMP.L	#255,D0
	BNE	L10011
	CLR.L	D0
	BRA	L10012
L10011:
	MOVE.L	#1,D0
L10012:
	MOVE.L	-16(A6),D1
	BEQ	L10013
	CLR.L	D1
	BRA	L10014
L10013:
	MOVE.L	#1,D1
L10014:
	AND.L	D1,D0
	BEQ	L84
	MOVE.L	#2,-16(A6)
L84:
	MOVE.B	-33(A6),D0
	ANDI.L	#$FF,D0
	MOVE.L	-12(A6),D1
	ADDQ.L	#1,D1
	CMP.L	D1,D0
	BEQ	L10015
	CLR.L	D0
	BRA	L10016
L10015:
	MOVE.L	#1,D0
L10016:
	MOVE.L	-16(A6),D1
	BEQ	L10017
	CLR.L	D1
	BRA	L10018
L10017:
	MOVE.L	#1,D1
L10018:
	AND.L	D1,D0
	BEQ	L85
	MOVE.L	#1,-16(A6)
L85:
	CLR.L	_loop
L86:
	MOVE.L	_loop,D0
	CMP.L	#127,D0
	BGT	L87
	MOVE.L	_ai,-(SP)
	JSR	_b_fgetc
	ADDQ.L	#4,SP
	MOVE.L	-20(A6),D1
	ASL.L	#7,D1
	ADD.L	_loop,D1
	ADD.L	#_data,D1
	MOVE.L	D1,A1
	MOVE.B	D0,(A1)
	MOVE.L	-20(A6),D0
	ASL.L	#7,D0
	ADD.L	_loop,D0
	ADD.L	#_data,D0
	MOVE.L	D0,A0
	MOVE.B	(A0),D0
	ANDI.L	#$FF,D0
	ADD.L	-4(A6),D0
	MOVE.L	D0,-4(A6)
	MOVE.L	-4(A6),D0
	CMP.L	#255,D0
	BLE	L89
	MOVE.L	-4(A6),D0
	MOVE.L	#256,D1
	SUB.L	D1,D0
	MOVE.L	D0,-4(A6)
L89:
L88:
	ADDQ.L	#1,_loop
	BRA	L86
L87:
	MOVE.L	_ai,-(SP)
	JSR	_b_fgetc
	ADDQ.L	#4,SP
	MOVE.B	D0,-35(A6)
	MOVE.L	-16(A6),D0
	BEQ	L10019
	CLR.L	D0
	BRA	L10020
L10019:
	MOVE.L	#1,D0
L10020:
	MOVE.B	-35(A6),D1
	ANDI.L	#$FF,D1
	CMP.L	-4(A6),D1
	BNE	L10021
	CLR.L	D1
	BRA	L10022
L10021:
	MOVE.L	#1,D1
L10022:
	AND.L	D1,D0
	BEQ	L90
	MOVE.L	#2,-16(A6)
L90:
	MOVE.L	-16(A6),D0
	CMP.L	#2,D0
	BNE	L91
	MOVE.B	-37(A6),-40(A6)
	BRA	L92
L91:
	MOVE.B	-39(A6),-40(A6)
L92:
	MOVE.L	-12(A6),D0
	CMP.L	#255,D0
	BNE	L93
	CLR.L	-12(A6)
	BRA	L94
L93:
	MOVE.L	-12(A6),D0
	ADDQ.L	#1,D0
	MOVE.L	D0,-12(A6)
L94:
	MOVE.L	-16(A6),D0
	BEQ	L95
	MOVE.L	-12(A6),D0
	SUBQ.L	#1,D0
	MOVE.L	D0,-12(A6)
	BRA	L96
L95:
	MOVE.L	-20(A6),D0
	ADDQ.L	#1,D0
	MOVE.L	D0,-20(A6)
L96:
	MOVE.L	_ai,-(SP)
	MOVE.B	-40(A6),D0
	ANDI.L	#$ff,D0
	MOVE.L	D0,-(SP)
	JSR	_b_fputc
	ADDQ.L	#8,SP
	MOVE.L	D0,_fc
	MOVE.L	-20(A6),-(SP)
	JSR	_b_iprint
	ADDQ.L	#4,SP
	BRA	L77
L78:
	MOVE.L	_ai,-(SP)
	MOVE.B	-39(A6),D0
	ANDI.L	#$ff,D0
	MOVE.L	D0,-(SP)
	JSR	_b_fputc
	ADDQ.L	#8,SP
	MOVE.L	D0,_fc
	MOVE.L	#L97,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	-24(A6),-(SP)
	JSR	_SET232C
	ADDQ.L	#4,SP
	MOVE.L	#L98,-(SP)
	MOVE.L	A6,D0
	ADD.L	#-64,D0
	MOVE.L	D0,-(SP)
	JSR	_b_fopen
	ADDQ.L	#8,SP
	MOVE.L	D0,_ci
	CLR.L	-32(A6)
L99:
	MOVE.L	-20(A6),D0
	SUBQ.L	#1,D0
	CMP.L	-32(A6),D0
	BLT	L100
	CLR.L	_loop
L102:
	MOVE.L	_loop,D0
	CMP.L	#127,D0
	BGT	L103
	MOVE.L	_ci,-(SP)
	MOVE.L	-32(A6),D0
	ASL.L	#7,D0
	ADD.L	_loop,D0
	ADD.L	#_data,D0
	MOVE.L	D0,A0
	MOVE.B	(A0),D0
	ANDI.L	#$FF,D0
	MOVE.L	D0,-(SP)
	JSR	_b_fputc
	ADDQ.L	#8,SP
	MOVE.L	D0,_fc
L104:
	ADDQ.L	#1,_loop
	BRA	L102
L103:
L101:
	ADDQ.L	#1,-32(A6)
	BRA	L99
L100:
	MOVE.L	_ci,-(SP)
	JSR	_b_fclose
	ADDQ.L	#4,SP
L70:
	UNLK	A6
	RTS
L68:
	LINK	A6,#-64
	BRA	L69

*
*
*_help
*
*
	.GLOBL	_help
	.TEXT
_help:
~~_help:
	BRA	L105
L106:
	MOVE.L	#L108,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#L109,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#L110,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#L111,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#L112,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#L113,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#L114,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#L115,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#L116,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#L117,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#L118,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
L107:
	UNLK	A6
	RTS
L105:
	LINK	A6,#0
	BRA	L106

*
*
*_term_mode
*
*
	.GLOBL	_term_mode
	.TEXT
_term_mode:
~~_term_mode:
	BRA	L119
L120:
	MOVE.L	#L122,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#L123,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#L124,-(SP)
	JSR	_printf
	ADDQ.L	#4,SP
	MOVE.L	#_STRCRLF,-(SP)
	JSR	_b_sprint
	ADDQ.L	#4,SP
	MOVE.L	#-1,-(SP)
	MOVE.L	A6,D0
	ADD.L	#-4,D0
	MOVE.L	D0,-(SP)
	MOVE.L	#516,-(SP)
	MOVE.L	#L125,-(SP)
	JSR	_b_input
	LEA	16(SP),SP
	MOVE.L	-4(A6),D0
	BRA	L127
L128:
	MOVE.L	#19970,-(SP)
	JSR	_SET232C
	ADDQ.L	#4,SP
	BRA	L126
L129:
	MOVE.L	#19972,-(SP)
	JSR	_SET232C
	ADDQ.L	#4,SP
	BRA	L126
L127:
	SUB.L	#1,D0
	CMPI.L	#1,D0
	BHI	L126
	ASL.L	#2,D0
	LEA	L10024(PC),A0
	MOVE.L	(A0,D0.L),A0
	JMP	(A0)
L10024:
	.DC.L	L128
	.DC.L	L129
L126:
L121:
	UNLK	A6
	RTS
L119:
	LINK	A6,#-4
	BRA	L120

*
*
*STRING AREA
*
*
	.DATA
L4:
	.DC.B	$93,$ec,$8b,$9e,$81,$40,$8a,$c8,$88,$d5,$20,$82,$73,$82
	.DC.B	$64,$82,$71,$82,$6c,$20,$56,$65,$72,$30,$2e,$30,$31,$0a,$00
L5:
	.DC.B	$61,$75,$78,$00
L6:
	.DC.B	$72,$77,$00
L25:
	.DC.B	$20,$00
L30:
	.DC.B	$00
L37:
	.DC.B	$82,$6d,$82,$73,$82,$73,$20,$82,$f0,$8f,$49,$97,$b9,$82
	.DC.B	$b5,$82,$dc,$82,$b7,$81,$42,$82,$a2,$82,$a2,$82,$a9,$82,$c8
	.DC.B	$81,$48,$20,$28,$59,$2f,$4e,$29,$20,$3f,$20,$00
L38:
	.DC.B	$59,$00
L39:
	.DC.B	$79,$00
L41:
	.DC.B	$82,$cd,$82,$a2,$0a,$00
L42:
	.DC.B	$82,$a2,$82,$a2,$82,$a6,$0a,$00
L47:
	.DC.B	$66,$69,$6c,$65,$20,$6e,$61,$6d,$65,$20,$3a,$3f,$20,$00
L48:
	.DC.B	$72,$00
L57:
	.DC.B	$8a,$f9,$82,$c9,$83,$5f,$83,$45,$83,$93,$83,$8d,$81,$5b
	.DC.B	$83,$68,$92,$86,$82,$c5,$82,$b7,$81,$42,$0a,$00
L58:
	.DC.B	$66,$69,$6c,$65,$20,$6e,$61,$6d,$65,$20,$3f,$20,$00
L59:
	.DC.B	$63,$00
L60:
	.DC.B	$6c,$6f,$67,$20,$6f,$6e,$20,$21,$0a,$00
L66:
	.DC.B	$8a,$f9,$82,$c9,$83,$49,$83,$74,$82,$c5,$82,$b7,$81,$42
	.DC.B	$0a,$00
L67:
	.DC.B	$6c,$6f,$67,$20,$6f,$66,$66,$0a,$00
L71:
	.DC.B	$61,$75,$78,$00
L72:
	.DC.B	$72,$77,$00
L76:
	.DC.B	$58,$2d,$4d,$4f,$44,$45,$4d,$20,$44,$4f,$57,$4e,$20,$4c
	.DC.B	$4f,$41,$44,$20,$20,$46,$69,$6c,$65,$20,$4e,$61,$6d,$65,$20
	.DC.B	$3f,$20,$00
L97:
	.DC.B	$64,$61,$74,$61,$20,$77,$72,$69,$74,$69,$6e,$67,$2e,$2e
	.DC.B	$0a,$00
L98:
	.DC.B	$63,$00
L108:
	.DC.B	$0a,$00
L109:
	.DC.B	$2b,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d
	.DC.B	$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d
	.DC.B	$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2b,$0a,$00
L110:
	.DC.B	$20,$20,$83,$52,$83,$7d,$83,$93,$83,$68,$90,$e0,$96,$be
	.DC.B	$0a,$00
L111:
	.DC.B	$20,$20,$20,$20,$82,$64,$82,$72,$82,$62,$83,$4c,$81,$5b
	.DC.B	$82,$f0,$89,$9f,$82,$b5,$82,$bd,$8c,$e3,$0a,$00
L112:
	.DC.B	$20,$20,$20,$20,$20,$20,$20,$20,$82,$74,$81,$63,$83,$41
	.DC.B	$83,$62,$83,$76,$83,$8d,$81,$5b,$83,$68,$0a,$00
L113:
	.DC.B	$20,$20,$20,$20,$20,$20,$20,$20,$82,$63,$81,$63,$83,$5f
	.DC.B	$83,$45,$83,$93,$83,$8d,$81,$5b,$83,$68,$8a,$4a,$8e,$6e,$0a,$00
L114:
	.DC.B	$20,$20,$20,$20,$20,$20,$20,$20,$82,$60,$81,$63,$83,$5f
	.DC.B	$83,$45,$83,$93,$83,$8d,$81,$5b,$83,$68,$8f,$49,$97,$b9,$0a,$00
L115:
	.DC.B	$20,$20,$20,$20,$20,$20,$20,$20,$82,$77,$81,$63,$58,$2d
	.DC.B	$4d,$4f,$44,$45,$4d,$20,$66,$69,$6c,$65,$83,$5f,$83,$45,$83
	.DC.B	$93,$83,$8d,$81,$5b,$83,$68,$0a,$00
L116:
	.DC.B	$20,$20,$20,$20,$20,$20,$20,$20,$82,$70,$81,$63,$83,$76
	.DC.B	$83,$8d,$83,$4f,$83,$89,$83,$80,$8f,$49,$97,$b9,$0a,$00
L117:
	.DC.B	$20,$20,$20,$20,$20,$20,$20,$20,$82,$6c,$81,$63,$83,$7b
	.DC.B	$81,$5b,$83,$8c,$81,$5b,$83,$67,$90,$dd,$92,$e8,$0a,$00
L118:
	.DC.B	$2b,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d
	.DC.B	$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d
	.DC.B	$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2b,$0a,$00
L122:
	.DC.B	$83,$7b,$81,$5b,$83,$8c,$81,$5b,$83,$67,$82,$f0,$95,$cf
	.DC.B	$8d,$58,$82,$b5,$82,$dc,$82,$b7,$0a,$0a,$00
L123:
	.DC.B	$20,$20,$20,$20,$31,$2e,$2e,$2e,$33,$30,$30,$62,$70,$73
	.DC.B	$2e,$0a,$00
L124:
	.DC.B	$20,$20,$20,$20,$32,$2e,$2e,$31,$32,$30,$30,$62,$70,$73
	.DC.B	$2e,$0a,$00
L125:
	.DC.B	$20,$20,$82,$c7,$82,$ea,$82,$c9,$82,$b5,$82,$dc,$82,$b7
	.DC.B	$82,$a9,$3f,$20,$00
	.EVEN
	.END
