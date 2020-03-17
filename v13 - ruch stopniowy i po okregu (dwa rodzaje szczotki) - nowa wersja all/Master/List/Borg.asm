
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
	.DEF _xxx=R4
	.DEF _nr_zacisku=R6
	.DEF _odczytalem_zacisk=R8
	.DEF _il_prob_odczytu=R10
	.DEF _czas_zatrzymania_na_dole=R12

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

_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x5A,0x61,0x63,0x69,0x73,0x6B,0x20
	.DB  0x6E,0x69,0x65,0x20,0x7A,0x6D,0x69,0x65
	.DB  0x72,0x7A,0x6F,0x6E,0x79,0x20,0x75,0x20
	.DB  0x57,0x79,0x6B,0x6F,0x6E,0x61,0x77,0x63
	.DB  0x79,0x0,0x4B,0x6C,0x79,0x20,0x77,0x20
	.DB  0x6B,0x69,0x65,0x72,0x75,0x6E,0x6B,0x75
	.DB  0x20,0x70,0x72,0x61,0x77,0x65,0x6A,0x20
	.DB  0x73,0x74,0x72,0x6F,0x6E,0x79,0x0,0x4B
	.DB  0x6C,0x79,0x20,0x77,0x20,0x6B,0x69,0x65
	.DB  0x72,0x75,0x6E,0x6B,0x75,0x20,0x6C,0x65
	.DB  0x77,0x65,0x6A,0x20,0x73,0x74,0x72,0x6F
	.DB  0x6E,0x79,0x0,0x43,0x69,0x73,0x6E,0x69
	.DB  0x65,0x6E,0x69,0x65,0x20,0x7A,0x61,0x20
	.DB  0x6D,0x61,0x6C,0x65,0x20,0x2D,0x20,0x6D
	.DB  0x6E,0x69,0x65,0x6A,0x73,0x7A,0x65,0x20
	.DB  0x6E,0x69,0x7A,0x20,0x36,0x20,0x62,0x61
	.DB  0x72,0x0,0x38,0x36,0x2D,0x30,0x31,0x37
	.DB  0x30,0x0,0x38,0x36,0x2D,0x31,0x30,0x34
	.DB  0x33,0x0,0x38,0x36,0x2D,0x31,0x36,0x37
	.DB  0x35,0x0,0x38,0x36,0x2D,0x32,0x30,0x39
	.DB  0x38,0x0,0x38,0x37,0x2D,0x30,0x31,0x37
	.DB  0x30,0x0,0x38,0x37,0x2D,0x31,0x30,0x34
	.DB  0x33,0x0,0x38,0x37,0x2D,0x31,0x36,0x37
	.DB  0x35,0x0,0x38,0x37,0x2D,0x32,0x30,0x39
	.DB  0x38,0x0,0x38,0x36,0x2D,0x30,0x31,0x39
	.DB  0x32,0x0,0x38,0x36,0x2D,0x31,0x30,0x35
	.DB  0x34,0x0,0x38,0x36,0x2D,0x31,0x36,0x37
	.DB  0x36,0x0,0x38,0x36,0x2D,0x32,0x31,0x33
	.DB  0x32,0x0,0x38,0x37,0x2D,0x30,0x31,0x39
	.DB  0x32,0x0,0x38,0x37,0x2D,0x31,0x30,0x35
	.DB  0x34,0x0,0x38,0x37,0x2D,0x31,0x36,0x37
	.DB  0x36,0x0,0x38,0x37,0x2D,0x32,0x31,0x33
	.DB  0x32,0x0,0x38,0x36,0x2D,0x30,0x31,0x39
	.DB  0x33,0x0,0x38,0x36,0x2D,0x31,0x32,0x31
	.DB  0x36,0x0,0x38,0x36,0x2D,0x31,0x38,0x33
	.DB  0x32,0x0,0x38,0x36,0x2D,0x32,0x31,0x37
	.DB  0x34,0x0,0x38,0x37,0x2D,0x30,0x31,0x39
	.DB  0x33,0x0,0x38,0x37,0x2D,0x31,0x32,0x31
	.DB  0x36,0x0,0x38,0x37,0x2D,0x31,0x38,0x33
	.DB  0x32,0x0,0x38,0x37,0x2D,0x32,0x31,0x37
	.DB  0x34,0x0,0x38,0x36,0x2D,0x30,0x31,0x39
	.DB  0x34,0x0,0x38,0x36,0x2D,0x31,0x33,0x34
	.DB  0x31,0x0,0x38,0x36,0x2D,0x31,0x38,0x33
	.DB  0x33,0x0,0x38,0x36,0x2D,0x32,0x31,0x38
	.DB  0x30,0x0,0x38,0x37,0x2D,0x30,0x31,0x39
	.DB  0x34,0x0,0x38,0x37,0x2D,0x31,0x33,0x34
	.DB  0x31,0x0,0x38,0x37,0x2D,0x31,0x38,0x33
	.DB  0x33,0x0,0x38,0x37,0x2D,0x32,0x31,0x38
	.DB  0x30,0x0,0x38,0x36,0x2D,0x30,0x36,0x36
	.DB  0x33,0x0,0x38,0x36,0x2D,0x31,0x33,0x34
	.DB  0x39,0x0,0x38,0x36,0x2D,0x31,0x38,0x33
	.DB  0x34,0x0,0x38,0x36,0x2D,0x32,0x32,0x30
	.DB  0x34,0x0,0x38,0x37,0x2D,0x30,0x36,0x36
	.DB  0x33,0x0,0x38,0x37,0x2D,0x31,0x33,0x34
	.DB  0x39,0x0,0x38,0x37,0x2D,0x31,0x38,0x33
	.DB  0x34,0x0,0x38,0x37,0x2D,0x32,0x32,0x30
	.DB  0x34,0x0,0x38,0x36,0x2D,0x30,0x37,0x36
	.DB  0x38,0x0,0x38,0x36,0x2D,0x31,0x33,0x35
	.DB  0x37,0x0,0x38,0x36,0x2D,0x31,0x38,0x34
	.DB  0x38,0x0,0x38,0x36,0x2D,0x32,0x32,0x31
	.DB  0x32,0x0,0x38,0x37,0x2D,0x30,0x37,0x36
	.DB  0x38,0x0,0x38,0x37,0x2D,0x31,0x33,0x35
	.DB  0x37,0x0,0x38,0x37,0x2D,0x31,0x38,0x34
	.DB  0x38,0x0,0x38,0x37,0x2D,0x32,0x32,0x31
	.DB  0x32,0x0,0x38,0x36,0x2D,0x30,0x38,0x30
	.DB  0x30,0x0,0x38,0x36,0x2D,0x31,0x33,0x36
	.DB  0x33,0x0,0x38,0x36,0x2D,0x31,0x39,0x30
	.DB  0x34,0x0,0x38,0x36,0x2D,0x32,0x32,0x34
	.DB  0x31,0x0,0x38,0x37,0x2D,0x30,0x38,0x30
	.DB  0x30,0x0,0x38,0x37,0x2D,0x31,0x33,0x36
	.DB  0x33,0x0,0x38,0x37,0x2D,0x31,0x39,0x30
	.DB  0x34,0x0,0x38,0x37,0x2D,0x32,0x32,0x34
	.DB  0x31,0x0,0x38,0x36,0x2D,0x30,0x38,0x31
	.DB  0x31,0x0,0x38,0x36,0x2D,0x31,0x35,0x32
	.DB  0x33,0x0,0x38,0x36,0x2D,0x31,0x39,0x32
	.DB  0x39,0x0,0x38,0x36,0x2D,0x32,0x32,0x36
	.DB  0x31,0x0,0x38,0x37,0x2D,0x30,0x38,0x31
	.DB  0x31,0x0,0x38,0x37,0x2D,0x31,0x35,0x32
	.DB  0x33,0x0,0x38,0x37,0x2D,0x31,0x39,0x32
	.DB  0x39,0x0,0x38,0x37,0x2D,0x32,0x32,0x36
	.DB  0x31,0x0,0x38,0x36,0x2D,0x30,0x38,0x31
	.DB  0x34,0x0,0x38,0x36,0x2D,0x31,0x35,0x33
	.DB  0x30,0x0,0x38,0x36,0x2D,0x31,0x39,0x33
	.DB  0x36,0x0,0x38,0x36,0x2D,0x32,0x32,0x38
	.DB  0x35,0x0,0x38,0x37,0x2D,0x30,0x38,0x31
	.DB  0x34,0x0,0x38,0x37,0x2D,0x31,0x35,0x33
	.DB  0x30,0x0,0x38,0x37,0x2D,0x31,0x39,0x33
	.DB  0x36,0x0,0x38,0x37,0x2D,0x32,0x32,0x38
	.DB  0x35,0x0,0x38,0x36,0x2D,0x30,0x38,0x31
	.DB  0x35,0x0,0x38,0x36,0x2D,0x31,0x35,0x35
	.DB  0x31,0x0,0x38,0x36,0x2D,0x31,0x39,0x34
	.DB  0x31,0x0,0x38,0x36,0x2D,0x32,0x32,0x38
	.DB  0x36,0x0,0x38,0x37,0x2D,0x30,0x38,0x31
	.DB  0x35,0x0,0x38,0x37,0x2D,0x31,0x35,0x35
	.DB  0x31,0x0,0x38,0x37,0x2D,0x31,0x39,0x34
	.DB  0x31,0x0,0x38,0x37,0x2D,0x32,0x32,0x38
	.DB  0x36,0x0,0x38,0x36,0x2D,0x30,0x38,0x31
	.DB  0x36,0x0,0x38,0x36,0x2D,0x31,0x35,0x35
	.DB  0x32,0x0,0x38,0x36,0x2D,0x32,0x30,0x30
	.DB  0x37,0x0,0x38,0x36,0x2D,0x32,0x32,0x39
	.DB  0x32,0x0,0x38,0x37,0x2D,0x30,0x38,0x31
	.DB  0x36,0x0,0x38,0x37,0x2D,0x31,0x35,0x35
	.DB  0x32,0x0,0x38,0x37,0x2D,0x32,0x30,0x30
	.DB  0x37,0x0,0x38,0x37,0x2D,0x32,0x32,0x39
	.DB  0x32,0x0,0x38,0x36,0x2D,0x30,0x38,0x31
	.DB  0x37,0x0,0x38,0x36,0x2D,0x31,0x36,0x30
	.DB  0x32,0x0,0x38,0x36,0x2D,0x32,0x30,0x31
	.DB  0x37,0x0,0x38,0x36,0x2D,0x32,0x33,0x38
	.DB  0x34,0x0,0x38,0x37,0x2D,0x30,0x38,0x31
	.DB  0x37,0x0,0x38,0x37,0x2D,0x31,0x36,0x30
	.DB  0x32,0x0,0x38,0x37,0x2D,0x32,0x30,0x31
	.DB  0x37,0x0,0x38,0x37,0x2D,0x32,0x33,0x38
	.DB  0x34,0x0,0x38,0x36,0x2D,0x30,0x38,0x34
	.DB  0x37,0x0,0x38,0x36,0x2D,0x31,0x36,0x32
	.DB  0x30,0x0,0x38,0x36,0x2D,0x32,0x30,0x31
	.DB  0x39,0x0,0x38,0x36,0x2D,0x32,0x33,0x38
	.DB  0x35,0x0,0x38,0x37,0x2D,0x30,0x38,0x34
	.DB  0x37,0x0,0x38,0x37,0x2D,0x31,0x36,0x32
	.DB  0x30,0x0,0x38,0x37,0x2D,0x32,0x30,0x31
	.DB  0x39,0x0,0x38,0x37,0x2D,0x32,0x33,0x38
	.DB  0x35,0x0,0x38,0x36,0x2D,0x30,0x38,0x35
	.DB  0x34,0x0,0x38,0x36,0x2D,0x31,0x36,0x32
	.DB  0x32,0x0,0x38,0x36,0x2D,0x32,0x30,0x32
	.DB  0x38,0x0,0x38,0x36,0x2D,0x32,0x34,0x33
	.DB  0x37,0x0,0x38,0x37,0x2D,0x30,0x38,0x35
	.DB  0x34,0x0,0x38,0x37,0x2D,0x31,0x36,0x32
	.DB  0x32,0x0,0x38,0x37,0x2D,0x32,0x30,0x32
	.DB  0x38,0x0,0x38,0x37,0x2D,0x32,0x34,0x33
	.DB  0x37,0x0,0x38,0x36,0x2D,0x30,0x38,0x36
	.DB  0x32,0x0,0x38,0x36,0x2D,0x31,0x36,0x32
	.DB  0x35,0x0,0x38,0x36,0x2D,0x32,0x30,0x35
	.DB  0x32,0x0,0x38,0x36,0x2D,0x32,0x34,0x39
	.DB  0x32,0x0,0x38,0x37,0x2D,0x30,0x38,0x36
	.DB  0x32,0x0,0x38,0x37,0x2D,0x31,0x36,0x32
	.DB  0x35,0x0,0x38,0x37,0x2D,0x32,0x30,0x35
	.DB  0x32,0x0,0x38,0x37,0x2D,0x32,0x34,0x39
	.DB  0x32,0x0,0x38,0x36,0x2D,0x30,0x39,0x33
	.DB  0x35,0x0,0x38,0x36,0x2D,0x31,0x36,0x34
	.DB  0x38,0x0,0x38,0x36,0x2D,0x32,0x30,0x38
	.DB  0x32,0x0,0x38,0x36,0x2D,0x32,0x35,0x30
	.DB  0x30,0x0,0x38,0x37,0x2D,0x30,0x39,0x33
	.DB  0x35,0x0,0x38,0x37,0x2D,0x31,0x36,0x34
	.DB  0x38,0x0,0x38,0x37,0x2D,0x32,0x30,0x38
	.DB  0x32,0x0,0x38,0x37,0x2D,0x32,0x35,0x30
	.DB  0x30,0x0,0x38,0x36,0x2D,0x31,0x30,0x31
	.DB  0x39,0x0,0x38,0x36,0x2D,0x31,0x36,0x34
	.DB  0x39,0x0,0x38,0x36,0x2D,0x32,0x30,0x38
	.DB  0x33,0x0,0x38,0x36,0x2D,0x32,0x35,0x38
	.DB  0x35,0x0,0x38,0x37,0x2D,0x31,0x30,0x31
	.DB  0x39,0x0,0x38,0x37,0x2D,0x31,0x36,0x34
	.DB  0x39,0x0,0x38,0x37,0x2D,0x32,0x30,0x38
	.DB  0x33,0x0,0x38,0x37,0x2D,0x32,0x36,0x32
	.DB  0x34,0x0,0x38,0x36,0x2D,0x31,0x30,0x32
	.DB  0x37,0x0,0x38,0x36,0x2D,0x31,0x36,0x36
	.DB  0x39,0x0,0x38,0x36,0x2D,0x32,0x30,0x38
	.DB  0x37,0x0,0x38,0x36,0x2D,0x32,0x36,0x32
	.DB  0x34,0x0,0x38,0x37,0x2D,0x31,0x30,0x32
	.DB  0x37,0x0,0x38,0x37,0x2D,0x31,0x36,0x36
	.DB  0x39,0x0,0x38,0x37,0x2D,0x32,0x30,0x38
	.DB  0x37,0x0,0x38,0x37,0x2D,0x32,0x35,0x38
	.DB  0x35,0x0,0x4E,0x69,0x65,0x20,0x77,0x63
	.DB  0x7A,0x79,0x74,0x61,0x6E,0x6F,0x20,0x7A
	.DB  0x61,0x63,0x69,0x73,0x6B,0x75,0x0,0x5A
	.DB  0x61,0x74,0x72,0x7A,0x79,0x6D,0x61,0x6E
	.DB  0x6F,0x20,0x2D,0x20,0x6E,0x61,0x63,0x69
	.DB  0x73,0x6E,0x69,0x6A,0x20,0x53,0x54,0x41
	.DB  0x52,0x54,0x20,0x61,0x62,0x79,0x20,0x77
	.DB  0x7A,0x6E,0x6F,0x77,0x69,0x63,0x0,0x5A
	.DB  0x61,0x6D,0x6B,0x6E,0x69,0x6A,0x20,0x6F
	.DB  0x73,0x6C,0x6F,0x6E,0x79,0x20,0x67,0x6F
	.DB  0x72,0x6E,0x65,0x20,0x69,0x20,0x6E,0x61
	.DB  0x63,0x69,0x73,0x6E,0x69,0x6A,0x20,0x53
	.DB  0x54,0x41,0x52,0x54,0x0,0x4E,0x61,0x63
	.DB  0x69,0x73,0x6E,0x69,0x6A,0x20,0x53,0x54
	.DB  0x41,0x52,0x54,0x20,0x61,0x62,0x79,0x20
	.DB  0x77,0x79,0x70,0x6F,0x7A,0x79,0x63,0x6A
	.DB  0x6F,0x6E,0x6F,0x77,0x61,0x63,0x20,0x6E
	.DB  0x61,0x70,0x65,0x64,0x79,0x0,0x5A,0x61
	.DB  0x6D,0x6B,0x6E,0x69,0x6A,0x20,0x6F,0x73
	.DB  0x6C,0x6F,0x6E,0x79,0x20,0x67,0x6F,0x72
	.DB  0x6E,0x65,0x0,0x4F,0x74,0x77,0x61,0x72
	.DB  0x63,0x69,0x65,0x20,0x6F,0x73,0x6C,0x6F
	.DB  0x6E,0x20,0x77,0x20,0x74,0x72,0x61,0x6B
	.DB  0x63,0x69,0x65,0x20,0x70,0x6F,0x7A,0x79
	.DB  0x63,0x6A,0x6F,0x6E,0x6F,0x77,0x61,0x6E
	.DB  0x69,0x61,0x0,0x57,0x79,0x6C,0x61,0x63
	.DB  0x7A,0x20,0x69,0x20,0x77,0x6C,0x61,0x63
	.DB  0x7A,0x20,0x6D,0x61,0x73,0x7A,0x79,0x6E
	.DB  0x65,0x0,0x5A,0x61,0x74,0x72,0x7A,0x79
	.DB  0x6D,0x61,0x6E,0x69,0x65,0x20,0x77,0x20
	.DB  0x74,0x72,0x61,0x6B,0x63,0x69,0x65,0x20
	.DB  0x70,0x6F,0x7A,0x79,0x63,0x6A,0x6F,0x6E
	.DB  0x6F,0x77,0x61,0x6E,0x69,0x61,0x0,0x50
	.DB  0x6F,0x7A,0x79,0x63,0x6A,0x6F,0x6E,0x75
	.DB  0x6A,0x65,0x20,0x75,0x6B,0x6C,0x61,0x64
	.DB  0x79,0x20,0x6C,0x69,0x6E,0x69,0x6F,0x77
	.DB  0x65,0x20,0x58,0x59,0x5A,0x0,0x53,0x74
	.DB  0x65,0x72,0x6F,0x77,0x6E,0x69,0x6B,0x20
	.DB  0x33,0x20,0x2D,0x20,0x77,0x79,0x70,0x6F
	.DB  0x7A,0x79,0x63,0x6A,0x6F,0x6E,0x6F,0x77
	.DB  0x61,0x6C,0x65,0x6D,0x0,0x53,0x74,0x65
	.DB  0x72,0x6F,0x77,0x6E,0x69,0x6B,0x20,0x34
	.DB  0x20,0x2D,0x20,0x77,0x79,0x70,0x6F,0x7A
	.DB  0x79,0x63,0x6A,0x6F,0x6E,0x6F,0x77,0x61
	.DB  0x6C,0x65,0x6D,0x0,0x41,0x6C,0x61,0x72
	.DB  0x6D,0x20,0x53,0x74,0x65,0x72,0x6F,0x77
	.DB  0x6E,0x69,0x6B,0x20,0x34,0x0,0x41,0x6C
	.DB  0x61,0x72,0x6D,0x20,0x53,0x74,0x65,0x72
	.DB  0x6F,0x77,0x6E,0x69,0x6B,0x20,0x33,0x0
	.DB  0x53,0x74,0x65,0x72,0x6F,0x77,0x6E,0x69
	.DB  0x6B,0x20,0x31,0x20,0x2D,0x20,0x77,0x79
	.DB  0x70,0x6F,0x7A,0x79,0x63,0x6A,0x6F,0x6E
	.DB  0x6F,0x77,0x61,0x6C,0x65,0x6D,0x0,0x53
	.DB  0x74,0x65,0x72,0x6F,0x77,0x6E,0x69,0x6B
	.DB  0x20,0x32,0x20,0x2D,0x20,0x77,0x79,0x70
	.DB  0x6F,0x7A,0x79,0x63,0x6A,0x6F,0x6E,0x6F
	.DB  0x77,0x61,0x6C,0x65,0x6D,0x0,0x41,0x6C
	.DB  0x61,0x72,0x6D,0x20,0x53,0x74,0x65,0x72
	.DB  0x6F,0x77,0x6E,0x69,0x6B,0x20,0x31,0x0
	.DB  0x41,0x6C,0x61,0x72,0x6D,0x20,0x53,0x74
	.DB  0x65,0x72,0x6F,0x77,0x6E,0x69,0x6B,0x20
	.DB  0x32,0x0,0x57,0x79,0x70,0x6F,0x7A,0x79
	.DB  0x63,0x6A,0x6F,0x6E,0x6F,0x77,0x61,0x6E
	.DB  0x6F,0x20,0x75,0x6B,0x6C,0x61,0x64,0x79
	.DB  0x20,0x6C,0x69,0x6E,0x69,0x6F,0x77,0x65
	.DB  0x20,0x58,0x59,0x5A,0x0,0x4B,0x6F,0x6C
	.DB  0x69,0x7A,0x6A,0x61,0x20,0x58,0x59,0x20
	.DB  0x75,0x6B,0x6C,0x61,0x64,0x75,0x20,0x6B
	.DB  0x72,0x61,0x7A,0x6B,0x61,0x0,0x4B,0x6F
	.DB  0x6C,0x69,0x7A,0x6A,0x61,0x20,0x58,0x59
	.DB  0x20,0x75,0x6B,0x6C,0x61,0x64,0x75,0x20
	.DB  0x73,0x7A,0x63,0x7A,0x6F,0x74,0x6B,0x69
	.DB  0x0,0x4B,0x6F,0x6C,0x69,0x7A,0x6A,0x61
	.DB  0x20,0x6B,0x72,0x61,0x7A,0x6B,0x61,0x20
	.DB  0x2D,0x20,0x77,0x79,0x6C,0x61,0x63,0x7A
	.DB  0x20,0x69,0x20,0x77,0x6C,0x61,0x63,0x7A
	.DB  0x20,0x6D,0x61,0x73,0x7A,0x79,0x6E,0x65
	.DB  0x0,0x4B,0x6F,0x6C,0x69,0x7A,0x6A,0x61
	.DB  0x20,0x73,0x7A,0x63,0x7A,0x2E,0x20,0x64
	.DB  0x72,0x75,0x63,0x69,0x61,0x6E,0x65,0x6A
	.DB  0x20,0x2D,0x20,0x77,0x79,0x6C,0x61,0x63
	.DB  0x7A,0x20,0x69,0x20,0x77,0x6C,0x61,0x63
	.DB  0x7A,0x20,0x6D,0x61,0x73,0x7A,0x79,0x6E
	.DB  0x65,0x0,0x57,0x79,0x6D,0x69,0x65,0x6E
	.DB  0x20,0x73,0x7A,0x63,0x7A,0x6F,0x74,0x6B
	.DB  0x65,0x20,0x64,0x72,0x75,0x63,0x69,0x61
	.DB  0x6E,0x61,0x0,0x57,0x79,0x6D,0x69,0x65
	.DB  0x6E,0x20,0x6B,0x72,0x61,0x7A,0x65,0x6B
	.DB  0x20,0x73,0x63,0x69,0x65,0x72,0x6E,0x79
	.DB  0x20,0x64,0x6F,0x20,0x6B,0x6F,0x72,0x70
	.DB  0x75,0x73,0x75,0x20,0x6F,0x20,0x73,0x72
	.DB  0x65,0x64,0x6E,0x69,0x63,0x79,0x20,0x33
	.DB  0x34,0x0,0x57,0x79,0x6D,0x69,0x65,0x6E
	.DB  0x20,0x6B,0x72,0x61,0x7A,0x65,0x6B,0x20
	.DB  0x73,0x63,0x69,0x65,0x72,0x6E,0x79,0x20
	.DB  0x64,0x6F,0x20,0x6B,0x6F,0x72,0x70,0x75
	.DB  0x73,0x75,0x20,0x6F,0x20,0x73,0x72,0x65
	.DB  0x64,0x6E,0x69,0x63,0x79,0x20,0x33,0x36
	.DB  0x0,0x57,0x79,0x6D,0x69,0x65,0x6E,0x20
	.DB  0x6B,0x72,0x61,0x7A,0x65,0x6B,0x20,0x73
	.DB  0x63,0x69,0x65,0x72,0x6E,0x79,0x20,0x64
	.DB  0x6F,0x20,0x6B,0x6F,0x72,0x70,0x75,0x73
	.DB  0x75,0x20,0x6F,0x20,0x73,0x72,0x65,0x64
	.DB  0x6E,0x69,0x63,0x79,0x20,0x33,0x38,0x0
	.DB  0x57,0x79,0x6D,0x69,0x65,0x6E,0x20,0x6B
	.DB  0x72,0x61,0x7A,0x65,0x6B,0x20,0x73,0x63
	.DB  0x69,0x65,0x72,0x6E,0x79,0x20,0x64,0x6F
	.DB  0x20,0x6B,0x6F,0x72,0x70,0x75,0x73,0x75
	.DB  0x20,0x6F,0x20,0x73,0x72,0x65,0x64,0x6E
	.DB  0x69,0x63,0x79,0x20,0x34,0x31,0x0,0x57
	.DB  0x79,0x6D,0x69,0x65,0x6E,0x20,0x6B,0x72
	.DB  0x61,0x7A,0x65,0x6B,0x20,0x73,0x63,0x69
	.DB  0x65,0x72,0x6E,0x79,0x20,0x64,0x6F,0x20
	.DB  0x6B,0x6F,0x72,0x70,0x75,0x73,0x75,0x20
	.DB  0x6F,0x20,0x73,0x72,0x65,0x64,0x6E,0x69
	.DB  0x63,0x79,0x20,0x34,0x33,0x0,0x57,0x63
	.DB  0x7A,0x79,0x74,0x61,0x6A,0x20,0x7A,0x61
	.DB  0x63,0x69,0x73,0x6B,0x20,0x74,0x65,0x6E
	.DB  0x20,0x73,0x61,0x6D,0x20,0x6C,0x75,0x62
	.DB  0x20,0x6E,0x6F,0x77,0x79,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

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
;Date    : 2018-08-31
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega128
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;#include <io.h>
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
;#define DATA_REGISTER_EMPTY (1<<UDRE0)
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
;
;
;#pragma warn-
;
;eeprom int szczotka_druciana_ilosc_cykli,krazek_scierny_ilosc_cykli,krazek_scierny_cykl_po_okregu_ilosc;
;//eeprom int czas_pracy_krazka_sciernego,czas_pracy_szczotki_drucianej;
;eeprom int czas_pracy_krazka_sciernego_h_34, czas_pracy_krazka_sciernego_h_36, czas_pracy_krazka_sciernego_h_38;
;eeprom int czas_pracy_krazka_sciernego_h_41, czas_pracy_krazka_sciernego_h_43;
;eeprom int czas_pracy_szczotki_drucianej_h;
;eeprom int czas_pracy_krazka_sciernego_stala,czas_pracy_szczotki_drucianej_stala;
;eeprom int tryb_pracy_szczotki_drucianej;
;
;#pragma warn+
;
;
;// Get a character from the USART1 Receiver
;#pragma used+
;char getchar1(void)
; 0000 0031 {

	.CSEG
; 0000 0032 unsigned char status;
; 0000 0033 char data;
; 0000 0034 while (1)
;	status -> R17
;	data -> R16
; 0000 0035       {
; 0000 0036       while (((status=UCSR1A) & RX_COMPLETE)==0);
; 0000 0037       data=UDR1;
; 0000 0038       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
; 0000 0039          return data;
; 0000 003A       }
; 0000 003B }
;#pragma used-
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 0041 {
; 0000 0042 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
; 0000 0043 UDR1=c;
; 0000 0044 }
;#pragma used-
;
;
;
;#include <mega128.h>
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
;#include <math.h>
;#include <stdio.h>
;
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=1
   .equ __scl_bit=0
; 0000 0055 #endasm
;#include <i2c.h>
;
;
;typedef union{
;   struct{
;      unsigned char b0:1;
;      unsigned char b1:1;
;      unsigned char b2:1;
;      unsigned char b3:1;
;      unsigned char b4:1;
;      unsigned char b5:1;
;      unsigned char b6:1;
;      unsigned char b7:1;
;   }bits;
;   unsigned char byte;
;}BB;
;
;
;typedef union{
;   struct{
;      unsigned char b0:1;
;      unsigned char b1:1;
;      unsigned char b2:1;
;      unsigned char b3:1;
;      unsigned char b4:1;
;      unsigned char b5:1;
;   }bits;
;   unsigned char byte;
;}CC;
;
;typedef union{
;   struct{
;      unsigned char b0:1;
;      unsigned char b1:1;
;      unsigned char b2:1;
;      unsigned char b3:1;
;      unsigned char b4:1;
;      unsigned char b5:1;
;      unsigned char b6:1;
;      unsigned char b7:1;
;   }bits;
;   unsigned char byte;
;}DD;
;
;
;
;
;
;BB PORT_F;
;BB PORTHH,PORT_CZYTNIK;
;BB PORTJJ,PORTKK,PORTLL,PORTMM;
;CC PORT_STER3,PORT_STER4;
;DD PORT_STER1,PORT_STER2;
;
;int xxx;
;int nr_zacisku,odczytalem_zacisk,il_prob_odczytu;
;int macierz_zaciskow[3];
;long int sek1,sek2,sek3,sek4,sek5,sek6,sek7,sek8,sek9,sek10,sek11,sek12,sek13,sek20;
;int czas_zatrzymania_na_dole;
;//int rzad;
;int start;
;int cykl;
;int aaa,bbb,ccc,ddd;
;int il_zaciskow_rzad_1,il_zaciskow_rzad_2;
;int cykl_sterownik_1,cykl_sterownik_3,cykl_sterownik_2,cykl_sterownik_4;
;int adr1,adr2,adr3,adr4;
;int cykl_sterownik_3_wykonalem;
;//int szczotka_druciana_ilosc_cykli;
;int szczotka_druc_cykl;
;int cykl_glowny;
;int start_kontynuacja;
;int ruch_zlozony;
;int krazek_scierny_cykl_po_okregu;
;//int krazek_scierny_cykl_po_okregu_ilosc;
;int krazek_scierny_cykl;
;//int krazek_scierny_ilosc_cykli;
;int cykl_ilosc_zaciskow;
;int wykonalem_komplet_okregow;
;int abs_ster3,abs_ster4;
;int koniec_rzedu_10;
;int rzad_obrabiany;
;int jestem_w_trakcie_czyszczenia_calosci;
;int wykonalem_rzedow;
;bit guzik1_przelaczania_zaciskow,guzik2_przelaczania_zaciskow;
;bit zmienna_przelaczanie_zaciskow;
;int czekaj_az_puszcze, czek1, czek2;
;int czas_przedmuchu;
;int a[10];
;int wymieniono_szczotke_druciana,wymieniono_krazek_scierny;
;int predkosc_pion_szczotka, predkosc_pion_krazek;
;int wejscie_krazka_sciernego_w_pow_boczna_cylindra;
;int predkosc_ruchow_po_okregu_krazek_scierny;
;int test_geometryczny_rzad_1, test_geometryczny_rzad_2;
;int czas_pracy_krazka_sciernego,czas_pracy_szczotki_drucianej;
;int powrot_przedwczesny_druciak;
;int powrot_przedwczesny_krazek_scierny;
;int czas_druciaka_na_gorze;
;int srednica_krazka_sciernego;
;int manualny_wybor_zacisku;
;int ruch_haos;
;int byla_wloczona_szlifierka_2,byla_wloczona_szlifierka_1;
;//int tryb_pracy_szczotki_drucianej; //bo juz eeprom
;int byl_wloczony_przedmuch,zastopowany_czas_przedmuchu;
;int cisnienie_sprawdzone;
;int odczytalem_w_trakcie_czyszczenia_drugiego_rzedu;
;int zaaktualizuj_ilosc_rzad2;
;int srednica_wew_korpusu;
;int srednica_wew_korpusu_cyklowa;
;
;char sprawdz_pin0(BB PORT, int numer_pcf)
; 0000 00C4 {
_sprawdz_pin0:
; 0000 00C5 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00C6 i2c_write(numer_pcf);
; 0000 00C7 PORT.byte = i2c_read(0);
; 0000 00C8 i2c_stop();
; 0000 00C9 
; 0000 00CA 
; 0000 00CB return PORT.bits.b0;
	RJMP _0x20A0004
; 0000 00CC }
;
;char sprawdz_pin1(BB PORT, int numer_pcf)
; 0000 00CF {
_sprawdz_pin1:
; 0000 00D0 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00D1 i2c_write(numer_pcf);
; 0000 00D2 PORT.byte = i2c_read(0);
; 0000 00D3 i2c_stop();
; 0000 00D4 
; 0000 00D5 
; 0000 00D6 return PORT.bits.b1;
	LSR  R30
	RJMP _0x20A0004
; 0000 00D7 }
;
;
;char sprawdz_pin2(BB PORT, int numer_pcf)
; 0000 00DB {
_sprawdz_pin2:
; 0000 00DC i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00DD i2c_write(numer_pcf);
; 0000 00DE PORT.byte = i2c_read(0);
; 0000 00DF i2c_stop();
; 0000 00E0 
; 0000 00E1 
; 0000 00E2 return PORT.bits.b2;
	LSR  R30
	LSR  R30
	RJMP _0x20A0004
; 0000 00E3 }
;
;char sprawdz_pin3(BB PORT, int numer_pcf)
; 0000 00E6 {
_sprawdz_pin3:
; 0000 00E7 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00E8 i2c_write(numer_pcf);
; 0000 00E9 PORT.byte = i2c_read(0);
; 0000 00EA i2c_stop();
; 0000 00EB 
; 0000 00EC 
; 0000 00ED return PORT.bits.b3;
	LSR  R30
	LSR  R30
	LSR  R30
	RJMP _0x20A0004
; 0000 00EE }
;
;char sprawdz_pin4(BB PORT, int numer_pcf)
; 0000 00F1 {
_sprawdz_pin4:
; 0000 00F2 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00F3 i2c_write(numer_pcf);
; 0000 00F4 PORT.byte = i2c_read(0);
; 0000 00F5 i2c_stop();
; 0000 00F6 
; 0000 00F7 
; 0000 00F8 return PORT.bits.b4;
	SWAP R30
	RJMP _0x20A0004
; 0000 00F9 }
;
;char sprawdz_pin5(BB PORT, int numer_pcf)
; 0000 00FC {
_sprawdz_pin5:
; 0000 00FD i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00FE i2c_write(numer_pcf);
; 0000 00FF PORT.byte = i2c_read(0);
; 0000 0100 i2c_stop();
; 0000 0101 
; 0000 0102 
; 0000 0103 return PORT.bits.b5;
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	RJMP _0x20A0004
; 0000 0104 }
;
;char sprawdz_pin6(BB PORT, int numer_pcf)
; 0000 0107 {
_sprawdz_pin6:
; 0000 0108 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0109 i2c_write(numer_pcf);
; 0000 010A PORT.byte = i2c_read(0);
; 0000 010B i2c_stop();
; 0000 010C 
; 0000 010D 
; 0000 010E return PORT.bits.b6;
	CALL SUBOPT_0x1
	RJMP _0x20A0004
; 0000 010F }
;
;char sprawdz_pin7(BB PORT, int numer_pcf)
; 0000 0112 {
_sprawdz_pin7:
; 0000 0113 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0114 i2c_write(numer_pcf);
; 0000 0115 PORT.byte = i2c_read(0);
; 0000 0116 i2c_stop();
; 0000 0117 
; 0000 0118 
; 0000 0119 return PORT.bits.b7;
	ROL  R30
	LDI  R30,0
	ROL  R30
_0x20A0004:
	ANDI R30,LOW(0x1)
	ADIW R28,3
	RET
; 0000 011A }
;
;int odczytaj_parametr(int adres1, int adres2)
; 0000 011D {
_odczytaj_parametr:
; 0000 011E int z;
; 0000 011F z = 0;
	CALL SUBOPT_0x2
;	adres1 -> Y+4
;	adres2 -> Y+2
;	z -> R16,R17
; 0000 0120 putchar(90);
	CALL SUBOPT_0x3
; 0000 0121 putchar(165);
; 0000 0122 putchar(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _putchar
; 0000 0123 putchar(131);
	LDI  R30,LOW(131)
	CALL SUBOPT_0x4
; 0000 0124 putchar(adres1);
; 0000 0125 putchar(adres2);
; 0000 0126 putchar(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar
; 0000 0127 getchar();
	CALL SUBOPT_0x5
; 0000 0128 getchar();
; 0000 0129 getchar();
; 0000 012A getchar();
	CALL SUBOPT_0x5
; 0000 012B getchar();
; 0000 012C getchar();
; 0000 012D getchar();
	CALL SUBOPT_0x5
; 0000 012E getchar();
; 0000 012F z = getchar();
	MOV  R16,R30
	CLR  R17
; 0000 0130 
; 0000 0131 
; 0000 0132 
; 0000 0133 
; 0000 0134 
; 0000 0135 
; 0000 0136 
; 0000 0137 
; 0000 0138 
; 0000 0139 
; 0000 013A 
; 0000 013B 
; 0000 013C return z;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0003
; 0000 013D }
;
;
;
;int czekaj_na_guzik_start(int adres)
; 0000 0142 {
; 0000 0143 //48 to adres zmiennej 30
; 0000 0144 //16 to adres zmiennj 10
; 0000 0145 
; 0000 0146 int z;
; 0000 0147 z = 0;
;	adres -> Y+2
;	z -> R16,R17
; 0000 0148 putchar(90);
; 0000 0149 putchar(165);
; 0000 014A putchar(4);
; 0000 014B putchar(131);
; 0000 014C putchar(0);
; 0000 014D putchar(adres);  //adres zmiennej - 30
; 0000 014E putchar(1);
; 0000 014F getchar();
; 0000 0150 getchar();
; 0000 0151 getchar();
; 0000 0152 getchar();
; 0000 0153 getchar();
; 0000 0154 getchar();
; 0000 0155 getchar();
; 0000 0156 getchar();
; 0000 0157 z = getchar();
; 0000 0158 //itoa(z,dupa1);
; 0000 0159 //lcd_puts(dupa1);
; 0000 015A 
; 0000 015B return z;
; 0000 015C }
;
;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0163 {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0164 // Place your code here
; 0000 0165 //16,384 ms
; 0000 0166 sek1++;     //Ster 1
	LDI  R26,LOW(_sek1)
	LDI  R27,HIGH(_sek1)
	CALL SUBOPT_0x6
; 0000 0167 sek2++;     //ster 3
	LDI  R26,LOW(_sek2)
	LDI  R27,HIGH(_sek2)
	CALL SUBOPT_0x6
; 0000 0168 
; 0000 0169 
; 0000 016A sek3++;     //ster 2
	LDI  R26,LOW(_sek3)
	LDI  R27,HIGH(_sek3)
	CALL SUBOPT_0x6
; 0000 016B sek4++;     //ster 4
	LDI  R26,LOW(_sek4)
	LDI  R27,HIGH(_sek4)
	CALL SUBOPT_0x6
; 0000 016C 
; 0000 016D 
; 0000 016E //sek10++;
; 0000 016F 
; 0000 0170 sek11++;  //do wyboru zacisku
	LDI  R26,LOW(_sek11)
	LDI  R27,HIGH(_sek11)
	CALL SUBOPT_0x6
; 0000 0171 sek12++;  //do czasu przedmuchu
	LDI  R26,LOW(_sek12)
	LDI  R27,HIGH(_sek12)
	CALL SUBOPT_0x6
; 0000 0172 
; 0000 0173 sek13++;  //do czasu zatrzymania sie druciaka na gorze
	LDI  R26,LOW(_sek13)
	LDI  R27,HIGH(_sek13)
	CALL SUBOPT_0x6
; 0000 0174 
; 0000 0175 sek20++;
	LDI  R26,LOW(_sek20)
	LDI  R27,HIGH(_sek20)
	CALL SUBOPT_0x6
; 0000 0176 /*
; 0000 0177 if(PORTE.3 == 1)
; 0000 0178       {
; 0000 0179       czas_pracy_szczotki_drucianej++;
; 0000 017A       czas_pracy_krazka_sciernego++;
; 0000 017B       if(czas_pracy_szczotki_drucianej == 61 * 60 * 60)
; 0000 017C             {
; 0000 017D             czas_pracy_szczotki_drucianej = 0;
; 0000 017E             czas_pracy_szczotki_drucianej_h++;
; 0000 017F             }
; 0000 0180       if(czas_pracy_krazka_sciernego == 61 * 60 * 60)
; 0000 0181             {
; 0000 0182             czas_pracy_krazka_sciernego = 0;
; 0000 0183             czas_pracy_krazka_sciernego_h++;
; 0000 0184             }
; 0000 0185       }
; 0000 0186 
; 0000 0187 
; 0000 0188       //61 razy - 1s
; 0000 0189       //61 * 60 - 1 minuta
; 0000 018A       //61 * 60 * 60 - 1h
; 0000 018B 
; 0000 018C */
; 0000 018D 
; 0000 018E }
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
;
;
;
;
;// Declare your global variables here
;
;void komunikat_na_panel(char flash *fmtstr,int adres2,int adres22)
; 0000 0197 {
_komunikat_na_panel:
; 0000 0198 int h;
; 0000 0199 
; 0000 019A h = 0;
	CALL SUBOPT_0x2
;	*fmtstr -> Y+6
;	adres2 -> Y+4
;	adres22 -> Y+2
;	h -> R16,R17
; 0000 019B h = strlenf(fmtstr);
	CALL SUBOPT_0x7
	CALL _strlenf
	MOVW R16,R30
; 0000 019C h = h + 3;
	__ADDWRN 16,17,3
; 0000 019D 
; 0000 019E putchar(90);
	CALL SUBOPT_0x3
; 0000 019F putchar(165);
; 0000 01A0 putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL _putchar
; 0000 01A1 putchar(130);  //82
	LDI  R30,LOW(130)
	CALL SUBOPT_0x4
; 0000 01A2 putchar(adres2);    //
; 0000 01A3 putchar(adres22);  //
; 0000 01A4 printf(fmtstr);
	CALL SUBOPT_0x7
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 01A5 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;
;
;
;void wartosc_parametru_panelu(int wartosc, int adres1, int adres2)
; 0000 01AA {
_wartosc_parametru_panelu:
; 0000 01AB putchar(90);  //5A
;	wartosc -> Y+4
;	adres1 -> Y+2
;	adres2 -> Y+0
	CALL SUBOPT_0x3
; 0000 01AC putchar(165); //A5
; 0000 01AD putchar(5);//05
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 01AE putchar(130);  //82    /
; 0000 01AF putchar(adres1);    //00
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
; 0000 01B0 putchar(adres2);   //40
	LD   R30,Y
	ST   -Y,R30
	CALL _putchar
; 0000 01B1 putchar(0);    //00
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
; 0000 01B2 putchar(wartosc);   //80
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _putchar
; 0000 01B3 }
_0x20A0003:
	ADIW R28,6
	RET
;
;
;void zaktualizuj_parametry_panelu()
; 0000 01B7 {
_zaktualizuj_parametry_panelu:
; 0000 01B8 
; 0000 01B9 /////////////////////////
; 0000 01BA wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
	CALL SUBOPT_0x9
; 0000 01BB 
; 0000 01BC wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
; 0000 01BD 
; 0000 01BE wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
; 0000 01BF 
; 0000 01C0 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
; 0000 01C1 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
; 0000 01C2 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
; 0000 01C3 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
; 0000 01C4 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	CALL SUBOPT_0xB
; 0000 01C5 
; 0000 01C6 //////////////////////////
; 0000 01C7 
; 0000 01C8 
; 0000 01C9 
; 0000 01CA 
; 0000 01CB if(zaaktualizuj_ilosc_rzad2 == 1)
	LDS  R26,_zaaktualizuj_ilosc_rzad2
	LDS  R27,_zaaktualizuj_ilosc_rzad2+1
	SBIW R26,1
	BRNE _0xD
; 0000 01CC     {
; 0000 01CD     wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad2
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
; 0000 01CE     zaaktualizuj_ilosc_rzad2 = 0;
	LDI  R30,LOW(0)
	STS  _zaaktualizuj_ilosc_rzad2,R30
	STS  _zaaktualizuj_ilosc_rzad2+1,R30
; 0000 01CF     }
; 0000 01D0 }
_0xD:
	RET
;
;void komunikat_z_czytnika_kodow(char flash *fmtstr,int rzad, int na_plus_minus)
; 0000 01D3 {
_komunikat_z_czytnika_kodow:
; 0000 01D4 //na_plus_minus = 1;  to jest na plus
; 0000 01D5 //na_plus_minus = 0;  to jest na minus
; 0000 01D6 
; 0000 01D7 int h, adres1,adres11,adres2,adres22;
; 0000 01D8 
; 0000 01D9 h = 0;
	SBIW R28,4
	CALL __SAVELOCR6
;	*fmtstr -> Y+14
;	rzad -> Y+12
;	na_plus_minus -> Y+10
;	h -> R16,R17
;	adres1 -> R18,R19
;	adres11 -> R20,R21
;	adres2 -> Y+8
;	adres22 -> Y+6
	__GETWRN 16,17,0
; 0000 01DA h = strlenf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOVW R16,R30
; 0000 01DB h = h + 3;
	__ADDWRN 16,17,3
; 0000 01DC 
; 0000 01DD if(rzad == 1)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BRNE _0xE
; 0000 01DE    {
; 0000 01DF    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01E0    adres11 = 80;
	__GETWRN 20,21,80
; 0000 01E1    adres2 = 80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01E2    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01E3    }
; 0000 01E4 if(rzad == 2)
_0xE:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,2
	BRNE _0xF
; 0000 01E5    {
; 0000 01E6    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01E7    adres11 = 32;
	__GETWRN 20,21,32
; 0000 01E8    adres2 = 64;
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01E9    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01EA    }
; 0000 01EB 
; 0000 01EC putchar(90);
_0xF:
	CALL SUBOPT_0x3
; 0000 01ED putchar(165);
; 0000 01EE putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL SUBOPT_0x8
; 0000 01EF putchar(130);  //82
; 0000 01F0 putchar(adres1);    //
	ST   -Y,R18
	CALL _putchar
; 0000 01F1 putchar(adres11);  //
	ST   -Y,R20
	CALL _putchar
; 0000 01F2 printf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 01F3 
; 0000 01F4 
; 0000 01F5 if(rzad == 1 & macierz_zaciskow[rzad]==0)
	CALL SUBOPT_0x10
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0x11
	CALL __GETW1P
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x10
; 0000 01F6     {
; 0000 01F7     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x12
; 0000 01F8     komunikat_na_panel("Zacisk nie zmierzony u Wykonawcy",adres2,adres22);
	__POINTW1FN _0x0,49
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
; 0000 01F9     }
; 0000 01FA 
; 0000 01FB if(rzad == 1 & na_plus_minus == 1)
_0x10:
	CALL SUBOPT_0x10
	CALL SUBOPT_0x15
	BREQ _0x11
; 0000 01FC     {
; 0000 01FD     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x12
; 0000 01FE     //komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
; 0000 01FF     komunikat_na_panel("Kly w kierunku prawej strony",adres2,adres22);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
; 0000 0200     }
; 0000 0201 
; 0000 0202 if(rzad == 1 & na_plus_minus == 0)
_0x11:
	CALL SUBOPT_0x10
	CALL SUBOPT_0x16
	BREQ _0x12
; 0000 0203     {
; 0000 0204     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x12
; 0000 0205     //komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
; 0000 0206     komunikat_na_panel("Kly w kierunku lewej strony",adres2,adres22);
	__POINTW1FN _0x0,111
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
; 0000 0207     }
; 0000 0208 
; 0000 0209 
; 0000 020A if(rzad == 2 & na_plus_minus == 1)
_0x12:
	CALL SUBOPT_0x17
	CALL SUBOPT_0x15
	BREQ _0x13
; 0000 020B     {
; 0000 020C     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x12
; 0000 020D     //komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
; 0000 020E     komunikat_na_panel("Kly w kierunku lewej strony",adres2,adres22);
	__POINTW1FN _0x0,111
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
; 0000 020F     }
; 0000 0210 
; 0000 0211 if(rzad == 2 & na_plus_minus == 0)
_0x13:
	CALL SUBOPT_0x17
	CALL SUBOPT_0x16
	BREQ _0x14
; 0000 0212     {
; 0000 0213     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x12
; 0000 0214     //komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
; 0000 0215     komunikat_na_panel("Kly w kierunku prawej strony",adres2,adres22);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
; 0000 0216     }
; 0000 0217 
; 0000 0218 
; 0000 0219 }
_0x14:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;
;void zerowanie_pam_wew()
; 0000 021C {
; 0000 021D /*
; 0000 021E if(czas_pracy_szczotki_drucianej_h >= 255 | czas_pracy_krazka_sciernego_h >=255 | czas_pracy_krazka_sciernego_stala >= 255 | czas_pracy_szczotki_drucianej_stala >= 255 |
; 0000 021F    szczotka_druciana_ilosc_cykli >= 255 | krazek_scierny_ilosc_cykli >= 255 | krazek_scierny_cykl_po_okregu_ilosc >=255)
; 0000 0220      {
; 0000 0221      czas_pracy_szczotki_drucianej_h = 0;
; 0000 0222      czas_pracy_szczotki_drucianej = 0;
; 0000 0223      czas_pracy_krazka_sciernego_h = 0;
; 0000 0224      czas_pracy_krazka_sciernego = 0;
; 0000 0225      czas_pracy_krazka_sciernego_stala = 5;
; 0000 0226      czas_pracy_szczotki_drucianej_stala = 5;
; 0000 0227      szczotka_druciana_ilosc_cykli = 3;
; 0000 0228      krazek_scierny_ilosc_cykli = 3;
; 0000 0229      krazek_scierny_cykl_po_okregu_ilosc = 3;
; 0000 022A      }
; 0000 022B */
; 0000 022C 
; 0000 022D /*
; 0000 022E if(czas_pracy_krazka_sciernego_h >= 255)
; 0000 022F      {
; 0000 0230      czas_pracy_krazka_sciernego_h = 0;
; 0000 0231      czas_pracy_krazka_sciernego = 0;
; 0000 0232      }
; 0000 0233 if(czas_pracy_krazka_sciernego_stala >= 255)
; 0000 0234      czas_pracy_krazka_sciernego_stala = 5;
; 0000 0235 
; 0000 0236 if(czas_pracy_szczotki_drucianej_stala >= 255)
; 0000 0237      czas_pracy_szczotki_drucianej_stala = 5;
; 0000 0238 
; 0000 0239 if(szczotka_druciana_ilosc_cykli >= 255)
; 0000 023A 
; 0000 023B if(krazek_scierny_ilosc_cykli >= 255)
; 0000 023C 
; 0000 023D if(krazek_scierny_cykl_po_okregu_ilosc >=255)
; 0000 023E */
; 0000 023F 
; 0000 0240 }
;
;
;void odpytaj_parametry_panelu()
; 0000 0244 {
_odpytaj_parametry_panelu:
; 0000 0245 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	POP  R26
	AND  R30,R26
	BREQ _0x15
; 0000 0246     start = odczytaj_parametr(0,64);
	CALL SUBOPT_0xE
	CALL SUBOPT_0x1B
	STS  _start,R30
	STS  _start+1,R31
; 0000 0247 il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
_0x15:
	CALL SUBOPT_0xE
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
; 0000 0248 il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
; 0000 0249 
; 0000 024A szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
	CALL SUBOPT_0x1B
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL SUBOPT_0x20
; 0000 024B                                                 //2090
; 0000 024C krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
; 0000 024D                                                     //3000
; 0000 024E krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
	CALL SUBOPT_0xE
	CALL SUBOPT_0x23
; 0000 024F 
; 0000 0250 //////////////////////////////////////////////
; 0000 0251 czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0xD
	CALL SUBOPT_0x24
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL SUBOPT_0x20
; 0000 0252 
; 0000 0253 czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x24
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_stala)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_stala)
	CALL __EEPROMWRW
; 0000 0254 
; 0000 0255 //czas_pracy_szczotki_drucianej_h = odczytaj_parametr(0,144);
; 0000 0256 
; 0000 0257 //czas_pracy_krazka_sciernego_h_34 = odczytaj_parametr(96,48);
; 0000 0258 //czas_pracy_krazka_sciernego_h_36 = odczytaj_parametr(96,64);
; 0000 0259 //czas_pracy_krazka_sciernego_h_38 = odczytaj_parametr(96,80);
; 0000 025A //czas_pracy_krazka_sciernego_h_41 = odczytaj_parametr(96,96);
; 0000 025B //czas_pracy_krazka_sciernego_h_43 = odczytaj_parametr(96,112);
; 0000 025C 
; 0000 025D //////////////////////////////////////////////////////////
; 0000 025E 
; 0000 025F test_geometryczny_rzad_1 = odczytaj_parametr(48,80);
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x25
	STS  _test_geometryczny_rzad_1,R30
	STS  _test_geometryczny_rzad_1+1,R31
; 0000 0260 
; 0000 0261 test_geometryczny_rzad_2 = odczytaj_parametr(48,96);
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0xA
	CALL SUBOPT_0x24
	STS  _test_geometryczny_rzad_2,R30
	STS  _test_geometryczny_rzad_2+1,R31
; 0000 0262 
; 0000 0263 srednica_krazka_sciernego = odczytaj_parametr(48,112);
	CALL SUBOPT_0x26
	CALL SUBOPT_0x24
	CALL SUBOPT_0x27
; 0000 0264 
; 0000 0265 ruch_haos = odczytaj_parametr(48,144);
	CALL SUBOPT_0x21
	STS  _ruch_haos,R30
	STS  _ruch_haos+1,R31
; 0000 0266 
; 0000 0267 tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0x28
	CALL SUBOPT_0x24
	LDI  R26,LOW(_tryb_pracy_szczotki_drucianej)
	LDI  R27,HIGH(_tryb_pracy_szczotki_drucianej)
	CALL __EEPROMWRW
; 0000 0268                                                 //2050
; 0000 0269 //zerowanie_pam_wew();
; 0000 026A 
; 0000 026B }
	RET
;
;void wyrrrjscia_i_wejscia_opis()
; 0000 026E {
; 0000 026F 
; 0000 0270 
; 0000 0271 //IN0
; 0000 0272 
; 0000 0273 //komunikacja miedzy slave a master
; 0000 0274 //sprawdz_pin0(PORTHH,0x73)
; 0000 0275 //sprawdz_pin1(PORTHH,0x73)
; 0000 0276 //sprawdz_pin2(PORTHH,0x73)
; 0000 0277 //sprawdz_pin3(PORTHH,0x73)
; 0000 0278 //sprawdz_pin4(PORTHH,0x73)
; 0000 0279 //sprawdz_pin5(PORTHH,0x73)
; 0000 027A //sprawdz_pin6(PORTHH,0x73)
; 0000 027B //sprawdz_pin7(PORTHH,0x73)
; 0000 027C 
; 0000 027D //IN1
; 0000 027E //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 027F //sprawdz_pin1(PORTJJ,0x79)  AREA   STEROWNIK1
; 0000 0280 //sprawdz_pin2(PORTJJ,0x79)  SETON  STEROWNIK1
; 0000 0281 //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 0282 //sprawdz_pin4(PORTJJ,0x79)  SVRE   STEROWNIK1
; 0000 0283 //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 0284 //sprawdz_pin6(PORTJJ,0x79)  czujnik cisnienia
; 0000 0285 //sprawdz_pin7(PORTJJ,0x79)
; 0000 0286 
; 0000 0287 //IN2
; 0000 0288 //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 0289 //sprawdz_pin1(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK3
; 0000 028A //sprawdz_pin2(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK3
; 0000 028B //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 028C //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 028D //sprawdz_pin5(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK4
; 0000 028E //sprawdz_pin6(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK4
; 0000 028F //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 0290 
; 0000 0291 //IN3
; 0000 0292 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 0293 //sprawdz_pin1(PORTLL,0x71)  AREA   STEROWNIK2
; 0000 0294 //sprawdz_pin2(PORTLL,0x71)  SETON  STEROWNIK2
; 0000 0295 //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 0296 //sprawdz_pin4(PORTLL,0x71)  SVRE   STEROWNIK2
; 0000 0297 //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 0298 //sprawdz_pin6(PORTLL,0x71)  S6A przek³adanie rzedow
; 0000 0299 //sprawdz_pin7(PORTLL,0x71)  S6B przekladanie rzedow
; 0000 029A 
; 0000 029B //IN4
; 0000 029C //sprawdz_pin0(PORTMM,0x77) J2  czujnik indukcyjny domkniecia pokrywy
; 0000 029D //sprawdz_pin1(PORTMM,0x77) J3  czujnik indukcyjny domkniecia pokrywy
; 0000 029E //sprawdz_pin2(PORTMM,0x77)
; 0000 029F //sprawdz_pin3(PORTMM,0x77)
; 0000 02A0 //sprawdz_pin4(PORTMM,0x77)
; 0000 02A1 //sprawdz_pin5(PORTMM,0x77)
; 0000 02A2 //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 02A3 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 02A4 
; 0000 02A5 //sterownik 1 i sterownik 3 - krazek scierny
; 0000 02A6 //sterownik 2 i sterownik 4 - druciak
; 0000 02A7 
; 0000 02A8 //OUT
; 0000 02A9 //PORTA.0   IN0  STEROWNIK1        OUT 1
; 0000 02AA //PORTA.1   IN1  STEROWNIK1
; 0000 02AB //PORTA.2   IN2  STEROWNIK1
; 0000 02AC //PORTA.3   IN3  STEROWNIK1
; 0000 02AD //PORTA.4   IN4  STEROWNIK1
; 0000 02AE //PORTA.5   IN5  STEROWNIK1
; 0000 02AF //PORTA.6   IN6  STEROWNIK1
; 0000 02B0 //PORTA.7   IN7  STEROWNIK1
; 0000 02B1 
; 0000 02B2 //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 02B3 //PORTB.1   IN1  STEROWNIK4
; 0000 02B4 //PORTB.2   IN2  STEROWNIK4
; 0000 02B5 //PORTB.3   IN3  STEROWNIK4
; 0000 02B6 //PORTB.4   4B CEWKA przedmuch osi, byl, juz poloczone z B.6, teraz juz setup poziome
; 0000 02B7 //PORTB.5   DRIVE  STEROWNIK4
; 0000 02B8 //PORTB.6   swiatlo zielone
; 0000 02B9 //PORTB.7   IN5 STEROWNIK 3
; 0000 02BA 
; 0000 02BB //PORTC.0   IN0  STEROWNIK2        OUT 3
; 0000 02BC //PORTC.1   IN1  STEROWNIK2
; 0000 02BD //PORTC.2   IN2  STEROWNIK2
; 0000 02BE //PORTC.3   IN3  STEROWNIK2
; 0000 02BF //PORTC.4   IN4  STEROWNIK2
; 0000 02C0 //PORTC.5   IN5  STEROWNIK2
; 0000 02C1 //PORTC.6   IN6  STEROWNIK2
; 0000 02C2 //PORTC.7   IN7  STEROWNIK2
; 0000 02C3 
; 0000 02C4 //PORTD.0  SDA                     OUT 2
; 0000 02C5 //PORTD.1  SCL
; 0000 02C6 //PORTD.2  SETUP   STEROWNIK1 STEROWNIK 2 STEROIWNIK 3 STEROWNIK 4
; 0000 02C7 //PORTD.3  DRIVE   STEROWNIK1
; 0000 02C8 //PORTD.4  IN8 STEROWNIK1
; 0000 02C9 //PORTD.5  IN8 STEROWNIK2
; 0000 02CA //PORTD.6  DRIVE   STEROWNIK2
; 0000 02CB //PORTD.7  swiatlo czerwone i jednoczesnie HOLD
; 0000 02CC 
; 0000 02CD //PORTE.0
; 0000 02CE //PORTE.1
; 0000 02CF //PORTE.2  1A CEWKA szczotka druciana                    OUT 6
; 0000 02D0 //PORTE.3  1B CEWKA krazek scierny
; 0000 02D1 //PORTE.4  IN4  STEROWNIK4
; 0000 02D2 //PORTE.5  IN5  STEROWNIK4   ///////////////////////////////////////////////teraz tu bêdzie przedmuch kana³ B
; 0000 02D3 //PORTE.6  2A CEWKA przerzucanie docisku zaciskow
; 0000 02D4 //PORTE.7  3A CEWKA zacisnij zaciski
; 0000 02D5 
; 0000 02D6 //PORTF.0   IN0  STEROWNIK3             OUT 4
; 0000 02D7 //PORTF.1   IN1  STEROWNIK3
; 0000 02D8 //PORTF.2   IN2  STEROWNIK3
; 0000 02D9 //PORTF.3   IN3  STEROWNIK3
; 0000 02DA //PORTF.4   4A CEWKA przedmuch zaciskow
; 0000 02DB //PORTF.5   DRIVE  STEROWNIK3
; 0000 02DC //PORTF.6   swiatlo zolte
; 0000 02DD //PORTF.7   IN4 STEROWNIK 3
; 0000 02DE 
; 0000 02DF 
; 0000 02E0 
; 0000 02E1  //PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 02E2 //PORTF = PORT_F.byte;
; 0000 02E3 //PORTB.6 = 1;  //przedmuch osi
; 0000 02E4 //PORTE.2 = 1;  //szlifierka 1
; 0000 02E5 //PORTE.3 = 1;  //szlifierka 2
; 0000 02E6 //PORTE.6 = 0;  //zacisniety rzad 1
; 0000 02E7 //PORTE.6 = 1;  //zacisniety rzad 2
; 0000 02E8 //PORTE.7 = 0;    //zacisnij zaciski
; 0000 02E9 
; 0000 02EA 
; 0000 02EB //macierz_zaciskow[rzad]=44; brak
; 0000 02EC //macierz_zaciskow[rzad]=48; brak
; 0000 02ED //macierz_zaciskow[rzad]=76  brak
; 0000 02EE //macierz_zaciskow[rzad]=80; brak
; 0000 02EF //macierz_zaciskow[rzad]=92; brak
; 0000 02F0 //macierz_zaciskow[rzad]=96;  brak
; 0000 02F1 //macierz_zaciskow[rzad]=107; brak
; 0000 02F2 //macierz_zaciskow[rzad]=111; brak
; 0000 02F3 
; 0000 02F4 
; 0000 02F5 
; 0000 02F6 
; 0000 02F7 /*
; 0000 02F8 
; 0000 02F9 //testy parzystych i nieparzystych IN0-IN8
; 0000 02FA //testy port/pin
; 0000 02FB //sterownik 3
; 0000 02FC //PORTF.0   IN0  STEROWNIK3
; 0000 02FD //PORTF.1   IN1  STEROWNIK3
; 0000 02FE //PORTF.2   IN2  STEROWNIK3
; 0000 02FF //PORTF.3   IN3  STEROWNIK3
; 0000 0300 //PORTF.7   IN4 STEROWNIK 3
; 0000 0301 //PORTB.7   IN5 STEROWNIK 3
; 0000 0302 
; 0000 0303 
; 0000 0304 PORT_F.bits.b0 = 0;
; 0000 0305 PORT_F.bits.b1 = 1;
; 0000 0306 PORT_F.bits.b2 = 0;
; 0000 0307 PORT_F.bits.b3 = 1;
; 0000 0308 PORT_F.bits.b7 = 0;
; 0000 0309 PORTF = PORT_F.byte;
; 0000 030A PORTB.7 = 1;
; 0000 030B 
; 0000 030C //sterownik 4
; 0000 030D 
; 0000 030E //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 030F //PORTB.1   IN1  STEROWNIK4
; 0000 0310 //PORTB.2   IN2  STEROWNIK4
; 0000 0311 //PORTB.3   IN3  STEROWNIK4
; 0000 0312 //PORTE.4  IN4  STEROWNIK4
; 0000 0313 
; 0000 0314 
; 0000 0315 PORTB.0 = 0;
; 0000 0316 PORTB.1 = 1;
; 0000 0317 PORTB.2 = 0;
; 0000 0318 PORTB.3 = 1;
; 0000 0319 PORTE.4 = 0;
; 0000 031A 
; 0000 031B 
; 0000 031C //ster 1
; 0000 031D PORTA.0 = 0;   //IN0  STEROWNIK1        OUT 1
; 0000 031E PORTA.1 = 1;  //IN1  STEROWNIK1
; 0000 031F PORTA.2 = 0;  // IN2  STEROWNIK1
; 0000 0320 PORTA.3 = 1;  //IN3  STEROWNIK1
; 0000 0321 PORTA.4 = 0;  // IN4  STEROWNIK1
; 0000 0322 PORTA.5 = 1;  //IN5  STEROWNIK1
; 0000 0323 PORTA.6 = 0;   //IN6  STEROWNIK1
; 0000 0324 PORTA.7 = 1;  //IN7  STEROWNIK1
; 0000 0325 PORTD.4 = 0; //IN8 STEROWNIK1
; 0000 0326 
; 0000 0327 
; 0000 0328 
; 0000 0329 //sterownik 2
; 0000 032A PORTC.0 = 0;   //IN0  STEROWNIK2        OUT 3
; 0000 032B PORTC.1  = 1;  //IN1  STEROWNIK2
; 0000 032C PORTC.2 = 0;    //IN2  STEROWNIK2
; 0000 032D PORTC.3= 1;   //IN3  STEROWNIK2
; 0000 032E PORTC.4 = 0;   // IN4  STEROWNIK2
; 0000 032F PORTC.5= 1;   //IN5  STEROWNIK2
; 0000 0330 PORTC.6 = 0;   // IN6  STEROWNIK2
; 0000 0331 PORTC.7= 1;   //IN7  STEROWNIK2
; 0000 0332 PORTD.5 = 0;  //IN8 STEROWNIK2
; 0000 0333 
; 0000 0334 */
; 0000 0335 
; 0000 0336 }
;
;void sprawdz_cisnienie()
; 0000 0339 {
_sprawdz_cisnienie:
; 0000 033A int i;
; 0000 033B i = 0;
	CALL SUBOPT_0x2
;	i -> R16,R17
; 0000 033C //i = 1;
; 0000 033D 
; 0000 033E while(i == 0)
_0x16:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x18
; 0000 033F     {
; 0000 0340     if(sprawdz_pin6(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x29
	RCALL _sprawdz_pin6
	CPI  R30,0
	BRNE _0x19
; 0000 0341         {
; 0000 0342         i = 1;
	__GETWRN 16,17,1
; 0000 0343         if(cisnienie_sprawdzone == 0)
	LDS  R30,_cisnienie_sprawdzone
	LDS  R31,_cisnienie_sprawdzone+1
	SBIW R30,0
	BRNE _0x1A
; 0000 0344             {
; 0000 0345             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 0346             cisnienie_sprawdzone = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cisnienie_sprawdzone,R30
	STS  _cisnienie_sprawdzone+1,R31
; 0000 0347             }
; 0000 0348 
; 0000 0349         }
_0x1A:
; 0000 034A     else
	RJMP _0x1B
_0x19:
; 0000 034B         {
; 0000 034C         i = 0;
	__GETWRN 16,17,0
; 0000 034D         cisnienie_sprawdzone = 0;
	LDI  R30,LOW(0)
	STS  _cisnienie_sprawdzone,R30
	STS  _cisnienie_sprawdzone+1,R30
; 0000 034E         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 034F         komunikat_na_panel("Cisnienie za male - mniejsze niz 6 bar",adr1,adr2);
	__POINTW1FN _0x0,139
	CALL SUBOPT_0x2B
; 0000 0350 
; 0000 0351         }
_0x1B:
; 0000 0352     }
	RJMP _0x16
_0x18:
; 0000 0353 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;int odczyt_wybranego_zacisku()
; 0000 0357 {                         //11
_odczyt_wybranego_zacisku:
; 0000 0358 int rzad;
; 0000 0359 
; 0000 035A PORT_CZYTNIK.bits.b0 = sprawdz_pin0(PORTHH,0x73);
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	CALL SUBOPT_0x2C
	RCALL _sprawdz_pin0
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFE
	CALL SUBOPT_0x2D
; 0000 035B PORT_CZYTNIK.bits.b1 = sprawdz_pin1(PORTHH,0x73);
	RCALL _sprawdz_pin1
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFD
	CALL SUBOPT_0x2D
; 0000 035C PORT_CZYTNIK.bits.b2 = sprawdz_pin2(PORTHH,0x73);
	RCALL _sprawdz_pin2
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFB
	CALL SUBOPT_0x2D
; 0000 035D PORT_CZYTNIK.bits.b3 = sprawdz_pin3(PORTHH,0x73);
	RCALL _sprawdz_pin3
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0XF7
	CALL SUBOPT_0x2D
; 0000 035E PORT_CZYTNIK.bits.b4 = sprawdz_pin4(PORTHH,0x73);
	RCALL _sprawdz_pin4
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xEF
	CALL SUBOPT_0x2D
; 0000 035F PORT_CZYTNIK.bits.b5 = sprawdz_pin5(PORTHH,0x73);
	RCALL _sprawdz_pin5
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xDF
	CALL SUBOPT_0x2D
; 0000 0360 PORT_CZYTNIK.bits.b6 = sprawdz_pin6(PORTHH,0x73);
	RCALL _sprawdz_pin6
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xBF
	CALL SUBOPT_0x2D
; 0000 0361 PORT_CZYTNIK.bits.b7 = sprawdz_pin7(PORTHH,0x73);
	RCALL _sprawdz_pin7
	ANDI R30,LOW(0x1)
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0x7F
	OR   R30,R0
	STS  _PORT_CZYTNIK,R30
; 0000 0362 
; 0000 0363 rzad = odczytaj_parametr(32,128);       //20,80
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x1C
	MOVW R16,R30
; 0000 0364 
; 0000 0365 if(PORT_CZYTNIK.byte == 0x01)
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1)
	BRNE _0x1C
; 0000 0366     {
; 0000 0367     macierz_zaciskow[rzad]=1;
	MOVW R30,R16
	CALL SUBOPT_0x11
	CALL SUBOPT_0x2F
; 0000 0368     komunikat_z_czytnika_kodow("86-0170",rzad,1);
	__POINTW1FN _0x0,178
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0369     /////////////
; 0000 036A     srednica_wew_korpusu = 38;  //to tylko proba, nie wiem ile on ma
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
; 0000 036B     }
; 0000 036C 
; 0000 036D if(PORT_CZYTNIK.byte == 0x02)
_0x1C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2)
	BRNE _0x1D
; 0000 036E     {
; 0000 036F     macierz_zaciskow[rzad]=2;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
; 0000 0370     komunikat_z_czytnika_kodow("86-1043",rzad,0);
	__POINTW1FN _0x0,186
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0371 
; 0000 0372     }
; 0000 0373 
; 0000 0374 if(PORT_CZYTNIK.byte == 0x03)
_0x1D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3)
	BRNE _0x1E
; 0000 0375     {
; 0000 0376       macierz_zaciskow[rzad]=3;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   X+,R30
	ST   X,R31
; 0000 0377       komunikat_z_czytnika_kodow("86-1675",rzad,0);
	__POINTW1FN _0x0,194
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0378     }
; 0000 0379 
; 0000 037A if(PORT_CZYTNIK.byte == 0x04)
_0x1E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4)
	BRNE _0x1F
; 0000 037B     {
; 0000 037C 
; 0000 037D       macierz_zaciskow[rzad]=4;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   X+,R30
	ST   X,R31
; 0000 037E       komunikat_z_czytnika_kodow("86-2098",rzad,0);
	__POINTW1FN _0x0,202
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 037F 
; 0000 0380     }
; 0000 0381 if(PORT_CZYTNIK.byte == 0x05)
_0x1F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5)
	BRNE _0x20
; 0000 0382     {
; 0000 0383       macierz_zaciskow[rzad]=5;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   X+,R30
	ST   X,R31
; 0000 0384       komunikat_z_czytnika_kodow("87-0170",rzad,0);
	__POINTW1FN _0x0,210
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0385 
; 0000 0386     }
; 0000 0387 if(PORT_CZYTNIK.byte == 0x06)
_0x20:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6)
	BRNE _0x21
; 0000 0388     {
; 0000 0389       macierz_zaciskow[rzad]=6;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   X+,R30
	ST   X,R31
; 0000 038A       komunikat_z_czytnika_kodow("87-1043",rzad,1);
	__POINTW1FN _0x0,218
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 038B 
; 0000 038C     }
; 0000 038D 
; 0000 038E if(PORT_CZYTNIK.byte == 0x07)
_0x21:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7)
	BRNE _0x22
; 0000 038F     {
; 0000 0390       macierz_zaciskow[rzad]=7;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   X+,R30
	ST   X,R31
; 0000 0391       komunikat_z_czytnika_kodow("87-1675",rzad,1);
	__POINTW1FN _0x0,226
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0392 
; 0000 0393     }
; 0000 0394 
; 0000 0395 if(PORT_CZYTNIK.byte == 0x08)
_0x22:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8)
	BRNE _0x23
; 0000 0396     {
; 0000 0397       macierz_zaciskow[rzad]=8;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   X+,R30
	ST   X,R31
; 0000 0398       komunikat_z_czytnika_kodow("87-2098",rzad,1);
	__POINTW1FN _0x0,234
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0399 
; 0000 039A     }
; 0000 039B if(PORT_CZYTNIK.byte == 0x09)
_0x23:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x9)
	BRNE _0x24
; 0000 039C     {
; 0000 039D       macierz_zaciskow[rzad]=9;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   X+,R30
	ST   X,R31
; 0000 039E       komunikat_z_czytnika_kodow("86-0192",rzad,0);
	__POINTW1FN _0x0,242
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 039F 
; 0000 03A0     }
; 0000 03A1 if(PORT_CZYTNIK.byte == 0x0A)
_0x24:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xA)
	BRNE _0x25
; 0000 03A2     {
; 0000 03A3       macierz_zaciskow[rzad]=10;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   X+,R30
	ST   X,R31
; 0000 03A4       komunikat_z_czytnika_kodow("86-1054",rzad,0);
	__POINTW1FN _0x0,250
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 03A5 
; 0000 03A6     }
; 0000 03A7 if(PORT_CZYTNIK.byte == 0x0B)
_0x25:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xB)
	BRNE _0x26
; 0000 03A8     {
; 0000 03A9       macierz_zaciskow[rzad]=11;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   X+,R30
	ST   X,R31
; 0000 03AA       komunikat_z_czytnika_kodow("86-1676",rzad,0);
	__POINTW1FN _0x0,258
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 03AB 
; 0000 03AC     }
; 0000 03AD if(PORT_CZYTNIK.byte == 0x0C)
_0x26:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xC)
	BRNE _0x27
; 0000 03AE     {
; 0000 03AF       macierz_zaciskow[rzad]=12;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   X+,R30
	ST   X,R31
; 0000 03B0       komunikat_z_czytnika_kodow("86-2132",rzad,1);
	__POINTW1FN _0x0,266
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 03B1 
; 0000 03B2     }
; 0000 03B3 if(PORT_CZYTNIK.byte == 0x0D)
_0x27:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xD)
	BRNE _0x28
; 0000 03B4     {
; 0000 03B5       macierz_zaciskow[rzad]=13;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   X+,R30
	ST   X,R31
; 0000 03B6       komunikat_z_czytnika_kodow("87-0192",rzad,1);
	__POINTW1FN _0x0,274
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 03B7 
; 0000 03B8     }
; 0000 03B9 if(PORT_CZYTNIK.byte == 0x0E)
_0x28:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xE)
	BRNE _0x29
; 0000 03BA     {
; 0000 03BB       macierz_zaciskow[rzad]=14;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   X+,R30
	ST   X,R31
; 0000 03BC       komunikat_z_czytnika_kodow("87-1054",rzad,1);
	__POINTW1FN _0x0,282
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 03BD 
; 0000 03BE     }
; 0000 03BF 
; 0000 03C0 if(PORT_CZYTNIK.byte == 0x0F)
_0x29:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xF)
	BRNE _0x2A
; 0000 03C1     {
; 0000 03C2       macierz_zaciskow[rzad]=15;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   X+,R30
	ST   X,R31
; 0000 03C3       komunikat_z_czytnika_kodow("87-1676",rzad,1);
	__POINTW1FN _0x0,290
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 03C4 
; 0000 03C5     }
; 0000 03C6 if(PORT_CZYTNIK.byte == 0x10)
_0x2A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x10)
	BRNE _0x2B
; 0000 03C7     {
; 0000 03C8       macierz_zaciskow[rzad]=16;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   X+,R30
	ST   X,R31
; 0000 03C9       komunikat_z_czytnika_kodow("87-2132",rzad,0);
	__POINTW1FN _0x0,298
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 03CA 
; 0000 03CB     }
; 0000 03CC 
; 0000 03CD if(PORT_CZYTNIK.byte == 0x11)
_0x2B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x11)
	BRNE _0x2C
; 0000 03CE     {
; 0000 03CF       macierz_zaciskow[rzad]=17;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   X+,R30
	ST   X,R31
; 0000 03D0       komunikat_z_czytnika_kodow("86-0193",rzad,0);
	__POINTW1FN _0x0,306
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 03D1     }
; 0000 03D2 
; 0000 03D3 if(PORT_CZYTNIK.byte == 0x12)
_0x2C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x12)
	BRNE _0x2D
; 0000 03D4     {
; 0000 03D5       macierz_zaciskow[rzad]=18;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	ST   X+,R30
	ST   X,R31
; 0000 03D6       komunikat_z_czytnika_kodow("86-1216",rzad,0);
	__POINTW1FN _0x0,314
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 03D7 
; 0000 03D8     }
; 0000 03D9 if(PORT_CZYTNIK.byte == 0x13)
_0x2D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x13)
	BRNE _0x2E
; 0000 03DA     {
; 0000 03DB       macierz_zaciskow[rzad]=19;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	ST   X+,R30
	ST   X,R31
; 0000 03DC       komunikat_z_czytnika_kodow("86-1832",rzad,0);
	__POINTW1FN _0x0,322
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 03DD 
; 0000 03DE     }
; 0000 03DF 
; 0000 03E0 if(PORT_CZYTNIK.byte == 0x14)
_0x2E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x14)
	BRNE _0x2F
; 0000 03E1     {
; 0000 03E2       macierz_zaciskow[rzad]=20;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   X+,R30
	ST   X,R31
; 0000 03E3       komunikat_z_czytnika_kodow("86-2174",rzad,0);
	__POINTW1FN _0x0,330
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 03E4 
; 0000 03E5     }
; 0000 03E6 if(PORT_CZYTNIK.byte == 0x15)
_0x2F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x15)
	BRNE _0x30
; 0000 03E7     {
; 0000 03E8       macierz_zaciskow[rzad]=21;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	ST   X+,R30
	ST   X,R31
; 0000 03E9       komunikat_z_czytnika_kodow("87-0193",rzad,1);
	__POINTW1FN _0x0,338
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 03EA 
; 0000 03EB     }
; 0000 03EC 
; 0000 03ED if(PORT_CZYTNIK.byte == 0x16)
_0x30:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x16)
	BRNE _0x31
; 0000 03EE     {
; 0000 03EF       macierz_zaciskow[rzad]=22;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	ST   X+,R30
	ST   X,R31
; 0000 03F0       komunikat_z_czytnika_kodow("87-1216",rzad,1);
	__POINTW1FN _0x0,346
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 03F1 
; 0000 03F2     }
; 0000 03F3 if(PORT_CZYTNIK.byte == 0x17)
_0x31:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x17)
	BRNE _0x32
; 0000 03F4     {
; 0000 03F5       macierz_zaciskow[rzad]=23;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	ST   X+,R30
	ST   X,R31
; 0000 03F6       komunikat_z_czytnika_kodow("87-1832",rzad,1);
	__POINTW1FN _0x0,354
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 03F7 
; 0000 03F8     }
; 0000 03F9 
; 0000 03FA if(PORT_CZYTNIK.byte == 0x18)
_0x32:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x18)
	BRNE _0x33
; 0000 03FB     {
; 0000 03FC       macierz_zaciskow[rzad]=24;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	ST   X+,R30
	ST   X,R31
; 0000 03FD       komunikat_z_czytnika_kodow("87-2174",rzad,1);
	__POINTW1FN _0x0,362
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 03FE 
; 0000 03FF     }
; 0000 0400 if(PORT_CZYTNIK.byte == 0x19)
_0x33:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x19)
	BRNE _0x34
; 0000 0401     {
; 0000 0402       macierz_zaciskow[rzad]=25;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	ST   X+,R30
	ST   X,R31
; 0000 0403       komunikat_z_czytnika_kodow("86-0194",rzad,0);
	__POINTW1FN _0x0,370
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0404 
; 0000 0405     }
; 0000 0406 
; 0000 0407 if(PORT_CZYTNIK.byte == 0x1A)
_0x34:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1A)
	BRNE _0x35
; 0000 0408     {
; 0000 0409       macierz_zaciskow[rzad]=26;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	ST   X+,R30
	ST   X,R31
; 0000 040A       komunikat_z_czytnika_kodow("86-1341",rzad,0);
	__POINTW1FN _0x0,378
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 040B 
; 0000 040C     }
; 0000 040D if(PORT_CZYTNIK.byte == 0x1B)
_0x35:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1B)
	BRNE _0x36
; 0000 040E     {
; 0000 040F       macierz_zaciskow[rzad]=27;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(27)
	LDI  R31,HIGH(27)
	ST   X+,R30
	ST   X,R31
; 0000 0410       komunikat_z_czytnika_kodow("86-1833",rzad,0);
	__POINTW1FN _0x0,386
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0411 
; 0000 0412     }
; 0000 0413 if(PORT_CZYTNIK.byte == 0x1C)
_0x36:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1C)
	BRNE _0x37
; 0000 0414     {
; 0000 0415       macierz_zaciskow[rzad]=28;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	ST   X+,R30
	ST   X,R31
; 0000 0416       komunikat_z_czytnika_kodow("86-2180",rzad,1);
	__POINTW1FN _0x0,394
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0417 
; 0000 0418     }
; 0000 0419 if(PORT_CZYTNIK.byte == 0x1D)
_0x37:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1D)
	BRNE _0x38
; 0000 041A     {
; 0000 041B       macierz_zaciskow[rzad]=29;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	ST   X+,R30
	ST   X,R31
; 0000 041C       komunikat_z_czytnika_kodow("87-0194",rzad,1);
	__POINTW1FN _0x0,402
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 041D 
; 0000 041E     }
; 0000 041F 
; 0000 0420 if(PORT_CZYTNIK.byte == 0x1E)
_0x38:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1E)
	BRNE _0x39
; 0000 0421     {
; 0000 0422       macierz_zaciskow[rzad]=30;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   X+,R30
	ST   X,R31
; 0000 0423       komunikat_z_czytnika_kodow("87-1341",rzad,1);
	__POINTW1FN _0x0,410
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0424 
; 0000 0425     }
; 0000 0426 if(PORT_CZYTNIK.byte == 0x1F)
_0x39:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1F)
	BRNE _0x3A
; 0000 0427     {
; 0000 0428       macierz_zaciskow[rzad]=31;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	ST   X+,R30
	ST   X,R31
; 0000 0429       komunikat_z_czytnika_kodow("87-1833",rzad,1);
	__POINTW1FN _0x0,418
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 042A 
; 0000 042B     }
; 0000 042C 
; 0000 042D if(PORT_CZYTNIK.byte == 0x20)
_0x3A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x20)
	BRNE _0x3B
; 0000 042E     {
; 0000 042F       macierz_zaciskow[rzad]=32;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   X+,R30
	ST   X,R31
; 0000 0430       komunikat_z_czytnika_kodow("87-2180",rzad,0);
	__POINTW1FN _0x0,426
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0431 
; 0000 0432     }
; 0000 0433 if(PORT_CZYTNIK.byte == 0x21)
_0x3B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x21)
	BRNE _0x3C
; 0000 0434     {
; 0000 0435       macierz_zaciskow[rzad]=33;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	ST   X+,R30
	ST   X,R31
; 0000 0436       komunikat_z_czytnika_kodow("86-0663",rzad,1);
	__POINTW1FN _0x0,434
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0437 
; 0000 0438     }
; 0000 0439 
; 0000 043A if(PORT_CZYTNIK.byte == 0x22)
_0x3C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x22)
	BRNE _0x3D
; 0000 043B     {
; 0000 043C       macierz_zaciskow[rzad]=34;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	ST   X+,R30
	ST   X,R31
; 0000 043D       komunikat_z_czytnika_kodow("86-1349",rzad,0);
	__POINTW1FN _0x0,442
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 043E 
; 0000 043F     }
; 0000 0440 if(PORT_CZYTNIK.byte == 0x23)
_0x3D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x23)
	BRNE _0x3E
; 0000 0441     {
; 0000 0442       macierz_zaciskow[rzad]=35;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	ST   X+,R30
	ST   X,R31
; 0000 0443       komunikat_z_czytnika_kodow("86-1834",rzad,0);
	__POINTW1FN _0x0,450
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0444 
; 0000 0445     }
; 0000 0446 if(PORT_CZYTNIK.byte == 0x24)
_0x3E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x24)
	BRNE _0x3F
; 0000 0447     {
; 0000 0448       macierz_zaciskow[rzad]=36;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	ST   X+,R30
	ST   X,R31
; 0000 0449       komunikat_z_czytnika_kodow("86-2204",rzad,0);
	__POINTW1FN _0x0,458
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 044A 
; 0000 044B     }
; 0000 044C if(PORT_CZYTNIK.byte == 0x25)
_0x3F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x25)
	BRNE _0x40
; 0000 044D     {
; 0000 044E       macierz_zaciskow[rzad]=37;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(37)
	LDI  R31,HIGH(37)
	ST   X+,R30
	ST   X,R31
; 0000 044F       komunikat_z_czytnika_kodow("87-0663",rzad,0);
	__POINTW1FN _0x0,466
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0450 
; 0000 0451     }
; 0000 0452 if(PORT_CZYTNIK.byte == 0x26)
_0x40:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x26)
	BRNE _0x41
; 0000 0453     {
; 0000 0454       macierz_zaciskow[rzad]=38;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	ST   X+,R30
	ST   X,R31
; 0000 0455       komunikat_z_czytnika_kodow("87-1349",rzad,1);
	__POINTW1FN _0x0,474
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0456 
; 0000 0457     }
; 0000 0458 if(PORT_CZYTNIK.byte == 0x27)
_0x41:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x27)
	BRNE _0x42
; 0000 0459     {
; 0000 045A       macierz_zaciskow[rzad]=39;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(39)
	LDI  R31,HIGH(39)
	ST   X+,R30
	ST   X,R31
; 0000 045B       komunikat_z_czytnika_kodow("87-1834",rzad,1);
	__POINTW1FN _0x0,482
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 045C 
; 0000 045D     }
; 0000 045E if(PORT_CZYTNIK.byte == 0x28)
_0x42:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x28)
	BRNE _0x43
; 0000 045F     {
; 0000 0460       macierz_zaciskow[rzad]=40;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   X+,R30
	ST   X,R31
; 0000 0461       komunikat_z_czytnika_kodow("87-2204",rzad,1);
	__POINTW1FN _0x0,490
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0462 
; 0000 0463     }
; 0000 0464 if(PORT_CZYTNIK.byte == 0x29)
_0x43:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x29)
	BRNE _0x44
; 0000 0465     {
; 0000 0466       macierz_zaciskow[rzad]=41;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	ST   X+,R30
	ST   X,R31
; 0000 0467       komunikat_z_czytnika_kodow("86-0768",rzad,1);
	__POINTW1FN _0x0,498
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0468 
; 0000 0469     }
; 0000 046A if(PORT_CZYTNIK.byte == 0x2A)
_0x44:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2A)
	BRNE _0x45
; 0000 046B     {
; 0000 046C       macierz_zaciskow[rzad]=42;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   X+,R30
	ST   X,R31
; 0000 046D       komunikat_z_czytnika_kodow("86-1357",rzad,0);
	__POINTW1FN _0x0,506
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 046E 
; 0000 046F     }
; 0000 0470 if(PORT_CZYTNIK.byte == 0x2B)
_0x45:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2B)
	BRNE _0x46
; 0000 0471     {
; 0000 0472       macierz_zaciskow[rzad]=43;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	ST   X+,R30
	ST   X,R31
; 0000 0473       komunikat_z_czytnika_kodow("86-1848",rzad,0);
	__POINTW1FN _0x0,514
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0474 
; 0000 0475     }
; 0000 0476 if(PORT_CZYTNIK.byte == 0x2C)
_0x46:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2C)
	BRNE _0x47
; 0000 0477     {
; 0000 0478      macierz_zaciskow[rzad]=44;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x32
; 0000 0479       macierz_zaciskow[rzad]=0;   ////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x33
; 0000 047A 
; 0000 047B      komunikat_z_czytnika_kodow("86-2212",rzad,0);
	__POINTW1FN _0x0,522
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 047C 
; 0000 047D     }
; 0000 047E if(PORT_CZYTNIK.byte == 0x2D)
_0x47:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2D)
	BRNE _0x48
; 0000 047F     {
; 0000 0480       macierz_zaciskow[rzad]=45;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	ST   X+,R30
	ST   X,R31
; 0000 0481       komunikat_z_czytnika_kodow("87-0768",rzad,0);
	__POINTW1FN _0x0,530
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0482 
; 0000 0483     }
; 0000 0484 if(PORT_CZYTNIK.byte == 0x2E)
_0x48:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2E)
	BRNE _0x49
; 0000 0485     {
; 0000 0486       macierz_zaciskow[rzad]=46;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	ST   X+,R30
	ST   X,R31
; 0000 0487       komunikat_z_czytnika_kodow("87-1357",rzad,1);
	__POINTW1FN _0x0,538
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0488 
; 0000 0489     }
; 0000 048A if(PORT_CZYTNIK.byte == 0x2F)
_0x49:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2F)
	BRNE _0x4A
; 0000 048B     {
; 0000 048C       macierz_zaciskow[rzad]=47;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	ST   X+,R30
	ST   X,R31
; 0000 048D       komunikat_z_czytnika_kodow("87-1848",rzad,1);
	__POINTW1FN _0x0,546
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 048E 
; 0000 048F     }
; 0000 0490 if(PORT_CZYTNIK.byte == 0x30)
_0x4A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x30)
	BRNE _0x4B
; 0000 0491     {
; 0000 0492       macierz_zaciskow[rzad]=48;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x32
; 0000 0493       macierz_zaciskow[rzad]=0;    /////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x33
; 0000 0494       komunikat_z_czytnika_kodow("87-2212",rzad,1);
	__POINTW1FN _0x0,554
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0495 
; 0000 0496     }
; 0000 0497 if(PORT_CZYTNIK.byte == 0x31)
_0x4B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x31)
	BRNE _0x4C
; 0000 0498     {
; 0000 0499       macierz_zaciskow[rzad]=49;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	ST   X+,R30
	ST   X,R31
; 0000 049A       komunikat_z_czytnika_kodow("86-0800",rzad,0);
	__POINTW1FN _0x0,562
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 049B 
; 0000 049C     }
; 0000 049D if(PORT_CZYTNIK.byte == 0x32)
_0x4C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x32)
	BRNE _0x4D
; 0000 049E     {
; 0000 049F       macierz_zaciskow[rzad]=50;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   X+,R30
	ST   X,R31
; 0000 04A0       komunikat_z_czytnika_kodow("86-1363",rzad,0);
	__POINTW1FN _0x0,570
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 04A1 
; 0000 04A2     }
; 0000 04A3 if(PORT_CZYTNIK.byte == 0x33)
_0x4D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x33)
	BRNE _0x4E
; 0000 04A4     {
; 0000 04A5       macierz_zaciskow[rzad]=51;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	ST   X+,R30
	ST   X,R31
; 0000 04A6       komunikat_z_czytnika_kodow("86-1904",rzad,0);
	__POINTW1FN _0x0,578
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 04A7 
; 0000 04A8     }
; 0000 04A9 if(PORT_CZYTNIK.byte == 0x34)
_0x4E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x34)
	BRNE _0x4F
; 0000 04AA     {
; 0000 04AB       macierz_zaciskow[rzad]=52;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	ST   X+,R30
	ST   X,R31
; 0000 04AC       komunikat_z_czytnika_kodow("86-2241",rzad,1);
	__POINTW1FN _0x0,586
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 04AD 
; 0000 04AE     }
; 0000 04AF if(PORT_CZYTNIK.byte == 0x35)
_0x4F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x35)
	BRNE _0x50
; 0000 04B0     {
; 0000 04B1       macierz_zaciskow[rzad]=53;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(53)
	LDI  R31,HIGH(53)
	ST   X+,R30
	ST   X,R31
; 0000 04B2       komunikat_z_czytnika_kodow("87-0800",rzad,1);
	__POINTW1FN _0x0,594
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 04B3 
; 0000 04B4     }
; 0000 04B5 
; 0000 04B6 if(PORT_CZYTNIK.byte == 0x36)
_0x50:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x36)
	BRNE _0x51
; 0000 04B7     {
; 0000 04B8       macierz_zaciskow[rzad]=54;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	ST   X+,R30
	ST   X,R31
; 0000 04B9       komunikat_z_czytnika_kodow("87-1363",rzad,1);
	__POINTW1FN _0x0,602
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 04BA 
; 0000 04BB     }
; 0000 04BC if(PORT_CZYTNIK.byte == 0x37)
_0x51:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x37)
	BRNE _0x52
; 0000 04BD     {
; 0000 04BE       macierz_zaciskow[rzad]=55;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	ST   X+,R30
	ST   X,R31
; 0000 04BF       komunikat_z_czytnika_kodow("87-1904",rzad,1);
	__POINTW1FN _0x0,610
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 04C0 
; 0000 04C1     }
; 0000 04C2 if(PORT_CZYTNIK.byte == 0x38)
_0x52:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x38)
	BRNE _0x53
; 0000 04C3     {
; 0000 04C4       macierz_zaciskow[rzad]=56;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	ST   X+,R30
	ST   X,R31
; 0000 04C5       komunikat_z_czytnika_kodow("87-2241",rzad,0);
	__POINTW1FN _0x0,618
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 04C6 
; 0000 04C7     }
; 0000 04C8 if(PORT_CZYTNIK.byte == 0x39)
_0x53:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x39)
	BRNE _0x54
; 0000 04C9     {
; 0000 04CA       macierz_zaciskow[rzad]=57;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(57)
	LDI  R31,HIGH(57)
	ST   X+,R30
	ST   X,R31
; 0000 04CB       komunikat_z_czytnika_kodow("86-0811",rzad,0);
	__POINTW1FN _0x0,626
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 04CC 
; 0000 04CD     }
; 0000 04CE if(PORT_CZYTNIK.byte == 0x3A)
_0x54:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3A)
	BRNE _0x55
; 0000 04CF     {
; 0000 04D0       macierz_zaciskow[rzad]=58;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	ST   X+,R30
	ST   X,R31
; 0000 04D1       komunikat_z_czytnika_kodow("86-1523",rzad,0);
	__POINTW1FN _0x0,634
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 04D2 
; 0000 04D3     }
; 0000 04D4 if(PORT_CZYTNIK.byte == 0x3B)
_0x55:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3B)
	BRNE _0x56
; 0000 04D5     {
; 0000 04D6       macierz_zaciskow[rzad]=59;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	ST   X+,R30
	ST   X,R31
; 0000 04D7       komunikat_z_czytnika_kodow("86-1929",rzad,0);
	__POINTW1FN _0x0,642
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 04D8 
; 0000 04D9     }
; 0000 04DA if(PORT_CZYTNIK.byte == 0x3C)
_0x56:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3C)
	BRNE _0x57
; 0000 04DB     {
; 0000 04DC       macierz_zaciskow[rzad]=60;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	ST   X+,R30
	ST   X,R31
; 0000 04DD       komunikat_z_czytnika_kodow("86-2261",rzad,0);
	__POINTW1FN _0x0,650
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 04DE 
; 0000 04DF     }
; 0000 04E0 if(PORT_CZYTNIK.byte == 0x3D)
_0x57:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3D)
	BRNE _0x58
; 0000 04E1     {
; 0000 04E2       macierz_zaciskow[rzad]=61;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	ST   X+,R30
	ST   X,R31
; 0000 04E3       komunikat_z_czytnika_kodow("87-0811",rzad,1);
	__POINTW1FN _0x0,658
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 04E4 
; 0000 04E5     }
; 0000 04E6 if(PORT_CZYTNIK.byte == 0x3E)
_0x58:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3E)
	BRNE _0x59
; 0000 04E7     {
; 0000 04E8       macierz_zaciskow[rzad]=62;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	ST   X+,R30
	ST   X,R31
; 0000 04E9       komunikat_z_czytnika_kodow("87-1523",rzad,1);
	__POINTW1FN _0x0,666
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 04EA 
; 0000 04EB     }
; 0000 04EC if(PORT_CZYTNIK.byte == 0x3F)
_0x59:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3F)
	BRNE _0x5A
; 0000 04ED     {
; 0000 04EE       macierz_zaciskow[rzad]=63;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	ST   X+,R30
	ST   X,R31
; 0000 04EF       komunikat_z_czytnika_kodow("87-1929",rzad,1);
	__POINTW1FN _0x0,674
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 04F0 
; 0000 04F1     }
; 0000 04F2 if(PORT_CZYTNIK.byte == 0x40)
_0x5A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x40)
	BRNE _0x5B
; 0000 04F3     {
; 0000 04F4       macierz_zaciskow[rzad]=64;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   X+,R30
	ST   X,R31
; 0000 04F5       komunikat_z_czytnika_kodow("87-2261",rzad,1);
	__POINTW1FN _0x0,682
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 04F6 
; 0000 04F7     }
; 0000 04F8 if(PORT_CZYTNIK.byte == 0x41)
_0x5B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x41)
	BRNE _0x5C
; 0000 04F9     {
; 0000 04FA       macierz_zaciskow[rzad]=65;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   X+,R30
	ST   X,R31
; 0000 04FB       komunikat_z_czytnika_kodow("86-0814",rzad,0);
	__POINTW1FN _0x0,690
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 04FC 
; 0000 04FD     }
; 0000 04FE if(PORT_CZYTNIK.byte == 0x42)
_0x5C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x42)
	BRNE _0x5D
; 0000 04FF     {
; 0000 0500       macierz_zaciskow[rzad]=66;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	ST   X+,R30
	ST   X,R31
; 0000 0501       komunikat_z_czytnika_kodow("86-1530",rzad,1);
	__POINTW1FN _0x0,698
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0502 
; 0000 0503     }
; 0000 0504 if(PORT_CZYTNIK.byte == 0x43)
_0x5D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x43)
	BRNE _0x5E
; 0000 0505     {
; 0000 0506       macierz_zaciskow[rzad]=67;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(67)
	LDI  R31,HIGH(67)
	ST   X+,R30
	ST   X,R31
; 0000 0507       komunikat_z_czytnika_kodow("86-1936",rzad,1);
	__POINTW1FN _0x0,706
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0508 
; 0000 0509     }
; 0000 050A if(PORT_CZYTNIK.byte == 0x44)
_0x5E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x44)
	BRNE _0x5F
; 0000 050B     {
; 0000 050C       macierz_zaciskow[rzad]=68;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   X+,R30
	ST   X,R31
; 0000 050D       komunikat_z_czytnika_kodow("86-2285",rzad,1);
	__POINTW1FN _0x0,714
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 050E 
; 0000 050F     }
; 0000 0510 if(PORT_CZYTNIK.byte == 0x45)
_0x5F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x45)
	BRNE _0x60
; 0000 0511     {
; 0000 0512       macierz_zaciskow[rzad]=69;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(69)
	LDI  R31,HIGH(69)
	ST   X+,R30
	ST   X,R31
; 0000 0513       komunikat_z_czytnika_kodow("87-0814",rzad,1);
	__POINTW1FN _0x0,722
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0514 
; 0000 0515     }
; 0000 0516 if(PORT_CZYTNIK.byte == 0x46)
_0x60:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x46)
	BRNE _0x61
; 0000 0517     {
; 0000 0518       macierz_zaciskow[rzad]=70;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   X+,R30
	ST   X,R31
; 0000 0519       komunikat_z_czytnika_kodow("87-1530",rzad,0);
	__POINTW1FN _0x0,730
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 051A 
; 0000 051B     }
; 0000 051C if(PORT_CZYTNIK.byte == 0x47)
_0x61:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x47)
	BRNE _0x62
; 0000 051D     {
; 0000 051E       macierz_zaciskow[rzad]=71;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(71)
	LDI  R31,HIGH(71)
	ST   X+,R30
	ST   X,R31
; 0000 051F       komunikat_z_czytnika_kodow("87-1936",rzad,0);
	__POINTW1FN _0x0,738
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0520 
; 0000 0521     }
; 0000 0522 if(PORT_CZYTNIK.byte == 0x48)
_0x62:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x48)
	BRNE _0x63
; 0000 0523     {
; 0000 0524       macierz_zaciskow[rzad]=72;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	ST   X+,R30
	ST   X,R31
; 0000 0525       komunikat_z_czytnika_kodow("87-2285",rzad,0);
	__POINTW1FN _0x0,746
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0526 
; 0000 0527     }
; 0000 0528 if(PORT_CZYTNIK.byte == 0x49)
_0x63:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x49)
	BRNE _0x64
; 0000 0529     {
; 0000 052A       macierz_zaciskow[rzad]=73;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(73)
	LDI  R31,HIGH(73)
	ST   X+,R30
	ST   X,R31
; 0000 052B       komunikat_z_czytnika_kodow("86-0815",rzad,0);
	__POINTW1FN _0x0,754
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 052C 
; 0000 052D     }
; 0000 052E 
; 0000 052F if(PORT_CZYTNIK.byte == 0x4A)
_0x64:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4A)
	BRNE _0x65
; 0000 0530     {
; 0000 0531       macierz_zaciskow[rzad]=74;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	ST   X+,R30
	ST   X,R31
; 0000 0532       komunikat_z_czytnika_kodow("86-1551",rzad,0);
	__POINTW1FN _0x0,762
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0533 
; 0000 0534     }
; 0000 0535 if(PORT_CZYTNIK.byte == 0x4B)
_0x65:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4B)
	BRNE _0x66
; 0000 0536     {
; 0000 0537       macierz_zaciskow[rzad]=75;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	ST   X+,R30
	ST   X,R31
; 0000 0538       komunikat_z_czytnika_kodow("86-1941",rzad,0);
	__POINTW1FN _0x0,770
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0539 
; 0000 053A     }
; 0000 053B if(PORT_CZYTNIK.byte == 0x4C)
_0x66:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4C)
	BRNE _0x67
; 0000 053C     {
; 0000 053D       macierz_zaciskow[rzad]=76;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x32
; 0000 053E       macierz_zaciskow[rzad]=0;    ////////////////////////////////brak zacisku
	CALL SUBOPT_0x33
; 0000 053F       komunikat_z_czytnika_kodow("86-2286",rzad,0);
	__POINTW1FN _0x0,778
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0540 
; 0000 0541     }
; 0000 0542 if(PORT_CZYTNIK.byte == 0x4D)
_0x67:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4D)
	BRNE _0x68
; 0000 0543     {
; 0000 0544       macierz_zaciskow[rzad]=77;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(77)
	LDI  R31,HIGH(77)
	ST   X+,R30
	ST   X,R31
; 0000 0545       komunikat_z_czytnika_kodow("87-0815",rzad,1);
	__POINTW1FN _0x0,786
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0546 
; 0000 0547     }
; 0000 0548 if(PORT_CZYTNIK.byte == 0x4E)
_0x68:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4E)
	BRNE _0x69
; 0000 0549     {
; 0000 054A       macierz_zaciskow[rzad]=78;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	ST   X+,R30
	ST   X,R31
; 0000 054B       komunikat_z_czytnika_kodow("87-1551",rzad,1);
	__POINTW1FN _0x0,794
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 054C 
; 0000 054D     }
; 0000 054E if(PORT_CZYTNIK.byte == 0x4F)
_0x69:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4F)
	BRNE _0x6A
; 0000 054F     {
; 0000 0550       macierz_zaciskow[rzad]=79;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(79)
	LDI  R31,HIGH(79)
	ST   X+,R30
	ST   X,R31
; 0000 0551       komunikat_z_czytnika_kodow("87-1941",rzad,1);
	__POINTW1FN _0x0,802
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0552 
; 0000 0553     }
; 0000 0554 if(PORT_CZYTNIK.byte == 0x50)
_0x6A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x50)
	BRNE _0x6B
; 0000 0555     {
; 0000 0556       macierz_zaciskow[rzad]=80;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x32
; 0000 0557       macierz_zaciskow[rzad]=0;  ////////////////////////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x33
; 0000 0558       komunikat_z_czytnika_kodow("87-2286",rzad,0);
	__POINTW1FN _0x0,810
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0559 
; 0000 055A     }
; 0000 055B if(PORT_CZYTNIK.byte == 0x51)
_0x6B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x51)
	BRNE _0x6C
; 0000 055C     {
; 0000 055D       macierz_zaciskow[rzad]=81;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(81)
	LDI  R31,HIGH(81)
	ST   X+,R30
	ST   X,R31
; 0000 055E       komunikat_z_czytnika_kodow("86-0816",rzad,0);
	__POINTW1FN _0x0,818
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 055F 
; 0000 0560     }
; 0000 0561 if(PORT_CZYTNIK.byte == 0x52)
_0x6C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x52)
	BRNE _0x6D
; 0000 0562     {
; 0000 0563       macierz_zaciskow[rzad]=82;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	ST   X+,R30
	ST   X,R31
; 0000 0564       komunikat_z_czytnika_kodow("86-1552",rzad,0);
	__POINTW1FN _0x0,826
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0565 
; 0000 0566     }
; 0000 0567 if(PORT_CZYTNIK.byte == 0x53)
_0x6D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x53)
	BRNE _0x6E
; 0000 0568     {
; 0000 0569       macierz_zaciskow[rzad]=83;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	ST   X+,R30
	ST   X,R31
; 0000 056A       komunikat_z_czytnika_kodow("86-2007",rzad,1);
	__POINTW1FN _0x0,834
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 056B 
; 0000 056C     }
; 0000 056D if(PORT_CZYTNIK.byte == 0x54)
_0x6E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x54)
	BRNE _0x6F
; 0000 056E     {
; 0000 056F       macierz_zaciskow[rzad]=84;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	ST   X+,R30
	ST   X,R31
; 0000 0570       komunikat_z_czytnika_kodow("86-2292",rzad,1);
	__POINTW1FN _0x0,842
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0571 
; 0000 0572     }
; 0000 0573 if(PORT_CZYTNIK.byte == 0x55)
_0x6F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x55)
	BRNE _0x70
; 0000 0574     {
; 0000 0575       macierz_zaciskow[rzad]=85;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	ST   X+,R30
	ST   X,R31
; 0000 0576       komunikat_z_czytnika_kodow("87-0816",rzad,1);
	__POINTW1FN _0x0,850
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0577 
; 0000 0578      }
; 0000 0579 if(PORT_CZYTNIK.byte == 0x56)
_0x70:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x56)
	BRNE _0x71
; 0000 057A     {
; 0000 057B       macierz_zaciskow[rzad]=86;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	ST   X+,R30
	ST   X,R31
; 0000 057C       komunikat_z_czytnika_kodow("87-1552",rzad,1);
	__POINTW1FN _0x0,858
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 057D 
; 0000 057E     }
; 0000 057F if(PORT_CZYTNIK.byte == 0x57)
_0x71:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x57)
	BRNE _0x72
; 0000 0580     {
; 0000 0581       macierz_zaciskow[rzad]=87;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(87)
	LDI  R31,HIGH(87)
	ST   X+,R30
	ST   X,R31
; 0000 0582       komunikat_z_czytnika_kodow("87-2007",rzad,0);
	__POINTW1FN _0x0,866
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0583 
; 0000 0584     }
; 0000 0585 if(PORT_CZYTNIK.byte == 0x58)
_0x72:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x58)
	BRNE _0x73
; 0000 0586     {
; 0000 0587       macierz_zaciskow[rzad]=88;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	ST   X+,R30
	ST   X,R31
; 0000 0588       komunikat_z_czytnika_kodow("87-2292",rzad,0);
	__POINTW1FN _0x0,874
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 0589 
; 0000 058A     }
; 0000 058B if(PORT_CZYTNIK.byte == 0x59)
_0x73:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x59)
	BRNE _0x74
; 0000 058C     {
; 0000 058D       macierz_zaciskow[rzad]=89;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(89)
	LDI  R31,HIGH(89)
	ST   X+,R30
	ST   X,R31
; 0000 058E       komunikat_z_czytnika_kodow("86-0817",rzad,0);
	__POINTW1FN _0x0,882
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 058F 
; 0000 0590     }
; 0000 0591 if(PORT_CZYTNIK.byte == 0x5A)
_0x74:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5A)
	BRNE _0x75
; 0000 0592     {
; 0000 0593       macierz_zaciskow[rzad]=90;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   X+,R30
	ST   X,R31
; 0000 0594       komunikat_z_czytnika_kodow("86-1602",rzad,1);
	__POINTW1FN _0x0,890
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0595 
; 0000 0596     }
; 0000 0597 if(PORT_CZYTNIK.byte == 0x5B)
_0x75:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5B)
	BRNE _0x76
; 0000 0598     {
; 0000 0599       macierz_zaciskow[rzad]=91;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	ST   X+,R30
	ST   X,R31
; 0000 059A       komunikat_z_czytnika_kodow("86-2017",rzad,1);
	__POINTW1FN _0x0,898
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 059B 
; 0000 059C     }
; 0000 059D if(PORT_CZYTNIK.byte == 0x5C)
_0x76:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5C)
	BRNE _0x77
; 0000 059E     {
; 0000 059F       macierz_zaciskow[rzad]=92;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x32
; 0000 05A0       macierz_zaciskow[rzad]=0;           /////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x33
; 0000 05A1       komunikat_z_czytnika_kodow("86-2384",rzad,0);
	__POINTW1FN _0x0,906
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	RCALL _komunikat_z_czytnika_kodow
; 0000 05A2 
; 0000 05A3     }
; 0000 05A4 if(PORT_CZYTNIK.byte == 0x5D)
_0x77:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5D)
	BRNE _0x78
; 0000 05A5     {
; 0000 05A6       macierz_zaciskow[rzad]=93;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(93)
	LDI  R31,HIGH(93)
	ST   X+,R30
	ST   X,R31
; 0000 05A7       komunikat_z_czytnika_kodow("87-0817",rzad,1);
	__POINTW1FN _0x0,914
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 05A8 
; 0000 05A9     }
; 0000 05AA if(PORT_CZYTNIK.byte == 0x5E)
_0x78:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5E)
	BRNE _0x79
; 0000 05AB     {
; 0000 05AC       macierz_zaciskow[rzad]=94;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	ST   X+,R30
	ST   X,R31
; 0000 05AD       komunikat_z_czytnika_kodow("87-1602",rzad,0);
	__POINTW1FN _0x0,922
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 05AE 
; 0000 05AF     }
; 0000 05B0 if(PORT_CZYTNIK.byte == 0x5F)
_0x79:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5F)
	BRNE _0x7A
; 0000 05B1     {
; 0000 05B2       macierz_zaciskow[rzad]=95;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(95)
	LDI  R31,HIGH(95)
	ST   X+,R30
	ST   X,R31
; 0000 05B3       komunikat_z_czytnika_kodow("87-2017",rzad,0);
	__POINTW1FN _0x0,930
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 05B4 
; 0000 05B5     }
; 0000 05B6 if(PORT_CZYTNIK.byte == 0x60)
_0x7A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x60)
	BRNE _0x7B
; 0000 05B7     {
; 0000 05B8       macierz_zaciskow[rzad]=96;   ///////////////////////////////////////////////brak zacisku
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x32
; 0000 05B9       macierz_zaciskow[rzad]=0;
	CALL SUBOPT_0x33
; 0000 05BA       komunikat_z_czytnika_kodow("87-2384",rzad,0);
	__POINTW1FN _0x0,938
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 05BB 
; 0000 05BC     }
; 0000 05BD 
; 0000 05BE if(PORT_CZYTNIK.byte == 0x61)
_0x7B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x61)
	BRNE _0x7C
; 0000 05BF     {
; 0000 05C0       macierz_zaciskow[rzad]=97;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(97)
	LDI  R31,HIGH(97)
	ST   X+,R30
	ST   X,R31
; 0000 05C1       komunikat_z_czytnika_kodow("86-0847",rzad,0);
	__POINTW1FN _0x0,946
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 05C2 
; 0000 05C3     }
; 0000 05C4 
; 0000 05C5 if(PORT_CZYTNIK.byte == 0x62)
_0x7C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x62)
	BRNE _0x7D
; 0000 05C6     {
; 0000 05C7       macierz_zaciskow[rzad]=98;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	ST   X+,R30
	ST   X,R31
; 0000 05C8       komunikat_z_czytnika_kodow("86-1620",rzad,0);
	__POINTW1FN _0x0,954
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 05C9 
; 0000 05CA     }
; 0000 05CB if(PORT_CZYTNIK.byte == 0x63)
_0x7D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x63)
	BRNE _0x7E
; 0000 05CC     {
; 0000 05CD       macierz_zaciskow[rzad]=99;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	ST   X+,R30
	ST   X,R31
; 0000 05CE       komunikat_z_czytnika_kodow("86-2019",rzad,1);
	__POINTW1FN _0x0,962
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 05CF 
; 0000 05D0     }
; 0000 05D1 if(PORT_CZYTNIK.byte == 0x64)
_0x7E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x64)
	BRNE _0x7F
; 0000 05D2     {
; 0000 05D3       macierz_zaciskow[rzad]=100;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   X+,R30
	ST   X,R31
; 0000 05D4       komunikat_z_czytnika_kodow("86-2385",rzad,0);
	__POINTW1FN _0x0,970
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 05D5 
; 0000 05D6     }
; 0000 05D7 if(PORT_CZYTNIK.byte == 0x65)
_0x7F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x65)
	BRNE _0x80
; 0000 05D8     {
; 0000 05D9       macierz_zaciskow[rzad]=101;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(101)
	LDI  R31,HIGH(101)
	ST   X+,R30
	ST   X,R31
; 0000 05DA       komunikat_z_czytnika_kodow("87-0847",rzad,1);
	__POINTW1FN _0x0,978
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 05DB 
; 0000 05DC     }
; 0000 05DD if(PORT_CZYTNIK.byte == 0x66)
_0x80:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x66)
	BRNE _0x81
; 0000 05DE     {
; 0000 05DF       macierz_zaciskow[rzad]=102;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	ST   X+,R30
	ST   X,R31
; 0000 05E0       komunikat_z_czytnika_kodow("87-1620",rzad,1);
	__POINTW1FN _0x0,986
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 05E1 
; 0000 05E2     }
; 0000 05E3 if(PORT_CZYTNIK.byte == 0x67)
_0x81:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x67)
	BRNE _0x82
; 0000 05E4     {
; 0000 05E5       macierz_zaciskow[rzad]=103;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	ST   X+,R30
	ST   X,R31
; 0000 05E6       komunikat_z_czytnika_kodow("87-2019",rzad,0);
	__POINTW1FN _0x0,994
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 05E7 
; 0000 05E8     }
; 0000 05E9 if(PORT_CZYTNIK.byte == 0x68)
_0x82:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x68)
	BRNE _0x83
; 0000 05EA     {
; 0000 05EB       macierz_zaciskow[rzad]=104;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	ST   X+,R30
	ST   X,R31
; 0000 05EC       komunikat_z_czytnika_kodow("87-2385",rzad,1);
	__POINTW1FN _0x0,1002
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 05ED 
; 0000 05EE     }
; 0000 05EF if(PORT_CZYTNIK.byte == 0x69)
_0x83:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x69)
	BRNE _0x84
; 0000 05F0     {
; 0000 05F1       macierz_zaciskow[rzad]=105;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(105)
	LDI  R31,HIGH(105)
	ST   X+,R30
	ST   X,R31
; 0000 05F2       komunikat_z_czytnika_kodow("86-0854",rzad,0);
	__POINTW1FN _0x0,1010
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 05F3 
; 0000 05F4     }
; 0000 05F5 if(PORT_CZYTNIK.byte == 0x6A)
_0x84:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6A)
	BRNE _0x85
; 0000 05F6     {
; 0000 05F7       macierz_zaciskow[rzad]=106;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	ST   X+,R30
	ST   X,R31
; 0000 05F8       komunikat_z_czytnika_kodow("86-1622",rzad,1);
	__POINTW1FN _0x0,1018
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 05F9 
; 0000 05FA     }
; 0000 05FB if(PORT_CZYTNIK.byte == 0x6B)
_0x85:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6B)
	BRNE _0x86
; 0000 05FC     {
; 0000 05FD       macierz_zaciskow[rzad]=107;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(107)
	LDI  R31,HIGH(107)
	CALL SUBOPT_0x32
; 0000 05FE       macierz_zaciskow[rzad]=0;          //brak zacisku
	CALL SUBOPT_0x33
; 0000 05FF       komunikat_z_czytnika_kodow("86-2028",rzad,0);
	__POINTW1FN _0x0,1026
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 0600 
; 0000 0601     }
; 0000 0602 if(PORT_CZYTNIK.byte == 0x6C)
_0x86:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6C)
	BRNE _0x87
; 0000 0603     {
; 0000 0604       macierz_zaciskow[rzad]=108;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	ST   X+,R30
	ST   X,R31
; 0000 0605       komunikat_z_czytnika_kodow("86-2437",rzad,0);
	__POINTW1FN _0x0,1034
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 0606 
; 0000 0607     }
; 0000 0608 if(PORT_CZYTNIK.byte == 0x6D)
_0x87:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6D)
	BRNE _0x88
; 0000 0609     {
; 0000 060A       macierz_zaciskow[rzad]=109;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(109)
	LDI  R31,HIGH(109)
	ST   X+,R30
	ST   X,R31
; 0000 060B       komunikat_z_czytnika_kodow("87-0854",rzad,1);
	__POINTW1FN _0x0,1042
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 060C 
; 0000 060D     }
; 0000 060E if(PORT_CZYTNIK.byte == 0x6E)
_0x88:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6E)
	BRNE _0x89
; 0000 060F     {
; 0000 0610       macierz_zaciskow[rzad]=110;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	ST   X+,R30
	ST   X,R31
; 0000 0611       komunikat_z_czytnika_kodow("87-1622",rzad,0);
	__POINTW1FN _0x0,1050
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 0612 
; 0000 0613     }
; 0000 0614 
; 0000 0615 if(PORT_CZYTNIK.byte == 0x6F)
_0x89:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6F)
	BRNE _0x8A
; 0000 0616     {
; 0000 0617       macierz_zaciskow[rzad]=111;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(111)
	LDI  R31,HIGH(111)
	CALL SUBOPT_0x32
; 0000 0618       macierz_zaciskow[rzad]=0;      //brak zacisku
	CALL SUBOPT_0x33
; 0000 0619       komunikat_z_czytnika_kodow("87-2028",rzad,0);
	__POINTW1FN _0x0,1058
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 061A 
; 0000 061B     }
; 0000 061C 
; 0000 061D if(PORT_CZYTNIK.byte == 0x70)
_0x8A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x70)
	BRNE _0x8B
; 0000 061E     {
; 0000 061F       macierz_zaciskow[rzad]=112;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   X+,R30
	ST   X,R31
; 0000 0620       komunikat_z_czytnika_kodow("87-2437",rzad,1);
	__POINTW1FN _0x0,1066
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0621 
; 0000 0622     }
; 0000 0623 if(PORT_CZYTNIK.byte == 0x71)
_0x8B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x71)
	BRNE _0x8C
; 0000 0624     {
; 0000 0625       macierz_zaciskow[rzad]=113;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   X+,R30
	ST   X,R31
; 0000 0626       komunikat_z_czytnika_kodow("86-0862",rzad,0);
	__POINTW1FN _0x0,1074
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 0627 
; 0000 0628     }
; 0000 0629 if(PORT_CZYTNIK.byte == 0x72)
_0x8C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x72)
	BRNE _0x8D
; 0000 062A     {
; 0000 062B       macierz_zaciskow[rzad]=114;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	ST   X+,R30
	ST   X,R31
; 0000 062C       komunikat_z_czytnika_kodow("86-1625",rzad,0);
	__POINTW1FN _0x0,1082
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 062D 
; 0000 062E     }
; 0000 062F if(PORT_CZYTNIK.byte == 0x73)
_0x8D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x73)
	BRNE _0x8E
; 0000 0630     {
; 0000 0631       macierz_zaciskow[rzad]=115;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(115)
	LDI  R31,HIGH(115)
	ST   X+,R30
	ST   X,R31
; 0000 0632       komunikat_z_czytnika_kodow("86-2052",rzad,0);
	__POINTW1FN _0x0,1090
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 0633 
; 0000 0634     }
; 0000 0635 if(PORT_CZYTNIK.byte == 0x74)
_0x8E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x74)
	BRNE _0x8F
; 0000 0636     {
; 0000 0637       macierz_zaciskow[rzad]=116;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	ST   X+,R30
	ST   X,R31
; 0000 0638       komunikat_z_czytnika_kodow("86-2492",rzad,1);
	__POINTW1FN _0x0,1098
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0639 
; 0000 063A     }
; 0000 063B if(PORT_CZYTNIK.byte == 0x75)
_0x8F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x75)
	BRNE _0x90
; 0000 063C     {
; 0000 063D       macierz_zaciskow[rzad]=117;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(117)
	LDI  R31,HIGH(117)
	ST   X+,R30
	ST   X,R31
; 0000 063E       komunikat_z_czytnika_kodow("87-0862",rzad,1);
	__POINTW1FN _0x0,1106
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 063F 
; 0000 0640     }
; 0000 0641 if(PORT_CZYTNIK.byte == 0x76)
_0x90:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x76)
	BRNE _0x91
; 0000 0642     {
; 0000 0643       macierz_zaciskow[rzad]=118;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	ST   X+,R30
	ST   X,R31
; 0000 0644       komunikat_z_czytnika_kodow("87-1625",rzad,1);
	__POINTW1FN _0x0,1114
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0645 
; 0000 0646     }
; 0000 0647 if(PORT_CZYTNIK.byte == 0x77)
_0x91:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x77)
	BRNE _0x92
; 0000 0648     {
; 0000 0649       macierz_zaciskow[rzad]=119;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   X+,R30
	ST   X,R31
; 0000 064A       komunikat_z_czytnika_kodow("87-2052",rzad,1);
	__POINTW1FN _0x0,1122
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 064B 
; 0000 064C     }
; 0000 064D if(PORT_CZYTNIK.byte == 0x78)
_0x92:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x78)
	BRNE _0x93
; 0000 064E     {
; 0000 064F       macierz_zaciskow[rzad]=120;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   X+,R30
	ST   X,R31
; 0000 0650       komunikat_z_czytnika_kodow("87-2492",rzad,0);
	__POINTW1FN _0x0,1130
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 0651 
; 0000 0652     }
; 0000 0653 if(PORT_CZYTNIK.byte == 0x79)
_0x93:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x79)
	BRNE _0x94
; 0000 0654     {
; 0000 0655       macierz_zaciskow[rzad]=121;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   X+,R30
	ST   X,R31
; 0000 0656       komunikat_z_czytnika_kodow("86-0935",rzad,0);
	__POINTW1FN _0x0,1138
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 0657 
; 0000 0658     }
; 0000 0659 if(PORT_CZYTNIK.byte == 0x7A)
_0x94:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7A)
	BRNE _0x95
; 0000 065A     {
; 0000 065B       macierz_zaciskow[rzad]=122;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	ST   X+,R30
	ST   X,R31
; 0000 065C       komunikat_z_czytnika_kodow("86-1648",rzad,0);
	__POINTW1FN _0x0,1146
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 065D 
; 0000 065E     }
; 0000 065F if(PORT_CZYTNIK.byte == 0x7B)
_0x95:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7B)
	BRNE _0x96
; 0000 0660     {
; 0000 0661       macierz_zaciskow[rzad]=123;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(123)
	LDI  R31,HIGH(123)
	ST   X+,R30
	ST   X,R31
; 0000 0662       komunikat_z_czytnika_kodow("86-2082",rzad,0);
	__POINTW1FN _0x0,1154
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 0663 
; 0000 0664     }
; 0000 0665 if(PORT_CZYTNIK.byte == 0x7C)
_0x96:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7C)
	BRNE _0x97
; 0000 0666     {
; 0000 0667       macierz_zaciskow[rzad]=124;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	ST   X+,R30
	ST   X,R31
; 0000 0668       komunikat_z_czytnika_kodow("86-2500",rzad,0);
	__POINTW1FN _0x0,1162
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 0669 
; 0000 066A     }
; 0000 066B if(PORT_CZYTNIK.byte == 0x7D)
_0x97:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7D)
	BRNE _0x98
; 0000 066C     {
; 0000 066D       macierz_zaciskow[rzad]=125;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   X+,R30
	ST   X,R31
; 0000 066E       komunikat_z_czytnika_kodow("87-0935",rzad,1);
	__POINTW1FN _0x0,1170
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 066F 
; 0000 0670     }
; 0000 0671 if(PORT_CZYTNIK.byte == 0x7E)
_0x98:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7E)
	BRNE _0x99
; 0000 0672     {
; 0000 0673       macierz_zaciskow[rzad]=126;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	ST   X+,R30
	ST   X,R31
; 0000 0674       komunikat_z_czytnika_kodow("87-1648",rzad,1);
	__POINTW1FN _0x0,1178
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0675 
; 0000 0676     }
; 0000 0677 
; 0000 0678 if(PORT_CZYTNIK.byte == 0x7F)
_0x99:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7F)
	BRNE _0x9A
; 0000 0679     {
; 0000 067A       macierz_zaciskow[rzad]=127;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	ST   X+,R30
	ST   X,R31
; 0000 067B       komunikat_z_czytnika_kodow("87-2082",rzad,1);
	__POINTW1FN _0x0,1186
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 067C 
; 0000 067D     }
; 0000 067E if(PORT_CZYTNIK.byte == 0x80)
_0x9A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x80)
	BRNE _0x9B
; 0000 067F     {
; 0000 0680       macierz_zaciskow[rzad]=128;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   X+,R30
	ST   X,R31
; 0000 0681       komunikat_z_czytnika_kodow("87-2500",rzad,1);
	__POINTW1FN _0x0,1194
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0682 
; 0000 0683     }
; 0000 0684 if(PORT_CZYTNIK.byte == 0x81)
_0x9B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x81)
	BRNE _0x9C
; 0000 0685     {
; 0000 0686       macierz_zaciskow[rzad]=129;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(129)
	LDI  R31,HIGH(129)
	ST   X+,R30
	ST   X,R31
; 0000 0687       komunikat_z_czytnika_kodow("86-1019",rzad,0);
	__POINTW1FN _0x0,1202
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 0688 
; 0000 0689     }
; 0000 068A if(PORT_CZYTNIK.byte == 0x82)
_0x9C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x82)
	BRNE _0x9D
; 0000 068B     {
; 0000 068C       macierz_zaciskow[rzad]=130;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	ST   X+,R30
	ST   X,R31
; 0000 068D       komunikat_z_czytnika_kodow("86-1649",rzad,0);
	__POINTW1FN _0x0,1210
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 068E 
; 0000 068F     }
; 0000 0690 if(PORT_CZYTNIK.byte == 0x83)
_0x9D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x83)
	BRNE _0x9E
; 0000 0691     {
; 0000 0692       macierz_zaciskow[rzad]=131;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(131)
	LDI  R31,HIGH(131)
	ST   X+,R30
	ST   X,R31
; 0000 0693       komunikat_z_czytnika_kodow("86-2083",rzad,1);
	__POINTW1FN _0x0,1218
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0694 
; 0000 0695     }
; 0000 0696 if(PORT_CZYTNIK.byte == 0x84)
_0x9E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x84)
	BRNE _0x9F
; 0000 0697     {
; 0000 0698       macierz_zaciskow[rzad]=132;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	ST   X+,R30
	ST   X,R31
; 0000 0699       komunikat_z_czytnika_kodow("86-2585",rzad,0);
	__POINTW1FN _0x0,1226
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 069A 
; 0000 069B     }
; 0000 069C if(PORT_CZYTNIK.byte == 0x85)
_0x9F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x85)
	BRNE _0xA0
; 0000 069D     {
; 0000 069E       macierz_zaciskow[rzad]=133;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(133)
	LDI  R31,HIGH(133)
	ST   X+,R30
	ST   X,R31
; 0000 069F       komunikat_z_czytnika_kodow("87-1019",rzad,1);
	__POINTW1FN _0x0,1234
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 06A0 
; 0000 06A1     }
; 0000 06A2 if(PORT_CZYTNIK.byte == 0x86)
_0xA0:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x86)
	BRNE _0xA1
; 0000 06A3     {
; 0000 06A4       macierz_zaciskow[rzad]=134;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	ST   X+,R30
	ST   X,R31
; 0000 06A5       komunikat_z_czytnika_kodow("87-1649",rzad,1);
	__POINTW1FN _0x0,1242
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 06A6 
; 0000 06A7     }
; 0000 06A8 if(PORT_CZYTNIK.byte == 0x87)
_0xA1:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x87)
	BRNE _0xA2
; 0000 06A9     {
; 0000 06AA       macierz_zaciskow[rzad]=135;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(135)
	LDI  R31,HIGH(135)
	ST   X+,R30
	ST   X,R31
; 0000 06AB       komunikat_z_czytnika_kodow("87-2083",rzad,0);
	__POINTW1FN _0x0,1250
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 06AC 
; 0000 06AD     }
; 0000 06AE 
; 0000 06AF if(PORT_CZYTNIK.byte == 0x88)
_0xA2:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x88)
	BRNE _0xA3
; 0000 06B0     {
; 0000 06B1       macierz_zaciskow[rzad]=136;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	ST   X+,R30
	ST   X,R31
; 0000 06B2       komunikat_z_czytnika_kodow("87-2624",rzad,1);
	__POINTW1FN _0x0,1258
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 06B3 
; 0000 06B4     }
; 0000 06B5 if(PORT_CZYTNIK.byte == 0x89)
_0xA3:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x89)
	BRNE _0xA4
; 0000 06B6     {
; 0000 06B7       macierz_zaciskow[rzad]=137;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(137)
	LDI  R31,HIGH(137)
	ST   X+,R30
	ST   X,R31
; 0000 06B8       komunikat_z_czytnika_kodow("86-1027",rzad,0);
	__POINTW1FN _0x0,1266
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 06B9 
; 0000 06BA     }
; 0000 06BB if(PORT_CZYTNIK.byte == 0x8A)
_0xA4:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8A)
	BRNE _0xA5
; 0000 06BC     {
; 0000 06BD       macierz_zaciskow[rzad]=138;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	ST   X+,R30
	ST   X,R31
; 0000 06BE       komunikat_z_czytnika_kodow("86-1669",rzad,1);
	__POINTW1FN _0x0,1274
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 06BF 
; 0000 06C0     }
; 0000 06C1 if(PORT_CZYTNIK.byte == 0x8B)
_0xA5:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8B)
	BRNE _0xA6
; 0000 06C2     {
; 0000 06C3       macierz_zaciskow[rzad]=139;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(139)
	LDI  R31,HIGH(139)
	ST   X+,R30
	ST   X,R31
; 0000 06C4       komunikat_z_czytnika_kodow("86-2087",rzad,1);
	__POINTW1FN _0x0,1282
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 06C5 
; 0000 06C6     }
; 0000 06C7 if(PORT_CZYTNIK.byte == 0x8C)
_0xA6:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8C)
	BRNE _0xA7
; 0000 06C8     {
; 0000 06C9       macierz_zaciskow[rzad]=140;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	ST   X+,R30
	ST   X,R31
; 0000 06CA       komunikat_z_czytnika_kodow("86-2624",rzad,0);
	__POINTW1FN _0x0,1290
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 06CB 
; 0000 06CC     }
; 0000 06CD if(PORT_CZYTNIK.byte == 0x8D)
_0xA7:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8D)
	BRNE _0xA8
; 0000 06CE     {
; 0000 06CF       macierz_zaciskow[rzad]=141;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(141)
	LDI  R31,HIGH(141)
	ST   X+,R30
	ST   X,R31
; 0000 06D0       komunikat_z_czytnika_kodow("87-1027",rzad,1);
	__POINTW1FN _0x0,1298
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 06D1 
; 0000 06D2     }
; 0000 06D3 if(PORT_CZYTNIK.byte == 0x8E)
_0xA8:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8E)
	BRNE _0xA9
; 0000 06D4     {
; 0000 06D5       macierz_zaciskow[rzad]=142;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	ST   X+,R30
	ST   X,R31
; 0000 06D6       komunikat_z_czytnika_kodow("87-1669",rzad,0);
	__POINTW1FN _0x0,1306
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 06D7 
; 0000 06D8     }
; 0000 06D9 if(PORT_CZYTNIK.byte == 0x8F)
_0xA9:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8F)
	BRNE _0xAA
; 0000 06DA     {
; 0000 06DB       macierz_zaciskow[rzad]=143;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(143)
	LDI  R31,HIGH(143)
	ST   X+,R30
	ST   X,R31
; 0000 06DC       komunikat_z_czytnika_kodow("87-2087",rzad,0);
	__POINTW1FN _0x0,1314
	CALL SUBOPT_0x30
	CALL SUBOPT_0xE
	CALL _komunikat_z_czytnika_kodow
; 0000 06DD 
; 0000 06DE     }
; 0000 06DF if(PORT_CZYTNIK.byte == 0x90)
_0xAA:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x90)
	BRNE _0xAB
; 0000 06E0     {
; 0000 06E1       macierz_zaciskow[rzad]=144;
	MOVW R30,R16
	CALL SUBOPT_0x11
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   X+,R30
	ST   X,R31
; 0000 06E2       komunikat_z_czytnika_kodow("87-2585",rzad,1);
	__POINTW1FN _0x0,1322
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 06E3 
; 0000 06E4     }
; 0000 06E5 
; 0000 06E6 
; 0000 06E7 return rzad;
_0xAB:
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 06E8 }
;
;
;void wybor_linijek_sterownikow(int rzad_local)
; 0000 06EC {
_wybor_linijek_sterownikow:
; 0000 06ED //zaczynam od tego
; 0000 06EE //komentarz: celowo upraszam:
; 0000 06EF //  a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 06F0 //a[4] = 0x21;    //ster3 ABS             //krazek scierny
; 0000 06F1 
; 0000 06F2 //legenda pierwotna
; 0000 06F3             /*
; 0000 06F4             a[0] = 0x05A;   //ster1
; 0000 06F5             a[1] = a[0]+0x001;                                   //0x05B;   //ster2
; 0000 06F6             a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 06F7             a[3] = 0x11;    //ster4 INV             //druciak
; 0000 06F8             a[4] = a[2];   //0x21;    //ster3 ABS             //krazek scierny
; 0000 06F9             a[5] = 0x196;   //delta okrag
; 0000 06FA             a[6] = a[5]+0x001;            //0x197;   //okrag
; 0000 06FB             a[7] = 0x12;    //ster3 INV             krazek scierny
; 0000 06FC             a[8] = a[6]+0x001;                0x198;   //-delta okrag
; 0000 06FD             a[9] = 0;          //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 06FE             */
; 0000 06FF 
; 0000 0700 
; 0000 0701 //macierz_zaciskow[rzad_local]
; 0000 0702 //macierz_zaciskow[rzad_local] = 140;
; 0000 0703 
; 0000 0704 
; 0000 0705 
; 0000 0706 
; 0000 0707 
; 0000 0708 
; 0000 0709 switch(macierz_zaciskow[rzad_local])
;	rzad_local -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x11
	CALL __GETW1P
; 0000 070A {
; 0000 070B     case 0:
	SBIW R30,0
	BRNE _0xAF
; 0000 070C 
; 0000 070D             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 070E             komunikat_na_panel("Nie wczytano zacisku",adr1,adr2);
	__POINTW1FN _0x0,1330
	CALL SUBOPT_0x2B
; 0000 070F 
; 0000 0710     break;
	JMP  _0xAE
; 0000 0711 
; 0000 0712 
; 0000 0713      case 1:
_0xAF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB0
; 0000 0714 
; 0000 0715             a[0] = 0x0C8;   //ster1
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x34
; 0000 0716             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0717             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x36
; 0000 0718             a[5] = 0x196;   //delta okrag
; 0000 0719             a[7] = 0x11;    //ster3 INV krazek scierny
	JMP  _0x513
; 0000 071A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 071B 
; 0000 071C             a[1] = a[0]+0x001;  //ster2
; 0000 071D             a[2] = a[4];        //ster4 ABS druciak
; 0000 071E             a[6] = a[5]+0x001;  //okrag
; 0000 071F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0720 
; 0000 0721     break;
; 0000 0722 
; 0000 0723       case 2:
_0xB0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB1
; 0000 0724 
; 0000 0725             a[0] = 0x110;   //ster1
	LDI  R30,LOW(272)
	LDI  R31,HIGH(272)
	CALL SUBOPT_0x34
; 0000 0726             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0727             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x38
; 0000 0728             a[5] = 0x190;   //delta okrag
; 0000 0729             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x37
; 0000 072A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x39
	JMP  _0x514
; 0000 072B 
; 0000 072C             a[1] = a[0]+0x001;  //ster2
; 0000 072D             a[2] = a[4];        //ster4 ABS druciak
; 0000 072E             a[6] = a[5]+0x001;  //okrag
; 0000 072F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0730 
; 0000 0731     break;
; 0000 0732 
; 0000 0733       case 3:
_0xB1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xB2
; 0000 0734 
; 0000 0735             a[0] = 0x07A;   //ster1
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	CALL SUBOPT_0x34
; 0000 0736             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0737             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3A
; 0000 0738             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 0739             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 073A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x514
; 0000 073B 
; 0000 073C             a[1] = a[0]+0x001;  //ster2
; 0000 073D             a[2] = a[4];        //ster4 ABS druciak
; 0000 073E             a[6] = a[5]+0x001;  //okrag
; 0000 073F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0740 
; 0000 0741     break;
; 0000 0742 
; 0000 0743       case 4:
_0xB2:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xB3
; 0000 0744 
; 0000 0745             a[0] = 0x102;   //ster1
	LDI  R30,LOW(258)
	LDI  R31,HIGH(258)
	CALL SUBOPT_0x34
; 0000 0746             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0747             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 0748             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 0749             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 074A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x514
; 0000 074B 
; 0000 074C             a[1] = a[0]+0x001;  //ster2
; 0000 074D             a[2] = a[4];        //ster4 ABS druciak
; 0000 074E             a[6] = a[5]+0x001;  //okrag
; 0000 074F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0750 
; 0000 0751     break;
; 0000 0752 
; 0000 0753       case 5:
_0xB3:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xB4
; 0000 0754 
; 0000 0755             a[0] = 0x0B0;   //ster1
	LDI  R30,LOW(176)
	LDI  R31,HIGH(176)
	CALL SUBOPT_0x34
; 0000 0756             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0757             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x36
; 0000 0758             a[5] = 0x196;   //delta okrag
; 0000 0759             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 075A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 075B 
; 0000 075C             a[1] = a[0]+0x001;  //ster2
; 0000 075D             a[2] = a[4];        //ster4 ABS druciak
; 0000 075E             a[6] = a[5]+0x001;  //okrag
; 0000 075F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0760 
; 0000 0761     break;
; 0000 0762 
; 0000 0763       case 6:
_0xB4:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xB5
; 0000 0764 
; 0000 0765             a[0] = 0x0FE;   //ster1
	LDI  R30,LOW(254)
	LDI  R31,HIGH(254)
	CALL SUBOPT_0x34
; 0000 0766             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0767             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x38
; 0000 0768             a[5] = 0x190;   //delta okrag
; 0000 0769             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x513
; 0000 076A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 076B 
; 0000 076C             a[1] = a[0]+0x001;  //ster2
; 0000 076D             a[2] = a[4];        //ster4 ABS druciak
; 0000 076E             a[6] = a[5]+0x001;  //okrag
; 0000 076F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0770 
; 0000 0771     break;
; 0000 0772 
; 0000 0773 
; 0000 0774       case 7:
_0xB5:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xB6
; 0000 0775 
; 0000 0776             a[0] = 0x078;   //ster1
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x34
; 0000 0777             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0778             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3A
; 0000 0779             a[5] = 0x196;   //delta okrag
	RJMP _0x515
; 0000 077A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 077B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 077C 
; 0000 077D             a[1] = a[0]+0x001;  //ster2
; 0000 077E             a[2] = a[4];        //ster4 ABS druciak
; 0000 077F             a[6] = a[5]+0x001;  //okrag
; 0000 0780             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0781 
; 0000 0782     break;
; 0000 0783 
; 0000 0784 
; 0000 0785       case 8:
_0xB6:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xB7
; 0000 0786 
; 0000 0787             a[0] = 0x0C0;   //ster1
	LDI  R30,LOW(192)
	LDI  R31,HIGH(192)
	CALL SUBOPT_0x34
; 0000 0788             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0789             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 078A             a[5] = 0x196;   //delta okrag
	RJMP _0x515
; 0000 078B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 078C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 078D 
; 0000 078E             a[1] = a[0]+0x001;  //ster2
; 0000 078F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0790             a[6] = a[5]+0x001;  //okrag
; 0000 0791             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0792 
; 0000 0793     break;
; 0000 0794 
; 0000 0795 
; 0000 0796       case 9:
_0xB7:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xB8
; 0000 0797 
; 0000 0798             a[0] = 0x018;   //ster1
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL SUBOPT_0x34
; 0000 0799             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 079A             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 079B             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3E
; 0000 079C             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 079D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 079E 
; 0000 079F             a[1] = a[0]+0x001;  //ster2
; 0000 07A0             a[2] = a[4];        //ster4 ABS druciak
; 0000 07A1             a[6] = a[5]+0x001;  //okrag
; 0000 07A2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07A3 
; 0000 07A4     break;
; 0000 07A5 
; 0000 07A6 
; 0000 07A7       case 10:
_0xB8:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xB9
; 0000 07A8 
; 0000 07A9             a[0] = 0x016;   //ster1
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CALL SUBOPT_0x34
; 0000 07AA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 07AB             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 07AC             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 07AD             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07AE             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 07AF 
; 0000 07B0             a[1] = a[0]+0x001;  //ster2
; 0000 07B1             a[2] = a[4];        //ster4 ABS druciak
; 0000 07B2             a[6] = a[5]+0x001;  //okrag
; 0000 07B3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07B4 
; 0000 07B5     break;
; 0000 07B6 
; 0000 07B7 
; 0000 07B8       case 11:
_0xB9:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xBA
; 0000 07B9 
; 0000 07BA             a[0] = 0x074;   //ster1
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	CALL SUBOPT_0x34
; 0000 07BB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 07BC             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 07BD             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 07BE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07BF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 07C0 
; 0000 07C1             a[1] = a[0]+0x001;  //ster2
; 0000 07C2             a[2] = a[4];        //ster4 ABS druciak
; 0000 07C3             a[6] = a[5]+0x001;  //okrag
; 0000 07C4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07C5 
; 0000 07C6     break;
; 0000 07C7 
; 0000 07C8 
; 0000 07C9       case 12:
_0xBA:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xBB
; 0000 07CA 
; 0000 07CB             a[0] = 0x096;   //ster1
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x34
; 0000 07CC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 07CD             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 07CE             a[5] = 0x199;   //delta okrag
	RJMP _0x515
; 0000 07CF             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07D0             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07D1 
; 0000 07D2             a[1] = a[0]+0x001;  //ster2
; 0000 07D3             a[2] = a[4];        //ster4 ABS druciak
; 0000 07D4             a[6] = a[5]+0x001;  //okrag
; 0000 07D5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07D6 
; 0000 07D7     break;
; 0000 07D8 
; 0000 07D9 
; 0000 07DA       case 13:
_0xBB:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xBC
; 0000 07DB 
; 0000 07DC             a[0] = 0x01A;   //ster1
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	CALL SUBOPT_0x34
; 0000 07DD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 07DE             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 07DF             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3E
; 0000 07E0             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 07E1             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07E2 
; 0000 07E3             a[1] = a[0]+0x001;  //ster2
; 0000 07E4             a[2] = a[4];        //ster4 ABS druciak
; 0000 07E5             a[6] = a[5]+0x001;  //okrag
; 0000 07E6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07E7 
; 0000 07E8     break;
; 0000 07E9 
; 0000 07EA 
; 0000 07EB       case 14:
_0xBC:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xBD
; 0000 07EC 
; 0000 07ED             a[0] = 0x05E;   //ster1
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	CALL SUBOPT_0x34
; 0000 07EE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 07EF             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 07F0             a[5] = 0x199;   //delta okrag
	RJMP _0x515
; 0000 07F1             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07F2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07F3 
; 0000 07F4             a[1] = a[0]+0x001;  //ster2
; 0000 07F5             a[2] = a[4];        //ster4 ABS druciak
; 0000 07F6             a[6] = a[5]+0x001;  //okrag
; 0000 07F7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07F8 
; 0000 07F9     break;
; 0000 07FA 
; 0000 07FB 
; 0000 07FC       case 15:
_0xBD:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xBE
; 0000 07FD 
; 0000 07FE             a[0] = 0x084;   //ster1
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	CALL SUBOPT_0x34
; 0000 07FF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0800             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0801             a[5] = 0x199;   //delta okrag
	RJMP _0x515
; 0000 0802             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0803             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0804 
; 0000 0805             a[1] = a[0]+0x001;  //ster2
; 0000 0806             a[2] = a[4];        //ster4 ABS druciak
; 0000 0807             a[6] = a[5]+0x001;  //okrag
; 0000 0808             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0809 
; 0000 080A     break;
; 0000 080B 
; 0000 080C 
; 0000 080D       case 16:
_0xBE:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xBF
; 0000 080E 
; 0000 080F             a[0] = 0x0B8;   //ster1
	LDI  R30,LOW(184)
	LDI  R31,HIGH(184)
	CALL SUBOPT_0x34
; 0000 0810             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0811             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 0812             a[5] = 0x199;   //delta okrag
; 0000 0813             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0814             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0815 
; 0000 0816             a[1] = a[0]+0x001;  //ster2
; 0000 0817             a[2] = a[4];        //ster4 ABS druciak
; 0000 0818             a[6] = a[5]+0x001;  //okrag
; 0000 0819             a[8] = a[6]+0x001;  //-delta okrag
; 0000 081A 
; 0000 081B     break;
; 0000 081C 
; 0000 081D       case 17:
_0xBF:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xC0
; 0000 081E 
; 0000 081F             a[0] = 0x020;   //ster1
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x34
; 0000 0820             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0821             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x36
; 0000 0822             a[5] = 0x196;   //delta okrag
; 0000 0823             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0824             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0825 
; 0000 0826             a[1] = a[0]+0x001;  //ster2
; 0000 0827             a[2] = a[4];        //ster4 ABS druciak
; 0000 0828             a[6] = a[5]+0x001;  //okrag
; 0000 0829             a[8] = a[6]+0x001;  //-delta okrag
; 0000 082A 
; 0000 082B     break;
; 0000 082C 
; 0000 082D 
; 0000 082E       case 18:
_0xC0:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xC1
; 0000 082F 
; 0000 0830             a[0] = 0x098;   //ster1
	LDI  R30,LOW(152)
	LDI  R31,HIGH(152)
	CALL SUBOPT_0x34
; 0000 0831             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0832             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x43
; 0000 0833             a[5] = 0x190;   //delta okrag
; 0000 0834             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x37
; 0000 0835             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x39
	RJMP _0x514
; 0000 0836 
; 0000 0837             a[1] = a[0]+0x001;  //ster2
; 0000 0838             a[2] = a[4];        //ster4 ABS druciak
; 0000 0839             a[6] = a[5]+0x001;  //okrag
; 0000 083A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 083B 
; 0000 083C     break;
; 0000 083D 
; 0000 083E 
; 0000 083F 
; 0000 0840       case 19:
_0xC1:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xC2
; 0000 0841 
; 0000 0842             a[0] = 0x0AA;   //ster1
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	CALL SUBOPT_0x34
; 0000 0843             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0844             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0845             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x45
; 0000 0846             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0847             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0848 
; 0000 0849             a[1] = a[0]+0x001;  //ster2
; 0000 084A             a[2] = a[4];        //ster4 ABS druciak
; 0000 084B             a[6] = a[5]+0x001;  //okrag
; 0000 084C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 084D 
; 0000 084E     break;
; 0000 084F 
; 0000 0850 
; 0000 0851       case 20:
_0xC2:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0xC3
; 0000 0852 
; 0000 0853             a[0] = 0x042;   //ster1
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	CALL SUBOPT_0x34
; 0000 0854             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0855             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0856             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x46
; 0000 0857             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0858             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0859 
; 0000 085A             a[1] = a[0]+0x001;  //ster2
; 0000 085B             a[2] = a[4];        //ster4 ABS druciak
; 0000 085C             a[6] = a[5]+0x001;  //okrag
; 0000 085D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 085E 
; 0000 085F     break;
; 0000 0860 
; 0000 0861 
; 0000 0862       case 21:
_0xC3:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0xC4
; 0000 0863 
; 0000 0864             a[0] = 0x04E;   //ster1
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	CALL SUBOPT_0x34
; 0000 0865             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0866             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x36
; 0000 0867             a[5] = 0x196;   //delta okrag
; 0000 0868             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0869             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 086A 
; 0000 086B             a[1] = a[0]+0x001;  //ster2
; 0000 086C             a[2] = a[4];        //ster4 ABS druciak
; 0000 086D             a[6] = a[5]+0x001;  //okrag
; 0000 086E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 086F 
; 0000 0870     break;
; 0000 0871 
; 0000 0872       case 22:
_0xC4:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0xC5
; 0000 0873 
; 0000 0874             a[0] = 0x0C2;   //ster1
	LDI  R30,LOW(194)
	LDI  R31,HIGH(194)
	CALL SUBOPT_0x34
; 0000 0875             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0876             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x43
; 0000 0877             a[5] = 0x190;   //delta okrag
; 0000 0878             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x513
; 0000 0879             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 087A 
; 0000 087B             a[1] = a[0]+0x001;  //ster2
; 0000 087C             a[2] = a[4];        //ster4 ABS druciak
; 0000 087D             a[6] = a[5]+0x001;  //okrag
; 0000 087E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 087F 
; 0000 0880     break;
; 0000 0881 
; 0000 0882 
; 0000 0883       case 23:
_0xC5:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0xC6
; 0000 0884 
; 0000 0885             a[0] = 0x0CE;   //ster1
	LDI  R30,LOW(206)
	LDI  R31,HIGH(206)
	CALL SUBOPT_0x34
; 0000 0886             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0887             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0888             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x515
; 0000 0889             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 088A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 088B 
; 0000 088C             a[1] = a[0]+0x001;  //ster2
; 0000 088D             a[2] = a[4];        //ster4 ABS druciak
; 0000 088E             a[6] = a[5]+0x001;  //okrag
; 0000 088F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0890 
; 0000 0891     break;
; 0000 0892 
; 0000 0893 
; 0000 0894       case 24:
_0xC6:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0xC7
; 0000 0895 
; 0000 0896             a[0] = 0x040;   //ster1
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL SUBOPT_0x34
; 0000 0897             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0898             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0899             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x46
; 0000 089A             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 089B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 089C 
; 0000 089D             a[1] = a[0]+0x001;  //ster2
; 0000 089E             a[2] = a[4];        //ster4 ABS druciak
; 0000 089F             a[6] = a[5]+0x001;  //okrag
; 0000 08A0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08A1 
; 0000 08A2     break;
; 0000 08A3 
; 0000 08A4       case 25:
_0xC7:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0xC8
; 0000 08A5 
; 0000 08A6             a[0] = 0x02E;   //ster1
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	CALL SUBOPT_0x34
; 0000 08A7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 08A8             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 08A9             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 08AA             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08AB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 08AC 
; 0000 08AD             a[1] = a[0]+0x001;  //ster2
; 0000 08AE             a[2] = a[4];        //ster4 ABS druciak
; 0000 08AF             a[6] = a[5]+0x001;  //okrag
; 0000 08B0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08B1 
; 0000 08B2     break;
; 0000 08B3 
; 0000 08B4       case 26:
_0xC8:
	CPI  R30,LOW(0x1A)
	LDI  R26,HIGH(0x1A)
	CPC  R31,R26
	BRNE _0xC9
; 0000 08B5 
; 0000 08B6             a[0] = 0x0FA;   //ster1
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x34
; 0000 08B7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 08B8             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 08B9             a[5] = 0x190;   //delta okrag
; 0000 08BA             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 08BB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 08BC 
; 0000 08BD             a[1] = a[0]+0x001;  //ster2
; 0000 08BE             a[2] = a[4];        //ster4 ABS druciak
; 0000 08BF             a[6] = a[5]+0x001;  //okrag
; 0000 08C0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08C1 
; 0000 08C2     break;
; 0000 08C3 
; 0000 08C4 
; 0000 08C5       case 27:
_0xC9:
	CPI  R30,LOW(0x1B)
	LDI  R26,HIGH(0x1B)
	CPC  R31,R26
	BRNE _0xCA
; 0000 08C6 
; 0000 08C7             a[0] = 0x06C;   //ster1
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	CALL SUBOPT_0x34
; 0000 08C8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 08C9             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 08CA             a[5] = 0x199;   //delta okrag
; 0000 08CB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08CC             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 08CD 
; 0000 08CE             a[1] = a[0]+0x001;  //ster2
; 0000 08CF             a[2] = a[4];        //ster4 ABS druciak
; 0000 08D0             a[6] = a[5]+0x001;  //okrag
; 0000 08D1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08D2 
; 0000 08D3     break;
; 0000 08D4 
; 0000 08D5 
; 0000 08D6       case 28:
_0xCA:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BRNE _0xCB
; 0000 08D7 
; 0000 08D8             a[0] = 0x0A4;   //ster1
	LDI  R30,LOW(164)
	LDI  R31,HIGH(164)
	CALL SUBOPT_0x34
; 0000 08D9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 08DA             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 08DB             a[5] = 0x199;   //delta okrag
	RJMP _0x515
; 0000 08DC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08DD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08DE 
; 0000 08DF             a[1] = a[0]+0x001;  //ster2
; 0000 08E0             a[2] = a[4];        //ster4 ABS druciak
; 0000 08E1             a[6] = a[5]+0x001;  //okrag
; 0000 08E2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08E3 
; 0000 08E4     break;
; 0000 08E5 
; 0000 08E6       case 29:
_0xCB:
	CPI  R30,LOW(0x1D)
	LDI  R26,HIGH(0x1D)
	CPC  R31,R26
	BRNE _0xCC
; 0000 08E7 
; 0000 08E8             a[0] = 0x02A;   //ster1
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	CALL SUBOPT_0x34
; 0000 08E9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 08EA             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 08EB             a[5] = 0x199;   //delta okrag
	RJMP _0x515
; 0000 08EC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08ED             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08EE 
; 0000 08EF             a[1] = a[0]+0x001;  //ster2
; 0000 08F0             a[2] = a[4];        //ster4 ABS druciak
; 0000 08F1             a[6] = a[5]+0x001;  //okrag
; 0000 08F2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08F3 
; 0000 08F4 
; 0000 08F5 
; 0000 08F6 
; 0000 08F7 
; 0000 08F8     break;
; 0000 08F9 
; 0000 08FA       case 30:
_0xCC:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0xCD
; 0000 08FB 
; 0000 08FC             a[0] = 0x094;   //ster1
	LDI  R30,LOW(148)
	LDI  R31,HIGH(148)
	CALL SUBOPT_0x34
; 0000 08FD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 08FE             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 08FF             a[5] = 0x190;   //delta okrag
; 0000 0900             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0901             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0902 
; 0000 0903             a[1] = a[0]+0x001;  //ster2
; 0000 0904             a[2] = a[4];        //ster4 ABS druciak
; 0000 0905             a[6] = a[5]+0x001;  //okrag
; 0000 0906             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0907 
; 0000 0908     break;
; 0000 0909 
; 0000 090A       case 31:
_0xCD:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0xCE
; 0000 090B 
; 0000 090C             a[0] = 0x06E;   //ster1
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	CALL SUBOPT_0x34
; 0000 090D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 090E             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 090F             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x515
; 0000 0910             a[7] = 0x12;  //ster3 INV krazek scierny
; 0000 0911             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0912 
; 0000 0913             a[1] = a[0]+0x001;  //ster2
; 0000 0914             a[2] = a[4];        //ster4 ABS druciak
; 0000 0915             a[6] = a[5]+0x001;  //okrag
; 0000 0916             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0917 
; 0000 0918     break;
; 0000 0919 
; 0000 091A 
; 0000 091B        case 32:
_0xCE:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xCF
; 0000 091C 
; 0000 091D             a[0] = 0x086;   //ster1
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	CALL SUBOPT_0x34
; 0000 091E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 091F             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0920             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 0921             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0922             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0923 
; 0000 0924             a[1] = a[0]+0x001;  //ster2
; 0000 0925             a[2] = a[4];        //ster4 ABS druciak
; 0000 0926             a[6] = a[5]+0x001;  //okrag
; 0000 0927             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0928 
; 0000 0929     break;
; 0000 092A 
; 0000 092B        case 33:
_0xCF:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0xD0
; 0000 092C 
; 0000 092D             a[0] = 0x08E;   //ster1
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	CALL SUBOPT_0x34
; 0000 092E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 092F             a[4] = 0x20;    //ster3 ABS krazek scierny
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	RJMP _0x516
; 0000 0930             a[5] = 0x19C;   //delta okrag
; 0000 0931             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0932             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0933 
; 0000 0934             a[1] = a[0]+0x001;  //ster2
; 0000 0935             a[2] = a[4];        //ster4 ABS druciak
; 0000 0936             a[6] = a[5]+0x001;  //okrag
; 0000 0937             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0938 
; 0000 0939     break;
; 0000 093A 
; 0000 093B 
; 0000 093C     case 34: //86-1349
_0xD0:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0xD1
; 0000 093D 
; 0000 093E             a[0] = 0x05A;   //ster1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x34
; 0000 093F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0940             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0941             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0942             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0943             a[9] = 0;       //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0944 
; 0000 0945             a[1] = a[0]+0x001;  //ster2
; 0000 0946             a[2] = a[4];        //ster4 ABS druciak
; 0000 0947             a[6] = a[5]+0x001;  //okrag
; 0000 0948             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0949 
; 0000 094A     break;
; 0000 094B 
; 0000 094C 
; 0000 094D     case 35:
_0xD1:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0xD2
; 0000 094E 
; 0000 094F             a[0] = 0x0DA;   //ster1
	LDI  R30,LOW(218)
	LDI  R31,HIGH(218)
	CALL SUBOPT_0x34
; 0000 0950             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0951             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0952             a[5] = 0x190;   //delta okrag
; 0000 0953             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0954             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0955 
; 0000 0956             a[1] = a[0]+0x001;  //ster2
; 0000 0957             a[2] = a[4];        //ster4 ABS druciak
; 0000 0958             a[6] = a[5]+0x001;  //okrag
; 0000 0959             a[8] = a[6]+0x001;  //-delta okrag
; 0000 095A 
; 0000 095B     break;
; 0000 095C 
; 0000 095D          case 36:
_0xD2:
	CPI  R30,LOW(0x24)
	LDI  R26,HIGH(0x24)
	CPC  R31,R26
	BRNE _0xD3
; 0000 095E 
; 0000 095F             a[0] = 0x0A2;   //ster1
	LDI  R30,LOW(162)
	LDI  R31,HIGH(162)
	CALL SUBOPT_0x34
; 0000 0960             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x4C
; 0000 0961             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 0962             a[5] = 0x196;   //delta okrag
; 0000 0963             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x37
; 0000 0964             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x39
	RJMP _0x514
; 0000 0965 
; 0000 0966             a[1] = a[0]+0x001;  //ster2
; 0000 0967             a[2] = a[4];        //ster4 ABS druciak
; 0000 0968             a[6] = a[5]+0x001;  //okrag
; 0000 0969             a[8] = a[6]+0x001;  //-delta okrag
; 0000 096A 
; 0000 096B     break;
; 0000 096C 
; 0000 096D          case 37:
_0xD3:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0xD4
; 0000 096E 
; 0000 096F             a[0] = 0x104;   //ster1
	LDI  R30,LOW(260)
	LDI  R31,HIGH(260)
	CALL SUBOPT_0x34
; 0000 0970             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0971             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0972             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x4D
; 0000 0973             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0974             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0975 
; 0000 0976             a[1] = a[0]+0x001;  //ster2
; 0000 0977             a[2] = a[4];        //ster4 ABS druciak
; 0000 0978             a[6] = a[5]+0x001;  //okrag
; 0000 0979             a[8] = a[6]+0x001;  //-delta okrag
; 0000 097A 
; 0000 097B     break;
; 0000 097C 
; 0000 097D          case 38:
_0xD4:
	CPI  R30,LOW(0x26)
	LDI  R26,HIGH(0x26)
	CPC  R31,R26
	BRNE _0xD5
; 0000 097E 
; 0000 097F             a[0] = 0x036;   //ster1
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	CALL SUBOPT_0x34
; 0000 0980             a[3] = 0x11 - 0x01;    //ster4 INV druciak  //korekta
	CALL SUBOPT_0x37
; 0000 0981             a[4] = 0x21;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x49
; 0000 0982             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x515
; 0000 0983             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0984             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0985 
; 0000 0986             a[1] = a[0]+0x001;  //ster2
; 0000 0987             a[2] = a[4];        //ster4 ABS druciak
; 0000 0988             a[6] = a[5]+0x001;  //okrag
; 0000 0989             a[8] = a[6]+0x001;  //-delta okrag
; 0000 098A 
; 0000 098B     break;
; 0000 098C 
; 0000 098D 
; 0000 098E          case 39:
_0xD5:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0xD6
; 0000 098F 
; 0000 0990             a[0] = 0x118;   //ster1
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	CALL SUBOPT_0x34
; 0000 0991             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0992             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0993             a[5] = 0x190;   //delta okrag
; 0000 0994             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0995             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0996 
; 0000 0997             a[1] = a[0]+0x001;  //ster2
; 0000 0998             a[2] = a[4];        //ster4 ABS druciak
; 0000 0999             a[6] = a[5]+0x001;  //okrag
; 0000 099A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 099B 
; 0000 099C     break;
; 0000 099D 
; 0000 099E 
; 0000 099F          case 40:
_0xD6:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0xD7
; 0000 09A0 
; 0000 09A1             a[0] = 0x0A6;   //ster1
	LDI  R30,LOW(166)
	LDI  R31,HIGH(166)
	CALL SUBOPT_0x34
; 0000 09A2             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x4C
; 0000 09A3             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 09A4             a[5] = 0x196;   //delta okrag
; 0000 09A5             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x513
; 0000 09A6             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09A7 
; 0000 09A8             a[1] = a[0]+0x001;  //ster2
; 0000 09A9             a[2] = a[4];        //ster4 ABS druciak
; 0000 09AA             a[6] = a[5]+0x001;  //okrag
; 0000 09AB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09AC 
; 0000 09AD     break;
; 0000 09AE 
; 0000 09AF          case 41:
_0xD7:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0xD8
; 0000 09B0 
; 0000 09B1             a[0] = 0x01E;   //ster1
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x34
; 0000 09B2             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 09B3             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 09B4             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3E
; 0000 09B5             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 09B6             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09B7 
; 0000 09B8             a[1] = a[0]+0x001;  //ster2
; 0000 09B9             a[2] = a[4];        //ster4 ABS druciak
; 0000 09BA             a[6] = a[5]+0x001;  //okrag
; 0000 09BB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09BC 
; 0000 09BD     break;
; 0000 09BE 
; 0000 09BF 
; 0000 09C0          case 42:
_0xD8:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0xD9
; 0000 09C1 
; 0000 09C2             a[0] = 0x05C;   //ster1
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x34
; 0000 09C3             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 09C4             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 09C5             a[5] = 0x196;   //delta okrag
; 0000 09C6             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 09C7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 09C8 
; 0000 09C9             a[1] = a[0]+0x001;  //ster2
; 0000 09CA             a[2] = a[4];        //ster4 ABS druciak
; 0000 09CB             a[6] = a[5]+0x001;  //okrag
; 0000 09CC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09CD 
; 0000 09CE     break;
; 0000 09CF 
; 0000 09D0 
; 0000 09D1          case 43:
_0xD9:
	CPI  R30,LOW(0x2B)
	LDI  R26,HIGH(0x2B)
	CPC  R31,R26
	BRNE _0xDA
; 0000 09D2 
; 0000 09D3             a[0] = 0x062;   //ster1
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL SUBOPT_0x34
; 0000 09D4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 09D5             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 09D6             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 09D7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 09D8             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 09D9 
; 0000 09DA             a[1] = a[0]+0x001;  //ster2
; 0000 09DB             a[2] = a[4];        //ster4 ABS druciak
; 0000 09DC             a[6] = a[5]+0x001;  //okrag
; 0000 09DD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09DE 
; 0000 09DF     break;
; 0000 09E0 
; 0000 09E1 
; 0000 09E2          case 44:
_0xDA:
	CPI  R30,LOW(0x2C)
	LDI  R26,HIGH(0x2C)
	CPC  R31,R26
	BRNE _0xDB
; 0000 09E3 
; 0000 09E4             a[0] = 0x;   //ster1
	CALL SUBOPT_0x4F
; 0000 09E5             a[3] = 0x;    //ster4 INV druciak
; 0000 09E6             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 09E7             a[5] = 0x;   //delta okrag
; 0000 09E8             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 09E9             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 09EA 
; 0000 09EB             a[1] = a[0]+0x001;  //ster2
; 0000 09EC             a[2] = a[4];        //ster4 ABS druciak
; 0000 09ED             a[6] = a[5]+0x001;  //okrag
; 0000 09EE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09EF 
; 0000 09F0     break;
; 0000 09F1 
; 0000 09F2 
; 0000 09F3          case 45:
_0xDB:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0xDC
; 0000 09F4 
; 0000 09F5             a[0] = 0x010;   //ster1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x34
; 0000 09F6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 09F7             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 09F8             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3E
; 0000 09F9             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 09FA             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 09FB 
; 0000 09FC             a[1] = a[0]+0x001;  //ster2
; 0000 09FD             a[2] = a[4];        //ster4 ABS druciak
; 0000 09FE             a[6] = a[5]+0x001;  //okrag
; 0000 09FF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A00 
; 0000 0A01     break;
; 0000 0A02 
; 0000 0A03 
; 0000 0A04     case 46:
_0xDC:
	CPI  R30,LOW(0x2E)
	LDI  R26,HIGH(0x2E)
	CPC  R31,R26
	BRNE _0xDD
; 0000 0A05 
; 0000 0A06             a[0] = 0x050;   //ster1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x34
; 0000 0A07             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0A08             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 0A09             a[5] = 0x196;   //delta okrag
; 0000 0A0A             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0A0B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A0C 
; 0000 0A0D             a[1] = a[0]+0x001;  //ster2
; 0000 0A0E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A0F             a[6] = a[5]+0x001;  //okrag
; 0000 0A10             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A11 
; 0000 0A12     break;
; 0000 0A13 
; 0000 0A14 
; 0000 0A15     case 47:
_0xDD:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BRNE _0xDE
; 0000 0A16 
; 0000 0A17             a[0] = 0x068;   //ster1
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	CALL SUBOPT_0x34
; 0000 0A18             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0A19             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0A1A             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x515
; 0000 0A1B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A1C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A1D 
; 0000 0A1E             a[1] = a[0]+0x001;  //ster2
; 0000 0A1F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A20             a[6] = a[5]+0x001;  //okrag
; 0000 0A21             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A22 
; 0000 0A23     break;
; 0000 0A24 
; 0000 0A25 
; 0000 0A26 
; 0000 0A27     case 48:
_0xDE:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0xDF
; 0000 0A28 
; 0000 0A29             a[0] = 0x;   //ster1
	CALL SUBOPT_0x4F
; 0000 0A2A             a[3] = 0x;    //ster4 INV druciak
; 0000 0A2B             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0A2C             a[5] = 0x;   //delta okrag
; 0000 0A2D             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0A2E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0A2F 
; 0000 0A30             a[1] = a[0]+0x001;  //ster2
; 0000 0A31             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A32             a[6] = a[5]+0x001;  //okrag
; 0000 0A33             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A34 
; 0000 0A35     break;
; 0000 0A36 
; 0000 0A37 
; 0000 0A38     case 49:
_0xDF:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xE0
; 0000 0A39 
; 0000 0A3A             a[0] = 0x024;   //ster1
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL SUBOPT_0x34
; 0000 0A3B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0A3C             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 0A3D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 0A3E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A3F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0A40 
; 0000 0A41             a[1] = a[0]+0x001;  //ster2
; 0000 0A42             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A43             a[6] = a[5]+0x001;  //okrag
; 0000 0A44             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A45 
; 0000 0A46     break;
; 0000 0A47 
; 0000 0A48 
; 0000 0A49     case 50:
_0xE0:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0xE1
; 0000 0A4A 
; 0000 0A4B             a[0] = 0x014;   //ster1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x34
; 0000 0A4C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0A4D             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0A4E             a[5] = 0x190;   //delta okrag
; 0000 0A4F             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0A50             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0A51 
; 0000 0A52             a[1] = a[0]+0x001;  //ster2
; 0000 0A53             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A54             a[6] = a[5]+0x001;  //okrag
; 0000 0A55             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A56 
; 0000 0A57     break;
; 0000 0A58 
; 0000 0A59     case 51:
_0xE1:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0xE2
; 0000 0A5A 
; 0000 0A5B             a[0] = 0x082;   //ster1
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	CALL SUBOPT_0x34
; 0000 0A5C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0A5D             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0A5E             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x4D
; 0000 0A5F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A60             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0A61 
; 0000 0A62             a[1] = a[0]+0x001;  //ster2
; 0000 0A63             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A64             a[6] = a[5]+0x001;  //okrag
; 0000 0A65             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A66 
; 0000 0A67     break;
; 0000 0A68 
; 0000 0A69     case 52:
_0xE2:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0xE3
; 0000 0A6A 
; 0000 0A6B             a[0] = 0x106;   //ster1
	LDI  R30,LOW(262)
	LDI  R31,HIGH(262)
	CALL SUBOPT_0x34
; 0000 0A6C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0A6D             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 0A6E             a[5] = 0x190;   //delta okrag
; 0000 0A6F             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0A70             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A71 
; 0000 0A72             a[1] = a[0]+0x001;  //ster2
; 0000 0A73             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A74             a[6] = a[5]+0x001;  //okrag
; 0000 0A75             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A76 
; 0000 0A77     break;
; 0000 0A78 
; 0000 0A79 
; 0000 0A7A     case 53:
_0xE3:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0xE4
; 0000 0A7B 
; 0000 0A7C             a[0] = 0x04C;   //ster1
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x34
; 0000 0A7D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0A7E             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 0A7F             a[5] = 0x196;   //delta okrag
	RJMP _0x515
; 0000 0A80             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A81             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A82 
; 0000 0A83             a[1] = a[0]+0x001;  //ster2
; 0000 0A84             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A85             a[6] = a[5]+0x001;  //okrag
; 0000 0A86             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A87 
; 0000 0A88     break;
; 0000 0A89 
; 0000 0A8A 
; 0000 0A8B     case 54:
_0xE4:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0xE5
; 0000 0A8C 
; 0000 0A8D             a[0] = 0x01C;   //ster1
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	CALL SUBOPT_0x34
; 0000 0A8E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0A8F             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0A90             a[5] = 0x190;   //delta okrag
; 0000 0A91             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0A92             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A93 
; 0000 0A94             a[1] = a[0]+0x001;  //ster2
; 0000 0A95             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A96             a[6] = a[5]+0x001;  //okrag
; 0000 0A97             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A98 
; 0000 0A99     break;
; 0000 0A9A 
; 0000 0A9B     case 55:
_0xE5:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0xE6
; 0000 0A9C 
; 0000 0A9D             a[0] = 0x114;   //ster1
	LDI  R30,LOW(276)
	LDI  R31,HIGH(276)
	CALL SUBOPT_0x34
; 0000 0A9E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0A9F             a[4] = 0x1A;    //ster3 ABS krazek scierny
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	RJMP _0x516
; 0000 0AA0             a[5] = 0x19C;   //delta okrag
; 0000 0AA1             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AA2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AA3 
; 0000 0AA4             a[1] = a[0]+0x001;  //ster2
; 0000 0AA5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AA6             a[6] = a[5]+0x001;  //okrag
; 0000 0AA7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AA8 
; 0000 0AA9     break;
; 0000 0AAA 
; 0000 0AAB 
; 0000 0AAC     case 56:
_0xE6:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0xE7
; 0000 0AAD 
; 0000 0AAE             a[0] = 0x0EE;   //ster1
	LDI  R30,LOW(238)
	LDI  R31,HIGH(238)
	CALL SUBOPT_0x34
; 0000 0AAF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0AB0             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 0AB1             a[5] = 0x190;   //delta okrag
; 0000 0AB2             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0AB3             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0AB4 
; 0000 0AB5             a[1] = a[0]+0x001;  //ster2
; 0000 0AB6             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AB7             a[6] = a[5]+0x001;  //okrag
; 0000 0AB8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AB9 
; 0000 0ABA     break;
; 0000 0ABB 
; 0000 0ABC 
; 0000 0ABD     case 57:
_0xE7:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0xE8
; 0000 0ABE 
; 0000 0ABF             a[0] = 0x0F8;   //ster1
	LDI  R30,LOW(248)
	LDI  R31,HIGH(248)
	CALL SUBOPT_0x34
; 0000 0AC0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0AC1             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x52
; 0000 0AC2             a[5] = 0x190;   //delta okrag
; 0000 0AC3             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0AC4             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0AC5 
; 0000 0AC6             a[1] = a[0]+0x001;  //ster2
; 0000 0AC7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AC8             a[6] = a[5]+0x001;  //okrag
; 0000 0AC9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ACA 
; 0000 0ACB     break;
; 0000 0ACC 
; 0000 0ACD 
; 0000 0ACE     case 58:
_0xE8:
	CPI  R30,LOW(0x3A)
	LDI  R26,HIGH(0x3A)
	CPC  R31,R26
	BRNE _0xE9
; 0000 0ACF 
; 0000 0AD0             a[0] = 0x0E4;   //ster1
	LDI  R30,LOW(228)
	LDI  R31,HIGH(228)
	CALL SUBOPT_0x34
; 0000 0AD1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0AD2             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0AD3             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0AD4             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AD5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0AD6 
; 0000 0AD7             a[1] = a[0]+0x001;  //ster2
; 0000 0AD8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AD9             a[6] = a[5]+0x001;  //okrag
; 0000 0ADA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ADB 
; 0000 0ADC     break;
; 0000 0ADD 
; 0000 0ADE 
; 0000 0ADF     case 59:
_0xE9:
	CPI  R30,LOW(0x3B)
	LDI  R26,HIGH(0x3B)
	CPC  R31,R26
	BRNE _0xEA
; 0000 0AE0 
; 0000 0AE1             a[0] = 0x052;   //ster1
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	CALL SUBOPT_0x34
; 0000 0AE2             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0AE3             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0AE4             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x45
; 0000 0AE5             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AE6             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0AE7 
; 0000 0AE8             a[1] = a[0]+0x001;  //ster2
; 0000 0AE9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AEA             a[6] = a[5]+0x001;  //okrag
; 0000 0AEB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AEC 
; 0000 0AED     break;
; 0000 0AEE 
; 0000 0AEF 
; 0000 0AF0     case 60:
_0xEA:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BRNE _0xEB
; 0000 0AF1 
; 0000 0AF2             a[0] = 0x090;   //ster1
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0x34
; 0000 0AF3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0AF4             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x54
; 0000 0AF5             a[5] = 0x190;   //delta okrag
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL SUBOPT_0x3E
; 0000 0AF6             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0AF7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0AF8 
; 0000 0AF9             a[1] = a[0]+0x001;  //ster2
; 0000 0AFA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AFB             a[6] = a[5]+0x001;  //okrag
; 0000 0AFC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AFD 
; 0000 0AFE     break;
; 0000 0AFF 
; 0000 0B00 
; 0000 0B01     case 61:
_0xEB:
	CPI  R30,LOW(0x3D)
	LDI  R26,HIGH(0x3D)
	CPC  R31,R26
	BRNE _0xEC
; 0000 0B02 
; 0000 0B03             a[0] = 0x0FC;   //ster1
	LDI  R30,LOW(252)
	LDI  R31,HIGH(252)
	CALL SUBOPT_0x34
; 0000 0B04             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0B05             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 0B06             a[5] = 0x190;   //delta okrag
; 0000 0B07             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0B08             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B09 
; 0000 0B0A             a[1] = a[0]+0x001;  //ster2
; 0000 0B0B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B0C             a[6] = a[5]+0x001;  //okrag
; 0000 0B0D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B0E 
; 0000 0B0F     break;
; 0000 0B10 
; 0000 0B11 
; 0000 0B12     case 62:
_0xEC:
	CPI  R30,LOW(0x3E)
	LDI  R26,HIGH(0x3E)
	CPC  R31,R26
	BRNE _0xED
; 0000 0B13 
; 0000 0B14             a[0] = 0x028;   //ster1
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x34
; 0000 0B15             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0B16             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0B17             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x515
; 0000 0B18             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B19             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B1A 
; 0000 0B1B             a[1] = a[0]+0x001;  //ster2
; 0000 0B1C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B1D             a[6] = a[5]+0x001;  //okrag
; 0000 0B1E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B1F 
; 0000 0B20     break;
; 0000 0B21 
; 0000 0B22 
; 0000 0B23     case 63:
_0xED:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0xEE
; 0000 0B24 
; 0000 0B25             a[0] = 0x034;   //ster1
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	CALL SUBOPT_0x34
; 0000 0B26             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0B27             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0B28             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x515
; 0000 0B29             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B2A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B2B 
; 0000 0B2C             a[1] = a[0]+0x001;  //ster2
; 0000 0B2D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B2E             a[6] = a[5]+0x001;  //okrag
; 0000 0B2F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B30 
; 0000 0B31     break;
; 0000 0B32 
; 0000 0B33 
; 0000 0B34     case 64:
_0xEE:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0xEF
; 0000 0B35 
; 0000 0B36             a[0] = 0x0EC;   //ster1
	LDI  R30,LOW(236)
	LDI  R31,HIGH(236)
	CALL SUBOPT_0x34
; 0000 0B37             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0B38             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x52
; 0000 0B39             a[5] = 0x190;   //delta okrag
; 0000 0B3A             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0B3B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B3C 
; 0000 0B3D             a[1] = a[0]+0x001;  //ster2
; 0000 0B3E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B3F             a[6] = a[5]+0x001;  //okrag
; 0000 0B40             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B41 
; 0000 0B42     break;
; 0000 0B43 
; 0000 0B44 
; 0000 0B45     case 65:
_0xEF:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0xF0
; 0000 0B46 
; 0000 0B47             a[0] = 0x0CC;   //ster1
	LDI  R30,LOW(204)
	LDI  R31,HIGH(204)
	CALL SUBOPT_0x34
; 0000 0B48             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0B49             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0B4A             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 0B4B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B4C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0B4D 
; 0000 0B4E             a[1] = a[0]+0x001;  //ster2
; 0000 0B4F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B50             a[6] = a[5]+0x001;  //okrag
; 0000 0B51             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B52 
; 0000 0B53     break;
; 0000 0B54 
; 0000 0B55 
; 0000 0B56     case 66:
_0xF0:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0xF1
; 0000 0B57 
; 0000 0B58             a[0] = 0x0BC;   //ster1
	LDI  R30,LOW(188)
	LDI  R31,HIGH(188)
	CALL SUBOPT_0x34
; 0000 0B59             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0B5A             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0B5B             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x56
; 0000 0B5C             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0B5D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B5E 
; 0000 0B5F             a[1] = a[0]+0x001;  //ster2
; 0000 0B60             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B61             a[6] = a[5]+0x001;  //okrag
; 0000 0B62             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B63 
; 0000 0B64     break;
; 0000 0B65 
; 0000 0B66 
; 0000 0B67     case 67:
_0xF1:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xF2
; 0000 0B68 
; 0000 0B69             a[0] = 0x09C;   //ster1
	LDI  R30,LOW(156)
	LDI  R31,HIGH(156)
	CALL SUBOPT_0x34
; 0000 0B6A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0B6B             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0B6C             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x515
; 0000 0B6D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B6E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B6F 
; 0000 0B70             a[1] = a[0]+0x001;  //ster2
; 0000 0B71             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B72             a[6] = a[5]+0x001;  //okrag
; 0000 0B73             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B74 
; 0000 0B75     break;
; 0000 0B76 
; 0000 0B77 
; 0000 0B78     case 68:
_0xF2:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0xF3
; 0000 0B79 
; 0000 0B7A             a[0] = 0x07C;   //ster1
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	CALL SUBOPT_0x34
; 0000 0B7B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0B7C             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0B7D             a[5] = 0x199;   //delta okrag
	RJMP _0x515
; 0000 0B7E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B7F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B80 
; 0000 0B81             a[1] = a[0]+0x001;  //ster2
; 0000 0B82             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B83             a[6] = a[5]+0x001;  //okrag
; 0000 0B84             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B85 
; 0000 0B86     break;
; 0000 0B87 
; 0000 0B88 
; 0000 0B89     case 69:
_0xF3:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BRNE _0xF4
; 0000 0B8A 
; 0000 0B8B             a[0] = 0x0D2;   //ster1
	LDI  R30,LOW(210)
	LDI  R31,HIGH(210)
	CALL SUBOPT_0x34
; 0000 0B8C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0B8D             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0B8E             a[5] = 0x193;   //delta okrag
	RJMP _0x515
; 0000 0B8F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B90             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B91 
; 0000 0B92             a[1] = a[0]+0x001;  //ster2
; 0000 0B93             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B94             a[6] = a[5]+0x001;  //okrag
; 0000 0B95             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B96 
; 0000 0B97     break;
; 0000 0B98 
; 0000 0B99 
; 0000 0B9A     case 70:
_0xF4:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BRNE _0xF5
; 0000 0B9B 
; 0000 0B9C             a[0] = 0x0E6;   //ster1
	LDI  R30,LOW(230)
	LDI  R31,HIGH(230)
	CALL SUBOPT_0x34
; 0000 0B9D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0B9E             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0B9F             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x56
; 0000 0BA0             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0BA1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0BA2 
; 0000 0BA3             a[1] = a[0]+0x001;  //ster2
; 0000 0BA4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BA5             a[6] = a[5]+0x001;  //okrag
; 0000 0BA6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BA7 
; 0000 0BA8     break;
; 0000 0BA9 
; 0000 0BAA 
; 0000 0BAB     case 71:
_0xF5:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BRNE _0xF6
; 0000 0BAC 
; 0000 0BAD             a[0] = 0x0B4;   //ster1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x34
; 0000 0BAE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0BAF             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0BB0             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0BB1             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BB2             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0BB3 
; 0000 0BB4             a[1] = a[0]+0x001;  //ster2
; 0000 0BB5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BB6             a[6] = a[5]+0x001;  //okrag
; 0000 0BB7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BB8 
; 0000 0BB9     break;
; 0000 0BBA 
; 0000 0BBB 
; 0000 0BBC     case 72:
_0xF6:
	CPI  R30,LOW(0x48)
	LDI  R26,HIGH(0x48)
	CPC  R31,R26
	BRNE _0xF7
; 0000 0BBD 
; 0000 0BBE             a[0] = 0x0AC;   //ster1
	LDI  R30,LOW(172)
	LDI  R31,HIGH(172)
	CALL SUBOPT_0x34
; 0000 0BBF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0BC0             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0BC1             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 0BC2             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BC3             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0BC4 
; 0000 0BC5             a[1] = a[0]+0x001;  //ster2
; 0000 0BC6             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BC7             a[6] = a[5]+0x001;  //okrag
; 0000 0BC8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BC9 
; 0000 0BCA     break;
; 0000 0BCB 
; 0000 0BCC 
; 0000 0BCD     case 73:
_0xF7:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BRNE _0xF8
; 0000 0BCE 
; 0000 0BCF             a[0] = 0x012;   //ster1
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CALL SUBOPT_0x34
; 0000 0BD0             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0BD1             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x50
; 0000 0BD2             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0BD3             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BD4             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0BD5 
; 0000 0BD6             a[1] = a[0]+0x001;  //ster2
; 0000 0BD7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BD8             a[6] = a[5]+0x001;  //okrag
; 0000 0BD9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BDA 
; 0000 0BDB     break;
; 0000 0BDC 
; 0000 0BDD 
; 0000 0BDE     case 74:
_0xF8:
	CPI  R30,LOW(0x4A)
	LDI  R26,HIGH(0x4A)
	CPC  R31,R26
	BRNE _0xF9
; 0000 0BDF 
; 0000 0BE0             a[0] = 0x0B2;   //ster1
	LDI  R30,LOW(178)
	LDI  R31,HIGH(178)
	CALL SUBOPT_0x34
; 0000 0BE1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0BE2             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 0BE3             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 0BE4             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BE5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0BE6 
; 0000 0BE7             a[1] = a[0]+0x001;  //ster2
; 0000 0BE8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BE9             a[6] = a[5]+0x001;  //okrag
; 0000 0BEA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BEB 
; 0000 0BEC     break;
; 0000 0BED 
; 0000 0BEE 
; 0000 0BEF     case 75:
_0xF9:
	CPI  R30,LOW(0x4B)
	LDI  R26,HIGH(0x4B)
	CPC  R31,R26
	BRNE _0xFA
; 0000 0BF0 
; 0000 0BF1             a[0] = 0x10C;   //ster1
	LDI  R30,LOW(268)
	LDI  R31,HIGH(268)
	CALL SUBOPT_0x34
; 0000 0BF2             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0BF3             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0BF4             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0BF5             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BF6             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0BF7 
; 0000 0BF8             a[1] = a[0]+0x001;  //ster2
; 0000 0BF9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BFA             a[6] = a[5]+0x001;  //okrag
; 0000 0BFB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BFC 
; 0000 0BFD     break;
; 0000 0BFE 
; 0000 0BFF 
; 0000 0C00     case 76:
_0xFA:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0xFB
; 0000 0C01 
; 0000 0C02             a[0] = 0x;   //ster1
	CALL SUBOPT_0x4F
; 0000 0C03             a[3] = 0x;    //ster4 INV druciak
; 0000 0C04             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0C05             a[5] = 0x;   //delta okrag
; 0000 0C06             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0C07             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0C08 
; 0000 0C09             a[1] = a[0]+0x001;  //ster2
; 0000 0C0A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C0B             a[6] = a[5]+0x001;  //okrag
; 0000 0C0C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C0D 
; 0000 0C0E     break;
; 0000 0C0F 
; 0000 0C10 
; 0000 0C11     case 77:
_0xFB:
	CPI  R30,LOW(0x4D)
	LDI  R26,HIGH(0x4D)
	CPC  R31,R26
	BRNE _0xFC
; 0000 0C12 
; 0000 0C13             a[0] = 0x026;   //ster1
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL SUBOPT_0x34
; 0000 0C14             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0C15             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x50
; 0000 0C16             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x515
; 0000 0C17             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C18             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C19 
; 0000 0C1A             a[1] = a[0]+0x001;  //ster2
; 0000 0C1B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C1C             a[6] = a[5]+0x001;  //okrag
; 0000 0C1D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C1E 
; 0000 0C1F     break;
; 0000 0C20 
; 0000 0C21 
; 0000 0C22     case 78:
_0xFC:
	CPI  R30,LOW(0x4E)
	LDI  R26,HIGH(0x4E)
	CPC  R31,R26
	BRNE _0xFD
; 0000 0C23 
; 0000 0C24             a[0] = 0x11C;   //ster1
	LDI  R30,LOW(284)
	LDI  R31,HIGH(284)
	CALL SUBOPT_0x34
; 0000 0C25             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0C26             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0C27             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x515
; 0000 0C28             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C29             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C2A 
; 0000 0C2B             a[1] = a[0]+0x001;  //ster2
; 0000 0C2C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C2D             a[6] = a[5]+0x001;  //okrag
; 0000 0C2E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C2F 
; 0000 0C30     break;
; 0000 0C31 
; 0000 0C32 
; 0000 0C33     case 79:
_0xFD:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0xFE
; 0000 0C34 
; 0000 0C35             a[0] = 0x112;   //ster1
	LDI  R30,LOW(274)
	LDI  R31,HIGH(274)
	CALL SUBOPT_0x34
; 0000 0C36             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0C37             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0C38             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x515
; 0000 0C39             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C3A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C3B 
; 0000 0C3C             a[1] = a[0]+0x001;  //ster2
; 0000 0C3D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C3E             a[6] = a[5]+0x001;  //okrag
; 0000 0C3F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C40 
; 0000 0C41     break;
; 0000 0C42 
; 0000 0C43     case 80:
_0xFE:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0xFF
; 0000 0C44 
; 0000 0C45             a[0] = 0x;   //ster1
	CALL SUBOPT_0x4F
; 0000 0C46             a[3] = 0x;    //ster4 INV druciak
; 0000 0C47             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0C48             a[5] = 0x;   //delta okrag
; 0000 0C49             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0C4A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0C4B 
; 0000 0C4C             a[1] = a[0]+0x001;  //ster2
; 0000 0C4D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C4E             a[6] = a[5]+0x001;  //okrag
; 0000 0C4F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C50 
; 0000 0C51     break;
; 0000 0C52 
; 0000 0C53     case 81:
_0xFF:
	CPI  R30,LOW(0x51)
	LDI  R26,HIGH(0x51)
	CPC  R31,R26
	BRNE _0x100
; 0000 0C54 
; 0000 0C55             a[0] = 0x0EA;   //ster1
	LDI  R30,LOW(234)
	LDI  R31,HIGH(234)
	CALL SUBOPT_0x34
; 0000 0C56             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0C57             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0C58             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 0C59             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C5A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0C5B 
; 0000 0C5C             a[1] = a[0]+0x001;  //ster2
; 0000 0C5D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C5E             a[6] = a[5]+0x001;  //okrag
; 0000 0C5F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C60 
; 0000 0C61     break;
; 0000 0C62 
; 0000 0C63 
; 0000 0C64     case 82:
_0x100:
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BRNE _0x101
; 0000 0C65 
; 0000 0C66             a[0] = 0x0D8;   //ster1
	LDI  R30,LOW(216)
	LDI  R31,HIGH(216)
	CALL SUBOPT_0x34
; 0000 0C67             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0C68             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0C69             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 0C6A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C6B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0C6C 
; 0000 0C6D             a[1] = a[0]+0x001;  //ster2
; 0000 0C6E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C6F             a[6] = a[5]+0x001;  //okrag
; 0000 0C70             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C71 
; 0000 0C72     break;
; 0000 0C73 
; 0000 0C74 
; 0000 0C75     case 83:
_0x101:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x102
; 0000 0C76 
; 0000 0C77             a[0] = 0x08C;   //ster1
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	CALL SUBOPT_0x34
; 0000 0C78             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0C79             a[4] = 0x22;    //ster3 ABS krazek scierny
	LDI  R26,LOW(34)
	LDI  R27,HIGH(34)
	CALL SUBOPT_0x5A
; 0000 0C7A             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x515
; 0000 0C7B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C7C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C7D 
; 0000 0C7E             a[1] = a[0]+0x001;  //ster2
; 0000 0C7F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C80             a[6] = a[5]+0x001;  //okrag
; 0000 0C81             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C82 
; 0000 0C83     break;
; 0000 0C84 
; 0000 0C85 
; 0000 0C86     case 84:
_0x102:
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x103
; 0000 0C87 
; 0000 0C88             a[0] = 0x0A0;   //ster1
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	CALL SUBOPT_0x34
; 0000 0C89             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x5B
; 0000 0C8A             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0C8B             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5C
; 0000 0C8C             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x513
; 0000 0C8D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C8E 
; 0000 0C8F             a[1] = a[0]+0x001;  //ster2
; 0000 0C90             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C91             a[6] = a[5]+0x001;  //okrag
; 0000 0C92             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C93 
; 0000 0C94     break;
; 0000 0C95 
; 0000 0C96 
; 0000 0C97    case 85:
_0x103:
	CPI  R30,LOW(0x55)
	LDI  R26,HIGH(0x55)
	CPC  R31,R26
	BRNE _0x104
; 0000 0C98 
; 0000 0C99             a[0] = 0x0AE;   //ster1
	LDI  R30,LOW(174)
	LDI  R31,HIGH(174)
	CALL SUBOPT_0x34
; 0000 0C9A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0C9B             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0C9C             a[5] = 0x193;   //delta okrag
	RJMP _0x515
; 0000 0C9D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C9E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C9F 
; 0000 0CA0             a[1] = a[0]+0x001;  //ster2
; 0000 0CA1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CA2             a[6] = a[5]+0x001;  //okrag
; 0000 0CA3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CA4 
; 0000 0CA5     break;
; 0000 0CA6 
; 0000 0CA7     case 86:
_0x104:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BRNE _0x105
; 0000 0CA8 
; 0000 0CA9             a[0] = 0x0F6;   //ster1
	LDI  R30,LOW(246)
	LDI  R31,HIGH(246)
	CALL SUBOPT_0x34
; 0000 0CAA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0CAB             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0CAC             a[5] = 0x190;   //delta okrag
	RJMP _0x515
; 0000 0CAD             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CAE             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CAF 
; 0000 0CB0             a[1] = a[0]+0x001;  //ster2
; 0000 0CB1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CB2             a[6] = a[5]+0x001;  //okrag
; 0000 0CB3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CB4 
; 0000 0CB5     break;
; 0000 0CB6 
; 0000 0CB7 
; 0000 0CB8     case 87:
_0x105:
	CPI  R30,LOW(0x57)
	LDI  R26,HIGH(0x57)
	CPC  R31,R26
	BRNE _0x106
; 0000 0CB9 
; 0000 0CBA             a[0] = 0x0C4;   //ster1
	LDI  R30,LOW(196)
	LDI  R31,HIGH(196)
	CALL SUBOPT_0x34
; 0000 0CBB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0CBC             a[4] = 0x23;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5D
; 0000 0CBD             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x45
; 0000 0CBE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CBF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0CC0 
; 0000 0CC1             a[1] = a[0]+0x001;  //ster2
; 0000 0CC2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CC3             a[6] = a[5]+0x001;  //okrag
; 0000 0CC4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CC5 
; 0000 0CC6     break;
; 0000 0CC7 
; 0000 0CC8 
; 0000 0CC9     case 88:
_0x106:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x107
; 0000 0CCA 
; 0000 0CCB             a[0] = 0x07E;   //ster1
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	CALL SUBOPT_0x34
; 0000 0CCC             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x5B
; 0000 0CCD             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0CCE             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5C
; 0000 0CCF             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x37
; 0000 0CD0             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x39
	RJMP _0x514
; 0000 0CD1 
; 0000 0CD2             a[1] = a[0]+0x001;  //ster2
; 0000 0CD3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CD4             a[6] = a[5]+0x001;  //okrag
; 0000 0CD5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CD6 
; 0000 0CD7     break;
; 0000 0CD8 
; 0000 0CD9 
; 0000 0CDA     case 89:
_0x107:
	CPI  R30,LOW(0x59)
	LDI  R26,HIGH(0x59)
	CPC  R31,R26
	BRNE _0x108
; 0000 0CDB 
; 0000 0CDC             a[0] = 0x02C;   //ster1
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x34
; 0000 0CDD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0CDE             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x54
; 0000 0CDF             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0CE0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CE1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0CE2 
; 0000 0CE3             a[1] = a[0]+0x001;  //ster2
; 0000 0CE4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CE5             a[6] = a[5]+0x001;  //okrag
; 0000 0CE6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CE7 
; 0000 0CE8     break;
; 0000 0CE9 
; 0000 0CEA 
; 0000 0CEB     case 90:
_0x108:
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BRNE _0x109
; 0000 0CEC 
; 0000 0CED             a[0] = 0x0F0;   //ster1
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	CALL SUBOPT_0x34
; 0000 0CEE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0CEF             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x36
; 0000 0CF0             a[5] = 0x196;   //delta okrag
; 0000 0CF1             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0CF2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CF3 
; 0000 0CF4             a[1] = a[0]+0x001;  //ster2
; 0000 0CF5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CF6             a[6] = a[5]+0x001;  //okrag
; 0000 0CF7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CF8 
; 0000 0CF9     break;
; 0000 0CFA 
; 0000 0CFB 
; 0000 0CFC     case 91:
_0x109:
	CPI  R30,LOW(0x5B)
	LDI  R26,HIGH(0x5B)
	CPC  R31,R26
	BRNE _0x10A
; 0000 0CFD 
; 0000 0CFE             a[0] = 0x0A8;   //ster1
	LDI  R30,LOW(168)
	LDI  R31,HIGH(168)
	CALL SUBOPT_0x34
; 0000 0CFF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0D00             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0D01             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x515
; 0000 0D02             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D03             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D04 
; 0000 0D05             a[1] = a[0]+0x001;  //ster2
; 0000 0D06             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D07             a[6] = a[5]+0x001;  //okrag
; 0000 0D08             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D09 
; 0000 0D0A     break;
; 0000 0D0B 
; 0000 0D0C 
; 0000 0D0D     case 92:
_0x10A:
	CPI  R30,LOW(0x5C)
	LDI  R26,HIGH(0x5C)
	CPC  R31,R26
	BRNE _0x10B
; 0000 0D0E 
; 0000 0D0F             a[0] = 0x;   //ster1
	CALL SUBOPT_0x4F
; 0000 0D10             a[3] = 0x;    //ster4 INV druciak
; 0000 0D11             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0D12             a[5] = 0x;   //delta okrag
; 0000 0D13             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0D14             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0D15 
; 0000 0D16             a[1] = a[0]+0x001;  //ster2
; 0000 0D17             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D18             a[6] = a[5]+0x001;  //okrag
; 0000 0D19             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D1A 
; 0000 0D1B     break;
; 0000 0D1C 
; 0000 0D1D 
; 0000 0D1E     case 93:
_0x10B:
	CPI  R30,LOW(0x5D)
	LDI  R26,HIGH(0x5D)
	CPC  R31,R26
	BRNE _0x10C
; 0000 0D1F 
; 0000 0D20             a[0] = 0x030;   //ster1
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x34
; 0000 0D21             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0D22             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x54
; 0000 0D23             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x515
; 0000 0D24             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D25             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D26 
; 0000 0D27             a[1] = a[0]+0x001;  //ster2
; 0000 0D28             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D29             a[6] = a[5]+0x001;  //okrag
; 0000 0D2A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D2B 
; 0000 0D2C     break;
; 0000 0D2D 
; 0000 0D2E 
; 0000 0D2F     case 94:
_0x10C:
	CPI  R30,LOW(0x5E)
	LDI  R26,HIGH(0x5E)
	CPC  R31,R26
	BRNE _0x10D
; 0000 0D30 
; 0000 0D31             a[0] = 0x0F4;   //ster1
	LDI  R30,LOW(244)
	LDI  R31,HIGH(244)
	CALL SUBOPT_0x34
; 0000 0D32             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0D33             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x36
; 0000 0D34             a[5] = 0x196;   //delta okrag
; 0000 0D35             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0D36             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0D37 
; 0000 0D38             a[1] = a[0]+0x001;  //ster2
; 0000 0D39             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D3A             a[6] = a[5]+0x001;  //okrag
; 0000 0D3B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D3C 
; 0000 0D3D     break;
; 0000 0D3E 
; 0000 0D3F 
; 0000 0D40     case 95:
_0x10D:
	CPI  R30,LOW(0x5F)
	LDI  R26,HIGH(0x5F)
	CPC  R31,R26
	BRNE _0x10E
; 0000 0D41 
; 0000 0D42             a[0] = 0x09E;   //ster1
	LDI  R30,LOW(158)
	LDI  R31,HIGH(158)
	CALL SUBOPT_0x34
; 0000 0D43             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0D44             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 0D45             a[5] = 0x199;   //delta okrag
; 0000 0D46             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D47             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0D48 
; 0000 0D49             a[1] = a[0]+0x001;  //ster2
; 0000 0D4A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D4B             a[6] = a[5]+0x001;  //okrag
; 0000 0D4C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D4D 
; 0000 0D4E     break;
; 0000 0D4F 
; 0000 0D50     case 96:
_0x10E:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x10F
; 0000 0D51 
; 0000 0D52             a[0] = 0x;   //ster1
	CALL SUBOPT_0x4F
; 0000 0D53             a[3] = 0x;    //ster4 INV druciak
; 0000 0D54             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0D55             a[5] = 0x;   //delta okrag
; 0000 0D56             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0D57             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0D58 
; 0000 0D59             a[1] = a[0]+0x001;  //ster2
; 0000 0D5A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D5B             a[6] = a[5]+0x001;  //okrag
; 0000 0D5C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D5D 
; 0000 0D5E     break;
; 0000 0D5F 
; 0000 0D60 
; 0000 0D61     case 97:
_0x10F:
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BRNE _0x110
; 0000 0D62 
; 0000 0D63             a[0] = 0x06A;   //ster1
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	CALL SUBOPT_0x34
; 0000 0D64             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0D65             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0D66             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 0D67             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D68             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0D69 
; 0000 0D6A             a[1] = a[0]+0x001;  //ster2
; 0000 0D6B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D6C             a[6] = a[5]+0x001;  //okrag
; 0000 0D6D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D6E 
; 0000 0D6F     break;
; 0000 0D70 
; 0000 0D71 
; 0000 0D72     case 98:
_0x110:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x111
; 0000 0D73 
; 0000 0D74             a[0] = 0x0BE;   //ster1
	LDI  R30,LOW(190)
	LDI  R31,HIGH(190)
	CALL SUBOPT_0x34
; 0000 0D75             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0D76             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3A
; 0000 0D77             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0D78             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0D79             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0D7A 
; 0000 0D7B             a[1] = a[0]+0x001;  //ster2
; 0000 0D7C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D7D             a[6] = a[5]+0x001;  //okrag
; 0000 0D7E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D7F 
; 0000 0D80     break;
; 0000 0D81 
; 0000 0D82 
; 0000 0D83     case 99:
_0x111:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x112
; 0000 0D84 
; 0000 0D85             a[0] = 0x0BA;   //ster1
	LDI  R30,LOW(186)
	LDI  R31,HIGH(186)
	CALL SUBOPT_0x34
; 0000 0D86             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0D87             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0D88             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x515
; 0000 0D89             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D8A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D8B 
; 0000 0D8C             a[1] = a[0]+0x001;  //ster2
; 0000 0D8D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D8E             a[6] = a[5]+0x001;  //okrag
; 0000 0D8F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D90 
; 0000 0D91     break;
; 0000 0D92 
; 0000 0D93 
; 0000 0D94     case 100:
_0x112:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRNE _0x113
; 0000 0D95 
; 0000 0D96             a[0] = 0x060;   //ster1
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x34
; 0000 0D97             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0D98             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 0D99             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3B
; 0000 0D9A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D9B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0D9C 
; 0000 0D9D             a[1] = a[0]+0x001;  //ster2
; 0000 0D9E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D9F             a[6] = a[5]+0x001;  //okrag
; 0000 0DA0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DA1 
; 0000 0DA2     break;
; 0000 0DA3 
; 0000 0DA4 
; 0000 0DA5     case 101:
_0x113:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x114
; 0000 0DA6 
; 0000 0DA7             a[0] = 0x070;   //ster1
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	CALL SUBOPT_0x34
; 0000 0DA8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0DA9             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0DAA             a[5] = 0x199;   //delta okrag
	RJMP _0x515
; 0000 0DAB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DAC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DAD 
; 0000 0DAE             a[1] = a[0]+0x001;  //ster2
; 0000 0DAF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DB0             a[6] = a[5]+0x001;  //okrag
; 0000 0DB1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DB2 
; 0000 0DB3     break;
; 0000 0DB4 
; 0000 0DB5 
; 0000 0DB6     case 102:
_0x114:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BRNE _0x115
; 0000 0DB7 
; 0000 0DB8             a[0] = 0x08A;   //ster1
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	CALL SUBOPT_0x34
; 0000 0DB9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0DBA             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3A
; 0000 0DBB             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0DBC             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0DBD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DBE 
; 0000 0DBF             a[1] = a[0]+0x001;  //ster2
; 0000 0DC0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DC1             a[6] = a[5]+0x001;  //okrag
; 0000 0DC2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DC3 
; 0000 0DC4     break;
; 0000 0DC5 
; 0000 0DC6 
; 0000 0DC7     case 103:
_0x115:
	CPI  R30,LOW(0x67)
	LDI  R26,HIGH(0x67)
	CPC  R31,R26
	BRNE _0x116
; 0000 0DC8 
; 0000 0DC9             a[0] = 0x080;   //ster1
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CALL SUBOPT_0x34
; 0000 0DCA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0DCB             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0DCC             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x45
; 0000 0DCD             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DCE             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0DCF 
; 0000 0DD0             a[1] = a[0]+0x001;  //ster2
; 0000 0DD1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DD2             a[6] = a[5]+0x001;  //okrag
; 0000 0DD3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DD4 
; 0000 0DD5     break;
; 0000 0DD6 
; 0000 0DD7 
; 0000 0DD8     case 104:
_0x116:
	CPI  R30,LOW(0x68)
	LDI  R26,HIGH(0x68)
	CPC  R31,R26
	BRNE _0x117
; 0000 0DD9 
; 0000 0DDA             a[0] = 0x0B6;   //ster1
	LDI  R30,LOW(182)
	LDI  R31,HIGH(182)
	CALL SUBOPT_0x34
; 0000 0DDB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0DDC             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 0DDD             a[5] = 0x196;   //delta okrag
	RJMP _0x515
; 0000 0DDE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DDF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DE0 
; 0000 0DE1             a[1] = a[0]+0x001;  //ster2
; 0000 0DE2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DE3             a[6] = a[5]+0x001;  //okrag
; 0000 0DE4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DE5 
; 0000 0DE6     break;
; 0000 0DE7 
; 0000 0DE8 
; 0000 0DE9     case 105:
_0x117:
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x118
; 0000 0DEA 
; 0000 0DEB             a[0] = 0x044;   //ster1
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	CALL SUBOPT_0x34
; 0000 0DEC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0DED             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5F
; 0000 0DEE             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x46
; 0000 0DEF             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0DF0             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0DF1 
; 0000 0DF2             a[1] = a[0]+0x001;  //ster2
; 0000 0DF3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DF4             a[6] = a[5]+0x001;  //okrag
; 0000 0DF5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DF6 
; 0000 0DF7     break;
; 0000 0DF8 
; 0000 0DF9 
; 0000 0DFA     case 106:
_0x118:
	CPI  R30,LOW(0x6A)
	LDI  R26,HIGH(0x6A)
	CPC  R31,R26
	BRNE _0x119
; 0000 0DFB 
; 0000 0DFC             a[0] = 0x03A;   //ster1
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	CALL SUBOPT_0x34
; 0000 0DFD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0DFE             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0DFF             a[5] = 0x190;   //delta okrag
; 0000 0E00             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0E01             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E02 
; 0000 0E03             a[1] = a[0]+0x001;  //ster2
; 0000 0E04             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E05             a[6] = a[5]+0x001;  //okrag
; 0000 0E06             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E07 
; 0000 0E08     break;
; 0000 0E09 
; 0000 0E0A 
; 0000 0E0B     case 107:
_0x119:
	CPI  R30,LOW(0x6B)
	LDI  R26,HIGH(0x6B)
	CPC  R31,R26
	BRNE _0x11A
; 0000 0E0C 
; 0000 0E0D             a[0] = 0x;   //ster1
	CALL SUBOPT_0x4F
; 0000 0E0E             a[3] = 0x;    //ster4 INV druciak
; 0000 0E0F             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0E10             a[5] = 0x;   //delta okrag
; 0000 0E11             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0E12             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0E13 
; 0000 0E14             a[1] = a[0]+0x001;  //ster2
; 0000 0E15             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E16             a[6] = a[5]+0x001;  //okrag
; 0000 0E17             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E18 
; 0000 0E19     break;
; 0000 0E1A 
; 0000 0E1B 
; 0000 0E1C     case 108:
_0x11A:
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BRNE _0x11B
; 0000 0E1D 
; 0000 0E1E             a[0] = 0x0C6;   //ster1
	LDI  R30,LOW(198)
	LDI  R31,HIGH(198)
	CALL SUBOPT_0x34
; 0000 0E1F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0E20             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0E21             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x56
; 0000 0E22             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0E23             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0E24 
; 0000 0E25             a[1] = a[0]+0x001;  //ster2
; 0000 0E26             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E27             a[6] = a[5]+0x001;  //okrag
; 0000 0E28             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E29 
; 0000 0E2A     break;
; 0000 0E2B 
; 0000 0E2C 
; 0000 0E2D     case 109:
_0x11B:
	CPI  R30,LOW(0x6D)
	LDI  R26,HIGH(0x6D)
	CPC  R31,R26
	BRNE _0x11C
; 0000 0E2E 
; 0000 0E2F             a[0] = 0x00A;   //ster1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x34
; 0000 0E30             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0E31             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x38
; 0000 0E32             a[5] = 0x190;   //delta okrag
; 0000 0E33             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x513
; 0000 0E34             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E35 
; 0000 0E36             a[1] = a[0]+0x001;  //ster2
; 0000 0E37             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E38             a[6] = a[5]+0x001;  //okrag
; 0000 0E39             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E3A 
; 0000 0E3B     break;
; 0000 0E3C 
; 0000 0E3D 
; 0000 0E3E     case 110:
_0x11C:
	CPI  R30,LOW(0x6E)
	LDI  R26,HIGH(0x6E)
	CPC  R31,R26
	BRNE _0x11D
; 0000 0E3F 
; 0000 0E40             a[0] = 0x032;   //ster1
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x34
; 0000 0E41             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0E42             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0E43             a[5] = 0x190;   //delta okrag
; 0000 0E44             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0E45             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0E46 
; 0000 0E47             a[1] = a[0]+0x001;  //ster2
; 0000 0E48             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E49             a[6] = a[5]+0x001;  //okrag
; 0000 0E4A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E4B 
; 0000 0E4C     break;
; 0000 0E4D 
; 0000 0E4E 
; 0000 0E4F     case 111:
_0x11D:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x11E
; 0000 0E50 
; 0000 0E51             a[0] = 0x;   //ster1
	CALL SUBOPT_0x4F
; 0000 0E52             a[3] = 0x;    //ster4 INV druciak
; 0000 0E53             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0E54             a[5] = 0x;   //delta okrag
; 0000 0E55             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0E56             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0E57 
; 0000 0E58             a[1] = a[0]+0x001;  //ster2
; 0000 0E59             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E5A             a[6] = a[5]+0x001;  //okrag
; 0000 0E5B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E5C 
; 0000 0E5D     break;
; 0000 0E5E 
; 0000 0E5F 
; 0000 0E60     case 112:
_0x11E:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x11F
; 0000 0E61 
; 0000 0E62             a[0] = 0x0E2;   //ster1
	LDI  R30,LOW(226)
	LDI  R31,HIGH(226)
	CALL SUBOPT_0x34
; 0000 0E63             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0E64             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0E65             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x56
; 0000 0E66             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0E67             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E68 
; 0000 0E69             a[1] = a[0]+0x001;  //ster2
; 0000 0E6A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E6B             a[6] = a[5]+0x001;  //okrag
; 0000 0E6C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E6D 
; 0000 0E6E     break;
; 0000 0E6F 
; 0000 0E70 
; 0000 0E71     case 113:
_0x11F:
	CPI  R30,LOW(0x71)
	LDI  R26,HIGH(0x71)
	CPC  R31,R26
	BRNE _0x120
; 0000 0E72 
; 0000 0E73             a[0] = 0x0D4;   //ster1
	LDI  R30,LOW(212)
	LDI  R31,HIGH(212)
	CALL SUBOPT_0x34
; 0000 0E74             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0E75             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x60
; 0000 0E76             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x56
; 0000 0E77             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0E78             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0E79 
; 0000 0E7A             a[1] = a[0]+0x001;  //ster2
; 0000 0E7B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E7C             a[6] = a[5]+0x001;  //okrag
; 0000 0E7D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E7E 
; 0000 0E7F     break;
; 0000 0E80 
; 0000 0E81 
; 0000 0E82     case 114:
_0x120:
	CPI  R30,LOW(0x72)
	LDI  R26,HIGH(0x72)
	CPC  R31,R26
	BRNE _0x121
; 0000 0E83 
; 0000 0E84             a[0] = 0x04A;   //ster1
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	CALL SUBOPT_0x34
; 0000 0E85             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0E86             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x61
; 0000 0E87             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5C
; 0000 0E88             a[7] = 0x0F;    //ster3 INV krazek scierny
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	CALL SUBOPT_0x3D
; 0000 0E89             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0E8A 
; 0000 0E8B             a[1] = a[0]+0x001;  //ster2
; 0000 0E8C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E8D             a[6] = a[5]+0x001;  //okrag
; 0000 0E8E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E8F 
; 0000 0E90     break;
; 0000 0E91 
; 0000 0E92 
; 0000 0E93     case 115:
_0x121:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x122
; 0000 0E94 
; 0000 0E95             a[0] = 0x076;   //ster1
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	CALL SUBOPT_0x34
; 0000 0E96             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x62
; 0000 0E97             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0E98             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x3E
; 0000 0E99             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0E9A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0E9B 
; 0000 0E9C             a[1] = a[0]+0x001;  //ster2
; 0000 0E9D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E9E             a[6] = a[5]+0x001;  //okrag
; 0000 0E9F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EA0 
; 0000 0EA1     break;
; 0000 0EA2 
; 0000 0EA3 
; 0000 0EA4     case 116:
_0x122:
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BRNE _0x123
; 0000 0EA5 
; 0000 0EA6             a[0] = 0x092;   //ster1
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	CALL SUBOPT_0x34
; 0000 0EA7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0EA8             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0EA9             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x515
; 0000 0EAA             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0EAB             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EAC 
; 0000 0EAD             a[1] = a[0]+0x001;  //ster2
; 0000 0EAE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EAF             a[6] = a[5]+0x001;  //okrag
; 0000 0EB0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EB1 
; 0000 0EB2     break;
; 0000 0EB3 
; 0000 0EB4 
; 0000 0EB5 
; 0000 0EB6     case 117:
_0x123:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x124
; 0000 0EB7 
; 0000 0EB8             a[0] = 0x11A;   //ster1
	LDI  R30,LOW(282)
	LDI  R31,HIGH(282)
	CALL SUBOPT_0x34
; 0000 0EB9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0EBA             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x60
; 0000 0EBB             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x56
; 0000 0EBC             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0EBD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EBE 
; 0000 0EBF             a[1] = a[0]+0x001;  //ster2
; 0000 0EC0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EC1             a[6] = a[5]+0x001;  //okrag
; 0000 0EC2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EC3 
; 0000 0EC4     break;
; 0000 0EC5 
; 0000 0EC6 
; 0000 0EC7 
; 0000 0EC8     case 118:
_0x124:
	CPI  R30,LOW(0x76)
	LDI  R26,HIGH(0x76)
	CPC  R31,R26
	BRNE _0x125
; 0000 0EC9 
; 0000 0ECA             a[0] = 0x056;   //ster1
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	CALL SUBOPT_0x34
; 0000 0ECB             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0ECC             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x61
; 0000 0ECD             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x56
; 0000 0ECE             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0ECF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0ED0 
; 0000 0ED1             a[1] = a[0]+0x001;  //ster2
; 0000 0ED2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0ED3             a[6] = a[5]+0x001;  //okrag
; 0000 0ED4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ED5 
; 0000 0ED6     break;
; 0000 0ED7 
; 0000 0ED8 
; 0000 0ED9     case 119:
_0x125:
	CPI  R30,LOW(0x77)
	LDI  R26,HIGH(0x77)
	CPC  R31,R26
	BRNE _0x126
; 0000 0EDA 
; 0000 0EDB             a[0] = 0x072;   //ster1
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	CALL SUBOPT_0x34
; 0000 0EDC             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x62
; 0000 0EDD             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0EDE             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x3E
; 0000 0EDF             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0EE0             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EE1 
; 0000 0EE2             a[1] = a[0]+0x001;  //ster2
; 0000 0EE3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EE4             a[6] = a[5]+0x001;  //okrag
; 0000 0EE5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EE6 
; 0000 0EE7     break;
; 0000 0EE8 
; 0000 0EE9 
; 0000 0EEA     case 120:
_0x126:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x127
; 0000 0EEB 
; 0000 0EEC             a[0] = 0x0D0;   //ster1
	LDI  R30,LOW(208)
	LDI  R31,HIGH(208)
	CALL SUBOPT_0x34
; 0000 0EED             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0EEE             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0EEF             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0EF0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0EF1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0EF2 
; 0000 0EF3             a[1] = a[0]+0x001;  //ster2
; 0000 0EF4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EF5             a[6] = a[5]+0x001;  //okrag
; 0000 0EF6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EF7 
; 0000 0EF8     break;
; 0000 0EF9 
; 0000 0EFA 
; 0000 0EFB     case 121:
_0x127:
	CPI  R30,LOW(0x79)
	LDI  R26,HIGH(0x79)
	CPC  R31,R26
	BRNE _0x128
; 0000 0EFC 
; 0000 0EFD             a[0] = 0x048;   //ster1
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	CALL SUBOPT_0x34
; 0000 0EFE             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0EFF             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x61
; 0000 0F00             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x56
; 0000 0F01             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0F02             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0F03 
; 0000 0F04             a[1] = a[0]+0x001;  //ster2
; 0000 0F05             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F06             a[6] = a[5]+0x001;  //okrag
; 0000 0F07             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F08 
; 0000 0F09     break;
; 0000 0F0A 
; 0000 0F0B 
; 0000 0F0C     case 122:
_0x128:
	CPI  R30,LOW(0x7A)
	LDI  R26,HIGH(0x7A)
	CPC  R31,R26
	BRNE _0x129
; 0000 0F0D 
; 0000 0F0E             a[0] = 0x09A;   //ster1
	LDI  R30,LOW(154)
	LDI  R31,HIGH(154)
	CALL SUBOPT_0x34
; 0000 0F0F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0F10             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0F11             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0F12             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F13             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0F14 
; 0000 0F15             a[1] = a[0]+0x001;  //ster2
; 0000 0F16             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F17             a[6] = a[5]+0x001;  //okrag
; 0000 0F18             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F19 
; 0000 0F1A     break;
; 0000 0F1B 
; 0000 0F1C 
; 0000 0F1D     case 123:
_0x129:
	CPI  R30,LOW(0x7B)
	LDI  R26,HIGH(0x7B)
	CPC  R31,R26
	BRNE _0x12A
; 0000 0F1E 
; 0000 0F1F             a[0] = 0x046;   //ster1
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL SUBOPT_0x34
; 0000 0F20             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0F21             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0F22             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x64
; 0000 0F23             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0F24             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0F25 
; 0000 0F26             a[1] = a[0]+0x001;  //ster2
; 0000 0F27             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F28             a[6] = a[5]+0x001;  //okrag
; 0000 0F29             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F2A 
; 0000 0F2B     break;
; 0000 0F2C 
; 0000 0F2D 
; 0000 0F2E 
; 0000 0F2F     case 124:
_0x12A:
	CPI  R30,LOW(0x7C)
	LDI  R26,HIGH(0x7C)
	CPC  R31,R26
	BRNE _0x12B
; 0000 0F30 
; 0000 0F31             a[0] = 0x0E0;   //ster1
	LDI  R30,LOW(224)
	LDI  R31,HIGH(224)
	CALL SUBOPT_0x34
; 0000 0F32             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x65
; 0000 0F33             a[4] = 0x15;    //ster3 ABS krazek scierny
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL SUBOPT_0x5A
; 0000 0F34             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5C
; 0000 0F35             a[7] = 0x13;    //ster3 INV krazek scierny
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	CALL SUBOPT_0x3D
; 0000 0F36             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0F37 
; 0000 0F38             a[1] = a[0]+0x001;  //ster2
; 0000 0F39             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F3A             a[6] = a[5]+0x001;  //okrag
; 0000 0F3B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F3C 
; 0000 0F3D     break;
; 0000 0F3E 
; 0000 0F3F 
; 0000 0F40     case 125:
_0x12B:
	CPI  R30,LOW(0x7D)
	LDI  R26,HIGH(0x7D)
	CPC  R31,R26
	BRNE _0x12C
; 0000 0F41 
; 0000 0F42             a[0] = 0x038;   //ster1
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	CALL SUBOPT_0x34
; 0000 0F43             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0F44             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0F45             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x56
; 0000 0F46             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0F47             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F48 
; 0000 0F49             a[1] = a[0]+0x001;  //ster2
; 0000 0F4A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F4B             a[6] = a[5]+0x001;  //okrag
; 0000 0F4C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F4D 
; 0000 0F4E     break;
; 0000 0F4F 
; 0000 0F50 
; 0000 0F51     case 126:
_0x12C:
	CPI  R30,LOW(0x7E)
	LDI  R26,HIGH(0x7E)
	CPC  R31,R26
	BRNE _0x12D
; 0000 0F52 
; 0000 0F53             a[0] = 0x0CA;   //ster1
	LDI  R30,LOW(202)
	LDI  R31,HIGH(202)
	CALL SUBOPT_0x34
; 0000 0F54             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0F55             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0F56             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x515
; 0000 0F57             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F58             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F59 
; 0000 0F5A             a[1] = a[0]+0x001;  //ster2
; 0000 0F5B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F5C             a[6] = a[5]+0x001;  //okrag
; 0000 0F5D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F5E 
; 0000 0F5F     break;
; 0000 0F60 
; 0000 0F61 
; 0000 0F62     case 127:
_0x12D:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0x12E
; 0000 0F63 
; 0000 0F64             a[0] = 0x0DE;   //ster1
	LDI  R30,LOW(222)
	LDI  R31,HIGH(222)
	CALL SUBOPT_0x34
; 0000 0F65             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0F66             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0F67             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x64
; 0000 0F68             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0F69             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F6A 
; 0000 0F6B             a[1] = a[0]+0x001;  //ster2
; 0000 0F6C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F6D             a[6] = a[5]+0x001;  //okrag
; 0000 0F6E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F6F 
; 0000 0F70     break;
; 0000 0F71 
; 0000 0F72 
; 0000 0F73     case 128:
_0x12E:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x12F
; 0000 0F74 
; 0000 0F75             a[0] = 0x116;   //ster1
	LDI  R30,LOW(278)
	LDI  R31,HIGH(278)
	CALL SUBOPT_0x34
; 0000 0F76             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 0F77             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x3A
; 0000 0F78             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0F79             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0F7A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F7B 
; 0000 0F7C             a[1] = a[0]+0x001;  //ster2
; 0000 0F7D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F7E             a[6] = a[5]+0x001;  //okrag
; 0000 0F7F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F80 
; 0000 0F81     break;
; 0000 0F82 
; 0000 0F83 
; 0000 0F84     case 129:
_0x12F:
	CPI  R30,LOW(0x81)
	LDI  R26,HIGH(0x81)
	CPC  R31,R26
	BRNE _0x130
; 0000 0F85 
; 0000 0F86             a[0] = 0x0E8;   //ster1
	LDI  R30,LOW(232)
	LDI  R31,HIGH(232)
	CALL SUBOPT_0x34
; 0000 0F87             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x65
; 0000 0F88             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0F89             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x66
; 0000 0F8A             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 0F8B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0F8C 
; 0000 0F8D             a[1] = a[0]+0x001;  //ster2
; 0000 0F8E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F8F             a[6] = a[5]+0x001;  //okrag
; 0000 0F90             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F91 
; 0000 0F92     break;
; 0000 0F93 
; 0000 0F94 
; 0000 0F95     case 130:
_0x130:
	CPI  R30,LOW(0x82)
	LDI  R26,HIGH(0x82)
	CPC  R31,R26
	BRNE _0x131
; 0000 0F96 
; 0000 0F97             a[0] = 0x0F2;   //ster1
	LDI  R30,LOW(242)
	LDI  R31,HIGH(242)
	CALL SUBOPT_0x34
; 0000 0F98             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x68
; 0000 0F99             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0F9A             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5C
; 0000 0F9B             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x37
; 0000 0F9C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x39
	RJMP _0x514
; 0000 0F9D 
; 0000 0F9E             a[1] = a[0]+0x001;  //ster2
; 0000 0F9F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FA0             a[6] = a[5]+0x001;  //okrag
; 0000 0FA1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FA2 
; 0000 0FA3     break;
; 0000 0FA4 
; 0000 0FA5 
; 0000 0FA6     case 131:
_0x131:
	CPI  R30,LOW(0x83)
	LDI  R26,HIGH(0x83)
	CPC  R31,R26
	BRNE _0x132
; 0000 0FA7 
; 0000 0FA8             a[0] = 0x108;   //ster1
	LDI  R30,LOW(264)
	LDI  R31,HIGH(264)
	CALL SUBOPT_0x34
; 0000 0FA9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0FAA             a[4] = 0x1F;    //ster3 ABS krazek scierny
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP _0x516
; 0000 0FAB             a[5] = 0x19C;   //delta okrag
; 0000 0FAC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FAD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FAE 
; 0000 0FAF             a[1] = a[0]+0x001;  //ster2
; 0000 0FB0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FB1             a[6] = a[5]+0x001;  //okrag
; 0000 0FB2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FB3 
; 0000 0FB4     break;
; 0000 0FB5 
; 0000 0FB6 
; 0000 0FB7 
; 0000 0FB8     case 132:
_0x132:
	CPI  R30,LOW(0x84)
	LDI  R26,HIGH(0x84)
	CPC  R31,R26
	BRNE _0x133
; 0000 0FB9 
; 0000 0FBA             a[0] = 0x064;   //ster1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x34
; 0000 0FBB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0FBC             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0FBD             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x4D
; 0000 0FBE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FBF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0FC0 
; 0000 0FC1             a[1] = a[0]+0x001;  //ster2
; 0000 0FC2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FC3             a[6] = a[5]+0x001;  //okrag
; 0000 0FC4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FC5 
; 0000 0FC6     break;
; 0000 0FC7 
; 0000 0FC8 
; 0000 0FC9     case 133:
_0x133:
	CPI  R30,LOW(0x85)
	LDI  R26,HIGH(0x85)
	CPC  R31,R26
	BRNE _0x134
; 0000 0FCA 
; 0000 0FCB             a[0] = 0x088;   //ster1
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	CALL SUBOPT_0x34
; 0000 0FCC             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x65
; 0000 0FCD             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0FCE             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x66
; 0000 0FCF             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 0FD0             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FD1 
; 0000 0FD2             a[1] = a[0]+0x001;  //ster2
; 0000 0FD3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FD4             a[6] = a[5]+0x001;  //okrag
; 0000 0FD5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FD6 
; 0000 0FD7     break;
; 0000 0FD8 
; 0000 0FD9 
; 0000 0FDA 
; 0000 0FDB     case 134:
_0x134:
	CPI  R30,LOW(0x86)
	LDI  R26,HIGH(0x86)
	CPC  R31,R26
	BRNE _0x135
; 0000 0FDC 
; 0000 0FDD             a[0] = 0x10E;   //ster1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x34
; 0000 0FDE             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x68
; 0000 0FDF             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0FE0             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5C
; 0000 0FE1             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x513
; 0000 0FE2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FE3 
; 0000 0FE4             a[1] = a[0]+0x001;  //ster2
; 0000 0FE5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FE6             a[6] = a[5]+0x001;  //okrag
; 0000 0FE7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FE8 
; 0000 0FE9     break;
; 0000 0FEA 
; 0000 0FEB                ////////////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 0FEC      case 135:
_0x135:
	CPI  R30,LOW(0x87)
	LDI  R26,HIGH(0x87)
	CPC  R31,R26
	BRNE _0x136
; 0000 0FED 
; 0000 0FEE             a[0] = 0x054;   //ster1
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CALL SUBOPT_0x34
; 0000 0FEF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 0FF0             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5F
; 0000 0FF1             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x4D
; 0000 0FF2             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FF3             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 0FF4 
; 0000 0FF5             a[1] = a[0]+0x001;  //ster2
; 0000 0FF6             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FF7             a[6] = a[5]+0x001;  //okrag
; 0000 0FF8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FF9 
; 0000 0FFA     break;
; 0000 0FFB 
; 0000 0FFC 
; 0000 0FFD      case 136:
_0x136:
	CPI  R30,LOW(0x88)
	LDI  R26,HIGH(0x88)
	CPC  R31,R26
	BRNE _0x137
; 0000 0FFE 
; 0000 0FFF             a[0] = 0x03E;   //ster1
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	CALL SUBOPT_0x34
; 0000 1000             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 1001             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x67
; 0000 1002             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x69
; 0000 1003             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x513
; 0000 1004             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1005 
; 0000 1006             a[1] = a[0]+0x001;  //ster2
; 0000 1007             a[2] = a[4];        //ster4 ABS druciak
; 0000 1008             a[6] = a[5]+0x001;  //okrag
; 0000 1009             a[8] = a[6]+0x001;  //-delta okrag
; 0000 100A 
; 0000 100B     break;
; 0000 100C 
; 0000 100D      case 137:
_0x137:
	CPI  R30,LOW(0x89)
	LDI  R26,HIGH(0x89)
	CPC  R31,R26
	BRNE _0x138
; 0000 100E 
; 0000 100F             a[0] = 0x00C;   //ster1
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x34
; 0000 1010             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 1011             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 1012             a[5] = 0x190;   //delta okrag
; 0000 1013             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 1014             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 1015 
; 0000 1016             a[1] = a[0]+0x001;  //ster2
; 0000 1017             a[2] = a[4];        //ster4 ABS druciak
; 0000 1018             a[6] = a[5]+0x001;  //okrag
; 0000 1019             a[8] = a[6]+0x001;  //-delta okrag
; 0000 101A 
; 0000 101B     break;
; 0000 101C 
; 0000 101D 
; 0000 101E      case 138:
_0x138:
	CPI  R30,LOW(0x8A)
	LDI  R26,HIGH(0x8A)
	CPC  R31,R26
	BRNE _0x139
; 0000 101F 
; 0000 1020             a[0] = 0x0DC;   //ster1
	LDI  R30,LOW(220)
	LDI  R31,HIGH(220)
	CALL SUBOPT_0x34
; 0000 1021             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 1022             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x36
; 0000 1023             a[5] = 0x196;   //delta okrag
; 0000 1024             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 1025             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1026 
; 0000 1027             a[1] = a[0]+0x001;  //ster2
; 0000 1028             a[2] = a[4];        //ster4 ABS druciak
; 0000 1029             a[6] = a[5]+0x001;  //okrag
; 0000 102A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 102B 
; 0000 102C     break;
; 0000 102D 
; 0000 102E 
; 0000 102F      case 139:
_0x139:
	CPI  R30,LOW(0x8B)
	LDI  R26,HIGH(0x8B)
	CPC  R31,R26
	BRNE _0x13A
; 0000 1030 
; 0000 1031             a[0] = 0x058;   //ster1
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	CALL SUBOPT_0x34
; 0000 1032             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 1033             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x60
; 0000 1034             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x515
; 0000 1035             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 1036             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1037 
; 0000 1038             a[1] = a[0]+0x001;  //ster2
; 0000 1039             a[2] = a[4];        //ster4 ABS druciak
; 0000 103A             a[6] = a[5]+0x001;  //okrag
; 0000 103B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 103C 
; 0000 103D     break;
; 0000 103E 
; 0000 103F 
; 0000 1040      case 140:
_0x13A:
	CPI  R30,LOW(0x8C)
	LDI  R26,HIGH(0x8C)
	CPC  R31,R26
	BRNE _0x13B
; 0000 1041 
; 0000 1042             a[0] = 0x03C;   //ster1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0x34
; 0000 1043             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 1044             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 1045             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x69
; 0000 1046             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x37
; 0000 1047             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x39
	RJMP _0x514
; 0000 1048 
; 0000 1049             a[1] = a[0]+0x001;  //ster2
; 0000 104A             a[2] = a[4];        //ster4 ABS druciak
; 0000 104B             a[6] = a[5]+0x001;  //okrag
; 0000 104C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 104D 
; 0000 104E 
; 0000 104F 
; 0000 1050     break;
; 0000 1051 
; 0000 1052 
; 0000 1053      case 141:
_0x13B:
	CPI  R30,LOW(0x8D)
	LDI  R26,HIGH(0x8D)
	CPC  R31,R26
	BRNE _0x13C
; 0000 1054 
; 0000 1055             a[0] = 0x00E;   //ster1
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x34
; 0000 1056             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 1057             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 1058             a[5] = 0x190;   //delta okrag
; 0000 1059             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x513
; 0000 105A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 105B 
; 0000 105C             a[1] = a[0]+0x001;  //ster2
; 0000 105D             a[2] = a[4];        //ster4 ABS druciak
; 0000 105E             a[6] = a[5]+0x001;  //okrag
; 0000 105F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1060 
; 0000 1061     break;
; 0000 1062 
; 0000 1063 
; 0000 1064      case 142:
_0x13C:
	CPI  R30,LOW(0x8E)
	LDI  R26,HIGH(0x8E)
	CPC  R31,R26
	BRNE _0x13D
; 0000 1065 
; 0000 1066             a[0] = 0x10A;   //ster1
	LDI  R30,LOW(266)
	LDI  R31,HIGH(266)
	CALL SUBOPT_0x34
; 0000 1067             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x37
; 0000 1068             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x36
; 0000 1069             a[5] = 0x196;   //delta okrag
; 0000 106A             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3D
; 0000 106B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 106C 
; 0000 106D             a[1] = a[0]+0x001;  //ster2
; 0000 106E             a[2] = a[4];        //ster4 ABS druciak
; 0000 106F             a[6] = a[5]+0x001;  //okrag
; 0000 1070             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1071 
; 0000 1072     break;
; 0000 1073 
; 0000 1074 
; 0000 1075 
; 0000 1076      case 143:
_0x13D:
	CPI  R30,LOW(0x8F)
	LDI  R26,HIGH(0x8F)
	CPC  R31,R26
	BRNE _0x13E
; 0000 1077 
; 0000 1078             a[0] = 0x022;   //ster1
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL SUBOPT_0x34
; 0000 1079             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 107A             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x60
; 0000 107B             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 107C             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 107D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x514
; 0000 107E 
; 0000 107F             a[1] = a[0]+0x001;  //ster2
; 0000 1080             a[2] = a[4];        //ster4 ABS druciak
; 0000 1081             a[6] = a[5]+0x001;  //okrag
; 0000 1082             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1083 
; 0000 1084     break;
; 0000 1085 
; 0000 1086 
; 0000 1087      case 144:
_0x13E:
	CPI  R30,LOW(0x90)
	LDI  R26,HIGH(0x90)
	CPC  R31,R26
	BRNE _0xAE
; 0000 1088 
; 0000 1089             a[0] = 0x066;   //ster1
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	CALL SUBOPT_0x34
; 0000 108A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x35
; 0000 108B             a[4] = 0x1C;    //ster3 ABS krazek scierny
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
_0x516:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 108C             a[5] = 0x19C;   //delta okrag
	__POINTW1MN _a,10
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
_0x515:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 108D             a[7] = 0x12;    //ster3 INV krazek scierny
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
_0x513:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 108E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	__POINTW1MN _a,18
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
_0x514:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 108F 
; 0000 1090             a[1] = a[0]+0x001;  //ster2
	CALL SUBOPT_0x6A
	ADIW R30,1
	__PUTW1MN _a,2
; 0000 1091             a[2] = a[4];        //ster4 ABS druciak
	CALL SUBOPT_0x6B
	__PUTW1MN _a,4
; 0000 1092             a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
; 0000 1093             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1094 
; 0000 1095     break;
; 0000 1096 
; 0000 1097 
; 0000 1098 }
_0xAE:
; 0000 1099 
; 0000 109A //if(predkosc_pion_szczotka == 50)   //zwolnienie predkosci pion
; 0000 109B //       {
; 0000 109C //       a[3] = a[3] - 0x05;
; 0000 109D //       }
; 0000 109E 
; 0000 109F if(tryb_pracy_szczotki_drucianej == 1)
	CALL SUBOPT_0x6E
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x140
; 0000 10A0          a[3] = a[3];
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x70
; 0000 10A1 
; 0000 10A2 if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)
_0x140:
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x71
	BREQ _0x141
; 0000 10A3          a[3] = a[3]-0x05;
	CALL SUBOPT_0x6F
	SBIW R30,5
	CALL SUBOPT_0x70
; 0000 10A4 
; 0000 10A5 //if(predkosc_pion_krazek == 50)   //zwolnienie predkosci pion krazek
; 0000 10A6 //       {
; 0000 10A7 //       a[7] = a[7] - 0x05;
; 0000 10A8 //       }
; 0000 10A9 
; 0000 10AA a[3] = a[3]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT
_0x141:
	CALL SUBOPT_0x6F
	SBIW R30,6
	CALL SUBOPT_0x70
; 0000 10AB a[2] = a[2]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT
	CALL SUBOPT_0x72
	SBIW R30,6
	__PUTW1MN _a,4
; 0000 10AC 
; 0000 10AD 
; 0000 10AE 
; 0000 10AF if(krazek_scierny_cykl_po_okregu_ilosc == 0 | ruch_haos == 1)
	CALL SUBOPT_0x73
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x74
	CALL SUBOPT_0x75
	OR   R30,R0
	BREQ _0x142
; 0000 10B0         a[7] = a[7] - 0x05;
	CALL SUBOPT_0x76
	SBIW R30,5
	__PUTW1MN _a,14
; 0000 10B1 
; 0000 10B2 if(srednica_krazka_sciernego == 40)
_0x142:
	CALL SUBOPT_0x77
	SBIW R26,40
	BRNE _0x143
; 0000 10B3         a[4] = a[4]+ 0x13;
	CALL SUBOPT_0x6B
	ADIW R30,19
	__PUTW1MN _a,8
; 0000 10B4 
; 0000 10B5                                                      //2
; 0000 10B6 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 30)
_0x143:
	CALL SUBOPT_0x78
	CALL SUBOPT_0x75
	CALL SUBOPT_0x79
; 0000 10B7     {
; 0000 10B8     }
; 0000 10B9 
; 0000 10BA                                                    //2
; 0000 10BB if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 30)
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x79
	BREQ _0x145
; 0000 10BC     {
; 0000 10BD     a[5] = a[5] + 0x10;   //plus 16 dzesietnie
	CALL SUBOPT_0x6C
	ADIW R30,16
	CALL SUBOPT_0x7B
; 0000 10BE     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6D
; 0000 10BF     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10C0     }
; 0000 10C1                                                     //1
; 0000 10C2 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 30)
_0x145:
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x79
	BREQ _0x146
; 0000 10C3     {
; 0000 10C4     a[5] = a[5] + 0x20;   //plus 32 dzesietnie
	CALL SUBOPT_0x6C
	ADIW R30,32
	CALL SUBOPT_0x7B
; 0000 10C5     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6D
; 0000 10C6     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10C7     }
; 0000 10C8 
; 0000 10C9                                                     //2
; 0000 10CA if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 30)
_0x146:
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x79
	BREQ _0x147
; 0000 10CB     {
; 0000 10CC     a[5] = a[5] + 0x30;   //plus 48 dzesietnie
	CALL SUBOPT_0x6C
	ADIW R30,48
	CALL SUBOPT_0x7B
; 0000 10CD     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6D
; 0000 10CE     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10CF     }
; 0000 10D0 
; 0000 10D1 /////////////////////////////////////////////////////////////////////////////////////
; 0000 10D2 
; 0000 10D3 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 40)
_0x147:
	CALL SUBOPT_0x78
	CALL SUBOPT_0x75
	CALL SUBOPT_0x7E
	BREQ _0x148
; 0000 10D4     {
; 0000 10D5     a[5] = a[5] + 0x39;   //plus 66 dzesietnie   ///////////////
	CALL SUBOPT_0x6C
	ADIW R30,57
	CALL SUBOPT_0x7B
; 0000 10D6     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6D
; 0000 10D7     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10D8     }
; 0000 10D9 
; 0000 10DA                                                    //2
; 0000 10DB if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 40)
_0x148:
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7E
	BREQ _0x149
; 0000 10DC     {
; 0000 10DD     a[5] = a[5] + 0x42;   //plus 16 dzesietnie
	CALL SUBOPT_0x6C
	SUBI R30,LOW(-66)
	SBCI R31,HIGH(-66)
	CALL SUBOPT_0x7B
; 0000 10DE     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6D
; 0000 10DF     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10E0     }
; 0000 10E1                                                     //1
; 0000 10E2 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 40)
_0x149:
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x7E
	BREQ _0x14A
; 0000 10E3     {
; 0000 10E4     a[5] = a[5] + 0x4B;   //plus 32 dzesietnie
	CALL SUBOPT_0x6C
	SUBI R30,LOW(-75)
	SBCI R31,HIGH(-75)
	CALL SUBOPT_0x7B
; 0000 10E5     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6D
; 0000 10E6     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10E7     }
; 0000 10E8 
; 0000 10E9                                                     //2
; 0000 10EA if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 40)
_0x14A:
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x7E
	BREQ _0x14B
; 0000 10EB     {
; 0000 10EC     a[5] = a[5] + 0x54;   //plus 48 dzesietnie
	CALL SUBOPT_0x6C
	SUBI R30,LOW(-84)
	SBCI R31,HIGH(-84)
	CALL SUBOPT_0x7B
; 0000 10ED     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6D
; 0000 10EE     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10EF     }
; 0000 10F0 
; 0000 10F1 }
_0x14B:
	ADIW R28,2
	RET
;
;void obsluga_nacisniecia_zatrzymaj()
; 0000 10F4 {
_obsluga_nacisniecia_zatrzymaj:
; 0000 10F5 int sg;
; 0000 10F6 sg = 0;
	CALL SUBOPT_0x2
;	sg -> R16,R17
; 0000 10F7 
; 0000 10F8   if(sek20 > 60)
	LDS  R26,_sek20
	LDS  R27,_sek20+1
	LDS  R24,_sek20+2
	LDS  R25,_sek20+3
	CALL SUBOPT_0x7F
	BRGE PC+3
	JMP _0x14C
; 0000 10F9    {
; 0000 10FA    sek20 = 0;
	LDI  R30,LOW(0)
	STS  _sek20,R30
	STS  _sek20+1,R30
	STS  _sek20+2,R30
	STS  _sek20+3,R30
; 0000 10FB    while(sprawdz_pin2(PORTMM,0x77) == 0)
_0x14D:
	CALL SUBOPT_0x18
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x14F
; 0000 10FC         {
; 0000 10FD         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0x80
; 0000 10FE         PORTD.7 = 1;
	SBI  0x12,7
; 0000 10FF         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x152
; 0000 1100            {
; 0000 1101            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x81
; 0000 1102            PORTE.2 = 0;
; 0000 1103            }
; 0000 1104 
; 0000 1105         if(PORTE.3 == 1)
_0x152:
	SBIS 0x3,3
	RJMP _0x155
; 0000 1106            {
; 0000 1107            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x82
; 0000 1108            PORTE.3 = 0;
; 0000 1109            }
; 0000 110A 
; 0000 110B          if(PORT_F.bits.b4 == 1)
_0x155:
	CALL SUBOPT_0x83
	BRNE _0x158
; 0000 110C             {
; 0000 110D             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x84
; 0000 110E             zastopowany_czas_przedmuchu = sek12;
; 0000 110F             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1110             PORTF = PORT_F.byte;
; 0000 1111             }
; 0000 1112 
; 0000 1113 
; 0000 1114         komunikat_na_panel("                                                ",adr1,adr2);
_0x158:
	CALL SUBOPT_0x2A
; 0000 1115         komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr1,adr2);
	__POINTW1FN _0x0,1351
	CALL SUBOPT_0x2B
; 0000 1116         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1117         komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr3,adr4);
	__POINTW1FN _0x0,1351
	CALL SUBOPT_0x86
; 0000 1118 
; 0000 1119         }
	RJMP _0x14D
_0x14F:
; 0000 111A 
; 0000 111B     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x159
; 0000 111C         {
; 0000 111D         while(sg == 0)
_0x15A:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x15C
; 0000 111E             {
; 0000 111F             if(sprawdz_pin2(PORTMM,0x77) == 1)
	CALL SUBOPT_0x18
	CALL _sprawdz_pin2
	CPI  R30,LOW(0x1)
	BRNE _0x15D
; 0000 1120                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0xE
	CALL SUBOPT_0x1B
	MOVW R16,R30
; 0000 1121 
; 0000 1122 
; 0000 1123             }
_0x15D:
	RJMP _0x15A
_0x15C:
; 0000 1124 
; 0000 1125         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 1126         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1127 
; 0000 1128         PORTD.7 = 0;
	CALL SUBOPT_0x87
; 0000 1129         if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x160
; 0000 112A             {
; 0000 112B             PORTE.2 = 1;
	CALL SUBOPT_0x88
; 0000 112C             byla_wloczona_szlifierka_1 = 0;
; 0000 112D             }
; 0000 112E         if(byla_wloczona_szlifierka_2 == 1)
_0x160:
	CALL SUBOPT_0x89
	BRNE _0x163
; 0000 112F             {
; 0000 1130             PORTE.3 = 1;
	CALL SUBOPT_0x8A
; 0000 1131             byla_wloczona_szlifierka_2 = 0;
; 0000 1132             }
; 0000 1133         if(byl_wloczony_przedmuch == 1)
_0x163:
	CALL SUBOPT_0x8B
	BRNE _0x166
; 0000 1134             {
; 0000 1135             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x8C
; 0000 1136             PORTF = PORT_F.byte;
; 0000 1137             sek12 = zastopowany_czas_przedmuchu;
; 0000 1138             byl_wloczony_przedmuch = 0;
; 0000 1139             }
; 0000 113A         }
_0x166:
; 0000 113B     }
_0x159:
; 0000 113C 
; 0000 113D }
_0x14C:
	RJMP _0x20A0002
;
;
;void obsluga_otwarcia_klapy_rzad()
; 0000 1141 {
_obsluga_otwarcia_klapy_rzad:
; 0000 1142 int sg;
; 0000 1143 sg = 0;
	CALL SUBOPT_0x2
;	sg -> R16,R17
; 0000 1144 
; 0000 1145 if(rzad_obrabiany == 1 & start == 1)
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x75
	CALL SUBOPT_0x8E
	AND  R30,R0
	BRNE PC+3
	JMP _0x167
; 0000 1146    {
; 0000 1147    while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x168:
	CALL SUBOPT_0x18
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x16A
; 0000 1148         {
; 0000 1149         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0x80
; 0000 114A         PORTD.7 = 1;
	SBI  0x12,7
; 0000 114B         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x16D
; 0000 114C            {
; 0000 114D            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x81
; 0000 114E            PORTE.2 = 0;
; 0000 114F            }
; 0000 1150 
; 0000 1151         if(PORTE.3 == 1)
_0x16D:
	SBIS 0x3,3
	RJMP _0x170
; 0000 1152            {
; 0000 1153            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x82
; 0000 1154            PORTE.3 = 0;
; 0000 1155            }
; 0000 1156 
; 0000 1157            if(PORT_F.bits.b4 == 1)
_0x170:
	CALL SUBOPT_0x83
	BRNE _0x173
; 0000 1158             {
; 0000 1159             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x84
; 0000 115A             zastopowany_czas_przedmuchu = sek12;
; 0000 115B             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 115C             PORTF = PORT_F.byte;
; 0000 115D             }
; 0000 115E 
; 0000 115F 
; 0000 1160         komunikat_na_panel("                                                ",adr1,adr2);
_0x173:
	CALL SUBOPT_0x2A
; 0000 1161         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x2B
; 0000 1162         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1163         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x86
; 0000 1164 
; 0000 1165         }
	RJMP _0x168
_0x16A:
; 0000 1166     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x174
; 0000 1167         {
; 0000 1168         while(sg == 0)
_0x175:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x177
; 0000 1169             {
; 0000 116A             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	POP  R26
	AND  R30,R26
	BREQ _0x178
; 0000 116B                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0xE
	CALL SUBOPT_0x1B
	MOVW R16,R30
; 0000 116C 
; 0000 116D 
; 0000 116E             }
_0x178:
	RJMP _0x175
_0x177:
; 0000 116F 
; 0000 1170         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 1171         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1172 
; 0000 1173         PORTD.7 = 0;
	CALL SUBOPT_0x87
; 0000 1174           if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x17B
; 0000 1175             {
; 0000 1176             PORTE.2 = 1;
	CALL SUBOPT_0x88
; 0000 1177             byla_wloczona_szlifierka_1 = 0;
; 0000 1178             }
; 0000 1179         if(byla_wloczona_szlifierka_2 == 1)
_0x17B:
	CALL SUBOPT_0x89
	BRNE _0x17E
; 0000 117A             {
; 0000 117B             PORTE.3 = 1;
	CALL SUBOPT_0x8A
; 0000 117C             byla_wloczona_szlifierka_2 = 0;
; 0000 117D             }
; 0000 117E         if(byl_wloczony_przedmuch == 1)
_0x17E:
	CALL SUBOPT_0x8B
	BRNE _0x181
; 0000 117F             {
; 0000 1180             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x8C
; 0000 1181             PORTF = PORT_F.byte;
; 0000 1182             sek12 = zastopowany_czas_przedmuchu;
; 0000 1183             byl_wloczony_przedmuch = 0;
; 0000 1184             }
; 0000 1185         }
_0x181:
; 0000 1186    }
_0x174:
; 0000 1187 
; 0000 1188 
; 0000 1189 if(rzad_obrabiany == 2 & start == 1)
_0x167:
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x8E
	AND  R30,R0
	BRNE PC+3
	JMP _0x182
; 0000 118A    {
; 0000 118B    while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x183:
	CALL SUBOPT_0x18
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BRNE _0x185
; 0000 118C         {
; 0000 118D         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0x80
; 0000 118E         PORTD.7 = 1;
	SBI  0x12,7
; 0000 118F         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x188
; 0000 1190            {
; 0000 1191            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x81
; 0000 1192            PORTE.2 = 0;
; 0000 1193            }
; 0000 1194 
; 0000 1195         if(PORTE.3 == 1)
_0x188:
	SBIS 0x3,3
	RJMP _0x18B
; 0000 1196            {
; 0000 1197            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x82
; 0000 1198            PORTE.3 = 0;
; 0000 1199            }
; 0000 119A 
; 0000 119B          if(PORT_F.bits.b4 == 1)
_0x18B:
	CALL SUBOPT_0x83
	BRNE _0x18E
; 0000 119C             {
; 0000 119D             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x84
; 0000 119E             zastopowany_czas_przedmuchu = sek12;
; 0000 119F             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 11A0             PORTF = PORT_F.byte;
; 0000 11A1             }
; 0000 11A2 
; 0000 11A3         komunikat_na_panel("                                                ",adr1,adr2);
_0x18E:
	CALL SUBOPT_0x2A
; 0000 11A4         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x2B
; 0000 11A5         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 11A6         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x86
; 0000 11A7 
; 0000 11A8         }
	RJMP _0x183
_0x185:
; 0000 11A9     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x18F
; 0000 11AA         {
; 0000 11AB         while(sg == 0)
_0x190:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x192
; 0000 11AC             {
; 0000 11AD             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	POP  R26
	AND  R30,R26
	BREQ _0x193
; 0000 11AE                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0xE
	CALL SUBOPT_0x1B
	MOVW R16,R30
; 0000 11AF 
; 0000 11B0 
; 0000 11B1             }
_0x193:
	RJMP _0x190
_0x192:
; 0000 11B2 
; 0000 11B3         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 11B4         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 11B5 
; 0000 11B6         PORTD.7 = 0;
	CALL SUBOPT_0x87
; 0000 11B7         if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x196
; 0000 11B8             {
; 0000 11B9             PORTE.2 = 1;
	CALL SUBOPT_0x88
; 0000 11BA             byla_wloczona_szlifierka_1 = 0;
; 0000 11BB             }
; 0000 11BC         if(byla_wloczona_szlifierka_2 == 1)
_0x196:
	CALL SUBOPT_0x89
	BRNE _0x199
; 0000 11BD             {
; 0000 11BE             PORTE.3 = 1;
	CALL SUBOPT_0x8A
; 0000 11BF             byla_wloczona_szlifierka_2 = 0;
; 0000 11C0             }
; 0000 11C1         if(byl_wloczony_przedmuch == 1)
_0x199:
	CALL SUBOPT_0x8B
	BRNE _0x19C
; 0000 11C2             {
; 0000 11C3             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x8C
; 0000 11C4             PORTF = PORT_F.byte;
; 0000 11C5             sek12 = zastopowany_czas_przedmuchu;
; 0000 11C6             byl_wloczony_przedmuch = 0;
; 0000 11C7             }
; 0000 11C8         }
_0x19C:
; 0000 11C9    }
_0x18F:
; 0000 11CA 
; 0000 11CB 
; 0000 11CC 
; 0000 11CD 
; 0000 11CE 
; 0000 11CF }
_0x182:
_0x20A0002:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;
;void wartosci_wstepne_panelu()
; 0000 11D4 {
_wartosci_wstepne_panelu:
; 0000 11D5                                                       //3040
; 0000 11D6 wartosc_parametru_panelu(szczotka_druciana_ilosc_cykli,48,64);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x90
	CALL SUBOPT_0x91
	CALL SUBOPT_0x80
; 0000 11D7                                                 //2090
; 0000 11D8 wartosc_parametru_panelu(krazek_scierny_ilosc_cykli,32,144);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x92
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2E
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0xB
; 0000 11D9                                                         //3000
; 0000 11DA wartosc_parametru_panelu(krazek_scierny_cykl_po_okregu_ilosc,48,0);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x73
	CALL SUBOPT_0x91
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0xB
; 0000 11DB                                                 //2050
; 0000 11DC wartosc_parametru_panelu(predkosc_pion_szczotka,32,80);
	LDS  R30,_predkosc_pion_szczotka
	LDS  R31,_predkosc_pion_szczotka+1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2E
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0xB
; 0000 11DD                                                 //2060
; 0000 11DE wartosc_parametru_panelu(predkosc_pion_krazek,32,96);
	LDS  R30,_predkosc_pion_krazek
	LDS  R31,_predkosc_pion_krazek+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
; 0000 11DF                                                                        //3010
; 0000 11E0 wartosc_parametru_panelu(wejscie_krazka_sciernego_w_pow_boczna_cylindra,48,16);
	LDS  R30,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R31,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	CALL SUBOPT_0x91
	CALL SUBOPT_0xF
; 0000 11E1                                                                      //2070
; 0000 11E2 wartosc_parametru_panelu(predkosc_ruchow_po_okregu_krazek_scierny,32,112);
	LDS  R30,_predkosc_ruchow_po_okregu_krazek_scierny
	LDS  R31,_predkosc_ruchow_po_okregu_krazek_scierny+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0xD
	CALL SUBOPT_0xB
; 0000 11E3 
; 0000 11E4 /////////////////////////
; 0000 11E5 wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
	CALL SUBOPT_0x9
; 0000 11E6 
; 0000 11E7 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
; 0000 11E8 
; 0000 11E9 wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
; 0000 11EA 
; 0000 11EB wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
; 0000 11EC wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
; 0000 11ED wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
; 0000 11EE wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
; 0000 11EF wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	CALL SUBOPT_0xB
; 0000 11F0 
; 0000 11F1 //////////////////////////
; 0000 11F2 wartosc_parametru_panelu(40,48,112);  //srednica krazka wstepnie
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x26
	CALL SUBOPT_0xB
; 0000 11F3 
; 0000 11F4 wartosc_parametru_panelu(tryb_pracy_szczotki_drucianej,0,112);
	CALL SUBOPT_0x6E
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x28
	CALL SUBOPT_0xB
; 0000 11F5 
; 0000 11F6 
; 0000 11F7 }
	RET
;
;void wypozycjonuj_napedy_minimalistyczna()
; 0000 11FA {
_wypozycjonuj_napedy_minimalistyczna:
; 0000 11FB 
; 0000 11FC while(start == 0)
_0x19D:
	LDS  R30,_start
	LDS  R31,_start+1
	SBIW R30,0
	BRNE _0x19F
; 0000 11FD     {
; 0000 11FE     komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 11FF     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr1,adr2);
	__POINTW1FN _0x0,1429
	CALL SUBOPT_0x2B
; 0000 1200     komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1201     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr3,adr4);
	__POINTW1FN _0x0,1429
	CALL SUBOPT_0x86
; 0000 1202     delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 1203     start = odczytaj_parametr(0,64);
	CALL SUBOPT_0xE
	CALL SUBOPT_0x1B
	STS  _start,R30
	STS  _start+1,R31
; 0000 1204     }
	RJMP _0x19D
_0x19F:
; 0000 1205 
; 0000 1206 
; 0000 1207 while(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
_0x1A0:
	CALL SUBOPT_0x18
	CALL SUBOPT_0x94
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x95
	POP  R26
	OR   R30,R26
	BREQ _0x1A2
; 0000 1208     {
; 0000 1209     komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 120A     komunikat_na_panel("Zamknij oslony gorne",adr1,adr2);
	__POINTW1FN _0x0,1470
	CALL SUBOPT_0x2B
; 0000 120B     komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 120C     komunikat_na_panel("Zamknij oslony gorne",adr3,adr4);
	__POINTW1FN _0x0,1470
	CALL SUBOPT_0x86
; 0000 120D     }
	RJMP _0x1A0
_0x1A2:
; 0000 120E 
; 0000 120F 
; 0000 1210 PORTB.4 = 1;   //setupy piony
	SBI  0x18,4
; 0000 1211 
; 0000 1212 delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 1213 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 1214 
; 0000 1215 
; 0000 1216 
; 0000 1217 while(sprawdz_pin3(PORTKK,0x75) == 1 | sprawdz_pin7(PORTKK,0x75) == 1)
_0x1A7:
	CALL SUBOPT_0x96
	CALL SUBOPT_0x97
	PUSH R30
	CALL SUBOPT_0x96
	CALL SUBOPT_0x98
	POP  R26
	OR   R30,R26
	BRNE PC+3
	JMP _0x1A9
; 0000 1218       {
; 0000 1219       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x94
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x95
	POP  R26
	OR   R30,R26
	BREQ _0x1AA
; 0000 121A         while(1)
_0x1AB:
; 0000 121B             {
; 0000 121C             PORTD.7 = 1;
	CALL SUBOPT_0x99
; 0000 121D             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 121E 
; 0000 121F             PORTB.4 = 0;   //setupy piony
; 0000 1220             PORTD.2 = 0;   //setup wspolny
; 0000 1221 
; 0000 1222             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1223             komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1491
	CALL SUBOPT_0x2B
; 0000 1224             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1225             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0x9A
; 0000 1226 
; 0000 1227             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0x80
; 0000 1228             }
	RJMP _0x1AB
; 0000 1229 
; 0000 122A 
; 0000 122B       if(sprawdz_pin2(PORTMM,0x77) == 0)
_0x1AA:
	CALL SUBOPT_0x18
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x1B6
; 0000 122C         while(1)
_0x1B7:
; 0000 122D             {
; 0000 122E             PORTD.7 = 1;
	CALL SUBOPT_0x99
; 0000 122F             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 1230 
; 0000 1231             PORTB.4 = 0;   //setupy piony
; 0000 1232             PORTD.2 = 0;   //setup wspolny
; 0000 1233 
; 0000 1234             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1235             komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1554
	CALL SUBOPT_0x2B
; 0000 1236             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1237             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0x9A
; 0000 1238 
; 0000 1239             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0x80
; 0000 123A             }
	RJMP _0x1B7
; 0000 123B 
; 0000 123C 
; 0000 123D       komunikat_na_panel("                                                ",adr1,adr2);
_0x1B6:
	CALL SUBOPT_0x2A
; 0000 123E       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x2B
; 0000 123F       komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1240       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x86
; 0000 1241       delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 1242 
; 0000 1243       if(sprawdz_pin3(PORTKK,0x75) == 0)
	CALL SUBOPT_0x96
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1C2
; 0000 1244             {
; 0000 1245             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 1246             komunikat_na_panel("Sterownik 3 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1622
	CALL SUBOPT_0x2B
; 0000 1247             delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 1248             }
; 0000 1249       if(sprawdz_pin7(PORTKK,0x75) == 0)
_0x1C2:
	CALL SUBOPT_0x96
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x1C3
; 0000 124A             {
; 0000 124B             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 124C             komunikat_na_panel("Sterownik 4 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1653
	CALL SUBOPT_0x2B
; 0000 124D             delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 124E             }
; 0000 124F 
; 0000 1250 
; 0000 1251       if(sprawdz_pin6(PORTMM,0x77) == 1 |
_0x1C3:
; 0000 1252          sprawdz_pin7(PORTMM,0x77) == 1)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x9B
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x98
	POP  R26
	OR   R30,R26
	BREQ _0x1C4
; 0000 1253             {
; 0000 1254             PORTD.7 = 1;
	SBI  0x12,7
; 0000 1255             if(sprawdz_pin6(PORTMM,0x77) == 1)
	CALL SUBOPT_0x18
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x1C7
; 0000 1256                 {
; 0000 1257                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 1258                 komunikat_na_panel("Alarm Sterownik 4",adr1,adr2);
	__POINTW1FN _0x0,1684
	CALL SUBOPT_0x2B
; 0000 1259                 delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 125A                 }
; 0000 125B             if(sprawdz_pin7(PORTMM,0x77) == 1)
_0x1C7:
	CALL SUBOPT_0x18
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x1C8
; 0000 125C                 {
; 0000 125D                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 125E                 komunikat_na_panel("Alarm Sterownik 3",adr1,adr2);
	__POINTW1FN _0x0,1702
	CALL SUBOPT_0x2B
; 0000 125F                 delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 1260                 }
; 0000 1261             }
_0x1C8:
; 0000 1262 
; 0000 1263 
; 0000 1264 
; 0000 1265 
; 0000 1266 
; 0000 1267 
; 0000 1268 
; 0000 1269 
; 0000 126A       }
_0x1C4:
	RJMP _0x1A7
_0x1A9:
; 0000 126B 
; 0000 126C PORTB.4 = 0;   //setupy piony
	CBI  0x18,4
; 0000 126D PORTD.2 = 1;   //setup poziomy
	SBI  0x12,2
; 0000 126E delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 126F 
; 0000 1270 
; 0000 1271 while(sprawdz_pin3(PORTJJ,0x79) == 1 | sprawdz_pin3(PORTLL,0x71) == 1)
_0x1CD:
	CALL SUBOPT_0x29
	CALL SUBOPT_0x97
	PUSH R30
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x97
	POP  R26
	OR   R30,R26
	BRNE PC+3
	JMP _0x1CF
; 0000 1272       {
; 0000 1273 
; 0000 1274       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x94
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x95
	POP  R26
	OR   R30,R26
	BREQ _0x1D0
; 0000 1275         while(1)
_0x1D1:
; 0000 1276             {
; 0000 1277             PORTD.7 = 1;
	SBI  0x12,7
; 0000 1278             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 1279             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 127A             komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1491
	CALL SUBOPT_0x2B
; 0000 127B             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 127C             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0x9A
; 0000 127D 
; 0000 127E             PORTB.4 = 0;   //setupy piony
	CBI  0x18,4
; 0000 127F             PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 1280 
; 0000 1281             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0x80
; 0000 1282             }
	RJMP _0x1D1
; 0000 1283 
; 0000 1284 
; 0000 1285       if(sprawdz_pin2(PORTMM,0x77) == 0)
_0x1D0:
	CALL SUBOPT_0x18
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x1DC
; 0000 1286         while(1)
_0x1DD:
; 0000 1287             {
; 0000 1288             PORTD.7 = 1;
	CALL SUBOPT_0x99
; 0000 1289             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 128A 
; 0000 128B             PORTB.4 = 0;   //setupy piony
; 0000 128C             PORTD.2 = 0;   //setup wspolny
; 0000 128D 
; 0000 128E             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 128F             komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1554
	CALL SUBOPT_0x2B
; 0000 1290             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1291             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0x9A
; 0000 1292 
; 0000 1293             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0x80
; 0000 1294             }
	RJMP _0x1DD
; 0000 1295 
; 0000 1296       komunikat_na_panel("                                                ",adr1,adr2);
_0x1DC:
	CALL SUBOPT_0x2A
; 0000 1297       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x2B
; 0000 1298       komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1299       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x86
; 0000 129A       delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 129B 
; 0000 129C       if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x29
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1E8
; 0000 129D             {
; 0000 129E             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 129F             komunikat_na_panel("Sterownik 1 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1720
	CALL SUBOPT_0x2B
; 0000 12A0             delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 12A1             }
; 0000 12A2       if(sprawdz_pin3(PORTLL,0x71) == 0)
_0x1E8:
	CALL SUBOPT_0x9C
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1E9
; 0000 12A3             {
; 0000 12A4             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 12A5             komunikat_na_panel("Sterownik 2 - wypozycjonowalem",adr3,adr4);
	__POINTW1FN _0x0,1751
	CALL SUBOPT_0x86
; 0000 12A6             delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 12A7             }
; 0000 12A8 
; 0000 12A9        //if(sprawdz_pin7(PORTMM,0x77) == 1)
; 0000 12AA        //     PORTD.7 = 1;
; 0000 12AB 
; 0000 12AC       if(sprawdz_pin5(PORTJJ,0x79) == 1 |
_0x1E9:
; 0000 12AD          sprawdz_pin5(PORTLL,0x71) == 1)
	CALL SUBOPT_0x29
	CALL SUBOPT_0x9D
	PUSH R30
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x9D
	POP  R26
	OR   R30,R26
	BREQ _0x1EA
; 0000 12AE             {
; 0000 12AF             PORTD.7 = 1;
	SBI  0x12,7
; 0000 12B0             if(sprawdz_pin5(PORTJJ,0x79) == 1)
	CALL SUBOPT_0x29
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x1ED
; 0000 12B1                 {
; 0000 12B2                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 12B3                 komunikat_na_panel("Alarm Sterownik 1",adr1,adr2);
	__POINTW1FN _0x0,1782
	CALL SUBOPT_0x2B
; 0000 12B4                 delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 12B5                 }
; 0000 12B6             if(sprawdz_pin5(PORTLL,0x71) == 1)
_0x1ED:
	CALL SUBOPT_0x9C
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x1EE
; 0000 12B7                 {
; 0000 12B8                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 12B9                 komunikat_na_panel("Alarm Sterownik 2",adr1,adr2);
	__POINTW1FN _0x0,1800
	CALL SUBOPT_0x2B
; 0000 12BA                 delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 12BB                 }
; 0000 12BC 
; 0000 12BD             }
_0x1EE:
; 0000 12BE 
; 0000 12BF       //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 12C0 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 12C1       //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 12C2        //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 12C3 
; 0000 12C4 
; 0000 12C5 
; 0000 12C6       }
_0x1EA:
	RJMP _0x1CD
_0x1CF:
; 0000 12C7 
; 0000 12C8 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 12C9 komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1818
	CALL SUBOPT_0x2B
; 0000 12CA komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 12CB komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1818
	CALL SUBOPT_0x86
; 0000 12CC 
; 0000 12CD PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 12CE PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 12CF delay_ms(1000);
	CALL SUBOPT_0x93
; 0000 12D0 wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0x80
; 0000 12D1 start = 0;
	CALL SUBOPT_0x9E
; 0000 12D2 
; 0000 12D3 }
	RET
;
;
;void przerzucanie_dociskow()
; 0000 12D7 {
_przerzucanie_dociskow:
; 0000 12D8 
; 0000 12D9 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x1F3
; 0000 12DA   {
; 0000 12DB    if(sprawdz_pin6(PORTLL,0x71) == 0 & sprawdz_pin7(PORTLL,0x71) == 0 & czekaj_az_puszcze == 0)
	CALL SUBOPT_0x9C
	CALL _sprawdz_pin6
	LDI  R26,LOW(0)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0x9C
	CALL _sprawdz_pin7
	LDI  R26,LOW(0)
	CALL __EQB12
	POP  R26
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xA0
	BREQ _0x1F4
; 0000 12DC            {
; 0000 12DD            czekaj_az_puszcze = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 12DE            //PORTB.6 = 1;
; 0000 12DF            }
; 0000 12E0        if(sprawdz_pin6(PORTLL,0x71) == 1 & sprawdz_pin7(PORTLL,0x71) == 1 & czekaj_az_puszcze == 1)
_0x1F4:
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x9B
	PUSH R30
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x98
	POP  R26
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x75
	AND  R30,R0
	BREQ _0x1F5
; 0000 12E1            {
; 0000 12E2            czekaj_az_puszcze = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 12E3            //PORTB.6 = 0;
; 0000 12E4            }
; 0000 12E5 
; 0000 12E6        if(czekaj_az_puszcze == 2 & PORTE.6 == 1)
_0x1F5:
	CALL SUBOPT_0xA1
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x1F6
; 0000 12E7             {
; 0000 12E8             PORTE.6 = 0;
	CBI  0x3,6
; 0000 12E9             czekaj_az_puszcze = 0;
	CALL SUBOPT_0xA2
; 0000 12EA             delay_ms(100);
; 0000 12EB             }
; 0000 12EC 
; 0000 12ED        if(czekaj_az_puszcze == 2 & PORTE.6 == 0)
_0x1F6:
	CALL SUBOPT_0xA1
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x1F9
; 0000 12EE            {
; 0000 12EF             PORTE.6 = 1;
	SBI  0x3,6
; 0000 12F0             czekaj_az_puszcze = 0;
	CALL SUBOPT_0xA2
; 0000 12F1             delay_ms(100);
; 0000 12F2            }
; 0000 12F3 
; 0000 12F4   }
_0x1F9:
; 0000 12F5 }
_0x1F3:
	RET
;
;void ostateczny_wybor_zacisku()
; 0000 12F8 {
_ostateczny_wybor_zacisku:
; 0000 12F9 int rzad;
; 0000 12FA 
; 0000 12FB   if(sek11 > 60) //co 1s sekunde sprawdzam   //jak co 40 to sie wywala
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	LDS  R26,_sek11
	LDS  R27,_sek11+1
	LDS  R24,_sek11+2
	LDS  R25,_sek11+3
	CALL SUBOPT_0x7F
	BRGE PC+3
	JMP _0x1FC
; 0000 12FC         {
; 0000 12FD        sek11 = 0;
	CALL SUBOPT_0xA3
; 0000 12FE        if(odczytalem_zacisk < il_prob_odczytu &
; 0000 12FF                                            (sprawdz_pin0(PORTHH,0x73) == 1 |
; 0000 1300                                             sprawdz_pin1(PORTHH,0x73) == 1 |
; 0000 1301                                             sprawdz_pin2(PORTHH,0x73) == 1 |
; 0000 1302                                             sprawdz_pin3(PORTHH,0x73) == 1 |
; 0000 1303                                             sprawdz_pin4(PORTHH,0x73) == 1 |
; 0000 1304                                             sprawdz_pin5(PORTHH,0x73) == 1 |
; 0000 1305                                             sprawdz_pin6(PORTHH,0x73) == 1 |
; 0000 1306                                             sprawdz_pin7(PORTHH,0x73) == 1))
	MOVW R30,R10
	MOVW R26,R8
	CALL __LTW12
	PUSH R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x94
	PUSH R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x95
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin2
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x97
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin4
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x9D
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x9B
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x98
	POP  R26
	OR   R30,R26
	POP  R26
	AND  R30,R26
	BREQ _0x1FD
; 0000 1307         {
; 0000 1308         odczytalem_zacisk++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 1309         }
; 0000 130A         }
_0x1FD:
; 0000 130B 
; 0000 130C if(odczytalem_zacisk == il_prob_odczytu)
_0x1FC:
	__CPWRR 10,11,8,9
	BRNE _0x1FE
; 0000 130D         {
; 0000 130E         //PORTB = 0xFF;
; 0000 130F         rzad = odczyt_wybranego_zacisku();
	CALL _odczyt_wybranego_zacisku
	MOVW R16,R30
; 0000 1310         //sek10 = 0;
; 0000 1311         sek11 = 0;    //nowe
	CALL SUBOPT_0xA3
; 0000 1312         odczytalem_zacisk++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 1313 
; 0000 1314         //if(rzad == 1)
; 0000 1315         //    wartosc_parametru_panelu(2,32,128);    //tego nie chca
; 0000 1316         //if(rzad == 2)
; 0000 1317         //    wartosc_parametru_panelu(1,32,128);
; 0000 1318 
; 0000 1319         }                                     //& sek10 > 1                //3s po odczytaniu dopiero sprawdzam port
; 0000 131A if((odczytalem_zacisk == il_prob_odczytu + 1))        //183
_0x1FE:
	MOVW R30,R10
	ADIW R30,1
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x1FF
; 0000 131B         {
; 0000 131C 
; 0000 131D         if(rzad == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x200
; 0000 131E             wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad1
	CALL SUBOPT_0xE
	CALL SUBOPT_0xA4
	CALL SUBOPT_0xB
; 0000 131F 
; 0000 1320         if(rzad == 2 & start == 0)
_0x200:
	MOVW R26,R16
	CALL SUBOPT_0xA5
	MOV  R0,R30
	CALL SUBOPT_0xA6
	CALL SUBOPT_0xA0
	BREQ _0x201
; 0000 1321             wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad2
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
; 0000 1322 
; 0000 1323         if(rzad == 2 & start == 1)
_0x201:
	MOVW R26,R16
	CALL SUBOPT_0xA5
	CALL SUBOPT_0x8E
	AND  R30,R0
	BREQ _0x202
; 0000 1324             zaaktualizuj_ilosc_rzad2 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _zaaktualizuj_ilosc_rzad2,R30
	STS  _zaaktualizuj_ilosc_rzad2+1,R31
; 0000 1325 
; 0000 1326 
; 0000 1327         odczytalem_zacisk = 0;
_0x202:
	CLR  R8
	CLR  R9
; 0000 1328         if(start == 1)
	CALL SUBOPT_0xA6
	SBIW R26,1
	BRNE _0x203
; 0000 1329             odczytalem_w_trakcie_czyszczenia_drugiego_rzedu = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu,R30
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1,R31
; 0000 132A         }
_0x203:
; 0000 132B }
_0x1FF:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;
;int sterownik_1_praca(int PORT)
; 0000 1330 {
_sterownik_1_praca:
; 0000 1331 //PORTA.0   IN0  STEROWNIK1
; 0000 1332 //PORTA.1   IN1  STEROWNIK1
; 0000 1333 //PORTA.2   IN2  STEROWNIK1
; 0000 1334 //PORTA.3   IN3  STEROWNIK1
; 0000 1335 //PORTA.4   IN4  STEROWNIK1
; 0000 1336 //PORTA.5   IN5  STEROWNIK1
; 0000 1337 //PORTA.6   IN6  STEROWNIK1
; 0000 1338 //PORTA.7   IN7  STEROWNIK1
; 0000 1339 //PORTD.4   IN8 STEROWNIK1
; 0000 133A 
; 0000 133B //PORTD.2  SETUP   STEROWNIK1
; 0000 133C //PORTD.3  DRIVE   STEROWNIK1
; 0000 133D 
; 0000 133E //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 133F //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 1340 
; 0000 1341 if(sprawdz_pin5(PORTJJ,0x79) == 1)     //if alarn
;	PORT -> Y+0
	CALL SUBOPT_0x29
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x204
; 0000 1342     {
; 0000 1343     PORTD.7 = 1;
	CALL SUBOPT_0xA7
; 0000 1344     PORTE.2 = 0;
; 0000 1345     PORTE.3 = 0;  //szlifierki stop
; 0000 1346     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1347     PORTF = PORT_F.byte;
; 0000 1348 
; 0000 1349     while(1)
_0x20B:
; 0000 134A         {
; 0000 134B         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 134C         komunikat_na_panel("Kolizja XY ukladu krazka",adr1,adr2);
	__POINTW1FN _0x0,1853
	CALL SUBOPT_0x2B
; 0000 134D         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 134E         komunikat_na_panel("Kolizja XY ukladu krazka",adr3,adr4);
	__POINTW1FN _0x0,1853
	CALL SUBOPT_0x86
; 0000 134F         }
	RJMP _0x20B
; 0000 1350 
; 0000 1351     }
; 0000 1352 
; 0000 1353 if(start == 1)
_0x204:
	CALL SUBOPT_0xA6
	SBIW R26,1
	BRNE _0x20E
; 0000 1354     {
; 0000 1355     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xA8
; 0000 1356     obsluga_nacisniecia_zatrzymaj();
; 0000 1357     }
; 0000 1358 switch(cykl_sterownik_1)
_0x20E:
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
; 0000 1359         {
; 0000 135A         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x212
; 0000 135B 
; 0000 135C             sek1 = 0;
	CALL SUBOPT_0xA9
; 0000 135D             PORT_STER1.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER1,R30
; 0000 135E             PORTA.0 = PORT_STER1.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x213
	CBI  0x1B,0
	RJMP _0x214
_0x213:
	SBI  0x1B,0
_0x214:
; 0000 135F             PORTA.1 = PORT_STER1.bits.b1;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x2)
	BRNE _0x215
	CBI  0x1B,1
	RJMP _0x216
_0x215:
	SBI  0x1B,1
_0x216:
; 0000 1360             PORTA.2 = PORT_STER1.bits.b2;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x4)
	BRNE _0x217
	CBI  0x1B,2
	RJMP _0x218
_0x217:
	SBI  0x1B,2
_0x218:
; 0000 1361             PORTA.3 = PORT_STER1.bits.b3;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x8)
	BRNE _0x219
	CBI  0x1B,3
	RJMP _0x21A
_0x219:
	SBI  0x1B,3
_0x21A:
; 0000 1362             PORTA.4 = PORT_STER1.bits.b4;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x10)
	BRNE _0x21B
	CBI  0x1B,4
	RJMP _0x21C
_0x21B:
	SBI  0x1B,4
_0x21C:
; 0000 1363             PORTA.5 = PORT_STER1.bits.b5;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x20)
	BRNE _0x21D
	CBI  0x1B,5
	RJMP _0x21E
_0x21D:
	SBI  0x1B,5
_0x21E:
; 0000 1364             PORTA.6 = PORT_STER1.bits.b6;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x40)
	BRNE _0x21F
	CBI  0x1B,6
	RJMP _0x220
_0x21F:
	SBI  0x1B,6
_0x220:
; 0000 1365             PORTA.7 = PORT_STER1.bits.b7;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x80)
	BRNE _0x221
	CBI  0x1B,7
	RJMP _0x222
_0x221:
	SBI  0x1B,7
_0x222:
; 0000 1366 
; 0000 1367             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x223
; 0000 1368                 PORTD.4 = 1;
	SBI  0x12,4
; 0000 1369 
; 0000 136A 
; 0000 136B 
; 0000 136C             cykl_sterownik_1 = 1;
_0x223:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x517
; 0000 136D 
; 0000 136E         break;
; 0000 136F 
; 0000 1370         case 1:
_0x212:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x226
; 0000 1371 
; 0000 1372             if(sek1 > 1)
	LDS  R26,_sek1
	LDS  R27,_sek1+1
	LDS  R24,_sek1+2
	LDS  R25,_sek1+3
	CALL SUBOPT_0xAA
	BRLT _0x227
; 0000 1373                 {
; 0000 1374 
; 0000 1375                 PORTD.3 = 1;
	SBI  0x12,3
; 0000 1376                 cykl_sterownik_1 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xAB
; 0000 1377                 }
; 0000 1378         break;
_0x227:
	RJMP _0x211
; 0000 1379 
; 0000 137A 
; 0000 137B         case 2:
_0x226:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x22A
; 0000 137C 
; 0000 137D                if(sprawdz_pin0(PORTJJ,0x79) == 0)     //busy
	CALL SUBOPT_0x29
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x22B
; 0000 137E                   {
; 0000 137F 
; 0000 1380                   PORTD.3 = 0;
	CBI  0x12,3
; 0000 1381                   PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 1382                   PORTD.4 = 0;
	CBI  0x12,4
; 0000 1383                   sek1 = 0;
	CALL SUBOPT_0xA9
; 0000 1384                   cykl_sterownik_1 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xAB
; 0000 1385                   }
; 0000 1386 
; 0000 1387         break;
_0x22B:
	RJMP _0x211
; 0000 1388 
; 0000 1389         case 3:
_0x22A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x230
; 0000 138A 
; 0000 138B                if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x29
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x231
; 0000 138C                   {
; 0000 138D 
; 0000 138E                   sek1 = 0;
	CALL SUBOPT_0xA9
; 0000 138F                   cykl_sterownik_1 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xAB
; 0000 1390                   }
; 0000 1391 
; 0000 1392 
; 0000 1393         break;
_0x231:
	RJMP _0x211
; 0000 1394 
; 0000 1395 
; 0000 1396         case 4:
_0x230:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x211
; 0000 1397 
; 0000 1398             if(sprawdz_pin0(PORTJJ,0x79) == 1)
	CALL SUBOPT_0x29
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x233
; 0000 1399                 {
; 0000 139A 
; 0000 139B                 cykl_sterownik_1 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x517:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
; 0000 139C                 }
; 0000 139D         break;
_0x233:
; 0000 139E 
; 0000 139F         }
_0x211:
; 0000 13A0 
; 0000 13A1 return cykl_sterownik_1;
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
	RJMP _0x20A0001
; 0000 13A2 }
;
;
;int sterownik_2_praca(int PORT)
; 0000 13A6 {
_sterownik_2_praca:
; 0000 13A7 //PORTC.0   IN0  STEROWNIK2
; 0000 13A8 //PORTC.1   IN1  STEROWNIK2
; 0000 13A9 //PORTC.2   IN2  STEROWNIK2
; 0000 13AA //PORTC.3   IN3  STEROWNIK2
; 0000 13AB //PORTC.4   IN4  STEROWNIK2
; 0000 13AC //PORTC.5   IN5  STEROWNIK2
; 0000 13AD //PORTC.6   IN6  STEROWNIK2
; 0000 13AE //PORTC.7   IN7  STEROWNIK2
; 0000 13AF //PORTD.5   IN8 STEROWNIK2
; 0000 13B0 
; 0000 13B1 
; 0000 13B2 //PORTD.5  SETUP   STEROWNIK2
; 0000 13B3 //PORTD.6  DRIVE   STEROWNIK2
; 0000 13B4 
; 0000 13B5 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 13B6 //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 13B7 
; 0000 13B8  if(sprawdz_pin5(PORTLL,0x71) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0x9C
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x234
; 0000 13B9     {
; 0000 13BA     PORTD.7 = 1;
	CALL SUBOPT_0xA7
; 0000 13BB     PORTE.2 = 0;
; 0000 13BC     PORTE.3 = 0;  //szlifierki stop
; 0000 13BD     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 13BE     PORTF = PORT_F.byte;
; 0000 13BF 
; 0000 13C0     while(1)
_0x23B:
; 0000 13C1         {
; 0000 13C2         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 13C3         komunikat_na_panel("Kolizja XY ukladu szczotki",adr1,adr2);
	__POINTW1FN _0x0,1878
	CALL SUBOPT_0x2B
; 0000 13C4         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 13C5         komunikat_na_panel("Kolizja XY ukladu szczotki",adr3,adr4);
	__POINTW1FN _0x0,1878
	CALL SUBOPT_0x86
; 0000 13C6         }
	RJMP _0x23B
; 0000 13C7 
; 0000 13C8     }
; 0000 13C9 if(start == 1)
_0x234:
	CALL SUBOPT_0xA6
	SBIW R26,1
	BRNE _0x23E
; 0000 13CA     {
; 0000 13CB     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xA8
; 0000 13CC     obsluga_nacisniecia_zatrzymaj();
; 0000 13CD     }
; 0000 13CE switch(cykl_sterownik_2)
_0x23E:
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
; 0000 13CF         {
; 0000 13D0         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x242
; 0000 13D1 
; 0000 13D2             sek3 = 0;
	CALL SUBOPT_0xAC
; 0000 13D3             PORT_STER2.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER2,R30
; 0000 13D4             PORTC.0 = PORT_STER2.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x243
	CBI  0x15,0
	RJMP _0x244
_0x243:
	SBI  0x15,0
_0x244:
; 0000 13D5             PORTC.1 = PORT_STER2.bits.b1;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x2)
	BRNE _0x245
	CBI  0x15,1
	RJMP _0x246
_0x245:
	SBI  0x15,1
_0x246:
; 0000 13D6             PORTC.2 = PORT_STER2.bits.b2;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x4)
	BRNE _0x247
	CBI  0x15,2
	RJMP _0x248
_0x247:
	SBI  0x15,2
_0x248:
; 0000 13D7             PORTC.3 = PORT_STER2.bits.b3;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x8)
	BRNE _0x249
	CBI  0x15,3
	RJMP _0x24A
_0x249:
	SBI  0x15,3
_0x24A:
; 0000 13D8             PORTC.4 = PORT_STER2.bits.b4;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x10)
	BRNE _0x24B
	CBI  0x15,4
	RJMP _0x24C
_0x24B:
	SBI  0x15,4
_0x24C:
; 0000 13D9             PORTC.5 = PORT_STER2.bits.b5;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x20)
	BRNE _0x24D
	CBI  0x15,5
	RJMP _0x24E
_0x24D:
	SBI  0x15,5
_0x24E:
; 0000 13DA             PORTC.6 = PORT_STER2.bits.b6;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x40)
	BRNE _0x24F
	CBI  0x15,6
	RJMP _0x250
_0x24F:
	SBI  0x15,6
_0x250:
; 0000 13DB             PORTC.7 = PORT_STER2.bits.b7;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x80)
	BRNE _0x251
	CBI  0x15,7
	RJMP _0x252
_0x251:
	SBI  0x15,7
_0x252:
; 0000 13DC             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x253
; 0000 13DD                 PORTD.5 = 1;
	SBI  0x12,5
; 0000 13DE 
; 0000 13DF 
; 0000 13E0             cykl_sterownik_2 = 1;
_0x253:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x518
; 0000 13E1 
; 0000 13E2 
; 0000 13E3         break;
; 0000 13E4 
; 0000 13E5         case 1:
_0x242:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x256
; 0000 13E6 
; 0000 13E7             if(sek3 > 1)
	LDS  R26,_sek3
	LDS  R27,_sek3+1
	LDS  R24,_sek3+2
	LDS  R25,_sek3+3
	CALL SUBOPT_0xAA
	BRLT _0x257
; 0000 13E8                 {
; 0000 13E9                 PORTD.6 = 1;
	SBI  0x12,6
; 0000 13EA                 cykl_sterownik_2 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xAD
; 0000 13EB                 }
; 0000 13EC         break;
_0x257:
	RJMP _0x241
; 0000 13ED 
; 0000 13EE 
; 0000 13EF         case 2:
_0x256:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x25A
; 0000 13F0 
; 0000 13F1                if(sprawdz_pin0(PORTLL,0x71) == 0)     //busy
	CALL SUBOPT_0x9C
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x25B
; 0000 13F2                   {
; 0000 13F3                   PORTD.6 = 0;
	CBI  0x12,6
; 0000 13F4                   PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 13F5                   PORTD.5 = 0;
	CBI  0x12,5
; 0000 13F6                   sek3 = 0;
	CALL SUBOPT_0xAC
; 0000 13F7                   cykl_sterownik_2 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xAD
; 0000 13F8                   }
; 0000 13F9 
; 0000 13FA         break;
_0x25B:
	RJMP _0x241
; 0000 13FB 
; 0000 13FC         case 3:
_0x25A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x260
; 0000 13FD 
; 0000 13FE                if(sprawdz_pin3(PORTLL,0x71) == 0)
	CALL SUBOPT_0x9C
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x261
; 0000 13FF                   {
; 0000 1400                   sek3 = 0;
	CALL SUBOPT_0xAC
; 0000 1401                   cykl_sterownik_2 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xAD
; 0000 1402                   }
; 0000 1403 
; 0000 1404 
; 0000 1405         break;
_0x261:
	RJMP _0x241
; 0000 1406 
; 0000 1407 
; 0000 1408         case 4:
_0x260:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x241
; 0000 1409 
; 0000 140A             if(sprawdz_pin0(PORTLL,0x71) == 1)
	CALL SUBOPT_0x9C
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x263
; 0000 140B                 {
; 0000 140C                 cykl_sterownik_2 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x518:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
; 0000 140D                 }
; 0000 140E         break;
_0x263:
; 0000 140F 
; 0000 1410         }
_0x241:
; 0000 1411 
; 0000 1412 return cykl_sterownik_2;
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
	RJMP _0x20A0001
; 0000 1413 }
;
;
;
;
;
;
;int sterownik_3_praca(int PORT)
; 0000 141B {
_sterownik_3_praca:
; 0000 141C //PORTF.0   IN0  STEROWNIK3
; 0000 141D //PORTF.1   IN1  STEROWNIK3
; 0000 141E //PORTF.2   IN2  STEROWNIK3
; 0000 141F //PORTF.3   IN3  STEROWNIK3
; 0000 1420 //PORTF.7   IN4 STEROWNIK 3
; 0000 1421 //PORTB.7   IN5 STEROWNIK 3
; 0000 1422 
; 0000 1423 
; 0000 1424 
; 0000 1425 //PORTF.5   DRIVE  STEROWNIK3
; 0000 1426 
; 0000 1427 //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 1428 //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 1429 
; 0000 142A if(sprawdz_pin7(PORTMM,0x77) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0x18
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x264
; 0000 142B      {
; 0000 142C      PORTD.7 = 1;
	CALL SUBOPT_0xA7
; 0000 142D      PORTE.2 = 0;
; 0000 142E      PORTE.3 = 0;  //szlifierki stop
; 0000 142F      PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1430      PORTF = PORT_F.byte;
; 0000 1431 
; 0000 1432      while(1)
_0x26B:
; 0000 1433         {
; 0000 1434         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 1435         komunikat_na_panel("Kolizja krazka - wylacz i wlacz maszyne",adr1,adr2);
	__POINTW1FN _0x0,1905
	CALL SUBOPT_0x2B
; 0000 1436         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1437         komunikat_na_panel("Kolizja krazka - wylacz i wlacz maszyne",adr3,adr4);
	__POINTW1FN _0x0,1905
	CALL SUBOPT_0x86
; 0000 1438         }
	RJMP _0x26B
; 0000 1439      }
; 0000 143A if(start == 1)
_0x264:
	CALL SUBOPT_0xA6
	SBIW R26,1
	BRNE _0x26E
; 0000 143B     {
; 0000 143C     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xA8
; 0000 143D     obsluga_nacisniecia_zatrzymaj();
; 0000 143E 
; 0000 143F     }
; 0000 1440 switch(cykl_sterownik_3)
_0x26E:
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
; 0000 1441         {
; 0000 1442         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x272
; 0000 1443 
; 0000 1444             PORT_STER3.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER3,R30
; 0000 1445             PORT_F.bits.b0 = PORT_STER3.bits.b0;
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0xAE
; 0000 1446             PORT_F.bits.b1 = PORT_STER3.bits.b1;
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFD
	CALL SUBOPT_0xAE
; 0000 1447             PORT_F.bits.b2 = PORT_STER3.bits.b2;
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFB
	CALL SUBOPT_0xAE
; 0000 1448             PORT_F.bits.b3 = PORT_STER3.bits.b3;
	LSR  R30
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0XF7
	CALL SUBOPT_0xAE
; 0000 1449             PORT_F.bits.b7 = PORT_STER3.bits.b4;
	SWAP R30
	ANDI R30,LOW(0x1)
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0x7F
	OR   R30,R0
	CALL SUBOPT_0xAF
; 0000 144A             PORTF = PORT_F.byte;
; 0000 144B             PORTB.7 = PORT_STER3.bits.b5;
	LDS  R30,_PORT_STER3
	ANDI R30,LOW(0x20)
	BRNE _0x273
	CBI  0x18,7
	RJMP _0x274
_0x273:
	SBI  0x18,7
_0x274:
; 0000 144C 
; 0000 144D 
; 0000 144E 
; 0000 144F             sek2 = 0;
	CALL SUBOPT_0xB0
; 0000 1450             cykl_sterownik_3 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0xB1
; 0000 1451 
; 0000 1452 
; 0000 1453 
; 0000 1454         break;
	RJMP _0x271
; 0000 1455 
; 0000 1456         case 1:
_0x272:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x275
; 0000 1457 
; 0000 1458 
; 0000 1459             if(sek2 > 1)
	LDS  R26,_sek2
	LDS  R27,_sek2+1
	LDS  R24,_sek2+2
	LDS  R25,_sek2+3
	CALL SUBOPT_0xAA
	BRLT _0x276
; 0000 145A                 {
; 0000 145B 
; 0000 145C                 PORT_F.bits.b5 = 1;
	LDS  R30,_PORT_F
	ORI  R30,0x20
	CALL SUBOPT_0xAF
; 0000 145D                 PORTF = PORT_F.byte;
; 0000 145E                 cykl_sterownik_3 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xB1
; 0000 145F                 }
; 0000 1460         break;
_0x276:
	RJMP _0x271
; 0000 1461 
; 0000 1462 
; 0000 1463         case 2:
_0x275:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x277
; 0000 1464 
; 0000 1465 
; 0000 1466                if(sprawdz_pin0(PORTKK,0x75) == 0)
	CALL SUBOPT_0x96
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x278
; 0000 1467                   {
; 0000 1468                   PORT_F.bits.b5 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xDF
	CALL SUBOPT_0xAF
; 0000 1469                   PORTF = PORT_F.byte;
; 0000 146A 
; 0000 146B                   PORT_F.bits.b0 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0xB2
; 0000 146C                   PORT_F.bits.b1 = 0;
	ANDI R30,0xFD
	CALL SUBOPT_0xB2
; 0000 146D                   PORT_F.bits.b2 = 0;
	ANDI R30,0xFB
	CALL SUBOPT_0xB2
; 0000 146E                   PORT_F.bits.b3 = 0;
	ANDI R30,0XF7
	CALL SUBOPT_0xB2
; 0000 146F                   PORT_F.bits.b7 = 0;
	ANDI R30,0x7F
	CALL SUBOPT_0xAF
; 0000 1470                   PORTF = PORT_F.byte;
; 0000 1471                   PORTB.7 = 0;
	CBI  0x18,7
; 0000 1472 
; 0000 1473                   sek2 = 0;
	CALL SUBOPT_0xB0
; 0000 1474                   cykl_sterownik_3 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xB1
; 0000 1475                   }
; 0000 1476 
; 0000 1477         break;
_0x278:
	RJMP _0x271
; 0000 1478 
; 0000 1479         case 3:
_0x277:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x27B
; 0000 147A 
; 0000 147B 
; 0000 147C                if(sprawdz_pin3(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0x96
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x27C
; 0000 147D                   {
; 0000 147E                   sek2 = 0;
	CALL SUBOPT_0xB0
; 0000 147F                   cykl_sterownik_3 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xB1
; 0000 1480                   }
; 0000 1481 
; 0000 1482 
; 0000 1483         break;
_0x27C:
	RJMP _0x271
; 0000 1484 
; 0000 1485 
; 0000 1486         case 4:
_0x27B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x271
; 0000 1487 
; 0000 1488               if(sprawdz_pin0(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0x96
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x27E
; 0000 1489                 {
; 0000 148A                 cykl_sterownik_3 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0xB1
; 0000 148B 
; 0000 148C 
; 0000 148D                 switch(cykl_sterownik_3_wykonalem)
	LDS  R30,_cykl_sterownik_3_wykonalem
	LDS  R31,_cykl_sterownik_3_wykonalem+1
; 0000 148E                     {
; 0000 148F                     case 0:
	SBIW R30,0
	BRNE _0x282
; 0000 1490                             cykl_sterownik_3_wykonalem = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R31
; 0000 1491                     break;
	RJMP _0x281
; 0000 1492 
; 0000 1493                     case 1:
_0x282:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x281
; 0000 1494                             cykl_sterownik_3_wykonalem = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R30
; 0000 1495                     break;
; 0000 1496 
; 0000 1497                     }
_0x281:
; 0000 1498 
; 0000 1499 
; 0000 149A                 }
; 0000 149B         break;
_0x27E:
; 0000 149C 
; 0000 149D         }
_0x271:
; 0000 149E 
; 0000 149F return cykl_sterownik_3;
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
_0x20A0001:
	ADIW R28,2
	RET
; 0000 14A0 }
;
;//
;//int sterownik_4_praca(char f,char e,char d, char c, char b, char a)
;int sterownik_4_praca(int PORT,int p)
; 0000 14A5 {
_sterownik_4_praca:
; 0000 14A6 
; 0000 14A7 
; 0000 14A8 //PORTB.0   IN0  STEROWNIK4
; 0000 14A9 //PORTB.1   IN1  STEROWNIK4
; 0000 14AA //PORTB.2   IN2  STEROWNIK4
; 0000 14AB //PORTB.3   IN3  STEROWNIK4
; 0000 14AC //PORTE.4  IN4  STEROWNIK4
; 0000 14AD 
; 0000 14AE 
; 0000 14AF 
; 0000 14B0 //PORTB.4   SETUP  STEROWNIK4
; 0000 14B1 //PORTB.5   DRIVE  STEROWNIK4
; 0000 14B2 
; 0000 14B3 //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 14B4 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 14B5 
; 0000 14B6 if(sprawdz_pin6(PORTMM,0x77) == 1)
;	PORT -> Y+2
;	p -> Y+0
	CALL SUBOPT_0x18
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x284
; 0000 14B7     {
; 0000 14B8     PORTD.7 = 1;
	CALL SUBOPT_0xA7
; 0000 14B9     PORTE.2 = 0;
; 0000 14BA     PORTE.3 = 0;
; 0000 14BB     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 14BC     PORTF = PORT_F.byte;
; 0000 14BD 
; 0000 14BE     while(1)
_0x28B:
; 0000 14BF         {
; 0000 14C0         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 14C1         komunikat_na_panel("Kolizja szcz. drucianej - wylacz i wlacz maszyne",adr1,adr2);
	__POINTW1FN _0x0,1945
	CALL SUBOPT_0x2B
; 0000 14C2         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 14C3         komunikat_na_panel("Kolizja szcz. drucianej - wylacz i wlacz maszyne",adr3,adr4);
	__POINTW1FN _0x0,1945
	CALL SUBOPT_0x86
; 0000 14C4         }
	RJMP _0x28B
; 0000 14C5 
; 0000 14C6     }
; 0000 14C7 if(start == 1)
_0x284:
	CALL SUBOPT_0xA6
	SBIW R26,1
	BRNE _0x28E
; 0000 14C8     {
; 0000 14C9     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xA8
; 0000 14CA     obsluga_nacisniecia_zatrzymaj();
; 0000 14CB     }
; 0000 14CC switch(cykl_sterownik_4)
_0x28E:
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
; 0000 14CD         {
; 0000 14CE         case 0:
	SBIW R30,0
	BRNE _0x292
; 0000 14CF 
; 0000 14D0             PORT_STER4.byte = PORT;
	LDD  R30,Y+2
	STS  _PORT_STER4,R30
; 0000 14D1             PORTB.0 = PORT_STER4.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x293
	CBI  0x18,0
	RJMP _0x294
_0x293:
	SBI  0x18,0
_0x294:
; 0000 14D2             PORTB.1 = PORT_STER4.bits.b1;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x2)
	BRNE _0x295
	CBI  0x18,1
	RJMP _0x296
_0x295:
	SBI  0x18,1
_0x296:
; 0000 14D3             PORTB.2 = PORT_STER4.bits.b2;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x4)
	BRNE _0x297
	CBI  0x18,2
	RJMP _0x298
_0x297:
	SBI  0x18,2
_0x298:
; 0000 14D4             PORTB.3 = PORT_STER4.bits.b3;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x8)
	BRNE _0x299
	CBI  0x18,3
	RJMP _0x29A
_0x299:
	SBI  0x18,3
_0x29A:
; 0000 14D5             PORTE.4 = PORT_STER4.bits.b4;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x10)
	BRNE _0x29B
	CBI  0x3,4
	RJMP _0x29C
_0x29B:
	SBI  0x3,4
_0x29C:
; 0000 14D6 
; 0000 14D7 
; 0000 14D8             sek4 = 0;
	CALL SUBOPT_0xB3
; 0000 14D9             cykl_sterownik_4 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x519
; 0000 14DA 
; 0000 14DB         break;
; 0000 14DC 
; 0000 14DD         case 1:
_0x292:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x29D
; 0000 14DE 
; 0000 14DF             if(sek4 > 1)
	LDS  R26,_sek4
	LDS  R27,_sek4+1
	LDS  R24,_sek4+2
	LDS  R25,_sek4+3
	CALL SUBOPT_0xAA
	BRLT _0x29E
; 0000 14E0                 {
; 0000 14E1                 PORTB.5 = 1;
	SBI  0x18,5
; 0000 14E2                 cykl_sterownik_4 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xB4
; 0000 14E3                 }
; 0000 14E4         break;
_0x29E:
	RJMP _0x291
; 0000 14E5 
; 0000 14E6 
; 0000 14E7         case 2:
_0x29D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2A1
; 0000 14E8 
; 0000 14E9                if(sprawdz_pin4(PORTKK,0x75) == 0)
	CALL SUBOPT_0x96
	CALL _sprawdz_pin4
	CPI  R30,0
	BRNE _0x2A2
; 0000 14EA                   {
; 0000 14EB                   PORTB.5 = 0;  //drive
	CBI  0x18,5
; 0000 14EC 
; 0000 14ED                   PORTB.0 = 0;
	CBI  0x18,0
; 0000 14EE                   PORTB.1 = 0;
	CBI  0x18,1
; 0000 14EF                   PORTB.2 = 0;
	CBI  0x18,2
; 0000 14F0                   PORTB.3 = 0;
	CBI  0x18,3
; 0000 14F1                   PORTE.4 = 0;
	CBI  0x3,4
; 0000 14F2 
; 0000 14F3 
; 0000 14F4                   sek4 = 0;
	CALL SUBOPT_0xB3
; 0000 14F5                   cykl_sterownik_4 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xB4
; 0000 14F6                   }
; 0000 14F7 
; 0000 14F8         break;
_0x2A2:
	RJMP _0x291
; 0000 14F9 
; 0000 14FA         case 3:
_0x2A1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2AF
; 0000 14FB 
; 0000 14FC                if(sprawdz_pin7(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0x96
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x2B0
; 0000 14FD                   {
; 0000 14FE                   //if(p == 1)
; 0000 14FF                   //  PORTE.2 = 1;  //wylaczam do testu
; 0000 1500 
; 0000 1501                   sek4 = 0;
	CALL SUBOPT_0xB3
; 0000 1502                   cykl_sterownik_4 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xB4
; 0000 1503                   }
; 0000 1504 
; 0000 1505 
; 0000 1506         break;
_0x2B0:
	RJMP _0x291
; 0000 1507 
; 0000 1508 
; 0000 1509         case 4:
_0x2AF:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x291
; 0000 150A 
; 0000 150B               if(sprawdz_pin4(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0x96
	CALL _sprawdz_pin4
	CPI  R30,LOW(0x1)
	BRNE _0x2B2
; 0000 150C                 {
; 0000 150D                 cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x519:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
; 0000 150E                 }
; 0000 150F         break;
_0x2B2:
; 0000 1510 
; 0000 1511         }
_0x291:
; 0000 1512 
; 0000 1513 return cykl_sterownik_4;
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
	ADIW R28,4
	RET
; 0000 1514 }
;
;
;void test_geometryczny()
; 0000 1518 {
_test_geometryczny:
; 0000 1519 int cykl_testu,d;
; 0000 151A int ff[12];
; 0000 151B int i;
; 0000 151C d = 0;
	SBIW R28,24
	CALL __SAVELOCR6
;	cykl_testu -> R16,R17
;	d -> R18,R19
;	ff -> Y+6
;	i -> R20,R21
	__GETWRN 18,19,0
; 0000 151D cykl_testu = 0;
	__GETWRN 16,17,0
; 0000 151E 
; 0000 151F for(i=0;i<11;i++)
	__GETWRN 20,21,0
_0x2B4:
	__CPWRN 20,21,11
	BRGE _0x2B5
; 0000 1520      ff[i]=0;
	MOVW R30,R20
	CALL SUBOPT_0xB5
	CALL SUBOPT_0x33
	__ADDWRN 20,21,1
	RJMP _0x2B4
_0x2B5:
; 0000 1523 manualny_wybor_zacisku = 145;
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	STS  _manualny_wybor_zacisku,R30
	STS  _manualny_wybor_zacisku+1,R31
; 0000 1524 manualny_wybor_zacisku = odczytaj_parametr(48,128);
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1C
	STS  _manualny_wybor_zacisku,R30
	STS  _manualny_wybor_zacisku+1,R31
; 0000 1525 
; 0000 1526 if(manualny_wybor_zacisku != 145)
	LDS  R26,_manualny_wybor_zacisku
	LDS  R27,_manualny_wybor_zacisku+1
	CPI  R26,LOW(0x91)
	LDI  R30,HIGH(0x91)
	CPC  R27,R30
	BREQ _0x2B6
; 0000 1527     {
; 0000 1528     macierz_zaciskow[1] = manualny_wybor_zacisku;
	LDS  R30,_manualny_wybor_zacisku
	LDS  R31,_manualny_wybor_zacisku+1
	__PUTW1MN _macierz_zaciskow,2
; 0000 1529     macierz_zaciskow[2] = manualny_wybor_zacisku;
	__PUTW1MN _macierz_zaciskow,4
; 0000 152A     }
; 0000 152B 
; 0000 152C                                                                    //swiatlo czer       //swiatlo zolte
; 0000 152D if(test_geometryczny_rzad_1 == 1 & test_geometryczny_rzad_2 == 0 & PORTD.7 == 0  & PORT_F.bits.b6 == 0 &
_0x2B6:
; 0000 152E     il_zaciskow_rzad_1 > 1 & macierz_zaciskow[1]!=0 & sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0xB6
	CALL SUBOPT_0x75
	MOV  R0,R30
	CALL SUBOPT_0xB7
	CALL SUBOPT_0xB8
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xBB
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	POP  R26
	AND  R30,R26
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x2B7
; 0000 152F     {
; 0000 1530     while(test_geometryczny_rzad_1 == 1)
_0x2B8:
	CALL SUBOPT_0xB6
	SBIW R26,1
	BREQ PC+3
	JMP _0x2BA
; 0000 1531         {
; 0000 1532         switch(cykl_testu)
	MOVW R30,R16
; 0000 1533             {
; 0000 1534              case 0:
	SBIW R30,0
	BRNE _0x2BE
; 0000 1535 
; 0000 1536                wybor_linijek_sterownikow(1);
	CALL SUBOPT_0xBC
; 0000 1537                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	CALL SUBOPT_0xBD
; 0000 1538                cykl_sterownik_1 = 0;
; 0000 1539                cykl_sterownik_2 = 0;
; 0000 153A                cykl_sterownik_3 = 0;
; 0000 153B                cykl_sterownik_4 = 0;
; 0000 153C                wybor_linijek_sterownikow(1);
	CALL SUBOPT_0xBC
; 0000 153D                cykl_testu = 1;
	__GETWRN 16,17,1
; 0000 153E 
; 0000 153F 
; 0000 1540 
; 0000 1541             break;
	RJMP _0x2BD
; 0000 1542 
; 0000 1543             case 1:
_0x2BE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2C1
; 0000 1544 
; 0000 1545             //na sam dol zjezdzamy pionami
; 0000 1546                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x2C2
; 0000 1547                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xBF
; 0000 1548                 if(cykl_sterownik_4 < 5)
_0x2C2:
	CALL SUBOPT_0xC0
	SBIW R26,5
	BRGE _0x2C3
; 0000 1549                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 154A 
; 0000 154B                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2C3:
	CALL SUBOPT_0xC2
	BREQ _0x2C4
; 0000 154C                                         {
; 0000 154D                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC3
; 0000 154E                                         cykl_sterownik_4 = 0;
; 0000 154F                                         cykl_testu = 2;
	__GETWRN 16,17,2
; 0000 1550                                         }
; 0000 1551 
; 0000 1552 
; 0000 1553 
; 0000 1554             break;
_0x2C4:
	RJMP _0x2BD
; 0000 1555 
; 0000 1556 
; 0000 1557             case 2:
_0x2C1:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2C5
; 0000 1558 
; 0000 1559                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x2C6
; 0000 155A                                     cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC5
; 0000 155B                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy
_0x2C6:
	CALL SUBOPT_0xC6
	SBIW R26,5
	BRGE _0x2C7
; 0000 155C                                     cykl_sterownik_2 = sterownik_2_praca(0x008);       //ster 2 ucieczka do zera (druciak)
	CALL SUBOPT_0xC7
	CALL SUBOPT_0xC8
; 0000 155D 
; 0000 155E                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x2C7:
	CALL SUBOPT_0xC9
	BREQ _0x2C8
; 0000 155F                                         {
; 0000 1560                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1561                                         cykl_sterownik_2 = 0;
; 0000 1562                                         cykl_sterownik_3 = 0;
; 0000 1563                                         cykl_sterownik_4 = 0;
; 0000 1564                                         cykl_testu = 3;
	__GETWRN 16,17,3
; 0000 1565 
; 0000 1566                                         }
; 0000 1567 
; 0000 1568             break;
_0x2C8:
	RJMP _0x2BD
; 0000 1569 
; 0000 156A 
; 0000 156B             case 3:
_0x2C5:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2C9
; 0000 156C 
; 0000 156D                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x2CA
; 0000 156E                                     cykl_sterownik_1 = sterownik_1_praca(a[0]); //ster 1 pod srodek zacisku
	CALL SUBOPT_0xCB
	CALL SUBOPT_0xC5
; 0000 156F 
; 0000 1570                                     if(cykl_sterownik_1 == 5)
_0x2CA:
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRNE _0x2CB
; 0000 1571                                         {
; 0000 1572                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1573                                         cykl_sterownik_2 = 0;
; 0000 1574                                         cykl_sterownik_3 = 0;
; 0000 1575                                         cykl_sterownik_4 = 0;
; 0000 1576                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 1577                                         }
; 0000 1578 
; 0000 1579             break;
_0x2CB:
	RJMP _0x2BD
; 0000 157A 
; 0000 157B             case 4:
_0x2C9:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2CC
; 0000 157C 
; 0000 157D                                    if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x2CD
; 0000 157E                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
	CALL SUBOPT_0x6B
	CALL SUBOPT_0xCC
; 0000 157F 
; 0000 1580                                    if(cykl_sterownik_3 == 5)
_0x2CD:
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRNE _0x2CE
; 0000 1581                                         {
; 0000 1582                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1583                                         cykl_sterownik_2 = 0;
; 0000 1584                                         cykl_sterownik_3 = 0;
; 0000 1585                                         cykl_sterownik_4 = 0;
; 0000 1586                                         cykl_testu = 5;
	__GETWRN 16,17,5
; 0000 1587                                         }
; 0000 1588 
; 0000 1589             break;
_0x2CE:
	RJMP _0x2BD
; 0000 158A 
; 0000 158B             case 5:
_0x2CC:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2CF
; 0000 158C                                    if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x2D0
; 0000 158D                                    {
; 0000 158E                                      d = odczytaj_parametr(48,80);
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x25
	MOVW R18,R30
; 0000 158F                                         if(d == 0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x2D1
; 0000 1590                                             cykl_testu = 666;
	__GETWRN 16,17,666
; 0000 1591 
; 0000 1592                                         if(d == 2 & ff[2] == 0)
_0x2D1:
	MOVW R26,R18
	CALL SUBOPT_0xA5
	MOV  R0,R30
	CALL SUBOPT_0x16
	BREQ _0x2D2
; 0000 1593                                             {
; 0000 1594                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1595                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 1596                                             }
; 0000 1597                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
_0x2D2:
	CALL SUBOPT_0xCE
	AND  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0xA0
	BREQ _0x2D3
; 0000 1598                                             {
; 0000 1599                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 159A                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 159B                                             }
; 0000 159C                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
_0x2D3:
	CALL SUBOPT_0xCF
	AND  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0xA0
	BREQ _0x2D4
; 0000 159D                                             {
; 0000 159E                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 159F                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 15A0                                             }
; 0000 15A1                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
_0x2D4:
	CALL SUBOPT_0xD0
	AND  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0xA0
	BREQ _0x2D5
; 0000 15A2                                             {
; 0000 15A3                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 15A4                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 15A5                                             }
; 0000 15A6                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
_0x2D5:
	CALL SUBOPT_0xD1
	AND  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0xA0
	BREQ _0x2D6
; 0000 15A7                                             {
; 0000 15A8                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 15A9                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 15AA                                             }
; 0000 15AB                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
_0x2D6:
	CALL SUBOPT_0xD2
	AND  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0xA0
	BREQ _0x2D7
; 0000 15AC                                             {
; 0000 15AD                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 15AE                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 15AF                                             }
; 0000 15B0                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
_0x2D7:
	CALL SUBOPT_0xD3
	AND  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0xA0
	BREQ _0x2D8
; 0000 15B1                                             {
; 0000 15B2                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 15B3                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 15B4                                             }
; 0000 15B5                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
_0x2D8:
	CALL SUBOPT_0xD4
	AND  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CALL SUBOPT_0xA0
	BREQ _0x2D9
; 0000 15B6                                             {
; 0000 15B7                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 15B8                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 15B9                                             }
; 0000 15BA                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
_0x2D9:
	CALL SUBOPT_0xD5
	AND  R0,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL SUBOPT_0xA0
	BREQ _0x2DA
; 0000 15BB                                             {
; 0000 15BC                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 15BD                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 15BE                                             }
; 0000 15BF                                     }
_0x2DA:
; 0000 15C0 
; 0000 15C1             break;
_0x2D0:
	RJMP _0x2BD
; 0000 15C2 
; 0000 15C3             case 6:
_0x2CF:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2DB
; 0000 15C4                                      if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x2DC
; 0000 15C5                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xBF
; 0000 15C6                                         if(cykl_sterownik_3 == 5)
_0x2DC:
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRNE _0x2DD
; 0000 15C7                                             {
; 0000 15C8                                             cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 15C9                                             cykl_sterownik_2 = 0;
; 0000 15CA                                             cykl_sterownik_3 = 0;
; 0000 15CB                                             cykl_sterownik_4 = 0;
; 0000 15CC                                             cykl_testu = 7;
	__GETWRN 16,17,7
; 0000 15CD                                             }
; 0000 15CE 
; 0000 15CF             break;
_0x2DD:
	RJMP _0x2BD
; 0000 15D0 
; 0000 15D1             case 7:
_0x2DB:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2DE
; 0000 15D2 
; 0000 15D3                                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x2DF
; 0000 15D4                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
	CALL SUBOPT_0xD6
; 0000 15D5 
; 0000 15D6                                     if(cykl_sterownik_1 == 5)
_0x2DF:
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRNE _0x2E0
; 0000 15D7                                         {
; 0000 15D8                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 15D9                                         cykl_sterownik_2 = 0;
; 0000 15DA                                         cykl_sterownik_3 = 0;
; 0000 15DB                                         cykl_sterownik_4 = 0;
; 0000 15DC                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 15DD                                         }
; 0000 15DE 
; 0000 15DF 
; 0000 15E0             break;
_0x2E0:
	RJMP _0x2BD
; 0000 15E1 
; 0000 15E2 
; 0000 15E3 
; 0000 15E4 
; 0000 15E5 
; 0000 15E6 
; 0000 15E7 
; 0000 15E8             case 666:
_0x2DE:
	CPI  R30,LOW(0x29A)
	LDI  R26,HIGH(0x29A)
	CPC  R31,R26
	BRNE _0x2BD
; 0000 15E9 
; 0000 15EA                                         if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x2E2
; 0000 15EB                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xBF
; 0000 15EC                                         if(cykl_sterownik_3 == 5)
_0x2E2:
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRNE _0x2E3
; 0000 15ED                                             {
; 0000 15EE                                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC3
; 0000 15EF                                             cykl_sterownik_4 = 0;
; 0000 15F0                                             cykl_testu = 100;
	__GETWRN 16,17,100
; 0000 15F1                                             test_geometryczny_rzad_1 = 0;
	LDI  R30,LOW(0)
	STS  _test_geometryczny_rzad_1,R30
	STS  _test_geometryczny_rzad_1+1,R30
; 0000 15F2                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 15F3                                             }
; 0000 15F4 
; 0000 15F5             break;
_0x2E3:
; 0000 15F6 
; 0000 15F7 
; 0000 15F8 
; 0000 15F9             }
_0x2BD:
; 0000 15FA 
; 0000 15FB         }
	RJMP _0x2B8
_0x2BA:
; 0000 15FC     }
; 0000 15FD 
; 0000 15FE 
; 0000 15FF 
; 0000 1600                                                                    //swiatlo czer       //swiatlo zolte
; 0000 1601 if(test_geometryczny_rzad_1 == 0 & test_geometryczny_rzad_2 == 1 & PORTD.7 == 0  & PORT_F.bits.b6 == 0 &
_0x2B7:
; 0000 1602     il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0 & sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xB8
	MOV  R0,R30
	CALL SUBOPT_0xB7
	CALL SUBOPT_0x75
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xD8
	CALL SUBOPT_0xD9
	AND  R30,R0
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	POP  R26
	AND  R30,R26
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x2E6
; 0000 1603     {
; 0000 1604     while(test_geometryczny_rzad_2 == 1)
_0x2E7:
	CALL SUBOPT_0xB7
	SBIW R26,1
	BREQ PC+3
	JMP _0x2E9
; 0000 1605         {
; 0000 1606         switch(cykl_testu)
	MOVW R30,R16
; 0000 1607             {
; 0000 1608              case 0:
	SBIW R30,0
	BRNE _0x2ED
; 0000 1609 
; 0000 160A                wybor_linijek_sterownikow(2);
	CALL SUBOPT_0xDA
; 0000 160B                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	CALL SUBOPT_0xBD
; 0000 160C                cykl_sterownik_1 = 0;
; 0000 160D                cykl_sterownik_2 = 0;
; 0000 160E                cykl_sterownik_3 = 0;
; 0000 160F                cykl_sterownik_4 = 0;
; 0000 1610                wybor_linijek_sterownikow(2);
	CALL SUBOPT_0xDA
; 0000 1611                cykl_testu = 1;
	__GETWRN 16,17,1
; 0000 1612 
; 0000 1613 
; 0000 1614 
; 0000 1615             break;
	RJMP _0x2EC
; 0000 1616 
; 0000 1617             case 1:
_0x2ED:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2F0
; 0000 1618 
; 0000 1619             //na sam dol zjezdzamy pionami
; 0000 161A                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x2F1
; 0000 161B                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xBF
; 0000 161C                 if(cykl_sterownik_4 < 5)
_0x2F1:
	CALL SUBOPT_0xC0
	SBIW R26,5
	BRGE _0x2F2
; 0000 161D                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 161E 
; 0000 161F                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2F2:
	CALL SUBOPT_0xC2
	BREQ _0x2F3
; 0000 1620                                         {
; 0000 1621                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC3
; 0000 1622                                         cykl_sterownik_4 = 0;
; 0000 1623                                         cykl_testu = 2;
	__GETWRN 16,17,2
; 0000 1624                                         }
; 0000 1625 
; 0000 1626 
; 0000 1627 
; 0000 1628             break;
_0x2F3:
	RJMP _0x2EC
; 0000 1629 
; 0000 162A 
; 0000 162B             case 2:
_0x2F0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2F4
; 0000 162C 
; 0000 162D                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x2F5
; 0000 162E                                     cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xC5
; 0000 162F                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy rzad 2
_0x2F5:
	CALL SUBOPT_0xC6
	SBIW R26,5
	BRGE _0x2F6
; 0000 1630                                     cykl_sterownik_2 = sterownik_2_praca(0x009);       //ster 2 ucieczka dla II rzedu (druciak)
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xC8
; 0000 1631 
; 0000 1632                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x2F6:
	CALL SUBOPT_0xC9
	BREQ _0x2F7
; 0000 1633                                         {
; 0000 1634                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1635                                         cykl_sterownik_2 = 0;
; 0000 1636                                         cykl_sterownik_3 = 0;
; 0000 1637                                         cykl_sterownik_4 = 0;
; 0000 1638                                         cykl_testu = 3;
	__GETWRN 16,17,3
; 0000 1639 
; 0000 163A                                         }
; 0000 163B 
; 0000 163C             break;
_0x2F7:
	RJMP _0x2EC
; 0000 163D 
; 0000 163E 
; 0000 163F             case 3:
_0x2F4:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2F8
; 0000 1640 
; 0000 1641                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x2F9
; 0000 1642                                     cykl_sterownik_1 = sterownik_1_praca(a[1]); //ster 1 pod srodek zacisku
	CALL SUBOPT_0xDD
	CALL SUBOPT_0xC5
; 0000 1643 
; 0000 1644                                     if(cykl_sterownik_1 == 5)
_0x2F9:
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRNE _0x2FA
; 0000 1645                                         {
; 0000 1646                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1647                                         cykl_sterownik_2 = 0;
; 0000 1648                                         cykl_sterownik_3 = 0;
; 0000 1649                                         cykl_sterownik_4 = 0;
; 0000 164A                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 164B                                         }
; 0000 164C 
; 0000 164D             break;
_0x2FA:
	RJMP _0x2EC
; 0000 164E 
; 0000 164F             case 4:
_0x2F8:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2FB
; 0000 1650 
; 0000 1651                                    if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x2FC
; 0000 1652                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
	CALL SUBOPT_0x6B
	CALL SUBOPT_0xCC
; 0000 1653 
; 0000 1654                                    if(cykl_sterownik_3 == 5)
_0x2FC:
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRNE _0x2FD
; 0000 1655                                         {
; 0000 1656                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1657                                         cykl_sterownik_2 = 0;
; 0000 1658                                         cykl_sterownik_3 = 0;
; 0000 1659                                         cykl_sterownik_4 = 0;
; 0000 165A                                         cykl_testu = 5;
	__GETWRN 16,17,5
; 0000 165B                                         }
; 0000 165C 
; 0000 165D             break;
_0x2FD:
	RJMP _0x2EC
; 0000 165E 
; 0000 165F             case 5:
_0x2FB:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2FE
; 0000 1660                                      if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x2FF
; 0000 1661                                      {
; 0000 1662                                      d = odczytaj_parametr(48,96);
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0xA
	CALL SUBOPT_0x24
	MOVW R18,R30
; 0000 1663                                         if(d == 0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x300
; 0000 1664                                             cykl_testu = 666;
	__GETWRN 16,17,666
; 0000 1665 
; 0000 1666 
; 0000 1667 
; 0000 1668 
; 0000 1669                                         if(d == 2 & ff[2] == 0)
_0x300:
	MOVW R26,R18
	CALL SUBOPT_0xA5
	MOV  R0,R30
	CALL SUBOPT_0x16
	BREQ _0x301
; 0000 166A                                             {
; 0000 166B                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 166C                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 166D                                             }
; 0000 166E                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
_0x301:
	CALL SUBOPT_0xCE
	AND  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0xA0
	BREQ _0x302
; 0000 166F                                             {
; 0000 1670                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1671                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 1672                                             }
; 0000 1673                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
_0x302:
	CALL SUBOPT_0xCF
	AND  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0xA0
	BREQ _0x303
; 0000 1674                                             {
; 0000 1675                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1676                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 1677                                             }
; 0000 1678                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
_0x303:
	CALL SUBOPT_0xD0
	AND  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0xA0
	BREQ _0x304
; 0000 1679                                             {
; 0000 167A                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 167B                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 167C                                             }
; 0000 167D                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
_0x304:
	CALL SUBOPT_0xD1
	AND  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0xA0
	BREQ _0x305
; 0000 167E                                             {
; 0000 167F                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1680                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 1681                                             }
; 0000 1682                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
_0x305:
	CALL SUBOPT_0xD2
	AND  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0xA0
	BREQ _0x306
; 0000 1683                                             {
; 0000 1684                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1685                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 1686                                             }
; 0000 1687                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
_0x306:
	CALL SUBOPT_0xD3
	AND  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0xA0
	BREQ _0x307
; 0000 1688                                             {
; 0000 1689                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 168A                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 168B                                             }
; 0000 168C                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
_0x307:
	CALL SUBOPT_0xD4
	AND  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CALL SUBOPT_0xA0
	BREQ _0x308
; 0000 168D                                             {
; 0000 168E                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 168F                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 1690                                             }
; 0000 1691                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
_0x308:
	CALL SUBOPT_0xD5
	AND  R0,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL SUBOPT_0xA0
	BREQ _0x309
; 0000 1692                                             {
; 0000 1693                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1694                                             ff[d]=1;
	CALL SUBOPT_0x2F
; 0000 1695                                             }
; 0000 1696 
; 0000 1697                                       }
_0x309:
; 0000 1698             break;
_0x2FF:
	RJMP _0x2EC
; 0000 1699 
; 0000 169A             case 6:
_0x2FE:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x30A
; 0000 169B                                      if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x30B
; 0000 169C                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xBF
; 0000 169D                                         if(cykl_sterownik_3 == 5)
_0x30B:
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRNE _0x30C
; 0000 169E                                             {
; 0000 169F                                             cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 16A0                                             cykl_sterownik_2 = 0;
; 0000 16A1                                             cykl_sterownik_3 = 0;
; 0000 16A2                                             cykl_sterownik_4 = 0;
; 0000 16A3                                             cykl_testu = 7;
	__GETWRN 16,17,7
; 0000 16A4                                             }
; 0000 16A5 
; 0000 16A6             break;
_0x30C:
	RJMP _0x2EC
; 0000 16A7 
; 0000 16A8             case 7:
_0x30A:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x30D
; 0000 16A9 
; 0000 16AA                                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x30E
; 0000 16AB                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
	CALL SUBOPT_0xD6
; 0000 16AC 
; 0000 16AD                                     if(cykl_sterownik_1 == 5)
_0x30E:
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRNE _0x30F
; 0000 16AE                                         {
; 0000 16AF                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 16B0                                         cykl_sterownik_2 = 0;
; 0000 16B1                                         cykl_sterownik_3 = 0;
; 0000 16B2                                         cykl_sterownik_4 = 0;
; 0000 16B3                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 16B4                                         }
; 0000 16B5 
; 0000 16B6 
; 0000 16B7             break;
_0x30F:
	RJMP _0x2EC
; 0000 16B8 
; 0000 16B9 
; 0000 16BA 
; 0000 16BB             case 666:
_0x30D:
	CPI  R30,LOW(0x29A)
	LDI  R26,HIGH(0x29A)
	CPC  R31,R26
	BRNE _0x2EC
; 0000 16BC 
; 0000 16BD                                         if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x311
; 0000 16BE                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xBF
; 0000 16BF                                         if(cykl_sterownik_3 == 5)
_0x311:
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRNE _0x312
; 0000 16C0                                             {
; 0000 16C1                                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC3
; 0000 16C2                                             cykl_sterownik_4 = 0;
; 0000 16C3                                             cykl_testu = 100;
	__GETWRN 16,17,100
; 0000 16C4                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 16C5                                             test_geometryczny_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _test_geometryczny_rzad_2,R30
	STS  _test_geometryczny_rzad_2+1,R30
; 0000 16C6                                             }
; 0000 16C7 
; 0000 16C8             break;
_0x312:
; 0000 16C9 
; 0000 16CA 
; 0000 16CB 
; 0000 16CC             }
_0x2EC:
; 0000 16CD 
; 0000 16CE         }
	RJMP _0x2E7
_0x2E9:
; 0000 16CF     }
; 0000 16D0 
; 0000 16D1 
; 0000 16D2 
; 0000 16D3 
; 0000 16D4 }
_0x2E6:
	CALL __LOADLOCR6
	ADIW R28,30
	RET
;
;
;
;
;
;void kontrola_zoltego_swiatla()
; 0000 16DB {
_kontrola_zoltego_swiatla:
; 0000 16DC 
; 0000 16DD 
; 0000 16DE if(czas_pracy_szczotki_drucianej_h >= czas_pracy_szczotki_drucianej_stala)
	CALL SUBOPT_0xDE
	MOVW R0,R30
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL SUBOPT_0xDF
	BRLT _0x315
; 0000 16DF      {
; 0000 16E0      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0xE0
; 0000 16E1      PORTF = PORT_F.byte;
; 0000 16E2      komunikat_na_panel("                                                ",80,0);
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL _komunikat_na_panel
; 0000 16E3      komunikat_na_panel("Wymien szczotke druciana",80,0);
	__POINTW1FN _0x0,1994
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xE2
	CALL _komunikat_na_panel
; 0000 16E4      }
; 0000 16E5 
; 0000 16E6 if(czas_pracy_krazka_sciernego_h_34 >= czas_pracy_krazka_sciernego_stala)
_0x315:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_34)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_34)
	CALL SUBOPT_0xE3
	BRLT _0x316
; 0000 16E7      {
; 0000 16E8      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0xE0
; 0000 16E9      PORTF = PORT_F.byte;
; 0000 16EA      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE4
	CALL _komunikat_na_panel
; 0000 16EB      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 34",64,0);
	__POINTW1FN _0x0,2019
	CALL SUBOPT_0xE5
	CALL _komunikat_na_panel
; 0000 16EC      }
; 0000 16ED 
; 0000 16EE if(czas_pracy_krazka_sciernego_h_36 >= czas_pracy_krazka_sciernego_stala)
_0x316:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_36)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_36)
	CALL SUBOPT_0xE3
	BRLT _0x317
; 0000 16EF      {
; 0000 16F0      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0xE0
; 0000 16F1      PORTF = PORT_F.byte;
; 0000 16F2      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE4
	CALL _komunikat_na_panel
; 0000 16F3      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 36",64,0);
	__POINTW1FN _0x0,2066
	CALL SUBOPT_0xE5
	CALL _komunikat_na_panel
; 0000 16F4      }
; 0000 16F5 
; 0000 16F6 if(czas_pracy_krazka_sciernego_h_38 >= czas_pracy_krazka_sciernego_stala)
_0x317:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_38)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_38)
	CALL SUBOPT_0xE3
	BRLT _0x318
; 0000 16F7      {
; 0000 16F8      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0xE0
; 0000 16F9      PORTF = PORT_F.byte;
; 0000 16FA      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE4
	CALL _komunikat_na_panel
; 0000 16FB      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 38",64,0);
	__POINTW1FN _0x0,2113
	CALL SUBOPT_0xE5
	CALL _komunikat_na_panel
; 0000 16FC      }
; 0000 16FD 
; 0000 16FE if(czas_pracy_krazka_sciernego_h_41 >= czas_pracy_krazka_sciernego_stala)
_0x318:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_41)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_41)
	CALL SUBOPT_0xE3
	BRLT _0x319
; 0000 16FF      {
; 0000 1700      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0xE0
; 0000 1701      PORTF = PORT_F.byte;
; 0000 1702      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE4
	CALL _komunikat_na_panel
; 0000 1703      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 41",64,0);
	__POINTW1FN _0x0,2160
	CALL SUBOPT_0xE5
	CALL _komunikat_na_panel
; 0000 1704      }
; 0000 1705 
; 0000 1706 if(czas_pracy_krazka_sciernego_h_43 >= czas_pracy_krazka_sciernego_stala)
_0x319:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_43)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_43)
	CALL SUBOPT_0xE3
	BRLT _0x31A
; 0000 1707      {
; 0000 1708      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0xE0
; 0000 1709      PORTF = PORT_F.byte;
; 0000 170A      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE4
	CALL _komunikat_na_panel
; 0000 170B      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 43",64,0);
	__POINTW1FN _0x0,2207
	CALL SUBOPT_0xE5
	CALL _komunikat_na_panel
; 0000 170C      }
; 0000 170D 
; 0000 170E 
; 0000 170F 
; 0000 1710 }
_0x31A:
	RET
;
;void wymiana_szczotki_i_krazka()
; 0000 1713 {
_wymiana_szczotki_i_krazka:
; 0000 1714 int g,e,f,d,cykl_wymiany;
; 0000 1715 cykl_wymiany = 0;
	SBIW R28,4
	CALL __SAVELOCR6
;	g -> R16,R17
;	e -> R18,R19
;	f -> R20,R21
;	d -> Y+8
;	cykl_wymiany -> Y+6
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 1716                       //30 //20
; 0000 1717 
; 0000 1718 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	POP  R26
	AND  R30,R26
	BREQ _0x31B
; 0000 1719 {
; 0000 171A g = odczytaj_parametr(48,32);  //szczotka druciana
	CALL SUBOPT_0x1E
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x24
	MOVW R16,R30
; 0000 171B                     //30  //30
; 0000 171C f = odczytaj_parametr(48,48);  //krazek scierny
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
	CALL _odczytaj_parametr
	MOVW R20,R30
; 0000 171D }
; 0000 171E 
; 0000 171F while(g == 1)
_0x31B:
_0x31C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+3
	JMP _0x31E
; 0000 1720     {
; 0000 1721     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 1722     {
; 0000 1723     case 0:
	SBIW R30,0
	BRNE _0x322
; 0000 1724 
; 0000 1725                cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1726                cykl_sterownik_2 = 0;
; 0000 1727                cykl_sterownik_3 = 0;
; 0000 1728                cykl_sterownik_4 = 0;
; 0000 1729                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 172A                cykl_wymiany = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 172B 
; 0000 172C 
; 0000 172D 
; 0000 172E     break;
	RJMP _0x321
; 0000 172F 
; 0000 1730     case 1:
_0x322:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x325
; 0000 1731 
; 0000 1732             //na sam dol zjezdzamy pionami
; 0000 1733                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x326
; 0000 1734                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xBF
; 0000 1735                 if(cykl_sterownik_4 < 5)
_0x326:
	CALL SUBOPT_0xC0
	SBIW R26,5
	BRGE _0x327
; 0000 1736                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 1737 
; 0000 1738                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x327:
	CALL SUBOPT_0xC2
	BREQ _0x328
; 0000 1739 
; 0000 173A                             {
; 0000 173B                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC3
; 0000 173C                                         cykl_sterownik_4 = 0;
; 0000 173D                                         cykl_wymiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 173E                                         }
; 0000 173F 
; 0000 1740 
; 0000 1741 
; 0000 1742     break;
_0x328:
	RJMP _0x321
; 0000 1743 
; 0000 1744 
; 0000 1745 
; 0000 1746     case 2:
_0x325:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x329
; 0000 1747 
; 0000 1748                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x32A
; 0000 1749                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0xE6
	CALL SUBOPT_0xC5
; 0000 174A                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x32A:
	CALL SUBOPT_0xC6
	SBIW R26,5
	BRGE _0x32B
; 0000 174B                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xE6
	CALL SUBOPT_0xC8
; 0000 174C 
; 0000 174D                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x32B:
	CALL SUBOPT_0xC9
	BREQ _0x32C
; 0000 174E                                         {
; 0000 174F                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1750                                         cykl_sterownik_2 = 0;
; 0000 1751                                         cykl_sterownik_3 = 0;
; 0000 1752                                         cykl_sterownik_4 = 0;
; 0000 1753                                          cykl_wymiany = 3;
	CALL SUBOPT_0xE7
; 0000 1754 
; 0000 1755                                         }
; 0000 1756 
; 0000 1757     break;
_0x32C:
	RJMP _0x321
; 0000 1758 
; 0000 1759 
; 0000 175A 
; 0000 175B     case 3:
_0x329:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x32D
; 0000 175C 
; 0000 175D             //na sam dol zjezdzamy pionami
; 0000 175E                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x32E
; 0000 175F                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xCC
; 0000 1760                 if(cykl_sterownik_4 < 5)
_0x32E:
	CALL SUBOPT_0xC0
	SBIW R26,5
	BRGE _0x32F
; 0000 1761                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
	CALL SUBOPT_0xE8
	CALL SUBOPT_0xC1
; 0000 1762 
; 0000 1763                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x32F:
	CALL SUBOPT_0xC2
	BRNE PC+3
	JMP _0x330
; 0000 1764 
; 0000 1765                             {
; 0000 1766                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC3
; 0000 1767                                         cykl_sterownik_4 = 0;
; 0000 1768                                         d = odczytaj_parametr(48,32);
	CALL SUBOPT_0x1E
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x24
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 1769 
; 0000 176A                                         switch (d)
; 0000 176B                                         {
; 0000 176C                                         case 0:
	SBIW R30,0
	BRNE _0x334
; 0000 176D 
; 0000 176E                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	POP  R26
	AND  R30,R26
	BREQ _0x335
; 0000 176F                                                 {
; 0000 1770                                                 cykl_wymiany = 4;
	CALL SUBOPT_0xE9
; 0000 1771                                                 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1772                                                 }
; 0000 1773                                              //jednak nie wymianiamy
; 0000 1774 
; 0000 1775                                         break;
_0x335:
	RJMP _0x333
; 0000 1776 
; 0000 1777                                         case 1:
_0x334:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x338
; 0000 1778                                              cykl_wymiany = 3;
	CALL SUBOPT_0xE7
; 0000 1779                                              PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 177A                                              //czekam z decyzja - w trakcie wymiany
; 0000 177B                                         break;
	RJMP _0x333
; 0000 177C 
; 0000 177D                                         case 2:
_0x338:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x333
; 0000 177E 
; 0000 177F 
; 0000 1780                                              wymieniono_szczotke_druciana = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wymieniono_szczotke_druciana,R30
	STS  _wymieniono_szczotke_druciana+1,R31
; 0000 1781                                              PORT_F.bits.b6 = 0;   //zgas lampke
	LDS  R30,_PORT_F
	ANDI R30,0xBF
	CALL SUBOPT_0xAF
; 0000 1782                                              PORTF = PORT_F.byte;
; 0000 1783                                              czas_pracy_szczotki_drucianej = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_szczotki_drucianej,R30
	STS  _czas_pracy_szczotki_drucianej+1,R30
; 0000 1784                                              czas_pracy_szczotki_drucianej_h = 0;
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h)
	CALL SUBOPT_0xEA
; 0000 1785                                              zaktualizuj_parametry_panelu();
	CALL _zaktualizuj_parametry_panelu
; 0000 1786                                              komunikat_na_panel("                                                ",80,0);
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL _komunikat_na_panel
; 0000 1787 
; 0000 1788                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	POP  R26
	AND  R30,R26
	BREQ _0x33C
; 0000 1789                                                 {
; 0000 178A                                                 cykl_wymiany = 4;
	CALL SUBOPT_0xE9
; 0000 178B                                                 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 178C                                                 }
; 0000 178D                                              //wymianymy
; 0000 178E                                         break;
_0x33C:
; 0000 178F                                         }
_0x333:
; 0000 1790                             }
; 0000 1791 
; 0000 1792 
; 0000 1793 
; 0000 1794 
; 0000 1795 
; 0000 1796 
; 0000 1797     break;
_0x330:
	RJMP _0x321
; 0000 1798 
; 0000 1799    case 4:
_0x32D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x321
; 0000 179A 
; 0000 179B                       //na sam dol zjezdzamy pionami
; 0000 179C                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x340
; 0000 179D                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xBF
; 0000 179E                 if(cykl_sterownik_4 < 5)
_0x340:
	CALL SUBOPT_0xC0
	SBIW R26,5
	BRGE _0x341
; 0000 179F                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 17A0 
; 0000 17A1                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x341:
	CALL SUBOPT_0xC2
	BREQ _0x342
; 0000 17A2                                         {
; 0000 17A3                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 17A4                                         cykl_sterownik_2 = 0;
; 0000 17A5                                         cykl_sterownik_3 = 0;
; 0000 17A6                                         cykl_sterownik_4 = 0;
; 0000 17A7                                         wartosc_parametru_panelu(0,48,32);
	CALL SUBOPT_0xE
	CALL SUBOPT_0x1E
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0xB
; 0000 17A8                                         PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 17A9                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 17AA                                         g = 0;
	__GETWRN 16,17,0
; 0000 17AB                                         }
; 0000 17AC 
; 0000 17AD    break;
_0x342:
; 0000 17AE 
; 0000 17AF 
; 0000 17B0     }//switch
_0x321:
; 0000 17B1 
; 0000 17B2    }//while
	RJMP _0x31C
_0x31E:
; 0000 17B3 
; 0000 17B4 
; 0000 17B5 while(f == 1)
_0x345:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ PC+3
	JMP _0x347
; 0000 17B6     {
; 0000 17B7     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 17B8     {
; 0000 17B9     case 0:
	SBIW R30,0
	BRNE _0x34B
; 0000 17BA 
; 0000 17BB                cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 17BC                cykl_sterownik_2 = 0;
; 0000 17BD                cykl_sterownik_3 = 0;
; 0000 17BE                cykl_sterownik_4 = 0;
; 0000 17BF                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 17C0                cykl_wymiany = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 17C1 
; 0000 17C2 
; 0000 17C3 
; 0000 17C4     break;
	RJMP _0x34A
; 0000 17C5 
; 0000 17C6     case 1:
_0x34B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x34E
; 0000 17C7 
; 0000 17C8             //na sam dol zjezdzamy pionami
; 0000 17C9                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x34F
; 0000 17CA                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xBF
; 0000 17CB                 if(cykl_sterownik_4 < 5)
_0x34F:
	CALL SUBOPT_0xC0
	SBIW R26,5
	BRGE _0x350
; 0000 17CC                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 17CD 
; 0000 17CE                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x350:
	CALL SUBOPT_0xC2
	BREQ _0x351
; 0000 17CF 
; 0000 17D0                             {
; 0000 17D1                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC3
; 0000 17D2                                         cykl_sterownik_4 = 0;
; 0000 17D3                                         cykl_wymiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 17D4                                         }
; 0000 17D5 
; 0000 17D6 
; 0000 17D7 
; 0000 17D8     break;
_0x351:
	RJMP _0x34A
; 0000 17D9 
; 0000 17DA 
; 0000 17DB 
; 0000 17DC     case 2:
_0x34E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x352
; 0000 17DD 
; 0000 17DE                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x353
; 0000 17DF                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0xE6
	CALL SUBOPT_0xC5
; 0000 17E0                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x353:
	CALL SUBOPT_0xC6
	SBIW R26,5
	BRGE _0x354
; 0000 17E1                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xE6
	CALL SUBOPT_0xC8
; 0000 17E2 
; 0000 17E3                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x354:
	CALL SUBOPT_0xC9
	BREQ _0x355
; 0000 17E4                                         {
; 0000 17E5                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 17E6                                         cykl_sterownik_2 = 0;
; 0000 17E7                                         cykl_sterownik_3 = 0;
; 0000 17E8                                         cykl_sterownik_4 = 0;
; 0000 17E9                                          cykl_wymiany = 3;
	CALL SUBOPT_0xE7
; 0000 17EA 
; 0000 17EB                                         }
; 0000 17EC 
; 0000 17ED     break;
_0x355:
	RJMP _0x34A
; 0000 17EE 
; 0000 17EF 
; 0000 17F0 
; 0000 17F1     case 3:
_0x352:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x356
; 0000 17F2 
; 0000 17F3             //na sam dol zjezdzamy pionami
; 0000 17F4                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x357
; 0000 17F5                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xCC
; 0000 17F6                 if(cykl_sterownik_4 < 5)
_0x357:
	CALL SUBOPT_0xC0
	SBIW R26,5
	BRGE _0x358
; 0000 17F7                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
	CALL SUBOPT_0xE8
	CALL SUBOPT_0xC1
; 0000 17F8 
; 0000 17F9                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x358:
	CALL SUBOPT_0xC2
	BRNE PC+3
	JMP _0x359
; 0000 17FA 
; 0000 17FB                             {
; 0000 17FC                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC3
; 0000 17FD                                         cykl_sterownik_4 = 0;
; 0000 17FE                                         e = odczytaj_parametr(48,48);
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 17FF 
; 0000 1800                                         switch (e)
	MOVW R30,R18
; 0000 1801                                         {
; 0000 1802                                         case 0:
	SBIW R30,0
	BRNE _0x35D
; 0000 1803 
; 0000 1804                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	POP  R26
	AND  R30,R26
	BREQ _0x35E
; 0000 1805                                              {
; 0000 1806                                              cykl_wymiany = 4;
	CALL SUBOPT_0xE9
; 0000 1807                                              PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1808                                              }
; 0000 1809                                              //jednak nie wymianiamy
; 0000 180A 
; 0000 180B                                         break;
_0x35E:
	RJMP _0x35C
; 0000 180C 
; 0000 180D                                         case 1:
_0x35D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x361
; 0000 180E                                              PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 180F                                              cykl_wymiany = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x51A
; 0000 1810                                              //czekam z decyzja - w trakcie wymiany
; 0000 1811                                         break;
; 0000 1812 
; 0000 1813                                         case 2:
_0x361:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x35C
; 0000 1814 
; 0000 1815                                              wymieniono_krazek_scierny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wymieniono_krazek_scierny,R30
	STS  _wymieniono_krazek_scierny+1,R31
; 0000 1816 
; 0000 1817                                              PORT_F.bits.b6 = 0;   //zgas lampke
	LDS  R30,_PORT_F
	ANDI R30,0xBF
	CALL SUBOPT_0xAF
; 0000 1818                                              PORTF = PORT_F.byte;
; 0000 1819                                              czas_pracy_krazka_sciernego = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego,R30
	STS  _czas_pracy_krazka_sciernego+1,R30
; 0000 181A                                              if(srednica_wew_korpusu == 34)
	CALL SUBOPT_0xEB
	SBIW R26,34
	BRNE _0x365
; 0000 181B                                                 czas_pracy_krazka_sciernego_h_34 = 0;
	CALL SUBOPT_0xEC
; 0000 181C                                              if(srednica_wew_korpusu == 36)
_0x365:
	CALL SUBOPT_0xEB
	SBIW R26,36
	BRNE _0x366
; 0000 181D                                                 czas_pracy_krazka_sciernego_h_36 = 0;
	CALL SUBOPT_0xED
; 0000 181E                                              if(srednica_wew_korpusu == 38)
_0x366:
	CALL SUBOPT_0xEB
	SBIW R26,38
	BRNE _0x367
; 0000 181F                                                 czas_pracy_krazka_sciernego_h_38 = 0;
	CALL SUBOPT_0xEE
; 0000 1820                                              if(srednica_wew_korpusu == 41)
_0x367:
	CALL SUBOPT_0xEB
	SBIW R26,41
	BRNE _0x368
; 0000 1821                                                 czas_pracy_krazka_sciernego_h_41 = 0;
	CALL SUBOPT_0xEF
; 0000 1822                                              if(srednica_wew_korpusu == 43)
_0x368:
	CALL SUBOPT_0xEB
	SBIW R26,43
	BRNE _0x369
; 0000 1823                                                 czas_pracy_krazka_sciernego_h_43 = 0;
	CALL SUBOPT_0xF0
; 0000 1824 
; 0000 1825                                              zaktualizuj_parametry_panelu();
_0x369:
	CALL _zaktualizuj_parametry_panelu
; 0000 1826                                              komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE4
	CALL _komunikat_na_panel
; 0000 1827                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	PUSH R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	POP  R26
	AND  R30,R26
	BREQ _0x36A
; 0000 1828                                                      {
; 0000 1829                                                      PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 182A                                                      cykl_wymiany = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
_0x51A:
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 182B                                                      }
; 0000 182C                                              //wymianymy
; 0000 182D                                         break;
_0x36A:
; 0000 182E                                         }
_0x35C:
; 0000 182F                             }
; 0000 1830 
; 0000 1831 
; 0000 1832 
; 0000 1833 
; 0000 1834 
; 0000 1835 
; 0000 1836     break;
_0x359:
	RJMP _0x34A
; 0000 1837 
; 0000 1838    case 4:
_0x356:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x34A
; 0000 1839 
; 0000 183A                       //na sam dol zjezdzamy pionami
; 0000 183B                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x36E
; 0000 183C                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xBF
; 0000 183D                 if(cykl_sterownik_4 < 5)
_0x36E:
	CALL SUBOPT_0xC0
	SBIW R26,5
	BRGE _0x36F
; 0000 183E                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 183F 
; 0000 1840                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x36F:
	CALL SUBOPT_0xC2
	BREQ _0x370
; 0000 1841 
; 0000 1842                             {
; 0000 1843                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1844                                         cykl_sterownik_2 = 0;
; 0000 1845                                         cykl_sterownik_3 = 0;
; 0000 1846                                         cykl_sterownik_4 = 0;
; 0000 1847                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1848                                         wartosc_parametru_panelu(0,48,48);
	CALL SUBOPT_0xE
	CALL SUBOPT_0x1E
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0xB
; 0000 1849                                         PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 184A                                         f = 0;
	__GETWRN 20,21,0
; 0000 184B                                         }
; 0000 184C 
; 0000 184D    break;
_0x370:
; 0000 184E 
; 0000 184F 
; 0000 1850     }//switch
_0x34A:
; 0000 1851 
; 0000 1852    }//while
	RJMP _0x345
_0x347:
; 0000 1853 
; 0000 1854 
; 0000 1855 
; 0000 1856 
; 0000 1857 
; 0000 1858 
; 0000 1859 
; 0000 185A 
; 0000 185B }
	CALL __LOADLOCR6
	ADIW R28,10
	RET
;
;
;void przypadek887()
; 0000 185F {
_przypadek887:
; 0000 1860 if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF1
	BRGE _0x373
; 0000 1861                         {
; 0000 1862                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xF2
; 0000 1863                         PORTF = PORT_F.byte;
; 0000 1864                         }
; 0000 1865 
; 0000 1866 
; 0000 1867                      if(rzad_obrabiany == 2)
_0x373:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x374
; 0000 1868                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1869 
; 0000 186A                     if(koniec_rzedu_10 == 1)
_0x374:
	CALL SUBOPT_0xF3
	BRNE _0x375
; 0000 186B                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xF4
; 0000 186C 
; 0000 186D 
; 0000 186E                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x375:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF6
	MOVW R26,R30
	CALL SUBOPT_0xD8
	CALL SUBOPT_0xF7
	BREQ _0x376
; 0000 186F                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x6C
	CALL SUBOPT_0xF8
; 0000 1870 
; 0000 1871                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x376:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF9
	BREQ _0x377
; 0000 1872                         {
; 0000 1873                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1874                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0xFB
; 0000 1875                         }
; 0000 1876 
; 0000 1877 
; 0000 1878                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x377:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF6
	CALL SUBOPT_0xFC
	AND  R30,R0
	BREQ _0x378
; 0000 1879                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0xFD
; 0000 187A 
; 0000 187B                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x378:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xFE
	CALL SUBOPT_0xFC
	AND  R30,R0
	BREQ _0x379
; 0000 187C                         {
; 0000 187D                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 187E                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0xFF
; 0000 187F                         }
; 0000 1880 
; 0000 1881                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x379:
	CALL SUBOPT_0x73
	CALL SUBOPT_0x100
	AND  R30,R0
	BREQ _0x37A
; 0000 1882                         {
; 0000 1883                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1884                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x101
; 0000 1885                         }
; 0000 1886 
; 0000 1887                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1888                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x37A:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x102
	AND  R30,R0
	BREQ _0x37B
; 0000 1889                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x103
; 0000 188A 
; 0000 188B 
; 0000 188C                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x37B:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x37C
; 0000 188D                         {
; 0000 188E                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 188F                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x105
; 0000 1890                         }
; 0000 1891 
; 0000 1892 
; 0000 1893 
; 0000 1894 
; 0000 1895 
; 0000 1896 
; 0000 1897 
; 0000 1898                                                               //to nowy war, ostatni dzien w borg
; 0000 1899                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x37C:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x108
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x109
	BREQ _0x37D
; 0000 189A                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xC1
; 0000 189B 
; 0000 189C                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x37D:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x10B
	CALL SUBOPT_0x10C
	CALL SUBOPT_0x10D
	CALL SUBOPT_0xA0
	BREQ _0x37E
; 0000 189D                         {
; 0000 189E                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x10E
	BRNE _0x37F
; 0000 189F                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 18A0                         if(abs_ster4 == 0)
_0x37F:
	CALL SUBOPT_0x110
	BRNE _0x380
; 0000 18A1                             {
; 0000 18A2                             szczotka_druc_cykl++;
	CALL SUBOPT_0x111
; 0000 18A3                             abs_ster4 = 1;
; 0000 18A4                             }
; 0000 18A5                         else
	RJMP _0x381
_0x380:
; 0000 18A6                             {
; 0000 18A7                             abs_ster4 = 0;
	CALL SUBOPT_0x112
; 0000 18A8                             sek13 = 0;
; 0000 18A9                             }
_0x381:
; 0000 18AA                         }
; 0000 18AB 
; 0000 18AC                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x37E:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x114
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x115
	BREQ _0x382
; 0000 18AD                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x76
	CALL SUBOPT_0xCC
; 0000 18AE 
; 0000 18AF 
; 0000 18B0                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x382:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x116
	CALL SUBOPT_0x117
	CALL SUBOPT_0x118
	BREQ _0x383
; 0000 18B1                         {
; 0000 18B2                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 18B3                         if(abs_ster3 == 0)
	CALL SUBOPT_0x11A
	BRNE _0x384
; 0000 18B4                             {
; 0000 18B5                             krazek_scierny_cykl++;
	CALL SUBOPT_0x11B
; 0000 18B6                             abs_ster3 = 1;
; 0000 18B7                             }
; 0000 18B8                         else
	RJMP _0x385
_0x384:
; 0000 18B9                             abs_ster3 = 0;
	CALL SUBOPT_0x11C
; 0000 18BA                         }
_0x385:
; 0000 18BB 
; 0000 18BC                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x383:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x114
	CALL SUBOPT_0x75
	AND  R30,R0
	BREQ _0x386
; 0000 18BD                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x6B
	CALL SUBOPT_0xCC
; 0000 18BE 
; 0000 18BF                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x386:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0x75
	CALL SUBOPT_0x108
	CALL SUBOPT_0xA0
	BREQ _0x387
; 0000 18C0                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory
	CALL SUBOPT_0x11D
	CALL SUBOPT_0xC1
; 0000 18C1 
; 0000 18C2 
; 0000 18C3 
; 0000 18C4                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 18C5 
; 0000 18C6                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonalem_komplet_okregow == 3)
_0x387:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x116
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x90
	CALL SUBOPT_0x11F
	BREQ _0x388
; 0000 18C7                        {
; 0000 18C8                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 18C9                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x120
; 0000 18CA                        }
; 0000 18CB                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x388:
	CALL SUBOPT_0x121
	MOV  R0,R30
	CALL SUBOPT_0x113
	CALL __LTW12
	AND  R30,R0
	BREQ _0x389
; 0000 18CC                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x122
; 0000 18CD 
; 0000 18CE                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x389:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x123
	AND  R30,R0
	BREQ _0x38A
; 0000 18CF                        {
; 0000 18D0                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x124
; 0000 18D1                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 18D2                        }
; 0000 18D3                    //////////////////////////////////////////////
; 0000 18D4 
; 0000 18D5 
; 0000 18D6 
; 0000 18D7                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 18D8 
; 0000 18D9                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x38A:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x10B
	CALL SUBOPT_0x125
	CALL SUBOPT_0x126
	BREQ _0x38D
; 0000 18DA                        {
; 0000 18DB                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 18DC                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 18DD                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x127
; 0000 18DE                        }
; 0000 18DF                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x38D:
	CALL SUBOPT_0x128
	MOV  R0,R30
	CALL SUBOPT_0x106
	CALL __LTW12
	AND  R30,R0
	BREQ _0x390
; 0000 18E0                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 18E1 
; 0000 18E2                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x390:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x129
	AND  R30,R0
	BREQ _0x391
; 0000 18E3                        {
; 0000 18E4                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x12A
; 0000 18E5                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 18E6                        }
; 0000 18E7                    //////////////////////////////////////////////
; 0000 18E8 
; 0000 18E9                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x391:
; 0000 18EA                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 18EB                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 18EC                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0 &  wykonalem_komplet_okregow == 3)
	CALL SUBOPT_0x90
	CALL SUBOPT_0x12B
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x113
	CALL SUBOPT_0x12C
	CALL SUBOPT_0x12D
	CALL SUBOPT_0x108
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x12E
	BREQ _0x394
; 0000 18ED                         {
; 0000 18EE                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x124
; 0000 18EF                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x12A
; 0000 18F0                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 18F1                         cykl_sterownik_2 = 0;
; 0000 18F2                         cykl_sterownik_3 = 0;
; 0000 18F3                         cykl_sterownik_4 = 0;
; 0000 18F4                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x12F
; 0000 18F5                         krazek_scierny_cykl = 0;
; 0000 18F6                         krazek_scierny_cykl_po_okregu = 0;
; 0000 18F7                         wykonalem_komplet_okregow = 0;
; 0000 18F8                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 18F9                         //PORTF = PORT_F.byte;
; 0000 18FA                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 18FB                         cykl_glowny = 9;
; 0000 18FC                         }
; 0000 18FD }
_0x394:
	RET
;
;
;
;void przypadek888()
; 0000 1902 {
_przypadek888:
; 0000 1903 
; 0000 1904                  if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF1
	BRGE _0x397
; 0000 1905                         {
; 0000 1906                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xF2
; 0000 1907                         PORTF = PORT_F.byte;
; 0000 1908                         }
; 0000 1909 
; 0000 190A 
; 0000 190B                      if(rzad_obrabiany == 2)
_0x397:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x398
; 0000 190C                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 190D 
; 0000 190E                     if(koniec_rzedu_10 == 1)
_0x398:
	CALL SUBOPT_0xF3
	BRNE _0x399
; 0000 190F                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xF4
; 0000 1910 
; 0000 1911 
; 0000 1912                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x399:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF6
	MOVW R26,R30
	CALL SUBOPT_0xD8
	CALL SUBOPT_0xF7
	BREQ _0x39A
; 0000 1913                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x6C
	CALL SUBOPT_0xF8
; 0000 1914 
; 0000 1915                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x39A:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF9
	BREQ _0x39B
; 0000 1916                         {
; 0000 1917                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1918                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0xFB
; 0000 1919                         }
; 0000 191A 
; 0000 191B 
; 0000 191C                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x39B:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF6
	CALL SUBOPT_0xFC
	AND  R30,R0
	BREQ _0x39C
; 0000 191D                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0xFD
; 0000 191E 
; 0000 191F                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x39C:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xFE
	CALL SUBOPT_0xFC
	AND  R30,R0
	BREQ _0x39D
; 0000 1920                         {
; 0000 1921                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1922                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0xFF
; 0000 1923                         }
; 0000 1924 
; 0000 1925                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x39D:
	CALL SUBOPT_0x73
	CALL SUBOPT_0x100
	AND  R30,R0
	BREQ _0x39E
; 0000 1926                         {
; 0000 1927                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1928                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x101
; 0000 1929                         }
; 0000 192A 
; 0000 192B                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 192C                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x39E:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x102
	AND  R30,R0
	BREQ _0x39F
; 0000 192D                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x103
; 0000 192E 
; 0000 192F 
; 0000 1930                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x39F:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x3A0
; 0000 1931                         {
; 0000 1932                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1933                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x105
; 0000 1934                         }
; 0000 1935 
; 0000 1936 
; 0000 1937 
; 0000 1938 
; 0000 1939 
; 0000 193A 
; 0000 193B 
; 0000 193C                                                               //to nowy war, ostatni dzien w borg
; 0000 193D                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3A0:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x108
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x109
	BREQ _0x3A1
; 0000 193E                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xC1
; 0000 193F 
; 0000 1940                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3A1:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x10B
	CALL SUBOPT_0x130
	CALL SUBOPT_0xA0
	BREQ _0x3A2
; 0000 1941                         {
; 0000 1942                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x10E
	BRNE _0x3A3
; 0000 1943                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 1944                         if(abs_ster4 == 0)
_0x3A3:
	CALL SUBOPT_0x110
	BRNE _0x3A4
; 0000 1945                             {
; 0000 1946                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x6E
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3A5
; 0000 1947                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1948                             szczotka_druc_cykl++;
_0x3A5:
	CALL SUBOPT_0x111
; 0000 1949                             abs_ster4 = 1;
; 0000 194A                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x90
	CALL SUBOPT_0x131
	BRNE _0x3A8
; 0000 194B                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0xF4
; 0000 194C                             }
_0x3A8:
; 0000 194D                         else
	RJMP _0x3A9
_0x3A4:
; 0000 194E                             {
; 0000 194F                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1950                             abs_ster4 = 0;
	CALL SUBOPT_0x112
; 0000 1951                             sek13 = 0;
; 0000 1952                             }
_0x3A9:
; 0000 1953                         }
; 0000 1954 
; 0000 1955                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3A2:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x114
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x115
	BREQ _0x3AC
; 0000 1956                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x76
	CALL SUBOPT_0xCC
; 0000 1957 
; 0000 1958 
; 0000 1959                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3AC:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x116
	CALL SUBOPT_0x132
	BREQ _0x3AD
; 0000 195A                         {
; 0000 195B                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 195C                         if(abs_ster3 == 0)
	CALL SUBOPT_0x11A
	BRNE _0x3AE
; 0000 195D                             {
; 0000 195E                             krazek_scierny_cykl++;
	CALL SUBOPT_0x11B
; 0000 195F                             abs_ster3 = 1;
; 0000 1960                             }
; 0000 1961                         else
	RJMP _0x3AF
_0x3AE:
; 0000 1962                             abs_ster3 = 0;
	CALL SUBOPT_0x11C
; 0000 1963                         }
_0x3AF:
; 0000 1964 
; 0000 1965                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3AD:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x114
	CALL SUBOPT_0x75
	AND  R30,R0
	BREQ _0x3B0
; 0000 1966                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x6B
	CALL SUBOPT_0xCC
; 0000 1967 
; 0000 1968                        if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x3B0:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0x75
	CALL SUBOPT_0x108
	CALL SUBOPT_0xA0
	BREQ _0x3B1
; 0000 1969                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x72
	CALL SUBOPT_0x133
	CALL SUBOPT_0xC1
; 0000 196A 
; 0000 196B                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 196C 
; 0000 196D                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonalem_komplet_okregow == 3)
_0x3B1:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x116
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x90
	CALL SUBOPT_0x11F
	BREQ _0x3B2
; 0000 196E                        {
; 0000 196F                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 1970                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x120
; 0000 1971                        }
; 0000 1972                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x3B2:
	CALL SUBOPT_0x121
	MOV  R0,R30
	CALL SUBOPT_0x113
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3B3
; 0000 1973                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x122
; 0000 1974 
; 0000 1975                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x3B3:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x123
	AND  R30,R0
	BREQ _0x3B4
; 0000 1976                        {
; 0000 1977                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x124
; 0000 1978                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1979                        }
; 0000 197A                    //////////////////////////////////////////////
; 0000 197B 
; 0000 197C 
; 0000 197D 
; 0000 197E                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 197F 
; 0000 1980                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x3B4:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x10B
	CALL SUBOPT_0x125
	CALL SUBOPT_0x126
	BREQ _0x3B7
; 0000 1981                        {
; 0000 1982                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1983                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 1984                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x127
; 0000 1985                        }
; 0000 1986                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3B7:
	CALL SUBOPT_0x128
	MOV  R0,R30
	CALL SUBOPT_0x106
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3BA
; 0000 1987                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 1988 
; 0000 1989                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3BA:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x129
	AND  R30,R0
	BREQ _0x3BB
; 0000 198A                        {
; 0000 198B                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x12A
; 0000 198C                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 198D                        }
; 0000 198E                    //////////////////////////////////////////////
; 0000 198F 
; 0000 1990                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3BB:
; 0000 1991                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1992                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1993                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0 &  wykonalem_komplet_okregow == 3)
	CALL SUBOPT_0x90
	CALL SUBOPT_0x12B
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x113
	CALL SUBOPT_0x12C
	CALL SUBOPT_0x12D
	CALL SUBOPT_0x108
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x12E
	BREQ _0x3BE
; 0000 1994                         {
; 0000 1995                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x124
; 0000 1996                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x12A
; 0000 1997                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1998                         cykl_sterownik_2 = 0;
; 0000 1999                         cykl_sterownik_3 = 0;
; 0000 199A                         cykl_sterownik_4 = 0;
; 0000 199B                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x12F
; 0000 199C                         krazek_scierny_cykl = 0;
; 0000 199D                         krazek_scierny_cykl_po_okregu = 0;
; 0000 199E                         wykonalem_komplet_okregow = 0;
; 0000 199F                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 19A0                         //PORTF = PORT_F.byte;
; 0000 19A1                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 19A2                         cykl_glowny = 9;
; 0000 19A3                         }
; 0000 19A4 
; 0000 19A5  }
_0x3BE:
	RET
;
;
;
;void przypadek997()
; 0000 19AA 
; 0000 19AB {
_przypadek997:
; 0000 19AC 
; 0000 19AD            if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF1
	BRGE _0x3C1
; 0000 19AE                         {
; 0000 19AF                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xF2
; 0000 19B0                         PORTF = PORT_F.byte;
; 0000 19B1                         }
; 0000 19B2 
; 0000 19B3 
; 0000 19B4                      if(rzad_obrabiany == 2)
_0x3C1:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x3C2
; 0000 19B5                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 19B6 
; 0000 19B7                     if(koniec_rzedu_10 == 1)
_0x3C2:
	CALL SUBOPT_0xF3
	BRNE _0x3C3
; 0000 19B8                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xF4
; 0000 19B9                                                               //to nowy war, ostatni dzien w borg
; 0000 19BA                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3C3:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x108
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x109
	BREQ _0x3C4
; 0000 19BB                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xC1
; 0000 19BC 
; 0000 19BD                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3C4:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x10B
	CALL SUBOPT_0x130
	CALL SUBOPT_0xA0
	BREQ _0x3C5
; 0000 19BE                         {
; 0000 19BF                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x10E
	BRNE _0x3C6
; 0000 19C0                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 19C1                         if(abs_ster4 == 0)
_0x3C6:
	CALL SUBOPT_0x110
	BRNE _0x3C7
; 0000 19C2                             {
; 0000 19C3                             szczotka_druc_cykl++;
	CALL SUBOPT_0x111
; 0000 19C4                             abs_ster4 = 1;
; 0000 19C5                             }
; 0000 19C6                        else
	RJMP _0x3C8
_0x3C7:
; 0000 19C7                             {
; 0000 19C8                             abs_ster4 = 0;
	CALL SUBOPT_0x112
; 0000 19C9                             sek13 = 0;
; 0000 19CA                             }
_0x3C8:
; 0000 19CB                         }
; 0000 19CC 
; 0000 19CD                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3C5:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x114
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x115
	BREQ _0x3C9
; 0000 19CE                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x76
	CALL SUBOPT_0xCC
; 0000 19CF 
; 0000 19D0 
; 0000 19D1                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3C9:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x116
	CALL SUBOPT_0x132
	BREQ _0x3CA
; 0000 19D2                         {
; 0000 19D3                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 19D4                         if(abs_ster3 == 0)
	CALL SUBOPT_0x11A
	BRNE _0x3CB
; 0000 19D5                             {
; 0000 19D6                             krazek_scierny_cykl++;
	CALL SUBOPT_0x11B
; 0000 19D7                             abs_ster3 = 1;
; 0000 19D8                             }
; 0000 19D9                         else
	RJMP _0x3CC
_0x3CB:
; 0000 19DA                             abs_ster3 = 0;
	CALL SUBOPT_0x11C
; 0000 19DB                         }
_0x3CC:
; 0000 19DC 
; 0000 19DD                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3CA:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x114
	CALL SUBOPT_0x75
	AND  R30,R0
	BREQ _0x3CD
; 0000 19DE                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x6B
	CALL SUBOPT_0xCC
; 0000 19DF 
; 0000 19E0 
; 0000 19E1                      if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x3CD:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0x75
	CALL SUBOPT_0x108
	CALL SUBOPT_0xA0
	BREQ _0x3CE
; 0000 19E2                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory kawaleczek
	CALL SUBOPT_0x11D
	CALL SUBOPT_0xC1
; 0000 19E3 
; 0000 19E4                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 19E5 
; 0000 19E6                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x3CE:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x116
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x90
	CALL SUBOPT_0x134
	BREQ _0x3CF
; 0000 19E7                        {
; 0000 19E8                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 19E9                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x120
; 0000 19EA                        }
; 0000 19EB                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x3CF:
	CALL SUBOPT_0x121
	MOV  R0,R30
	CALL SUBOPT_0x113
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3D0
; 0000 19EC                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x122
; 0000 19ED 
; 0000 19EE                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x3D0:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x123
	AND  R30,R0
	BREQ _0x3D1
; 0000 19EF                        {
; 0000 19F0                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x124
; 0000 19F1                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 19F2                        }
; 0000 19F3                    //////////////////////////////////////////////
; 0000 19F4 
; 0000 19F5 
; 0000 19F6 
; 0000 19F7                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 19F8 
; 0000 19F9                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x3D1:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x10B
	CALL SUBOPT_0x125
	CALL SUBOPT_0x126
	BREQ _0x3D4
; 0000 19FA                        {
; 0000 19FB                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 19FC                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 19FD                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x127
; 0000 19FE                        }
; 0000 19FF                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3D4:
	CALL SUBOPT_0x128
	MOV  R0,R30
	CALL SUBOPT_0x106
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3D7
; 0000 1A00                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 1A01 
; 0000 1A02                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3D7:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x129
	AND  R30,R0
	BREQ _0x3D8
; 0000 1A03                        {
; 0000 1A04                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x12A
; 0000 1A05                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1A06                        }
; 0000 1A07                    //////////////////////////////////////////////
; 0000 1A08 
; 0000 1A09                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3D8:
; 0000 1A0A                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1A0B                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1A0C                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0)
	CALL SUBOPT_0x90
	CALL SUBOPT_0x12B
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x113
	CALL SUBOPT_0x12C
	CALL SUBOPT_0x12D
	CALL SUBOPT_0x108
	CALL SUBOPT_0xA0
	BREQ _0x3DB
; 0000 1A0D                         {
; 0000 1A0E                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x124
; 0000 1A0F                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x12A
; 0000 1A10                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1A11                         cykl_sterownik_2 = 0;
; 0000 1A12                         cykl_sterownik_3 = 0;
; 0000 1A13                         cykl_sterownik_4 = 0;
; 0000 1A14                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x135
; 0000 1A15                         krazek_scierny_cykl = 0;
; 0000 1A16                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1A17                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1A18                         //PORTF = PORT_F.byte;
; 0000 1A19                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1A1A                         cykl_glowny = 9;
; 0000 1A1B                         }
; 0000 1A1C 
; 0000 1A1D }
_0x3DB:
	RET
;
;void przypadek998()
; 0000 1A20 {
_przypadek998:
; 0000 1A21 
; 0000 1A22            if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF1
	BRGE _0x3DE
; 0000 1A23                         {
; 0000 1A24                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xF2
; 0000 1A25                         PORTF = PORT_F.byte;
; 0000 1A26                         }
; 0000 1A27 
; 0000 1A28 
; 0000 1A29                      if(rzad_obrabiany == 2)
_0x3DE:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x3DF
; 0000 1A2A                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1A2B 
; 0000 1A2C                     if(koniec_rzedu_10 == 1)
_0x3DF:
	CALL SUBOPT_0xF3
	BRNE _0x3E0
; 0000 1A2D                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xF4
; 0000 1A2E 
; 0000 1A2F                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3E0:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x108
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x109
	BREQ _0x3E1
; 0000 1A30                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xC1
; 0000 1A31 
; 0000 1A32                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3E1:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x10B
	CALL SUBOPT_0x130
	CALL SUBOPT_0xA0
	BREQ _0x3E2
; 0000 1A33                         {
; 0000 1A34                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x10E
	BRNE _0x3E3
; 0000 1A35                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 1A36                         if(abs_ster4 == 0)
_0x3E3:
	CALL SUBOPT_0x110
	BRNE _0x3E4
; 0000 1A37                             {
; 0000 1A38                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x6E
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3E5
; 0000 1A39                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1A3A                             szczotka_druc_cykl++;
_0x3E5:
	CALL SUBOPT_0x111
; 0000 1A3B                             abs_ster4 = 1;
; 0000 1A3C                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x90
	CALL SUBOPT_0x131
	BRNE _0x3E8
; 0000 1A3D                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0xF4
; 0000 1A3E                             }
_0x3E8:
; 0000 1A3F                         else
	RJMP _0x3E9
_0x3E4:
; 0000 1A40                             {
; 0000 1A41                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1A42                             abs_ster4 = 0;
	CALL SUBOPT_0x112
; 0000 1A43                             sek13 = 0;
; 0000 1A44                             }
_0x3E9:
; 0000 1A45                         }
; 0000 1A46 
; 0000 1A47                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3E2:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x114
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x115
	BREQ _0x3EC
; 0000 1A48                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x76
	CALL SUBOPT_0xCC
; 0000 1A49 
; 0000 1A4A 
; 0000 1A4B                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3EC:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x116
	CALL SUBOPT_0x132
	BREQ _0x3ED
; 0000 1A4C                         {
; 0000 1A4D                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 1A4E                         if(abs_ster3 == 0)
	CALL SUBOPT_0x11A
	BRNE _0x3EE
; 0000 1A4F                             {
; 0000 1A50                             krazek_scierny_cykl++;
	CALL SUBOPT_0x11B
; 0000 1A51 
; 0000 1A52                             abs_ster3 = 1;
; 0000 1A53                             }
; 0000 1A54                         else
	RJMP _0x3EF
_0x3EE:
; 0000 1A55                             abs_ster3 = 0;
	CALL SUBOPT_0x11C
; 0000 1A56                         }
_0x3EF:
; 0000 1A57 
; 0000 1A58                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3ED:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x114
	CALL SUBOPT_0x75
	AND  R30,R0
	BREQ _0x3F0
; 0000 1A59                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x6B
	CALL SUBOPT_0xCC
; 0000 1A5A 
; 0000 1A5B                        if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x3F0:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0x75
	CALL SUBOPT_0x108
	CALL SUBOPT_0xA0
	BREQ _0x3F1
; 0000 1A5C                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x72
	CALL SUBOPT_0x133
	CALL SUBOPT_0xC1
; 0000 1A5D 
; 0000 1A5E 
; 0000 1A5F 
; 0000 1A60                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1A61 
; 0000 1A62                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x3F1:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x116
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x90
	CALL SUBOPT_0x134
	BREQ _0x3F2
; 0000 1A63                        {
; 0000 1A64                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 1A65                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x120
; 0000 1A66                        }
; 0000 1A67                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x3F2:
	CALL SUBOPT_0x121
	MOV  R0,R30
	CALL SUBOPT_0x113
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3F3
; 0000 1A68                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x122
; 0000 1A69 
; 0000 1A6A                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x3F3:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x123
	AND  R30,R0
	BREQ _0x3F4
; 0000 1A6B                        {
; 0000 1A6C                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x124
; 0000 1A6D                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1A6E                        }
; 0000 1A6F                    //////////////////////////////////////////////
; 0000 1A70 
; 0000 1A71 
; 0000 1A72 
; 0000 1A73                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1A74 
; 0000 1A75                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x3F4:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x10B
	CALL SUBOPT_0x125
	CALL SUBOPT_0x126
	BREQ _0x3F7
; 0000 1A76                        {
; 0000 1A77                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1A78                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 1A79                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x127
; 0000 1A7A                        }
; 0000 1A7B                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3F7:
	CALL SUBOPT_0x128
	MOV  R0,R30
	CALL SUBOPT_0x106
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3FA
; 0000 1A7C                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 1A7D 
; 0000 1A7E                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3FA:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x129
	AND  R30,R0
	BREQ _0x3FB
; 0000 1A7F                        {
; 0000 1A80                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x12A
; 0000 1A81                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1A82                        }
; 0000 1A83                    //////////////////////////////////////////////
; 0000 1A84 
; 0000 1A85                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3FB:
; 0000 1A86                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1A87                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1A88                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0)
	CALL SUBOPT_0x90
	CALL SUBOPT_0x12B
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x113
	CALL SUBOPT_0x12C
	CALL SUBOPT_0x12D
	CALL SUBOPT_0x108
	CALL SUBOPT_0xA0
	BREQ _0x3FE
; 0000 1A89                         {
; 0000 1A8A                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x124
; 0000 1A8B                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x12A
; 0000 1A8C                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1A8D                         cykl_sterownik_2 = 0;
; 0000 1A8E                         cykl_sterownik_3 = 0;
; 0000 1A8F                         cykl_sterownik_4 = 0;
; 0000 1A90                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x135
; 0000 1A91                         krazek_scierny_cykl = 0;
; 0000 1A92                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1A93                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1A94                         //PORTF = PORT_F.byte;
; 0000 1A95                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1A96                         cykl_glowny = 9;
; 0000 1A97                         }
; 0000 1A98 }
_0x3FE:
	RET
;
;
;void przypadek8()
; 0000 1A9C 
; 0000 1A9D {
_przypadek8:
; 0000 1A9E 
; 0000 1A9F                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF1
	BRGE _0x401
; 0000 1AA0                         {
; 0000 1AA1                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xF2
; 0000 1AA2                         PORTF = PORT_F.byte;
; 0000 1AA3                         }
; 0000 1AA4 
; 0000 1AA5 
; 0000 1AA6                      if(rzad_obrabiany == 2)
_0x401:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x402
; 0000 1AA7                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1AA8 
; 0000 1AA9 
; 0000 1AAA 
; 0000 1AAB                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x402:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF6
	MOVW R26,R30
	CALL SUBOPT_0xD8
	CALL SUBOPT_0xF7
	BREQ _0x403
; 0000 1AAC                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x6C
	CALL SUBOPT_0xF8
; 0000 1AAD                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x403:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF9
	BREQ _0x404
; 0000 1AAE                         {
; 0000 1AAF                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1AB0                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0xFB
; 0000 1AB1                         }
; 0000 1AB2 
; 0000 1AB3 
; 0000 1AB4                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x404:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF6
	CALL SUBOPT_0xFC
	AND  R30,R0
	BREQ _0x405
; 0000 1AB5                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0xFD
; 0000 1AB6 
; 0000 1AB7                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x405:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xFE
	CALL SUBOPT_0xFC
	AND  R30,R0
	BREQ _0x406
; 0000 1AB8                         {
; 0000 1AB9                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1ABA                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0xFF
; 0000 1ABB                         }
; 0000 1ABC 
; 0000 1ABD                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x406:
	CALL SUBOPT_0x73
	CALL SUBOPT_0x100
	AND  R30,R0
	BREQ _0x407
; 0000 1ABE                         {
; 0000 1ABF                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1AC0                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x101
; 0000 1AC1                         }
; 0000 1AC2 
; 0000 1AC3                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1AC4                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x407:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x102
	AND  R30,R0
	BREQ _0x408
; 0000 1AC5                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x103
; 0000 1AC6 
; 0000 1AC7 
; 0000 1AC8                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x408:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x409
; 0000 1AC9                         {
; 0000 1ACA                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1ACB                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x105
; 0000 1ACC                         }
; 0000 1ACD 
; 0000 1ACE                     if(cykl_sterownik_3 < 5 & wykonalem_komplet_okregow == 3)
_0x409:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x136
	BREQ _0x40A
; 0000 1ACF                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV         //tu zmienienie INV, ¿eby szed³ w dol
	CALL SUBOPT_0x76
	CALL SUBOPT_0xCC
; 0000 1AD0 
; 0000 1AD1                      if(cykl_sterownik_3 == 5 & wykonalem_komplet_okregow == 3)
_0x40A:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x137
	BREQ _0x40B
; 0000 1AD2                         {
; 0000 1AD3                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x138
; 0000 1AD4                         krazek_scierny_cykl++;
; 0000 1AD5 
; 0000 1AD6                         if(krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x117
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x40C
; 0000 1AD7                             {
; 0000 1AD8                             wykonalem_komplet_okregow = 4;
	CALL SUBOPT_0x139
; 0000 1AD9                             }
; 0000 1ADA                         else
	RJMP _0x40D
_0x40C:
; 0000 1ADB                             wykonalem_komplet_okregow = 0;
	CALL SUBOPT_0x13A
; 0000 1ADC 
; 0000 1ADD                         cykl_sterownik_1 = 0;
_0x40D:
	CALL SUBOPT_0xFA
; 0000 1ADE                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 1ADF                         }
; 0000 1AE0 
; 0000 1AE1 
; 0000 1AE2 
; 0000 1AE3 
; 0000 1AE4 
; 0000 1AE5                     if(koniec_rzedu_10 == 1)
_0x40B:
	CALL SUBOPT_0xF3
	BRNE _0x40E
; 0000 1AE6                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xF4
; 0000 1AE7                                                               //to nowy war, ostatni dzien w borg
; 0000 1AE8                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze & koniec_rzedu_10 == 0)
_0x40E:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x108
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x13B
	BREQ _0x40F
; 0000 1AE9                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xC1
; 0000 1AEA 
; 0000 1AEB                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x40F:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x10B
	CALL SUBOPT_0x130
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x13C
	BREQ _0x410
; 0000 1AEC                         {
; 0000 1AED                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x10E
	BRNE _0x411
; 0000 1AEE                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 1AEF                         if(abs_ster4 == 0)
_0x411:
	CALL SUBOPT_0x110
	BRNE _0x412
; 0000 1AF0                             {
; 0000 1AF1                             szczotka_druc_cykl++;
	CALL SUBOPT_0x111
; 0000 1AF2                             abs_ster4 = 1;
; 0000 1AF3                             }
; 0000 1AF4                         else
	RJMP _0x413
_0x412:
; 0000 1AF5                             {
; 0000 1AF6                             abs_ster4 = 0;
	CALL SUBOPT_0x112
; 0000 1AF7                             sek13 = 0;
; 0000 1AF8                             }
_0x413:
; 0000 1AF9                         }
; 0000 1AFA 
; 0000 1AFB 
; 0000 1AFC                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x410:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0x75
	CALL SUBOPT_0x108
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x13C
	BREQ _0x414
; 0000 1AFD                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory
	CALL SUBOPT_0x11D
	CALL SUBOPT_0xC1
; 0000 1AFE 
; 0000 1AFF 
; 0000 1B00                         ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1B01 
; 0000 1B02                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x414:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x116
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x90
	CALL SUBOPT_0x134
	BREQ _0x415
; 0000 1B03                        {
; 0000 1B04                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 1B05                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x120
; 0000 1B06                        }
; 0000 1B07                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x415:
	CALL SUBOPT_0x121
	MOV  R0,R30
	CALL SUBOPT_0x113
	CALL __LTW12
	AND  R30,R0
	BREQ _0x416
; 0000 1B08                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x122
; 0000 1B09 
; 0000 1B0A                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x416:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x123
	AND  R30,R0
	BREQ _0x417
; 0000 1B0B                        {
; 0000 1B0C                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x124
; 0000 1B0D                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1B0E                        }
; 0000 1B0F                    //////////////////////////////////////////////
; 0000 1B10 
; 0000 1B11 
; 0000 1B12 
; 0000 1B13                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1B14 
; 0000 1B15                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
_0x417:
	CALL SUBOPT_0x13D
	MOV  R0,R30
	CALL SUBOPT_0x106
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x90
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x13F
	BREQ _0x41A
; 0000 1B16                        {
; 0000 1B17                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1B18                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 1B19                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x127
; 0000 1B1A                        }
; 0000 1B1B                   if(koniec_rzedu_10 == 0 & powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x41A:
	CALL SUBOPT_0x13D
	MOV  R0,R30
	CALL SUBOPT_0x128
	AND  R0,R30
	CALL SUBOPT_0x106
	CALL __LTW12
	AND  R30,R0
	BREQ _0x41D
; 0000 1B1C                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 1B1D 
; 0000 1B1E                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x41D:
	CALL SUBOPT_0x13D
	MOV  R0,R30
	CALL SUBOPT_0x106
	CALL SUBOPT_0x140
	CALL SUBOPT_0x75
	AND  R30,R0
	BREQ _0x41E
; 0000 1B1F                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x12A
; 0000 1B20                    //////////////////////////////////////////////
; 0000 1B21 
; 0000 1B22                     if((wykonalem_komplet_okregow == 4 &
_0x41E:
; 0000 1B23                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 1B24                         cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0 & powrot_przedwczesny_krazek_scierny == 0) | (wykonalem_komplet_okregow == 4 & koniec_rzedu_10 == 1 & powrot_przedwczesny_krazek_scierny == 0) )
	CALL SUBOPT_0x141
	CALL SUBOPT_0x10C
	CALL SUBOPT_0x12C
	CALL SUBOPT_0x140
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x115
	CALL SUBOPT_0x142
	CALL SUBOPT_0x115
	OR   R30,R1
	BREQ _0x41F
; 0000 1B25                         {
; 0000 1B26                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x12A
; 0000 1B27                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x124
; 0000 1B28                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1B29                         cykl_sterownik_2 = 0;
; 0000 1B2A                         cykl_sterownik_3 = 0;
; 0000 1B2B                         cykl_sterownik_4 = 0;
; 0000 1B2C                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x135
; 0000 1B2D                         krazek_scierny_cykl = 0;
; 0000 1B2E                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1B2F                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1B30                         //PORTF = PORT_F.byte;
; 0000 1B31                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1B32                         cykl_glowny = 9;
; 0000 1B33                         }
; 0000 1B34 }
_0x41F:
	RET
;                                                                                                //ster 1 - ruch po okregu
;                                                                                                //ster 2 - nic
;                                                                                                //ster 3 - krazek - gora dol
;                                                                                                //ster 4 - druciak - gora dol
;
;
;void przypadek88()
; 0000 1B3C {
_przypadek88:
; 0000 1B3D 
; 0000 1B3E                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF1
	BRGE _0x422
; 0000 1B3F                         {
; 0000 1B40                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xF2
; 0000 1B41                         PORTF = PORT_F.byte;
; 0000 1B42                         }
; 0000 1B43 
; 0000 1B44 
; 0000 1B45                      if(rzad_obrabiany == 2)
_0x422:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x423
; 0000 1B46                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1B47 
; 0000 1B48 
; 0000 1B49 
; 0000 1B4A                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x423:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF6
	MOVW R26,R30
	CALL SUBOPT_0xD8
	CALL SUBOPT_0xF7
	BREQ _0x424
; 0000 1B4B                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x6C
	CALL SUBOPT_0xF8
; 0000 1B4C                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x424:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF9
	BREQ _0x425
; 0000 1B4D                         {
; 0000 1B4E                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1B4F                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0xFB
; 0000 1B50                         }
; 0000 1B51 
; 0000 1B52 
; 0000 1B53                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x425:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF6
	CALL SUBOPT_0xFC
	AND  R30,R0
	BREQ _0x426
; 0000 1B54                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0xFD
; 0000 1B55 
; 0000 1B56                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x426:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xFE
	CALL SUBOPT_0xFC
	AND  R30,R0
	BREQ _0x427
; 0000 1B57                         {
; 0000 1B58                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1B59                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0xFF
; 0000 1B5A                         }
; 0000 1B5B 
; 0000 1B5C                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x427:
	CALL SUBOPT_0x73
	CALL SUBOPT_0x100
	AND  R30,R0
	BREQ _0x428
; 0000 1B5D                         {
; 0000 1B5E                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1B5F                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x101
; 0000 1B60                         }
; 0000 1B61 
; 0000 1B62                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1B63                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x428:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x102
	AND  R30,R0
	BREQ _0x429
; 0000 1B64                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x103
; 0000 1B65 
; 0000 1B66 
; 0000 1B67                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x429:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x42A
; 0000 1B68                         {
; 0000 1B69                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1B6A                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x105
; 0000 1B6B                         }
; 0000 1B6C 
; 0000 1B6D                     if(cykl_sterownik_3 < 5 & wykonalem_komplet_okregow == 3)
_0x42A:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x136
	BREQ _0x42B
; 0000 1B6E                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV         //tu zmienienie INV, ¿eby szed³ w dol
	CALL SUBOPT_0x76
	CALL SUBOPT_0xCC
; 0000 1B6F 
; 0000 1B70                      if(cykl_sterownik_3 == 5 & wykonalem_komplet_okregow == 3)
_0x42B:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x137
	BREQ _0x42C
; 0000 1B71                         {
; 0000 1B72                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x138
; 0000 1B73                         krazek_scierny_cykl++;
; 0000 1B74 
; 0000 1B75                         if(krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x117
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x42D
; 0000 1B76                             {
; 0000 1B77                             wykonalem_komplet_okregow = 4;
	CALL SUBOPT_0x139
; 0000 1B78                             }
; 0000 1B79                         else
	RJMP _0x42E
_0x42D:
; 0000 1B7A                             wykonalem_komplet_okregow = 0;
	CALL SUBOPT_0x13A
; 0000 1B7B 
; 0000 1B7C                         cykl_sterownik_1 = 0;
_0x42E:
	CALL SUBOPT_0xFA
; 0000 1B7D                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 1B7E                         }
; 0000 1B7F 
; 0000 1B80 
; 0000 1B81 
; 0000 1B82 
; 0000 1B83 
; 0000 1B84                     if(koniec_rzedu_10 == 1)
_0x42C:
	CALL SUBOPT_0xF3
	BRNE _0x42F
; 0000 1B85                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xF4
; 0000 1B86                                                               //to nowy war, ostatni dzien w borg
; 0000 1B87                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze & koniec_rzedu_10 == 0)
_0x42F:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x108
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x13B
	BREQ _0x430
; 0000 1B88                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xC1
; 0000 1B89 
; 0000 1B8A                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x430:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x10B
	CALL SUBOPT_0x130
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x13C
	BREQ _0x431
; 0000 1B8B                         {
; 0000 1B8C                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x10E
	BRNE _0x432
; 0000 1B8D                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 1B8E                         if(abs_ster4 == 0)
_0x432:
	CALL SUBOPT_0x110
	BRNE _0x433
; 0000 1B8F                             {
; 0000 1B90                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x6E
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x434
; 0000 1B91                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1B92                             szczotka_druc_cykl++;
_0x434:
	CALL SUBOPT_0x111
; 0000 1B93                             abs_ster4 = 1;
; 0000 1B94                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x90
	CALL SUBOPT_0x131
	BRNE _0x437
; 0000 1B95                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0xF4
; 0000 1B96                             }
_0x437:
; 0000 1B97                          else
	RJMP _0x438
_0x433:
; 0000 1B98                             {
; 0000 1B99                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1B9A                             abs_ster4 = 0;
	CALL SUBOPT_0x112
; 0000 1B9B                             sek13 = 0;
; 0000 1B9C                             }
_0x438:
; 0000 1B9D                         }
; 0000 1B9E 
; 0000 1B9F 
; 0000 1BA0 
; 0000 1BA1                         if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x431:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0x75
	CALL SUBOPT_0x108
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x13C
	BREQ _0x43B
; 0000 1BA2                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x72
	CALL SUBOPT_0x133
	CALL SUBOPT_0xC1
; 0000 1BA3 
; 0000 1BA4                         ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1BA5 
; 0000 1BA6                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x43B:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x116
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x90
	CALL SUBOPT_0x134
	BREQ _0x43C
; 0000 1BA7                        {
; 0000 1BA8                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 1BA9                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x120
; 0000 1BAA                        }
; 0000 1BAB                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x43C:
	CALL SUBOPT_0x121
	MOV  R0,R30
	CALL SUBOPT_0x113
	CALL __LTW12
	AND  R30,R0
	BREQ _0x43D
; 0000 1BAC                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x122
; 0000 1BAD 
; 0000 1BAE                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x43D:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x123
	AND  R30,R0
	BREQ _0x43E
; 0000 1BAF                        {
; 0000 1BB0                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x124
; 0000 1BB1                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1BB2                        }
; 0000 1BB3                    //////////////////////////////////////////////
; 0000 1BB4 
; 0000 1BB5 
; 0000 1BB6 
; 0000 1BB7                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1BB8 
; 0000 1BB9                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
_0x43E:
	CALL SUBOPT_0x13D
	MOV  R0,R30
	CALL SUBOPT_0x106
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x90
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x13F
	BREQ _0x441
; 0000 1BBA                        {
; 0000 1BBB                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1BBC                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 1BBD                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x127
; 0000 1BBE                        }
; 0000 1BBF                   if(koniec_rzedu_10 == 0 & powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x441:
	CALL SUBOPT_0x13D
	MOV  R0,R30
	CALL SUBOPT_0x128
	AND  R0,R30
	CALL SUBOPT_0x106
	CALL __LTW12
	AND  R30,R0
	BREQ _0x444
; 0000 1BC0                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 1BC1 
; 0000 1BC2                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x444:
	CALL SUBOPT_0x13D
	MOV  R0,R30
	CALL SUBOPT_0x106
	CALL SUBOPT_0x140
	CALL SUBOPT_0x75
	AND  R30,R0
	BREQ _0x445
; 0000 1BC3                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x12A
; 0000 1BC4                    //////////////////////////////////////////////
; 0000 1BC5 
; 0000 1BC6                     if((wykonalem_komplet_okregow == 4 &
_0x445:
; 0000 1BC7                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 1BC8                         cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0 & powrot_przedwczesny_krazek_scierny == 0) | (wykonalem_komplet_okregow == 4 & koniec_rzedu_10 == 1 & powrot_przedwczesny_krazek_scierny == 0) )
	CALL SUBOPT_0x141
	CALL SUBOPT_0x10C
	CALL SUBOPT_0x12C
	CALL SUBOPT_0x140
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x115
	CALL SUBOPT_0x142
	CALL SUBOPT_0x115
	OR   R30,R1
	BREQ _0x446
; 0000 1BC9                         {
; 0000 1BCA                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x12A
; 0000 1BCB                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x124
; 0000 1BCC                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1BCD                         cykl_sterownik_2 = 0;
; 0000 1BCE                         cykl_sterownik_3 = 0;
; 0000 1BCF                         cykl_sterownik_4 = 0;
; 0000 1BD0                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x135
; 0000 1BD1                         krazek_scierny_cykl = 0;
; 0000 1BD2                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1BD3                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1BD4                         //PORTF = PORT_F.byte;
; 0000 1BD5                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1BD6                         cykl_glowny = 9;
; 0000 1BD7                         }
; 0000 1BD8 
; 0000 1BD9                                                                                                 //ster 1 - ruch po okregu
; 0000 1BDA                                                                                                 //ster 2 - nic
; 0000 1BDB                                                                                                 //ster 3 - krazek - gora dol
; 0000 1BDC                                                                                                 //ster 4 - druciak - gora dol
; 0000 1BDD 
; 0000 1BDE 
; 0000 1BDF }
_0x446:
	RET
;
;
;void main(void)
; 0000 1BE3 {
_main:
; 0000 1BE4 
; 0000 1BE5 // Input/Output Ports initialization
; 0000 1BE6 // Port A initialization
; 0000 1BE7 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1BE8 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1BE9 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 1BEA DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 1BEB 
; 0000 1BEC // Port B initialization
; 0000 1BED // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1BEE // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1BEF PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 1BF0 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 1BF1 
; 0000 1BF2 // Port C initialization
; 0000 1BF3 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1BF4 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1BF5 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 1BF6 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 1BF7 
; 0000 1BF8 // Port D initialization
; 0000 1BF9 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1BFA // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1BFB PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 1BFC DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 1BFD 
; 0000 1BFE // Port E initialization
; 0000 1BFF // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1C00 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1C01 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 1C02 DDRE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 1C03 
; 0000 1C04 // Port F initialization
; 0000 1C05 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1C06 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1C07 PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 1C08 DDRF=0xFF;
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 1C09 
; 0000 1C0A // Port G initialization
; 0000 1C0B // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1C0C // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1C0D PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 1C0E DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 1C0F 
; 0000 1C10 
; 0000 1C11 
; 0000 1C12 
; 0000 1C13 
; 0000 1C14 // Timer/Counter 0 initialization
; 0000 1C15 // Clock source: System Clock
; 0000 1C16 // Clock value: 15,625 kHz
; 0000 1C17 // Mode: Normal top=0xFF
; 0000 1C18 // OC0 output: Disconnected
; 0000 1C19 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 1C1A TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 1C1B TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 1C1C OCR0=0x00;
	OUT  0x31,R30
; 0000 1C1D 
; 0000 1C1E // Timer/Counter 1 initialization
; 0000 1C1F // Clock source: System Clock
; 0000 1C20 // Clock value: Timer1 Stopped
; 0000 1C21 // Mode: Normal top=0xFFFF
; 0000 1C22 // OC1A output: Discon.
; 0000 1C23 // OC1B output: Discon.
; 0000 1C24 // OC1C output: Discon.
; 0000 1C25 // Noise Canceler: Off
; 0000 1C26 // Input Capture on Falling Edge
; 0000 1C27 // Timer1 Overflow Interrupt: Off
; 0000 1C28 // Input Capture Interrupt: Off
; 0000 1C29 // Compare A Match Interrupt: Off
; 0000 1C2A // Compare B Match Interrupt: Off
; 0000 1C2B // Compare C Match Interrupt: Off
; 0000 1C2C TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 1C2D TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 1C2E TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 1C2F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 1C30 ICR1H=0x00;
	OUT  0x27,R30
; 0000 1C31 ICR1L=0x00;
	OUT  0x26,R30
; 0000 1C32 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 1C33 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 1C34 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 1C35 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 1C36 OCR1CH=0x00;
	STS  121,R30
; 0000 1C37 OCR1CL=0x00;
	STS  120,R30
; 0000 1C38 
; 0000 1C39 // Timer/Counter 2 initialization
; 0000 1C3A // Clock source: System Clock
; 0000 1C3B // Clock value: Timer2 Stopped
; 0000 1C3C // Mode: Normal top=0xFF
; 0000 1C3D // OC2 output: Disconnected
; 0000 1C3E TCCR2=0x00;
	OUT  0x25,R30
; 0000 1C3F TCNT2=0x00;
	OUT  0x24,R30
; 0000 1C40 OCR2=0x00;
	OUT  0x23,R30
; 0000 1C41 
; 0000 1C42 // Timer/Counter 3 initialization
; 0000 1C43 // Clock source: System Clock
; 0000 1C44 // Clock value: Timer3 Stopped
; 0000 1C45 // Mode: Normal top=0xFFFF
; 0000 1C46 // OC3A output: Discon.
; 0000 1C47 // OC3B output: Discon.
; 0000 1C48 // OC3C output: Discon.
; 0000 1C49 // Noise Canceler: Off
; 0000 1C4A // Input Capture on Falling Edge
; 0000 1C4B // Timer3 Overflow Interrupt: Off
; 0000 1C4C // Input Capture Interrupt: Off
; 0000 1C4D // Compare A Match Interrupt: Off
; 0000 1C4E // Compare B Match Interrupt: Off
; 0000 1C4F // Compare C Match Interrupt: Off
; 0000 1C50 TCCR3A=0x00;
	STS  139,R30
; 0000 1C51 TCCR3B=0x00;
	STS  138,R30
; 0000 1C52 TCNT3H=0x00;
	STS  137,R30
; 0000 1C53 TCNT3L=0x00;
	STS  136,R30
; 0000 1C54 ICR3H=0x00;
	STS  129,R30
; 0000 1C55 ICR3L=0x00;
	STS  128,R30
; 0000 1C56 OCR3AH=0x00;
	STS  135,R30
; 0000 1C57 OCR3AL=0x00;
	STS  134,R30
; 0000 1C58 OCR3BH=0x00;
	STS  133,R30
; 0000 1C59 OCR3BL=0x00;
	STS  132,R30
; 0000 1C5A OCR3CH=0x00;
	STS  131,R30
; 0000 1C5B OCR3CL=0x00;
	STS  130,R30
; 0000 1C5C 
; 0000 1C5D // External Interrupt(s) initialization
; 0000 1C5E // INT0: Off
; 0000 1C5F // INT1: Off
; 0000 1C60 // INT2: Off
; 0000 1C61 // INT3: Off
; 0000 1C62 // INT4: Off
; 0000 1C63 // INT5: Off
; 0000 1C64 // INT6: Off
; 0000 1C65 // INT7: Off
; 0000 1C66 EICRA=0x00;
	STS  106,R30
; 0000 1C67 EICRB=0x00;
	OUT  0x3A,R30
; 0000 1C68 EIMSK=0x00;
	OUT  0x39,R30
; 0000 1C69 
; 0000 1C6A // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 1C6B TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 1C6C 
; 0000 1C6D ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 1C6E 
; 0000 1C6F 
; 0000 1C70 // USART0 initialization
; 0000 1C71 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 1C72 // USART0 Receiver: On
; 0000 1C73 // USART0 Transmitter: On
; 0000 1C74 // USART0 Mode: Asynchronous
; 0000 1C75 // USART0 Baud Rate: 115200
; 0000 1C76 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 1C77 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 1C78 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 1C79 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 1C7A UBRR0L=0x08;
	LDI  R30,LOW(8)
	OUT  0x9,R30
; 0000 1C7B 
; 0000 1C7C // USART1 initialization
; 0000 1C7D // USART1 disabled
; 0000 1C7E UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 1C7F 
; 0000 1C80 // Analog Comparator initialization
; 0000 1C81 // Analog Comparator: Off
; 0000 1C82 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 1C83 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 1C84 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 1C85 
; 0000 1C86 // ADC initialization
; 0000 1C87 // ADC disabled
; 0000 1C88 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 1C89 
; 0000 1C8A // SPI initialization
; 0000 1C8B // SPI disabled
; 0000 1C8C SPCR=0x00;
	OUT  0xD,R30
; 0000 1C8D 
; 0000 1C8E // TWI initialization
; 0000 1C8F // TWI disabled
; 0000 1C90 TWCR=0x00;
	STS  116,R30
; 0000 1C91 
; 0000 1C92 //ciekawe, tej linijki brakowalo w medalach ,wyczailem w borgu
; 0000 1C93 // I2C Bus initialization
; 0000 1C94 i2c_init();
	CALL _i2c_init
; 0000 1C95 
; 0000 1C96 // Global enable interrupts
; 0000 1C97 #asm("sei")
	sei
; 0000 1C98 
; 0000 1C99 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x143
; 0000 1C9A delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x143
; 0000 1C9B delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x143
; 0000 1C9C delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x143
; 0000 1C9D 
; 0000 1C9E //jak patrze na maszyne to ten po lewej to 1
; 0000 1C9F 
; 0000 1CA0 putchar(90);  //5A
	CALL SUBOPT_0x3
; 0000 1CA1 putchar(165); //A5
; 0000 1CA2 putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _putchar
; 0000 1CA3 putchar(128);  //80
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _putchar
; 0000 1CA4 putchar(2);    //02
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
; 0000 1CA5 putchar(16);   //10
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
; 0000 1CA6 
; 0000 1CA7 il_prob_odczytu = 1;    //100
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 1CA8 start = 0;
	CALL SUBOPT_0x9E
; 0000 1CA9 //szczotka_druciana_ilosc_cykli = 4; bo eeprom
; 0000 1CAA //krazek_scierny_cykl_po_okregu_ilosc = 4;
; 0000 1CAB //krazek_scierny_ilosc_cykli = 4;
; 0000 1CAC rzad_obrabiany = 1;
	CALL SUBOPT_0x144
; 0000 1CAD jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 1CAE wykonalem_rzedow = 0;
	CALL SUBOPT_0x145
; 0000 1CAF cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x146
; 0000 1CB0 guzik1_przelaczania_zaciskow = 1;
	SET
	BLD  R2,0
; 0000 1CB1 guzik2_przelaczania_zaciskow = 1;
	BLD  R2,1
; 0000 1CB2 //PORTE.6 = 1;  //aby byl dostep do zaciskow rzad 1
; 0000 1CB3 zmienna_przelaczanie_zaciskow = 1;
	BLD  R2,2
; 0000 1CB4 czas_przedmuchu = 183;
	LDI  R30,LOW(183)
	LDI  R31,HIGH(183)
	STS  _czas_przedmuchu,R30
	STS  _czas_przedmuchu+1,R31
; 0000 1CB5 predkosc_pion_szczotka = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 1CB6 predkosc_pion_krazek = 100;
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 1CB7 wejscie_krazka_sciernego_w_pow_boczna_cylindra = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 1CB8 predkosc_ruchow_po_okregu_krazek_scierny = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 1CB9 czas_druciaka_na_gorze = 100;  //1 sekundy dla druciaka na gorze aby dolek zrobil git (kiedyS), zmieniam na 3s
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _czas_druciaka_na_gorze,R30
	STS  _czas_druciaka_na_gorze+1,R31
; 0000 1CBA czas_zatrzymania_na_dole = 120;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	MOVW R12,R30
; 0000 1CBB //tryb_pracy_szczotki_drucianej = 1;
; 0000 1CBC 
; 0000 1CBD adr1 = 80;  //rzad 1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STS  _adr1,R30
	STS  _adr1+1,R31
; 0000 1CBE adr2 = 0;   //
	LDI  R30,LOW(0)
	STS  _adr2,R30
	STS  _adr2+1,R30
; 0000 1CBF adr3 = 64;  //rzad 2
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STS  _adr3,R30
	STS  _adr3+1,R31
; 0000 1CC0 adr4 = 0;
	LDI  R30,LOW(0)
	STS  _adr4,R30
	STS  _adr4+1,R30
; 0000 1CC1 
; 0000 1CC2 
; 0000 1CC3 wartosci_wstepne_panelu();
	CALL _wartosci_wstepne_panelu
; 0000 1CC4 wypozycjonuj_napedy_minimalistyczna();
	CALL _wypozycjonuj_napedy_minimalistyczna
; 0000 1CC5 sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 1CC6 
; 0000 1CC7 //mniejsze ziarno na krazku - dobry pomysl
; 0000 1CC8 
; 0000 1CC9 
; 0000 1CCA while (1)
_0x449:
; 0000 1CCB       {
; 0000 1CCC       ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1CCD       przerzucanie_dociskow();
	CALL _przerzucanie_dociskow
; 0000 1CCE       kontrola_zoltego_swiatla();
	CALL _kontrola_zoltego_swiatla
; 0000 1CCF       wymiana_szczotki_i_krazka();
	CALL _wymiana_szczotki_i_krazka
; 0000 1CD0       zaktualizuj_parametry_panelu();
	CALL _zaktualizuj_parametry_panelu
; 0000 1CD1       odpytaj_parametry_panelu();
	CALL _odpytaj_parametry_panelu
; 0000 1CD2       test_geometryczny();
	CALL _test_geometryczny
; 0000 1CD3       sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 1CD4 
; 0000 1CD5       while((start == 1 & il_zaciskow_rzad_1 > 1 & il_zaciskow_rzad_2 != 1 & macierz_zaciskow[1]!=0  & (macierz_zaciskow[2]!=0 |  il_zaciskow_rzad_2 == 0)) | jestem_w_trakcie_czyszczenia_calosci == 1)
_0x44C:
	CALL SUBOPT_0xA6
	CALL SUBOPT_0x75
	MOV  R0,R30
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xD7
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	AND  R0,R30
	CALL SUBOPT_0xBB
	MOV  R1,R30
	CALL SUBOPT_0xD9
	MOV  R0,R30
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xB8
	OR   R30,R0
	AND  R30,R1
	MOV  R0,R30
	LDS  R26,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R27,_jestem_w_trakcie_czyszczenia_calosci+1
	CALL SUBOPT_0x75
	OR   R30,R0
	BRNE PC+3
	JMP _0x44E
; 0000 1CD6             {
; 0000 1CD7             switch (cykl_glowny)
	LDS  R30,_cykl_glowny
	LDS  R31,_cykl_glowny+1
; 0000 1CD8             {
; 0000 1CD9             case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x452
; 0000 1CDA 
; 0000 1CDB 
; 0000 1CDC                     PORTB.6 = 1;   ////zielona lampka
	SBI  0x18,6
; 0000 1CDD                     if(jestem_w_trakcie_czyszczenia_calosci == 0)
	LDS  R30,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R31,_jestem_w_trakcie_czyszczenia_calosci+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x455
; 0000 1CDE                         {
; 0000 1CDF                         //PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1CE0 
; 0000 1CE1                         srednica_wew_korpusu_cyklowa = srednica_wew_korpusu;
	LDS  R30,_srednica_wew_korpusu
	LDS  R31,_srednica_wew_korpusu+1
	STS  _srednica_wew_korpusu_cyklowa,R30
	STS  _srednica_wew_korpusu_cyklowa+1,R31
; 0000 1CE2 
; 0000 1CE3                         wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad1
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
; 0000 1CE4                         wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad2
	CALL SUBOPT_0xE
	CALL SUBOPT_0xA4
	CALL SUBOPT_0xB
; 0000 1CE5 
; 0000 1CE6                         il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
	CALL SUBOPT_0xE
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
; 0000 1CE7                         il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
; 0000 1CE8 
; 0000 1CE9 
; 0000 1CEA                         szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64) - 1;  //wykonano zaciskow rzad1
	CALL SUBOPT_0x1B
	SBIW R30,1
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL __EEPROMWRW
; 0000 1CEB 
; 0000 1CEC                         tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0x28
	CALL SUBOPT_0x24
	LDI  R26,LOW(_tryb_pracy_szczotki_drucianej)
	LDI  R27,HIGH(_tryb_pracy_szczotki_drucianej)
	CALL __EEPROMWRW
; 0000 1CED 
; 0000 1CEE                         if(tryb_pracy_szczotki_drucianej == 1)
	CALL SUBOPT_0x6E
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x456
; 0000 1CEF                             szczotka_druciana_ilosc_cykli = 1; //zmieniam bo teraz inny ruch szczotki drucianej, jeden schodek na dole
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EEPROMWRW
; 0000 1CF0                         if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)
_0x456:
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x71
	BREQ _0x457
; 0000 1CF1                             czas_druciaka_na_gorze = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _czas_druciaka_na_gorze,R30
	STS  _czas_druciaka_na_gorze+1,R31
; 0000 1CF2 
; 0000 1CF3                                                 //2090
; 0000 1CF4                         krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);  //wykonano zaciskow rzad1
_0x457:
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
; 0000 1CF5                                                     //3000
; 0000 1CF6 
; 0000 1CF7                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);  //wykonano zaciskow rzad1
	CALL SUBOPT_0xE
	CALL SUBOPT_0x23
; 0000 1CF8 
; 0000 1CF9                         if(krazek_scierny_cykl_po_okregu_ilosc == 0)
	CALL SUBOPT_0x73
	SBIW R30,0
	BRNE _0x458
; 0000 1CFA                             {
; 0000 1CFB                             krazek_scierny_ilosc_cykli--;
	CALL SUBOPT_0x92
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
; 0000 1CFC                             }
; 0000 1CFD 
; 0000 1CFE                         predkosc_pion_szczotka = odczytaj_parametr(32,80);
_0x458:
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x25
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 1CFF                                                 //2060
; 0000 1D00                         predkosc_pion_krazek = odczytaj_parametr(32,96);
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0xA
	CALL SUBOPT_0x24
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 1D01 
; 0000 1D02                         wejscie_krazka_sciernego_w_pow_boczna_cylindra = odczytaj_parametr(48,16);
	CALL SUBOPT_0x1E
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x24
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 1D03 
; 0000 1D04                         predkosc_ruchow_po_okregu_krazek_scierny = odczytaj_parametr(32,112);
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0xD
	CALL SUBOPT_0x24
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 1D05 
; 0000 1D06                         srednica_krazka_sciernego = odczytaj_parametr(48,112);
	CALL SUBOPT_0x26
	CALL SUBOPT_0x24
	CALL SUBOPT_0x27
; 0000 1D07 
; 0000 1D08                         ruch_haos = odczytaj_parametr(48,144);
	CALL SUBOPT_0x21
	STS  _ruch_haos,R30
	STS  _ruch_haos+1,R31
; 0000 1D09 
; 0000 1D0A                         if(il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0)
	CALL SUBOPT_0xD7
	CALL SUBOPT_0x147
	CALL SUBOPT_0xD9
	AND  R30,R0
	BREQ _0x459
; 0000 1D0B                               il_zaciskow_rzad_2 = il_zaciskow_rzad_2;
	CALL SUBOPT_0x148
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
; 0000 1D0C                         else
	RJMP _0x45A
_0x459:
; 0000 1D0D                               il_zaciskow_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R30
; 0000 1D0E 
; 0000 1D0F                         wybor_linijek_sterownikow(1);  //rzad 1
_0x45A:
	CALL SUBOPT_0xBC
; 0000 1D10                         }
; 0000 1D11 
; 0000 1D12                     jestem_w_trakcie_czyszczenia_calosci = 1;
_0x455:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R31
; 0000 1D13 
; 0000 1D14                     if(rzad_obrabiany == 1)
	CALL SUBOPT_0x8D
	SBIW R26,1
	BRNE _0x45B
; 0000 1D15                     {
; 0000 1D16                     PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
	CBI  0x3,6
; 0000 1D17                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x45E
; 0000 1D18                         cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xC5
; 0000 1D19                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x45E:
	CALL SUBOPT_0xC6
	SBIW R26,5
	BRGE _0x45F
; 0000 1D1A                         cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC8
; 0000 1D1B                     }
_0x45F:
; 0000 1D1C 
; 0000 1D1D                     if(rzad_obrabiany == 2)
_0x45B:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x460
; 0000 1D1E                     {
; 0000 1D1F                     ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1D20                     //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2 - na razie nie bo nie ma jeszcze oslon
; 0000 1D21 
; 0000 1D22                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x461
; 0000 1D23                         cykl_sterownik_1 = sterownik_1_praca(0x008);
	CALL SUBOPT_0xC7
	CALL SUBOPT_0xC5
; 0000 1D24                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x461:
	CALL SUBOPT_0xC6
	SBIW R26,5
	BRGE _0x462
; 0000 1D25                         cykl_sterownik_2 = sterownik_2_praca(0x001);       //ster 2 pod pin pozy rzad 2
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xC8
; 0000 1D26                     }
_0x462:
; 0000 1D27 
; 0000 1D28 
; 0000 1D29                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x460:
	CALL SUBOPT_0xC9
	BREQ _0x463
; 0000 1D2A                         {
; 0000 1D2B 
; 0000 1D2C                           if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x464
; 0000 1D2D                             {
; 0000 1D2E                             while(PORTE.6 == 0)
_0x465:
	SBIC 0x3,6
	RJMP _0x467
; 0000 1D2F                                 przerzucanie_dociskow();
	CALL _przerzucanie_dociskow
	RJMP _0x465
_0x467:
; 0000 1D30 delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 1D31                             }
; 0000 1D32 
; 0000 1D33                         delay_ms(2000);  //aby zdazyl przelozyc
_0x464:
	CALL SUBOPT_0x143
; 0000 1D34                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1D35                         cykl_sterownik_2 = 0;
; 0000 1D36                         cykl_sterownik_3 = 0;
; 0000 1D37                         cykl_sterownik_4 = 0;
; 0000 1D38                         cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x146
; 0000 1D39                         koniec_rzedu_10 = 0;
	CALL SUBOPT_0x149
; 0000 1D3A                         cykl_glowny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x14A
; 0000 1D3B                         }
; 0000 1D3C 
; 0000 1D3D             break;
_0x463:
	RJMP _0x451
; 0000 1D3E 
; 0000 1D3F 
; 0000 1D40 
; 0000 1D41             case 1:
_0x452:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x468
; 0000 1D42 
; 0000 1D43 
; 0000 1D44                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 1)
	CALL SUBOPT_0x14B
	CALL SUBOPT_0x14C
	AND  R30,R0
	BREQ _0x469
; 0000 1D45                           {          //ster 1 nic
; 0000 1D46                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 1D47                           cykl_sterownik_2 = sterownik_2_praca(a[0]);        //ster 2 pod zacisk
	CALL SUBOPT_0xCB
	CALL SUBOPT_0xC8
; 0000 1D48                           }                                                    //ster 4 na pozycje miedzy rzedzami
; 0000 1D49 
; 0000 1D4A                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 2)
_0x469:
	CALL SUBOPT_0x14B
	CALL SUBOPT_0x8F
	AND  R30,R0
	BREQ _0x46C
; 0000 1D4B                         {
; 0000 1D4C                         //cykl_sterownik_2 = sterownik_2_praca(0x5B,0);
; 0000 1D4D                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 1D4E                           ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1D4F                           cykl_sterownik_2 = sterownik_2_praca(a[1]);
	CALL SUBOPT_0xDD
	CALL SUBOPT_0xC8
; 0000 1D50                          }
; 0000 1D51                      if(cykl_sterownik_4 < 5 & cykl_sterownik_2 == 5)
_0x46C:
	CALL SUBOPT_0x106
	CALL __LTW12
	CALL SUBOPT_0x14D
	AND  R30,R0
	BREQ _0x46F
; 0000 1D52                        // cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);
; 0000 1D53                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 1D54 
; 0000 1D55                       if(cykl_sterownik_2 == 5 & cykl_sterownik_4 == 5)
_0x46F:
	CALL SUBOPT_0xC6
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x106
	CALL __EQW12
	AND  R30,R0
	BREQ _0x470
; 0000 1D56                         {
; 0000 1D57                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1D58                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x14E
; 0000 1D59                         cykl_sterownik_4 = 0;
; 0000 1D5A                         szczotka_druc_cykl = 0;
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
; 0000 1D5B                         cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x14A
; 0000 1D5C                         }
; 0000 1D5D 
; 0000 1D5E 
; 0000 1D5F             break;
_0x470:
	RJMP _0x451
; 0000 1D60 
; 0000 1D61 
; 0000 1D62             case 2:
_0x468:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x471
; 0000 1D63                     if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x472
; 0000 1D64                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1D65 
; 0000 1D66                     if(cykl_sterownik_4 < 5)
_0x472:
	CALL SUBOPT_0xC0
	SBIW R26,5
	BRGE _0x473
; 0000 1D67                           cykl_sterownik_4 = sterownik_4_praca(a[2],1);
	CALL SUBOPT_0x72
	CALL SUBOPT_0x133
	CALL SUBOPT_0xC1
; 0000 1D68                     if(cykl_sterownik_4 == 5)
_0x473:
	CALL SUBOPT_0xC0
	SBIW R26,5
	BRNE _0x474
; 0000 1D69                         {
; 0000 1D6A                         PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1D6B                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 1D6C 
; 0000 1D6D                         //if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
; 0000 1D6E                         //     cykl_sterownik_4 = 5;
; 0000 1D6F 
; 0000 1D70                         sek13 = 0;
	CALL SUBOPT_0x14F
; 0000 1D71                         cykl_glowny = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x14A
; 0000 1D72                         }
; 0000 1D73             break;
_0x474:
	RJMP _0x451
; 0000 1D74 
; 0000 1D75 
; 0000 1D76             case 3:
_0x471:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x477
; 0000 1D77 
; 0000 1D78                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x478
; 0000 1D79                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1D7A 
; 0000 1D7B                     if(cykl_sterownik_4 < 5 & sek13 > czas_druciaka_na_gorze & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x478:
	CALL SUBOPT_0x106
	CALL __LTW12
	MOV  R0,R30
	LDS  R30,_czas_druciaka_na_gorze
	LDS  R31,_czas_druciaka_na_gorze+1
	LDS  R26,_sek13
	LDS  R27,_sek13+1
	LDS  R24,_sek13+2
	LDS  R25,_sek13+3
	CALL __CWD1
	CALL __GTD12
	AND  R0,R30
	CALL SUBOPT_0x90
	CALL SUBOPT_0x150
	BREQ _0x479
; 0000 1D7C                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xC1
; 0000 1D7D 
; 0000 1D7E                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x479:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x10B
	CALL SUBOPT_0x150
	BREQ _0x47A
; 0000 1D7F                         {
; 0000 1D80                         szczotka_druc_cykl++;
	LDI  R26,LOW(_szczotka_druc_cykl)
	LDI  R27,HIGH(_szczotka_druc_cykl)
	CALL SUBOPT_0x151
; 0000 1D81                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 1D82 
; 0000 1D83                         if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x152
	CALL SUBOPT_0x153
	AND  R30,R0
	BREQ _0x47B
; 0000 1D84                             cykl_sterownik_4 = 5;
	CALL SUBOPT_0xF4
; 0000 1D85 
; 0000 1D86 
; 0000 1D87 
; 0000 1D88                         if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x47B:
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x152
	CALL SUBOPT_0x150
	BREQ _0x47C
; 0000 1D89                                {
; 0000 1D8A                                cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x14A
; 0000 1D8B                                if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x6E
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x47D
; 0000 1D8C                                    PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1D8D                                }
_0x47D:
; 0000 1D8E                         }
_0x47C:
; 0000 1D8F 
; 0000 1D90                     if(cykl_sterownik_4 < 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & tryb_pracy_szczotki_drucianej == 1)
_0x47A:
	CALL SUBOPT_0x106
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x90
	CALL SUBOPT_0x153
	AND  R0,R30
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x154
	BREQ _0x480
; 0000 1D91                          cykl_sterownik_4 = sterownik_4_praca(0x03,0); //INV
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xC1
; 0000 1D92 
; 0000 1D93 
; 0000 1D94 
; 0000 1D95                         if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
_0x480:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x10B
	CALL SUBOPT_0x153
	AND  R30,R0
	BREQ _0x481
; 0000 1D96                             {
; 0000 1D97                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1D98                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 1D99                             cykl_glowny = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x14A
; 0000 1D9A                             }
; 0000 1D9B 
; 0000 1D9C             break;
_0x481:
	RJMP _0x451
; 0000 1D9D 
; 0000 1D9E             case 4:
_0x477:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x484
; 0000 1D9F 
; 0000 1DA0 
; 0000 1DA1                       if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x485
; 0000 1DA2                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1DA3 
; 0000 1DA4                      if(cykl_sterownik_4 < 5)
_0x485:
	CALL SUBOPT_0xC0
	SBIW R26,5
	BRGE _0x486
; 0000 1DA5                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 1DA6 
; 0000 1DA7                      if(cykl_sterownik_4 == 5)
_0x486:
	CALL SUBOPT_0xC0
	SBIW R26,5
	BRNE _0x487
; 0000 1DA8                         {
; 0000 1DA9                         PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1DAA                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 1DAB                         ruch_zlozony = 0;
	LDI  R30,LOW(0)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R30
; 0000 1DAC                         cykl_glowny = 5;
	CALL SUBOPT_0x155
; 0000 1DAD                         }
; 0000 1DAE 
; 0000 1DAF             break;
_0x487:
	RJMP _0x451
; 0000 1DB0 
; 0000 1DB1             case 5:
_0x484:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x48A
; 0000 1DB2 
; 0000 1DB3 
; 0000 1DB4                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 1)
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x156
	AND  R0,R30
	CALL SUBOPT_0x14C
	AND  R30,R0
	BREQ _0x48B
; 0000 1DB5                         cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC5
; 0000 1DB6                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 2)
_0x48B:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x156
	AND  R0,R30
	CALL SUBOPT_0x8F
	AND  R30,R0
	BREQ _0x48C
; 0000 1DB7                         cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xC5
; 0000 1DB8 
; 0000 1DB9                      if(rzad_obrabiany == 2)
_0x48C:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x48D
; 0000 1DBA                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1DBB 
; 0000 1DBC                     if(cykl_sterownik_1 == 5 & ruch_zlozony == 0)
_0x48D:
	CALL SUBOPT_0xF5
	CALL __EQW12
	CALL SUBOPT_0x157
	CALL SUBOPT_0xA0
	BREQ _0x48E
; 0000 1DBD                         {
; 0000 1DBE                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1DBF                         ruch_zlozony = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 1DC0                         }
; 0000 1DC1 
; 0000 1DC2                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 1)
_0x48E:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x158
	CALL SUBOPT_0x75
	AND  R0,R30
	CALL SUBOPT_0x14C
	AND  R30,R0
	BREQ _0x48F
; 0000 1DC3                         cykl_sterownik_1 = sterownik_1_praca(a[0]);
	CALL SUBOPT_0xCB
	CALL SUBOPT_0xC5
; 0000 1DC4                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 2)
_0x48F:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x158
	CALL SUBOPT_0x75
	AND  R0,R30
	CALL SUBOPT_0x8F
	AND  R30,R0
	BREQ _0x490
; 0000 1DC5                           cykl_sterownik_1 = sterownik_1_praca(a[1]);
	CALL SUBOPT_0xDD
	CALL SUBOPT_0xC5
; 0000 1DC6 
; 0000 1DC7 
; 0000 1DC8                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 2)
_0x490:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x158
	CALL SUBOPT_0xA5
	AND  R30,R0
	BREQ _0x491
; 0000 1DC9                         cykl_sterownik_1 = sterownik_1_praca(0x003);     ////////////////////////////////////////////////////////////
	CALL SUBOPT_0xD6
; 0000 1DCA 
; 0000 1DCB                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 0)                                //ster 1 do pierwszego dolka
_0x491:
	CALL SUBOPT_0x14B
	CALL SUBOPT_0x159
	CALL SUBOPT_0xA0
	BREQ _0x492
; 0000 1DCC                         cykl_sterownik_2 = sterownik_2_praca(0x003);       //ster 2 pod nastpeny dolek
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x15A
; 0000 1DCD 
; 0000 1DCE 
; 0000 1DCF                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 1)
_0x492:
	CALL SUBOPT_0x14B
	CALL SUBOPT_0x159
	CALL SUBOPT_0x75
	AND  R0,R30
	CALL SUBOPT_0x14C
	AND  R30,R0
	BREQ _0x493
; 0000 1DD0                         cykl_sterownik_2 = sterownik_2_praca(0x008);      //ster 2 do samego tylu
	CALL SUBOPT_0xC7
	CALL SUBOPT_0xC8
; 0000 1DD1                      if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 2)
_0x493:
	CALL SUBOPT_0x14B
	CALL SUBOPT_0x159
	CALL SUBOPT_0x75
	AND  R0,R30
	CALL SUBOPT_0x8F
	AND  R30,R0
	BREQ _0x494
; 0000 1DD2                         cykl_sterownik_2 = sterownik_2_praca(0x009);      //ster 2 do samego tylu
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xC8
; 0000 1DD3 
; 0000 1DD4                     if((cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5 & ruch_zlozony == 1) | (cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5) & ruch_zlozony == 2)
_0x494:
	CALL SUBOPT_0xF5
	CALL __EQW12
	CALL SUBOPT_0x14D
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0x75
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0xF5
	CALL __EQW12
	CALL SUBOPT_0x14D
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0xA5
	AND  R30,R0
	OR   R30,R1
	BREQ _0x495
; 0000 1DD5                         {
; 0000 1DD6                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1DD7                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x14E
; 0000 1DD8                         cykl_sterownik_4 = 0;
; 0000 1DD9                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 1DDA                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
	SBI  0x3,3
; 0000 1DDB                         cykl_glowny = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x14A
; 0000 1DDC                         }
; 0000 1DDD 
; 0000 1DDE             break;
_0x495:
	RJMP _0x451
; 0000 1DDF 
; 0000 1DE0             case 6:
_0x48A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x498
; 0000 1DE1 
; 0000 1DE2                     if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBE
	SBIW R26,5
	BRGE _0x499
; 0000 1DE3                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs //krazek scierny do gory
	CALL SUBOPT_0x6B
	CALL SUBOPT_0xCC
; 0000 1DE4 
; 0000 1DE5                     if(koniec_rzedu_10 == 1)
_0x499:
	CALL SUBOPT_0xF3
	BRNE _0x49A
; 0000 1DE6                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xF4
; 0000 1DE7 
; 0000 1DE8                     if(cykl_sterownik_4 < 5)
_0x49A:
	CALL SUBOPT_0xC0
	SBIW R26,5
	BRGE _0x49B
; 0000 1DE9                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);    //ABS          //druciak do gory
	CALL SUBOPT_0x72
	CALL SUBOPT_0x133
	CALL SUBOPT_0xC1
; 0000 1DEA 
; 0000 1DEB                      if(rzad_obrabiany == 2)
_0x49B:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x49C
; 0000 1DEC                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1DED 
; 0000 1DEE 
; 0000 1DEF                     if(cykl_sterownik_4 == 5 & cykl_sterownik_3 == 5)
_0x49C:
	CALL SUBOPT_0x106
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x113
	CALL __EQW12
	AND  R30,R0
	BREQ _0x49D
; 0000 1DF0                         {
; 0000 1DF1                         if((cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1 & rzad_obrabiany == 1) | (cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1 & rzad_obrabiany == 2))
	CALL SUBOPT_0x15B
	MOV  R0,R30
	CALL SUBOPT_0x14C
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0x15C
	MOV  R0,R30
	CALL SUBOPT_0x8F
	AND  R30,R0
	OR   R30,R1
	BREQ _0x49E
; 0000 1DF2                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1DF3 
; 0000 1DF4                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
_0x49E:
	SBI  0x3,3
; 0000 1DF5                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC3
; 0000 1DF6                         cykl_sterownik_4 = 0;
; 0000 1DF7                         if(cykl_ilosc_zaciskow > 0)
	CALL SUBOPT_0x15D
	CALL __CPW02
	BRGE _0x4A3
; 0000 1DF8                                 {
; 0000 1DF9                                 sek12 = 0;    //do przedmuchu
	CALL SUBOPT_0x15E
; 0000 1DFA                                 PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x15F
; 0000 1DFB                                 PORTF = PORT_F.byte;
; 0000 1DFC                                 }
; 0000 1DFD                         sek13 = 0;
_0x4A3:
	CALL SUBOPT_0x14F
; 0000 1DFE                         cykl_glowny = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x14A
; 0000 1DFF                         }
; 0000 1E00 
; 0000 1E01            break;
_0x49D:
	RJMP _0x451
; 0000 1E02 
; 0000 1E03 
; 0000 1E04            case 7:
_0x498:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4A4
; 0000 1E05 
; 0000 1E06 
; 0000 1E07                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x4A5
; 0000 1E08                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1E09 
; 0000 1E0A                         wykonalem_komplet_okregow = 0;
_0x4A5:
	CALL SUBOPT_0x13A
; 0000 1E0B                         szczotka_druc_cykl = 0;
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
; 0000 1E0C                         krazek_scierny_cykl_po_okregu = 0;
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
; 0000 1E0D                         krazek_scierny_cykl = 0;
	STS  _krazek_scierny_cykl,R30
	STS  _krazek_scierny_cykl+1,R30
; 0000 1E0E                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x124
; 0000 1E0F                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x12A
; 0000 1E10 
; 0000 1E11                         abs_ster3 = 0;
	CALL SUBOPT_0x11C
; 0000 1E12                         abs_ster4 = 0;
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
; 0000 1E13                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1E14                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x14E
; 0000 1E15                         cykl_sterownik_4 = 0;
; 0000 1E16                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 1E17 
; 0000 1E18                              if(krazek_scierny_cykl_po_okregu_ilosc > 0)
	CALL SUBOPT_0x73
	MOVW R26,R30
	CALL __CPW02
	BRGE _0x4A6
; 0000 1E19                                 {
; 0000 1E1A                                 if(ruch_haos == 0 & tryb_pracy_szczotki_drucianej == 1)  //spr.
	CALL SUBOPT_0x74
	CALL SUBOPT_0xB8
	MOV  R0,R30
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x154
	BREQ _0x4A7
; 0000 1E1B                                     cykl_glowny = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x14A
; 0000 1E1C 
; 0000 1E1D                                 if(ruch_haos == 0 & (tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3))//spr.
_0x4A7:
	CALL SUBOPT_0x74
	CALL SUBOPT_0xB8
	MOV  R1,R30
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x160
	CALL SUBOPT_0x161
	BREQ _0x4A8
; 0000 1E1E                                     cykl_glowny = 88;
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	CALL SUBOPT_0x14A
; 0000 1E1F 
; 0000 1E20                                 if(ruch_haos == 1 & tryb_pracy_szczotki_drucianej == 1) //spr.
_0x4A8:
	CALL SUBOPT_0x74
	CALL SUBOPT_0x75
	MOV  R0,R30
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x154
	BREQ _0x4A9
; 0000 1E21                                     cykl_glowny = 887;
	LDI  R30,LOW(887)
	LDI  R31,HIGH(887)
	CALL SUBOPT_0x14A
; 0000 1E22 
; 0000 1E23                                 if(ruch_haos == 1 & (tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3))// spr.
_0x4A9:
	CALL SUBOPT_0x74
	CALL SUBOPT_0x75
	MOV  R1,R30
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x160
	CALL SUBOPT_0x161
	BREQ _0x4AA
; 0000 1E24                                     cykl_glowny = 888;
	LDI  R30,LOW(888)
	LDI  R31,HIGH(888)
	CALL SUBOPT_0x14A
; 0000 1E25                                 }
_0x4AA:
; 0000 1E26                              else
	RJMP _0x4AB
_0x4A6:
; 0000 1E27                                 {
; 0000 1E28                                 if(tryb_pracy_szczotki_drucianej == 1)  //spr
	CALL SUBOPT_0x6E
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4AC
; 0000 1E29                                     cykl_glowny = 997;
	LDI  R30,LOW(997)
	LDI  R31,HIGH(997)
	CALL SUBOPT_0x14A
; 0000 1E2A                                 if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)  //spr
_0x4AC:
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x71
	BREQ _0x4AD
; 0000 1E2B                                     cykl_glowny = 998;
	LDI  R30,LOW(998)
	LDI  R31,HIGH(998)
	CALL SUBOPT_0x14A
; 0000 1E2C 
; 0000 1E2D                                 }
_0x4AD:
_0x4AB:
; 0000 1E2E 
; 0000 1E2F            break;
	RJMP _0x451
; 0000 1E30 
; 0000 1E31 
; 0000 1E32            case 887:
_0x4A4:
	CPI  R30,LOW(0x377)
	LDI  R26,HIGH(0x377)
	CPC  R31,R26
	BRNE _0x4AE
; 0000 1E33                     przypadek887();
	CALL _przypadek887
; 0000 1E34            break;
	RJMP _0x451
; 0000 1E35 
; 0000 1E36             case 888:
_0x4AE:
	CPI  R30,LOW(0x378)
	LDI  R26,HIGH(0x378)
	CPC  R31,R26
	BRNE _0x4AF
; 0000 1E37                    przypadek888();
	CALL _przypadek888
; 0000 1E38            break;
	RJMP _0x451
; 0000 1E39 
; 0000 1E3A            case 997:
_0x4AF:
	CPI  R30,LOW(0x3E5)
	LDI  R26,HIGH(0x3E5)
	CPC  R31,R26
	BRNE _0x4B0
; 0000 1E3B                    przypadek997();
	CALL _przypadek997
; 0000 1E3C            break;
	RJMP _0x451
; 0000 1E3D 
; 0000 1E3E            case 998:
_0x4B0:
	CPI  R30,LOW(0x3E6)
	LDI  R26,HIGH(0x3E6)
	CPC  R31,R26
	BRNE _0x4B1
; 0000 1E3F                     przypadek998();
	CALL _przypadek998
; 0000 1E40            break;
	RJMP _0x451
; 0000 1E41 
; 0000 1E42             case 8:
_0x4B1:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x4B2
; 0000 1E43                     przypadek8();
	RCALL _przypadek8
; 0000 1E44             break;
	RJMP _0x451
; 0000 1E45 
; 0000 1E46             case 88:
_0x4B2:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x4B3
; 0000 1E47                     przypadek88();
	RCALL _przypadek88
; 0000 1E48             break;
	RJMP _0x451
; 0000 1E49 
; 0000 1E4A 
; 0000 1E4B 
; 0000 1E4C             case 9:                                          //cykl 3 == 5
_0x4B3:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4B4
; 0000 1E4D 
; 0000 1E4E                          if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF1
	BRGE _0x4B5
; 0000 1E4F                         {
; 0000 1E50                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0xF2
; 0000 1E51                         PORTF = PORT_F.byte;
; 0000 1E52                         }
; 0000 1E53 
; 0000 1E54 
; 0000 1E55 
; 0000 1E56                          if(rzad_obrabiany == 1)
_0x4B5:
	CALL SUBOPT_0x8D
	SBIW R26,1
	BRNE _0x4B6
; 0000 1E57                          {
; 0000 1E58                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)    //////
	CALL SUBOPT_0x113
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x15B
	AND  R30,R0
	BREQ _0x4B7
; 0000 1E59                               cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x122
; 0000 1E5A 
; 0000 1E5B 
; 0000 1E5C                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_1 - 2)
_0x4B7:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x162
	CALL SUBOPT_0x163
	BREQ _0x4B8
; 0000 1E5D                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 1E5E 
; 0000 1E5F 
; 0000 1E60                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)       //2 marca 2019 wykomentowuje ////////
_0x4B8:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x162
	CALL SUBOPT_0x164
	BREQ _0x4B9
; 0000 1E61                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xBF
; 0000 1E62 
; 0000 1E63 
; 0000 1E64                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_1 - 2)
_0x4B9:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x162
	CALL SUBOPT_0x165
	BREQ _0x4BA
; 0000 1E65                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 1E66 
; 0000 1E67                           }
_0x4BA:
; 0000 1E68 
; 0000 1E69 
; 0000 1E6A                          if(rzad_obrabiany == 2)
_0x4B6:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x4BB
; 0000 1E6B                          {
; 0000 1E6C                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
	CALL SUBOPT_0x113
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x15C
	AND  R30,R0
	BREQ _0x4BC
; 0000 1E6D                             cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x122
; 0000 1E6E 
; 0000 1E6F                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_2 - 2)
_0x4BC:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x166
	CALL SUBOPT_0x163
	BREQ _0x4BD
; 0000 1E70                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 1E71 
; 0000 1E72                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x4BD:
	CALL SUBOPT_0x113
	CALL SUBOPT_0x166
	CALL SUBOPT_0x164
	BREQ _0x4BE
; 0000 1E73                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xBF
; 0000 1E74 
; 0000 1E75                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_2 - 2)
_0x4BE:
	CALL SUBOPT_0x106
	CALL SUBOPT_0x166
	CALL SUBOPT_0x165
	BREQ _0x4BF
; 0000 1E76                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC1
; 0000 1E77 
; 0000 1E78                            if(rzad_obrabiany == 2)
_0x4BF:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x4C0
; 0000 1E79                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1E7A 
; 0000 1E7B                           }
_0x4C0:
; 0000 1E7C 
; 0000 1E7D 
; 0000 1E7E                           if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 & sek12 > czas_przedmuchu)
_0x4BB:
	CALL SUBOPT_0x113
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x106
	CALL __EQW12
	AND  R0,R30
	LDS  R30,_czas_przedmuchu
	LDS  R31,_czas_przedmuchu+1
	LDS  R26,_sek12
	LDS  R27,_sek12+1
	LDS  R24,_sek12+2
	LDS  R25,_sek12+3
	CALL __CWD1
	CALL __GTD12
	AND  R30,R0
	BREQ _0x4C1
; 0000 1E7F                             {
; 0000 1E80                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1E81                             PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1E82                             //PORTB.6 = 0;  //wylacz przedmuchy
; 0000 1E83                             PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0xF2
; 0000 1E84                             PORTF = PORT_F.byte;
; 0000 1E85                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x10F
; 0000 1E86                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0x119
; 0000 1E87                             cykl_ilosc_zaciskow++;
	LDI  R26,LOW(_cykl_ilosc_zaciskow)
	LDI  R27,HIGH(_cykl_ilosc_zaciskow)
	CALL SUBOPT_0x151
; 0000 1E88                             ruch_zlozony = 2;                       //il_zaciskow_rzad_1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 1E89                             cykl_glowny = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x14A
; 0000 1E8A                             }
; 0000 1E8B 
; 0000 1E8C 
; 0000 1E8D             break;
_0x4C1:
	RJMP _0x451
; 0000 1E8E 
; 0000 1E8F 
; 0000 1E90 
; 0000 1E91             case 10:
_0x4B4:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4C6
; 0000 1E92 
; 0000 1E93                                                //wywali ten warunek jak zadziala
; 0000 1E94                      if(rzad_obrabiany == 1 & cykl_glowny != 0)
	CALL SUBOPT_0x14C
	CALL SUBOPT_0x167
	BRNE PC+3
	JMP _0x4C7
; 0000 1E95                             {
; 0000 1E96                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,96);  //wykonano zaciskow rzad1
	LDS  R30,_cykl_ilosc_zaciskow
	LDS  R31,_cykl_ilosc_zaciskow+1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xA4
	CALL SUBOPT_0xB
; 0000 1E97                             czas_pracy_szczotki_drucianej_h++;
	CALL SUBOPT_0xDE
	CALL SUBOPT_0x168
; 0000 1E98                             if(srednica_wew_korpusu_cyklowa == 34)
	BRNE _0x4C8
; 0000 1E99                                 czas_pracy_krazka_sciernego_h_34 = 0;
	CALL SUBOPT_0xEC
; 0000 1E9A                             if(srednica_wew_korpusu_cyklowa == 36)
_0x4C8:
	CALL SUBOPT_0x169
	SBIW R26,36
	BRNE _0x4C9
; 0000 1E9B                                 czas_pracy_krazka_sciernego_h_36 = 0;
	CALL SUBOPT_0xED
; 0000 1E9C                             if(srednica_wew_korpusu_cyklowa == 38)
_0x4C9:
	CALL SUBOPT_0x169
	SBIW R26,38
	BRNE _0x4CA
; 0000 1E9D                                 czas_pracy_krazka_sciernego_h_38 = 0;
	CALL SUBOPT_0xEE
; 0000 1E9E                             if(srednica_wew_korpusu_cyklowa == 41)
_0x4CA:
	CALL SUBOPT_0x169
	SBIW R26,41
	BRNE _0x4CB
; 0000 1E9F                                 czas_pracy_krazka_sciernego_h_41 = 0;
	CALL SUBOPT_0xEF
; 0000 1EA0                             if(srednica_wew_korpusu_cyklowa == 43)
_0x4CB:
	CALL SUBOPT_0x169
	SBIW R26,43
	BRNE _0x4CC
; 0000 1EA1                                 czas_pracy_krazka_sciernego_h_43 = 0;
	CALL SUBOPT_0xF0
; 0000 1EA2 
; 0000 1EA3 
; 0000 1EA4                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_1 - 1)
_0x4CC:
	CALL SUBOPT_0x16A
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x4CD
; 0000 1EA5                                 {
; 0000 1EA6                                 cykl_glowny = 5;
	CALL SUBOPT_0x155
; 0000 1EA7                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0x149
; 0000 1EA8                                 }
; 0000 1EA9 
; 0000 1EAA                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
_0x4CD:
	CALL SUBOPT_0x16A
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x4CE
; 0000 1EAB                                 {
; 0000 1EAC                                 cykl_glowny = 5;
	CALL SUBOPT_0x155
; 0000 1EAD                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x16B
; 0000 1EAE                                 }
; 0000 1EAF 
; 0000 1EB0                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 == 10)
_0x4CE:
	CALL SUBOPT_0x16C
	CALL __EQW12
	AND  R30,R0
	BREQ _0x4CF
; 0000 1EB1                                 {
; 0000 1EB2                                 cykl_glowny = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x14A
; 0000 1EB3                                 }
; 0000 1EB4 
; 0000 1EB5                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 != 10)  /////zmieniam + 1 20.02
_0x4CF:
	CALL SUBOPT_0x16C
	CALL __NEW12
	AND  R30,R0
	BREQ _0x4D0
; 0000 1EB6                                 {
; 0000 1EB7                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x14A
; 0000 1EB8                                 }
; 0000 1EB9                             }
_0x4D0:
; 0000 1EBA 
; 0000 1EBB 
; 0000 1EBC                              if(rzad_obrabiany == 2)
_0x4C7:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x4D1
; 0000 1EBD                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1EBE 
; 0000 1EBF                             if(rzad_obrabiany == 2 & cykl_glowny != 0)
_0x4D1:
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x167
	BRNE PC+3
	JMP _0x4D2
; 0000 1EC0                             {
; 0000 1EC1                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,16);  //wykonano zaciskow rzad2
	LDS  R30,_cykl_ilosc_zaciskow
	LDS  R31,_cykl_ilosc_zaciskow+1
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xF
; 0000 1EC2 
; 0000 1EC3                             czas_pracy_szczotki_drucianej_h++;
	CALL SUBOPT_0xDE
	CALL SUBOPT_0x168
; 0000 1EC4                             if(srednica_wew_korpusu_cyklowa == 34)
	BRNE _0x4D3
; 0000 1EC5                                 czas_pracy_krazka_sciernego_h_34 = 0;
	CALL SUBOPT_0xEC
; 0000 1EC6                             if(srednica_wew_korpusu_cyklowa == 36)
_0x4D3:
	CALL SUBOPT_0x169
	SBIW R26,36
	BRNE _0x4D4
; 0000 1EC7                                 czas_pracy_krazka_sciernego_h_36 = 0;
	CALL SUBOPT_0xED
; 0000 1EC8                             if(srednica_wew_korpusu_cyklowa == 38)
_0x4D4:
	CALL SUBOPT_0x169
	SBIW R26,38
	BRNE _0x4D5
; 0000 1EC9                                 czas_pracy_krazka_sciernego_h_38 = 0;
	CALL SUBOPT_0xEE
; 0000 1ECA                             if(srednica_wew_korpusu_cyklowa == 41)
_0x4D5:
	CALL SUBOPT_0x169
	SBIW R26,41
	BRNE _0x4D6
; 0000 1ECB                                 czas_pracy_krazka_sciernego_h_41 = 0;
	CALL SUBOPT_0xEF
; 0000 1ECC                             if(srednica_wew_korpusu_cyklowa == 43)
_0x4D6:
	CALL SUBOPT_0x169
	SBIW R26,43
	BRNE _0x4D7
; 0000 1ECD                                 czas_pracy_krazka_sciernego_h_43 = 0;
	CALL SUBOPT_0xF0
; 0000 1ECE 
; 0000 1ECF 
; 0000 1ED0                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_2 - 1)
_0x4D7:
	CALL SUBOPT_0x148
	SBIW R30,1
	CALL SUBOPT_0x15D
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x4D8
; 0000 1ED1                                 {
; 0000 1ED2                                 cykl_glowny = 5;
	CALL SUBOPT_0x155
; 0000 1ED3                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0x149
; 0000 1ED4                                 }
; 0000 1ED5 
; 0000 1ED6                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x4D8:
	CALL SUBOPT_0x148
	SBIW R30,1
	CALL SUBOPT_0x15D
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x4D9
; 0000 1ED7                                 {
; 0000 1ED8                                 cykl_glowny = 5;
	CALL SUBOPT_0x155
; 0000 1ED9                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x16B
; 0000 1EDA                                 }
; 0000 1EDB 
; 0000 1EDC                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 == 10)
_0x4D9:
	CALL SUBOPT_0x16D
	CALL __EQW12
	AND  R30,R0
	BREQ _0x4DA
; 0000 1EDD                                 {
; 0000 1EDE                                 cykl_glowny = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x14A
; 0000 1EDF                                 }
; 0000 1EE0 
; 0000 1EE1 
; 0000 1EE2                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 != 10)   ///////////////////zmieniam + 1 20.02
_0x4DA:
	CALL SUBOPT_0x16D
	CALL __NEW12
	AND  R30,R0
	BREQ _0x4DB
; 0000 1EE3                                 {
; 0000 1EE4                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x14A
; 0000 1EE5                                 }
; 0000 1EE6                             }
_0x4DB:
; 0000 1EE7 
; 0000 1EE8 
; 0000 1EE9 
; 0000 1EEA             break;
_0x4D2:
	RJMP _0x451
; 0000 1EEB 
; 0000 1EEC             case 11:
_0x4C6:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x4DC
; 0000 1EED 
; 0000 1EEE                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x4DD
; 0000 1EEF                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1EF0 
; 0000 1EF1                              //ster 1 ucieka od szafy
; 0000 1EF2                              if(cykl_sterownik_1 < 5)
_0x4DD:
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x4DE
; 0000 1EF3                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0xF8
; 0000 1EF4 
; 0000 1EF5                              if(cykl_sterownik_2 < 5)
_0x4DE:
	CALL SUBOPT_0xC6
	SBIW R26,5
	BRGE _0x4DF
; 0000 1EF6                                     cykl_sterownik_2 = sterownik_2_praca(0x190);     //pod dolek ostatni 10 do przedmuchu rzad 1
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0x15A
; 0000 1EF7 
; 0000 1EF8                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x4DF:
	CALL SUBOPT_0xC9
	BREQ _0x4E0
; 0000 1EF9                                     {
; 0000 1EFA                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x15F
; 0000 1EFB                                     PORTF = PORT_F.byte;
; 0000 1EFC                                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 1EFD                                     sek12 = 0;
	CALL SUBOPT_0x15E
; 0000 1EFE                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1EFF                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x16E
; 0000 1F00                                     cykl_glowny = 13;
; 0000 1F01                                     }
; 0000 1F02             break;
_0x4E0:
	RJMP _0x451
; 0000 1F03 
; 0000 1F04 
; 0000 1F05             case 12:
_0x4DC:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x4E3
; 0000 1F06 
; 0000 1F07                              if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x4E4
; 0000 1F08                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F09 
; 0000 1F0A                                //ster 1 ucieka od szafy
; 0000 1F0B                              if(cykl_sterownik_1 < 5)
_0x4E4:
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x4E5
; 0000 1F0C                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0xF8
; 0000 1F0D 
; 0000 1F0E                             if(cykl_sterownik_2 < 5)
_0x4E5:
	CALL SUBOPT_0xC6
	SBIW R26,5
	BRGE _0x4E6
; 0000 1F0F                                     cykl_sterownik_2 = sterownik_2_praca(0x191);     //pod dolek ostatni 10 do przedmuchu rzad 2
	LDI  R30,LOW(401)
	LDI  R31,HIGH(401)
	CALL SUBOPT_0x15A
; 0000 1F10 
; 0000 1F11                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x4E6:
	CALL SUBOPT_0xC9
	BREQ _0x4E7
; 0000 1F12                                     {
; 0000 1F13                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x15F
; 0000 1F14                                     PORTF = PORT_F.byte;
; 0000 1F15                                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 1F16                                     sek12 = 0;
	CALL SUBOPT_0x15E
; 0000 1F17                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1F18                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x16E
; 0000 1F19                                     cykl_glowny = 13;
; 0000 1F1A                                     }
; 0000 1F1B 
; 0000 1F1C 
; 0000 1F1D             break;
_0x4E7:
	RJMP _0x451
; 0000 1F1E 
; 0000 1F1F             case 13:
_0x4E3:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x4EA
; 0000 1F20 
; 0000 1F21 
; 0000 1F22                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x4EB
; 0000 1F23                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F24 
; 0000 1F25                               if(sek12 > czas_przedmuchu)
_0x4EB:
	CALL SUBOPT_0xF1
	BRGE _0x4EC
; 0000 1F26                                         {
; 0000 1F27                                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0xF2
; 0000 1F28                                         PORTF = PORT_F.byte;
; 0000 1F29                                         PORTE.5 = 0;
	CBI  0x3,5
; 0000 1F2A                                         }
; 0000 1F2B 
; 0000 1F2C 
; 0000 1F2D                              if(cykl_sterownik_2 < 5)
_0x4EC:
	CALL SUBOPT_0xC6
	SBIW R26,5
	BRGE _0x4EF
; 0000 1F2E                                     cykl_sterownik_2 = sterownik_2_praca(0x192);     //okrag
	LDI  R30,LOW(402)
	LDI  R31,HIGH(402)
	CALL SUBOPT_0x15A
; 0000 1F2F                              if(cykl_sterownik_2 == 5)
_0x4EF:
	CALL SUBOPT_0xC6
	SBIW R26,5
	BRNE _0x4F0
; 0000 1F30                                     {
; 0000 1F31 
; 0000 1F32                                      if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF1
	BRGE _0x4F1
; 0000 1F33                                         {
; 0000 1F34                                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0xF2
; 0000 1F35                                         PORTF = PORT_F.byte;
; 0000 1F36                                         PORTE.5 = 0;
	CBI  0x3,5
; 0000 1F37                                         cykl_sterownik_2 = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
; 0000 1F38                                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x14A
; 0000 1F39                                         }
; 0000 1F3A                                     }
_0x4F1:
; 0000 1F3B 
; 0000 1F3C             break;
_0x4F0:
	RJMP _0x451
; 0000 1F3D 
; 0000 1F3E 
; 0000 1F3F 
; 0000 1F40             case 14:
_0x4EA:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x4F4
; 0000 1F41 
; 0000 1F42 
; 0000 1F43                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x4F5
; 0000 1F44                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F45 
; 0000 1F46                     if(cykl_sterownik_1 < 5)
_0x4F5:
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x4F6
; 0000 1F47                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek zeby przedmuchac
	CALL SUBOPT_0xD6
; 0000 1F48                     if(cykl_sterownik_1 == 5)
_0x4F6:
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRNE _0x4F7
; 0000 1F49                         {
; 0000 1F4A                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xFA
; 0000 1F4B                         sek12 = 0;
	CALL SUBOPT_0x15E
; 0000 1F4C                         cykl_glowny = 15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x14A
; 0000 1F4D                         }
; 0000 1F4E 
; 0000 1F4F             break;
_0x4F7:
	RJMP _0x451
; 0000 1F50 
; 0000 1F51 
; 0000 1F52 
; 0000 1F53             case 15:
_0x4F4:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x4F8
; 0000 1F54 
; 0000 1F55                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x4F9
; 0000 1F56                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F57 
; 0000 1F58                     //przedmuch
; 0000 1F59                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
_0x4F9:
	CALL SUBOPT_0x15F
; 0000 1F5A                     PORTF = PORT_F.byte;
; 0000 1F5B 
; 0000 1F5C                     if(start == 1)
	CALL SUBOPT_0xA6
	SBIW R26,1
	BRNE _0x4FA
; 0000 1F5D                         {
; 0000 1F5E                         obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xA8
; 0000 1F5F                         obsluga_nacisniecia_zatrzymaj();
; 0000 1F60                         }
; 0000 1F61 
; 0000 1F62 
; 0000 1F63                     if(sek12 > czas_przedmuchu)
_0x4FA:
	CALL SUBOPT_0xF1
	BRGE _0x4FB
; 0000 1F64                         {
; 0000 1F65                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xF2
; 0000 1F66                         PORTF = PORT_F.byte;
; 0000 1F67                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x14A
; 0000 1F68                         }
; 0000 1F69             break;
_0x4FB:
	RJMP _0x451
; 0000 1F6A 
; 0000 1F6B 
; 0000 1F6C             case 16:
_0x4F8:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4FC
; 0000 1F6D 
; 0000 1F6E                      if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & wykonalem_rzedow == 0)  /////zmieniam + 1 20.02
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	CALL SUBOPT_0x15D
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x16F
	CALL SUBOPT_0xA0
	BREQ _0x4FD
; 0000 1F6F                                 {
; 0000 1F70                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x146
; 0000 1F71                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1F72                                 if(il_zaciskow_rzad_2 > 0)
	CALL SUBOPT_0xD7
	CALL __CPW02
	BRGE _0x500
; 0000 1F73                                     {
; 0000 1F74 
; 0000 1F75                                     rzad_obrabiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
; 0000 1F76                                     wybor_linijek_sterownikow(2);  //rzad 2
	CALL SUBOPT_0xDA
; 0000 1F77                                     cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 1F78                                     }
; 0000 1F79                                 else
	RJMP _0x501
_0x500:
; 0000 1F7A                                     cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x14A
; 0000 1F7B 
; 0000 1F7C                                 wykonalem_rzedow = 1;
_0x501:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 1F7D                                 }
; 0000 1F7E 
; 0000 1F7F                        if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 1)   ///////////////////zmieniam + 1 20.02
_0x4FD:
	CALL SUBOPT_0x148
	CALL SUBOPT_0x15D
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xD8
	CALL SUBOPT_0x16F
	CALL SUBOPT_0x75
	AND  R30,R0
	BREQ _0x502
; 0000 1F80                                 {
; 0000 1F81                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1F82                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x146
; 0000 1F83                                 cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x14A
; 0000 1F84                                 rzad_obrabiany = 1;
	CALL SUBOPT_0x144
; 0000 1F85                                 wykonalem_rzedow = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 1F86                                 }
; 0000 1F87 
; 0000 1F88 
; 0000 1F89                         if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 2)
_0x502:
	CALL SUBOPT_0x170
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xD8
	CALL SUBOPT_0x16F
	CALL SUBOPT_0xA5
	AND  R30,R0
	BREQ _0x505
; 0000 1F8A                                   {
; 0000 1F8B                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x144
; 0000 1F8C                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0x145
; 0000 1F8D                                   PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1F8E                                   //PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1 - tego na razie nie poki nie ma oslon
; 0000 1F8F                                   //PORTB.6 = 0;   ////zielona lampka
; 0000 1F90                                   //wartosc_parametru_panelu(0,0,64);
; 0000 1F91                                   }
; 0000 1F92 
; 0000 1F93                             if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 == 0 & wykonalem_rzedow == 1)
_0x505:
	CALL SUBOPT_0x170
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xB8
	AND  R0,R30
	CALL SUBOPT_0x16F
	CALL SUBOPT_0x75
	AND  R30,R0
	BREQ _0x508
; 0000 1F94                                   {
; 0000 1F95                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x144
; 0000 1F96                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0x145
; 0000 1F97                                   //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
; 0000 1F98                                   }
; 0000 1F99 
; 0000 1F9A 
; 0000 1F9B 
; 0000 1F9C             break;
_0x508:
	RJMP _0x451
; 0000 1F9D 
; 0000 1F9E 
; 0000 1F9F             case 17:
_0x4FC:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x451
; 0000 1FA0 
; 0000 1FA1 
; 0000 1FA2                                  if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC4
	SBIW R26,5
	BRGE _0x50A
; 0000 1FA3                                     cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xC5
; 0000 1FA4                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x50A:
	CALL SUBOPT_0xC6
	SBIW R26,5
	BRGE _0x50B
; 0000 1FA5                                     cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC8
; 0000 1FA6 
; 0000 1FA7                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x50B:
	CALL SUBOPT_0xC9
	BREQ _0x50C
; 0000 1FA8                                         {
; 0000 1FA9                                         PORTB.6 = 0;   ////zielona lampka
	CBI  0x18,6
; 0000 1FAA                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xCA
; 0000 1FAB                                         cykl_sterownik_2 = 0;
; 0000 1FAC                                         cykl_sterownik_3 = 0;
; 0000 1FAD                                         cykl_sterownik_4 = 0;
; 0000 1FAE                                         jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 1FAF                                         PORTB.6 = 0;
	CBI  0x18,6
; 0000 1FB0 
; 0000 1FB1                                         if(odczytalem_w_trakcie_czyszczenia_drugiego_rzedu == 0)
	LDS  R30,_odczytalem_w_trakcie_czyszczenia_drugiego_rzedu
	LDS  R31,_odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1
	SBIW R30,0
	BRNE _0x511
; 0000 1FB2                                         {
; 0000 1FB3                                         macierz_zaciskow[1]=0;
	__POINTW1MN _macierz_zaciskow,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1FB4                                         macierz_zaciskow[2]=0;
	__POINTW1MN _macierz_zaciskow,4
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1FB5                                         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2A
; 0000 1FB6                                         komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",adr1,adr2);
	__POINTW1FN _0x0,2254
	CALL SUBOPT_0x2B
; 0000 1FB7                                         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1FB8                                         komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",adr3,adr4);
	__POINTW1FN _0x0,2254
	CALL SUBOPT_0x86
; 0000 1FB9                                         }
; 0000 1FBA 
; 0000 1FBB                                         odczytalem_w_trakcie_czyszczenia_drugiego_rzedu = 0;
_0x511:
	LDI  R30,LOW(0)
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu,R30
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1,R30
; 0000 1FBC                                         wartosc_parametru_panelu(0,0,64);
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0x80
; 0000 1FBD                                         start = 0;
	CALL SUBOPT_0x9E
; 0000 1FBE                                         cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 1FBF                                         }
; 0000 1FC0 
; 0000 1FC1 
; 0000 1FC2 
; 0000 1FC3 
; 0000 1FC4             break;
_0x50C:
; 0000 1FC5 
; 0000 1FC6 
; 0000 1FC7 
; 0000 1FC8             }//switch
_0x451:
; 0000 1FC9 
; 0000 1FCA 
; 0000 1FCB   }//while
	RJMP _0x44C
_0x44E:
; 0000 1FCC }//while glowny
	RJMP _0x449
; 0000 1FCD 
; 0000 1FCE }//koniec
_0x512:
	RJMP _0x512
;
;
;
;

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG

	.CSEG

	.CSEG
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
_put_usart_G103:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x151
	ADIW R28,3
	RET
__print_G103:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x33
_0x2060016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2060018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x206001C
	CPI  R18,37
	BRNE _0x206001D
	LDI  R17,LOW(1)
	RJMP _0x206001E
_0x206001D:
	CALL SUBOPT_0x171
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x171
	RJMP _0x20600C9
_0x2060020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2060021
	LDI  R16,LOW(1)
	RJMP _0x206001B
_0x2060021:
	CPI  R18,43
	BRNE _0x2060022
	LDI  R20,LOW(43)
	RJMP _0x206001B
_0x2060022:
	CPI  R18,32
	BRNE _0x2060023
	LDI  R20,LOW(32)
	RJMP _0x206001B
_0x2060023:
	RJMP _0x2060024
_0x206001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2060025
_0x2060024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060026
	ORI  R16,LOW(128)
	RJMP _0x206001B
_0x2060026:
	RJMP _0x2060027
_0x2060025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x206001B
_0x2060027:
	CPI  R18,48
	BRLO _0x206002A
	CPI  R18,58
	BRLO _0x206002B
_0x206002A:
	RJMP _0x2060029
_0x206002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x206001B
_0x2060029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x206002F
	CALL SUBOPT_0x172
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x173
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x172
	CALL SUBOPT_0x174
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x172
	CALL SUBOPT_0x174
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2060036
_0x2060035:
	CPI  R30,LOW(0x64)
	BREQ _0x2060039
	CPI  R30,LOW(0x69)
	BRNE _0x206003A
_0x2060039:
	ORI  R16,LOW(4)
	RJMP _0x206003B
_0x206003A:
	CPI  R30,LOW(0x75)
	BRNE _0x206003C
_0x206003B:
	LDI  R30,LOW(_tbl10_G103*2)
	LDI  R31,HIGH(_tbl10_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x206003D
_0x206003C:
	CPI  R30,LOW(0x58)
	BRNE _0x206003F
	ORI  R16,LOW(8)
	RJMP _0x2060040
_0x206003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2060071
_0x2060040:
	LDI  R30,LOW(_tbl16_G103*2)
	LDI  R31,HIGH(_tbl16_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x206003D:
	SBRS R16,2
	RJMP _0x2060042
	CALL SUBOPT_0x172
	CALL SUBOPT_0x175
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2060043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2060043:
	CPI  R20,0
	BREQ _0x2060044
	SUBI R17,-LOW(1)
	RJMP _0x2060045
_0x2060044:
	ANDI R16,LOW(251)
_0x2060045:
	RJMP _0x2060046
_0x2060042:
	CALL SUBOPT_0x172
	CALL SUBOPT_0x175
_0x2060046:
_0x2060036:
	SBRC R16,0
	RJMP _0x2060047
_0x2060048:
	CP   R17,R21
	BRSH _0x206004A
	SBRS R16,7
	RJMP _0x206004B
	SBRS R16,2
	RJMP _0x206004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x206004D
_0x206004C:
	LDI  R18,LOW(48)
_0x206004D:
	RJMP _0x206004E
_0x206004B:
	LDI  R18,LOW(32)
_0x206004E:
	CALL SUBOPT_0x171
	SUBI R21,LOW(1)
	RJMP _0x2060048
_0x206004A:
_0x2060047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x206004F
_0x2060050:
	CPI  R19,0
	BREQ _0x2060052
	SBRS R16,3
	RJMP _0x2060053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2060054
_0x2060053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2060054:
	CALL SUBOPT_0x171
	CPI  R21,0
	BREQ _0x2060055
	SUBI R21,LOW(1)
_0x2060055:
	SUBI R19,LOW(1)
	RJMP _0x2060050
_0x2060052:
	RJMP _0x2060056
_0x206004F:
_0x2060058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x206005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x206005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x206005A
_0x206005C:
	CPI  R18,58
	BRLO _0x206005D
	SBRS R16,3
	RJMP _0x206005E
	SUBI R18,-LOW(7)
	RJMP _0x206005F
_0x206005E:
	SUBI R18,-LOW(39)
_0x206005F:
_0x206005D:
	SBRC R16,4
	RJMP _0x2060061
	CPI  R18,49
	BRSH _0x2060063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2060062
_0x2060063:
	RJMP _0x20600CA
_0x2060062:
	CP   R21,R19
	BRLO _0x2060067
	SBRS R16,0
	RJMP _0x2060068
_0x2060067:
	RJMP _0x2060066
_0x2060068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2060069
	LDI  R18,LOW(48)
_0x20600CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x206006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x173
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x171
	CPI  R21,0
	BREQ _0x206006C
	SUBI R21,LOW(1)
_0x206006C:
_0x2060066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2060059
	RJMP _0x2060058
_0x2060059:
_0x2060056:
	SBRS R16,0
	RJMP _0x206006D
_0x206006E:
	CPI  R21,0
	BREQ _0x2060070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x173
	RJMP _0x206006E
_0x2060070:
_0x206006D:
_0x2060071:
_0x2060030:
_0x20600C9:
	LDI  R17,LOW(0)
_0x206001B:
	RJMP _0x2060016
_0x2060018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	CALL SUBOPT_0x30
	LDI  R30,LOW(_put_usart_G103)
	LDI  R31,HIGH(_put_usart_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G103
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG

	.ESEG
_szczotka_druciana_ilosc_cykli:
	.BYTE 0x2
_krazek_scierny_ilosc_cykli:
	.BYTE 0x2
_krazek_scierny_cykl_po_okregu_ilosc:
	.BYTE 0x2
_czas_pracy_krazka_sciernego_h_34:
	.BYTE 0x2
_czas_pracy_krazka_sciernego_h_36:
	.BYTE 0x2
_czas_pracy_krazka_sciernego_h_38:
	.BYTE 0x2
_czas_pracy_krazka_sciernego_h_41:
	.BYTE 0x2
_czas_pracy_krazka_sciernego_h_43:
	.BYTE 0x2
_czas_pracy_szczotki_drucianej_h:
	.BYTE 0x2
_czas_pracy_krazka_sciernego_stala:
	.BYTE 0x2
_czas_pracy_szczotki_drucianej_stala:
	.BYTE 0x2
_tryb_pracy_szczotki_drucianej:
	.BYTE 0x2

	.DSEG
_PORT_F:
	.BYTE 0x1
_PORTHH:
	.BYTE 0x1
_PORT_CZYTNIK:
	.BYTE 0x1
_PORTJJ:
	.BYTE 0x1
_PORTKK:
	.BYTE 0x1
_PORTLL:
	.BYTE 0x1
_PORTMM:
	.BYTE 0x1
_PORT_STER3:
	.BYTE 0x1
_PORT_STER4:
	.BYTE 0x1
_PORT_STER1:
	.BYTE 0x1
_PORT_STER2:
	.BYTE 0x1
_macierz_zaciskow:
	.BYTE 0x6
_sek1:
	.BYTE 0x4
_sek2:
	.BYTE 0x4
_sek3:
	.BYTE 0x4
_sek4:
	.BYTE 0x4
_sek11:
	.BYTE 0x4
_sek12:
	.BYTE 0x4
_sek13:
	.BYTE 0x4
_sek20:
	.BYTE 0x4
_start:
	.BYTE 0x2
_il_zaciskow_rzad_1:
	.BYTE 0x2
_il_zaciskow_rzad_2:
	.BYTE 0x2
_cykl_sterownik_1:
	.BYTE 0x2
_cykl_sterownik_3:
	.BYTE 0x2
_cykl_sterownik_2:
	.BYTE 0x2
_cykl_sterownik_4:
	.BYTE 0x2
_adr1:
	.BYTE 0x2
_adr2:
	.BYTE 0x2
_adr3:
	.BYTE 0x2
_adr4:
	.BYTE 0x2
_cykl_sterownik_3_wykonalem:
	.BYTE 0x2
_szczotka_druc_cykl:
	.BYTE 0x2
_cykl_glowny:
	.BYTE 0x2
_ruch_zlozony:
	.BYTE 0x2
_krazek_scierny_cykl_po_okregu:
	.BYTE 0x2
_krazek_scierny_cykl:
	.BYTE 0x2
_cykl_ilosc_zaciskow:
	.BYTE 0x2
_wykonalem_komplet_okregow:
	.BYTE 0x2
_abs_ster3:
	.BYTE 0x2
_abs_ster4:
	.BYTE 0x2
_koniec_rzedu_10:
	.BYTE 0x2
_rzad_obrabiany:
	.BYTE 0x2
_jestem_w_trakcie_czyszczenia_calosci:
	.BYTE 0x2
_wykonalem_rzedow:
	.BYTE 0x2
_czekaj_az_puszcze:
	.BYTE 0x2
_czas_przedmuchu:
	.BYTE 0x2
_a:
	.BYTE 0x14
_wymieniono_szczotke_druciana:
	.BYTE 0x2
_wymieniono_krazek_scierny:
	.BYTE 0x2
_predkosc_pion_szczotka:
	.BYTE 0x2
_predkosc_pion_krazek:
	.BYTE 0x2
_wejscie_krazka_sciernego_w_pow_boczna_cylindra:
	.BYTE 0x2
_predkosc_ruchow_po_okregu_krazek_scierny:
	.BYTE 0x2
_test_geometryczny_rzad_1:
	.BYTE 0x2
_test_geometryczny_rzad_2:
	.BYTE 0x2
_czas_pracy_krazka_sciernego:
	.BYTE 0x2
_czas_pracy_szczotki_drucianej:
	.BYTE 0x2
_powrot_przedwczesny_druciak:
	.BYTE 0x2
_powrot_przedwczesny_krazek_scierny:
	.BYTE 0x2
_czas_druciaka_na_gorze:
	.BYTE 0x2
_srednica_krazka_sciernego:
	.BYTE 0x2
_manualny_wybor_zacisku:
	.BYTE 0x2
_ruch_haos:
	.BYTE 0x2
_byla_wloczona_szlifierka_2:
	.BYTE 0x2
_byla_wloczona_szlifierka_1:
	.BYTE 0x2
_byl_wloczony_przedmuch:
	.BYTE 0x2
_zastopowany_czas_przedmuchu:
	.BYTE 0x2
_cisnienie_sprawdzone:
	.BYTE 0x2
_odczytalem_w_trakcie_czyszczenia_drugiego_rzedu:
	.BYTE 0x2
_zaaktualizuj_ilosc_rzad2:
	.BYTE 0x2
_srednica_wew_korpusu:
	.BYTE 0x2
_srednica_wew_korpusu_cyklowa:
	.BYTE 0x2
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x0:
	CALL _i2c_start
	LD   R30,Y
	ST   -Y,R30
	CALL _i2c_write
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	STD  Y+2,R30
	CALL _i2c_stop
	LDD  R30,Y+2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(90)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(165)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	CALL _putchar
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _putchar
	LDD  R30,Y+2
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	CALL _getchar
	CALL _getchar
	JMP  _getchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x6:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	CALL _putchar
	LDI  R30,LOW(130)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_stala)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_stala)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_34)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_34)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_36)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_36)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_38)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_38)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_41)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_41)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_43)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_43)
	CALL __EEPROMRDW
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 181 TIMES, CODE SIZE REDUCTION:357 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 154 TIMES, CODE SIZE REDUCTION:609 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_macierz_zaciskow)
	LDI  R27,HIGH(_macierz_zaciskow)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x12:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x13:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 100 TIMES, CODE SIZE REDUCTION:195 WORDS
SUBOPT_0x14:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x16:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 44 TIMES, CODE SIZE REDUCTION:255 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(_PORTMM)
	LDI  R31,HIGH(_PORTMM)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x19:
	CALL _sprawdz_pin0
	LDI  R26,LOW(0)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1A:
	CALL _sprawdz_pin1
	LDI  R26,LOW(0)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	STS  _il_zaciskow_rzad_1,R30
	STS  _il_zaciskow_rzad_1+1,R31
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	CALL _odczytaj_parametr
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	CALL __EEPROMWRW
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(_krazek_scierny_ilosc_cykli)
	LDI  R27,HIGH(_krazek_scierny_ilosc_cykli)
	CALL __EEPROMWRW
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	CALL _odczytaj_parametr
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu_ilosc)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu_ilosc)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x24:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	STS  _srednica_krazka_sciernego,R30
	STS  _srednica_krazka_sciernego+1,R31
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(_PORTJJ)
	LDI  R31,HIGH(_PORTJJ)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:389 WORDS
SUBOPT_0x2A:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr1
	LDS  R31,_adr1+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr2
	LDS  R31,_adr2+1
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:297 WORDS
SUBOPT_0x2B:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr1
	LDS  R31,_adr1+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr2
	LDS  R31,_adr2+1
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(_PORTHH)
	LDI  R31,HIGH(_PORTHH)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(115)
	LDI  R31,HIGH(115)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2D:
	OR   R30,R0
	STS  _PORT_CZYTNIK,R30
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 145 TIMES, CODE SIZE REDUCTION:285 WORDS
SUBOPT_0x30:
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 69 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_z_czytnika_kodow

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x32:
	ST   X+,R30
	ST   X,R31
	MOVW R30,R16
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 136 TIMES, CODE SIZE REDUCTION:537 WORDS
SUBOPT_0x34:
	STS  _a,R30
	STS  _a+1,R31
	__POINTW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 105 TIMES, CODE SIZE REDUCTION:413 WORDS
SUBOPT_0x35:
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x36:
	LDI  R26,LOW(27)
	LDI  R27,HIGH(27)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x37:
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x38:
	__POINTW1MN _a,8
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 76 TIMES, CODE SIZE REDUCTION:147 WORDS
SUBOPT_0x39:
	__POINTW1MN _a,18
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3A:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x3B:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x3C:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x3D:
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x3E:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3F:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x41:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x42:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x43:
	__POINTW1MN _a,8
	LDI  R26,LOW(22)
	LDI  R27,HIGH(22)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x44:
	LDI  R26,LOW(29)
	LDI  R27,HIGH(29)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x46:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x47:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x48:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x49:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4A:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x4B:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4C:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	LDI  R26,LOW(34)
	LDI  R27,HIGH(34)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4E:
	__POINTW1MN _a,8
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:186 WORDS
SUBOPT_0x4F:
	LDI  R30,LOW(0)
	STS  _a,R30
	STS  _a+1,R30
	__POINTW1MN _a,6
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x50:
	LDI  R26,LOW(27)
	LDI  R27,HIGH(27)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x51:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x52:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x53:
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x54:
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x55:
	LDI  R26,LOW(22)
	LDI  R27,HIGH(22)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x56:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x57:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x58:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x59:
	LDI  R26,LOW(20)
	LDI  R27,HIGH(20)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x5A:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5B:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	LDI  R26,LOW(36)
	LDI  R27,HIGH(36)
	RJMP SUBOPT_0x5A

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x5C:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	RJMP SUBOPT_0x5A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5F:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP SUBOPT_0x5A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	RJMP SUBOPT_0x5A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	__POINTW1MN _a,8
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x62:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x5F

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x63:
	__POINTW1MN _a,8
	LDI  R26,LOW(23)
	LDI  R27,HIGH(23)
	RJMP SUBOPT_0x5A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x64:
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x65:
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x66:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x67:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	RJMP SUBOPT_0x5A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x68:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x5D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6A:
	LDS  R30,_a
	LDS  R31,_a+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6B:
	__GETW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x6C:
	__GETW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x6D:
	ADIW R30,1
	__PUTW1MN _a,12
	__GETW1MN _a,12
	ADIW R30,1
	__PUTW1MN _a,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x6E:
	LDI  R26,LOW(_tryb_pracy_szczotki_drucianej)
	LDI  R27,HIGH(_tryb_pracy_szczotki_drucianej)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6F:
	__GETW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x70:
	__PUTW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x71:
	MOVW R22,R30
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	MOVW R30,R22
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __EQW12
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x72:
	__GETW1MN _a,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x73:
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu_ilosc)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu_ilosc)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x74:
	LDS  R26,_ruch_haos
	LDS  R27,_ruch_haos+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 91 TIMES, CODE SIZE REDUCTION:177 WORDS
SUBOPT_0x75:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x76:
	__GETW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x77:
	LDS  R26,_srednica_krazka_sciernego
	LDS  R27,_srednica_krazka_sciernego+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x78:
	LDS  R26,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R27,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x79:
	MOV  R0,R30
	RCALL SUBOPT_0x77
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7A:
	RCALL SUBOPT_0x78
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7B:
	__PUTW1MN _a,10
	RJMP SUBOPT_0x6C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7C:
	RCALL SUBOPT_0x78
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7D:
	RCALL SUBOPT_0x78
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7E:
	MOV  R0,R30
	RCALL SUBOPT_0x77
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7F:
	__CPD2N 0x3D
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x80:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x81:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _byla_wloczona_szlifierka_1,R30
	STS  _byla_wloczona_szlifierka_1+1,R31
	CBI  0x3,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x82:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _byla_wloczona_szlifierka_2,R30
	STS  _byla_wloczona_szlifierka_2+1,R31
	CBI  0x3,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x83:
	LDS  R30,_PORT_F
	ANDI R30,LOW(0x10)
	CPI  R30,LOW(0x10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x84:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _byl_wloczony_przedmuch,R30
	STS  _byl_wloczony_przedmuch+1,R31
	LDS  R30,_sek12
	LDS  R31,_sek12+1
	STS  _zastopowany_czas_przedmuchu,R30
	STS  _zastopowany_czas_przedmuchu+1,R31
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:291 WORDS
SUBOPT_0x85:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:201 WORDS
SUBOPT_0x86:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x87:
	CBI  0x12,7
	LDS  R26,_byla_wloczona_szlifierka_1
	LDS  R27,_byla_wloczona_szlifierka_1+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x88:
	SBI  0x3,2
	LDI  R30,LOW(0)
	STS  _byla_wloczona_szlifierka_1,R30
	STS  _byla_wloczona_szlifierka_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x89:
	LDS  R26,_byla_wloczona_szlifierka_2
	LDS  R27,_byla_wloczona_szlifierka_2+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8A:
	SBI  0x3,3
	LDI  R30,LOW(0)
	STS  _byla_wloczona_szlifierka_2,R30
	STS  _byla_wloczona_szlifierka_2+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8B:
	LDS  R26,_byl_wloczony_przedmuch
	LDS  R27,_byl_wloczony_przedmuch+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x8C:
	LDS  R30,_PORT_F
	ORI  R30,0x10
	STS  _PORT_F,R30
	STS  98,R30
	LDS  R30,_zastopowany_czas_przedmuchu
	LDS  R31,_zastopowany_czas_przedmuchu+1
	CALL __CWD1
	STS  _sek12,R30
	STS  _sek12+1,R31
	STS  _sek12+2,R22
	STS  _sek12+3,R23
	LDI  R30,LOW(0)
	STS  _byl_wloczony_przedmuch,R30
	STS  _byl_wloczony_przedmuch+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 38 TIMES, CODE SIZE REDUCTION:71 WORDS
SUBOPT_0x8D:
	LDS  R26,_rzad_obrabiany
	LDS  R27,_rzad_obrabiany+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8E:
	MOV  R0,R30
	LDS  R26,_start
	LDS  R27,_start+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x8F:
	RCALL SUBOPT_0x8D
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x90:
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x91:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x92:
	LDI  R26,LOW(_krazek_scierny_ilosc_cykli)
	LDI  R27,HIGH(_krazek_scierny_ilosc_cykli)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x93:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x94:
	CALL _sprawdz_pin0
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x95:
	CALL _sprawdz_pin1
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x96:
	LDI  R30,LOW(_PORTKK)
	LDI  R31,HIGH(_PORTKK)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(117)
	LDI  R31,HIGH(117)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x97:
	CALL _sprawdz_pin3
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x98:
	CALL _sprawdz_pin7
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x99:
	SBI  0x12,7
	CBI  0x18,6
	CBI  0x18,4
	CBI  0x12,2
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9A:
	__POINTW1FN _0x0,1531
	RJMP SUBOPT_0x86

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9B:
	CALL _sprawdz_pin6
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x9C:
	LDI  R30,LOW(_PORTLL)
	LDI  R31,HIGH(_PORTLL)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9D:
	CALL _sprawdz_pin5
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9E:
	LDI  R30,LOW(0)
	STS  _start,R30
	STS  _start+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9F:
	AND  R30,R26
	MOV  R0,R30
	LDS  R26,_czekaj_az_puszcze
	LDS  R27,_czekaj_az_puszcze+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 57 TIMES, CODE SIZE REDUCTION:165 WORDS
SUBOPT_0xA0:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA1:
	LDS  R26,_czekaj_az_puszcze
	LDS  R27,_czekaj_az_puszcze+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x3,6
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA2:
	LDI  R30,LOW(0)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA3:
	LDI  R30,LOW(0)
	STS  _sek11,R30
	STS  _sek11+1,R30
	STS  _sek11+2,R30
	STS  _sek11+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA4:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xA5:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA6:
	LDS  R26,_start
	LDS  R27,_start+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xA7:
	SBI  0x12,7
	CBI  0x3,2
	CBI  0x3,3
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA8:
	CALL _obsluga_otwarcia_klapy_rzad
	JMP  _obsluga_nacisniecia_zatrzymaj

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA9:
	LDI  R30,LOW(0)
	STS  _sek1,R30
	STS  _sek1+1,R30
	STS  _sek1+2,R30
	STS  _sek1+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xAA:
	__CPD2N 0x2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0xAB:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xAC:
	LDI  R30,LOW(0)
	STS  _sek3,R30
	STS  _sek3+1,R30
	STS  _sek3+2,R30
	STS  _sek3+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0xAD:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xAE:
	OR   R30,R0
	STS  _PORT_F,R30
	LDS  R30,_PORT_STER3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:101 WORDS
SUBOPT_0xAF:
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB0:
	LDI  R30,LOW(0)
	STS  _sek2,R30
	STS  _sek2+1,R30
	STS  _sek2+2,R30
	STS  _sek2+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0xB1:
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB2:
	STS  _PORT_F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB3:
	LDI  R30,LOW(0)
	STS  _sek4,R30
	STS  _sek4+1,R30
	STS  _sek4+2,R30
	STS  _sek4+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 50 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0xB4:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0xB5:
	MOVW R26,R28
	ADIW R26,6
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB6:
	LDS  R26,_test_geometryczny_rzad_1
	LDS  R27,_test_geometryczny_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB7:
	LDS  R26,_test_geometryczny_rzad_2
	LDS  R27,_test_geometryczny_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 42 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0xB8:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xB9:
	AND  R0,R30
	LDI  R26,0
	SBIC 0x12,7
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R0,R30
	LDS  R30,_PORT_F
	RCALL SUBOPT_0x1
	ANDI R30,LOW(0x1)
	LDI  R26,LOW(0)
	CALL __EQB12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xBA:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __GTW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xBB:
	__GETW1MN _macierz_zaciskow,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xBC:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wybor_linijek_sterownikow

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xBD:
	SBI  0x18,6
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 73 TIMES, CODE SIZE REDUCTION:141 WORDS
SUBOPT_0xBE:
	LDS  R26,_cykl_sterownik_3
	LDS  R27,_cykl_sterownik_3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0xBF:
	CALL _sterownik_3_praca
	RJMP SUBOPT_0xB1

;OPTIMIZER ADDED SUBROUTINE, CALLED 75 TIMES, CODE SIZE REDUCTION:145 WORDS
SUBOPT_0xC0:
	LDS  R26,_cykl_sterownik_4
	LDS  R27,_cykl_sterownik_4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0xC1:
	CALL _sterownik_4_praca
	RJMP SUBOPT_0xB4

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0xC2:
	RCALL SUBOPT_0xBE
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0xC0
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:253 WORDS
SUBOPT_0xC3:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 59 TIMES, CODE SIZE REDUCTION:113 WORDS
SUBOPT_0xC4:
	LDS  R26,_cykl_sterownik_1
	LDS  R27,_cykl_sterownik_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0xC5:
	CALL _sterownik_1_praca
	RJMP SUBOPT_0xAB

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xC6:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC7:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xC8:
	CALL _sterownik_2_praca
	RJMP SUBOPT_0xAD

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0xC9:
	RCALL SUBOPT_0xC4
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0xC6
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:227 WORDS
SUBOPT_0xCA:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	RJMP SUBOPT_0xC3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCB:
	RCALL SUBOPT_0x6A
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xCC:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xBF

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0xCD:
	__GETWRN 16,17,6
	MOVW R30,R18
	RJMP SUBOPT_0xB5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xCE:
	MOVW R26,R18
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xCF:
	MOVW R26,R18
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD0:
	MOVW R26,R18
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD1:
	MOVW R26,R18
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD2:
	MOVW R26,R18
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD3:
	MOVW R26,R18
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD4:
	MOVW R26,R18
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD5:
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD6:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xC5

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xD7:
	LDS  R26,_il_zaciskow_rzad_2
	LDS  R27,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xD8:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD9:
	__GETW1MN _macierz_zaciskow,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xDA:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wybor_linijek_sterownikow

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xDB:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xDC:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xDD:
	__GETW1MN _a,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xDE:
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xDF:
	CALL __EEPROMRDW
	CP   R0,R30
	CPC  R1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE0:
	LDS  R30,_PORT_F
	ORI  R30,0x40
	RJMP SUBOPT_0xAF

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xE1:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE2:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xE3:
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_stala)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_stala)
	RJMP SUBOPT_0xDF

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xE4:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE5:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xE4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE6:
	LDI  R30,LOW(505)
	LDI  R31,HIGH(505)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE7:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE8:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE9:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBI  0x18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xEA:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xEB:
	LDS  R26,_srednica_wew_korpusu
	LDS  R27,_srednica_wew_korpusu+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xEC:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_34)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_34)
	RJMP SUBOPT_0xEA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xED:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_36)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_36)
	RJMP SUBOPT_0xEA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xEE:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_38)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_38)
	RJMP SUBOPT_0xEA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xEF:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_41)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_41)
	RJMP SUBOPT_0xEA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF0:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_43)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_43)
	RJMP SUBOPT_0xEA

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0xF1:
	LDS  R30,_czas_przedmuchu
	LDS  R31,_czas_przedmuchu+1
	LDS  R26,_sek12
	LDS  R27,_sek12+1
	LDS  R24,_sek12+2
	LDS  R25,_sek12+3
	CALL __CWD1
	CALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xF2:
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	RJMP SUBOPT_0xAF

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xF3:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xF4:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0xB4

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:59 WORDS
SUBOPT_0xF5:
	RCALL SUBOPT_0xC4
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xF6:
	CALL __LTW12
	MOV  R0,R30
	RJMP SUBOPT_0x73

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xF7:
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xA0

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xF8:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xC5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF9:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0xF7

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0xFA:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xFB:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:74 WORDS
SUBOPT_0xFC:
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __LTW12
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xFD:
	__GETW1MN _a,12
	RJMP SUBOPT_0xF8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xFE:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x73

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xFF:
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x100:
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x101:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x102:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xA5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x103:
	__GETW1MN _a,16
	RJMP SUBOPT_0xF8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x104:
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xA5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x105:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 54 TIMES, CODE SIZE REDUCTION:103 WORDS
SUBOPT_0x106:
	RCALL SUBOPT_0xC0
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x107:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster4
	LDS  R27,_abs_ster4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:72 WORDS
SUBOPT_0x108:
	AND  R0,R30
	LDS  R26,_powrot_przedwczesny_druciak
	LDS  R27,_powrot_przedwczesny_druciak+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x109:
	AND  R0,R30
	LDS  R30,_czas_druciaka_na_gorze
	LDS  R31,_czas_druciaka_na_gorze+1
	LDS  R26,_sek13
	LDS  R27,_sek13+1
	LDS  R24,_sek13+2
	LDS  R25,_sek13+3
	CALL __CWD1
	CALL __GTD12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10A:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x10B:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x90

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x10C:
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10D:
	CALL __LTW12
	RJMP SUBOPT_0x108

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x10E:
	LDS  R30,_koniec_rzedu_10
	LDS  R31,_koniec_rzedu_10+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x10F:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x110:
	LDS  R30,_abs_ster4
	LDS  R31,_abs_ster4+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x111:
	LDI  R26,LOW(_szczotka_druc_cykl)
	LDI  R27,HIGH(_szczotka_druc_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x112:
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
	STS  _sek13,R30
	STS  _sek13+1,R30
	STS  _sek13+2,R30
	STS  _sek13+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 44 TIMES, CODE SIZE REDUCTION:83 WORDS
SUBOPT_0x113:
	RCALL SUBOPT_0xBE
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x114:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster3
	LDS  R27,_abs_ster3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x115:
	AND  R0,R30
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0xA0

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x116:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x92

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x117:
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x118:
	CALL __LTW12
	RJMP SUBOPT_0x115

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x119:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11A:
	LDS  R30,_abs_ster3
	LDS  R31,_abs_ster3+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x11B:
	LDI  R26,LOW(_krazek_scierny_cykl)
	LDI  R27,HIGH(_krazek_scierny_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11C:
	LDI  R30,LOW(0)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11D:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xDB

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x11E:
	RCALL SUBOPT_0x117
	CALL __EQW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11F:
	RCALL SUBOPT_0x10C
	CALL __NEW12
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x120:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _powrot_przedwczesny_krazek_scierny,R30
	STS  _powrot_przedwczesny_krazek_scierny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x121:
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x122:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0xCC

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x123:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x121

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x124:
	LDI  R30,LOW(0)
	STS  _powrot_przedwczesny_krazek_scierny,R30
	STS  _powrot_przedwczesny_krazek_scierny+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x125:
	RCALL SUBOPT_0x10C
	CALL __EQW12
	AND  R0,R30
	RJMP SUBOPT_0x92

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x126:
	RCALL SUBOPT_0x117
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x127:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x128:
	LDS  R26,_powrot_przedwczesny_druciak
	LDS  R27,_powrot_przedwczesny_druciak+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x129:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x128

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x12A:
	LDI  R30,LOW(0)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12B:
	RCALL SUBOPT_0x10C
	RJMP SUBOPT_0x116

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x12C:
	CALL __EQW12
	AND  R0,R30
	RJMP SUBOPT_0x106

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x12D:
	CALL __EQW12
	AND  R0,R30
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0xB8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12E:
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x12F:
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
	STS  _krazek_scierny_cykl,R30
	STS  _krazek_scierny_cykl+1,R30
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R30
	CBI  0x3,2
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x130:
	RCALL SUBOPT_0x10C
	RJMP SUBOPT_0x10D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x131:
	RCALL SUBOPT_0x10C
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x132:
	RCALL SUBOPT_0x117
	RJMP SUBOPT_0x118

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x133:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xDB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x134:
	RCALL SUBOPT_0x10C
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x135:
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
	STS  _krazek_scierny_cykl,R30
	STS  _krazek_scierny_cykl+1,R30
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
	CBI  0x3,2
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x136:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x137:
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x138:
	LDI  R30,LOW(0)
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
	LDI  R26,LOW(_krazek_scierny_cykl)
	LDI  R27,HIGH(_krazek_scierny_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP SUBOPT_0x92

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x139:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13A:
	LDI  R30,LOW(0)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x13B:
	AND  R0,R30
	LDS  R30,_czas_druciaka_na_gorze
	LDS  R31,_czas_druciaka_na_gorze+1
	LDS  R26,_sek13
	LDS  R27,_sek13+1
	LDS  R24,_sek13+2
	LDS  R25,_sek13+3
	CALL __CWD1
	CALL __GTD12
	AND  R0,R30
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0xA0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x13C:
	AND  R0,R30
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0xA0

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x13D:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0xB8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x13E:
	RCALL SUBOPT_0x10C
	CALL __EQW12
	AND  R30,R0
	MOV  R1,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	MOV  R0,R30
	RJMP SUBOPT_0x92

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13F:
	RCALL SUBOPT_0x117
	CALL __NEW12
	OR   R30,R0
	AND  R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x140:
	CALL __EQW12
	RJMP SUBOPT_0x108

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x141:
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	MOV  R22,R30
	MOV  R0,R30
	RJMP SUBOPT_0x90

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x142:
	MOV  R1,R30
	MOV  R0,R22
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x143:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x144:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x145:
	LDI  R30,LOW(0)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x146:
	LDI  R30,LOW(0)
	STS  _cykl_ilosc_zaciskow,R30
	STS  _cykl_ilosc_zaciskow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x147:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x148:
	LDS  R30,_il_zaciskow_rzad_2
	LDS  R31,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x149:
	LDI  R30,LOW(0)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x14A:
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x14B:
	RCALL SUBOPT_0xC6
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14C:
	RCALL SUBOPT_0x8D
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14D:
	MOV  R0,R30
	RCALL SUBOPT_0xC6
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14E:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	RJMP SUBOPT_0x10F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14F:
	LDI  R30,LOW(0)
	STS  _sek13,R30
	STS  _sek13+1,R30
	STS  _sek13+2,R30
	STS  _sek13+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x150:
	RCALL SUBOPT_0x10C
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x151:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x152:
	MOVW R22,R30
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	MOVW R30,R22
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __EQW12
	OR   R0,R30
	RJMP SUBOPT_0x90

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x153:
	RCALL SUBOPT_0x10C
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x154:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x155:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0x14A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x156:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RJMP SUBOPT_0xB8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x157:
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x158:
	CALL __LTW12
	RJMP SUBOPT_0x157

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x159:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15A:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xC8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15B:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15C:
	RCALL SUBOPT_0x148
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x15D:
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x15E:
	LDI  R30,LOW(0)
	STS  _sek12,R30
	STS  _sek12+1,R30
	STS  _sek12+2,R30
	STS  _sek12+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15F:
	LDS  R30,_PORT_F
	ORI  R30,0x10
	RJMP SUBOPT_0xAF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x160:
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x6E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x161:
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __EQW12
	OR   R30,R0
	AND  R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x162:
	CALL __LTW12
	MOV  R0,R30
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x163:
	SBIW R30,2
	RCALL SUBOPT_0x15D
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x164:
	SBIW R30,1
	RCALL SUBOPT_0x15D
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x165:
	SBIW R30,2
	RCALL SUBOPT_0x15D
	CALL __GEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x166:
	CALL __LTW12
	MOV  R0,R30
	RJMP SUBOPT_0x148

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x167:
	MOV  R0,R30
	LDS  R26,_cykl_glowny
	LDS  R27,_cykl_glowny+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x168:
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
	LDS  R26,_srednica_wew_korpusu_cyklowa
	LDS  R27,_srednica_wew_korpusu_cyklowa+1
	SBIW R26,34
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x169:
	LDS  R26,_srednica_wew_korpusu_cyklowa
	LDS  R27,_srednica_wew_korpusu_cyklowa+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16A:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	RJMP SUBOPT_0x15D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x16C:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RCALL SUBOPT_0x15D
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16D:
	RCALL SUBOPT_0x148
	RCALL SUBOPT_0x15D
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0xD7
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16E:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RJMP SUBOPT_0x14A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16F:
	LDS  R26,_wykonalem_rzedow
	LDS  R27,_wykonalem_rzedow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x170:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	RJMP SUBOPT_0x147

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x171:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x172:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x173:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x174:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	JMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x175:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,27
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,53
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__NEW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRNE __NEW12T
	CLR  R30
__NEW12T:
	RET

__GEW12:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRGE __GEW12T
	CLR  R30
__GEW12T:
	RET

__LTW12:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRLT __LTW12T
	CLR  R30
__LTW12T:
	RET

__GTW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRLT __GTW12T
	CLR  R30
__GTW12T:
	RET

__GTD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	LDI  R30,1
	BRLT __GTD12T
	CLR  R30
__GTD12T:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARL:
	CLR  R27
__PUTPAR:
	ADD  R30,R26
	ADC  R31,R27
__PUTPAR0:
	LD   R0,-Z
	ST   -Y,R0
	SBIW R26,1
	BRNE __PUTPAR0
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
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
