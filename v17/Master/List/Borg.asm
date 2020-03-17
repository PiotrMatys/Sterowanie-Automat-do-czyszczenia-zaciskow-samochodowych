
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
	.DEF _szczotka_druciana_ilosc_cykli=R4
	.DEF _krazek_scierny_ilosc_cykli=R6
	.DEF _krazek_scierny_cykl_po_okregu_ilosc=R8
	.DEF _tryb_pracy_szczotki_drucianej=R10
	.DEF _czas_pracy_szczotki_drucianej_stala=R12

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
;//#pragma warn-
;
;//eeprom int czas_pracy_krazka_sciernego_h_34, czas_pracy_krazka_sciernego_h_36, czas_pracy_krazka_sciernego_h_38;
;//eeprom int czas_pracy_krazka_sciernego_h_41, czas_pracy_krazka_sciernego_h_43;
;//eeprom int czas_pracy_szczotki_drucianej_h;
;
;
;//eeprom int tryb_pracy_szczotki_drucianej;
;
;//#pragma warn+
;
;
;// Get a character from the USART1 Receiver
;#pragma used+
;char getchar1(void)
; 0000 0030 {

	.CSEG
; 0000 0031 unsigned char status;
; 0000 0032 char data;
; 0000 0033 while (1)
;	status -> R17
;	data -> R16
; 0000 0034       {
; 0000 0035       while (((status=UCSR1A) & RX_COMPLETE)==0);
; 0000 0036       data=UDR1;
; 0000 0037       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
; 0000 0038          return data;
; 0000 0039       }
; 0000 003A }
;#pragma used-
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 0040 {
; 0000 0041 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
; 0000 0042 UDR1=c;
; 0000 0043 }
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
; 0000 0054 #endasm
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
;////////////to idzie do stalej pamieci
;int szczotka_druciana_ilosc_cykli;
;int krazek_scierny_ilosc_cykli;
;int krazek_scierny_cykl_po_okregu_ilosc;
;int tryb_pracy_szczotki_drucianej;
;int czas_pracy_szczotki_drucianej_stala;
;int czas_pracy_krazka_sciernego_stala;
;int czas_pracy_krazka_sciernego_h_34, czas_pracy_krazka_sciernego_h_36, czas_pracy_krazka_sciernego_h_38;
;int czas_pracy_krazka_sciernego_h_41, czas_pracy_krazka_sciernego_h_43;
;int czas_pracy_szczotki_drucianej_h;
;//////////////////////////////////////////////
;
;
;
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
;int szczotka_druc_cykl;
;int cykl_glowny;
;int start_kontynuacja;
;int ruch_zlozony;
;int krazek_scierny_cykl_po_okregu;
;int krazek_scierny_cykl;
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
;//int wymieniono_szczotke_druciana,wymieniono_krazek_scierny;
;int predkosc_pion_szczotka, predkosc_pion_krazek;
;int wejscie_krazka_sciernego_w_pow_boczna_cylindra;
;int predkosc_ruchow_po_okregu_krazek_scierny;
;int test_geometryczny_rzad_1, test_geometryczny_rzad_2;
;//int czas_pracy_krazka_sciernego,czas_pracy_szczotki_drucianej;
;int powrot_przedwczesny_druciak;
;int powrot_przedwczesny_krazek_scierny;
;int czas_druciaka_na_gorze;
;int srednica_krazka_sciernego;
;int manualny_wybor_zacisku;
;int ruch_haos;
;int byla_wloczona_szlifierka_2,byla_wloczona_szlifierka_1;
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
; 0000 00D1 {
_sprawdz_pin0:
; 0000 00D2 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00D3 i2c_write(numer_pcf);
; 0000 00D4 PORT.byte = i2c_read(0);
; 0000 00D5 i2c_stop();
; 0000 00D6 
; 0000 00D7 
; 0000 00D8 return PORT.bits.b0;
	RJMP _0x20A0007
; 0000 00D9 }
;
;char sprawdz_pin1(BB PORT, int numer_pcf)
; 0000 00DC {
_sprawdz_pin1:
; 0000 00DD i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00DE i2c_write(numer_pcf);
; 0000 00DF PORT.byte = i2c_read(0);
; 0000 00E0 i2c_stop();
; 0000 00E1 
; 0000 00E2 
; 0000 00E3 return PORT.bits.b1;
	LSR  R30
	RJMP _0x20A0007
; 0000 00E4 }
;
;
;char sprawdz_pin2(BB PORT, int numer_pcf)
; 0000 00E8 {
_sprawdz_pin2:
; 0000 00E9 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00EA i2c_write(numer_pcf);
; 0000 00EB PORT.byte = i2c_read(0);
; 0000 00EC i2c_stop();
; 0000 00ED 
; 0000 00EE 
; 0000 00EF return PORT.bits.b2;
	LSR  R30
	LSR  R30
	RJMP _0x20A0007
; 0000 00F0 }
;
;char sprawdz_pin3(BB PORT, int numer_pcf)
; 0000 00F3 {
_sprawdz_pin3:
; 0000 00F4 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00F5 i2c_write(numer_pcf);
; 0000 00F6 PORT.byte = i2c_read(0);
; 0000 00F7 i2c_stop();
; 0000 00F8 
; 0000 00F9 
; 0000 00FA return PORT.bits.b3;
	LSR  R30
	LSR  R30
	LSR  R30
	RJMP _0x20A0007
; 0000 00FB }
;
;char sprawdz_pin4(BB PORT, int numer_pcf)
; 0000 00FE {
_sprawdz_pin4:
; 0000 00FF i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0100 i2c_write(numer_pcf);
; 0000 0101 PORT.byte = i2c_read(0);
; 0000 0102 i2c_stop();
; 0000 0103 
; 0000 0104 
; 0000 0105 return PORT.bits.b4;
	SWAP R30
	RJMP _0x20A0007
; 0000 0106 }
;
;char sprawdz_pin5(BB PORT, int numer_pcf)
; 0000 0109 {
_sprawdz_pin5:
; 0000 010A i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 010B i2c_write(numer_pcf);
; 0000 010C PORT.byte = i2c_read(0);
; 0000 010D i2c_stop();
; 0000 010E 
; 0000 010F 
; 0000 0110 return PORT.bits.b5;
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	RJMP _0x20A0007
; 0000 0111 }
;
;char sprawdz_pin6(BB PORT, int numer_pcf)
; 0000 0114 {
_sprawdz_pin6:
; 0000 0115 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0116 i2c_write(numer_pcf);
; 0000 0117 PORT.byte = i2c_read(0);
; 0000 0118 i2c_stop();
; 0000 0119 
; 0000 011A 
; 0000 011B return PORT.bits.b6;
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	RJMP _0x20A0007
; 0000 011C }
;
;char sprawdz_pin7(BB PORT, int numer_pcf)
; 0000 011F {
_sprawdz_pin7:
; 0000 0120 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0121 i2c_write(numer_pcf);
; 0000 0122 PORT.byte = i2c_read(0);
; 0000 0123 i2c_stop();
; 0000 0124 
; 0000 0125 
; 0000 0126 return PORT.bits.b7;
	ROL  R30
	LDI  R30,0
	ROL  R30
_0x20A0007:
	ANDI R30,LOW(0x1)
	ADIW R28,3
	RET
; 0000 0127 }
;
;int odczytaj_parametr(int adres1, int adres2)
; 0000 012A {
_odczytaj_parametr:
; 0000 012B int z;
; 0000 012C z = 0;
	CALL SUBOPT_0x1
;	adres1 -> Y+4
;	adres2 -> Y+2
;	z -> R16,R17
; 0000 012D putchar(90);
	CALL SUBOPT_0x2
; 0000 012E putchar(165);
; 0000 012F putchar(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _putchar
; 0000 0130 putchar(131);
	LDI  R30,LOW(131)
	CALL SUBOPT_0x3
; 0000 0131 putchar(adres1);
; 0000 0132 putchar(adres2);
; 0000 0133 putchar(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar
; 0000 0134 getchar();
	CALL SUBOPT_0x4
; 0000 0135 getchar();
; 0000 0136 getchar();
; 0000 0137 getchar();
	CALL SUBOPT_0x4
; 0000 0138 getchar();
; 0000 0139 getchar();
; 0000 013A getchar();
	CALL SUBOPT_0x4
; 0000 013B getchar();
; 0000 013C z = getchar();
	MOV  R16,R30
	CLR  R17
; 0000 013D 
; 0000 013E 
; 0000 013F 
; 0000 0140 
; 0000 0141 
; 0000 0142 
; 0000 0143 
; 0000 0144 
; 0000 0145 
; 0000 0146 
; 0000 0147 
; 0000 0148 
; 0000 0149 return z;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0006
; 0000 014A }
;
;
;
;int czekaj_na_guzik_start(int adres)
; 0000 014F {
; 0000 0150 //48 to adres zmiennej 30
; 0000 0151 //16 to adres zmiennj 10
; 0000 0152 
; 0000 0153 int z;
; 0000 0154 z = 0;
;	adres -> Y+2
;	z -> R16,R17
; 0000 0155 putchar(90);
; 0000 0156 putchar(165);
; 0000 0157 putchar(4);
; 0000 0158 putchar(131);
; 0000 0159 putchar(0);
; 0000 015A putchar(adres);  //adres zmiennej - 30
; 0000 015B putchar(1);
; 0000 015C getchar();
; 0000 015D getchar();
; 0000 015E getchar();
; 0000 015F getchar();
; 0000 0160 getchar();
; 0000 0161 getchar();
; 0000 0162 getchar();
; 0000 0163 getchar();
; 0000 0164 z = getchar();
; 0000 0165 //itoa(z,dupa1);
; 0000 0166 //lcd_puts(dupa1);
; 0000 0167 
; 0000 0168 return z;
; 0000 0169 }
;
;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0170 {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0171 // Place your code here
; 0000 0172 //16,384 ms
; 0000 0173 sek1++;     //Ster 1
	LDI  R26,LOW(_sek1)
	LDI  R27,HIGH(_sek1)
	CALL SUBOPT_0x5
; 0000 0174 sek2++;     //ster 3
	LDI  R26,LOW(_sek2)
	LDI  R27,HIGH(_sek2)
	CALL SUBOPT_0x5
; 0000 0175 
; 0000 0176 
; 0000 0177 sek3++;     //ster 2
	LDI  R26,LOW(_sek3)
	LDI  R27,HIGH(_sek3)
	CALL SUBOPT_0x5
; 0000 0178 sek4++;     //ster 4
	LDI  R26,LOW(_sek4)
	LDI  R27,HIGH(_sek4)
	CALL SUBOPT_0x5
; 0000 0179 
; 0000 017A 
; 0000 017B //sek10++;
; 0000 017C 
; 0000 017D sek11++;  //do wyboru zacisku
	LDI  R26,LOW(_sek11)
	LDI  R27,HIGH(_sek11)
	CALL SUBOPT_0x5
; 0000 017E sek12++;  //do czasu przedmuchu
	LDI  R26,LOW(_sek12)
	LDI  R27,HIGH(_sek12)
	CALL SUBOPT_0x5
; 0000 017F 
; 0000 0180 sek13++;  //do czasu zatrzymania sie druciaka na gorze
	LDI  R26,LOW(_sek13)
	LDI  R27,HIGH(_sek13)
	CALL SUBOPT_0x5
; 0000 0181 
; 0000 0182 sek20++;
	LDI  R26,LOW(_sek20)
	LDI  R27,HIGH(_sek20)
	CALL SUBOPT_0x5
; 0000 0183 /*
; 0000 0184 if(PORTE.3 == 1)
; 0000 0185       {
; 0000 0186       czas_pracy_szczotki_drucianej++;
; 0000 0187       czas_pracy_krazka_sciernego++;
; 0000 0188       if(czas_pracy_szczotki_drucianej == 61 * 60 * 60)
; 0000 0189             {
; 0000 018A             czas_pracy_szczotki_drucianej = 0;
; 0000 018B             czas_pracy_szczotki_drucianej_h++;
; 0000 018C             }
; 0000 018D       if(czas_pracy_krazka_sciernego == 61 * 60 * 60)
; 0000 018E             {
; 0000 018F             czas_pracy_krazka_sciernego = 0;
; 0000 0190             czas_pracy_krazka_sciernego_h++;
; 0000 0191             }
; 0000 0192       }
; 0000 0193 
; 0000 0194 
; 0000 0195       //61 razy - 1s
; 0000 0196       //61 * 60 - 1 minuta
; 0000 0197       //61 * 60 * 60 - 1h
; 0000 0198 
; 0000 0199 */
; 0000 019A 
; 0000 019B }
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
; 0000 01A4 {
_komunikat_na_panel:
; 0000 01A5 int h;
; 0000 01A6 
; 0000 01A7 h = 0;
	CALL SUBOPT_0x1
;	*fmtstr -> Y+6
;	adres2 -> Y+4
;	adres22 -> Y+2
;	h -> R16,R17
; 0000 01A8 h = strlenf(fmtstr);
	CALL SUBOPT_0x6
	CALL _strlenf
	MOVW R16,R30
; 0000 01A9 h = h + 3;
	__ADDWRN 16,17,3
; 0000 01AA 
; 0000 01AB putchar(90);
	CALL SUBOPT_0x2
; 0000 01AC putchar(165);
; 0000 01AD putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL _putchar
; 0000 01AE putchar(130);  //82
	LDI  R30,LOW(130)
	CALL SUBOPT_0x3
; 0000 01AF putchar(adres2);    //
; 0000 01B0 putchar(adres22);  //
; 0000 01B1 printf(fmtstr);
	CALL SUBOPT_0x6
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 01B2 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;
;
;
;void wartosc_parametru_panelu(int wartosc, int adres1, int adres2)
; 0000 01B7 {
_wartosc_parametru_panelu:
; 0000 01B8 putchar(90);  //5A
;	wartosc -> Y+4
;	adres1 -> Y+2
;	adres2 -> Y+0
	CALL SUBOPT_0x2
; 0000 01B9 putchar(165); //A5
; 0000 01BA putchar(5);//05
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL SUBOPT_0x7
; 0000 01BB putchar(130);  //82    /
; 0000 01BC putchar(adres1);    //00
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
; 0000 01BD putchar(adres2);   //40
	CALL SUBOPT_0x8
; 0000 01BE putchar(0);    //00
; 0000 01BF putchar(wartosc);   //80
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _putchar
; 0000 01C0 }
_0x20A0006:
	ADIW R28,6
	RET
;
;
;void zaktualizuj_parametry_panelu()
; 0000 01C4 {
; 0000 01C5 
; 0000 01C6 /////////////////////////
; 0000 01C7 //wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
; 0000 01C8 
; 0000 01C9 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
; 0000 01CA 
; 0000 01CB //wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
; 0000 01CC 
; 0000 01CD //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
; 0000 01CE //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
; 0000 01CF //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
; 0000 01D0 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
; 0000 01D1 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
; 0000 01D2 
; 0000 01D3 //////////////////////////
; 0000 01D4 
; 0000 01D5 
; 0000 01D6 
; 0000 01D7 
; 0000 01D8 if(zaaktualizuj_ilosc_rzad2 == 1)
; 0000 01D9     {
; 0000 01DA     wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad2
; 0000 01DB     zaaktualizuj_ilosc_rzad2 = 0;
; 0000 01DC     }
; 0000 01DD }
;
;void komunikat_z_czytnika_kodow(char flash *fmtstr,int rzad, int na_plus_minus)
; 0000 01E0 {
_komunikat_z_czytnika_kodow:
; 0000 01E1 //na_plus_minus = 1;  to jest na plus
; 0000 01E2 //na_plus_minus = 0;  to jest na minus
; 0000 01E3 
; 0000 01E4 int h, adres1,adres11,adres2,adres22;
; 0000 01E5 
; 0000 01E6 h = 0;
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
; 0000 01E7 h = strlenf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOVW R16,R30
; 0000 01E8 h = h + 3;
	__ADDWRN 16,17,3
; 0000 01E9 
; 0000 01EA if(rzad == 1)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BRNE _0xE
; 0000 01EB    {
; 0000 01EC    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01ED    adres11 = 80;
	__GETWRN 20,21,80
; 0000 01EE    adres2 = 80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01EF    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01F0    }
; 0000 01F1 if(rzad == 2)
_0xE:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,2
	BRNE _0xF
; 0000 01F2    {
; 0000 01F3    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01F4    adres11 = 32;
	__GETWRN 20,21,32
; 0000 01F5    adres2 = 64;
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01F6    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01F7    }
; 0000 01F8 
; 0000 01F9 putchar(90);
_0xF:
	CALL SUBOPT_0x2
; 0000 01FA putchar(165);
; 0000 01FB putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL SUBOPT_0x7
; 0000 01FC putchar(130);  //82
; 0000 01FD putchar(adres1);    //
	ST   -Y,R18
	CALL _putchar
; 0000 01FE putchar(adres11);  //
	ST   -Y,R20
	CALL _putchar
; 0000 01FF printf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 0200 
; 0000 0201 
; 0000 0202 if(rzad == 1 & macierz_zaciskow[rzad]==0)
	CALL SUBOPT_0x9
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0xA
	CALL __GETW1P
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x10
; 0000 0203     {
; 0000 0204     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xB
; 0000 0205     komunikat_na_panel("Zacisk nie zmierzony u Wykonawcy",adres2,adres22);
	__POINTW1FN _0x0,49
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 0206     }
; 0000 0207 
; 0000 0208 if(rzad == 1 & na_plus_minus == 1)
_0x10:
	CALL SUBOPT_0x9
	CALL SUBOPT_0xE
	BREQ _0x11
; 0000 0209     {
; 0000 020A     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xB
; 0000 020B     //komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
; 0000 020C     komunikat_na_panel("Kly w kierunku prawej strony",adres2,adres22);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 020D     }
; 0000 020E 
; 0000 020F if(rzad == 1 & na_plus_minus == 0)
_0x11:
	CALL SUBOPT_0x9
	CALL SUBOPT_0xF
	BREQ _0x12
; 0000 0210     {
; 0000 0211     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xB
; 0000 0212     //komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
; 0000 0213     komunikat_na_panel("Kly w kierunku lewej strony",adres2,adres22);
	__POINTW1FN _0x0,111
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 0214     }
; 0000 0215 
; 0000 0216 
; 0000 0217 if(rzad == 2 & na_plus_minus == 1)
_0x12:
	CALL SUBOPT_0x10
	CALL SUBOPT_0xE
	BREQ _0x13
; 0000 0218     {
; 0000 0219     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xB
; 0000 021A     //komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
; 0000 021B     komunikat_na_panel("Kly w kierunku lewej strony",adres2,adres22);
	__POINTW1FN _0x0,111
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 021C     }
; 0000 021D 
; 0000 021E if(rzad == 2 & na_plus_minus == 0)
_0x13:
	CALL SUBOPT_0x10
	CALL SUBOPT_0xF
	BREQ _0x14
; 0000 021F     {
; 0000 0220     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0xB
; 0000 0221     //komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
; 0000 0222     komunikat_na_panel("Kly w kierunku prawej strony",adres2,adres22);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 0223     }
; 0000 0224 
; 0000 0225 
; 0000 0226 }
_0x14:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;
;void zerowanie_pam_wew()
; 0000 0229 {
; 0000 022A /*
; 0000 022B if(czas_pracy_szczotki_drucianej_h >= 255 | czas_pracy_krazka_sciernego_h >=255 | czas_pracy_krazka_sciernego_stala >= 255 | czas_pracy_szczotki_drucianej_stala >= 255 |
; 0000 022C    szczotka_druciana_ilosc_cykli >= 255 | krazek_scierny_ilosc_cykli >= 255 | krazek_scierny_cykl_po_okregu_ilosc >=255)
; 0000 022D      {
; 0000 022E      czas_pracy_szczotki_drucianej_h = 0;
; 0000 022F      czas_pracy_szczotki_drucianej = 0;
; 0000 0230      czas_pracy_krazka_sciernego_h = 0;
; 0000 0231      czas_pracy_krazka_sciernego = 0;
; 0000 0232      czas_pracy_krazka_sciernego_stala = 5;
; 0000 0233      czas_pracy_szczotki_drucianej_stala = 5;
; 0000 0234      szczotka_druciana_ilosc_cykli = 3;
; 0000 0235      krazek_scierny_ilosc_cykli = 3;
; 0000 0236      krazek_scierny_cykl_po_okregu_ilosc = 3;
; 0000 0237      }
; 0000 0238 */
; 0000 0239 
; 0000 023A /*
; 0000 023B if(czas_pracy_krazka_sciernego_h >= 255)
; 0000 023C      {
; 0000 023D      czas_pracy_krazka_sciernego_h = 0;
; 0000 023E      czas_pracy_krazka_sciernego = 0;
; 0000 023F      }
; 0000 0240 if(czas_pracy_krazka_sciernego_stala >= 255)
; 0000 0241      czas_pracy_krazka_sciernego_stala = 5;
; 0000 0242 
; 0000 0243 if(czas_pracy_szczotki_drucianej_stala >= 255)
; 0000 0244      czas_pracy_szczotki_drucianej_stala = 5;
; 0000 0245 
; 0000 0246 if(szczotka_druciana_ilosc_cykli >= 255)
; 0000 0247 
; 0000 0248 if(krazek_scierny_ilosc_cykli >= 255)
; 0000 0249 
; 0000 024A if(krazek_scierny_cykl_po_okregu_ilosc >=255)
; 0000 024B */
; 0000 024C 
; 0000 024D }
;
;
;void odpytaj_parametry_panelu()
; 0000 0251 {
_odpytaj_parametry_panelu:
; 0000 0252 /* to wylaczam tylko do testow w switniakch
; 0000 0253 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
; 0000 0254     start = odczytaj_parametr(0,64);
; 0000 0255 il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
; 0000 0256 il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
; 0000 0257 */
; 0000 0258 
; 0000 0259 
; 0000 025A szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 025B                                                 //2090
; 0000 025C krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
; 0000 025D                                                     //3000
; 0000 025E krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
; 0000 025F 
; 0000 0260 //////////////////////////////////////////////
; 0000 0261 czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
; 0000 0262 
; 0000 0263 czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
; 0000 0264 
; 0000 0265 
; 0000 0266 czas_pracy_szczotki_drucianej_h = odczytaj_parametr(0,144);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0267 
; 0000 0268 czas_pracy_krazka_sciernego_h_34 = odczytaj_parametr(96,48);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x11
	RCALL _odczytaj_parametr
	CALL SUBOPT_0x19
; 0000 0269 czas_pracy_krazka_sciernego_h_36 = odczytaj_parametr(96,64);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x12
	CALL SUBOPT_0x1A
; 0000 026A czas_pracy_krazka_sciernego_h_38 = odczytaj_parametr(96,80);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
; 0000 026B czas_pracy_krazka_sciernego_h_41 = odczytaj_parametr(96,96);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x18
	RCALL _odczytaj_parametr
	CALL SUBOPT_0x1D
; 0000 026C czas_pracy_krazka_sciernego_h_43 = odczytaj_parametr(96,112);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
; 0000 026D 
; 0000 026E //////////////////////////////////////////////////////////
; 0000 026F 
; 0000 0270 test_geometryczny_rzad_1 = odczytaj_parametr(48,80);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x1B
	STS  _test_geometryczny_rzad_1,R30
	STS  _test_geometryczny_rzad_1+1,R31
; 0000 0271 
; 0000 0272 test_geometryczny_rzad_2 = odczytaj_parametr(48,96);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x18
	RCALL _odczytaj_parametr
	STS  _test_geometryczny_rzad_2,R30
	STS  _test_geometryczny_rzad_2+1,R31
; 0000 0273 
; 0000 0274 srednica_krazka_sciernego = odczytaj_parametr(48,112);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x20
; 0000 0275 
; 0000 0276 ruch_haos = odczytaj_parametr(48,144);
	CALL SUBOPT_0x16
	STS  _ruch_haos,R30
	STS  _ruch_haos+1,R31
; 0000 0277 
; 0000 0278 tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1E
	MOVW R10,R30
; 0000 0279                                                 //2050
; 0000 027A //zerowanie_pam_wew();
; 0000 027B 
; 0000 027C }
	RET
;
;void wyrrrjscia_i_wejscia_opis()
; 0000 027F {
; 0000 0280 
; 0000 0281 
; 0000 0282 //IN0
; 0000 0283 
; 0000 0284 //komunikacja miedzy slave a master
; 0000 0285 //sprawdz_pin0(PORTHH,0x73)
; 0000 0286 //sprawdz_pin1(PORTHH,0x73)
; 0000 0287 //sprawdz_pin2(PORTHH,0x73)
; 0000 0288 //sprawdz_pin3(PORTHH,0x73)
; 0000 0289 //sprawdz_pin4(PORTHH,0x73)
; 0000 028A //sprawdz_pin5(PORTHH,0x73)
; 0000 028B //sprawdz_pin6(PORTHH,0x73)
; 0000 028C //sprawdz_pin7(PORTHH,0x73)
; 0000 028D 
; 0000 028E //IN1
; 0000 028F //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 0290 //sprawdz_pin1(PORTJJ,0x79)  AREA   STEROWNIK1
; 0000 0291 //sprawdz_pin2(PORTJJ,0x79)  SETON  STEROWNIK1
; 0000 0292 //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 0293 //sprawdz_pin4(PORTJJ,0x79)  SVRE   STEROWNIK1
; 0000 0294 //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 0295 //sprawdz_pin6(PORTJJ,0x79)  czujnik cisnienia
; 0000 0296 //sprawdz_pin7(PORTJJ,0x79)
; 0000 0297 
; 0000 0298 //IN2
; 0000 0299 //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 029A //sprawdz_pin1(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK3
; 0000 029B //sprawdz_pin2(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK3
; 0000 029C //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 029D //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 029E //sprawdz_pin5(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK4
; 0000 029F //sprawdz_pin6(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK4
; 0000 02A0 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 02A1 
; 0000 02A2 //IN3
; 0000 02A3 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 02A4 //sprawdz_pin1(PORTLL,0x71)  AREA   STEROWNIK2
; 0000 02A5 //sprawdz_pin2(PORTLL,0x71)  SETON  STEROWNIK2
; 0000 02A6 //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 02A7 //sprawdz_pin4(PORTLL,0x71)  SVRE   STEROWNIK2
; 0000 02A8 //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 02A9 //sprawdz_pin6(PORTLL,0x71)  S6A przek³adanie rzedow
; 0000 02AA //sprawdz_pin7(PORTLL,0x71)  S6B przekladanie rzedow
; 0000 02AB 
; 0000 02AC //IN4
; 0000 02AD //sprawdz_pin0(PORTMM,0x77) J2  czujnik indukcyjny domkniecia pokrywy
; 0000 02AE //sprawdz_pin1(PORTMM,0x77) J3  czujnik indukcyjny domkniecia pokrywy
; 0000 02AF //sprawdz_pin2(PORTMM,0x77)
; 0000 02B0 //sprawdz_pin3(PORTMM,0x77)
; 0000 02B1 //sprawdz_pin4(PORTMM,0x77)
; 0000 02B2 //sprawdz_pin5(PORTMM,0x77)
; 0000 02B3 //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 02B4 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 02B5 
; 0000 02B6 //sterownik 1 i sterownik 3 - krazek scierny
; 0000 02B7 //sterownik 2 i sterownik 4 - druciak
; 0000 02B8 
; 0000 02B9 //OUT
; 0000 02BA //PORTA.0   IN0  STEROWNIK1        OUT 1
; 0000 02BB //PORTA.1   IN1  STEROWNIK1
; 0000 02BC //PORTA.2   IN2  STEROWNIK1
; 0000 02BD //PORTA.3   IN3  STEROWNIK1
; 0000 02BE //PORTA.4   IN4  STEROWNIK1
; 0000 02BF //PORTA.5   IN5  STEROWNIK1
; 0000 02C0 //PORTA.6   IN6  STEROWNIK1
; 0000 02C1 //PORTA.7   IN7  STEROWNIK1
; 0000 02C2 
; 0000 02C3 //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 02C4 //PORTB.1   IN1  STEROWNIK4
; 0000 02C5 //PORTB.2   IN2  STEROWNIK4
; 0000 02C6 //PORTB.3   IN3  STEROWNIK4
; 0000 02C7 //PORTB.4   4B CEWKA przedmuch osi, byl, juz poloczone z B.6, teraz juz setup poziome
; 0000 02C8 //PORTB.5   DRIVE  STEROWNIK4
; 0000 02C9 //PORTB.6   swiatlo zielone
; 0000 02CA //PORTB.7   IN5 STEROWNIK 3
; 0000 02CB 
; 0000 02CC //PORTC.0   IN0  STEROWNIK2        OUT 3
; 0000 02CD //PORTC.1   IN1  STEROWNIK2
; 0000 02CE //PORTC.2   IN2  STEROWNIK2
; 0000 02CF //PORTC.3   IN3  STEROWNIK2
; 0000 02D0 //PORTC.4   IN4  STEROWNIK2
; 0000 02D1 //PORTC.5   IN5  STEROWNIK2
; 0000 02D2 //PORTC.6   IN6  STEROWNIK2
; 0000 02D3 //PORTC.7   IN7  STEROWNIK2
; 0000 02D4 
; 0000 02D5 //PORTD.0  SDA                     OUT 2
; 0000 02D6 //PORTD.1  SCL
; 0000 02D7 //PORTD.2  SETUP   STEROWNIK1 STEROWNIK 2 STEROIWNIK 3 STEROWNIK 4
; 0000 02D8 //PORTD.3  DRIVE   STEROWNIK1
; 0000 02D9 //PORTD.4  IN8 STEROWNIK1
; 0000 02DA //PORTD.5  IN8 STEROWNIK2
; 0000 02DB //PORTD.6  DRIVE   STEROWNIK2
; 0000 02DC //PORTD.7  swiatlo czerwone i jednoczesnie HOLD
; 0000 02DD 
; 0000 02DE //PORTE.0
; 0000 02DF //PORTE.1
; 0000 02E0 //PORTE.2  1A CEWKA szczotka druciana                    OUT 6
; 0000 02E1 //PORTE.3  1B CEWKA krazek scierny
; 0000 02E2 //PORTE.4  IN4  STEROWNIK4
; 0000 02E3 //PORTE.5  IN5  STEROWNIK4   ///////////////////////////////////////////////teraz tu bêdzie przedmuch kana³ B
; 0000 02E4 //PORTE.6  2A CEWKA przerzucanie docisku zaciskow
; 0000 02E5 //PORTE.7  3A CEWKA zacisnij zaciski
; 0000 02E6 
; 0000 02E7 //PORTF.0   IN0  STEROWNIK3             OUT 4
; 0000 02E8 //PORTF.1   IN1  STEROWNIK3
; 0000 02E9 //PORTF.2   IN2  STEROWNIK3
; 0000 02EA //PORTF.3   IN3  STEROWNIK3
; 0000 02EB //PORTF.4   4A CEWKA przedmuch zaciskow
; 0000 02EC //PORTF.5   DRIVE  STEROWNIK3
; 0000 02ED //PORTF.6   swiatlo zolte
; 0000 02EE //PORTF.7   IN4 STEROWNIK 3
; 0000 02EF 
; 0000 02F0 
; 0000 02F1 
; 0000 02F2  //PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 02F3 //PORTF = PORT_F.byte;
; 0000 02F4 //PORTB.6 = 1;  //przedmuch osi
; 0000 02F5 //PORTE.2 = 1;  //szlifierka 1
; 0000 02F6 //PORTE.3 = 1;  //szlifierka 2
; 0000 02F7 //PORTE.6 = 0;  //zacisniety rzad 1
; 0000 02F8 //PORTE.6 = 1;  //zacisniety rzad 2
; 0000 02F9 //PORTE.7 = 0;    //zacisnij zaciski
; 0000 02FA 
; 0000 02FB 
; 0000 02FC //macierz_zaciskow[rzad]=44; brak
; 0000 02FD //macierz_zaciskow[rzad]=48; brak
; 0000 02FE //macierz_zaciskow[rzad]=76  brak
; 0000 02FF //macierz_zaciskow[rzad]=80; brak
; 0000 0300 //macierz_zaciskow[rzad]=92; brak
; 0000 0301 //macierz_zaciskow[rzad]=96;  brak
; 0000 0302 //macierz_zaciskow[rzad]=107; brak
; 0000 0303 //macierz_zaciskow[rzad]=111; brak
; 0000 0304 
; 0000 0305 
; 0000 0306 
; 0000 0307 
; 0000 0308 /*
; 0000 0309 
; 0000 030A //testy parzystych i nieparzystych IN0-IN8
; 0000 030B //testy port/pin
; 0000 030C //sterownik 3
; 0000 030D //PORTF.0   IN0  STEROWNIK3
; 0000 030E //PORTF.1   IN1  STEROWNIK3
; 0000 030F //PORTF.2   IN2  STEROWNIK3
; 0000 0310 //PORTF.3   IN3  STEROWNIK3
; 0000 0311 //PORTF.7   IN4 STEROWNIK 3
; 0000 0312 //PORTB.7   IN5 STEROWNIK 3
; 0000 0313 
; 0000 0314 
; 0000 0315 PORT_F.bits.b0 = 0;
; 0000 0316 PORT_F.bits.b1 = 1;
; 0000 0317 PORT_F.bits.b2 = 0;
; 0000 0318 PORT_F.bits.b3 = 1;
; 0000 0319 PORT_F.bits.b7 = 0;
; 0000 031A PORTF = PORT_F.byte;
; 0000 031B PORTB.7 = 1;
; 0000 031C 
; 0000 031D //sterownik 4
; 0000 031E 
; 0000 031F //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 0320 //PORTB.1   IN1  STEROWNIK4
; 0000 0321 //PORTB.2   IN2  STEROWNIK4
; 0000 0322 //PORTB.3   IN3  STEROWNIK4
; 0000 0323 //PORTE.4  IN4  STEROWNIK4
; 0000 0324 
; 0000 0325 
; 0000 0326 PORTB.0 = 0;
; 0000 0327 PORTB.1 = 1;
; 0000 0328 PORTB.2 = 0;
; 0000 0329 PORTB.3 = 1;
; 0000 032A PORTE.4 = 0;
; 0000 032B 
; 0000 032C 
; 0000 032D //ster 1
; 0000 032E PORTA.0 = 0;   //IN0  STEROWNIK1        OUT 1
; 0000 032F PORTA.1 = 1;  //IN1  STEROWNIK1
; 0000 0330 PORTA.2 = 0;  // IN2  STEROWNIK1
; 0000 0331 PORTA.3 = 1;  //IN3  STEROWNIK1
; 0000 0332 PORTA.4 = 0;  // IN4  STEROWNIK1
; 0000 0333 PORTA.5 = 1;  //IN5  STEROWNIK1
; 0000 0334 PORTA.6 = 0;   //IN6  STEROWNIK1
; 0000 0335 PORTA.7 = 1;  //IN7  STEROWNIK1
; 0000 0336 PORTD.4 = 0; //IN8 STEROWNIK1
; 0000 0337 
; 0000 0338 
; 0000 0339 
; 0000 033A //sterownik 2
; 0000 033B PORTC.0 = 0;   //IN0  STEROWNIK2        OUT 3
; 0000 033C PORTC.1  = 1;  //IN1  STEROWNIK2
; 0000 033D PORTC.2 = 0;    //IN2  STEROWNIK2
; 0000 033E PORTC.3= 1;   //IN3  STEROWNIK2
; 0000 033F PORTC.4 = 0;   // IN4  STEROWNIK2
; 0000 0340 PORTC.5= 1;   //IN5  STEROWNIK2
; 0000 0341 PORTC.6 = 0;   // IN6  STEROWNIK2
; 0000 0342 PORTC.7= 1;   //IN7  STEROWNIK2
; 0000 0343 PORTD.5 = 0;  //IN8 STEROWNIK2
; 0000 0344 
; 0000 0345 */
; 0000 0346 
; 0000 0347 }
;
;void sprawdz_cisnienie()
; 0000 034A {
; 0000 034B int i;
; 0000 034C i = 0;
;	i -> R16,R17
; 0000 034D //i = 1;
; 0000 034E 
; 0000 034F while(i == 0)
; 0000 0350     {
; 0000 0351     if(sprawdz_pin6(PORTJJ,0x79) == 0)
; 0000 0352         {
; 0000 0353         i = 1;
; 0000 0354         if(cisnienie_sprawdzone == 0)
; 0000 0355             {
; 0000 0356             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 0357             cisnienie_sprawdzone = 1;
; 0000 0358             }
; 0000 0359 
; 0000 035A         }
; 0000 035B     else
; 0000 035C         {
; 0000 035D         i = 0;
; 0000 035E         cisnienie_sprawdzone = 0;
; 0000 035F         komunikat_na_panel("                                                ",adr1,adr2);
; 0000 0360         komunikat_na_panel("Cisnienie za male - mniejsze niz 6 bar",adr1,adr2);
; 0000 0361 
; 0000 0362         }
; 0000 0363     }
; 0000 0364 }
;
;
;int odczyt_wybranego_zacisku()
; 0000 0368 {                         //11
_odczyt_wybranego_zacisku:
; 0000 0369 int rzad;
; 0000 036A 
; 0000 036B PORT_CZYTNIK.bits.b0 = sprawdz_pin0(PORTHH,0x73);
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	CALL SUBOPT_0x21
	RCALL _sprawdz_pin0
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFE
	CALL SUBOPT_0x22
; 0000 036C PORT_CZYTNIK.bits.b1 = sprawdz_pin1(PORTHH,0x73);
	RCALL _sprawdz_pin1
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFD
	CALL SUBOPT_0x22
; 0000 036D PORT_CZYTNIK.bits.b2 = sprawdz_pin2(PORTHH,0x73);
	RCALL _sprawdz_pin2
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFB
	CALL SUBOPT_0x22
; 0000 036E PORT_CZYTNIK.bits.b3 = sprawdz_pin3(PORTHH,0x73);
	RCALL _sprawdz_pin3
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0XF7
	CALL SUBOPT_0x22
; 0000 036F PORT_CZYTNIK.bits.b4 = sprawdz_pin4(PORTHH,0x73);
	RCALL _sprawdz_pin4
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xEF
	CALL SUBOPT_0x22
; 0000 0370 PORT_CZYTNIK.bits.b5 = sprawdz_pin5(PORTHH,0x73);
	RCALL _sprawdz_pin5
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xDF
	CALL SUBOPT_0x22
; 0000 0371 PORT_CZYTNIK.bits.b6 = sprawdz_pin6(PORTHH,0x73);
	RCALL _sprawdz_pin6
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xBF
	CALL SUBOPT_0x22
; 0000 0372 PORT_CZYTNIK.bits.b7 = sprawdz_pin7(PORTHH,0x73);
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
; 0000 0373 
; 0000 0374 rzad = odczytaj_parametr(32,128);       //20,80
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	RCALL _odczytaj_parametr
	MOVW R16,R30
; 0000 0375 
; 0000 0376 if(PORT_CZYTNIK.byte == 0x01)
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1)
	BRNE _0x1B
; 0000 0377     {
; 0000 0378     macierz_zaciskow[rzad]=1;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
; 0000 0379     komunikat_z_czytnika_kodow("86-0170",rzad,1);
	__POINTW1FN _0x0,178
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 037A     srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 037B     }
; 0000 037C 
; 0000 037D if(PORT_CZYTNIK.byte == 0x02)
_0x1B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2)
	BRNE _0x1C
; 0000 037E     {
; 0000 037F     macierz_zaciskow[rzad]=2;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
; 0000 0380     komunikat_z_czytnika_kodow("86-1043",rzad,0);
	__POINTW1FN _0x0,186
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 0381     srednica_wew_korpusu = 34;
; 0000 0382     }
; 0000 0383 
; 0000 0384 if(PORT_CZYTNIK.byte == 0x03)
_0x1C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3)
	BRNE _0x1D
; 0000 0385     {
; 0000 0386       macierz_zaciskow[rzad]=3;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   X+,R30
	ST   X,R31
; 0000 0387       komunikat_z_czytnika_kodow("86-1675",rzad,0);
	__POINTW1FN _0x0,194
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 0388       srednica_wew_korpusu =38;
; 0000 0389     }
; 0000 038A 
; 0000 038B if(PORT_CZYTNIK.byte == 0x04)
_0x1D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4)
	BRNE _0x1E
; 0000 038C     {
; 0000 038D 
; 0000 038E       macierz_zaciskow[rzad]=4;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   X+,R30
	ST   X,R31
; 0000 038F       komunikat_z_czytnika_kodow("86-2098",rzad,0);
	__POINTW1FN _0x0,202
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 0390       srednica_wew_korpusu = 38;
; 0000 0391     }
; 0000 0392 if(PORT_CZYTNIK.byte == 0x05)
_0x1E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5)
	BRNE _0x1F
; 0000 0393     {
; 0000 0394       macierz_zaciskow[rzad]=5;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   X+,R30
	ST   X,R31
; 0000 0395       komunikat_z_czytnika_kodow("87-0170",rzad,0);
	__POINTW1FN _0x0,210
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 0396       srednica_wew_korpusu = 38;
; 0000 0397     }
; 0000 0398 if(PORT_CZYTNIK.byte == 0x06)
_0x1F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6)
	BRNE _0x20
; 0000 0399     {
; 0000 039A       macierz_zaciskow[rzad]=6;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   X+,R30
	ST   X,R31
; 0000 039B       komunikat_z_czytnika_kodow("87-1043",rzad,1);
	__POINTW1FN _0x0,218
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 039C       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 039D     }
; 0000 039E 
; 0000 039F if(PORT_CZYTNIK.byte == 0x07)
_0x20:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7)
	BRNE _0x21
; 0000 03A0     {
; 0000 03A1       macierz_zaciskow[rzad]=7;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   X+,R30
	ST   X,R31
; 0000 03A2       komunikat_z_czytnika_kodow("87-1675",rzad,1);
	__POINTW1FN _0x0,226
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 03A3       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 03A4     }
; 0000 03A5 
; 0000 03A6 if(PORT_CZYTNIK.byte == 0x08)
_0x21:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8)
	BRNE _0x22
; 0000 03A7     {
; 0000 03A8       macierz_zaciskow[rzad]=8;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   X+,R30
	ST   X,R31
; 0000 03A9       komunikat_z_czytnika_kodow("87-2098",rzad,1);
	__POINTW1FN _0x0,234
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 03AA       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 03AB     }
; 0000 03AC if(PORT_CZYTNIK.byte == 0x09)
_0x22:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x9)
	BRNE _0x23
; 0000 03AD     {
; 0000 03AE       macierz_zaciskow[rzad]=9;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   X+,R30
	ST   X,R31
; 0000 03AF       komunikat_z_czytnika_kodow("86-0192",rzad,0);
	__POINTW1FN _0x0,242
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 03B0       srednica_wew_korpusu = 38;
; 0000 03B1     }
; 0000 03B2 if(PORT_CZYTNIK.byte == 0x0A)
_0x23:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xA)
	BRNE _0x24
; 0000 03B3     {
; 0000 03B4       macierz_zaciskow[rzad]=10;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   X+,R30
	ST   X,R31
; 0000 03B5       komunikat_z_czytnika_kodow("86-1054",rzad,0);
	__POINTW1FN _0x0,250
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 03B6       srednica_wew_korpusu = 41;
; 0000 03B7     }
; 0000 03B8 if(PORT_CZYTNIK.byte == 0x0B)
_0x24:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xB)
	BRNE _0x25
; 0000 03B9     {
; 0000 03BA       macierz_zaciskow[rzad]=11;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   X+,R30
	ST   X,R31
; 0000 03BB       komunikat_z_czytnika_kodow("86-1676",rzad,0);
	__POINTW1FN _0x0,258
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 03BC       srednica_wew_korpusu = 41;
; 0000 03BD     }
; 0000 03BE if(PORT_CZYTNIK.byte == 0x0C)
_0x25:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xC)
	BRNE _0x26
; 0000 03BF     {
; 0000 03C0       macierz_zaciskow[rzad]=12;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   X+,R30
	ST   X,R31
; 0000 03C1       komunikat_z_czytnika_kodow("86-2132",rzad,1);
	__POINTW1FN _0x0,266
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 03C2       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 03C3     }
; 0000 03C4 if(PORT_CZYTNIK.byte == 0x0D)
_0x26:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xD)
	BRNE _0x27
; 0000 03C5     {
; 0000 03C6       macierz_zaciskow[rzad]=13;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   X+,R30
	ST   X,R31
; 0000 03C7       komunikat_z_czytnika_kodow("87-0192",rzad,1);
	__POINTW1FN _0x0,274
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 03C8       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 03C9     }
; 0000 03CA if(PORT_CZYTNIK.byte == 0x0E)
_0x27:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xE)
	BRNE _0x28
; 0000 03CB     {
; 0000 03CC       macierz_zaciskow[rzad]=14;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   X+,R30
	ST   X,R31
; 0000 03CD       komunikat_z_czytnika_kodow("87-1054",rzad,1);
	__POINTW1FN _0x0,282
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 03CE       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 03CF     }
; 0000 03D0 
; 0000 03D1 if(PORT_CZYTNIK.byte == 0x0F)
_0x28:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xF)
	BRNE _0x29
; 0000 03D2     {
; 0000 03D3       macierz_zaciskow[rzad]=15;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   X+,R30
	ST   X,R31
; 0000 03D4       komunikat_z_czytnika_kodow("87-1676",rzad,1);
	__POINTW1FN _0x0,290
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 03D5       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 03D6     }
; 0000 03D7 if(PORT_CZYTNIK.byte == 0x10)
_0x29:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x10)
	BRNE _0x2A
; 0000 03D8     {
; 0000 03D9       macierz_zaciskow[rzad]=16;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   X+,R30
	ST   X,R31
; 0000 03DA       komunikat_z_czytnika_kodow("87-2132",rzad,0);
	__POINTW1FN _0x0,298
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 03DB       srednica_wew_korpusu = 41;
; 0000 03DC     }
; 0000 03DD 
; 0000 03DE if(PORT_CZYTNIK.byte == 0x11)
_0x2A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x11)
	BRNE _0x2B
; 0000 03DF     {
; 0000 03E0       macierz_zaciskow[rzad]=17;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   X+,R30
	ST   X,R31
; 0000 03E1       komunikat_z_czytnika_kodow("86-0193",rzad,0);
	__POINTW1FN _0x0,306
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 03E2       srednica_wew_korpusu = 38;
; 0000 03E3     }
; 0000 03E4 
; 0000 03E5 if(PORT_CZYTNIK.byte == 0x12)
_0x2B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x12)
	BRNE _0x2C
; 0000 03E6     {
; 0000 03E7       macierz_zaciskow[rzad]=18;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	ST   X+,R30
	ST   X,R31
; 0000 03E8       komunikat_z_czytnika_kodow("86-1216",rzad,0);
	__POINTW1FN _0x0,314
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 03E9       srednica_wew_korpusu = 34;
; 0000 03EA     }
; 0000 03EB if(PORT_CZYTNIK.byte == 0x13)
_0x2C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x13)
	BRNE _0x2D
; 0000 03EC     {
; 0000 03ED       macierz_zaciskow[rzad]=19;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	ST   X+,R30
	ST   X,R31
; 0000 03EE       komunikat_z_czytnika_kodow("86-1832",rzad,0);
	__POINTW1FN _0x0,322
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 03EF       srednica_wew_korpusu = 41;
; 0000 03F0     }
; 0000 03F1 
; 0000 03F2 if(PORT_CZYTNIK.byte == 0x14)
_0x2D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x14)
	BRNE _0x2E
; 0000 03F3     {
; 0000 03F4       macierz_zaciskow[rzad]=20;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   X+,R30
	ST   X,R31
; 0000 03F5       komunikat_z_czytnika_kodow("86-2174",rzad,0);
	__POINTW1FN _0x0,330
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 03F6       srednica_wew_korpusu = 34;
; 0000 03F7     }
; 0000 03F8 if(PORT_CZYTNIK.byte == 0x15)
_0x2E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x15)
	BRNE _0x2F
; 0000 03F9     {
; 0000 03FA       macierz_zaciskow[rzad]=21;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	ST   X+,R30
	ST   X,R31
; 0000 03FB       komunikat_z_czytnika_kodow("87-0193",rzad,1);
	__POINTW1FN _0x0,338
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 03FC       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 03FD     }
; 0000 03FE 
; 0000 03FF if(PORT_CZYTNIK.byte == 0x16)
_0x2F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x16)
	BRNE _0x30
; 0000 0400     {
; 0000 0401       macierz_zaciskow[rzad]=22;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	ST   X+,R30
	ST   X,R31
; 0000 0402       komunikat_z_czytnika_kodow("87-1216",rzad,1);
	__POINTW1FN _0x0,346
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0403       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 0404     }
; 0000 0405 if(PORT_CZYTNIK.byte == 0x17)
_0x30:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x17)
	BRNE _0x31
; 0000 0406     {
; 0000 0407       macierz_zaciskow[rzad]=23;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	ST   X+,R30
	ST   X,R31
; 0000 0408       komunikat_z_czytnika_kodow("87-1832",rzad,1);
	__POINTW1FN _0x0,354
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0409       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 040A     }
; 0000 040B 
; 0000 040C if(PORT_CZYTNIK.byte == 0x18)
_0x31:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x18)
	BRNE _0x32
; 0000 040D     {
; 0000 040E       macierz_zaciskow[rzad]=24;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	ST   X+,R30
	ST   X,R31
; 0000 040F       komunikat_z_czytnika_kodow("87-2174",rzad,1);
	__POINTW1FN _0x0,362
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0410       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 0411     }
; 0000 0412 if(PORT_CZYTNIK.byte == 0x19)
_0x32:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x19)
	BRNE _0x33
; 0000 0413     {
; 0000 0414       macierz_zaciskow[rzad]=25;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	ST   X+,R30
	ST   X,R31
; 0000 0415       komunikat_z_czytnika_kodow("86-0194",rzad,0);
	__POINTW1FN _0x0,370
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 0416       srednica_wew_korpusu = 41;
; 0000 0417     }
; 0000 0418 
; 0000 0419 if(PORT_CZYTNIK.byte == 0x1A)
_0x33:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1A)
	BRNE _0x34
; 0000 041A     {
; 0000 041B       macierz_zaciskow[rzad]=26;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	ST   X+,R30
	ST   X,R31
; 0000 041C       komunikat_z_czytnika_kodow("86-1341",rzad,0);
	__POINTW1FN _0x0,378
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 041D       srednica_wew_korpusu = 34;
; 0000 041E     }
; 0000 041F if(PORT_CZYTNIK.byte == 0x1B)
_0x34:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1B)
	BRNE _0x35
; 0000 0420     {
; 0000 0421       macierz_zaciskow[rzad]=27;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(27)
	LDI  R31,HIGH(27)
	ST   X+,R30
	ST   X,R31
; 0000 0422       komunikat_z_czytnika_kodow("86-1833",rzad,0);
	__POINTW1FN _0x0,386
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 0423       srednica_wew_korpusu = 41;
; 0000 0424     }
; 0000 0425 if(PORT_CZYTNIK.byte == 0x1C)
_0x35:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1C)
	BRNE _0x36
; 0000 0426     {
; 0000 0427       macierz_zaciskow[rzad]=28;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	ST   X+,R30
	ST   X,R31
; 0000 0428       komunikat_z_czytnika_kodow("86-2180",rzad,1);
	__POINTW1FN _0x0,394
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0429       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 042A     }
; 0000 042B if(PORT_CZYTNIK.byte == 0x1D)
_0x36:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1D)
	BRNE _0x37
; 0000 042C     {
; 0000 042D       macierz_zaciskow[rzad]=29;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	ST   X+,R30
	ST   X,R31
; 0000 042E       komunikat_z_czytnika_kodow("87-0194",rzad,1);
	__POINTW1FN _0x0,402
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 042F       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 0430     }
; 0000 0431 
; 0000 0432 if(PORT_CZYTNIK.byte == 0x1E)
_0x37:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1E)
	BRNE _0x38
; 0000 0433     {
; 0000 0434       macierz_zaciskow[rzad]=30;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   X+,R30
	ST   X,R31
; 0000 0435       komunikat_z_czytnika_kodow("87-1341",rzad,1);
	__POINTW1FN _0x0,410
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0436       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 0437     }
; 0000 0438 if(PORT_CZYTNIK.byte == 0x1F)
_0x38:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1F)
	BRNE _0x39
; 0000 0439     {
; 0000 043A       macierz_zaciskow[rzad]=31;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	ST   X+,R30
	ST   X,R31
; 0000 043B       komunikat_z_czytnika_kodow("87-1833",rzad,1);
	__POINTW1FN _0x0,418
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 043C       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 043D     }
; 0000 043E 
; 0000 043F if(PORT_CZYTNIK.byte == 0x20)
_0x39:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x20)
	BRNE _0x3A
; 0000 0440     {
; 0000 0441       macierz_zaciskow[rzad]=32;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   X+,R30
	ST   X,R31
; 0000 0442       komunikat_z_czytnika_kodow("87-2180",rzad,0);
	__POINTW1FN _0x0,426
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 0443       srednica_wew_korpusu = 41;
; 0000 0444     }
; 0000 0445 if(PORT_CZYTNIK.byte == 0x21)
_0x3A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x21)
	BRNE _0x3B
; 0000 0446     {
; 0000 0447       macierz_zaciskow[rzad]=33;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	ST   X+,R30
	ST   X,R31
; 0000 0448       komunikat_z_czytnika_kodow("86-0663",rzad,1);
	__POINTW1FN _0x0,434
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0449       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x2D
; 0000 044A     }
; 0000 044B 
; 0000 044C if(PORT_CZYTNIK.byte == 0x22)
_0x3B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x22)
	BRNE _0x3C
; 0000 044D     {
; 0000 044E       macierz_zaciskow[rzad]=34;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	ST   X+,R30
	ST   X,R31
; 0000 044F       komunikat_z_czytnika_kodow("86-1349",rzad,0);
	__POINTW1FN _0x0,442
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 0450       srednica_wew_korpusu = 38;
; 0000 0451     }
; 0000 0452 if(PORT_CZYTNIK.byte == 0x23)
_0x3C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x23)
	BRNE _0x3D
; 0000 0453     {
; 0000 0454       macierz_zaciskow[rzad]=35;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	ST   X+,R30
	ST   X,R31
; 0000 0455       komunikat_z_czytnika_kodow("86-1834",rzad,0);
	__POINTW1FN _0x0,450
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 0456       srednica_wew_korpusu = 34;
; 0000 0457     }
; 0000 0458 if(PORT_CZYTNIK.byte == 0x24)
_0x3D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x24)
	BRNE _0x3E
; 0000 0459     {
; 0000 045A       macierz_zaciskow[rzad]=36;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	ST   X+,R30
	ST   X,R31
; 0000 045B       komunikat_z_czytnika_kodow("86-2204",rzad,0);
	__POINTW1FN _0x0,458
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 045C       srednica_wew_korpusu = 38;
; 0000 045D     }
; 0000 045E if(PORT_CZYTNIK.byte == 0x25)
_0x3E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x25)
	BRNE _0x3F
; 0000 045F     {
; 0000 0460       macierz_zaciskow[rzad]=37;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(37)
	LDI  R31,HIGH(37)
	ST   X+,R30
	ST   X,R31
; 0000 0461       komunikat_z_czytnika_kodow("87-0663",rzad,0);
	__POINTW1FN _0x0,466
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2E
; 0000 0462       srednica_wew_korpusu = 43;
; 0000 0463     }
; 0000 0464 if(PORT_CZYTNIK.byte == 0x26)
_0x3F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x26)
	BRNE _0x40
; 0000 0465     {
; 0000 0466       macierz_zaciskow[rzad]=38;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	ST   X+,R30
	ST   X,R31
; 0000 0467       komunikat_z_czytnika_kodow("87-1349",rzad,1);
	__POINTW1FN _0x0,474
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0468       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 0469     }
; 0000 046A if(PORT_CZYTNIK.byte == 0x27)
_0x40:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x27)
	BRNE _0x41
; 0000 046B     {
; 0000 046C       macierz_zaciskow[rzad]=39;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(39)
	LDI  R31,HIGH(39)
	ST   X+,R30
	ST   X,R31
; 0000 046D       komunikat_z_czytnika_kodow("87-1834",rzad,1);
	__POINTW1FN _0x0,482
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 046E       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 046F     }
; 0000 0470 if(PORT_CZYTNIK.byte == 0x28)
_0x41:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x28)
	BRNE _0x42
; 0000 0471     {
; 0000 0472       macierz_zaciskow[rzad]=40;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   X+,R30
	ST   X,R31
; 0000 0473       komunikat_z_czytnika_kodow("87-2204",rzad,1);
	__POINTW1FN _0x0,490
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0474       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 0475     }
; 0000 0476 if(PORT_CZYTNIK.byte == 0x29)
_0x42:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x29)
	BRNE _0x43
; 0000 0477     {
; 0000 0478       macierz_zaciskow[rzad]=41;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	ST   X+,R30
	ST   X,R31
; 0000 0479       komunikat_z_czytnika_kodow("86-0768",rzad,1);
	__POINTW1FN _0x0,498
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 047A       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 047B     }
; 0000 047C if(PORT_CZYTNIK.byte == 0x2A)
_0x43:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2A)
	BRNE _0x44
; 0000 047D     {
; 0000 047E       macierz_zaciskow[rzad]=42;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   X+,R30
	ST   X,R31
; 0000 047F       komunikat_z_czytnika_kodow("86-1357",rzad,0);
	__POINTW1FN _0x0,506
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 0480       srednica_wew_korpusu = 38;
; 0000 0481     }
; 0000 0482 if(PORT_CZYTNIK.byte == 0x2B)
_0x44:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2B)
	BRNE _0x45
; 0000 0483     {
; 0000 0484       macierz_zaciskow[rzad]=43;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	ST   X+,R30
	ST   X,R31
; 0000 0485       komunikat_z_czytnika_kodow("86-1848",rzad,0);
	__POINTW1FN _0x0,514
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 0486       srednica_wew_korpusu = 38;
; 0000 0487     }
; 0000 0488 if(PORT_CZYTNIK.byte == 0x2C)
_0x45:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2C)
	BRNE _0x46
; 0000 0489     {
; 0000 048A      macierz_zaciskow[rzad]=44;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x2F
; 0000 048B       macierz_zaciskow[rzad]=0;   ////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x30
; 0000 048C 
; 0000 048D      komunikat_z_czytnika_kodow("86-2212",rzad,0);
	__POINTW1FN _0x0,522
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 048E      srednica_wew_korpusu = 38;
; 0000 048F     }
; 0000 0490 if(PORT_CZYTNIK.byte == 0x2D)
_0x46:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2D)
	BRNE _0x47
; 0000 0491     {
; 0000 0492       macierz_zaciskow[rzad]=45;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	ST   X+,R30
	ST   X,R31
; 0000 0493       komunikat_z_czytnika_kodow("87-0768",rzad,0);
	__POINTW1FN _0x0,530
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 0494       srednica_wew_korpusu = 38;
; 0000 0495     }
; 0000 0496 if(PORT_CZYTNIK.byte == 0x2E)
_0x47:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2E)
	BRNE _0x48
; 0000 0497     {
; 0000 0498       macierz_zaciskow[rzad]=46;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	ST   X+,R30
	ST   X,R31
; 0000 0499       komunikat_z_czytnika_kodow("87-1357",rzad,1);
	__POINTW1FN _0x0,538
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 049A       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 049B     }
; 0000 049C if(PORT_CZYTNIK.byte == 0x2F)
_0x48:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2F)
	BRNE _0x49
; 0000 049D     {
; 0000 049E       macierz_zaciskow[rzad]=47;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	ST   X+,R30
	ST   X,R31
; 0000 049F       komunikat_z_czytnika_kodow("87-1848",rzad,1);
	__POINTW1FN _0x0,546
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 04A0       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 04A1     }
; 0000 04A2 if(PORT_CZYTNIK.byte == 0x30)
_0x49:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x30)
	BRNE _0x4A
; 0000 04A3     {
; 0000 04A4       macierz_zaciskow[rzad]=48;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x2F
; 0000 04A5       macierz_zaciskow[rzad]=0;    /////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x30
; 0000 04A6       komunikat_z_czytnika_kodow("87-2212",rzad,1);
	__POINTW1FN _0x0,554
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 04A7       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 04A8     }
; 0000 04A9 if(PORT_CZYTNIK.byte == 0x31)
_0x4A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x31)
	BRNE _0x4B
; 0000 04AA     {
; 0000 04AB       macierz_zaciskow[rzad]=49;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	ST   X+,R30
	ST   X,R31
; 0000 04AC       komunikat_z_czytnika_kodow("86-0800",rzad,0);
	__POINTW1FN _0x0,562
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 04AD       srednica_wew_korpusu = 38;
; 0000 04AE     }
; 0000 04AF if(PORT_CZYTNIK.byte == 0x32)
_0x4B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x32)
	BRNE _0x4C
; 0000 04B0     {
; 0000 04B1       macierz_zaciskow[rzad]=50;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   X+,R30
	ST   X,R31
; 0000 04B2       komunikat_z_czytnika_kodow("86-1363",rzad,0);
	__POINTW1FN _0x0,570
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 04B3       srednica_wew_korpusu = 34;
; 0000 04B4     }
; 0000 04B5 if(PORT_CZYTNIK.byte == 0x33)
_0x4C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x33)
	BRNE _0x4D
; 0000 04B6     {
; 0000 04B7       macierz_zaciskow[rzad]=51;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	ST   X+,R30
	ST   X,R31
; 0000 04B8       komunikat_z_czytnika_kodow("86-1904",rzad,0);
	__POINTW1FN _0x0,578
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2E
; 0000 04B9       srednica_wew_korpusu = 43;
; 0000 04BA     }
; 0000 04BB if(PORT_CZYTNIK.byte == 0x34)
_0x4D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x34)
	BRNE _0x4E
; 0000 04BC     {
; 0000 04BD       macierz_zaciskow[rzad]=52;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	ST   X+,R30
	ST   X,R31
; 0000 04BE       komunikat_z_czytnika_kodow("86-2241",rzad,1);
	__POINTW1FN _0x0,586
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 04BF       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 04C0     }
; 0000 04C1 if(PORT_CZYTNIK.byte == 0x35)
_0x4E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x35)
	BRNE _0x4F
; 0000 04C2     {
; 0000 04C3       macierz_zaciskow[rzad]=53;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(53)
	LDI  R31,HIGH(53)
	ST   X+,R30
	ST   X,R31
; 0000 04C4       komunikat_z_czytnika_kodow("87-0800",rzad,1);
	__POINTW1FN _0x0,594
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 04C5       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 04C6     }
; 0000 04C7 
; 0000 04C8 if(PORT_CZYTNIK.byte == 0x36)
_0x4F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x36)
	BRNE _0x50
; 0000 04C9     {
; 0000 04CA       macierz_zaciskow[rzad]=54;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	ST   X+,R30
	ST   X,R31
; 0000 04CB       komunikat_z_czytnika_kodow("87-1363",rzad,1);
	__POINTW1FN _0x0,602
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 04CC       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 04CD     }
; 0000 04CE if(PORT_CZYTNIK.byte == 0x37)
_0x50:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x37)
	BRNE _0x51
; 0000 04CF     {
; 0000 04D0       macierz_zaciskow[rzad]=55;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	ST   X+,R30
	ST   X,R31
; 0000 04D1       komunikat_z_czytnika_kodow("87-1904",rzad,1);
	__POINTW1FN _0x0,610
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 04D2       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x2D
; 0000 04D3     }
; 0000 04D4 if(PORT_CZYTNIK.byte == 0x38)
_0x51:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x38)
	BRNE _0x52
; 0000 04D5     {
; 0000 04D6       macierz_zaciskow[rzad]=56;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	ST   X+,R30
	ST   X,R31
; 0000 04D7       komunikat_z_czytnika_kodow("87-2241",rzad,0);
	__POINTW1FN _0x0,618
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 04D8       srednica_wew_korpusu = 34;
; 0000 04D9     }
; 0000 04DA if(PORT_CZYTNIK.byte == 0x39)
_0x52:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x39)
	BRNE _0x53
; 0000 04DB     {
; 0000 04DC       macierz_zaciskow[rzad]=57;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(57)
	LDI  R31,HIGH(57)
	ST   X+,R30
	ST   X,R31
; 0000 04DD       komunikat_z_czytnika_kodow("86-0811",rzad,0);
	__POINTW1FN _0x0,626
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 04DE       srednica_wew_korpusu = 34;
; 0000 04DF     }
; 0000 04E0 if(PORT_CZYTNIK.byte == 0x3A)
_0x53:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3A)
	BRNE _0x54
; 0000 04E1     {
; 0000 04E2       macierz_zaciskow[rzad]=58;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	ST   X+,R30
	ST   X,R31
; 0000 04E3       komunikat_z_czytnika_kodow("86-1523",rzad,0);
	__POINTW1FN _0x0,634
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 04E4       srednica_wew_korpusu = 38;
; 0000 04E5     }
; 0000 04E6 if(PORT_CZYTNIK.byte == 0x3B)
_0x54:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3B)
	BRNE _0x55
; 0000 04E7     {
; 0000 04E8       macierz_zaciskow[rzad]=59;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	ST   X+,R30
	ST   X,R31
; 0000 04E9       komunikat_z_czytnika_kodow("86-1929",rzad,0);
	__POINTW1FN _0x0,642
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 04EA       srednica_wew_korpusu = 41;
; 0000 04EB     }
; 0000 04EC if(PORT_CZYTNIK.byte == 0x3C)
_0x55:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3C)
	BRNE _0x56
; 0000 04ED     {
; 0000 04EE       macierz_zaciskow[rzad]=60;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	ST   X+,R30
	ST   X,R31
; 0000 04EF       komunikat_z_czytnika_kodow("86-2261",rzad,0);
	__POINTW1FN _0x0,650
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 04F0       srednica_wew_korpusu = 34;
; 0000 04F1     }
; 0000 04F2 if(PORT_CZYTNIK.byte == 0x3D)
_0x56:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3D)
	BRNE _0x57
; 0000 04F3     {
; 0000 04F4       macierz_zaciskow[rzad]=61;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	ST   X+,R30
	ST   X,R31
; 0000 04F5       komunikat_z_czytnika_kodow("87-0811",rzad,1);
	__POINTW1FN _0x0,658
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 04F6       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 04F7     }
; 0000 04F8 if(PORT_CZYTNIK.byte == 0x3E)
_0x57:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3E)
	BRNE _0x58
; 0000 04F9     {
; 0000 04FA       macierz_zaciskow[rzad]=62;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	ST   X+,R30
	ST   X,R31
; 0000 04FB       komunikat_z_czytnika_kodow("87-1523",rzad,1);
	__POINTW1FN _0x0,666
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 04FC       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 04FD     }
; 0000 04FE if(PORT_CZYTNIK.byte == 0x3F)
_0x58:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3F)
	BRNE _0x59
; 0000 04FF     {
; 0000 0500       macierz_zaciskow[rzad]=63;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	ST   X+,R30
	ST   X,R31
; 0000 0501       komunikat_z_czytnika_kodow("87-1929",rzad,1);
	__POINTW1FN _0x0,674
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0502       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 0503     }
; 0000 0504 if(PORT_CZYTNIK.byte == 0x40)
_0x59:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x40)
	BRNE _0x5A
; 0000 0505     {
; 0000 0506       macierz_zaciskow[rzad]=64;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   X+,R30
	ST   X,R31
; 0000 0507       komunikat_z_czytnika_kodow("87-2261",rzad,1);
	__POINTW1FN _0x0,682
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0508       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 0509     }
; 0000 050A if(PORT_CZYTNIK.byte == 0x41)
_0x5A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x41)
	BRNE _0x5B
; 0000 050B     {
; 0000 050C       macierz_zaciskow[rzad]=65;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   X+,R30
	ST   X,R31
; 0000 050D       komunikat_z_czytnika_kodow("86-0814",rzad,0);
	__POINTW1FN _0x0,690
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x31
; 0000 050E       srednica_wew_korpusu = 36;
; 0000 050F     }
; 0000 0510 if(PORT_CZYTNIK.byte == 0x42)
_0x5B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x42)
	BRNE _0x5C
; 0000 0511     {
; 0000 0512       macierz_zaciskow[rzad]=66;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	ST   X+,R30
	ST   X,R31
; 0000 0513       komunikat_z_czytnika_kodow("86-1530",rzad,1);
	__POINTW1FN _0x0,698
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0514       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 0515     }
; 0000 0516 if(PORT_CZYTNIK.byte == 0x43)
_0x5C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x43)
	BRNE _0x5D
; 0000 0517     {
; 0000 0518       macierz_zaciskow[rzad]=67;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(67)
	LDI  R31,HIGH(67)
	ST   X+,R30
	ST   X,R31
; 0000 0519       komunikat_z_czytnika_kodow("86-1936",rzad,1);
	__POINTW1FN _0x0,706
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 051A       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 051B     }
; 0000 051C if(PORT_CZYTNIK.byte == 0x44)
_0x5D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x44)
	BRNE _0x5E
; 0000 051D     {
; 0000 051E       macierz_zaciskow[rzad]=68;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   X+,R30
	ST   X,R31
; 0000 051F       komunikat_z_czytnika_kodow("86-2285",rzad,1);
	__POINTW1FN _0x0,714
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0520       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 0521     }
; 0000 0522 if(PORT_CZYTNIK.byte == 0x45)
_0x5E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x45)
	BRNE _0x5F
; 0000 0523     {
; 0000 0524       macierz_zaciskow[rzad]=69;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(69)
	LDI  R31,HIGH(69)
	ST   X+,R30
	ST   X,R31
; 0000 0525       komunikat_z_czytnika_kodow("87-0814",rzad,1);
	__POINTW1FN _0x0,722
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0526       srednica_wew_korpusu = 36;
	CALL SUBOPT_0x32
; 0000 0527     }
; 0000 0528 if(PORT_CZYTNIK.byte == 0x46)
_0x5F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x46)
	BRNE _0x60
; 0000 0529     {
; 0000 052A       macierz_zaciskow[rzad]=70;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   X+,R30
	ST   X,R31
; 0000 052B       komunikat_z_czytnika_kodow("87-1530",rzad,0);
	__POINTW1FN _0x0,730
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 052C       srednica_wew_korpusu = 38;
; 0000 052D     }
; 0000 052E if(PORT_CZYTNIK.byte == 0x47)
_0x60:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x47)
	BRNE _0x61
; 0000 052F     {
; 0000 0530       macierz_zaciskow[rzad]=71;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(71)
	LDI  R31,HIGH(71)
	ST   X+,R30
	ST   X,R31
; 0000 0531       komunikat_z_czytnika_kodow("87-1936",rzad,0);
	__POINTW1FN _0x0,738
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 0532       srednica_wew_korpusu = 38;
; 0000 0533     }
; 0000 0534 if(PORT_CZYTNIK.byte == 0x48)
_0x61:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x48)
	BRNE _0x62
; 0000 0535     {
; 0000 0536       macierz_zaciskow[rzad]=72;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	ST   X+,R30
	ST   X,R31
; 0000 0537       komunikat_z_czytnika_kodow("87-2285",rzad,0);
	__POINTW1FN _0x0,746
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 0538       srednica_wew_korpusu = 41;
; 0000 0539     }
; 0000 053A if(PORT_CZYTNIK.byte == 0x49)
_0x62:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x49)
	BRNE _0x63
; 0000 053B     {
; 0000 053C       macierz_zaciskow[rzad]=73;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(73)
	LDI  R31,HIGH(73)
	ST   X+,R30
	ST   X,R31
; 0000 053D       komunikat_z_czytnika_kodow("86-0815",rzad,0);
	__POINTW1FN _0x0,754
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 053E       srednica_wew_korpusu = 38;
; 0000 053F     }
; 0000 0540 
; 0000 0541 if(PORT_CZYTNIK.byte == 0x4A)
_0x63:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4A)
	BRNE _0x64
; 0000 0542     {
; 0000 0543       macierz_zaciskow[rzad]=74;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	ST   X+,R30
	ST   X,R31
; 0000 0544       komunikat_z_czytnika_kodow("86-1551",rzad,0);
	__POINTW1FN _0x0,762
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 0545       srednica_wew_korpusu = 38;
; 0000 0546     }
; 0000 0547 if(PORT_CZYTNIK.byte == 0x4B)
_0x64:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4B)
	BRNE _0x65
; 0000 0548     {
; 0000 0549       macierz_zaciskow[rzad]=75;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	ST   X+,R30
	ST   X,R31
; 0000 054A       komunikat_z_czytnika_kodow("86-1941",rzad,0);
	__POINTW1FN _0x0,770
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 054B       srednica_wew_korpusu = 38;
; 0000 054C     }
; 0000 054D if(PORT_CZYTNIK.byte == 0x4C)
_0x65:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4C)
	BRNE _0x66
; 0000 054E     {
; 0000 054F       macierz_zaciskow[rzad]=76;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x2F
; 0000 0550       macierz_zaciskow[rzad]=0;    ////////////////////////////////brak zacisku
	CALL SUBOPT_0x30
; 0000 0551       komunikat_z_czytnika_kodow("86-2286",rzad,0);
	__POINTW1FN _0x0,778
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 0552       srednica_wew_korpusu = 41;
; 0000 0553     }
; 0000 0554 if(PORT_CZYTNIK.byte == 0x4D)
_0x66:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4D)
	BRNE _0x67
; 0000 0555     {
; 0000 0556       macierz_zaciskow[rzad]=77;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(77)
	LDI  R31,HIGH(77)
	ST   X+,R30
	ST   X,R31
; 0000 0557       komunikat_z_czytnika_kodow("87-0815",rzad,1);
	__POINTW1FN _0x0,786
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0558       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 0559     }
; 0000 055A if(PORT_CZYTNIK.byte == 0x4E)
_0x67:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4E)
	BRNE _0x68
; 0000 055B     {
; 0000 055C       macierz_zaciskow[rzad]=78;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	ST   X+,R30
	ST   X,R31
; 0000 055D       komunikat_z_czytnika_kodow("87-1551",rzad,1);
	__POINTW1FN _0x0,794
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 055E       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 055F     }
; 0000 0560 if(PORT_CZYTNIK.byte == 0x4F)
_0x68:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4F)
	BRNE _0x69
; 0000 0561     {
; 0000 0562       macierz_zaciskow[rzad]=79;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(79)
	LDI  R31,HIGH(79)
	ST   X+,R30
	ST   X,R31
; 0000 0563       komunikat_z_czytnika_kodow("87-1941",rzad,1);
	__POINTW1FN _0x0,802
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0564       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 0565     }
; 0000 0566 if(PORT_CZYTNIK.byte == 0x50)
_0x69:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x50)
	BRNE _0x6A
; 0000 0567     {
; 0000 0568       macierz_zaciskow[rzad]=80;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x2F
; 0000 0569       macierz_zaciskow[rzad]=0;  ////////////////////////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x30
; 0000 056A       komunikat_z_czytnika_kodow("87-2286",rzad,0);
	__POINTW1FN _0x0,810
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 056B       srednica_wew_korpusu = 41;
; 0000 056C     }
; 0000 056D if(PORT_CZYTNIK.byte == 0x51)
_0x6A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x51)
	BRNE _0x6B
; 0000 056E     {
; 0000 056F       macierz_zaciskow[rzad]=81;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(81)
	LDI  R31,HIGH(81)
	ST   X+,R30
	ST   X,R31
; 0000 0570       komunikat_z_czytnika_kodow("86-0816",rzad,0);
	__POINTW1FN _0x0,818
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x31
; 0000 0571       srednica_wew_korpusu = 36;
; 0000 0572     }
; 0000 0573 if(PORT_CZYTNIK.byte == 0x52)
_0x6B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x52)
	BRNE _0x6C
; 0000 0574     {
; 0000 0575       macierz_zaciskow[rzad]=82;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	ST   X+,R30
	ST   X,R31
; 0000 0576       komunikat_z_czytnika_kodow("86-1552",rzad,0);
	__POINTW1FN _0x0,826
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 0577       srednica_wew_korpusu = 34;
; 0000 0578     }
; 0000 0579 if(PORT_CZYTNIK.byte == 0x53)
_0x6C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x53)
	BRNE _0x6D
; 0000 057A     {
; 0000 057B       macierz_zaciskow[rzad]=83;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	ST   X+,R30
	ST   X,R31
; 0000 057C       komunikat_z_czytnika_kodow("86-2007",rzad,1);
	__POINTW1FN _0x0,834
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 057D       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 057E     }
; 0000 057F if(PORT_CZYTNIK.byte == 0x54)
_0x6D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x54)
	BRNE _0x6E
; 0000 0580     {
; 0000 0581       macierz_zaciskow[rzad]=84;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	ST   X+,R30
	ST   X,R31
; 0000 0582       komunikat_z_czytnika_kodow("86-2292",rzad,1);
	__POINTW1FN _0x0,842
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0583       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 0584     }
; 0000 0585 if(PORT_CZYTNIK.byte == 0x55)
_0x6E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x55)
	BRNE _0x6F
; 0000 0586     {
; 0000 0587       macierz_zaciskow[rzad]=85;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	ST   X+,R30
	ST   X,R31
; 0000 0588       komunikat_z_czytnika_kodow("87-0816",rzad,1);
	__POINTW1FN _0x0,850
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0589       srednica_wew_korpusu = 36;
	CALL SUBOPT_0x32
; 0000 058A      }
; 0000 058B if(PORT_CZYTNIK.byte == 0x56)
_0x6F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x56)
	BRNE _0x70
; 0000 058C     {
; 0000 058D       macierz_zaciskow[rzad]=86;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	ST   X+,R30
	ST   X,R31
; 0000 058E       komunikat_z_czytnika_kodow("87-1552",rzad,1);
	__POINTW1FN _0x0,858
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 058F       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 0590     }
; 0000 0591 if(PORT_CZYTNIK.byte == 0x57)
_0x70:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x57)
	BRNE _0x71
; 0000 0592     {
; 0000 0593       macierz_zaciskow[rzad]=87;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(87)
	LDI  R31,HIGH(87)
	ST   X+,R30
	ST   X,R31
; 0000 0594       komunikat_z_czytnika_kodow("87-2007",rzad,0);
	__POINTW1FN _0x0,866
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 0595       srednica_wew_korpusu = 41;
; 0000 0596     }
; 0000 0597 if(PORT_CZYTNIK.byte == 0x58)
_0x71:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x58)
	BRNE _0x72
; 0000 0598     {
; 0000 0599       macierz_zaciskow[rzad]=88;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	ST   X+,R30
	ST   X,R31
; 0000 059A       komunikat_z_czytnika_kodow("87-2292",rzad,0);
	__POINTW1FN _0x0,874
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 059B       srednica_wew_korpusu = 38;
; 0000 059C     }
; 0000 059D if(PORT_CZYTNIK.byte == 0x59)
_0x72:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x59)
	BRNE _0x73
; 0000 059E     {
; 0000 059F       macierz_zaciskow[rzad]=89;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(89)
	LDI  R31,HIGH(89)
	ST   X+,R30
	ST   X,R31
; 0000 05A0       komunikat_z_czytnika_kodow("86-0817",rzad,0);
	__POINTW1FN _0x0,882
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 05A1       srednica_wew_korpusu = 38;
; 0000 05A2     }
; 0000 05A3 if(PORT_CZYTNIK.byte == 0x5A)
_0x73:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5A)
	BRNE _0x74
; 0000 05A4     {
; 0000 05A5       macierz_zaciskow[rzad]=90;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   X+,R30
	ST   X,R31
; 0000 05A6       komunikat_z_czytnika_kodow("86-1602",rzad,1);
	__POINTW1FN _0x0,890
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 05A7       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 05A8     }
; 0000 05A9 if(PORT_CZYTNIK.byte == 0x5B)
_0x74:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5B)
	BRNE _0x75
; 0000 05AA     {
; 0000 05AB       macierz_zaciskow[rzad]=91;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	ST   X+,R30
	ST   X,R31
; 0000 05AC       komunikat_z_czytnika_kodow("86-2017",rzad,1);
	__POINTW1FN _0x0,898
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 05AD       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 05AE     }
; 0000 05AF if(PORT_CZYTNIK.byte == 0x5C)
_0x75:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5C)
	BRNE _0x76
; 0000 05B0     {
; 0000 05B1       macierz_zaciskow[rzad]=92;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x2F
; 0000 05B2       macierz_zaciskow[rzad]=0;           /////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x30
; 0000 05B3       komunikat_z_czytnika_kodow("86-2384",rzad,0);
	__POINTW1FN _0x0,906
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 05B4       srednica_wew_korpusu = 38;
; 0000 05B5     }
; 0000 05B6 if(PORT_CZYTNIK.byte == 0x5D)
_0x76:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5D)
	BRNE _0x77
; 0000 05B7     {
; 0000 05B8       macierz_zaciskow[rzad]=93;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(93)
	LDI  R31,HIGH(93)
	ST   X+,R30
	ST   X,R31
; 0000 05B9       komunikat_z_czytnika_kodow("87-0817",rzad,1);
	__POINTW1FN _0x0,914
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 05BA       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 05BB     }
; 0000 05BC if(PORT_CZYTNIK.byte == 0x5E)
_0x77:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5E)
	BRNE _0x78
; 0000 05BD     {
; 0000 05BE       macierz_zaciskow[rzad]=94;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	ST   X+,R30
	ST   X,R31
; 0000 05BF       komunikat_z_czytnika_kodow("87-1602",rzad,0);
	__POINTW1FN _0x0,922
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 05C0       srednica_wew_korpusu = 38;
; 0000 05C1     }
; 0000 05C2 if(PORT_CZYTNIK.byte == 0x5F)
_0x78:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5F)
	BRNE _0x79
; 0000 05C3     {
; 0000 05C4       macierz_zaciskow[rzad]=95;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(95)
	LDI  R31,HIGH(95)
	ST   X+,R30
	ST   X,R31
; 0000 05C5       komunikat_z_czytnika_kodow("87-2017",rzad,0);
	__POINTW1FN _0x0,930
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 05C6       srednica_wew_korpusu = 41;
; 0000 05C7     }
; 0000 05C8 if(PORT_CZYTNIK.byte == 0x60)
_0x79:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x60)
	BRNE _0x7A
; 0000 05C9     {
; 0000 05CA       macierz_zaciskow[rzad]=96;   ///////////////////////////////////////////////brak zacisku
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x2F
; 0000 05CB       macierz_zaciskow[rzad]=0;
	CALL SUBOPT_0x30
; 0000 05CC       komunikat_z_czytnika_kodow("87-2384",rzad,0);
	__POINTW1FN _0x0,938
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 05CD       srednica_wew_korpusu = 38;
; 0000 05CE     }
; 0000 05CF 
; 0000 05D0 if(PORT_CZYTNIK.byte == 0x61)
_0x7A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x61)
	BRNE _0x7B
; 0000 05D1     {
; 0000 05D2       macierz_zaciskow[rzad]=97;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(97)
	LDI  R31,HIGH(97)
	ST   X+,R30
	ST   X,R31
; 0000 05D3       komunikat_z_czytnika_kodow("86-0847",rzad,0);
	__POINTW1FN _0x0,946
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 05D4       srednica_wew_korpusu = 41;
; 0000 05D5     }
; 0000 05D6 
; 0000 05D7 if(PORT_CZYTNIK.byte == 0x62)
_0x7B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x62)
	BRNE _0x7C
; 0000 05D8     {
; 0000 05D9       macierz_zaciskow[rzad]=98;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	ST   X+,R30
	ST   X,R31
; 0000 05DA       komunikat_z_czytnika_kodow("86-1620",rzad,0);
	__POINTW1FN _0x0,954
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 05DB       srednica_wew_korpusu = 38;
; 0000 05DC     }
; 0000 05DD if(PORT_CZYTNIK.byte == 0x63)
_0x7C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x63)
	BRNE _0x7D
; 0000 05DE     {
; 0000 05DF       macierz_zaciskow[rzad]=99;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	ST   X+,R30
	ST   X,R31
; 0000 05E0       komunikat_z_czytnika_kodow("86-2019",rzad,1);
	__POINTW1FN _0x0,962
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 05E1       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 05E2     }
; 0000 05E3 if(PORT_CZYTNIK.byte == 0x64)
_0x7D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x64)
	BRNE _0x7E
; 0000 05E4     {
; 0000 05E5       macierz_zaciskow[rzad]=100;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   X+,R30
	ST   X,R31
; 0000 05E6       komunikat_z_czytnika_kodow("86-2385",rzad,0);
	__POINTW1FN _0x0,970
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 05E7       srednica_wew_korpusu = 38;
; 0000 05E8     }
; 0000 05E9 if(PORT_CZYTNIK.byte == 0x65)
_0x7E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x65)
	BRNE _0x7F
; 0000 05EA     {
; 0000 05EB       macierz_zaciskow[rzad]=101;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(101)
	LDI  R31,HIGH(101)
	ST   X+,R30
	ST   X,R31
; 0000 05EC       komunikat_z_czytnika_kodow("87-0847",rzad,1);
	__POINTW1FN _0x0,978
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 05ED       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 05EE     }
; 0000 05EF if(PORT_CZYTNIK.byte == 0x66)
_0x7F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x66)
	BRNE _0x80
; 0000 05F0     {
; 0000 05F1       macierz_zaciskow[rzad]=102;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	ST   X+,R30
	ST   X,R31
; 0000 05F2       komunikat_z_czytnika_kodow("87-1620",rzad,1);
	__POINTW1FN _0x0,986
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 05F3       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 05F4     }
; 0000 05F5 if(PORT_CZYTNIK.byte == 0x67)
_0x80:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x67)
	BRNE _0x81
; 0000 05F6     {
; 0000 05F7       macierz_zaciskow[rzad]=103;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	ST   X+,R30
	ST   X,R31
; 0000 05F8       komunikat_z_czytnika_kodow("87-2019",rzad,0);
	__POINTW1FN _0x0,994
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 05F9       srednica_wew_korpusu = 41;
; 0000 05FA     }
; 0000 05FB if(PORT_CZYTNIK.byte == 0x68)
_0x81:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x68)
	BRNE _0x82
; 0000 05FC     {
; 0000 05FD       macierz_zaciskow[rzad]=104;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	ST   X+,R30
	ST   X,R31
; 0000 05FE       komunikat_z_czytnika_kodow("87-2385",rzad,1);
	__POINTW1FN _0x0,1002
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 05FF       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 0600     }
; 0000 0601 if(PORT_CZYTNIK.byte == 0x69)
_0x82:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x69)
	BRNE _0x83
; 0000 0602     {
; 0000 0603       macierz_zaciskow[rzad]=105;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(105)
	LDI  R31,HIGH(105)
	ST   X+,R30
	ST   X,R31
; 0000 0604       komunikat_z_czytnika_kodow("86-0854",rzad,0);
	__POINTW1FN _0x0,1010
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 0605       srednica_wew_korpusu = 34;
; 0000 0606     }
; 0000 0607 if(PORT_CZYTNIK.byte == 0x6A)
_0x83:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6A)
	BRNE _0x84
; 0000 0608     {
; 0000 0609       macierz_zaciskow[rzad]=106;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	ST   X+,R30
	ST   X,R31
; 0000 060A       komunikat_z_czytnika_kodow("86-1622",rzad,1);
	__POINTW1FN _0x0,1018
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 060B       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 060C     }
; 0000 060D if(PORT_CZYTNIK.byte == 0x6B)
_0x84:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6B)
	BRNE _0x85
; 0000 060E     {
; 0000 060F       macierz_zaciskow[rzad]=107;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(107)
	LDI  R31,HIGH(107)
	CALL SUBOPT_0x2F
; 0000 0610       macierz_zaciskow[rzad]=0;          //brak zacisku
	CALL SUBOPT_0x30
; 0000 0611       komunikat_z_czytnika_kodow("86-2028",rzad,0);
	__POINTW1FN _0x0,1026
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2E
; 0000 0612       srednica_wew_korpusu = 43;
; 0000 0613     }
; 0000 0614 if(PORT_CZYTNIK.byte == 0x6C)
_0x85:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6C)
	BRNE _0x86
; 0000 0615     {
; 0000 0616       macierz_zaciskow[rzad]=108;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	ST   X+,R30
	ST   X,R31
; 0000 0617       komunikat_z_czytnika_kodow("86-2437",rzad,0);
	__POINTW1FN _0x0,1034
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 0618       srednica_wew_korpusu = 38;
; 0000 0619     }
; 0000 061A if(PORT_CZYTNIK.byte == 0x6D)
_0x86:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6D)
	BRNE _0x87
; 0000 061B     {
; 0000 061C       macierz_zaciskow[rzad]=109;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(109)
	LDI  R31,HIGH(109)
	ST   X+,R30
	ST   X,R31
; 0000 061D       komunikat_z_czytnika_kodow("87-0854",rzad,1);
	__POINTW1FN _0x0,1042
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 061E       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 061F     }
; 0000 0620 if(PORT_CZYTNIK.byte == 0x6E)
_0x87:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6E)
	BRNE _0x88
; 0000 0621     {
; 0000 0622       macierz_zaciskow[rzad]=110;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	ST   X+,R30
	ST   X,R31
; 0000 0623       komunikat_z_czytnika_kodow("87-1622",rzad,0);
	__POINTW1FN _0x0,1050
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 0624       srednica_wew_korpusu = 34;
; 0000 0625     }
; 0000 0626 
; 0000 0627 if(PORT_CZYTNIK.byte == 0x6F)
_0x88:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6F)
	BRNE _0x89
; 0000 0628     {
; 0000 0629       macierz_zaciskow[rzad]=111;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(111)
	LDI  R31,HIGH(111)
	CALL SUBOPT_0x2F
; 0000 062A       macierz_zaciskow[rzad]=0;      //brak zacisku
	CALL SUBOPT_0x30
; 0000 062B       komunikat_z_czytnika_kodow("87-2028",rzad,0);
	__POINTW1FN _0x0,1058
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2E
; 0000 062C       srednica_wew_korpusu = 43;
; 0000 062D     }
; 0000 062E 
; 0000 062F if(PORT_CZYTNIK.byte == 0x70)
_0x89:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x70)
	BRNE _0x8A
; 0000 0630     {
; 0000 0631       macierz_zaciskow[rzad]=112;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   X+,R30
	ST   X,R31
; 0000 0632       komunikat_z_czytnika_kodow("87-2437",rzad,1);
	__POINTW1FN _0x0,1066
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0633       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 0634     }
; 0000 0635 if(PORT_CZYTNIK.byte == 0x71)
_0x8A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x71)
	BRNE _0x8B
; 0000 0636     {
; 0000 0637       macierz_zaciskow[rzad]=113;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   X+,R30
	ST   X,R31
; 0000 0638       komunikat_z_czytnika_kodow("86-0862",rzad,0);
	__POINTW1FN _0x0,1074
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 0639       srednica_wew_korpusu = 38;
; 0000 063A     }
; 0000 063B if(PORT_CZYTNIK.byte == 0x72)
_0x8B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x72)
	BRNE _0x8C
; 0000 063C     {
; 0000 063D       macierz_zaciskow[rzad]=114;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	ST   X+,R30
	ST   X,R31
; 0000 063E       komunikat_z_czytnika_kodow("86-1625",rzad,0);
	__POINTW1FN _0x0,1082
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 063F       srednica_wew_korpusu = 38;
; 0000 0640     }
; 0000 0641 if(PORT_CZYTNIK.byte == 0x73)
_0x8C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x73)
	BRNE _0x8D
; 0000 0642     {
; 0000 0643       macierz_zaciskow[rzad]=115;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(115)
	LDI  R31,HIGH(115)
	ST   X+,R30
	ST   X,R31
; 0000 0644       komunikat_z_czytnika_kodow("86-2052",rzad,0);
	__POINTW1FN _0x0,1090
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2E
; 0000 0645       srednica_wew_korpusu = 43;
; 0000 0646     }
; 0000 0647 if(PORT_CZYTNIK.byte == 0x74)
_0x8D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x74)
	BRNE _0x8E
; 0000 0648     {
; 0000 0649       macierz_zaciskow[rzad]=116;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	ST   X+,R30
	ST   X,R31
; 0000 064A       komunikat_z_czytnika_kodow("86-2492",rzad,1);
	__POINTW1FN _0x0,1098
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 064B       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 064C     }
; 0000 064D if(PORT_CZYTNIK.byte == 0x75)
_0x8E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x75)
	BRNE _0x8F
; 0000 064E     {
; 0000 064F       macierz_zaciskow[rzad]=117;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(117)
	LDI  R31,HIGH(117)
	ST   X+,R30
	ST   X,R31
; 0000 0650       komunikat_z_czytnika_kodow("87-0862",rzad,1);
	__POINTW1FN _0x0,1106
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0651       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 0652     }
; 0000 0653 if(PORT_CZYTNIK.byte == 0x76)
_0x8F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x76)
	BRNE _0x90
; 0000 0654     {
; 0000 0655       macierz_zaciskow[rzad]=118;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	ST   X+,R30
	ST   X,R31
; 0000 0656       komunikat_z_czytnika_kodow("87-1625",rzad,1);
	__POINTW1FN _0x0,1114
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0657       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 0658     }
; 0000 0659 if(PORT_CZYTNIK.byte == 0x77)
_0x90:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x77)
	BRNE _0x91
; 0000 065A     {
; 0000 065B       macierz_zaciskow[rzad]=119;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   X+,R30
	ST   X,R31
; 0000 065C       komunikat_z_czytnika_kodow("87-2052",rzad,1);
	__POINTW1FN _0x0,1122
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 065D       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x2D
; 0000 065E     }
; 0000 065F if(PORT_CZYTNIK.byte == 0x78)
_0x91:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x78)
	BRNE _0x92
; 0000 0660     {
; 0000 0661       macierz_zaciskow[rzad]=120;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   X+,R30
	ST   X,R31
; 0000 0662       komunikat_z_czytnika_kodow("87-2492",rzad,0);
	__POINTW1FN _0x0,1130
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 0663       srednica_wew_korpusu = 38;
; 0000 0664     }
; 0000 0665 if(PORT_CZYTNIK.byte == 0x79)
_0x92:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x79)
	BRNE _0x93
; 0000 0666     {
; 0000 0667       macierz_zaciskow[rzad]=121;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   X+,R30
	ST   X,R31
; 0000 0668       komunikat_z_czytnika_kodow("86-0935",rzad,0);
	__POINTW1FN _0x0,1138
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 0669       srednica_wew_korpusu = 38;
; 0000 066A     }
; 0000 066B if(PORT_CZYTNIK.byte == 0x7A)
_0x93:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7A)
	BRNE _0x94
; 0000 066C     {
; 0000 066D       macierz_zaciskow[rzad]=122;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	ST   X+,R30
	ST   X,R31
; 0000 066E       komunikat_z_czytnika_kodow("86-1648",rzad,0);
	__POINTW1FN _0x0,1146
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 066F       srednica_wew_korpusu = 38;
; 0000 0670     }
; 0000 0671 if(PORT_CZYTNIK.byte == 0x7B)
_0x94:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7B)
	BRNE _0x95
; 0000 0672     {
; 0000 0673       macierz_zaciskow[rzad]=123;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(123)
	LDI  R31,HIGH(123)
	ST   X+,R30
	ST   X,R31
; 0000 0674       komunikat_z_czytnika_kodow("86-2082",rzad,0);
	__POINTW1FN _0x0,1154
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x31
; 0000 0675       srednica_wew_korpusu = 36;
; 0000 0676     }
; 0000 0677 if(PORT_CZYTNIK.byte == 0x7C)
_0x95:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7C)
	BRNE _0x96
; 0000 0678     {
; 0000 0679       macierz_zaciskow[rzad]=124;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	ST   X+,R30
	ST   X,R31
; 0000 067A       komunikat_z_czytnika_kodow("86-2500",rzad,0);
	__POINTW1FN _0x0,1162
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 067B       srednica_wew_korpusu = 38;
; 0000 067C     }
; 0000 067D if(PORT_CZYTNIK.byte == 0x7D)
_0x96:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7D)
	BRNE _0x97
; 0000 067E     {
; 0000 067F       macierz_zaciskow[rzad]=125;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   X+,R30
	ST   X,R31
; 0000 0680       komunikat_z_czytnika_kodow("87-0935",rzad,1);
	__POINTW1FN _0x0,1170
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0681       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 0682     }
; 0000 0683 if(PORT_CZYTNIK.byte == 0x7E)
_0x97:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7E)
	BRNE _0x98
; 0000 0684     {
; 0000 0685       macierz_zaciskow[rzad]=126;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	ST   X+,R30
	ST   X,R31
; 0000 0686       komunikat_z_czytnika_kodow("87-1648",rzad,1);
	__POINTW1FN _0x0,1178
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0687       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 0688     }
; 0000 0689 
; 0000 068A if(PORT_CZYTNIK.byte == 0x7F)
_0x98:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7F)
	BRNE _0x99
; 0000 068B     {
; 0000 068C       macierz_zaciskow[rzad]=127;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	ST   X+,R30
	ST   X,R31
; 0000 068D       komunikat_z_czytnika_kodow("87-2082",rzad,1);
	__POINTW1FN _0x0,1186
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 068E       srednica_wew_korpusu = 36;
	CALL SUBOPT_0x32
; 0000 068F     }
; 0000 0690 if(PORT_CZYTNIK.byte == 0x80)
_0x99:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x80)
	BRNE _0x9A
; 0000 0691     {
; 0000 0692       macierz_zaciskow[rzad]=128;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   X+,R30
	ST   X,R31
; 0000 0693       komunikat_z_czytnika_kodow("87-2500",rzad,1);
	__POINTW1FN _0x0,1194
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0694       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 0695     }
; 0000 0696 if(PORT_CZYTNIK.byte == 0x81)
_0x9A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x81)
	BRNE _0x9B
; 0000 0697     {
; 0000 0698       macierz_zaciskow[rzad]=129;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(129)
	LDI  R31,HIGH(129)
	ST   X+,R30
	ST   X,R31
; 0000 0699       komunikat_z_czytnika_kodow("86-1019",rzad,0);
	__POINTW1FN _0x0,1202
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2B
; 0000 069A       srednica_wew_korpusu = 41;
; 0000 069B     }
; 0000 069C if(PORT_CZYTNIK.byte == 0x82)
_0x9B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x82)
	BRNE _0x9C
; 0000 069D     {
; 0000 069E       macierz_zaciskow[rzad]=130;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	ST   X+,R30
	ST   X,R31
; 0000 069F       komunikat_z_czytnika_kodow("86-1649",rzad,0);
	__POINTW1FN _0x0,1210
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 06A0       srednica_wew_korpusu = 38;
; 0000 06A1     }
; 0000 06A2 if(PORT_CZYTNIK.byte == 0x83)
_0x9C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x83)
	BRNE _0x9D
; 0000 06A3     {
; 0000 06A4       macierz_zaciskow[rzad]=131;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(131)
	LDI  R31,HIGH(131)
	ST   X+,R30
	ST   X,R31
; 0000 06A5       komunikat_z_czytnika_kodow("86-2083",rzad,1);
	__POINTW1FN _0x0,1218
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 06A6       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x2D
; 0000 06A7     }
; 0000 06A8 if(PORT_CZYTNIK.byte == 0x84)
_0x9D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x84)
	BRNE _0x9E
; 0000 06A9     {
; 0000 06AA       macierz_zaciskow[rzad]=132;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	ST   X+,R30
	ST   X,R31
; 0000 06AB       komunikat_z_czytnika_kodow("86-2585",rzad,0);
	__POINTW1FN _0x0,1226
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2E
; 0000 06AC       srednica_wew_korpusu = 43;
; 0000 06AD     }
; 0000 06AE if(PORT_CZYTNIK.byte == 0x85)
_0x9E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x85)
	BRNE _0x9F
; 0000 06AF     {
; 0000 06B0       macierz_zaciskow[rzad]=133;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(133)
	LDI  R31,HIGH(133)
	ST   X+,R30
	ST   X,R31
; 0000 06B1       komunikat_z_czytnika_kodow("87-1019",rzad,1);
	__POINTW1FN _0x0,1234
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 06B2       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x2C
; 0000 06B3     }
; 0000 06B4 if(PORT_CZYTNIK.byte == 0x86)
_0x9F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x86)
	BRNE _0xA0
; 0000 06B5     {
; 0000 06B6       macierz_zaciskow[rzad]=134;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	ST   X+,R30
	ST   X,R31
; 0000 06B7       komunikat_z_czytnika_kodow("87-1649",rzad,1);
	__POINTW1FN _0x0,1242
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 06B8       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 06B9     }
; 0000 06BA if(PORT_CZYTNIK.byte == 0x87)
_0xA0:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x87)
	BRNE _0xA1
; 0000 06BB     {
; 0000 06BC       macierz_zaciskow[rzad]=135;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(135)
	LDI  R31,HIGH(135)
	ST   X+,R30
	ST   X,R31
; 0000 06BD       komunikat_z_czytnika_kodow("87-2083",rzad,0);
	__POINTW1FN _0x0,1250
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2E
; 0000 06BE       srednica_wew_korpusu = 43;
; 0000 06BF     }
; 0000 06C0 
; 0000 06C1 if(PORT_CZYTNIK.byte == 0x88)
_0xA1:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x88)
	BRNE _0xA2
; 0000 06C2     {
; 0000 06C3       macierz_zaciskow[rzad]=136;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	ST   X+,R30
	ST   X,R31
; 0000 06C4       komunikat_z_czytnika_kodow("87-2624",rzad,1);
	__POINTW1FN _0x0,1258
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 06C5       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 06C6     }
; 0000 06C7 if(PORT_CZYTNIK.byte == 0x89)
_0xA2:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x89)
	BRNE _0xA3
; 0000 06C8     {
; 0000 06C9       macierz_zaciskow[rzad]=137;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(137)
	LDI  R31,HIGH(137)
	ST   X+,R30
	ST   X,R31
; 0000 06CA       komunikat_z_czytnika_kodow("86-1027",rzad,0);
	__POINTW1FN _0x0,1266
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 06CB       srednica_wew_korpusu = 34;
; 0000 06CC     }
; 0000 06CD if(PORT_CZYTNIK.byte == 0x8A)
_0xA3:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8A)
	BRNE _0xA4
; 0000 06CE     {
; 0000 06CF       macierz_zaciskow[rzad]=138;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	ST   X+,R30
	ST   X,R31
; 0000 06D0       komunikat_z_czytnika_kodow("86-1669",rzad,1);
	__POINTW1FN _0x0,1274
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 06D1       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 06D2     }
; 0000 06D3 if(PORT_CZYTNIK.byte == 0x8B)
_0xA4:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8B)
	BRNE _0xA5
; 0000 06D4     {
; 0000 06D5       macierz_zaciskow[rzad]=139;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(139)
	LDI  R31,HIGH(139)
	ST   X+,R30
	ST   X,R31
; 0000 06D6       komunikat_z_czytnika_kodow("86-2087",rzad,1);
	__POINTW1FN _0x0,1282
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 06D7       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x27
; 0000 06D8     }
; 0000 06D9 if(PORT_CZYTNIK.byte == 0x8C)
_0xA5:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8C)
	BRNE _0xA6
; 0000 06DA     {
; 0000 06DB       macierz_zaciskow[rzad]=140;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	ST   X+,R30
	ST   X,R31
; 0000 06DC       komunikat_z_czytnika_kodow("86-2624",rzad,0);
	__POINTW1FN _0x0,1290
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x28
; 0000 06DD       srednica_wew_korpusu = 34;
; 0000 06DE     }
; 0000 06DF if(PORT_CZYTNIK.byte == 0x8D)
_0xA6:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8D)
	BRNE _0xA7
; 0000 06E0     {
; 0000 06E1       macierz_zaciskow[rzad]=141;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(141)
	LDI  R31,HIGH(141)
	ST   X+,R30
	ST   X,R31
; 0000 06E2       komunikat_z_czytnika_kodow("87-1027",rzad,1);
	__POINTW1FN _0x0,1298
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 06E3       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x2A
; 0000 06E4     }
; 0000 06E5 if(PORT_CZYTNIK.byte == 0x8E)
_0xA7:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8E)
	BRNE _0xA8
; 0000 06E6     {
; 0000 06E7       macierz_zaciskow[rzad]=142;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	ST   X+,R30
	ST   X,R31
; 0000 06E8       komunikat_z_czytnika_kodow("87-1669",rzad,0);
	__POINTW1FN _0x0,1306
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 06E9       srednica_wew_korpusu = 38;
; 0000 06EA     }
; 0000 06EB if(PORT_CZYTNIK.byte == 0x8F)
_0xA8:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8F)
	BRNE _0xA9
; 0000 06EC     {
; 0000 06ED       macierz_zaciskow[rzad]=143;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(143)
	LDI  R31,HIGH(143)
	ST   X+,R30
	ST   X,R31
; 0000 06EE       komunikat_z_czytnika_kodow("87-2087",rzad,0);
	__POINTW1FN _0x0,1314
	CALL SUBOPT_0x25
	CALL SUBOPT_0x14
	CALL SUBOPT_0x29
; 0000 06EF       srednica_wew_korpusu = 38;
; 0000 06F0     }
; 0000 06F1 if(PORT_CZYTNIK.byte == 0x90)
_0xA9:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x90)
	BRNE _0xAA
; 0000 06F2     {
; 0000 06F3       macierz_zaciskow[rzad]=144;
	MOVW R30,R16
	CALL SUBOPT_0xA
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   X+,R30
	ST   X,R31
; 0000 06F4       komunikat_z_czytnika_kodow("87-2585",rzad,1);
	__POINTW1FN _0x0,1322
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 06F5       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x2D
; 0000 06F6     }
; 0000 06F7 
; 0000 06F8 
; 0000 06F9 return rzad;
_0xAA:
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 06FA }
;
;
;void wybor_linijek_sterownikow(int rzad_local)
; 0000 06FE {
_wybor_linijek_sterownikow:
; 0000 06FF //zaczynam od tego
; 0000 0700 //komentarz: celowo upraszam:
; 0000 0701 //  a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 0702 //a[4] = 0x21;    //ster3 ABS             //krazek scierny
; 0000 0703 
; 0000 0704 //legenda pierwotna
; 0000 0705             /*
; 0000 0706             a[0] = 0x05A;   //ster1
; 0000 0707             a[1] = a[0]+0x001;                                   //0x05B;   //ster2
; 0000 0708             a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 0709             a[3] = 0x11;    //ster4 INV             //druciak
; 0000 070A             a[4] = a[2];   //0x21;    //ster3 ABS             //krazek scierny
; 0000 070B             a[5] = 0x196;   //delta okrag
; 0000 070C             a[6] = a[5]+0x001;            //0x197;   //okrag
; 0000 070D             a[7] = 0x12;    //ster3 INV             krazek scierny
; 0000 070E             a[8] = a[6]+0x001;                0x198;   //-delta okrag
; 0000 070F             a[9] = 0;          //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0710             */
; 0000 0711 
; 0000 0712 
; 0000 0713 //macierz_zaciskow[rzad_local]
; 0000 0714 //macierz_zaciskow[rzad_local] = 140;
; 0000 0715 
; 0000 0716 
; 0000 0717 
; 0000 0718 
; 0000 0719 
; 0000 071A 
; 0000 071B switch(macierz_zaciskow[rzad_local])
;	rzad_local -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0xA
	CALL __GETW1P
; 0000 071C {
; 0000 071D     case 0:
	SBIW R30,0
	BRNE _0xAE
; 0000 071E 
; 0000 071F             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x33
; 0000 0720             komunikat_na_panel("Nie wczytano zacisku",adr1,adr2);
	__POINTW1FN _0x0,1330
	CALL SUBOPT_0x34
; 0000 0721 
; 0000 0722     break;
	JMP  _0xAD
; 0000 0723 
; 0000 0724 
; 0000 0725      case 1:
_0xAE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xAF
; 0000 0726 
; 0000 0727             a[0] = 0x0C8;   //ster1
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x35
; 0000 0728             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0729             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x37
; 0000 072A             a[5] = 0x196;   //delta okrag
; 0000 072B             a[7] = 0x11;    //ster3 INV krazek scierny
	JMP  _0x53B
; 0000 072C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 072D 
; 0000 072E             a[1] = a[0]+0x001;  //ster2
; 0000 072F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0730             a[6] = a[5]+0x001;  //okrag
; 0000 0731             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0732 
; 0000 0733     break;
; 0000 0734 
; 0000 0735       case 2:
_0xAF:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB0
; 0000 0736 
; 0000 0737             a[0] = 0x110;   //ster1
	LDI  R30,LOW(272)
	LDI  R31,HIGH(272)
	CALL SUBOPT_0x35
; 0000 0738             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0739             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x39
; 0000 073A             a[5] = 0x190;   //delta okrag
; 0000 073B             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x38
; 0000 073C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3A
	JMP  _0x53C
; 0000 073D 
; 0000 073E             a[1] = a[0]+0x001;  //ster2
; 0000 073F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0740             a[6] = a[5]+0x001;  //okrag
; 0000 0741             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0742 
; 0000 0743     break;
; 0000 0744 
; 0000 0745       case 3:
_0xB0:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xB1
; 0000 0746 
; 0000 0747             a[0] = 0x07A;   //ster1
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	CALL SUBOPT_0x35
; 0000 0748             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0749             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 074A             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 074B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 074C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x53C
; 0000 074D 
; 0000 074E             a[1] = a[0]+0x001;  //ster2
; 0000 074F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0750             a[6] = a[5]+0x001;  //okrag
; 0000 0751             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0752 
; 0000 0753     break;
; 0000 0754 
; 0000 0755       case 4:
_0xB1:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xB2
; 0000 0756 
; 0000 0757             a[0] = 0x102;   //ster1
	LDI  R30,LOW(258)
	LDI  R31,HIGH(258)
	CALL SUBOPT_0x35
; 0000 0758             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0759             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 075A             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 075B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 075C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x53C
; 0000 075D 
; 0000 075E             a[1] = a[0]+0x001;  //ster2
; 0000 075F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0760             a[6] = a[5]+0x001;  //okrag
; 0000 0761             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0762 
; 0000 0763     break;
; 0000 0764 
; 0000 0765       case 5:
_0xB2:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xB3
; 0000 0766 
; 0000 0767             a[0] = 0x0B0;   //ster1
	LDI  R30,LOW(176)
	LDI  R31,HIGH(176)
	CALL SUBOPT_0x35
; 0000 0768             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0769             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x37
; 0000 076A             a[5] = 0x196;   //delta okrag
; 0000 076B             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 076C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 076D 
; 0000 076E             a[1] = a[0]+0x001;  //ster2
; 0000 076F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0770             a[6] = a[5]+0x001;  //okrag
; 0000 0771             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0772 
; 0000 0773     break;
; 0000 0774 
; 0000 0775       case 6:
_0xB3:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xB4
; 0000 0776 
; 0000 0777             a[0] = 0x0FE;   //ster1
	LDI  R30,LOW(254)
	LDI  R31,HIGH(254)
	CALL SUBOPT_0x35
; 0000 0778             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0779             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x39
; 0000 077A             a[5] = 0x190;   //delta okrag
; 0000 077B             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x53B
; 0000 077C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 077D 
; 0000 077E             a[1] = a[0]+0x001;  //ster2
; 0000 077F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0780             a[6] = a[5]+0x001;  //okrag
; 0000 0781             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0782 
; 0000 0783     break;
; 0000 0784 
; 0000 0785 
; 0000 0786       case 7:
_0xB4:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xB5
; 0000 0787 
; 0000 0788             a[0] = 0x078;   //ster1
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x35
; 0000 0789             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 078A             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 078B             a[5] = 0x196;   //delta okrag
	RJMP _0x53D
; 0000 078C             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 078D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 078E 
; 0000 078F             a[1] = a[0]+0x001;  //ster2
; 0000 0790             a[2] = a[4];        //ster4 ABS druciak
; 0000 0791             a[6] = a[5]+0x001;  //okrag
; 0000 0792             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0793 
; 0000 0794     break;
; 0000 0795 
; 0000 0796 
; 0000 0797       case 8:
_0xB5:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xB6
; 0000 0798 
; 0000 0799             a[0] = 0x0C0;   //ster1
	LDI  R30,LOW(192)
	LDI  R31,HIGH(192)
	CALL SUBOPT_0x35
; 0000 079A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 079B             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 079C             a[5] = 0x196;   //delta okrag
	RJMP _0x53D
; 0000 079D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 079E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 079F 
; 0000 07A0             a[1] = a[0]+0x001;  //ster2
; 0000 07A1             a[2] = a[4];        //ster4 ABS druciak
; 0000 07A2             a[6] = a[5]+0x001;  //okrag
; 0000 07A3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07A4 
; 0000 07A5     break;
; 0000 07A6 
; 0000 07A7 
; 0000 07A8       case 9:
_0xB6:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xB7
; 0000 07A9 
; 0000 07AA             a[0] = 0x018;   //ster1
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL SUBOPT_0x35
; 0000 07AB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 07AC             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 07AD             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 07AE             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 07AF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 07B0 
; 0000 07B1             a[1] = a[0]+0x001;  //ster2
; 0000 07B2             a[2] = a[4];        //ster4 ABS druciak
; 0000 07B3             a[6] = a[5]+0x001;  //okrag
; 0000 07B4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07B5 
; 0000 07B6     break;
; 0000 07B7 
; 0000 07B8 
; 0000 07B9       case 10:
_0xB7:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xB8
; 0000 07BA 
; 0000 07BB             a[0] = 0x016;   //ster1
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CALL SUBOPT_0x35
; 0000 07BC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 07BD             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 07BE             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 07BF             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07C0             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 07C1 
; 0000 07C2             a[1] = a[0]+0x001;  //ster2
; 0000 07C3             a[2] = a[4];        //ster4 ABS druciak
; 0000 07C4             a[6] = a[5]+0x001;  //okrag
; 0000 07C5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07C6 
; 0000 07C7     break;
; 0000 07C8 
; 0000 07C9 
; 0000 07CA       case 11:
_0xB8:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xB9
; 0000 07CB 
; 0000 07CC             a[0] = 0x074;   //ster1
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	CALL SUBOPT_0x35
; 0000 07CD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 07CE             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 07CF             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 07D0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07D1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 07D2 
; 0000 07D3             a[1] = a[0]+0x001;  //ster2
; 0000 07D4             a[2] = a[4];        //ster4 ABS druciak
; 0000 07D5             a[6] = a[5]+0x001;  //okrag
; 0000 07D6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07D7 
; 0000 07D8     break;
; 0000 07D9 
; 0000 07DA 
; 0000 07DB       case 12:
_0xB9:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xBA
; 0000 07DC 
; 0000 07DD             a[0] = 0x096;   //ster1
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x35
; 0000 07DE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 07DF             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 07E0             a[5] = 0x199;   //delta okrag
	RJMP _0x53D
; 0000 07E1             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07E2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07E3 
; 0000 07E4             a[1] = a[0]+0x001;  //ster2
; 0000 07E5             a[2] = a[4];        //ster4 ABS druciak
; 0000 07E6             a[6] = a[5]+0x001;  //okrag
; 0000 07E7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07E8 
; 0000 07E9     break;
; 0000 07EA 
; 0000 07EB 
; 0000 07EC       case 13:
_0xBA:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xBB
; 0000 07ED 
; 0000 07EE             a[0] = 0x01A;   //ster1
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	CALL SUBOPT_0x35
; 0000 07EF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 07F0             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 07F1             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 07F2             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 07F3             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07F4 
; 0000 07F5             a[1] = a[0]+0x001;  //ster2
; 0000 07F6             a[2] = a[4];        //ster4 ABS druciak
; 0000 07F7             a[6] = a[5]+0x001;  //okrag
; 0000 07F8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07F9 
; 0000 07FA     break;
; 0000 07FB 
; 0000 07FC 
; 0000 07FD       case 14:
_0xBB:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xBC
; 0000 07FE 
; 0000 07FF             a[0] = 0x05E;   //ster1
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	CALL SUBOPT_0x35
; 0000 0800             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0801             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0802             a[5] = 0x199;   //delta okrag
	RJMP _0x53D
; 0000 0803             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0804             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0805 
; 0000 0806             a[1] = a[0]+0x001;  //ster2
; 0000 0807             a[2] = a[4];        //ster4 ABS druciak
; 0000 0808             a[6] = a[5]+0x001;  //okrag
; 0000 0809             a[8] = a[6]+0x001;  //-delta okrag
; 0000 080A 
; 0000 080B     break;
; 0000 080C 
; 0000 080D 
; 0000 080E       case 15:
_0xBC:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xBD
; 0000 080F 
; 0000 0810             a[0] = 0x084;   //ster1
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	CALL SUBOPT_0x35
; 0000 0811             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0812             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0813             a[5] = 0x199;   //delta okrag
	RJMP _0x53D
; 0000 0814             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0815             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0816 
; 0000 0817             a[1] = a[0]+0x001;  //ster2
; 0000 0818             a[2] = a[4];        //ster4 ABS druciak
; 0000 0819             a[6] = a[5]+0x001;  //okrag
; 0000 081A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 081B 
; 0000 081C     break;
; 0000 081D 
; 0000 081E 
; 0000 081F       case 16:
_0xBD:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xBE
; 0000 0820 
; 0000 0821             a[0] = 0x0B8;   //ster1
	LDI  R30,LOW(184)
	LDI  R31,HIGH(184)
	CALL SUBOPT_0x35
; 0000 0822             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0823             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x43
; 0000 0824             a[5] = 0x199;   //delta okrag
; 0000 0825             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0826             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0827 
; 0000 0828             a[1] = a[0]+0x001;  //ster2
; 0000 0829             a[2] = a[4];        //ster4 ABS druciak
; 0000 082A             a[6] = a[5]+0x001;  //okrag
; 0000 082B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 082C 
; 0000 082D     break;
; 0000 082E 
; 0000 082F       case 17:
_0xBE:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xBF
; 0000 0830 
; 0000 0831             a[0] = 0x020;   //ster1
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x35
; 0000 0832             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0833             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x37
; 0000 0834             a[5] = 0x196;   //delta okrag
; 0000 0835             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0836             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0837 
; 0000 0838             a[1] = a[0]+0x001;  //ster2
; 0000 0839             a[2] = a[4];        //ster4 ABS druciak
; 0000 083A             a[6] = a[5]+0x001;  //okrag
; 0000 083B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 083C 
; 0000 083D     break;
; 0000 083E 
; 0000 083F 
; 0000 0840       case 18:
_0xBF:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xC0
; 0000 0841 
; 0000 0842             a[0] = 0x098;   //ster1
	LDI  R30,LOW(152)
	LDI  R31,HIGH(152)
	CALL SUBOPT_0x35
; 0000 0843             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0844             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0845             a[5] = 0x190;   //delta okrag
; 0000 0846             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x38
; 0000 0847             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3A
	RJMP _0x53C
; 0000 0848 
; 0000 0849             a[1] = a[0]+0x001;  //ster2
; 0000 084A             a[2] = a[4];        //ster4 ABS druciak
; 0000 084B             a[6] = a[5]+0x001;  //okrag
; 0000 084C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 084D 
; 0000 084E     break;
; 0000 084F 
; 0000 0850 
; 0000 0851 
; 0000 0852       case 19:
_0xC0:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xC1
; 0000 0853 
; 0000 0854             a[0] = 0x0AA;   //ster1
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	CALL SUBOPT_0x35
; 0000 0855             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0856             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0857             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x46
; 0000 0858             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0859             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 085A 
; 0000 085B             a[1] = a[0]+0x001;  //ster2
; 0000 085C             a[2] = a[4];        //ster4 ABS druciak
; 0000 085D             a[6] = a[5]+0x001;  //okrag
; 0000 085E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 085F 
; 0000 0860     break;
; 0000 0861 
; 0000 0862 
; 0000 0863       case 20:
_0xC1:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0xC2
; 0000 0864 
; 0000 0865             a[0] = 0x042;   //ster1
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	CALL SUBOPT_0x35
; 0000 0866             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0867             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0868             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x47
; 0000 0869             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 086A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 086B 
; 0000 086C             a[1] = a[0]+0x001;  //ster2
; 0000 086D             a[2] = a[4];        //ster4 ABS druciak
; 0000 086E             a[6] = a[5]+0x001;  //okrag
; 0000 086F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0870 
; 0000 0871     break;
; 0000 0872 
; 0000 0873 
; 0000 0874       case 21:
_0xC2:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0xC3
; 0000 0875 
; 0000 0876             a[0] = 0x04E;   //ster1
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	CALL SUBOPT_0x35
; 0000 0877             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0878             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x37
; 0000 0879             a[5] = 0x196;   //delta okrag
; 0000 087A             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 087B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 087C 
; 0000 087D             a[1] = a[0]+0x001;  //ster2
; 0000 087E             a[2] = a[4];        //ster4 ABS druciak
; 0000 087F             a[6] = a[5]+0x001;  //okrag
; 0000 0880             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0881 
; 0000 0882     break;
; 0000 0883 
; 0000 0884       case 22:
_0xC3:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0xC4
; 0000 0885 
; 0000 0886             a[0] = 0x0C2;   //ster1
	LDI  R30,LOW(194)
	LDI  R31,HIGH(194)
	CALL SUBOPT_0x35
; 0000 0887             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0888             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0889             a[5] = 0x190;   //delta okrag
; 0000 088A             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x53B
; 0000 088B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 088C 
; 0000 088D             a[1] = a[0]+0x001;  //ster2
; 0000 088E             a[2] = a[4];        //ster4 ABS druciak
; 0000 088F             a[6] = a[5]+0x001;  //okrag
; 0000 0890             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0891 
; 0000 0892     break;
; 0000 0893 
; 0000 0894 
; 0000 0895       case 23:
_0xC4:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0xC5
; 0000 0896 
; 0000 0897             a[0] = 0x0CE;   //ster1
	LDI  R30,LOW(206)
	LDI  R31,HIGH(206)
	CALL SUBOPT_0x35
; 0000 0898             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0899             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 089A             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x53D
; 0000 089B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 089C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 089D 
; 0000 089E             a[1] = a[0]+0x001;  //ster2
; 0000 089F             a[2] = a[4];        //ster4 ABS druciak
; 0000 08A0             a[6] = a[5]+0x001;  //okrag
; 0000 08A1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08A2 
; 0000 08A3     break;
; 0000 08A4 
; 0000 08A5 
; 0000 08A6       case 24:
_0xC5:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0xC6
; 0000 08A7 
; 0000 08A8             a[0] = 0x040;   //ster1
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL SUBOPT_0x35
; 0000 08A9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 08AA             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 08AB             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x47
; 0000 08AC             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 08AD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08AE 
; 0000 08AF             a[1] = a[0]+0x001;  //ster2
; 0000 08B0             a[2] = a[4];        //ster4 ABS druciak
; 0000 08B1             a[6] = a[5]+0x001;  //okrag
; 0000 08B2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08B3 
; 0000 08B4     break;
; 0000 08B5 
; 0000 08B6       case 25:
_0xC6:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0xC7
; 0000 08B7 
; 0000 08B8             a[0] = 0x02E;   //ster1
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	CALL SUBOPT_0x35
; 0000 08B9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 08BA             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 08BB             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 08BC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08BD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 08BE 
; 0000 08BF             a[1] = a[0]+0x001;  //ster2
; 0000 08C0             a[2] = a[4];        //ster4 ABS druciak
; 0000 08C1             a[6] = a[5]+0x001;  //okrag
; 0000 08C2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08C3 
; 0000 08C4     break;
; 0000 08C5 
; 0000 08C6       case 26:
_0xC7:
	CPI  R30,LOW(0x1A)
	LDI  R26,HIGH(0x1A)
	CPC  R31,R26
	BRNE _0xC8
; 0000 08C7 
; 0000 08C8             a[0] = 0x0FA;   //ster1
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x35
; 0000 08C9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 08CA             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 08CB             a[5] = 0x190;   //delta okrag
; 0000 08CC             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 08CD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 08CE 
; 0000 08CF             a[1] = a[0]+0x001;  //ster2
; 0000 08D0             a[2] = a[4];        //ster4 ABS druciak
; 0000 08D1             a[6] = a[5]+0x001;  //okrag
; 0000 08D2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08D3 
; 0000 08D4     break;
; 0000 08D5 
; 0000 08D6 
; 0000 08D7       case 27:
_0xC8:
	CPI  R30,LOW(0x1B)
	LDI  R26,HIGH(0x1B)
	CPC  R31,R26
	BRNE _0xC9
; 0000 08D8 
; 0000 08D9             a[0] = 0x06C;   //ster1
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	CALL SUBOPT_0x35
; 0000 08DA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 08DB             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x43
; 0000 08DC             a[5] = 0x199;   //delta okrag
; 0000 08DD             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08DE             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 08DF 
; 0000 08E0             a[1] = a[0]+0x001;  //ster2
; 0000 08E1             a[2] = a[4];        //ster4 ABS druciak
; 0000 08E2             a[6] = a[5]+0x001;  //okrag
; 0000 08E3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08E4 
; 0000 08E5     break;
; 0000 08E6 
; 0000 08E7 
; 0000 08E8       case 28:
_0xC9:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BRNE _0xCA
; 0000 08E9 
; 0000 08EA             a[0] = 0x0A4;   //ster1
	LDI  R30,LOW(164)
	LDI  R31,HIGH(164)
	CALL SUBOPT_0x35
; 0000 08EB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 08EC             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 08ED             a[5] = 0x199;   //delta okrag
	RJMP _0x53D
; 0000 08EE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08EF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08F0 
; 0000 08F1             a[1] = a[0]+0x001;  //ster2
; 0000 08F2             a[2] = a[4];        //ster4 ABS druciak
; 0000 08F3             a[6] = a[5]+0x001;  //okrag
; 0000 08F4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08F5 
; 0000 08F6     break;
; 0000 08F7 
; 0000 08F8       case 29:
_0xCA:
	CPI  R30,LOW(0x1D)
	LDI  R26,HIGH(0x1D)
	CPC  R31,R26
	BRNE _0xCB
; 0000 08F9 
; 0000 08FA             a[0] = 0x02A;   //ster1
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	CALL SUBOPT_0x35
; 0000 08FB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 08FC             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 08FD             a[5] = 0x199;   //delta okrag
	RJMP _0x53D
; 0000 08FE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08FF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0900 
; 0000 0901             a[1] = a[0]+0x001;  //ster2
; 0000 0902             a[2] = a[4];        //ster4 ABS druciak
; 0000 0903             a[6] = a[5]+0x001;  //okrag
; 0000 0904             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0905 
; 0000 0906 
; 0000 0907 
; 0000 0908 
; 0000 0909 
; 0000 090A     break;
; 0000 090B 
; 0000 090C       case 30:
_0xCB:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0xCC
; 0000 090D 
; 0000 090E             a[0] = 0x094;   //ster1
	LDI  R30,LOW(148)
	LDI  R31,HIGH(148)
	CALL SUBOPT_0x35
; 0000 090F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0910             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0911             a[5] = 0x190;   //delta okrag
; 0000 0912             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0913             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0914 
; 0000 0915             a[1] = a[0]+0x001;  //ster2
; 0000 0916             a[2] = a[4];        //ster4 ABS druciak
; 0000 0917             a[6] = a[5]+0x001;  //okrag
; 0000 0918             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0919 
; 0000 091A     break;
; 0000 091B 
; 0000 091C       case 31:
_0xCC:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0xCD
; 0000 091D 
; 0000 091E             a[0] = 0x06E;   //ster1
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	CALL SUBOPT_0x35
; 0000 091F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0920             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0921             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x53D
; 0000 0922             a[7] = 0x12;  //ster3 INV krazek scierny
; 0000 0923             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0924 
; 0000 0925             a[1] = a[0]+0x001;  //ster2
; 0000 0926             a[2] = a[4];        //ster4 ABS druciak
; 0000 0927             a[6] = a[5]+0x001;  //okrag
; 0000 0928             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0929 
; 0000 092A     break;
; 0000 092B 
; 0000 092C 
; 0000 092D        case 32:
_0xCD:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xCE
; 0000 092E 
; 0000 092F             a[0] = 0x086;   //ster1
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	CALL SUBOPT_0x35
; 0000 0930             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0931             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 0932             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 0933             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0934             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0935 
; 0000 0936             a[1] = a[0]+0x001;  //ster2
; 0000 0937             a[2] = a[4];        //ster4 ABS druciak
; 0000 0938             a[6] = a[5]+0x001;  //okrag
; 0000 0939             a[8] = a[6]+0x001;  //-delta okrag
; 0000 093A 
; 0000 093B     break;
; 0000 093C 
; 0000 093D        case 33:
_0xCE:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0xCF
; 0000 093E 
; 0000 093F             a[0] = 0x08E;   //ster1
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	CALL SUBOPT_0x35
; 0000 0940             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0941             a[4] = 0x20;    //ster3 ABS krazek scierny
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	RJMP _0x53E
; 0000 0942             a[5] = 0x19C;   //delta okrag
; 0000 0943             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0944             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0945 
; 0000 0946             a[1] = a[0]+0x001;  //ster2
; 0000 0947             a[2] = a[4];        //ster4 ABS druciak
; 0000 0948             a[6] = a[5]+0x001;  //okrag
; 0000 0949             a[8] = a[6]+0x001;  //-delta okrag
; 0000 094A 
; 0000 094B     break;
; 0000 094C 
; 0000 094D 
; 0000 094E     case 34: //86-1349
_0xCF:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0xD0
; 0000 094F 
; 0000 0950             a[0] = 0x05A;   //ster1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x35
; 0000 0951             a[3] = 0x11- 0x01;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0952             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 0953             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 0954             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0955             a[9] = 0;       //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0956 
; 0000 0957             a[1] = a[0]+0x001;  //ster2
; 0000 0958             a[2] = a[4];        //ster4 ABS druciak
; 0000 0959             a[6] = a[5]+0x001;  //okrag
; 0000 095A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 095B 
; 0000 095C     break;
; 0000 095D 
; 0000 095E 
; 0000 095F     case 35:
_0xD0:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0xD1
; 0000 0960 
; 0000 0961             a[0] = 0x0DA;   //ster1
	LDI  R30,LOW(218)
	LDI  R31,HIGH(218)
	CALL SUBOPT_0x35
; 0000 0962             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0963             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0964             a[5] = 0x190;   //delta okrag
; 0000 0965             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0966             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0967 
; 0000 0968             a[1] = a[0]+0x001;  //ster2
; 0000 0969             a[2] = a[4];        //ster4 ABS druciak
; 0000 096A             a[6] = a[5]+0x001;  //okrag
; 0000 096B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 096C 
; 0000 096D     break;
; 0000 096E 
; 0000 096F          case 36:
_0xD1:
	CPI  R30,LOW(0x24)
	LDI  R26,HIGH(0x24)
	CPC  R31,R26
	BRNE _0xD2
; 0000 0970 
; 0000 0971             a[0] = 0x0A2;   //ster1
	LDI  R30,LOW(162)
	LDI  R31,HIGH(162)
	CALL SUBOPT_0x35
; 0000 0972             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x4C
; 0000 0973             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 0974             a[5] = 0x196;   //delta okrag
; 0000 0975             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x38
; 0000 0976             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3A
	RJMP _0x53C
; 0000 0977 
; 0000 0978             a[1] = a[0]+0x001;  //ster2
; 0000 0979             a[2] = a[4];        //ster4 ABS druciak
; 0000 097A             a[6] = a[5]+0x001;  //okrag
; 0000 097B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 097C 
; 0000 097D     break;
; 0000 097E 
; 0000 097F          case 37:
_0xD2:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0xD3
; 0000 0980 
; 0000 0981             a[0] = 0x104;   //ster1
	LDI  R30,LOW(260)
	LDI  R31,HIGH(260)
	CALL SUBOPT_0x35
; 0000 0982             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0983             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0984             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0985             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0986             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0987 
; 0000 0988             a[1] = a[0]+0x001;  //ster2
; 0000 0989             a[2] = a[4];        //ster4 ABS druciak
; 0000 098A             a[6] = a[5]+0x001;  //okrag
; 0000 098B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 098C 
; 0000 098D     break;
; 0000 098E 
; 0000 098F          case 38:
_0xD3:
	CPI  R30,LOW(0x26)
	LDI  R26,HIGH(0x26)
	CPC  R31,R26
	BRNE _0xD4
; 0000 0990 
; 0000 0991             a[0] = 0x036;   //ster1
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	CALL SUBOPT_0x35
; 0000 0992             a[3] = 0x11 - 0x01;    //ster4 INV druciak  //korekta
	CALL SUBOPT_0x38
; 0000 0993             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 0994             a[5] = 0x196;   //delta okrag
	RJMP _0x53D
; 0000 0995             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0996             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0997 
; 0000 0998             a[1] = a[0]+0x001;  //ster2
; 0000 0999             a[2] = a[4];        //ster4 ABS druciak
; 0000 099A             a[6] = a[5]+0x001;  //okrag
; 0000 099B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 099C 
; 0000 099D     break;
; 0000 099E 
; 0000 099F 
; 0000 09A0          case 39:
_0xD4:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0xD5
; 0000 09A1 
; 0000 09A2             a[0] = 0x118;   //ster1
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	CALL SUBOPT_0x35
; 0000 09A3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 09A4             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 09A5             a[5] = 0x190;   //delta okrag
; 0000 09A6             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 09A7             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09A8 
; 0000 09A9             a[1] = a[0]+0x001;  //ster2
; 0000 09AA             a[2] = a[4];        //ster4 ABS druciak
; 0000 09AB             a[6] = a[5]+0x001;  //okrag
; 0000 09AC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09AD 
; 0000 09AE     break;
; 0000 09AF 
; 0000 09B0 
; 0000 09B1          case 40:
_0xD5:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0xD6
; 0000 09B2 
; 0000 09B3             a[0] = 0x0A6;   //ster1
	LDI  R30,LOW(166)
	LDI  R31,HIGH(166)
	CALL SUBOPT_0x35
; 0000 09B4             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x4C
; 0000 09B5             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 09B6             a[5] = 0x196;   //delta okrag
; 0000 09B7             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x53B
; 0000 09B8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09B9 
; 0000 09BA             a[1] = a[0]+0x001;  //ster2
; 0000 09BB             a[2] = a[4];        //ster4 ABS druciak
; 0000 09BC             a[6] = a[5]+0x001;  //okrag
; 0000 09BD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09BE 
; 0000 09BF     break;
; 0000 09C0 
; 0000 09C1          case 41:
_0xD6:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0xD7
; 0000 09C2 
; 0000 09C3             a[0] = 0x01E;   //ster1
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x35
; 0000 09C4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 09C5             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 09C6             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 09C7             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 09C8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09C9 
; 0000 09CA             a[1] = a[0]+0x001;  //ster2
; 0000 09CB             a[2] = a[4];        //ster4 ABS druciak
; 0000 09CC             a[6] = a[5]+0x001;  //okrag
; 0000 09CD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09CE 
; 0000 09CF     break;
; 0000 09D0 
; 0000 09D1 
; 0000 09D2          case 42:
_0xD7:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0xD8
; 0000 09D3 
; 0000 09D4             a[0] = 0x05C;   //ster1
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x35
; 0000 09D5             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 09D6             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 09D7             a[5] = 0x196;   //delta okrag
; 0000 09D8             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 09D9             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 09DA 
; 0000 09DB             a[1] = a[0]+0x001;  //ster2
; 0000 09DC             a[2] = a[4];        //ster4 ABS druciak
; 0000 09DD             a[6] = a[5]+0x001;  //okrag
; 0000 09DE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09DF 
; 0000 09E0     break;
; 0000 09E1 
; 0000 09E2 
; 0000 09E3          case 43:
_0xD8:
	CPI  R30,LOW(0x2B)
	LDI  R26,HIGH(0x2B)
	CPC  R31,R26
	BRNE _0xD9
; 0000 09E4 
; 0000 09E5             a[0] = 0x062;   //ster1
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL SUBOPT_0x35
; 0000 09E6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 09E7             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 09E8             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x50
; 0000 09E9             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 09EA             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 09EB 
; 0000 09EC             a[1] = a[0]+0x001;  //ster2
; 0000 09ED             a[2] = a[4];        //ster4 ABS druciak
; 0000 09EE             a[6] = a[5]+0x001;  //okrag
; 0000 09EF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09F0 
; 0000 09F1     break;
; 0000 09F2 
; 0000 09F3 
; 0000 09F4          case 44:
_0xD9:
	CPI  R30,LOW(0x2C)
	LDI  R26,HIGH(0x2C)
	CPC  R31,R26
	BRNE _0xDA
; 0000 09F5 
; 0000 09F6             a[0] = 0x;   //ster1
	CALL SUBOPT_0x51
; 0000 09F7             a[3] = 0x;    //ster4 INV druciak
; 0000 09F8             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 09F9             a[5] = 0x;   //delta okrag
; 0000 09FA             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 09FB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 09FC 
; 0000 09FD             a[1] = a[0]+0x001;  //ster2
; 0000 09FE             a[2] = a[4];        //ster4 ABS druciak
; 0000 09FF             a[6] = a[5]+0x001;  //okrag
; 0000 0A00             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A01 
; 0000 0A02     break;
; 0000 0A03 
; 0000 0A04 
; 0000 0A05          case 45:
_0xDA:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0xDB
; 0000 0A06 
; 0000 0A07             a[0] = 0x010;   //ster1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x35
; 0000 0A08             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0A09             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 0A0A             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3F
; 0000 0A0B             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0A0C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0A0D 
; 0000 0A0E             a[1] = a[0]+0x001;  //ster2
; 0000 0A0F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A10             a[6] = a[5]+0x001;  //okrag
; 0000 0A11             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A12 
; 0000 0A13     break;
; 0000 0A14 
; 0000 0A15 
; 0000 0A16     case 46:
_0xDB:
	CPI  R30,LOW(0x2E)
	LDI  R26,HIGH(0x2E)
	CPC  R31,R26
	BRNE _0xDC
; 0000 0A17 
; 0000 0A18             a[0] = 0x050;   //ster1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x35
; 0000 0A19             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0A1A             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0A1B             a[5] = 0x196;   //delta okrag
; 0000 0A1C             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0A1D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A1E 
; 0000 0A1F             a[1] = a[0]+0x001;  //ster2
; 0000 0A20             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A21             a[6] = a[5]+0x001;  //okrag
; 0000 0A22             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A23 
; 0000 0A24     break;
; 0000 0A25 
; 0000 0A26 
; 0000 0A27     case 47:
_0xDC:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BRNE _0xDD
; 0000 0A28 
; 0000 0A29             a[0] = 0x068;   //ster1
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	CALL SUBOPT_0x35
; 0000 0A2A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0A2B             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0A2C             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x53D
; 0000 0A2D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A2E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A2F 
; 0000 0A30             a[1] = a[0]+0x001;  //ster2
; 0000 0A31             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A32             a[6] = a[5]+0x001;  //okrag
; 0000 0A33             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A34 
; 0000 0A35     break;
; 0000 0A36 
; 0000 0A37 
; 0000 0A38 
; 0000 0A39     case 48:
_0xDD:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0xDE
; 0000 0A3A 
; 0000 0A3B             a[0] = 0x;   //ster1
	CALL SUBOPT_0x51
; 0000 0A3C             a[3] = 0x;    //ster4 INV druciak
; 0000 0A3D             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0A3E             a[5] = 0x;   //delta okrag
; 0000 0A3F             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0A40             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0A41 
; 0000 0A42             a[1] = a[0]+0x001;  //ster2
; 0000 0A43             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A44             a[6] = a[5]+0x001;  //okrag
; 0000 0A45             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A46 
; 0000 0A47     break;
; 0000 0A48 
; 0000 0A49 
; 0000 0A4A     case 49:
_0xDE:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xDF
; 0000 0A4B 
; 0000 0A4C             a[0] = 0x024;   //ster1
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL SUBOPT_0x35
; 0000 0A4D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0A4E             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 0A4F             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 0A50             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A51             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0A52 
; 0000 0A53             a[1] = a[0]+0x001;  //ster2
; 0000 0A54             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A55             a[6] = a[5]+0x001;  //okrag
; 0000 0A56             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A57 
; 0000 0A58     break;
; 0000 0A59 
; 0000 0A5A 
; 0000 0A5B     case 50:
_0xDF:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0xE0
; 0000 0A5C 
; 0000 0A5D             a[0] = 0x014;   //ster1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x35
; 0000 0A5E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0A5F             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0A60             a[5] = 0x190;   //delta okrag
; 0000 0A61             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0A62             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0A63 
; 0000 0A64             a[1] = a[0]+0x001;  //ster2
; 0000 0A65             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A66             a[6] = a[5]+0x001;  //okrag
; 0000 0A67             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A68 
; 0000 0A69     break;
; 0000 0A6A 
; 0000 0A6B     case 51:
_0xE0:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0xE1
; 0000 0A6C 
; 0000 0A6D             a[0] = 0x082;   //ster1
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	CALL SUBOPT_0x35
; 0000 0A6E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0A6F             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x52
; 0000 0A70             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0A71             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A72             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0A73 
; 0000 0A74             a[1] = a[0]+0x001;  //ster2
; 0000 0A75             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A76             a[6] = a[5]+0x001;  //okrag
; 0000 0A77             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A78 
; 0000 0A79     break;
; 0000 0A7A 
; 0000 0A7B     case 52:
_0xE1:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0xE2
; 0000 0A7C 
; 0000 0A7D             a[0] = 0x106;   //ster1
	LDI  R30,LOW(262)
	LDI  R31,HIGH(262)
	CALL SUBOPT_0x35
; 0000 0A7E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0A7F             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0A80             a[5] = 0x190;   //delta okrag
; 0000 0A81             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0A82             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A83 
; 0000 0A84             a[1] = a[0]+0x001;  //ster2
; 0000 0A85             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A86             a[6] = a[5]+0x001;  //okrag
; 0000 0A87             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A88 
; 0000 0A89     break;
; 0000 0A8A 
; 0000 0A8B 
; 0000 0A8C     case 53:
_0xE2:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0xE3
; 0000 0A8D 
; 0000 0A8E             a[0] = 0x04C;   //ster1
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x35
; 0000 0A8F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0A90             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 0A91             a[5] = 0x196;   //delta okrag
	RJMP _0x53D
; 0000 0A92             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A93             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A94 
; 0000 0A95             a[1] = a[0]+0x001;  //ster2
; 0000 0A96             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A97             a[6] = a[5]+0x001;  //okrag
; 0000 0A98             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A99 
; 0000 0A9A     break;
; 0000 0A9B 
; 0000 0A9C 
; 0000 0A9D     case 54:
_0xE3:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0xE4
; 0000 0A9E 
; 0000 0A9F             a[0] = 0x01C;   //ster1
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	CALL SUBOPT_0x35
; 0000 0AA0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0AA1             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0AA2             a[5] = 0x190;   //delta okrag
; 0000 0AA3             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0AA4             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AA5 
; 0000 0AA6             a[1] = a[0]+0x001;  //ster2
; 0000 0AA7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AA8             a[6] = a[5]+0x001;  //okrag
; 0000 0AA9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AAA 
; 0000 0AAB     break;
; 0000 0AAC 
; 0000 0AAD     case 55:
_0xE4:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0xE5
; 0000 0AAE 
; 0000 0AAF             a[0] = 0x114;   //ster1
	LDI  R30,LOW(276)
	LDI  R31,HIGH(276)
	CALL SUBOPT_0x35
; 0000 0AB0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0AB1             a[4] = 0x1A;    //ster3 ABS krazek scierny
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	RJMP _0x53E
; 0000 0AB2             a[5] = 0x19C;   //delta okrag
; 0000 0AB3             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AB4             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AB5 
; 0000 0AB6             a[1] = a[0]+0x001;  //ster2
; 0000 0AB7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AB8             a[6] = a[5]+0x001;  //okrag
; 0000 0AB9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ABA 
; 0000 0ABB     break;
; 0000 0ABC 
; 0000 0ABD 
; 0000 0ABE     case 56:
_0xE5:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0xE6
; 0000 0ABF 
; 0000 0AC0             a[0] = 0x0EE;   //ster1
	LDI  R30,LOW(238)
	LDI  R31,HIGH(238)
	CALL SUBOPT_0x35
; 0000 0AC1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0AC2             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0AC3             a[5] = 0x190;   //delta okrag
; 0000 0AC4             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0AC5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0AC6 
; 0000 0AC7             a[1] = a[0]+0x001;  //ster2
; 0000 0AC8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AC9             a[6] = a[5]+0x001;  //okrag
; 0000 0ACA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ACB 
; 0000 0ACC     break;
; 0000 0ACD 
; 0000 0ACE 
; 0000 0ACF     case 57:
_0xE6:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0xE7
; 0000 0AD0 
; 0000 0AD1             a[0] = 0x0F8;   //ster1
	LDI  R30,LOW(248)
	LDI  R31,HIGH(248)
	CALL SUBOPT_0x35
; 0000 0AD2             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0AD3             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x54
; 0000 0AD4             a[5] = 0x190;   //delta okrag
; 0000 0AD5             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0AD6             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0AD7 
; 0000 0AD8             a[1] = a[0]+0x001;  //ster2
; 0000 0AD9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0ADA             a[6] = a[5]+0x001;  //okrag
; 0000 0ADB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ADC 
; 0000 0ADD     break;
; 0000 0ADE 
; 0000 0ADF 
; 0000 0AE0     case 58:
_0xE7:
	CPI  R30,LOW(0x3A)
	LDI  R26,HIGH(0x3A)
	CPC  R31,R26
	BRNE _0xE8
; 0000 0AE1 
; 0000 0AE2             a[0] = 0x0E4;   //ster1
	LDI  R30,LOW(228)
	LDI  R31,HIGH(228)
	CALL SUBOPT_0x35
; 0000 0AE3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0AE4             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0AE5             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x50
; 0000 0AE6             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AE7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0AE8 
; 0000 0AE9             a[1] = a[0]+0x001;  //ster2
; 0000 0AEA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AEB             a[6] = a[5]+0x001;  //okrag
; 0000 0AEC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AED 
; 0000 0AEE     break;
; 0000 0AEF 
; 0000 0AF0 
; 0000 0AF1     case 59:
_0xE8:
	CPI  R30,LOW(0x3B)
	LDI  R26,HIGH(0x3B)
	CPC  R31,R26
	BRNE _0xE9
; 0000 0AF2 
; 0000 0AF3             a[0] = 0x052;   //ster1
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	CALL SUBOPT_0x35
; 0000 0AF4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0AF5             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0AF6             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x46
; 0000 0AF7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AF8             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0AF9 
; 0000 0AFA             a[1] = a[0]+0x001;  //ster2
; 0000 0AFB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AFC             a[6] = a[5]+0x001;  //okrag
; 0000 0AFD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AFE 
; 0000 0AFF     break;
; 0000 0B00 
; 0000 0B01 
; 0000 0B02     case 60:
_0xE9:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BRNE _0xEA
; 0000 0B03 
; 0000 0B04             a[0] = 0x090;   //ster1
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0x35
; 0000 0B05             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0B06             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 0B07             a[5] = 0x190;   //delta okrag
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL SUBOPT_0x3F
; 0000 0B08             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0B09             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0B0A 
; 0000 0B0B             a[1] = a[0]+0x001;  //ster2
; 0000 0B0C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B0D             a[6] = a[5]+0x001;  //okrag
; 0000 0B0E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B0F 
; 0000 0B10     break;
; 0000 0B11 
; 0000 0B12 
; 0000 0B13     case 61:
_0xEA:
	CPI  R30,LOW(0x3D)
	LDI  R26,HIGH(0x3D)
	CPC  R31,R26
	BRNE _0xEB
; 0000 0B14 
; 0000 0B15             a[0] = 0x0FC;   //ster1
	LDI  R30,LOW(252)
	LDI  R31,HIGH(252)
	CALL SUBOPT_0x35
; 0000 0B16             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0B17             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0B18             a[5] = 0x190;   //delta okrag
; 0000 0B19             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0B1A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B1B 
; 0000 0B1C             a[1] = a[0]+0x001;  //ster2
; 0000 0B1D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B1E             a[6] = a[5]+0x001;  //okrag
; 0000 0B1F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B20 
; 0000 0B21     break;
; 0000 0B22 
; 0000 0B23 
; 0000 0B24     case 62:
_0xEB:
	CPI  R30,LOW(0x3E)
	LDI  R26,HIGH(0x3E)
	CPC  R31,R26
	BRNE _0xEC
; 0000 0B25 
; 0000 0B26             a[0] = 0x028;   //ster1
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x35
; 0000 0B27             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0B28             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0B29             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x53D
; 0000 0B2A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B2B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B2C 
; 0000 0B2D             a[1] = a[0]+0x001;  //ster2
; 0000 0B2E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B2F             a[6] = a[5]+0x001;  //okrag
; 0000 0B30             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B31 
; 0000 0B32     break;
; 0000 0B33 
; 0000 0B34 
; 0000 0B35     case 63:
_0xEC:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0xED
; 0000 0B36 
; 0000 0B37             a[0] = 0x034;   //ster1
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	CALL SUBOPT_0x35
; 0000 0B38             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0B39             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0B3A             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x53D
; 0000 0B3B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B3C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B3D 
; 0000 0B3E             a[1] = a[0]+0x001;  //ster2
; 0000 0B3F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B40             a[6] = a[5]+0x001;  //okrag
; 0000 0B41             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B42 
; 0000 0B43     break;
; 0000 0B44 
; 0000 0B45 
; 0000 0B46     case 64:
_0xED:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0xEE
; 0000 0B47 
; 0000 0B48             a[0] = 0x0EC;   //ster1
	LDI  R30,LOW(236)
	LDI  R31,HIGH(236)
	CALL SUBOPT_0x35
; 0000 0B49             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0B4A             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x54
; 0000 0B4B             a[5] = 0x190;   //delta okrag
; 0000 0B4C             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0B4D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B4E 
; 0000 0B4F             a[1] = a[0]+0x001;  //ster2
; 0000 0B50             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B51             a[6] = a[5]+0x001;  //okrag
; 0000 0B52             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B53 
; 0000 0B54     break;
; 0000 0B55 
; 0000 0B56 
; 0000 0B57     case 65:
_0xEE:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0xEF
; 0000 0B58 
; 0000 0B59             a[0] = 0x0CC;   //ster1
	LDI  R30,LOW(204)
	LDI  R31,HIGH(204)
	CALL SUBOPT_0x35
; 0000 0B5A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0B5B             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0B5C             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 0B5D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B5E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0B5F 
; 0000 0B60             a[1] = a[0]+0x001;  //ster2
; 0000 0B61             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B62             a[6] = a[5]+0x001;  //okrag
; 0000 0B63             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B64 
; 0000 0B65     break;
; 0000 0B66 
; 0000 0B67 
; 0000 0B68     case 66:
_0xEF:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0xF0
; 0000 0B69 
; 0000 0B6A             a[0] = 0x0BC;   //ster1
	LDI  R30,LOW(188)
	LDI  R31,HIGH(188)
	CALL SUBOPT_0x35
; 0000 0B6B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0B6C             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0B6D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x58
; 0000 0B6E             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0B6F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B70 
; 0000 0B71             a[1] = a[0]+0x001;  //ster2
; 0000 0B72             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B73             a[6] = a[5]+0x001;  //okrag
; 0000 0B74             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B75 
; 0000 0B76     break;
; 0000 0B77 
; 0000 0B78 
; 0000 0B79     case 67:
_0xF0:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xF1
; 0000 0B7A 
; 0000 0B7B             a[0] = 0x09C;   //ster1
	LDI  R30,LOW(156)
	LDI  R31,HIGH(156)
	CALL SUBOPT_0x35
; 0000 0B7C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0B7D             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0B7E             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x53D
; 0000 0B7F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B80             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B81 
; 0000 0B82             a[1] = a[0]+0x001;  //ster2
; 0000 0B83             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B84             a[6] = a[5]+0x001;  //okrag
; 0000 0B85             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B86 
; 0000 0B87     break;
; 0000 0B88 
; 0000 0B89 
; 0000 0B8A     case 68:
_0xF1:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0xF2
; 0000 0B8B 
; 0000 0B8C             a[0] = 0x07C;   //ster1
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	CALL SUBOPT_0x35
; 0000 0B8D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0B8E             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 0B8F             a[5] = 0x199;   //delta okrag
	RJMP _0x53D
; 0000 0B90             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B91             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B92 
; 0000 0B93             a[1] = a[0]+0x001;  //ster2
; 0000 0B94             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B95             a[6] = a[5]+0x001;  //okrag
; 0000 0B96             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B97 
; 0000 0B98     break;
; 0000 0B99 
; 0000 0B9A 
; 0000 0B9B     case 69:
_0xF2:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BRNE _0xF3
; 0000 0B9C 
; 0000 0B9D             a[0] = 0x0D2;   //ster1
	LDI  R30,LOW(210)
	LDI  R31,HIGH(210)
	CALL SUBOPT_0x35
; 0000 0B9E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0B9F             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0BA0             a[5] = 0x193;   //delta okrag
	RJMP _0x53D
; 0000 0BA1             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BA2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0BA3 
; 0000 0BA4             a[1] = a[0]+0x001;  //ster2
; 0000 0BA5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BA6             a[6] = a[5]+0x001;  //okrag
; 0000 0BA7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BA8 
; 0000 0BA9     break;
; 0000 0BAA 
; 0000 0BAB 
; 0000 0BAC     case 70:
_0xF3:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BRNE _0xF4
; 0000 0BAD 
; 0000 0BAE             a[0] = 0x0E6;   //ster1
	LDI  R30,LOW(230)
	LDI  R31,HIGH(230)
	CALL SUBOPT_0x35
; 0000 0BAF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0BB0             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0BB1             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x58
; 0000 0BB2             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0BB3             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0BB4 
; 0000 0BB5             a[1] = a[0]+0x001;  //ster2
; 0000 0BB6             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BB7             a[6] = a[5]+0x001;  //okrag
; 0000 0BB8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BB9 
; 0000 0BBA     break;
; 0000 0BBB 
; 0000 0BBC 
; 0000 0BBD     case 71:
_0xF4:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BRNE _0xF5
; 0000 0BBE 
; 0000 0BBF             a[0] = 0x0B4;   //ster1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x35
; 0000 0BC0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0BC1             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0BC2             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x50
; 0000 0BC3             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BC4             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0BC5 
; 0000 0BC6             a[1] = a[0]+0x001;  //ster2
; 0000 0BC7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BC8             a[6] = a[5]+0x001;  //okrag
; 0000 0BC9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BCA 
; 0000 0BCB     break;
; 0000 0BCC 
; 0000 0BCD 
; 0000 0BCE     case 72:
_0xF5:
	CPI  R30,LOW(0x48)
	LDI  R26,HIGH(0x48)
	CPC  R31,R26
	BRNE _0xF6
; 0000 0BCF 
; 0000 0BD0             a[0] = 0x0AC;   //ster1
	LDI  R30,LOW(172)
	LDI  R31,HIGH(172)
	CALL SUBOPT_0x35
; 0000 0BD1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0BD2             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 0BD3             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 0BD4             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BD5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0BD6 
; 0000 0BD7             a[1] = a[0]+0x001;  //ster2
; 0000 0BD8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BD9             a[6] = a[5]+0x001;  //okrag
; 0000 0BDA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BDB 
; 0000 0BDC     break;
; 0000 0BDD 
; 0000 0BDE 
; 0000 0BDF     case 73:
_0xF6:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BRNE _0xF7
; 0000 0BE0 
; 0000 0BE1             a[0] = 0x012;   //ster1
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CALL SUBOPT_0x35
; 0000 0BE2             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0BE3             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x52
; 0000 0BE4             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x50
; 0000 0BE5             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BE6             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0BE7 
; 0000 0BE8             a[1] = a[0]+0x001;  //ster2
; 0000 0BE9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BEA             a[6] = a[5]+0x001;  //okrag
; 0000 0BEB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BEC 
; 0000 0BED     break;
; 0000 0BEE 
; 0000 0BEF 
; 0000 0BF0     case 74:
_0xF7:
	CPI  R30,LOW(0x4A)
	LDI  R26,HIGH(0x4A)
	CPC  R31,R26
	BRNE _0xF8
; 0000 0BF1 
; 0000 0BF2             a[0] = 0x0B2;   //ster1
	LDI  R30,LOW(178)
	LDI  R31,HIGH(178)
	CALL SUBOPT_0x35
; 0000 0BF3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0BF4             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 0BF5             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 0BF6             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BF7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0BF8 
; 0000 0BF9             a[1] = a[0]+0x001;  //ster2
; 0000 0BFA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BFB             a[6] = a[5]+0x001;  //okrag
; 0000 0BFC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BFD 
; 0000 0BFE     break;
; 0000 0BFF 
; 0000 0C00 
; 0000 0C01     case 75:
_0xF8:
	CPI  R30,LOW(0x4B)
	LDI  R26,HIGH(0x4B)
	CPC  R31,R26
	BRNE _0xF9
; 0000 0C02 
; 0000 0C03             a[0] = 0x10C;   //ster1
	LDI  R30,LOW(268)
	LDI  R31,HIGH(268)
	CALL SUBOPT_0x35
; 0000 0C04             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0C05             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0C06             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x50
; 0000 0C07             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C08             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0C09 
; 0000 0C0A             a[1] = a[0]+0x001;  //ster2
; 0000 0C0B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C0C             a[6] = a[5]+0x001;  //okrag
; 0000 0C0D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C0E 
; 0000 0C0F     break;
; 0000 0C10 
; 0000 0C11 
; 0000 0C12     case 76:
_0xF9:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0xFA
; 0000 0C13 
; 0000 0C14             a[0] = 0x;   //ster1
	CALL SUBOPT_0x51
; 0000 0C15             a[3] = 0x;    //ster4 INV druciak
; 0000 0C16             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0C17             a[5] = 0x;   //delta okrag
; 0000 0C18             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0C19             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0C1A 
; 0000 0C1B             a[1] = a[0]+0x001;  //ster2
; 0000 0C1C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C1D             a[6] = a[5]+0x001;  //okrag
; 0000 0C1E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C1F 
; 0000 0C20     break;
; 0000 0C21 
; 0000 0C22 
; 0000 0C23     case 77:
_0xFA:
	CPI  R30,LOW(0x4D)
	LDI  R26,HIGH(0x4D)
	CPC  R31,R26
	BRNE _0xFB
; 0000 0C24 
; 0000 0C25             a[0] = 0x026;   //ster1
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL SUBOPT_0x35
; 0000 0C26             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0C27             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x52
; 0000 0C28             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x53D
; 0000 0C29             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C2A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C2B 
; 0000 0C2C             a[1] = a[0]+0x001;  //ster2
; 0000 0C2D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C2E             a[6] = a[5]+0x001;  //okrag
; 0000 0C2F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C30 
; 0000 0C31     break;
; 0000 0C32 
; 0000 0C33 
; 0000 0C34     case 78:
_0xFB:
	CPI  R30,LOW(0x4E)
	LDI  R26,HIGH(0x4E)
	CPC  R31,R26
	BRNE _0xFC
; 0000 0C35 
; 0000 0C36             a[0] = 0x11C;   //ster1
	LDI  R30,LOW(284)
	LDI  R31,HIGH(284)
	CALL SUBOPT_0x35
; 0000 0C37             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0C38             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0C39             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x53D
; 0000 0C3A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C3B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C3C 
; 0000 0C3D             a[1] = a[0]+0x001;  //ster2
; 0000 0C3E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C3F             a[6] = a[5]+0x001;  //okrag
; 0000 0C40             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C41 
; 0000 0C42     break;
; 0000 0C43 
; 0000 0C44 
; 0000 0C45     case 79:
_0xFC:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0xFD
; 0000 0C46 
; 0000 0C47             a[0] = 0x112;   //ster1
	LDI  R30,LOW(274)
	LDI  R31,HIGH(274)
	CALL SUBOPT_0x35
; 0000 0C48             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0C49             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0C4A             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x53D
; 0000 0C4B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C4C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C4D 
; 0000 0C4E             a[1] = a[0]+0x001;  //ster2
; 0000 0C4F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C50             a[6] = a[5]+0x001;  //okrag
; 0000 0C51             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C52 
; 0000 0C53     break;
; 0000 0C54 
; 0000 0C55     case 80:
_0xFD:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0xFE
; 0000 0C56 
; 0000 0C57             a[0] = 0x;   //ster1
	CALL SUBOPT_0x51
; 0000 0C58             a[3] = 0x;    //ster4 INV druciak
; 0000 0C59             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0C5A             a[5] = 0x;   //delta okrag
; 0000 0C5B             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0C5C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0C5D 
; 0000 0C5E             a[1] = a[0]+0x001;  //ster2
; 0000 0C5F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C60             a[6] = a[5]+0x001;  //okrag
; 0000 0C61             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C62 
; 0000 0C63     break;
; 0000 0C64 
; 0000 0C65     case 81:
_0xFE:
	CPI  R30,LOW(0x51)
	LDI  R26,HIGH(0x51)
	CPC  R31,R26
	BRNE _0xFF
; 0000 0C66 
; 0000 0C67             a[0] = 0x0EA;   //ster1
	LDI  R30,LOW(234)
	LDI  R31,HIGH(234)
	CALL SUBOPT_0x35
; 0000 0C68             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0C69             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5A
; 0000 0C6A             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 0C6B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C6C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0C6D 
; 0000 0C6E             a[1] = a[0]+0x001;  //ster2
; 0000 0C6F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C70             a[6] = a[5]+0x001;  //okrag
; 0000 0C71             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C72 
; 0000 0C73     break;
; 0000 0C74 
; 0000 0C75 
; 0000 0C76     case 82:
_0xFF:
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BRNE _0x100
; 0000 0C77 
; 0000 0C78             a[0] = 0x0D8;   //ster1
	LDI  R30,LOW(216)
	LDI  R31,HIGH(216)
	CALL SUBOPT_0x35
; 0000 0C79             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0C7A             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0C7B             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 0C7C             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C7D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0C7E 
; 0000 0C7F             a[1] = a[0]+0x001;  //ster2
; 0000 0C80             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C81             a[6] = a[5]+0x001;  //okrag
; 0000 0C82             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C83 
; 0000 0C84     break;
; 0000 0C85 
; 0000 0C86 
; 0000 0C87     case 83:
_0x100:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x101
; 0000 0C88 
; 0000 0C89             a[0] = 0x08C;   //ster1
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	CALL SUBOPT_0x35
; 0000 0C8A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0C8B             a[4] = 0x22;    //ster3 ABS krazek scierny
	LDI  R26,LOW(34)
	LDI  R27,HIGH(34)
	CALL SUBOPT_0x5C
; 0000 0C8C             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x53D
; 0000 0C8D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C8E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C8F 
; 0000 0C90             a[1] = a[0]+0x001;  //ster2
; 0000 0C91             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C92             a[6] = a[5]+0x001;  //okrag
; 0000 0C93             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C94 
; 0000 0C95     break;
; 0000 0C96 
; 0000 0C97 
; 0000 0C98     case 84:
_0x101:
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x102
; 0000 0C99 
; 0000 0C9A             a[0] = 0x0A0;   //ster1
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	CALL SUBOPT_0x35
; 0000 0C9B             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x5D
; 0000 0C9C             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0C9D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0C9E             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x53B
; 0000 0C9F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CA0 
; 0000 0CA1             a[1] = a[0]+0x001;  //ster2
; 0000 0CA2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CA3             a[6] = a[5]+0x001;  //okrag
; 0000 0CA4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CA5 
; 0000 0CA6     break;
; 0000 0CA7 
; 0000 0CA8 
; 0000 0CA9    case 85:
_0x102:
	CPI  R30,LOW(0x55)
	LDI  R26,HIGH(0x55)
	CPC  R31,R26
	BRNE _0x103
; 0000 0CAA 
; 0000 0CAB             a[0] = 0x0AE;   //ster1
	LDI  R30,LOW(174)
	LDI  R31,HIGH(174)
	CALL SUBOPT_0x35
; 0000 0CAC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0CAD             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5A
; 0000 0CAE             a[5] = 0x193;   //delta okrag
	RJMP _0x53D
; 0000 0CAF             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CB0             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CB1 
; 0000 0CB2             a[1] = a[0]+0x001;  //ster2
; 0000 0CB3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CB4             a[6] = a[5]+0x001;  //okrag
; 0000 0CB5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CB6 
; 0000 0CB7     break;
; 0000 0CB8 
; 0000 0CB9     case 86:
_0x103:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BRNE _0x104
; 0000 0CBA 
; 0000 0CBB             a[0] = 0x0F6;   //ster1
	LDI  R30,LOW(246)
	LDI  R31,HIGH(246)
	CALL SUBOPT_0x35
; 0000 0CBC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0CBD             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0CBE             a[5] = 0x190;   //delta okrag
	RJMP _0x53D
; 0000 0CBF             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CC0             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CC1 
; 0000 0CC2             a[1] = a[0]+0x001;  //ster2
; 0000 0CC3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CC4             a[6] = a[5]+0x001;  //okrag
; 0000 0CC5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CC6 
; 0000 0CC7     break;
; 0000 0CC8 
; 0000 0CC9 
; 0000 0CCA     case 87:
_0x104:
	CPI  R30,LOW(0x57)
	LDI  R26,HIGH(0x57)
	CPC  R31,R26
	BRNE _0x105
; 0000 0CCB 
; 0000 0CCC             a[0] = 0x0C4;   //ster1
	LDI  R30,LOW(196)
	LDI  R31,HIGH(196)
	CALL SUBOPT_0x35
; 0000 0CCD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0CCE             a[4] = 0x23;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5F
; 0000 0CCF             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x46
; 0000 0CD0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CD1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0CD2 
; 0000 0CD3             a[1] = a[0]+0x001;  //ster2
; 0000 0CD4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CD5             a[6] = a[5]+0x001;  //okrag
; 0000 0CD6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CD7 
; 0000 0CD8     break;
; 0000 0CD9 
; 0000 0CDA 
; 0000 0CDB     case 88:
_0x105:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x106
; 0000 0CDC 
; 0000 0CDD             a[0] = 0x07E;   //ster1
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	CALL SUBOPT_0x35
; 0000 0CDE             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x5D
; 0000 0CDF             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0CE0             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0CE1             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x38
; 0000 0CE2             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3A
	RJMP _0x53C
; 0000 0CE3 
; 0000 0CE4             a[1] = a[0]+0x001;  //ster2
; 0000 0CE5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CE6             a[6] = a[5]+0x001;  //okrag
; 0000 0CE7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CE8 
; 0000 0CE9     break;
; 0000 0CEA 
; 0000 0CEB 
; 0000 0CEC     case 89:
_0x106:
	CPI  R30,LOW(0x59)
	LDI  R26,HIGH(0x59)
	CPC  R31,R26
	BRNE _0x107
; 0000 0CED 
; 0000 0CEE             a[0] = 0x02C;   //ster1
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x35
; 0000 0CEF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0CF0             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 0CF1             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x50
; 0000 0CF2             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CF3             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0CF4 
; 0000 0CF5             a[1] = a[0]+0x001;  //ster2
; 0000 0CF6             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CF7             a[6] = a[5]+0x001;  //okrag
; 0000 0CF8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CF9 
; 0000 0CFA     break;
; 0000 0CFB 
; 0000 0CFC 
; 0000 0CFD     case 90:
_0x107:
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BRNE _0x108
; 0000 0CFE 
; 0000 0CFF             a[0] = 0x0F0;   //ster1
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	CALL SUBOPT_0x35
; 0000 0D00             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0D01             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x37
; 0000 0D02             a[5] = 0x196;   //delta okrag
; 0000 0D03             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0D04             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D05 
; 0000 0D06             a[1] = a[0]+0x001;  //ster2
; 0000 0D07             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D08             a[6] = a[5]+0x001;  //okrag
; 0000 0D09             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D0A 
; 0000 0D0B     break;
; 0000 0D0C 
; 0000 0D0D 
; 0000 0D0E     case 91:
_0x108:
	CPI  R30,LOW(0x5B)
	LDI  R26,HIGH(0x5B)
	CPC  R31,R26
	BRNE _0x109
; 0000 0D0F 
; 0000 0D10             a[0] = 0x0A8;   //ster1
	LDI  R30,LOW(168)
	LDI  R31,HIGH(168)
	CALL SUBOPT_0x35
; 0000 0D11             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0D12             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0D13             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x53D
; 0000 0D14             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D15             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D16 
; 0000 0D17             a[1] = a[0]+0x001;  //ster2
; 0000 0D18             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D19             a[6] = a[5]+0x001;  //okrag
; 0000 0D1A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D1B 
; 0000 0D1C     break;
; 0000 0D1D 
; 0000 0D1E 
; 0000 0D1F     case 92:
_0x109:
	CPI  R30,LOW(0x5C)
	LDI  R26,HIGH(0x5C)
	CPC  R31,R26
	BRNE _0x10A
; 0000 0D20 
; 0000 0D21             a[0] = 0x;   //ster1
	CALL SUBOPT_0x51
; 0000 0D22             a[3] = 0x;    //ster4 INV druciak
; 0000 0D23             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0D24             a[5] = 0x;   //delta okrag
; 0000 0D25             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0D26             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0D27 
; 0000 0D28             a[1] = a[0]+0x001;  //ster2
; 0000 0D29             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D2A             a[6] = a[5]+0x001;  //okrag
; 0000 0D2B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D2C 
; 0000 0D2D     break;
; 0000 0D2E 
; 0000 0D2F 
; 0000 0D30     case 93:
_0x10A:
	CPI  R30,LOW(0x5D)
	LDI  R26,HIGH(0x5D)
	CPC  R31,R26
	BRNE _0x10B
; 0000 0D31 
; 0000 0D32             a[0] = 0x030;   //ster1
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x35
; 0000 0D33             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0D34             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 0D35             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x53D
; 0000 0D36             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D37             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D38 
; 0000 0D39             a[1] = a[0]+0x001;  //ster2
; 0000 0D3A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D3B             a[6] = a[5]+0x001;  //okrag
; 0000 0D3C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D3D 
; 0000 0D3E     break;
; 0000 0D3F 
; 0000 0D40 
; 0000 0D41     case 94:
_0x10B:
	CPI  R30,LOW(0x5E)
	LDI  R26,HIGH(0x5E)
	CPC  R31,R26
	BRNE _0x10C
; 0000 0D42 
; 0000 0D43             a[0] = 0x0F4;   //ster1
	LDI  R30,LOW(244)
	LDI  R31,HIGH(244)
	CALL SUBOPT_0x35
; 0000 0D44             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0D45             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x37
; 0000 0D46             a[5] = 0x196;   //delta okrag
; 0000 0D47             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0D48             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0D49 
; 0000 0D4A             a[1] = a[0]+0x001;  //ster2
; 0000 0D4B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D4C             a[6] = a[5]+0x001;  //okrag
; 0000 0D4D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D4E 
; 0000 0D4F     break;
; 0000 0D50 
; 0000 0D51 
; 0000 0D52     case 95:
_0x10C:
	CPI  R30,LOW(0x5F)
	LDI  R26,HIGH(0x5F)
	CPC  R31,R26
	BRNE _0x10D
; 0000 0D53 
; 0000 0D54             a[0] = 0x09E;   //ster1
	LDI  R30,LOW(158)
	LDI  R31,HIGH(158)
	CALL SUBOPT_0x35
; 0000 0D55             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0D56             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x43
; 0000 0D57             a[5] = 0x199;   //delta okrag
; 0000 0D58             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D59             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0D5A 
; 0000 0D5B             a[1] = a[0]+0x001;  //ster2
; 0000 0D5C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D5D             a[6] = a[5]+0x001;  //okrag
; 0000 0D5E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D5F 
; 0000 0D60     break;
; 0000 0D61 
; 0000 0D62     case 96:
_0x10D:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x10E
; 0000 0D63 
; 0000 0D64             a[0] = 0x;   //ster1
	CALL SUBOPT_0x51
; 0000 0D65             a[3] = 0x;    //ster4 INV druciak
; 0000 0D66             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0D67             a[5] = 0x;   //delta okrag
; 0000 0D68             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0D69             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0D6A 
; 0000 0D6B             a[1] = a[0]+0x001;  //ster2
; 0000 0D6C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D6D             a[6] = a[5]+0x001;  //okrag
; 0000 0D6E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D6F 
; 0000 0D70     break;
; 0000 0D71 
; 0000 0D72 
; 0000 0D73     case 97:
_0x10E:
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BRNE _0x10F
; 0000 0D74 
; 0000 0D75             a[0] = 0x06A;   //ster1
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	CALL SUBOPT_0x35
; 0000 0D76             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0D77             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 0D78             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 0D79             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D7A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0D7B 
; 0000 0D7C             a[1] = a[0]+0x001;  //ster2
; 0000 0D7D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D7E             a[6] = a[5]+0x001;  //okrag
; 0000 0D7F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D80 
; 0000 0D81     break;
; 0000 0D82 
; 0000 0D83 
; 0000 0D84     case 98:
_0x10F:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x110
; 0000 0D85 
; 0000 0D86             a[0] = 0x0BE;   //ster1
	LDI  R30,LOW(190)
	LDI  R31,HIGH(190)
	CALL SUBOPT_0x35
; 0000 0D87             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0D88             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0D89             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x60
; 0000 0D8A             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0D8B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0D8C 
; 0000 0D8D             a[1] = a[0]+0x001;  //ster2
; 0000 0D8E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D8F             a[6] = a[5]+0x001;  //okrag
; 0000 0D90             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D91 
; 0000 0D92     break;
; 0000 0D93 
; 0000 0D94 
; 0000 0D95     case 99:
_0x110:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x111
; 0000 0D96 
; 0000 0D97             a[0] = 0x0BA;   //ster1
	LDI  R30,LOW(186)
	LDI  R31,HIGH(186)
	CALL SUBOPT_0x35
; 0000 0D98             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0D99             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0D9A             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x53D
; 0000 0D9B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D9C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D9D 
; 0000 0D9E             a[1] = a[0]+0x001;  //ster2
; 0000 0D9F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DA0             a[6] = a[5]+0x001;  //okrag
; 0000 0DA1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DA2 
; 0000 0DA3     break;
; 0000 0DA4 
; 0000 0DA5 
; 0000 0DA6     case 100:
_0x111:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRNE _0x112
; 0000 0DA7 
; 0000 0DA8             a[0] = 0x060;   //ster1
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x35
; 0000 0DA9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0DAA             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 0DAB             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3C
; 0000 0DAC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DAD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0DAE 
; 0000 0DAF             a[1] = a[0]+0x001;  //ster2
; 0000 0DB0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DB1             a[6] = a[5]+0x001;  //okrag
; 0000 0DB2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DB3 
; 0000 0DB4     break;
; 0000 0DB5 
; 0000 0DB6 
; 0000 0DB7     case 101:
_0x112:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x113
; 0000 0DB8 
; 0000 0DB9             a[0] = 0x070;   //ster1
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	CALL SUBOPT_0x35
; 0000 0DBA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0DBB             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 0DBC             a[5] = 0x199;   //delta okrag
	RJMP _0x53D
; 0000 0DBD             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DBE             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DBF 
; 0000 0DC0             a[1] = a[0]+0x001;  //ster2
; 0000 0DC1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DC2             a[6] = a[5]+0x001;  //okrag
; 0000 0DC3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DC4 
; 0000 0DC5     break;
; 0000 0DC6 
; 0000 0DC7 
; 0000 0DC8     case 102:
_0x113:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BRNE _0x114
; 0000 0DC9 
; 0000 0DCA             a[0] = 0x08A;   //ster1
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	CALL SUBOPT_0x35
; 0000 0DCB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0DCC             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0DCD             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x60
; 0000 0DCE             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0DCF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DD0 
; 0000 0DD1             a[1] = a[0]+0x001;  //ster2
; 0000 0DD2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DD3             a[6] = a[5]+0x001;  //okrag
; 0000 0DD4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DD5 
; 0000 0DD6     break;
; 0000 0DD7 
; 0000 0DD8 
; 0000 0DD9     case 103:
_0x114:
	CPI  R30,LOW(0x67)
	LDI  R26,HIGH(0x67)
	CPC  R31,R26
	BRNE _0x115
; 0000 0DDA 
; 0000 0DDB             a[0] = 0x080;   //ster1
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CALL SUBOPT_0x35
; 0000 0DDC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0DDD             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0DDE             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x46
; 0000 0DDF             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DE0             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0DE1 
; 0000 0DE2             a[1] = a[0]+0x001;  //ster2
; 0000 0DE3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DE4             a[6] = a[5]+0x001;  //okrag
; 0000 0DE5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DE6 
; 0000 0DE7     break;
; 0000 0DE8 
; 0000 0DE9 
; 0000 0DEA     case 104:
_0x115:
	CPI  R30,LOW(0x68)
	LDI  R26,HIGH(0x68)
	CPC  R31,R26
	BRNE _0x116
; 0000 0DEB 
; 0000 0DEC             a[0] = 0x0B6;   //ster1
	LDI  R30,LOW(182)
	LDI  R31,HIGH(182)
	CALL SUBOPT_0x35
; 0000 0DED             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0DEE             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 0DEF             a[5] = 0x196;   //delta okrag
	RJMP _0x53D
; 0000 0DF0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DF1             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DF2 
; 0000 0DF3             a[1] = a[0]+0x001;  //ster2
; 0000 0DF4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DF5             a[6] = a[5]+0x001;  //okrag
; 0000 0DF6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DF7 
; 0000 0DF8     break;
; 0000 0DF9 
; 0000 0DFA 
; 0000 0DFB     case 105:
_0x116:
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x117
; 0000 0DFC 
; 0000 0DFD             a[0] = 0x044;   //ster1
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	CALL SUBOPT_0x35
; 0000 0DFE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0DFF             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x61
; 0000 0E00             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x47
; 0000 0E01             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0E02             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0E03 
; 0000 0E04             a[1] = a[0]+0x001;  //ster2
; 0000 0E05             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E06             a[6] = a[5]+0x001;  //okrag
; 0000 0E07             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E08 
; 0000 0E09     break;
; 0000 0E0A 
; 0000 0E0B 
; 0000 0E0C     case 106:
_0x117:
	CPI  R30,LOW(0x6A)
	LDI  R26,HIGH(0x6A)
	CPC  R31,R26
	BRNE _0x118
; 0000 0E0D 
; 0000 0E0E             a[0] = 0x03A;   //ster1
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	CALL SUBOPT_0x35
; 0000 0E0F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0E10             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0E11             a[5] = 0x190;   //delta okrag
; 0000 0E12             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0E13             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E14 
; 0000 0E15             a[1] = a[0]+0x001;  //ster2
; 0000 0E16             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E17             a[6] = a[5]+0x001;  //okrag
; 0000 0E18             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E19 
; 0000 0E1A     break;
; 0000 0E1B 
; 0000 0E1C 
; 0000 0E1D     case 107:
_0x118:
	CPI  R30,LOW(0x6B)
	LDI  R26,HIGH(0x6B)
	CPC  R31,R26
	BRNE _0x119
; 0000 0E1E 
; 0000 0E1F             a[0] = 0x;   //ster1
	CALL SUBOPT_0x51
; 0000 0E20             a[3] = 0x;    //ster4 INV druciak
; 0000 0E21             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0E22             a[5] = 0x;   //delta okrag
; 0000 0E23             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0E24             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0E25 
; 0000 0E26             a[1] = a[0]+0x001;  //ster2
; 0000 0E27             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E28             a[6] = a[5]+0x001;  //okrag
; 0000 0E29             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E2A 
; 0000 0E2B     break;
; 0000 0E2C 
; 0000 0E2D 
; 0000 0E2E     case 108:
_0x119:
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BRNE _0x11A
; 0000 0E2F 
; 0000 0E30             a[0] = 0x0C6;   //ster1
	LDI  R30,LOW(198)
	LDI  R31,HIGH(198)
	CALL SUBOPT_0x35
; 0000 0E31             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0E32             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0E33             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x58
; 0000 0E34             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0E35             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0E36 
; 0000 0E37             a[1] = a[0]+0x001;  //ster2
; 0000 0E38             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E39             a[6] = a[5]+0x001;  //okrag
; 0000 0E3A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E3B 
; 0000 0E3C     break;
; 0000 0E3D 
; 0000 0E3E 
; 0000 0E3F     case 109:
_0x11A:
	CPI  R30,LOW(0x6D)
	LDI  R26,HIGH(0x6D)
	CPC  R31,R26
	BRNE _0x11B
; 0000 0E40 
; 0000 0E41             a[0] = 0x00A;   //ster1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x35
; 0000 0E42             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0E43             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x39
; 0000 0E44             a[5] = 0x190;   //delta okrag
; 0000 0E45             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x53B
; 0000 0E46             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E47 
; 0000 0E48             a[1] = a[0]+0x001;  //ster2
; 0000 0E49             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E4A             a[6] = a[5]+0x001;  //okrag
; 0000 0E4B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E4C 
; 0000 0E4D     break;
; 0000 0E4E 
; 0000 0E4F 
; 0000 0E50     case 110:
_0x11B:
	CPI  R30,LOW(0x6E)
	LDI  R26,HIGH(0x6E)
	CPC  R31,R26
	BRNE _0x11C
; 0000 0E51 
; 0000 0E52             a[0] = 0x032;   //ster1
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x35
; 0000 0E53             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0E54             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0E55             a[5] = 0x190;   //delta okrag
; 0000 0E56             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0E57             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0E58 
; 0000 0E59             a[1] = a[0]+0x001;  //ster2
; 0000 0E5A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E5B             a[6] = a[5]+0x001;  //okrag
; 0000 0E5C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E5D 
; 0000 0E5E     break;
; 0000 0E5F 
; 0000 0E60 
; 0000 0E61     case 111:
_0x11C:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x11D
; 0000 0E62 
; 0000 0E63             a[0] = 0x;   //ster1
	CALL SUBOPT_0x51
; 0000 0E64             a[3] = 0x;    //ster4 INV druciak
; 0000 0E65             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0E66             a[5] = 0x;   //delta okrag
; 0000 0E67             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0E68             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0E69 
; 0000 0E6A             a[1] = a[0]+0x001;  //ster2
; 0000 0E6B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E6C             a[6] = a[5]+0x001;  //okrag
; 0000 0E6D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E6E 
; 0000 0E6F     break;
; 0000 0E70 
; 0000 0E71 
; 0000 0E72     case 112:
_0x11D:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x11E
; 0000 0E73 
; 0000 0E74             a[0] = 0x0E2;   //ster1
	LDI  R30,LOW(226)
	LDI  R31,HIGH(226)
	CALL SUBOPT_0x35
; 0000 0E75             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0E76             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0E77             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x58
; 0000 0E78             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0E79             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E7A 
; 0000 0E7B             a[1] = a[0]+0x001;  //ster2
; 0000 0E7C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E7D             a[6] = a[5]+0x001;  //okrag
; 0000 0E7E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E7F 
; 0000 0E80     break;
; 0000 0E81 
; 0000 0E82 
; 0000 0E83     case 113:
_0x11E:
	CPI  R30,LOW(0x71)
	LDI  R26,HIGH(0x71)
	CPC  R31,R26
	BRNE _0x11F
; 0000 0E84 
; 0000 0E85             a[0] = 0x0D4;   //ster1
	LDI  R30,LOW(212)
	LDI  R31,HIGH(212)
	CALL SUBOPT_0x35
; 0000 0E86             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0E87             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0E88             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x58
; 0000 0E89             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0E8A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0E8B 
; 0000 0E8C             a[1] = a[0]+0x001;  //ster2
; 0000 0E8D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E8E             a[6] = a[5]+0x001;  //okrag
; 0000 0E8F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E90 
; 0000 0E91     break;
; 0000 0E92 
; 0000 0E93 
; 0000 0E94     case 114:
_0x11F:
	CPI  R30,LOW(0x72)
	LDI  R26,HIGH(0x72)
	CPC  R31,R26
	BRNE _0x120
; 0000 0E95 
; 0000 0E96             a[0] = 0x04A;   //ster1
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	CALL SUBOPT_0x35
; 0000 0E97             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0E98             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0E99             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0E9A             a[7] = 0x0F;    //ster3 INV krazek scierny
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	CALL SUBOPT_0x3E
; 0000 0E9B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0E9C 
; 0000 0E9D             a[1] = a[0]+0x001;  //ster2
; 0000 0E9E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E9F             a[6] = a[5]+0x001;  //okrag
; 0000 0EA0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EA1 
; 0000 0EA2     break;
; 0000 0EA3 
; 0000 0EA4 
; 0000 0EA5     case 115:
_0x120:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x121
; 0000 0EA6 
; 0000 0EA7             a[0] = 0x076;   //ster1
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	CALL SUBOPT_0x35
; 0000 0EA8             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x64
; 0000 0EA9             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0EAA             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x3F
; 0000 0EAB             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0EAC             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0EAD 
; 0000 0EAE             a[1] = a[0]+0x001;  //ster2
; 0000 0EAF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EB0             a[6] = a[5]+0x001;  //okrag
; 0000 0EB1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EB2 
; 0000 0EB3     break;
; 0000 0EB4 
; 0000 0EB5 
; 0000 0EB6     case 116:
_0x121:
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BRNE _0x122
; 0000 0EB7 
; 0000 0EB8             a[0] = 0x092;   //ster1
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	CALL SUBOPT_0x35
; 0000 0EB9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0EBA             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0EBB             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x53D
; 0000 0EBC             a[7] = 0x12;    //ster3 INV krazek scierny
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
; 0000 0EC8     case 117:
_0x122:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x123
; 0000 0EC9 
; 0000 0ECA             a[0] = 0x11A;   //ster1
	LDI  R30,LOW(282)
	LDI  R31,HIGH(282)
	CALL SUBOPT_0x35
; 0000 0ECB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0ECC             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0ECD             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x58
; 0000 0ECE             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
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
; 0000 0ED9 
; 0000 0EDA     case 118:
_0x123:
	CPI  R30,LOW(0x76)
	LDI  R26,HIGH(0x76)
	CPC  R31,R26
	BRNE _0x124
; 0000 0EDB 
; 0000 0EDC             a[0] = 0x056;   //ster1
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	CALL SUBOPT_0x35
; 0000 0EDD             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0EDE             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0EDF             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x58
; 0000 0EE0             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0EE1             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EE2 
; 0000 0EE3             a[1] = a[0]+0x001;  //ster2
; 0000 0EE4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EE5             a[6] = a[5]+0x001;  //okrag
; 0000 0EE6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EE7 
; 0000 0EE8     break;
; 0000 0EE9 
; 0000 0EEA 
; 0000 0EEB     case 119:
_0x124:
	CPI  R30,LOW(0x77)
	LDI  R26,HIGH(0x77)
	CPC  R31,R26
	BRNE _0x125
; 0000 0EEC 
; 0000 0EED             a[0] = 0x072;   //ster1
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	CALL SUBOPT_0x35
; 0000 0EEE             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x64
; 0000 0EEF             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0EF0             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x3F
; 0000 0EF1             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0EF2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EF3 
; 0000 0EF4             a[1] = a[0]+0x001;  //ster2
; 0000 0EF5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EF6             a[6] = a[5]+0x001;  //okrag
; 0000 0EF7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EF8 
; 0000 0EF9     break;
; 0000 0EFA 
; 0000 0EFB 
; 0000 0EFC     case 120:
_0x125:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x126
; 0000 0EFD 
; 0000 0EFE             a[0] = 0x0D0;   //ster1
	LDI  R30,LOW(208)
	LDI  R31,HIGH(208)
	CALL SUBOPT_0x35
; 0000 0EFF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0F00             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0F01             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x50
; 0000 0F02             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F03             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0F04 
; 0000 0F05             a[1] = a[0]+0x001;  //ster2
; 0000 0F06             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F07             a[6] = a[5]+0x001;  //okrag
; 0000 0F08             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F09 
; 0000 0F0A     break;
; 0000 0F0B 
; 0000 0F0C 
; 0000 0F0D     case 121:
_0x126:
	CPI  R30,LOW(0x79)
	LDI  R26,HIGH(0x79)
	CPC  R31,R26
	BRNE _0x127
; 0000 0F0E 
; 0000 0F0F             a[0] = 0x048;   //ster1
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	CALL SUBOPT_0x35
; 0000 0F10             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0F11             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0F12             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x58
; 0000 0F13             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0F14             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0F15 
; 0000 0F16             a[1] = a[0]+0x001;  //ster2
; 0000 0F17             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F18             a[6] = a[5]+0x001;  //okrag
; 0000 0F19             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F1A 
; 0000 0F1B     break;
; 0000 0F1C 
; 0000 0F1D 
; 0000 0F1E     case 122:
_0x127:
	CPI  R30,LOW(0x7A)
	LDI  R26,HIGH(0x7A)
	CPC  R31,R26
	BRNE _0x128
; 0000 0F1F 
; 0000 0F20             a[0] = 0x09A;   //ster1
	LDI  R30,LOW(154)
	LDI  R31,HIGH(154)
	CALL SUBOPT_0x35
; 0000 0F21             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0F22             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0F23             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x50
; 0000 0F24             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F25             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0F26 
; 0000 0F27             a[1] = a[0]+0x001;  //ster2
; 0000 0F28             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F29             a[6] = a[5]+0x001;  //okrag
; 0000 0F2A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F2B 
; 0000 0F2C     break;
; 0000 0F2D 
; 0000 0F2E 
; 0000 0F2F     case 123:
_0x128:
	CPI  R30,LOW(0x7B)
	LDI  R26,HIGH(0x7B)
	CPC  R31,R26
	BRNE _0x129
; 0000 0F30 
; 0000 0F31             a[0] = 0x046;   //ster1
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL SUBOPT_0x35
; 0000 0F32             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0F33             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x65
; 0000 0F34             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0F35             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0F36             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0F37 
; 0000 0F38             a[1] = a[0]+0x001;  //ster2
; 0000 0F39             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F3A             a[6] = a[5]+0x001;  //okrag
; 0000 0F3B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F3C 
; 0000 0F3D     break;
; 0000 0F3E 
; 0000 0F3F 
; 0000 0F40 
; 0000 0F41     case 124:
_0x129:
	CPI  R30,LOW(0x7C)
	LDI  R26,HIGH(0x7C)
	CPC  R31,R26
	BRNE _0x12A
; 0000 0F42 
; 0000 0F43             a[0] = 0x0E0;   //ster1
	LDI  R30,LOW(224)
	LDI  R31,HIGH(224)
	CALL SUBOPT_0x35
; 0000 0F44             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x67
; 0000 0F45             a[4] = 0x15;    //ster3 ABS krazek scierny
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL SUBOPT_0x5C
; 0000 0F46             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0F47             a[7] = 0x13;    //ster3 INV krazek scierny
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	CALL SUBOPT_0x3E
; 0000 0F48             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0F49 
; 0000 0F4A             a[1] = a[0]+0x001;  //ster2
; 0000 0F4B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F4C             a[6] = a[5]+0x001;  //okrag
; 0000 0F4D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F4E 
; 0000 0F4F     break;
; 0000 0F50 
; 0000 0F51 
; 0000 0F52     case 125:
_0x12A:
	CPI  R30,LOW(0x7D)
	LDI  R26,HIGH(0x7D)
	CPC  R31,R26
	BRNE _0x12B
; 0000 0F53 
; 0000 0F54             a[0] = 0x038;   //ster1
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	CALL SUBOPT_0x35
; 0000 0F55             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0F56             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0F57             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x58
; 0000 0F58             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0F59             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F5A 
; 0000 0F5B             a[1] = a[0]+0x001;  //ster2
; 0000 0F5C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F5D             a[6] = a[5]+0x001;  //okrag
; 0000 0F5E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F5F 
; 0000 0F60     break;
; 0000 0F61 
; 0000 0F62 
; 0000 0F63     case 126:
_0x12B:
	CPI  R30,LOW(0x7E)
	LDI  R26,HIGH(0x7E)
	CPC  R31,R26
	BRNE _0x12C
; 0000 0F64 
; 0000 0F65             a[0] = 0x0CA;   //ster1
	LDI  R30,LOW(202)
	LDI  R31,HIGH(202)
	CALL SUBOPT_0x35
; 0000 0F66             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0F67             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0F68             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x53D
; 0000 0F69             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F6A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F6B 
; 0000 0F6C             a[1] = a[0]+0x001;  //ster2
; 0000 0F6D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F6E             a[6] = a[5]+0x001;  //okrag
; 0000 0F6F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F70 
; 0000 0F71     break;
; 0000 0F72 
; 0000 0F73 
; 0000 0F74     case 127:
_0x12C:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0x12D
; 0000 0F75 
; 0000 0F76             a[0] = 0x0DE;   //ster1
	LDI  R30,LOW(222)
	LDI  R31,HIGH(222)
	CALL SUBOPT_0x35
; 0000 0F77             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0F78             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x65
; 0000 0F79             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0F7A             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0F7B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F7C 
; 0000 0F7D             a[1] = a[0]+0x001;  //ster2
; 0000 0F7E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F7F             a[6] = a[5]+0x001;  //okrag
; 0000 0F80             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F81 
; 0000 0F82     break;
; 0000 0F83 
; 0000 0F84 
; 0000 0F85     case 128:
_0x12D:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x12E
; 0000 0F86 
; 0000 0F87             a[0] = 0x116;   //ster1
	LDI  R30,LOW(278)
	LDI  R31,HIGH(278)
	CALL SUBOPT_0x35
; 0000 0F88             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 0F89             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x3B
; 0000 0F8A             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x68
; 0000 0F8B             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0F8C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F8D 
; 0000 0F8E             a[1] = a[0]+0x001;  //ster2
; 0000 0F8F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F90             a[6] = a[5]+0x001;  //okrag
; 0000 0F91             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F92 
; 0000 0F93     break;
; 0000 0F94 
; 0000 0F95 
; 0000 0F96     case 129:
_0x12E:
	CPI  R30,LOW(0x81)
	LDI  R26,HIGH(0x81)
	CPC  R31,R26
	BRNE _0x12F
; 0000 0F97 
; 0000 0F98             a[0] = 0x0E8;   //ster1
	LDI  R30,LOW(232)
	LDI  R31,HIGH(232)
	CALL SUBOPT_0x35
; 0000 0F99             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x67
; 0000 0F9A             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x69
; 0000 0F9B             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x68
; 0000 0F9C             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 0F9D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0F9E 
; 0000 0F9F             a[1] = a[0]+0x001;  //ster2
; 0000 0FA0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FA1             a[6] = a[5]+0x001;  //okrag
; 0000 0FA2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FA3 
; 0000 0FA4     break;
; 0000 0FA5 
; 0000 0FA6 
; 0000 0FA7     case 130:
_0x12F:
	CPI  R30,LOW(0x82)
	LDI  R26,HIGH(0x82)
	CPC  R31,R26
	BRNE _0x130
; 0000 0FA8 
; 0000 0FA9             a[0] = 0x0F2;   //ster1
	LDI  R30,LOW(242)
	LDI  R31,HIGH(242)
	CALL SUBOPT_0x35
; 0000 0FAA             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x6A
; 0000 0FAB             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0FAC             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0FAD             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x38
; 0000 0FAE             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3A
	RJMP _0x53C
; 0000 0FAF 
; 0000 0FB0             a[1] = a[0]+0x001;  //ster2
; 0000 0FB1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FB2             a[6] = a[5]+0x001;  //okrag
; 0000 0FB3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FB4 
; 0000 0FB5     break;
; 0000 0FB6 
; 0000 0FB7 
; 0000 0FB8     case 131:
_0x130:
	CPI  R30,LOW(0x83)
	LDI  R26,HIGH(0x83)
	CPC  R31,R26
	BRNE _0x131
; 0000 0FB9 
; 0000 0FBA             a[0] = 0x108;   //ster1
	LDI  R30,LOW(264)
	LDI  R31,HIGH(264)
	CALL SUBOPT_0x35
; 0000 0FBB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0FBC             a[4] = 0x1F;    //ster3 ABS krazek scierny
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP _0x53E
; 0000 0FBD             a[5] = 0x19C;   //delta okrag
; 0000 0FBE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FBF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FC0 
; 0000 0FC1             a[1] = a[0]+0x001;  //ster2
; 0000 0FC2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FC3             a[6] = a[5]+0x001;  //okrag
; 0000 0FC4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FC5 
; 0000 0FC6     break;
; 0000 0FC7 
; 0000 0FC8 
; 0000 0FC9 
; 0000 0FCA     case 132:
_0x131:
	CPI  R30,LOW(0x84)
	LDI  R26,HIGH(0x84)
	CPC  R31,R26
	BRNE _0x132
; 0000 0FCB 
; 0000 0FCC             a[0] = 0x064;   //ster1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x35
; 0000 0FCD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 0FCE             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0FCF             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0FD0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FD1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 0FD2 
; 0000 0FD3             a[1] = a[0]+0x001;  //ster2
; 0000 0FD4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FD5             a[6] = a[5]+0x001;  //okrag
; 0000 0FD6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FD7 
; 0000 0FD8     break;
; 0000 0FD9 
; 0000 0FDA 
; 0000 0FDB     case 133:
_0x132:
	CPI  R30,LOW(0x85)
	LDI  R26,HIGH(0x85)
	CPC  R31,R26
	BRNE _0x133
; 0000 0FDC 
; 0000 0FDD             a[0] = 0x088;   //ster1
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	CALL SUBOPT_0x35
; 0000 0FDE             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x67
; 0000 0FDF             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x69
; 0000 0FE0             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x68
; 0000 0FE1             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 0FE2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FE3 
; 0000 0FE4             a[1] = a[0]+0x001;  //ster2
; 0000 0FE5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FE6             a[6] = a[5]+0x001;  //okrag
; 0000 0FE7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FE8 
; 0000 0FE9     break;
; 0000 0FEA 
; 0000 0FEB 
; 0000 0FEC 
; 0000 0FED     case 134:
_0x133:
	CPI  R30,LOW(0x86)
	LDI  R26,HIGH(0x86)
	CPC  R31,R26
	BRNE _0x134
; 0000 0FEE 
; 0000 0FEF             a[0] = 0x10E;   //ster1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x35
; 0000 0FF0             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x6A
; 0000 0FF1             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0FF2             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0FF3             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x53B
; 0000 0FF4             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FF5 
; 0000 0FF6             a[1] = a[0]+0x001;  //ster2
; 0000 0FF7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FF8             a[6] = a[5]+0x001;  //okrag
; 0000 0FF9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FFA 
; 0000 0FFB     break;
; 0000 0FFC 
; 0000 0FFD                ////////////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 0FFE      case 135:
_0x134:
	CPI  R30,LOW(0x87)
	LDI  R26,HIGH(0x87)
	CPC  R31,R26
	BRNE _0x135
; 0000 0FFF 
; 0000 1000             a[0] = 0x054;   //ster1
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CALL SUBOPT_0x35
; 0000 1001             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 1002             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x61
; 0000 1003             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 1004             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 1005             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 1006 
; 0000 1007             a[1] = a[0]+0x001;  //ster2
; 0000 1008             a[2] = a[4];        //ster4 ABS druciak
; 0000 1009             a[6] = a[5]+0x001;  //okrag
; 0000 100A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 100B 
; 0000 100C     break;
; 0000 100D 
; 0000 100E 
; 0000 100F      case 136:
_0x135:
	CPI  R30,LOW(0x88)
	LDI  R26,HIGH(0x88)
	CPC  R31,R26
	BRNE _0x136
; 0000 1010 
; 0000 1011             a[0] = 0x03E;   //ster1
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	CALL SUBOPT_0x35
; 0000 1012             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 1013             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x69
; 0000 1014             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x6B
; 0000 1015             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x53B
; 0000 1016             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1017 
; 0000 1018             a[1] = a[0]+0x001;  //ster2
; 0000 1019             a[2] = a[4];        //ster4 ABS druciak
; 0000 101A             a[6] = a[5]+0x001;  //okrag
; 0000 101B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 101C 
; 0000 101D     break;
; 0000 101E 
; 0000 101F      case 137:
_0x136:
	CPI  R30,LOW(0x89)
	LDI  R26,HIGH(0x89)
	CPC  R31,R26
	BRNE _0x137
; 0000 1020 
; 0000 1021             a[0] = 0x00C;   //ster1
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x35
; 0000 1022             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 1023             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 1024             a[5] = 0x190;   //delta okrag
; 0000 1025             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 1026             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 1027 
; 0000 1028             a[1] = a[0]+0x001;  //ster2
; 0000 1029             a[2] = a[4];        //ster4 ABS druciak
; 0000 102A             a[6] = a[5]+0x001;  //okrag
; 0000 102B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 102C 
; 0000 102D     break;
; 0000 102E 
; 0000 102F 
; 0000 1030      case 138:
_0x137:
	CPI  R30,LOW(0x8A)
	LDI  R26,HIGH(0x8A)
	CPC  R31,R26
	BRNE _0x138
; 0000 1031 
; 0000 1032             a[0] = 0x0DC;   //ster1
	LDI  R30,LOW(220)
	LDI  R31,HIGH(220)
	CALL SUBOPT_0x35
; 0000 1033             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 1034             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x37
; 0000 1035             a[5] = 0x196;   //delta okrag
; 0000 1036             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 1037             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1038 
; 0000 1039             a[1] = a[0]+0x001;  //ster2
; 0000 103A             a[2] = a[4];        //ster4 ABS druciak
; 0000 103B             a[6] = a[5]+0x001;  //okrag
; 0000 103C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 103D 
; 0000 103E     break;
; 0000 103F 
; 0000 1040 
; 0000 1041      case 139:
_0x138:
	CPI  R30,LOW(0x8B)
	LDI  R26,HIGH(0x8B)
	CPC  R31,R26
	BRNE _0x139
; 0000 1042 
; 0000 1043             a[0] = 0x058;   //ster1
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	CALL SUBOPT_0x35
; 0000 1044             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 1045             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 1046             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x53D
; 0000 1047             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 1048             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1049 
; 0000 104A             a[1] = a[0]+0x001;  //ster2
; 0000 104B             a[2] = a[4];        //ster4 ABS druciak
; 0000 104C             a[6] = a[5]+0x001;  //okrag
; 0000 104D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 104E 
; 0000 104F     break;
; 0000 1050 
; 0000 1051 
; 0000 1052      case 140:
_0x139:
	CPI  R30,LOW(0x8C)
	LDI  R26,HIGH(0x8C)
	CPC  R31,R26
	BRNE _0x13A
; 0000 1053 
; 0000 1054             a[0] = 0x03C;   //ster1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0x35
; 0000 1055             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 1056             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x65
; 0000 1057             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x6B
; 0000 1058             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x38
; 0000 1059             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x3A
	RJMP _0x53C
; 0000 105A 
; 0000 105B             a[1] = a[0]+0x001;  //ster2
; 0000 105C             a[2] = a[4];        //ster4 ABS druciak
; 0000 105D             a[6] = a[5]+0x001;  //okrag
; 0000 105E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 105F 
; 0000 1060 
; 0000 1061 
; 0000 1062     break;
; 0000 1063 
; 0000 1064 
; 0000 1065      case 141:
_0x13A:
	CPI  R30,LOW(0x8D)
	LDI  R26,HIGH(0x8D)
	CPC  R31,R26
	BRNE _0x13B
; 0000 1066 
; 0000 1067             a[0] = 0x00E;   //ster1
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x35
; 0000 1068             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 1069             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 106A             a[5] = 0x190;   //delta okrag
; 0000 106B             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x53B
; 0000 106C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 106D 
; 0000 106E             a[1] = a[0]+0x001;  //ster2
; 0000 106F             a[2] = a[4];        //ster4 ABS druciak
; 0000 1070             a[6] = a[5]+0x001;  //okrag
; 0000 1071             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1072 
; 0000 1073     break;
; 0000 1074 
; 0000 1075 
; 0000 1076      case 142:
_0x13B:
	CPI  R30,LOW(0x8E)
	LDI  R26,HIGH(0x8E)
	CPC  R31,R26
	BRNE _0x13C
; 0000 1077 
; 0000 1078             a[0] = 0x10A;   //ster1
	LDI  R30,LOW(266)
	LDI  R31,HIGH(266)
	CALL SUBOPT_0x35
; 0000 1079             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x38
; 0000 107A             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x37
; 0000 107B             a[5] = 0x196;   //delta okrag
; 0000 107C             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3E
; 0000 107D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 107E 
; 0000 107F             a[1] = a[0]+0x001;  //ster2
; 0000 1080             a[2] = a[4];        //ster4 ABS druciak
; 0000 1081             a[6] = a[5]+0x001;  //okrag
; 0000 1082             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1083 
; 0000 1084     break;
; 0000 1085 
; 0000 1086 
; 0000 1087 
; 0000 1088      case 143:
_0x13C:
	CPI  R30,LOW(0x8F)
	LDI  R26,HIGH(0x8F)
	CPC  R31,R26
	BRNE _0x13D
; 0000 1089 
; 0000 108A             a[0] = 0x022;   //ster1
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL SUBOPT_0x35
; 0000 108B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 108C             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 108D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x50
; 0000 108E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 108F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x53C
; 0000 1090 
; 0000 1091             a[1] = a[0]+0x001;  //ster2
; 0000 1092             a[2] = a[4];        //ster4 ABS druciak
; 0000 1093             a[6] = a[5]+0x001;  //okrag
; 0000 1094             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1095 
; 0000 1096     break;
; 0000 1097 
; 0000 1098 
; 0000 1099      case 144:
_0x13D:
	CPI  R30,LOW(0x90)
	LDI  R26,HIGH(0x90)
	CPC  R31,R26
	BRNE _0xAD
; 0000 109A 
; 0000 109B             a[0] = 0x066;   //ster1
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	CALL SUBOPT_0x35
; 0000 109C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x36
; 0000 109D             a[4] = 0x1C;    //ster3 ABS krazek scierny
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
_0x53E:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 109E             a[5] = 0x19C;   //delta okrag
	__POINTW1MN _a,10
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
_0x53D:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 109F             a[7] = 0x12;    //ster3 INV krazek scierny
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
_0x53B:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 10A0             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	__POINTW1MN _a,18
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
_0x53C:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 10A1 
; 0000 10A2             a[1] = a[0]+0x001;  //ster2
	CALL SUBOPT_0x6C
	ADIW R30,1
	__PUTW1MN _a,2
; 0000 10A3             a[2] = a[4];        //ster4 ABS druciak
	CALL SUBOPT_0x6D
	__PUTW1MN _a,4
; 0000 10A4             a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x6F
; 0000 10A5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 10A6 
; 0000 10A7     break;
; 0000 10A8 
; 0000 10A9 
; 0000 10AA }
_0xAD:
; 0000 10AB 
; 0000 10AC //if(predkosc_pion_szczotka == 50)   //zwolnienie predkosci pion
; 0000 10AD //       {
; 0000 10AE //       a[3] = a[3] - 0x05;
; 0000 10AF //       }
; 0000 10B0 
; 0000 10B1 if(tryb_pracy_szczotki_drucianej == 1)
	CALL SUBOPT_0x70
	BRNE _0x13F
; 0000 10B2          a[3] = a[3];
	CALL SUBOPT_0x71
	CALL SUBOPT_0x72
; 0000 10B3 
; 0000 10B4 if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)
_0x13F:
	CALL SUBOPT_0x73
	BREQ _0x140
; 0000 10B5          a[3] = a[3]-0x05;
	CALL SUBOPT_0x71
	SBIW R30,5
	CALL SUBOPT_0x72
; 0000 10B6 
; 0000 10B7 //if(predkosc_pion_krazek == 50)   //zwolnienie predkosci pion krazek
; 0000 10B8 //       {
; 0000 10B9 //       a[7] = a[7] - 0x05;
; 0000 10BA //       }
; 0000 10BB 
; 0000 10BC a[3] = a[3]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT
_0x140:
	CALL SUBOPT_0x71
	SBIW R30,6
	CALL SUBOPT_0x72
; 0000 10BD a[2] = a[2]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT
	CALL SUBOPT_0x74
	SBIW R30,6
	__PUTW1MN _a,4
; 0000 10BE 
; 0000 10BF 
; 0000 10C0 
; 0000 10C1 if(krazek_scierny_cykl_po_okregu_ilosc == 0 | ruch_haos == 1)
	MOVW R26,R8
	CALL SUBOPT_0x75
	CALL SUBOPT_0x76
	CALL SUBOPT_0x77
	OR   R30,R0
	BREQ _0x141
; 0000 10C2         a[7] = a[7] - 0x05;
	CALL SUBOPT_0x78
	SBIW R30,5
	__PUTW1MN _a,14
; 0000 10C3 
; 0000 10C4 if(srednica_krazka_sciernego == 40)
_0x141:
	CALL SUBOPT_0x79
	SBIW R26,40
	BRNE _0x142
; 0000 10C5         a[4] = a[4]+ 0x13;
	CALL SUBOPT_0x6D
	ADIW R30,19
	__PUTW1MN _a,8
; 0000 10C6 
; 0000 10C7                                                      //2
; 0000 10C8 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 30)
_0x142:
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x77
	CALL SUBOPT_0x7B
; 0000 10C9     {
; 0000 10CA     }
; 0000 10CB 
; 0000 10CC                                                    //2
; 0000 10CD if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 30)
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x7B
	BREQ _0x144
; 0000 10CE     {
; 0000 10CF     a[5] = a[5] + 0x10;   //plus 16 dzesietnie
	CALL SUBOPT_0x6E
	ADIW R30,16
	CALL SUBOPT_0x7D
; 0000 10D0     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6F
; 0000 10D1     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10D2     }
; 0000 10D3                                                     //1
; 0000 10D4 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 30)
_0x144:
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x7B
	BREQ _0x145
; 0000 10D5     {
; 0000 10D6     a[5] = a[5] + 0x20;   //plus 32 dzesietnie
	CALL SUBOPT_0x6E
	ADIW R30,32
	CALL SUBOPT_0x7D
; 0000 10D7     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6F
; 0000 10D8     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10D9     }
; 0000 10DA 
; 0000 10DB                                                     //2
; 0000 10DC if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 30)
_0x145:
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x7B
	BREQ _0x146
; 0000 10DD     {
; 0000 10DE     a[5] = a[5] + 0x30;   //plus 48 dzesietnie
	CALL SUBOPT_0x6E
	ADIW R30,48
	CALL SUBOPT_0x7D
; 0000 10DF     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6F
; 0000 10E0     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10E1     }
; 0000 10E2 
; 0000 10E3 /////////////////////////////////////////////////////////////////////////////////////
; 0000 10E4 
; 0000 10E5 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 40)
_0x146:
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x77
	CALL SUBOPT_0x80
	BREQ _0x147
; 0000 10E6     {
; 0000 10E7     a[5] = a[5] + 0x39;   //plus 66 dzesietnie   ///////////////
	CALL SUBOPT_0x6E
	ADIW R30,57
	CALL SUBOPT_0x7D
; 0000 10E8     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6F
; 0000 10E9     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10EA     }
; 0000 10EB 
; 0000 10EC                                                    //2
; 0000 10ED if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 40)
_0x147:
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x80
	BREQ _0x148
; 0000 10EE     {
; 0000 10EF     a[5] = a[5] + 0x42;   //plus 16 dzesietnie
	CALL SUBOPT_0x6E
	SUBI R30,LOW(-66)
	SBCI R31,HIGH(-66)
	CALL SUBOPT_0x7D
; 0000 10F0     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6F
; 0000 10F1     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10F2     }
; 0000 10F3                                                     //1
; 0000 10F4 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 40)
_0x148:
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x80
	BREQ _0x149
; 0000 10F5     {
; 0000 10F6     a[5] = a[5] + 0x4B;   //plus 32 dzesietnie
	CALL SUBOPT_0x6E
	SUBI R30,LOW(-75)
	SBCI R31,HIGH(-75)
	CALL SUBOPT_0x7D
; 0000 10F7     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6F
; 0000 10F8     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10F9     }
; 0000 10FA 
; 0000 10FB                                                     //2
; 0000 10FC if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 40)
_0x149:
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x80
	BREQ _0x14A
; 0000 10FD     {
; 0000 10FE     a[5] = a[5] + 0x54;   //plus 48 dzesietnie
	CALL SUBOPT_0x6E
	SUBI R30,LOW(-84)
	SBCI R31,HIGH(-84)
	CALL SUBOPT_0x7D
; 0000 10FF     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x6F
; 0000 1100     a[8] = a[6]+0x001;  //-delta okrag
; 0000 1101     }
; 0000 1102 
; 0000 1103 }
_0x14A:
	RJMP _0x20A0003
;
;void obsluga_nacisniecia_zatrzymaj()
; 0000 1106 {
_obsluga_nacisniecia_zatrzymaj:
; 0000 1107 int sg;
; 0000 1108 sg = 0;
	CALL SUBOPT_0x1
;	sg -> R16,R17
; 0000 1109 
; 0000 110A   if(sek20 > 60)
	LDS  R26,_sek20
	LDS  R27,_sek20+1
	LDS  R24,_sek20+2
	LDS  R25,_sek20+3
	CALL SUBOPT_0x81
	BRGE PC+3
	JMP _0x14B
; 0000 110B    {
; 0000 110C    sek20 = 0;
	LDI  R30,LOW(0)
	STS  _sek20,R30
	STS  _sek20+1,R30
	STS  _sek20+2,R30
	STS  _sek20+3,R30
; 0000 110D    while(sprawdz_pin2(PORTMM,0x77) == 0)
_0x14C:
	CALL SUBOPT_0x82
	CPI  R30,0
	BRNE _0x14E
; 0000 110E         {
; 0000 110F         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x14
	CALL SUBOPT_0x14
	CALL SUBOPT_0x83
; 0000 1110         PORTD.7 = 1;
; 0000 1111         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x151
; 0000 1112            {
; 0000 1113            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x84
; 0000 1114            PORTE.2 = 0;
; 0000 1115            }
; 0000 1116 
; 0000 1117         if(PORTE.3 == 1)
_0x151:
	SBIS 0x3,3
	RJMP _0x154
; 0000 1118            {
; 0000 1119            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x85
; 0000 111A            PORTE.3 = 0;
; 0000 111B            }
; 0000 111C 
; 0000 111D          if(PORT_F.bits.b4 == 1)
_0x154:
	CALL SUBOPT_0x86
	BRNE _0x157
; 0000 111E             {
; 0000 111F             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x87
; 0000 1120             zastopowany_czas_przedmuchu = sek12;
; 0000 1121             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1122             PORTF = PORT_F.byte;
; 0000 1123             }
; 0000 1124 
; 0000 1125 
; 0000 1126         komunikat_na_panel("                                                ",adr1,adr2);
_0x157:
	CALL SUBOPT_0x33
; 0000 1127         komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr1,adr2);
	__POINTW1FN _0x0,1351
	CALL SUBOPT_0x34
; 0000 1128         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x88
; 0000 1129         komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr3,adr4);
	__POINTW1FN _0x0,1351
	CALL SUBOPT_0x89
; 0000 112A 
; 0000 112B         }
	RJMP _0x14C
_0x14E:
; 0000 112C 
; 0000 112D     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x158
; 0000 112E         {
; 0000 112F         while(sg == 0)
_0x159:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x15B
; 0000 1130             {
; 0000 1131             if(sprawdz_pin2(PORTMM,0x77) == 1)
	CALL SUBOPT_0x82
	CPI  R30,LOW(0x1)
	BRNE _0x15C
; 0000 1132                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x12
	MOVW R16,R30
; 0000 1133 
; 0000 1134 
; 0000 1135             }
_0x15C:
	RJMP _0x159
_0x15B:
; 0000 1136 
; 0000 1137         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x33
; 0000 1138         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x88
; 0000 1139 
; 0000 113A         PORTD.7 = 0;
	CALL SUBOPT_0x8A
; 0000 113B         if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x15F
; 0000 113C             {
; 0000 113D             PORTE.2 = 1;
	CALL SUBOPT_0x8B
; 0000 113E             byla_wloczona_szlifierka_1 = 0;
; 0000 113F             }
; 0000 1140         if(byla_wloczona_szlifierka_2 == 1)
_0x15F:
	CALL SUBOPT_0x8C
	BRNE _0x162
; 0000 1141             {
; 0000 1142             PORTE.3 = 1;
	CALL SUBOPT_0x8D
; 0000 1143             byla_wloczona_szlifierka_2 = 0;
; 0000 1144             }
; 0000 1145         if(byl_wloczony_przedmuch == 1)
_0x162:
	CALL SUBOPT_0x8E
	BRNE _0x165
; 0000 1146             {
; 0000 1147             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x8F
; 0000 1148             PORTF = PORT_F.byte;
; 0000 1149             sek12 = zastopowany_czas_przedmuchu;
; 0000 114A             byl_wloczony_przedmuch = 0;
; 0000 114B             }
; 0000 114C         }
_0x165:
; 0000 114D     }
_0x158:
; 0000 114E 
; 0000 114F }
_0x14B:
	RJMP _0x20A0005
;
;
;void obsluga_otwarcia_klapy_rzad()
; 0000 1153 {
_obsluga_otwarcia_klapy_rzad:
; 0000 1154 int sg;
; 0000 1155 sg = 0;
	CALL SUBOPT_0x1
;	sg -> R16,R17
; 0000 1156 
; 0000 1157 if(rzad_obrabiany == 1 & start == 1)
	CALL SUBOPT_0x90
	CALL SUBOPT_0x77
	CALL SUBOPT_0x91
	AND  R30,R0
	BRNE PC+3
	JMP _0x166
; 0000 1158    {
; 0000 1159    while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x167:
	CALL SUBOPT_0x92
	CPI  R30,LOW(0x1)
	BRNE _0x169
; 0000 115A         {
; 0000 115B         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x14
	CALL SUBOPT_0x14
	CALL SUBOPT_0x83
; 0000 115C         PORTD.7 = 1;
; 0000 115D         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x16C
; 0000 115E            {
; 0000 115F            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x84
; 0000 1160            PORTE.2 = 0;
; 0000 1161            }
; 0000 1162 
; 0000 1163         if(PORTE.3 == 1)
_0x16C:
	SBIS 0x3,3
	RJMP _0x16F
; 0000 1164            {
; 0000 1165            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x85
; 0000 1166            PORTE.3 = 0;
; 0000 1167            }
; 0000 1168 
; 0000 1169            if(PORT_F.bits.b4 == 1)
_0x16F:
	CALL SUBOPT_0x86
	BRNE _0x172
; 0000 116A             {
; 0000 116B             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x87
; 0000 116C             zastopowany_czas_przedmuchu = sek12;
; 0000 116D             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 116E             PORTF = PORT_F.byte;
; 0000 116F             }
; 0000 1170 
; 0000 1171 
; 0000 1172         komunikat_na_panel("                                                ",adr1,adr2);
_0x172:
	CALL SUBOPT_0x33
; 0000 1173         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x34
; 0000 1174         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x88
; 0000 1175         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x89
; 0000 1176 
; 0000 1177         }
	RJMP _0x167
_0x169:
; 0000 1178     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x173
; 0000 1179         {
; 0000 117A         while(sg == 0)
_0x174:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x176
; 0000 117B             {
; 0000 117C             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x92
	LDI  R26,LOW(0)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0x93
	LDI  R26,LOW(0)
	CALL __EQB12
	POP  R26
	AND  R30,R26
	BREQ _0x177
; 0000 117D                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x12
	MOVW R16,R30
; 0000 117E 
; 0000 117F 
; 0000 1180             }
_0x177:
	RJMP _0x174
_0x176:
; 0000 1181 
; 0000 1182         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x33
; 0000 1183         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x88
; 0000 1184 
; 0000 1185         PORTD.7 = 0;
	CALL SUBOPT_0x8A
; 0000 1186           if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x17A
; 0000 1187             {
; 0000 1188             PORTE.2 = 1;
	CALL SUBOPT_0x8B
; 0000 1189             byla_wloczona_szlifierka_1 = 0;
; 0000 118A             }
; 0000 118B         if(byla_wloczona_szlifierka_2 == 1)
_0x17A:
	CALL SUBOPT_0x8C
	BRNE _0x17D
; 0000 118C             {
; 0000 118D             PORTE.3 = 1;
	CALL SUBOPT_0x8D
; 0000 118E             byla_wloczona_szlifierka_2 = 0;
; 0000 118F             }
; 0000 1190         if(byl_wloczony_przedmuch == 1)
_0x17D:
	CALL SUBOPT_0x8E
	BRNE _0x180
; 0000 1191             {
; 0000 1192             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x8F
; 0000 1193             PORTF = PORT_F.byte;
; 0000 1194             sek12 = zastopowany_czas_przedmuchu;
; 0000 1195             byl_wloczony_przedmuch = 0;
; 0000 1196             }
; 0000 1197         }
_0x180:
; 0000 1198    }
_0x173:
; 0000 1199 
; 0000 119A 
; 0000 119B if(rzad_obrabiany == 2 & start == 1)
_0x166:
	CALL SUBOPT_0x94
	CALL SUBOPT_0x91
	AND  R30,R0
	BRNE PC+3
	JMP _0x181
; 0000 119C    {
; 0000 119D    while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x182:
	CALL SUBOPT_0x93
	CPI  R30,LOW(0x1)
	BRNE _0x184
; 0000 119E         {
; 0000 119F         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x14
	CALL SUBOPT_0x14
	CALL SUBOPT_0x83
; 0000 11A0         PORTD.7 = 1;
; 0000 11A1         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x187
; 0000 11A2            {
; 0000 11A3            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x84
; 0000 11A4            PORTE.2 = 0;
; 0000 11A5            }
; 0000 11A6 
; 0000 11A7         if(PORTE.3 == 1)
_0x187:
	SBIS 0x3,3
	RJMP _0x18A
; 0000 11A8            {
; 0000 11A9            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x85
; 0000 11AA            PORTE.3 = 0;
; 0000 11AB            }
; 0000 11AC 
; 0000 11AD          if(PORT_F.bits.b4 == 1)
_0x18A:
	CALL SUBOPT_0x86
	BRNE _0x18D
; 0000 11AE             {
; 0000 11AF             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x87
; 0000 11B0             zastopowany_czas_przedmuchu = sek12;
; 0000 11B1             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 11B2             PORTF = PORT_F.byte;
; 0000 11B3             }
; 0000 11B4 
; 0000 11B5         komunikat_na_panel("                                                ",adr1,adr2);
_0x18D:
	CALL SUBOPT_0x33
; 0000 11B6         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x34
; 0000 11B7         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x88
; 0000 11B8         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x89
; 0000 11B9 
; 0000 11BA         }
	RJMP _0x182
_0x184:
; 0000 11BB     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x18E
; 0000 11BC         {
; 0000 11BD         while(sg == 0)
_0x18F:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x191
; 0000 11BE             {
; 0000 11BF             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x92
	LDI  R26,LOW(0)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0x93
	LDI  R26,LOW(0)
	CALL __EQB12
	POP  R26
	AND  R30,R26
	BREQ _0x192
; 0000 11C0                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x12
	MOVW R16,R30
; 0000 11C1 
; 0000 11C2 
; 0000 11C3             }
_0x192:
	RJMP _0x18F
_0x191:
; 0000 11C4 
; 0000 11C5         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x33
; 0000 11C6         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x88
; 0000 11C7 
; 0000 11C8         PORTD.7 = 0;
	CALL SUBOPT_0x8A
; 0000 11C9         if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x195
; 0000 11CA             {
; 0000 11CB             PORTE.2 = 1;
	CALL SUBOPT_0x8B
; 0000 11CC             byla_wloczona_szlifierka_1 = 0;
; 0000 11CD             }
; 0000 11CE         if(byla_wloczona_szlifierka_2 == 1)
_0x195:
	CALL SUBOPT_0x8C
	BRNE _0x198
; 0000 11CF             {
; 0000 11D0             PORTE.3 = 1;
	CALL SUBOPT_0x8D
; 0000 11D1             byla_wloczona_szlifierka_2 = 0;
; 0000 11D2             }
; 0000 11D3         if(byl_wloczony_przedmuch == 1)
_0x198:
	CALL SUBOPT_0x8E
	BRNE _0x19B
; 0000 11D4             {
; 0000 11D5             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x8F
; 0000 11D6             PORTF = PORT_F.byte;
; 0000 11D7             sek12 = zastopowany_czas_przedmuchu;
; 0000 11D8             byl_wloczony_przedmuch = 0;
; 0000 11D9             }
; 0000 11DA         }
_0x19B:
; 0000 11DB    }
_0x18E:
; 0000 11DC 
; 0000 11DD 
; 0000 11DE 
; 0000 11DF 
; 0000 11E0 
; 0000 11E1 }
_0x181:
_0x20A0005:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;void odczyt_parametru_panelu_stala_pamiec(int adres_nieulotny1, int adres_nieulotny2, int dokad_adres1,int dokad_adres2)
; 0000 11E5 {
_odczyt_parametru_panelu_stala_pamiec:
; 0000 11E6 
; 0000 11E7 //5AA5 0C 80 56 5A A0 00000000 1010 0010 – Odczyt (A0) z pamiêci FLASH 00000000 do VP 1010
; 0000 11E8 
; 0000 11E9 putchar(90);  //5A
;	adres_nieulotny1 -> Y+6
;	adres_nieulotny2 -> Y+4
;	dokad_adres1 -> Y+2
;	dokad_adres2 -> Y+0
	CALL SUBOPT_0x2
; 0000 11EA putchar(165); //A5
; 0000 11EB putchar(12);   //0C
	CALL SUBOPT_0x95
; 0000 11EC putchar(128);  //80    /
; 0000 11ED putchar(86);    //56
; 0000 11EE putchar(90);   //5A
; 0000 11EF putchar(160);    //A0
	LDI  R30,LOW(160)
	RJMP _0x20A0004
; 0000 11F0 putchar(0);   //00
; 0000 11F1 putchar(0);   //00
; 0000 11F2 putchar(adres_nieulotny1);   //00
; 0000 11F3 putchar(adres_nieulotny2);   //00
; 0000 11F4 putchar(dokad_adres1);   //10
; 0000 11F5 putchar(dokad_adres2);   //10
; 0000 11F6 putchar(0);   //0
; 0000 11F7 putchar(10);   //ile danych
; 0000 11F8 }
;
;
;
;
;void wartosc_parametru_panelu_stala_pamiec(int adres_nieulotny1,int adres_nieulotny2, int skad_adres1, int skad_adres2)
; 0000 11FE {
_wartosc_parametru_panelu_stala_pamiec:
; 0000 11FF 
; 0000 1200 //5AA5 0C 80 56 5A 50 00000000 1000 0010 – Zapis (50) z VP 1000 do pamiêci FLASH 00000000
; 0000 1201 
; 0000 1202 putchar(90);  //5A
;	adres_nieulotny1 -> Y+6
;	adres_nieulotny2 -> Y+4
;	skad_adres1 -> Y+2
;	skad_adres2 -> Y+0
	CALL SUBOPT_0x2
; 0000 1203 putchar(165); //A5
; 0000 1204 putchar(12);   //0C
	CALL SUBOPT_0x95
; 0000 1205 putchar(128);  //80    /
; 0000 1206 putchar(86);    //56
; 0000 1207 putchar(90);   //5A
; 0000 1208 putchar(80);    //50
	LDI  R30,LOW(80)
_0x20A0004:
	ST   -Y,R30
	CALL _putchar
; 0000 1209 putchar(0);   //00
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
; 0000 120A putchar(0);   //00
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
; 0000 120B putchar(adres_nieulotny1);   //00
	LDD  R30,Y+6
	CALL SUBOPT_0x3
; 0000 120C putchar(adres_nieulotny2);   //00
; 0000 120D putchar(skad_adres1);   //10
; 0000 120E putchar(skad_adres2);   //0
	CALL SUBOPT_0x8
; 0000 120F putchar(0);   //0
; 0000 1210 putchar(10);   //ile danych
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _putchar
; 0000 1211 }
	ADIW R28,8
	RET
;
;
;
;
;
;void wartosci_wstepne_wgrac_tylko_raz(int ktore_wgrac)
; 0000 1218 {
_wartosci_wstepne_wgrac_tylko_raz:
; 0000 1219 if(ktore_wgrac == 0)
;	ktore_wgrac -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x19C
; 0000 121A {
; 0000 121B szczotka_druciana_ilosc_cykli = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 121C krazek_scierny_ilosc_cykli = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R6,R30
; 0000 121D tryb_pracy_szczotki_drucianej = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 121E krazek_scierny_cykl_po_okregu_ilosc = 0;
	CLR  R8
	CLR  R9
; 0000 121F czas_pracy_szczotki_drucianej_stala = 150;
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	MOVW R12,R30
; 0000 1220 czas_pracy_krazka_sciernego_stala = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _czas_pracy_krazka_sciernego_stala,R30
	STS  _czas_pracy_krazka_sciernego_stala+1,R31
; 0000 1221 czas_pracy_szczotki_drucianej_h = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_szczotki_drucianej_h,R30
	STS  _czas_pracy_szczotki_drucianej_h+1,R30
; 0000 1222 czas_pracy_krazka_sciernego_h_34 = 0;
	STS  _czas_pracy_krazka_sciernego_h_34,R30
	STS  _czas_pracy_krazka_sciernego_h_34+1,R30
; 0000 1223 czas_pracy_krazka_sciernego_h_36 = 0;
	STS  _czas_pracy_krazka_sciernego_h_36,R30
	STS  _czas_pracy_krazka_sciernego_h_36+1,R30
; 0000 1224 czas_pracy_krazka_sciernego_h_38 = 0;
	STS  _czas_pracy_krazka_sciernego_h_38,R30
	STS  _czas_pracy_krazka_sciernego_h_38+1,R30
; 0000 1225 czas_pracy_krazka_sciernego_h_41 = 0;
	STS  _czas_pracy_krazka_sciernego_h_41,R30
	STS  _czas_pracy_krazka_sciernego_h_41+1,R30
; 0000 1226 czas_pracy_krazka_sciernego_h_43 = 0;
	STS  _czas_pracy_krazka_sciernego_h_43,R30
	STS  _czas_pracy_krazka_sciernego_h_43+1,R30
; 0000 1227 }
; 0000 1228 
; 0000 1229 
; 0000 122A wartosc_parametru_panelu(szczotka_druciana_ilosc_cykli,48,64);
_0x19C:
	ST   -Y,R5
	ST   -Y,R4
	CALL SUBOPT_0x11
	CALL SUBOPT_0x96
	CALL _wartosc_parametru_panelu
; 0000 122B delay_ms(200);
	CALL SUBOPT_0x97
; 0000 122C wartosc_parametru_panelu_stala_pamiec(0,0,48,64);                       //proba
	CALL SUBOPT_0x14
	CALL SUBOPT_0x11
	CALL SUBOPT_0x96
	CALL SUBOPT_0x98
; 0000 122D //putchar(adres_nieulotny1);   //00
; 0000 122E //putchar(adres_nieulotny2);   //00
; 0000 122F //putchar(skad_adres1);   //10
; 0000 1230 //putchar(skad_adres2);   //0
; 0000 1231 delay_ms(200);
; 0000 1232 odczyt_parametru_panelu_stala_pamiec(0,0,48,64);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x11
	CALL SUBOPT_0x96
	CALL SUBOPT_0x99
; 0000 1233 //putchar(adres_nieulotny1);
; 0000 1234 //putchar(adres_nieulotny2);   //00
; 0000 1235 //putchar(dokad_adres1);   //10
; 0000 1236 //putchar(dokad_adres2);   //10
; 0000 1237 delay_ms(200);
; 0000 1238 
; 0000 1239 
; 0000 123A wartosc_parametru_panelu(krazek_scierny_ilosc_cykli,32,144);
	ST   -Y,R7
	ST   -Y,R6
	CALL SUBOPT_0x23
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x9B
; 0000 123B wartosc_parametru_panelu_stala_pamiec(0,16,32,144);
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x98
; 0000 123C delay_ms(200);
; 0000 123D odczyt_parametru_panelu_stala_pamiec(0,16,32,144);
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x99
; 0000 123E delay_ms(200);
; 0000 123F 
; 0000 1240 
; 0000 1241 wartosc_parametru_panelu(krazek_scierny_cykl_po_okregu_ilosc,48,0);
	ST   -Y,R9
	ST   -Y,R8
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x9B
; 0000 1242 wartosc_parametru_panelu_stala_pamiec(0,32,48,0);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x98
; 0000 1243 delay_ms(200);
; 0000 1244 odczyt_parametru_panelu_stala_pamiec(0,32,48,0);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x99
; 0000 1245 delay_ms(200);
; 0000 1246 
; 0000 1247 
; 0000 1248 wartosc_parametru_panelu(tryb_pracy_szczotki_drucianej,0,112);
	ST   -Y,R11
	ST   -Y,R10
	CALL SUBOPT_0x14
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x9B
; 0000 1249 wartosc_parametru_panelu_stala_pamiec(0,48,0,112);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x98
; 0000 124A delay_ms(200);
; 0000 124B odczyt_parametru_panelu_stala_pamiec(0,48,0,112);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x99
; 0000 124C delay_ms(200);
; 0000 124D 
; 0000 124E 
; 0000 124F 
; 0000 1250 wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
	ST   -Y,R13
	ST   -Y,R12
	CALL SUBOPT_0x9E
	CALL SUBOPT_0x9B
; 0000 1251 wartosc_parametru_panelu_stala_pamiec(0,64,16,112);
	CALL SUBOPT_0x96
	CALL SUBOPT_0x9E
	CALL SUBOPT_0x98
; 0000 1252 delay_ms(200);
; 0000 1253 odczyt_parametru_panelu_stala_pamiec(0,64,16,112);
	CALL SUBOPT_0x96
	CALL SUBOPT_0x9E
	CALL SUBOPT_0x99
; 0000 1254 delay_ms(200);
; 0000 1255 
; 0000 1256 
; 0000 1257 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
	LDS  R30,_czas_pracy_krazka_sciernego_stala
	LDS  R31,_czas_pracy_krazka_sciernego_stala+1
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x9B
; 0000 1258 wartosc_parametru_panelu_stala_pamiec(0,80,32,16);
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x98
; 0000 1259 delay_ms(200);
; 0000 125A odczyt_parametru_panelu_stala_pamiec(0,80,32,16);
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x99
; 0000 125B delay_ms(200);
; 0000 125C 
; 0000 125D 
; 0000 125E 
; 0000 125F wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
	LDS  R30,_czas_pracy_szczotki_drucianej_h
	LDS  R31,_czas_pracy_szczotki_drucianej_h+1
	CALL SUBOPT_0xA2
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x9B
; 0000 1260 wartosc_parametru_panelu_stala_pamiec(0,96,0,144);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x14
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x98
; 0000 1261 delay_ms(200);
; 0000 1262 odczyt_parametru_panelu_stala_pamiec(0,96,0,144);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x14
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x99
; 0000 1263 delay_ms(200);
; 0000 1264 
; 0000 1265 if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 34)
	CALL SUBOPT_0xA3
	CALL SUBOPT_0x75
	CALL SUBOPT_0xA3
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x19D
; 0000 1266 {
; 0000 1267 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
	LDS  R30,_czas_pracy_krazka_sciernego_h_34
	LDS  R31,_czas_pracy_krazka_sciernego_h_34+1
	CALL SUBOPT_0xA4
	CALL SUBOPT_0x11
	CALL SUBOPT_0x9B
; 0000 1268 wartosc_parametru_panelu_stala_pamiec(0,112,96,48);
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x18
	CALL SUBOPT_0x11
	CALL SUBOPT_0x98
; 0000 1269 delay_ms(200);
; 0000 126A odczyt_parametru_panelu_stala_pamiec(0,112,96,48);
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x18
	CALL SUBOPT_0x11
	CALL SUBOPT_0x99
; 0000 126B delay_ms(200);
; 0000 126C }
; 0000 126D 
; 0000 126E if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 36)
_0x19D:
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA3
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x19E
; 0000 126F {
; 0000 1270 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
	LDS  R30,_czas_pracy_krazka_sciernego_h_36
	LDS  R31,_czas_pracy_krazka_sciernego_h_36+1
	CALL SUBOPT_0xA4
	CALL SUBOPT_0x96
	CALL SUBOPT_0x9B
; 0000 1271 wartosc_parametru_panelu_stala_pamiec(0,128,96,64);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x18
	CALL SUBOPT_0x96
	CALL SUBOPT_0x98
; 0000 1272 delay_ms(200);
; 0000 1273 odczyt_parametru_panelu_stala_pamiec(0,128,96,64);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x18
	CALL SUBOPT_0x96
	CALL SUBOPT_0x99
; 0000 1274 delay_ms(200);
; 0000 1275 }
; 0000 1276 
; 0000 1277 if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 38)
_0x19E:
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA3
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x19F
; 0000 1278 {
; 0000 1279 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
	LDS  R30,_czas_pracy_krazka_sciernego_h_38
	LDS  R31,_czas_pracy_krazka_sciernego_h_38+1
	CALL SUBOPT_0xA4
	CALL SUBOPT_0xA6
	CALL SUBOPT_0x9B
; 0000 127A wartosc_parametru_panelu_stala_pamiec(0,144,96,80);
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x18
	CALL SUBOPT_0xA6
	CALL SUBOPT_0x98
; 0000 127B delay_ms(200);
; 0000 127C odczyt_parametru_panelu_stala_pamiec(0,144,96,80);
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x18
	CALL SUBOPT_0xA6
	CALL SUBOPT_0x99
; 0000 127D delay_ms(200);
; 0000 127E }
; 0000 127F 
; 0000 1280 if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 41)
_0x19F:
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA3
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x1A0
; 0000 1281 {
; 0000 1282 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
	LDS  R30,_czas_pracy_krazka_sciernego_h_41
	LDS  R31,_czas_pracy_krazka_sciernego_h_41+1
	CALL SUBOPT_0xA4
	CALL SUBOPT_0x18
	CALL _wartosc_parametru_panelu
; 0000 1283 wartosc_parametru_panelu_stala_pamiec(16,0,96,96);
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x14
	CALL SUBOPT_0x18
	CALL SUBOPT_0x18
	CALL SUBOPT_0xA7
; 0000 1284 delay_ms(200);
; 0000 1285 odczyt_parametru_panelu_stala_pamiec(16,0,96,96);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x18
	CALL SUBOPT_0x18
	CALL SUBOPT_0x99
; 0000 1286 delay_ms(200);
; 0000 1287 }
; 0000 1288 
; 0000 1289 if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 43)
_0x1A0:
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA3
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x1A1
; 0000 128A {
; 0000 128B wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
	LDS  R30,_czas_pracy_krazka_sciernego_h_43
	LDS  R31,_czas_pracy_krazka_sciernego_h_43+1
	CALL SUBOPT_0xA4
	CALL SUBOPT_0x9D
	CALL _wartosc_parametru_panelu
; 0000 128C wartosc_parametru_panelu_stala_pamiec(16,16,96,112);
	CALL SUBOPT_0xA0
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x18
	CALL SUBOPT_0x9D
	CALL SUBOPT_0xA7
; 0000 128D delay_ms(200);
; 0000 128E odczyt_parametru_panelu_stala_pamiec(16,16,96,112);
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x18
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x99
; 0000 128F delay_ms(200);
; 0000 1290 }
; 0000 1291 
; 0000 1292 }
_0x1A1:
_0x20A0003:
	ADIW R28,2
	RET
;
;
;
;void zapis_probny_test()
; 0000 1297 {
_zapis_probny_test:
; 0000 1298 int dupa_dupa;
; 0000 1299 
; 0000 129A dupa_dupa = odczytaj_parametr(128,144);             //uruchomienie cyklu przez zapis
	ST   -Y,R17
	ST   -Y,R16
;	dupa_dupa -> R16,R17
	CALL SUBOPT_0x24
	CALL SUBOPT_0x16
	MOVW R16,R30
; 0000 129B 
; 0000 129C if(dupa_dupa == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+3
	JMP _0x1A2
; 0000 129D     {
; 0000 129E 
; 0000 129F 
; 0000 12A0 
; 0000 12A1      srednica_wew_korpusu_cyklowa = 43;
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	CALL SUBOPT_0xA8
; 0000 12A2 
; 0000 12A3                              tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0x1E
	MOVW R10,R30
; 0000 12A4                              szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 12A5                                krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
; 0000 12A6                                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
; 0000 12A7                                         czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
; 0000 12A8                                         czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
; 0000 12A9 
; 0000 12AA 
; 0000 12AB 
; 0000 12AC                             czas_pracy_szczotki_drucianej_h++;
	CALL SUBOPT_0xA9
; 0000 12AD                             if(srednica_wew_korpusu_cyklowa == 34)
	BRNE _0x1A3
; 0000 12AE                                 czas_pracy_krazka_sciernego_h_34++;
	CALL SUBOPT_0xAA
; 0000 12AF                             if(srednica_wew_korpusu_cyklowa == 36)
_0x1A3:
	CALL SUBOPT_0xA3
	SBIW R26,36
	BRNE _0x1A4
; 0000 12B0                                 czas_pracy_krazka_sciernego_h_36++;
	CALL SUBOPT_0xAB
; 0000 12B1                             if(srednica_wew_korpusu_cyklowa == 38)
_0x1A4:
	CALL SUBOPT_0xA3
	SBIW R26,38
	BRNE _0x1A5
; 0000 12B2                                 czas_pracy_krazka_sciernego_h_38++;
	CALL SUBOPT_0xAC
; 0000 12B3                             if(srednica_wew_korpusu_cyklowa == 41)
_0x1A5:
	CALL SUBOPT_0xA3
	SBIW R26,41
	BRNE _0x1A6
; 0000 12B4                                 czas_pracy_krazka_sciernego_h_41++;
	CALL SUBOPT_0xAD
; 0000 12B5                             if(srednica_wew_korpusu_cyklowa == 43)
_0x1A6:
	CALL SUBOPT_0xA3
	SBIW R26,43
	BRNE _0x1A7
; 0000 12B6                                 czas_pracy_krazka_sciernego_h_43++;
	CALL SUBOPT_0xAE
; 0000 12B7 
; 0000 12B8 
; 0000 12B9 
; 0000 12BA                             czas_pracy_szczotki_drucianej_h++;
_0x1A7:
	CALL SUBOPT_0xA9
; 0000 12BB                             if(srednica_wew_korpusu_cyklowa == 34)
	BRNE _0x1A8
; 0000 12BC                                 czas_pracy_krazka_sciernego_h_34++;
	CALL SUBOPT_0xAA
; 0000 12BD                             if(srednica_wew_korpusu_cyklowa == 36)
_0x1A8:
	CALL SUBOPT_0xA3
	SBIW R26,36
	BRNE _0x1A9
; 0000 12BE                                 czas_pracy_krazka_sciernego_h_36++;
	CALL SUBOPT_0xAB
; 0000 12BF                             if(srednica_wew_korpusu_cyklowa == 38)
_0x1A9:
	CALL SUBOPT_0xA3
	SBIW R26,38
	BRNE _0x1AA
; 0000 12C0                                 czas_pracy_krazka_sciernego_h_38++;
	CALL SUBOPT_0xAC
; 0000 12C1                             if(srednica_wew_korpusu_cyklowa == 41)
_0x1AA:
	CALL SUBOPT_0xA3
	SBIW R26,41
	BRNE _0x1AB
; 0000 12C2                                 czas_pracy_krazka_sciernego_h_41++;
	CALL SUBOPT_0xAD
; 0000 12C3                             if(srednica_wew_korpusu_cyklowa == 43)
_0x1AB:
	CALL SUBOPT_0xA3
	SBIW R26,43
	BRNE _0x1AC
; 0000 12C4                                 czas_pracy_krazka_sciernego_h_43++;
	CALL SUBOPT_0xAE
; 0000 12C5 
; 0000 12C6 
; 0000 12C7 
; 0000 12C8 
; 0000 12C9                             wartosci_wstepne_wgrac_tylko_raz(1); //to trwa 3s
_0x1AC:
	CALL SUBOPT_0xAF
	RCALL _wartosci_wstepne_wgrac_tylko_raz
; 0000 12CA 
; 0000 12CB 
; 0000 12CC                                 //wartosc wstpena panelu
; 0000 12CD                               wartosc_parametru_panelu(0,128,144);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x24
	CALL SUBOPT_0x9A
	CALL _wartosc_parametru_panelu
; 0000 12CE 
; 0000 12CF     }
; 0000 12D0 
; 0000 12D1 
; 0000 12D2 }
_0x1A2:
	RJMP _0x20A0002
;
;
;void wartosci_wstepne_panelu()
; 0000 12D6 {
_wartosci_wstepne_panelu:
; 0000 12D7 
; 0000 12D8 delay_ms(200);
	CALL SUBOPT_0x97
; 0000 12D9 odczyt_parametru_panelu_stala_pamiec(0,0,48,64);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x11
	CALL SUBOPT_0x96
	CALL SUBOPT_0xB0
; 0000 12DA delay_ms(200);
; 0000 12DB //////////////////////////////////////////////////wartosc_parametru_panelu(szczotka_druciana_ilosc_cykli,48,64);
; 0000 12DC 
; 0000 12DD 
; 0000 12DE odczyt_parametru_panelu_stala_pamiec(0,16,32,144);
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x9A
	CALL SUBOPT_0xB0
; 0000 12DF delay_ms(200);
; 0000 12E0 /////////////////////////////////////////////////wartosc_parametru_panelu(krazek_scierny_ilosc_cykli,32,144);
; 0000 12E1                                                         //3000
; 0000 12E2 odczyt_parametru_panelu_stala_pamiec(0,32,48,0);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x99
; 0000 12E3 delay_ms(200);
; 0000 12E4 /////////////////////////////////////////////////////////wartosc_parametru_panelu(krazek_scierny_cykl_po_okregu_ilosc,48,0);
; 0000 12E5                                                 //2050
; 0000 12E6 
; 0000 12E7 /////////////////////////
; 0000 12E8 delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0xB1
; 0000 12E9 odczyt_parametru_panelu_stala_pamiec(0,64,16,112);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x96
	CALL SUBOPT_0x9E
	CALL SUBOPT_0xB0
; 0000 12EA /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
; 0000 12EB 
; 0000 12EC delay_ms(200);
; 0000 12ED odczyt_parametru_panelu_stala_pamiec(0,80,32,16);
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xA0
	CALL SUBOPT_0xB0
; 0000 12EE /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
; 0000 12EF 
; 0000 12F0 delay_ms(200);
; 0000 12F1 odczyt_parametru_panelu_stala_pamiec(0,96,0,144);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x14
	CALL SUBOPT_0x9A
	CALL SUBOPT_0xB0
; 0000 12F2 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
; 0000 12F3 
; 0000 12F4 delay_ms(200);
; 0000 12F5 odczyt_parametru_panelu_stala_pamiec(0,112,96,48);
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x18
	CALL SUBOPT_0x11
	CALL SUBOPT_0xB0
; 0000 12F6 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
; 0000 12F7 
; 0000 12F8 delay_ms(200);
; 0000 12F9 odczyt_parametru_panelu_stala_pamiec(0,128,96,64);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x18
	CALL SUBOPT_0x96
	CALL SUBOPT_0xB0
; 0000 12FA /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
; 0000 12FB 
; 0000 12FC delay_ms(200);
; 0000 12FD odczyt_parametru_panelu_stala_pamiec(0,144,96,80);
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x18
	CALL SUBOPT_0xA6
	CALL SUBOPT_0x99
; 0000 12FE /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
; 0000 12FF 
; 0000 1300 delay_ms(200);
; 0000 1301 odczyt_parametru_panelu_stala_pamiec(16,0,96,96);
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x14
	CALL SUBOPT_0x18
	CALL SUBOPT_0x18
	CALL SUBOPT_0x99
; 0000 1302 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
; 0000 1303 
; 0000 1304 delay_ms(200);
; 0000 1305 odczyt_parametru_panelu_stala_pamiec(16,16,96,112);
	CALL SUBOPT_0xA0
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x18
	CALL SUBOPT_0x9D
	CALL SUBOPT_0xB0
; 0000 1306 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
; 0000 1307 
; 0000 1308 delay_ms(200);
; 0000 1309 odczyt_parametru_panelu_stala_pamiec(0,48,0,112);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x99
; 0000 130A delay_ms(200);
; 0000 130B //////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(tryb_pracy_szczotki_drucianej,0,112);
; 0000 130C 
; 0000 130D 
; 0000 130E //////////////////////////
; 0000 130F wartosc_parametru_panelu(predkosc_pion_szczotka,32,80);
	LDS  R30,_predkosc_pion_szczotka
	LDS  R31,_predkosc_pion_szczotka+1
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xA6
	CALL _wartosc_parametru_panelu
; 0000 1310                                                 //2060
; 0000 1311 wartosc_parametru_panelu(predkosc_pion_krazek,32,96);
	LDS  R30,_predkosc_pion_krazek
	LDS  R31,_predkosc_pion_krazek+1
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x18
	CALL _wartosc_parametru_panelu
; 0000 1312                                                                        //3010
; 0000 1313 wartosc_parametru_panelu(wejscie_krazka_sciernego_w_pow_boczna_cylindra,48,16);
	LDS  R30,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R31,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	CALL SUBOPT_0xB2
	CALL SUBOPT_0xA0
	CALL _wartosc_parametru_panelu
; 0000 1314                                                                      //2070
; 0000 1315 wartosc_parametru_panelu(predkosc_ruchow_po_okregu_krazek_scierny,32,112);
	LDS  R30,_predkosc_ruchow_po_okregu_krazek_scierny
	LDS  R31,_predkosc_ruchow_po_okregu_krazek_scierny+1
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x9D
	CALL _wartosc_parametru_panelu
; 0000 1316 wartosc_parametru_panelu(40,48,112);  //srednica krazka wstepnie
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x9D
	CALL _wartosc_parametru_panelu
; 0000 1317 wartosc_parametru_panelu(145,48,128);   //to do manualnego wczytywania zacisku, ma byc 145
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x24
	CALL SUBOPT_0x9B
; 0000 1318 wartosc_parametru_panelu(0,128,64);   //to do statystyki, zeby zawsze bylo 0
	CALL SUBOPT_0x24
	CALL SUBOPT_0x96
	CALL _wartosc_parametru_panelu
; 0000 1319 
; 0000 131A 
; 0000 131B 
; 0000 131C }
	RET
;
;void wypozycjonuj_napedy_minimalistyczna()
; 0000 131F {
; 0000 1320 
; 0000 1321 while(start == 0)
; 0000 1322     {
; 0000 1323     komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1324     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr1,adr2);
; 0000 1325     komunikat_na_panel("                                                ",adr3,adr4);
; 0000 1326     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr3,adr4);
; 0000 1327     delay_ms(1000);
; 0000 1328     start = odczytaj_parametr(0,64);
; 0000 1329     }
; 0000 132A 
; 0000 132B 
; 0000 132C while(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
; 0000 132D     {
; 0000 132E     komunikat_na_panel("                                                ",adr1,adr2);
; 0000 132F     komunikat_na_panel("Zamknij oslony gorne",adr1,adr2);
; 0000 1330     komunikat_na_panel("                                                ",adr3,adr4);
; 0000 1331     komunikat_na_panel("Zamknij oslony gorne",adr3,adr4);
; 0000 1332     }
; 0000 1333 
; 0000 1334 
; 0000 1335 PORTB.4 = 1;   //setupy piony
; 0000 1336 
; 0000 1337 delay_ms(1000);
; 0000 1338 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1339 
; 0000 133A 
; 0000 133B 
; 0000 133C while(sprawdz_pin3(PORTKK,0x75) == 1 | sprawdz_pin7(PORTKK,0x75) == 1)
; 0000 133D       {
; 0000 133E       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
; 0000 133F         while(1)
; 0000 1340             {
; 0000 1341             PORTD.7 = 1;
; 0000 1342             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 1343 
; 0000 1344             PORTB.4 = 0;   //setupy piony
; 0000 1345             PORTD.2 = 0;   //setup wspolny
; 0000 1346 
; 0000 1347             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1348             komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
; 0000 1349             komunikat_na_panel("                                                ",adr3,adr4);
; 0000 134A             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
; 0000 134B 
; 0000 134C             wartosc_parametru_panelu(0,0,64);  //start na 0;
; 0000 134D             }
; 0000 134E 
; 0000 134F 
; 0000 1350       if(sprawdz_pin2(PORTMM,0x77) == 0)
; 0000 1351         while(1)
; 0000 1352             {
; 0000 1353             PORTD.7 = 1;
; 0000 1354             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 1355 
; 0000 1356             PORTB.4 = 0;   //setupy piony
; 0000 1357             PORTD.2 = 0;   //setup wspolny
; 0000 1358 
; 0000 1359             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 135A             komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
; 0000 135B             komunikat_na_panel("                                                ",adr3,adr4);
; 0000 135C             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
; 0000 135D 
; 0000 135E             wartosc_parametru_panelu(0,0,64);  //start na 0;
; 0000 135F             }
; 0000 1360 
; 0000 1361 
; 0000 1362       komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1363       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
; 0000 1364       komunikat_na_panel("                                                ",adr3,adr4);
; 0000 1365       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
; 0000 1366       delay_ms(1000);
; 0000 1367 
; 0000 1368       if(sprawdz_pin3(PORTKK,0x75) == 0)
; 0000 1369             {
; 0000 136A             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 136B             komunikat_na_panel("Sterownik 3 - wypozycjonowalem",adr1,adr2);
; 0000 136C             delay_ms(1000);
; 0000 136D             }
; 0000 136E       if(sprawdz_pin7(PORTKK,0x75) == 0)
; 0000 136F             {
; 0000 1370             komunikat_na_panel("                                                ",adr3,adr4);
; 0000 1371             komunikat_na_panel("Sterownik 4 - wypozycjonowalem",adr1,adr2);
; 0000 1372             delay_ms(1000);
; 0000 1373             }
; 0000 1374 
; 0000 1375 
; 0000 1376       if(sprawdz_pin6(PORTMM,0x77) == 1 |
; 0000 1377          sprawdz_pin7(PORTMM,0x77) == 1)
; 0000 1378             {
; 0000 1379             PORTD.7 = 1;
; 0000 137A             if(sprawdz_pin6(PORTMM,0x77) == 1)
; 0000 137B                 {
; 0000 137C                 komunikat_na_panel("                                                ",adr1,adr2);
; 0000 137D                 komunikat_na_panel("Alarm Sterownik 4",adr1,adr2);
; 0000 137E                 delay_ms(1000);
; 0000 137F                 }
; 0000 1380             if(sprawdz_pin7(PORTMM,0x77) == 1)
; 0000 1381                 {
; 0000 1382                 komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1383                 komunikat_na_panel("Alarm Sterownik 3",adr1,adr2);
; 0000 1384                 delay_ms(1000);
; 0000 1385                 }
; 0000 1386             }
; 0000 1387 
; 0000 1388 
; 0000 1389 
; 0000 138A 
; 0000 138B 
; 0000 138C 
; 0000 138D 
; 0000 138E 
; 0000 138F       }
; 0000 1390 
; 0000 1391 PORTB.4 = 0;   //setupy piony
; 0000 1392 PORTD.2 = 1;   //setup poziomy
; 0000 1393 delay_ms(1000);
; 0000 1394 
; 0000 1395 
; 0000 1396 while(sprawdz_pin3(PORTJJ,0x79) == 1 | sprawdz_pin3(PORTLL,0x71) == 1)
; 0000 1397       {
; 0000 1398 
; 0000 1399       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
; 0000 139A         while(1)
; 0000 139B             {
; 0000 139C             PORTD.7 = 1;
; 0000 139D             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 139E             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 139F             komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
; 0000 13A0             komunikat_na_panel("                                                ",adr3,adr4);
; 0000 13A1             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
; 0000 13A2 
; 0000 13A3             PORTB.4 = 0;   //setupy piony
; 0000 13A4             PORTD.2 = 0;   //setup wspolny
; 0000 13A5 
; 0000 13A6             wartosc_parametru_panelu(0,0,64);  //start na 0;
; 0000 13A7             }
; 0000 13A8 
; 0000 13A9 
; 0000 13AA       if(sprawdz_pin2(PORTMM,0x77) == 0)
; 0000 13AB         while(1)
; 0000 13AC             {
; 0000 13AD             PORTD.7 = 1;
; 0000 13AE             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 13AF 
; 0000 13B0             PORTB.4 = 0;   //setupy piony
; 0000 13B1             PORTD.2 = 0;   //setup wspolny
; 0000 13B2 
; 0000 13B3             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 13B4             komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
; 0000 13B5             komunikat_na_panel("                                                ",adr3,adr4);
; 0000 13B6             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
; 0000 13B7 
; 0000 13B8             wartosc_parametru_panelu(0,0,64);  //start na 0;
; 0000 13B9             }
; 0000 13BA 
; 0000 13BB       komunikat_na_panel("                                                ",adr1,adr2);
; 0000 13BC       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
; 0000 13BD       komunikat_na_panel("                                                ",adr3,adr4);
; 0000 13BE       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
; 0000 13BF       delay_ms(1000);
; 0000 13C0 
; 0000 13C1       if(sprawdz_pin3(PORTJJ,0x79) == 0)
; 0000 13C2             {
; 0000 13C3             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 13C4             komunikat_na_panel("Sterownik 1 - wypozycjonowalem",adr1,adr2);
; 0000 13C5             delay_ms(1000);
; 0000 13C6             }
; 0000 13C7       if(sprawdz_pin3(PORTLL,0x71) == 0)
; 0000 13C8             {
; 0000 13C9             komunikat_na_panel("                                                ",adr3,adr4);
; 0000 13CA             komunikat_na_panel("Sterownik 2 - wypozycjonowalem",adr3,adr4);
; 0000 13CB             delay_ms(1000);
; 0000 13CC             }
; 0000 13CD 
; 0000 13CE        //if(sprawdz_pin7(PORTMM,0x77) == 1)
; 0000 13CF        //     PORTD.7 = 1;
; 0000 13D0 
; 0000 13D1       if(sprawdz_pin5(PORTJJ,0x79) == 1 |
; 0000 13D2          sprawdz_pin5(PORTLL,0x71) == 1)
; 0000 13D3             {
; 0000 13D4             PORTD.7 = 1;
; 0000 13D5             if(sprawdz_pin5(PORTJJ,0x79) == 1)
; 0000 13D6                 {
; 0000 13D7                 komunikat_na_panel("                                                ",adr1,adr2);
; 0000 13D8                 komunikat_na_panel("Alarm Sterownik 1",adr1,adr2);
; 0000 13D9                 delay_ms(1000);
; 0000 13DA                 }
; 0000 13DB             if(sprawdz_pin5(PORTLL,0x71) == 1)
; 0000 13DC                 {
; 0000 13DD                 komunikat_na_panel("                                                ",adr1,adr2);
; 0000 13DE                 komunikat_na_panel("Alarm Sterownik 2",adr1,adr2);
; 0000 13DF                 delay_ms(1000);
; 0000 13E0                 }
; 0000 13E1 
; 0000 13E2             }
; 0000 13E3 
; 0000 13E4       //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 13E5 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 13E6       //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 13E7        //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 13E8 
; 0000 13E9 
; 0000 13EA 
; 0000 13EB       }
; 0000 13EC 
; 0000 13ED komunikat_na_panel("                                                ",adr1,adr2);
; 0000 13EE komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr1,adr2);
; 0000 13EF komunikat_na_panel("                                                ",adr3,adr4);
; 0000 13F0 komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr3,adr4);
; 0000 13F1 
; 0000 13F2 PORTD.2 = 0;   //setup wspolny
; 0000 13F3 PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 13F4 delay_ms(1000);
; 0000 13F5 wartosc_parametru_panelu(0,0,64);  //start na 0;
; 0000 13F6 start = 0;
; 0000 13F7 
; 0000 13F8 }
;
;
;void przerzucanie_dociskow()
; 0000 13FC {
_przerzucanie_dociskow:
; 0000 13FD 
; 0000 13FE if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x92
	LDI  R26,LOW(0)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0x93
	LDI  R26,LOW(0)
	CALL __EQB12
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x203
; 0000 13FF   {
; 0000 1400    if(sprawdz_pin6(PORTLL,0x71) == 0 & sprawdz_pin7(PORTLL,0x71) == 0 & czekaj_az_puszcze == 0)
	CALL SUBOPT_0xB3
	CALL _sprawdz_pin6
	LDI  R26,LOW(0)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0xB3
	CALL _sprawdz_pin7
	LDI  R26,LOW(0)
	CALL __EQB12
	POP  R26
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xB5
	BREQ _0x204
; 0000 1401            {
; 0000 1402            czekaj_az_puszcze = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 1403            //PORTB.6 = 1;
; 0000 1404            }
; 0000 1405        if(sprawdz_pin6(PORTLL,0x71) == 1 & sprawdz_pin7(PORTLL,0x71) == 1 & czekaj_az_puszcze == 1)
_0x204:
	CALL SUBOPT_0xB3
	CALL _sprawdz_pin6
	LDI  R26,LOW(1)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0xB3
	CALL _sprawdz_pin7
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x205
; 0000 1406            {
; 0000 1407            czekaj_az_puszcze = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 1408            //PORTB.6 = 0;
; 0000 1409            }
; 0000 140A 
; 0000 140B        if(czekaj_az_puszcze == 2 & PORTE.6 == 1)
_0x205:
	CALL SUBOPT_0xB6
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x206
; 0000 140C             {
; 0000 140D             PORTE.6 = 0;
	CBI  0x3,6
; 0000 140E             czekaj_az_puszcze = 0;
	CALL SUBOPT_0xB7
; 0000 140F             delay_ms(100);
; 0000 1410             }
; 0000 1411 
; 0000 1412        if(czekaj_az_puszcze == 2 & PORTE.6 == 0)
_0x206:
	CALL SUBOPT_0xB6
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x209
; 0000 1413            {
; 0000 1414             PORTE.6 = 1;
	SBI  0x3,6
; 0000 1415             czekaj_az_puszcze = 0;
	CALL SUBOPT_0xB7
; 0000 1416             delay_ms(100);
; 0000 1417            }
; 0000 1418 
; 0000 1419   }
_0x209:
; 0000 141A }
_0x203:
	RET
;
;void ostateczny_wybor_zacisku()
; 0000 141D {
_ostateczny_wybor_zacisku:
; 0000 141E int rzad;
; 0000 141F 
; 0000 1420   if(sek11 > 60) //co 1s sekunde sprawdzam   //jak co 40 to sie wywala
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	LDS  R26,_sek11
	LDS  R27,_sek11+1
	LDS  R24,_sek11+2
	LDS  R25,_sek11+3
	CALL SUBOPT_0x81
	BRGE PC+3
	JMP _0x20C
; 0000 1421         {
; 0000 1422        sek11 = 0;
	CALL SUBOPT_0xB8
; 0000 1423        if(odczytalem_zacisk < il_prob_odczytu &
; 0000 1424                                            (sprawdz_pin0(PORTHH,0x73) == 1 |
; 0000 1425                                             sprawdz_pin1(PORTHH,0x73) == 1 |
; 0000 1426                                             sprawdz_pin2(PORTHH,0x73) == 1 |
; 0000 1427                                             sprawdz_pin3(PORTHH,0x73) == 1 |
; 0000 1428                                             sprawdz_pin4(PORTHH,0x73) == 1 |
; 0000 1429                                             sprawdz_pin5(PORTHH,0x73) == 1 |
; 0000 142A                                             sprawdz_pin6(PORTHH,0x73) == 1 |
; 0000 142B                                             sprawdz_pin7(PORTHH,0x73) == 1))
	CALL SUBOPT_0xB9
	CALL __LTW12
	PUSH R30
	CALL SUBOPT_0x21
	CALL _sprawdz_pin0
	LDI  R26,LOW(1)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0x21
	CALL _sprawdz_pin1
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x21
	CALL _sprawdz_pin2
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x21
	CALL _sprawdz_pin3
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x21
	CALL _sprawdz_pin4
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x21
	CALL _sprawdz_pin5
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x21
	CALL _sprawdz_pin6
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x21
	CALL _sprawdz_pin7
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	POP  R26
	AND  R30,R26
	BREQ _0x20D
; 0000 142C         {
; 0000 142D         odczytalem_zacisk++;
	CALL SUBOPT_0xBA
; 0000 142E         }
; 0000 142F         }
_0x20D:
; 0000 1430 
; 0000 1431 if(odczytalem_zacisk == il_prob_odczytu)
_0x20C:
	CALL SUBOPT_0xB9
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x20E
; 0000 1432         {
; 0000 1433         //PORTB = 0xFF;
; 0000 1434         rzad = odczyt_wybranego_zacisku();
	CALL _odczyt_wybranego_zacisku
	MOVW R16,R30
; 0000 1435         //sek10 = 0;
; 0000 1436         sek11 = 0;    //nowe
	CALL SUBOPT_0xB8
; 0000 1437         odczytalem_zacisk++;
	CALL SUBOPT_0xBA
; 0000 1438 
; 0000 1439         //if(rzad == 1)
; 0000 143A         //    wartosc_parametru_panelu(2,32,128);    //tego nie chca
; 0000 143B         //if(rzad == 2)
; 0000 143C         //    wartosc_parametru_panelu(1,32,128);
; 0000 143D 
; 0000 143E         }                                     //& sek10 > 1                //3s po odczytaniu dopiero sprawdzam port
; 0000 143F if((odczytalem_zacisk == il_prob_odczytu + 1))        //183
_0x20E:
	LDS  R30,_il_prob_odczytu
	LDS  R31,_il_prob_odczytu+1
	ADIW R30,1
	LDS  R26,_odczytalem_zacisk
	LDS  R27,_odczytalem_zacisk+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x20F
; 0000 1440         {
; 0000 1441 
; 0000 1442         if(rzad == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x210
; 0000 1443             wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x14
	CALL SUBOPT_0x14
	CALL SUBOPT_0x18
	CALL _wartosc_parametru_panelu
; 0000 1444 
; 0000 1445         if(rzad == 2 & start == 0)
_0x210:
	MOVW R26,R16
	CALL SUBOPT_0xBB
	MOV  R0,R30
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xB5
	BREQ _0x211
; 0000 1446             wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad2
	CALL SUBOPT_0x14
	CALL SUBOPT_0x14
	CALL SUBOPT_0xA0
	CALL _wartosc_parametru_panelu
; 0000 1447 
; 0000 1448         if(rzad == 2 & start == 1)
_0x211:
	MOVW R26,R16
	CALL SUBOPT_0xBB
	CALL SUBOPT_0x91
	AND  R30,R0
	BREQ _0x212
; 0000 1449             zaaktualizuj_ilosc_rzad2 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _zaaktualizuj_ilosc_rzad2,R30
	STS  _zaaktualizuj_ilosc_rzad2+1,R31
; 0000 144A 
; 0000 144B 
; 0000 144C         odczytalem_zacisk = 0;
_0x212:
	LDI  R30,LOW(0)
	STS  _odczytalem_zacisk,R30
	STS  _odczytalem_zacisk+1,R30
; 0000 144D         if(start == 1)
	CALL SUBOPT_0xBC
	SBIW R26,1
	BRNE _0x213
; 0000 144E             odczytalem_w_trakcie_czyszczenia_drugiego_rzedu = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu,R30
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1,R31
; 0000 144F         }
_0x213:
; 0000 1450 }
_0x20F:
_0x20A0002:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;
;int sterownik_1_praca(int PORT)
; 0000 1455 {
_sterownik_1_praca:
; 0000 1456 //PORTA.0   IN0  STEROWNIK1
; 0000 1457 //PORTA.1   IN1  STEROWNIK1
; 0000 1458 //PORTA.2   IN2  STEROWNIK1
; 0000 1459 //PORTA.3   IN3  STEROWNIK1
; 0000 145A //PORTA.4   IN4  STEROWNIK1
; 0000 145B //PORTA.5   IN5  STEROWNIK1
; 0000 145C //PORTA.6   IN6  STEROWNIK1
; 0000 145D //PORTA.7   IN7  STEROWNIK1
; 0000 145E //PORTD.4   IN8 STEROWNIK1
; 0000 145F 
; 0000 1460 //PORTD.2  SETUP   STEROWNIK1
; 0000 1461 //PORTD.3  DRIVE   STEROWNIK1
; 0000 1462 
; 0000 1463 //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 1464 //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 1465 
; 0000 1466 if(sprawdz_pin5(PORTJJ,0x79) == 1)     //if alarn
;	PORT -> Y+0
	CALL SUBOPT_0xBD
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x214
; 0000 1467     {
; 0000 1468     PORTD.7 = 1;
	CALL SUBOPT_0xBE
; 0000 1469     PORTE.2 = 0;
; 0000 146A     PORTE.3 = 0;  //szlifierki stop
; 0000 146B     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 146C     PORTF = PORT_F.byte;
; 0000 146D 
; 0000 146E     while(1)
_0x21B:
; 0000 146F         {
; 0000 1470         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x33
; 0000 1471         komunikat_na_panel("Kolizja XY ukladu krazka",adr1,adr2);
	__POINTW1FN _0x0,1853
	CALL SUBOPT_0x34
; 0000 1472         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x88
; 0000 1473         komunikat_na_panel("Kolizja XY ukladu krazka",adr3,adr4);
	__POINTW1FN _0x0,1853
	CALL SUBOPT_0x89
; 0000 1474         }
	RJMP _0x21B
; 0000 1475 
; 0000 1476     }
; 0000 1477 
; 0000 1478 if(start == 1)
_0x214:
	CALL SUBOPT_0xBC
	SBIW R26,1
	BRNE _0x21E
; 0000 1479     {
; 0000 147A     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xBF
; 0000 147B     obsluga_nacisniecia_zatrzymaj();
; 0000 147C     }
; 0000 147D switch(cykl_sterownik_1)
_0x21E:
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
; 0000 147E         {
; 0000 147F         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x222
; 0000 1480 
; 0000 1481             sek1 = 0;
	CALL SUBOPT_0xC0
; 0000 1482             PORT_STER1.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER1,R30
; 0000 1483             PORTA.0 = PORT_STER1.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x223
	CBI  0x1B,0
	RJMP _0x224
_0x223:
	SBI  0x1B,0
_0x224:
; 0000 1484             PORTA.1 = PORT_STER1.bits.b1;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x2)
	BRNE _0x225
	CBI  0x1B,1
	RJMP _0x226
_0x225:
	SBI  0x1B,1
_0x226:
; 0000 1485             PORTA.2 = PORT_STER1.bits.b2;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x4)
	BRNE _0x227
	CBI  0x1B,2
	RJMP _0x228
_0x227:
	SBI  0x1B,2
_0x228:
; 0000 1486             PORTA.3 = PORT_STER1.bits.b3;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x8)
	BRNE _0x229
	CBI  0x1B,3
	RJMP _0x22A
_0x229:
	SBI  0x1B,3
_0x22A:
; 0000 1487             PORTA.4 = PORT_STER1.bits.b4;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x10)
	BRNE _0x22B
	CBI  0x1B,4
	RJMP _0x22C
_0x22B:
	SBI  0x1B,4
_0x22C:
; 0000 1488             PORTA.5 = PORT_STER1.bits.b5;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x20)
	BRNE _0x22D
	CBI  0x1B,5
	RJMP _0x22E
_0x22D:
	SBI  0x1B,5
_0x22E:
; 0000 1489             PORTA.6 = PORT_STER1.bits.b6;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x40)
	BRNE _0x22F
	CBI  0x1B,6
	RJMP _0x230
_0x22F:
	SBI  0x1B,6
_0x230:
; 0000 148A             PORTA.7 = PORT_STER1.bits.b7;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x80)
	BRNE _0x231
	CBI  0x1B,7
	RJMP _0x232
_0x231:
	SBI  0x1B,7
_0x232:
; 0000 148B 
; 0000 148C             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x233
; 0000 148D                 PORTD.4 = 1;
	SBI  0x12,4
; 0000 148E 
; 0000 148F 
; 0000 1490 
; 0000 1491             cykl_sterownik_1 = 1;
_0x233:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x53F
; 0000 1492 
; 0000 1493         break;
; 0000 1494 
; 0000 1495         case 1:
_0x222:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x236
; 0000 1496 
; 0000 1497             if(sek1 > 1)
	LDS  R26,_sek1
	LDS  R27,_sek1+1
	LDS  R24,_sek1+2
	LDS  R25,_sek1+3
	CALL SUBOPT_0xC1
	BRLT _0x237
; 0000 1498                 {
; 0000 1499 
; 0000 149A                 PORTD.3 = 1;
	SBI  0x12,3
; 0000 149B                 cykl_sterownik_1 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xC2
; 0000 149C                 }
; 0000 149D         break;
_0x237:
	RJMP _0x221
; 0000 149E 
; 0000 149F 
; 0000 14A0         case 2:
_0x236:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x23A
; 0000 14A1 
; 0000 14A2                if(sprawdz_pin0(PORTJJ,0x79) == 0)     //busy
	CALL SUBOPT_0xBD
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x23B
; 0000 14A3                   {
; 0000 14A4 
; 0000 14A5                   PORTD.3 = 0;
	CBI  0x12,3
; 0000 14A6                   PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 14A7                   PORTD.4 = 0;
	CBI  0x12,4
; 0000 14A8                   sek1 = 0;
	CALL SUBOPT_0xC0
; 0000 14A9                   cykl_sterownik_1 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xC2
; 0000 14AA                   }
; 0000 14AB 
; 0000 14AC         break;
_0x23B:
	RJMP _0x221
; 0000 14AD 
; 0000 14AE         case 3:
_0x23A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x240
; 0000 14AF 
; 0000 14B0                if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0xBD
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x241
; 0000 14B1                   {
; 0000 14B2 
; 0000 14B3                   sek1 = 0;
	CALL SUBOPT_0xC0
; 0000 14B4                   cykl_sterownik_1 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xC2
; 0000 14B5                   }
; 0000 14B6 
; 0000 14B7 
; 0000 14B8         break;
_0x241:
	RJMP _0x221
; 0000 14B9 
; 0000 14BA 
; 0000 14BB         case 4:
_0x240:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x221
; 0000 14BC 
; 0000 14BD             if(sprawdz_pin0(PORTJJ,0x79) == 1)
	CALL SUBOPT_0xBD
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x243
; 0000 14BE                 {
; 0000 14BF 
; 0000 14C0                 cykl_sterownik_1 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x53F:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
; 0000 14C1                 }
; 0000 14C2         break;
_0x243:
; 0000 14C3 
; 0000 14C4         }
_0x221:
; 0000 14C5 
; 0000 14C6 return cykl_sterownik_1;
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
	RJMP _0x20A0001
; 0000 14C7 }
;
;
;int sterownik_2_praca(int PORT)
; 0000 14CB {
_sterownik_2_praca:
; 0000 14CC //PORTC.0   IN0  STEROWNIK2
; 0000 14CD //PORTC.1   IN1  STEROWNIK2
; 0000 14CE //PORTC.2   IN2  STEROWNIK2
; 0000 14CF //PORTC.3   IN3  STEROWNIK2
; 0000 14D0 //PORTC.4   IN4  STEROWNIK2
; 0000 14D1 //PORTC.5   IN5  STEROWNIK2
; 0000 14D2 //PORTC.6   IN6  STEROWNIK2
; 0000 14D3 //PORTC.7   IN7  STEROWNIK2
; 0000 14D4 //PORTD.5   IN8 STEROWNIK2
; 0000 14D5 
; 0000 14D6 
; 0000 14D7 //PORTD.5  SETUP   STEROWNIK2
; 0000 14D8 //PORTD.6  DRIVE   STEROWNIK2
; 0000 14D9 
; 0000 14DA //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 14DB //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 14DC 
; 0000 14DD  if(sprawdz_pin5(PORTLL,0x71) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0xB3
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x244
; 0000 14DE     {
; 0000 14DF     PORTD.7 = 1;
	CALL SUBOPT_0xBE
; 0000 14E0     PORTE.2 = 0;
; 0000 14E1     PORTE.3 = 0;  //szlifierki stop
; 0000 14E2     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 14E3     PORTF = PORT_F.byte;
; 0000 14E4 
; 0000 14E5     while(1)
_0x24B:
; 0000 14E6         {
; 0000 14E7         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x33
; 0000 14E8         komunikat_na_panel("Kolizja XY ukladu szczotki",adr1,adr2);
	__POINTW1FN _0x0,1878
	CALL SUBOPT_0x34
; 0000 14E9         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x88
; 0000 14EA         komunikat_na_panel("Kolizja XY ukladu szczotki",adr3,adr4);
	__POINTW1FN _0x0,1878
	CALL SUBOPT_0x89
; 0000 14EB         }
	RJMP _0x24B
; 0000 14EC 
; 0000 14ED     }
; 0000 14EE if(start == 1)
_0x244:
	CALL SUBOPT_0xBC
	SBIW R26,1
	BRNE _0x24E
; 0000 14EF     {
; 0000 14F0     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xBF
; 0000 14F1     obsluga_nacisniecia_zatrzymaj();
; 0000 14F2     }
; 0000 14F3 switch(cykl_sterownik_2)
_0x24E:
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
; 0000 14F4         {
; 0000 14F5         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x252
; 0000 14F6 
; 0000 14F7             sek3 = 0;
	CALL SUBOPT_0xC3
; 0000 14F8             PORT_STER2.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER2,R30
; 0000 14F9             PORTC.0 = PORT_STER2.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x253
	CBI  0x15,0
	RJMP _0x254
_0x253:
	SBI  0x15,0
_0x254:
; 0000 14FA             PORTC.1 = PORT_STER2.bits.b1;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x2)
	BRNE _0x255
	CBI  0x15,1
	RJMP _0x256
_0x255:
	SBI  0x15,1
_0x256:
; 0000 14FB             PORTC.2 = PORT_STER2.bits.b2;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x4)
	BRNE _0x257
	CBI  0x15,2
	RJMP _0x258
_0x257:
	SBI  0x15,2
_0x258:
; 0000 14FC             PORTC.3 = PORT_STER2.bits.b3;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x8)
	BRNE _0x259
	CBI  0x15,3
	RJMP _0x25A
_0x259:
	SBI  0x15,3
_0x25A:
; 0000 14FD             PORTC.4 = PORT_STER2.bits.b4;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x10)
	BRNE _0x25B
	CBI  0x15,4
	RJMP _0x25C
_0x25B:
	SBI  0x15,4
_0x25C:
; 0000 14FE             PORTC.5 = PORT_STER2.bits.b5;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x20)
	BRNE _0x25D
	CBI  0x15,5
	RJMP _0x25E
_0x25D:
	SBI  0x15,5
_0x25E:
; 0000 14FF             PORTC.6 = PORT_STER2.bits.b6;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x40)
	BRNE _0x25F
	CBI  0x15,6
	RJMP _0x260
_0x25F:
	SBI  0x15,6
_0x260:
; 0000 1500             PORTC.7 = PORT_STER2.bits.b7;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x80)
	BRNE _0x261
	CBI  0x15,7
	RJMP _0x262
_0x261:
	SBI  0x15,7
_0x262:
; 0000 1501             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x263
; 0000 1502                 PORTD.5 = 1;
	SBI  0x12,5
; 0000 1503 
; 0000 1504 
; 0000 1505             cykl_sterownik_2 = 1;
_0x263:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x540
; 0000 1506 
; 0000 1507 
; 0000 1508         break;
; 0000 1509 
; 0000 150A         case 1:
_0x252:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x266
; 0000 150B 
; 0000 150C             if(sek3 > 1)
	LDS  R26,_sek3
	LDS  R27,_sek3+1
	LDS  R24,_sek3+2
	LDS  R25,_sek3+3
	CALL SUBOPT_0xC1
	BRLT _0x267
; 0000 150D                 {
; 0000 150E                 PORTD.6 = 1;
	SBI  0x12,6
; 0000 150F                 cykl_sterownik_2 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xC4
; 0000 1510                 }
; 0000 1511         break;
_0x267:
	RJMP _0x251
; 0000 1512 
; 0000 1513 
; 0000 1514         case 2:
_0x266:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x26A
; 0000 1515 
; 0000 1516                if(sprawdz_pin0(PORTLL,0x71) == 0)     //busy
	CALL SUBOPT_0xB3
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x26B
; 0000 1517                   {
; 0000 1518                   PORTD.6 = 0;
	CBI  0x12,6
; 0000 1519                   PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 151A                   PORTD.5 = 0;
	CBI  0x12,5
; 0000 151B                   sek3 = 0;
	CALL SUBOPT_0xC3
; 0000 151C                   cykl_sterownik_2 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xC4
; 0000 151D                   }
; 0000 151E 
; 0000 151F         break;
_0x26B:
	RJMP _0x251
; 0000 1520 
; 0000 1521         case 3:
_0x26A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x270
; 0000 1522 
; 0000 1523                if(sprawdz_pin3(PORTLL,0x71) == 0)
	CALL SUBOPT_0xB3
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x271
; 0000 1524                   {
; 0000 1525                   sek3 = 0;
	CALL SUBOPT_0xC3
; 0000 1526                   cykl_sterownik_2 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xC4
; 0000 1527                   }
; 0000 1528 
; 0000 1529 
; 0000 152A         break;
_0x271:
	RJMP _0x251
; 0000 152B 
; 0000 152C 
; 0000 152D         case 4:
_0x270:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x251
; 0000 152E 
; 0000 152F             if(sprawdz_pin0(PORTLL,0x71) == 1)
	CALL SUBOPT_0xB3
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x273
; 0000 1530                 {
; 0000 1531                 cykl_sterownik_2 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x540:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
; 0000 1532                 }
; 0000 1533         break;
_0x273:
; 0000 1534 
; 0000 1535         }
_0x251:
; 0000 1536 
; 0000 1537 return cykl_sterownik_2;
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
	RJMP _0x20A0001
; 0000 1538 }
;
;
;
;
;
;
;int sterownik_3_praca(int PORT)
; 0000 1540 {
_sterownik_3_praca:
; 0000 1541 //PORTF.0   IN0  STEROWNIK3
; 0000 1542 //PORTF.1   IN1  STEROWNIK3
; 0000 1543 //PORTF.2   IN2  STEROWNIK3
; 0000 1544 //PORTF.3   IN3  STEROWNIK3
; 0000 1545 //PORTF.7   IN4 STEROWNIK 3
; 0000 1546 //PORTB.7   IN5 STEROWNIK 3
; 0000 1547 
; 0000 1548 
; 0000 1549 
; 0000 154A //PORTF.5   DRIVE  STEROWNIK3
; 0000 154B 
; 0000 154C //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 154D //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 154E 
; 0000 154F if(sprawdz_pin7(PORTMM,0x77) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0xC5
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x274
; 0000 1550      {
; 0000 1551      PORTD.7 = 1;
	CALL SUBOPT_0xBE
; 0000 1552      PORTE.2 = 0;
; 0000 1553      PORTE.3 = 0;  //szlifierki stop
; 0000 1554      PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1555      PORTF = PORT_F.byte;
; 0000 1556 
; 0000 1557      while(1)
_0x27B:
; 0000 1558         {
; 0000 1559         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x33
; 0000 155A         komunikat_na_panel("Kolizja krazka - wylacz i wlacz maszyne",adr1,adr2);
	__POINTW1FN _0x0,1905
	CALL SUBOPT_0x34
; 0000 155B         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x88
; 0000 155C         komunikat_na_panel("Kolizja krazka - wylacz i wlacz maszyne",adr3,adr4);
	__POINTW1FN _0x0,1905
	CALL SUBOPT_0x89
; 0000 155D         }
	RJMP _0x27B
; 0000 155E      }
; 0000 155F if(start == 1)
_0x274:
	CALL SUBOPT_0xBC
	SBIW R26,1
	BRNE _0x27E
; 0000 1560     {
; 0000 1561     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xBF
; 0000 1562     obsluga_nacisniecia_zatrzymaj();
; 0000 1563 
; 0000 1564     }
; 0000 1565 switch(cykl_sterownik_3)
_0x27E:
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
; 0000 1566         {
; 0000 1567         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x282
; 0000 1568 
; 0000 1569             PORT_STER3.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER3,R30
; 0000 156A             PORT_F.bits.b0 = PORT_STER3.bits.b0;
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0xC6
; 0000 156B             PORT_F.bits.b1 = PORT_STER3.bits.b1;
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFD
	CALL SUBOPT_0xC6
; 0000 156C             PORT_F.bits.b2 = PORT_STER3.bits.b2;
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFB
	CALL SUBOPT_0xC6
; 0000 156D             PORT_F.bits.b3 = PORT_STER3.bits.b3;
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
	CALL SUBOPT_0xC6
; 0000 156E             PORT_F.bits.b7 = PORT_STER3.bits.b4;
	SWAP R30
	ANDI R30,LOW(0x1)
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0x7F
	OR   R30,R0
	CALL SUBOPT_0xC7
; 0000 156F             PORTF = PORT_F.byte;
; 0000 1570             PORTB.7 = PORT_STER3.bits.b5;
	LDS  R30,_PORT_STER3
	ANDI R30,LOW(0x20)
	BRNE _0x283
	CBI  0x18,7
	RJMP _0x284
_0x283:
	SBI  0x18,7
_0x284:
; 0000 1571 
; 0000 1572 
; 0000 1573 
; 0000 1574             sek2 = 0;
	CALL SUBOPT_0xC8
; 0000 1575             cykl_sterownik_3 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0xC9
; 0000 1576 
; 0000 1577 
; 0000 1578 
; 0000 1579         break;
	RJMP _0x281
; 0000 157A 
; 0000 157B         case 1:
_0x282:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x285
; 0000 157C 
; 0000 157D 
; 0000 157E             if(sek2 > 1)
	LDS  R26,_sek2
	LDS  R27,_sek2+1
	LDS  R24,_sek2+2
	LDS  R25,_sek2+3
	CALL SUBOPT_0xC1
	BRLT _0x286
; 0000 157F                 {
; 0000 1580 
; 0000 1581                 PORT_F.bits.b5 = 1;
	LDS  R30,_PORT_F
	ORI  R30,0x20
	CALL SUBOPT_0xC7
; 0000 1582                 PORTF = PORT_F.byte;
; 0000 1583                 cykl_sterownik_3 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xC9
; 0000 1584                 }
; 0000 1585         break;
_0x286:
	RJMP _0x281
; 0000 1586 
; 0000 1587 
; 0000 1588         case 2:
_0x285:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x287
; 0000 1589 
; 0000 158A 
; 0000 158B                if(sprawdz_pin0(PORTKK,0x75) == 0)
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x288
; 0000 158C                   {
; 0000 158D                   PORT_F.bits.b5 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xDF
	CALL SUBOPT_0xC7
; 0000 158E                   PORTF = PORT_F.byte;
; 0000 158F 
; 0000 1590                   PORT_F.bits.b0 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0xCB
; 0000 1591                   PORT_F.bits.b1 = 0;
	ANDI R30,0xFD
	CALL SUBOPT_0xCB
; 0000 1592                   PORT_F.bits.b2 = 0;
	ANDI R30,0xFB
	CALL SUBOPT_0xCB
; 0000 1593                   PORT_F.bits.b3 = 0;
	ANDI R30,0XF7
	CALL SUBOPT_0xCB
; 0000 1594                   PORT_F.bits.b7 = 0;
	ANDI R30,0x7F
	CALL SUBOPT_0xC7
; 0000 1595                   PORTF = PORT_F.byte;
; 0000 1596                   PORTB.7 = 0;
	CBI  0x18,7
; 0000 1597 
; 0000 1598                   sek2 = 0;
	CALL SUBOPT_0xC8
; 0000 1599                   cykl_sterownik_3 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xC9
; 0000 159A                   }
; 0000 159B 
; 0000 159C         break;
_0x288:
	RJMP _0x281
; 0000 159D 
; 0000 159E         case 3:
_0x287:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x28B
; 0000 159F 
; 0000 15A0 
; 0000 15A1                if(sprawdz_pin3(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x28C
; 0000 15A2                   {
; 0000 15A3                   sek2 = 0;
	CALL SUBOPT_0xC8
; 0000 15A4                   cykl_sterownik_3 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xC9
; 0000 15A5                   }
; 0000 15A6 
; 0000 15A7 
; 0000 15A8         break;
_0x28C:
	RJMP _0x281
; 0000 15A9 
; 0000 15AA 
; 0000 15AB         case 4:
_0x28B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x281
; 0000 15AC 
; 0000 15AD               if(sprawdz_pin0(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x28E
; 0000 15AE                 {
; 0000 15AF                 cykl_sterownik_3 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0xC9
; 0000 15B0 
; 0000 15B1 
; 0000 15B2                 switch(cykl_sterownik_3_wykonalem)
	LDS  R30,_cykl_sterownik_3_wykonalem
	LDS  R31,_cykl_sterownik_3_wykonalem+1
; 0000 15B3                     {
; 0000 15B4                     case 0:
	SBIW R30,0
	BRNE _0x292
; 0000 15B5                             cykl_sterownik_3_wykonalem = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R31
; 0000 15B6                     break;
	RJMP _0x291
; 0000 15B7 
; 0000 15B8                     case 1:
_0x292:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x291
; 0000 15B9                             cykl_sterownik_3_wykonalem = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R30
; 0000 15BA                     break;
; 0000 15BB 
; 0000 15BC                     }
_0x291:
; 0000 15BD 
; 0000 15BE 
; 0000 15BF                 }
; 0000 15C0         break;
_0x28E:
; 0000 15C1 
; 0000 15C2         }
_0x281:
; 0000 15C3 
; 0000 15C4 return cykl_sterownik_3;
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
_0x20A0001:
	ADIW R28,2
	RET
; 0000 15C5 }
;
;//
;//int sterownik_4_praca(char f,char e,char d, char c, char b, char a)
;int sterownik_4_praca(int PORT,int p)
; 0000 15CA {
_sterownik_4_praca:
; 0000 15CB 
; 0000 15CC 
; 0000 15CD //PORTB.0   IN0  STEROWNIK4
; 0000 15CE //PORTB.1   IN1  STEROWNIK4
; 0000 15CF //PORTB.2   IN2  STEROWNIK4
; 0000 15D0 //PORTB.3   IN3  STEROWNIK4
; 0000 15D1 //PORTE.4  IN4  STEROWNIK4
; 0000 15D2 
; 0000 15D3 
; 0000 15D4 
; 0000 15D5 //PORTB.4   SETUP  STEROWNIK4
; 0000 15D6 //PORTB.5   DRIVE  STEROWNIK4
; 0000 15D7 
; 0000 15D8 //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 15D9 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 15DA 
; 0000 15DB if(sprawdz_pin6(PORTMM,0x77) == 1)
;	PORT -> Y+2
;	p -> Y+0
	CALL SUBOPT_0xC5
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x294
; 0000 15DC     {
; 0000 15DD     PORTD.7 = 1;
	CALL SUBOPT_0xBE
; 0000 15DE     PORTE.2 = 0;
; 0000 15DF     PORTE.3 = 0;
; 0000 15E0     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 15E1     PORTF = PORT_F.byte;
; 0000 15E2 
; 0000 15E3     while(1)
_0x29B:
; 0000 15E4         {
; 0000 15E5         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x33
; 0000 15E6         komunikat_na_panel("Kolizja szcz. drucianej - wylacz i wlacz maszyne",adr1,adr2);
	__POINTW1FN _0x0,1945
	CALL SUBOPT_0x34
; 0000 15E7         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x88
; 0000 15E8         komunikat_na_panel("Kolizja szcz. drucianej - wylacz i wlacz maszyne",adr3,adr4);
	__POINTW1FN _0x0,1945
	CALL SUBOPT_0x89
; 0000 15E9         }
	RJMP _0x29B
; 0000 15EA 
; 0000 15EB     }
; 0000 15EC if(start == 1)
_0x294:
	CALL SUBOPT_0xBC
	SBIW R26,1
	BRNE _0x29E
; 0000 15ED     {
; 0000 15EE     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xBF
; 0000 15EF     obsluga_nacisniecia_zatrzymaj();
; 0000 15F0     }
; 0000 15F1 switch(cykl_sterownik_4)
_0x29E:
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
; 0000 15F2         {
; 0000 15F3         case 0:
	SBIW R30,0
	BRNE _0x2A2
; 0000 15F4 
; 0000 15F5             PORT_STER4.byte = PORT;
	LDD  R30,Y+2
	STS  _PORT_STER4,R30
; 0000 15F6             PORTB.0 = PORT_STER4.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x2A3
	CBI  0x18,0
	RJMP _0x2A4
_0x2A3:
	SBI  0x18,0
_0x2A4:
; 0000 15F7             PORTB.1 = PORT_STER4.bits.b1;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x2)
	BRNE _0x2A5
	CBI  0x18,1
	RJMP _0x2A6
_0x2A5:
	SBI  0x18,1
_0x2A6:
; 0000 15F8             PORTB.2 = PORT_STER4.bits.b2;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x4)
	BRNE _0x2A7
	CBI  0x18,2
	RJMP _0x2A8
_0x2A7:
	SBI  0x18,2
_0x2A8:
; 0000 15F9             PORTB.3 = PORT_STER4.bits.b3;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x8)
	BRNE _0x2A9
	CBI  0x18,3
	RJMP _0x2AA
_0x2A9:
	SBI  0x18,3
_0x2AA:
; 0000 15FA             PORTE.4 = PORT_STER4.bits.b4;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x10)
	BRNE _0x2AB
	CBI  0x3,4
	RJMP _0x2AC
_0x2AB:
	SBI  0x3,4
_0x2AC:
; 0000 15FB 
; 0000 15FC 
; 0000 15FD             sek4 = 0;
	CALL SUBOPT_0xCC
; 0000 15FE             cykl_sterownik_4 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x541
; 0000 15FF 
; 0000 1600         break;
; 0000 1601 
; 0000 1602         case 1:
_0x2A2:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2AD
; 0000 1603 
; 0000 1604             if(sek4 > 1)
	LDS  R26,_sek4
	LDS  R27,_sek4+1
	LDS  R24,_sek4+2
	LDS  R25,_sek4+3
	CALL SUBOPT_0xC1
	BRLT _0x2AE
; 0000 1605                 {
; 0000 1606                 PORTB.5 = 1;
	SBI  0x18,5
; 0000 1607                 cykl_sterownik_4 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xCD
; 0000 1608                 }
; 0000 1609         break;
_0x2AE:
	RJMP _0x2A1
; 0000 160A 
; 0000 160B 
; 0000 160C         case 2:
_0x2AD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2B1
; 0000 160D 
; 0000 160E                if(sprawdz_pin4(PORTKK,0x75) == 0)
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin4
	CPI  R30,0
	BRNE _0x2B2
; 0000 160F                   {
; 0000 1610                   PORTB.5 = 0;  //drive
	CBI  0x18,5
; 0000 1611 
; 0000 1612                   PORTB.0 = 0;
	CBI  0x18,0
; 0000 1613                   PORTB.1 = 0;
	CBI  0x18,1
; 0000 1614                   PORTB.2 = 0;
	CBI  0x18,2
; 0000 1615                   PORTB.3 = 0;
	CBI  0x18,3
; 0000 1616                   PORTE.4 = 0;
	CBI  0x3,4
; 0000 1617 
; 0000 1618 
; 0000 1619                   sek4 = 0;
	CALL SUBOPT_0xCC
; 0000 161A                   cykl_sterownik_4 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xCD
; 0000 161B                   }
; 0000 161C 
; 0000 161D         break;
_0x2B2:
	RJMP _0x2A1
; 0000 161E 
; 0000 161F         case 3:
_0x2B1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2BF
; 0000 1620 
; 0000 1621                if(sprawdz_pin7(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x2C0
; 0000 1622                   {
; 0000 1623                   //if(p == 1)
; 0000 1624                   //  PORTE.2 = 1;  //wylaczam do testu
; 0000 1625 
; 0000 1626                   sek4 = 0;
	CALL SUBOPT_0xCC
; 0000 1627                   cykl_sterownik_4 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xCD
; 0000 1628                   }
; 0000 1629 
; 0000 162A 
; 0000 162B         break;
_0x2C0:
	RJMP _0x2A1
; 0000 162C 
; 0000 162D 
; 0000 162E         case 4:
_0x2BF:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2A1
; 0000 162F 
; 0000 1630               if(sprawdz_pin4(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin4
	CPI  R30,LOW(0x1)
	BRNE _0x2C2
; 0000 1631                 {
; 0000 1632                 cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x541:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
; 0000 1633                 }
; 0000 1634         break;
_0x2C2:
; 0000 1635 
; 0000 1636         }
_0x2A1:
; 0000 1637 
; 0000 1638 return cykl_sterownik_4;
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
	ADIW R28,4
	RET
; 0000 1639 }
;
;
;void test_geometryczny()
; 0000 163D {
; 0000 163E int cykl_testu,d;
; 0000 163F int ff[12];
; 0000 1640 int i;
; 0000 1641 d = 0;
;	cykl_testu -> R16,R17
;	d -> R18,R19
;	ff -> Y+6
;	i -> R20,R21
; 0000 1642 cykl_testu = 0;
; 0000 1643 
; 0000 1644 for(i=0;i<11;i++)
; 0000 1645      ff[i]=0;
; 0000 1648 manualny_wybor_zacisku = 145;
; 0000 1649 manualny_wybor_zacisku = odczytaj_parametr(48,128);
; 0000 164A 
; 0000 164B if(manualny_wybor_zacisku != 145)
; 0000 164C     {
; 0000 164D     macierz_zaciskow[1] = manualny_wybor_zacisku;
; 0000 164E     macierz_zaciskow[2] = manualny_wybor_zacisku;
; 0000 164F     }
; 0000 1650 
; 0000 1651                                                                    //swiatlo czer       //swiatlo zolte
; 0000 1652 if(test_geometryczny_rzad_1 == 1 & test_geometryczny_rzad_2 == 0 & PORTD.7 == 0  & PORT_F.bits.b6 == 0 &
; 0000 1653     il_zaciskow_rzad_1 > 1 & macierz_zaciskow[1]!=0 & sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
; 0000 1654     {
; 0000 1655     while(test_geometryczny_rzad_1 == 1)
; 0000 1656         {
; 0000 1657         switch(cykl_testu)
; 0000 1658             {
; 0000 1659              case 0:
; 0000 165A 
; 0000 165B                wybor_linijek_sterownikow(1);
; 0000 165C                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 165D                cykl_sterownik_1 = 0;
; 0000 165E                cykl_sterownik_2 = 0;
; 0000 165F                cykl_sterownik_3 = 0;
; 0000 1660                cykl_sterownik_4 = 0;
; 0000 1661                wybor_linijek_sterownikow(1);
; 0000 1662                cykl_testu = 1;
; 0000 1663 
; 0000 1664 
; 0000 1665 
; 0000 1666             break;
; 0000 1667 
; 0000 1668             case 1:
; 0000 1669 
; 0000 166A             //na sam dol zjezdzamy pionami
; 0000 166B                 if(cykl_sterownik_3 < 5)
; 0000 166C                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
; 0000 166D                 if(cykl_sterownik_4 < 5)
; 0000 166E                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
; 0000 166F 
; 0000 1670                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
; 0000 1671                                         {
; 0000 1672                                         cykl_sterownik_3 = 0;
; 0000 1673                                         cykl_sterownik_4 = 0;
; 0000 1674                                         cykl_testu = 2;
; 0000 1675                                         }
; 0000 1676 
; 0000 1677 
; 0000 1678 
; 0000 1679             break;
; 0000 167A 
; 0000 167B 
; 0000 167C             case 2:
; 0000 167D 
; 0000 167E                                 if(cykl_sterownik_1 < 5)
; 0000 167F                                     cykl_sterownik_1 = sterownik_1_praca(0x000);
; 0000 1680                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy
; 0000 1681                                     cykl_sterownik_2 = sterownik_2_praca(0x008);       //ster 2 ucieczka do zera (druciak)
; 0000 1682 
; 0000 1683                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
; 0000 1684                                         {
; 0000 1685                                         cykl_sterownik_1 = 0;
; 0000 1686                                         cykl_sterownik_2 = 0;
; 0000 1687                                         cykl_sterownik_3 = 0;
; 0000 1688                                         cykl_sterownik_4 = 0;
; 0000 1689                                         cykl_testu = 3;
; 0000 168A 
; 0000 168B                                         }
; 0000 168C 
; 0000 168D             break;
; 0000 168E 
; 0000 168F 
; 0000 1690             case 3:
; 0000 1691 
; 0000 1692                                 if(cykl_sterownik_1 < 5)
; 0000 1693                                     cykl_sterownik_1 = sterownik_1_praca(a[0]); //ster 1 pod srodek zacisku
; 0000 1694 
; 0000 1695                                     if(cykl_sterownik_1 == 5)
; 0000 1696                                         {
; 0000 1697                                         cykl_sterownik_1 = 0;
; 0000 1698                                         cykl_sterownik_2 = 0;
; 0000 1699                                         cykl_sterownik_3 = 0;
; 0000 169A                                         cykl_sterownik_4 = 0;
; 0000 169B                                         cykl_testu = 4;
; 0000 169C                                         }
; 0000 169D 
; 0000 169E             break;
; 0000 169F 
; 0000 16A0             case 4:
; 0000 16A1 
; 0000 16A2                                    if(cykl_sterownik_3 < 5)
; 0000 16A3                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
; 0000 16A4 
; 0000 16A5                                    if(cykl_sterownik_3 == 5)
; 0000 16A6                                         {
; 0000 16A7                                         cykl_sterownik_1 = 0;
; 0000 16A8                                         cykl_sterownik_2 = 0;
; 0000 16A9                                         cykl_sterownik_3 = 0;
; 0000 16AA                                         cykl_sterownik_4 = 0;
; 0000 16AB                                         cykl_testu = 5;
; 0000 16AC                                         }
; 0000 16AD 
; 0000 16AE             break;
; 0000 16AF 
; 0000 16B0             case 5:
; 0000 16B1                                    if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
; 0000 16B2                                    {
; 0000 16B3                                      d = odczytaj_parametr(48,80);
; 0000 16B4                                         if(d == 0)
; 0000 16B5                                             cykl_testu = 666;
; 0000 16B6 
; 0000 16B7                                         if(d == 2 & ff[2] == 0)
; 0000 16B8                                             {
; 0000 16B9                                             cykl_testu = 6;
; 0000 16BA                                             ff[d]=1;
; 0000 16BB                                             }
; 0000 16BC                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
; 0000 16BD                                             {
; 0000 16BE                                             cykl_testu = 6;
; 0000 16BF                                             ff[d]=1;
; 0000 16C0                                             }
; 0000 16C1                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
; 0000 16C2                                             {
; 0000 16C3                                             cykl_testu = 6;
; 0000 16C4                                             ff[d]=1;
; 0000 16C5                                             }
; 0000 16C6                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
; 0000 16C7                                             {
; 0000 16C8                                             cykl_testu = 6;
; 0000 16C9                                             ff[d]=1;
; 0000 16CA                                             }
; 0000 16CB                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
; 0000 16CC                                             {
; 0000 16CD                                             cykl_testu = 6;
; 0000 16CE                                             ff[d]=1;
; 0000 16CF                                             }
; 0000 16D0                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
; 0000 16D1                                             {
; 0000 16D2                                             cykl_testu = 6;
; 0000 16D3                                             ff[d]=1;
; 0000 16D4                                             }
; 0000 16D5                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
; 0000 16D6                                             {
; 0000 16D7                                             cykl_testu = 6;
; 0000 16D8                                             ff[d]=1;
; 0000 16D9                                             }
; 0000 16DA                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
; 0000 16DB                                             {
; 0000 16DC                                             cykl_testu = 6;
; 0000 16DD                                             ff[d]=1;
; 0000 16DE                                             }
; 0000 16DF                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
; 0000 16E0                                             {
; 0000 16E1                                             cykl_testu = 6;
; 0000 16E2                                             ff[d]=1;
; 0000 16E3                                             }
; 0000 16E4                                     }
; 0000 16E5 
; 0000 16E6             break;
; 0000 16E7 
; 0000 16E8             case 6:
; 0000 16E9                                      if(cykl_sterownik_3 < 5)
; 0000 16EA                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
; 0000 16EB                                         if(cykl_sterownik_3 == 5)
; 0000 16EC                                             {
; 0000 16ED                                             cykl_sterownik_1 = 0;
; 0000 16EE                                             cykl_sterownik_2 = 0;
; 0000 16EF                                             cykl_sterownik_3 = 0;
; 0000 16F0                                             cykl_sterownik_4 = 0;
; 0000 16F1                                             cykl_testu = 7;
; 0000 16F2                                             }
; 0000 16F3 
; 0000 16F4             break;
; 0000 16F5 
; 0000 16F6             case 7:
; 0000 16F7 
; 0000 16F8                                     if(cykl_sterownik_1 < 5)
; 0000 16F9                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
; 0000 16FA 
; 0000 16FB                                     if(cykl_sterownik_1 == 5)
; 0000 16FC                                         {
; 0000 16FD                                         cykl_sterownik_1 = 0;
; 0000 16FE                                         cykl_sterownik_2 = 0;
; 0000 16FF                                         cykl_sterownik_3 = 0;
; 0000 1700                                         cykl_sterownik_4 = 0;
; 0000 1701                                         cykl_testu = 4;
; 0000 1702                                         }
; 0000 1703 
; 0000 1704 
; 0000 1705             break;
; 0000 1706 
; 0000 1707 
; 0000 1708 
; 0000 1709 
; 0000 170A 
; 0000 170B 
; 0000 170C 
; 0000 170D             case 666:
; 0000 170E 
; 0000 170F                                         if(cykl_sterownik_3 < 5)
; 0000 1710                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
; 0000 1711                                         if(cykl_sterownik_3 == 5)
; 0000 1712                                             {
; 0000 1713                                             cykl_sterownik_3 = 0;
; 0000 1714                                             cykl_sterownik_4 = 0;
; 0000 1715                                             cykl_testu = 100;
; 0000 1716                                             test_geometryczny_rzad_1 = 0;
; 0000 1717                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 1718                                             }
; 0000 1719 
; 0000 171A             break;
; 0000 171B 
; 0000 171C 
; 0000 171D 
; 0000 171E             }
; 0000 171F 
; 0000 1720         }
; 0000 1721     }
; 0000 1722 
; 0000 1723 
; 0000 1724 
; 0000 1725                                                                    //swiatlo czer       //swiatlo zolte
; 0000 1726 if(test_geometryczny_rzad_1 == 0 & test_geometryczny_rzad_2 == 1 & PORTD.7 == 0  & PORT_F.bits.b6 == 0 &
; 0000 1727     il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0 & sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
; 0000 1728     {
; 0000 1729     while(test_geometryczny_rzad_2 == 1)
; 0000 172A         {
; 0000 172B         switch(cykl_testu)
; 0000 172C             {
; 0000 172D              case 0:
; 0000 172E 
; 0000 172F                wybor_linijek_sterownikow(2);
; 0000 1730                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1731                cykl_sterownik_1 = 0;
; 0000 1732                cykl_sterownik_2 = 0;
; 0000 1733                cykl_sterownik_3 = 0;
; 0000 1734                cykl_sterownik_4 = 0;
; 0000 1735                wybor_linijek_sterownikow(2);
; 0000 1736                cykl_testu = 1;
; 0000 1737 
; 0000 1738 
; 0000 1739 
; 0000 173A             break;
; 0000 173B 
; 0000 173C             case 1:
; 0000 173D 
; 0000 173E             //na sam dol zjezdzamy pionami
; 0000 173F                 if(cykl_sterownik_3 < 5)
; 0000 1740                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
; 0000 1741                 if(cykl_sterownik_4 < 5)
; 0000 1742                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
; 0000 1743 
; 0000 1744                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
; 0000 1745                                         {
; 0000 1746                                         cykl_sterownik_3 = 0;
; 0000 1747                                         cykl_sterownik_4 = 0;
; 0000 1748                                         cykl_testu = 2;
; 0000 1749                                         }
; 0000 174A 
; 0000 174B 
; 0000 174C 
; 0000 174D             break;
; 0000 174E 
; 0000 174F 
; 0000 1750             case 2:
; 0000 1751 
; 0000 1752                                 if(cykl_sterownik_1 < 5)
; 0000 1753                                     cykl_sterownik_1 = sterownik_1_praca(0x001);
; 0000 1754                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy rzad 2
; 0000 1755                                     cykl_sterownik_2 = sterownik_2_praca(0x009);       //ster 2 ucieczka dla II rzedu (druciak)
; 0000 1756 
; 0000 1757                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
; 0000 1758                                         {
; 0000 1759                                         cykl_sterownik_1 = 0;
; 0000 175A                                         cykl_sterownik_2 = 0;
; 0000 175B                                         cykl_sterownik_3 = 0;
; 0000 175C                                         cykl_sterownik_4 = 0;
; 0000 175D                                         cykl_testu = 3;
; 0000 175E 
; 0000 175F                                         }
; 0000 1760 
; 0000 1761             break;
; 0000 1762 
; 0000 1763 
; 0000 1764             case 3:
; 0000 1765 
; 0000 1766                                 if(cykl_sterownik_1 < 5)
; 0000 1767                                     cykl_sterownik_1 = sterownik_1_praca(a[1]); //ster 1 pod srodek zacisku
; 0000 1768 
; 0000 1769                                     if(cykl_sterownik_1 == 5)
; 0000 176A                                         {
; 0000 176B                                         cykl_sterownik_1 = 0;
; 0000 176C                                         cykl_sterownik_2 = 0;
; 0000 176D                                         cykl_sterownik_3 = 0;
; 0000 176E                                         cykl_sterownik_4 = 0;
; 0000 176F                                         cykl_testu = 4;
; 0000 1770                                         }
; 0000 1771 
; 0000 1772             break;
; 0000 1773 
; 0000 1774             case 4:
; 0000 1775 
; 0000 1776                                    if(cykl_sterownik_3 < 5)
; 0000 1777                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
; 0000 1778 
; 0000 1779                                    if(cykl_sterownik_3 == 5)
; 0000 177A                                         {
; 0000 177B                                         cykl_sterownik_1 = 0;
; 0000 177C                                         cykl_sterownik_2 = 0;
; 0000 177D                                         cykl_sterownik_3 = 0;
; 0000 177E                                         cykl_sterownik_4 = 0;
; 0000 177F                                         cykl_testu = 5;
; 0000 1780                                         }
; 0000 1781 
; 0000 1782             break;
; 0000 1783 
; 0000 1784             case 5:
; 0000 1785                                      if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
; 0000 1786                                      {
; 0000 1787                                      d = odczytaj_parametr(48,96);
; 0000 1788                                         if(d == 0)
; 0000 1789                                             cykl_testu = 666;
; 0000 178A 
; 0000 178B 
; 0000 178C 
; 0000 178D 
; 0000 178E                                         if(d == 2 & ff[2] == 0)
; 0000 178F                                             {
; 0000 1790                                             cykl_testu = 6;
; 0000 1791                                             ff[d]=1;
; 0000 1792                                             }
; 0000 1793                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
; 0000 1794                                             {
; 0000 1795                                             cykl_testu = 6;
; 0000 1796                                             ff[d]=1;
; 0000 1797                                             }
; 0000 1798                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
; 0000 1799                                             {
; 0000 179A                                             cykl_testu = 6;
; 0000 179B                                             ff[d]=1;
; 0000 179C                                             }
; 0000 179D                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
; 0000 179E                                             {
; 0000 179F                                             cykl_testu = 6;
; 0000 17A0                                             ff[d]=1;
; 0000 17A1                                             }
; 0000 17A2                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
; 0000 17A3                                             {
; 0000 17A4                                             cykl_testu = 6;
; 0000 17A5                                             ff[d]=1;
; 0000 17A6                                             }
; 0000 17A7                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
; 0000 17A8                                             {
; 0000 17A9                                             cykl_testu = 6;
; 0000 17AA                                             ff[d]=1;
; 0000 17AB                                             }
; 0000 17AC                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
; 0000 17AD                                             {
; 0000 17AE                                             cykl_testu = 6;
; 0000 17AF                                             ff[d]=1;
; 0000 17B0                                             }
; 0000 17B1                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
; 0000 17B2                                             {
; 0000 17B3                                             cykl_testu = 6;
; 0000 17B4                                             ff[d]=1;
; 0000 17B5                                             }
; 0000 17B6                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
; 0000 17B7                                             {
; 0000 17B8                                             cykl_testu = 6;
; 0000 17B9                                             ff[d]=1;
; 0000 17BA                                             }
; 0000 17BB 
; 0000 17BC                                       }
; 0000 17BD             break;
; 0000 17BE 
; 0000 17BF             case 6:
; 0000 17C0                                      if(cykl_sterownik_3 < 5)
; 0000 17C1                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
; 0000 17C2                                         if(cykl_sterownik_3 == 5)
; 0000 17C3                                             {
; 0000 17C4                                             cykl_sterownik_1 = 0;
; 0000 17C5                                             cykl_sterownik_2 = 0;
; 0000 17C6                                             cykl_sterownik_3 = 0;
; 0000 17C7                                             cykl_sterownik_4 = 0;
; 0000 17C8                                             cykl_testu = 7;
; 0000 17C9                                             }
; 0000 17CA 
; 0000 17CB             break;
; 0000 17CC 
; 0000 17CD             case 7:
; 0000 17CE 
; 0000 17CF                                     if(cykl_sterownik_1 < 5)
; 0000 17D0                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
; 0000 17D1 
; 0000 17D2                                     if(cykl_sterownik_1 == 5)
; 0000 17D3                                         {
; 0000 17D4                                         cykl_sterownik_1 = 0;
; 0000 17D5                                         cykl_sterownik_2 = 0;
; 0000 17D6                                         cykl_sterownik_3 = 0;
; 0000 17D7                                         cykl_sterownik_4 = 0;
; 0000 17D8                                         cykl_testu = 4;
; 0000 17D9                                         }
; 0000 17DA 
; 0000 17DB 
; 0000 17DC             break;
; 0000 17DD 
; 0000 17DE 
; 0000 17DF 
; 0000 17E0             case 666:
; 0000 17E1 
; 0000 17E2                                         if(cykl_sterownik_3 < 5)
; 0000 17E3                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
; 0000 17E4                                         if(cykl_sterownik_3 == 5)
; 0000 17E5                                             {
; 0000 17E6                                             cykl_sterownik_3 = 0;
; 0000 17E7                                             cykl_sterownik_4 = 0;
; 0000 17E8                                             cykl_testu = 100;
; 0000 17E9                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 17EA                                             test_geometryczny_rzad_2 = 0;
; 0000 17EB                                             }
; 0000 17EC 
; 0000 17ED             break;
; 0000 17EE 
; 0000 17EF 
; 0000 17F0 
; 0000 17F1             }
; 0000 17F2 
; 0000 17F3         }
; 0000 17F4     }
; 0000 17F5 
; 0000 17F6 
; 0000 17F7 
; 0000 17F8 
; 0000 17F9 }
;
;
;
;
;
;void kontrola_zoltego_swiatla()
; 0000 1800 {
; 0000 1801 
; 0000 1802 
; 0000 1803 if(czas_pracy_szczotki_drucianej_h >= czas_pracy_szczotki_drucianej_stala)
; 0000 1804      {
; 0000 1805      PORT_F.bits.b6 = 1;
; 0000 1806      PORTF = PORT_F.byte;
; 0000 1807      komunikat_na_panel("                                                ",80,0);
; 0000 1808      komunikat_na_panel("Wymien szczotke druciana",80,0);
; 0000 1809      }
; 0000 180A 
; 0000 180B if(czas_pracy_krazka_sciernego_h_34 >= czas_pracy_krazka_sciernego_stala)
; 0000 180C      {
; 0000 180D      PORT_F.bits.b6 = 1;
; 0000 180E      PORTF = PORT_F.byte;
; 0000 180F      komunikat_na_panel("                                                ",64,0);
; 0000 1810      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 34",64,0);
; 0000 1811      }
; 0000 1812 
; 0000 1813 if(czas_pracy_krazka_sciernego_h_36 >= czas_pracy_krazka_sciernego_stala)
; 0000 1814      {
; 0000 1815      PORT_F.bits.b6 = 1;
; 0000 1816      PORTF = PORT_F.byte;
; 0000 1817      komunikat_na_panel("                                                ",64,0);
; 0000 1818      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 36",64,0);
; 0000 1819      }
; 0000 181A 
; 0000 181B if(czas_pracy_krazka_sciernego_h_38 >= czas_pracy_krazka_sciernego_stala)
; 0000 181C      {
; 0000 181D      PORT_F.bits.b6 = 1;
; 0000 181E      PORTF = PORT_F.byte;
; 0000 181F      komunikat_na_panel("                                                ",64,0);
; 0000 1820      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 38",64,0);
; 0000 1821      }
; 0000 1822 
; 0000 1823 if(czas_pracy_krazka_sciernego_h_41 >= czas_pracy_krazka_sciernego_stala)
; 0000 1824      {
; 0000 1825      PORT_F.bits.b6 = 1;
; 0000 1826      PORTF = PORT_F.byte;
; 0000 1827      komunikat_na_panel("                                                ",64,0);
; 0000 1828      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 41",64,0);
; 0000 1829      }
; 0000 182A 
; 0000 182B if(czas_pracy_krazka_sciernego_h_43 >= czas_pracy_krazka_sciernego_stala)
; 0000 182C      {
; 0000 182D      PORT_F.bits.b6 = 1;
; 0000 182E      PORTF = PORT_F.byte;
; 0000 182F      komunikat_na_panel("                                                ",64,0);
; 0000 1830      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 43",64,0);
; 0000 1831      }
; 0000 1832 
; 0000 1833 
; 0000 1834 
; 0000 1835 }
;
;void wymiana_szczotki_i_krazka()
; 0000 1838 {
; 0000 1839 int g,e,f,d,cykl_wymiany;
; 0000 183A cykl_wymiany = 0;
;	g -> R16,R17
;	e -> R18,R19
;	f -> R20,R21
;	d -> Y+8
;	cykl_wymiany -> Y+6
; 0000 183B                       //30 //20
; 0000 183C 
; 0000 183D if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
; 0000 183E {
; 0000 183F g = odczytaj_parametr(48,32);  //szczotka druciana
; 0000 1840                     //30  //30
; 0000 1841 f = odczytaj_parametr(48,48);  //krazek scierny
; 0000 1842 }
; 0000 1843 
; 0000 1844 while(g == 1)
; 0000 1845     {
; 0000 1846     switch(cykl_wymiany)
; 0000 1847     {
; 0000 1848     case 0:
; 0000 1849 
; 0000 184A                cykl_sterownik_1 = 0;
; 0000 184B                cykl_sterownik_2 = 0;
; 0000 184C                cykl_sterownik_3 = 0;
; 0000 184D                cykl_sterownik_4 = 0;
; 0000 184E                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 184F                cykl_wymiany = 1;
; 0000 1850 
; 0000 1851 
; 0000 1852 
; 0000 1853     break;
; 0000 1854 
; 0000 1855     case 1:
; 0000 1856 
; 0000 1857             //na sam dol zjezdzamy pionami
; 0000 1858                 if(cykl_sterownik_3 < 5)
; 0000 1859                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
; 0000 185A                 if(cykl_sterownik_4 < 5)
; 0000 185B                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
; 0000 185C 
; 0000 185D                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
; 0000 185E 
; 0000 185F                             {
; 0000 1860                                         cykl_sterownik_3 = 0;
; 0000 1861                                         cykl_sterownik_4 = 0;
; 0000 1862                                         cykl_wymiany = 2;
; 0000 1863                                         }
; 0000 1864 
; 0000 1865 
; 0000 1866 
; 0000 1867     break;
; 0000 1868 
; 0000 1869 
; 0000 186A 
; 0000 186B     case 2:
; 0000 186C 
; 0000 186D                                 if(cykl_sterownik_1 < 5)
; 0000 186E                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
; 0000 186F                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
; 0000 1870                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
; 0000 1871 
; 0000 1872                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
; 0000 1873                                         {
; 0000 1874                                         cykl_sterownik_1 = 0;
; 0000 1875                                         cykl_sterownik_2 = 0;
; 0000 1876                                         cykl_sterownik_3 = 0;
; 0000 1877                                         cykl_sterownik_4 = 0;
; 0000 1878                                          cykl_wymiany = 3;
; 0000 1879 
; 0000 187A                                         }
; 0000 187B 
; 0000 187C     break;
; 0000 187D 
; 0000 187E 
; 0000 187F 
; 0000 1880     case 3:
; 0000 1881 
; 0000 1882             //na sam dol zjezdzamy pionami
; 0000 1883                 if(cykl_sterownik_3 < 5)
; 0000 1884                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
; 0000 1885                 if(cykl_sterownik_4 < 5)
; 0000 1886                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
; 0000 1887 
; 0000 1888                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
; 0000 1889 
; 0000 188A                             {
; 0000 188B                                         cykl_sterownik_3 = 0;
; 0000 188C                                         cykl_sterownik_4 = 0;
; 0000 188D                                         d = odczytaj_parametr(48,32);
; 0000 188E 
; 0000 188F                                         switch (d)
; 0000 1890                                         {
; 0000 1891                                         case 0:
; 0000 1892 
; 0000 1893                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
; 0000 1894                                                 {
; 0000 1895                                                 cykl_wymiany = 4;
; 0000 1896                                                 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1897                                                 }
; 0000 1898                                              //jednak nie wymianiamy
; 0000 1899 
; 0000 189A                                         break;
; 0000 189B 
; 0000 189C                                         case 1:
; 0000 189D                                              cykl_wymiany = 3;
; 0000 189E                                              PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 189F                                              //czekam z decyzja - w trakcie wymiany
; 0000 18A0                                         break;
; 0000 18A1 
; 0000 18A2                                         case 2:
; 0000 18A3 
; 0000 18A4 
; 0000 18A5 
; 0000 18A6                                              PORT_F.bits.b6 = 0;   //zgas lampke
; 0000 18A7                                              PORTF = PORT_F.byte;
; 0000 18A8 
; 0000 18A9                                              czas_pracy_szczotki_drucianej_h = 0;
; 0000 18AA                                              wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
; 0000 18AB                                              wartosc_parametru_panelu_stala_pamiec(0,96,0,144);
; 0000 18AC                                              delay_ms(200);
; 0000 18AD                                              odczyt_parametru_panelu_stala_pamiec(0,96,0,144);
; 0000 18AE                                              delay_ms(200);
; 0000 18AF 
; 0000 18B0                                              komunikat_na_panel("                                                ",80,0);
; 0000 18B1 
; 0000 18B2                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
; 0000 18B3                                                 {
; 0000 18B4                                                 cykl_wymiany = 4;
; 0000 18B5                                                 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 18B6                                                 }
; 0000 18B7                                              //wymianymy
; 0000 18B8                                         break;
; 0000 18B9                                         }
; 0000 18BA                             }
; 0000 18BB 
; 0000 18BC 
; 0000 18BD 
; 0000 18BE 
; 0000 18BF 
; 0000 18C0 
; 0000 18C1     break;
; 0000 18C2 
; 0000 18C3    case 4:
; 0000 18C4 
; 0000 18C5                       //na sam dol zjezdzamy pionami
; 0000 18C6                 if(cykl_sterownik_3 < 5)
; 0000 18C7                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
; 0000 18C8                 if(cykl_sterownik_4 < 5)
; 0000 18C9                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
; 0000 18CA 
; 0000 18CB                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
; 0000 18CC                                         {
; 0000 18CD                                         cykl_sterownik_1 = 0;
; 0000 18CE                                         cykl_sterownik_2 = 0;
; 0000 18CF                                         cykl_sterownik_3 = 0;
; 0000 18D0                                         cykl_sterownik_4 = 0;
; 0000 18D1                                         wartosc_parametru_panelu(0,48,32);
; 0000 18D2                                         PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 18D3                                         cykl_wymiany = 5;
; 0000 18D4                                         g = 0;
; 0000 18D5                                         }
; 0000 18D6 
; 0000 18D7    break;
; 0000 18D8 
; 0000 18D9 
; 0000 18DA     }//switch
; 0000 18DB 
; 0000 18DC    }//while
; 0000 18DD 
; 0000 18DE 
; 0000 18DF while(f == 1)
; 0000 18E0     {
; 0000 18E1     switch(cykl_wymiany)
; 0000 18E2     {
; 0000 18E3     case 0:
; 0000 18E4 
; 0000 18E5                cykl_sterownik_1 = 0;
; 0000 18E6                cykl_sterownik_2 = 0;
; 0000 18E7                cykl_sterownik_3 = 0;
; 0000 18E8                cykl_sterownik_4 = 0;
; 0000 18E9                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 18EA                cykl_wymiany = 1;
; 0000 18EB 
; 0000 18EC 
; 0000 18ED 
; 0000 18EE     break;
; 0000 18EF 
; 0000 18F0     case 1:
; 0000 18F1 
; 0000 18F2             //na sam dol zjezdzamy pionami
; 0000 18F3                 if(cykl_sterownik_3 < 5)
; 0000 18F4                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
; 0000 18F5                 if(cykl_sterownik_4 < 5)
; 0000 18F6                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
; 0000 18F7 
; 0000 18F8                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
; 0000 18F9 
; 0000 18FA                             {
; 0000 18FB                                         cykl_sterownik_3 = 0;
; 0000 18FC                                         cykl_sterownik_4 = 0;
; 0000 18FD                                         cykl_wymiany = 2;
; 0000 18FE                                         }
; 0000 18FF 
; 0000 1900 
; 0000 1901 
; 0000 1902     break;
; 0000 1903 
; 0000 1904 
; 0000 1905 
; 0000 1906     case 2:
; 0000 1907 
; 0000 1908                                 if(cykl_sterownik_1 < 5)
; 0000 1909                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
; 0000 190A                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
; 0000 190B                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
; 0000 190C 
; 0000 190D                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
; 0000 190E                                         {
; 0000 190F                                         cykl_sterownik_1 = 0;
; 0000 1910                                         cykl_sterownik_2 = 0;
; 0000 1911                                         cykl_sterownik_3 = 0;
; 0000 1912                                         cykl_sterownik_4 = 0;
; 0000 1913                                          cykl_wymiany = 3;
; 0000 1914 
; 0000 1915                                         }
; 0000 1916 
; 0000 1917     break;
; 0000 1918 
; 0000 1919 
; 0000 191A 
; 0000 191B     case 3:
; 0000 191C 
; 0000 191D             //na sam dol zjezdzamy pionami
; 0000 191E                 if(cykl_sterownik_3 < 5)
; 0000 191F                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
; 0000 1920                 if(cykl_sterownik_4 < 5)
; 0000 1921                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
; 0000 1922 
; 0000 1923                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
; 0000 1924 
; 0000 1925                             {
; 0000 1926                                         cykl_sterownik_3 = 0;
; 0000 1927                                         cykl_sterownik_4 = 0;
; 0000 1928                                         e = odczytaj_parametr(48,48);
; 0000 1929 
; 0000 192A                                         switch (e)
; 0000 192B                                         {
; 0000 192C                                         case 0:
; 0000 192D 
; 0000 192E                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
; 0000 192F                                              {
; 0000 1930                                              cykl_wymiany = 4;
; 0000 1931                                              PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1932                                              }
; 0000 1933                                              //jednak nie wymianiamy
; 0000 1934 
; 0000 1935                                         break;
; 0000 1936 
; 0000 1937                                         case 1:
; 0000 1938                                              PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 1939                                              cykl_wymiany = 3;
; 0000 193A                                              //czekam z decyzja - w trakcie wymiany
; 0000 193B                                         break;
; 0000 193C 
; 0000 193D                                         case 2:
; 0000 193E 
; 0000 193F 
; 0000 1940 
; 0000 1941                                              PORT_F.bits.b6 = 0;   //zgas lampke
; 0000 1942                                              PORTF = PORT_F.byte;
; 0000 1943 
; 0000 1944                                              if(srednica_wew_korpusu == 34)
; 0000 1945                                              {
; 0000 1946                                              czas_pracy_krazka_sciernego_h_34 = 0;
; 0000 1947                                              wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
; 0000 1948                                              wartosc_parametru_panelu_stala_pamiec(0,112,96,48);
; 0000 1949                                              delay_ms(200);
; 0000 194A                                              odczyt_parametru_panelu_stala_pamiec(0,112,96,48);
; 0000 194B                                              delay_ms(200);
; 0000 194C                                              }
; 0000 194D 
; 0000 194E                                              if(srednica_wew_korpusu == 36)
; 0000 194F                                              {
; 0000 1950                                              czas_pracy_krazka_sciernego_h_36 = 0;
; 0000 1951                                              wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
; 0000 1952                                              wartosc_parametru_panelu_stala_pamiec(0,128,96,64);
; 0000 1953                                              delay_ms(200);
; 0000 1954                                              odczyt_parametru_panelu_stala_pamiec(0,128,96,64);
; 0000 1955                                              delay_ms(200);
; 0000 1956                                              }
; 0000 1957 
; 0000 1958                                              if(srednica_wew_korpusu == 38)
; 0000 1959                                              {
; 0000 195A                                              czas_pracy_krazka_sciernego_h_38 = 0;
; 0000 195B                                              wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
; 0000 195C                                              wartosc_parametru_panelu_stala_pamiec(0,144,96,80);
; 0000 195D                                              delay_ms(200);
; 0000 195E                                              odczyt_parametru_panelu_stala_pamiec(0,144,96,80);
; 0000 195F                                              delay_ms(200);
; 0000 1960                                              }
; 0000 1961 
; 0000 1962                                             if(srednica_wew_korpusu == 41)
; 0000 1963                                             {
; 0000 1964                                             czas_pracy_krazka_sciernego_h_41 = 0;
; 0000 1965                                             wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
; 0000 1966                                             wartosc_parametru_panelu_stala_pamiec(16,0,96,96);
; 0000 1967                                             delay_ms(200);
; 0000 1968                                             odczyt_parametru_panelu_stala_pamiec(16,0,96,96);
; 0000 1969                                             delay_ms(200);
; 0000 196A                                             }
; 0000 196B 
; 0000 196C                                             if(srednica_wew_korpusu == 43)
; 0000 196D                                             {
; 0000 196E                                             czas_pracy_krazka_sciernego_h_43 = 0;
; 0000 196F                                             wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
; 0000 1970                                             wartosc_parametru_panelu_stala_pamiec(16,16,96,112);
; 0000 1971                                             delay_ms(200);
; 0000 1972                                             odczyt_parametru_panelu_stala_pamiec(16,16,96,112);
; 0000 1973                                             delay_ms(200);
; 0000 1974                                             }
; 0000 1975 
; 0000 1976 
; 0000 1977                                              komunikat_na_panel("                                                ",64,0);
; 0000 1978                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
; 0000 1979                                                      {
; 0000 197A                                                      PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 197B                                                      cykl_wymiany = 4;
; 0000 197C                                                      }
; 0000 197D                                              //wymianymy
; 0000 197E                                         break;
; 0000 197F                                         }
; 0000 1980                             }
; 0000 1981 
; 0000 1982 
; 0000 1983 
; 0000 1984 
; 0000 1985 
; 0000 1986 
; 0000 1987     break;
; 0000 1988 
; 0000 1989    case 4:
; 0000 198A 
; 0000 198B                       //na sam dol zjezdzamy pionami
; 0000 198C                 if(cykl_sterownik_3 < 5)
; 0000 198D                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
; 0000 198E                 if(cykl_sterownik_4 < 5)
; 0000 198F                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
; 0000 1990 
; 0000 1991                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
; 0000 1992 
; 0000 1993                             {
; 0000 1994                                         cykl_sterownik_1 = 0;
; 0000 1995                                         cykl_sterownik_2 = 0;
; 0000 1996                                         cykl_sterownik_3 = 0;
; 0000 1997                                         cykl_sterownik_4 = 0;
; 0000 1998                                         cykl_wymiany = 5;
; 0000 1999                                         wartosc_parametru_panelu(0,48,48);
; 0000 199A                                         PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 199B                                         f = 0;
; 0000 199C                                         }
; 0000 199D 
; 0000 199E    break;
; 0000 199F 
; 0000 19A0 
; 0000 19A1     }//switch
; 0000 19A2 
; 0000 19A3    }//while
; 0000 19A4 
; 0000 19A5 
; 0000 19A6 
; 0000 19A7 
; 0000 19A8 
; 0000 19A9 
; 0000 19AA 
; 0000 19AB 
; 0000 19AC }
;
;
;void przypadek887()
; 0000 19B0 {
_przypadek887:
; 0000 19B1 if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xCE
	BRGE _0x383
; 0000 19B2                         {
; 0000 19B3                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xCF
; 0000 19B4                         PORTF = PORT_F.byte;
; 0000 19B5                         }
; 0000 19B6 
; 0000 19B7 
; 0000 19B8                      if(rzad_obrabiany == 2)
_0x383:
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x384
; 0000 19B9                         ostateczny_wybor_zacisku();
	RCALL _ostateczny_wybor_zacisku
; 0000 19BA 
; 0000 19BB                     if(koniec_rzedu_10 == 1)
_0x384:
	CALL SUBOPT_0xD0
	BRNE _0x385
; 0000 19BC                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xD1
; 0000 19BD 
; 0000 19BE 
; 0000 19BF                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x385:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD3
	BREQ _0x386
; 0000 19C0                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x6E
	CALL SUBOPT_0xD4
; 0000 19C1 
; 0000 19C2                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x386:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xB5
	BREQ _0x387
; 0000 19C3                         {
; 0000 19C4                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 19C5                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0xD7
; 0000 19C6                         }
; 0000 19C7 
; 0000 19C8 
; 0000 19C9                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x387:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD8
	AND  R30,R0
	BREQ _0x388
; 0000 19CA                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0xD9
; 0000 19CB 
; 0000 19CC                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x388:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xDA
	AND  R30,R0
	BREQ _0x389
; 0000 19CD                         {
; 0000 19CE                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 19CF                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0xDB
; 0000 19D0                         }
; 0000 19D1 
; 0000 19D2                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x389:
	CALL SUBOPT_0xDC
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x38A
; 0000 19D3                         {
; 0000 19D4                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 19D5                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0xDD
; 0000 19D6                         }
; 0000 19D7 
; 0000 19D8                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 19D9                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x38A:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xDE
	AND  R30,R0
	BREQ _0x38B
; 0000 19DA                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0xDF
; 0000 19DB 
; 0000 19DC 
; 0000 19DD                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x38B:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xBB
	AND  R30,R0
	BREQ _0x38C
; 0000 19DE                         {
; 0000 19DF                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 19E0                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0xE0
; 0000 19E1                         }
; 0000 19E2 
; 0000 19E3 
; 0000 19E4 
; 0000 19E5 
; 0000 19E6 
; 0000 19E7 
; 0000 19E8 
; 0000 19E9                                                               //to nowy war, ostatni dzien w borg
; 0000 19EA                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x38C:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xE4
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xE5
	BREQ _0x38D
; 0000 19EB                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x71
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xE6
; 0000 19EC 
; 0000 19ED                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x38D:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE7
	CALL SUBOPT_0xE8
	BREQ _0x38E
; 0000 19EE                         {
; 0000 19EF                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0xE9
	BRNE _0x38F
; 0000 19F0                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 19F1                         if(abs_ster4 == 0)
_0x38F:
	CALL SUBOPT_0xEB
	BRNE _0x390
; 0000 19F2                             {
; 0000 19F3                             szczotka_druc_cykl++;
	CALL SUBOPT_0xEC
; 0000 19F4                             abs_ster4 = 1;
; 0000 19F5                             }
; 0000 19F6                         else
	RJMP _0x391
_0x390:
; 0000 19F7                             {
; 0000 19F8                             abs_ster4 = 0;
	CALL SUBOPT_0xED
; 0000 19F9                             sek13 = 0;
; 0000 19FA                             }
_0x391:
; 0000 19FB                         }
; 0000 19FC 
; 0000 19FD                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x38E:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xEF
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xF0
	BREQ _0x392
; 0000 19FE                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x78
	CALL SUBOPT_0xF1
; 0000 19FF 
; 0000 1A00 
; 0000 1A01                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x392:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xF2
	CALL SUBOPT_0xF3
	BREQ _0x393
; 0000 1A02                         {
; 0000 1A03                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1A04                         if(abs_ster3 == 0)
	CALL SUBOPT_0xF5
	BRNE _0x394
; 0000 1A05                             {
; 0000 1A06                             krazek_scierny_cykl++;
	CALL SUBOPT_0xF6
; 0000 1A07                             abs_ster3 = 1;
; 0000 1A08                             }
; 0000 1A09                         else
	RJMP _0x395
_0x394:
; 0000 1A0A                             abs_ster3 = 0;
	CALL SUBOPT_0xF7
; 0000 1A0B                         }
_0x395:
; 0000 1A0C 
; 0000 1A0D                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x393:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xEF
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x396
; 0000 1A0E                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x6D
	CALL SUBOPT_0xF1
; 0000 1A0F 
; 0000 1A10                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x396:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL SUBOPT_0x77
	CALL SUBOPT_0xF8
	BREQ _0x397
; 0000 1A11                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory
	CALL SUBOPT_0xF9
	CALL SUBOPT_0xE6
; 0000 1A12 
; 0000 1A13 
; 0000 1A14 
; 0000 1A15                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1A16 
; 0000 1A17                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonalem_komplet_okregow == 3)
_0x397:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xF2
	CALL SUBOPT_0xFA
	BREQ _0x398
; 0000 1A18                        {
; 0000 1A19                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1A1A                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0xFB
; 0000 1A1B                        }
; 0000 1A1C                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x398:
	CALL SUBOPT_0xFC
	MOV  R0,R30
	CALL SUBOPT_0xEE
	CALL __LTW12
	AND  R30,R0
	BREQ _0x399
; 0000 1A1D                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xFD
; 0000 1A1E 
; 0000 1A1F                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x399:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFE
	AND  R30,R0
	BREQ _0x39A
; 0000 1A20                        {
; 0000 1A21                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0xFF
; 0000 1A22                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1A23                        }
; 0000 1A24                    //////////////////////////////////////////////
; 0000 1A25 
; 0000 1A26 
; 0000 1A27 
; 0000 1A28                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1A29 
; 0000 1A2A                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x39A:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x100
	BREQ _0x39D
; 0000 1A2B                        {
; 0000 1A2C                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1A2D                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1A2E                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x101
; 0000 1A2F                        }
; 0000 1A30                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x39D:
	CALL SUBOPT_0x102
	MOV  R0,R30
	CALL SUBOPT_0xE1
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3A0
; 0000 1A31                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x103
	CALL SUBOPT_0xE6
; 0000 1A32 
; 0000 1A33                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3A0:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x3A1
; 0000 1A34                        {
; 0000 1A35                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x105
; 0000 1A36                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1A37                        }
; 0000 1A38                    //////////////////////////////////////////////
; 0000 1A39 
; 0000 1A3A                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3A1:
; 0000 1A3B                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1A3C                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1A3D                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0 &  wykonalem_komplet_okregow == 3)
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0x108
	CALL SUBOPT_0x109
	CALL SUBOPT_0x10A
	CALL SUBOPT_0x10B
	BREQ _0x3A4
; 0000 1A3E                         {
; 0000 1A3F                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0xFF
; 0000 1A40                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x105
; 0000 1A41                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1A42                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x10C
; 0000 1A43                         cykl_sterownik_3 = 0;
; 0000 1A44                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1A45                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x10D
; 0000 1A46                         krazek_scierny_cykl = 0;
; 0000 1A47                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1A48                         wykonalem_komplet_okregow = 0;
; 0000 1A49                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1A4A                         //PORTF = PORT_F.byte;
; 0000 1A4B                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1A4C                         cykl_glowny = 9;
; 0000 1A4D                         }
; 0000 1A4E }
_0x3A4:
	RET
;
;
;
;void przypadek888()
; 0000 1A53 {
_przypadek888:
; 0000 1A54 
; 0000 1A55                  if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xCE
	BRGE _0x3A7
; 0000 1A56                         {
; 0000 1A57                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xCF
; 0000 1A58                         PORTF = PORT_F.byte;
; 0000 1A59                         }
; 0000 1A5A 
; 0000 1A5B 
; 0000 1A5C                      if(rzad_obrabiany == 2)
_0x3A7:
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x3A8
; 0000 1A5D                         ostateczny_wybor_zacisku();
	RCALL _ostateczny_wybor_zacisku
; 0000 1A5E 
; 0000 1A5F                     if(koniec_rzedu_10 == 1)
_0x3A8:
	CALL SUBOPT_0xD0
	BRNE _0x3A9
; 0000 1A60                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xD1
; 0000 1A61 
; 0000 1A62 
; 0000 1A63                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x3A9:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD3
	BREQ _0x3AA
; 0000 1A64                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x6E
	CALL SUBOPT_0xD4
; 0000 1A65 
; 0000 1A66                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x3AA:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xB5
	BREQ _0x3AB
; 0000 1A67                         {
; 0000 1A68                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1A69                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0xD7
; 0000 1A6A                         }
; 0000 1A6B 
; 0000 1A6C 
; 0000 1A6D                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3AB:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD8
	AND  R30,R0
	BREQ _0x3AC
; 0000 1A6E                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0xD9
; 0000 1A6F 
; 0000 1A70                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3AC:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xDA
	AND  R30,R0
	BREQ _0x3AD
; 0000 1A71                         {
; 0000 1A72                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1A73                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0xDB
; 0000 1A74                         }
; 0000 1A75 
; 0000 1A76                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3AD:
	CALL SUBOPT_0xDC
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x3AE
; 0000 1A77                         {
; 0000 1A78                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1A79                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0xDD
; 0000 1A7A                         }
; 0000 1A7B 
; 0000 1A7C                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1A7D                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x3AE:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xDE
	AND  R30,R0
	BREQ _0x3AF
; 0000 1A7E                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0xDF
; 0000 1A7F 
; 0000 1A80 
; 0000 1A81                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x3AF:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xBB
	AND  R30,R0
	BREQ _0x3B0
; 0000 1A82                         {
; 0000 1A83                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1A84                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0xE0
; 0000 1A85                         }
; 0000 1A86 
; 0000 1A87 
; 0000 1A88 
; 0000 1A89 
; 0000 1A8A 
; 0000 1A8B 
; 0000 1A8C 
; 0000 1A8D                                                               //to nowy war, ostatni dzien w borg
; 0000 1A8E                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3B0:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL SUBOPT_0xE3
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xE5
	BREQ _0x3B1
; 0000 1A8F                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x71
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xE6
; 0000 1A90 
; 0000 1A91                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3B1:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE7
	CALL SUBOPT_0xE8
	BREQ _0x3B2
; 0000 1A92                         {
; 0000 1A93                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0xE9
	BRNE _0x3B3
; 0000 1A94                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1A95                         if(abs_ster4 == 0)
_0x3B3:
	CALL SUBOPT_0xEB
	BRNE _0x3B4
; 0000 1A96                             {
; 0000 1A97                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x10E
	BRNE _0x3B5
; 0000 1A98                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1A99                             szczotka_druc_cykl++;
_0x3B5:
	CALL SUBOPT_0xEC
; 0000 1A9A                             abs_ster4 = 1;
; 0000 1A9B                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x10F
	CP   R4,R26
	CPC  R5,R27
	BRNE _0x3B8
; 0000 1A9C                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0xD1
; 0000 1A9D                             }
_0x3B8:
; 0000 1A9E                         else
	RJMP _0x3B9
_0x3B4:
; 0000 1A9F                             {
; 0000 1AA0                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1AA1                             abs_ster4 = 0;
	CALL SUBOPT_0xED
; 0000 1AA2                             sek13 = 0;
; 0000 1AA3                             }
_0x3B9:
; 0000 1AA4                         }
; 0000 1AA5 
; 0000 1AA6                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3B2:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xEF
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xF0
	BREQ _0x3BC
; 0000 1AA7                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x78
	CALL SUBOPT_0xF1
; 0000 1AA8 
; 0000 1AA9 
; 0000 1AAA                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3BC:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xF2
	CALL SUBOPT_0xF3
	BREQ _0x3BD
; 0000 1AAB                         {
; 0000 1AAC                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1AAD                         if(abs_ster3 == 0)
	CALL SUBOPT_0xF5
	BRNE _0x3BE
; 0000 1AAE                             {
; 0000 1AAF                             krazek_scierny_cykl++;
	CALL SUBOPT_0xF6
; 0000 1AB0                             abs_ster3 = 1;
; 0000 1AB1                             }
; 0000 1AB2                         else
	RJMP _0x3BF
_0x3BE:
; 0000 1AB3                             abs_ster3 = 0;
	CALL SUBOPT_0xF7
; 0000 1AB4                         }
_0x3BF:
; 0000 1AB5 
; 0000 1AB6                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3BD:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xEF
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x3C0
; 0000 1AB7                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x6D
	CALL SUBOPT_0xF1
; 0000 1AB8 
; 0000 1AB9                        if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x3C0:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL SUBOPT_0x77
	CALL SUBOPT_0xF8
	BREQ _0x3C1
; 0000 1ABA                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x74
	CALL SUBOPT_0x110
	CALL SUBOPT_0xE6
; 0000 1ABB 
; 0000 1ABC                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1ABD 
; 0000 1ABE                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonalem_komplet_okregow == 3)
_0x3C1:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xF2
	CALL SUBOPT_0xFA
	BREQ _0x3C2
; 0000 1ABF                        {
; 0000 1AC0                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1AC1                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0xFB
; 0000 1AC2                        }
; 0000 1AC3                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x3C2:
	CALL SUBOPT_0xFC
	MOV  R0,R30
	CALL SUBOPT_0xEE
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3C3
; 0000 1AC4                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xFD
; 0000 1AC5 
; 0000 1AC6                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x3C3:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFE
	AND  R30,R0
	BREQ _0x3C4
; 0000 1AC7                        {
; 0000 1AC8                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0xFF
; 0000 1AC9                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1ACA                        }
; 0000 1ACB                    //////////////////////////////////////////////
; 0000 1ACC 
; 0000 1ACD 
; 0000 1ACE 
; 0000 1ACF                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1AD0 
; 0000 1AD1                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x3C4:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x100
	BREQ _0x3C7
; 0000 1AD2                        {
; 0000 1AD3                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1AD4                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1AD5                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x101
; 0000 1AD6                        }
; 0000 1AD7                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3C7:
	CALL SUBOPT_0x102
	MOV  R0,R30
	CALL SUBOPT_0xE1
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3CA
; 0000 1AD8                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x103
	CALL SUBOPT_0xE6
; 0000 1AD9 
; 0000 1ADA                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3CA:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x3CB
; 0000 1ADB                        {
; 0000 1ADC                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x105
; 0000 1ADD                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1ADE                        }
; 0000 1ADF                    //////////////////////////////////////////////
; 0000 1AE0 
; 0000 1AE1                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3CB:
; 0000 1AE2                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1AE3                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1AE4                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0 &  wykonalem_komplet_okregow == 3)
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0x108
	CALL SUBOPT_0x109
	CALL SUBOPT_0x10A
	CALL SUBOPT_0x10B
	BREQ _0x3CE
; 0000 1AE5                         {
; 0000 1AE6                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0xFF
; 0000 1AE7                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x105
; 0000 1AE8                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1AE9                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x10C
; 0000 1AEA                         cykl_sterownik_3 = 0;
; 0000 1AEB                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1AEC                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x10D
; 0000 1AED                         krazek_scierny_cykl = 0;
; 0000 1AEE                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1AEF                         wykonalem_komplet_okregow = 0;
; 0000 1AF0                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1AF1                         //PORTF = PORT_F.byte;
; 0000 1AF2                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1AF3                         cykl_glowny = 9;
; 0000 1AF4                         }
; 0000 1AF5 
; 0000 1AF6  }
_0x3CE:
	RET
;
;
;
;void przypadek997()
; 0000 1AFB 
; 0000 1AFC {
_przypadek997:
; 0000 1AFD 
; 0000 1AFE            if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xCE
	BRGE _0x3D1
; 0000 1AFF                         {
; 0000 1B00                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xCF
; 0000 1B01                         PORTF = PORT_F.byte;
; 0000 1B02                         }
; 0000 1B03 
; 0000 1B04 
; 0000 1B05                      if(rzad_obrabiany == 2)
_0x3D1:
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x3D2
; 0000 1B06                         ostateczny_wybor_zacisku();
	RCALL _ostateczny_wybor_zacisku
; 0000 1B07 
; 0000 1B08                     if(koniec_rzedu_10 == 1)
_0x3D2:
	CALL SUBOPT_0xD0
	BRNE _0x3D3
; 0000 1B09                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xD1
; 0000 1B0A                                                               //to nowy war, ostatni dzien w borg
; 0000 1B0B                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3D3:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL SUBOPT_0xE3
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xE5
	BREQ _0x3D4
; 0000 1B0C                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x71
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xE6
; 0000 1B0D 
; 0000 1B0E                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3D4:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE7
	CALL SUBOPT_0xE8
	BREQ _0x3D5
; 0000 1B0F                         {
; 0000 1B10                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0xE9
	BRNE _0x3D6
; 0000 1B11                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1B12                         if(abs_ster4 == 0)
_0x3D6:
	CALL SUBOPT_0xEB
	BRNE _0x3D7
; 0000 1B13                             {
; 0000 1B14                             szczotka_druc_cykl++;
	CALL SUBOPT_0x111
; 0000 1B15                             //////////////////////
; 0000 1B16                             if(statystyka == 1)
	CALL SUBOPT_0x112
	BRNE _0x3D8
; 0000 1B17                                 {
; 0000 1B18                                 wartosc_parametru_panelu(szczotka_druc_cykl,96,128);
	CALL SUBOPT_0x113
	CALL SUBOPT_0x24
	CALL _wartosc_parametru_panelu
; 0000 1B19                                 wartosc_parametru_panelu(cykl_ilosc_zaciskow,128,80);  //pamietac ze zmienna cykl tak naprawde dodaje sie dalej w programie, czyli jak tu bedzie 7 to znaczy ze jestesmy na dolku 8
	CALL SUBOPT_0x114
	CALL SUBOPT_0x115
	CALL SUBOPT_0xA6
	CALL _wartosc_parametru_panelu
; 0000 1B1A                                 }
; 0000 1B1B                             //////////////////////////
; 0000 1B1C                             abs_ster4 = 1;
_0x3D8:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R31
; 0000 1B1D                             }
; 0000 1B1E                        else
	RJMP _0x3D9
_0x3D7:
; 0000 1B1F                             {
; 0000 1B20                             abs_ster4 = 0;
	CALL SUBOPT_0xED
; 0000 1B21                             sek13 = 0;
; 0000 1B22                             }
_0x3D9:
; 0000 1B23                         }
; 0000 1B24 
; 0000 1B25                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3D5:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xEF
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xF0
	BREQ _0x3DA
; 0000 1B26                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x78
	CALL SUBOPT_0xF1
; 0000 1B27 
; 0000 1B28 
; 0000 1B29                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3DA:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xF2
	CALL SUBOPT_0xF3
	BREQ _0x3DB
; 0000 1B2A                         {
; 0000 1B2B                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1B2C                         if(abs_ster3 == 0)
	CALL SUBOPT_0xF5
	BRNE _0x3DC
; 0000 1B2D                             {
; 0000 1B2E                             krazek_scierny_cykl++;
	CALL SUBOPT_0x116
; 0000 1B2F                             //////////////////////
; 0000 1B30                             if(statystyka == 1)
	CALL SUBOPT_0x112
	BRNE _0x3DD
; 0000 1B31                                 wartosc_parametru_panelu(krazek_scierny_cykl,128,96);
	CALL SUBOPT_0x117
	CALL SUBOPT_0x18
	CALL _wartosc_parametru_panelu
; 0000 1B32                             //////////////////////////
; 0000 1B33                             abs_ster3 = 1;
_0x3DD:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R31
; 0000 1B34                             }
; 0000 1B35                         else
	RJMP _0x3DE
_0x3DC:
; 0000 1B36                             abs_ster3 = 0;
	CALL SUBOPT_0xF7
; 0000 1B37                         }
_0x3DE:
; 0000 1B38 
; 0000 1B39                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3DB:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xEF
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x3DF
; 0000 1B3A                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x6D
	CALL SUBOPT_0xF1
; 0000 1B3B 
; 0000 1B3C 
; 0000 1B3D                      if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x3DF:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL SUBOPT_0x77
	CALL SUBOPT_0xF8
	BREQ _0x3E0
; 0000 1B3E                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory kawaleczek
	CALL SUBOPT_0xF9
	CALL SUBOPT_0xE6
; 0000 1B3F 
; 0000 1B40                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1B41 
; 0000 1B42                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonano_powrot_przedwczesny_krazek_scierny == 0)
_0x3E0:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xF2
	CALL SUBOPT_0x118
	AND  R0,R30
	LDS  R26,_wykonano_powrot_przedwczesny_krazek_scierny
	LDS  R27,_wykonano_powrot_przedwczesny_krazek_scierny+1
	CALL SUBOPT_0xB5
	BREQ _0x3E1
; 0000 1B43                        {
; 0000 1B44                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1B45                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0xFB
; 0000 1B46                        //////////////////////
; 0000 1B47                        if(statystyka == 1)
	CALL SUBOPT_0x112
	BRNE _0x3E2
; 0000 1B48                             wartosc_parametru_panelu(powrot_przedwczesny_krazek_scierny,128,112);
	CALL SUBOPT_0x119
	CALL SUBOPT_0x9D
	CALL _wartosc_parametru_panelu
; 0000 1B49                        //////////////////////////
; 0000 1B4A                        }
_0x3E2:
; 0000 1B4B                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x3E1:
	CALL SUBOPT_0xFC
	MOV  R0,R30
	CALL SUBOPT_0xEE
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3E3
; 0000 1B4C                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xFD
; 0000 1B4D 
; 0000 1B4E                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x3E3:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFE
	AND  R30,R0
	BREQ _0x3E4
; 0000 1B4F                        {
; 0000 1B50                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0xFF
; 0000 1B51                        wykonano_powrot_przedwczesny_krazek_scierny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonano_powrot_przedwczesny_krazek_scierny,R30
	STS  _wykonano_powrot_przedwczesny_krazek_scierny+1,R31
; 0000 1B52                        //////////////////////
; 0000 1B53                        if(statystyka == 1)
	CALL SUBOPT_0x112
	BRNE _0x3E5
; 0000 1B54                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_krazek_scierny,128,128);
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x24
	CALL _wartosc_parametru_panelu
; 0000 1B55                        //////////////////////////
; 0000 1B56                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
_0x3E5:
	CBI  0x3,3
; 0000 1B57                        }
; 0000 1B58                    //////////////////////////////////////////////
; 0000 1B59 
; 0000 1B5A 
; 0000 1B5B 
; 0000 1B5C                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1B5D 
; 0000 1B5E                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli & wykonano_powrot_przedwczesny_druciak == 0)
_0x3E4:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE7
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x11B
	AND  R0,R30
	LDS  R26,_wykonano_powrot_przedwczesny_druciak
	LDS  R27,_wykonano_powrot_przedwczesny_druciak+1
	CALL SUBOPT_0xB5
	BREQ _0x3E8
; 0000 1B5F                        {
; 0000 1B60                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1B61                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1B62                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x101
; 0000 1B63                        //////////////////////
; 0000 1B64                        if(statystyka == 1)
	CALL SUBOPT_0x112
	BRNE _0x3EB
; 0000 1B65                             wartosc_parametru_panelu(powrot_przedwczesny_druciak,96,144);
	CALL SUBOPT_0x11C
	CALL SUBOPT_0x9A
	CALL _wartosc_parametru_panelu
; 0000 1B66                        //////////////////////////
; 0000 1B67                        }
_0x3EB:
; 0000 1B68                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3E8:
	CALL SUBOPT_0x102
	MOV  R0,R30
	CALL SUBOPT_0xE1
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3EC
; 0000 1B69                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x103
	CALL SUBOPT_0xE6
; 0000 1B6A 
; 0000 1B6B                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3EC:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x3ED
; 0000 1B6C                        {
; 0000 1B6D                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x105
; 0000 1B6E                        wykonano_powrot_przedwczesny_druciak = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonano_powrot_przedwczesny_druciak,R30
	STS  _wykonano_powrot_przedwczesny_druciak+1,R31
; 0000 1B6F                        ///////////////////////////////
; 0000 1B70                        if(statystyka == 1)
	CALL SUBOPT_0x112
	BRNE _0x3EE
; 0000 1B71                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_druciak,112,0);
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x14
	CALL _wartosc_parametru_panelu
; 0000 1B72                        //////////////////////////////
; 0000 1B73                        PORTE.2 = 0;  //wylacz szlifierke
_0x3EE:
	CBI  0x3,2
; 0000 1B74                        }
; 0000 1B75                    ///////////////////////////////////////////////////////////////////////
; 0000 1B76 
; 0000 1B77                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3ED:
; 0000 1B78                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1B79                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1B7A                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0)
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0x108
	CALL SUBOPT_0x109
	CALL SUBOPT_0xE4
	CALL SUBOPT_0xB5
	BRNE PC+3
	JMP _0x3F1
; 0000 1B7B                         {
; 0000 1B7C                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0xFF
; 0000 1B7D                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x105
; 0000 1B7E                         wykonano_powrot_przedwczesny_krazek_scierny = 0;
	LDI  R30,LOW(0)
	STS  _wykonano_powrot_przedwczesny_krazek_scierny,R30
	STS  _wykonano_powrot_przedwczesny_krazek_scierny+1,R30
; 0000 1B7F                         wykonano_powrot_przedwczesny_druciak = 0;
	STS  _wykonano_powrot_przedwczesny_druciak,R30
	STS  _wykonano_powrot_przedwczesny_druciak+1,R30
; 0000 1B80                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1B81                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x10C
; 0000 1B82                         cykl_sterownik_3 = 0;
; 0000 1B83                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1B84                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x11E
; 0000 1B85                         krazek_scierny_cykl = 0;
; 0000 1B86                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1B87                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1B88                         //PORTF = PORT_F.byte;
; 0000 1B89                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1B8A 
; 0000 1B8B                         if(statystyka == 1)
	CALL SUBOPT_0x112
	BRNE _0x3F4
; 0000 1B8C                             {
; 0000 1B8D                             wartosc_parametru_panelu(szczotka_druc_cykl,96,128);
	CALL SUBOPT_0x113
	CALL SUBOPT_0x24
	CALL _wartosc_parametru_panelu
; 0000 1B8E                             wartosc_parametru_panelu(krazek_scierny_cykl,128,96);
	CALL SUBOPT_0x117
	CALL SUBOPT_0x18
	CALL _wartosc_parametru_panelu
; 0000 1B8F                             wartosc_parametru_panelu(powrot_przedwczesny_druciak,96,144);
	CALL SUBOPT_0x11C
	CALL SUBOPT_0x9A
	CALL _wartosc_parametru_panelu
; 0000 1B90                             wartosc_parametru_panelu(powrot_przedwczesny_krazek_scierny,128,112);
	CALL SUBOPT_0x119
	CALL SUBOPT_0x9D
	CALL _wartosc_parametru_panelu
; 0000 1B91                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_druciak,112,0);
	CALL SUBOPT_0x11D
	CALL SUBOPT_0x14
	CALL _wartosc_parametru_panelu
; 0000 1B92                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_krazek_scierny,128,128);
	CALL SUBOPT_0x11A
	CALL SUBOPT_0x24
	CALL _wartosc_parametru_panelu
; 0000 1B93                             }
; 0000 1B94                         cykl_glowny = 9;
_0x3F4:
	CALL SUBOPT_0x11F
; 0000 1B95                         }
; 0000 1B96 
; 0000 1B97 }
_0x3F1:
	RET
;
;void przypadek998()
; 0000 1B9A {
_przypadek998:
; 0000 1B9B 
; 0000 1B9C            if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xCE
	BRGE _0x3F5
; 0000 1B9D                         {
; 0000 1B9E                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xCF
; 0000 1B9F                         PORTF = PORT_F.byte;
; 0000 1BA0                         }
; 0000 1BA1 
; 0000 1BA2 
; 0000 1BA3                      if(rzad_obrabiany == 2)
_0x3F5:
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x3F6
; 0000 1BA4                         ostateczny_wybor_zacisku();
	RCALL _ostateczny_wybor_zacisku
; 0000 1BA5 
; 0000 1BA6                     if(koniec_rzedu_10 == 1)
_0x3F6:
	CALL SUBOPT_0xD0
	BRNE _0x3F7
; 0000 1BA7                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xD1
; 0000 1BA8 
; 0000 1BA9                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3F7:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL SUBOPT_0xE3
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xE5
	BREQ _0x3F8
; 0000 1BAA                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x71
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xE6
; 0000 1BAB 
; 0000 1BAC                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3F8:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE7
	CALL SUBOPT_0xE8
	BREQ _0x3F9
; 0000 1BAD                         {
; 0000 1BAE                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0xE9
	BRNE _0x3FA
; 0000 1BAF                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1BB0                         if(abs_ster4 == 0)
_0x3FA:
	CALL SUBOPT_0xEB
	BRNE _0x3FB
; 0000 1BB1                             {
; 0000 1BB2                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x10E
	BRNE _0x3FC
; 0000 1BB3                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1BB4                             szczotka_druc_cykl++;
_0x3FC:
	CALL SUBOPT_0xEC
; 0000 1BB5                             abs_ster4 = 1;
; 0000 1BB6                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x10F
	CP   R4,R26
	CPC  R5,R27
	BRNE _0x3FF
; 0000 1BB7                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0xD1
; 0000 1BB8                             }
_0x3FF:
; 0000 1BB9                         else
	RJMP _0x400
_0x3FB:
; 0000 1BBA                             {
; 0000 1BBB                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1BBC                             abs_ster4 = 0;
	CALL SUBOPT_0xED
; 0000 1BBD                             sek13 = 0;
; 0000 1BBE                             }
_0x400:
; 0000 1BBF                         }
; 0000 1BC0 
; 0000 1BC1                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3F9:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xEF
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xF0
	BREQ _0x403
; 0000 1BC2                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x78
	CALL SUBOPT_0xF1
; 0000 1BC3 
; 0000 1BC4 
; 0000 1BC5                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x403:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xF2
	CALL SUBOPT_0xF3
	BREQ _0x404
; 0000 1BC6                         {
; 0000 1BC7                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1BC8                         if(abs_ster3 == 0)
	CALL SUBOPT_0xF5
	BRNE _0x405
; 0000 1BC9                             {
; 0000 1BCA                             krazek_scierny_cykl++;
	CALL SUBOPT_0xF6
; 0000 1BCB 
; 0000 1BCC                             abs_ster3 = 1;
; 0000 1BCD                             }
; 0000 1BCE                         else
	RJMP _0x406
_0x405:
; 0000 1BCF                             abs_ster3 = 0;
	CALL SUBOPT_0xF7
; 0000 1BD0                         }
_0x406:
; 0000 1BD1 
; 0000 1BD2                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x404:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xEF
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x407
; 0000 1BD3                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x6D
	CALL SUBOPT_0xF1
; 0000 1BD4 
; 0000 1BD5                        if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x407:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL SUBOPT_0x77
	CALL SUBOPT_0xF8
	BREQ _0x408
; 0000 1BD6                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x74
	CALL SUBOPT_0x110
	CALL SUBOPT_0xE6
; 0000 1BD7 
; 0000 1BD8 
; 0000 1BD9 
; 0000 1BDA                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1BDB 
; 0000 1BDC                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x408:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xF2
	CALL SUBOPT_0x118
	AND  R30,R0
	BREQ _0x409
; 0000 1BDD                        {
; 0000 1BDE                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1BDF                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0xFB
; 0000 1BE0                        }
; 0000 1BE1                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x409:
	CALL SUBOPT_0xFC
	MOV  R0,R30
	CALL SUBOPT_0xEE
	CALL __LTW12
	AND  R30,R0
	BREQ _0x40A
; 0000 1BE2                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xFD
; 0000 1BE3 
; 0000 1BE4                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x40A:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFE
	AND  R30,R0
	BREQ _0x40B
; 0000 1BE5                        {
; 0000 1BE6                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0xFF
; 0000 1BE7                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1BE8                        }
; 0000 1BE9                    //////////////////////////////////////////////
; 0000 1BEA 
; 0000 1BEB 
; 0000 1BEC 
; 0000 1BED                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1BEE 
; 0000 1BEF                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x40B:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x100
	BREQ _0x40E
; 0000 1BF0                        {
; 0000 1BF1                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1BF2                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1BF3                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x101
; 0000 1BF4                        }
; 0000 1BF5                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x40E:
	CALL SUBOPT_0x102
	MOV  R0,R30
	CALL SUBOPT_0xE1
	CALL __LTW12
	AND  R30,R0
	BREQ _0x411
; 0000 1BF6                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x103
	CALL SUBOPT_0xE6
; 0000 1BF7 
; 0000 1BF8                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x411:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0x104
	AND  R30,R0
	BREQ _0x412
; 0000 1BF9                        {
; 0000 1BFA                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x105
; 0000 1BFB                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1BFC                        }
; 0000 1BFD                    //////////////////////////////////////////////
; 0000 1BFE 
; 0000 1BFF                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x412:
; 0000 1C00                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1C01                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1C02                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0)
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0x108
	CALL SUBOPT_0x109
	CALL SUBOPT_0xE4
	CALL SUBOPT_0xB5
	BREQ _0x415
; 0000 1C03                         {
; 0000 1C04                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0xFF
; 0000 1C05                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x105
; 0000 1C06                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1C07                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x10C
; 0000 1C08                         cykl_sterownik_3 = 0;
; 0000 1C09                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1C0A                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x11E
; 0000 1C0B                         krazek_scierny_cykl = 0;
; 0000 1C0C                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1C0D                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1C0E                         //PORTF = PORT_F.byte;
; 0000 1C0F                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1C10                         cykl_glowny = 9;
	CALL SUBOPT_0x11F
; 0000 1C11                         }
; 0000 1C12 }
_0x415:
	RET
;
;
;void przypadek8()
; 0000 1C16 
; 0000 1C17 {
_przypadek8:
; 0000 1C18 
; 0000 1C19                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xCE
	BRGE _0x418
; 0000 1C1A                         {
; 0000 1C1B                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xCF
; 0000 1C1C                         PORTF = PORT_F.byte;
; 0000 1C1D                         }
; 0000 1C1E 
; 0000 1C1F 
; 0000 1C20                      if(rzad_obrabiany == 2)
_0x418:
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x419
; 0000 1C21                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1C22 
; 0000 1C23 
; 0000 1C24 
; 0000 1C25                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x419:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD3
	BREQ _0x41A
; 0000 1C26                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x6E
	CALL SUBOPT_0xD4
; 0000 1C27                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x41A:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xB5
	BREQ _0x41B
; 0000 1C28                         {
; 0000 1C29                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1C2A                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0xD7
; 0000 1C2B                         }
; 0000 1C2C 
; 0000 1C2D 
; 0000 1C2E                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x41B:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD8
	AND  R30,R0
	BREQ _0x41C
; 0000 1C2F                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0xD9
; 0000 1C30 
; 0000 1C31                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x41C:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xDA
	AND  R30,R0
	BREQ _0x41D
; 0000 1C32                         {
; 0000 1C33                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1C34                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0xDB
; 0000 1C35                         }
; 0000 1C36 
; 0000 1C37                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x41D:
	CALL SUBOPT_0xDC
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x41E
; 0000 1C38                         {
; 0000 1C39                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1C3A                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0xDD
; 0000 1C3B                         }
; 0000 1C3C 
; 0000 1C3D                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1C3E                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x41E:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xDE
	AND  R30,R0
	BREQ _0x41F
; 0000 1C3F                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0xDF
; 0000 1C40 
; 0000 1C41 
; 0000 1C42                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x41F:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xBB
	AND  R30,R0
	BREQ _0x420
; 0000 1C43                         {
; 0000 1C44                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1C45                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0xE0
; 0000 1C46                         }
; 0000 1C47 
; 0000 1C48                     if(cykl_sterownik_3 < 5 & wykonalem_komplet_okregow == 3)
_0x420:
	CALL SUBOPT_0xEE
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x10B
	BREQ _0x421
; 0000 1C49                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV         //tu zmienienie INV, ¿eby szed³ w dol
	CALL SUBOPT_0x78
	CALL SUBOPT_0xF1
; 0000 1C4A 
; 0000 1C4B                      if(cykl_sterownik_3 == 5 & wykonalem_komplet_okregow == 3)
_0x421:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xD5
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x422
; 0000 1C4C                         {
; 0000 1C4D                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x120
; 0000 1C4E                         krazek_scierny_cykl++;
; 0000 1C4F 
; 0000 1C50                         if(krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x121
	BRNE _0x423
; 0000 1C51                             {
; 0000 1C52                             wykonalem_komplet_okregow = 4;
	CALL SUBOPT_0x122
; 0000 1C53                             }
; 0000 1C54                         else
	RJMP _0x424
_0x423:
; 0000 1C55                             wykonalem_komplet_okregow = 0;
	CALL SUBOPT_0x123
; 0000 1C56 
; 0000 1C57                         cykl_sterownik_1 = 0;
_0x424:
	CALL SUBOPT_0xD6
; 0000 1C58                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1C59                         }
; 0000 1C5A 
; 0000 1C5B 
; 0000 1C5C 
; 0000 1C5D 
; 0000 1C5E 
; 0000 1C5F                     if(koniec_rzedu_10 == 1)
_0x422:
	CALL SUBOPT_0xD0
	BRNE _0x425
; 0000 1C60                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xD1
; 0000 1C61                                                               //to nowy war, ostatni dzien w borg
; 0000 1C62                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze & koniec_rzedu_10 == 0)
_0x425:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL SUBOPT_0xE3
	CALL SUBOPT_0x10A
	CALL SUBOPT_0x124
	BREQ _0x426
; 0000 1C63                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x71
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xE6
; 0000 1C64 
; 0000 1C65                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x426:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE7
	CALL __LTW12
	AND  R0,R30
	CALL SUBOPT_0x10A
	CALL SUBOPT_0x125
	BREQ _0x427
; 0000 1C66                         {
; 0000 1C67                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0xE9
	BRNE _0x428
; 0000 1C68                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1C69                         if(abs_ster4 == 0)
_0x428:
	CALL SUBOPT_0xEB
	BRNE _0x429
; 0000 1C6A                             {
; 0000 1C6B                             szczotka_druc_cykl++;
	CALL SUBOPT_0xEC
; 0000 1C6C                             abs_ster4 = 1;
; 0000 1C6D                             }
; 0000 1C6E                         else
	RJMP _0x42A
_0x429:
; 0000 1C6F                             {
; 0000 1C70                             abs_ster4 = 0;
	CALL SUBOPT_0xED
; 0000 1C71                             sek13 = 0;
; 0000 1C72                             }
_0x42A:
; 0000 1C73                         }
; 0000 1C74 
; 0000 1C75 
; 0000 1C76                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x427:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL SUBOPT_0x77
	AND  R0,R30
	CALL SUBOPT_0x10A
	CALL SUBOPT_0x125
	BREQ _0x42B
; 0000 1C77                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory
	CALL SUBOPT_0xF9
	CALL SUBOPT_0xE6
; 0000 1C78 
; 0000 1C79 
; 0000 1C7A                         ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1C7B 
; 0000 1C7C                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x42B:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xF2
	CALL SUBOPT_0x118
	AND  R30,R0
	BREQ _0x42C
; 0000 1C7D                        {
; 0000 1C7E                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1C7F                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0xFB
; 0000 1C80                        }
; 0000 1C81                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x42C:
	CALL SUBOPT_0xFC
	MOV  R0,R30
	CALL SUBOPT_0xEE
	CALL __LTW12
	AND  R30,R0
	BREQ _0x42D
; 0000 1C82                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xFD
; 0000 1C83 
; 0000 1C84                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x42D:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFE
	AND  R30,R0
	BREQ _0x42E
; 0000 1C85                        {
; 0000 1C86                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0xFF
; 0000 1C87                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1C88                        }
; 0000 1C89                    //////////////////////////////////////////////
; 0000 1C8A 
; 0000 1C8B 
; 0000 1C8C 
; 0000 1C8D                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1C8E 
; 0000 1C8F                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
_0x42E:
	CALL SUBOPT_0x126
	CALL SUBOPT_0xE1
	CALL SUBOPT_0x127
	OR   R30,R0
	AND  R30,R1
	BREQ _0x431
; 0000 1C90                        {
; 0000 1C91                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1C92                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1C93                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x101
; 0000 1C94                        }
; 0000 1C95                   if(koniec_rzedu_10 == 0 & powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x431:
	CALL SUBOPT_0x126
	CALL SUBOPT_0x102
	AND  R0,R30
	CALL SUBOPT_0xE1
	CALL __LTW12
	AND  R30,R0
	BREQ _0x434
; 0000 1C96                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x103
	CALL SUBOPT_0xE6
; 0000 1C97 
; 0000 1C98                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x434:
	CALL SUBOPT_0x126
	CALL SUBOPT_0xE1
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x102
	AND  R30,R0
	BREQ _0x435
; 0000 1C99                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x105
; 0000 1C9A                    //////////////////////////////////////////////
; 0000 1C9B 
; 0000 1C9C                     if((wykonalem_komplet_okregow == 4 &
_0x435:
; 0000 1C9D                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 1C9E                         cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0 & powrot_przedwczesny_krazek_scierny == 0) | (wykonalem_komplet_okregow == 4 & koniec_rzedu_10 == 1 & powrot_przedwczesny_krazek_scierny == 0) )
	CALL SUBOPT_0x128
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xF0
	CALL SUBOPT_0x129
	AND  R0,R30
	CALL SUBOPT_0xF0
	OR   R30,R1
	BREQ _0x436
; 0000 1C9F                         {
; 0000 1CA0                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x105
; 0000 1CA1                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0xFF
; 0000 1CA2                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1CA3                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x10C
; 0000 1CA4                         cykl_sterownik_3 = 0;
; 0000 1CA5                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1CA6                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x11E
; 0000 1CA7                         krazek_scierny_cykl = 0;
; 0000 1CA8                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1CA9                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1CAA                         //PORTF = PORT_F.byte;
; 0000 1CAB                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1CAC                         cykl_glowny = 9;
	CALL SUBOPT_0x11F
; 0000 1CAD                         }
; 0000 1CAE }
_0x436:
	RET
;                                                                                                //ster 1 - ruch po okregu
;                                                                                                //ster 2 - nic
;                                                                                                //ster 3 - krazek - gora dol
;                                                                                                //ster 4 - druciak - gora dol
;
;
;void przypadek88()
; 0000 1CB6 {
_przypadek88:
; 0000 1CB7 
; 0000 1CB8                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xCE
	BRGE _0x439
; 0000 1CB9                         {
; 0000 1CBA                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xCF
; 0000 1CBB                         PORTF = PORT_F.byte;
; 0000 1CBC                         }
; 0000 1CBD 
; 0000 1CBE 
; 0000 1CBF                      if(rzad_obrabiany == 2)
_0x439:
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x43A
; 0000 1CC0                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1CC1 
; 0000 1CC2 
; 0000 1CC3 
; 0000 1CC4                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x43A:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD3
	BREQ _0x43B
; 0000 1CC5                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x6E
	CALL SUBOPT_0xD4
; 0000 1CC6                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x43B:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xB5
	BREQ _0x43C
; 0000 1CC7                         {
; 0000 1CC8                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1CC9                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0xD7
; 0000 1CCA                         }
; 0000 1CCB 
; 0000 1CCC 
; 0000 1CCD                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x43C:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD8
	AND  R30,R0
	BREQ _0x43D
; 0000 1CCE                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0xD9
; 0000 1CCF 
; 0000 1CD0                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x43D:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xDA
	AND  R30,R0
	BREQ _0x43E
; 0000 1CD1                         {
; 0000 1CD2                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1CD3                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0xDB
; 0000 1CD4                         }
; 0000 1CD5 
; 0000 1CD6                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x43E:
	CALL SUBOPT_0xDC
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x43F
; 0000 1CD7                         {
; 0000 1CD8                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1CD9                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0xDD
; 0000 1CDA                         }
; 0000 1CDB 
; 0000 1CDC                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1CDD                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x43F:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xDE
	AND  R30,R0
	BREQ _0x440
; 0000 1CDE                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0xDF
; 0000 1CDF 
; 0000 1CE0 
; 0000 1CE1                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x440:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xBB
	AND  R30,R0
	BREQ _0x441
; 0000 1CE2                         {
; 0000 1CE3                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1CE4                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0xE0
; 0000 1CE5                         }
; 0000 1CE6 
; 0000 1CE7                     if(cykl_sterownik_3 < 5 & wykonalem_komplet_okregow == 3)
_0x441:
	CALL SUBOPT_0xEE
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x10B
	BREQ _0x442
; 0000 1CE8                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV         //tu zmienienie INV, ¿eby szed³ w dol
	CALL SUBOPT_0x78
	CALL SUBOPT_0xF1
; 0000 1CE9 
; 0000 1CEA                      if(cykl_sterownik_3 == 5 & wykonalem_komplet_okregow == 3)
_0x442:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xD5
	CALL SUBOPT_0x12A
	AND  R30,R0
	BREQ _0x443
; 0000 1CEB                         {
; 0000 1CEC                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x120
; 0000 1CED                         krazek_scierny_cykl++;
; 0000 1CEE 
; 0000 1CEF                         if(krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x121
	BRNE _0x444
; 0000 1CF0                             {
; 0000 1CF1                             wykonalem_komplet_okregow = 4;
	CALL SUBOPT_0x122
; 0000 1CF2                             }
; 0000 1CF3                         else
	RJMP _0x445
_0x444:
; 0000 1CF4                             wykonalem_komplet_okregow = 0;
	CALL SUBOPT_0x123
; 0000 1CF5 
; 0000 1CF6                         cykl_sterownik_1 = 0;
_0x445:
	CALL SUBOPT_0xD6
; 0000 1CF7                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1CF8                         }
; 0000 1CF9 
; 0000 1CFA 
; 0000 1CFB 
; 0000 1CFC 
; 0000 1CFD 
; 0000 1CFE                     if(koniec_rzedu_10 == 1)
_0x443:
	CALL SUBOPT_0xD0
	BRNE _0x446
; 0000 1CFF                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xD1
; 0000 1D00                                                               //to nowy war, ostatni dzien w borg
; 0000 1D01                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze & koniec_rzedu_10 == 0)
_0x446:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL SUBOPT_0xE3
	CALL SUBOPT_0x10A
	CALL SUBOPT_0x124
	BREQ _0x447
; 0000 1D02                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x71
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xE6
; 0000 1D03 
; 0000 1D04                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x447:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE7
	CALL __LTW12
	AND  R0,R30
	CALL SUBOPT_0x10A
	CALL SUBOPT_0x125
	BREQ _0x448
; 0000 1D05                         {
; 0000 1D06                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0xE9
	BRNE _0x449
; 0000 1D07                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1D08                         if(abs_ster4 == 0)
_0x449:
	CALL SUBOPT_0xEB
	BRNE _0x44A
; 0000 1D09                             {
; 0000 1D0A                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x10E
	BRNE _0x44B
; 0000 1D0B                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1D0C                             szczotka_druc_cykl++;
_0x44B:
	CALL SUBOPT_0xEC
; 0000 1D0D                             abs_ster4 = 1;
; 0000 1D0E                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x10F
	CP   R4,R26
	CPC  R5,R27
	BRNE _0x44E
; 0000 1D0F                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0xD1
; 0000 1D10                             }
_0x44E:
; 0000 1D11                          else
	RJMP _0x44F
_0x44A:
; 0000 1D12                             {
; 0000 1D13                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1D14                             abs_ster4 = 0;
	CALL SUBOPT_0xED
; 0000 1D15                             sek13 = 0;
; 0000 1D16                             }
_0x44F:
; 0000 1D17                         }
; 0000 1D18 
; 0000 1D19 
; 0000 1D1A 
; 0000 1D1B                         if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x448:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	CALL SUBOPT_0x77
	AND  R0,R30
	CALL SUBOPT_0x10A
	CALL SUBOPT_0x125
	BREQ _0x452
; 0000 1D1C                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x74
	CALL SUBOPT_0x110
	CALL SUBOPT_0xE6
; 0000 1D1D 
; 0000 1D1E                         ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1D1F 
; 0000 1D20                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x452:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xF2
	CALL SUBOPT_0x118
	AND  R30,R0
	BREQ _0x453
; 0000 1D21                        {
; 0000 1D22                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1D23                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0xFB
; 0000 1D24                        }
; 0000 1D25                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x453:
	CALL SUBOPT_0xFC
	MOV  R0,R30
	CALL SUBOPT_0xEE
	CALL __LTW12
	AND  R30,R0
	BREQ _0x454
; 0000 1D26                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xFD
; 0000 1D27 
; 0000 1D28                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x454:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xFE
	AND  R30,R0
	BREQ _0x455
; 0000 1D29                        {
; 0000 1D2A                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0xFF
; 0000 1D2B                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1D2C                        }
; 0000 1D2D                    //////////////////////////////////////////////
; 0000 1D2E 
; 0000 1D2F 
; 0000 1D30 
; 0000 1D31                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1D32 
; 0000 1D33                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
_0x455:
	CALL SUBOPT_0x126
	CALL SUBOPT_0xE1
	CALL SUBOPT_0x127
	OR   R30,R0
	AND  R30,R1
	BREQ _0x458
; 0000 1D34                        {
; 0000 1D35                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1D36                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1D37                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x101
; 0000 1D38                        }
; 0000 1D39                   if(koniec_rzedu_10 == 0 & powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x458:
	CALL SUBOPT_0x126
	CALL SUBOPT_0x102
	AND  R0,R30
	CALL SUBOPT_0xE1
	CALL __LTW12
	AND  R30,R0
	BREQ _0x45B
; 0000 1D3A                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x103
	CALL SUBOPT_0xE6
; 0000 1D3B 
; 0000 1D3C                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x45B:
	CALL SUBOPT_0x126
	CALL SUBOPT_0xE1
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x102
	AND  R30,R0
	BREQ _0x45C
; 0000 1D3D                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x105
; 0000 1D3E                    //////////////////////////////////////////////
; 0000 1D3F 
; 0000 1D40                     if((wykonalem_komplet_okregow == 4 &
_0x45C:
; 0000 1D41                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 1D42                         cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0 & powrot_przedwczesny_krazek_scierny == 0) | (wykonalem_komplet_okregow == 4 & koniec_rzedu_10 == 1 & powrot_przedwczesny_krazek_scierny == 0) )
	CALL SUBOPT_0x128
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xF0
	CALL SUBOPT_0x129
	AND  R0,R30
	CALL SUBOPT_0xF0
	OR   R30,R1
	BREQ _0x45D
; 0000 1D43                         {
; 0000 1D44                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x105
; 0000 1D45                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0xFF
; 0000 1D46                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1D47                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x10C
; 0000 1D48                         cykl_sterownik_3 = 0;
; 0000 1D49                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1D4A                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x11E
; 0000 1D4B                         krazek_scierny_cykl = 0;
; 0000 1D4C                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1D4D                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1D4E                         //PORTF = PORT_F.byte;
; 0000 1D4F                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1D50                         cykl_glowny = 9;
	CALL SUBOPT_0x11F
; 0000 1D51                         }
; 0000 1D52 
; 0000 1D53                                                                                                 //ster 1 - ruch po okregu
; 0000 1D54                                                                                                 //ster 2 - nic
; 0000 1D55                                                                                                 //ster 3 - krazek - gora dol
; 0000 1D56                                                                                                 //ster 4 - druciak - gora dol
; 0000 1D57 
; 0000 1D58 
; 0000 1D59 }
_0x45D:
	RET
;
;
;void main(void)
; 0000 1D5D {
_main:
; 0000 1D5E 
; 0000 1D5F // Input/Output Ports initialization
; 0000 1D60 // Port A initialization
; 0000 1D61 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1D62 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1D63 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 1D64 DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 1D65 
; 0000 1D66 // Port B initialization
; 0000 1D67 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1D68 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1D69 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 1D6A DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 1D6B 
; 0000 1D6C // Port C initialization
; 0000 1D6D // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1D6E // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1D6F PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 1D70 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 1D71 
; 0000 1D72 // Port D initialization
; 0000 1D73 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1D74 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1D75 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 1D76 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 1D77 
; 0000 1D78 // Port E initialization
; 0000 1D79 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1D7A // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1D7B PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 1D7C DDRE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 1D7D 
; 0000 1D7E // Port F initialization
; 0000 1D7F // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1D80 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1D81 PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 1D82 DDRF=0xFF;
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 1D83 
; 0000 1D84 // Port G initialization
; 0000 1D85 // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1D86 // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1D87 PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 1D88 DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 1D89 
; 0000 1D8A 
; 0000 1D8B 
; 0000 1D8C 
; 0000 1D8D 
; 0000 1D8E // Timer/Counter 0 initialization
; 0000 1D8F // Clock source: System Clock
; 0000 1D90 // Clock value: 15,625 kHz
; 0000 1D91 // Mode: Normal top=0xFF
; 0000 1D92 // OC0 output: Disconnected
; 0000 1D93 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 1D94 TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 1D95 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 1D96 OCR0=0x00;
	OUT  0x31,R30
; 0000 1D97 
; 0000 1D98 // Timer/Counter 1 initialization
; 0000 1D99 // Clock source: System Clock
; 0000 1D9A // Clock value: Timer1 Stopped
; 0000 1D9B // Mode: Normal top=0xFFFF
; 0000 1D9C // OC1A output: Discon.
; 0000 1D9D // OC1B output: Discon.
; 0000 1D9E // OC1C output: Discon.
; 0000 1D9F // Noise Canceler: Off
; 0000 1DA0 // Input Capture on Falling Edge
; 0000 1DA1 // Timer1 Overflow Interrupt: Off
; 0000 1DA2 // Input Capture Interrupt: Off
; 0000 1DA3 // Compare A Match Interrupt: Off
; 0000 1DA4 // Compare B Match Interrupt: Off
; 0000 1DA5 // Compare C Match Interrupt: Off
; 0000 1DA6 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 1DA7 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 1DA8 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 1DA9 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 1DAA ICR1H=0x00;
	OUT  0x27,R30
; 0000 1DAB ICR1L=0x00;
	OUT  0x26,R30
; 0000 1DAC OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 1DAD OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 1DAE OCR1BH=0x00;
	OUT  0x29,R30
; 0000 1DAF OCR1BL=0x00;
	OUT  0x28,R30
; 0000 1DB0 OCR1CH=0x00;
	STS  121,R30
; 0000 1DB1 OCR1CL=0x00;
	STS  120,R30
; 0000 1DB2 
; 0000 1DB3 // Timer/Counter 2 initialization
; 0000 1DB4 // Clock source: System Clock
; 0000 1DB5 // Clock value: Timer2 Stopped
; 0000 1DB6 // Mode: Normal top=0xFF
; 0000 1DB7 // OC2 output: Disconnected
; 0000 1DB8 TCCR2=0x00;
	OUT  0x25,R30
; 0000 1DB9 TCNT2=0x00;
	OUT  0x24,R30
; 0000 1DBA OCR2=0x00;
	OUT  0x23,R30
; 0000 1DBB 
; 0000 1DBC // Timer/Counter 3 initialization
; 0000 1DBD // Clock source: System Clock
; 0000 1DBE // Clock value: Timer3 Stopped
; 0000 1DBF // Mode: Normal top=0xFFFF
; 0000 1DC0 // OC3A output: Discon.
; 0000 1DC1 // OC3B output: Discon.
; 0000 1DC2 // OC3C output: Discon.
; 0000 1DC3 // Noise Canceler: Off
; 0000 1DC4 // Input Capture on Falling Edge
; 0000 1DC5 // Timer3 Overflow Interrupt: Off
; 0000 1DC6 // Input Capture Interrupt: Off
; 0000 1DC7 // Compare A Match Interrupt: Off
; 0000 1DC8 // Compare B Match Interrupt: Off
; 0000 1DC9 // Compare C Match Interrupt: Off
; 0000 1DCA TCCR3A=0x00;
	STS  139,R30
; 0000 1DCB TCCR3B=0x00;
	STS  138,R30
; 0000 1DCC TCNT3H=0x00;
	STS  137,R30
; 0000 1DCD TCNT3L=0x00;
	STS  136,R30
; 0000 1DCE ICR3H=0x00;
	STS  129,R30
; 0000 1DCF ICR3L=0x00;
	STS  128,R30
; 0000 1DD0 OCR3AH=0x00;
	STS  135,R30
; 0000 1DD1 OCR3AL=0x00;
	STS  134,R30
; 0000 1DD2 OCR3BH=0x00;
	STS  133,R30
; 0000 1DD3 OCR3BL=0x00;
	STS  132,R30
; 0000 1DD4 OCR3CH=0x00;
	STS  131,R30
; 0000 1DD5 OCR3CL=0x00;
	STS  130,R30
; 0000 1DD6 
; 0000 1DD7 // External Interrupt(s) initialization
; 0000 1DD8 // INT0: Off
; 0000 1DD9 // INT1: Off
; 0000 1DDA // INT2: Off
; 0000 1DDB // INT3: Off
; 0000 1DDC // INT4: Off
; 0000 1DDD // INT5: Off
; 0000 1DDE // INT6: Off
; 0000 1DDF // INT7: Off
; 0000 1DE0 EICRA=0x00;
	STS  106,R30
; 0000 1DE1 EICRB=0x00;
	OUT  0x3A,R30
; 0000 1DE2 EIMSK=0x00;
	OUT  0x39,R30
; 0000 1DE3 
; 0000 1DE4 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 1DE5 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 1DE6 
; 0000 1DE7 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 1DE8 
; 0000 1DE9 
; 0000 1DEA // USART0 initialization
; 0000 1DEB // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 1DEC // USART0 Receiver: On
; 0000 1DED // USART0 Transmitter: On
; 0000 1DEE // USART0 Mode: Asynchronous
; 0000 1DEF // USART0 Baud Rate: 115200
; 0000 1DF0 //UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
; 0000 1DF1 //UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
; 0000 1DF2 //UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
; 0000 1DF3 //UBRR0H=0x00;
; 0000 1DF4 //UBRR0L=0x08;
; 0000 1DF5 
; 0000 1DF6 // USART0 initialization
; 0000 1DF7 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 1DF8 // USART0 Receiver: On
; 0000 1DF9 // USART0 Transmitter: On
; 0000 1DFA // USART0 Mode: Asynchronous
; 0000 1DFB // USART0 Baud Rate: 9600
; 0000 1DFC UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 1DFD UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 1DFE UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 1DFF UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 1E00 UBRR0L=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 1E01 
; 0000 1E02 
; 0000 1E03 
; 0000 1E04 
; 0000 1E05 
; 0000 1E06 // USART1 initialization
; 0000 1E07 // USART1 disabled
; 0000 1E08 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 1E09 
; 0000 1E0A // Analog Comparator initialization
; 0000 1E0B // Analog Comparator: Off
; 0000 1E0C // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 1E0D ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 1E0E SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 1E0F 
; 0000 1E10 // ADC initialization
; 0000 1E11 // ADC disabled
; 0000 1E12 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 1E13 
; 0000 1E14 // SPI initialization
; 0000 1E15 // SPI disabled
; 0000 1E16 SPCR=0x00;
	OUT  0xD,R30
; 0000 1E17 
; 0000 1E18 // TWI initialization
; 0000 1E19 // TWI disabled
; 0000 1E1A TWCR=0x00;
	STS  116,R30
; 0000 1E1B 
; 0000 1E1C //ciekawe, tej linijki brakowalo w medalach ,wyczailem w borgu
; 0000 1E1D // I2C Bus initialization
; 0000 1E1E i2c_init();
	CALL _i2c_init
; 0000 1E1F 
; 0000 1E20 // Global enable interrupts
; 0000 1E21 #asm("sei")
	sei
; 0000 1E22 
; 0000 1E23 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x12B
; 0000 1E24 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x12B
; 0000 1E25 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x12B
; 0000 1E26 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x12B
; 0000 1E27 
; 0000 1E28 //jak patrze na maszyne to ten po lewej to 1
; 0000 1E29 
; 0000 1E2A putchar(90);  //5A
	CALL SUBOPT_0x2
; 0000 1E2B putchar(165); //A5
; 0000 1E2C putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _putchar
; 0000 1E2D putchar(128);  //80
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _putchar
; 0000 1E2E putchar(2);    //02
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
; 0000 1E2F putchar(16);   //10
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
; 0000 1E30 
; 0000 1E31 il_prob_odczytu = 1;    //100
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _il_prob_odczytu,R30
	STS  _il_prob_odczytu+1,R31
; 0000 1E32 start = 0;
	LDI  R30,LOW(0)
	STS  _start,R30
	STS  _start+1,R30
; 0000 1E33 rzad_obrabiany = 1;
	CALL SUBOPT_0x12C
; 0000 1E34 jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 1E35 wykonalem_rzedow = 0;
	CALL SUBOPT_0x12D
; 0000 1E36 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x12E
; 0000 1E37 guzik1_przelaczania_zaciskow = 1;
	SET
	BLD  R2,0
; 0000 1E38 guzik2_przelaczania_zaciskow = 1;
	BLD  R2,1
; 0000 1E39 //PORTE.6 = 1;  //aby byl dostep do zaciskow rzad 1
; 0000 1E3A zmienna_przelaczanie_zaciskow = 1;
	BLD  R2,2
; 0000 1E3B czas_przedmuchu = 183;
	LDI  R30,LOW(183)
	LDI  R31,HIGH(183)
	STS  _czas_przedmuchu,R30
	STS  _czas_przedmuchu+1,R31
; 0000 1E3C predkosc_pion_szczotka = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 1E3D predkosc_pion_krazek = 100;
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 1E3E wejscie_krazka_sciernego_w_pow_boczna_cylindra = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 1E3F predkosc_ruchow_po_okregu_krazek_scierny = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 1E40 czas_druciaka_na_gorze = 100;  //1 sekundy dla druciaka na gorze aby dolek zrobil git (kiedyS), zmieniam na 3s
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _czas_druciaka_na_gorze,R30
	STS  _czas_druciaka_na_gorze+1,R31
; 0000 1E41 czas_zatrzymania_na_dole = 120;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	STS  _czas_zatrzymania_na_dole,R30
	STS  _czas_zatrzymania_na_dole+1,R31
; 0000 1E42 srednica_wew_korpusu_cyklowa = 0;
	LDI  R30,LOW(0)
	STS  _srednica_wew_korpusu_cyklowa,R30
	STS  _srednica_wew_korpusu_cyklowa+1,R30
; 0000 1E43 
; 0000 1E44 adr1 = 80;  //rzad 1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STS  _adr1,R30
	STS  _adr1+1,R31
; 0000 1E45 adr2 = 0;   //
	LDI  R30,LOW(0)
	STS  _adr2,R30
	STS  _adr2+1,R30
; 0000 1E46 adr3 = 64;  //rzad 2
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STS  _adr3,R30
	STS  _adr3+1,R31
; 0000 1E47 adr4 = 0;
	LDI  R30,LOW(0)
	STS  _adr4,R30
	STS  _adr4+1,R30
; 0000 1E48 
; 0000 1E49 //na sekunde
; 0000 1E4A //wartosci_wstepne_wgrac_tylko_raz(0);
; 0000 1E4B 
; 0000 1E4C //while(1)
; 0000 1E4D //{
; 0000 1E4E //}
; 0000 1E4F 
; 0000 1E50 wartosci_wstepne_panelu();
	CALL _wartosci_wstepne_panelu
; 0000 1E51 
; 0000 1E52 //wypozycjonuj_napedy_minimalistyczna();
; 0000 1E53 //sprawdz_cisnienie();
; 0000 1E54 
; 0000 1E55 //SPRAWDZAM CO SIE DZIEJE CO CYKL, TO LICZENIE SZCZOTKI I KRAZKA
; 0000 1E56 
; 0000 1E57 while (1)
_0x460:
; 0000 1E58       {
; 0000 1E59       //ostateczny_wybor_zacisku();
; 0000 1E5A       //przerzucanie_dociskow();
; 0000 1E5B       //kontrola_zoltego_swiatla();
; 0000 1E5C       //wymiana_szczotki_i_krazka();
; 0000 1E5D       //zaktualizuj_parametry_panelu();
; 0000 1E5E 
; 0000 1E5F         //to wylaczam tylko do testow w switniakch, wewnatrz tego wylaczam 4 pierwsze linijki
; 0000 1E60       odpytaj_parametry_panelu();
	CALL _odpytaj_parametry_panelu
; 0000 1E61 
; 0000 1E62 
; 0000 1E63       //test_geometryczny();
; 0000 1E64       //sprawdz_cisnienie();
; 0000 1E65 
; 0000 1E66       zapis_probny_test();
	CALL _zapis_probny_test
; 0000 1E67 
; 0000 1E68 
; 0000 1E69 
; 0000 1E6A       while((start == 1 & il_zaciskow_rzad_1 > 1 & il_zaciskow_rzad_2 != 1 & macierz_zaciskow[1]!=0  & (macierz_zaciskow[2]!=0 |  il_zaciskow_rzad_2 == 0)) | jestem_w_trakcie_czyszczenia_calosci == 1)
_0x463:
	CALL SUBOPT_0xBC
	CALL SUBOPT_0x77
	CALL SUBOPT_0x12F
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __GTW12
	AND  R0,R30
	CALL SUBOPT_0x130
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	AND  R0,R30
	__GETW1MN _macierz_zaciskow,2
	CALL SUBOPT_0x131
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0x132
	CALL SUBOPT_0x133
	CALL __EQW12
	OR   R30,R0
	AND  R30,R1
	MOV  R0,R30
	LDS  R26,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R27,_jestem_w_trakcie_czyszczenia_calosci+1
	CALL SUBOPT_0x77
	OR   R30,R0
	BRNE PC+3
	JMP _0x465
; 0000 1E6B             {
; 0000 1E6C             switch (cykl_glowny)
	LDS  R30,_cykl_glowny
	LDS  R31,_cykl_glowny+1
; 0000 1E6D             {
; 0000 1E6E             case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x469
; 0000 1E6F 
; 0000 1E70 
; 0000 1E71                     PORTB.6 = 1;   ////zielona lampka
	SBI  0x18,6
; 0000 1E72                     if(jestem_w_trakcie_czyszczenia_calosci == 0)
	LDS  R30,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R31,_jestem_w_trakcie_czyszczenia_calosci+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x46C
; 0000 1E73                         {
; 0000 1E74                         //PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1E75 
; 0000 1E76                         srednica_wew_korpusu_cyklowa = srednica_wew_korpusu;
	LDS  R30,_srednica_wew_korpusu
	LDS  R31,_srednica_wew_korpusu+1
	CALL SUBOPT_0xA8
; 0000 1E77 
; 0000 1E78                         wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x14
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x9B
; 0000 1E79                         wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad2
	CALL SUBOPT_0x14
	CALL SUBOPT_0x18
	CALL SUBOPT_0x9B
; 0000 1E7A 
; 0000 1E7B                         il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
	CALL SUBOPT_0x24
	CALL _odczytaj_parametr
	STS  _il_zaciskow_rzad_1,R30
	STS  _il_zaciskow_rzad_1+1,R31
; 0000 1E7C                         il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x11
	CALL _odczytaj_parametr
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
; 0000 1E7D 
; 0000 1E7E 
; 0000 1E7F                         szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64) - 1;  //wykonano zaciskow rzad1
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	SBIW R30,1
	MOVW R4,R30
; 0000 1E80 
; 0000 1E81                         tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1E
	MOVW R10,R30
; 0000 1E82 
; 0000 1E83                         if(tryb_pracy_szczotki_drucianej == 1)
	CALL SUBOPT_0x70
	BRNE _0x46D
; 0000 1E84                             szczotka_druciana_ilosc_cykli = 1; //zmieniam bo teraz inny ruch szczotki drucianej, jeden schodek na dole
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 1E85                         if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)
_0x46D:
	CALL SUBOPT_0x73
	BREQ _0x46E
; 0000 1E86                             czas_druciaka_na_gorze = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _czas_druciaka_na_gorze,R30
	STS  _czas_druciaka_na_gorze+1,R31
; 0000 1E87 
; 0000 1E88                                                 //2090
; 0000 1E89                         krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);  //wykonano zaciskow rzad1
_0x46E:
	CALL SUBOPT_0x23
	CALL SUBOPT_0x16
	MOVW R6,R30
; 0000 1E8A                                                     //3000
; 0000 1E8B 
; 0000 1E8C                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL _odczytaj_parametr
	MOVW R8,R30
; 0000 1E8D 
; 0000 1E8E                         if(krazek_scierny_cykl_po_okregu_ilosc == 0)
	MOV  R0,R8
	OR   R0,R9
	BRNE _0x46F
; 0000 1E8F                             {
; 0000 1E90                             krazek_scierny_ilosc_cykli--;
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
; 0000 1E91                             }
; 0000 1E92 
; 0000 1E93                         predkosc_pion_szczotka = odczytaj_parametr(32,80);
_0x46F:
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1B
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 1E94                                                 //2060
; 0000 1E95                         predkosc_pion_krazek = odczytaj_parametr(32,96);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x18
	CALL _odczytaj_parametr
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 1E96 
; 0000 1E97                         wejscie_krazka_sciernego_w_pow_boczna_cylindra = odczytaj_parametr(48,16);
	CALL SUBOPT_0x11
	CALL SUBOPT_0xA0
	CALL _odczytaj_parametr
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 1E98 
; 0000 1E99                         predkosc_ruchow_po_okregu_krazek_scierny = odczytaj_parametr(32,112);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1E
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 1E9A 
; 0000 1E9B                         srednica_krazka_sciernego = odczytaj_parametr(48,112);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x20
; 0000 1E9C 
; 0000 1E9D                         ruch_haos = odczytaj_parametr(48,144);
	CALL SUBOPT_0x16
	STS  _ruch_haos,R30
	STS  _ruch_haos+1,R31
; 0000 1E9E 
; 0000 1E9F                         statystyka = odczytaj_parametr(128,64);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x12
	STS  _statystyka,R30
	STS  _statystyka+1,R31
; 0000 1EA0 
; 0000 1EA1                         if(il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0)
	CALL SUBOPT_0x130
	CALL SUBOPT_0x134
	MOV  R0,R30
	CALL SUBOPT_0x132
	AND  R30,R0
	BREQ _0x470
; 0000 1EA2                               il_zaciskow_rzad_2 = il_zaciskow_rzad_2;
	CALL SUBOPT_0x135
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
; 0000 1EA3                         else
	RJMP _0x471
_0x470:
; 0000 1EA4                               il_zaciskow_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R30
; 0000 1EA5 
; 0000 1EA6                         wybor_linijek_sterownikow(1);  //rzad 1
_0x471:
	CALL SUBOPT_0xAF
	CALL _wybor_linijek_sterownikow
; 0000 1EA7                         }
; 0000 1EA8 
; 0000 1EA9                     jestem_w_trakcie_czyszczenia_calosci = 1;
_0x46C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R31
; 0000 1EAA 
; 0000 1EAB                     if(rzad_obrabiany == 1)
	CALL SUBOPT_0x90
	SBIW R26,1
	BRNE _0x472
; 0000 1EAC                     {
; 0000 1EAD                     PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
	CBI  0x3,6
; 0000 1EAE                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x136
	BRGE _0x475
; 0000 1EAF                         cykl_sterownik_1 = sterownik_1_praca(0x009);
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL SUBOPT_0xD4
; 0000 1EB0                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x475:
	CALL SUBOPT_0x137
	BRGE _0x476
; 0000 1EB1                         cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x14
	CALL SUBOPT_0x138
; 0000 1EB2                     }
_0x476:
; 0000 1EB3 
; 0000 1EB4                     if(rzad_obrabiany == 2)
_0x472:
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x477
; 0000 1EB5                     {
; 0000 1EB6                     ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1EB7                     //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2 - na razie nie bo nie ma jeszcze oslon
; 0000 1EB8 
; 0000 1EB9                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x136
	BRGE _0x478
; 0000 1EBA                         cykl_sterownik_1 = sterownik_1_praca(0x008);
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0xD4
; 0000 1EBB                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x478:
	CALL SUBOPT_0x137
	BRGE _0x479
; 0000 1EBC                         cykl_sterownik_2 = sterownik_2_praca(0x001);       //ster 2 pod pin pozy rzad 2
	CALL SUBOPT_0xAF
	CALL SUBOPT_0x138
; 0000 1EBD                     }
_0x479:
; 0000 1EBE 
; 0000 1EBF 
; 0000 1EC0                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x477:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0x139
	AND  R30,R0
	BREQ _0x47A
; 0000 1EC1                         {
; 0000 1EC2 
; 0000 1EC3                           if(rzad_obrabiany == 2)
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x47B
; 0000 1EC4                             {
; 0000 1EC5                             while(PORTE.6 == 0)
_0x47C:
	SBIC 0x3,6
	RJMP _0x47E
; 0000 1EC6                                 przerzucanie_dociskow();
	CALL _przerzucanie_dociskow
	RJMP _0x47C
_0x47E:
; 0000 1EC7 delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	CALL SUBOPT_0xB1
; 0000 1EC8                             }
; 0000 1EC9 
; 0000 1ECA                         delay_ms(2000);  //aby zdazyl przelozyc
_0x47B:
	CALL SUBOPT_0x12B
; 0000 1ECB                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1ECC                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x10C
; 0000 1ECD                         cykl_sterownik_3 = 0;
; 0000 1ECE                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1ECF                         cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x12E
; 0000 1ED0                         koniec_rzedu_10 = 0;
	CALL SUBOPT_0x13A
; 0000 1ED1                         cykl_glowny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x13B
; 0000 1ED2                         }
; 0000 1ED3 
; 0000 1ED4             break;
_0x47A:
	RJMP _0x468
; 0000 1ED5 
; 0000 1ED6 
; 0000 1ED7 
; 0000 1ED8             case 1:
_0x469:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x47F
; 0000 1ED9 
; 0000 1EDA 
; 0000 1EDB                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 1)
	CALL SUBOPT_0x13C
	CALL SUBOPT_0x13D
	AND  R30,R0
	BREQ _0x480
; 0000 1EDC                           {          //ster 1 nic
; 0000 1EDD                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 1EDE                           cykl_sterownik_2 = sterownik_2_praca(a[0]);        //ster 2 pod zacisk
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x13E
; 0000 1EDF                           }                                                    //ster 4 na pozycje miedzy rzedzami
; 0000 1EE0 
; 0000 1EE1                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 2)
_0x480:
	CALL SUBOPT_0x13C
	CALL SUBOPT_0x94
	AND  R30,R0
	BREQ _0x483
; 0000 1EE2                         {
; 0000 1EE3                         //cykl_sterownik_2 = sterownik_2_praca(0x5B,0);
; 0000 1EE4                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 1EE5                           ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1EE6                           cykl_sterownik_2 = sterownik_2_praca(a[1]);
	__GETW1MN _a,2
	CALL SUBOPT_0x13E
; 0000 1EE7                          }
; 0000 1EE8                      if(cykl_sterownik_4 < 5 & cykl_sterownik_2 == 5)
_0x483:
	CALL SUBOPT_0xE1
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x13F
	AND  R30,R0
	BREQ _0x486
; 0000 1EE9                        // cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);
; 0000 1EEA                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0x103
	CALL SUBOPT_0xE6
; 0000 1EEB 
; 0000 1EEC                       if(cykl_sterownik_2 == 5 & cykl_sterownik_4 == 5)
_0x486:
	CALL SUBOPT_0x13F
	MOV  R0,R30
	CALL SUBOPT_0xE1
	CALL __EQW12
	AND  R30,R0
	BREQ _0x487
; 0000 1EED                         {
; 0000 1EEE                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1EEF                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x140
; 0000 1EF0                         cykl_sterownik_4 = 0;
; 0000 1EF1                         szczotka_druc_cykl = 0;
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
; 0000 1EF2                         cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x13B
; 0000 1EF3                         }
; 0000 1EF4 
; 0000 1EF5 
; 0000 1EF6             break;
_0x487:
	RJMP _0x468
; 0000 1EF7 
; 0000 1EF8 
; 0000 1EF9             case 2:
_0x47F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x488
; 0000 1EFA                     if(rzad_obrabiany == 2)
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x489
; 0000 1EFB                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1EFC 
; 0000 1EFD                     if(cykl_sterownik_4 < 5)
_0x489:
	CALL SUBOPT_0x141
	BRGE _0x48A
; 0000 1EFE                           cykl_sterownik_4 = sterownik_4_praca(a[2],1);
	CALL SUBOPT_0x74
	CALL SUBOPT_0x110
	CALL SUBOPT_0xE6
; 0000 1EFF                     if(cykl_sterownik_4 == 5)
_0x48A:
	CALL SUBOPT_0x141
	BRNE _0x48B
; 0000 1F00                         {
; 0000 1F01                         PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1F02                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1F03 
; 0000 1F04                         //if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
; 0000 1F05                         //     cykl_sterownik_4 = 5;
; 0000 1F06 
; 0000 1F07                         sek13 = 0;
	CALL SUBOPT_0x142
; 0000 1F08                         cykl_glowny = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x13B
; 0000 1F09                         }
; 0000 1F0A             break;
_0x48B:
	RJMP _0x468
; 0000 1F0B 
; 0000 1F0C 
; 0000 1F0D             case 3:
_0x488:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x48E
; 0000 1F0E 
; 0000 1F0F                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x48F
; 0000 1F10                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F11 
; 0000 1F12                     if(cykl_sterownik_4 < 5 & sek13 > czas_druciaka_na_gorze & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x48F:
	CALL SUBOPT_0xE1
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
	CALL SUBOPT_0x143
	BREQ _0x490
; 0000 1F13                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV
	CALL SUBOPT_0x71
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xE6
; 0000 1F14 
; 0000 1F15                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x490:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE7
	CALL __LTW12
	AND  R30,R0
	BREQ _0x491
; 0000 1F16                         {
; 0000 1F17                         szczotka_druc_cykl++;
	CALL SUBOPT_0x111
; 0000 1F18                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1F19 
; 0000 1F1A                         if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
	MOVW R26,R10
	CALL SUBOPT_0xBB
	MOV  R0,R30
	MOVW R26,R10
	CALL SUBOPT_0x12A
	OR   R0,R30
	MOVW R30,R4
	CALL SUBOPT_0x10F
	CALL __EQW12
	AND  R30,R0
	BREQ _0x492
; 0000 1F1B                             cykl_sterownik_4 = 5;
	CALL SUBOPT_0xD1
; 0000 1F1C 
; 0000 1F1D 
; 0000 1F1E 
; 0000 1F1F                         if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x492:
	MOVW R26,R10
	CALL SUBOPT_0xBB
	MOV  R0,R30
	MOVW R26,R10
	CALL SUBOPT_0x12A
	OR   R0,R30
	CALL SUBOPT_0x143
	BREQ _0x493
; 0000 1F20                                {
; 0000 1F21                                cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x13B
; 0000 1F22                                if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x10E
	BRNE _0x494
; 0000 1F23                                    PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1F24                                }
_0x494:
; 0000 1F25                         }
_0x493:
; 0000 1F26 
; 0000 1F27                     if(cykl_sterownik_4 < 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & tryb_pracy_szczotki_drucianej == 1)
_0x491:
	CALL SUBOPT_0xE1
	CALL __LTW12
	MOV  R0,R30
	MOVW R30,R4
	CALL SUBOPT_0x10F
	CALL __EQW12
	AND  R0,R30
	MOVW R26,R10
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x497
; 0000 1F28                          cykl_sterownik_4 = sterownik_4_praca(0x03,0); //INV
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xE6
; 0000 1F29 
; 0000 1F2A 
; 0000 1F2B 
; 0000 1F2C                         if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
_0x497:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE7
	CALL __EQW12
	AND  R30,R0
	BREQ _0x498
; 0000 1F2D                             {
; 0000 1F2E                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1F2F                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1F30                             cykl_glowny = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x13B
; 0000 1F31                             }
; 0000 1F32 
; 0000 1F33             break;
_0x498:
	RJMP _0x468
; 0000 1F34 
; 0000 1F35             case 4:
_0x48E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x49B
; 0000 1F36 
; 0000 1F37 
; 0000 1F38                       if(rzad_obrabiany == 2)
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x49C
; 0000 1F39                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F3A 
; 0000 1F3B                      if(cykl_sterownik_4 < 5)
_0x49C:
	CALL SUBOPT_0x141
	BRGE _0x49D
; 0000 1F3C                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0x103
	CALL SUBOPT_0xE6
; 0000 1F3D 
; 0000 1F3E                      if(cykl_sterownik_4 == 5)
_0x49D:
	CALL SUBOPT_0x141
	BRNE _0x49E
; 0000 1F3F                         {
; 0000 1F40                         PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1F41                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1F42                         ruch_zlozony = 0;
	LDI  R30,LOW(0)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R30
; 0000 1F43                         cykl_glowny = 5;
	CALL SUBOPT_0x144
; 0000 1F44                         }
; 0000 1F45 
; 0000 1F46             break;
_0x49E:
	RJMP _0x468
; 0000 1F47 
; 0000 1F48             case 5:
_0x49B:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4A1
; 0000 1F49 
; 0000 1F4A 
; 0000 1F4B                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 1)
	CALL SUBOPT_0xD2
	CALL SUBOPT_0x145
	CALL SUBOPT_0x13D
	AND  R30,R0
	BREQ _0x4A2
; 0000 1F4C                         cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0x14
	CALL _sterownik_1_praca
	CALL SUBOPT_0xC2
; 0000 1F4D                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 2)
_0x4A2:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0x145
	CALL SUBOPT_0x94
	AND  R30,R0
	BREQ _0x4A3
; 0000 1F4E                         cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xAF
	CALL _sterownik_1_praca
	CALL SUBOPT_0xC2
; 0000 1F4F 
; 0000 1F50                      if(rzad_obrabiany == 2)
_0x4A3:
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x4A4
; 0000 1F51                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F52 
; 0000 1F53                     if(cykl_sterownik_1 == 5 & ruch_zlozony == 0)
_0x4A4:
	CALL SUBOPT_0xD2
	CALL __EQW12
	CALL SUBOPT_0x146
	CALL SUBOPT_0xB5
	BREQ _0x4A5
; 0000 1F54                         {
; 0000 1F55                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1F56                         ruch_zlozony = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 1F57                         }
; 0000 1F58 
; 0000 1F59                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 1)
_0x4A5:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0x147
	CALL SUBOPT_0x77
	AND  R0,R30
	CALL SUBOPT_0x13D
	AND  R30,R0
	BREQ _0x4A6
; 0000 1F5A                         cykl_sterownik_1 = sterownik_1_praca(a[0]);
	CALL SUBOPT_0x6C
	CALL SUBOPT_0xD4
; 0000 1F5B                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 2)
_0x4A6:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0x147
	CALL SUBOPT_0x77
	AND  R0,R30
	CALL SUBOPT_0x94
	AND  R30,R0
	BREQ _0x4A7
; 0000 1F5C                           cykl_sterownik_1 = sterownik_1_praca(a[1]);
	__GETW1MN _a,2
	CALL SUBOPT_0xD4
; 0000 1F5D 
; 0000 1F5E 
; 0000 1F5F                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 2)
_0x4A7:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0x147
	CALL SUBOPT_0xBB
	AND  R30,R0
	BREQ _0x4A8
; 0000 1F60                         cykl_sterownik_1 = sterownik_1_praca(0x003);     ////////////////////////////////////////////////////////////
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xD4
; 0000 1F61 
; 0000 1F62                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 0)                                //ster 1 do pierwszego dolka
_0x4A8:
	CALL SUBOPT_0x13C
	CALL SUBOPT_0x125
	BREQ _0x4A9
; 0000 1F63                         cykl_sterownik_2 = sterownik_2_praca(0x003);       //ster 2 pod nastpeny dolek
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x13E
; 0000 1F64 
; 0000 1F65 
; 0000 1F66                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 1)
_0x4A9:
	CALL SUBOPT_0x13C
	CALL SUBOPT_0x148
	AND  R0,R30
	CALL SUBOPT_0x13D
	AND  R30,R0
	BREQ _0x4AA
; 0000 1F67                         cykl_sterownik_2 = sterownik_2_praca(0x008);      //ster 2 do samego tylu
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x13E
; 0000 1F68                      if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 2)
_0x4AA:
	CALL SUBOPT_0x13C
	CALL SUBOPT_0x148
	AND  R0,R30
	CALL SUBOPT_0x94
	AND  R30,R0
	BREQ _0x4AB
; 0000 1F69                         cykl_sterownik_2 = sterownik_2_praca(0x009);      //ster 2 do samego tylu
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL SUBOPT_0x13E
; 0000 1F6A 
; 0000 1F6B                     if((cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5 & ruch_zlozony == 1) | (cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5) & ruch_zlozony == 2)
_0x4AB:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0x139
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0x77
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0xD2
	CALL SUBOPT_0x139
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0xBB
	AND  R30,R0
	OR   R30,R1
	BREQ _0x4AC
; 0000 1F6C                         {
; 0000 1F6D                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1F6E                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x140
; 0000 1F6F                         cykl_sterownik_4 = 0;
; 0000 1F70                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1F71                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
	SBI  0x3,3
; 0000 1F72                         cykl_glowny = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x13B
; 0000 1F73                         }
; 0000 1F74 
; 0000 1F75             break;
_0x4AC:
	RJMP _0x468
; 0000 1F76 
; 0000 1F77             case 6:
_0x4A1:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4AF
; 0000 1F78 
; 0000 1F79                     if(cykl_sterownik_3 < 5)
	LDS  R26,_cykl_sterownik_3
	LDS  R27,_cykl_sterownik_3+1
	SBIW R26,5
	BRGE _0x4B0
; 0000 1F7A                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs //krazek scierny do gory
	CALL SUBOPT_0x6D
	CALL SUBOPT_0xF1
; 0000 1F7B 
; 0000 1F7C                     if(koniec_rzedu_10 == 1)
_0x4B0:
	CALL SUBOPT_0xD0
	BRNE _0x4B1
; 0000 1F7D                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0xD1
; 0000 1F7E 
; 0000 1F7F                     if(cykl_sterownik_4 < 5)
_0x4B1:
	CALL SUBOPT_0x141
	BRGE _0x4B2
; 0000 1F80                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);    //ABS          //druciak do gory
	CALL SUBOPT_0x74
	CALL SUBOPT_0x110
	CALL SUBOPT_0xE6
; 0000 1F81 
; 0000 1F82                      if(rzad_obrabiany == 2)
_0x4B2:
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x4B3
; 0000 1F83                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F84 
; 0000 1F85 
; 0000 1F86                     if(cykl_sterownik_4 == 5 & cykl_sterownik_3 == 5)
_0x4B3:
	CALL SUBOPT_0xE1
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0xEE
	CALL __EQW12
	AND  R30,R0
	BREQ _0x4B4
; 0000 1F87                         {
; 0000 1F88                         if((cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1 & rzad_obrabiany == 1) | (cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1 & rzad_obrabiany == 2))
	CALL SUBOPT_0x149
	MOV  R0,R30
	CALL SUBOPT_0x13D
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0x14A
	MOV  R0,R30
	CALL SUBOPT_0x94
	AND  R30,R0
	OR   R30,R1
	BREQ _0x4B5
; 0000 1F89                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1F8A 
; 0000 1F8B                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
_0x4B5:
	SBI  0x3,3
; 0000 1F8C                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1F8D                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 1F8E                         if(cykl_ilosc_zaciskow > 0)
	CALL SUBOPT_0x14B
	CALL __CPW02
	BRGE _0x4BA
; 0000 1F8F                                 {
; 0000 1F90                                 sek12 = 0;    //do przedmuchu
	CALL SUBOPT_0x14C
; 0000 1F91                                 PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x14D
; 0000 1F92                                 PORTF = PORT_F.byte;
; 0000 1F93                                 }
; 0000 1F94                         sek13 = 0;
_0x4BA:
	CALL SUBOPT_0x142
; 0000 1F95                         cykl_glowny = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x13B
; 0000 1F96                         }
; 0000 1F97 
; 0000 1F98            break;
_0x4B4:
	RJMP _0x468
; 0000 1F99 
; 0000 1F9A 
; 0000 1F9B            case 7:
_0x4AF:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4BB
; 0000 1F9C 
; 0000 1F9D 
; 0000 1F9E                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x4BC
; 0000 1F9F                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1FA0 
; 0000 1FA1                         wykonalem_komplet_okregow = 0;
_0x4BC:
	CALL SUBOPT_0x123
; 0000 1FA2                         szczotka_druc_cykl = 0;
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
; 0000 1FA3                         krazek_scierny_cykl_po_okregu = 0;
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
; 0000 1FA4                         krazek_scierny_cykl = 0;
	STS  _krazek_scierny_cykl,R30
	STS  _krazek_scierny_cykl+1,R30
; 0000 1FA5                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0xFF
; 0000 1FA6                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x105
; 0000 1FA7 
; 0000 1FA8                         abs_ster3 = 0;
	CALL SUBOPT_0xF7
; 0000 1FA9                         abs_ster4 = 0;
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
; 0000 1FAA                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 1FAB                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x140
; 0000 1FAC                         cykl_sterownik_4 = 0;
; 0000 1FAD                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 1FAE 
; 0000 1FAF                              if(krazek_scierny_cykl_po_okregu_ilosc > 0)
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BRGE _0x4BD
; 0000 1FB0                                 {
; 0000 1FB1                                 if(ruch_haos == 0 & tryb_pracy_szczotki_drucianej == 1)  //spr.
	CALL SUBOPT_0x76
	CALL SUBOPT_0x75
	MOVW R26,R10
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x4BE
; 0000 1FB2                                     cykl_glowny = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x13B
; 0000 1FB3 
; 0000 1FB4                                 if(ruch_haos == 0 & (tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3))//spr.
_0x4BE:
	CALL SUBOPT_0x76
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	MOV  R1,R30
	CALL SUBOPT_0x73
	AND  R30,R1
	BREQ _0x4BF
; 0000 1FB5                                     cykl_glowny = 88;
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	CALL SUBOPT_0x13B
; 0000 1FB6 
; 0000 1FB7                                 if(ruch_haos == 1 & tryb_pracy_szczotki_drucianej == 1) //spr.
_0x4BF:
	CALL SUBOPT_0x76
	CALL SUBOPT_0x77
	MOV  R0,R30
	MOVW R26,R10
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x4C0
; 0000 1FB8                                     cykl_glowny = 887;
	LDI  R30,LOW(887)
	LDI  R31,HIGH(887)
	CALL SUBOPT_0x13B
; 0000 1FB9 
; 0000 1FBA                                 if(ruch_haos == 1 & (tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3))// spr.
_0x4C0:
	CALL SUBOPT_0x76
	CALL SUBOPT_0x77
	MOV  R1,R30
	CALL SUBOPT_0x73
	AND  R30,R1
	BREQ _0x4C1
; 0000 1FBB                                     cykl_glowny = 888;
	LDI  R30,LOW(888)
	LDI  R31,HIGH(888)
	CALL SUBOPT_0x13B
; 0000 1FBC                                 }
_0x4C1:
; 0000 1FBD                              else
	RJMP _0x4C2
_0x4BD:
; 0000 1FBE                                 {
; 0000 1FBF                                 if(tryb_pracy_szczotki_drucianej == 1)  //spr
	CALL SUBOPT_0x70
	BRNE _0x4C3
; 0000 1FC0                                     cykl_glowny = 997;
	LDI  R30,LOW(997)
	LDI  R31,HIGH(997)
	CALL SUBOPT_0x13B
; 0000 1FC1                                 if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)  //spr
_0x4C3:
	CALL SUBOPT_0x73
	BREQ _0x4C4
; 0000 1FC2                                     cykl_glowny = 998;
	LDI  R30,LOW(998)
	LDI  R31,HIGH(998)
	CALL SUBOPT_0x13B
; 0000 1FC3 
; 0000 1FC4                                 }
_0x4C4:
_0x4C2:
; 0000 1FC5 
; 0000 1FC6            break;
	RJMP _0x468
; 0000 1FC7 
; 0000 1FC8 
; 0000 1FC9            case 887:
_0x4BB:
	CPI  R30,LOW(0x377)
	LDI  R26,HIGH(0x377)
	CPC  R31,R26
	BRNE _0x4C5
; 0000 1FCA                     przypadek887();
	CALL _przypadek887
; 0000 1FCB            break;
	RJMP _0x468
; 0000 1FCC 
; 0000 1FCD             case 888:
_0x4C5:
	CPI  R30,LOW(0x378)
	LDI  R26,HIGH(0x378)
	CPC  R31,R26
	BRNE _0x4C6
; 0000 1FCE                    przypadek888();
	CALL _przypadek888
; 0000 1FCF            break;
	RJMP _0x468
; 0000 1FD0 
; 0000 1FD1            case 997:
_0x4C6:
	CPI  R30,LOW(0x3E5)
	LDI  R26,HIGH(0x3E5)
	CPC  R31,R26
	BRNE _0x4C7
; 0000 1FD2                    przypadek997();
	CALL _przypadek997
; 0000 1FD3            break;
	RJMP _0x468
; 0000 1FD4 
; 0000 1FD5            case 998:
_0x4C7:
	CPI  R30,LOW(0x3E6)
	LDI  R26,HIGH(0x3E6)
	CPC  R31,R26
	BRNE _0x4C8
; 0000 1FD6                     przypadek998();
	CALL _przypadek998
; 0000 1FD7            break;
	RJMP _0x468
; 0000 1FD8 
; 0000 1FD9             case 8:
_0x4C8:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x4C9
; 0000 1FDA                     przypadek8();
	RCALL _przypadek8
; 0000 1FDB             break;
	RJMP _0x468
; 0000 1FDC 
; 0000 1FDD             case 88:
_0x4C9:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x4CA
; 0000 1FDE                     przypadek88();
	RCALL _przypadek88
; 0000 1FDF             break;
	RJMP _0x468
; 0000 1FE0 
; 0000 1FE1 
; 0000 1FE2 
; 0000 1FE3             case 9:                                          //cykl 3 == 5
_0x4CA:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4CB
; 0000 1FE4 
; 0000 1FE5                          if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xCE
	BRGE _0x4CC
; 0000 1FE6                         {
; 0000 1FE7                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0xCF
; 0000 1FE8                         PORTF = PORT_F.byte;
; 0000 1FE9                         }
; 0000 1FEA 
; 0000 1FEB 
; 0000 1FEC 
; 0000 1FED                          if(rzad_obrabiany == 1)
_0x4CC:
	CALL SUBOPT_0x90
	SBIW R26,1
	BRNE _0x4CD
; 0000 1FEE                          {
; 0000 1FEF                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)    //////
	CALL SUBOPT_0xEE
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x149
	AND  R30,R0
	BREQ _0x4CE
; 0000 1FF0                               cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xFD
; 0000 1FF1 
; 0000 1FF2 
; 0000 1FF3                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_1 - 2)
_0x4CE:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x14F
	BREQ _0x4CF
; 0000 1FF4                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x103
	CALL SUBOPT_0xE6
; 0000 1FF5 
; 0000 1FF6 
; 0000 1FF7                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)       //2 marca 2019 wykomentowuje ////////
_0x4CF:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x150
	BREQ _0x4D0
; 0000 1FF8                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x14
	CALL SUBOPT_0xFD
; 0000 1FF9 
; 0000 1FFA 
; 0000 1FFB                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_1 - 2)
_0x4D0:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x151
	BREQ _0x4D1
; 0000 1FFC                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x14
	CALL SUBOPT_0x14
	CALL SUBOPT_0xE6
; 0000 1FFD 
; 0000 1FFE                           }
_0x4D1:
; 0000 1FFF 
; 0000 2000 
; 0000 2001                          if(rzad_obrabiany == 2)
_0x4CD:
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x4D2
; 0000 2002                          {
; 0000 2003                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
	CALL SUBOPT_0xEE
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x14A
	AND  R30,R0
	BREQ _0x4D3
; 0000 2004                             cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xFD
; 0000 2005 
; 0000 2006                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_2 - 2)
_0x4D3:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0x152
	CALL SUBOPT_0x14F
	BREQ _0x4D4
; 0000 2007                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0x103
	CALL SUBOPT_0xE6
; 0000 2008 
; 0000 2009                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x4D4:
	CALL SUBOPT_0xEE
	CALL SUBOPT_0x152
	CALL SUBOPT_0x150
	BREQ _0x4D5
; 0000 200A                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x14
	CALL SUBOPT_0xFD
; 0000 200B 
; 0000 200C                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_2 - 2)
_0x4D5:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0x152
	CALL SUBOPT_0x151
	BREQ _0x4D6
; 0000 200D                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x14
	CALL SUBOPT_0x14
	CALL SUBOPT_0xE6
; 0000 200E 
; 0000 200F                            if(rzad_obrabiany == 2)
_0x4D6:
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x4D7
; 0000 2010                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 2011 
; 0000 2012                           }
_0x4D7:
; 0000 2013 
; 0000 2014 
; 0000 2015                           if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 & sek12 > czas_przedmuchu)
_0x4D2:
	CALL SUBOPT_0xEE
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0xE1
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
	BREQ _0x4D8
; 0000 2016                             {
; 0000 2017                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 2018                             PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 2019                             //PORTB.6 = 0;  //wylacz przedmuchy
; 0000 201A                             PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0xCF
; 0000 201B                             PORTF = PORT_F.byte;
; 0000 201C                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 201D                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF4
; 0000 201E                             cykl_ilosc_zaciskow++;
	LDI  R26,LOW(_cykl_ilosc_zaciskow)
	LDI  R27,HIGH(_cykl_ilosc_zaciskow)
	CALL SUBOPT_0x153
; 0000 201F                             ruch_zlozony = 2;                       //il_zaciskow_rzad_1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 2020                             cykl_glowny = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x13B
; 0000 2021                             }
; 0000 2022 
; 0000 2023 
; 0000 2024             break;
_0x4D8:
	RJMP _0x468
; 0000 2025 
; 0000 2026 
; 0000 2027 
; 0000 2028             case 10:
_0x4CB:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4DD
; 0000 2029 
; 0000 202A                                                //wywali ten warunek jak zadziala
; 0000 202B                      if(rzad_obrabiany == 1 & cykl_glowny != 0)
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x154
	BRNE PC+3
	JMP _0x4DE
; 0000 202C                             {
; 0000 202D                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,96);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x114
	CALL SUBOPT_0xA2
	CALL SUBOPT_0x18
	CALL SUBOPT_0x155
; 0000 202E                             czas_pracy_szczotki_drucianej_h++;
; 0000 202F                             if(czas_pracy_szczotki_drucianej_h > 250)
	CALL SUBOPT_0x156
	BRLT _0x4DF
; 0000 2030                                 czas_pracy_szczotki_drucianej_h = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x17
; 0000 2031 
; 0000 2032                             if(srednica_wew_korpusu_cyklowa == 34)
_0x4DF:
	CALL SUBOPT_0xA3
	SBIW R26,34
	BRNE _0x4E0
; 0000 2033                                 {
; 0000 2034                                 czas_pracy_krazka_sciernego_h_34++;
	CALL SUBOPT_0xAA
; 0000 2035                                 if(czas_pracy_krazka_sciernego_h_34 > 250)
	CALL SUBOPT_0x157
	BRLT _0x4E1
; 0000 2036                                     czas_pracy_krazka_sciernego_h_34 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x19
; 0000 2037                                 }
_0x4E1:
; 0000 2038 
; 0000 2039 
; 0000 203A                             if(srednica_wew_korpusu_cyklowa == 36)
_0x4E0:
	CALL SUBOPT_0xA3
	SBIW R26,36
	BRNE _0x4E2
; 0000 203B                                 {
; 0000 203C                                 czas_pracy_krazka_sciernego_h_36++;
	CALL SUBOPT_0xAB
; 0000 203D                                 if(czas_pracy_krazka_sciernego_h_36 > 250)
	CALL SUBOPT_0x158
	BRLT _0x4E3
; 0000 203E                                     czas_pracy_krazka_sciernego_h_36 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x1A
; 0000 203F                                 }
_0x4E3:
; 0000 2040                             if(srednica_wew_korpusu_cyklowa == 38)
_0x4E2:
	CALL SUBOPT_0xA3
	SBIW R26,38
	BRNE _0x4E4
; 0000 2041                                 {
; 0000 2042                                 czas_pracy_krazka_sciernego_h_38++;
	CALL SUBOPT_0xAC
; 0000 2043                                 if(czas_pracy_krazka_sciernego_h_38 > 250)
	CALL SUBOPT_0x159
	BRLT _0x4E5
; 0000 2044                                     czas_pracy_krazka_sciernego_h_38 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x1C
; 0000 2045                                 }
_0x4E5:
; 0000 2046                             if(srednica_wew_korpusu_cyklowa == 41)
_0x4E4:
	CALL SUBOPT_0xA3
	SBIW R26,41
	BRNE _0x4E6
; 0000 2047                                 {
; 0000 2048                                 czas_pracy_krazka_sciernego_h_41++;
	CALL SUBOPT_0xAD
; 0000 2049                                 if(czas_pracy_krazka_sciernego_h_41 > 250)
	CALL SUBOPT_0x15A
	BRLT _0x4E7
; 0000 204A                                     czas_pracy_krazka_sciernego_h_41 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x1D
; 0000 204B                                 }
_0x4E7:
; 0000 204C                             if(srednica_wew_korpusu_cyklowa == 43)
_0x4E6:
	CALL SUBOPT_0xA3
	SBIW R26,43
	BRNE _0x4E8
; 0000 204D                                 {
; 0000 204E                                 czas_pracy_krazka_sciernego_h_43++;
	CALL SUBOPT_0xAE
; 0000 204F                                 if(czas_pracy_krazka_sciernego_h_43 > 250)
	CALL SUBOPT_0x15B
	BRLT _0x4E9
; 0000 2050                                     czas_pracy_krazka_sciernego_h_43 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x1F
; 0000 2051                                 }
_0x4E9:
; 0000 2052 
; 0000 2053                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_1 - 1)
_0x4E8:
	CALL SUBOPT_0x15C
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x4EA
; 0000 2054                                 {
; 0000 2055                                 cykl_glowny = 5;
	CALL SUBOPT_0x144
; 0000 2056                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0x13A
; 0000 2057                                 }
; 0000 2058 
; 0000 2059                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
_0x4EA:
	CALL SUBOPT_0x15C
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x4EB
; 0000 205A                                 {
; 0000 205B                                 cykl_glowny = 5;
	CALL SUBOPT_0x144
; 0000 205C                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x15D
; 0000 205D                                 }
; 0000 205E 
; 0000 205F                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 == 10)
_0x4EB:
	CALL SUBOPT_0x15E
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x4EC
; 0000 2060                                 {
; 0000 2061                                 cykl_glowny = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x13B
; 0000 2062                                 }
; 0000 2063 
; 0000 2064                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 != 10)  /////zmieniam + 1 20.02
_0x4EC:
	CALL SUBOPT_0x15E
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __NEW12
	AND  R30,R0
	BREQ _0x4ED
; 0000 2065                                 {
; 0000 2066                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x13B
; 0000 2067                                 }
; 0000 2068                             }
_0x4ED:
; 0000 2069 
; 0000 206A 
; 0000 206B                              if(rzad_obrabiany == 2)
_0x4DE:
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x4EE
; 0000 206C                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 206D 
; 0000 206E                             if(rzad_obrabiany == 2 & cykl_glowny != 0)
_0x4EE:
	CALL SUBOPT_0x94
	CALL SUBOPT_0x154
	BRNE PC+3
	JMP _0x4EF
; 0000 206F                             {
; 0000 2070                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,16);  //wykonano zaciskow rzad2
	CALL SUBOPT_0x114
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x155
; 0000 2071 
; 0000 2072                             czas_pracy_szczotki_drucianej_h++;
; 0000 2073                              if(czas_pracy_szczotki_drucianej_h > 250)
	CALL SUBOPT_0x156
	BRLT _0x4F0
; 0000 2074                                 czas_pracy_szczotki_drucianej_h = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x17
; 0000 2075 
; 0000 2076                             if(srednica_wew_korpusu_cyklowa == 34)
_0x4F0:
	CALL SUBOPT_0xA3
	SBIW R26,34
	BRNE _0x4F1
; 0000 2077                                 {
; 0000 2078                                 czas_pracy_krazka_sciernego_h_34++;
	CALL SUBOPT_0xAA
; 0000 2079                                 if(czas_pracy_krazka_sciernego_h_34 > 250)
	CALL SUBOPT_0x157
	BRLT _0x4F2
; 0000 207A                                     czas_pracy_krazka_sciernego_h_34 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x19
; 0000 207B                                 }
_0x4F2:
; 0000 207C 
; 0000 207D 
; 0000 207E                             if(srednica_wew_korpusu_cyklowa == 36)
_0x4F1:
	CALL SUBOPT_0xA3
	SBIW R26,36
	BRNE _0x4F3
; 0000 207F                                 {
; 0000 2080                                 czas_pracy_krazka_sciernego_h_36++;
	CALL SUBOPT_0xAB
; 0000 2081                                 if(czas_pracy_krazka_sciernego_h_36 > 250)
	CALL SUBOPT_0x158
	BRLT _0x4F4
; 0000 2082                                     czas_pracy_krazka_sciernego_h_36 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x1A
; 0000 2083                                 }
_0x4F4:
; 0000 2084                             if(srednica_wew_korpusu_cyklowa == 38)
_0x4F3:
	CALL SUBOPT_0xA3
	SBIW R26,38
	BRNE _0x4F5
; 0000 2085                                 {
; 0000 2086                                 czas_pracy_krazka_sciernego_h_38++;
	CALL SUBOPT_0xAC
; 0000 2087                                 if(czas_pracy_krazka_sciernego_h_38 > 250)
	CALL SUBOPT_0x159
	BRLT _0x4F6
; 0000 2088                                     czas_pracy_krazka_sciernego_h_38 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x1C
; 0000 2089                                 }
_0x4F6:
; 0000 208A                             if(srednica_wew_korpusu_cyklowa == 41)
_0x4F5:
	CALL SUBOPT_0xA3
	SBIW R26,41
	BRNE _0x4F7
; 0000 208B                                 {
; 0000 208C                                 czas_pracy_krazka_sciernego_h_41++;
	CALL SUBOPT_0xAD
; 0000 208D                                 if(czas_pracy_krazka_sciernego_h_41 > 250)
	CALL SUBOPT_0x15A
	BRLT _0x4F8
; 0000 208E                                     czas_pracy_krazka_sciernego_h_41 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x1D
; 0000 208F                                 }
_0x4F8:
; 0000 2090                             if(srednica_wew_korpusu_cyklowa == 43)
_0x4F7:
	CALL SUBOPT_0xA3
	SBIW R26,43
	BRNE _0x4F9
; 0000 2091                                 {
; 0000 2092                                 czas_pracy_krazka_sciernego_h_43++;
	CALL SUBOPT_0xAE
; 0000 2093                                 if(czas_pracy_krazka_sciernego_h_43 > 250)
	CALL SUBOPT_0x15B
	BRLT _0x4FA
; 0000 2094                                     czas_pracy_krazka_sciernego_h_43 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x1F
; 0000 2095                                 }
_0x4FA:
; 0000 2096 
; 0000 2097 
; 0000 2098                             if(srednica_wew_korpusu_cyklowa == 34)
_0x4F9:
	CALL SUBOPT_0xA3
	SBIW R26,34
	BRNE _0x4FB
; 0000 2099                                 czas_pracy_krazka_sciernego_h_34++;
	CALL SUBOPT_0xAA
; 0000 209A                             if(srednica_wew_korpusu_cyklowa == 36)
_0x4FB:
	CALL SUBOPT_0xA3
	SBIW R26,36
	BRNE _0x4FC
; 0000 209B                                 czas_pracy_krazka_sciernego_h_36++;
	CALL SUBOPT_0xAB
; 0000 209C                             if(srednica_wew_korpusu_cyklowa == 38)
_0x4FC:
	CALL SUBOPT_0xA3
	SBIW R26,38
	BRNE _0x4FD
; 0000 209D                                 czas_pracy_krazka_sciernego_h_38++;
	CALL SUBOPT_0xAC
; 0000 209E                             if(srednica_wew_korpusu_cyklowa == 41)
_0x4FD:
	CALL SUBOPT_0xA3
	SBIW R26,41
	BRNE _0x4FE
; 0000 209F                                 czas_pracy_krazka_sciernego_h_41++;
	CALL SUBOPT_0xAD
; 0000 20A0                             if(srednica_wew_korpusu_cyklowa == 43)
_0x4FE:
	CALL SUBOPT_0xA3
	SBIW R26,43
	BRNE _0x4FF
; 0000 20A1                                 czas_pracy_krazka_sciernego_h_43++;
	CALL SUBOPT_0xAE
; 0000 20A2 
; 0000 20A3 
; 0000 20A4                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_2 - 1)
_0x4FF:
	CALL SUBOPT_0x135
	SBIW R30,1
	CALL SUBOPT_0x14B
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x500
; 0000 20A5                                 {
; 0000 20A6                                 cykl_glowny = 5;
	CALL SUBOPT_0x144
; 0000 20A7                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0x13A
; 0000 20A8                                 }
; 0000 20A9 
; 0000 20AA                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x500:
	CALL SUBOPT_0x135
	SBIW R30,1
	CALL SUBOPT_0x14B
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x501
; 0000 20AB                                 {
; 0000 20AC                                 cykl_glowny = 5;
	CALL SUBOPT_0x144
; 0000 20AD                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x15D
; 0000 20AE                                 }
; 0000 20AF 
; 0000 20B0                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 == 10)
_0x501:
	CALL SUBOPT_0x15F
	CALL __EQW12
	AND  R30,R0
	BREQ _0x502
; 0000 20B1                                 {
; 0000 20B2                                 cykl_glowny = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x13B
; 0000 20B3                                 }
; 0000 20B4 
; 0000 20B5 
; 0000 20B6                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 != 10)   ///////////////////zmieniam + 1 20.02
_0x502:
	CALL SUBOPT_0x15F
	CALL __NEW12
	AND  R30,R0
	BREQ _0x503
; 0000 20B7                                 {
; 0000 20B8                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x13B
; 0000 20B9                                 }
; 0000 20BA                             }
_0x503:
; 0000 20BB 
; 0000 20BC 
; 0000 20BD 
; 0000 20BE             break;
_0x4EF:
	RJMP _0x468
; 0000 20BF 
; 0000 20C0             case 11:
_0x4DD:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x504
; 0000 20C1 
; 0000 20C2                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x505
; 0000 20C3                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 20C4 
; 0000 20C5                              //ster 1 ucieka od szafy
; 0000 20C6                              if(cykl_sterownik_1 < 5)
_0x505:
	CALL SUBOPT_0x136
	BRGE _0x506
; 0000 20C7                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0xD4
; 0000 20C8 
; 0000 20C9                              if(cykl_sterownik_2 < 5)
_0x506:
	CALL SUBOPT_0x137
	BRGE _0x507
; 0000 20CA                                     cykl_sterownik_2 = sterownik_2_praca(0x190);     //pod dolek ostatni 10 do przedmuchu rzad 1
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0x13E
; 0000 20CB 
; 0000 20CC                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x507:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0x139
	AND  R30,R0
	BREQ _0x508
; 0000 20CD                                     {
; 0000 20CE                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x14D
; 0000 20CF                                     PORTF = PORT_F.byte;
; 0000 20D0                                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 20D1                                     sek12 = 0;
	CALL SUBOPT_0x14C
; 0000 20D2                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 20D3                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x160
; 0000 20D4                                     cykl_glowny = 13;
; 0000 20D5                                     }
; 0000 20D6             break;
_0x508:
	RJMP _0x468
; 0000 20D7 
; 0000 20D8 
; 0000 20D9             case 12:
_0x504:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x50B
; 0000 20DA 
; 0000 20DB                              if(rzad_obrabiany == 2)
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x50C
; 0000 20DC                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 20DD 
; 0000 20DE                                //ster 1 ucieka od szafy
; 0000 20DF                              if(cykl_sterownik_1 < 5)
_0x50C:
	CALL SUBOPT_0x136
	BRGE _0x50D
; 0000 20E0                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0xD4
; 0000 20E1 
; 0000 20E2                             if(cykl_sterownik_2 < 5)
_0x50D:
	CALL SUBOPT_0x137
	BRGE _0x50E
; 0000 20E3                                     cykl_sterownik_2 = sterownik_2_praca(0x191);     //pod dolek ostatni 10 do przedmuchu rzad 2
	LDI  R30,LOW(401)
	LDI  R31,HIGH(401)
	CALL SUBOPT_0x13E
; 0000 20E4 
; 0000 20E5                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x50E:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0x139
	AND  R30,R0
	BREQ _0x50F
; 0000 20E6                                     {
; 0000 20E7                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x14D
; 0000 20E8                                     PORTF = PORT_F.byte;
; 0000 20E9                                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 20EA                                     sek12 = 0;
	CALL SUBOPT_0x14C
; 0000 20EB                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 20EC                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x160
; 0000 20ED                                     cykl_glowny = 13;
; 0000 20EE                                     }
; 0000 20EF 
; 0000 20F0 
; 0000 20F1             break;
_0x50F:
	RJMP _0x468
; 0000 20F2 
; 0000 20F3             case 13:
_0x50B:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x512
; 0000 20F4 
; 0000 20F5 
; 0000 20F6                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x513
; 0000 20F7                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 20F8 
; 0000 20F9                               if(sek12 > czas_przedmuchu)
_0x513:
	CALL SUBOPT_0xCE
	BRGE _0x514
; 0000 20FA                                         {
; 0000 20FB                                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0xCF
; 0000 20FC                                         PORTF = PORT_F.byte;
; 0000 20FD                                         PORTE.5 = 0;
	CBI  0x3,5
; 0000 20FE                                         }
; 0000 20FF 
; 0000 2100 
; 0000 2101                              if(cykl_sterownik_2 < 5)
_0x514:
	CALL SUBOPT_0x137
	BRGE _0x517
; 0000 2102                                     cykl_sterownik_2 = sterownik_2_praca(0x192);     //okrag
	LDI  R30,LOW(402)
	LDI  R31,HIGH(402)
	CALL SUBOPT_0x13E
; 0000 2103                              if(cykl_sterownik_2 == 5)
_0x517:
	CALL SUBOPT_0x137
	BRNE _0x518
; 0000 2104                                     {
; 0000 2105 
; 0000 2106                                      if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xCE
	BRGE _0x519
; 0000 2107                                         {
; 0000 2108                                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0xCF
; 0000 2109                                         PORTF = PORT_F.byte;
; 0000 210A                                         PORTE.5 = 0;
	CBI  0x3,5
; 0000 210B                                         cykl_sterownik_2 = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
; 0000 210C                                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x13B
; 0000 210D                                         }
; 0000 210E                                     }
_0x519:
; 0000 210F 
; 0000 2110             break;
_0x518:
	RJMP _0x468
; 0000 2111 
; 0000 2112 
; 0000 2113 
; 0000 2114             case 14:
_0x512:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x51C
; 0000 2115 
; 0000 2116 
; 0000 2117                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x51D
; 0000 2118                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 2119 
; 0000 211A                     if(cykl_sterownik_1 < 5)
_0x51D:
	CALL SUBOPT_0x136
	BRGE _0x51E
; 0000 211B                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek zeby przedmuchac
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xD4
; 0000 211C                     if(cykl_sterownik_1 == 5)
_0x51E:
	CALL SUBOPT_0x136
	BRNE _0x51F
; 0000 211D                         {
; 0000 211E                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 211F                         sek12 = 0;
	CALL SUBOPT_0x14C
; 0000 2120                         cykl_glowny = 15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x13B
; 0000 2121                         }
; 0000 2122 
; 0000 2123             break;
_0x51F:
	RJMP _0x468
; 0000 2124 
; 0000 2125 
; 0000 2126 
; 0000 2127             case 15:
_0x51C:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x520
; 0000 2128 
; 0000 2129                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x90
	SBIW R26,2
	BRNE _0x521
; 0000 212A                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 212B 
; 0000 212C                     //przedmuch
; 0000 212D                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
_0x521:
	CALL SUBOPT_0x14D
; 0000 212E                     PORTF = PORT_F.byte;
; 0000 212F 
; 0000 2130                     if(start == 1)
	CALL SUBOPT_0xBC
	SBIW R26,1
	BRNE _0x522
; 0000 2131                         {
; 0000 2132                         obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xBF
; 0000 2133                         obsluga_nacisniecia_zatrzymaj();
; 0000 2134                         }
; 0000 2135 
; 0000 2136 
; 0000 2137                     if(sek12 > czas_przedmuchu)
_0x522:
	CALL SUBOPT_0xCE
	BRGE _0x523
; 0000 2138                         {
; 0000 2139                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xCF
; 0000 213A                         PORTF = PORT_F.byte;
; 0000 213B                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x13B
; 0000 213C                         }
; 0000 213D             break;
_0x523:
	RJMP _0x468
; 0000 213E 
; 0000 213F 
; 0000 2140             case 16:
_0x520:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x524
; 0000 2141 
; 0000 2142                      if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & wykonalem_rzedow == 0)  /////zmieniam + 1 20.02
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	CALL SUBOPT_0x14B
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x161
	CALL SUBOPT_0xB5
	BREQ _0x525
; 0000 2143                                 {
; 0000 2144                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x12E
; 0000 2145                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 2146                                 if(il_zaciskow_rzad_2 > 0)
	CALL SUBOPT_0x130
	CALL __CPW02
	BRGE _0x528
; 0000 2147                                     {
; 0000 2148 
; 0000 2149                                     rzad_obrabiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
; 0000 214A                                     wybor_linijek_sterownikow(2);  //rzad 2
	ST   -Y,R31
	ST   -Y,R30
	CALL _wybor_linijek_sterownikow
; 0000 214B                                     cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 214C                                     }
; 0000 214D                                 else
	RJMP _0x529
_0x528:
; 0000 214E                                     cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x13B
; 0000 214F 
; 0000 2150                                 wykonalem_rzedow = 1;
_0x529:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 2151                                 }
; 0000 2152 
; 0000 2153                        if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 1)   ///////////////////zmieniam + 1 20.02
_0x525:
	CALL SUBOPT_0x135
	CALL SUBOPT_0x14B
	CALL __EQW12
	CALL SUBOPT_0x133
	CALL __GTW12
	AND  R0,R30
	CALL SUBOPT_0x161
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x52A
; 0000 2154                                 {
; 0000 2155                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 2156                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x12E
; 0000 2157                                 cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x13B
; 0000 2158                                 rzad_obrabiany = 1;
	CALL SUBOPT_0x12C
; 0000 2159                                 wykonalem_rzedow = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 215A                                 }
; 0000 215B 
; 0000 215C 
; 0000 215D                         if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 2)
_0x52A:
	CALL SUBOPT_0x162
	CALL SUBOPT_0x133
	CALL __GTW12
	AND  R0,R30
	CALL SUBOPT_0x161
	CALL SUBOPT_0xBB
	AND  R30,R0
	BREQ _0x52D
; 0000 215E                                   {
; 0000 215F                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x12C
; 0000 2160                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0x12D
; 0000 2161                                   PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 2162                                   //PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1 - tego na razie nie poki nie ma oslon
; 0000 2163                                   //PORTB.6 = 0;   ////zielona lampka
; 0000 2164                                   //wartosc_parametru_panelu(0,0,64);
; 0000 2165                                   }
; 0000 2166 
; 0000 2167                             if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 == 0 & wykonalem_rzedow == 1)
_0x52D:
	CALL SUBOPT_0x162
	MOV  R0,R30
	CALL SUBOPT_0x130
	CALL SUBOPT_0xE3
	CALL SUBOPT_0x161
	CALL SUBOPT_0x77
	AND  R30,R0
	BREQ _0x530
; 0000 2168                                   {
; 0000 2169                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x12C
; 0000 216A                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0x12D
; 0000 216B                                   //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
; 0000 216C                                   }
; 0000 216D 
; 0000 216E 
; 0000 216F 
; 0000 2170             break;
_0x530:
	RJMP _0x468
; 0000 2171 
; 0000 2172 
; 0000 2173             case 17:
_0x524:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x468
; 0000 2174 
; 0000 2175 
; 0000 2176                                  if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x136
	BRGE _0x532
; 0000 2177                                     cykl_sterownik_1 = sterownik_1_praca(0x009);
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL SUBOPT_0xD4
; 0000 2178                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x532:
	CALL SUBOPT_0x137
	BRGE _0x533
; 0000 2179                                     cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x14
	CALL SUBOPT_0x138
; 0000 217A 
; 0000 217B                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x533:
	CALL SUBOPT_0xD2
	CALL SUBOPT_0x139
	AND  R30,R0
	BRNE PC+3
	JMP _0x534
; 0000 217C                                         {
; 0000 217D                                         PORTB.6 = 0;   ////zielona lampka
	CBI  0x18,6
; 0000 217E                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD6
; 0000 217F                                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x10C
; 0000 2180                                         cykl_sterownik_3 = 0;
; 0000 2181                                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xEA
; 0000 2182                                         jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 2183                                         PORTB.6 = 0;
	CBI  0x18,6
; 0000 2184 
; 0000 2185                                         if(odczytalem_w_trakcie_czyszczenia_drugiego_rzedu == 0)
	LDS  R30,_odczytalem_w_trakcie_czyszczenia_drugiego_rzedu
	LDS  R31,_odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1
	SBIW R30,0
	BRNE _0x539
; 0000 2186                                         {
; 0000 2187                                         macierz_zaciskow[1]=0;
	__POINTW1MN _macierz_zaciskow,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 2188                                         macierz_zaciskow[2]=0;
	__POINTW1MN _macierz_zaciskow,4
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 2189 
; 0000 218A                                         komunikat_na_panel("-------",0,80);  //rzad 1
	__POINTW1FN _0x0,2254
	CALL SUBOPT_0xA2
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0xD
; 0000 218B                                         komunikat_na_panel("-------",0,32);  //rzad 2
	__POINTW1FN _0x0,2254
	CALL SUBOPT_0xA2
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0xD
; 0000 218C 
; 0000 218D                                         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x33
; 0000 218E                                         komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",adr1,adr2);
	__POINTW1FN _0x0,2262
	CALL SUBOPT_0x34
; 0000 218F                                         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x88
; 0000 2190                                         komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",adr3,adr4);
	__POINTW1FN _0x0,2262
	CALL SUBOPT_0x89
; 0000 2191                                         }
; 0000 2192 
; 0000 2193                                         odczytalem_w_trakcie_czyszczenia_drugiego_rzedu = 0;
_0x539:
	LDI  R30,LOW(0)
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu,R30
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1,R30
; 0000 2194 
; 0000 2195 
; 0000 2196                                         //to ponizej dotyczy zapisu do pamieci stalej cykli szczotki i krazka
; 0000 2197 
; 0000 2198                                         tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1E
	MOVW R10,R30
; 0000 2199                                         szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 219A                                         krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
; 0000 219B                                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
; 0000 219C                                         czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
; 0000 219D                                         czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
; 0000 219E 
; 0000 219F                                         wartosci_wstepne_wgrac_tylko_raz(1); //to trwa 3s
	CALL SUBOPT_0xAF
	CALL _wartosci_wstepne_wgrac_tylko_raz
; 0000 21A0                                         srednica_wew_korpusu_cyklowa = 0;
	LDI  R30,LOW(0)
	STS  _srednica_wew_korpusu_cyklowa,R30
	STS  _srednica_wew_korpusu_cyklowa+1,R30
; 0000 21A1                                         wartosc_parametru_panelu(0,0,64);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x14
	CALL SUBOPT_0x96
	CALL _wartosc_parametru_panelu
; 0000 21A2                                         start = 0;
	LDI  R30,LOW(0)
	STS  _start,R30
	STS  _start+1,R30
; 0000 21A3                                         cykl_glowny = 0;
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 21A4                                         }
; 0000 21A5 
; 0000 21A6 
; 0000 21A7 
; 0000 21A8 
; 0000 21A9             break;
_0x534:
; 0000 21AA 
; 0000 21AB 
; 0000 21AC 
; 0000 21AD             }//switch
_0x468:
; 0000 21AE 
; 0000 21AF 
; 0000 21B0   }//while
	RJMP _0x463
_0x465:
; 0000 21B1 
; 0000 21B2 
; 0000 21B3 
; 0000 21B4 }//while glowny
	RJMP _0x460
; 0000 21B5 
; 0000 21B6 
; 0000 21B7 
; 0000 21B8 
; 0000 21B9 }//koniec
_0x53A:
	RJMP _0x53A
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
	CALL SUBOPT_0x153
	ADIW R28,3
	RET
__print_G103:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x30
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
	CALL SUBOPT_0x163
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x163
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
	CALL SUBOPT_0x164
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x165
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x164
	CALL SUBOPT_0x166
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x164
	CALL SUBOPT_0x166
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
	CALL SUBOPT_0x164
	CALL SUBOPT_0x167
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
	CALL SUBOPT_0x164
	CALL SUBOPT_0x167
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
	CALL SUBOPT_0x163
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
	CALL SUBOPT_0x163
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
	CALL SUBOPT_0x165
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x163
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
	CALL SUBOPT_0x165
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
	CALL SUBOPT_0x25
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
_czas_pracy_krazka_sciernego_stala:
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
_odczytalem_zacisk:
	.BYTE 0x2
_il_prob_odczytu:
	.BYTE 0x2
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
_czas_zatrzymania_na_dole:
	.BYTE 0x2
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(90)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(165)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	CALL _putchar
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _putchar
	LDD  R30,Y+2
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	CALL _getchar
	CALL _getchar
	JMP  _getchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x5:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CALL _putchar
	LDI  R30,LOW(130)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LD   R30,Y
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 154 TIMES, CODE SIZE REDUCTION:609 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(_macierz_zaciskow)
	LDI  R27,HIGH(_macierz_zaciskow)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0xB:
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
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 47 TIMES, CODE SIZE REDUCTION:89 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x13:
	MOVW R4,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	MOVW R6,R30
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 188 TIMES, CODE SIZE REDUCTION:371 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x15:
	CALL _odczytaj_parametr
	MOVW R8,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	MOVW R12,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STS  _czas_pracy_krazka_sciernego_stala,R30
	STS  _czas_pracy_krazka_sciernego_stala+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	STS  _czas_pracy_szczotki_drucianej_h,R30
	STS  _czas_pracy_szczotki_drucianej_h+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 45 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	STS  _czas_pracy_krazka_sciernego_h_34,R30
	STS  _czas_pracy_krazka_sciernego_h_34+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	STS  _czas_pracy_krazka_sciernego_h_36,R30
	STS  _czas_pracy_krazka_sciernego_h_36+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	STS  _czas_pracy_krazka_sciernego_h_38,R30
	STS  _czas_pracy_krazka_sciernego_h_38+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	STS  _czas_pracy_krazka_sciernego_h_41,R30
	STS  _czas_pracy_krazka_sciernego_h_41+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	STS  _czas_pracy_krazka_sciernego_h_43,R30
	STS  _czas_pracy_krazka_sciernego_h_43+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	STS  _srednica_krazka_sciernego,R30
	STS  _srednica_krazka_sciernego+1,R31
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x21:
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
SUBOPT_0x22:
	OR   R30,R0
	STS  _PORT_CZYTNIK,R30
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 145 TIMES, CODE SIZE REDUCTION:285 WORDS
SUBOPT_0x25:
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 69 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_z_czytnika_kodow

;OPTIMIZER ADDED SUBROUTINE, CALLED 68 TIMES, CODE SIZE REDUCTION:265 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x28:
	CALL _komunikat_z_czytnika_kodow
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x29:
	CALL _komunikat_z_czytnika_kodow
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x2B:
	CALL _komunikat_z_czytnika_kodow
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2E:
	CALL _komunikat_z_czytnika_kodow
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2F:
	ST   X+,R30
	ST   X,R31
	MOVW R30,R16
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x31:
	CALL _komunikat_z_czytnika_kodow
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:151 WORDS
SUBOPT_0x33:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr1
	LDS  R31,_adr1+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr2
	LDS  R31,_adr2+1
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0x34:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr1
	LDS  R31,_adr1+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr2
	LDS  R31,_adr2+1
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 136 TIMES, CODE SIZE REDUCTION:537 WORDS
SUBOPT_0x35:
	STS  _a,R30
	STS  _a+1,R31
	__POINTW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 104 TIMES, CODE SIZE REDUCTION:409 WORDS
SUBOPT_0x36:
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x37:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x38:
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x39:
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
SUBOPT_0x3A:
	__POINTW1MN _a,18
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3B:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x3C:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x3A

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x3D:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x3E:
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x3A

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x3F:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x40:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x42:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x43:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x44:
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
SUBOPT_0x45:
	LDI  R26,LOW(29)
	LDI  R27,HIGH(29)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x47:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x48:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x49:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4A:
	__POINTW1MN _a,8
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x4B:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RJMP SUBOPT_0x47

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4D:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4E:
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4F:
	__POINTW1MN _a,8
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x50:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:186 WORDS
SUBOPT_0x51:
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
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x52:
	LDI  R26,LOW(27)
	LDI  R27,HIGH(27)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x53:
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
SUBOPT_0x54:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x55:
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x56:
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x57:
	LDI  R26,LOW(22)
	LDI  R27,HIGH(22)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x58:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x59:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	LDI  R26,LOW(20)
	LDI  R27,HIGH(20)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x5C:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5D:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	LDI  R26,LOW(36)
	LDI  R27,HIGH(36)
	RJMP SUBOPT_0x5C

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x5E:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5F:
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	RJMP SUBOPT_0x5C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP SUBOPT_0x5C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x62:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	RJMP SUBOPT_0x5C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	__POINTW1MN _a,8
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x64:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x61

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x65:
	__POINTW1MN _a,8
	LDI  R26,LOW(23)
	LDI  R27,HIGH(23)
	RJMP SUBOPT_0x5C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x66:
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x67:
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x68:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	RJMP SUBOPT_0x5C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6A:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x5F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6B:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6C:
	LDS  R30,_a
	LDS  R31,_a+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6D:
	__GETW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x6E:
	__GETW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x6F:
	ADIW R30,1
	__PUTW1MN _a,12
	__GETW1MN _a,12
	ADIW R30,1
	__PUTW1MN _a,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x70:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x71:
	__GETW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x72:
	__PUTW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x73:
	MOVW R26,R10
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x74:
	__GETW1MN _a,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x75:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x76:
	LDS  R26,_ruch_haos
	LDS  R27,_ruch_haos+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 76 TIMES, CODE SIZE REDUCTION:147 WORDS
SUBOPT_0x77:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x78:
	__GETW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x79:
	LDS  R26,_srednica_krazka_sciernego
	LDS  R27,_srednica_krazka_sciernego+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7A:
	LDS  R26,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R27,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7B:
	MOV  R0,R30
	RCALL SUBOPT_0x79
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7C:
	RCALL SUBOPT_0x7A
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7D:
	__PUTW1MN _a,10
	RJMP SUBOPT_0x6E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7E:
	RCALL SUBOPT_0x7A
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7F:
	RCALL SUBOPT_0x7A
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x80:
	MOV  R0,R30
	RCALL SUBOPT_0x79
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x81:
	__CPD2N 0x3D
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x82:
	LDI  R30,LOW(_PORTMM)
	LDI  R31,HIGH(_PORTMM)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _sprawdz_pin2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x83:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	SBI  0x12,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x84:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _byla_wloczona_szlifierka_1,R30
	STS  _byla_wloczona_szlifierka_1+1,R31
	CBI  0x3,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x85:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _byla_wloczona_szlifierka_2,R30
	STS  _byla_wloczona_szlifierka_2+1,R31
	CBI  0x3,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x86:
	LDS  R30,_PORT_F
	ANDI R30,LOW(0x10)
	CPI  R30,LOW(0x10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x87:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:137 WORDS
SUBOPT_0x88:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x89:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8A:
	CBI  0x12,7
	LDS  R26,_byla_wloczona_szlifierka_1
	LDS  R27,_byla_wloczona_szlifierka_1+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8B:
	SBI  0x3,2
	LDI  R30,LOW(0)
	STS  _byla_wloczona_szlifierka_1,R30
	STS  _byla_wloczona_szlifierka_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8C:
	LDS  R26,_byla_wloczona_szlifierka_2
	LDS  R27,_byla_wloczona_szlifierka_2+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8D:
	SBI  0x3,3
	LDI  R30,LOW(0)
	STS  _byla_wloczona_szlifierka_2,R30
	STS  _byla_wloczona_szlifierka_2+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8E:
	LDS  R26,_byl_wloczony_przedmuch
	LDS  R27,_byl_wloczony_przedmuch+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x8F:
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
SUBOPT_0x90:
	LDS  R26,_rzad_obrabiany
	LDS  R27,_rzad_obrabiany+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x91:
	MOV  R0,R30
	LDS  R26,_start
	LDS  R27,_start+1
	RJMP SUBOPT_0x77

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x92:
	LDI  R30,LOW(_PORTMM)
	LDI  R31,HIGH(_PORTMM)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _sprawdz_pin0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x93:
	LDI  R30,LOW(_PORTMM)
	LDI  R31,HIGH(_PORTMM)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _sprawdz_pin1

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x94:
	RCALL SUBOPT_0x90
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x95:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x96:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:111 WORDS
SUBOPT_0x97:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x98:
	CALL _wartosc_parametru_panelu_stala_pamiec
	RJMP SUBOPT_0x97

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x99:
	CALL _odczyt_parametru_panelu_stala_pamiec
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x9A:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x9B:
	CALL _wartosc_parametru_panelu
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9C:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x9D:
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9E:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x9D

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9F:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0xA0:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA1:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP SUBOPT_0x9F

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xA2:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0xA3:
	LDS  R26,_srednica_wew_korpusu_cyklowa
	LDS  R27,_srednica_wew_korpusu_cyklowa+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA4:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA5:
	RCALL SUBOPT_0xA3
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA6:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA7:
	CALL _wartosc_parametru_panelu_stala_pamiec
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RJMP SUBOPT_0xA0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA8:
	STS  _srednica_wew_korpusu_cyklowa,R30
	STS  _srednica_wew_korpusu_cyklowa+1,R31
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA9:
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RCALL SUBOPT_0xA3
	SBIW R26,34
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xAA:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_34)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_34)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xAB:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_36)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_36)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xAC:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_38)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_38)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xAD:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_41)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_41)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xAE:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_43)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_43)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xAF:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB0:
	CALL _odczyt_parametru_panelu_stala_pamiec
	RJMP SUBOPT_0x97

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB1:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB2:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0xB3:
	LDI  R30,LOW(_PORTLL)
	LDI  R31,HIGH(_PORTLL)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB4:
	AND  R30,R26
	MOV  R0,R30
	LDS  R26,_czekaj_az_puszcze
	LDS  R27,_czekaj_az_puszcze+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 43 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0xB5:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB6:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB7:
	LDI  R30,LOW(0)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0xB1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB8:
	LDI  R30,LOW(0)
	STS  _sek11,R30
	STS  _sek11+1,R30
	STS  _sek11+2,R30
	STS  _sek11+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB9:
	LDS  R30,_il_prob_odczytu
	LDS  R31,_il_prob_odczytu+1
	LDS  R26,_odczytalem_zacisk
	LDS  R27,_odczytalem_zacisk+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xBA:
	LDI  R26,LOW(_odczytalem_zacisk)
	LDI  R27,HIGH(_odczytalem_zacisk)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xBB:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xBC:
	LDS  R26,_start
	LDS  R27,_start+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xBD:
	LDI  R30,LOW(_PORTJJ)
	LDI  R31,HIGH(_PORTJJ)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xBE:
	SBI  0x12,7
	CBI  0x3,2
	CBI  0x3,3
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xBF:
	CALL _obsluga_otwarcia_klapy_rzad
	JMP  _obsluga_nacisniecia_zatrzymaj

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xC0:
	LDI  R30,LOW(0)
	STS  _sek1,R30
	STS  _sek1+1,R30
	STS  _sek1+2,R30
	STS  _sek1+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xC1:
	__CPD2N 0x2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0xC2:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xC3:
	LDI  R30,LOW(0)
	STS  _sek3,R30
	STS  _sek3+1,R30
	STS  _sek3+2,R30
	STS  _sek3+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xC4:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC5:
	LDI  R30,LOW(_PORTMM)
	LDI  R31,HIGH(_PORTMM)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC6:
	OR   R30,R0
	STS  _PORT_F,R30
	LDS  R30,_PORT_STER3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0xC7:
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xC8:
	LDI  R30,LOW(0)
	STS  _sek2,R30
	STS  _sek2+1,R30
	STS  _sek2+2,R30
	STS  _sek2+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0xC9:
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xCA:
	LDI  R30,LOW(_PORTKK)
	LDI  R31,HIGH(_PORTKK)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(117)
	LDI  R31,HIGH(117)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xCB:
	STS  _PORT_F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xCC:
	LDI  R30,LOW(0)
	STS  _sek4,R30
	STS  _sek4+1,R30
	STS  _sek4+2,R30
	STS  _sek4+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 42 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0xCD:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0xCE:
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
SUBOPT_0xCF:
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	RJMP SUBOPT_0xC7

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xD0:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xD1:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0xCD

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:137 WORDS
SUBOPT_0xD2:
	LDS  R26,_cykl_sterownik_1
	LDS  R27,_cykl_sterownik_1+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0xD3:
	CALL __LTW12
	MOV  R0,R30
	MOVW R26,R8
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xB5

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0xD4:
	ST   -Y,R31
	ST   -Y,R30
	CALL _sterownik_1_praca
	RJMP SUBOPT_0xC2

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:62 WORDS
SUBOPT_0xD5:
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0xD6:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0xD8:
	CALL __LTW12
	MOV  R0,R30
	MOVW R30,R8
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __LTW12
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x77

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD9:
	__GETW1MN _a,12
	RJMP SUBOPT_0xD4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0xDA:
	CALL __EQW12
	MOV  R0,R30
	MOVW R30,R8
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __LTW12
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x77

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xDB:
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xDC:
	MOVW R30,R8
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	RJMP SUBOPT_0xD5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xDD:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xDE:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xBB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xDF:
	__GETW1MN _a,16
	RJMP SUBOPT_0xD4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE0:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 54 TIMES, CODE SIZE REDUCTION:209 WORDS
SUBOPT_0xE1:
	LDS  R26,_cykl_sterownik_4
	LDS  R27,_cykl_sterownik_4+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0xE2:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster4
	LDS  R27,_abs_ster4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0xE3:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0xE4:
	LDS  R26,_powrot_przedwczesny_druciak
	LDS  R27,_powrot_przedwczesny_druciak+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0xE5:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xE6:
	CALL _sterownik_4_praca
	RJMP SUBOPT_0xCD

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0xE7:
	CALL __EQW12
	MOV  R0,R30
	MOVW R30,R4
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE8:
	CALL __LTW12
	AND  R0,R30
	RCALL SUBOPT_0xE4
	RJMP SUBOPT_0xB5

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE9:
	LDS  R30,_koniec_rzedu_10
	LDS  R31,_koniec_rzedu_10+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0xEA:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xEB:
	LDS  R30,_abs_ster4
	LDS  R31,_abs_ster4+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xEC:
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
SUBOPT_0xED:
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
	STS  _sek13,R30
	STS  _sek13+1,R30
	STS  _sek13+2,R30
	STS  _sek13+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 44 TIMES, CODE SIZE REDUCTION:169 WORDS
SUBOPT_0xEE:
	LDS  R26,_cykl_sterownik_3
	LDS  R27,_cykl_sterownik_3+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0xEF:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster3
	LDS  R27,_abs_ster3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xF0:
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0xB5

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xF1:
	ST   -Y,R31
	ST   -Y,R30
	CALL _sterownik_3_praca
	RJMP SUBOPT_0xC9

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0xF2:
	CALL __EQW12
	MOV  R0,R30
	MOVW R30,R6
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF3:
	CALL __LTW12
	AND  R0,R30
	RJMP SUBOPT_0xF0

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:66 WORDS
SUBOPT_0xF4:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF5:
	LDS  R30,_abs_ster3
	LDS  R31,_abs_ster3+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xF6:
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
SUBOPT_0xF7:
	LDI  R30,LOW(0)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF8:
	AND  R0,R30
	RCALL SUBOPT_0xE4
	RJMP SUBOPT_0xB5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF9:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xAF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xFA:
	CALL __EQW12
	AND  R0,R30
	MOVW R30,R4
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
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
SUBOPT_0xFB:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _powrot_przedwczesny_krazek_scierny,R30
	STS  _powrot_przedwczesny_krazek_scierny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xFC:
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x77

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xFD:
	CALL _sterownik_3_praca
	RJMP SUBOPT_0xC9

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xFE:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0xFC

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xFF:
	LDI  R30,LOW(0)
	STS  _powrot_przedwczesny_krazek_scierny,R30
	STS  _powrot_przedwczesny_krazek_scierny+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x100:
	CALL __EQW12
	AND  R0,R30
	MOVW R30,R6
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x101:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x102:
	RCALL SUBOPT_0xE4
	RJMP SUBOPT_0x77

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x103:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0xA2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x104:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x102

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x105:
	LDI  R30,LOW(0)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x106:
	MOVW R30,R4
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RJMP SUBOPT_0xF2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x107:
	CALL __EQW12
	AND  R0,R30
	RJMP SUBOPT_0xEE

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x108:
	CALL __EQW12
	AND  R0,R30
	RJMP SUBOPT_0xE1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x109:
	CALL __EQW12
	AND  R0,R30
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0xE3

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x10A:
	RCALL SUBOPT_0xE4
	RJMP SUBOPT_0xE3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x10B:
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x10C:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	RJMP SUBOPT_0xF4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x10D:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10E:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x10F:
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x110:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xAF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x111:
	LDI  R26,LOW(_szczotka_druc_cykl)
	LDI  R27,HIGH(_szczotka_druc_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x112:
	LDS  R26,_statystyka
	LDS  R27,_statystyka+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x113:
	LDS  R30,_szczotka_druc_cykl
	LDS  R31,_szczotka_druc_cykl+1
	RJMP SUBOPT_0xA4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x114:
	LDS  R30,_cykl_ilosc_zaciskow
	LDS  R31,_cykl_ilosc_zaciskow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x115:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x116:
	LDI  R26,LOW(_krazek_scierny_cykl)
	LDI  R27,HIGH(_krazek_scierny_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x117:
	LDS  R30,_krazek_scierny_cykl
	LDS  R31,_krazek_scierny_cykl+1
	RJMP SUBOPT_0x115

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x118:
	CALL __EQW12
	AND  R0,R30
	MOVW R30,R4
	RCALL SUBOPT_0x10F
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x119:
	LDS  R30,_powrot_przedwczesny_krazek_scierny
	LDS  R31,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x115

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11A:
	LDS  R30,_wykonano_powrot_przedwczesny_krazek_scierny
	LDS  R31,_wykonano_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x115

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11B:
	MOVW R30,R6
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11C:
	LDS  R30,_powrot_przedwczesny_druciak
	LDS  R31,_powrot_przedwczesny_druciak+1
	RJMP SUBOPT_0xA4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11D:
	LDS  R30,_wykonano_powrot_przedwczesny_druciak
	LDS  R31,_wykonano_powrot_przedwczesny_druciak+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x9D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x11E:
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
SUBOPT_0x11F:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x120:
	LDI  R30,LOW(0)
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
	RJMP SUBOPT_0x116

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x121:
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	CP   R6,R26
	CPC  R7,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x122:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x123:
	LDI  R30,LOW(0)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x124:
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
	RJMP SUBOPT_0xB5

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x125:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0xB5

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x126:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x127:
	CALL __EQW12
	AND  R0,R30
	MOVW R30,R4
	RCALL SUBOPT_0x10F
	CALL __EQW12
	AND  R30,R0
	MOV  R1,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	MOV  R0,R30
	RJMP SUBOPT_0x11B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x128:
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	MOV  R22,R30
	MOV  R0,R30
	MOVW R30,R4
	RCALL SUBOPT_0x10F
	RJMP SUBOPT_0x108

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x129:
	MOV  R1,R30
	MOV  R0,R22
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0x77

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12A:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12B:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RJMP SUBOPT_0xB1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12D:
	LDI  R30,LOW(0)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12E:
	LDI  R30,LOW(0)
	STS  _cykl_ilosc_zaciskow,R30
	STS  _cykl_ilosc_zaciskow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12F:
	MOV  R0,R30
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x130:
	LDS  R26,_il_zaciskow_rzad_2
	LDS  R27,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x131:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x132:
	__GETW1MN _macierz_zaciskow,4
	RJMP SUBOPT_0x131

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x133:
	MOV  R0,R30
	RCALL SUBOPT_0x130
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x134:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x135:
	LDS  R30,_il_zaciskow_rzad_2
	LDS  R31,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x136:
	LDS  R26,_cykl_sterownik_1
	LDS  R27,_cykl_sterownik_1+1
	SBIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x137:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	SBIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x138:
	CALL _sterownik_2_praca
	RJMP SUBOPT_0xC4

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x139:
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13A:
	LDI  R30,LOW(0)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x13B:
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x13C:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13D:
	RCALL SUBOPT_0x90
	RJMP SUBOPT_0x77

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x13E:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x138

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13F:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x140:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	RJMP SUBOPT_0xEA

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x141:
	LDS  R26,_cykl_sterownik_4
	LDS  R27,_cykl_sterownik_4+1
	SBIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x142:
	LDI  R30,LOW(0)
	STS  _sek13,R30
	STS  _sek13+1,R30
	STS  _sek13+2,R30
	STS  _sek13+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x143:
	MOVW R30,R4
	RCALL SUBOPT_0x10F
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x144:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0x13B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x145:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RJMP SUBOPT_0xE3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x146:
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x147:
	CALL __LTW12
	RJMP SUBOPT_0x146

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x148:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0x77

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x149:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14A:
	RCALL SUBOPT_0x135
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x14B:
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x14C:
	LDI  R30,LOW(0)
	STS  _sek12,R30
	STS  _sek12+1,R30
	STS  _sek12+2,R30
	STS  _sek12+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x14D:
	LDS  R30,_PORT_F
	ORI  R30,0x10
	RJMP SUBOPT_0xC7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14E:
	CALL __LTW12
	MOV  R0,R30
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14F:
	SBIW R30,2
	RCALL SUBOPT_0x14B
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x150:
	SBIW R30,1
	RCALL SUBOPT_0x14B
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x151:
	SBIW R30,2
	RCALL SUBOPT_0x14B
	CALL __GEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x152:
	CALL __LTW12
	MOV  R0,R30
	RJMP SUBOPT_0x135

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x153:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x154:
	MOV  R0,R30
	LDS  R26,_cykl_glowny
	LDS  R27,_cykl_glowny+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x155:
	CALL _wartosc_parametru_panelu
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h)
	RJMP SUBOPT_0x153

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x156:
	LDS  R26,_czas_pracy_szczotki_drucianej_h
	LDS  R27,_czas_pracy_szczotki_drucianej_h+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x157:
	LDS  R26,_czas_pracy_krazka_sciernego_h_34
	LDS  R27,_czas_pracy_krazka_sciernego_h_34+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x158:
	LDS  R26,_czas_pracy_krazka_sciernego_h_36
	LDS  R27,_czas_pracy_krazka_sciernego_h_36+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x159:
	LDS  R26,_czas_pracy_krazka_sciernego_h_38
	LDS  R27,_czas_pracy_krazka_sciernego_h_38+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15A:
	LDS  R26,_czas_pracy_krazka_sciernego_h_41
	LDS  R27,_czas_pracy_krazka_sciernego_h_41+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15B:
	LDS  R26,_czas_pracy_krazka_sciernego_h_43
	LDS  R27,_czas_pracy_krazka_sciernego_h_43+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15C:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	RJMP SUBOPT_0x14B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15E:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RCALL SUBOPT_0x14B
	CALL __EQW12
	RJMP SUBOPT_0x12F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15F:
	RCALL SUBOPT_0x135
	RCALL SUBOPT_0x14B
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0x130
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x160:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RJMP SUBOPT_0x13B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x161:
	LDS  R26,_wykonalem_rzedow
	LDS  R27,_wykonalem_rzedow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x162:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	RJMP SUBOPT_0x134

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x163:
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
SUBOPT_0x164:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x165:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x166:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	JMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x167:
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
