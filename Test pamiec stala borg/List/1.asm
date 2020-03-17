
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _guzik=R4
	.DEF _guzik0=R6
	.DEF _guzik1=R8
	.DEF _guzik2=R10
	.DEF _czas_kodu_panela=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2019-05-20
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega128
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;#include <io.h>
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
;#include <math.h>
;
;int guzik;
;int guzik0,guzik1,guzik2;
;long int sek80;
;int czas_kodu_panela;
;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 002A {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 002B // Place your code here
; 0000 002C //16,384 ms
; 0000 002D sek80++;
	LDI  R26,LOW(_sek80)
	LDI  R27,HIGH(_sek80)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 002E 
; 0000 002F 
; 0000 0030 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;
;void wartosc_parametru_panelu(int wartosc, int adres1, int adres2)
; 0000 0033 {
_wartosc_parametru_panelu:
; 0000 0034 putchar(90);  //5A
;	wartosc -> Y+4
;	adres1 -> Y+2
;	adres2 -> Y+0
	CALL SUBOPT_0x0
; 0000 0035 putchar(165); //A5
; 0000 0036 putchar(5);//05
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _putchar
; 0000 0037 putchar(130);  //82    /
	LDI  R30,LOW(130)
	CALL SUBOPT_0x1
; 0000 0038 putchar(adres1);    //00
; 0000 0039 putchar(adres2);   //40
	CALL SUBOPT_0x2
; 0000 003A putchar(0);    //00
; 0000 003B putchar(wartosc);   //np 5
	LDD  R30,Y+4
	RJMP _0x20A0003
; 0000 003C }
;
;
;/*
;void wartosc_parametru_panelu_stala_pamiec(int wartosc, int adres1, int adres2)
;{
;
;//5AA5 0C 80 56 5A 50 00000000 1000 0010 – Zapis (50) z VP 1000 do pamiêci FLASH 00000000
;
;putchar(90);  //5A
;putchar(165); //A5
;putchar(12);   //0C
;putchar(128);  //80    /
;putchar(86);    //56
;putchar(90);   //5A
;putchar(80);    //50
;putchar(0);   //00
;putchar(0);   //00
;putchar(0);   //00
;putchar(0);   //00
;putchar(16);   //10
;putchar(0);   //0
;putchar(0);   //0
;putchar(16);   //10
;}
;
;
;void odczyt_parametru_panelu_stala_pamiec(int wartosc, int adres1, int adres2)
;{
;
;//5AA5 0C 80 56 5A A0 00000000 1000 0010 – Odczyt (A0) z pamiêci FLASH 00000000 do VP 1000
;
;putchar(90);  //5A
;putchar(165); //A5
;putchar(12);   //0C
;putchar(128);  //80    /
;putchar(86);    //56
;putchar(90);   //5A
;putchar(160);    //A0
;putchar(0);   //00
;putchar(0);   //00
;putchar(0);   //00
;putchar(0);   //00
;putchar(16);   //10
;putchar(16);   //10
;putchar(0);   //0
;putchar(16);   //10
;}
;
;*/
;/*
;void wartosc_parametru_panelu_stala_pamiec(int skad_adres1, int skad_adres2, int dokad_adres1, int dokad_adres2)
;{
;
;//5AA5 0C 80 56 5A 50 00000000 1000 0010 – Zapis (50) z VP 1000 do pamiêci FLASH 00000000
;
;putchar(90);  //5A
;putchar(165); //A5
;putchar(12);   //0C
;putchar(128);  //80    /
;putchar(86);    //56
;putchar(90);   //5A
;putchar(80);    //50
;putchar(0);   //00
;putchar(0);   //00
;putchar(0);   //00
;putchar(0);   //00
;putchar(skad_adres1);   //10
;putchar(skad_adres2);   //0
;putchar(dokad_adres1);   //0
;putchar(dokad_adres2);   //10
;}
;
;void wartosc_parametru_panelu_stala_pamiec_1(int skad_adres1, int skad_adres2, int dokad_adres1, int dokad_adres2)
;{
;
;//5AA5 0C 80 56 5A 50 00000000 1000 0010 – Zapis (50) z VP 1000 do pamiêci FLASH 00000000
;
;putchar(90);  //5A
;putchar(165); //A5
;putchar(12);   //0C
;putchar(128);  //80    /
;putchar(86);    //56
;putchar(90);   //5A
;putchar(80);    //50
;putchar(0);   //00
;putchar(0);   //00
;putchar(0);   //00
;putchar(16);   //00
;putchar(skad_adres1);   //10
;putchar(skad_adres2);   //0
;putchar(dokad_adres1);   //0
;putchar(dokad_adres2);   //10
;}
;
;
;void odczyt_parametru_panelu_stala_pamiec(int dokad_adres1, int dokad_adres2,int skad_adres1, int skad_adres2,)
;{
;
;//5AA5 0C 80 56 5A A0 00000000 1010 0010 – Odczyt (A0) z pamiêci FLASH 00000000 do VP 1010
;
;putchar(90);  //5A
;putchar(165); //A5
;putchar(12);   //0C
;putchar(128);  //80    /
;putchar(86);    //56
;putchar(90);   //5A
;putchar(160);    //A0
;putchar(0);   //00
;putchar(0);   //00
;putchar(0);   //00
;putchar(0);   //00
;putchar(dokad_adres1);   //10
;putchar(dokad_adres2);   //10
;putchar(skad_adres1);   //0
;putchar(skad_adres2);   //10
;}
;
;void odczyt_parametru_panelu_stala_pamiec_1(int dokad_adres1, int dokad_adres2,int skad_adres1, int skad_adres2,)
;{
;
;//5AA5 0C 80 56 5A A0 00000000 1010 0010 – Odczyt (A0) z pamiêci FLASH 00000000 do VP 1010
;
;putchar(90);  //5A
;putchar(165); //A5
;putchar(12);   //0C
;putchar(128);  //80    /
;putchar(86);    //56
;putchar(90);   //5A
;putchar(160);    //A0
;putchar(0);   //00
;putchar(0);   //00
;putchar(0);   //00
;putchar(16);   //00
;putchar(dokad_adres1);   //10
;putchar(dokad_adres2);   //10
;putchar(skad_adres1);   //0
;putchar(skad_adres2);   //10
;}
;
;*/
;
;
;int odczytaj_parametr(int adres1, int adres2)
; 0000 00CC {
_odczytaj_parametr:
; 0000 00CD int z;
; 0000 00CE z = 0;
	ST   -Y,R17
	ST   -Y,R16
;	adres1 -> Y+4
;	adres2 -> Y+2
;	z -> R16,R17
	__GETWRN 16,17,0
; 0000 00CF putchar(90);
	CALL SUBOPT_0x0
; 0000 00D0 putchar(165);
; 0000 00D1 putchar(4);
	CALL SUBOPT_0x3
; 0000 00D2 putchar(131);
	LDI  R30,LOW(131)
	CALL SUBOPT_0x4
; 0000 00D3 putchar(adres1);
; 0000 00D4 putchar(adres2);
; 0000 00D5 putchar(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar
; 0000 00D6 getchar();
	CALL SUBOPT_0x5
; 0000 00D7 getchar();
; 0000 00D8 getchar();
; 0000 00D9 getchar();
	CALL SUBOPT_0x5
; 0000 00DA getchar();
; 0000 00DB getchar();
; 0000 00DC getchar();
	CALL SUBOPT_0x5
; 0000 00DD getchar();
; 0000 00DE z = getchar();
	MOV  R16,R30
	CLR  R17
; 0000 00DF 
; 0000 00E0 
; 0000 00E1 
; 0000 00E2 
; 0000 00E3 
; 0000 00E4 return z;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0002
; 0000 00E5 }
;
;
;
;void wartosc_parametru_panelu_stala_pamiec(int adres_nieulotny1,int skad_adres1, int skad_adres2)
; 0000 00EA {
_wartosc_parametru_panelu_stala_pamiec:
; 0000 00EB 
; 0000 00EC //5AA5 0C 80 56 5A 50 00000000 1000 0010 – Zapis (50) z VP 1000 do pamiêci FLASH 00000000
; 0000 00ED 
; 0000 00EE putchar(90);  //5A
;	adres_nieulotny1 -> Y+4
;	skad_adres1 -> Y+2
;	skad_adres2 -> Y+0
	CALL SUBOPT_0x0
; 0000 00EF putchar(165); //A5
; 0000 00F0 putchar(12);   //0C
	CALL SUBOPT_0x6
; 0000 00F1 putchar(128);  //80    /
; 0000 00F2 putchar(86);    //56
; 0000 00F3 putchar(90);   //5A
; 0000 00F4 putchar(80);    //50
	LDI  R30,LOW(80)
	RJMP _0x20A0001
; 0000 00F5 putchar(0);   //00
; 0000 00F6 putchar(0);   //00
; 0000 00F7 putchar(0);   //00
; 0000 00F8 putchar(adres_nieulotny1);   //00
; 0000 00F9 putchar(skad_adres1);   //10
; 0000 00FA putchar(skad_adres2);   //0
; 0000 00FB putchar(0);   //0
; 0000 00FC putchar(16);   //ile danych
; 0000 00FD }
;
;
;void obsluga_trybu_administratora()
; 0000 0101 {
_obsluga_trybu_administratora:
; 0000 0102 int guzik0,guzik1,guzik2,guzik3,guzik4,guzik5,guzik6,guzik7,guzik8;
; 0000 0103 int czas_kodu_panela;
; 0000 0104 
; 0000 0105 czas_kodu_panela = 0;
	SBIW R28,14
	CALL __SAVELOCR6
;	guzik0 -> R16,R17
;	guzik1 -> R18,R19
;	guzik2 -> R20,R21
;	guzik3 -> Y+18
;	guzik4 -> Y+16
;	guzik5 -> Y+14
;	guzik6 -> Y+12
;	guzik7 -> Y+10
;	guzik8 -> Y+8
;	czas_kodu_panela -> Y+6
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 0106 
; 0000 0107       guzik0 = odczytaj_parametr(80,144);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
; 0000 0108       guzik1 = odczytaj_parametr(80,145);
	CALL SUBOPT_0x9
; 0000 0109       guzik2 = odczytaj_parametr(80,146);
	CALL SUBOPT_0xA
; 0000 010A       guzik3 = odczytaj_parametr(80,147);
	CALL SUBOPT_0xB
; 0000 010B       guzik4 = odczytaj_parametr(80,148);
	CALL SUBOPT_0xC
; 0000 010C       guzik5 = odczytaj_parametr(80,149);
	CALL SUBOPT_0xD
; 0000 010D       guzik6 = odczytaj_parametr(80,150);
	CALL SUBOPT_0xE
; 0000 010E       guzik7 = odczytaj_parametr(80,151);
	CALL SUBOPT_0xF
; 0000 010F       guzik8 = odczytaj_parametr(80,152);
	CALL SUBOPT_0x10
; 0000 0110 
; 0000 0111 
; 0000 0112 
; 0000 0113 
; 0000 0114       while(guzik0 == 1 | guzik1 == 1 | guzik2 == 1 |
_0x3:
; 0000 0115             guzik3 == 1 | guzik4 == 1 | guzik5 == 1 |
; 0000 0116             guzik6 == 1 | guzik7 == 1 | guzik8 == 1)
	MOVW R26,R16
	CALL SUBOPT_0x11
	MOV  R0,R30
	MOVW R26,R18
	CALL SUBOPT_0x11
	OR   R0,R30
	MOVW R26,R20
	CALL SUBOPT_0x11
	OR   R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0x11
	OR   R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0x11
	OR   R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x11
	OR   R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x11
	OR   R0,R30
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x11
	OR   R0,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL SUBOPT_0x11
	OR   R30,R0
	BRNE PC+3
	JMP _0x5
; 0000 0117 
; 0000 0118       {
; 0000 0119 
; 0000 011A       if(czas_kodu_panela == 0)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BRNE _0x6
; 0000 011B       {
; 0000 011C       sek80 = 0;
	CALL SUBOPT_0x12
; 0000 011D       czas_kodu_panela = 1;
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 011E       }
; 0000 011F 
; 0000 0120       guzik0 = odczytaj_parametr(80,144);
_0x6:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
; 0000 0121       guzik1 = odczytaj_parametr(80,145);
	CALL SUBOPT_0x9
; 0000 0122       guzik2 = odczytaj_parametr(80,146);  /////////
	CALL SUBOPT_0xA
; 0000 0123       guzik3 = odczytaj_parametr(80,147);
	CALL SUBOPT_0xB
; 0000 0124       guzik4 = odczytaj_parametr(80,148);  /////////
	CALL SUBOPT_0xC
; 0000 0125       guzik5 = odczytaj_parametr(80,149);
	CALL SUBOPT_0xD
; 0000 0126       guzik6 = odczytaj_parametr(80,150);  ////////
	CALL SUBOPT_0xE
; 0000 0127       guzik7 = odczytaj_parametr(80,151);
	CALL SUBOPT_0xF
; 0000 0128       guzik8 = odczytaj_parametr(80,152);
	CALL SUBOPT_0x10
; 0000 0129 
; 0000 012A 
; 0000 012B       //kod to 7 5 3 (przekatna)
; 0000 012C 
; 0000 012D       if((guzik2 + guzik4 + guzik6) == 3 & (guzik2 == 1 & guzik4 == 1 & guzik6 == 1))
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADD  R30,R20
	ADC  R31,R21
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	MOV  R1,R30
	MOVW R26,R20
	CALL SUBOPT_0x11
	MOV  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0x11
	AND  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x11
	AND  R30,R0
	AND  R30,R1
	BREQ _0x7
; 0000 012E                    {
; 0000 012F 
; 0000 0130                    putchar(90);  //5A
	CALL SUBOPT_0x0
; 0000 0131                    putchar(165); //A5
; 0000 0132                    putchar(4);//04  //zmiana obrazu
	CALL SUBOPT_0x3
; 0000 0133                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 0134                    putchar(3);    //03
	CALL SUBOPT_0x14
; 0000 0135                    putchar(0);   //2
	CALL SUBOPT_0x15
; 0000 0136                    putchar(0);   //0
	CALL SUBOPT_0x15
; 0000 0137 
; 0000 0138                    delay_ms(500);
	CALL SUBOPT_0x16
; 0000 0139                    putchar(90);  //5A
; 0000 013A                    putchar(165); //A5
; 0000 013B                    putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 013C                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 013D                    putchar(2);    //02
	CALL SUBOPT_0x17
; 0000 013E                    putchar(16);   //10
; 0000 013F                    delay_ms(500);
; 0000 0140                    putchar(90);  //5A
; 0000 0141                    putchar(165); //A5
; 0000 0142                    putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 0143                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 0144                    putchar(2);    //02
	CALL SUBOPT_0x17
; 0000 0145                    putchar(16);   //10
; 0000 0146                    delay_ms(500);
; 0000 0147                    putchar(90);  //5A
; 0000 0148                    putchar(165); //A5
; 0000 0149                    putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 014A                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 014B                    putchar(2);    //02
	CALL SUBOPT_0x17
; 0000 014C                    putchar(16);   //10
; 0000 014D                    delay_ms(500);
; 0000 014E                    putchar(90);  //5A
; 0000 014F                    putchar(165); //A5
; 0000 0150                    putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 0151                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 0152                    putchar(2);    //02
	CALL SUBOPT_0x18
; 0000 0153                    putchar(16);   //10
; 0000 0154 
; 0000 0155                    wartosc_parametru_panelu(0, 80, 144);
	CALL SUBOPT_0x19
; 0000 0156                    wartosc_parametru_panelu(0, 80, 145);
	CALL SUBOPT_0x1A
; 0000 0157                    wartosc_parametru_panelu(0, 80, 146);
	CALL SUBOPT_0x1B
; 0000 0158                    wartosc_parametru_panelu(0, 80, 147);
	CALL SUBOPT_0x1C
; 0000 0159                    wartosc_parametru_panelu(0, 80, 148);
	CALL SUBOPT_0x1D
; 0000 015A                    wartosc_parametru_panelu(0, 80, 149);
	CALL SUBOPT_0x1E
; 0000 015B                    wartosc_parametru_panelu(0, 80, 150);
	CALL SUBOPT_0x1F
; 0000 015C                    wartosc_parametru_panelu(0, 80, 151);
	CALL SUBOPT_0x20
; 0000 015D                    wartosc_parametru_panelu(0, 80, 152);
	CALL SUBOPT_0x21
; 0000 015E 
; 0000 015F 
; 0000 0160                    guzik0 = 0;
; 0000 0161                    guzik1 = 0;
; 0000 0162                    guzik2 = 0;
; 0000 0163                    guzik3 = 0;
; 0000 0164                    guzik4 = 0;
; 0000 0165                    guzik5 = 0;
; 0000 0166                    guzik6 = 0;
; 0000 0167                    guzik7 = 0;
; 0000 0168                    guzik8 = 0;
; 0000 0169 
; 0000 016A                    czas_kodu_panela = 0;
; 0000 016B                    }
; 0000 016C 
; 0000 016D 
; 0000 016E       if(sek80 > 320)
_0x7:
	CALL SUBOPT_0x22
	BRLT _0x8
; 0000 016F                    {
; 0000 0170                    guzik = 0;
	CLR  R4
	CLR  R5
; 0000 0171                    delay_ms(500);
	CALL SUBOPT_0x16
; 0000 0172                    putchar(90);  //5A
; 0000 0173                    putchar(165); //A5
; 0000 0174                    putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 0175                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 0176                    putchar(2);    //02
	CALL SUBOPT_0x17
; 0000 0177                    putchar(16);   //10
; 0000 0178                    delay_ms(500);
; 0000 0179                    putchar(90);  //5A
; 0000 017A                    putchar(165); //A5
; 0000 017B                    putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 017C                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 017D                    putchar(2);    //02
	CALL SUBOPT_0x18
; 0000 017E                    putchar(16);   //10
; 0000 017F 
; 0000 0180                    wartosc_parametru_panelu(0, 80, 144);
	CALL SUBOPT_0x19
; 0000 0181                    wartosc_parametru_panelu(0, 80, 145);
	CALL SUBOPT_0x1A
; 0000 0182                    wartosc_parametru_panelu(0, 80, 146);
	CALL SUBOPT_0x1B
; 0000 0183                    wartosc_parametru_panelu(0, 80, 147);
	CALL SUBOPT_0x1C
; 0000 0184                    wartosc_parametru_panelu(0, 80, 148);
	CALL SUBOPT_0x1D
; 0000 0185                    wartosc_parametru_panelu(0, 80, 149);
	CALL SUBOPT_0x1E
; 0000 0186                    wartosc_parametru_panelu(0, 80, 150);
	CALL SUBOPT_0x1F
; 0000 0187                    wartosc_parametru_panelu(0, 80, 151);
	CALL SUBOPT_0x20
; 0000 0188                    wartosc_parametru_panelu(0, 80, 152);
	CALL SUBOPT_0x21
; 0000 0189 
; 0000 018A 
; 0000 018B                    guzik0 = 0;
; 0000 018C                    guzik1 = 0;
; 0000 018D                    guzik2 = 0;
; 0000 018E                    guzik3 = 0;
; 0000 018F                    guzik4 = 0;
; 0000 0190                    guzik5 = 0;
; 0000 0191                    guzik6 = 0;
; 0000 0192                    guzik7 = 0;
; 0000 0193                    guzik8 = 0;
; 0000 0194 
; 0000 0195                    czas_kodu_panela = 0;
; 0000 0196 
; 0000 0197 
; 0000 0198                    }
; 0000 0199 
; 0000 019A 
; 0000 019B       }
_0x8:
	RJMP _0x3
_0x5:
; 0000 019C }
	CALL __LOADLOCR6
	ADIW R28,20
	RET
;
;
;void odczyt_parametru_panelu_stala_pamiec(int adres_nieulotny1,int dokad_adres1,int dokad_adres2)
; 0000 01A0 {
_odczyt_parametru_panelu_stala_pamiec:
; 0000 01A1 
; 0000 01A2 //5AA5 0C 80 56 5A A0 00000000 1010 0010 – Odczyt (A0) z pamiêci FLASH 00000000 do VP 1010
; 0000 01A3 
; 0000 01A4 putchar(90);  //5A
;	adres_nieulotny1 -> Y+4
;	dokad_adres1 -> Y+2
;	dokad_adres2 -> Y+0
	CALL SUBOPT_0x0
; 0000 01A5 putchar(165); //A5
; 0000 01A6 putchar(12);   //0C
	CALL SUBOPT_0x6
; 0000 01A7 putchar(128);  //80    /
; 0000 01A8 putchar(86);    //56
; 0000 01A9 putchar(90);   //5A
; 0000 01AA putchar(160);    //A0
	LDI  R30,LOW(160)
_0x20A0001:
	ST   -Y,R30
	CALL _putchar
; 0000 01AB putchar(0);   //00
	CALL SUBOPT_0x15
; 0000 01AC putchar(0);   //00
	CALL SUBOPT_0x15
; 0000 01AD putchar(0);   //00
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4
; 0000 01AE putchar(adres_nieulotny1);   //00
; 0000 01AF putchar(dokad_adres1);   //10
; 0000 01B0 putchar(dokad_adres2);   //10
	CALL SUBOPT_0x2
; 0000 01B1 putchar(0);   //0
; 0000 01B2 putchar(16);   //ile danych
	LDI  R30,LOW(16)
_0x20A0003:
	ST   -Y,R30
	CALL _putchar
; 0000 01B3 }
_0x20A0002:
	ADIW R28,6
	RET
;
;// Declare your global variables here
;
;void main(void)
; 0000 01B8 {
_main:
; 0000 01B9 // Declare your local variables here
; 0000 01BA 
; 0000 01BB // Input/Output Ports initialization
; 0000 01BC // Port A initialization
; 0000 01BD // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 01BE // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 01BF PORTA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 01C0 DDRA=0xFF;
	OUT  0x1A,R30
; 0000 01C1 
; 0000 01C2 // Port B initialization
; 0000 01C3 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01C4 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01C5 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 01C6 DDRB=0x00;
	OUT  0x17,R30
; 0000 01C7 
; 0000 01C8 // Port C initialization
; 0000 01C9 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01CA // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01CB PORTC=0x00;
	OUT  0x15,R30
; 0000 01CC DDRC=0x00;
	OUT  0x14,R30
; 0000 01CD 
; 0000 01CE // Port D initialization
; 0000 01CF // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01D0 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01D1 PORTD=0x00;
	OUT  0x12,R30
; 0000 01D2 DDRD=0x00;
	OUT  0x11,R30
; 0000 01D3 
; 0000 01D4 // Port E initialization
; 0000 01D5 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01D6 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01D7 PORTE=0x00;
	OUT  0x3,R30
; 0000 01D8 DDRE=0x00;
	OUT  0x2,R30
; 0000 01D9 
; 0000 01DA // Port F initialization
; 0000 01DB // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01DC // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01DD PORTF=0x00;
	STS  98,R30
; 0000 01DE DDRF=0x00;
	STS  97,R30
; 0000 01DF 
; 0000 01E0 // Port G initialization
; 0000 01E1 // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01E2 // State4=T State3=T State2=T State1=T State0=T
; 0000 01E3 PORTG=0x00;
	STS  101,R30
; 0000 01E4 DDRG=0x00;
	STS  100,R30
; 0000 01E5 
; 0000 01E6 // Timer/Counter 0 initialization
; 0000 01E7 // Clock source: System Clock
; 0000 01E8 // Clock value: 15,625 kHz
; 0000 01E9 // Mode: Normal top=0xFF
; 0000 01EA // OC0 output: Disconnected
; 0000 01EB ASSR=0x00;
	OUT  0x30,R30
; 0000 01EC TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 01ED TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 01EE OCR0=0x00;
	OUT  0x31,R30
; 0000 01EF 
; 0000 01F0 // Timer/Counter 1 initialization
; 0000 01F1 // Clock source: System Clock
; 0000 01F2 // Clock value: Timer1 Stopped
; 0000 01F3 // Mode: Normal top=0xFFFF
; 0000 01F4 // OC1A output: Discon.
; 0000 01F5 // OC1B output: Discon.
; 0000 01F6 // OC1C output: Discon.
; 0000 01F7 // Noise Canceler: Off
; 0000 01F8 // Input Capture on Falling Edge
; 0000 01F9 // Timer1 Overflow Interrupt: Off
; 0000 01FA // Input Capture Interrupt: Off
; 0000 01FB // Compare A Match Interrupt: Off
; 0000 01FC // Compare B Match Interrupt: Off
; 0000 01FD // Compare C Match Interrupt: Off
; 0000 01FE TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 01FF TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0200 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0201 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0202 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0203 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0204 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0205 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0206 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0207 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0208 OCR1CH=0x00;
	STS  121,R30
; 0000 0209 OCR1CL=0x00;
	STS  120,R30
; 0000 020A 
; 0000 020B // Timer/Counter 2 initialization
; 0000 020C // Clock source: System Clock
; 0000 020D // Clock value: Timer2 Stopped
; 0000 020E // Mode: Normal top=0xFF
; 0000 020F // OC2 output: Disconnected
; 0000 0210 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0211 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0212 OCR2=0x00;
	OUT  0x23,R30
; 0000 0213 
; 0000 0214 // Timer/Counter 3 initialization
; 0000 0215 // Clock source: System Clock
; 0000 0216 // Clock value: Timer3 Stopped
; 0000 0217 // Mode: Normal top=0xFFFF
; 0000 0218 // OC3A output: Discon.
; 0000 0219 // OC3B output: Discon.
; 0000 021A // OC3C output: Discon.
; 0000 021B // Noise Canceler: Off
; 0000 021C // Input Capture on Falling Edge
; 0000 021D // Timer3 Overflow Interrupt: Off
; 0000 021E // Input Capture Interrupt: Off
; 0000 021F // Compare A Match Interrupt: Off
; 0000 0220 // Compare B Match Interrupt: Off
; 0000 0221 // Compare C Match Interrupt: Off
; 0000 0222 TCCR3A=0x00;
	STS  139,R30
; 0000 0223 TCCR3B=0x00;
	STS  138,R30
; 0000 0224 TCNT3H=0x00;
	STS  137,R30
; 0000 0225 TCNT3L=0x00;
	STS  136,R30
; 0000 0226 ICR3H=0x00;
	STS  129,R30
; 0000 0227 ICR3L=0x00;
	STS  128,R30
; 0000 0228 OCR3AH=0x00;
	STS  135,R30
; 0000 0229 OCR3AL=0x00;
	STS  134,R30
; 0000 022A OCR3BH=0x00;
	STS  133,R30
; 0000 022B OCR3BL=0x00;
	STS  132,R30
; 0000 022C OCR3CH=0x00;
	STS  131,R30
; 0000 022D OCR3CL=0x00;
	STS  130,R30
; 0000 022E 
; 0000 022F // External Interrupt(s) initialization
; 0000 0230 // INT0: Off
; 0000 0231 // INT1: Off
; 0000 0232 // INT2: Off
; 0000 0233 // INT3: Off
; 0000 0234 // INT4: Off
; 0000 0235 // INT5: Off
; 0000 0236 // INT6: Off
; 0000 0237 // INT7: Off
; 0000 0238 EICRA=0x00;
	STS  106,R30
; 0000 0239 EICRB=0x00;
	OUT  0x3A,R30
; 0000 023A EIMSK=0x00;
	OUT  0x39,R30
; 0000 023B 
; 0000 023C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 023D TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 023E 
; 0000 023F ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 0240 
; 0000 0241 // USART0 initialization
; 0000 0242 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0243 // USART0 Receiver: On
; 0000 0244 // USART0 Transmitter: On
; 0000 0245 // USART0 Mode: Asynchronous
; 0000 0246 // USART0 Baud Rate: 115200
; 0000 0247 //UCSR0A=0x00;
; 0000 0248 //UCSR0B=0x18;
; 0000 0249 //UCSR0C=0x06;
; 0000 024A //UBRR0H=0x00;
; 0000 024B //UBRR0L=0x08;
; 0000 024C 
; 0000 024D 
; 0000 024E 
; 0000 024F 
; 0000 0250 
; 0000 0251 // USART0 initialization
; 0000 0252 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0253 // USART0 Receiver: On
; 0000 0254 // USART0 Transmitter: On
; 0000 0255 // USART0 Mode: Asynchronous
; 0000 0256 // USART0 Baud Rate: 9600
; 0000 0257 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 0258 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0259 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 025A UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 025B UBRR0L=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 025C 
; 0000 025D 
; 0000 025E 
; 0000 025F 
; 0000 0260 
; 0000 0261 
; 0000 0262 // USART1 initialization
; 0000 0263 // USART1 disabled
; 0000 0264 UCSR1B=0x00;
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 0265 
; 0000 0266 // Analog Comparator initialization
; 0000 0267 // Analog Comparator: Off
; 0000 0268 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0269 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 026A SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 026B 
; 0000 026C // ADC initialization
; 0000 026D // ADC disabled
; 0000 026E ADCSRA=0x00;
	OUT  0x6,R30
; 0000 026F 
; 0000 0270 // SPI initialization
; 0000 0271 // SPI disabled
; 0000 0272 SPCR=0x00;
	OUT  0xD,R30
; 0000 0273 
; 0000 0274 // TWI initialization
; 0000 0275 // TWI disabled
; 0000 0276 TWCR=0x00;
	STS  116,R30
; 0000 0277 
; 0000 0278 
; 0000 0279 // Global enable interrupts
; 0000 027A #asm("sei")
	sei
; 0000 027B 
; 0000 027C 
; 0000 027D 
; 0000 027E delay_ms(2000);
	CALL SUBOPT_0x23
; 0000 027F delay_ms(2000);
	CALL SUBOPT_0x23
; 0000 0280 
; 0000 0281 
; 0000 0282 putchar(90);  //5A
	CALL SUBOPT_0x0
; 0000 0283 putchar(165); //A5
; 0000 0284 putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 0285 putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 0286 putchar(2);    //02
	CALL SUBOPT_0x24
; 0000 0287 putchar(16);   //10
; 0000 0288 
; 0000 0289 delay_ms(2000);
; 0000 028A 
; 0000 028B putchar(90);  //5A
	CALL SUBOPT_0x0
; 0000 028C putchar(165); //A5
; 0000 028D putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 028E putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 028F putchar(2);    //02
	CALL SUBOPT_0x24
; 0000 0290 putchar(16);   //10
; 0000 0291 
; 0000 0292 delay_ms(2000);
; 0000 0293 
; 0000 0294 // to dziala na bank to ponizej
; 0000 0295 /*
; 0000 0296 wartosc_parametru_panelu(9,16,0);
; 0000 0297 
; 0000 0298 delay_ms(2000);
; 0000 0299 
; 0000 029A putchar(90);  //5A
; 0000 029B putchar(165); //A5
; 0000 029C putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 029D putchar(128);  //80
; 0000 029E putchar(2);    //02
; 0000 029F putchar(16);   //10
; 0000 02A0 
; 0000 02A1 delay_ms(2000);
; 0000 02A2 
; 0000 02A3 wartosc_parametru_panelu_stala_pamiec(9,16,0);
; 0000 02A4 
; 0000 02A5 delay_ms(2000);
; 0000 02A6 
; 0000 02A7 putchar(90);  //5A
; 0000 02A8 putchar(165); //A5
; 0000 02A9 putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 02AA putchar(128);  //80
; 0000 02AB putchar(2);    //02
; 0000 02AC putchar(16);   //10
; 0000 02AD 
; 0000 02AE delay_ms(2000);
; 0000 02AF 
; 0000 02B0 odczyt_parametru_panelu_stala_pamiec(9,16,0);
; 0000 02B1 
; 0000 02B2 delay_ms(2000);
; 0000 02B3 */
; 0000 02B4 
; 0000 02B5 wartosc_parametru_panelu(1,16,0);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	RCALL _wartosc_parametru_panelu
; 0000 02B6 wartosc_parametru_panelu(2,16,16);
	CALL SUBOPT_0x28
	CALL SUBOPT_0x26
	CALL SUBOPT_0x26
	CALL SUBOPT_0x29
; 0000 02B7 
; 0000 02B8 wartosc_parametru_panelu_stala_pamiec(0,16,0);
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
; 0000 02B9 
; 0000 02BA delay_ms(200);
; 0000 02BB 
; 0000 02BC wartosc_parametru_panelu_stala_pamiec(16,16,16);
	CALL SUBOPT_0x26
	CALL SUBOPT_0x26
	CALL SUBOPT_0x26
	CALL SUBOPT_0x2A
; 0000 02BD 
; 0000 02BE //delay_ms(1000);
; 0000 02BF //putchar(adres_nieulotny1);   //00
; 0000 02C0 //putchar(skad_adres1);   //10
; 0000 02C1 //putchar(skad_adres2);   //0
; 0000 02C2 
; 0000 02C3 delay_ms(200);
; 0000 02C4 
; 0000 02C5 odczyt_parametru_panelu_stala_pamiec(0,16,48);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x26
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _odczyt_parametru_panelu_stala_pamiec
; 0000 02C6 
; 0000 02C7 delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x2B
; 0000 02C8 
; 0000 02C9 odczyt_parametru_panelu_stala_pamiec(16,16,32);
	CALL SUBOPT_0x26
	CALL SUBOPT_0x26
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _odczyt_parametru_panelu_stala_pamiec
; 0000 02CA //putchar(adres_nieulotny1);   //00
; 0000 02CB //putchar(dokad_adres1);   //10
; 0000 02CC //putchar(dokad_adres2);   //10
; 0000 02CD /*
; 0000 02CE 
; 0000 02CF delay_ms(2000);
; 0000 02D0 wartosc_parametru_panelu_stala_pamiec(16,0,0,16);
; 0000 02D1 delay_ms(2000);
; 0000 02D2 wartosc_parametru_panelu_stala_pamiec_1(16,16,0,16);  //to (32)20 to teoria
; 0000 02D3 
; 0000 02D4 //putchar(skad_adres1);   //10
; 0000 02D5 //putchar(skad_adres2);   //0
; 0000 02D6 //putchar(dokad_adres1);   //0
; 0000 02D7 //putchar(dokad_adres2);   //10
; 0000 02D8 
; 0000 02D9 
; 0000 02DA delay_ms(2000);
; 0000 02DB odczyt_parametru_panelu_stala_pamiec(16,48,0,16);
; 0000 02DC delay_ms(2000);
; 0000 02DD odczyt_parametru_panelu_stala_pamiec_1(16,32,0,16);
; 0000 02DE 
; 0000 02DF 
; 0000 02E0 
; 0000 02E1 //putchar(dokad_adres1);   //10
; 0000 02E2 //putchar(dokad_adres2);   //10
; 0000 02E3 //putchar(skad_adres1);   //0
; 0000 02E4 //putchar(skad_adres2);   //10
; 0000 02E5 
; 0000 02E6 */
; 0000 02E7 //wartosc_parametru_panelu_stala_pamiec(16,0,0,16);
; 0000 02E8 //putchar(skad_adres1);   //10
; 0000 02E9 //putchar(skad_adres2);   //0
; 0000 02EA //putchar(dokad_adres1);   //0
; 0000 02EB //putchar(dokad_adres2);   //10
; 0000 02EC 
; 0000 02ED 
; 0000 02EE 
; 0000 02EF obsluga_trybu_administratora();
	RCALL _obsluga_trybu_administratora
; 0000 02F0 
; 0000 02F1 
; 0000 02F2 
; 0000 02F3 while (1)
_0x9:
; 0000 02F4       {
; 0000 02F5       wartosc_parametru_panelu(7, 16, 0);
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	RCALL _wartosc_parametru_panelu
; 0000 02F6       //wartosc_parametru_panelu(0, 144, 1);
; 0000 02F7       //wartosc_parametru_panelu(0, 144, 2);
; 0000 02F8 
; 0000 02F9       guzik0 = odczytaj_parametr(144,0);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x27
	RCALL _odczytaj_parametr
	MOVW R6,R30
; 0000 02FA       guzik1 = odczytaj_parametr(144,1);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x25
	RCALL _odczytaj_parametr
	MOVW R8,R30
; 0000 02FB       guzik2 = odczytaj_parametr(144,2);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x28
	RCALL _odczytaj_parametr
	MOVW R10,R30
; 0000 02FC 
; 0000 02FD       while(guzik0 == 1 | guzik1 == 1 | guzik2 == 1)
_0xC:
	MOVW R26,R6
	CALL SUBOPT_0x11
	MOV  R0,R30
	MOVW R26,R8
	CALL SUBOPT_0x11
	OR   R0,R30
	MOVW R26,R10
	CALL SUBOPT_0x11
	OR   R30,R0
	BRNE PC+3
	JMP _0xE
; 0000 02FE       {
; 0000 02FF 
; 0000 0300       if(czas_kodu_panela == 0)
	MOV  R0,R12
	OR   R0,R13
	BRNE _0xF
; 0000 0301       {
; 0000 0302       sek80 = 0;
	CALL SUBOPT_0x12
; 0000 0303       czas_kodu_panela = 1;
	MOVW R12,R30
; 0000 0304       }
; 0000 0305 
; 0000 0306       guzik0 = odczytaj_parametr(144,0);
_0xF:
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x27
	RCALL _odczytaj_parametr
	MOVW R6,R30
; 0000 0307       guzik1 = odczytaj_parametr(144,1);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x25
	RCALL _odczytaj_parametr
	MOVW R8,R30
; 0000 0308       guzik2 = odczytaj_parametr(144,2);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x28
	RCALL _odczytaj_parametr
	MOVW R10,R30
; 0000 0309 
; 0000 030A       if((guzik0 + guzik1 + guzik2) == 2 & (guzik0 == 1 & guzik1 == 0 & guzik2 == 1))
	MOVW R30,R8
	ADD  R30,R6
	ADC  R31,R7
	ADD  R30,R10
	ADC  R31,R11
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	CALL __EQW12
	MOV  R1,R30
	MOVW R26,R6
	CALL SUBOPT_0x11
	MOV  R0,R30
	MOVW R26,R8
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R0,R30
	MOVW R26,R10
	CALL SUBOPT_0x11
	AND  R30,R0
	AND  R30,R1
	BRNE PC+3
	JMP _0x10
; 0000 030B                    {
; 0000 030C                    guzik = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 030D 
; 0000 030E                    putchar(90);  //5A
	CALL SUBOPT_0x0
; 0000 030F                    putchar(165); //A5
; 0000 0310                    putchar(4);//04  //zmiana obrazu
	CALL SUBOPT_0x3
; 0000 0311                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 0312                    putchar(3);    //03
	CALL SUBOPT_0x14
; 0000 0313                    putchar(0);   //2
	CALL SUBOPT_0x15
; 0000 0314                    putchar(2);   //2
	CALL SUBOPT_0x2D
; 0000 0315 
; 0000 0316                    wartosc_parametru_panelu(guzik+3, 16, 0);
	MOVW R30,R4
	ADIW R30,3
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	RCALL _wartosc_parametru_panelu
; 0000 0317 
; 0000 0318                    delay_ms(500);
	CALL SUBOPT_0x16
; 0000 0319                    putchar(90);  //5A
; 0000 031A                    putchar(165); //A5
; 0000 031B                    putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 031C                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 031D                    putchar(2);    //02
	CALL SUBOPT_0x17
; 0000 031E                    putchar(16);   //10
; 0000 031F                    delay_ms(500);
; 0000 0320                    putchar(90);  //5A
; 0000 0321                    putchar(165); //A5
; 0000 0322                    putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 0323                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 0324                    putchar(2);    //02
	CALL SUBOPT_0x17
; 0000 0325                    putchar(16);   //10
; 0000 0326                    delay_ms(500);
; 0000 0327                    putchar(90);  //5A
; 0000 0328                    putchar(165); //A5
; 0000 0329                    putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 032A                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 032B                    putchar(2);    //02
	CALL SUBOPT_0x17
; 0000 032C                    putchar(16);   //10
; 0000 032D                    delay_ms(500);
; 0000 032E                    putchar(90);  //5A
; 0000 032F                    putchar(165); //A5
; 0000 0330                    putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 0331                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 0332                    putchar(2);    //02
	CALL SUBOPT_0x2D
; 0000 0333                    putchar(16);   //10
	CALL SUBOPT_0x2E
; 0000 0334 
; 0000 0335 
; 0000 0336 
; 0000 0337 
; 0000 0338 
; 0000 0339                    wartosc_parametru_panelu(0, 144, 0);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
; 0000 033A                    wartosc_parametru_panelu(0, 144, 1);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x25
	CALL SUBOPT_0x29
; 0000 033B                    wartosc_parametru_panelu(0, 144, 2);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2F
; 0000 033C 
; 0000 033D                      guzik0 = 0;
; 0000 033E                      guzik1 = 0;
; 0000 033F                      guzik2 = 0;
; 0000 0340 
; 0000 0341                    czas_kodu_panela = 0;
; 0000 0342                    }
; 0000 0343 
; 0000 0344 
; 0000 0345       if(sek80 > 320)
_0x10:
	CALL SUBOPT_0x22
	BRLT _0x11
; 0000 0346                    {
; 0000 0347                    guzik = 0;
	CLR  R4
	CLR  R5
; 0000 0348                    delay_ms(500);
	CALL SUBOPT_0x16
; 0000 0349                    putchar(90);  //5A
; 0000 034A                    putchar(165); //A5
; 0000 034B                    putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 034C                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 034D                    putchar(2);    //02
	CALL SUBOPT_0x17
; 0000 034E                    putchar(16);   //10
; 0000 034F                    delay_ms(500);
; 0000 0350                    putchar(90);  //5A
; 0000 0351                    putchar(165); //A5
; 0000 0352                    putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x14
; 0000 0353                    putchar(128);  //80
	CALL SUBOPT_0x13
; 0000 0354                    putchar(2);    //02
	CALL SUBOPT_0x2D
; 0000 0355                    putchar(16);   //10
	CALL SUBOPT_0x2E
; 0000 0356 
; 0000 0357 
; 0000 0358                    wartosc_parametru_panelu(0, 144, 0);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x27
	CALL SUBOPT_0x29
; 0000 0359                    wartosc_parametru_panelu(0, 144, 1);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x25
	CALL SUBOPT_0x29
; 0000 035A                    wartosc_parametru_panelu(0, 144, 2);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2F
; 0000 035B 
; 0000 035C                      guzik0 = 0;
; 0000 035D                      guzik1 = 0;
; 0000 035E                      guzik2 = 0;
; 0000 035F 
; 0000 0360                     czas_kodu_panela = 0;
; 0000 0361                    }
; 0000 0362 
; 0000 0363 
; 0000 0364       }
_0x11:
	RJMP _0xC
_0xE:
; 0000 0365 
; 0000 0366 
; 0000 0367 
; 0000 0368       if(guzik == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x12
; 0000 0369       {
; 0000 036A        guzik = 0;
	CLR  R4
	CLR  R5
; 0000 036B 
; 0000 036C 
; 0000 036D 
; 0000 036E       PORTA.0 = 0;
	CBI  0x1B,0
; 0000 036F       delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x2B
; 0000 0370       PORTA.0 = 1;
	SBI  0x1B,0
; 0000 0371       delay_ms(3000);
	CALL SUBOPT_0x30
; 0000 0372       delay_ms(3000);
	CALL SUBOPT_0x30
; 0000 0373       delay_ms(3000);
	CALL SUBOPT_0x30
; 0000 0374       delay_ms(3000);
	CALL SUBOPT_0x30
; 0000 0375       delay_ms(3000);
	CALL SUBOPT_0x30
; 0000 0376 
; 0000 0377 
; 0000 0378       }
; 0000 0379       // Place your code here
; 0000 037A 
; 0000 037B       }
_0x12:
	RJMP _0x9
; 0000 037C }
_0x17:
	RJMP _0x17
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_getchar:
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_sek80:
	.BYTE 0x4
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:111 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(90)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(165)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	CALL _putchar
	LDD  R30,Y+2
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LD   R30,Y
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	CALL _putchar
	LDD  R30,Y+4
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	CALL _getchar
	CALL _getchar
	JMP  _getchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(86)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(90)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	MOVW R16,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	MOVW R18,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	MOVW R20,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(147)
	LDI  R31,HIGH(147)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STD  Y+18,R30
	STD  Y+18+1,R31
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(148)
	LDI  R31,HIGH(148)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(149)
	LDI  R31,HIGH(149)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STD  Y+12,R30
	STD  Y+12+1,R31
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(151)
	LDI  R31,HIGH(151)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(152)
	LDI  R31,HIGH(152)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	STS  _sek80,R30
	STS  _sek80+1,R30
	STS  _sek80+2,R30
	STS  _sek80+3,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(128)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(147)
	LDI  R31,HIGH(147)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(148)
	LDI  R31,HIGH(148)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(149)
	LDI  R31,HIGH(149)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(151)
	LDI  R31,HIGH(151)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(152)
	LDI  R31,HIGH(152)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R30,LOW(0)
	STD  Y+18,R30
	STD  Y+18+1,R30
	STD  Y+16,R30
	STD  Y+16+1,R30
	STD  Y+14,R30
	STD  Y+14+1,R30
	STD  Y+12,R30
	STD  Y+12+1,R30
	STD  Y+10,R30
	STD  Y+10+1,R30
	STD  Y+8,R30
	STD  Y+8+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x22:
	LDS  R26,_sek80
	LDS  R27,_sek80+1
	LDS  R24,_sek80+2
	LDS  R25,_sek80+3
	__CPD2N 0x141
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	CALL _wartosc_parametru_panelu
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	CALL _wartosc_parametru_panelu_stala_pamiec
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	CALL _wartosc_parametru_panelu
	CLR  R6
	CLR  R7
	CLR  R8
	CLR  R9
	CLR  R10
	CLR  R11
	CLR  R12
	CLR  R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	RJMP SUBOPT_0x2B


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
