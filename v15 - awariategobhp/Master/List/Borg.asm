
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
	.DB  0x79,0x0,0x4F,0x73,0x20,0x7A,0x61,0x63
	.DB  0x69,0x73,0x6B,0x75,0x20,0x62,0x6C,0x69
	.DB  0x7A,0x65,0x6A,0x20,0x73,0x7A,0x61,0x66
	.DB  0x79,0x0,0x4F,0x73,0x20,0x7A,0x61,0x63
	.DB  0x69,0x73,0x6B,0x75,0x20,0x64,0x61,0x6C
	.DB  0x65,0x6A,0x20,0x6F,0x64,0x20,0x73,0x7A
	.DB  0x61,0x66,0x79,0x0,0x43,0x69,0x73,0x6E
	.DB  0x69,0x65,0x6E,0x69,0x65,0x20,0x7A,0x61
	.DB  0x20,0x6D,0x61,0x6C,0x65,0x20,0x2D,0x20
	.DB  0x6D,0x6E,0x69,0x65,0x6A,0x73,0x7A,0x65
	.DB  0x20,0x6E,0x69,0x7A,0x20,0x36,0x20,0x62
	.DB  0x61,0x72,0x0,0x38,0x36,0x2D,0x30,0x31
	.DB  0x37,0x30,0x0,0x38,0x36,0x2D,0x31,0x30
	.DB  0x34,0x33,0x0,0x38,0x36,0x2D,0x31,0x36
	.DB  0x37,0x35,0x0,0x38,0x36,0x2D,0x32,0x30
	.DB  0x39,0x38,0x0,0x38,0x37,0x2D,0x30,0x31
	.DB  0x37,0x30,0x0,0x38,0x37,0x2D,0x31,0x30
	.DB  0x34,0x33,0x0,0x38,0x37,0x2D,0x31,0x36
	.DB  0x37,0x35,0x0,0x38,0x37,0x2D,0x32,0x30
	.DB  0x39,0x38,0x0,0x38,0x36,0x2D,0x30,0x31
	.DB  0x39,0x32,0x0,0x38,0x36,0x2D,0x31,0x30
	.DB  0x35,0x34,0x0,0x38,0x36,0x2D,0x31,0x36
	.DB  0x37,0x36,0x0,0x38,0x36,0x2D,0x32,0x31
	.DB  0x33,0x32,0x0,0x38,0x37,0x2D,0x30,0x31
	.DB  0x39,0x32,0x0,0x38,0x37,0x2D,0x31,0x30
	.DB  0x35,0x34,0x0,0x38,0x37,0x2D,0x31,0x36
	.DB  0x37,0x36,0x0,0x38,0x37,0x2D,0x32,0x31
	.DB  0x33,0x32,0x0,0x38,0x36,0x2D,0x30,0x31
	.DB  0x39,0x33,0x0,0x38,0x36,0x2D,0x31,0x32
	.DB  0x31,0x36,0x0,0x38,0x36,0x2D,0x31,0x38
	.DB  0x33,0x32,0x0,0x38,0x36,0x2D,0x32,0x31
	.DB  0x37,0x34,0x0,0x38,0x37,0x2D,0x30,0x31
	.DB  0x39,0x33,0x0,0x38,0x37,0x2D,0x31,0x32
	.DB  0x31,0x36,0x0,0x38,0x37,0x2D,0x31,0x38
	.DB  0x33,0x32,0x0,0x38,0x37,0x2D,0x32,0x31
	.DB  0x37,0x34,0x0,0x38,0x36,0x2D,0x30,0x31
	.DB  0x39,0x34,0x0,0x38,0x36,0x2D,0x31,0x33
	.DB  0x34,0x31,0x0,0x38,0x36,0x2D,0x31,0x38
	.DB  0x33,0x33,0x0,0x38,0x36,0x2D,0x32,0x31
	.DB  0x38,0x30,0x0,0x38,0x37,0x2D,0x30,0x31
	.DB  0x39,0x34,0x0,0x38,0x37,0x2D,0x31,0x33
	.DB  0x34,0x31,0x0,0x38,0x37,0x2D,0x31,0x38
	.DB  0x33,0x33,0x0,0x38,0x37,0x2D,0x32,0x31
	.DB  0x38,0x30,0x0,0x38,0x36,0x2D,0x30,0x36
	.DB  0x36,0x33,0x0,0x38,0x36,0x2D,0x31,0x33
	.DB  0x34,0x39,0x0,0x38,0x36,0x2D,0x31,0x38
	.DB  0x33,0x34,0x0,0x38,0x36,0x2D,0x32,0x32
	.DB  0x30,0x34,0x0,0x38,0x37,0x2D,0x30,0x36
	.DB  0x36,0x33,0x0,0x38,0x37,0x2D,0x31,0x33
	.DB  0x34,0x39,0x0,0x38,0x37,0x2D,0x31,0x38
	.DB  0x33,0x34,0x0,0x38,0x37,0x2D,0x32,0x32
	.DB  0x30,0x34,0x0,0x38,0x36,0x2D,0x30,0x37
	.DB  0x36,0x38,0x0,0x38,0x36,0x2D,0x31,0x33
	.DB  0x35,0x37,0x0,0x38,0x36,0x2D,0x31,0x38
	.DB  0x34,0x38,0x0,0x38,0x36,0x2D,0x32,0x32
	.DB  0x31,0x32,0x0,0x38,0x37,0x2D,0x30,0x37
	.DB  0x36,0x38,0x0,0x38,0x37,0x2D,0x31,0x33
	.DB  0x35,0x37,0x0,0x38,0x37,0x2D,0x31,0x38
	.DB  0x34,0x38,0x0,0x38,0x37,0x2D,0x32,0x32
	.DB  0x31,0x32,0x0,0x38,0x36,0x2D,0x30,0x38
	.DB  0x30,0x30,0x0,0x38,0x36,0x2D,0x31,0x33
	.DB  0x36,0x33,0x0,0x38,0x36,0x2D,0x31,0x39
	.DB  0x30,0x34,0x0,0x38,0x36,0x2D,0x32,0x32
	.DB  0x34,0x31,0x0,0x38,0x37,0x2D,0x30,0x38
	.DB  0x30,0x30,0x0,0x38,0x37,0x2D,0x31,0x33
	.DB  0x36,0x33,0x0,0x38,0x37,0x2D,0x31,0x39
	.DB  0x30,0x34,0x0,0x38,0x37,0x2D,0x32,0x32
	.DB  0x34,0x31,0x0,0x38,0x36,0x2D,0x30,0x38
	.DB  0x31,0x31,0x0,0x38,0x36,0x2D,0x31,0x35
	.DB  0x32,0x33,0x0,0x38,0x36,0x2D,0x31,0x39
	.DB  0x32,0x39,0x0,0x38,0x36,0x2D,0x32,0x32
	.DB  0x36,0x31,0x0,0x38,0x37,0x2D,0x30,0x38
	.DB  0x31,0x31,0x0,0x38,0x37,0x2D,0x31,0x35
	.DB  0x32,0x33,0x0,0x38,0x37,0x2D,0x31,0x39
	.DB  0x32,0x39,0x0,0x38,0x37,0x2D,0x32,0x32
	.DB  0x36,0x31,0x0,0x38,0x36,0x2D,0x30,0x38
	.DB  0x31,0x34,0x0,0x38,0x36,0x2D,0x31,0x35
	.DB  0x33,0x30,0x0,0x38,0x36,0x2D,0x31,0x39
	.DB  0x33,0x36,0x0,0x38,0x36,0x2D,0x32,0x32
	.DB  0x38,0x35,0x0,0x38,0x37,0x2D,0x30,0x38
	.DB  0x31,0x34,0x0,0x38,0x37,0x2D,0x31,0x35
	.DB  0x33,0x30,0x0,0x38,0x37,0x2D,0x31,0x39
	.DB  0x33,0x36,0x0,0x38,0x37,0x2D,0x32,0x32
	.DB  0x38,0x35,0x0,0x38,0x36,0x2D,0x30,0x38
	.DB  0x31,0x35,0x0,0x38,0x36,0x2D,0x31,0x35
	.DB  0x35,0x31,0x0,0x38,0x36,0x2D,0x31,0x39
	.DB  0x34,0x31,0x0,0x38,0x36,0x2D,0x32,0x32
	.DB  0x38,0x36,0x0,0x38,0x37,0x2D,0x30,0x38
	.DB  0x31,0x35,0x0,0x38,0x37,0x2D,0x31,0x35
	.DB  0x35,0x31,0x0,0x38,0x37,0x2D,0x31,0x39
	.DB  0x34,0x31,0x0,0x38,0x37,0x2D,0x32,0x32
	.DB  0x38,0x36,0x0,0x38,0x36,0x2D,0x30,0x38
	.DB  0x31,0x36,0x0,0x38,0x36,0x2D,0x31,0x35
	.DB  0x35,0x32,0x0,0x38,0x36,0x2D,0x32,0x30
	.DB  0x30,0x37,0x0,0x38,0x36,0x2D,0x32,0x32
	.DB  0x39,0x32,0x0,0x38,0x37,0x2D,0x30,0x38
	.DB  0x31,0x36,0x0,0x38,0x37,0x2D,0x31,0x35
	.DB  0x35,0x32,0x0,0x38,0x37,0x2D,0x32,0x30
	.DB  0x30,0x37,0x0,0x38,0x37,0x2D,0x32,0x32
	.DB  0x39,0x32,0x0,0x38,0x36,0x2D,0x30,0x38
	.DB  0x31,0x37,0x0,0x38,0x36,0x2D,0x31,0x36
	.DB  0x30,0x32,0x0,0x38,0x36,0x2D,0x32,0x30
	.DB  0x31,0x37,0x0,0x38,0x36,0x2D,0x32,0x33
	.DB  0x38,0x34,0x0,0x38,0x37,0x2D,0x30,0x38
	.DB  0x31,0x37,0x0,0x38,0x37,0x2D,0x31,0x36
	.DB  0x30,0x32,0x0,0x38,0x37,0x2D,0x32,0x30
	.DB  0x31,0x37,0x0,0x38,0x37,0x2D,0x32,0x33
	.DB  0x38,0x34,0x0,0x38,0x36,0x2D,0x30,0x38
	.DB  0x34,0x37,0x0,0x38,0x36,0x2D,0x31,0x36
	.DB  0x32,0x30,0x0,0x38,0x36,0x2D,0x32,0x30
	.DB  0x31,0x39,0x0,0x38,0x36,0x2D,0x32,0x33
	.DB  0x38,0x35,0x0,0x38,0x37,0x2D,0x30,0x38
	.DB  0x34,0x37,0x0,0x38,0x37,0x2D,0x31,0x36
	.DB  0x32,0x30,0x0,0x38,0x37,0x2D,0x32,0x30
	.DB  0x31,0x39,0x0,0x38,0x37,0x2D,0x32,0x33
	.DB  0x38,0x35,0x0,0x38,0x36,0x2D,0x30,0x38
	.DB  0x35,0x34,0x0,0x38,0x36,0x2D,0x31,0x36
	.DB  0x32,0x32,0x0,0x38,0x36,0x2D,0x32,0x30
	.DB  0x32,0x38,0x0,0x38,0x36,0x2D,0x32,0x34
	.DB  0x33,0x37,0x0,0x38,0x37,0x2D,0x30,0x38
	.DB  0x35,0x34,0x0,0x38,0x37,0x2D,0x31,0x36
	.DB  0x32,0x32,0x0,0x38,0x37,0x2D,0x32,0x30
	.DB  0x32,0x38,0x0,0x38,0x37,0x2D,0x32,0x34
	.DB  0x33,0x37,0x0,0x38,0x36,0x2D,0x30,0x38
	.DB  0x36,0x32,0x0,0x38,0x36,0x2D,0x31,0x36
	.DB  0x32,0x35,0x0,0x38,0x36,0x2D,0x32,0x30
	.DB  0x35,0x32,0x0,0x38,0x36,0x2D,0x32,0x34
	.DB  0x39,0x32,0x0,0x38,0x37,0x2D,0x30,0x38
	.DB  0x36,0x32,0x0,0x38,0x37,0x2D,0x31,0x36
	.DB  0x32,0x35,0x0,0x38,0x37,0x2D,0x32,0x30
	.DB  0x35,0x32,0x0,0x38,0x37,0x2D,0x32,0x34
	.DB  0x39,0x32,0x0,0x38,0x36,0x2D,0x30,0x39
	.DB  0x33,0x35,0x0,0x38,0x36,0x2D,0x31,0x36
	.DB  0x34,0x38,0x0,0x38,0x36,0x2D,0x32,0x30
	.DB  0x38,0x32,0x0,0x38,0x36,0x2D,0x32,0x35
	.DB  0x30,0x30,0x0,0x38,0x37,0x2D,0x30,0x39
	.DB  0x33,0x35,0x0,0x38,0x37,0x2D,0x31,0x36
	.DB  0x34,0x38,0x0,0x38,0x37,0x2D,0x32,0x30
	.DB  0x38,0x32,0x0,0x38,0x37,0x2D,0x32,0x35
	.DB  0x30,0x30,0x0,0x38,0x36,0x2D,0x31,0x30
	.DB  0x31,0x39,0x0,0x38,0x36,0x2D,0x31,0x36
	.DB  0x34,0x39,0x0,0x38,0x36,0x2D,0x32,0x30
	.DB  0x38,0x33,0x0,0x38,0x36,0x2D,0x32,0x35
	.DB  0x38,0x35,0x0,0x38,0x37,0x2D,0x31,0x30
	.DB  0x31,0x39,0x0,0x38,0x37,0x2D,0x31,0x36
	.DB  0x34,0x39,0x0,0x38,0x37,0x2D,0x32,0x30
	.DB  0x38,0x33,0x0,0x38,0x37,0x2D,0x32,0x36
	.DB  0x32,0x34,0x0,0x38,0x36,0x2D,0x31,0x30
	.DB  0x32,0x37,0x0,0x38,0x36,0x2D,0x31,0x36
	.DB  0x36,0x39,0x0,0x38,0x36,0x2D,0x32,0x30
	.DB  0x38,0x37,0x0,0x38,0x36,0x2D,0x32,0x36
	.DB  0x32,0x34,0x0,0x38,0x37,0x2D,0x31,0x30
	.DB  0x32,0x37,0x0,0x38,0x37,0x2D,0x31,0x36
	.DB  0x36,0x39,0x0,0x38,0x37,0x2D,0x32,0x30
	.DB  0x38,0x37,0x0,0x38,0x37,0x2D,0x32,0x35
	.DB  0x38,0x35,0x0,0x4E,0x69,0x65,0x20,0x77
	.DB  0x63,0x7A,0x79,0x74,0x61,0x6E,0x6F,0x20
	.DB  0x7A,0x61,0x63,0x69,0x73,0x6B,0x75,0x0
	.DB  0x5A,0x61,0x74,0x72,0x7A,0x79,0x6D,0x61
	.DB  0x6E,0x6F,0x20,0x2D,0x20,0x6E,0x61,0x63
	.DB  0x69,0x73,0x6E,0x69,0x6A,0x20,0x53,0x54
	.DB  0x41,0x52,0x54,0x20,0x61,0x62,0x79,0x20
	.DB  0x77,0x7A,0x6E,0x6F,0x77,0x69,0x63,0x0
	.DB  0x5A,0x61,0x6D,0x6B,0x6E,0x69,0x6A,0x20
	.DB  0x6F,0x73,0x6C,0x6F,0x6E,0x79,0x20,0x67
	.DB  0x6F,0x72,0x6E,0x65,0x20,0x69,0x20,0x6E
	.DB  0x61,0x63,0x69,0x73,0x6E,0x69,0x6A,0x20
	.DB  0x53,0x54,0x41,0x52,0x54,0x0,0x4E,0x61
	.DB  0x63,0x69,0x73,0x6E,0x69,0x6A,0x20,0x53
	.DB  0x54,0x41,0x52,0x54,0x20,0x61,0x62,0x79
	.DB  0x20,0x77,0x79,0x70,0x6F,0x7A,0x79,0x63
	.DB  0x6A,0x6F,0x6E,0x6F,0x77,0x61,0x63,0x20
	.DB  0x6E,0x61,0x70,0x65,0x64,0x79,0x0,0x5A
	.DB  0x61,0x6D,0x6B,0x6E,0x69,0x6A,0x20,0x6F
	.DB  0x73,0x6C,0x6F,0x6E,0x79,0x20,0x67,0x6F
	.DB  0x72,0x6E,0x65,0x0,0x4F,0x74,0x77,0x61
	.DB  0x72,0x63,0x69,0x65,0x20,0x6F,0x73,0x6C
	.DB  0x6F,0x6E,0x20,0x77,0x20,0x74,0x72,0x61
	.DB  0x6B,0x63,0x69,0x65,0x20,0x70,0x6F,0x7A
	.DB  0x79,0x63,0x6A,0x6F,0x6E,0x6F,0x77,0x61
	.DB  0x6E,0x69,0x61,0x0,0x57,0x79,0x6C,0x61
	.DB  0x63,0x7A,0x20,0x69,0x20,0x77,0x6C,0x61
	.DB  0x63,0x7A,0x20,0x6D,0x61,0x73,0x7A,0x79
	.DB  0x6E,0x65,0x0,0x5A,0x61,0x74,0x72,0x7A
	.DB  0x79,0x6D,0x61,0x6E,0x69,0x65,0x20,0x77
	.DB  0x20,0x74,0x72,0x61,0x6B,0x63,0x69,0x65
	.DB  0x20,0x70,0x6F,0x7A,0x79,0x63,0x6A,0x6F
	.DB  0x6E,0x6F,0x77,0x61,0x6E,0x69,0x61,0x0
	.DB  0x50,0x6F,0x7A,0x79,0x63,0x6A,0x6F,0x6E
	.DB  0x75,0x6A,0x65,0x20,0x75,0x6B,0x6C,0x61
	.DB  0x64,0x79,0x20,0x6C,0x69,0x6E,0x69,0x6F
	.DB  0x77,0x65,0x20,0x58,0x59,0x5A,0x0,0x53
	.DB  0x74,0x65,0x72,0x6F,0x77,0x6E,0x69,0x6B
	.DB  0x20,0x33,0x20,0x2D,0x20,0x77,0x79,0x70
	.DB  0x6F,0x7A,0x79,0x63,0x6A,0x6F,0x6E,0x6F
	.DB  0x77,0x61,0x6C,0x65,0x6D,0x0,0x53,0x74
	.DB  0x65,0x72,0x6F,0x77,0x6E,0x69,0x6B,0x20
	.DB  0x34,0x20,0x2D,0x20,0x77,0x79,0x70,0x6F
	.DB  0x7A,0x79,0x63,0x6A,0x6F,0x6E,0x6F,0x77
	.DB  0x61,0x6C,0x65,0x6D,0x0,0x41,0x6C,0x61
	.DB  0x72,0x6D,0x20,0x53,0x74,0x65,0x72,0x6F
	.DB  0x77,0x6E,0x69,0x6B,0x20,0x34,0x0,0x41
	.DB  0x6C,0x61,0x72,0x6D,0x20,0x53,0x74,0x65
	.DB  0x72,0x6F,0x77,0x6E,0x69,0x6B,0x20,0x33
	.DB  0x0,0x53,0x74,0x65,0x72,0x6F,0x77,0x6E
	.DB  0x69,0x6B,0x20,0x31,0x20,0x2D,0x20,0x77
	.DB  0x79,0x70,0x6F,0x7A,0x79,0x63,0x6A,0x6F
	.DB  0x6E,0x6F,0x77,0x61,0x6C,0x65,0x6D,0x0
	.DB  0x53,0x74,0x65,0x72,0x6F,0x77,0x6E,0x69
	.DB  0x6B,0x20,0x32,0x20,0x2D,0x20,0x77,0x79
	.DB  0x70,0x6F,0x7A,0x79,0x63,0x6A,0x6F,0x6E
	.DB  0x6F,0x77,0x61,0x6C,0x65,0x6D,0x0,0x41
	.DB  0x6C,0x61,0x72,0x6D,0x20,0x53,0x74,0x65
	.DB  0x72,0x6F,0x77,0x6E,0x69,0x6B,0x20,0x31
	.DB  0x0,0x41,0x6C,0x61,0x72,0x6D,0x20,0x53
	.DB  0x74,0x65,0x72,0x6F,0x77,0x6E,0x69,0x6B
	.DB  0x20,0x32,0x0,0x57,0x79,0x70,0x6F,0x7A
	.DB  0x79,0x63,0x6A,0x6F,0x6E,0x6F,0x77,0x61
	.DB  0x6E,0x6F,0x20,0x75,0x6B,0x6C,0x61,0x64
	.DB  0x79,0x20,0x6C,0x69,0x6E,0x69,0x6F,0x77
	.DB  0x65,0x20,0x58,0x59,0x5A,0x0,0x57,0x79
	.DB  0x6D,0x69,0x65,0x6E,0x20,0x73,0x7A,0x63
	.DB  0x7A,0x6F,0x74,0x6B,0x65,0x20,0x70,0x65
	.DB  0x64,0x7A,0x65,0x6C,0x6B,0x6F,0x77,0x61
	.DB  0x0,0x57,0x79,0x6D,0x69,0x65,0x6E,0x20
	.DB  0x6B,0x72,0x61,0x7A,0x65,0x6B,0x20,0x73
	.DB  0x63,0x69,0x65,0x72,0x6E,0x79,0x0,0x57
	.DB  0x63,0x7A,0x79,0x74,0x61,0x6A,0x20,0x7A
	.DB  0x61,0x63,0x69,0x73,0x6B,0x20,0x74,0x65
	.DB  0x6E,0x20,0x73,0x61,0x6D,0x20,0x6C,0x75
	.DB  0x62,0x20,0x6E,0x6F,0x77,0x79,0x0
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
;eeprom int czas_pracy_krazka_sciernego_h,czas_pracy_szczotki_drucianej_h;
;eeprom int czas_pracy_krazka_sciernego_stala,czas_pracy_szczotki_drucianej_stala;
;
;#pragma warn+
;
;
;// Get a character from the USART1 Receiver
;#pragma used+
;char getchar1(void)
; 0000 002E {

	.CSEG
; 0000 002F unsigned char status;
; 0000 0030 char data;
; 0000 0031 while (1)
;	status -> R17
;	data -> R16
; 0000 0032       {
; 0000 0033       while (((status=UCSR1A) & RX_COMPLETE)==0);
; 0000 0034       data=UDR1;
; 0000 0035       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
; 0000 0036          return data;
; 0000 0037       }
; 0000 0038 }
;#pragma used-
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 003E {
; 0000 003F while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
; 0000 0040 UDR1=c;
; 0000 0041 }
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
; 0000 0052 #endasm
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
;int byl_wloczony_przedmuch,zastopowany_czas_przedmuchu;
;
;char sprawdz_pin0(BB PORT, int numer_pcf)
; 0000 00BB {
_sprawdz_pin0:
; 0000 00BC i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00BD i2c_write(numer_pcf);
; 0000 00BE PORT.byte = i2c_read(0);
; 0000 00BF i2c_stop();
; 0000 00C0 
; 0000 00C1 
; 0000 00C2 return PORT.bits.b0;
	RJMP _0x20A0004
; 0000 00C3 }
;
;char sprawdz_pin1(BB PORT, int numer_pcf)
; 0000 00C6 {
_sprawdz_pin1:
; 0000 00C7 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00C8 i2c_write(numer_pcf);
; 0000 00C9 PORT.byte = i2c_read(0);
; 0000 00CA i2c_stop();
; 0000 00CB 
; 0000 00CC 
; 0000 00CD return PORT.bits.b1;
	LSR  R30
	RJMP _0x20A0004
; 0000 00CE }
;
;
;char sprawdz_pin2(BB PORT, int numer_pcf)
; 0000 00D2 {
_sprawdz_pin2:
; 0000 00D3 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00D4 i2c_write(numer_pcf);
; 0000 00D5 PORT.byte = i2c_read(0);
; 0000 00D6 i2c_stop();
; 0000 00D7 
; 0000 00D8 
; 0000 00D9 return PORT.bits.b2;
	LSR  R30
	LSR  R30
	RJMP _0x20A0004
; 0000 00DA }
;
;char sprawdz_pin3(BB PORT, int numer_pcf)
; 0000 00DD {
_sprawdz_pin3:
; 0000 00DE i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00DF i2c_write(numer_pcf);
; 0000 00E0 PORT.byte = i2c_read(0);
; 0000 00E1 i2c_stop();
; 0000 00E2 
; 0000 00E3 
; 0000 00E4 return PORT.bits.b3;
	LSR  R30
	LSR  R30
	LSR  R30
	RJMP _0x20A0004
; 0000 00E5 }
;
;char sprawdz_pin4(BB PORT, int numer_pcf)
; 0000 00E8 {
_sprawdz_pin4:
; 0000 00E9 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00EA i2c_write(numer_pcf);
; 0000 00EB PORT.byte = i2c_read(0);
; 0000 00EC i2c_stop();
; 0000 00ED 
; 0000 00EE 
; 0000 00EF return PORT.bits.b4;
	SWAP R30
	RJMP _0x20A0004
; 0000 00F0 }
;
;char sprawdz_pin5(BB PORT, int numer_pcf)
; 0000 00F3 {
_sprawdz_pin5:
; 0000 00F4 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00F5 i2c_write(numer_pcf);
; 0000 00F6 PORT.byte = i2c_read(0);
; 0000 00F7 i2c_stop();
; 0000 00F8 
; 0000 00F9 
; 0000 00FA return PORT.bits.b5;
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	RJMP _0x20A0004
; 0000 00FB }
;
;char sprawdz_pin6(BB PORT, int numer_pcf)
; 0000 00FE {
_sprawdz_pin6:
; 0000 00FF i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0100 i2c_write(numer_pcf);
; 0000 0101 PORT.byte = i2c_read(0);
; 0000 0102 i2c_stop();
; 0000 0103 
; 0000 0104 
; 0000 0105 return PORT.bits.b6;
	CALL SUBOPT_0x1
	RJMP _0x20A0004
; 0000 0106 }
;
;char sprawdz_pin7(BB PORT, int numer_pcf)
; 0000 0109 {
_sprawdz_pin7:
; 0000 010A i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 010B i2c_write(numer_pcf);
; 0000 010C PORT.byte = i2c_read(0);
; 0000 010D i2c_stop();
; 0000 010E 
; 0000 010F 
; 0000 0110 return PORT.bits.b7;
	ROL  R30
	LDI  R30,0
	ROL  R30
_0x20A0004:
	ANDI R30,LOW(0x1)
	ADIW R28,3
	RET
; 0000 0111 }
;
;int odczytaj_parametr(int adres1, int adres2)
; 0000 0114 {
_odczytaj_parametr:
; 0000 0115 int z;
; 0000 0116 z = 0;
	CALL SUBOPT_0x2
;	adres1 -> Y+4
;	adres2 -> Y+2
;	z -> R16,R17
; 0000 0117 putchar(90);
	CALL SUBOPT_0x3
; 0000 0118 putchar(165);
; 0000 0119 putchar(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _putchar
; 0000 011A putchar(131);
	LDI  R30,LOW(131)
	CALL SUBOPT_0x4
; 0000 011B putchar(adres1);
; 0000 011C putchar(adres2);
; 0000 011D putchar(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar
; 0000 011E getchar();
	CALL SUBOPT_0x5
; 0000 011F getchar();
; 0000 0120 getchar();
; 0000 0121 getchar();
	CALL SUBOPT_0x5
; 0000 0122 getchar();
; 0000 0123 getchar();
; 0000 0124 getchar();
	CALL SUBOPT_0x5
; 0000 0125 getchar();
; 0000 0126 z = getchar();
	MOV  R16,R30
	CLR  R17
; 0000 0127 
; 0000 0128 
; 0000 0129 
; 0000 012A 
; 0000 012B 
; 0000 012C 
; 0000 012D 
; 0000 012E 
; 0000 012F 
; 0000 0130 
; 0000 0131 
; 0000 0132 
; 0000 0133 return z;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0003
; 0000 0134 }
;
;
;
;int czekaj_na_guzik_start(int adres)
; 0000 0139 {
; 0000 013A //48 to adres zmiennej 30
; 0000 013B //16 to adres zmiennj 10
; 0000 013C 
; 0000 013D int z;
; 0000 013E z = 0;
;	adres -> Y+2
;	z -> R16,R17
; 0000 013F putchar(90);
; 0000 0140 putchar(165);
; 0000 0141 putchar(4);
; 0000 0142 putchar(131);
; 0000 0143 putchar(0);
; 0000 0144 putchar(adres);  //adres zmiennej - 30
; 0000 0145 putchar(1);
; 0000 0146 getchar();
; 0000 0147 getchar();
; 0000 0148 getchar();
; 0000 0149 getchar();
; 0000 014A getchar();
; 0000 014B getchar();
; 0000 014C getchar();
; 0000 014D getchar();
; 0000 014E z = getchar();
; 0000 014F //itoa(z,dupa1);
; 0000 0150 //lcd_puts(dupa1);
; 0000 0151 
; 0000 0152 return z;
; 0000 0153 }
;
;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 015A {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 015B // Place your code here
; 0000 015C //16,384 ms
; 0000 015D sek1++;     //Ster 1
	LDI  R26,LOW(_sek1)
	LDI  R27,HIGH(_sek1)
	CALL SUBOPT_0x6
; 0000 015E sek2++;     //ster 3
	LDI  R26,LOW(_sek2)
	LDI  R27,HIGH(_sek2)
	CALL SUBOPT_0x6
; 0000 015F 
; 0000 0160 
; 0000 0161 sek3++;     //ster 2
	LDI  R26,LOW(_sek3)
	LDI  R27,HIGH(_sek3)
	CALL SUBOPT_0x6
; 0000 0162 sek4++;     //ster 4
	LDI  R26,LOW(_sek4)
	LDI  R27,HIGH(_sek4)
	CALL SUBOPT_0x6
; 0000 0163 
; 0000 0164 
; 0000 0165 //sek10++;
; 0000 0166 
; 0000 0167 sek11++;  //do wyboru zacisku
	LDI  R26,LOW(_sek11)
	LDI  R27,HIGH(_sek11)
	CALL SUBOPT_0x6
; 0000 0168 sek12++;  //do czasu przedmuchu
	LDI  R26,LOW(_sek12)
	LDI  R27,HIGH(_sek12)
	CALL SUBOPT_0x6
; 0000 0169 
; 0000 016A sek13++;  //do czasu zatrzymania sie druciaka na gorze
	LDI  R26,LOW(_sek13)
	LDI  R27,HIGH(_sek13)
	CALL SUBOPT_0x6
; 0000 016B 
; 0000 016C /*
; 0000 016D if(PORTE.3 == 1)
; 0000 016E       {
; 0000 016F       czas_pracy_szczotki_drucianej++;
; 0000 0170       czas_pracy_krazka_sciernego++;
; 0000 0171       if(czas_pracy_szczotki_drucianej == 61 * 60 * 60)
; 0000 0172             {
; 0000 0173             czas_pracy_szczotki_drucianej = 0;
; 0000 0174             czas_pracy_szczotki_drucianej_h++;
; 0000 0175             }
; 0000 0176       if(czas_pracy_krazka_sciernego == 61 * 60 * 60)
; 0000 0177             {
; 0000 0178             czas_pracy_krazka_sciernego = 0;
; 0000 0179             czas_pracy_krazka_sciernego_h++;
; 0000 017A             }
; 0000 017B       }
; 0000 017C 
; 0000 017D 
; 0000 017E       //61 razy - 1s
; 0000 017F       //61 * 60 - 1 minuta
; 0000 0180       //61 * 60 * 60 - 1h
; 0000 0181 
; 0000 0182 */
; 0000 0183 
; 0000 0184 }
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
; 0000 018D {
_komunikat_na_panel:
; 0000 018E int h;
; 0000 018F 
; 0000 0190 h = 0;
	CALL SUBOPT_0x2
;	*fmtstr -> Y+6
;	adres2 -> Y+4
;	adres22 -> Y+2
;	h -> R16,R17
; 0000 0191 h = strlenf(fmtstr);
	CALL SUBOPT_0x7
	CALL _strlenf
	MOVW R16,R30
; 0000 0192 h = h + 3;
	__ADDWRN 16,17,3
; 0000 0193 
; 0000 0194 putchar(90);
	CALL SUBOPT_0x3
; 0000 0195 putchar(165);
; 0000 0196 putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL _putchar
; 0000 0197 putchar(130);  //82
	LDI  R30,LOW(130)
	CALL SUBOPT_0x4
; 0000 0198 putchar(adres2);    //
; 0000 0199 putchar(adres22);  //
; 0000 019A printf(fmtstr);
	CALL SUBOPT_0x7
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 019B }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;
;
;
;void wartosc_parametru_panelu(int wartosc, int adres1, int adres2)
; 0000 01A0 {
_wartosc_parametru_panelu:
; 0000 01A1 putchar(90);  //5A
;	wartosc -> Y+4
;	adres1 -> Y+2
;	adres2 -> Y+0
	CALL SUBOPT_0x3
; 0000 01A2 putchar(165); //A5
; 0000 01A3 putchar(5);//05
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 01A4 putchar(130);  //82    /
; 0000 01A5 putchar(adres1);    //00
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
; 0000 01A6 putchar(adres2);   //40
	LD   R30,Y
	ST   -Y,R30
	CALL _putchar
; 0000 01A7 putchar(0);    //00
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
; 0000 01A8 putchar(wartosc);   //80
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _putchar
; 0000 01A9 }
_0x20A0003:
	ADIW R28,6
	RET
;
;
;void zaktualizuj_parametry_panelu()
; 0000 01AD {
_zaktualizuj_parametry_panelu:
; 0000 01AE wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 01AF 
; 0000 01B0 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h,16,48);
; 0000 01B1 
; 0000 01B2 }
	RET
;
;void komunikat_z_czytnika_kodow(char flash *fmtstr,int rzad, int na_plus_minus)
; 0000 01B5 {
_komunikat_z_czytnika_kodow:
; 0000 01B6 //na_plus_minus = 1;  to jest na plus
; 0000 01B7 //na_plus_minus = 0;  to jest na minus
; 0000 01B8 
; 0000 01B9 int h, adres1,adres11,adres2,adres22;
; 0000 01BA 
; 0000 01BB h = 0;
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
; 0000 01BC h = strlenf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOVW R16,R30
; 0000 01BD h = h + 3;
	__ADDWRN 16,17,3
; 0000 01BE 
; 0000 01BF if(rzad == 1)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BRNE _0xD
; 0000 01C0    {
; 0000 01C1    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01C2    adres11 = 80;
	__GETWRN 20,21,80
; 0000 01C3    adres2 = 80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01C4    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01C5    }
; 0000 01C6 if(rzad == 2)
_0xD:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,2
	BRNE _0xE
; 0000 01C7    {
; 0000 01C8    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01C9    adres11 = 32;
	__GETWRN 20,21,32
; 0000 01CA    adres2 = 64;
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01CB    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01CC    }
; 0000 01CD 
; 0000 01CE putchar(90);
_0xE:
	CALL SUBOPT_0x3
; 0000 01CF putchar(165);
; 0000 01D0 putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL SUBOPT_0x8
; 0000 01D1 putchar(130);  //82
; 0000 01D2 putchar(adres1);    //
	ST   -Y,R18
	CALL _putchar
; 0000 01D3 putchar(adres11);  //
	ST   -Y,R20
	CALL _putchar
; 0000 01D4 printf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 01D5 
; 0000 01D6 
; 0000 01D7 if(rzad == 1 & macierz_zaciskow[rzad]==0)
	CALL SUBOPT_0xD
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0xE
	CALL __GETW1P
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	BREQ _0xF
; 0000 01D8     {
; 0000 01D9     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xF
; 0000 01DA     komunikat_na_panel("Zacisk nie zmierzony u Wykonawcy",adres2,adres22);
	__POINTW1FN _0x0,49
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 01DB     }
; 0000 01DC 
; 0000 01DD if(rzad == 1 & na_plus_minus == 1)
_0xF:
	CALL SUBOPT_0xD
	CALL SUBOPT_0x12
	BREQ _0x10
; 0000 01DE     {
; 0000 01DF     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xF
; 0000 01E0     komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 01E1     }
; 0000 01E2 
; 0000 01E3 if(rzad == 1 & na_plus_minus == 0)
_0x10:
	CALL SUBOPT_0xD
	CALL SUBOPT_0x13
	BREQ _0x11
; 0000 01E4     {
; 0000 01E5     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xF
; 0000 01E6     komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
	__POINTW1FN _0x0,106
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 01E7     }
; 0000 01E8 
; 0000 01E9 
; 0000 01EA if(rzad == 2 & na_plus_minus == 1)
_0x11:
	CALL SUBOPT_0x14
	CALL SUBOPT_0x12
	BREQ _0x12
; 0000 01EB     {
; 0000 01EC     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xF
; 0000 01ED     komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
	__POINTW1FN _0x0,106
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 01EE     }
; 0000 01EF 
; 0000 01F0 if(rzad == 2 & na_plus_minus == 0)
_0x12:
	CALL SUBOPT_0x14
	CALL SUBOPT_0x13
	BREQ _0x13
; 0000 01F1     {
; 0000 01F2     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xF
; 0000 01F3     komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 01F4     }
; 0000 01F5 
; 0000 01F6 
; 0000 01F7 }
_0x13:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;
;void zerowanie_pam_wew()
; 0000 01FA {
_zerowanie_pam_wew:
; 0000 01FB if(czas_pracy_szczotki_drucianej_h >= 255 | czas_pracy_krazka_sciernego_h >=255 | czas_pracy_krazka_sciernego_stala >= 255 | czas_pracy_szczotki_drucianej_stala >= 255 |
; 0000 01FC    szczotka_druciana_ilosc_cykli >= 255 | krazek_scierny_ilosc_cykli >= 255 | krazek_scierny_cykl_po_okregu_ilosc >=255)
	CALL SUBOPT_0x9
	CALL SUBOPT_0x15
	MOV  R0,R30
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h)
	CALL SUBOPT_0x16
	OR   R0,R30
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_stala)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_stala)
	CALL SUBOPT_0x16
	OR   R0,R30
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL SUBOPT_0x16
	OR   R0,R30
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL SUBOPT_0x16
	OR   R0,R30
	LDI  R26,LOW(_krazek_scierny_ilosc_cykli)
	LDI  R27,HIGH(_krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x16
	OR   R0,R30
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu_ilosc)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu_ilosc)
	CALL SUBOPT_0x16
	OR   R30,R0
	BREQ _0x14
; 0000 01FD      {
; 0000 01FE      czas_pracy_szczotki_drucianej_h = 0;
	CALL SUBOPT_0x17
; 0000 01FF      czas_pracy_szczotki_drucianej = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_szczotki_drucianej,R30
	STS  _czas_pracy_szczotki_drucianej+1,R30
; 0000 0200      czas_pracy_krazka_sciernego_h = 0;
	CALL SUBOPT_0x18
; 0000 0201      czas_pracy_krazka_sciernego = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego,R30
	STS  _czas_pracy_krazka_sciernego+1,R30
; 0000 0202      czas_pracy_krazka_sciernego_stala = 5;
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_stala)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_stala)
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EEPROMWRW
; 0000 0203      czas_pracy_szczotki_drucianej_stala = 5;
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL __EEPROMWRW
; 0000 0204      szczotka_druciana_ilosc_cykli = 3;
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL SUBOPT_0x19
; 0000 0205      krazek_scierny_ilosc_cykli = 3;
	LDI  R26,LOW(_krazek_scierny_ilosc_cykli)
	LDI  R27,HIGH(_krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x19
; 0000 0206      krazek_scierny_cykl_po_okregu_ilosc = 3;
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu_ilosc)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu_ilosc)
	CALL SUBOPT_0x19
; 0000 0207      }
; 0000 0208 
; 0000 0209 /*
; 0000 020A if(czas_pracy_krazka_sciernego_h >= 255)
; 0000 020B      {
; 0000 020C      czas_pracy_krazka_sciernego_h = 0;
; 0000 020D      czas_pracy_krazka_sciernego = 0;
; 0000 020E      }
; 0000 020F if(czas_pracy_krazka_sciernego_stala >= 255)
; 0000 0210      czas_pracy_krazka_sciernego_stala = 5;
; 0000 0211 
; 0000 0212 if(czas_pracy_szczotki_drucianej_stala >= 255)
; 0000 0213      czas_pracy_szczotki_drucianej_stala = 5;
; 0000 0214 
; 0000 0215 if(szczotka_druciana_ilosc_cykli >= 255)
; 0000 0216 
; 0000 0217 if(krazek_scierny_ilosc_cykli >= 255)
; 0000 0218 
; 0000 0219 if(krazek_scierny_cykl_po_okregu_ilosc >=255)
; 0000 021A */
; 0000 021B 
; 0000 021C }
_0x14:
	RET
;
;
;void odpytaj_parametry_panelu()
; 0000 0220 {
_odpytaj_parametry_panelu:
; 0000 0221 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	PUSH R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	POP  R26
	AND  R30,R26
	BREQ _0x15
; 0000 0222     start = odczytaj_parametr(0,64);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	STS  _start,R30
	STS  _start+1,R31
; 0000 0223 il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
_0x15:
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
; 0000 0224 il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
; 0000 0225 
; 0000 0226 szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
	CALL SUBOPT_0x1E
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL SUBOPT_0x23
; 0000 0227                                                 //2090
; 0000 0228 krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x24
; 0000 0229                                                     //3000
; 0000 022A krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
	CALL SUBOPT_0x25
; 0000 022B 
; 0000 022C 
; 0000 022D czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL SUBOPT_0x23
; 0000 022E 
; 0000 022F czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
	CALL SUBOPT_0x26
	RCALL _odczytaj_parametr
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_stala)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_stala)
	CALL __EEPROMWRW
; 0000 0230 
; 0000 0231 czas_pracy_szczotki_drucianej_h = odczytaj_parametr(0,144);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xB
	RCALL _odczytaj_parametr
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h)
	CALL __EEPROMWRW
; 0000 0232 
; 0000 0233 czas_pracy_krazka_sciernego_h = odczytaj_parametr(16,48);
	CALL SUBOPT_0x26
	CALL SUBOPT_0x21
	RCALL _odczytaj_parametr
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h)
	CALL __EEPROMWRW
; 0000 0234 
; 0000 0235 test_geometryczny_rzad_1 = odczytaj_parametr(48,80);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x28
	RCALL _odczytaj_parametr
	STS  _test_geometryczny_rzad_1,R30
	STS  _test_geometryczny_rzad_1+1,R31
; 0000 0236 
; 0000 0237 test_geometryczny_rzad_2 = odczytaj_parametr(48,96);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x29
	RCALL _odczytaj_parametr
	STS  _test_geometryczny_rzad_2,R30
	STS  _test_geometryczny_rzad_2+1,R31
; 0000 0238 
; 0000 0239 srednica_krazka_sciernego = odczytaj_parametr(48,112);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
; 0000 023A 
; 0000 023B ruch_haos = odczytaj_parametr(48,144);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x2B
; 0000 023C                                                 //2050
; 0000 023D zerowanie_pam_wew();
	RCALL _zerowanie_pam_wew
; 0000 023E 
; 0000 023F }
	RET
;
;void wyrrrjscia_i_wejscia_opis()
; 0000 0242 {
; 0000 0243 
; 0000 0244 
; 0000 0245 //IN0
; 0000 0246 
; 0000 0247 //komunikacja miedzy slave a master
; 0000 0248 //sprawdz_pin0(PORTHH,0x73)
; 0000 0249 //sprawdz_pin1(PORTHH,0x73)
; 0000 024A //sprawdz_pin2(PORTHH,0x73)
; 0000 024B //sprawdz_pin3(PORTHH,0x73)
; 0000 024C //sprawdz_pin4(PORTHH,0x73)
; 0000 024D //sprawdz_pin5(PORTHH,0x73)
; 0000 024E //sprawdz_pin6(PORTHH,0x73)
; 0000 024F //sprawdz_pin7(PORTHH,0x73)
; 0000 0250 
; 0000 0251 //IN1
; 0000 0252 //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 0253 //sprawdz_pin1(PORTJJ,0x79)  AREA   STEROWNIK1
; 0000 0254 //sprawdz_pin2(PORTJJ,0x79)  SETON  STEROWNIK1
; 0000 0255 //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 0256 //sprawdz_pin4(PORTJJ,0x79)  SVRE   STEROWNIK1
; 0000 0257 //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 0258 //sprawdz_pin6(PORTJJ,0x79)  czujnik cisnienia
; 0000 0259 //sprawdz_pin7(PORTJJ,0x79)
; 0000 025A 
; 0000 025B //IN2
; 0000 025C //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 025D //sprawdz_pin1(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK3
; 0000 025E //sprawdz_pin2(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK3
; 0000 025F //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 0260 //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 0261 //sprawdz_pin5(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK4
; 0000 0262 //sprawdz_pin6(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK4
; 0000 0263 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 0264 
; 0000 0265 //IN3
; 0000 0266 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 0267 //sprawdz_pin1(PORTLL,0x71)  AREA   STEROWNIK2
; 0000 0268 //sprawdz_pin2(PORTLL,0x71)  SETON  STEROWNIK2
; 0000 0269 //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 026A //sprawdz_pin4(PORTLL,0x71)  SVRE   STEROWNIK2
; 0000 026B //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 026C //sprawdz_pin6(PORTLL,0x71)  S6A przek³adanie rzedow
; 0000 026D //sprawdz_pin7(PORTLL,0x71)  S6B przekladanie rzedow
; 0000 026E 
; 0000 026F //IN4
; 0000 0270 //sprawdz_pin0(PORTMM,0x77) J2  czujnik indukcyjny domkniecia pokrywy
; 0000 0271 //sprawdz_pin1(PORTMM,0x77) J3  czujnik indukcyjny domkniecia pokrywy
; 0000 0272 //sprawdz_pin2(PORTMM,0x77) przycisk zatrzymaj
; 0000 0273 //sprawdz_pin3(PORTMM,0x77)
; 0000 0274 //sprawdz_pin4(PORTMM,0x77)
; 0000 0275 //sprawdz_pin5(PORTMM,0x77)
; 0000 0276 //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 0277 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 0278 
; 0000 0279 //sterownik 1 i sterownik 3 - krazek scierny
; 0000 027A //sterownik 2 i sterownik 4 - druciak
; 0000 027B 
; 0000 027C //OUT
; 0000 027D //PORTA.0   IN0  STEROWNIK1        OUT 1
; 0000 027E //PORTA.1   IN1  STEROWNIK1
; 0000 027F //PORTA.2   IN2  STEROWNIK1
; 0000 0280 //PORTA.3   IN3  STEROWNIK1
; 0000 0281 //PORTA.4   IN4  STEROWNIK1
; 0000 0282 //PORTA.5   IN5  STEROWNIK1
; 0000 0283 //PORTA.6   IN6  STEROWNIK1
; 0000 0284 //PORTA.7   IN7  STEROWNIK1
; 0000 0285 
; 0000 0286 //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 0287 //PORTB.1   IN1  STEROWNIK4
; 0000 0288 //PORTB.2   IN2  STEROWNIK4
; 0000 0289 //PORTB.3   IN3  STEROWNIK4
; 0000 028A //PORTB.4   4B CEWKA przedmuch osi, byl, juz poloczone z B.6, teraz juz setup poziome
; 0000 028B //PORTB.5   DRIVE  STEROWNIK4
; 0000 028C //PORTB.6   swiatlo zielone
; 0000 028D //PORTB.7   IN5 STEROWNIK 3
; 0000 028E 
; 0000 028F //PORTC.0   IN0  STEROWNIK2        OUT 3
; 0000 0290 //PORTC.1   IN1  STEROWNIK2
; 0000 0291 //PORTC.2   IN2  STEROWNIK2
; 0000 0292 //PORTC.3   IN3  STEROWNIK2
; 0000 0293 //PORTC.4   IN4  STEROWNIK2
; 0000 0294 //PORTC.5   IN5  STEROWNIK2
; 0000 0295 //PORTC.6   IN6  STEROWNIK2
; 0000 0296 //PORTC.7   IN7  STEROWNIK2
; 0000 0297 
; 0000 0298 //PORTD.0  SDA                     OUT 2
; 0000 0299 //PORTD.1  SCL
; 0000 029A //PORTD.2  SETUP   STEROWNIK1 STEROWNIK 2 STEROIWNIK 3 STEROWNIK 4
; 0000 029B //PORTD.3  DRIVE   STEROWNIK1
; 0000 029C //PORTD.4  IN8 STEROWNIK1
; 0000 029D //PORTD.5  IN8 STEROWNIK2
; 0000 029E //PORTD.6  DRIVE   STEROWNIK2
; 0000 029F //PORTD.7  swiatlo czerwone i jednoczesnie HOLD
; 0000 02A0 
; 0000 02A1 //PORTE.0
; 0000 02A2 //PORTE.1
; 0000 02A3 //PORTE.2  1A CEWKA szczotka druciana                    OUT 6
; 0000 02A4 //PORTE.3  1B CEWKA krazek scierny
; 0000 02A5 //PORTE.4  IN4  STEROWNIK4
; 0000 02A6 //PORTE.5  IN5  STEROWNIK4      ///////////////////////////////////////////////////////////////////tu zmieniam 16.04 - cewka zmiany przedmuch 0 - ta na krazku 1- ta na druciaku
; 0000 02A7 //PORTE.6  2A CEWKA przerzucanie docisku zaciskow
; 0000 02A8 //PORTE.7  3A CEWKA zacisnij zaciski
; 0000 02A9 
; 0000 02AA //PORTF.0   IN0  STEROWNIK3             OUT 4
; 0000 02AB //PORTF.1   IN1  STEROWNIK3
; 0000 02AC //PORTF.2   IN2  STEROWNIK3
; 0000 02AD //PORTF.3   IN3  STEROWNIK3
; 0000 02AE //PORTF.4   4A CEWKA przedmuch zaciskow
; 0000 02AF //PORTF.5   DRIVE  STEROWNIK3
; 0000 02B0 //PORTF.6   swiatlo zolte
; 0000 02B1 //PORTF.7   IN4 STEROWNIK 3
; 0000 02B2 
; 0000 02B3 
; 0000 02B4 
; 0000 02B5  //PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 02B6 //PORTF = PORT_F.byte;
; 0000 02B7 //PORTB.6 = 1;  //przedmuch osi
; 0000 02B8 //PORTE.2 = 1;  //szlifierka 1
; 0000 02B9 //PORTE.3 = 1;  //szlifierka 2
; 0000 02BA //PORTE.6 = 0;  //zacisniety rzad 1
; 0000 02BB //PORTE.6 = 1;  //zacisniety rzad 2
; 0000 02BC //PORTE.7 = 0;    //zacisnij zaciski
; 0000 02BD 
; 0000 02BE 
; 0000 02BF //macierz_zaciskow[rzad]=44; brak
; 0000 02C0 //macierz_zaciskow[rzad]=48; brak
; 0000 02C1 //macierz_zaciskow[rzad]=76  brak
; 0000 02C2 //macierz_zaciskow[rzad]=80; brak
; 0000 02C3 //macierz_zaciskow[rzad]=92; brak
; 0000 02C4 //macierz_zaciskow[rzad]=96;  brak
; 0000 02C5 //macierz_zaciskow[rzad]=107; brak
; 0000 02C6 //macierz_zaciskow[rzad]=111; brak
; 0000 02C7 
; 0000 02C8 
; 0000 02C9 
; 0000 02CA 
; 0000 02CB /*
; 0000 02CC 
; 0000 02CD //testy parzystych i nieparzystych IN0-IN8
; 0000 02CE //testy port/pin
; 0000 02CF //sterownik 3
; 0000 02D0 //PORTF.0   IN0  STEROWNIK3
; 0000 02D1 //PORTF.1   IN1  STEROWNIK3
; 0000 02D2 //PORTF.2   IN2  STEROWNIK3
; 0000 02D3 //PORTF.3   IN3  STEROWNIK3
; 0000 02D4 //PORTF.7   IN4 STEROWNIK 3
; 0000 02D5 //PORTB.7   IN5 STEROWNIK 3
; 0000 02D6 
; 0000 02D7 
; 0000 02D8 PORT_F.bits.b0 = 0;
; 0000 02D9 PORT_F.bits.b1 = 1;
; 0000 02DA PORT_F.bits.b2 = 0;
; 0000 02DB PORT_F.bits.b3 = 1;
; 0000 02DC PORT_F.bits.b7 = 0;
; 0000 02DD PORTF = PORT_F.byte;
; 0000 02DE PORTB.7 = 1;
; 0000 02DF 
; 0000 02E0 //sterownik 4
; 0000 02E1 
; 0000 02E2 //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 02E3 //PORTB.1   IN1  STEROWNIK4
; 0000 02E4 //PORTB.2   IN2  STEROWNIK4
; 0000 02E5 //PORTB.3   IN3  STEROWNIK4
; 0000 02E6 //PORTE.4  IN4  STEROWNIK4
; 0000 02E7 
; 0000 02E8 
; 0000 02E9 PORTB.0 = 0;
; 0000 02EA PORTB.1 = 1;
; 0000 02EB PORTB.2 = 0;
; 0000 02EC PORTB.3 = 1;
; 0000 02ED PORTE.4 = 0;
; 0000 02EE 
; 0000 02EF 
; 0000 02F0 //ster 1
; 0000 02F1 PORTA.0 = 0;   //IN0  STEROWNIK1        OUT 1
; 0000 02F2 PORTA.1 = 1;  //IN1  STEROWNIK1
; 0000 02F3 PORTA.2 = 0;  // IN2  STEROWNIK1
; 0000 02F4 PORTA.3 = 1;  //IN3  STEROWNIK1
; 0000 02F5 PORTA.4 = 0;  // IN4  STEROWNIK1
; 0000 02F6 PORTA.5 = 1;  //IN5  STEROWNIK1
; 0000 02F7 PORTA.6 = 0;   //IN6  STEROWNIK1
; 0000 02F8 PORTA.7 = 1;  //IN7  STEROWNIK1
; 0000 02F9 PORTD.4 = 0; //IN8 STEROWNIK1
; 0000 02FA 
; 0000 02FB 
; 0000 02FC 
; 0000 02FD //sterownik 2
; 0000 02FE PORTC.0 = 0;   //IN0  STEROWNIK2        OUT 3
; 0000 02FF PORTC.1  = 1;  //IN1  STEROWNIK2
; 0000 0300 PORTC.2 = 0;    //IN2  STEROWNIK2
; 0000 0301 PORTC.3= 1;   //IN3  STEROWNIK2
; 0000 0302 PORTC.4 = 0;   // IN4  STEROWNIK2
; 0000 0303 PORTC.5= 1;   //IN5  STEROWNIK2
; 0000 0304 PORTC.6 = 0;   // IN6  STEROWNIK2
; 0000 0305 PORTC.7= 1;   //IN7  STEROWNIK2
; 0000 0306 PORTD.5 = 0;  //IN8 STEROWNIK2
; 0000 0307 
; 0000 0308 */
; 0000 0309 
; 0000 030A }
;
;void sprawdz_cisnienie()
; 0000 030D {
_sprawdz_cisnienie:
; 0000 030E int i;
; 0000 030F //i = 0;
; 0000 0310 i = 1;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,1
; 0000 0311 
; 0000 0312 while(i == 0)
_0x16:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x18
; 0000 0313     {
; 0000 0314     if(sprawdz_pin6(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x2C
	RCALL _sprawdz_pin6
	CPI  R30,0
	BRNE _0x19
; 0000 0315         {
; 0000 0316         i = 1;
	__GETWRN 16,17,1
; 0000 0317         komunikat_na_panel("                                                ",adr1,adr2);
	__POINTW1FN _0x0,0
	RJMP _0x464
; 0000 0318         }
; 0000 0319     else
_0x19:
; 0000 031A         {
; 0000 031B         i = 0;
	__GETWRN 16,17,0
; 0000 031C         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 031D         komunikat_na_panel("Cisnienie za male - mniejsze niz 6 bar",adr1,adr2);
	__POINTW1FN _0x0,132
_0x464:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2E
; 0000 031E         }
; 0000 031F     }
	RJMP _0x16
_0x18:
; 0000 0320 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;int odczyt_wybranego_zacisku()
; 0000 0324 {                         //11
_odczyt_wybranego_zacisku:
; 0000 0325 int rzad;
; 0000 0326 
; 0000 0327 PORT_CZYTNIK.bits.b0 = sprawdz_pin0(PORTHH,0x73);
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	CALL SUBOPT_0x2F
	RCALL _sprawdz_pin0
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFE
	CALL SUBOPT_0x30
; 0000 0328 PORT_CZYTNIK.bits.b1 = sprawdz_pin1(PORTHH,0x73);
	RCALL _sprawdz_pin1
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFD
	CALL SUBOPT_0x30
; 0000 0329 PORT_CZYTNIK.bits.b2 = sprawdz_pin2(PORTHH,0x73);
	RCALL _sprawdz_pin2
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFB
	CALL SUBOPT_0x30
; 0000 032A PORT_CZYTNIK.bits.b3 = sprawdz_pin3(PORTHH,0x73);
	RCALL _sprawdz_pin3
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0XF7
	CALL SUBOPT_0x30
; 0000 032B PORT_CZYTNIK.bits.b4 = sprawdz_pin4(PORTHH,0x73);
	RCALL _sprawdz_pin4
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xEF
	CALL SUBOPT_0x30
; 0000 032C PORT_CZYTNIK.bits.b5 = sprawdz_pin5(PORTHH,0x73);
	RCALL _sprawdz_pin5
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xDF
	CALL SUBOPT_0x30
; 0000 032D PORT_CZYTNIK.bits.b6 = sprawdz_pin6(PORTHH,0x73);
	RCALL _sprawdz_pin6
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xBF
	CALL SUBOPT_0x30
; 0000 032E PORT_CZYTNIK.bits.b7 = sprawdz_pin7(PORTHH,0x73);
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
; 0000 032F 
; 0000 0330 rzad = odczytaj_parametr(32,128);       //20,80
	CALL SUBOPT_0x31
	CALL SUBOPT_0x1F
	MOVW R16,R30
; 0000 0331 
; 0000 0332 if(PORT_CZYTNIK.byte == 0x01)
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1)
	BRNE _0x1B
; 0000 0333     {
; 0000 0334     macierz_zaciskow[rzad]=1;
	MOVW R30,R16
	CALL SUBOPT_0xE
	CALL SUBOPT_0x32
; 0000 0335     komunikat_z_czytnika_kodow("86-0170",rzad,1);
	__POINTW1FN _0x0,171
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0336     }
; 0000 0337 
; 0000 0338 if(PORT_CZYTNIK.byte == 0x02)
_0x1B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2)
	BRNE _0x1C
; 0000 0339     {
; 0000 033A     macierz_zaciskow[rzad]=2;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
; 0000 033B     komunikat_z_czytnika_kodow("86-1043",rzad,0);
	__POINTW1FN _0x0,179
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 033C 
; 0000 033D     }
; 0000 033E 
; 0000 033F if(PORT_CZYTNIK.byte == 0x03)
_0x1C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3)
	BRNE _0x1D
; 0000 0340     {
; 0000 0341       macierz_zaciskow[rzad]=3;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   X+,R30
	ST   X,R31
; 0000 0342       komunikat_z_czytnika_kodow("86-1675",rzad,0);
	__POINTW1FN _0x0,187
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0343     }
; 0000 0344 
; 0000 0345 if(PORT_CZYTNIK.byte == 0x04)
_0x1D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4)
	BRNE _0x1E
; 0000 0346     {
; 0000 0347 
; 0000 0348       macierz_zaciskow[rzad]=4;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   X+,R30
	ST   X,R31
; 0000 0349       komunikat_z_czytnika_kodow("86-2098",rzad,0);
	__POINTW1FN _0x0,195
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 034A 
; 0000 034B     }
; 0000 034C if(PORT_CZYTNIK.byte == 0x05)
_0x1E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5)
	BRNE _0x1F
; 0000 034D     {
; 0000 034E       macierz_zaciskow[rzad]=5;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   X+,R30
	ST   X,R31
; 0000 034F       komunikat_z_czytnika_kodow("87-0170",rzad,0);
	__POINTW1FN _0x0,203
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0350 
; 0000 0351     }
; 0000 0352 if(PORT_CZYTNIK.byte == 0x06)
_0x1F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6)
	BRNE _0x20
; 0000 0353     {
; 0000 0354       macierz_zaciskow[rzad]=6;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   X+,R30
	ST   X,R31
; 0000 0355       komunikat_z_czytnika_kodow("87-1043",rzad,1);
	__POINTW1FN _0x0,211
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0356 
; 0000 0357     }
; 0000 0358 
; 0000 0359 if(PORT_CZYTNIK.byte == 0x07)
_0x20:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7)
	BRNE _0x21
; 0000 035A     {
; 0000 035B       macierz_zaciskow[rzad]=7;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   X+,R30
	ST   X,R31
; 0000 035C       komunikat_z_czytnika_kodow("87-1675",rzad,1);
	__POINTW1FN _0x0,219
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 035D 
; 0000 035E     }
; 0000 035F 
; 0000 0360 if(PORT_CZYTNIK.byte == 0x08)
_0x21:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8)
	BRNE _0x22
; 0000 0361     {
; 0000 0362       macierz_zaciskow[rzad]=8;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   X+,R30
	ST   X,R31
; 0000 0363       komunikat_z_czytnika_kodow("87-2098",rzad,1);
	__POINTW1FN _0x0,227
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0364 
; 0000 0365     }
; 0000 0366 if(PORT_CZYTNIK.byte == 0x09)
_0x22:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x9)
	BRNE _0x23
; 0000 0367     {
; 0000 0368       macierz_zaciskow[rzad]=9;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   X+,R30
	ST   X,R31
; 0000 0369       komunikat_z_czytnika_kodow("86-0192",rzad,0);
	__POINTW1FN _0x0,235
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 036A 
; 0000 036B     }
; 0000 036C if(PORT_CZYTNIK.byte == 0x0A)
_0x23:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xA)
	BRNE _0x24
; 0000 036D     {
; 0000 036E       macierz_zaciskow[rzad]=10;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   X+,R30
	ST   X,R31
; 0000 036F       komunikat_z_czytnika_kodow("86-1054",rzad,0);
	__POINTW1FN _0x0,243
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0370 
; 0000 0371     }
; 0000 0372 if(PORT_CZYTNIK.byte == 0x0B)
_0x24:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xB)
	BRNE _0x25
; 0000 0373     {
; 0000 0374       macierz_zaciskow[rzad]=11;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   X+,R30
	ST   X,R31
; 0000 0375       komunikat_z_czytnika_kodow("86-1676",rzad,0);
	__POINTW1FN _0x0,251
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0376 
; 0000 0377     }
; 0000 0378 if(PORT_CZYTNIK.byte == 0x0C)
_0x25:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xC)
	BRNE _0x26
; 0000 0379     {
; 0000 037A       macierz_zaciskow[rzad]=12;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   X+,R30
	ST   X,R31
; 0000 037B       komunikat_z_czytnika_kodow("86-2132",rzad,1);
	__POINTW1FN _0x0,259
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 037C 
; 0000 037D     }
; 0000 037E if(PORT_CZYTNIK.byte == 0x0D)
_0x26:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xD)
	BRNE _0x27
; 0000 037F     {
; 0000 0380       macierz_zaciskow[rzad]=13;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   X+,R30
	ST   X,R31
; 0000 0381       komunikat_z_czytnika_kodow("87-0192",rzad,1);
	__POINTW1FN _0x0,267
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0382 
; 0000 0383     }
; 0000 0384 if(PORT_CZYTNIK.byte == 0x0E)
_0x27:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xE)
	BRNE _0x28
; 0000 0385     {
; 0000 0386       macierz_zaciskow[rzad]=14;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   X+,R30
	ST   X,R31
; 0000 0387       komunikat_z_czytnika_kodow("87-1054",rzad,1);
	__POINTW1FN _0x0,275
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0388 
; 0000 0389     }
; 0000 038A 
; 0000 038B if(PORT_CZYTNIK.byte == 0x0F)
_0x28:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xF)
	BRNE _0x29
; 0000 038C     {
; 0000 038D       macierz_zaciskow[rzad]=15;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   X+,R30
	ST   X,R31
; 0000 038E       komunikat_z_czytnika_kodow("87-1676",rzad,1);
	__POINTW1FN _0x0,283
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 038F 
; 0000 0390     }
; 0000 0391 if(PORT_CZYTNIK.byte == 0x10)
_0x29:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x10)
	BRNE _0x2A
; 0000 0392     {
; 0000 0393       macierz_zaciskow[rzad]=16;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   X+,R30
	ST   X,R31
; 0000 0394       komunikat_z_czytnika_kodow("87-2132",rzad,0);
	__POINTW1FN _0x0,291
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0395 
; 0000 0396     }
; 0000 0397 
; 0000 0398 if(PORT_CZYTNIK.byte == 0x11)
_0x2A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x11)
	BRNE _0x2B
; 0000 0399     {
; 0000 039A       macierz_zaciskow[rzad]=17;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   X+,R30
	ST   X,R31
; 0000 039B       komunikat_z_czytnika_kodow("86-0193",rzad,0);
	__POINTW1FN _0x0,299
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 039C     }
; 0000 039D 
; 0000 039E if(PORT_CZYTNIK.byte == 0x12)
_0x2B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x12)
	BRNE _0x2C
; 0000 039F     {
; 0000 03A0       macierz_zaciskow[rzad]=18;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	ST   X+,R30
	ST   X,R31
; 0000 03A1       komunikat_z_czytnika_kodow("86-1216",rzad,0);
	__POINTW1FN _0x0,307
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 03A2 
; 0000 03A3     }
; 0000 03A4 if(PORT_CZYTNIK.byte == 0x13)
_0x2C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x13)
	BRNE _0x2D
; 0000 03A5     {
; 0000 03A6       macierz_zaciskow[rzad]=19;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	ST   X+,R30
	ST   X,R31
; 0000 03A7       komunikat_z_czytnika_kodow("86-1832",rzad,0);
	__POINTW1FN _0x0,315
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 03A8 
; 0000 03A9     }
; 0000 03AA 
; 0000 03AB if(PORT_CZYTNIK.byte == 0x14)
_0x2D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x14)
	BRNE _0x2E
; 0000 03AC     {
; 0000 03AD       macierz_zaciskow[rzad]=20;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   X+,R30
	ST   X,R31
; 0000 03AE       komunikat_z_czytnika_kodow("86-2174",rzad,0);
	__POINTW1FN _0x0,323
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 03AF 
; 0000 03B0     }
; 0000 03B1 if(PORT_CZYTNIK.byte == 0x15)
_0x2E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x15)
	BRNE _0x2F
; 0000 03B2     {
; 0000 03B3       macierz_zaciskow[rzad]=21;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	ST   X+,R30
	ST   X,R31
; 0000 03B4       komunikat_z_czytnika_kodow("87-0193",rzad,1);
	__POINTW1FN _0x0,331
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03B5 
; 0000 03B6     }
; 0000 03B7 
; 0000 03B8 if(PORT_CZYTNIK.byte == 0x16)
_0x2F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x16)
	BRNE _0x30
; 0000 03B9     {
; 0000 03BA       macierz_zaciskow[rzad]=22;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	ST   X+,R30
	ST   X,R31
; 0000 03BB       komunikat_z_czytnika_kodow("87-1216",rzad,1);
	__POINTW1FN _0x0,339
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03BC 
; 0000 03BD     }
; 0000 03BE if(PORT_CZYTNIK.byte == 0x17)
_0x30:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x17)
	BRNE _0x31
; 0000 03BF     {
; 0000 03C0       macierz_zaciskow[rzad]=23;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	ST   X+,R30
	ST   X,R31
; 0000 03C1       komunikat_z_czytnika_kodow("87-1832",rzad,1);
	__POINTW1FN _0x0,347
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03C2 
; 0000 03C3     }
; 0000 03C4 
; 0000 03C5 if(PORT_CZYTNIK.byte == 0x18)
_0x31:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x18)
	BRNE _0x32
; 0000 03C6     {
; 0000 03C7       macierz_zaciskow[rzad]=24;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	ST   X+,R30
	ST   X,R31
; 0000 03C8       komunikat_z_czytnika_kodow("87-2174",rzad,1);
	__POINTW1FN _0x0,355
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03C9 
; 0000 03CA     }
; 0000 03CB if(PORT_CZYTNIK.byte == 0x19)
_0x32:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x19)
	BRNE _0x33
; 0000 03CC     {
; 0000 03CD       macierz_zaciskow[rzad]=25;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	ST   X+,R30
	ST   X,R31
; 0000 03CE       komunikat_z_czytnika_kodow("86-0194",rzad,0);
	__POINTW1FN _0x0,363
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 03CF 
; 0000 03D0     }
; 0000 03D1 
; 0000 03D2 if(PORT_CZYTNIK.byte == 0x1A)
_0x33:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1A)
	BRNE _0x34
; 0000 03D3     {
; 0000 03D4       macierz_zaciskow[rzad]=26;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	ST   X+,R30
	ST   X,R31
; 0000 03D5       komunikat_z_czytnika_kodow("86-1341",rzad,0);
	__POINTW1FN _0x0,371
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 03D6 
; 0000 03D7     }
; 0000 03D8 if(PORT_CZYTNIK.byte == 0x1B)
_0x34:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1B)
	BRNE _0x35
; 0000 03D9     {
; 0000 03DA       macierz_zaciskow[rzad]=27;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(27)
	LDI  R31,HIGH(27)
	ST   X+,R30
	ST   X,R31
; 0000 03DB       komunikat_z_czytnika_kodow("86-1833",rzad,0);
	__POINTW1FN _0x0,379
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 03DC 
; 0000 03DD     }
; 0000 03DE if(PORT_CZYTNIK.byte == 0x1C)
_0x35:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1C)
	BRNE _0x36
; 0000 03DF     {
; 0000 03E0       macierz_zaciskow[rzad]=28;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	ST   X+,R30
	ST   X,R31
; 0000 03E1       komunikat_z_czytnika_kodow("86-2180",rzad,1);
	__POINTW1FN _0x0,387
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03E2 
; 0000 03E3     }
; 0000 03E4 if(PORT_CZYTNIK.byte == 0x1D)
_0x36:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1D)
	BRNE _0x37
; 0000 03E5     {
; 0000 03E6       macierz_zaciskow[rzad]=29;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	ST   X+,R30
	ST   X,R31
; 0000 03E7       komunikat_z_czytnika_kodow("87-0194",rzad,1);
	__POINTW1FN _0x0,395
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03E8 
; 0000 03E9     }
; 0000 03EA 
; 0000 03EB if(PORT_CZYTNIK.byte == 0x1E)
_0x37:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1E)
	BRNE _0x38
; 0000 03EC     {
; 0000 03ED       macierz_zaciskow[rzad]=30;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   X+,R30
	ST   X,R31
; 0000 03EE       komunikat_z_czytnika_kodow("87-1341",rzad,1);
	__POINTW1FN _0x0,403
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03EF 
; 0000 03F0     }
; 0000 03F1 if(PORT_CZYTNIK.byte == 0x1F)
_0x38:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1F)
	BRNE _0x39
; 0000 03F2     {
; 0000 03F3       macierz_zaciskow[rzad]=31;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	ST   X+,R30
	ST   X,R31
; 0000 03F4       komunikat_z_czytnika_kodow("87-1833",rzad,1);
	__POINTW1FN _0x0,411
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03F5 
; 0000 03F6     }
; 0000 03F7 
; 0000 03F8 if(PORT_CZYTNIK.byte == 0x20)
_0x39:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x20)
	BRNE _0x3A
; 0000 03F9     {
; 0000 03FA       macierz_zaciskow[rzad]=32;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   X+,R30
	ST   X,R31
; 0000 03FB       komunikat_z_czytnika_kodow("87-2180",rzad,0);
	__POINTW1FN _0x0,419
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 03FC 
; 0000 03FD     }
; 0000 03FE if(PORT_CZYTNIK.byte == 0x21)
_0x3A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x21)
	BRNE _0x3B
; 0000 03FF     {
; 0000 0400       macierz_zaciskow[rzad]=33;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	ST   X+,R30
	ST   X,R31
; 0000 0401       komunikat_z_czytnika_kodow("86-0663",rzad,1);
	__POINTW1FN _0x0,427
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0402 
; 0000 0403     }
; 0000 0404 
; 0000 0405 if(PORT_CZYTNIK.byte == 0x22)
_0x3B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x22)
	BRNE _0x3C
; 0000 0406     {
; 0000 0407       macierz_zaciskow[rzad]=34;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	ST   X+,R30
	ST   X,R31
; 0000 0408       komunikat_z_czytnika_kodow("86-1349",rzad,0);
	__POINTW1FN _0x0,435
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0409 
; 0000 040A     }
; 0000 040B if(PORT_CZYTNIK.byte == 0x23)
_0x3C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x23)
	BRNE _0x3D
; 0000 040C     {
; 0000 040D       macierz_zaciskow[rzad]=35;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	ST   X+,R30
	ST   X,R31
; 0000 040E       komunikat_z_czytnika_kodow("86-1834",rzad,0);
	__POINTW1FN _0x0,443
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 040F 
; 0000 0410     }
; 0000 0411 if(PORT_CZYTNIK.byte == 0x24)
_0x3D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x24)
	BRNE _0x3E
; 0000 0412     {
; 0000 0413       macierz_zaciskow[rzad]=36;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	ST   X+,R30
	ST   X,R31
; 0000 0414       komunikat_z_czytnika_kodow("86-2204",rzad,0);
	__POINTW1FN _0x0,451
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0415 
; 0000 0416     }
; 0000 0417 if(PORT_CZYTNIK.byte == 0x25)
_0x3E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x25)
	BRNE _0x3F
; 0000 0418     {
; 0000 0419       macierz_zaciskow[rzad]=37;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(37)
	LDI  R31,HIGH(37)
	ST   X+,R30
	ST   X,R31
; 0000 041A       komunikat_z_czytnika_kodow("87-0663",rzad,0);
	__POINTW1FN _0x0,459
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 041B 
; 0000 041C     }
; 0000 041D if(PORT_CZYTNIK.byte == 0x26)
_0x3F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x26)
	BRNE _0x40
; 0000 041E     {
; 0000 041F       macierz_zaciskow[rzad]=38;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	ST   X+,R30
	ST   X,R31
; 0000 0420       komunikat_z_czytnika_kodow("87-1349",rzad,1);
	__POINTW1FN _0x0,467
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0421 
; 0000 0422     }
; 0000 0423 if(PORT_CZYTNIK.byte == 0x27)
_0x40:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x27)
	BRNE _0x41
; 0000 0424     {
; 0000 0425       macierz_zaciskow[rzad]=39;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(39)
	LDI  R31,HIGH(39)
	ST   X+,R30
	ST   X,R31
; 0000 0426       komunikat_z_czytnika_kodow("87-1834",rzad,1);
	__POINTW1FN _0x0,475
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0427 
; 0000 0428     }
; 0000 0429 if(PORT_CZYTNIK.byte == 0x28)
_0x41:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x28)
	BRNE _0x42
; 0000 042A     {
; 0000 042B       macierz_zaciskow[rzad]=40;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   X+,R30
	ST   X,R31
; 0000 042C       komunikat_z_czytnika_kodow("87-2204",rzad,1);
	__POINTW1FN _0x0,483
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 042D 
; 0000 042E     }
; 0000 042F if(PORT_CZYTNIK.byte == 0x29)
_0x42:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x29)
	BRNE _0x43
; 0000 0430     {
; 0000 0431       macierz_zaciskow[rzad]=41;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	ST   X+,R30
	ST   X,R31
; 0000 0432       komunikat_z_czytnika_kodow("86-0768",rzad,1);
	__POINTW1FN _0x0,491
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0433 
; 0000 0434     }
; 0000 0435 if(PORT_CZYTNIK.byte == 0x2A)
_0x43:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2A)
	BRNE _0x44
; 0000 0436     {
; 0000 0437       macierz_zaciskow[rzad]=42;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   X+,R30
	ST   X,R31
; 0000 0438       komunikat_z_czytnika_kodow("86-1357",rzad,0);
	__POINTW1FN _0x0,499
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0439 
; 0000 043A     }
; 0000 043B if(PORT_CZYTNIK.byte == 0x2B)
_0x44:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2B)
	BRNE _0x45
; 0000 043C     {
; 0000 043D       macierz_zaciskow[rzad]=43;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	ST   X+,R30
	ST   X,R31
; 0000 043E       komunikat_z_czytnika_kodow("86-1848",rzad,0);
	__POINTW1FN _0x0,507
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 043F 
; 0000 0440     }
; 0000 0441 if(PORT_CZYTNIK.byte == 0x2C)
_0x45:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2C)
	BRNE _0x46
; 0000 0442     {
; 0000 0443      macierz_zaciskow[rzad]=44;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x35
; 0000 0444       macierz_zaciskow[rzad]=0;   ////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x36
; 0000 0445 
; 0000 0446      komunikat_z_czytnika_kodow("86-2212",rzad,0);
	__POINTW1FN _0x0,515
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0447 
; 0000 0448     }
; 0000 0449 if(PORT_CZYTNIK.byte == 0x2D)
_0x46:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2D)
	BRNE _0x47
; 0000 044A     {
; 0000 044B       macierz_zaciskow[rzad]=45;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	ST   X+,R30
	ST   X,R31
; 0000 044C       komunikat_z_czytnika_kodow("87-0768",rzad,0);
	__POINTW1FN _0x0,523
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 044D 
; 0000 044E     }
; 0000 044F if(PORT_CZYTNIK.byte == 0x2E)
_0x47:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2E)
	BRNE _0x48
; 0000 0450     {
; 0000 0451       macierz_zaciskow[rzad]=46;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	ST   X+,R30
	ST   X,R31
; 0000 0452       komunikat_z_czytnika_kodow("87-1357",rzad,1);
	__POINTW1FN _0x0,531
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0453 
; 0000 0454     }
; 0000 0455 if(PORT_CZYTNIK.byte == 0x2F)
_0x48:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2F)
	BRNE _0x49
; 0000 0456     {
; 0000 0457       macierz_zaciskow[rzad]=47;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	ST   X+,R30
	ST   X,R31
; 0000 0458       komunikat_z_czytnika_kodow("87-1848",rzad,1);
	__POINTW1FN _0x0,539
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0459 
; 0000 045A     }
; 0000 045B if(PORT_CZYTNIK.byte == 0x30)
_0x49:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x30)
	BRNE _0x4A
; 0000 045C     {
; 0000 045D       macierz_zaciskow[rzad]=48;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x35
; 0000 045E       macierz_zaciskow[rzad]=0;    /////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x36
; 0000 045F       komunikat_z_czytnika_kodow("87-2212",rzad,1);
	__POINTW1FN _0x0,547
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0460 
; 0000 0461     }
; 0000 0462 if(PORT_CZYTNIK.byte == 0x31)
_0x4A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x31)
	BRNE _0x4B
; 0000 0463     {
; 0000 0464       macierz_zaciskow[rzad]=49;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	ST   X+,R30
	ST   X,R31
; 0000 0465       komunikat_z_czytnika_kodow("86-0800",rzad,0);
	__POINTW1FN _0x0,555
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0466 
; 0000 0467     }
; 0000 0468 if(PORT_CZYTNIK.byte == 0x32)
_0x4B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x32)
	BRNE _0x4C
; 0000 0469     {
; 0000 046A       macierz_zaciskow[rzad]=50;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   X+,R30
	ST   X,R31
; 0000 046B       komunikat_z_czytnika_kodow("86-1363",rzad,0);
	__POINTW1FN _0x0,563
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 046C 
; 0000 046D     }
; 0000 046E if(PORT_CZYTNIK.byte == 0x33)
_0x4C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x33)
	BRNE _0x4D
; 0000 046F     {
; 0000 0470       macierz_zaciskow[rzad]=51;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	ST   X+,R30
	ST   X,R31
; 0000 0471       komunikat_z_czytnika_kodow("86-1904",rzad,0);
	__POINTW1FN _0x0,571
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0472 
; 0000 0473     }
; 0000 0474 if(PORT_CZYTNIK.byte == 0x34)
_0x4D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x34)
	BRNE _0x4E
; 0000 0475     {
; 0000 0476       macierz_zaciskow[rzad]=52;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	ST   X+,R30
	ST   X,R31
; 0000 0477       komunikat_z_czytnika_kodow("86-2241",rzad,1);
	__POINTW1FN _0x0,579
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0478 
; 0000 0479     }
; 0000 047A if(PORT_CZYTNIK.byte == 0x35)
_0x4E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x35)
	BRNE _0x4F
; 0000 047B     {
; 0000 047C       macierz_zaciskow[rzad]=53;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(53)
	LDI  R31,HIGH(53)
	ST   X+,R30
	ST   X,R31
; 0000 047D       komunikat_z_czytnika_kodow("87-0800",rzad,1);
	__POINTW1FN _0x0,587
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 047E 
; 0000 047F     }
; 0000 0480 
; 0000 0481 if(PORT_CZYTNIK.byte == 0x36)
_0x4F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x36)
	BRNE _0x50
; 0000 0482     {
; 0000 0483       macierz_zaciskow[rzad]=54;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	ST   X+,R30
	ST   X,R31
; 0000 0484       komunikat_z_czytnika_kodow("87-1363",rzad,1);
	__POINTW1FN _0x0,595
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0485 
; 0000 0486     }
; 0000 0487 if(PORT_CZYTNIK.byte == 0x37)
_0x50:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x37)
	BRNE _0x51
; 0000 0488     {
; 0000 0489       macierz_zaciskow[rzad]=55;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	ST   X+,R30
	ST   X,R31
; 0000 048A       komunikat_z_czytnika_kodow("87-1904",rzad,1);
	__POINTW1FN _0x0,603
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 048B 
; 0000 048C     }
; 0000 048D if(PORT_CZYTNIK.byte == 0x38)
_0x51:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x38)
	BRNE _0x52
; 0000 048E     {
; 0000 048F       macierz_zaciskow[rzad]=56;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	ST   X+,R30
	ST   X,R31
; 0000 0490       komunikat_z_czytnika_kodow("87-2241",rzad,0);
	__POINTW1FN _0x0,611
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0491 
; 0000 0492     }
; 0000 0493 if(PORT_CZYTNIK.byte == 0x39)
_0x52:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x39)
	BRNE _0x53
; 0000 0494     {
; 0000 0495       macierz_zaciskow[rzad]=57;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(57)
	LDI  R31,HIGH(57)
	ST   X+,R30
	ST   X,R31
; 0000 0496       komunikat_z_czytnika_kodow("86-0811",rzad,0);
	__POINTW1FN _0x0,619
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0497 
; 0000 0498     }
; 0000 0499 if(PORT_CZYTNIK.byte == 0x3A)
_0x53:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3A)
	BRNE _0x54
; 0000 049A     {
; 0000 049B       macierz_zaciskow[rzad]=58;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	ST   X+,R30
	ST   X,R31
; 0000 049C       komunikat_z_czytnika_kodow("86-1523",rzad,0);
	__POINTW1FN _0x0,627
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 049D 
; 0000 049E     }
; 0000 049F if(PORT_CZYTNIK.byte == 0x3B)
_0x54:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3B)
	BRNE _0x55
; 0000 04A0     {
; 0000 04A1       macierz_zaciskow[rzad]=59;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	ST   X+,R30
	ST   X,R31
; 0000 04A2       komunikat_z_czytnika_kodow("86-1929",rzad,0);
	__POINTW1FN _0x0,635
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 04A3 
; 0000 04A4     }
; 0000 04A5 if(PORT_CZYTNIK.byte == 0x3C)
_0x55:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3C)
	BRNE _0x56
; 0000 04A6     {
; 0000 04A7       macierz_zaciskow[rzad]=60;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	ST   X+,R30
	ST   X,R31
; 0000 04A8       komunikat_z_czytnika_kodow("86-2261",rzad,0);
	__POINTW1FN _0x0,643
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 04A9 
; 0000 04AA     }
; 0000 04AB if(PORT_CZYTNIK.byte == 0x3D)
_0x56:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3D)
	BRNE _0x57
; 0000 04AC     {
; 0000 04AD       macierz_zaciskow[rzad]=61;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	ST   X+,R30
	ST   X,R31
; 0000 04AE       komunikat_z_czytnika_kodow("87-0811",rzad,1);
	__POINTW1FN _0x0,651
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04AF 
; 0000 04B0     }
; 0000 04B1 if(PORT_CZYTNIK.byte == 0x3E)
_0x57:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3E)
	BRNE _0x58
; 0000 04B2     {
; 0000 04B3       macierz_zaciskow[rzad]=62;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	ST   X+,R30
	ST   X,R31
; 0000 04B4       komunikat_z_czytnika_kodow("87-1523",rzad,1);
	__POINTW1FN _0x0,659
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04B5 
; 0000 04B6     }
; 0000 04B7 if(PORT_CZYTNIK.byte == 0x3F)
_0x58:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3F)
	BRNE _0x59
; 0000 04B8     {
; 0000 04B9       macierz_zaciskow[rzad]=63;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	ST   X+,R30
	ST   X,R31
; 0000 04BA       komunikat_z_czytnika_kodow("87-1929",rzad,1);
	__POINTW1FN _0x0,667
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04BB 
; 0000 04BC     }
; 0000 04BD if(PORT_CZYTNIK.byte == 0x40)
_0x59:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x40)
	BRNE _0x5A
; 0000 04BE     {
; 0000 04BF       macierz_zaciskow[rzad]=64;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   X+,R30
	ST   X,R31
; 0000 04C0       komunikat_z_czytnika_kodow("87-2261",rzad,1);
	__POINTW1FN _0x0,675
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04C1 
; 0000 04C2     }
; 0000 04C3 if(PORT_CZYTNIK.byte == 0x41)
_0x5A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x41)
	BRNE _0x5B
; 0000 04C4     {
; 0000 04C5       macierz_zaciskow[rzad]=65;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   X+,R30
	ST   X,R31
; 0000 04C6       komunikat_z_czytnika_kodow("86-0814",rzad,0);
	__POINTW1FN _0x0,683
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 04C7 
; 0000 04C8     }
; 0000 04C9 if(PORT_CZYTNIK.byte == 0x42)
_0x5B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x42)
	BRNE _0x5C
; 0000 04CA     {
; 0000 04CB       macierz_zaciskow[rzad]=66;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	ST   X+,R30
	ST   X,R31
; 0000 04CC       komunikat_z_czytnika_kodow("86-1530",rzad,1);
	__POINTW1FN _0x0,691
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04CD 
; 0000 04CE     }
; 0000 04CF if(PORT_CZYTNIK.byte == 0x43)
_0x5C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x43)
	BRNE _0x5D
; 0000 04D0     {
; 0000 04D1       macierz_zaciskow[rzad]=67;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(67)
	LDI  R31,HIGH(67)
	ST   X+,R30
	ST   X,R31
; 0000 04D2       komunikat_z_czytnika_kodow("86-1936",rzad,1);
	__POINTW1FN _0x0,699
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04D3 
; 0000 04D4     }
; 0000 04D5 if(PORT_CZYTNIK.byte == 0x44)
_0x5D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x44)
	BRNE _0x5E
; 0000 04D6     {
; 0000 04D7       macierz_zaciskow[rzad]=68;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   X+,R30
	ST   X,R31
; 0000 04D8       komunikat_z_czytnika_kodow("86-2285",rzad,1);
	__POINTW1FN _0x0,707
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04D9 
; 0000 04DA     }
; 0000 04DB if(PORT_CZYTNIK.byte == 0x45)
_0x5E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x45)
	BRNE _0x5F
; 0000 04DC     {
; 0000 04DD       macierz_zaciskow[rzad]=69;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(69)
	LDI  R31,HIGH(69)
	ST   X+,R30
	ST   X,R31
; 0000 04DE       komunikat_z_czytnika_kodow("87-0814",rzad,1);
	__POINTW1FN _0x0,715
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04DF 
; 0000 04E0     }
; 0000 04E1 if(PORT_CZYTNIK.byte == 0x46)
_0x5F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x46)
	BRNE _0x60
; 0000 04E2     {
; 0000 04E3       macierz_zaciskow[rzad]=70;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   X+,R30
	ST   X,R31
; 0000 04E4       komunikat_z_czytnika_kodow("87-1530",rzad,0);
	__POINTW1FN _0x0,723
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 04E5 
; 0000 04E6     }
; 0000 04E7 if(PORT_CZYTNIK.byte == 0x47)
_0x60:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x47)
	BRNE _0x61
; 0000 04E8     {
; 0000 04E9       macierz_zaciskow[rzad]=71;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(71)
	LDI  R31,HIGH(71)
	ST   X+,R30
	ST   X,R31
; 0000 04EA       komunikat_z_czytnika_kodow("87-1936",rzad,0);
	__POINTW1FN _0x0,731
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 04EB 
; 0000 04EC     }
; 0000 04ED if(PORT_CZYTNIK.byte == 0x48)
_0x61:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x48)
	BRNE _0x62
; 0000 04EE     {
; 0000 04EF       macierz_zaciskow[rzad]=72;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	ST   X+,R30
	ST   X,R31
; 0000 04F0       komunikat_z_czytnika_kodow("87-2285",rzad,0);
	__POINTW1FN _0x0,739
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 04F1 
; 0000 04F2     }
; 0000 04F3 if(PORT_CZYTNIK.byte == 0x49)
_0x62:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x49)
	BRNE _0x63
; 0000 04F4     {
; 0000 04F5       macierz_zaciskow[rzad]=73;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(73)
	LDI  R31,HIGH(73)
	ST   X+,R30
	ST   X,R31
; 0000 04F6       komunikat_z_czytnika_kodow("86-0815",rzad,0);
	__POINTW1FN _0x0,747
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 04F7 
; 0000 04F8     }
; 0000 04F9 
; 0000 04FA if(PORT_CZYTNIK.byte == 0x4A)
_0x63:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4A)
	BRNE _0x64
; 0000 04FB     {
; 0000 04FC       macierz_zaciskow[rzad]=74;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	ST   X+,R30
	ST   X,R31
; 0000 04FD       komunikat_z_czytnika_kodow("86-1551",rzad,0);
	__POINTW1FN _0x0,755
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 04FE 
; 0000 04FF     }
; 0000 0500 if(PORT_CZYTNIK.byte == 0x4B)
_0x64:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4B)
	BRNE _0x65
; 0000 0501     {
; 0000 0502       macierz_zaciskow[rzad]=75;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	ST   X+,R30
	ST   X,R31
; 0000 0503       komunikat_z_czytnika_kodow("86-1941",rzad,0);
	__POINTW1FN _0x0,763
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0504 
; 0000 0505     }
; 0000 0506 if(PORT_CZYTNIK.byte == 0x4C)
_0x65:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4C)
	BRNE _0x66
; 0000 0507     {
; 0000 0508       macierz_zaciskow[rzad]=76;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x35
; 0000 0509       macierz_zaciskow[rzad]=0;    ////////////////////////////////brak zacisku
	CALL SUBOPT_0x36
; 0000 050A       komunikat_z_czytnika_kodow("86-2286",rzad,0);
	__POINTW1FN _0x0,771
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 050B 
; 0000 050C     }
; 0000 050D if(PORT_CZYTNIK.byte == 0x4D)
_0x66:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4D)
	BRNE _0x67
; 0000 050E     {
; 0000 050F       macierz_zaciskow[rzad]=77;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(77)
	LDI  R31,HIGH(77)
	ST   X+,R30
	ST   X,R31
; 0000 0510       komunikat_z_czytnika_kodow("87-0815",rzad,1);
	__POINTW1FN _0x0,779
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0511 
; 0000 0512     }
; 0000 0513 if(PORT_CZYTNIK.byte == 0x4E)
_0x67:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4E)
	BRNE _0x68
; 0000 0514     {
; 0000 0515       macierz_zaciskow[rzad]=78;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	ST   X+,R30
	ST   X,R31
; 0000 0516       komunikat_z_czytnika_kodow("87-1551",rzad,1);
	__POINTW1FN _0x0,787
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0517 
; 0000 0518     }
; 0000 0519 if(PORT_CZYTNIK.byte == 0x4F)
_0x68:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4F)
	BRNE _0x69
; 0000 051A     {
; 0000 051B       macierz_zaciskow[rzad]=79;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(79)
	LDI  R31,HIGH(79)
	ST   X+,R30
	ST   X,R31
; 0000 051C       komunikat_z_czytnika_kodow("87-1941",rzad,1);
	__POINTW1FN _0x0,795
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 051D 
; 0000 051E     }
; 0000 051F if(PORT_CZYTNIK.byte == 0x50)
_0x69:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x50)
	BRNE _0x6A
; 0000 0520     {
; 0000 0521       macierz_zaciskow[rzad]=80;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x35
; 0000 0522       macierz_zaciskow[rzad]=0;  ////////////////////////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x36
; 0000 0523       komunikat_z_czytnika_kodow("87-2286",rzad,0);
	__POINTW1FN _0x0,803
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0524 
; 0000 0525     }
; 0000 0526 if(PORT_CZYTNIK.byte == 0x51)
_0x6A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x51)
	BRNE _0x6B
; 0000 0527     {
; 0000 0528       macierz_zaciskow[rzad]=81;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(81)
	LDI  R31,HIGH(81)
	ST   X+,R30
	ST   X,R31
; 0000 0529       komunikat_z_czytnika_kodow("86-0816",rzad,0);
	__POINTW1FN _0x0,811
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 052A 
; 0000 052B     }
; 0000 052C if(PORT_CZYTNIK.byte == 0x52)
_0x6B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x52)
	BRNE _0x6C
; 0000 052D     {
; 0000 052E       macierz_zaciskow[rzad]=82;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	ST   X+,R30
	ST   X,R31
; 0000 052F       komunikat_z_czytnika_kodow("86-1552",rzad,0);
	__POINTW1FN _0x0,819
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0530 
; 0000 0531     }
; 0000 0532 if(PORT_CZYTNIK.byte == 0x53)
_0x6C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x53)
	BRNE _0x6D
; 0000 0533     {
; 0000 0534       macierz_zaciskow[rzad]=83;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	ST   X+,R30
	ST   X,R31
; 0000 0535       komunikat_z_czytnika_kodow("86-2007",rzad,1);
	__POINTW1FN _0x0,827
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0536 
; 0000 0537     }
; 0000 0538 if(PORT_CZYTNIK.byte == 0x54)
_0x6D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x54)
	BRNE _0x6E
; 0000 0539     {
; 0000 053A       macierz_zaciskow[rzad]=84;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	ST   X+,R30
	ST   X,R31
; 0000 053B       komunikat_z_czytnika_kodow("86-2292",rzad,1);
	__POINTW1FN _0x0,835
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 053C 
; 0000 053D     }
; 0000 053E if(PORT_CZYTNIK.byte == 0x55)
_0x6E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x55)
	BRNE _0x6F
; 0000 053F     {
; 0000 0540       macierz_zaciskow[rzad]=85;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	ST   X+,R30
	ST   X,R31
; 0000 0541       komunikat_z_czytnika_kodow("87-0816",rzad,1);
	__POINTW1FN _0x0,843
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0542 
; 0000 0543      }
; 0000 0544 if(PORT_CZYTNIK.byte == 0x56)
_0x6F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x56)
	BRNE _0x70
; 0000 0545     {
; 0000 0546       macierz_zaciskow[rzad]=86;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	ST   X+,R30
	ST   X,R31
; 0000 0547       komunikat_z_czytnika_kodow("87-1552",rzad,1);
	__POINTW1FN _0x0,851
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0548 
; 0000 0549     }
; 0000 054A if(PORT_CZYTNIK.byte == 0x57)
_0x70:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x57)
	BRNE _0x71
; 0000 054B     {
; 0000 054C       macierz_zaciskow[rzad]=87;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(87)
	LDI  R31,HIGH(87)
	ST   X+,R30
	ST   X,R31
; 0000 054D       komunikat_z_czytnika_kodow("87-2007",rzad,0);
	__POINTW1FN _0x0,859
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 054E 
; 0000 054F     }
; 0000 0550 if(PORT_CZYTNIK.byte == 0x58)
_0x71:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x58)
	BRNE _0x72
; 0000 0551     {
; 0000 0552       macierz_zaciskow[rzad]=88;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	ST   X+,R30
	ST   X,R31
; 0000 0553       komunikat_z_czytnika_kodow("87-2292",rzad,0);
	__POINTW1FN _0x0,867
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 0554 
; 0000 0555     }
; 0000 0556 if(PORT_CZYTNIK.byte == 0x59)
_0x72:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x59)
	BRNE _0x73
; 0000 0557     {
; 0000 0558       macierz_zaciskow[rzad]=89;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(89)
	LDI  R31,HIGH(89)
	ST   X+,R30
	ST   X,R31
; 0000 0559       komunikat_z_czytnika_kodow("86-0817",rzad,0);
	__POINTW1FN _0x0,875
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	RCALL _komunikat_z_czytnika_kodow
; 0000 055A 
; 0000 055B     }
; 0000 055C if(PORT_CZYTNIK.byte == 0x5A)
_0x73:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5A)
	BRNE _0x74
; 0000 055D     {
; 0000 055E       macierz_zaciskow[rzad]=90;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   X+,R30
	ST   X,R31
; 0000 055F       komunikat_z_czytnika_kodow("86-1602",rzad,1);
	__POINTW1FN _0x0,883
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0560 
; 0000 0561     }
; 0000 0562 if(PORT_CZYTNIK.byte == 0x5B)
_0x74:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5B)
	BRNE _0x75
; 0000 0563     {
; 0000 0564       macierz_zaciskow[rzad]=91;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	ST   X+,R30
	ST   X,R31
; 0000 0565       komunikat_z_czytnika_kodow("86-2017",rzad,1);
	__POINTW1FN _0x0,891
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0566 
; 0000 0567     }
; 0000 0568 if(PORT_CZYTNIK.byte == 0x5C)
_0x75:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5C)
	BRNE _0x76
; 0000 0569     {
; 0000 056A       macierz_zaciskow[rzad]=92;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x35
; 0000 056B       macierz_zaciskow[rzad]=0;           /////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x36
; 0000 056C       komunikat_z_czytnika_kodow("86-2384",rzad,0);
	__POINTW1FN _0x0,899
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 056D 
; 0000 056E     }
; 0000 056F if(PORT_CZYTNIK.byte == 0x5D)
_0x76:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5D)
	BRNE _0x77
; 0000 0570     {
; 0000 0571       macierz_zaciskow[rzad]=93;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(93)
	LDI  R31,HIGH(93)
	ST   X+,R30
	ST   X,R31
; 0000 0572       komunikat_z_czytnika_kodow("87-0817",rzad,1);
	__POINTW1FN _0x0,907
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0573 
; 0000 0574     }
; 0000 0575 if(PORT_CZYTNIK.byte == 0x5E)
_0x77:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5E)
	BRNE _0x78
; 0000 0576     {
; 0000 0577       macierz_zaciskow[rzad]=94;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	ST   X+,R30
	ST   X,R31
; 0000 0578       komunikat_z_czytnika_kodow("87-1602",rzad,0);
	__POINTW1FN _0x0,915
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 0579 
; 0000 057A     }
; 0000 057B if(PORT_CZYTNIK.byte == 0x5F)
_0x78:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5F)
	BRNE _0x79
; 0000 057C     {
; 0000 057D       macierz_zaciskow[rzad]=95;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(95)
	LDI  R31,HIGH(95)
	ST   X+,R30
	ST   X,R31
; 0000 057E       komunikat_z_czytnika_kodow("87-2017",rzad,0);
	__POINTW1FN _0x0,923
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 057F 
; 0000 0580     }
; 0000 0581 if(PORT_CZYTNIK.byte == 0x60)
_0x79:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x60)
	BRNE _0x7A
; 0000 0582     {
; 0000 0583       macierz_zaciskow[rzad]=96;   ///////////////////////////////////////////////brak zacisku
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x35
; 0000 0584       macierz_zaciskow[rzad]=0;
	CALL SUBOPT_0x36
; 0000 0585       komunikat_z_czytnika_kodow("87-2384",rzad,0);
	__POINTW1FN _0x0,931
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 0586 
; 0000 0587     }
; 0000 0588 
; 0000 0589 if(PORT_CZYTNIK.byte == 0x61)
_0x7A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x61)
	BRNE _0x7B
; 0000 058A     {
; 0000 058B       macierz_zaciskow[rzad]=97;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(97)
	LDI  R31,HIGH(97)
	ST   X+,R30
	ST   X,R31
; 0000 058C       komunikat_z_czytnika_kodow("86-0847",rzad,0);
	__POINTW1FN _0x0,939
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 058D 
; 0000 058E     }
; 0000 058F 
; 0000 0590 if(PORT_CZYTNIK.byte == 0x62)
_0x7B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x62)
	BRNE _0x7C
; 0000 0591     {
; 0000 0592       macierz_zaciskow[rzad]=98;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	ST   X+,R30
	ST   X,R31
; 0000 0593       komunikat_z_czytnika_kodow("86-1620",rzad,0);
	__POINTW1FN _0x0,947
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 0594 
; 0000 0595     }
; 0000 0596 if(PORT_CZYTNIK.byte == 0x63)
_0x7C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x63)
	BRNE _0x7D
; 0000 0597     {
; 0000 0598       macierz_zaciskow[rzad]=99;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	ST   X+,R30
	ST   X,R31
; 0000 0599       komunikat_z_czytnika_kodow("86-2019",rzad,1);
	__POINTW1FN _0x0,955
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 059A 
; 0000 059B     }
; 0000 059C if(PORT_CZYTNIK.byte == 0x64)
_0x7D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x64)
	BRNE _0x7E
; 0000 059D     {
; 0000 059E       macierz_zaciskow[rzad]=100;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   X+,R30
	ST   X,R31
; 0000 059F       komunikat_z_czytnika_kodow("86-2385",rzad,0);
	__POINTW1FN _0x0,963
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 05A0 
; 0000 05A1     }
; 0000 05A2 if(PORT_CZYTNIK.byte == 0x65)
_0x7E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x65)
	BRNE _0x7F
; 0000 05A3     {
; 0000 05A4       macierz_zaciskow[rzad]=101;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(101)
	LDI  R31,HIGH(101)
	ST   X+,R30
	ST   X,R31
; 0000 05A5       komunikat_z_czytnika_kodow("87-0847",rzad,1);
	__POINTW1FN _0x0,971
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 05A6 
; 0000 05A7     }
; 0000 05A8 if(PORT_CZYTNIK.byte == 0x66)
_0x7F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x66)
	BRNE _0x80
; 0000 05A9     {
; 0000 05AA       macierz_zaciskow[rzad]=102;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	ST   X+,R30
	ST   X,R31
; 0000 05AB       komunikat_z_czytnika_kodow("87-1620",rzad,1);
	__POINTW1FN _0x0,979
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 05AC 
; 0000 05AD     }
; 0000 05AE if(PORT_CZYTNIK.byte == 0x67)
_0x80:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x67)
	BRNE _0x81
; 0000 05AF     {
; 0000 05B0       macierz_zaciskow[rzad]=103;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	ST   X+,R30
	ST   X,R31
; 0000 05B1       komunikat_z_czytnika_kodow("87-2019",rzad,0);
	__POINTW1FN _0x0,987
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 05B2 
; 0000 05B3     }
; 0000 05B4 if(PORT_CZYTNIK.byte == 0x68)
_0x81:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x68)
	BRNE _0x82
; 0000 05B5     {
; 0000 05B6       macierz_zaciskow[rzad]=104;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	ST   X+,R30
	ST   X,R31
; 0000 05B7       komunikat_z_czytnika_kodow("87-2385",rzad,1);
	__POINTW1FN _0x0,995
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 05B8 
; 0000 05B9     }
; 0000 05BA if(PORT_CZYTNIK.byte == 0x69)
_0x82:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x69)
	BRNE _0x83
; 0000 05BB     {
; 0000 05BC       macierz_zaciskow[rzad]=105;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(105)
	LDI  R31,HIGH(105)
	ST   X+,R30
	ST   X,R31
; 0000 05BD       komunikat_z_czytnika_kodow("86-0854",rzad,0);
	__POINTW1FN _0x0,1003
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 05BE 
; 0000 05BF     }
; 0000 05C0 if(PORT_CZYTNIK.byte == 0x6A)
_0x83:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6A)
	BRNE _0x84
; 0000 05C1     {
; 0000 05C2       macierz_zaciskow[rzad]=106;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	ST   X+,R30
	ST   X,R31
; 0000 05C3       komunikat_z_czytnika_kodow("86-1622",rzad,1);
	__POINTW1FN _0x0,1011
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 05C4 
; 0000 05C5     }
; 0000 05C6 if(PORT_CZYTNIK.byte == 0x6B)
_0x84:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6B)
	BRNE _0x85
; 0000 05C7     {
; 0000 05C8       macierz_zaciskow[rzad]=107;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(107)
	LDI  R31,HIGH(107)
	CALL SUBOPT_0x35
; 0000 05C9       macierz_zaciskow[rzad]=0;          //brak zacisku
	CALL SUBOPT_0x36
; 0000 05CA       komunikat_z_czytnika_kodow("86-2028",rzad,0);
	__POINTW1FN _0x0,1019
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 05CB 
; 0000 05CC     }
; 0000 05CD if(PORT_CZYTNIK.byte == 0x6C)
_0x85:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6C)
	BRNE _0x86
; 0000 05CE     {
; 0000 05CF       macierz_zaciskow[rzad]=108;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	ST   X+,R30
	ST   X,R31
; 0000 05D0       komunikat_z_czytnika_kodow("86-2437",rzad,0);
	__POINTW1FN _0x0,1027
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 05D1 
; 0000 05D2     }
; 0000 05D3 if(PORT_CZYTNIK.byte == 0x6D)
_0x86:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6D)
	BRNE _0x87
; 0000 05D4     {
; 0000 05D5       macierz_zaciskow[rzad]=109;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(109)
	LDI  R31,HIGH(109)
	ST   X+,R30
	ST   X,R31
; 0000 05D6       komunikat_z_czytnika_kodow("87-0854",rzad,1);
	__POINTW1FN _0x0,1035
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 05D7 
; 0000 05D8     }
; 0000 05D9 if(PORT_CZYTNIK.byte == 0x6E)
_0x87:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6E)
	BRNE _0x88
; 0000 05DA     {
; 0000 05DB       macierz_zaciskow[rzad]=110;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	ST   X+,R30
	ST   X,R31
; 0000 05DC       komunikat_z_czytnika_kodow("87-1622",rzad,0);
	__POINTW1FN _0x0,1043
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 05DD 
; 0000 05DE     }
; 0000 05DF 
; 0000 05E0 if(PORT_CZYTNIK.byte == 0x6F)
_0x88:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6F)
	BRNE _0x89
; 0000 05E1     {
; 0000 05E2       macierz_zaciskow[rzad]=111;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(111)
	LDI  R31,HIGH(111)
	CALL SUBOPT_0x35
; 0000 05E3       macierz_zaciskow[rzad]=0;      //brak zacisku
	CALL SUBOPT_0x36
; 0000 05E4       komunikat_z_czytnika_kodow("87-2028",rzad,0);
	__POINTW1FN _0x0,1051
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 05E5 
; 0000 05E6     }
; 0000 05E7 
; 0000 05E8 if(PORT_CZYTNIK.byte == 0x70)
_0x89:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x70)
	BRNE _0x8A
; 0000 05E9     {
; 0000 05EA       macierz_zaciskow[rzad]=112;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   X+,R30
	ST   X,R31
; 0000 05EB       komunikat_z_czytnika_kodow("87-2437",rzad,1);
	__POINTW1FN _0x0,1059
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 05EC 
; 0000 05ED     }
; 0000 05EE if(PORT_CZYTNIK.byte == 0x71)
_0x8A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x71)
	BRNE _0x8B
; 0000 05EF     {
; 0000 05F0       macierz_zaciskow[rzad]=113;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   X+,R30
	ST   X,R31
; 0000 05F1       komunikat_z_czytnika_kodow("86-0862",rzad,0);
	__POINTW1FN _0x0,1067
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 05F2 
; 0000 05F3     }
; 0000 05F4 if(PORT_CZYTNIK.byte == 0x72)
_0x8B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x72)
	BRNE _0x8C
; 0000 05F5     {
; 0000 05F6       macierz_zaciskow[rzad]=114;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	ST   X+,R30
	ST   X,R31
; 0000 05F7       komunikat_z_czytnika_kodow("86-1625",rzad,0);
	__POINTW1FN _0x0,1075
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 05F8 
; 0000 05F9     }
; 0000 05FA if(PORT_CZYTNIK.byte == 0x73)
_0x8C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x73)
	BRNE _0x8D
; 0000 05FB     {
; 0000 05FC       macierz_zaciskow[rzad]=115;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(115)
	LDI  R31,HIGH(115)
	ST   X+,R30
	ST   X,R31
; 0000 05FD       komunikat_z_czytnika_kodow("86-2052",rzad,0);
	__POINTW1FN _0x0,1083
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 05FE 
; 0000 05FF     }
; 0000 0600 if(PORT_CZYTNIK.byte == 0x74)
_0x8D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x74)
	BRNE _0x8E
; 0000 0601     {
; 0000 0602       macierz_zaciskow[rzad]=116;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	ST   X+,R30
	ST   X,R31
; 0000 0603       komunikat_z_czytnika_kodow("86-2492",rzad,1);
	__POINTW1FN _0x0,1091
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0604 
; 0000 0605     }
; 0000 0606 if(PORT_CZYTNIK.byte == 0x75)
_0x8E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x75)
	BRNE _0x8F
; 0000 0607     {
; 0000 0608       macierz_zaciskow[rzad]=117;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(117)
	LDI  R31,HIGH(117)
	ST   X+,R30
	ST   X,R31
; 0000 0609       komunikat_z_czytnika_kodow("87-0862",rzad,1);
	__POINTW1FN _0x0,1099
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 060A 
; 0000 060B     }
; 0000 060C if(PORT_CZYTNIK.byte == 0x76)
_0x8F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x76)
	BRNE _0x90
; 0000 060D     {
; 0000 060E       macierz_zaciskow[rzad]=118;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	ST   X+,R30
	ST   X,R31
; 0000 060F       komunikat_z_czytnika_kodow("87-1625",rzad,1);
	__POINTW1FN _0x0,1107
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0610 
; 0000 0611     }
; 0000 0612 if(PORT_CZYTNIK.byte == 0x77)
_0x90:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x77)
	BRNE _0x91
; 0000 0613     {
; 0000 0614       macierz_zaciskow[rzad]=119;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   X+,R30
	ST   X,R31
; 0000 0615       komunikat_z_czytnika_kodow("87-2052",rzad,1);
	__POINTW1FN _0x0,1115
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0616 
; 0000 0617     }
; 0000 0618 if(PORT_CZYTNIK.byte == 0x78)
_0x91:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x78)
	BRNE _0x92
; 0000 0619     {
; 0000 061A       macierz_zaciskow[rzad]=120;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   X+,R30
	ST   X,R31
; 0000 061B       komunikat_z_czytnika_kodow("87-2492",rzad,0);
	__POINTW1FN _0x0,1123
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 061C 
; 0000 061D     }
; 0000 061E if(PORT_CZYTNIK.byte == 0x79)
_0x92:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x79)
	BRNE _0x93
; 0000 061F     {
; 0000 0620       macierz_zaciskow[rzad]=121;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   X+,R30
	ST   X,R31
; 0000 0621       komunikat_z_czytnika_kodow("86-0935",rzad,0);
	__POINTW1FN _0x0,1131
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 0622 
; 0000 0623     }
; 0000 0624 if(PORT_CZYTNIK.byte == 0x7A)
_0x93:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7A)
	BRNE _0x94
; 0000 0625     {
; 0000 0626       macierz_zaciskow[rzad]=122;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	ST   X+,R30
	ST   X,R31
; 0000 0627       komunikat_z_czytnika_kodow("86-1648",rzad,0);
	__POINTW1FN _0x0,1139
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 0628 
; 0000 0629     }
; 0000 062A if(PORT_CZYTNIK.byte == 0x7B)
_0x94:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7B)
	BRNE _0x95
; 0000 062B     {
; 0000 062C       macierz_zaciskow[rzad]=123;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(123)
	LDI  R31,HIGH(123)
	ST   X+,R30
	ST   X,R31
; 0000 062D       komunikat_z_czytnika_kodow("86-2082",rzad,0);
	__POINTW1FN _0x0,1147
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 062E 
; 0000 062F     }
; 0000 0630 if(PORT_CZYTNIK.byte == 0x7C)
_0x95:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7C)
	BRNE _0x96
; 0000 0631     {
; 0000 0632       macierz_zaciskow[rzad]=124;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	ST   X+,R30
	ST   X,R31
; 0000 0633       komunikat_z_czytnika_kodow("86-2500",rzad,0);
	__POINTW1FN _0x0,1155
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 0634 
; 0000 0635     }
; 0000 0636 if(PORT_CZYTNIK.byte == 0x7D)
_0x96:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7D)
	BRNE _0x97
; 0000 0637     {
; 0000 0638       macierz_zaciskow[rzad]=125;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   X+,R30
	ST   X,R31
; 0000 0639       komunikat_z_czytnika_kodow("87-0935",rzad,1);
	__POINTW1FN _0x0,1163
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 063A 
; 0000 063B     }
; 0000 063C if(PORT_CZYTNIK.byte == 0x7E)
_0x97:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7E)
	BRNE _0x98
; 0000 063D     {
; 0000 063E       macierz_zaciskow[rzad]=126;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	ST   X+,R30
	ST   X,R31
; 0000 063F       komunikat_z_czytnika_kodow("87-1648",rzad,1);
	__POINTW1FN _0x0,1171
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0640 
; 0000 0641     }
; 0000 0642 
; 0000 0643 if(PORT_CZYTNIK.byte == 0x7F)
_0x98:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7F)
	BRNE _0x99
; 0000 0644     {
; 0000 0645       macierz_zaciskow[rzad]=127;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	ST   X+,R30
	ST   X,R31
; 0000 0646       komunikat_z_czytnika_kodow("87-2082",rzad,1);
	__POINTW1FN _0x0,1179
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0647 
; 0000 0648     }
; 0000 0649 if(PORT_CZYTNIK.byte == 0x80)
_0x99:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x80)
	BRNE _0x9A
; 0000 064A     {
; 0000 064B       macierz_zaciskow[rzad]=128;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   X+,R30
	ST   X,R31
; 0000 064C       komunikat_z_czytnika_kodow("87-2500",rzad,1);
	__POINTW1FN _0x0,1187
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 064D 
; 0000 064E     }
; 0000 064F if(PORT_CZYTNIK.byte == 0x81)
_0x9A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x81)
	BRNE _0x9B
; 0000 0650     {
; 0000 0651       macierz_zaciskow[rzad]=129;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(129)
	LDI  R31,HIGH(129)
	ST   X+,R30
	ST   X,R31
; 0000 0652       komunikat_z_czytnika_kodow("86-1019",rzad,0);
	__POINTW1FN _0x0,1195
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 0653 
; 0000 0654     }
; 0000 0655 if(PORT_CZYTNIK.byte == 0x82)
_0x9B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x82)
	BRNE _0x9C
; 0000 0656     {
; 0000 0657       macierz_zaciskow[rzad]=130;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	ST   X+,R30
	ST   X,R31
; 0000 0658       komunikat_z_czytnika_kodow("86-1649",rzad,0);
	__POINTW1FN _0x0,1203
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 0659 
; 0000 065A     }
; 0000 065B if(PORT_CZYTNIK.byte == 0x83)
_0x9C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x83)
	BRNE _0x9D
; 0000 065C     {
; 0000 065D       macierz_zaciskow[rzad]=131;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(131)
	LDI  R31,HIGH(131)
	ST   X+,R30
	ST   X,R31
; 0000 065E       komunikat_z_czytnika_kodow("86-2083",rzad,1);
	__POINTW1FN _0x0,1211
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 065F 
; 0000 0660     }
; 0000 0661 if(PORT_CZYTNIK.byte == 0x84)
_0x9D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x84)
	BRNE _0x9E
; 0000 0662     {
; 0000 0663       macierz_zaciskow[rzad]=132;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	ST   X+,R30
	ST   X,R31
; 0000 0664       komunikat_z_czytnika_kodow("86-2585",rzad,0);
	__POINTW1FN _0x0,1219
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 0665 
; 0000 0666     }
; 0000 0667 if(PORT_CZYTNIK.byte == 0x85)
_0x9E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x85)
	BRNE _0x9F
; 0000 0668     {
; 0000 0669       macierz_zaciskow[rzad]=133;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(133)
	LDI  R31,HIGH(133)
	ST   X+,R30
	ST   X,R31
; 0000 066A       komunikat_z_czytnika_kodow("87-1019",rzad,1);
	__POINTW1FN _0x0,1227
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 066B 
; 0000 066C     }
; 0000 066D if(PORT_CZYTNIK.byte == 0x86)
_0x9F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x86)
	BRNE _0xA0
; 0000 066E     {
; 0000 066F       macierz_zaciskow[rzad]=134;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	ST   X+,R30
	ST   X,R31
; 0000 0670       komunikat_z_czytnika_kodow("87-1649",rzad,1);
	__POINTW1FN _0x0,1235
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0671 
; 0000 0672     }
; 0000 0673 if(PORT_CZYTNIK.byte == 0x87)
_0xA0:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x87)
	BRNE _0xA1
; 0000 0674     {
; 0000 0675       macierz_zaciskow[rzad]=135;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(135)
	LDI  R31,HIGH(135)
	ST   X+,R30
	ST   X,R31
; 0000 0676       komunikat_z_czytnika_kodow("87-2083",rzad,0);
	__POINTW1FN _0x0,1243
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 0677 
; 0000 0678     }
; 0000 0679 
; 0000 067A if(PORT_CZYTNIK.byte == 0x88)
_0xA1:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x88)
	BRNE _0xA2
; 0000 067B     {
; 0000 067C       macierz_zaciskow[rzad]=136;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	ST   X+,R30
	ST   X,R31
; 0000 067D       komunikat_z_czytnika_kodow("87-2624",rzad,1);
	__POINTW1FN _0x0,1251
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 067E 
; 0000 067F     }
; 0000 0680 if(PORT_CZYTNIK.byte == 0x89)
_0xA2:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x89)
	BRNE _0xA3
; 0000 0681     {
; 0000 0682       macierz_zaciskow[rzad]=137;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(137)
	LDI  R31,HIGH(137)
	ST   X+,R30
	ST   X,R31
; 0000 0683       komunikat_z_czytnika_kodow("86-1027",rzad,0);
	__POINTW1FN _0x0,1259
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 0684 
; 0000 0685     }
; 0000 0686 if(PORT_CZYTNIK.byte == 0x8A)
_0xA3:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8A)
	BRNE _0xA4
; 0000 0687     {
; 0000 0688       macierz_zaciskow[rzad]=138;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	ST   X+,R30
	ST   X,R31
; 0000 0689       komunikat_z_czytnika_kodow("86-1669",rzad,1);
	__POINTW1FN _0x0,1267
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 068A 
; 0000 068B     }
; 0000 068C if(PORT_CZYTNIK.byte == 0x8B)
_0xA4:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8B)
	BRNE _0xA5
; 0000 068D     {
; 0000 068E       macierz_zaciskow[rzad]=139;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(139)
	LDI  R31,HIGH(139)
	ST   X+,R30
	ST   X,R31
; 0000 068F       komunikat_z_czytnika_kodow("86-2087",rzad,1);
	__POINTW1FN _0x0,1275
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0690 
; 0000 0691     }
; 0000 0692 if(PORT_CZYTNIK.byte == 0x8C)
_0xA5:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8C)
	BRNE _0xA6
; 0000 0693     {
; 0000 0694       macierz_zaciskow[rzad]=140;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	ST   X+,R30
	ST   X,R31
; 0000 0695       komunikat_z_czytnika_kodow("86-2624",rzad,0);
	__POINTW1FN _0x0,1283
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 0696 
; 0000 0697     }
; 0000 0698 if(PORT_CZYTNIK.byte == 0x8D)
_0xA6:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8D)
	BRNE _0xA7
; 0000 0699     {
; 0000 069A       macierz_zaciskow[rzad]=141;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(141)
	LDI  R31,HIGH(141)
	ST   X+,R30
	ST   X,R31
; 0000 069B       komunikat_z_czytnika_kodow("87-1027",rzad,1);
	__POINTW1FN _0x0,1291
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 069C 
; 0000 069D     }
; 0000 069E if(PORT_CZYTNIK.byte == 0x8E)
_0xA7:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8E)
	BRNE _0xA8
; 0000 069F     {
; 0000 06A0       macierz_zaciskow[rzad]=142;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	ST   X+,R30
	ST   X,R31
; 0000 06A1       komunikat_z_czytnika_kodow("87-1669",rzad,0);
	__POINTW1FN _0x0,1299
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 06A2 
; 0000 06A3     }
; 0000 06A4 if(PORT_CZYTNIK.byte == 0x8F)
_0xA8:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8F)
	BRNE _0xA9
; 0000 06A5     {
; 0000 06A6       macierz_zaciskow[rzad]=143;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(143)
	LDI  R31,HIGH(143)
	ST   X+,R30
	ST   X,R31
; 0000 06A7       komunikat_z_czytnika_kodow("87-2087",rzad,0);
	__POINTW1FN _0x0,1307
	CALL SUBOPT_0x33
	CALL SUBOPT_0x1D
	CALL _komunikat_z_czytnika_kodow
; 0000 06A8 
; 0000 06A9     }
; 0000 06AA if(PORT_CZYTNIK.byte == 0x90)
_0xA9:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x90)
	BRNE _0xAA
; 0000 06AB     {
; 0000 06AC       macierz_zaciskow[rzad]=144;
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   X+,R30
	ST   X,R31
; 0000 06AD       komunikat_z_czytnika_kodow("87-2585",rzad,1);
	__POINTW1FN _0x0,1315
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 06AE 
; 0000 06AF     }
; 0000 06B0 
; 0000 06B1 
; 0000 06B2 return rzad;
_0xAA:
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 06B3 }
;
;
;void wybor_linijek_sterownikow(int rzad_local)
; 0000 06B7 {
_wybor_linijek_sterownikow:
; 0000 06B8 //zaczynam od tego
; 0000 06B9 //komentarz: celowo upraszam:
; 0000 06BA //  a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 06BB //a[4] = 0x21;    //ster3 ABS             //krazek scierny
; 0000 06BC 
; 0000 06BD //legenda pierwotna
; 0000 06BE             /*
; 0000 06BF             a[0] = 0x05A;   //ster1
; 0000 06C0             a[1] = a[0]+0x001;                                   //0x05B;   //ster2
; 0000 06C1             a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 06C2             a[3] = 0x11;    //ster4 INV             //druciak
; 0000 06C3             a[4] = a[2];   //0x21;    //ster3 ABS             //krazek scierny
; 0000 06C4             a[5] = 0x196;   //delta okrag
; 0000 06C5             a[6] = a[5]+0x001;            //0x197;   //okrag
; 0000 06C6             a[7] = 0x12;    //ster3 INV             krazek scierny
; 0000 06C7             a[8] = a[6]+0x001;                0x198;   //-delta okrag
; 0000 06C8             a[9] = 0;          //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 06C9             */
; 0000 06CA 
; 0000 06CB 
; 0000 06CC //macierz_zaciskow[rzad_local]
; 0000 06CD //macierz_zaciskow[rzad_local] = 140;
; 0000 06CE 
; 0000 06CF 
; 0000 06D0 
; 0000 06D1 
; 0000 06D2 
; 0000 06D3 
; 0000 06D4 switch(macierz_zaciskow[rzad_local])
;	rzad_local -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0xE
	CALL __GETW1P
; 0000 06D5 {
; 0000 06D6     case 0:
	SBIW R30,0
	BRNE _0xAE
; 0000 06D7 
; 0000 06D8             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 06D9             komunikat_na_panel("Nie wczytano zacisku",adr1,adr2);
	__POINTW1FN _0x0,1323
	CALL SUBOPT_0x37
; 0000 06DA 
; 0000 06DB     break;
	JMP  _0xAD
; 0000 06DC 
; 0000 06DD 
; 0000 06DE      case 1:
_0xAE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xAF
; 0000 06DF 
; 0000 06E0             a[0] = 0x0C8;   //ster1
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x38
; 0000 06E1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 06E2             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3A
; 0000 06E3             a[5] = 0x196;   //delta okrag
; 0000 06E4             a[7] = 0x11;    //ster3 INV krazek scierny
	JMP  _0x465
; 0000 06E5             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 06E6 
; 0000 06E7             a[1] = a[0]+0x001;  //ster2
; 0000 06E8             a[2] = a[4];        //ster4 ABS druciak
; 0000 06E9             a[6] = a[5]+0x001;  //okrag
; 0000 06EA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 06EB 
; 0000 06EC     break;
; 0000 06ED 
; 0000 06EE       case 2:
_0xAF:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB0
; 0000 06EF 
; 0000 06F0             a[0] = 0x110;   //ster1
	LDI  R30,LOW(272)
	LDI  R31,HIGH(272)
	CALL SUBOPT_0x38
; 0000 06F1             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 06F2             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 06F3             a[5] = 0x190;   //delta okrag
; 0000 06F4             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3B
; 0000 06F5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3D
	JMP  _0x466
; 0000 06F6 
; 0000 06F7             a[1] = a[0]+0x001;  //ster2
; 0000 06F8             a[2] = a[4];        //ster4 ABS druciak
; 0000 06F9             a[6] = a[5]+0x001;  //okrag
; 0000 06FA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 06FB 
; 0000 06FC     break;
; 0000 06FD 
; 0000 06FE       case 3:
_0xB0:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xB1
; 0000 06FF 
; 0000 0700             a[0] = 0x07A;   //ster1
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	CALL SUBOPT_0x38
; 0000 0701             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0702             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3E
; 0000 0703             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0704             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0705             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x466
; 0000 0706 
; 0000 0707             a[1] = a[0]+0x001;  //ster2
; 0000 0708             a[2] = a[4];        //ster4 ABS druciak
; 0000 0709             a[6] = a[5]+0x001;  //okrag
; 0000 070A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 070B 
; 0000 070C     break;
; 0000 070D 
; 0000 070E       case 4:
_0xB1:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xB2
; 0000 070F 
; 0000 0710             a[0] = 0x102;   //ster1
	LDI  R30,LOW(258)
	LDI  R31,HIGH(258)
	CALL SUBOPT_0x38
; 0000 0711             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0712             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0713             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0714             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0715             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x466
; 0000 0716 
; 0000 0717             a[1] = a[0]+0x001;  //ster2
; 0000 0718             a[2] = a[4];        //ster4 ABS druciak
; 0000 0719             a[6] = a[5]+0x001;  //okrag
; 0000 071A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 071B 
; 0000 071C     break;
; 0000 071D 
; 0000 071E       case 5:
_0xB2:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xB3
; 0000 071F 
; 0000 0720             a[0] = 0x0B0;   //ster1
	LDI  R30,LOW(176)
	LDI  R31,HIGH(176)
	CALL SUBOPT_0x38
; 0000 0721             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0722             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3A
; 0000 0723             a[5] = 0x196;   //delta okrag
; 0000 0724             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0725             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0726 
; 0000 0727             a[1] = a[0]+0x001;  //ster2
; 0000 0728             a[2] = a[4];        //ster4 ABS druciak
; 0000 0729             a[6] = a[5]+0x001;  //okrag
; 0000 072A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 072B 
; 0000 072C     break;
; 0000 072D 
; 0000 072E       case 6:
_0xB3:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xB4
; 0000 072F 
; 0000 0730             a[0] = 0x0FE;   //ster1
	LDI  R30,LOW(254)
	LDI  R31,HIGH(254)
	CALL SUBOPT_0x38
; 0000 0731             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 0732             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 0733             a[5] = 0x190;   //delta okrag
; 0000 0734             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x465
; 0000 0735             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0736 
; 0000 0737             a[1] = a[0]+0x001;  //ster2
; 0000 0738             a[2] = a[4];        //ster4 ABS druciak
; 0000 0739             a[6] = a[5]+0x001;  //okrag
; 0000 073A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 073B 
; 0000 073C     break;
; 0000 073D 
; 0000 073E 
; 0000 073F       case 7:
_0xB4:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xB5
; 0000 0740 
; 0000 0741             a[0] = 0x078;   //ster1
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x38
; 0000 0742             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0743             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3E
; 0000 0744             a[5] = 0x196;   //delta okrag
	RJMP _0x467
; 0000 0745             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0746             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0747 
; 0000 0748             a[1] = a[0]+0x001;  //ster2
; 0000 0749             a[2] = a[4];        //ster4 ABS druciak
; 0000 074A             a[6] = a[5]+0x001;  //okrag
; 0000 074B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 074C 
; 0000 074D     break;
; 0000 074E 
; 0000 074F 
; 0000 0750       case 8:
_0xB5:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xB6
; 0000 0751 
; 0000 0752             a[0] = 0x0C0;   //ster1
	LDI  R30,LOW(192)
	LDI  R31,HIGH(192)
	CALL SUBOPT_0x38
; 0000 0753             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0754             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0755             a[5] = 0x196;   //delta okrag
	RJMP _0x467
; 0000 0756             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0757             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0758 
; 0000 0759             a[1] = a[0]+0x001;  //ster2
; 0000 075A             a[2] = a[4];        //ster4 ABS druciak
; 0000 075B             a[6] = a[5]+0x001;  //okrag
; 0000 075C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 075D 
; 0000 075E     break;
; 0000 075F 
; 0000 0760 
; 0000 0761       case 9:
_0xB6:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xB7
; 0000 0762 
; 0000 0763             a[0] = 0x018;   //ster1
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL SUBOPT_0x38
; 0000 0764             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0765             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0766             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x42
; 0000 0767             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0768             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0769 
; 0000 076A             a[1] = a[0]+0x001;  //ster2
; 0000 076B             a[2] = a[4];        //ster4 ABS druciak
; 0000 076C             a[6] = a[5]+0x001;  //okrag
; 0000 076D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 076E 
; 0000 076F     break;
; 0000 0770 
; 0000 0771 
; 0000 0772       case 10:
_0xB7:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xB8
; 0000 0773 
; 0000 0774             a[0] = 0x016;   //ster1
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CALL SUBOPT_0x38
; 0000 0775             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0776             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x43
; 0000 0777             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0778             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0779             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 077A 
; 0000 077B             a[1] = a[0]+0x001;  //ster2
; 0000 077C             a[2] = a[4];        //ster4 ABS druciak
; 0000 077D             a[6] = a[5]+0x001;  //okrag
; 0000 077E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 077F 
; 0000 0780     break;
; 0000 0781 
; 0000 0782 
; 0000 0783       case 11:
_0xB8:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xB9
; 0000 0784 
; 0000 0785             a[0] = 0x074;   //ster1
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	CALL SUBOPT_0x38
; 0000 0786             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0787             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0788             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0789             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 078A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 078B 
; 0000 078C             a[1] = a[0]+0x001;  //ster2
; 0000 078D             a[2] = a[4];        //ster4 ABS druciak
; 0000 078E             a[6] = a[5]+0x001;  //okrag
; 0000 078F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0790 
; 0000 0791     break;
; 0000 0792 
; 0000 0793 
; 0000 0794       case 12:
_0xB9:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xBA
; 0000 0795 
; 0000 0796             a[0] = 0x096;   //ster1
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x38
; 0000 0797             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0798             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0799             a[5] = 0x199;   //delta okrag
	RJMP _0x467
; 0000 079A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 079B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 079C 
; 0000 079D             a[1] = a[0]+0x001;  //ster2
; 0000 079E             a[2] = a[4];        //ster4 ABS druciak
; 0000 079F             a[6] = a[5]+0x001;  //okrag
; 0000 07A0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07A1 
; 0000 07A2     break;
; 0000 07A3 
; 0000 07A4 
; 0000 07A5       case 13:
_0xBA:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xBB
; 0000 07A6 
; 0000 07A7             a[0] = 0x01A;   //ster1
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	CALL SUBOPT_0x38
; 0000 07A8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 07A9             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 07AA             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x42
; 0000 07AB             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 07AC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07AD 
; 0000 07AE             a[1] = a[0]+0x001;  //ster2
; 0000 07AF             a[2] = a[4];        //ster4 ABS druciak
; 0000 07B0             a[6] = a[5]+0x001;  //okrag
; 0000 07B1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07B2 
; 0000 07B3     break;
; 0000 07B4 
; 0000 07B5 
; 0000 07B6       case 14:
_0xBB:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xBC
; 0000 07B7 
; 0000 07B8             a[0] = 0x05E;   //ster1
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	CALL SUBOPT_0x38
; 0000 07B9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 07BA             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x43
; 0000 07BB             a[5] = 0x199;   //delta okrag
	RJMP _0x467
; 0000 07BC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07BD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07BE 
; 0000 07BF             a[1] = a[0]+0x001;  //ster2
; 0000 07C0             a[2] = a[4];        //ster4 ABS druciak
; 0000 07C1             a[6] = a[5]+0x001;  //okrag
; 0000 07C2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07C3 
; 0000 07C4     break;
; 0000 07C5 
; 0000 07C6 
; 0000 07C7       case 15:
_0xBC:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xBD
; 0000 07C8 
; 0000 07C9             a[0] = 0x084;   //ster1
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	CALL SUBOPT_0x38
; 0000 07CA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 07CB             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 07CC             a[5] = 0x199;   //delta okrag
	RJMP _0x467
; 0000 07CD             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07CE             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07CF 
; 0000 07D0             a[1] = a[0]+0x001;  //ster2
; 0000 07D1             a[2] = a[4];        //ster4 ABS druciak
; 0000 07D2             a[6] = a[5]+0x001;  //okrag
; 0000 07D3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07D4 
; 0000 07D5     break;
; 0000 07D6 
; 0000 07D7 
; 0000 07D8       case 16:
_0xBD:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xBE
; 0000 07D9 
; 0000 07DA             a[0] = 0x0B8;   //ster1
	LDI  R30,LOW(184)
	LDI  R31,HIGH(184)
	CALL SUBOPT_0x38
; 0000 07DB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 07DC             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x46
; 0000 07DD             a[5] = 0x199;   //delta okrag
; 0000 07DE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07DF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 07E0 
; 0000 07E1             a[1] = a[0]+0x001;  //ster2
; 0000 07E2             a[2] = a[4];        //ster4 ABS druciak
; 0000 07E3             a[6] = a[5]+0x001;  //okrag
; 0000 07E4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07E5 
; 0000 07E6     break;
; 0000 07E7 
; 0000 07E8       case 17:
_0xBE:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xBF
; 0000 07E9 
; 0000 07EA             a[0] = 0x020;   //ster1
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x38
; 0000 07EB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 07EC             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3A
; 0000 07ED             a[5] = 0x196;   //delta okrag
; 0000 07EE             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 07EF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 07F0 
; 0000 07F1             a[1] = a[0]+0x001;  //ster2
; 0000 07F2             a[2] = a[4];        //ster4 ABS druciak
; 0000 07F3             a[6] = a[5]+0x001;  //okrag
; 0000 07F4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07F5 
; 0000 07F6     break;
; 0000 07F7 
; 0000 07F8 
; 0000 07F9       case 18:
_0xBF:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xC0
; 0000 07FA 
; 0000 07FB             a[0] = 0x098;   //ster1
	LDI  R30,LOW(152)
	LDI  R31,HIGH(152)
	CALL SUBOPT_0x38
; 0000 07FC             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 07FD             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 07FE             a[5] = 0x190;   //delta okrag
; 0000 07FF             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3B
; 0000 0800             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3D
	RJMP _0x466
; 0000 0801 
; 0000 0802             a[1] = a[0]+0x001;  //ster2
; 0000 0803             a[2] = a[4];        //ster4 ABS druciak
; 0000 0804             a[6] = a[5]+0x001;  //okrag
; 0000 0805             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0806 
; 0000 0807     break;
; 0000 0808 
; 0000 0809 
; 0000 080A 
; 0000 080B       case 19:
_0xC0:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xC1
; 0000 080C 
; 0000 080D             a[0] = 0x0AA;   //ster1
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	CALL SUBOPT_0x38
; 0000 080E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 080F             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0810             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0811             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0812             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0813 
; 0000 0814             a[1] = a[0]+0x001;  //ster2
; 0000 0815             a[2] = a[4];        //ster4 ABS druciak
; 0000 0816             a[6] = a[5]+0x001;  //okrag
; 0000 0817             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0818 
; 0000 0819     break;
; 0000 081A 
; 0000 081B 
; 0000 081C       case 20:
_0xC1:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0xC2
; 0000 081D 
; 0000 081E             a[0] = 0x042;   //ster1
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	CALL SUBOPT_0x38
; 0000 081F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0820             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0821             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0822             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0823             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0824 
; 0000 0825             a[1] = a[0]+0x001;  //ster2
; 0000 0826             a[2] = a[4];        //ster4 ABS druciak
; 0000 0827             a[6] = a[5]+0x001;  //okrag
; 0000 0828             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0829 
; 0000 082A     break;
; 0000 082B 
; 0000 082C 
; 0000 082D       case 21:
_0xC2:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0xC3
; 0000 082E 
; 0000 082F             a[0] = 0x04E;   //ster1
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	CALL SUBOPT_0x38
; 0000 0830             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0831             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3A
; 0000 0832             a[5] = 0x196;   //delta okrag
; 0000 0833             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0834             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0835 
; 0000 0836             a[1] = a[0]+0x001;  //ster2
; 0000 0837             a[2] = a[4];        //ster4 ABS druciak
; 0000 0838             a[6] = a[5]+0x001;  //okrag
; 0000 0839             a[8] = a[6]+0x001;  //-delta okrag
; 0000 083A 
; 0000 083B     break;
; 0000 083C 
; 0000 083D       case 22:
_0xC3:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0xC4
; 0000 083E 
; 0000 083F             a[0] = 0x0C2;   //ster1
	LDI  R30,LOW(194)
	LDI  R31,HIGH(194)
	CALL SUBOPT_0x38
; 0000 0840             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 0841             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 0842             a[5] = 0x190;   //delta okrag
; 0000 0843             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x465
; 0000 0844             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0845 
; 0000 0846             a[1] = a[0]+0x001;  //ster2
; 0000 0847             a[2] = a[4];        //ster4 ABS druciak
; 0000 0848             a[6] = a[5]+0x001;  //okrag
; 0000 0849             a[8] = a[6]+0x001;  //-delta okrag
; 0000 084A 
; 0000 084B     break;
; 0000 084C 
; 0000 084D 
; 0000 084E       case 23:
_0xC4:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0xC5
; 0000 084F 
; 0000 0850             a[0] = 0x0CE;   //ster1
	LDI  R30,LOW(206)
	LDI  R31,HIGH(206)
	CALL SUBOPT_0x38
; 0000 0851             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0852             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0853             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x467
; 0000 0854             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0855             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0856 
; 0000 0857             a[1] = a[0]+0x001;  //ster2
; 0000 0858             a[2] = a[4];        //ster4 ABS druciak
; 0000 0859             a[6] = a[5]+0x001;  //okrag
; 0000 085A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 085B 
; 0000 085C     break;
; 0000 085D 
; 0000 085E 
; 0000 085F       case 24:
_0xC5:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0xC6
; 0000 0860 
; 0000 0861             a[0] = 0x040;   //ster1
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL SUBOPT_0x38
; 0000 0862             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0863             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0864             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0865             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0866             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0867 
; 0000 0868             a[1] = a[0]+0x001;  //ster2
; 0000 0869             a[2] = a[4];        //ster4 ABS druciak
; 0000 086A             a[6] = a[5]+0x001;  //okrag
; 0000 086B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 086C 
; 0000 086D     break;
; 0000 086E 
; 0000 086F       case 25:
_0xC6:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0xC7
; 0000 0870 
; 0000 0871             a[0] = 0x02E;   //ster1
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	CALL SUBOPT_0x38
; 0000 0872             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0873             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x43
; 0000 0874             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0875             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0876             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0877 
; 0000 0878             a[1] = a[0]+0x001;  //ster2
; 0000 0879             a[2] = a[4];        //ster4 ABS druciak
; 0000 087A             a[6] = a[5]+0x001;  //okrag
; 0000 087B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 087C 
; 0000 087D     break;
; 0000 087E 
; 0000 087F       case 26:
_0xC7:
	CPI  R30,LOW(0x1A)
	LDI  R26,HIGH(0x1A)
	CPC  R31,R26
	BRNE _0xC8
; 0000 0880 
; 0000 0881             a[0] = 0x0FA;   //ster1
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x38
; 0000 0882             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0883             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0884             a[5] = 0x190;   //delta okrag
; 0000 0885             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0886             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0887 
; 0000 0888             a[1] = a[0]+0x001;  //ster2
; 0000 0889             a[2] = a[4];        //ster4 ABS druciak
; 0000 088A             a[6] = a[5]+0x001;  //okrag
; 0000 088B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 088C 
; 0000 088D     break;
; 0000 088E 
; 0000 088F 
; 0000 0890       case 27:
_0xC8:
	CPI  R30,LOW(0x1B)
	LDI  R26,HIGH(0x1B)
	CPC  R31,R26
	BRNE _0xC9
; 0000 0891 
; 0000 0892             a[0] = 0x06C;   //ster1
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	CALL SUBOPT_0x38
; 0000 0893             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0894             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x46
; 0000 0895             a[5] = 0x199;   //delta okrag
; 0000 0896             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0897             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0898 
; 0000 0899             a[1] = a[0]+0x001;  //ster2
; 0000 089A             a[2] = a[4];        //ster4 ABS druciak
; 0000 089B             a[6] = a[5]+0x001;  //okrag
; 0000 089C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 089D 
; 0000 089E     break;
; 0000 089F 
; 0000 08A0 
; 0000 08A1       case 28:
_0xC9:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BRNE _0xCA
; 0000 08A2 
; 0000 08A3             a[0] = 0x0A4;   //ster1
	LDI  R30,LOW(164)
	LDI  R31,HIGH(164)
	CALL SUBOPT_0x38
; 0000 08A4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 08A5             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 08A6             a[5] = 0x199;   //delta okrag
	RJMP _0x467
; 0000 08A7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08A8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08A9 
; 0000 08AA             a[1] = a[0]+0x001;  //ster2
; 0000 08AB             a[2] = a[4];        //ster4 ABS druciak
; 0000 08AC             a[6] = a[5]+0x001;  //okrag
; 0000 08AD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08AE 
; 0000 08AF     break;
; 0000 08B0 
; 0000 08B1       case 29:
_0xCA:
	CPI  R30,LOW(0x1D)
	LDI  R26,HIGH(0x1D)
	CPC  R31,R26
	BRNE _0xCB
; 0000 08B2 
; 0000 08B3             a[0] = 0x02A;   //ster1
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	CALL SUBOPT_0x38
; 0000 08B4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 08B5             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x43
; 0000 08B6             a[5] = 0x199;   //delta okrag
	RJMP _0x467
; 0000 08B7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08B8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08B9 
; 0000 08BA             a[1] = a[0]+0x001;  //ster2
; 0000 08BB             a[2] = a[4];        //ster4 ABS druciak
; 0000 08BC             a[6] = a[5]+0x001;  //okrag
; 0000 08BD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08BE 
; 0000 08BF     break;
; 0000 08C0 
; 0000 08C1       case 30:
_0xCB:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0xCC
; 0000 08C2 
; 0000 08C3             a[0] = 0x094;   //ster1
	LDI  R30,LOW(148)
	LDI  R31,HIGH(148)
	CALL SUBOPT_0x38
; 0000 08C4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 08C5             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 08C6             a[5] = 0x190;   //delta okrag
; 0000 08C7             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 08C8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08C9 
; 0000 08CA             a[1] = a[0]+0x001;  //ster2
; 0000 08CB             a[2] = a[4];        //ster4 ABS druciak
; 0000 08CC             a[6] = a[5]+0x001;  //okrag
; 0000 08CD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08CE 
; 0000 08CF     break;
; 0000 08D0 
; 0000 08D1       case 31:
_0xCC:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0xCD
; 0000 08D2 
; 0000 08D3             a[0] = 0x06E;   //ster1
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	CALL SUBOPT_0x38
; 0000 08D4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 08D5             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4C
; 0000 08D6             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x467
; 0000 08D7             a[7] = 0x12;  //ster3 INV krazek scierny
; 0000 08D8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08D9 
; 0000 08DA             a[1] = a[0]+0x001;  //ster2
; 0000 08DB             a[2] = a[4];        //ster4 ABS druciak
; 0000 08DC             a[6] = a[5]+0x001;  //okrag
; 0000 08DD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08DE 
; 0000 08DF     break;
; 0000 08E0 
; 0000 08E1 
; 0000 08E2        case 32:
_0xCD:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xCE
; 0000 08E3 
; 0000 08E4             a[0] = 0x086;   //ster1
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	CALL SUBOPT_0x38
; 0000 08E5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 08E6             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 08E7             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 08E8             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08E9             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 08EA 
; 0000 08EB             a[1] = a[0]+0x001;  //ster2
; 0000 08EC             a[2] = a[4];        //ster4 ABS druciak
; 0000 08ED             a[6] = a[5]+0x001;  //okrag
; 0000 08EE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08EF 
; 0000 08F0     break;
; 0000 08F1 
; 0000 08F2        case 33:
_0xCE:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0xCF
; 0000 08F3 
; 0000 08F4             a[0] = 0x08E;   //ster1
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	CALL SUBOPT_0x38
; 0000 08F5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 08F6             a[4] = 0x20;    //ster3 ABS krazek scierny
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	RJMP _0x468
; 0000 08F7             a[5] = 0x19C;   //delta okrag
; 0000 08F8             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08F9             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08FA 
; 0000 08FB             a[1] = a[0]+0x001;  //ster2
; 0000 08FC             a[2] = a[4];        //ster4 ABS druciak
; 0000 08FD             a[6] = a[5]+0x001;  //okrag
; 0000 08FE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08FF 
; 0000 0900     break;
; 0000 0901 
; 0000 0902 
; 0000 0903     case 34: //86-1349
_0xCF:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0xD0
; 0000 0904 
; 0000 0905             a[0] = 0x05A;   //ster1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x38
; 0000 0906             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0907             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0908             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0909             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 090A             a[9] = 0;       //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 090B 
; 0000 090C             a[1] = a[0]+0x001;  //ster2
; 0000 090D             a[2] = a[4];        //ster4 ABS druciak
; 0000 090E             a[6] = a[5]+0x001;  //okrag
; 0000 090F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0910 
; 0000 0911     break;
; 0000 0912 
; 0000 0913 
; 0000 0914     case 35:
_0xD0:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0xD1
; 0000 0915 
; 0000 0916             a[0] = 0x0DA;   //ster1
	LDI  R30,LOW(218)
	LDI  R31,HIGH(218)
	CALL SUBOPT_0x38
; 0000 0917             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0918             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0919             a[5] = 0x190;   //delta okrag
; 0000 091A             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 091B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 091C 
; 0000 091D             a[1] = a[0]+0x001;  //ster2
; 0000 091E             a[2] = a[4];        //ster4 ABS druciak
; 0000 091F             a[6] = a[5]+0x001;  //okrag
; 0000 0920             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0921 
; 0000 0922     break;
; 0000 0923 
; 0000 0924          case 36:
_0xD1:
	CPI  R30,LOW(0x24)
	LDI  R26,HIGH(0x24)
	CPC  R31,R26
	BRNE _0xD2
; 0000 0925 
; 0000 0926             a[0] = 0x0A2;   //ster1
	LDI  R30,LOW(162)
	LDI  R31,HIGH(162)
	CALL SUBOPT_0x38
; 0000 0927             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x50
; 0000 0928             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 0929             a[5] = 0x196;   //delta okrag
; 0000 092A             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3B
; 0000 092B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3D
	RJMP _0x466
; 0000 092C 
; 0000 092D             a[1] = a[0]+0x001;  //ster2
; 0000 092E             a[2] = a[4];        //ster4 ABS druciak
; 0000 092F             a[6] = a[5]+0x001;  //okrag
; 0000 0930             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0931 
; 0000 0932     break;
; 0000 0933 
; 0000 0934          case 37:
_0xD2:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0xD3
; 0000 0935 
; 0000 0936             a[0] = 0x104;   //ster1
	LDI  R30,LOW(260)
	LDI  R31,HIGH(260)
	CALL SUBOPT_0x38
; 0000 0937             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0938             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0939             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x51
; 0000 093A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 093B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 093C 
; 0000 093D             a[1] = a[0]+0x001;  //ster2
; 0000 093E             a[2] = a[4];        //ster4 ABS druciak
; 0000 093F             a[6] = a[5]+0x001;  //okrag
; 0000 0940             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0941 
; 0000 0942     break;
; 0000 0943 
; 0000 0944          case 38:
_0xD3:
	CPI  R30,LOW(0x26)
	LDI  R26,HIGH(0x26)
	CPC  R31,R26
	BRNE _0xD4
; 0000 0945 
; 0000 0946             a[0] = 0x036;   //ster1
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	CALL SUBOPT_0x38
; 0000 0947             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0948             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0949             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x467
; 0000 094A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 094B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 094C 
; 0000 094D             a[1] = a[0]+0x001;  //ster2
; 0000 094E             a[2] = a[4];        //ster4 ABS druciak
; 0000 094F             a[6] = a[5]+0x001;  //okrag
; 0000 0950             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0951 
; 0000 0952     break;
; 0000 0953 
; 0000 0954 
; 0000 0955          case 39:
_0xD4:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0xD5
; 0000 0956 
; 0000 0957             a[0] = 0x118;   //ster1
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	CALL SUBOPT_0x38
; 0000 0958             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0959             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 095A             a[5] = 0x190;   //delta okrag
; 0000 095B             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 095C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 095D 
; 0000 095E             a[1] = a[0]+0x001;  //ster2
; 0000 095F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0960             a[6] = a[5]+0x001;  //okrag
; 0000 0961             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0962 
; 0000 0963     break;
; 0000 0964 
; 0000 0965 
; 0000 0966          case 40:
_0xD5:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0xD6
; 0000 0967 
; 0000 0968             a[0] = 0x0A6;   //ster1
	LDI  R30,LOW(166)
	LDI  R31,HIGH(166)
	CALL SUBOPT_0x38
; 0000 0969             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x50
; 0000 096A             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 096B             a[5] = 0x196;   //delta okrag
; 0000 096C             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x465
; 0000 096D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 096E 
; 0000 096F             a[1] = a[0]+0x001;  //ster2
; 0000 0970             a[2] = a[4];        //ster4 ABS druciak
; 0000 0971             a[6] = a[5]+0x001;  //okrag
; 0000 0972             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0973 
; 0000 0974     break;
; 0000 0975 
; 0000 0976          case 41:
_0xD6:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0xD7
; 0000 0977 
; 0000 0978             a[0] = 0x01E;   //ster1
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x38
; 0000 0979             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 097A             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 097B             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x42
; 0000 097C             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 097D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 097E 
; 0000 097F             a[1] = a[0]+0x001;  //ster2
; 0000 0980             a[2] = a[4];        //ster4 ABS druciak
; 0000 0981             a[6] = a[5]+0x001;  //okrag
; 0000 0982             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0983 
; 0000 0984     break;
; 0000 0985 
; 0000 0986 
; 0000 0987          case 42:
_0xD7:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0xD8
; 0000 0988 
; 0000 0989             a[0] = 0x05C;   //ster1
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x38
; 0000 098A             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 098B             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x52
; 0000 098C             a[5] = 0x196;   //delta okrag
; 0000 098D             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 098E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 098F 
; 0000 0990             a[1] = a[0]+0x001;  //ster2
; 0000 0991             a[2] = a[4];        //ster4 ABS druciak
; 0000 0992             a[6] = a[5]+0x001;  //okrag
; 0000 0993             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0994 
; 0000 0995     break;
; 0000 0996 
; 0000 0997 
; 0000 0998          case 43:
_0xD8:
	CPI  R30,LOW(0x2B)
	LDI  R26,HIGH(0x2B)
	CPC  R31,R26
	BRNE _0xD9
; 0000 0999 
; 0000 099A             a[0] = 0x062;   //ster1
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL SUBOPT_0x38
; 0000 099B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 099C             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4C
; 0000 099D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 099E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 099F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 09A0 
; 0000 09A1             a[1] = a[0]+0x001;  //ster2
; 0000 09A2             a[2] = a[4];        //ster4 ABS druciak
; 0000 09A3             a[6] = a[5]+0x001;  //okrag
; 0000 09A4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09A5 
; 0000 09A6     break;
; 0000 09A7 
; 0000 09A8 
; 0000 09A9          case 44:
_0xD9:
	CPI  R30,LOW(0x2C)
	LDI  R26,HIGH(0x2C)
	CPC  R31,R26
	BRNE _0xDA
; 0000 09AA 
; 0000 09AB             a[0] = 0x;   //ster1
	CALL SUBOPT_0x53
; 0000 09AC             a[3] = 0x;    //ster4 INV druciak
; 0000 09AD             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 09AE             a[5] = 0x;   //delta okrag
; 0000 09AF             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 09B0             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 09B1 
; 0000 09B2             a[1] = a[0]+0x001;  //ster2
; 0000 09B3             a[2] = a[4];        //ster4 ABS druciak
; 0000 09B4             a[6] = a[5]+0x001;  //okrag
; 0000 09B5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09B6 
; 0000 09B7     break;
; 0000 09B8 
; 0000 09B9 
; 0000 09BA          case 45:
_0xDA:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0xDB
; 0000 09BB 
; 0000 09BC             a[0] = 0x010;   //ster1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x38
; 0000 09BD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 09BE             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 09BF             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x42
; 0000 09C0             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 09C1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 09C2 
; 0000 09C3             a[1] = a[0]+0x001;  //ster2
; 0000 09C4             a[2] = a[4];        //ster4 ABS druciak
; 0000 09C5             a[6] = a[5]+0x001;  //okrag
; 0000 09C6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09C7 
; 0000 09C8     break;
; 0000 09C9 
; 0000 09CA 
; 0000 09CB     case 46:
_0xDB:
	CPI  R30,LOW(0x2E)
	LDI  R26,HIGH(0x2E)
	CPC  R31,R26
	BRNE _0xDC
; 0000 09CC 
; 0000 09CD             a[0] = 0x050;   //ster1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x38
; 0000 09CE             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 09CF             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x52
; 0000 09D0             a[5] = 0x196;   //delta okrag
; 0000 09D1             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 09D2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09D3 
; 0000 09D4             a[1] = a[0]+0x001;  //ster2
; 0000 09D5             a[2] = a[4];        //ster4 ABS druciak
; 0000 09D6             a[6] = a[5]+0x001;  //okrag
; 0000 09D7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09D8 
; 0000 09D9     break;
; 0000 09DA 
; 0000 09DB 
; 0000 09DC     case 47:
_0xDC:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BRNE _0xDD
; 0000 09DD 
; 0000 09DE             a[0] = 0x068;   //ster1
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	CALL SUBOPT_0x38
; 0000 09DF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 09E0             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4C
; 0000 09E1             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x467
; 0000 09E2             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 09E3             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09E4 
; 0000 09E5             a[1] = a[0]+0x001;  //ster2
; 0000 09E6             a[2] = a[4];        //ster4 ABS druciak
; 0000 09E7             a[6] = a[5]+0x001;  //okrag
; 0000 09E8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09E9 
; 0000 09EA     break;
; 0000 09EB 
; 0000 09EC 
; 0000 09ED 
; 0000 09EE     case 48:
_0xDD:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0xDE
; 0000 09EF 
; 0000 09F0             a[0] = 0x;   //ster1
	CALL SUBOPT_0x53
; 0000 09F1             a[3] = 0x;    //ster4 INV druciak
; 0000 09F2             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 09F3             a[5] = 0x;   //delta okrag
; 0000 09F4             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 09F5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 09F6 
; 0000 09F7             a[1] = a[0]+0x001;  //ster2
; 0000 09F8             a[2] = a[4];        //ster4 ABS druciak
; 0000 09F9             a[6] = a[5]+0x001;  //okrag
; 0000 09FA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09FB 
; 0000 09FC     break;
; 0000 09FD 
; 0000 09FE 
; 0000 09FF     case 49:
_0xDE:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xDF
; 0000 0A00 
; 0000 0A01             a[0] = 0x024;   //ster1
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL SUBOPT_0x38
; 0000 0A02             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0A03             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0A04             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0A05             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A06             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0A07 
; 0000 0A08             a[1] = a[0]+0x001;  //ster2
; 0000 0A09             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A0A             a[6] = a[5]+0x001;  //okrag
; 0000 0A0B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A0C 
; 0000 0A0D     break;
; 0000 0A0E 
; 0000 0A0F 
; 0000 0A10     case 50:
_0xDF:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0xE0
; 0000 0A11 
; 0000 0A12             a[0] = 0x014;   //ster1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x38
; 0000 0A13             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0A14             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0A15             a[5] = 0x190;   //delta okrag
; 0000 0A16             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0A17             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0A18 
; 0000 0A19             a[1] = a[0]+0x001;  //ster2
; 0000 0A1A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A1B             a[6] = a[5]+0x001;  //okrag
; 0000 0A1C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A1D 
; 0000 0A1E     break;
; 0000 0A1F 
; 0000 0A20     case 51:
_0xE0:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0xE1
; 0000 0A21 
; 0000 0A22             a[0] = 0x082;   //ster1
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	CALL SUBOPT_0x38
; 0000 0A23             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0A24             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x54
; 0000 0A25             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x51
; 0000 0A26             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A27             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0A28 
; 0000 0A29             a[1] = a[0]+0x001;  //ster2
; 0000 0A2A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A2B             a[6] = a[5]+0x001;  //okrag
; 0000 0A2C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A2D 
; 0000 0A2E     break;
; 0000 0A2F 
; 0000 0A30     case 52:
_0xE1:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0xE2
; 0000 0A31 
; 0000 0A32             a[0] = 0x106;   //ster1
	LDI  R30,LOW(262)
	LDI  R31,HIGH(262)
	CALL SUBOPT_0x38
; 0000 0A33             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0A34             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0A35             a[5] = 0x190;   //delta okrag
; 0000 0A36             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0A37             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A38 
; 0000 0A39             a[1] = a[0]+0x001;  //ster2
; 0000 0A3A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A3B             a[6] = a[5]+0x001;  //okrag
; 0000 0A3C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A3D 
; 0000 0A3E     break;
; 0000 0A3F 
; 0000 0A40 
; 0000 0A41     case 53:
_0xE2:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0xE3
; 0000 0A42 
; 0000 0A43             a[0] = 0x04C;   //ster1
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x38
; 0000 0A44             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0A45             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0A46             a[5] = 0x196;   //delta okrag
	RJMP _0x467
; 0000 0A47             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A48             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A49 
; 0000 0A4A             a[1] = a[0]+0x001;  //ster2
; 0000 0A4B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A4C             a[6] = a[5]+0x001;  //okrag
; 0000 0A4D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A4E 
; 0000 0A4F     break;
; 0000 0A50 
; 0000 0A51 
; 0000 0A52     case 54:
_0xE3:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0xE4
; 0000 0A53 
; 0000 0A54             a[0] = 0x01C;   //ster1
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	CALL SUBOPT_0x38
; 0000 0A55             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0A56             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0A57             a[5] = 0x190;   //delta okrag
; 0000 0A58             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0A59             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A5A 
; 0000 0A5B             a[1] = a[0]+0x001;  //ster2
; 0000 0A5C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A5D             a[6] = a[5]+0x001;  //okrag
; 0000 0A5E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A5F 
; 0000 0A60     break;
; 0000 0A61 
; 0000 0A62     case 55:
_0xE4:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0xE5
; 0000 0A63 
; 0000 0A64             a[0] = 0x114;   //ster1
	LDI  R30,LOW(276)
	LDI  R31,HIGH(276)
	CALL SUBOPT_0x38
; 0000 0A65             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0A66             a[4] = 0x1A;    //ster3 ABS krazek scierny
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	RJMP _0x468
; 0000 0A67             a[5] = 0x19C;   //delta okrag
; 0000 0A68             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A69             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A6A 
; 0000 0A6B             a[1] = a[0]+0x001;  //ster2
; 0000 0A6C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A6D             a[6] = a[5]+0x001;  //okrag
; 0000 0A6E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A6F 
; 0000 0A70     break;
; 0000 0A71 
; 0000 0A72 
; 0000 0A73     case 56:
_0xE5:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0xE6
; 0000 0A74 
; 0000 0A75             a[0] = 0x0EE;   //ster1
	LDI  R30,LOW(238)
	LDI  R31,HIGH(238)
	CALL SUBOPT_0x38
; 0000 0A76             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0A77             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0A78             a[5] = 0x190;   //delta okrag
; 0000 0A79             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0A7A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0A7B 
; 0000 0A7C             a[1] = a[0]+0x001;  //ster2
; 0000 0A7D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A7E             a[6] = a[5]+0x001;  //okrag
; 0000 0A7F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A80 
; 0000 0A81     break;
; 0000 0A82 
; 0000 0A83 
; 0000 0A84     case 57:
_0xE6:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0xE7
; 0000 0A85 
; 0000 0A86             a[0] = 0x0F8;   //ster1
	LDI  R30,LOW(248)
	LDI  R31,HIGH(248)
	CALL SUBOPT_0x38
; 0000 0A87             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0A88             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 0A89             a[5] = 0x190;   //delta okrag
; 0000 0A8A             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0A8B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0A8C 
; 0000 0A8D             a[1] = a[0]+0x001;  //ster2
; 0000 0A8E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A8F             a[6] = a[5]+0x001;  //okrag
; 0000 0A90             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A91 
; 0000 0A92     break;
; 0000 0A93 
; 0000 0A94 
; 0000 0A95     case 58:
_0xE7:
	CPI  R30,LOW(0x3A)
	LDI  R26,HIGH(0x3A)
	CPC  R31,R26
	BRNE _0xE8
; 0000 0A96 
; 0000 0A97             a[0] = 0x0E4;   //ster1
	LDI  R30,LOW(228)
	LDI  R31,HIGH(228)
	CALL SUBOPT_0x38
; 0000 0A98             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0A99             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4C
; 0000 0A9A             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0A9B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A9C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0A9D 
; 0000 0A9E             a[1] = a[0]+0x001;  //ster2
; 0000 0A9F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AA0             a[6] = a[5]+0x001;  //okrag
; 0000 0AA1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AA2 
; 0000 0AA3     break;
; 0000 0AA4 
; 0000 0AA5 
; 0000 0AA6     case 59:
_0xE8:
	CPI  R30,LOW(0x3B)
	LDI  R26,HIGH(0x3B)
	CPC  R31,R26
	BRNE _0xE9
; 0000 0AA7 
; 0000 0AA8             a[0] = 0x052;   //ster1
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	CALL SUBOPT_0x38
; 0000 0AA9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0AAA             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0AAB             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0AAC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AAD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0AAE 
; 0000 0AAF             a[1] = a[0]+0x001;  //ster2
; 0000 0AB0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AB1             a[6] = a[5]+0x001;  //okrag
; 0000 0AB2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AB3 
; 0000 0AB4     break;
; 0000 0AB5 
; 0000 0AB6 
; 0000 0AB7     case 60:
_0xE9:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BRNE _0xEA
; 0000 0AB8 
; 0000 0AB9             a[0] = 0x090;   //ster1
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0x38
; 0000 0ABA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0ABB             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0ABC             a[5] = 0x190;   //delta okrag
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL SUBOPT_0x42
; 0000 0ABD             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0ABE             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0ABF 
; 0000 0AC0             a[1] = a[0]+0x001;  //ster2
; 0000 0AC1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AC2             a[6] = a[5]+0x001;  //okrag
; 0000 0AC3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AC4 
; 0000 0AC5     break;
; 0000 0AC6 
; 0000 0AC7 
; 0000 0AC8     case 61:
_0xEA:
	CPI  R30,LOW(0x3D)
	LDI  R26,HIGH(0x3D)
	CPC  R31,R26
	BRNE _0xEB
; 0000 0AC9 
; 0000 0ACA             a[0] = 0x0FC;   //ster1
	LDI  R30,LOW(252)
	LDI  R31,HIGH(252)
	CALL SUBOPT_0x38
; 0000 0ACB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0ACC             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0ACD             a[5] = 0x190;   //delta okrag
; 0000 0ACE             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0ACF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AD0 
; 0000 0AD1             a[1] = a[0]+0x001;  //ster2
; 0000 0AD2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AD3             a[6] = a[5]+0x001;  //okrag
; 0000 0AD4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AD5 
; 0000 0AD6     break;
; 0000 0AD7 
; 0000 0AD8 
; 0000 0AD9     case 62:
_0xEB:
	CPI  R30,LOW(0x3E)
	LDI  R26,HIGH(0x3E)
	CPC  R31,R26
	BRNE _0xEC
; 0000 0ADA 
; 0000 0ADB             a[0] = 0x028;   //ster1
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x38
; 0000 0ADC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0ADD             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4C
; 0000 0ADE             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x467
; 0000 0ADF             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AE0             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AE1 
; 0000 0AE2             a[1] = a[0]+0x001;  //ster2
; 0000 0AE3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AE4             a[6] = a[5]+0x001;  //okrag
; 0000 0AE5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AE6 
; 0000 0AE7     break;
; 0000 0AE8 
; 0000 0AE9 
; 0000 0AEA     case 63:
_0xEC:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0xED
; 0000 0AEB 
; 0000 0AEC             a[0] = 0x034;   //ster1
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	CALL SUBOPT_0x38
; 0000 0AED             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0AEE             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0AEF             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x467
; 0000 0AF0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AF1             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AF2 
; 0000 0AF3             a[1] = a[0]+0x001;  //ster2
; 0000 0AF4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AF5             a[6] = a[5]+0x001;  //okrag
; 0000 0AF6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AF7 
; 0000 0AF8     break;
; 0000 0AF9 
; 0000 0AFA 
; 0000 0AFB     case 64:
_0xED:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0xEE
; 0000 0AFC 
; 0000 0AFD             a[0] = 0x0EC;   //ster1
	LDI  R30,LOW(236)
	LDI  R31,HIGH(236)
	CALL SUBOPT_0x38
; 0000 0AFE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0AFF             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 0B00             a[5] = 0x190;   //delta okrag
; 0000 0B01             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0B02             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B03 
; 0000 0B04             a[1] = a[0]+0x001;  //ster2
; 0000 0B05             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B06             a[6] = a[5]+0x001;  //okrag
; 0000 0B07             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B08 
; 0000 0B09     break;
; 0000 0B0A 
; 0000 0B0B 
; 0000 0B0C     case 65:
_0xEE:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0xEF
; 0000 0B0D 
; 0000 0B0E             a[0] = 0x0CC;   //ster1
	LDI  R30,LOW(204)
	LDI  R31,HIGH(204)
	CALL SUBOPT_0x38
; 0000 0B0F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0B10             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0B11             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0B12             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B13             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0B14 
; 0000 0B15             a[1] = a[0]+0x001;  //ster2
; 0000 0B16             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B17             a[6] = a[5]+0x001;  //okrag
; 0000 0B18             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B19 
; 0000 0B1A     break;
; 0000 0B1B 
; 0000 0B1C 
; 0000 0B1D     case 66:
_0xEF:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0xF0
; 0000 0B1E 
; 0000 0B1F             a[0] = 0x0BC;   //ster1
	LDI  R30,LOW(188)
	LDI  R31,HIGH(188)
	CALL SUBOPT_0x38
; 0000 0B20             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0B21             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0B22             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5A
; 0000 0B23             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0B24             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B25 
; 0000 0B26             a[1] = a[0]+0x001;  //ster2
; 0000 0B27             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B28             a[6] = a[5]+0x001;  //okrag
; 0000 0B29             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B2A 
; 0000 0B2B     break;
; 0000 0B2C 
; 0000 0B2D 
; 0000 0B2E     case 67:
_0xF0:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xF1
; 0000 0B2F 
; 0000 0B30             a[0] = 0x09C;   //ster1
	LDI  R30,LOW(156)
	LDI  R31,HIGH(156)
	CALL SUBOPT_0x38
; 0000 0B31             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0B32             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0B33             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x467
; 0000 0B34             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B35             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B36 
; 0000 0B37             a[1] = a[0]+0x001;  //ster2
; 0000 0B38             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B39             a[6] = a[5]+0x001;  //okrag
; 0000 0B3A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B3B 
; 0000 0B3C     break;
; 0000 0B3D 
; 0000 0B3E 
; 0000 0B3F     case 68:
_0xF1:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0xF2
; 0000 0B40 
; 0000 0B41             a[0] = 0x07C;   //ster1
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	CALL SUBOPT_0x38
; 0000 0B42             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0B43             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0B44             a[5] = 0x199;   //delta okrag
	RJMP _0x467
; 0000 0B45             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B46             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B47 
; 0000 0B48             a[1] = a[0]+0x001;  //ster2
; 0000 0B49             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B4A             a[6] = a[5]+0x001;  //okrag
; 0000 0B4B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B4C 
; 0000 0B4D     break;
; 0000 0B4E 
; 0000 0B4F 
; 0000 0B50     case 69:
_0xF2:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BRNE _0xF3
; 0000 0B51 
; 0000 0B52             a[0] = 0x0D2;   //ster1
	LDI  R30,LOW(210)
	LDI  R31,HIGH(210)
	CALL SUBOPT_0x38
; 0000 0B53             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0B54             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0B55             a[5] = 0x193;   //delta okrag
	RJMP _0x467
; 0000 0B56             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B57             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B58 
; 0000 0B59             a[1] = a[0]+0x001;  //ster2
; 0000 0B5A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B5B             a[6] = a[5]+0x001;  //okrag
; 0000 0B5C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B5D 
; 0000 0B5E     break;
; 0000 0B5F 
; 0000 0B60 
; 0000 0B61     case 70:
_0xF3:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BRNE _0xF4
; 0000 0B62 
; 0000 0B63             a[0] = 0x0E6;   //ster1
	LDI  R30,LOW(230)
	LDI  R31,HIGH(230)
	CALL SUBOPT_0x38
; 0000 0B64             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0B65             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0B66             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5A
; 0000 0B67             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0B68             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0B69 
; 0000 0B6A             a[1] = a[0]+0x001;  //ster2
; 0000 0B6B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B6C             a[6] = a[5]+0x001;  //okrag
; 0000 0B6D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B6E 
; 0000 0B6F     break;
; 0000 0B70 
; 0000 0B71 
; 0000 0B72     case 71:
_0xF4:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BRNE _0xF5
; 0000 0B73 
; 0000 0B74             a[0] = 0x0B4;   //ster1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x38
; 0000 0B75             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0B76             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0B77             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0B78             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B79             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0B7A 
; 0000 0B7B             a[1] = a[0]+0x001;  //ster2
; 0000 0B7C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B7D             a[6] = a[5]+0x001;  //okrag
; 0000 0B7E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B7F 
; 0000 0B80     break;
; 0000 0B81 
; 0000 0B82 
; 0000 0B83     case 72:
_0xF5:
	CPI  R30,LOW(0x48)
	LDI  R26,HIGH(0x48)
	CPC  R31,R26
	BRNE _0xF6
; 0000 0B84 
; 0000 0B85             a[0] = 0x0AC;   //ster1
	LDI  R30,LOW(172)
	LDI  R31,HIGH(172)
	CALL SUBOPT_0x38
; 0000 0B86             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0B87             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0B88             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0B89             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B8A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0B8B 
; 0000 0B8C             a[1] = a[0]+0x001;  //ster2
; 0000 0B8D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B8E             a[6] = a[5]+0x001;  //okrag
; 0000 0B8F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B90 
; 0000 0B91     break;
; 0000 0B92 
; 0000 0B93 
; 0000 0B94     case 73:
_0xF6:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BRNE _0xF7
; 0000 0B95 
; 0000 0B96             a[0] = 0x012;   //ster1
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CALL SUBOPT_0x38
; 0000 0B97             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 0B98             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x54
; 0000 0B99             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0B9A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B9B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0B9C 
; 0000 0B9D             a[1] = a[0]+0x001;  //ster2
; 0000 0B9E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B9F             a[6] = a[5]+0x001;  //okrag
; 0000 0BA0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BA1 
; 0000 0BA2     break;
; 0000 0BA3 
; 0000 0BA4 
; 0000 0BA5     case 74:
_0xF7:
	CPI  R30,LOW(0x4A)
	LDI  R26,HIGH(0x4A)
	CPC  R31,R26
	BRNE _0xF8
; 0000 0BA6 
; 0000 0BA7             a[0] = 0x0B2;   //ster1
	LDI  R30,LOW(178)
	LDI  R31,HIGH(178)
	CALL SUBOPT_0x38
; 0000 0BA8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0BA9             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0BAA             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0BAB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BAC             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0BAD 
; 0000 0BAE             a[1] = a[0]+0x001;  //ster2
; 0000 0BAF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BB0             a[6] = a[5]+0x001;  //okrag
; 0000 0BB1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BB2 
; 0000 0BB3     break;
; 0000 0BB4 
; 0000 0BB5 
; 0000 0BB6     case 75:
_0xF8:
	CPI  R30,LOW(0x4B)
	LDI  R26,HIGH(0x4B)
	CPC  R31,R26
	BRNE _0xF9
; 0000 0BB7 
; 0000 0BB8             a[0] = 0x10C;   //ster1
	LDI  R30,LOW(268)
	LDI  R31,HIGH(268)
	CALL SUBOPT_0x38
; 0000 0BB9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0BBA             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0BBB             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0BBC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BBD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0BBE 
; 0000 0BBF             a[1] = a[0]+0x001;  //ster2
; 0000 0BC0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BC1             a[6] = a[5]+0x001;  //okrag
; 0000 0BC2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BC3 
; 0000 0BC4     break;
; 0000 0BC5 
; 0000 0BC6 
; 0000 0BC7     case 76:
_0xF9:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0xFA
; 0000 0BC8 
; 0000 0BC9             a[0] = 0x;   //ster1
	CALL SUBOPT_0x53
; 0000 0BCA             a[3] = 0x;    //ster4 INV druciak
; 0000 0BCB             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0BCC             a[5] = 0x;   //delta okrag
; 0000 0BCD             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0BCE             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0BCF 
; 0000 0BD0             a[1] = a[0]+0x001;  //ster2
; 0000 0BD1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BD2             a[6] = a[5]+0x001;  //okrag
; 0000 0BD3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BD4 
; 0000 0BD5     break;
; 0000 0BD6 
; 0000 0BD7 
; 0000 0BD8     case 77:
_0xFA:
	CPI  R30,LOW(0x4D)
	LDI  R26,HIGH(0x4D)
	CPC  R31,R26
	BRNE _0xFB
; 0000 0BD9 
; 0000 0BDA             a[0] = 0x026;   //ster1
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL SUBOPT_0x38
; 0000 0BDB             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 0BDC             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x54
; 0000 0BDD             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x467
; 0000 0BDE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BDF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0BE0 
; 0000 0BE1             a[1] = a[0]+0x001;  //ster2
; 0000 0BE2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BE3             a[6] = a[5]+0x001;  //okrag
; 0000 0BE4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BE5 
; 0000 0BE6     break;
; 0000 0BE7 
; 0000 0BE8 
; 0000 0BE9     case 78:
_0xFB:
	CPI  R30,LOW(0x4E)
	LDI  R26,HIGH(0x4E)
	CPC  R31,R26
	BRNE _0xFC
; 0000 0BEA 
; 0000 0BEB             a[0] = 0x11C;   //ster1
	LDI  R30,LOW(284)
	LDI  R31,HIGH(284)
	CALL SUBOPT_0x38
; 0000 0BEC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0BED             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0BEE             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x467
; 0000 0BEF             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BF0             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0BF1 
; 0000 0BF2             a[1] = a[0]+0x001;  //ster2
; 0000 0BF3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BF4             a[6] = a[5]+0x001;  //okrag
; 0000 0BF5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BF6 
; 0000 0BF7     break;
; 0000 0BF8 
; 0000 0BF9 
; 0000 0BFA     case 79:
_0xFC:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0xFD
; 0000 0BFB 
; 0000 0BFC             a[0] = 0x112;   //ster1
	LDI  R30,LOW(274)
	LDI  R31,HIGH(274)
	CALL SUBOPT_0x38
; 0000 0BFD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0BFE             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0BFF             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x467
; 0000 0C00             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C01             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C02 
; 0000 0C03             a[1] = a[0]+0x001;  //ster2
; 0000 0C04             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C05             a[6] = a[5]+0x001;  //okrag
; 0000 0C06             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C07 
; 0000 0C08     break;
; 0000 0C09 
; 0000 0C0A     case 80:
_0xFD:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0xFE
; 0000 0C0B 
; 0000 0C0C             a[0] = 0x;   //ster1
	CALL SUBOPT_0x53
; 0000 0C0D             a[3] = 0x;    //ster4 INV druciak
; 0000 0C0E             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0C0F             a[5] = 0x;   //delta okrag
; 0000 0C10             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0C11             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0C12 
; 0000 0C13             a[1] = a[0]+0x001;  //ster2
; 0000 0C14             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C15             a[6] = a[5]+0x001;  //okrag
; 0000 0C16             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C17 
; 0000 0C18     break;
; 0000 0C19 
; 0000 0C1A     case 81:
_0xFE:
	CPI  R30,LOW(0x51)
	LDI  R26,HIGH(0x51)
	CPC  R31,R26
	BRNE _0xFF
; 0000 0C1B 
; 0000 0C1C             a[0] = 0x0EA;   //ster1
	LDI  R30,LOW(234)
	LDI  R31,HIGH(234)
	CALL SUBOPT_0x38
; 0000 0C1D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0C1E             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5C
; 0000 0C1F             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0C20             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C21             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0C22 
; 0000 0C23             a[1] = a[0]+0x001;  //ster2
; 0000 0C24             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C25             a[6] = a[5]+0x001;  //okrag
; 0000 0C26             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C27 
; 0000 0C28     break;
; 0000 0C29 
; 0000 0C2A 
; 0000 0C2B     case 82:
_0xFF:
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BRNE _0x100
; 0000 0C2C 
; 0000 0C2D             a[0] = 0x0D8;   //ster1
	LDI  R30,LOW(216)
	LDI  R31,HIGH(216)
	CALL SUBOPT_0x38
; 0000 0C2E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0C2F             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5D
; 0000 0C30             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0C31             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C32             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0C33 
; 0000 0C34             a[1] = a[0]+0x001;  //ster2
; 0000 0C35             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C36             a[6] = a[5]+0x001;  //okrag
; 0000 0C37             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C38 
; 0000 0C39     break;
; 0000 0C3A 
; 0000 0C3B 
; 0000 0C3C     case 83:
_0x100:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x101
; 0000 0C3D 
; 0000 0C3E             a[0] = 0x08C;   //ster1
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	CALL SUBOPT_0x38
; 0000 0C3F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0C40             a[4] = 0x22;    //ster3 ABS krazek scierny
	LDI  R26,LOW(34)
	LDI  R27,HIGH(34)
	CALL SUBOPT_0x5E
; 0000 0C41             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x467
; 0000 0C42             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C43             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C44 
; 0000 0C45             a[1] = a[0]+0x001;  //ster2
; 0000 0C46             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C47             a[6] = a[5]+0x001;  //okrag
; 0000 0C48             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C49 
; 0000 0C4A     break;
; 0000 0C4B 
; 0000 0C4C 
; 0000 0C4D     case 84:
_0x101:
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x102
; 0000 0C4E 
; 0000 0C4F             a[0] = 0x0A0;   //ster1
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	CALL SUBOPT_0x38
; 0000 0C50             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x5F
; 0000 0C51             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0C52             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x60
; 0000 0C53             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x465
; 0000 0C54             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C55 
; 0000 0C56             a[1] = a[0]+0x001;  //ster2
; 0000 0C57             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C58             a[6] = a[5]+0x001;  //okrag
; 0000 0C59             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C5A 
; 0000 0C5B     break;
; 0000 0C5C 
; 0000 0C5D 
; 0000 0C5E    case 85:
_0x102:
	CPI  R30,LOW(0x55)
	LDI  R26,HIGH(0x55)
	CPC  R31,R26
	BRNE _0x103
; 0000 0C5F 
; 0000 0C60             a[0] = 0x0AE;   //ster1
	LDI  R30,LOW(174)
	LDI  R31,HIGH(174)
	CALL SUBOPT_0x38
; 0000 0C61             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0C62             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5C
; 0000 0C63             a[5] = 0x193;   //delta okrag
	RJMP _0x467
; 0000 0C64             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C65             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C66 
; 0000 0C67             a[1] = a[0]+0x001;  //ster2
; 0000 0C68             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C69             a[6] = a[5]+0x001;  //okrag
; 0000 0C6A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C6B 
; 0000 0C6C     break;
; 0000 0C6D 
; 0000 0C6E     case 86:
_0x103:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BRNE _0x104
; 0000 0C6F 
; 0000 0C70             a[0] = 0x0F6;   //ster1
	LDI  R30,LOW(246)
	LDI  R31,HIGH(246)
	CALL SUBOPT_0x38
; 0000 0C71             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0C72             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5D
; 0000 0C73             a[5] = 0x190;   //delta okrag
	RJMP _0x467
; 0000 0C74             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C75             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C76 
; 0000 0C77             a[1] = a[0]+0x001;  //ster2
; 0000 0C78             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C79             a[6] = a[5]+0x001;  //okrag
; 0000 0C7A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C7B 
; 0000 0C7C     break;
; 0000 0C7D 
; 0000 0C7E 
; 0000 0C7F     case 87:
_0x104:
	CPI  R30,LOW(0x57)
	LDI  R26,HIGH(0x57)
	CPC  R31,R26
	BRNE _0x105
; 0000 0C80 
; 0000 0C81             a[0] = 0x0C4;   //ster1
	LDI  R30,LOW(196)
	LDI  R31,HIGH(196)
	CALL SUBOPT_0x38
; 0000 0C82             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0C83             a[4] = 0x23;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x61
; 0000 0C84             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0C85             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C86             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0C87 
; 0000 0C88             a[1] = a[0]+0x001;  //ster2
; 0000 0C89             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C8A             a[6] = a[5]+0x001;  //okrag
; 0000 0C8B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C8C 
; 0000 0C8D     break;
; 0000 0C8E 
; 0000 0C8F 
; 0000 0C90     case 88:
_0x105:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x106
; 0000 0C91 
; 0000 0C92             a[0] = 0x07E;   //ster1
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	CALL SUBOPT_0x38
; 0000 0C93             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x5F
; 0000 0C94             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0C95             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x60
; 0000 0C96             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3B
; 0000 0C97             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3D
	RJMP _0x466
; 0000 0C98 
; 0000 0C99             a[1] = a[0]+0x001;  //ster2
; 0000 0C9A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C9B             a[6] = a[5]+0x001;  //okrag
; 0000 0C9C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C9D 
; 0000 0C9E     break;
; 0000 0C9F 
; 0000 0CA0 
; 0000 0CA1     case 89:
_0x106:
	CPI  R30,LOW(0x59)
	LDI  R26,HIGH(0x59)
	CPC  R31,R26
	BRNE _0x107
; 0000 0CA2 
; 0000 0CA3             a[0] = 0x02C;   //ster1
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x38
; 0000 0CA4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0CA5             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0CA6             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0CA7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CA8             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0CA9 
; 0000 0CAA             a[1] = a[0]+0x001;  //ster2
; 0000 0CAB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CAC             a[6] = a[5]+0x001;  //okrag
; 0000 0CAD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CAE 
; 0000 0CAF     break;
; 0000 0CB0 
; 0000 0CB1 
; 0000 0CB2     case 90:
_0x107:
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BRNE _0x108
; 0000 0CB3 
; 0000 0CB4             a[0] = 0x0F0;   //ster1
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	CALL SUBOPT_0x38
; 0000 0CB5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0CB6             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3A
; 0000 0CB7             a[5] = 0x196;   //delta okrag
; 0000 0CB8             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0CB9             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CBA 
; 0000 0CBB             a[1] = a[0]+0x001;  //ster2
; 0000 0CBC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CBD             a[6] = a[5]+0x001;  //okrag
; 0000 0CBE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CBF 
; 0000 0CC0     break;
; 0000 0CC1 
; 0000 0CC2 
; 0000 0CC3     case 91:
_0x108:
	CPI  R30,LOW(0x5B)
	LDI  R26,HIGH(0x5B)
	CPC  R31,R26
	BRNE _0x109
; 0000 0CC4 
; 0000 0CC5             a[0] = 0x0A8;   //ster1
	LDI  R30,LOW(168)
	LDI  R31,HIGH(168)
	CALL SUBOPT_0x38
; 0000 0CC6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0CC7             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4C
; 0000 0CC8             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x467
; 0000 0CC9             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CCA             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CCB 
; 0000 0CCC             a[1] = a[0]+0x001;  //ster2
; 0000 0CCD             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CCE             a[6] = a[5]+0x001;  //okrag
; 0000 0CCF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CD0 
; 0000 0CD1     break;
; 0000 0CD2 
; 0000 0CD3 
; 0000 0CD4     case 92:
_0x109:
	CPI  R30,LOW(0x5C)
	LDI  R26,HIGH(0x5C)
	CPC  R31,R26
	BRNE _0x10A
; 0000 0CD5 
; 0000 0CD6             a[0] = 0x;   //ster1
	CALL SUBOPT_0x53
; 0000 0CD7             a[3] = 0x;    //ster4 INV druciak
; 0000 0CD8             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0CD9             a[5] = 0x;   //delta okrag
; 0000 0CDA             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0CDB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0CDC 
; 0000 0CDD             a[1] = a[0]+0x001;  //ster2
; 0000 0CDE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CDF             a[6] = a[5]+0x001;  //okrag
; 0000 0CE0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CE1 
; 0000 0CE2     break;
; 0000 0CE3 
; 0000 0CE4 
; 0000 0CE5     case 93:
_0x10A:
	CPI  R30,LOW(0x5D)
	LDI  R26,HIGH(0x5D)
	CPC  R31,R26
	BRNE _0x10B
; 0000 0CE6 
; 0000 0CE7             a[0] = 0x030;   //ster1
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x38
; 0000 0CE8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0CE9             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0CEA             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x467
; 0000 0CEB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CEC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CED 
; 0000 0CEE             a[1] = a[0]+0x001;  //ster2
; 0000 0CEF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CF0             a[6] = a[5]+0x001;  //okrag
; 0000 0CF1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CF2 
; 0000 0CF3     break;
; 0000 0CF4 
; 0000 0CF5 
; 0000 0CF6     case 94:
_0x10B:
	CPI  R30,LOW(0x5E)
	LDI  R26,HIGH(0x5E)
	CPC  R31,R26
	BRNE _0x10C
; 0000 0CF7 
; 0000 0CF8             a[0] = 0x0F4;   //ster1
	LDI  R30,LOW(244)
	LDI  R31,HIGH(244)
	CALL SUBOPT_0x38
; 0000 0CF9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0CFA             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3A
; 0000 0CFB             a[5] = 0x196;   //delta okrag
; 0000 0CFC             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0CFD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0CFE 
; 0000 0CFF             a[1] = a[0]+0x001;  //ster2
; 0000 0D00             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D01             a[6] = a[5]+0x001;  //okrag
; 0000 0D02             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D03 
; 0000 0D04     break;
; 0000 0D05 
; 0000 0D06 
; 0000 0D07     case 95:
_0x10C:
	CPI  R30,LOW(0x5F)
	LDI  R26,HIGH(0x5F)
	CPC  R31,R26
	BRNE _0x10D
; 0000 0D08 
; 0000 0D09             a[0] = 0x09E;   //ster1
	LDI  R30,LOW(158)
	LDI  R31,HIGH(158)
	CALL SUBOPT_0x38
; 0000 0D0A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0D0B             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x46
; 0000 0D0C             a[5] = 0x199;   //delta okrag
; 0000 0D0D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D0E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0D0F 
; 0000 0D10             a[1] = a[0]+0x001;  //ster2
; 0000 0D11             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D12             a[6] = a[5]+0x001;  //okrag
; 0000 0D13             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D14 
; 0000 0D15     break;
; 0000 0D16 
; 0000 0D17     case 96:
_0x10D:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x10E
; 0000 0D18 
; 0000 0D19             a[0] = 0x;   //ster1
	CALL SUBOPT_0x53
; 0000 0D1A             a[3] = 0x;    //ster4 INV druciak
; 0000 0D1B             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0D1C             a[5] = 0x;   //delta okrag
; 0000 0D1D             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0D1E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0D1F 
; 0000 0D20             a[1] = a[0]+0x001;  //ster2
; 0000 0D21             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D22             a[6] = a[5]+0x001;  //okrag
; 0000 0D23             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D24 
; 0000 0D25     break;
; 0000 0D26 
; 0000 0D27 
; 0000 0D28     case 97:
_0x10E:
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BRNE _0x10F
; 0000 0D29 
; 0000 0D2A             a[0] = 0x06A;   //ster1
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	CALL SUBOPT_0x38
; 0000 0D2B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0D2C             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0D2D             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0D2E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D2F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0D30 
; 0000 0D31             a[1] = a[0]+0x001;  //ster2
; 0000 0D32             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D33             a[6] = a[5]+0x001;  //okrag
; 0000 0D34             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D35 
; 0000 0D36     break;
; 0000 0D37 
; 0000 0D38 
; 0000 0D39     case 98:
_0x10F:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x110
; 0000 0D3A 
; 0000 0D3B             a[0] = 0x0BE;   //ster1
	LDI  R30,LOW(190)
	LDI  R31,HIGH(190)
	CALL SUBOPT_0x38
; 0000 0D3C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0D3D             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3E
; 0000 0D3E             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x62
; 0000 0D3F             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0D40             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0D41 
; 0000 0D42             a[1] = a[0]+0x001;  //ster2
; 0000 0D43             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D44             a[6] = a[5]+0x001;  //okrag
; 0000 0D45             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D46 
; 0000 0D47     break;
; 0000 0D48 
; 0000 0D49 
; 0000 0D4A     case 99:
_0x110:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x111
; 0000 0D4B 
; 0000 0D4C             a[0] = 0x0BA;   //ster1
	LDI  R30,LOW(186)
	LDI  R31,HIGH(186)
	CALL SUBOPT_0x38
; 0000 0D4D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0D4E             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0D4F             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x467
; 0000 0D50             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D51             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D52 
; 0000 0D53             a[1] = a[0]+0x001;  //ster2
; 0000 0D54             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D55             a[6] = a[5]+0x001;  //okrag
; 0000 0D56             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D57 
; 0000 0D58     break;
; 0000 0D59 
; 0000 0D5A 
; 0000 0D5B     case 100:
_0x111:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRNE _0x112
; 0000 0D5C 
; 0000 0D5D             a[0] = 0x060;   //ster1
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x38
; 0000 0D5E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0D5F             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0D60             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0D61             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D62             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0D63 
; 0000 0D64             a[1] = a[0]+0x001;  //ster2
; 0000 0D65             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D66             a[6] = a[5]+0x001;  //okrag
; 0000 0D67             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D68 
; 0000 0D69     break;
; 0000 0D6A 
; 0000 0D6B 
; 0000 0D6C     case 101:
_0x112:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x113
; 0000 0D6D 
; 0000 0D6E             a[0] = 0x070;   //ster1
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	CALL SUBOPT_0x38
; 0000 0D6F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0D70             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0D71             a[5] = 0x199;   //delta okrag
	RJMP _0x467
; 0000 0D72             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D73             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D74 
; 0000 0D75             a[1] = a[0]+0x001;  //ster2
; 0000 0D76             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D77             a[6] = a[5]+0x001;  //okrag
; 0000 0D78             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D79 
; 0000 0D7A     break;
; 0000 0D7B 
; 0000 0D7C 
; 0000 0D7D     case 102:
_0x113:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BRNE _0x114
; 0000 0D7E 
; 0000 0D7F             a[0] = 0x08A;   //ster1
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	CALL SUBOPT_0x38
; 0000 0D80             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0D81             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3E
; 0000 0D82             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x62
; 0000 0D83             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0D84             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D85 
; 0000 0D86             a[1] = a[0]+0x001;  //ster2
; 0000 0D87             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D88             a[6] = a[5]+0x001;  //okrag
; 0000 0D89             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D8A 
; 0000 0D8B     break;
; 0000 0D8C 
; 0000 0D8D 
; 0000 0D8E     case 103:
_0x114:
	CPI  R30,LOW(0x67)
	LDI  R26,HIGH(0x67)
	CPC  R31,R26
	BRNE _0x115
; 0000 0D8F 
; 0000 0D90             a[0] = 0x080;   //ster1
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CALL SUBOPT_0x38
; 0000 0D91             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0D92             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0D93             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0D94             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D95             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0D96 
; 0000 0D97             a[1] = a[0]+0x001;  //ster2
; 0000 0D98             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D99             a[6] = a[5]+0x001;  //okrag
; 0000 0D9A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D9B 
; 0000 0D9C     break;
; 0000 0D9D 
; 0000 0D9E 
; 0000 0D9F     case 104:
_0x115:
	CPI  R30,LOW(0x68)
	LDI  R26,HIGH(0x68)
	CPC  R31,R26
	BRNE _0x116
; 0000 0DA0 
; 0000 0DA1             a[0] = 0x0B6;   //ster1
	LDI  R30,LOW(182)
	LDI  R31,HIGH(182)
	CALL SUBOPT_0x38
; 0000 0DA2             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0DA3             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0DA4             a[5] = 0x196;   //delta okrag
	RJMP _0x467
; 0000 0DA5             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DA6             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DA7 
; 0000 0DA8             a[1] = a[0]+0x001;  //ster2
; 0000 0DA9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DAA             a[6] = a[5]+0x001;  //okrag
; 0000 0DAB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DAC 
; 0000 0DAD     break;
; 0000 0DAE 
; 0000 0DAF 
; 0000 0DB0     case 105:
_0x116:
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x117
; 0000 0DB1 
; 0000 0DB2             a[0] = 0x044;   //ster1
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	CALL SUBOPT_0x38
; 0000 0DB3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0DB4             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0DB5             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0DB6             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0DB7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0DB8 
; 0000 0DB9             a[1] = a[0]+0x001;  //ster2
; 0000 0DBA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DBB             a[6] = a[5]+0x001;  //okrag
; 0000 0DBC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DBD 
; 0000 0DBE     break;
; 0000 0DBF 
; 0000 0DC0 
; 0000 0DC1     case 106:
_0x117:
	CPI  R30,LOW(0x6A)
	LDI  R26,HIGH(0x6A)
	CPC  R31,R26
	BRNE _0x118
; 0000 0DC2 
; 0000 0DC3             a[0] = 0x03A;   //ster1
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	CALL SUBOPT_0x38
; 0000 0DC4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0DC5             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0DC6             a[5] = 0x190;   //delta okrag
; 0000 0DC7             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0DC8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DC9 
; 0000 0DCA             a[1] = a[0]+0x001;  //ster2
; 0000 0DCB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DCC             a[6] = a[5]+0x001;  //okrag
; 0000 0DCD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DCE 
; 0000 0DCF     break;
; 0000 0DD0 
; 0000 0DD1 
; 0000 0DD2     case 107:
_0x118:
	CPI  R30,LOW(0x6B)
	LDI  R26,HIGH(0x6B)
	CPC  R31,R26
	BRNE _0x119
; 0000 0DD3 
; 0000 0DD4             a[0] = 0x;   //ster1
	CALL SUBOPT_0x53
; 0000 0DD5             a[3] = 0x;    //ster4 INV druciak
; 0000 0DD6             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0DD7             a[5] = 0x;   //delta okrag
; 0000 0DD8             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0DD9             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0DDA 
; 0000 0DDB             a[1] = a[0]+0x001;  //ster2
; 0000 0DDC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DDD             a[6] = a[5]+0x001;  //okrag
; 0000 0DDE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DDF 
; 0000 0DE0     break;
; 0000 0DE1 
; 0000 0DE2 
; 0000 0DE3     case 108:
_0x119:
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BRNE _0x11A
; 0000 0DE4 
; 0000 0DE5             a[0] = 0x0C6;   //ster1
	LDI  R30,LOW(198)
	LDI  R31,HIGH(198)
	CALL SUBOPT_0x38
; 0000 0DE6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0DE7             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0DE8             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5A
; 0000 0DE9             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0DEA             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0DEB 
; 0000 0DEC             a[1] = a[0]+0x001;  //ster2
; 0000 0DED             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DEE             a[6] = a[5]+0x001;  //okrag
; 0000 0DEF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DF0 
; 0000 0DF1     break;
; 0000 0DF2 
; 0000 0DF3 
; 0000 0DF4     case 109:
_0x11A:
	CPI  R30,LOW(0x6D)
	LDI  R26,HIGH(0x6D)
	CPC  R31,R26
	BRNE _0x11B
; 0000 0DF5 
; 0000 0DF6             a[0] = 0x00A;   //ster1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x38
; 0000 0DF7             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 0DF8             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 0DF9             a[5] = 0x190;   //delta okrag
; 0000 0DFA             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x465
; 0000 0DFB             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DFC 
; 0000 0DFD             a[1] = a[0]+0x001;  //ster2
; 0000 0DFE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DFF             a[6] = a[5]+0x001;  //okrag
; 0000 0E00             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E01 
; 0000 0E02     break;
; 0000 0E03 
; 0000 0E04 
; 0000 0E05     case 110:
_0x11B:
	CPI  R30,LOW(0x6E)
	LDI  R26,HIGH(0x6E)
	CPC  R31,R26
	BRNE _0x11C
; 0000 0E06 
; 0000 0E07             a[0] = 0x032;   //ster1
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x38
; 0000 0E08             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0E09             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0E0A             a[5] = 0x190;   //delta okrag
; 0000 0E0B             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0E0C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0E0D 
; 0000 0E0E             a[1] = a[0]+0x001;  //ster2
; 0000 0E0F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E10             a[6] = a[5]+0x001;  //okrag
; 0000 0E11             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E12 
; 0000 0E13     break;
; 0000 0E14 
; 0000 0E15 
; 0000 0E16     case 111:
_0x11C:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x11D
; 0000 0E17 
; 0000 0E18             a[0] = 0x;   //ster1
	CALL SUBOPT_0x53
; 0000 0E19             a[3] = 0x;    //ster4 INV druciak
; 0000 0E1A             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0E1B             a[5] = 0x;   //delta okrag
; 0000 0E1C             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0E1D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0E1E 
; 0000 0E1F             a[1] = a[0]+0x001;  //ster2
; 0000 0E20             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E21             a[6] = a[5]+0x001;  //okrag
; 0000 0E22             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E23 
; 0000 0E24     break;
; 0000 0E25 
; 0000 0E26 
; 0000 0E27     case 112:
_0x11D:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x11E
; 0000 0E28 
; 0000 0E29             a[0] = 0x0E2;   //ster1
	LDI  R30,LOW(226)
	LDI  R31,HIGH(226)
	CALL SUBOPT_0x38
; 0000 0E2A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0E2B             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0E2C             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5A
; 0000 0E2D             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0E2E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E2F 
; 0000 0E30             a[1] = a[0]+0x001;  //ster2
; 0000 0E31             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E32             a[6] = a[5]+0x001;  //okrag
; 0000 0E33             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E34 
; 0000 0E35     break;
; 0000 0E36 
; 0000 0E37 
; 0000 0E38     case 113:
_0x11E:
	CPI  R30,LOW(0x71)
	LDI  R26,HIGH(0x71)
	CPC  R31,R26
	BRNE _0x11F
; 0000 0E39 
; 0000 0E3A             a[0] = 0x0D4;   //ster1
	LDI  R30,LOW(212)
	LDI  R31,HIGH(212)
	CALL SUBOPT_0x38
; 0000 0E3B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0E3C             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x64
; 0000 0E3D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5A
; 0000 0E3E             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0E3F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0E40 
; 0000 0E41             a[1] = a[0]+0x001;  //ster2
; 0000 0E42             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E43             a[6] = a[5]+0x001;  //okrag
; 0000 0E44             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E45 
; 0000 0E46     break;
; 0000 0E47 
; 0000 0E48 
; 0000 0E49     case 114:
_0x11F:
	CPI  R30,LOW(0x72)
	LDI  R26,HIGH(0x72)
	CPC  R31,R26
	BRNE _0x120
; 0000 0E4A 
; 0000 0E4B             a[0] = 0x04A;   //ster1
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	CALL SUBOPT_0x38
; 0000 0E4C             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 0E4D             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x65
; 0000 0E4E             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x60
; 0000 0E4F             a[7] = 0x0F;    //ster3 INV krazek scierny
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	CALL SUBOPT_0x41
; 0000 0E50             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0E51 
; 0000 0E52             a[1] = a[0]+0x001;  //ster2
; 0000 0E53             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E54             a[6] = a[5]+0x001;  //okrag
; 0000 0E55             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E56 
; 0000 0E57     break;
; 0000 0E58 
; 0000 0E59 
; 0000 0E5A     case 115:
_0x120:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x121
; 0000 0E5B 
; 0000 0E5C             a[0] = 0x076;   //ster1
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	CALL SUBOPT_0x38
; 0000 0E5D             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x66
; 0000 0E5E             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0E5F             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x42
; 0000 0E60             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0E61             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0E62 
; 0000 0E63             a[1] = a[0]+0x001;  //ster2
; 0000 0E64             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E65             a[6] = a[5]+0x001;  //okrag
; 0000 0E66             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E67 
; 0000 0E68     break;
; 0000 0E69 
; 0000 0E6A 
; 0000 0E6B     case 116:
_0x121:
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BRNE _0x122
; 0000 0E6C 
; 0000 0E6D             a[0] = 0x092;   //ster1
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	CALL SUBOPT_0x38
; 0000 0E6E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0E6F             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0E70             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x467
; 0000 0E71             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0E72             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E73 
; 0000 0E74             a[1] = a[0]+0x001;  //ster2
; 0000 0E75             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E76             a[6] = a[5]+0x001;  //okrag
; 0000 0E77             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E78 
; 0000 0E79     break;
; 0000 0E7A 
; 0000 0E7B 
; 0000 0E7C 
; 0000 0E7D     case 117:
_0x122:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x123
; 0000 0E7E 
; 0000 0E7F             a[0] = 0x11A;   //ster1
	LDI  R30,LOW(282)
	LDI  R31,HIGH(282)
	CALL SUBOPT_0x38
; 0000 0E80             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0E81             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x64
; 0000 0E82             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5A
; 0000 0E83             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0E84             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E85 
; 0000 0E86             a[1] = a[0]+0x001;  //ster2
; 0000 0E87             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E88             a[6] = a[5]+0x001;  //okrag
; 0000 0E89             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E8A 
; 0000 0E8B     break;
; 0000 0E8C 
; 0000 0E8D 
; 0000 0E8E 
; 0000 0E8F     case 118:
_0x123:
	CPI  R30,LOW(0x76)
	LDI  R26,HIGH(0x76)
	CPC  R31,R26
	BRNE _0x124
; 0000 0E90 
; 0000 0E91             a[0] = 0x056;   //ster1
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	CALL SUBOPT_0x38
; 0000 0E92             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 0E93             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x65
; 0000 0E94             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5A
; 0000 0E95             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0E96             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E97 
; 0000 0E98             a[1] = a[0]+0x001;  //ster2
; 0000 0E99             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E9A             a[6] = a[5]+0x001;  //okrag
; 0000 0E9B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E9C 
; 0000 0E9D     break;
; 0000 0E9E 
; 0000 0E9F 
; 0000 0EA0     case 119:
_0x124:
	CPI  R30,LOW(0x77)
	LDI  R26,HIGH(0x77)
	CPC  R31,R26
	BRNE _0x125
; 0000 0EA1 
; 0000 0EA2             a[0] = 0x072;   //ster1
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	CALL SUBOPT_0x38
; 0000 0EA3             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x66
; 0000 0EA4             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0EA5             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x42
; 0000 0EA6             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0EA7             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EA8 
; 0000 0EA9             a[1] = a[0]+0x001;  //ster2
; 0000 0EAA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EAB             a[6] = a[5]+0x001;  //okrag
; 0000 0EAC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EAD 
; 0000 0EAE     break;
; 0000 0EAF 
; 0000 0EB0 
; 0000 0EB1     case 120:
_0x125:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x126
; 0000 0EB2 
; 0000 0EB3             a[0] = 0x0D0;   //ster1
	LDI  R30,LOW(208)
	LDI  R31,HIGH(208)
	CALL SUBOPT_0x38
; 0000 0EB4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0EB5             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0EB6             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0EB7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0EB8             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0EB9 
; 0000 0EBA             a[1] = a[0]+0x001;  //ster2
; 0000 0EBB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EBC             a[6] = a[5]+0x001;  //okrag
; 0000 0EBD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EBE 
; 0000 0EBF     break;
; 0000 0EC0 
; 0000 0EC1 
; 0000 0EC2     case 121:
_0x126:
	CPI  R30,LOW(0x79)
	LDI  R26,HIGH(0x79)
	CPC  R31,R26
	BRNE _0x127
; 0000 0EC3 
; 0000 0EC4             a[0] = 0x048;   //ster1
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	CALL SUBOPT_0x38
; 0000 0EC5             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 0EC6             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x65
; 0000 0EC7             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5A
; 0000 0EC8             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0EC9             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0ECA 
; 0000 0ECB             a[1] = a[0]+0x001;  //ster2
; 0000 0ECC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0ECD             a[6] = a[5]+0x001;  //okrag
; 0000 0ECE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ECF 
; 0000 0ED0     break;
; 0000 0ED1 
; 0000 0ED2 
; 0000 0ED3     case 122:
_0x127:
	CPI  R30,LOW(0x7A)
	LDI  R26,HIGH(0x7A)
	CPC  R31,R26
	BRNE _0x128
; 0000 0ED4 
; 0000 0ED5             a[0] = 0x09A;   //ster1
	LDI  R30,LOW(154)
	LDI  R31,HIGH(154)
	CALL SUBOPT_0x38
; 0000 0ED6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0ED7             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0ED8             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0ED9             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0EDA             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0EDB 
; 0000 0EDC             a[1] = a[0]+0x001;  //ster2
; 0000 0EDD             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EDE             a[6] = a[5]+0x001;  //okrag
; 0000 0EDF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EE0 
; 0000 0EE1     break;
; 0000 0EE2 
; 0000 0EE3 
; 0000 0EE4     case 123:
_0x128:
	CPI  R30,LOW(0x7B)
	LDI  R26,HIGH(0x7B)
	CPC  R31,R26
	BRNE _0x129
; 0000 0EE5 
; 0000 0EE6             a[0] = 0x046;   //ster1
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL SUBOPT_0x38
; 0000 0EE7             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 0EE8             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0EE9             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x68
; 0000 0EEA             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0EEB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0EEC 
; 0000 0EED             a[1] = a[0]+0x001;  //ster2
; 0000 0EEE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EEF             a[6] = a[5]+0x001;  //okrag
; 0000 0EF0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EF1 
; 0000 0EF2     break;
; 0000 0EF3 
; 0000 0EF4 
; 0000 0EF5 
; 0000 0EF6     case 124:
_0x129:
	CPI  R30,LOW(0x7C)
	LDI  R26,HIGH(0x7C)
	CPC  R31,R26
	BRNE _0x12A
; 0000 0EF7 
; 0000 0EF8             a[0] = 0x0E0;   //ster1
	LDI  R30,LOW(224)
	LDI  R31,HIGH(224)
	CALL SUBOPT_0x38
; 0000 0EF9             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x69
; 0000 0EFA             a[4] = 0x15;    //ster3 ABS krazek scierny
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL SUBOPT_0x5E
; 0000 0EFB             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x60
; 0000 0EFC             a[7] = 0x13;    //ster3 INV krazek scierny
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	CALL SUBOPT_0x41
; 0000 0EFD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0EFE 
; 0000 0EFF             a[1] = a[0]+0x001;  //ster2
; 0000 0F00             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F01             a[6] = a[5]+0x001;  //okrag
; 0000 0F02             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F03 
; 0000 0F04     break;
; 0000 0F05 
; 0000 0F06 
; 0000 0F07     case 125:
_0x12A:
	CPI  R30,LOW(0x7D)
	LDI  R26,HIGH(0x7D)
	CPC  R31,R26
	BRNE _0x12B
; 0000 0F08 
; 0000 0F09             a[0] = 0x038;   //ster1
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	CALL SUBOPT_0x38
; 0000 0F0A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0F0B             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0F0C             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5A
; 0000 0F0D             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0F0E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F0F 
; 0000 0F10             a[1] = a[0]+0x001;  //ster2
; 0000 0F11             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F12             a[6] = a[5]+0x001;  //okrag
; 0000 0F13             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F14 
; 0000 0F15     break;
; 0000 0F16 
; 0000 0F17 
; 0000 0F18     case 126:
_0x12B:
	CPI  R30,LOW(0x7E)
	LDI  R26,HIGH(0x7E)
	CPC  R31,R26
	BRNE _0x12C
; 0000 0F19 
; 0000 0F1A             a[0] = 0x0CA;   //ster1
	LDI  R30,LOW(202)
	LDI  R31,HIGH(202)
	CALL SUBOPT_0x38
; 0000 0F1B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0F1C             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0F1D             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x467
; 0000 0F1E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F1F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F20 
; 0000 0F21             a[1] = a[0]+0x001;  //ster2
; 0000 0F22             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F23             a[6] = a[5]+0x001;  //okrag
; 0000 0F24             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F25 
; 0000 0F26     break;
; 0000 0F27 
; 0000 0F28 
; 0000 0F29     case 127:
_0x12C:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0x12D
; 0000 0F2A 
; 0000 0F2B             a[0] = 0x0DE;   //ster1
	LDI  R30,LOW(222)
	LDI  R31,HIGH(222)
	CALL SUBOPT_0x38
; 0000 0F2C             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 0F2D             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0F2E             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x68
; 0000 0F2F             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0F30             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F31 
; 0000 0F32             a[1] = a[0]+0x001;  //ster2
; 0000 0F33             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F34             a[6] = a[5]+0x001;  //okrag
; 0000 0F35             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F36 
; 0000 0F37     break;
; 0000 0F38 
; 0000 0F39 
; 0000 0F3A     case 128:
_0x12D:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x12E
; 0000 0F3B 
; 0000 0F3C             a[0] = 0x116;   //ster1
	LDI  R30,LOW(278)
	LDI  R31,HIGH(278)
	CALL SUBOPT_0x38
; 0000 0F3D             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 0F3E             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x3E
; 0000 0F3F             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6A
; 0000 0F40             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0F41             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F42 
; 0000 0F43             a[1] = a[0]+0x001;  //ster2
; 0000 0F44             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F45             a[6] = a[5]+0x001;  //okrag
; 0000 0F46             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F47 
; 0000 0F48     break;
; 0000 0F49 
; 0000 0F4A 
; 0000 0F4B     case 129:
_0x12E:
	CPI  R30,LOW(0x81)
	LDI  R26,HIGH(0x81)
	CPC  R31,R26
	BRNE _0x12F
; 0000 0F4C 
; 0000 0F4D             a[0] = 0x0E8;   //ster1
	LDI  R30,LOW(232)
	LDI  R31,HIGH(232)
	CALL SUBOPT_0x38
; 0000 0F4E             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x69
; 0000 0F4F             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6B
; 0000 0F50             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x6A
; 0000 0F51             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0F52             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0F53 
; 0000 0F54             a[1] = a[0]+0x001;  //ster2
; 0000 0F55             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F56             a[6] = a[5]+0x001;  //okrag
; 0000 0F57             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F58 
; 0000 0F59     break;
; 0000 0F5A 
; 0000 0F5B 
; 0000 0F5C     case 130:
_0x12F:
	CPI  R30,LOW(0x82)
	LDI  R26,HIGH(0x82)
	CPC  R31,R26
	BRNE _0x130
; 0000 0F5D 
; 0000 0F5E             a[0] = 0x0F2;   //ster1
	LDI  R30,LOW(242)
	LDI  R31,HIGH(242)
	CALL SUBOPT_0x38
; 0000 0F5F             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x6C
; 0000 0F60             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0F61             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x60
; 0000 0F62             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3B
; 0000 0F63             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3D
	RJMP _0x466
; 0000 0F64 
; 0000 0F65             a[1] = a[0]+0x001;  //ster2
; 0000 0F66             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F67             a[6] = a[5]+0x001;  //okrag
; 0000 0F68             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F69 
; 0000 0F6A     break;
; 0000 0F6B 
; 0000 0F6C 
; 0000 0F6D     case 131:
_0x130:
	CPI  R30,LOW(0x83)
	LDI  R26,HIGH(0x83)
	CPC  R31,R26
	BRNE _0x131
; 0000 0F6E 
; 0000 0F6F             a[0] = 0x108;   //ster1
	LDI  R30,LOW(264)
	LDI  R31,HIGH(264)
	CALL SUBOPT_0x38
; 0000 0F70             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0F71             a[4] = 0x1F;    //ster3 ABS krazek scierny
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP _0x468
; 0000 0F72             a[5] = 0x19C;   //delta okrag
; 0000 0F73             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F74             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F75 
; 0000 0F76             a[1] = a[0]+0x001;  //ster2
; 0000 0F77             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F78             a[6] = a[5]+0x001;  //okrag
; 0000 0F79             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F7A 
; 0000 0F7B     break;
; 0000 0F7C 
; 0000 0F7D 
; 0000 0F7E 
; 0000 0F7F     case 132:
_0x131:
	CPI  R30,LOW(0x84)
	LDI  R26,HIGH(0x84)
	CPC  R31,R26
	BRNE _0x132
; 0000 0F80 
; 0000 0F81             a[0] = 0x064;   //ster1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x38
; 0000 0F82             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0F83             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0F84             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x51
; 0000 0F85             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F86             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0F87 
; 0000 0F88             a[1] = a[0]+0x001;  //ster2
; 0000 0F89             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F8A             a[6] = a[5]+0x001;  //okrag
; 0000 0F8B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F8C 
; 0000 0F8D     break;
; 0000 0F8E 
; 0000 0F8F 
; 0000 0F90     case 133:
_0x132:
	CPI  R30,LOW(0x85)
	LDI  R26,HIGH(0x85)
	CPC  R31,R26
	BRNE _0x133
; 0000 0F91 
; 0000 0F92             a[0] = 0x088;   //ster1
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	CALL SUBOPT_0x38
; 0000 0F93             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x69
; 0000 0F94             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6B
; 0000 0F95             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x6A
; 0000 0F96             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0F97             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F98 
; 0000 0F99             a[1] = a[0]+0x001;  //ster2
; 0000 0F9A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F9B             a[6] = a[5]+0x001;  //okrag
; 0000 0F9C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F9D 
; 0000 0F9E     break;
; 0000 0F9F 
; 0000 0FA0 
; 0000 0FA1 
; 0000 0FA2     case 134:
_0x133:
	CPI  R30,LOW(0x86)
	LDI  R26,HIGH(0x86)
	CPC  R31,R26
	BRNE _0x134
; 0000 0FA3 
; 0000 0FA4             a[0] = 0x10E;   //ster1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x38
; 0000 0FA5             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x6C
; 0000 0FA6             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0FA7             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x60
; 0000 0FA8             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x465
; 0000 0FA9             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FAA 
; 0000 0FAB             a[1] = a[0]+0x001;  //ster2
; 0000 0FAC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FAD             a[6] = a[5]+0x001;  //okrag
; 0000 0FAE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FAF 
; 0000 0FB0     break;
; 0000 0FB1 
; 0000 0FB2                ////////////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 0FB3      case 135:
_0x134:
	CPI  R30,LOW(0x87)
	LDI  R26,HIGH(0x87)
	CPC  R31,R26
	BRNE _0x135
; 0000 0FB4 
; 0000 0FB5             a[0] = 0x054;   //ster1
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CALL SUBOPT_0x38
; 0000 0FB6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0FB7             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0FB8             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x51
; 0000 0FB9             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FBA             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0FBB 
; 0000 0FBC             a[1] = a[0]+0x001;  //ster2
; 0000 0FBD             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FBE             a[6] = a[5]+0x001;  //okrag
; 0000 0FBF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FC0 
; 0000 0FC1     break;
; 0000 0FC2 
; 0000 0FC3 
; 0000 0FC4      case 136:
_0x135:
	CPI  R30,LOW(0x88)
	LDI  R26,HIGH(0x88)
	CPC  R31,R26
	BRNE _0x136
; 0000 0FC5 
; 0000 0FC6             a[0] = 0x03E;   //ster1
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	CALL SUBOPT_0x38
; 0000 0FC7             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 0FC8             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x6B
; 0000 0FC9             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x6D
; 0000 0FCA             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x465
; 0000 0FCB             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FCC 
; 0000 0FCD             a[1] = a[0]+0x001;  //ster2
; 0000 0FCE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FCF             a[6] = a[5]+0x001;  //okrag
; 0000 0FD0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FD1 
; 0000 0FD2     break;
; 0000 0FD3 
; 0000 0FD4      case 137:
_0x136:
	CPI  R30,LOW(0x89)
	LDI  R26,HIGH(0x89)
	CPC  R31,R26
	BRNE _0x137
; 0000 0FD5 
; 0000 0FD6             a[0] = 0x00C;   //ster1
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x38
; 0000 0FD7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0FD8             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0FD9             a[5] = 0x190;   //delta okrag
; 0000 0FDA             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 0FDB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 0FDC 
; 0000 0FDD             a[1] = a[0]+0x001;  //ster2
; 0000 0FDE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FDF             a[6] = a[5]+0x001;  //okrag
; 0000 0FE0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FE1 
; 0000 0FE2     break;
; 0000 0FE3 
; 0000 0FE4 
; 0000 0FE5      case 138:
_0x137:
	CPI  R30,LOW(0x8A)
	LDI  R26,HIGH(0x8A)
	CPC  R31,R26
	BRNE _0x138
; 0000 0FE6 
; 0000 0FE7             a[0] = 0x0DC;   //ster1
	LDI  R30,LOW(220)
	LDI  R31,HIGH(220)
	CALL SUBOPT_0x38
; 0000 0FE8             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 0FE9             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x3A
; 0000 0FEA             a[5] = 0x196;   //delta okrag
; 0000 0FEB             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 0FEC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FED 
; 0000 0FEE             a[1] = a[0]+0x001;  //ster2
; 0000 0FEF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FF0             a[6] = a[5]+0x001;  //okrag
; 0000 0FF1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FF2 
; 0000 0FF3     break;
; 0000 0FF4 
; 0000 0FF5 
; 0000 0FF6      case 139:
_0x138:
	CPI  R30,LOW(0x8B)
	LDI  R26,HIGH(0x8B)
	CPC  R31,R26
	BRNE _0x139
; 0000 0FF7 
; 0000 0FF8             a[0] = 0x058;   //ster1
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	CALL SUBOPT_0x38
; 0000 0FF9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 0FFA             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x64
; 0000 0FFB             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x467
; 0000 0FFC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FFD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FFE 
; 0000 0FFF             a[1] = a[0]+0x001;  //ster2
; 0000 1000             a[2] = a[4];        //ster4 ABS druciak
; 0000 1001             a[6] = a[5]+0x001;  //okrag
; 0000 1002             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1003 
; 0000 1004     break;
; 0000 1005 
; 0000 1006 
; 0000 1007      case 140:
_0x139:
	CPI  R30,LOW(0x8C)
	LDI  R26,HIGH(0x8C)
	CPC  R31,R26
	BRNE _0x13A
; 0000 1008 
; 0000 1009             a[0] = 0x03C;   //ster1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0x38
; 0000 100A             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 100B             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 100C             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x6D
; 0000 100D             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3B
; 0000 100E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3D
	RJMP _0x466
; 0000 100F 
; 0000 1010             a[1] = a[0]+0x001;  //ster2
; 0000 1011             a[2] = a[4];        //ster4 ABS druciak
; 0000 1012             a[6] = a[5]+0x001;  //okrag
; 0000 1013             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1014 
; 0000 1015 
; 0000 1016 
; 0000 1017     break;
; 0000 1018 
; 0000 1019 
; 0000 101A      case 141:
_0x13A:
	CPI  R30,LOW(0x8D)
	LDI  R26,HIGH(0x8D)
	CPC  R31,R26
	BRNE _0x13B
; 0000 101B 
; 0000 101C             a[0] = 0x00E;   //ster1
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x38
; 0000 101D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 101E             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 101F             a[5] = 0x190;   //delta okrag
; 0000 1020             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x465
; 0000 1021             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1022 
; 0000 1023             a[1] = a[0]+0x001;  //ster2
; 0000 1024             a[2] = a[4];        //ster4 ABS druciak
; 0000 1025             a[6] = a[5]+0x001;  //okrag
; 0000 1026             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1027 
; 0000 1028     break;
; 0000 1029 
; 0000 102A 
; 0000 102B      case 142:
_0x13B:
	CPI  R30,LOW(0x8E)
	LDI  R26,HIGH(0x8E)
	CPC  R31,R26
	BRNE _0x13C
; 0000 102C 
; 0000 102D             a[0] = 0x10A;   //ster1
	LDI  R30,LOW(266)
	LDI  R31,HIGH(266)
	CALL SUBOPT_0x38
; 0000 102E             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3B
; 0000 102F             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x3A
; 0000 1030             a[5] = 0x196;   //delta okrag
; 0000 1031             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x41
; 0000 1032             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 1033 
; 0000 1034             a[1] = a[0]+0x001;  //ster2
; 0000 1035             a[2] = a[4];        //ster4 ABS druciak
; 0000 1036             a[6] = a[5]+0x001;  //okrag
; 0000 1037             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1038 
; 0000 1039     break;
; 0000 103A 
; 0000 103B 
; 0000 103C 
; 0000 103D      case 143:
_0x13C:
	CPI  R30,LOW(0x8F)
	LDI  R26,HIGH(0x8F)
	CPC  R31,R26
	BRNE _0x13D
; 0000 103E 
; 0000 103F             a[0] = 0x022;   //ster1
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL SUBOPT_0x38
; 0000 1040             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 1041             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x64
; 0000 1042             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 1043             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 1044             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x466
; 0000 1045 
; 0000 1046             a[1] = a[0]+0x001;  //ster2
; 0000 1047             a[2] = a[4];        //ster4 ABS druciak
; 0000 1048             a[6] = a[5]+0x001;  //okrag
; 0000 1049             a[8] = a[6]+0x001;  //-delta okrag
; 0000 104A 
; 0000 104B     break;
; 0000 104C 
; 0000 104D 
; 0000 104E      case 144:
_0x13D:
	CPI  R30,LOW(0x90)
	LDI  R26,HIGH(0x90)
	CPC  R31,R26
	BRNE _0xAD
; 0000 104F 
; 0000 1050             a[0] = 0x066;   //ster1
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	CALL SUBOPT_0x38
; 0000 1051             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x39
; 0000 1052             a[4] = 0x1C;    //ster3 ABS krazek scierny
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
_0x468:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1053             a[5] = 0x19C;   //delta okrag
	__POINTW1MN _a,10
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
_0x467:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1054             a[7] = 0x12;    //ster3 INV krazek scierny
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
_0x465:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1055             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	__POINTW1MN _a,18
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
_0x466:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1056 
; 0000 1057             a[1] = a[0]+0x001;  //ster2
	CALL SUBOPT_0x6E
	ADIW R30,1
	__PUTW1MN _a,2
; 0000 1058             a[2] = a[4];        //ster4 ABS druciak
	CALL SUBOPT_0x6F
	__PUTW1MN _a,4
; 0000 1059             a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x70
	CALL SUBOPT_0x71
; 0000 105A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 105B 
; 0000 105C     break;
; 0000 105D 
; 0000 105E 
; 0000 105F }
_0xAD:
; 0000 1060 
; 0000 1061 if(predkosc_pion_szczotka == 50)   //zwolnienie predkosci pion
	LDS  R26,_predkosc_pion_szczotka
	LDS  R27,_predkosc_pion_szczotka+1
	SBIW R26,50
	BRNE _0x13F
; 0000 1062        {
; 0000 1063        a[3] = a[3] - 0x05;
	CALL SUBOPT_0x72
	SBIW R30,5
	__PUTW1MN _a,6
; 0000 1064        }
; 0000 1065 
; 0000 1066 if(krazek_scierny_cykl_po_okregu_ilosc == 0 | ruch_haos == 1)
_0x13F:
	CALL SUBOPT_0x73
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_ruch_haos
	LDS  R27,_ruch_haos+1
	CALL SUBOPT_0x74
	OR   R30,R0
	BREQ _0x140
; 0000 1067         a[7] = a[7] - 0x05;
	CALL SUBOPT_0x75
	SBIW R30,5
	__PUTW1MN _a,14
; 0000 1068 
; 0000 1069 if(srednica_krazka_sciernego == 40)
_0x140:
	CALL SUBOPT_0x76
	SBIW R26,40
	BRNE _0x141
; 0000 106A         a[4] = a[4]+ 0x13;
	CALL SUBOPT_0x6F
	ADIW R30,19
	__PUTW1MN _a,8
; 0000 106B 
; 0000 106C 
; 0000 106D a[3] = a[3]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT
_0x141:
	CALL SUBOPT_0x72
	SBIW R30,6
	__PUTW1MN _a,6
; 0000 106E a[2] = a[2]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT
	CALL SUBOPT_0x77
	SBIW R30,6
	__PUTW1MN _a,4
; 0000 106F 
; 0000 1070 
; 0000 1071 
; 0000 1072                                                      //2
; 0000 1073 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 30)
	CALL SUBOPT_0x78
	CALL SUBOPT_0x74
	CALL SUBOPT_0x79
; 0000 1074     {
; 0000 1075     }
; 0000 1076 
; 0000 1077                                                    //2
; 0000 1078 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 30)
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x79
	BREQ _0x143
; 0000 1079     {
; 0000 107A     a[5] = a[5] + 0x10;   //plus 16 dzesietnie
	CALL SUBOPT_0x70
	ADIW R30,16
	CALL SUBOPT_0x7B
; 0000 107B     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x71
; 0000 107C     a[8] = a[6]+0x001;  //-delta okrag
; 0000 107D     }
; 0000 107E                                                     //1
; 0000 107F if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 30)
_0x143:
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x79
	BREQ _0x144
; 0000 1080     {
; 0000 1081     a[5] = a[5] + 0x20;   //plus 32 dzesietnie
	CALL SUBOPT_0x70
	ADIW R30,32
	CALL SUBOPT_0x7B
; 0000 1082     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x71
; 0000 1083     a[8] = a[6]+0x001;  //-delta okrag
; 0000 1084     }
; 0000 1085 
; 0000 1086                                                     //2
; 0000 1087 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 30)
_0x144:
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x79
	BREQ _0x145
; 0000 1088     {
; 0000 1089     a[5] = a[5] + 0x30;   //plus 48 dzesietnie
	CALL SUBOPT_0x70
	ADIW R30,48
	CALL SUBOPT_0x7B
; 0000 108A     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x71
; 0000 108B     a[8] = a[6]+0x001;  //-delta okrag
; 0000 108C     }
; 0000 108D 
; 0000 108E /////////////////////////////////////////////////////////////////////////////////////
; 0000 108F 
; 0000 1090 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 40)
_0x145:
	CALL SUBOPT_0x78
	CALL SUBOPT_0x74
	CALL SUBOPT_0x7E
	BREQ _0x146
; 0000 1091     {
; 0000 1092     a[5] = a[5] + 0x39;   //plus 66 dzesietnie   ///////////////
	CALL SUBOPT_0x70
	ADIW R30,57
	CALL SUBOPT_0x7B
; 0000 1093     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x71
; 0000 1094     a[8] = a[6]+0x001;  //-delta okrag
; 0000 1095     }
; 0000 1096 
; 0000 1097                                                    //2
; 0000 1098 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 40)
_0x146:
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7E
	BREQ _0x147
; 0000 1099     {
; 0000 109A     a[5] = a[5] + 0x42;   //plus 16 dzesietnie
	CALL SUBOPT_0x70
	SUBI R30,LOW(-66)
	SBCI R31,HIGH(-66)
	CALL SUBOPT_0x7B
; 0000 109B     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x71
; 0000 109C     a[8] = a[6]+0x001;  //-delta okrag
; 0000 109D     }
; 0000 109E                                                     //1
; 0000 109F if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 40)
_0x147:
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x7E
	BREQ _0x148
; 0000 10A0     {
; 0000 10A1     a[5] = a[5] + 0x4B;   //plus 32 dzesietnie
	CALL SUBOPT_0x70
	SUBI R30,LOW(-75)
	SBCI R31,HIGH(-75)
	CALL SUBOPT_0x7B
; 0000 10A2     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x71
; 0000 10A3     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10A4     }
; 0000 10A5 
; 0000 10A6                                                     //2
; 0000 10A7 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 40)
_0x148:
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x7E
	BREQ _0x149
; 0000 10A8     {
; 0000 10A9     a[5] = a[5] + 0x54;   //plus 48 dzesietnie
	CALL SUBOPT_0x70
	SUBI R30,LOW(-84)
	SBCI R31,HIGH(-84)
	CALL SUBOPT_0x7B
; 0000 10AA     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x71
; 0000 10AB     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10AC     }
; 0000 10AD 
; 0000 10AE 
; 0000 10AF 
; 0000 10B0 
; 0000 10B1 
; 0000 10B2 
; 0000 10B3 
; 0000 10B4 
; 0000 10B5 
; 0000 10B6      /*
; 0000 10B7         a[0] = 0x05A;   //ster1
; 0000 10B8             a[3] = 0x11;    //ster4 INV druciak
; 0000 10B9             a[4] = 0x21;    //ster3 ABS krazek scierny
; 0000 10BA             a[5] = 0x196;   //delta okrag
; 0000 10BB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 10BC             a[9] = 0;       //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 10BD 
; 0000 10BE             a[1] = a[0]+0x001;  //ster2
; 0000 10BF             a[2] = a[4];        //ster4 ABS druciak
; 0000 10C0             a[6] = a[5]+0x001;  //okrag
; 0000 10C1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 10C2         */
; 0000 10C3 }
_0x149:
	ADIW R28,2
	RET
;
;
;
;void obsluga_nacisniecia_zatrzymaj()
; 0000 10C8 {
_obsluga_nacisniecia_zatrzymaj:
; 0000 10C9 int sg;
; 0000 10CA sg = 0;
	CALL SUBOPT_0x2
;	sg -> R16,R17
; 0000 10CB 
; 0000 10CC 
; 0000 10CD 
; 0000 10CE    while(sprawdz_pin2(PORTMM,0x77) == 0)
_0x14A:
	CALL SUBOPT_0x1A
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x14C
; 0000 10CF         {
; 0000 10D0         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x80
; 0000 10D1         PORTD.7 = 1;
; 0000 10D2         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x14F
; 0000 10D3            {
; 0000 10D4            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x81
; 0000 10D5            PORTE.2 = 0;
; 0000 10D6            }
; 0000 10D7 
; 0000 10D8         if(PORTE.3 == 1)
_0x14F:
	SBIS 0x3,3
	RJMP _0x152
; 0000 10D9            {
; 0000 10DA            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x82
; 0000 10DB            PORTE.3 = 0;
; 0000 10DC            }
; 0000 10DD 
; 0000 10DE         if(PORT_F.bits.b4 == 1)
_0x152:
	CALL SUBOPT_0x83
	BRNE _0x155
; 0000 10DF             {
; 0000 10E0             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x84
; 0000 10E1             zastopowany_czas_przedmuchu = sek12;
; 0000 10E2             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 10E3             PORTF = PORT_F.byte;
; 0000 10E4             }
; 0000 10E5 
; 0000 10E6         komunikat_na_panel("                                                ",adr1,adr2);
_0x155:
	CALL SUBOPT_0x2D
; 0000 10E7         komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr1,adr2);
	__POINTW1FN _0x0,1344
	CALL SUBOPT_0x37
; 0000 10E8         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 10E9         komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr3,adr4);
	__POINTW1FN _0x0,1344
	CALL SUBOPT_0x86
; 0000 10EA 
; 0000 10EB         }
	RJMP _0x14A
_0x14C:
; 0000 10EC 
; 0000 10ED     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x156
; 0000 10EE         {
; 0000 10EF         while(sg == 0)
_0x157:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x159
; 0000 10F0             {
; 0000 10F1             if(sprawdz_pin2(PORTMM,0x77) == 1)
	CALL SUBOPT_0x1A
	CALL _sprawdz_pin2
	CPI  R30,LOW(0x1)
	BRNE _0x15A
; 0000 10F2                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	MOVW R16,R30
; 0000 10F3 
; 0000 10F4 
; 0000 10F5             }
_0x15A:
	RJMP _0x157
_0x159:
; 0000 10F6 
; 0000 10F7         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 10F8         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 10F9 
; 0000 10FA         PORTD.7 = 0;
	CALL SUBOPT_0x87
; 0000 10FB         if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x15D
; 0000 10FC             {
; 0000 10FD             PORTE.2 = 1;
	CALL SUBOPT_0x88
; 0000 10FE             byla_wloczona_szlifierka_1 = 0;
; 0000 10FF             }
; 0000 1100         if(byla_wloczona_szlifierka_2 == 1)
_0x15D:
	CALL SUBOPT_0x89
	BRNE _0x160
; 0000 1101             {
; 0000 1102             PORTE.3 = 1;
	CALL SUBOPT_0x8A
; 0000 1103             byla_wloczona_szlifierka_2 = 0;
; 0000 1104             }
; 0000 1105         if(byl_wloczony_przedmuch == 1)
_0x160:
	CALL SUBOPT_0x8B
	BRNE _0x163
; 0000 1106             {
; 0000 1107             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x8C
; 0000 1108             PORTF = PORT_F.byte;
; 0000 1109             sek12 = zastopowany_czas_przedmuchu;
; 0000 110A             byl_wloczony_przedmuch = 0;
; 0000 110B             }
; 0000 110C 
; 0000 110D 
; 0000 110E         }
_0x163:
; 0000 110F 
; 0000 1110 }
_0x156:
	RJMP _0x20A0002
;
;
;
;
;void obsluga_otwarcia_klapy_rzad()
; 0000 1116 {
_obsluga_otwarcia_klapy_rzad:
; 0000 1117 int sg;
; 0000 1118 sg = 0;
	CALL SUBOPT_0x2
;	sg -> R16,R17
; 0000 1119 
; 0000 111A if(rzad_obrabiany == 1 & start == 1)
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x74
	CALL SUBOPT_0x8E
	AND  R30,R0
	BRNE PC+3
	JMP _0x164
; 0000 111B    {
; 0000 111C    while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x165:
	CALL SUBOPT_0x1A
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x167
; 0000 111D         {
; 0000 111E         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x80
; 0000 111F         PORTD.7 = 1;
; 0000 1120         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x16A
; 0000 1121            {
; 0000 1122            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x81
; 0000 1123            PORTE.2 = 0;
; 0000 1124            }
; 0000 1125 
; 0000 1126         if(PORTE.3 == 1)
_0x16A:
	SBIS 0x3,3
	RJMP _0x16D
; 0000 1127            {
; 0000 1128            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x82
; 0000 1129            PORTE.3 = 0;
; 0000 112A            }
; 0000 112B 
; 0000 112C 
; 0000 112D         if(PORT_F.bits.b4 == 1)
_0x16D:
	CALL SUBOPT_0x83
	BRNE _0x170
; 0000 112E             {
; 0000 112F             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x84
; 0000 1130             zastopowany_czas_przedmuchu = sek12;
; 0000 1131             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1132             PORTF = PORT_F.byte;
; 0000 1133             }
; 0000 1134 
; 0000 1135         komunikat_na_panel("                                                ",adr1,adr2);
_0x170:
	CALL SUBOPT_0x2D
; 0000 1136         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
	__POINTW1FN _0x0,1384
	CALL SUBOPT_0x37
; 0000 1137         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1138         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
	__POINTW1FN _0x0,1384
	CALL SUBOPT_0x86
; 0000 1139 
; 0000 113A         }
	RJMP _0x165
_0x167:
; 0000 113B     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x171
; 0000 113C         {
; 0000 113D         while(sg == 0)
_0x172:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x174
; 0000 113E             {
; 0000 113F             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	PUSH R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	POP  R26
	AND  R30,R26
	BREQ _0x175
; 0000 1140                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	MOVW R16,R30
; 0000 1141 
; 0000 1142 
; 0000 1143             }
_0x175:
	RJMP _0x172
_0x174:
; 0000 1144 
; 0000 1145         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 1146         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1147 
; 0000 1148         PORTD.7 = 0;
	CALL SUBOPT_0x87
; 0000 1149 
; 0000 114A         if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x178
; 0000 114B             {
; 0000 114C             PORTE.2 = 1;
	CALL SUBOPT_0x88
; 0000 114D             byla_wloczona_szlifierka_1 = 0;
; 0000 114E             }
; 0000 114F         if(byla_wloczona_szlifierka_2 == 1)
_0x178:
	CALL SUBOPT_0x89
	BRNE _0x17B
; 0000 1150             {
; 0000 1151             PORTE.3 = 1;
	CALL SUBOPT_0x8A
; 0000 1152             byla_wloczona_szlifierka_2 = 0;
; 0000 1153             }
; 0000 1154         if(byl_wloczony_przedmuch == 1)
_0x17B:
	CALL SUBOPT_0x8B
	BRNE _0x17E
; 0000 1155             {
; 0000 1156             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x8C
; 0000 1157             PORTF = PORT_F.byte;
; 0000 1158             sek12 = zastopowany_czas_przedmuchu;
; 0000 1159             byl_wloczony_przedmuch = 0;
; 0000 115A             }
; 0000 115B 
; 0000 115C 
; 0000 115D 
; 0000 115E         }
_0x17E:
; 0000 115F    }
_0x171:
; 0000 1160 
; 0000 1161 
; 0000 1162 if(rzad_obrabiany == 2 & start == 1)
_0x164:
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x8E
	AND  R30,R0
	BRNE PC+3
	JMP _0x17F
; 0000 1163    {
; 0000 1164    while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x180:
	CALL SUBOPT_0x1A
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BRNE _0x182
; 0000 1165         {
; 0000 1166         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x80
; 0000 1167         PORTD.7 = 1;
; 0000 1168         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x185
; 0000 1169            {
; 0000 116A            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x81
; 0000 116B            PORTE.2 = 0;
; 0000 116C            }
; 0000 116D 
; 0000 116E         if(PORTE.3 == 1)
_0x185:
	SBIS 0x3,3
	RJMP _0x188
; 0000 116F            {
; 0000 1170            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x82
; 0000 1171            PORTE.3 = 0;
; 0000 1172            }
; 0000 1173 
; 0000 1174          if(PORT_F.bits.b4 == 1)
_0x188:
	CALL SUBOPT_0x83
	BRNE _0x18B
; 0000 1175             {
; 0000 1176             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x84
; 0000 1177             zastopowany_czas_przedmuchu = sek12;
; 0000 1178             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1179             PORTF = PORT_F.byte;
; 0000 117A             }
; 0000 117B 
; 0000 117C 
; 0000 117D         komunikat_na_panel("                                                ",adr1,adr2);
_0x18B:
	CALL SUBOPT_0x2D
; 0000 117E         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
	__POINTW1FN _0x0,1384
	CALL SUBOPT_0x37
; 0000 117F         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1180         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
	__POINTW1FN _0x0,1384
	CALL SUBOPT_0x86
; 0000 1181 
; 0000 1182         }
	RJMP _0x180
_0x182:
; 0000 1183     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x18C
; 0000 1184         {
; 0000 1185         while(sg == 0)
_0x18D:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x18F
; 0000 1186             {
; 0000 1187             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	PUSH R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	POP  R26
	AND  R30,R26
	BREQ _0x190
; 0000 1188                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	MOVW R16,R30
; 0000 1189 
; 0000 118A 
; 0000 118B             }
_0x190:
	RJMP _0x18D
_0x18F:
; 0000 118C 
; 0000 118D         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 118E         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 118F 
; 0000 1190         PORTD.7 = 0;
	CALL SUBOPT_0x87
; 0000 1191        if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x193
; 0000 1192             {
; 0000 1193             PORTE.2 = 1;
	CALL SUBOPT_0x88
; 0000 1194             byla_wloczona_szlifierka_1 = 0;
; 0000 1195             }
; 0000 1196         if(byla_wloczona_szlifierka_2 == 1)
_0x193:
	CALL SUBOPT_0x89
	BRNE _0x196
; 0000 1197             {
; 0000 1198             PORTE.3 = 1;
	CALL SUBOPT_0x8A
; 0000 1199             byla_wloczona_szlifierka_2 = 0;
; 0000 119A             }
; 0000 119B         if(byl_wloczony_przedmuch == 1)
_0x196:
	CALL SUBOPT_0x8B
	BRNE _0x199
; 0000 119C             {
; 0000 119D             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x8C
; 0000 119E             PORTF = PORT_F.byte;
; 0000 119F             sek12 = zastopowany_czas_przedmuchu;
; 0000 11A0             byl_wloczony_przedmuch = 0;
; 0000 11A1             }
; 0000 11A2 
; 0000 11A3         }
_0x199:
; 0000 11A4    }
_0x18C:
; 0000 11A5 
; 0000 11A6 
; 0000 11A7 
; 0000 11A8 
; 0000 11A9 
; 0000 11AA }
_0x17F:
_0x20A0002:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;
;void wartosci_wstepne_panelu()
; 0000 11AF {
_wartosci_wstepne_panelu:
; 0000 11B0                                                       //3040
; 0000 11B1 wartosc_parametru_panelu(szczotka_druciana_ilosc_cykli,48,64);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x90
	CALL SUBOPT_0x91
	CALL SUBOPT_0x92
; 0000 11B2                                                 //2090
; 0000 11B3 wartosc_parametru_panelu(krazek_scierny_ilosc_cykli,32,144);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x93
	CALL SUBOPT_0x94
	CALL SUBOPT_0xB
	CALL _wartosc_parametru_panelu
; 0000 11B4                                                         //3000
; 0000 11B5 wartosc_parametru_panelu(krazek_scierny_cykl_po_okregu_ilosc,48,0);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x73
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0xA
	CALL _wartosc_parametru_panelu
; 0000 11B6                                                 //2050
; 0000 11B7 wartosc_parametru_panelu(predkosc_pion_szczotka,32,80);
	LDS  R30,_predkosc_pion_szczotka
	LDS  R31,_predkosc_pion_szczotka+1
	CALL SUBOPT_0x94
	CALL SUBOPT_0x28
	CALL _wartosc_parametru_panelu
; 0000 11B8                                                 //2060
; 0000 11B9 wartosc_parametru_panelu(predkosc_pion_krazek,32,96);
	LDS  R30,_predkosc_pion_krazek
	LDS  R31,_predkosc_pion_krazek+1
	CALL SUBOPT_0x94
	CALL SUBOPT_0x29
	CALL _wartosc_parametru_panelu
; 0000 11BA                                                                        //3010
; 0000 11BB wartosc_parametru_panelu(wejscie_krazka_sciernego_w_pow_boczna_cylindra,48,16);
	LDS  R30,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R31,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	CALL SUBOPT_0x91
	CALL SUBOPT_0x26
	CALL _wartosc_parametru_panelu
; 0000 11BC                                                                      //2070
; 0000 11BD wartosc_parametru_panelu(predkosc_ruchow_po_okregu_krazek_scierny,32,112);
	LDS  R30,_predkosc_ruchow_po_okregu_krazek_scierny
	LDS  R31,_predkosc_ruchow_po_okregu_krazek_scierny+1
	CALL SUBOPT_0x94
	CALL SUBOPT_0x95
; 0000 11BE 
; 0000 11BF wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x26
	CALL SUBOPT_0x95
; 0000 11C0 
; 0000 11C1 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_stala)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_stala)
	CALL __EEPROMRDW
	CALL SUBOPT_0x94
	CALL SUBOPT_0x26
	CALL _wartosc_parametru_panelu
; 0000 11C2 
; 0000 11C3 wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 11C4 
; 0000 11C5 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h,16,48);
; 0000 11C6 
; 0000 11C7 wartosc_parametru_panelu(40,48,112);  //srednica krazka wstepnie
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x91
	CALL SUBOPT_0x95
; 0000 11C8 
; 0000 11C9 }
	RET
;
;void wypozycjonuj_napedy_minimalistyczna()
; 0000 11CC {
_wypozycjonuj_napedy_minimalistyczna:
; 0000 11CD 
; 0000 11CE while(start == 0)
_0x19A:
	LDS  R30,_start
	LDS  R31,_start+1
	SBIW R30,0
	BRNE _0x19C
; 0000 11CF     {
; 0000 11D0     komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 11D1     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr1,adr2);
	__POINTW1FN _0x0,1422
	CALL SUBOPT_0x37
; 0000 11D2     komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 11D3     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr3,adr4);
	__POINTW1FN _0x0,1422
	CALL SUBOPT_0x86
; 0000 11D4     delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 11D5     start = odczytaj_parametr(0,64);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	STS  _start,R30
	STS  _start+1,R31
; 0000 11D6     }
	RJMP _0x19A
_0x19C:
; 0000 11D7 
; 0000 11D8 
; 0000 11D9 while(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
_0x19D:
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x97
	PUSH R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x98
	POP  R26
	OR   R30,R26
	BREQ _0x19F
; 0000 11DA     {
; 0000 11DB     komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 11DC     komunikat_na_panel("Zamknij oslony gorne",adr1,adr2);
	__POINTW1FN _0x0,1463
	CALL SUBOPT_0x37
; 0000 11DD     komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 11DE     komunikat_na_panel("Zamknij oslony gorne",adr3,adr4);
	__POINTW1FN _0x0,1463
	CALL SUBOPT_0x86
; 0000 11DF     }
	RJMP _0x19D
_0x19F:
; 0000 11E0 
; 0000 11E1 
; 0000 11E2 PORTB.4 = 1;   //setupy piony
	SBI  0x18,4
; 0000 11E3 
; 0000 11E4 delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 11E5 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 11E6 
; 0000 11E7 
; 0000 11E8 
; 0000 11E9 while(sprawdz_pin3(PORTKK,0x75) == 1 | sprawdz_pin7(PORTKK,0x75) == 1)
_0x1A4:
	CALL SUBOPT_0x99
	CALL SUBOPT_0x9A
	PUSH R30
	CALL SUBOPT_0x99
	CALL SUBOPT_0x9B
	POP  R26
	OR   R30,R26
	BRNE PC+3
	JMP _0x1A6
; 0000 11EA       {
; 0000 11EB       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x97
	PUSH R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x98
	POP  R26
	OR   R30,R26
	BREQ _0x1A7
; 0000 11EC         while(1)
_0x1A8:
; 0000 11ED             {
; 0000 11EE             PORTD.7 = 1;
	CALL SUBOPT_0x9C
; 0000 11EF             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 11F0 
; 0000 11F1             PORTB.4 = 0;   //setupy piony
; 0000 11F2             PORTD.2 = 0;   //setup wspolny
; 0000 11F3 
; 0000 11F4             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 11F5             komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1484
	CALL SUBOPT_0x37
; 0000 11F6             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 11F7             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0x9D
; 0000 11F8 
; 0000 11F9             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x92
; 0000 11FA             }
	RJMP _0x1A8
; 0000 11FB       if(sprawdz_pin2(PORTMM,0x77) == 0)
_0x1A7:
	CALL SUBOPT_0x1A
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x1B3
; 0000 11FC         while(1)
_0x1B4:
; 0000 11FD             {
; 0000 11FE             PORTD.7 = 1;
	CALL SUBOPT_0x9C
; 0000 11FF             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 1200 
; 0000 1201             PORTB.4 = 0;   //setupy piony
; 0000 1202             PORTD.2 = 0;   //setup wspolny
; 0000 1203 
; 0000 1204             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1205             komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1547
	CALL SUBOPT_0x37
; 0000 1206             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1207             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0x9D
; 0000 1208 
; 0000 1209             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x92
; 0000 120A             }
	RJMP _0x1B4
; 0000 120B 
; 0000 120C 
; 0000 120D 
; 0000 120E 
; 0000 120F 
; 0000 1210 
; 0000 1211 
; 0000 1212 
; 0000 1213       komunikat_na_panel("                                                ",adr1,adr2);
_0x1B3:
	CALL SUBOPT_0x2D
; 0000 1214       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1584
	CALL SUBOPT_0x37
; 0000 1215       komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1216       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1584
	CALL SUBOPT_0x86
; 0000 1217       delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 1218 
; 0000 1219       if(sprawdz_pin3(PORTKK,0x75) == 0)
	CALL SUBOPT_0x99
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1BF
; 0000 121A             {
; 0000 121B             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 121C             komunikat_na_panel("Sterownik 3 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1615
	CALL SUBOPT_0x37
; 0000 121D             delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 121E             }
; 0000 121F       if(sprawdz_pin7(PORTKK,0x75) == 0)
_0x1BF:
	CALL SUBOPT_0x99
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x1C0
; 0000 1220             {
; 0000 1221             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1222             komunikat_na_panel("Sterownik 4 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1646
	CALL SUBOPT_0x37
; 0000 1223             delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 1224             }
; 0000 1225 
; 0000 1226 
; 0000 1227       if(sprawdz_pin6(PORTMM,0x77) == 1 |
_0x1C0:
; 0000 1228          sprawdz_pin7(PORTMM,0x77) == 1)
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x9E
	PUSH R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x9B
	POP  R26
	OR   R30,R26
	BREQ _0x1C1
; 0000 1229             {
; 0000 122A             PORTD.7 = 1;
	SBI  0x12,7
; 0000 122B             if(sprawdz_pin6(PORTMM,0x77) == 1)
	CALL SUBOPT_0x1A
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x1C4
; 0000 122C                 {
; 0000 122D                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 122E                 komunikat_na_panel("Alarm Sterownik 4",adr1,adr2);
	__POINTW1FN _0x0,1677
	CALL SUBOPT_0x37
; 0000 122F                 delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 1230                 }
; 0000 1231             if(sprawdz_pin7(PORTMM,0x77) == 1)
_0x1C4:
	CALL SUBOPT_0x1A
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x1C5
; 0000 1232                 {
; 0000 1233                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 1234                 komunikat_na_panel("Alarm Sterownik 3",adr1,adr2);
	__POINTW1FN _0x0,1695
	CALL SUBOPT_0x37
; 0000 1235                 delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 1236                 }
; 0000 1237             }
_0x1C5:
; 0000 1238 
; 0000 1239 
; 0000 123A 
; 0000 123B 
; 0000 123C 
; 0000 123D 
; 0000 123E 
; 0000 123F 
; 0000 1240       }
_0x1C1:
	RJMP _0x1A4
_0x1A6:
; 0000 1241 
; 0000 1242 PORTB.4 = 0;   //setupy piony
	CBI  0x18,4
; 0000 1243 PORTD.2 = 1;   //setup poziomy
	SBI  0x12,2
; 0000 1244 delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 1245 
; 0000 1246 
; 0000 1247 while(sprawdz_pin3(PORTJJ,0x79) == 1 | sprawdz_pin3(PORTLL,0x71) == 1)
_0x1CA:
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x9A
	PUSH R30
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x9A
	POP  R26
	OR   R30,R26
	BRNE PC+3
	JMP _0x1CC
; 0000 1248       {
; 0000 1249 
; 0000 124A       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x97
	PUSH R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x98
	POP  R26
	OR   R30,R26
	BREQ _0x1CD
; 0000 124B         while(1)
_0x1CE:
; 0000 124C             {
; 0000 124D             PORTD.7 = 1;
	SBI  0x12,7
; 0000 124E             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 124F             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 1250             komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1484
	CALL SUBOPT_0x37
; 0000 1251             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1252             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0x9D
; 0000 1253 
; 0000 1254             PORTB.4 = 0;   //setupy piony
	CBI  0x18,4
; 0000 1255             PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 1256 
; 0000 1257             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x92
; 0000 1258             }
	RJMP _0x1CE
; 0000 1259 
; 0000 125A       if(sprawdz_pin2(PORTMM,0x77) == 0)
_0x1CD:
	CALL SUBOPT_0x1A
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x1D9
; 0000 125B         while(1)
_0x1DA:
; 0000 125C             {
; 0000 125D             PORTD.7 = 1;
	CALL SUBOPT_0x9C
; 0000 125E             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 125F 
; 0000 1260             PORTB.4 = 0;   //setupy piony
; 0000 1261             PORTD.2 = 0;   //setup wspolny
; 0000 1262 
; 0000 1263             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1264             komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1547
	CALL SUBOPT_0x37
; 0000 1265             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1266             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0x9D
; 0000 1267 
; 0000 1268             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x92
; 0000 1269             }
	RJMP _0x1DA
; 0000 126A 
; 0000 126B 
; 0000 126C 
; 0000 126D 
; 0000 126E       komunikat_na_panel("                                                ",adr1,adr2);
_0x1D9:
	CALL SUBOPT_0x2D
; 0000 126F       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1584
	CALL SUBOPT_0x37
; 0000 1270       komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1271       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1584
	CALL SUBOPT_0x86
; 0000 1272       delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 1273 
; 0000 1274       if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1E5
; 0000 1275             {
; 0000 1276             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 1277             komunikat_na_panel("Sterownik 1 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1713
	CALL SUBOPT_0x37
; 0000 1278             delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 1279             }
; 0000 127A       if(sprawdz_pin3(PORTLL,0x71) == 0)
_0x1E5:
	CALL SUBOPT_0x9F
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1E6
; 0000 127B             {
; 0000 127C             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 127D             komunikat_na_panel("Sterownik 2 - wypozycjonowalem",adr3,adr4);
	__POINTW1FN _0x0,1744
	CALL SUBOPT_0x86
; 0000 127E             delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 127F             }
; 0000 1280 
; 0000 1281        //if(sprawdz_pin7(PORTMM,0x77) == 1)
; 0000 1282        //     PORTD.7 = 1;
; 0000 1283 
; 0000 1284       if(sprawdz_pin5(PORTJJ,0x79) == 1 |
_0x1E6:
; 0000 1285          sprawdz_pin5(PORTLL,0x71) == 1)
	CALL SUBOPT_0x2C
	CALL SUBOPT_0xA0
	PUSH R30
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xA0
	POP  R26
	OR   R30,R26
	BREQ _0x1E7
; 0000 1286             {
; 0000 1287             PORTD.7 = 1;
	SBI  0x12,7
; 0000 1288             if(sprawdz_pin5(PORTJJ,0x79) == 1)
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x1EA
; 0000 1289                 {
; 0000 128A                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 128B                 komunikat_na_panel("Alarm Sterownik 1",adr1,adr2);
	__POINTW1FN _0x0,1775
	CALL SUBOPT_0x37
; 0000 128C                 delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 128D                 }
; 0000 128E             if(sprawdz_pin5(PORTLL,0x71) == 1)
_0x1EA:
	CALL SUBOPT_0x9F
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x1EB
; 0000 128F                 {
; 0000 1290                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 1291                 komunikat_na_panel("Alarm Sterownik 2",adr1,adr2);
	__POINTW1FN _0x0,1793
	CALL SUBOPT_0x37
; 0000 1292                 delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 1293                 }
; 0000 1294 
; 0000 1295             }
_0x1EB:
; 0000 1296 
; 0000 1297       //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 1298 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 1299       //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 129A        //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 129B 
; 0000 129C 
; 0000 129D 
; 0000 129E       }
_0x1E7:
	RJMP _0x1CA
_0x1CC:
; 0000 129F 
; 0000 12A0 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 12A1 komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1811
	CALL SUBOPT_0x37
; 0000 12A2 komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 12A3 komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1811
	CALL SUBOPT_0x86
; 0000 12A4 
; 0000 12A5 PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 12A6 PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 12A7 delay_ms(1000);
	CALL SUBOPT_0x96
; 0000 12A8 wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x92
; 0000 12A9 start = 0;
	CALL SUBOPT_0xA1
; 0000 12AA 
; 0000 12AB }
	RET
;
;
;void przerzucanie_dociskow()
; 0000 12AF {
_przerzucanie_dociskow:
; 0000 12B0 
; 0000 12B1 
; 0000 12B2 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	PUSH R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x1F0
; 0000 12B3   {
; 0000 12B4    if(sprawdz_pin6(PORTLL,0x71) == 0 & sprawdz_pin7(PORTLL,0x71) == 0 & czekaj_az_puszcze == 0)
	CALL SUBOPT_0x9F
	CALL _sprawdz_pin6
	LDI  R26,LOW(0)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0x9F
	CALL _sprawdz_pin7
	LDI  R26,LOW(0)
	CALL __EQB12
	POP  R26
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x1F1
; 0000 12B5            {
; 0000 12B6            czekaj_az_puszcze = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 12B7            //PORTB.6 = 1;
; 0000 12B8            }
; 0000 12B9        if(sprawdz_pin6(PORTLL,0x71) == 1 & sprawdz_pin7(PORTLL,0x71) == 1 & czekaj_az_puszcze == 1)
_0x1F1:
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x9E
	PUSH R30
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x9B
	POP  R26
	CALL SUBOPT_0xA2
	CALL SUBOPT_0x74
	AND  R30,R0
	BREQ _0x1F2
; 0000 12BA            {
; 0000 12BB            czekaj_az_puszcze = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 12BC            //PORTB.6 = 0;
; 0000 12BD            }
; 0000 12BE 
; 0000 12BF        if(czekaj_az_puszcze == 2 & PORTE.6 == 1)
_0x1F2:
	CALL SUBOPT_0xA4
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x1F3
; 0000 12C0             {
; 0000 12C1             PORTE.6 = 0;
	CBI  0x3,6
; 0000 12C2             czekaj_az_puszcze = 0;
	CALL SUBOPT_0xA5
; 0000 12C3             delay_ms(100);
; 0000 12C4             }
; 0000 12C5 
; 0000 12C6        if(czekaj_az_puszcze == 2 & PORTE.6 == 0)
_0x1F3:
	CALL SUBOPT_0xA4
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x1F6
; 0000 12C7            {
; 0000 12C8             PORTE.6 = 1;
	SBI  0x3,6
; 0000 12C9             czekaj_az_puszcze = 0;
	CALL SUBOPT_0xA5
; 0000 12CA             delay_ms(100);
; 0000 12CB            }
; 0000 12CC 
; 0000 12CD   }
_0x1F6:
; 0000 12CE }
_0x1F0:
	RET
;
;void ostateczny_wybor_zacisku()
; 0000 12D1 {
_ostateczny_wybor_zacisku:
; 0000 12D2 int rzad;
; 0000 12D3 
; 0000 12D4   if(sek11 > 60) //co 1s sekunde sprawdzam   //jak co 40 to sie wywala
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	LDS  R26,_sek11
	LDS  R27,_sek11+1
	LDS  R24,_sek11+2
	LDS  R25,_sek11+3
	__CPD2N 0x3D
	BRGE PC+3
	JMP _0x1F9
; 0000 12D5         {
; 0000 12D6        sek11 = 0;
	CALL SUBOPT_0xA6
; 0000 12D7        if(odczytalem_zacisk < il_prob_odczytu &
; 0000 12D8                                            (sprawdz_pin0(PORTHH,0x73) == 1 |
; 0000 12D9                                             sprawdz_pin1(PORTHH,0x73) == 1 |
; 0000 12DA                                             sprawdz_pin2(PORTHH,0x73) == 1 |
; 0000 12DB                                             sprawdz_pin3(PORTHH,0x73) == 1 |
; 0000 12DC                                             sprawdz_pin4(PORTHH,0x73) == 1 |
; 0000 12DD                                             sprawdz_pin5(PORTHH,0x73) == 1 |
; 0000 12DE                                             sprawdz_pin6(PORTHH,0x73) == 1 |
; 0000 12DF                                             sprawdz_pin7(PORTHH,0x73) == 1))
	MOVW R30,R10
	MOVW R26,R8
	CALL __LTW12
	PUSH R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x97
	PUSH R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x98
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2F
	CALL _sprawdz_pin2
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x9A
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2F
	CALL _sprawdz_pin4
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0xA0
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x9E
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x9B
	POP  R26
	OR   R30,R26
	POP  R26
	AND  R30,R26
	BREQ _0x1FA
; 0000 12E0         {
; 0000 12E1         odczytalem_zacisk++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 12E2         }
; 0000 12E3         }
_0x1FA:
; 0000 12E4 
; 0000 12E5 if(odczytalem_zacisk == il_prob_odczytu)
_0x1F9:
	__CPWRR 10,11,8,9
	BRNE _0x1FB
; 0000 12E6         {
; 0000 12E7         //PORTB = 0xFF;
; 0000 12E8         rzad = odczyt_wybranego_zacisku();
	CALL _odczyt_wybranego_zacisku
	MOVW R16,R30
; 0000 12E9         //sek10 = 0;
; 0000 12EA         sek11 = 0;    //nowe
	CALL SUBOPT_0xA6
; 0000 12EB         odczytalem_zacisk++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 12EC 
; 0000 12ED         //if(rzad == 1)
; 0000 12EE         //    wartosc_parametru_panelu(2,32,128);    //tego nie chca
; 0000 12EF         //if(rzad == 2)
; 0000 12F0         //    wartosc_parametru_panelu(1,32,128);
; 0000 12F1 
; 0000 12F2         }                                     //& sek10 > 1                //3s po odczytaniu dopiero sprawdzam port
; 0000 12F3 if((odczytalem_zacisk == il_prob_odczytu + 1))        //183
_0x1FB:
	MOVW R30,R10
	ADIW R30,1
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x1FC
; 0000 12F4         {
; 0000 12F5         odczytalem_zacisk = 0;
	CLR  R8
	CLR  R9
; 0000 12F6         }
; 0000 12F7 }
_0x1FC:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;
;int sterownik_1_praca(int PORT)
; 0000 12FC {
_sterownik_1_praca:
; 0000 12FD //PORTA.0   IN0  STEROWNIK1
; 0000 12FE //PORTA.1   IN1  STEROWNIK1
; 0000 12FF //PORTA.2   IN2  STEROWNIK1
; 0000 1300 //PORTA.3   IN3  STEROWNIK1
; 0000 1301 //PORTA.4   IN4  STEROWNIK1
; 0000 1302 //PORTA.5   IN5  STEROWNIK1
; 0000 1303 //PORTA.6   IN6  STEROWNIK1
; 0000 1304 //PORTA.7   IN7  STEROWNIK1
; 0000 1305 //PORTD.4   IN8 STEROWNIK1
; 0000 1306 
; 0000 1307 //PORTD.2  SETUP   STEROWNIK1
; 0000 1308 //PORTD.3  DRIVE   STEROWNIK1
; 0000 1309 
; 0000 130A //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 130B //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 130C 
; 0000 130D if(sprawdz_pin5(PORTJJ,0x79) == 1)     //if alarn
;	PORT -> Y+0
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x1FD
; 0000 130E     {
; 0000 130F     PORTD.7 = 1;
	SBI  0x12,7
; 0000 1310     PORTE.2 = 0;
	CBI  0x3,2
; 0000 1311     PORTE.3 = 0;  //szlifierki stop
	CBI  0x3,3
; 0000 1312     }
; 0000 1313 
; 0000 1314 if(start == 1)
_0x1FD:
	CALL SUBOPT_0xA7
	BRNE _0x204
; 0000 1315     {
; 0000 1316     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xA8
; 0000 1317     obsluga_nacisniecia_zatrzymaj();
; 0000 1318     }
; 0000 1319 switch(cykl_sterownik_1)
_0x204:
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
; 0000 131A         {
; 0000 131B         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x208
; 0000 131C 
; 0000 131D             sek1 = 0;
	CALL SUBOPT_0xA9
; 0000 131E             PORT_STER1.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER1,R30
; 0000 131F             PORTA.0 = PORT_STER1.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x209
	CBI  0x1B,0
	RJMP _0x20A
_0x209:
	SBI  0x1B,0
_0x20A:
; 0000 1320             PORTA.1 = PORT_STER1.bits.b1;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x2)
	BRNE _0x20B
	CBI  0x1B,1
	RJMP _0x20C
_0x20B:
	SBI  0x1B,1
_0x20C:
; 0000 1321             PORTA.2 = PORT_STER1.bits.b2;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x4)
	BRNE _0x20D
	CBI  0x1B,2
	RJMP _0x20E
_0x20D:
	SBI  0x1B,2
_0x20E:
; 0000 1322             PORTA.3 = PORT_STER1.bits.b3;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x8)
	BRNE _0x20F
	CBI  0x1B,3
	RJMP _0x210
_0x20F:
	SBI  0x1B,3
_0x210:
; 0000 1323             PORTA.4 = PORT_STER1.bits.b4;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x10)
	BRNE _0x211
	CBI  0x1B,4
	RJMP _0x212
_0x211:
	SBI  0x1B,4
_0x212:
; 0000 1324             PORTA.5 = PORT_STER1.bits.b5;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x20)
	BRNE _0x213
	CBI  0x1B,5
	RJMP _0x214
_0x213:
	SBI  0x1B,5
_0x214:
; 0000 1325             PORTA.6 = PORT_STER1.bits.b6;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x40)
	BRNE _0x215
	CBI  0x1B,6
	RJMP _0x216
_0x215:
	SBI  0x1B,6
_0x216:
; 0000 1326             PORTA.7 = PORT_STER1.bits.b7;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x80)
	BRNE _0x217
	CBI  0x1B,7
	RJMP _0x218
_0x217:
	SBI  0x1B,7
_0x218:
; 0000 1327 
; 0000 1328             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x219
; 0000 1329                 PORTD.4 = 1;
	SBI  0x12,4
; 0000 132A 
; 0000 132B 
; 0000 132C 
; 0000 132D             cykl_sterownik_1 = 1;
_0x219:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x469
; 0000 132E 
; 0000 132F         break;
; 0000 1330 
; 0000 1331         case 1:
_0x208:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x21C
; 0000 1332 
; 0000 1333             if(sek1 > 1)
	LDS  R26,_sek1
	LDS  R27,_sek1+1
	LDS  R24,_sek1+2
	LDS  R25,_sek1+3
	CALL SUBOPT_0xAA
	BRLT _0x21D
; 0000 1334                 {
; 0000 1335 
; 0000 1336                 PORTD.3 = 1;
	SBI  0x12,3
; 0000 1337                 cykl_sterownik_1 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xAB
; 0000 1338                 }
; 0000 1339         break;
_0x21D:
	RJMP _0x207
; 0000 133A 
; 0000 133B 
; 0000 133C         case 2:
_0x21C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x220
; 0000 133D 
; 0000 133E                if(sprawdz_pin0(PORTJJ,0x79) == 0)     //busy
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x221
; 0000 133F                   {
; 0000 1340 
; 0000 1341                   PORTD.3 = 0;
	CBI  0x12,3
; 0000 1342                   PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 1343                   PORTD.4 = 0;
	CBI  0x12,4
; 0000 1344                   sek1 = 0;
	CALL SUBOPT_0xA9
; 0000 1345                   cykl_sterownik_1 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xAB
; 0000 1346                   }
; 0000 1347 
; 0000 1348         break;
_0x221:
	RJMP _0x207
; 0000 1349 
; 0000 134A         case 3:
_0x220:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x226
; 0000 134B 
; 0000 134C                if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x227
; 0000 134D                   {
; 0000 134E 
; 0000 134F                   sek1 = 0;
	CALL SUBOPT_0xA9
; 0000 1350                   cykl_sterownik_1 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xAB
; 0000 1351                   }
; 0000 1352 
; 0000 1353 
; 0000 1354         break;
_0x227:
	RJMP _0x207
; 0000 1355 
; 0000 1356 
; 0000 1357         case 4:
_0x226:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x207
; 0000 1358 
; 0000 1359             if(sprawdz_pin0(PORTJJ,0x79) == 1)
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x229
; 0000 135A                 {
; 0000 135B 
; 0000 135C                 cykl_sterownik_1 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x469:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
; 0000 135D                 }
; 0000 135E         break;
_0x229:
; 0000 135F 
; 0000 1360         }
_0x207:
; 0000 1361 
; 0000 1362 return cykl_sterownik_1;
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
	RJMP _0x20A0001
; 0000 1363 }
;
;
;int sterownik_2_praca(int PORT)
; 0000 1367 {
_sterownik_2_praca:
; 0000 1368 //PORTC.0   IN0  STEROWNIK2
; 0000 1369 //PORTC.1   IN1  STEROWNIK2
; 0000 136A //PORTC.2   IN2  STEROWNIK2
; 0000 136B //PORTC.3   IN3  STEROWNIK2
; 0000 136C //PORTC.4   IN4  STEROWNIK2
; 0000 136D //PORTC.5   IN5  STEROWNIK2
; 0000 136E //PORTC.6   IN6  STEROWNIK2
; 0000 136F //PORTC.7   IN7  STEROWNIK2
; 0000 1370 //PORTD.5   IN8 STEROWNIK2
; 0000 1371 
; 0000 1372 
; 0000 1373 //PORTD.5  SETUP   STEROWNIK2
; 0000 1374 //PORTD.6  DRIVE   STEROWNIK2
; 0000 1375 
; 0000 1376 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 1377 //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 1378 
; 0000 1379  if(sprawdz_pin5(PORTLL,0x71) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0x9F
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x22A
; 0000 137A     {
; 0000 137B     PORTD.7 = 1;
	SBI  0x12,7
; 0000 137C     PORTE.2 = 0;
	CBI  0x3,2
; 0000 137D     PORTE.3 = 0;  //szlifierki stop
	CBI  0x3,3
; 0000 137E     }
; 0000 137F if(start == 1)
_0x22A:
	CALL SUBOPT_0xA7
	BRNE _0x231
; 0000 1380     {
; 0000 1381     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xA8
; 0000 1382     obsluga_nacisniecia_zatrzymaj();
; 0000 1383     }
; 0000 1384 switch(cykl_sterownik_2)
_0x231:
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
; 0000 1385         {
; 0000 1386         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x235
; 0000 1387 
; 0000 1388             sek3 = 0;
	CALL SUBOPT_0xAC
; 0000 1389             PORT_STER2.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER2,R30
; 0000 138A             PORTC.0 = PORT_STER2.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x236
	CBI  0x15,0
	RJMP _0x237
_0x236:
	SBI  0x15,0
_0x237:
; 0000 138B             PORTC.1 = PORT_STER2.bits.b1;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x2)
	BRNE _0x238
	CBI  0x15,1
	RJMP _0x239
_0x238:
	SBI  0x15,1
_0x239:
; 0000 138C             PORTC.2 = PORT_STER2.bits.b2;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x4)
	BRNE _0x23A
	CBI  0x15,2
	RJMP _0x23B
_0x23A:
	SBI  0x15,2
_0x23B:
; 0000 138D             PORTC.3 = PORT_STER2.bits.b3;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x8)
	BRNE _0x23C
	CBI  0x15,3
	RJMP _0x23D
_0x23C:
	SBI  0x15,3
_0x23D:
; 0000 138E             PORTC.4 = PORT_STER2.bits.b4;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x10)
	BRNE _0x23E
	CBI  0x15,4
	RJMP _0x23F
_0x23E:
	SBI  0x15,4
_0x23F:
; 0000 138F             PORTC.5 = PORT_STER2.bits.b5;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x20)
	BRNE _0x240
	CBI  0x15,5
	RJMP _0x241
_0x240:
	SBI  0x15,5
_0x241:
; 0000 1390             PORTC.6 = PORT_STER2.bits.b6;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x40)
	BRNE _0x242
	CBI  0x15,6
	RJMP _0x243
_0x242:
	SBI  0x15,6
_0x243:
; 0000 1391             PORTC.7 = PORT_STER2.bits.b7;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x80)
	BRNE _0x244
	CBI  0x15,7
	RJMP _0x245
_0x244:
	SBI  0x15,7
_0x245:
; 0000 1392             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x246
; 0000 1393                 PORTD.5 = 1;
	SBI  0x12,5
; 0000 1394 
; 0000 1395 
; 0000 1396             cykl_sterownik_2 = 1;
_0x246:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x46A
; 0000 1397 
; 0000 1398 
; 0000 1399         break;
; 0000 139A 
; 0000 139B         case 1:
_0x235:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x249
; 0000 139C 
; 0000 139D             if(sek3 > 1)
	LDS  R26,_sek3
	LDS  R27,_sek3+1
	LDS  R24,_sek3+2
	LDS  R25,_sek3+3
	CALL SUBOPT_0xAA
	BRLT _0x24A
; 0000 139E                 {
; 0000 139F                 PORTD.6 = 1;
	SBI  0x12,6
; 0000 13A0                 cykl_sterownik_2 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xAD
; 0000 13A1                 }
; 0000 13A2         break;
_0x24A:
	RJMP _0x234
; 0000 13A3 
; 0000 13A4 
; 0000 13A5         case 2:
_0x249:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x24D
; 0000 13A6 
; 0000 13A7                if(sprawdz_pin0(PORTLL,0x71) == 0)     //busy
	CALL SUBOPT_0x9F
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x24E
; 0000 13A8                   {
; 0000 13A9                   PORTD.6 = 0;
	CBI  0x12,6
; 0000 13AA                   PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 13AB                   PORTD.5 = 0;
	CBI  0x12,5
; 0000 13AC                   sek3 = 0;
	CALL SUBOPT_0xAC
; 0000 13AD                   cykl_sterownik_2 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xAD
; 0000 13AE                   }
; 0000 13AF 
; 0000 13B0         break;
_0x24E:
	RJMP _0x234
; 0000 13B1 
; 0000 13B2         case 3:
_0x24D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x253
; 0000 13B3 
; 0000 13B4                if(sprawdz_pin3(PORTLL,0x71) == 0)
	CALL SUBOPT_0x9F
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x254
; 0000 13B5                   {
; 0000 13B6                   sek3 = 0;
	CALL SUBOPT_0xAC
; 0000 13B7                   cykl_sterownik_2 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xAD
; 0000 13B8                   }
; 0000 13B9 
; 0000 13BA 
; 0000 13BB         break;
_0x254:
	RJMP _0x234
; 0000 13BC 
; 0000 13BD 
; 0000 13BE         case 4:
_0x253:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x234
; 0000 13BF 
; 0000 13C0             if(sprawdz_pin0(PORTLL,0x71) == 1)
	CALL SUBOPT_0x9F
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x256
; 0000 13C1                 {
; 0000 13C2                 cykl_sterownik_2 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x46A:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
; 0000 13C3                 }
; 0000 13C4         break;
_0x256:
; 0000 13C5 
; 0000 13C6         }
_0x234:
; 0000 13C7 
; 0000 13C8 return cykl_sterownik_2;
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
	RJMP _0x20A0001
; 0000 13C9 }
;
;
;
;
;
;
;int sterownik_3_praca(int PORT)
; 0000 13D1 {
_sterownik_3_praca:
; 0000 13D2 //PORTF.0   IN0  STEROWNIK3
; 0000 13D3 //PORTF.1   IN1  STEROWNIK3
; 0000 13D4 //PORTF.2   IN2  STEROWNIK3
; 0000 13D5 //PORTF.3   IN3  STEROWNIK3
; 0000 13D6 //PORTF.7   IN4 STEROWNIK 3
; 0000 13D7 //PORTB.7   IN5 STEROWNIK 3
; 0000 13D8 
; 0000 13D9 
; 0000 13DA 
; 0000 13DB //PORTF.5   DRIVE  STEROWNIK3
; 0000 13DC 
; 0000 13DD //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 13DE //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 13DF 
; 0000 13E0 if(sprawdz_pin7(PORTMM,0x77) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0x1A
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x257
; 0000 13E1      {
; 0000 13E2      PORTD.7 = 1;
	SBI  0x12,7
; 0000 13E3      PORTE.2 = 0;
	CBI  0x3,2
; 0000 13E4      PORTE.3 = 0;  //szlifierki stop
	CBI  0x3,3
; 0000 13E5      }
; 0000 13E6 if(start == 1)
_0x257:
	CALL SUBOPT_0xA7
	BRNE _0x25E
; 0000 13E7     {
; 0000 13E8     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xA8
; 0000 13E9     obsluga_nacisniecia_zatrzymaj();
; 0000 13EA     }
; 0000 13EB switch(cykl_sterownik_3)
_0x25E:
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
; 0000 13EC         {
; 0000 13ED         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x262
; 0000 13EE 
; 0000 13EF             PORT_STER3.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER3,R30
; 0000 13F0             PORT_F.bits.b0 = PORT_STER3.bits.b0;
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0xAE
; 0000 13F1             PORT_F.bits.b1 = PORT_STER3.bits.b1;
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFD
	CALL SUBOPT_0xAE
; 0000 13F2             PORT_F.bits.b2 = PORT_STER3.bits.b2;
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFB
	CALL SUBOPT_0xAE
; 0000 13F3             PORT_F.bits.b3 = PORT_STER3.bits.b3;
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
; 0000 13F4             PORT_F.bits.b7 = PORT_STER3.bits.b4;
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
; 0000 13F5             PORTF = PORT_F.byte;
; 0000 13F6             PORTB.7 = PORT_STER3.bits.b5;
	LDS  R30,_PORT_STER3
	ANDI R30,LOW(0x20)
	BRNE _0x263
	CBI  0x18,7
	RJMP _0x264
_0x263:
	SBI  0x18,7
_0x264:
; 0000 13F7 
; 0000 13F8 
; 0000 13F9 
; 0000 13FA             sek2 = 0;
	CALL SUBOPT_0xB0
; 0000 13FB             cykl_sterownik_3 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0xB1
; 0000 13FC 
; 0000 13FD 
; 0000 13FE 
; 0000 13FF         break;
	RJMP _0x261
; 0000 1400 
; 0000 1401         case 1:
_0x262:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x265
; 0000 1402 
; 0000 1403 
; 0000 1404             if(sek2 > 1)
	LDS  R26,_sek2
	LDS  R27,_sek2+1
	LDS  R24,_sek2+2
	LDS  R25,_sek2+3
	CALL SUBOPT_0xAA
	BRLT _0x266
; 0000 1405                 {
; 0000 1406 
; 0000 1407                 PORT_F.bits.b5 = 1;
	LDS  R30,_PORT_F
	ORI  R30,0x20
	CALL SUBOPT_0xAF
; 0000 1408                 PORTF = PORT_F.byte;
; 0000 1409                 cykl_sterownik_3 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xB1
; 0000 140A                 }
; 0000 140B         break;
_0x266:
	RJMP _0x261
; 0000 140C 
; 0000 140D 
; 0000 140E         case 2:
_0x265:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x267
; 0000 140F 
; 0000 1410 
; 0000 1411                if(sprawdz_pin0(PORTKK,0x75) == 0)
	CALL SUBOPT_0x99
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x268
; 0000 1412                   {
; 0000 1413                   PORT_F.bits.b5 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xDF
	CALL SUBOPT_0xAF
; 0000 1414                   PORTF = PORT_F.byte;
; 0000 1415 
; 0000 1416                   PORT_F.bits.b0 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0xB2
; 0000 1417                   PORT_F.bits.b1 = 0;
	ANDI R30,0xFD
	CALL SUBOPT_0xB2
; 0000 1418                   PORT_F.bits.b2 = 0;
	ANDI R30,0xFB
	CALL SUBOPT_0xB2
; 0000 1419                   PORT_F.bits.b3 = 0;
	ANDI R30,0XF7
	CALL SUBOPT_0xB2
; 0000 141A                   PORT_F.bits.b7 = 0;
	ANDI R30,0x7F
	CALL SUBOPT_0xAF
; 0000 141B                   PORTF = PORT_F.byte;
; 0000 141C                   PORTB.7 = 0;
	CBI  0x18,7
; 0000 141D 
; 0000 141E                   sek2 = 0;
	CALL SUBOPT_0xB0
; 0000 141F                   cykl_sterownik_3 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xB1
; 0000 1420                   }
; 0000 1421 
; 0000 1422         break;
_0x268:
	RJMP _0x261
; 0000 1423 
; 0000 1424         case 3:
_0x267:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x26B
; 0000 1425 
; 0000 1426 
; 0000 1427                if(sprawdz_pin3(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0x99
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x26C
; 0000 1428                   {
; 0000 1429                   sek2 = 0;
	CALL SUBOPT_0xB0
; 0000 142A                   cykl_sterownik_3 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xB1
; 0000 142B                   }
; 0000 142C 
; 0000 142D 
; 0000 142E         break;
_0x26C:
	RJMP _0x261
; 0000 142F 
; 0000 1430 
; 0000 1431         case 4:
_0x26B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x261
; 0000 1432 
; 0000 1433               if(sprawdz_pin0(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0x99
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x26E
; 0000 1434                 {
; 0000 1435                 cykl_sterownik_3 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0xB1
; 0000 1436 
; 0000 1437 
; 0000 1438                 switch(cykl_sterownik_3_wykonalem)
	LDS  R30,_cykl_sterownik_3_wykonalem
	LDS  R31,_cykl_sterownik_3_wykonalem+1
; 0000 1439                     {
; 0000 143A                     case 0:
	SBIW R30,0
	BRNE _0x272
; 0000 143B                             cykl_sterownik_3_wykonalem = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R31
; 0000 143C                     break;
	RJMP _0x271
; 0000 143D 
; 0000 143E                     case 1:
_0x272:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x271
; 0000 143F                             cykl_sterownik_3_wykonalem = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R30
; 0000 1440                     break;
; 0000 1441 
; 0000 1442                     }
_0x271:
; 0000 1443 
; 0000 1444 
; 0000 1445                 }
; 0000 1446         break;
_0x26E:
; 0000 1447 
; 0000 1448         }
_0x261:
; 0000 1449 
; 0000 144A return cykl_sterownik_3;
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
_0x20A0001:
	ADIW R28,2
	RET
; 0000 144B }
;
;//
;//int sterownik_4_praca(char f,char e,char d, char c, char b, char a)
;int sterownik_4_praca(int PORT,int p)
; 0000 1450 {
_sterownik_4_praca:
; 0000 1451 
; 0000 1452 
; 0000 1453 //PORTB.0   IN0  STEROWNIK4
; 0000 1454 //PORTB.1   IN1  STEROWNIK4
; 0000 1455 //PORTB.2   IN2  STEROWNIK4
; 0000 1456 //PORTB.3   IN3  STEROWNIK4
; 0000 1457 //PORTE.4  IN4  STEROWNIK4
; 0000 1458 
; 0000 1459 
; 0000 145A 
; 0000 145B //PORTB.4   SETUP  STEROWNIK4
; 0000 145C //PORTB.5   DRIVE  STEROWNIK4
; 0000 145D 
; 0000 145E //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 145F //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 1460 
; 0000 1461 if(sprawdz_pin6(PORTMM,0x77) == 1)
;	PORT -> Y+2
;	p -> Y+0
	CALL SUBOPT_0x1A
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x274
; 0000 1462     {
; 0000 1463     PORTD.7 = 1;
	SBI  0x12,7
; 0000 1464     PORTE.2 = 0;
	CBI  0x3,2
; 0000 1465     PORTE.3 = 0;
	CBI  0x3,3
; 0000 1466     }
; 0000 1467 if(start == 1)
_0x274:
	CALL SUBOPT_0xA7
	BRNE _0x27B
; 0000 1468     {
; 0000 1469     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xA8
; 0000 146A     obsluga_nacisniecia_zatrzymaj();
; 0000 146B     }
; 0000 146C switch(cykl_sterownik_4)
_0x27B:
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
; 0000 146D         {
; 0000 146E         case 0:
	SBIW R30,0
	BRNE _0x27F
; 0000 146F 
; 0000 1470             PORT_STER4.byte = PORT;
	LDD  R30,Y+2
	STS  _PORT_STER4,R30
; 0000 1471             PORTB.0 = PORT_STER4.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x280
	CBI  0x18,0
	RJMP _0x281
_0x280:
	SBI  0x18,0
_0x281:
; 0000 1472             PORTB.1 = PORT_STER4.bits.b1;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x2)
	BRNE _0x282
	CBI  0x18,1
	RJMP _0x283
_0x282:
	SBI  0x18,1
_0x283:
; 0000 1473             PORTB.2 = PORT_STER4.bits.b2;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x4)
	BRNE _0x284
	CBI  0x18,2
	RJMP _0x285
_0x284:
	SBI  0x18,2
_0x285:
; 0000 1474             PORTB.3 = PORT_STER4.bits.b3;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x8)
	BRNE _0x286
	CBI  0x18,3
	RJMP _0x287
_0x286:
	SBI  0x18,3
_0x287:
; 0000 1475             PORTE.4 = PORT_STER4.bits.b4;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x10)
	BRNE _0x288
	CBI  0x3,4
	RJMP _0x289
_0x288:
	SBI  0x3,4
_0x289:
; 0000 1476 
; 0000 1477 
; 0000 1478             sek4 = 0;
	CALL SUBOPT_0xB3
; 0000 1479             cykl_sterownik_4 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x46B
; 0000 147A 
; 0000 147B         break;
; 0000 147C 
; 0000 147D         case 1:
_0x27F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x28A
; 0000 147E 
; 0000 147F             if(sek4 > 1)
	LDS  R26,_sek4
	LDS  R27,_sek4+1
	LDS  R24,_sek4+2
	LDS  R25,_sek4+3
	CALL SUBOPT_0xAA
	BRLT _0x28B
; 0000 1480                 {
; 0000 1481                 PORTB.5 = 1;
	SBI  0x18,5
; 0000 1482                 cykl_sterownik_4 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xB4
; 0000 1483                 }
; 0000 1484         break;
_0x28B:
	RJMP _0x27E
; 0000 1485 
; 0000 1486 
; 0000 1487         case 2:
_0x28A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x28E
; 0000 1488 
; 0000 1489                if(sprawdz_pin4(PORTKK,0x75) == 0)
	CALL SUBOPT_0x99
	CALL _sprawdz_pin4
	CPI  R30,0
	BRNE _0x28F
; 0000 148A                   {
; 0000 148B                   PORTB.5 = 0;  //drive
	CBI  0x18,5
; 0000 148C 
; 0000 148D                   PORTB.0 = 0;
	CBI  0x18,0
; 0000 148E                   PORTB.1 = 0;
	CBI  0x18,1
; 0000 148F                   PORTB.2 = 0;
	CBI  0x18,2
; 0000 1490                   PORTB.3 = 0;
	CBI  0x18,3
; 0000 1491                   PORTE.4 = 0;
	CBI  0x3,4
; 0000 1492 
; 0000 1493 
; 0000 1494                   sek4 = 0;
	CALL SUBOPT_0xB3
; 0000 1495                   cykl_sterownik_4 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xB4
; 0000 1496                   }
; 0000 1497 
; 0000 1498         break;
_0x28F:
	RJMP _0x27E
; 0000 1499 
; 0000 149A         case 3:
_0x28E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x29C
; 0000 149B 
; 0000 149C                if(sprawdz_pin7(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0x99
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x29D
; 0000 149D                   {
; 0000 149E                   //if(p == 1)
; 0000 149F                   //  PORTE.2 = 1;  //wylaczam do testu
; 0000 14A0 
; 0000 14A1                   sek4 = 0;
	CALL SUBOPT_0xB3
; 0000 14A2                   cykl_sterownik_4 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xB4
; 0000 14A3                   }
; 0000 14A4 
; 0000 14A5 
; 0000 14A6         break;
_0x29D:
	RJMP _0x27E
; 0000 14A7 
; 0000 14A8 
; 0000 14A9         case 4:
_0x29C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x27E
; 0000 14AA 
; 0000 14AB               if(sprawdz_pin4(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0x99
	CALL _sprawdz_pin4
	CPI  R30,LOW(0x1)
	BRNE _0x29F
; 0000 14AC                 {
; 0000 14AD                 cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x46B:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
; 0000 14AE                 }
; 0000 14AF         break;
_0x29F:
; 0000 14B0 
; 0000 14B1         }
_0x27E:
; 0000 14B2 
; 0000 14B3 return cykl_sterownik_4;
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
	ADIW R28,4
	RET
; 0000 14B4 }
;
;
;void test_geometryczny()
; 0000 14B8 {
_test_geometryczny:
; 0000 14B9 int cykl_testu,d;
; 0000 14BA int ff[12];
; 0000 14BB int i;
; 0000 14BC d = 0;
	SBIW R28,24
	CALL __SAVELOCR6
;	cykl_testu -> R16,R17
;	d -> R18,R19
;	ff -> Y+6
;	i -> R20,R21
	__GETWRN 18,19,0
; 0000 14BD cykl_testu = 0;
	__GETWRN 16,17,0
; 0000 14BE 
; 0000 14BF for(i=0;i<11;i++)
	__GETWRN 20,21,0
_0x2A1:
	__CPWRN 20,21,11
	BRGE _0x2A2
; 0000 14C0      ff[i]=0;
	MOVW R30,R20
	CALL SUBOPT_0xB5
	CALL SUBOPT_0x36
	__ADDWRN 20,21,1
	RJMP _0x2A1
_0x2A2:
; 0000 14C3 manualny_wybor_zacisku = 145;
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	STS  _manualny_wybor_zacisku,R30
	STS  _manualny_wybor_zacisku+1,R31
; 0000 14C4 manualny_wybor_zacisku = odczytaj_parametr(48,128);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1F
	STS  _manualny_wybor_zacisku,R30
	STS  _manualny_wybor_zacisku+1,R31
; 0000 14C5 
; 0000 14C6 if(manualny_wybor_zacisku != 145)
	LDS  R26,_manualny_wybor_zacisku
	LDS  R27,_manualny_wybor_zacisku+1
	CPI  R26,LOW(0x91)
	LDI  R30,HIGH(0x91)
	CPC  R27,R30
	BREQ _0x2A3
; 0000 14C7     {
; 0000 14C8     macierz_zaciskow[1] = manualny_wybor_zacisku;
	LDS  R30,_manualny_wybor_zacisku
	LDS  R31,_manualny_wybor_zacisku+1
	__PUTW1MN _macierz_zaciskow,2
; 0000 14C9     macierz_zaciskow[2] = manualny_wybor_zacisku;
	__PUTW1MN _macierz_zaciskow,4
; 0000 14CA     }
; 0000 14CB 
; 0000 14CC                                                                    //swiatlo czer       //swiatlo zolte
; 0000 14CD if(test_geometryczny_rzad_1 == 1 & test_geometryczny_rzad_2 == 0 & PORTD.7 == 0  & PORT_F.bits.b6 == 0 &
_0x2A3:
; 0000 14CE     il_zaciskow_rzad_1 > 1 & macierz_zaciskow[1]!=0 & sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0xB6
	CALL SUBOPT_0x74
	MOV  R0,R30
	CALL SUBOPT_0xB7
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xB8
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xBA
	PUSH R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	POP  R26
	AND  R30,R26
	PUSH R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x2A4
; 0000 14CF     {
; 0000 14D0     while(test_geometryczny_rzad_1 == 1)
_0x2A5:
	CALL SUBOPT_0xB6
	SBIW R26,1
	BREQ PC+3
	JMP _0x2A7
; 0000 14D1         {
; 0000 14D2         switch(cykl_testu)
	MOVW R30,R16
; 0000 14D3             {
; 0000 14D4              case 0:
	SBIW R30,0
	BRNE _0x2AB
; 0000 14D5 
; 0000 14D6                wybor_linijek_sterownikow(1);
	CALL SUBOPT_0xBB
; 0000 14D7                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	CALL SUBOPT_0xBC
; 0000 14D8                cykl_sterownik_1 = 0;
; 0000 14D9                cykl_sterownik_2 = 0;
; 0000 14DA                cykl_sterownik_3 = 0;
; 0000 14DB                cykl_sterownik_4 = 0;
; 0000 14DC                wybor_linijek_sterownikow(1);
	CALL SUBOPT_0xBB
; 0000 14DD                cykl_testu = 1;
	__GETWRN 16,17,1
; 0000 14DE 
; 0000 14DF 
; 0000 14E0 
; 0000 14E1             break;
	RJMP _0x2AA
; 0000 14E2 
; 0000 14E3             case 1:
_0x2AB:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2AE
; 0000 14E4 
; 0000 14E5             //na sam dol zjezdzamy pionami
; 0000 14E6                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x2AF
; 0000 14E7                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xBE
; 0000 14E8                 if(cykl_sterownik_4 < 5)
_0x2AF:
	CALL SUBOPT_0xBF
	SBIW R26,5
	BRGE _0x2B0
; 0000 14E9                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x7F
	CALL SUBOPT_0xC0
; 0000 14EA 
; 0000 14EB                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2B0:
	CALL SUBOPT_0xC1
	BREQ _0x2B1
; 0000 14EC                                         {
; 0000 14ED                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC2
; 0000 14EE                                         cykl_sterownik_4 = 0;
; 0000 14EF                                         cykl_testu = 2;
	__GETWRN 16,17,2
; 0000 14F0                                         }
; 0000 14F1 
; 0000 14F2 
; 0000 14F3 
; 0000 14F4             break;
_0x2B1:
	RJMP _0x2AA
; 0000 14F5 
; 0000 14F6 
; 0000 14F7             case 2:
_0x2AE:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2B2
; 0000 14F8 
; 0000 14F9                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x2B3
; 0000 14FA                                     cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xC4
; 0000 14FB                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy
_0x2B3:
	CALL SUBOPT_0xC5
	SBIW R26,5
	BRGE _0x2B4
; 0000 14FC                                     cykl_sterownik_2 = sterownik_2_praca(0x008);       //ster 2 ucieczka do zera (druciak)
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xC7
; 0000 14FD 
; 0000 14FE                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x2B4:
	CALL SUBOPT_0xC8
	BREQ _0x2B5
; 0000 14FF                                         {
; 0000 1500                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 1501                                         cykl_sterownik_2 = 0;
; 0000 1502                                         cykl_sterownik_3 = 0;
; 0000 1503                                         cykl_sterownik_4 = 0;
; 0000 1504                                         cykl_testu = 3;
	__GETWRN 16,17,3
; 0000 1505 
; 0000 1506                                         }
; 0000 1507 
; 0000 1508             break;
_0x2B5:
	RJMP _0x2AA
; 0000 1509 
; 0000 150A 
; 0000 150B             case 3:
_0x2B2:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2B6
; 0000 150C 
; 0000 150D                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x2B7
; 0000 150E                                     cykl_sterownik_1 = sterownik_1_praca(a[0]); //ster 1 pod srodek zacisku
	CALL SUBOPT_0xCA
	CALL SUBOPT_0xC4
; 0000 150F 
; 0000 1510                                     if(cykl_sterownik_1 == 5)
_0x2B7:
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRNE _0x2B8
; 0000 1511                                         {
; 0000 1512                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 1513                                         cykl_sterownik_2 = 0;
; 0000 1514                                         cykl_sterownik_3 = 0;
; 0000 1515                                         cykl_sterownik_4 = 0;
; 0000 1516                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 1517                                         }
; 0000 1518 
; 0000 1519             break;
_0x2B8:
	RJMP _0x2AA
; 0000 151A 
; 0000 151B             case 4:
_0x2B6:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2B9
; 0000 151C 
; 0000 151D                                    if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x2BA
; 0000 151E                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
	CALL SUBOPT_0x6F
	CALL SUBOPT_0xCB
; 0000 151F 
; 0000 1520                                    if(cykl_sterownik_3 == 5)
_0x2BA:
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRNE _0x2BB
; 0000 1521                                         {
; 0000 1522                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 1523                                         cykl_sterownik_2 = 0;
; 0000 1524                                         cykl_sterownik_3 = 0;
; 0000 1525                                         cykl_sterownik_4 = 0;
; 0000 1526                                         cykl_testu = 5;
	__GETWRN 16,17,5
; 0000 1527                                         }
; 0000 1528 
; 0000 1529             break;
_0x2BB:
	RJMP _0x2AA
; 0000 152A 
; 0000 152B             case 5:
_0x2B9:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2BC
; 0000 152C 
; 0000 152D                                      d = odczytaj_parametr(48,80);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x28
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 152E                                         if(d == 0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x2BD
; 0000 152F                                             cykl_testu = 666;
	__GETWRN 16,17,666
; 0000 1530 
; 0000 1531                                         if(d == 2 & ff[2] == 0)
_0x2BD:
	CALL SUBOPT_0xCC
	BREQ _0x2BE
; 0000 1532                                             {
; 0000 1533                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1534                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1535                                             }
; 0000 1536                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
_0x2BE:
	CALL SUBOPT_0xCE
	AND  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2BF
; 0000 1537                                             {
; 0000 1538                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1539                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 153A                                             }
; 0000 153B                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
_0x2BF:
	CALL SUBOPT_0xCF
	AND  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2C0
; 0000 153C                                             {
; 0000 153D                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 153E                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 153F                                             }
; 0000 1540                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
_0x2C0:
	CALL SUBOPT_0xD0
	AND  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2C1
; 0000 1541                                             {
; 0000 1542                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1543                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1544                                             }
; 0000 1545                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
_0x2C1:
	CALL SUBOPT_0xD1
	AND  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2C2
; 0000 1546                                             {
; 0000 1547                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1548                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1549                                             }
; 0000 154A                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
_0x2C2:
	CALL SUBOPT_0xD2
	AND  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2C3
; 0000 154B                                             {
; 0000 154C                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 154D                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 154E                                             }
; 0000 154F                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
_0x2C3:
	CALL SUBOPT_0xD3
	AND  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2C4
; 0000 1550                                             {
; 0000 1551                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1552                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1553                                             }
; 0000 1554                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
_0x2C4:
	CALL SUBOPT_0xD4
	AND  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2C5
; 0000 1555                                             {
; 0000 1556                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1557                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1558                                             }
; 0000 1559                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
_0x2C5:
	CALL SUBOPT_0xD5
	AND  R0,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2C6
; 0000 155A                                             {
; 0000 155B                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 155C                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 155D                                             }
; 0000 155E 
; 0000 155F 
; 0000 1560             break;
_0x2C6:
	RJMP _0x2AA
; 0000 1561 
; 0000 1562             case 6:
_0x2BC:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2C7
; 0000 1563                                      if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x2C8
; 0000 1564                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xBE
; 0000 1565                                         if(cykl_sterownik_3 == 5)
_0x2C8:
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRNE _0x2C9
; 0000 1566                                             {
; 0000 1567                                             cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 1568                                             cykl_sterownik_2 = 0;
; 0000 1569                                             cykl_sterownik_3 = 0;
; 0000 156A                                             cykl_sterownik_4 = 0;
; 0000 156B                                             cykl_testu = 7;
	__GETWRN 16,17,7
; 0000 156C                                             }
; 0000 156D 
; 0000 156E             break;
_0x2C9:
	RJMP _0x2AA
; 0000 156F 
; 0000 1570             case 7:
_0x2C7:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2CA
; 0000 1571 
; 0000 1572                                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x2CB
; 0000 1573                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
	CALL SUBOPT_0xD6
; 0000 1574 
; 0000 1575                                     if(cykl_sterownik_1 == 5)
_0x2CB:
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRNE _0x2CC
; 0000 1576                                         {
; 0000 1577                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 1578                                         cykl_sterownik_2 = 0;
; 0000 1579                                         cykl_sterownik_3 = 0;
; 0000 157A                                         cykl_sterownik_4 = 0;
; 0000 157B                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 157C                                         }
; 0000 157D 
; 0000 157E 
; 0000 157F             break;
_0x2CC:
	RJMP _0x2AA
; 0000 1580 
; 0000 1581 
; 0000 1582 
; 0000 1583 
; 0000 1584 
; 0000 1585 
; 0000 1586 
; 0000 1587             case 666:
_0x2CA:
	CPI  R30,LOW(0x29A)
	LDI  R26,HIGH(0x29A)
	CPC  R31,R26
	BRNE _0x2AA
; 0000 1588 
; 0000 1589                                         if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x2CE
; 0000 158A                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xBE
; 0000 158B                                         if(cykl_sterownik_3 == 5)
_0x2CE:
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRNE _0x2CF
; 0000 158C                                             {
; 0000 158D                                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC2
; 0000 158E                                             cykl_sterownik_4 = 0;
; 0000 158F                                             cykl_testu = 100;
	__GETWRN 16,17,100
; 0000 1590                                             test_geometryczny_rzad_1 = 0;
	LDI  R30,LOW(0)
	STS  _test_geometryczny_rzad_1,R30
	STS  _test_geometryczny_rzad_1+1,R30
; 0000 1591                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 1592                                             }
; 0000 1593 
; 0000 1594             break;
_0x2CF:
; 0000 1595 
; 0000 1596 
; 0000 1597 
; 0000 1598             }
_0x2AA:
; 0000 1599 
; 0000 159A         }
	RJMP _0x2A5
_0x2A7:
; 0000 159B     }
; 0000 159C 
; 0000 159D 
; 0000 159E 
; 0000 159F                                                                    //swiatlo czer       //swiatlo zolte
; 0000 15A0 if(test_geometryczny_rzad_1 == 0 & test_geometryczny_rzad_2 == 1 & PORTD.7 == 0  & PORT_F.bits.b6 == 0 &
_0x2A4:
; 0000 15A1     il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0)
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xA3
	MOV  R0,R30
	CALL SUBOPT_0xB7
	CALL SUBOPT_0x74
	CALL SUBOPT_0xB8
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xD8
	AND  R0,R30
	CALL SUBOPT_0xD9
	AND  R30,R0
	BRNE PC+3
	JMP _0x2D2
; 0000 15A2     {
; 0000 15A3     while(test_geometryczny_rzad_2 == 1)
_0x2D3:
	CALL SUBOPT_0xB7
	SBIW R26,1
	BREQ PC+3
	JMP _0x2D5
; 0000 15A4         {
; 0000 15A5         switch(cykl_testu)
	MOVW R30,R16
; 0000 15A6             {
; 0000 15A7              case 0:
	SBIW R30,0
	BRNE _0x2D9
; 0000 15A8 
; 0000 15A9                wybor_linijek_sterownikow(2);
	CALL SUBOPT_0xDA
; 0000 15AA                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	CALL SUBOPT_0xBC
; 0000 15AB                cykl_sterownik_1 = 0;
; 0000 15AC                cykl_sterownik_2 = 0;
; 0000 15AD                cykl_sterownik_3 = 0;
; 0000 15AE                cykl_sterownik_4 = 0;
; 0000 15AF                wybor_linijek_sterownikow(2);
	CALL SUBOPT_0xDA
; 0000 15B0                cykl_testu = 1;
	__GETWRN 16,17,1
; 0000 15B1 
; 0000 15B2 
; 0000 15B3 
; 0000 15B4             break;
	RJMP _0x2D8
; 0000 15B5 
; 0000 15B6             case 1:
_0x2D9:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2DC
; 0000 15B7 
; 0000 15B8             //na sam dol zjezdzamy pionami
; 0000 15B9                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x2DD
; 0000 15BA                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xBE
; 0000 15BB                 if(cykl_sterownik_4 < 5)
_0x2DD:
	CALL SUBOPT_0xBF
	SBIW R26,5
	BRGE _0x2DE
; 0000 15BC                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x7F
	CALL SUBOPT_0xC0
; 0000 15BD 
; 0000 15BE                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2DE:
	CALL SUBOPT_0xC1
	BREQ _0x2DF
; 0000 15BF                                         {
; 0000 15C0                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC2
; 0000 15C1                                         cykl_sterownik_4 = 0;
; 0000 15C2                                         cykl_testu = 2;
	__GETWRN 16,17,2
; 0000 15C3                                         }
; 0000 15C4 
; 0000 15C5 
; 0000 15C6 
; 0000 15C7             break;
_0x2DF:
	RJMP _0x2D8
; 0000 15C8 
; 0000 15C9 
; 0000 15CA             case 2:
_0x2DC:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2E0
; 0000 15CB 
; 0000 15CC                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x2E1
; 0000 15CD                                     cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xC4
; 0000 15CE                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy rzad 2
_0x2E1:
	CALL SUBOPT_0xC5
	SBIW R26,5
	BRGE _0x2E2
; 0000 15CF                                     cykl_sterownik_2 = sterownik_2_praca(0x009);       //ster 2 ucieczka dla II rzedu (druciak)
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xC7
; 0000 15D0 
; 0000 15D1                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x2E2:
	CALL SUBOPT_0xC8
	BREQ _0x2E3
; 0000 15D2                                         {
; 0000 15D3                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 15D4                                         cykl_sterownik_2 = 0;
; 0000 15D5                                         cykl_sterownik_3 = 0;
; 0000 15D6                                         cykl_sterownik_4 = 0;
; 0000 15D7                                         cykl_testu = 3;
	__GETWRN 16,17,3
; 0000 15D8 
; 0000 15D9                                         }
; 0000 15DA 
; 0000 15DB             break;
_0x2E3:
	RJMP _0x2D8
; 0000 15DC 
; 0000 15DD 
; 0000 15DE             case 3:
_0x2E0:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2E4
; 0000 15DF 
; 0000 15E0                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x2E5
; 0000 15E1                                     cykl_sterownik_1 = sterownik_1_praca(a[1]); //ster 1 pod srodek zacisku
	CALL SUBOPT_0xDD
	CALL SUBOPT_0xC4
; 0000 15E2 
; 0000 15E3                                     if(cykl_sterownik_1 == 5)
_0x2E5:
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRNE _0x2E6
; 0000 15E4                                         {
; 0000 15E5                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 15E6                                         cykl_sterownik_2 = 0;
; 0000 15E7                                         cykl_sterownik_3 = 0;
; 0000 15E8                                         cykl_sterownik_4 = 0;
; 0000 15E9                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 15EA                                         }
; 0000 15EB 
; 0000 15EC             break;
_0x2E6:
	RJMP _0x2D8
; 0000 15ED 
; 0000 15EE             case 4:
_0x2E4:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2E7
; 0000 15EF 
; 0000 15F0                                    if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x2E8
; 0000 15F1                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
	CALL SUBOPT_0x6F
	CALL SUBOPT_0xCB
; 0000 15F2 
; 0000 15F3                                    if(cykl_sterownik_3 == 5)
_0x2E8:
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRNE _0x2E9
; 0000 15F4                                         {
; 0000 15F5                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 15F6                                         cykl_sterownik_2 = 0;
; 0000 15F7                                         cykl_sterownik_3 = 0;
; 0000 15F8                                         cykl_sterownik_4 = 0;
; 0000 15F9                                         cykl_testu = 5;
	__GETWRN 16,17,5
; 0000 15FA                                         }
; 0000 15FB 
; 0000 15FC             break;
_0x2E9:
	RJMP _0x2D8
; 0000 15FD 
; 0000 15FE             case 5:
_0x2E7:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2EA
; 0000 15FF 
; 0000 1600                                      d = odczytaj_parametr(48,96);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x29
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 1601                                         if(d == 0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x2EB
; 0000 1602                                             cykl_testu = 666;
	__GETWRN 16,17,666
; 0000 1603 
; 0000 1604 
; 0000 1605 
; 0000 1606 
; 0000 1607                                         if(d == 2 & ff[2] == 0)
_0x2EB:
	CALL SUBOPT_0xCC
	BREQ _0x2EC
; 0000 1608                                             {
; 0000 1609                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 160A                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 160B                                             }
; 0000 160C                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
_0x2EC:
	CALL SUBOPT_0xCE
	AND  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2ED
; 0000 160D                                             {
; 0000 160E                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 160F                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1610                                             }
; 0000 1611                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
_0x2ED:
	CALL SUBOPT_0xCF
	AND  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2EE
; 0000 1612                                             {
; 0000 1613                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1614                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1615                                             }
; 0000 1616                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
_0x2EE:
	CALL SUBOPT_0xD0
	AND  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2EF
; 0000 1617                                             {
; 0000 1618                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1619                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 161A                                             }
; 0000 161B                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
_0x2EF:
	CALL SUBOPT_0xD1
	AND  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2F0
; 0000 161C                                             {
; 0000 161D                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 161E                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 161F                                             }
; 0000 1620                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
_0x2F0:
	CALL SUBOPT_0xD2
	AND  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2F1
; 0000 1621                                             {
; 0000 1622                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1623                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1624                                             }
; 0000 1625                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
_0x2F1:
	CALL SUBOPT_0xD3
	AND  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2F2
; 0000 1626                                             {
; 0000 1627                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1628                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1629                                             }
; 0000 162A                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
_0x2F2:
	CALL SUBOPT_0xD4
	AND  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2F3
; 0000 162B                                             {
; 0000 162C                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 162D                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 162E                                             }
; 0000 162F                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
_0x2F3:
	CALL SUBOPT_0xD5
	AND  R0,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x2F4
; 0000 1630                                             {
; 0000 1631                                             cykl_testu = 6;
	CALL SUBOPT_0xCD
; 0000 1632                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1633                                             }
; 0000 1634 
; 0000 1635 
; 0000 1636             break;
_0x2F4:
	RJMP _0x2D8
; 0000 1637 
; 0000 1638             case 6:
_0x2EA:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2F5
; 0000 1639                                      if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x2F6
; 0000 163A                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xBE
; 0000 163B                                         if(cykl_sterownik_3 == 5)
_0x2F6:
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRNE _0x2F7
; 0000 163C                                             {
; 0000 163D                                             cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 163E                                             cykl_sterownik_2 = 0;
; 0000 163F                                             cykl_sterownik_3 = 0;
; 0000 1640                                             cykl_sterownik_4 = 0;
; 0000 1641                                             cykl_testu = 7;
	__GETWRN 16,17,7
; 0000 1642                                             }
; 0000 1643 
; 0000 1644             break;
_0x2F7:
	RJMP _0x2D8
; 0000 1645 
; 0000 1646             case 7:
_0x2F5:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2F8
; 0000 1647 
; 0000 1648                                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x2F9
; 0000 1649                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
	CALL SUBOPT_0xD6
; 0000 164A 
; 0000 164B                                     if(cykl_sterownik_1 == 5)
_0x2F9:
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRNE _0x2FA
; 0000 164C                                         {
; 0000 164D                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 164E                                         cykl_sterownik_2 = 0;
; 0000 164F                                         cykl_sterownik_3 = 0;
; 0000 1650                                         cykl_sterownik_4 = 0;
; 0000 1651                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 1652                                         }
; 0000 1653 
; 0000 1654 
; 0000 1655             break;
_0x2FA:
	RJMP _0x2D8
; 0000 1656 
; 0000 1657 
; 0000 1658 
; 0000 1659             case 666:
_0x2F8:
	CPI  R30,LOW(0x29A)
	LDI  R26,HIGH(0x29A)
	CPC  R31,R26
	BRNE _0x2D8
; 0000 165A 
; 0000 165B                                         if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x2FC
; 0000 165C                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xBE
; 0000 165D                                         if(cykl_sterownik_3 == 5)
_0x2FC:
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRNE _0x2FD
; 0000 165E                                             {
; 0000 165F                                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC2
; 0000 1660                                             cykl_sterownik_4 = 0;
; 0000 1661                                             cykl_testu = 100;
	__GETWRN 16,17,100
; 0000 1662                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 1663                                             test_geometryczny_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _test_geometryczny_rzad_2,R30
	STS  _test_geometryczny_rzad_2+1,R30
; 0000 1664                                             }
; 0000 1665 
; 0000 1666             break;
_0x2FD:
; 0000 1667 
; 0000 1668 
; 0000 1669 
; 0000 166A             }
_0x2D8:
; 0000 166B 
; 0000 166C         }
	RJMP _0x2D3
_0x2D5:
; 0000 166D     }
; 0000 166E 
; 0000 166F 
; 0000 1670 
; 0000 1671 
; 0000 1672 
; 0000 1673 }
_0x2D2:
	CALL __LOADLOCR6
	ADIW R28,30
	RET
;
;
;
;
;
;void kontrola_zoltego_swiatla()
; 0000 167A {
_kontrola_zoltego_swiatla:
; 0000 167B 
; 0000 167C 
; 0000 167D if(czas_pracy_szczotki_drucianej_h >= czas_pracy_szczotki_drucianej_stala)
	CALL SUBOPT_0x9
	MOVW R0,R30
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL __EEPROMRDW
	CP   R0,R30
	CPC  R1,R31
	BRLT _0x300
; 0000 167E      {
; 0000 167F      PORT_F.bits.b6 = 1;
	LDS  R30,_PORT_F
	ORI  R30,0x40
	CALL SUBOPT_0xAF
; 0000 1680      PORTF = PORT_F.byte;
; 0000 1681      komunikat_na_panel("                                                ",80,0);
	CALL SUBOPT_0xDE
	CALL SUBOPT_0xDF
	CALL _komunikat_na_panel
; 0000 1682      komunikat_na_panel("Wymien szczotke pedzelkowa",80,0);
	__POINTW1FN _0x0,1846
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xDF
	CALL _komunikat_na_panel
; 0000 1683      }
; 0000 1684 
; 0000 1685 if(czas_pracy_krazka_sciernego_h >= czas_pracy_krazka_sciernego_stala)
_0x300:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_stala)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_stala)
	CALL __EEPROMRDW
	CP   R0,R30
	CPC  R1,R31
	BRLT _0x301
; 0000 1686      {
; 0000 1687      PORT_F.bits.b6 = 1;
	LDS  R30,_PORT_F
	ORI  R30,0x40
	CALL SUBOPT_0xAF
; 0000 1688      PORTF = PORT_F.byte;
; 0000 1689      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xDE
	CALL SUBOPT_0xE0
	CALL _komunikat_na_panel
; 0000 168A      komunikat_na_panel("Wymien krazek scierny",64,0);
	__POINTW1FN _0x0,1873
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xE0
	CALL _komunikat_na_panel
; 0000 168B      }
; 0000 168C 
; 0000 168D 
; 0000 168E }
_0x301:
	RET
;
;void wymiana_szczotki_i_krazka()
; 0000 1691 {
_wymiana_szczotki_i_krazka:
; 0000 1692 int g,e,f,d,cykl_wymiany;
; 0000 1693 cykl_wymiany = 0;
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
; 0000 1694                       //30 //20
; 0000 1695 
; 0000 1696 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	PUSH R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	POP  R26
	AND  R30,R26
	BREQ _0x302
; 0000 1697 {
; 0000 1698 g = odczytaj_parametr(48,32);  //szczotka druciana
	CALL SUBOPT_0x21
	CALL SUBOPT_0x31
	CALL _odczytaj_parametr
	MOVW R16,R30
; 0000 1699                     //30  //30
; 0000 169A f = odczytaj_parametr(48,48);  //krazek scierny
	CALL SUBOPT_0x21
	CALL SUBOPT_0x21
	CALL _odczytaj_parametr
	MOVW R20,R30
; 0000 169B }
; 0000 169C 
; 0000 169D while(g == 1)
_0x302:
_0x303:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+3
	JMP _0x305
; 0000 169E     {
; 0000 169F     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 16A0     {
; 0000 16A1     case 0:
	SBIW R30,0
	BRNE _0x309
; 0000 16A2 
; 0000 16A3                cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 16A4                cykl_sterownik_2 = 0;
; 0000 16A5                cykl_sterownik_3 = 0;
; 0000 16A6                cykl_sterownik_4 = 0;
; 0000 16A7                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 16A8                cykl_wymiany = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 16A9 
; 0000 16AA 
; 0000 16AB 
; 0000 16AC     break;
	RJMP _0x308
; 0000 16AD 
; 0000 16AE     case 1:
_0x309:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x30C
; 0000 16AF 
; 0000 16B0             //na sam dol zjezdzamy pionami
; 0000 16B1                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x30D
; 0000 16B2                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xBE
; 0000 16B3                 if(cykl_sterownik_4 < 5)
_0x30D:
	CALL SUBOPT_0xBF
	SBIW R26,5
	BRGE _0x30E
; 0000 16B4                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x7F
	CALL SUBOPT_0xC0
; 0000 16B5 
; 0000 16B6                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x30E:
	CALL SUBOPT_0xC1
	BREQ _0x30F
; 0000 16B7 
; 0000 16B8                             {
; 0000 16B9                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC2
; 0000 16BA                                         cykl_sterownik_4 = 0;
; 0000 16BB                                         cykl_wymiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 16BC                                         }
; 0000 16BD 
; 0000 16BE 
; 0000 16BF 
; 0000 16C0     break;
_0x30F:
	RJMP _0x308
; 0000 16C1 
; 0000 16C2 
; 0000 16C3 
; 0000 16C4     case 2:
_0x30C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x310
; 0000 16C5 
; 0000 16C6                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x311
; 0000 16C7                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xC4
; 0000 16C8                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x311:
	CALL SUBOPT_0xC5
	SBIW R26,5
	BRGE _0x312
; 0000 16C9                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xC7
; 0000 16CA 
; 0000 16CB                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x312:
	CALL SUBOPT_0xC8
	BREQ _0x313
; 0000 16CC                                         {
; 0000 16CD                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 16CE                                         cykl_sterownik_2 = 0;
; 0000 16CF                                         cykl_sterownik_3 = 0;
; 0000 16D0                                         cykl_sterownik_4 = 0;
; 0000 16D1                                          cykl_wymiany = 3;
	CALL SUBOPT_0xE2
; 0000 16D2 
; 0000 16D3                                         }
; 0000 16D4 
; 0000 16D5     break;
_0x313:
	RJMP _0x308
; 0000 16D6 
; 0000 16D7 
; 0000 16D8 
; 0000 16D9     case 3:
_0x310:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x314
; 0000 16DA 
; 0000 16DB             //na sam dol zjezdzamy pionami
; 0000 16DC                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x315
; 0000 16DD                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xCB
; 0000 16DE                 if(cykl_sterownik_4 < 5)
_0x315:
	CALL SUBOPT_0xBF
	SBIW R26,5
	BRGE _0x316
; 0000 16DF                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC0
; 0000 16E0 
; 0000 16E1                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x316:
	CALL SUBOPT_0xC1
	BRNE PC+3
	JMP _0x317
; 0000 16E2 
; 0000 16E3                             {
; 0000 16E4                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC2
; 0000 16E5                                         cykl_sterownik_4 = 0;
; 0000 16E6                                         d = odczytaj_parametr(48,32);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x31
	CALL _odczytaj_parametr
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 16E7 
; 0000 16E8                                         switch (d)
; 0000 16E9                                         {
; 0000 16EA                                         case 0:
	SBIW R30,0
	BRNE _0x31B
; 0000 16EB 
; 0000 16EC                                              PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 16ED                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	PUSH R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	POP  R26
	AND  R30,R26
	BREQ _0x31E
; 0000 16EE                                                 cykl_wymiany = 4;
	CALL SUBOPT_0xE3
; 0000 16EF                                              //jednak nie wymianiamy
; 0000 16F0 
; 0000 16F1                                         break;
_0x31E:
	RJMP _0x31A
; 0000 16F2 
; 0000 16F3                                         case 1:
_0x31B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x31F
; 0000 16F4                                              cykl_wymiany = 3;
	CALL SUBOPT_0xE2
; 0000 16F5                                              PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 16F6                                              //czekam z decyzja - w trakcie wymiany
; 0000 16F7                                         break;
	RJMP _0x31A
; 0000 16F8 
; 0000 16F9                                         case 2:
_0x31F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x31A
; 0000 16FA 
; 0000 16FB                                              PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 16FC                                              wymieniono_szczotke_druciana = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wymieniono_szczotke_druciana,R30
	STS  _wymieniono_szczotke_druciana+1,R31
; 0000 16FD                                              PORT_F.bits.b6 = 0;   //zgas lampke
	LDS  R30,_PORT_F
	ANDI R30,0xBF
	CALL SUBOPT_0xAF
; 0000 16FE                                              PORTF = PORT_F.byte;
; 0000 16FF                                              czas_pracy_szczotki_drucianej = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_szczotki_drucianej,R30
	STS  _czas_pracy_szczotki_drucianej+1,R30
; 0000 1700                                              czas_pracy_szczotki_drucianej_h = 0;
	CALL SUBOPT_0x17
; 0000 1701                                              zaktualizuj_parametry_panelu();
	CALL _zaktualizuj_parametry_panelu
; 0000 1702                                              komunikat_na_panel("                                                ",80,0);
	CALL SUBOPT_0xDE
	CALL SUBOPT_0xDF
	CALL _komunikat_na_panel
; 0000 1703 
; 0000 1704                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	PUSH R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	POP  R26
	AND  R30,R26
	BREQ _0x325
; 0000 1705                                                 cykl_wymiany = 4;
	CALL SUBOPT_0xE3
; 0000 1706                                              //wymianymy
; 0000 1707                                         break;
_0x325:
; 0000 1708                                         }
_0x31A:
; 0000 1709                             }
; 0000 170A 
; 0000 170B 
; 0000 170C 
; 0000 170D 
; 0000 170E 
; 0000 170F 
; 0000 1710     break;
_0x317:
	RJMP _0x308
; 0000 1711 
; 0000 1712    case 4:
_0x314:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x308
; 0000 1713 
; 0000 1714                       //na sam dol zjezdzamy pionami
; 0000 1715                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x327
; 0000 1716                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xBE
; 0000 1717                 if(cykl_sterownik_4 < 5)
_0x327:
	CALL SUBOPT_0xBF
	SBIW R26,5
	BRGE _0x328
; 0000 1718                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x7F
	CALL SUBOPT_0xC0
; 0000 1719 
; 0000 171A                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x328:
	CALL SUBOPT_0xC1
	BREQ _0x329
; 0000 171B 
; 0000 171C                             {
; 0000 171D                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 171E                                         cykl_sterownik_2 = 0;
; 0000 171F                                         cykl_sterownik_3 = 0;
; 0000 1720                                         cykl_sterownik_4 = 0;
; 0000 1721                                         wartosc_parametru_panelu(0,48,32);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x21
	CALL SUBOPT_0x31
	CALL _wartosc_parametru_panelu
; 0000 1722                                         PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 1723                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1724                                         g = 0;
	__GETWRN 16,17,0
; 0000 1725                                         }
; 0000 1726 
; 0000 1727    break;
_0x329:
; 0000 1728 
; 0000 1729 
; 0000 172A     }//switch
_0x308:
; 0000 172B 
; 0000 172C    }//while
	RJMP _0x303
_0x305:
; 0000 172D 
; 0000 172E f = odczytaj_parametr(48,48);  //krazek scierny
	CALL SUBOPT_0x21
	CALL SUBOPT_0x21
	CALL _odczytaj_parametr
	MOVW R20,R30
; 0000 172F cykl_wymiany = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 1730 
; 0000 1731 while(f == 1)
_0x32C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ PC+3
	JMP _0x32E
; 0000 1732     {
; 0000 1733     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 1734     {
; 0000 1735     case 0:
	SBIW R30,0
	BRNE _0x332
; 0000 1736 
; 0000 1737                cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 1738                cykl_sterownik_2 = 0;
; 0000 1739                cykl_sterownik_3 = 0;
; 0000 173A                cykl_sterownik_4 = 0;
; 0000 173B                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 173C                cykl_wymiany = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 173D 
; 0000 173E 
; 0000 173F 
; 0000 1740     break;
	RJMP _0x331
; 0000 1741 
; 0000 1742     case 1:
_0x332:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x335
; 0000 1743 
; 0000 1744             //na sam dol zjezdzamy pionami
; 0000 1745                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x336
; 0000 1746                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xBE
; 0000 1747                 if(cykl_sterownik_4 < 5)
_0x336:
	CALL SUBOPT_0xBF
	SBIW R26,5
	BRGE _0x337
; 0000 1748                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x7F
	CALL SUBOPT_0xC0
; 0000 1749 
; 0000 174A                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x337:
	CALL SUBOPT_0xC1
	BREQ _0x338
; 0000 174B 
; 0000 174C                             {
; 0000 174D                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC2
; 0000 174E                                         cykl_sterownik_4 = 0;
; 0000 174F                                         cykl_wymiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1750                                         }
; 0000 1751 
; 0000 1752 
; 0000 1753 
; 0000 1754     break;
_0x338:
	RJMP _0x331
; 0000 1755 
; 0000 1756 
; 0000 1757 
; 0000 1758     case 2:
_0x335:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x339
; 0000 1759 
; 0000 175A                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x33A
; 0000 175B                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xC4
; 0000 175C                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x33A:
	CALL SUBOPT_0xC5
	SBIW R26,5
	BRGE _0x33B
; 0000 175D                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xC7
; 0000 175E 
; 0000 175F                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x33B:
	CALL SUBOPT_0xC8
	BREQ _0x33C
; 0000 1760                                         {
; 0000 1761                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 1762                                         cykl_sterownik_2 = 0;
; 0000 1763                                         cykl_sterownik_3 = 0;
; 0000 1764                                         cykl_sterownik_4 = 0;
; 0000 1765                                          cykl_wymiany = 3;
	CALL SUBOPT_0xE2
; 0000 1766 
; 0000 1767                                         }
; 0000 1768 
; 0000 1769     break;
_0x33C:
	RJMP _0x331
; 0000 176A 
; 0000 176B 
; 0000 176C 
; 0000 176D     case 3:
_0x339:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x33D
; 0000 176E 
; 0000 176F             //na sam dol zjezdzamy pionami
; 0000 1770                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x33E
; 0000 1771                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xCB
; 0000 1772                 if(cykl_sterownik_4 < 5)
_0x33E:
	CALL SUBOPT_0xBF
	SBIW R26,5
	BRGE _0x33F
; 0000 1773                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC0
; 0000 1774 
; 0000 1775                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x33F:
	CALL SUBOPT_0xC1
	BREQ _0x340
; 0000 1776 
; 0000 1777                             {
; 0000 1778                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC2
; 0000 1779                                         cykl_sterownik_4 = 0;
; 0000 177A                                         e = odczytaj_parametr(48,48);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x21
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 177B 
; 0000 177C                                         switch (e)
	MOVW R30,R18
; 0000 177D                                         {
; 0000 177E                                         case 0:
	SBIW R30,0
	BRNE _0x344
; 0000 177F 
; 0000 1780                                              cykl_wymiany = 4;
	CALL SUBOPT_0xE3
; 0000 1781                                              PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 1782                                              //jednak nie wymianiamy
; 0000 1783 
; 0000 1784                                         break;
	RJMP _0x343
; 0000 1785 
; 0000 1786                                         case 1:
_0x344:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x347
; 0000 1787                                              PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 1788                                              cykl_wymiany = 3;
	CALL SUBOPT_0xE2
; 0000 1789                                              //czekam z decyzja - w trakcie wymiany
; 0000 178A                                         break;
	RJMP _0x343
; 0000 178B 
; 0000 178C                                         case 2:
_0x347:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x343
; 0000 178D                                              cykl_wymiany = 4;
	CALL SUBOPT_0xE3
; 0000 178E                                              wymieniono_krazek_scierny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wymieniono_krazek_scierny,R30
	STS  _wymieniono_krazek_scierny+1,R31
; 0000 178F                                              PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 1790                                              PORT_F.bits.b6 = 0;   //zgas lampke
	LDS  R30,_PORT_F
	ANDI R30,0xBF
	CALL SUBOPT_0xAF
; 0000 1791                                              PORTF = PORT_F.byte;
; 0000 1792                                              czas_pracy_krazka_sciernego = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego,R30
	STS  _czas_pracy_krazka_sciernego+1,R30
; 0000 1793                                              czas_pracy_krazka_sciernego_h = 0;
	CALL SUBOPT_0x18
; 0000 1794                                              zaktualizuj_parametry_panelu();
	CALL _zaktualizuj_parametry_panelu
; 0000 1795                                              komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xDE
	CALL SUBOPT_0xE0
	CALL _komunikat_na_panel
; 0000 1796                                              //wymianymy
; 0000 1797                                         break;
; 0000 1798                                         }
_0x343:
; 0000 1799                             }
; 0000 179A 
; 0000 179B 
; 0000 179C 
; 0000 179D 
; 0000 179E 
; 0000 179F 
; 0000 17A0     break;
_0x340:
	RJMP _0x331
; 0000 17A1 
; 0000 17A2    case 4:
_0x33D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x331
; 0000 17A3 
; 0000 17A4                       //na sam dol zjezdzamy pionami
; 0000 17A5                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x34E
; 0000 17A6                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xBE
; 0000 17A7                 if(cykl_sterownik_4 < 5)
_0x34E:
	CALL SUBOPT_0xBF
	SBIW R26,5
	BRGE _0x34F
; 0000 17A8                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x7F
	CALL SUBOPT_0xC0
; 0000 17A9 
; 0000 17AA                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x34F:
	CALL SUBOPT_0xC1
	BREQ _0x350
; 0000 17AB 
; 0000 17AC                             {
; 0000 17AD                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 17AE                                         cykl_sterownik_2 = 0;
; 0000 17AF                                         cykl_sterownik_3 = 0;
; 0000 17B0                                         cykl_sterownik_4 = 0;
; 0000 17B1                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 17B2                                         wartosc_parametru_panelu(0,48,48);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x21
	CALL SUBOPT_0x21
	CALL _wartosc_parametru_panelu
; 0000 17B3                                         PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 17B4                                         f = 0;
	__GETWRN 20,21,0
; 0000 17B5                                         }
; 0000 17B6 
; 0000 17B7    break;
_0x350:
; 0000 17B8 
; 0000 17B9 
; 0000 17BA     }//switch
_0x331:
; 0000 17BB 
; 0000 17BC    }//while
	RJMP _0x32C
_0x32E:
; 0000 17BD 
; 0000 17BE 
; 0000 17BF 
; 0000 17C0 
; 0000 17C1 
; 0000 17C2 
; 0000 17C3 
; 0000 17C4 }
	CALL __LOADLOCR6
	ADIW R28,10
	RET
;
;
;
;
;
;void main(void)
; 0000 17CB {
_main:
; 0000 17CC 
; 0000 17CD // Input/Output Ports initialization
; 0000 17CE // Port A initialization
; 0000 17CF // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 17D0 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 17D1 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 17D2 DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 17D3 
; 0000 17D4 // Port B initialization
; 0000 17D5 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 17D6 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 17D7 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 17D8 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 17D9 
; 0000 17DA // Port C initialization
; 0000 17DB // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 17DC // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 17DD PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 17DE DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 17DF 
; 0000 17E0 // Port D initialization
; 0000 17E1 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 17E2 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 17E3 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 17E4 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 17E5 
; 0000 17E6 // Port E initialization
; 0000 17E7 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 17E8 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 17E9 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 17EA DDRE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 17EB 
; 0000 17EC // Port F initialization
; 0000 17ED // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 17EE // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 17EF PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 17F0 DDRF=0xFF;
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 17F1 
; 0000 17F2 // Port G initialization
; 0000 17F3 // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 17F4 // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 17F5 PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 17F6 DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 17F7 
; 0000 17F8 
; 0000 17F9 
; 0000 17FA 
; 0000 17FB 
; 0000 17FC // Timer/Counter 0 initialization
; 0000 17FD // Clock source: System Clock
; 0000 17FE // Clock value: 15,625 kHz
; 0000 17FF // Mode: Normal top=0xFF
; 0000 1800 // OC0 output: Disconnected
; 0000 1801 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 1802 TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 1803 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 1804 OCR0=0x00;
	OUT  0x31,R30
; 0000 1805 
; 0000 1806 // Timer/Counter 1 initialization
; 0000 1807 // Clock source: System Clock
; 0000 1808 // Clock value: Timer1 Stopped
; 0000 1809 // Mode: Normal top=0xFFFF
; 0000 180A // OC1A output: Discon.
; 0000 180B // OC1B output: Discon.
; 0000 180C // OC1C output: Discon.
; 0000 180D // Noise Canceler: Off
; 0000 180E // Input Capture on Falling Edge
; 0000 180F // Timer1 Overflow Interrupt: Off
; 0000 1810 // Input Capture Interrupt: Off
; 0000 1811 // Compare A Match Interrupt: Off
; 0000 1812 // Compare B Match Interrupt: Off
; 0000 1813 // Compare C Match Interrupt: Off
; 0000 1814 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 1815 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 1816 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 1817 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 1818 ICR1H=0x00;
	OUT  0x27,R30
; 0000 1819 ICR1L=0x00;
	OUT  0x26,R30
; 0000 181A OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 181B OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 181C OCR1BH=0x00;
	OUT  0x29,R30
; 0000 181D OCR1BL=0x00;
	OUT  0x28,R30
; 0000 181E OCR1CH=0x00;
	STS  121,R30
; 0000 181F OCR1CL=0x00;
	STS  120,R30
; 0000 1820 
; 0000 1821 // Timer/Counter 2 initialization
; 0000 1822 // Clock source: System Clock
; 0000 1823 // Clock value: Timer2 Stopped
; 0000 1824 // Mode: Normal top=0xFF
; 0000 1825 // OC2 output: Disconnected
; 0000 1826 TCCR2=0x00;
	OUT  0x25,R30
; 0000 1827 TCNT2=0x00;
	OUT  0x24,R30
; 0000 1828 OCR2=0x00;
	OUT  0x23,R30
; 0000 1829 
; 0000 182A // Timer/Counter 3 initialization
; 0000 182B // Clock source: System Clock
; 0000 182C // Clock value: Timer3 Stopped
; 0000 182D // Mode: Normal top=0xFFFF
; 0000 182E // OC3A output: Discon.
; 0000 182F // OC3B output: Discon.
; 0000 1830 // OC3C output: Discon.
; 0000 1831 // Noise Canceler: Off
; 0000 1832 // Input Capture on Falling Edge
; 0000 1833 // Timer3 Overflow Interrupt: Off
; 0000 1834 // Input Capture Interrupt: Off
; 0000 1835 // Compare A Match Interrupt: Off
; 0000 1836 // Compare B Match Interrupt: Off
; 0000 1837 // Compare C Match Interrupt: Off
; 0000 1838 TCCR3A=0x00;
	STS  139,R30
; 0000 1839 TCCR3B=0x00;
	STS  138,R30
; 0000 183A TCNT3H=0x00;
	STS  137,R30
; 0000 183B TCNT3L=0x00;
	STS  136,R30
; 0000 183C ICR3H=0x00;
	STS  129,R30
; 0000 183D ICR3L=0x00;
	STS  128,R30
; 0000 183E OCR3AH=0x00;
	STS  135,R30
; 0000 183F OCR3AL=0x00;
	STS  134,R30
; 0000 1840 OCR3BH=0x00;
	STS  133,R30
; 0000 1841 OCR3BL=0x00;
	STS  132,R30
; 0000 1842 OCR3CH=0x00;
	STS  131,R30
; 0000 1843 OCR3CL=0x00;
	STS  130,R30
; 0000 1844 
; 0000 1845 // External Interrupt(s) initialization
; 0000 1846 // INT0: Off
; 0000 1847 // INT1: Off
; 0000 1848 // INT2: Off
; 0000 1849 // INT3: Off
; 0000 184A // INT4: Off
; 0000 184B // INT5: Off
; 0000 184C // INT6: Off
; 0000 184D // INT7: Off
; 0000 184E EICRA=0x00;
	STS  106,R30
; 0000 184F EICRB=0x00;
	OUT  0x3A,R30
; 0000 1850 EIMSK=0x00;
	OUT  0x39,R30
; 0000 1851 
; 0000 1852 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 1853 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 1854 
; 0000 1855 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 1856 
; 0000 1857 
; 0000 1858 // USART0 initialization
; 0000 1859 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 185A // USART0 Receiver: On
; 0000 185B // USART0 Transmitter: On
; 0000 185C // USART0 Mode: Asynchronous
; 0000 185D // USART0 Baud Rate: 115200
; 0000 185E UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 185F UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 1860 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 1861 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 1862 UBRR0L=0x08;
	LDI  R30,LOW(8)
	OUT  0x9,R30
; 0000 1863 
; 0000 1864 // USART1 initialization
; 0000 1865 // USART1 disabled
; 0000 1866 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 1867 
; 0000 1868 // Analog Comparator initialization
; 0000 1869 // Analog Comparator: Off
; 0000 186A // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 186B ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 186C SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 186D 
; 0000 186E // ADC initialization
; 0000 186F // ADC disabled
; 0000 1870 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 1871 
; 0000 1872 // SPI initialization
; 0000 1873 // SPI disabled
; 0000 1874 SPCR=0x00;
	OUT  0xD,R30
; 0000 1875 
; 0000 1876 // TWI initialization
; 0000 1877 // TWI disabled
; 0000 1878 TWCR=0x00;
	STS  116,R30
; 0000 1879 
; 0000 187A //ciekawe, tej linijki brakowalo w medalach ,wyczailem w borgu
; 0000 187B // I2C Bus initialization
; 0000 187C i2c_init();
	CALL _i2c_init
; 0000 187D 
; 0000 187E // Global enable interrupts
; 0000 187F #asm("sei")
	sei
; 0000 1880 
; 0000 1881 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0xE4
; 0000 1882 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0xE4
; 0000 1883 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0xE4
; 0000 1884 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0xE4
; 0000 1885 
; 0000 1886 //jak patrze na maszyne to ten po lewej to 1
; 0000 1887 
; 0000 1888 putchar(90);  //5A
	CALL SUBOPT_0x3
; 0000 1889 putchar(165); //A5
; 0000 188A putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _putchar
; 0000 188B putchar(128);  //80
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _putchar
; 0000 188C putchar(2);    //02
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
; 0000 188D putchar(16);   //10
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
; 0000 188E 
; 0000 188F il_prob_odczytu = 1;    //100
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 1890 start = 0;
	CALL SUBOPT_0xA1
; 0000 1891 //szczotka_druciana_ilosc_cykli = 4; bo eeprom
; 0000 1892 //krazek_scierny_cykl_po_okregu_ilosc = 4;
; 0000 1893 //krazek_scierny_ilosc_cykli = 4;
; 0000 1894 rzad_obrabiany = 1;
	CALL SUBOPT_0xE5
; 0000 1895 jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 1896 wykonalem_rzedow = 0;
	CALL SUBOPT_0xE6
; 0000 1897 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0xE7
; 0000 1898 guzik1_przelaczania_zaciskow = 1;
	SET
	BLD  R2,0
; 0000 1899 guzik2_przelaczania_zaciskow = 1;
	BLD  R2,1
; 0000 189A //PORTE.6 = 1;  //aby byl dostep do zaciskow rzad 1
; 0000 189B zmienna_przelaczanie_zaciskow = 1;
	BLD  R2,2
; 0000 189C czas_przedmuchu = 183;
	LDI  R30,LOW(183)
	LDI  R31,HIGH(183)
	STS  _czas_przedmuchu,R30
	STS  _czas_przedmuchu+1,R31
; 0000 189D predkosc_pion_szczotka = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 189E predkosc_pion_krazek = 100;
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 189F wejscie_krazka_sciernego_w_pow_boczna_cylindra = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 18A0 predkosc_ruchow_po_okregu_krazek_scierny = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 18A1 czas_druciaka_na_gorze = 100;  //1 sekundy dla druciaka na gorze aby dolek zrobil git (kiedyS), zmieniam na 3s
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _czas_druciaka_na_gorze,R30
	STS  _czas_druciaka_na_gorze+1,R31
; 0000 18A2 czas_zatrzymania_na_dole = 120;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	MOVW R12,R30
; 0000 18A3 
; 0000 18A4 adr1 = 80;  //rzad 1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STS  _adr1,R30
	STS  _adr1+1,R31
; 0000 18A5 adr2 = 0;   //
	LDI  R30,LOW(0)
	STS  _adr2,R30
	STS  _adr2+1,R30
; 0000 18A6 adr3 = 64;  //rzad 2
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STS  _adr3,R30
	STS  _adr3+1,R31
; 0000 18A7 adr4 = 0;
	LDI  R30,LOW(0)
	STS  _adr4,R30
	STS  _adr4+1,R30
; 0000 18A8 
; 0000 18A9 
; 0000 18AA wartosci_wstepne_panelu();
	CALL _wartosci_wstepne_panelu
; 0000 18AB wypozycjonuj_napedy_minimalistyczna();
	CALL _wypozycjonuj_napedy_minimalistyczna
; 0000 18AC sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 18AD 
; 0000 18AE //mniejsze ziarno na krazku - dobry pomysl
; 0000 18AF 
; 0000 18B0 
; 0000 18B1 while (1)
_0x353:
; 0000 18B2       {
; 0000 18B3       ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 18B4       przerzucanie_dociskow();
	CALL _przerzucanie_dociskow
; 0000 18B5       kontrola_zoltego_swiatla();
	RCALL _kontrola_zoltego_swiatla
; 0000 18B6       wymiana_szczotki_i_krazka();
	RCALL _wymiana_szczotki_i_krazka
; 0000 18B7       zaktualizuj_parametry_panelu();
	CALL _zaktualizuj_parametry_panelu
; 0000 18B8       odpytaj_parametry_panelu();
	CALL _odpytaj_parametry_panelu
; 0000 18B9       test_geometryczny();
	RCALL _test_geometryczny
; 0000 18BA       sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 18BB 
; 0000 18BC       while((start == 1 & il_zaciskow_rzad_1 > 1 & il_zaciskow_rzad_2 != 1 & macierz_zaciskow[1]!=0  & (macierz_zaciskow[2]!=0 |  il_zaciskow_rzad_2 == 0)) | jestem_w_trakcie_czyszczenia_calosci == 1)
_0x356:
	LDS  R26,_start
	LDS  R27,_start+1
	CALL SUBOPT_0x74
	MOV  R0,R30
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xD7
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	AND  R0,R30
	CALL SUBOPT_0xBA
	MOV  R1,R30
	CALL SUBOPT_0xD9
	MOV  R0,R30
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xA3
	OR   R30,R0
	AND  R30,R1
	MOV  R0,R30
	LDS  R26,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R27,_jestem_w_trakcie_czyszczenia_calosci+1
	CALL SUBOPT_0x74
	OR   R30,R0
	BRNE PC+3
	JMP _0x358
; 0000 18BD             {
; 0000 18BE             switch (cykl_glowny)
	LDS  R30,_cykl_glowny
	LDS  R31,_cykl_glowny+1
; 0000 18BF             {
; 0000 18C0             case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x35C
; 0000 18C1 
; 0000 18C2 
; 0000 18C3                     PORTB.6 = 1;   ////zielona lampka
	SBI  0x18,6
; 0000 18C4                     if(jestem_w_trakcie_czyszczenia_calosci == 0)
	LDS  R30,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R31,_jestem_w_trakcie_czyszczenia_calosci+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x35F
; 0000 18C5                         {
; 0000 18C6                         //PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 18C7 
; 0000 18C8                         wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x26
	CALL _wartosc_parametru_panelu
; 0000 18C9                         wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad2
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x29
	CALL _wartosc_parametru_panelu
; 0000 18CA 
; 0000 18CB                         il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
; 0000 18CC                         il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
; 0000 18CD 
; 0000 18CE                         szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64) - 1;  //wykonano zaciskow rzad1
	CALL SUBOPT_0x1E
	SBIW R30,1
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL __EEPROMWRW
; 0000 18CF                         szczotka_druciana_ilosc_cykli = 1; //zmieniam bo teraz inny ruch szczotki drucianej, jeden schoek na dole
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x23
; 0000 18D0                                                 //2090
; 0000 18D1                         krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);  //wykonano zaciskow rzad1
	CALL SUBOPT_0xB
	CALL SUBOPT_0x24
; 0000 18D2                                                     //3000
; 0000 18D3 
; 0000 18D4                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x25
; 0000 18D5 
; 0000 18D6                         if(krazek_scierny_cykl_po_okregu_ilosc == 0)
	CALL SUBOPT_0x73
	SBIW R30,0
	BRNE _0x360
; 0000 18D7                             {
; 0000 18D8                             krazek_scierny_ilosc_cykli--;
	CALL SUBOPT_0x93
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
; 0000 18D9                             }
; 0000 18DA 
; 0000 18DB                         predkosc_pion_szczotka = odczytaj_parametr(32,80);
_0x360:
	CALL SUBOPT_0x31
	CALL SUBOPT_0x28
	CALL _odczytaj_parametr
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 18DC                                                 //2060
; 0000 18DD                         predkosc_pion_krazek = odczytaj_parametr(32,96);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x29
	CALL _odczytaj_parametr
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 18DE 
; 0000 18DF                         wejscie_krazka_sciernego_w_pow_boczna_cylindra = odczytaj_parametr(48,16);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x26
	CALL _odczytaj_parametr
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 18E0 
; 0000 18E1                         predkosc_ruchow_po_okregu_krazek_scierny = odczytaj_parametr(32,112);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x27
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 18E2 
; 0000 18E3                         srednica_krazka_sciernego = odczytaj_parametr(48,112);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2A
; 0000 18E4 
; 0000 18E5                         ruch_haos = odczytaj_parametr(48,144);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x2B
; 0000 18E6 
; 0000 18E7                         if(il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0)
	CALL SUBOPT_0xE8
	MOV  R0,R30
	CALL SUBOPT_0xD9
	AND  R30,R0
	BREQ _0x361
; 0000 18E8                               il_zaciskow_rzad_2 = il_zaciskow_rzad_2;
	CALL SUBOPT_0xE9
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
; 0000 18E9                         else
	RJMP _0x362
_0x361:
; 0000 18EA                               il_zaciskow_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R30
; 0000 18EB 
; 0000 18EC                         wybor_linijek_sterownikow(1);  //rzad 1
_0x362:
	CALL SUBOPT_0xBB
; 0000 18ED                         }
; 0000 18EE 
; 0000 18EF                     jestem_w_trakcie_czyszczenia_calosci = 1;
_0x35F:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R31
; 0000 18F0 
; 0000 18F1                     if(rzad_obrabiany == 1)
	CALL SUBOPT_0x8D
	SBIW R26,1
	BRNE _0x363
; 0000 18F2                     {
; 0000 18F3                     PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
	CBI  0x3,6
; 0000 18F4                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x366
; 0000 18F5                         cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xC4
; 0000 18F6                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x366:
	CALL SUBOPT_0xC5
	SBIW R26,5
	BRGE _0x367
; 0000 18F7                         cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xC7
; 0000 18F8                     }
_0x367:
; 0000 18F9 
; 0000 18FA                     if(rzad_obrabiany == 2)
_0x363:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x368
; 0000 18FB                     {
; 0000 18FC                     ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 18FD                     //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2 - na razie nie bo nie ma jeszcze oslon
; 0000 18FE 
; 0000 18FF                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x369
; 0000 1900                         cykl_sterownik_1 = sterownik_1_praca(0x008);
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xC4
; 0000 1901                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x369:
	CALL SUBOPT_0xC5
	SBIW R26,5
	BRGE _0x36A
; 0000 1902                         cykl_sterownik_2 = sterownik_2_praca(0x001);       //ster 2 pod pin pozy rzad 2
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xC7
; 0000 1903                     }
_0x36A:
; 0000 1904 
; 0000 1905 
; 0000 1906                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x368:
	CALL SUBOPT_0xC8
	BREQ _0x36B
; 0000 1907                         {
; 0000 1908 
; 0000 1909                           if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x36C
; 0000 190A                             {
; 0000 190B                             while(PORTE.6 == 0)
_0x36D:
	SBIC 0x3,6
	RJMP _0x36F
; 0000 190C                                 przerzucanie_dociskow();
	CALL _przerzucanie_dociskow
	RJMP _0x36D
_0x36F:
; 0000 190D delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 190E                             }
; 0000 190F 
; 0000 1910                         delay_ms(2000);  //aby zdazyl przelozyc
_0x36C:
	CALL SUBOPT_0xE4
; 0000 1911                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 1912                         cykl_sterownik_2 = 0;
; 0000 1913                         cykl_sterownik_3 = 0;
; 0000 1914                         cykl_sterownik_4 = 0;
; 0000 1915                         cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0xE7
; 0000 1916                         koniec_rzedu_10 = 0;
	CALL SUBOPT_0xEA
; 0000 1917                         cykl_glowny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0xEB
; 0000 1918                         }
; 0000 1919 
; 0000 191A             break;
_0x36B:
	RJMP _0x35B
; 0000 191B 
; 0000 191C 
; 0000 191D 
; 0000 191E             case 1:
_0x35C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x370
; 0000 191F 
; 0000 1920 
; 0000 1921                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 1)
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xED
	AND  R30,R0
	BREQ _0x371
; 0000 1922                           {          //ster 1 nic
; 0000 1923                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 1924                           cykl_sterownik_2 = sterownik_2_praca(a[0]);        //ster 2 pod zacisk
	CALL SUBOPT_0xCA
	CALL SUBOPT_0xC7
; 0000 1925                           }                                                    //ster 4 na pozycje miedzy rzedzami
; 0000 1926 
; 0000 1927                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 2)
_0x371:
	CALL SUBOPT_0xEC
	CALL SUBOPT_0x8F
	AND  R30,R0
	BREQ _0x374
; 0000 1928                         {
; 0000 1929                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 192A                           ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 192B                           cykl_sterownik_2 = sterownik_2_praca(a[1]);
	CALL SUBOPT_0xDD
	CALL SUBOPT_0xC7
; 0000 192C                          }
; 0000 192D                      if(cykl_sterownik_4 < 5 & cykl_sterownik_2 == 5)
_0x374:
	CALL SUBOPT_0xEE
	CALL __LTW12
	CALL SUBOPT_0xEF
	AND  R30,R0
	BREQ _0x377
; 0000 192E                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0xF0
	CALL SUBOPT_0xC0
; 0000 192F 
; 0000 1930                       if(cykl_sterownik_2 == 5 & cykl_sterownik_4 == 5)
_0x377:
	CALL SUBOPT_0xC5
	CALL SUBOPT_0xF1
	CALL SUBOPT_0xEE
	CALL __EQW12
	AND  R30,R0
	BREQ _0x378
; 0000 1931                         {
; 0000 1932                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 1933                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0xF3
; 0000 1934                         cykl_sterownik_4 = 0;
; 0000 1935                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0xF4
; 0000 1936                         cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xEB
; 0000 1937                         }
; 0000 1938 
; 0000 1939 
; 0000 193A             break;
_0x378:
	RJMP _0x35B
; 0000 193B 
; 0000 193C 
; 0000 193D             case 2:
_0x370:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x379
; 0000 193E                     if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x37A
; 0000 193F                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1940 
; 0000 1941                     if(cykl_sterownik_4 < 5)
_0x37A:
	CALL SUBOPT_0xBF
	SBIW R26,5
	BRGE _0x37B
; 0000 1942                         //cykl_sterownik_4 = sterownik_4_praca(1,0,0,0,1,0);
; 0000 1943                           cykl_sterownik_4 = sterownik_4_praca(a[2],1);
	CALL SUBOPT_0x77
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xC0
; 0000 1944                     if(cykl_sterownik_4 == 5)
_0x37B:
	CALL SUBOPT_0xBF
	SBIW R26,5
	BRNE _0x37C
; 0000 1945                         {
; 0000 1946                         PORTE.2 = 1;  //wlacz szlifierke   wylaczam do testu
	SBI  0x3,2
; 0000 1947                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xF6
; 0000 1948                         sek13 = 0;
	CALL SUBOPT_0xF7
; 0000 1949                         cykl_glowny = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xEB
; 0000 194A                         }
; 0000 194B 
; 0000 194C             break;
_0x37C:
	RJMP _0x35B
; 0000 194D 
; 0000 194E 
; 0000 194F             case 3:
_0x379:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x37F
; 0000 1950 
; 0000 1951                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x380
; 0000 1952                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1953 
; 0000 1954                     if(cykl_sterownik_4 < 5 & sek13 > czas_druciaka_na_gorze & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x380:
	CALL SUBOPT_0xEE
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0xF8
	AND  R0,R30
	CALL SUBOPT_0x90
	CALL SUBOPT_0xF9
	BREQ _0x381
; 0000 1955                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV
	CALL SUBOPT_0x72
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC0
; 0000 1956 
; 0000 1957                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x381:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFA
	CALL SUBOPT_0xF9
	BREQ _0x382
; 0000 1958                         {
; 0000 1959                         szczotka_druc_cykl++;
	CALL SUBOPT_0xFB
; 0000 195A                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xF6
; 0000 195B                         }
; 0000 195C 
; 0000 195D                     if(cykl_sterownik_4 < 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
_0x382:
	CALL SUBOPT_0xEE
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x90
	CALL SUBOPT_0xFC
	BREQ _0x383
; 0000 195E                          cykl_sterownik_4 = sterownik_4_praca(0x03,0); //INV
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC0
; 0000 195F 
; 0000 1960 
; 0000 1961 
; 0000 1962                         if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
_0x383:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFA
	CALL SUBOPT_0xFC
	BREQ _0x384
; 0000 1963                             {
; 0000 1964                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1965                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xF6
; 0000 1966                             cykl_glowny = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xEB
; 0000 1967                             }
; 0000 1968 
; 0000 1969 
; 0000 196A 
; 0000 196B 
; 0000 196C 
; 0000 196D             break;
_0x384:
	RJMP _0x35B
; 0000 196E 
; 0000 196F             case 4:
_0x37F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x387
; 0000 1970 
; 0000 1971 
; 0000 1972                       if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x388
; 0000 1973                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1974 
; 0000 1975                      if(cykl_sterownik_4 < 5)
_0x388:
	CALL SUBOPT_0xBF
	SBIW R26,5
	BRGE _0x389
; 0000 1976                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0xF0
	CALL SUBOPT_0xC0
; 0000 1977 
; 0000 1978                      if(cykl_sterownik_4 == 5)
_0x389:
	CALL SUBOPT_0xBF
	SBIW R26,5
	BRNE _0x38A
; 0000 1979                         {
; 0000 197A                         PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 197B                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xF6
; 0000 197C                         cykl_glowny = 5;
	CALL SUBOPT_0xFD
; 0000 197D                         }
; 0000 197E 
; 0000 197F             break;
_0x38A:
	RJMP _0x35B
; 0000 1980 
; 0000 1981             case 5:
_0x387:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x38D
; 0000 1982 
; 0000 1983 
; 0000 1984                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 1)
	CALL SUBOPT_0xFE
	AND  R0,R30
	CALL SUBOPT_0xED
	AND  R30,R0
	BREQ _0x38E
; 0000 1985                         cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xC4
; 0000 1986                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 2)
_0x38E:
	CALL SUBOPT_0xFE
	AND  R0,R30
	CALL SUBOPT_0x8F
	AND  R30,R0
	BREQ _0x38F
; 0000 1987                         cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xC4
; 0000 1988 
; 0000 1989                      if(rzad_obrabiany == 2)
_0x38F:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x390
; 0000 198A                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 198B 
; 0000 198C                     if(cykl_sterownik_1 == 5 & ruch_zlozony == 0)
_0x390:
	CALL SUBOPT_0xFF
	CALL SUBOPT_0x100
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x391
; 0000 198D                         {
; 0000 198E                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 198F                         ruch_zlozony = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 1990                         }
; 0000 1991 
; 0000 1992                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 1)
_0x391:
	CALL SUBOPT_0x101
	AND  R0,R30
	CALL SUBOPT_0xED
	AND  R30,R0
	BREQ _0x392
; 0000 1993                         cykl_sterownik_1 = sterownik_1_praca(a[0]);
	CALL SUBOPT_0xCA
	CALL SUBOPT_0xC4
; 0000 1994                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 2)
_0x392:
	CALL SUBOPT_0x101
	AND  R0,R30
	CALL SUBOPT_0x8F
	AND  R30,R0
	BREQ _0x393
; 0000 1995                           cykl_sterownik_1 = sterownik_1_praca(a[1]);
	CALL SUBOPT_0xDD
	CALL SUBOPT_0xC4
; 0000 1996 
; 0000 1997 
; 0000 1998                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 2)
_0x393:
	CALL SUBOPT_0x102
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x103
	BREQ _0x394
; 0000 1999                         cykl_sterownik_1 = sterownik_1_praca(0x003);     ////////////////////////////////////////////////////////////
	CALL SUBOPT_0xD6
; 0000 199A 
; 0000 199B                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 0)                                //ster 1 do pierwszego dolka
_0x394:
	CALL SUBOPT_0xEC
	CALL SUBOPT_0x104
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x395
; 0000 199C                         cykl_sterownik_2 = sterownik_2_praca(0x003);       //ster 2 pod nastpeny dolek
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x105
; 0000 199D 
; 0000 199E 
; 0000 199F                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 1)
_0x395:
	CALL SUBOPT_0xEC
	CALL SUBOPT_0x106
	AND  R0,R30
	CALL SUBOPT_0xED
	AND  R30,R0
	BREQ _0x396
; 0000 19A0                         cykl_sterownik_2 = sterownik_2_praca(0x008);      //ster 2 do samego tylu
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xC7
; 0000 19A1                      if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 2)
_0x396:
	CALL SUBOPT_0xEC
	CALL SUBOPT_0x106
	AND  R0,R30
	CALL SUBOPT_0x8F
	AND  R30,R0
	BREQ _0x397
; 0000 19A2                         cykl_sterownik_2 = sterownik_2_praca(0x009);      //ster 2 do samego tylu
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xC7
; 0000 19A3 
; 0000 19A4                     if((cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5 & ruch_zlozony == 1) | (cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5) & ruch_zlozony == 2)
_0x397:
	CALL SUBOPT_0x102
	CALL __EQW12
	CALL SUBOPT_0xEF
	AND  R0,R30
	CALL SUBOPT_0x100
	CALL SUBOPT_0x74
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0x102
	CALL __EQW12
	CALL SUBOPT_0xEF
	AND  R0,R30
	CALL SUBOPT_0x103
	OR   R30,R1
	BREQ _0x398
; 0000 19A5                         {
; 0000 19A6                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 19A7                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0xF3
; 0000 19A8                         cykl_sterownik_4 = 0;
; 0000 19A9                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x107
; 0000 19AA                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
	SBI  0x3,3
; 0000 19AB                         cykl_glowny = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0xEB
; 0000 19AC                         }
; 0000 19AD 
; 0000 19AE             break;
_0x398:
	RJMP _0x35B
; 0000 19AF 
; 0000 19B0 
; 0000 19B1             case 6:
_0x38D:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x39B
; 0000 19B2 
; 0000 19B3 
; 0000 19B4 
; 0000 19B5 
; 0000 19B6                     if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xBD
	SBIW R26,5
	BRGE _0x39C
; 0000 19B7                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs //krazek scierny do gory
	CALL SUBOPT_0x6F
	CALL SUBOPT_0xCB
; 0000 19B8 
; 0000 19B9                     if(koniec_rzedu_10 == 1)
_0x39C:
	CALL SUBOPT_0x104
	SBIW R26,1
	BRNE _0x39D
; 0000 19BA                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x108
; 0000 19BB 
; 0000 19BC                     if(cykl_sterownik_4 < 5)
_0x39D:
	CALL SUBOPT_0xBF
	SBIW R26,5
	BRGE _0x39E
; 0000 19BD                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);    //ABS          //druciak do gory
	CALL SUBOPT_0x77
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xC0
; 0000 19BE 
; 0000 19BF                      if(rzad_obrabiany == 2)
_0x39E:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x39F
; 0000 19C0                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 19C1 
; 0000 19C2 
; 0000 19C3                     if(cykl_sterownik_4 == 5 & cykl_sterownik_3 == 5)
_0x39F:
	CALL SUBOPT_0xEE
	CALL __EQW12
	CALL SUBOPT_0x109
	CALL __EQW12
	AND  R30,R0
	BREQ _0x3A0
; 0000 19C4                         {
; 0000 19C5                         if((cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1 & rzad_obrabiany == 1) | (cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1 & rzad_obrabiany == 2))
	CALL SUBOPT_0x10A
	MOV  R0,R30
	CALL SUBOPT_0xED
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0x10B
	MOV  R0,R30
	CALL SUBOPT_0x8F
	AND  R30,R0
	OR   R30,R1
	BREQ _0x3A1
; 0000 19C6                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 19C7 
; 0000 19C8 
; 0000 19C9                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
_0x3A1:
	SBI  0x3,3
; 0000 19CA                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xC2
; 0000 19CB                         cykl_sterownik_4 = 0;
; 0000 19CC                         if(cykl_ilosc_zaciskow > 0)
	CALL SUBOPT_0x10C
	CALL __CPW02
	BRGE _0x3A6
; 0000 19CD                                 {
; 0000 19CE                                 sek12 = 0;    //do przedmuchu
	CALL SUBOPT_0x10D
; 0000 19CF                                 PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x10E
; 0000 19D0                                 PORTF = PORT_F.byte;
; 0000 19D1                                 }
; 0000 19D2 
; 0000 19D3                         sek13 = 0;
_0x3A6:
	CALL SUBOPT_0xF7
; 0000 19D4                         cykl_glowny = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0xEB
; 0000 19D5                         }
; 0000 19D6 
; 0000 19D7            break;
_0x3A0:
	RJMP _0x35B
; 0000 19D8 
; 0000 19D9 
; 0000 19DA            case 7:
_0x39B:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x3A7
; 0000 19DB 
; 0000 19DC 
; 0000 19DD                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x3A8
; 0000 19DE                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 19DF 
; 0000 19E0                         wykonalem_komplet_okregow = 0;
_0x3A8:
	CALL SUBOPT_0x10F
; 0000 19E1                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x110
; 0000 19E2                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x111
; 0000 19E3                         krazek_scierny_cykl = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x112
; 0000 19E4                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x113
; 0000 19E5                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x114
; 0000 19E6 
; 0000 19E7                         abs_ster3 = 0;
	CALL SUBOPT_0x115
; 0000 19E8                         abs_ster4 = 0;
	CALL SUBOPT_0x116
; 0000 19E9                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 19EA                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0xF3
; 0000 19EB                         cykl_sterownik_4 = 0;
; 0000 19EC                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x107
; 0000 19ED 
; 0000 19EE                         if(krazek_scierny_cykl_po_okregu_ilosc > 0)
	CALL SUBOPT_0x73
	MOVW R26,R30
	CALL __CPW02
	BRGE _0x3A9
; 0000 19EF                                 {
; 0000 19F0                                 cykl_glowny = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0xEB
; 0000 19F1                                 if(ruch_haos == 1)
	LDS  R26,_ruch_haos
	LDS  R27,_ruch_haos+1
	SBIW R26,1
	BRNE _0x3AA
; 0000 19F2                                     cykl_glowny = 888;
	LDI  R30,LOW(888)
	LDI  R31,HIGH(888)
	CALL SUBOPT_0xEB
; 0000 19F3                                 }
_0x3AA:
; 0000 19F4                         else
	RJMP _0x3AB
_0x3A9:
; 0000 19F5                            cykl_glowny = 999;
	LDI  R30,LOW(999)
	LDI  R31,HIGH(999)
	CALL SUBOPT_0xEB
; 0000 19F6 
; 0000 19F7 
; 0000 19F8 
; 0000 19F9 
; 0000 19FA            break;
_0x3AB:
	RJMP _0x35B
; 0000 19FB 
; 0000 19FC 
; 0000 19FD            case 888:
_0x3A7:
	CPI  R30,LOW(0x378)
	LDI  R26,HIGH(0x378)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3AC
; 0000 19FE 
; 0000 19FF                         if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x117
	BRGE _0x3AD
; 0000 1A00                         {
; 0000 1A01                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x118
; 0000 1A02                         PORTF = PORT_F.byte;
; 0000 1A03                         }
; 0000 1A04 
; 0000 1A05 
; 0000 1A06                      if(rzad_obrabiany == 2)
_0x3AD:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x3AE
; 0000 1A07                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1A08 
; 0000 1A09                     if(koniec_rzedu_10 == 1)
_0x3AE:
	CALL SUBOPT_0x104
	SBIW R26,1
	BRNE _0x3AF
; 0000 1A0A                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x108
; 0000 1A0B 
; 0000 1A0C 
; 0000 1A0D                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x3AF:
	CALL SUBOPT_0x102
	CALL SUBOPT_0x119
	MOVW R26,R30
	CALL SUBOPT_0xD8
	CALL SUBOPT_0x11A
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x3B0
; 0000 1A0E                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x70
	CALL SUBOPT_0x11B
; 0000 1A0F 
; 0000 1A10                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x3B0:
	CALL SUBOPT_0xFF
	CALL SUBOPT_0x11C
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x3B1
; 0000 1A11                         {
; 0000 1A12                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 1A13                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x11D
; 0000 1A14                         }
; 0000 1A15 
; 0000 1A16 
; 0000 1A17                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3B1:
	CALL SUBOPT_0x102
	CALL SUBOPT_0x119
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x74
	AND  R30,R0
	BREQ _0x3B2
; 0000 1A18                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x11F
; 0000 1A19 
; 0000 1A1A                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3B2:
	CALL SUBOPT_0xFF
	CALL SUBOPT_0x73
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x74
	AND  R30,R0
	BREQ _0x3B3
; 0000 1A1B                         {
; 0000 1A1C                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 1A1D                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x120
; 0000 1A1E                         }
; 0000 1A1F 
; 0000 1A20                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3B3:
	CALL SUBOPT_0x73
	CALL SUBOPT_0x121
	AND  R30,R0
	BREQ _0x3B4
; 0000 1A21                         {
; 0000 1A22                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 1A23                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x122
; 0000 1A24                         }
; 0000 1A25 
; 0000 1A26                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1A27                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x3B4:
	CALL SUBOPT_0x102
	CALL SUBOPT_0x123
	BREQ _0x3B5
; 0000 1A28                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x124
; 0000 1A29 
; 0000 1A2A 
; 0000 1A2B                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x3B5:
	CALL SUBOPT_0xFF
	CALL SUBOPT_0x125
	BREQ _0x3B6
; 0000 1A2C                         {
; 0000 1A2D                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 1A2E                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x126
; 0000 1A2F                         }
; 0000 1A30 
; 0000 1A31 
; 0000 1A32 
; 0000 1A33 
; 0000 1A34 
; 0000 1A35 
; 0000 1A36 
; 0000 1A37                                                               //to nowy war, ostatni dzien w borg
; 0000 1A38                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3B6:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0x127
	CALL SUBOPT_0xA3
	CALL SUBOPT_0x128
	AND  R0,R30
	CALL SUBOPT_0xF8
	AND  R30,R0
	BREQ _0x3B7
; 0000 1A39                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x72
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC0
; 0000 1A3A 
; 0000 1A3B                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3B7:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFA
	CALL SUBOPT_0x129
	CALL SUBOPT_0x12A
	AND  R30,R0
	BREQ _0x3B8
; 0000 1A3C                         {
; 0000 1A3D                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x12B
	BRNE _0x3B9
; 0000 1A3E                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xF6
; 0000 1A3F                         if(abs_ster4 == 0)
_0x3B9:
	CALL SUBOPT_0x12C
	BRNE _0x3BA
; 0000 1A40                             {
; 0000 1A41                             szczotka_druc_cykl++;
	CALL SUBOPT_0xFB
; 0000 1A42                             abs_ster4 = 1;
	CALL SUBOPT_0x12D
; 0000 1A43                             }
; 0000 1A44                         else
	RJMP _0x3BB
_0x3BA:
; 0000 1A45                             {
; 0000 1A46                             abs_ster4 = 0;
	CALL SUBOPT_0x116
; 0000 1A47                             sek13 = 0;
	CALL SUBOPT_0xF7
; 0000 1A48                             }
_0x3BB:
; 0000 1A49                         }
; 0000 1A4A 
; 0000 1A4B                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3B8:
	CALL SUBOPT_0x12E
	CALL SUBOPT_0xA3
	CALL SUBOPT_0x12F
	AND  R30,R0
	BREQ _0x3BC
; 0000 1A4C                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x75
	CALL SUBOPT_0xCB
; 0000 1A4D 
; 0000 1A4E 
; 0000 1A4F                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3BC:
	CALL SUBOPT_0x130
	CALL SUBOPT_0x93
	CALL SUBOPT_0x131
	CALL __LTW12
	CALL SUBOPT_0x12F
	AND  R30,R0
	BREQ _0x3BD
; 0000 1A50                         {
; 0000 1A51                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x132
; 0000 1A52                         if(abs_ster3 == 0)
	BRNE _0x3BE
; 0000 1A53                             {
; 0000 1A54                             krazek_scierny_cykl++;
	CALL SUBOPT_0x133
; 0000 1A55                             abs_ster3 = 1;
; 0000 1A56                             }
; 0000 1A57                         else
	RJMP _0x3BF
_0x3BE:
; 0000 1A58                             abs_ster3 = 0;
	CALL SUBOPT_0x115
; 0000 1A59                         }
_0x3BF:
; 0000 1A5A 
; 0000 1A5B                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3BD:
	CALL SUBOPT_0x12E
	CALL SUBOPT_0x74
	AND  R30,R0
	BREQ _0x3C0
; 0000 1A5C                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x6F
	CALL SUBOPT_0xCB
; 0000 1A5D 
; 0000 1A5E                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x3C0:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0x127
	CALL SUBOPT_0x74
	CALL SUBOPT_0x128
	AND  R30,R0
	BREQ _0x3C1
; 0000 1A5F                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory
	CALL SUBOPT_0x134
	CALL SUBOPT_0xC0
; 0000 1A60 
; 0000 1A61 
; 0000 1A62 
; 0000 1A63                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1A64 
; 0000 1A65                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonalem_komplet_okregow == 3)
_0x3C1:
	CALL SUBOPT_0x130
	CALL SUBOPT_0x93
	CALL SUBOPT_0x135
	CALL SUBOPT_0x90
	CALL SUBOPT_0x136
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x137
	BREQ _0x3C2
; 0000 1A66                        {
; 0000 1A67                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x138
; 0000 1A68                        powrot_przedwczesny_krazek_scierny = 1;
; 0000 1A69                        }
; 0000 1A6A                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x3C2:
	CALL SUBOPT_0x139
	CALL SUBOPT_0x109
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3C3
; 0000 1A6B                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x13A
; 0000 1A6C 
; 0000 1A6D                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x3C3:
	CALL SUBOPT_0x130
	CALL SUBOPT_0x139
	AND  R30,R0
	BREQ _0x3C4
; 0000 1A6E                        {
; 0000 1A6F                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x13B
; 0000 1A70                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
; 0000 1A71                        }
; 0000 1A72                    //////////////////////////////////////////////
; 0000 1A73 
; 0000 1A74 
; 0000 1A75 
; 0000 1A76                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1A77 
; 0000 1A78                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x3C4:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFA
	CALL SUBOPT_0x13C
	AND  R0,R30
	CALL SUBOPT_0x93
	CALL SUBOPT_0x131
	CALL __NEW12
	AND  R30,R0
	BREQ _0x3C7
; 0000 1A79                        {
; 0000 1A7A                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1A7B                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0xF6
; 0000 1A7C                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x13D
; 0000 1A7D                        }
; 0000 1A7E                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3C7:
	CALL SUBOPT_0x13E
	MOV  R0,R30
	CALL SUBOPT_0xEE
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3CA
; 0000 1A7F                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xF0
	CALL SUBOPT_0xC0
; 0000 1A80 
; 0000 1A81                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3CA:
	CALL SUBOPT_0xEE
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x13E
	AND  R30,R0
	BREQ _0x3CB
; 0000 1A82                        {
; 0000 1A83                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x114
; 0000 1A84                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1A85                        }
; 0000 1A86                    //////////////////////////////////////////////
; 0000 1A87 
; 0000 1A88                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3CB:
; 0000 1A89                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1A8A                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1A8B                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0 &  wykonalem_komplet_okregow == 3)
	CALL SUBOPT_0x90
	CALL SUBOPT_0x13C
	MOV  R0,R30
	CALL SUBOPT_0x93
	CALL SUBOPT_0x135
	CALL SUBOPT_0x13F
	CALL __EQW12
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x128
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x137
	BREQ _0x3CE
; 0000 1A8C                         {
; 0000 1A8D                         powrot_przedwczesny_krazek_scierny = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x113
; 0000 1A8E                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x114
; 0000 1A8F                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 1A90                         cykl_sterownik_2 = 0;
; 0000 1A91                         cykl_sterownik_3 = 0;
; 0000 1A92                         cykl_sterownik_4 = 0;
; 0000 1A93                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x110
; 0000 1A94                         krazek_scierny_cykl = 0;
	CALL SUBOPT_0x112
; 0000 1A95                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x111
; 0000 1A96                         wykonalem_komplet_okregow = 0;
	CALL SUBOPT_0x10F
; 0000 1A97                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0x118
; 0000 1A98                         PORTF = PORT_F.byte;
; 0000 1A99                         PORTE.2 = 0;  //wylacz szlifierke
	CALL SUBOPT_0x140
; 0000 1A9A                         cykl_glowny = 9;
; 0000 1A9B                         }
; 0000 1A9C 
; 0000 1A9D 
; 0000 1A9E 
; 0000 1A9F            break;
_0x3CE:
	RJMP _0x35B
; 0000 1AA0 
; 0000 1AA1 
; 0000 1AA2            case 999:
_0x3AC:
	CPI  R30,LOW(0x3E7)
	LDI  R26,HIGH(0x3E7)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3D1
; 0000 1AA3 
; 0000 1AA4            if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x117
	BRGE _0x3D2
; 0000 1AA5                         {
; 0000 1AA6                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x118
; 0000 1AA7                         PORTF = PORT_F.byte;
; 0000 1AA8                         }
; 0000 1AA9 
; 0000 1AAA 
; 0000 1AAB                      if(rzad_obrabiany == 2)
_0x3D2:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x3D3
; 0000 1AAC                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1AAD 
; 0000 1AAE                     if(koniec_rzedu_10 == 1)
_0x3D3:
	CALL SUBOPT_0x104
	SBIW R26,1
	BRNE _0x3D4
; 0000 1AAF                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x108
; 0000 1AB0                                                               //to nowy war, ostatni dzien w borg
; 0000 1AB1                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3D4:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0x127
	CALL SUBOPT_0xA3
	CALL SUBOPT_0x128
	AND  R0,R30
	CALL SUBOPT_0xF8
	AND  R30,R0
	BREQ _0x3D5
; 0000 1AB2                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x72
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC0
; 0000 1AB3 
; 0000 1AB4                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3D5:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFA
	CALL SUBOPT_0x129
	CALL SUBOPT_0x12A
	AND  R30,R0
	BREQ _0x3D6
; 0000 1AB5                         {
; 0000 1AB6                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x12B
	BRNE _0x3D7
; 0000 1AB7                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xF6
; 0000 1AB8                         if(abs_ster4 == 0)
_0x3D7:
	CALL SUBOPT_0x12C
	BRNE _0x3D8
; 0000 1AB9                             {
; 0000 1ABA                             //PORTE.2 = 0;  //wylacz szlifierke
; 0000 1ABB                             szczotka_druc_cykl++;
	CALL SUBOPT_0xFB
; 0000 1ABC                             abs_ster4 = 1;
	CALL SUBOPT_0x12D
; 0000 1ABD                             }
; 0000 1ABE                         else
	RJMP _0x3D9
_0x3D8:
; 0000 1ABF                             {
; 0000 1AC0                             abs_ster4 = 0;
	CALL SUBOPT_0x116
; 0000 1AC1                             sek13 = 0;
	CALL SUBOPT_0xF7
; 0000 1AC2                             }
_0x3D9:
; 0000 1AC3                         }
; 0000 1AC4 
; 0000 1AC5                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3D6:
	CALL SUBOPT_0x12E
	CALL SUBOPT_0xA3
	CALL SUBOPT_0x12F
	AND  R30,R0
	BREQ _0x3DA
; 0000 1AC6                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x75
	CALL SUBOPT_0xCB
; 0000 1AC7 
; 0000 1AC8 
; 0000 1AC9                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3DA:
	CALL SUBOPT_0x130
	CALL SUBOPT_0x93
	CALL SUBOPT_0x131
	CALL __LTW12
	CALL SUBOPT_0x12F
	AND  R30,R0
	BREQ _0x3DB
; 0000 1ACA                         {
; 0000 1ACB                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x132
; 0000 1ACC                         if(abs_ster3 == 0)
	BRNE _0x3DC
; 0000 1ACD                             {
; 0000 1ACE                             krazek_scierny_cykl++;
	CALL SUBOPT_0x133
; 0000 1ACF 
; 0000 1AD0                             abs_ster3 = 1;
; 0000 1AD1                             }
; 0000 1AD2                         else
	RJMP _0x3DD
_0x3DC:
; 0000 1AD3                             abs_ster3 = 0;
	CALL SUBOPT_0x115
; 0000 1AD4                         }
_0x3DD:
; 0000 1AD5 
; 0000 1AD6                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3DB:
	CALL SUBOPT_0x12E
	CALL SUBOPT_0x74
	AND  R30,R0
	BREQ _0x3DE
; 0000 1AD7                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x6F
	CALL SUBOPT_0xCB
; 0000 1AD8 
; 0000 1AD9                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x3DE:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0x127
	CALL SUBOPT_0x74
	CALL SUBOPT_0x128
	AND  R30,R0
	BREQ _0x3DF
; 0000 1ADA                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory kawaleczek
	CALL SUBOPT_0x134
	CALL SUBOPT_0xC0
; 0000 1ADB 
; 0000 1ADC 
; 0000 1ADD 
; 0000 1ADE                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1ADF 
; 0000 1AE0                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x3DF:
	CALL SUBOPT_0x130
	CALL SUBOPT_0x93
	CALL SUBOPT_0x135
	CALL SUBOPT_0x90
	CALL SUBOPT_0x136
	AND  R30,R0
	BREQ _0x3E0
; 0000 1AE1                        {
; 0000 1AE2                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x138
; 0000 1AE3                        powrot_przedwczesny_krazek_scierny = 1;
; 0000 1AE4                        }
; 0000 1AE5                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x3E0:
	CALL SUBOPT_0x139
	CALL SUBOPT_0x109
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3E1
; 0000 1AE6                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x13A
; 0000 1AE7 
; 0000 1AE8                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x3E1:
	CALL SUBOPT_0x130
	CALL SUBOPT_0x139
	AND  R30,R0
	BREQ _0x3E2
; 0000 1AE9                        {
; 0000 1AEA                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x13B
; 0000 1AEB                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
; 0000 1AEC                        }
; 0000 1AED                    //////////////////////////////////////////////
; 0000 1AEE 
; 0000 1AEF 
; 0000 1AF0 
; 0000 1AF1                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1AF2 
; 0000 1AF3                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x3E2:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFA
	CALL SUBOPT_0x13C
	AND  R0,R30
	CALL SUBOPT_0x93
	CALL SUBOPT_0x131
	CALL __NEW12
	AND  R30,R0
	BREQ _0x3E5
; 0000 1AF4                        {
; 0000 1AF5                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1AF6                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0xF6
; 0000 1AF7                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x13D
; 0000 1AF8                        }
; 0000 1AF9                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3E5:
	CALL SUBOPT_0x13E
	MOV  R0,R30
	CALL SUBOPT_0xEE
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3E8
; 0000 1AFA                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xF0
	CALL SUBOPT_0xC0
; 0000 1AFB 
; 0000 1AFC                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3E8:
	CALL SUBOPT_0xEE
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x13E
	AND  R30,R0
	BREQ _0x3E9
; 0000 1AFD                        {
; 0000 1AFE                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x114
; 0000 1AFF                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1B00                        }
; 0000 1B01                    //////////////////////////////////////////////
; 0000 1B02 
; 0000 1B03                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3E9:
; 0000 1B04                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1B05                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1B06                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0)
	CALL SUBOPT_0x90
	CALL SUBOPT_0x13C
	MOV  R0,R30
	CALL SUBOPT_0x93
	CALL SUBOPT_0x135
	CALL SUBOPT_0x13F
	CALL __EQW12
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x128
	AND  R30,R0
	BREQ _0x3EC
; 0000 1B07                         {
; 0000 1B08                         powrot_przedwczesny_krazek_scierny = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x113
; 0000 1B09                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x114
; 0000 1B0A                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 1B0B                         cykl_sterownik_2 = 0;
; 0000 1B0C                         cykl_sterownik_3 = 0;
; 0000 1B0D                         cykl_sterownik_4 = 0;
; 0000 1B0E                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x110
; 0000 1B0F                         krazek_scierny_cykl = 0;
	CALL SUBOPT_0x112
; 0000 1B10                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x111
; 0000 1B11                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0x118
; 0000 1B12                         PORTF = PORT_F.byte;
; 0000 1B13                         PORTE.2 = 0;  //wylacz szlifierke
	CALL SUBOPT_0x140
; 0000 1B14                         cykl_glowny = 9;
; 0000 1B15                         }
; 0000 1B16 
; 0000 1B17 
; 0000 1B18            break;
_0x3EC:
	RJMP _0x35B
; 0000 1B19 
; 0000 1B1A 
; 0000 1B1B             case 8:
_0x3D1:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3EF
; 0000 1B1C 
; 0000 1B1D                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x117
	BRGE _0x3F0
; 0000 1B1E                         {
; 0000 1B1F                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x118
; 0000 1B20                         PORTF = PORT_F.byte;
; 0000 1B21                         }
; 0000 1B22 
; 0000 1B23 
; 0000 1B24                      if(rzad_obrabiany == 2)
_0x3F0:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x3F1
; 0000 1B25                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1B26 
; 0000 1B27 
; 0000 1B28 
; 0000 1B29                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x3F1:
	CALL SUBOPT_0x102
	CALL SUBOPT_0x119
	MOVW R26,R30
	CALL SUBOPT_0xD8
	CALL SUBOPT_0x11A
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x3F2
; 0000 1B2A                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x70
	CALL SUBOPT_0x11B
; 0000 1B2B                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x3F2:
	CALL SUBOPT_0xFF
	CALL SUBOPT_0x11C
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x3F3
; 0000 1B2C                         {
; 0000 1B2D                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 1B2E                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x11D
; 0000 1B2F                         }
; 0000 1B30 
; 0000 1B31 
; 0000 1B32                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3F3:
	CALL SUBOPT_0x102
	CALL SUBOPT_0x119
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x74
	AND  R30,R0
	BREQ _0x3F4
; 0000 1B33                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x11F
; 0000 1B34 
; 0000 1B35                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3F4:
	CALL SUBOPT_0xFF
	CALL SUBOPT_0x73
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x74
	AND  R30,R0
	BREQ _0x3F5
; 0000 1B36                         {
; 0000 1B37                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 1B38                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x120
; 0000 1B39                         }
; 0000 1B3A 
; 0000 1B3B                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3F5:
	CALL SUBOPT_0x73
	CALL SUBOPT_0x121
	AND  R30,R0
	BREQ _0x3F6
; 0000 1B3C                         {
; 0000 1B3D                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 1B3E                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x122
; 0000 1B3F                         }
; 0000 1B40 
; 0000 1B41                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1B42                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x3F6:
	CALL SUBOPT_0x102
	CALL SUBOPT_0x123
	BREQ _0x3F7
; 0000 1B43                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x124
; 0000 1B44 
; 0000 1B45 
; 0000 1B46                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x3F7:
	CALL SUBOPT_0xFF
	CALL SUBOPT_0x125
	BREQ _0x3F8
; 0000 1B47                         {
; 0000 1B48                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 1B49                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x126
; 0000 1B4A                         }
; 0000 1B4B 
; 0000 1B4C                     if(cykl_sterownik_3 < 5 & wykonalem_komplet_okregow == 3)
_0x3F8:
	CALL SUBOPT_0x141
	CALL SUBOPT_0x11C
	CALL SUBOPT_0x137
	BREQ _0x3F9
; 0000 1B4D                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV         //tu zmienienie INV, ¿eby szed³ w dol
	CALL SUBOPT_0x75
	CALL SUBOPT_0xCB
; 0000 1B4E 
; 0000 1B4F                      if(cykl_sterownik_3 == 5 & wykonalem_komplet_okregow == 3)
_0x3F9:
	CALL SUBOPT_0x130
	CALL SUBOPT_0x11C
	CALL SUBOPT_0x137
	BREQ _0x3FA
; 0000 1B50                         {
; 0000 1B51                         krazek_scierny_cykl_po_okregu = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x111
; 0000 1B52                         krazek_scierny_cykl++;
	LDI  R26,LOW(_krazek_scierny_cykl)
	LDI  R27,HIGH(_krazek_scierny_cykl)
	CALL SUBOPT_0x142
; 0000 1B53 
; 0000 1B54                         if(krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x93
	CALL SUBOPT_0x131
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x3FB
; 0000 1B55                             {
; 0000 1B56                             wykonalem_komplet_okregow = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
; 0000 1B57                             }
; 0000 1B58                         else
	RJMP _0x3FC
_0x3FB:
; 0000 1B59                             wykonalem_komplet_okregow = 0;
	CALL SUBOPT_0x10F
; 0000 1B5A 
; 0000 1B5B                         cykl_sterownik_1 = 0;
_0x3FC:
	CALL SUBOPT_0xF2
; 0000 1B5C                         cykl_sterownik_3 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x107
; 0000 1B5D                         }
; 0000 1B5E 
; 0000 1B5F 
; 0000 1B60 
; 0000 1B61 
; 0000 1B62 
; 0000 1B63                     if(koniec_rzedu_10 == 1)
_0x3FA:
	CALL SUBOPT_0x104
	SBIW R26,1
	BRNE _0x3FD
; 0000 1B64                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x108
; 0000 1B65                                                               //to nowy war, ostatni dzien w borg
; 0000 1B66                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze & koniec_rzedu_10 == 0)
_0x3FD:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0x127
	CALL SUBOPT_0xA3
	CALL SUBOPT_0x128
	AND  R0,R30
	CALL SUBOPT_0xF8
	CALL SUBOPT_0x143
	AND  R30,R0
	BREQ _0x3FE
; 0000 1B67                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x72
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC0
; 0000 1B68 
; 0000 1B69                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x3FE:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFA
	CALL SUBOPT_0x129
	CALL SUBOPT_0x12A
	CALL SUBOPT_0x143
	AND  R30,R0
	BREQ _0x3FF
; 0000 1B6A                         {
; 0000 1B6B                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x12B
	BRNE _0x400
; 0000 1B6C                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xF6
; 0000 1B6D                         if(abs_ster4 == 0)
_0x400:
	CALL SUBOPT_0x12C
	BRNE _0x401
; 0000 1B6E                             {
; 0000 1B6F                             szczotka_druc_cykl++;
	CALL SUBOPT_0xFB
; 0000 1B70                             abs_ster4 = 1;
	CALL SUBOPT_0x12D
; 0000 1B71                             }
; 0000 1B72                         else
	RJMP _0x402
_0x401:
; 0000 1B73                             {
; 0000 1B74                             abs_ster4 = 0;
	CALL SUBOPT_0x116
; 0000 1B75                             sek13 = 0;
	CALL SUBOPT_0xF7
; 0000 1B76                             }
_0x402:
; 0000 1B77                         }
; 0000 1B78 
; 0000 1B79 
; 0000 1B7A                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x3FF:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0x127
	CALL SUBOPT_0x74
	CALL SUBOPT_0x128
	CALL SUBOPT_0x143
	AND  R30,R0
	BREQ _0x403
; 0000 1B7B                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory
	CALL SUBOPT_0x134
	CALL SUBOPT_0xC0
; 0000 1B7C 
; 0000 1B7D 
; 0000 1B7E                         ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1B7F 
; 0000 1B80                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x403:
	CALL SUBOPT_0x130
	CALL SUBOPT_0x93
	CALL SUBOPT_0x135
	CALL SUBOPT_0x90
	CALL SUBOPT_0x136
	AND  R30,R0
	BREQ _0x404
; 0000 1B81                        {
; 0000 1B82                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x138
; 0000 1B83                        powrot_przedwczesny_krazek_scierny = 1;
; 0000 1B84                        }
; 0000 1B85                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x404:
	CALL SUBOPT_0x139
	CALL SUBOPT_0x109
	CALL __LTW12
	AND  R30,R0
	BREQ _0x405
; 0000 1B86                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x13A
; 0000 1B87 
; 0000 1B88                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x405:
	CALL SUBOPT_0x130
	CALL SUBOPT_0x139
	AND  R30,R0
	BREQ _0x406
; 0000 1B89                        {
; 0000 1B8A                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x13B
; 0000 1B8B                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
; 0000 1B8C                        }
; 0000 1B8D                    //////////////////////////////////////////////
; 0000 1B8E 
; 0000 1B8F 
; 0000 1B90 
; 0000 1B91                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1B92 
; 0000 1B93                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
_0x406:
	CALL SUBOPT_0x144
	MOV  R0,R30
	CALL SUBOPT_0xEE
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x90
	CALL SUBOPT_0xFC
	MOV  R1,R30
	CALL SUBOPT_0x11C
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	MOV  R0,R30
	CALL SUBOPT_0x93
	CALL SUBOPT_0x131
	CALL __NEW12
	OR   R30,R0
	AND  R30,R1
	BREQ _0x409
; 0000 1B94                        {
; 0000 1B95                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1B96                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0xF6
; 0000 1B97                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x13D
; 0000 1B98                        }
; 0000 1B99                   if(koniec_rzedu_10 == 0 & powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x409:
	CALL SUBOPT_0x144
	MOV  R0,R30
	CALL SUBOPT_0x13E
	AND  R0,R30
	CALL SUBOPT_0xEE
	CALL __LTW12
	AND  R30,R0
	BREQ _0x40C
; 0000 1B9A                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xF0
	CALL SUBOPT_0xC0
; 0000 1B9B 
; 0000 1B9C                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x40C:
	CALL SUBOPT_0x144
	MOV  R0,R30
	CALL SUBOPT_0xEE
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x13E
	AND  R30,R0
	BREQ _0x40D
; 0000 1B9D                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x114
; 0000 1B9E                    //////////////////////////////////////////////
; 0000 1B9F 
; 0000 1BA0                     if((wykonalem_komplet_okregow == 4 &
_0x40D:
; 0000 1BA1                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 1BA2                         cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0 & powrot_przedwczesny_krazek_scierny == 0) | (wykonalem_komplet_okregow == 4 & koniec_rzedu_10 == 1 & powrot_przedwczesny_krazek_scierny == 0) )
	CALL SUBOPT_0x11C
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	MOV  R22,R30
	MOV  R0,R30
	CALL SUBOPT_0x90
	CALL SUBOPT_0x13C
	AND  R0,R30
	CALL SUBOPT_0xEE
	CALL __EQW12
	CALL SUBOPT_0x128
	CALL SUBOPT_0x12F
	AND  R30,R0
	MOV  R1,R30
	MOV  R0,R22
	CALL SUBOPT_0x106
	CALL SUBOPT_0x12F
	AND  R30,R0
	OR   R30,R1
	BREQ _0x40E
; 0000 1BA3                         {
; 0000 1BA4                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x114
; 0000 1BA5                         powrot_przedwczesny_krazek_scierny = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x113
; 0000 1BA6                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 1BA7                         cykl_sterownik_2 = 0;
; 0000 1BA8                         cykl_sterownik_3 = 0;
; 0000 1BA9                         cykl_sterownik_4 = 0;
; 0000 1BAA                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x110
; 0000 1BAB                         krazek_scierny_cykl = 0;
	CALL SUBOPT_0x112
; 0000 1BAC                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x111
; 0000 1BAD                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0x118
; 0000 1BAE                         PORTF = PORT_F.byte;
; 0000 1BAF                         PORTE.2 = 0;  //wylacz szlifierke
	CALL SUBOPT_0x140
; 0000 1BB0                         cykl_glowny = 9;
; 0000 1BB1                         }
; 0000 1BB2 
; 0000 1BB3                                                                                                 //ster 1 - ruch po okregu
; 0000 1BB4                                                                                                 //ster 2 - nic
; 0000 1BB5                                                                                                 //ster 3 - krazek - gora dol
; 0000 1BB6                                                                                                 //ster 4 - druciak - gora dol
; 0000 1BB7 
; 0000 1BB8             break;
_0x40E:
	RJMP _0x35B
; 0000 1BB9 
; 0000 1BBA 
; 0000 1BBB             case 9:                                          //cykl 3 == 5
_0x3EF:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x411
; 0000 1BBC 
; 0000 1BBD 
; 0000 1BBE                          if(rzad_obrabiany == 1)
	CALL SUBOPT_0x8D
	SBIW R26,1
	BRNE _0x412
; 0000 1BBF                          {
; 0000 1BC0                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)    //////
	CALL SUBOPT_0x141
	CALL SUBOPT_0x10A
	AND  R30,R0
	BREQ _0x413
; 0000 1BC1                               cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x13A
; 0000 1BC2 
; 0000 1BC3 
; 0000 1BC4                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_1 - 2)
_0x413:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0x145
	CALL __LTW12
	AND  R30,R0
	BREQ _0x414
; 0000 1BC5                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xF0
	CALL SUBOPT_0xC0
; 0000 1BC6 
; 0000 1BC7 
; 0000 1BC8                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)       //2 marca 2019 wykomentowuje ////////
_0x414:
	CALL SUBOPT_0x141
	CALL SUBOPT_0x146
	CALL __EQW12
	AND  R30,R0
	BREQ _0x415
; 0000 1BC9                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xBE
; 0000 1BCA 
; 0000 1BCB 
; 0000 1BCC                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_1 - 2)
_0x415:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0x145
	CALL __GEW12
	AND  R30,R0
	BREQ _0x416
; 0000 1BCD                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x7F
	CALL SUBOPT_0xC0
; 0000 1BCE 
; 0000 1BCF                           }
_0x416:
; 0000 1BD0 
; 0000 1BD1 
; 0000 1BD2                          if(rzad_obrabiany == 2)
_0x412:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x417
; 0000 1BD3                          {
; 0000 1BD4                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
	CALL SUBOPT_0x141
	CALL SUBOPT_0x10B
	AND  R30,R0
	BREQ _0x418
; 0000 1BD5                             cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x13A
; 0000 1BD6 
; 0000 1BD7                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_2 - 2)
_0x418:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0x147
	CALL __LTW12
	AND  R30,R0
	BREQ _0x419
; 0000 1BD8                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xF0
	CALL SUBOPT_0xC0
; 0000 1BD9 
; 0000 1BDA                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x419:
	CALL SUBOPT_0x141
	CALL SUBOPT_0x148
	CALL __EQW12
	AND  R30,R0
	BREQ _0x41A
; 0000 1BDB                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xBE
; 0000 1BDC 
; 0000 1BDD                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_2 - 2)
_0x41A:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0x147
	CALL __GEW12
	AND  R30,R0
	BREQ _0x41B
; 0000 1BDE                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x7F
	CALL SUBOPT_0xC0
; 0000 1BDF 
; 0000 1BE0                            if(rzad_obrabiany == 2)
_0x41B:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x41C
; 0000 1BE1                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1BE2 
; 0000 1BE3                           }
_0x41C:
; 0000 1BE4 
; 0000 1BE5 
; 0000 1BE6                           if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x417:
	CALL SUBOPT_0xC1
	BREQ _0x41D
; 0000 1BE7                             {
; 0000 1BE8                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1BE9                             PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1BEA                             //PORTB.6 = 0;  //wylacz przedmuchy
; 0000 1BEB                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xF6
; 0000 1BEC                             cykl_sterownik_3 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x107
; 0000 1BED                             cykl_ilosc_zaciskow++;
	LDI  R26,LOW(_cykl_ilosc_zaciskow)
	LDI  R27,HIGH(_cykl_ilosc_zaciskow)
	CALL SUBOPT_0x142
; 0000 1BEE                             ruch_zlozony = 2;                       //il_zaciskow_rzad_1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 1BEF                             cykl_glowny = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0xEB
; 0000 1BF0                             }
; 0000 1BF1 
; 0000 1BF2 
; 0000 1BF3             break;
_0x41D:
	RJMP _0x35B
; 0000 1BF4 
; 0000 1BF5 
; 0000 1BF6 
; 0000 1BF7             case 10:
_0x411:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x422
; 0000 1BF8 
; 0000 1BF9                                                //wywali ten warunek jak zadziala
; 0000 1BFA                      if(rzad_obrabiany == 1 & cykl_glowny != 0)
	CALL SUBOPT_0xED
	CALL SUBOPT_0x149
	BREQ _0x423
; 0000 1BFB                             {
; 0000 1BFC                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,96);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x14A
	CALL SUBOPT_0x29
	CALL _wartosc_parametru_panelu
; 0000 1BFD                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_1 - 1)
	CALL SUBOPT_0x146
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x424
; 0000 1BFE                                 {
; 0000 1BFF                                 cykl_glowny = 5;
	CALL SUBOPT_0xFD
; 0000 1C00                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0xEA
; 0000 1C01                                 }
; 0000 1C02 
; 0000 1C03                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
_0x424:
	CALL SUBOPT_0x146
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x425
; 0000 1C04                                 {
; 0000 1C05                                 cykl_glowny = 5;
	CALL SUBOPT_0xFD
; 0000 1C06                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x14B
; 0000 1C07                                 }
; 0000 1C08 
; 0000 1C09                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 == 10)
_0x425:
	CALL SUBOPT_0x14C
	CALL __EQW12
	AND  R30,R0
	BREQ _0x426
; 0000 1C0A                                 {
; 0000 1C0B                                 cykl_glowny = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0xEB
; 0000 1C0C                                 }
; 0000 1C0D 
; 0000 1C0E                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 != 10)  /////zmieniam + 1 20.02
_0x426:
	CALL SUBOPT_0x14C
	CALL __NEW12
	AND  R30,R0
	BREQ _0x427
; 0000 1C0F                                 {
; 0000 1C10                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0xEB
; 0000 1C11                                 }
; 0000 1C12                             }
_0x427:
; 0000 1C13 
; 0000 1C14 
; 0000 1C15                              if(rzad_obrabiany == 2)
_0x423:
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x428
; 0000 1C16                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1C17 
; 0000 1C18                             if(rzad_obrabiany == 2 & cykl_glowny != 0)
_0x428:
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x149
	BREQ _0x429
; 0000 1C19                             {
; 0000 1C1A                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,16);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x14A
	CALL SUBOPT_0x26
	CALL _wartosc_parametru_panelu
; 0000 1C1B                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_2 - 1)
	CALL SUBOPT_0x148
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x42A
; 0000 1C1C                                 {
; 0000 1C1D                                 cykl_glowny = 5;
	CALL SUBOPT_0xFD
; 0000 1C1E                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0xEA
; 0000 1C1F                                 }
; 0000 1C20 
; 0000 1C21                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x42A:
	CALL SUBOPT_0x148
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x42B
; 0000 1C22                                 {
; 0000 1C23                                 cykl_glowny = 5;
	CALL SUBOPT_0xFD
; 0000 1C24                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x14B
; 0000 1C25                                 }
; 0000 1C26 
; 0000 1C27                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 == 10)
_0x42B:
	CALL SUBOPT_0x14D
	CALL __EQW12
	AND  R30,R0
	BREQ _0x42C
; 0000 1C28                                 {
; 0000 1C29                                 cykl_glowny = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0xEB
; 0000 1C2A                                 }
; 0000 1C2B 
; 0000 1C2C 
; 0000 1C2D                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 != 10)   ///////////////////zmieniam + 1 20.02
_0x42C:
	CALL SUBOPT_0x14D
	CALL __NEW12
	AND  R30,R0
	BREQ _0x42D
; 0000 1C2E                                 {
; 0000 1C2F                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0xEB
; 0000 1C30                                 }
; 0000 1C31                             }
_0x42D:
; 0000 1C32 
; 0000 1C33 
; 0000 1C34 
; 0000 1C35             break;
_0x429:
	RJMP _0x35B
; 0000 1C36 
; 0000 1C37 
; 0000 1C38 
; 0000 1C39             case 11:
_0x422:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x42E
; 0000 1C3A 
; 0000 1C3B                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x42F
; 0000 1C3C                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1C3D 
; 0000 1C3E                              //ster 1 ucieka od szafy
; 0000 1C3F                              if(cykl_sterownik_1 < 5)
_0x42F:
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x430
; 0000 1C40                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x11B
; 0000 1C41 
; 0000 1C42                              if(cykl_sterownik_2 < 5)
_0x430:
	CALL SUBOPT_0xC5
	SBIW R26,5
	BRGE _0x431
; 0000 1C43                                     cykl_sterownik_2 = sterownik_2_praca(0x190);     //pod dolek ostatni 10 do przedmuchu rzad 1
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0x105
; 0000 1C44 
; 0000 1C45                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x431:
	CALL SUBOPT_0xC8
	BREQ _0x432
; 0000 1C46                                     {
; 0000 1C47                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x10E
; 0000 1C48                                     PORTF = PORT_F.byte;
; 0000 1C49                                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 1C4A                                     sek12 = 0;
	CALL SUBOPT_0x10D
; 0000 1C4B                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 1C4C                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x14E
; 0000 1C4D                                     cykl_glowny = 13;
; 0000 1C4E                                     }
; 0000 1C4F             break;
_0x432:
	RJMP _0x35B
; 0000 1C50 
; 0000 1C51 
; 0000 1C52             case 12:
_0x42E:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x435
; 0000 1C53 
; 0000 1C54                              if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x436
; 0000 1C55                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1C56 
; 0000 1C57                                //ster 1 ucieka od szafy
; 0000 1C58                              if(cykl_sterownik_1 < 5)
_0x436:
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x437
; 0000 1C59                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x11B
; 0000 1C5A 
; 0000 1C5B                             if(cykl_sterownik_2 < 5)
_0x437:
	CALL SUBOPT_0xC5
	SBIW R26,5
	BRGE _0x438
; 0000 1C5C                                     cykl_sterownik_2 = sterownik_2_praca(0x191);     //pod dolek ostatni 10 do przedmuchu rzad 2
	LDI  R30,LOW(401)
	LDI  R31,HIGH(401)
	CALL SUBOPT_0x105
; 0000 1C5D 
; 0000 1C5E                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x438:
	CALL SUBOPT_0xC8
	BREQ _0x439
; 0000 1C5F                                     {
; 0000 1C60                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x10E
; 0000 1C61                                     PORTF = PORT_F.byte;
; 0000 1C62                                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 1C63                                     sek12 = 0;
	CALL SUBOPT_0x10D
; 0000 1C64                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 1C65                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x14E
; 0000 1C66                                     cykl_glowny = 13;
; 0000 1C67                                     }
; 0000 1C68 
; 0000 1C69 
; 0000 1C6A             break;
_0x439:
	RJMP _0x35B
; 0000 1C6B 
; 0000 1C6C 
; 0000 1C6D 
; 0000 1C6E             case 13:
_0x435:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x43C
; 0000 1C6F 
; 0000 1C70 
; 0000 1C71                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x43D
; 0000 1C72                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1C73 
; 0000 1C74 
; 0000 1C75                             if(sek12 > czas_przedmuchu)
_0x43D:
	CALL SUBOPT_0x117
	BRGE _0x43E
; 0000 1C76                                         {
; 0000 1C77                                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0x118
; 0000 1C78                                         PORTF = PORT_F.byte;
; 0000 1C79                                         PORTE.5 = 0;
	CBI  0x3,5
; 0000 1C7A                                         }
; 0000 1C7B 
; 0000 1C7C                              if(cykl_sterownik_2 < 5)
_0x43E:
	CALL SUBOPT_0xC5
	SBIW R26,5
	BRGE _0x441
; 0000 1C7D                                     cykl_sterownik_2 = sterownik_2_praca(0x192);     //okrag
	LDI  R30,LOW(402)
	LDI  R31,HIGH(402)
	CALL SUBOPT_0x105
; 0000 1C7E                              if(cykl_sterownik_2 == 5)
_0x441:
	CALL SUBOPT_0xC5
	SBIW R26,5
	BRNE _0x442
; 0000 1C7F                                     {
; 0000 1C80                                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x117
	BRGE _0x443
; 0000 1C81                                         {
; 0000 1C82                                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0x118
; 0000 1C83                                         PORTF = PORT_F.byte;
; 0000 1C84                                         PORTE.5 = 0;
	CBI  0x3,5
; 0000 1C85                                         cykl_sterownik_2 = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
; 0000 1C86                                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0xEB
; 0000 1C87                                         }
; 0000 1C88 
; 0000 1C89                                     }
_0x443:
; 0000 1C8A 
; 0000 1C8B             break;
_0x442:
	RJMP _0x35B
; 0000 1C8C 
; 0000 1C8D 
; 0000 1C8E 
; 0000 1C8F             case 14:
_0x43C:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x446
; 0000 1C90 
; 0000 1C91 
; 0000 1C92                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x447
; 0000 1C93                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1C94 
; 0000 1C95                     if(cykl_sterownik_1 < 5)
_0x447:
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x448
; 0000 1C96                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek zeby przedmuchac
	CALL SUBOPT_0xD6
; 0000 1C97                     if(cykl_sterownik_1 == 5)
_0x448:
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRNE _0x449
; 0000 1C98                         {
; 0000 1C99                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF2
; 0000 1C9A                         sek12 = 0;
	CALL SUBOPT_0x10D
; 0000 1C9B                         cykl_glowny = 15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0xEB
; 0000 1C9C                         }
; 0000 1C9D 
; 0000 1C9E             break;
_0x449:
	RJMP _0x35B
; 0000 1C9F 
; 0000 1CA0 
; 0000 1CA1 
; 0000 1CA2             case 15:
_0x446:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x44A
; 0000 1CA3 
; 0000 1CA4                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x8D
	SBIW R26,2
	BRNE _0x44B
; 0000 1CA5                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1CA6 
; 0000 1CA7 
; 0000 1CA8                     if(start == 1)
_0x44B:
	CALL SUBOPT_0xA7
	BRNE _0x44C
; 0000 1CA9                         {
; 0000 1CAA                         obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xA8
; 0000 1CAB                         obsluga_nacisniecia_zatrzymaj();
; 0000 1CAC                         }
; 0000 1CAD 
; 0000 1CAE                     //przedmuch
; 0000 1CAF                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
_0x44C:
	CALL SUBOPT_0x10E
; 0000 1CB0                     PORTF = PORT_F.byte;
; 0000 1CB1                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x117
	BRGE _0x44D
; 0000 1CB2                         {
; 0000 1CB3                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x118
; 0000 1CB4                         PORTF = PORT_F.byte;
; 0000 1CB5                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0xEB
; 0000 1CB6                         }
; 0000 1CB7             break;
_0x44D:
	RJMP _0x35B
; 0000 1CB8 
; 0000 1CB9 
; 0000 1CBA             case 16:
_0x44A:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x44E
; 0000 1CBB 
; 0000 1CBC                      if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & wykonalem_rzedow == 0)  /////zmieniam + 1 20.02
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	CALL SUBOPT_0x10C
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x14F
	CALL SUBOPT_0xA3
	AND  R30,R0
	BREQ _0x44F
; 0000 1CBD                                 {
; 0000 1CBE                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0xE7
; 0000 1CBF                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1CC0                                 if(il_zaciskow_rzad_2 > 0)
	CALL SUBOPT_0xD7
	CALL __CPW02
	BRGE _0x452
; 0000 1CC1                                     {
; 0000 1CC2 
; 0000 1CC3                                     rzad_obrabiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
; 0000 1CC4                                     wybor_linijek_sterownikow(2);  //rzad 2
	CALL SUBOPT_0xDA
; 0000 1CC5                                     cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 1CC6                                     }
; 0000 1CC7                                 else
	RJMP _0x453
_0x452:
; 0000 1CC8                                     cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0xEB
; 0000 1CC9 
; 0000 1CCA                                 wykonalem_rzedow = 1;
_0x453:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 1CCB                                 }
; 0000 1CCC 
; 0000 1CCD                        if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 1)   ///////////////////zmieniam + 1 20.02
_0x44F:
	CALL SUBOPT_0xE9
	CALL SUBOPT_0x10C
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0xE8
	AND  R0,R30
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x74
	AND  R30,R0
	BREQ _0x454
; 0000 1CCE                                 {
; 0000 1CCF                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1CD0                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0xE7
; 0000 1CD1                                 cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0xEB
; 0000 1CD2                                 rzad_obrabiany = 1;
	CALL SUBOPT_0xE5
; 0000 1CD3                                 wykonalem_rzedow = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 1CD4                                 }
; 0000 1CD5 
; 0000 1CD6 
; 0000 1CD7 
; 0000 1CD8 
; 0000 1CD9                         if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 2)
_0x454:
	CALL SUBOPT_0x150
	MOV  R0,R30
	CALL SUBOPT_0xE8
	AND  R0,R30
	CALL SUBOPT_0x14F
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x457
; 0000 1CDA                                   {
; 0000 1CDB                                   rzad_obrabiany = 1;
	CALL SUBOPT_0xE5
; 0000 1CDC                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0xE6
; 0000 1CDD                                   PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1CDE                                   //PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1 - tego na razie nie poki nie ma oslon
; 0000 1CDF                                   //PORTB.6 = 0;   ////zielona lampka
; 0000 1CE0                                   //wartosc_parametru_panelu(0,0,64);
; 0000 1CE1                                   }
; 0000 1CE2 
; 0000 1CE3                             if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 == 0 & wykonalem_rzedow == 1)
_0x457:
	CALL SUBOPT_0x150
	MOV  R0,R30
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xA3
	AND  R0,R30
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x74
	AND  R30,R0
	BREQ _0x45A
; 0000 1CE4                                   {
; 0000 1CE5                                   rzad_obrabiany = 1;
	CALL SUBOPT_0xE5
; 0000 1CE6                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0xE6
; 0000 1CE7                                   //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
; 0000 1CE8                                   }
; 0000 1CE9 
; 0000 1CEA 
; 0000 1CEB 
; 0000 1CEC             break;
_0x45A:
	RJMP _0x35B
; 0000 1CED 
; 0000 1CEE 
; 0000 1CEF             case 17:
_0x44E:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x35B
; 0000 1CF0 
; 0000 1CF1 
; 0000 1CF2                                  if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xC3
	SBIW R26,5
	BRGE _0x45C
; 0000 1CF3                                     cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xC4
; 0000 1CF4                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x45C:
	CALL SUBOPT_0xC5
	SBIW R26,5
	BRGE _0x45D
; 0000 1CF5                                     cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xC7
; 0000 1CF6 
; 0000 1CF7                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x45D:
	CALL SUBOPT_0xC8
	BREQ _0x45E
; 0000 1CF8                                         {
; 0000 1CF9                                         PORTB.6 = 0;   ////zielona lampka
	CBI  0x18,6
; 0000 1CFA                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xC9
; 0000 1CFB                                         cykl_sterownik_2 = 0;
; 0000 1CFC                                         cykl_sterownik_3 = 0;
; 0000 1CFD                                         cykl_sterownik_4 = 0;
; 0000 1CFE                                         jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 1CFF                                         PORTB.6 = 0;
	CBI  0x18,6
; 0000 1D00                                         macierz_zaciskow[1]=0;
	__POINTW1MN _macierz_zaciskow,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1D01                                         macierz_zaciskow[2]=0;
	__POINTW1MN _macierz_zaciskow,4
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1D02                                         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 1D03                                         komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",adr1,adr2);
	__POINTW1FN _0x0,1895
	CALL SUBOPT_0x37
; 0000 1D04                                         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x85
; 0000 1D05                                         komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",adr3,adr4);
	__POINTW1FN _0x0,1895
	CALL SUBOPT_0x86
; 0000 1D06                                         wartosc_parametru_panelu(0,0,64);
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x92
; 0000 1D07                                         start = 0;
	CALL SUBOPT_0xA1
; 0000 1D08                                         cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 1D09                                         }
; 0000 1D0A 
; 0000 1D0B 
; 0000 1D0C 
; 0000 1D0D 
; 0000 1D0E             break;
_0x45E:
; 0000 1D0F 
; 0000 1D10 
; 0000 1D11 
; 0000 1D12             }//switch
_0x35B:
; 0000 1D13 
; 0000 1D14 
; 0000 1D15   }//while
	JMP  _0x356
_0x358:
; 0000 1D16 }//while glowny
	JMP  _0x353
; 0000 1D17 
; 0000 1D18 }//koniec
_0x463:
	RJMP _0x463
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
	CALL SUBOPT_0x142
	ADIW R28,3
	RET
__print_G103:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x36
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
	CALL SUBOPT_0x151
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x151
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
	CALL SUBOPT_0x152
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x153
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x152
	CALL SUBOPT_0x154
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x152
	CALL SUBOPT_0x154
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
	CALL SUBOPT_0x152
	CALL SUBOPT_0x155
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
	CALL SUBOPT_0x152
	CALL SUBOPT_0x155
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
	CALL SUBOPT_0x151
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
	CALL SUBOPT_0x151
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
	CALL SUBOPT_0x153
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x151
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
	CALL SUBOPT_0x153
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
	CALL SUBOPT_0x33
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
_czas_pracy_krazka_sciernego_h:
	.BYTE 0x2
_czas_pracy_szczotki_drucianej_h:
	.BYTE 0x2
_czas_pracy_krazka_sciernego_stala:
	.BYTE 0x2
_czas_pracy_szczotki_drucianej_stala:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 46 TIMES, CODE SIZE REDUCTION:177 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC:
	CALL _wartosc_parametru_panelu
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 154 TIMES, CODE SIZE REDUCTION:609 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(_macierz_zaciskow)
	LDI  R27,HIGH(_macierz_zaciskow)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0xF:
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
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 83 TIMES, CODE SIZE REDUCTION:161 WORDS
SUBOPT_0x11:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x13:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x15:
	MOVW R26,R30
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL __GEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	CALL __EEPROMRDW
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:195 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(_PORTMM)
	LDI  R31,HIGH(_PORTMM)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1B:
	CALL _sprawdz_pin0
	LDI  R26,LOW(0)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1C:
	CALL _sprawdz_pin1
	LDI  R26,LOW(0)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 103 TIMES, CODE SIZE REDUCTION:201 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	STS  _il_zaciskow_rzad_1,R30
	STS  _il_zaciskow_rzad_1+1,R31
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	CALL _odczytaj_parametr
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	CALL __EEPROMWRW
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	CALL _odczytaj_parametr
	LDI  R26,LOW(_krazek_scierny_ilosc_cykli)
	LDI  R27,HIGH(_krazek_scierny_ilosc_cykli)
	CALL __EEPROMWRW
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	CALL _odczytaj_parametr
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu_ilosc)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu_ilosc)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	STS  _srednica_krazka_sciernego,R30
	STS  _srednica_krazka_sciernego+1,R31
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	CALL _odczytaj_parametr
	STS  _ruch_haos,R30
	STS  _ruch_haos+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(_PORTJJ)
	LDI  R31,HIGH(_PORTJJ)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:319 WORDS
SUBOPT_0x2D:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr1
	LDS  R31,_adr1+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr2
	LDS  R31,_adr2+1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:207 WORDS
SUBOPT_0x2E:
	LDS  R30,_adr1
	LDS  R31,_adr1+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr2
	LDS  R31,_adr2+1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x2F:
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
SUBOPT_0x30:
	OR   R30,R0
	STS  _PORT_CZYTNIK,R30
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 145 TIMES, CODE SIZE REDUCTION:285 WORDS
SUBOPT_0x33:
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 69 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_z_czytnika_kodow

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x35:
	ST   X+,R30
	ST   X,R31
	MOVW R30,R16
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x37:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 136 TIMES, CODE SIZE REDUCTION:537 WORDS
SUBOPT_0x38:
	STS  _a,R30
	STS  _a+1,R31
	__POINTW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 106 TIMES, CODE SIZE REDUCTION:417 WORDS
SUBOPT_0x39:
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x3A:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x3B:
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3C:
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
SUBOPT_0x3D:
	__POINTW1MN _a,18
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3E:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x3F:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x40:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x41:
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x42:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x43:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x45:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x46:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x47:
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
SUBOPT_0x48:
	LDI  R26,LOW(29)
	LDI  R27,HIGH(29)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x49:
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x4A:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4B:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4C:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4D:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4E:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x4F:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RJMP SUBOPT_0x4A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x50:
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
SUBOPT_0x51:
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x52:
	__POINTW1MN _a,8
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:186 WORDS
SUBOPT_0x53:
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
	RJMP SUBOPT_0x41

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x54:
	LDI  R26,LOW(27)
	LDI  R27,HIGH(27)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x55:
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
SUBOPT_0x56:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x57:
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x58:
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x59:
	LDI  R26,LOW(22)
	LDI  R27,HIGH(22)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5A:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x5B:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5C:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5D:
	LDI  R26,LOW(20)
	LDI  R27,HIGH(20)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x5E:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5F:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	LDI  R26,LOW(36)
	LDI  R27,HIGH(36)
	RJMP SUBOPT_0x5E

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x60:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	RJMP SUBOPT_0x5E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x62:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x63:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP SUBOPT_0x5E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x64:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	RJMP SUBOPT_0x5E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x65:
	__POINTW1MN _a,8
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x66:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x63

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x67:
	__POINTW1MN _a,8
	LDI  R26,LOW(23)
	LDI  R27,HIGH(23)
	RJMP SUBOPT_0x5E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x68:
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x69:
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6A:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6B:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	RJMP SUBOPT_0x5E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6C:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x61

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6D:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6E:
	LDS  R30,_a
	LDS  R31,_a+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6F:
	__GETW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x70:
	__GETW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x71:
	ADIW R30,1
	__PUTW1MN _a,12
	__GETW1MN _a,12
	ADIW R30,1
	__PUTW1MN _a,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x72:
	__GETW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x73:
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu_ilosc)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu_ilosc)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 64 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x74:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x75:
	__GETW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x76:
	LDS  R26,_srednica_krazka_sciernego
	LDS  R27,_srednica_krazka_sciernego+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x77:
	__GETW1MN _a,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x78:
	LDS  R26,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R27,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x79:
	MOV  R0,R30
	RCALL SUBOPT_0x76
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
	RJMP SUBOPT_0x70

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
	RCALL SUBOPT_0x76
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x7F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x80:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	SBI  0x12,7
	RET

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:235 WORDS
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
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:153 WORDS
SUBOPT_0x86:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	RJMP SUBOPT_0x11

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x8D:
	LDS  R26,_rzad_obrabiany
	LDS  R27,_rzad_obrabiany+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8E:
	MOV  R0,R30
	LDS  R26,_start
	LDS  R27,_start+1
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x8F:
	RCALL SUBOPT_0x8D
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x90:
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x91:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x92:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x93:
	LDI  R26,LOW(_krazek_scierny_ilosc_cykli)
	LDI  R27,HIGH(_krazek_scierny_ilosc_cykli)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x94:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x95:
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x96:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x97:
	CALL _sprawdz_pin0
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x98:
	CALL _sprawdz_pin1
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x99:
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
SUBOPT_0x9A:
	CALL _sprawdz_pin3
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9B:
	CALL _sprawdz_pin7
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9C:
	SBI  0x12,7
	CBI  0x18,6
	CBI  0x18,4
	CBI  0x12,2
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9D:
	__POINTW1FN _0x0,1524
	RJMP SUBOPT_0x86

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9E:
	CALL _sprawdz_pin6
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x9F:
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
SUBOPT_0xA0:
	CALL _sprawdz_pin5
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA1:
	LDI  R30,LOW(0)
	STS  _start,R30
	STS  _start+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA2:
	AND  R30,R26
	MOV  R0,R30
	LDS  R26,_czekaj_az_puszcze
	LDS  R27,_czekaj_az_puszcze+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 61 TIMES, CODE SIZE REDUCTION:117 WORDS
SUBOPT_0xA3:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA4:
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
SUBOPT_0xA5:
	LDI  R30,LOW(0)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA6:
	LDI  R30,LOW(0)
	STS  _sek11,R30
	STS  _sek11+1,R30
	STS  _sek11+2,R30
	STS  _sek11+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA7:
	LDS  R26,_start
	LDS  R27,_start+1
	SBIW R26,1
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:77 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:59 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xB8:
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
SUBOPT_0xB9:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __GTW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xBA:
	__GETW1MN _macierz_zaciskow,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xBB:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wybor_linijek_sterownikow

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xBC:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 54 TIMES, CODE SIZE REDUCTION:103 WORDS
SUBOPT_0xBD:
	LDS  R26,_cykl_sterownik_3
	LDS  R27,_cykl_sterownik_3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0xBE:
	CALL _sterownik_3_praca
	RJMP SUBOPT_0xB1

;OPTIMIZER ADDED SUBROUTINE, CALLED 54 TIMES, CODE SIZE REDUCTION:103 WORDS
SUBOPT_0xBF:
	LDS  R26,_cykl_sterownik_4
	LDS  R27,_cykl_sterownik_4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0xC0:
	CALL _sterownik_4_praca
	RJMP SUBOPT_0xB4

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0xC1:
	RCALL SUBOPT_0xBD
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0xBF
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:229 WORDS
SUBOPT_0xC2:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 47 TIMES, CODE SIZE REDUCTION:89 WORDS
SUBOPT_0xC3:
	LDS  R26,_cykl_sterownik_1
	LDS  R27,_cykl_sterownik_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0xC4:
	CALL _sterownik_1_praca
	RJMP SUBOPT_0xAB

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xC5:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC6:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xC7:
	CALL _sterownik_2_praca
	RJMP SUBOPT_0xAD

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0xC8:
	RCALL SUBOPT_0xC3
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0xC5
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:197 WORDS
SUBOPT_0xC9:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	RJMP SUBOPT_0xC2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCA:
	RCALL SUBOPT_0x6E
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xCB:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xBE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xCC:
	MOVW R26,R18
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x13

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
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xCF:
	MOVW R26,R18
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD0:
	MOVW R26,R18
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD1:
	MOVW R26,R18
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD2:
	MOVW R26,R18
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD3:
	MOVW R26,R18
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD4:
	MOVW R26,R18
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD5:
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD6:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xC4

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xD7:
	LDS  R26,_il_zaciskow_rzad_2
	LDS  R27,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xD8:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xDE:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xDF:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE0:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE1:
	LDI  R30,LOW(505)
	LDI  R31,HIGH(505)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE2:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE3:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xE4:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE5:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE6:
	LDI  R30,LOW(0)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE7:
	LDI  R30,LOW(0)
	STS  _cykl_ilosc_zaciskow,R30
	STS  _cykl_ilosc_zaciskow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE8:
	RCALL SUBOPT_0xD7
	RJMP SUBOPT_0xD8

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xE9:
	LDS  R30,_il_zaciskow_rzad_2
	LDS  R31,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xEA:
	LDI  R30,LOW(0)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0xEB:
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xEC:
	RCALL SUBOPT_0xC5
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xED:
	RCALL SUBOPT_0x8D
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:59 WORDS
SUBOPT_0xEE:
	RCALL SUBOPT_0xBF
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xEF:
	MOV  R0,R30
	RCALL SUBOPT_0xC5
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0xF1:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0xF2:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xF3:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF4:
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF5:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xDB

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xF6:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xF7:
	LDI  R30,LOW(0)
	STS  _sek13,R30
	STS  _sek13+1,R30
	STS  _sek13+2,R30
	STS  _sek13+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0xF8:
	LDS  R30,_czas_druciaka_na_gorze
	LDS  R31,_czas_druciaka_na_gorze+1
	LDS  R26,_sek13
	LDS  R27,_sek13+1
	LDS  R24,_sek13+2
	LDS  R25,_sek13+3
	CALL __CWD1
	CALL __GTD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF9:
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xFA:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x90

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xFB:
	LDI  R26,LOW(_szczotka_druc_cykl)
	LDI  R27,HIGH(_szczotka_druc_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xFC:
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xFD:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0xEB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xFE:
	RCALL SUBOPT_0xC3
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RJMP SUBOPT_0xA3

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xFF:
	RCALL SUBOPT_0xC3
	RJMP SUBOPT_0xF1

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x100:
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x101:
	RCALL SUBOPT_0xC3
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	RCALL SUBOPT_0x100
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x102:
	RCALL SUBOPT_0xC3
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x103:
	RCALL SUBOPT_0x100
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x104:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x105:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xC7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x106:
	RCALL SUBOPT_0x104
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x107:
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x108:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0xB4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x109:
	MOV  R0,R30
	RCALL SUBOPT_0xBD
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x10A:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10B:
	RCALL SUBOPT_0xE9
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x10C:
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x10D:
	LDI  R30,LOW(0)
	STS  _sek12,R30
	STS  _sek12+1,R30
	STS  _sek12+2,R30
	STS  _sek12+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x10E:
	LDS  R30,_PORT_F
	ORI  R30,0x10
	RJMP SUBOPT_0xAF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10F:
	LDI  R30,LOW(0)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x110:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xF4
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x111:
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x112:
	STS  _krazek_scierny_cykl,R30
	STS  _krazek_scierny_cykl+1,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x113:
	STS  _powrot_przedwczesny_krazek_scierny,R30
	STS  _powrot_przedwczesny_krazek_scierny+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x114:
	LDI  R30,LOW(0)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x115:
	LDI  R30,LOW(0)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x116:
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x117:
	LDS  R30,_czas_przedmuchu
	LDS  R31,_czas_przedmuchu+1
	LDS  R26,_sek12
	LDS  R27,_sek12+1
	LDS  R24,_sek12+2
	LDS  R25,_sek12+3
	CALL __CWD1
	CALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x118:
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	RJMP SUBOPT_0xAF

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x119:
	CALL __LTW12
	MOV  R0,R30
	RJMP SUBOPT_0x73

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x11A:
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x11B:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xC4

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x11C:
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x11E:
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __LTW12
	RJMP SUBOPT_0x11A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11F:
	__GETW1MN _a,12
	RJMP SUBOPT_0x11B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x120:
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x121:
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0x11C
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x122:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x123:
	CALL __LTW12
	MOV  R0,R30
	RCALL SUBOPT_0x11C
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x124:
	__GETW1MN _a,16
	RJMP SUBOPT_0x11B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x125:
	RCALL SUBOPT_0x11C
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x126:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x127:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster4
	LDS  R27,_abs_ster4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x128:
	AND  R0,R30
	LDS  R26,_powrot_przedwczesny_druciak
	LDS  R27,_powrot_przedwczesny_druciak+1
	RJMP SUBOPT_0xA3

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x129:
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12A:
	CALL __LTW12
	RJMP SUBOPT_0x128

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12B:
	LDS  R30,_koniec_rzedu_10
	LDS  R31,_koniec_rzedu_10+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12C:
	LDS  R30,_abs_ster4
	LDS  R31,_abs_ster4+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x12E:
	RCALL SUBOPT_0xBD
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster3
	LDS  R27,_abs_ster3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x12F:
	AND  R0,R30
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0xA3

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x130:
	RCALL SUBOPT_0xBD
	RJMP SUBOPT_0xF1

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x131:
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x132:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x107
	LDS  R30,_abs_ster3
	LDS  R31,_abs_ster3+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x133:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x134:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0xF5

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x135:
	RCALL SUBOPT_0x131
	CALL __EQW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x136:
	RCALL SUBOPT_0x129
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x137:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x138:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x107
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _powrot_przedwczesny_krazek_scierny,R30
	STS  _powrot_przedwczesny_krazek_scierny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x139:
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0xCB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13B:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x113
	CBI  0x3,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13C:
	RCALL SUBOPT_0x129
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x13E:
	LDS  R26,_powrot_przedwczesny_druciak
	LDS  R27,_powrot_przedwczesny_druciak+1
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13F:
	RCALL SUBOPT_0xBD
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R0,R30
	RJMP SUBOPT_0xEE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x140:
	CBI  0x3,2
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP SUBOPT_0xEB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x141:
	RCALL SUBOPT_0xBD
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x142:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x143:
	AND  R0,R30
	RCALL SUBOPT_0x104
	RJMP SUBOPT_0xA3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x144:
	RCALL SUBOPT_0x104
	RJMP SUBOPT_0xA3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x145:
	CALL __LTW12
	MOV  R0,R30
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,2
	RJMP SUBOPT_0x10C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x146:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	RJMP SUBOPT_0x10C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x147:
	CALL __LTW12
	MOV  R0,R30
	RCALL SUBOPT_0xE9
	SBIW R30,2
	RJMP SUBOPT_0x10C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x148:
	RCALL SUBOPT_0xE9
	SBIW R30,1
	RJMP SUBOPT_0x10C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x149:
	MOV  R0,R30
	LDS  R26,_cykl_glowny
	LDS  R27,_cykl_glowny+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14A:
	LDS  R30,_cykl_ilosc_zaciskow
	LDS  R31,_cykl_ilosc_zaciskow+1
	JMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x14C:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RCALL SUBOPT_0x10C
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x14D:
	RCALL SUBOPT_0xE9
	RCALL SUBOPT_0x10C
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0xD7
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14E:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RJMP SUBOPT_0xEB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14F:
	LDS  R26,_wykonalem_rzedow
	LDS  R27,_wykonalem_rzedow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x150:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	RJMP SUBOPT_0xD8

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x151:
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
SUBOPT_0x152:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x153:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x154:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	JMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x155:
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
