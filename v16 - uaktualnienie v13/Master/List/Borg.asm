
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
	.DB  0x63,0x79,0x20,0x34,0x33,0x0,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x0,0x57,0x63
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
;
;eeprom int czas_pracy_krazka_sciernego_h_34, czas_pracy_krazka_sciernego_h_36, czas_pracy_krazka_sciernego_h_38;
;eeprom int czas_pracy_krazka_sciernego_h_41, czas_pracy_krazka_sciernego_h_43;
;eeprom int czas_pracy_szczotki_drucianej_h;
;
;eeprom int czas_pracy_krazka_sciernego_stala,czas_pracy_szczotki_drucianej_stala;
;eeprom int tryb_pracy_szczotki_drucianej;
;
;#pragma warn+
;
;
;// Get a character from the USART1 Receiver
;#pragma used+
;char getchar1(void)
; 0000 0032 {

	.CSEG
; 0000 0033 unsigned char status;
; 0000 0034 char data;
; 0000 0035 while (1)
;	status -> R17
;	data -> R16
; 0000 0036       {
; 0000 0037       while (((status=UCSR1A) & RX_COMPLETE)==0);
; 0000 0038       data=UDR1;
; 0000 0039       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
; 0000 003A          return data;
; 0000 003B       }
; 0000 003C }
;#pragma used-
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 0042 {
; 0000 0043 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
; 0000 0044 UDR1=c;
; 0000 0045 }
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
; 0000 0056 #endasm
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
;int wykonano_powrot_przedwczesny_krazek_scierny;
;int wykonano_powrot_przedwczesny_druciak;
;int statystyka;
;
;char sprawdz_pin0(BB PORT, int numer_pcf)
; 0000 00C8 {
_sprawdz_pin0:
; 0000 00C9 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00CA i2c_write(numer_pcf);
; 0000 00CB PORT.byte = i2c_read(0);
; 0000 00CC i2c_stop();
; 0000 00CD 
; 0000 00CE 
; 0000 00CF return PORT.bits.b0;
	RJMP _0x20A0004
; 0000 00D0 }
;
;char sprawdz_pin1(BB PORT, int numer_pcf)
; 0000 00D3 {
_sprawdz_pin1:
; 0000 00D4 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00D5 i2c_write(numer_pcf);
; 0000 00D6 PORT.byte = i2c_read(0);
; 0000 00D7 i2c_stop();
; 0000 00D8 
; 0000 00D9 
; 0000 00DA return PORT.bits.b1;
	LSR  R30
	RJMP _0x20A0004
; 0000 00DB }
;
;
;char sprawdz_pin2(BB PORT, int numer_pcf)
; 0000 00DF {
_sprawdz_pin2:
; 0000 00E0 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00E1 i2c_write(numer_pcf);
; 0000 00E2 PORT.byte = i2c_read(0);
; 0000 00E3 i2c_stop();
; 0000 00E4 
; 0000 00E5 
; 0000 00E6 return PORT.bits.b2;
	LSR  R30
	LSR  R30
	RJMP _0x20A0004
; 0000 00E7 }
;
;char sprawdz_pin3(BB PORT, int numer_pcf)
; 0000 00EA {
_sprawdz_pin3:
; 0000 00EB i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00EC i2c_write(numer_pcf);
; 0000 00ED PORT.byte = i2c_read(0);
; 0000 00EE i2c_stop();
; 0000 00EF 
; 0000 00F0 
; 0000 00F1 return PORT.bits.b3;
	LSR  R30
	LSR  R30
	LSR  R30
	RJMP _0x20A0004
; 0000 00F2 }
;
;char sprawdz_pin4(BB PORT, int numer_pcf)
; 0000 00F5 {
_sprawdz_pin4:
; 0000 00F6 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00F7 i2c_write(numer_pcf);
; 0000 00F8 PORT.byte = i2c_read(0);
; 0000 00F9 i2c_stop();
; 0000 00FA 
; 0000 00FB 
; 0000 00FC return PORT.bits.b4;
	SWAP R30
	RJMP _0x20A0004
; 0000 00FD }
;
;char sprawdz_pin5(BB PORT, int numer_pcf)
; 0000 0100 {
_sprawdz_pin5:
; 0000 0101 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0102 i2c_write(numer_pcf);
; 0000 0103 PORT.byte = i2c_read(0);
; 0000 0104 i2c_stop();
; 0000 0105 
; 0000 0106 
; 0000 0107 return PORT.bits.b5;
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	RJMP _0x20A0004
; 0000 0108 }
;
;char sprawdz_pin6(BB PORT, int numer_pcf)
; 0000 010B {
_sprawdz_pin6:
; 0000 010C i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 010D i2c_write(numer_pcf);
; 0000 010E PORT.byte = i2c_read(0);
; 0000 010F i2c_stop();
; 0000 0110 
; 0000 0111 
; 0000 0112 return PORT.bits.b6;
	CALL SUBOPT_0x1
	RJMP _0x20A0004
; 0000 0113 }
;
;char sprawdz_pin7(BB PORT, int numer_pcf)
; 0000 0116 {
_sprawdz_pin7:
; 0000 0117 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0118 i2c_write(numer_pcf);
; 0000 0119 PORT.byte = i2c_read(0);
; 0000 011A i2c_stop();
; 0000 011B 
; 0000 011C 
; 0000 011D return PORT.bits.b7;
	ROL  R30
	LDI  R30,0
	ROL  R30
_0x20A0004:
	ANDI R30,LOW(0x1)
	ADIW R28,3
	RET
; 0000 011E }
;
;int odczytaj_parametr(int adres1, int adres2)
; 0000 0121 {
_odczytaj_parametr:
; 0000 0122 int z;
; 0000 0123 z = 0;
	CALL SUBOPT_0x2
;	adres1 -> Y+4
;	adres2 -> Y+2
;	z -> R16,R17
; 0000 0124 putchar(90);
	CALL SUBOPT_0x3
; 0000 0125 putchar(165);
; 0000 0126 putchar(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _putchar
; 0000 0127 putchar(131);
	LDI  R30,LOW(131)
	CALL SUBOPT_0x4
; 0000 0128 putchar(adres1);
; 0000 0129 putchar(adres2);
; 0000 012A putchar(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar
; 0000 012B getchar();
	CALL SUBOPT_0x5
; 0000 012C getchar();
; 0000 012D getchar();
; 0000 012E getchar();
	CALL SUBOPT_0x5
; 0000 012F getchar();
; 0000 0130 getchar();
; 0000 0131 getchar();
	CALL SUBOPT_0x5
; 0000 0132 getchar();
; 0000 0133 z = getchar();
	MOV  R16,R30
	CLR  R17
; 0000 0134 
; 0000 0135 
; 0000 0136 
; 0000 0137 
; 0000 0138 
; 0000 0139 
; 0000 013A 
; 0000 013B 
; 0000 013C 
; 0000 013D 
; 0000 013E 
; 0000 013F 
; 0000 0140 return z;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0003
; 0000 0141 }
;
;
;
;int czekaj_na_guzik_start(int adres)
; 0000 0146 {
; 0000 0147 //48 to adres zmiennej 30
; 0000 0148 //16 to adres zmiennj 10
; 0000 0149 
; 0000 014A int z;
; 0000 014B z = 0;
;	adres -> Y+2
;	z -> R16,R17
; 0000 014C putchar(90);
; 0000 014D putchar(165);
; 0000 014E putchar(4);
; 0000 014F putchar(131);
; 0000 0150 putchar(0);
; 0000 0151 putchar(adres);  //adres zmiennej - 30
; 0000 0152 putchar(1);
; 0000 0153 getchar();
; 0000 0154 getchar();
; 0000 0155 getchar();
; 0000 0156 getchar();
; 0000 0157 getchar();
; 0000 0158 getchar();
; 0000 0159 getchar();
; 0000 015A getchar();
; 0000 015B z = getchar();
; 0000 015C //itoa(z,dupa1);
; 0000 015D //lcd_puts(dupa1);
; 0000 015E 
; 0000 015F return z;
; 0000 0160 }
;
;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0167 {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0168 // Place your code here
; 0000 0169 //16,384 ms
; 0000 016A sek1++;     //Ster 1
	LDI  R26,LOW(_sek1)
	LDI  R27,HIGH(_sek1)
	CALL SUBOPT_0x6
; 0000 016B sek2++;     //ster 3
	LDI  R26,LOW(_sek2)
	LDI  R27,HIGH(_sek2)
	CALL SUBOPT_0x6
; 0000 016C 
; 0000 016D 
; 0000 016E sek3++;     //ster 2
	LDI  R26,LOW(_sek3)
	LDI  R27,HIGH(_sek3)
	CALL SUBOPT_0x6
; 0000 016F sek4++;     //ster 4
	LDI  R26,LOW(_sek4)
	LDI  R27,HIGH(_sek4)
	CALL SUBOPT_0x6
; 0000 0170 
; 0000 0171 
; 0000 0172 //sek10++;
; 0000 0173 
; 0000 0174 sek11++;  //do wyboru zacisku
	LDI  R26,LOW(_sek11)
	LDI  R27,HIGH(_sek11)
	CALL SUBOPT_0x6
; 0000 0175 sek12++;  //do czasu przedmuchu
	LDI  R26,LOW(_sek12)
	LDI  R27,HIGH(_sek12)
	CALL SUBOPT_0x6
; 0000 0176 
; 0000 0177 sek13++;  //do czasu zatrzymania sie druciaka na gorze
	LDI  R26,LOW(_sek13)
	LDI  R27,HIGH(_sek13)
	CALL SUBOPT_0x6
; 0000 0178 
; 0000 0179 sek20++;
	LDI  R26,LOW(_sek20)
	LDI  R27,HIGH(_sek20)
	CALL SUBOPT_0x6
; 0000 017A /*
; 0000 017B if(PORTE.3 == 1)
; 0000 017C       {
; 0000 017D       czas_pracy_szczotki_drucianej++;
; 0000 017E       czas_pracy_krazka_sciernego++;
; 0000 017F       if(czas_pracy_szczotki_drucianej == 61 * 60 * 60)
; 0000 0180             {
; 0000 0181             czas_pracy_szczotki_drucianej = 0;
; 0000 0182             czas_pracy_szczotki_drucianej_h++;
; 0000 0183             }
; 0000 0184       if(czas_pracy_krazka_sciernego == 61 * 60 * 60)
; 0000 0185             {
; 0000 0186             czas_pracy_krazka_sciernego = 0;
; 0000 0187             czas_pracy_krazka_sciernego_h++;
; 0000 0188             }
; 0000 0189       }
; 0000 018A 
; 0000 018B 
; 0000 018C       //61 razy - 1s
; 0000 018D       //61 * 60 - 1 minuta
; 0000 018E       //61 * 60 * 60 - 1h
; 0000 018F 
; 0000 0190 */
; 0000 0191 
; 0000 0192 }
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
; 0000 019B {
_komunikat_na_panel:
; 0000 019C int h;
; 0000 019D 
; 0000 019E h = 0;
	CALL SUBOPT_0x2
;	*fmtstr -> Y+6
;	adres2 -> Y+4
;	adres22 -> Y+2
;	h -> R16,R17
; 0000 019F h = strlenf(fmtstr);
	CALL SUBOPT_0x7
	CALL _strlenf
	MOVW R16,R30
; 0000 01A0 h = h + 3;
	__ADDWRN 16,17,3
; 0000 01A1 
; 0000 01A2 putchar(90);
	CALL SUBOPT_0x3
; 0000 01A3 putchar(165);
; 0000 01A4 putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL _putchar
; 0000 01A5 putchar(130);  //82
	LDI  R30,LOW(130)
	CALL SUBOPT_0x4
; 0000 01A6 putchar(adres2);    //
; 0000 01A7 putchar(adres22);  //
; 0000 01A8 printf(fmtstr);
	CALL SUBOPT_0x7
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 01A9 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;
;
;
;void wartosc_parametru_panelu(int wartosc, int adres1, int adres2)
; 0000 01AE {
_wartosc_parametru_panelu:
; 0000 01AF putchar(90);  //5A
;	wartosc -> Y+4
;	adres1 -> Y+2
;	adres2 -> Y+0
	CALL SUBOPT_0x3
; 0000 01B0 putchar(165); //A5
; 0000 01B1 putchar(5);//05
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 01B2 putchar(130);  //82    /
; 0000 01B3 putchar(adres1);    //00
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
; 0000 01B4 putchar(adres2);   //40
	LD   R30,Y
	ST   -Y,R30
	CALL _putchar
; 0000 01B5 putchar(0);    //00
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
; 0000 01B6 putchar(wartosc);   //80
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _putchar
; 0000 01B7 }
_0x20A0003:
	ADIW R28,6
	RET
;
;
;void zaktualizuj_parametry_panelu()
; 0000 01BB {
_zaktualizuj_parametry_panelu:
; 0000 01BC 
; 0000 01BD /////////////////////////
; 0000 01BE //wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
; 0000 01BF 
; 0000 01C0 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
; 0000 01C1 
; 0000 01C2 wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
	CALL SUBOPT_0x9
; 0000 01C3 
; 0000 01C4 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
; 0000 01C5 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
; 0000 01C6 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
; 0000 01C7 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
; 0000 01C8 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
; 0000 01C9 
; 0000 01CA //////////////////////////
; 0000 01CB 
; 0000 01CC 
; 0000 01CD 
; 0000 01CE 
; 0000 01CF if(zaaktualizuj_ilosc_rzad2 == 1)
	LDS  R26,_zaaktualizuj_ilosc_rzad2
	LDS  R27,_zaaktualizuj_ilosc_rzad2+1
	SBIW R26,1
	BRNE _0xD
; 0000 01D0     {
; 0000 01D1     wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad2
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	RCALL _wartosc_parametru_panelu
; 0000 01D2     zaaktualizuj_ilosc_rzad2 = 0;
	LDI  R30,LOW(0)
	STS  _zaaktualizuj_ilosc_rzad2,R30
	STS  _zaaktualizuj_ilosc_rzad2+1,R30
; 0000 01D3     }
; 0000 01D4 }
_0xD:
	RET
;
;void komunikat_z_czytnika_kodow(char flash *fmtstr,int rzad, int na_plus_minus)
; 0000 01D7 {
_komunikat_z_czytnika_kodow:
; 0000 01D8 //na_plus_minus = 1;  to jest na plus
; 0000 01D9 //na_plus_minus = 0;  to jest na minus
; 0000 01DA 
; 0000 01DB int h, adres1,adres11,adres2,adres22;
; 0000 01DC 
; 0000 01DD h = 0;
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
; 0000 01DE h = strlenf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOVW R16,R30
; 0000 01DF h = h + 3;
	__ADDWRN 16,17,3
; 0000 01E0 
; 0000 01E1 if(rzad == 1)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BRNE _0xE
; 0000 01E2    {
; 0000 01E3    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01E4    adres11 = 80;
	__GETWRN 20,21,80
; 0000 01E5    adres2 = 80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01E6    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01E7    }
; 0000 01E8 if(rzad == 2)
_0xE:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,2
	BRNE _0xF
; 0000 01E9    {
; 0000 01EA    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01EB    adres11 = 32;
	__GETWRN 20,21,32
; 0000 01EC    adres2 = 64;
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01ED    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01EE    }
; 0000 01EF 
; 0000 01F0 putchar(90);
_0xF:
	CALL SUBOPT_0x3
; 0000 01F1 putchar(165);
; 0000 01F2 putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL SUBOPT_0x8
; 0000 01F3 putchar(130);  //82
; 0000 01F4 putchar(adres1);    //
	ST   -Y,R18
	CALL _putchar
; 0000 01F5 putchar(adres11);  //
	ST   -Y,R20
	CALL _putchar
; 0000 01F6 printf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 01F7 
; 0000 01F8 
; 0000 01F9 if(rzad == 1 & macierz_zaciskow[rzad]==0)
	CALL SUBOPT_0xC
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0xD
	CALL __GETW1P
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x10
; 0000 01FA     {
; 0000 01FB     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xE
; 0000 01FC     komunikat_na_panel("Zacisk nie zmierzony u Wykonawcy",adres2,adres22);
	__POINTW1FN _0x0,49
	CALL SUBOPT_0xF
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 01FD     }
; 0000 01FE 
; 0000 01FF if(rzad == 1 & na_plus_minus == 1)
_0x10:
	CALL SUBOPT_0xC
	CALL SUBOPT_0x11
	BREQ _0x11
; 0000 0200     {
; 0000 0201     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xE
; 0000 0202     //komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
; 0000 0203     komunikat_na_panel("Kly w kierunku prawej strony",adres2,adres22);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0xF
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 0204     }
; 0000 0205 
; 0000 0206 if(rzad == 1 & na_plus_minus == 0)
_0x11:
	CALL SUBOPT_0xC
	CALL SUBOPT_0x12
	BREQ _0x12
; 0000 0207     {
; 0000 0208     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xE
; 0000 0209     //komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
; 0000 020A     komunikat_na_panel("Kly w kierunku lewej strony",adres2,adres22);
	__POINTW1FN _0x0,111
	CALL SUBOPT_0xF
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 020B     }
; 0000 020C 
; 0000 020D 
; 0000 020E if(rzad == 2 & na_plus_minus == 1)
_0x12:
	CALL SUBOPT_0x13
	CALL SUBOPT_0x11
	BREQ _0x13
; 0000 020F     {
; 0000 0210     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xE
; 0000 0211     //komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
; 0000 0212     komunikat_na_panel("Kly w kierunku lewej strony",adres2,adres22);
	__POINTW1FN _0x0,111
	CALL SUBOPT_0xF
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 0213     }
; 0000 0214 
; 0000 0215 if(rzad == 2 & na_plus_minus == 0)
_0x13:
	CALL SUBOPT_0x13
	CALL SUBOPT_0x12
	BREQ _0x14
; 0000 0216     {
; 0000 0217     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xE
; 0000 0218     //komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
; 0000 0219     komunikat_na_panel("Kly w kierunku prawej strony",adres2,adres22);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0xF
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 021A     }
; 0000 021B 
; 0000 021C 
; 0000 021D }
_0x14:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;
;void zerowanie_pam_wew()
; 0000 0220 {
; 0000 0221 /*
; 0000 0222 if(czas_pracy_szczotki_drucianej_h >= 255 | czas_pracy_krazka_sciernego_h >=255 | czas_pracy_krazka_sciernego_stala >= 255 | czas_pracy_szczotki_drucianej_stala >= 255 |
; 0000 0223    szczotka_druciana_ilosc_cykli >= 255 | krazek_scierny_ilosc_cykli >= 255 | krazek_scierny_cykl_po_okregu_ilosc >=255)
; 0000 0224      {
; 0000 0225      czas_pracy_szczotki_drucianej_h = 0;
; 0000 0226      czas_pracy_szczotki_drucianej = 0;
; 0000 0227      czas_pracy_krazka_sciernego_h = 0;
; 0000 0228      czas_pracy_krazka_sciernego = 0;
; 0000 0229      czas_pracy_krazka_sciernego_stala = 5;
; 0000 022A      czas_pracy_szczotki_drucianej_stala = 5;
; 0000 022B      szczotka_druciana_ilosc_cykli = 3;
; 0000 022C      krazek_scierny_ilosc_cykli = 3;
; 0000 022D      krazek_scierny_cykl_po_okregu_ilosc = 3;
; 0000 022E      }
; 0000 022F */
; 0000 0230 
; 0000 0231 /*
; 0000 0232 if(czas_pracy_krazka_sciernego_h >= 255)
; 0000 0233      {
; 0000 0234      czas_pracy_krazka_sciernego_h = 0;
; 0000 0235      czas_pracy_krazka_sciernego = 0;
; 0000 0236      }
; 0000 0237 if(czas_pracy_krazka_sciernego_stala >= 255)
; 0000 0238      czas_pracy_krazka_sciernego_stala = 5;
; 0000 0239 
; 0000 023A if(czas_pracy_szczotki_drucianej_stala >= 255)
; 0000 023B      czas_pracy_szczotki_drucianej_stala = 5;
; 0000 023C 
; 0000 023D if(szczotka_druciana_ilosc_cykli >= 255)
; 0000 023E 
; 0000 023F if(krazek_scierny_ilosc_cykli >= 255)
; 0000 0240 
; 0000 0241 if(krazek_scierny_cykl_po_okregu_ilosc >=255)
; 0000 0242 */
; 0000 0243 
; 0000 0244 }
;
;
;void odpytaj_parametry_panelu()
; 0000 0248 {
_odpytaj_parametry_panelu:
; 0000 0249 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x15
; 0000 024A     start = odczytaj_parametr(0,64);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x17
	STS  _start,R30
	STS  _start+1,R31
; 0000 024B il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
_0x15:
	CALL SUBOPT_0xA
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0000 024C il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
; 0000 024D 
; 0000 024E szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
	CALL SUBOPT_0x17
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL SUBOPT_0x1C
; 0000 024F                                                 //2090
; 0000 0250 krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
; 0000 0251                                                     //3000
; 0000 0252 krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1F
; 0000 0253 
; 0000 0254 //////////////////////////////////////////////
; 0000 0255 czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x20
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL SUBOPT_0x1C
; 0000 0256 
; 0000 0257 czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
	CALL SUBOPT_0xB
	RCALL _odczytaj_parametr
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_stala)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_stala)
	CALL __EEPROMWRW
; 0000 0258 
; 0000 0259 
; 0000 025A //czas_pracy_szczotki_drucianej_h = odczytaj_parametr(0,144);
; 0000 025B 
; 0000 025C //czas_pracy_krazka_sciernego_h_34 = odczytaj_parametr(96,48);
; 0000 025D //czas_pracy_krazka_sciernego_h_36 = odczytaj_parametr(96,64);
; 0000 025E //czas_pracy_krazka_sciernego_h_38 = odczytaj_parametr(96,80);
; 0000 025F //czas_pracy_krazka_sciernego_h_41 = odczytaj_parametr(96,96);
; 0000 0260 //czas_pracy_krazka_sciernego_h_43 = odczytaj_parametr(96,112);
; 0000 0261 
; 0000 0262 //////////////////////////////////////////////////////////
; 0000 0263 
; 0000 0264 test_geometryczny_rzad_1 = odczytaj_parametr(48,80);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x21
	RCALL _odczytaj_parametr
	STS  _test_geometryczny_rzad_1,R30
	STS  _test_geometryczny_rzad_1+1,R31
; 0000 0265 
; 0000 0266 test_geometryczny_rzad_2 = odczytaj_parametr(48,96);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x22
	RCALL _odczytaj_parametr
	STS  _test_geometryczny_rzad_2,R30
	STS  _test_geometryczny_rzad_2+1,R31
; 0000 0267 
; 0000 0268 srednica_krazka_sciernego = odczytaj_parametr(48,112);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x20
	CALL SUBOPT_0x23
; 0000 0269 
; 0000 026A ruch_haos = odczytaj_parametr(48,144);
	CALL SUBOPT_0x1D
	STS  _ruch_haos,R30
	STS  _ruch_haos+1,R31
; 0000 026B 
; 0000 026C tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x20
	LDI  R26,LOW(_tryb_pracy_szczotki_drucianej)
	LDI  R27,HIGH(_tryb_pracy_szczotki_drucianej)
	CALL __EEPROMWRW
; 0000 026D                                                 //2050
; 0000 026E //zerowanie_pam_wew();
; 0000 026F 
; 0000 0270 }
	RET
;
;void wyrrrjscia_i_wejscia_opis()
; 0000 0273 {
; 0000 0274 
; 0000 0275 
; 0000 0276 //IN0
; 0000 0277 
; 0000 0278 //komunikacja miedzy slave a master
; 0000 0279 //sprawdz_pin0(PORTHH,0x73)
; 0000 027A //sprawdz_pin1(PORTHH,0x73)
; 0000 027B //sprawdz_pin2(PORTHH,0x73)
; 0000 027C //sprawdz_pin3(PORTHH,0x73)
; 0000 027D //sprawdz_pin4(PORTHH,0x73)
; 0000 027E //sprawdz_pin5(PORTHH,0x73)
; 0000 027F //sprawdz_pin6(PORTHH,0x73)
; 0000 0280 //sprawdz_pin7(PORTHH,0x73)
; 0000 0281 
; 0000 0282 //IN1
; 0000 0283 //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 0284 //sprawdz_pin1(PORTJJ,0x79)  AREA   STEROWNIK1
; 0000 0285 //sprawdz_pin2(PORTJJ,0x79)  SETON  STEROWNIK1
; 0000 0286 //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 0287 //sprawdz_pin4(PORTJJ,0x79)  SVRE   STEROWNIK1
; 0000 0288 //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 0289 //sprawdz_pin6(PORTJJ,0x79)  czujnik cisnienia
; 0000 028A //sprawdz_pin7(PORTJJ,0x79)
; 0000 028B 
; 0000 028C //IN2
; 0000 028D //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 028E //sprawdz_pin1(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK3
; 0000 028F //sprawdz_pin2(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK3
; 0000 0290 //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 0291 //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 0292 //sprawdz_pin5(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK4
; 0000 0293 //sprawdz_pin6(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK4
; 0000 0294 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 0295 
; 0000 0296 //IN3
; 0000 0297 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 0298 //sprawdz_pin1(PORTLL,0x71)  AREA   STEROWNIK2
; 0000 0299 //sprawdz_pin2(PORTLL,0x71)  SETON  STEROWNIK2
; 0000 029A //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 029B //sprawdz_pin4(PORTLL,0x71)  SVRE   STEROWNIK2
; 0000 029C //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 029D //sprawdz_pin6(PORTLL,0x71)  S6A przek³adanie rzedow
; 0000 029E //sprawdz_pin7(PORTLL,0x71)  S6B przekladanie rzedow
; 0000 029F 
; 0000 02A0 //IN4
; 0000 02A1 //sprawdz_pin0(PORTMM,0x77) J2  czujnik indukcyjny domkniecia pokrywy
; 0000 02A2 //sprawdz_pin1(PORTMM,0x77) J3  czujnik indukcyjny domkniecia pokrywy
; 0000 02A3 //sprawdz_pin2(PORTMM,0x77)
; 0000 02A4 //sprawdz_pin3(PORTMM,0x77)
; 0000 02A5 //sprawdz_pin4(PORTMM,0x77)
; 0000 02A6 //sprawdz_pin5(PORTMM,0x77)
; 0000 02A7 //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 02A8 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 02A9 
; 0000 02AA //sterownik 1 i sterownik 3 - krazek scierny
; 0000 02AB //sterownik 2 i sterownik 4 - druciak
; 0000 02AC 
; 0000 02AD //OUT
; 0000 02AE //PORTA.0   IN0  STEROWNIK1        OUT 1
; 0000 02AF //PORTA.1   IN1  STEROWNIK1
; 0000 02B0 //PORTA.2   IN2  STEROWNIK1
; 0000 02B1 //PORTA.3   IN3  STEROWNIK1
; 0000 02B2 //PORTA.4   IN4  STEROWNIK1
; 0000 02B3 //PORTA.5   IN5  STEROWNIK1
; 0000 02B4 //PORTA.6   IN6  STEROWNIK1
; 0000 02B5 //PORTA.7   IN7  STEROWNIK1
; 0000 02B6 
; 0000 02B7 //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 02B8 //PORTB.1   IN1  STEROWNIK4
; 0000 02B9 //PORTB.2   IN2  STEROWNIK4
; 0000 02BA //PORTB.3   IN3  STEROWNIK4
; 0000 02BB //PORTB.4   4B CEWKA przedmuch osi, byl, juz poloczone z B.6, teraz juz setup poziome
; 0000 02BC //PORTB.5   DRIVE  STEROWNIK4
; 0000 02BD //PORTB.6   swiatlo zielone
; 0000 02BE //PORTB.7   IN5 STEROWNIK 3
; 0000 02BF 
; 0000 02C0 //PORTC.0   IN0  STEROWNIK2        OUT 3
; 0000 02C1 //PORTC.1   IN1  STEROWNIK2
; 0000 02C2 //PORTC.2   IN2  STEROWNIK2
; 0000 02C3 //PORTC.3   IN3  STEROWNIK2
; 0000 02C4 //PORTC.4   IN4  STEROWNIK2
; 0000 02C5 //PORTC.5   IN5  STEROWNIK2
; 0000 02C6 //PORTC.6   IN6  STEROWNIK2
; 0000 02C7 //PORTC.7   IN7  STEROWNIK2
; 0000 02C8 
; 0000 02C9 //PORTD.0  SDA                     OUT 2
; 0000 02CA //PORTD.1  SCL
; 0000 02CB //PORTD.2  SETUP   STEROWNIK1 STEROWNIK 2 STEROIWNIK 3 STEROWNIK 4
; 0000 02CC //PORTD.3  DRIVE   STEROWNIK1
; 0000 02CD //PORTD.4  IN8 STEROWNIK1
; 0000 02CE //PORTD.5  IN8 STEROWNIK2
; 0000 02CF //PORTD.6  DRIVE   STEROWNIK2
; 0000 02D0 //PORTD.7  swiatlo czerwone i jednoczesnie HOLD
; 0000 02D1 
; 0000 02D2 //PORTE.0
; 0000 02D3 //PORTE.1
; 0000 02D4 //PORTE.2  1A CEWKA szczotka druciana                    OUT 6
; 0000 02D5 //PORTE.3  1B CEWKA krazek scierny
; 0000 02D6 //PORTE.4  IN4  STEROWNIK4
; 0000 02D7 //PORTE.5  IN5  STEROWNIK4   ///////////////////////////////////////////////teraz tu bêdzie przedmuch kana³ B
; 0000 02D8 //PORTE.6  2A CEWKA przerzucanie docisku zaciskow
; 0000 02D9 //PORTE.7  3A CEWKA zacisnij zaciski
; 0000 02DA 
; 0000 02DB //PORTF.0   IN0  STEROWNIK3             OUT 4
; 0000 02DC //PORTF.1   IN1  STEROWNIK3
; 0000 02DD //PORTF.2   IN2  STEROWNIK3
; 0000 02DE //PORTF.3   IN3  STEROWNIK3
; 0000 02DF //PORTF.4   4A CEWKA przedmuch zaciskow
; 0000 02E0 //PORTF.5   DRIVE  STEROWNIK3
; 0000 02E1 //PORTF.6   swiatlo zolte
; 0000 02E2 //PORTF.7   IN4 STEROWNIK 3
; 0000 02E3 
; 0000 02E4 
; 0000 02E5 
; 0000 02E6  //PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 02E7 //PORTF = PORT_F.byte;
; 0000 02E8 //PORTB.6 = 1;  //przedmuch osi
; 0000 02E9 //PORTE.2 = 1;  //szlifierka 1
; 0000 02EA //PORTE.3 = 1;  //szlifierka 2
; 0000 02EB //PORTE.6 = 0;  //zacisniety rzad 1
; 0000 02EC //PORTE.6 = 1;  //zacisniety rzad 2
; 0000 02ED //PORTE.7 = 0;    //zacisnij zaciski
; 0000 02EE 
; 0000 02EF 
; 0000 02F0 //macierz_zaciskow[rzad]=44; brak
; 0000 02F1 //macierz_zaciskow[rzad]=48; brak
; 0000 02F2 //macierz_zaciskow[rzad]=76  brak
; 0000 02F3 //macierz_zaciskow[rzad]=80; brak
; 0000 02F4 //macierz_zaciskow[rzad]=92; brak
; 0000 02F5 //macierz_zaciskow[rzad]=96;  brak
; 0000 02F6 //macierz_zaciskow[rzad]=107; brak
; 0000 02F7 //macierz_zaciskow[rzad]=111; brak
; 0000 02F8 
; 0000 02F9 
; 0000 02FA 
; 0000 02FB 
; 0000 02FC /*
; 0000 02FD 
; 0000 02FE //testy parzystych i nieparzystych IN0-IN8
; 0000 02FF //testy port/pin
; 0000 0300 //sterownik 3
; 0000 0301 //PORTF.0   IN0  STEROWNIK3
; 0000 0302 //PORTF.1   IN1  STEROWNIK3
; 0000 0303 //PORTF.2   IN2  STEROWNIK3
; 0000 0304 //PORTF.3   IN3  STEROWNIK3
; 0000 0305 //PORTF.7   IN4 STEROWNIK 3
; 0000 0306 //PORTB.7   IN5 STEROWNIK 3
; 0000 0307 
; 0000 0308 
; 0000 0309 PORT_F.bits.b0 = 0;
; 0000 030A PORT_F.bits.b1 = 1;
; 0000 030B PORT_F.bits.b2 = 0;
; 0000 030C PORT_F.bits.b3 = 1;
; 0000 030D PORT_F.bits.b7 = 0;
; 0000 030E PORTF = PORT_F.byte;
; 0000 030F PORTB.7 = 1;
; 0000 0310 
; 0000 0311 //sterownik 4
; 0000 0312 
; 0000 0313 //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 0314 //PORTB.1   IN1  STEROWNIK4
; 0000 0315 //PORTB.2   IN2  STEROWNIK4
; 0000 0316 //PORTB.3   IN3  STEROWNIK4
; 0000 0317 //PORTE.4  IN4  STEROWNIK4
; 0000 0318 
; 0000 0319 
; 0000 031A PORTB.0 = 0;
; 0000 031B PORTB.1 = 1;
; 0000 031C PORTB.2 = 0;
; 0000 031D PORTB.3 = 1;
; 0000 031E PORTE.4 = 0;
; 0000 031F 
; 0000 0320 
; 0000 0321 //ster 1
; 0000 0322 PORTA.0 = 0;   //IN0  STEROWNIK1        OUT 1
; 0000 0323 PORTA.1 = 1;  //IN1  STEROWNIK1
; 0000 0324 PORTA.2 = 0;  // IN2  STEROWNIK1
; 0000 0325 PORTA.3 = 1;  //IN3  STEROWNIK1
; 0000 0326 PORTA.4 = 0;  // IN4  STEROWNIK1
; 0000 0327 PORTA.5 = 1;  //IN5  STEROWNIK1
; 0000 0328 PORTA.6 = 0;   //IN6  STEROWNIK1
; 0000 0329 PORTA.7 = 1;  //IN7  STEROWNIK1
; 0000 032A PORTD.4 = 0; //IN8 STEROWNIK1
; 0000 032B 
; 0000 032C 
; 0000 032D 
; 0000 032E //sterownik 2
; 0000 032F PORTC.0 = 0;   //IN0  STEROWNIK2        OUT 3
; 0000 0330 PORTC.1  = 1;  //IN1  STEROWNIK2
; 0000 0331 PORTC.2 = 0;    //IN2  STEROWNIK2
; 0000 0332 PORTC.3= 1;   //IN3  STEROWNIK2
; 0000 0333 PORTC.4 = 0;   // IN4  STEROWNIK2
; 0000 0334 PORTC.5= 1;   //IN5  STEROWNIK2
; 0000 0335 PORTC.6 = 0;   // IN6  STEROWNIK2
; 0000 0336 PORTC.7= 1;   //IN7  STEROWNIK2
; 0000 0337 PORTD.5 = 0;  //IN8 STEROWNIK2
; 0000 0338 
; 0000 0339 */
; 0000 033A 
; 0000 033B }
;
;void sprawdz_cisnienie()
; 0000 033E {
_sprawdz_cisnienie:
; 0000 033F int i;
; 0000 0340 i = 0;
	CALL SUBOPT_0x2
;	i -> R16,R17
; 0000 0341 //i = 1;
; 0000 0342 
; 0000 0343 while(i == 0)
_0x16:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x18
; 0000 0344     {
; 0000 0345     if(sprawdz_pin6(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x24
	RCALL _sprawdz_pin6
	CPI  R30,0
	BRNE _0x19
; 0000 0346         {
; 0000 0347         i = 1;
	__GETWRN 16,17,1
; 0000 0348         if(cisnienie_sprawdzone == 0)
	LDS  R30,_cisnienie_sprawdzone
	LDS  R31,_cisnienie_sprawdzone+1
	SBIW R30,0
	BRNE _0x1A
; 0000 0349             {
; 0000 034A             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 034B             cisnienie_sprawdzone = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cisnienie_sprawdzone,R30
	STS  _cisnienie_sprawdzone+1,R31
; 0000 034C             }
; 0000 034D 
; 0000 034E         }
_0x1A:
; 0000 034F     else
	RJMP _0x1B
_0x19:
; 0000 0350         {
; 0000 0351         i = 0;
	__GETWRN 16,17,0
; 0000 0352         cisnienie_sprawdzone = 0;
	LDI  R30,LOW(0)
	STS  _cisnienie_sprawdzone,R30
	STS  _cisnienie_sprawdzone+1,R30
; 0000 0353         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 0354         komunikat_na_panel("Cisnienie za male - mniejsze niz 6 bar",adr1,adr2);
	__POINTW1FN _0x0,139
	CALL SUBOPT_0x26
; 0000 0355 
; 0000 0356         }
_0x1B:
; 0000 0357     }
	RJMP _0x16
_0x18:
; 0000 0358 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;int odczyt_wybranego_zacisku()
; 0000 035C {                         //11
_odczyt_wybranego_zacisku:
; 0000 035D int rzad;
; 0000 035E 
; 0000 035F PORT_CZYTNIK.bits.b0 = sprawdz_pin0(PORTHH,0x73);
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	CALL SUBOPT_0x27
	RCALL _sprawdz_pin0
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFE
	CALL SUBOPT_0x28
; 0000 0360 PORT_CZYTNIK.bits.b1 = sprawdz_pin1(PORTHH,0x73);
	RCALL _sprawdz_pin1
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFD
	CALL SUBOPT_0x28
; 0000 0361 PORT_CZYTNIK.bits.b2 = sprawdz_pin2(PORTHH,0x73);
	RCALL _sprawdz_pin2
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFB
	CALL SUBOPT_0x28
; 0000 0362 PORT_CZYTNIK.bits.b3 = sprawdz_pin3(PORTHH,0x73);
	RCALL _sprawdz_pin3
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0XF7
	CALL SUBOPT_0x28
; 0000 0363 PORT_CZYTNIK.bits.b4 = sprawdz_pin4(PORTHH,0x73);
	RCALL _sprawdz_pin4
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xEF
	CALL SUBOPT_0x28
; 0000 0364 PORT_CZYTNIK.bits.b5 = sprawdz_pin5(PORTHH,0x73);
	RCALL _sprawdz_pin5
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xDF
	CALL SUBOPT_0x28
; 0000 0365 PORT_CZYTNIK.bits.b6 = sprawdz_pin6(PORTHH,0x73);
	RCALL _sprawdz_pin6
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xBF
	CALL SUBOPT_0x28
; 0000 0366 PORT_CZYTNIK.bits.b7 = sprawdz_pin7(PORTHH,0x73);
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
; 0000 0367 
; 0000 0368 rzad = odczytaj_parametr(32,128);       //20,80
	CALL SUBOPT_0x29
	CALL SUBOPT_0x18
	MOVW R16,R30
; 0000 0369 
; 0000 036A if(PORT_CZYTNIK.byte == 0x01)
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1)
	BRNE _0x1C
; 0000 036B     {
; 0000 036C     macierz_zaciskow[rzad]=1;
	MOVW R30,R16
	CALL SUBOPT_0xD
	CALL SUBOPT_0x2A
; 0000 036D     komunikat_z_czytnika_kodow("86-0170",rzad,1);
	__POINTW1FN _0x0,178
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 036E     srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 036F     }
; 0000 0370 
; 0000 0371 if(PORT_CZYTNIK.byte == 0x02)
_0x1C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2)
	BRNE _0x1D
; 0000 0372     {
; 0000 0373     macierz_zaciskow[rzad]=2;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
; 0000 0374     komunikat_z_czytnika_kodow("86-1043",rzad,0);
	__POINTW1FN _0x0,186
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 0375     srednica_wew_korpusu = 34;
; 0000 0376     }
; 0000 0377 
; 0000 0378 if(PORT_CZYTNIK.byte == 0x03)
_0x1D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3)
	BRNE _0x1E
; 0000 0379     {
; 0000 037A       macierz_zaciskow[rzad]=3;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   X+,R30
	ST   X,R31
; 0000 037B       komunikat_z_czytnika_kodow("86-1675",rzad,0);
	__POINTW1FN _0x0,194
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 037C       srednica_wew_korpusu =38;
; 0000 037D     }
; 0000 037E 
; 0000 037F if(PORT_CZYTNIK.byte == 0x04)
_0x1E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4)
	BRNE _0x1F
; 0000 0380     {
; 0000 0381 
; 0000 0382       macierz_zaciskow[rzad]=4;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   X+,R30
	ST   X,R31
; 0000 0383       komunikat_z_czytnika_kodow("86-2098",rzad,0);
	__POINTW1FN _0x0,202
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0384       srednica_wew_korpusu = 38;
; 0000 0385     }
; 0000 0386 if(PORT_CZYTNIK.byte == 0x05)
_0x1F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5)
	BRNE _0x20
; 0000 0387     {
; 0000 0388       macierz_zaciskow[rzad]=5;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   X+,R30
	ST   X,R31
; 0000 0389       komunikat_z_czytnika_kodow("87-0170",rzad,0);
	__POINTW1FN _0x0,210
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 038A       srednica_wew_korpusu = 38;
; 0000 038B     }
; 0000 038C if(PORT_CZYTNIK.byte == 0x06)
_0x20:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6)
	BRNE _0x21
; 0000 038D     {
; 0000 038E       macierz_zaciskow[rzad]=6;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   X+,R30
	ST   X,R31
; 0000 038F       komunikat_z_czytnika_kodow("87-1043",rzad,1);
	__POINTW1FN _0x0,218
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0390       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 0391     }
; 0000 0392 
; 0000 0393 if(PORT_CZYTNIK.byte == 0x07)
_0x21:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7)
	BRNE _0x22
; 0000 0394     {
; 0000 0395       macierz_zaciskow[rzad]=7;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   X+,R30
	ST   X,R31
; 0000 0396       komunikat_z_czytnika_kodow("87-1675",rzad,1);
	__POINTW1FN _0x0,226
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0397       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 0398     }
; 0000 0399 
; 0000 039A if(PORT_CZYTNIK.byte == 0x08)
_0x22:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8)
	BRNE _0x23
; 0000 039B     {
; 0000 039C       macierz_zaciskow[rzad]=8;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   X+,R30
	ST   X,R31
; 0000 039D       komunikat_z_czytnika_kodow("87-2098",rzad,1);
	__POINTW1FN _0x0,234
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 039E       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 039F     }
; 0000 03A0 if(PORT_CZYTNIK.byte == 0x09)
_0x23:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x9)
	BRNE _0x24
; 0000 03A1     {
; 0000 03A2       macierz_zaciskow[rzad]=9;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   X+,R30
	ST   X,R31
; 0000 03A3       komunikat_z_czytnika_kodow("86-0192",rzad,0);
	__POINTW1FN _0x0,242
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 03A4       srednica_wew_korpusu = 38;
; 0000 03A5     }
; 0000 03A6 if(PORT_CZYTNIK.byte == 0x0A)
_0x24:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xA)
	BRNE _0x25
; 0000 03A7     {
; 0000 03A8       macierz_zaciskow[rzad]=10;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   X+,R30
	ST   X,R31
; 0000 03A9       komunikat_z_czytnika_kodow("86-1054",rzad,0);
	__POINTW1FN _0x0,250
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 03AA       srednica_wew_korpusu = 41;
; 0000 03AB     }
; 0000 03AC if(PORT_CZYTNIK.byte == 0x0B)
_0x25:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xB)
	BRNE _0x26
; 0000 03AD     {
; 0000 03AE       macierz_zaciskow[rzad]=11;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   X+,R30
	ST   X,R31
; 0000 03AF       komunikat_z_czytnika_kodow("86-1676",rzad,0);
	__POINTW1FN _0x0,258
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 03B0       srednica_wew_korpusu = 41;
; 0000 03B1     }
; 0000 03B2 if(PORT_CZYTNIK.byte == 0x0C)
_0x26:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xC)
	BRNE _0x27
; 0000 03B3     {
; 0000 03B4       macierz_zaciskow[rzad]=12;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   X+,R30
	ST   X,R31
; 0000 03B5       komunikat_z_czytnika_kodow("86-2132",rzad,1);
	__POINTW1FN _0x0,266
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 03B6       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 03B7     }
; 0000 03B8 if(PORT_CZYTNIK.byte == 0x0D)
_0x27:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xD)
	BRNE _0x28
; 0000 03B9     {
; 0000 03BA       macierz_zaciskow[rzad]=13;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   X+,R30
	ST   X,R31
; 0000 03BB       komunikat_z_czytnika_kodow("87-0192",rzad,1);
	__POINTW1FN _0x0,274
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 03BC       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 03BD     }
; 0000 03BE if(PORT_CZYTNIK.byte == 0x0E)
_0x28:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xE)
	BRNE _0x29
; 0000 03BF     {
; 0000 03C0       macierz_zaciskow[rzad]=14;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   X+,R30
	ST   X,R31
; 0000 03C1       komunikat_z_czytnika_kodow("87-1054",rzad,1);
	__POINTW1FN _0x0,282
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 03C2       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 03C3     }
; 0000 03C4 
; 0000 03C5 if(PORT_CZYTNIK.byte == 0x0F)
_0x29:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xF)
	BRNE _0x2A
; 0000 03C6     {
; 0000 03C7       macierz_zaciskow[rzad]=15;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   X+,R30
	ST   X,R31
; 0000 03C8       komunikat_z_czytnika_kodow("87-1676",rzad,1);
	__POINTW1FN _0x0,290
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 03C9       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 03CA     }
; 0000 03CB if(PORT_CZYTNIK.byte == 0x10)
_0x2A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x10)
	BRNE _0x2B
; 0000 03CC     {
; 0000 03CD       macierz_zaciskow[rzad]=16;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   X+,R30
	ST   X,R31
; 0000 03CE       komunikat_z_czytnika_kodow("87-2132",rzad,0);
	__POINTW1FN _0x0,298
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 03CF       srednica_wew_korpusu = 41;
; 0000 03D0     }
; 0000 03D1 
; 0000 03D2 if(PORT_CZYTNIK.byte == 0x11)
_0x2B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x11)
	BRNE _0x2C
; 0000 03D3     {
; 0000 03D4       macierz_zaciskow[rzad]=17;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   X+,R30
	ST   X,R31
; 0000 03D5       komunikat_z_czytnika_kodow("86-0193",rzad,0);
	__POINTW1FN _0x0,306
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 03D6       srednica_wew_korpusu = 38;
; 0000 03D7     }
; 0000 03D8 
; 0000 03D9 if(PORT_CZYTNIK.byte == 0x12)
_0x2C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x12)
	BRNE _0x2D
; 0000 03DA     {
; 0000 03DB       macierz_zaciskow[rzad]=18;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	ST   X+,R30
	ST   X,R31
; 0000 03DC       komunikat_z_czytnika_kodow("86-1216",rzad,0);
	__POINTW1FN _0x0,314
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 03DD       srednica_wew_korpusu = 34;
; 0000 03DE     }
; 0000 03DF if(PORT_CZYTNIK.byte == 0x13)
_0x2D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x13)
	BRNE _0x2E
; 0000 03E0     {
; 0000 03E1       macierz_zaciskow[rzad]=19;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	ST   X+,R30
	ST   X,R31
; 0000 03E2       komunikat_z_czytnika_kodow("86-1832",rzad,0);
	__POINTW1FN _0x0,322
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 03E3       srednica_wew_korpusu = 41;
; 0000 03E4     }
; 0000 03E5 
; 0000 03E6 if(PORT_CZYTNIK.byte == 0x14)
_0x2E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x14)
	BRNE _0x2F
; 0000 03E7     {
; 0000 03E8       macierz_zaciskow[rzad]=20;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   X+,R30
	ST   X,R31
; 0000 03E9       komunikat_z_czytnika_kodow("86-2174",rzad,0);
	__POINTW1FN _0x0,330
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 03EA       srednica_wew_korpusu = 34;
; 0000 03EB     }
; 0000 03EC if(PORT_CZYTNIK.byte == 0x15)
_0x2F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x15)
	BRNE _0x30
; 0000 03ED     {
; 0000 03EE       macierz_zaciskow[rzad]=21;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	ST   X+,R30
	ST   X,R31
; 0000 03EF       komunikat_z_czytnika_kodow("87-0193",rzad,1);
	__POINTW1FN _0x0,338
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 03F0       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 03F1     }
; 0000 03F2 
; 0000 03F3 if(PORT_CZYTNIK.byte == 0x16)
_0x30:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x16)
	BRNE _0x31
; 0000 03F4     {
; 0000 03F5       macierz_zaciskow[rzad]=22;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	ST   X+,R30
	ST   X,R31
; 0000 03F6       komunikat_z_czytnika_kodow("87-1216",rzad,1);
	__POINTW1FN _0x0,346
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 03F7       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 03F8     }
; 0000 03F9 if(PORT_CZYTNIK.byte == 0x17)
_0x31:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x17)
	BRNE _0x32
; 0000 03FA     {
; 0000 03FB       macierz_zaciskow[rzad]=23;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	ST   X+,R30
	ST   X,R31
; 0000 03FC       komunikat_z_czytnika_kodow("87-1832",rzad,1);
	__POINTW1FN _0x0,354
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 03FD       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 03FE     }
; 0000 03FF 
; 0000 0400 if(PORT_CZYTNIK.byte == 0x18)
_0x32:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x18)
	BRNE _0x33
; 0000 0401     {
; 0000 0402       macierz_zaciskow[rzad]=24;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	ST   X+,R30
	ST   X,R31
; 0000 0403       komunikat_z_czytnika_kodow("87-2174",rzad,1);
	__POINTW1FN _0x0,362
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0404       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 0405     }
; 0000 0406 if(PORT_CZYTNIK.byte == 0x19)
_0x33:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x19)
	BRNE _0x34
; 0000 0407     {
; 0000 0408       macierz_zaciskow[rzad]=25;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	ST   X+,R30
	ST   X,R31
; 0000 0409       komunikat_z_czytnika_kodow("86-0194",rzad,0);
	__POINTW1FN _0x0,370
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 040A       srednica_wew_korpusu = 41;
; 0000 040B     }
; 0000 040C 
; 0000 040D if(PORT_CZYTNIK.byte == 0x1A)
_0x34:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1A)
	BRNE _0x35
; 0000 040E     {
; 0000 040F       macierz_zaciskow[rzad]=26;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	ST   X+,R30
	ST   X,R31
; 0000 0410       komunikat_z_czytnika_kodow("86-1341",rzad,0);
	__POINTW1FN _0x0,378
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 0411       srednica_wew_korpusu = 34;
; 0000 0412     }
; 0000 0413 if(PORT_CZYTNIK.byte == 0x1B)
_0x35:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1B)
	BRNE _0x36
; 0000 0414     {
; 0000 0415       macierz_zaciskow[rzad]=27;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(27)
	LDI  R31,HIGH(27)
	ST   X+,R30
	ST   X,R31
; 0000 0416       komunikat_z_czytnika_kodow("86-1833",rzad,0);
	__POINTW1FN _0x0,386
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 0417       srednica_wew_korpusu = 41;
; 0000 0418     }
; 0000 0419 if(PORT_CZYTNIK.byte == 0x1C)
_0x36:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1C)
	BRNE _0x37
; 0000 041A     {
; 0000 041B       macierz_zaciskow[rzad]=28;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	ST   X+,R30
	ST   X,R31
; 0000 041C       komunikat_z_czytnika_kodow("86-2180",rzad,1);
	__POINTW1FN _0x0,394
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 041D       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 041E     }
; 0000 041F if(PORT_CZYTNIK.byte == 0x1D)
_0x37:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1D)
	BRNE _0x38
; 0000 0420     {
; 0000 0421       macierz_zaciskow[rzad]=29;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	ST   X+,R30
	ST   X,R31
; 0000 0422       komunikat_z_czytnika_kodow("87-0194",rzad,1);
	__POINTW1FN _0x0,402
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0423       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 0424     }
; 0000 0425 
; 0000 0426 if(PORT_CZYTNIK.byte == 0x1E)
_0x38:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1E)
	BRNE _0x39
; 0000 0427     {
; 0000 0428       macierz_zaciskow[rzad]=30;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   X+,R30
	ST   X,R31
; 0000 0429       komunikat_z_czytnika_kodow("87-1341",rzad,1);
	__POINTW1FN _0x0,410
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 042A       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 042B     }
; 0000 042C if(PORT_CZYTNIK.byte == 0x1F)
_0x39:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1F)
	BRNE _0x3A
; 0000 042D     {
; 0000 042E       macierz_zaciskow[rzad]=31;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	ST   X+,R30
	ST   X,R31
; 0000 042F       komunikat_z_czytnika_kodow("87-1833",rzad,1);
	__POINTW1FN _0x0,418
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0430       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 0431     }
; 0000 0432 
; 0000 0433 if(PORT_CZYTNIK.byte == 0x20)
_0x3A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x20)
	BRNE _0x3B
; 0000 0434     {
; 0000 0435       macierz_zaciskow[rzad]=32;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   X+,R30
	ST   X,R31
; 0000 0436       komunikat_z_czytnika_kodow("87-2180",rzad,0);
	__POINTW1FN _0x0,426
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 0437       srednica_wew_korpusu = 41;
; 0000 0438     }
; 0000 0439 if(PORT_CZYTNIK.byte == 0x21)
_0x3B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x21)
	BRNE _0x3C
; 0000 043A     {
; 0000 043B       macierz_zaciskow[rzad]=33;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	ST   X+,R30
	ST   X,R31
; 0000 043C       komunikat_z_czytnika_kodow("86-0663",rzad,1);
	__POINTW1FN _0x0,434
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 043D       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x33
; 0000 043E     }
; 0000 043F 
; 0000 0440 if(PORT_CZYTNIK.byte == 0x22)
_0x3C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x22)
	BRNE _0x3D
; 0000 0441     {
; 0000 0442       macierz_zaciskow[rzad]=34;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	ST   X+,R30
	ST   X,R31
; 0000 0443       komunikat_z_czytnika_kodow("86-1349",rzad,0);
	__POINTW1FN _0x0,442
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0444       srednica_wew_korpusu = 38;
; 0000 0445     }
; 0000 0446 if(PORT_CZYTNIK.byte == 0x23)
_0x3D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x23)
	BRNE _0x3E
; 0000 0447     {
; 0000 0448       macierz_zaciskow[rzad]=35;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	ST   X+,R30
	ST   X,R31
; 0000 0449       komunikat_z_czytnika_kodow("86-1834",rzad,0);
	__POINTW1FN _0x0,450
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 044A       srednica_wew_korpusu = 34;
; 0000 044B     }
; 0000 044C if(PORT_CZYTNIK.byte == 0x24)
_0x3E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x24)
	BRNE _0x3F
; 0000 044D     {
; 0000 044E       macierz_zaciskow[rzad]=36;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	ST   X+,R30
	ST   X,R31
; 0000 044F       komunikat_z_czytnika_kodow("86-2204",rzad,0);
	__POINTW1FN _0x0,458
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0450       srednica_wew_korpusu = 38;
; 0000 0451     }
; 0000 0452 if(PORT_CZYTNIK.byte == 0x25)
_0x3F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x25)
	BRNE _0x40
; 0000 0453     {
; 0000 0454       macierz_zaciskow[rzad]=37;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(37)
	LDI  R31,HIGH(37)
	ST   X+,R30
	ST   X,R31
; 0000 0455       komunikat_z_czytnika_kodow("87-0663",rzad,0);
	__POINTW1FN _0x0,466
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x34
; 0000 0456       srednica_wew_korpusu = 43;
; 0000 0457     }
; 0000 0458 if(PORT_CZYTNIK.byte == 0x26)
_0x40:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x26)
	BRNE _0x41
; 0000 0459     {
; 0000 045A       macierz_zaciskow[rzad]=38;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	ST   X+,R30
	ST   X,R31
; 0000 045B       komunikat_z_czytnika_kodow("87-1349",rzad,1);
	__POINTW1FN _0x0,474
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 045C       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 045D     }
; 0000 045E if(PORT_CZYTNIK.byte == 0x27)
_0x41:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x27)
	BRNE _0x42
; 0000 045F     {
; 0000 0460       macierz_zaciskow[rzad]=39;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(39)
	LDI  R31,HIGH(39)
	ST   X+,R30
	ST   X,R31
; 0000 0461       komunikat_z_czytnika_kodow("87-1834",rzad,1);
	__POINTW1FN _0x0,482
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0462       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 0463     }
; 0000 0464 if(PORT_CZYTNIK.byte == 0x28)
_0x42:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x28)
	BRNE _0x43
; 0000 0465     {
; 0000 0466       macierz_zaciskow[rzad]=40;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   X+,R30
	ST   X,R31
; 0000 0467       komunikat_z_czytnika_kodow("87-2204",rzad,1);
	__POINTW1FN _0x0,490
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0468       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 0469     }
; 0000 046A if(PORT_CZYTNIK.byte == 0x29)
_0x43:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x29)
	BRNE _0x44
; 0000 046B     {
; 0000 046C       macierz_zaciskow[rzad]=41;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	ST   X+,R30
	ST   X,R31
; 0000 046D       komunikat_z_czytnika_kodow("86-0768",rzad,1);
	__POINTW1FN _0x0,498
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 046E       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 046F     }
; 0000 0470 if(PORT_CZYTNIK.byte == 0x2A)
_0x44:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2A)
	BRNE _0x45
; 0000 0471     {
; 0000 0472       macierz_zaciskow[rzad]=42;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   X+,R30
	ST   X,R31
; 0000 0473       komunikat_z_czytnika_kodow("86-1357",rzad,0);
	__POINTW1FN _0x0,506
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0474       srednica_wew_korpusu = 38;
; 0000 0475     }
; 0000 0476 if(PORT_CZYTNIK.byte == 0x2B)
_0x45:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2B)
	BRNE _0x46
; 0000 0477     {
; 0000 0478       macierz_zaciskow[rzad]=43;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	ST   X+,R30
	ST   X,R31
; 0000 0479       komunikat_z_czytnika_kodow("86-1848",rzad,0);
	__POINTW1FN _0x0,514
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 047A       srednica_wew_korpusu = 38;
; 0000 047B     }
; 0000 047C if(PORT_CZYTNIK.byte == 0x2C)
_0x46:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2C)
	BRNE _0x47
; 0000 047D     {
; 0000 047E      macierz_zaciskow[rzad]=44;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x35
; 0000 047F       macierz_zaciskow[rzad]=0;   ////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x36
; 0000 0480 
; 0000 0481      komunikat_z_czytnika_kodow("86-2212",rzad,0);
	__POINTW1FN _0x0,522
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0482      srednica_wew_korpusu = 38;
; 0000 0483     }
; 0000 0484 if(PORT_CZYTNIK.byte == 0x2D)
_0x47:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2D)
	BRNE _0x48
; 0000 0485     {
; 0000 0486       macierz_zaciskow[rzad]=45;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	ST   X+,R30
	ST   X,R31
; 0000 0487       komunikat_z_czytnika_kodow("87-0768",rzad,0);
	__POINTW1FN _0x0,530
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0488       srednica_wew_korpusu = 38;
; 0000 0489     }
; 0000 048A if(PORT_CZYTNIK.byte == 0x2E)
_0x48:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2E)
	BRNE _0x49
; 0000 048B     {
; 0000 048C       macierz_zaciskow[rzad]=46;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	ST   X+,R30
	ST   X,R31
; 0000 048D       komunikat_z_czytnika_kodow("87-1357",rzad,1);
	__POINTW1FN _0x0,538
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 048E       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 048F     }
; 0000 0490 if(PORT_CZYTNIK.byte == 0x2F)
_0x49:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2F)
	BRNE _0x4A
; 0000 0491     {
; 0000 0492       macierz_zaciskow[rzad]=47;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	ST   X+,R30
	ST   X,R31
; 0000 0493       komunikat_z_czytnika_kodow("87-1848",rzad,1);
	__POINTW1FN _0x0,546
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0494       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 0495     }
; 0000 0496 if(PORT_CZYTNIK.byte == 0x30)
_0x4A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x30)
	BRNE _0x4B
; 0000 0497     {
; 0000 0498       macierz_zaciskow[rzad]=48;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x35
; 0000 0499       macierz_zaciskow[rzad]=0;    /////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x36
; 0000 049A       komunikat_z_czytnika_kodow("87-2212",rzad,1);
	__POINTW1FN _0x0,554
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 049B       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 049C     }
; 0000 049D if(PORT_CZYTNIK.byte == 0x31)
_0x4B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x31)
	BRNE _0x4C
; 0000 049E     {
; 0000 049F       macierz_zaciskow[rzad]=49;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	ST   X+,R30
	ST   X,R31
; 0000 04A0       komunikat_z_czytnika_kodow("86-0800",rzad,0);
	__POINTW1FN _0x0,562
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 04A1       srednica_wew_korpusu = 38;
; 0000 04A2     }
; 0000 04A3 if(PORT_CZYTNIK.byte == 0x32)
_0x4C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x32)
	BRNE _0x4D
; 0000 04A4     {
; 0000 04A5       macierz_zaciskow[rzad]=50;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   X+,R30
	ST   X,R31
; 0000 04A6       komunikat_z_czytnika_kodow("86-1363",rzad,0);
	__POINTW1FN _0x0,570
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 04A7       srednica_wew_korpusu = 34;
; 0000 04A8     }
; 0000 04A9 if(PORT_CZYTNIK.byte == 0x33)
_0x4D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x33)
	BRNE _0x4E
; 0000 04AA     {
; 0000 04AB       macierz_zaciskow[rzad]=51;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	ST   X+,R30
	ST   X,R31
; 0000 04AC       komunikat_z_czytnika_kodow("86-1904",rzad,0);
	__POINTW1FN _0x0,578
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x34
; 0000 04AD       srednica_wew_korpusu = 43;
; 0000 04AE     }
; 0000 04AF if(PORT_CZYTNIK.byte == 0x34)
_0x4E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x34)
	BRNE _0x4F
; 0000 04B0     {
; 0000 04B1       macierz_zaciskow[rzad]=52;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	ST   X+,R30
	ST   X,R31
; 0000 04B2       komunikat_z_czytnika_kodow("86-2241",rzad,1);
	__POINTW1FN _0x0,586
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 04B3       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 04B4     }
; 0000 04B5 if(PORT_CZYTNIK.byte == 0x35)
_0x4F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x35)
	BRNE _0x50
; 0000 04B6     {
; 0000 04B7       macierz_zaciskow[rzad]=53;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(53)
	LDI  R31,HIGH(53)
	ST   X+,R30
	ST   X,R31
; 0000 04B8       komunikat_z_czytnika_kodow("87-0800",rzad,1);
	__POINTW1FN _0x0,594
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 04B9       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 04BA     }
; 0000 04BB 
; 0000 04BC if(PORT_CZYTNIK.byte == 0x36)
_0x50:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x36)
	BRNE _0x51
; 0000 04BD     {
; 0000 04BE       macierz_zaciskow[rzad]=54;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	ST   X+,R30
	ST   X,R31
; 0000 04BF       komunikat_z_czytnika_kodow("87-1363",rzad,1);
	__POINTW1FN _0x0,602
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 04C0       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 04C1     }
; 0000 04C2 if(PORT_CZYTNIK.byte == 0x37)
_0x51:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x37)
	BRNE _0x52
; 0000 04C3     {
; 0000 04C4       macierz_zaciskow[rzad]=55;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	ST   X+,R30
	ST   X,R31
; 0000 04C5       komunikat_z_czytnika_kodow("87-1904",rzad,1);
	__POINTW1FN _0x0,610
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 04C6       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x33
; 0000 04C7     }
; 0000 04C8 if(PORT_CZYTNIK.byte == 0x38)
_0x52:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x38)
	BRNE _0x53
; 0000 04C9     {
; 0000 04CA       macierz_zaciskow[rzad]=56;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	ST   X+,R30
	ST   X,R31
; 0000 04CB       komunikat_z_czytnika_kodow("87-2241",rzad,0);
	__POINTW1FN _0x0,618
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 04CC       srednica_wew_korpusu = 34;
; 0000 04CD     }
; 0000 04CE if(PORT_CZYTNIK.byte == 0x39)
_0x53:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x39)
	BRNE _0x54
; 0000 04CF     {
; 0000 04D0       macierz_zaciskow[rzad]=57;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(57)
	LDI  R31,HIGH(57)
	ST   X+,R30
	ST   X,R31
; 0000 04D1       komunikat_z_czytnika_kodow("86-0811",rzad,0);
	__POINTW1FN _0x0,626
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 04D2       srednica_wew_korpusu = 34;
; 0000 04D3     }
; 0000 04D4 if(PORT_CZYTNIK.byte == 0x3A)
_0x54:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3A)
	BRNE _0x55
; 0000 04D5     {
; 0000 04D6       macierz_zaciskow[rzad]=58;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	ST   X+,R30
	ST   X,R31
; 0000 04D7       komunikat_z_czytnika_kodow("86-1523",rzad,0);
	__POINTW1FN _0x0,634
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 04D8       srednica_wew_korpusu = 38;
; 0000 04D9     }
; 0000 04DA if(PORT_CZYTNIK.byte == 0x3B)
_0x55:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3B)
	BRNE _0x56
; 0000 04DB     {
; 0000 04DC       macierz_zaciskow[rzad]=59;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	ST   X+,R30
	ST   X,R31
; 0000 04DD       komunikat_z_czytnika_kodow("86-1929",rzad,0);
	__POINTW1FN _0x0,642
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 04DE       srednica_wew_korpusu = 41;
; 0000 04DF     }
; 0000 04E0 if(PORT_CZYTNIK.byte == 0x3C)
_0x56:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3C)
	BRNE _0x57
; 0000 04E1     {
; 0000 04E2       macierz_zaciskow[rzad]=60;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	ST   X+,R30
	ST   X,R31
; 0000 04E3       komunikat_z_czytnika_kodow("86-2261",rzad,0);
	__POINTW1FN _0x0,650
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 04E4       srednica_wew_korpusu = 34;
; 0000 04E5     }
; 0000 04E6 if(PORT_CZYTNIK.byte == 0x3D)
_0x57:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3D)
	BRNE _0x58
; 0000 04E7     {
; 0000 04E8       macierz_zaciskow[rzad]=61;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	ST   X+,R30
	ST   X,R31
; 0000 04E9       komunikat_z_czytnika_kodow("87-0811",rzad,1);
	__POINTW1FN _0x0,658
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 04EA       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 04EB     }
; 0000 04EC if(PORT_CZYTNIK.byte == 0x3E)
_0x58:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3E)
	BRNE _0x59
; 0000 04ED     {
; 0000 04EE       macierz_zaciskow[rzad]=62;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	ST   X+,R30
	ST   X,R31
; 0000 04EF       komunikat_z_czytnika_kodow("87-1523",rzad,1);
	__POINTW1FN _0x0,666
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 04F0       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 04F1     }
; 0000 04F2 if(PORT_CZYTNIK.byte == 0x3F)
_0x59:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3F)
	BRNE _0x5A
; 0000 04F3     {
; 0000 04F4       macierz_zaciskow[rzad]=63;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	ST   X+,R30
	ST   X,R31
; 0000 04F5       komunikat_z_czytnika_kodow("87-1929",rzad,1);
	__POINTW1FN _0x0,674
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 04F6       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 04F7     }
; 0000 04F8 if(PORT_CZYTNIK.byte == 0x40)
_0x5A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x40)
	BRNE _0x5B
; 0000 04F9     {
; 0000 04FA       macierz_zaciskow[rzad]=64;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   X+,R30
	ST   X,R31
; 0000 04FB       komunikat_z_czytnika_kodow("87-2261",rzad,1);
	__POINTW1FN _0x0,682
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 04FC       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 04FD     }
; 0000 04FE if(PORT_CZYTNIK.byte == 0x41)
_0x5B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x41)
	BRNE _0x5C
; 0000 04FF     {
; 0000 0500       macierz_zaciskow[rzad]=65;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   X+,R30
	ST   X,R31
; 0000 0501       komunikat_z_czytnika_kodow("86-0814",rzad,0);
	__POINTW1FN _0x0,690
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 0502       srednica_wew_korpusu = 36;
; 0000 0503     }
; 0000 0504 if(PORT_CZYTNIK.byte == 0x42)
_0x5C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x42)
	BRNE _0x5D
; 0000 0505     {
; 0000 0506       macierz_zaciskow[rzad]=66;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	ST   X+,R30
	ST   X,R31
; 0000 0507       komunikat_z_czytnika_kodow("86-1530",rzad,1);
	__POINTW1FN _0x0,698
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0508       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 0509     }
; 0000 050A if(PORT_CZYTNIK.byte == 0x43)
_0x5D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x43)
	BRNE _0x5E
; 0000 050B     {
; 0000 050C       macierz_zaciskow[rzad]=67;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(67)
	LDI  R31,HIGH(67)
	ST   X+,R30
	ST   X,R31
; 0000 050D       komunikat_z_czytnika_kodow("86-1936",rzad,1);
	__POINTW1FN _0x0,706
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 050E       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 050F     }
; 0000 0510 if(PORT_CZYTNIK.byte == 0x44)
_0x5E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x44)
	BRNE _0x5F
; 0000 0511     {
; 0000 0512       macierz_zaciskow[rzad]=68;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   X+,R30
	ST   X,R31
; 0000 0513       komunikat_z_czytnika_kodow("86-2285",rzad,1);
	__POINTW1FN _0x0,714
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0514       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 0515     }
; 0000 0516 if(PORT_CZYTNIK.byte == 0x45)
_0x5F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x45)
	BRNE _0x60
; 0000 0517     {
; 0000 0518       macierz_zaciskow[rzad]=69;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(69)
	LDI  R31,HIGH(69)
	ST   X+,R30
	ST   X,R31
; 0000 0519       komunikat_z_czytnika_kodow("87-0814",rzad,1);
	__POINTW1FN _0x0,722
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 051A       srednica_wew_korpusu = 36;
	CALL SUBOPT_0x38
; 0000 051B     }
; 0000 051C if(PORT_CZYTNIK.byte == 0x46)
_0x60:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x46)
	BRNE _0x61
; 0000 051D     {
; 0000 051E       macierz_zaciskow[rzad]=70;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   X+,R30
	ST   X,R31
; 0000 051F       komunikat_z_czytnika_kodow("87-1530",rzad,0);
	__POINTW1FN _0x0,730
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0520       srednica_wew_korpusu = 38;
; 0000 0521     }
; 0000 0522 if(PORT_CZYTNIK.byte == 0x47)
_0x61:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x47)
	BRNE _0x62
; 0000 0523     {
; 0000 0524       macierz_zaciskow[rzad]=71;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(71)
	LDI  R31,HIGH(71)
	ST   X+,R30
	ST   X,R31
; 0000 0525       komunikat_z_czytnika_kodow("87-1936",rzad,0);
	__POINTW1FN _0x0,738
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0526       srednica_wew_korpusu = 38;
; 0000 0527     }
; 0000 0528 if(PORT_CZYTNIK.byte == 0x48)
_0x62:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x48)
	BRNE _0x63
; 0000 0529     {
; 0000 052A       macierz_zaciskow[rzad]=72;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	ST   X+,R30
	ST   X,R31
; 0000 052B       komunikat_z_czytnika_kodow("87-2285",rzad,0);
	__POINTW1FN _0x0,746
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 052C       srednica_wew_korpusu = 41;
; 0000 052D     }
; 0000 052E if(PORT_CZYTNIK.byte == 0x49)
_0x63:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x49)
	BRNE _0x64
; 0000 052F     {
; 0000 0530       macierz_zaciskow[rzad]=73;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(73)
	LDI  R31,HIGH(73)
	ST   X+,R30
	ST   X,R31
; 0000 0531       komunikat_z_czytnika_kodow("86-0815",rzad,0);
	__POINTW1FN _0x0,754
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0532       srednica_wew_korpusu = 38;
; 0000 0533     }
; 0000 0534 
; 0000 0535 if(PORT_CZYTNIK.byte == 0x4A)
_0x64:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4A)
	BRNE _0x65
; 0000 0536     {
; 0000 0537       macierz_zaciskow[rzad]=74;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	ST   X+,R30
	ST   X,R31
; 0000 0538       komunikat_z_czytnika_kodow("86-1551",rzad,0);
	__POINTW1FN _0x0,762
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0539       srednica_wew_korpusu = 38;
; 0000 053A     }
; 0000 053B if(PORT_CZYTNIK.byte == 0x4B)
_0x65:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4B)
	BRNE _0x66
; 0000 053C     {
; 0000 053D       macierz_zaciskow[rzad]=75;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	ST   X+,R30
	ST   X,R31
; 0000 053E       komunikat_z_czytnika_kodow("86-1941",rzad,0);
	__POINTW1FN _0x0,770
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 053F       srednica_wew_korpusu = 38;
; 0000 0540     }
; 0000 0541 if(PORT_CZYTNIK.byte == 0x4C)
_0x66:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4C)
	BRNE _0x67
; 0000 0542     {
; 0000 0543       macierz_zaciskow[rzad]=76;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x35
; 0000 0544       macierz_zaciskow[rzad]=0;    ////////////////////////////////brak zacisku
	CALL SUBOPT_0x36
; 0000 0545       komunikat_z_czytnika_kodow("86-2286",rzad,0);
	__POINTW1FN _0x0,778
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 0546       srednica_wew_korpusu = 41;
; 0000 0547     }
; 0000 0548 if(PORT_CZYTNIK.byte == 0x4D)
_0x67:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4D)
	BRNE _0x68
; 0000 0549     {
; 0000 054A       macierz_zaciskow[rzad]=77;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(77)
	LDI  R31,HIGH(77)
	ST   X+,R30
	ST   X,R31
; 0000 054B       komunikat_z_czytnika_kodow("87-0815",rzad,1);
	__POINTW1FN _0x0,786
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 054C       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 054D     }
; 0000 054E if(PORT_CZYTNIK.byte == 0x4E)
_0x68:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4E)
	BRNE _0x69
; 0000 054F     {
; 0000 0550       macierz_zaciskow[rzad]=78;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	ST   X+,R30
	ST   X,R31
; 0000 0551       komunikat_z_czytnika_kodow("87-1551",rzad,1);
	__POINTW1FN _0x0,794
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0552       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 0553     }
; 0000 0554 if(PORT_CZYTNIK.byte == 0x4F)
_0x69:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4F)
	BRNE _0x6A
; 0000 0555     {
; 0000 0556       macierz_zaciskow[rzad]=79;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(79)
	LDI  R31,HIGH(79)
	ST   X+,R30
	ST   X,R31
; 0000 0557       komunikat_z_czytnika_kodow("87-1941",rzad,1);
	__POINTW1FN _0x0,802
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0558       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 0559     }
; 0000 055A if(PORT_CZYTNIK.byte == 0x50)
_0x6A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x50)
	BRNE _0x6B
; 0000 055B     {
; 0000 055C       macierz_zaciskow[rzad]=80;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x35
; 0000 055D       macierz_zaciskow[rzad]=0;  ////////////////////////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x36
; 0000 055E       komunikat_z_czytnika_kodow("87-2286",rzad,0);
	__POINTW1FN _0x0,810
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 055F       srednica_wew_korpusu = 41;
; 0000 0560     }
; 0000 0561 if(PORT_CZYTNIK.byte == 0x51)
_0x6B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x51)
	BRNE _0x6C
; 0000 0562     {
; 0000 0563       macierz_zaciskow[rzad]=81;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(81)
	LDI  R31,HIGH(81)
	ST   X+,R30
	ST   X,R31
; 0000 0564       komunikat_z_czytnika_kodow("86-0816",rzad,0);
	__POINTW1FN _0x0,818
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 0565       srednica_wew_korpusu = 36;
; 0000 0566     }
; 0000 0567 if(PORT_CZYTNIK.byte == 0x52)
_0x6C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x52)
	BRNE _0x6D
; 0000 0568     {
; 0000 0569       macierz_zaciskow[rzad]=82;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	ST   X+,R30
	ST   X,R31
; 0000 056A       komunikat_z_czytnika_kodow("86-1552",rzad,0);
	__POINTW1FN _0x0,826
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 056B       srednica_wew_korpusu = 34;
; 0000 056C     }
; 0000 056D if(PORT_CZYTNIK.byte == 0x53)
_0x6D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x53)
	BRNE _0x6E
; 0000 056E     {
; 0000 056F       macierz_zaciskow[rzad]=83;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	ST   X+,R30
	ST   X,R31
; 0000 0570       komunikat_z_czytnika_kodow("86-2007",rzad,1);
	__POINTW1FN _0x0,834
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0571       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 0572     }
; 0000 0573 if(PORT_CZYTNIK.byte == 0x54)
_0x6E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x54)
	BRNE _0x6F
; 0000 0574     {
; 0000 0575       macierz_zaciskow[rzad]=84;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	ST   X+,R30
	ST   X,R31
; 0000 0576       komunikat_z_czytnika_kodow("86-2292",rzad,1);
	__POINTW1FN _0x0,842
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0577       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 0578     }
; 0000 0579 if(PORT_CZYTNIK.byte == 0x55)
_0x6F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x55)
	BRNE _0x70
; 0000 057A     {
; 0000 057B       macierz_zaciskow[rzad]=85;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	ST   X+,R30
	ST   X,R31
; 0000 057C       komunikat_z_czytnika_kodow("87-0816",rzad,1);
	__POINTW1FN _0x0,850
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 057D       srednica_wew_korpusu = 36;
	CALL SUBOPT_0x38
; 0000 057E      }
; 0000 057F if(PORT_CZYTNIK.byte == 0x56)
_0x70:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x56)
	BRNE _0x71
; 0000 0580     {
; 0000 0581       macierz_zaciskow[rzad]=86;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	ST   X+,R30
	ST   X,R31
; 0000 0582       komunikat_z_czytnika_kodow("87-1552",rzad,1);
	__POINTW1FN _0x0,858
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0583       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 0584     }
; 0000 0585 if(PORT_CZYTNIK.byte == 0x57)
_0x71:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x57)
	BRNE _0x72
; 0000 0586     {
; 0000 0587       macierz_zaciskow[rzad]=87;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(87)
	LDI  R31,HIGH(87)
	ST   X+,R30
	ST   X,R31
; 0000 0588       komunikat_z_czytnika_kodow("87-2007",rzad,0);
	__POINTW1FN _0x0,866
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 0589       srednica_wew_korpusu = 41;
; 0000 058A     }
; 0000 058B if(PORT_CZYTNIK.byte == 0x58)
_0x72:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x58)
	BRNE _0x73
; 0000 058C     {
; 0000 058D       macierz_zaciskow[rzad]=88;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	ST   X+,R30
	ST   X,R31
; 0000 058E       komunikat_z_czytnika_kodow("87-2292",rzad,0);
	__POINTW1FN _0x0,874
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 058F       srednica_wew_korpusu = 38;
; 0000 0590     }
; 0000 0591 if(PORT_CZYTNIK.byte == 0x59)
_0x73:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x59)
	BRNE _0x74
; 0000 0592     {
; 0000 0593       macierz_zaciskow[rzad]=89;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(89)
	LDI  R31,HIGH(89)
	ST   X+,R30
	ST   X,R31
; 0000 0594       komunikat_z_czytnika_kodow("86-0817",rzad,0);
	__POINTW1FN _0x0,882
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0595       srednica_wew_korpusu = 38;
; 0000 0596     }
; 0000 0597 if(PORT_CZYTNIK.byte == 0x5A)
_0x74:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5A)
	BRNE _0x75
; 0000 0598     {
; 0000 0599       macierz_zaciskow[rzad]=90;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   X+,R30
	ST   X,R31
; 0000 059A       komunikat_z_czytnika_kodow("86-1602",rzad,1);
	__POINTW1FN _0x0,890
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 059B       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 059C     }
; 0000 059D if(PORT_CZYTNIK.byte == 0x5B)
_0x75:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5B)
	BRNE _0x76
; 0000 059E     {
; 0000 059F       macierz_zaciskow[rzad]=91;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	ST   X+,R30
	ST   X,R31
; 0000 05A0       komunikat_z_czytnika_kodow("86-2017",rzad,1);
	__POINTW1FN _0x0,898
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 05A1       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 05A2     }
; 0000 05A3 if(PORT_CZYTNIK.byte == 0x5C)
_0x76:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5C)
	BRNE _0x77
; 0000 05A4     {
; 0000 05A5       macierz_zaciskow[rzad]=92;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x35
; 0000 05A6       macierz_zaciskow[rzad]=0;           /////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x36
; 0000 05A7       komunikat_z_czytnika_kodow("86-2384",rzad,0);
	__POINTW1FN _0x0,906
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 05A8       srednica_wew_korpusu = 38;
; 0000 05A9     }
; 0000 05AA if(PORT_CZYTNIK.byte == 0x5D)
_0x77:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5D)
	BRNE _0x78
; 0000 05AB     {
; 0000 05AC       macierz_zaciskow[rzad]=93;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(93)
	LDI  R31,HIGH(93)
	ST   X+,R30
	ST   X,R31
; 0000 05AD       komunikat_z_czytnika_kodow("87-0817",rzad,1);
	__POINTW1FN _0x0,914
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 05AE       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 05AF     }
; 0000 05B0 if(PORT_CZYTNIK.byte == 0x5E)
_0x78:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5E)
	BRNE _0x79
; 0000 05B1     {
; 0000 05B2       macierz_zaciskow[rzad]=94;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	ST   X+,R30
	ST   X,R31
; 0000 05B3       komunikat_z_czytnika_kodow("87-1602",rzad,0);
	__POINTW1FN _0x0,922
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 05B4       srednica_wew_korpusu = 38;
; 0000 05B5     }
; 0000 05B6 if(PORT_CZYTNIK.byte == 0x5F)
_0x79:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5F)
	BRNE _0x7A
; 0000 05B7     {
; 0000 05B8       macierz_zaciskow[rzad]=95;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(95)
	LDI  R31,HIGH(95)
	ST   X+,R30
	ST   X,R31
; 0000 05B9       komunikat_z_czytnika_kodow("87-2017",rzad,0);
	__POINTW1FN _0x0,930
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 05BA       srednica_wew_korpusu = 41;
; 0000 05BB     }
; 0000 05BC if(PORT_CZYTNIK.byte == 0x60)
_0x7A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x60)
	BRNE _0x7B
; 0000 05BD     {
; 0000 05BE       macierz_zaciskow[rzad]=96;   ///////////////////////////////////////////////brak zacisku
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x35
; 0000 05BF       macierz_zaciskow[rzad]=0;
	CALL SUBOPT_0x36
; 0000 05C0       komunikat_z_czytnika_kodow("87-2384",rzad,0);
	__POINTW1FN _0x0,938
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 05C1       srednica_wew_korpusu = 38;
; 0000 05C2     }
; 0000 05C3 
; 0000 05C4 if(PORT_CZYTNIK.byte == 0x61)
_0x7B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x61)
	BRNE _0x7C
; 0000 05C5     {
; 0000 05C6       macierz_zaciskow[rzad]=97;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(97)
	LDI  R31,HIGH(97)
	ST   X+,R30
	ST   X,R31
; 0000 05C7       komunikat_z_czytnika_kodow("86-0847",rzad,0);
	__POINTW1FN _0x0,946
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 05C8       srednica_wew_korpusu = 41;
; 0000 05C9     }
; 0000 05CA 
; 0000 05CB if(PORT_CZYTNIK.byte == 0x62)
_0x7C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x62)
	BRNE _0x7D
; 0000 05CC     {
; 0000 05CD       macierz_zaciskow[rzad]=98;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	ST   X+,R30
	ST   X,R31
; 0000 05CE       komunikat_z_czytnika_kodow("86-1620",rzad,0);
	__POINTW1FN _0x0,954
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 05CF       srednica_wew_korpusu = 38;
; 0000 05D0     }
; 0000 05D1 if(PORT_CZYTNIK.byte == 0x63)
_0x7D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x63)
	BRNE _0x7E
; 0000 05D2     {
; 0000 05D3       macierz_zaciskow[rzad]=99;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	ST   X+,R30
	ST   X,R31
; 0000 05D4       komunikat_z_czytnika_kodow("86-2019",rzad,1);
	__POINTW1FN _0x0,962
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 05D5       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 05D6     }
; 0000 05D7 if(PORT_CZYTNIK.byte == 0x64)
_0x7E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x64)
	BRNE _0x7F
; 0000 05D8     {
; 0000 05D9       macierz_zaciskow[rzad]=100;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   X+,R30
	ST   X,R31
; 0000 05DA       komunikat_z_czytnika_kodow("86-2385",rzad,0);
	__POINTW1FN _0x0,970
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 05DB       srednica_wew_korpusu = 38;
; 0000 05DC     }
; 0000 05DD if(PORT_CZYTNIK.byte == 0x65)
_0x7F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x65)
	BRNE _0x80
; 0000 05DE     {
; 0000 05DF       macierz_zaciskow[rzad]=101;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(101)
	LDI  R31,HIGH(101)
	ST   X+,R30
	ST   X,R31
; 0000 05E0       komunikat_z_czytnika_kodow("87-0847",rzad,1);
	__POINTW1FN _0x0,978
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 05E1       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 05E2     }
; 0000 05E3 if(PORT_CZYTNIK.byte == 0x66)
_0x80:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x66)
	BRNE _0x81
; 0000 05E4     {
; 0000 05E5       macierz_zaciskow[rzad]=102;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	ST   X+,R30
	ST   X,R31
; 0000 05E6       komunikat_z_czytnika_kodow("87-1620",rzad,1);
	__POINTW1FN _0x0,986
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 05E7       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 05E8     }
; 0000 05E9 if(PORT_CZYTNIK.byte == 0x67)
_0x81:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x67)
	BRNE _0x82
; 0000 05EA     {
; 0000 05EB       macierz_zaciskow[rzad]=103;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	ST   X+,R30
	ST   X,R31
; 0000 05EC       komunikat_z_czytnika_kodow("87-2019",rzad,0);
	__POINTW1FN _0x0,994
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 05ED       srednica_wew_korpusu = 41;
; 0000 05EE     }
; 0000 05EF if(PORT_CZYTNIK.byte == 0x68)
_0x82:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x68)
	BRNE _0x83
; 0000 05F0     {
; 0000 05F1       macierz_zaciskow[rzad]=104;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	ST   X+,R30
	ST   X,R31
; 0000 05F2       komunikat_z_czytnika_kodow("87-2385",rzad,1);
	__POINTW1FN _0x0,1002
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 05F3       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 05F4     }
; 0000 05F5 if(PORT_CZYTNIK.byte == 0x69)
_0x83:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x69)
	BRNE _0x84
; 0000 05F6     {
; 0000 05F7       macierz_zaciskow[rzad]=105;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(105)
	LDI  R31,HIGH(105)
	ST   X+,R30
	ST   X,R31
; 0000 05F8       komunikat_z_czytnika_kodow("86-0854",rzad,0);
	__POINTW1FN _0x0,1010
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 05F9       srednica_wew_korpusu = 34;
; 0000 05FA     }
; 0000 05FB if(PORT_CZYTNIK.byte == 0x6A)
_0x84:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6A)
	BRNE _0x85
; 0000 05FC     {
; 0000 05FD       macierz_zaciskow[rzad]=106;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	ST   X+,R30
	ST   X,R31
; 0000 05FE       komunikat_z_czytnika_kodow("86-1622",rzad,1);
	__POINTW1FN _0x0,1018
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 05FF       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 0600     }
; 0000 0601 if(PORT_CZYTNIK.byte == 0x6B)
_0x85:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6B)
	BRNE _0x86
; 0000 0602     {
; 0000 0603       macierz_zaciskow[rzad]=107;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(107)
	LDI  R31,HIGH(107)
	CALL SUBOPT_0x35
; 0000 0604       macierz_zaciskow[rzad]=0;          //brak zacisku
	CALL SUBOPT_0x36
; 0000 0605       komunikat_z_czytnika_kodow("86-2028",rzad,0);
	__POINTW1FN _0x0,1026
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x34
; 0000 0606       srednica_wew_korpusu = 43;
; 0000 0607     }
; 0000 0608 if(PORT_CZYTNIK.byte == 0x6C)
_0x86:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6C)
	BRNE _0x87
; 0000 0609     {
; 0000 060A       macierz_zaciskow[rzad]=108;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	ST   X+,R30
	ST   X,R31
; 0000 060B       komunikat_z_czytnika_kodow("86-2437",rzad,0);
	__POINTW1FN _0x0,1034
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 060C       srednica_wew_korpusu = 38;
; 0000 060D     }
; 0000 060E if(PORT_CZYTNIK.byte == 0x6D)
_0x87:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6D)
	BRNE _0x88
; 0000 060F     {
; 0000 0610       macierz_zaciskow[rzad]=109;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(109)
	LDI  R31,HIGH(109)
	ST   X+,R30
	ST   X,R31
; 0000 0611       komunikat_z_czytnika_kodow("87-0854",rzad,1);
	__POINTW1FN _0x0,1042
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0612       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 0613     }
; 0000 0614 if(PORT_CZYTNIK.byte == 0x6E)
_0x88:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6E)
	BRNE _0x89
; 0000 0615     {
; 0000 0616       macierz_zaciskow[rzad]=110;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	ST   X+,R30
	ST   X,R31
; 0000 0617       komunikat_z_czytnika_kodow("87-1622",rzad,0);
	__POINTW1FN _0x0,1050
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 0618       srednica_wew_korpusu = 34;
; 0000 0619     }
; 0000 061A 
; 0000 061B if(PORT_CZYTNIK.byte == 0x6F)
_0x89:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6F)
	BRNE _0x8A
; 0000 061C     {
; 0000 061D       macierz_zaciskow[rzad]=111;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(111)
	LDI  R31,HIGH(111)
	CALL SUBOPT_0x35
; 0000 061E       macierz_zaciskow[rzad]=0;      //brak zacisku
	CALL SUBOPT_0x36
; 0000 061F       komunikat_z_czytnika_kodow("87-2028",rzad,0);
	__POINTW1FN _0x0,1058
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x34
; 0000 0620       srednica_wew_korpusu = 43;
; 0000 0621     }
; 0000 0622 
; 0000 0623 if(PORT_CZYTNIK.byte == 0x70)
_0x8A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x70)
	BRNE _0x8B
; 0000 0624     {
; 0000 0625       macierz_zaciskow[rzad]=112;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   X+,R30
	ST   X,R31
; 0000 0626       komunikat_z_czytnika_kodow("87-2437",rzad,1);
	__POINTW1FN _0x0,1066
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0627       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 0628     }
; 0000 0629 if(PORT_CZYTNIK.byte == 0x71)
_0x8B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x71)
	BRNE _0x8C
; 0000 062A     {
; 0000 062B       macierz_zaciskow[rzad]=113;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   X+,R30
	ST   X,R31
; 0000 062C       komunikat_z_czytnika_kodow("86-0862",rzad,0);
	__POINTW1FN _0x0,1074
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 062D       srednica_wew_korpusu = 38;
; 0000 062E     }
; 0000 062F if(PORT_CZYTNIK.byte == 0x72)
_0x8C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x72)
	BRNE _0x8D
; 0000 0630     {
; 0000 0631       macierz_zaciskow[rzad]=114;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	ST   X+,R30
	ST   X,R31
; 0000 0632       komunikat_z_czytnika_kodow("86-1625",rzad,0);
	__POINTW1FN _0x0,1082
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0633       srednica_wew_korpusu = 38;
; 0000 0634     }
; 0000 0635 if(PORT_CZYTNIK.byte == 0x73)
_0x8D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x73)
	BRNE _0x8E
; 0000 0636     {
; 0000 0637       macierz_zaciskow[rzad]=115;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(115)
	LDI  R31,HIGH(115)
	ST   X+,R30
	ST   X,R31
; 0000 0638       komunikat_z_czytnika_kodow("86-2052",rzad,0);
	__POINTW1FN _0x0,1090
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x34
; 0000 0639       srednica_wew_korpusu = 43;
; 0000 063A     }
; 0000 063B if(PORT_CZYTNIK.byte == 0x74)
_0x8E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x74)
	BRNE _0x8F
; 0000 063C     {
; 0000 063D       macierz_zaciskow[rzad]=116;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	ST   X+,R30
	ST   X,R31
; 0000 063E       komunikat_z_czytnika_kodow("86-2492",rzad,1);
	__POINTW1FN _0x0,1098
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 063F       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 0640     }
; 0000 0641 if(PORT_CZYTNIK.byte == 0x75)
_0x8F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x75)
	BRNE _0x90
; 0000 0642     {
; 0000 0643       macierz_zaciskow[rzad]=117;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(117)
	LDI  R31,HIGH(117)
	ST   X+,R30
	ST   X,R31
; 0000 0644       komunikat_z_czytnika_kodow("87-0862",rzad,1);
	__POINTW1FN _0x0,1106
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0645       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 0646     }
; 0000 0647 if(PORT_CZYTNIK.byte == 0x76)
_0x90:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x76)
	BRNE _0x91
; 0000 0648     {
; 0000 0649       macierz_zaciskow[rzad]=118;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	ST   X+,R30
	ST   X,R31
; 0000 064A       komunikat_z_czytnika_kodow("87-1625",rzad,1);
	__POINTW1FN _0x0,1114
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 064B       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 064C     }
; 0000 064D if(PORT_CZYTNIK.byte == 0x77)
_0x91:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x77)
	BRNE _0x92
; 0000 064E     {
; 0000 064F       macierz_zaciskow[rzad]=119;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   X+,R30
	ST   X,R31
; 0000 0650       komunikat_z_czytnika_kodow("87-2052",rzad,1);
	__POINTW1FN _0x0,1122
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0651       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x33
; 0000 0652     }
; 0000 0653 if(PORT_CZYTNIK.byte == 0x78)
_0x92:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x78)
	BRNE _0x93
; 0000 0654     {
; 0000 0655       macierz_zaciskow[rzad]=120;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   X+,R30
	ST   X,R31
; 0000 0656       komunikat_z_czytnika_kodow("87-2492",rzad,0);
	__POINTW1FN _0x0,1130
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0657       srednica_wew_korpusu = 38;
; 0000 0658     }
; 0000 0659 if(PORT_CZYTNIK.byte == 0x79)
_0x93:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x79)
	BRNE _0x94
; 0000 065A     {
; 0000 065B       macierz_zaciskow[rzad]=121;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   X+,R30
	ST   X,R31
; 0000 065C       komunikat_z_czytnika_kodow("86-0935",rzad,0);
	__POINTW1FN _0x0,1138
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 065D       srednica_wew_korpusu = 38;
; 0000 065E     }
; 0000 065F if(PORT_CZYTNIK.byte == 0x7A)
_0x94:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7A)
	BRNE _0x95
; 0000 0660     {
; 0000 0661       macierz_zaciskow[rzad]=122;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	ST   X+,R30
	ST   X,R31
; 0000 0662       komunikat_z_czytnika_kodow("86-1648",rzad,0);
	__POINTW1FN _0x0,1146
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0663       srednica_wew_korpusu = 38;
; 0000 0664     }
; 0000 0665 if(PORT_CZYTNIK.byte == 0x7B)
_0x95:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7B)
	BRNE _0x96
; 0000 0666     {
; 0000 0667       macierz_zaciskow[rzad]=123;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(123)
	LDI  R31,HIGH(123)
	ST   X+,R30
	ST   X,R31
; 0000 0668       komunikat_z_czytnika_kodow("86-2082",rzad,0);
	__POINTW1FN _0x0,1154
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 0669       srednica_wew_korpusu = 36;
; 0000 066A     }
; 0000 066B if(PORT_CZYTNIK.byte == 0x7C)
_0x96:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7C)
	BRNE _0x97
; 0000 066C     {
; 0000 066D       macierz_zaciskow[rzad]=124;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	ST   X+,R30
	ST   X,R31
; 0000 066E       komunikat_z_czytnika_kodow("86-2500",rzad,0);
	__POINTW1FN _0x0,1162
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 066F       srednica_wew_korpusu = 38;
; 0000 0670     }
; 0000 0671 if(PORT_CZYTNIK.byte == 0x7D)
_0x97:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7D)
	BRNE _0x98
; 0000 0672     {
; 0000 0673       macierz_zaciskow[rzad]=125;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   X+,R30
	ST   X,R31
; 0000 0674       komunikat_z_czytnika_kodow("87-0935",rzad,1);
	__POINTW1FN _0x0,1170
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0675       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 0676     }
; 0000 0677 if(PORT_CZYTNIK.byte == 0x7E)
_0x98:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7E)
	BRNE _0x99
; 0000 0678     {
; 0000 0679       macierz_zaciskow[rzad]=126;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	ST   X+,R30
	ST   X,R31
; 0000 067A       komunikat_z_czytnika_kodow("87-1648",rzad,1);
	__POINTW1FN _0x0,1178
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 067B       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 067C     }
; 0000 067D 
; 0000 067E if(PORT_CZYTNIK.byte == 0x7F)
_0x99:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7F)
	BRNE _0x9A
; 0000 067F     {
; 0000 0680       macierz_zaciskow[rzad]=127;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	ST   X+,R30
	ST   X,R31
; 0000 0681       komunikat_z_czytnika_kodow("87-2082",rzad,1);
	__POINTW1FN _0x0,1186
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0682       srednica_wew_korpusu = 36;
	CALL SUBOPT_0x38
; 0000 0683     }
; 0000 0684 if(PORT_CZYTNIK.byte == 0x80)
_0x9A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x80)
	BRNE _0x9B
; 0000 0685     {
; 0000 0686       macierz_zaciskow[rzad]=128;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   X+,R30
	ST   X,R31
; 0000 0687       komunikat_z_czytnika_kodow("87-2500",rzad,1);
	__POINTW1FN _0x0,1194
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0688       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 0689     }
; 0000 068A if(PORT_CZYTNIK.byte == 0x81)
_0x9B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x81)
	BRNE _0x9C
; 0000 068B     {
; 0000 068C       macierz_zaciskow[rzad]=129;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(129)
	LDI  R31,HIGH(129)
	ST   X+,R30
	ST   X,R31
; 0000 068D       komunikat_z_czytnika_kodow("86-1019",rzad,0);
	__POINTW1FN _0x0,1202
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x31
; 0000 068E       srednica_wew_korpusu = 41;
; 0000 068F     }
; 0000 0690 if(PORT_CZYTNIK.byte == 0x82)
_0x9C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x82)
	BRNE _0x9D
; 0000 0691     {
; 0000 0692       macierz_zaciskow[rzad]=130;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	ST   X+,R30
	ST   X,R31
; 0000 0693       komunikat_z_czytnika_kodow("86-1649",rzad,0);
	__POINTW1FN _0x0,1210
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 0694       srednica_wew_korpusu = 38;
; 0000 0695     }
; 0000 0696 if(PORT_CZYTNIK.byte == 0x83)
_0x9D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x83)
	BRNE _0x9E
; 0000 0697     {
; 0000 0698       macierz_zaciskow[rzad]=131;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(131)
	LDI  R31,HIGH(131)
	ST   X+,R30
	ST   X,R31
; 0000 0699       komunikat_z_czytnika_kodow("86-2083",rzad,1);
	__POINTW1FN _0x0,1218
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 069A       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x33
; 0000 069B     }
; 0000 069C if(PORT_CZYTNIK.byte == 0x84)
_0x9E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x84)
	BRNE _0x9F
; 0000 069D     {
; 0000 069E       macierz_zaciskow[rzad]=132;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	ST   X+,R30
	ST   X,R31
; 0000 069F       komunikat_z_czytnika_kodow("86-2585",rzad,0);
	__POINTW1FN _0x0,1226
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x34
; 0000 06A0       srednica_wew_korpusu = 43;
; 0000 06A1     }
; 0000 06A2 if(PORT_CZYTNIK.byte == 0x85)
_0x9F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x85)
	BRNE _0xA0
; 0000 06A3     {
; 0000 06A4       macierz_zaciskow[rzad]=133;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(133)
	LDI  R31,HIGH(133)
	ST   X+,R30
	ST   X,R31
; 0000 06A5       komunikat_z_czytnika_kodow("87-1019",rzad,1);
	__POINTW1FN _0x0,1234
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 06A6       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x32
; 0000 06A7     }
; 0000 06A8 if(PORT_CZYTNIK.byte == 0x86)
_0xA0:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x86)
	BRNE _0xA1
; 0000 06A9     {
; 0000 06AA       macierz_zaciskow[rzad]=134;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	ST   X+,R30
	ST   X,R31
; 0000 06AB       komunikat_z_czytnika_kodow("87-1649",rzad,1);
	__POINTW1FN _0x0,1242
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 06AC       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 06AD     }
; 0000 06AE if(PORT_CZYTNIK.byte == 0x87)
_0xA1:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x87)
	BRNE _0xA2
; 0000 06AF     {
; 0000 06B0       macierz_zaciskow[rzad]=135;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(135)
	LDI  R31,HIGH(135)
	ST   X+,R30
	ST   X,R31
; 0000 06B1       komunikat_z_czytnika_kodow("87-2083",rzad,0);
	__POINTW1FN _0x0,1250
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x34
; 0000 06B2       srednica_wew_korpusu = 43;
; 0000 06B3     }
; 0000 06B4 
; 0000 06B5 if(PORT_CZYTNIK.byte == 0x88)
_0xA2:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x88)
	BRNE _0xA3
; 0000 06B6     {
; 0000 06B7       macierz_zaciskow[rzad]=136;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	ST   X+,R30
	ST   X,R31
; 0000 06B8       komunikat_z_czytnika_kodow("87-2624",rzad,1);
	__POINTW1FN _0x0,1258
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 06B9       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 06BA     }
; 0000 06BB if(PORT_CZYTNIK.byte == 0x89)
_0xA3:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x89)
	BRNE _0xA4
; 0000 06BC     {
; 0000 06BD       macierz_zaciskow[rzad]=137;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(137)
	LDI  R31,HIGH(137)
	ST   X+,R30
	ST   X,R31
; 0000 06BE       komunikat_z_czytnika_kodow("86-1027",rzad,0);
	__POINTW1FN _0x0,1266
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 06BF       srednica_wew_korpusu = 34;
; 0000 06C0     }
; 0000 06C1 if(PORT_CZYTNIK.byte == 0x8A)
_0xA4:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8A)
	BRNE _0xA5
; 0000 06C2     {
; 0000 06C3       macierz_zaciskow[rzad]=138;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	ST   X+,R30
	ST   X,R31
; 0000 06C4       komunikat_z_czytnika_kodow("86-1669",rzad,1);
	__POINTW1FN _0x0,1274
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 06C5       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 06C6     }
; 0000 06C7 if(PORT_CZYTNIK.byte == 0x8B)
_0xA5:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8B)
	BRNE _0xA6
; 0000 06C8     {
; 0000 06C9       macierz_zaciskow[rzad]=139;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(139)
	LDI  R31,HIGH(139)
	ST   X+,R30
	ST   X,R31
; 0000 06CA       komunikat_z_czytnika_kodow("86-2087",rzad,1);
	__POINTW1FN _0x0,1282
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 06CB       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x2D
; 0000 06CC     }
; 0000 06CD if(PORT_CZYTNIK.byte == 0x8C)
_0xA6:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8C)
	BRNE _0xA7
; 0000 06CE     {
; 0000 06CF       macierz_zaciskow[rzad]=140;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	ST   X+,R30
	ST   X,R31
; 0000 06D0       komunikat_z_czytnika_kodow("86-2624",rzad,0);
	__POINTW1FN _0x0,1290
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2E
; 0000 06D1       srednica_wew_korpusu = 34;
; 0000 06D2     }
; 0000 06D3 if(PORT_CZYTNIK.byte == 0x8D)
_0xA7:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8D)
	BRNE _0xA8
; 0000 06D4     {
; 0000 06D5       macierz_zaciskow[rzad]=141;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(141)
	LDI  R31,HIGH(141)
	ST   X+,R30
	ST   X,R31
; 0000 06D6       komunikat_z_czytnika_kodow("87-1027",rzad,1);
	__POINTW1FN _0x0,1298
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 06D7       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x30
; 0000 06D8     }
; 0000 06D9 if(PORT_CZYTNIK.byte == 0x8E)
_0xA8:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8E)
	BRNE _0xA9
; 0000 06DA     {
; 0000 06DB       macierz_zaciskow[rzad]=142;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	ST   X+,R30
	ST   X,R31
; 0000 06DC       komunikat_z_czytnika_kodow("87-1669",rzad,0);
	__POINTW1FN _0x0,1306
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 06DD       srednica_wew_korpusu = 38;
; 0000 06DE     }
; 0000 06DF if(PORT_CZYTNIK.byte == 0x8F)
_0xA9:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8F)
	BRNE _0xAA
; 0000 06E0     {
; 0000 06E1       macierz_zaciskow[rzad]=143;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(143)
	LDI  R31,HIGH(143)
	ST   X+,R30
	ST   X,R31
; 0000 06E2       komunikat_z_czytnika_kodow("87-2087",rzad,0);
	__POINTW1FN _0x0,1314
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2F
; 0000 06E3       srednica_wew_korpusu = 38;
; 0000 06E4     }
; 0000 06E5 if(PORT_CZYTNIK.byte == 0x90)
_0xAA:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x90)
	BRNE _0xAB
; 0000 06E6     {
; 0000 06E7       macierz_zaciskow[rzad]=144;
	MOVW R30,R16
	CALL SUBOPT_0xD
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   X+,R30
	ST   X,R31
; 0000 06E8       komunikat_z_czytnika_kodow("87-2585",rzad,1);
	__POINTW1FN _0x0,1322
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 06E9       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x33
; 0000 06EA     }
; 0000 06EB 
; 0000 06EC 
; 0000 06ED return rzad;
_0xAB:
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 06EE }
;
;
;void wybor_linijek_sterownikow(int rzad_local)
; 0000 06F2 {
_wybor_linijek_sterownikow:
; 0000 06F3 //zaczynam od tego
; 0000 06F4 //komentarz: celowo upraszam:
; 0000 06F5 //  a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 06F6 //a[4] = 0x21;    //ster3 ABS             //krazek scierny
; 0000 06F7 
; 0000 06F8 //legenda pierwotna
; 0000 06F9             /*
; 0000 06FA             a[0] = 0x05A;   //ster1
; 0000 06FB             a[1] = a[0]+0x001;                                   //0x05B;   //ster2
; 0000 06FC             a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 06FD             a[3] = 0x11;    //ster4 INV             //druciak
; 0000 06FE             a[4] = a[2];   //0x21;    //ster3 ABS             //krazek scierny
; 0000 06FF             a[5] = 0x196;   //delta okrag
; 0000 0700             a[6] = a[5]+0x001;            //0x197;   //okrag
; 0000 0701             a[7] = 0x12;    //ster3 INV             krazek scierny
; 0000 0702             a[8] = a[6]+0x001;                0x198;   //-delta okrag
; 0000 0703             a[9] = 0;          //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0704             */
; 0000 0705 
; 0000 0706 
; 0000 0707 //macierz_zaciskow[rzad_local]
; 0000 0708 //macierz_zaciskow[rzad_local] = 140;
; 0000 0709 
; 0000 070A 
; 0000 070B 
; 0000 070C 
; 0000 070D 
; 0000 070E 
; 0000 070F switch(macierz_zaciskow[rzad_local])
;	rzad_local -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0xD
	CALL __GETW1P
; 0000 0710 {
; 0000 0711     case 0:
	SBIW R30,0
	BRNE _0xAF
; 0000 0712 
; 0000 0713             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 0714             komunikat_na_panel("Nie wczytano zacisku",adr1,adr2);
	__POINTW1FN _0x0,1330
	CALL SUBOPT_0x26
; 0000 0715 
; 0000 0716     break;
	JMP  _0xAE
; 0000 0717 
; 0000 0718 
; 0000 0719      case 1:
_0xAF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB0
; 0000 071A 
; 0000 071B             a[0] = 0x0C8;   //ster1
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x39
; 0000 071C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 071D             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 071E             a[5] = 0x196;   //delta okrag
; 0000 071F             a[7] = 0x11;    //ster3 INV krazek scierny
	JMP  _0x51A
; 0000 0720             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0721 
; 0000 0722             a[1] = a[0]+0x001;  //ster2
; 0000 0723             a[2] = a[4];        //ster4 ABS druciak
; 0000 0724             a[6] = a[5]+0x001;  //okrag
; 0000 0725             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0726 
; 0000 0727     break;
; 0000 0728 
; 0000 0729       case 2:
_0xB0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB1
; 0000 072A 
; 0000 072B             a[0] = 0x110;   //ster1
	LDI  R30,LOW(272)
	LDI  R31,HIGH(272)
	CALL SUBOPT_0x39
; 0000 072C             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 072D             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 072E             a[5] = 0x190;   //delta okrag
; 0000 072F             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3C
; 0000 0730             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3E
	JMP  _0x51B
; 0000 0731 
; 0000 0732             a[1] = a[0]+0x001;  //ster2
; 0000 0733             a[2] = a[4];        //ster4 ABS druciak
; 0000 0734             a[6] = a[5]+0x001;  //okrag
; 0000 0735             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0736 
; 0000 0737     break;
; 0000 0738 
; 0000 0739       case 3:
_0xB1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xB2
; 0000 073A 
; 0000 073B             a[0] = 0x07A;   //ster1
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	CALL SUBOPT_0x39
; 0000 073C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 073D             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 073E             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x40
; 0000 073F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0740             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x51B
; 0000 0741 
; 0000 0742             a[1] = a[0]+0x001;  //ster2
; 0000 0743             a[2] = a[4];        //ster4 ABS druciak
; 0000 0744             a[6] = a[5]+0x001;  //okrag
; 0000 0745             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0746 
; 0000 0747     break;
; 0000 0748 
; 0000 0749       case 4:
_0xB2:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xB3
; 0000 074A 
; 0000 074B             a[0] = 0x102;   //ster1
	LDI  R30,LOW(258)
	LDI  R31,HIGH(258)
	CALL SUBOPT_0x39
; 0000 074C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 074D             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 074E             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x40
; 0000 074F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0750             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x51B
; 0000 0751 
; 0000 0752             a[1] = a[0]+0x001;  //ster2
; 0000 0753             a[2] = a[4];        //ster4 ABS druciak
; 0000 0754             a[6] = a[5]+0x001;  //okrag
; 0000 0755             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0756 
; 0000 0757     break;
; 0000 0758 
; 0000 0759       case 5:
_0xB3:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xB4
; 0000 075A 
; 0000 075B             a[0] = 0x0B0;   //ster1
	LDI  R30,LOW(176)
	LDI  R31,HIGH(176)
	CALL SUBOPT_0x39
; 0000 075C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 075D             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 075E             a[5] = 0x196;   //delta okrag
; 0000 075F             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0760             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0761 
; 0000 0762             a[1] = a[0]+0x001;  //ster2
; 0000 0763             a[2] = a[4];        //ster4 ABS druciak
; 0000 0764             a[6] = a[5]+0x001;  //okrag
; 0000 0765             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0766 
; 0000 0767     break;
; 0000 0768 
; 0000 0769       case 6:
_0xB4:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xB5
; 0000 076A 
; 0000 076B             a[0] = 0x0FE;   //ster1
	LDI  R30,LOW(254)
	LDI  R31,HIGH(254)
	CALL SUBOPT_0x39
; 0000 076C             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 076D             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 076E             a[5] = 0x190;   //delta okrag
; 0000 076F             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x51A
; 0000 0770             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0771 
; 0000 0772             a[1] = a[0]+0x001;  //ster2
; 0000 0773             a[2] = a[4];        //ster4 ABS druciak
; 0000 0774             a[6] = a[5]+0x001;  //okrag
; 0000 0775             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0776 
; 0000 0777     break;
; 0000 0778 
; 0000 0779 
; 0000 077A       case 7:
_0xB5:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xB6
; 0000 077B 
; 0000 077C             a[0] = 0x078;   //ster1
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x39
; 0000 077D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 077E             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 077F             a[5] = 0x196;   //delta okrag
	RJMP _0x51C
; 0000 0780             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0781             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0782 
; 0000 0783             a[1] = a[0]+0x001;  //ster2
; 0000 0784             a[2] = a[4];        //ster4 ABS druciak
; 0000 0785             a[6] = a[5]+0x001;  //okrag
; 0000 0786             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0787 
; 0000 0788     break;
; 0000 0789 
; 0000 078A 
; 0000 078B       case 8:
_0xB6:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xB7
; 0000 078C 
; 0000 078D             a[0] = 0x0C0;   //ster1
	LDI  R30,LOW(192)
	LDI  R31,HIGH(192)
	CALL SUBOPT_0x39
; 0000 078E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 078F             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0790             a[5] = 0x196;   //delta okrag
	RJMP _0x51C
; 0000 0791             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0792             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0793 
; 0000 0794             a[1] = a[0]+0x001;  //ster2
; 0000 0795             a[2] = a[4];        //ster4 ABS druciak
; 0000 0796             a[6] = a[5]+0x001;  //okrag
; 0000 0797             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0798 
; 0000 0799     break;
; 0000 079A 
; 0000 079B 
; 0000 079C       case 9:
_0xB7:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xB8
; 0000 079D 
; 0000 079E             a[0] = 0x018;   //ster1
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL SUBOPT_0x39
; 0000 079F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 07A0             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 07A1             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x43
; 0000 07A2             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 07A3             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 07A4 
; 0000 07A5             a[1] = a[0]+0x001;  //ster2
; 0000 07A6             a[2] = a[4];        //ster4 ABS druciak
; 0000 07A7             a[6] = a[5]+0x001;  //okrag
; 0000 07A8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07A9 
; 0000 07AA     break;
; 0000 07AB 
; 0000 07AC 
; 0000 07AD       case 10:
_0xB8:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xB9
; 0000 07AE 
; 0000 07AF             a[0] = 0x016;   //ster1
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CALL SUBOPT_0x39
; 0000 07B0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 07B1             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 07B2             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x40
; 0000 07B3             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07B4             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 07B5 
; 0000 07B6             a[1] = a[0]+0x001;  //ster2
; 0000 07B7             a[2] = a[4];        //ster4 ABS druciak
; 0000 07B8             a[6] = a[5]+0x001;  //okrag
; 0000 07B9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07BA 
; 0000 07BB     break;
; 0000 07BC 
; 0000 07BD 
; 0000 07BE       case 11:
_0xB9:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xBA
; 0000 07BF 
; 0000 07C0             a[0] = 0x074;   //ster1
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	CALL SUBOPT_0x39
; 0000 07C1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 07C2             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 07C3             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x40
; 0000 07C4             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07C5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 07C6 
; 0000 07C7             a[1] = a[0]+0x001;  //ster2
; 0000 07C8             a[2] = a[4];        //ster4 ABS druciak
; 0000 07C9             a[6] = a[5]+0x001;  //okrag
; 0000 07CA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07CB 
; 0000 07CC     break;
; 0000 07CD 
; 0000 07CE 
; 0000 07CF       case 12:
_0xBA:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xBB
; 0000 07D0 
; 0000 07D1             a[0] = 0x096;   //ster1
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x39
; 0000 07D2             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 07D3             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x46
; 0000 07D4             a[5] = 0x199;   //delta okrag
	RJMP _0x51C
; 0000 07D5             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07D6             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07D7 
; 0000 07D8             a[1] = a[0]+0x001;  //ster2
; 0000 07D9             a[2] = a[4];        //ster4 ABS druciak
; 0000 07DA             a[6] = a[5]+0x001;  //okrag
; 0000 07DB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07DC 
; 0000 07DD     break;
; 0000 07DE 
; 0000 07DF 
; 0000 07E0       case 13:
_0xBB:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xBC
; 0000 07E1 
; 0000 07E2             a[0] = 0x01A;   //ster1
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	CALL SUBOPT_0x39
; 0000 07E3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 07E4             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 07E5             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x43
; 0000 07E6             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 07E7             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07E8 
; 0000 07E9             a[1] = a[0]+0x001;  //ster2
; 0000 07EA             a[2] = a[4];        //ster4 ABS druciak
; 0000 07EB             a[6] = a[5]+0x001;  //okrag
; 0000 07EC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07ED 
; 0000 07EE     break;
; 0000 07EF 
; 0000 07F0 
; 0000 07F1       case 14:
_0xBC:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xBD
; 0000 07F2 
; 0000 07F3             a[0] = 0x05E;   //ster1
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	CALL SUBOPT_0x39
; 0000 07F4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 07F5             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 07F6             a[5] = 0x199;   //delta okrag
	RJMP _0x51C
; 0000 07F7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07F8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07F9 
; 0000 07FA             a[1] = a[0]+0x001;  //ster2
; 0000 07FB             a[2] = a[4];        //ster4 ABS druciak
; 0000 07FC             a[6] = a[5]+0x001;  //okrag
; 0000 07FD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07FE 
; 0000 07FF     break;
; 0000 0800 
; 0000 0801 
; 0000 0802       case 15:
_0xBD:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xBE
; 0000 0803 
; 0000 0804             a[0] = 0x084;   //ster1
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	CALL SUBOPT_0x39
; 0000 0805             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0806             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0807             a[5] = 0x199;   //delta okrag
	RJMP _0x51C
; 0000 0808             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0809             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 080A 
; 0000 080B             a[1] = a[0]+0x001;  //ster2
; 0000 080C             a[2] = a[4];        //ster4 ABS druciak
; 0000 080D             a[6] = a[5]+0x001;  //okrag
; 0000 080E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 080F 
; 0000 0810     break;
; 0000 0811 
; 0000 0812 
; 0000 0813       case 16:
_0xBE:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xBF
; 0000 0814 
; 0000 0815             a[0] = 0x0B8;   //ster1
	LDI  R30,LOW(184)
	LDI  R31,HIGH(184)
	CALL SUBOPT_0x39
; 0000 0816             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0817             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 0818             a[5] = 0x199;   //delta okrag
; 0000 0819             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 081A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 081B 
; 0000 081C             a[1] = a[0]+0x001;  //ster2
; 0000 081D             a[2] = a[4];        //ster4 ABS druciak
; 0000 081E             a[6] = a[5]+0x001;  //okrag
; 0000 081F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0820 
; 0000 0821     break;
; 0000 0822 
; 0000 0823       case 17:
_0xBF:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xC0
; 0000 0824 
; 0000 0825             a[0] = 0x020;   //ster1
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x39
; 0000 0826             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0827             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0828             a[5] = 0x196;   //delta okrag
; 0000 0829             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 082A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 082B 
; 0000 082C             a[1] = a[0]+0x001;  //ster2
; 0000 082D             a[2] = a[4];        //ster4 ABS druciak
; 0000 082E             a[6] = a[5]+0x001;  //okrag
; 0000 082F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0830 
; 0000 0831     break;
; 0000 0832 
; 0000 0833 
; 0000 0834       case 18:
_0xC0:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xC1
; 0000 0835 
; 0000 0836             a[0] = 0x098;   //ster1
	LDI  R30,LOW(152)
	LDI  R31,HIGH(152)
	CALL SUBOPT_0x39
; 0000 0837             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 0838             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0839             a[5] = 0x190;   //delta okrag
; 0000 083A             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3C
; 0000 083B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3E
	RJMP _0x51B
; 0000 083C 
; 0000 083D             a[1] = a[0]+0x001;  //ster2
; 0000 083E             a[2] = a[4];        //ster4 ABS druciak
; 0000 083F             a[6] = a[5]+0x001;  //okrag
; 0000 0840             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0841 
; 0000 0842     break;
; 0000 0843 
; 0000 0844 
; 0000 0845 
; 0000 0846       case 19:
_0xC1:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xC2
; 0000 0847 
; 0000 0848             a[0] = 0x0AA;   //ster1
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	CALL SUBOPT_0x39
; 0000 0849             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 084A             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 084B             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 084C             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 084D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 084E 
; 0000 084F             a[1] = a[0]+0x001;  //ster2
; 0000 0850             a[2] = a[4];        //ster4 ABS druciak
; 0000 0851             a[6] = a[5]+0x001;  //okrag
; 0000 0852             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0853 
; 0000 0854     break;
; 0000 0855 
; 0000 0856 
; 0000 0857       case 20:
_0xC2:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0xC3
; 0000 0858 
; 0000 0859             a[0] = 0x042;   //ster1
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	CALL SUBOPT_0x39
; 0000 085A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 085B             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 085C             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x4B
; 0000 085D             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 085E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 085F 
; 0000 0860             a[1] = a[0]+0x001;  //ster2
; 0000 0861             a[2] = a[4];        //ster4 ABS druciak
; 0000 0862             a[6] = a[5]+0x001;  //okrag
; 0000 0863             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0864 
; 0000 0865     break;
; 0000 0866 
; 0000 0867 
; 0000 0868       case 21:
_0xC3:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0xC4
; 0000 0869 
; 0000 086A             a[0] = 0x04E;   //ster1
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	CALL SUBOPT_0x39
; 0000 086B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 086C             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 086D             a[5] = 0x196;   //delta okrag
; 0000 086E             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 086F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0870 
; 0000 0871             a[1] = a[0]+0x001;  //ster2
; 0000 0872             a[2] = a[4];        //ster4 ABS druciak
; 0000 0873             a[6] = a[5]+0x001;  //okrag
; 0000 0874             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0875 
; 0000 0876     break;
; 0000 0877 
; 0000 0878       case 22:
_0xC4:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0xC5
; 0000 0879 
; 0000 087A             a[0] = 0x0C2;   //ster1
	LDI  R30,LOW(194)
	LDI  R31,HIGH(194)
	CALL SUBOPT_0x39
; 0000 087B             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 087C             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 087D             a[5] = 0x190;   //delta okrag
; 0000 087E             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x51A
; 0000 087F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0880 
; 0000 0881             a[1] = a[0]+0x001;  //ster2
; 0000 0882             a[2] = a[4];        //ster4 ABS druciak
; 0000 0883             a[6] = a[5]+0x001;  //okrag
; 0000 0884             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0885 
; 0000 0886     break;
; 0000 0887 
; 0000 0888 
; 0000 0889       case 23:
_0xC5:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0xC6
; 0000 088A 
; 0000 088B             a[0] = 0x0CE;   //ster1
	LDI  R30,LOW(206)
	LDI  R31,HIGH(206)
	CALL SUBOPT_0x39
; 0000 088C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 088D             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 088E             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x51C
; 0000 088F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0890             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0891 
; 0000 0892             a[1] = a[0]+0x001;  //ster2
; 0000 0893             a[2] = a[4];        //ster4 ABS druciak
; 0000 0894             a[6] = a[5]+0x001;  //okrag
; 0000 0895             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0896 
; 0000 0897     break;
; 0000 0898 
; 0000 0899 
; 0000 089A       case 24:
_0xC6:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0xC7
; 0000 089B 
; 0000 089C             a[0] = 0x040;   //ster1
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL SUBOPT_0x39
; 0000 089D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 089E             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 089F             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x4B
; 0000 08A0             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 08A1             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08A2 
; 0000 08A3             a[1] = a[0]+0x001;  //ster2
; 0000 08A4             a[2] = a[4];        //ster4 ABS druciak
; 0000 08A5             a[6] = a[5]+0x001;  //okrag
; 0000 08A6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08A7 
; 0000 08A8     break;
; 0000 08A9 
; 0000 08AA       case 25:
_0xC7:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0xC8
; 0000 08AB 
; 0000 08AC             a[0] = 0x02E;   //ster1
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	CALL SUBOPT_0x39
; 0000 08AD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 08AE             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 08AF             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x40
; 0000 08B0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08B1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 08B2 
; 0000 08B3             a[1] = a[0]+0x001;  //ster2
; 0000 08B4             a[2] = a[4];        //ster4 ABS druciak
; 0000 08B5             a[6] = a[5]+0x001;  //okrag
; 0000 08B6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08B7 
; 0000 08B8     break;
; 0000 08B9 
; 0000 08BA       case 26:
_0xC8:
	CPI  R30,LOW(0x1A)
	LDI  R26,HIGH(0x1A)
	CPC  R31,R26
	BRNE _0xC9
; 0000 08BB 
; 0000 08BC             a[0] = 0x0FA;   //ster1
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x39
; 0000 08BD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 08BE             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4C
; 0000 08BF             a[5] = 0x190;   //delta okrag
; 0000 08C0             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 08C1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 08C2 
; 0000 08C3             a[1] = a[0]+0x001;  //ster2
; 0000 08C4             a[2] = a[4];        //ster4 ABS druciak
; 0000 08C5             a[6] = a[5]+0x001;  //okrag
; 0000 08C6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08C7 
; 0000 08C8     break;
; 0000 08C9 
; 0000 08CA 
; 0000 08CB       case 27:
_0xC9:
	CPI  R30,LOW(0x1B)
	LDI  R26,HIGH(0x1B)
	CPC  R31,R26
	BRNE _0xCA
; 0000 08CC 
; 0000 08CD             a[0] = 0x06C;   //ster1
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	CALL SUBOPT_0x39
; 0000 08CE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 08CF             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 08D0             a[5] = 0x199;   //delta okrag
; 0000 08D1             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08D2             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 08D3 
; 0000 08D4             a[1] = a[0]+0x001;  //ster2
; 0000 08D5             a[2] = a[4];        //ster4 ABS druciak
; 0000 08D6             a[6] = a[5]+0x001;  //okrag
; 0000 08D7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08D8 
; 0000 08D9     break;
; 0000 08DA 
; 0000 08DB 
; 0000 08DC       case 28:
_0xCA:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BRNE _0xCB
; 0000 08DD 
; 0000 08DE             a[0] = 0x0A4;   //ster1
	LDI  R30,LOW(164)
	LDI  R31,HIGH(164)
	CALL SUBOPT_0x39
; 0000 08DF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 08E0             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x46
; 0000 08E1             a[5] = 0x199;   //delta okrag
	RJMP _0x51C
; 0000 08E2             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08E3             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08E4 
; 0000 08E5             a[1] = a[0]+0x001;  //ster2
; 0000 08E6             a[2] = a[4];        //ster4 ABS druciak
; 0000 08E7             a[6] = a[5]+0x001;  //okrag
; 0000 08E8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08E9 
; 0000 08EA     break;
; 0000 08EB 
; 0000 08EC       case 29:
_0xCB:
	CPI  R30,LOW(0x1D)
	LDI  R26,HIGH(0x1D)
	CPC  R31,R26
	BRNE _0xCC
; 0000 08ED 
; 0000 08EE             a[0] = 0x02A;   //ster1
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	CALL SUBOPT_0x39
; 0000 08EF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 08F0             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 08F1             a[5] = 0x199;   //delta okrag
	RJMP _0x51C
; 0000 08F2             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08F3             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08F4 
; 0000 08F5             a[1] = a[0]+0x001;  //ster2
; 0000 08F6             a[2] = a[4];        //ster4 ABS druciak
; 0000 08F7             a[6] = a[5]+0x001;  //okrag
; 0000 08F8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08F9 
; 0000 08FA 
; 0000 08FB 
; 0000 08FC 
; 0000 08FD 
; 0000 08FE     break;
; 0000 08FF 
; 0000 0900       case 30:
_0xCC:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0xCD
; 0000 0901 
; 0000 0902             a[0] = 0x094;   //ster1
	LDI  R30,LOW(148)
	LDI  R31,HIGH(148)
	CALL SUBOPT_0x39
; 0000 0903             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0904             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4C
; 0000 0905             a[5] = 0x190;   //delta okrag
; 0000 0906             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0907             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0908 
; 0000 0909             a[1] = a[0]+0x001;  //ster2
; 0000 090A             a[2] = a[4];        //ster4 ABS druciak
; 0000 090B             a[6] = a[5]+0x001;  //okrag
; 0000 090C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 090D 
; 0000 090E     break;
; 0000 090F 
; 0000 0910       case 31:
_0xCD:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0xCE
; 0000 0911 
; 0000 0912             a[0] = 0x06E;   //ster1
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	CALL SUBOPT_0x39
; 0000 0913             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0914             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0915             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x51C
; 0000 0916             a[7] = 0x12;  //ster3 INV krazek scierny
; 0000 0917             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0918 
; 0000 0919             a[1] = a[0]+0x001;  //ster2
; 0000 091A             a[2] = a[4];        //ster4 ABS druciak
; 0000 091B             a[6] = a[5]+0x001;  //okrag
; 0000 091C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 091D 
; 0000 091E     break;
; 0000 091F 
; 0000 0920 
; 0000 0921        case 32:
_0xCE:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xCF
; 0000 0922 
; 0000 0923             a[0] = 0x086;   //ster1
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	CALL SUBOPT_0x39
; 0000 0924             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0925             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x46
; 0000 0926             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x40
; 0000 0927             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0928             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0929 
; 0000 092A             a[1] = a[0]+0x001;  //ster2
; 0000 092B             a[2] = a[4];        //ster4 ABS druciak
; 0000 092C             a[6] = a[5]+0x001;  //okrag
; 0000 092D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 092E 
; 0000 092F     break;
; 0000 0930 
; 0000 0931        case 33:
_0xCF:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0xD0
; 0000 0932 
; 0000 0933             a[0] = 0x08E;   //ster1
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	CALL SUBOPT_0x39
; 0000 0934             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0935             a[4] = 0x20;    //ster3 ABS krazek scierny
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	RJMP _0x51D
; 0000 0936             a[5] = 0x19C;   //delta okrag
; 0000 0937             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0938             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0939 
; 0000 093A             a[1] = a[0]+0x001;  //ster2
; 0000 093B             a[2] = a[4];        //ster4 ABS druciak
; 0000 093C             a[6] = a[5]+0x001;  //okrag
; 0000 093D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 093E 
; 0000 093F     break;
; 0000 0940 
; 0000 0941 
; 0000 0942     case 34: //86-1349
_0xD0:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0xD1
; 0000 0943 
; 0000 0944             a[0] = 0x05A;   //ster1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x39
; 0000 0945             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0946             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 0947             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4F
; 0000 0948             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0949             a[9] = 0;       //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 094A 
; 0000 094B             a[1] = a[0]+0x001;  //ster2
; 0000 094C             a[2] = a[4];        //ster4 ABS druciak
; 0000 094D             a[6] = a[5]+0x001;  //okrag
; 0000 094E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 094F 
; 0000 0950     break;
; 0000 0951 
; 0000 0952 
; 0000 0953     case 35:
_0xD1:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0xD2
; 0000 0954 
; 0000 0955             a[0] = 0x0DA;   //ster1
	LDI  R30,LOW(218)
	LDI  R31,HIGH(218)
	CALL SUBOPT_0x39
; 0000 0956             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0957             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0958             a[5] = 0x190;   //delta okrag
; 0000 0959             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 095A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 095B 
; 0000 095C             a[1] = a[0]+0x001;  //ster2
; 0000 095D             a[2] = a[4];        //ster4 ABS druciak
; 0000 095E             a[6] = a[5]+0x001;  //okrag
; 0000 095F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0960 
; 0000 0961     break;
; 0000 0962 
; 0000 0963          case 36:
_0xD2:
	CPI  R30,LOW(0x24)
	LDI  R26,HIGH(0x24)
	CPC  R31,R26
	BRNE _0xD3
; 0000 0964 
; 0000 0965             a[0] = 0x0A2;   //ster1
	LDI  R30,LOW(162)
	LDI  R31,HIGH(162)
	CALL SUBOPT_0x39
; 0000 0966             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x51
; 0000 0967             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 0968             a[5] = 0x196;   //delta okrag
; 0000 0969             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3C
; 0000 096A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3E
	RJMP _0x51B
; 0000 096B 
; 0000 096C             a[1] = a[0]+0x001;  //ster2
; 0000 096D             a[2] = a[4];        //ster4 ABS druciak
; 0000 096E             a[6] = a[5]+0x001;  //okrag
; 0000 096F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0970 
; 0000 0971     break;
; 0000 0972 
; 0000 0973          case 37:
_0xD3:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0xD4
; 0000 0974 
; 0000 0975             a[0] = 0x104;   //ster1
	LDI  R30,LOW(260)
	LDI  R31,HIGH(260)
	CALL SUBOPT_0x39
; 0000 0976             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0977             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 0978             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x52
; 0000 0979             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 097A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 097B 
; 0000 097C             a[1] = a[0]+0x001;  //ster2
; 0000 097D             a[2] = a[4];        //ster4 ABS druciak
; 0000 097E             a[6] = a[5]+0x001;  //okrag
; 0000 097F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0980 
; 0000 0981     break;
; 0000 0982 
; 0000 0983          case 38:
_0xD4:
	CPI  R30,LOW(0x26)
	LDI  R26,HIGH(0x26)
	CPC  R31,R26
	BRNE _0xD5
; 0000 0984 
; 0000 0985             a[0] = 0x036;   //ster1
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	CALL SUBOPT_0x39
; 0000 0986             a[3] = 0x11 - 0x01;    //ster4 INV druciak  //korekta
	CALL SUBOPT_0x3C
; 0000 0987             a[4] = 0x21;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x4E
; 0000 0988             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x51C
; 0000 0989             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 098A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 098B 
; 0000 098C             a[1] = a[0]+0x001;  //ster2
; 0000 098D             a[2] = a[4];        //ster4 ABS druciak
; 0000 098E             a[6] = a[5]+0x001;  //okrag
; 0000 098F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0990 
; 0000 0991     break;
; 0000 0992 
; 0000 0993 
; 0000 0994          case 39:
_0xD5:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0xD6
; 0000 0995 
; 0000 0996             a[0] = 0x118;   //ster1
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	CALL SUBOPT_0x39
; 0000 0997             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0998             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0999             a[5] = 0x190;   //delta okrag
; 0000 099A             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 099B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 099C 
; 0000 099D             a[1] = a[0]+0x001;  //ster2
; 0000 099E             a[2] = a[4];        //ster4 ABS druciak
; 0000 099F             a[6] = a[5]+0x001;  //okrag
; 0000 09A0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09A1 
; 0000 09A2     break;
; 0000 09A3 
; 0000 09A4 
; 0000 09A5          case 40:
_0xD6:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0xD7
; 0000 09A6 
; 0000 09A7             a[0] = 0x0A6;   //ster1
	LDI  R30,LOW(166)
	LDI  R31,HIGH(166)
	CALL SUBOPT_0x39
; 0000 09A8             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x51
; 0000 09A9             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 09AA             a[5] = 0x196;   //delta okrag
; 0000 09AB             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x51A
; 0000 09AC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09AD 
; 0000 09AE             a[1] = a[0]+0x001;  //ster2
; 0000 09AF             a[2] = a[4];        //ster4 ABS druciak
; 0000 09B0             a[6] = a[5]+0x001;  //okrag
; 0000 09B1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09B2 
; 0000 09B3     break;
; 0000 09B4 
; 0000 09B5          case 41:
_0xD7:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0xD8
; 0000 09B6 
; 0000 09B7             a[0] = 0x01E;   //ster1
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x39
; 0000 09B8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 09B9             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 09BA             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x43
; 0000 09BB             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 09BC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09BD 
; 0000 09BE             a[1] = a[0]+0x001;  //ster2
; 0000 09BF             a[2] = a[4];        //ster4 ABS druciak
; 0000 09C0             a[6] = a[5]+0x001;  //okrag
; 0000 09C1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09C2 
; 0000 09C3     break;
; 0000 09C4 
; 0000 09C5 
; 0000 09C6          case 42:
_0xD8:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0xD9
; 0000 09C7 
; 0000 09C8             a[0] = 0x05C;   //ster1
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x39
; 0000 09C9             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 09CA             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 09CB             a[5] = 0x196;   //delta okrag
; 0000 09CC             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 09CD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 09CE 
; 0000 09CF             a[1] = a[0]+0x001;  //ster2
; 0000 09D0             a[2] = a[4];        //ster4 ABS druciak
; 0000 09D1             a[6] = a[5]+0x001;  //okrag
; 0000 09D2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09D3 
; 0000 09D4     break;
; 0000 09D5 
; 0000 09D6 
; 0000 09D7          case 43:
_0xD9:
	CPI  R30,LOW(0x2B)
	LDI  R26,HIGH(0x2B)
	CPC  R31,R26
	BRNE _0xDA
; 0000 09D8 
; 0000 09D9             a[0] = 0x062;   //ster1
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL SUBOPT_0x39
; 0000 09DA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 09DB             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 09DC             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4F
; 0000 09DD             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 09DE             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 09DF 
; 0000 09E0             a[1] = a[0]+0x001;  //ster2
; 0000 09E1             a[2] = a[4];        //ster4 ABS druciak
; 0000 09E2             a[6] = a[5]+0x001;  //okrag
; 0000 09E3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09E4 
; 0000 09E5     break;
; 0000 09E6 
; 0000 09E7 
; 0000 09E8          case 44:
_0xDA:
	CPI  R30,LOW(0x2C)
	LDI  R26,HIGH(0x2C)
	CPC  R31,R26
	BRNE _0xDB
; 0000 09E9 
; 0000 09EA             a[0] = 0x;   //ster1
	CALL SUBOPT_0x54
; 0000 09EB             a[3] = 0x;    //ster4 INV druciak
; 0000 09EC             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 09ED             a[5] = 0x;   //delta okrag
; 0000 09EE             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 09EF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 09F0 
; 0000 09F1             a[1] = a[0]+0x001;  //ster2
; 0000 09F2             a[2] = a[4];        //ster4 ABS druciak
; 0000 09F3             a[6] = a[5]+0x001;  //okrag
; 0000 09F4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09F5 
; 0000 09F6     break;
; 0000 09F7 
; 0000 09F8 
; 0000 09F9          case 45:
_0xDB:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0xDC
; 0000 09FA 
; 0000 09FB             a[0] = 0x010;   //ster1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x39
; 0000 09FC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 09FD             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 09FE             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x43
; 0000 09FF             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0A00             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0A01 
; 0000 0A02             a[1] = a[0]+0x001;  //ster2
; 0000 0A03             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A04             a[6] = a[5]+0x001;  //okrag
; 0000 0A05             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A06 
; 0000 0A07     break;
; 0000 0A08 
; 0000 0A09 
; 0000 0A0A     case 46:
_0xDC:
	CPI  R30,LOW(0x2E)
	LDI  R26,HIGH(0x2E)
	CPC  R31,R26
	BRNE _0xDD
; 0000 0A0B 
; 0000 0A0C             a[0] = 0x050;   //ster1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x39
; 0000 0A0D             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 0A0E             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0A0F             a[5] = 0x196;   //delta okrag
; 0000 0A10             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0A11             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A12 
; 0000 0A13             a[1] = a[0]+0x001;  //ster2
; 0000 0A14             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A15             a[6] = a[5]+0x001;  //okrag
; 0000 0A16             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A17 
; 0000 0A18     break;
; 0000 0A19 
; 0000 0A1A 
; 0000 0A1B     case 47:
_0xDD:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BRNE _0xDE
; 0000 0A1C 
; 0000 0A1D             a[0] = 0x068;   //ster1
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	CALL SUBOPT_0x39
; 0000 0A1E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0A1F             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0A20             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x51C
; 0000 0A21             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A22             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A23 
; 0000 0A24             a[1] = a[0]+0x001;  //ster2
; 0000 0A25             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A26             a[6] = a[5]+0x001;  //okrag
; 0000 0A27             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A28 
; 0000 0A29     break;
; 0000 0A2A 
; 0000 0A2B 
; 0000 0A2C 
; 0000 0A2D     case 48:
_0xDE:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0xDF
; 0000 0A2E 
; 0000 0A2F             a[0] = 0x;   //ster1
	CALL SUBOPT_0x54
; 0000 0A30             a[3] = 0x;    //ster4 INV druciak
; 0000 0A31             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0A32             a[5] = 0x;   //delta okrag
; 0000 0A33             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0A34             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0A35 
; 0000 0A36             a[1] = a[0]+0x001;  //ster2
; 0000 0A37             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A38             a[6] = a[5]+0x001;  //okrag
; 0000 0A39             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A3A 
; 0000 0A3B     break;
; 0000 0A3C 
; 0000 0A3D 
; 0000 0A3E     case 49:
_0xDF:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xE0
; 0000 0A3F 
; 0000 0A40             a[0] = 0x024;   //ster1
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL SUBOPT_0x39
; 0000 0A41             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0A42             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0A43             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x40
; 0000 0A44             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A45             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0A46 
; 0000 0A47             a[1] = a[0]+0x001;  //ster2
; 0000 0A48             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A49             a[6] = a[5]+0x001;  //okrag
; 0000 0A4A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A4B 
; 0000 0A4C     break;
; 0000 0A4D 
; 0000 0A4E 
; 0000 0A4F     case 50:
_0xE0:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0xE1
; 0000 0A50 
; 0000 0A51             a[0] = 0x014;   //ster1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x39
; 0000 0A52             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0A53             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0A54             a[5] = 0x190;   //delta okrag
; 0000 0A55             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0A56             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0A57 
; 0000 0A58             a[1] = a[0]+0x001;  //ster2
; 0000 0A59             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A5A             a[6] = a[5]+0x001;  //okrag
; 0000 0A5B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A5C 
; 0000 0A5D     break;
; 0000 0A5E 
; 0000 0A5F     case 51:
_0xE1:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0xE2
; 0000 0A60 
; 0000 0A61             a[0] = 0x082;   //ster1
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	CALL SUBOPT_0x39
; 0000 0A62             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0A63             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0A64             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x52
; 0000 0A65             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A66             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0A67 
; 0000 0A68             a[1] = a[0]+0x001;  //ster2
; 0000 0A69             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A6A             a[6] = a[5]+0x001;  //okrag
; 0000 0A6B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A6C 
; 0000 0A6D     break;
; 0000 0A6E 
; 0000 0A6F     case 52:
_0xE2:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0xE3
; 0000 0A70 
; 0000 0A71             a[0] = 0x106;   //ster1
	LDI  R30,LOW(262)
	LDI  R31,HIGH(262)
	CALL SUBOPT_0x39
; 0000 0A72             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0A73             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 0A74             a[5] = 0x190;   //delta okrag
; 0000 0A75             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0A76             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A77 
; 0000 0A78             a[1] = a[0]+0x001;  //ster2
; 0000 0A79             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A7A             a[6] = a[5]+0x001;  //okrag
; 0000 0A7B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A7C 
; 0000 0A7D     break;
; 0000 0A7E 
; 0000 0A7F 
; 0000 0A80     case 53:
_0xE3:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0xE4
; 0000 0A81 
; 0000 0A82             a[0] = 0x04C;   //ster1
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x39
; 0000 0A83             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0A84             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0A85             a[5] = 0x196;   //delta okrag
	RJMP _0x51C
; 0000 0A86             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A87             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A88 
; 0000 0A89             a[1] = a[0]+0x001;  //ster2
; 0000 0A8A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A8B             a[6] = a[5]+0x001;  //okrag
; 0000 0A8C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A8D 
; 0000 0A8E     break;
; 0000 0A8F 
; 0000 0A90 
; 0000 0A91     case 54:
_0xE4:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0xE5
; 0000 0A92 
; 0000 0A93             a[0] = 0x01C;   //ster1
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	CALL SUBOPT_0x39
; 0000 0A94             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0A95             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0A96             a[5] = 0x190;   //delta okrag
; 0000 0A97             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0A98             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A99 
; 0000 0A9A             a[1] = a[0]+0x001;  //ster2
; 0000 0A9B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A9C             a[6] = a[5]+0x001;  //okrag
; 0000 0A9D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A9E 
; 0000 0A9F     break;
; 0000 0AA0 
; 0000 0AA1     case 55:
_0xE5:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0xE6
; 0000 0AA2 
; 0000 0AA3             a[0] = 0x114;   //ster1
	LDI  R30,LOW(276)
	LDI  R31,HIGH(276)
	CALL SUBOPT_0x39
; 0000 0AA4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0AA5             a[4] = 0x1A;    //ster3 ABS krazek scierny
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	RJMP _0x51D
; 0000 0AA6             a[5] = 0x19C;   //delta okrag
; 0000 0AA7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AA8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AA9 
; 0000 0AAA             a[1] = a[0]+0x001;  //ster2
; 0000 0AAB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AAC             a[6] = a[5]+0x001;  //okrag
; 0000 0AAD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AAE 
; 0000 0AAF     break;
; 0000 0AB0 
; 0000 0AB1 
; 0000 0AB2     case 56:
_0xE6:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0xE7
; 0000 0AB3 
; 0000 0AB4             a[0] = 0x0EE;   //ster1
	LDI  R30,LOW(238)
	LDI  R31,HIGH(238)
	CALL SUBOPT_0x39
; 0000 0AB5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0AB6             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 0AB7             a[5] = 0x190;   //delta okrag
; 0000 0AB8             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0AB9             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0ABA 
; 0000 0ABB             a[1] = a[0]+0x001;  //ster2
; 0000 0ABC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0ABD             a[6] = a[5]+0x001;  //okrag
; 0000 0ABE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ABF 
; 0000 0AC0     break;
; 0000 0AC1 
; 0000 0AC2 
; 0000 0AC3     case 57:
_0xE7:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0xE8
; 0000 0AC4 
; 0000 0AC5             a[0] = 0x0F8;   //ster1
	LDI  R30,LOW(248)
	LDI  R31,HIGH(248)
	CALL SUBOPT_0x39
; 0000 0AC6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0AC7             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0AC8             a[5] = 0x190;   //delta okrag
; 0000 0AC9             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0ACA             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0ACB 
; 0000 0ACC             a[1] = a[0]+0x001;  //ster2
; 0000 0ACD             a[2] = a[4];        //ster4 ABS druciak
; 0000 0ACE             a[6] = a[5]+0x001;  //okrag
; 0000 0ACF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AD0 
; 0000 0AD1     break;
; 0000 0AD2 
; 0000 0AD3 
; 0000 0AD4     case 58:
_0xE8:
	CPI  R30,LOW(0x3A)
	LDI  R26,HIGH(0x3A)
	CPC  R31,R26
	BRNE _0xE9
; 0000 0AD5 
; 0000 0AD6             a[0] = 0x0E4;   //ster1
	LDI  R30,LOW(228)
	LDI  R31,HIGH(228)
	CALL SUBOPT_0x39
; 0000 0AD7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0AD8             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0AD9             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4F
; 0000 0ADA             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0ADB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0ADC 
; 0000 0ADD             a[1] = a[0]+0x001;  //ster2
; 0000 0ADE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0ADF             a[6] = a[5]+0x001;  //okrag
; 0000 0AE0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AE1 
; 0000 0AE2     break;
; 0000 0AE3 
; 0000 0AE4 
; 0000 0AE5     case 59:
_0xE9:
	CPI  R30,LOW(0x3B)
	LDI  R26,HIGH(0x3B)
	CPC  R31,R26
	BRNE _0xEA
; 0000 0AE6 
; 0000 0AE7             a[0] = 0x052;   //ster1
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	CALL SUBOPT_0x39
; 0000 0AE8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0AE9             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0AEA             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0AEB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AEC             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0AED 
; 0000 0AEE             a[1] = a[0]+0x001;  //ster2
; 0000 0AEF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AF0             a[6] = a[5]+0x001;  //okrag
; 0000 0AF1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AF2 
; 0000 0AF3     break;
; 0000 0AF4 
; 0000 0AF5 
; 0000 0AF6     case 60:
_0xEA:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BRNE _0xEB
; 0000 0AF7 
; 0000 0AF8             a[0] = 0x090;   //ster1
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0x39
; 0000 0AF9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0AFA             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0AFB             a[5] = 0x190;   //delta okrag
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL SUBOPT_0x43
; 0000 0AFC             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0AFD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0AFE 
; 0000 0AFF             a[1] = a[0]+0x001;  //ster2
; 0000 0B00             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B01             a[6] = a[5]+0x001;  //okrag
; 0000 0B02             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B03 
; 0000 0B04     break;
; 0000 0B05 
; 0000 0B06 
; 0000 0B07     case 61:
_0xEB:
	CPI  R30,LOW(0x3D)
	LDI  R26,HIGH(0x3D)
	CPC  R31,R26
	BRNE _0xEC
; 0000 0B08 
; 0000 0B09             a[0] = 0x0FC;   //ster1
	LDI  R30,LOW(252)
	LDI  R31,HIGH(252)
	CALL SUBOPT_0x39
; 0000 0B0A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0B0B             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4C
; 0000 0B0C             a[5] = 0x190;   //delta okrag
; 0000 0B0D             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0B0E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B0F 
; 0000 0B10             a[1] = a[0]+0x001;  //ster2
; 0000 0B11             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B12             a[6] = a[5]+0x001;  //okrag
; 0000 0B13             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B14 
; 0000 0B15     break;
; 0000 0B16 
; 0000 0B17 
; 0000 0B18     case 62:
_0xEC:
	CPI  R30,LOW(0x3E)
	LDI  R26,HIGH(0x3E)
	CPC  R31,R26
	BRNE _0xED
; 0000 0B19 
; 0000 0B1A             a[0] = 0x028;   //ster1
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x39
; 0000 0B1B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0B1C             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0B1D             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x51C
; 0000 0B1E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B1F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B20 
; 0000 0B21             a[1] = a[0]+0x001;  //ster2
; 0000 0B22             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B23             a[6] = a[5]+0x001;  //okrag
; 0000 0B24             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B25 
; 0000 0B26     break;
; 0000 0B27 
; 0000 0B28 
; 0000 0B29     case 63:
_0xED:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0xEE
; 0000 0B2A 
; 0000 0B2B             a[0] = 0x034;   //ster1
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	CALL SUBOPT_0x39
; 0000 0B2C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0B2D             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0B2E             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x51C
; 0000 0B2F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B30             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B31 
; 0000 0B32             a[1] = a[0]+0x001;  //ster2
; 0000 0B33             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B34             a[6] = a[5]+0x001;  //okrag
; 0000 0B35             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B36 
; 0000 0B37     break;
; 0000 0B38 
; 0000 0B39 
; 0000 0B3A     case 64:
_0xEE:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0xEF
; 0000 0B3B 
; 0000 0B3C             a[0] = 0x0EC;   //ster1
	LDI  R30,LOW(236)
	LDI  R31,HIGH(236)
	CALL SUBOPT_0x39
; 0000 0B3D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0B3E             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0B3F             a[5] = 0x190;   //delta okrag
; 0000 0B40             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0B41             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B42 
; 0000 0B43             a[1] = a[0]+0x001;  //ster2
; 0000 0B44             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B45             a[6] = a[5]+0x001;  //okrag
; 0000 0B46             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B47 
; 0000 0B48     break;
; 0000 0B49 
; 0000 0B4A 
; 0000 0B4B     case 65:
_0xEF:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0xF0
; 0000 0B4C 
; 0000 0B4D             a[0] = 0x0CC;   //ster1
	LDI  R30,LOW(204)
	LDI  R31,HIGH(204)
	CALL SUBOPT_0x39
; 0000 0B4E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0B4F             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5A
; 0000 0B50             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x40
; 0000 0B51             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B52             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0B53 
; 0000 0B54             a[1] = a[0]+0x001;  //ster2
; 0000 0B55             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B56             a[6] = a[5]+0x001;  //okrag
; 0000 0B57             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B58 
; 0000 0B59     break;
; 0000 0B5A 
; 0000 0B5B 
; 0000 0B5C     case 66:
_0xF0:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0xF1
; 0000 0B5D 
; 0000 0B5E             a[0] = 0x0BC;   //ster1
	LDI  R30,LOW(188)
	LDI  R31,HIGH(188)
	CALL SUBOPT_0x39
; 0000 0B5F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0B60             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0B61             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5B
; 0000 0B62             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0B63             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B64 
; 0000 0B65             a[1] = a[0]+0x001;  //ster2
; 0000 0B66             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B67             a[6] = a[5]+0x001;  //okrag
; 0000 0B68             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B69 
; 0000 0B6A     break;
; 0000 0B6B 
; 0000 0B6C 
; 0000 0B6D     case 67:
_0xF1:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xF2
; 0000 0B6E 
; 0000 0B6F             a[0] = 0x09C;   //ster1
	LDI  R30,LOW(156)
	LDI  R31,HIGH(156)
	CALL SUBOPT_0x39
; 0000 0B70             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0B71             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0B72             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x51C
; 0000 0B73             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B74             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B75 
; 0000 0B76             a[1] = a[0]+0x001;  //ster2
; 0000 0B77             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B78             a[6] = a[5]+0x001;  //okrag
; 0000 0B79             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B7A 
; 0000 0B7B     break;
; 0000 0B7C 
; 0000 0B7D 
; 0000 0B7E     case 68:
_0xF2:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0xF3
; 0000 0B7F 
; 0000 0B80             a[0] = 0x07C;   //ster1
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	CALL SUBOPT_0x39
; 0000 0B81             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0B82             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x46
; 0000 0B83             a[5] = 0x199;   //delta okrag
	RJMP _0x51C
; 0000 0B84             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B85             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B86 
; 0000 0B87             a[1] = a[0]+0x001;  //ster2
; 0000 0B88             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B89             a[6] = a[5]+0x001;  //okrag
; 0000 0B8A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B8B 
; 0000 0B8C     break;
; 0000 0B8D 
; 0000 0B8E 
; 0000 0B8F     case 69:
_0xF3:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BRNE _0xF4
; 0000 0B90 
; 0000 0B91             a[0] = 0x0D2;   //ster1
	LDI  R30,LOW(210)
	LDI  R31,HIGH(210)
	CALL SUBOPT_0x39
; 0000 0B92             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0B93             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5A
; 0000 0B94             a[5] = 0x193;   //delta okrag
	RJMP _0x51C
; 0000 0B95             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B96             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B97 
; 0000 0B98             a[1] = a[0]+0x001;  //ster2
; 0000 0B99             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B9A             a[6] = a[5]+0x001;  //okrag
; 0000 0B9B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B9C 
; 0000 0B9D     break;
; 0000 0B9E 
; 0000 0B9F 
; 0000 0BA0     case 70:
_0xF4:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BRNE _0xF5
; 0000 0BA1 
; 0000 0BA2             a[0] = 0x0E6;   //ster1
	LDI  R30,LOW(230)
	LDI  R31,HIGH(230)
	CALL SUBOPT_0x39
; 0000 0BA3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0BA4             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0BA5             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5B
; 0000 0BA6             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0BA7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0BA8 
; 0000 0BA9             a[1] = a[0]+0x001;  //ster2
; 0000 0BAA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BAB             a[6] = a[5]+0x001;  //okrag
; 0000 0BAC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BAD 
; 0000 0BAE     break;
; 0000 0BAF 
; 0000 0BB0 
; 0000 0BB1     case 71:
_0xF5:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BRNE _0xF6
; 0000 0BB2 
; 0000 0BB3             a[0] = 0x0B4;   //ster1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x39
; 0000 0BB4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0BB5             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0BB6             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4F
; 0000 0BB7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BB8             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0BB9 
; 0000 0BBA             a[1] = a[0]+0x001;  //ster2
; 0000 0BBB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BBC             a[6] = a[5]+0x001;  //okrag
; 0000 0BBD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BBE 
; 0000 0BBF     break;
; 0000 0BC0 
; 0000 0BC1 
; 0000 0BC2     case 72:
_0xF6:
	CPI  R30,LOW(0x48)
	LDI  R26,HIGH(0x48)
	CPC  R31,R26
	BRNE _0xF7
; 0000 0BC3 
; 0000 0BC4             a[0] = 0x0AC;   //ster1
	LDI  R30,LOW(172)
	LDI  R31,HIGH(172)
	CALL SUBOPT_0x39
; 0000 0BC5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0BC6             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x46
; 0000 0BC7             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x40
; 0000 0BC8             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BC9             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0BCA 
; 0000 0BCB             a[1] = a[0]+0x001;  //ster2
; 0000 0BCC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BCD             a[6] = a[5]+0x001;  //okrag
; 0000 0BCE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BCF 
; 0000 0BD0     break;
; 0000 0BD1 
; 0000 0BD2 
; 0000 0BD3     case 73:
_0xF7:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BRNE _0xF8
; 0000 0BD4 
; 0000 0BD5             a[0] = 0x012;   //ster1
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CALL SUBOPT_0x39
; 0000 0BD6             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 0BD7             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x55
; 0000 0BD8             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4F
; 0000 0BD9             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BDA             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0BDB 
; 0000 0BDC             a[1] = a[0]+0x001;  //ster2
; 0000 0BDD             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BDE             a[6] = a[5]+0x001;  //okrag
; 0000 0BDF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BE0 
; 0000 0BE1     break;
; 0000 0BE2 
; 0000 0BE3 
; 0000 0BE4     case 74:
_0xF8:
	CPI  R30,LOW(0x4A)
	LDI  R26,HIGH(0x4A)
	CPC  R31,R26
	BRNE _0xF9
; 0000 0BE5 
; 0000 0BE6             a[0] = 0x0B2;   //ster1
	LDI  R30,LOW(178)
	LDI  R31,HIGH(178)
	CALL SUBOPT_0x39
; 0000 0BE7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0BE8             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0BE9             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x40
; 0000 0BEA             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BEB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0BEC 
; 0000 0BED             a[1] = a[0]+0x001;  //ster2
; 0000 0BEE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BEF             a[6] = a[5]+0x001;  //okrag
; 0000 0BF0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BF1 
; 0000 0BF2     break;
; 0000 0BF3 
; 0000 0BF4 
; 0000 0BF5     case 75:
_0xF9:
	CPI  R30,LOW(0x4B)
	LDI  R26,HIGH(0x4B)
	CPC  R31,R26
	BRNE _0xFA
; 0000 0BF6 
; 0000 0BF7             a[0] = 0x10C;   //ster1
	LDI  R30,LOW(268)
	LDI  R31,HIGH(268)
	CALL SUBOPT_0x39
; 0000 0BF8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0BF9             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 0BFA             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4F
; 0000 0BFB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BFC             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0BFD 
; 0000 0BFE             a[1] = a[0]+0x001;  //ster2
; 0000 0BFF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C00             a[6] = a[5]+0x001;  //okrag
; 0000 0C01             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C02 
; 0000 0C03     break;
; 0000 0C04 
; 0000 0C05 
; 0000 0C06     case 76:
_0xFA:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0xFB
; 0000 0C07 
; 0000 0C08             a[0] = 0x;   //ster1
	CALL SUBOPT_0x54
; 0000 0C09             a[3] = 0x;    //ster4 INV druciak
; 0000 0C0A             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0C0B             a[5] = 0x;   //delta okrag
; 0000 0C0C             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0C0D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0C0E 
; 0000 0C0F             a[1] = a[0]+0x001;  //ster2
; 0000 0C10             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C11             a[6] = a[5]+0x001;  //okrag
; 0000 0C12             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C13 
; 0000 0C14     break;
; 0000 0C15 
; 0000 0C16 
; 0000 0C17     case 77:
_0xFB:
	CPI  R30,LOW(0x4D)
	LDI  R26,HIGH(0x4D)
	CPC  R31,R26
	BRNE _0xFC
; 0000 0C18 
; 0000 0C19             a[0] = 0x026;   //ster1
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL SUBOPT_0x39
; 0000 0C1A             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 0C1B             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x55
; 0000 0C1C             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x51C
; 0000 0C1D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C1E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C1F 
; 0000 0C20             a[1] = a[0]+0x001;  //ster2
; 0000 0C21             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C22             a[6] = a[5]+0x001;  //okrag
; 0000 0C23             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C24 
; 0000 0C25     break;
; 0000 0C26 
; 0000 0C27 
; 0000 0C28     case 78:
_0xFC:
	CPI  R30,LOW(0x4E)
	LDI  R26,HIGH(0x4E)
	CPC  R31,R26
	BRNE _0xFD
; 0000 0C29 
; 0000 0C2A             a[0] = 0x11C;   //ster1
	LDI  R30,LOW(284)
	LDI  R31,HIGH(284)
	CALL SUBOPT_0x39
; 0000 0C2B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0C2C             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5C
; 0000 0C2D             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x51C
; 0000 0C2E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C2F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C30 
; 0000 0C31             a[1] = a[0]+0x001;  //ster2
; 0000 0C32             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C33             a[6] = a[5]+0x001;  //okrag
; 0000 0C34             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C35 
; 0000 0C36     break;
; 0000 0C37 
; 0000 0C38 
; 0000 0C39     case 79:
_0xFD:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0xFE
; 0000 0C3A 
; 0000 0C3B             a[0] = 0x112;   //ster1
	LDI  R30,LOW(274)
	LDI  R31,HIGH(274)
	CALL SUBOPT_0x39
; 0000 0C3C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0C3D             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 0C3E             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x51C
; 0000 0C3F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C40             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C41 
; 0000 0C42             a[1] = a[0]+0x001;  //ster2
; 0000 0C43             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C44             a[6] = a[5]+0x001;  //okrag
; 0000 0C45             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C46 
; 0000 0C47     break;
; 0000 0C48 
; 0000 0C49     case 80:
_0xFE:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0xFF
; 0000 0C4A 
; 0000 0C4B             a[0] = 0x;   //ster1
	CALL SUBOPT_0x54
; 0000 0C4C             a[3] = 0x;    //ster4 INV druciak
; 0000 0C4D             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0C4E             a[5] = 0x;   //delta okrag
; 0000 0C4F             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0C50             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0C51 
; 0000 0C52             a[1] = a[0]+0x001;  //ster2
; 0000 0C53             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C54             a[6] = a[5]+0x001;  //okrag
; 0000 0C55             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C56 
; 0000 0C57     break;
; 0000 0C58 
; 0000 0C59     case 81:
_0xFF:
	CPI  R30,LOW(0x51)
	LDI  R26,HIGH(0x51)
	CPC  R31,R26
	BRNE _0x100
; 0000 0C5A 
; 0000 0C5B             a[0] = 0x0EA;   //ster1
	LDI  R30,LOW(234)
	LDI  R31,HIGH(234)
	CALL SUBOPT_0x39
; 0000 0C5C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0C5D             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5D
; 0000 0C5E             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x40
; 0000 0C5F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C60             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0C61 
; 0000 0C62             a[1] = a[0]+0x001;  //ster2
; 0000 0C63             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C64             a[6] = a[5]+0x001;  //okrag
; 0000 0C65             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C66 
; 0000 0C67     break;
; 0000 0C68 
; 0000 0C69 
; 0000 0C6A     case 82:
_0x100:
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BRNE _0x101
; 0000 0C6B 
; 0000 0C6C             a[0] = 0x0D8;   //ster1
	LDI  R30,LOW(216)
	LDI  R31,HIGH(216)
	CALL SUBOPT_0x39
; 0000 0C6D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0C6E             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5E
; 0000 0C6F             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x40
; 0000 0C70             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C71             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0C72 
; 0000 0C73             a[1] = a[0]+0x001;  //ster2
; 0000 0C74             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C75             a[6] = a[5]+0x001;  //okrag
; 0000 0C76             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C77 
; 0000 0C78     break;
; 0000 0C79 
; 0000 0C7A 
; 0000 0C7B     case 83:
_0x101:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x102
; 0000 0C7C 
; 0000 0C7D             a[0] = 0x08C;   //ster1
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	CALL SUBOPT_0x39
; 0000 0C7E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0C7F             a[4] = 0x22;    //ster3 ABS krazek scierny
	LDI  R26,LOW(34)
	LDI  R27,HIGH(34)
	CALL SUBOPT_0x5F
; 0000 0C80             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x51C
; 0000 0C81             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C82             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C83 
; 0000 0C84             a[1] = a[0]+0x001;  //ster2
; 0000 0C85             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C86             a[6] = a[5]+0x001;  //okrag
; 0000 0C87             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C88 
; 0000 0C89     break;
; 0000 0C8A 
; 0000 0C8B 
; 0000 0C8C     case 84:
_0x102:
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x103
; 0000 0C8D 
; 0000 0C8E             a[0] = 0x0A0;   //ster1
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	CALL SUBOPT_0x39
; 0000 0C8F             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x60
; 0000 0C90             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0C91             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x61
; 0000 0C92             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x51A
; 0000 0C93             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C94 
; 0000 0C95             a[1] = a[0]+0x001;  //ster2
; 0000 0C96             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C97             a[6] = a[5]+0x001;  //okrag
; 0000 0C98             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C99 
; 0000 0C9A     break;
; 0000 0C9B 
; 0000 0C9C 
; 0000 0C9D    case 85:
_0x103:
	CPI  R30,LOW(0x55)
	LDI  R26,HIGH(0x55)
	CPC  R31,R26
	BRNE _0x104
; 0000 0C9E 
; 0000 0C9F             a[0] = 0x0AE;   //ster1
	LDI  R30,LOW(174)
	LDI  R31,HIGH(174)
	CALL SUBOPT_0x39
; 0000 0CA0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0CA1             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5D
; 0000 0CA2             a[5] = 0x193;   //delta okrag
	RJMP _0x51C
; 0000 0CA3             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CA4             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CA5 
; 0000 0CA6             a[1] = a[0]+0x001;  //ster2
; 0000 0CA7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CA8             a[6] = a[5]+0x001;  //okrag
; 0000 0CA9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CAA 
; 0000 0CAB     break;
; 0000 0CAC 
; 0000 0CAD     case 86:
_0x104:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BRNE _0x105
; 0000 0CAE 
; 0000 0CAF             a[0] = 0x0F6;   //ster1
	LDI  R30,LOW(246)
	LDI  R31,HIGH(246)
	CALL SUBOPT_0x39
; 0000 0CB0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0CB1             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5E
; 0000 0CB2             a[5] = 0x190;   //delta okrag
	RJMP _0x51C
; 0000 0CB3             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CB4             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CB5 
; 0000 0CB6             a[1] = a[0]+0x001;  //ster2
; 0000 0CB7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CB8             a[6] = a[5]+0x001;  //okrag
; 0000 0CB9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CBA 
; 0000 0CBB     break;
; 0000 0CBC 
; 0000 0CBD 
; 0000 0CBE     case 87:
_0x105:
	CPI  R30,LOW(0x57)
	LDI  R26,HIGH(0x57)
	CPC  R31,R26
	BRNE _0x106
; 0000 0CBF 
; 0000 0CC0             a[0] = 0x0C4;   //ster1
	LDI  R30,LOW(196)
	LDI  R31,HIGH(196)
	CALL SUBOPT_0x39
; 0000 0CC1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0CC2             a[4] = 0x23;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0CC3             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0CC4             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CC5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0CC6 
; 0000 0CC7             a[1] = a[0]+0x001;  //ster2
; 0000 0CC8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CC9             a[6] = a[5]+0x001;  //okrag
; 0000 0CCA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CCB 
; 0000 0CCC     break;
; 0000 0CCD 
; 0000 0CCE 
; 0000 0CCF     case 88:
_0x106:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x107
; 0000 0CD0 
; 0000 0CD1             a[0] = 0x07E;   //ster1
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	CALL SUBOPT_0x39
; 0000 0CD2             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x60
; 0000 0CD3             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0CD4             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x61
; 0000 0CD5             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3C
; 0000 0CD6             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3E
	RJMP _0x51B
; 0000 0CD7 
; 0000 0CD8             a[1] = a[0]+0x001;  //ster2
; 0000 0CD9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CDA             a[6] = a[5]+0x001;  //okrag
; 0000 0CDB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CDC 
; 0000 0CDD     break;
; 0000 0CDE 
; 0000 0CDF 
; 0000 0CE0     case 89:
_0x107:
	CPI  R30,LOW(0x59)
	LDI  R26,HIGH(0x59)
	CPC  R31,R26
	BRNE _0x108
; 0000 0CE1 
; 0000 0CE2             a[0] = 0x02C;   //ster1
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x39
; 0000 0CE3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0CE4             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0CE5             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4F
; 0000 0CE6             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CE7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0CE8 
; 0000 0CE9             a[1] = a[0]+0x001;  //ster2
; 0000 0CEA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CEB             a[6] = a[5]+0x001;  //okrag
; 0000 0CEC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CED 
; 0000 0CEE     break;
; 0000 0CEF 
; 0000 0CF0 
; 0000 0CF1     case 90:
_0x108:
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BRNE _0x109
; 0000 0CF2 
; 0000 0CF3             a[0] = 0x0F0;   //ster1
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	CALL SUBOPT_0x39
; 0000 0CF4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0CF5             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0CF6             a[5] = 0x196;   //delta okrag
; 0000 0CF7             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0CF8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CF9 
; 0000 0CFA             a[1] = a[0]+0x001;  //ster2
; 0000 0CFB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CFC             a[6] = a[5]+0x001;  //okrag
; 0000 0CFD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CFE 
; 0000 0CFF     break;
; 0000 0D00 
; 0000 0D01 
; 0000 0D02     case 91:
_0x109:
	CPI  R30,LOW(0x5B)
	LDI  R26,HIGH(0x5B)
	CPC  R31,R26
	BRNE _0x10A
; 0000 0D03 
; 0000 0D04             a[0] = 0x0A8;   //ster1
	LDI  R30,LOW(168)
	LDI  R31,HIGH(168)
	CALL SUBOPT_0x39
; 0000 0D05             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0D06             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0D07             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x51C
; 0000 0D08             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D09             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D0A 
; 0000 0D0B             a[1] = a[0]+0x001;  //ster2
; 0000 0D0C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D0D             a[6] = a[5]+0x001;  //okrag
; 0000 0D0E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D0F 
; 0000 0D10     break;
; 0000 0D11 
; 0000 0D12 
; 0000 0D13     case 92:
_0x10A:
	CPI  R30,LOW(0x5C)
	LDI  R26,HIGH(0x5C)
	CPC  R31,R26
	BRNE _0x10B
; 0000 0D14 
; 0000 0D15             a[0] = 0x;   //ster1
	CALL SUBOPT_0x54
; 0000 0D16             a[3] = 0x;    //ster4 INV druciak
; 0000 0D17             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0D18             a[5] = 0x;   //delta okrag
; 0000 0D19             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0D1A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0D1B 
; 0000 0D1C             a[1] = a[0]+0x001;  //ster2
; 0000 0D1D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D1E             a[6] = a[5]+0x001;  //okrag
; 0000 0D1F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D20 
; 0000 0D21     break;
; 0000 0D22 
; 0000 0D23 
; 0000 0D24     case 93:
_0x10B:
	CPI  R30,LOW(0x5D)
	LDI  R26,HIGH(0x5D)
	CPC  R31,R26
	BRNE _0x10C
; 0000 0D25 
; 0000 0D26             a[0] = 0x030;   //ster1
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x39
; 0000 0D27             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0D28             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0D29             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x51C
; 0000 0D2A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D2B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D2C 
; 0000 0D2D             a[1] = a[0]+0x001;  //ster2
; 0000 0D2E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D2F             a[6] = a[5]+0x001;  //okrag
; 0000 0D30             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D31 
; 0000 0D32     break;
; 0000 0D33 
; 0000 0D34 
; 0000 0D35     case 94:
_0x10C:
	CPI  R30,LOW(0x5E)
	LDI  R26,HIGH(0x5E)
	CPC  R31,R26
	BRNE _0x10D
; 0000 0D36 
; 0000 0D37             a[0] = 0x0F4;   //ster1
	LDI  R30,LOW(244)
	LDI  R31,HIGH(244)
	CALL SUBOPT_0x39
; 0000 0D38             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0D39             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0D3A             a[5] = 0x196;   //delta okrag
; 0000 0D3B             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0D3C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0D3D 
; 0000 0D3E             a[1] = a[0]+0x001;  //ster2
; 0000 0D3F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D40             a[6] = a[5]+0x001;  //okrag
; 0000 0D41             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D42 
; 0000 0D43     break;
; 0000 0D44 
; 0000 0D45 
; 0000 0D46     case 95:
_0x10D:
	CPI  R30,LOW(0x5F)
	LDI  R26,HIGH(0x5F)
	CPC  R31,R26
	BRNE _0x10E
; 0000 0D47 
; 0000 0D48             a[0] = 0x09E;   //ster1
	LDI  R30,LOW(158)
	LDI  R31,HIGH(158)
	CALL SUBOPT_0x39
; 0000 0D49             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0D4A             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 0D4B             a[5] = 0x199;   //delta okrag
; 0000 0D4C             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D4D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0D4E 
; 0000 0D4F             a[1] = a[0]+0x001;  //ster2
; 0000 0D50             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D51             a[6] = a[5]+0x001;  //okrag
; 0000 0D52             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D53 
; 0000 0D54     break;
; 0000 0D55 
; 0000 0D56     case 96:
_0x10E:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x10F
; 0000 0D57 
; 0000 0D58             a[0] = 0x;   //ster1
	CALL SUBOPT_0x54
; 0000 0D59             a[3] = 0x;    //ster4 INV druciak
; 0000 0D5A             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0D5B             a[5] = 0x;   //delta okrag
; 0000 0D5C             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0D5D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0D5E 
; 0000 0D5F             a[1] = a[0]+0x001;  //ster2
; 0000 0D60             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D61             a[6] = a[5]+0x001;  //okrag
; 0000 0D62             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D63 
; 0000 0D64     break;
; 0000 0D65 
; 0000 0D66 
; 0000 0D67     case 97:
_0x10F:
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BRNE _0x110
; 0000 0D68 
; 0000 0D69             a[0] = 0x06A;   //ster1
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	CALL SUBOPT_0x39
; 0000 0D6A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0D6B             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x46
; 0000 0D6C             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x40
; 0000 0D6D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D6E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0D6F 
; 0000 0D70             a[1] = a[0]+0x001;  //ster2
; 0000 0D71             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D72             a[6] = a[5]+0x001;  //okrag
; 0000 0D73             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D74 
; 0000 0D75     break;
; 0000 0D76 
; 0000 0D77 
; 0000 0D78     case 98:
_0x110:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x111
; 0000 0D79 
; 0000 0D7A             a[0] = 0x0BE;   //ster1
	LDI  R30,LOW(190)
	LDI  R31,HIGH(190)
	CALL SUBOPT_0x39
; 0000 0D7B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0D7C             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 0D7D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x63
; 0000 0D7E             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0D7F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0D80 
; 0000 0D81             a[1] = a[0]+0x001;  //ster2
; 0000 0D82             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D83             a[6] = a[5]+0x001;  //okrag
; 0000 0D84             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D85 
; 0000 0D86     break;
; 0000 0D87 
; 0000 0D88 
; 0000 0D89     case 99:
_0x111:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x112
; 0000 0D8A 
; 0000 0D8B             a[0] = 0x0BA;   //ster1
	LDI  R30,LOW(186)
	LDI  R31,HIGH(186)
	CALL SUBOPT_0x39
; 0000 0D8C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0D8D             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5C
; 0000 0D8E             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x51C
; 0000 0D8F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D90             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D91 
; 0000 0D92             a[1] = a[0]+0x001;  //ster2
; 0000 0D93             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D94             a[6] = a[5]+0x001;  //okrag
; 0000 0D95             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D96 
; 0000 0D97     break;
; 0000 0D98 
; 0000 0D99 
; 0000 0D9A     case 100:
_0x112:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRNE _0x113
; 0000 0D9B 
; 0000 0D9C             a[0] = 0x060;   //ster1
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x39
; 0000 0D9D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0D9E             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0D9F             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x40
; 0000 0DA0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DA1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0DA2 
; 0000 0DA3             a[1] = a[0]+0x001;  //ster2
; 0000 0DA4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DA5             a[6] = a[5]+0x001;  //okrag
; 0000 0DA6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DA7 
; 0000 0DA8     break;
; 0000 0DA9 
; 0000 0DAA 
; 0000 0DAB     case 101:
_0x113:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x114
; 0000 0DAC 
; 0000 0DAD             a[0] = 0x070;   //ster1
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	CALL SUBOPT_0x39
; 0000 0DAE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0DAF             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x46
; 0000 0DB0             a[5] = 0x199;   //delta okrag
	RJMP _0x51C
; 0000 0DB1             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DB2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DB3 
; 0000 0DB4             a[1] = a[0]+0x001;  //ster2
; 0000 0DB5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DB6             a[6] = a[5]+0x001;  //okrag
; 0000 0DB7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DB8 
; 0000 0DB9     break;
; 0000 0DBA 
; 0000 0DBB 
; 0000 0DBC     case 102:
_0x114:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BRNE _0x115
; 0000 0DBD 
; 0000 0DBE             a[0] = 0x08A;   //ster1
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	CALL SUBOPT_0x39
; 0000 0DBF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0DC0             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 0DC1             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x63
; 0000 0DC2             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0DC3             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DC4 
; 0000 0DC5             a[1] = a[0]+0x001;  //ster2
; 0000 0DC6             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DC7             a[6] = a[5]+0x001;  //okrag
; 0000 0DC8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DC9 
; 0000 0DCA     break;
; 0000 0DCB 
; 0000 0DCC 
; 0000 0DCD     case 103:
_0x115:
	CPI  R30,LOW(0x67)
	LDI  R26,HIGH(0x67)
	CPC  R31,R26
	BRNE _0x116
; 0000 0DCE 
; 0000 0DCF             a[0] = 0x080;   //ster1
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CALL SUBOPT_0x39
; 0000 0DD0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0DD1             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5C
; 0000 0DD2             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0DD3             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DD4             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0DD5 
; 0000 0DD6             a[1] = a[0]+0x001;  //ster2
; 0000 0DD7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DD8             a[6] = a[5]+0x001;  //okrag
; 0000 0DD9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DDA 
; 0000 0DDB     break;
; 0000 0DDC 
; 0000 0DDD 
; 0000 0DDE     case 104:
_0x116:
	CPI  R30,LOW(0x68)
	LDI  R26,HIGH(0x68)
	CPC  R31,R26
	BRNE _0x117
; 0000 0DDF 
; 0000 0DE0             a[0] = 0x0B6;   //ster1
	LDI  R30,LOW(182)
	LDI  R31,HIGH(182)
	CALL SUBOPT_0x39
; 0000 0DE1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0DE2             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0DE3             a[5] = 0x196;   //delta okrag
	RJMP _0x51C
; 0000 0DE4             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DE5             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DE6 
; 0000 0DE7             a[1] = a[0]+0x001;  //ster2
; 0000 0DE8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DE9             a[6] = a[5]+0x001;  //okrag
; 0000 0DEA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DEB 
; 0000 0DEC     break;
; 0000 0DED 
; 0000 0DEE 
; 0000 0DEF     case 105:
_0x117:
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x118
; 0000 0DF0 
; 0000 0DF1             a[0] = 0x044;   //ster1
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	CALL SUBOPT_0x39
; 0000 0DF2             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0DF3             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x64
; 0000 0DF4             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x4B
; 0000 0DF5             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0DF6             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0DF7 
; 0000 0DF8             a[1] = a[0]+0x001;  //ster2
; 0000 0DF9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DFA             a[6] = a[5]+0x001;  //okrag
; 0000 0DFB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DFC 
; 0000 0DFD     break;
; 0000 0DFE 
; 0000 0DFF 
; 0000 0E00     case 106:
_0x118:
	CPI  R30,LOW(0x6A)
	LDI  R26,HIGH(0x6A)
	CPC  R31,R26
	BRNE _0x119
; 0000 0E01 
; 0000 0E02             a[0] = 0x03A;   //ster1
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	CALL SUBOPT_0x39
; 0000 0E03             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0E04             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0E05             a[5] = 0x190;   //delta okrag
; 0000 0E06             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0E07             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E08 
; 0000 0E09             a[1] = a[0]+0x001;  //ster2
; 0000 0E0A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E0B             a[6] = a[5]+0x001;  //okrag
; 0000 0E0C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E0D 
; 0000 0E0E     break;
; 0000 0E0F 
; 0000 0E10 
; 0000 0E11     case 107:
_0x119:
	CPI  R30,LOW(0x6B)
	LDI  R26,HIGH(0x6B)
	CPC  R31,R26
	BRNE _0x11A
; 0000 0E12 
; 0000 0E13             a[0] = 0x;   //ster1
	CALL SUBOPT_0x54
; 0000 0E14             a[3] = 0x;    //ster4 INV druciak
; 0000 0E15             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0E16             a[5] = 0x;   //delta okrag
; 0000 0E17             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0E18             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0E19 
; 0000 0E1A             a[1] = a[0]+0x001;  //ster2
; 0000 0E1B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E1C             a[6] = a[5]+0x001;  //okrag
; 0000 0E1D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E1E 
; 0000 0E1F     break;
; 0000 0E20 
; 0000 0E21 
; 0000 0E22     case 108:
_0x11A:
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BRNE _0x11B
; 0000 0E23 
; 0000 0E24             a[0] = 0x0C6;   //ster1
	LDI  R30,LOW(198)
	LDI  R31,HIGH(198)
	CALL SUBOPT_0x39
; 0000 0E25             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0E26             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0E27             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5B
; 0000 0E28             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0E29             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0E2A 
; 0000 0E2B             a[1] = a[0]+0x001;  //ster2
; 0000 0E2C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E2D             a[6] = a[5]+0x001;  //okrag
; 0000 0E2E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E2F 
; 0000 0E30     break;
; 0000 0E31 
; 0000 0E32 
; 0000 0E33     case 109:
_0x11B:
	CPI  R30,LOW(0x6D)
	LDI  R26,HIGH(0x6D)
	CPC  R31,R26
	BRNE _0x11C
; 0000 0E34 
; 0000 0E35             a[0] = 0x00A;   //ster1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x39
; 0000 0E36             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 0E37             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 0E38             a[5] = 0x190;   //delta okrag
; 0000 0E39             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x51A
; 0000 0E3A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E3B 
; 0000 0E3C             a[1] = a[0]+0x001;  //ster2
; 0000 0E3D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E3E             a[6] = a[5]+0x001;  //okrag
; 0000 0E3F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E40 
; 0000 0E41     break;
; 0000 0E42 
; 0000 0E43 
; 0000 0E44     case 110:
_0x11C:
	CPI  R30,LOW(0x6E)
	LDI  R26,HIGH(0x6E)
	CPC  R31,R26
	BRNE _0x11D
; 0000 0E45 
; 0000 0E46             a[0] = 0x032;   //ster1
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x39
; 0000 0E47             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0E48             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0E49             a[5] = 0x190;   //delta okrag
; 0000 0E4A             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0E4B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0E4C 
; 0000 0E4D             a[1] = a[0]+0x001;  //ster2
; 0000 0E4E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E4F             a[6] = a[5]+0x001;  //okrag
; 0000 0E50             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E51 
; 0000 0E52     break;
; 0000 0E53 
; 0000 0E54 
; 0000 0E55     case 111:
_0x11D:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x11E
; 0000 0E56 
; 0000 0E57             a[0] = 0x;   //ster1
	CALL SUBOPT_0x54
; 0000 0E58             a[3] = 0x;    //ster4 INV druciak
; 0000 0E59             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0E5A             a[5] = 0x;   //delta okrag
; 0000 0E5B             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0E5C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0E5D 
; 0000 0E5E             a[1] = a[0]+0x001;  //ster2
; 0000 0E5F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E60             a[6] = a[5]+0x001;  //okrag
; 0000 0E61             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E62 
; 0000 0E63     break;
; 0000 0E64 
; 0000 0E65 
; 0000 0E66     case 112:
_0x11E:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x11F
; 0000 0E67 
; 0000 0E68             a[0] = 0x0E2;   //ster1
	LDI  R30,LOW(226)
	LDI  R31,HIGH(226)
	CALL SUBOPT_0x39
; 0000 0E69             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0E6A             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0E6B             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5B
; 0000 0E6C             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0E6D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E6E 
; 0000 0E6F             a[1] = a[0]+0x001;  //ster2
; 0000 0E70             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E71             a[6] = a[5]+0x001;  //okrag
; 0000 0E72             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E73 
; 0000 0E74     break;
; 0000 0E75 
; 0000 0E76 
; 0000 0E77     case 113:
_0x11F:
	CPI  R30,LOW(0x71)
	LDI  R26,HIGH(0x71)
	CPC  R31,R26
	BRNE _0x120
; 0000 0E78 
; 0000 0E79             a[0] = 0x0D4;   //ster1
	LDI  R30,LOW(212)
	LDI  R31,HIGH(212)
	CALL SUBOPT_0x39
; 0000 0E7A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0E7B             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x65
; 0000 0E7C             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5B
; 0000 0E7D             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0E7E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0E7F 
; 0000 0E80             a[1] = a[0]+0x001;  //ster2
; 0000 0E81             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E82             a[6] = a[5]+0x001;  //okrag
; 0000 0E83             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E84 
; 0000 0E85     break;
; 0000 0E86 
; 0000 0E87 
; 0000 0E88     case 114:
_0x120:
	CPI  R30,LOW(0x72)
	LDI  R26,HIGH(0x72)
	CPC  R31,R26
	BRNE _0x121
; 0000 0E89 
; 0000 0E8A             a[0] = 0x04A;   //ster1
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	CALL SUBOPT_0x39
; 0000 0E8B             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 0E8C             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x66
; 0000 0E8D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x61
; 0000 0E8E             a[7] = 0x0F;    //ster3 INV krazek scierny
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	CALL SUBOPT_0x42
; 0000 0E8F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0E90 
; 0000 0E91             a[1] = a[0]+0x001;  //ster2
; 0000 0E92             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E93             a[6] = a[5]+0x001;  //okrag
; 0000 0E94             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E95 
; 0000 0E96     break;
; 0000 0E97 
; 0000 0E98 
; 0000 0E99     case 115:
_0x121:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x122
; 0000 0E9A 
; 0000 0E9B             a[0] = 0x076;   //ster1
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	CALL SUBOPT_0x39
; 0000 0E9C             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x67
; 0000 0E9D             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0E9E             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x43
; 0000 0E9F             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0EA0             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0EA1 
; 0000 0EA2             a[1] = a[0]+0x001;  //ster2
; 0000 0EA3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EA4             a[6] = a[5]+0x001;  //okrag
; 0000 0EA5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EA6 
; 0000 0EA7     break;
; 0000 0EA8 
; 0000 0EA9 
; 0000 0EAA     case 116:
_0x122:
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BRNE _0x123
; 0000 0EAB 
; 0000 0EAC             a[0] = 0x092;   //ster1
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	CALL SUBOPT_0x39
; 0000 0EAD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0EAE             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 0EAF             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x51C
; 0000 0EB0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0EB1             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EB2 
; 0000 0EB3             a[1] = a[0]+0x001;  //ster2
; 0000 0EB4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EB5             a[6] = a[5]+0x001;  //okrag
; 0000 0EB6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EB7 
; 0000 0EB8     break;
; 0000 0EB9 
; 0000 0EBA 
; 0000 0EBB 
; 0000 0EBC     case 117:
_0x123:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x124
; 0000 0EBD 
; 0000 0EBE             a[0] = 0x11A;   //ster1
	LDI  R30,LOW(282)
	LDI  R31,HIGH(282)
	CALL SUBOPT_0x39
; 0000 0EBF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0EC0             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x65
; 0000 0EC1             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5B
; 0000 0EC2             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0EC3             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EC4 
; 0000 0EC5             a[1] = a[0]+0x001;  //ster2
; 0000 0EC6             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EC7             a[6] = a[5]+0x001;  //okrag
; 0000 0EC8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EC9 
; 0000 0ECA     break;
; 0000 0ECB 
; 0000 0ECC 
; 0000 0ECD 
; 0000 0ECE     case 118:
_0x124:
	CPI  R30,LOW(0x76)
	LDI  R26,HIGH(0x76)
	CPC  R31,R26
	BRNE _0x125
; 0000 0ECF 
; 0000 0ED0             a[0] = 0x056;   //ster1
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	CALL SUBOPT_0x39
; 0000 0ED1             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 0ED2             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x66
; 0000 0ED3             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5B
; 0000 0ED4             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0ED5             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0ED6 
; 0000 0ED7             a[1] = a[0]+0x001;  //ster2
; 0000 0ED8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0ED9             a[6] = a[5]+0x001;  //okrag
; 0000 0EDA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EDB 
; 0000 0EDC     break;
; 0000 0EDD 
; 0000 0EDE 
; 0000 0EDF     case 119:
_0x125:
	CPI  R30,LOW(0x77)
	LDI  R26,HIGH(0x77)
	CPC  R31,R26
	BRNE _0x126
; 0000 0EE0 
; 0000 0EE1             a[0] = 0x072;   //ster1
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	CALL SUBOPT_0x39
; 0000 0EE2             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x67
; 0000 0EE3             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0EE4             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x43
; 0000 0EE5             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0EE6             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EE7 
; 0000 0EE8             a[1] = a[0]+0x001;  //ster2
; 0000 0EE9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EEA             a[6] = a[5]+0x001;  //okrag
; 0000 0EEB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EEC 
; 0000 0EED     break;
; 0000 0EEE 
; 0000 0EEF 
; 0000 0EF0     case 120:
_0x126:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x127
; 0000 0EF1 
; 0000 0EF2             a[0] = 0x0D0;   //ster1
	LDI  R30,LOW(208)
	LDI  R31,HIGH(208)
	CALL SUBOPT_0x39
; 0000 0EF3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0EF4             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 0EF5             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4F
; 0000 0EF6             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0EF7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0EF8 
; 0000 0EF9             a[1] = a[0]+0x001;  //ster2
; 0000 0EFA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EFB             a[6] = a[5]+0x001;  //okrag
; 0000 0EFC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EFD 
; 0000 0EFE     break;
; 0000 0EFF 
; 0000 0F00 
; 0000 0F01     case 121:
_0x127:
	CPI  R30,LOW(0x79)
	LDI  R26,HIGH(0x79)
	CPC  R31,R26
	BRNE _0x128
; 0000 0F02 
; 0000 0F03             a[0] = 0x048;   //ster1
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	CALL SUBOPT_0x39
; 0000 0F04             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 0F05             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x66
; 0000 0F06             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5B
; 0000 0F07             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0F08             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0F09 
; 0000 0F0A             a[1] = a[0]+0x001;  //ster2
; 0000 0F0B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F0C             a[6] = a[5]+0x001;  //okrag
; 0000 0F0D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F0E 
; 0000 0F0F     break;
; 0000 0F10 
; 0000 0F11 
; 0000 0F12     case 122:
_0x128:
	CPI  R30,LOW(0x7A)
	LDI  R26,HIGH(0x7A)
	CPC  R31,R26
	BRNE _0x129
; 0000 0F13 
; 0000 0F14             a[0] = 0x09A;   //ster1
	LDI  R30,LOW(154)
	LDI  R31,HIGH(154)
	CALL SUBOPT_0x39
; 0000 0F15             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0F16             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5C
; 0000 0F17             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4F
; 0000 0F18             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F19             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0F1A 
; 0000 0F1B             a[1] = a[0]+0x001;  //ster2
; 0000 0F1C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F1D             a[6] = a[5]+0x001;  //okrag
; 0000 0F1E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F1F 
; 0000 0F20     break;
; 0000 0F21 
; 0000 0F22 
; 0000 0F23     case 123:
_0x129:
	CPI  R30,LOW(0x7B)
	LDI  R26,HIGH(0x7B)
	CPC  R31,R26
	BRNE _0x12A
; 0000 0F24 
; 0000 0F25             a[0] = 0x046;   //ster1
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL SUBOPT_0x39
; 0000 0F26             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 0F27             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x68
; 0000 0F28             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x69
; 0000 0F29             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0F2A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0F2B 
; 0000 0F2C             a[1] = a[0]+0x001;  //ster2
; 0000 0F2D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F2E             a[6] = a[5]+0x001;  //okrag
; 0000 0F2F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F30 
; 0000 0F31     break;
; 0000 0F32 
; 0000 0F33 
; 0000 0F34 
; 0000 0F35     case 124:
_0x12A:
	CPI  R30,LOW(0x7C)
	LDI  R26,HIGH(0x7C)
	CPC  R31,R26
	BRNE _0x12B
; 0000 0F36 
; 0000 0F37             a[0] = 0x0E0;   //ster1
	LDI  R30,LOW(224)
	LDI  R31,HIGH(224)
	CALL SUBOPT_0x39
; 0000 0F38             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x6A
; 0000 0F39             a[4] = 0x15;    //ster3 ABS krazek scierny
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL SUBOPT_0x5F
; 0000 0F3A             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x61
; 0000 0F3B             a[7] = 0x13;    //ster3 INV krazek scierny
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	CALL SUBOPT_0x42
; 0000 0F3C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0F3D 
; 0000 0F3E             a[1] = a[0]+0x001;  //ster2
; 0000 0F3F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F40             a[6] = a[5]+0x001;  //okrag
; 0000 0F41             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F42 
; 0000 0F43     break;
; 0000 0F44 
; 0000 0F45 
; 0000 0F46     case 125:
_0x12B:
	CPI  R30,LOW(0x7D)
	LDI  R26,HIGH(0x7D)
	CPC  R31,R26
	BRNE _0x12C
; 0000 0F47 
; 0000 0F48             a[0] = 0x038;   //ster1
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	CALL SUBOPT_0x39
; 0000 0F49             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0F4A             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5C
; 0000 0F4B             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5B
; 0000 0F4C             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0F4D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F4E 
; 0000 0F4F             a[1] = a[0]+0x001;  //ster2
; 0000 0F50             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F51             a[6] = a[5]+0x001;  //okrag
; 0000 0F52             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F53 
; 0000 0F54     break;
; 0000 0F55 
; 0000 0F56 
; 0000 0F57     case 126:
_0x12C:
	CPI  R30,LOW(0x7E)
	LDI  R26,HIGH(0x7E)
	CPC  R31,R26
	BRNE _0x12D
; 0000 0F58 
; 0000 0F59             a[0] = 0x0CA;   //ster1
	LDI  R30,LOW(202)
	LDI  R31,HIGH(202)
	CALL SUBOPT_0x39
; 0000 0F5A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0F5B             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5C
; 0000 0F5C             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x51C
; 0000 0F5D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F5E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F5F 
; 0000 0F60             a[1] = a[0]+0x001;  //ster2
; 0000 0F61             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F62             a[6] = a[5]+0x001;  //okrag
; 0000 0F63             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F64 
; 0000 0F65     break;
; 0000 0F66 
; 0000 0F67 
; 0000 0F68     case 127:
_0x12D:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0x12E
; 0000 0F69 
; 0000 0F6A             a[0] = 0x0DE;   //ster1
	LDI  R30,LOW(222)
	LDI  R31,HIGH(222)
	CALL SUBOPT_0x39
; 0000 0F6B             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 0F6C             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x68
; 0000 0F6D             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x69
; 0000 0F6E             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0F6F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F70 
; 0000 0F71             a[1] = a[0]+0x001;  //ster2
; 0000 0F72             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F73             a[6] = a[5]+0x001;  //okrag
; 0000 0F74             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F75 
; 0000 0F76     break;
; 0000 0F77 
; 0000 0F78 
; 0000 0F79     case 128:
_0x12E:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x12F
; 0000 0F7A 
; 0000 0F7B             a[0] = 0x116;   //ster1
	LDI  R30,LOW(278)
	LDI  R31,HIGH(278)
	CALL SUBOPT_0x39
; 0000 0F7C             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 0F7D             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x3F
; 0000 0F7E             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6B
; 0000 0F7F             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0F80             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F81 
; 0000 0F82             a[1] = a[0]+0x001;  //ster2
; 0000 0F83             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F84             a[6] = a[5]+0x001;  //okrag
; 0000 0F85             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F86 
; 0000 0F87     break;
; 0000 0F88 
; 0000 0F89 
; 0000 0F8A     case 129:
_0x12F:
	CPI  R30,LOW(0x81)
	LDI  R26,HIGH(0x81)
	CPC  R31,R26
	BRNE _0x130
; 0000 0F8B 
; 0000 0F8C             a[0] = 0x0E8;   //ster1
	LDI  R30,LOW(232)
	LDI  R31,HIGH(232)
	CALL SUBOPT_0x39
; 0000 0F8D             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x6A
; 0000 0F8E             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6C
; 0000 0F8F             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x6B
; 0000 0F90             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 0F91             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0F92 
; 0000 0F93             a[1] = a[0]+0x001;  //ster2
; 0000 0F94             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F95             a[6] = a[5]+0x001;  //okrag
; 0000 0F96             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F97 
; 0000 0F98     break;
; 0000 0F99 
; 0000 0F9A 
; 0000 0F9B     case 130:
_0x130:
	CPI  R30,LOW(0x82)
	LDI  R26,HIGH(0x82)
	CPC  R31,R26
	BRNE _0x131
; 0000 0F9C 
; 0000 0F9D             a[0] = 0x0F2;   //ster1
	LDI  R30,LOW(242)
	LDI  R31,HIGH(242)
	CALL SUBOPT_0x39
; 0000 0F9E             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x6D
; 0000 0F9F             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0FA0             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x61
; 0000 0FA1             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3C
; 0000 0FA2             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3E
	RJMP _0x51B
; 0000 0FA3 
; 0000 0FA4             a[1] = a[0]+0x001;  //ster2
; 0000 0FA5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FA6             a[6] = a[5]+0x001;  //okrag
; 0000 0FA7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FA8 
; 0000 0FA9     break;
; 0000 0FAA 
; 0000 0FAB 
; 0000 0FAC     case 131:
_0x131:
	CPI  R30,LOW(0x83)
	LDI  R26,HIGH(0x83)
	CPC  R31,R26
	BRNE _0x132
; 0000 0FAD 
; 0000 0FAE             a[0] = 0x108;   //ster1
	LDI  R30,LOW(264)
	LDI  R31,HIGH(264)
	CALL SUBOPT_0x39
; 0000 0FAF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0FB0             a[4] = 0x1F;    //ster3 ABS krazek scierny
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP _0x51D
; 0000 0FB1             a[5] = 0x19C;   //delta okrag
; 0000 0FB2             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FB3             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FB4 
; 0000 0FB5             a[1] = a[0]+0x001;  //ster2
; 0000 0FB6             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FB7             a[6] = a[5]+0x001;  //okrag
; 0000 0FB8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FB9 
; 0000 0FBA     break;
; 0000 0FBB 
; 0000 0FBC 
; 0000 0FBD 
; 0000 0FBE     case 132:
_0x132:
	CPI  R30,LOW(0x84)
	LDI  R26,HIGH(0x84)
	CPC  R31,R26
	BRNE _0x133
; 0000 0FBF 
; 0000 0FC0             a[0] = 0x064;   //ster1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x39
; 0000 0FC1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0FC2             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0FC3             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x52
; 0000 0FC4             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FC5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0FC6 
; 0000 0FC7             a[1] = a[0]+0x001;  //ster2
; 0000 0FC8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FC9             a[6] = a[5]+0x001;  //okrag
; 0000 0FCA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FCB 
; 0000 0FCC     break;
; 0000 0FCD 
; 0000 0FCE 
; 0000 0FCF     case 133:
_0x133:
	CPI  R30,LOW(0x85)
	LDI  R26,HIGH(0x85)
	CPC  R31,R26
	BRNE _0x134
; 0000 0FD0 
; 0000 0FD1             a[0] = 0x088;   //ster1
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	CALL SUBOPT_0x39
; 0000 0FD2             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x6A
; 0000 0FD3             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6C
; 0000 0FD4             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x6B
; 0000 0FD5             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 0FD6             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FD7 
; 0000 0FD8             a[1] = a[0]+0x001;  //ster2
; 0000 0FD9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FDA             a[6] = a[5]+0x001;  //okrag
; 0000 0FDB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FDC 
; 0000 0FDD     break;
; 0000 0FDE 
; 0000 0FDF 
; 0000 0FE0 
; 0000 0FE1     case 134:
_0x134:
	CPI  R30,LOW(0x86)
	LDI  R26,HIGH(0x86)
	CPC  R31,R26
	BRNE _0x135
; 0000 0FE2 
; 0000 0FE3             a[0] = 0x10E;   //ster1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x39
; 0000 0FE4             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x6D
; 0000 0FE5             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0FE6             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x61
; 0000 0FE7             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x51A
; 0000 0FE8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FE9 
; 0000 0FEA             a[1] = a[0]+0x001;  //ster2
; 0000 0FEB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FEC             a[6] = a[5]+0x001;  //okrag
; 0000 0FED             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FEE 
; 0000 0FEF     break;
; 0000 0FF0 
; 0000 0FF1                ////////////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 0FF2      case 135:
_0x135:
	CPI  R30,LOW(0x87)
	LDI  R26,HIGH(0x87)
	CPC  R31,R26
	BRNE _0x136
; 0000 0FF3 
; 0000 0FF4             a[0] = 0x054;   //ster1
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CALL SUBOPT_0x39
; 0000 0FF5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 0FF6             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x64
; 0000 0FF7             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x52
; 0000 0FF8             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FF9             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 0FFA 
; 0000 0FFB             a[1] = a[0]+0x001;  //ster2
; 0000 0FFC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FFD             a[6] = a[5]+0x001;  //okrag
; 0000 0FFE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FFF 
; 0000 1000     break;
; 0000 1001 
; 0000 1002 
; 0000 1003      case 136:
_0x136:
	CPI  R30,LOW(0x88)
	LDI  R26,HIGH(0x88)
	CPC  R31,R26
	BRNE _0x137
; 0000 1004 
; 0000 1005             a[0] = 0x03E;   //ster1
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	CALL SUBOPT_0x39
; 0000 1006             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 1007             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x6C
; 0000 1008             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x6E
; 0000 1009             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x51A
; 0000 100A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 100B 
; 0000 100C             a[1] = a[0]+0x001;  //ster2
; 0000 100D             a[2] = a[4];        //ster4 ABS druciak
; 0000 100E             a[6] = a[5]+0x001;  //okrag
; 0000 100F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1010 
; 0000 1011     break;
; 0000 1012 
; 0000 1013      case 137:
_0x137:
	CPI  R30,LOW(0x89)
	LDI  R26,HIGH(0x89)
	CPC  R31,R26
	BRNE _0x138
; 0000 1014 
; 0000 1015             a[0] = 0x00C;   //ster1
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x39
; 0000 1016             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 1017             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 1018             a[5] = 0x190;   //delta okrag
; 0000 1019             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 101A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 101B 
; 0000 101C             a[1] = a[0]+0x001;  //ster2
; 0000 101D             a[2] = a[4];        //ster4 ABS druciak
; 0000 101E             a[6] = a[5]+0x001;  //okrag
; 0000 101F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1020 
; 0000 1021     break;
; 0000 1022 
; 0000 1023 
; 0000 1024      case 138:
_0x138:
	CPI  R30,LOW(0x8A)
	LDI  R26,HIGH(0x8A)
	CPC  R31,R26
	BRNE _0x139
; 0000 1025 
; 0000 1026             a[0] = 0x0DC;   //ster1
	LDI  R30,LOW(220)
	LDI  R31,HIGH(220)
	CALL SUBOPT_0x39
; 0000 1027             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 1028             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x3B
; 0000 1029             a[5] = 0x196;   //delta okrag
; 0000 102A             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 102B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 102C 
; 0000 102D             a[1] = a[0]+0x001;  //ster2
; 0000 102E             a[2] = a[4];        //ster4 ABS druciak
; 0000 102F             a[6] = a[5]+0x001;  //okrag
; 0000 1030             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1031 
; 0000 1032     break;
; 0000 1033 
; 0000 1034 
; 0000 1035      case 139:
_0x139:
	CPI  R30,LOW(0x8B)
	LDI  R26,HIGH(0x8B)
	CPC  R31,R26
	BRNE _0x13A
; 0000 1036 
; 0000 1037             a[0] = 0x058;   //ster1
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	CALL SUBOPT_0x39
; 0000 1038             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 1039             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x65
; 0000 103A             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x51C
; 0000 103B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 103C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 103D 
; 0000 103E             a[1] = a[0]+0x001;  //ster2
; 0000 103F             a[2] = a[4];        //ster4 ABS druciak
; 0000 1040             a[6] = a[5]+0x001;  //okrag
; 0000 1041             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1042 
; 0000 1043     break;
; 0000 1044 
; 0000 1045 
; 0000 1046      case 140:
_0x13A:
	CPI  R30,LOW(0x8C)
	LDI  R26,HIGH(0x8C)
	CPC  R31,R26
	BRNE _0x13B
; 0000 1047 
; 0000 1048             a[0] = 0x03C;   //ster1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0x39
; 0000 1049             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 104A             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x68
; 0000 104B             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x6E
; 0000 104C             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3C
; 0000 104D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3E
	RJMP _0x51B
; 0000 104E 
; 0000 104F             a[1] = a[0]+0x001;  //ster2
; 0000 1050             a[2] = a[4];        //ster4 ABS druciak
; 0000 1051             a[6] = a[5]+0x001;  //okrag
; 0000 1052             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1053 
; 0000 1054 
; 0000 1055 
; 0000 1056     break;
; 0000 1057 
; 0000 1058 
; 0000 1059      case 141:
_0x13B:
	CPI  R30,LOW(0x8D)
	LDI  R26,HIGH(0x8D)
	CPC  R31,R26
	BRNE _0x13C
; 0000 105A 
; 0000 105B             a[0] = 0x00E;   //ster1
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x39
; 0000 105C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 105D             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 105E             a[5] = 0x190;   //delta okrag
; 0000 105F             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x51A
; 0000 1060             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1061 
; 0000 1062             a[1] = a[0]+0x001;  //ster2
; 0000 1063             a[2] = a[4];        //ster4 ABS druciak
; 0000 1064             a[6] = a[5]+0x001;  //okrag
; 0000 1065             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1066 
; 0000 1067     break;
; 0000 1068 
; 0000 1069 
; 0000 106A      case 142:
_0x13C:
	CPI  R30,LOW(0x8E)
	LDI  R26,HIGH(0x8E)
	CPC  R31,R26
	BRNE _0x13D
; 0000 106B 
; 0000 106C             a[0] = 0x10A;   //ster1
	LDI  R30,LOW(266)
	LDI  R31,HIGH(266)
	CALL SUBOPT_0x39
; 0000 106D             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3C
; 0000 106E             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x3B
; 0000 106F             a[5] = 0x196;   //delta okrag
; 0000 1070             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x42
; 0000 1071             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 1072 
; 0000 1073             a[1] = a[0]+0x001;  //ster2
; 0000 1074             a[2] = a[4];        //ster4 ABS druciak
; 0000 1075             a[6] = a[5]+0x001;  //okrag
; 0000 1076             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1077 
; 0000 1078     break;
; 0000 1079 
; 0000 107A 
; 0000 107B 
; 0000 107C      case 143:
_0x13D:
	CPI  R30,LOW(0x8F)
	LDI  R26,HIGH(0x8F)
	CPC  R31,R26
	BRNE _0x13E
; 0000 107D 
; 0000 107E             a[0] = 0x022;   //ster1
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL SUBOPT_0x39
; 0000 107F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 1080             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x65
; 0000 1081             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4F
; 0000 1082             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 1083             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x51B
; 0000 1084 
; 0000 1085             a[1] = a[0]+0x001;  //ster2
; 0000 1086             a[2] = a[4];        //ster4 ABS druciak
; 0000 1087             a[6] = a[5]+0x001;  //okrag
; 0000 1088             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1089 
; 0000 108A     break;
; 0000 108B 
; 0000 108C 
; 0000 108D      case 144:
_0x13E:
	CPI  R30,LOW(0x90)
	LDI  R26,HIGH(0x90)
	CPC  R31,R26
	BRNE _0xAE
; 0000 108E 
; 0000 108F             a[0] = 0x066;   //ster1
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	CALL SUBOPT_0x39
; 0000 1090             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3A
; 0000 1091             a[4] = 0x1C;    //ster3 ABS krazek scierny
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
_0x51D:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1092             a[5] = 0x19C;   //delta okrag
	__POINTW1MN _a,10
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
_0x51C:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1093             a[7] = 0x12;    //ster3 INV krazek scierny
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
_0x51A:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1094             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	__POINTW1MN _a,18
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
_0x51B:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1095 
; 0000 1096             a[1] = a[0]+0x001;  //ster2
	CALL SUBOPT_0x6F
	ADIW R30,1
	__PUTW1MN _a,2
; 0000 1097             a[2] = a[4];        //ster4 ABS druciak
	CALL SUBOPT_0x70
	__PUTW1MN _a,4
; 0000 1098             a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x71
	CALL SUBOPT_0x72
; 0000 1099             a[8] = a[6]+0x001;  //-delta okrag
; 0000 109A 
; 0000 109B     break;
; 0000 109C 
; 0000 109D 
; 0000 109E }
_0xAE:
; 0000 109F 
; 0000 10A0 //if(predkosc_pion_szczotka == 50)   //zwolnienie predkosci pion
; 0000 10A1 //       {
; 0000 10A2 //       a[3] = a[3] - 0x05;
; 0000 10A3 //       }
; 0000 10A4 
; 0000 10A5 if(tryb_pracy_szczotki_drucianej == 1)
	CALL SUBOPT_0x73
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x140
; 0000 10A6          a[3] = a[3];
	CALL SUBOPT_0x74
	CALL SUBOPT_0x75
; 0000 10A7 
; 0000 10A8 if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)
_0x140:
	CALL SUBOPT_0x73
	CALL SUBOPT_0x76
	BREQ _0x141
; 0000 10A9          a[3] = a[3]-0x05;
	CALL SUBOPT_0x74
	SBIW R30,5
	CALL SUBOPT_0x75
; 0000 10AA 
; 0000 10AB //if(predkosc_pion_krazek == 50)   //zwolnienie predkosci pion krazek
; 0000 10AC //       {
; 0000 10AD //       a[7] = a[7] - 0x05;
; 0000 10AE //       }
; 0000 10AF 
; 0000 10B0 a[3] = a[3]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT
_0x141:
	CALL SUBOPT_0x74
	SBIW R30,6
	CALL SUBOPT_0x75
; 0000 10B1 a[2] = a[2]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT
	CALL SUBOPT_0x77
	SBIW R30,6
	__PUTW1MN _a,4
; 0000 10B2 
; 0000 10B3 
; 0000 10B4 
; 0000 10B5 if(krazek_scierny_cykl_po_okregu_ilosc == 0 | ruch_haos == 1)
	CALL SUBOPT_0x78
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x79
	CALL SUBOPT_0x7A
	OR   R30,R0
	BREQ _0x142
; 0000 10B6         a[7] = a[7] - 0x05;
	CALL SUBOPT_0x7B
	SBIW R30,5
	__PUTW1MN _a,14
; 0000 10B7 
; 0000 10B8 if(srednica_krazka_sciernego == 40)
_0x142:
	CALL SUBOPT_0x7C
	SBIW R26,40
	BRNE _0x143
; 0000 10B9         a[4] = a[4]+ 0x13;
	CALL SUBOPT_0x70
	ADIW R30,19
	__PUTW1MN _a,8
; 0000 10BA 
; 0000 10BB                                                      //2
; 0000 10BC if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 30)
_0x143:
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7E
; 0000 10BD     {
; 0000 10BE     }
; 0000 10BF 
; 0000 10C0                                                    //2
; 0000 10C1 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 30)
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x7E
	BREQ _0x145
; 0000 10C2     {
; 0000 10C3     a[5] = a[5] + 0x10;   //plus 16 dzesietnie
	CALL SUBOPT_0x71
	ADIW R30,16
	CALL SUBOPT_0x80
; 0000 10C4     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x72
; 0000 10C5     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10C6     }
; 0000 10C7                                                     //1
; 0000 10C8 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 30)
_0x145:
	CALL SUBOPT_0x81
	CALL SUBOPT_0x7E
	BREQ _0x146
; 0000 10C9     {
; 0000 10CA     a[5] = a[5] + 0x20;   //plus 32 dzesietnie
	CALL SUBOPT_0x71
	ADIW R30,32
	CALL SUBOPT_0x80
; 0000 10CB     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x72
; 0000 10CC     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10CD     }
; 0000 10CE 
; 0000 10CF                                                     //2
; 0000 10D0 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 30)
_0x146:
	CALL SUBOPT_0x82
	CALL SUBOPT_0x7E
	BREQ _0x147
; 0000 10D1     {
; 0000 10D2     a[5] = a[5] + 0x30;   //plus 48 dzesietnie
	CALL SUBOPT_0x71
	ADIW R30,48
	CALL SUBOPT_0x80
; 0000 10D3     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x72
; 0000 10D4     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10D5     }
; 0000 10D6 
; 0000 10D7 /////////////////////////////////////////////////////////////////////////////////////
; 0000 10D8 
; 0000 10D9 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 40)
_0x147:
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x83
	BREQ _0x148
; 0000 10DA     {
; 0000 10DB     a[5] = a[5] + 0x39;   //plus 66 dzesietnie   ///////////////
	CALL SUBOPT_0x71
	ADIW R30,57
	CALL SUBOPT_0x80
; 0000 10DC     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x72
; 0000 10DD     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10DE     }
; 0000 10DF 
; 0000 10E0                                                    //2
; 0000 10E1 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 40)
_0x148:
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x83
	BREQ _0x149
; 0000 10E2     {
; 0000 10E3     a[5] = a[5] + 0x42;   //plus 16 dzesietnie
	CALL SUBOPT_0x71
	SUBI R30,LOW(-66)
	SBCI R31,HIGH(-66)
	CALL SUBOPT_0x80
; 0000 10E4     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x72
; 0000 10E5     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10E6     }
; 0000 10E7                                                     //1
; 0000 10E8 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 40)
_0x149:
	CALL SUBOPT_0x81
	CALL SUBOPT_0x83
	BREQ _0x14A
; 0000 10E9     {
; 0000 10EA     a[5] = a[5] + 0x4B;   //plus 32 dzesietnie
	CALL SUBOPT_0x71
	SUBI R30,LOW(-75)
	SBCI R31,HIGH(-75)
	CALL SUBOPT_0x80
; 0000 10EB     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x72
; 0000 10EC     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10ED     }
; 0000 10EE 
; 0000 10EF                                                     //2
; 0000 10F0 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 40)
_0x14A:
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
	BREQ _0x14B
; 0000 10F1     {
; 0000 10F2     a[5] = a[5] + 0x54;   //plus 48 dzesietnie
	CALL SUBOPT_0x71
	SUBI R30,LOW(-84)
	SBCI R31,HIGH(-84)
	CALL SUBOPT_0x80
; 0000 10F3     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x72
; 0000 10F4     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10F5     }
; 0000 10F6 
; 0000 10F7 }
_0x14B:
	ADIW R28,2
	RET
;
;void obsluga_nacisniecia_zatrzymaj()
; 0000 10FA {
_obsluga_nacisniecia_zatrzymaj:
; 0000 10FB int sg;
; 0000 10FC sg = 0;
	CALL SUBOPT_0x2
;	sg -> R16,R17
; 0000 10FD 
; 0000 10FE   if(sek20 > 60)
	LDS  R26,_sek20
	LDS  R27,_sek20+1
	LDS  R24,_sek20+2
	LDS  R25,_sek20+3
	CALL SUBOPT_0x84
	BRGE PC+3
	JMP _0x14C
; 0000 10FF    {
; 0000 1100    sek20 = 0;
	LDI  R30,LOW(0)
	STS  _sek20,R30
	STS  _sek20+1,R30
	STS  _sek20+2,R30
	STS  _sek20+3,R30
; 0000 1101    while(sprawdz_pin2(PORTMM,0x77) == 0)
_0x14D:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x14F
; 0000 1102         {
; 0000 1103         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x85
; 0000 1104         PORTD.7 = 1;
; 0000 1105         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x152
; 0000 1106            {
; 0000 1107            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x86
; 0000 1108            PORTE.2 = 0;
; 0000 1109            }
; 0000 110A 
; 0000 110B         if(PORTE.3 == 1)
_0x152:
	SBIS 0x3,3
	RJMP _0x155
; 0000 110C            {
; 0000 110D            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x87
; 0000 110E            PORTE.3 = 0;
; 0000 110F            }
; 0000 1110 
; 0000 1111          if(PORT_F.bits.b4 == 1)
_0x155:
	CALL SUBOPT_0x88
	BRNE _0x158
; 0000 1112             {
; 0000 1113             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x89
; 0000 1114             zastopowany_czas_przedmuchu = sek12;
; 0000 1115             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1116             PORTF = PORT_F.byte;
; 0000 1117             }
; 0000 1118 
; 0000 1119 
; 0000 111A         komunikat_na_panel("                                                ",adr1,adr2);
_0x158:
	CALL SUBOPT_0x25
; 0000 111B         komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr1,adr2);
	__POINTW1FN _0x0,1351
	CALL SUBOPT_0x26
; 0000 111C         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 111D         komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr3,adr4);
	__POINTW1FN _0x0,1351
	CALL SUBOPT_0x8B
; 0000 111E 
; 0000 111F         }
	RJMP _0x14D
_0x14F:
; 0000 1120 
; 0000 1121     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x159
; 0000 1122         {
; 0000 1123         while(sg == 0)
_0x15A:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x15C
; 0000 1124             {
; 0000 1125             if(sprawdz_pin2(PORTMM,0x77) == 1)
	CALL SUBOPT_0x14
	CALL _sprawdz_pin2
	CPI  R30,LOW(0x1)
	BRNE _0x15D
; 0000 1126                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x17
	MOVW R16,R30
; 0000 1127 
; 0000 1128 
; 0000 1129             }
_0x15D:
	RJMP _0x15A
_0x15C:
; 0000 112A 
; 0000 112B         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 112C         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 112D 
; 0000 112E         PORTD.7 = 0;
	CALL SUBOPT_0x8C
; 0000 112F         if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x160
; 0000 1130             {
; 0000 1131             PORTE.2 = 1;
	CALL SUBOPT_0x8D
; 0000 1132             byla_wloczona_szlifierka_1 = 0;
; 0000 1133             }
; 0000 1134         if(byla_wloczona_szlifierka_2 == 1)
_0x160:
	CALL SUBOPT_0x8E
	BRNE _0x163
; 0000 1135             {
; 0000 1136             PORTE.3 = 1;
	CALL SUBOPT_0x8F
; 0000 1137             byla_wloczona_szlifierka_2 = 0;
; 0000 1138             }
; 0000 1139         if(byl_wloczony_przedmuch == 1)
_0x163:
	CALL SUBOPT_0x90
	BRNE _0x166
; 0000 113A             {
; 0000 113B             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x91
; 0000 113C             PORTF = PORT_F.byte;
; 0000 113D             sek12 = zastopowany_czas_przedmuchu;
; 0000 113E             byl_wloczony_przedmuch = 0;
; 0000 113F             }
; 0000 1140         }
_0x166:
; 0000 1141     }
_0x159:
; 0000 1142 
; 0000 1143 }
_0x14C:
	RJMP _0x20A0002
;
;
;void obsluga_otwarcia_klapy_rzad()
; 0000 1147 {
_obsluga_otwarcia_klapy_rzad:
; 0000 1148 int sg;
; 0000 1149 sg = 0;
	CALL SUBOPT_0x2
;	sg -> R16,R17
; 0000 114A 
; 0000 114B if(rzad_obrabiany == 1 & start == 1)
	CALL SUBOPT_0x92
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x93
	AND  R30,R0
	BRNE PC+3
	JMP _0x167
; 0000 114C    {
; 0000 114D    while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x168:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x16A
; 0000 114E         {
; 0000 114F         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x85
; 0000 1150         PORTD.7 = 1;
; 0000 1151         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x16D
; 0000 1152            {
; 0000 1153            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x86
; 0000 1154            PORTE.2 = 0;
; 0000 1155            }
; 0000 1156 
; 0000 1157         if(PORTE.3 == 1)
_0x16D:
	SBIS 0x3,3
	RJMP _0x170
; 0000 1158            {
; 0000 1159            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x87
; 0000 115A            PORTE.3 = 0;
; 0000 115B            }
; 0000 115C 
; 0000 115D            if(PORT_F.bits.b4 == 1)
_0x170:
	CALL SUBOPT_0x88
	BRNE _0x173
; 0000 115E             {
; 0000 115F             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x89
; 0000 1160             zastopowany_czas_przedmuchu = sek12;
; 0000 1161             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1162             PORTF = PORT_F.byte;
; 0000 1163             }
; 0000 1164 
; 0000 1165 
; 0000 1166         komunikat_na_panel("                                                ",adr1,adr2);
_0x173:
	CALL SUBOPT_0x25
; 0000 1167         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x26
; 0000 1168         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 1169         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x8B
; 0000 116A 
; 0000 116B         }
	RJMP _0x168
_0x16A:
; 0000 116C     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x174
; 0000 116D         {
; 0000 116E         while(sg == 0)
_0x175:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x177
; 0000 116F             {
; 0000 1170             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x178
; 0000 1171                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x17
	MOVW R16,R30
; 0000 1172 
; 0000 1173 
; 0000 1174             }
_0x178:
	RJMP _0x175
_0x177:
; 0000 1175 
; 0000 1176         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 1177         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 1178 
; 0000 1179         PORTD.7 = 0;
	CALL SUBOPT_0x8C
; 0000 117A           if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x17B
; 0000 117B             {
; 0000 117C             PORTE.2 = 1;
	CALL SUBOPT_0x8D
; 0000 117D             byla_wloczona_szlifierka_1 = 0;
; 0000 117E             }
; 0000 117F         if(byla_wloczona_szlifierka_2 == 1)
_0x17B:
	CALL SUBOPT_0x8E
	BRNE _0x17E
; 0000 1180             {
; 0000 1181             PORTE.3 = 1;
	CALL SUBOPT_0x8F
; 0000 1182             byla_wloczona_szlifierka_2 = 0;
; 0000 1183             }
; 0000 1184         if(byl_wloczony_przedmuch == 1)
_0x17E:
	CALL SUBOPT_0x90
	BRNE _0x181
; 0000 1185             {
; 0000 1186             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x91
; 0000 1187             PORTF = PORT_F.byte;
; 0000 1188             sek12 = zastopowany_czas_przedmuchu;
; 0000 1189             byl_wloczony_przedmuch = 0;
; 0000 118A             }
; 0000 118B         }
_0x181:
; 0000 118C    }
_0x174:
; 0000 118D 
; 0000 118E 
; 0000 118F if(rzad_obrabiany == 2 & start == 1)
_0x167:
	CALL SUBOPT_0x94
	CALL SUBOPT_0x93
	AND  R30,R0
	BRNE PC+3
	JMP _0x182
; 0000 1190    {
; 0000 1191    while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x183:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BRNE _0x185
; 0000 1192         {
; 0000 1193         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x85
; 0000 1194         PORTD.7 = 1;
; 0000 1195         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x188
; 0000 1196            {
; 0000 1197            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x86
; 0000 1198            PORTE.2 = 0;
; 0000 1199            }
; 0000 119A 
; 0000 119B         if(PORTE.3 == 1)
_0x188:
	SBIS 0x3,3
	RJMP _0x18B
; 0000 119C            {
; 0000 119D            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x87
; 0000 119E            PORTE.3 = 0;
; 0000 119F            }
; 0000 11A0 
; 0000 11A1          if(PORT_F.bits.b4 == 1)
_0x18B:
	CALL SUBOPT_0x88
	BRNE _0x18E
; 0000 11A2             {
; 0000 11A3             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x89
; 0000 11A4             zastopowany_czas_przedmuchu = sek12;
; 0000 11A5             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 11A6             PORTF = PORT_F.byte;
; 0000 11A7             }
; 0000 11A8 
; 0000 11A9         komunikat_na_panel("                                                ",adr1,adr2);
_0x18E:
	CALL SUBOPT_0x25
; 0000 11AA         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x26
; 0000 11AB         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 11AC         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x8B
; 0000 11AD 
; 0000 11AE         }
	RJMP _0x183
_0x185:
; 0000 11AF     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x18F
; 0000 11B0         {
; 0000 11B1         while(sg == 0)
_0x190:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x192
; 0000 11B2             {
; 0000 11B3             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x193
; 0000 11B4                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x17
	MOVW R16,R30
; 0000 11B5 
; 0000 11B6 
; 0000 11B7             }
_0x193:
	RJMP _0x190
_0x192:
; 0000 11B8 
; 0000 11B9         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 11BA         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 11BB 
; 0000 11BC         PORTD.7 = 0;
	CALL SUBOPT_0x8C
; 0000 11BD         if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x196
; 0000 11BE             {
; 0000 11BF             PORTE.2 = 1;
	CALL SUBOPT_0x8D
; 0000 11C0             byla_wloczona_szlifierka_1 = 0;
; 0000 11C1             }
; 0000 11C2         if(byla_wloczona_szlifierka_2 == 1)
_0x196:
	CALL SUBOPT_0x8E
	BRNE _0x199
; 0000 11C3             {
; 0000 11C4             PORTE.3 = 1;
	CALL SUBOPT_0x8F
; 0000 11C5             byla_wloczona_szlifierka_2 = 0;
; 0000 11C6             }
; 0000 11C7         if(byl_wloczony_przedmuch == 1)
_0x199:
	CALL SUBOPT_0x90
	BRNE _0x19C
; 0000 11C8             {
; 0000 11C9             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x91
; 0000 11CA             PORTF = PORT_F.byte;
; 0000 11CB             sek12 = zastopowany_czas_przedmuchu;
; 0000 11CC             byl_wloczony_przedmuch = 0;
; 0000 11CD             }
; 0000 11CE         }
_0x19C:
; 0000 11CF    }
_0x18F:
; 0000 11D0 
; 0000 11D1 
; 0000 11D2 
; 0000 11D3 
; 0000 11D4 
; 0000 11D5 }
_0x182:
_0x20A0002:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;
;void wartosci_wstepne_panelu()
; 0000 11DA {
_wartosci_wstepne_panelu:
; 0000 11DB                                                       //3040
; 0000 11DC wartosc_parametru_panelu(szczotka_druciana_ilosc_cykli,48,64);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x95
	CALL SUBOPT_0x96
	CALL SUBOPT_0x97
; 0000 11DD                                                 //2090
; 0000 11DE wartosc_parametru_panelu(krazek_scierny_ilosc_cykli,32,144);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x98
	CALL SUBOPT_0x99
	CALL SUBOPT_0x9A
; 0000 11DF                                                         //3000
; 0000 11E0 wartosc_parametru_panelu(krazek_scierny_cykl_po_okregu_ilosc,48,0);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x78
	CALL SUBOPT_0x96
	CALL SUBOPT_0xA
	CALL _wartosc_parametru_panelu
; 0000 11E1                                                 //2050
; 0000 11E2 wartosc_parametru_panelu(predkosc_pion_szczotka,32,80);
	LDS  R30,_predkosc_pion_szczotka
	LDS  R31,_predkosc_pion_szczotka+1
	CALL SUBOPT_0x99
	CALL SUBOPT_0x21
	CALL _wartosc_parametru_panelu
; 0000 11E3                                                 //2060
; 0000 11E4 wartosc_parametru_panelu(predkosc_pion_krazek,32,96);
	LDS  R30,_predkosc_pion_krazek
	LDS  R31,_predkosc_pion_krazek+1
	CALL SUBOPT_0x99
	CALL SUBOPT_0x22
	CALL _wartosc_parametru_panelu
; 0000 11E5                                                                        //3010
; 0000 11E6 wartosc_parametru_panelu(wejscie_krazka_sciernego_w_pow_boczna_cylindra,48,16);
	LDS  R30,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R31,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	CALL SUBOPT_0x96
	CALL SUBOPT_0xB
	CALL _wartosc_parametru_panelu
; 0000 11E7                                                                      //2070
; 0000 11E8 wartosc_parametru_panelu(predkosc_ruchow_po_okregu_krazek_scierny,32,112);
	LDS  R30,_predkosc_ruchow_po_okregu_krazek_scierny
	LDS  R31,_predkosc_ruchow_po_okregu_krazek_scierny+1
	CALL SUBOPT_0x99
	CALL SUBOPT_0x9B
; 0000 11E9 
; 0000 11EA /////////////////////////
; 0000 11EB wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0x9B
; 0000 11EC 
; 0000 11ED wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x99
	CALL SUBOPT_0xB
	CALL _wartosc_parametru_panelu
; 0000 11EE 
; 0000 11EF wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
	CALL SUBOPT_0x9
; 0000 11F0 
; 0000 11F1 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
; 0000 11F2 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
; 0000 11F3 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
; 0000 11F4 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
; 0000 11F5 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
; 0000 11F6 
; 0000 11F7 //wartosc_parametru_panelu(1,96,48);
; 0000 11F8 //wartosc_parametru_panelu(2,96,64);
; 0000 11F9 //wartosc_parametru_panelu(3,96,80);
; 0000 11FA //wartosc_parametru_panelu(4,96,96);
; 0000 11FB //wartosc_parametru_panelu(5,96,112);
; 0000 11FC 
; 0000 11FD 
; 0000 11FE 
; 0000 11FF 
; 0000 1200 
; 0000 1201 //////////////////////////
; 0000 1202 wartosc_parametru_panelu(40,48,112);  //srednica krazka wstepnie
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x96
	CALL SUBOPT_0x9B
; 0000 1203 wartosc_parametru_panelu(145,48,128);   //to do manualnego wczytywania zacisku, ma byc 145
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	CALL SUBOPT_0x96
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x9E
; 0000 1204 wartosc_parametru_panelu(0,128,64);   //to do statystyki, zeby zawsze bylo 0
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x97
; 0000 1205 
; 0000 1206 wartosc_parametru_panelu(tryb_pracy_szczotki_drucianej,0,112);
	CALL SUBOPT_0x73
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x9B
; 0000 1207 
; 0000 1208 
; 0000 1209 }
	RET
;
;void wypozycjonuj_napedy_minimalistyczna()
; 0000 120C {
_wypozycjonuj_napedy_minimalistyczna:
; 0000 120D 
; 0000 120E while(start == 0)
_0x19D:
	LDS  R30,_start
	LDS  R31,_start+1
	SBIW R30,0
	BRNE _0x19F
; 0000 120F     {
; 0000 1210     komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 1211     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr1,adr2);
	__POINTW1FN _0x0,1429
	CALL SUBOPT_0x26
; 0000 1212     komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 1213     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr3,adr4);
	__POINTW1FN _0x0,1429
	CALL SUBOPT_0x8B
; 0000 1214     delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 1215     start = odczytaj_parametr(0,64);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x17
	STS  _start,R30
	STS  _start+1,R31
; 0000 1216     }
	RJMP _0x19D
_0x19F:
; 0000 1217 
; 0000 1218 
; 0000 1219 while(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
_0x1A0:
	CALL SUBOPT_0x14
	CALL SUBOPT_0xA1
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0xA2
	POP  R26
	OR   R30,R26
	BREQ _0x1A2
; 0000 121A     {
; 0000 121B     komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 121C     komunikat_na_panel("Zamknij oslony gorne",adr1,adr2);
	__POINTW1FN _0x0,1470
	CALL SUBOPT_0x26
; 0000 121D     komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 121E     komunikat_na_panel("Zamknij oslony gorne",adr3,adr4);
	__POINTW1FN _0x0,1470
	CALL SUBOPT_0x8B
; 0000 121F     }
	RJMP _0x1A0
_0x1A2:
; 0000 1220 
; 0000 1221 
; 0000 1222 PORTB.4 = 1;   //setupy piony
	SBI  0x18,4
; 0000 1223 
; 0000 1224 delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 1225 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 1226 
; 0000 1227 
; 0000 1228 
; 0000 1229 while(sprawdz_pin3(PORTKK,0x75) == 1 | sprawdz_pin7(PORTKK,0x75) == 1)
_0x1A7:
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA4
	PUSH R30
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA5
	POP  R26
	OR   R30,R26
	BRNE PC+3
	JMP _0x1A9
; 0000 122A       {
; 0000 122B       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
	CALL SUBOPT_0x14
	CALL SUBOPT_0xA1
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0xA2
	POP  R26
	OR   R30,R26
	BREQ _0x1AA
; 0000 122C         while(1)
_0x1AB:
; 0000 122D             {
; 0000 122E             PORTD.7 = 1;
	CALL SUBOPT_0xA6
; 0000 122F             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 1230 
; 0000 1231             PORTB.4 = 0;   //setupy piony
; 0000 1232             PORTD.2 = 0;   //setup wspolny
; 0000 1233 
; 0000 1234             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1235             komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1491
	CALL SUBOPT_0x26
; 0000 1236             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 1237             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xA7
; 0000 1238 
; 0000 1239             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x97
; 0000 123A             }
	RJMP _0x1AB
; 0000 123B 
; 0000 123C 
; 0000 123D       if(sprawdz_pin2(PORTMM,0x77) == 0)
_0x1AA:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x1B6
; 0000 123E         while(1)
_0x1B7:
; 0000 123F             {
; 0000 1240             PORTD.7 = 1;
	CALL SUBOPT_0xA6
; 0000 1241             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 1242 
; 0000 1243             PORTB.4 = 0;   //setupy piony
; 0000 1244             PORTD.2 = 0;   //setup wspolny
; 0000 1245 
; 0000 1246             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1247             komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1554
	CALL SUBOPT_0x26
; 0000 1248             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 1249             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xA7
; 0000 124A 
; 0000 124B             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x97
; 0000 124C             }
	RJMP _0x1B7
; 0000 124D 
; 0000 124E 
; 0000 124F       komunikat_na_panel("                                                ",adr1,adr2);
_0x1B6:
	CALL SUBOPT_0x25
; 0000 1250       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x26
; 0000 1251       komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 1252       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x8B
; 0000 1253       delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 1254 
; 0000 1255       if(sprawdz_pin3(PORTKK,0x75) == 0)
	CALL SUBOPT_0xA3
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1C2
; 0000 1256             {
; 0000 1257             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 1258             komunikat_na_panel("Sterownik 3 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1622
	CALL SUBOPT_0x26
; 0000 1259             delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 125A             }
; 0000 125B       if(sprawdz_pin7(PORTKK,0x75) == 0)
_0x1C2:
	CALL SUBOPT_0xA3
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x1C3
; 0000 125C             {
; 0000 125D             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 125E             komunikat_na_panel("Sterownik 4 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1653
	CALL SUBOPT_0x26
; 0000 125F             delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 1260             }
; 0000 1261 
; 0000 1262 
; 0000 1263       if(sprawdz_pin6(PORTMM,0x77) == 1 |
_0x1C3:
; 0000 1264          sprawdz_pin7(PORTMM,0x77) == 1)
	CALL SUBOPT_0x14
	CALL SUBOPT_0xA8
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0xA5
	POP  R26
	OR   R30,R26
	BREQ _0x1C4
; 0000 1265             {
; 0000 1266             PORTD.7 = 1;
	SBI  0x12,7
; 0000 1267             if(sprawdz_pin6(PORTMM,0x77) == 1)
	CALL SUBOPT_0x14
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x1C7
; 0000 1268                 {
; 0000 1269                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 126A                 komunikat_na_panel("Alarm Sterownik 4",adr1,adr2);
	__POINTW1FN _0x0,1684
	CALL SUBOPT_0x26
; 0000 126B                 delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 126C                 }
; 0000 126D             if(sprawdz_pin7(PORTMM,0x77) == 1)
_0x1C7:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x1C8
; 0000 126E                 {
; 0000 126F                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 1270                 komunikat_na_panel("Alarm Sterownik 3",adr1,adr2);
	__POINTW1FN _0x0,1702
	CALL SUBOPT_0x26
; 0000 1271                 delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 1272                 }
; 0000 1273             }
_0x1C8:
; 0000 1274 
; 0000 1275 
; 0000 1276 
; 0000 1277 
; 0000 1278 
; 0000 1279 
; 0000 127A 
; 0000 127B 
; 0000 127C       }
_0x1C4:
	RJMP _0x1A7
_0x1A9:
; 0000 127D 
; 0000 127E PORTB.4 = 0;   //setupy piony
	CBI  0x18,4
; 0000 127F PORTD.2 = 1;   //setup poziomy
	SBI  0x12,2
; 0000 1280 delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 1281 
; 0000 1282 
; 0000 1283 while(sprawdz_pin3(PORTJJ,0x79) == 1 | sprawdz_pin3(PORTLL,0x71) == 1)
_0x1CD:
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA4
	PUSH R30
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA4
	POP  R26
	OR   R30,R26
	BRNE PC+3
	JMP _0x1CF
; 0000 1284       {
; 0000 1285 
; 0000 1286       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
	CALL SUBOPT_0x14
	CALL SUBOPT_0xA1
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0xA2
	POP  R26
	OR   R30,R26
	BREQ _0x1D0
; 0000 1287         while(1)
_0x1D1:
; 0000 1288             {
; 0000 1289             PORTD.7 = 1;
	SBI  0x12,7
; 0000 128A             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 128B             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 128C             komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1491
	CALL SUBOPT_0x26
; 0000 128D             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 128E             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xA7
; 0000 128F 
; 0000 1290             PORTB.4 = 0;   //setupy piony
	CBI  0x18,4
; 0000 1291             PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 1292 
; 0000 1293             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x97
; 0000 1294             }
	RJMP _0x1D1
; 0000 1295 
; 0000 1296 
; 0000 1297       if(sprawdz_pin2(PORTMM,0x77) == 0)
_0x1D0:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x1DC
; 0000 1298         while(1)
_0x1DD:
; 0000 1299             {
; 0000 129A             PORTD.7 = 1;
	CALL SUBOPT_0xA6
; 0000 129B             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 129C 
; 0000 129D             PORTB.4 = 0;   //setupy piony
; 0000 129E             PORTD.2 = 0;   //setup wspolny
; 0000 129F 
; 0000 12A0             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 12A1             komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1554
	CALL SUBOPT_0x26
; 0000 12A2             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 12A3             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xA7
; 0000 12A4 
; 0000 12A5             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x97
; 0000 12A6             }
	RJMP _0x1DD
; 0000 12A7 
; 0000 12A8       komunikat_na_panel("                                                ",adr1,adr2);
_0x1DC:
	CALL SUBOPT_0x25
; 0000 12A9       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x26
; 0000 12AA       komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 12AB       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x8B
; 0000 12AC       delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 12AD 
; 0000 12AE       if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x24
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1E8
; 0000 12AF             {
; 0000 12B0             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 12B1             komunikat_na_panel("Sterownik 1 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1720
	CALL SUBOPT_0x26
; 0000 12B2             delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 12B3             }
; 0000 12B4       if(sprawdz_pin3(PORTLL,0x71) == 0)
_0x1E8:
	CALL SUBOPT_0xA9
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1E9
; 0000 12B5             {
; 0000 12B6             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 12B7             komunikat_na_panel("Sterownik 2 - wypozycjonowalem",adr3,adr4);
	__POINTW1FN _0x0,1751
	CALL SUBOPT_0x8B
; 0000 12B8             delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 12B9             }
; 0000 12BA 
; 0000 12BB        //if(sprawdz_pin7(PORTMM,0x77) == 1)
; 0000 12BC        //     PORTD.7 = 1;
; 0000 12BD 
; 0000 12BE       if(sprawdz_pin5(PORTJJ,0x79) == 1 |
_0x1E9:
; 0000 12BF          sprawdz_pin5(PORTLL,0x71) == 1)
	CALL SUBOPT_0x24
	CALL SUBOPT_0xAA
	PUSH R30
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xAA
	POP  R26
	OR   R30,R26
	BREQ _0x1EA
; 0000 12C0             {
; 0000 12C1             PORTD.7 = 1;
	SBI  0x12,7
; 0000 12C2             if(sprawdz_pin5(PORTJJ,0x79) == 1)
	CALL SUBOPT_0x24
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x1ED
; 0000 12C3                 {
; 0000 12C4                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 12C5                 komunikat_na_panel("Alarm Sterownik 1",adr1,adr2);
	__POINTW1FN _0x0,1782
	CALL SUBOPT_0x26
; 0000 12C6                 delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 12C7                 }
; 0000 12C8             if(sprawdz_pin5(PORTLL,0x71) == 1)
_0x1ED:
	CALL SUBOPT_0xA9
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x1EE
; 0000 12C9                 {
; 0000 12CA                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 12CB                 komunikat_na_panel("Alarm Sterownik 2",adr1,adr2);
	__POINTW1FN _0x0,1800
	CALL SUBOPT_0x26
; 0000 12CC                 delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 12CD                 }
; 0000 12CE 
; 0000 12CF             }
_0x1EE:
; 0000 12D0 
; 0000 12D1       //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 12D2 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 12D3       //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 12D4        //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 12D5 
; 0000 12D6 
; 0000 12D7 
; 0000 12D8       }
_0x1EA:
	RJMP _0x1CD
_0x1CF:
; 0000 12D9 
; 0000 12DA komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 12DB komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1818
	CALL SUBOPT_0x26
; 0000 12DC komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 12DD komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1818
	CALL SUBOPT_0x8B
; 0000 12DE 
; 0000 12DF PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 12E0 PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 12E1 delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 12E2 wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x97
; 0000 12E3 start = 0;
	CALL SUBOPT_0xAB
; 0000 12E4 
; 0000 12E5 }
	RET
;
;
;void przerzucanie_dociskow()
; 0000 12E9 {
_przerzucanie_dociskow:
; 0000 12EA 
; 0000 12EB if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x1F3
; 0000 12EC   {
; 0000 12ED    if(sprawdz_pin6(PORTLL,0x71) == 0 & sprawdz_pin7(PORTLL,0x71) == 0 & czekaj_az_puszcze == 0)
	CALL SUBOPT_0xA9
	CALL _sprawdz_pin6
	LDI  R26,LOW(0)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0xA9
	CALL _sprawdz_pin7
	LDI  R26,LOW(0)
	CALL __EQB12
	POP  R26
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xAD
	BREQ _0x1F4
; 0000 12EE            {
; 0000 12EF            czekaj_az_puszcze = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 12F0            //PORTB.6 = 1;
; 0000 12F1            }
; 0000 12F2        if(sprawdz_pin6(PORTLL,0x71) == 1 & sprawdz_pin7(PORTLL,0x71) == 1 & czekaj_az_puszcze == 1)
_0x1F4:
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA8
	PUSH R30
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA5
	POP  R26
	CALL SUBOPT_0xAC
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x1F5
; 0000 12F3            {
; 0000 12F4            czekaj_az_puszcze = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 12F5            //PORTB.6 = 0;
; 0000 12F6            }
; 0000 12F7 
; 0000 12F8        if(czekaj_az_puszcze == 2 & PORTE.6 == 1)
_0x1F5:
	CALL SUBOPT_0xAE
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x1F6
; 0000 12F9             {
; 0000 12FA             PORTE.6 = 0;
	CBI  0x3,6
; 0000 12FB             czekaj_az_puszcze = 0;
	CALL SUBOPT_0xAF
; 0000 12FC             delay_ms(100);
; 0000 12FD             }
; 0000 12FE 
; 0000 12FF        if(czekaj_az_puszcze == 2 & PORTE.6 == 0)
_0x1F6:
	CALL SUBOPT_0xAE
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x1F9
; 0000 1300            {
; 0000 1301             PORTE.6 = 1;
	SBI  0x3,6
; 0000 1302             czekaj_az_puszcze = 0;
	CALL SUBOPT_0xAF
; 0000 1303             delay_ms(100);
; 0000 1304            }
; 0000 1305 
; 0000 1306   }
_0x1F9:
; 0000 1307 }
_0x1F3:
	RET
;
;void ostateczny_wybor_zacisku()
; 0000 130A {
_ostateczny_wybor_zacisku:
; 0000 130B int rzad;
; 0000 130C 
; 0000 130D   if(sek11 > 60) //co 1s sekunde sprawdzam   //jak co 40 to sie wywala
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	LDS  R26,_sek11
	LDS  R27,_sek11+1
	LDS  R24,_sek11+2
	LDS  R25,_sek11+3
	CALL SUBOPT_0x84
	BRGE PC+3
	JMP _0x1FC
; 0000 130E         {
; 0000 130F        sek11 = 0;
	CALL SUBOPT_0xB0
; 0000 1310        if(odczytalem_zacisk < il_prob_odczytu &
; 0000 1311                                            (sprawdz_pin0(PORTHH,0x73) == 1 |
; 0000 1312                                             sprawdz_pin1(PORTHH,0x73) == 1 |
; 0000 1313                                             sprawdz_pin2(PORTHH,0x73) == 1 |
; 0000 1314                                             sprawdz_pin3(PORTHH,0x73) == 1 |
; 0000 1315                                             sprawdz_pin4(PORTHH,0x73) == 1 |
; 0000 1316                                             sprawdz_pin5(PORTHH,0x73) == 1 |
; 0000 1317                                             sprawdz_pin6(PORTHH,0x73) == 1 |
; 0000 1318                                             sprawdz_pin7(PORTHH,0x73) == 1))
	MOVW R30,R10
	MOVW R26,R8
	CALL __LTW12
	PUSH R30
	CALL SUBOPT_0x27
	CALL SUBOPT_0xA1
	PUSH R30
	CALL SUBOPT_0x27
	CALL SUBOPT_0xA2
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x27
	CALL _sprawdz_pin2
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x27
	CALL SUBOPT_0xA4
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x27
	CALL _sprawdz_pin4
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x27
	CALL SUBOPT_0xAA
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x27
	CALL SUBOPT_0xA8
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x27
	CALL SUBOPT_0xA5
	POP  R26
	OR   R30,R26
	POP  R26
	AND  R30,R26
	BREQ _0x1FD
; 0000 1319         {
; 0000 131A         odczytalem_zacisk++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 131B         }
; 0000 131C         }
_0x1FD:
; 0000 131D 
; 0000 131E if(odczytalem_zacisk == il_prob_odczytu)
_0x1FC:
	__CPWRR 10,11,8,9
	BRNE _0x1FE
; 0000 131F         {
; 0000 1320         //PORTB = 0xFF;
; 0000 1321         rzad = odczyt_wybranego_zacisku();
	CALL _odczyt_wybranego_zacisku
	MOVW R16,R30
; 0000 1322         //sek10 = 0;
; 0000 1323         sek11 = 0;    //nowe
	CALL SUBOPT_0xB0
; 0000 1324         odczytalem_zacisk++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 1325 
; 0000 1326         //if(rzad == 1)
; 0000 1327         //    wartosc_parametru_panelu(2,32,128);    //tego nie chca
; 0000 1328         //if(rzad == 2)
; 0000 1329         //    wartosc_parametru_panelu(1,32,128);
; 0000 132A 
; 0000 132B         }                                     //& sek10 > 1                //3s po odczytaniu dopiero sprawdzam port
; 0000 132C if((odczytalem_zacisk == il_prob_odczytu + 1))        //183
_0x1FE:
	MOVW R30,R10
	ADIW R30,1
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x1FF
; 0000 132D         {
; 0000 132E 
; 0000 132F         if(rzad == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x200
; 0000 1330             wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad1
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x22
	CALL _wartosc_parametru_panelu
; 0000 1331 
; 0000 1332         if(rzad == 2 & start == 0)
_0x200:
	MOVW R26,R16
	CALL SUBOPT_0xB1
	MOV  R0,R30
	CALL SUBOPT_0xB2
	CALL SUBOPT_0xAD
	BREQ _0x201
; 0000 1333             wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad2
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL _wartosc_parametru_panelu
; 0000 1334 
; 0000 1335         if(rzad == 2 & start == 1)
_0x201:
	MOVW R26,R16
	CALL SUBOPT_0xB1
	CALL SUBOPT_0x93
	AND  R30,R0
	BREQ _0x202
; 0000 1336             zaaktualizuj_ilosc_rzad2 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _zaaktualizuj_ilosc_rzad2,R30
	STS  _zaaktualizuj_ilosc_rzad2+1,R31
; 0000 1337 
; 0000 1338 
; 0000 1339         odczytalem_zacisk = 0;
_0x202:
	CLR  R8
	CLR  R9
; 0000 133A         if(start == 1)
	CALL SUBOPT_0xB2
	SBIW R26,1
	BRNE _0x203
; 0000 133B             odczytalem_w_trakcie_czyszczenia_drugiego_rzedu = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu,R30
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1,R31
; 0000 133C         }
_0x203:
; 0000 133D }
_0x1FF:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;
;int sterownik_1_praca(int PORT)
; 0000 1342 {
_sterownik_1_praca:
; 0000 1343 //PORTA.0   IN0  STEROWNIK1
; 0000 1344 //PORTA.1   IN1  STEROWNIK1
; 0000 1345 //PORTA.2   IN2  STEROWNIK1
; 0000 1346 //PORTA.3   IN3  STEROWNIK1
; 0000 1347 //PORTA.4   IN4  STEROWNIK1
; 0000 1348 //PORTA.5   IN5  STEROWNIK1
; 0000 1349 //PORTA.6   IN6  STEROWNIK1
; 0000 134A //PORTA.7   IN7  STEROWNIK1
; 0000 134B //PORTD.4   IN8 STEROWNIK1
; 0000 134C 
; 0000 134D //PORTD.2  SETUP   STEROWNIK1
; 0000 134E //PORTD.3  DRIVE   STEROWNIK1
; 0000 134F 
; 0000 1350 //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 1351 //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 1352 
; 0000 1353 if(sprawdz_pin5(PORTJJ,0x79) == 1)     //if alarn
;	PORT -> Y+0
	CALL SUBOPT_0x24
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x204
; 0000 1354     {
; 0000 1355     PORTD.7 = 1;
	CALL SUBOPT_0xB3
; 0000 1356     PORTE.2 = 0;
; 0000 1357     PORTE.3 = 0;  //szlifierki stop
; 0000 1358     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1359     PORTF = PORT_F.byte;
; 0000 135A 
; 0000 135B     while(1)
_0x20B:
; 0000 135C         {
; 0000 135D         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 135E         komunikat_na_panel("Kolizja XY ukladu krazka",adr1,adr2);
	__POINTW1FN _0x0,1853
	CALL SUBOPT_0x26
; 0000 135F         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 1360         komunikat_na_panel("Kolizja XY ukladu krazka",adr3,adr4);
	__POINTW1FN _0x0,1853
	CALL SUBOPT_0x8B
; 0000 1361         }
	RJMP _0x20B
; 0000 1362 
; 0000 1363     }
; 0000 1364 
; 0000 1365 if(start == 1)
_0x204:
	CALL SUBOPT_0xB2
	SBIW R26,1
	BRNE _0x20E
; 0000 1366     {
; 0000 1367     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xB4
; 0000 1368     obsluga_nacisniecia_zatrzymaj();
; 0000 1369     }
; 0000 136A switch(cykl_sterownik_1)
_0x20E:
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
; 0000 136B         {
; 0000 136C         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x212
; 0000 136D 
; 0000 136E             sek1 = 0;
	CALL SUBOPT_0xB5
; 0000 136F             PORT_STER1.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER1,R30
; 0000 1370             PORTA.0 = PORT_STER1.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x213
	CBI  0x1B,0
	RJMP _0x214
_0x213:
	SBI  0x1B,0
_0x214:
; 0000 1371             PORTA.1 = PORT_STER1.bits.b1;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x2)
	BRNE _0x215
	CBI  0x1B,1
	RJMP _0x216
_0x215:
	SBI  0x1B,1
_0x216:
; 0000 1372             PORTA.2 = PORT_STER1.bits.b2;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x4)
	BRNE _0x217
	CBI  0x1B,2
	RJMP _0x218
_0x217:
	SBI  0x1B,2
_0x218:
; 0000 1373             PORTA.3 = PORT_STER1.bits.b3;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x8)
	BRNE _0x219
	CBI  0x1B,3
	RJMP _0x21A
_0x219:
	SBI  0x1B,3
_0x21A:
; 0000 1374             PORTA.4 = PORT_STER1.bits.b4;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x10)
	BRNE _0x21B
	CBI  0x1B,4
	RJMP _0x21C
_0x21B:
	SBI  0x1B,4
_0x21C:
; 0000 1375             PORTA.5 = PORT_STER1.bits.b5;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x20)
	BRNE _0x21D
	CBI  0x1B,5
	RJMP _0x21E
_0x21D:
	SBI  0x1B,5
_0x21E:
; 0000 1376             PORTA.6 = PORT_STER1.bits.b6;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x40)
	BRNE _0x21F
	CBI  0x1B,6
	RJMP _0x220
_0x21F:
	SBI  0x1B,6
_0x220:
; 0000 1377             PORTA.7 = PORT_STER1.bits.b7;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x80)
	BRNE _0x221
	CBI  0x1B,7
	RJMP _0x222
_0x221:
	SBI  0x1B,7
_0x222:
; 0000 1378 
; 0000 1379             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x223
; 0000 137A                 PORTD.4 = 1;
	SBI  0x12,4
; 0000 137B 
; 0000 137C 
; 0000 137D 
; 0000 137E             cykl_sterownik_1 = 1;
_0x223:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x51E
; 0000 137F 
; 0000 1380         break;
; 0000 1381 
; 0000 1382         case 1:
_0x212:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x226
; 0000 1383 
; 0000 1384             if(sek1 > 1)
	LDS  R26,_sek1
	LDS  R27,_sek1+1
	LDS  R24,_sek1+2
	LDS  R25,_sek1+3
	CALL SUBOPT_0xB6
	BRLT _0x227
; 0000 1385                 {
; 0000 1386 
; 0000 1387                 PORTD.3 = 1;
	SBI  0x12,3
; 0000 1388                 cykl_sterownik_1 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xB7
; 0000 1389                 }
; 0000 138A         break;
_0x227:
	RJMP _0x211
; 0000 138B 
; 0000 138C 
; 0000 138D         case 2:
_0x226:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x22A
; 0000 138E 
; 0000 138F                if(sprawdz_pin0(PORTJJ,0x79) == 0)     //busy
	CALL SUBOPT_0x24
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x22B
; 0000 1390                   {
; 0000 1391 
; 0000 1392                   PORTD.3 = 0;
	CBI  0x12,3
; 0000 1393                   PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 1394                   PORTD.4 = 0;
	CBI  0x12,4
; 0000 1395                   sek1 = 0;
	CALL SUBOPT_0xB5
; 0000 1396                   cykl_sterownik_1 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xB7
; 0000 1397                   }
; 0000 1398 
; 0000 1399         break;
_0x22B:
	RJMP _0x211
; 0000 139A 
; 0000 139B         case 3:
_0x22A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x230
; 0000 139C 
; 0000 139D                if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x24
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x231
; 0000 139E                   {
; 0000 139F 
; 0000 13A0                   sek1 = 0;
	CALL SUBOPT_0xB5
; 0000 13A1                   cykl_sterownik_1 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xB7
; 0000 13A2                   }
; 0000 13A3 
; 0000 13A4 
; 0000 13A5         break;
_0x231:
	RJMP _0x211
; 0000 13A6 
; 0000 13A7 
; 0000 13A8         case 4:
_0x230:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x211
; 0000 13A9 
; 0000 13AA             if(sprawdz_pin0(PORTJJ,0x79) == 1)
	CALL SUBOPT_0x24
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x233
; 0000 13AB                 {
; 0000 13AC 
; 0000 13AD                 cykl_sterownik_1 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x51E:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
; 0000 13AE                 }
; 0000 13AF         break;
_0x233:
; 0000 13B0 
; 0000 13B1         }
_0x211:
; 0000 13B2 
; 0000 13B3 return cykl_sterownik_1;
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
	RJMP _0x20A0001
; 0000 13B4 }
;
;
;int sterownik_2_praca(int PORT)
; 0000 13B8 {
_sterownik_2_praca:
; 0000 13B9 //PORTC.0   IN0  STEROWNIK2
; 0000 13BA //PORTC.1   IN1  STEROWNIK2
; 0000 13BB //PORTC.2   IN2  STEROWNIK2
; 0000 13BC //PORTC.3   IN3  STEROWNIK2
; 0000 13BD //PORTC.4   IN4  STEROWNIK2
; 0000 13BE //PORTC.5   IN5  STEROWNIK2
; 0000 13BF //PORTC.6   IN6  STEROWNIK2
; 0000 13C0 //PORTC.7   IN7  STEROWNIK2
; 0000 13C1 //PORTD.5   IN8 STEROWNIK2
; 0000 13C2 
; 0000 13C3 
; 0000 13C4 //PORTD.5  SETUP   STEROWNIK2
; 0000 13C5 //PORTD.6  DRIVE   STEROWNIK2
; 0000 13C6 
; 0000 13C7 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 13C8 //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 13C9 
; 0000 13CA  if(sprawdz_pin5(PORTLL,0x71) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0xA9
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x234
; 0000 13CB     {
; 0000 13CC     PORTD.7 = 1;
	CALL SUBOPT_0xB3
; 0000 13CD     PORTE.2 = 0;
; 0000 13CE     PORTE.3 = 0;  //szlifierki stop
; 0000 13CF     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 13D0     PORTF = PORT_F.byte;
; 0000 13D1 
; 0000 13D2     while(1)
_0x23B:
; 0000 13D3         {
; 0000 13D4         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 13D5         komunikat_na_panel("Kolizja XY ukladu szczotki",adr1,adr2);
	__POINTW1FN _0x0,1878
	CALL SUBOPT_0x26
; 0000 13D6         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 13D7         komunikat_na_panel("Kolizja XY ukladu szczotki",adr3,adr4);
	__POINTW1FN _0x0,1878
	CALL SUBOPT_0x8B
; 0000 13D8         }
	RJMP _0x23B
; 0000 13D9 
; 0000 13DA     }
; 0000 13DB if(start == 1)
_0x234:
	CALL SUBOPT_0xB2
	SBIW R26,1
	BRNE _0x23E
; 0000 13DC     {
; 0000 13DD     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xB4
; 0000 13DE     obsluga_nacisniecia_zatrzymaj();
; 0000 13DF     }
; 0000 13E0 switch(cykl_sterownik_2)
_0x23E:
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
; 0000 13E1         {
; 0000 13E2         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x242
; 0000 13E3 
; 0000 13E4             sek3 = 0;
	CALL SUBOPT_0xB8
; 0000 13E5             PORT_STER2.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER2,R30
; 0000 13E6             PORTC.0 = PORT_STER2.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x243
	CBI  0x15,0
	RJMP _0x244
_0x243:
	SBI  0x15,0
_0x244:
; 0000 13E7             PORTC.1 = PORT_STER2.bits.b1;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x2)
	BRNE _0x245
	CBI  0x15,1
	RJMP _0x246
_0x245:
	SBI  0x15,1
_0x246:
; 0000 13E8             PORTC.2 = PORT_STER2.bits.b2;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x4)
	BRNE _0x247
	CBI  0x15,2
	RJMP _0x248
_0x247:
	SBI  0x15,2
_0x248:
; 0000 13E9             PORTC.3 = PORT_STER2.bits.b3;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x8)
	BRNE _0x249
	CBI  0x15,3
	RJMP _0x24A
_0x249:
	SBI  0x15,3
_0x24A:
; 0000 13EA             PORTC.4 = PORT_STER2.bits.b4;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x10)
	BRNE _0x24B
	CBI  0x15,4
	RJMP _0x24C
_0x24B:
	SBI  0x15,4
_0x24C:
; 0000 13EB             PORTC.5 = PORT_STER2.bits.b5;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x20)
	BRNE _0x24D
	CBI  0x15,5
	RJMP _0x24E
_0x24D:
	SBI  0x15,5
_0x24E:
; 0000 13EC             PORTC.6 = PORT_STER2.bits.b6;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x40)
	BRNE _0x24F
	CBI  0x15,6
	RJMP _0x250
_0x24F:
	SBI  0x15,6
_0x250:
; 0000 13ED             PORTC.7 = PORT_STER2.bits.b7;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x80)
	BRNE _0x251
	CBI  0x15,7
	RJMP _0x252
_0x251:
	SBI  0x15,7
_0x252:
; 0000 13EE             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x253
; 0000 13EF                 PORTD.5 = 1;
	SBI  0x12,5
; 0000 13F0 
; 0000 13F1 
; 0000 13F2             cykl_sterownik_2 = 1;
_0x253:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x51F
; 0000 13F3 
; 0000 13F4 
; 0000 13F5         break;
; 0000 13F6 
; 0000 13F7         case 1:
_0x242:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x256
; 0000 13F8 
; 0000 13F9             if(sek3 > 1)
	LDS  R26,_sek3
	LDS  R27,_sek3+1
	LDS  R24,_sek3+2
	LDS  R25,_sek3+3
	CALL SUBOPT_0xB6
	BRLT _0x257
; 0000 13FA                 {
; 0000 13FB                 PORTD.6 = 1;
	SBI  0x12,6
; 0000 13FC                 cykl_sterownik_2 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xB9
; 0000 13FD                 }
; 0000 13FE         break;
_0x257:
	RJMP _0x241
; 0000 13FF 
; 0000 1400 
; 0000 1401         case 2:
_0x256:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x25A
; 0000 1402 
; 0000 1403                if(sprawdz_pin0(PORTLL,0x71) == 0)     //busy
	CALL SUBOPT_0xA9
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x25B
; 0000 1404                   {
; 0000 1405                   PORTD.6 = 0;
	CBI  0x12,6
; 0000 1406                   PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 1407                   PORTD.5 = 0;
	CBI  0x12,5
; 0000 1408                   sek3 = 0;
	CALL SUBOPT_0xB8
; 0000 1409                   cykl_sterownik_2 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xB9
; 0000 140A                   }
; 0000 140B 
; 0000 140C         break;
_0x25B:
	RJMP _0x241
; 0000 140D 
; 0000 140E         case 3:
_0x25A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x260
; 0000 140F 
; 0000 1410                if(sprawdz_pin3(PORTLL,0x71) == 0)
	CALL SUBOPT_0xA9
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x261
; 0000 1411                   {
; 0000 1412                   sek3 = 0;
	CALL SUBOPT_0xB8
; 0000 1413                   cykl_sterownik_2 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xB9
; 0000 1414                   }
; 0000 1415 
; 0000 1416 
; 0000 1417         break;
_0x261:
	RJMP _0x241
; 0000 1418 
; 0000 1419 
; 0000 141A         case 4:
_0x260:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x241
; 0000 141B 
; 0000 141C             if(sprawdz_pin0(PORTLL,0x71) == 1)
	CALL SUBOPT_0xA9
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x263
; 0000 141D                 {
; 0000 141E                 cykl_sterownik_2 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x51F:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
; 0000 141F                 }
; 0000 1420         break;
_0x263:
; 0000 1421 
; 0000 1422         }
_0x241:
; 0000 1423 
; 0000 1424 return cykl_sterownik_2;
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
	RJMP _0x20A0001
; 0000 1425 }
;
;
;
;
;
;
;int sterownik_3_praca(int PORT)
; 0000 142D {
_sterownik_3_praca:
; 0000 142E //PORTF.0   IN0  STEROWNIK3
; 0000 142F //PORTF.1   IN1  STEROWNIK3
; 0000 1430 //PORTF.2   IN2  STEROWNIK3
; 0000 1431 //PORTF.3   IN3  STEROWNIK3
; 0000 1432 //PORTF.7   IN4 STEROWNIK 3
; 0000 1433 //PORTB.7   IN5 STEROWNIK 3
; 0000 1434 
; 0000 1435 
; 0000 1436 
; 0000 1437 //PORTF.5   DRIVE  STEROWNIK3
; 0000 1438 
; 0000 1439 //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 143A //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 143B 
; 0000 143C if(sprawdz_pin7(PORTMM,0x77) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0x14
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x264
; 0000 143D      {
; 0000 143E      PORTD.7 = 1;
	CALL SUBOPT_0xB3
; 0000 143F      PORTE.2 = 0;
; 0000 1440      PORTE.3 = 0;  //szlifierki stop
; 0000 1441      PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1442      PORTF = PORT_F.byte;
; 0000 1443 
; 0000 1444      while(1)
_0x26B:
; 0000 1445         {
; 0000 1446         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 1447         komunikat_na_panel("Kolizja krazka - wylacz i wlacz maszyne",adr1,adr2);
	__POINTW1FN _0x0,1905
	CALL SUBOPT_0x26
; 0000 1448         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 1449         komunikat_na_panel("Kolizja krazka - wylacz i wlacz maszyne",adr3,adr4);
	__POINTW1FN _0x0,1905
	CALL SUBOPT_0x8B
; 0000 144A         }
	RJMP _0x26B
; 0000 144B      }
; 0000 144C if(start == 1)
_0x264:
	CALL SUBOPT_0xB2
	SBIW R26,1
	BRNE _0x26E
; 0000 144D     {
; 0000 144E     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xB4
; 0000 144F     obsluga_nacisniecia_zatrzymaj();
; 0000 1450 
; 0000 1451     }
; 0000 1452 switch(cykl_sterownik_3)
_0x26E:
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
; 0000 1453         {
; 0000 1454         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x272
; 0000 1455 
; 0000 1456             PORT_STER3.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER3,R30
; 0000 1457             PORT_F.bits.b0 = PORT_STER3.bits.b0;
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0xBA
; 0000 1458             PORT_F.bits.b1 = PORT_STER3.bits.b1;
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFD
	CALL SUBOPT_0xBA
; 0000 1459             PORT_F.bits.b2 = PORT_STER3.bits.b2;
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFB
	CALL SUBOPT_0xBA
; 0000 145A             PORT_F.bits.b3 = PORT_STER3.bits.b3;
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
	CALL SUBOPT_0xBA
; 0000 145B             PORT_F.bits.b7 = PORT_STER3.bits.b4;
	SWAP R30
	ANDI R30,LOW(0x1)
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0x7F
	OR   R30,R0
	CALL SUBOPT_0xBB
; 0000 145C             PORTF = PORT_F.byte;
; 0000 145D             PORTB.7 = PORT_STER3.bits.b5;
	LDS  R30,_PORT_STER3
	ANDI R30,LOW(0x20)
	BRNE _0x273
	CBI  0x18,7
	RJMP _0x274
_0x273:
	SBI  0x18,7
_0x274:
; 0000 145E 
; 0000 145F 
; 0000 1460 
; 0000 1461             sek2 = 0;
	CALL SUBOPT_0xBC
; 0000 1462             cykl_sterownik_3 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0xBD
; 0000 1463 
; 0000 1464 
; 0000 1465 
; 0000 1466         break;
	RJMP _0x271
; 0000 1467 
; 0000 1468         case 1:
_0x272:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x275
; 0000 1469 
; 0000 146A 
; 0000 146B             if(sek2 > 1)
	LDS  R26,_sek2
	LDS  R27,_sek2+1
	LDS  R24,_sek2+2
	LDS  R25,_sek2+3
	CALL SUBOPT_0xB6
	BRLT _0x276
; 0000 146C                 {
; 0000 146D 
; 0000 146E                 PORT_F.bits.b5 = 1;
	LDS  R30,_PORT_F
	ORI  R30,0x20
	CALL SUBOPT_0xBB
; 0000 146F                 PORTF = PORT_F.byte;
; 0000 1470                 cykl_sterownik_3 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xBD
; 0000 1471                 }
; 0000 1472         break;
_0x276:
	RJMP _0x271
; 0000 1473 
; 0000 1474 
; 0000 1475         case 2:
_0x275:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x277
; 0000 1476 
; 0000 1477 
; 0000 1478                if(sprawdz_pin0(PORTKK,0x75) == 0)
	CALL SUBOPT_0xA3
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x278
; 0000 1479                   {
; 0000 147A                   PORT_F.bits.b5 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xDF
	CALL SUBOPT_0xBB
; 0000 147B                   PORTF = PORT_F.byte;
; 0000 147C 
; 0000 147D                   PORT_F.bits.b0 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0xBE
; 0000 147E                   PORT_F.bits.b1 = 0;
	ANDI R30,0xFD
	CALL SUBOPT_0xBE
; 0000 147F                   PORT_F.bits.b2 = 0;
	ANDI R30,0xFB
	CALL SUBOPT_0xBE
; 0000 1480                   PORT_F.bits.b3 = 0;
	ANDI R30,0XF7
	CALL SUBOPT_0xBE
; 0000 1481                   PORT_F.bits.b7 = 0;
	ANDI R30,0x7F
	CALL SUBOPT_0xBB
; 0000 1482                   PORTF = PORT_F.byte;
; 0000 1483                   PORTB.7 = 0;
	CBI  0x18,7
; 0000 1484 
; 0000 1485                   sek2 = 0;
	CALL SUBOPT_0xBC
; 0000 1486                   cykl_sterownik_3 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xBD
; 0000 1487                   }
; 0000 1488 
; 0000 1489         break;
_0x278:
	RJMP _0x271
; 0000 148A 
; 0000 148B         case 3:
_0x277:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x27B
; 0000 148C 
; 0000 148D 
; 0000 148E                if(sprawdz_pin3(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0xA3
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x27C
; 0000 148F                   {
; 0000 1490                   sek2 = 0;
	CALL SUBOPT_0xBC
; 0000 1491                   cykl_sterownik_3 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xBD
; 0000 1492                   }
; 0000 1493 
; 0000 1494 
; 0000 1495         break;
_0x27C:
	RJMP _0x271
; 0000 1496 
; 0000 1497 
; 0000 1498         case 4:
_0x27B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x271
; 0000 1499 
; 0000 149A               if(sprawdz_pin0(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0xA3
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x27E
; 0000 149B                 {
; 0000 149C                 cykl_sterownik_3 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0xBD
; 0000 149D 
; 0000 149E 
; 0000 149F                 switch(cykl_sterownik_3_wykonalem)
	LDS  R30,_cykl_sterownik_3_wykonalem
	LDS  R31,_cykl_sterownik_3_wykonalem+1
; 0000 14A0                     {
; 0000 14A1                     case 0:
	SBIW R30,0
	BRNE _0x282
; 0000 14A2                             cykl_sterownik_3_wykonalem = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R31
; 0000 14A3                     break;
	RJMP _0x281
; 0000 14A4 
; 0000 14A5                     case 1:
_0x282:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x281
; 0000 14A6                             cykl_sterownik_3_wykonalem = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R30
; 0000 14A7                     break;
; 0000 14A8 
; 0000 14A9                     }
_0x281:
; 0000 14AA 
; 0000 14AB 
; 0000 14AC                 }
; 0000 14AD         break;
_0x27E:
; 0000 14AE 
; 0000 14AF         }
_0x271:
; 0000 14B0 
; 0000 14B1 return cykl_sterownik_3;
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
_0x20A0001:
	ADIW R28,2
	RET
; 0000 14B2 }
;
;//
;//int sterownik_4_praca(char f,char e,char d, char c, char b, char a)
;int sterownik_4_praca(int PORT,int p)
; 0000 14B7 {
_sterownik_4_praca:
; 0000 14B8 
; 0000 14B9 
; 0000 14BA //PORTB.0   IN0  STEROWNIK4
; 0000 14BB //PORTB.1   IN1  STEROWNIK4
; 0000 14BC //PORTB.2   IN2  STEROWNIK4
; 0000 14BD //PORTB.3   IN3  STEROWNIK4
; 0000 14BE //PORTE.4  IN4  STEROWNIK4
; 0000 14BF 
; 0000 14C0 
; 0000 14C1 
; 0000 14C2 //PORTB.4   SETUP  STEROWNIK4
; 0000 14C3 //PORTB.5   DRIVE  STEROWNIK4
; 0000 14C4 
; 0000 14C5 //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 14C6 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 14C7 
; 0000 14C8 if(sprawdz_pin6(PORTMM,0x77) == 1)
;	PORT -> Y+2
;	p -> Y+0
	CALL SUBOPT_0x14
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x284
; 0000 14C9     {
; 0000 14CA     PORTD.7 = 1;
	CALL SUBOPT_0xB3
; 0000 14CB     PORTE.2 = 0;
; 0000 14CC     PORTE.3 = 0;
; 0000 14CD     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 14CE     PORTF = PORT_F.byte;
; 0000 14CF 
; 0000 14D0     while(1)
_0x28B:
; 0000 14D1         {
; 0000 14D2         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 14D3         komunikat_na_panel("Kolizja szcz. drucianej - wylacz i wlacz maszyne",adr1,adr2);
	__POINTW1FN _0x0,1945
	CALL SUBOPT_0x26
; 0000 14D4         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 14D5         komunikat_na_panel("Kolizja szcz. drucianej - wylacz i wlacz maszyne",adr3,adr4);
	__POINTW1FN _0x0,1945
	CALL SUBOPT_0x8B
; 0000 14D6         }
	RJMP _0x28B
; 0000 14D7 
; 0000 14D8     }
; 0000 14D9 if(start == 1)
_0x284:
	CALL SUBOPT_0xB2
	SBIW R26,1
	BRNE _0x28E
; 0000 14DA     {
; 0000 14DB     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xB4
; 0000 14DC     obsluga_nacisniecia_zatrzymaj();
; 0000 14DD     }
; 0000 14DE switch(cykl_sterownik_4)
_0x28E:
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
; 0000 14DF         {
; 0000 14E0         case 0:
	SBIW R30,0
	BRNE _0x292
; 0000 14E1 
; 0000 14E2             PORT_STER4.byte = PORT;
	LDD  R30,Y+2
	STS  _PORT_STER4,R30
; 0000 14E3             PORTB.0 = PORT_STER4.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x293
	CBI  0x18,0
	RJMP _0x294
_0x293:
	SBI  0x18,0
_0x294:
; 0000 14E4             PORTB.1 = PORT_STER4.bits.b1;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x2)
	BRNE _0x295
	CBI  0x18,1
	RJMP _0x296
_0x295:
	SBI  0x18,1
_0x296:
; 0000 14E5             PORTB.2 = PORT_STER4.bits.b2;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x4)
	BRNE _0x297
	CBI  0x18,2
	RJMP _0x298
_0x297:
	SBI  0x18,2
_0x298:
; 0000 14E6             PORTB.3 = PORT_STER4.bits.b3;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x8)
	BRNE _0x299
	CBI  0x18,3
	RJMP _0x29A
_0x299:
	SBI  0x18,3
_0x29A:
; 0000 14E7             PORTE.4 = PORT_STER4.bits.b4;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x10)
	BRNE _0x29B
	CBI  0x3,4
	RJMP _0x29C
_0x29B:
	SBI  0x3,4
_0x29C:
; 0000 14E8 
; 0000 14E9 
; 0000 14EA             sek4 = 0;
	CALL SUBOPT_0xBF
; 0000 14EB             cykl_sterownik_4 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x520
; 0000 14EC 
; 0000 14ED         break;
; 0000 14EE 
; 0000 14EF         case 1:
_0x292:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x29D
; 0000 14F0 
; 0000 14F1             if(sek4 > 1)
	LDS  R26,_sek4
	LDS  R27,_sek4+1
	LDS  R24,_sek4+2
	LDS  R25,_sek4+3
	CALL SUBOPT_0xB6
	BRLT _0x29E
; 0000 14F2                 {
; 0000 14F3                 PORTB.5 = 1;
	SBI  0x18,5
; 0000 14F4                 cykl_sterownik_4 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xC0
; 0000 14F5                 }
; 0000 14F6         break;
_0x29E:
	RJMP _0x291
; 0000 14F7 
; 0000 14F8 
; 0000 14F9         case 2:
_0x29D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2A1
; 0000 14FA 
; 0000 14FB                if(sprawdz_pin4(PORTKK,0x75) == 0)
	CALL SUBOPT_0xA3
	CALL _sprawdz_pin4
	CPI  R30,0
	BRNE _0x2A2
; 0000 14FC                   {
; 0000 14FD                   PORTB.5 = 0;  //drive
	CBI  0x18,5
; 0000 14FE 
; 0000 14FF                   PORTB.0 = 0;
	CBI  0x18,0
; 0000 1500                   PORTB.1 = 0;
	CBI  0x18,1
; 0000 1501                   PORTB.2 = 0;
	CBI  0x18,2
; 0000 1502                   PORTB.3 = 0;
	CBI  0x18,3
; 0000 1503                   PORTE.4 = 0;
	CBI  0x3,4
; 0000 1504 
; 0000 1505 
; 0000 1506                   sek4 = 0;
	CALL SUBOPT_0xBF
; 0000 1507                   cykl_sterownik_4 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xC0
; 0000 1508                   }
; 0000 1509 
; 0000 150A         break;
_0x2A2:
	RJMP _0x291
; 0000 150B 
; 0000 150C         case 3:
_0x2A1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2AF
; 0000 150D 
; 0000 150E                if(sprawdz_pin7(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0xA3
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x2B0
; 0000 150F                   {
; 0000 1510                   //if(p == 1)
; 0000 1511                   //  PORTE.2 = 1;  //wylaczam do testu
; 0000 1512 
; 0000 1513                   sek4 = 0;
	CALL SUBOPT_0xBF
; 0000 1514                   cykl_sterownik_4 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xC0
; 0000 1515                   }
; 0000 1516 
; 0000 1517 
; 0000 1518         break;
_0x2B0:
	RJMP _0x291
; 0000 1519 
; 0000 151A 
; 0000 151B         case 4:
_0x2AF:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x291
; 0000 151C 
; 0000 151D               if(sprawdz_pin4(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0xA3
	CALL _sprawdz_pin4
	CPI  R30,LOW(0x1)
	BRNE _0x2B2
; 0000 151E                 {
; 0000 151F                 cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x520:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
; 0000 1520                 }
; 0000 1521         break;
_0x2B2:
; 0000 1522 
; 0000 1523         }
_0x291:
; 0000 1524 
; 0000 1525 return cykl_sterownik_4;
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
	ADIW R28,4
	RET
; 0000 1526 }
;
;
;void test_geometryczny()
; 0000 152A {
_test_geometryczny:
; 0000 152B int cykl_testu,d;
; 0000 152C int ff[12];
; 0000 152D int i;
; 0000 152E d = 0;
	SBIW R28,24
	CALL __SAVELOCR6
;	cykl_testu -> R16,R17
;	d -> R18,R19
;	ff -> Y+6
;	i -> R20,R21
	__GETWRN 18,19,0
; 0000 152F cykl_testu = 0;
	__GETWRN 16,17,0
; 0000 1530 
; 0000 1531 for(i=0;i<11;i++)
	__GETWRN 20,21,0
_0x2B4:
	__CPWRN 20,21,11
	BRGE _0x2B5
; 0000 1532      ff[i]=0;
	MOVW R30,R20
	CALL SUBOPT_0xC1
	CALL SUBOPT_0x36
	__ADDWRN 20,21,1
	RJMP _0x2B4
_0x2B5:
; 0000 1535 manualny_wybor_zacisku = 145;
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	STS  _manualny_wybor_zacisku,R30
	STS  _manualny_wybor_zacisku+1,R31
; 0000 1536 manualny_wybor_zacisku = odczytaj_parametr(48,128);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x18
	STS  _manualny_wybor_zacisku,R30
	STS  _manualny_wybor_zacisku+1,R31
; 0000 1537 
; 0000 1538 if(manualny_wybor_zacisku != 145)
	LDS  R26,_manualny_wybor_zacisku
	LDS  R27,_manualny_wybor_zacisku+1
	CPI  R26,LOW(0x91)
	LDI  R30,HIGH(0x91)
	CPC  R27,R30
	BREQ _0x2B6
; 0000 1539     {
; 0000 153A     macierz_zaciskow[1] = manualny_wybor_zacisku;
	LDS  R30,_manualny_wybor_zacisku
	LDS  R31,_manualny_wybor_zacisku+1
	__PUTW1MN _macierz_zaciskow,2
; 0000 153B     macierz_zaciskow[2] = manualny_wybor_zacisku;
	__PUTW1MN _macierz_zaciskow,4
; 0000 153C     }
; 0000 153D 
; 0000 153E                                                                    //swiatlo czer       //swiatlo zolte
; 0000 153F if(test_geometryczny_rzad_1 == 1 & test_geometryczny_rzad_2 == 0 & PORTD.7 == 0  & PORT_F.bits.b6 == 0 &
_0x2B6:
; 0000 1540     il_zaciskow_rzad_1 > 1 & macierz_zaciskow[1]!=0 & sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x7A
	MOV  R0,R30
	CALL SUBOPT_0xC3
	CALL SUBOPT_0xC4
	CALL SUBOPT_0xC5
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xC7
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	POP  R26
	AND  R30,R26
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x2B7
; 0000 1541     {
; 0000 1542     while(test_geometryczny_rzad_1 == 1)
_0x2B8:
	CALL SUBOPT_0xC2
	SBIW R26,1
	BREQ PC+3
	JMP _0x2BA
; 0000 1543         {
; 0000 1544         switch(cykl_testu)
	MOVW R30,R16
; 0000 1545             {
; 0000 1546              case 0:
	SBIW R30,0
	BRNE _0x2BE
; 0000 1547 
; 0000 1548                wybor_linijek_sterownikow(1);
	CALL SUBOPT_0xC8
; 0000 1549                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	CALL SUBOPT_0xC9
; 0000 154A                cykl_sterownik_1 = 0;
; 0000 154B                cykl_sterownik_2 = 0;
; 0000 154C                cykl_sterownik_3 = 0;
; 0000 154D                cykl_sterownik_4 = 0;
; 0000 154E                wybor_linijek_sterownikow(1);
	CALL SUBOPT_0xC8
; 0000 154F                cykl_testu = 1;
	__GETWRN 16,17,1
; 0000 1550 
; 0000 1551 
; 0000 1552 
; 0000 1553             break;
	RJMP _0x2BD
; 0000 1554 
; 0000 1555             case 1:
_0x2BE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2C1
; 0000 1556 
; 0000 1557             //na sam dol zjezdzamy pionami
; 0000 1558                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x2C2
; 0000 1559                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCB
; 0000 155A                 if(cykl_sterownik_4 < 5)
_0x2C2:
	CALL SUBOPT_0xCC
	SBIW R26,5
	BRGE _0x2C3
; 0000 155B                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCD
; 0000 155C 
; 0000 155D                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2C3:
	CALL SUBOPT_0xCE
	BREQ _0x2C4
; 0000 155E                                         {
; 0000 155F                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xCF
; 0000 1560                                         cykl_sterownik_4 = 0;
; 0000 1561                                         cykl_testu = 2;
	__GETWRN 16,17,2
; 0000 1562                                         }
; 0000 1563 
; 0000 1564 
; 0000 1565 
; 0000 1566             break;
_0x2C4:
	RJMP _0x2BD
; 0000 1567 
; 0000 1568 
; 0000 1569             case 2:
_0x2C1:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2C5
; 0000 156A 
; 0000 156B                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x2C6
; 0000 156C                                     cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0xA
	CALL SUBOPT_0xD1
; 0000 156D                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy
_0x2C6:
	CALL SUBOPT_0xD2
	SBIW R26,5
	BRGE _0x2C7
; 0000 156E                                     cykl_sterownik_2 = sterownik_2_praca(0x008);       //ster 2 ucieczka do zera (druciak)
	CALL SUBOPT_0xD3
	CALL SUBOPT_0xD4
; 0000 156F 
; 0000 1570                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x2C7:
	CALL SUBOPT_0xD5
	BREQ _0x2C8
; 0000 1571                                         {
; 0000 1572                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1573                                         cykl_sterownik_2 = 0;
; 0000 1574                                         cykl_sterownik_3 = 0;
; 0000 1575                                         cykl_sterownik_4 = 0;
; 0000 1576                                         cykl_testu = 3;
	__GETWRN 16,17,3
; 0000 1577 
; 0000 1578                                         }
; 0000 1579 
; 0000 157A             break;
_0x2C8:
	RJMP _0x2BD
; 0000 157B 
; 0000 157C 
; 0000 157D             case 3:
_0x2C5:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2C9
; 0000 157E 
; 0000 157F                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x2CA
; 0000 1580                                     cykl_sterownik_1 = sterownik_1_praca(a[0]); //ster 1 pod srodek zacisku
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xD1
; 0000 1581 
; 0000 1582                                     if(cykl_sterownik_1 == 5)
_0x2CA:
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRNE _0x2CB
; 0000 1583                                         {
; 0000 1584                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1585                                         cykl_sterownik_2 = 0;
; 0000 1586                                         cykl_sterownik_3 = 0;
; 0000 1587                                         cykl_sterownik_4 = 0;
; 0000 1588                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 1589                                         }
; 0000 158A 
; 0000 158B             break;
_0x2CB:
	RJMP _0x2BD
; 0000 158C 
; 0000 158D             case 4:
_0x2C9:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2CC
; 0000 158E 
; 0000 158F                                    if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x2CD
; 0000 1590                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
	CALL SUBOPT_0x70
	CALL SUBOPT_0xD8
; 0000 1591 
; 0000 1592                                    if(cykl_sterownik_3 == 5)
_0x2CD:
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRNE _0x2CE
; 0000 1593                                         {
; 0000 1594                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1595                                         cykl_sterownik_2 = 0;
; 0000 1596                                         cykl_sterownik_3 = 0;
; 0000 1597                                         cykl_sterownik_4 = 0;
; 0000 1598                                         cykl_testu = 5;
	__GETWRN 16,17,5
; 0000 1599                                         }
; 0000 159A 
; 0000 159B             break;
_0x2CE:
	RJMP _0x2BD
; 0000 159C 
; 0000 159D             case 5:
_0x2CC:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2CF
; 0000 159E                                    if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x2D0
; 0000 159F                                    {
; 0000 15A0                                      d = odczytaj_parametr(48,80);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x21
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 15A1                                         if(d == 0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x2D1
; 0000 15A2                                             cykl_testu = 666;
	__GETWRN 16,17,666
; 0000 15A3 
; 0000 15A4                                         if(d == 2 & ff[2] == 0)
_0x2D1:
	MOVW R26,R18
	CALL SUBOPT_0xB1
	MOV  R0,R30
	CALL SUBOPT_0x12
	BREQ _0x2D2
; 0000 15A5                                             {
; 0000 15A6                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 15A7                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 15A8                                             }
; 0000 15A9                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
_0x2D2:
	CALL SUBOPT_0xDA
	AND  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0xAD
	BREQ _0x2D3
; 0000 15AA                                             {
; 0000 15AB                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 15AC                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 15AD                                             }
; 0000 15AE                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
_0x2D3:
	CALL SUBOPT_0xDB
	AND  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0xAD
	BREQ _0x2D4
; 0000 15AF                                             {
; 0000 15B0                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 15B1                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 15B2                                             }
; 0000 15B3                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
_0x2D4:
	CALL SUBOPT_0xDC
	AND  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0xAD
	BREQ _0x2D5
; 0000 15B4                                             {
; 0000 15B5                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 15B6                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 15B7                                             }
; 0000 15B8                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
_0x2D5:
	CALL SUBOPT_0xDD
	AND  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0xAD
	BREQ _0x2D6
; 0000 15B9                                             {
; 0000 15BA                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 15BB                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 15BC                                             }
; 0000 15BD                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
_0x2D6:
	CALL SUBOPT_0xDE
	AND  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0xAD
	BREQ _0x2D7
; 0000 15BE                                             {
; 0000 15BF                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 15C0                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 15C1                                             }
; 0000 15C2                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
_0x2D7:
	CALL SUBOPT_0xDF
	AND  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0xAD
	BREQ _0x2D8
; 0000 15C3                                             {
; 0000 15C4                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 15C5                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 15C6                                             }
; 0000 15C7                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
_0x2D8:
	CALL SUBOPT_0xE0
	AND  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CALL SUBOPT_0xAD
	BREQ _0x2D9
; 0000 15C8                                             {
; 0000 15C9                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 15CA                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 15CB                                             }
; 0000 15CC                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
_0x2D9:
	CALL SUBOPT_0xE1
	AND  R0,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL SUBOPT_0xAD
	BREQ _0x2DA
; 0000 15CD                                             {
; 0000 15CE                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 15CF                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 15D0                                             }
; 0000 15D1                                     }
_0x2DA:
; 0000 15D2 
; 0000 15D3             break;
_0x2D0:
	RJMP _0x2BD
; 0000 15D4 
; 0000 15D5             case 6:
_0x2CF:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2DB
; 0000 15D6                                      if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x2DC
; 0000 15D7                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCB
; 0000 15D8                                         if(cykl_sterownik_3 == 5)
_0x2DC:
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRNE _0x2DD
; 0000 15D9                                             {
; 0000 15DA                                             cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 15DB                                             cykl_sterownik_2 = 0;
; 0000 15DC                                             cykl_sterownik_3 = 0;
; 0000 15DD                                             cykl_sterownik_4 = 0;
; 0000 15DE                                             cykl_testu = 7;
	__GETWRN 16,17,7
; 0000 15DF                                             }
; 0000 15E0 
; 0000 15E1             break;
_0x2DD:
	RJMP _0x2BD
; 0000 15E2 
; 0000 15E3             case 7:
_0x2DB:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2DE
; 0000 15E4 
; 0000 15E5                                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x2DF
; 0000 15E6                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
	CALL SUBOPT_0xE2
; 0000 15E7 
; 0000 15E8                                     if(cykl_sterownik_1 == 5)
_0x2DF:
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRNE _0x2E0
; 0000 15E9                                         {
; 0000 15EA                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 15EB                                         cykl_sterownik_2 = 0;
; 0000 15EC                                         cykl_sterownik_3 = 0;
; 0000 15ED                                         cykl_sterownik_4 = 0;
; 0000 15EE                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 15EF                                         }
; 0000 15F0 
; 0000 15F1 
; 0000 15F2             break;
_0x2E0:
	RJMP _0x2BD
; 0000 15F3 
; 0000 15F4 
; 0000 15F5 
; 0000 15F6 
; 0000 15F7 
; 0000 15F8 
; 0000 15F9 
; 0000 15FA             case 666:
_0x2DE:
	CPI  R30,LOW(0x29A)
	LDI  R26,HIGH(0x29A)
	CPC  R31,R26
	BRNE _0x2BD
; 0000 15FB 
; 0000 15FC                                         if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x2E2
; 0000 15FD                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCB
; 0000 15FE                                         if(cykl_sterownik_3 == 5)
_0x2E2:
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRNE _0x2E3
; 0000 15FF                                             {
; 0000 1600                                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0xCF
; 0000 1601                                             cykl_sterownik_4 = 0;
; 0000 1602                                             cykl_testu = 100;
	__GETWRN 16,17,100
; 0000 1603                                             test_geometryczny_rzad_1 = 0;
	LDI  R30,LOW(0)
	STS  _test_geometryczny_rzad_1,R30
	STS  _test_geometryczny_rzad_1+1,R30
; 0000 1604                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 1605                                             }
; 0000 1606 
; 0000 1607             break;
_0x2E3:
; 0000 1608 
; 0000 1609 
; 0000 160A 
; 0000 160B             }
_0x2BD:
; 0000 160C 
; 0000 160D         }
	RJMP _0x2B8
_0x2BA:
; 0000 160E     }
; 0000 160F 
; 0000 1610 
; 0000 1611 
; 0000 1612                                                                    //swiatlo czer       //swiatlo zolte
; 0000 1613 if(test_geometryczny_rzad_1 == 0 & test_geometryczny_rzad_2 == 1 & PORTD.7 == 0  & PORT_F.bits.b6 == 0 &
_0x2B7:
; 0000 1614     il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0 & sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0xC2
	CALL SUBOPT_0xC4
	MOV  R0,R30
	CALL SUBOPT_0xC3
	CALL SUBOPT_0x7A
	CALL SUBOPT_0xC5
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xE4
	CALL SUBOPT_0xE5
	AND  R30,R0
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	POP  R26
	AND  R30,R26
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x2E6
; 0000 1615     {
; 0000 1616     while(test_geometryczny_rzad_2 == 1)
_0x2E7:
	CALL SUBOPT_0xC3
	SBIW R26,1
	BREQ PC+3
	JMP _0x2E9
; 0000 1617         {
; 0000 1618         switch(cykl_testu)
	MOVW R30,R16
; 0000 1619             {
; 0000 161A              case 0:
	SBIW R30,0
	BRNE _0x2ED
; 0000 161B 
; 0000 161C                wybor_linijek_sterownikow(2);
	CALL SUBOPT_0xE6
; 0000 161D                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	CALL SUBOPT_0xC9
; 0000 161E                cykl_sterownik_1 = 0;
; 0000 161F                cykl_sterownik_2 = 0;
; 0000 1620                cykl_sterownik_3 = 0;
; 0000 1621                cykl_sterownik_4 = 0;
; 0000 1622                wybor_linijek_sterownikow(2);
	CALL SUBOPT_0xE6
; 0000 1623                cykl_testu = 1;
	__GETWRN 16,17,1
; 0000 1624 
; 0000 1625 
; 0000 1626 
; 0000 1627             break;
	RJMP _0x2EC
; 0000 1628 
; 0000 1629             case 1:
_0x2ED:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2F0
; 0000 162A 
; 0000 162B             //na sam dol zjezdzamy pionami
; 0000 162C                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x2F1
; 0000 162D                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCB
; 0000 162E                 if(cykl_sterownik_4 < 5)
_0x2F1:
	CALL SUBOPT_0xCC
	SBIW R26,5
	BRGE _0x2F2
; 0000 162F                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCD
; 0000 1630 
; 0000 1631                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2F2:
	CALL SUBOPT_0xCE
	BREQ _0x2F3
; 0000 1632                                         {
; 0000 1633                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xCF
; 0000 1634                                         cykl_sterownik_4 = 0;
; 0000 1635                                         cykl_testu = 2;
	__GETWRN 16,17,2
; 0000 1636                                         }
; 0000 1637 
; 0000 1638 
; 0000 1639 
; 0000 163A             break;
_0x2F3:
	RJMP _0x2EC
; 0000 163B 
; 0000 163C 
; 0000 163D             case 2:
_0x2F0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2F4
; 0000 163E 
; 0000 163F                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x2F5
; 0000 1640                                     cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xE7
	CALL SUBOPT_0xD1
; 0000 1641                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy rzad 2
_0x2F5:
	CALL SUBOPT_0xD2
	SBIW R26,5
	BRGE _0x2F6
; 0000 1642                                     cykl_sterownik_2 = sterownik_2_praca(0x009);       //ster 2 ucieczka dla II rzedu (druciak)
	CALL SUBOPT_0xE8
	CALL SUBOPT_0xD4
; 0000 1643 
; 0000 1644                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x2F6:
	CALL SUBOPT_0xD5
	BREQ _0x2F7
; 0000 1645                                         {
; 0000 1646                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1647                                         cykl_sterownik_2 = 0;
; 0000 1648                                         cykl_sterownik_3 = 0;
; 0000 1649                                         cykl_sterownik_4 = 0;
; 0000 164A                                         cykl_testu = 3;
	__GETWRN 16,17,3
; 0000 164B 
; 0000 164C                                         }
; 0000 164D 
; 0000 164E             break;
_0x2F7:
	RJMP _0x2EC
; 0000 164F 
; 0000 1650 
; 0000 1651             case 3:
_0x2F4:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2F8
; 0000 1652 
; 0000 1653                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x2F9
; 0000 1654                                     cykl_sterownik_1 = sterownik_1_praca(a[1]); //ster 1 pod srodek zacisku
	CALL SUBOPT_0xE9
	CALL SUBOPT_0xD1
; 0000 1655 
; 0000 1656                                     if(cykl_sterownik_1 == 5)
_0x2F9:
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRNE _0x2FA
; 0000 1657                                         {
; 0000 1658                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1659                                         cykl_sterownik_2 = 0;
; 0000 165A                                         cykl_sterownik_3 = 0;
; 0000 165B                                         cykl_sterownik_4 = 0;
; 0000 165C                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 165D                                         }
; 0000 165E 
; 0000 165F             break;
_0x2FA:
	RJMP _0x2EC
; 0000 1660 
; 0000 1661             case 4:
_0x2F8:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2FB
; 0000 1662 
; 0000 1663                                    if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x2FC
; 0000 1664                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
	CALL SUBOPT_0x70
	CALL SUBOPT_0xD8
; 0000 1665 
; 0000 1666                                    if(cykl_sterownik_3 == 5)
_0x2FC:
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRNE _0x2FD
; 0000 1667                                         {
; 0000 1668                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1669                                         cykl_sterownik_2 = 0;
; 0000 166A                                         cykl_sterownik_3 = 0;
; 0000 166B                                         cykl_sterownik_4 = 0;
; 0000 166C                                         cykl_testu = 5;
	__GETWRN 16,17,5
; 0000 166D                                         }
; 0000 166E 
; 0000 166F             break;
_0x2FD:
	RJMP _0x2EC
; 0000 1670 
; 0000 1671             case 5:
_0x2FB:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2FE
; 0000 1672                                      if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x2FF
; 0000 1673                                      {
; 0000 1674                                      d = odczytaj_parametr(48,96);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x22
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 1675                                         if(d == 0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x300
; 0000 1676                                             cykl_testu = 666;
	__GETWRN 16,17,666
; 0000 1677 
; 0000 1678 
; 0000 1679 
; 0000 167A 
; 0000 167B                                         if(d == 2 & ff[2] == 0)
_0x300:
	MOVW R26,R18
	CALL SUBOPT_0xB1
	MOV  R0,R30
	CALL SUBOPT_0x12
	BREQ _0x301
; 0000 167C                                             {
; 0000 167D                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 167E                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 167F                                             }
; 0000 1680                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
_0x301:
	CALL SUBOPT_0xDA
	AND  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0xAD
	BREQ _0x302
; 0000 1681                                             {
; 0000 1682                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 1683                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 1684                                             }
; 0000 1685                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
_0x302:
	CALL SUBOPT_0xDB
	AND  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0xAD
	BREQ _0x303
; 0000 1686                                             {
; 0000 1687                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 1688                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 1689                                             }
; 0000 168A                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
_0x303:
	CALL SUBOPT_0xDC
	AND  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0xAD
	BREQ _0x304
; 0000 168B                                             {
; 0000 168C                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 168D                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 168E                                             }
; 0000 168F                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
_0x304:
	CALL SUBOPT_0xDD
	AND  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0xAD
	BREQ _0x305
; 0000 1690                                             {
; 0000 1691                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 1692                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 1693                                             }
; 0000 1694                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
_0x305:
	CALL SUBOPT_0xDE
	AND  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0xAD
	BREQ _0x306
; 0000 1695                                             {
; 0000 1696                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 1697                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 1698                                             }
; 0000 1699                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
_0x306:
	CALL SUBOPT_0xDF
	AND  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0xAD
	BREQ _0x307
; 0000 169A                                             {
; 0000 169B                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 169C                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 169D                                             }
; 0000 169E                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
_0x307:
	CALL SUBOPT_0xE0
	AND  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CALL SUBOPT_0xAD
	BREQ _0x308
; 0000 169F                                             {
; 0000 16A0                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 16A1                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 16A2                                             }
; 0000 16A3                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
_0x308:
	CALL SUBOPT_0xE1
	AND  R0,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL SUBOPT_0xAD
	BREQ _0x309
; 0000 16A4                                             {
; 0000 16A5                                             cykl_testu = 6;
	CALL SUBOPT_0xD9
; 0000 16A6                                             ff[d]=1;
	CALL SUBOPT_0x2A
; 0000 16A7                                             }
; 0000 16A8 
; 0000 16A9                                       }
_0x309:
; 0000 16AA             break;
_0x2FF:
	RJMP _0x2EC
; 0000 16AB 
; 0000 16AC             case 6:
_0x2FE:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x30A
; 0000 16AD                                      if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x30B
; 0000 16AE                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCB
; 0000 16AF                                         if(cykl_sterownik_3 == 5)
_0x30B:
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRNE _0x30C
; 0000 16B0                                             {
; 0000 16B1                                             cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 16B2                                             cykl_sterownik_2 = 0;
; 0000 16B3                                             cykl_sterownik_3 = 0;
; 0000 16B4                                             cykl_sterownik_4 = 0;
; 0000 16B5                                             cykl_testu = 7;
	__GETWRN 16,17,7
; 0000 16B6                                             }
; 0000 16B7 
; 0000 16B8             break;
_0x30C:
	RJMP _0x2EC
; 0000 16B9 
; 0000 16BA             case 7:
_0x30A:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x30D
; 0000 16BB 
; 0000 16BC                                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x30E
; 0000 16BD                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
	CALL SUBOPT_0xE2
; 0000 16BE 
; 0000 16BF                                     if(cykl_sterownik_1 == 5)
_0x30E:
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRNE _0x30F
; 0000 16C0                                         {
; 0000 16C1                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 16C2                                         cykl_sterownik_2 = 0;
; 0000 16C3                                         cykl_sterownik_3 = 0;
; 0000 16C4                                         cykl_sterownik_4 = 0;
; 0000 16C5                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 16C6                                         }
; 0000 16C7 
; 0000 16C8 
; 0000 16C9             break;
_0x30F:
	RJMP _0x2EC
; 0000 16CA 
; 0000 16CB 
; 0000 16CC 
; 0000 16CD             case 666:
_0x30D:
	CPI  R30,LOW(0x29A)
	LDI  R26,HIGH(0x29A)
	CPC  R31,R26
	BRNE _0x2EC
; 0000 16CE 
; 0000 16CF                                         if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x311
; 0000 16D0                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCB
; 0000 16D1                                         if(cykl_sterownik_3 == 5)
_0x311:
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRNE _0x312
; 0000 16D2                                             {
; 0000 16D3                                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0xCF
; 0000 16D4                                             cykl_sterownik_4 = 0;
; 0000 16D5                                             cykl_testu = 100;
	__GETWRN 16,17,100
; 0000 16D6                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 16D7                                             test_geometryczny_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _test_geometryczny_rzad_2,R30
	STS  _test_geometryczny_rzad_2+1,R30
; 0000 16D8                                             }
; 0000 16D9 
; 0000 16DA             break;
_0x312:
; 0000 16DB 
; 0000 16DC 
; 0000 16DD 
; 0000 16DE             }
_0x2EC:
; 0000 16DF 
; 0000 16E0         }
	RJMP _0x2E7
_0x2E9:
; 0000 16E1     }
; 0000 16E2 
; 0000 16E3 
; 0000 16E4 
; 0000 16E5 
; 0000 16E6 }
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
; 0000 16ED {
_kontrola_zoltego_swiatla:
; 0000 16EE 
; 0000 16EF 
; 0000 16F0 if(czas_pracy_szczotki_drucianej_h >= czas_pracy_szczotki_drucianej_stala)
	CALL SUBOPT_0xEA
	MOVW R0,R30
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL __EEPROMRDW
	CP   R0,R30
	CPC  R1,R31
	BRLT _0x315
; 0000 16F1      {
; 0000 16F2      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0xEB
; 0000 16F3      PORTF = PORT_F.byte;
; 0000 16F4      komunikat_na_panel("                                                ",80,0);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0x21
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 16F5      komunikat_na_panel("Wymien szczotke druciana",80,0);
	__POINTW1FN _0x0,1994
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x21
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 16F6      }
; 0000 16F7 
; 0000 16F8 if(czas_pracy_krazka_sciernego_h_34 >= czas_pracy_krazka_sciernego_stala)
_0x315:
	CALL SUBOPT_0xED
	MOVW R0,R30
	CALL SUBOPT_0x9C
	CP   R0,R30
	CPC  R1,R31
	BRLT _0x316
; 0000 16F9      {
; 0000 16FA      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0xEB
; 0000 16FB      PORTF = PORT_F.byte;
; 0000 16FC      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xEE
	CALL _komunikat_na_panel
; 0000 16FD      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 34",64,0);
	__POINTW1FN _0x0,2019
	CALL SUBOPT_0xEF
	CALL _komunikat_na_panel
; 0000 16FE      }
; 0000 16FF 
; 0000 1700 if(czas_pracy_krazka_sciernego_h_36 >= czas_pracy_krazka_sciernego_stala)
_0x316:
	CALL SUBOPT_0xF0
	MOVW R0,R30
	CALL SUBOPT_0x9C
	CP   R0,R30
	CPC  R1,R31
	BRLT _0x317
; 0000 1701      {
; 0000 1702      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0xEB
; 0000 1703      PORTF = PORT_F.byte;
; 0000 1704      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xEE
	CALL _komunikat_na_panel
; 0000 1705      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 36",64,0);
	__POINTW1FN _0x0,2066
	CALL SUBOPT_0xEF
	CALL _komunikat_na_panel
; 0000 1706      }
; 0000 1707 
; 0000 1708 if(czas_pracy_krazka_sciernego_h_38 >= czas_pracy_krazka_sciernego_stala)
_0x317:
	CALL SUBOPT_0xF1
	MOVW R0,R30
	CALL SUBOPT_0x9C
	CP   R0,R30
	CPC  R1,R31
	BRLT _0x318
; 0000 1709      {
; 0000 170A      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0xEB
; 0000 170B      PORTF = PORT_F.byte;
; 0000 170C      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xEE
	CALL _komunikat_na_panel
; 0000 170D      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 38",64,0);
	__POINTW1FN _0x0,2113
	CALL SUBOPT_0xEF
	CALL _komunikat_na_panel
; 0000 170E      }
; 0000 170F 
; 0000 1710 if(czas_pracy_krazka_sciernego_h_41 >= czas_pracy_krazka_sciernego_stala)
_0x318:
	CALL SUBOPT_0xF2
	MOVW R0,R30
	CALL SUBOPT_0x9C
	CP   R0,R30
	CPC  R1,R31
	BRLT _0x319
; 0000 1711      {
; 0000 1712      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0xEB
; 0000 1713      PORTF = PORT_F.byte;
; 0000 1714      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xEE
	CALL _komunikat_na_panel
; 0000 1715      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 41",64,0);
	__POINTW1FN _0x0,2160
	CALL SUBOPT_0xEF
	CALL _komunikat_na_panel
; 0000 1716      }
; 0000 1717 
; 0000 1718 if(czas_pracy_krazka_sciernego_h_43 >= czas_pracy_krazka_sciernego_stala)
_0x319:
	CALL SUBOPT_0xF3
	MOVW R0,R30
	CALL SUBOPT_0x9C
	CP   R0,R30
	CPC  R1,R31
	BRLT _0x31A
; 0000 1719      {
; 0000 171A      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0xEB
; 0000 171B      PORTF = PORT_F.byte;
; 0000 171C      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xEE
	CALL _komunikat_na_panel
; 0000 171D      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 43",64,0);
	__POINTW1FN _0x0,2207
	CALL SUBOPT_0xEF
	CALL _komunikat_na_panel
; 0000 171E      }
; 0000 171F 
; 0000 1720 
; 0000 1721 
; 0000 1722 }
_0x31A:
	RET
;
;void wymiana_szczotki_i_krazka()
; 0000 1725 {
_wymiana_szczotki_i_krazka:
; 0000 1726 int g,e,f,d,cykl_wymiany;
; 0000 1727 cykl_wymiany = 0;
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
; 0000 1728                       //30 //20
; 0000 1729 
; 0000 172A if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x31B
; 0000 172B {
; 0000 172C g = odczytaj_parametr(48,32);  //szczotka druciana
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x29
	CALL _odczytaj_parametr
	MOVW R16,R30
; 0000 172D                     //30  //30
; 0000 172E f = odczytaj_parametr(48,48);  //krazek scierny
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1A
	CALL _odczytaj_parametr
	MOVW R20,R30
; 0000 172F }
; 0000 1730 
; 0000 1731 while(g == 1)
_0x31B:
_0x31C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+3
	JMP _0x31E
; 0000 1732     {
; 0000 1733     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 1734     {
; 0000 1735     case 0:
	SBIW R30,0
	BRNE _0x322
; 0000 1736 
; 0000 1737                cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
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
	RJMP _0x321
; 0000 1741 
; 0000 1742     case 1:
_0x322:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x325
; 0000 1743 
; 0000 1744             //na sam dol zjezdzamy pionami
; 0000 1745                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x326
; 0000 1746                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCB
; 0000 1747                 if(cykl_sterownik_4 < 5)
_0x326:
	CALL SUBOPT_0xCC
	SBIW R26,5
	BRGE _0x327
; 0000 1748                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCD
; 0000 1749 
; 0000 174A                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x327:
	CALL SUBOPT_0xCE
	BREQ _0x328
; 0000 174B 
; 0000 174C                             {
; 0000 174D                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xCF
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
_0x328:
	RJMP _0x321
; 0000 1755 
; 0000 1756 
; 0000 1757 
; 0000 1758     case 2:
_0x325:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x329
; 0000 1759 
; 0000 175A                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x32A
; 0000 175B                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0xF4
	CALL SUBOPT_0xD1
; 0000 175C                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x32A:
	CALL SUBOPT_0xD2
	SBIW R26,5
	BRGE _0x32B
; 0000 175D                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xF4
	CALL SUBOPT_0xD4
; 0000 175E 
; 0000 175F                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x32B:
	CALL SUBOPT_0xD5
	BREQ _0x32C
; 0000 1760                                         {
; 0000 1761                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1762                                         cykl_sterownik_2 = 0;
; 0000 1763                                         cykl_sterownik_3 = 0;
; 0000 1764                                         cykl_sterownik_4 = 0;
; 0000 1765                                          cykl_wymiany = 3;
	CALL SUBOPT_0xF5
; 0000 1766 
; 0000 1767                                         }
; 0000 1768 
; 0000 1769     break;
_0x32C:
	RJMP _0x321
; 0000 176A 
; 0000 176B 
; 0000 176C 
; 0000 176D     case 3:
_0x329:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x32D
; 0000 176E 
; 0000 176F             //na sam dol zjezdzamy pionami
; 0000 1770                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x32E
; 0000 1771                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xD8
; 0000 1772                 if(cykl_sterownik_4 < 5)
_0x32E:
	CALL SUBOPT_0xCC
	SBIW R26,5
	BRGE _0x32F
; 0000 1773                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xCD
; 0000 1774 
; 0000 1775                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x32F:
	CALL SUBOPT_0xCE
	BRNE PC+3
	JMP _0x330
; 0000 1776 
; 0000 1777                             {
; 0000 1778                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xCF
; 0000 1779                                         cykl_sterownik_4 = 0;
; 0000 177A                                         d = odczytaj_parametr(48,32);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x29
	CALL _odczytaj_parametr
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 177B 
; 0000 177C                                         switch (d)
; 0000 177D                                         {
; 0000 177E                                         case 0:
	SBIW R30,0
	BRNE _0x334
; 0000 177F 
; 0000 1780                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x335
; 0000 1781                                                 {
; 0000 1782                                                 cykl_wymiany = 4;
	CALL SUBOPT_0xF6
; 0000 1783                                                 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1784                                                 }
; 0000 1785                                              //jednak nie wymianiamy
; 0000 1786 
; 0000 1787                                         break;
_0x335:
	RJMP _0x333
; 0000 1788 
; 0000 1789                                         case 1:
_0x334:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x338
; 0000 178A                                              cykl_wymiany = 3;
	CALL SUBOPT_0xF5
; 0000 178B                                              PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 178C                                              //czekam z decyzja - w trakcie wymiany
; 0000 178D                                         break;
	RJMP _0x333
; 0000 178E 
; 0000 178F                                         case 2:
_0x338:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x333
; 0000 1790 
; 0000 1791 
; 0000 1792                                              wymieniono_szczotke_druciana = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wymieniono_szczotke_druciana,R30
	STS  _wymieniono_szczotke_druciana+1,R31
; 0000 1793                                              PORT_F.bits.b6 = 0;   //zgas lampke
	LDS  R30,_PORT_F
	ANDI R30,0xBF
	CALL SUBOPT_0xBB
; 0000 1794                                              PORTF = PORT_F.byte;
; 0000 1795                                              czas_pracy_szczotki_drucianej = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_szczotki_drucianej,R30
	STS  _czas_pracy_szczotki_drucianej+1,R30
; 0000 1796                                              czas_pracy_szczotki_drucianej_h = 0;
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h)
	CALL SUBOPT_0xF7
; 0000 1797                                              zaktualizuj_parametry_panelu();
	CALL _zaktualizuj_parametry_panelu
; 0000 1798                                              komunikat_na_panel("                                                ",80,0);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0x21
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 1799 
; 0000 179A                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x33C
; 0000 179B                                                 {
; 0000 179C                                                 cykl_wymiany = 4;
	CALL SUBOPT_0xF6
; 0000 179D                                                 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 179E                                                 }
; 0000 179F                                              //wymianymy
; 0000 17A0                                         break;
_0x33C:
; 0000 17A1                                         }
_0x333:
; 0000 17A2                             }
; 0000 17A3 
; 0000 17A4 
; 0000 17A5 
; 0000 17A6 
; 0000 17A7 
; 0000 17A8 
; 0000 17A9     break;
_0x330:
	RJMP _0x321
; 0000 17AA 
; 0000 17AB    case 4:
_0x32D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x321
; 0000 17AC 
; 0000 17AD                       //na sam dol zjezdzamy pionami
; 0000 17AE                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x340
; 0000 17AF                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCB
; 0000 17B0                 if(cykl_sterownik_4 < 5)
_0x340:
	CALL SUBOPT_0xCC
	SBIW R26,5
	BRGE _0x341
; 0000 17B1                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCD
; 0000 17B2 
; 0000 17B3                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x341:
	CALL SUBOPT_0xCE
	BREQ _0x342
; 0000 17B4                                         {
; 0000 17B5                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 17B6                                         cykl_sterownik_2 = 0;
; 0000 17B7                                         cykl_sterownik_3 = 0;
; 0000 17B8                                         cykl_sterownik_4 = 0;
; 0000 17B9                                         wartosc_parametru_panelu(0,48,32);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x29
	CALL _wartosc_parametru_panelu
; 0000 17BA                                         PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 17BB                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 17BC                                         g = 0;
	__GETWRN 16,17,0
; 0000 17BD                                         }
; 0000 17BE 
; 0000 17BF    break;
_0x342:
; 0000 17C0 
; 0000 17C1 
; 0000 17C2     }//switch
_0x321:
; 0000 17C3 
; 0000 17C4    }//while
	RJMP _0x31C
_0x31E:
; 0000 17C5 
; 0000 17C6 
; 0000 17C7 while(f == 1)
_0x345:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ PC+3
	JMP _0x347
; 0000 17C8     {
; 0000 17C9     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 17CA     {
; 0000 17CB     case 0:
	SBIW R30,0
	BRNE _0x34B
; 0000 17CC 
; 0000 17CD                cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 17CE                cykl_sterownik_2 = 0;
; 0000 17CF                cykl_sterownik_3 = 0;
; 0000 17D0                cykl_sterownik_4 = 0;
; 0000 17D1                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 17D2                cykl_wymiany = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 17D3 
; 0000 17D4 
; 0000 17D5 
; 0000 17D6     break;
	RJMP _0x34A
; 0000 17D7 
; 0000 17D8     case 1:
_0x34B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x34E
; 0000 17D9 
; 0000 17DA             //na sam dol zjezdzamy pionami
; 0000 17DB                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x34F
; 0000 17DC                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCB
; 0000 17DD                 if(cykl_sterownik_4 < 5)
_0x34F:
	CALL SUBOPT_0xCC
	SBIW R26,5
	BRGE _0x350
; 0000 17DE                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCD
; 0000 17DF 
; 0000 17E0                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x350:
	CALL SUBOPT_0xCE
	BREQ _0x351
; 0000 17E1 
; 0000 17E2                             {
; 0000 17E3                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xCF
; 0000 17E4                                         cykl_sterownik_4 = 0;
; 0000 17E5                                         cykl_wymiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 17E6                                         }
; 0000 17E7 
; 0000 17E8 
; 0000 17E9 
; 0000 17EA     break;
_0x351:
	RJMP _0x34A
; 0000 17EB 
; 0000 17EC 
; 0000 17ED 
; 0000 17EE     case 2:
_0x34E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x352
; 0000 17EF 
; 0000 17F0                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x353
; 0000 17F1                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0xF4
	CALL SUBOPT_0xD1
; 0000 17F2                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x353:
	CALL SUBOPT_0xD2
	SBIW R26,5
	BRGE _0x354
; 0000 17F3                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xF4
	CALL SUBOPT_0xD4
; 0000 17F4 
; 0000 17F5                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x354:
	CALL SUBOPT_0xD5
	BREQ _0x355
; 0000 17F6                                         {
; 0000 17F7                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 17F8                                         cykl_sterownik_2 = 0;
; 0000 17F9                                         cykl_sterownik_3 = 0;
; 0000 17FA                                         cykl_sterownik_4 = 0;
; 0000 17FB                                          cykl_wymiany = 3;
	CALL SUBOPT_0xF5
; 0000 17FC 
; 0000 17FD                                         }
; 0000 17FE 
; 0000 17FF     break;
_0x355:
	RJMP _0x34A
; 0000 1800 
; 0000 1801 
; 0000 1802 
; 0000 1803     case 3:
_0x352:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x356
; 0000 1804 
; 0000 1805             //na sam dol zjezdzamy pionami
; 0000 1806                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x357
; 0000 1807                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xD8
; 0000 1808                 if(cykl_sterownik_4 < 5)
_0x357:
	CALL SUBOPT_0xCC
	SBIW R26,5
	BRGE _0x358
; 0000 1809                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xCD
; 0000 180A 
; 0000 180B                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x358:
	CALL SUBOPT_0xCE
	BRNE PC+3
	JMP _0x359
; 0000 180C 
; 0000 180D                             {
; 0000 180E                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xCF
; 0000 180F                                         cykl_sterownik_4 = 0;
; 0000 1810                                         e = odczytaj_parametr(48,48);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1A
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 1811 
; 0000 1812                                         switch (e)
	MOVW R30,R18
; 0000 1813                                         {
; 0000 1814                                         case 0:
	SBIW R30,0
	BRNE _0x35D
; 0000 1815 
; 0000 1816                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x35E
; 0000 1817                                              {
; 0000 1818                                              cykl_wymiany = 4;
	CALL SUBOPT_0xF6
; 0000 1819                                              PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 181A                                              }
; 0000 181B                                              //jednak nie wymianiamy
; 0000 181C 
; 0000 181D                                         break;
_0x35E:
	RJMP _0x35C
; 0000 181E 
; 0000 181F                                         case 1:
_0x35D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x361
; 0000 1820                                              PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 1821                                              cykl_wymiany = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x521
; 0000 1822                                              //czekam z decyzja - w trakcie wymiany
; 0000 1823                                         break;
; 0000 1824 
; 0000 1825                                         case 2:
_0x361:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x35C
; 0000 1826 
; 0000 1827                                              wymieniono_krazek_scierny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wymieniono_krazek_scierny,R30
	STS  _wymieniono_krazek_scierny+1,R31
; 0000 1828 
; 0000 1829                                              PORT_F.bits.b6 = 0;   //zgas lampke
	LDS  R30,_PORT_F
	ANDI R30,0xBF
	CALL SUBOPT_0xBB
; 0000 182A                                              PORTF = PORT_F.byte;
; 0000 182B                                              czas_pracy_krazka_sciernego = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego,R30
	STS  _czas_pracy_krazka_sciernego+1,R30
; 0000 182C                                              if(srednica_wew_korpusu == 34)
	CALL SUBOPT_0xF8
	SBIW R26,34
	BRNE _0x365
; 0000 182D                                                 czas_pracy_krazka_sciernego_h_34 = 0;
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_34)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_34)
	CALL SUBOPT_0xF7
; 0000 182E                                              if(srednica_wew_korpusu == 36)
_0x365:
	CALL SUBOPT_0xF8
	SBIW R26,36
	BRNE _0x366
; 0000 182F                                                 czas_pracy_krazka_sciernego_h_36 = 0;
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_36)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_36)
	CALL SUBOPT_0xF7
; 0000 1830                                              if(srednica_wew_korpusu == 38)
_0x366:
	CALL SUBOPT_0xF8
	SBIW R26,38
	BRNE _0x367
; 0000 1831                                                 czas_pracy_krazka_sciernego_h_38 = 0;
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_38)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_38)
	CALL SUBOPT_0xF7
; 0000 1832                                              if(srednica_wew_korpusu == 41)
_0x367:
	CALL SUBOPT_0xF8
	SBIW R26,41
	BRNE _0x368
; 0000 1833                                                 czas_pracy_krazka_sciernego_h_41 = 0;
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_41)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_41)
	CALL SUBOPT_0xF7
; 0000 1834                                              if(srednica_wew_korpusu == 43)
_0x368:
	CALL SUBOPT_0xF8
	SBIW R26,43
	BRNE _0x369
; 0000 1835                                                 czas_pracy_krazka_sciernego_h_43 = 0;
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_43)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_43)
	CALL SUBOPT_0xF7
; 0000 1836 
; 0000 1837                                              zaktualizuj_parametry_panelu();
_0x369:
	CALL _zaktualizuj_parametry_panelu
; 0000 1838                                              komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xEC
	CALL SUBOPT_0xEE
	CALL _komunikat_na_panel
; 0000 1839                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x36A
; 0000 183A                                                      {
; 0000 183B                                                      PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 183C                                                      cykl_wymiany = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
_0x521:
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 183D                                                      }
; 0000 183E                                              //wymianymy
; 0000 183F                                         break;
_0x36A:
; 0000 1840                                         }
_0x35C:
; 0000 1841                             }
; 0000 1842 
; 0000 1843 
; 0000 1844 
; 0000 1845 
; 0000 1846 
; 0000 1847 
; 0000 1848     break;
_0x359:
	RJMP _0x34A
; 0000 1849 
; 0000 184A    case 4:
_0x356:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x34A
; 0000 184B 
; 0000 184C                       //na sam dol zjezdzamy pionami
; 0000 184D                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x36E
; 0000 184E                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCB
; 0000 184F                 if(cykl_sterownik_4 < 5)
_0x36E:
	CALL SUBOPT_0xCC
	SBIW R26,5
	BRGE _0x36F
; 0000 1850                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCD
; 0000 1851 
; 0000 1852                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x36F:
	CALL SUBOPT_0xCE
	BREQ _0x370
; 0000 1853 
; 0000 1854                             {
; 0000 1855                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1856                                         cykl_sterownik_2 = 0;
; 0000 1857                                         cykl_sterownik_3 = 0;
; 0000 1858                                         cykl_sterownik_4 = 0;
; 0000 1859                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 185A                                         wartosc_parametru_panelu(0,48,48);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1A
	CALL _wartosc_parametru_panelu
; 0000 185B                                         PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 185C                                         f = 0;
	__GETWRN 20,21,0
; 0000 185D                                         }
; 0000 185E 
; 0000 185F    break;
_0x370:
; 0000 1860 
; 0000 1861 
; 0000 1862     }//switch
_0x34A:
; 0000 1863 
; 0000 1864    }//while
	RJMP _0x345
_0x347:
; 0000 1865 
; 0000 1866 
; 0000 1867 
; 0000 1868 
; 0000 1869 
; 0000 186A 
; 0000 186B 
; 0000 186C 
; 0000 186D }
	CALL __LOADLOCR6
	ADIW R28,10
	RET
;
;
;void przypadek887()
; 0000 1871 {
_przypadek887:
; 0000 1872 if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF9
	BRGE _0x373
; 0000 1873                         {
; 0000 1874                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xFA
; 0000 1875                         PORTF = PORT_F.byte;
; 0000 1876                         }
; 0000 1877 
; 0000 1878 
; 0000 1879                      if(rzad_obrabiany == 2)
_0x373:
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x374
; 0000 187A                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 187B 
; 0000 187C                     if(koniec_rzedu_10 == 1)
_0x374:
	CALL SUBOPT_0xFB
	BRNE _0x375
; 0000 187D                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xFC
; 0000 187E 
; 0000 187F 
; 0000 1880                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x375:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0xFE
	MOVW R26,R30
	CALL SUBOPT_0xE4
	CALL SUBOPT_0xFF
	BREQ _0x376
; 0000 1881                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x71
	CALL SUBOPT_0x100
; 0000 1882 
; 0000 1883                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x376:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x101
	BREQ _0x377
; 0000 1884                         {
; 0000 1885                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1886                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x103
; 0000 1887                         }
; 0000 1888 
; 0000 1889 
; 0000 188A                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x377:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0xFE
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x378
; 0000 188B                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x105
; 0000 188C 
; 0000 188D                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x378:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x106
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x379
; 0000 188E                         {
; 0000 188F                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1890                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x107
; 0000 1891                         }
; 0000 1892 
; 0000 1893                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x379:
	CALL SUBOPT_0x78
	CALL SUBOPT_0x108
	AND  R30,R0
	BREQ _0x37A
; 0000 1894                         {
; 0000 1895                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1896                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x109
; 0000 1897                         }
; 0000 1898 
; 0000 1899                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 189A                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x37A:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x10A
	AND  R30,R0
	BREQ _0x37B
; 0000 189B                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x10B
; 0000 189C 
; 0000 189D 
; 0000 189E                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x37B:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x10C
	AND  R30,R0
	BREQ _0x37C
; 0000 189F                         {
; 0000 18A0                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 18A1                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x10D
; 0000 18A2                         }
; 0000 18A3 
; 0000 18A4 
; 0000 18A5 
; 0000 18A6 
; 0000 18A7 
; 0000 18A8 
; 0000 18A9 
; 0000 18AA                                                               //to nowy war, ostatni dzien w borg
; 0000 18AB                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x37C:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x10F
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x110
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x111
	BREQ _0x37D
; 0000 18AC                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x74
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xCD
; 0000 18AD 
; 0000 18AE                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x37D:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x112
	CALL SUBOPT_0x113
	CALL SUBOPT_0x114
	CALL SUBOPT_0xAD
	BREQ _0x37E
; 0000 18AF                         {
; 0000 18B0                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x115
	BRNE _0x37F
; 0000 18B1                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 18B2                         if(abs_ster4 == 0)
_0x37F:
	CALL SUBOPT_0x117
	BRNE _0x380
; 0000 18B3                             {
; 0000 18B4                             szczotka_druc_cykl++;
	CALL SUBOPT_0x118
; 0000 18B5                             abs_ster4 = 1;
; 0000 18B6                             }
; 0000 18B7                         else
	RJMP _0x381
_0x380:
; 0000 18B8                             {
; 0000 18B9                             abs_ster4 = 0;
	CALL SUBOPT_0x119
; 0000 18BA                             sek13 = 0;
; 0000 18BB                             }
_0x381:
; 0000 18BC                         }
; 0000 18BD 
; 0000 18BE                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x37E:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11B
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x11C
	BREQ _0x382
; 0000 18BF                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x7B
	CALL SUBOPT_0xD8
; 0000 18C0 
; 0000 18C1 
; 0000 18C2                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x382:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x11F
	BREQ _0x383
; 0000 18C3                         {
; 0000 18C4                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 18C5                         if(abs_ster3 == 0)
	CALL SUBOPT_0x121
	BRNE _0x384
; 0000 18C6                             {
; 0000 18C7                             krazek_scierny_cykl++;
	CALL SUBOPT_0x122
; 0000 18C8                             abs_ster3 = 1;
; 0000 18C9                             }
; 0000 18CA                         else
	RJMP _0x385
_0x384:
; 0000 18CB                             abs_ster3 = 0;
	CALL SUBOPT_0x123
; 0000 18CC                         }
_0x385:
; 0000 18CD 
; 0000 18CE                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x383:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11B
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x386
; 0000 18CF                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x70
	CALL SUBOPT_0xD8
; 0000 18D0 
; 0000 18D1                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x386:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x10F
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x110
	CALL SUBOPT_0xAD
	BREQ _0x387
; 0000 18D2                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory
	CALL SUBOPT_0x124
	CALL SUBOPT_0xCD
; 0000 18D3 
; 0000 18D4 
; 0000 18D5 
; 0000 18D6                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 18D7 
; 0000 18D8                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonalem_komplet_okregow == 3)
_0x387:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x125
	CALL SUBOPT_0x95
	CALL SUBOPT_0x126
	BREQ _0x388
; 0000 18D9                        {
; 0000 18DA                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 18DB                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x127
; 0000 18DC                        }
; 0000 18DD                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x388:
	CALL SUBOPT_0x128
	MOV  R0,R30
	CALL SUBOPT_0x11A
	CALL __LTW12
	AND  R30,R0
	BREQ _0x389
; 0000 18DE                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x129
; 0000 18DF 
; 0000 18E0                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x389:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x12A
	AND  R30,R0
	BREQ _0x38A
; 0000 18E1                        {
; 0000 18E2                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x12B
; 0000 18E3                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 18E4                        }
; 0000 18E5                    //////////////////////////////////////////////
; 0000 18E6 
; 0000 18E7 
; 0000 18E8 
; 0000 18E9                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 18EA 
; 0000 18EB                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x38A:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x112
	CALL SUBOPT_0x12C
	CALL SUBOPT_0x12D
	BREQ _0x38D
; 0000 18EC                        {
; 0000 18ED                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 18EE                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 18EF                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x12E
; 0000 18F0                        }
; 0000 18F1                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x38D:
	CALL SUBOPT_0x12F
	MOV  R0,R30
	CALL SUBOPT_0x10E
	CALL __LTW12
	AND  R30,R0
	BREQ _0x390
; 0000 18F2                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x130
	CALL SUBOPT_0xCD
; 0000 18F3 
; 0000 18F4                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x390:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x131
	AND  R30,R0
	BREQ _0x391
; 0000 18F5                        {
; 0000 18F6                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x132
; 0000 18F7                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 18F8                        }
; 0000 18F9                    //////////////////////////////////////////////
; 0000 18FA 
; 0000 18FB                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x391:
; 0000 18FC                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 18FD                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 18FE                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0 &  wykonalem_komplet_okregow == 3)
	CALL SUBOPT_0x95
	CALL SUBOPT_0x133
	CALL SUBOPT_0x125
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x134
	CALL SUBOPT_0x135
	CALL SUBOPT_0x110
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x136
	BREQ _0x394
; 0000 18FF                         {
; 0000 1900                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x12B
; 0000 1901                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x132
; 0000 1902                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1903                         cykl_sterownik_2 = 0;
; 0000 1904                         cykl_sterownik_3 = 0;
; 0000 1905                         cykl_sterownik_4 = 0;
; 0000 1906                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x137
; 0000 1907                         krazek_scierny_cykl = 0;
; 0000 1908                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1909                         wykonalem_komplet_okregow = 0;
; 0000 190A                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 190B                         //PORTF = PORT_F.byte;
; 0000 190C                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 190D                         cykl_glowny = 9;
; 0000 190E                         }
; 0000 190F }
_0x394:
	RET
;
;
;
;void przypadek888()
; 0000 1914 {
_przypadek888:
; 0000 1915 
; 0000 1916                  if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF9
	BRGE _0x397
; 0000 1917                         {
; 0000 1918                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xFA
; 0000 1919                         PORTF = PORT_F.byte;
; 0000 191A                         }
; 0000 191B 
; 0000 191C 
; 0000 191D                      if(rzad_obrabiany == 2)
_0x397:
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x398
; 0000 191E                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 191F 
; 0000 1920                     if(koniec_rzedu_10 == 1)
_0x398:
	CALL SUBOPT_0xFB
	BRNE _0x399
; 0000 1921                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xFC
; 0000 1922 
; 0000 1923 
; 0000 1924                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x399:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0xFE
	MOVW R26,R30
	CALL SUBOPT_0xE4
	CALL SUBOPT_0xFF
	BREQ _0x39A
; 0000 1925                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x71
	CALL SUBOPT_0x100
; 0000 1926 
; 0000 1927                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x39A:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x101
	BREQ _0x39B
; 0000 1928                         {
; 0000 1929                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 192A                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x103
; 0000 192B                         }
; 0000 192C 
; 0000 192D 
; 0000 192E                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x39B:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0xFE
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x39C
; 0000 192F                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x105
; 0000 1930 
; 0000 1931                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x39C:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x106
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x39D
; 0000 1932                         {
; 0000 1933                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1934                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x107
; 0000 1935                         }
; 0000 1936 
; 0000 1937                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x39D:
	CALL SUBOPT_0x78
	CALL SUBOPT_0x108
	AND  R30,R0
	BREQ _0x39E
; 0000 1938                         {
; 0000 1939                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 193A                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x109
; 0000 193B                         }
; 0000 193C 
; 0000 193D                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 193E                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x39E:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x10A
	AND  R30,R0
	BREQ _0x39F
; 0000 193F                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x10B
; 0000 1940 
; 0000 1941 
; 0000 1942                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x39F:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x10C
	AND  R30,R0
	BREQ _0x3A0
; 0000 1943                         {
; 0000 1944                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1945                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x10D
; 0000 1946                         }
; 0000 1947 
; 0000 1948 
; 0000 1949 
; 0000 194A 
; 0000 194B 
; 0000 194C 
; 0000 194D 
; 0000 194E                                                               //to nowy war, ostatni dzien w borg
; 0000 194F                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3A0:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x10F
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x110
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x111
	BREQ _0x3A1
; 0000 1950                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x74
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xCD
; 0000 1951 
; 0000 1952                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3A1:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x112
	CALL SUBOPT_0x138
	CALL SUBOPT_0xAD
	BREQ _0x3A2
; 0000 1953                         {
; 0000 1954                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x115
	BRNE _0x3A3
; 0000 1955                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1956                         if(abs_ster4 == 0)
_0x3A3:
	CALL SUBOPT_0x117
	BRNE _0x3A4
; 0000 1957                             {
; 0000 1958                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x73
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3A5
; 0000 1959                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 195A                             szczotka_druc_cykl++;
_0x3A5:
	CALL SUBOPT_0x118
; 0000 195B                             abs_ster4 = 1;
; 0000 195C                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x95
	CALL SUBOPT_0x139
	BRNE _0x3A8
; 0000 195D                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0xFC
; 0000 195E                             }
_0x3A8:
; 0000 195F                         else
	RJMP _0x3A9
_0x3A4:
; 0000 1960                             {
; 0000 1961                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1962                             abs_ster4 = 0;
	CALL SUBOPT_0x119
; 0000 1963                             sek13 = 0;
; 0000 1964                             }
_0x3A9:
; 0000 1965                         }
; 0000 1966 
; 0000 1967                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3A2:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11B
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x11C
	BREQ _0x3AC
; 0000 1968                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x7B
	CALL SUBOPT_0xD8
; 0000 1969 
; 0000 196A 
; 0000 196B                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3AC:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x13A
	BREQ _0x3AD
; 0000 196C                         {
; 0000 196D                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 196E                         if(abs_ster3 == 0)
	CALL SUBOPT_0x121
	BRNE _0x3AE
; 0000 196F                             {
; 0000 1970                             krazek_scierny_cykl++;
	CALL SUBOPT_0x122
; 0000 1971                             abs_ster3 = 1;
; 0000 1972                             }
; 0000 1973                         else
	RJMP _0x3AF
_0x3AE:
; 0000 1974                             abs_ster3 = 0;
	CALL SUBOPT_0x123
; 0000 1975                         }
_0x3AF:
; 0000 1976 
; 0000 1977                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3AD:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11B
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x3B0
; 0000 1978                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x70
	CALL SUBOPT_0xD8
; 0000 1979 
; 0000 197A                        if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x3B0:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x10F
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x110
	CALL SUBOPT_0xAD
	BREQ _0x3B1
; 0000 197B                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x77
	CALL SUBOPT_0x13B
	CALL SUBOPT_0xCD
; 0000 197C 
; 0000 197D                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 197E 
; 0000 197F                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonalem_komplet_okregow == 3)
_0x3B1:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x125
	CALL SUBOPT_0x95
	CALL SUBOPT_0x126
	BREQ _0x3B2
; 0000 1980                        {
; 0000 1981                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 1982                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x127
; 0000 1983                        }
; 0000 1984                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x3B2:
	CALL SUBOPT_0x128
	MOV  R0,R30
	CALL SUBOPT_0x11A
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3B3
; 0000 1985                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x129
; 0000 1986 
; 0000 1987                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x3B3:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x12A
	AND  R30,R0
	BREQ _0x3B4
; 0000 1988                        {
; 0000 1989                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x12B
; 0000 198A                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 198B                        }
; 0000 198C                    //////////////////////////////////////////////
; 0000 198D 
; 0000 198E 
; 0000 198F 
; 0000 1990                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1991 
; 0000 1992                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x3B4:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x112
	CALL SUBOPT_0x12C
	CALL SUBOPT_0x12D
	BREQ _0x3B7
; 0000 1993                        {
; 0000 1994                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1995                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1996                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x12E
; 0000 1997                        }
; 0000 1998                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3B7:
	CALL SUBOPT_0x12F
	MOV  R0,R30
	CALL SUBOPT_0x10E
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3BA
; 0000 1999                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x130
	CALL SUBOPT_0xCD
; 0000 199A 
; 0000 199B                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3BA:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x131
	AND  R30,R0
	BREQ _0x3BB
; 0000 199C                        {
; 0000 199D                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x132
; 0000 199E                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 199F                        }
; 0000 19A0                    //////////////////////////////////////////////
; 0000 19A1 
; 0000 19A2                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3BB:
; 0000 19A3                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 19A4                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 19A5                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0 &  wykonalem_komplet_okregow == 3)
	CALL SUBOPT_0x95
	CALL SUBOPT_0x133
	CALL SUBOPT_0x125
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x134
	CALL SUBOPT_0x135
	CALL SUBOPT_0x110
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x136
	BREQ _0x3BE
; 0000 19A6                         {
; 0000 19A7                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x12B
; 0000 19A8                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x132
; 0000 19A9                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 19AA                         cykl_sterownik_2 = 0;
; 0000 19AB                         cykl_sterownik_3 = 0;
; 0000 19AC                         cykl_sterownik_4 = 0;
; 0000 19AD                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x137
; 0000 19AE                         krazek_scierny_cykl = 0;
; 0000 19AF                         krazek_scierny_cykl_po_okregu = 0;
; 0000 19B0                         wykonalem_komplet_okregow = 0;
; 0000 19B1                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 19B2                         //PORTF = PORT_F.byte;
; 0000 19B3                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 19B4                         cykl_glowny = 9;
; 0000 19B5                         }
; 0000 19B6 
; 0000 19B7  }
_0x3BE:
	RET
;
;
;
;void przypadek997()
; 0000 19BC 
; 0000 19BD {
_przypadek997:
; 0000 19BE 
; 0000 19BF            if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF9
	BRGE _0x3C1
; 0000 19C0                         {
; 0000 19C1                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xFA
; 0000 19C2                         PORTF = PORT_F.byte;
; 0000 19C3                         }
; 0000 19C4 
; 0000 19C5 
; 0000 19C6                      if(rzad_obrabiany == 2)
_0x3C1:
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x3C2
; 0000 19C7                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 19C8 
; 0000 19C9                     if(koniec_rzedu_10 == 1)
_0x3C2:
	CALL SUBOPT_0xFB
	BRNE _0x3C3
; 0000 19CA                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xFC
; 0000 19CB                                                               //to nowy war, ostatni dzien w borg
; 0000 19CC                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3C3:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x10F
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x110
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x111
	BREQ _0x3C4
; 0000 19CD                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x74
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xCD
; 0000 19CE 
; 0000 19CF                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3C4:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x112
	CALL SUBOPT_0x138
	CALL SUBOPT_0xAD
	BREQ _0x3C5
; 0000 19D0                         {
; 0000 19D1                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x115
	BRNE _0x3C6
; 0000 19D2                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 19D3                         if(abs_ster4 == 0)
_0x3C6:
	CALL SUBOPT_0x117
	BRNE _0x3C7
; 0000 19D4                             {
; 0000 19D5                             szczotka_druc_cykl++;
	CALL SUBOPT_0x13C
; 0000 19D6                             //////////////////////
; 0000 19D7                             if(statystyka == 1)
	CALL SUBOPT_0x13D
	BRNE _0x3C8
; 0000 19D8                                 {
; 0000 19D9                                 wartosc_parametru_panelu(szczotka_druc_cykl,96,128);
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x9D
	CALL _wartosc_parametru_panelu
; 0000 19DA                                 wartosc_parametru_panelu(cykl_ilosc_zaciskow,128,80);  //pamietac ze zmienna cykl tak naprawde dodaje sie dalej w programie, czyli jak tu bedzie 7 to znaczy ze jestesmy na dolku 8
	CALL SUBOPT_0x13F
	CALL SUBOPT_0x140
	CALL SUBOPT_0x21
	CALL _wartosc_parametru_panelu
; 0000 19DB                                 }
; 0000 19DC                             //////////////////////////
; 0000 19DD                             abs_ster4 = 1;
_0x3C8:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R31
; 0000 19DE                             }
; 0000 19DF                        else
	RJMP _0x3C9
_0x3C7:
; 0000 19E0                             {
; 0000 19E1                             abs_ster4 = 0;
	CALL SUBOPT_0x119
; 0000 19E2                             sek13 = 0;
; 0000 19E3                             }
_0x3C9:
; 0000 19E4                         }
; 0000 19E5 
; 0000 19E6                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3C5:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11B
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x11C
	BREQ _0x3CA
; 0000 19E7                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x7B
	CALL SUBOPT_0xD8
; 0000 19E8 
; 0000 19E9 
; 0000 19EA                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3CA:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x13A
	BREQ _0x3CB
; 0000 19EB                         {
; 0000 19EC                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 19ED                         if(abs_ster3 == 0)
	CALL SUBOPT_0x121
	BRNE _0x3CC
; 0000 19EE                             {
; 0000 19EF                             krazek_scierny_cykl++;
	CALL SUBOPT_0x141
; 0000 19F0                             //////////////////////
; 0000 19F1                             if(statystyka == 1)
	CALL SUBOPT_0x13D
	BRNE _0x3CD
; 0000 19F2                                 wartosc_parametru_panelu(krazek_scierny_cykl,128,96);
	CALL SUBOPT_0x142
	CALL SUBOPT_0x22
	CALL _wartosc_parametru_panelu
; 0000 19F3                             //////////////////////////
; 0000 19F4                             abs_ster3 = 1;
_0x3CD:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R31
; 0000 19F5                             }
; 0000 19F6                         else
	RJMP _0x3CE
_0x3CC:
; 0000 19F7                             abs_ster3 = 0;
	CALL SUBOPT_0x123
; 0000 19F8                         }
_0x3CE:
; 0000 19F9 
; 0000 19FA                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3CB:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11B
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x3CF
; 0000 19FB                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x70
	CALL SUBOPT_0xD8
; 0000 19FC 
; 0000 19FD 
; 0000 19FE                      if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x3CF:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x10F
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x110
	CALL SUBOPT_0xAD
	BREQ _0x3D0
; 0000 19FF                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory kawaleczek
	CALL SUBOPT_0x124
	CALL SUBOPT_0xCD
; 0000 1A00 
; 0000 1A01                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1A02 
; 0000 1A03                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonano_powrot_przedwczesny_krazek_scierny == 0)
_0x3D0:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x125
	CALL SUBOPT_0x95
	CALL SUBOPT_0x143
	AND  R0,R30
	LDS  R26,_wykonano_powrot_przedwczesny_krazek_scierny
	LDS  R27,_wykonano_powrot_przedwczesny_krazek_scierny+1
	CALL SUBOPT_0xAD
	BREQ _0x3D1
; 0000 1A04                        {
; 0000 1A05                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 1A06                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x127
; 0000 1A07                        //////////////////////
; 0000 1A08                        if(statystyka == 1)
	CALL SUBOPT_0x13D
	BRNE _0x3D2
; 0000 1A09                             wartosc_parametru_panelu(powrot_przedwczesny_krazek_scierny,128,112);
	CALL SUBOPT_0x144
	CALL SUBOPT_0x9B
; 0000 1A0A                        //////////////////////////
; 0000 1A0B                        }
_0x3D2:
; 0000 1A0C                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x3D1:
	CALL SUBOPT_0x128
	MOV  R0,R30
	CALL SUBOPT_0x11A
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3D3
; 0000 1A0D                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x129
; 0000 1A0E 
; 0000 1A0F                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x3D3:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x12A
	AND  R30,R0
	BREQ _0x3D4
; 0000 1A10                        {
; 0000 1A11                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x12B
; 0000 1A12                        wykonano_powrot_przedwczesny_krazek_scierny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonano_powrot_przedwczesny_krazek_scierny,R30
	STS  _wykonano_powrot_przedwczesny_krazek_scierny+1,R31
; 0000 1A13                        //////////////////////
; 0000 1A14                        if(statystyka == 1)
	CALL SUBOPT_0x13D
	BRNE _0x3D5
; 0000 1A15                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_krazek_scierny,128,128);
	CALL SUBOPT_0x145
	CALL SUBOPT_0x9D
	CALL _wartosc_parametru_panelu
; 0000 1A16                        //////////////////////////
; 0000 1A17                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
_0x3D5:
	CBI  0x3,3
; 0000 1A18                        }
; 0000 1A19                    //////////////////////////////////////////////
; 0000 1A1A 
; 0000 1A1B 
; 0000 1A1C 
; 0000 1A1D                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1A1E 
; 0000 1A1F                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli & wykonano_powrot_przedwczesny_druciak == 0)
_0x3D4:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x112
	CALL SUBOPT_0x12C
	CALL SUBOPT_0x146
	AND  R0,R30
	LDS  R26,_wykonano_powrot_przedwczesny_druciak
	LDS  R27,_wykonano_powrot_przedwczesny_druciak+1
	CALL SUBOPT_0xAD
	BREQ _0x3D8
; 0000 1A20                        {
; 0000 1A21                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1A22                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1A23                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x12E
; 0000 1A24                        //////////////////////
; 0000 1A25                        if(statystyka == 1)
	CALL SUBOPT_0x13D
	BRNE _0x3DB
; 0000 1A26                             wartosc_parametru_panelu(powrot_przedwczesny_druciak,96,144);
	CALL SUBOPT_0x147
	CALL SUBOPT_0x9A
; 0000 1A27                        //////////////////////////
; 0000 1A28                        }
_0x3DB:
; 0000 1A29                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3D8:
	CALL SUBOPT_0x12F
	MOV  R0,R30
	CALL SUBOPT_0x10E
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3DC
; 0000 1A2A                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x130
	CALL SUBOPT_0xCD
; 0000 1A2B 
; 0000 1A2C                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3DC:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x131
	AND  R30,R0
	BREQ _0x3DD
; 0000 1A2D                        {
; 0000 1A2E                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x132
; 0000 1A2F                        wykonano_powrot_przedwczesny_druciak = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonano_powrot_przedwczesny_druciak,R30
	STS  _wykonano_powrot_przedwczesny_druciak+1,R31
; 0000 1A30                        ///////////////////////////////
; 0000 1A31                        if(statystyka == 1)
	CALL SUBOPT_0x13D
	BRNE _0x3DE
; 0000 1A32                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_druciak,112,0);
	CALL SUBOPT_0x148
	CALL _wartosc_parametru_panelu
; 0000 1A33                        //////////////////////////////
; 0000 1A34                        PORTE.2 = 0;  //wylacz szlifierke
_0x3DE:
	CBI  0x3,2
; 0000 1A35                        }
; 0000 1A36                    ///////////////////////////////////////////////////////////////////////
; 0000 1A37 
; 0000 1A38                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3DD:
; 0000 1A39                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1A3A                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1A3B                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0)
	CALL SUBOPT_0x95
	CALL SUBOPT_0x133
	CALL SUBOPT_0x125
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x134
	CALL SUBOPT_0x135
	CALL SUBOPT_0x110
	CALL SUBOPT_0xAD
	BREQ _0x3E1
; 0000 1A3C                         {
; 0000 1A3D                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x12B
; 0000 1A3E                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x132
; 0000 1A3F                         wykonano_powrot_przedwczesny_krazek_scierny = 0;
	LDI  R30,LOW(0)
	STS  _wykonano_powrot_przedwczesny_krazek_scierny,R30
	STS  _wykonano_powrot_przedwczesny_krazek_scierny+1,R30
; 0000 1A40                         wykonano_powrot_przedwczesny_druciak = 0;
	STS  _wykonano_powrot_przedwczesny_druciak,R30
	STS  _wykonano_powrot_przedwczesny_druciak+1,R30
; 0000 1A41                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1A42                         cykl_sterownik_2 = 0;
; 0000 1A43                         cykl_sterownik_3 = 0;
; 0000 1A44                         cykl_sterownik_4 = 0;
; 0000 1A45                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x149
; 0000 1A46                         krazek_scierny_cykl = 0;
; 0000 1A47                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1A48                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1A49                         //PORTF = PORT_F.byte;
; 0000 1A4A                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1A4B 
; 0000 1A4C                         if(statystyka == 1)
	CALL SUBOPT_0x13D
	BRNE _0x3E4
; 0000 1A4D                             {
; 0000 1A4E                             wartosc_parametru_panelu(szczotka_druc_cykl,96,128);
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x9D
	CALL _wartosc_parametru_panelu
; 0000 1A4F                             wartosc_parametru_panelu(krazek_scierny_cykl,128,96);
	CALL SUBOPT_0x142
	CALL SUBOPT_0x22
	CALL _wartosc_parametru_panelu
; 0000 1A50                             wartosc_parametru_panelu(powrot_przedwczesny_druciak,96,144);
	CALL SUBOPT_0x147
	CALL SUBOPT_0x9A
; 0000 1A51                             wartosc_parametru_panelu(powrot_przedwczesny_krazek_scierny,128,112);
	CALL SUBOPT_0x144
	CALL SUBOPT_0x9B
; 0000 1A52                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_druciak,112,0);
	CALL SUBOPT_0x148
	CALL _wartosc_parametru_panelu
; 0000 1A53                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_krazek_scierny,128,128);
	CALL SUBOPT_0x145
	CALL SUBOPT_0x9D
	CALL _wartosc_parametru_panelu
; 0000 1A54                             }
; 0000 1A55                         cykl_glowny = 9;
_0x3E4:
	CALL SUBOPT_0x14A
; 0000 1A56                         }
; 0000 1A57 
; 0000 1A58 }
_0x3E1:
	RET
;
;void przypadek998()
; 0000 1A5B {
_przypadek998:
; 0000 1A5C 
; 0000 1A5D            if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF9
	BRGE _0x3E5
; 0000 1A5E                         {
; 0000 1A5F                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xFA
; 0000 1A60                         PORTF = PORT_F.byte;
; 0000 1A61                         }
; 0000 1A62 
; 0000 1A63 
; 0000 1A64                      if(rzad_obrabiany == 2)
_0x3E5:
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x3E6
; 0000 1A65                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1A66 
; 0000 1A67                     if(koniec_rzedu_10 == 1)
_0x3E6:
	CALL SUBOPT_0xFB
	BRNE _0x3E7
; 0000 1A68                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xFC
; 0000 1A69 
; 0000 1A6A                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3E7:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x10F
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x110
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x111
	BREQ _0x3E8
; 0000 1A6B                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x74
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xCD
; 0000 1A6C 
; 0000 1A6D                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3E8:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x112
	CALL SUBOPT_0x138
	CALL SUBOPT_0xAD
	BREQ _0x3E9
; 0000 1A6E                         {
; 0000 1A6F                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x115
	BRNE _0x3EA
; 0000 1A70                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1A71                         if(abs_ster4 == 0)
_0x3EA:
	CALL SUBOPT_0x117
	BRNE _0x3EB
; 0000 1A72                             {
; 0000 1A73                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x73
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3EC
; 0000 1A74                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1A75                             szczotka_druc_cykl++;
_0x3EC:
	CALL SUBOPT_0x118
; 0000 1A76                             abs_ster4 = 1;
; 0000 1A77                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x95
	CALL SUBOPT_0x139
	BRNE _0x3EF
; 0000 1A78                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0xFC
; 0000 1A79                             }
_0x3EF:
; 0000 1A7A                         else
	RJMP _0x3F0
_0x3EB:
; 0000 1A7B                             {
; 0000 1A7C                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1A7D                             abs_ster4 = 0;
	CALL SUBOPT_0x119
; 0000 1A7E                             sek13 = 0;
; 0000 1A7F                             }
_0x3F0:
; 0000 1A80                         }
; 0000 1A81 
; 0000 1A82                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3E9:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11B
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x11C
	BREQ _0x3F3
; 0000 1A83                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x7B
	CALL SUBOPT_0xD8
; 0000 1A84 
; 0000 1A85 
; 0000 1A86                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3F3:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x13A
	BREQ _0x3F4
; 0000 1A87                         {
; 0000 1A88                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 1A89                         if(abs_ster3 == 0)
	CALL SUBOPT_0x121
	BRNE _0x3F5
; 0000 1A8A                             {
; 0000 1A8B                             krazek_scierny_cykl++;
	CALL SUBOPT_0x122
; 0000 1A8C 
; 0000 1A8D                             abs_ster3 = 1;
; 0000 1A8E                             }
; 0000 1A8F                         else
	RJMP _0x3F6
_0x3F5:
; 0000 1A90                             abs_ster3 = 0;
	CALL SUBOPT_0x123
; 0000 1A91                         }
_0x3F6:
; 0000 1A92 
; 0000 1A93                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3F4:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11B
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x3F7
; 0000 1A94                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x70
	CALL SUBOPT_0xD8
; 0000 1A95 
; 0000 1A96                        if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x3F7:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x10F
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x110
	CALL SUBOPT_0xAD
	BREQ _0x3F8
; 0000 1A97                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x77
	CALL SUBOPT_0x13B
	CALL SUBOPT_0xCD
; 0000 1A98 
; 0000 1A99 
; 0000 1A9A 
; 0000 1A9B                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1A9C 
; 0000 1A9D                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x3F8:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x125
	CALL SUBOPT_0x95
	CALL SUBOPT_0x143
	AND  R30,R0
	BREQ _0x3F9
; 0000 1A9E                        {
; 0000 1A9F                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 1AA0                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x127
; 0000 1AA1                        }
; 0000 1AA2                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x3F9:
	CALL SUBOPT_0x128
	MOV  R0,R30
	CALL SUBOPT_0x11A
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3FA
; 0000 1AA3                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x129
; 0000 1AA4 
; 0000 1AA5                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x3FA:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x12A
	AND  R30,R0
	BREQ _0x3FB
; 0000 1AA6                        {
; 0000 1AA7                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x12B
; 0000 1AA8                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1AA9                        }
; 0000 1AAA                    //////////////////////////////////////////////
; 0000 1AAB 
; 0000 1AAC 
; 0000 1AAD 
; 0000 1AAE                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1AAF 
; 0000 1AB0                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x3FB:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x112
	CALL SUBOPT_0x12C
	CALL SUBOPT_0x12D
	BREQ _0x3FE
; 0000 1AB1                        {
; 0000 1AB2                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1AB3                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1AB4                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x12E
; 0000 1AB5                        }
; 0000 1AB6                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3FE:
	CALL SUBOPT_0x12F
	MOV  R0,R30
	CALL SUBOPT_0x10E
	CALL __LTW12
	AND  R30,R0
	BREQ _0x401
; 0000 1AB7                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x130
	CALL SUBOPT_0xCD
; 0000 1AB8 
; 0000 1AB9                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x401:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x131
	AND  R30,R0
	BREQ _0x402
; 0000 1ABA                        {
; 0000 1ABB                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x132
; 0000 1ABC                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1ABD                        }
; 0000 1ABE                    //////////////////////////////////////////////
; 0000 1ABF 
; 0000 1AC0                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x402:
; 0000 1AC1                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1AC2                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1AC3                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0)
	CALL SUBOPT_0x95
	CALL SUBOPT_0x133
	CALL SUBOPT_0x125
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x134
	CALL SUBOPT_0x135
	CALL SUBOPT_0x110
	CALL SUBOPT_0xAD
	BREQ _0x405
; 0000 1AC4                         {
; 0000 1AC5                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x12B
; 0000 1AC6                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x132
; 0000 1AC7                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1AC8                         cykl_sterownik_2 = 0;
; 0000 1AC9                         cykl_sterownik_3 = 0;
; 0000 1ACA                         cykl_sterownik_4 = 0;
; 0000 1ACB                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x149
; 0000 1ACC                         krazek_scierny_cykl = 0;
; 0000 1ACD                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1ACE                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1ACF                         //PORTF = PORT_F.byte;
; 0000 1AD0                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1AD1                         cykl_glowny = 9;
	CALL SUBOPT_0x14A
; 0000 1AD2                         }
; 0000 1AD3 }
_0x405:
	RET
;
;
;void przypadek8()
; 0000 1AD7 
; 0000 1AD8 {
_przypadek8:
; 0000 1AD9 
; 0000 1ADA                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF9
	BRGE _0x408
; 0000 1ADB                         {
; 0000 1ADC                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xFA
; 0000 1ADD                         PORTF = PORT_F.byte;
; 0000 1ADE                         }
; 0000 1ADF 
; 0000 1AE0 
; 0000 1AE1                      if(rzad_obrabiany == 2)
_0x408:
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x409
; 0000 1AE2                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1AE3 
; 0000 1AE4 
; 0000 1AE5 
; 0000 1AE6                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x409:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0xFE
	MOVW R26,R30
	CALL SUBOPT_0xE4
	CALL SUBOPT_0xFF
	BREQ _0x40A
; 0000 1AE7                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x71
	CALL SUBOPT_0x100
; 0000 1AE8                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x40A:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x101
	BREQ _0x40B
; 0000 1AE9                         {
; 0000 1AEA                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1AEB                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x103
; 0000 1AEC                         }
; 0000 1AED 
; 0000 1AEE 
; 0000 1AEF                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x40B:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0xFE
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x40C
; 0000 1AF0                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x105
; 0000 1AF1 
; 0000 1AF2                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x40C:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x106
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x40D
; 0000 1AF3                         {
; 0000 1AF4                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1AF5                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x107
; 0000 1AF6                         }
; 0000 1AF7 
; 0000 1AF8                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x40D:
	CALL SUBOPT_0x78
	CALL SUBOPT_0x108
	AND  R30,R0
	BREQ _0x40E
; 0000 1AF9                         {
; 0000 1AFA                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1AFB                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x109
; 0000 1AFC                         }
; 0000 1AFD 
; 0000 1AFE                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1AFF                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x40E:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x10A
	AND  R30,R0
	BREQ _0x40F
; 0000 1B00                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x10B
; 0000 1B01 
; 0000 1B02 
; 0000 1B03                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x40F:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x10C
	AND  R30,R0
	BREQ _0x410
; 0000 1B04                         {
; 0000 1B05                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1B06                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x10D
; 0000 1B07                         }
; 0000 1B08 
; 0000 1B09                     if(cykl_sterownik_3 < 5 & wykonalem_komplet_okregow == 3)
_0x410:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x14B
	BREQ _0x411
; 0000 1B0A                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV         //tu zmienienie INV, ¿eby szed³ w dol
	CALL SUBOPT_0x7B
	CALL SUBOPT_0xD8
; 0000 1B0B 
; 0000 1B0C                      if(cykl_sterownik_3 == 5 & wykonalem_komplet_okregow == 3)
_0x411:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x14C
	BREQ _0x412
; 0000 1B0D                         {
; 0000 1B0E                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x14D
; 0000 1B0F                         krazek_scierny_cykl++;
; 0000 1B10 
; 0000 1B11                         if(krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x98
	CALL SUBOPT_0x11E
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x413
; 0000 1B12                             {
; 0000 1B13                             wykonalem_komplet_okregow = 4;
	CALL SUBOPT_0x14E
; 0000 1B14                             }
; 0000 1B15                         else
	RJMP _0x414
_0x413:
; 0000 1B16                             wykonalem_komplet_okregow = 0;
	CALL SUBOPT_0x14F
; 0000 1B17 
; 0000 1B18                         cykl_sterownik_1 = 0;
_0x414:
	CALL SUBOPT_0x102
; 0000 1B19                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 1B1A                         }
; 0000 1B1B 
; 0000 1B1C 
; 0000 1B1D 
; 0000 1B1E 
; 0000 1B1F 
; 0000 1B20                     if(koniec_rzedu_10 == 1)
_0x412:
	CALL SUBOPT_0xFB
	BRNE _0x415
; 0000 1B21                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xFC
; 0000 1B22                                                               //to nowy war, ostatni dzien w borg
; 0000 1B23                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze & koniec_rzedu_10 == 0)
_0x415:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x10F
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x110
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x150
	BREQ _0x416
; 0000 1B24                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x74
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xCD
; 0000 1B25 
; 0000 1B26                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x416:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x112
	CALL SUBOPT_0x138
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x151
	BREQ _0x417
; 0000 1B27                         {
; 0000 1B28                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x115
	BRNE _0x418
; 0000 1B29                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1B2A                         if(abs_ster4 == 0)
_0x418:
	CALL SUBOPT_0x117
	BRNE _0x419
; 0000 1B2B                             {
; 0000 1B2C                             szczotka_druc_cykl++;
	CALL SUBOPT_0x118
; 0000 1B2D                             abs_ster4 = 1;
; 0000 1B2E                             }
; 0000 1B2F                         else
	RJMP _0x41A
_0x419:
; 0000 1B30                             {
; 0000 1B31                             abs_ster4 = 0;
	CALL SUBOPT_0x119
; 0000 1B32                             sek13 = 0;
; 0000 1B33                             }
_0x41A:
; 0000 1B34                         }
; 0000 1B35 
; 0000 1B36 
; 0000 1B37                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x417:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x10F
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x110
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x151
	BREQ _0x41B
; 0000 1B38                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory
	CALL SUBOPT_0x124
	CALL SUBOPT_0xCD
; 0000 1B39 
; 0000 1B3A 
; 0000 1B3B                         ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1B3C 
; 0000 1B3D                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x41B:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x125
	CALL SUBOPT_0x95
	CALL SUBOPT_0x143
	AND  R30,R0
	BREQ _0x41C
; 0000 1B3E                        {
; 0000 1B3F                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 1B40                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x127
; 0000 1B41                        }
; 0000 1B42                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x41C:
	CALL SUBOPT_0x128
	MOV  R0,R30
	CALL SUBOPT_0x11A
	CALL __LTW12
	AND  R30,R0
	BREQ _0x41D
; 0000 1B43                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x129
; 0000 1B44 
; 0000 1B45                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x41D:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x12A
	AND  R30,R0
	BREQ _0x41E
; 0000 1B46                        {
; 0000 1B47                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x12B
; 0000 1B48                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1B49                        }
; 0000 1B4A                    //////////////////////////////////////////////
; 0000 1B4B 
; 0000 1B4C 
; 0000 1B4D 
; 0000 1B4E                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1B4F 
; 0000 1B50                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
_0x41E:
	CALL SUBOPT_0x152
	MOV  R0,R30
	CALL SUBOPT_0x10E
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x95
	CALL SUBOPT_0x153
	CALL SUBOPT_0x146
	OR   R30,R0
	AND  R30,R1
	BREQ _0x421
; 0000 1B51                        {
; 0000 1B52                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1B53                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1B54                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x12E
; 0000 1B55                        }
; 0000 1B56                   if(koniec_rzedu_10 == 0 & powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x421:
	CALL SUBOPT_0x152
	MOV  R0,R30
	CALL SUBOPT_0x12F
	AND  R0,R30
	CALL SUBOPT_0x10E
	CALL __LTW12
	AND  R30,R0
	BREQ _0x424
; 0000 1B57                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x130
	CALL SUBOPT_0xCD
; 0000 1B58 
; 0000 1B59                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x424:
	CALL SUBOPT_0x152
	MOV  R0,R30
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x154
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x425
; 0000 1B5A                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x132
; 0000 1B5B                    //////////////////////////////////////////////
; 0000 1B5C 
; 0000 1B5D                     if((wykonalem_komplet_okregow == 4 &
_0x425:
; 0000 1B5E                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 1B5F                         cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0 & powrot_przedwczesny_krazek_scierny == 0) | (wykonalem_komplet_okregow == 4 & koniec_rzedu_10 == 1 & powrot_przedwczesny_krazek_scierny == 0) )
	CALL SUBOPT_0x155
	CALL SUBOPT_0x113
	CALL SUBOPT_0x134
	CALL SUBOPT_0x154
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x11C
	CALL SUBOPT_0x156
	CALL SUBOPT_0x11C
	OR   R30,R1
	BREQ _0x426
; 0000 1B60                         {
; 0000 1B61                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x132
; 0000 1B62                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x12B
; 0000 1B63                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1B64                         cykl_sterownik_2 = 0;
; 0000 1B65                         cykl_sterownik_3 = 0;
; 0000 1B66                         cykl_sterownik_4 = 0;
; 0000 1B67                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x149
; 0000 1B68                         krazek_scierny_cykl = 0;
; 0000 1B69                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1B6A                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1B6B                         //PORTF = PORT_F.byte;
; 0000 1B6C                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1B6D                         cykl_glowny = 9;
	CALL SUBOPT_0x14A
; 0000 1B6E                         }
; 0000 1B6F }
_0x426:
	RET
;                                                                                                //ster 1 - ruch po okregu
;                                                                                                //ster 2 - nic
;                                                                                                //ster 3 - krazek - gora dol
;                                                                                                //ster 4 - druciak - gora dol
;
;
;void przypadek88()
; 0000 1B77 {
_przypadek88:
; 0000 1B78 
; 0000 1B79                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF9
	BRGE _0x429
; 0000 1B7A                         {
; 0000 1B7B                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xFA
; 0000 1B7C                         PORTF = PORT_F.byte;
; 0000 1B7D                         }
; 0000 1B7E 
; 0000 1B7F 
; 0000 1B80                      if(rzad_obrabiany == 2)
_0x429:
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x42A
; 0000 1B81                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1B82 
; 0000 1B83 
; 0000 1B84 
; 0000 1B85                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x42A:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0xFE
	MOVW R26,R30
	CALL SUBOPT_0xE4
	CALL SUBOPT_0xFF
	BREQ _0x42B
; 0000 1B86                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x71
	CALL SUBOPT_0x100
; 0000 1B87                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x42B:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x101
	BREQ _0x42C
; 0000 1B88                         {
; 0000 1B89                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1B8A                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x103
; 0000 1B8B                         }
; 0000 1B8C 
; 0000 1B8D 
; 0000 1B8E                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x42C:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0xFE
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x42D
; 0000 1B8F                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x105
; 0000 1B90 
; 0000 1B91                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x42D:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x106
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x42E
; 0000 1B92                         {
; 0000 1B93                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1B94                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x107
; 0000 1B95                         }
; 0000 1B96 
; 0000 1B97                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x42E:
	CALL SUBOPT_0x78
	CALL SUBOPT_0x108
	AND  R30,R0
	BREQ _0x42F
; 0000 1B98                         {
; 0000 1B99                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1B9A                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x109
; 0000 1B9B                         }
; 0000 1B9C 
; 0000 1B9D                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1B9E                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x42F:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x10A
	AND  R30,R0
	BREQ _0x430
; 0000 1B9F                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x10B
; 0000 1BA0 
; 0000 1BA1 
; 0000 1BA2                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x430:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x10C
	AND  R30,R0
	BREQ _0x431
; 0000 1BA3                         {
; 0000 1BA4                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1BA5                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x10D
; 0000 1BA6                         }
; 0000 1BA7 
; 0000 1BA8                     if(cykl_sterownik_3 < 5 & wykonalem_komplet_okregow == 3)
_0x431:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x14B
	BREQ _0x432
; 0000 1BA9                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV         //tu zmienienie INV, ¿eby szed³ w dol
	CALL SUBOPT_0x7B
	CALL SUBOPT_0xD8
; 0000 1BAA 
; 0000 1BAB                      if(cykl_sterownik_3 == 5 & wykonalem_komplet_okregow == 3)
_0x432:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x14C
	BREQ _0x433
; 0000 1BAC                         {
; 0000 1BAD                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x14D
; 0000 1BAE                         krazek_scierny_cykl++;
; 0000 1BAF 
; 0000 1BB0                         if(krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x98
	CALL SUBOPT_0x11E
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x434
; 0000 1BB1                             {
; 0000 1BB2                             wykonalem_komplet_okregow = 4;
	CALL SUBOPT_0x14E
; 0000 1BB3                             }
; 0000 1BB4                         else
	RJMP _0x435
_0x434:
; 0000 1BB5                             wykonalem_komplet_okregow = 0;
	CALL SUBOPT_0x14F
; 0000 1BB6 
; 0000 1BB7                         cykl_sterownik_1 = 0;
_0x435:
	CALL SUBOPT_0x102
; 0000 1BB8                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 1BB9                         }
; 0000 1BBA 
; 0000 1BBB 
; 0000 1BBC 
; 0000 1BBD 
; 0000 1BBE 
; 0000 1BBF                     if(koniec_rzedu_10 == 1)
_0x433:
	CALL SUBOPT_0xFB
	BRNE _0x436
; 0000 1BC0                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xFC
; 0000 1BC1                                                               //to nowy war, ostatni dzien w borg
; 0000 1BC2                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze & koniec_rzedu_10 == 0)
_0x436:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x10F
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x110
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x150
	BREQ _0x437
; 0000 1BC3                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x74
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xCD
; 0000 1BC4 
; 0000 1BC5                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x437:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x112
	CALL SUBOPT_0x138
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x151
	BREQ _0x438
; 0000 1BC6                         {
; 0000 1BC7                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x115
	BRNE _0x439
; 0000 1BC8                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1BC9                         if(abs_ster4 == 0)
_0x439:
	CALL SUBOPT_0x117
	BRNE _0x43A
; 0000 1BCA                             {
; 0000 1BCB                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x73
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x43B
; 0000 1BCC                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1BCD                             szczotka_druc_cykl++;
_0x43B:
	CALL SUBOPT_0x118
; 0000 1BCE                             abs_ster4 = 1;
; 0000 1BCF                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x95
	CALL SUBOPT_0x139
	BRNE _0x43E
; 0000 1BD0                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0xFC
; 0000 1BD1                             }
_0x43E:
; 0000 1BD2                          else
	RJMP _0x43F
_0x43A:
; 0000 1BD3                             {
; 0000 1BD4                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1BD5                             abs_ster4 = 0;
	CALL SUBOPT_0x119
; 0000 1BD6                             sek13 = 0;
; 0000 1BD7                             }
_0x43F:
; 0000 1BD8                         }
; 0000 1BD9 
; 0000 1BDA 
; 0000 1BDB 
; 0000 1BDC                         if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x438:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x10F
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x110
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x151
	BREQ _0x442
; 0000 1BDD                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x77
	CALL SUBOPT_0x13B
	CALL SUBOPT_0xCD
; 0000 1BDE 
; 0000 1BDF                         ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1BE0 
; 0000 1BE1                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x442:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x125
	CALL SUBOPT_0x95
	CALL SUBOPT_0x143
	AND  R30,R0
	BREQ _0x443
; 0000 1BE2                        {
; 0000 1BE3                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 1BE4                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x127
; 0000 1BE5                        }
; 0000 1BE6                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x443:
	CALL SUBOPT_0x128
	MOV  R0,R30
	CALL SUBOPT_0x11A
	CALL __LTW12
	AND  R30,R0
	BREQ _0x444
; 0000 1BE7                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x129
; 0000 1BE8 
; 0000 1BE9                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x444:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x12A
	AND  R30,R0
	BREQ _0x445
; 0000 1BEA                        {
; 0000 1BEB                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x12B
; 0000 1BEC                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1BED                        }
; 0000 1BEE                    //////////////////////////////////////////////
; 0000 1BEF 
; 0000 1BF0 
; 0000 1BF1 
; 0000 1BF2                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1BF3 
; 0000 1BF4                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
_0x445:
	CALL SUBOPT_0x152
	MOV  R0,R30
	CALL SUBOPT_0x10E
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x95
	CALL SUBOPT_0x153
	CALL SUBOPT_0x146
	OR   R30,R0
	AND  R30,R1
	BREQ _0x448
; 0000 1BF5                        {
; 0000 1BF6                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1BF7                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1BF8                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x12E
; 0000 1BF9                        }
; 0000 1BFA                   if(koniec_rzedu_10 == 0 & powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x448:
	CALL SUBOPT_0x152
	MOV  R0,R30
	CALL SUBOPT_0x12F
	AND  R0,R30
	CALL SUBOPT_0x10E
	CALL __LTW12
	AND  R30,R0
	BREQ _0x44B
; 0000 1BFB                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x130
	CALL SUBOPT_0xCD
; 0000 1BFC 
; 0000 1BFD                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x44B:
	CALL SUBOPT_0x152
	MOV  R0,R30
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x154
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x44C
; 0000 1BFE                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x132
; 0000 1BFF                    //////////////////////////////////////////////
; 0000 1C00 
; 0000 1C01                     if((wykonalem_komplet_okregow == 4 &
_0x44C:
; 0000 1C02                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 1C03                         cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0 & powrot_przedwczesny_krazek_scierny == 0) | (wykonalem_komplet_okregow == 4 & koniec_rzedu_10 == 1 & powrot_przedwczesny_krazek_scierny == 0) )
	CALL SUBOPT_0x155
	CALL SUBOPT_0x113
	CALL SUBOPT_0x134
	CALL SUBOPT_0x154
	CALL SUBOPT_0xC4
	CALL SUBOPT_0x11C
	CALL SUBOPT_0x156
	CALL SUBOPT_0x11C
	OR   R30,R1
	BREQ _0x44D
; 0000 1C04                         {
; 0000 1C05                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x132
; 0000 1C06                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x12B
; 0000 1C07                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1C08                         cykl_sterownik_2 = 0;
; 0000 1C09                         cykl_sterownik_3 = 0;
; 0000 1C0A                         cykl_sterownik_4 = 0;
; 0000 1C0B                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x149
; 0000 1C0C                         krazek_scierny_cykl = 0;
; 0000 1C0D                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1C0E                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1C0F                         //PORTF = PORT_F.byte;
; 0000 1C10                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1C11                         cykl_glowny = 9;
	CALL SUBOPT_0x14A
; 0000 1C12                         }
; 0000 1C13 
; 0000 1C14                                                                                                 //ster 1 - ruch po okregu
; 0000 1C15                                                                                                 //ster 2 - nic
; 0000 1C16                                                                                                 //ster 3 - krazek - gora dol
; 0000 1C17                                                                                                 //ster 4 - druciak - gora dol
; 0000 1C18 
; 0000 1C19 
; 0000 1C1A }
_0x44D:
	RET
;
;
;void main(void)
; 0000 1C1E {
_main:
; 0000 1C1F 
; 0000 1C20 // Input/Output Ports initialization
; 0000 1C21 // Port A initialization
; 0000 1C22 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1C23 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1C24 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 1C25 DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 1C26 
; 0000 1C27 // Port B initialization
; 0000 1C28 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1C29 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1C2A PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 1C2B DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 1C2C 
; 0000 1C2D // Port C initialization
; 0000 1C2E // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1C2F // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1C30 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 1C31 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 1C32 
; 0000 1C33 // Port D initialization
; 0000 1C34 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1C35 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1C36 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 1C37 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 1C38 
; 0000 1C39 // Port E initialization
; 0000 1C3A // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1C3B // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1C3C PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 1C3D DDRE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 1C3E 
; 0000 1C3F // Port F initialization
; 0000 1C40 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1C41 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1C42 PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 1C43 DDRF=0xFF;
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 1C44 
; 0000 1C45 // Port G initialization
; 0000 1C46 // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1C47 // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1C48 PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 1C49 DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 1C4A 
; 0000 1C4B 
; 0000 1C4C 
; 0000 1C4D 
; 0000 1C4E 
; 0000 1C4F // Timer/Counter 0 initialization
; 0000 1C50 // Clock source: System Clock
; 0000 1C51 // Clock value: 15,625 kHz
; 0000 1C52 // Mode: Normal top=0xFF
; 0000 1C53 // OC0 output: Disconnected
; 0000 1C54 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 1C55 TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 1C56 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 1C57 OCR0=0x00;
	OUT  0x31,R30
; 0000 1C58 
; 0000 1C59 // Timer/Counter 1 initialization
; 0000 1C5A // Clock source: System Clock
; 0000 1C5B // Clock value: Timer1 Stopped
; 0000 1C5C // Mode: Normal top=0xFFFF
; 0000 1C5D // OC1A output: Discon.
; 0000 1C5E // OC1B output: Discon.
; 0000 1C5F // OC1C output: Discon.
; 0000 1C60 // Noise Canceler: Off
; 0000 1C61 // Input Capture on Falling Edge
; 0000 1C62 // Timer1 Overflow Interrupt: Off
; 0000 1C63 // Input Capture Interrupt: Off
; 0000 1C64 // Compare A Match Interrupt: Off
; 0000 1C65 // Compare B Match Interrupt: Off
; 0000 1C66 // Compare C Match Interrupt: Off
; 0000 1C67 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 1C68 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 1C69 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 1C6A TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 1C6B ICR1H=0x00;
	OUT  0x27,R30
; 0000 1C6C ICR1L=0x00;
	OUT  0x26,R30
; 0000 1C6D OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 1C6E OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 1C6F OCR1BH=0x00;
	OUT  0x29,R30
; 0000 1C70 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 1C71 OCR1CH=0x00;
	STS  121,R30
; 0000 1C72 OCR1CL=0x00;
	STS  120,R30
; 0000 1C73 
; 0000 1C74 // Timer/Counter 2 initialization
; 0000 1C75 // Clock source: System Clock
; 0000 1C76 // Clock value: Timer2 Stopped
; 0000 1C77 // Mode: Normal top=0xFF
; 0000 1C78 // OC2 output: Disconnected
; 0000 1C79 TCCR2=0x00;
	OUT  0x25,R30
; 0000 1C7A TCNT2=0x00;
	OUT  0x24,R30
; 0000 1C7B OCR2=0x00;
	OUT  0x23,R30
; 0000 1C7C 
; 0000 1C7D // Timer/Counter 3 initialization
; 0000 1C7E // Clock source: System Clock
; 0000 1C7F // Clock value: Timer3 Stopped
; 0000 1C80 // Mode: Normal top=0xFFFF
; 0000 1C81 // OC3A output: Discon.
; 0000 1C82 // OC3B output: Discon.
; 0000 1C83 // OC3C output: Discon.
; 0000 1C84 // Noise Canceler: Off
; 0000 1C85 // Input Capture on Falling Edge
; 0000 1C86 // Timer3 Overflow Interrupt: Off
; 0000 1C87 // Input Capture Interrupt: Off
; 0000 1C88 // Compare A Match Interrupt: Off
; 0000 1C89 // Compare B Match Interrupt: Off
; 0000 1C8A // Compare C Match Interrupt: Off
; 0000 1C8B TCCR3A=0x00;
	STS  139,R30
; 0000 1C8C TCCR3B=0x00;
	STS  138,R30
; 0000 1C8D TCNT3H=0x00;
	STS  137,R30
; 0000 1C8E TCNT3L=0x00;
	STS  136,R30
; 0000 1C8F ICR3H=0x00;
	STS  129,R30
; 0000 1C90 ICR3L=0x00;
	STS  128,R30
; 0000 1C91 OCR3AH=0x00;
	STS  135,R30
; 0000 1C92 OCR3AL=0x00;
	STS  134,R30
; 0000 1C93 OCR3BH=0x00;
	STS  133,R30
; 0000 1C94 OCR3BL=0x00;
	STS  132,R30
; 0000 1C95 OCR3CH=0x00;
	STS  131,R30
; 0000 1C96 OCR3CL=0x00;
	STS  130,R30
; 0000 1C97 
; 0000 1C98 // External Interrupt(s) initialization
; 0000 1C99 // INT0: Off
; 0000 1C9A // INT1: Off
; 0000 1C9B // INT2: Off
; 0000 1C9C // INT3: Off
; 0000 1C9D // INT4: Off
; 0000 1C9E // INT5: Off
; 0000 1C9F // INT6: Off
; 0000 1CA0 // INT7: Off
; 0000 1CA1 EICRA=0x00;
	STS  106,R30
; 0000 1CA2 EICRB=0x00;
	OUT  0x3A,R30
; 0000 1CA3 EIMSK=0x00;
	OUT  0x39,R30
; 0000 1CA4 
; 0000 1CA5 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 1CA6 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 1CA7 
; 0000 1CA8 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 1CA9 
; 0000 1CAA 
; 0000 1CAB // USART0 initialization
; 0000 1CAC // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 1CAD // USART0 Receiver: On
; 0000 1CAE // USART0 Transmitter: On
; 0000 1CAF // USART0 Mode: Asynchronous
; 0000 1CB0 // USART0 Baud Rate: 115200
; 0000 1CB1 //UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
; 0000 1CB2 //UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
; 0000 1CB3 //UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
; 0000 1CB4 //UBRR0H=0x00;
; 0000 1CB5 //UBRR0L=0x08;
; 0000 1CB6 
; 0000 1CB7 // USART0 initialization
; 0000 1CB8 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 1CB9 // USART0 Receiver: On
; 0000 1CBA // USART0 Transmitter: On
; 0000 1CBB // USART0 Mode: Asynchronous
; 0000 1CBC // USART0 Baud Rate: 9600
; 0000 1CBD UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 1CBE UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 1CBF UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 1CC0 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 1CC1 UBRR0L=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 1CC2 
; 0000 1CC3 
; 0000 1CC4 
; 0000 1CC5 
; 0000 1CC6 
; 0000 1CC7 // USART1 initialization
; 0000 1CC8 // USART1 disabled
; 0000 1CC9 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 1CCA 
; 0000 1CCB // Analog Comparator initialization
; 0000 1CCC // Analog Comparator: Off
; 0000 1CCD // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 1CCE ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 1CCF SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 1CD0 
; 0000 1CD1 // ADC initialization
; 0000 1CD2 // ADC disabled
; 0000 1CD3 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 1CD4 
; 0000 1CD5 // SPI initialization
; 0000 1CD6 // SPI disabled
; 0000 1CD7 SPCR=0x00;
	OUT  0xD,R30
; 0000 1CD8 
; 0000 1CD9 // TWI initialization
; 0000 1CDA // TWI disabled
; 0000 1CDB TWCR=0x00;
	STS  116,R30
; 0000 1CDC 
; 0000 1CDD //ciekawe, tej linijki brakowalo w medalach ,wyczailem w borgu
; 0000 1CDE // I2C Bus initialization
; 0000 1CDF i2c_init();
	CALL _i2c_init
; 0000 1CE0 
; 0000 1CE1 // Global enable interrupts
; 0000 1CE2 #asm("sei")
	sei
; 0000 1CE3 
; 0000 1CE4 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x157
; 0000 1CE5 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x157
; 0000 1CE6 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x157
; 0000 1CE7 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x157
; 0000 1CE8 
; 0000 1CE9 //jak patrze na maszyne to ten po lewej to 1
; 0000 1CEA 
; 0000 1CEB putchar(90);  //5A
	CALL SUBOPT_0x3
; 0000 1CEC putchar(165); //A5
; 0000 1CED putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _putchar
; 0000 1CEE putchar(128);  //80
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _putchar
; 0000 1CEF putchar(2);    //02
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
; 0000 1CF0 putchar(16);   //10
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
; 0000 1CF1 
; 0000 1CF2 il_prob_odczytu = 1;    //100
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 1CF3 start = 0;
	CALL SUBOPT_0xAB
; 0000 1CF4 //szczotka_druciana_ilosc_cykli = 4; bo eeprom
; 0000 1CF5 //krazek_scierny_cykl_po_okregu_ilosc = 4;
; 0000 1CF6 //krazek_scierny_ilosc_cykli = 4;
; 0000 1CF7 rzad_obrabiany = 1;
	CALL SUBOPT_0x158
; 0000 1CF8 jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 1CF9 wykonalem_rzedow = 0;
	CALL SUBOPT_0x159
; 0000 1CFA cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x15A
; 0000 1CFB guzik1_przelaczania_zaciskow = 1;
	SET
	BLD  R2,0
; 0000 1CFC guzik2_przelaczania_zaciskow = 1;
	BLD  R2,1
; 0000 1CFD //PORTE.6 = 1;  //aby byl dostep do zaciskow rzad 1
; 0000 1CFE zmienna_przelaczanie_zaciskow = 1;
	BLD  R2,2
; 0000 1CFF czas_przedmuchu = 183;
	LDI  R30,LOW(183)
	LDI  R31,HIGH(183)
	STS  _czas_przedmuchu,R30
	STS  _czas_przedmuchu+1,R31
; 0000 1D00 predkosc_pion_szczotka = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 1D01 predkosc_pion_krazek = 100;
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 1D02 wejscie_krazka_sciernego_w_pow_boczna_cylindra = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 1D03 predkosc_ruchow_po_okregu_krazek_scierny = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 1D04 czas_druciaka_na_gorze = 100;  //1 sekundy dla druciaka na gorze aby dolek zrobil git (kiedyS), zmieniam na 3s
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _czas_druciaka_na_gorze,R30
	STS  _czas_druciaka_na_gorze+1,R31
; 0000 1D05 czas_zatrzymania_na_dole = 120;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	MOVW R12,R30
; 0000 1D06 //tryb_pracy_szczotki_drucianej = 1;
; 0000 1D07 
; 0000 1D08 adr1 = 80;  //rzad 1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STS  _adr1,R30
	STS  _adr1+1,R31
; 0000 1D09 adr2 = 0;   //
	LDI  R30,LOW(0)
	STS  _adr2,R30
	STS  _adr2+1,R30
; 0000 1D0A adr3 = 64;  //rzad 2
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STS  _adr3,R30
	STS  _adr3+1,R31
; 0000 1D0B adr4 = 0;
	LDI  R30,LOW(0)
	STS  _adr4,R30
	STS  _adr4+1,R30
; 0000 1D0C 
; 0000 1D0D //na sekunde
; 0000 1D0E 
; 0000 1D0F wartosci_wstepne_panelu();
	CALL _wartosci_wstepne_panelu
; 0000 1D10 
; 0000 1D11 /*
; 0000 1D12 while(1)
; 0000 1D13 {
; 0000 1D14 czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
; 0000 1D15 czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
; 0000 1D16 
; 0000 1D17 
; 0000 1D18 czas_pracy_szczotki_drucianej_h = 0;
; 0000 1D19 czas_pracy_krazka_sciernego_h_34 = 0;
; 0000 1D1A czas_pracy_krazka_sciernego_h_36 = 0;
; 0000 1D1B czas_pracy_krazka_sciernego_h_38 = 0;
; 0000 1D1C czas_pracy_krazka_sciernego_h_41 = 0;
; 0000 1D1D czas_pracy_krazka_sciernego_h_43 = 0;
; 0000 1D1E 
; 0000 1D1F while(1)
; 0000 1D20 {
; 0000 1D21 }
; 0000 1D22 
; 0000 1D23 
; 0000 1D24 czas_pracy_szczotki_drucianej_h = odczytaj_parametr(0,144);
; 0000 1D25 czas_pracy_krazka_sciernego_h_34 = odczytaj_parametr(96,48);
; 0000 1D26 czas_pracy_krazka_sciernego_h_36 = odczytaj_parametr(96,64);
; 0000 1D27 czas_pracy_krazka_sciernego_h_38 = odczytaj_parametr(96,80);
; 0000 1D28 czas_pracy_krazka_sciernego_h_41 = odczytaj_parametr(96,96);
; 0000 1D29 czas_pracy_krazka_sciernego_h_43 = odczytaj_parametr(96,112);
; 0000 1D2A 
; 0000 1D2B 
; 0000 1D2C 
; 0000 1D2D }
; 0000 1D2E */
; 0000 1D2F 
; 0000 1D30 wypozycjonuj_napedy_minimalistyczna();
	CALL _wypozycjonuj_napedy_minimalistyczna
; 0000 1D31 sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 1D32 
; 0000 1D33 //mniejsze ziarno na krazku - dobry pomysl
; 0000 1D34 
; 0000 1D35 
; 0000 1D36 while (1)
_0x450:
; 0000 1D37       {
; 0000 1D38       ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1D39       przerzucanie_dociskow();
	CALL _przerzucanie_dociskow
; 0000 1D3A       kontrola_zoltego_swiatla();
	CALL _kontrola_zoltego_swiatla
; 0000 1D3B       wymiana_szczotki_i_krazka();
	CALL _wymiana_szczotki_i_krazka
; 0000 1D3C       zaktualizuj_parametry_panelu();
	CALL _zaktualizuj_parametry_panelu
; 0000 1D3D       odpytaj_parametry_panelu();
	CALL _odpytaj_parametry_panelu
; 0000 1D3E       test_geometryczny();
	CALL _test_geometryczny
; 0000 1D3F       sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 1D40 
; 0000 1D41       while((start == 1 & il_zaciskow_rzad_1 > 1 & il_zaciskow_rzad_2 != 1 & macierz_zaciskow[1]!=0  & (macierz_zaciskow[2]!=0 |  il_zaciskow_rzad_2 == 0)) | jestem_w_trakcie_czyszczenia_calosci == 1)
_0x453:
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x7A
	MOV  R0,R30
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xE3
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	AND  R0,R30
	CALL SUBOPT_0xC7
	MOV  R1,R30
	CALL SUBOPT_0xE5
	MOV  R0,R30
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xC4
	OR   R30,R0
	AND  R30,R1
	MOV  R0,R30
	LDS  R26,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R27,_jestem_w_trakcie_czyszczenia_calosci+1
	CALL SUBOPT_0x7A
	OR   R30,R0
	BRNE PC+3
	JMP _0x455
; 0000 1D42             {
; 0000 1D43             switch (cykl_glowny)
	LDS  R30,_cykl_glowny
	LDS  R31,_cykl_glowny+1
; 0000 1D44             {
; 0000 1D45             case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x459
; 0000 1D46 
; 0000 1D47 
; 0000 1D48                     PORTB.6 = 1;   ////zielona lampka
	SBI  0x18,6
; 0000 1D49                     if(jestem_w_trakcie_czyszczenia_calosci == 0)
	LDS  R30,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R31,_jestem_w_trakcie_czyszczenia_calosci+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x45C
; 0000 1D4A                         {
; 0000 1D4B                         //PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1D4C 
; 0000 1D4D                         srednica_wew_korpusu_cyklowa = srednica_wew_korpusu;
	LDS  R30,_srednica_wew_korpusu
	LDS  R31,_srednica_wew_korpusu+1
	STS  _srednica_wew_korpusu_cyklowa,R30
	STS  _srednica_wew_korpusu_cyklowa+1,R31
; 0000 1D4E 
; 0000 1D4F                         wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad1
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL SUBOPT_0x9E
; 0000 1D50                         wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad2
	CALL SUBOPT_0xA
	CALL SUBOPT_0x22
	CALL SUBOPT_0x9E
; 0000 1D51 
; 0000 1D52                         il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0000 1D53                         il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
; 0000 1D54 
; 0000 1D55 
; 0000 1D56                         szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64) - 1;  //wykonano zaciskow rzad1
	CALL SUBOPT_0x17
	SBIW R30,1
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL __EEPROMWRW
; 0000 1D57 
; 0000 1D58                         tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x20
	LDI  R26,LOW(_tryb_pracy_szczotki_drucianej)
	LDI  R27,HIGH(_tryb_pracy_szczotki_drucianej)
	CALL __EEPROMWRW
; 0000 1D59 
; 0000 1D5A                         if(tryb_pracy_szczotki_drucianej == 1)
	CALL SUBOPT_0x73
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x45D
; 0000 1D5B                             szczotka_druciana_ilosc_cykli = 1; //zmieniam bo teraz inny ruch szczotki drucianej, jeden schodek na dole
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EEPROMWRW
; 0000 1D5C                         if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)
_0x45D:
	CALL SUBOPT_0x73
	CALL SUBOPT_0x76
	BREQ _0x45E
; 0000 1D5D                             czas_druciaka_na_gorze = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _czas_druciaka_na_gorze,R30
	STS  _czas_druciaka_na_gorze+1,R31
; 0000 1D5E 
; 0000 1D5F                                                 //2090
; 0000 1D60                         krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);  //wykonano zaciskow rzad1
_0x45E:
	CALL SUBOPT_0x29
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
; 0000 1D61                                                     //3000
; 0000 1D62 
; 0000 1D63                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);  //wykonano zaciskow rzad1
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1F
; 0000 1D64 
; 0000 1D65                         if(krazek_scierny_cykl_po_okregu_ilosc == 0)
	CALL SUBOPT_0x78
	SBIW R30,0
	BRNE _0x45F
; 0000 1D66                             {
; 0000 1D67                             krazek_scierny_ilosc_cykli--;
	CALL SUBOPT_0x98
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
; 0000 1D68                             }
; 0000 1D69 
; 0000 1D6A                         predkosc_pion_szczotka = odczytaj_parametr(32,80);
_0x45F:
	CALL SUBOPT_0x29
	CALL SUBOPT_0x21
	CALL _odczytaj_parametr
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 1D6B                                                 //2060
; 0000 1D6C                         predkosc_pion_krazek = odczytaj_parametr(32,96);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x22
	CALL _odczytaj_parametr
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 1D6D 
; 0000 1D6E                         wejscie_krazka_sciernego_w_pow_boczna_cylindra = odczytaj_parametr(48,16);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xB
	CALL _odczytaj_parametr
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 1D6F 
; 0000 1D70                         predkosc_ruchow_po_okregu_krazek_scierny = odczytaj_parametr(32,112);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x20
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 1D71 
; 0000 1D72                         srednica_krazka_sciernego = odczytaj_parametr(48,112);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x20
	CALL SUBOPT_0x23
; 0000 1D73 
; 0000 1D74                         ruch_haos = odczytaj_parametr(48,144);
	CALL SUBOPT_0x1D
	STS  _ruch_haos,R30
	STS  _ruch_haos+1,R31
; 0000 1D75 
; 0000 1D76                         statystyka = odczytaj_parametr(128,64);
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x17
	STS  _statystyka,R30
	STS  _statystyka+1,R31
; 0000 1D77 
; 0000 1D78                         if(il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0)
	CALL SUBOPT_0xE3
	CALL SUBOPT_0x15B
	CALL SUBOPT_0xE5
	AND  R30,R0
	BREQ _0x460
; 0000 1D79                               il_zaciskow_rzad_2 = il_zaciskow_rzad_2;
	CALL SUBOPT_0x15C
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
; 0000 1D7A                         else
	RJMP _0x461
_0x460:
; 0000 1D7B                               il_zaciskow_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R30
; 0000 1D7C 
; 0000 1D7D                         wybor_linijek_sterownikow(1);  //rzad 1
_0x461:
	CALL SUBOPT_0xC8
; 0000 1D7E                         }
; 0000 1D7F 
; 0000 1D80                     jestem_w_trakcie_czyszczenia_calosci = 1;
_0x45C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R31
; 0000 1D81 
; 0000 1D82                     if(rzad_obrabiany == 1)
	CALL SUBOPT_0x92
	SBIW R26,1
	BRNE _0x462
; 0000 1D83                     {
; 0000 1D84                     PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
	CBI  0x3,6
; 0000 1D85                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x465
; 0000 1D86                         cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0xE8
	CALL SUBOPT_0xD1
; 0000 1D87                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x465:
	CALL SUBOPT_0xD2
	SBIW R26,5
	BRGE _0x466
; 0000 1D88                         cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xA
	CALL SUBOPT_0xD4
; 0000 1D89                     }
_0x466:
; 0000 1D8A 
; 0000 1D8B                     if(rzad_obrabiany == 2)
_0x462:
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x467
; 0000 1D8C                     {
; 0000 1D8D                     ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1D8E                     //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2 - na razie nie bo nie ma jeszcze oslon
; 0000 1D8F 
; 0000 1D90                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x468
; 0000 1D91                         cykl_sterownik_1 = sterownik_1_praca(0x008);
	CALL SUBOPT_0xD3
	CALL SUBOPT_0xD1
; 0000 1D92                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x468:
	CALL SUBOPT_0xD2
	SBIW R26,5
	BRGE _0x469
; 0000 1D93                         cykl_sterownik_2 = sterownik_2_praca(0x001);       //ster 2 pod pin pozy rzad 2
	CALL SUBOPT_0xE7
	CALL SUBOPT_0xD4
; 0000 1D94                     }
_0x469:
; 0000 1D95 
; 0000 1D96 
; 0000 1D97                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x467:
	CALL SUBOPT_0xD5
	BREQ _0x46A
; 0000 1D98                         {
; 0000 1D99 
; 0000 1D9A                           if(rzad_obrabiany == 2)
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x46B
; 0000 1D9B                             {
; 0000 1D9C                             while(PORTE.6 == 0)
_0x46C:
	SBIC 0x3,6
	RJMP _0x46E
; 0000 1D9D                                 przerzucanie_dociskow();
	CALL _przerzucanie_dociskow
	RJMP _0x46C
_0x46E:
; 0000 1D9E delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 1D9F                             }
; 0000 1DA0 
; 0000 1DA1                         delay_ms(2000);  //aby zdazyl przelozyc
_0x46B:
	CALL SUBOPT_0x157
; 0000 1DA2                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1DA3                         cykl_sterownik_2 = 0;
; 0000 1DA4                         cykl_sterownik_3 = 0;
; 0000 1DA5                         cykl_sterownik_4 = 0;
; 0000 1DA6                         cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x15A
; 0000 1DA7                         koniec_rzedu_10 = 0;
	CALL SUBOPT_0x15D
; 0000 1DA8                         cykl_glowny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x15E
; 0000 1DA9                         }
; 0000 1DAA 
; 0000 1DAB             break;
_0x46A:
	RJMP _0x458
; 0000 1DAC 
; 0000 1DAD 
; 0000 1DAE 
; 0000 1DAF             case 1:
_0x459:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x46F
; 0000 1DB0 
; 0000 1DB1 
; 0000 1DB2                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 1)
	CALL SUBOPT_0x15F
	CALL SUBOPT_0x160
	AND  R30,R0
	BREQ _0x470
; 0000 1DB3                           {          //ster 1 nic
; 0000 1DB4                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 1DB5                           cykl_sterownik_2 = sterownik_2_praca(a[0]);        //ster 2 pod zacisk
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xD4
; 0000 1DB6                           }                                                    //ster 4 na pozycje miedzy rzedzami
; 0000 1DB7 
; 0000 1DB8                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 2)
_0x470:
	CALL SUBOPT_0x15F
	CALL SUBOPT_0x94
	AND  R30,R0
	BREQ _0x473
; 0000 1DB9                         {
; 0000 1DBA                         //cykl_sterownik_2 = sterownik_2_praca(0x5B,0);
; 0000 1DBB                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 1DBC                           ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1DBD                           cykl_sterownik_2 = sterownik_2_praca(a[1]);
	CALL SUBOPT_0xE9
	CALL SUBOPT_0xD4
; 0000 1DBE                          }
; 0000 1DBF                      if(cykl_sterownik_4 < 5 & cykl_sterownik_2 == 5)
_0x473:
	CALL SUBOPT_0x10E
	CALL __LTW12
	CALL SUBOPT_0x161
	AND  R30,R0
	BREQ _0x476
; 0000 1DC0                        // cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);
; 0000 1DC1                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0x130
	CALL SUBOPT_0xCD
; 0000 1DC2 
; 0000 1DC3                       if(cykl_sterownik_2 == 5 & cykl_sterownik_4 == 5)
_0x476:
	CALL SUBOPT_0xD2
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x10E
	CALL __EQW12
	AND  R30,R0
	BREQ _0x477
; 0000 1DC4                         {
; 0000 1DC5                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1DC6                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x162
; 0000 1DC7                         cykl_sterownik_4 = 0;
; 0000 1DC8                         szczotka_druc_cykl = 0;
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
; 0000 1DC9                         cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x15E
; 0000 1DCA                         }
; 0000 1DCB 
; 0000 1DCC 
; 0000 1DCD             break;
_0x477:
	RJMP _0x458
; 0000 1DCE 
; 0000 1DCF 
; 0000 1DD0             case 2:
_0x46F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x478
; 0000 1DD1                     if(rzad_obrabiany == 2)
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x479
; 0000 1DD2                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1DD3 
; 0000 1DD4                     if(cykl_sterownik_4 < 5)
_0x479:
	CALL SUBOPT_0xCC
	SBIW R26,5
	BRGE _0x47A
; 0000 1DD5                           cykl_sterownik_4 = sterownik_4_praca(a[2],1);
	CALL SUBOPT_0x77
	CALL SUBOPT_0x13B
	CALL SUBOPT_0xCD
; 0000 1DD6                     if(cykl_sterownik_4 == 5)
_0x47A:
	CALL SUBOPT_0xCC
	SBIW R26,5
	BRNE _0x47B
; 0000 1DD7                         {
; 0000 1DD8                         PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1DD9                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1DDA 
; 0000 1DDB                         //if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
; 0000 1DDC                         //     cykl_sterownik_4 = 5;
; 0000 1DDD 
; 0000 1DDE                         sek13 = 0;
	CALL SUBOPT_0x163
; 0000 1DDF                         cykl_glowny = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x15E
; 0000 1DE0                         }
; 0000 1DE1             break;
_0x47B:
	RJMP _0x458
; 0000 1DE2 
; 0000 1DE3 
; 0000 1DE4             case 3:
_0x478:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x47E
; 0000 1DE5 
; 0000 1DE6                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x47F
; 0000 1DE7                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1DE8 
; 0000 1DE9                     if(cykl_sterownik_4 < 5 & sek13 > czas_druciaka_na_gorze & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x47F:
	CALL SUBOPT_0x10E
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
	CALL SUBOPT_0x95
	CALL SUBOPT_0x164
	BREQ _0x480
; 0000 1DEA                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV
	CALL SUBOPT_0x74
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xCD
; 0000 1DEB 
; 0000 1DEC                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x480:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x112
	CALL SUBOPT_0x164
	BREQ _0x481
; 0000 1DED                         {
; 0000 1DEE                         szczotka_druc_cykl++;
	CALL SUBOPT_0x13C
; 0000 1DEF                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1DF0 
; 0000 1DF1                         if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
	CALL SUBOPT_0x73
	CALL SUBOPT_0x165
	CALL SUBOPT_0x166
	AND  R30,R0
	BREQ _0x482
; 0000 1DF2                             cykl_sterownik_4 = 5;
	CALL SUBOPT_0xFC
; 0000 1DF3 
; 0000 1DF4 
; 0000 1DF5 
; 0000 1DF6                         if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x482:
	CALL SUBOPT_0x73
	CALL SUBOPT_0x165
	CALL SUBOPT_0x164
	BREQ _0x483
; 0000 1DF7                                {
; 0000 1DF8                                cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x15E
; 0000 1DF9                                if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x73
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x484
; 0000 1DFA                                    PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1DFB                                }
_0x484:
; 0000 1DFC                         }
_0x483:
; 0000 1DFD 
; 0000 1DFE                     if(cykl_sterownik_4 < 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & tryb_pracy_szczotki_drucianej == 1)
_0x481:
	CALL SUBOPT_0x10E
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x95
	CALL SUBOPT_0x166
	AND  R0,R30
	CALL SUBOPT_0x73
	CALL SUBOPT_0x167
	BREQ _0x487
; 0000 1DFF                          cykl_sterownik_4 = sterownik_4_praca(0x03,0); //INV
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xCD
; 0000 1E00 
; 0000 1E01 
; 0000 1E02 
; 0000 1E03                         if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
_0x487:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x112
	CALL SUBOPT_0x166
	AND  R30,R0
	BREQ _0x488
; 0000 1E04                             {
; 0000 1E05                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1E06                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1E07                             cykl_glowny = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x15E
; 0000 1E08                             }
; 0000 1E09 
; 0000 1E0A             break;
_0x488:
	RJMP _0x458
; 0000 1E0B 
; 0000 1E0C             case 4:
_0x47E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x48B
; 0000 1E0D 
; 0000 1E0E 
; 0000 1E0F                       if(rzad_obrabiany == 2)
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x48C
; 0000 1E10                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1E11 
; 0000 1E12                      if(cykl_sterownik_4 < 5)
_0x48C:
	CALL SUBOPT_0xCC
	SBIW R26,5
	BRGE _0x48D
; 0000 1E13                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0x130
	CALL SUBOPT_0xCD
; 0000 1E14 
; 0000 1E15                      if(cykl_sterownik_4 == 5)
_0x48D:
	CALL SUBOPT_0xCC
	SBIW R26,5
	BRNE _0x48E
; 0000 1E16                         {
; 0000 1E17                         PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1E18                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1E19                         ruch_zlozony = 0;
	LDI  R30,LOW(0)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R30
; 0000 1E1A                         cykl_glowny = 5;
	CALL SUBOPT_0x168
; 0000 1E1B                         }
; 0000 1E1C 
; 0000 1E1D             break;
_0x48E:
	RJMP _0x458
; 0000 1E1E 
; 0000 1E1F             case 5:
_0x48B:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x491
; 0000 1E20 
; 0000 1E21 
; 0000 1E22                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 1)
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x169
	AND  R0,R30
	CALL SUBOPT_0x160
	AND  R30,R0
	BREQ _0x492
; 0000 1E23                         cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0xA
	CALL SUBOPT_0xD1
; 0000 1E24                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 2)
_0x492:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x169
	AND  R0,R30
	CALL SUBOPT_0x94
	AND  R30,R0
	BREQ _0x493
; 0000 1E25                         cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xE7
	CALL SUBOPT_0xD1
; 0000 1E26 
; 0000 1E27                      if(rzad_obrabiany == 2)
_0x493:
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x494
; 0000 1E28                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1E29 
; 0000 1E2A                     if(cykl_sterownik_1 == 5 & ruch_zlozony == 0)
_0x494:
	CALL SUBOPT_0xFD
	CALL __EQW12
	CALL SUBOPT_0x16A
	CALL SUBOPT_0xAD
	BREQ _0x495
; 0000 1E2B                         {
; 0000 1E2C                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1E2D                         ruch_zlozony = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 1E2E                         }
; 0000 1E2F 
; 0000 1E30                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 1)
_0x495:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x16B
	CALL SUBOPT_0x7A
	AND  R0,R30
	CALL SUBOPT_0x160
	AND  R30,R0
	BREQ _0x496
; 0000 1E31                         cykl_sterownik_1 = sterownik_1_praca(a[0]);
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xD1
; 0000 1E32                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 2)
_0x496:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x16B
	CALL SUBOPT_0x7A
	AND  R0,R30
	CALL SUBOPT_0x94
	AND  R30,R0
	BREQ _0x497
; 0000 1E33                           cykl_sterownik_1 = sterownik_1_praca(a[1]);
	CALL SUBOPT_0xE9
	CALL SUBOPT_0xD1
; 0000 1E34 
; 0000 1E35 
; 0000 1E36                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 2)
_0x497:
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x16B
	CALL SUBOPT_0xB1
	AND  R30,R0
	BREQ _0x498
; 0000 1E37                         cykl_sterownik_1 = sterownik_1_praca(0x003);     ////////////////////////////////////////////////////////////
	CALL SUBOPT_0xE2
; 0000 1E38 
; 0000 1E39                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 0)                                //ster 1 do pierwszego dolka
_0x498:
	CALL SUBOPT_0x15F
	CALL SUBOPT_0x16C
	CALL SUBOPT_0xAD
	BREQ _0x499
; 0000 1E3A                         cykl_sterownik_2 = sterownik_2_praca(0x003);       //ster 2 pod nastpeny dolek
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x16D
; 0000 1E3B 
; 0000 1E3C 
; 0000 1E3D                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 1)
_0x499:
	CALL SUBOPT_0x15F
	CALL SUBOPT_0x16C
	CALL SUBOPT_0x7A
	AND  R0,R30
	CALL SUBOPT_0x160
	AND  R30,R0
	BREQ _0x49A
; 0000 1E3E                         cykl_sterownik_2 = sterownik_2_praca(0x008);      //ster 2 do samego tylu
	CALL SUBOPT_0xD3
	CALL SUBOPT_0xD4
; 0000 1E3F                      if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 2)
_0x49A:
	CALL SUBOPT_0x15F
	CALL SUBOPT_0x16C
	CALL SUBOPT_0x7A
	AND  R0,R30
	CALL SUBOPT_0x94
	AND  R30,R0
	BREQ _0x49B
; 0000 1E40                         cykl_sterownik_2 = sterownik_2_praca(0x009);      //ster 2 do samego tylu
	CALL SUBOPT_0xE8
	CALL SUBOPT_0xD4
; 0000 1E41 
; 0000 1E42                     if((cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5 & ruch_zlozony == 1) | (cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5) & ruch_zlozony == 2)
_0x49B:
	CALL SUBOPT_0xFD
	CALL __EQW12
	CALL SUBOPT_0x161
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0x7A
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0xFD
	CALL __EQW12
	CALL SUBOPT_0x161
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0xB1
	AND  R30,R0
	OR   R30,R1
	BREQ _0x49C
; 0000 1E43                         {
; 0000 1E44                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1E45                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x162
; 0000 1E46                         cykl_sterownik_4 = 0;
; 0000 1E47                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 1E48                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
	SBI  0x3,3
; 0000 1E49                         cykl_glowny = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x15E
; 0000 1E4A                         }
; 0000 1E4B 
; 0000 1E4C             break;
_0x49C:
	RJMP _0x458
; 0000 1E4D 
; 0000 1E4E             case 6:
_0x491:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x49F
; 0000 1E4F 
; 0000 1E50                     if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xCA
	SBIW R26,5
	BRGE _0x4A0
; 0000 1E51                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs //krazek scierny do gory
	CALL SUBOPT_0x70
	CALL SUBOPT_0xD8
; 0000 1E52 
; 0000 1E53                     if(koniec_rzedu_10 == 1)
_0x4A0:
	CALL SUBOPT_0xFB
	BRNE _0x4A1
; 0000 1E54                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xFC
; 0000 1E55 
; 0000 1E56                     if(cykl_sterownik_4 < 5)
_0x4A1:
	CALL SUBOPT_0xCC
	SBIW R26,5
	BRGE _0x4A2
; 0000 1E57                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);    //ABS          //druciak do gory
	CALL SUBOPT_0x77
	CALL SUBOPT_0x13B
	CALL SUBOPT_0xCD
; 0000 1E58 
; 0000 1E59                      if(rzad_obrabiany == 2)
_0x4A2:
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x4A3
; 0000 1E5A                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1E5B 
; 0000 1E5C 
; 0000 1E5D                     if(cykl_sterownik_4 == 5 & cykl_sterownik_3 == 5)
_0x4A3:
	CALL SUBOPT_0x10E
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x11A
	CALL __EQW12
	AND  R30,R0
	BREQ _0x4A4
; 0000 1E5E                         {
; 0000 1E5F                         if((cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1 & rzad_obrabiany == 1) | (cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1 & rzad_obrabiany == 2))
	CALL SUBOPT_0x16E
	MOV  R0,R30
	CALL SUBOPT_0x160
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0x16F
	MOV  R0,R30
	CALL SUBOPT_0x94
	AND  R30,R0
	OR   R30,R1
	BREQ _0x4A5
; 0000 1E60                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1E61 
; 0000 1E62                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
_0x4A5:
	SBI  0x3,3
; 0000 1E63                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xCF
; 0000 1E64                         cykl_sterownik_4 = 0;
; 0000 1E65                         if(cykl_ilosc_zaciskow > 0)
	CALL SUBOPT_0x170
	CALL __CPW02
	BRGE _0x4AA
; 0000 1E66                                 {
; 0000 1E67                                 sek12 = 0;    //do przedmuchu
	CALL SUBOPT_0x171
; 0000 1E68                                 PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x172
; 0000 1E69                                 PORTF = PORT_F.byte;
; 0000 1E6A                                 }
; 0000 1E6B                         sek13 = 0;
_0x4AA:
	CALL SUBOPT_0x163
; 0000 1E6C                         cykl_glowny = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x15E
; 0000 1E6D                         }
; 0000 1E6E 
; 0000 1E6F            break;
_0x4A4:
	RJMP _0x458
; 0000 1E70 
; 0000 1E71 
; 0000 1E72            case 7:
_0x49F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4AB
; 0000 1E73 
; 0000 1E74 
; 0000 1E75                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x4AC
; 0000 1E76                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1E77 
; 0000 1E78                         wykonalem_komplet_okregow = 0;
_0x4AC:
	CALL SUBOPT_0x14F
; 0000 1E79                         szczotka_druc_cykl = 0;
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
; 0000 1E7A                         krazek_scierny_cykl_po_okregu = 0;
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
; 0000 1E7B                         krazek_scierny_cykl = 0;
	STS  _krazek_scierny_cykl,R30
	STS  _krazek_scierny_cykl+1,R30
; 0000 1E7C                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x12B
; 0000 1E7D                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x132
; 0000 1E7E 
; 0000 1E7F                         abs_ster3 = 0;
	CALL SUBOPT_0x123
; 0000 1E80                         abs_ster4 = 0;
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
; 0000 1E81                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1E82                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x162
; 0000 1E83                         cykl_sterownik_4 = 0;
; 0000 1E84                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 1E85 
; 0000 1E86                              if(krazek_scierny_cykl_po_okregu_ilosc > 0)
	CALL SUBOPT_0x78
	MOVW R26,R30
	CALL __CPW02
	BRGE _0x4AD
; 0000 1E87                                 {
; 0000 1E88                                 if(ruch_haos == 0 & tryb_pracy_szczotki_drucianej == 1)  //spr.
	CALL SUBOPT_0x79
	CALL SUBOPT_0xC4
	MOV  R0,R30
	CALL SUBOPT_0x73
	CALL SUBOPT_0x167
	BREQ _0x4AE
; 0000 1E89                                     cykl_glowny = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x15E
; 0000 1E8A 
; 0000 1E8B                                 if(ruch_haos == 0 & (tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3))//spr.
_0x4AE:
	CALL SUBOPT_0x79
	CALL SUBOPT_0xC4
	MOV  R1,R30
	CALL SUBOPT_0x73
	CALL SUBOPT_0x173
	CALL SUBOPT_0x174
	BREQ _0x4AF
; 0000 1E8C                                     cykl_glowny = 88;
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	CALL SUBOPT_0x15E
; 0000 1E8D 
; 0000 1E8E                                 if(ruch_haos == 1 & tryb_pracy_szczotki_drucianej == 1) //spr.
_0x4AF:
	CALL SUBOPT_0x79
	CALL SUBOPT_0x7A
	MOV  R0,R30
	CALL SUBOPT_0x73
	CALL SUBOPT_0x167
	BREQ _0x4B0
; 0000 1E8F                                     cykl_glowny = 887;
	LDI  R30,LOW(887)
	LDI  R31,HIGH(887)
	CALL SUBOPT_0x15E
; 0000 1E90 
; 0000 1E91                                 if(ruch_haos == 1 & (tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3))// spr.
_0x4B0:
	CALL SUBOPT_0x79
	CALL SUBOPT_0x7A
	MOV  R1,R30
	CALL SUBOPT_0x73
	CALL SUBOPT_0x173
	CALL SUBOPT_0x174
	BREQ _0x4B1
; 0000 1E92                                     cykl_glowny = 888;
	LDI  R30,LOW(888)
	LDI  R31,HIGH(888)
	CALL SUBOPT_0x15E
; 0000 1E93                                 }
_0x4B1:
; 0000 1E94                              else
	RJMP _0x4B2
_0x4AD:
; 0000 1E95                                 {
; 0000 1E96                                 if(tryb_pracy_szczotki_drucianej == 1)  //spr
	CALL SUBOPT_0x73
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4B3
; 0000 1E97                                     cykl_glowny = 997;
	LDI  R30,LOW(997)
	LDI  R31,HIGH(997)
	CALL SUBOPT_0x15E
; 0000 1E98                                 if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)  //spr
_0x4B3:
	CALL SUBOPT_0x73
	CALL SUBOPT_0x76
	BREQ _0x4B4
; 0000 1E99                                     cykl_glowny = 998;
	LDI  R30,LOW(998)
	LDI  R31,HIGH(998)
	CALL SUBOPT_0x15E
; 0000 1E9A 
; 0000 1E9B                                 }
_0x4B4:
_0x4B2:
; 0000 1E9C 
; 0000 1E9D            break;
	RJMP _0x458
; 0000 1E9E 
; 0000 1E9F 
; 0000 1EA0            case 887:
_0x4AB:
	CPI  R30,LOW(0x377)
	LDI  R26,HIGH(0x377)
	CPC  R31,R26
	BRNE _0x4B5
; 0000 1EA1                     przypadek887();
	CALL _przypadek887
; 0000 1EA2            break;
	RJMP _0x458
; 0000 1EA3 
; 0000 1EA4             case 888:
_0x4B5:
	CPI  R30,LOW(0x378)
	LDI  R26,HIGH(0x378)
	CPC  R31,R26
	BRNE _0x4B6
; 0000 1EA5                    przypadek888();
	CALL _przypadek888
; 0000 1EA6            break;
	RJMP _0x458
; 0000 1EA7 
; 0000 1EA8            case 997:
_0x4B6:
	CPI  R30,LOW(0x3E5)
	LDI  R26,HIGH(0x3E5)
	CPC  R31,R26
	BRNE _0x4B7
; 0000 1EA9                    przypadek997();
	CALL _przypadek997
; 0000 1EAA            break;
	RJMP _0x458
; 0000 1EAB 
; 0000 1EAC            case 998:
_0x4B7:
	CPI  R30,LOW(0x3E6)
	LDI  R26,HIGH(0x3E6)
	CPC  R31,R26
	BRNE _0x4B8
; 0000 1EAD                     przypadek998();
	CALL _przypadek998
; 0000 1EAE            break;
	RJMP _0x458
; 0000 1EAF 
; 0000 1EB0             case 8:
_0x4B8:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x4B9
; 0000 1EB1                     przypadek8();
	RCALL _przypadek8
; 0000 1EB2             break;
	RJMP _0x458
; 0000 1EB3 
; 0000 1EB4             case 88:
_0x4B9:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x4BA
; 0000 1EB5                     przypadek88();
	RCALL _przypadek88
; 0000 1EB6             break;
	RJMP _0x458
; 0000 1EB7 
; 0000 1EB8 
; 0000 1EB9 
; 0000 1EBA             case 9:                                          //cykl 3 == 5
_0x4BA:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4BB
; 0000 1EBB 
; 0000 1EBC                          if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF9
	BRGE _0x4BC
; 0000 1EBD                         {
; 0000 1EBE                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0xFA
; 0000 1EBF                         PORTF = PORT_F.byte;
; 0000 1EC0                         }
; 0000 1EC1 
; 0000 1EC2 
; 0000 1EC3 
; 0000 1EC4                          if(rzad_obrabiany == 1)
_0x4BC:
	CALL SUBOPT_0x92
	SBIW R26,1
	BRNE _0x4BD
; 0000 1EC5                          {
; 0000 1EC6                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)    //////
	CALL SUBOPT_0x11A
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x16E
	AND  R30,R0
	BREQ _0x4BE
; 0000 1EC7                               cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x129
; 0000 1EC8 
; 0000 1EC9 
; 0000 1ECA                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_1 - 2)
_0x4BE:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x175
	CALL SUBOPT_0x176
	BREQ _0x4BF
; 0000 1ECB                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x130
	CALL SUBOPT_0xCD
; 0000 1ECC 
; 0000 1ECD 
; 0000 1ECE                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)       //2 marca 2019 wykomentowuje ////////
_0x4BF:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x175
	CALL SUBOPT_0x177
	BREQ _0x4C0
; 0000 1ECF                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCB
; 0000 1ED0 
; 0000 1ED1 
; 0000 1ED2                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_1 - 2)
_0x4C0:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x175
	CALL SUBOPT_0x178
	BREQ _0x4C1
; 0000 1ED3                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCD
; 0000 1ED4 
; 0000 1ED5                           }
_0x4C1:
; 0000 1ED6 
; 0000 1ED7 
; 0000 1ED8                          if(rzad_obrabiany == 2)
_0x4BD:
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x4C2
; 0000 1ED9                          {
; 0000 1EDA                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
	CALL SUBOPT_0x11A
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x16F
	AND  R30,R0
	BREQ _0x4C3
; 0000 1EDB                             cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0x129
; 0000 1EDC 
; 0000 1EDD                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_2 - 2)
_0x4C3:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x179
	CALL SUBOPT_0x176
	BREQ _0x4C4
; 0000 1EDE                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x130
	CALL SUBOPT_0xCD
; 0000 1EDF 
; 0000 1EE0                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x4C4:
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x179
	CALL SUBOPT_0x177
	BREQ _0x4C5
; 0000 1EE1                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCB
; 0000 1EE2 
; 0000 1EE3                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_2 - 2)
_0x4C5:
	CALL SUBOPT_0x10E
	CALL SUBOPT_0x179
	CALL SUBOPT_0x178
	BREQ _0x4C6
; 0000 1EE4                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xCD
; 0000 1EE5 
; 0000 1EE6                            if(rzad_obrabiany == 2)
_0x4C6:
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x4C7
; 0000 1EE7                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1EE8 
; 0000 1EE9                           }
_0x4C7:
; 0000 1EEA 
; 0000 1EEB 
; 0000 1EEC                           if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 & sek12 > czas_przedmuchu)
_0x4C2:
	CALL SUBOPT_0x11A
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x10E
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
	BREQ _0x4C8
; 0000 1EED                             {
; 0000 1EEE                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1EEF                             PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1EF0                             //PORTB.6 = 0;  //wylacz przedmuchy
; 0000 1EF1                             PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0xFA
; 0000 1EF2                             PORTF = PORT_F.byte;
; 0000 1EF3                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x116
; 0000 1EF4                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0x120
; 0000 1EF5                             cykl_ilosc_zaciskow++;
	LDI  R26,LOW(_cykl_ilosc_zaciskow)
	LDI  R27,HIGH(_cykl_ilosc_zaciskow)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 1EF6                             ruch_zlozony = 2;                       //il_zaciskow_rzad_1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 1EF7                             cykl_glowny = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x15E
; 0000 1EF8                             }
; 0000 1EF9 
; 0000 1EFA 
; 0000 1EFB             break;
_0x4C8:
	RJMP _0x458
; 0000 1EFC 
; 0000 1EFD 
; 0000 1EFE 
; 0000 1EFF             case 10:
_0x4BB:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4CD
; 0000 1F00 
; 0000 1F01                                                //wywali ten warunek jak zadziala
; 0000 1F02                      if(rzad_obrabiany == 1 & cykl_glowny != 0)
	CALL SUBOPT_0x160
	CALL SUBOPT_0x17A
	BRNE PC+3
	JMP _0x4CE
; 0000 1F03                             {
; 0000 1F04                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,96);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x13F
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x22
	CALL _wartosc_parametru_panelu
; 0000 1F05                             czas_pracy_szczotki_drucianej_h++;
	CALL SUBOPT_0xEA
	CALL SUBOPT_0x17B
; 0000 1F06                             if(srednica_wew_korpusu_cyklowa == 34)
	CALL SUBOPT_0x17C
	SBIW R26,34
	BRNE _0x4CF
; 0000 1F07                                 czas_pracy_krazka_sciernego_h_34++;
	CALL SUBOPT_0xED
	CALL SUBOPT_0x17B
; 0000 1F08                             if(srednica_wew_korpusu_cyklowa == 36)
_0x4CF:
	CALL SUBOPT_0x17C
	SBIW R26,36
	BRNE _0x4D0
; 0000 1F09                                 czas_pracy_krazka_sciernego_h_36++;
	CALL SUBOPT_0xF0
	CALL SUBOPT_0x17B
; 0000 1F0A                             if(srednica_wew_korpusu_cyklowa == 38)
_0x4D0:
	CALL SUBOPT_0x17C
	SBIW R26,38
	BRNE _0x4D1
; 0000 1F0B                                 czas_pracy_krazka_sciernego_h_38++;
	CALL SUBOPT_0xF1
	CALL SUBOPT_0x17B
; 0000 1F0C                             if(srednica_wew_korpusu_cyklowa == 41)
_0x4D1:
	CALL SUBOPT_0x17C
	SBIW R26,41
	BRNE _0x4D2
; 0000 1F0D                                 czas_pracy_krazka_sciernego_h_41++;
	CALL SUBOPT_0xF2
	CALL SUBOPT_0x17B
; 0000 1F0E                             if(srednica_wew_korpusu_cyklowa == 43)
_0x4D2:
	CALL SUBOPT_0x17C
	SBIW R26,43
	BRNE _0x4D3
; 0000 1F0F                                 czas_pracy_krazka_sciernego_h_43++;
	CALL SUBOPT_0xF3
	CALL SUBOPT_0x17B
; 0000 1F10 
; 0000 1F11 
; 0000 1F12                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_1 - 1)
_0x4D3:
	CALL SUBOPT_0x17D
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x4D4
; 0000 1F13                                 {
; 0000 1F14                                 cykl_glowny = 5;
	CALL SUBOPT_0x168
; 0000 1F15                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0x15D
; 0000 1F16                                 }
; 0000 1F17 
; 0000 1F18                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
_0x4D4:
	CALL SUBOPT_0x17D
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x4D5
; 0000 1F19                                 {
; 0000 1F1A                                 cykl_glowny = 5;
	CALL SUBOPT_0x168
; 0000 1F1B                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x17E
; 0000 1F1C                                 }
; 0000 1F1D 
; 0000 1F1E                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 == 10)
_0x4D5:
	CALL SUBOPT_0x17F
	CALL __EQW12
	AND  R30,R0
	BREQ _0x4D6
; 0000 1F1F                                 {
; 0000 1F20                                 cykl_glowny = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x15E
; 0000 1F21                                 }
; 0000 1F22 
; 0000 1F23                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 != 10)  /////zmieniam + 1 20.02
_0x4D6:
	CALL SUBOPT_0x17F
	CALL __NEW12
	AND  R30,R0
	BREQ _0x4D7
; 0000 1F24                                 {
; 0000 1F25                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x15E
; 0000 1F26                                 }
; 0000 1F27                             }
_0x4D7:
; 0000 1F28 
; 0000 1F29 
; 0000 1F2A                              if(rzad_obrabiany == 2)
_0x4CE:
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x4D8
; 0000 1F2B                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F2C 
; 0000 1F2D                             if(rzad_obrabiany == 2 & cykl_glowny != 0)
_0x4D8:
	CALL SUBOPT_0x94
	CALL SUBOPT_0x17A
	BRNE PC+3
	JMP _0x4D9
; 0000 1F2E                             {
; 0000 1F2F                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,16);  //wykonano zaciskow rzad2
	CALL SUBOPT_0x13F
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xB
	CALL _wartosc_parametru_panelu
; 0000 1F30 
; 0000 1F31                             czas_pracy_szczotki_drucianej_h++;
	CALL SUBOPT_0xEA
	CALL SUBOPT_0x17B
; 0000 1F32                             if(srednica_wew_korpusu_cyklowa == 34)
	CALL SUBOPT_0x17C
	SBIW R26,34
	BRNE _0x4DA
; 0000 1F33                                 czas_pracy_krazka_sciernego_h_34++;
	CALL SUBOPT_0xED
	CALL SUBOPT_0x17B
; 0000 1F34                             if(srednica_wew_korpusu_cyklowa == 36)
_0x4DA:
	CALL SUBOPT_0x17C
	SBIW R26,36
	BRNE _0x4DB
; 0000 1F35                                 czas_pracy_krazka_sciernego_h_36++;
	CALL SUBOPT_0xF0
	CALL SUBOPT_0x17B
; 0000 1F36                             if(srednica_wew_korpusu_cyklowa == 38)
_0x4DB:
	CALL SUBOPT_0x17C
	SBIW R26,38
	BRNE _0x4DC
; 0000 1F37                                 czas_pracy_krazka_sciernego_h_38++;
	CALL SUBOPT_0xF1
	CALL SUBOPT_0x17B
; 0000 1F38                             if(srednica_wew_korpusu_cyklowa == 41)
_0x4DC:
	CALL SUBOPT_0x17C
	SBIW R26,41
	BRNE _0x4DD
; 0000 1F39                                 czas_pracy_krazka_sciernego_h_41++;
	CALL SUBOPT_0xF2
	CALL SUBOPT_0x17B
; 0000 1F3A                             if(srednica_wew_korpusu_cyklowa == 43)
_0x4DD:
	CALL SUBOPT_0x17C
	SBIW R26,43
	BRNE _0x4DE
; 0000 1F3B                                 czas_pracy_krazka_sciernego_h_43++;
	CALL SUBOPT_0xF3
	CALL SUBOPT_0x17B
; 0000 1F3C 
; 0000 1F3D 
; 0000 1F3E                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_2 - 1)
_0x4DE:
	CALL SUBOPT_0x15C
	SBIW R30,1
	CALL SUBOPT_0x170
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x4DF
; 0000 1F3F                                 {
; 0000 1F40                                 cykl_glowny = 5;
	CALL SUBOPT_0x168
; 0000 1F41                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0x15D
; 0000 1F42                                 }
; 0000 1F43 
; 0000 1F44                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x4DF:
	CALL SUBOPT_0x15C
	SBIW R30,1
	CALL SUBOPT_0x170
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x4E0
; 0000 1F45                                 {
; 0000 1F46                                 cykl_glowny = 5;
	CALL SUBOPT_0x168
; 0000 1F47                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x17E
; 0000 1F48                                 }
; 0000 1F49 
; 0000 1F4A                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 == 10)
_0x4E0:
	CALL SUBOPT_0x180
	CALL __EQW12
	AND  R30,R0
	BREQ _0x4E1
; 0000 1F4B                                 {
; 0000 1F4C                                 cykl_glowny = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x15E
; 0000 1F4D                                 }
; 0000 1F4E 
; 0000 1F4F 
; 0000 1F50                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 != 10)   ///////////////////zmieniam + 1 20.02
_0x4E1:
	CALL SUBOPT_0x180
	CALL __NEW12
	AND  R30,R0
	BREQ _0x4E2
; 0000 1F51                                 {
; 0000 1F52                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x15E
; 0000 1F53                                 }
; 0000 1F54                             }
_0x4E2:
; 0000 1F55 
; 0000 1F56 
; 0000 1F57 
; 0000 1F58             break;
_0x4D9:
	RJMP _0x458
; 0000 1F59 
; 0000 1F5A             case 11:
_0x4CD:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x4E3
; 0000 1F5B 
; 0000 1F5C                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x4E4
; 0000 1F5D                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F5E 
; 0000 1F5F                              //ster 1 ucieka od szafy
; 0000 1F60                              if(cykl_sterownik_1 < 5)
_0x4E4:
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x4E5
; 0000 1F61                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x100
; 0000 1F62 
; 0000 1F63                              if(cykl_sterownik_2 < 5)
_0x4E5:
	CALL SUBOPT_0xD2
	SBIW R26,5
	BRGE _0x4E6
; 0000 1F64                                     cykl_sterownik_2 = sterownik_2_praca(0x190);     //pod dolek ostatni 10 do przedmuchu rzad 1
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0x16D
; 0000 1F65 
; 0000 1F66                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x4E6:
	CALL SUBOPT_0xD5
	BREQ _0x4E7
; 0000 1F67                                     {
; 0000 1F68                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x172
; 0000 1F69                                     PORTF = PORT_F.byte;
; 0000 1F6A                                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 1F6B                                     sek12 = 0;
	CALL SUBOPT_0x171
; 0000 1F6C                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1F6D                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x181
; 0000 1F6E                                     cykl_glowny = 13;
; 0000 1F6F                                     }
; 0000 1F70             break;
_0x4E7:
	RJMP _0x458
; 0000 1F71 
; 0000 1F72 
; 0000 1F73             case 12:
_0x4E3:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x4EA
; 0000 1F74 
; 0000 1F75                              if(rzad_obrabiany == 2)
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x4EB
; 0000 1F76                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F77 
; 0000 1F78                                //ster 1 ucieka od szafy
; 0000 1F79                              if(cykl_sterownik_1 < 5)
_0x4EB:
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x4EC
; 0000 1F7A                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x100
; 0000 1F7B 
; 0000 1F7C                             if(cykl_sterownik_2 < 5)
_0x4EC:
	CALL SUBOPT_0xD2
	SBIW R26,5
	BRGE _0x4ED
; 0000 1F7D                                     cykl_sterownik_2 = sterownik_2_praca(0x191);     //pod dolek ostatni 10 do przedmuchu rzad 2
	LDI  R30,LOW(401)
	LDI  R31,HIGH(401)
	CALL SUBOPT_0x16D
; 0000 1F7E 
; 0000 1F7F                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x4ED:
	CALL SUBOPT_0xD5
	BREQ _0x4EE
; 0000 1F80                                     {
; 0000 1F81                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x172
; 0000 1F82                                     PORTF = PORT_F.byte;
; 0000 1F83                                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 1F84                                     sek12 = 0;
	CALL SUBOPT_0x171
; 0000 1F85                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1F86                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x181
; 0000 1F87                                     cykl_glowny = 13;
; 0000 1F88                                     }
; 0000 1F89 
; 0000 1F8A 
; 0000 1F8B             break;
_0x4EE:
	RJMP _0x458
; 0000 1F8C 
; 0000 1F8D             case 13:
_0x4EA:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x4F1
; 0000 1F8E 
; 0000 1F8F 
; 0000 1F90                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x4F2
; 0000 1F91                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F92 
; 0000 1F93                               if(sek12 > czas_przedmuchu)
_0x4F2:
	CALL SUBOPT_0xF9
	BRGE _0x4F3
; 0000 1F94                                         {
; 0000 1F95                                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0xFA
; 0000 1F96                                         PORTF = PORT_F.byte;
; 0000 1F97                                         PORTE.5 = 0;
	CBI  0x3,5
; 0000 1F98                                         }
; 0000 1F99 
; 0000 1F9A 
; 0000 1F9B                              if(cykl_sterownik_2 < 5)
_0x4F3:
	CALL SUBOPT_0xD2
	SBIW R26,5
	BRGE _0x4F6
; 0000 1F9C                                     cykl_sterownik_2 = sterownik_2_praca(0x192);     //okrag
	LDI  R30,LOW(402)
	LDI  R31,HIGH(402)
	CALL SUBOPT_0x16D
; 0000 1F9D                              if(cykl_sterownik_2 == 5)
_0x4F6:
	CALL SUBOPT_0xD2
	SBIW R26,5
	BRNE _0x4F7
; 0000 1F9E                                     {
; 0000 1F9F 
; 0000 1FA0                                      if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF9
	BRGE _0x4F8
; 0000 1FA1                                         {
; 0000 1FA2                                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0xFA
; 0000 1FA3                                         PORTF = PORT_F.byte;
; 0000 1FA4                                         PORTE.5 = 0;
	CBI  0x3,5
; 0000 1FA5                                         cykl_sterownik_2 = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
; 0000 1FA6                                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x15E
; 0000 1FA7                                         }
; 0000 1FA8                                     }
_0x4F8:
; 0000 1FA9 
; 0000 1FAA             break;
_0x4F7:
	RJMP _0x458
; 0000 1FAB 
; 0000 1FAC 
; 0000 1FAD 
; 0000 1FAE             case 14:
_0x4F1:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x4FB
; 0000 1FAF 
; 0000 1FB0 
; 0000 1FB1                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x4FC
; 0000 1FB2                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1FB3 
; 0000 1FB4                     if(cykl_sterownik_1 < 5)
_0x4FC:
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x4FD
; 0000 1FB5                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek zeby przedmuchac
	CALL SUBOPT_0xE2
; 0000 1FB6                     if(cykl_sterownik_1 == 5)
_0x4FD:
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRNE _0x4FE
; 0000 1FB7                         {
; 0000 1FB8                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x102
; 0000 1FB9                         sek12 = 0;
	CALL SUBOPT_0x171
; 0000 1FBA                         cykl_glowny = 15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x15E
; 0000 1FBB                         }
; 0000 1FBC 
; 0000 1FBD             break;
_0x4FE:
	RJMP _0x458
; 0000 1FBE 
; 0000 1FBF 
; 0000 1FC0 
; 0000 1FC1             case 15:
_0x4FB:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x4FF
; 0000 1FC2 
; 0000 1FC3                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x92
	SBIW R26,2
	BRNE _0x500
; 0000 1FC4                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1FC5 
; 0000 1FC6                     //przedmuch
; 0000 1FC7                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
_0x500:
	CALL SUBOPT_0x172
; 0000 1FC8                     PORTF = PORT_F.byte;
; 0000 1FC9 
; 0000 1FCA                     if(start == 1)
	CALL SUBOPT_0xB2
	SBIW R26,1
	BRNE _0x501
; 0000 1FCB                         {
; 0000 1FCC                         obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xB4
; 0000 1FCD                         obsluga_nacisniecia_zatrzymaj();
; 0000 1FCE                         }
; 0000 1FCF 
; 0000 1FD0 
; 0000 1FD1                     if(sek12 > czas_przedmuchu)
_0x501:
	CALL SUBOPT_0xF9
	BRGE _0x502
; 0000 1FD2                         {
; 0000 1FD3                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xFA
; 0000 1FD4                         PORTF = PORT_F.byte;
; 0000 1FD5                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x15E
; 0000 1FD6                         }
; 0000 1FD7             break;
_0x502:
	RJMP _0x458
; 0000 1FD8 
; 0000 1FD9 
; 0000 1FDA             case 16:
_0x4FF:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x503
; 0000 1FDB 
; 0000 1FDC                      if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & wykonalem_rzedow == 0)  /////zmieniam + 1 20.02
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	CALL SUBOPT_0x170
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x182
	CALL SUBOPT_0xAD
	BREQ _0x504
; 0000 1FDD                                 {
; 0000 1FDE                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x15A
; 0000 1FDF                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1FE0                                 if(il_zaciskow_rzad_2 > 0)
	CALL SUBOPT_0xE3
	CALL __CPW02
	BRGE _0x507
; 0000 1FE1                                     {
; 0000 1FE2 
; 0000 1FE3                                     rzad_obrabiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
; 0000 1FE4                                     wybor_linijek_sterownikow(2);  //rzad 2
	CALL SUBOPT_0xE6
; 0000 1FE5                                     cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 1FE6                                     }
; 0000 1FE7                                 else
	RJMP _0x508
_0x507:
; 0000 1FE8                                     cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x15E
; 0000 1FE9 
; 0000 1FEA                                 wykonalem_rzedow = 1;
_0x508:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 1FEB                                 }
; 0000 1FEC 
; 0000 1FED                        if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 1)   ///////////////////zmieniam + 1 20.02
_0x504:
	CALL SUBOPT_0x15C
	CALL SUBOPT_0x170
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xE4
	CALL SUBOPT_0x182
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x509
; 0000 1FEE                                 {
; 0000 1FEF                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1FF0                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x15A
; 0000 1FF1                                 cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x15E
; 0000 1FF2                                 rzad_obrabiany = 1;
	CALL SUBOPT_0x158
; 0000 1FF3                                 wykonalem_rzedow = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 1FF4                                 }
; 0000 1FF5 
; 0000 1FF6 
; 0000 1FF7                         if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 2)
_0x509:
	CALL SUBOPT_0x183
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xE4
	CALL SUBOPT_0x182
	CALL SUBOPT_0xB1
	AND  R30,R0
	BREQ _0x50C
; 0000 1FF8                                   {
; 0000 1FF9                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x158
; 0000 1FFA                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0x159
; 0000 1FFB                                   PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1FFC                                   //PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1 - tego na razie nie poki nie ma oslon
; 0000 1FFD                                   //PORTB.6 = 0;   ////zielona lampka
; 0000 1FFE                                   //wartosc_parametru_panelu(0,0,64);
; 0000 1FFF                                   }
; 0000 2000 
; 0000 2001                             if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 == 0 & wykonalem_rzedow == 1)
_0x50C:
	CALL SUBOPT_0x183
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xC4
	AND  R0,R30
	CALL SUBOPT_0x182
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x50F
; 0000 2002                                   {
; 0000 2003                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x158
; 0000 2004                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0x159
; 0000 2005                                   //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
; 0000 2006                                   }
; 0000 2007 
; 0000 2008 
; 0000 2009 
; 0000 200A             break;
_0x50F:
	RJMP _0x458
; 0000 200B 
; 0000 200C 
; 0000 200D             case 17:
_0x503:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x458
; 0000 200E 
; 0000 200F 
; 0000 2010                                  if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xD0
	SBIW R26,5
	BRGE _0x511
; 0000 2011                                     cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0xE8
	CALL SUBOPT_0xD1
; 0000 2012                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x511:
	CALL SUBOPT_0xD2
	SBIW R26,5
	BRGE _0x512
; 0000 2013                                     cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xA
	CALL SUBOPT_0xD4
; 0000 2014 
; 0000 2015                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x512:
	CALL SUBOPT_0xD5
	BRNE PC+3
	JMP _0x513
; 0000 2016                                         {
; 0000 2017                                         PORTB.6 = 0;   ////zielona lampka
	CBI  0x18,6
; 0000 2018                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 2019                                         cykl_sterownik_2 = 0;
; 0000 201A                                         cykl_sterownik_3 = 0;
; 0000 201B                                         cykl_sterownik_4 = 0;
; 0000 201C                                         jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 201D                                         PORTB.6 = 0;
	CBI  0x18,6
; 0000 201E 
; 0000 201F                                         if(odczytalem_w_trakcie_czyszczenia_drugiego_rzedu == 0)
	LDS  R30,_odczytalem_w_trakcie_czyszczenia_drugiego_rzedu
	LDS  R31,_odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1
	SBIW R30,0
	BRNE _0x518
; 0000 2020                                         {
; 0000 2021                                         macierz_zaciskow[1]=0;
	__POINTW1MN _macierz_zaciskow,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 2022                                         macierz_zaciskow[2]=0;
	__POINTW1MN _macierz_zaciskow,4
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 2023 
; 0000 2024                                         komunikat_na_panel("-------",0,80);  //rzad 1
	__POINTW1FN _0x0,2254
	CALL SUBOPT_0x9F
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x10
; 0000 2025                                         komunikat_na_panel("-------",0,32);  //rzad 2
	__POINTW1FN _0x0,2254
	CALL SUBOPT_0x9F
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x10
; 0000 2026 
; 0000 2027                                         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x25
; 0000 2028                                         komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",adr1,adr2);
	__POINTW1FN _0x0,2262
	CALL SUBOPT_0x26
; 0000 2029                                         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x8A
; 0000 202A                                         komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",adr3,adr4);
	__POINTW1FN _0x0,2262
	CALL SUBOPT_0x8B
; 0000 202B                                         }
; 0000 202C 
; 0000 202D                                         odczytalem_w_trakcie_czyszczenia_drugiego_rzedu = 0;
_0x518:
	LDI  R30,LOW(0)
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu,R30
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1,R30
; 0000 202E                                         wartosc_parametru_panelu(0,0,64);
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x97
; 0000 202F                                         delay_ms(1000);
	CALL SUBOPT_0xA0
; 0000 2030                                         start = 0;
	CALL SUBOPT_0xAB
; 0000 2031                                         cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 2032                                         }
; 0000 2033 
; 0000 2034 
; 0000 2035 
; 0000 2036 
; 0000 2037             break;
_0x513:
; 0000 2038 
; 0000 2039 
; 0000 203A 
; 0000 203B             }//switch
_0x458:
; 0000 203C 
; 0000 203D 
; 0000 203E   }//while
	RJMP _0x453
_0x455:
; 0000 203F }//while glowny
	RJMP _0x450
; 0000 2040 
; 0000 2041 }//koniec
_0x519:
	RJMP _0x519
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
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
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
	CALL SUBOPT_0x184
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x184
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
	CALL SUBOPT_0x185
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x186
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x185
	CALL SUBOPT_0x187
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x185
	CALL SUBOPT_0x187
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
	CALL SUBOPT_0x185
	CALL SUBOPT_0x188
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
	CALL SUBOPT_0x185
	CALL SUBOPT_0x188
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
	CALL SUBOPT_0x184
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
	CALL SUBOPT_0x184
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
	CALL SUBOPT_0x186
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x184
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
	CALL SUBOPT_0x186
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
	CALL SUBOPT_0x2B
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
_wykonano_powrot_przedwczesny_krazek_scierny:
	.BYTE 0x2
_wykonano_powrot_przedwczesny_druciak:
	.BYTE 0x2
_statystyka:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:91 WORDS
SUBOPT_0x9:
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
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_43)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_43)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 193 TIMES, CODE SIZE REDUCTION:381 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 154 TIMES, CODE SIZE REDUCTION:609 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(_macierz_zaciskow)
	LDI  R27,HIGH(_macierz_zaciskow)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0xE:
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
SUBOPT_0xF:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 102 TIMES, CODE SIZE REDUCTION:199 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x12:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 44 TIMES, CODE SIZE REDUCTION:255 WORDS
SUBOPT_0x14:
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
SUBOPT_0x15:
	CALL _sprawdz_pin0
	LDI  R26,LOW(0)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x16:
	CALL _sprawdz_pin1
	LDI  R26,LOW(0)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	STS  _il_zaciskow_rzad_1,R30
	STS  _il_zaciskow_rzad_1+1,R31
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	CALL _odczytaj_parametr
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	CALL __EEPROMWRW
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(_krazek_scierny_ilosc_cykli)
	LDI  R27,HIGH(_krazek_scierny_ilosc_cykli)
	CALL __EEPROMWRW
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	CALL _odczytaj_parametr
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu_ilosc)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu_ilosc)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	STS  _srednica_krazka_sciernego,R30
	STS  _srednica_krazka_sciernego+1,R31
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x24:
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
SUBOPT_0x25:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr1
	LDS  R31,_adr1+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr2
	LDS  R31,_adr2+1
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:297 WORDS
SUBOPT_0x26:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr1
	LDS  R31,_adr1+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr2
	LDS  R31,_adr2+1
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x27:
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
SUBOPT_0x28:
	OR   R30,R0
	STS  _PORT_CZYTNIK,R30
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 145 TIMES, CODE SIZE REDUCTION:285 WORDS
SUBOPT_0x2B:
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 69 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_z_czytnika_kodow

;OPTIMIZER ADDED SUBROUTINE, CALLED 68 TIMES, CODE SIZE REDUCTION:265 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x2E:
	CALL _komunikat_z_czytnika_kodow
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x2F:
	CALL _komunikat_z_czytnika_kodow
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x31:
	CALL _komunikat_z_czytnika_kodow
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x34:
	CALL _komunikat_z_czytnika_kodow
	RJMP SUBOPT_0x33

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x35:
	ST   X+,R30
	ST   X,R31
	MOVW R30,R16
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x37:
	CALL _komunikat_z_czytnika_kodow
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 136 TIMES, CODE SIZE REDUCTION:537 WORDS
SUBOPT_0x39:
	STS  _a,R30
	STS  _a+1,R31
	__POINTW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 105 TIMES, CODE SIZE REDUCTION:413 WORDS
SUBOPT_0x3A:
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x3B:
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
SUBOPT_0x3C:
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3D:
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
SUBOPT_0x3E:
	__POINTW1MN _a,18
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3F:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x40:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x41:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x42:
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x43:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x44:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x46:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x47:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x40

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x48:
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
SUBOPT_0x49:
	LDI  R26,LOW(29)
	LDI  R27,HIGH(29)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x40

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x4B:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4C:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4D:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4E:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4F:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x40

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x50:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RJMP SUBOPT_0x4B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x51:
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
SUBOPT_0x52:
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	RJMP SUBOPT_0x40

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x53:
	__POINTW1MN _a,8
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:186 WORDS
SUBOPT_0x54:
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
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x55:
	LDI  R26,LOW(27)
	LDI  R27,HIGH(27)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x56:
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
SUBOPT_0x57:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x58:
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x59:
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	LDI  R26,LOW(22)
	LDI  R27,HIGH(22)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5B:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x5C:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5D:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5E:
	LDI  R26,LOW(20)
	LDI  R27,HIGH(20)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x5F:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x60:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	LDI  R26,LOW(36)
	LDI  R27,HIGH(36)
	RJMP SUBOPT_0x5F

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x61:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x62:
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	RJMP SUBOPT_0x5F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x64:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP SUBOPT_0x5F

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x65:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	RJMP SUBOPT_0x5F

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x66:
	__POINTW1MN _a,8
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x67:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x64

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x68:
	__POINTW1MN _a,8
	LDI  R26,LOW(23)
	LDI  R27,HIGH(23)
	RJMP SUBOPT_0x5F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x69:
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6A:
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6B:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6C:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	RJMP SUBOPT_0x5F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6D:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x62

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6E:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6F:
	LDS  R30,_a
	LDS  R31,_a+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x70:
	__GETW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x71:
	__GETW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x72:
	ADIW R30,1
	__PUTW1MN _a,12
	__GETW1MN _a,12
	ADIW R30,1
	__PUTW1MN _a,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x73:
	LDI  R26,LOW(_tryb_pracy_szczotki_drucianej)
	LDI  R27,HIGH(_tryb_pracy_szczotki_drucianej)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x74:
	__GETW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x75:
	__PUTW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x76:
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
SUBOPT_0x77:
	__GETW1MN _a,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x78:
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu_ilosc)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu_ilosc)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x79:
	LDS  R26,_ruch_haos
	LDS  R27,_ruch_haos+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 91 TIMES, CODE SIZE REDUCTION:177 WORDS
SUBOPT_0x7A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7B:
	__GETW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7C:
	LDS  R26,_srednica_krazka_sciernego
	LDS  R27,_srednica_krazka_sciernego+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7D:
	LDS  R26,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R27,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7E:
	MOV  R0,R30
	RCALL SUBOPT_0x7C
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7F:
	RCALL SUBOPT_0x7D
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x80:
	__PUTW1MN _a,10
	RJMP SUBOPT_0x71

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x81:
	RCALL SUBOPT_0x7D
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x82:
	RCALL SUBOPT_0x7D
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x83:
	MOV  R0,R30
	RCALL SUBOPT_0x7C
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x84:
	__CPD2N 0x3D
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x85:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	SBI  0x12,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x86:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _byla_wloczona_szlifierka_1,R30
	STS  _byla_wloczona_szlifierka_1+1,R31
	CBI  0x3,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x87:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _byla_wloczona_szlifierka_2,R30
	STS  _byla_wloczona_szlifierka_2+1,R31
	CBI  0x3,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x88:
	LDS  R30,_PORT_F
	ANDI R30,LOW(0x10)
	CPI  R30,LOW(0x10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x89:
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
SUBOPT_0x8A:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:201 WORDS
SUBOPT_0x8B:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8C:
	CBI  0x12,7
	LDS  R26,_byla_wloczona_szlifierka_1
	LDS  R27,_byla_wloczona_szlifierka_1+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8D:
	SBI  0x3,2
	LDI  R30,LOW(0)
	STS  _byla_wloczona_szlifierka_1,R30
	STS  _byla_wloczona_szlifierka_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8E:
	LDS  R26,_byla_wloczona_szlifierka_2
	LDS  R27,_byla_wloczona_szlifierka_2+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8F:
	SBI  0x3,3
	LDI  R30,LOW(0)
	STS  _byla_wloczona_szlifierka_2,R30
	STS  _byla_wloczona_szlifierka_2+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x90:
	LDS  R26,_byl_wloczony_przedmuch
	LDS  R27,_byl_wloczony_przedmuch+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x91:
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
SUBOPT_0x92:
	LDS  R26,_rzad_obrabiany
	LDS  R27,_rzad_obrabiany+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x93:
	MOV  R0,R30
	LDS  R26,_start
	LDS  R27,_start+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x94:
	RCALL SUBOPT_0x92
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x95:
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x96:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x97:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x98:
	LDI  R26,LOW(_krazek_scierny_ilosc_cykli)
	LDI  R27,HIGH(_krazek_scierny_ilosc_cykli)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x99:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9A:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9B:
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9C:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_stala)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_stala)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x9D:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9E:
	CALL _wartosc_parametru_panelu
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 38 TIMES, CODE SIZE REDUCTION:71 WORDS
SUBOPT_0x9F:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0xA0:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA1:
	CALL _sprawdz_pin0
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA2:
	CALL _sprawdz_pin1
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xA3:
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
SUBOPT_0xA4:
	CALL _sprawdz_pin3
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA5:
	CALL _sprawdz_pin7
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA6:
	SBI  0x12,7
	CBI  0x18,6
	CBI  0x18,4
	CBI  0x12,2
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA7:
	__POINTW1FN _0x0,1531
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA8:
	CALL _sprawdz_pin6
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0xA9:
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
SUBOPT_0xAA:
	CALL _sprawdz_pin5
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xAB:
	LDI  R30,LOW(0)
	STS  _start,R30
	STS  _start+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAC:
	AND  R30,R26
	MOV  R0,R30
	LDS  R26,_czekaj_az_puszcze
	LDS  R27,_czekaj_az_puszcze+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 59 TIMES, CODE SIZE REDUCTION:171 WORDS
SUBOPT_0xAD:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xAE:
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
SUBOPT_0xAF:
	LDI  R30,LOW(0)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB0:
	LDI  R30,LOW(0)
	STS  _sek11,R30
	STS  _sek11+1,R30
	STS  _sek11+2,R30
	STS  _sek11+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xB1:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB2:
	LDS  R26,_start
	LDS  R27,_start+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xB3:
	SBI  0x12,7
	CBI  0x3,2
	CBI  0x3,3
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB4:
	CALL _obsluga_otwarcia_klapy_rzad
	JMP  _obsluga_nacisniecia_zatrzymaj

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB5:
	LDI  R30,LOW(0)
	STS  _sek1,R30
	STS  _sek1+1,R30
	STS  _sek1+2,R30
	STS  _sek1+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xB6:
	__CPD2N 0x2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0xB7:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB8:
	LDI  R30,LOW(0)
	STS  _sek3,R30
	STS  _sek3+1,R30
	STS  _sek3+2,R30
	STS  _sek3+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0xB9:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xBA:
	OR   R30,R0
	STS  _PORT_F,R30
	LDS  R30,_PORT_STER3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:101 WORDS
SUBOPT_0xBB:
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xBC:
	LDI  R30,LOW(0)
	STS  _sek2,R30
	STS  _sek2+1,R30
	STS  _sek2+2,R30
	STS  _sek2+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0xBD:
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBE:
	STS  _PORT_F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xBF:
	LDI  R30,LOW(0)
	STS  _sek4,R30
	STS  _sek4+1,R30
	STS  _sek4+2,R30
	STS  _sek4+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 50 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0xC0:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0xC1:
	MOVW R26,R28
	ADIW R26,6
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC2:
	LDS  R26,_test_geometryczny_rzad_1
	LDS  R27,_test_geometryczny_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC3:
	LDS  R26,_test_geometryczny_rzad_2
	LDS  R27,_test_geometryczny_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 42 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0xC4:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xC5:
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
SUBOPT_0xC6:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __GTW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC7:
	__GETW1MN _macierz_zaciskow,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC8:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wybor_linijek_sterownikow

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xC9:
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
SUBOPT_0xCA:
	LDS  R26,_cykl_sterownik_3
	LDS  R27,_cykl_sterownik_3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0xCB:
	CALL _sterownik_3_praca
	RJMP SUBOPT_0xBD

;OPTIMIZER ADDED SUBROUTINE, CALLED 75 TIMES, CODE SIZE REDUCTION:145 WORDS
SUBOPT_0xCC:
	LDS  R26,_cykl_sterownik_4
	LDS  R27,_cykl_sterownik_4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0xCD:
	CALL _sterownik_4_praca
	RJMP SUBOPT_0xC0

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0xCE:
	RCALL SUBOPT_0xCA
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0xCC
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:253 WORDS
SUBOPT_0xCF:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 59 TIMES, CODE SIZE REDUCTION:113 WORDS
SUBOPT_0xD0:
	LDS  R26,_cykl_sterownik_1
	LDS  R27,_cykl_sterownik_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0xD1:
	CALL _sterownik_1_praca
	RJMP SUBOPT_0xB7

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xD2:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD3:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xD4:
	CALL _sterownik_2_praca
	RJMP SUBOPT_0xB9

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0xD5:
	RCALL SUBOPT_0xD0
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0xD2
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:227 WORDS
SUBOPT_0xD6:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	RJMP SUBOPT_0xCF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD7:
	RCALL SUBOPT_0x6F
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xD8:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xCB

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0xD9:
	__GETWRN 16,17,6
	MOVW R30,R18
	RJMP SUBOPT_0xC1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xDA:
	MOVW R26,R18
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xDB:
	MOVW R26,R18
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xDC:
	MOVW R26,R18
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xDD:
	MOVW R26,R18
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xDE:
	MOVW R26,R18
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xDF:
	MOVW R26,R18
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE0:
	MOVW R26,R18
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE1:
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE2:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xD1

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xE3:
	LDS  R26,_il_zaciskow_rzad_2
	LDS  R27,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xE4:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE5:
	__GETW1MN _macierz_zaciskow,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE6:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wybor_linijek_sterownikow

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xE7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE8:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE9:
	__GETW1MN _a,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xEA:
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xEB:
	LDS  R30,_PORT_F
	ORI  R30,0x40
	RJMP SUBOPT_0xBB

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xEC:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xED:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_34)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_34)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xEE:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RJMP SUBOPT_0x9F

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xEF:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xEE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF0:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_36)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_36)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF1:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_38)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_38)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF2:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_41)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_41)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF3:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_43)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_43)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF4:
	LDI  R30,LOW(505)
	LDI  R31,HIGH(505)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF5:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF6:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBI  0x18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF7:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF8:
	LDS  R26,_srednica_wew_korpusu
	LDS  R27,_srednica_wew_korpusu+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0xF9:
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
SUBOPT_0xFA:
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	RJMP SUBOPT_0xBB

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xFB:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xFC:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0xC0

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:59 WORDS
SUBOPT_0xFD:
	RCALL SUBOPT_0xD0
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xFE:
	CALL __LTW12
	MOV  R0,R30
	RJMP SUBOPT_0x78

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xFF:
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xAD

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x100:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xD1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x101:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0xFF

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x102:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x103:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:74 WORDS
SUBOPT_0x104:
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __LTW12
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x105:
	__GETW1MN _a,12
	RJMP SUBOPT_0x100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x106:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x78

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x107:
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x108:
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x109:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x10A:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xB1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10B:
	__GETW1MN _a,16
	RJMP SUBOPT_0x100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x10C:
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xB1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10D:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 54 TIMES, CODE SIZE REDUCTION:103 WORDS
SUBOPT_0x10E:
	RCALL SUBOPT_0xCC
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x10F:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster4
	LDS  R27,_abs_ster4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:72 WORDS
SUBOPT_0x110:
	AND  R0,R30
	LDS  R26,_powrot_przedwczesny_druciak
	LDS  R27,_powrot_przedwczesny_druciak+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x111:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x112:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x95

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x113:
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x114:
	CALL __LTW12
	RJMP SUBOPT_0x110

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x115:
	LDS  R30,_koniec_rzedu_10
	LDS  R31,_koniec_rzedu_10+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x116:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x117:
	LDS  R30,_abs_ster4
	LDS  R31,_abs_ster4+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x118:
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
SUBOPT_0x119:
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
	STS  _sek13,R30
	STS  _sek13+1,R30
	STS  _sek13+2,R30
	STS  _sek13+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 44 TIMES, CODE SIZE REDUCTION:83 WORDS
SUBOPT_0x11A:
	RCALL SUBOPT_0xCA
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x11B:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster3
	LDS  R27,_abs_ster3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x11C:
	AND  R0,R30
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0xAD

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x11D:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x98

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x11E:
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11F:
	CALL __LTW12
	RJMP SUBOPT_0x11C

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x120:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x121:
	LDS  R30,_abs_ster3
	LDS  R31,_abs_ster3+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x122:
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
SUBOPT_0x123:
	LDI  R30,LOW(0)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x124:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xE7

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x125:
	RCALL SUBOPT_0x11E
	CALL __EQW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x126:
	RCALL SUBOPT_0x113
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
SUBOPT_0x127:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _powrot_przedwczesny_krazek_scierny,R30
	STS  _powrot_przedwczesny_krazek_scierny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x128:
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x129:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0xD8

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x12A:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x128

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x12B:
	LDI  R30,LOW(0)
	STS  _powrot_przedwczesny_krazek_scierny,R30
	STS  _powrot_przedwczesny_krazek_scierny+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x12C:
	RCALL SUBOPT_0x113
	CALL __EQW12
	AND  R0,R30
	RJMP SUBOPT_0x98

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12D:
	RCALL SUBOPT_0x11E
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x12E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x12F:
	LDS  R26,_powrot_przedwczesny_druciak
	LDS  R27,_powrot_przedwczesny_druciak+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x130:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x9F

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x131:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x12F

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x132:
	LDI  R30,LOW(0)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x133:
	RCALL SUBOPT_0x113
	RJMP SUBOPT_0x11D

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x134:
	CALL __EQW12
	AND  R0,R30
	RJMP SUBOPT_0x10E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x135:
	CALL __EQW12
	AND  R0,R30
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0xC4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x136:
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x137:
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
SUBOPT_0x138:
	RCALL SUBOPT_0x113
	RJMP SUBOPT_0x114

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x139:
	RCALL SUBOPT_0x113
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13A:
	RCALL SUBOPT_0x11E
	RJMP SUBOPT_0x11F

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13B:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xE7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13C:
	LDI  R26,LOW(_szczotka_druc_cykl)
	LDI  R27,HIGH(_szczotka_druc_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x13D:
	LDS  R26,_statystyka
	LDS  R27,_statystyka+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13E:
	LDS  R30,_szczotka_druc_cykl
	LDS  R31,_szczotka_druc_cykl+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13F:
	LDS  R30,_cykl_ilosc_zaciskow
	LDS  R31,_cykl_ilosc_zaciskow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x140:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x9D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x141:
	LDI  R26,LOW(_krazek_scierny_cykl)
	LDI  R27,HIGH(_krazek_scierny_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x142:
	LDS  R30,_krazek_scierny_cykl
	LDS  R31,_krazek_scierny_cykl+1
	RJMP SUBOPT_0x140

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x143:
	RCALL SUBOPT_0x113
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x144:
	LDS  R30,_powrot_przedwczesny_krazek_scierny
	LDS  R31,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x140

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x145:
	LDS  R30,_wykonano_powrot_przedwczesny_krazek_scierny
	LDS  R31,_wykonano_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x140

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x146:
	RCALL SUBOPT_0x11E
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x147:
	LDS  R30,_powrot_przedwczesny_druciak
	LDS  R31,_powrot_przedwczesny_druciak+1
	ST   -Y,R31
	ST   -Y,R30
	JMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x148:
	LDS  R30,_wykonano_powrot_przedwczesny_druciak
	LDS  R31,_wykonano_powrot_przedwczesny_druciak+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	RJMP SUBOPT_0x9F

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x149:
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
	STS  _krazek_scierny_cykl,R30
	STS  _krazek_scierny_cykl+1,R30
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
	CBI  0x3,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14A:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14B:
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
SUBOPT_0x14C:
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14D:
	LDI  R30,LOW(0)
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
	RJMP SUBOPT_0x141

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14E:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14F:
	LDI  R30,LOW(0)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x150:
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
	RJMP SUBOPT_0xAD

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x151:
	AND  R0,R30
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0xAD

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x152:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0xC4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x153:
	RCALL SUBOPT_0x113
	CALL __EQW12
	AND  R30,R0
	MOV  R1,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	MOV  R0,R30
	RJMP SUBOPT_0x98

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x154:
	CALL __EQW12
	RJMP SUBOPT_0x110

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x155:
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	MOV  R22,R30
	MOV  R0,R30
	RJMP SUBOPT_0x95

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x156:
	MOV  R1,R30
	MOV  R0,R22
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x157:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x158:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x159:
	LDI  R30,LOW(0)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15A:
	LDI  R30,LOW(0)
	STS  _cykl_ilosc_zaciskow,R30
	STS  _cykl_ilosc_zaciskow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15B:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x15C:
	LDS  R30,_il_zaciskow_rzad_2
	LDS  R31,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15D:
	LDI  R30,LOW(0)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x15E:
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x15F:
	RCALL SUBOPT_0xD2
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x160:
	RCALL SUBOPT_0x92
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x161:
	MOV  R0,R30
	RCALL SUBOPT_0xD2
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x162:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	RJMP SUBOPT_0x116

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x163:
	LDI  R30,LOW(0)
	STS  _sek13,R30
	STS  _sek13+1,R30
	STS  _sek13+2,R30
	STS  _sek13+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x164:
	RCALL SUBOPT_0x113
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x165:
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
	RJMP SUBOPT_0x95

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x166:
	RCALL SUBOPT_0x113
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x167:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x168:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0x15E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x169:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RJMP SUBOPT_0xC4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16A:
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16B:
	CALL __LTW12
	RJMP SUBOPT_0x16A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16C:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16D:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xD4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16E:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16F:
	RCALL SUBOPT_0x15C
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x170:
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x171:
	LDI  R30,LOW(0)
	STS  _sek12,R30
	STS  _sek12+1,R30
	STS  _sek12+2,R30
	STS  _sek12+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x172:
	LDS  R30,_PORT_F
	ORI  R30,0x10
	RJMP SUBOPT_0xBB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x173:
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x73

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x174:
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __EQW12
	OR   R30,R0
	AND  R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x175:
	CALL __LTW12
	MOV  R0,R30
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x176:
	SBIW R30,2
	RCALL SUBOPT_0x170
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x177:
	SBIW R30,1
	RCALL SUBOPT_0x170
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x178:
	SBIW R30,2
	RCALL SUBOPT_0x170
	CALL __GEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x179:
	CALL __LTW12
	MOV  R0,R30
	RJMP SUBOPT_0x15C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17A:
	MOV  R0,R30
	LDS  R26,_cykl_glowny
	LDS  R27,_cykl_glowny+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x17B:
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x17C:
	LDS  R26,_srednica_wew_korpusu_cyklowa
	LDS  R27,_srednica_wew_korpusu_cyklowa+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17D:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	RJMP SUBOPT_0x170

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x17F:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RCALL SUBOPT_0x170
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x180:
	RCALL SUBOPT_0x15C
	RCALL SUBOPT_0x170
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0xE3
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x181:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RJMP SUBOPT_0x15E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x182:
	LDS  R26,_wykonalem_rzedow
	LDS  R27,_wykonalem_rzedow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x183:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	RJMP SUBOPT_0x15B

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x184:
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
SUBOPT_0x185:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x186:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x187:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	JMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x188:
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
