
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
	.DB  0x6E,0x61,0x20,0x31,0x37,0x2D,0x73,0x74
	.DB  0x6B,0x65,0x0,0x57,0x79,0x6D,0x69,0x65
	.DB  0x6E,0x20,0x73,0x7A,0x63,0x7A,0x6F,0x74
	.DB  0x6B,0x65,0x20,0x64,0x72,0x75,0x63,0x69
	.DB  0x61,0x6E,0x61,0x20,0x31,0x35,0x2D,0x73
	.DB  0x74,0x6B,0x65,0x0,0x57,0x79,0x6D,0x69
	.DB  0x65,0x6E,0x20,0x6B,0x72,0x61,0x7A,0x65
	.DB  0x6B,0x20,0x73,0x63,0x69,0x65,0x72,0x6E
	.DB  0x79,0x20,0x64,0x6F,0x20,0x6B,0x6F,0x72
	.DB  0x70,0x75,0x73,0x75,0x20,0x6F,0x20,0x73
	.DB  0x72,0x65,0x64,0x6E,0x69,0x63,0x79,0x20
	.DB  0x33,0x34,0x0,0x57,0x79,0x6D,0x69,0x65
	.DB  0x6E,0x20,0x6B,0x72,0x61,0x7A,0x65,0x6B
	.DB  0x20,0x73,0x63,0x69,0x65,0x72,0x6E,0x79
	.DB  0x20,0x64,0x6F,0x20,0x6B,0x6F,0x72,0x70
	.DB  0x75,0x73,0x75,0x20,0x6F,0x20,0x73,0x72
	.DB  0x65,0x64,0x6E,0x69,0x63,0x79,0x20,0x33
	.DB  0x36,0x0,0x57,0x79,0x6D,0x69,0x65,0x6E
	.DB  0x20,0x6B,0x72,0x61,0x7A,0x65,0x6B,0x20
	.DB  0x73,0x63,0x69,0x65,0x72,0x6E,0x79,0x20
	.DB  0x64,0x6F,0x20,0x6B,0x6F,0x72,0x70,0x75
	.DB  0x73,0x75,0x20,0x6F,0x20,0x73,0x72,0x65
	.DB  0x64,0x6E,0x69,0x63,0x79,0x20,0x33,0x38
	.DB  0x0,0x57,0x79,0x6D,0x69,0x65,0x6E,0x20
	.DB  0x6B,0x72,0x61,0x7A,0x65,0x6B,0x20,0x73
	.DB  0x63,0x69,0x65,0x72,0x6E,0x79,0x20,0x64
	.DB  0x6F,0x20,0x6B,0x6F,0x72,0x70,0x75,0x73
	.DB  0x75,0x20,0x6F,0x20,0x73,0x72,0x65,0x64
	.DB  0x6E,0x69,0x63,0x79,0x20,0x34,0x31,0x0
	.DB  0x57,0x79,0x6D,0x69,0x65,0x6E,0x20,0x6B
	.DB  0x72,0x61,0x7A,0x65,0x6B,0x20,0x73,0x63
	.DB  0x69,0x65,0x72,0x6E,0x79,0x20,0x64,0x6F
	.DB  0x20,0x6B,0x6F,0x72,0x70,0x75,0x73,0x75
	.DB  0x20,0x6F,0x20,0x73,0x72,0x65,0x64,0x6E
	.DB  0x69,0x63,0x79,0x20,0x34,0x33,0x0,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x0,0x57
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
;int czas_pracy_szczotki_drucianej_h_17;
;int czas_pracy_szczotki_drucianej_h_15;
;
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
; 0000 00D3 {
_sprawdz_pin0:
; 0000 00D4 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00D5 i2c_write(numer_pcf);
; 0000 00D6 PORT.byte = i2c_read(0);
; 0000 00D7 i2c_stop();
; 0000 00D8 
; 0000 00D9 
; 0000 00DA return PORT.bits.b0;
	RJMP _0x20A0005
; 0000 00DB }
;
;char sprawdz_pin1(BB PORT, int numer_pcf)
; 0000 00DE {
_sprawdz_pin1:
; 0000 00DF i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00E0 i2c_write(numer_pcf);
; 0000 00E1 PORT.byte = i2c_read(0);
; 0000 00E2 i2c_stop();
; 0000 00E3 
; 0000 00E4 
; 0000 00E5 return PORT.bits.b1;
	LSR  R30
	RJMP _0x20A0005
; 0000 00E6 }
;
;
;char sprawdz_pin2(BB PORT, int numer_pcf)
; 0000 00EA {
_sprawdz_pin2:
; 0000 00EB i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00EC i2c_write(numer_pcf);
; 0000 00ED PORT.byte = i2c_read(0);
; 0000 00EE i2c_stop();
; 0000 00EF 
; 0000 00F0 
; 0000 00F1 return PORT.bits.b2;
	LSR  R30
	LSR  R30
	RJMP _0x20A0005
; 0000 00F2 }
;
;char sprawdz_pin3(BB PORT, int numer_pcf)
; 0000 00F5 {
_sprawdz_pin3:
; 0000 00F6 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00F7 i2c_write(numer_pcf);
; 0000 00F8 PORT.byte = i2c_read(0);
; 0000 00F9 i2c_stop();
; 0000 00FA 
; 0000 00FB 
; 0000 00FC return PORT.bits.b3;
	LSR  R30
	LSR  R30
	LSR  R30
	RJMP _0x20A0005
; 0000 00FD }
;
;char sprawdz_pin4(BB PORT, int numer_pcf)
; 0000 0100 {
_sprawdz_pin4:
; 0000 0101 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0102 i2c_write(numer_pcf);
; 0000 0103 PORT.byte = i2c_read(0);
; 0000 0104 i2c_stop();
; 0000 0105 
; 0000 0106 
; 0000 0107 return PORT.bits.b4;
	SWAP R30
	RJMP _0x20A0005
; 0000 0108 }
;
;char sprawdz_pin5(BB PORT, int numer_pcf)
; 0000 010B {
_sprawdz_pin5:
; 0000 010C i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 010D i2c_write(numer_pcf);
; 0000 010E PORT.byte = i2c_read(0);
; 0000 010F i2c_stop();
; 0000 0110 
; 0000 0111 
; 0000 0112 return PORT.bits.b5;
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	RJMP _0x20A0005
; 0000 0113 }
;
;char sprawdz_pin6(BB PORT, int numer_pcf)
; 0000 0116 {
_sprawdz_pin6:
; 0000 0117 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0118 i2c_write(numer_pcf);
; 0000 0119 PORT.byte = i2c_read(0);
; 0000 011A i2c_stop();
; 0000 011B 
; 0000 011C 
; 0000 011D return PORT.bits.b6;
	CALL SUBOPT_0x1
	RJMP _0x20A0005
; 0000 011E }
;
;char sprawdz_pin7(BB PORT, int numer_pcf)
; 0000 0121 {
_sprawdz_pin7:
; 0000 0122 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0123 i2c_write(numer_pcf);
; 0000 0124 PORT.byte = i2c_read(0);
; 0000 0125 i2c_stop();
; 0000 0126 
; 0000 0127 
; 0000 0128 return PORT.bits.b7;
	ROL  R30
	LDI  R30,0
	ROL  R30
_0x20A0005:
	ANDI R30,LOW(0x1)
	ADIW R28,3
	RET
; 0000 0129 }
;
;int odczytaj_parametr(int adres1, int adres2)
; 0000 012C {
_odczytaj_parametr:
; 0000 012D int z;
; 0000 012E z = 0;
	CALL SUBOPT_0x2
;	adres1 -> Y+4
;	adres2 -> Y+2
;	z -> R16,R17
; 0000 012F putchar(90);
	CALL SUBOPT_0x3
; 0000 0130 putchar(165);
; 0000 0131 putchar(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _putchar
; 0000 0132 putchar(131);
	LDI  R30,LOW(131)
	CALL SUBOPT_0x4
; 0000 0133 putchar(adres1);
; 0000 0134 putchar(adres2);
; 0000 0135 putchar(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar
; 0000 0136 getchar();
	CALL SUBOPT_0x5
; 0000 0137 getchar();
; 0000 0138 getchar();
; 0000 0139 getchar();
	CALL SUBOPT_0x5
; 0000 013A getchar();
; 0000 013B getchar();
; 0000 013C getchar();
	CALL SUBOPT_0x5
; 0000 013D getchar();
; 0000 013E z = getchar();
	MOV  R16,R30
	CLR  R17
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
; 0000 0149 
; 0000 014A 
; 0000 014B return z;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0004
; 0000 014C }
;
;
;
;int czekaj_na_guzik_start(int adres)
; 0000 0151 {
; 0000 0152 //48 to adres zmiennej 30
; 0000 0153 //16 to adres zmiennj 10
; 0000 0154 
; 0000 0155 int z;
; 0000 0156 z = 0;
;	adres -> Y+2
;	z -> R16,R17
; 0000 0157 putchar(90);
; 0000 0158 putchar(165);
; 0000 0159 putchar(4);
; 0000 015A putchar(131);
; 0000 015B putchar(0);
; 0000 015C putchar(adres);  //adres zmiennej - 30
; 0000 015D putchar(1);
; 0000 015E getchar();
; 0000 015F getchar();
; 0000 0160 getchar();
; 0000 0161 getchar();
; 0000 0162 getchar();
; 0000 0163 getchar();
; 0000 0164 getchar();
; 0000 0165 getchar();
; 0000 0166 z = getchar();
; 0000 0167 //itoa(z,dupa1);
; 0000 0168 //lcd_puts(dupa1);
; 0000 0169 
; 0000 016A return z;
; 0000 016B }
;
;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0172 {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0173 // Place your code here
; 0000 0174 //16,384 ms
; 0000 0175 sek1++;     //Ster 1
	LDI  R26,LOW(_sek1)
	LDI  R27,HIGH(_sek1)
	CALL SUBOPT_0x6
; 0000 0176 sek2++;     //ster 3
	LDI  R26,LOW(_sek2)
	LDI  R27,HIGH(_sek2)
	CALL SUBOPT_0x6
; 0000 0177 
; 0000 0178 
; 0000 0179 sek3++;     //ster 2
	LDI  R26,LOW(_sek3)
	LDI  R27,HIGH(_sek3)
	CALL SUBOPT_0x6
; 0000 017A sek4++;     //ster 4
	LDI  R26,LOW(_sek4)
	LDI  R27,HIGH(_sek4)
	CALL SUBOPT_0x6
; 0000 017B 
; 0000 017C 
; 0000 017D //sek10++;
; 0000 017E 
; 0000 017F sek11++;  //do wyboru zacisku
	LDI  R26,LOW(_sek11)
	LDI  R27,HIGH(_sek11)
	CALL SUBOPT_0x6
; 0000 0180 sek12++;  //do czasu przedmuchu
	LDI  R26,LOW(_sek12)
	LDI  R27,HIGH(_sek12)
	CALL SUBOPT_0x6
; 0000 0181 
; 0000 0182 sek13++;  //do czasu zatrzymania sie druciaka na gorze
	LDI  R26,LOW(_sek13)
	LDI  R27,HIGH(_sek13)
	CALL SUBOPT_0x6
; 0000 0183 
; 0000 0184 sek20++;
	LDI  R26,LOW(_sek20)
	LDI  R27,HIGH(_sek20)
	CALL SUBOPT_0x6
; 0000 0185 /*
; 0000 0186 if(PORTE.3 == 1)
; 0000 0187       {
; 0000 0188       czas_pracy_szczotki_drucianej++;
; 0000 0189       czas_pracy_krazka_sciernego++;
; 0000 018A       if(czas_pracy_szczotki_drucianej == 61 * 60 * 60)
; 0000 018B             {
; 0000 018C             czas_pracy_szczotki_drucianej = 0;
; 0000 018D             czas_pracy_szczotki_drucianej_h++;
; 0000 018E             }
; 0000 018F       if(czas_pracy_krazka_sciernego == 61 * 60 * 60)
; 0000 0190             {
; 0000 0191             czas_pracy_krazka_sciernego = 0;
; 0000 0192             czas_pracy_krazka_sciernego_h++;
; 0000 0193             }
; 0000 0194       }
; 0000 0195 
; 0000 0196 
; 0000 0197       //61 razy - 1s
; 0000 0198       //61 * 60 - 1 minuta
; 0000 0199       //61 * 60 * 60 - 1h
; 0000 019A 
; 0000 019B */
; 0000 019C 
; 0000 019D }
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
; 0000 01A6 {
_komunikat_na_panel:
; 0000 01A7 int h;
; 0000 01A8 
; 0000 01A9 h = 0;
	CALL SUBOPT_0x2
;	*fmtstr -> Y+6
;	adres2 -> Y+4
;	adres22 -> Y+2
;	h -> R16,R17
; 0000 01AA h = strlenf(fmtstr);
	CALL SUBOPT_0x7
	CALL _strlenf
	MOVW R16,R30
; 0000 01AB h = h + 3;
	__ADDWRN 16,17,3
; 0000 01AC 
; 0000 01AD putchar(90);
	CALL SUBOPT_0x3
; 0000 01AE putchar(165);
; 0000 01AF putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL _putchar
; 0000 01B0 putchar(130);  //82
	LDI  R30,LOW(130)
	CALL SUBOPT_0x4
; 0000 01B1 putchar(adres2);    //
; 0000 01B2 putchar(adres22);  //
; 0000 01B3 printf(fmtstr);
	CALL SUBOPT_0x7
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 01B4 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;
;
;
;void wartosc_parametru_panelu(int wartosc, int adres1, int adres2)
; 0000 01B9 {
_wartosc_parametru_panelu:
; 0000 01BA putchar(90);  //5A
;	wartosc -> Y+4
;	adres1 -> Y+2
;	adres2 -> Y+0
	CALL SUBOPT_0x3
; 0000 01BB putchar(165); //A5
; 0000 01BC putchar(5);//05
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 01BD putchar(130);  //82    /
; 0000 01BE putchar(adres1);    //00
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
; 0000 01BF putchar(adres2);   //40
	CALL SUBOPT_0x9
; 0000 01C0 putchar(0);    //00
; 0000 01C1 putchar(wartosc);   //80
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _putchar
; 0000 01C2 }
_0x20A0004:
	ADIW R28,6
	RET
;
;
;void zaktualizuj_parametry_panelu()
; 0000 01C6 {
_zaktualizuj_parametry_panelu:
; 0000 01C7 
; 0000 01C8 /////////////////////////
; 0000 01C9 //wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
; 0000 01CA 
; 0000 01CB //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
; 0000 01CC 
; 0000 01CD //wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
; 0000 01CE 
; 0000 01CF //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
; 0000 01D0 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
; 0000 01D1 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
; 0000 01D2 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
; 0000 01D3 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
; 0000 01D4 
; 0000 01D5 //////////////////////////
; 0000 01D6 
; 0000 01D7 
; 0000 01D8 
; 0000 01D9 
; 0000 01DA if(zaaktualizuj_ilosc_rzad2 == 1)
	LDS  R26,_zaaktualizuj_ilosc_rzad2
	LDS  R27,_zaaktualizuj_ilosc_rzad2+1
	SBIW R26,1
	BRNE _0xD
; 0000 01DB     {
; 0000 01DC     wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad2
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	RCALL _wartosc_parametru_panelu
; 0000 01DD     zaaktualizuj_ilosc_rzad2 = 0;
	LDI  R30,LOW(0)
	STS  _zaaktualizuj_ilosc_rzad2,R30
	STS  _zaaktualizuj_ilosc_rzad2+1,R30
; 0000 01DE     }
; 0000 01DF }
_0xD:
	RET
;
;void komunikat_z_czytnika_kodow(char flash *fmtstr,int rzad, int na_plus_minus)
; 0000 01E2 {
_komunikat_z_czytnika_kodow:
; 0000 01E3 //na_plus_minus = 1;  to jest na plus
; 0000 01E4 //na_plus_minus = 0;  to jest na minus
; 0000 01E5 
; 0000 01E6 int h, adres1,adres11,adres2,adres22;
; 0000 01E7 
; 0000 01E8 h = 0;
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
; 0000 01E9 h = strlenf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOVW R16,R30
; 0000 01EA h = h + 3;
	__ADDWRN 16,17,3
; 0000 01EB 
; 0000 01EC if(rzad == 1)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BRNE _0xE
; 0000 01ED    {
; 0000 01EE    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01EF    adres11 = 80;
	__GETWRN 20,21,80
; 0000 01F0    adres2 = 80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01F1    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01F2    }
; 0000 01F3 if(rzad == 2)
_0xE:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,2
	BRNE _0xF
; 0000 01F4    {
; 0000 01F5    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01F6    adres11 = 32;
	__GETWRN 20,21,32
; 0000 01F7    adres2 = 64;
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01F8    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01F9    }
; 0000 01FA 
; 0000 01FB putchar(90);
_0xF:
	CALL SUBOPT_0x3
; 0000 01FC putchar(165);
; 0000 01FD putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL SUBOPT_0x8
; 0000 01FE putchar(130);  //82
; 0000 01FF putchar(adres1);    //
	ST   -Y,R18
	CALL _putchar
; 0000 0200 putchar(adres11);  //
	ST   -Y,R20
	CALL _putchar
; 0000 0201 printf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 0202 
; 0000 0203 
; 0000 0204 if(rzad == 1 & macierz_zaciskow[rzad]==0)
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	BREQ _0x10
; 0000 0205     {
; 0000 0206     komunikat_na_panel("                                                ",144,80);//128,144
	CALL SUBOPT_0xE
; 0000 0207     komunikat_na_panel("Zacisk nie zmierzony u Wykonawcy",144,80);
	__POINTW1FN _0x0,49
	CALL SUBOPT_0xF
; 0000 0208     }
; 0000 0209 
; 0000 020A if(rzad == 1 & na_plus_minus == 1)
_0x10:
	CALL SUBOPT_0xC
	CALL SUBOPT_0x10
	BREQ _0x11
; 0000 020B     {
; 0000 020C     komunikat_na_panel("                                                ",144,80);  //128,144
	CALL SUBOPT_0xE
; 0000 020D     //komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
; 0000 020E     komunikat_na_panel("Kly w kierunku prawej strony",144,80);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0xF
; 0000 020F     }
; 0000 0210 
; 0000 0211 if(rzad == 1 & na_plus_minus == 0)
_0x11:
	CALL SUBOPT_0xC
	CALL SUBOPT_0x11
	BREQ _0x12
; 0000 0212     {
; 0000 0213     komunikat_na_panel("                                                ",144,80);  //128,144
	CALL SUBOPT_0xE
; 0000 0214     //komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
; 0000 0215     komunikat_na_panel("Kly w kierunku lewej strony",144,80);
	__POINTW1FN _0x0,111
	CALL SUBOPT_0xF
; 0000 0216     }
; 0000 0217 
; 0000 0218 
; 0000 0219 if(rzad == 2 & na_plus_minus == 1)
_0x12:
	CALL SUBOPT_0x12
	CALL SUBOPT_0x10
	BREQ _0x13
; 0000 021A     {
; 0000 021B     komunikat_na_panel("                                                ",128,144);  //144,80
	CALL SUBOPT_0x13
; 0000 021C     //komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
; 0000 021D     komunikat_na_panel("Kly w kierunku lewej strony",128,144);
	__POINTW1FN _0x0,111
	CALL SUBOPT_0x14
; 0000 021E     }
; 0000 021F 
; 0000 0220 if(rzad == 2 & na_plus_minus == 0)
_0x13:
	CALL SUBOPT_0x12
	CALL SUBOPT_0x11
	BREQ _0x14
; 0000 0221     {
; 0000 0222     komunikat_na_panel("                                                ",128,144); //144,80
	CALL SUBOPT_0x13
; 0000 0223     //komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
; 0000 0224     komunikat_na_panel("Kly w kierunku prawej strony",128,144);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0x14
; 0000 0225     }
; 0000 0226 
; 0000 0227 if(rzad == 2 & macierz_zaciskow[rzad]==0)
_0x14:
	CALL SUBOPT_0x12
	CALL SUBOPT_0xD
	BREQ _0x15
; 0000 0228     {
; 0000 0229     komunikat_na_panel("                                                ",128,144);  //144,80
	CALL SUBOPT_0x13
; 0000 022A     komunikat_na_panel("Zacisk nie zmierzony u Wykonawcy",128,144);
	__POINTW1FN _0x0,49
	CALL SUBOPT_0x14
; 0000 022B     }
; 0000 022C 
; 0000 022D 
; 0000 022E }
_0x15:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;
;void zerowanie_pam_wew()
; 0000 0231 {
; 0000 0232 /*
; 0000 0233 if(czas_pracy_szczotki_drucianej_h >= 255 | czas_pracy_krazka_sciernego_h >=255 | czas_pracy_krazka_sciernego_stala >= 255 | czas_pracy_szczotki_drucianej_stala >= 255 |
; 0000 0234    szczotka_druciana_ilosc_cykli >= 255 | krazek_scierny_ilosc_cykli >= 255 | krazek_scierny_cykl_po_okregu_ilosc >=255)
; 0000 0235      {
; 0000 0236      czas_pracy_szczotki_drucianej_h = 0;
; 0000 0237      czas_pracy_szczotki_drucianej = 0;
; 0000 0238      czas_pracy_krazka_sciernego_h = 0;
; 0000 0239      czas_pracy_krazka_sciernego = 0;
; 0000 023A      czas_pracy_krazka_sciernego_stala = 5;
; 0000 023B      czas_pracy_szczotki_drucianej_stala = 5;
; 0000 023C      szczotka_druciana_ilosc_cykli = 3;
; 0000 023D      krazek_scierny_ilosc_cykli = 3;
; 0000 023E      krazek_scierny_cykl_po_okregu_ilosc = 3;
; 0000 023F      }
; 0000 0240 */
; 0000 0241 
; 0000 0242 /*
; 0000 0243 if(czas_pracy_krazka_sciernego_h >= 255)
; 0000 0244      {
; 0000 0245      czas_pracy_krazka_sciernego_h = 0;
; 0000 0246      czas_pracy_krazka_sciernego = 0;
; 0000 0247      }
; 0000 0248 if(czas_pracy_krazka_sciernego_stala >= 255)
; 0000 0249      czas_pracy_krazka_sciernego_stala = 5;
; 0000 024A 
; 0000 024B if(czas_pracy_szczotki_drucianej_stala >= 255)
; 0000 024C      czas_pracy_szczotki_drucianej_stala = 5;
; 0000 024D 
; 0000 024E if(szczotka_druciana_ilosc_cykli >= 255)
; 0000 024F 
; 0000 0250 if(krazek_scierny_ilosc_cykli >= 255)
; 0000 0251 
; 0000 0252 if(krazek_scierny_cykl_po_okregu_ilosc >=255)
; 0000 0253 */
; 0000 0254 
; 0000 0255 }
;
;
;void odpytaj_parametry_panelu()
; 0000 0259 {
_odpytaj_parametry_panelu:
; 0000 025A // to wylaczam tylko do testow w switniakch
; 0000 025B if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	POP  R26
	AND  R30,R26
	BREQ _0x16
; 0000 025C     start = odczytaj_parametr(0,64);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x18
	STS  _start,R30
	STS  _start+1,R31
; 0000 025D il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
_0x16:
	CALL SUBOPT_0xA
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
; 0000 025E il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
; 0000 025F 
; 0000 0260 
; 0000 0261 
; 0000 0262 szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1D
; 0000 0263                                                 //2090
; 0000 0264 krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
; 0000 0265                                                     //3000
; 0000 0266 krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
	CALL SUBOPT_0xA
	RCALL _odczytaj_parametr
	MOVW R8,R30
; 0000 0267 
; 0000 0268 //////////////////////////////////////////////
; 0000 0269 czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
; 0000 026A 
; 0000 026B czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
	CALL SUBOPT_0x20
; 0000 026C 
; 0000 026D 
; 0000 026E czas_pracy_szczotki_drucianej_h_17 = odczytaj_parametr(0,144);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
; 0000 026F czas_pracy_szczotki_drucianej_h_15 = odczytaj_parametr(16,128);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x19
	CALL SUBOPT_0x23
; 0000 0270 
; 0000 0271 
; 0000 0272 czas_pracy_krazka_sciernego_h_34 = odczytaj_parametr(96,48);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1B
	RCALL _odczytaj_parametr
	CALL SUBOPT_0x25
; 0000 0273 czas_pracy_krazka_sciernego_h_36 = odczytaj_parametr(96,64);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x18
	CALL SUBOPT_0x26
; 0000 0274 czas_pracy_krazka_sciernego_h_38 = odczytaj_parametr(96,80);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
; 0000 0275 czas_pracy_krazka_sciernego_h_41 = odczytaj_parametr(96,96);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x24
	RCALL _odczytaj_parametr
	CALL SUBOPT_0x29
; 0000 0276 czas_pracy_krazka_sciernego_h_43 = odczytaj_parametr(96,112);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x2A
; 0000 0277 
; 0000 0278 //////////////////////////////////////////////////////////
; 0000 0279 
; 0000 027A test_geometryczny_rzad_1 = odczytaj_parametr(48,80);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x27
	STS  _test_geometryczny_rzad_1,R30
	STS  _test_geometryczny_rzad_1+1,R31
; 0000 027B 
; 0000 027C test_geometryczny_rzad_2 = odczytaj_parametr(48,96);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x24
	RCALL _odczytaj_parametr
	STS  _test_geometryczny_rzad_2,R30
	STS  _test_geometryczny_rzad_2+1,R31
; 0000 027D 
; 0000 027E srednica_krazka_sciernego = odczytaj_parametr(48,112);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x2B
; 0000 027F 
; 0000 0280 ruch_haos = odczytaj_parametr(48,144);
	CALL SUBOPT_0x21
	STS  _ruch_haos,R30
	STS  _ruch_haos+1,R31
; 0000 0281 
; 0000 0282 tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1E
	MOVW R10,R30
; 0000 0283                                                 //2050
; 0000 0284 //zerowanie_pam_wew();
; 0000 0285 
; 0000 0286 }
	RET
;
;void wyrrrjscia_i_wejscia_opis()
; 0000 0289 {
; 0000 028A 
; 0000 028B 
; 0000 028C //IN0
; 0000 028D 
; 0000 028E //komunikacja miedzy slave a master
; 0000 028F //sprawdz_pin0(PORTHH,0x73)
; 0000 0290 //sprawdz_pin1(PORTHH,0x73)
; 0000 0291 //sprawdz_pin2(PORTHH,0x73)
; 0000 0292 //sprawdz_pin3(PORTHH,0x73)
; 0000 0293 //sprawdz_pin4(PORTHH,0x73)
; 0000 0294 //sprawdz_pin5(PORTHH,0x73)
; 0000 0295 //sprawdz_pin6(PORTHH,0x73)
; 0000 0296 //sprawdz_pin7(PORTHH,0x73)
; 0000 0297 
; 0000 0298 //IN1
; 0000 0299 //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 029A //sprawdz_pin1(PORTJJ,0x79)  AREA   STEROWNIK1
; 0000 029B //sprawdz_pin2(PORTJJ,0x79)  SETON  STEROWNIK1
; 0000 029C //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 029D //sprawdz_pin4(PORTJJ,0x79)  SVRE   STEROWNIK1
; 0000 029E //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 029F //sprawdz_pin6(PORTJJ,0x79)  czujnik cisnienia
; 0000 02A0 //sprawdz_pin7(PORTJJ,0x79)
; 0000 02A1 
; 0000 02A2 //IN2
; 0000 02A3 //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 02A4 //sprawdz_pin1(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK3
; 0000 02A5 //sprawdz_pin2(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK3
; 0000 02A6 //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 02A7 //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 02A8 //sprawdz_pin5(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK4
; 0000 02A9 //sprawdz_pin6(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK4
; 0000 02AA //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 02AB 
; 0000 02AC //IN3
; 0000 02AD //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 02AE //sprawdz_pin1(PORTLL,0x71)  AREA   STEROWNIK2
; 0000 02AF //sprawdz_pin2(PORTLL,0x71)  SETON  STEROWNIK2
; 0000 02B0 //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 02B1 //sprawdz_pin4(PORTLL,0x71)  SVRE   STEROWNIK2
; 0000 02B2 //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 02B3 //sprawdz_pin6(PORTLL,0x71)  S6A przek³adanie rzedow
; 0000 02B4 //sprawdz_pin7(PORTLL,0x71)  S6B przekladanie rzedow
; 0000 02B5 
; 0000 02B6 //IN4
; 0000 02B7 //sprawdz_pin0(PORTMM,0x77) J2  czujnik indukcyjny domkniecia pokrywy
; 0000 02B8 //sprawdz_pin1(PORTMM,0x77) J3  czujnik indukcyjny domkniecia pokrywy
; 0000 02B9 //sprawdz_pin2(PORTMM,0x77)
; 0000 02BA //sprawdz_pin3(PORTMM,0x77)
; 0000 02BB //sprawdz_pin4(PORTMM,0x77)
; 0000 02BC //sprawdz_pin5(PORTMM,0x77)
; 0000 02BD //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 02BE //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 02BF 
; 0000 02C0 //sterownik 1 i sterownik 3 - krazek scierny
; 0000 02C1 //sterownik 2 i sterownik 4 - druciak
; 0000 02C2 
; 0000 02C3 //OUT
; 0000 02C4 //PORTA.0   IN0  STEROWNIK1        OUT 1
; 0000 02C5 //PORTA.1   IN1  STEROWNIK1
; 0000 02C6 //PORTA.2   IN2  STEROWNIK1
; 0000 02C7 //PORTA.3   IN3  STEROWNIK1
; 0000 02C8 //PORTA.4   IN4  STEROWNIK1
; 0000 02C9 //PORTA.5   IN5  STEROWNIK1
; 0000 02CA //PORTA.6   IN6  STEROWNIK1
; 0000 02CB //PORTA.7   IN7  STEROWNIK1
; 0000 02CC 
; 0000 02CD //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 02CE //PORTB.1   IN1  STEROWNIK4
; 0000 02CF //PORTB.2   IN2  STEROWNIK4
; 0000 02D0 //PORTB.3   IN3  STEROWNIK4
; 0000 02D1 //PORTB.4   4B CEWKA przedmuch osi, byl, juz poloczone z B.6, teraz juz setup poziome
; 0000 02D2 //PORTB.5   DRIVE  STEROWNIK4
; 0000 02D3 //PORTB.6   swiatlo zielone
; 0000 02D4 //PORTB.7   IN5 STEROWNIK 3
; 0000 02D5 
; 0000 02D6 //PORTC.0   IN0  STEROWNIK2        OUT 3
; 0000 02D7 //PORTC.1   IN1  STEROWNIK2
; 0000 02D8 //PORTC.2   IN2  STEROWNIK2
; 0000 02D9 //PORTC.3   IN3  STEROWNIK2
; 0000 02DA //PORTC.4   IN4  STEROWNIK2
; 0000 02DB //PORTC.5   IN5  STEROWNIK2
; 0000 02DC //PORTC.6   IN6  STEROWNIK2
; 0000 02DD //PORTC.7   IN7  STEROWNIK2
; 0000 02DE 
; 0000 02DF //PORTD.0  SDA                     OUT 2
; 0000 02E0 //PORTD.1  SCL
; 0000 02E1 //PORTD.2  SETUP   STEROWNIK1 STEROWNIK 2 STEROIWNIK 3 STEROWNIK 4
; 0000 02E2 //PORTD.3  DRIVE   STEROWNIK1
; 0000 02E3 //PORTD.4  IN8 STEROWNIK1
; 0000 02E4 //PORTD.5  IN8 STEROWNIK2
; 0000 02E5 //PORTD.6  DRIVE   STEROWNIK2
; 0000 02E6 //PORTD.7  swiatlo czerwone i jednoczesnie HOLD
; 0000 02E7 
; 0000 02E8 //PORTE.0
; 0000 02E9 //PORTE.1
; 0000 02EA //PORTE.2  1A CEWKA szczotka druciana                    OUT 6
; 0000 02EB //PORTE.3  1B CEWKA krazek scierny
; 0000 02EC //PORTE.4  IN4  STEROWNIK4
; 0000 02ED //PORTE.5  IN5  STEROWNIK4   ///////////////////////////////////////////////teraz tu bêdzie przedmuch kana³ B
; 0000 02EE //PORTE.6  2A CEWKA przerzucanie docisku zaciskow
; 0000 02EF //PORTE.7  3A CEWKA zacisnij zaciski
; 0000 02F0 
; 0000 02F1 //PORTF.0   IN0  STEROWNIK3             OUT 4
; 0000 02F2 //PORTF.1   IN1  STEROWNIK3
; 0000 02F3 //PORTF.2   IN2  STEROWNIK3
; 0000 02F4 //PORTF.3   IN3  STEROWNIK3
; 0000 02F5 //PORTF.4   4A CEWKA przedmuch zaciskow
; 0000 02F6 //PORTF.5   DRIVE  STEROWNIK3
; 0000 02F7 //PORTF.6   swiatlo zolte
; 0000 02F8 //PORTF.7   IN4 STEROWNIK 3
; 0000 02F9 
; 0000 02FA 
; 0000 02FB 
; 0000 02FC  //PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 02FD //PORTF = PORT_F.byte;
; 0000 02FE //PORTB.6 = 1;  //przedmuch osi
; 0000 02FF //PORTE.2 = 1;  //szlifierka 1
; 0000 0300 //PORTE.3 = 1;  //szlifierka 2
; 0000 0301 //PORTE.6 = 0;  //zacisniety rzad 1
; 0000 0302 //PORTE.6 = 1;  //zacisniety rzad 2
; 0000 0303 //PORTE.7 = 0;    //zacisnij zaciski
; 0000 0304 
; 0000 0305 
; 0000 0306 //macierz_zaciskow[rzad]=44; brak
; 0000 0307 //macierz_zaciskow[rzad]=48; brak
; 0000 0308 //macierz_zaciskow[rzad]=76  brak
; 0000 0309 //macierz_zaciskow[rzad]=80; brak
; 0000 030A //macierz_zaciskow[rzad]=92; brak
; 0000 030B //macierz_zaciskow[rzad]=96;  brak
; 0000 030C //macierz_zaciskow[rzad]=107; brak
; 0000 030D //macierz_zaciskow[rzad]=111; brak
; 0000 030E 
; 0000 030F 
; 0000 0310 
; 0000 0311 
; 0000 0312 /*
; 0000 0313 
; 0000 0314 //testy parzystych i nieparzystych IN0-IN8
; 0000 0315 //testy port/pin
; 0000 0316 //sterownik 3
; 0000 0317 //PORTF.0   IN0  STEROWNIK3
; 0000 0318 //PORTF.1   IN1  STEROWNIK3
; 0000 0319 //PORTF.2   IN2  STEROWNIK3
; 0000 031A //PORTF.3   IN3  STEROWNIK3
; 0000 031B //PORTF.7   IN4 STEROWNIK 3
; 0000 031C //PORTB.7   IN5 STEROWNIK 3
; 0000 031D 
; 0000 031E 
; 0000 031F PORT_F.bits.b0 = 0;
; 0000 0320 PORT_F.bits.b1 = 1;
; 0000 0321 PORT_F.bits.b2 = 0;
; 0000 0322 PORT_F.bits.b3 = 1;
; 0000 0323 PORT_F.bits.b7 = 0;
; 0000 0324 PORTF = PORT_F.byte;
; 0000 0325 PORTB.7 = 1;
; 0000 0326 
; 0000 0327 //sterownik 4
; 0000 0328 
; 0000 0329 //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 032A //PORTB.1   IN1  STEROWNIK4
; 0000 032B //PORTB.2   IN2  STEROWNIK4
; 0000 032C //PORTB.3   IN3  STEROWNIK4
; 0000 032D //PORTE.4  IN4  STEROWNIK4
; 0000 032E 
; 0000 032F 
; 0000 0330 PORTB.0 = 0;
; 0000 0331 PORTB.1 = 1;
; 0000 0332 PORTB.2 = 0;
; 0000 0333 PORTB.3 = 1;
; 0000 0334 PORTE.4 = 0;
; 0000 0335 
; 0000 0336 
; 0000 0337 //ster 1
; 0000 0338 PORTA.0 = 0;   //IN0  STEROWNIK1        OUT 1
; 0000 0339 PORTA.1 = 1;  //IN1  STEROWNIK1
; 0000 033A PORTA.2 = 0;  // IN2  STEROWNIK1
; 0000 033B PORTA.3 = 1;  //IN3  STEROWNIK1
; 0000 033C PORTA.4 = 0;  // IN4  STEROWNIK1
; 0000 033D PORTA.5 = 1;  //IN5  STEROWNIK1
; 0000 033E PORTA.6 = 0;   //IN6  STEROWNIK1
; 0000 033F PORTA.7 = 1;  //IN7  STEROWNIK1
; 0000 0340 PORTD.4 = 0; //IN8 STEROWNIK1
; 0000 0341 
; 0000 0342 
; 0000 0343 
; 0000 0344 //sterownik 2
; 0000 0345 PORTC.0 = 0;   //IN0  STEROWNIK2        OUT 3
; 0000 0346 PORTC.1  = 1;  //IN1  STEROWNIK2
; 0000 0347 PORTC.2 = 0;    //IN2  STEROWNIK2
; 0000 0348 PORTC.3= 1;   //IN3  STEROWNIK2
; 0000 0349 PORTC.4 = 0;   // IN4  STEROWNIK2
; 0000 034A PORTC.5= 1;   //IN5  STEROWNIK2
; 0000 034B PORTC.6 = 0;   // IN6  STEROWNIK2
; 0000 034C PORTC.7= 1;   //IN7  STEROWNIK2
; 0000 034D PORTD.5 = 0;  //IN8 STEROWNIK2
; 0000 034E 
; 0000 034F */
; 0000 0350 
; 0000 0351 }
;
;void sprawdz_cisnienie()
; 0000 0354 {
_sprawdz_cisnienie:
; 0000 0355 int i;
; 0000 0356 i = 0;
	CALL SUBOPT_0x2
;	i -> R16,R17
; 0000 0357 //i = 1;
; 0000 0358 
; 0000 0359 while(i == 0)
_0x17:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x19
; 0000 035A     {
; 0000 035B     if(sprawdz_pin6(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x2C
	RCALL _sprawdz_pin6
	CPI  R30,0
	BRNE _0x1A
; 0000 035C         {
; 0000 035D         i = 1;
	__GETWRN 16,17,1
; 0000 035E         if(cisnienie_sprawdzone == 0)
	LDS  R30,_cisnienie_sprawdzone
	LDS  R31,_cisnienie_sprawdzone+1
	SBIW R30,0
	BRNE _0x1B
; 0000 035F             {
; 0000 0360             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 0361             cisnienie_sprawdzone = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cisnienie_sprawdzone,R30
	STS  _cisnienie_sprawdzone+1,R31
; 0000 0362             }
; 0000 0363 
; 0000 0364         }
_0x1B:
; 0000 0365     else
	RJMP _0x1C
_0x1A:
; 0000 0366         {
; 0000 0367         i = 0;
	__GETWRN 16,17,0
; 0000 0368         cisnienie_sprawdzone = 0;
	LDI  R30,LOW(0)
	STS  _cisnienie_sprawdzone,R30
	STS  _cisnienie_sprawdzone+1,R30
; 0000 0369         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 036A         komunikat_na_panel("Cisnienie za male - mniejsze niz 6 bar",adr1,adr2);
	__POINTW1FN _0x0,139
	CALL SUBOPT_0x2E
; 0000 036B 
; 0000 036C         }
_0x1C:
; 0000 036D     }
	RJMP _0x17
_0x19:
; 0000 036E }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;int odczyt_wybranego_zacisku()
; 0000 0372 {                         //11
_odczyt_wybranego_zacisku:
; 0000 0373 int rzad;
; 0000 0374 
; 0000 0375 PORT_CZYTNIK.bits.b0 = sprawdz_pin0(PORTHH,0x73);
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
; 0000 0376 PORT_CZYTNIK.bits.b1 = sprawdz_pin1(PORTHH,0x73);
	RCALL _sprawdz_pin1
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFD
	CALL SUBOPT_0x30
; 0000 0377 PORT_CZYTNIK.bits.b2 = sprawdz_pin2(PORTHH,0x73);
	RCALL _sprawdz_pin2
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFB
	CALL SUBOPT_0x30
; 0000 0378 PORT_CZYTNIK.bits.b3 = sprawdz_pin3(PORTHH,0x73);
	RCALL _sprawdz_pin3
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0XF7
	CALL SUBOPT_0x30
; 0000 0379 PORT_CZYTNIK.bits.b4 = sprawdz_pin4(PORTHH,0x73);
	RCALL _sprawdz_pin4
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xEF
	CALL SUBOPT_0x30
; 0000 037A PORT_CZYTNIK.bits.b5 = sprawdz_pin5(PORTHH,0x73);
	RCALL _sprawdz_pin5
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xDF
	CALL SUBOPT_0x30
; 0000 037B PORT_CZYTNIK.bits.b6 = sprawdz_pin6(PORTHH,0x73);
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
; 0000 037C PORT_CZYTNIK.bits.b7 = sprawdz_pin7(PORTHH,0x73);
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
; 0000 037D 
; 0000 037E rzad = odczytaj_parametr(32,128);       //20,80
	CALL SUBOPT_0x31
	CALL SUBOPT_0x19
	MOVW R16,R30
; 0000 037F 
; 0000 0380 if(PORT_CZYTNIK.byte == 0x01)
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1)
	BRNE _0x1D
; 0000 0381     {
; 0000 0382     macierz_zaciskow[rzad]=1;
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
; 0000 0383     komunikat_z_czytnika_kodow("86-0170",rzad,1);
	__POINTW1FN _0x0,178
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0384     srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 0385     }
; 0000 0386 
; 0000 0387 if(PORT_CZYTNIK.byte == 0x02)
_0x1D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2)
	BRNE _0x1E
; 0000 0388     {
; 0000 0389     macierz_zaciskow[rzad]=2;
	CALL SUBOPT_0x32
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
; 0000 038A     komunikat_z_czytnika_kodow("86-1043",rzad,0);
	__POINTW1FN _0x0,186
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 038B     srednica_wew_korpusu = 34;
; 0000 038C     }
; 0000 038D 
; 0000 038E if(PORT_CZYTNIK.byte == 0x03)
_0x1E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3)
	BRNE _0x1F
; 0000 038F     {
; 0000 0390       macierz_zaciskow[rzad]=3;
	CALL SUBOPT_0x32
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   X+,R30
	ST   X,R31
; 0000 0391       komunikat_z_czytnika_kodow("86-1675",rzad,0);
	__POINTW1FN _0x0,194
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 0392       srednica_wew_korpusu =38;
; 0000 0393     }
; 0000 0394 
; 0000 0395 if(PORT_CZYTNIK.byte == 0x04)
_0x1F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4)
	BRNE _0x20
; 0000 0396     {
; 0000 0397 
; 0000 0398       macierz_zaciskow[rzad]=4;
	CALL SUBOPT_0x32
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   X+,R30
	ST   X,R31
; 0000 0399       komunikat_z_czytnika_kodow("86-2098",rzad,0);
	__POINTW1FN _0x0,202
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 039A       srednica_wew_korpusu = 38;
; 0000 039B     }
; 0000 039C if(PORT_CZYTNIK.byte == 0x05)
_0x20:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5)
	BRNE _0x21
; 0000 039D     {
; 0000 039E       macierz_zaciskow[rzad]=5;
	CALL SUBOPT_0x32
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   X+,R30
	ST   X,R31
; 0000 039F       komunikat_z_czytnika_kodow("87-0170",rzad,0);
	__POINTW1FN _0x0,210
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 03A0       srednica_wew_korpusu = 38;
; 0000 03A1     }
; 0000 03A2 if(PORT_CZYTNIK.byte == 0x06)
_0x21:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6)
	BRNE _0x22
; 0000 03A3     {
; 0000 03A4       macierz_zaciskow[rzad]=6;
	CALL SUBOPT_0x32
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   X+,R30
	ST   X,R31
; 0000 03A5       komunikat_z_czytnika_kodow("87-1043",rzad,1);
	__POINTW1FN _0x0,218
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 03A6       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 03A7     }
; 0000 03A8 
; 0000 03A9 if(PORT_CZYTNIK.byte == 0x07)
_0x22:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7)
	BRNE _0x23
; 0000 03AA     {
; 0000 03AB       macierz_zaciskow[rzad]=7;
	CALL SUBOPT_0x32
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   X+,R30
	ST   X,R31
; 0000 03AC       komunikat_z_czytnika_kodow("87-1675",rzad,1);
	__POINTW1FN _0x0,226
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 03AD       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 03AE     }
; 0000 03AF 
; 0000 03B0 if(PORT_CZYTNIK.byte == 0x08)
_0x23:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8)
	BRNE _0x24
; 0000 03B1     {
; 0000 03B2       macierz_zaciskow[rzad]=8;
	CALL SUBOPT_0x32
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   X+,R30
	ST   X,R31
; 0000 03B3       komunikat_z_czytnika_kodow("87-2098",rzad,1);
	__POINTW1FN _0x0,234
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 03B4       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 03B5     }
; 0000 03B6 if(PORT_CZYTNIK.byte == 0x09)
_0x24:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x9)
	BRNE _0x25
; 0000 03B7     {
; 0000 03B8       macierz_zaciskow[rzad]=9;
	CALL SUBOPT_0x32
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   X+,R30
	ST   X,R31
; 0000 03B9       komunikat_z_czytnika_kodow("86-0192",rzad,0);
	__POINTW1FN _0x0,242
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 03BA       srednica_wew_korpusu = 38;
; 0000 03BB     }
; 0000 03BC if(PORT_CZYTNIK.byte == 0x0A)
_0x25:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xA)
	BRNE _0x26
; 0000 03BD     {
; 0000 03BE       macierz_zaciskow[rzad]=10;
	CALL SUBOPT_0x32
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   X+,R30
	ST   X,R31
; 0000 03BF       komunikat_z_czytnika_kodow("86-1054",rzad,0);
	__POINTW1FN _0x0,250
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 03C0       srednica_wew_korpusu = 41;
; 0000 03C1     }
; 0000 03C2 if(PORT_CZYTNIK.byte == 0x0B)
_0x26:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xB)
	BRNE _0x27
; 0000 03C3     {
; 0000 03C4       macierz_zaciskow[rzad]=11;
	CALL SUBOPT_0x32
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   X+,R30
	ST   X,R31
; 0000 03C5       komunikat_z_czytnika_kodow("86-1676",rzad,0);
	__POINTW1FN _0x0,258
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 03C6       srednica_wew_korpusu = 41;
; 0000 03C7     }
; 0000 03C8 if(PORT_CZYTNIK.byte == 0x0C)
_0x27:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xC)
	BRNE _0x28
; 0000 03C9     {
; 0000 03CA       macierz_zaciskow[rzad]=12;
	CALL SUBOPT_0x32
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   X+,R30
	ST   X,R31
; 0000 03CB       komunikat_z_czytnika_kodow("86-2132",rzad,1);
	__POINTW1FN _0x0,266
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 03CC       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 03CD     }
; 0000 03CE if(PORT_CZYTNIK.byte == 0x0D)
_0x28:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xD)
	BRNE _0x29
; 0000 03CF     {
; 0000 03D0       macierz_zaciskow[rzad]=13;
	CALL SUBOPT_0x32
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   X+,R30
	ST   X,R31
; 0000 03D1       komunikat_z_czytnika_kodow("87-0192",rzad,1);
	__POINTW1FN _0x0,274
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 03D2       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 03D3     }
; 0000 03D4 if(PORT_CZYTNIK.byte == 0x0E)
_0x29:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xE)
	BRNE _0x2A
; 0000 03D5     {
; 0000 03D6       macierz_zaciskow[rzad]=14;
	CALL SUBOPT_0x32
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   X+,R30
	ST   X,R31
; 0000 03D7       komunikat_z_czytnika_kodow("87-1054",rzad,1);
	__POINTW1FN _0x0,282
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 03D8       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 03D9     }
; 0000 03DA 
; 0000 03DB if(PORT_CZYTNIK.byte == 0x0F)
_0x2A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xF)
	BRNE _0x2B
; 0000 03DC     {
; 0000 03DD       macierz_zaciskow[rzad]=15;
	CALL SUBOPT_0x32
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   X+,R30
	ST   X,R31
; 0000 03DE       komunikat_z_czytnika_kodow("87-1676",rzad,1);
	__POINTW1FN _0x0,290
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 03DF       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 03E0     }
; 0000 03E1 if(PORT_CZYTNIK.byte == 0x10)
_0x2B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x10)
	BRNE _0x2C
; 0000 03E2     {
; 0000 03E3       macierz_zaciskow[rzad]=16;
	CALL SUBOPT_0x32
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   X+,R30
	ST   X,R31
; 0000 03E4       komunikat_z_czytnika_kodow("87-2132",rzad,0);
	__POINTW1FN _0x0,298
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 03E5       srednica_wew_korpusu = 41;
; 0000 03E6     }
; 0000 03E7 
; 0000 03E8 if(PORT_CZYTNIK.byte == 0x11)
_0x2C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x11)
	BRNE _0x2D
; 0000 03E9     {
; 0000 03EA       macierz_zaciskow[rzad]=17;
	CALL SUBOPT_0x32
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   X+,R30
	ST   X,R31
; 0000 03EB       komunikat_z_czytnika_kodow("86-0193",rzad,0);
	__POINTW1FN _0x0,306
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 03EC       srednica_wew_korpusu = 38;
; 0000 03ED     }
; 0000 03EE 
; 0000 03EF if(PORT_CZYTNIK.byte == 0x12)
_0x2D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x12)
	BRNE _0x2E
; 0000 03F0     {
; 0000 03F1       macierz_zaciskow[rzad]=18;
	CALL SUBOPT_0x32
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	ST   X+,R30
	ST   X,R31
; 0000 03F2       komunikat_z_czytnika_kodow("86-1216",rzad,0);
	__POINTW1FN _0x0,314
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 03F3       srednica_wew_korpusu = 34;
; 0000 03F4     }
; 0000 03F5 if(PORT_CZYTNIK.byte == 0x13)
_0x2E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x13)
	BRNE _0x2F
; 0000 03F6     {
; 0000 03F7       macierz_zaciskow[rzad]=19;
	CALL SUBOPT_0x32
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	ST   X+,R30
	ST   X,R31
; 0000 03F8       komunikat_z_czytnika_kodow("86-1832",rzad,0);
	__POINTW1FN _0x0,322
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 03F9       srednica_wew_korpusu = 41;
; 0000 03FA     }
; 0000 03FB 
; 0000 03FC if(PORT_CZYTNIK.byte == 0x14)
_0x2F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x14)
	BRNE _0x30
; 0000 03FD     {
; 0000 03FE       macierz_zaciskow[rzad]=20;
	CALL SUBOPT_0x32
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   X+,R30
	ST   X,R31
; 0000 03FF       komunikat_z_czytnika_kodow("86-2174",rzad,0);
	__POINTW1FN _0x0,330
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 0400       srednica_wew_korpusu = 34;
; 0000 0401     }
; 0000 0402 if(PORT_CZYTNIK.byte == 0x15)
_0x30:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x15)
	BRNE _0x31
; 0000 0403     {
; 0000 0404       macierz_zaciskow[rzad]=21;
	CALL SUBOPT_0x32
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	ST   X+,R30
	ST   X,R31
; 0000 0405       komunikat_z_czytnika_kodow("87-0193",rzad,1);
	__POINTW1FN _0x0,338
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0406       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 0407     }
; 0000 0408 
; 0000 0409 if(PORT_CZYTNIK.byte == 0x16)
_0x31:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x16)
	BRNE _0x32
; 0000 040A     {
; 0000 040B       macierz_zaciskow[rzad]=22;
	CALL SUBOPT_0x32
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	ST   X+,R30
	ST   X,R31
; 0000 040C       komunikat_z_czytnika_kodow("87-1216",rzad,1);
	__POINTW1FN _0x0,346
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 040D       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 040E     }
; 0000 040F if(PORT_CZYTNIK.byte == 0x17)
_0x32:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x17)
	BRNE _0x33
; 0000 0410     {
; 0000 0411       macierz_zaciskow[rzad]=23;
	CALL SUBOPT_0x32
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	ST   X+,R30
	ST   X,R31
; 0000 0412       komunikat_z_czytnika_kodow("87-1832",rzad,1);
	__POINTW1FN _0x0,354
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0413       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 0414     }
; 0000 0415 
; 0000 0416 if(PORT_CZYTNIK.byte == 0x18)
_0x33:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x18)
	BRNE _0x34
; 0000 0417     {
; 0000 0418       macierz_zaciskow[rzad]=24;
	CALL SUBOPT_0x32
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	ST   X+,R30
	ST   X,R31
; 0000 0419       komunikat_z_czytnika_kodow("87-2174",rzad,1);
	__POINTW1FN _0x0,362
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 041A       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 041B     }
; 0000 041C if(PORT_CZYTNIK.byte == 0x19)
_0x34:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x19)
	BRNE _0x35
; 0000 041D     {
; 0000 041E       macierz_zaciskow[rzad]=25;
	CALL SUBOPT_0x32
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	ST   X+,R30
	ST   X,R31
; 0000 041F       komunikat_z_czytnika_kodow("86-0194",rzad,0);
	__POINTW1FN _0x0,370
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 0420       srednica_wew_korpusu = 41;
; 0000 0421     }
; 0000 0422 
; 0000 0423 if(PORT_CZYTNIK.byte == 0x1A)
_0x35:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1A)
	BRNE _0x36
; 0000 0424     {
; 0000 0425       macierz_zaciskow[rzad]=26;
	CALL SUBOPT_0x32
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	ST   X+,R30
	ST   X,R31
; 0000 0426       komunikat_z_czytnika_kodow("86-1341",rzad,0);
	__POINTW1FN _0x0,378
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 0427       srednica_wew_korpusu = 34;
; 0000 0428     }
; 0000 0429 if(PORT_CZYTNIK.byte == 0x1B)
_0x36:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1B)
	BRNE _0x37
; 0000 042A     {
; 0000 042B       macierz_zaciskow[rzad]=27;
	CALL SUBOPT_0x32
	LDI  R30,LOW(27)
	LDI  R31,HIGH(27)
	ST   X+,R30
	ST   X,R31
; 0000 042C       komunikat_z_czytnika_kodow("86-1833",rzad,0);
	__POINTW1FN _0x0,386
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 042D       srednica_wew_korpusu = 41;
; 0000 042E     }
; 0000 042F if(PORT_CZYTNIK.byte == 0x1C)
_0x37:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1C)
	BRNE _0x38
; 0000 0430     {
; 0000 0431       macierz_zaciskow[rzad]=28;
	CALL SUBOPT_0x32
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	ST   X+,R30
	ST   X,R31
; 0000 0432       komunikat_z_czytnika_kodow("86-2180",rzad,1);
	__POINTW1FN _0x0,394
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0433       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 0434     }
; 0000 0435 if(PORT_CZYTNIK.byte == 0x1D)
_0x38:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1D)
	BRNE _0x39
; 0000 0436     {
; 0000 0437       macierz_zaciskow[rzad]=29;
	CALL SUBOPT_0x32
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	ST   X+,R30
	ST   X,R31
; 0000 0438       komunikat_z_czytnika_kodow("87-0194",rzad,1);
	__POINTW1FN _0x0,402
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0439       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 043A     }
; 0000 043B 
; 0000 043C if(PORT_CZYTNIK.byte == 0x1E)
_0x39:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1E)
	BRNE _0x3A
; 0000 043D     {
; 0000 043E       macierz_zaciskow[rzad]=30;
	CALL SUBOPT_0x32
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   X+,R30
	ST   X,R31
; 0000 043F       komunikat_z_czytnika_kodow("87-1341",rzad,1);
	__POINTW1FN _0x0,410
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0440       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 0441     }
; 0000 0442 if(PORT_CZYTNIK.byte == 0x1F)
_0x3A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1F)
	BRNE _0x3B
; 0000 0443     {
; 0000 0444       macierz_zaciskow[rzad]=31;
	CALL SUBOPT_0x32
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	ST   X+,R30
	ST   X,R31
; 0000 0445       komunikat_z_czytnika_kodow("87-1833",rzad,1);
	__POINTW1FN _0x0,418
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0446       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 0447     }
; 0000 0448 
; 0000 0449 if(PORT_CZYTNIK.byte == 0x20)
_0x3B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x20)
	BRNE _0x3C
; 0000 044A     {
; 0000 044B       macierz_zaciskow[rzad]=32;
	CALL SUBOPT_0x32
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   X+,R30
	ST   X,R31
; 0000 044C       komunikat_z_czytnika_kodow("87-2180",rzad,0);
	__POINTW1FN _0x0,426
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 044D       srednica_wew_korpusu = 41;
; 0000 044E     }
; 0000 044F if(PORT_CZYTNIK.byte == 0x21)
_0x3C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x21)
	BRNE _0x3D
; 0000 0450     {
; 0000 0451       macierz_zaciskow[rzad]=33;
	CALL SUBOPT_0x32
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	ST   X+,R30
	ST   X,R31
; 0000 0452       komunikat_z_czytnika_kodow("86-0663",rzad,1);
	__POINTW1FN _0x0,434
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0453       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x3C
; 0000 0454     }
; 0000 0455 
; 0000 0456 if(PORT_CZYTNIK.byte == 0x22)
_0x3D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x22)
	BRNE _0x3E
; 0000 0457     {
; 0000 0458       macierz_zaciskow[rzad]=34;
	CALL SUBOPT_0x32
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	ST   X+,R30
	ST   X,R31
; 0000 0459       komunikat_z_czytnika_kodow("86-1349",rzad,0);
	__POINTW1FN _0x0,442
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 045A       srednica_wew_korpusu = 38;
; 0000 045B     }
; 0000 045C if(PORT_CZYTNIK.byte == 0x23)
_0x3E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x23)
	BRNE _0x3F
; 0000 045D     {
; 0000 045E       macierz_zaciskow[rzad]=35;
	CALL SUBOPT_0x32
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	ST   X+,R30
	ST   X,R31
; 0000 045F       komunikat_z_czytnika_kodow("86-1834",rzad,0);
	__POINTW1FN _0x0,450
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 0460       srednica_wew_korpusu = 34;
; 0000 0461     }
; 0000 0462 if(PORT_CZYTNIK.byte == 0x24)
_0x3F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x24)
	BRNE _0x40
; 0000 0463     {
; 0000 0464       macierz_zaciskow[rzad]=36;
	CALL SUBOPT_0x32
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	ST   X+,R30
	ST   X,R31
; 0000 0465       komunikat_z_czytnika_kodow("86-2204",rzad,0);
	__POINTW1FN _0x0,458
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 0466       srednica_wew_korpusu = 38;
; 0000 0467     }
; 0000 0468 if(PORT_CZYTNIK.byte == 0x25)
_0x40:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x25)
	BRNE _0x41
; 0000 0469     {
; 0000 046A       macierz_zaciskow[rzad]=37;
	CALL SUBOPT_0x32
	LDI  R30,LOW(37)
	LDI  R31,HIGH(37)
	ST   X+,R30
	ST   X,R31
; 0000 046B       komunikat_z_czytnika_kodow("87-0663",rzad,0);
	__POINTW1FN _0x0,466
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3D
; 0000 046C       srednica_wew_korpusu = 43;
; 0000 046D     }
; 0000 046E if(PORT_CZYTNIK.byte == 0x26)
_0x41:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x26)
	BRNE _0x42
; 0000 046F     {
; 0000 0470       macierz_zaciskow[rzad]=38;
	CALL SUBOPT_0x32
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	ST   X+,R30
	ST   X,R31
; 0000 0471       komunikat_z_czytnika_kodow("87-1349",rzad,1);
	__POINTW1FN _0x0,474
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0472       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 0473     }
; 0000 0474 if(PORT_CZYTNIK.byte == 0x27)
_0x42:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x27)
	BRNE _0x43
; 0000 0475     {
; 0000 0476       macierz_zaciskow[rzad]=39;
	CALL SUBOPT_0x32
	LDI  R30,LOW(39)
	LDI  R31,HIGH(39)
	ST   X+,R30
	ST   X,R31
; 0000 0477       komunikat_z_czytnika_kodow("87-1834",rzad,1);
	__POINTW1FN _0x0,482
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0478       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 0479     }
; 0000 047A if(PORT_CZYTNIK.byte == 0x28)
_0x43:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x28)
	BRNE _0x44
; 0000 047B     {
; 0000 047C       macierz_zaciskow[rzad]=40;
	CALL SUBOPT_0x32
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   X+,R30
	ST   X,R31
; 0000 047D       komunikat_z_czytnika_kodow("87-2204",rzad,1);
	__POINTW1FN _0x0,490
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 047E       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 047F     }
; 0000 0480 if(PORT_CZYTNIK.byte == 0x29)
_0x44:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x29)
	BRNE _0x45
; 0000 0481     {
; 0000 0482       macierz_zaciskow[rzad]=41;
	CALL SUBOPT_0x32
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	ST   X+,R30
	ST   X,R31
; 0000 0483       komunikat_z_czytnika_kodow("86-0768",rzad,1);
	__POINTW1FN _0x0,498
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0484       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 0485     }
; 0000 0486 if(PORT_CZYTNIK.byte == 0x2A)
_0x45:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2A)
	BRNE _0x46
; 0000 0487     {
; 0000 0488       macierz_zaciskow[rzad]=42;
	CALL SUBOPT_0x32
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   X+,R30
	ST   X,R31
; 0000 0489       komunikat_z_czytnika_kodow("86-1357",rzad,0);
	__POINTW1FN _0x0,506
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 048A       srednica_wew_korpusu = 38;
; 0000 048B     }
; 0000 048C if(PORT_CZYTNIK.byte == 0x2B)
_0x46:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2B)
	BRNE _0x47
; 0000 048D     {
; 0000 048E       macierz_zaciskow[rzad]=43;
	CALL SUBOPT_0x32
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	ST   X+,R30
	ST   X,R31
; 0000 048F       komunikat_z_czytnika_kodow("86-1848",rzad,0);
	__POINTW1FN _0x0,514
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 0490       srednica_wew_korpusu = 38;
; 0000 0491     }
; 0000 0492 if(PORT_CZYTNIK.byte == 0x2C)
_0x47:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2C)
	BRNE _0x48
; 0000 0493     {
; 0000 0494      macierz_zaciskow[rzad]=44;
	CALL SUBOPT_0x32
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x3E
; 0000 0495       macierz_zaciskow[rzad]=0;   ////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x3F
; 0000 0496 
; 0000 0497      komunikat_z_czytnika_kodow("86-2212",rzad,0);
	__POINTW1FN _0x0,522
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 0498      srednica_wew_korpusu = 38;
; 0000 0499     }
; 0000 049A if(PORT_CZYTNIK.byte == 0x2D)
_0x48:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2D)
	BRNE _0x49
; 0000 049B     {
; 0000 049C       macierz_zaciskow[rzad]=45;
	CALL SUBOPT_0x32
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	ST   X+,R30
	ST   X,R31
; 0000 049D       komunikat_z_czytnika_kodow("87-0768",rzad,0);
	__POINTW1FN _0x0,530
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 049E       srednica_wew_korpusu = 38;
; 0000 049F     }
; 0000 04A0 if(PORT_CZYTNIK.byte == 0x2E)
_0x49:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2E)
	BRNE _0x4A
; 0000 04A1     {
; 0000 04A2       macierz_zaciskow[rzad]=46;
	CALL SUBOPT_0x32
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	ST   X+,R30
	ST   X,R31
; 0000 04A3       komunikat_z_czytnika_kodow("87-1357",rzad,1);
	__POINTW1FN _0x0,538
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 04A4       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 04A5     }
; 0000 04A6 if(PORT_CZYTNIK.byte == 0x2F)
_0x4A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2F)
	BRNE _0x4B
; 0000 04A7     {
; 0000 04A8       macierz_zaciskow[rzad]=47;
	CALL SUBOPT_0x32
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	ST   X+,R30
	ST   X,R31
; 0000 04A9       komunikat_z_czytnika_kodow("87-1848",rzad,1);
	__POINTW1FN _0x0,546
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 04AA       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 04AB     }
; 0000 04AC if(PORT_CZYTNIK.byte == 0x30)
_0x4B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x30)
	BRNE _0x4C
; 0000 04AD     {
; 0000 04AE       macierz_zaciskow[rzad]=48;
	CALL SUBOPT_0x32
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x3E
; 0000 04AF       macierz_zaciskow[rzad]=0;    /////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x3F
; 0000 04B0       komunikat_z_czytnika_kodow("87-2212",rzad,1);
	__POINTW1FN _0x0,554
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 04B1       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 04B2     }
; 0000 04B3 if(PORT_CZYTNIK.byte == 0x31)
_0x4C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x31)
	BRNE _0x4D
; 0000 04B4     {
; 0000 04B5       macierz_zaciskow[rzad]=49;
	CALL SUBOPT_0x32
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	ST   X+,R30
	ST   X,R31
; 0000 04B6       komunikat_z_czytnika_kodow("86-0800",rzad,0);
	__POINTW1FN _0x0,562
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 04B7       srednica_wew_korpusu = 38;
; 0000 04B8     }
; 0000 04B9 if(PORT_CZYTNIK.byte == 0x32)
_0x4D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x32)
	BRNE _0x4E
; 0000 04BA     {
; 0000 04BB       macierz_zaciskow[rzad]=50;
	CALL SUBOPT_0x32
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   X+,R30
	ST   X,R31
; 0000 04BC       komunikat_z_czytnika_kodow("86-1363",rzad,0);
	__POINTW1FN _0x0,570
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 04BD       srednica_wew_korpusu = 34;
; 0000 04BE     }
; 0000 04BF if(PORT_CZYTNIK.byte == 0x33)
_0x4E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x33)
	BRNE _0x4F
; 0000 04C0     {
; 0000 04C1       macierz_zaciskow[rzad]=51;
	CALL SUBOPT_0x32
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	ST   X+,R30
	ST   X,R31
; 0000 04C2       komunikat_z_czytnika_kodow("86-1904",rzad,0);
	__POINTW1FN _0x0,578
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3D
; 0000 04C3       srednica_wew_korpusu = 43;
; 0000 04C4     }
; 0000 04C5 if(PORT_CZYTNIK.byte == 0x34)
_0x4F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x34)
	BRNE _0x50
; 0000 04C6     {
; 0000 04C7       macierz_zaciskow[rzad]=52;
	CALL SUBOPT_0x32
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	ST   X+,R30
	ST   X,R31
; 0000 04C8       komunikat_z_czytnika_kodow("86-2241",rzad,1);
	__POINTW1FN _0x0,586
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 04C9       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 04CA     }
; 0000 04CB if(PORT_CZYTNIK.byte == 0x35)
_0x50:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x35)
	BRNE _0x51
; 0000 04CC     {
; 0000 04CD       macierz_zaciskow[rzad]=53;
	CALL SUBOPT_0x32
	LDI  R30,LOW(53)
	LDI  R31,HIGH(53)
	ST   X+,R30
	ST   X,R31
; 0000 04CE       komunikat_z_czytnika_kodow("87-0800",rzad,1);
	__POINTW1FN _0x0,594
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 04CF       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 04D0     }
; 0000 04D1 
; 0000 04D2 if(PORT_CZYTNIK.byte == 0x36)
_0x51:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x36)
	BRNE _0x52
; 0000 04D3     {
; 0000 04D4       macierz_zaciskow[rzad]=54;
	CALL SUBOPT_0x32
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	ST   X+,R30
	ST   X,R31
; 0000 04D5       komunikat_z_czytnika_kodow("87-1363",rzad,1);
	__POINTW1FN _0x0,602
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 04D6       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 04D7     }
; 0000 04D8 if(PORT_CZYTNIK.byte == 0x37)
_0x52:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x37)
	BRNE _0x53
; 0000 04D9     {
; 0000 04DA       macierz_zaciskow[rzad]=55;
	CALL SUBOPT_0x32
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	ST   X+,R30
	ST   X,R31
; 0000 04DB       komunikat_z_czytnika_kodow("87-1904",rzad,1);
	__POINTW1FN _0x0,610
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 04DC       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x3C
; 0000 04DD     }
; 0000 04DE if(PORT_CZYTNIK.byte == 0x38)
_0x53:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x38)
	BRNE _0x54
; 0000 04DF     {
; 0000 04E0       macierz_zaciskow[rzad]=56;
	CALL SUBOPT_0x32
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	ST   X+,R30
	ST   X,R31
; 0000 04E1       komunikat_z_czytnika_kodow("87-2241",rzad,0);
	__POINTW1FN _0x0,618
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 04E2       srednica_wew_korpusu = 34;
; 0000 04E3     }
; 0000 04E4 if(PORT_CZYTNIK.byte == 0x39)
_0x54:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x39)
	BRNE _0x55
; 0000 04E5     {
; 0000 04E6       macierz_zaciskow[rzad]=57;
	CALL SUBOPT_0x32
	LDI  R30,LOW(57)
	LDI  R31,HIGH(57)
	ST   X+,R30
	ST   X,R31
; 0000 04E7       komunikat_z_czytnika_kodow("86-0811",rzad,0);
	__POINTW1FN _0x0,626
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 04E8       srednica_wew_korpusu = 34;
; 0000 04E9     }
; 0000 04EA if(PORT_CZYTNIK.byte == 0x3A)
_0x55:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3A)
	BRNE _0x56
; 0000 04EB     {
; 0000 04EC       macierz_zaciskow[rzad]=58;
	CALL SUBOPT_0x32
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	ST   X+,R30
	ST   X,R31
; 0000 04ED       komunikat_z_czytnika_kodow("86-1523",rzad,0);
	__POINTW1FN _0x0,634
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 04EE       srednica_wew_korpusu = 38;
; 0000 04EF     }
; 0000 04F0 if(PORT_CZYTNIK.byte == 0x3B)
_0x56:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3B)
	BRNE _0x57
; 0000 04F1     {
; 0000 04F2       macierz_zaciskow[rzad]=59;
	CALL SUBOPT_0x32
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	ST   X+,R30
	ST   X,R31
; 0000 04F3       komunikat_z_czytnika_kodow("86-1929",rzad,0);
	__POINTW1FN _0x0,642
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 04F4       srednica_wew_korpusu = 41;
; 0000 04F5     }
; 0000 04F6 if(PORT_CZYTNIK.byte == 0x3C)
_0x57:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3C)
	BRNE _0x58
; 0000 04F7     {
; 0000 04F8       macierz_zaciskow[rzad]=60;
	CALL SUBOPT_0x32
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	ST   X+,R30
	ST   X,R31
; 0000 04F9       komunikat_z_czytnika_kodow("86-2261",rzad,0);
	__POINTW1FN _0x0,650
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 04FA       srednica_wew_korpusu = 34;
; 0000 04FB     }
; 0000 04FC if(PORT_CZYTNIK.byte == 0x3D)
_0x58:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3D)
	BRNE _0x59
; 0000 04FD     {
; 0000 04FE       macierz_zaciskow[rzad]=61;
	CALL SUBOPT_0x32
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	ST   X+,R30
	ST   X,R31
; 0000 04FF       komunikat_z_czytnika_kodow("87-0811",rzad,1);
	__POINTW1FN _0x0,658
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0500       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 0501     }
; 0000 0502 if(PORT_CZYTNIK.byte == 0x3E)
_0x59:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3E)
	BRNE _0x5A
; 0000 0503     {
; 0000 0504       macierz_zaciskow[rzad]=62;
	CALL SUBOPT_0x32
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	ST   X+,R30
	ST   X,R31
; 0000 0505       komunikat_z_czytnika_kodow("87-1523",rzad,1);
	__POINTW1FN _0x0,666
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0506       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 0507     }
; 0000 0508 if(PORT_CZYTNIK.byte == 0x3F)
_0x5A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3F)
	BRNE _0x5B
; 0000 0509     {
; 0000 050A       macierz_zaciskow[rzad]=63;
	CALL SUBOPT_0x32
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	ST   X+,R30
	ST   X,R31
; 0000 050B       komunikat_z_czytnika_kodow("87-1929",rzad,1);
	__POINTW1FN _0x0,674
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 050C       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 050D     }
; 0000 050E if(PORT_CZYTNIK.byte == 0x40)
_0x5B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x40)
	BRNE _0x5C
; 0000 050F     {
; 0000 0510       macierz_zaciskow[rzad]=64;
	CALL SUBOPT_0x32
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   X+,R30
	ST   X,R31
; 0000 0511       komunikat_z_czytnika_kodow("87-2261",rzad,1);
	__POINTW1FN _0x0,682
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0512       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 0513     }
; 0000 0514 if(PORT_CZYTNIK.byte == 0x41)
_0x5C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x41)
	BRNE _0x5D
; 0000 0515     {
; 0000 0516       macierz_zaciskow[rzad]=65;
	CALL SUBOPT_0x32
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   X+,R30
	ST   X,R31
; 0000 0517       komunikat_z_czytnika_kodow("86-0814",rzad,0);
	__POINTW1FN _0x0,690
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x40
; 0000 0518       srednica_wew_korpusu = 36;
; 0000 0519     }
; 0000 051A if(PORT_CZYTNIK.byte == 0x42)
_0x5D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x42)
	BRNE _0x5E
; 0000 051B     {
; 0000 051C       macierz_zaciskow[rzad]=66;
	CALL SUBOPT_0x32
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	ST   X+,R30
	ST   X,R31
; 0000 051D       komunikat_z_czytnika_kodow("86-1530",rzad,1);
	__POINTW1FN _0x0,698
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 051E       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 051F     }
; 0000 0520 if(PORT_CZYTNIK.byte == 0x43)
_0x5E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x43)
	BRNE _0x5F
; 0000 0521     {
; 0000 0522       macierz_zaciskow[rzad]=67;
	CALL SUBOPT_0x32
	LDI  R30,LOW(67)
	LDI  R31,HIGH(67)
	ST   X+,R30
	ST   X,R31
; 0000 0523       komunikat_z_czytnika_kodow("86-1936",rzad,1);
	__POINTW1FN _0x0,706
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0524       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 0525     }
; 0000 0526 if(PORT_CZYTNIK.byte == 0x44)
_0x5F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x44)
	BRNE _0x60
; 0000 0527     {
; 0000 0528       macierz_zaciskow[rzad]=68;
	CALL SUBOPT_0x32
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   X+,R30
	ST   X,R31
; 0000 0529       komunikat_z_czytnika_kodow("86-2285",rzad,1);
	__POINTW1FN _0x0,714
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 052A       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 052B     }
; 0000 052C if(PORT_CZYTNIK.byte == 0x45)
_0x60:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x45)
	BRNE _0x61
; 0000 052D     {
; 0000 052E       macierz_zaciskow[rzad]=69;
	CALL SUBOPT_0x32
	LDI  R30,LOW(69)
	LDI  R31,HIGH(69)
	ST   X+,R30
	ST   X,R31
; 0000 052F       komunikat_z_czytnika_kodow("87-0814",rzad,1);
	__POINTW1FN _0x0,722
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0530       srednica_wew_korpusu = 36;
	CALL SUBOPT_0x41
; 0000 0531     }
; 0000 0532 if(PORT_CZYTNIK.byte == 0x46)
_0x61:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x46)
	BRNE _0x62
; 0000 0533     {
; 0000 0534       macierz_zaciskow[rzad]=70;
	CALL SUBOPT_0x32
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   X+,R30
	ST   X,R31
; 0000 0535       komunikat_z_czytnika_kodow("87-1530",rzad,0);
	__POINTW1FN _0x0,730
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 0536       srednica_wew_korpusu = 38;
; 0000 0537     }
; 0000 0538 if(PORT_CZYTNIK.byte == 0x47)
_0x62:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x47)
	BRNE _0x63
; 0000 0539     {
; 0000 053A       macierz_zaciskow[rzad]=71;
	CALL SUBOPT_0x32
	LDI  R30,LOW(71)
	LDI  R31,HIGH(71)
	ST   X+,R30
	ST   X,R31
; 0000 053B       komunikat_z_czytnika_kodow("87-1936",rzad,0);
	__POINTW1FN _0x0,738
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 053C       srednica_wew_korpusu = 38;
; 0000 053D     }
; 0000 053E if(PORT_CZYTNIK.byte == 0x48)
_0x63:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x48)
	BRNE _0x64
; 0000 053F     {
; 0000 0540       macierz_zaciskow[rzad]=72;
	CALL SUBOPT_0x32
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	ST   X+,R30
	ST   X,R31
; 0000 0541       komunikat_z_czytnika_kodow("87-2285",rzad,0);
	__POINTW1FN _0x0,746
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 0542       srednica_wew_korpusu = 41;
; 0000 0543     }
; 0000 0544 if(PORT_CZYTNIK.byte == 0x49)
_0x64:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x49)
	BRNE _0x65
; 0000 0545     {
; 0000 0546       macierz_zaciskow[rzad]=73;
	CALL SUBOPT_0x32
	LDI  R30,LOW(73)
	LDI  R31,HIGH(73)
	ST   X+,R30
	ST   X,R31
; 0000 0547       komunikat_z_czytnika_kodow("86-0815",rzad,0);
	__POINTW1FN _0x0,754
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 0548       srednica_wew_korpusu = 38;
; 0000 0549     }
; 0000 054A 
; 0000 054B if(PORT_CZYTNIK.byte == 0x4A)
_0x65:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4A)
	BRNE _0x66
; 0000 054C     {
; 0000 054D       macierz_zaciskow[rzad]=74;
	CALL SUBOPT_0x32
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	ST   X+,R30
	ST   X,R31
; 0000 054E       komunikat_z_czytnika_kodow("86-1551",rzad,0);
	__POINTW1FN _0x0,762
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 054F       srednica_wew_korpusu = 38;
; 0000 0550     }
; 0000 0551 if(PORT_CZYTNIK.byte == 0x4B)
_0x66:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4B)
	BRNE _0x67
; 0000 0552     {
; 0000 0553       macierz_zaciskow[rzad]=75;
	CALL SUBOPT_0x32
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	ST   X+,R30
	ST   X,R31
; 0000 0554       komunikat_z_czytnika_kodow("86-1941",rzad,0);
	__POINTW1FN _0x0,770
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 0555       srednica_wew_korpusu = 38;
; 0000 0556     }
; 0000 0557 if(PORT_CZYTNIK.byte == 0x4C)
_0x67:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4C)
	BRNE _0x68
; 0000 0558     {
; 0000 0559       macierz_zaciskow[rzad]=76;
	CALL SUBOPT_0x32
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x3E
; 0000 055A       macierz_zaciskow[rzad]=0;    ////////////////////////////////brak zacisku
	CALL SUBOPT_0x3F
; 0000 055B       komunikat_z_czytnika_kodow("86-2286",rzad,0);
	__POINTW1FN _0x0,778
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 055C       srednica_wew_korpusu = 41;
; 0000 055D     }
; 0000 055E if(PORT_CZYTNIK.byte == 0x4D)
_0x68:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4D)
	BRNE _0x69
; 0000 055F     {
; 0000 0560       macierz_zaciskow[rzad]=77;
	CALL SUBOPT_0x32
	LDI  R30,LOW(77)
	LDI  R31,HIGH(77)
	ST   X+,R30
	ST   X,R31
; 0000 0561       komunikat_z_czytnika_kodow("87-0815",rzad,1);
	__POINTW1FN _0x0,786
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0562       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 0563     }
; 0000 0564 if(PORT_CZYTNIK.byte == 0x4E)
_0x69:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4E)
	BRNE _0x6A
; 0000 0565     {
; 0000 0566       macierz_zaciskow[rzad]=78;
	CALL SUBOPT_0x32
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	ST   X+,R30
	ST   X,R31
; 0000 0567       komunikat_z_czytnika_kodow("87-1551",rzad,1);
	__POINTW1FN _0x0,794
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0568       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 0569     }
; 0000 056A if(PORT_CZYTNIK.byte == 0x4F)
_0x6A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4F)
	BRNE _0x6B
; 0000 056B     {
; 0000 056C       macierz_zaciskow[rzad]=79;
	CALL SUBOPT_0x32
	LDI  R30,LOW(79)
	LDI  R31,HIGH(79)
	ST   X+,R30
	ST   X,R31
; 0000 056D       komunikat_z_czytnika_kodow("87-1941",rzad,1);
	__POINTW1FN _0x0,802
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 056E       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 056F     }
; 0000 0570 if(PORT_CZYTNIK.byte == 0x50)
_0x6B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x50)
	BRNE _0x6C
; 0000 0571     {
; 0000 0572       macierz_zaciskow[rzad]=80;
	CALL SUBOPT_0x32
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x3E
; 0000 0573       macierz_zaciskow[rzad]=0;  ////////////////////////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x3F
; 0000 0574       komunikat_z_czytnika_kodow("87-2286",rzad,0);
	__POINTW1FN _0x0,810
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 0575       srednica_wew_korpusu = 41;
; 0000 0576     }
; 0000 0577 if(PORT_CZYTNIK.byte == 0x51)
_0x6C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x51)
	BRNE _0x6D
; 0000 0578     {
; 0000 0579       macierz_zaciskow[rzad]=81;
	CALL SUBOPT_0x32
	LDI  R30,LOW(81)
	LDI  R31,HIGH(81)
	ST   X+,R30
	ST   X,R31
; 0000 057A       komunikat_z_czytnika_kodow("86-0816",rzad,0);
	__POINTW1FN _0x0,818
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x40
; 0000 057B       srednica_wew_korpusu = 36;
; 0000 057C     }
; 0000 057D if(PORT_CZYTNIK.byte == 0x52)
_0x6D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x52)
	BRNE _0x6E
; 0000 057E     {
; 0000 057F       macierz_zaciskow[rzad]=82;
	CALL SUBOPT_0x32
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	ST   X+,R30
	ST   X,R31
; 0000 0580       komunikat_z_czytnika_kodow("86-1552",rzad,0);
	__POINTW1FN _0x0,826
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 0581       srednica_wew_korpusu = 34;
; 0000 0582     }
; 0000 0583 if(PORT_CZYTNIK.byte == 0x53)
_0x6E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x53)
	BRNE _0x6F
; 0000 0584     {
; 0000 0585       macierz_zaciskow[rzad]=83;
	CALL SUBOPT_0x32
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	ST   X+,R30
	ST   X,R31
; 0000 0586       komunikat_z_czytnika_kodow("86-2007",rzad,1);
	__POINTW1FN _0x0,834
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0587       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 0588     }
; 0000 0589 if(PORT_CZYTNIK.byte == 0x54)
_0x6F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x54)
	BRNE _0x70
; 0000 058A     {
; 0000 058B       macierz_zaciskow[rzad]=84;
	CALL SUBOPT_0x32
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	ST   X+,R30
	ST   X,R31
; 0000 058C       komunikat_z_czytnika_kodow("86-2292",rzad,1);
	__POINTW1FN _0x0,842
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 058D       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 058E     }
; 0000 058F if(PORT_CZYTNIK.byte == 0x55)
_0x70:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x55)
	BRNE _0x71
; 0000 0590     {
; 0000 0591       macierz_zaciskow[rzad]=85;
	CALL SUBOPT_0x32
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	ST   X+,R30
	ST   X,R31
; 0000 0592       komunikat_z_czytnika_kodow("87-0816",rzad,1);
	__POINTW1FN _0x0,850
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0593       srednica_wew_korpusu = 36;
	CALL SUBOPT_0x41
; 0000 0594      }
; 0000 0595 if(PORT_CZYTNIK.byte == 0x56)
_0x71:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x56)
	BRNE _0x72
; 0000 0596     {
; 0000 0597       macierz_zaciskow[rzad]=86;
	CALL SUBOPT_0x32
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	ST   X+,R30
	ST   X,R31
; 0000 0598       komunikat_z_czytnika_kodow("87-1552",rzad,1);
	__POINTW1FN _0x0,858
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0599       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 059A     }
; 0000 059B if(PORT_CZYTNIK.byte == 0x57)
_0x72:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x57)
	BRNE _0x73
; 0000 059C     {
; 0000 059D       macierz_zaciskow[rzad]=87;
	CALL SUBOPT_0x32
	LDI  R30,LOW(87)
	LDI  R31,HIGH(87)
	ST   X+,R30
	ST   X,R31
; 0000 059E       komunikat_z_czytnika_kodow("87-2007",rzad,0);
	__POINTW1FN _0x0,866
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 059F       srednica_wew_korpusu = 41;
; 0000 05A0     }
; 0000 05A1 if(PORT_CZYTNIK.byte == 0x58)
_0x73:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x58)
	BRNE _0x74
; 0000 05A2     {
; 0000 05A3       macierz_zaciskow[rzad]=88;
	CALL SUBOPT_0x32
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	ST   X+,R30
	ST   X,R31
; 0000 05A4       komunikat_z_czytnika_kodow("87-2292",rzad,0);
	__POINTW1FN _0x0,874
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 05A5       srednica_wew_korpusu = 38;
; 0000 05A6     }
; 0000 05A7 if(PORT_CZYTNIK.byte == 0x59)
_0x74:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x59)
	BRNE _0x75
; 0000 05A8     {
; 0000 05A9       macierz_zaciskow[rzad]=89;
	CALL SUBOPT_0x32
	LDI  R30,LOW(89)
	LDI  R31,HIGH(89)
	ST   X+,R30
	ST   X,R31
; 0000 05AA       komunikat_z_czytnika_kodow("86-0817",rzad,0);
	__POINTW1FN _0x0,882
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 05AB       srednica_wew_korpusu = 38;
; 0000 05AC     }
; 0000 05AD if(PORT_CZYTNIK.byte == 0x5A)
_0x75:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5A)
	BRNE _0x76
; 0000 05AE     {
; 0000 05AF       macierz_zaciskow[rzad]=90;
	CALL SUBOPT_0x32
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   X+,R30
	ST   X,R31
; 0000 05B0       komunikat_z_czytnika_kodow("86-1602",rzad,1);
	__POINTW1FN _0x0,890
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 05B1       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 05B2     }
; 0000 05B3 if(PORT_CZYTNIK.byte == 0x5B)
_0x76:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5B)
	BRNE _0x77
; 0000 05B4     {
; 0000 05B5       macierz_zaciskow[rzad]=91;
	CALL SUBOPT_0x32
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	ST   X+,R30
	ST   X,R31
; 0000 05B6       komunikat_z_czytnika_kodow("86-2017",rzad,1);
	__POINTW1FN _0x0,898
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 05B7       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 05B8     }
; 0000 05B9 if(PORT_CZYTNIK.byte == 0x5C)
_0x77:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5C)
	BRNE _0x78
; 0000 05BA     {
; 0000 05BB       macierz_zaciskow[rzad]=92;
	CALL SUBOPT_0x32
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x3E
; 0000 05BC       macierz_zaciskow[rzad]=0;           /////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x3F
; 0000 05BD       komunikat_z_czytnika_kodow("86-2384",rzad,0);
	__POINTW1FN _0x0,906
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 05BE       srednica_wew_korpusu = 38;
; 0000 05BF     }
; 0000 05C0 if(PORT_CZYTNIK.byte == 0x5D)
_0x78:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5D)
	BRNE _0x79
; 0000 05C1     {
; 0000 05C2       macierz_zaciskow[rzad]=93;
	CALL SUBOPT_0x32
	LDI  R30,LOW(93)
	LDI  R31,HIGH(93)
	ST   X+,R30
	ST   X,R31
; 0000 05C3       komunikat_z_czytnika_kodow("87-0817",rzad,1);
	__POINTW1FN _0x0,914
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 05C4       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 05C5     }
; 0000 05C6 if(PORT_CZYTNIK.byte == 0x5E)
_0x79:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5E)
	BRNE _0x7A
; 0000 05C7     {
; 0000 05C8       macierz_zaciskow[rzad]=94;
	CALL SUBOPT_0x32
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	ST   X+,R30
	ST   X,R31
; 0000 05C9       komunikat_z_czytnika_kodow("87-1602",rzad,0);
	__POINTW1FN _0x0,922
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 05CA       srednica_wew_korpusu = 38;
; 0000 05CB     }
; 0000 05CC if(PORT_CZYTNIK.byte == 0x5F)
_0x7A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5F)
	BRNE _0x7B
; 0000 05CD     {
; 0000 05CE       macierz_zaciskow[rzad]=95;
	CALL SUBOPT_0x32
	LDI  R30,LOW(95)
	LDI  R31,HIGH(95)
	ST   X+,R30
	ST   X,R31
; 0000 05CF       komunikat_z_czytnika_kodow("87-2017",rzad,0);
	__POINTW1FN _0x0,930
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 05D0       srednica_wew_korpusu = 41;
; 0000 05D1     }
; 0000 05D2 if(PORT_CZYTNIK.byte == 0x60)
_0x7B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x60)
	BRNE _0x7C
; 0000 05D3     {
; 0000 05D4       macierz_zaciskow[rzad]=96;   ///////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x32
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x3E
; 0000 05D5       macierz_zaciskow[rzad]=0;
	CALL SUBOPT_0x3F
; 0000 05D6       komunikat_z_czytnika_kodow("87-2384",rzad,0);
	__POINTW1FN _0x0,938
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 05D7       srednica_wew_korpusu = 38;
; 0000 05D8     }
; 0000 05D9 
; 0000 05DA if(PORT_CZYTNIK.byte == 0x61)
_0x7C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x61)
	BRNE _0x7D
; 0000 05DB     {
; 0000 05DC       macierz_zaciskow[rzad]=97;
	CALL SUBOPT_0x32
	LDI  R30,LOW(97)
	LDI  R31,HIGH(97)
	ST   X+,R30
	ST   X,R31
; 0000 05DD       komunikat_z_czytnika_kodow("86-0847",rzad,0);
	__POINTW1FN _0x0,946
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 05DE       srednica_wew_korpusu = 41;
; 0000 05DF     }
; 0000 05E0 
; 0000 05E1 if(PORT_CZYTNIK.byte == 0x62)
_0x7D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x62)
	BRNE _0x7E
; 0000 05E2     {
; 0000 05E3       macierz_zaciskow[rzad]=98;
	CALL SUBOPT_0x32
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	ST   X+,R30
	ST   X,R31
; 0000 05E4       komunikat_z_czytnika_kodow("86-1620",rzad,0);
	__POINTW1FN _0x0,954
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 05E5       srednica_wew_korpusu = 38;
; 0000 05E6     }
; 0000 05E7 if(PORT_CZYTNIK.byte == 0x63)
_0x7E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x63)
	BRNE _0x7F
; 0000 05E8     {
; 0000 05E9       macierz_zaciskow[rzad]=99;
	CALL SUBOPT_0x32
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	ST   X+,R30
	ST   X,R31
; 0000 05EA       komunikat_z_czytnika_kodow("86-2019",rzad,1);
	__POINTW1FN _0x0,962
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 05EB       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 05EC     }
; 0000 05ED if(PORT_CZYTNIK.byte == 0x64)
_0x7F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x64)
	BRNE _0x80
; 0000 05EE     {
; 0000 05EF       macierz_zaciskow[rzad]=100;
	CALL SUBOPT_0x32
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   X+,R30
	ST   X,R31
; 0000 05F0       komunikat_z_czytnika_kodow("86-2385",rzad,0);
	__POINTW1FN _0x0,970
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 05F1       srednica_wew_korpusu = 38;
; 0000 05F2     }
; 0000 05F3 if(PORT_CZYTNIK.byte == 0x65)
_0x80:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x65)
	BRNE _0x81
; 0000 05F4     {
; 0000 05F5       macierz_zaciskow[rzad]=101;
	CALL SUBOPT_0x32
	LDI  R30,LOW(101)
	LDI  R31,HIGH(101)
	ST   X+,R30
	ST   X,R31
; 0000 05F6       komunikat_z_czytnika_kodow("87-0847",rzad,1);
	__POINTW1FN _0x0,978
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 05F7       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 05F8     }
; 0000 05F9 if(PORT_CZYTNIK.byte == 0x66)
_0x81:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x66)
	BRNE _0x82
; 0000 05FA     {
; 0000 05FB       macierz_zaciskow[rzad]=102;
	CALL SUBOPT_0x32
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	ST   X+,R30
	ST   X,R31
; 0000 05FC       komunikat_z_czytnika_kodow("87-1620",rzad,1);
	__POINTW1FN _0x0,986
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 05FD       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 05FE     }
; 0000 05FF if(PORT_CZYTNIK.byte == 0x67)
_0x82:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x67)
	BRNE _0x83
; 0000 0600     {
; 0000 0601       macierz_zaciskow[rzad]=103;
	CALL SUBOPT_0x32
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	ST   X+,R30
	ST   X,R31
; 0000 0602       komunikat_z_czytnika_kodow("87-2019",rzad,0);
	__POINTW1FN _0x0,994
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 0603       srednica_wew_korpusu = 41;
; 0000 0604     }
; 0000 0605 if(PORT_CZYTNIK.byte == 0x68)
_0x83:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x68)
	BRNE _0x84
; 0000 0606     {
; 0000 0607       macierz_zaciskow[rzad]=104;
	CALL SUBOPT_0x32
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	ST   X+,R30
	ST   X,R31
; 0000 0608       komunikat_z_czytnika_kodow("87-2385",rzad,1);
	__POINTW1FN _0x0,1002
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0609       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 060A     }
; 0000 060B if(PORT_CZYTNIK.byte == 0x69)
_0x84:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x69)
	BRNE _0x85
; 0000 060C     {
; 0000 060D       macierz_zaciskow[rzad]=105;
	CALL SUBOPT_0x32
	LDI  R30,LOW(105)
	LDI  R31,HIGH(105)
	ST   X+,R30
	ST   X,R31
; 0000 060E       komunikat_z_czytnika_kodow("86-0854",rzad,0);
	__POINTW1FN _0x0,1010
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 060F       srednica_wew_korpusu = 34;
; 0000 0610     }
; 0000 0611 if(PORT_CZYTNIK.byte == 0x6A)
_0x85:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6A)
	BRNE _0x86
; 0000 0612     {
; 0000 0613       macierz_zaciskow[rzad]=106;
	CALL SUBOPT_0x32
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	ST   X+,R30
	ST   X,R31
; 0000 0614       komunikat_z_czytnika_kodow("86-1622",rzad,1);
	__POINTW1FN _0x0,1018
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0615       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 0616     }
; 0000 0617 if(PORT_CZYTNIK.byte == 0x6B)
_0x86:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6B)
	BRNE _0x87
; 0000 0618     {
; 0000 0619       macierz_zaciskow[rzad]=107;
	CALL SUBOPT_0x32
	LDI  R30,LOW(107)
	LDI  R31,HIGH(107)
	CALL SUBOPT_0x3E
; 0000 061A       macierz_zaciskow[rzad]=0;          //brak zacisku
	CALL SUBOPT_0x3F
; 0000 061B       komunikat_z_czytnika_kodow("86-2028",rzad,0);
	__POINTW1FN _0x0,1026
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3D
; 0000 061C       srednica_wew_korpusu = 43;
; 0000 061D     }
; 0000 061E if(PORT_CZYTNIK.byte == 0x6C)
_0x87:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6C)
	BRNE _0x88
; 0000 061F     {
; 0000 0620       macierz_zaciskow[rzad]=108;
	CALL SUBOPT_0x32
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	ST   X+,R30
	ST   X,R31
; 0000 0621       komunikat_z_czytnika_kodow("86-2437",rzad,0);
	__POINTW1FN _0x0,1034
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 0622       srednica_wew_korpusu = 38;
; 0000 0623     }
; 0000 0624 if(PORT_CZYTNIK.byte == 0x6D)
_0x88:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6D)
	BRNE _0x89
; 0000 0625     {
; 0000 0626       macierz_zaciskow[rzad]=109;
	CALL SUBOPT_0x32
	LDI  R30,LOW(109)
	LDI  R31,HIGH(109)
	ST   X+,R30
	ST   X,R31
; 0000 0627       komunikat_z_czytnika_kodow("87-0854",rzad,1);
	__POINTW1FN _0x0,1042
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0628       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 0629     }
; 0000 062A if(PORT_CZYTNIK.byte == 0x6E)
_0x89:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6E)
	BRNE _0x8A
; 0000 062B     {
; 0000 062C       macierz_zaciskow[rzad]=110;
	CALL SUBOPT_0x32
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	ST   X+,R30
	ST   X,R31
; 0000 062D       komunikat_z_czytnika_kodow("87-1622",rzad,0);
	__POINTW1FN _0x0,1050
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 062E       srednica_wew_korpusu = 34;
; 0000 062F     }
; 0000 0630 
; 0000 0631 if(PORT_CZYTNIK.byte == 0x6F)
_0x8A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6F)
	BRNE _0x8B
; 0000 0632     {
; 0000 0633       macierz_zaciskow[rzad]=111;
	CALL SUBOPT_0x32
	LDI  R30,LOW(111)
	LDI  R31,HIGH(111)
	CALL SUBOPT_0x3E
; 0000 0634       macierz_zaciskow[rzad]=0;      //brak zacisku
	CALL SUBOPT_0x3F
; 0000 0635       komunikat_z_czytnika_kodow("87-2028",rzad,0);
	__POINTW1FN _0x0,1058
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3D
; 0000 0636       srednica_wew_korpusu = 43;
; 0000 0637     }
; 0000 0638 
; 0000 0639 if(PORT_CZYTNIK.byte == 0x70)
_0x8B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x70)
	BRNE _0x8C
; 0000 063A     {
; 0000 063B       macierz_zaciskow[rzad]=112;
	CALL SUBOPT_0x32
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   X+,R30
	ST   X,R31
; 0000 063C       komunikat_z_czytnika_kodow("87-2437",rzad,1);
	__POINTW1FN _0x0,1066
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 063D       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 063E     }
; 0000 063F if(PORT_CZYTNIK.byte == 0x71)
_0x8C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x71)
	BRNE _0x8D
; 0000 0640     {
; 0000 0641       macierz_zaciskow[rzad]=113;
	CALL SUBOPT_0x32
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   X+,R30
	ST   X,R31
; 0000 0642       komunikat_z_czytnika_kodow("86-0862",rzad,0);
	__POINTW1FN _0x0,1074
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 0643       srednica_wew_korpusu = 38;
; 0000 0644     }
; 0000 0645 if(PORT_CZYTNIK.byte == 0x72)
_0x8D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x72)
	BRNE _0x8E
; 0000 0646     {
; 0000 0647       macierz_zaciskow[rzad]=114;
	CALL SUBOPT_0x32
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	ST   X+,R30
	ST   X,R31
; 0000 0648       komunikat_z_czytnika_kodow("86-1625",rzad,0);
	__POINTW1FN _0x0,1082
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 0649       srednica_wew_korpusu = 38;
; 0000 064A     }
; 0000 064B if(PORT_CZYTNIK.byte == 0x73)
_0x8E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x73)
	BRNE _0x8F
; 0000 064C     {
; 0000 064D       macierz_zaciskow[rzad]=115;
	CALL SUBOPT_0x32
	LDI  R30,LOW(115)
	LDI  R31,HIGH(115)
	ST   X+,R30
	ST   X,R31
; 0000 064E       komunikat_z_czytnika_kodow("86-2052",rzad,0);
	__POINTW1FN _0x0,1090
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3D
; 0000 064F       srednica_wew_korpusu = 43;
; 0000 0650     }
; 0000 0651 if(PORT_CZYTNIK.byte == 0x74)
_0x8F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x74)
	BRNE _0x90
; 0000 0652     {
; 0000 0653       macierz_zaciskow[rzad]=116;
	CALL SUBOPT_0x32
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	ST   X+,R30
	ST   X,R31
; 0000 0654       komunikat_z_czytnika_kodow("86-2492",rzad,1);
	__POINTW1FN _0x0,1098
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0655       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 0656     }
; 0000 0657 if(PORT_CZYTNIK.byte == 0x75)
_0x90:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x75)
	BRNE _0x91
; 0000 0658     {
; 0000 0659       macierz_zaciskow[rzad]=117;
	CALL SUBOPT_0x32
	LDI  R30,LOW(117)
	LDI  R31,HIGH(117)
	ST   X+,R30
	ST   X,R31
; 0000 065A       komunikat_z_czytnika_kodow("87-0862",rzad,1);
	__POINTW1FN _0x0,1106
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 065B       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 065C     }
; 0000 065D if(PORT_CZYTNIK.byte == 0x76)
_0x91:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x76)
	BRNE _0x92
; 0000 065E     {
; 0000 065F       macierz_zaciskow[rzad]=118;
	CALL SUBOPT_0x32
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	ST   X+,R30
	ST   X,R31
; 0000 0660       komunikat_z_czytnika_kodow("87-1625",rzad,1);
	__POINTW1FN _0x0,1114
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0661       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 0662     }
; 0000 0663 if(PORT_CZYTNIK.byte == 0x77)
_0x92:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x77)
	BRNE _0x93
; 0000 0664     {
; 0000 0665       macierz_zaciskow[rzad]=119;
	CALL SUBOPT_0x32
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   X+,R30
	ST   X,R31
; 0000 0666       komunikat_z_czytnika_kodow("87-2052",rzad,1);
	__POINTW1FN _0x0,1122
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0667       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x3C
; 0000 0668     }
; 0000 0669 if(PORT_CZYTNIK.byte == 0x78)
_0x93:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x78)
	BRNE _0x94
; 0000 066A     {
; 0000 066B       macierz_zaciskow[rzad]=120;
	CALL SUBOPT_0x32
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   X+,R30
	ST   X,R31
; 0000 066C       komunikat_z_czytnika_kodow("87-2492",rzad,0);
	__POINTW1FN _0x0,1130
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 066D       srednica_wew_korpusu = 38;
; 0000 066E     }
; 0000 066F if(PORT_CZYTNIK.byte == 0x79)
_0x94:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x79)
	BRNE _0x95
; 0000 0670     {
; 0000 0671       macierz_zaciskow[rzad]=121;
	CALL SUBOPT_0x32
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   X+,R30
	ST   X,R31
; 0000 0672       komunikat_z_czytnika_kodow("86-0935",rzad,0);
	__POINTW1FN _0x0,1138
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 0673       srednica_wew_korpusu = 38;
; 0000 0674     }
; 0000 0675 if(PORT_CZYTNIK.byte == 0x7A)
_0x95:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7A)
	BRNE _0x96
; 0000 0676     {
; 0000 0677       macierz_zaciskow[rzad]=122;
	CALL SUBOPT_0x32
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	ST   X+,R30
	ST   X,R31
; 0000 0678       komunikat_z_czytnika_kodow("86-1648",rzad,0);
	__POINTW1FN _0x0,1146
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 0679       srednica_wew_korpusu = 38;
; 0000 067A     }
; 0000 067B if(PORT_CZYTNIK.byte == 0x7B)
_0x96:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7B)
	BRNE _0x97
; 0000 067C     {
; 0000 067D       macierz_zaciskow[rzad]=123;
	CALL SUBOPT_0x32
	LDI  R30,LOW(123)
	LDI  R31,HIGH(123)
	ST   X+,R30
	ST   X,R31
; 0000 067E       komunikat_z_czytnika_kodow("86-2082",rzad,0);
	__POINTW1FN _0x0,1154
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x40
; 0000 067F       srednica_wew_korpusu = 36;
; 0000 0680     }
; 0000 0681 if(PORT_CZYTNIK.byte == 0x7C)
_0x97:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7C)
	BRNE _0x98
; 0000 0682     {
; 0000 0683       macierz_zaciskow[rzad]=124;
	CALL SUBOPT_0x32
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	ST   X+,R30
	ST   X,R31
; 0000 0684       komunikat_z_czytnika_kodow("86-2500",rzad,0);
	__POINTW1FN _0x0,1162
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 0685       srednica_wew_korpusu = 38;
; 0000 0686     }
; 0000 0687 if(PORT_CZYTNIK.byte == 0x7D)
_0x98:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7D)
	BRNE _0x99
; 0000 0688     {
; 0000 0689       macierz_zaciskow[rzad]=125;
	CALL SUBOPT_0x32
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   X+,R30
	ST   X,R31
; 0000 068A       komunikat_z_czytnika_kodow("87-0935",rzad,1);
	__POINTW1FN _0x0,1170
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 068B       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 068C     }
; 0000 068D if(PORT_CZYTNIK.byte == 0x7E)
_0x99:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7E)
	BRNE _0x9A
; 0000 068E     {
; 0000 068F       macierz_zaciskow[rzad]=126;
	CALL SUBOPT_0x32
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	ST   X+,R30
	ST   X,R31
; 0000 0690       komunikat_z_czytnika_kodow("87-1648",rzad,1);
	__POINTW1FN _0x0,1178
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0691       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 0692     }
; 0000 0693 
; 0000 0694 if(PORT_CZYTNIK.byte == 0x7F)
_0x9A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7F)
	BRNE _0x9B
; 0000 0695     {
; 0000 0696       macierz_zaciskow[rzad]=127;
	CALL SUBOPT_0x32
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	ST   X+,R30
	ST   X,R31
; 0000 0697       komunikat_z_czytnika_kodow("87-2082",rzad,1);
	__POINTW1FN _0x0,1186
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 0698       srednica_wew_korpusu = 36;
	CALL SUBOPT_0x41
; 0000 0699     }
; 0000 069A if(PORT_CZYTNIK.byte == 0x80)
_0x9B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x80)
	BRNE _0x9C
; 0000 069B     {
; 0000 069C       macierz_zaciskow[rzad]=128;
	CALL SUBOPT_0x32
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   X+,R30
	ST   X,R31
; 0000 069D       komunikat_z_czytnika_kodow("87-2500",rzad,1);
	__POINTW1FN _0x0,1194
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 069E       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 069F     }
; 0000 06A0 if(PORT_CZYTNIK.byte == 0x81)
_0x9C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x81)
	BRNE _0x9D
; 0000 06A1     {
; 0000 06A2       macierz_zaciskow[rzad]=129;
	CALL SUBOPT_0x32
	LDI  R30,LOW(129)
	LDI  R31,HIGH(129)
	ST   X+,R30
	ST   X,R31
; 0000 06A3       komunikat_z_czytnika_kodow("86-1019",rzad,0);
	__POINTW1FN _0x0,1202
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3A
; 0000 06A4       srednica_wew_korpusu = 41;
; 0000 06A5     }
; 0000 06A6 if(PORT_CZYTNIK.byte == 0x82)
_0x9D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x82)
	BRNE _0x9E
; 0000 06A7     {
; 0000 06A8       macierz_zaciskow[rzad]=130;
	CALL SUBOPT_0x32
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	ST   X+,R30
	ST   X,R31
; 0000 06A9       komunikat_z_czytnika_kodow("86-1649",rzad,0);
	__POINTW1FN _0x0,1210
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 06AA       srednica_wew_korpusu = 38;
; 0000 06AB     }
; 0000 06AC if(PORT_CZYTNIK.byte == 0x83)
_0x9E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x83)
	BRNE _0x9F
; 0000 06AD     {
; 0000 06AE       macierz_zaciskow[rzad]=131;
	CALL SUBOPT_0x32
	LDI  R30,LOW(131)
	LDI  R31,HIGH(131)
	ST   X+,R30
	ST   X,R31
; 0000 06AF       komunikat_z_czytnika_kodow("86-2083",rzad,1);
	__POINTW1FN _0x0,1218
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 06B0       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x3C
; 0000 06B1     }
; 0000 06B2 if(PORT_CZYTNIK.byte == 0x84)
_0x9F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x84)
	BRNE _0xA0
; 0000 06B3     {
; 0000 06B4       macierz_zaciskow[rzad]=132;
	CALL SUBOPT_0x32
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	ST   X+,R30
	ST   X,R31
; 0000 06B5       komunikat_z_czytnika_kodow("86-2585",rzad,0);
	__POINTW1FN _0x0,1226
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3D
; 0000 06B6       srednica_wew_korpusu = 43;
; 0000 06B7     }
; 0000 06B8 if(PORT_CZYTNIK.byte == 0x85)
_0xA0:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x85)
	BRNE _0xA1
; 0000 06B9     {
; 0000 06BA       macierz_zaciskow[rzad]=133;
	CALL SUBOPT_0x32
	LDI  R30,LOW(133)
	LDI  R31,HIGH(133)
	ST   X+,R30
	ST   X,R31
; 0000 06BB       komunikat_z_czytnika_kodow("87-1019",rzad,1);
	__POINTW1FN _0x0,1234
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 06BC       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3B
; 0000 06BD     }
; 0000 06BE if(PORT_CZYTNIK.byte == 0x86)
_0xA1:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x86)
	BRNE _0xA2
; 0000 06BF     {
; 0000 06C0       macierz_zaciskow[rzad]=134;
	CALL SUBOPT_0x32
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	ST   X+,R30
	ST   X,R31
; 0000 06C1       komunikat_z_czytnika_kodow("87-1649",rzad,1);
	__POINTW1FN _0x0,1242
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 06C2       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 06C3     }
; 0000 06C4 if(PORT_CZYTNIK.byte == 0x87)
_0xA2:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x87)
	BRNE _0xA3
; 0000 06C5     {
; 0000 06C6       macierz_zaciskow[rzad]=135;
	CALL SUBOPT_0x32
	LDI  R30,LOW(135)
	LDI  R31,HIGH(135)
	ST   X+,R30
	ST   X,R31
; 0000 06C7       komunikat_z_czytnika_kodow("87-2083",rzad,0);
	__POINTW1FN _0x0,1250
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3D
; 0000 06C8       srednica_wew_korpusu = 43;
; 0000 06C9     }
; 0000 06CA 
; 0000 06CB if(PORT_CZYTNIK.byte == 0x88)
_0xA3:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x88)
	BRNE _0xA4
; 0000 06CC     {
; 0000 06CD       macierz_zaciskow[rzad]=136;
	CALL SUBOPT_0x32
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	ST   X+,R30
	ST   X,R31
; 0000 06CE       komunikat_z_czytnika_kodow("87-2624",rzad,1);
	__POINTW1FN _0x0,1258
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 06CF       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 06D0     }
; 0000 06D1 if(PORT_CZYTNIK.byte == 0x89)
_0xA4:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x89)
	BRNE _0xA5
; 0000 06D2     {
; 0000 06D3       macierz_zaciskow[rzad]=137;
	CALL SUBOPT_0x32
	LDI  R30,LOW(137)
	LDI  R31,HIGH(137)
	ST   X+,R30
	ST   X,R31
; 0000 06D4       komunikat_z_czytnika_kodow("86-1027",rzad,0);
	__POINTW1FN _0x0,1266
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 06D5       srednica_wew_korpusu = 34;
; 0000 06D6     }
; 0000 06D7 if(PORT_CZYTNIK.byte == 0x8A)
_0xA5:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8A)
	BRNE _0xA6
; 0000 06D8     {
; 0000 06D9       macierz_zaciskow[rzad]=138;
	CALL SUBOPT_0x32
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	ST   X+,R30
	ST   X,R31
; 0000 06DA       komunikat_z_czytnika_kodow("86-1669",rzad,1);
	__POINTW1FN _0x0,1274
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 06DB       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 06DC     }
; 0000 06DD if(PORT_CZYTNIK.byte == 0x8B)
_0xA6:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8B)
	BRNE _0xA7
; 0000 06DE     {
; 0000 06DF       macierz_zaciskow[rzad]=139;
	CALL SUBOPT_0x32
	LDI  R30,LOW(139)
	LDI  R31,HIGH(139)
	ST   X+,R30
	ST   X,R31
; 0000 06E0       komunikat_z_czytnika_kodow("86-2087",rzad,1);
	__POINTW1FN _0x0,1282
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 06E1       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x36
; 0000 06E2     }
; 0000 06E3 if(PORT_CZYTNIK.byte == 0x8C)
_0xA7:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8C)
	BRNE _0xA8
; 0000 06E4     {
; 0000 06E5       macierz_zaciskow[rzad]=140;
	CALL SUBOPT_0x32
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	ST   X+,R30
	ST   X,R31
; 0000 06E6       komunikat_z_czytnika_kodow("86-2624",rzad,0);
	__POINTW1FN _0x0,1290
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x37
; 0000 06E7       srednica_wew_korpusu = 34;
; 0000 06E8     }
; 0000 06E9 if(PORT_CZYTNIK.byte == 0x8D)
_0xA8:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8D)
	BRNE _0xA9
; 0000 06EA     {
; 0000 06EB       macierz_zaciskow[rzad]=141;
	CALL SUBOPT_0x32
	LDI  R30,LOW(141)
	LDI  R31,HIGH(141)
	ST   X+,R30
	ST   X,R31
; 0000 06EC       komunikat_z_czytnika_kodow("87-1027",rzad,1);
	__POINTW1FN _0x0,1298
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 06ED       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x39
; 0000 06EE     }
; 0000 06EF if(PORT_CZYTNIK.byte == 0x8E)
_0xA9:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8E)
	BRNE _0xAA
; 0000 06F0     {
; 0000 06F1       macierz_zaciskow[rzad]=142;
	CALL SUBOPT_0x32
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	ST   X+,R30
	ST   X,R31
; 0000 06F2       komunikat_z_czytnika_kodow("87-1669",rzad,0);
	__POINTW1FN _0x0,1306
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 06F3       srednica_wew_korpusu = 38;
; 0000 06F4     }
; 0000 06F5 if(PORT_CZYTNIK.byte == 0x8F)
_0xAA:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8F)
	BRNE _0xAB
; 0000 06F6     {
; 0000 06F7       macierz_zaciskow[rzad]=143;
	CALL SUBOPT_0x32
	LDI  R30,LOW(143)
	LDI  R31,HIGH(143)
	ST   X+,R30
	ST   X,R31
; 0000 06F8       komunikat_z_czytnika_kodow("87-2087",rzad,0);
	__POINTW1FN _0x0,1314
	CALL SUBOPT_0x34
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
; 0000 06F9       srednica_wew_korpusu = 38;
; 0000 06FA     }
; 0000 06FB if(PORT_CZYTNIK.byte == 0x90)
_0xAB:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x90)
	BRNE _0xAC
; 0000 06FC     {
; 0000 06FD       macierz_zaciskow[rzad]=144;
	CALL SUBOPT_0x32
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   X+,R30
	ST   X,R31
; 0000 06FE       komunikat_z_czytnika_kodow("87-2585",rzad,1);
	__POINTW1FN _0x0,1322
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0000 06FF       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x3C
; 0000 0700     }
; 0000 0701 
; 0000 0702 
; 0000 0703 return rzad;
_0xAC:
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0704 }
;
;
;void wybor_linijek_sterownikow(int rzad_local)
; 0000 0708 {
_wybor_linijek_sterownikow:
; 0000 0709 //zaczynam od tego
; 0000 070A //komentarz: celowo upraszam:
; 0000 070B //  a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 070C //a[4] = 0x21;    //ster3 ABS             //krazek scierny
; 0000 070D 
; 0000 070E //legenda pierwotna
; 0000 070F             /*
; 0000 0710             a[0] = 0x05A;   //ster1
; 0000 0711             a[1] = a[0]+0x001;                                   //0x05B;   //ster2
; 0000 0712             a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 0713             a[3] = 0x11;    //ster4 INV             //druciak
; 0000 0714             a[4] = a[2];   //0x21;    //ster3 ABS             //krazek scierny
; 0000 0715             a[5] = 0x196;   //delta okrag
; 0000 0716             a[6] = a[5]+0x001;            //0x197;   //okrag
; 0000 0717             a[7] = 0x12;    //ster3 INV             krazek scierny
; 0000 0718             a[8] = a[6]+0x001;                0x198;   //-delta okrag
; 0000 0719             a[9] = 0;          //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 071A             */
; 0000 071B 
; 0000 071C 
; 0000 071D //macierz_zaciskow[rzad_local]
; 0000 071E //macierz_zaciskow[rzad_local] = 140;
; 0000 071F 
; 0000 0720 
; 0000 0721 
; 0000 0722 
; 0000 0723 
; 0000 0724 
; 0000 0725 switch(macierz_zaciskow[rzad_local])
;	rzad_local -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_macierz_zaciskow)
	LDI  R27,HIGH(_macierz_zaciskow)
	CALL SUBOPT_0x42
	CALL __GETW1P
; 0000 0726 {
; 0000 0727     case 0:
	SBIW R30,0
	BRNE _0xB0
; 0000 0728 
; 0000 0729             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 072A             komunikat_na_panel("Nie wczytano zacisku",adr1,adr2);
	__POINTW1FN _0x0,1330
	CALL SUBOPT_0x2E
; 0000 072B 
; 0000 072C     break;
	JMP  _0xAF
; 0000 072D 
; 0000 072E 
; 0000 072F      case 1:
_0xB0:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB1
; 0000 0730 
; 0000 0731             a[0] = 0x0C8;   //ster1
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x43
; 0000 0732             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0733             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0734             a[5] = 0x196;   //delta okrag
; 0000 0735             a[7] = 0x11;    //ster3 INV krazek scierny
	JMP  _0x545
; 0000 0736             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0737 
; 0000 0738             a[1] = a[0]+0x001;  //ster2
; 0000 0739             a[2] = a[4];        //ster4 ABS druciak
; 0000 073A             a[6] = a[5]+0x001;  //okrag
; 0000 073B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 073C 
; 0000 073D     break;
; 0000 073E 
; 0000 073F       case 2:
_0xB1:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB2
; 0000 0740 
; 0000 0741             a[0] = 0x110;   //ster1
	LDI  R30,LOW(272)
	LDI  R31,HIGH(272)
	CALL SUBOPT_0x43
; 0000 0742             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 0743             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 0744             a[5] = 0x190;   //delta okrag
; 0000 0745             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x46
; 0000 0746             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x48
	JMP  _0x546
; 0000 0747 
; 0000 0748             a[1] = a[0]+0x001;  //ster2
; 0000 0749             a[2] = a[4];        //ster4 ABS druciak
; 0000 074A             a[6] = a[5]+0x001;  //okrag
; 0000 074B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 074C 
; 0000 074D     break;
; 0000 074E 
; 0000 074F       case 3:
_0xB2:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xB3
; 0000 0750 
; 0000 0751             a[0] = 0x07A;   //ster1
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	CALL SUBOPT_0x43
; 0000 0752             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0753             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0754             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0755             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0756             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x546
; 0000 0757 
; 0000 0758             a[1] = a[0]+0x001;  //ster2
; 0000 0759             a[2] = a[4];        //ster4 ABS druciak
; 0000 075A             a[6] = a[5]+0x001;  //okrag
; 0000 075B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 075C 
; 0000 075D     break;
; 0000 075E 
; 0000 075F       case 4:
_0xB3:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xB4
; 0000 0760 
; 0000 0761             a[0] = 0x102;   //ster1
	LDI  R30,LOW(258)
	LDI  R31,HIGH(258)
	CALL SUBOPT_0x43
; 0000 0762             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0763             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0764             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0765             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0766             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x546
; 0000 0767 
; 0000 0768             a[1] = a[0]+0x001;  //ster2
; 0000 0769             a[2] = a[4];        //ster4 ABS druciak
; 0000 076A             a[6] = a[5]+0x001;  //okrag
; 0000 076B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 076C 
; 0000 076D     break;
; 0000 076E 
; 0000 076F       case 5:
_0xB4:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xB5
; 0000 0770 
; 0000 0771             a[0] = 0x0B0;   //ster1
	LDI  R30,LOW(176)
	LDI  R31,HIGH(176)
	CALL SUBOPT_0x43
; 0000 0772             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0773             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0774             a[5] = 0x196;   //delta okrag
; 0000 0775             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0776             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0777 
; 0000 0778             a[1] = a[0]+0x001;  //ster2
; 0000 0779             a[2] = a[4];        //ster4 ABS druciak
; 0000 077A             a[6] = a[5]+0x001;  //okrag
; 0000 077B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 077C 
; 0000 077D     break;
; 0000 077E 
; 0000 077F       case 6:
_0xB5:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xB6
; 0000 0780 
; 0000 0781             a[0] = 0x0FE;   //ster1
	LDI  R30,LOW(254)
	LDI  R31,HIGH(254)
	CALL SUBOPT_0x43
; 0000 0782             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 0783             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 0784             a[5] = 0x190;   //delta okrag
; 0000 0785             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x545
; 0000 0786             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0787 
; 0000 0788             a[1] = a[0]+0x001;  //ster2
; 0000 0789             a[2] = a[4];        //ster4 ABS druciak
; 0000 078A             a[6] = a[5]+0x001;  //okrag
; 0000 078B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 078C 
; 0000 078D     break;
; 0000 078E 
; 0000 078F 
; 0000 0790       case 7:
_0xB6:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xB7
; 0000 0791 
; 0000 0792             a[0] = 0x078;   //ster1
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x43
; 0000 0793             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0794             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0795             a[5] = 0x196;   //delta okrag
	RJMP _0x547
; 0000 0796             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0797             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0798 
; 0000 0799             a[1] = a[0]+0x001;  //ster2
; 0000 079A             a[2] = a[4];        //ster4 ABS druciak
; 0000 079B             a[6] = a[5]+0x001;  //okrag
; 0000 079C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 079D 
; 0000 079E     break;
; 0000 079F 
; 0000 07A0 
; 0000 07A1       case 8:
_0xB7:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xB8
; 0000 07A2 
; 0000 07A3             a[0] = 0x0C0;   //ster1
	LDI  R30,LOW(192)
	LDI  R31,HIGH(192)
	CALL SUBOPT_0x43
; 0000 07A4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 07A5             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 07A6             a[5] = 0x196;   //delta okrag
	RJMP _0x547
; 0000 07A7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07A8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07A9 
; 0000 07AA             a[1] = a[0]+0x001;  //ster2
; 0000 07AB             a[2] = a[4];        //ster4 ABS druciak
; 0000 07AC             a[6] = a[5]+0x001;  //okrag
; 0000 07AD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07AE 
; 0000 07AF     break;
; 0000 07B0 
; 0000 07B1 
; 0000 07B2       case 9:
_0xB8:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xB9
; 0000 07B3 
; 0000 07B4             a[0] = 0x018;   //ster1
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL SUBOPT_0x43
; 0000 07B5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 07B6             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 07B7             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4D
; 0000 07B8             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 07B9             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 07BA 
; 0000 07BB             a[1] = a[0]+0x001;  //ster2
; 0000 07BC             a[2] = a[4];        //ster4 ABS druciak
; 0000 07BD             a[6] = a[5]+0x001;  //okrag
; 0000 07BE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07BF 
; 0000 07C0     break;
; 0000 07C1 
; 0000 07C2 
; 0000 07C3       case 10:
_0xB9:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xBA
; 0000 07C4 
; 0000 07C5             a[0] = 0x016;   //ster1
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CALL SUBOPT_0x43
; 0000 07C6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 07C7             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 07C8             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 07C9             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07CA             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 07CB 
; 0000 07CC             a[1] = a[0]+0x001;  //ster2
; 0000 07CD             a[2] = a[4];        //ster4 ABS druciak
; 0000 07CE             a[6] = a[5]+0x001;  //okrag
; 0000 07CF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07D0 
; 0000 07D1     break;
; 0000 07D2 
; 0000 07D3 
; 0000 07D4       case 11:
_0xBA:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xBB
; 0000 07D5 
; 0000 07D6             a[0] = 0x074;   //ster1
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	CALL SUBOPT_0x43
; 0000 07D7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 07D8             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 07D9             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 07DA             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07DB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 07DC 
; 0000 07DD             a[1] = a[0]+0x001;  //ster2
; 0000 07DE             a[2] = a[4];        //ster4 ABS druciak
; 0000 07DF             a[6] = a[5]+0x001;  //okrag
; 0000 07E0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07E1 
; 0000 07E2     break;
; 0000 07E3 
; 0000 07E4 
; 0000 07E5       case 12:
_0xBB:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xBC
; 0000 07E6 
; 0000 07E7             a[0] = 0x096;   //ster1
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x43
; 0000 07E8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 07E9             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 07EA             a[5] = 0x199;   //delta okrag
	RJMP _0x547
; 0000 07EB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07EC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07ED 
; 0000 07EE             a[1] = a[0]+0x001;  //ster2
; 0000 07EF             a[2] = a[4];        //ster4 ABS druciak
; 0000 07F0             a[6] = a[5]+0x001;  //okrag
; 0000 07F1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07F2 
; 0000 07F3     break;
; 0000 07F4 
; 0000 07F5 
; 0000 07F6       case 13:
_0xBC:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xBD
; 0000 07F7 
; 0000 07F8             a[0] = 0x01A;   //ster1
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	CALL SUBOPT_0x43
; 0000 07F9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 07FA             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 07FB             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4D
; 0000 07FC             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 07FD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07FE 
; 0000 07FF             a[1] = a[0]+0x001;  //ster2
; 0000 0800             a[2] = a[4];        //ster4 ABS druciak
; 0000 0801             a[6] = a[5]+0x001;  //okrag
; 0000 0802             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0803 
; 0000 0804     break;
; 0000 0805 
; 0000 0806 
; 0000 0807       case 14:
_0xBD:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xBE
; 0000 0808 
; 0000 0809             a[0] = 0x05E;   //ster1
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	CALL SUBOPT_0x43
; 0000 080A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 080B             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 080C             a[5] = 0x199;   //delta okrag
	RJMP _0x547
; 0000 080D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 080E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 080F 
; 0000 0810             a[1] = a[0]+0x001;  //ster2
; 0000 0811             a[2] = a[4];        //ster4 ABS druciak
; 0000 0812             a[6] = a[5]+0x001;  //okrag
; 0000 0813             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0814 
; 0000 0815     break;
; 0000 0816 
; 0000 0817 
; 0000 0818       case 15:
_0xBE:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xBF
; 0000 0819 
; 0000 081A             a[0] = 0x084;   //ster1
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	CALL SUBOPT_0x43
; 0000 081B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 081C             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 081D             a[5] = 0x199;   //delta okrag
	RJMP _0x547
; 0000 081E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 081F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0820 
; 0000 0821             a[1] = a[0]+0x001;  //ster2
; 0000 0822             a[2] = a[4];        //ster4 ABS druciak
; 0000 0823             a[6] = a[5]+0x001;  //okrag
; 0000 0824             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0825 
; 0000 0826     break;
; 0000 0827 
; 0000 0828 
; 0000 0829       case 16:
_0xBF:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xC0
; 0000 082A 
; 0000 082B             a[0] = 0x0B8;   //ster1
	LDI  R30,LOW(184)
	LDI  R31,HIGH(184)
	CALL SUBOPT_0x43
; 0000 082C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 082D             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 082E             a[5] = 0x199;   //delta okrag
; 0000 082F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0830             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0831 
; 0000 0832             a[1] = a[0]+0x001;  //ster2
; 0000 0833             a[2] = a[4];        //ster4 ABS druciak
; 0000 0834             a[6] = a[5]+0x001;  //okrag
; 0000 0835             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0836 
; 0000 0837     break;
; 0000 0838 
; 0000 0839       case 17:
_0xC0:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xC1
; 0000 083A 
; 0000 083B             a[0] = 0x020;   //ster1
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x43
; 0000 083C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 083D             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 083E             a[5] = 0x196;   //delta okrag
; 0000 083F             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0840             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0841 
; 0000 0842             a[1] = a[0]+0x001;  //ster2
; 0000 0843             a[2] = a[4];        //ster4 ABS druciak
; 0000 0844             a[6] = a[5]+0x001;  //okrag
; 0000 0845             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0846 
; 0000 0847     break;
; 0000 0848 
; 0000 0849 
; 0000 084A       case 18:
_0xC1:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xC2
; 0000 084B 
; 0000 084C             a[0] = 0x098;   //ster1
	LDI  R30,LOW(152)
	LDI  R31,HIGH(152)
	CALL SUBOPT_0x43
; 0000 084D             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 084E             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x52
; 0000 084F             a[5] = 0x190;   //delta okrag
; 0000 0850             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x46
; 0000 0851             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x48
	RJMP _0x546
; 0000 0852 
; 0000 0853             a[1] = a[0]+0x001;  //ster2
; 0000 0854             a[2] = a[4];        //ster4 ABS druciak
; 0000 0855             a[6] = a[5]+0x001;  //okrag
; 0000 0856             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0857 
; 0000 0858     break;
; 0000 0859 
; 0000 085A 
; 0000 085B 
; 0000 085C       case 19:
_0xC2:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xC3
; 0000 085D 
; 0000 085E             a[0] = 0x0AA;   //ster1
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	CALL SUBOPT_0x43
; 0000 085F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0860             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0861             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x54
; 0000 0862             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0863             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0864 
; 0000 0865             a[1] = a[0]+0x001;  //ster2
; 0000 0866             a[2] = a[4];        //ster4 ABS druciak
; 0000 0867             a[6] = a[5]+0x001;  //okrag
; 0000 0868             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0869 
; 0000 086A     break;
; 0000 086B 
; 0000 086C 
; 0000 086D       case 20:
_0xC3:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0xC4
; 0000 086E 
; 0000 086F             a[0] = 0x042;   //ster1
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	CALL SUBOPT_0x43
; 0000 0870             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0871             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0872             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x55
; 0000 0873             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0874             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0875 
; 0000 0876             a[1] = a[0]+0x001;  //ster2
; 0000 0877             a[2] = a[4];        //ster4 ABS druciak
; 0000 0878             a[6] = a[5]+0x001;  //okrag
; 0000 0879             a[8] = a[6]+0x001;  //-delta okrag
; 0000 087A 
; 0000 087B     break;
; 0000 087C 
; 0000 087D 
; 0000 087E       case 21:
_0xC4:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0xC5
; 0000 087F 
; 0000 0880             a[0] = 0x04E;   //ster1
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	CALL SUBOPT_0x43
; 0000 0881             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0882             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0883             a[5] = 0x196;   //delta okrag
; 0000 0884             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0885             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0886 
; 0000 0887             a[1] = a[0]+0x001;  //ster2
; 0000 0888             a[2] = a[4];        //ster4 ABS druciak
; 0000 0889             a[6] = a[5]+0x001;  //okrag
; 0000 088A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 088B 
; 0000 088C     break;
; 0000 088D 
; 0000 088E       case 22:
_0xC5:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0xC6
; 0000 088F 
; 0000 0890             a[0] = 0x0C2;   //ster1
	LDI  R30,LOW(194)
	LDI  R31,HIGH(194)
	CALL SUBOPT_0x43
; 0000 0891             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 0892             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x52
; 0000 0893             a[5] = 0x190;   //delta okrag
; 0000 0894             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x545
; 0000 0895             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0896 
; 0000 0897             a[1] = a[0]+0x001;  //ster2
; 0000 0898             a[2] = a[4];        //ster4 ABS druciak
; 0000 0899             a[6] = a[5]+0x001;  //okrag
; 0000 089A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 089B 
; 0000 089C     break;
; 0000 089D 
; 0000 089E 
; 0000 089F       case 23:
_0xC6:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0xC7
; 0000 08A0 
; 0000 08A1             a[0] = 0x0CE;   //ster1
	LDI  R30,LOW(206)
	LDI  R31,HIGH(206)
	CALL SUBOPT_0x43
; 0000 08A2             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 08A3             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 08A4             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x547
; 0000 08A5             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08A6             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08A7 
; 0000 08A8             a[1] = a[0]+0x001;  //ster2
; 0000 08A9             a[2] = a[4];        //ster4 ABS druciak
; 0000 08AA             a[6] = a[5]+0x001;  //okrag
; 0000 08AB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08AC 
; 0000 08AD     break;
; 0000 08AE 
; 0000 08AF 
; 0000 08B0       case 24:
_0xC7:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0xC8
; 0000 08B1 
; 0000 08B2             a[0] = 0x040;   //ster1
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL SUBOPT_0x43
; 0000 08B3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 08B4             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 08B5             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x55
; 0000 08B6             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 08B7             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08B8 
; 0000 08B9             a[1] = a[0]+0x001;  //ster2
; 0000 08BA             a[2] = a[4];        //ster4 ABS druciak
; 0000 08BB             a[6] = a[5]+0x001;  //okrag
; 0000 08BC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08BD 
; 0000 08BE     break;
; 0000 08BF 
; 0000 08C0       case 25:
_0xC8:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0xC9
; 0000 08C1 
; 0000 08C2             a[0] = 0x02E;   //ster1
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	CALL SUBOPT_0x43
; 0000 08C3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 08C4             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 08C5             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 08C6             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08C7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 08C8 
; 0000 08C9             a[1] = a[0]+0x001;  //ster2
; 0000 08CA             a[2] = a[4];        //ster4 ABS druciak
; 0000 08CB             a[6] = a[5]+0x001;  //okrag
; 0000 08CC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08CD 
; 0000 08CE     break;
; 0000 08CF 
; 0000 08D0       case 26:
_0xC9:
	CPI  R30,LOW(0x1A)
	LDI  R26,HIGH(0x1A)
	CPC  R31,R26
	BRNE _0xCA
; 0000 08D1 
; 0000 08D2             a[0] = 0x0FA;   //ster1
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x43
; 0000 08D3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 08D4             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 08D5             a[5] = 0x190;   //delta okrag
; 0000 08D6             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 08D7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 08D8 
; 0000 08D9             a[1] = a[0]+0x001;  //ster2
; 0000 08DA             a[2] = a[4];        //ster4 ABS druciak
; 0000 08DB             a[6] = a[5]+0x001;  //okrag
; 0000 08DC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08DD 
; 0000 08DE     break;
; 0000 08DF 
; 0000 08E0 
; 0000 08E1       case 27:
_0xCA:
	CPI  R30,LOW(0x1B)
	LDI  R26,HIGH(0x1B)
	CPC  R31,R26
	BRNE _0xCB
; 0000 08E2 
; 0000 08E3             a[0] = 0x06C;   //ster1
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	CALL SUBOPT_0x43
; 0000 08E4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 08E5             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 08E6             a[5] = 0x199;   //delta okrag
; 0000 08E7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08E8             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 08E9 
; 0000 08EA             a[1] = a[0]+0x001;  //ster2
; 0000 08EB             a[2] = a[4];        //ster4 ABS druciak
; 0000 08EC             a[6] = a[5]+0x001;  //okrag
; 0000 08ED             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08EE 
; 0000 08EF     break;
; 0000 08F0 
; 0000 08F1 
; 0000 08F2       case 28:
_0xCB:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BRNE _0xCC
; 0000 08F3 
; 0000 08F4             a[0] = 0x0A4;   //ster1
	LDI  R30,LOW(164)
	LDI  R31,HIGH(164)
	CALL SUBOPT_0x43
; 0000 08F5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 08F6             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 08F7             a[5] = 0x199;   //delta okrag
	RJMP _0x547
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
; 0000 0902       case 29:
_0xCC:
	CPI  R30,LOW(0x1D)
	LDI  R26,HIGH(0x1D)
	CPC  R31,R26
	BRNE _0xCD
; 0000 0903 
; 0000 0904             a[0] = 0x02A;   //ster1
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	CALL SUBOPT_0x43
; 0000 0905             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0906             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 0907             a[5] = 0x199;   //delta okrag
	RJMP _0x547
; 0000 0908             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0909             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 090A 
; 0000 090B             a[1] = a[0]+0x001;  //ster2
; 0000 090C             a[2] = a[4];        //ster4 ABS druciak
; 0000 090D             a[6] = a[5]+0x001;  //okrag
; 0000 090E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 090F 
; 0000 0910 
; 0000 0911 
; 0000 0912 
; 0000 0913 
; 0000 0914     break;
; 0000 0915 
; 0000 0916       case 30:
_0xCD:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0xCE
; 0000 0917 
; 0000 0918             a[0] = 0x094;   //ster1
	LDI  R30,LOW(148)
	LDI  R31,HIGH(148)
	CALL SUBOPT_0x43
; 0000 0919             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 091A             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 091B             a[5] = 0x190;   //delta okrag
; 0000 091C             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 091D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 091E 
; 0000 091F             a[1] = a[0]+0x001;  //ster2
; 0000 0920             a[2] = a[4];        //ster4 ABS druciak
; 0000 0921             a[6] = a[5]+0x001;  //okrag
; 0000 0922             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0923 
; 0000 0924     break;
; 0000 0925 
; 0000 0926       case 31:
_0xCE:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0xCF
; 0000 0927 
; 0000 0928             a[0] = 0x06E;   //ster1
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	CALL SUBOPT_0x43
; 0000 0929             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 092A             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 092B             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x547
; 0000 092C             a[7] = 0x12;  //ster3 INV krazek scierny
; 0000 092D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 092E 
; 0000 092F             a[1] = a[0]+0x001;  //ster2
; 0000 0930             a[2] = a[4];        //ster4 ABS druciak
; 0000 0931             a[6] = a[5]+0x001;  //okrag
; 0000 0932             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0933 
; 0000 0934     break;
; 0000 0935 
; 0000 0936 
; 0000 0937        case 32:
_0xCF:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xD0
; 0000 0938 
; 0000 0939             a[0] = 0x086;   //ster1
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	CALL SUBOPT_0x43
; 0000 093A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 093B             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 093C             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 093D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 093E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 093F 
; 0000 0940             a[1] = a[0]+0x001;  //ster2
; 0000 0941             a[2] = a[4];        //ster4 ABS druciak
; 0000 0942             a[6] = a[5]+0x001;  //okrag
; 0000 0943             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0944 
; 0000 0945     break;
; 0000 0946 
; 0000 0947        case 33:
_0xD0:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0xD1
; 0000 0948 
; 0000 0949             a[0] = 0x08E;   //ster1
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	CALL SUBOPT_0x43
; 0000 094A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 094B             a[4] = 0x20;    //ster3 ABS krazek scierny
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	RJMP _0x548
; 0000 094C             a[5] = 0x19C;   //delta okrag
; 0000 094D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 094E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 094F 
; 0000 0950             a[1] = a[0]+0x001;  //ster2
; 0000 0951             a[2] = a[4];        //ster4 ABS druciak
; 0000 0952             a[6] = a[5]+0x001;  //okrag
; 0000 0953             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0954 
; 0000 0955     break;
; 0000 0956 
; 0000 0957 
; 0000 0958     case 34: //86-1349
_0xD1:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0xD2
; 0000 0959 
; 0000 095A             a[0] = 0x05A;   //ster1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x43
; 0000 095B             a[3] = 0x11- 0x01;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 095C             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 095D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 095E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 095F             a[9] = 0;       //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0960 
; 0000 0961             a[1] = a[0]+0x001;  //ster2
; 0000 0962             a[2] = a[4];        //ster4 ABS druciak
; 0000 0963             a[6] = a[5]+0x001;  //okrag
; 0000 0964             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0965 
; 0000 0966     break;
; 0000 0967 
; 0000 0968 
; 0000 0969     case 35:
_0xD2:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0xD3
; 0000 096A 
; 0000 096B             a[0] = 0x0DA;   //ster1
	LDI  R30,LOW(218)
	LDI  R31,HIGH(218)
	CALL SUBOPT_0x43
; 0000 096C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 096D             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 096E             a[5] = 0x190;   //delta okrag
; 0000 096F             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0970             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0971 
; 0000 0972             a[1] = a[0]+0x001;  //ster2
; 0000 0973             a[2] = a[4];        //ster4 ABS druciak
; 0000 0974             a[6] = a[5]+0x001;  //okrag
; 0000 0975             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0976 
; 0000 0977     break;
; 0000 0978 
; 0000 0979          case 36:
_0xD3:
	CPI  R30,LOW(0x24)
	LDI  R26,HIGH(0x24)
	CPC  R31,R26
	BRNE _0xD4
; 0000 097A 
; 0000 097B             a[0] = 0x0A2;   //ster1
	LDI  R30,LOW(162)
	LDI  R31,HIGH(162)
	CALL SUBOPT_0x43
; 0000 097C             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x5A
; 0000 097D             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 097E             a[5] = 0x196;   //delta okrag
; 0000 097F             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x46
; 0000 0980             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x48
	RJMP _0x546
; 0000 0981 
; 0000 0982             a[1] = a[0]+0x001;  //ster2
; 0000 0983             a[2] = a[4];        //ster4 ABS druciak
; 0000 0984             a[6] = a[5]+0x001;  //okrag
; 0000 0985             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0986 
; 0000 0987     break;
; 0000 0988 
; 0000 0989          case 37:
_0xD4:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0xD5
; 0000 098A 
; 0000 098B             a[0] = 0x104;   //ster1
	LDI  R30,LOW(260)
	LDI  R31,HIGH(260)
	CALL SUBOPT_0x43
; 0000 098C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 098D             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 098E             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x5C
; 0000 098F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0990             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0991 
; 0000 0992             a[1] = a[0]+0x001;  //ster2
; 0000 0993             a[2] = a[4];        //ster4 ABS druciak
; 0000 0994             a[6] = a[5]+0x001;  //okrag
; 0000 0995             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0996 
; 0000 0997     break;
; 0000 0998 
; 0000 0999          case 38:
_0xD5:
	CPI  R30,LOW(0x26)
	LDI  R26,HIGH(0x26)
	CPC  R31,R26
	BRNE _0xD6
; 0000 099A 
; 0000 099B             a[0] = 0x036;   //ster1
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	CALL SUBOPT_0x43
; 0000 099C             a[3] = 0x11 - 0x01;    //ster4 INV druciak  //korekta
	CALL SUBOPT_0x46
; 0000 099D             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 099E             a[5] = 0x196;   //delta okrag
	RJMP _0x547
; 0000 099F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 09A0             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09A1 
; 0000 09A2             a[1] = a[0]+0x001;  //ster2
; 0000 09A3             a[2] = a[4];        //ster4 ABS druciak
; 0000 09A4             a[6] = a[5]+0x001;  //okrag
; 0000 09A5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09A6 
; 0000 09A7     break;
; 0000 09A8 
; 0000 09A9 
; 0000 09AA          case 39:
_0xD6:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0xD7
; 0000 09AB 
; 0000 09AC             a[0] = 0x118;   //ster1
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	CALL SUBOPT_0x43
; 0000 09AD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 09AE             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 09AF             a[5] = 0x190;   //delta okrag
; 0000 09B0             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 09B1             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09B2 
; 0000 09B3             a[1] = a[0]+0x001;  //ster2
; 0000 09B4             a[2] = a[4];        //ster4 ABS druciak
; 0000 09B5             a[6] = a[5]+0x001;  //okrag
; 0000 09B6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09B7 
; 0000 09B8     break;
; 0000 09B9 
; 0000 09BA 
; 0000 09BB          case 40:
_0xD7:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0xD8
; 0000 09BC 
; 0000 09BD             a[0] = 0x0A6;   //ster1
	LDI  R30,LOW(166)
	LDI  R31,HIGH(166)
	CALL SUBOPT_0x43
; 0000 09BE             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x5A
; 0000 09BF             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 09C0             a[5] = 0x196;   //delta okrag
; 0000 09C1             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x545
; 0000 09C2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09C3 
; 0000 09C4             a[1] = a[0]+0x001;  //ster2
; 0000 09C5             a[2] = a[4];        //ster4 ABS druciak
; 0000 09C6             a[6] = a[5]+0x001;  //okrag
; 0000 09C7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09C8 
; 0000 09C9     break;
; 0000 09CA 
; 0000 09CB          case 41:
_0xD8:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0xD9
; 0000 09CC 
; 0000 09CD             a[0] = 0x01E;   //ster1
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x43
; 0000 09CE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 09CF             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 09D0             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4D
; 0000 09D1             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
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
; 0000 09DC          case 42:
_0xD9:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0xDA
; 0000 09DD 
; 0000 09DE             a[0] = 0x05C;   //ster1
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x43
; 0000 09DF             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 09E0             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5D
; 0000 09E1             a[5] = 0x196;   //delta okrag
; 0000 09E2             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 09E3             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 09E4 
; 0000 09E5             a[1] = a[0]+0x001;  //ster2
; 0000 09E6             a[2] = a[4];        //ster4 ABS druciak
; 0000 09E7             a[6] = a[5]+0x001;  //okrag
; 0000 09E8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09E9 
; 0000 09EA     break;
; 0000 09EB 
; 0000 09EC 
; 0000 09ED          case 43:
_0xDA:
	CPI  R30,LOW(0x2B)
	LDI  R26,HIGH(0x2B)
	CPC  R31,R26
	BRNE _0xDB
; 0000 09EE 
; 0000 09EF             a[0] = 0x062;   //ster1
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL SUBOPT_0x43
; 0000 09F0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 09F1             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 09F2             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 09F3             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 09F4             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 09F5 
; 0000 09F6             a[1] = a[0]+0x001;  //ster2
; 0000 09F7             a[2] = a[4];        //ster4 ABS druciak
; 0000 09F8             a[6] = a[5]+0x001;  //okrag
; 0000 09F9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09FA 
; 0000 09FB     break;
; 0000 09FC 
; 0000 09FD 
; 0000 09FE          case 44:
_0xDB:
	CPI  R30,LOW(0x2C)
	LDI  R26,HIGH(0x2C)
	CPC  R31,R26
	BRNE _0xDC
; 0000 09FF 
; 0000 0A00             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5F
; 0000 0A01             a[3] = 0x;    //ster4 INV druciak
; 0000 0A02             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0A03             a[5] = 0x;   //delta okrag
; 0000 0A04             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0A05             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0A06 
; 0000 0A07             a[1] = a[0]+0x001;  //ster2
; 0000 0A08             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A09             a[6] = a[5]+0x001;  //okrag
; 0000 0A0A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A0B 
; 0000 0A0C     break;
; 0000 0A0D 
; 0000 0A0E 
; 0000 0A0F          case 45:
_0xDC:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0xDD
; 0000 0A10 
; 0000 0A11             a[0] = 0x010;   //ster1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x43
; 0000 0A12             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0A13             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0A14             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4D
; 0000 0A15             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0A16             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0A17 
; 0000 0A18             a[1] = a[0]+0x001;  //ster2
; 0000 0A19             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A1A             a[6] = a[5]+0x001;  //okrag
; 0000 0A1B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A1C 
; 0000 0A1D     break;
; 0000 0A1E 
; 0000 0A1F 
; 0000 0A20     case 46:
_0xDD:
	CPI  R30,LOW(0x2E)
	LDI  R26,HIGH(0x2E)
	CPC  R31,R26
	BRNE _0xDE
; 0000 0A21 
; 0000 0A22             a[0] = 0x050;   //ster1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x43
; 0000 0A23             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 0A24             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5D
; 0000 0A25             a[5] = 0x196;   //delta okrag
; 0000 0A26             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0A27             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A28 
; 0000 0A29             a[1] = a[0]+0x001;  //ster2
; 0000 0A2A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A2B             a[6] = a[5]+0x001;  //okrag
; 0000 0A2C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A2D 
; 0000 0A2E     break;
; 0000 0A2F 
; 0000 0A30 
; 0000 0A31     case 47:
_0xDE:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BRNE _0xDF
; 0000 0A32 
; 0000 0A33             a[0] = 0x068;   //ster1
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	CALL SUBOPT_0x43
; 0000 0A34             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0A35             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0A36             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x547
; 0000 0A37             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A38             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A39 
; 0000 0A3A             a[1] = a[0]+0x001;  //ster2
; 0000 0A3B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A3C             a[6] = a[5]+0x001;  //okrag
; 0000 0A3D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A3E 
; 0000 0A3F     break;
; 0000 0A40 
; 0000 0A41 
; 0000 0A42 
; 0000 0A43     case 48:
_0xDF:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0xE0
; 0000 0A44 
; 0000 0A45             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5F
; 0000 0A46             a[3] = 0x;    //ster4 INV druciak
; 0000 0A47             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0A48             a[5] = 0x;   //delta okrag
; 0000 0A49             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0A4A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0A4B 
; 0000 0A4C             a[1] = a[0]+0x001;  //ster2
; 0000 0A4D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A4E             a[6] = a[5]+0x001;  //okrag
; 0000 0A4F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A50 
; 0000 0A51     break;
; 0000 0A52 
; 0000 0A53 
; 0000 0A54     case 49:
_0xE0:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xE1
; 0000 0A55 
; 0000 0A56             a[0] = 0x024;   //ster1
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL SUBOPT_0x43
; 0000 0A57             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0A58             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0A59             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0A5A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A5B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0A5C 
; 0000 0A5D             a[1] = a[0]+0x001;  //ster2
; 0000 0A5E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A5F             a[6] = a[5]+0x001;  //okrag
; 0000 0A60             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A61 
; 0000 0A62     break;
; 0000 0A63 
; 0000 0A64 
; 0000 0A65     case 50:
_0xE1:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0xE2
; 0000 0A66 
; 0000 0A67             a[0] = 0x014;   //ster1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x43
; 0000 0A68             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0A69             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0A6A             a[5] = 0x190;   //delta okrag
; 0000 0A6B             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0A6C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0A6D 
; 0000 0A6E             a[1] = a[0]+0x001;  //ster2
; 0000 0A6F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A70             a[6] = a[5]+0x001;  //okrag
; 0000 0A71             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A72 
; 0000 0A73     break;
; 0000 0A74 
; 0000 0A75     case 51:
_0xE2:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0xE3
; 0000 0A76 
; 0000 0A77             a[0] = 0x082;   //ster1
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	CALL SUBOPT_0x43
; 0000 0A78             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0A79             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x60
; 0000 0A7A             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x5C
; 0000 0A7B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A7C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0A7D 
; 0000 0A7E             a[1] = a[0]+0x001;  //ster2
; 0000 0A7F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A80             a[6] = a[5]+0x001;  //okrag
; 0000 0A81             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A82 
; 0000 0A83     break;
; 0000 0A84 
; 0000 0A85     case 52:
_0xE3:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0xE4
; 0000 0A86 
; 0000 0A87             a[0] = 0x106;   //ster1
	LDI  R30,LOW(262)
	LDI  R31,HIGH(262)
	CALL SUBOPT_0x43
; 0000 0A88             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0A89             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x61
; 0000 0A8A             a[5] = 0x190;   //delta okrag
; 0000 0A8B             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0A8C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A8D 
; 0000 0A8E             a[1] = a[0]+0x001;  //ster2
; 0000 0A8F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A90             a[6] = a[5]+0x001;  //okrag
; 0000 0A91             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A92 
; 0000 0A93     break;
; 0000 0A94 
; 0000 0A95 
; 0000 0A96     case 53:
_0xE4:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0xE5
; 0000 0A97 
; 0000 0A98             a[0] = 0x04C;   //ster1
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x43
; 0000 0A99             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0A9A             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0A9B             a[5] = 0x196;   //delta okrag
	RJMP _0x547
; 0000 0A9C             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A9D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A9E 
; 0000 0A9F             a[1] = a[0]+0x001;  //ster2
; 0000 0AA0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AA1             a[6] = a[5]+0x001;  //okrag
; 0000 0AA2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AA3 
; 0000 0AA4     break;
; 0000 0AA5 
; 0000 0AA6 
; 0000 0AA7     case 54:
_0xE5:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0xE6
; 0000 0AA8 
; 0000 0AA9             a[0] = 0x01C;   //ster1
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	CALL SUBOPT_0x43
; 0000 0AAA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0AAB             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0AAC             a[5] = 0x190;   //delta okrag
; 0000 0AAD             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0AAE             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AAF 
; 0000 0AB0             a[1] = a[0]+0x001;  //ster2
; 0000 0AB1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AB2             a[6] = a[5]+0x001;  //okrag
; 0000 0AB3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AB4 
; 0000 0AB5     break;
; 0000 0AB6 
; 0000 0AB7     case 55:
_0xE6:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0xE7
; 0000 0AB8 
; 0000 0AB9             a[0] = 0x114;   //ster1
	LDI  R30,LOW(276)
	LDI  R31,HIGH(276)
	CALL SUBOPT_0x43
; 0000 0ABA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0ABB             a[4] = 0x1A;    //ster3 ABS krazek scierny
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	RJMP _0x548
; 0000 0ABC             a[5] = 0x19C;   //delta okrag
; 0000 0ABD             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0ABE             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0ABF 
; 0000 0AC0             a[1] = a[0]+0x001;  //ster2
; 0000 0AC1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AC2             a[6] = a[5]+0x001;  //okrag
; 0000 0AC3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AC4 
; 0000 0AC5     break;
; 0000 0AC6 
; 0000 0AC7 
; 0000 0AC8     case 56:
_0xE7:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0xE8
; 0000 0AC9 
; 0000 0ACA             a[0] = 0x0EE;   //ster1
	LDI  R30,LOW(238)
	LDI  R31,HIGH(238)
	CALL SUBOPT_0x43
; 0000 0ACB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0ACC             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x61
; 0000 0ACD             a[5] = 0x190;   //delta okrag
; 0000 0ACE             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0ACF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0AD0 
; 0000 0AD1             a[1] = a[0]+0x001;  //ster2
; 0000 0AD2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AD3             a[6] = a[5]+0x001;  //okrag
; 0000 0AD4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AD5 
; 0000 0AD6     break;
; 0000 0AD7 
; 0000 0AD8 
; 0000 0AD9     case 57:
_0xE8:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0xE9
; 0000 0ADA 
; 0000 0ADB             a[0] = 0x0F8;   //ster1
	LDI  R30,LOW(248)
	LDI  R31,HIGH(248)
	CALL SUBOPT_0x43
; 0000 0ADC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0ADD             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0ADE             a[5] = 0x190;   //delta okrag
; 0000 0ADF             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0AE0             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0AE1 
; 0000 0AE2             a[1] = a[0]+0x001;  //ster2
; 0000 0AE3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AE4             a[6] = a[5]+0x001;  //okrag
; 0000 0AE5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AE6 
; 0000 0AE7     break;
; 0000 0AE8 
; 0000 0AE9 
; 0000 0AEA     case 58:
_0xE9:
	CPI  R30,LOW(0x3A)
	LDI  R26,HIGH(0x3A)
	CPC  R31,R26
	BRNE _0xEA
; 0000 0AEB 
; 0000 0AEC             a[0] = 0x0E4;   //ster1
	LDI  R30,LOW(228)
	LDI  R31,HIGH(228)
	CALL SUBOPT_0x43
; 0000 0AED             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0AEE             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0AEF             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0AF0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AF1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0AF2 
; 0000 0AF3             a[1] = a[0]+0x001;  //ster2
; 0000 0AF4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AF5             a[6] = a[5]+0x001;  //okrag
; 0000 0AF6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AF7 
; 0000 0AF8     break;
; 0000 0AF9 
; 0000 0AFA 
; 0000 0AFB     case 59:
_0xEA:
	CPI  R30,LOW(0x3B)
	LDI  R26,HIGH(0x3B)
	CPC  R31,R26
	BRNE _0xEB
; 0000 0AFC 
; 0000 0AFD             a[0] = 0x052;   //ster1
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	CALL SUBOPT_0x43
; 0000 0AFE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0AFF             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0B00             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x54
; 0000 0B01             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B02             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0B03 
; 0000 0B04             a[1] = a[0]+0x001;  //ster2
; 0000 0B05             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B06             a[6] = a[5]+0x001;  //okrag
; 0000 0B07             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B08 
; 0000 0B09     break;
; 0000 0B0A 
; 0000 0B0B 
; 0000 0B0C     case 60:
_0xEB:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BRNE _0xEC
; 0000 0B0D 
; 0000 0B0E             a[0] = 0x090;   //ster1
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0x43
; 0000 0B0F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0B10             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x64
; 0000 0B11             a[5] = 0x190;   //delta okrag
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL SUBOPT_0x4D
; 0000 0B12             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0B13             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0B14 
; 0000 0B15             a[1] = a[0]+0x001;  //ster2
; 0000 0B16             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B17             a[6] = a[5]+0x001;  //okrag
; 0000 0B18             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B19 
; 0000 0B1A     break;
; 0000 0B1B 
; 0000 0B1C 
; 0000 0B1D     case 61:
_0xEC:
	CPI  R30,LOW(0x3D)
	LDI  R26,HIGH(0x3D)
	CPC  R31,R26
	BRNE _0xED
; 0000 0B1E 
; 0000 0B1F             a[0] = 0x0FC;   //ster1
	LDI  R30,LOW(252)
	LDI  R31,HIGH(252)
	CALL SUBOPT_0x43
; 0000 0B20             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0B21             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 0B22             a[5] = 0x190;   //delta okrag
; 0000 0B23             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
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
; 0000 0B2E     case 62:
_0xED:
	CPI  R30,LOW(0x3E)
	LDI  R26,HIGH(0x3E)
	CPC  R31,R26
	BRNE _0xEE
; 0000 0B2F 
; 0000 0B30             a[0] = 0x028;   //ster1
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x43
; 0000 0B31             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0B32             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0B33             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x547
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
; 0000 0B3F     case 63:
_0xEE:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0xEF
; 0000 0B40 
; 0000 0B41             a[0] = 0x034;   //ster1
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	CALL SUBOPT_0x43
; 0000 0B42             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0B43             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0B44             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x547
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
; 0000 0B50     case 64:
_0xEF:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0xF0
; 0000 0B51 
; 0000 0B52             a[0] = 0x0EC;   //ster1
	LDI  R30,LOW(236)
	LDI  R31,HIGH(236)
	CALL SUBOPT_0x43
; 0000 0B53             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0B54             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0B55             a[5] = 0x190;   //delta okrag
; 0000 0B56             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
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
; 0000 0B61     case 65:
_0xF0:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0xF1
; 0000 0B62 
; 0000 0B63             a[0] = 0x0CC;   //ster1
	LDI  R30,LOW(204)
	LDI  R31,HIGH(204)
	CALL SUBOPT_0x43
; 0000 0B64             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0B65             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x65
; 0000 0B66             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0B67             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B68             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0B69 
; 0000 0B6A             a[1] = a[0]+0x001;  //ster2
; 0000 0B6B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B6C             a[6] = a[5]+0x001;  //okrag
; 0000 0B6D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B6E 
; 0000 0B6F     break;
; 0000 0B70 
; 0000 0B71 
; 0000 0B72     case 66:
_0xF1:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0xF2
; 0000 0B73 
; 0000 0B74             a[0] = 0x0BC;   //ster1
	LDI  R30,LOW(188)
	LDI  R31,HIGH(188)
	CALL SUBOPT_0x43
; 0000 0B75             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0B76             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0B77             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0B78             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0B79             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B7A 
; 0000 0B7B             a[1] = a[0]+0x001;  //ster2
; 0000 0B7C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B7D             a[6] = a[5]+0x001;  //okrag
; 0000 0B7E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B7F 
; 0000 0B80     break;
; 0000 0B81 
; 0000 0B82 
; 0000 0B83     case 67:
_0xF2:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xF3
; 0000 0B84 
; 0000 0B85             a[0] = 0x09C;   //ster1
	LDI  R30,LOW(156)
	LDI  R31,HIGH(156)
	CALL SUBOPT_0x43
; 0000 0B86             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0B87             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0B88             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x547
; 0000 0B89             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B8A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B8B 
; 0000 0B8C             a[1] = a[0]+0x001;  //ster2
; 0000 0B8D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B8E             a[6] = a[5]+0x001;  //okrag
; 0000 0B8F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B90 
; 0000 0B91     break;
; 0000 0B92 
; 0000 0B93 
; 0000 0B94     case 68:
_0xF3:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0xF4
; 0000 0B95 
; 0000 0B96             a[0] = 0x07C;   //ster1
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	CALL SUBOPT_0x43
; 0000 0B97             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0B98             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0B99             a[5] = 0x199;   //delta okrag
	RJMP _0x547
; 0000 0B9A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B9B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B9C 
; 0000 0B9D             a[1] = a[0]+0x001;  //ster2
; 0000 0B9E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B9F             a[6] = a[5]+0x001;  //okrag
; 0000 0BA0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BA1 
; 0000 0BA2     break;
; 0000 0BA3 
; 0000 0BA4 
; 0000 0BA5     case 69:
_0xF4:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BRNE _0xF5
; 0000 0BA6 
; 0000 0BA7             a[0] = 0x0D2;   //ster1
	LDI  R30,LOW(210)
	LDI  R31,HIGH(210)
	CALL SUBOPT_0x43
; 0000 0BA8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0BA9             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x65
; 0000 0BAA             a[5] = 0x193;   //delta okrag
	RJMP _0x547
; 0000 0BAB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BAC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0BAD 
; 0000 0BAE             a[1] = a[0]+0x001;  //ster2
; 0000 0BAF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BB0             a[6] = a[5]+0x001;  //okrag
; 0000 0BB1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BB2 
; 0000 0BB3     break;
; 0000 0BB4 
; 0000 0BB5 
; 0000 0BB6     case 70:
_0xF5:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BRNE _0xF6
; 0000 0BB7 
; 0000 0BB8             a[0] = 0x0E6;   //ster1
	LDI  R30,LOW(230)
	LDI  R31,HIGH(230)
	CALL SUBOPT_0x43
; 0000 0BB9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0BBA             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0BBB             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0BBC             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0BBD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0BBE 
; 0000 0BBF             a[1] = a[0]+0x001;  //ster2
; 0000 0BC0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BC1             a[6] = a[5]+0x001;  //okrag
; 0000 0BC2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BC3 
; 0000 0BC4     break;
; 0000 0BC5 
; 0000 0BC6 
; 0000 0BC7     case 71:
_0xF6:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BRNE _0xF7
; 0000 0BC8 
; 0000 0BC9             a[0] = 0x0B4;   //ster1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x43
; 0000 0BCA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0BCB             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0BCC             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0BCD             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BCE             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0BCF 
; 0000 0BD0             a[1] = a[0]+0x001;  //ster2
; 0000 0BD1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BD2             a[6] = a[5]+0x001;  //okrag
; 0000 0BD3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BD4 
; 0000 0BD5     break;
; 0000 0BD6 
; 0000 0BD7 
; 0000 0BD8     case 72:
_0xF7:
	CPI  R30,LOW(0x48)
	LDI  R26,HIGH(0x48)
	CPC  R31,R26
	BRNE _0xF8
; 0000 0BD9 
; 0000 0BDA             a[0] = 0x0AC;   //ster1
	LDI  R30,LOW(172)
	LDI  R31,HIGH(172)
	CALL SUBOPT_0x43
; 0000 0BDB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0BDC             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0BDD             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0BDE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BDF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0BE0 
; 0000 0BE1             a[1] = a[0]+0x001;  //ster2
; 0000 0BE2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BE3             a[6] = a[5]+0x001;  //okrag
; 0000 0BE4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BE5 
; 0000 0BE6     break;
; 0000 0BE7 
; 0000 0BE8 
; 0000 0BE9     case 73:
_0xF8:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BRNE _0xF9
; 0000 0BEA 
; 0000 0BEB             a[0] = 0x012;   //ster1
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CALL SUBOPT_0x43
; 0000 0BEC             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 0BED             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x60
; 0000 0BEE             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0BEF             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BF0             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0BF1 
; 0000 0BF2             a[1] = a[0]+0x001;  //ster2
; 0000 0BF3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BF4             a[6] = a[5]+0x001;  //okrag
; 0000 0BF5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BF6 
; 0000 0BF7     break;
; 0000 0BF8 
; 0000 0BF9 
; 0000 0BFA     case 74:
_0xF9:
	CPI  R30,LOW(0x4A)
	LDI  R26,HIGH(0x4A)
	CPC  R31,R26
	BRNE _0xFA
; 0000 0BFB 
; 0000 0BFC             a[0] = 0x0B2;   //ster1
	LDI  R30,LOW(178)
	LDI  R31,HIGH(178)
	CALL SUBOPT_0x43
; 0000 0BFD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0BFE             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0BFF             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0C00             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C01             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0C02 
; 0000 0C03             a[1] = a[0]+0x001;  //ster2
; 0000 0C04             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C05             a[6] = a[5]+0x001;  //okrag
; 0000 0C06             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C07 
; 0000 0C08     break;
; 0000 0C09 
; 0000 0C0A 
; 0000 0C0B     case 75:
_0xFA:
	CPI  R30,LOW(0x4B)
	LDI  R26,HIGH(0x4B)
	CPC  R31,R26
	BRNE _0xFB
; 0000 0C0C 
; 0000 0C0D             a[0] = 0x10C;   //ster1
	LDI  R30,LOW(268)
	LDI  R31,HIGH(268)
	CALL SUBOPT_0x43
; 0000 0C0E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0C0F             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0C10             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0C11             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C12             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0C13 
; 0000 0C14             a[1] = a[0]+0x001;  //ster2
; 0000 0C15             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C16             a[6] = a[5]+0x001;  //okrag
; 0000 0C17             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C18 
; 0000 0C19     break;
; 0000 0C1A 
; 0000 0C1B 
; 0000 0C1C     case 76:
_0xFB:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0xFC
; 0000 0C1D 
; 0000 0C1E             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5F
; 0000 0C1F             a[3] = 0x;    //ster4 INV druciak
; 0000 0C20             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0C21             a[5] = 0x;   //delta okrag
; 0000 0C22             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0C23             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0C24 
; 0000 0C25             a[1] = a[0]+0x001;  //ster2
; 0000 0C26             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C27             a[6] = a[5]+0x001;  //okrag
; 0000 0C28             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C29 
; 0000 0C2A     break;
; 0000 0C2B 
; 0000 0C2C 
; 0000 0C2D     case 77:
_0xFC:
	CPI  R30,LOW(0x4D)
	LDI  R26,HIGH(0x4D)
	CPC  R31,R26
	BRNE _0xFD
; 0000 0C2E 
; 0000 0C2F             a[0] = 0x026;   //ster1
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL SUBOPT_0x43
; 0000 0C30             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 0C31             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x60
; 0000 0C32             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x547
; 0000 0C33             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C34             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C35 
; 0000 0C36             a[1] = a[0]+0x001;  //ster2
; 0000 0C37             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C38             a[6] = a[5]+0x001;  //okrag
; 0000 0C39             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C3A 
; 0000 0C3B     break;
; 0000 0C3C 
; 0000 0C3D 
; 0000 0C3E     case 78:
_0xFD:
	CPI  R30,LOW(0x4E)
	LDI  R26,HIGH(0x4E)
	CPC  R31,R26
	BRNE _0xFE
; 0000 0C3F 
; 0000 0C40             a[0] = 0x11C;   //ster1
	LDI  R30,LOW(284)
	LDI  R31,HIGH(284)
	CALL SUBOPT_0x43
; 0000 0C41             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0C42             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0C43             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x547
; 0000 0C44             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C45             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C46 
; 0000 0C47             a[1] = a[0]+0x001;  //ster2
; 0000 0C48             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C49             a[6] = a[5]+0x001;  //okrag
; 0000 0C4A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C4B 
; 0000 0C4C     break;
; 0000 0C4D 
; 0000 0C4E 
; 0000 0C4F     case 79:
_0xFE:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0xFF
; 0000 0C50 
; 0000 0C51             a[0] = 0x112;   //ster1
	LDI  R30,LOW(274)
	LDI  R31,HIGH(274)
	CALL SUBOPT_0x43
; 0000 0C52             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0C53             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0C54             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x547
; 0000 0C55             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C56             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C57 
; 0000 0C58             a[1] = a[0]+0x001;  //ster2
; 0000 0C59             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C5A             a[6] = a[5]+0x001;  //okrag
; 0000 0C5B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C5C 
; 0000 0C5D     break;
; 0000 0C5E 
; 0000 0C5F     case 80:
_0xFF:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0x100
; 0000 0C60 
; 0000 0C61             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5F
; 0000 0C62             a[3] = 0x;    //ster4 INV druciak
; 0000 0C63             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0C64             a[5] = 0x;   //delta okrag
; 0000 0C65             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0C66             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0C67 
; 0000 0C68             a[1] = a[0]+0x001;  //ster2
; 0000 0C69             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C6A             a[6] = a[5]+0x001;  //okrag
; 0000 0C6B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C6C 
; 0000 0C6D     break;
; 0000 0C6E 
; 0000 0C6F     case 81:
_0x100:
	CPI  R30,LOW(0x51)
	LDI  R26,HIGH(0x51)
	CPC  R31,R26
	BRNE _0x101
; 0000 0C70 
; 0000 0C71             a[0] = 0x0EA;   //ster1
	LDI  R30,LOW(234)
	LDI  R31,HIGH(234)
	CALL SUBOPT_0x43
; 0000 0C72             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0C73             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x68
; 0000 0C74             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0C75             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C76             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0C77 
; 0000 0C78             a[1] = a[0]+0x001;  //ster2
; 0000 0C79             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C7A             a[6] = a[5]+0x001;  //okrag
; 0000 0C7B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C7C 
; 0000 0C7D     break;
; 0000 0C7E 
; 0000 0C7F 
; 0000 0C80     case 82:
_0x101:
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BRNE _0x102
; 0000 0C81 
; 0000 0C82             a[0] = 0x0D8;   //ster1
	LDI  R30,LOW(216)
	LDI  R31,HIGH(216)
	CALL SUBOPT_0x43
; 0000 0C83             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0C84             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x69
; 0000 0C85             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0C86             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C87             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0C88 
; 0000 0C89             a[1] = a[0]+0x001;  //ster2
; 0000 0C8A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C8B             a[6] = a[5]+0x001;  //okrag
; 0000 0C8C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C8D 
; 0000 0C8E     break;
; 0000 0C8F 
; 0000 0C90 
; 0000 0C91     case 83:
_0x102:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x103
; 0000 0C92 
; 0000 0C93             a[0] = 0x08C;   //ster1
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	CALL SUBOPT_0x43
; 0000 0C94             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0C95             a[4] = 0x22;    //ster3 ABS krazek scierny
	LDI  R26,LOW(34)
	LDI  R27,HIGH(34)
	CALL SUBOPT_0x6A
; 0000 0C96             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x547
; 0000 0C97             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C98             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C99 
; 0000 0C9A             a[1] = a[0]+0x001;  //ster2
; 0000 0C9B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C9C             a[6] = a[5]+0x001;  //okrag
; 0000 0C9D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C9E 
; 0000 0C9F     break;
; 0000 0CA0 
; 0000 0CA1 
; 0000 0CA2     case 84:
_0x103:
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x104
; 0000 0CA3 
; 0000 0CA4             a[0] = 0x0A0;   //ster1
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	CALL SUBOPT_0x43
; 0000 0CA5             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x6B
; 0000 0CA6             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0CA7             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6C
; 0000 0CA8             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x545
; 0000 0CA9             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CAA 
; 0000 0CAB             a[1] = a[0]+0x001;  //ster2
; 0000 0CAC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CAD             a[6] = a[5]+0x001;  //okrag
; 0000 0CAE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CAF 
; 0000 0CB0     break;
; 0000 0CB1 
; 0000 0CB2 
; 0000 0CB3    case 85:
_0x104:
	CPI  R30,LOW(0x55)
	LDI  R26,HIGH(0x55)
	CPC  R31,R26
	BRNE _0x105
; 0000 0CB4 
; 0000 0CB5             a[0] = 0x0AE;   //ster1
	LDI  R30,LOW(174)
	LDI  R31,HIGH(174)
	CALL SUBOPT_0x43
; 0000 0CB6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0CB7             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x68
; 0000 0CB8             a[5] = 0x193;   //delta okrag
	RJMP _0x547
; 0000 0CB9             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CBA             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CBB 
; 0000 0CBC             a[1] = a[0]+0x001;  //ster2
; 0000 0CBD             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CBE             a[6] = a[5]+0x001;  //okrag
; 0000 0CBF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CC0 
; 0000 0CC1     break;
; 0000 0CC2 
; 0000 0CC3     case 86:
_0x105:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BRNE _0x106
; 0000 0CC4 
; 0000 0CC5             a[0] = 0x0F6;   //ster1
	LDI  R30,LOW(246)
	LDI  R31,HIGH(246)
	CALL SUBOPT_0x43
; 0000 0CC6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0CC7             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x69
; 0000 0CC8             a[5] = 0x190;   //delta okrag
	RJMP _0x547
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
; 0000 0CD4     case 87:
_0x106:
	CPI  R30,LOW(0x57)
	LDI  R26,HIGH(0x57)
	CPC  R31,R26
	BRNE _0x107
; 0000 0CD5 
; 0000 0CD6             a[0] = 0x0C4;   //ster1
	LDI  R30,LOW(196)
	LDI  R31,HIGH(196)
	CALL SUBOPT_0x43
; 0000 0CD7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0CD8             a[4] = 0x23;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6D
; 0000 0CD9             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x54
; 0000 0CDA             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CDB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0CDC 
; 0000 0CDD             a[1] = a[0]+0x001;  //ster2
; 0000 0CDE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CDF             a[6] = a[5]+0x001;  //okrag
; 0000 0CE0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CE1 
; 0000 0CE2     break;
; 0000 0CE3 
; 0000 0CE4 
; 0000 0CE5     case 88:
_0x107:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x108
; 0000 0CE6 
; 0000 0CE7             a[0] = 0x07E;   //ster1
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	CALL SUBOPT_0x43
; 0000 0CE8             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x6B
; 0000 0CE9             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0CEA             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6C
; 0000 0CEB             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x46
; 0000 0CEC             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x48
	RJMP _0x546
; 0000 0CED 
; 0000 0CEE             a[1] = a[0]+0x001;  //ster2
; 0000 0CEF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CF0             a[6] = a[5]+0x001;  //okrag
; 0000 0CF1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CF2 
; 0000 0CF3     break;
; 0000 0CF4 
; 0000 0CF5 
; 0000 0CF6     case 89:
_0x108:
	CPI  R30,LOW(0x59)
	LDI  R26,HIGH(0x59)
	CPC  R31,R26
	BRNE _0x109
; 0000 0CF7 
; 0000 0CF8             a[0] = 0x02C;   //ster1
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x43
; 0000 0CF9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0CFA             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x64
; 0000 0CFB             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0CFC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CFD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0CFE 
; 0000 0CFF             a[1] = a[0]+0x001;  //ster2
; 0000 0D00             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D01             a[6] = a[5]+0x001;  //okrag
; 0000 0D02             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D03 
; 0000 0D04     break;
; 0000 0D05 
; 0000 0D06 
; 0000 0D07     case 90:
_0x109:
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BRNE _0x10A
; 0000 0D08 
; 0000 0D09             a[0] = 0x0F0;   //ster1
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	CALL SUBOPT_0x43
; 0000 0D0A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0D0B             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0D0C             a[5] = 0x196;   //delta okrag
; 0000 0D0D             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0D0E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D0F 
; 0000 0D10             a[1] = a[0]+0x001;  //ster2
; 0000 0D11             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D12             a[6] = a[5]+0x001;  //okrag
; 0000 0D13             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D14 
; 0000 0D15     break;
; 0000 0D16 
; 0000 0D17 
; 0000 0D18     case 91:
_0x10A:
	CPI  R30,LOW(0x5B)
	LDI  R26,HIGH(0x5B)
	CPC  R31,R26
	BRNE _0x10B
; 0000 0D19 
; 0000 0D1A             a[0] = 0x0A8;   //ster1
	LDI  R30,LOW(168)
	LDI  R31,HIGH(168)
	CALL SUBOPT_0x43
; 0000 0D1B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0D1C             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0D1D             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x547
; 0000 0D1E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D1F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D20 
; 0000 0D21             a[1] = a[0]+0x001;  //ster2
; 0000 0D22             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D23             a[6] = a[5]+0x001;  //okrag
; 0000 0D24             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D25 
; 0000 0D26     break;
; 0000 0D27 
; 0000 0D28 
; 0000 0D29     case 92:
_0x10B:
	CPI  R30,LOW(0x5C)
	LDI  R26,HIGH(0x5C)
	CPC  R31,R26
	BRNE _0x10C
; 0000 0D2A 
; 0000 0D2B             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5F
; 0000 0D2C             a[3] = 0x;    //ster4 INV druciak
; 0000 0D2D             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0D2E             a[5] = 0x;   //delta okrag
; 0000 0D2F             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0D30             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0D31 
; 0000 0D32             a[1] = a[0]+0x001;  //ster2
; 0000 0D33             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D34             a[6] = a[5]+0x001;  //okrag
; 0000 0D35             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D36 
; 0000 0D37     break;
; 0000 0D38 
; 0000 0D39 
; 0000 0D3A     case 93:
_0x10C:
	CPI  R30,LOW(0x5D)
	LDI  R26,HIGH(0x5D)
	CPC  R31,R26
	BRNE _0x10D
; 0000 0D3B 
; 0000 0D3C             a[0] = 0x030;   //ster1
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x43
; 0000 0D3D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0D3E             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x64
; 0000 0D3F             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x547
; 0000 0D40             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D41             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D42 
; 0000 0D43             a[1] = a[0]+0x001;  //ster2
; 0000 0D44             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D45             a[6] = a[5]+0x001;  //okrag
; 0000 0D46             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D47 
; 0000 0D48     break;
; 0000 0D49 
; 0000 0D4A 
; 0000 0D4B     case 94:
_0x10D:
	CPI  R30,LOW(0x5E)
	LDI  R26,HIGH(0x5E)
	CPC  R31,R26
	BRNE _0x10E
; 0000 0D4C 
; 0000 0D4D             a[0] = 0x0F4;   //ster1
	LDI  R30,LOW(244)
	LDI  R31,HIGH(244)
	CALL SUBOPT_0x43
; 0000 0D4E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0D4F             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0D50             a[5] = 0x196;   //delta okrag
; 0000 0D51             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0D52             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0D53 
; 0000 0D54             a[1] = a[0]+0x001;  //ster2
; 0000 0D55             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D56             a[6] = a[5]+0x001;  //okrag
; 0000 0D57             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D58 
; 0000 0D59     break;
; 0000 0D5A 
; 0000 0D5B 
; 0000 0D5C     case 95:
_0x10E:
	CPI  R30,LOW(0x5F)
	LDI  R26,HIGH(0x5F)
	CPC  R31,R26
	BRNE _0x10F
; 0000 0D5D 
; 0000 0D5E             a[0] = 0x09E;   //ster1
	LDI  R30,LOW(158)
	LDI  R31,HIGH(158)
	CALL SUBOPT_0x43
; 0000 0D5F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0D60             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 0D61             a[5] = 0x199;   //delta okrag
; 0000 0D62             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D63             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0D64 
; 0000 0D65             a[1] = a[0]+0x001;  //ster2
; 0000 0D66             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D67             a[6] = a[5]+0x001;  //okrag
; 0000 0D68             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D69 
; 0000 0D6A     break;
; 0000 0D6B 
; 0000 0D6C     case 96:
_0x10F:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x110
; 0000 0D6D 
; 0000 0D6E             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5F
; 0000 0D6F             a[3] = 0x;    //ster4 INV druciak
; 0000 0D70             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0D71             a[5] = 0x;   //delta okrag
; 0000 0D72             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0D73             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0D74 
; 0000 0D75             a[1] = a[0]+0x001;  //ster2
; 0000 0D76             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D77             a[6] = a[5]+0x001;  //okrag
; 0000 0D78             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D79 
; 0000 0D7A     break;
; 0000 0D7B 
; 0000 0D7C 
; 0000 0D7D     case 97:
_0x110:
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BRNE _0x111
; 0000 0D7E 
; 0000 0D7F             a[0] = 0x06A;   //ster1
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	CALL SUBOPT_0x43
; 0000 0D80             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0D81             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0D82             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0D83             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D84             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0D85 
; 0000 0D86             a[1] = a[0]+0x001;  //ster2
; 0000 0D87             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D88             a[6] = a[5]+0x001;  //okrag
; 0000 0D89             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D8A 
; 0000 0D8B     break;
; 0000 0D8C 
; 0000 0D8D 
; 0000 0D8E     case 98:
_0x111:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x112
; 0000 0D8F 
; 0000 0D90             a[0] = 0x0BE;   //ster1
	LDI  R30,LOW(190)
	LDI  R31,HIGH(190)
	CALL SUBOPT_0x43
; 0000 0D91             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0D92             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0D93             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6E
; 0000 0D94             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0D95             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0D96 
; 0000 0D97             a[1] = a[0]+0x001;  //ster2
; 0000 0D98             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D99             a[6] = a[5]+0x001;  //okrag
; 0000 0D9A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D9B 
; 0000 0D9C     break;
; 0000 0D9D 
; 0000 0D9E 
; 0000 0D9F     case 99:
_0x112:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x113
; 0000 0DA0 
; 0000 0DA1             a[0] = 0x0BA;   //ster1
	LDI  R30,LOW(186)
	LDI  R31,HIGH(186)
	CALL SUBOPT_0x43
; 0000 0DA2             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0DA3             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0DA4             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x547
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
; 0000 0DB0     case 100:
_0x113:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRNE _0x114
; 0000 0DB1 
; 0000 0DB2             a[0] = 0x060;   //ster1
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x43
; 0000 0DB3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0DB4             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0DB5             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4A
; 0000 0DB6             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DB7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0DB8 
; 0000 0DB9             a[1] = a[0]+0x001;  //ster2
; 0000 0DBA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DBB             a[6] = a[5]+0x001;  //okrag
; 0000 0DBC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DBD 
; 0000 0DBE     break;
; 0000 0DBF 
; 0000 0DC0 
; 0000 0DC1     case 101:
_0x114:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x115
; 0000 0DC2 
; 0000 0DC3             a[0] = 0x070;   //ster1
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	CALL SUBOPT_0x43
; 0000 0DC4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0DC5             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0DC6             a[5] = 0x199;   //delta okrag
	RJMP _0x547
; 0000 0DC7             a[7] = 0x12;    //ster3 INV krazek scierny
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
; 0000 0DD2     case 102:
_0x115:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BRNE _0x116
; 0000 0DD3 
; 0000 0DD4             a[0] = 0x08A;   //ster1
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	CALL SUBOPT_0x43
; 0000 0DD5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0DD6             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0DD7             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6E
; 0000 0DD8             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0DD9             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DDA 
; 0000 0DDB             a[1] = a[0]+0x001;  //ster2
; 0000 0DDC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DDD             a[6] = a[5]+0x001;  //okrag
; 0000 0DDE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DDF 
; 0000 0DE0     break;
; 0000 0DE1 
; 0000 0DE2 
; 0000 0DE3     case 103:
_0x116:
	CPI  R30,LOW(0x67)
	LDI  R26,HIGH(0x67)
	CPC  R31,R26
	BRNE _0x117
; 0000 0DE4 
; 0000 0DE5             a[0] = 0x080;   //ster1
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CALL SUBOPT_0x43
; 0000 0DE6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0DE7             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0DE8             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x54
; 0000 0DE9             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DEA             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0DEB 
; 0000 0DEC             a[1] = a[0]+0x001;  //ster2
; 0000 0DED             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DEE             a[6] = a[5]+0x001;  //okrag
; 0000 0DEF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DF0 
; 0000 0DF1     break;
; 0000 0DF2 
; 0000 0DF3 
; 0000 0DF4     case 104:
_0x117:
	CPI  R30,LOW(0x68)
	LDI  R26,HIGH(0x68)
	CPC  R31,R26
	BRNE _0x118
; 0000 0DF5 
; 0000 0DF6             a[0] = 0x0B6;   //ster1
	LDI  R30,LOW(182)
	LDI  R31,HIGH(182)
	CALL SUBOPT_0x43
; 0000 0DF7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0DF8             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0DF9             a[5] = 0x196;   //delta okrag
	RJMP _0x547
; 0000 0DFA             a[7] = 0x12;    //ster3 INV krazek scierny
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
; 0000 0E05     case 105:
_0x118:
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x119
; 0000 0E06 
; 0000 0E07             a[0] = 0x044;   //ster1
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	CALL SUBOPT_0x43
; 0000 0E08             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0E09             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6F
; 0000 0E0A             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x55
; 0000 0E0B             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0E0C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0E0D 
; 0000 0E0E             a[1] = a[0]+0x001;  //ster2
; 0000 0E0F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E10             a[6] = a[5]+0x001;  //okrag
; 0000 0E11             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E12 
; 0000 0E13     break;
; 0000 0E14 
; 0000 0E15 
; 0000 0E16     case 106:
_0x119:
	CPI  R30,LOW(0x6A)
	LDI  R26,HIGH(0x6A)
	CPC  R31,R26
	BRNE _0x11A
; 0000 0E17 
; 0000 0E18             a[0] = 0x03A;   //ster1
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	CALL SUBOPT_0x43
; 0000 0E19             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0E1A             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0E1B             a[5] = 0x190;   //delta okrag
; 0000 0E1C             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0E1D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E1E 
; 0000 0E1F             a[1] = a[0]+0x001;  //ster2
; 0000 0E20             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E21             a[6] = a[5]+0x001;  //okrag
; 0000 0E22             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E23 
; 0000 0E24     break;
; 0000 0E25 
; 0000 0E26 
; 0000 0E27     case 107:
_0x11A:
	CPI  R30,LOW(0x6B)
	LDI  R26,HIGH(0x6B)
	CPC  R31,R26
	BRNE _0x11B
; 0000 0E28 
; 0000 0E29             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5F
; 0000 0E2A             a[3] = 0x;    //ster4 INV druciak
; 0000 0E2B             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0E2C             a[5] = 0x;   //delta okrag
; 0000 0E2D             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0E2E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0E2F 
; 0000 0E30             a[1] = a[0]+0x001;  //ster2
; 0000 0E31             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E32             a[6] = a[5]+0x001;  //okrag
; 0000 0E33             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E34 
; 0000 0E35     break;
; 0000 0E36 
; 0000 0E37 
; 0000 0E38     case 108:
_0x11B:
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BRNE _0x11C
; 0000 0E39 
; 0000 0E3A             a[0] = 0x0C6;   //ster1
	LDI  R30,LOW(198)
	LDI  R31,HIGH(198)
	CALL SUBOPT_0x43
; 0000 0E3B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0E3C             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0E3D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0E3E             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0E3F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0E40 
; 0000 0E41             a[1] = a[0]+0x001;  //ster2
; 0000 0E42             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E43             a[6] = a[5]+0x001;  //okrag
; 0000 0E44             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E45 
; 0000 0E46     break;
; 0000 0E47 
; 0000 0E48 
; 0000 0E49     case 109:
_0x11C:
	CPI  R30,LOW(0x6D)
	LDI  R26,HIGH(0x6D)
	CPC  R31,R26
	BRNE _0x11D
; 0000 0E4A 
; 0000 0E4B             a[0] = 0x00A;   //ster1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x43
; 0000 0E4C             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 0E4D             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 0E4E             a[5] = 0x190;   //delta okrag
; 0000 0E4F             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x545
; 0000 0E50             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E51 
; 0000 0E52             a[1] = a[0]+0x001;  //ster2
; 0000 0E53             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E54             a[6] = a[5]+0x001;  //okrag
; 0000 0E55             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E56 
; 0000 0E57     break;
; 0000 0E58 
; 0000 0E59 
; 0000 0E5A     case 110:
_0x11D:
	CPI  R30,LOW(0x6E)
	LDI  R26,HIGH(0x6E)
	CPC  R31,R26
	BRNE _0x11E
; 0000 0E5B 
; 0000 0E5C             a[0] = 0x032;   //ster1
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x43
; 0000 0E5D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0E5E             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0E5F             a[5] = 0x190;   //delta okrag
; 0000 0E60             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0E61             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0E62 
; 0000 0E63             a[1] = a[0]+0x001;  //ster2
; 0000 0E64             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E65             a[6] = a[5]+0x001;  //okrag
; 0000 0E66             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E67 
; 0000 0E68     break;
; 0000 0E69 
; 0000 0E6A 
; 0000 0E6B     case 111:
_0x11E:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x11F
; 0000 0E6C 
; 0000 0E6D             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5F
; 0000 0E6E             a[3] = 0x;    //ster4 INV druciak
; 0000 0E6F             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0E70             a[5] = 0x;   //delta okrag
; 0000 0E71             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0E72             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0E73 
; 0000 0E74             a[1] = a[0]+0x001;  //ster2
; 0000 0E75             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E76             a[6] = a[5]+0x001;  //okrag
; 0000 0E77             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E78 
; 0000 0E79     break;
; 0000 0E7A 
; 0000 0E7B 
; 0000 0E7C     case 112:
_0x11F:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x120
; 0000 0E7D 
; 0000 0E7E             a[0] = 0x0E2;   //ster1
	LDI  R30,LOW(226)
	LDI  R31,HIGH(226)
	CALL SUBOPT_0x43
; 0000 0E7F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0E80             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0E81             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0E82             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0E83             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E84 
; 0000 0E85             a[1] = a[0]+0x001;  //ster2
; 0000 0E86             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E87             a[6] = a[5]+0x001;  //okrag
; 0000 0E88             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E89 
; 0000 0E8A     break;
; 0000 0E8B 
; 0000 0E8C 
; 0000 0E8D     case 113:
_0x120:
	CPI  R30,LOW(0x71)
	LDI  R26,HIGH(0x71)
	CPC  R31,R26
	BRNE _0x121
; 0000 0E8E 
; 0000 0E8F             a[0] = 0x0D4;   //ster1
	LDI  R30,LOW(212)
	LDI  R31,HIGH(212)
	CALL SUBOPT_0x43
; 0000 0E90             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0E91             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x70
; 0000 0E92             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0E93             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0E94             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0E95 
; 0000 0E96             a[1] = a[0]+0x001;  //ster2
; 0000 0E97             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E98             a[6] = a[5]+0x001;  //okrag
; 0000 0E99             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E9A 
; 0000 0E9B     break;
; 0000 0E9C 
; 0000 0E9D 
; 0000 0E9E     case 114:
_0x121:
	CPI  R30,LOW(0x72)
	LDI  R26,HIGH(0x72)
	CPC  R31,R26
	BRNE _0x122
; 0000 0E9F 
; 0000 0EA0             a[0] = 0x04A;   //ster1
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	CALL SUBOPT_0x43
; 0000 0EA1             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 0EA2             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x71
; 0000 0EA3             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6C
; 0000 0EA4             a[7] = 0x0F;    //ster3 INV krazek scierny
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	CALL SUBOPT_0x4C
; 0000 0EA5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0EA6 
; 0000 0EA7             a[1] = a[0]+0x001;  //ster2
; 0000 0EA8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EA9             a[6] = a[5]+0x001;  //okrag
; 0000 0EAA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EAB 
; 0000 0EAC     break;
; 0000 0EAD 
; 0000 0EAE 
; 0000 0EAF     case 115:
_0x122:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x123
; 0000 0EB0 
; 0000 0EB1             a[0] = 0x076;   //ster1
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	CALL SUBOPT_0x43
; 0000 0EB2             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x72
; 0000 0EB3             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0EB4             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x4D
; 0000 0EB5             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0EB6             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0EB7 
; 0000 0EB8             a[1] = a[0]+0x001;  //ster2
; 0000 0EB9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EBA             a[6] = a[5]+0x001;  //okrag
; 0000 0EBB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EBC 
; 0000 0EBD     break;
; 0000 0EBE 
; 0000 0EBF 
; 0000 0EC0     case 116:
_0x123:
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BRNE _0x124
; 0000 0EC1 
; 0000 0EC2             a[0] = 0x092;   //ster1
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	CALL SUBOPT_0x43
; 0000 0EC3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0EC4             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0EC5             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x547
; 0000 0EC6             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0EC7             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EC8 
; 0000 0EC9             a[1] = a[0]+0x001;  //ster2
; 0000 0ECA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0ECB             a[6] = a[5]+0x001;  //okrag
; 0000 0ECC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ECD 
; 0000 0ECE     break;
; 0000 0ECF 
; 0000 0ED0 
; 0000 0ED1 
; 0000 0ED2     case 117:
_0x124:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x125
; 0000 0ED3 
; 0000 0ED4             a[0] = 0x11A;   //ster1
	LDI  R30,LOW(282)
	LDI  R31,HIGH(282)
	CALL SUBOPT_0x43
; 0000 0ED5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0ED6             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x70
; 0000 0ED7             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0ED8             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0ED9             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EDA 
; 0000 0EDB             a[1] = a[0]+0x001;  //ster2
; 0000 0EDC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EDD             a[6] = a[5]+0x001;  //okrag
; 0000 0EDE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EDF 
; 0000 0EE0     break;
; 0000 0EE1 
; 0000 0EE2 
; 0000 0EE3 
; 0000 0EE4     case 118:
_0x125:
	CPI  R30,LOW(0x76)
	LDI  R26,HIGH(0x76)
	CPC  R31,R26
	BRNE _0x126
; 0000 0EE5 
; 0000 0EE6             a[0] = 0x056;   //ster1
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	CALL SUBOPT_0x43
; 0000 0EE7             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 0EE8             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x71
; 0000 0EE9             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0EEA             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0EEB             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EEC 
; 0000 0EED             a[1] = a[0]+0x001;  //ster2
; 0000 0EEE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EEF             a[6] = a[5]+0x001;  //okrag
; 0000 0EF0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EF1 
; 0000 0EF2     break;
; 0000 0EF3 
; 0000 0EF4 
; 0000 0EF5     case 119:
_0x126:
	CPI  R30,LOW(0x77)
	LDI  R26,HIGH(0x77)
	CPC  R31,R26
	BRNE _0x127
; 0000 0EF6 
; 0000 0EF7             a[0] = 0x072;   //ster1
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	CALL SUBOPT_0x43
; 0000 0EF8             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x72
; 0000 0EF9             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0EFA             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x4D
; 0000 0EFB             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0EFC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EFD 
; 0000 0EFE             a[1] = a[0]+0x001;  //ster2
; 0000 0EFF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F00             a[6] = a[5]+0x001;  //okrag
; 0000 0F01             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F02 
; 0000 0F03     break;
; 0000 0F04 
; 0000 0F05 
; 0000 0F06     case 120:
_0x127:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x128
; 0000 0F07 
; 0000 0F08             a[0] = 0x0D0;   //ster1
	LDI  R30,LOW(208)
	LDI  R31,HIGH(208)
	CALL SUBOPT_0x43
; 0000 0F09             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0F0A             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0F0B             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0F0C             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F0D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0F0E 
; 0000 0F0F             a[1] = a[0]+0x001;  //ster2
; 0000 0F10             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F11             a[6] = a[5]+0x001;  //okrag
; 0000 0F12             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F13 
; 0000 0F14     break;
; 0000 0F15 
; 0000 0F16 
; 0000 0F17     case 121:
_0x128:
	CPI  R30,LOW(0x79)
	LDI  R26,HIGH(0x79)
	CPC  R31,R26
	BRNE _0x129
; 0000 0F18 
; 0000 0F19             a[0] = 0x048;   //ster1
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	CALL SUBOPT_0x43
; 0000 0F1A             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 0F1B             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x71
; 0000 0F1C             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0F1D             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0F1E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0F1F 
; 0000 0F20             a[1] = a[0]+0x001;  //ster2
; 0000 0F21             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F22             a[6] = a[5]+0x001;  //okrag
; 0000 0F23             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F24 
; 0000 0F25     break;
; 0000 0F26 
; 0000 0F27 
; 0000 0F28     case 122:
_0x129:
	CPI  R30,LOW(0x7A)
	LDI  R26,HIGH(0x7A)
	CPC  R31,R26
	BRNE _0x12A
; 0000 0F29 
; 0000 0F2A             a[0] = 0x09A;   //ster1
	LDI  R30,LOW(154)
	LDI  R31,HIGH(154)
	CALL SUBOPT_0x43
; 0000 0F2B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0F2C             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0F2D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0F2E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F2F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0F30 
; 0000 0F31             a[1] = a[0]+0x001;  //ster2
; 0000 0F32             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F33             a[6] = a[5]+0x001;  //okrag
; 0000 0F34             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F35 
; 0000 0F36     break;
; 0000 0F37 
; 0000 0F38 
; 0000 0F39     case 123:
_0x12A:
	CPI  R30,LOW(0x7B)
	LDI  R26,HIGH(0x7B)
	CPC  R31,R26
	BRNE _0x12B
; 0000 0F3A 
; 0000 0F3B             a[0] = 0x046;   //ster1
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL SUBOPT_0x43
; 0000 0F3C             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 0F3D             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x73
; 0000 0F3E             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x74
; 0000 0F3F             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0F40             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0F41 
; 0000 0F42             a[1] = a[0]+0x001;  //ster2
; 0000 0F43             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F44             a[6] = a[5]+0x001;  //okrag
; 0000 0F45             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F46 
; 0000 0F47     break;
; 0000 0F48 
; 0000 0F49 
; 0000 0F4A 
; 0000 0F4B     case 124:
_0x12B:
	CPI  R30,LOW(0x7C)
	LDI  R26,HIGH(0x7C)
	CPC  R31,R26
	BRNE _0x12C
; 0000 0F4C 
; 0000 0F4D             a[0] = 0x0E0;   //ster1
	LDI  R30,LOW(224)
	LDI  R31,HIGH(224)
	CALL SUBOPT_0x43
; 0000 0F4E             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x75
; 0000 0F4F             a[4] = 0x15;    //ster3 ABS krazek scierny
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL SUBOPT_0x6A
; 0000 0F50             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6C
; 0000 0F51             a[7] = 0x13;    //ster3 INV krazek scierny
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	CALL SUBOPT_0x4C
; 0000 0F52             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0F53 
; 0000 0F54             a[1] = a[0]+0x001;  //ster2
; 0000 0F55             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F56             a[6] = a[5]+0x001;  //okrag
; 0000 0F57             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F58 
; 0000 0F59     break;
; 0000 0F5A 
; 0000 0F5B 
; 0000 0F5C     case 125:
_0x12C:
	CPI  R30,LOW(0x7D)
	LDI  R26,HIGH(0x7D)
	CPC  R31,R26
	BRNE _0x12D
; 0000 0F5D 
; 0000 0F5E             a[0] = 0x038;   //ster1
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	CALL SUBOPT_0x43
; 0000 0F5F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0F60             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0F61             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0F62             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0F63             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F64 
; 0000 0F65             a[1] = a[0]+0x001;  //ster2
; 0000 0F66             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F67             a[6] = a[5]+0x001;  //okrag
; 0000 0F68             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F69 
; 0000 0F6A     break;
; 0000 0F6B 
; 0000 0F6C 
; 0000 0F6D     case 126:
_0x12D:
	CPI  R30,LOW(0x7E)
	LDI  R26,HIGH(0x7E)
	CPC  R31,R26
	BRNE _0x12E
; 0000 0F6E 
; 0000 0F6F             a[0] = 0x0CA;   //ster1
	LDI  R30,LOW(202)
	LDI  R31,HIGH(202)
	CALL SUBOPT_0x43
; 0000 0F70             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0F71             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0F72             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x547
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
; 0000 0F7E     case 127:
_0x12E:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0x12F
; 0000 0F7F 
; 0000 0F80             a[0] = 0x0DE;   //ster1
	LDI  R30,LOW(222)
	LDI  R31,HIGH(222)
	CALL SUBOPT_0x43
; 0000 0F81             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 0F82             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x73
; 0000 0F83             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x74
; 0000 0F84             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0F85             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F86 
; 0000 0F87             a[1] = a[0]+0x001;  //ster2
; 0000 0F88             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F89             a[6] = a[5]+0x001;  //okrag
; 0000 0F8A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F8B 
; 0000 0F8C     break;
; 0000 0F8D 
; 0000 0F8E 
; 0000 0F8F     case 128:
_0x12F:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x130
; 0000 0F90 
; 0000 0F91             a[0] = 0x116;   //ster1
	LDI  R30,LOW(278)
	LDI  R31,HIGH(278)
	CALL SUBOPT_0x43
; 0000 0F92             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 0F93             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x49
; 0000 0F94             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x76
; 0000 0F95             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 0F96             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F97 
; 0000 0F98             a[1] = a[0]+0x001;  //ster2
; 0000 0F99             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F9A             a[6] = a[5]+0x001;  //okrag
; 0000 0F9B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F9C 
; 0000 0F9D     break;
; 0000 0F9E 
; 0000 0F9F 
; 0000 0FA0     case 129:
_0x130:
	CPI  R30,LOW(0x81)
	LDI  R26,HIGH(0x81)
	CPC  R31,R26
	BRNE _0x131
; 0000 0FA1 
; 0000 0FA2             a[0] = 0x0E8;   //ster1
	LDI  R30,LOW(232)
	LDI  R31,HIGH(232)
	CALL SUBOPT_0x43
; 0000 0FA3             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x75
; 0000 0FA4             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x77
; 0000 0FA5             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x76
; 0000 0FA6             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 0FA7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0FA8 
; 0000 0FA9             a[1] = a[0]+0x001;  //ster2
; 0000 0FAA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FAB             a[6] = a[5]+0x001;  //okrag
; 0000 0FAC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FAD 
; 0000 0FAE     break;
; 0000 0FAF 
; 0000 0FB0 
; 0000 0FB1     case 130:
_0x131:
	CPI  R30,LOW(0x82)
	LDI  R26,HIGH(0x82)
	CPC  R31,R26
	BRNE _0x132
; 0000 0FB2 
; 0000 0FB3             a[0] = 0x0F2;   //ster1
	LDI  R30,LOW(242)
	LDI  R31,HIGH(242)
	CALL SUBOPT_0x43
; 0000 0FB4             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x78
; 0000 0FB5             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0FB6             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6C
; 0000 0FB7             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x46
; 0000 0FB8             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x48
	RJMP _0x546
; 0000 0FB9 
; 0000 0FBA             a[1] = a[0]+0x001;  //ster2
; 0000 0FBB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FBC             a[6] = a[5]+0x001;  //okrag
; 0000 0FBD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FBE 
; 0000 0FBF     break;
; 0000 0FC0 
; 0000 0FC1 
; 0000 0FC2     case 131:
_0x132:
	CPI  R30,LOW(0x83)
	LDI  R26,HIGH(0x83)
	CPC  R31,R26
	BRNE _0x133
; 0000 0FC3 
; 0000 0FC4             a[0] = 0x108;   //ster1
	LDI  R30,LOW(264)
	LDI  R31,HIGH(264)
	CALL SUBOPT_0x43
; 0000 0FC5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0FC6             a[4] = 0x1F;    //ster3 ABS krazek scierny
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP _0x548
; 0000 0FC7             a[5] = 0x19C;   //delta okrag
; 0000 0FC8             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FC9             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FCA 
; 0000 0FCB             a[1] = a[0]+0x001;  //ster2
; 0000 0FCC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FCD             a[6] = a[5]+0x001;  //okrag
; 0000 0FCE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FCF 
; 0000 0FD0     break;
; 0000 0FD1 
; 0000 0FD2 
; 0000 0FD3 
; 0000 0FD4     case 132:
_0x133:
	CPI  R30,LOW(0x84)
	LDI  R26,HIGH(0x84)
	CPC  R31,R26
	BRNE _0x134
; 0000 0FD5 
; 0000 0FD6             a[0] = 0x064;   //ster1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x43
; 0000 0FD7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 0FD8             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0FD9             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x5C
; 0000 0FDA             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FDB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 0FDC 
; 0000 0FDD             a[1] = a[0]+0x001;  //ster2
; 0000 0FDE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FDF             a[6] = a[5]+0x001;  //okrag
; 0000 0FE0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FE1 
; 0000 0FE2     break;
; 0000 0FE3 
; 0000 0FE4 
; 0000 0FE5     case 133:
_0x134:
	CPI  R30,LOW(0x85)
	LDI  R26,HIGH(0x85)
	CPC  R31,R26
	BRNE _0x135
; 0000 0FE6 
; 0000 0FE7             a[0] = 0x088;   //ster1
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	CALL SUBOPT_0x43
; 0000 0FE8             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x75
; 0000 0FE9             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x77
; 0000 0FEA             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x76
; 0000 0FEB             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x545
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
; 0000 0FF6 
; 0000 0FF7     case 134:
_0x135:
	CPI  R30,LOW(0x86)
	LDI  R26,HIGH(0x86)
	CPC  R31,R26
	BRNE _0x136
; 0000 0FF8 
; 0000 0FF9             a[0] = 0x10E;   //ster1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x43
; 0000 0FFA             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x78
; 0000 0FFB             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0FFC             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6C
; 0000 0FFD             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x545
; 0000 0FFE             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FFF 
; 0000 1000             a[1] = a[0]+0x001;  //ster2
; 0000 1001             a[2] = a[4];        //ster4 ABS druciak
; 0000 1002             a[6] = a[5]+0x001;  //okrag
; 0000 1003             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1004 
; 0000 1005     break;
; 0000 1006 
; 0000 1007                ////////////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 1008      case 135:
_0x136:
	CPI  R30,LOW(0x87)
	LDI  R26,HIGH(0x87)
	CPC  R31,R26
	BRNE _0x137
; 0000 1009 
; 0000 100A             a[0] = 0x054;   //ster1
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CALL SUBOPT_0x43
; 0000 100B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 100C             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6F
; 0000 100D             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x5C
; 0000 100E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 100F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 1010 
; 0000 1011             a[1] = a[0]+0x001;  //ster2
; 0000 1012             a[2] = a[4];        //ster4 ABS druciak
; 0000 1013             a[6] = a[5]+0x001;  //okrag
; 0000 1014             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1015 
; 0000 1016     break;
; 0000 1017 
; 0000 1018 
; 0000 1019      case 136:
_0x137:
	CPI  R30,LOW(0x88)
	LDI  R26,HIGH(0x88)
	CPC  R31,R26
	BRNE _0x138
; 0000 101A 
; 0000 101B             a[0] = 0x03E;   //ster1
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	CALL SUBOPT_0x43
; 0000 101C             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 101D             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x77
; 0000 101E             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x79
; 0000 101F             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x545
; 0000 1020             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1021 
; 0000 1022             a[1] = a[0]+0x001;  //ster2
; 0000 1023             a[2] = a[4];        //ster4 ABS druciak
; 0000 1024             a[6] = a[5]+0x001;  //okrag
; 0000 1025             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1026 
; 0000 1027     break;
; 0000 1028 
; 0000 1029      case 137:
_0x138:
	CPI  R30,LOW(0x89)
	LDI  R26,HIGH(0x89)
	CPC  R31,R26
	BRNE _0x139
; 0000 102A 
; 0000 102B             a[0] = 0x00C;   //ster1
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x43
; 0000 102C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 102D             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 102E             a[5] = 0x190;   //delta okrag
; 0000 102F             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 1030             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 1031 
; 0000 1032             a[1] = a[0]+0x001;  //ster2
; 0000 1033             a[2] = a[4];        //ster4 ABS druciak
; 0000 1034             a[6] = a[5]+0x001;  //okrag
; 0000 1035             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1036 
; 0000 1037     break;
; 0000 1038 
; 0000 1039 
; 0000 103A      case 138:
_0x139:
	CPI  R30,LOW(0x8A)
	LDI  R26,HIGH(0x8A)
	CPC  R31,R26
	BRNE _0x13A
; 0000 103B 
; 0000 103C             a[0] = 0x0DC;   //ster1
	LDI  R30,LOW(220)
	LDI  R31,HIGH(220)
	CALL SUBOPT_0x43
; 0000 103D             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 103E             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x45
; 0000 103F             a[5] = 0x196;   //delta okrag
; 0000 1040             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 1041             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1042 
; 0000 1043             a[1] = a[0]+0x001;  //ster2
; 0000 1044             a[2] = a[4];        //ster4 ABS druciak
; 0000 1045             a[6] = a[5]+0x001;  //okrag
; 0000 1046             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1047 
; 0000 1048     break;
; 0000 1049 
; 0000 104A 
; 0000 104B      case 139:
_0x13A:
	CPI  R30,LOW(0x8B)
	LDI  R26,HIGH(0x8B)
	CPC  R31,R26
	BRNE _0x13B
; 0000 104C 
; 0000 104D             a[0] = 0x058;   //ster1
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	CALL SUBOPT_0x43
; 0000 104E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 104F             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x70
; 0000 1050             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x547
; 0000 1051             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 1052             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1053 
; 0000 1054             a[1] = a[0]+0x001;  //ster2
; 0000 1055             a[2] = a[4];        //ster4 ABS druciak
; 0000 1056             a[6] = a[5]+0x001;  //okrag
; 0000 1057             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1058 
; 0000 1059     break;
; 0000 105A 
; 0000 105B 
; 0000 105C      case 140:
_0x13B:
	CPI  R30,LOW(0x8C)
	LDI  R26,HIGH(0x8C)
	CPC  R31,R26
	BRNE _0x13C
; 0000 105D 
; 0000 105E             a[0] = 0x03C;   //ster1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0x43
; 0000 105F             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 1060             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x73
; 0000 1061             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x79
; 0000 1062             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x46
; 0000 1063             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x48
	RJMP _0x546
; 0000 1064 
; 0000 1065             a[1] = a[0]+0x001;  //ster2
; 0000 1066             a[2] = a[4];        //ster4 ABS druciak
; 0000 1067             a[6] = a[5]+0x001;  //okrag
; 0000 1068             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1069 
; 0000 106A 
; 0000 106B 
; 0000 106C     break;
; 0000 106D 
; 0000 106E 
; 0000 106F      case 141:
_0x13C:
	CPI  R30,LOW(0x8D)
	LDI  R26,HIGH(0x8D)
	CPC  R31,R26
	BRNE _0x13D
; 0000 1070 
; 0000 1071             a[0] = 0x00E;   //ster1
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x43
; 0000 1072             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 1073             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 1074             a[5] = 0x190;   //delta okrag
; 0000 1075             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x545
; 0000 1076             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1077 
; 0000 1078             a[1] = a[0]+0x001;  //ster2
; 0000 1079             a[2] = a[4];        //ster4 ABS druciak
; 0000 107A             a[6] = a[5]+0x001;  //okrag
; 0000 107B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 107C 
; 0000 107D     break;
; 0000 107E 
; 0000 107F 
; 0000 1080      case 142:
_0x13D:
	CPI  R30,LOW(0x8E)
	LDI  R26,HIGH(0x8E)
	CPC  R31,R26
	BRNE _0x13E
; 0000 1081 
; 0000 1082             a[0] = 0x10A;   //ster1
	LDI  R30,LOW(266)
	LDI  R31,HIGH(266)
	CALL SUBOPT_0x43
; 0000 1083             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x46
; 0000 1084             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x45
; 0000 1085             a[5] = 0x196;   //delta okrag
; 0000 1086             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4C
; 0000 1087             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 1088 
; 0000 1089             a[1] = a[0]+0x001;  //ster2
; 0000 108A             a[2] = a[4];        //ster4 ABS druciak
; 0000 108B             a[6] = a[5]+0x001;  //okrag
; 0000 108C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 108D 
; 0000 108E     break;
; 0000 108F 
; 0000 1090 
; 0000 1091 
; 0000 1092      case 143:
_0x13E:
	CPI  R30,LOW(0x8F)
	LDI  R26,HIGH(0x8F)
	CPC  R31,R26
	BRNE _0x13F
; 0000 1093 
; 0000 1094             a[0] = 0x022;   //ster1
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL SUBOPT_0x43
; 0000 1095             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 1096             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x70
; 0000 1097             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 1098             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 1099             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x546
; 0000 109A 
; 0000 109B             a[1] = a[0]+0x001;  //ster2
; 0000 109C             a[2] = a[4];        //ster4 ABS druciak
; 0000 109D             a[6] = a[5]+0x001;  //okrag
; 0000 109E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 109F 
; 0000 10A0     break;
; 0000 10A1 
; 0000 10A2 
; 0000 10A3      case 144:
_0x13F:
	CPI  R30,LOW(0x90)
	LDI  R26,HIGH(0x90)
	CPC  R31,R26
	BRNE _0xAF
; 0000 10A4 
; 0000 10A5             a[0] = 0x066;   //ster1
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	CALL SUBOPT_0x43
; 0000 10A6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x44
; 0000 10A7             a[4] = 0x1C;    //ster3 ABS krazek scierny
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
_0x548:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 10A8             a[5] = 0x19C;   //delta okrag
	__POINTW1MN _a,10
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
_0x547:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 10A9             a[7] = 0x12;    //ster3 INV krazek scierny
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
_0x545:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 10AA             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	__POINTW1MN _a,18
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
_0x546:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 10AB 
; 0000 10AC             a[1] = a[0]+0x001;  //ster2
	CALL SUBOPT_0x7A
	ADIW R30,1
	__PUTW1MN _a,2
; 0000 10AD             a[2] = a[4];        //ster4 ABS druciak
	CALL SUBOPT_0x7B
	__PUTW1MN _a,4
; 0000 10AE             a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x7D
; 0000 10AF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 10B0 
; 0000 10B1     break;
; 0000 10B2 
; 0000 10B3 
; 0000 10B4 }
_0xAF:
; 0000 10B5 
; 0000 10B6 //if(predkosc_pion_szczotka == 50)   //zwolnienie predkosci pion
; 0000 10B7 //       {
; 0000 10B8 //       a[3] = a[3] - 0x05;
; 0000 10B9 //       }
; 0000 10BA 
; 0000 10BB if(tryb_pracy_szczotki_drucianej == 1)
	CALL SUBOPT_0x7E
	BRNE _0x141
; 0000 10BC          a[3] = a[3];
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x80
; 0000 10BD 
; 0000 10BE if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)
_0x141:
	CALL SUBOPT_0x81
	BREQ _0x142
; 0000 10BF          a[3] = a[3]-0x05;
	CALL SUBOPT_0x7F
	SBIW R30,5
	CALL SUBOPT_0x80
; 0000 10C0 
; 0000 10C1 //if(predkosc_pion_krazek == 50)   //zwolnienie predkosci pion krazek
; 0000 10C2 //       {
; 0000 10C3 //       a[7] = a[7] - 0x05;
; 0000 10C4 //       }
; 0000 10C5 
; 0000 10C6 a[3] = a[3]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT
_0x142:
	CALL SUBOPT_0x7F
	SBIW R30,6
	CALL SUBOPT_0x80
; 0000 10C7 a[2] = a[2]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT
	CALL SUBOPT_0x82
	SBIW R30,6
	__PUTW1MN _a,4
; 0000 10C8 
; 0000 10C9 
; 0000 10CA 
; 0000 10CB if(krazek_scierny_cykl_po_okregu_ilosc == 0 | ruch_haos == 1)
	MOVW R26,R8
	CALL SUBOPT_0x83
	CALL SUBOPT_0x84
	CALL SUBOPT_0x85
	OR   R30,R0
	BREQ _0x143
; 0000 10CC         a[7] = a[7] - 0x05;
	CALL SUBOPT_0x86
	SBIW R30,5
	__PUTW1MN _a,14
; 0000 10CD 
; 0000 10CE if(srednica_krazka_sciernego == 40)
_0x143:
	CALL SUBOPT_0x87
	SBIW R26,40
	BRNE _0x144
; 0000 10CF         a[4] = a[4]+ 0x13;
	CALL SUBOPT_0x7B
	ADIW R30,19
	__PUTW1MN _a,8
; 0000 10D0 
; 0000 10D1                                                      //2
; 0000 10D2 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 30)
_0x144:
	CALL SUBOPT_0x88
	CALL SUBOPT_0x85
	CALL SUBOPT_0x89
; 0000 10D3     {
; 0000 10D4     }
; 0000 10D5 
; 0000 10D6                                                    //2
; 0000 10D7 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 30)
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x89
	BREQ _0x146
; 0000 10D8     {
; 0000 10D9     a[5] = a[5] + 0x10;   //plus 16 dzesietnie
	CALL SUBOPT_0x7C
	ADIW R30,16
	CALL SUBOPT_0x8B
; 0000 10DA     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7D
; 0000 10DB     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10DC     }
; 0000 10DD                                                     //1
; 0000 10DE if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 30)
_0x146:
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x89
	BREQ _0x147
; 0000 10DF     {
; 0000 10E0     a[5] = a[5] + 0x20;   //plus 32 dzesietnie
	CALL SUBOPT_0x7C
	ADIW R30,32
	CALL SUBOPT_0x8B
; 0000 10E1     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7D
; 0000 10E2     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10E3     }
; 0000 10E4 
; 0000 10E5                                                     //2
; 0000 10E6 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 30)
_0x147:
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x89
	BREQ _0x148
; 0000 10E7     {
; 0000 10E8     a[5] = a[5] + 0x30;   //plus 48 dzesietnie
	CALL SUBOPT_0x7C
	ADIW R30,48
	CALL SUBOPT_0x8B
; 0000 10E9     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7D
; 0000 10EA     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10EB     }
; 0000 10EC 
; 0000 10ED /////////////////////////////////////////////////////////////////////////////////////
; 0000 10EE 
; 0000 10EF if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 40)
_0x148:
	CALL SUBOPT_0x88
	CALL SUBOPT_0x85
	CALL SUBOPT_0x8E
	BREQ _0x149
; 0000 10F0     {
; 0000 10F1     a[5] = a[5] + 0x39;   //plus 66 dzesietnie   ///////////////
	CALL SUBOPT_0x7C
	ADIW R30,57
	CALL SUBOPT_0x8B
; 0000 10F2     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7D
; 0000 10F3     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10F4     }
; 0000 10F5 
; 0000 10F6                                                    //2
; 0000 10F7 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 40)
_0x149:
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x8E
	BREQ _0x14A
; 0000 10F8     {
; 0000 10F9     a[5] = a[5] + 0x42;   //plus 16 dzesietnie
	CALL SUBOPT_0x7C
	SUBI R30,LOW(-66)
	SBCI R31,HIGH(-66)
	CALL SUBOPT_0x8B
; 0000 10FA     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7D
; 0000 10FB     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10FC     }
; 0000 10FD                                                     //1
; 0000 10FE if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 40)
_0x14A:
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	BREQ _0x14B
; 0000 10FF     {
; 0000 1100     a[5] = a[5] + 0x4B;   //plus 32 dzesietnie
	CALL SUBOPT_0x7C
	SUBI R30,LOW(-75)
	SBCI R31,HIGH(-75)
	CALL SUBOPT_0x8B
; 0000 1101     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7D
; 0000 1102     a[8] = a[6]+0x001;  //-delta okrag
; 0000 1103     }
; 0000 1104 
; 0000 1105                                                     //2
; 0000 1106 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 40)
_0x14B:
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	BREQ _0x14C
; 0000 1107     {
; 0000 1108     a[5] = a[5] + 0x54;   //plus 48 dzesietnie
	CALL SUBOPT_0x7C
	SUBI R30,LOW(-84)
	SBCI R31,HIGH(-84)
	CALL SUBOPT_0x8B
; 0000 1109     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7D
; 0000 110A     a[8] = a[6]+0x001;  //-delta okrag
; 0000 110B     }
; 0000 110C 
; 0000 110D }
_0x14C:
	ADIW R28,2
	RET
;
;void obsluga_nacisniecia_zatrzymaj()
; 0000 1110 {
_obsluga_nacisniecia_zatrzymaj:
; 0000 1111 int sg;
; 0000 1112 sg = 0;
	CALL SUBOPT_0x2
;	sg -> R16,R17
; 0000 1113 
; 0000 1114   if(sek20 > 60)
	LDS  R26,_sek20
	LDS  R27,_sek20+1
	LDS  R24,_sek20+2
	LDS  R25,_sek20+3
	CALL SUBOPT_0x8F
	BRGE PC+3
	JMP _0x14D
; 0000 1115    {
; 0000 1116    sek20 = 0;
	LDI  R30,LOW(0)
	STS  _sek20,R30
	STS  _sek20+1,R30
	STS  _sek20+2,R30
	STS  _sek20+3,R30
; 0000 1117    while(sprawdz_pin2(PORTMM,0x77) == 0)
_0x14E:
	CALL SUBOPT_0x15
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x150
; 0000 1118         {
; 0000 1119         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x90
; 0000 111A         PORTD.7 = 1;
; 0000 111B         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x153
; 0000 111C            {
; 0000 111D            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x91
; 0000 111E            PORTE.2 = 0;
; 0000 111F            }
; 0000 1120 
; 0000 1121         if(PORTE.3 == 1)
_0x153:
	SBIS 0x3,3
	RJMP _0x156
; 0000 1122            {
; 0000 1123            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x92
; 0000 1124            PORTE.3 = 0;
; 0000 1125            }
; 0000 1126 
; 0000 1127          if(PORT_F.bits.b4 == 1)
_0x156:
	CALL SUBOPT_0x93
	BRNE _0x159
; 0000 1128             {
; 0000 1129             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x94
; 0000 112A             zastopowany_czas_przedmuchu = sek12;
; 0000 112B             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 112C             PORTF = PORT_F.byte;
; 0000 112D             }
; 0000 112E 
; 0000 112F 
; 0000 1130         komunikat_na_panel("                                                ",adr1,adr2);
_0x159:
	CALL SUBOPT_0x2D
; 0000 1131         komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr1,adr2);
	__POINTW1FN _0x0,1351
	CALL SUBOPT_0x2E
; 0000 1132         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 1133         komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr3,adr4);
	__POINTW1FN _0x0,1351
	CALL SUBOPT_0x96
; 0000 1134 
; 0000 1135         }
	RJMP _0x14E
_0x150:
; 0000 1136 
; 0000 1137     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x15A
; 0000 1138         {
; 0000 1139         while(sg == 0)
_0x15B:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x15D
; 0000 113A             {
; 0000 113B             if(sprawdz_pin2(PORTMM,0x77) == 1)
	CALL SUBOPT_0x15
	CALL _sprawdz_pin2
	CPI  R30,LOW(0x1)
	BRNE _0x15E
; 0000 113C                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x18
	MOVW R16,R30
; 0000 113D 
; 0000 113E 
; 0000 113F             }
_0x15E:
	RJMP _0x15B
_0x15D:
; 0000 1140 
; 0000 1141         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 1142         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 1143 
; 0000 1144         PORTD.7 = 0;
	CALL SUBOPT_0x97
; 0000 1145         if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x161
; 0000 1146             {
; 0000 1147             PORTE.2 = 1;
	CALL SUBOPT_0x98
; 0000 1148             byla_wloczona_szlifierka_1 = 0;
; 0000 1149             }
; 0000 114A         if(byla_wloczona_szlifierka_2 == 1)
_0x161:
	CALL SUBOPT_0x99
	BRNE _0x164
; 0000 114B             {
; 0000 114C             PORTE.3 = 1;
	CALL SUBOPT_0x9A
; 0000 114D             byla_wloczona_szlifierka_2 = 0;
; 0000 114E             }
; 0000 114F         if(byl_wloczony_przedmuch == 1)
_0x164:
	CALL SUBOPT_0x9B
	BRNE _0x167
; 0000 1150             {
; 0000 1151             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x9C
; 0000 1152             PORTF = PORT_F.byte;
; 0000 1153             sek12 = zastopowany_czas_przedmuchu;
; 0000 1154             byl_wloczony_przedmuch = 0;
; 0000 1155             }
; 0000 1156         }
_0x167:
; 0000 1157     }
_0x15A:
; 0000 1158 
; 0000 1159 }
_0x14D:
	RJMP _0x20A0003
;
;
;void obsluga_otwarcia_klapy_rzad()
; 0000 115D {
_obsluga_otwarcia_klapy_rzad:
; 0000 115E int sg;
; 0000 115F sg = 0;
	CALL SUBOPT_0x2
;	sg -> R16,R17
; 0000 1160 
; 0000 1161 if(rzad_obrabiany == 1 & start == 1)
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x85
	CALL SUBOPT_0x9E
	AND  R30,R0
	BRNE PC+3
	JMP _0x168
; 0000 1162    {
; 0000 1163    while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x169:
	CALL SUBOPT_0x15
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x16B
; 0000 1164         {
; 0000 1165         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x90
; 0000 1166         PORTD.7 = 1;
; 0000 1167         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x16E
; 0000 1168            {
; 0000 1169            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x91
; 0000 116A            PORTE.2 = 0;
; 0000 116B            }
; 0000 116C 
; 0000 116D         if(PORTE.3 == 1)
_0x16E:
	SBIS 0x3,3
	RJMP _0x171
; 0000 116E            {
; 0000 116F            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x92
; 0000 1170            PORTE.3 = 0;
; 0000 1171            }
; 0000 1172 
; 0000 1173            if(PORT_F.bits.b4 == 1)
_0x171:
	CALL SUBOPT_0x93
	BRNE _0x174
; 0000 1174             {
; 0000 1175             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x94
; 0000 1176             zastopowany_czas_przedmuchu = sek12;
; 0000 1177             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1178             PORTF = PORT_F.byte;
; 0000 1179             }
; 0000 117A 
; 0000 117B 
; 0000 117C         komunikat_na_panel("                                                ",adr1,adr2);
_0x174:
	CALL SUBOPT_0x2D
; 0000 117D         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x2E
; 0000 117E         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 117F         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x96
; 0000 1180 
; 0000 1181         }
	RJMP _0x169
_0x16B:
; 0000 1182     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x175
; 0000 1183         {
; 0000 1184         while(sg == 0)
_0x176:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x178
; 0000 1185             {
; 0000 1186             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	POP  R26
	AND  R30,R26
	BREQ _0x179
; 0000 1187                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x18
	MOVW R16,R30
; 0000 1188 
; 0000 1189 
; 0000 118A             }
_0x179:
	RJMP _0x176
_0x178:
; 0000 118B 
; 0000 118C         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 118D         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 118E 
; 0000 118F         PORTD.7 = 0;
	CALL SUBOPT_0x97
; 0000 1190           if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x17C
; 0000 1191             {
; 0000 1192             PORTE.2 = 1;
	CALL SUBOPT_0x98
; 0000 1193             byla_wloczona_szlifierka_1 = 0;
; 0000 1194             }
; 0000 1195         if(byla_wloczona_szlifierka_2 == 1)
_0x17C:
	CALL SUBOPT_0x99
	BRNE _0x17F
; 0000 1196             {
; 0000 1197             PORTE.3 = 1;
	CALL SUBOPT_0x9A
; 0000 1198             byla_wloczona_szlifierka_2 = 0;
; 0000 1199             }
; 0000 119A         if(byl_wloczony_przedmuch == 1)
_0x17F:
	CALL SUBOPT_0x9B
	BRNE _0x182
; 0000 119B             {
; 0000 119C             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x9C
; 0000 119D             PORTF = PORT_F.byte;
; 0000 119E             sek12 = zastopowany_czas_przedmuchu;
; 0000 119F             byl_wloczony_przedmuch = 0;
; 0000 11A0             }
; 0000 11A1         }
_0x182:
; 0000 11A2    }
_0x175:
; 0000 11A3 
; 0000 11A4 
; 0000 11A5 if(rzad_obrabiany == 2 & start == 1)
_0x168:
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x9E
	AND  R30,R0
	BRNE PC+3
	JMP _0x183
; 0000 11A6    {
; 0000 11A7    while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x184:
	CALL SUBOPT_0x15
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BRNE _0x186
; 0000 11A8         {
; 0000 11A9         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x90
; 0000 11AA         PORTD.7 = 1;
; 0000 11AB         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x189
; 0000 11AC            {
; 0000 11AD            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x91
; 0000 11AE            PORTE.2 = 0;
; 0000 11AF            }
; 0000 11B0 
; 0000 11B1         if(PORTE.3 == 1)
_0x189:
	SBIS 0x3,3
	RJMP _0x18C
; 0000 11B2            {
; 0000 11B3            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x92
; 0000 11B4            PORTE.3 = 0;
; 0000 11B5            }
; 0000 11B6 
; 0000 11B7          if(PORT_F.bits.b4 == 1)
_0x18C:
	CALL SUBOPT_0x93
	BRNE _0x18F
; 0000 11B8             {
; 0000 11B9             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x94
; 0000 11BA             zastopowany_czas_przedmuchu = sek12;
; 0000 11BB             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 11BC             PORTF = PORT_F.byte;
; 0000 11BD             }
; 0000 11BE 
; 0000 11BF         komunikat_na_panel("                                                ",adr1,adr2);
_0x18F:
	CALL SUBOPT_0x2D
; 0000 11C0         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x2E
; 0000 11C1         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 11C2         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x96
; 0000 11C3 
; 0000 11C4         }
	RJMP _0x184
_0x186:
; 0000 11C5     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x190
; 0000 11C6         {
; 0000 11C7         while(sg == 0)
_0x191:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x193
; 0000 11C8             {
; 0000 11C9             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	POP  R26
	AND  R30,R26
	BREQ _0x194
; 0000 11CA                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x18
	MOVW R16,R30
; 0000 11CB 
; 0000 11CC 
; 0000 11CD             }
_0x194:
	RJMP _0x191
_0x193:
; 0000 11CE 
; 0000 11CF         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 11D0         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 11D1 
; 0000 11D2         PORTD.7 = 0;
	CALL SUBOPT_0x97
; 0000 11D3         if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x197
; 0000 11D4             {
; 0000 11D5             PORTE.2 = 1;
	CALL SUBOPT_0x98
; 0000 11D6             byla_wloczona_szlifierka_1 = 0;
; 0000 11D7             }
; 0000 11D8         if(byla_wloczona_szlifierka_2 == 1)
_0x197:
	CALL SUBOPT_0x99
	BRNE _0x19A
; 0000 11D9             {
; 0000 11DA             PORTE.3 = 1;
	CALL SUBOPT_0x9A
; 0000 11DB             byla_wloczona_szlifierka_2 = 0;
; 0000 11DC             }
; 0000 11DD         if(byl_wloczony_przedmuch == 1)
_0x19A:
	CALL SUBOPT_0x9B
	BRNE _0x19D
; 0000 11DE             {
; 0000 11DF             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x9C
; 0000 11E0             PORTF = PORT_F.byte;
; 0000 11E1             sek12 = zastopowany_czas_przedmuchu;
; 0000 11E2             byl_wloczony_przedmuch = 0;
; 0000 11E3             }
; 0000 11E4         }
_0x19D:
; 0000 11E5    }
_0x190:
; 0000 11E6 
; 0000 11E7 
; 0000 11E8 
; 0000 11E9 
; 0000 11EA 
; 0000 11EB }
_0x183:
_0x20A0003:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;void odczyt_parametru_panelu_stala_pamiec(int adres_nieulotny1, int adres_nieulotny2, int dokad_adres1,int dokad_adres2)
; 0000 11EF {
_odczyt_parametru_panelu_stala_pamiec:
; 0000 11F0 
; 0000 11F1 //5AA5 0C 80 56 5A A0 00000000 1010 0010 – Odczyt (A0) z pamiêci FLASH 00000000 do VP 1010
; 0000 11F2 
; 0000 11F3 putchar(90);  //5A
;	adres_nieulotny1 -> Y+6
;	adres_nieulotny2 -> Y+4
;	dokad_adres1 -> Y+2
;	dokad_adres2 -> Y+0
	CALL SUBOPT_0x3
; 0000 11F4 putchar(165); //A5
; 0000 11F5 putchar(12);   //0C
	CALL SUBOPT_0xA0
; 0000 11F6 putchar(128);  //80    /
; 0000 11F7 putchar(86);    //56
; 0000 11F8 putchar(90);   //5A
; 0000 11F9 putchar(160);    //A0
	LDI  R30,LOW(160)
	RJMP _0x20A0002
; 0000 11FA putchar(0);   //00
; 0000 11FB putchar(0);   //00
; 0000 11FC putchar(adres_nieulotny1);   //00
; 0000 11FD putchar(adres_nieulotny2);   //00
; 0000 11FE putchar(dokad_adres1);   //10
; 0000 11FF putchar(dokad_adres2);   //10
; 0000 1200 putchar(0);   //0
; 0000 1201 putchar(10);   //ile danych
; 0000 1202 }
;
;
;
;
;void wartosc_parametru_panelu_stala_pamiec(int adres_nieulotny1,int adres_nieulotny2, int skad_adres1, int skad_adres2)
; 0000 1208 {
_wartosc_parametru_panelu_stala_pamiec:
; 0000 1209 
; 0000 120A //5AA5 0C 80 56 5A 50 00000000 1000 0010 – Zapis (50) z VP 1000 do pamiêci FLASH 00000000
; 0000 120B 
; 0000 120C putchar(90);  //5A
;	adres_nieulotny1 -> Y+6
;	adres_nieulotny2 -> Y+4
;	skad_adres1 -> Y+2
;	skad_adres2 -> Y+0
	CALL SUBOPT_0x3
; 0000 120D putchar(165); //A5
; 0000 120E putchar(12);   //0C
	CALL SUBOPT_0xA0
; 0000 120F putchar(128);  //80    /
; 0000 1210 putchar(86);    //56
; 0000 1211 putchar(90);   //5A
; 0000 1212 putchar(80);    //50
	LDI  R30,LOW(80)
_0x20A0002:
	ST   -Y,R30
	CALL _putchar
; 0000 1213 putchar(0);   //00
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
; 0000 1214 putchar(0);   //00
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
; 0000 1215 putchar(adres_nieulotny1);   //00
	LDD  R30,Y+6
	CALL SUBOPT_0x4
; 0000 1216 putchar(adres_nieulotny2);   //00
; 0000 1217 putchar(skad_adres1);   //10
; 0000 1218 putchar(skad_adres2);   //0
	CALL SUBOPT_0x9
; 0000 1219 putchar(0);   //0
; 0000 121A putchar(10);   //ile danych
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _putchar
; 0000 121B }
	ADIW R28,8
	RET
;
;
;
;
;
;void wartosci_wstepne_wgrac_tylko_raz(int ktore_wgrac)
; 0000 1222 {
_wartosci_wstepne_wgrac_tylko_raz:
; 0000 1223 if(ktore_wgrac == 0)
;	ktore_wgrac -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x19E
; 0000 1224 {
; 0000 1225 szczotka_druciana_ilosc_cykli = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 1226 krazek_scierny_ilosc_cykli = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R6,R30
; 0000 1227 tryb_pracy_szczotki_drucianej = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 1228 krazek_scierny_cykl_po_okregu_ilosc = 0;
	CLR  R8
	CLR  R9
; 0000 1229 czas_pracy_szczotki_drucianej_stala = 150;
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	MOVW R12,R30
; 0000 122A czas_pracy_krazka_sciernego_stala = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _czas_pracy_krazka_sciernego_stala,R30
	STS  _czas_pracy_krazka_sciernego_stala+1,R31
; 0000 122B czas_pracy_szczotki_drucianej_h_17 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_szczotki_drucianej_h_17,R30
	STS  _czas_pracy_szczotki_drucianej_h_17+1,R30
; 0000 122C czas_pracy_szczotki_drucianej_h_15 = 0;
	STS  _czas_pracy_szczotki_drucianej_h_15,R30
	STS  _czas_pracy_szczotki_drucianej_h_15+1,R30
; 0000 122D czas_pracy_krazka_sciernego_h_34 = 0;
	STS  _czas_pracy_krazka_sciernego_h_34,R30
	STS  _czas_pracy_krazka_sciernego_h_34+1,R30
; 0000 122E czas_pracy_krazka_sciernego_h_36 = 0;
	STS  _czas_pracy_krazka_sciernego_h_36,R30
	STS  _czas_pracy_krazka_sciernego_h_36+1,R30
; 0000 122F czas_pracy_krazka_sciernego_h_38 = 0;
	STS  _czas_pracy_krazka_sciernego_h_38,R30
	STS  _czas_pracy_krazka_sciernego_h_38+1,R30
; 0000 1230 czas_pracy_krazka_sciernego_h_41 = 0;
	STS  _czas_pracy_krazka_sciernego_h_41,R30
	STS  _czas_pracy_krazka_sciernego_h_41+1,R30
; 0000 1231 czas_pracy_krazka_sciernego_h_43 = 0;
	STS  _czas_pracy_krazka_sciernego_h_43,R30
	STS  _czas_pracy_krazka_sciernego_h_43+1,R30
; 0000 1232 }
; 0000 1233 
; 0000 1234 
; 0000 1235 wartosc_parametru_panelu(szczotka_druciana_ilosc_cykli,48,64);
_0x19E:
	ST   -Y,R5
	ST   -Y,R4
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA1
	CALL _wartosc_parametru_panelu
; 0000 1236 delay_ms(200);
	CALL SUBOPT_0xA2
; 0000 1237 wartosc_parametru_panelu_stala_pamiec(0,0,48,64);                       //proba
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xA3
; 0000 1238 //putchar(adres_nieulotny1);   //00
; 0000 1239 //putchar(adres_nieulotny2);   //00
; 0000 123A //putchar(skad_adres1);   //10
; 0000 123B //putchar(skad_adres2);   //0
; 0000 123C delay_ms(200);
; 0000 123D odczyt_parametru_panelu_stala_pamiec(0,0,48,64);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xA4
; 0000 123E //putchar(adres_nieulotny1);
; 0000 123F //putchar(adres_nieulotny2);   //00
; 0000 1240 //putchar(dokad_adres1);   //10
; 0000 1241 //putchar(dokad_adres2);   //10
; 0000 1242 delay_ms(200);
; 0000 1243 
; 0000 1244 
; 0000 1245 wartosc_parametru_panelu(krazek_scierny_ilosc_cykli,32,144);
	ST   -Y,R7
	ST   -Y,R6
	CALL SUBOPT_0x31
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA6
; 0000 1246 wartosc_parametru_panelu_stala_pamiec(0,16,32,144);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x31
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA3
; 0000 1247 delay_ms(200);
; 0000 1248 odczyt_parametru_panelu_stala_pamiec(0,16,32,144);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x31
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA4
; 0000 1249 delay_ms(200);
; 0000 124A 
; 0000 124B 
; 0000 124C wartosc_parametru_panelu(krazek_scierny_cykl_po_okregu_ilosc,48,0);
	ST   -Y,R9
	ST   -Y,R8
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA6
; 0000 124D wartosc_parametru_panelu_stala_pamiec(0,32,48,0);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA3
; 0000 124E delay_ms(200);
; 0000 124F odczyt_parametru_panelu_stala_pamiec(0,32,48,0);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA4
; 0000 1250 delay_ms(200);
; 0000 1251 
; 0000 1252 
; 0000 1253 wartosc_parametru_panelu(tryb_pracy_szczotki_drucianej,0,112);
	ST   -Y,R11
	ST   -Y,R10
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA6
; 0000 1254 wartosc_parametru_panelu_stala_pamiec(0,48,0,112);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA3
; 0000 1255 delay_ms(200);
; 0000 1256 odczyt_parametru_panelu_stala_pamiec(0,48,0,112);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA4
; 0000 1257 delay_ms(200);
; 0000 1258 
; 0000 1259 
; 0000 125A 
; 0000 125B wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
	ST   -Y,R13
	ST   -Y,R12
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA6
; 0000 125C wartosc_parametru_panelu_stala_pamiec(0,64,16,112);
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA3
; 0000 125D delay_ms(200);
; 0000 125E odczyt_parametru_panelu_stala_pamiec(0,64,16,112);
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA4
; 0000 125F delay_ms(200);
; 0000 1260 
; 0000 1261 
; 0000 1262 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
	CALL SUBOPT_0xA8
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA6
; 0000 1263 wartosc_parametru_panelu_stala_pamiec(0,80,32,16);
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA3
; 0000 1264 delay_ms(200);
; 0000 1265 odczyt_parametru_panelu_stala_pamiec(0,80,32,16);
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA4
; 0000 1266 delay_ms(200);
; 0000 1267 
; 0000 1268 
; 0000 1269 if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 38 | srednica_wew_korpusu_cyklowa == 41 | srednica_wew_korpusu_cyklowa == 43)
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x83
	CALL SUBOPT_0xAC
	OR   R0,R30
	CALL SUBOPT_0xAD
	CALL SUBOPT_0xAE
	BREQ _0x19F
; 0000 126A {
; 0000 126B wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_17,0,144);
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA6
; 0000 126C wartosc_parametru_panelu_stala_pamiec(0,96,0,144);
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA3
; 0000 126D delay_ms(200);
; 0000 126E odczyt_parametru_panelu_stala_pamiec(0,96,0,144);
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA4
; 0000 126F delay_ms(200);
; 0000 1270 }
; 0000 1271 
; 0000 1272 
; 0000 1273 
; 0000 1274 if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 34 | srednica_wew_korpusu_cyklowa == 36)
_0x19F:
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xB1
	OR   R0,R30
	CALL SUBOPT_0xB2
	BREQ _0x1A0
; 0000 1275 {
; 0000 1276 wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_15,16,128);
	CALL SUBOPT_0xB3
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xB5
; 0000 1277 wartosc_parametru_panelu_stala_pamiec(16,32,16,128);
	CALL SUBOPT_0x31
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xB6
; 0000 1278 delay_ms(200);
; 0000 1279 odczyt_parametru_panelu_stala_pamiec(16,32,16,128);
	CALL SUBOPT_0x31
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xA4
; 0000 127A delay_ms(200);
; 0000 127B }
; 0000 127C 
; 0000 127D 
; 0000 127E if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 34)
_0x1A0:
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xB1
	OR   R30,R0
	BREQ _0x1A1
; 0000 127F {
; 0000 1280 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
	CALL SUBOPT_0xB7
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA6
; 0000 1281 wartosc_parametru_panelu_stala_pamiec(0,112,96,48);
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA3
; 0000 1282 delay_ms(200);
; 0000 1283 odczyt_parametru_panelu_stala_pamiec(0,112,96,48);
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA4
; 0000 1284 delay_ms(200);
; 0000 1285 }
; 0000 1286 
; 0000 1287 if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 36)
_0x1A1:
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xB2
	BREQ _0x1A2
; 0000 1288 {
; 0000 1289 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
	CALL SUBOPT_0xB8
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xA6
; 0000 128A wartosc_parametru_panelu_stala_pamiec(0,128,96,64);
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xA3
; 0000 128B delay_ms(200);
; 0000 128C odczyt_parametru_panelu_stala_pamiec(0,128,96,64);
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xA4
; 0000 128D delay_ms(200);
; 0000 128E }
; 0000 128F 
; 0000 1290 if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 38)
_0x1A2:
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xAC
	OR   R30,R0
	BREQ _0x1A3
; 0000 1291 {
; 0000 1292 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xA6
; 0000 1293 wartosc_parametru_panelu_stala_pamiec(0,144,96,80);
	CALL SUBOPT_0xA5
	CALL SUBOPT_0x24
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xA3
; 0000 1294 delay_ms(200);
; 0000 1295 odczyt_parametru_panelu_stala_pamiec(0,144,96,80);
	CALL SUBOPT_0xA5
	CALL SUBOPT_0x24
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xA4
; 0000 1296 delay_ms(200);
; 0000 1297 }
; 0000 1298 
; 0000 1299 if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 41)
_0x1A3:
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xAD
	OR   R30,R0
	BREQ _0x1A4
; 0000 129A {
; 0000 129B wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
	CALL SUBOPT_0xBB
	CALL SUBOPT_0x24
	CALL SUBOPT_0xB5
; 0000 129C wartosc_parametru_panelu_stala_pamiec(16,0,96,96);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x24
	CALL SUBOPT_0x24
	CALL SUBOPT_0xB6
; 0000 129D delay_ms(200);
; 0000 129E odczyt_parametru_panelu_stala_pamiec(16,0,96,96);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x24
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA4
; 0000 129F delay_ms(200);
; 0000 12A0 }
; 0000 12A1 
; 0000 12A2 if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 43)
_0x1A4:
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xAB
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x1A5
; 0000 12A3 {
; 0000 12A4 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xB5
; 0000 12A5 wartosc_parametru_panelu_stala_pamiec(16,16,96,112);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xB6
; 0000 12A6 delay_ms(200);
; 0000 12A7 odczyt_parametru_panelu_stala_pamiec(16,16,96,112);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA4
; 0000 12A8 delay_ms(200);
; 0000 12A9 }
; 0000 12AA 
; 0000 12AB 
; 0000 12AC 
; 0000 12AD }
_0x1A5:
	ADIW R28,2
	RET
;
;
;
;void zapis_probny_test()
; 0000 12B2 {
; 0000 12B3 int dupa_dupa;
; 0000 12B4 
; 0000 12B5 dupa_dupa = odczytaj_parametr(128,144);             //uruchomienie cyklu przez zapis
;	dupa_dupa -> R16,R17
; 0000 12B6 
; 0000 12B7 if(dupa_dupa == 1)
; 0000 12B8     {
; 0000 12B9 
; 0000 12BA 
; 0000 12BB 
; 0000 12BC      srednica_wew_korpusu_cyklowa = 38;
; 0000 12BD 
; 0000 12BE                              tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
; 0000 12BF                              szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
; 0000 12C0                                krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
; 0000 12C1                                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
; 0000 12C2                                         czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
; 0000 12C3                                         czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
; 0000 12C4 
; 0000 12C5 
; 0000 12C6                              if(srednica_wew_korpusu_cyklowa == 34 | srednica_wew_korpusu_cyklowa == 36)
; 0000 12C7                                  czas_pracy_szczotki_drucianej_h_15++;
; 0000 12C8 
; 0000 12C9                              if(srednica_wew_korpusu_cyklowa == 38 | srednica_wew_korpusu_cyklowa == 41 | srednica_wew_korpusu_cyklowa == 43)
; 0000 12CA                                  czas_pracy_szczotki_drucianej_h_17++;
; 0000 12CB 
; 0000 12CC 
; 0000 12CD                             if(srednica_wew_korpusu_cyklowa == 34)
; 0000 12CE                                 czas_pracy_krazka_sciernego_h_34++;
; 0000 12CF                             if(srednica_wew_korpusu_cyklowa == 36)
; 0000 12D0                                 czas_pracy_krazka_sciernego_h_36++;
; 0000 12D1                             if(srednica_wew_korpusu_cyklowa == 38)
; 0000 12D2                                 czas_pracy_krazka_sciernego_h_38++;
; 0000 12D3                             if(srednica_wew_korpusu_cyklowa == 41)
; 0000 12D4                                 czas_pracy_krazka_sciernego_h_41++;
; 0000 12D5                             if(srednica_wew_korpusu_cyklowa == 43)
; 0000 12D6                                 czas_pracy_krazka_sciernego_h_43++;
; 0000 12D7 
; 0000 12D8                             wartosci_wstepne_wgrac_tylko_raz(1); //to trwa 3s
; 0000 12D9 
; 0000 12DA 
; 0000 12DB                                 //wartosc wstpena panelu
; 0000 12DC                               wartosc_parametru_panelu(0,128,144);
; 0000 12DD 
; 0000 12DE     }
; 0000 12DF 
; 0000 12E0 
; 0000 12E1 }
;
;
;void wartosci_wstepne_panelu()
; 0000 12E5 {
_wartosci_wstepne_panelu:
; 0000 12E6 
; 0000 12E7 delay_ms(200);
	CALL SUBOPT_0xA2
; 0000 12E8 odczyt_parametru_panelu_stala_pamiec(0,0,48,64);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xBD
; 0000 12E9 delay_ms(200);
; 0000 12EA //////////////////////////////////////////////////wartosc_parametru_panelu(szczotka_druciana_ilosc_cykli,48,64);
; 0000 12EB 
; 0000 12EC 
; 0000 12ED odczyt_parametru_panelu_stala_pamiec(0,16,32,144);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x31
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xBD
; 0000 12EE delay_ms(200);
; 0000 12EF /////////////////////////////////////////////////wartosc_parametru_panelu(krazek_scierny_ilosc_cykli,32,144);
; 0000 12F0                                                         //3000
; 0000 12F1 odczyt_parametru_panelu_stala_pamiec(0,32,48,0);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA4
; 0000 12F2 delay_ms(200);
; 0000 12F3 /////////////////////////////////////////////////////////wartosc_parametru_panelu(krazek_scierny_cykl_po_okregu_ilosc,48,0);
; 0000 12F4                                                 //2050
; 0000 12F5 
; 0000 12F6 /////////////////////////
; 0000 12F7 delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0xBE
; 0000 12F8 odczyt_parametru_panelu_stala_pamiec(0,64,16,112);
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xBD
; 0000 12F9 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
; 0000 12FA 
; 0000 12FB delay_ms(200);
; 0000 12FC odczyt_parametru_panelu_stala_pamiec(0,80,32,16);
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xB
	CALL SUBOPT_0xBD
; 0000 12FD /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
; 0000 12FE 
; 0000 12FF delay_ms(200);
; 0000 1300 odczyt_parametru_panelu_stala_pamiec(0,96,0,144);
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA4
; 0000 1301 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_17,0,144);
; 0000 1302 
; 0000 1303 delay_ms(200);
; 0000 1304 odczyt_parametru_panelu_stala_pamiec(16,32,16,128);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x31
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xBD
; 0000 1305 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_15,16,128);
; 0000 1306 
; 0000 1307 delay_ms(200);
; 0000 1308 odczyt_parametru_panelu_stala_pamiec(0,112,96,48);
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xBD
; 0000 1309 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
; 0000 130A 
; 0000 130B delay_ms(200);
; 0000 130C odczyt_parametru_panelu_stala_pamiec(0,128,96,64);
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xBD
; 0000 130D /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
; 0000 130E 
; 0000 130F delay_ms(200);
; 0000 1310 odczyt_parametru_panelu_stala_pamiec(0,144,96,80);
	CALL SUBOPT_0xA5
	CALL SUBOPT_0x24
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xA4
; 0000 1311 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
; 0000 1312 
; 0000 1313 delay_ms(200);
; 0000 1314 odczyt_parametru_panelu_stala_pamiec(16,0,96,96);
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA
	CALL SUBOPT_0x24
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA4
; 0000 1315 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
; 0000 1316 
; 0000 1317 delay_ms(200);
; 0000 1318 odczyt_parametru_panelu_stala_pamiec(16,16,96,112);
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xBD
; 0000 1319 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
; 0000 131A 
; 0000 131B delay_ms(200);
; 0000 131C odczyt_parametru_panelu_stala_pamiec(0,48,0,112);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA4
; 0000 131D delay_ms(200);
; 0000 131E //////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(tryb_pracy_szczotki_drucianej,0,112);
; 0000 131F 
; 0000 1320 
; 0000 1321 //////////////////////////
; 0000 1322 wartosc_parametru_panelu(predkosc_pion_szczotka,32,80);
	LDS  R30,_predkosc_pion_szczotka
	LDS  R31,_predkosc_pion_szczotka+1
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xBA
	CALL _wartosc_parametru_panelu
; 0000 1323                                                 //2060
; 0000 1324 wartosc_parametru_panelu(predkosc_pion_krazek,32,96);
	LDS  R30,_predkosc_pion_krazek
	LDS  R31,_predkosc_pion_krazek+1
	CALL SUBOPT_0xA9
	CALL SUBOPT_0x24
	CALL _wartosc_parametru_panelu
; 0000 1325                                                                        //3010
; 0000 1326 wartosc_parametru_panelu(wejscie_krazka_sciernego_w_pow_boczna_cylindra,48,16);
	LDS  R30,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R31,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	CALL SUBOPT_0xBF
	CALL SUBOPT_0xB
	CALL _wartosc_parametru_panelu
; 0000 1327                                                                      //2070
; 0000 1328 wartosc_parametru_panelu(predkosc_ruchow_po_okregu_krazek_scierny,32,112);
	LDS  R30,_predkosc_ruchow_po_okregu_krazek_scierny
	LDS  R31,_predkosc_ruchow_po_okregu_krazek_scierny+1
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA7
	CALL _wartosc_parametru_panelu
; 0000 1329 wartosc_parametru_panelu(40,48,112);  //srednica krazka wstepnie
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0xBF
	CALL SUBOPT_0xA7
	CALL _wartosc_parametru_panelu
; 0000 132A wartosc_parametru_panelu(145,48,128);   //to do manualnego wczytywania zacisku, ma byc 145
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	CALL SUBOPT_0xBF
	CALL SUBOPT_0xB4
	CALL _wartosc_parametru_panelu
; 0000 132B wartosc_parametru_panelu(1,128,64);   //to do statystyki, zeby zawsze bylo 1
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xA1
	CALL _wartosc_parametru_panelu
; 0000 132C 
; 0000 132D 
; 0000 132E 
; 0000 132F }
	RET
;
;void wypozycjonuj_napedy_minimalistyczna()
; 0000 1332 {
_wypozycjonuj_napedy_minimalistyczna:
; 0000 1333 
; 0000 1334 while(start == 0)
_0x1AE:
	LDS  R30,_start
	LDS  R31,_start+1
	SBIW R30,0
	BRNE _0x1B0
; 0000 1335     {
; 0000 1336     komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 1337     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr1,adr2);
	__POINTW1FN _0x0,1429
	CALL SUBOPT_0x2E
; 0000 1338     komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 1339     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr3,adr4);
	__POINTW1FN _0x0,1429
	CALL SUBOPT_0x96
; 0000 133A     delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0xBE
; 0000 133B     start = odczytaj_parametr(0,64);
	CALL SUBOPT_0x18
	STS  _start,R30
	STS  _start+1,R31
; 0000 133C     }
	RJMP _0x1AE
_0x1B0:
; 0000 133D 
; 0000 133E 
; 0000 133F while(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
_0x1B1:
	CALL SUBOPT_0x15
	CALL SUBOPT_0xC1
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0xC2
	POP  R26
	OR   R30,R26
	BREQ _0x1B3
; 0000 1340     {
; 0000 1341     komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 1342     komunikat_na_panel("Zamknij oslony gorne",adr1,adr2);
	__POINTW1FN _0x0,1470
	CALL SUBOPT_0x2E
; 0000 1343     komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 1344     komunikat_na_panel("Zamknij oslony gorne",adr3,adr4);
	__POINTW1FN _0x0,1470
	CALL SUBOPT_0x96
; 0000 1345     }
	RJMP _0x1B1
_0x1B3:
; 0000 1346 
; 0000 1347 
; 0000 1348 PORTB.4 = 1;   //setupy piony
	SBI  0x18,4
; 0000 1349 
; 0000 134A delay_ms(1000);
	CALL SUBOPT_0xC3
; 0000 134B PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 134C 
; 0000 134D 
; 0000 134E 
; 0000 134F while(sprawdz_pin3(PORTKK,0x75) == 1 | sprawdz_pin7(PORTKK,0x75) == 1)
_0x1B8:
	CALL SUBOPT_0xC4
	CALL SUBOPT_0xC5
	PUSH R30
	CALL SUBOPT_0xC4
	CALL SUBOPT_0xC6
	POP  R26
	OR   R30,R26
	BRNE PC+3
	JMP _0x1BA
; 0000 1350       {
; 0000 1351       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
	CALL SUBOPT_0x15
	CALL SUBOPT_0xC1
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0xC2
	POP  R26
	OR   R30,R26
	BREQ _0x1BB
; 0000 1352         while(1)
_0x1BC:
; 0000 1353             {
; 0000 1354             PORTD.7 = 1;
	CALL SUBOPT_0xC7
; 0000 1355             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 1356 
; 0000 1357             PORTB.4 = 0;   //setupy piony
; 0000 1358             PORTD.2 = 0;   //setup wspolny
; 0000 1359 
; 0000 135A             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 135B             komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1491
	CALL SUBOPT_0x2E
; 0000 135C             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 135D             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xC8
; 0000 135E 
; 0000 135F             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA1
	CALL _wartosc_parametru_panelu
; 0000 1360             }
	RJMP _0x1BC
; 0000 1361 
; 0000 1362 
; 0000 1363       if(sprawdz_pin2(PORTMM,0x77) == 0)
_0x1BB:
	CALL SUBOPT_0x15
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x1C7
; 0000 1364         while(1)
_0x1C8:
; 0000 1365             {
; 0000 1366             PORTD.7 = 1;
	CALL SUBOPT_0xC7
; 0000 1367             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 1368 
; 0000 1369             PORTB.4 = 0;   //setupy piony
; 0000 136A             PORTD.2 = 0;   //setup wspolny
; 0000 136B 
; 0000 136C             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 136D             komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1554
	CALL SUBOPT_0x2E
; 0000 136E             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 136F             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xC8
; 0000 1370 
; 0000 1371             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA1
	CALL _wartosc_parametru_panelu
; 0000 1372             }
	RJMP _0x1C8
; 0000 1373 
; 0000 1374 
; 0000 1375       komunikat_na_panel("                                                ",adr1,adr2);
_0x1C7:
	CALL SUBOPT_0x2D
; 0000 1376       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x2E
; 0000 1377       komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 1378       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x96
; 0000 1379       delay_ms(1000);
	CALL SUBOPT_0xC3
; 0000 137A 
; 0000 137B       if(sprawdz_pin3(PORTKK,0x75) == 0)
	CALL SUBOPT_0xC4
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1D3
; 0000 137C             {
; 0000 137D             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 137E             komunikat_na_panel("Sterownik 3 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1622
	CALL SUBOPT_0x2E
; 0000 137F             delay_ms(1000);
	CALL SUBOPT_0xC3
; 0000 1380             }
; 0000 1381       if(sprawdz_pin7(PORTKK,0x75) == 0)
_0x1D3:
	CALL SUBOPT_0xC4
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x1D4
; 0000 1382             {
; 0000 1383             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 1384             komunikat_na_panel("Sterownik 4 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1653
	CALL SUBOPT_0x2E
; 0000 1385             delay_ms(1000);
	CALL SUBOPT_0xC3
; 0000 1386             }
; 0000 1387 
; 0000 1388 
; 0000 1389       if(sprawdz_pin6(PORTMM,0x77) == 1 |
_0x1D4:
; 0000 138A          sprawdz_pin7(PORTMM,0x77) == 1)
	CALL SUBOPT_0x15
	CALL SUBOPT_0xC9
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0xC6
	POP  R26
	OR   R30,R26
	BREQ _0x1D5
; 0000 138B             {
; 0000 138C             PORTD.7 = 1;
	SBI  0x12,7
; 0000 138D             if(sprawdz_pin6(PORTMM,0x77) == 1)
	CALL SUBOPT_0x15
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x1D8
; 0000 138E                 {
; 0000 138F                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 1390                 komunikat_na_panel("Alarm Sterownik 4",adr1,adr2);
	__POINTW1FN _0x0,1684
	CALL SUBOPT_0x2E
; 0000 1391                 delay_ms(1000);
	CALL SUBOPT_0xC3
; 0000 1392                 }
; 0000 1393             if(sprawdz_pin7(PORTMM,0x77) == 1)
_0x1D8:
	CALL SUBOPT_0x15
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x1D9
; 0000 1394                 {
; 0000 1395                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 1396                 komunikat_na_panel("Alarm Sterownik 3",adr1,adr2);
	__POINTW1FN _0x0,1702
	CALL SUBOPT_0x2E
; 0000 1397                 delay_ms(1000);
	CALL SUBOPT_0xC3
; 0000 1398                 }
; 0000 1399             }
_0x1D9:
; 0000 139A 
; 0000 139B 
; 0000 139C 
; 0000 139D 
; 0000 139E 
; 0000 139F 
; 0000 13A0 
; 0000 13A1 
; 0000 13A2       }
_0x1D5:
	RJMP _0x1B8
_0x1BA:
; 0000 13A3 
; 0000 13A4 PORTB.4 = 0;   //setupy piony
	CBI  0x18,4
; 0000 13A5 PORTD.2 = 1;   //setup poziomy
	SBI  0x12,2
; 0000 13A6 delay_ms(1000);
	CALL SUBOPT_0xC3
; 0000 13A7 
; 0000 13A8 
; 0000 13A9 while(sprawdz_pin3(PORTJJ,0x79) == 1 | sprawdz_pin3(PORTLL,0x71) == 1)
_0x1DE:
	CALL SUBOPT_0x2C
	CALL SUBOPT_0xC5
	PUSH R30
	CALL SUBOPT_0xCA
	CALL SUBOPT_0xC5
	POP  R26
	OR   R30,R26
	BRNE PC+3
	JMP _0x1E0
; 0000 13AA       {
; 0000 13AB 
; 0000 13AC       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
	CALL SUBOPT_0x15
	CALL SUBOPT_0xC1
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0xC2
	POP  R26
	OR   R30,R26
	BREQ _0x1E1
; 0000 13AD         while(1)
_0x1E2:
; 0000 13AE             {
; 0000 13AF             PORTD.7 = 1;
	SBI  0x12,7
; 0000 13B0             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 13B1             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 13B2             komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1491
	CALL SUBOPT_0x2E
; 0000 13B3             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 13B4             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xC8
; 0000 13B5 
; 0000 13B6             PORTB.4 = 0;   //setupy piony
	CBI  0x18,4
; 0000 13B7             PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 13B8 
; 0000 13B9             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA1
	CALL _wartosc_parametru_panelu
; 0000 13BA             }
	RJMP _0x1E2
; 0000 13BB 
; 0000 13BC 
; 0000 13BD       if(sprawdz_pin2(PORTMM,0x77) == 0)
_0x1E1:
	CALL SUBOPT_0x15
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x1ED
; 0000 13BE         while(1)
_0x1EE:
; 0000 13BF             {
; 0000 13C0             PORTD.7 = 1;
	CALL SUBOPT_0xC7
; 0000 13C1             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 13C2 
; 0000 13C3             PORTB.4 = 0;   //setupy piony
; 0000 13C4             PORTD.2 = 0;   //setup wspolny
; 0000 13C5 
; 0000 13C6             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 13C7             komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
	__POINTW1FN _0x0,1554
	CALL SUBOPT_0x2E
; 0000 13C8             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 13C9             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xC8
; 0000 13CA 
; 0000 13CB             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA1
	CALL _wartosc_parametru_panelu
; 0000 13CC             }
	RJMP _0x1EE
; 0000 13CD 
; 0000 13CE       komunikat_na_panel("                                                ",adr1,adr2);
_0x1ED:
	CALL SUBOPT_0x2D
; 0000 13CF       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x2E
; 0000 13D0       komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 13D1       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x96
; 0000 13D2       delay_ms(1000);
	CALL SUBOPT_0xC3
; 0000 13D3 
; 0000 13D4       if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1F9
; 0000 13D5             {
; 0000 13D6             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 13D7             komunikat_na_panel("Sterownik 1 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1720
	CALL SUBOPT_0x2E
; 0000 13D8             delay_ms(1000);
	CALL SUBOPT_0xC3
; 0000 13D9             }
; 0000 13DA       if(sprawdz_pin3(PORTLL,0x71) == 0)
_0x1F9:
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1FA
; 0000 13DB             {
; 0000 13DC             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 13DD             komunikat_na_panel("Sterownik 2 - wypozycjonowalem",adr3,adr4);
	__POINTW1FN _0x0,1751
	CALL SUBOPT_0x96
; 0000 13DE             delay_ms(1000);
	CALL SUBOPT_0xC3
; 0000 13DF             }
; 0000 13E0 
; 0000 13E1        //if(sprawdz_pin7(PORTMM,0x77) == 1)
; 0000 13E2        //     PORTD.7 = 1;
; 0000 13E3 
; 0000 13E4       if(sprawdz_pin5(PORTJJ,0x79) == 1 |
_0x1FA:
; 0000 13E5          sprawdz_pin5(PORTLL,0x71) == 1)
	CALL SUBOPT_0x2C
	CALL SUBOPT_0xCB
	PUSH R30
	CALL SUBOPT_0xCA
	CALL SUBOPT_0xCB
	POP  R26
	OR   R30,R26
	BREQ _0x1FB
; 0000 13E6             {
; 0000 13E7             PORTD.7 = 1;
	SBI  0x12,7
; 0000 13E8             if(sprawdz_pin5(PORTJJ,0x79) == 1)
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x1FE
; 0000 13E9                 {
; 0000 13EA                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 13EB                 komunikat_na_panel("Alarm Sterownik 1",adr1,adr2);
	__POINTW1FN _0x0,1782
	CALL SUBOPT_0x2E
; 0000 13EC                 delay_ms(1000);
	CALL SUBOPT_0xC3
; 0000 13ED                 }
; 0000 13EE             if(sprawdz_pin5(PORTLL,0x71) == 1)
_0x1FE:
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x1FF
; 0000 13EF                 {
; 0000 13F0                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 13F1                 komunikat_na_panel("Alarm Sterownik 2",adr1,adr2);
	__POINTW1FN _0x0,1800
	CALL SUBOPT_0x2E
; 0000 13F2                 delay_ms(1000);
	CALL SUBOPT_0xC3
; 0000 13F3                 }
; 0000 13F4 
; 0000 13F5             }
_0x1FF:
; 0000 13F6 
; 0000 13F7       //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 13F8 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 13F9       //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 13FA        //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 13FB 
; 0000 13FC 
; 0000 13FD 
; 0000 13FE       }
_0x1FB:
	RJMP _0x1DE
_0x1E0:
; 0000 13FF 
; 0000 1400 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 1401 komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1818
	CALL SUBOPT_0x2E
; 0000 1402 komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 1403 komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1818
	CALL SUBOPT_0x96
; 0000 1404 
; 0000 1405 PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 1406 PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 1407 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0xBE
; 0000 1408 wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xCC
; 0000 1409 start = 0;
; 0000 140A 
; 0000 140B }
	RET
;
;
;void przerzucanie_dociskow()
; 0000 140F {
_przerzucanie_dociskow:
; 0000 1410 
; 0000 1411 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x204
; 0000 1412   {
; 0000 1413    if(sprawdz_pin6(PORTLL,0x71) == 0 & sprawdz_pin7(PORTLL,0x71) == 0 & czekaj_az_puszcze == 0)
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin6
	LDI  R26,LOW(0)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin7
	LDI  R26,LOW(0)
	CALL __EQB12
	POP  R26
	CALL SUBOPT_0xCD
	CALL SUBOPT_0xCE
	BREQ _0x205
; 0000 1414            {
; 0000 1415            czekaj_az_puszcze = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 1416            //PORTB.6 = 1;
; 0000 1417            }
; 0000 1418        if(sprawdz_pin6(PORTLL,0x71) == 1 & sprawdz_pin7(PORTLL,0x71) == 1 & czekaj_az_puszcze == 1)
_0x205:
	CALL SUBOPT_0xCA
	CALL SUBOPT_0xC9
	PUSH R30
	CALL SUBOPT_0xCA
	CALL SUBOPT_0xC6
	POP  R26
	CALL SUBOPT_0xCD
	CALL SUBOPT_0x85
	AND  R30,R0
	BREQ _0x206
; 0000 1419            {
; 0000 141A            czekaj_az_puszcze = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 141B            //PORTB.6 = 0;
; 0000 141C            }
; 0000 141D 
; 0000 141E        if(czekaj_az_puszcze == 2 & PORTE.6 == 1)
_0x206:
	CALL SUBOPT_0xCF
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x207
; 0000 141F             {
; 0000 1420             PORTE.6 = 0;
	CBI  0x3,6
; 0000 1421             czekaj_az_puszcze = 0;
	CALL SUBOPT_0xD0
; 0000 1422             delay_ms(100);
; 0000 1423             }
; 0000 1424 
; 0000 1425        if(czekaj_az_puszcze == 2 & PORTE.6 == 0)
_0x207:
	CALL SUBOPT_0xCF
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x20A
; 0000 1426            {
; 0000 1427             PORTE.6 = 1;
	SBI  0x3,6
; 0000 1428             czekaj_az_puszcze = 0;
	CALL SUBOPT_0xD0
; 0000 1429             delay_ms(100);
; 0000 142A            }
; 0000 142B 
; 0000 142C   }
_0x20A:
; 0000 142D }
_0x204:
	RET
;
;void ostateczny_wybor_zacisku()
; 0000 1430 {
_ostateczny_wybor_zacisku:
; 0000 1431 int rzad;
; 0000 1432 
; 0000 1433   if(sek11 > 60) //co 1s sekunde sprawdzam   //jak co 40 to sie wywala
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	LDS  R26,_sek11
	LDS  R27,_sek11+1
	LDS  R24,_sek11+2
	LDS  R25,_sek11+3
	CALL SUBOPT_0x8F
	BRGE PC+3
	JMP _0x20D
; 0000 1434         {
; 0000 1435        sek11 = 0;
	CALL SUBOPT_0xD1
; 0000 1436        if(odczytalem_zacisk < il_prob_odczytu &
; 0000 1437                                            (sprawdz_pin0(PORTHH,0x73) == 1 |
; 0000 1438                                             sprawdz_pin1(PORTHH,0x73) == 1 |
; 0000 1439                                             sprawdz_pin2(PORTHH,0x73) == 1 |
; 0000 143A                                             sprawdz_pin3(PORTHH,0x73) == 1 |
; 0000 143B                                             sprawdz_pin4(PORTHH,0x73) == 1 |
; 0000 143C                                             sprawdz_pin5(PORTHH,0x73) == 1 |
; 0000 143D                                             sprawdz_pin6(PORTHH,0x73) == 1 |
; 0000 143E                                             sprawdz_pin7(PORTHH,0x73) == 1))
	CALL SUBOPT_0xD2
	CALL __LTW12
	PUSH R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0xC1
	PUSH R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0xC2
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
	CALL SUBOPT_0xC5
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
	CALL SUBOPT_0xCB
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0xC9
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0xC6
	POP  R26
	OR   R30,R26
	POP  R26
	AND  R30,R26
	BREQ _0x20E
; 0000 143F         {
; 0000 1440         odczytalem_zacisk++;
	CALL SUBOPT_0xD3
; 0000 1441         }
; 0000 1442         }
_0x20E:
; 0000 1443 
; 0000 1444 if(odczytalem_zacisk == il_prob_odczytu)
_0x20D:
	CALL SUBOPT_0xD2
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x20F
; 0000 1445         {
; 0000 1446         //PORTB = 0xFF;
; 0000 1447         rzad = odczyt_wybranego_zacisku();
	CALL _odczyt_wybranego_zacisku
	MOVW R16,R30
; 0000 1448         //sek10 = 0;
; 0000 1449         sek11 = 0;    //nowe
	CALL SUBOPT_0xD1
; 0000 144A         odczytalem_zacisk++;
	CALL SUBOPT_0xD3
; 0000 144B 
; 0000 144C         //if(rzad == 1)
; 0000 144D         //    wartosc_parametru_panelu(2,32,128);    //tego nie chca
; 0000 144E         //if(rzad == 2)
; 0000 144F         //    wartosc_parametru_panelu(1,32,128);
; 0000 1450 
; 0000 1451         }                                     //& sek10 > 1                //3s po odczytaniu dopiero sprawdzam port
; 0000 1452 if((odczytalem_zacisk == il_prob_odczytu + 1))        //183
_0x20F:
	LDS  R30,_il_prob_odczytu
	LDS  R31,_il_prob_odczytu+1
	ADIW R30,1
	LDS  R26,_odczytalem_zacisk
	LDS  R27,_odczytalem_zacisk+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x210
; 0000 1453         {
; 0000 1454 
; 0000 1455         if(rzad == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x211
; 0000 1456             wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad1
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x24
	CALL _wartosc_parametru_panelu
; 0000 1457 
; 0000 1458         if(rzad == 2 & start == 0)
_0x211:
	MOVW R26,R16
	CALL SUBOPT_0xD4
	MOV  R0,R30
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xCE
	BREQ _0x212
; 0000 1459             wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad2
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL _wartosc_parametru_panelu
; 0000 145A 
; 0000 145B         if(rzad == 2 & start == 1)
_0x212:
	MOVW R26,R16
	CALL SUBOPT_0xD4
	CALL SUBOPT_0x9E
	AND  R30,R0
	BREQ _0x213
; 0000 145C             zaaktualizuj_ilosc_rzad2 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _zaaktualizuj_ilosc_rzad2,R30
	STS  _zaaktualizuj_ilosc_rzad2+1,R31
; 0000 145D 
; 0000 145E 
; 0000 145F         odczytalem_zacisk = 0;
_0x213:
	LDI  R30,LOW(0)
	STS  _odczytalem_zacisk,R30
	STS  _odczytalem_zacisk+1,R30
; 0000 1460         if(start == 1)
	CALL SUBOPT_0xD5
	SBIW R26,1
	BRNE _0x214
; 0000 1461             odczytalem_w_trakcie_czyszczenia_drugiego_rzedu = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu,R30
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1,R31
; 0000 1462         }
_0x214:
; 0000 1463 }
_0x210:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;
;int sterownik_1_praca(int PORT)
; 0000 1468 {
_sterownik_1_praca:
; 0000 1469 //PORTA.0   IN0  STEROWNIK1
; 0000 146A //PORTA.1   IN1  STEROWNIK1
; 0000 146B //PORTA.2   IN2  STEROWNIK1
; 0000 146C //PORTA.3   IN3  STEROWNIK1
; 0000 146D //PORTA.4   IN4  STEROWNIK1
; 0000 146E //PORTA.5   IN5  STEROWNIK1
; 0000 146F //PORTA.6   IN6  STEROWNIK1
; 0000 1470 //PORTA.7   IN7  STEROWNIK1
; 0000 1471 //PORTD.4   IN8 STEROWNIK1
; 0000 1472 
; 0000 1473 //PORTD.2  SETUP   STEROWNIK1
; 0000 1474 //PORTD.3  DRIVE   STEROWNIK1
; 0000 1475 
; 0000 1476 //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 1477 //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 1478 
; 0000 1479 if(sprawdz_pin5(PORTJJ,0x79) == 1)     //if alarn
;	PORT -> Y+0
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x215
; 0000 147A     {
; 0000 147B     PORTD.7 = 1;
	CALL SUBOPT_0xD6
; 0000 147C     PORTE.2 = 0;
; 0000 147D     PORTE.3 = 0;  //szlifierki stop
; 0000 147E     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 147F     PORTF = PORT_F.byte;
; 0000 1480 
; 0000 1481     while(1)
_0x21C:
; 0000 1482         {
; 0000 1483         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 1484         komunikat_na_panel("Kolizja XY ukladu krazka",adr1,adr2);
	__POINTW1FN _0x0,1853
	CALL SUBOPT_0x2E
; 0000 1485         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 1486         komunikat_na_panel("Kolizja XY ukladu krazka",adr3,adr4);
	__POINTW1FN _0x0,1853
	CALL SUBOPT_0x96
; 0000 1487         }
	RJMP _0x21C
; 0000 1488 
; 0000 1489     }
; 0000 148A 
; 0000 148B if(start == 1)
_0x215:
	CALL SUBOPT_0xD5
	SBIW R26,1
	BRNE _0x21F
; 0000 148C     {
; 0000 148D     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xD7
; 0000 148E     obsluga_nacisniecia_zatrzymaj();
; 0000 148F     }
; 0000 1490 switch(cykl_sterownik_1)
_0x21F:
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
; 0000 1491         {
; 0000 1492         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x223
; 0000 1493 
; 0000 1494             sek1 = 0;
	CALL SUBOPT_0xD8
; 0000 1495             PORT_STER1.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER1,R30
; 0000 1496             PORTA.0 = PORT_STER1.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x224
	CBI  0x1B,0
	RJMP _0x225
_0x224:
	SBI  0x1B,0
_0x225:
; 0000 1497             PORTA.1 = PORT_STER1.bits.b1;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x2)
	BRNE _0x226
	CBI  0x1B,1
	RJMP _0x227
_0x226:
	SBI  0x1B,1
_0x227:
; 0000 1498             PORTA.2 = PORT_STER1.bits.b2;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x4)
	BRNE _0x228
	CBI  0x1B,2
	RJMP _0x229
_0x228:
	SBI  0x1B,2
_0x229:
; 0000 1499             PORTA.3 = PORT_STER1.bits.b3;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x8)
	BRNE _0x22A
	CBI  0x1B,3
	RJMP _0x22B
_0x22A:
	SBI  0x1B,3
_0x22B:
; 0000 149A             PORTA.4 = PORT_STER1.bits.b4;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x10)
	BRNE _0x22C
	CBI  0x1B,4
	RJMP _0x22D
_0x22C:
	SBI  0x1B,4
_0x22D:
; 0000 149B             PORTA.5 = PORT_STER1.bits.b5;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x20)
	BRNE _0x22E
	CBI  0x1B,5
	RJMP _0x22F
_0x22E:
	SBI  0x1B,5
_0x22F:
; 0000 149C             PORTA.6 = PORT_STER1.bits.b6;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x40)
	BRNE _0x230
	CBI  0x1B,6
	RJMP _0x231
_0x230:
	SBI  0x1B,6
_0x231:
; 0000 149D             PORTA.7 = PORT_STER1.bits.b7;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x80)
	BRNE _0x232
	CBI  0x1B,7
	RJMP _0x233
_0x232:
	SBI  0x1B,7
_0x233:
; 0000 149E 
; 0000 149F             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x234
; 0000 14A0                 PORTD.4 = 1;
	SBI  0x12,4
; 0000 14A1 
; 0000 14A2 
; 0000 14A3 
; 0000 14A4             cykl_sterownik_1 = 1;
_0x234:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x549
; 0000 14A5 
; 0000 14A6         break;
; 0000 14A7 
; 0000 14A8         case 1:
_0x223:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x237
; 0000 14A9 
; 0000 14AA             if(sek1 > 1)
	LDS  R26,_sek1
	LDS  R27,_sek1+1
	LDS  R24,_sek1+2
	LDS  R25,_sek1+3
	CALL SUBOPT_0xD9
	BRLT _0x238
; 0000 14AB                 {
; 0000 14AC 
; 0000 14AD                 PORTD.3 = 1;
	SBI  0x12,3
; 0000 14AE                 cykl_sterownik_1 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xDA
; 0000 14AF                 }
; 0000 14B0         break;
_0x238:
	RJMP _0x222
; 0000 14B1 
; 0000 14B2 
; 0000 14B3         case 2:
_0x237:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x23B
; 0000 14B4 
; 0000 14B5                if(sprawdz_pin0(PORTJJ,0x79) == 0)     //busy
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x23C
; 0000 14B6                   {
; 0000 14B7 
; 0000 14B8                   PORTD.3 = 0;
	CBI  0x12,3
; 0000 14B9                   PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 14BA                   PORTD.4 = 0;
	CBI  0x12,4
; 0000 14BB                   sek1 = 0;
	CALL SUBOPT_0xD8
; 0000 14BC                   cykl_sterownik_1 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xDA
; 0000 14BD                   }
; 0000 14BE 
; 0000 14BF         break;
_0x23C:
	RJMP _0x222
; 0000 14C0 
; 0000 14C1         case 3:
_0x23B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x241
; 0000 14C2 
; 0000 14C3                if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x242
; 0000 14C4                   {
; 0000 14C5 
; 0000 14C6                   sek1 = 0;
	CALL SUBOPT_0xD8
; 0000 14C7                   cykl_sterownik_1 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xDA
; 0000 14C8                   }
; 0000 14C9 
; 0000 14CA 
; 0000 14CB         break;
_0x242:
	RJMP _0x222
; 0000 14CC 
; 0000 14CD 
; 0000 14CE         case 4:
_0x241:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x222
; 0000 14CF 
; 0000 14D0             if(sprawdz_pin0(PORTJJ,0x79) == 1)
	CALL SUBOPT_0x2C
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x244
; 0000 14D1                 {
; 0000 14D2 
; 0000 14D3                 cykl_sterownik_1 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x549:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
; 0000 14D4                 }
; 0000 14D5         break;
_0x244:
; 0000 14D6 
; 0000 14D7         }
_0x222:
; 0000 14D8 
; 0000 14D9 return cykl_sterownik_1;
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
	RJMP _0x20A0001
; 0000 14DA }
;
;
;int sterownik_2_praca(int PORT)
; 0000 14DE {
_sterownik_2_praca:
; 0000 14DF //PORTC.0   IN0  STEROWNIK2
; 0000 14E0 //PORTC.1   IN1  STEROWNIK2
; 0000 14E1 //PORTC.2   IN2  STEROWNIK2
; 0000 14E2 //PORTC.3   IN3  STEROWNIK2
; 0000 14E3 //PORTC.4   IN4  STEROWNIK2
; 0000 14E4 //PORTC.5   IN5  STEROWNIK2
; 0000 14E5 //PORTC.6   IN6  STEROWNIK2
; 0000 14E6 //PORTC.7   IN7  STEROWNIK2
; 0000 14E7 //PORTD.5   IN8 STEROWNIK2
; 0000 14E8 
; 0000 14E9 
; 0000 14EA //PORTD.5  SETUP   STEROWNIK2
; 0000 14EB //PORTD.6  DRIVE   STEROWNIK2
; 0000 14EC 
; 0000 14ED //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 14EE //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 14EF 
; 0000 14F0  if(sprawdz_pin5(PORTLL,0x71) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x245
; 0000 14F1     {
; 0000 14F2     PORTD.7 = 1;
	CALL SUBOPT_0xD6
; 0000 14F3     PORTE.2 = 0;
; 0000 14F4     PORTE.3 = 0;  //szlifierki stop
; 0000 14F5     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 14F6     PORTF = PORT_F.byte;
; 0000 14F7 
; 0000 14F8     while(1)
_0x24C:
; 0000 14F9         {
; 0000 14FA         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 14FB         komunikat_na_panel("Kolizja XY ukladu szczotki",adr1,adr2);
	__POINTW1FN _0x0,1878
	CALL SUBOPT_0x2E
; 0000 14FC         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 14FD         komunikat_na_panel("Kolizja XY ukladu szczotki",adr3,adr4);
	__POINTW1FN _0x0,1878
	CALL SUBOPT_0x96
; 0000 14FE         }
	RJMP _0x24C
; 0000 14FF 
; 0000 1500     }
; 0000 1501 if(start == 1)
_0x245:
	CALL SUBOPT_0xD5
	SBIW R26,1
	BRNE _0x24F
; 0000 1502     {
; 0000 1503     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xD7
; 0000 1504     obsluga_nacisniecia_zatrzymaj();
; 0000 1505     }
; 0000 1506 switch(cykl_sterownik_2)
_0x24F:
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
; 0000 1507         {
; 0000 1508         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x253
; 0000 1509 
; 0000 150A             sek3 = 0;
	CALL SUBOPT_0xDB
; 0000 150B             PORT_STER2.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER2,R30
; 0000 150C             PORTC.0 = PORT_STER2.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x254
	CBI  0x15,0
	RJMP _0x255
_0x254:
	SBI  0x15,0
_0x255:
; 0000 150D             PORTC.1 = PORT_STER2.bits.b1;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x2)
	BRNE _0x256
	CBI  0x15,1
	RJMP _0x257
_0x256:
	SBI  0x15,1
_0x257:
; 0000 150E             PORTC.2 = PORT_STER2.bits.b2;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x4)
	BRNE _0x258
	CBI  0x15,2
	RJMP _0x259
_0x258:
	SBI  0x15,2
_0x259:
; 0000 150F             PORTC.3 = PORT_STER2.bits.b3;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x8)
	BRNE _0x25A
	CBI  0x15,3
	RJMP _0x25B
_0x25A:
	SBI  0x15,3
_0x25B:
; 0000 1510             PORTC.4 = PORT_STER2.bits.b4;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x10)
	BRNE _0x25C
	CBI  0x15,4
	RJMP _0x25D
_0x25C:
	SBI  0x15,4
_0x25D:
; 0000 1511             PORTC.5 = PORT_STER2.bits.b5;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x20)
	BRNE _0x25E
	CBI  0x15,5
	RJMP _0x25F
_0x25E:
	SBI  0x15,5
_0x25F:
; 0000 1512             PORTC.6 = PORT_STER2.bits.b6;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x40)
	BRNE _0x260
	CBI  0x15,6
	RJMP _0x261
_0x260:
	SBI  0x15,6
_0x261:
; 0000 1513             PORTC.7 = PORT_STER2.bits.b7;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x80)
	BRNE _0x262
	CBI  0x15,7
	RJMP _0x263
_0x262:
	SBI  0x15,7
_0x263:
; 0000 1514             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x264
; 0000 1515                 PORTD.5 = 1;
	SBI  0x12,5
; 0000 1516 
; 0000 1517 
; 0000 1518             cykl_sterownik_2 = 1;
_0x264:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x54A
; 0000 1519 
; 0000 151A 
; 0000 151B         break;
; 0000 151C 
; 0000 151D         case 1:
_0x253:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x267
; 0000 151E 
; 0000 151F             if(sek3 > 1)
	LDS  R26,_sek3
	LDS  R27,_sek3+1
	LDS  R24,_sek3+2
	LDS  R25,_sek3+3
	CALL SUBOPT_0xD9
	BRLT _0x268
; 0000 1520                 {
; 0000 1521                 PORTD.6 = 1;
	SBI  0x12,6
; 0000 1522                 cykl_sterownik_2 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xDC
; 0000 1523                 }
; 0000 1524         break;
_0x268:
	RJMP _0x252
; 0000 1525 
; 0000 1526 
; 0000 1527         case 2:
_0x267:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x26B
; 0000 1528 
; 0000 1529                if(sprawdz_pin0(PORTLL,0x71) == 0)     //busy
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x26C
; 0000 152A                   {
; 0000 152B                   PORTD.6 = 0;
	CBI  0x12,6
; 0000 152C                   PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 152D                   PORTD.5 = 0;
	CBI  0x12,5
; 0000 152E                   sek3 = 0;
	CALL SUBOPT_0xDB
; 0000 152F                   cykl_sterownik_2 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xDC
; 0000 1530                   }
; 0000 1531 
; 0000 1532         break;
_0x26C:
	RJMP _0x252
; 0000 1533 
; 0000 1534         case 3:
_0x26B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x271
; 0000 1535 
; 0000 1536                if(sprawdz_pin3(PORTLL,0x71) == 0)
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x272
; 0000 1537                   {
; 0000 1538                   sek3 = 0;
	CALL SUBOPT_0xDB
; 0000 1539                   cykl_sterownik_2 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xDC
; 0000 153A                   }
; 0000 153B 
; 0000 153C 
; 0000 153D         break;
_0x272:
	RJMP _0x252
; 0000 153E 
; 0000 153F 
; 0000 1540         case 4:
_0x271:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x252
; 0000 1541 
; 0000 1542             if(sprawdz_pin0(PORTLL,0x71) == 1)
	CALL SUBOPT_0xCA
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x274
; 0000 1543                 {
; 0000 1544                 cykl_sterownik_2 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x54A:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
; 0000 1545                 }
; 0000 1546         break;
_0x274:
; 0000 1547 
; 0000 1548         }
_0x252:
; 0000 1549 
; 0000 154A return cykl_sterownik_2;
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
	RJMP _0x20A0001
; 0000 154B }
;
;
;
;
;
;
;int sterownik_3_praca(int PORT)
; 0000 1553 {
_sterownik_3_praca:
; 0000 1554 //PORTF.0   IN0  STEROWNIK3
; 0000 1555 //PORTF.1   IN1  STEROWNIK3
; 0000 1556 //PORTF.2   IN2  STEROWNIK3
; 0000 1557 //PORTF.3   IN3  STEROWNIK3
; 0000 1558 //PORTF.7   IN4 STEROWNIK 3
; 0000 1559 //PORTB.7   IN5 STEROWNIK 3
; 0000 155A 
; 0000 155B 
; 0000 155C 
; 0000 155D //PORTF.5   DRIVE  STEROWNIK3
; 0000 155E 
; 0000 155F //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 1560 //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 1561 
; 0000 1562 if(sprawdz_pin7(PORTMM,0x77) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0x15
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x275
; 0000 1563      {
; 0000 1564      PORTD.7 = 1;
	CALL SUBOPT_0xD6
; 0000 1565      PORTE.2 = 0;
; 0000 1566      PORTE.3 = 0;  //szlifierki stop
; 0000 1567      PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1568      PORTF = PORT_F.byte;
; 0000 1569 
; 0000 156A      while(1)
_0x27C:
; 0000 156B         {
; 0000 156C         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 156D         komunikat_na_panel("Kolizja krazka - wylacz i wlacz maszyne",adr1,adr2);
	__POINTW1FN _0x0,1905
	CALL SUBOPT_0x2E
; 0000 156E         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 156F         komunikat_na_panel("Kolizja krazka - wylacz i wlacz maszyne",adr3,adr4);
	__POINTW1FN _0x0,1905
	CALL SUBOPT_0x96
; 0000 1570         }
	RJMP _0x27C
; 0000 1571      }
; 0000 1572 if(start == 1)
_0x275:
	CALL SUBOPT_0xD5
	SBIW R26,1
	BRNE _0x27F
; 0000 1573     {
; 0000 1574     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xD7
; 0000 1575     obsluga_nacisniecia_zatrzymaj();
; 0000 1576 
; 0000 1577     }
; 0000 1578 switch(cykl_sterownik_3)
_0x27F:
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
; 0000 1579         {
; 0000 157A         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x283
; 0000 157B 
; 0000 157C             PORT_STER3.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER3,R30
; 0000 157D             PORT_F.bits.b0 = PORT_STER3.bits.b0;
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0xDD
; 0000 157E             PORT_F.bits.b1 = PORT_STER3.bits.b1;
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFD
	CALL SUBOPT_0xDD
; 0000 157F             PORT_F.bits.b2 = PORT_STER3.bits.b2;
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFB
	CALL SUBOPT_0xDD
; 0000 1580             PORT_F.bits.b3 = PORT_STER3.bits.b3;
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
	CALL SUBOPT_0xDD
; 0000 1581             PORT_F.bits.b7 = PORT_STER3.bits.b4;
	SWAP R30
	ANDI R30,LOW(0x1)
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0x7F
	OR   R30,R0
	CALL SUBOPT_0xDE
; 0000 1582             PORTF = PORT_F.byte;
; 0000 1583             PORTB.7 = PORT_STER3.bits.b5;
	LDS  R30,_PORT_STER3
	ANDI R30,LOW(0x20)
	BRNE _0x284
	CBI  0x18,7
	RJMP _0x285
_0x284:
	SBI  0x18,7
_0x285:
; 0000 1584 
; 0000 1585 
; 0000 1586 
; 0000 1587             sek2 = 0;
	CALL SUBOPT_0xDF
; 0000 1588             cykl_sterownik_3 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0xE0
; 0000 1589 
; 0000 158A 
; 0000 158B 
; 0000 158C         break;
	RJMP _0x282
; 0000 158D 
; 0000 158E         case 1:
_0x283:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x286
; 0000 158F 
; 0000 1590 
; 0000 1591             if(sek2 > 1)
	LDS  R26,_sek2
	LDS  R27,_sek2+1
	LDS  R24,_sek2+2
	LDS  R25,_sek2+3
	CALL SUBOPT_0xD9
	BRLT _0x287
; 0000 1592                 {
; 0000 1593 
; 0000 1594                 PORT_F.bits.b5 = 1;
	LDS  R30,_PORT_F
	ORI  R30,0x20
	CALL SUBOPT_0xDE
; 0000 1595                 PORTF = PORT_F.byte;
; 0000 1596                 cykl_sterownik_3 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xE0
; 0000 1597                 }
; 0000 1598         break;
_0x287:
	RJMP _0x282
; 0000 1599 
; 0000 159A 
; 0000 159B         case 2:
_0x286:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x288
; 0000 159C 
; 0000 159D 
; 0000 159E                if(sprawdz_pin0(PORTKK,0x75) == 0)
	CALL SUBOPT_0xC4
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x289
; 0000 159F                   {
; 0000 15A0                   PORT_F.bits.b5 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xDF
	CALL SUBOPT_0xDE
; 0000 15A1                   PORTF = PORT_F.byte;
; 0000 15A2 
; 0000 15A3                   PORT_F.bits.b0 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0xE1
; 0000 15A4                   PORT_F.bits.b1 = 0;
	ANDI R30,0xFD
	CALL SUBOPT_0xE1
; 0000 15A5                   PORT_F.bits.b2 = 0;
	ANDI R30,0xFB
	CALL SUBOPT_0xE1
; 0000 15A6                   PORT_F.bits.b3 = 0;
	ANDI R30,0XF7
	CALL SUBOPT_0xE1
; 0000 15A7                   PORT_F.bits.b7 = 0;
	ANDI R30,0x7F
	CALL SUBOPT_0xDE
; 0000 15A8                   PORTF = PORT_F.byte;
; 0000 15A9                   PORTB.7 = 0;
	CBI  0x18,7
; 0000 15AA 
; 0000 15AB                   sek2 = 0;
	CALL SUBOPT_0xDF
; 0000 15AC                   cykl_sterownik_3 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xE0
; 0000 15AD                   }
; 0000 15AE 
; 0000 15AF         break;
_0x289:
	RJMP _0x282
; 0000 15B0 
; 0000 15B1         case 3:
_0x288:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x28C
; 0000 15B2 
; 0000 15B3 
; 0000 15B4                if(sprawdz_pin3(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0xC4
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x28D
; 0000 15B5                   {
; 0000 15B6                   sek2 = 0;
	CALL SUBOPT_0xDF
; 0000 15B7                   cykl_sterownik_3 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xE0
; 0000 15B8                   }
; 0000 15B9 
; 0000 15BA 
; 0000 15BB         break;
_0x28D:
	RJMP _0x282
; 0000 15BC 
; 0000 15BD 
; 0000 15BE         case 4:
_0x28C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x282
; 0000 15BF 
; 0000 15C0               if(sprawdz_pin0(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0xC4
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x28F
; 0000 15C1                 {
; 0000 15C2                 cykl_sterownik_3 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0xE0
; 0000 15C3 
; 0000 15C4 
; 0000 15C5                 switch(cykl_sterownik_3_wykonalem)
	LDS  R30,_cykl_sterownik_3_wykonalem
	LDS  R31,_cykl_sterownik_3_wykonalem+1
; 0000 15C6                     {
; 0000 15C7                     case 0:
	SBIW R30,0
	BRNE _0x293
; 0000 15C8                             cykl_sterownik_3_wykonalem = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R31
; 0000 15C9                     break;
	RJMP _0x292
; 0000 15CA 
; 0000 15CB                     case 1:
_0x293:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x292
; 0000 15CC                             cykl_sterownik_3_wykonalem = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R30
; 0000 15CD                     break;
; 0000 15CE 
; 0000 15CF                     }
_0x292:
; 0000 15D0 
; 0000 15D1 
; 0000 15D2                 }
; 0000 15D3         break;
_0x28F:
; 0000 15D4 
; 0000 15D5         }
_0x282:
; 0000 15D6 
; 0000 15D7 return cykl_sterownik_3;
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
_0x20A0001:
	ADIW R28,2
	RET
; 0000 15D8 }
;
;//
;//int sterownik_4_praca(char f,char e,char d, char c, char b, char a)
;int sterownik_4_praca(int PORT,int p)
; 0000 15DD {
_sterownik_4_praca:
; 0000 15DE 
; 0000 15DF 
; 0000 15E0 //PORTB.0   IN0  STEROWNIK4
; 0000 15E1 //PORTB.1   IN1  STEROWNIK4
; 0000 15E2 //PORTB.2   IN2  STEROWNIK4
; 0000 15E3 //PORTB.3   IN3  STEROWNIK4
; 0000 15E4 //PORTE.4  IN4  STEROWNIK4
; 0000 15E5 
; 0000 15E6 
; 0000 15E7 
; 0000 15E8 //PORTB.4   SETUP  STEROWNIK4
; 0000 15E9 //PORTB.5   DRIVE  STEROWNIK4
; 0000 15EA 
; 0000 15EB //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 15EC //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 15ED 
; 0000 15EE if(sprawdz_pin6(PORTMM,0x77) == 1)
;	PORT -> Y+2
;	p -> Y+0
	CALL SUBOPT_0x15
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x295
; 0000 15EF     {
; 0000 15F0     PORTD.7 = 1;
	CALL SUBOPT_0xD6
; 0000 15F1     PORTE.2 = 0;
; 0000 15F2     PORTE.3 = 0;
; 0000 15F3     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 15F4     PORTF = PORT_F.byte;
; 0000 15F5 
; 0000 15F6     while(1)
_0x29C:
; 0000 15F7         {
; 0000 15F8         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2D
; 0000 15F9         komunikat_na_panel("Kolizja szcz. drucianej - wylacz i wlacz maszyne",adr1,adr2);
	__POINTW1FN _0x0,1945
	CALL SUBOPT_0x2E
; 0000 15FA         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x95
; 0000 15FB         komunikat_na_panel("Kolizja szcz. drucianej - wylacz i wlacz maszyne",adr3,adr4);
	__POINTW1FN _0x0,1945
	CALL SUBOPT_0x96
; 0000 15FC         }
	RJMP _0x29C
; 0000 15FD 
; 0000 15FE     }
; 0000 15FF if(start == 1)
_0x295:
	CALL SUBOPT_0xD5
	SBIW R26,1
	BRNE _0x29F
; 0000 1600     {
; 0000 1601     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xD7
; 0000 1602     obsluga_nacisniecia_zatrzymaj();
; 0000 1603     }
; 0000 1604 switch(cykl_sterownik_4)
_0x29F:
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
; 0000 1605         {
; 0000 1606         case 0:
	SBIW R30,0
	BRNE _0x2A3
; 0000 1607 
; 0000 1608             PORT_STER4.byte = PORT;
	LDD  R30,Y+2
	STS  _PORT_STER4,R30
; 0000 1609             PORTB.0 = PORT_STER4.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x2A4
	CBI  0x18,0
	RJMP _0x2A5
_0x2A4:
	SBI  0x18,0
_0x2A5:
; 0000 160A             PORTB.1 = PORT_STER4.bits.b1;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x2)
	BRNE _0x2A6
	CBI  0x18,1
	RJMP _0x2A7
_0x2A6:
	SBI  0x18,1
_0x2A7:
; 0000 160B             PORTB.2 = PORT_STER4.bits.b2;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x4)
	BRNE _0x2A8
	CBI  0x18,2
	RJMP _0x2A9
_0x2A8:
	SBI  0x18,2
_0x2A9:
; 0000 160C             PORTB.3 = PORT_STER4.bits.b3;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x8)
	BRNE _0x2AA
	CBI  0x18,3
	RJMP _0x2AB
_0x2AA:
	SBI  0x18,3
_0x2AB:
; 0000 160D             PORTE.4 = PORT_STER4.bits.b4;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x10)
	BRNE _0x2AC
	CBI  0x3,4
	RJMP _0x2AD
_0x2AC:
	SBI  0x3,4
_0x2AD:
; 0000 160E 
; 0000 160F 
; 0000 1610             sek4 = 0;
	CALL SUBOPT_0xE2
; 0000 1611             cykl_sterownik_4 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x54B
; 0000 1612 
; 0000 1613         break;
; 0000 1614 
; 0000 1615         case 1:
_0x2A3:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2AE
; 0000 1616 
; 0000 1617             if(sek4 > 1)
	LDS  R26,_sek4
	LDS  R27,_sek4+1
	LDS  R24,_sek4+2
	LDS  R25,_sek4+3
	CALL SUBOPT_0xD9
	BRLT _0x2AF
; 0000 1618                 {
; 0000 1619                 PORTB.5 = 1;
	SBI  0x18,5
; 0000 161A                 cykl_sterownik_4 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xE3
; 0000 161B                 }
; 0000 161C         break;
_0x2AF:
	RJMP _0x2A2
; 0000 161D 
; 0000 161E 
; 0000 161F         case 2:
_0x2AE:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2B2
; 0000 1620 
; 0000 1621                if(sprawdz_pin4(PORTKK,0x75) == 0)
	CALL SUBOPT_0xC4
	CALL _sprawdz_pin4
	CPI  R30,0
	BRNE _0x2B3
; 0000 1622                   {
; 0000 1623                   PORTB.5 = 0;  //drive
	CBI  0x18,5
; 0000 1624 
; 0000 1625                   PORTB.0 = 0;
	CBI  0x18,0
; 0000 1626                   PORTB.1 = 0;
	CBI  0x18,1
; 0000 1627                   PORTB.2 = 0;
	CBI  0x18,2
; 0000 1628                   PORTB.3 = 0;
	CBI  0x18,3
; 0000 1629                   PORTE.4 = 0;
	CBI  0x3,4
; 0000 162A 
; 0000 162B 
; 0000 162C                   sek4 = 0;
	CALL SUBOPT_0xE2
; 0000 162D                   cykl_sterownik_4 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xE3
; 0000 162E                   }
; 0000 162F 
; 0000 1630         break;
_0x2B3:
	RJMP _0x2A2
; 0000 1631 
; 0000 1632         case 3:
_0x2B2:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2C0
; 0000 1633 
; 0000 1634                if(sprawdz_pin7(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0xC4
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x2C1
; 0000 1635                   {
; 0000 1636                   //if(p == 1)
; 0000 1637                   //  PORTE.2 = 1;  //wylaczam do testu
; 0000 1638 
; 0000 1639                   sek4 = 0;
	CALL SUBOPT_0xE2
; 0000 163A                   cykl_sterownik_4 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xE3
; 0000 163B                   }
; 0000 163C 
; 0000 163D 
; 0000 163E         break;
_0x2C1:
	RJMP _0x2A2
; 0000 163F 
; 0000 1640 
; 0000 1641         case 4:
_0x2C0:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2A2
; 0000 1642 
; 0000 1643               if(sprawdz_pin4(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0xC4
	CALL _sprawdz_pin4
	CPI  R30,LOW(0x1)
	BRNE _0x2C3
; 0000 1644                 {
; 0000 1645                 cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x54B:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
; 0000 1646                 }
; 0000 1647         break;
_0x2C3:
; 0000 1648 
; 0000 1649         }
_0x2A2:
; 0000 164A 
; 0000 164B return cykl_sterownik_4;
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
	ADIW R28,4
	RET
; 0000 164C }
;
;
;void test_geometryczny()
; 0000 1650 {
_test_geometryczny:
; 0000 1651 int cykl_testu,d;
; 0000 1652 int ff[12];
; 0000 1653 int i;
; 0000 1654 d = 0;
	SBIW R28,24
	CALL __SAVELOCR6
;	cykl_testu -> R16,R17
;	d -> R18,R19
;	ff -> Y+6
;	i -> R20,R21
	__GETWRN 18,19,0
; 0000 1655 cykl_testu = 0;
	__GETWRN 16,17,0
; 0000 1656 
; 0000 1657 for(i=0;i<11;i++)
	__GETWRN 20,21,0
_0x2C5:
	__CPWRN 20,21,11
	BRGE _0x2C6
; 0000 1658      ff[i]=0;
	MOVW R30,R20
	CALL SUBOPT_0xE4
	CALL SUBOPT_0x3F
	__ADDWRN 20,21,1
	RJMP _0x2C5
_0x2C6:
; 0000 165B manualny_wybor_zacisku = 145;
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	STS  _manualny_wybor_zacisku,R30
	STS  _manualny_wybor_zacisku+1,R31
; 0000 165C manualny_wybor_zacisku = odczytaj_parametr(48,128);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x19
	STS  _manualny_wybor_zacisku,R30
	STS  _manualny_wybor_zacisku+1,R31
; 0000 165D 
; 0000 165E if(manualny_wybor_zacisku != 145)
	LDS  R26,_manualny_wybor_zacisku
	LDS  R27,_manualny_wybor_zacisku+1
	CPI  R26,LOW(0x91)
	LDI  R30,HIGH(0x91)
	CPC  R27,R30
	BREQ _0x2C7
; 0000 165F     {
; 0000 1660     macierz_zaciskow[1] = manualny_wybor_zacisku;
	LDS  R30,_manualny_wybor_zacisku
	LDS  R31,_manualny_wybor_zacisku+1
	__PUTW1MN _macierz_zaciskow,2
; 0000 1661     macierz_zaciskow[2] = manualny_wybor_zacisku;
	__PUTW1MN _macierz_zaciskow,4
; 0000 1662     }
; 0000 1663 
; 0000 1664                                                                    //swiatlo czer       //swiatlo zolte
; 0000 1665 if(test_geometryczny_rzad_1 == 1 & test_geometryczny_rzad_2 == 0 & PORTD.7 == 0  & PORT_F.bits.b6 == 0 &
_0x2C7:
; 0000 1666     il_zaciskow_rzad_1 > 1 & macierz_zaciskow[1]!=0 & sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0xE5
	CALL SUBOPT_0x85
	MOV  R0,R30
	CALL SUBOPT_0xE6
	CALL SUBOPT_0xE7
	CALL SUBOPT_0xE8
	CALL SUBOPT_0xE9
	CALL SUBOPT_0xEA
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x2C8
; 0000 1667     {
; 0000 1668     while(test_geometryczny_rzad_1 == 1)
_0x2C9:
	CALL SUBOPT_0xE5
	SBIW R26,1
	BREQ PC+3
	JMP _0x2CB
; 0000 1669         {
; 0000 166A         switch(cykl_testu)
	MOVW R30,R16
; 0000 166B             {
; 0000 166C              case 0:
	SBIW R30,0
	BRNE _0x2CF
; 0000 166D 
; 0000 166E                wybor_linijek_sterownikow(1);
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xEB
; 0000 166F                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1670                cykl_sterownik_1 = 0;
; 0000 1671                cykl_sterownik_2 = 0;
; 0000 1672                cykl_sterownik_3 = 0;
; 0000 1673                cykl_sterownik_4 = 0;
; 0000 1674                wybor_linijek_sterownikow(1);
	CALL SUBOPT_0xC0
	CALL _wybor_linijek_sterownikow
; 0000 1675                cykl_testu = 1;
	__GETWRN 16,17,1
; 0000 1676 
; 0000 1677 
; 0000 1678 
; 0000 1679             break;
	RJMP _0x2CE
; 0000 167A 
; 0000 167B             case 1:
_0x2CF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2D2
; 0000 167C 
; 0000 167D             //na sam dol zjezdzamy pionami
; 0000 167E                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x2D3
; 0000 167F                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xED
; 0000 1680                 if(cykl_sterownik_4 < 5)
_0x2D3:
	CALL SUBOPT_0xEE
	SBIW R26,5
	BRGE _0x2D4
; 0000 1681                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 1682 
; 0000 1683                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2D4:
	CALL SUBOPT_0xF0
	BREQ _0x2D5
; 0000 1684                                         {
; 0000 1685                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF1
; 0000 1686                                         cykl_sterownik_4 = 0;
; 0000 1687                                         cykl_testu = 2;
	__GETWRN 16,17,2
; 0000 1688                                         }
; 0000 1689 
; 0000 168A 
; 0000 168B 
; 0000 168C             break;
_0x2D5:
	RJMP _0x2CE
; 0000 168D 
; 0000 168E 
; 0000 168F             case 2:
_0x2D2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2D6
; 0000 1690 
; 0000 1691                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x2D7
; 0000 1692                                     cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0xA
	CALL SUBOPT_0xF3
; 0000 1693                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy
_0x2D7:
	CALL SUBOPT_0xF4
	SBIW R26,5
	BRGE _0x2D8
; 0000 1694                                     cykl_sterownik_2 = sterownik_2_praca(0x008);       //ster 2 ucieczka do zera (druciak)
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF6
; 0000 1695 
; 0000 1696                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x2D8:
	CALL SUBOPT_0xF7
	BREQ _0x2D9
; 0000 1697                                         {
; 0000 1698                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 1699                                         cykl_sterownik_2 = 0;
; 0000 169A                                         cykl_sterownik_3 = 0;
; 0000 169B                                         cykl_sterownik_4 = 0;
; 0000 169C                                         cykl_testu = 3;
	__GETWRN 16,17,3
; 0000 169D 
; 0000 169E                                         }
; 0000 169F 
; 0000 16A0             break;
_0x2D9:
	RJMP _0x2CE
; 0000 16A1 
; 0000 16A2 
; 0000 16A3             case 3:
_0x2D6:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2DA
; 0000 16A4 
; 0000 16A5                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x2DB
; 0000 16A6                                     cykl_sterownik_1 = sterownik_1_praca(a[0]); //ster 1 pod srodek zacisku
	CALL SUBOPT_0xF9
	CALL SUBOPT_0xF3
; 0000 16A7 
; 0000 16A8                                     if(cykl_sterownik_1 == 5)
_0x2DB:
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRNE _0x2DC
; 0000 16A9                                         {
; 0000 16AA                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 16AB                                         cykl_sterownik_2 = 0;
; 0000 16AC                                         cykl_sterownik_3 = 0;
; 0000 16AD                                         cykl_sterownik_4 = 0;
; 0000 16AE                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 16AF                                         }
; 0000 16B0 
; 0000 16B1             break;
_0x2DC:
	RJMP _0x2CE
; 0000 16B2 
; 0000 16B3             case 4:
_0x2DA:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2DD
; 0000 16B4 
; 0000 16B5                                    if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x2DE
; 0000 16B6                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
	CALL SUBOPT_0x7B
	CALL SUBOPT_0xFA
; 0000 16B7 
; 0000 16B8                                    if(cykl_sterownik_3 == 5)
_0x2DE:
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRNE _0x2DF
; 0000 16B9                                         {
; 0000 16BA                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 16BB                                         cykl_sterownik_2 = 0;
; 0000 16BC                                         cykl_sterownik_3 = 0;
; 0000 16BD                                         cykl_sterownik_4 = 0;
; 0000 16BE                                         cykl_testu = 5;
	__GETWRN 16,17,5
; 0000 16BF                                         }
; 0000 16C0 
; 0000 16C1             break;
_0x2DF:
	RJMP _0x2CE
; 0000 16C2 
; 0000 16C3             case 5:
_0x2DD:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2E0
; 0000 16C4                                    if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x2E1
; 0000 16C5                                    {
; 0000 16C6                                      d = odczytaj_parametr(48,80);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x27
	MOVW R18,R30
; 0000 16C7                                         if(d == 0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x2E2
; 0000 16C8                                             cykl_testu = 666;
	__GETWRN 16,17,666
; 0000 16C9 
; 0000 16CA                                         if(d == 2 & ff[2] == 0)
_0x2E2:
	MOVW R26,R18
	CALL SUBOPT_0xD4
	MOV  R0,R30
	CALL SUBOPT_0x11
	BREQ _0x2E3
; 0000 16CB                                             {
; 0000 16CC                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 16CD                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 16CE                                             }
; 0000 16CF                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
_0x2E3:
	CALL SUBOPT_0xFC
	AND  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0xCE
	BREQ _0x2E4
; 0000 16D0                                             {
; 0000 16D1                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 16D2                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 16D3                                             }
; 0000 16D4                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
_0x2E4:
	CALL SUBOPT_0xFD
	AND  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0xCE
	BREQ _0x2E5
; 0000 16D5                                             {
; 0000 16D6                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 16D7                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 16D8                                             }
; 0000 16D9                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
_0x2E5:
	CALL SUBOPT_0xFE
	AND  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0xCE
	BREQ _0x2E6
; 0000 16DA                                             {
; 0000 16DB                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 16DC                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 16DD                                             }
; 0000 16DE                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
_0x2E6:
	CALL SUBOPT_0xFF
	AND  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0xCE
	BREQ _0x2E7
; 0000 16DF                                             {
; 0000 16E0                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 16E1                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 16E2                                             }
; 0000 16E3                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
_0x2E7:
	CALL SUBOPT_0x100
	AND  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0xCE
	BREQ _0x2E8
; 0000 16E4                                             {
; 0000 16E5                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 16E6                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 16E7                                             }
; 0000 16E8                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
_0x2E8:
	CALL SUBOPT_0x101
	AND  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0xCE
	BREQ _0x2E9
; 0000 16E9                                             {
; 0000 16EA                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 16EB                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 16EC                                             }
; 0000 16ED                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
_0x2E9:
	CALL SUBOPT_0x102
	AND  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CALL SUBOPT_0xCE
	BREQ _0x2EA
; 0000 16EE                                             {
; 0000 16EF                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 16F0                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 16F1                                             }
; 0000 16F2                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
_0x2EA:
	CALL SUBOPT_0x103
	AND  R0,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL SUBOPT_0xCE
	BREQ _0x2EB
; 0000 16F3                                             {
; 0000 16F4                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 16F5                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 16F6                                             }
; 0000 16F7                                     }
_0x2EB:
; 0000 16F8 
; 0000 16F9             break;
_0x2E1:
	RJMP _0x2CE
; 0000 16FA 
; 0000 16FB             case 6:
_0x2E0:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2EC
; 0000 16FC                                      if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x2ED
; 0000 16FD                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xED
; 0000 16FE                                         if(cykl_sterownik_3 == 5)
_0x2ED:
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRNE _0x2EE
; 0000 16FF                                             {
; 0000 1700                                             cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 1701                                             cykl_sterownik_2 = 0;
; 0000 1702                                             cykl_sterownik_3 = 0;
; 0000 1703                                             cykl_sterownik_4 = 0;
; 0000 1704                                             cykl_testu = 7;
	__GETWRN 16,17,7
; 0000 1705                                             }
; 0000 1706 
; 0000 1707             break;
_0x2EE:
	RJMP _0x2CE
; 0000 1708 
; 0000 1709             case 7:
_0x2EC:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2EF
; 0000 170A 
; 0000 170B                                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x2F0
; 0000 170C                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
	CALL SUBOPT_0x104
; 0000 170D 
; 0000 170E                                     if(cykl_sterownik_1 == 5)
_0x2F0:
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRNE _0x2F1
; 0000 170F                                         {
; 0000 1710                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 1711                                         cykl_sterownik_2 = 0;
; 0000 1712                                         cykl_sterownik_3 = 0;
; 0000 1713                                         cykl_sterownik_4 = 0;
; 0000 1714                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 1715                                         }
; 0000 1716 
; 0000 1717 
; 0000 1718             break;
_0x2F1:
	RJMP _0x2CE
; 0000 1719 
; 0000 171A 
; 0000 171B 
; 0000 171C 
; 0000 171D 
; 0000 171E 
; 0000 171F 
; 0000 1720             case 666:
_0x2EF:
	CPI  R30,LOW(0x29A)
	LDI  R26,HIGH(0x29A)
	CPC  R31,R26
	BRNE _0x2CE
; 0000 1721 
; 0000 1722                                         if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x2F3
; 0000 1723                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xED
; 0000 1724                                         if(cykl_sterownik_3 == 5)
_0x2F3:
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRNE _0x2F4
; 0000 1725                                             {
; 0000 1726                                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF1
; 0000 1727                                             cykl_sterownik_4 = 0;
; 0000 1728                                             cykl_testu = 100;
	__GETWRN 16,17,100
; 0000 1729                                             test_geometryczny_rzad_1 = 0;
	LDI  R30,LOW(0)
	STS  _test_geometryczny_rzad_1,R30
	STS  _test_geometryczny_rzad_1+1,R30
; 0000 172A                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 172B                                             }
; 0000 172C 
; 0000 172D             break;
_0x2F4:
; 0000 172E 
; 0000 172F 
; 0000 1730 
; 0000 1731             }
_0x2CE:
; 0000 1732 
; 0000 1733         }
	RJMP _0x2C9
_0x2CB:
; 0000 1734     }
; 0000 1735 
; 0000 1736 
; 0000 1737 
; 0000 1738                                                                    //swiatlo czer       //swiatlo zolte
; 0000 1739 if(test_geometryczny_rzad_1 == 0 & test_geometryczny_rzad_2 == 1 & PORTD.7 == 0  & PORT_F.bits.b6 == 0 &
_0x2C8:
; 0000 173A     il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0 & sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0xE5
	CALL SUBOPT_0x83
	CALL SUBOPT_0xE6
	CALL SUBOPT_0x85
	AND  R0,R30
	CALL SUBOPT_0xE8
	CALL SUBOPT_0x105
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	AND  R30,R0
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x2F7
; 0000 173B     {
; 0000 173C     while(test_geometryczny_rzad_2 == 1)
_0x2F8:
	CALL SUBOPT_0xE6
	SBIW R26,1
	BREQ PC+3
	JMP _0x2FA
; 0000 173D         {
; 0000 173E         switch(cykl_testu)
	MOVW R30,R16
; 0000 173F             {
; 0000 1740              case 0:
	SBIW R30,0
	BRNE _0x2FE
; 0000 1741 
; 0000 1742                wybor_linijek_sterownikow(2);
	CALL SUBOPT_0x108
	CALL SUBOPT_0xEB
; 0000 1743                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1744                cykl_sterownik_1 = 0;
; 0000 1745                cykl_sterownik_2 = 0;
; 0000 1746                cykl_sterownik_3 = 0;
; 0000 1747                cykl_sterownik_4 = 0;
; 0000 1748                wybor_linijek_sterownikow(2);
	CALL SUBOPT_0x108
	CALL _wybor_linijek_sterownikow
; 0000 1749                cykl_testu = 1;
	__GETWRN 16,17,1
; 0000 174A 
; 0000 174B 
; 0000 174C 
; 0000 174D             break;
	RJMP _0x2FD
; 0000 174E 
; 0000 174F             case 1:
_0x2FE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x301
; 0000 1750 
; 0000 1751             //na sam dol zjezdzamy pionami
; 0000 1752                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x302
; 0000 1753                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xED
; 0000 1754                 if(cykl_sterownik_4 < 5)
_0x302:
	CALL SUBOPT_0xEE
	SBIW R26,5
	BRGE _0x303
; 0000 1755                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 1756 
; 0000 1757                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x303:
	CALL SUBOPT_0xF0
	BREQ _0x304
; 0000 1758                                         {
; 0000 1759                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF1
; 0000 175A                                         cykl_sterownik_4 = 0;
; 0000 175B                                         cykl_testu = 2;
	__GETWRN 16,17,2
; 0000 175C                                         }
; 0000 175D 
; 0000 175E 
; 0000 175F 
; 0000 1760             break;
_0x304:
	RJMP _0x2FD
; 0000 1761 
; 0000 1762 
; 0000 1763             case 2:
_0x301:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x305
; 0000 1764 
; 0000 1765                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x306
; 0000 1766                                     cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xF3
; 0000 1767                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy rzad 2
_0x306:
	CALL SUBOPT_0xF4
	SBIW R26,5
	BRGE _0x307
; 0000 1768                                     cykl_sterownik_2 = sterownik_2_praca(0x009);       //ster 2 ucieczka dla II rzedu (druciak)
	CALL SUBOPT_0x109
	CALL SUBOPT_0xF6
; 0000 1769 
; 0000 176A                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x307:
	CALL SUBOPT_0xF7
	BREQ _0x308
; 0000 176B                                         {
; 0000 176C                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 176D                                         cykl_sterownik_2 = 0;
; 0000 176E                                         cykl_sterownik_3 = 0;
; 0000 176F                                         cykl_sterownik_4 = 0;
; 0000 1770                                         cykl_testu = 3;
	__GETWRN 16,17,3
; 0000 1771 
; 0000 1772                                         }
; 0000 1773 
; 0000 1774             break;
_0x308:
	RJMP _0x2FD
; 0000 1775 
; 0000 1776 
; 0000 1777             case 3:
_0x305:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x309
; 0000 1778 
; 0000 1779                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x30A
; 0000 177A                                     cykl_sterownik_1 = sterownik_1_praca(a[1]); //ster 1 pod srodek zacisku
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xF3
; 0000 177B 
; 0000 177C                                     if(cykl_sterownik_1 == 5)
_0x30A:
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRNE _0x30B
; 0000 177D                                         {
; 0000 177E                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 177F                                         cykl_sterownik_2 = 0;
; 0000 1780                                         cykl_sterownik_3 = 0;
; 0000 1781                                         cykl_sterownik_4 = 0;
; 0000 1782                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 1783                                         }
; 0000 1784 
; 0000 1785             break;
_0x30B:
	RJMP _0x2FD
; 0000 1786 
; 0000 1787             case 4:
_0x309:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x30C
; 0000 1788 
; 0000 1789                                    if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x30D
; 0000 178A                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
	CALL SUBOPT_0x7B
	CALL SUBOPT_0xFA
; 0000 178B 
; 0000 178C                                    if(cykl_sterownik_3 == 5)
_0x30D:
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRNE _0x30E
; 0000 178D                                         {
; 0000 178E                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 178F                                         cykl_sterownik_2 = 0;
; 0000 1790                                         cykl_sterownik_3 = 0;
; 0000 1791                                         cykl_sterownik_4 = 0;
; 0000 1792                                         cykl_testu = 5;
	__GETWRN 16,17,5
; 0000 1793                                         }
; 0000 1794 
; 0000 1795             break;
_0x30E:
	RJMP _0x2FD
; 0000 1796 
; 0000 1797             case 5:
_0x30C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x30F
; 0000 1798                                      if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x310
; 0000 1799                                      {
; 0000 179A                                      d = odczytaj_parametr(48,96);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x24
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 179B                                         if(d == 0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x311
; 0000 179C                                             cykl_testu = 666;
	__GETWRN 16,17,666
; 0000 179D 
; 0000 179E 
; 0000 179F 
; 0000 17A0 
; 0000 17A1                                         if(d == 2 & ff[2] == 0)
_0x311:
	MOVW R26,R18
	CALL SUBOPT_0xD4
	MOV  R0,R30
	CALL SUBOPT_0x11
	BREQ _0x312
; 0000 17A2                                             {
; 0000 17A3                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 17A4                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 17A5                                             }
; 0000 17A6                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
_0x312:
	CALL SUBOPT_0xFC
	AND  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0xCE
	BREQ _0x313
; 0000 17A7                                             {
; 0000 17A8                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 17A9                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 17AA                                             }
; 0000 17AB                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
_0x313:
	CALL SUBOPT_0xFD
	AND  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0xCE
	BREQ _0x314
; 0000 17AC                                             {
; 0000 17AD                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 17AE                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 17AF                                             }
; 0000 17B0                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
_0x314:
	CALL SUBOPT_0xFE
	AND  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0xCE
	BREQ _0x315
; 0000 17B1                                             {
; 0000 17B2                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 17B3                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 17B4                                             }
; 0000 17B5                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
_0x315:
	CALL SUBOPT_0xFF
	AND  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0xCE
	BREQ _0x316
; 0000 17B6                                             {
; 0000 17B7                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 17B8                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 17B9                                             }
; 0000 17BA                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
_0x316:
	CALL SUBOPT_0x100
	AND  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0xCE
	BREQ _0x317
; 0000 17BB                                             {
; 0000 17BC                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 17BD                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 17BE                                             }
; 0000 17BF                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
_0x317:
	CALL SUBOPT_0x101
	AND  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0xCE
	BREQ _0x318
; 0000 17C0                                             {
; 0000 17C1                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 17C2                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 17C3                                             }
; 0000 17C4                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
_0x318:
	CALL SUBOPT_0x102
	AND  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CALL SUBOPT_0xCE
	BREQ _0x319
; 0000 17C5                                             {
; 0000 17C6                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 17C7                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 17C8                                             }
; 0000 17C9                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
_0x319:
	CALL SUBOPT_0x103
	AND  R0,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL SUBOPT_0xCE
	BREQ _0x31A
; 0000 17CA                                             {
; 0000 17CB                                             cykl_testu = 6;
	CALL SUBOPT_0xFB
; 0000 17CC                                             ff[d]=1;
	CALL SUBOPT_0x33
; 0000 17CD                                             }
; 0000 17CE 
; 0000 17CF                                       }
_0x31A:
; 0000 17D0             break;
_0x310:
	RJMP _0x2FD
; 0000 17D1 
; 0000 17D2             case 6:
_0x30F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x31B
; 0000 17D3                                      if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x31C
; 0000 17D4                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xED
; 0000 17D5                                         if(cykl_sterownik_3 == 5)
_0x31C:
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRNE _0x31D
; 0000 17D6                                             {
; 0000 17D7                                             cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 17D8                                             cykl_sterownik_2 = 0;
; 0000 17D9                                             cykl_sterownik_3 = 0;
; 0000 17DA                                             cykl_sterownik_4 = 0;
; 0000 17DB                                             cykl_testu = 7;
	__GETWRN 16,17,7
; 0000 17DC                                             }
; 0000 17DD 
; 0000 17DE             break;
_0x31D:
	RJMP _0x2FD
; 0000 17DF 
; 0000 17E0             case 7:
_0x31B:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x31E
; 0000 17E1 
; 0000 17E2                                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x31F
; 0000 17E3                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
	CALL SUBOPT_0x104
; 0000 17E4 
; 0000 17E5                                     if(cykl_sterownik_1 == 5)
_0x31F:
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRNE _0x320
; 0000 17E6                                         {
; 0000 17E7                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 17E8                                         cykl_sterownik_2 = 0;
; 0000 17E9                                         cykl_sterownik_3 = 0;
; 0000 17EA                                         cykl_sterownik_4 = 0;
; 0000 17EB                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 17EC                                         }
; 0000 17ED 
; 0000 17EE 
; 0000 17EF             break;
_0x320:
	RJMP _0x2FD
; 0000 17F0 
; 0000 17F1 
; 0000 17F2 
; 0000 17F3             case 666:
_0x31E:
	CPI  R30,LOW(0x29A)
	LDI  R26,HIGH(0x29A)
	CPC  R31,R26
	BRNE _0x2FD
; 0000 17F4 
; 0000 17F5                                         if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x322
; 0000 17F6                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xED
; 0000 17F7                                         if(cykl_sterownik_3 == 5)
_0x322:
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRNE _0x323
; 0000 17F8                                             {
; 0000 17F9                                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF1
; 0000 17FA                                             cykl_sterownik_4 = 0;
; 0000 17FB                                             cykl_testu = 100;
	__GETWRN 16,17,100
; 0000 17FC                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 17FD                                             test_geometryczny_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _test_geometryczny_rzad_2,R30
	STS  _test_geometryczny_rzad_2+1,R30
; 0000 17FE                                             }
; 0000 17FF 
; 0000 1800             break;
_0x323:
; 0000 1801 
; 0000 1802 
; 0000 1803 
; 0000 1804             }
_0x2FD:
; 0000 1805 
; 0000 1806         }
	RJMP _0x2F8
_0x2FA:
; 0000 1807     }
; 0000 1808 
; 0000 1809 
; 0000 180A 
; 0000 180B 
; 0000 180C }
_0x2F7:
	CALL __LOADLOCR6
	ADIW R28,30
	RET
;
;
;
;
;
;void kontrola_zoltego_swiatla()
; 0000 1813 {
_kontrola_zoltego_swiatla:
; 0000 1814 
; 0000 1815 
; 0000 1816 if(czas_pracy_szczotki_drucianej_h_17 >= czas_pracy_szczotki_drucianej_stala)
	CALL SUBOPT_0x10B
	CP   R26,R12
	CPC  R27,R13
	BRLT _0x326
; 0000 1817      {
; 0000 1818      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x10C
; 0000 1819      PORTF = PORT_F.byte;
; 0000 181A      komunikat_na_panel("                                                ",80,0);
	CALL SUBOPT_0x10D
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 181B      komunikat_na_panel("Wymien szczotke druciana 17-stke",80,0);
	__POINTW1FN _0x0,1994
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 181C      }
; 0000 181D 
; 0000 181E if(czas_pracy_szczotki_drucianej_h_15 >= czas_pracy_szczotki_drucianej_stala)
_0x326:
	CALL SUBOPT_0x10E
	CP   R26,R12
	CPC  R27,R13
	BRLT _0x327
; 0000 181F      {
; 0000 1820      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x10C
; 0000 1821      PORTF = PORT_F.byte;
; 0000 1822      komunikat_na_panel("                                                ",80,0);
	CALL SUBOPT_0x10D
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 1823      komunikat_na_panel("Wymien szczotke druciana 15-stke",16,128);
	__POINTW1FN _0x0,2027
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB4
	CALL _komunikat_na_panel
; 0000 1824      }
; 0000 1825 
; 0000 1826 if(czas_pracy_krazka_sciernego_h_34 >= czas_pracy_krazka_sciernego_stala)
_0x327:
	CALL SUBOPT_0xA8
	CALL SUBOPT_0x10F
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x328
; 0000 1827      {
; 0000 1828      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x10C
; 0000 1829      PORTF = PORT_F.byte;
; 0000 182A      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0x110
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 182B      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 34",64,0);
	__POINTW1FN _0x0,2060
	CALL SUBOPT_0x111
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 182C      }
; 0000 182D 
; 0000 182E if(czas_pracy_krazka_sciernego_h_36 >= czas_pracy_krazka_sciernego_stala)
_0x328:
	CALL SUBOPT_0xA8
	CALL SUBOPT_0x112
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x329
; 0000 182F      {
; 0000 1830      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x10C
; 0000 1831      PORTF = PORT_F.byte;
; 0000 1832      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0x110
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 1833      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 36",64,0);
	__POINTW1FN _0x0,2107
	CALL SUBOPT_0x111
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 1834      }
; 0000 1835 
; 0000 1836 if(czas_pracy_krazka_sciernego_h_38 >= czas_pracy_krazka_sciernego_stala)
_0x329:
	CALL SUBOPT_0xA8
	CALL SUBOPT_0x113
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x32A
; 0000 1837      {
; 0000 1838      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x10C
; 0000 1839      PORTF = PORT_F.byte;
; 0000 183A      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0x110
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 183B      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 38",64,0);
	__POINTW1FN _0x0,2154
	CALL SUBOPT_0x111
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 183C      }
; 0000 183D 
; 0000 183E if(czas_pracy_krazka_sciernego_h_41 >= czas_pracy_krazka_sciernego_stala)
_0x32A:
	CALL SUBOPT_0xA8
	CALL SUBOPT_0x114
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x32B
; 0000 183F      {
; 0000 1840      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x10C
; 0000 1841      PORTF = PORT_F.byte;
; 0000 1842      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0x110
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 1843      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 41",64,0);
	__POINTW1FN _0x0,2201
	CALL SUBOPT_0x111
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 1844      }
; 0000 1845 
; 0000 1846 if(czas_pracy_krazka_sciernego_h_43 >= czas_pracy_krazka_sciernego_stala)
_0x32B:
	CALL SUBOPT_0xA8
	CALL SUBOPT_0x115
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x32C
; 0000 1847      {
; 0000 1848      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x10C
; 0000 1849      PORTF = PORT_F.byte;
; 0000 184A      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0x110
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 184B      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 43",64,0);
	__POINTW1FN _0x0,2248
	CALL SUBOPT_0x111
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 184C      }
; 0000 184D 
; 0000 184E 
; 0000 184F 
; 0000 1850 }
_0x32C:
	RET
;
;void wymiana_szczotki_i_krazka()
; 0000 1853 {
_wymiana_szczotki_i_krazka:
; 0000 1854 int g,e,f,d,cykl_wymiany;
; 0000 1855 cykl_wymiany = 0;
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
; 0000 1856                       //30 //20
; 0000 1857 
; 0000 1858 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	POP  R26
	AND  R30,R26
	BREQ _0x32D
; 0000 1859 {
; 0000 185A g = odczytaj_parametr(48,32);  //szczotka druciana
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x31
	CALL _odczytaj_parametr
	MOVW R16,R30
; 0000 185B                     //30  //30
; 0000 185C f = odczytaj_parametr(48,48);  //krazek scierny
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1B
	CALL _odczytaj_parametr
	MOVW R20,R30
; 0000 185D }
; 0000 185E 
; 0000 185F while(g == 1)
_0x32D:
_0x32E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+3
	JMP _0x330
; 0000 1860     {
; 0000 1861     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 1862     {
; 0000 1863     case 0:
	SBIW R30,0
	BRNE _0x334
; 0000 1864 
; 0000 1865                cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 1866                cykl_sterownik_2 = 0;
; 0000 1867                cykl_sterownik_3 = 0;
; 0000 1868                cykl_sterownik_4 = 0;
; 0000 1869                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 186A                cykl_wymiany = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 186B 
; 0000 186C 
; 0000 186D 
; 0000 186E     break;
	RJMP _0x333
; 0000 186F 
; 0000 1870     case 1:
_0x334:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x337
; 0000 1871 
; 0000 1872             //na sam dol zjezdzamy pionami
; 0000 1873                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x338
; 0000 1874                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xED
; 0000 1875                 if(cykl_sterownik_4 < 5)
_0x338:
	CALL SUBOPT_0xEE
	SBIW R26,5
	BRGE _0x339
; 0000 1876                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 1877 
; 0000 1878                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x339:
	CALL SUBOPT_0xF0
	BREQ _0x33A
; 0000 1879 
; 0000 187A                             {
; 0000 187B                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF1
; 0000 187C                                         cykl_sterownik_4 = 0;
; 0000 187D                                         cykl_wymiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 187E                                         }
; 0000 187F 
; 0000 1880 
; 0000 1881 
; 0000 1882     break;
_0x33A:
	RJMP _0x333
; 0000 1883 
; 0000 1884 
; 0000 1885 
; 0000 1886     case 2:
_0x337:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x33B
; 0000 1887 
; 0000 1888                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x33C
; 0000 1889                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0x116
	CALL SUBOPT_0xF3
; 0000 188A                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x33C:
	CALL SUBOPT_0xF4
	SBIW R26,5
	BRGE _0x33D
; 0000 188B                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x116
	CALL SUBOPT_0xF6
; 0000 188C 
; 0000 188D                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x33D:
	CALL SUBOPT_0xF7
	BREQ _0x33E
; 0000 188E                                         {
; 0000 188F                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 1890                                         cykl_sterownik_2 = 0;
; 0000 1891                                         cykl_sterownik_3 = 0;
; 0000 1892                                         cykl_sterownik_4 = 0;
; 0000 1893                                          cykl_wymiany = 3;
	CALL SUBOPT_0x117
; 0000 1894 
; 0000 1895                                         }
; 0000 1896 
; 0000 1897     break;
_0x33E:
	RJMP _0x333
; 0000 1898 
; 0000 1899 
; 0000 189A 
; 0000 189B     case 3:
_0x33B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x33F
; 0000 189C 
; 0000 189D             //na sam dol zjezdzamy pionami
; 0000 189E                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x340
; 0000 189F                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xFA
; 0000 18A0                 if(cykl_sterownik_4 < 5)
_0x340:
	CALL SUBOPT_0xEE
	SBIW R26,5
	BRGE _0x341
; 0000 18A1                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
	CALL SUBOPT_0x108
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 18A2 
; 0000 18A3                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x341:
	CALL SUBOPT_0xF0
	BRNE PC+3
	JMP _0x342
; 0000 18A4 
; 0000 18A5                             {
; 0000 18A6                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF1
; 0000 18A7                                         cykl_sterownik_4 = 0;
; 0000 18A8                                         d = odczytaj_parametr(48,32);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x31
	CALL _odczytaj_parametr
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 18A9 
; 0000 18AA                                         switch (d)
; 0000 18AB                                         {
; 0000 18AC                                         case 0:
	SBIW R30,0
	BRNE _0x346
; 0000 18AD 
; 0000 18AE                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	POP  R26
	AND  R30,R26
	BREQ _0x347
; 0000 18AF                                                 {
; 0000 18B0                                                 cykl_wymiany = 4;
	CALL SUBOPT_0x118
; 0000 18B1                                                 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 18B2                                                 }
; 0000 18B3                                              //jednak nie wymianiamy
; 0000 18B4 
; 0000 18B5                                         break;
_0x347:
	RJMP _0x345
; 0000 18B6 
; 0000 18B7                                         case 1:
_0x346:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x34A
; 0000 18B8                                              cykl_wymiany = 3;
	CALL SUBOPT_0x117
; 0000 18B9                                              PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 18BA                                              //czekam z decyzja - w trakcie wymiany
; 0000 18BB                                         break;
	RJMP _0x345
; 0000 18BC 
; 0000 18BD                                         case 2:
_0x34A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x345
; 0000 18BE 
; 0000 18BF 
; 0000 18C0 
; 0000 18C1                                              PORT_F.bits.b6 = 0;   //zgas lampke
	LDS  R30,_PORT_F
	ANDI R30,0xBF
	CALL SUBOPT_0xDE
; 0000 18C2                                              PORTF = PORT_F.byte;
; 0000 18C3 
; 0000 18C4                                              if(srednica_wew_korpusu == 34 | srednica_wew_korpusu == 36)
	CALL SUBOPT_0x119
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x119
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x34E
; 0000 18C5                                              {
; 0000 18C6                                              czas_pracy_szczotki_drucianej_h_15 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_szczotki_drucianej_h_15,R30
	STS  _czas_pracy_szczotki_drucianej_h_15+1,R30
; 0000 18C7                                              wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_15,16,128);
	CALL SUBOPT_0xB3
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xB5
; 0000 18C8                                              wartosc_parametru_panelu_stala_pamiec(16,32,16,128);
	CALL SUBOPT_0x31
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xB6
; 0000 18C9                                              delay_ms(200);
; 0000 18CA                                              odczyt_parametru_panelu_stala_pamiec(16,32,16,128);
	CALL SUBOPT_0x31
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB4
	CALL SUBOPT_0xA4
; 0000 18CB                                              delay_ms(200);
; 0000 18CC                                              }
; 0000 18CD 
; 0000 18CE                                              if(srednica_wew_korpusu == 38 | srednica_wew_korpusu == 41 | srednica_wew_korpusu == 43)
_0x34E:
	CALL SUBOPT_0x119
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x119
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	CALL __EQW12
	OR   R0,R30
	CALL SUBOPT_0x119
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x34F
; 0000 18CF                                              {
; 0000 18D0                                              czas_pracy_szczotki_drucianej_h_17 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_szczotki_drucianej_h_17,R30
	STS  _czas_pracy_szczotki_drucianej_h_17+1,R30
; 0000 18D1                                              wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_17,0,144);
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA6
; 0000 18D2                                              wartosc_parametru_panelu_stala_pamiec(0,96,0,144);
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA3
; 0000 18D3                                              delay_ms(200);
; 0000 18D4                                              odczyt_parametru_panelu_stala_pamiec(0,96,0,144);
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA4
; 0000 18D5                                              delay_ms(200);
; 0000 18D6                                              }
; 0000 18D7 
; 0000 18D8                                              komunikat_na_panel("                                                ",80,0);
_0x34F:
	CALL SUBOPT_0x10D
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 18D9 
; 0000 18DA                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	POP  R26
	AND  R30,R26
	BREQ _0x350
; 0000 18DB                                                 {
; 0000 18DC                                                 cykl_wymiany = 4;
	CALL SUBOPT_0x118
; 0000 18DD                                                 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 18DE                                                 }
; 0000 18DF                                              //wymianymy
; 0000 18E0                                         break;
_0x350:
; 0000 18E1                                         }
_0x345:
; 0000 18E2                             }
; 0000 18E3 
; 0000 18E4 
; 0000 18E5 
; 0000 18E6 
; 0000 18E7 
; 0000 18E8 
; 0000 18E9     break;
_0x342:
	RJMP _0x333
; 0000 18EA 
; 0000 18EB    case 4:
_0x33F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x333
; 0000 18EC 
; 0000 18ED                       //na sam dol zjezdzamy pionami
; 0000 18EE                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x354
; 0000 18EF                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xED
; 0000 18F0                 if(cykl_sterownik_4 < 5)
_0x354:
	CALL SUBOPT_0xEE
	SBIW R26,5
	BRGE _0x355
; 0000 18F1                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 18F2 
; 0000 18F3                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x355:
	CALL SUBOPT_0xF0
	BREQ _0x356
; 0000 18F4                                         {
; 0000 18F5                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 18F6                                         cykl_sterownik_2 = 0;
; 0000 18F7                                         cykl_sterownik_3 = 0;
; 0000 18F8                                         cykl_sterownik_4 = 0;
; 0000 18F9                                         wartosc_parametru_panelu(0,48,32);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x31
	CALL _wartosc_parametru_panelu
; 0000 18FA                                         PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 18FB                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 18FC                                         g = 0;
	__GETWRN 16,17,0
; 0000 18FD                                         }
; 0000 18FE 
; 0000 18FF    break;
_0x356:
; 0000 1900 
; 0000 1901 
; 0000 1902     }//switch
_0x333:
; 0000 1903 
; 0000 1904    }//while
	RJMP _0x32E
_0x330:
; 0000 1905 
; 0000 1906 
; 0000 1907 while(f == 1)
_0x359:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ PC+3
	JMP _0x35B
; 0000 1908     {
; 0000 1909     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 190A     {
; 0000 190B     case 0:
	SBIW R30,0
	BRNE _0x35F
; 0000 190C 
; 0000 190D                cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 190E                cykl_sterownik_2 = 0;
; 0000 190F                cykl_sterownik_3 = 0;
; 0000 1910                cykl_sterownik_4 = 0;
; 0000 1911                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 1912                cykl_wymiany = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1913 
; 0000 1914 
; 0000 1915 
; 0000 1916     break;
	RJMP _0x35E
; 0000 1917 
; 0000 1918     case 1:
_0x35F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x362
; 0000 1919 
; 0000 191A             //na sam dol zjezdzamy pionami
; 0000 191B                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x363
; 0000 191C                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xED
; 0000 191D                 if(cykl_sterownik_4 < 5)
_0x363:
	CALL SUBOPT_0xEE
	SBIW R26,5
	BRGE _0x364
; 0000 191E                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 191F 
; 0000 1920                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x364:
	CALL SUBOPT_0xF0
	BREQ _0x365
; 0000 1921 
; 0000 1922                             {
; 0000 1923                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF1
; 0000 1924                                         cykl_sterownik_4 = 0;
; 0000 1925                                         cykl_wymiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1926                                         }
; 0000 1927 
; 0000 1928 
; 0000 1929 
; 0000 192A     break;
_0x365:
	RJMP _0x35E
; 0000 192B 
; 0000 192C 
; 0000 192D 
; 0000 192E     case 2:
_0x362:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x366
; 0000 192F 
; 0000 1930                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x367
; 0000 1931                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0x116
	CALL SUBOPT_0xF3
; 0000 1932                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x367:
	CALL SUBOPT_0xF4
	SBIW R26,5
	BRGE _0x368
; 0000 1933                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x116
	CALL SUBOPT_0xF6
; 0000 1934 
; 0000 1935                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x368:
	CALL SUBOPT_0xF7
	BREQ _0x369
; 0000 1936                                         {
; 0000 1937                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 1938                                         cykl_sterownik_2 = 0;
; 0000 1939                                         cykl_sterownik_3 = 0;
; 0000 193A                                         cykl_sterownik_4 = 0;
; 0000 193B                                          cykl_wymiany = 3;
	CALL SUBOPT_0x117
; 0000 193C 
; 0000 193D                                         }
; 0000 193E 
; 0000 193F     break;
_0x369:
	RJMP _0x35E
; 0000 1940 
; 0000 1941 
; 0000 1942 
; 0000 1943     case 3:
_0x366:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x36A
; 0000 1944 
; 0000 1945             //na sam dol zjezdzamy pionami
; 0000 1946                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x36B
; 0000 1947                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xFA
; 0000 1948                 if(cykl_sterownik_4 < 5)
_0x36B:
	CALL SUBOPT_0xEE
	SBIW R26,5
	BRGE _0x36C
; 0000 1949                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
	CALL SUBOPT_0x108
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 194A 
; 0000 194B                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x36C:
	CALL SUBOPT_0xF0
	BRNE PC+3
	JMP _0x36D
; 0000 194C 
; 0000 194D                             {
; 0000 194E                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF1
; 0000 194F                                         cykl_sterownik_4 = 0;
; 0000 1950                                         e = odczytaj_parametr(48,48);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1B
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 1951 
; 0000 1952                                         switch (e)
	MOVW R30,R18
; 0000 1953                                         {
; 0000 1954                                         case 0:
	SBIW R30,0
	BRNE _0x371
; 0000 1955 
; 0000 1956                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	POP  R26
	AND  R30,R26
	BREQ _0x372
; 0000 1957                                              {
; 0000 1958                                              cykl_wymiany = 4;
	CALL SUBOPT_0x118
; 0000 1959                                              PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 195A                                              }
; 0000 195B                                              //jednak nie wymianiamy
; 0000 195C 
; 0000 195D                                         break;
_0x372:
	RJMP _0x370
; 0000 195E 
; 0000 195F                                         case 1:
_0x371:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x375
; 0000 1960                                              PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 1961                                              cykl_wymiany = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x54C
; 0000 1962                                              //czekam z decyzja - w trakcie wymiany
; 0000 1963                                         break;
; 0000 1964 
; 0000 1965                                         case 2:
_0x375:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x370
; 0000 1966 
; 0000 1967 
; 0000 1968 
; 0000 1969                                              PORT_F.bits.b6 = 0;   //zgas lampke
	LDS  R30,_PORT_F
	ANDI R30,0xBF
	CALL SUBOPT_0xDE
; 0000 196A                                              PORTF = PORT_F.byte;
; 0000 196B 
; 0000 196C                                              if(srednica_wew_korpusu == 34)
	CALL SUBOPT_0x119
	SBIW R26,34
	BRNE _0x379
; 0000 196D                                              {
; 0000 196E                                              czas_pracy_krazka_sciernego_h_34 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego_h_34,R30
	STS  _czas_pracy_krazka_sciernego_h_34+1,R30
; 0000 196F                                              wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
	CALL SUBOPT_0xB7
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA6
; 0000 1970                                              wartosc_parametru_panelu_stala_pamiec(0,112,96,48);
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA3
; 0000 1971                                              delay_ms(200);
; 0000 1972                                              odczyt_parametru_panelu_stala_pamiec(0,112,96,48);
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA4
; 0000 1973                                              delay_ms(200);
; 0000 1974                                              }
; 0000 1975 
; 0000 1976                                              if(srednica_wew_korpusu == 36)
_0x379:
	CALL SUBOPT_0x119
	SBIW R26,36
	BRNE _0x37A
; 0000 1977                                              {
; 0000 1978                                              czas_pracy_krazka_sciernego_h_36 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego_h_36,R30
	STS  _czas_pracy_krazka_sciernego_h_36+1,R30
; 0000 1979                                              wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
	CALL SUBOPT_0xB8
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xA6
; 0000 197A                                              wartosc_parametru_panelu_stala_pamiec(0,128,96,64);
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xA3
; 0000 197B                                              delay_ms(200);
; 0000 197C                                              odczyt_parametru_panelu_stala_pamiec(0,128,96,64);
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xA4
; 0000 197D                                              delay_ms(200);
; 0000 197E                                              }
; 0000 197F 
; 0000 1980                                              if(srednica_wew_korpusu == 38)
_0x37A:
	CALL SUBOPT_0x119
	SBIW R26,38
	BRNE _0x37B
; 0000 1981                                              {
; 0000 1982                                              czas_pracy_krazka_sciernego_h_38 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego_h_38,R30
	STS  _czas_pracy_krazka_sciernego_h_38+1,R30
; 0000 1983                                              wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xA6
; 0000 1984                                              wartosc_parametru_panelu_stala_pamiec(0,144,96,80);
	CALL SUBOPT_0xA5
	CALL SUBOPT_0x24
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xA3
; 0000 1985                                              delay_ms(200);
; 0000 1986                                              odczyt_parametru_panelu_stala_pamiec(0,144,96,80);
	CALL SUBOPT_0xA5
	CALL SUBOPT_0x24
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xA4
; 0000 1987                                              delay_ms(200);
; 0000 1988                                              }
; 0000 1989 
; 0000 198A                                             if(srednica_wew_korpusu == 41)
_0x37B:
	CALL SUBOPT_0x119
	SBIW R26,41
	BRNE _0x37C
; 0000 198B                                             {
; 0000 198C                                             czas_pracy_krazka_sciernego_h_41 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego_h_41,R30
	STS  _czas_pracy_krazka_sciernego_h_41+1,R30
; 0000 198D                                             wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
	CALL SUBOPT_0xBB
	CALL SUBOPT_0x24
	CALL SUBOPT_0xB5
; 0000 198E                                             wartosc_parametru_panelu_stala_pamiec(16,0,96,96);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x24
	CALL SUBOPT_0x24
	CALL SUBOPT_0xB6
; 0000 198F                                             delay_ms(200);
; 0000 1990                                             odczyt_parametru_panelu_stala_pamiec(16,0,96,96);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x24
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA4
; 0000 1991                                             delay_ms(200);
; 0000 1992                                             }
; 0000 1993 
; 0000 1994                                             if(srednica_wew_korpusu == 43)
_0x37C:
	CALL SUBOPT_0x119
	SBIW R26,43
	BRNE _0x37D
; 0000 1995                                             {
; 0000 1996                                             czas_pracy_krazka_sciernego_h_43 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego_h_43,R30
	STS  _czas_pracy_krazka_sciernego_h_43+1,R30
; 0000 1997                                             wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xB5
; 0000 1998                                             wartosc_parametru_panelu_stala_pamiec(16,16,96,112);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xB6
; 0000 1999                                             delay_ms(200);
; 0000 199A                                             odczyt_parametru_panelu_stala_pamiec(16,16,96,112);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA4
; 0000 199B                                             delay_ms(200);
; 0000 199C                                             }
; 0000 199D 
; 0000 199E 
; 0000 199F                                              komunikat_na_panel("                                                ",64,0);
_0x37D:
	CALL SUBOPT_0x110
	CALL SUBOPT_0xA
	CALL _komunikat_na_panel
; 0000 19A0                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	PUSH R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	POP  R26
	AND  R30,R26
	BREQ _0x37E
; 0000 19A1                                                      {
; 0000 19A2                                                      PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 19A3                                                      cykl_wymiany = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
_0x54C:
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 19A4                                                      }
; 0000 19A5                                              //wymianymy
; 0000 19A6                                         break;
_0x37E:
; 0000 19A7                                         }
_0x370:
; 0000 19A8                             }
; 0000 19A9 
; 0000 19AA 
; 0000 19AB 
; 0000 19AC 
; 0000 19AD 
; 0000 19AE 
; 0000 19AF     break;
_0x36D:
	RJMP _0x35E
; 0000 19B0 
; 0000 19B1    case 4:
_0x36A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x35E
; 0000 19B2 
; 0000 19B3                       //na sam dol zjezdzamy pionami
; 0000 19B4                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x382
; 0000 19B5                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xED
; 0000 19B6                 if(cykl_sterownik_4 < 5)
_0x382:
	CALL SUBOPT_0xEE
	SBIW R26,5
	BRGE _0x383
; 0000 19B7                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 19B8 
; 0000 19B9                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x383:
	CALL SUBOPT_0xF0
	BREQ _0x384
; 0000 19BA 
; 0000 19BB                             {
; 0000 19BC                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 19BD                                         cykl_sterownik_2 = 0;
; 0000 19BE                                         cykl_sterownik_3 = 0;
; 0000 19BF                                         cykl_sterownik_4 = 0;
; 0000 19C0                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 19C1                                         wartosc_parametru_panelu(0,48,48);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1B
	CALL _wartosc_parametru_panelu
; 0000 19C2                                         PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 19C3                                         f = 0;
	__GETWRN 20,21,0
; 0000 19C4                                         }
; 0000 19C5 
; 0000 19C6    break;
_0x384:
; 0000 19C7 
; 0000 19C8 
; 0000 19C9     }//switch
_0x35E:
; 0000 19CA 
; 0000 19CB    }//while
	RJMP _0x359
_0x35B:
; 0000 19CC 
; 0000 19CD 
; 0000 19CE 
; 0000 19CF 
; 0000 19D0 
; 0000 19D1 
; 0000 19D2 
; 0000 19D3 
; 0000 19D4 }
	CALL __LOADLOCR6
	ADIW R28,10
	RET
;
;
;void przypadek887()
; 0000 19D8 {
_przypadek887:
; 0000 19D9 if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x11A
	BRGE _0x387
; 0000 19DA                         {
; 0000 19DB                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x11B
; 0000 19DC                         PORTF = PORT_F.byte;
; 0000 19DD                         }
; 0000 19DE 
; 0000 19DF 
; 0000 19E0                      if(rzad_obrabiany == 2)
_0x387:
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x388
; 0000 19E1                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 19E2 
; 0000 19E3                     if(koniec_rzedu_10 == 1)
_0x388:
	CALL SUBOPT_0x11C
	BRNE _0x389
; 0000 19E4                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x11D
; 0000 19E5 
; 0000 19E6 
; 0000 19E7                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x389:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x11F
	CALL SUBOPT_0x120
	BREQ _0x38A
; 0000 19E8                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x121
; 0000 19E9 
; 0000 19EA                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x38A:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x122
	BREQ _0x38B
; 0000 19EB                         {
; 0000 19EC                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 19ED                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x124
; 0000 19EE                         }
; 0000 19EF 
; 0000 19F0 
; 0000 19F1                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x38B:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x125
	AND  R30,R0
	BREQ _0x38C
; 0000 19F2                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x126
; 0000 19F3 
; 0000 19F4                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x38C:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x127
	AND  R30,R0
	BREQ _0x38D
; 0000 19F5                         {
; 0000 19F6                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 19F7                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x128
; 0000 19F8                         }
; 0000 19F9 
; 0000 19FA                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x38D:
	CALL SUBOPT_0x129
	AND  R30,R0
	BREQ _0x38E
; 0000 19FB                         {
; 0000 19FC                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 19FD                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x12A
; 0000 19FE                         }
; 0000 19FF 
; 0000 1A00                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1A01                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x38E:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x12B
	AND  R30,R0
	BREQ _0x38F
; 0000 1A02                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x12C
; 0000 1A03 
; 0000 1A04 
; 0000 1A05                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x38F:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x12D
	AND  R30,R0
	BREQ _0x390
; 0000 1A06                         {
; 0000 1A07                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1A08                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x12E
; 0000 1A09                         }
; 0000 1A0A 
; 0000 1A0B 
; 0000 1A0C 
; 0000 1A0D 
; 0000 1A0E 
; 0000 1A0F 
; 0000 1A10 
; 0000 1A11                                                               //to nowy war, ostatni dzien w borg
; 0000 1A12                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x390:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x130
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x131
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x132
	BREQ _0x391
; 0000 1A13                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x133
	CALL SUBOPT_0xEF
; 0000 1A14 
; 0000 1A15                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x391:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x134
	CALL SUBOPT_0x135
	BREQ _0x392
; 0000 1A16                         {
; 0000 1A17                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x136
	BRNE _0x393
; 0000 1A18                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1A19                         if(abs_ster4 == 0)
_0x393:
	CALL SUBOPT_0x138
	BRNE _0x394
; 0000 1A1A                             {
; 0000 1A1B                             szczotka_druc_cykl++;
	CALL SUBOPT_0x139
; 0000 1A1C                             abs_ster4 = 1;
; 0000 1A1D                             }
; 0000 1A1E                         else
	RJMP _0x395
_0x394:
; 0000 1A1F                             {
; 0000 1A20                             abs_ster4 = 0;
	CALL SUBOPT_0x13A
; 0000 1A21                             sek13 = 0;
; 0000 1A22                             }
_0x395:
; 0000 1A23                         }
; 0000 1A24 
; 0000 1A25                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x392:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13C
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x13D
	BREQ _0x396
; 0000 1A26                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x86
	CALL SUBOPT_0xFA
; 0000 1A27 
; 0000 1A28 
; 0000 1A29                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x396:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x13F
	BREQ _0x397
; 0000 1A2A                         {
; 0000 1A2B                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1A2C                         if(abs_ster3 == 0)
	CALL SUBOPT_0x141
	BRNE _0x398
; 0000 1A2D                             {
; 0000 1A2E                             krazek_scierny_cykl++;
	CALL SUBOPT_0x142
; 0000 1A2F                             abs_ster3 = 1;
; 0000 1A30                             }
; 0000 1A31                         else
	RJMP _0x399
_0x398:
; 0000 1A32                             abs_ster3 = 0;
	CALL SUBOPT_0x143
; 0000 1A33                         }
_0x399:
; 0000 1A34 
; 0000 1A35                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x397:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13C
	CALL SUBOPT_0x85
	AND  R30,R0
	BREQ _0x39A
; 0000 1A36                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x7B
	CALL SUBOPT_0xFA
; 0000 1A37 
; 0000 1A38                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x39A:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x130
	CALL SUBOPT_0x85
	CALL SUBOPT_0x144
	BREQ _0x39B
; 0000 1A39                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory
	CALL SUBOPT_0x145
	CALL SUBOPT_0xEF
; 0000 1A3A 
; 0000 1A3B 
; 0000 1A3C 
; 0000 1A3D                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1A3E 
; 0000 1A3F                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonalem_komplet_okregow == 3)
_0x39B:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x146
	BREQ _0x39C
; 0000 1A40                        {
; 0000 1A41                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1A42                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x147
; 0000 1A43                        }
; 0000 1A44                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x39C:
	CALL SUBOPT_0x148
	MOV  R0,R30
	CALL SUBOPT_0x13B
	CALL __LTW12
	AND  R30,R0
	BREQ _0x39D
; 0000 1A45                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xED
; 0000 1A46 
; 0000 1A47                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x39D:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x149
	AND  R30,R0
	BREQ _0x39E
; 0000 1A48                        {
; 0000 1A49                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x14A
; 0000 1A4A                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1A4B                        }
; 0000 1A4C                    //////////////////////////////////////////////
; 0000 1A4D 
; 0000 1A4E 
; 0000 1A4F 
; 0000 1A50                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1A51 
; 0000 1A52                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x39E:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x134
	CALL SUBOPT_0x14B
	BREQ _0x3A1
; 0000 1A53                        {
; 0000 1A54                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1A55                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1A56                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x14C
; 0000 1A57                        }
; 0000 1A58                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3A1:
	CALL SUBOPT_0x14D
	MOV  R0,R30
	CALL SUBOPT_0x12F
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3A4
; 0000 1A59                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 1A5A 
; 0000 1A5B                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3A4:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x14E
	AND  R30,R0
	BREQ _0x3A5
; 0000 1A5C                        {
; 0000 1A5D                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x14F
; 0000 1A5E                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1A5F                        }
; 0000 1A60                    //////////////////////////////////////////////
; 0000 1A61 
; 0000 1A62                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3A5:
; 0000 1A63                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1A64                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1A65                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0 &  wykonalem_komplet_okregow == 3)
	CALL SUBOPT_0x150
	CALL SUBOPT_0x151
	CALL SUBOPT_0x152
	CALL SUBOPT_0x153
	CALL SUBOPT_0x154
	CALL SUBOPT_0x155
	BREQ _0x3A8
; 0000 1A66                         {
; 0000 1A67                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x14A
; 0000 1A68                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x14F
; 0000 1A69                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 1A6A                         cykl_sterownik_2 = 0;
; 0000 1A6B                         cykl_sterownik_3 = 0;
; 0000 1A6C                         cykl_sterownik_4 = 0;
; 0000 1A6D                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x156
; 0000 1A6E                         krazek_scierny_cykl = 0;
; 0000 1A6F                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1A70                         wykonalem_komplet_okregow = 0;
; 0000 1A71                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1A72                         //PORTF = PORT_F.byte;
; 0000 1A73                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1A74                         cykl_glowny = 9;
; 0000 1A75                         }
; 0000 1A76 }
_0x3A8:
	RET
;
;
;
;void przypadek888()
; 0000 1A7B {
_przypadek888:
; 0000 1A7C 
; 0000 1A7D                  if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x11A
	BRGE _0x3AB
; 0000 1A7E                         {
; 0000 1A7F                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x11B
; 0000 1A80                         PORTF = PORT_F.byte;
; 0000 1A81                         }
; 0000 1A82 
; 0000 1A83 
; 0000 1A84                      if(rzad_obrabiany == 2)
_0x3AB:
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x3AC
; 0000 1A85                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1A86 
; 0000 1A87                     if(koniec_rzedu_10 == 1)
_0x3AC:
	CALL SUBOPT_0x11C
	BRNE _0x3AD
; 0000 1A88                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x11D
; 0000 1A89 
; 0000 1A8A 
; 0000 1A8B                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x3AD:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x11F
	CALL SUBOPT_0x120
	BREQ _0x3AE
; 0000 1A8C                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x121
; 0000 1A8D 
; 0000 1A8E                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x3AE:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x122
	BREQ _0x3AF
; 0000 1A8F                         {
; 0000 1A90                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1A91                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x124
; 0000 1A92                         }
; 0000 1A93 
; 0000 1A94 
; 0000 1A95                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3AF:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x125
	AND  R30,R0
	BREQ _0x3B0
; 0000 1A96                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x126
; 0000 1A97 
; 0000 1A98                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3B0:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x127
	AND  R30,R0
	BREQ _0x3B1
; 0000 1A99                         {
; 0000 1A9A                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1A9B                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x128
; 0000 1A9C                         }
; 0000 1A9D 
; 0000 1A9E                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3B1:
	CALL SUBOPT_0x129
	AND  R30,R0
	BREQ _0x3B2
; 0000 1A9F                         {
; 0000 1AA0                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1AA1                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x12A
; 0000 1AA2                         }
; 0000 1AA3 
; 0000 1AA4                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1AA5                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x3B2:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x12B
	AND  R30,R0
	BREQ _0x3B3
; 0000 1AA6                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x12C
; 0000 1AA7 
; 0000 1AA8 
; 0000 1AA9                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x3B3:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x12D
	AND  R30,R0
	BREQ _0x3B4
; 0000 1AAA                         {
; 0000 1AAB                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1AAC                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x12E
; 0000 1AAD                         }
; 0000 1AAE 
; 0000 1AAF 
; 0000 1AB0 
; 0000 1AB1 
; 0000 1AB2 
; 0000 1AB3 
; 0000 1AB4 
; 0000 1AB5                                                               //to nowy war, ostatni dzien w borg
; 0000 1AB6                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3B4:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x130
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x154
	CALL SUBOPT_0x132
	BREQ _0x3B5
; 0000 1AB7                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x133
	CALL SUBOPT_0xEF
; 0000 1AB8 
; 0000 1AB9                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3B5:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x134
	CALL SUBOPT_0x135
	BREQ _0x3B6
; 0000 1ABA                         {
; 0000 1ABB                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x136
	BRNE _0x3B7
; 0000 1ABC                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1ABD                         if(abs_ster4 == 0)
_0x3B7:
	CALL SUBOPT_0x138
	BRNE _0x3B8
; 0000 1ABE                             {
; 0000 1ABF                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x157
	BRNE _0x3B9
; 0000 1AC0                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1AC1                             szczotka_druc_cykl++;
_0x3B9:
	CALL SUBOPT_0x139
; 0000 1AC2                             abs_ster4 = 1;
; 0000 1AC3                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x158
	CP   R4,R26
	CPC  R5,R27
	BRNE _0x3BC
; 0000 1AC4                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0x11D
; 0000 1AC5                             }
_0x3BC:
; 0000 1AC6                         else
	RJMP _0x3BD
_0x3B8:
; 0000 1AC7                             {
; 0000 1AC8                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1AC9                             abs_ster4 = 0;
	CALL SUBOPT_0x13A
; 0000 1ACA                             sek13 = 0;
; 0000 1ACB                             }
_0x3BD:
; 0000 1ACC                         }
; 0000 1ACD 
; 0000 1ACE                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3B6:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13C
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x13D
	BREQ _0x3C0
; 0000 1ACF                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x86
	CALL SUBOPT_0xFA
; 0000 1AD0 
; 0000 1AD1 
; 0000 1AD2                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3C0:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x13F
	BREQ _0x3C1
; 0000 1AD3                         {
; 0000 1AD4                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1AD5                         if(abs_ster3 == 0)
	CALL SUBOPT_0x141
	BRNE _0x3C2
; 0000 1AD6                             {
; 0000 1AD7                             krazek_scierny_cykl++;
	CALL SUBOPT_0x142
; 0000 1AD8                             abs_ster3 = 1;
; 0000 1AD9                             }
; 0000 1ADA                         else
	RJMP _0x3C3
_0x3C2:
; 0000 1ADB                             abs_ster3 = 0;
	CALL SUBOPT_0x143
; 0000 1ADC                         }
_0x3C3:
; 0000 1ADD 
; 0000 1ADE                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3C1:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13C
	CALL SUBOPT_0x85
	AND  R30,R0
	BREQ _0x3C4
; 0000 1ADF                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x7B
	CALL SUBOPT_0xFA
; 0000 1AE0 
; 0000 1AE1                        if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x3C4:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x130
	CALL SUBOPT_0x85
	CALL SUBOPT_0x144
	BREQ _0x3C5
; 0000 1AE2                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x82
	CALL SUBOPT_0x159
	CALL SUBOPT_0xEF
; 0000 1AE3 
; 0000 1AE4                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1AE5 
; 0000 1AE6                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonalem_komplet_okregow == 3)
_0x3C5:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x146
	BREQ _0x3C6
; 0000 1AE7                        {
; 0000 1AE8                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1AE9                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x147
; 0000 1AEA                        }
; 0000 1AEB                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x3C6:
	CALL SUBOPT_0x148
	MOV  R0,R30
	CALL SUBOPT_0x13B
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3C7
; 0000 1AEC                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xED
; 0000 1AED 
; 0000 1AEE                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x3C7:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x149
	AND  R30,R0
	BREQ _0x3C8
; 0000 1AEF                        {
; 0000 1AF0                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x14A
; 0000 1AF1                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1AF2                        }
; 0000 1AF3                    //////////////////////////////////////////////
; 0000 1AF4 
; 0000 1AF5 
; 0000 1AF6 
; 0000 1AF7                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1AF8 
; 0000 1AF9                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x3C8:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x134
	CALL SUBOPT_0x14B
	BREQ _0x3CB
; 0000 1AFA                        {
; 0000 1AFB                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1AFC                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1AFD                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x14C
; 0000 1AFE                        }
; 0000 1AFF                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3CB:
	CALL SUBOPT_0x14D
	MOV  R0,R30
	CALL SUBOPT_0x12F
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3CE
; 0000 1B00                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 1B01 
; 0000 1B02                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3CE:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x14E
	AND  R30,R0
	BREQ _0x3CF
; 0000 1B03                        {
; 0000 1B04                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x14F
; 0000 1B05                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1B06                        }
; 0000 1B07                    //////////////////////////////////////////////
; 0000 1B08 
; 0000 1B09                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3CF:
; 0000 1B0A                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1B0B                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1B0C                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0 &  wykonalem_komplet_okregow == 3)
	CALL SUBOPT_0x150
	CALL SUBOPT_0x151
	CALL SUBOPT_0x152
	CALL SUBOPT_0x153
	CALL SUBOPT_0x154
	CALL SUBOPT_0x155
	BREQ _0x3D2
; 0000 1B0D                         {
; 0000 1B0E                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x14A
; 0000 1B0F                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x14F
; 0000 1B10                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 1B11                         cykl_sterownik_2 = 0;
; 0000 1B12                         cykl_sterownik_3 = 0;
; 0000 1B13                         cykl_sterownik_4 = 0;
; 0000 1B14                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x156
; 0000 1B15                         krazek_scierny_cykl = 0;
; 0000 1B16                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1B17                         wykonalem_komplet_okregow = 0;
; 0000 1B18                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1B19                         //PORTF = PORT_F.byte;
; 0000 1B1A                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1B1B                         cykl_glowny = 9;
; 0000 1B1C                         }
; 0000 1B1D 
; 0000 1B1E  }
_0x3D2:
	RET
;
;
;
;void przypadek997()
; 0000 1B23 
; 0000 1B24 {
_przypadek997:
; 0000 1B25 
; 0000 1B26            if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x11A
	BRGE _0x3D5
; 0000 1B27                         {
; 0000 1B28                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x11B
; 0000 1B29                         PORTF = PORT_F.byte;
; 0000 1B2A                         }
; 0000 1B2B 
; 0000 1B2C 
; 0000 1B2D                      if(rzad_obrabiany == 2)
_0x3D5:
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x3D6
; 0000 1B2E                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1B2F 
; 0000 1B30                     if(koniec_rzedu_10 == 1)
_0x3D6:
	CALL SUBOPT_0x11C
	BRNE _0x3D7
; 0000 1B31                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x11D
; 0000 1B32                                                               //to nowy war, ostatni dzien w borg
; 0000 1B33                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3D7:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x130
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x154
	CALL SUBOPT_0x132
	BREQ _0x3D8
; 0000 1B34                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x133
	CALL SUBOPT_0xEF
; 0000 1B35 
; 0000 1B36                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3D8:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x134
	CALL SUBOPT_0x135
	BREQ _0x3D9
; 0000 1B37                         {
; 0000 1B38                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x136
	BRNE _0x3DA
; 0000 1B39                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1B3A                         if(abs_ster4 == 0)
_0x3DA:
	CALL SUBOPT_0x138
	BRNE _0x3DB
; 0000 1B3B                             {
; 0000 1B3C                             szczotka_druc_cykl++;
	CALL SUBOPT_0x15A
; 0000 1B3D                             //////////////////////
; 0000 1B3E                             if(statystyka == 1)
	CALL SUBOPT_0x15B
	BRNE _0x3DC
; 0000 1B3F                                 {
; 0000 1B40                                 wartosc_parametru_panelu(szczotka_druc_cykl,96,128);
	CALL SUBOPT_0x15C
	CALL SUBOPT_0xB4
	CALL _wartosc_parametru_panelu
; 0000 1B41                                 wartosc_parametru_panelu(cykl_ilosc_zaciskow,128,80);  //pamietac ze zmienna cykl tak naprawde dodaje sie dalej w programie, czyli jak tu bedzie 7 to znaczy ze jestesmy na dolku 8
	CALL SUBOPT_0x15D
	CALL SUBOPT_0x15E
	CALL SUBOPT_0xBA
	CALL _wartosc_parametru_panelu
; 0000 1B42                                 }
; 0000 1B43                             //////////////////////////
; 0000 1B44                             abs_ster4 = 1;
_0x3DC:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R31
; 0000 1B45                             }
; 0000 1B46                        else
	RJMP _0x3DD
_0x3DB:
; 0000 1B47                             {
; 0000 1B48                             abs_ster4 = 0;
	CALL SUBOPT_0x13A
; 0000 1B49                             sek13 = 0;
; 0000 1B4A                             }
_0x3DD:
; 0000 1B4B                         }
; 0000 1B4C 
; 0000 1B4D                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3D9:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13C
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x13D
	BREQ _0x3DE
; 0000 1B4E                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x86
	CALL SUBOPT_0xFA
; 0000 1B4F 
; 0000 1B50 
; 0000 1B51                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3DE:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x13F
	BREQ _0x3DF
; 0000 1B52                         {
; 0000 1B53                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1B54                         if(abs_ster3 == 0)
	CALL SUBOPT_0x141
	BRNE _0x3E0
; 0000 1B55                             {
; 0000 1B56                             krazek_scierny_cykl++;
	CALL SUBOPT_0x15F
; 0000 1B57                             //////////////////////
; 0000 1B58                             if(statystyka == 1)
	CALL SUBOPT_0x15B
	BRNE _0x3E1
; 0000 1B59                                 wartosc_parametru_panelu(krazek_scierny_cykl,128,96);
	CALL SUBOPT_0x160
	CALL SUBOPT_0x24
	CALL _wartosc_parametru_panelu
; 0000 1B5A                             //////////////////////////
; 0000 1B5B                             abs_ster3 = 1;
_0x3E1:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R31
; 0000 1B5C                             }
; 0000 1B5D                         else
	RJMP _0x3E2
_0x3E0:
; 0000 1B5E                             abs_ster3 = 0;
	CALL SUBOPT_0x143
; 0000 1B5F                         }
_0x3E2:
; 0000 1B60 
; 0000 1B61                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3DF:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13C
	CALL SUBOPT_0x85
	AND  R30,R0
	BREQ _0x3E3
; 0000 1B62                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x7B
	CALL SUBOPT_0xFA
; 0000 1B63 
; 0000 1B64 
; 0000 1B65                      if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x3E3:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x130
	CALL SUBOPT_0x85
	CALL SUBOPT_0x144
	BREQ _0x3E4
; 0000 1B66                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory kawaleczek
	CALL SUBOPT_0x145
	CALL SUBOPT_0xEF
; 0000 1B67 
; 0000 1B68                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1B69 
; 0000 1B6A                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonano_powrot_przedwczesny_krazek_scierny == 0)
_0x3E4:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x161
	AND  R0,R30
	LDS  R26,_wykonano_powrot_przedwczesny_krazek_scierny
	LDS  R27,_wykonano_powrot_przedwczesny_krazek_scierny+1
	CALL SUBOPT_0xCE
	BREQ _0x3E5
; 0000 1B6B                        {
; 0000 1B6C                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1B6D                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x147
; 0000 1B6E                        //////////////////////
; 0000 1B6F                        if(statystyka == 1)
	CALL SUBOPT_0x15B
	BRNE _0x3E6
; 0000 1B70                             wartosc_parametru_panelu(powrot_przedwczesny_krazek_scierny,128,112);
	CALL SUBOPT_0x162
	CALL SUBOPT_0xA7
	CALL _wartosc_parametru_panelu
; 0000 1B71                        //////////////////////////
; 0000 1B72                        }
_0x3E6:
; 0000 1B73                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x3E5:
	CALL SUBOPT_0x148
	MOV  R0,R30
	CALL SUBOPT_0x13B
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3E7
; 0000 1B74                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xED
; 0000 1B75 
; 0000 1B76                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x3E7:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x149
	AND  R30,R0
	BREQ _0x3E8
; 0000 1B77                        {
; 0000 1B78                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x14A
; 0000 1B79                        wykonano_powrot_przedwczesny_krazek_scierny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonano_powrot_przedwczesny_krazek_scierny,R30
	STS  _wykonano_powrot_przedwczesny_krazek_scierny+1,R31
; 0000 1B7A                        //////////////////////
; 0000 1B7B                        if(statystyka == 1)
	CALL SUBOPT_0x15B
	BRNE _0x3E9
; 0000 1B7C                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_krazek_scierny,128,128);
	CALL SUBOPT_0x163
	CALL SUBOPT_0xB4
	CALL _wartosc_parametru_panelu
; 0000 1B7D                        //////////////////////////
; 0000 1B7E                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
_0x3E9:
	CBI  0x3,3
; 0000 1B7F                        }
; 0000 1B80                    //////////////////////////////////////////////
; 0000 1B81 
; 0000 1B82 
; 0000 1B83 
; 0000 1B84                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1B85 
; 0000 1B86                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli & wykonano_powrot_przedwczesny_druciak == 0)
_0x3E8:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x134
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x164
	AND  R0,R30
	LDS  R26,_wykonano_powrot_przedwczesny_druciak
	LDS  R27,_wykonano_powrot_przedwczesny_druciak+1
	CALL SUBOPT_0xCE
	BREQ _0x3EC
; 0000 1B87                        {
; 0000 1B88                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1B89                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1B8A                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x14C
; 0000 1B8B                        //////////////////////
; 0000 1B8C                        if(statystyka == 1)
	CALL SUBOPT_0x15B
	BRNE _0x3EF
; 0000 1B8D                             wartosc_parametru_panelu(powrot_przedwczesny_druciak,96,144);
	CALL SUBOPT_0x165
	CALL SUBOPT_0xA5
	CALL _wartosc_parametru_panelu
; 0000 1B8E                        //////////////////////////
; 0000 1B8F                        }
_0x3EF:
; 0000 1B90                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3EC:
	CALL SUBOPT_0x14D
	MOV  R0,R30
	CALL SUBOPT_0x12F
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3F0
; 0000 1B91                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 1B92 
; 0000 1B93                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3F0:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x14E
	AND  R30,R0
	BREQ _0x3F1
; 0000 1B94                        {
; 0000 1B95                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x14F
; 0000 1B96                        wykonano_powrot_przedwczesny_druciak = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonano_powrot_przedwczesny_druciak,R30
	STS  _wykonano_powrot_przedwczesny_druciak+1,R31
; 0000 1B97                        ///////////////////////////////
; 0000 1B98                        if(statystyka == 1)
	CALL SUBOPT_0x15B
	BRNE _0x3F2
; 0000 1B99                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_druciak,112,0);
	CALL SUBOPT_0x166
	CALL SUBOPT_0xA
	CALL _wartosc_parametru_panelu
; 0000 1B9A                        //////////////////////////////
; 0000 1B9B                        PORTE.2 = 0;  //wylacz szlifierke
_0x3F2:
	CBI  0x3,2
; 0000 1B9C                        }
; 0000 1B9D                    ///////////////////////////////////////////////////////////////////////
; 0000 1B9E 
; 0000 1B9F                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3F1:
; 0000 1BA0                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1BA1                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1BA2                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0)
	CALL SUBOPT_0x150
	CALL SUBOPT_0x151
	CALL SUBOPT_0x152
	CALL SUBOPT_0x153
	CALL SUBOPT_0x131
	CALL SUBOPT_0xCE
	BREQ _0x3F5
; 0000 1BA3                         {
; 0000 1BA4                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x14A
; 0000 1BA5                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x14F
; 0000 1BA6                         wykonano_powrot_przedwczesny_krazek_scierny = 0;
	LDI  R30,LOW(0)
	STS  _wykonano_powrot_przedwczesny_krazek_scierny,R30
	STS  _wykonano_powrot_przedwczesny_krazek_scierny+1,R30
; 0000 1BA7                         wykonano_powrot_przedwczesny_druciak = 0;
	STS  _wykonano_powrot_przedwczesny_druciak,R30
	STS  _wykonano_powrot_przedwczesny_druciak+1,R30
; 0000 1BA8                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 1BA9                         cykl_sterownik_2 = 0;
; 0000 1BAA                         cykl_sterownik_3 = 0;
; 0000 1BAB                         cykl_sterownik_4 = 0;
; 0000 1BAC                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x167
; 0000 1BAD                         krazek_scierny_cykl = 0;
; 0000 1BAE                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1BAF                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1BB0                         //PORTF = PORT_F.byte;
; 0000 1BB1                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1BB2 
; 0000 1BB3                         if(statystyka == 1)
	CALL SUBOPT_0x15B
	BRNE _0x3F8
; 0000 1BB4                             {
; 0000 1BB5                             wartosc_parametru_panelu(szczotka_druc_cykl,96,128);
	CALL SUBOPT_0x15C
	CALL SUBOPT_0xB4
	CALL _wartosc_parametru_panelu
; 0000 1BB6                             wartosc_parametru_panelu(krazek_scierny_cykl,128,96);
	CALL SUBOPT_0x160
	CALL SUBOPT_0x24
	CALL _wartosc_parametru_panelu
; 0000 1BB7                             wartosc_parametru_panelu(powrot_przedwczesny_druciak,96,144);
	CALL SUBOPT_0x165
	CALL SUBOPT_0xA5
	CALL _wartosc_parametru_panelu
; 0000 1BB8                             wartosc_parametru_panelu(powrot_przedwczesny_krazek_scierny,128,112);
	CALL SUBOPT_0x162
	CALL SUBOPT_0xA7
	CALL _wartosc_parametru_panelu
; 0000 1BB9                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_druciak,112,0);
	CALL SUBOPT_0x166
	CALL SUBOPT_0xA
	CALL _wartosc_parametru_panelu
; 0000 1BBA                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_krazek_scierny,128,128);
	CALL SUBOPT_0x163
	CALL SUBOPT_0xB4
	CALL _wartosc_parametru_panelu
; 0000 1BBB                             }
; 0000 1BBC                         cykl_glowny = 9;
_0x3F8:
	CALL SUBOPT_0x168
; 0000 1BBD                         }
; 0000 1BBE 
; 0000 1BBF }
_0x3F5:
	RET
;
;void przypadek998()
; 0000 1BC2 {
_przypadek998:
; 0000 1BC3 
; 0000 1BC4            if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x11A
	BRGE _0x3F9
; 0000 1BC5                         {
; 0000 1BC6                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x11B
; 0000 1BC7                         PORTF = PORT_F.byte;
; 0000 1BC8                         }
; 0000 1BC9 
; 0000 1BCA 
; 0000 1BCB                      if(rzad_obrabiany == 2)
_0x3F9:
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x3FA
; 0000 1BCC                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1BCD 
; 0000 1BCE                     if(koniec_rzedu_10 == 1)
_0x3FA:
	CALL SUBOPT_0x11C
	BRNE _0x3FB
; 0000 1BCF                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x11D
; 0000 1BD0 
; 0000 1BD1                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3FB:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x130
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x154
	CALL SUBOPT_0x132
	BREQ _0x3FC
; 0000 1BD2                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x133
	CALL SUBOPT_0xEF
; 0000 1BD3 
; 0000 1BD4                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3FC:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x134
	CALL SUBOPT_0x135
	BREQ _0x3FD
; 0000 1BD5                         {
; 0000 1BD6                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x136
	BRNE _0x3FE
; 0000 1BD7                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1BD8                         if(abs_ster4 == 0)
_0x3FE:
	CALL SUBOPT_0x138
	BRNE _0x3FF
; 0000 1BD9                             {
; 0000 1BDA                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x157
	BRNE _0x400
; 0000 1BDB                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1BDC                             szczotka_druc_cykl++;
_0x400:
	CALL SUBOPT_0x139
; 0000 1BDD                             abs_ster4 = 1;
; 0000 1BDE                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x158
	CP   R4,R26
	CPC  R5,R27
	BRNE _0x403
; 0000 1BDF                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0x11D
; 0000 1BE0                             }
_0x403:
; 0000 1BE1                         else
	RJMP _0x404
_0x3FF:
; 0000 1BE2                             {
; 0000 1BE3                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1BE4                             abs_ster4 = 0;
	CALL SUBOPT_0x13A
; 0000 1BE5                             sek13 = 0;
; 0000 1BE6                             }
_0x404:
; 0000 1BE7                         }
; 0000 1BE8 
; 0000 1BE9                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3FD:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13C
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x13D
	BREQ _0x407
; 0000 1BEA                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x86
	CALL SUBOPT_0xFA
; 0000 1BEB 
; 0000 1BEC 
; 0000 1BED                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x407:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x13F
	BREQ _0x408
; 0000 1BEE                         {
; 0000 1BEF                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1BF0                         if(abs_ster3 == 0)
	CALL SUBOPT_0x141
	BRNE _0x409
; 0000 1BF1                             {
; 0000 1BF2                             krazek_scierny_cykl++;
	CALL SUBOPT_0x142
; 0000 1BF3 
; 0000 1BF4                             abs_ster3 = 1;
; 0000 1BF5                             }
; 0000 1BF6                         else
	RJMP _0x40A
_0x409:
; 0000 1BF7                             abs_ster3 = 0;
	CALL SUBOPT_0x143
; 0000 1BF8                         }
_0x40A:
; 0000 1BF9 
; 0000 1BFA                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x408:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13C
	CALL SUBOPT_0x85
	AND  R30,R0
	BREQ _0x40B
; 0000 1BFB                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x7B
	CALL SUBOPT_0xFA
; 0000 1BFC 
; 0000 1BFD                        if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x40B:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x130
	CALL SUBOPT_0x85
	CALL SUBOPT_0x144
	BREQ _0x40C
; 0000 1BFE                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x82
	CALL SUBOPT_0x159
	CALL SUBOPT_0xEF
; 0000 1BFF 
; 0000 1C00 
; 0000 1C01 
; 0000 1C02                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1C03 
; 0000 1C04                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x40C:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x161
	AND  R30,R0
	BREQ _0x40D
; 0000 1C05                        {
; 0000 1C06                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1C07                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x147
; 0000 1C08                        }
; 0000 1C09                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x40D:
	CALL SUBOPT_0x148
	MOV  R0,R30
	CALL SUBOPT_0x13B
	CALL __LTW12
	AND  R30,R0
	BREQ _0x40E
; 0000 1C0A                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xED
; 0000 1C0B 
; 0000 1C0C                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x40E:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x149
	AND  R30,R0
	BREQ _0x40F
; 0000 1C0D                        {
; 0000 1C0E                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x14A
; 0000 1C0F                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1C10                        }
; 0000 1C11                    //////////////////////////////////////////////
; 0000 1C12 
; 0000 1C13 
; 0000 1C14 
; 0000 1C15                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1C16 
; 0000 1C17                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x40F:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x134
	CALL SUBOPT_0x14B
	BREQ _0x412
; 0000 1C18                        {
; 0000 1C19                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1C1A                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1C1B                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x14C
; 0000 1C1C                        }
; 0000 1C1D                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x412:
	CALL SUBOPT_0x14D
	MOV  R0,R30
	CALL SUBOPT_0x12F
	CALL __LTW12
	AND  R30,R0
	BREQ _0x415
; 0000 1C1E                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 1C1F 
; 0000 1C20                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x415:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x14E
	AND  R30,R0
	BREQ _0x416
; 0000 1C21                        {
; 0000 1C22                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x14F
; 0000 1C23                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1C24                        }
; 0000 1C25                    //////////////////////////////////////////////
; 0000 1C26 
; 0000 1C27                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x416:
; 0000 1C28                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1C29                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1C2A                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0)
	CALL SUBOPT_0x150
	CALL SUBOPT_0x151
	CALL SUBOPT_0x152
	CALL SUBOPT_0x153
	CALL SUBOPT_0x131
	CALL SUBOPT_0xCE
	BREQ _0x419
; 0000 1C2B                         {
; 0000 1C2C                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x14A
; 0000 1C2D                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x14F
; 0000 1C2E                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 1C2F                         cykl_sterownik_2 = 0;
; 0000 1C30                         cykl_sterownik_3 = 0;
; 0000 1C31                         cykl_sterownik_4 = 0;
; 0000 1C32                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x167
; 0000 1C33                         krazek_scierny_cykl = 0;
; 0000 1C34                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1C35                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1C36                         //PORTF = PORT_F.byte;
; 0000 1C37                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1C38                         cykl_glowny = 9;
	CALL SUBOPT_0x168
; 0000 1C39                         }
; 0000 1C3A }
_0x419:
	RET
;
;
;void przypadek8()
; 0000 1C3E 
; 0000 1C3F {
_przypadek8:
; 0000 1C40 
; 0000 1C41                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x11A
	BRGE _0x41C
; 0000 1C42                         {
; 0000 1C43                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x11B
; 0000 1C44                         PORTF = PORT_F.byte;
; 0000 1C45                         }
; 0000 1C46 
; 0000 1C47 
; 0000 1C48                      if(rzad_obrabiany == 2)
_0x41C:
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x41D
; 0000 1C49                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1C4A 
; 0000 1C4B 
; 0000 1C4C 
; 0000 1C4D                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x41D:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x11F
	CALL SUBOPT_0x120
	BREQ _0x41E
; 0000 1C4E                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x121
; 0000 1C4F                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x41E:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x122
	BREQ _0x41F
; 0000 1C50                         {
; 0000 1C51                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1C52                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x124
; 0000 1C53                         }
; 0000 1C54 
; 0000 1C55 
; 0000 1C56                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x41F:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x125
	AND  R30,R0
	BREQ _0x420
; 0000 1C57                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x126
; 0000 1C58 
; 0000 1C59                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x420:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x127
	AND  R30,R0
	BREQ _0x421
; 0000 1C5A                         {
; 0000 1C5B                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1C5C                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x128
; 0000 1C5D                         }
; 0000 1C5E 
; 0000 1C5F                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x421:
	CALL SUBOPT_0x129
	AND  R30,R0
	BREQ _0x422
; 0000 1C60                         {
; 0000 1C61                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1C62                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x12A
; 0000 1C63                         }
; 0000 1C64 
; 0000 1C65                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1C66                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x422:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x12B
	AND  R30,R0
	BREQ _0x423
; 0000 1C67                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x12C
; 0000 1C68 
; 0000 1C69 
; 0000 1C6A                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x423:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x12D
	AND  R30,R0
	BREQ _0x424
; 0000 1C6B                         {
; 0000 1C6C                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1C6D                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x12E
; 0000 1C6E                         }
; 0000 1C6F 
; 0000 1C70                     if(cykl_sterownik_3 < 5 & wykonalem_komplet_okregow == 3)
_0x424:
	CALL SUBOPT_0x13B
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x155
	BREQ _0x425
; 0000 1C71                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV         //tu zmienienie INV, ¿eby szed³ w dol
	CALL SUBOPT_0x86
	CALL SUBOPT_0xFA
; 0000 1C72 
; 0000 1C73                      if(cykl_sterownik_3 == 5 & wykonalem_komplet_okregow == 3)
_0x425:
	CALL SUBOPT_0x13B
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x155
	BREQ _0x426
; 0000 1C74                         {
; 0000 1C75                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x169
; 0000 1C76                         krazek_scierny_cykl++;
; 0000 1C77 
; 0000 1C78                         if(krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x16A
	BRNE _0x427
; 0000 1C79                             {
; 0000 1C7A                             wykonalem_komplet_okregow = 4;
	CALL SUBOPT_0x16B
; 0000 1C7B                             }
; 0000 1C7C                         else
	RJMP _0x428
_0x427:
; 0000 1C7D                             wykonalem_komplet_okregow = 0;
	CALL SUBOPT_0x16C
; 0000 1C7E 
; 0000 1C7F                         cykl_sterownik_1 = 0;
_0x428:
	CALL SUBOPT_0x123
; 0000 1C80                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1C81                         }
; 0000 1C82 
; 0000 1C83 
; 0000 1C84 
; 0000 1C85 
; 0000 1C86 
; 0000 1C87                     if(koniec_rzedu_10 == 1)
_0x426:
	CALL SUBOPT_0x11C
	BRNE _0x429
; 0000 1C88                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x11D
; 0000 1C89                                                               //to nowy war, ostatni dzien w borg
; 0000 1C8A                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze & koniec_rzedu_10 == 0)
_0x429:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x130
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x154
	CALL SUBOPT_0x16D
	BREQ _0x42A
; 0000 1C8B                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x133
	CALL SUBOPT_0xEF
; 0000 1C8C 
; 0000 1C8D                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x42A:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x134
	CALL __LTW12
	AND  R0,R30
	CALL SUBOPT_0x154
	CALL SUBOPT_0x16E
	BREQ _0x42B
; 0000 1C8E                         {
; 0000 1C8F                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x136
	BRNE _0x42C
; 0000 1C90                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1C91                         if(abs_ster4 == 0)
_0x42C:
	CALL SUBOPT_0x138
	BRNE _0x42D
; 0000 1C92                             {
; 0000 1C93                             szczotka_druc_cykl++;
	CALL SUBOPT_0x139
; 0000 1C94                             abs_ster4 = 1;
; 0000 1C95                             }
; 0000 1C96                         else
	RJMP _0x42E
_0x42D:
; 0000 1C97                             {
; 0000 1C98                             abs_ster4 = 0;
	CALL SUBOPT_0x13A
; 0000 1C99                             sek13 = 0;
; 0000 1C9A                             }
_0x42E:
; 0000 1C9B                         }
; 0000 1C9C 
; 0000 1C9D 
; 0000 1C9E                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x42B:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x130
	CALL SUBOPT_0x85
	AND  R0,R30
	CALL SUBOPT_0x154
	CALL SUBOPT_0x16E
	BREQ _0x42F
; 0000 1C9F                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory
	CALL SUBOPT_0x145
	CALL SUBOPT_0xEF
; 0000 1CA0 
; 0000 1CA1 
; 0000 1CA2                         ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1CA3 
; 0000 1CA4                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x42F:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x161
	AND  R30,R0
	BREQ _0x430
; 0000 1CA5                        {
; 0000 1CA6                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1CA7                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x147
; 0000 1CA8                        }
; 0000 1CA9                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x430:
	CALL SUBOPT_0x148
	MOV  R0,R30
	CALL SUBOPT_0x13B
	CALL __LTW12
	AND  R30,R0
	BREQ _0x431
; 0000 1CAA                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xED
; 0000 1CAB 
; 0000 1CAC                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x431:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x149
	AND  R30,R0
	BREQ _0x432
; 0000 1CAD                        {
; 0000 1CAE                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x14A
; 0000 1CAF                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1CB0                        }
; 0000 1CB1                    //////////////////////////////////////////////
; 0000 1CB2 
; 0000 1CB3 
; 0000 1CB4 
; 0000 1CB5                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1CB6 
; 0000 1CB7                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
_0x432:
	CALL SUBOPT_0x16F
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x170
	OR   R30,R0
	AND  R30,R1
	BREQ _0x435
; 0000 1CB8                        {
; 0000 1CB9                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1CBA                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1CBB                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x14C
; 0000 1CBC                        }
; 0000 1CBD                   if(koniec_rzedu_10 == 0 & powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x435:
	CALL SUBOPT_0x16F
	CALL SUBOPT_0x14D
	AND  R0,R30
	CALL SUBOPT_0x12F
	CALL __LTW12
	AND  R30,R0
	BREQ _0x438
; 0000 1CBE                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 1CBF 
; 0000 1CC0                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x438:
	CALL SUBOPT_0x16F
	CALL SUBOPT_0x12F
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x14D
	AND  R30,R0
	BREQ _0x439
; 0000 1CC1                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x14F
; 0000 1CC2                    //////////////////////////////////////////////
; 0000 1CC3 
; 0000 1CC4                     if((wykonalem_komplet_okregow == 4 &
_0x439:
; 0000 1CC5                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 1CC6                         cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0 & powrot_przedwczesny_krazek_scierny == 0) | (wykonalem_komplet_okregow == 4 & koniec_rzedu_10 == 1 & powrot_przedwczesny_krazek_scierny == 0) )
	CALL SUBOPT_0x171
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x154
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x172
	AND  R0,R30
	CALL SUBOPT_0x13D
	OR   R30,R1
	BREQ _0x43A
; 0000 1CC7                         {
; 0000 1CC8                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x14F
; 0000 1CC9                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x14A
; 0000 1CCA                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 1CCB                         cykl_sterownik_2 = 0;
; 0000 1CCC                         cykl_sterownik_3 = 0;
; 0000 1CCD                         cykl_sterownik_4 = 0;
; 0000 1CCE                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x167
; 0000 1CCF                         krazek_scierny_cykl = 0;
; 0000 1CD0                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1CD1                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1CD2                         //PORTF = PORT_F.byte;
; 0000 1CD3                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1CD4                         cykl_glowny = 9;
	CALL SUBOPT_0x168
; 0000 1CD5                         }
; 0000 1CD6 }
_0x43A:
	RET
;                                                                                                //ster 1 - ruch po okregu
;                                                                                                //ster 2 - nic
;                                                                                                //ster 3 - krazek - gora dol
;                                                                                                //ster 4 - druciak - gora dol
;
;
;void przypadek88()
; 0000 1CDE {
_przypadek88:
; 0000 1CDF 
; 0000 1CE0                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x11A
	BRGE _0x43D
; 0000 1CE1                         {
; 0000 1CE2                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x11B
; 0000 1CE3                         PORTF = PORT_F.byte;
; 0000 1CE4                         }
; 0000 1CE5 
; 0000 1CE6 
; 0000 1CE7                      if(rzad_obrabiany == 2)
_0x43D:
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x43E
; 0000 1CE8                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1CE9 
; 0000 1CEA 
; 0000 1CEB 
; 0000 1CEC                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x43E:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x11F
	CALL SUBOPT_0x120
	BREQ _0x43F
; 0000 1CED                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x121
; 0000 1CEE                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x43F:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x122
	BREQ _0x440
; 0000 1CEF                         {
; 0000 1CF0                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1CF1                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x124
; 0000 1CF2                         }
; 0000 1CF3 
; 0000 1CF4 
; 0000 1CF5                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x440:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x125
	AND  R30,R0
	BREQ _0x441
; 0000 1CF6                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x126
; 0000 1CF7 
; 0000 1CF8                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x441:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x127
	AND  R30,R0
	BREQ _0x442
; 0000 1CF9                         {
; 0000 1CFA                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1CFB                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x128
; 0000 1CFC                         }
; 0000 1CFD 
; 0000 1CFE                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x442:
	CALL SUBOPT_0x129
	AND  R30,R0
	BREQ _0x443
; 0000 1CFF                         {
; 0000 1D00                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1D01                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x12A
; 0000 1D02                         }
; 0000 1D03 
; 0000 1D04                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1D05                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x443:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x12B
	AND  R30,R0
	BREQ _0x444
; 0000 1D06                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x12C
; 0000 1D07 
; 0000 1D08 
; 0000 1D09                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x444:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x12D
	AND  R30,R0
	BREQ _0x445
; 0000 1D0A                         {
; 0000 1D0B                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1D0C                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x12E
; 0000 1D0D                         }
; 0000 1D0E 
; 0000 1D0F                     if(cykl_sterownik_3 < 5 & wykonalem_komplet_okregow == 3)
_0x445:
	CALL SUBOPT_0x13B
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x155
	BREQ _0x446
; 0000 1D10                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV         //tu zmienienie INV, ¿eby szed³ w dol
	CALL SUBOPT_0x86
	CALL SUBOPT_0xFA
; 0000 1D11 
; 0000 1D12                      if(cykl_sterownik_3 == 5 & wykonalem_komplet_okregow == 3)
_0x446:
	CALL SUBOPT_0x13B
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x155
	BREQ _0x447
; 0000 1D13                         {
; 0000 1D14                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x169
; 0000 1D15                         krazek_scierny_cykl++;
; 0000 1D16 
; 0000 1D17                         if(krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x16A
	BRNE _0x448
; 0000 1D18                             {
; 0000 1D19                             wykonalem_komplet_okregow = 4;
	CALL SUBOPT_0x16B
; 0000 1D1A                             }
; 0000 1D1B                         else
	RJMP _0x449
_0x448:
; 0000 1D1C                             wykonalem_komplet_okregow = 0;
	CALL SUBOPT_0x16C
; 0000 1D1D 
; 0000 1D1E                         cykl_sterownik_1 = 0;
_0x449:
	CALL SUBOPT_0x123
; 0000 1D1F                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1D20                         }
; 0000 1D21 
; 0000 1D22 
; 0000 1D23 
; 0000 1D24 
; 0000 1D25 
; 0000 1D26                     if(koniec_rzedu_10 == 1)
_0x447:
	CALL SUBOPT_0x11C
	BRNE _0x44A
; 0000 1D27                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x11D
; 0000 1D28                                                               //to nowy war, ostatni dzien w borg
; 0000 1D29                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze & koniec_rzedu_10 == 0)
_0x44A:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x130
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x154
	CALL SUBOPT_0x16D
	BREQ _0x44B
; 0000 1D2A                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x133
	CALL SUBOPT_0xEF
; 0000 1D2B 
; 0000 1D2C                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x44B:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x134
	CALL __LTW12
	AND  R0,R30
	CALL SUBOPT_0x154
	CALL SUBOPT_0x16E
	BREQ _0x44C
; 0000 1D2D                         {
; 0000 1D2E                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x136
	BRNE _0x44D
; 0000 1D2F                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1D30                         if(abs_ster4 == 0)
_0x44D:
	CALL SUBOPT_0x138
	BRNE _0x44E
; 0000 1D31                             {
; 0000 1D32                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x157
	BRNE _0x44F
; 0000 1D33                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1D34                             szczotka_druc_cykl++;
_0x44F:
	CALL SUBOPT_0x139
; 0000 1D35                             abs_ster4 = 1;
; 0000 1D36                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x158
	CP   R4,R26
	CPC  R5,R27
	BRNE _0x452
; 0000 1D37                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0x11D
; 0000 1D38                             }
_0x452:
; 0000 1D39                          else
	RJMP _0x453
_0x44E:
; 0000 1D3A                             {
; 0000 1D3B                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1D3C                             abs_ster4 = 0;
	CALL SUBOPT_0x13A
; 0000 1D3D                             sek13 = 0;
; 0000 1D3E                             }
_0x453:
; 0000 1D3F                         }
; 0000 1D40 
; 0000 1D41 
; 0000 1D42 
; 0000 1D43                         if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x44C:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x130
	CALL SUBOPT_0x85
	AND  R0,R30
	CALL SUBOPT_0x154
	CALL SUBOPT_0x16E
	BREQ _0x456
; 0000 1D44                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x82
	CALL SUBOPT_0x159
	CALL SUBOPT_0xEF
; 0000 1D45 
; 0000 1D46                         ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1D47 
; 0000 1D48                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x456:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x161
	AND  R30,R0
	BREQ _0x457
; 0000 1D49                        {
; 0000 1D4A                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1D4B                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x147
; 0000 1D4C                        }
; 0000 1D4D                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x457:
	CALL SUBOPT_0x148
	MOV  R0,R30
	CALL SUBOPT_0x13B
	CALL __LTW12
	AND  R30,R0
	BREQ _0x458
; 0000 1D4E                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xED
; 0000 1D4F 
; 0000 1D50                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x458:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x149
	AND  R30,R0
	BREQ _0x459
; 0000 1D51                        {
; 0000 1D52                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x14A
; 0000 1D53                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1D54                        }
; 0000 1D55                    //////////////////////////////////////////////
; 0000 1D56 
; 0000 1D57 
; 0000 1D58 
; 0000 1D59                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1D5A 
; 0000 1D5B                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
_0x459:
	CALL SUBOPT_0x16F
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x170
	OR   R30,R0
	AND  R30,R1
	BREQ _0x45C
; 0000 1D5C                        {
; 0000 1D5D                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1D5E                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1D5F                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x14C
; 0000 1D60                        }
; 0000 1D61                   if(koniec_rzedu_10 == 0 & powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x45C:
	CALL SUBOPT_0x16F
	CALL SUBOPT_0x14D
	AND  R0,R30
	CALL SUBOPT_0x12F
	CALL __LTW12
	AND  R30,R0
	BREQ _0x45F
; 0000 1D62                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 1D63 
; 0000 1D64                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x45F:
	CALL SUBOPT_0x16F
	CALL SUBOPT_0x12F
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x14D
	AND  R30,R0
	BREQ _0x460
; 0000 1D65                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x14F
; 0000 1D66                    //////////////////////////////////////////////
; 0000 1D67 
; 0000 1D68                     if((wykonalem_komplet_okregow == 4 &
_0x460:
; 0000 1D69                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 1D6A                         cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0 & powrot_przedwczesny_krazek_scierny == 0) | (wykonalem_komplet_okregow == 4 & koniec_rzedu_10 == 1 & powrot_przedwczesny_krazek_scierny == 0) )
	CALL SUBOPT_0x171
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x154
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x172
	AND  R0,R30
	CALL SUBOPT_0x13D
	OR   R30,R1
	BREQ _0x461
; 0000 1D6B                         {
; 0000 1D6C                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x14F
; 0000 1D6D                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x14A
; 0000 1D6E                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 1D6F                         cykl_sterownik_2 = 0;
; 0000 1D70                         cykl_sterownik_3 = 0;
; 0000 1D71                         cykl_sterownik_4 = 0;
; 0000 1D72                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x167
; 0000 1D73                         krazek_scierny_cykl = 0;
; 0000 1D74                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1D75                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1D76                         //PORTF = PORT_F.byte;
; 0000 1D77                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1D78                         cykl_glowny = 9;
	CALL SUBOPT_0x168
; 0000 1D79                         }
; 0000 1D7A 
; 0000 1D7B                                                                                                 //ster 1 - ruch po okregu
; 0000 1D7C                                                                                                 //ster 2 - nic
; 0000 1D7D                                                                                                 //ster 3 - krazek - gora dol
; 0000 1D7E                                                                                                 //ster 4 - druciak - gora dol
; 0000 1D7F 
; 0000 1D80 
; 0000 1D81 }
_0x461:
	RET
;
;
;void main(void)
; 0000 1D85 {
_main:
; 0000 1D86 
; 0000 1D87 // Input/Output Ports initialization
; 0000 1D88 // Port A initialization
; 0000 1D89 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1D8A // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1D8B PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 1D8C DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 1D8D 
; 0000 1D8E // Port B initialization
; 0000 1D8F // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1D90 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1D91 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 1D92 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 1D93 
; 0000 1D94 // Port C initialization
; 0000 1D95 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1D96 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1D97 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 1D98 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 1D99 
; 0000 1D9A // Port D initialization
; 0000 1D9B // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1D9C // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1D9D PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 1D9E DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 1D9F 
; 0000 1DA0 // Port E initialization
; 0000 1DA1 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1DA2 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1DA3 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 1DA4 DDRE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 1DA5 
; 0000 1DA6 // Port F initialization
; 0000 1DA7 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1DA8 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1DA9 PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 1DAA DDRF=0xFF;
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 1DAB 
; 0000 1DAC // Port G initialization
; 0000 1DAD // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1DAE // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1DAF PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 1DB0 DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 1DB1 
; 0000 1DB2 
; 0000 1DB3 
; 0000 1DB4 
; 0000 1DB5 
; 0000 1DB6 // Timer/Counter 0 initialization
; 0000 1DB7 // Clock source: System Clock
; 0000 1DB8 // Clock value: 15,625 kHz
; 0000 1DB9 // Mode: Normal top=0xFF
; 0000 1DBA // OC0 output: Disconnected
; 0000 1DBB ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 1DBC TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 1DBD TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 1DBE OCR0=0x00;
	OUT  0x31,R30
; 0000 1DBF 
; 0000 1DC0 // Timer/Counter 1 initialization
; 0000 1DC1 // Clock source: System Clock
; 0000 1DC2 // Clock value: Timer1 Stopped
; 0000 1DC3 // Mode: Normal top=0xFFFF
; 0000 1DC4 // OC1A output: Discon.
; 0000 1DC5 // OC1B output: Discon.
; 0000 1DC6 // OC1C output: Discon.
; 0000 1DC7 // Noise Canceler: Off
; 0000 1DC8 // Input Capture on Falling Edge
; 0000 1DC9 // Timer1 Overflow Interrupt: Off
; 0000 1DCA // Input Capture Interrupt: Off
; 0000 1DCB // Compare A Match Interrupt: Off
; 0000 1DCC // Compare B Match Interrupt: Off
; 0000 1DCD // Compare C Match Interrupt: Off
; 0000 1DCE TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 1DCF TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 1DD0 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 1DD1 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 1DD2 ICR1H=0x00;
	OUT  0x27,R30
; 0000 1DD3 ICR1L=0x00;
	OUT  0x26,R30
; 0000 1DD4 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 1DD5 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 1DD6 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 1DD7 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 1DD8 OCR1CH=0x00;
	STS  121,R30
; 0000 1DD9 OCR1CL=0x00;
	STS  120,R30
; 0000 1DDA 
; 0000 1DDB // Timer/Counter 2 initialization
; 0000 1DDC // Clock source: System Clock
; 0000 1DDD // Clock value: Timer2 Stopped
; 0000 1DDE // Mode: Normal top=0xFF
; 0000 1DDF // OC2 output: Disconnected
; 0000 1DE0 TCCR2=0x00;
	OUT  0x25,R30
; 0000 1DE1 TCNT2=0x00;
	OUT  0x24,R30
; 0000 1DE2 OCR2=0x00;
	OUT  0x23,R30
; 0000 1DE3 
; 0000 1DE4 // Timer/Counter 3 initialization
; 0000 1DE5 // Clock source: System Clock
; 0000 1DE6 // Clock value: Timer3 Stopped
; 0000 1DE7 // Mode: Normal top=0xFFFF
; 0000 1DE8 // OC3A output: Discon.
; 0000 1DE9 // OC3B output: Discon.
; 0000 1DEA // OC3C output: Discon.
; 0000 1DEB // Noise Canceler: Off
; 0000 1DEC // Input Capture on Falling Edge
; 0000 1DED // Timer3 Overflow Interrupt: Off
; 0000 1DEE // Input Capture Interrupt: Off
; 0000 1DEF // Compare A Match Interrupt: Off
; 0000 1DF0 // Compare B Match Interrupt: Off
; 0000 1DF1 // Compare C Match Interrupt: Off
; 0000 1DF2 TCCR3A=0x00;
	STS  139,R30
; 0000 1DF3 TCCR3B=0x00;
	STS  138,R30
; 0000 1DF4 TCNT3H=0x00;
	STS  137,R30
; 0000 1DF5 TCNT3L=0x00;
	STS  136,R30
; 0000 1DF6 ICR3H=0x00;
	STS  129,R30
; 0000 1DF7 ICR3L=0x00;
	STS  128,R30
; 0000 1DF8 OCR3AH=0x00;
	STS  135,R30
; 0000 1DF9 OCR3AL=0x00;
	STS  134,R30
; 0000 1DFA OCR3BH=0x00;
	STS  133,R30
; 0000 1DFB OCR3BL=0x00;
	STS  132,R30
; 0000 1DFC OCR3CH=0x00;
	STS  131,R30
; 0000 1DFD OCR3CL=0x00;
	STS  130,R30
; 0000 1DFE 
; 0000 1DFF // External Interrupt(s) initialization
; 0000 1E00 // INT0: Off
; 0000 1E01 // INT1: Off
; 0000 1E02 // INT2: Off
; 0000 1E03 // INT3: Off
; 0000 1E04 // INT4: Off
; 0000 1E05 // INT5: Off
; 0000 1E06 // INT6: Off
; 0000 1E07 // INT7: Off
; 0000 1E08 EICRA=0x00;
	STS  106,R30
; 0000 1E09 EICRB=0x00;
	OUT  0x3A,R30
; 0000 1E0A EIMSK=0x00;
	OUT  0x39,R30
; 0000 1E0B 
; 0000 1E0C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 1E0D TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 1E0E 
; 0000 1E0F ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 1E10 
; 0000 1E11 
; 0000 1E12 // USART0 initialization
; 0000 1E13 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 1E14 // USART0 Receiver: On
; 0000 1E15 // USART0 Transmitter: On
; 0000 1E16 // USART0 Mode: Asynchronous
; 0000 1E17 // USART0 Baud Rate: 115200
; 0000 1E18 //UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
; 0000 1E19 //UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
; 0000 1E1A //UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
; 0000 1E1B //UBRR0H=0x00;
; 0000 1E1C //UBRR0L=0x08;
; 0000 1E1D 
; 0000 1E1E // USART0 initialization
; 0000 1E1F // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 1E20 // USART0 Receiver: On
; 0000 1E21 // USART0 Transmitter: On
; 0000 1E22 // USART0 Mode: Asynchronous
; 0000 1E23 // USART0 Baud Rate: 9600
; 0000 1E24 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 1E25 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 1E26 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 1E27 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 1E28 UBRR0L=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 1E29 
; 0000 1E2A 
; 0000 1E2B 
; 0000 1E2C 
; 0000 1E2D 
; 0000 1E2E // USART1 initialization
; 0000 1E2F // USART1 disabled
; 0000 1E30 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 1E31 
; 0000 1E32 // Analog Comparator initialization
; 0000 1E33 // Analog Comparator: Off
; 0000 1E34 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 1E35 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 1E36 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 1E37 
; 0000 1E38 // ADC initialization
; 0000 1E39 // ADC disabled
; 0000 1E3A ADCSRA=0x00;
	OUT  0x6,R30
; 0000 1E3B 
; 0000 1E3C // SPI initialization
; 0000 1E3D // SPI disabled
; 0000 1E3E SPCR=0x00;
	OUT  0xD,R30
; 0000 1E3F 
; 0000 1E40 // TWI initialization
; 0000 1E41 // TWI disabled
; 0000 1E42 TWCR=0x00;
	STS  116,R30
; 0000 1E43 
; 0000 1E44 //ciekawe, tej linijki brakowalo w medalach ,wyczailem w borgu
; 0000 1E45 // I2C Bus initialization
; 0000 1E46 i2c_init();
	CALL _i2c_init
; 0000 1E47 
; 0000 1E48 // Global enable interrupts
; 0000 1E49 #asm("sei")
	sei
; 0000 1E4A 
; 0000 1E4B delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x173
; 0000 1E4C delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x173
; 0000 1E4D delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x173
; 0000 1E4E delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x173
; 0000 1E4F 
; 0000 1E50 //jak patrze na maszyne to ten po lewej to 1
; 0000 1E51 
; 0000 1E52 putchar(90);  //5A
	CALL SUBOPT_0x3
; 0000 1E53 putchar(165); //A5
; 0000 1E54 putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _putchar
; 0000 1E55 putchar(128);  //80
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _putchar
; 0000 1E56 putchar(2);    //02
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
; 0000 1E57 putchar(16);   //10
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
; 0000 1E58 
; 0000 1E59 il_prob_odczytu = 1;    //100
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _il_prob_odczytu,R30
	STS  _il_prob_odczytu+1,R31
; 0000 1E5A start = 0;
	LDI  R30,LOW(0)
	STS  _start,R30
	STS  _start+1,R30
; 0000 1E5B rzad_obrabiany = 1;
	CALL SUBOPT_0x174
; 0000 1E5C jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 1E5D wykonalem_rzedow = 0;
	CALL SUBOPT_0x175
; 0000 1E5E cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x176
; 0000 1E5F guzik1_przelaczania_zaciskow = 1;
	SET
	BLD  R2,0
; 0000 1E60 guzik2_przelaczania_zaciskow = 1;
	BLD  R2,1
; 0000 1E61 //PORTE.6 = 1;  //aby byl dostep do zaciskow rzad 1
; 0000 1E62 zmienna_przelaczanie_zaciskow = 1;
	BLD  R2,2
; 0000 1E63 czas_przedmuchu = 183;
	LDI  R30,LOW(183)
	LDI  R31,HIGH(183)
	STS  _czas_przedmuchu,R30
	STS  _czas_przedmuchu+1,R31
; 0000 1E64 predkosc_pion_szczotka = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 1E65 predkosc_pion_krazek = 100;
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 1E66 wejscie_krazka_sciernego_w_pow_boczna_cylindra = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 1E67 predkosc_ruchow_po_okregu_krazek_scierny = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 1E68 czas_druciaka_na_gorze = 100;  //1 sekundy dla druciaka na gorze aby dolek zrobil git (kiedyS), zmieniam na 3s
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _czas_druciaka_na_gorze,R30
	STS  _czas_druciaka_na_gorze+1,R31
; 0000 1E69 czas_zatrzymania_na_dole = 120;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	STS  _czas_zatrzymania_na_dole,R30
	STS  _czas_zatrzymania_na_dole+1,R31
; 0000 1E6A srednica_wew_korpusu_cyklowa = 0;
	LDI  R30,LOW(0)
	STS  _srednica_wew_korpusu_cyklowa,R30
	STS  _srednica_wew_korpusu_cyklowa+1,R30
; 0000 1E6B 
; 0000 1E6C adr1 = 80;  //rzad 1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STS  _adr1,R30
	STS  _adr1+1,R31
; 0000 1E6D adr2 = 0;   //
	LDI  R30,LOW(0)
	STS  _adr2,R30
	STS  _adr2+1,R30
; 0000 1E6E adr3 = 64;  //rzad 2
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STS  _adr3,R30
	STS  _adr3+1,R31
; 0000 1E6F adr4 = 0;
	LDI  R30,LOW(0)
	STS  _adr4,R30
	STS  _adr4+1,R30
; 0000 1E70 
; 0000 1E71 //na sekunde
; 0000 1E72 //wartosci_wstepne_wgrac_tylko_raz(0);
; 0000 1E73 
; 0000 1E74 //while(1)
; 0000 1E75 //{
; 0000 1E76 //}
; 0000 1E77 
; 0000 1E78 wartosci_wstepne_panelu();
	CALL _wartosci_wstepne_panelu
; 0000 1E79 odpytaj_parametry_panelu();
	CALL _odpytaj_parametry_panelu
; 0000 1E7A 
; 0000 1E7B wypozycjonuj_napedy_minimalistyczna();
	CALL _wypozycjonuj_napedy_minimalistyczna
; 0000 1E7C sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 1E7D 
; 0000 1E7E //SPRAWDZAM CO SIE DZIEJE CO CYKL, TO LICZENIE SZCZOTKI I KRAZKA
; 0000 1E7F 
; 0000 1E80 while (1)
_0x464:
; 0000 1E81       {
; 0000 1E82         //to wylaczam tylko do testow w switniakch, wewnatrz tego wylaczam 4 pierwsze linijki
; 0000 1E83       odpytaj_parametry_panelu();
	CALL _odpytaj_parametry_panelu
; 0000 1E84       ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1E85       przerzucanie_dociskow();
	CALL _przerzucanie_dociskow
; 0000 1E86       kontrola_zoltego_swiatla();
	CALL _kontrola_zoltego_swiatla
; 0000 1E87       wymiana_szczotki_i_krazka();
	CALL _wymiana_szczotki_i_krazka
; 0000 1E88       zaktualizuj_parametry_panelu();
	CALL _zaktualizuj_parametry_panelu
; 0000 1E89 
; 0000 1E8A       test_geometryczny();
	CALL _test_geometryczny
; 0000 1E8B       sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 1E8C 
; 0000 1E8D       //zapis_probny_test();
; 0000 1E8E 
; 0000 1E8F 
; 0000 1E90 
; 0000 1E91       while((start == 1 & il_zaciskow_rzad_1 > 1 & il_zaciskow_rzad_2 != 1 & macierz_zaciskow[1]!=0  & (macierz_zaciskow[2]!=0 |  il_zaciskow_rzad_2 == 0)) | jestem_w_trakcie_czyszczenia_calosci == 1)
_0x467:
	CALL SUBOPT_0xD5
	CALL SUBOPT_0x85
	MOV  R0,R30
	CALL SUBOPT_0xE9
	CALL SUBOPT_0x105
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	AND  R0,R30
	CALL SUBOPT_0xEA
	MOV  R1,R30
	CALL SUBOPT_0x107
	MOV  R0,R30
	CALL SUBOPT_0x105
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	OR   R30,R0
	AND  R30,R1
	MOV  R0,R30
	LDS  R26,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R27,_jestem_w_trakcie_czyszczenia_calosci+1
	CALL SUBOPT_0x85
	OR   R30,R0
	BRNE PC+3
	JMP _0x469
; 0000 1E92             {
; 0000 1E93             switch (cykl_glowny)
	LDS  R30,_cykl_glowny
	LDS  R31,_cykl_glowny+1
; 0000 1E94             {
; 0000 1E95             case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x46D
; 0000 1E96 
; 0000 1E97 
; 0000 1E98                     PORTB.6 = 1;   ////zielona lampka
	SBI  0x18,6
; 0000 1E99                     if(jestem_w_trakcie_czyszczenia_calosci == 0)
	LDS  R30,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R31,_jestem_w_trakcie_czyszczenia_calosci+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x470
; 0000 1E9A                         {
; 0000 1E9B                         //PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1E9C 
; 0000 1E9D                         srednica_wew_korpusu_cyklowa = srednica_wew_korpusu;
	LDS  R30,_srednica_wew_korpusu
	LDS  R31,_srednica_wew_korpusu+1
	STS  _srednica_wew_korpusu_cyklowa,R30
	STS  _srednica_wew_korpusu_cyklowa+1,R31
; 0000 1E9E 
; 0000 1E9F                         wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad1
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA6
; 0000 1EA0                         wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad2
	CALL SUBOPT_0xA
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA6
; 0000 1EA1 
; 0000 1EA2                         il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
; 0000 1EA3                         il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
; 0000 1EA4 
; 0000 1EA5 
; 0000 1EA6                         szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64) - 1;  //wykonano zaciskow rzad1
	CALL SUBOPT_0x18
	SBIW R30,1
	MOVW R4,R30
; 0000 1EA7 
; 0000 1EA8                         tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1E
	MOVW R10,R30
; 0000 1EA9 
; 0000 1EAA                         if(tryb_pracy_szczotki_drucianej == 1)
	CALL SUBOPT_0x7E
	BRNE _0x471
; 0000 1EAB                             szczotka_druciana_ilosc_cykli = 1; //zmieniam bo teraz inny ruch szczotki drucianej, jeden schodek na dole
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 1EAC                         if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)
_0x471:
	CALL SUBOPT_0x81
	BREQ _0x472
; 0000 1EAD                             czas_druciaka_na_gorze = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _czas_druciaka_na_gorze,R30
	STS  _czas_druciaka_na_gorze+1,R31
; 0000 1EAE 
; 0000 1EAF                                                 //2090
; 0000 1EB0                         krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);  //wykonano zaciskow rzad1
_0x472:
	CALL SUBOPT_0x31
	CALL SUBOPT_0x21
	MOVW R6,R30
; 0000 1EB1                                                     //3000
; 0000 1EB2 
; 0000 1EB3                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xA
	CALL _odczytaj_parametr
	MOVW R8,R30
; 0000 1EB4 
; 0000 1EB5                         if(krazek_scierny_cykl_po_okregu_ilosc == 0)
	MOV  R0,R8
	OR   R0,R9
	BRNE _0x473
; 0000 1EB6                             {
; 0000 1EB7                             krazek_scierny_ilosc_cykli--;
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
; 0000 1EB8                             }
; 0000 1EB9 
; 0000 1EBA                         predkosc_pion_szczotka = odczytaj_parametr(32,80);
_0x473:
	CALL SUBOPT_0x31
	CALL SUBOPT_0x27
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 1EBB                                                 //2060
; 0000 1EBC                         predkosc_pion_krazek = odczytaj_parametr(32,96);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x24
	CALL _odczytaj_parametr
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 1EBD 
; 0000 1EBE                         wejscie_krazka_sciernego_w_pow_boczna_cylindra = odczytaj_parametr(48,16);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xB
	CALL _odczytaj_parametr
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 1EBF 
; 0000 1EC0                         predkosc_ruchow_po_okregu_krazek_scierny = odczytaj_parametr(32,112);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x1E
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 1EC1 
; 0000 1EC2                         srednica_krazka_sciernego = odczytaj_parametr(48,112);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x2B
; 0000 1EC3 
; 0000 1EC4                         ruch_haos = odczytaj_parametr(48,144);
	CALL SUBOPT_0x21
	STS  _ruch_haos,R30
	STS  _ruch_haos+1,R31
; 0000 1EC5 
; 0000 1EC6                         statystyka = odczytaj_parametr(128,64);
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x18
	STS  _statystyka,R30
	STS  _statystyka+1,R31
; 0000 1EC7 
; 0000 1EC8                         if(il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0)
	CALL SUBOPT_0x105
	CALL SUBOPT_0x177
	CALL SUBOPT_0x107
	AND  R30,R0
	BREQ _0x474
; 0000 1EC9                               il_zaciskow_rzad_2 = il_zaciskow_rzad_2;
	CALL SUBOPT_0x178
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
; 0000 1ECA                         else
	RJMP _0x475
_0x474:
; 0000 1ECB                               il_zaciskow_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R30
; 0000 1ECC 
; 0000 1ECD                         wybor_linijek_sterownikow(1);  //rzad 1
_0x475:
	CALL SUBOPT_0xC0
	CALL _wybor_linijek_sterownikow
; 0000 1ECE                         }
; 0000 1ECF 
; 0000 1ED0                     jestem_w_trakcie_czyszczenia_calosci = 1;
_0x470:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R31
; 0000 1ED1 
; 0000 1ED2                     if(rzad_obrabiany == 1)
	CALL SUBOPT_0x9D
	SBIW R26,1
	BRNE _0x476
; 0000 1ED3                     {
; 0000 1ED4                     PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
	CBI  0x3,6
; 0000 1ED5                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x479
; 0000 1ED6                         cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0x109
	CALL SUBOPT_0xF3
; 0000 1ED7                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x479:
	CALL SUBOPT_0xF4
	SBIW R26,5
	BRGE _0x47A
; 0000 1ED8                         cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xA
	CALL SUBOPT_0xF6
; 0000 1ED9                     }
_0x47A:
; 0000 1EDA 
; 0000 1EDB                     if(rzad_obrabiany == 2)
_0x476:
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x47B
; 0000 1EDC                     {
; 0000 1EDD                     ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1EDE                     //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2 - na razie nie bo nie ma jeszcze oslon
; 0000 1EDF 
; 0000 1EE0                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x47C
; 0000 1EE1                         cykl_sterownik_1 = sterownik_1_praca(0x008);
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF3
; 0000 1EE2                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x47C:
	CALL SUBOPT_0xF4
	SBIW R26,5
	BRGE _0x47D
; 0000 1EE3                         cykl_sterownik_2 = sterownik_2_praca(0x001);       //ster 2 pod pin pozy rzad 2
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xF6
; 0000 1EE4                     }
_0x47D:
; 0000 1EE5 
; 0000 1EE6 
; 0000 1EE7                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x47B:
	CALL SUBOPT_0xF7
	BREQ _0x47E
; 0000 1EE8                         {
; 0000 1EE9 
; 0000 1EEA                           if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x47F
; 0000 1EEB                             {
; 0000 1EEC                             while(PORTE.6 == 0)
_0x480:
	SBIC 0x3,6
	RJMP _0x482
; 0000 1EED                                 przerzucanie_dociskow();
	CALL _przerzucanie_dociskow
	RJMP _0x480
_0x482:
; 0000 1EEE delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 1EEF                             }
; 0000 1EF0 
; 0000 1EF1                         delay_ms(2000);  //aby zdazyl przelozyc
_0x47F:
	CALL SUBOPT_0x173
; 0000 1EF2                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 1EF3                         cykl_sterownik_2 = 0;
; 0000 1EF4                         cykl_sterownik_3 = 0;
; 0000 1EF5                         cykl_sterownik_4 = 0;
; 0000 1EF6                         cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x176
; 0000 1EF7                         koniec_rzedu_10 = 0;
	CALL SUBOPT_0x179
; 0000 1EF8                         cykl_glowny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x17A
; 0000 1EF9                         }
; 0000 1EFA 
; 0000 1EFB             break;
_0x47E:
	RJMP _0x46C
; 0000 1EFC 
; 0000 1EFD 
; 0000 1EFE 
; 0000 1EFF             case 1:
_0x46D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x483
; 0000 1F00 
; 0000 1F01 
; 0000 1F02                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 1)
	CALL SUBOPT_0x17B
	CALL SUBOPT_0x17C
	AND  R30,R0
	BREQ _0x484
; 0000 1F03                           {          //ster 1 nic
; 0000 1F04                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 1F05                           cykl_sterownik_2 = sterownik_2_praca(a[0]);        //ster 2 pod zacisk
	CALL SUBOPT_0xF9
	CALL SUBOPT_0xF6
; 0000 1F06                           }                                                    //ster 4 na pozycje miedzy rzedzami
; 0000 1F07 
; 0000 1F08                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 2)
_0x484:
	CALL SUBOPT_0x17B
	CALL SUBOPT_0x9F
	AND  R30,R0
	BREQ _0x487
; 0000 1F09                         {
; 0000 1F0A                         //cykl_sterownik_2 = sterownik_2_praca(0x5B,0);
; 0000 1F0B                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 1F0C                           ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F0D                           cykl_sterownik_2 = sterownik_2_praca(a[1]);
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xF6
; 0000 1F0E                          }
; 0000 1F0F                      if(cykl_sterownik_4 < 5 & cykl_sterownik_2 == 5)
_0x487:
	CALL SUBOPT_0x12F
	CALL __LTW12
	CALL SUBOPT_0x17D
	AND  R30,R0
	BREQ _0x48A
; 0000 1F10                        // cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);
; 0000 1F11                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 1F12 
; 0000 1F13                       if(cykl_sterownik_2 == 5 & cykl_sterownik_4 == 5)
_0x48A:
	CALL SUBOPT_0xF4
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x12F
	CALL __EQW12
	AND  R30,R0
	BREQ _0x48B
; 0000 1F14                         {
; 0000 1F15                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1F16                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x17E
; 0000 1F17                         cykl_sterownik_4 = 0;
; 0000 1F18                         szczotka_druc_cykl = 0;
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
; 0000 1F19                         cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x17A
; 0000 1F1A                         }
; 0000 1F1B 
; 0000 1F1C 
; 0000 1F1D             break;
_0x48B:
	RJMP _0x46C
; 0000 1F1E 
; 0000 1F1F 
; 0000 1F20             case 2:
_0x483:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x48C
; 0000 1F21                     if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x48D
; 0000 1F22                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F23 
; 0000 1F24                     if(cykl_sterownik_4 < 5)
_0x48D:
	CALL SUBOPT_0xEE
	SBIW R26,5
	BRGE _0x48E
; 0000 1F25                           cykl_sterownik_4 = sterownik_4_praca(a[2],1);
	CALL SUBOPT_0x82
	CALL SUBOPT_0x159
	CALL SUBOPT_0xEF
; 0000 1F26                     if(cykl_sterownik_4 == 5)
_0x48E:
	CALL SUBOPT_0xEE
	SBIW R26,5
	BRNE _0x48F
; 0000 1F27                         {
; 0000 1F28                         PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1F29                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1F2A 
; 0000 1F2B                         //if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
; 0000 1F2C                         //     cykl_sterownik_4 = 5;
; 0000 1F2D 
; 0000 1F2E                         sek13 = 0;
	CALL SUBOPT_0x17F
; 0000 1F2F                         cykl_glowny = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x17A
; 0000 1F30                         }
; 0000 1F31             break;
_0x48F:
	RJMP _0x46C
; 0000 1F32 
; 0000 1F33 
; 0000 1F34             case 3:
_0x48C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x492
; 0000 1F35 
; 0000 1F36                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x493
; 0000 1F37                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F38 
; 0000 1F39                     if(cykl_sterownik_4 < 5 & sek13 > czas_druciaka_na_gorze & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x493:
	CALL SUBOPT_0x12F
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
	CALL SUBOPT_0x180
	BREQ _0x494
; 0000 1F3A                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x133
	CALL SUBOPT_0xEF
; 0000 1F3B 
; 0000 1F3C                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x494:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x134
	CALL __LTW12
	AND  R30,R0
	BREQ _0x495
; 0000 1F3D                         {
; 0000 1F3E                         szczotka_druc_cykl++;
	CALL SUBOPT_0x15A
; 0000 1F3F                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1F40 
; 0000 1F41                         if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
	MOVW R26,R10
	CALL SUBOPT_0xD4
	CALL SUBOPT_0x181
	MOVW R30,R4
	CALL SUBOPT_0x158
	CALL __EQW12
	AND  R30,R0
	BREQ _0x496
; 0000 1F42                             cykl_sterownik_4 = 5;
	CALL SUBOPT_0x11D
; 0000 1F43 
; 0000 1F44 
; 0000 1F45 
; 0000 1F46                         if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x496:
	MOVW R26,R10
	CALL SUBOPT_0xD4
	CALL SUBOPT_0x181
	CALL SUBOPT_0x180
	BREQ _0x497
; 0000 1F47                                {
; 0000 1F48                                cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x17A
; 0000 1F49                                if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x157
	BRNE _0x498
; 0000 1F4A                                    PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1F4B                                }
_0x498:
; 0000 1F4C                         }
_0x497:
; 0000 1F4D 
; 0000 1F4E                     if(cykl_sterownik_4 < 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & tryb_pracy_szczotki_drucianej == 1)
_0x495:
	CALL SUBOPT_0x12F
	CALL __LTW12
	MOV  R0,R30
	MOVW R30,R4
	CALL SUBOPT_0x158
	CALL __EQW12
	AND  R0,R30
	MOVW R26,R10
	CALL SUBOPT_0x85
	AND  R30,R0
	BREQ _0x49B
; 0000 1F4F                          cykl_sterownik_4 = sterownik_4_praca(0x03,0); //INV
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x133
	CALL SUBOPT_0xEF
; 0000 1F50 
; 0000 1F51 
; 0000 1F52 
; 0000 1F53                         if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
_0x49B:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x134
	CALL __EQW12
	AND  R30,R0
	BREQ _0x49C
; 0000 1F54                             {
; 0000 1F55                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1F56                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1F57                             cykl_glowny = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x17A
; 0000 1F58                             }
; 0000 1F59 
; 0000 1F5A             break;
_0x49C:
	RJMP _0x46C
; 0000 1F5B 
; 0000 1F5C             case 4:
_0x492:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x49F
; 0000 1F5D 
; 0000 1F5E 
; 0000 1F5F                       if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x4A0
; 0000 1F60                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F61 
; 0000 1F62                      if(cykl_sterownik_4 < 5)
_0x4A0:
	CALL SUBOPT_0xEE
	SBIW R26,5
	BRGE _0x4A1
; 0000 1F63                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 1F64 
; 0000 1F65                      if(cykl_sterownik_4 == 5)
_0x4A1:
	CALL SUBOPT_0xEE
	SBIW R26,5
	BRNE _0x4A2
; 0000 1F66                         {
; 0000 1F67                         PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1F68                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 1F69                         ruch_zlozony = 0;
	LDI  R30,LOW(0)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R30
; 0000 1F6A                         cykl_glowny = 5;
	CALL SUBOPT_0x182
; 0000 1F6B                         }
; 0000 1F6C 
; 0000 1F6D             break;
_0x4A2:
	RJMP _0x46C
; 0000 1F6E 
; 0000 1F6F             case 5:
_0x49F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4A5
; 0000 1F70 
; 0000 1F71 
; 0000 1F72                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 1)
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x183
	CALL SUBOPT_0x17C
	AND  R30,R0
	BREQ _0x4A6
; 0000 1F73                         cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0xA
	CALL SUBOPT_0xF3
; 0000 1F74                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 2)
_0x4A6:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x183
	CALL SUBOPT_0x9F
	AND  R30,R0
	BREQ _0x4A7
; 0000 1F75                         cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xF3
; 0000 1F76 
; 0000 1F77                      if(rzad_obrabiany == 2)
_0x4A7:
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x4A8
; 0000 1F78                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1F79 
; 0000 1F7A                     if(cykl_sterownik_1 == 5 & ruch_zlozony == 0)
_0x4A8:
	CALL SUBOPT_0x11E
	CALL __EQW12
	CALL SUBOPT_0x184
	CALL SUBOPT_0xCE
	BREQ _0x4A9
; 0000 1F7B                         {
; 0000 1F7C                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1F7D                         ruch_zlozony = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 1F7E                         }
; 0000 1F7F 
; 0000 1F80                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 1)
_0x4A9:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x185
	CALL SUBOPT_0x85
	AND  R0,R30
	CALL SUBOPT_0x17C
	AND  R30,R0
	BREQ _0x4AA
; 0000 1F81                         cykl_sterownik_1 = sterownik_1_praca(a[0]);
	CALL SUBOPT_0xF9
	CALL SUBOPT_0xF3
; 0000 1F82                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 2)
_0x4AA:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x185
	CALL SUBOPT_0x85
	AND  R0,R30
	CALL SUBOPT_0x9F
	AND  R30,R0
	BREQ _0x4AB
; 0000 1F83                           cykl_sterownik_1 = sterownik_1_praca(a[1]);
	CALL SUBOPT_0x10A
	CALL SUBOPT_0xF3
; 0000 1F84 
; 0000 1F85 
; 0000 1F86                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 2)
_0x4AB:
	CALL SUBOPT_0x11E
	CALL SUBOPT_0x185
	CALL SUBOPT_0xD4
	AND  R30,R0
	BREQ _0x4AC
; 0000 1F87                         cykl_sterownik_1 = sterownik_1_praca(0x003);     ////////////////////////////////////////////////////////////
	CALL SUBOPT_0x104
; 0000 1F88 
; 0000 1F89                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 0)                                //ster 1 do pierwszego dolka
_0x4AC:
	CALL SUBOPT_0x17B
	CALL SUBOPT_0x16E
	BREQ _0x4AD
; 0000 1F8A                         cykl_sterownik_2 = sterownik_2_praca(0x003);       //ster 2 pod nastpeny dolek
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x186
; 0000 1F8B 
; 0000 1F8C 
; 0000 1F8D                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 1)
_0x4AD:
	CALL SUBOPT_0x17B
	CALL SUBOPT_0x187
	AND  R0,R30
	CALL SUBOPT_0x17C
	AND  R30,R0
	BREQ _0x4AE
; 0000 1F8E                         cykl_sterownik_2 = sterownik_2_praca(0x008);      //ster 2 do samego tylu
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xF6
; 0000 1F8F                      if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 2)
_0x4AE:
	CALL SUBOPT_0x17B
	CALL SUBOPT_0x187
	AND  R0,R30
	CALL SUBOPT_0x9F
	AND  R30,R0
	BREQ _0x4AF
; 0000 1F90                         cykl_sterownik_2 = sterownik_2_praca(0x009);      //ster 2 do samego tylu
	CALL SUBOPT_0x109
	CALL SUBOPT_0xF6
; 0000 1F91 
; 0000 1F92                     if((cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5 & ruch_zlozony == 1) | (cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5) & ruch_zlozony == 2)
_0x4AF:
	CALL SUBOPT_0x11E
	CALL __EQW12
	CALL SUBOPT_0x17D
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0x85
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0x11E
	CALL __EQW12
	CALL SUBOPT_0x17D
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0xD4
	AND  R30,R0
	OR   R30,R1
	BREQ _0x4B0
; 0000 1F93                         {
; 0000 1F94                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1F95                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x17E
; 0000 1F96                         cykl_sterownik_4 = 0;
; 0000 1F97                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1F98                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
	SBI  0x3,3
; 0000 1F99                         cykl_glowny = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x17A
; 0000 1F9A                         }
; 0000 1F9B 
; 0000 1F9C             break;
_0x4B0:
	RJMP _0x46C
; 0000 1F9D 
; 0000 1F9E             case 6:
_0x4A5:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4B3
; 0000 1F9F 
; 0000 1FA0                     if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xEC
	SBIW R26,5
	BRGE _0x4B4
; 0000 1FA1                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs //krazek scierny do gory
	CALL SUBOPT_0x7B
	CALL SUBOPT_0xFA
; 0000 1FA2 
; 0000 1FA3                     if(koniec_rzedu_10 == 1)
_0x4B4:
	CALL SUBOPT_0x11C
	BRNE _0x4B5
; 0000 1FA4                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x11D
; 0000 1FA5 
; 0000 1FA6                     if(cykl_sterownik_4 < 5)
_0x4B5:
	CALL SUBOPT_0xEE
	SBIW R26,5
	BRGE _0x4B6
; 0000 1FA7                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);    //ABS          //druciak do gory
	CALL SUBOPT_0x82
	CALL SUBOPT_0x159
	CALL SUBOPT_0xEF
; 0000 1FA8 
; 0000 1FA9                      if(rzad_obrabiany == 2)
_0x4B6:
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x4B7
; 0000 1FAA                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1FAB 
; 0000 1FAC 
; 0000 1FAD                     if(cykl_sterownik_4 == 5 & cykl_sterownik_3 == 5)
_0x4B7:
	CALL SUBOPT_0x12F
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x13B
	CALL __EQW12
	AND  R30,R0
	BREQ _0x4B8
; 0000 1FAE                         {
; 0000 1FAF                         if((cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1 & rzad_obrabiany == 1) | (cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1 & rzad_obrabiany == 2))
	CALL SUBOPT_0x188
	MOV  R0,R30
	CALL SUBOPT_0x17C
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0x189
	MOV  R0,R30
	CALL SUBOPT_0x9F
	AND  R30,R0
	OR   R30,R1
	BREQ _0x4B9
; 0000 1FB0                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1FB1 
; 0000 1FB2                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
_0x4B9:
	SBI  0x3,3
; 0000 1FB3                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xF1
; 0000 1FB4                         cykl_sterownik_4 = 0;
; 0000 1FB5                         if(cykl_ilosc_zaciskow > 0)
	CALL SUBOPT_0x18A
	CALL __CPW02
	BRGE _0x4BE
; 0000 1FB6                                 {
; 0000 1FB7                                 sek12 = 0;    //do przedmuchu
	CALL SUBOPT_0x18B
; 0000 1FB8                                 PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x18C
; 0000 1FB9                                 PORTF = PORT_F.byte;
; 0000 1FBA                                 }
; 0000 1FBB                         sek13 = 0;
_0x4BE:
	CALL SUBOPT_0x17F
; 0000 1FBC                         cykl_glowny = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x17A
; 0000 1FBD                         }
; 0000 1FBE 
; 0000 1FBF            break;
_0x4B8:
	RJMP _0x46C
; 0000 1FC0 
; 0000 1FC1 
; 0000 1FC2            case 7:
_0x4B3:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4BF
; 0000 1FC3 
; 0000 1FC4 
; 0000 1FC5                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x4C0
; 0000 1FC6                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1FC7 
; 0000 1FC8                         wykonalem_komplet_okregow = 0;
_0x4C0:
	CALL SUBOPT_0x16C
; 0000 1FC9                         szczotka_druc_cykl = 0;
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
; 0000 1FCA                         krazek_scierny_cykl_po_okregu = 0;
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
; 0000 1FCB                         krazek_scierny_cykl = 0;
	STS  _krazek_scierny_cykl,R30
	STS  _krazek_scierny_cykl+1,R30
; 0000 1FCC                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x14A
; 0000 1FCD                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x14F
; 0000 1FCE 
; 0000 1FCF                         abs_ster3 = 0;
	CALL SUBOPT_0x143
; 0000 1FD0                         abs_ster4 = 0;
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
; 0000 1FD1                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 1FD2                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x17E
; 0000 1FD3                         cykl_sterownik_4 = 0;
; 0000 1FD4                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 1FD5 
; 0000 1FD6                              if(krazek_scierny_cykl_po_okregu_ilosc > 0)
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BRGE _0x4C1
; 0000 1FD7                                 {
; 0000 1FD8                                 if(ruch_haos == 0 & tryb_pracy_szczotki_drucianej == 1)  //spr.
	CALL SUBOPT_0x84
	CALL SUBOPT_0x83
	MOVW R26,R10
	CALL SUBOPT_0x85
	AND  R30,R0
	BREQ _0x4C2
; 0000 1FD9                                     cykl_glowny = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x17A
; 0000 1FDA 
; 0000 1FDB                                 if(ruch_haos == 0 & (tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3))//spr.
_0x4C2:
	CALL SUBOPT_0x84
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	MOV  R1,R30
	CALL SUBOPT_0x81
	AND  R30,R1
	BREQ _0x4C3
; 0000 1FDC                                     cykl_glowny = 88;
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	CALL SUBOPT_0x17A
; 0000 1FDD 
; 0000 1FDE                                 if(ruch_haos == 1 & tryb_pracy_szczotki_drucianej == 1) //spr.
_0x4C3:
	CALL SUBOPT_0x84
	CALL SUBOPT_0x85
	MOV  R0,R30
	MOVW R26,R10
	CALL SUBOPT_0x85
	AND  R30,R0
	BREQ _0x4C4
; 0000 1FDF                                     cykl_glowny = 887;
	LDI  R30,LOW(887)
	LDI  R31,HIGH(887)
	CALL SUBOPT_0x17A
; 0000 1FE0 
; 0000 1FE1                                 if(ruch_haos == 1 & (tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3))// spr.
_0x4C4:
	CALL SUBOPT_0x84
	CALL SUBOPT_0x85
	MOV  R1,R30
	CALL SUBOPT_0x81
	AND  R30,R1
	BREQ _0x4C5
; 0000 1FE2                                     cykl_glowny = 888;
	LDI  R30,LOW(888)
	LDI  R31,HIGH(888)
	CALL SUBOPT_0x17A
; 0000 1FE3                                 }
_0x4C5:
; 0000 1FE4                              else
	RJMP _0x4C6
_0x4C1:
; 0000 1FE5                                 {
; 0000 1FE6                                 if(tryb_pracy_szczotki_drucianej == 1)  //spr
	CALL SUBOPT_0x7E
	BRNE _0x4C7
; 0000 1FE7                                     cykl_glowny = 997;
	LDI  R30,LOW(997)
	LDI  R31,HIGH(997)
	CALL SUBOPT_0x17A
; 0000 1FE8                                 if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)  //spr
_0x4C7:
	CALL SUBOPT_0x81
	BREQ _0x4C8
; 0000 1FE9                                     cykl_glowny = 998;
	LDI  R30,LOW(998)
	LDI  R31,HIGH(998)
	CALL SUBOPT_0x17A
; 0000 1FEA 
; 0000 1FEB                                 }
_0x4C8:
_0x4C6:
; 0000 1FEC 
; 0000 1FED            break;
	RJMP _0x46C
; 0000 1FEE 
; 0000 1FEF 
; 0000 1FF0            case 887:
_0x4BF:
	CPI  R30,LOW(0x377)
	LDI  R26,HIGH(0x377)
	CPC  R31,R26
	BRNE _0x4C9
; 0000 1FF1                     przypadek887();
	CALL _przypadek887
; 0000 1FF2            break;
	RJMP _0x46C
; 0000 1FF3 
; 0000 1FF4             case 888:
_0x4C9:
	CPI  R30,LOW(0x378)
	LDI  R26,HIGH(0x378)
	CPC  R31,R26
	BRNE _0x4CA
; 0000 1FF5                    przypadek888();
	CALL _przypadek888
; 0000 1FF6            break;
	RJMP _0x46C
; 0000 1FF7 
; 0000 1FF8            case 997:
_0x4CA:
	CPI  R30,LOW(0x3E5)
	LDI  R26,HIGH(0x3E5)
	CPC  R31,R26
	BRNE _0x4CB
; 0000 1FF9                    przypadek997();
	CALL _przypadek997
; 0000 1FFA            break;
	RJMP _0x46C
; 0000 1FFB 
; 0000 1FFC            case 998:
_0x4CB:
	CPI  R30,LOW(0x3E6)
	LDI  R26,HIGH(0x3E6)
	CPC  R31,R26
	BRNE _0x4CC
; 0000 1FFD                     przypadek998();
	CALL _przypadek998
; 0000 1FFE            break;
	RJMP _0x46C
; 0000 1FFF 
; 0000 2000             case 8:
_0x4CC:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x4CD
; 0000 2001                     przypadek8();
	RCALL _przypadek8
; 0000 2002             break;
	RJMP _0x46C
; 0000 2003 
; 0000 2004             case 88:
_0x4CD:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x4CE
; 0000 2005                     przypadek88();
	RCALL _przypadek88
; 0000 2006             break;
	RJMP _0x46C
; 0000 2007 
; 0000 2008 
; 0000 2009 
; 0000 200A             case 9:                                          //cykl 3 == 5
_0x4CE:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4CF
; 0000 200B 
; 0000 200C                          if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x11A
	BRGE _0x4D0
; 0000 200D                         {
; 0000 200E                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0x11B
; 0000 200F                         PORTF = PORT_F.byte;
; 0000 2010                         }
; 0000 2011 
; 0000 2012 
; 0000 2013 
; 0000 2014                          if(rzad_obrabiany == 1)
_0x4D0:
	CALL SUBOPT_0x9D
	SBIW R26,1
	BRNE _0x4D1
; 0000 2015                          {
; 0000 2016                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)    //////
	CALL SUBOPT_0x13B
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x188
	AND  R30,R0
	BREQ _0x4D2
; 0000 2017                               cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xED
; 0000 2018 
; 0000 2019 
; 0000 201A                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_1 - 2)
_0x4D2:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x18D
	CALL SUBOPT_0x18E
	BREQ _0x4D3
; 0000 201B                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 201C 
; 0000 201D 
; 0000 201E                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)       //2 marca 2019 wykomentowuje ////////
_0x4D3:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x18D
	CALL SUBOPT_0x18F
	BREQ _0x4D4
; 0000 201F                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xED
; 0000 2020 
; 0000 2021 
; 0000 2022                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_1 - 2)
_0x4D4:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x18D
	CALL SUBOPT_0x190
	BREQ _0x4D5
; 0000 2023                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 2024 
; 0000 2025                           }
_0x4D5:
; 0000 2026 
; 0000 2027 
; 0000 2028                          if(rzad_obrabiany == 2)
_0x4D1:
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x4D6
; 0000 2029                          {
; 0000 202A                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
	CALL SUBOPT_0x13B
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x189
	AND  R30,R0
	BREQ _0x4D7
; 0000 202B                             cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xED
; 0000 202C 
; 0000 202D                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_2 - 2)
_0x4D7:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x191
	CALL SUBOPT_0x18E
	BREQ _0x4D8
; 0000 202E                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 202F 
; 0000 2030                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x4D8:
	CALL SUBOPT_0x13B
	CALL SUBOPT_0x191
	CALL SUBOPT_0x18F
	BREQ _0x4D9
; 0000 2031                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xED
; 0000 2032 
; 0000 2033                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_2 - 2)
_0x4D9:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x191
	CALL SUBOPT_0x190
	BREQ _0x4DA
; 0000 2034                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xEF
; 0000 2035 
; 0000 2036                            if(rzad_obrabiany == 2)
_0x4DA:
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x4DB
; 0000 2037                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 2038 
; 0000 2039                           }
_0x4DB:
; 0000 203A 
; 0000 203B 
; 0000 203C                           if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 & sek12 > czas_przedmuchu)
_0x4D6:
	CALL SUBOPT_0x13B
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x12F
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
	BREQ _0x4DC
; 0000 203D                             {
; 0000 203E                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 203F                             PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 2040                             //PORTB.6 = 0;  //wylacz przedmuchy
; 0000 2041                             PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0x11B
; 0000 2042                             PORTF = PORT_F.byte;
; 0000 2043                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x137
; 0000 2044                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0x140
; 0000 2045                             cykl_ilosc_zaciskow++;
	LDI  R26,LOW(_cykl_ilosc_zaciskow)
	LDI  R27,HIGH(_cykl_ilosc_zaciskow)
	CALL SUBOPT_0x192
; 0000 2046                             ruch_zlozony = 2;                       //il_zaciskow_rzad_1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 2047                             cykl_glowny = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x17A
; 0000 2048                             }
; 0000 2049 
; 0000 204A 
; 0000 204B             break;
_0x4DC:
	RJMP _0x46C
; 0000 204C 
; 0000 204D 
; 0000 204E 
; 0000 204F             case 10:
_0x4CF:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4E1
; 0000 2050 
; 0000 2051                                                //wywali ten warunek jak zadziala
; 0000 2052                      if(rzad_obrabiany == 1 & cykl_glowny != 0)
	CALL SUBOPT_0x17C
	CALL SUBOPT_0x193
	BRNE PC+3
	JMP _0x4E2
; 0000 2053                             {
; 0000 2054                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,96);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x15D
	CALL SUBOPT_0x133
	CALL SUBOPT_0x24
	CALL _wartosc_parametru_panelu
; 0000 2055                             if(srednica_wew_korpusu_cyklowa == 38 | srednica_wew_korpusu_cyklowa == 41 | srednica_wew_korpusu_cyklowa == 43)
	CALL SUBOPT_0xAC
	MOV  R0,R30
	CALL SUBOPT_0xAD
	CALL SUBOPT_0xAE
	BREQ _0x4E3
; 0000 2056                             {
; 0000 2057                             czas_pracy_szczotki_drucianej_h_17++;
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h_17)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h_17)
	CALL SUBOPT_0x192
; 0000 2058                             if(czas_pracy_szczotki_drucianej_h_17 > 250)
	CALL SUBOPT_0x10B
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x4E4
; 0000 2059                                 czas_pracy_szczotki_drucianej_h_17 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x22
; 0000 205A                             }
_0x4E4:
; 0000 205B 
; 0000 205C                             if(srednica_wew_korpusu_cyklowa == 34 | srednica_wew_korpusu_cyklowa == 36)
_0x4E3:
	CALL SUBOPT_0xB1
	MOV  R0,R30
	CALL SUBOPT_0xB2
	BREQ _0x4E5
; 0000 205D                             {
; 0000 205E                             czas_pracy_szczotki_drucianej_h_15++;
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h_15)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h_15)
	CALL SUBOPT_0x192
; 0000 205F                             if(czas_pracy_szczotki_drucianej_h_15 > 250)
	CALL SUBOPT_0x10E
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x4E6
; 0000 2060                                 czas_pracy_szczotki_drucianej_h_15 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x23
; 0000 2061                             }
_0x4E6:
; 0000 2062 
; 0000 2063 
; 0000 2064 
; 0000 2065 
; 0000 2066 
; 0000 2067                             if(srednica_wew_korpusu_cyklowa == 34)
_0x4E5:
	CALL SUBOPT_0xAB
	SBIW R26,34
	BRNE _0x4E7
; 0000 2068                                 {
; 0000 2069                                 czas_pracy_krazka_sciernego_h_34++;
	CALL SUBOPT_0x194
; 0000 206A                                 if(czas_pracy_krazka_sciernego_h_34 > 250)
	CALL SUBOPT_0x10F
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x4E8
; 0000 206B                                     czas_pracy_krazka_sciernego_h_34 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x25
; 0000 206C                                 }
_0x4E8:
; 0000 206D 
; 0000 206E 
; 0000 206F                             if(srednica_wew_korpusu_cyklowa == 36)
_0x4E7:
	CALL SUBOPT_0xAB
	SBIW R26,36
	BRNE _0x4E9
; 0000 2070                                 {
; 0000 2071                                 czas_pracy_krazka_sciernego_h_36++;
	CALL SUBOPT_0x195
; 0000 2072                                 if(czas_pracy_krazka_sciernego_h_36 > 250)
	CALL SUBOPT_0x112
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x4EA
; 0000 2073                                     czas_pracy_krazka_sciernego_h_36 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x26
; 0000 2074                                 }
_0x4EA:
; 0000 2075                             if(srednica_wew_korpusu_cyklowa == 38)
_0x4E9:
	CALL SUBOPT_0xAB
	SBIW R26,38
	BRNE _0x4EB
; 0000 2076                                 {
; 0000 2077                                 czas_pracy_krazka_sciernego_h_38++;
	CALL SUBOPT_0x196
; 0000 2078                                 if(czas_pracy_krazka_sciernego_h_38 > 250)
	CALL SUBOPT_0x113
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x4EC
; 0000 2079                                     czas_pracy_krazka_sciernego_h_38 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x28
; 0000 207A                                 }
_0x4EC:
; 0000 207B                             if(srednica_wew_korpusu_cyklowa == 41)
_0x4EB:
	CALL SUBOPT_0xAB
	SBIW R26,41
	BRNE _0x4ED
; 0000 207C                                 {
; 0000 207D                                 czas_pracy_krazka_sciernego_h_41++;
	CALL SUBOPT_0x197
; 0000 207E                                 if(czas_pracy_krazka_sciernego_h_41 > 250)
	CALL SUBOPT_0x114
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x4EE
; 0000 207F                                     czas_pracy_krazka_sciernego_h_41 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x29
; 0000 2080                                 }
_0x4EE:
; 0000 2081                             if(srednica_wew_korpusu_cyklowa == 43)
_0x4ED:
	CALL SUBOPT_0xAB
	SBIW R26,43
	BRNE _0x4EF
; 0000 2082                                 {
; 0000 2083                                 czas_pracy_krazka_sciernego_h_43++;
	CALL SUBOPT_0x198
; 0000 2084                                 if(czas_pracy_krazka_sciernego_h_43 > 250)
	CALL SUBOPT_0x115
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x4F0
; 0000 2085                                     czas_pracy_krazka_sciernego_h_43 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x2A
; 0000 2086                                 }
_0x4F0:
; 0000 2087 
; 0000 2088                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_1 - 1)
_0x4EF:
	CALL SUBOPT_0x199
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x4F1
; 0000 2089                                 {
; 0000 208A                                 cykl_glowny = 5;
	CALL SUBOPT_0x182
; 0000 208B                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0x179
; 0000 208C                                 }
; 0000 208D 
; 0000 208E                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
_0x4F1:
	CALL SUBOPT_0x199
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x4F2
; 0000 208F                                 {
; 0000 2090                                 cykl_glowny = 5;
	CALL SUBOPT_0x182
; 0000 2091                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x19A
; 0000 2092                                 }
; 0000 2093 
; 0000 2094                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 == 10)
_0x4F2:
	CALL SUBOPT_0x19B
	CALL __EQW12
	AND  R30,R0
	BREQ _0x4F3
; 0000 2095                                 {
; 0000 2096                                 cykl_glowny = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x17A
; 0000 2097                                 }
; 0000 2098 
; 0000 2099                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 != 10)  /////zmieniam + 1 20.02
_0x4F3:
	CALL SUBOPT_0x19B
	CALL __NEW12
	AND  R30,R0
	BREQ _0x4F4
; 0000 209A                                 {
; 0000 209B                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x17A
; 0000 209C                                 }
; 0000 209D                             }
_0x4F4:
; 0000 209E 
; 0000 209F 
; 0000 20A0                              if(rzad_obrabiany == 2)
_0x4E2:
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x4F5
; 0000 20A1                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 20A2 
; 0000 20A3                             if(rzad_obrabiany == 2 & cykl_glowny != 0)
_0x4F5:
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x193
	BRNE PC+3
	JMP _0x4F6
; 0000 20A4                             {
; 0000 20A5                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,16);  //wykonano zaciskow rzad2
	CALL SUBOPT_0x15D
	CALL SUBOPT_0x133
	CALL SUBOPT_0xB
	CALL _wartosc_parametru_panelu
; 0000 20A6 
; 0000 20A7                             if(srednica_wew_korpusu_cyklowa == 38 | srednica_wew_korpusu_cyklowa == 41 | srednica_wew_korpusu_cyklowa == 43)
	CALL SUBOPT_0xAC
	MOV  R0,R30
	CALL SUBOPT_0xAD
	CALL SUBOPT_0xAE
	BREQ _0x4F7
; 0000 20A8                             {
; 0000 20A9                             czas_pracy_szczotki_drucianej_h_17++;
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h_17)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h_17)
	CALL SUBOPT_0x192
; 0000 20AA                             if(czas_pracy_szczotki_drucianej_h_17 > 250)
	CALL SUBOPT_0x10B
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x4F8
; 0000 20AB                                 czas_pracy_szczotki_drucianej_h_17 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x22
; 0000 20AC                             }
_0x4F8:
; 0000 20AD 
; 0000 20AE                             if(srednica_wew_korpusu_cyklowa == 34 | srednica_wew_korpusu_cyklowa == 36)
_0x4F7:
	CALL SUBOPT_0xB1
	MOV  R0,R30
	CALL SUBOPT_0xB2
	BREQ _0x4F9
; 0000 20AF                             {
; 0000 20B0                             czas_pracy_szczotki_drucianej_h_15++;
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h_15)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h_15)
	CALL SUBOPT_0x192
; 0000 20B1                             if(czas_pracy_szczotki_drucianej_h_15 > 250)
	CALL SUBOPT_0x10E
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x4FA
; 0000 20B2                                 czas_pracy_szczotki_drucianej_h_15 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x23
; 0000 20B3                             }
_0x4FA:
; 0000 20B4 
; 0000 20B5 
; 0000 20B6                             if(srednica_wew_korpusu_cyklowa == 34)
_0x4F9:
	CALL SUBOPT_0xAB
	SBIW R26,34
	BRNE _0x4FB
; 0000 20B7                                 {
; 0000 20B8                                 czas_pracy_krazka_sciernego_h_34++;
	CALL SUBOPT_0x194
; 0000 20B9                                 if(czas_pracy_krazka_sciernego_h_34 > 250)
	CALL SUBOPT_0x10F
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x4FC
; 0000 20BA                                     czas_pracy_krazka_sciernego_h_34 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x25
; 0000 20BB                                 }
_0x4FC:
; 0000 20BC 
; 0000 20BD 
; 0000 20BE                             if(srednica_wew_korpusu_cyklowa == 36)
_0x4FB:
	CALL SUBOPT_0xAB
	SBIW R26,36
	BRNE _0x4FD
; 0000 20BF                                 {
; 0000 20C0                                 czas_pracy_krazka_sciernego_h_36++;
	CALL SUBOPT_0x195
; 0000 20C1                                 if(czas_pracy_krazka_sciernego_h_36 > 250)
	CALL SUBOPT_0x112
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x4FE
; 0000 20C2                                     czas_pracy_krazka_sciernego_h_36 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x26
; 0000 20C3                                 }
_0x4FE:
; 0000 20C4                             if(srednica_wew_korpusu_cyklowa == 38)
_0x4FD:
	CALL SUBOPT_0xAB
	SBIW R26,38
	BRNE _0x4FF
; 0000 20C5                                 {
; 0000 20C6                                 czas_pracy_krazka_sciernego_h_38++;
	CALL SUBOPT_0x196
; 0000 20C7                                 if(czas_pracy_krazka_sciernego_h_38 > 250)
	CALL SUBOPT_0x113
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x500
; 0000 20C8                                     czas_pracy_krazka_sciernego_h_38 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x28
; 0000 20C9                                 }
_0x500:
; 0000 20CA                             if(srednica_wew_korpusu_cyklowa == 41)
_0x4FF:
	CALL SUBOPT_0xAB
	SBIW R26,41
	BRNE _0x501
; 0000 20CB                                 {
; 0000 20CC                                 czas_pracy_krazka_sciernego_h_41++;
	CALL SUBOPT_0x197
; 0000 20CD                                 if(czas_pracy_krazka_sciernego_h_41 > 250)
	CALL SUBOPT_0x114
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x502
; 0000 20CE                                     czas_pracy_krazka_sciernego_h_41 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x29
; 0000 20CF                                 }
_0x502:
; 0000 20D0                             if(srednica_wew_korpusu_cyklowa == 43)
_0x501:
	CALL SUBOPT_0xAB
	SBIW R26,43
	BRNE _0x503
; 0000 20D1                                 {
; 0000 20D2                                 czas_pracy_krazka_sciernego_h_43++;
	CALL SUBOPT_0x198
; 0000 20D3                                 if(czas_pracy_krazka_sciernego_h_43 > 250)
	CALL SUBOPT_0x115
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x504
; 0000 20D4                                     czas_pracy_krazka_sciernego_h_43 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x2A
; 0000 20D5                                 }
_0x504:
; 0000 20D6 
; 0000 20D7 
; 0000 20D8                             if(srednica_wew_korpusu_cyklowa == 34)
_0x503:
	CALL SUBOPT_0xAB
	SBIW R26,34
	BRNE _0x505
; 0000 20D9                                 czas_pracy_krazka_sciernego_h_34++;
	CALL SUBOPT_0x194
; 0000 20DA                             if(srednica_wew_korpusu_cyklowa == 36)
_0x505:
	CALL SUBOPT_0xAB
	SBIW R26,36
	BRNE _0x506
; 0000 20DB                                 czas_pracy_krazka_sciernego_h_36++;
	CALL SUBOPT_0x195
; 0000 20DC                             if(srednica_wew_korpusu_cyklowa == 38)
_0x506:
	CALL SUBOPT_0xAB
	SBIW R26,38
	BRNE _0x507
; 0000 20DD                                 czas_pracy_krazka_sciernego_h_38++;
	CALL SUBOPT_0x196
; 0000 20DE                             if(srednica_wew_korpusu_cyklowa == 41)
_0x507:
	CALL SUBOPT_0xAB
	SBIW R26,41
	BRNE _0x508
; 0000 20DF                                 czas_pracy_krazka_sciernego_h_41++;
	CALL SUBOPT_0x197
; 0000 20E0                             if(srednica_wew_korpusu_cyklowa == 43)
_0x508:
	CALL SUBOPT_0xAB
	SBIW R26,43
	BRNE _0x509
; 0000 20E1                                 czas_pracy_krazka_sciernego_h_43++;
	CALL SUBOPT_0x198
; 0000 20E2 
; 0000 20E3 
; 0000 20E4                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_2 - 1)
_0x509:
	CALL SUBOPT_0x178
	SBIW R30,1
	CALL SUBOPT_0x18A
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x50A
; 0000 20E5                                 {
; 0000 20E6                                 cykl_glowny = 5;
	CALL SUBOPT_0x182
; 0000 20E7                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0x179
; 0000 20E8                                 }
; 0000 20E9 
; 0000 20EA                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x50A:
	CALL SUBOPT_0x178
	SBIW R30,1
	CALL SUBOPT_0x18A
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x50B
; 0000 20EB                                 {
; 0000 20EC                                 cykl_glowny = 5;
	CALL SUBOPT_0x182
; 0000 20ED                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x19A
; 0000 20EE                                 }
; 0000 20EF 
; 0000 20F0                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 == 10)
_0x50B:
	CALL SUBOPT_0x19C
	CALL __EQW12
	AND  R30,R0
	BREQ _0x50C
; 0000 20F1                                 {
; 0000 20F2                                 cykl_glowny = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x17A
; 0000 20F3                                 }
; 0000 20F4 
; 0000 20F5 
; 0000 20F6                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 != 10)   ///////////////////zmieniam + 1 20.02
_0x50C:
	CALL SUBOPT_0x19C
	CALL __NEW12
	AND  R30,R0
	BREQ _0x50D
; 0000 20F7                                 {
; 0000 20F8                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x17A
; 0000 20F9                                 }
; 0000 20FA                             }
_0x50D:
; 0000 20FB 
; 0000 20FC 
; 0000 20FD 
; 0000 20FE             break;
_0x4F6:
	RJMP _0x46C
; 0000 20FF 
; 0000 2100             case 11:
_0x4E1:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x50E
; 0000 2101 
; 0000 2102                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x50F
; 0000 2103                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 2104 
; 0000 2105                              //ster 1 ucieka od szafy
; 0000 2106                              if(cykl_sterownik_1 < 5)
_0x50F:
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x510
; 0000 2107                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x121
; 0000 2108 
; 0000 2109                              if(cykl_sterownik_2 < 5)
_0x510:
	CALL SUBOPT_0xF4
	SBIW R26,5
	BRGE _0x511
; 0000 210A                                     cykl_sterownik_2 = sterownik_2_praca(0x190);     //pod dolek ostatni 10 do przedmuchu rzad 1
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0x186
; 0000 210B 
; 0000 210C                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x511:
	CALL SUBOPT_0xF7
	BREQ _0x512
; 0000 210D                                     {
; 0000 210E                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x18C
; 0000 210F                                     PORTF = PORT_F.byte;
; 0000 2110                                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 2111                                     sek12 = 0;
	CALL SUBOPT_0x18B
; 0000 2112                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 2113                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x19D
; 0000 2114                                     cykl_glowny = 13;
; 0000 2115                                     }
; 0000 2116             break;
_0x512:
	RJMP _0x46C
; 0000 2117 
; 0000 2118 
; 0000 2119             case 12:
_0x50E:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x515
; 0000 211A 
; 0000 211B                              if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x516
; 0000 211C                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 211D 
; 0000 211E                                //ster 1 ucieka od szafy
; 0000 211F                              if(cykl_sterownik_1 < 5)
_0x516:
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x517
; 0000 2120                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x121
; 0000 2121 
; 0000 2122                             if(cykl_sterownik_2 < 5)
_0x517:
	CALL SUBOPT_0xF4
	SBIW R26,5
	BRGE _0x518
; 0000 2123                                     cykl_sterownik_2 = sterownik_2_praca(0x191);     //pod dolek ostatni 10 do przedmuchu rzad 2
	LDI  R30,LOW(401)
	LDI  R31,HIGH(401)
	CALL SUBOPT_0x186
; 0000 2124 
; 0000 2125                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x518:
	CALL SUBOPT_0xF7
	BREQ _0x519
; 0000 2126                                     {
; 0000 2127                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x18C
; 0000 2128                                     PORTF = PORT_F.byte;
; 0000 2129                                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 212A                                     sek12 = 0;
	CALL SUBOPT_0x18B
; 0000 212B                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 212C                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x19D
; 0000 212D                                     cykl_glowny = 13;
; 0000 212E                                     }
; 0000 212F 
; 0000 2130 
; 0000 2131             break;
_0x519:
	RJMP _0x46C
; 0000 2132 
; 0000 2133             case 13:
_0x515:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x51C
; 0000 2134 
; 0000 2135 
; 0000 2136                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x51D
; 0000 2137                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 2138 
; 0000 2139                               if(sek12 > czas_przedmuchu)
_0x51D:
	CALL SUBOPT_0x11A
	BRGE _0x51E
; 0000 213A                                         {
; 0000 213B                                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0x11B
; 0000 213C                                         PORTF = PORT_F.byte;
; 0000 213D                                         PORTE.5 = 0;
	CBI  0x3,5
; 0000 213E                                         }
; 0000 213F 
; 0000 2140 
; 0000 2141                              if(cykl_sterownik_2 < 5)
_0x51E:
	CALL SUBOPT_0xF4
	SBIW R26,5
	BRGE _0x521
; 0000 2142                                     cykl_sterownik_2 = sterownik_2_praca(0x192);     //okrag
	LDI  R30,LOW(402)
	LDI  R31,HIGH(402)
	CALL SUBOPT_0x186
; 0000 2143                              if(cykl_sterownik_2 == 5)
_0x521:
	CALL SUBOPT_0xF4
	SBIW R26,5
	BRNE _0x522
; 0000 2144                                     {
; 0000 2145 
; 0000 2146                                      if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x11A
	BRGE _0x523
; 0000 2147                                         {
; 0000 2148                                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0x11B
; 0000 2149                                         PORTF = PORT_F.byte;
; 0000 214A                                         PORTE.5 = 0;
	CBI  0x3,5
; 0000 214B                                         cykl_sterownik_2 = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
; 0000 214C                                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x17A
; 0000 214D                                         }
; 0000 214E                                     }
_0x523:
; 0000 214F 
; 0000 2150             break;
_0x522:
	RJMP _0x46C
; 0000 2151 
; 0000 2152 
; 0000 2153 
; 0000 2154             case 14:
_0x51C:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x526
; 0000 2155 
; 0000 2156 
; 0000 2157                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x527
; 0000 2158                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 2159 
; 0000 215A                     if(cykl_sterownik_1 < 5)
_0x527:
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x528
; 0000 215B                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek zeby przedmuchac
	CALL SUBOPT_0x104
; 0000 215C                     if(cykl_sterownik_1 == 5)
_0x528:
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRNE _0x529
; 0000 215D                         {
; 0000 215E                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x123
; 0000 215F                         sek12 = 0;
	CALL SUBOPT_0x18B
; 0000 2160                         cykl_glowny = 15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x17A
; 0000 2161                         }
; 0000 2162 
; 0000 2163             break;
_0x529:
	RJMP _0x46C
; 0000 2164 
; 0000 2165 
; 0000 2166 
; 0000 2167             case 15:
_0x526:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x52A
; 0000 2168 
; 0000 2169                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9D
	SBIW R26,2
	BRNE _0x52B
; 0000 216A                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 216B 
; 0000 216C                     //przedmuch
; 0000 216D                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
_0x52B:
	CALL SUBOPT_0x18C
; 0000 216E                     PORTF = PORT_F.byte;
; 0000 216F 
; 0000 2170                     if(start == 1)
	CALL SUBOPT_0xD5
	SBIW R26,1
	BRNE _0x52C
; 0000 2171                         {
; 0000 2172                         obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xD7
; 0000 2173                         obsluga_nacisniecia_zatrzymaj();
; 0000 2174                         }
; 0000 2175 
; 0000 2176 
; 0000 2177                     if(sek12 > czas_przedmuchu)
_0x52C:
	CALL SUBOPT_0x11A
	BRGE _0x52D
; 0000 2178                         {
; 0000 2179                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x11B
; 0000 217A                         PORTF = PORT_F.byte;
; 0000 217B                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x17A
; 0000 217C                         }
; 0000 217D             break;
_0x52D:
	RJMP _0x46C
; 0000 217E 
; 0000 217F 
; 0000 2180             case 16:
_0x52A:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x52E
; 0000 2181 
; 0000 2182                      if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & wykonalem_rzedow == 0)  /////zmieniam + 1 20.02
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	CALL SUBOPT_0x18A
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x19E
	CALL SUBOPT_0xCE
	BREQ _0x52F
; 0000 2183                                 {
; 0000 2184                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x176
; 0000 2185                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 2186                                 if(il_zaciskow_rzad_2 > 0)
	CALL SUBOPT_0x105
	CALL __CPW02
	BRGE _0x532
; 0000 2187                                     {
; 0000 2188 
; 0000 2189                                     rzad_obrabiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
; 0000 218A                                     wybor_linijek_sterownikow(2);  //rzad 2
	CALL SUBOPT_0x108
	CALL _wybor_linijek_sterownikow
; 0000 218B                                     cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 218C                                     }
; 0000 218D                                 else
	RJMP _0x533
_0x532:
; 0000 218E                                     cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x17A
; 0000 218F 
; 0000 2190                                 wykonalem_rzedow = 1;
_0x533:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 2191                                 }
; 0000 2192 
; 0000 2193                        if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 1)   ///////////////////zmieniam + 1 20.02
_0x52F:
	CALL SUBOPT_0x178
	CALL SUBOPT_0x18A
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x105
	CALL SUBOPT_0x106
	CALL SUBOPT_0x19E
	CALL SUBOPT_0x85
	AND  R30,R0
	BREQ _0x534
; 0000 2194                                 {
; 0000 2195                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 2196                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x176
; 0000 2197                                 cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x17A
; 0000 2198                                 rzad_obrabiany = 1;
	CALL SUBOPT_0x174
; 0000 2199                                 wykonalem_rzedow = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 219A                                 }
; 0000 219B 
; 0000 219C 
; 0000 219D                         if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 2)
_0x534:
	CALL SUBOPT_0x19F
	CALL SUBOPT_0x105
	CALL SUBOPT_0x106
	CALL SUBOPT_0x19E
	CALL SUBOPT_0xD4
	AND  R30,R0
	BREQ _0x537
; 0000 219E                                   {
; 0000 219F                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x174
; 0000 21A0                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0x175
; 0000 21A1                                   PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 21A2                                   //PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1 - tego na razie nie poki nie ma oslon
; 0000 21A3                                   //PORTB.6 = 0;   ////zielona lampka
; 0000 21A4                                   //wartosc_parametru_panelu(0,0,64);
; 0000 21A5                                   }
; 0000 21A6 
; 0000 21A7                             if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 == 0 & wykonalem_rzedow == 1)
_0x537:
	CALL SUBOPT_0x19F
	CALL SUBOPT_0x105
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x19E
	CALL SUBOPT_0x85
	AND  R30,R0
	BREQ _0x53A
; 0000 21A8                                   {
; 0000 21A9                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x174
; 0000 21AA                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0x175
; 0000 21AB                                   //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
; 0000 21AC                                   }
; 0000 21AD 
; 0000 21AE 
; 0000 21AF 
; 0000 21B0             break;
_0x53A:
	RJMP _0x46C
; 0000 21B1 
; 0000 21B2 
; 0000 21B3             case 17:
_0x52E:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x46C
; 0000 21B4 
; 0000 21B5 
; 0000 21B6                                  if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xF2
	SBIW R26,5
	BRGE _0x53C
; 0000 21B7                                     cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0x109
	CALL SUBOPT_0xF3
; 0000 21B8                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x53C:
	CALL SUBOPT_0xF4
	SBIW R26,5
	BRGE _0x53D
; 0000 21B9                                     cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xA
	CALL SUBOPT_0xF6
; 0000 21BA 
; 0000 21BB                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x53D:
	CALL SUBOPT_0xF7
	BRNE PC+3
	JMP _0x53E
; 0000 21BC                                         {
; 0000 21BD                                         PORTB.6 = 0;   ////zielona lampka
	CBI  0x18,6
; 0000 21BE                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xF8
; 0000 21BF                                         cykl_sterownik_2 = 0;
; 0000 21C0                                         cykl_sterownik_3 = 0;
; 0000 21C1                                         cykl_sterownik_4 = 0;
; 0000 21C2                                         jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 21C3                                         PORTB.6 = 0;
	CBI  0x18,6
; 0000 21C4 
; 0000 21C5                                         if(odczytalem_w_trakcie_czyszczenia_drugiego_rzedu == 0)
	LDS  R30,_odczytalem_w_trakcie_czyszczenia_drugiego_rzedu
	LDS  R31,_odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1
	SBIW R30,0
	BRNE _0x543
; 0000 21C6                                         {
; 0000 21C7                                         macierz_zaciskow[1]=0;
	__POINTW1MN _macierz_zaciskow,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 21C8                                         macierz_zaciskow[2]=0;
	__POINTW1MN _macierz_zaciskow,4
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 21C9 
; 0000 21CA                                         komunikat_na_panel("-------",0,80);  //rzad 1
	__POINTW1FN _0x0,2295
	CALL SUBOPT_0x133
	CALL SUBOPT_0xBA
	CALL _komunikat_na_panel
; 0000 21CB                                         komunikat_na_panel("-------",0,32);  //rzad 2
	__POINTW1FN _0x0,2295
	CALL SUBOPT_0x133
	CALL SUBOPT_0x31
	CALL _komunikat_na_panel
; 0000 21CC 
; 0000 21CD                                         komunikat_na_panel("                                                ",128,144);
	CALL SUBOPT_0x13
; 0000 21CE                                         komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",128,144);
	__POINTW1FN _0x0,2303
	CALL SUBOPT_0x14
; 0000 21CF                                         komunikat_na_panel("                                                ",144,80);
	CALL SUBOPT_0xE
; 0000 21D0                                         komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",144,80);
	__POINTW1FN _0x0,2303
	CALL SUBOPT_0xF
; 0000 21D1                                         }
; 0000 21D2 
; 0000 21D3                                         odczytalem_w_trakcie_czyszczenia_drugiego_rzedu = 0;
_0x543:
	LDI  R30,LOW(0)
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu,R30
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1,R30
; 0000 21D4 
; 0000 21D5 
; 0000 21D6                                         //to ponizej dotyczy zapisu do pamieci stalej cykli szczotki i krazka
; 0000 21D7 
; 0000 21D8                                         tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1E
	MOVW R10,R30
; 0000 21D9                                         szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1D
; 0000 21DA                                         krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
; 0000 21DB                                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
	CALL SUBOPT_0xA
	CALL _odczytaj_parametr
	MOVW R8,R30
; 0000 21DC                                         czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
; 0000 21DD                                         czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
	CALL SUBOPT_0x20
; 0000 21DE 
; 0000 21DF                                         wartosci_wstepne_wgrac_tylko_raz(1); //to trwa 3s
	CALL SUBOPT_0xC0
	CALL _wartosci_wstepne_wgrac_tylko_raz
; 0000 21E0                                         srednica_wew_korpusu_cyklowa = 0;
	LDI  R30,LOW(0)
	STS  _srednica_wew_korpusu_cyklowa,R30
	STS  _srednica_wew_korpusu_cyklowa+1,R30
; 0000 21E1                                         wartosc_parametru_panelu(0,0,64);
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xCC
; 0000 21E2                                         start = 0;
; 0000 21E3                                         cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 21E4                                         }
; 0000 21E5 
; 0000 21E6 
; 0000 21E7 
; 0000 21E8 
; 0000 21E9             break;
_0x53E:
; 0000 21EA 
; 0000 21EB 
; 0000 21EC 
; 0000 21ED             }//switch
_0x46C:
; 0000 21EE 
; 0000 21EF 
; 0000 21F0   }//while
	RJMP _0x467
_0x469:
; 0000 21F1 
; 0000 21F2 
; 0000 21F3 
; 0000 21F4 }//while glowny
	RJMP _0x464
; 0000 21F5 
; 0000 21F6 
; 0000 21F7 
; 0000 21F8 
; 0000 21F9 }//koniec
_0x544:
	RJMP _0x544
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
	CALL SUBOPT_0x192
	ADIW R28,3
	RET
__print_G103:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x3F
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
	CALL SUBOPT_0x1A0
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x1A0
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
	CALL SUBOPT_0x1A1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1A2
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x1A1
	CALL SUBOPT_0x1A3
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x1A1
	CALL SUBOPT_0x1A3
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
	CALL SUBOPT_0x1A1
	CALL SUBOPT_0x1A4
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
	CALL SUBOPT_0x1A1
	CALL SUBOPT_0x1A4
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
	CALL SUBOPT_0x1A0
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
	CALL SUBOPT_0x1A0
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
	CALL SUBOPT_0x1A2
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x1A0
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
	CALL SUBOPT_0x1A2
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
	CALL SUBOPT_0x34
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
_czas_pracy_szczotki_drucianej_h_17:
	.BYTE 0x2
_czas_pracy_szczotki_drucianej_h_15:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(90)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(165)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LD   R30,Y
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 255 TIMES, CODE SIZE REDUCTION:505 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 50 TIMES, CODE SIZE REDUCTION:95 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xD:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	LDI  R26,LOW(_macierz_zaciskow)
	LDI  R27,HIGH(_macierz_zaciskow)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xE:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xF:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x11:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x13:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x14:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 44 TIMES, CODE SIZE REDUCTION:255 WORDS
SUBOPT_0x15:
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
SUBOPT_0x16:
	CALL _sprawdz_pin0
	LDI  R26,LOW(0)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x17:
	CALL _sprawdz_pin1
	LDI  R26,LOW(0)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	STS  _il_zaciskow_rzad_1,R30
	STS  _il_zaciskow_rzad_1+1,R31
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 49 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	CALL _odczytaj_parametr
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
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
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	MOVW R12,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	CALL _odczytaj_parametr
	STS  _czas_pracy_krazka_sciernego_stala,R30
	STS  _czas_pracy_krazka_sciernego_stala+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	STS  _czas_pracy_szczotki_drucianej_h_17,R30
	STS  _czas_pracy_szczotki_drucianej_h_17+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	STS  _czas_pracy_szczotki_drucianej_h_15,R30
	STS  _czas_pracy_szczotki_drucianej_h_15+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 66 TIMES, CODE SIZE REDUCTION:127 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	STS  _czas_pracy_krazka_sciernego_h_34,R30
	STS  _czas_pracy_krazka_sciernego_h_34+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	STS  _czas_pracy_krazka_sciernego_h_36,R30
	STS  _czas_pracy_krazka_sciernego_h_36+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	STS  _czas_pracy_krazka_sciernego_h_38,R30
	STS  _czas_pracy_krazka_sciernego_h_38+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	STS  _czas_pracy_krazka_sciernego_h_41,R30
	STS  _czas_pracy_krazka_sciernego_h_41+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	STS  _czas_pracy_krazka_sciernego_h_43,R30
	STS  _czas_pracy_krazka_sciernego_h_43+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	STS  _srednica_krazka_sciernego,R30
	STS  _srednica_krazka_sciernego+1,R31
	RJMP SUBOPT_0x1B

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:429 WORDS
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
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:333 WORDS
SUBOPT_0x2E:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr1
	LDS  R31,_adr1+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr2
	LDS  R31,_adr2+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 152 TIMES, CODE SIZE REDUCTION:752 WORDS
SUBOPT_0x32:
	MOVW R30,R16
	LDI  R26,LOW(_macierz_zaciskow)
	LDI  R27,HIGH(_macierz_zaciskow)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 145 TIMES, CODE SIZE REDUCTION:285 WORDS
SUBOPT_0x34:
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 69 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_z_czytnika_kodow

;OPTIMIZER ADDED SUBROUTINE, CALLED 68 TIMES, CODE SIZE REDUCTION:265 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x37:
	CALL _komunikat_z_czytnika_kodow
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x38:
	CALL _komunikat_z_czytnika_kodow
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x39:
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x3A:
	CALL _komunikat_z_czytnika_kodow
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x3B:
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x3C:
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3D:
	CALL _komunikat_z_czytnika_kodow
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3E:
	ST   X+,R30
	ST   X,R31
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x40:
	CALL _komunikat_z_czytnika_kodow
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x42:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 136 TIMES, CODE SIZE REDUCTION:537 WORDS
SUBOPT_0x43:
	STS  _a,R30
	STS  _a+1,R31
	__POINTW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 104 TIMES, CODE SIZE REDUCTION:409 WORDS
SUBOPT_0x44:
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x45:
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
SUBOPT_0x46:
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x47:
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
SUBOPT_0x48:
	__POINTW1MN _a,18
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x49:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x4A:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x4B:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x4C:
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x4D:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4E:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x50:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x51:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x4A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x52:
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
SUBOPT_0x53:
	LDI  R26,LOW(29)
	LDI  R27,HIGH(29)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x4A

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x55:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x56:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x4D

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x57:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x58:
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
SUBOPT_0x59:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RJMP SUBOPT_0x55

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5A:
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
SUBOPT_0x5B:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5C:
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	RJMP SUBOPT_0x4A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5D:
	__POINTW1MN _a,8
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x4D

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5E:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x4A

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:186 WORDS
SUBOPT_0x5F:
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
	RJMP SUBOPT_0x4C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x60:
	LDI  R26,LOW(27)
	LDI  R27,HIGH(27)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x61:
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
SUBOPT_0x62:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x4D

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x63:
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x64:
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x65:
	LDI  R26,LOW(22)
	LDI  R27,HIGH(22)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x66:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x4D

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x67:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x68:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x69:
	LDI  R26,LOW(20)
	LDI  R27,HIGH(20)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x6A:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6B:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	LDI  R26,LOW(36)
	LDI  R27,HIGH(36)
	RJMP SUBOPT_0x6A

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x6C:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6D:
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	RJMP SUBOPT_0x6A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6E:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6F:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP SUBOPT_0x6A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x70:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	RJMP SUBOPT_0x6A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x71:
	__POINTW1MN _a,8
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x72:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x6F

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x73:
	__POINTW1MN _a,8
	LDI  R26,LOW(23)
	LDI  R27,HIGH(23)
	RJMP SUBOPT_0x6A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x74:
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x75:
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x76:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x77:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	RJMP SUBOPT_0x6A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x78:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x6D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x79:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7A:
	LDS  R30,_a
	LDS  R31,_a+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7B:
	__GETW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x7C:
	__GETW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x7D:
	ADIW R30,1
	__PUTW1MN _a,12
	__GETW1MN _a,12
	ADIW R30,1
	__PUTW1MN _a,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7F:
	__GETW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x80:
	__PUTW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x81:
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
SUBOPT_0x82:
	__GETW1MN _a,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x83:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x84:
	LDS  R26,_ruch_haos
	LDS  R27,_ruch_haos+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 94 TIMES, CODE SIZE REDUCTION:183 WORDS
SUBOPT_0x85:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x86:
	__GETW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x87:
	LDS  R26,_srednica_krazka_sciernego
	LDS  R27,_srednica_krazka_sciernego+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x88:
	LDS  R26,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R27,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x89:
	MOV  R0,R30
	RCALL SUBOPT_0x87
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8A:
	RCALL SUBOPT_0x88
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x8B:
	__PUTW1MN _a,10
	RJMP SUBOPT_0x7C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8C:
	RCALL SUBOPT_0x88
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8D:
	RCALL SUBOPT_0x88
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x8E:
	MOV  R0,R30
	RCALL SUBOPT_0x87
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8F:
	__CPD2N 0x3D
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x90:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	SBI  0x12,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x91:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _byla_wloczona_szlifierka_1,R30
	STS  _byla_wloczona_szlifierka_1+1,R31
	CBI  0x3,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x92:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _byla_wloczona_szlifierka_2,R30
	STS  _byla_wloczona_szlifierka_2+1,R31
	CBI  0x3,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x93:
	LDS  R30,_PORT_F
	ANDI R30,LOW(0x10)
	CPI  R30,LOW(0x10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x94:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:317 WORDS
SUBOPT_0x95:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:221 WORDS
SUBOPT_0x96:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x97:
	CBI  0x12,7
	LDS  R26,_byla_wloczona_szlifierka_1
	LDS  R27,_byla_wloczona_szlifierka_1+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x98:
	SBI  0x3,2
	LDI  R30,LOW(0)
	STS  _byla_wloczona_szlifierka_1,R30
	STS  _byla_wloczona_szlifierka_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x99:
	LDS  R26,_byla_wloczona_szlifierka_2
	LDS  R27,_byla_wloczona_szlifierka_2+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9A:
	SBI  0x3,3
	LDI  R30,LOW(0)
	STS  _byla_wloczona_szlifierka_2,R30
	STS  _byla_wloczona_szlifierka_2+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9B:
	LDS  R26,_byl_wloczony_przedmuch
	LDS  R27,_byl_wloczony_przedmuch+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x9C:
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
SUBOPT_0x9D:
	LDS  R26,_rzad_obrabiany
	LDS  R27,_rzad_obrabiany+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9E:
	MOV  R0,R30
	LDS  R26,_start
	LDS  R27,_start+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x9F:
	RCALL SUBOPT_0x9D
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA0:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:59 WORDS
SUBOPT_0xA1:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:135 WORDS
SUBOPT_0xA2:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xA3:
	CALL _wartosc_parametru_panelu_stala_pamiec
	RJMP SUBOPT_0xA2

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:141 WORDS
SUBOPT_0xA4:
	CALL _odczyt_parametru_panelu_stala_pamiec
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0xA5:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xA6:
	CALL _wartosc_parametru_panelu
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0xA7:
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA8:
	LDS  R30,_czas_pracy_krazka_sciernego_stala
	LDS  R31,_czas_pracy_krazka_sciernego_stala+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA9:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAA:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP SUBOPT_0xA9

;OPTIMIZER ADDED SUBROUTINE, CALLED 42 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0xAB:
	LDS  R26,_srednica_wew_korpusu_cyklowa
	LDS  R27,_srednica_wew_korpusu_cyklowa+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xAC:
	RCALL SUBOPT_0xAB
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xAD:
	RCALL SUBOPT_0xAB
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xAE:
	OR   R0,R30
	RCALL SUBOPT_0xAB
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	CALL __EQW12
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xAF:
	LDS  R30,_czas_pracy_szczotki_drucianej_h_17
	LDS  R31,_czas_pracy_szczotki_drucianej_h_17+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB0:
	RCALL SUBOPT_0xAB
	RJMP SUBOPT_0x83

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB1:
	RCALL SUBOPT_0xAB
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xB2:
	RCALL SUBOPT_0xAB
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL __EQW12
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB3:
	LDS  R30,_czas_pracy_szczotki_drucianej_h_15
	LDS  R31,_czas_pracy_szczotki_drucianej_h_15+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0xB4:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB5:
	CALL _wartosc_parametru_panelu
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xB6:
	CALL _wartosc_parametru_panelu_stala_pamiec
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB7:
	LDS  R30,_czas_pracy_krazka_sciernego_h_34
	LDS  R31,_czas_pracy_krazka_sciernego_h_34+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB8:
	LDS  R30,_czas_pracy_krazka_sciernego_h_36
	LDS  R31,_czas_pracy_krazka_sciernego_h_36+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB9:
	LDS  R30,_czas_pracy_krazka_sciernego_h_38
	LDS  R31,_czas_pracy_krazka_sciernego_h_38+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xBA:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBB:
	LDS  R30,_czas_pracy_krazka_sciernego_h_41
	LDS  R31,_czas_pracy_krazka_sciernego_h_41+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBC:
	LDS  R30,_czas_pracy_krazka_sciernego_h_43
	LDS  R31,_czas_pracy_krazka_sciernego_h_43+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xBD:
	CALL _odczyt_parametru_panelu_stala_pamiec
	RJMP SUBOPT_0xA2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xBE:
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBF:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0xC0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC1:
	CALL _sprawdz_pin0
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC2:
	CALL _sprawdz_pin1
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xC3:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xC4:
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
SUBOPT_0xC5:
	CALL _sprawdz_pin3
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC6:
	CALL _sprawdz_pin7
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC7:
	SBI  0x12,7
	CBI  0x18,6
	CBI  0x18,4
	CBI  0x12,2
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC8:
	__POINTW1FN _0x0,1531
	RJMP SUBOPT_0x96

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC9:
	CALL _sprawdz_pin6
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0xCA:
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
SUBOPT_0xCB:
	CALL _sprawdz_pin5
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xCC:
	CALL _wartosc_parametru_panelu
	LDI  R30,LOW(0)
	STS  _start,R30
	STS  _start+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCD:
	AND  R30,R26
	MOV  R0,R30
	LDS  R26,_czekaj_az_puszcze
	LDS  R27,_czekaj_az_puszcze+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 59 TIMES, CODE SIZE REDUCTION:171 WORDS
SUBOPT_0xCE:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xCF:
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
SUBOPT_0xD0:
	LDI  R30,LOW(0)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD1:
	LDI  R30,LOW(0)
	STS  _sek11,R30
	STS  _sek11+1,R30
	STS  _sek11+2,R30
	STS  _sek11+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD2:
	LDS  R30,_il_prob_odczytu
	LDS  R31,_il_prob_odczytu+1
	LDS  R26,_odczytalem_zacisk
	LDS  R27,_odczytalem_zacisk+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD3:
	LDI  R26,LOW(_odczytalem_zacisk)
	LDI  R27,HIGH(_odczytalem_zacisk)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xD4:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xD5:
	LDS  R26,_start
	LDS  R27,_start+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xD6:
	SBI  0x12,7
	CBI  0x3,2
	CBI  0x3,3
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD7:
	CALL _obsluga_otwarcia_klapy_rzad
	JMP  _obsluga_nacisniecia_zatrzymaj

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xD8:
	LDI  R30,LOW(0)
	STS  _sek1,R30
	STS  _sek1+1,R30
	STS  _sek1+2,R30
	STS  _sek1+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xD9:
	__CPD2N 0x2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0xDA:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xDB:
	LDI  R30,LOW(0)
	STS  _sek3,R30
	STS  _sek3+1,R30
	STS  _sek3+2,R30
	STS  _sek3+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0xDC:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xDD:
	OR   R30,R0
	STS  _PORT_F,R30
	LDS  R30,_PORT_STER3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0xDE:
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xDF:
	LDI  R30,LOW(0)
	STS  _sek2,R30
	STS  _sek2+1,R30
	STS  _sek2+2,R30
	STS  _sek2+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0xE0:
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE1:
	STS  _PORT_F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xE2:
	LDI  R30,LOW(0)
	STS  _sek4,R30
	STS  _sek4+1,R30
	STS  _sek4+2,R30
	STS  _sek4+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 50 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0xE3:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xE4:
	MOVW R26,R28
	ADIW R26,6
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE5:
	LDS  R26,_test_geometryczny_rzad_1
	LDS  R27,_test_geometryczny_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE6:
	LDS  R26,_test_geometryczny_rzad_2
	LDS  R27,_test_geometryczny_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:90 WORDS
SUBOPT_0xE7:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xE8:
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
SUBOPT_0xE9:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __GTW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xEA:
	__GETW1MN _macierz_zaciskow,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xEB:
	CALL _wybor_linijek_sterownikow
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
SUBOPT_0xEC:
	LDS  R26,_cykl_sterownik_3
	LDS  R27,_cykl_sterownik_3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0xED:
	CALL _sterownik_3_praca
	RJMP SUBOPT_0xE0

;OPTIMIZER ADDED SUBROUTINE, CALLED 75 TIMES, CODE SIZE REDUCTION:145 WORDS
SUBOPT_0xEE:
	LDS  R26,_cykl_sterownik_4
	LDS  R27,_cykl_sterownik_4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0xEF:
	CALL _sterownik_4_praca
	RJMP SUBOPT_0xE3

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0xF0:
	RCALL SUBOPT_0xEC
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0xEE
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:253 WORDS
SUBOPT_0xF1:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 59 TIMES, CODE SIZE REDUCTION:113 WORDS
SUBOPT_0xF2:
	LDS  R26,_cykl_sterownik_1
	LDS  R27,_cykl_sterownik_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0xF3:
	CALL _sterownik_1_praca
	RJMP SUBOPT_0xDA

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xF4:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF5:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xF6:
	CALL _sterownik_2_praca
	RJMP SUBOPT_0xDC

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0xF7:
	RCALL SUBOPT_0xF2
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0xF4
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:227 WORDS
SUBOPT_0xF8:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	RJMP SUBOPT_0xF1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF9:
	RCALL SUBOPT_0x7A
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xFA:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xED

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0xFB:
	__GETWRN 16,17,6
	MOVW R30,R18
	RJMP SUBOPT_0xE4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xFC:
	MOVW R26,R18
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xFD:
	MOVW R26,R18
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xFE:
	MOVW R26,R18
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xFF:
	MOVW R26,R18
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x100:
	MOVW R26,R18
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x101:
	MOVW R26,R18
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x102:
	MOVW R26,R18
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x103:
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x104:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xF3

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x105:
	LDS  R26,_il_zaciskow_rzad_2
	LDS  R27,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x106:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x107:
	__GETW1MN _macierz_zaciskow,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x108:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x109:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10A:
	__GETW1MN _a,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10B:
	LDS  R26,_czas_pracy_szczotki_drucianej_h_17
	LDS  R27,_czas_pracy_szczotki_drucianej_h_17+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x10C:
	LDS  R30,_PORT_F
	ORI  R30,0x40
	RJMP SUBOPT_0xDE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10D:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xBA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10E:
	LDS  R26,_czas_pracy_szczotki_drucianej_h_15
	LDS  R27,_czas_pracy_szczotki_drucianej_h_15+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10F:
	LDS  R26,_czas_pracy_krazka_sciernego_h_34
	LDS  R27,_czas_pracy_krazka_sciernego_h_34+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x110:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA1

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x111:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x112:
	LDS  R26,_czas_pracy_krazka_sciernego_h_36
	LDS  R27,_czas_pracy_krazka_sciernego_h_36+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x113:
	LDS  R26,_czas_pracy_krazka_sciernego_h_38
	LDS  R27,_czas_pracy_krazka_sciernego_h_38+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x114:
	LDS  R26,_czas_pracy_krazka_sciernego_h_41
	LDS  R27,_czas_pracy_krazka_sciernego_h_41+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x115:
	LDS  R26,_czas_pracy_krazka_sciernego_h_43
	LDS  R27,_czas_pracy_krazka_sciernego_h_43+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x116:
	LDI  R30,LOW(505)
	LDI  R31,HIGH(505)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x117:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x118:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBI  0x18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x119:
	LDS  R26,_srednica_wew_korpusu
	LDS  R27,_srednica_wew_korpusu+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x11A:
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
SUBOPT_0x11B:
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	RJMP SUBOPT_0xDE

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x11C:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x11D:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0xE3

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:59 WORDS
SUBOPT_0x11E:
	RCALL SUBOPT_0xF2
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11F:
	CALL __LTW12
	MOV  R0,R30
	MOVW R26,R8
	RJMP SUBOPT_0x106

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x120:
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xCE

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x121:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xF3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x122:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x120

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x123:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x124:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x125:
	CALL __LTW12
	MOV  R0,R30
	MOVW R30,R8
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __LTW12
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x126:
	__GETW1MN _a,12
	RJMP SUBOPT_0x121

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x127:
	CALL __EQW12
	MOV  R0,R30
	MOVW R30,R8
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __LTW12
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x128:
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x129:
	MOVW R30,R8
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12A:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x12B:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xD4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12C:
	__GETW1MN _a,16
	RJMP SUBOPT_0x121

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x12D:
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xD4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12E:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 54 TIMES, CODE SIZE REDUCTION:103 WORDS
SUBOPT_0x12F:
	RCALL SUBOPT_0xEE
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x130:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster4
	LDS  R27,_abs_ster4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x131:
	LDS  R26,_powrot_przedwczesny_druciak
	LDS  R27,_powrot_przedwczesny_druciak+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x132:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x133:
	ST   -Y,R31
	ST   -Y,R30
	JMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x134:
	CALL __EQW12
	MOV  R0,R30
	MOVW R30,R4
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x135:
	CALL __LTW12
	AND  R0,R30
	RCALL SUBOPT_0x131
	RJMP SUBOPT_0xCE

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x136:
	LDS  R30,_koniec_rzedu_10
	LDS  R31,_koniec_rzedu_10+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x137:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x138:
	LDS  R30,_abs_ster4
	LDS  R31,_abs_ster4+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x139:
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
SUBOPT_0x13A:
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
	STS  _sek13,R30
	STS  _sek13+1,R30
	STS  _sek13+2,R30
	STS  _sek13+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 44 TIMES, CODE SIZE REDUCTION:83 WORDS
SUBOPT_0x13B:
	RCALL SUBOPT_0xEC
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x13C:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster3
	LDS  R27,_abs_ster3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x13D:
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0xCE

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x13E:
	CALL __EQW12
	MOV  R0,R30
	MOVW R30,R6
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13F:
	CALL __LTW12
	AND  R0,R30
	RJMP SUBOPT_0x13D

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x140:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x141:
	LDS  R30,_abs_ster3
	LDS  R31,_abs_ster3+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x142:
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
SUBOPT_0x143:
	LDI  R30,LOW(0)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x144:
	AND  R0,R30
	RCALL SUBOPT_0x131
	RJMP SUBOPT_0xCE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x145:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xC0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x146:
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
SUBOPT_0x147:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _powrot_przedwczesny_krazek_scierny,R30
	STS  _powrot_przedwczesny_krazek_scierny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x148:
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x149:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x148

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x14A:
	LDI  R30,LOW(0)
	STS  _powrot_przedwczesny_krazek_scierny,R30
	STS  _powrot_przedwczesny_krazek_scierny+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x14B:
	CALL __EQW12
	AND  R0,R30
	MOVW R30,R6
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x14C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x14D:
	RCALL SUBOPT_0x131
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x14E:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x14D

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x14F:
	LDI  R30,LOW(0)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x150:
	MOVW R30,R4
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RJMP SUBOPT_0x13E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x151:
	CALL __EQW12
	AND  R0,R30
	RJMP SUBOPT_0x13B

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x152:
	CALL __EQW12
	AND  R0,R30
	RJMP SUBOPT_0x12F

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x153:
	CALL __EQW12
	AND  R0,R30
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0xE7

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x154:
	RCALL SUBOPT_0x131
	RJMP SUBOPT_0xE7

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x155:
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x156:
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
SUBOPT_0x157:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x158:
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x159:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xC0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15A:
	LDI  R26,LOW(_szczotka_druc_cykl)
	LDI  R27,HIGH(_szczotka_druc_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x15B:
	LDS  R26,_statystyka
	LDS  R27,_statystyka+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15C:
	LDS  R30,_szczotka_druc_cykl
	LDS  R31,_szczotka_druc_cykl+1
	ST   -Y,R31
	ST   -Y,R30
	JMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15D:
	LDS  R30,_cykl_ilosc_zaciskow
	LDS  R31,_cykl_ilosc_zaciskow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15E:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xB4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15F:
	LDI  R26,LOW(_krazek_scierny_cykl)
	LDI  R27,HIGH(_krazek_scierny_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x160:
	LDS  R30,_krazek_scierny_cykl
	LDS  R31,_krazek_scierny_cykl+1
	RJMP SUBOPT_0x15E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x161:
	CALL __EQW12
	AND  R0,R30
	MOVW R30,R4
	RCALL SUBOPT_0x158
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x162:
	LDS  R30,_powrot_przedwczesny_krazek_scierny
	LDS  R31,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x15E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x163:
	LDS  R30,_wykonano_powrot_przedwczesny_krazek_scierny
	LDS  R31,_wykonano_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x15E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x164:
	MOVW R30,R6
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x165:
	LDS  R30,_powrot_przedwczesny_druciak
	LDS  R31,_powrot_przedwczesny_druciak+1
	ST   -Y,R31
	ST   -Y,R30
	JMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x166:
	LDS  R30,_wykonano_powrot_przedwczesny_druciak
	LDS  R31,_wykonano_powrot_przedwczesny_druciak+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x167:
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
SUBOPT_0x168:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x169:
	LDI  R30,LOW(0)
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
	RJMP SUBOPT_0x15F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16A:
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	CP   R6,R26
	CPC  R7,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16B:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16C:
	LDI  R30,LOW(0)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x16D:
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
	RJMP SUBOPT_0xCE

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x16E:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0xCE

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x16F:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0x83

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x170:
	CALL __EQW12
	AND  R0,R30
	MOVW R30,R4
	RCALL SUBOPT_0x158
	CALL __EQW12
	AND  R30,R0
	MOV  R1,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	MOV  R0,R30
	RJMP SUBOPT_0x164

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x171:
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	MOV  R22,R30
	MOV  R0,R30
	MOVW R30,R4
	RCALL SUBOPT_0x158
	RJMP SUBOPT_0x152

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x172:
	MOV  R1,R30
	MOV  R0,R22
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x173:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x174:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x175:
	LDI  R30,LOW(0)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x176:
	LDI  R30,LOW(0)
	STS  _cykl_ilosc_zaciskow,R30
	STS  _cykl_ilosc_zaciskow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x177:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x178:
	LDS  R30,_il_zaciskow_rzad_2
	LDS  R31,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x179:
	LDI  R30,LOW(0)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x17A:
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x17B:
	RCALL SUBOPT_0xF4
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17C:
	RCALL SUBOPT_0x9D
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17D:
	MOV  R0,R30
	RCALL SUBOPT_0xF4
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17E:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	RJMP SUBOPT_0x137

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17F:
	LDI  R30,LOW(0)
	STS  _sek13,R30
	STS  _sek13+1,R30
	STS  _sek13+2,R30
	STS  _sek13+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x180:
	MOVW R30,R4
	RCALL SUBOPT_0x158
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x181:
	MOV  R0,R30
	MOVW R26,R10
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	OR   R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x182:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0x17A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x183:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RJMP SUBOPT_0xE7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x184:
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x185:
	CALL __LTW12
	RJMP SUBOPT_0x184

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x186:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xF6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x187:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0x85

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x188:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x189:
	RCALL SUBOPT_0x178
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x18A:
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x18B:
	LDI  R30,LOW(0)
	STS  _sek12,R30
	STS  _sek12+1,R30
	STS  _sek12+2,R30
	STS  _sek12+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18C:
	LDS  R30,_PORT_F
	ORI  R30,0x10
	RJMP SUBOPT_0xDE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18D:
	CALL __LTW12
	MOV  R0,R30
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18E:
	SBIW R30,2
	RCALL SUBOPT_0x18A
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18F:
	SBIW R30,1
	RCALL SUBOPT_0x18A
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x190:
	SBIW R30,2
	RCALL SUBOPT_0x18A
	CALL __GEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x191:
	CALL __LTW12
	MOV  R0,R30
	RJMP SUBOPT_0x178

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x192:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x193:
	MOV  R0,R30
	LDS  R26,_cykl_glowny
	LDS  R27,_cykl_glowny+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x194:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_34)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_34)
	RJMP SUBOPT_0x192

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x195:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_36)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_36)
	RJMP SUBOPT_0x192

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x196:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_38)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_38)
	RJMP SUBOPT_0x192

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x197:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_41)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_41)
	RJMP SUBOPT_0x192

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x198:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_43)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_43)
	RJMP SUBOPT_0x192

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x199:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	RJMP SUBOPT_0x18A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x19B:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RCALL SUBOPT_0x18A
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19C:
	RCALL SUBOPT_0x178
	RCALL SUBOPT_0x18A
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0x105
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19D:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RJMP SUBOPT_0x17A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19E:
	LDS  R26,_wykonalem_rzedow
	LDS  R27,_wykonalem_rzedow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19F:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	RJMP SUBOPT_0x177

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1A0:
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
SUBOPT_0x1A1:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A2:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A3:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	JMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A4:
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
