
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
;long int sek1,sek2,sek3,sek4,sek5,sek6,sek7,sek8,sek9,sek10,sek11,sek12,sek13,sek20,sek80;
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
;long int sek21;
;int sek21_wylaczenie_szlif;
;
;char sprawdz_pin0(BB PORT, int numer_pcf)
; 0000 00D5 {
_sprawdz_pin0:
; 0000 00D6 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00D7 i2c_write(numer_pcf);
; 0000 00D8 PORT.byte = i2c_read(0);
; 0000 00D9 i2c_stop();
; 0000 00DA 
; 0000 00DB 
; 0000 00DC return PORT.bits.b0;
	RJMP _0x20A0005
; 0000 00DD }
;
;char sprawdz_pin1(BB PORT, int numer_pcf)
; 0000 00E0 {
_sprawdz_pin1:
; 0000 00E1 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00E2 i2c_write(numer_pcf);
; 0000 00E3 PORT.byte = i2c_read(0);
; 0000 00E4 i2c_stop();
; 0000 00E5 
; 0000 00E6 
; 0000 00E7 return PORT.bits.b1;
	LSR  R30
	RJMP _0x20A0005
; 0000 00E8 }
;
;
;char sprawdz_pin2(BB PORT, int numer_pcf)
; 0000 00EC {
_sprawdz_pin2:
; 0000 00ED i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00EE i2c_write(numer_pcf);
; 0000 00EF PORT.byte = i2c_read(0);
; 0000 00F0 i2c_stop();
; 0000 00F1 
; 0000 00F2 
; 0000 00F3 return PORT.bits.b2;
	LSR  R30
	LSR  R30
	RJMP _0x20A0005
; 0000 00F4 }
;
;char sprawdz_pin3(BB PORT, int numer_pcf)
; 0000 00F7 {
_sprawdz_pin3:
; 0000 00F8 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00F9 i2c_write(numer_pcf);
; 0000 00FA PORT.byte = i2c_read(0);
; 0000 00FB i2c_stop();
; 0000 00FC 
; 0000 00FD 
; 0000 00FE return PORT.bits.b3;
	LSR  R30
	LSR  R30
	LSR  R30
	RJMP _0x20A0005
; 0000 00FF }
;
;char sprawdz_pin4(BB PORT, int numer_pcf)
; 0000 0102 {
_sprawdz_pin4:
; 0000 0103 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0104 i2c_write(numer_pcf);
; 0000 0105 PORT.byte = i2c_read(0);
; 0000 0106 i2c_stop();
; 0000 0107 
; 0000 0108 
; 0000 0109 return PORT.bits.b4;
	SWAP R30
	RJMP _0x20A0005
; 0000 010A }
;
;char sprawdz_pin5(BB PORT, int numer_pcf)
; 0000 010D {
_sprawdz_pin5:
; 0000 010E i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 010F i2c_write(numer_pcf);
; 0000 0110 PORT.byte = i2c_read(0);
; 0000 0111 i2c_stop();
; 0000 0112 
; 0000 0113 
; 0000 0114 return PORT.bits.b5;
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	RJMP _0x20A0005
; 0000 0115 }
;
;char sprawdz_pin6(BB PORT, int numer_pcf)
; 0000 0118 {
_sprawdz_pin6:
; 0000 0119 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 011A i2c_write(numer_pcf);
; 0000 011B PORT.byte = i2c_read(0);
; 0000 011C i2c_stop();
; 0000 011D 
; 0000 011E 
; 0000 011F return PORT.bits.b6;
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	RJMP _0x20A0005
; 0000 0120 }
;
;char sprawdz_pin7(BB PORT, int numer_pcf)
; 0000 0123 {
_sprawdz_pin7:
; 0000 0124 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0125 i2c_write(numer_pcf);
; 0000 0126 PORT.byte = i2c_read(0);
; 0000 0127 i2c_stop();
; 0000 0128 
; 0000 0129 
; 0000 012A return PORT.bits.b7;
	ROL  R30
	LDI  R30,0
	ROL  R30
_0x20A0005:
	ANDI R30,LOW(0x1)
	ADIW R28,3
	RET
; 0000 012B }
;
;int odczytaj_parametr(int adres1, int adres2)
; 0000 012E {
_odczytaj_parametr:
; 0000 012F int z;
; 0000 0130 z = 0;
	CALL SUBOPT_0x1
;	adres1 -> Y+4
;	adres2 -> Y+2
;	z -> R16,R17
; 0000 0131 putchar(90);
	CALL SUBOPT_0x2
; 0000 0132 putchar(165);
; 0000 0133 putchar(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _putchar
; 0000 0134 putchar(131);
	LDI  R30,LOW(131)
	CALL SUBOPT_0x3
; 0000 0135 putchar(adres1);
; 0000 0136 putchar(adres2);
; 0000 0137 putchar(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar
; 0000 0138 getchar();
	CALL SUBOPT_0x4
; 0000 0139 getchar();
; 0000 013A getchar();
; 0000 013B getchar();
	CALL SUBOPT_0x4
; 0000 013C getchar();
; 0000 013D getchar();
; 0000 013E getchar();
	CALL SUBOPT_0x4
; 0000 013F getchar();
; 0000 0140 z = getchar();
	MOV  R16,R30
	CLR  R17
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
; 0000 014B 
; 0000 014C 
; 0000 014D return z;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0004
; 0000 014E }
;
;
;
;int czekaj_na_guzik_start(int adres)
; 0000 0153 {
; 0000 0154 //48 to adres zmiennej 30
; 0000 0155 //16 to adres zmiennj 10
; 0000 0156 
; 0000 0157 int z;
; 0000 0158 z = 0;
;	adres -> Y+2
;	z -> R16,R17
; 0000 0159 putchar(90);
; 0000 015A putchar(165);
; 0000 015B putchar(4);
; 0000 015C putchar(131);
; 0000 015D putchar(0);
; 0000 015E putchar(adres);  //adres zmiennej - 30
; 0000 015F putchar(1);
; 0000 0160 getchar();
; 0000 0161 getchar();
; 0000 0162 getchar();
; 0000 0163 getchar();
; 0000 0164 getchar();
; 0000 0165 getchar();
; 0000 0166 getchar();
; 0000 0167 getchar();
; 0000 0168 z = getchar();
; 0000 0169 //itoa(z,dupa1);
; 0000 016A //lcd_puts(dupa1);
; 0000 016B 
; 0000 016C return z;
; 0000 016D }
;
;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0174 {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0175 // Place your code here
; 0000 0176 //16,384 ms
; 0000 0177 sek1++;     //Ster 1
	LDI  R26,LOW(_sek1)
	LDI  R27,HIGH(_sek1)
	CALL SUBOPT_0x5
; 0000 0178 sek2++;     //ster 3
	LDI  R26,LOW(_sek2)
	LDI  R27,HIGH(_sek2)
	CALL SUBOPT_0x5
; 0000 0179 
; 0000 017A 
; 0000 017B sek3++;     //ster 2
	LDI  R26,LOW(_sek3)
	LDI  R27,HIGH(_sek3)
	CALL SUBOPT_0x5
; 0000 017C sek4++;     //ster 4
	LDI  R26,LOW(_sek4)
	LDI  R27,HIGH(_sek4)
	CALL SUBOPT_0x5
; 0000 017D 
; 0000 017E 
; 0000 017F //sek10++;
; 0000 0180 
; 0000 0181 sek11++;  //do wyboru zacisku
	LDI  R26,LOW(_sek11)
	LDI  R27,HIGH(_sek11)
	CALL SUBOPT_0x5
; 0000 0182 sek12++;  //do czasu przedmuchu
	LDI  R26,LOW(_sek12)
	LDI  R27,HIGH(_sek12)
	CALL SUBOPT_0x5
; 0000 0183 
; 0000 0184 sek13++;  //do czasu zatrzymania sie druciaka na gorze
	LDI  R26,LOW(_sek13)
	LDI  R27,HIGH(_sek13)
	CALL SUBOPT_0x5
; 0000 0185 
; 0000 0186 sek20++;
	LDI  R26,LOW(_sek20)
	LDI  R27,HIGH(_sek20)
	CALL SUBOPT_0x5
; 0000 0187 
; 0000 0188 sek80++;  //do kodu panela
	LDI  R26,LOW(_sek80)
	LDI  R27,HIGH(_sek80)
	CALL SUBOPT_0x5
; 0000 0189 sek21++;    //do wylaczenia szlifierki krazka sciernego przed klami
	LDI  R26,LOW(_sek21)
	LDI  R27,HIGH(_sek21)
	CALL SUBOPT_0x5
; 0000 018A 
; 0000 018B /*
; 0000 018C if(PORTE.3 == 1)
; 0000 018D       {
; 0000 018E       czas_pracy_szczotki_drucianej++;
; 0000 018F       czas_pracy_krazka_sciernego++;
; 0000 0190       if(czas_pracy_szczotki_drucianej == 61 * 60 * 60)
; 0000 0191             {
; 0000 0192             czas_pracy_szczotki_drucianej = 0;
; 0000 0193             czas_pracy_szczotki_drucianej_h++;
; 0000 0194             }
; 0000 0195       if(czas_pracy_krazka_sciernego == 61 * 60 * 60)
; 0000 0196             {
; 0000 0197             czas_pracy_krazka_sciernego = 0;
; 0000 0198             czas_pracy_krazka_sciernego_h++;
; 0000 0199             }
; 0000 019A       }
; 0000 019B 
; 0000 019C 
; 0000 019D       //61 razy - 1s
; 0000 019E       //61 * 60 - 1 minuta
; 0000 019F       //61 * 60 * 60 - 1h
; 0000 01A0 
; 0000 01A1 */
; 0000 01A2 
; 0000 01A3 }
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
; 0000 01AC {
_komunikat_na_panel:
; 0000 01AD int h;
; 0000 01AE 
; 0000 01AF h = 0;
	CALL SUBOPT_0x1
;	*fmtstr -> Y+6
;	adres2 -> Y+4
;	adres22 -> Y+2
;	h -> R16,R17
; 0000 01B0 h = strlenf(fmtstr);
	CALL SUBOPT_0x6
	CALL _strlenf
	MOVW R16,R30
; 0000 01B1 h = h + 3;
	__ADDWRN 16,17,3
; 0000 01B2 
; 0000 01B3 putchar(90);
	CALL SUBOPT_0x2
; 0000 01B4 putchar(165);
; 0000 01B5 putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL _putchar
; 0000 01B6 putchar(130);  //82
	LDI  R30,LOW(130)
	CALL SUBOPT_0x3
; 0000 01B7 putchar(adres2);    //
; 0000 01B8 putchar(adres22);  //
; 0000 01B9 printf(fmtstr);
	CALL SUBOPT_0x6
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 01BA }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;
;
;
;void wartosc_parametru_panelu(int wartosc, int adres1, int adres2)
; 0000 01BF {
_wartosc_parametru_panelu:
; 0000 01C0 putchar(90);  //5A
;	wartosc -> Y+4
;	adres1 -> Y+2
;	adres2 -> Y+0
	CALL SUBOPT_0x2
; 0000 01C1 putchar(165); //A5
; 0000 01C2 putchar(5);//05
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL SUBOPT_0x7
; 0000 01C3 putchar(130);  //82    /
; 0000 01C4 putchar(adres1);    //00
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
; 0000 01C5 putchar(adres2);   //40
	CALL SUBOPT_0x8
; 0000 01C6 putchar(0);    //00
; 0000 01C7 putchar(wartosc);   //80
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _putchar
; 0000 01C8 }
_0x20A0004:
	ADIW R28,6
	RET
;
;
;void zaktualizuj_parametry_panelu()
; 0000 01CC {
_zaktualizuj_parametry_panelu:
; 0000 01CD 
; 0000 01CE /////////////////////////
; 0000 01CF //wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
; 0000 01D0 
; 0000 01D1 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
; 0000 01D2 
; 0000 01D3 //wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
; 0000 01D4 
; 0000 01D5 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
; 0000 01D6 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
; 0000 01D7 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
; 0000 01D8 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
; 0000 01D9 //wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
; 0000 01DA 
; 0000 01DB //////////////////////////
; 0000 01DC 
; 0000 01DD 
; 0000 01DE 
; 0000 01DF 
; 0000 01E0 if(zaaktualizuj_ilosc_rzad2 == 1)
	LDS  R26,_zaaktualizuj_ilosc_rzad2
	LDS  R27,_zaaktualizuj_ilosc_rzad2+1
	SBIW R26,1
	BRNE _0xD
; 0000 01E1     {
; 0000 01E2     wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	RCALL _wartosc_parametru_panelu
; 0000 01E3     zaaktualizuj_ilosc_rzad2 = 0;
	LDI  R30,LOW(0)
	STS  _zaaktualizuj_ilosc_rzad2,R30
	STS  _zaaktualizuj_ilosc_rzad2+1,R30
; 0000 01E4     }
; 0000 01E5 }
_0xD:
	RET
;
;void komunikat_z_czytnika_kodow(char flash *fmtstr,int rzad, int na_plus_minus)
; 0000 01E8 {
_komunikat_z_czytnika_kodow:
; 0000 01E9 //na_plus_minus = 1;  to jest na plus
; 0000 01EA //na_plus_minus = 0;  to jest na minus
; 0000 01EB 
; 0000 01EC int h, adres1,adres11,adres2,adres22;
; 0000 01ED 
; 0000 01EE h = 0;
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
; 0000 01EF h = strlenf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOVW R16,R30
; 0000 01F0 h = h + 3;
	__ADDWRN 16,17,3
; 0000 01F1 
; 0000 01F2 if(rzad == 1)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BRNE _0xE
; 0000 01F3    {
; 0000 01F4    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01F5    adres11 = 80;
	__GETWRN 20,21,80
; 0000 01F6    adres2 = 80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01F7    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01F8    }
; 0000 01F9 if(rzad == 2)
_0xE:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,2
	BRNE _0xF
; 0000 01FA    {
; 0000 01FB    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01FC    adres11 = 32;
	__GETWRN 20,21,32
; 0000 01FD    adres2 = 64;
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01FE    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01FF    }
; 0000 0200 
; 0000 0201 putchar(90);
_0xF:
	CALL SUBOPT_0x2
; 0000 0202 putchar(165);
; 0000 0203 putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL SUBOPT_0x7
; 0000 0204 putchar(130);  //82
; 0000 0205 putchar(adres1);    //
	ST   -Y,R18
	CALL _putchar
; 0000 0206 putchar(adres11);  //
	ST   -Y,R20
	CALL _putchar
; 0000 0207 printf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 0208 
; 0000 0209 
; 0000 020A if(rzad == 1 & macierz_zaciskow[rzad]==0)
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	BREQ _0x10
; 0000 020B     {
; 0000 020C     komunikat_na_panel("                                                ",144,80);//128,144
	CALL SUBOPT_0xD
; 0000 020D     komunikat_na_panel("Zacisk nie zmierzony u Wykonawcy",144,80);
	__POINTW1FN _0x0,49
	CALL SUBOPT_0xE
; 0000 020E     }
; 0000 020F 
; 0000 0210 if(rzad == 1 & na_plus_minus == 1)
_0x10:
	CALL SUBOPT_0xB
	CALL SUBOPT_0xF
	BREQ _0x11
; 0000 0211     {
; 0000 0212     komunikat_na_panel("                                                ",144,80);  //128,144
	CALL SUBOPT_0xD
; 0000 0213     //komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
; 0000 0214     komunikat_na_panel("Kly w kierunku prawej strony",144,80);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0xE
; 0000 0215     }
; 0000 0216 
; 0000 0217 if(rzad == 1 & na_plus_minus == 0)
_0x11:
	CALL SUBOPT_0xB
	CALL SUBOPT_0x10
	BREQ _0x12
; 0000 0218     {
; 0000 0219     komunikat_na_panel("                                                ",144,80);  //128,144
	CALL SUBOPT_0xD
; 0000 021A     //komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
; 0000 021B     komunikat_na_panel("Kly w kierunku lewej strony",144,80);
	__POINTW1FN _0x0,111
	CALL SUBOPT_0xE
; 0000 021C     }
; 0000 021D 
; 0000 021E 
; 0000 021F if(rzad == 2 & na_plus_minus == 1)
_0x12:
	CALL SUBOPT_0x11
	CALL SUBOPT_0xF
	BREQ _0x13
; 0000 0220     {
; 0000 0221     komunikat_na_panel("                                                ",128,144);  //144,80
	CALL SUBOPT_0x12
; 0000 0222     //komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
; 0000 0223     komunikat_na_panel("Kly w kierunku lewej strony",128,144);
	__POINTW1FN _0x0,111
	CALL SUBOPT_0x13
; 0000 0224     }
; 0000 0225 
; 0000 0226 if(rzad == 2 & na_plus_minus == 0)
_0x13:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x10
	BREQ _0x14
; 0000 0227     {
; 0000 0228     komunikat_na_panel("                                                ",128,144); //144,80
	CALL SUBOPT_0x12
; 0000 0229     //komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
; 0000 022A     komunikat_na_panel("Kly w kierunku prawej strony",128,144);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0x13
; 0000 022B     }
; 0000 022C 
; 0000 022D if(rzad == 2 & macierz_zaciskow[rzad]==0)
_0x14:
	CALL SUBOPT_0x11
	CALL SUBOPT_0xC
	BREQ _0x15
; 0000 022E     {
; 0000 022F     komunikat_na_panel("                                                ",128,144);  //144,80
	CALL SUBOPT_0x12
; 0000 0230     komunikat_na_panel("Zacisk nie zmierzony u Wykonawcy",128,144);
	__POINTW1FN _0x0,49
	CALL SUBOPT_0x13
; 0000 0231     }
; 0000 0232 
; 0000 0233 
; 0000 0234 }
_0x15:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;
;void zerowanie_pam_wew()
; 0000 0237 {
; 0000 0238 /*
; 0000 0239 if(czas_pracy_szczotki_drucianej_h >= 255 | czas_pracy_krazka_sciernego_h >=255 | czas_pracy_krazka_sciernego_stala >= 255 | czas_pracy_szczotki_drucianej_stala >= 255 |
; 0000 023A    szczotka_druciana_ilosc_cykli >= 255 | krazek_scierny_ilosc_cykli >= 255 | krazek_scierny_cykl_po_okregu_ilosc >=255)
; 0000 023B      {
; 0000 023C      czas_pracy_szczotki_drucianej_h = 0;
; 0000 023D      czas_pracy_szczotki_drucianej = 0;
; 0000 023E      czas_pracy_krazka_sciernego_h = 0;
; 0000 023F      czas_pracy_krazka_sciernego = 0;
; 0000 0240      czas_pracy_krazka_sciernego_stala = 5;
; 0000 0241      czas_pracy_szczotki_drucianej_stala = 5;
; 0000 0242      szczotka_druciana_ilosc_cykli = 3;
; 0000 0243      krazek_scierny_ilosc_cykli = 3;
; 0000 0244      krazek_scierny_cykl_po_okregu_ilosc = 3;
; 0000 0245      }
; 0000 0246 */
; 0000 0247 
; 0000 0248 /*
; 0000 0249 if(czas_pracy_krazka_sciernego_h >= 255)
; 0000 024A      {
; 0000 024B      czas_pracy_krazka_sciernego_h = 0;
; 0000 024C      czas_pracy_krazka_sciernego = 0;
; 0000 024D      }
; 0000 024E if(czas_pracy_krazka_sciernego_stala >= 255)
; 0000 024F      czas_pracy_krazka_sciernego_stala = 5;
; 0000 0250 
; 0000 0251 if(czas_pracy_szczotki_drucianej_stala >= 255)
; 0000 0252      czas_pracy_szczotki_drucianej_stala = 5;
; 0000 0253 
; 0000 0254 if(szczotka_druciana_ilosc_cykli >= 255)
; 0000 0255 
; 0000 0256 if(krazek_scierny_ilosc_cykli >= 255)
; 0000 0257 
; 0000 0258 if(krazek_scierny_cykl_po_okregu_ilosc >=255)
; 0000 0259 */
; 0000 025A 
; 0000 025B }
;
;
;void odpytaj_parametry_panelu()
; 0000 025F {
_odpytaj_parametry_panelu:
; 0000 0260 // to wylaczam tylko do testow w switniakch
; 0000 0261 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x16
; 0000 0262     start = odczytaj_parametr(0,64);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x17
	STS  _start,R30
	STS  _start+1,R31
; 0000 0263 il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
_0x16:
	CALL SUBOPT_0x9
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0000 0264 il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
; 0000 0265 
; 0000 0266 
; 0000 0267 
; 0000 0268 szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1C
; 0000 0269                                                 //2090
; 0000 026A krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
; 0000 026B                                                     //3000
; 0000 026C krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
	CALL SUBOPT_0x9
	RCALL _odczytaj_parametr
	MOVW R8,R30
; 0000 026D 
; 0000 026E //////////////////////////////////////////////
; 0000 026F czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
; 0000 0270 
; 0000 0271 czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
	CALL SUBOPT_0x1F
; 0000 0272 
; 0000 0273 
; 0000 0274 czas_pracy_szczotki_drucianej_h_17 = odczytaj_parametr(0,144);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
; 0000 0275 czas_pracy_szczotki_drucianej_h_15 = odczytaj_parametr(16,128);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x18
	CALL SUBOPT_0x22
; 0000 0276 
; 0000 0277 
; 0000 0278 czas_pracy_krazka_sciernego_h_34 = odczytaj_parametr(96,48);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1A
	RCALL _odczytaj_parametr
	CALL SUBOPT_0x24
; 0000 0279 czas_pracy_krazka_sciernego_h_36 = odczytaj_parametr(96,64);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x17
	CALL SUBOPT_0x25
; 0000 027A czas_pracy_krazka_sciernego_h_38 = odczytaj_parametr(96,80);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
; 0000 027B czas_pracy_krazka_sciernego_h_41 = odczytaj_parametr(96,96);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	RCALL _odczytaj_parametr
	CALL SUBOPT_0x28
; 0000 027C czas_pracy_krazka_sciernego_h_43 = odczytaj_parametr(96,112);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x29
; 0000 027D 
; 0000 027E //////////////////////////////////////////////////////////
; 0000 027F 
; 0000 0280 test_geometryczny_rzad_1 = odczytaj_parametr(48,80);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x26
	STS  _test_geometryczny_rzad_1,R30
	STS  _test_geometryczny_rzad_1+1,R31
; 0000 0281 
; 0000 0282 test_geometryczny_rzad_2 = odczytaj_parametr(48,96);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x23
	RCALL _odczytaj_parametr
	STS  _test_geometryczny_rzad_2,R30
	STS  _test_geometryczny_rzad_2+1,R31
; 0000 0283 
; 0000 0284 srednica_krazka_sciernego = odczytaj_parametr(48,112);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x2A
; 0000 0285 
; 0000 0286 ruch_haos = odczytaj_parametr(48,144);
	CALL SUBOPT_0x20
	STS  _ruch_haos,R30
	STS  _ruch_haos+1,R31
; 0000 0287 
; 0000 0288 tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1D
	MOVW R10,R30
; 0000 0289                                                 //2050
; 0000 028A //zerowanie_pam_wew();
; 0000 028B 
; 0000 028C }
	RET
;
;void wyrrrjscia_i_wejscia_opis()
; 0000 028F {
; 0000 0290 
; 0000 0291 
; 0000 0292 //IN0
; 0000 0293 
; 0000 0294 //komunikacja miedzy slave a master
; 0000 0295 //sprawdz_pin0(PORTHH,0x73)
; 0000 0296 //sprawdz_pin1(PORTHH,0x73)
; 0000 0297 //sprawdz_pin2(PORTHH,0x73)
; 0000 0298 //sprawdz_pin3(PORTHH,0x73)
; 0000 0299 //sprawdz_pin4(PORTHH,0x73)
; 0000 029A //sprawdz_pin5(PORTHH,0x73)
; 0000 029B //sprawdz_pin6(PORTHH,0x73)
; 0000 029C //sprawdz_pin7(PORTHH,0x73)
; 0000 029D 
; 0000 029E //IN1
; 0000 029F //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 02A0 //sprawdz_pin1(PORTJJ,0x79)  AREA   STEROWNIK1
; 0000 02A1 //sprawdz_pin2(PORTJJ,0x79)  SETON  STEROWNIK1
; 0000 02A2 //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 02A3 //sprawdz_pin4(PORTJJ,0x79)  SVRE   STEROWNIK1
; 0000 02A4 //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 02A5 //sprawdz_pin6(PORTJJ,0x79)  czujnik cisnienia
; 0000 02A6 //sprawdz_pin7(PORTJJ,0x79)
; 0000 02A7 
; 0000 02A8 //IN2
; 0000 02A9 //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 02AA //sprawdz_pin1(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK3
; 0000 02AB //sprawdz_pin2(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK3
; 0000 02AC //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 02AD //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 02AE //sprawdz_pin5(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK4
; 0000 02AF //sprawdz_pin6(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK4
; 0000 02B0 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 02B1 
; 0000 02B2 //IN3
; 0000 02B3 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 02B4 //sprawdz_pin1(PORTLL,0x71)  AREA   STEROWNIK2
; 0000 02B5 //sprawdz_pin2(PORTLL,0x71)  SETON  STEROWNIK2
; 0000 02B6 //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 02B7 //sprawdz_pin4(PORTLL,0x71)  SVRE   STEROWNIK2
; 0000 02B8 //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 02B9 //sprawdz_pin6(PORTLL,0x71)  S6A przek³adanie rzedow
; 0000 02BA //sprawdz_pin7(PORTLL,0x71)  S6B przekladanie rzedow
; 0000 02BB 
; 0000 02BC //IN4
; 0000 02BD //sprawdz_pin0(PORTMM,0x77) J2  czujnik indukcyjny domkniecia pokrywy
; 0000 02BE //sprawdz_pin1(PORTMM,0x77) J3  czujnik indukcyjny domkniecia pokrywy
; 0000 02BF //sprawdz_pin2(PORTMM,0x77)
; 0000 02C0 //sprawdz_pin3(PORTMM,0x77)
; 0000 02C1 //sprawdz_pin4(PORTMM,0x77)
; 0000 02C2 //sprawdz_pin5(PORTMM,0x77)
; 0000 02C3 //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 02C4 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 02C5 
; 0000 02C6 //sterownik 1 i sterownik 3 - krazek scierny
; 0000 02C7 //sterownik 2 i sterownik 4 - druciak
; 0000 02C8 
; 0000 02C9 //OUT
; 0000 02CA //PORTA.0   IN0  STEROWNIK1        OUT 1
; 0000 02CB //PORTA.1   IN1  STEROWNIK1
; 0000 02CC //PORTA.2   IN2  STEROWNIK1
; 0000 02CD //PORTA.3   IN3  STEROWNIK1
; 0000 02CE //PORTA.4   IN4  STEROWNIK1
; 0000 02CF //PORTA.5   IN5  STEROWNIK1
; 0000 02D0 //PORTA.6   IN6  STEROWNIK1
; 0000 02D1 //PORTA.7   IN7  STEROWNIK1
; 0000 02D2 
; 0000 02D3 //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 02D4 //PORTB.1   IN1  STEROWNIK4
; 0000 02D5 //PORTB.2   IN2  STEROWNIK4
; 0000 02D6 //PORTB.3   IN3  STEROWNIK4
; 0000 02D7 //PORTB.4   4B CEWKA przedmuch osi, byl, juz poloczone z B.6, teraz juz setup poziome
; 0000 02D8 //PORTB.5   DRIVE  STEROWNIK4
; 0000 02D9 //PORTB.6   swiatlo zielone
; 0000 02DA //PORTB.7   IN5 STEROWNIK 3
; 0000 02DB 
; 0000 02DC //PORTC.0   IN0  STEROWNIK2        OUT 3
; 0000 02DD //PORTC.1   IN1  STEROWNIK2
; 0000 02DE //PORTC.2   IN2  STEROWNIK2
; 0000 02DF //PORTC.3   IN3  STEROWNIK2
; 0000 02E0 //PORTC.4   IN4  STEROWNIK2
; 0000 02E1 //PORTC.5   IN5  STEROWNIK2
; 0000 02E2 //PORTC.6   IN6  STEROWNIK2
; 0000 02E3 //PORTC.7   IN7  STEROWNIK2
; 0000 02E4 
; 0000 02E5 //PORTD.0  SDA                     OUT 2
; 0000 02E6 //PORTD.1  SCL
; 0000 02E7 //PORTD.2  SETUP   STEROWNIK1 STEROWNIK 2 STEROIWNIK 3 STEROWNIK 4
; 0000 02E8 //PORTD.3  DRIVE   STEROWNIK1
; 0000 02E9 //PORTD.4  IN8 STEROWNIK1
; 0000 02EA //PORTD.5  IN8 STEROWNIK2
; 0000 02EB //PORTD.6  DRIVE   STEROWNIK2
; 0000 02EC //PORTD.7  swiatlo czerwone i jednoczesnie HOLD
; 0000 02ED 
; 0000 02EE //PORTE.0
; 0000 02EF //PORTE.1
; 0000 02F0 //PORTE.2  1A CEWKA szczotka druciana                    OUT 6
; 0000 02F1 //PORTE.3  1B CEWKA krazek scierny
; 0000 02F2 //PORTE.4  IN4  STEROWNIK4
; 0000 02F3 //PORTE.5  IN5  STEROWNIK4   ///////////////////////////////////////////////teraz tu bêdzie przedmuch kana³ B
; 0000 02F4 //PORTE.6  2A CEWKA przerzucanie docisku zaciskow
; 0000 02F5 //PORTE.7  3A CEWKA zacisnij zaciski
; 0000 02F6 
; 0000 02F7 //PORTF.0   IN0  STEROWNIK3             OUT 4
; 0000 02F8 //PORTF.1   IN1  STEROWNIK3
; 0000 02F9 //PORTF.2   IN2  STEROWNIK3
; 0000 02FA //PORTF.3   IN3  STEROWNIK3
; 0000 02FB //PORTF.4   4A CEWKA przedmuch zaciskow
; 0000 02FC //PORTF.5   DRIVE  STEROWNIK3
; 0000 02FD //PORTF.6   swiatlo zolte
; 0000 02FE //PORTF.7   IN4 STEROWNIK 3
; 0000 02FF 
; 0000 0300 
; 0000 0301 
; 0000 0302  //PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 0303 //PORTF = PORT_F.byte;
; 0000 0304 //PORTB.6 = 1;  //przedmuch osi
; 0000 0305 //PORTE.2 = 1;  //szlifierka 1
; 0000 0306 //PORTE.3 = 1;  //szlifierka 2
; 0000 0307 //PORTE.6 = 0;  //zacisniety rzad 1
; 0000 0308 //PORTE.6 = 1;  //zacisniety rzad 2
; 0000 0309 //PORTE.7 = 0;    //zacisnij zaciski
; 0000 030A 
; 0000 030B 
; 0000 030C //macierz_zaciskow[rzad]=44; brak
; 0000 030D //macierz_zaciskow[rzad]=48; brak
; 0000 030E //macierz_zaciskow[rzad]=76  brak
; 0000 030F //macierz_zaciskow[rzad]=80; brak
; 0000 0310 //macierz_zaciskow[rzad]=92; brak
; 0000 0311 //macierz_zaciskow[rzad]=96;  brak
; 0000 0312 //macierz_zaciskow[rzad]=107; brak
; 0000 0313 //macierz_zaciskow[rzad]=111; brak
; 0000 0314 
; 0000 0315 
; 0000 0316 
; 0000 0317 
; 0000 0318 /*
; 0000 0319 
; 0000 031A //testy parzystych i nieparzystych IN0-IN8
; 0000 031B //testy port/pin
; 0000 031C //sterownik 3
; 0000 031D //PORTF.0   IN0  STEROWNIK3
; 0000 031E //PORTF.1   IN1  STEROWNIK3
; 0000 031F //PORTF.2   IN2  STEROWNIK3
; 0000 0320 //PORTF.3   IN3  STEROWNIK3
; 0000 0321 //PORTF.7   IN4 STEROWNIK 3
; 0000 0322 //PORTB.7   IN5 STEROWNIK 3
; 0000 0323 
; 0000 0324 
; 0000 0325 PORT_F.bits.b0 = 0;
; 0000 0326 PORT_F.bits.b1 = 1;
; 0000 0327 PORT_F.bits.b2 = 0;
; 0000 0328 PORT_F.bits.b3 = 1;
; 0000 0329 PORT_F.bits.b7 = 0;
; 0000 032A PORTF = PORT_F.byte;
; 0000 032B PORTB.7 = 1;
; 0000 032C 
; 0000 032D //sterownik 4
; 0000 032E 
; 0000 032F //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 0330 //PORTB.1   IN1  STEROWNIK4
; 0000 0331 //PORTB.2   IN2  STEROWNIK4
; 0000 0332 //PORTB.3   IN3  STEROWNIK4
; 0000 0333 //PORTE.4  IN4  STEROWNIK4
; 0000 0334 
; 0000 0335 
; 0000 0336 PORTB.0 = 0;
; 0000 0337 PORTB.1 = 1;
; 0000 0338 PORTB.2 = 0;
; 0000 0339 PORTB.3 = 1;
; 0000 033A PORTE.4 = 0;
; 0000 033B 
; 0000 033C 
; 0000 033D //ster 1
; 0000 033E PORTA.0 = 0;   //IN0  STEROWNIK1        OUT 1
; 0000 033F PORTA.1 = 1;  //IN1  STEROWNIK1
; 0000 0340 PORTA.2 = 0;  // IN2  STEROWNIK1
; 0000 0341 PORTA.3 = 1;  //IN3  STEROWNIK1
; 0000 0342 PORTA.4 = 0;  // IN4  STEROWNIK1
; 0000 0343 PORTA.5 = 1;  //IN5  STEROWNIK1
; 0000 0344 PORTA.6 = 0;   //IN6  STEROWNIK1
; 0000 0345 PORTA.7 = 1;  //IN7  STEROWNIK1
; 0000 0346 PORTD.4 = 0; //IN8 STEROWNIK1
; 0000 0347 
; 0000 0348 
; 0000 0349 
; 0000 034A //sterownik 2
; 0000 034B PORTC.0 = 0;   //IN0  STEROWNIK2        OUT 3
; 0000 034C PORTC.1  = 1;  //IN1  STEROWNIK2
; 0000 034D PORTC.2 = 0;    //IN2  STEROWNIK2
; 0000 034E PORTC.3= 1;   //IN3  STEROWNIK2
; 0000 034F PORTC.4 = 0;   // IN4  STEROWNIK2
; 0000 0350 PORTC.5= 1;   //IN5  STEROWNIK2
; 0000 0351 PORTC.6 = 0;   // IN6  STEROWNIK2
; 0000 0352 PORTC.7= 1;   //IN7  STEROWNIK2
; 0000 0353 PORTD.5 = 0;  //IN8 STEROWNIK2
; 0000 0354 
; 0000 0355 */
; 0000 0356 
; 0000 0357 }
;
;void sprawdz_cisnienie()
; 0000 035A {
_sprawdz_cisnienie:
; 0000 035B int i;
; 0000 035C i = 0;
	CALL SUBOPT_0x1
;	i -> R16,R17
; 0000 035D //i = 1;
; 0000 035E 
; 0000 035F while(i == 0)
_0x17:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x19
; 0000 0360     {
; 0000 0361     if(sprawdz_pin6(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x2B
	RCALL _sprawdz_pin6
	CPI  R30,0
	BRNE _0x1A
; 0000 0362         {
; 0000 0363         i = 1;
	__GETWRN 16,17,1
; 0000 0364         if(cisnienie_sprawdzone == 0)
	LDS  R30,_cisnienie_sprawdzone
	LDS  R31,_cisnienie_sprawdzone+1
	SBIW R30,0
	BRNE _0x1B
; 0000 0365             {
; 0000 0366             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 0367             cisnienie_sprawdzone = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cisnienie_sprawdzone,R30
	STS  _cisnienie_sprawdzone+1,R31
; 0000 0368             }
; 0000 0369 
; 0000 036A         }
_0x1B:
; 0000 036B     else
	RJMP _0x1C
_0x1A:
; 0000 036C         {
; 0000 036D         i = 0;
	__GETWRN 16,17,0
; 0000 036E         cisnienie_sprawdzone = 0;
	LDI  R30,LOW(0)
	STS  _cisnienie_sprawdzone,R30
	STS  _cisnienie_sprawdzone+1,R30
; 0000 036F         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 0370         komunikat_na_panel("Cisnienie za male - mniejsze niz 6 bar",adr1,adr2);
	__POINTW1FN _0x0,139
	CALL SUBOPT_0x2D
; 0000 0371 
; 0000 0372         }
_0x1C:
; 0000 0373     }
	RJMP _0x17
_0x19:
; 0000 0374 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;int odczyt_wybranego_zacisku()
; 0000 0378 {                         //11
_odczyt_wybranego_zacisku:
; 0000 0379 int rzad;
; 0000 037A 
; 0000 037B PORT_CZYTNIK.bits.b0 = sprawdz_pin0(PORTHH,0x73);
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	CALL SUBOPT_0x2E
	RCALL _sprawdz_pin0
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFE
	CALL SUBOPT_0x2F
; 0000 037C PORT_CZYTNIK.bits.b1 = sprawdz_pin1(PORTHH,0x73);
	RCALL _sprawdz_pin1
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFD
	CALL SUBOPT_0x2F
; 0000 037D PORT_CZYTNIK.bits.b2 = sprawdz_pin2(PORTHH,0x73);
	RCALL _sprawdz_pin2
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFB
	CALL SUBOPT_0x2F
; 0000 037E PORT_CZYTNIK.bits.b3 = sprawdz_pin3(PORTHH,0x73);
	RCALL _sprawdz_pin3
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0XF7
	CALL SUBOPT_0x2F
; 0000 037F PORT_CZYTNIK.bits.b4 = sprawdz_pin4(PORTHH,0x73);
	RCALL _sprawdz_pin4
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xEF
	CALL SUBOPT_0x2F
; 0000 0380 PORT_CZYTNIK.bits.b5 = sprawdz_pin5(PORTHH,0x73);
	RCALL _sprawdz_pin5
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xDF
	CALL SUBOPT_0x2F
; 0000 0381 PORT_CZYTNIK.bits.b6 = sprawdz_pin6(PORTHH,0x73);
	RCALL _sprawdz_pin6
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xBF
	CALL SUBOPT_0x2F
; 0000 0382 PORT_CZYTNIK.bits.b7 = sprawdz_pin7(PORTHH,0x73);
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
; 0000 0383 
; 0000 0384 rzad = odczytaj_parametr(32,128);       //20,80
	CALL SUBOPT_0x30
	CALL SUBOPT_0x18
	MOVW R16,R30
; 0000 0385 
; 0000 0386 if(PORT_CZYTNIK.byte == 0x01)
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1)
	BRNE _0x1D
; 0000 0387     {
; 0000 0388     macierz_zaciskow[rzad]=1;
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
; 0000 0389     komunikat_z_czytnika_kodow("86-0170",rzad,1);
	__POINTW1FN _0x0,178
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 038A     srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 038B     }
; 0000 038C 
; 0000 038D if(PORT_CZYTNIK.byte == 0x02)
_0x1D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2)
	BRNE _0x1E
; 0000 038E     {
; 0000 038F     macierz_zaciskow[rzad]=2;
	CALL SUBOPT_0x31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
; 0000 0390     komunikat_z_czytnika_kodow("86-1043",rzad,0);
	__POINTW1FN _0x0,186
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 0391     srednica_wew_korpusu = 34;
; 0000 0392     }
; 0000 0393 
; 0000 0394 if(PORT_CZYTNIK.byte == 0x03)
_0x1E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3)
	BRNE _0x1F
; 0000 0395     {
; 0000 0396       macierz_zaciskow[rzad]=3;
	CALL SUBOPT_0x31
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   X+,R30
	ST   X,R31
; 0000 0397       komunikat_z_czytnika_kodow("86-1675",rzad,0);
	__POINTW1FN _0x0,194
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 0398       srednica_wew_korpusu =38;
; 0000 0399     }
; 0000 039A 
; 0000 039B if(PORT_CZYTNIK.byte == 0x04)
_0x1F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4)
	BRNE _0x20
; 0000 039C     {
; 0000 039D 
; 0000 039E       macierz_zaciskow[rzad]=4;
	CALL SUBOPT_0x31
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   X+,R30
	ST   X,R31
; 0000 039F       komunikat_z_czytnika_kodow("86-2098",rzad,0);
	__POINTW1FN _0x0,202
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 03A0       srednica_wew_korpusu = 38;
; 0000 03A1     }
; 0000 03A2 if(PORT_CZYTNIK.byte == 0x05)
_0x20:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5)
	BRNE _0x21
; 0000 03A3     {
; 0000 03A4       macierz_zaciskow[rzad]=5;
	CALL SUBOPT_0x31
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   X+,R30
	ST   X,R31
; 0000 03A5       komunikat_z_czytnika_kodow("87-0170",rzad,0);
	__POINTW1FN _0x0,210
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 03A6       srednica_wew_korpusu = 38;
; 0000 03A7     }
; 0000 03A8 if(PORT_CZYTNIK.byte == 0x06)
_0x21:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6)
	BRNE _0x22
; 0000 03A9     {
; 0000 03AA       macierz_zaciskow[rzad]=6;
	CALL SUBOPT_0x31
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   X+,R30
	ST   X,R31
; 0000 03AB       komunikat_z_czytnika_kodow("87-1043",rzad,1);
	__POINTW1FN _0x0,218
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03AC       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 03AD     }
; 0000 03AE 
; 0000 03AF if(PORT_CZYTNIK.byte == 0x07)
_0x22:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7)
	BRNE _0x23
; 0000 03B0     {
; 0000 03B1       macierz_zaciskow[rzad]=7;
	CALL SUBOPT_0x31
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   X+,R30
	ST   X,R31
; 0000 03B2       komunikat_z_czytnika_kodow("87-1675",rzad,1);
	__POINTW1FN _0x0,226
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03B3       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 03B4     }
; 0000 03B5 
; 0000 03B6 if(PORT_CZYTNIK.byte == 0x08)
_0x23:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8)
	BRNE _0x24
; 0000 03B7     {
; 0000 03B8       macierz_zaciskow[rzad]=8;
	CALL SUBOPT_0x31
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   X+,R30
	ST   X,R31
; 0000 03B9       komunikat_z_czytnika_kodow("87-2098",rzad,1);
	__POINTW1FN _0x0,234
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03BA       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 03BB     }
; 0000 03BC if(PORT_CZYTNIK.byte == 0x09)
_0x24:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x9)
	BRNE _0x25
; 0000 03BD     {
; 0000 03BE       macierz_zaciskow[rzad]=9;
	CALL SUBOPT_0x31
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   X+,R30
	ST   X,R31
; 0000 03BF       komunikat_z_czytnika_kodow("86-0192",rzad,0);
	__POINTW1FN _0x0,242
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 03C0       srednica_wew_korpusu = 38;
; 0000 03C1     }
; 0000 03C2 if(PORT_CZYTNIK.byte == 0x0A)
_0x25:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xA)
	BRNE _0x26
; 0000 03C3     {
; 0000 03C4       macierz_zaciskow[rzad]=10;
	CALL SUBOPT_0x31
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   X+,R30
	ST   X,R31
; 0000 03C5       komunikat_z_czytnika_kodow("86-1054",rzad,0);
	__POINTW1FN _0x0,250
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 03C6       srednica_wew_korpusu = 41;
; 0000 03C7     }
; 0000 03C8 if(PORT_CZYTNIK.byte == 0x0B)
_0x26:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xB)
	BRNE _0x27
; 0000 03C9     {
; 0000 03CA       macierz_zaciskow[rzad]=11;
	CALL SUBOPT_0x31
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   X+,R30
	ST   X,R31
; 0000 03CB       komunikat_z_czytnika_kodow("86-1676",rzad,0);
	__POINTW1FN _0x0,258
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 03CC       srednica_wew_korpusu = 41;
; 0000 03CD     }
; 0000 03CE if(PORT_CZYTNIK.byte == 0x0C)
_0x27:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xC)
	BRNE _0x28
; 0000 03CF     {
; 0000 03D0       macierz_zaciskow[rzad]=12;
	CALL SUBOPT_0x31
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   X+,R30
	ST   X,R31
; 0000 03D1       komunikat_z_czytnika_kodow("86-2132",rzad,1);
	__POINTW1FN _0x0,266
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03D2       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 03D3     }
; 0000 03D4 if(PORT_CZYTNIK.byte == 0x0D)
_0x28:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xD)
	BRNE _0x29
; 0000 03D5     {
; 0000 03D6       macierz_zaciskow[rzad]=13;
	CALL SUBOPT_0x31
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   X+,R30
	ST   X,R31
; 0000 03D7       komunikat_z_czytnika_kodow("87-0192",rzad,1);
	__POINTW1FN _0x0,274
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03D8       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 03D9     }
; 0000 03DA if(PORT_CZYTNIK.byte == 0x0E)
_0x29:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xE)
	BRNE _0x2A
; 0000 03DB     {
; 0000 03DC       macierz_zaciskow[rzad]=14;
	CALL SUBOPT_0x31
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   X+,R30
	ST   X,R31
; 0000 03DD       komunikat_z_czytnika_kodow("87-1054",rzad,1);
	__POINTW1FN _0x0,282
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03DE       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 03DF     }
; 0000 03E0 
; 0000 03E1 if(PORT_CZYTNIK.byte == 0x0F)
_0x2A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xF)
	BRNE _0x2B
; 0000 03E2     {
; 0000 03E3       macierz_zaciskow[rzad]=15;
	CALL SUBOPT_0x31
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   X+,R30
	ST   X,R31
; 0000 03E4       komunikat_z_czytnika_kodow("87-1676",rzad,1);
	__POINTW1FN _0x0,290
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 03E5       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 03E6     }
; 0000 03E7 if(PORT_CZYTNIK.byte == 0x10)
_0x2B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x10)
	BRNE _0x2C
; 0000 03E8     {
; 0000 03E9       macierz_zaciskow[rzad]=16;
	CALL SUBOPT_0x31
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   X+,R30
	ST   X,R31
; 0000 03EA       komunikat_z_czytnika_kodow("87-2132",rzad,0);
	__POINTW1FN _0x0,298
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 03EB       srednica_wew_korpusu = 41;
; 0000 03EC     }
; 0000 03ED 
; 0000 03EE if(PORT_CZYTNIK.byte == 0x11)
_0x2C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x11)
	BRNE _0x2D
; 0000 03EF     {
; 0000 03F0       macierz_zaciskow[rzad]=17;
	CALL SUBOPT_0x31
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   X+,R30
	ST   X,R31
; 0000 03F1       komunikat_z_czytnika_kodow("86-0193",rzad,0);
	__POINTW1FN _0x0,306
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 03F2       srednica_wew_korpusu = 38;
; 0000 03F3     }
; 0000 03F4 
; 0000 03F5 if(PORT_CZYTNIK.byte == 0x12)
_0x2D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x12)
	BRNE _0x2E
; 0000 03F6     {
; 0000 03F7       macierz_zaciskow[rzad]=18;
	CALL SUBOPT_0x31
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	ST   X+,R30
	ST   X,R31
; 0000 03F8       komunikat_z_czytnika_kodow("86-1216",rzad,0);
	__POINTW1FN _0x0,314
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 03F9       srednica_wew_korpusu = 34;
; 0000 03FA     }
; 0000 03FB if(PORT_CZYTNIK.byte == 0x13)
_0x2E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x13)
	BRNE _0x2F
; 0000 03FC     {
; 0000 03FD       macierz_zaciskow[rzad]=19;
	CALL SUBOPT_0x31
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	ST   X+,R30
	ST   X,R31
; 0000 03FE       komunikat_z_czytnika_kodow("86-1832",rzad,0);
	__POINTW1FN _0x0,322
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 03FF       srednica_wew_korpusu = 41;
; 0000 0400     }
; 0000 0401 
; 0000 0402 if(PORT_CZYTNIK.byte == 0x14)
_0x2F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x14)
	BRNE _0x30
; 0000 0403     {
; 0000 0404       macierz_zaciskow[rzad]=20;
	CALL SUBOPT_0x31
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   X+,R30
	ST   X,R31
; 0000 0405       komunikat_z_czytnika_kodow("86-2174",rzad,0);
	__POINTW1FN _0x0,330
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 0406       srednica_wew_korpusu = 34;
; 0000 0407     }
; 0000 0408 if(PORT_CZYTNIK.byte == 0x15)
_0x30:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x15)
	BRNE _0x31
; 0000 0409     {
; 0000 040A       macierz_zaciskow[rzad]=21;
	CALL SUBOPT_0x31
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	ST   X+,R30
	ST   X,R31
; 0000 040B       komunikat_z_czytnika_kodow("87-0193",rzad,1);
	__POINTW1FN _0x0,338
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 040C       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 040D     }
; 0000 040E 
; 0000 040F if(PORT_CZYTNIK.byte == 0x16)
_0x31:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x16)
	BRNE _0x32
; 0000 0410     {
; 0000 0411       macierz_zaciskow[rzad]=22;
	CALL SUBOPT_0x31
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	ST   X+,R30
	ST   X,R31
; 0000 0412       komunikat_z_czytnika_kodow("87-1216",rzad,1);
	__POINTW1FN _0x0,346
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0413       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 0414     }
; 0000 0415 if(PORT_CZYTNIK.byte == 0x17)
_0x32:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x17)
	BRNE _0x33
; 0000 0416     {
; 0000 0417       macierz_zaciskow[rzad]=23;
	CALL SUBOPT_0x31
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	ST   X+,R30
	ST   X,R31
; 0000 0418       komunikat_z_czytnika_kodow("87-1832",rzad,1);
	__POINTW1FN _0x0,354
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0419       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 041A     }
; 0000 041B 
; 0000 041C if(PORT_CZYTNIK.byte == 0x18)
_0x33:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x18)
	BRNE _0x34
; 0000 041D     {
; 0000 041E       macierz_zaciskow[rzad]=24;
	CALL SUBOPT_0x31
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	ST   X+,R30
	ST   X,R31
; 0000 041F       komunikat_z_czytnika_kodow("87-2174",rzad,1);
	__POINTW1FN _0x0,362
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0420       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 0421     }
; 0000 0422 if(PORT_CZYTNIK.byte == 0x19)
_0x34:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x19)
	BRNE _0x35
; 0000 0423     {
; 0000 0424       macierz_zaciskow[rzad]=25;
	CALL SUBOPT_0x31
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	ST   X+,R30
	ST   X,R31
; 0000 0425       komunikat_z_czytnika_kodow("86-0194",rzad,0);
	__POINTW1FN _0x0,370
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 0426       srednica_wew_korpusu = 41;
; 0000 0427     }
; 0000 0428 
; 0000 0429 if(PORT_CZYTNIK.byte == 0x1A)
_0x35:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1A)
	BRNE _0x36
; 0000 042A     {
; 0000 042B       macierz_zaciskow[rzad]=26;
	CALL SUBOPT_0x31
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	ST   X+,R30
	ST   X,R31
; 0000 042C       komunikat_z_czytnika_kodow("86-1341",rzad,0);
	__POINTW1FN _0x0,378
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 042D       srednica_wew_korpusu = 34;
; 0000 042E     }
; 0000 042F if(PORT_CZYTNIK.byte == 0x1B)
_0x36:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1B)
	BRNE _0x37
; 0000 0430     {
; 0000 0431       macierz_zaciskow[rzad]=27;
	CALL SUBOPT_0x31
	LDI  R30,LOW(27)
	LDI  R31,HIGH(27)
	ST   X+,R30
	ST   X,R31
; 0000 0432       komunikat_z_czytnika_kodow("86-1833",rzad,0);
	__POINTW1FN _0x0,386
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 0433       srednica_wew_korpusu = 41;
; 0000 0434     }
; 0000 0435 if(PORT_CZYTNIK.byte == 0x1C)
_0x37:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1C)
	BRNE _0x38
; 0000 0436     {
; 0000 0437       macierz_zaciskow[rzad]=28;
	CALL SUBOPT_0x31
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	ST   X+,R30
	ST   X,R31
; 0000 0438       komunikat_z_czytnika_kodow("86-2180",rzad,1);
	__POINTW1FN _0x0,394
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0439       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 043A     }
; 0000 043B if(PORT_CZYTNIK.byte == 0x1D)
_0x38:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1D)
	BRNE _0x39
; 0000 043C     {
; 0000 043D       macierz_zaciskow[rzad]=29;
	CALL SUBOPT_0x31
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	ST   X+,R30
	ST   X,R31
; 0000 043E       komunikat_z_czytnika_kodow("87-0194",rzad,1);
	__POINTW1FN _0x0,402
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 043F       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 0440     }
; 0000 0441 
; 0000 0442 if(PORT_CZYTNIK.byte == 0x1E)
_0x39:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1E)
	BRNE _0x3A
; 0000 0443     {
; 0000 0444       macierz_zaciskow[rzad]=30;
	CALL SUBOPT_0x31
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   X+,R30
	ST   X,R31
; 0000 0445       komunikat_z_czytnika_kodow("87-1341",rzad,1);
	__POINTW1FN _0x0,410
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0446       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 0447     }
; 0000 0448 if(PORT_CZYTNIK.byte == 0x1F)
_0x3A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1F)
	BRNE _0x3B
; 0000 0449     {
; 0000 044A       macierz_zaciskow[rzad]=31;
	CALL SUBOPT_0x31
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	ST   X+,R30
	ST   X,R31
; 0000 044B       komunikat_z_czytnika_kodow("87-1833",rzad,1);
	__POINTW1FN _0x0,418
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 044C       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 044D     }
; 0000 044E 
; 0000 044F if(PORT_CZYTNIK.byte == 0x20)
_0x3B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x20)
	BRNE _0x3C
; 0000 0450     {
; 0000 0451       macierz_zaciskow[rzad]=32;
	CALL SUBOPT_0x31
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   X+,R30
	ST   X,R31
; 0000 0452       komunikat_z_czytnika_kodow("87-2180",rzad,0);
	__POINTW1FN _0x0,426
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 0453       srednica_wew_korpusu = 41;
; 0000 0454     }
; 0000 0455 if(PORT_CZYTNIK.byte == 0x21)
_0x3C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x21)
	BRNE _0x3D
; 0000 0456     {
; 0000 0457       macierz_zaciskow[rzad]=33;
	CALL SUBOPT_0x31
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	ST   X+,R30
	ST   X,R31
; 0000 0458       komunikat_z_czytnika_kodow("86-0663",rzad,1);
	__POINTW1FN _0x0,434
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0459       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x3B
; 0000 045A     }
; 0000 045B 
; 0000 045C if(PORT_CZYTNIK.byte == 0x22)
_0x3D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x22)
	BRNE _0x3E
; 0000 045D     {
; 0000 045E       macierz_zaciskow[rzad]=34;
	CALL SUBOPT_0x31
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	ST   X+,R30
	ST   X,R31
; 0000 045F       komunikat_z_czytnika_kodow("86-1349",rzad,0);
	__POINTW1FN _0x0,442
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 0460       srednica_wew_korpusu = 38;
; 0000 0461     }
; 0000 0462 if(PORT_CZYTNIK.byte == 0x23)
_0x3E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x23)
	BRNE _0x3F
; 0000 0463     {
; 0000 0464       macierz_zaciskow[rzad]=35;
	CALL SUBOPT_0x31
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	ST   X+,R30
	ST   X,R31
; 0000 0465       komunikat_z_czytnika_kodow("86-1834",rzad,0);
	__POINTW1FN _0x0,450
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 0466       srednica_wew_korpusu = 34;
; 0000 0467     }
; 0000 0468 if(PORT_CZYTNIK.byte == 0x24)
_0x3F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x24)
	BRNE _0x40
; 0000 0469     {
; 0000 046A       macierz_zaciskow[rzad]=36;
	CALL SUBOPT_0x31
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	ST   X+,R30
	ST   X,R31
; 0000 046B       komunikat_z_czytnika_kodow("86-2204",rzad,0);
	__POINTW1FN _0x0,458
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 046C       srednica_wew_korpusu = 38;
; 0000 046D     }
; 0000 046E if(PORT_CZYTNIK.byte == 0x25)
_0x40:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x25)
	BRNE _0x41
; 0000 046F     {
; 0000 0470       macierz_zaciskow[rzad]=37;
	CALL SUBOPT_0x31
	LDI  R30,LOW(37)
	LDI  R31,HIGH(37)
	ST   X+,R30
	ST   X,R31
; 0000 0471       komunikat_z_czytnika_kodow("87-0663",rzad,0);
	__POINTW1FN _0x0,466
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3C
; 0000 0472       srednica_wew_korpusu = 43;
; 0000 0473     }
; 0000 0474 if(PORT_CZYTNIK.byte == 0x26)
_0x41:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x26)
	BRNE _0x42
; 0000 0475     {
; 0000 0476       macierz_zaciskow[rzad]=38;
	CALL SUBOPT_0x31
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	ST   X+,R30
	ST   X,R31
; 0000 0477       komunikat_z_czytnika_kodow("87-1349",rzad,1);
	__POINTW1FN _0x0,474
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0478       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 0479     }
; 0000 047A if(PORT_CZYTNIK.byte == 0x27)
_0x42:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x27)
	BRNE _0x43
; 0000 047B     {
; 0000 047C       macierz_zaciskow[rzad]=39;
	CALL SUBOPT_0x31
	LDI  R30,LOW(39)
	LDI  R31,HIGH(39)
	ST   X+,R30
	ST   X,R31
; 0000 047D       komunikat_z_czytnika_kodow("87-1834",rzad,1);
	__POINTW1FN _0x0,482
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 047E       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 047F     }
; 0000 0480 if(PORT_CZYTNIK.byte == 0x28)
_0x43:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x28)
	BRNE _0x44
; 0000 0481     {
; 0000 0482       macierz_zaciskow[rzad]=40;
	CALL SUBOPT_0x31
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   X+,R30
	ST   X,R31
; 0000 0483       komunikat_z_czytnika_kodow("87-2204",rzad,1);
	__POINTW1FN _0x0,490
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0484       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 0485     }
; 0000 0486 if(PORT_CZYTNIK.byte == 0x29)
_0x44:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x29)
	BRNE _0x45
; 0000 0487     {
; 0000 0488       macierz_zaciskow[rzad]=41;
	CALL SUBOPT_0x31
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	ST   X+,R30
	ST   X,R31
; 0000 0489       komunikat_z_czytnika_kodow("86-0768",rzad,1);
	__POINTW1FN _0x0,498
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 048A       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 048B     }
; 0000 048C if(PORT_CZYTNIK.byte == 0x2A)
_0x45:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2A)
	BRNE _0x46
; 0000 048D     {
; 0000 048E       macierz_zaciskow[rzad]=42;
	CALL SUBOPT_0x31
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   X+,R30
	ST   X,R31
; 0000 048F       komunikat_z_czytnika_kodow("86-1357",rzad,0);
	__POINTW1FN _0x0,506
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 0490       srednica_wew_korpusu = 38;
; 0000 0491     }
; 0000 0492 if(PORT_CZYTNIK.byte == 0x2B)
_0x46:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2B)
	BRNE _0x47
; 0000 0493     {
; 0000 0494       macierz_zaciskow[rzad]=43;
	CALL SUBOPT_0x31
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	ST   X+,R30
	ST   X,R31
; 0000 0495       komunikat_z_czytnika_kodow("86-1848",rzad,0);
	__POINTW1FN _0x0,514
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 0496       srednica_wew_korpusu = 38;
; 0000 0497     }
; 0000 0498 if(PORT_CZYTNIK.byte == 0x2C)
_0x47:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2C)
	BRNE _0x48
; 0000 0499     {
; 0000 049A      macierz_zaciskow[rzad]=44;
	CALL SUBOPT_0x31
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x3D
; 0000 049B       macierz_zaciskow[rzad]=0;   ////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x3E
; 0000 049C 
; 0000 049D      komunikat_z_czytnika_kodow("86-2212",rzad,0);
	__POINTW1FN _0x0,522
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 049E      srednica_wew_korpusu = 38;
; 0000 049F     }
; 0000 04A0 if(PORT_CZYTNIK.byte == 0x2D)
_0x48:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2D)
	BRNE _0x49
; 0000 04A1     {
; 0000 04A2       macierz_zaciskow[rzad]=45;
	CALL SUBOPT_0x31
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	ST   X+,R30
	ST   X,R31
; 0000 04A3       komunikat_z_czytnika_kodow("87-0768",rzad,0);
	__POINTW1FN _0x0,530
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 04A4       srednica_wew_korpusu = 38;
; 0000 04A5     }
; 0000 04A6 if(PORT_CZYTNIK.byte == 0x2E)
_0x49:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2E)
	BRNE _0x4A
; 0000 04A7     {
; 0000 04A8       macierz_zaciskow[rzad]=46;
	CALL SUBOPT_0x31
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	ST   X+,R30
	ST   X,R31
; 0000 04A9       komunikat_z_czytnika_kodow("87-1357",rzad,1);
	__POINTW1FN _0x0,538
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04AA       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 04AB     }
; 0000 04AC if(PORT_CZYTNIK.byte == 0x2F)
_0x4A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2F)
	BRNE _0x4B
; 0000 04AD     {
; 0000 04AE       macierz_zaciskow[rzad]=47;
	CALL SUBOPT_0x31
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	ST   X+,R30
	ST   X,R31
; 0000 04AF       komunikat_z_czytnika_kodow("87-1848",rzad,1);
	__POINTW1FN _0x0,546
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04B0       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 04B1     }
; 0000 04B2 if(PORT_CZYTNIK.byte == 0x30)
_0x4B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x30)
	BRNE _0x4C
; 0000 04B3     {
; 0000 04B4       macierz_zaciskow[rzad]=48;
	CALL SUBOPT_0x31
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x3D
; 0000 04B5       macierz_zaciskow[rzad]=0;    /////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x3E
; 0000 04B6       komunikat_z_czytnika_kodow("87-2212",rzad,1);
	__POINTW1FN _0x0,554
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04B7       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 04B8     }
; 0000 04B9 if(PORT_CZYTNIK.byte == 0x31)
_0x4C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x31)
	BRNE _0x4D
; 0000 04BA     {
; 0000 04BB       macierz_zaciskow[rzad]=49;
	CALL SUBOPT_0x31
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	ST   X+,R30
	ST   X,R31
; 0000 04BC       komunikat_z_czytnika_kodow("86-0800",rzad,0);
	__POINTW1FN _0x0,562
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 04BD       srednica_wew_korpusu = 38;
; 0000 04BE     }
; 0000 04BF if(PORT_CZYTNIK.byte == 0x32)
_0x4D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x32)
	BRNE _0x4E
; 0000 04C0     {
; 0000 04C1       macierz_zaciskow[rzad]=50;
	CALL SUBOPT_0x31
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   X+,R30
	ST   X,R31
; 0000 04C2       komunikat_z_czytnika_kodow("86-1363",rzad,0);
	__POINTW1FN _0x0,570
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 04C3       srednica_wew_korpusu = 34;
; 0000 04C4     }
; 0000 04C5 if(PORT_CZYTNIK.byte == 0x33)
_0x4E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x33)
	BRNE _0x4F
; 0000 04C6     {
; 0000 04C7       macierz_zaciskow[rzad]=51;
	CALL SUBOPT_0x31
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	ST   X+,R30
	ST   X,R31
; 0000 04C8       komunikat_z_czytnika_kodow("86-1904",rzad,0);
	__POINTW1FN _0x0,578
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3C
; 0000 04C9       srednica_wew_korpusu = 43;
; 0000 04CA     }
; 0000 04CB if(PORT_CZYTNIK.byte == 0x34)
_0x4F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x34)
	BRNE _0x50
; 0000 04CC     {
; 0000 04CD       macierz_zaciskow[rzad]=52;
	CALL SUBOPT_0x31
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	ST   X+,R30
	ST   X,R31
; 0000 04CE       komunikat_z_czytnika_kodow("86-2241",rzad,1);
	__POINTW1FN _0x0,586
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04CF       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 04D0     }
; 0000 04D1 if(PORT_CZYTNIK.byte == 0x35)
_0x50:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x35)
	BRNE _0x51
; 0000 04D2     {
; 0000 04D3       macierz_zaciskow[rzad]=53;
	CALL SUBOPT_0x31
	LDI  R30,LOW(53)
	LDI  R31,HIGH(53)
	ST   X+,R30
	ST   X,R31
; 0000 04D4       komunikat_z_czytnika_kodow("87-0800",rzad,1);
	__POINTW1FN _0x0,594
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04D5       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 04D6     }
; 0000 04D7 
; 0000 04D8 if(PORT_CZYTNIK.byte == 0x36)
_0x51:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x36)
	BRNE _0x52
; 0000 04D9     {
; 0000 04DA       macierz_zaciskow[rzad]=54;
	CALL SUBOPT_0x31
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	ST   X+,R30
	ST   X,R31
; 0000 04DB       komunikat_z_czytnika_kodow("87-1363",rzad,1);
	__POINTW1FN _0x0,602
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04DC       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 04DD     }
; 0000 04DE if(PORT_CZYTNIK.byte == 0x37)
_0x52:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x37)
	BRNE _0x53
; 0000 04DF     {
; 0000 04E0       macierz_zaciskow[rzad]=55;
	CALL SUBOPT_0x31
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	ST   X+,R30
	ST   X,R31
; 0000 04E1       komunikat_z_czytnika_kodow("87-1904",rzad,1);
	__POINTW1FN _0x0,610
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 04E2       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x3B
; 0000 04E3     }
; 0000 04E4 if(PORT_CZYTNIK.byte == 0x38)
_0x53:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x38)
	BRNE _0x54
; 0000 04E5     {
; 0000 04E6       macierz_zaciskow[rzad]=56;
	CALL SUBOPT_0x31
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	ST   X+,R30
	ST   X,R31
; 0000 04E7       komunikat_z_czytnika_kodow("87-2241",rzad,0);
	__POINTW1FN _0x0,618
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 04E8       srednica_wew_korpusu = 34;
; 0000 04E9     }
; 0000 04EA if(PORT_CZYTNIK.byte == 0x39)
_0x54:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x39)
	BRNE _0x55
; 0000 04EB     {
; 0000 04EC       macierz_zaciskow[rzad]=57;
	CALL SUBOPT_0x31
	LDI  R30,LOW(57)
	LDI  R31,HIGH(57)
	ST   X+,R30
	ST   X,R31
; 0000 04ED       komunikat_z_czytnika_kodow("86-0811",rzad,0);
	__POINTW1FN _0x0,626
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 04EE       srednica_wew_korpusu = 34;
; 0000 04EF     }
; 0000 04F0 if(PORT_CZYTNIK.byte == 0x3A)
_0x55:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3A)
	BRNE _0x56
; 0000 04F1     {
; 0000 04F2       macierz_zaciskow[rzad]=58;
	CALL SUBOPT_0x31
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	ST   X+,R30
	ST   X,R31
; 0000 04F3       komunikat_z_czytnika_kodow("86-1523",rzad,0);
	__POINTW1FN _0x0,634
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 04F4       srednica_wew_korpusu = 38;
; 0000 04F5     }
; 0000 04F6 if(PORT_CZYTNIK.byte == 0x3B)
_0x56:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3B)
	BRNE _0x57
; 0000 04F7     {
; 0000 04F8       macierz_zaciskow[rzad]=59;
	CALL SUBOPT_0x31
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	ST   X+,R30
	ST   X,R31
; 0000 04F9       komunikat_z_czytnika_kodow("86-1929",rzad,0);
	__POINTW1FN _0x0,642
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 04FA       srednica_wew_korpusu = 41;
; 0000 04FB     }
; 0000 04FC if(PORT_CZYTNIK.byte == 0x3C)
_0x57:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3C)
	BRNE _0x58
; 0000 04FD     {
; 0000 04FE       macierz_zaciskow[rzad]=60;
	CALL SUBOPT_0x31
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	ST   X+,R30
	ST   X,R31
; 0000 04FF       komunikat_z_czytnika_kodow("86-2261",rzad,0);
	__POINTW1FN _0x0,650
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 0500       srednica_wew_korpusu = 34;
; 0000 0501     }
; 0000 0502 if(PORT_CZYTNIK.byte == 0x3D)
_0x58:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3D)
	BRNE _0x59
; 0000 0503     {
; 0000 0504       macierz_zaciskow[rzad]=61;
	CALL SUBOPT_0x31
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	ST   X+,R30
	ST   X,R31
; 0000 0505       komunikat_z_czytnika_kodow("87-0811",rzad,1);
	__POINTW1FN _0x0,658
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0506       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 0507     }
; 0000 0508 if(PORT_CZYTNIK.byte == 0x3E)
_0x59:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3E)
	BRNE _0x5A
; 0000 0509     {
; 0000 050A       macierz_zaciskow[rzad]=62;
	CALL SUBOPT_0x31
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	ST   X+,R30
	ST   X,R31
; 0000 050B       komunikat_z_czytnika_kodow("87-1523",rzad,1);
	__POINTW1FN _0x0,666
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 050C       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 050D     }
; 0000 050E if(PORT_CZYTNIK.byte == 0x3F)
_0x5A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3F)
	BRNE _0x5B
; 0000 050F     {
; 0000 0510       macierz_zaciskow[rzad]=63;
	CALL SUBOPT_0x31
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	ST   X+,R30
	ST   X,R31
; 0000 0511       komunikat_z_czytnika_kodow("87-1929",rzad,1);
	__POINTW1FN _0x0,674
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0512       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 0513     }
; 0000 0514 if(PORT_CZYTNIK.byte == 0x40)
_0x5B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x40)
	BRNE _0x5C
; 0000 0515     {
; 0000 0516       macierz_zaciskow[rzad]=64;
	CALL SUBOPT_0x31
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   X+,R30
	ST   X,R31
; 0000 0517       komunikat_z_czytnika_kodow("87-2261",rzad,1);
	__POINTW1FN _0x0,682
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0518       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 0519     }
; 0000 051A if(PORT_CZYTNIK.byte == 0x41)
_0x5C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x41)
	BRNE _0x5D
; 0000 051B     {
; 0000 051C       macierz_zaciskow[rzad]=65;
	CALL SUBOPT_0x31
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   X+,R30
	ST   X,R31
; 0000 051D       komunikat_z_czytnika_kodow("86-0814",rzad,0);
	__POINTW1FN _0x0,690
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3F
; 0000 051E       srednica_wew_korpusu = 36;
; 0000 051F     }
; 0000 0520 if(PORT_CZYTNIK.byte == 0x42)
_0x5D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x42)
	BRNE _0x5E
; 0000 0521     {
; 0000 0522       macierz_zaciskow[rzad]=66;
	CALL SUBOPT_0x31
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	ST   X+,R30
	ST   X,R31
; 0000 0523       komunikat_z_czytnika_kodow("86-1530",rzad,1);
	__POINTW1FN _0x0,698
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0524       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 0525     }
; 0000 0526 if(PORT_CZYTNIK.byte == 0x43)
_0x5E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x43)
	BRNE _0x5F
; 0000 0527     {
; 0000 0528       macierz_zaciskow[rzad]=67;
	CALL SUBOPT_0x31
	LDI  R30,LOW(67)
	LDI  R31,HIGH(67)
	ST   X+,R30
	ST   X,R31
; 0000 0529       komunikat_z_czytnika_kodow("86-1936",rzad,1);
	__POINTW1FN _0x0,706
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 052A       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 052B     }
; 0000 052C if(PORT_CZYTNIK.byte == 0x44)
_0x5F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x44)
	BRNE _0x60
; 0000 052D     {
; 0000 052E       macierz_zaciskow[rzad]=68;
	CALL SUBOPT_0x31
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   X+,R30
	ST   X,R31
; 0000 052F       komunikat_z_czytnika_kodow("86-2285",rzad,1);
	__POINTW1FN _0x0,714
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0530       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 0531     }
; 0000 0532 if(PORT_CZYTNIK.byte == 0x45)
_0x60:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x45)
	BRNE _0x61
; 0000 0533     {
; 0000 0534       macierz_zaciskow[rzad]=69;
	CALL SUBOPT_0x31
	LDI  R30,LOW(69)
	LDI  R31,HIGH(69)
	ST   X+,R30
	ST   X,R31
; 0000 0535       komunikat_z_czytnika_kodow("87-0814",rzad,1);
	__POINTW1FN _0x0,722
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0536       srednica_wew_korpusu = 36;
	CALL SUBOPT_0x40
; 0000 0537     }
; 0000 0538 if(PORT_CZYTNIK.byte == 0x46)
_0x61:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x46)
	BRNE _0x62
; 0000 0539     {
; 0000 053A       macierz_zaciskow[rzad]=70;
	CALL SUBOPT_0x31
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   X+,R30
	ST   X,R31
; 0000 053B       komunikat_z_czytnika_kodow("87-1530",rzad,0);
	__POINTW1FN _0x0,730
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 053C       srednica_wew_korpusu = 38;
; 0000 053D     }
; 0000 053E if(PORT_CZYTNIK.byte == 0x47)
_0x62:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x47)
	BRNE _0x63
; 0000 053F     {
; 0000 0540       macierz_zaciskow[rzad]=71;
	CALL SUBOPT_0x31
	LDI  R30,LOW(71)
	LDI  R31,HIGH(71)
	ST   X+,R30
	ST   X,R31
; 0000 0541       komunikat_z_czytnika_kodow("87-1936",rzad,0);
	__POINTW1FN _0x0,738
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 0542       srednica_wew_korpusu = 38;
; 0000 0543     }
; 0000 0544 if(PORT_CZYTNIK.byte == 0x48)
_0x63:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x48)
	BRNE _0x64
; 0000 0545     {
; 0000 0546       macierz_zaciskow[rzad]=72;
	CALL SUBOPT_0x31
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	ST   X+,R30
	ST   X,R31
; 0000 0547       komunikat_z_czytnika_kodow("87-2285",rzad,0);
	__POINTW1FN _0x0,746
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 0548       srednica_wew_korpusu = 41;
; 0000 0549     }
; 0000 054A if(PORT_CZYTNIK.byte == 0x49)
_0x64:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x49)
	BRNE _0x65
; 0000 054B     {
; 0000 054C       macierz_zaciskow[rzad]=73;
	CALL SUBOPT_0x31
	LDI  R30,LOW(73)
	LDI  R31,HIGH(73)
	ST   X+,R30
	ST   X,R31
; 0000 054D       komunikat_z_czytnika_kodow("86-0815",rzad,0);
	__POINTW1FN _0x0,754
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 054E       srednica_wew_korpusu = 38;
; 0000 054F     }
; 0000 0550 
; 0000 0551 if(PORT_CZYTNIK.byte == 0x4A)
_0x65:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4A)
	BRNE _0x66
; 0000 0552     {
; 0000 0553       macierz_zaciskow[rzad]=74;
	CALL SUBOPT_0x31
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	ST   X+,R30
	ST   X,R31
; 0000 0554       komunikat_z_czytnika_kodow("86-1551",rzad,0);
	__POINTW1FN _0x0,762
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 0555       srednica_wew_korpusu = 38;
; 0000 0556     }
; 0000 0557 if(PORT_CZYTNIK.byte == 0x4B)
_0x66:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4B)
	BRNE _0x67
; 0000 0558     {
; 0000 0559       macierz_zaciskow[rzad]=75;
	CALL SUBOPT_0x31
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	ST   X+,R30
	ST   X,R31
; 0000 055A       komunikat_z_czytnika_kodow("86-1941",rzad,0);
	__POINTW1FN _0x0,770
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 055B       srednica_wew_korpusu = 38;
; 0000 055C     }
; 0000 055D if(PORT_CZYTNIK.byte == 0x4C)
_0x67:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4C)
	BRNE _0x68
; 0000 055E     {
; 0000 055F       macierz_zaciskow[rzad]=76;
	CALL SUBOPT_0x31
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x3D
; 0000 0560       macierz_zaciskow[rzad]=0;    ////////////////////////////////brak zacisku
	CALL SUBOPT_0x3E
; 0000 0561       komunikat_z_czytnika_kodow("86-2286",rzad,0);
	__POINTW1FN _0x0,778
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 0562       srednica_wew_korpusu = 41;
; 0000 0563     }
; 0000 0564 if(PORT_CZYTNIK.byte == 0x4D)
_0x68:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4D)
	BRNE _0x69
; 0000 0565     {
; 0000 0566       macierz_zaciskow[rzad]=77;
	CALL SUBOPT_0x31
	LDI  R30,LOW(77)
	LDI  R31,HIGH(77)
	ST   X+,R30
	ST   X,R31
; 0000 0567       komunikat_z_czytnika_kodow("87-0815",rzad,1);
	__POINTW1FN _0x0,786
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0568       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 0569     }
; 0000 056A if(PORT_CZYTNIK.byte == 0x4E)
_0x69:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4E)
	BRNE _0x6A
; 0000 056B     {
; 0000 056C       macierz_zaciskow[rzad]=78;
	CALL SUBOPT_0x31
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	ST   X+,R30
	ST   X,R31
; 0000 056D       komunikat_z_czytnika_kodow("87-1551",rzad,1);
	__POINTW1FN _0x0,794
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 056E       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 056F     }
; 0000 0570 if(PORT_CZYTNIK.byte == 0x4F)
_0x6A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4F)
	BRNE _0x6B
; 0000 0571     {
; 0000 0572       macierz_zaciskow[rzad]=79;
	CALL SUBOPT_0x31
	LDI  R30,LOW(79)
	LDI  R31,HIGH(79)
	ST   X+,R30
	ST   X,R31
; 0000 0573       komunikat_z_czytnika_kodow("87-1941",rzad,1);
	__POINTW1FN _0x0,802
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0574       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 0575     }
; 0000 0576 if(PORT_CZYTNIK.byte == 0x50)
_0x6B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x50)
	BRNE _0x6C
; 0000 0577     {
; 0000 0578       macierz_zaciskow[rzad]=80;
	CALL SUBOPT_0x31
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x3D
; 0000 0579       macierz_zaciskow[rzad]=0;  ////////////////////////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x3E
; 0000 057A       komunikat_z_czytnika_kodow("87-2286",rzad,0);
	__POINTW1FN _0x0,810
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 057B       srednica_wew_korpusu = 41;
; 0000 057C     }
; 0000 057D if(PORT_CZYTNIK.byte == 0x51)
_0x6C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x51)
	BRNE _0x6D
; 0000 057E     {
; 0000 057F       macierz_zaciskow[rzad]=81;
	CALL SUBOPT_0x31
	LDI  R30,LOW(81)
	LDI  R31,HIGH(81)
	ST   X+,R30
	ST   X,R31
; 0000 0580       komunikat_z_czytnika_kodow("86-0816",rzad,0);
	__POINTW1FN _0x0,818
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3F
; 0000 0581       srednica_wew_korpusu = 36;
; 0000 0582     }
; 0000 0583 if(PORT_CZYTNIK.byte == 0x52)
_0x6D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x52)
	BRNE _0x6E
; 0000 0584     {
; 0000 0585       macierz_zaciskow[rzad]=82;
	CALL SUBOPT_0x31
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	ST   X+,R30
	ST   X,R31
; 0000 0586       komunikat_z_czytnika_kodow("86-1552",rzad,0);
	__POINTW1FN _0x0,826
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 0587       srednica_wew_korpusu = 34;
; 0000 0588     }
; 0000 0589 if(PORT_CZYTNIK.byte == 0x53)
_0x6E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x53)
	BRNE _0x6F
; 0000 058A     {
; 0000 058B       macierz_zaciskow[rzad]=83;
	CALL SUBOPT_0x31
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	ST   X+,R30
	ST   X,R31
; 0000 058C       komunikat_z_czytnika_kodow("86-2007",rzad,1);
	__POINTW1FN _0x0,834
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 058D       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 058E     }
; 0000 058F if(PORT_CZYTNIK.byte == 0x54)
_0x6F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x54)
	BRNE _0x70
; 0000 0590     {
; 0000 0591       macierz_zaciskow[rzad]=84;
	CALL SUBOPT_0x31
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	ST   X+,R30
	ST   X,R31
; 0000 0592       komunikat_z_czytnika_kodow("86-2292",rzad,1);
	__POINTW1FN _0x0,842
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0593       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 0594     }
; 0000 0595 if(PORT_CZYTNIK.byte == 0x55)
_0x70:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x55)
	BRNE _0x71
; 0000 0596     {
; 0000 0597       macierz_zaciskow[rzad]=85;
	CALL SUBOPT_0x31
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	ST   X+,R30
	ST   X,R31
; 0000 0598       komunikat_z_czytnika_kodow("87-0816",rzad,1);
	__POINTW1FN _0x0,850
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0599       srednica_wew_korpusu = 36;
	CALL SUBOPT_0x40
; 0000 059A      }
; 0000 059B if(PORT_CZYTNIK.byte == 0x56)
_0x71:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x56)
	BRNE _0x72
; 0000 059C     {
; 0000 059D       macierz_zaciskow[rzad]=86;
	CALL SUBOPT_0x31
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	ST   X+,R30
	ST   X,R31
; 0000 059E       komunikat_z_czytnika_kodow("87-1552",rzad,1);
	__POINTW1FN _0x0,858
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 059F       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 05A0     }
; 0000 05A1 if(PORT_CZYTNIK.byte == 0x57)
_0x72:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x57)
	BRNE _0x73
; 0000 05A2     {
; 0000 05A3       macierz_zaciskow[rzad]=87;
	CALL SUBOPT_0x31
	LDI  R30,LOW(87)
	LDI  R31,HIGH(87)
	ST   X+,R30
	ST   X,R31
; 0000 05A4       komunikat_z_czytnika_kodow("87-2007",rzad,0);
	__POINTW1FN _0x0,866
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 05A5       srednica_wew_korpusu = 41;
; 0000 05A6     }
; 0000 05A7 if(PORT_CZYTNIK.byte == 0x58)
_0x73:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x58)
	BRNE _0x74
; 0000 05A8     {
; 0000 05A9       macierz_zaciskow[rzad]=88;
	CALL SUBOPT_0x31
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	ST   X+,R30
	ST   X,R31
; 0000 05AA       komunikat_z_czytnika_kodow("87-2292",rzad,0);
	__POINTW1FN _0x0,874
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 05AB       srednica_wew_korpusu = 38;
; 0000 05AC     }
; 0000 05AD if(PORT_CZYTNIK.byte == 0x59)
_0x74:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x59)
	BRNE _0x75
; 0000 05AE     {
; 0000 05AF       macierz_zaciskow[rzad]=89;
	CALL SUBOPT_0x31
	LDI  R30,LOW(89)
	LDI  R31,HIGH(89)
	ST   X+,R30
	ST   X,R31
; 0000 05B0       komunikat_z_czytnika_kodow("86-0817",rzad,0);
	__POINTW1FN _0x0,882
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 05B1       srednica_wew_korpusu = 38;
; 0000 05B2     }
; 0000 05B3 if(PORT_CZYTNIK.byte == 0x5A)
_0x75:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5A)
	BRNE _0x76
; 0000 05B4     {
; 0000 05B5       macierz_zaciskow[rzad]=90;
	CALL SUBOPT_0x31
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   X+,R30
	ST   X,R31
; 0000 05B6       komunikat_z_czytnika_kodow("86-1602",rzad,1);
	__POINTW1FN _0x0,890
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 05B7       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 05B8     }
; 0000 05B9 if(PORT_CZYTNIK.byte == 0x5B)
_0x76:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5B)
	BRNE _0x77
; 0000 05BA     {
; 0000 05BB       macierz_zaciskow[rzad]=91;
	CALL SUBOPT_0x31
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	ST   X+,R30
	ST   X,R31
; 0000 05BC       komunikat_z_czytnika_kodow("86-2017",rzad,1);
	__POINTW1FN _0x0,898
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 05BD       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 05BE     }
; 0000 05BF if(PORT_CZYTNIK.byte == 0x5C)
_0x77:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5C)
	BRNE _0x78
; 0000 05C0     {
; 0000 05C1       macierz_zaciskow[rzad]=92;
	CALL SUBOPT_0x31
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x3D
; 0000 05C2       macierz_zaciskow[rzad]=0;           /////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x3E
; 0000 05C3       komunikat_z_czytnika_kodow("86-2384",rzad,0);
	__POINTW1FN _0x0,906
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 05C4       srednica_wew_korpusu = 38;
; 0000 05C5     }
; 0000 05C6 if(PORT_CZYTNIK.byte == 0x5D)
_0x78:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5D)
	BRNE _0x79
; 0000 05C7     {
; 0000 05C8       macierz_zaciskow[rzad]=93;
	CALL SUBOPT_0x31
	LDI  R30,LOW(93)
	LDI  R31,HIGH(93)
	ST   X+,R30
	ST   X,R31
; 0000 05C9       komunikat_z_czytnika_kodow("87-0817",rzad,1);
	__POINTW1FN _0x0,914
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 05CA       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 05CB     }
; 0000 05CC if(PORT_CZYTNIK.byte == 0x5E)
_0x79:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5E)
	BRNE _0x7A
; 0000 05CD     {
; 0000 05CE       macierz_zaciskow[rzad]=94;
	CALL SUBOPT_0x31
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	ST   X+,R30
	ST   X,R31
; 0000 05CF       komunikat_z_czytnika_kodow("87-1602",rzad,0);
	__POINTW1FN _0x0,922
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 05D0       srednica_wew_korpusu = 38;
; 0000 05D1     }
; 0000 05D2 if(PORT_CZYTNIK.byte == 0x5F)
_0x7A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5F)
	BRNE _0x7B
; 0000 05D3     {
; 0000 05D4       macierz_zaciskow[rzad]=95;
	CALL SUBOPT_0x31
	LDI  R30,LOW(95)
	LDI  R31,HIGH(95)
	ST   X+,R30
	ST   X,R31
; 0000 05D5       komunikat_z_czytnika_kodow("87-2017",rzad,0);
	__POINTW1FN _0x0,930
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 05D6       srednica_wew_korpusu = 41;
; 0000 05D7     }
; 0000 05D8 if(PORT_CZYTNIK.byte == 0x60)
_0x7B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x60)
	BRNE _0x7C
; 0000 05D9     {
; 0000 05DA       macierz_zaciskow[rzad]=96;   ///////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x31
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x3D
; 0000 05DB       macierz_zaciskow[rzad]=0;
	CALL SUBOPT_0x3E
; 0000 05DC       komunikat_z_czytnika_kodow("87-2384",rzad,0);
	__POINTW1FN _0x0,938
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 05DD       srednica_wew_korpusu = 38;
; 0000 05DE     }
; 0000 05DF 
; 0000 05E0 if(PORT_CZYTNIK.byte == 0x61)
_0x7C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x61)
	BRNE _0x7D
; 0000 05E1     {
; 0000 05E2       macierz_zaciskow[rzad]=97;
	CALL SUBOPT_0x31
	LDI  R30,LOW(97)
	LDI  R31,HIGH(97)
	ST   X+,R30
	ST   X,R31
; 0000 05E3       komunikat_z_czytnika_kodow("86-0847",rzad,0);
	__POINTW1FN _0x0,946
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 05E4       srednica_wew_korpusu = 41;
; 0000 05E5     }
; 0000 05E6 
; 0000 05E7 if(PORT_CZYTNIK.byte == 0x62)
_0x7D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x62)
	BRNE _0x7E
; 0000 05E8     {
; 0000 05E9       macierz_zaciskow[rzad]=98;
	CALL SUBOPT_0x31
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	ST   X+,R30
	ST   X,R31
; 0000 05EA       komunikat_z_czytnika_kodow("86-1620",rzad,0);
	__POINTW1FN _0x0,954
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 05EB       srednica_wew_korpusu = 38;
; 0000 05EC     }
; 0000 05ED if(PORT_CZYTNIK.byte == 0x63)
_0x7E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x63)
	BRNE _0x7F
; 0000 05EE     {
; 0000 05EF       macierz_zaciskow[rzad]=99;
	CALL SUBOPT_0x31
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	ST   X+,R30
	ST   X,R31
; 0000 05F0       komunikat_z_czytnika_kodow("86-2019",rzad,1);
	__POINTW1FN _0x0,962
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 05F1       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 05F2     }
; 0000 05F3 if(PORT_CZYTNIK.byte == 0x64)
_0x7F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x64)
	BRNE _0x80
; 0000 05F4     {
; 0000 05F5       macierz_zaciskow[rzad]=100;
	CALL SUBOPT_0x31
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   X+,R30
	ST   X,R31
; 0000 05F6       komunikat_z_czytnika_kodow("86-2385",rzad,0);
	__POINTW1FN _0x0,970
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 05F7       srednica_wew_korpusu = 38;
; 0000 05F8     }
; 0000 05F9 if(PORT_CZYTNIK.byte == 0x65)
_0x80:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x65)
	BRNE _0x81
; 0000 05FA     {
; 0000 05FB       macierz_zaciskow[rzad]=101;
	CALL SUBOPT_0x31
	LDI  R30,LOW(101)
	LDI  R31,HIGH(101)
	ST   X+,R30
	ST   X,R31
; 0000 05FC       komunikat_z_czytnika_kodow("87-0847",rzad,1);
	__POINTW1FN _0x0,978
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 05FD       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 05FE     }
; 0000 05FF if(PORT_CZYTNIK.byte == 0x66)
_0x81:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x66)
	BRNE _0x82
; 0000 0600     {
; 0000 0601       macierz_zaciskow[rzad]=102;
	CALL SUBOPT_0x31
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	ST   X+,R30
	ST   X,R31
; 0000 0602       komunikat_z_czytnika_kodow("87-1620",rzad,1);
	__POINTW1FN _0x0,986
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0603       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 0604     }
; 0000 0605 if(PORT_CZYTNIK.byte == 0x67)
_0x82:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x67)
	BRNE _0x83
; 0000 0606     {
; 0000 0607       macierz_zaciskow[rzad]=103;
	CALL SUBOPT_0x31
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	ST   X+,R30
	ST   X,R31
; 0000 0608       komunikat_z_czytnika_kodow("87-2019",rzad,0);
	__POINTW1FN _0x0,994
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 0609       srednica_wew_korpusu = 41;
; 0000 060A     }
; 0000 060B if(PORT_CZYTNIK.byte == 0x68)
_0x83:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x68)
	BRNE _0x84
; 0000 060C     {
; 0000 060D       macierz_zaciskow[rzad]=104;
	CALL SUBOPT_0x31
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	ST   X+,R30
	ST   X,R31
; 0000 060E       komunikat_z_czytnika_kodow("87-2385",rzad,1);
	__POINTW1FN _0x0,1002
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 060F       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 0610     }
; 0000 0611 if(PORT_CZYTNIK.byte == 0x69)
_0x84:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x69)
	BRNE _0x85
; 0000 0612     {
; 0000 0613       macierz_zaciskow[rzad]=105;
	CALL SUBOPT_0x31
	LDI  R30,LOW(105)
	LDI  R31,HIGH(105)
	ST   X+,R30
	ST   X,R31
; 0000 0614       komunikat_z_czytnika_kodow("86-0854",rzad,0);
	__POINTW1FN _0x0,1010
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 0615       srednica_wew_korpusu = 34;
; 0000 0616     }
; 0000 0617 if(PORT_CZYTNIK.byte == 0x6A)
_0x85:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6A)
	BRNE _0x86
; 0000 0618     {
; 0000 0619       macierz_zaciskow[rzad]=106;
	CALL SUBOPT_0x31
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	ST   X+,R30
	ST   X,R31
; 0000 061A       komunikat_z_czytnika_kodow("86-1622",rzad,1);
	__POINTW1FN _0x0,1018
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 061B       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 061C     }
; 0000 061D if(PORT_CZYTNIK.byte == 0x6B)
_0x86:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6B)
	BRNE _0x87
; 0000 061E     {
; 0000 061F       macierz_zaciskow[rzad]=107;
	CALL SUBOPT_0x31
	LDI  R30,LOW(107)
	LDI  R31,HIGH(107)
	CALL SUBOPT_0x3D
; 0000 0620       macierz_zaciskow[rzad]=0;          //brak zacisku
	CALL SUBOPT_0x3E
; 0000 0621       komunikat_z_czytnika_kodow("86-2028",rzad,0);
	__POINTW1FN _0x0,1026
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3C
; 0000 0622       srednica_wew_korpusu = 43;
; 0000 0623     }
; 0000 0624 if(PORT_CZYTNIK.byte == 0x6C)
_0x87:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6C)
	BRNE _0x88
; 0000 0625     {
; 0000 0626       macierz_zaciskow[rzad]=108;
	CALL SUBOPT_0x31
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	ST   X+,R30
	ST   X,R31
; 0000 0627       komunikat_z_czytnika_kodow("86-2437",rzad,0);
	__POINTW1FN _0x0,1034
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 0628       srednica_wew_korpusu = 38;
; 0000 0629     }
; 0000 062A if(PORT_CZYTNIK.byte == 0x6D)
_0x88:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6D)
	BRNE _0x89
; 0000 062B     {
; 0000 062C       macierz_zaciskow[rzad]=109;
	CALL SUBOPT_0x31
	LDI  R30,LOW(109)
	LDI  R31,HIGH(109)
	ST   X+,R30
	ST   X,R31
; 0000 062D       komunikat_z_czytnika_kodow("87-0854",rzad,1);
	__POINTW1FN _0x0,1042
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 062E       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 062F     }
; 0000 0630 if(PORT_CZYTNIK.byte == 0x6E)
_0x89:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6E)
	BRNE _0x8A
; 0000 0631     {
; 0000 0632       macierz_zaciskow[rzad]=110;
	CALL SUBOPT_0x31
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	ST   X+,R30
	ST   X,R31
; 0000 0633       komunikat_z_czytnika_kodow("87-1622",rzad,0);
	__POINTW1FN _0x0,1050
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 0634       srednica_wew_korpusu = 34;
; 0000 0635     }
; 0000 0636 
; 0000 0637 if(PORT_CZYTNIK.byte == 0x6F)
_0x8A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6F)
	BRNE _0x8B
; 0000 0638     {
; 0000 0639       macierz_zaciskow[rzad]=111;
	CALL SUBOPT_0x31
	LDI  R30,LOW(111)
	LDI  R31,HIGH(111)
	CALL SUBOPT_0x3D
; 0000 063A       macierz_zaciskow[rzad]=0;      //brak zacisku
	CALL SUBOPT_0x3E
; 0000 063B       komunikat_z_czytnika_kodow("87-2028",rzad,0);
	__POINTW1FN _0x0,1058
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3C
; 0000 063C       srednica_wew_korpusu = 43;
; 0000 063D     }
; 0000 063E 
; 0000 063F if(PORT_CZYTNIK.byte == 0x70)
_0x8B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x70)
	BRNE _0x8C
; 0000 0640     {
; 0000 0641       macierz_zaciskow[rzad]=112;
	CALL SUBOPT_0x31
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   X+,R30
	ST   X,R31
; 0000 0642       komunikat_z_czytnika_kodow("87-2437",rzad,1);
	__POINTW1FN _0x0,1066
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0643       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 0644     }
; 0000 0645 if(PORT_CZYTNIK.byte == 0x71)
_0x8C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x71)
	BRNE _0x8D
; 0000 0646     {
; 0000 0647       macierz_zaciskow[rzad]=113;
	CALL SUBOPT_0x31
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   X+,R30
	ST   X,R31
; 0000 0648       komunikat_z_czytnika_kodow("86-0862",rzad,0);
	__POINTW1FN _0x0,1074
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 0649       srednica_wew_korpusu = 38;
; 0000 064A     }
; 0000 064B if(PORT_CZYTNIK.byte == 0x72)
_0x8D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x72)
	BRNE _0x8E
; 0000 064C     {
; 0000 064D       macierz_zaciskow[rzad]=114;
	CALL SUBOPT_0x31
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	ST   X+,R30
	ST   X,R31
; 0000 064E       komunikat_z_czytnika_kodow("86-1625",rzad,0);
	__POINTW1FN _0x0,1082
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 064F       srednica_wew_korpusu = 38;
; 0000 0650     }
; 0000 0651 if(PORT_CZYTNIK.byte == 0x73)
_0x8E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x73)
	BRNE _0x8F
; 0000 0652     {
; 0000 0653       macierz_zaciskow[rzad]=115;
	CALL SUBOPT_0x31
	LDI  R30,LOW(115)
	LDI  R31,HIGH(115)
	ST   X+,R30
	ST   X,R31
; 0000 0654       komunikat_z_czytnika_kodow("86-2052",rzad,0);
	__POINTW1FN _0x0,1090
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3C
; 0000 0655       srednica_wew_korpusu = 43;
; 0000 0656     }
; 0000 0657 if(PORT_CZYTNIK.byte == 0x74)
_0x8F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x74)
	BRNE _0x90
; 0000 0658     {
; 0000 0659       macierz_zaciskow[rzad]=116;
	CALL SUBOPT_0x31
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	ST   X+,R30
	ST   X,R31
; 0000 065A       komunikat_z_czytnika_kodow("86-2492",rzad,1);
	__POINTW1FN _0x0,1098
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 065B       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 065C     }
; 0000 065D if(PORT_CZYTNIK.byte == 0x75)
_0x90:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x75)
	BRNE _0x91
; 0000 065E     {
; 0000 065F       macierz_zaciskow[rzad]=117;
	CALL SUBOPT_0x31
	LDI  R30,LOW(117)
	LDI  R31,HIGH(117)
	ST   X+,R30
	ST   X,R31
; 0000 0660       komunikat_z_czytnika_kodow("87-0862",rzad,1);
	__POINTW1FN _0x0,1106
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0661       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 0662     }
; 0000 0663 if(PORT_CZYTNIK.byte == 0x76)
_0x91:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x76)
	BRNE _0x92
; 0000 0664     {
; 0000 0665       macierz_zaciskow[rzad]=118;
	CALL SUBOPT_0x31
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	ST   X+,R30
	ST   X,R31
; 0000 0666       komunikat_z_czytnika_kodow("87-1625",rzad,1);
	__POINTW1FN _0x0,1114
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0667       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 0668     }
; 0000 0669 if(PORT_CZYTNIK.byte == 0x77)
_0x92:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x77)
	BRNE _0x93
; 0000 066A     {
; 0000 066B       macierz_zaciskow[rzad]=119;
	CALL SUBOPT_0x31
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   X+,R30
	ST   X,R31
; 0000 066C       komunikat_z_czytnika_kodow("87-2052",rzad,1);
	__POINTW1FN _0x0,1122
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 066D       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x3B
; 0000 066E     }
; 0000 066F if(PORT_CZYTNIK.byte == 0x78)
_0x93:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x78)
	BRNE _0x94
; 0000 0670     {
; 0000 0671       macierz_zaciskow[rzad]=120;
	CALL SUBOPT_0x31
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   X+,R30
	ST   X,R31
; 0000 0672       komunikat_z_czytnika_kodow("87-2492",rzad,0);
	__POINTW1FN _0x0,1130
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 0673       srednica_wew_korpusu = 38;
; 0000 0674     }
; 0000 0675 if(PORT_CZYTNIK.byte == 0x79)
_0x94:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x79)
	BRNE _0x95
; 0000 0676     {
; 0000 0677       macierz_zaciskow[rzad]=121;
	CALL SUBOPT_0x31
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   X+,R30
	ST   X,R31
; 0000 0678       komunikat_z_czytnika_kodow("86-0935",rzad,0);
	__POINTW1FN _0x0,1138
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 0679       srednica_wew_korpusu = 38;
; 0000 067A     }
; 0000 067B if(PORT_CZYTNIK.byte == 0x7A)
_0x95:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7A)
	BRNE _0x96
; 0000 067C     {
; 0000 067D       macierz_zaciskow[rzad]=122;
	CALL SUBOPT_0x31
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	ST   X+,R30
	ST   X,R31
; 0000 067E       komunikat_z_czytnika_kodow("86-1648",rzad,0);
	__POINTW1FN _0x0,1146
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 067F       srednica_wew_korpusu = 38;
; 0000 0680     }
; 0000 0681 if(PORT_CZYTNIK.byte == 0x7B)
_0x96:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7B)
	BRNE _0x97
; 0000 0682     {
; 0000 0683       macierz_zaciskow[rzad]=123;
	CALL SUBOPT_0x31
	LDI  R30,LOW(123)
	LDI  R31,HIGH(123)
	ST   X+,R30
	ST   X,R31
; 0000 0684       komunikat_z_czytnika_kodow("86-2082",rzad,0);
	__POINTW1FN _0x0,1154
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3F
; 0000 0685       srednica_wew_korpusu = 36;
; 0000 0686     }
; 0000 0687 if(PORT_CZYTNIK.byte == 0x7C)
_0x97:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7C)
	BRNE _0x98
; 0000 0688     {
; 0000 0689       macierz_zaciskow[rzad]=124;
	CALL SUBOPT_0x31
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	ST   X+,R30
	ST   X,R31
; 0000 068A       komunikat_z_czytnika_kodow("86-2500",rzad,0);
	__POINTW1FN _0x0,1162
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 068B       srednica_wew_korpusu = 38;
; 0000 068C     }
; 0000 068D if(PORT_CZYTNIK.byte == 0x7D)
_0x98:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7D)
	BRNE _0x99
; 0000 068E     {
; 0000 068F       macierz_zaciskow[rzad]=125;
	CALL SUBOPT_0x31
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   X+,R30
	ST   X,R31
; 0000 0690       komunikat_z_czytnika_kodow("87-0935",rzad,1);
	__POINTW1FN _0x0,1170
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0691       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 0692     }
; 0000 0693 if(PORT_CZYTNIK.byte == 0x7E)
_0x99:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7E)
	BRNE _0x9A
; 0000 0694     {
; 0000 0695       macierz_zaciskow[rzad]=126;
	CALL SUBOPT_0x31
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	ST   X+,R30
	ST   X,R31
; 0000 0696       komunikat_z_czytnika_kodow("87-1648",rzad,1);
	__POINTW1FN _0x0,1178
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0697       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 0698     }
; 0000 0699 
; 0000 069A if(PORT_CZYTNIK.byte == 0x7F)
_0x9A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7F)
	BRNE _0x9B
; 0000 069B     {
; 0000 069C       macierz_zaciskow[rzad]=127;
	CALL SUBOPT_0x31
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	ST   X+,R30
	ST   X,R31
; 0000 069D       komunikat_z_czytnika_kodow("87-2082",rzad,1);
	__POINTW1FN _0x0,1186
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 069E       srednica_wew_korpusu = 36;
	CALL SUBOPT_0x40
; 0000 069F     }
; 0000 06A0 if(PORT_CZYTNIK.byte == 0x80)
_0x9B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x80)
	BRNE _0x9C
; 0000 06A1     {
; 0000 06A2       macierz_zaciskow[rzad]=128;
	CALL SUBOPT_0x31
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   X+,R30
	ST   X,R31
; 0000 06A3       komunikat_z_czytnika_kodow("87-2500",rzad,1);
	__POINTW1FN _0x0,1194
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 06A4       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 06A5     }
; 0000 06A6 if(PORT_CZYTNIK.byte == 0x81)
_0x9C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x81)
	BRNE _0x9D
; 0000 06A7     {
; 0000 06A8       macierz_zaciskow[rzad]=129;
	CALL SUBOPT_0x31
	LDI  R30,LOW(129)
	LDI  R31,HIGH(129)
	ST   X+,R30
	ST   X,R31
; 0000 06A9       komunikat_z_czytnika_kodow("86-1019",rzad,0);
	__POINTW1FN _0x0,1202
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x39
; 0000 06AA       srednica_wew_korpusu = 41;
; 0000 06AB     }
; 0000 06AC if(PORT_CZYTNIK.byte == 0x82)
_0x9D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x82)
	BRNE _0x9E
; 0000 06AD     {
; 0000 06AE       macierz_zaciskow[rzad]=130;
	CALL SUBOPT_0x31
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	ST   X+,R30
	ST   X,R31
; 0000 06AF       komunikat_z_czytnika_kodow("86-1649",rzad,0);
	__POINTW1FN _0x0,1210
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 06B0       srednica_wew_korpusu = 38;
; 0000 06B1     }
; 0000 06B2 if(PORT_CZYTNIK.byte == 0x83)
_0x9E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x83)
	BRNE _0x9F
; 0000 06B3     {
; 0000 06B4       macierz_zaciskow[rzad]=131;
	CALL SUBOPT_0x31
	LDI  R30,LOW(131)
	LDI  R31,HIGH(131)
	ST   X+,R30
	ST   X,R31
; 0000 06B5       komunikat_z_czytnika_kodow("86-2083",rzad,1);
	__POINTW1FN _0x0,1218
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 06B6       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x3B
; 0000 06B7     }
; 0000 06B8 if(PORT_CZYTNIK.byte == 0x84)
_0x9F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x84)
	BRNE _0xA0
; 0000 06B9     {
; 0000 06BA       macierz_zaciskow[rzad]=132;
	CALL SUBOPT_0x31
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	ST   X+,R30
	ST   X,R31
; 0000 06BB       komunikat_z_czytnika_kodow("86-2585",rzad,0);
	__POINTW1FN _0x0,1226
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3C
; 0000 06BC       srednica_wew_korpusu = 43;
; 0000 06BD     }
; 0000 06BE if(PORT_CZYTNIK.byte == 0x85)
_0xA0:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x85)
	BRNE _0xA1
; 0000 06BF     {
; 0000 06C0       macierz_zaciskow[rzad]=133;
	CALL SUBOPT_0x31
	LDI  R30,LOW(133)
	LDI  R31,HIGH(133)
	ST   X+,R30
	ST   X,R31
; 0000 06C1       komunikat_z_czytnika_kodow("87-1019",rzad,1);
	__POINTW1FN _0x0,1234
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 06C2       srednica_wew_korpusu = 41;
	CALL SUBOPT_0x3A
; 0000 06C3     }
; 0000 06C4 if(PORT_CZYTNIK.byte == 0x86)
_0xA1:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x86)
	BRNE _0xA2
; 0000 06C5     {
; 0000 06C6       macierz_zaciskow[rzad]=134;
	CALL SUBOPT_0x31
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	ST   X+,R30
	ST   X,R31
; 0000 06C7       komunikat_z_czytnika_kodow("87-1649",rzad,1);
	__POINTW1FN _0x0,1242
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 06C8       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 06C9     }
; 0000 06CA if(PORT_CZYTNIK.byte == 0x87)
_0xA2:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x87)
	BRNE _0xA3
; 0000 06CB     {
; 0000 06CC       macierz_zaciskow[rzad]=135;
	CALL SUBOPT_0x31
	LDI  R30,LOW(135)
	LDI  R31,HIGH(135)
	ST   X+,R30
	ST   X,R31
; 0000 06CD       komunikat_z_czytnika_kodow("87-2083",rzad,0);
	__POINTW1FN _0x0,1250
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3C
; 0000 06CE       srednica_wew_korpusu = 43;
; 0000 06CF     }
; 0000 06D0 
; 0000 06D1 if(PORT_CZYTNIK.byte == 0x88)
_0xA3:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x88)
	BRNE _0xA4
; 0000 06D2     {
; 0000 06D3       macierz_zaciskow[rzad]=136;
	CALL SUBOPT_0x31
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	ST   X+,R30
	ST   X,R31
; 0000 06D4       komunikat_z_czytnika_kodow("87-2624",rzad,1);
	__POINTW1FN _0x0,1258
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 06D5       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 06D6     }
; 0000 06D7 if(PORT_CZYTNIK.byte == 0x89)
_0xA4:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x89)
	BRNE _0xA5
; 0000 06D8     {
; 0000 06D9       macierz_zaciskow[rzad]=137;
	CALL SUBOPT_0x31
	LDI  R30,LOW(137)
	LDI  R31,HIGH(137)
	ST   X+,R30
	ST   X,R31
; 0000 06DA       komunikat_z_czytnika_kodow("86-1027",rzad,0);
	__POINTW1FN _0x0,1266
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 06DB       srednica_wew_korpusu = 34;
; 0000 06DC     }
; 0000 06DD if(PORT_CZYTNIK.byte == 0x8A)
_0xA5:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8A)
	BRNE _0xA6
; 0000 06DE     {
; 0000 06DF       macierz_zaciskow[rzad]=138;
	CALL SUBOPT_0x31
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	ST   X+,R30
	ST   X,R31
; 0000 06E0       komunikat_z_czytnika_kodow("86-1669",rzad,1);
	__POINTW1FN _0x0,1274
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 06E1       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 06E2     }
; 0000 06E3 if(PORT_CZYTNIK.byte == 0x8B)
_0xA6:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8B)
	BRNE _0xA7
; 0000 06E4     {
; 0000 06E5       macierz_zaciskow[rzad]=139;
	CALL SUBOPT_0x31
	LDI  R30,LOW(139)
	LDI  R31,HIGH(139)
	ST   X+,R30
	ST   X,R31
; 0000 06E6       komunikat_z_czytnika_kodow("86-2087",rzad,1);
	__POINTW1FN _0x0,1282
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 06E7       srednica_wew_korpusu = 38;
	CALL SUBOPT_0x35
; 0000 06E8     }
; 0000 06E9 if(PORT_CZYTNIK.byte == 0x8C)
_0xA7:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8C)
	BRNE _0xA8
; 0000 06EA     {
; 0000 06EB       macierz_zaciskow[rzad]=140;
	CALL SUBOPT_0x31
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	ST   X+,R30
	ST   X,R31
; 0000 06EC       komunikat_z_czytnika_kodow("86-2624",rzad,0);
	__POINTW1FN _0x0,1290
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x36
; 0000 06ED       srednica_wew_korpusu = 34;
; 0000 06EE     }
; 0000 06EF if(PORT_CZYTNIK.byte == 0x8D)
_0xA8:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8D)
	BRNE _0xA9
; 0000 06F0     {
; 0000 06F1       macierz_zaciskow[rzad]=141;
	CALL SUBOPT_0x31
	LDI  R30,LOW(141)
	LDI  R31,HIGH(141)
	ST   X+,R30
	ST   X,R31
; 0000 06F2       komunikat_z_czytnika_kodow("87-1027",rzad,1);
	__POINTW1FN _0x0,1298
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 06F3       srednica_wew_korpusu = 34;
	CALL SUBOPT_0x38
; 0000 06F4     }
; 0000 06F5 if(PORT_CZYTNIK.byte == 0x8E)
_0xA9:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8E)
	BRNE _0xAA
; 0000 06F6     {
; 0000 06F7       macierz_zaciskow[rzad]=142;
	CALL SUBOPT_0x31
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	ST   X+,R30
	ST   X,R31
; 0000 06F8       komunikat_z_czytnika_kodow("87-1669",rzad,0);
	__POINTW1FN _0x0,1306
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 06F9       srednica_wew_korpusu = 38;
; 0000 06FA     }
; 0000 06FB if(PORT_CZYTNIK.byte == 0x8F)
_0xAA:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8F)
	BRNE _0xAB
; 0000 06FC     {
; 0000 06FD       macierz_zaciskow[rzad]=143;
	CALL SUBOPT_0x31
	LDI  R30,LOW(143)
	LDI  R31,HIGH(143)
	ST   X+,R30
	ST   X,R31
; 0000 06FE       komunikat_z_czytnika_kodow("87-2087",rzad,0);
	__POINTW1FN _0x0,1314
	CALL SUBOPT_0x33
	CALL SUBOPT_0x9
	CALL SUBOPT_0x37
; 0000 06FF       srednica_wew_korpusu = 38;
; 0000 0700     }
; 0000 0701 if(PORT_CZYTNIK.byte == 0x90)
_0xAB:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x90)
	BRNE _0xAC
; 0000 0702     {
; 0000 0703       macierz_zaciskow[rzad]=144;
	CALL SUBOPT_0x31
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   X+,R30
	ST   X,R31
; 0000 0704       komunikat_z_czytnika_kodow("87-2585",rzad,1);
	__POINTW1FN _0x0,1322
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0000 0705       srednica_wew_korpusu = 43;
	CALL SUBOPT_0x3B
; 0000 0706     }
; 0000 0707 
; 0000 0708 
; 0000 0709 return rzad;
_0xAC:
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 070A }
;
;
;void wybor_linijek_sterownikow(int rzad_local)
; 0000 070E {
_wybor_linijek_sterownikow:
; 0000 070F //zaczynam od tego
; 0000 0710 //komentarz: celowo upraszam:
; 0000 0711 //  a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 0712 //a[4] = 0x21;    //ster3 ABS             //krazek scierny
; 0000 0713 
; 0000 0714 //legenda pierwotna
; 0000 0715             /*
; 0000 0716             a[0] = 0x05A;   //ster1
; 0000 0717             a[1] = a[0]+0x001;                                   //0x05B;   //ster2
; 0000 0718             a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 0719             a[3] = 0x11;    //ster4 INV             //druciak
; 0000 071A             a[4] = a[2];   //0x21;    //ster3 ABS             //krazek scierny
; 0000 071B             a[5] = 0x196;   //delta okrag
; 0000 071C             a[6] = a[5]+0x001;            //0x197;   //okrag
; 0000 071D             a[7] = 0x12;    //ster3 INV             krazek scierny
; 0000 071E             a[8] = a[6]+0x001;                0x198;   //-delta okrag
; 0000 071F             a[9] = 0;          //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0720             */
; 0000 0721 
; 0000 0722 
; 0000 0723 //macierz_zaciskow[rzad_local]
; 0000 0724 //macierz_zaciskow[rzad_local] = 140;
; 0000 0725 
; 0000 0726 
; 0000 0727 
; 0000 0728 
; 0000 0729 
; 0000 072A 
; 0000 072B switch(macierz_zaciskow[rzad_local])
;	rzad_local -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(_macierz_zaciskow)
	LDI  R27,HIGH(_macierz_zaciskow)
	CALL SUBOPT_0x41
	CALL __GETW1P
; 0000 072C {
; 0000 072D     case 0:
	SBIW R30,0
	BRNE _0xB0
; 0000 072E 
; 0000 072F             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 0730             komunikat_na_panel("Nie wczytano zacisku",adr1,adr2);
	__POINTW1FN _0x0,1330
	CALL SUBOPT_0x2D
; 0000 0731 
; 0000 0732     break;
	JMP  _0xAF
; 0000 0733 
; 0000 0734 
; 0000 0735      case 1:
_0xB0:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB1
; 0000 0736 
; 0000 0737             a[0] = 0x0C8;   //ster1
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x42
; 0000 0738             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0739             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 073A             a[5] = 0x196;   //delta okrag
; 0000 073B             a[7] = 0x11;    //ster3 INV krazek scierny
	JMP  _0x581
; 0000 073C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 073D 
; 0000 073E             a[1] = a[0]+0x001;  //ster2
; 0000 073F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0740             a[6] = a[5]+0x001;  //okrag
; 0000 0741             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0742 
; 0000 0743     break;
; 0000 0744 
; 0000 0745       case 2:
_0xB1:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB2
; 0000 0746 
; 0000 0747             a[0] = 0x110;   //ster1
	LDI  R30,LOW(272)
	LDI  R31,HIGH(272)
	CALL SUBOPT_0x42
; 0000 0748             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0749             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x46
; 0000 074A             a[5] = 0x190;   //delta okrag
; 0000 074B             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 074C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x47
	JMP  _0x582
; 0000 074D 
; 0000 074E             a[1] = a[0]+0x001;  //ster2
; 0000 074F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0750             a[6] = a[5]+0x001;  //okrag
; 0000 0751             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0752 
; 0000 0753     break;
; 0000 0754 
; 0000 0755       case 3:
_0xB2:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xB3
; 0000 0756 
; 0000 0757             a[0] = 0x07A;   //ster1
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	CALL SUBOPT_0x42
; 0000 0758             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0759             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 075A             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x49
; 0000 075B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 075C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x582
; 0000 075D 
; 0000 075E             a[1] = a[0]+0x001;  //ster2
; 0000 075F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0760             a[6] = a[5]+0x001;  //okrag
; 0000 0761             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0762 
; 0000 0763     break;
; 0000 0764 
; 0000 0765       case 4:
_0xB3:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xB4
; 0000 0766 
; 0000 0767             a[0] = 0x102;   //ster1
	LDI  R30,LOW(258)
	LDI  R31,HIGH(258)
	CALL SUBOPT_0x42
; 0000 0768             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0769             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 076A             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x49
; 0000 076B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 076C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x582
; 0000 076D 
; 0000 076E             a[1] = a[0]+0x001;  //ster2
; 0000 076F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0770             a[6] = a[5]+0x001;  //okrag
; 0000 0771             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0772 
; 0000 0773     break;
; 0000 0774 
; 0000 0775       case 5:
_0xB4:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xB5
; 0000 0776 
; 0000 0777             a[0] = 0x0B0;   //ster1
	LDI  R30,LOW(176)
	LDI  R31,HIGH(176)
	CALL SUBOPT_0x42
; 0000 0778             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0779             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 077A             a[5] = 0x196;   //delta okrag
; 0000 077B             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 077C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 077D 
; 0000 077E             a[1] = a[0]+0x001;  //ster2
; 0000 077F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0780             a[6] = a[5]+0x001;  //okrag
; 0000 0781             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0782 
; 0000 0783     break;
; 0000 0784 
; 0000 0785       case 6:
_0xB5:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xB6
; 0000 0786 
; 0000 0787             a[0] = 0x0FE;   //ster1
	LDI  R30,LOW(254)
	LDI  R31,HIGH(254)
	CALL SUBOPT_0x42
; 0000 0788             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0789             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x46
; 0000 078A             a[5] = 0x190;   //delta okrag
; 0000 078B             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x581
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
; 0000 0796       case 7:
_0xB6:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xB7
; 0000 0797 
; 0000 0798             a[0] = 0x078;   //ster1
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x42
; 0000 0799             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 079A             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 079B             a[5] = 0x196;   //delta okrag
	RJMP _0x583
; 0000 079C             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 079D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 079E 
; 0000 079F             a[1] = a[0]+0x001;  //ster2
; 0000 07A0             a[2] = a[4];        //ster4 ABS druciak
; 0000 07A1             a[6] = a[5]+0x001;  //okrag
; 0000 07A2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07A3 
; 0000 07A4     break;
; 0000 07A5 
; 0000 07A6 
; 0000 07A7       case 8:
_0xB7:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xB8
; 0000 07A8 
; 0000 07A9             a[0] = 0x0C0;   //ster1
	LDI  R30,LOW(192)
	LDI  R31,HIGH(192)
	CALL SUBOPT_0x42
; 0000 07AA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 07AB             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 07AC             a[5] = 0x196;   //delta okrag
	RJMP _0x583
; 0000 07AD             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07AE             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07AF 
; 0000 07B0             a[1] = a[0]+0x001;  //ster2
; 0000 07B1             a[2] = a[4];        //ster4 ABS druciak
; 0000 07B2             a[6] = a[5]+0x001;  //okrag
; 0000 07B3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07B4 
; 0000 07B5     break;
; 0000 07B6 
; 0000 07B7 
; 0000 07B8       case 9:
_0xB8:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xB9
; 0000 07B9 
; 0000 07BA             a[0] = 0x018;   //ster1
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL SUBOPT_0x42
; 0000 07BB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 07BC             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 07BD             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4C
; 0000 07BE             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 07BF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 07C0 
; 0000 07C1             a[1] = a[0]+0x001;  //ster2
; 0000 07C2             a[2] = a[4];        //ster4 ABS druciak
; 0000 07C3             a[6] = a[5]+0x001;  //okrag
; 0000 07C4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07C5 
; 0000 07C6     break;
; 0000 07C7 
; 0000 07C8 
; 0000 07C9       case 10:
_0xB9:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xBA
; 0000 07CA 
; 0000 07CB             a[0] = 0x016;   //ster1
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CALL SUBOPT_0x42
; 0000 07CC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 07CD             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 07CE             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x49
; 0000 07CF             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07D0             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 07D1 
; 0000 07D2             a[1] = a[0]+0x001;  //ster2
; 0000 07D3             a[2] = a[4];        //ster4 ABS druciak
; 0000 07D4             a[6] = a[5]+0x001;  //okrag
; 0000 07D5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07D6 
; 0000 07D7     break;
; 0000 07D8 
; 0000 07D9 
; 0000 07DA       case 11:
_0xBA:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xBB
; 0000 07DB 
; 0000 07DC             a[0] = 0x074;   //ster1
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	CALL SUBOPT_0x42
; 0000 07DD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 07DE             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 07DF             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x49
; 0000 07E0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07E1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 07E2 
; 0000 07E3             a[1] = a[0]+0x001;  //ster2
; 0000 07E4             a[2] = a[4];        //ster4 ABS druciak
; 0000 07E5             a[6] = a[5]+0x001;  //okrag
; 0000 07E6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07E7 
; 0000 07E8     break;
; 0000 07E9 
; 0000 07EA 
; 0000 07EB       case 12:
_0xBB:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xBC
; 0000 07EC 
; 0000 07ED             a[0] = 0x096;   //ster1
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x42
; 0000 07EE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 07EF             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 07F0             a[5] = 0x199;   //delta okrag
	RJMP _0x583
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
; 0000 07FC       case 13:
_0xBC:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xBD
; 0000 07FD 
; 0000 07FE             a[0] = 0x01A;   //ster1
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	CALL SUBOPT_0x42
; 0000 07FF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0800             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 0801             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4C
; 0000 0802             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
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
; 0000 080D       case 14:
_0xBD:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xBE
; 0000 080E 
; 0000 080F             a[0] = 0x05E;   //ster1
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	CALL SUBOPT_0x42
; 0000 0810             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0811             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 0812             a[5] = 0x199;   //delta okrag
	RJMP _0x583
; 0000 0813             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0814             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0815 
; 0000 0816             a[1] = a[0]+0x001;  //ster2
; 0000 0817             a[2] = a[4];        //ster4 ABS druciak
; 0000 0818             a[6] = a[5]+0x001;  //okrag
; 0000 0819             a[8] = a[6]+0x001;  //-delta okrag
; 0000 081A 
; 0000 081B     break;
; 0000 081C 
; 0000 081D 
; 0000 081E       case 15:
_0xBE:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xBF
; 0000 081F 
; 0000 0820             a[0] = 0x084;   //ster1
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	CALL SUBOPT_0x42
; 0000 0821             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0822             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4E
; 0000 0823             a[5] = 0x199;   //delta okrag
	RJMP _0x583
; 0000 0824             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0825             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0826 
; 0000 0827             a[1] = a[0]+0x001;  //ster2
; 0000 0828             a[2] = a[4];        //ster4 ABS druciak
; 0000 0829             a[6] = a[5]+0x001;  //okrag
; 0000 082A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 082B 
; 0000 082C     break;
; 0000 082D 
; 0000 082E 
; 0000 082F       case 16:
_0xBF:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xC0
; 0000 0830 
; 0000 0831             a[0] = 0x0B8;   //ster1
	LDI  R30,LOW(184)
	LDI  R31,HIGH(184)
	CALL SUBOPT_0x42
; 0000 0832             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0833             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0834             a[5] = 0x199;   //delta okrag
; 0000 0835             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0836             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0837 
; 0000 0838             a[1] = a[0]+0x001;  //ster2
; 0000 0839             a[2] = a[4];        //ster4 ABS druciak
; 0000 083A             a[6] = a[5]+0x001;  //okrag
; 0000 083B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 083C 
; 0000 083D     break;
; 0000 083E 
; 0000 083F       case 17:
_0xC0:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xC1
; 0000 0840 
; 0000 0841             a[0] = 0x020;   //ster1
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x42
; 0000 0842             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0843             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0844             a[5] = 0x196;   //delta okrag
; 0000 0845             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0846             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0847 
; 0000 0848             a[1] = a[0]+0x001;  //ster2
; 0000 0849             a[2] = a[4];        //ster4 ABS druciak
; 0000 084A             a[6] = a[5]+0x001;  //okrag
; 0000 084B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 084C 
; 0000 084D     break;
; 0000 084E 
; 0000 084F 
; 0000 0850       case 18:
_0xC1:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xC2
; 0000 0851 
; 0000 0852             a[0] = 0x098;   //ster1
	LDI  R30,LOW(152)
	LDI  R31,HIGH(152)
	CALL SUBOPT_0x42
; 0000 0853             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0854             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 0855             a[5] = 0x190;   //delta okrag
; 0000 0856             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0857             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x47
	RJMP _0x582
; 0000 0858 
; 0000 0859             a[1] = a[0]+0x001;  //ster2
; 0000 085A             a[2] = a[4];        //ster4 ABS druciak
; 0000 085B             a[6] = a[5]+0x001;  //okrag
; 0000 085C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 085D 
; 0000 085E     break;
; 0000 085F 
; 0000 0860 
; 0000 0861 
; 0000 0862       case 19:
_0xC2:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xC3
; 0000 0863 
; 0000 0864             a[0] = 0x0AA;   //ster1
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	CALL SUBOPT_0x42
; 0000 0865             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0866             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x52
; 0000 0867             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x53
; 0000 0868             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0869             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 086A 
; 0000 086B             a[1] = a[0]+0x001;  //ster2
; 0000 086C             a[2] = a[4];        //ster4 ABS druciak
; 0000 086D             a[6] = a[5]+0x001;  //okrag
; 0000 086E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 086F 
; 0000 0870     break;
; 0000 0871 
; 0000 0872 
; 0000 0873       case 20:
_0xC3:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0xC4
; 0000 0874 
; 0000 0875             a[0] = 0x042;   //ster1
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	CALL SUBOPT_0x42
; 0000 0876             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0877             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x52
; 0000 0878             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x54
; 0000 0879             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 087A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 087B 
; 0000 087C             a[1] = a[0]+0x001;  //ster2
; 0000 087D             a[2] = a[4];        //ster4 ABS druciak
; 0000 087E             a[6] = a[5]+0x001;  //okrag
; 0000 087F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0880 
; 0000 0881     break;
; 0000 0882 
; 0000 0883 
; 0000 0884       case 21:
_0xC4:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0xC5
; 0000 0885 
; 0000 0886             a[0] = 0x04E;   //ster1
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	CALL SUBOPT_0x42
; 0000 0887             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0888             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0889             a[5] = 0x196;   //delta okrag
; 0000 088A             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 088B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 088C 
; 0000 088D             a[1] = a[0]+0x001;  //ster2
; 0000 088E             a[2] = a[4];        //ster4 ABS druciak
; 0000 088F             a[6] = a[5]+0x001;  //okrag
; 0000 0890             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0891 
; 0000 0892     break;
; 0000 0893 
; 0000 0894       case 22:
_0xC5:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0xC6
; 0000 0895 
; 0000 0896             a[0] = 0x0C2;   //ster1
	LDI  R30,LOW(194)
	LDI  R31,HIGH(194)
	CALL SUBOPT_0x42
; 0000 0897             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0898             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 0899             a[5] = 0x190;   //delta okrag
; 0000 089A             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x581
; 0000 089B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 089C 
; 0000 089D             a[1] = a[0]+0x001;  //ster2
; 0000 089E             a[2] = a[4];        //ster4 ABS druciak
; 0000 089F             a[6] = a[5]+0x001;  //okrag
; 0000 08A0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08A1 
; 0000 08A2     break;
; 0000 08A3 
; 0000 08A4 
; 0000 08A5       case 23:
_0xC6:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0xC7
; 0000 08A6 
; 0000 08A7             a[0] = 0x0CE;   //ster1
	LDI  R30,LOW(206)
	LDI  R31,HIGH(206)
	CALL SUBOPT_0x42
; 0000 08A8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 08A9             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x52
; 0000 08AA             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x583
; 0000 08AB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08AC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08AD 
; 0000 08AE             a[1] = a[0]+0x001;  //ster2
; 0000 08AF             a[2] = a[4];        //ster4 ABS druciak
; 0000 08B0             a[6] = a[5]+0x001;  //okrag
; 0000 08B1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08B2 
; 0000 08B3     break;
; 0000 08B4 
; 0000 08B5 
; 0000 08B6       case 24:
_0xC7:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0xC8
; 0000 08B7 
; 0000 08B8             a[0] = 0x040;   //ster1
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL SUBOPT_0x42
; 0000 08B9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 08BA             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x52
; 0000 08BB             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x54
; 0000 08BC             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 08BD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08BE 
; 0000 08BF             a[1] = a[0]+0x001;  //ster2
; 0000 08C0             a[2] = a[4];        //ster4 ABS druciak
; 0000 08C1             a[6] = a[5]+0x001;  //okrag
; 0000 08C2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08C3 
; 0000 08C4     break;
; 0000 08C5 
; 0000 08C6       case 25:
_0xC8:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0xC9
; 0000 08C7 
; 0000 08C8             a[0] = 0x02E;   //ster1
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	CALL SUBOPT_0x42
; 0000 08C9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 08CA             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 08CB             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x49
; 0000 08CC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08CD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 08CE 
; 0000 08CF             a[1] = a[0]+0x001;  //ster2
; 0000 08D0             a[2] = a[4];        //ster4 ABS druciak
; 0000 08D1             a[6] = a[5]+0x001;  //okrag
; 0000 08D2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08D3 
; 0000 08D4     break;
; 0000 08D5 
; 0000 08D6       case 26:
_0xC9:
	CPI  R30,LOW(0x1A)
	LDI  R26,HIGH(0x1A)
	CPC  R31,R26
	BRNE _0xCA
; 0000 08D7 
; 0000 08D8             a[0] = 0x0FA;   //ster1
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x42
; 0000 08D9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 08DA             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 08DB             a[5] = 0x190;   //delta okrag
; 0000 08DC             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 08DD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 08DE 
; 0000 08DF             a[1] = a[0]+0x001;  //ster2
; 0000 08E0             a[2] = a[4];        //ster4 ABS druciak
; 0000 08E1             a[6] = a[5]+0x001;  //okrag
; 0000 08E2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08E3 
; 0000 08E4     break;
; 0000 08E5 
; 0000 08E6 
; 0000 08E7       case 27:
_0xCA:
	CPI  R30,LOW(0x1B)
	LDI  R26,HIGH(0x1B)
	CPC  R31,R26
	BRNE _0xCB
; 0000 08E8 
; 0000 08E9             a[0] = 0x06C;   //ster1
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	CALL SUBOPT_0x42
; 0000 08EA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 08EB             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 08EC             a[5] = 0x199;   //delta okrag
; 0000 08ED             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08EE             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 08EF 
; 0000 08F0             a[1] = a[0]+0x001;  //ster2
; 0000 08F1             a[2] = a[4];        //ster4 ABS druciak
; 0000 08F2             a[6] = a[5]+0x001;  //okrag
; 0000 08F3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08F4 
; 0000 08F5     break;
; 0000 08F6 
; 0000 08F7 
; 0000 08F8       case 28:
_0xCB:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BRNE _0xCC
; 0000 08F9 
; 0000 08FA             a[0] = 0x0A4;   //ster1
	LDI  R30,LOW(164)
	LDI  R31,HIGH(164)
	CALL SUBOPT_0x42
; 0000 08FB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 08FC             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 08FD             a[5] = 0x199;   //delta okrag
	RJMP _0x583
; 0000 08FE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08FF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0900 
; 0000 0901             a[1] = a[0]+0x001;  //ster2
; 0000 0902             a[2] = a[4];        //ster4 ABS druciak
; 0000 0903             a[6] = a[5]+0x001;  //okrag
; 0000 0904             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0905 
; 0000 0906     break;
; 0000 0907 
; 0000 0908       case 29:
_0xCC:
	CPI  R30,LOW(0x1D)
	LDI  R26,HIGH(0x1D)
	CPC  R31,R26
	BRNE _0xCD
; 0000 0909 
; 0000 090A             a[0] = 0x02A;   //ster1
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	CALL SUBOPT_0x42
; 0000 090B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 090C             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4D
; 0000 090D             a[5] = 0x199;   //delta okrag
	RJMP _0x583
; 0000 090E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 090F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0910 
; 0000 0911             a[1] = a[0]+0x001;  //ster2
; 0000 0912             a[2] = a[4];        //ster4 ABS druciak
; 0000 0913             a[6] = a[5]+0x001;  //okrag
; 0000 0914             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0915 
; 0000 0916 
; 0000 0917 
; 0000 0918 
; 0000 0919 
; 0000 091A     break;
; 0000 091B 
; 0000 091C       case 30:
_0xCD:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0xCE
; 0000 091D 
; 0000 091E             a[0] = 0x094;   //ster1
	LDI  R30,LOW(148)
	LDI  R31,HIGH(148)
	CALL SUBOPT_0x42
; 0000 091F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0920             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0921             a[5] = 0x190;   //delta okrag
; 0000 0922             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 0923             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0924 
; 0000 0925             a[1] = a[0]+0x001;  //ster2
; 0000 0926             a[2] = a[4];        //ster4 ABS druciak
; 0000 0927             a[6] = a[5]+0x001;  //okrag
; 0000 0928             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0929 
; 0000 092A     break;
; 0000 092B 
; 0000 092C       case 31:
_0xCE:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0xCF
; 0000 092D 
; 0000 092E             a[0] = 0x06E;   //ster1
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	CALL SUBOPT_0x42
; 0000 092F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0930             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 0931             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x583
; 0000 0932             a[7] = 0x12;  //ster3 INV krazek scierny
; 0000 0933             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0934 
; 0000 0935             a[1] = a[0]+0x001;  //ster2
; 0000 0936             a[2] = a[4];        //ster4 ABS druciak
; 0000 0937             a[6] = a[5]+0x001;  //okrag
; 0000 0938             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0939 
; 0000 093A     break;
; 0000 093B 
; 0000 093C 
; 0000 093D        case 32:
_0xCF:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xD0
; 0000 093E 
; 0000 093F             a[0] = 0x086;   //ster1
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	CALL SUBOPT_0x42
; 0000 0940             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0941             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0942             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0943             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0944             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0945 
; 0000 0946             a[1] = a[0]+0x001;  //ster2
; 0000 0947             a[2] = a[4];        //ster4 ABS druciak
; 0000 0948             a[6] = a[5]+0x001;  //okrag
; 0000 0949             a[8] = a[6]+0x001;  //-delta okrag
; 0000 094A 
; 0000 094B     break;
; 0000 094C 
; 0000 094D        case 33:
_0xD0:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0xD1
; 0000 094E 
; 0000 094F             a[0] = 0x08E;   //ster1
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	CALL SUBOPT_0x42
; 0000 0950             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0951             a[4] = 0x20;    //ster3 ABS krazek scierny
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	RJMP _0x584
; 0000 0952             a[5] = 0x19C;   //delta okrag
; 0000 0953             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0954             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0955 
; 0000 0956             a[1] = a[0]+0x001;  //ster2
; 0000 0957             a[2] = a[4];        //ster4 ABS druciak
; 0000 0958             a[6] = a[5]+0x001;  //okrag
; 0000 0959             a[8] = a[6]+0x001;  //-delta okrag
; 0000 095A 
; 0000 095B     break;
; 0000 095C 
; 0000 095D 
; 0000 095E     case 34: //86-1349
_0xD1:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0xD2
; 0000 095F 
; 0000 0960             a[0] = 0x05A;   //ster1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x42
; 0000 0961             a[3] = 0x11- 0x01;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0962             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 0963             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0964             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0965             a[9] = 0;       //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0966 
; 0000 0967             a[1] = a[0]+0x001;  //ster2
; 0000 0968             a[2] = a[4];        //ster4 ABS druciak
; 0000 0969             a[6] = a[5]+0x001;  //okrag
; 0000 096A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 096B 
; 0000 096C     break;
; 0000 096D 
; 0000 096E 
; 0000 096F     case 35:
_0xD2:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0xD3
; 0000 0970 
; 0000 0971             a[0] = 0x0DA;   //ster1
	LDI  R30,LOW(218)
	LDI  R31,HIGH(218)
	CALL SUBOPT_0x42
; 0000 0972             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0973             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0974             a[5] = 0x190;   //delta okrag
; 0000 0975             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0976             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0977 
; 0000 0978             a[1] = a[0]+0x001;  //ster2
; 0000 0979             a[2] = a[4];        //ster4 ABS druciak
; 0000 097A             a[6] = a[5]+0x001;  //okrag
; 0000 097B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 097C 
; 0000 097D     break;
; 0000 097E 
; 0000 097F          case 36:
_0xD3:
	CPI  R30,LOW(0x24)
	LDI  R26,HIGH(0x24)
	CPC  R31,R26
	BRNE _0xD4
; 0000 0980 
; 0000 0981             a[0] = 0x0A2;   //ster1
	LDI  R30,LOW(162)
	LDI  R31,HIGH(162)
	CALL SUBOPT_0x42
; 0000 0982             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x59
; 0000 0983             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 0984             a[5] = 0x196;   //delta okrag
; 0000 0985             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0986             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x47
	RJMP _0x582
; 0000 0987 
; 0000 0988             a[1] = a[0]+0x001;  //ster2
; 0000 0989             a[2] = a[4];        //ster4 ABS druciak
; 0000 098A             a[6] = a[5]+0x001;  //okrag
; 0000 098B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 098C 
; 0000 098D     break;
; 0000 098E 
; 0000 098F          case 37:
_0xD4:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0xD5
; 0000 0990 
; 0000 0991             a[0] = 0x104;   //ster1
	LDI  R30,LOW(260)
	LDI  R31,HIGH(260)
	CALL SUBOPT_0x42
; 0000 0992             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0993             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5A
; 0000 0994             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x5B
; 0000 0995             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0996             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0997 
; 0000 0998             a[1] = a[0]+0x001;  //ster2
; 0000 0999             a[2] = a[4];        //ster4 ABS druciak
; 0000 099A             a[6] = a[5]+0x001;  //okrag
; 0000 099B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 099C 
; 0000 099D     break;
; 0000 099E 
; 0000 099F          case 38:
_0xD5:
	CPI  R30,LOW(0x26)
	LDI  R26,HIGH(0x26)
	CPC  R31,R26
	BRNE _0xD6
; 0000 09A0 
; 0000 09A1             a[0] = 0x036;   //ster1
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	CALL SUBOPT_0x42
; 0000 09A2             a[3] = 0x11 - 0x01;    //ster4 INV druciak  //korekta
	CALL SUBOPT_0x45
; 0000 09A3             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x57
; 0000 09A4             a[5] = 0x196;   //delta okrag
	RJMP _0x583
; 0000 09A5             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 09A6             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09A7 
; 0000 09A8             a[1] = a[0]+0x001;  //ster2
; 0000 09A9             a[2] = a[4];        //ster4 ABS druciak
; 0000 09AA             a[6] = a[5]+0x001;  //okrag
; 0000 09AB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09AC 
; 0000 09AD     break;
; 0000 09AE 
; 0000 09AF 
; 0000 09B0          case 39:
_0xD6:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0xD7
; 0000 09B1 
; 0000 09B2             a[0] = 0x118;   //ster1
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	CALL SUBOPT_0x42
; 0000 09B3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 09B4             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 09B5             a[5] = 0x190;   //delta okrag
; 0000 09B6             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 09B7             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09B8 
; 0000 09B9             a[1] = a[0]+0x001;  //ster2
; 0000 09BA             a[2] = a[4];        //ster4 ABS druciak
; 0000 09BB             a[6] = a[5]+0x001;  //okrag
; 0000 09BC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09BD 
; 0000 09BE     break;
; 0000 09BF 
; 0000 09C0 
; 0000 09C1          case 40:
_0xD7:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0xD8
; 0000 09C2 
; 0000 09C3             a[0] = 0x0A6;   //ster1
	LDI  R30,LOW(166)
	LDI  R31,HIGH(166)
	CALL SUBOPT_0x42
; 0000 09C4             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x59
; 0000 09C5             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 09C6             a[5] = 0x196;   //delta okrag
; 0000 09C7             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x581
; 0000 09C8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09C9 
; 0000 09CA             a[1] = a[0]+0x001;  //ster2
; 0000 09CB             a[2] = a[4];        //ster4 ABS druciak
; 0000 09CC             a[6] = a[5]+0x001;  //okrag
; 0000 09CD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09CE 
; 0000 09CF     break;
; 0000 09D0 
; 0000 09D1          case 41:
_0xD8:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0xD9
; 0000 09D2 
; 0000 09D3             a[0] = 0x01E;   //ster1
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x42
; 0000 09D4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 09D5             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 09D6             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4C
; 0000 09D7             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 09D8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09D9 
; 0000 09DA             a[1] = a[0]+0x001;  //ster2
; 0000 09DB             a[2] = a[4];        //ster4 ABS druciak
; 0000 09DC             a[6] = a[5]+0x001;  //okrag
; 0000 09DD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09DE 
; 0000 09DF     break;
; 0000 09E0 
; 0000 09E1 
; 0000 09E2          case 42:
_0xD9:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0xDA
; 0000 09E3 
; 0000 09E4             a[0] = 0x05C;   //ster1
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x42
; 0000 09E5             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 09E6             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5C
; 0000 09E7             a[5] = 0x196;   //delta okrag
; 0000 09E8             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 09E9             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 09EA 
; 0000 09EB             a[1] = a[0]+0x001;  //ster2
; 0000 09EC             a[2] = a[4];        //ster4 ABS druciak
; 0000 09ED             a[6] = a[5]+0x001;  //okrag
; 0000 09EE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09EF 
; 0000 09F0     break;
; 0000 09F1 
; 0000 09F2 
; 0000 09F3          case 43:
_0xDA:
	CPI  R30,LOW(0x2B)
	LDI  R26,HIGH(0x2B)
	CPC  R31,R26
	BRNE _0xDB
; 0000 09F4 
; 0000 09F5             a[0] = 0x062;   //ster1
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL SUBOPT_0x42
; 0000 09F6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 09F7             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 09F8             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5D
; 0000 09F9             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 09FA             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 09FB 
; 0000 09FC             a[1] = a[0]+0x001;  //ster2
; 0000 09FD             a[2] = a[4];        //ster4 ABS druciak
; 0000 09FE             a[6] = a[5]+0x001;  //okrag
; 0000 09FF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A00 
; 0000 0A01     break;
; 0000 0A02 
; 0000 0A03 
; 0000 0A04          case 44:
_0xDB:
	CPI  R30,LOW(0x2C)
	LDI  R26,HIGH(0x2C)
	CPC  R31,R26
	BRNE _0xDC
; 0000 0A05 
; 0000 0A06             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5E
; 0000 0A07             a[3] = 0x;    //ster4 INV druciak
; 0000 0A08             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0A09             a[5] = 0x;   //delta okrag
; 0000 0A0A             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0A0B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0A0C 
; 0000 0A0D             a[1] = a[0]+0x001;  //ster2
; 0000 0A0E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A0F             a[6] = a[5]+0x001;  //okrag
; 0000 0A10             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A11 
; 0000 0A12     break;
; 0000 0A13 
; 0000 0A14 
; 0000 0A15          case 45:
_0xDC:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0xDD
; 0000 0A16 
; 0000 0A17             a[0] = 0x010;   //ster1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x42
; 0000 0A18             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0A19             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 0A1A             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4C
; 0000 0A1B             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0A1C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0A1D 
; 0000 0A1E             a[1] = a[0]+0x001;  //ster2
; 0000 0A1F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A20             a[6] = a[5]+0x001;  //okrag
; 0000 0A21             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A22 
; 0000 0A23     break;
; 0000 0A24 
; 0000 0A25 
; 0000 0A26     case 46:
_0xDD:
	CPI  R30,LOW(0x2E)
	LDI  R26,HIGH(0x2E)
	CPC  R31,R26
	BRNE _0xDE
; 0000 0A27 
; 0000 0A28             a[0] = 0x050;   //ster1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x42
; 0000 0A29             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0A2A             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5C
; 0000 0A2B             a[5] = 0x196;   //delta okrag
; 0000 0A2C             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 0A2D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A2E 
; 0000 0A2F             a[1] = a[0]+0x001;  //ster2
; 0000 0A30             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A31             a[6] = a[5]+0x001;  //okrag
; 0000 0A32             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A33 
; 0000 0A34     break;
; 0000 0A35 
; 0000 0A36 
; 0000 0A37     case 47:
_0xDE:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BRNE _0xDF
; 0000 0A38 
; 0000 0A39             a[0] = 0x068;   //ster1
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	CALL SUBOPT_0x42
; 0000 0A3A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0A3B             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 0A3C             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x583
; 0000 0A3D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A3E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A3F 
; 0000 0A40             a[1] = a[0]+0x001;  //ster2
; 0000 0A41             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A42             a[6] = a[5]+0x001;  //okrag
; 0000 0A43             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A44 
; 0000 0A45     break;
; 0000 0A46 
; 0000 0A47 
; 0000 0A48 
; 0000 0A49     case 48:
_0xDF:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0xE0
; 0000 0A4A 
; 0000 0A4B             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5E
; 0000 0A4C             a[3] = 0x;    //ster4 INV druciak
; 0000 0A4D             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0A4E             a[5] = 0x;   //delta okrag
; 0000 0A4F             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0A50             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0A51 
; 0000 0A52             a[1] = a[0]+0x001;  //ster2
; 0000 0A53             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A54             a[6] = a[5]+0x001;  //okrag
; 0000 0A55             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A56 
; 0000 0A57     break;
; 0000 0A58 
; 0000 0A59 
; 0000 0A5A     case 49:
_0xE0:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xE1
; 0000 0A5B 
; 0000 0A5C             a[0] = 0x024;   //ster1
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL SUBOPT_0x42
; 0000 0A5D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0A5E             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 0A5F             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0A60             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A61             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0A62 
; 0000 0A63             a[1] = a[0]+0x001;  //ster2
; 0000 0A64             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A65             a[6] = a[5]+0x001;  //okrag
; 0000 0A66             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A67 
; 0000 0A68     break;
; 0000 0A69 
; 0000 0A6A 
; 0000 0A6B     case 50:
_0xE1:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0xE2
; 0000 0A6C 
; 0000 0A6D             a[0] = 0x014;   //ster1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x42
; 0000 0A6E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0A6F             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0A70             a[5] = 0x190;   //delta okrag
; 0000 0A71             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0A72             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0A73 
; 0000 0A74             a[1] = a[0]+0x001;  //ster2
; 0000 0A75             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A76             a[6] = a[5]+0x001;  //okrag
; 0000 0A77             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A78 
; 0000 0A79     break;
; 0000 0A7A 
; 0000 0A7B     case 51:
_0xE2:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0xE3
; 0000 0A7C 
; 0000 0A7D             a[0] = 0x082;   //ster1
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	CALL SUBOPT_0x42
; 0000 0A7E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0A7F             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5F
; 0000 0A80             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x5B
; 0000 0A81             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A82             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0A83 
; 0000 0A84             a[1] = a[0]+0x001;  //ster2
; 0000 0A85             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A86             a[6] = a[5]+0x001;  //okrag
; 0000 0A87             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A88 
; 0000 0A89     break;
; 0000 0A8A 
; 0000 0A8B     case 52:
_0xE3:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0xE4
; 0000 0A8C 
; 0000 0A8D             a[0] = 0x106;   //ster1
	LDI  R30,LOW(262)
	LDI  R31,HIGH(262)
	CALL SUBOPT_0x42
; 0000 0A8E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0A8F             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x60
; 0000 0A90             a[5] = 0x190;   //delta okrag
; 0000 0A91             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 0A92             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A93 
; 0000 0A94             a[1] = a[0]+0x001;  //ster2
; 0000 0A95             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A96             a[6] = a[5]+0x001;  //okrag
; 0000 0A97             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A98 
; 0000 0A99     break;
; 0000 0A9A 
; 0000 0A9B 
; 0000 0A9C     case 53:
_0xE4:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0xE5
; 0000 0A9D 
; 0000 0A9E             a[0] = 0x04C;   //ster1
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x42
; 0000 0A9F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0AA0             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 0AA1             a[5] = 0x196;   //delta okrag
	RJMP _0x583
; 0000 0AA2             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AA3             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AA4 
; 0000 0AA5             a[1] = a[0]+0x001;  //ster2
; 0000 0AA6             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AA7             a[6] = a[5]+0x001;  //okrag
; 0000 0AA8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AA9 
; 0000 0AAA     break;
; 0000 0AAB 
; 0000 0AAC 
; 0000 0AAD     case 54:
_0xE5:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0xE6
; 0000 0AAE 
; 0000 0AAF             a[0] = 0x01C;   //ster1
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	CALL SUBOPT_0x42
; 0000 0AB0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0AB1             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0AB2             a[5] = 0x190;   //delta okrag
; 0000 0AB3             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 0AB4             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AB5 
; 0000 0AB6             a[1] = a[0]+0x001;  //ster2
; 0000 0AB7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AB8             a[6] = a[5]+0x001;  //okrag
; 0000 0AB9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ABA 
; 0000 0ABB     break;
; 0000 0ABC 
; 0000 0ABD     case 55:
_0xE6:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0xE7
; 0000 0ABE 
; 0000 0ABF             a[0] = 0x114;   //ster1
	LDI  R30,LOW(276)
	LDI  R31,HIGH(276)
	CALL SUBOPT_0x42
; 0000 0AC0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0AC1             a[4] = 0x1A;    //ster3 ABS krazek scierny
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	RJMP _0x584
; 0000 0AC2             a[5] = 0x19C;   //delta okrag
; 0000 0AC3             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AC4             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AC5 
; 0000 0AC6             a[1] = a[0]+0x001;  //ster2
; 0000 0AC7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AC8             a[6] = a[5]+0x001;  //okrag
; 0000 0AC9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ACA 
; 0000 0ACB     break;
; 0000 0ACC 
; 0000 0ACD 
; 0000 0ACE     case 56:
_0xE7:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0xE8
; 0000 0ACF 
; 0000 0AD0             a[0] = 0x0EE;   //ster1
	LDI  R30,LOW(238)
	LDI  R31,HIGH(238)
	CALL SUBOPT_0x42
; 0000 0AD1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0AD2             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x60
; 0000 0AD3             a[5] = 0x190;   //delta okrag
; 0000 0AD4             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0AD5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0AD6 
; 0000 0AD7             a[1] = a[0]+0x001;  //ster2
; 0000 0AD8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AD9             a[6] = a[5]+0x001;  //okrag
; 0000 0ADA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ADB 
; 0000 0ADC     break;
; 0000 0ADD 
; 0000 0ADE 
; 0000 0ADF     case 57:
_0xE8:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0xE9
; 0000 0AE0 
; 0000 0AE1             a[0] = 0x0F8;   //ster1
	LDI  R30,LOW(248)
	LDI  R31,HIGH(248)
	CALL SUBOPT_0x42
; 0000 0AE2             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0AE3             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x61
; 0000 0AE4             a[5] = 0x190;   //delta okrag
; 0000 0AE5             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0AE6             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0AE7 
; 0000 0AE8             a[1] = a[0]+0x001;  //ster2
; 0000 0AE9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AEA             a[6] = a[5]+0x001;  //okrag
; 0000 0AEB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AEC 
; 0000 0AED     break;
; 0000 0AEE 
; 0000 0AEF 
; 0000 0AF0     case 58:
_0xE9:
	CPI  R30,LOW(0x3A)
	LDI  R26,HIGH(0x3A)
	CPC  R31,R26
	BRNE _0xEA
; 0000 0AF1 
; 0000 0AF2             a[0] = 0x0E4;   //ster1
	LDI  R30,LOW(228)
	LDI  R31,HIGH(228)
	CALL SUBOPT_0x42
; 0000 0AF3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0AF4             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 0AF5             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5D
; 0000 0AF6             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AF7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0AF8 
; 0000 0AF9             a[1] = a[0]+0x001;  //ster2
; 0000 0AFA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AFB             a[6] = a[5]+0x001;  //okrag
; 0000 0AFC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AFD 
; 0000 0AFE     break;
; 0000 0AFF 
; 0000 0B00 
; 0000 0B01     case 59:
_0xEA:
	CPI  R30,LOW(0x3B)
	LDI  R26,HIGH(0x3B)
	CPC  R31,R26
	BRNE _0xEB
; 0000 0B02 
; 0000 0B03             a[0] = 0x052;   //ster1
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	CALL SUBOPT_0x42
; 0000 0B04             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0B05             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0B06             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x53
; 0000 0B07             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B08             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0B09 
; 0000 0B0A             a[1] = a[0]+0x001;  //ster2
; 0000 0B0B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B0C             a[6] = a[5]+0x001;  //okrag
; 0000 0B0D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B0E 
; 0000 0B0F     break;
; 0000 0B10 
; 0000 0B11 
; 0000 0B12     case 60:
_0xEB:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BRNE _0xEC
; 0000 0B13 
; 0000 0B14             a[0] = 0x090;   //ster1
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0x42
; 0000 0B15             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0B16             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0B17             a[5] = 0x190;   //delta okrag
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL SUBOPT_0x4C
; 0000 0B18             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0B19             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0B1A 
; 0000 0B1B             a[1] = a[0]+0x001;  //ster2
; 0000 0B1C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B1D             a[6] = a[5]+0x001;  //okrag
; 0000 0B1E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B1F 
; 0000 0B20     break;
; 0000 0B21 
; 0000 0B22 
; 0000 0B23     case 61:
_0xEC:
	CPI  R30,LOW(0x3D)
	LDI  R26,HIGH(0x3D)
	CPC  R31,R26
	BRNE _0xED
; 0000 0B24 
; 0000 0B25             a[0] = 0x0FC;   //ster1
	LDI  R30,LOW(252)
	LDI  R31,HIGH(252)
	CALL SUBOPT_0x42
; 0000 0B26             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0B27             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x55
; 0000 0B28             a[5] = 0x190;   //delta okrag
; 0000 0B29             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
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
; 0000 0B34     case 62:
_0xED:
	CPI  R30,LOW(0x3E)
	LDI  R26,HIGH(0x3E)
	CPC  R31,R26
	BRNE _0xEE
; 0000 0B35 
; 0000 0B36             a[0] = 0x028;   //ster1
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x42
; 0000 0B37             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0B38             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 0B39             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x583
; 0000 0B3A             a[7] = 0x12;    //ster3 INV krazek scierny
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
; 0000 0B45     case 63:
_0xEE:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0xEF
; 0000 0B46 
; 0000 0B47             a[0] = 0x034;   //ster1
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	CALL SUBOPT_0x42
; 0000 0B48             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0B49             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0B4A             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x583
; 0000 0B4B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B4C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B4D 
; 0000 0B4E             a[1] = a[0]+0x001;  //ster2
; 0000 0B4F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B50             a[6] = a[5]+0x001;  //okrag
; 0000 0B51             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B52 
; 0000 0B53     break;
; 0000 0B54 
; 0000 0B55 
; 0000 0B56     case 64:
_0xEF:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0xF0
; 0000 0B57 
; 0000 0B58             a[0] = 0x0EC;   //ster1
	LDI  R30,LOW(236)
	LDI  R31,HIGH(236)
	CALL SUBOPT_0x42
; 0000 0B59             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0B5A             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x61
; 0000 0B5B             a[5] = 0x190;   //delta okrag
; 0000 0B5C             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
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
; 0000 0B67     case 65:
_0xF0:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0xF1
; 0000 0B68 
; 0000 0B69             a[0] = 0x0CC;   //ster1
	LDI  R30,LOW(204)
	LDI  R31,HIGH(204)
	CALL SUBOPT_0x42
; 0000 0B6A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0B6B             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x64
; 0000 0B6C             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0B6D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B6E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0B6F 
; 0000 0B70             a[1] = a[0]+0x001;  //ster2
; 0000 0B71             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B72             a[6] = a[5]+0x001;  //okrag
; 0000 0B73             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B74 
; 0000 0B75     break;
; 0000 0B76 
; 0000 0B77 
; 0000 0B78     case 66:
_0xF1:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0xF2
; 0000 0B79 
; 0000 0B7A             a[0] = 0x0BC;   //ster1
	LDI  R30,LOW(188)
	LDI  R31,HIGH(188)
	CALL SUBOPT_0x42
; 0000 0B7B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0B7C             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0B7D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x65
; 0000 0B7E             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
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
; 0000 0B89     case 67:
_0xF2:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xF3
; 0000 0B8A 
; 0000 0B8B             a[0] = 0x09C;   //ster1
	LDI  R30,LOW(156)
	LDI  R31,HIGH(156)
	CALL SUBOPT_0x42
; 0000 0B8C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0B8D             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0B8E             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x583
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
; 0000 0B9A     case 68:
_0xF3:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0xF4
; 0000 0B9B 
; 0000 0B9C             a[0] = 0x07C;   //ster1
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	CALL SUBOPT_0x42
; 0000 0B9D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0B9E             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0B9F             a[5] = 0x199;   //delta okrag
	RJMP _0x583
; 0000 0BA0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BA1             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0BA2 
; 0000 0BA3             a[1] = a[0]+0x001;  //ster2
; 0000 0BA4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BA5             a[6] = a[5]+0x001;  //okrag
; 0000 0BA6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BA7 
; 0000 0BA8     break;
; 0000 0BA9 
; 0000 0BAA 
; 0000 0BAB     case 69:
_0xF4:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BRNE _0xF5
; 0000 0BAC 
; 0000 0BAD             a[0] = 0x0D2;   //ster1
	LDI  R30,LOW(210)
	LDI  R31,HIGH(210)
	CALL SUBOPT_0x42
; 0000 0BAE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0BAF             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x64
; 0000 0BB0             a[5] = 0x193;   //delta okrag
	RJMP _0x583
; 0000 0BB1             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BB2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0BB3 
; 0000 0BB4             a[1] = a[0]+0x001;  //ster2
; 0000 0BB5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BB6             a[6] = a[5]+0x001;  //okrag
; 0000 0BB7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BB8 
; 0000 0BB9     break;
; 0000 0BBA 
; 0000 0BBB 
; 0000 0BBC     case 70:
_0xF5:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BRNE _0xF6
; 0000 0BBD 
; 0000 0BBE             a[0] = 0x0E6;   //ster1
	LDI  R30,LOW(230)
	LDI  R31,HIGH(230)
	CALL SUBOPT_0x42
; 0000 0BBF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0BC0             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0BC1             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x65
; 0000 0BC2             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0BC3             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0BC4 
; 0000 0BC5             a[1] = a[0]+0x001;  //ster2
; 0000 0BC6             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BC7             a[6] = a[5]+0x001;  //okrag
; 0000 0BC8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BC9 
; 0000 0BCA     break;
; 0000 0BCB 
; 0000 0BCC 
; 0000 0BCD     case 71:
_0xF6:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BRNE _0xF7
; 0000 0BCE 
; 0000 0BCF             a[0] = 0x0B4;   //ster1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x42
; 0000 0BD0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0BD1             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0BD2             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5D
; 0000 0BD3             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BD4             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0BD5 
; 0000 0BD6             a[1] = a[0]+0x001;  //ster2
; 0000 0BD7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BD8             a[6] = a[5]+0x001;  //okrag
; 0000 0BD9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BDA 
; 0000 0BDB     break;
; 0000 0BDC 
; 0000 0BDD 
; 0000 0BDE     case 72:
_0xF7:
	CPI  R30,LOW(0x48)
	LDI  R26,HIGH(0x48)
	CPC  R31,R26
	BRNE _0xF8
; 0000 0BDF 
; 0000 0BE0             a[0] = 0x0AC;   //ster1
	LDI  R30,LOW(172)
	LDI  R31,HIGH(172)
	CALL SUBOPT_0x42
; 0000 0BE1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0BE2             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0BE3             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0BE4             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BE5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0BE6 
; 0000 0BE7             a[1] = a[0]+0x001;  //ster2
; 0000 0BE8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BE9             a[6] = a[5]+0x001;  //okrag
; 0000 0BEA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BEB 
; 0000 0BEC     break;
; 0000 0BED 
; 0000 0BEE 
; 0000 0BEF     case 73:
_0xF8:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BRNE _0xF9
; 0000 0BF0 
; 0000 0BF1             a[0] = 0x012;   //ster1
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CALL SUBOPT_0x42
; 0000 0BF2             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0BF3             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x5F
; 0000 0BF4             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5D
; 0000 0BF5             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BF6             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0BF7 
; 0000 0BF8             a[1] = a[0]+0x001;  //ster2
; 0000 0BF9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BFA             a[6] = a[5]+0x001;  //okrag
; 0000 0BFB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BFC 
; 0000 0BFD     break;
; 0000 0BFE 
; 0000 0BFF 
; 0000 0C00     case 74:
_0xF9:
	CPI  R30,LOW(0x4A)
	LDI  R26,HIGH(0x4A)
	CPC  R31,R26
	BRNE _0xFA
; 0000 0C01 
; 0000 0C02             a[0] = 0x0B2;   //ster1
	LDI  R30,LOW(178)
	LDI  R31,HIGH(178)
	CALL SUBOPT_0x42
; 0000 0C03             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0C04             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 0C05             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0C06             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C07             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0C08 
; 0000 0C09             a[1] = a[0]+0x001;  //ster2
; 0000 0C0A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C0B             a[6] = a[5]+0x001;  //okrag
; 0000 0C0C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C0D 
; 0000 0C0E     break;
; 0000 0C0F 
; 0000 0C10 
; 0000 0C11     case 75:
_0xFA:
	CPI  R30,LOW(0x4B)
	LDI  R26,HIGH(0x4B)
	CPC  R31,R26
	BRNE _0xFB
; 0000 0C12 
; 0000 0C13             a[0] = 0x10C;   //ster1
	LDI  R30,LOW(268)
	LDI  R31,HIGH(268)
	CALL SUBOPT_0x42
; 0000 0C14             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0C15             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5A
; 0000 0C16             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5D
; 0000 0C17             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C18             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0C19 
; 0000 0C1A             a[1] = a[0]+0x001;  //ster2
; 0000 0C1B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C1C             a[6] = a[5]+0x001;  //okrag
; 0000 0C1D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C1E 
; 0000 0C1F     break;
; 0000 0C20 
; 0000 0C21 
; 0000 0C22     case 76:
_0xFB:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0xFC
; 0000 0C23 
; 0000 0C24             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5E
; 0000 0C25             a[3] = 0x;    //ster4 INV druciak
; 0000 0C26             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0C27             a[5] = 0x;   //delta okrag
; 0000 0C28             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0C29             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0C2A 
; 0000 0C2B             a[1] = a[0]+0x001;  //ster2
; 0000 0C2C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C2D             a[6] = a[5]+0x001;  //okrag
; 0000 0C2E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C2F 
; 0000 0C30     break;
; 0000 0C31 
; 0000 0C32 
; 0000 0C33     case 77:
_0xFC:
	CPI  R30,LOW(0x4D)
	LDI  R26,HIGH(0x4D)
	CPC  R31,R26
	BRNE _0xFD
; 0000 0C34 
; 0000 0C35             a[0] = 0x026;   //ster1
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL SUBOPT_0x42
; 0000 0C36             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0C37             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x5F
; 0000 0C38             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x583
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
; 0000 0C43 
; 0000 0C44     case 78:
_0xFD:
	CPI  R30,LOW(0x4E)
	LDI  R26,HIGH(0x4E)
	CPC  R31,R26
	BRNE _0xFE
; 0000 0C45 
; 0000 0C46             a[0] = 0x11C;   //ster1
	LDI  R30,LOW(284)
	LDI  R31,HIGH(284)
	CALL SUBOPT_0x42
; 0000 0C47             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0C48             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x66
; 0000 0C49             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x583
; 0000 0C4A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C4B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C4C 
; 0000 0C4D             a[1] = a[0]+0x001;  //ster2
; 0000 0C4E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C4F             a[6] = a[5]+0x001;  //okrag
; 0000 0C50             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C51 
; 0000 0C52     break;
; 0000 0C53 
; 0000 0C54 
; 0000 0C55     case 79:
_0xFE:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0xFF
; 0000 0C56 
; 0000 0C57             a[0] = 0x112;   //ster1
	LDI  R30,LOW(274)
	LDI  R31,HIGH(274)
	CALL SUBOPT_0x42
; 0000 0C58             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0C59             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5A
; 0000 0C5A             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x583
; 0000 0C5B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C5C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C5D 
; 0000 0C5E             a[1] = a[0]+0x001;  //ster2
; 0000 0C5F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C60             a[6] = a[5]+0x001;  //okrag
; 0000 0C61             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C62 
; 0000 0C63     break;
; 0000 0C64 
; 0000 0C65     case 80:
_0xFF:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0x100
; 0000 0C66 
; 0000 0C67             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5E
; 0000 0C68             a[3] = 0x;    //ster4 INV druciak
; 0000 0C69             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0C6A             a[5] = 0x;   //delta okrag
; 0000 0C6B             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0C6C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0C6D 
; 0000 0C6E             a[1] = a[0]+0x001;  //ster2
; 0000 0C6F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C70             a[6] = a[5]+0x001;  //okrag
; 0000 0C71             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C72 
; 0000 0C73     break;
; 0000 0C74 
; 0000 0C75     case 81:
_0x100:
	CPI  R30,LOW(0x51)
	LDI  R26,HIGH(0x51)
	CPC  R31,R26
	BRNE _0x101
; 0000 0C76 
; 0000 0C77             a[0] = 0x0EA;   //ster1
	LDI  R30,LOW(234)
	LDI  R31,HIGH(234)
	CALL SUBOPT_0x42
; 0000 0C78             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0C79             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0C7A             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0C7B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C7C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0C7D 
; 0000 0C7E             a[1] = a[0]+0x001;  //ster2
; 0000 0C7F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C80             a[6] = a[5]+0x001;  //okrag
; 0000 0C81             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C82 
; 0000 0C83     break;
; 0000 0C84 
; 0000 0C85 
; 0000 0C86     case 82:
_0x101:
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BRNE _0x102
; 0000 0C87 
; 0000 0C88             a[0] = 0x0D8;   //ster1
	LDI  R30,LOW(216)
	LDI  R31,HIGH(216)
	CALL SUBOPT_0x42
; 0000 0C89             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0C8A             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x68
; 0000 0C8B             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0C8C             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C8D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0C8E 
; 0000 0C8F             a[1] = a[0]+0x001;  //ster2
; 0000 0C90             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C91             a[6] = a[5]+0x001;  //okrag
; 0000 0C92             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C93 
; 0000 0C94     break;
; 0000 0C95 
; 0000 0C96 
; 0000 0C97     case 83:
_0x102:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x103
; 0000 0C98 
; 0000 0C99             a[0] = 0x08C;   //ster1
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	CALL SUBOPT_0x42
; 0000 0C9A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0C9B             a[4] = 0x22;    //ster3 ABS krazek scierny
	LDI  R26,LOW(34)
	LDI  R27,HIGH(34)
	CALL SUBOPT_0x69
; 0000 0C9C             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x583
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
; 0000 0CA7 
; 0000 0CA8     case 84:
_0x103:
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x104
; 0000 0CA9 
; 0000 0CAA             a[0] = 0x0A0;   //ster1
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	CALL SUBOPT_0x42
; 0000 0CAB             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x6A
; 0000 0CAC             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0CAD             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6B
; 0000 0CAE             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x581
; 0000 0CAF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CB0 
; 0000 0CB1             a[1] = a[0]+0x001;  //ster2
; 0000 0CB2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CB3             a[6] = a[5]+0x001;  //okrag
; 0000 0CB4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CB5 
; 0000 0CB6     break;
; 0000 0CB7 
; 0000 0CB8 
; 0000 0CB9    case 85:
_0x104:
	CPI  R30,LOW(0x55)
	LDI  R26,HIGH(0x55)
	CPC  R31,R26
	BRNE _0x105
; 0000 0CBA 
; 0000 0CBB             a[0] = 0x0AE;   //ster1
	LDI  R30,LOW(174)
	LDI  R31,HIGH(174)
	CALL SUBOPT_0x42
; 0000 0CBC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0CBD             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0CBE             a[5] = 0x193;   //delta okrag
	RJMP _0x583
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
; 0000 0CC9     case 86:
_0x105:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BRNE _0x106
; 0000 0CCA 
; 0000 0CCB             a[0] = 0x0F6;   //ster1
	LDI  R30,LOW(246)
	LDI  R31,HIGH(246)
	CALL SUBOPT_0x42
; 0000 0CCC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0CCD             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x68
; 0000 0CCE             a[5] = 0x190;   //delta okrag
	RJMP _0x583
; 0000 0CCF             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CD0             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CD1 
; 0000 0CD2             a[1] = a[0]+0x001;  //ster2
; 0000 0CD3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CD4             a[6] = a[5]+0x001;  //okrag
; 0000 0CD5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CD6 
; 0000 0CD7     break;
; 0000 0CD8 
; 0000 0CD9 
; 0000 0CDA     case 87:
_0x106:
	CPI  R30,LOW(0x57)
	LDI  R26,HIGH(0x57)
	CPC  R31,R26
	BRNE _0x107
; 0000 0CDB 
; 0000 0CDC             a[0] = 0x0C4;   //ster1
	LDI  R30,LOW(196)
	LDI  R31,HIGH(196)
	CALL SUBOPT_0x42
; 0000 0CDD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0CDE             a[4] = 0x23;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6C
; 0000 0CDF             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x53
; 0000 0CE0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CE1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0CE2 
; 0000 0CE3             a[1] = a[0]+0x001;  //ster2
; 0000 0CE4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CE5             a[6] = a[5]+0x001;  //okrag
; 0000 0CE6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CE7 
; 0000 0CE8     break;
; 0000 0CE9 
; 0000 0CEA 
; 0000 0CEB     case 88:
_0x107:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x108
; 0000 0CEC 
; 0000 0CED             a[0] = 0x07E;   //ster1
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	CALL SUBOPT_0x42
; 0000 0CEE             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x6A
; 0000 0CEF             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0CF0             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6B
; 0000 0CF1             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0CF2             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x47
	RJMP _0x582
; 0000 0CF3 
; 0000 0CF4             a[1] = a[0]+0x001;  //ster2
; 0000 0CF5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CF6             a[6] = a[5]+0x001;  //okrag
; 0000 0CF7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CF8 
; 0000 0CF9     break;
; 0000 0CFA 
; 0000 0CFB 
; 0000 0CFC     case 89:
_0x108:
	CPI  R30,LOW(0x59)
	LDI  R26,HIGH(0x59)
	CPC  R31,R26
	BRNE _0x109
; 0000 0CFD 
; 0000 0CFE             a[0] = 0x02C;   //ster1
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x42
; 0000 0CFF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0D00             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0D01             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5D
; 0000 0D02             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D03             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0D04 
; 0000 0D05             a[1] = a[0]+0x001;  //ster2
; 0000 0D06             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D07             a[6] = a[5]+0x001;  //okrag
; 0000 0D08             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D09 
; 0000 0D0A     break;
; 0000 0D0B 
; 0000 0D0C 
; 0000 0D0D     case 90:
_0x109:
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BRNE _0x10A
; 0000 0D0E 
; 0000 0D0F             a[0] = 0x0F0;   //ster1
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	CALL SUBOPT_0x42
; 0000 0D10             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0D11             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0D12             a[5] = 0x196;   //delta okrag
; 0000 0D13             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 0D14             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D15 
; 0000 0D16             a[1] = a[0]+0x001;  //ster2
; 0000 0D17             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D18             a[6] = a[5]+0x001;  //okrag
; 0000 0D19             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D1A 
; 0000 0D1B     break;
; 0000 0D1C 
; 0000 0D1D 
; 0000 0D1E     case 91:
_0x10A:
	CPI  R30,LOW(0x5B)
	LDI  R26,HIGH(0x5B)
	CPC  R31,R26
	BRNE _0x10B
; 0000 0D1F 
; 0000 0D20             a[0] = 0x0A8;   //ster1
	LDI  R30,LOW(168)
	LDI  R31,HIGH(168)
	CALL SUBOPT_0x42
; 0000 0D21             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0D22             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 0D23             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x583
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
; 0000 0D2F     case 92:
_0x10B:
	CPI  R30,LOW(0x5C)
	LDI  R26,HIGH(0x5C)
	CPC  R31,R26
	BRNE _0x10C
; 0000 0D30 
; 0000 0D31             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5E
; 0000 0D32             a[3] = 0x;    //ster4 INV druciak
; 0000 0D33             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0D34             a[5] = 0x;   //delta okrag
; 0000 0D35             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0D36             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0D37 
; 0000 0D38             a[1] = a[0]+0x001;  //ster2
; 0000 0D39             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D3A             a[6] = a[5]+0x001;  //okrag
; 0000 0D3B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D3C 
; 0000 0D3D     break;
; 0000 0D3E 
; 0000 0D3F 
; 0000 0D40     case 93:
_0x10C:
	CPI  R30,LOW(0x5D)
	LDI  R26,HIGH(0x5D)
	CPC  R31,R26
	BRNE _0x10D
; 0000 0D41 
; 0000 0D42             a[0] = 0x030;   //ster1
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x42
; 0000 0D43             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0D44             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x63
; 0000 0D45             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x583
; 0000 0D46             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D47             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D48 
; 0000 0D49             a[1] = a[0]+0x001;  //ster2
; 0000 0D4A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D4B             a[6] = a[5]+0x001;  //okrag
; 0000 0D4C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D4D 
; 0000 0D4E     break;
; 0000 0D4F 
; 0000 0D50 
; 0000 0D51     case 94:
_0x10D:
	CPI  R30,LOW(0x5E)
	LDI  R26,HIGH(0x5E)
	CPC  R31,R26
	BRNE _0x10E
; 0000 0D52 
; 0000 0D53             a[0] = 0x0F4;   //ster1
	LDI  R30,LOW(244)
	LDI  R31,HIGH(244)
	CALL SUBOPT_0x42
; 0000 0D54             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0D55             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0D56             a[5] = 0x196;   //delta okrag
; 0000 0D57             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0D58             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0D59 
; 0000 0D5A             a[1] = a[0]+0x001;  //ster2
; 0000 0D5B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D5C             a[6] = a[5]+0x001;  //okrag
; 0000 0D5D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D5E 
; 0000 0D5F     break;
; 0000 0D60 
; 0000 0D61 
; 0000 0D62     case 95:
_0x10E:
	CPI  R30,LOW(0x5F)
	LDI  R26,HIGH(0x5F)
	CPC  R31,R26
	BRNE _0x10F
; 0000 0D63 
; 0000 0D64             a[0] = 0x09E;   //ster1
	LDI  R30,LOW(158)
	LDI  R31,HIGH(158)
	CALL SUBOPT_0x42
; 0000 0D65             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0D66             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0D67             a[5] = 0x199;   //delta okrag
; 0000 0D68             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D69             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0D6A 
; 0000 0D6B             a[1] = a[0]+0x001;  //ster2
; 0000 0D6C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D6D             a[6] = a[5]+0x001;  //okrag
; 0000 0D6E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D6F 
; 0000 0D70     break;
; 0000 0D71 
; 0000 0D72     case 96:
_0x10F:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x110
; 0000 0D73 
; 0000 0D74             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5E
; 0000 0D75             a[3] = 0x;    //ster4 INV druciak
; 0000 0D76             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0D77             a[5] = 0x;   //delta okrag
; 0000 0D78             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0D79             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0D7A 
; 0000 0D7B             a[1] = a[0]+0x001;  //ster2
; 0000 0D7C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D7D             a[6] = a[5]+0x001;  //okrag
; 0000 0D7E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D7F 
; 0000 0D80     break;
; 0000 0D81 
; 0000 0D82 
; 0000 0D83     case 97:
_0x110:
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BRNE _0x111
; 0000 0D84 
; 0000 0D85             a[0] = 0x06A;   //ster1
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	CALL SUBOPT_0x42
; 0000 0D86             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0D87             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0D88             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0D89             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D8A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0D8B 
; 0000 0D8C             a[1] = a[0]+0x001;  //ster2
; 0000 0D8D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D8E             a[6] = a[5]+0x001;  //okrag
; 0000 0D8F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D90 
; 0000 0D91     break;
; 0000 0D92 
; 0000 0D93 
; 0000 0D94     case 98:
_0x111:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x112
; 0000 0D95 
; 0000 0D96             a[0] = 0x0BE;   //ster1
	LDI  R30,LOW(190)
	LDI  R31,HIGH(190)
	CALL SUBOPT_0x42
; 0000 0D97             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0D98             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0D99             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6D
; 0000 0D9A             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0D9B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0D9C 
; 0000 0D9D             a[1] = a[0]+0x001;  //ster2
; 0000 0D9E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D9F             a[6] = a[5]+0x001;  //okrag
; 0000 0DA0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DA1 
; 0000 0DA2     break;
; 0000 0DA3 
; 0000 0DA4 
; 0000 0DA5     case 99:
_0x112:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x113
; 0000 0DA6 
; 0000 0DA7             a[0] = 0x0BA;   //ster1
	LDI  R30,LOW(186)
	LDI  R31,HIGH(186)
	CALL SUBOPT_0x42
; 0000 0DA8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0DA9             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x66
; 0000 0DAA             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x583
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
; 0000 0DB6     case 100:
_0x113:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRNE _0x114
; 0000 0DB7 
; 0000 0DB8             a[0] = 0x060;   //ster1
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x42
; 0000 0DB9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0DBA             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 0DBB             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x49
; 0000 0DBC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DBD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0DBE 
; 0000 0DBF             a[1] = a[0]+0x001;  //ster2
; 0000 0DC0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DC1             a[6] = a[5]+0x001;  //okrag
; 0000 0DC2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DC3 
; 0000 0DC4     break;
; 0000 0DC5 
; 0000 0DC6 
; 0000 0DC7     case 101:
_0x114:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x115
; 0000 0DC8 
; 0000 0DC9             a[0] = 0x070;   //ster1
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	CALL SUBOPT_0x42
; 0000 0DCA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0DCB             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0DCC             a[5] = 0x199;   //delta okrag
	RJMP _0x583
; 0000 0DCD             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DCE             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DCF 
; 0000 0DD0             a[1] = a[0]+0x001;  //ster2
; 0000 0DD1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DD2             a[6] = a[5]+0x001;  //okrag
; 0000 0DD3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DD4 
; 0000 0DD5     break;
; 0000 0DD6 
; 0000 0DD7 
; 0000 0DD8     case 102:
_0x115:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BRNE _0x116
; 0000 0DD9 
; 0000 0DDA             a[0] = 0x08A;   //ster1
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	CALL SUBOPT_0x42
; 0000 0DDB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0DDC             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0DDD             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6D
; 0000 0DDE             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x581
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
; 0000 0DE9     case 103:
_0x116:
	CPI  R30,LOW(0x67)
	LDI  R26,HIGH(0x67)
	CPC  R31,R26
	BRNE _0x117
; 0000 0DEA 
; 0000 0DEB             a[0] = 0x080;   //ster1
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CALL SUBOPT_0x42
; 0000 0DEC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0DED             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x66
; 0000 0DEE             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x53
; 0000 0DEF             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DF0             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0DF1 
; 0000 0DF2             a[1] = a[0]+0x001;  //ster2
; 0000 0DF3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DF4             a[6] = a[5]+0x001;  //okrag
; 0000 0DF5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DF6 
; 0000 0DF7     break;
; 0000 0DF8 
; 0000 0DF9 
; 0000 0DFA     case 104:
_0x117:
	CPI  R30,LOW(0x68)
	LDI  R26,HIGH(0x68)
	CPC  R31,R26
	BRNE _0x118
; 0000 0DFB 
; 0000 0DFC             a[0] = 0x0B6;   //ster1
	LDI  R30,LOW(182)
	LDI  R31,HIGH(182)
	CALL SUBOPT_0x42
; 0000 0DFD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0DFE             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 0DFF             a[5] = 0x196;   //delta okrag
	RJMP _0x583
; 0000 0E00             a[7] = 0x12;    //ster3 INV krazek scierny
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
; 0000 0E0B     case 105:
_0x118:
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x119
; 0000 0E0C 
; 0000 0E0D             a[0] = 0x044;   //ster1
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	CALL SUBOPT_0x42
; 0000 0E0E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0E0F             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6E
; 0000 0E10             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x54
; 0000 0E11             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0E12             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0E13 
; 0000 0E14             a[1] = a[0]+0x001;  //ster2
; 0000 0E15             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E16             a[6] = a[5]+0x001;  //okrag
; 0000 0E17             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E18 
; 0000 0E19     break;
; 0000 0E1A 
; 0000 0E1B 
; 0000 0E1C     case 106:
_0x119:
	CPI  R30,LOW(0x6A)
	LDI  R26,HIGH(0x6A)
	CPC  R31,R26
	BRNE _0x11A
; 0000 0E1D 
; 0000 0E1E             a[0] = 0x03A;   //ster1
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	CALL SUBOPT_0x42
; 0000 0E1F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0E20             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0E21             a[5] = 0x190;   //delta okrag
; 0000 0E22             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 0E23             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E24 
; 0000 0E25             a[1] = a[0]+0x001;  //ster2
; 0000 0E26             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E27             a[6] = a[5]+0x001;  //okrag
; 0000 0E28             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E29 
; 0000 0E2A     break;
; 0000 0E2B 
; 0000 0E2C 
; 0000 0E2D     case 107:
_0x11A:
	CPI  R30,LOW(0x6B)
	LDI  R26,HIGH(0x6B)
	CPC  R31,R26
	BRNE _0x11B
; 0000 0E2E 
; 0000 0E2F             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5E
; 0000 0E30             a[3] = 0x;    //ster4 INV druciak
; 0000 0E31             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0E32             a[5] = 0x;   //delta okrag
; 0000 0E33             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0E34             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0E35 
; 0000 0E36             a[1] = a[0]+0x001;  //ster2
; 0000 0E37             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E38             a[6] = a[5]+0x001;  //okrag
; 0000 0E39             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E3A 
; 0000 0E3B     break;
; 0000 0E3C 
; 0000 0E3D 
; 0000 0E3E     case 108:
_0x11B:
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BRNE _0x11C
; 0000 0E3F 
; 0000 0E40             a[0] = 0x0C6;   //ster1
	LDI  R30,LOW(198)
	LDI  R31,HIGH(198)
	CALL SUBOPT_0x42
; 0000 0E41             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0E42             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0E43             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x65
; 0000 0E44             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0E45             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0E46 
; 0000 0E47             a[1] = a[0]+0x001;  //ster2
; 0000 0E48             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E49             a[6] = a[5]+0x001;  //okrag
; 0000 0E4A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E4B 
; 0000 0E4C     break;
; 0000 0E4D 
; 0000 0E4E 
; 0000 0E4F     case 109:
_0x11C:
	CPI  R30,LOW(0x6D)
	LDI  R26,HIGH(0x6D)
	CPC  R31,R26
	BRNE _0x11D
; 0000 0E50 
; 0000 0E51             a[0] = 0x00A;   //ster1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x42
; 0000 0E52             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0E53             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x46
; 0000 0E54             a[5] = 0x190;   //delta okrag
; 0000 0E55             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x581
; 0000 0E56             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E57 
; 0000 0E58             a[1] = a[0]+0x001;  //ster2
; 0000 0E59             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E5A             a[6] = a[5]+0x001;  //okrag
; 0000 0E5B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E5C 
; 0000 0E5D     break;
; 0000 0E5E 
; 0000 0E5F 
; 0000 0E60     case 110:
_0x11D:
	CPI  R30,LOW(0x6E)
	LDI  R26,HIGH(0x6E)
	CPC  R31,R26
	BRNE _0x11E
; 0000 0E61 
; 0000 0E62             a[0] = 0x032;   //ster1
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x42
; 0000 0E63             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0E64             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0E65             a[5] = 0x190;   //delta okrag
; 0000 0E66             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0E67             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0E68 
; 0000 0E69             a[1] = a[0]+0x001;  //ster2
; 0000 0E6A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E6B             a[6] = a[5]+0x001;  //okrag
; 0000 0E6C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E6D 
; 0000 0E6E     break;
; 0000 0E6F 
; 0000 0E70 
; 0000 0E71     case 111:
_0x11E:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x11F
; 0000 0E72 
; 0000 0E73             a[0] = 0x;   //ster1
	CALL SUBOPT_0x5E
; 0000 0E74             a[3] = 0x;    //ster4 INV druciak
; 0000 0E75             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0E76             a[5] = 0x;   //delta okrag
; 0000 0E77             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0E78             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0E79 
; 0000 0E7A             a[1] = a[0]+0x001;  //ster2
; 0000 0E7B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E7C             a[6] = a[5]+0x001;  //okrag
; 0000 0E7D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E7E 
; 0000 0E7F     break;
; 0000 0E80 
; 0000 0E81 
; 0000 0E82     case 112:
_0x11F:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x120
; 0000 0E83 
; 0000 0E84             a[0] = 0x0E2;   //ster1
	LDI  R30,LOW(226)
	LDI  R31,HIGH(226)
	CALL SUBOPT_0x42
; 0000 0E85             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0E86             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0E87             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x65
; 0000 0E88             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 0E89             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E8A 
; 0000 0E8B             a[1] = a[0]+0x001;  //ster2
; 0000 0E8C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E8D             a[6] = a[5]+0x001;  //okrag
; 0000 0E8E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E8F 
; 0000 0E90     break;
; 0000 0E91 
; 0000 0E92 
; 0000 0E93     case 113:
_0x120:
	CPI  R30,LOW(0x71)
	LDI  R26,HIGH(0x71)
	CPC  R31,R26
	BRNE _0x121
; 0000 0E94 
; 0000 0E95             a[0] = 0x0D4;   //ster1
	LDI  R30,LOW(212)
	LDI  R31,HIGH(212)
	CALL SUBOPT_0x42
; 0000 0E96             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0E97             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6F
; 0000 0E98             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x65
; 0000 0E99             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0E9A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0E9B 
; 0000 0E9C             a[1] = a[0]+0x001;  //ster2
; 0000 0E9D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E9E             a[6] = a[5]+0x001;  //okrag
; 0000 0E9F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EA0 
; 0000 0EA1     break;
; 0000 0EA2 
; 0000 0EA3 
; 0000 0EA4     case 114:
_0x121:
	CPI  R30,LOW(0x72)
	LDI  R26,HIGH(0x72)
	CPC  R31,R26
	BRNE _0x122
; 0000 0EA5 
; 0000 0EA6             a[0] = 0x04A;   //ster1
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	CALL SUBOPT_0x42
; 0000 0EA7             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0EA8             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x70
; 0000 0EA9             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6B
; 0000 0EAA             a[7] = 0x0F;    //ster3 INV krazek scierny
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	CALL SUBOPT_0x4B
; 0000 0EAB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0EAC 
; 0000 0EAD             a[1] = a[0]+0x001;  //ster2
; 0000 0EAE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EAF             a[6] = a[5]+0x001;  //okrag
; 0000 0EB0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EB1 
; 0000 0EB2     break;
; 0000 0EB3 
; 0000 0EB4 
; 0000 0EB5     case 115:
_0x122:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x123
; 0000 0EB6 
; 0000 0EB7             a[0] = 0x076;   //ster1
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	CALL SUBOPT_0x42
; 0000 0EB8             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x71
; 0000 0EB9             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0EBA             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x4C
; 0000 0EBB             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0EBC             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0EBD 
; 0000 0EBE             a[1] = a[0]+0x001;  //ster2
; 0000 0EBF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EC0             a[6] = a[5]+0x001;  //okrag
; 0000 0EC1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EC2 
; 0000 0EC3     break;
; 0000 0EC4 
; 0000 0EC5 
; 0000 0EC6     case 116:
_0x123:
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BRNE _0x124
; 0000 0EC7 
; 0000 0EC8             a[0] = 0x092;   //ster1
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	CALL SUBOPT_0x42
; 0000 0EC9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0ECA             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5A
; 0000 0ECB             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x583
; 0000 0ECC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0ECD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0ECE 
; 0000 0ECF             a[1] = a[0]+0x001;  //ster2
; 0000 0ED0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0ED1             a[6] = a[5]+0x001;  //okrag
; 0000 0ED2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ED3 
; 0000 0ED4     break;
; 0000 0ED5 
; 0000 0ED6 
; 0000 0ED7 
; 0000 0ED8     case 117:
_0x124:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x125
; 0000 0ED9 
; 0000 0EDA             a[0] = 0x11A;   //ster1
	LDI  R30,LOW(282)
	LDI  R31,HIGH(282)
	CALL SUBOPT_0x42
; 0000 0EDB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0EDC             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6F
; 0000 0EDD             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x65
; 0000 0EDE             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 0EDF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EE0 
; 0000 0EE1             a[1] = a[0]+0x001;  //ster2
; 0000 0EE2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EE3             a[6] = a[5]+0x001;  //okrag
; 0000 0EE4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EE5 
; 0000 0EE6     break;
; 0000 0EE7 
; 0000 0EE8 
; 0000 0EE9 
; 0000 0EEA     case 118:
_0x125:
	CPI  R30,LOW(0x76)
	LDI  R26,HIGH(0x76)
	CPC  R31,R26
	BRNE _0x126
; 0000 0EEB 
; 0000 0EEC             a[0] = 0x056;   //ster1
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	CALL SUBOPT_0x42
; 0000 0EED             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0EEE             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x70
; 0000 0EEF             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x65
; 0000 0EF0             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 0EF1             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EF2 
; 0000 0EF3             a[1] = a[0]+0x001;  //ster2
; 0000 0EF4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EF5             a[6] = a[5]+0x001;  //okrag
; 0000 0EF6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EF7 
; 0000 0EF8     break;
; 0000 0EF9 
; 0000 0EFA 
; 0000 0EFB     case 119:
_0x126:
	CPI  R30,LOW(0x77)
	LDI  R26,HIGH(0x77)
	CPC  R31,R26
	BRNE _0x127
; 0000 0EFC 
; 0000 0EFD             a[0] = 0x072;   //ster1
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	CALL SUBOPT_0x42
; 0000 0EFE             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x71
; 0000 0EFF             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0F00             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x4C
; 0000 0F01             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 0F02             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F03 
; 0000 0F04             a[1] = a[0]+0x001;  //ster2
; 0000 0F05             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F06             a[6] = a[5]+0x001;  //okrag
; 0000 0F07             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F08 
; 0000 0F09     break;
; 0000 0F0A 
; 0000 0F0B 
; 0000 0F0C     case 120:
_0x127:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x128
; 0000 0F0D 
; 0000 0F0E             a[0] = 0x0D0;   //ster1
	LDI  R30,LOW(208)
	LDI  R31,HIGH(208)
	CALL SUBOPT_0x42
; 0000 0F0F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0F10             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5A
; 0000 0F11             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5D
; 0000 0F12             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F13             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0F14 
; 0000 0F15             a[1] = a[0]+0x001;  //ster2
; 0000 0F16             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F17             a[6] = a[5]+0x001;  //okrag
; 0000 0F18             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F19 
; 0000 0F1A     break;
; 0000 0F1B 
; 0000 0F1C 
; 0000 0F1D     case 121:
_0x128:
	CPI  R30,LOW(0x79)
	LDI  R26,HIGH(0x79)
	CPC  R31,R26
	BRNE _0x129
; 0000 0F1E 
; 0000 0F1F             a[0] = 0x048;   //ster1
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	CALL SUBOPT_0x42
; 0000 0F20             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0F21             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x70
; 0000 0F22             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x65
; 0000 0F23             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0F24             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0F25 
; 0000 0F26             a[1] = a[0]+0x001;  //ster2
; 0000 0F27             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F28             a[6] = a[5]+0x001;  //okrag
; 0000 0F29             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F2A 
; 0000 0F2B     break;
; 0000 0F2C 
; 0000 0F2D 
; 0000 0F2E     case 122:
_0x129:
	CPI  R30,LOW(0x7A)
	LDI  R26,HIGH(0x7A)
	CPC  R31,R26
	BRNE _0x12A
; 0000 0F2F 
; 0000 0F30             a[0] = 0x09A;   //ster1
	LDI  R30,LOW(154)
	LDI  R31,HIGH(154)
	CALL SUBOPT_0x42
; 0000 0F31             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0F32             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x66
; 0000 0F33             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5D
; 0000 0F34             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F35             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0F36 
; 0000 0F37             a[1] = a[0]+0x001;  //ster2
; 0000 0F38             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F39             a[6] = a[5]+0x001;  //okrag
; 0000 0F3A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F3B 
; 0000 0F3C     break;
; 0000 0F3D 
; 0000 0F3E 
; 0000 0F3F     case 123:
_0x12A:
	CPI  R30,LOW(0x7B)
	LDI  R26,HIGH(0x7B)
	CPC  R31,R26
	BRNE _0x12B
; 0000 0F40 
; 0000 0F41             a[0] = 0x046;   //ster1
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL SUBOPT_0x42
; 0000 0F42             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0F43             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x72
; 0000 0F44             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x73
; 0000 0F45             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0F46             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0F47 
; 0000 0F48             a[1] = a[0]+0x001;  //ster2
; 0000 0F49             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F4A             a[6] = a[5]+0x001;  //okrag
; 0000 0F4B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F4C 
; 0000 0F4D     break;
; 0000 0F4E 
; 0000 0F4F 
; 0000 0F50 
; 0000 0F51     case 124:
_0x12B:
	CPI  R30,LOW(0x7C)
	LDI  R26,HIGH(0x7C)
	CPC  R31,R26
	BRNE _0x12C
; 0000 0F52 
; 0000 0F53             a[0] = 0x0E0;   //ster1
	LDI  R30,LOW(224)
	LDI  R31,HIGH(224)
	CALL SUBOPT_0x42
; 0000 0F54             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x74
; 0000 0F55             a[4] = 0x15;    //ster3 ABS krazek scierny
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL SUBOPT_0x69
; 0000 0F56             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6B
; 0000 0F57             a[7] = 0x13;    //ster3 INV krazek scierny
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	CALL SUBOPT_0x4B
; 0000 0F58             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0F59 
; 0000 0F5A             a[1] = a[0]+0x001;  //ster2
; 0000 0F5B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F5C             a[6] = a[5]+0x001;  //okrag
; 0000 0F5D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F5E 
; 0000 0F5F     break;
; 0000 0F60 
; 0000 0F61 
; 0000 0F62     case 125:
_0x12C:
	CPI  R30,LOW(0x7D)
	LDI  R26,HIGH(0x7D)
	CPC  R31,R26
	BRNE _0x12D
; 0000 0F63 
; 0000 0F64             a[0] = 0x038;   //ster1
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	CALL SUBOPT_0x42
; 0000 0F65             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0F66             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x66
; 0000 0F67             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x65
; 0000 0F68             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
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
; 0000 0F73     case 126:
_0x12D:
	CPI  R30,LOW(0x7E)
	LDI  R26,HIGH(0x7E)
	CPC  R31,R26
	BRNE _0x12E
; 0000 0F74 
; 0000 0F75             a[0] = 0x0CA;   //ster1
	LDI  R30,LOW(202)
	LDI  R31,HIGH(202)
	CALL SUBOPT_0x42
; 0000 0F76             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0F77             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x66
; 0000 0F78             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x583
; 0000 0F79             a[7] = 0x12;    //ster3 INV krazek scierny
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
; 0000 0F84     case 127:
_0x12E:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0x12F
; 0000 0F85 
; 0000 0F86             a[0] = 0x0DE;   //ster1
	LDI  R30,LOW(222)
	LDI  R31,HIGH(222)
	CALL SUBOPT_0x42
; 0000 0F87             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0F88             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x72
; 0000 0F89             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x73
; 0000 0F8A             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 0F8B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F8C 
; 0000 0F8D             a[1] = a[0]+0x001;  //ster2
; 0000 0F8E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F8F             a[6] = a[5]+0x001;  //okrag
; 0000 0F90             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F91 
; 0000 0F92     break;
; 0000 0F93 
; 0000 0F94 
; 0000 0F95     case 128:
_0x12F:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x130
; 0000 0F96 
; 0000 0F97             a[0] = 0x116;   //ster1
	LDI  R30,LOW(278)
	LDI  R31,HIGH(278)
	CALL SUBOPT_0x42
; 0000 0F98             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 0F99             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x48
; 0000 0F9A             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x75
; 0000 0F9B             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 0F9C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F9D 
; 0000 0F9E             a[1] = a[0]+0x001;  //ster2
; 0000 0F9F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FA0             a[6] = a[5]+0x001;  //okrag
; 0000 0FA1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FA2 
; 0000 0FA3     break;
; 0000 0FA4 
; 0000 0FA5 
; 0000 0FA6     case 129:
_0x130:
	CPI  R30,LOW(0x81)
	LDI  R26,HIGH(0x81)
	CPC  R31,R26
	BRNE _0x131
; 0000 0FA7 
; 0000 0FA8             a[0] = 0x0E8;   //ster1
	LDI  R30,LOW(232)
	LDI  R31,HIGH(232)
	CALL SUBOPT_0x42
; 0000 0FA9             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x74
; 0000 0FAA             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x76
; 0000 0FAB             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x75
; 0000 0FAC             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 0FAD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0FAE 
; 0000 0FAF             a[1] = a[0]+0x001;  //ster2
; 0000 0FB0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FB1             a[6] = a[5]+0x001;  //okrag
; 0000 0FB2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FB3 
; 0000 0FB4     break;
; 0000 0FB5 
; 0000 0FB6 
; 0000 0FB7     case 130:
_0x131:
	CPI  R30,LOW(0x82)
	LDI  R26,HIGH(0x82)
	CPC  R31,R26
	BRNE _0x132
; 0000 0FB8 
; 0000 0FB9             a[0] = 0x0F2;   //ster1
	LDI  R30,LOW(242)
	LDI  R31,HIGH(242)
	CALL SUBOPT_0x42
; 0000 0FBA             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x77
; 0000 0FBB             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0FBC             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6B
; 0000 0FBD             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0FBE             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x47
	RJMP _0x582
; 0000 0FBF 
; 0000 0FC0             a[1] = a[0]+0x001;  //ster2
; 0000 0FC1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FC2             a[6] = a[5]+0x001;  //okrag
; 0000 0FC3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FC4 
; 0000 0FC5     break;
; 0000 0FC6 
; 0000 0FC7 
; 0000 0FC8     case 131:
_0x132:
	CPI  R30,LOW(0x83)
	LDI  R26,HIGH(0x83)
	CPC  R31,R26
	BRNE _0x133
; 0000 0FC9 
; 0000 0FCA             a[0] = 0x108;   //ster1
	LDI  R30,LOW(264)
	LDI  R31,HIGH(264)
	CALL SUBOPT_0x42
; 0000 0FCB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0FCC             a[4] = 0x1F;    //ster3 ABS krazek scierny
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP _0x584
; 0000 0FCD             a[5] = 0x19C;   //delta okrag
; 0000 0FCE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FCF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FD0 
; 0000 0FD1             a[1] = a[0]+0x001;  //ster2
; 0000 0FD2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FD3             a[6] = a[5]+0x001;  //okrag
; 0000 0FD4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FD5 
; 0000 0FD6     break;
; 0000 0FD7 
; 0000 0FD8 
; 0000 0FD9 
; 0000 0FDA     case 132:
_0x133:
	CPI  R30,LOW(0x84)
	LDI  R26,HIGH(0x84)
	CPC  R31,R26
	BRNE _0x134
; 0000 0FDB 
; 0000 0FDC             a[0] = 0x064;   //ster1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x42
; 0000 0FDD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0FDE             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x62
; 0000 0FDF             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x5B
; 0000 0FE0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FE1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 0FE2 
; 0000 0FE3             a[1] = a[0]+0x001;  //ster2
; 0000 0FE4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FE5             a[6] = a[5]+0x001;  //okrag
; 0000 0FE6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FE7 
; 0000 0FE8     break;
; 0000 0FE9 
; 0000 0FEA 
; 0000 0FEB     case 133:
_0x134:
	CPI  R30,LOW(0x85)
	LDI  R26,HIGH(0x85)
	CPC  R31,R26
	BRNE _0x135
; 0000 0FEC 
; 0000 0FED             a[0] = 0x088;   //ster1
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	CALL SUBOPT_0x42
; 0000 0FEE             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x74
; 0000 0FEF             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x76
; 0000 0FF0             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x75
; 0000 0FF1             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 0FF2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FF3 
; 0000 0FF4             a[1] = a[0]+0x001;  //ster2
; 0000 0FF5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FF6             a[6] = a[5]+0x001;  //okrag
; 0000 0FF7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FF8 
; 0000 0FF9     break;
; 0000 0FFA 
; 0000 0FFB 
; 0000 0FFC 
; 0000 0FFD     case 134:
_0x135:
	CPI  R30,LOW(0x86)
	LDI  R26,HIGH(0x86)
	CPC  R31,R26
	BRNE _0x136
; 0000 0FFE 
; 0000 0FFF             a[0] = 0x10E;   //ster1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x42
; 0000 1000             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x77
; 0000 1001             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 1002             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6B
; 0000 1003             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x581
; 0000 1004             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1005 
; 0000 1006             a[1] = a[0]+0x001;  //ster2
; 0000 1007             a[2] = a[4];        //ster4 ABS druciak
; 0000 1008             a[6] = a[5]+0x001;  //okrag
; 0000 1009             a[8] = a[6]+0x001;  //-delta okrag
; 0000 100A 
; 0000 100B     break;
; 0000 100C 
; 0000 100D                ////////////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 100E      case 135:
_0x136:
	CPI  R30,LOW(0x87)
	LDI  R26,HIGH(0x87)
	CPC  R31,R26
	BRNE _0x137
; 0000 100F 
; 0000 1010             a[0] = 0x054;   //ster1
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CALL SUBOPT_0x42
; 0000 1011             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 1012             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6E
; 0000 1013             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x5B
; 0000 1014             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 1015             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 1016 
; 0000 1017             a[1] = a[0]+0x001;  //ster2
; 0000 1018             a[2] = a[4];        //ster4 ABS druciak
; 0000 1019             a[6] = a[5]+0x001;  //okrag
; 0000 101A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 101B 
; 0000 101C     break;
; 0000 101D 
; 0000 101E 
; 0000 101F      case 136:
_0x137:
	CPI  R30,LOW(0x88)
	LDI  R26,HIGH(0x88)
	CPC  R31,R26
	BRNE _0x138
; 0000 1020 
; 0000 1021             a[0] = 0x03E;   //ster1
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	CALL SUBOPT_0x42
; 0000 1022             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 1023             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x76
; 0000 1024             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x78
; 0000 1025             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x581
; 0000 1026             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1027 
; 0000 1028             a[1] = a[0]+0x001;  //ster2
; 0000 1029             a[2] = a[4];        //ster4 ABS druciak
; 0000 102A             a[6] = a[5]+0x001;  //okrag
; 0000 102B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 102C 
; 0000 102D     break;
; 0000 102E 
; 0000 102F      case 137:
_0x138:
	CPI  R30,LOW(0x89)
	LDI  R26,HIGH(0x89)
	CPC  R31,R26
	BRNE _0x139
; 0000 1030 
; 0000 1031             a[0] = 0x00C;   //ster1
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x42
; 0000 1032             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 1033             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 1034             a[5] = 0x190;   //delta okrag
; 0000 1035             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 1036             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 1037 
; 0000 1038             a[1] = a[0]+0x001;  //ster2
; 0000 1039             a[2] = a[4];        //ster4 ABS druciak
; 0000 103A             a[6] = a[5]+0x001;  //okrag
; 0000 103B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 103C 
; 0000 103D     break;
; 0000 103E 
; 0000 103F 
; 0000 1040      case 138:
_0x139:
	CPI  R30,LOW(0x8A)
	LDI  R26,HIGH(0x8A)
	CPC  R31,R26
	BRNE _0x13A
; 0000 1041 
; 0000 1042             a[0] = 0x0DC;   //ster1
	LDI  R30,LOW(220)
	LDI  R31,HIGH(220)
	CALL SUBOPT_0x42
; 0000 1043             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 1044             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x44
; 0000 1045             a[5] = 0x196;   //delta okrag
; 0000 1046             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 1047             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1048 
; 0000 1049             a[1] = a[0]+0x001;  //ster2
; 0000 104A             a[2] = a[4];        //ster4 ABS druciak
; 0000 104B             a[6] = a[5]+0x001;  //okrag
; 0000 104C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 104D 
; 0000 104E     break;
; 0000 104F 
; 0000 1050 
; 0000 1051      case 139:
_0x13A:
	CPI  R30,LOW(0x8B)
	LDI  R26,HIGH(0x8B)
	CPC  R31,R26
	BRNE _0x13B
; 0000 1052 
; 0000 1053             a[0] = 0x058;   //ster1
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	CALL SUBOPT_0x42
; 0000 1054             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 1055             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6F
; 0000 1056             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x583
; 0000 1057             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 1058             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1059 
; 0000 105A             a[1] = a[0]+0x001;  //ster2
; 0000 105B             a[2] = a[4];        //ster4 ABS druciak
; 0000 105C             a[6] = a[5]+0x001;  //okrag
; 0000 105D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 105E 
; 0000 105F     break;
; 0000 1060 
; 0000 1061 
; 0000 1062      case 140:
_0x13B:
	CPI  R30,LOW(0x8C)
	LDI  R26,HIGH(0x8C)
	CPC  R31,R26
	BRNE _0x13C
; 0000 1063 
; 0000 1064             a[0] = 0x03C;   //ster1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0x42
; 0000 1065             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 1066             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x72
; 0000 1067             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x78
; 0000 1068             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 1069             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x47
	RJMP _0x582
; 0000 106A 
; 0000 106B             a[1] = a[0]+0x001;  //ster2
; 0000 106C             a[2] = a[4];        //ster4 ABS druciak
; 0000 106D             a[6] = a[5]+0x001;  //okrag
; 0000 106E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 106F 
; 0000 1070 
; 0000 1071 
; 0000 1072     break;
; 0000 1073 
; 0000 1074 
; 0000 1075      case 141:
_0x13C:
	CPI  R30,LOW(0x8D)
	LDI  R26,HIGH(0x8D)
	CPC  R31,R26
	BRNE _0x13D
; 0000 1076 
; 0000 1077             a[0] = 0x00E;   //ster1
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x42
; 0000 1078             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 1079             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 107A             a[5] = 0x190;   //delta okrag
; 0000 107B             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x581
; 0000 107C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 107D 
; 0000 107E             a[1] = a[0]+0x001;  //ster2
; 0000 107F             a[2] = a[4];        //ster4 ABS druciak
; 0000 1080             a[6] = a[5]+0x001;  //okrag
; 0000 1081             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1082 
; 0000 1083     break;
; 0000 1084 
; 0000 1085 
; 0000 1086      case 142:
_0x13D:
	CPI  R30,LOW(0x8E)
	LDI  R26,HIGH(0x8E)
	CPC  R31,R26
	BRNE _0x13E
; 0000 1087 
; 0000 1088             a[0] = 0x10A;   //ster1
	LDI  R30,LOW(266)
	LDI  R31,HIGH(266)
	CALL SUBOPT_0x42
; 0000 1089             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x45
; 0000 108A             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x44
; 0000 108B             a[5] = 0x196;   //delta okrag
; 0000 108C             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x4B
; 0000 108D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 108E 
; 0000 108F             a[1] = a[0]+0x001;  //ster2
; 0000 1090             a[2] = a[4];        //ster4 ABS druciak
; 0000 1091             a[6] = a[5]+0x001;  //okrag
; 0000 1092             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1093 
; 0000 1094     break;
; 0000 1095 
; 0000 1096 
; 0000 1097 
; 0000 1098      case 143:
_0x13E:
	CPI  R30,LOW(0x8F)
	LDI  R26,HIGH(0x8F)
	CPC  R31,R26
	BRNE _0x13F
; 0000 1099 
; 0000 109A             a[0] = 0x022;   //ster1
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL SUBOPT_0x42
; 0000 109B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 109C             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6F
; 0000 109D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5D
; 0000 109E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 109F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x582
; 0000 10A0 
; 0000 10A1             a[1] = a[0]+0x001;  //ster2
; 0000 10A2             a[2] = a[4];        //ster4 ABS druciak
; 0000 10A3             a[6] = a[5]+0x001;  //okrag
; 0000 10A4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 10A5 
; 0000 10A6     break;
; 0000 10A7 
; 0000 10A8 
; 0000 10A9      case 144:
_0x13F:
	CPI  R30,LOW(0x90)
	LDI  R26,HIGH(0x90)
	CPC  R31,R26
	BRNE _0xAF
; 0000 10AA 
; 0000 10AB             a[0] = 0x066;   //ster1
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	CALL SUBOPT_0x42
; 0000 10AC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 10AD             a[4] = 0x1C;    //ster3 ABS krazek scierny
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
_0x584:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 10AE             a[5] = 0x19C;   //delta okrag
	__POINTW1MN _a,10
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
_0x583:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 10AF             a[7] = 0x12;    //ster3 INV krazek scierny
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
_0x581:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 10B0             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	__POINTW1MN _a,18
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
_0x582:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 10B1 
; 0000 10B2             a[1] = a[0]+0x001;  //ster2
	CALL SUBOPT_0x79
	ADIW R30,1
	__PUTW1MN _a,2
; 0000 10B3             a[2] = a[4];        //ster4 ABS druciak
	CALL SUBOPT_0x7A
	__PUTW1MN _a,4
; 0000 10B4             a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x7C
; 0000 10B5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 10B6 
; 0000 10B7     break;
; 0000 10B8 
; 0000 10B9 
; 0000 10BA }
_0xAF:
; 0000 10BB 
; 0000 10BC //if(predkosc_pion_szczotka == 50)   //zwolnienie predkosci pion
; 0000 10BD //       {
; 0000 10BE //       a[3] = a[3] - 0x05;
; 0000 10BF //       }
; 0000 10C0 
; 0000 10C1 if(tryb_pracy_szczotki_drucianej == 1)
	CALL SUBOPT_0x7D
	BRNE _0x141
; 0000 10C2          a[3] = a[3];
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x7F
; 0000 10C3 
; 0000 10C4 if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)
_0x141:
	CALL SUBOPT_0x80
	BREQ _0x142
; 0000 10C5          a[3] = a[3]-0x05;
	CALL SUBOPT_0x7E
	SBIW R30,5
	CALL SUBOPT_0x7F
; 0000 10C6 
; 0000 10C7 //if(predkosc_pion_krazek == 50)   //zwolnienie predkosci pion krazek
; 0000 10C8 //       {
; 0000 10C9 //       a[7] = a[7] - 0x05;
; 0000 10CA //       }
; 0000 10CB 
; 0000 10CC a[3] = a[3]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT
_0x142:
	CALL SUBOPT_0x7E
	SBIW R30,6
	CALL SUBOPT_0x7F
; 0000 10CD a[2] = a[2]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT
	CALL SUBOPT_0x81
	SBIW R30,6
	__PUTW1MN _a,4
; 0000 10CE 
; 0000 10CF 
; 0000 10D0 
; 0000 10D1 if(krazek_scierny_cykl_po_okregu_ilosc == 0 | ruch_haos == 1)
	MOVW R26,R8
	CALL SUBOPT_0x82
	CALL SUBOPT_0x83
	CALL SUBOPT_0x84
	OR   R30,R0
	BREQ _0x143
; 0000 10D2         a[7] = a[7] - 0x05;
	CALL SUBOPT_0x85
	SBIW R30,5
	__PUTW1MN _a,14
; 0000 10D3 
; 0000 10D4 if(srednica_krazka_sciernego == 40)
_0x143:
	CALL SUBOPT_0x86
	SBIW R26,40
	BRNE _0x144
; 0000 10D5         a[4] = a[4]+ 0x13;
	CALL SUBOPT_0x7A
	ADIW R30,19
	__PUTW1MN _a,8
; 0000 10D6 
; 0000 10D7                                                      //2
; 0000 10D8 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 30)
_0x144:
	CALL SUBOPT_0x87
	CALL SUBOPT_0x84
	CALL SUBOPT_0x88
; 0000 10D9     {
; 0000 10DA     }
; 0000 10DB 
; 0000 10DC                                                    //2
; 0000 10DD if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 30)
	CALL SUBOPT_0x89
	CALL SUBOPT_0x88
	BREQ _0x146
; 0000 10DE     {
; 0000 10DF     a[5] = a[5] + 0x10;   //plus 16 dzesietnie
	CALL SUBOPT_0x7B
	ADIW R30,16
	CALL SUBOPT_0x8A
; 0000 10E0     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7C
; 0000 10E1     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10E2     }
; 0000 10E3                                                     //1
; 0000 10E4 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 30)
_0x146:
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x88
	BREQ _0x147
; 0000 10E5     {
; 0000 10E6     a[5] = a[5] + 0x20;   //plus 32 dzesietnie
	CALL SUBOPT_0x7B
	ADIW R30,32
	CALL SUBOPT_0x8A
; 0000 10E7     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7C
; 0000 10E8     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10E9     }
; 0000 10EA 
; 0000 10EB                                                     //2
; 0000 10EC if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 30)
_0x147:
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x88
	BREQ _0x148
; 0000 10ED     {
; 0000 10EE     a[5] = a[5] + 0x30;   //plus 48 dzesietnie
	CALL SUBOPT_0x7B
	ADIW R30,48
	CALL SUBOPT_0x8A
; 0000 10EF     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7C
; 0000 10F0     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10F1     }
; 0000 10F2 
; 0000 10F3 /////////////////////////////////////////////////////////////////////////////////////
; 0000 10F4 
; 0000 10F5 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 40)
_0x148:
	CALL SUBOPT_0x87
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	BREQ _0x149
; 0000 10F6     {
; 0000 10F7     a[5] = a[5] + 0x39;   //plus 66 dzesietnie   ///////////////
	CALL SUBOPT_0x7B
	ADIW R30,57
	CALL SUBOPT_0x8A
; 0000 10F8     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7C
; 0000 10F9     a[8] = a[6]+0x001;  //-delta okrag
; 0000 10FA     }
; 0000 10FB 
; 0000 10FC                                                    //2
; 0000 10FD if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 40)
_0x149:
	CALL SUBOPT_0x89
	CALL SUBOPT_0x8D
	BREQ _0x14A
; 0000 10FE     {
; 0000 10FF     a[5] = a[5] + 0x42;   //plus 16 dzesietnie
	CALL SUBOPT_0x7B
	SUBI R30,LOW(-66)
	SBCI R31,HIGH(-66)
	CALL SUBOPT_0x8A
; 0000 1100     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7C
; 0000 1101     a[8] = a[6]+0x001;  //-delta okrag
; 0000 1102     }
; 0000 1103                                                     //1
; 0000 1104 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 40)
_0x14A:
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x8D
	BREQ _0x14B
; 0000 1105     {
; 0000 1106     a[5] = a[5] + 0x4B;   //plus 32 dzesietnie
	CALL SUBOPT_0x7B
	SUBI R30,LOW(-75)
	SBCI R31,HIGH(-75)
	CALL SUBOPT_0x8A
; 0000 1107     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7C
; 0000 1108     a[8] = a[6]+0x001;  //-delta okrag
; 0000 1109     }
; 0000 110A 
; 0000 110B                                                     //2
; 0000 110C if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 40)
_0x14B:
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	BREQ _0x14C
; 0000 110D     {
; 0000 110E     a[5] = a[5] + 0x54;   //plus 48 dzesietnie
	CALL SUBOPT_0x7B
	SUBI R30,LOW(-84)
	SBCI R31,HIGH(-84)
	CALL SUBOPT_0x8A
; 0000 110F     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x7C
; 0000 1110     a[8] = a[6]+0x001;  //-delta okrag
; 0000 1111     }
; 0000 1112 
; 0000 1113 }
_0x14C:
	ADIW R28,2
	RET
;
;void obsluga_nacisniecia_zatrzymaj()
; 0000 1116 {
_obsluga_nacisniecia_zatrzymaj:
; 0000 1117 int sg;
; 0000 1118 sg = 0;
	CALL SUBOPT_0x1
;	sg -> R16,R17
; 0000 1119 
; 0000 111A   if(sek20 > 60)
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x8F
	BRGE PC+3
	JMP _0x14D
; 0000 111B    {
; 0000 111C    sek20 = 0;
	CALL SUBOPT_0x90
; 0000 111D    while(sprawdz_pin2(PORTMM,0x77) == 0)
_0x14E:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x150
; 0000 111E         {
; 0000 111F         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x91
; 0000 1120         PORTD.7 = 1;
; 0000 1121         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x153
; 0000 1122            {
; 0000 1123            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x92
; 0000 1124            PORTE.2 = 0;
; 0000 1125            }
; 0000 1126 
; 0000 1127         if(PORTE.3 == 1)
_0x153:
	SBIS 0x3,3
	RJMP _0x156
; 0000 1128            {
; 0000 1129            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x93
; 0000 112A            PORTE.3 = 0;
; 0000 112B            }
; 0000 112C 
; 0000 112D          if(PORT_F.bits.b4 == 1)
_0x156:
	CALL SUBOPT_0x94
	BRNE _0x159
; 0000 112E             {
; 0000 112F             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x95
; 0000 1130             zastopowany_czas_przedmuchu = sek12;
; 0000 1131             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1132             PORTF = PORT_F.byte;
; 0000 1133             }
; 0000 1134 
; 0000 1135 
; 0000 1136         komunikat_na_panel("                                                ",adr1,adr2);
_0x159:
	CALL SUBOPT_0x2C
; 0000 1137         komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr1,adr2);
	__POINTW1FN _0x0,1351
	CALL SUBOPT_0x2D
; 0000 1138         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 1139         komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr3,adr4);
	__POINTW1FN _0x0,1351
	CALL SUBOPT_0x97
; 0000 113A 
; 0000 113B         }
	RJMP _0x14E
_0x150:
; 0000 113C 
; 0000 113D     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x15A
; 0000 113E         {
; 0000 113F         while(sg == 0)
_0x15B:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x15D
; 0000 1140             {
; 0000 1141             if(sprawdz_pin2(PORTMM,0x77) == 1)
	CALL SUBOPT_0x14
	CALL _sprawdz_pin2
	CPI  R30,LOW(0x1)
	BRNE _0x15E
; 0000 1142                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x17
	MOVW R16,R30
; 0000 1143 
; 0000 1144 
; 0000 1145             }
_0x15E:
	RJMP _0x15B
_0x15D:
; 0000 1146 
; 0000 1147         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 1148         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 1149 
; 0000 114A         PORTD.7 = 0;
	CALL SUBOPT_0x98
; 0000 114B         if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x161
; 0000 114C             {
; 0000 114D             PORTE.2 = 1;
	CALL SUBOPT_0x99
; 0000 114E             byla_wloczona_szlifierka_1 = 0;
; 0000 114F             }
; 0000 1150         if(byla_wloczona_szlifierka_2 == 1)
_0x161:
	CALL SUBOPT_0x9A
	BRNE _0x164
; 0000 1151             {
; 0000 1152             PORTE.3 = 1;
	CALL SUBOPT_0x9B
; 0000 1153             byla_wloczona_szlifierka_2 = 0;
; 0000 1154             }
; 0000 1155         if(byl_wloczony_przedmuch == 1)
_0x164:
	CALL SUBOPT_0x9C
	BRNE _0x167
; 0000 1156             {
; 0000 1157             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x9D
; 0000 1158             PORTF = PORT_F.byte;
; 0000 1159             sek12 = zastopowany_czas_przedmuchu;
; 0000 115A             byl_wloczony_przedmuch = 0;
; 0000 115B             }
; 0000 115C         }
_0x167:
; 0000 115D     }
_0x15A:
; 0000 115E 
; 0000 115F }
_0x14D:
	RJMP _0x20A0003
;
;
;void obsluga_otwarcia_klapy_rzad()
; 0000 1163 {
_obsluga_otwarcia_klapy_rzad:
; 0000 1164 int sg;
; 0000 1165 sg = 0;
	CALL SUBOPT_0x1
;	sg -> R16,R17
; 0000 1166 
; 0000 1167 if(rzad_obrabiany == 1 & start == 1)
	CALL SUBOPT_0x9E
	CALL SUBOPT_0x84
	CALL SUBOPT_0x9F
	AND  R30,R0
	BRNE PC+3
	JMP _0x168
; 0000 1168    {
; 0000 1169    while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x169:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x16B
; 0000 116A         {
; 0000 116B         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x91
; 0000 116C         PORTD.7 = 1;
; 0000 116D         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x16E
; 0000 116E            {
; 0000 116F            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x92
; 0000 1170            PORTE.2 = 0;
; 0000 1171            }
; 0000 1172 
; 0000 1173         if(PORTE.3 == 1)
_0x16E:
	SBIS 0x3,3
	RJMP _0x171
; 0000 1174            {
; 0000 1175            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x93
; 0000 1176            PORTE.3 = 0;
; 0000 1177            }
; 0000 1178 
; 0000 1179            if(PORT_F.bits.b4 == 1)
_0x171:
	CALL SUBOPT_0x94
	BRNE _0x174
; 0000 117A             {
; 0000 117B             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x95
; 0000 117C             zastopowany_czas_przedmuchu = sek12;
; 0000 117D             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 117E             PORTF = PORT_F.byte;
; 0000 117F             }
; 0000 1180 
; 0000 1181 
; 0000 1182         komunikat_na_panel("                                                ",adr1,adr2);
_0x174:
	CALL SUBOPT_0x2C
; 0000 1183         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x2D
; 0000 1184         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 1185         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x97
; 0000 1186 
; 0000 1187         }
	RJMP _0x169
_0x16B:
; 0000 1188     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x175
; 0000 1189         {
; 0000 118A         while(sg == 0)
_0x176:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x178
; 0000 118B             {
; 0000 118C             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x179
; 0000 118D                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x17
	MOVW R16,R30
; 0000 118E 
; 0000 118F 
; 0000 1190             }
_0x179:
	RJMP _0x176
_0x178:
; 0000 1191 
; 0000 1192         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 1193         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 1194 
; 0000 1195         PORTD.7 = 0;
	CALL SUBOPT_0x98
; 0000 1196           if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x17C
; 0000 1197             {
; 0000 1198             PORTE.2 = 1;
	CALL SUBOPT_0x99
; 0000 1199             byla_wloczona_szlifierka_1 = 0;
; 0000 119A             }
; 0000 119B         if(byla_wloczona_szlifierka_2 == 1)
_0x17C:
	CALL SUBOPT_0x9A
	BRNE _0x17F
; 0000 119C             {
; 0000 119D             PORTE.3 = 1;
	CALL SUBOPT_0x9B
; 0000 119E             byla_wloczona_szlifierka_2 = 0;
; 0000 119F             }
; 0000 11A0         if(byl_wloczony_przedmuch == 1)
_0x17F:
	CALL SUBOPT_0x9C
	BRNE _0x182
; 0000 11A1             {
; 0000 11A2             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x9D
; 0000 11A3             PORTF = PORT_F.byte;
; 0000 11A4             sek12 = zastopowany_czas_przedmuchu;
; 0000 11A5             byl_wloczony_przedmuch = 0;
; 0000 11A6             }
; 0000 11A7         }
_0x182:
; 0000 11A8    }
_0x175:
; 0000 11A9 
; 0000 11AA 
; 0000 11AB if(rzad_obrabiany == 2 & start == 1)
_0x168:
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x9F
	AND  R30,R0
	BRNE PC+3
	JMP _0x183
; 0000 11AC    {
; 0000 11AD    while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x184:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BRNE _0x186
; 0000 11AE         {
; 0000 11AF         wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x91
; 0000 11B0         PORTD.7 = 1;
; 0000 11B1         if(PORTE.2 == 1)
	SBIS 0x3,2
	RJMP _0x189
; 0000 11B2            {
; 0000 11B3            byla_wloczona_szlifierka_1 = 1;
	CALL SUBOPT_0x92
; 0000 11B4            PORTE.2 = 0;
; 0000 11B5            }
; 0000 11B6 
; 0000 11B7         if(PORTE.3 == 1)
_0x189:
	SBIS 0x3,3
	RJMP _0x18C
; 0000 11B8            {
; 0000 11B9            byla_wloczona_szlifierka_2 = 1;
	CALL SUBOPT_0x93
; 0000 11BA            PORTE.3 = 0;
; 0000 11BB            }
; 0000 11BC 
; 0000 11BD          if(PORT_F.bits.b4 == 1)
_0x18C:
	CALL SUBOPT_0x94
	BRNE _0x18F
; 0000 11BE             {
; 0000 11BF             byl_wloczony_przedmuch = 1;
	CALL SUBOPT_0x95
; 0000 11C0             zastopowany_czas_przedmuchu = sek12;
; 0000 11C1             PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 11C2             PORTF = PORT_F.byte;
; 0000 11C3             }
; 0000 11C4 
; 0000 11C5         komunikat_na_panel("                                                ",adr1,adr2);
_0x18F:
	CALL SUBOPT_0x2C
; 0000 11C6         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x2D
; 0000 11C7         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 11C8         komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
	__POINTW1FN _0x0,1391
	CALL SUBOPT_0x97
; 0000 11C9 
; 0000 11CA         }
	RJMP _0x184
_0x186:
; 0000 11CB     if(PORTD.7 == 1)
	SBIS 0x12,7
	RJMP _0x190
; 0000 11CC         {
; 0000 11CD         while(sg == 0)
_0x191:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x193
; 0000 11CE             {
; 0000 11CF             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x194
; 0000 11D0                 sg = odczytaj_parametr(0,64);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x17
	MOVW R16,R30
; 0000 11D1 
; 0000 11D2 
; 0000 11D3             }
_0x194:
	RJMP _0x191
_0x193:
; 0000 11D4 
; 0000 11D5         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 11D6         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 11D7 
; 0000 11D8         PORTD.7 = 0;
	CALL SUBOPT_0x98
; 0000 11D9         if(byla_wloczona_szlifierka_1 == 1)
	BRNE _0x197
; 0000 11DA             {
; 0000 11DB             PORTE.2 = 1;
	CALL SUBOPT_0x99
; 0000 11DC             byla_wloczona_szlifierka_1 = 0;
; 0000 11DD             }
; 0000 11DE         if(byla_wloczona_szlifierka_2 == 1)
_0x197:
	CALL SUBOPT_0x9A
	BRNE _0x19A
; 0000 11DF             {
; 0000 11E0             PORTE.3 = 1;
	CALL SUBOPT_0x9B
; 0000 11E1             byla_wloczona_szlifierka_2 = 0;
; 0000 11E2             }
; 0000 11E3         if(byl_wloczony_przedmuch == 1)
_0x19A:
	CALL SUBOPT_0x9C
	BRNE _0x19D
; 0000 11E4             {
; 0000 11E5             PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x9D
; 0000 11E6             PORTF = PORT_F.byte;
; 0000 11E7             sek12 = zastopowany_czas_przedmuchu;
; 0000 11E8             byl_wloczony_przedmuch = 0;
; 0000 11E9             }
; 0000 11EA         }
_0x19D:
; 0000 11EB    }
_0x190:
; 0000 11EC 
; 0000 11ED 
; 0000 11EE 
; 0000 11EF 
; 0000 11F0 
; 0000 11F1 }
_0x183:
_0x20A0003:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;void odczyt_parametru_panelu_stala_pamiec(int adres_nieulotny1, int adres_nieulotny2, int dokad_adres1,int dokad_adres2)
; 0000 11F5 {
_odczyt_parametru_panelu_stala_pamiec:
; 0000 11F6 
; 0000 11F7 //5AA5 0C 80 56 5A A0 00000000 1010 0010 – Odczyt (A0) z pamiêci FLASH 00000000 do VP 1010
; 0000 11F8 
; 0000 11F9 putchar(90);  //5A
;	adres_nieulotny1 -> Y+6
;	adres_nieulotny2 -> Y+4
;	dokad_adres1 -> Y+2
;	dokad_adres2 -> Y+0
	CALL SUBOPT_0x2
; 0000 11FA putchar(165); //A5
; 0000 11FB putchar(12);   //0C
	CALL SUBOPT_0xA1
; 0000 11FC putchar(128);  //80    /
; 0000 11FD putchar(86);    //56
; 0000 11FE putchar(90);   //5A
; 0000 11FF putchar(160);    //A0
	LDI  R30,LOW(160)
	RJMP _0x20A0002
; 0000 1200 putchar(0);   //00
; 0000 1201 putchar(0);   //00
; 0000 1202 putchar(adres_nieulotny1);   //00
; 0000 1203 putchar(adres_nieulotny2);   //00
; 0000 1204 putchar(dokad_adres1);   //10
; 0000 1205 putchar(dokad_adres2);   //10
; 0000 1206 putchar(0);   //0
; 0000 1207 putchar(10);   //ile danych
; 0000 1208 }
;
;
;
;
;void wartosc_parametru_panelu_stala_pamiec(int adres_nieulotny1,int adres_nieulotny2, int skad_adres1, int skad_adres2)
; 0000 120E {
_wartosc_parametru_panelu_stala_pamiec:
; 0000 120F 
; 0000 1210 //5AA5 0C 80 56 5A 50 00000000 1000 0010 – Zapis (50) z VP 1000 do pamiêci FLASH 00000000
; 0000 1211 
; 0000 1212 putchar(90);  //5A
;	adres_nieulotny1 -> Y+6
;	adres_nieulotny2 -> Y+4
;	skad_adres1 -> Y+2
;	skad_adres2 -> Y+0
	CALL SUBOPT_0x2
; 0000 1213 putchar(165); //A5
; 0000 1214 putchar(12);   //0C
	CALL SUBOPT_0xA1
; 0000 1215 putchar(128);  //80    /
; 0000 1216 putchar(86);    //56
; 0000 1217 putchar(90);   //5A
; 0000 1218 putchar(80);    //50
	LDI  R30,LOW(80)
_0x20A0002:
	ST   -Y,R30
	CALL SUBOPT_0xA2
; 0000 1219 putchar(0);   //00
	CALL SUBOPT_0xA2
; 0000 121A putchar(0);   //00
	CALL _putchar
; 0000 121B putchar(adres_nieulotny1);   //00
	LDD  R30,Y+6
	CALL SUBOPT_0x3
; 0000 121C putchar(adres_nieulotny2);   //00
; 0000 121D putchar(skad_adres1);   //10
; 0000 121E putchar(skad_adres2);   //0
	CALL SUBOPT_0x8
; 0000 121F putchar(0);   //0
; 0000 1220 putchar(10);   //ile danych
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _putchar
; 0000 1221 }
	ADIW R28,8
	RET
;
;
;
;
;
;void wartosci_wstepne_wgrac_tylko_raz(int ktore_wgrac)
; 0000 1228 {
_wartosci_wstepne_wgrac_tylko_raz:
; 0000 1229 if(ktore_wgrac == 0)
;	ktore_wgrac -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x19E
; 0000 122A {
; 0000 122B szczotka_druciana_ilosc_cykli = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 122C krazek_scierny_ilosc_cykli = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R6,R30
; 0000 122D tryb_pracy_szczotki_drucianej = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 122E krazek_scierny_cykl_po_okregu_ilosc = 0;
	CLR  R8
	CLR  R9
; 0000 122F czas_pracy_szczotki_drucianej_stala = 150;
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	MOVW R12,R30
; 0000 1230 czas_pracy_krazka_sciernego_stala = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _czas_pracy_krazka_sciernego_stala,R30
	STS  _czas_pracy_krazka_sciernego_stala+1,R31
; 0000 1231 czas_pracy_szczotki_drucianej_h_17 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_szczotki_drucianej_h_17,R30
	STS  _czas_pracy_szczotki_drucianej_h_17+1,R30
; 0000 1232 czas_pracy_szczotki_drucianej_h_15 = 0;
	STS  _czas_pracy_szczotki_drucianej_h_15,R30
	STS  _czas_pracy_szczotki_drucianej_h_15+1,R30
; 0000 1233 czas_pracy_krazka_sciernego_h_34 = 0;
	STS  _czas_pracy_krazka_sciernego_h_34,R30
	STS  _czas_pracy_krazka_sciernego_h_34+1,R30
; 0000 1234 czas_pracy_krazka_sciernego_h_36 = 0;
	STS  _czas_pracy_krazka_sciernego_h_36,R30
	STS  _czas_pracy_krazka_sciernego_h_36+1,R30
; 0000 1235 czas_pracy_krazka_sciernego_h_38 = 0;
	STS  _czas_pracy_krazka_sciernego_h_38,R30
	STS  _czas_pracy_krazka_sciernego_h_38+1,R30
; 0000 1236 czas_pracy_krazka_sciernego_h_41 = 0;
	STS  _czas_pracy_krazka_sciernego_h_41,R30
	STS  _czas_pracy_krazka_sciernego_h_41+1,R30
; 0000 1237 czas_pracy_krazka_sciernego_h_43 = 0;
	STS  _czas_pracy_krazka_sciernego_h_43,R30
	STS  _czas_pracy_krazka_sciernego_h_43+1,R30
; 0000 1238 }
; 0000 1239 
; 0000 123A 
; 0000 123B wartosc_parametru_panelu(szczotka_druciana_ilosc_cykli,48,64);
_0x19E:
	ST   -Y,R5
	ST   -Y,R4
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xA3
	CALL _wartosc_parametru_panelu
; 0000 123C delay_ms(200);
	CALL SUBOPT_0xA4
; 0000 123D wartosc_parametru_panelu_stala_pamiec(0,0,48,64);                       //proba
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA5
; 0000 123E //putchar(adres_nieulotny1);   //00
; 0000 123F //putchar(adres_nieulotny2);   //00
; 0000 1240 //putchar(skad_adres1);   //10
; 0000 1241 //putchar(skad_adres2);   //0
; 0000 1242 delay_ms(200);
; 0000 1243 odczyt_parametru_panelu_stala_pamiec(0,0,48,64);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA6
; 0000 1244 //putchar(adres_nieulotny1);
; 0000 1245 //putchar(adres_nieulotny2);   //00
; 0000 1246 //putchar(dokad_adres1);   //10
; 0000 1247 //putchar(dokad_adres2);   //10
; 0000 1248 delay_ms(200);
; 0000 1249 
; 0000 124A 
; 0000 124B wartosc_parametru_panelu(krazek_scierny_ilosc_cykli,32,144);
	ST   -Y,R7
	ST   -Y,R6
	CALL SUBOPT_0x30
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA8
; 0000 124C wartosc_parametru_panelu_stala_pamiec(0,16,32,144);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x30
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA5
; 0000 124D delay_ms(200);
; 0000 124E odczyt_parametru_panelu_stala_pamiec(0,16,32,144);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x30
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA6
; 0000 124F delay_ms(200);
; 0000 1250 
; 0000 1251 
; 0000 1252 wartosc_parametru_panelu(krazek_scierny_cykl_po_okregu_ilosc,48,0);
	ST   -Y,R9
	ST   -Y,R8
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA8
; 0000 1253 wartosc_parametru_panelu_stala_pamiec(0,32,48,0);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA5
; 0000 1254 delay_ms(200);
; 0000 1255 odczyt_parametru_panelu_stala_pamiec(0,32,48,0);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA6
; 0000 1256 delay_ms(200);
; 0000 1257 
; 0000 1258 
; 0000 1259 wartosc_parametru_panelu(tryb_pracy_szczotki_drucianej,0,112);
	ST   -Y,R11
	ST   -Y,R10
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA8
; 0000 125A wartosc_parametru_panelu_stala_pamiec(0,48,0,112);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA5
; 0000 125B delay_ms(200);
; 0000 125C odczyt_parametru_panelu_stala_pamiec(0,48,0,112);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA6
; 0000 125D delay_ms(200);
; 0000 125E 
; 0000 125F 
; 0000 1260 
; 0000 1261 wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
	ST   -Y,R13
	ST   -Y,R12
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA8
; 0000 1262 wartosc_parametru_panelu_stala_pamiec(0,64,16,112);
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA5
; 0000 1263 delay_ms(200);
; 0000 1264 odczyt_parametru_panelu_stala_pamiec(0,64,16,112);
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA6
; 0000 1265 delay_ms(200);
; 0000 1266 
; 0000 1267 
; 0000 1268 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xAB
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA8
; 0000 1269 wartosc_parametru_panelu_stala_pamiec(0,80,32,16);
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA5
; 0000 126A delay_ms(200);
; 0000 126B odczyt_parametru_panelu_stala_pamiec(0,80,32,16);
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA6
; 0000 126C delay_ms(200);
; 0000 126D 
; 0000 126E 
; 0000 126F if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 38 | srednica_wew_korpusu_cyklowa == 41 | srednica_wew_korpusu_cyklowa == 43)
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x82
	CALL SUBOPT_0xAE
	OR   R0,R30
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xB0
	BREQ _0x19F
; 0000 1270 {
; 0000 1271 wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_17,0,144);
	CALL SUBOPT_0xB1
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA8
; 0000 1272 wartosc_parametru_panelu_stala_pamiec(0,96,0,144);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA5
; 0000 1273 delay_ms(200);
; 0000 1274 odczyt_parametru_panelu_stala_pamiec(0,96,0,144);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA6
; 0000 1275 delay_ms(200);
; 0000 1276 }
; 0000 1277 
; 0000 1278 
; 0000 1279 
; 0000 127A if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 34 | srednica_wew_korpusu_cyklowa == 36)
_0x19F:
	CALL SUBOPT_0xB2
	CALL SUBOPT_0xB3
	OR   R0,R30
	CALL SUBOPT_0xB4
	BREQ _0x1A0
; 0000 127B {
; 0000 127C wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_15,16,128);
	CALL SUBOPT_0xB5
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xB7
; 0000 127D wartosc_parametru_panelu_stala_pamiec(16,32,16,128);
	CALL SUBOPT_0x30
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xB8
; 0000 127E delay_ms(200);
; 0000 127F odczyt_parametru_panelu_stala_pamiec(16,32,16,128);
	CALL SUBOPT_0x30
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xA6
; 0000 1280 delay_ms(200);
; 0000 1281 }
; 0000 1282 
; 0000 1283 
; 0000 1284 if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 34)
_0x1A0:
	CALL SUBOPT_0xB2
	CALL SUBOPT_0xB3
	OR   R30,R0
	BREQ _0x1A1
; 0000 1285 {
; 0000 1286 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
	CALL SUBOPT_0xB9
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xA8
; 0000 1287 wartosc_parametru_panelu_stala_pamiec(0,112,96,48);
	CALL SUBOPT_0xA9
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xA5
; 0000 1288 delay_ms(200);
; 0000 1289 odczyt_parametru_panelu_stala_pamiec(0,112,96,48);
	CALL SUBOPT_0xA9
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xA6
; 0000 128A delay_ms(200);
; 0000 128B }
; 0000 128C 
; 0000 128D if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 36)
_0x1A1:
	CALL SUBOPT_0xB2
	CALL SUBOPT_0xB4
	BREQ _0x1A2
; 0000 128E {
; 0000 128F wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA8
; 0000 1290 wartosc_parametru_panelu_stala_pamiec(0,128,96,64);
	CALL SUBOPT_0xB6
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA5
; 0000 1291 delay_ms(200);
; 0000 1292 odczyt_parametru_panelu_stala_pamiec(0,128,96,64);
	CALL SUBOPT_0xB6
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA6
; 0000 1293 delay_ms(200);
; 0000 1294 }
; 0000 1295 
; 0000 1296 if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 38)
_0x1A2:
	CALL SUBOPT_0xB2
	CALL SUBOPT_0xAE
	OR   R30,R0
	BREQ _0x1A3
; 0000 1297 {
; 0000 1298 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
	CALL SUBOPT_0xBB
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xA8
; 0000 1299 wartosc_parametru_panelu_stala_pamiec(0,144,96,80);
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x23
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xA5
; 0000 129A delay_ms(200);
; 0000 129B odczyt_parametru_panelu_stala_pamiec(0,144,96,80);
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x23
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xA6
; 0000 129C delay_ms(200);
; 0000 129D }
; 0000 129E 
; 0000 129F if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 41)
_0x1A3:
	CALL SUBOPT_0xB2
	CALL SUBOPT_0xAF
	OR   R30,R0
	BREQ _0x1A4
; 0000 12A0 {
; 0000 12A1 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
	CALL SUBOPT_0xBD
	CALL SUBOPT_0x23
	CALL SUBOPT_0xB7
; 0000 12A2 wartosc_parametru_panelu_stala_pamiec(16,0,96,96);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0xB8
; 0000 12A3 delay_ms(200);
; 0000 12A4 odczyt_parametru_panelu_stala_pamiec(16,0,96,96);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA6
; 0000 12A5 delay_ms(200);
; 0000 12A6 }
; 0000 12A7 
; 0000 12A8 if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 43)
_0x1A4:
	CALL SUBOPT_0xB2
	CALL SUBOPT_0xAD
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x1A5
; 0000 12A9 {
; 0000 12AA wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
	CALL SUBOPT_0xBE
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xB7
; 0000 12AB wartosc_parametru_panelu_stala_pamiec(16,16,96,112);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xB8
; 0000 12AC delay_ms(200);
; 0000 12AD odczyt_parametru_panelu_stala_pamiec(16,16,96,112);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA6
; 0000 12AE delay_ms(200);
; 0000 12AF }
; 0000 12B0 
; 0000 12B1 
; 0000 12B2 
; 0000 12B3 }
_0x1A5:
	ADIW R28,2
	RET
;
;
;
;void zapis_probny_test()
; 0000 12B8 {
; 0000 12B9 int dupa_dupa;
; 0000 12BA 
; 0000 12BB dupa_dupa = odczytaj_parametr(128,144);             //uruchomienie cyklu przez zapis
;	dupa_dupa -> R16,R17
; 0000 12BC 
; 0000 12BD if(dupa_dupa == 1)
; 0000 12BE     {
; 0000 12BF 
; 0000 12C0 
; 0000 12C1 
; 0000 12C2      srednica_wew_korpusu_cyklowa = 38;
; 0000 12C3 
; 0000 12C4                              tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
; 0000 12C5                              szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
; 0000 12C6                                krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
; 0000 12C7                                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
; 0000 12C8                                         czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
; 0000 12C9                                         czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
; 0000 12CA 
; 0000 12CB 
; 0000 12CC                              if(srednica_wew_korpusu_cyklowa == 34 | srednica_wew_korpusu_cyklowa == 36)
; 0000 12CD                                  czas_pracy_szczotki_drucianej_h_15++;
; 0000 12CE 
; 0000 12CF                              if(srednica_wew_korpusu_cyklowa == 38 | srednica_wew_korpusu_cyklowa == 41 | srednica_wew_korpusu_cyklowa == 43)
; 0000 12D0                                  czas_pracy_szczotki_drucianej_h_17++;
; 0000 12D1 
; 0000 12D2 
; 0000 12D3                             if(srednica_wew_korpusu_cyklowa == 34)
; 0000 12D4                                 czas_pracy_krazka_sciernego_h_34++;
; 0000 12D5                             if(srednica_wew_korpusu_cyklowa == 36)
; 0000 12D6                                 czas_pracy_krazka_sciernego_h_36++;
; 0000 12D7                             if(srednica_wew_korpusu_cyklowa == 38)
; 0000 12D8                                 czas_pracy_krazka_sciernego_h_38++;
; 0000 12D9                             if(srednica_wew_korpusu_cyklowa == 41)
; 0000 12DA                                 czas_pracy_krazka_sciernego_h_41++;
; 0000 12DB                             if(srednica_wew_korpusu_cyklowa == 43)
; 0000 12DC                                 czas_pracy_krazka_sciernego_h_43++;
; 0000 12DD 
; 0000 12DE                             wartosci_wstepne_wgrac_tylko_raz(1); //to trwa 3s
; 0000 12DF 
; 0000 12E0 
; 0000 12E1                                 //wartosc wstpena panelu
; 0000 12E2                               wartosc_parametru_panelu(0,128,144);
; 0000 12E3 
; 0000 12E4     }
; 0000 12E5 
; 0000 12E6 
; 0000 12E7 }
;
;
;void wartosci_wstepne_panelu()
; 0000 12EB {
_wartosci_wstepne_panelu:
; 0000 12EC 
; 0000 12ED delay_ms(200);
	CALL SUBOPT_0xA4
; 0000 12EE odczyt_parametru_panelu_stala_pamiec(0,0,48,64);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xBF
; 0000 12EF delay_ms(200);
; 0000 12F0 //////////////////////////////////////////////////wartosc_parametru_panelu(szczotka_druciana_ilosc_cykli,48,64);
; 0000 12F1 
; 0000 12F2 
; 0000 12F3 odczyt_parametru_panelu_stala_pamiec(0,16,32,144);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x30
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xBF
; 0000 12F4 delay_ms(200);
; 0000 12F5 /////////////////////////////////////////////////wartosc_parametru_panelu(krazek_scierny_ilosc_cykli,32,144);
; 0000 12F6                                                         //3000
; 0000 12F7 odczyt_parametru_panelu_stala_pamiec(0,32,48,0);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA6
; 0000 12F8 delay_ms(200);
; 0000 12F9 /////////////////////////////////////////////////////////wartosc_parametru_panelu(krazek_scierny_cykl_po_okregu_ilosc,48,0);
; 0000 12FA                                                 //2050
; 0000 12FB 
; 0000 12FC /////////////////////////
; 0000 12FD delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0xC0
; 0000 12FE odczyt_parametru_panelu_stala_pamiec(0,64,16,112);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xBF
; 0000 12FF /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
; 0000 1300 
; 0000 1301 delay_ms(200);
; 0000 1302 odczyt_parametru_panelu_stala_pamiec(0,80,32,16);
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xA
	CALL SUBOPT_0xBF
; 0000 1303 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
; 0000 1304 
; 0000 1305 delay_ms(200);
; 0000 1306 odczyt_parametru_panelu_stala_pamiec(0,96,0,144);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA6
; 0000 1307 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_17,0,144);
; 0000 1308 
; 0000 1309 delay_ms(200);
; 0000 130A odczyt_parametru_panelu_stala_pamiec(16,32,16,128);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x30
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xBF
; 0000 130B /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_15,16,128);
; 0000 130C 
; 0000 130D delay_ms(200);
; 0000 130E odczyt_parametru_panelu_stala_pamiec(0,112,96,48);
	CALL SUBOPT_0xA9
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xBF
; 0000 130F /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
; 0000 1310 
; 0000 1311 delay_ms(200);
; 0000 1312 odczyt_parametru_panelu_stala_pamiec(0,128,96,64);
	CALL SUBOPT_0xB6
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xBF
; 0000 1313 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
; 0000 1314 
; 0000 1315 delay_ms(200);
; 0000 1316 odczyt_parametru_panelu_stala_pamiec(0,144,96,80);
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x23
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xA6
; 0000 1317 /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
; 0000 1318 
; 0000 1319 delay_ms(200);
; 0000 131A odczyt_parametru_panelu_stala_pamiec(16,0,96,96);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x9
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA6
; 0000 131B /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
; 0000 131C 
; 0000 131D delay_ms(200);
; 0000 131E odczyt_parametru_panelu_stala_pamiec(16,16,96,112);
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xBF
; 0000 131F /////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
; 0000 1320 
; 0000 1321 delay_ms(200);
; 0000 1322 odczyt_parametru_panelu_stala_pamiec(0,48,0,112);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA6
; 0000 1323 delay_ms(200);
; 0000 1324 //////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(tryb_pracy_szczotki_drucianej,0,112);
; 0000 1325 
; 0000 1326 
; 0000 1327 //////////////////////////
; 0000 1328 wartosc_parametru_panelu(predkosc_pion_szczotka,32,80);
	LDS  R30,_predkosc_pion_szczotka
	LDS  R31,_predkosc_pion_szczotka+1
	CALL SUBOPT_0xAB
	CALL SUBOPT_0xBC
	CALL _wartosc_parametru_panelu
; 0000 1329                                                 //2060
; 0000 132A wartosc_parametru_panelu(predkosc_pion_krazek,32,96);
	LDS  R30,_predkosc_pion_krazek
	LDS  R31,_predkosc_pion_krazek+1
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x23
	CALL _wartosc_parametru_panelu
; 0000 132B                                                                        //3010
; 0000 132C wartosc_parametru_panelu(wejscie_krazka_sciernego_w_pow_boczna_cylindra,48,16);
	LDS  R30,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R31,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	CALL SUBOPT_0xC1
	CALL SUBOPT_0xA
	CALL _wartosc_parametru_panelu
; 0000 132D                                                                      //2070
; 0000 132E wartosc_parametru_panelu(predkosc_ruchow_po_okregu_krazek_scierny,32,112);
	LDS  R30,_predkosc_ruchow_po_okregu_krazek_scierny
	LDS  R31,_predkosc_ruchow_po_okregu_krazek_scierny+1
	CALL SUBOPT_0xAB
	CALL SUBOPT_0xA9
	CALL _wartosc_parametru_panelu
; 0000 132F wartosc_parametru_panelu(40,48,112);  //srednica krazka wstepnie
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0xC1
	CALL SUBOPT_0xA9
	CALL _wartosc_parametru_panelu
; 0000 1330 wartosc_parametru_panelu(145,48,128);   //to do manualnego wczytywania zacisku, ma byc 145
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	CALL SUBOPT_0xC1
	CALL SUBOPT_0xB6
	CALL _wartosc_parametru_panelu
; 0000 1331 wartosc_parametru_panelu(1,128,64);   //to do statystyki, zeby zawsze bylo 1
	CALL SUBOPT_0xC2
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xA3
	CALL _wartosc_parametru_panelu
; 0000 1332 
; 0000 1333 
; 0000 1334 
; 0000 1335 }
	RET
;
;
;
;void obsluga_trybu_administratora()
; 0000 133A {
_obsluga_trybu_administratora:
; 0000 133B int guzik0,guzik1,guzik2,guzik3,guzik4,guzik5,guzik6,guzik7,guzik8;
; 0000 133C int czas_kodu_panela;
; 0000 133D 
; 0000 133E czas_kodu_panela = 0;
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
; 0000 133F 
; 0000 1340       guzik0 = odczytaj_parametr(80,144);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0x20
	MOVW R16,R30
; 0000 1341       guzik1 = odczytaj_parametr(80,145);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xC3
; 0000 1342       guzik2 = odczytaj_parametr(80,146);
	CALL SUBOPT_0xC4
; 0000 1343       guzik3 = odczytaj_parametr(80,147);
	CALL SUBOPT_0xC5
; 0000 1344       guzik4 = odczytaj_parametr(80,148);
	CALL SUBOPT_0xC6
; 0000 1345       guzik5 = odczytaj_parametr(80,149);
	CALL SUBOPT_0xC7
; 0000 1346       guzik6 = odczytaj_parametr(80,150);
	CALL SUBOPT_0xC8
; 0000 1347       guzik7 = odczytaj_parametr(80,151);
	CALL SUBOPT_0xC9
; 0000 1348       guzik8 = odczytaj_parametr(80,152);
	CALL SUBOPT_0xCA
; 0000 1349 
; 0000 134A 
; 0000 134B 
; 0000 134C 
; 0000 134D       while(guzik0 == 1 | guzik1 == 1 | guzik2 == 1 |
_0x1AE:
; 0000 134E             guzik3 == 1 | guzik4 == 1 | guzik5 == 1 |
; 0000 134F             guzik6 == 1 | guzik7 == 1 | guzik8 == 1)
	MOVW R26,R16
	CALL SUBOPT_0x84
	MOV  R0,R30
	MOVW R26,R18
	CALL SUBOPT_0x84
	OR   R0,R30
	MOVW R26,R20
	CALL SUBOPT_0x84
	OR   R0,R30
	CALL SUBOPT_0xCB
	OR   R0,R30
	CALL SUBOPT_0xCC
	OR   R0,R30
	CALL SUBOPT_0xCD
	OR   R0,R30
	CALL SUBOPT_0xCE
	OR   R0,R30
	CALL SUBOPT_0xCF
	OR   R0,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL SUBOPT_0x84
	OR   R30,R0
	BRNE PC+3
	JMP _0x1B0
; 0000 1350 
; 0000 1351       {
; 0000 1352 
; 0000 1353       if(czas_kodu_panela == 0)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BRNE _0x1B1
; 0000 1354       {
; 0000 1355       sek80 = 0;
	LDI  R30,LOW(0)
	STS  _sek80,R30
	STS  _sek80+1,R30
	STS  _sek80+2,R30
	STS  _sek80+3,R30
; 0000 1356       czas_kodu_panela = 1;
	CALL SUBOPT_0xD0
; 0000 1357       }
; 0000 1358 
; 0000 1359       guzik0 = odczytaj_parametr(80,144);
_0x1B1:
	CALL SUBOPT_0xBC
	CALL SUBOPT_0x20
	MOVW R16,R30
; 0000 135A       guzik1 = odczytaj_parametr(80,145);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xC3
; 0000 135B       guzik2 = odczytaj_parametr(80,146);  /////////
	CALL SUBOPT_0xC4
; 0000 135C       guzik3 = odczytaj_parametr(80,147);
	CALL SUBOPT_0xC5
; 0000 135D       guzik4 = odczytaj_parametr(80,148);  /////////
	CALL SUBOPT_0xC6
; 0000 135E       guzik5 = odczytaj_parametr(80,149);
	CALL SUBOPT_0xC7
; 0000 135F       guzik6 = odczytaj_parametr(80,150);  ////////
	CALL SUBOPT_0xC8
; 0000 1360       guzik7 = odczytaj_parametr(80,151);
	CALL SUBOPT_0xC9
; 0000 1361       guzik8 = odczytaj_parametr(80,152);
	CALL SUBOPT_0xCA
; 0000 1362 
; 0000 1363 
; 0000 1364       //kod to 7 5 3 (przekatna)
; 0000 1365 
; 0000 1366       if((guzik2 + guzik4 + guzik6 + guzik8) == 4 & (guzik2 == 1 & guzik4 == 1 & guzik6 == 1 & guzik8 == 1))
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADD  R30,R20
	ADC  R31,R21
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0xD1
	MOV  R1,R30
	MOVW R26,R20
	CALL SUBOPT_0x84
	MOV  R0,R30
	CALL SUBOPT_0xCC
	AND  R0,R30
	CALL SUBOPT_0xCE
	AND  R0,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL SUBOPT_0x84
	AND  R30,R0
	AND  R30,R1
	BRNE PC+3
	JMP _0x1B2
; 0000 1367                    {
; 0000 1368 
; 0000 1369                    putchar(90);  //5A
	CALL SUBOPT_0x2
; 0000 136A                    putchar(165); //A5
; 0000 136B                    putchar(4);//04  //zmiana obrazu
	LDI  R30,LOW(4)
	CALL SUBOPT_0xD2
; 0000 136C                    putchar(128);  //80
; 0000 136D                    putchar(3);    //03
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL SUBOPT_0xA2
; 0000 136E                    putchar(0);   //
	CALL _putchar
; 0000 136F                    putchar(65);   //0
	LDI  R30,LOW(65)
	CALL SUBOPT_0xD3
; 0000 1370 
; 0000 1371                    delay_ms(500);
; 0000 1372                    putchar(90);  //5A
	CALL SUBOPT_0x2
; 0000 1373                    putchar(165); //A5
; 0000 1374                    putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	CALL SUBOPT_0xD2
; 0000 1375                    putchar(128);  //80
; 0000 1376                    putchar(2);    //02
	CALL SUBOPT_0xD4
; 0000 1377                    putchar(16);   //10
; 0000 1378                    delay_ms(500);
; 0000 1379                    putchar(90);  //5A
	CALL SUBOPT_0x2
; 0000 137A                    putchar(165); //A5
; 0000 137B                    putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	CALL SUBOPT_0xD2
; 0000 137C                    putchar(128);  //80
; 0000 137D                    putchar(2);    //02
	CALL SUBOPT_0xD4
; 0000 137E                    putchar(16);   //10
; 0000 137F                    delay_ms(500);
; 0000 1380                    putchar(90);  //5A
	CALL SUBOPT_0x2
; 0000 1381                    putchar(165); //A5
; 0000 1382                    putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	CALL SUBOPT_0xD2
; 0000 1383                    putchar(128);  //80
; 0000 1384                    putchar(2);    //02
	CALL SUBOPT_0xD4
; 0000 1385                    putchar(16);   //10
; 0000 1386                    delay_ms(500);
; 0000 1387                    putchar(90);  //5A
	CALL SUBOPT_0x2
; 0000 1388                    putchar(165); //A5
; 0000 1389                    putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	CALL SUBOPT_0xD2
; 0000 138A                    putchar(128);  //80
; 0000 138B                    putchar(2);    //02
	CALL SUBOPT_0xD5
; 0000 138C                    putchar(16);   //10
; 0000 138D 
; 0000 138E                    wartosc_parametru_panelu(0, 80, 144);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA8
; 0000 138F                    wartosc_parametru_panelu(0, 80, 145);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xD6
; 0000 1390                    wartosc_parametru_panelu(0, 80, 146);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xD7
; 0000 1391                    wartosc_parametru_panelu(0, 80, 147);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xD8
; 0000 1392                    wartosc_parametru_panelu(0, 80, 148);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xD9
; 0000 1393                    wartosc_parametru_panelu(0, 80, 149);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xDA
; 0000 1394                    wartosc_parametru_panelu(0, 80, 150);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xDB
; 0000 1395                    wartosc_parametru_panelu(0, 80, 151);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xDC
; 0000 1396                    wartosc_parametru_panelu(0, 80, 152);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xDD
; 0000 1397 
; 0000 1398 
; 0000 1399                    guzik0 = 0;
; 0000 139A                    guzik1 = 0;
; 0000 139B                    guzik2 = 0;
; 0000 139C                    guzik3 = 0;
; 0000 139D                    guzik4 = 0;
; 0000 139E                    guzik5 = 0;
; 0000 139F                    guzik6 = 0;
; 0000 13A0                    guzik7 = 0;
; 0000 13A1                    guzik8 = 0;
; 0000 13A2 
; 0000 13A3                    czas_kodu_panela = 0;
; 0000 13A4                    }
; 0000 13A5 
; 0000 13A6 
; 0000 13A7       if(sek80 > 320)
_0x1B2:
	LDS  R26,_sek80
	LDS  R27,_sek80+1
	LDS  R24,_sek80+2
	LDS  R25,_sek80+3
	__CPD2N 0x141
	BRLT _0x1B3
; 0000 13A8                    {
; 0000 13A9                    delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0xC0
; 0000 13AA                    putchar(90);  //5A
	CALL SUBOPT_0x2
; 0000 13AB                    putchar(165); //A5
; 0000 13AC                    putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	CALL SUBOPT_0xD2
; 0000 13AD                    putchar(128);  //80
; 0000 13AE                    putchar(2);    //02
	CALL SUBOPT_0xD4
; 0000 13AF                    putchar(16);   //10
; 0000 13B0                    delay_ms(500);
; 0000 13B1                    putchar(90);  //5A
	CALL SUBOPT_0x2
; 0000 13B2                    putchar(165); //A5
; 0000 13B3                    putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	CALL SUBOPT_0xD2
; 0000 13B4                    putchar(128);  //80
; 0000 13B5                    putchar(2);    //02
	CALL SUBOPT_0xD5
; 0000 13B6                    putchar(16);   //10
; 0000 13B7 
; 0000 13B8                    wartosc_parametru_panelu(0, 80, 144);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA8
; 0000 13B9                    wartosc_parametru_panelu(0, 80, 145);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xD6
; 0000 13BA                    wartosc_parametru_panelu(0, 80, 146);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xD7
; 0000 13BB                    wartosc_parametru_panelu(0, 80, 147);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xD8
; 0000 13BC                    wartosc_parametru_panelu(0, 80, 148);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xD9
; 0000 13BD                    wartosc_parametru_panelu(0, 80, 149);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xDA
; 0000 13BE                    wartosc_parametru_panelu(0, 80, 150);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xDB
; 0000 13BF                    wartosc_parametru_panelu(0, 80, 151);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xDC
; 0000 13C0                    wartosc_parametru_panelu(0, 80, 152);
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xDD
; 0000 13C1 
; 0000 13C2 
; 0000 13C3                    guzik0 = 0;
; 0000 13C4                    guzik1 = 0;
; 0000 13C5                    guzik2 = 0;
; 0000 13C6                    guzik3 = 0;
; 0000 13C7                    guzik4 = 0;
; 0000 13C8                    guzik5 = 0;
; 0000 13C9                    guzik6 = 0;
; 0000 13CA                    guzik7 = 0;
; 0000 13CB                    guzik8 = 0;
; 0000 13CC 
; 0000 13CD                    czas_kodu_panela = 0;
; 0000 13CE 
; 0000 13CF 
; 0000 13D0                    }
; 0000 13D1 
; 0000 13D2 
; 0000 13D3       }
_0x1B3:
	RJMP _0x1AE
_0x1B0:
; 0000 13D4 }
	CALL __LOADLOCR6
	ADIW R28,20
	RET
;
;
;
;
;
;
;
;void wypozycjonuj_napedy_minimalistyczna()
; 0000 13DD {
_wypozycjonuj_napedy_minimalistyczna:
; 0000 13DE //sek20
; 0000 13DF 
; 0000 13E0 
; 0000 13E1 while(start == 0)
_0x1B4:
	LDS  R30,_start
	LDS  R31,_start+1
	SBIW R30,0
	BRNE _0x1B6
; 0000 13E2     {
; 0000 13E3     komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 13E4     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr1,adr2);
	__POINTW1FN _0x0,1429
	CALL SUBOPT_0x2D
; 0000 13E5     komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 13E6     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr3,adr4);
	__POINTW1FN _0x0,1429
	CALL SUBOPT_0x97
; 0000 13E7     delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 13E8     start = odczytaj_parametr(0,64);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x17
	STS  _start,R30
	STS  _start+1,R31
; 0000 13E9     }
	RJMP _0x1B4
_0x1B6:
; 0000 13EA 
; 0000 13EB 
; 0000 13EC while(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
_0x1B7:
	CALL SUBOPT_0x14
	CALL SUBOPT_0xDF
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0xE0
	POP  R26
	OR   R30,R26
	BREQ _0x1B9
; 0000 13ED     {
; 0000 13EE     komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 13EF     komunikat_na_panel("Zamknij oslony gorne",adr1,adr2);
	__POINTW1FN _0x0,1470
	CALL SUBOPT_0x2D
; 0000 13F0     komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 13F1     komunikat_na_panel("Zamknij oslony gorne",adr3,adr4);
	__POINTW1FN _0x0,1470
	CALL SUBOPT_0x97
; 0000 13F2     }
	RJMP _0x1B7
_0x1B9:
; 0000 13F3 
; 0000 13F4 
; 0000 13F5 PORTB.4 = 1;   //setupy piony
	SBI  0x18,4
; 0000 13F6 delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 13F7 PORTB.4 = 0;   //setupy piony
	CBI  0x18,4
; 0000 13F8 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 13F9 
; 0000 13FA 
; 0000 13FB 
; 0000 13FC while(sprawdz_pin3(PORTKK,0x75) == 1 | sprawdz_pin7(PORTKK,0x75) == 1)
_0x1C0:
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE2
	PUSH R30
	CALL SUBOPT_0xE1
	CALL SUBOPT_0xE3
	POP  R26
	OR   R30,R26
	BRNE PC+3
	JMP _0x1C2
; 0000 13FD       {
; 0000 13FE       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
	CALL SUBOPT_0x14
	CALL SUBOPT_0xDF
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0xE0
	POP  R26
	OR   R30,R26
	BREQ _0x1C3
; 0000 13FF         while(1)
_0x1C4:
; 0000 1400             {
; 0000 1401             PORTD.7 = 1;
	CALL SUBOPT_0xE4
; 0000 1402             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 1403 
; 0000 1404             PORTB.4 = 0;   //setupy piony
; 0000 1405             PORTD.2 = 0;   //setup wspolny
; 0000 1406 
; 0000 1407             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1408             komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
	CALL SUBOPT_0xE5
; 0000 1409             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 140A             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xE6
; 0000 140B 
; 0000 140C             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA3
	CALL _wartosc_parametru_panelu
; 0000 140D             }
	RJMP _0x1C4
; 0000 140E 
; 0000 140F 
; 0000 1410       if(sprawdz_pin2(PORTMM,0x77) == 0)
_0x1C3:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x1CF
; 0000 1411         while(1)
_0x1D0:
; 0000 1412             {
; 0000 1413             PORTD.7 = 1;
	CALL SUBOPT_0xE4
; 0000 1414             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 1415 
; 0000 1416             PORTB.4 = 0;   //setupy piony
; 0000 1417             PORTD.2 = 0;   //setup wspolny
; 0000 1418 
; 0000 1419             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 141A             komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
	CALL SUBOPT_0xE7
; 0000 141B             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 141C             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xE6
; 0000 141D 
; 0000 141E             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA3
	CALL _wartosc_parametru_panelu
; 0000 141F             }
	RJMP _0x1D0
; 0000 1420 
; 0000 1421 
; 0000 1422       komunikat_na_panel("                                                ",adr1,adr2);
_0x1CF:
	CALL SUBOPT_0x2C
; 0000 1423       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x2D
; 0000 1424       komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 1425       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x97
; 0000 1426       delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 1427 
; 0000 1428       if(sprawdz_pin3(PORTKK,0x75) == 0)
	CALL SUBOPT_0xE1
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1DB
; 0000 1429             {
; 0000 142A             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 142B             komunikat_na_panel("Sterownik 3 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1622
	CALL SUBOPT_0x2D
; 0000 142C             delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 142D             }
; 0000 142E       if(sprawdz_pin7(PORTKK,0x75) == 0)
_0x1DB:
	CALL SUBOPT_0xE1
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x1DC
; 0000 142F             {
; 0000 1430             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 1431             komunikat_na_panel("Sterownik 4 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1653
	CALL SUBOPT_0x2D
; 0000 1432             delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 1433             }
; 0000 1434 
; 0000 1435 
; 0000 1436       if(sprawdz_pin6(PORTMM,0x77) == 1 |
_0x1DC:
; 0000 1437          sprawdz_pin7(PORTMM,0x77) == 1)
	CALL SUBOPT_0x14
	CALL SUBOPT_0xE8
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0xE3
	POP  R26
	OR   R30,R26
	BREQ _0x1DD
; 0000 1438             {
; 0000 1439             PORTD.7 = 1;
	SBI  0x12,7
; 0000 143A             if(sprawdz_pin6(PORTMM,0x77) == 1)
	CALL SUBOPT_0x14
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x1E0
; 0000 143B                 {
; 0000 143C                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 143D                 komunikat_na_panel("Alarm Sterownik 4",adr1,adr2);
	__POINTW1FN _0x0,1684
	CALL SUBOPT_0x2D
; 0000 143E                 delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 143F                 }
; 0000 1440             if(sprawdz_pin7(PORTMM,0x77) == 1)
_0x1E0:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x1E1
; 0000 1441                 {
; 0000 1442                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 1443                 komunikat_na_panel("Alarm Sterownik 3",adr1,adr2);
	__POINTW1FN _0x0,1702
	CALL SUBOPT_0x2D
; 0000 1444                 delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 1445                 }
; 0000 1446             }
_0x1E1:
; 0000 1447 
; 0000 1448 
; 0000 1449 
; 0000 144A 
; 0000 144B 
; 0000 144C 
; 0000 144D 
; 0000 144E 
; 0000 144F       }
_0x1DD:
	RJMP _0x1C0
_0x1C2:
; 0000 1450 
; 0000 1451 PORTB.4 = 0;   //setupy piony
	CBI  0x18,4
; 0000 1452 PORTD.2 = 1;   //setup poziomy
	SBI  0x12,2
; 0000 1453 delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 1454 PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 1455 sek20 = 0;
	CALL SUBOPT_0x90
; 0000 1456 
; 0000 1457 while((sprawdz_pin3(PORTJJ,0x79) == 1 | sprawdz_pin3(PORTLL,0x71) == 1) & sek20 < 3662)
_0x1E8:
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xE2
	PUSH R30
	CALL SUBOPT_0xE9
	POP  R26
	OR   R30,R26
	MOV  R0,R30
	CALL SUBOPT_0x8E
	__GETD1N 0xE4E
	CALL __LTD12
	AND  R30,R0
	BRNE PC+3
	JMP _0x1EA
; 0000 1458       {
; 0000 1459 
; 0000 145A       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
	CALL SUBOPT_0x14
	CALL SUBOPT_0xDF
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0xE0
	POP  R26
	OR   R30,R26
	BREQ _0x1EB
; 0000 145B         while(1)
_0x1EC:
; 0000 145C             {
; 0000 145D             PORTD.7 = 1;
	SBI  0x12,7
; 0000 145E             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 145F             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 1460             komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
	CALL SUBOPT_0xE5
; 0000 1461             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 1462             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xE6
; 0000 1463 
; 0000 1464             PORTB.4 = 0;   //setupy piony
	CBI  0x18,4
; 0000 1465             PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 1466 
; 0000 1467             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA3
	CALL _wartosc_parametru_panelu
; 0000 1468             }
	RJMP _0x1EC
; 0000 1469 
; 0000 146A 
; 0000 146B       if(sprawdz_pin2(PORTMM,0x77) == 0)
_0x1EB:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x1F7
; 0000 146C         while(1)
_0x1F8:
; 0000 146D             {
; 0000 146E             PORTD.7 = 1;
	CALL SUBOPT_0xE4
; 0000 146F             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 1470 
; 0000 1471             PORTB.4 = 0;   //setupy piony
; 0000 1472             PORTD.2 = 0;   //setup wspolny
; 0000 1473 
; 0000 1474             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1475             komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
	CALL SUBOPT_0xE7
; 0000 1476             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 1477             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xE6
; 0000 1478 
; 0000 1479             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA3
	CALL _wartosc_parametru_panelu
; 0000 147A             }
	RJMP _0x1F8
; 0000 147B 
; 0000 147C       komunikat_na_panel("                                                ",adr1,adr2);
_0x1F7:
	CALL SUBOPT_0x2C
; 0000 147D       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x2D
; 0000 147E       komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 147F       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1591
	CALL SUBOPT_0x97
; 0000 1480       delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 1481 
; 0000 1482       if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x2B
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x203
; 0000 1483             {
; 0000 1484             if(sprawdz_pin3(PORTLL,0x71) == 1 & & PORTD.2 == 0)
	CALL SUBOPT_0xE9
	MOV  R0,R30
	LDI  R26,LOW(50)
	LDI  R27,HIGH(50)
	CALL SUBOPT_0xEA
	BREQ _0x204
; 0000 1485                  PORTD.2 = 1;   //setup wspolny      ////////////PROBA 22.11.2019
	SBI  0x12,2
; 0000 1486             komunikat_na_panel("                                                ",adr1,adr2);
_0x204:
	CALL SUBOPT_0x2C
; 0000 1487             komunikat_na_panel("Sterownik 1 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1720
	CALL SUBOPT_0x2D
; 0000 1488             delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 1489             PORTD.2 = 0;
	CBI  0x12,2
; 0000 148A             }
; 0000 148B       if(sprawdz_pin3(PORTLL,0x71) == 0)
_0x203:
	CALL SUBOPT_0xEB
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x209
; 0000 148C             {
; 0000 148D             if(sprawdz_pin3(PORTJJ,0x79) == 1 & PORTD.2 == 0)
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xE2
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x12,2
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x20A
; 0000 148E                  PORTD.2 = 1;   //setup wspolny      ////////////PROBA 22.11.2019
	SBI  0x12,2
; 0000 148F             komunikat_na_panel("                                                ",adr3,adr4);
_0x20A:
	CALL SUBOPT_0x96
; 0000 1490             komunikat_na_panel("Sterownik 2 - wypozycjonowalem",adr3,adr4);
	__POINTW1FN _0x0,1751
	CALL SUBOPT_0x97
; 0000 1491             delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 1492             PORTD.2 = 0;   //setup wspolny      ////////////PROBA 22.11.2019
	CBI  0x12,2
; 0000 1493             }
; 0000 1494 
; 0000 1495        //if(sprawdz_pin7(PORTMM,0x77) == 1)
; 0000 1496        //     PORTD.7 = 1;
; 0000 1497 
; 0000 1498       if(sprawdz_pin5(PORTJJ,0x79) == 1 |
_0x209:
; 0000 1499          sprawdz_pin5(PORTLL,0x71) == 1)
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xEC
	PUSH R30
	CALL SUBOPT_0xEB
	CALL SUBOPT_0xEC
	POP  R26
	OR   R30,R26
	BREQ _0x20F
; 0000 149A             {
; 0000 149B             PORTD.7 = 1;
	SBI  0x12,7
; 0000 149C             if(sprawdz_pin5(PORTJJ,0x79) == 1)
	CALL SUBOPT_0x2B
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x212
; 0000 149D                 {
; 0000 149E                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 149F                 komunikat_na_panel("Alarm Sterownik 1",adr1,adr2);
	__POINTW1FN _0x0,1782
	CALL SUBOPT_0x2D
; 0000 14A0                 delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 14A1                 }
; 0000 14A2             if(sprawdz_pin5(PORTLL,0x71) == 1)
_0x212:
	CALL SUBOPT_0xEB
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x213
; 0000 14A3                 {
; 0000 14A4                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 14A5                 komunikat_na_panel("Alarm Sterownik 2",adr1,adr2);
	__POINTW1FN _0x0,1800
	CALL SUBOPT_0x2D
; 0000 14A6                 delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 14A7                 }
; 0000 14A8 
; 0000 14A9             }
_0x213:
; 0000 14AA 
; 0000 14AB       //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 14AC //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 14AD       //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 14AE        //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 14AF 
; 0000 14B0 
; 0000 14B1 
; 0000 14B2       }
_0x20F:
	RJMP _0x1E8
_0x1EA:
; 0000 14B3 
; 0000 14B4 
; 0000 14B5 
; 0000 14B6 
; 0000 14B7 
; 0000 14B8 
; 0000 14B9 
; 0000 14BA //to jest to pozycjonowanie powtornie na wszelki wypadek jak ju¿ osie Y dojecha³y na miejsca
; 0000 14BB PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 14BC delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0xC0
; 0000 14BD PORTD.2 = 1;   //setup poziomy
	SBI  0x12,2
; 0000 14BE delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 14BF PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 14C0 
; 0000 14C1 while(sprawdz_pin3(PORTJJ,0x79) == 1 | sprawdz_pin3(PORTLL,0x71) == 1)
_0x21A:
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xE2
	PUSH R30
	CALL SUBOPT_0xE9
	POP  R26
	OR   R30,R26
	BRNE PC+3
	JMP _0x21C
; 0000 14C2       {
; 0000 14C3 
; 0000 14C4       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
	CALL SUBOPT_0x14
	CALL SUBOPT_0xDF
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0xE0
	POP  R26
	OR   R30,R26
	BREQ _0x21D
; 0000 14C5         while(1)
_0x21E:
; 0000 14C6             {
; 0000 14C7             PORTD.7 = 1;
	SBI  0x12,7
; 0000 14C8             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 14C9             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 14CA             komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
	CALL SUBOPT_0xE5
; 0000 14CB             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 14CC             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xE6
; 0000 14CD 
; 0000 14CE             PORTB.4 = 0;   //setupy piony
	CBI  0x18,4
; 0000 14CF             PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 14D0 
; 0000 14D1             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA3
	CALL _wartosc_parametru_panelu
; 0000 14D2             }
	RJMP _0x21E
; 0000 14D3 
; 0000 14D4 
; 0000 14D5       if(sprawdz_pin2(PORTMM,0x77) == 0)
_0x21D:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin2
	CPI  R30,0
	BRNE _0x229
; 0000 14D6         while(1)
_0x22A:
; 0000 14D7             {
; 0000 14D8             PORTD.7 = 1;
	CALL SUBOPT_0xE4
; 0000 14D9             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
; 0000 14DA 
; 0000 14DB             PORTB.4 = 0;   //setupy piony
; 0000 14DC             PORTD.2 = 0;   //setup wspolny
; 0000 14DD 
; 0000 14DE             komunikat_na_panel("                                                ",adr1,adr2);
; 0000 14DF             komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
	CALL SUBOPT_0xE7
; 0000 14E0             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 14E1             komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
	CALL SUBOPT_0xE6
; 0000 14E2 
; 0000 14E3             wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA3
	CALL _wartosc_parametru_panelu
; 0000 14E4             }
	RJMP _0x22A
; 0000 14E5 
; 0000 14E6       //komunikat_na_panel("                                                ",adr1,adr2);
; 0000 14E7       //komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
; 0000 14E8       //komunikat_na_panel("                                                ",adr3,adr4);
; 0000 14E9       //komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
; 0000 14EA       //delay_ms(1000);
; 0000 14EB 
; 0000 14EC       if(sprawdz_pin3(PORTJJ,0x79) == 0)
_0x229:
	CALL SUBOPT_0x2B
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x235
; 0000 14ED             {
; 0000 14EE             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 14EF             komunikat_na_panel("Sterownik 1 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1720
	CALL SUBOPT_0x2D
; 0000 14F0             }
; 0000 14F1       if(sprawdz_pin3(PORTLL,0x71) == 0)
_0x235:
	CALL SUBOPT_0xEB
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x236
; 0000 14F2             {
; 0000 14F3             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 14F4             komunikat_na_panel("Sterownik 2 - wypozycjonowalem",adr3,adr4);
	__POINTW1FN _0x0,1751
	CALL SUBOPT_0x97
; 0000 14F5             }
; 0000 14F6 
; 0000 14F7        //if(sprawdz_pin7(PORTMM,0x77) == 1)
; 0000 14F8        //     PORTD.7 = 1;
; 0000 14F9 
; 0000 14FA       if(sprawdz_pin5(PORTJJ,0x79) == 1 |
_0x236:
; 0000 14FB          sprawdz_pin5(PORTLL,0x71) == 1)
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xEC
	PUSH R30
	CALL SUBOPT_0xEB
	CALL SUBOPT_0xEC
	POP  R26
	OR   R30,R26
	BREQ _0x237
; 0000 14FC             {
; 0000 14FD             PORTD.7 = 1;
	SBI  0x12,7
; 0000 14FE             if(sprawdz_pin5(PORTJJ,0x79) == 1)
	CALL SUBOPT_0x2B
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x23A
; 0000 14FF                 {
; 0000 1500                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 1501                 komunikat_na_panel("Alarm Sterownik 1",adr1,adr2);
	__POINTW1FN _0x0,1782
	CALL SUBOPT_0x2D
; 0000 1502                 delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 1503                 }
; 0000 1504             if(sprawdz_pin5(PORTLL,0x71) == 1)
_0x23A:
	CALL SUBOPT_0xEB
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x23B
; 0000 1505                 {
; 0000 1506                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 1507                 komunikat_na_panel("Alarm Sterownik 2",adr1,adr2);
	__POINTW1FN _0x0,1800
	CALL SUBOPT_0x2D
; 0000 1508                 delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 1509                 }
; 0000 150A 
; 0000 150B             }
_0x23B:
; 0000 150C 
; 0000 150D       //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 150E //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 150F       //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 1510        //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 1511 
; 0000 1512 
; 0000 1513 
; 0000 1514       }
_0x237:
	RJMP _0x21A
_0x21C:
; 0000 1515 
; 0000 1516 
; 0000 1517 
; 0000 1518 
; 0000 1519 
; 0000 151A 
; 0000 151B 
; 0000 151C 
; 0000 151D 
; 0000 151E 
; 0000 151F 
; 0000 1520 
; 0000 1521 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 1522 komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1818
	CALL SUBOPT_0x2D
; 0000 1523 komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 1524 komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1818
	CALL SUBOPT_0x97
; 0000 1525 
; 0000 1526 PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 1527 PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 1528 delay_ms(1000);
	CALL SUBOPT_0xDE
; 0000 1529 wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xED
; 0000 152A start = 0;
; 0000 152B 
; 0000 152C }
	RET
;
;
;void przerzucanie_dociskow()
; 0000 1530 {
_przerzucanie_dociskow:
; 0000 1531 
; 0000 1532 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x240
; 0000 1533   {
; 0000 1534    if(sprawdz_pin6(PORTLL,0x71) == 0 & sprawdz_pin7(PORTLL,0x71) == 0 & czekaj_az_puszcze == 0)
	CALL SUBOPT_0xEB
	CALL _sprawdz_pin6
	LDI  R26,LOW(0)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0xEB
	CALL _sprawdz_pin7
	LDI  R26,LOW(0)
	CALL __EQB12
	POP  R26
	CALL SUBOPT_0xEE
	CALL SUBOPT_0xEA
	BREQ _0x241
; 0000 1535            {
; 0000 1536            czekaj_az_puszcze = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 1537            //PORTB.6 = 1;
; 0000 1538            }
; 0000 1539        if(sprawdz_pin6(PORTLL,0x71) == 1 & sprawdz_pin7(PORTLL,0x71) == 1 & czekaj_az_puszcze == 1)
_0x241:
	CALL SUBOPT_0xEB
	CALL SUBOPT_0xE8
	PUSH R30
	CALL SUBOPT_0xEB
	CALL SUBOPT_0xE3
	POP  R26
	CALL SUBOPT_0xEE
	CALL SUBOPT_0x84
	AND  R30,R0
	BREQ _0x242
; 0000 153A            {
; 0000 153B            czekaj_az_puszcze = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 153C            //PORTB.6 = 0;
; 0000 153D            }
; 0000 153E 
; 0000 153F        if(czekaj_az_puszcze == 2 & PORTE.6 == 1)
_0x242:
	CALL SUBOPT_0xEF
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x243
; 0000 1540             {
; 0000 1541             PORTE.6 = 0;
	CBI  0x3,6
; 0000 1542             czekaj_az_puszcze = 0;
	CALL SUBOPT_0xF0
; 0000 1543             delay_ms(100);
; 0000 1544             }
; 0000 1545 
; 0000 1546        if(czekaj_az_puszcze == 2 & PORTE.6 == 0)
_0x243:
	CALL SUBOPT_0xEF
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x246
; 0000 1547            {
; 0000 1548             PORTE.6 = 1;
	SBI  0x3,6
; 0000 1549             czekaj_az_puszcze = 0;
	CALL SUBOPT_0xF0
; 0000 154A             delay_ms(100);
; 0000 154B            }
; 0000 154C 
; 0000 154D   }
_0x246:
; 0000 154E }
_0x240:
	RET
;
;void ostateczny_wybor_zacisku()
; 0000 1551 {
_ostateczny_wybor_zacisku:
; 0000 1552 int rzad;
; 0000 1553 
; 0000 1554   if(sek11 > 60) //co 1s sekunde sprawdzam   //jak co 40 to sie wywala
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	LDS  R26,_sek11
	LDS  R27,_sek11+1
	LDS  R24,_sek11+2
	LDS  R25,_sek11+3
	CALL SUBOPT_0x8F
	BRGE PC+3
	JMP _0x249
; 0000 1555         {
; 0000 1556        sek11 = 0;
	CALL SUBOPT_0xF1
; 0000 1557        if(odczytalem_zacisk < il_prob_odczytu &
; 0000 1558                                            (sprawdz_pin0(PORTHH,0x73) == 1 |
; 0000 1559                                             sprawdz_pin1(PORTHH,0x73) == 1 |
; 0000 155A                                             sprawdz_pin2(PORTHH,0x73) == 1 |
; 0000 155B                                             sprawdz_pin3(PORTHH,0x73) == 1 |
; 0000 155C                                             sprawdz_pin4(PORTHH,0x73) == 1 |
; 0000 155D                                             sprawdz_pin5(PORTHH,0x73) == 1 |
; 0000 155E                                             sprawdz_pin6(PORTHH,0x73) == 1 |
; 0000 155F                                             sprawdz_pin7(PORTHH,0x73) == 1))
	CALL SUBOPT_0xF2
	CALL __LTW12
	PUSH R30
	CALL SUBOPT_0x2E
	CALL SUBOPT_0xDF
	PUSH R30
	CALL SUBOPT_0x2E
	CALL SUBOPT_0xE0
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2E
	CALL _sprawdz_pin2
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2E
	CALL SUBOPT_0xE2
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2E
	CALL _sprawdz_pin4
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2E
	CALL SUBOPT_0xEC
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2E
	CALL SUBOPT_0xE8
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x2E
	CALL SUBOPT_0xE3
	POP  R26
	OR   R30,R26
	POP  R26
	AND  R30,R26
	BREQ _0x24A
; 0000 1560         {
; 0000 1561         odczytalem_zacisk++;
	CALL SUBOPT_0xF3
; 0000 1562         }
; 0000 1563         }
_0x24A:
; 0000 1564 
; 0000 1565 if(odczytalem_zacisk == il_prob_odczytu)
_0x249:
	CALL SUBOPT_0xF2
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x24B
; 0000 1566         {
; 0000 1567         //PORTB = 0xFF;
; 0000 1568         rzad = odczyt_wybranego_zacisku();
	CALL _odczyt_wybranego_zacisku
	MOVW R16,R30
; 0000 1569         //sek10 = 0;
; 0000 156A         sek11 = 0;    //nowe
	CALL SUBOPT_0xF1
; 0000 156B         odczytalem_zacisk++;
	CALL SUBOPT_0xF3
; 0000 156C 
; 0000 156D         //if(rzad == 1)
; 0000 156E         //    wartosc_parametru_panelu(2,32,128);    //tego nie chca
; 0000 156F         //if(rzad == 2)
; 0000 1570         //    wartosc_parametru_panelu(1,32,128);
; 0000 1571 
; 0000 1572         }                                     //& sek10 > 1                //3s po odczytaniu dopiero sprawdzam port
; 0000 1573 if((odczytalem_zacisk == il_prob_odczytu + 1))        //183
_0x24B:
	LDS  R30,_il_prob_odczytu
	LDS  R31,_il_prob_odczytu+1
	ADIW R30,1
	LDS  R26,_odczytalem_zacisk
	LDS  R27,_odczytalem_zacisk+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x24C
; 0000 1574         {
; 0000 1575 
; 0000 1576         if(rzad == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x24D
; 0000 1577             wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x23
	CALL _wartosc_parametru_panelu
; 0000 1578 
; 0000 1579         if(rzad == 2 & start == 0)
_0x24D:
	MOVW R26,R16
	CALL SUBOPT_0xF4
	MOV  R0,R30
	CALL SUBOPT_0xF5
	CALL SUBOPT_0xEA
	BREQ _0x24E
; 0000 157A             wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	CALL _wartosc_parametru_panelu
; 0000 157B 
; 0000 157C         if(rzad == 2 & start == 1)
_0x24E:
	MOVW R26,R16
	CALL SUBOPT_0xF4
	CALL SUBOPT_0x9F
	AND  R30,R0
	BREQ _0x24F
; 0000 157D             zaaktualizuj_ilosc_rzad2 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _zaaktualizuj_ilosc_rzad2,R30
	STS  _zaaktualizuj_ilosc_rzad2+1,R31
; 0000 157E 
; 0000 157F 
; 0000 1580         odczytalem_zacisk = 0;
_0x24F:
	LDI  R30,LOW(0)
	STS  _odczytalem_zacisk,R30
	STS  _odczytalem_zacisk+1,R30
; 0000 1581         if(start == 1)
	CALL SUBOPT_0xF5
	SBIW R26,1
	BRNE _0x250
; 0000 1582             odczytalem_w_trakcie_czyszczenia_drugiego_rzedu = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu,R30
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1,R31
; 0000 1583         }
_0x250:
; 0000 1584 }
_0x24C:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;
;int sterownik_1_praca(int PORT)
; 0000 1589 {
_sterownik_1_praca:
; 0000 158A //PORTA.0   IN0  STEROWNIK1
; 0000 158B //PORTA.1   IN1  STEROWNIK1
; 0000 158C //PORTA.2   IN2  STEROWNIK1
; 0000 158D //PORTA.3   IN3  STEROWNIK1
; 0000 158E //PORTA.4   IN4  STEROWNIK1
; 0000 158F //PORTA.5   IN5  STEROWNIK1
; 0000 1590 //PORTA.6   IN6  STEROWNIK1
; 0000 1591 //PORTA.7   IN7  STEROWNIK1
; 0000 1592 //PORTD.4   IN8 STEROWNIK1
; 0000 1593 
; 0000 1594 //PORTD.2  SETUP   STEROWNIK1
; 0000 1595 //PORTD.3  DRIVE   STEROWNIK1
; 0000 1596 
; 0000 1597 //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 1598 //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 1599 
; 0000 159A if(sprawdz_pin5(PORTJJ,0x79) == 1)     //if alarn
;	PORT -> Y+0
	CALL SUBOPT_0x2B
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x251
; 0000 159B     {
; 0000 159C     PORTD.7 = 1;
	CALL SUBOPT_0xF6
; 0000 159D     PORTE.2 = 0;
; 0000 159E     PORTE.3 = 0;  //szlifierki stop
; 0000 159F     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 15A0     PORTF = PORT_F.byte;
; 0000 15A1 
; 0000 15A2     while(1)
_0x258:
; 0000 15A3         {
; 0000 15A4         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 15A5         komunikat_na_panel("Kolizja XY ukladu krazka",adr1,adr2);
	__POINTW1FN _0x0,1853
	CALL SUBOPT_0x2D
; 0000 15A6         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 15A7         komunikat_na_panel("Kolizja XY ukladu krazka",adr3,adr4);
	__POINTW1FN _0x0,1853
	CALL SUBOPT_0x97
; 0000 15A8         }
	RJMP _0x258
; 0000 15A9 
; 0000 15AA     }
; 0000 15AB 
; 0000 15AC if(start == 1)
_0x251:
	CALL SUBOPT_0xF5
	SBIW R26,1
	BRNE _0x25B
; 0000 15AD     {
; 0000 15AE     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xF7
; 0000 15AF     obsluga_nacisniecia_zatrzymaj();
; 0000 15B0     }
; 0000 15B1 switch(cykl_sterownik_1)
_0x25B:
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
; 0000 15B2         {
; 0000 15B3         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x25F
; 0000 15B4 
; 0000 15B5             sek1 = 0;
	CALL SUBOPT_0xF8
; 0000 15B6             PORT_STER1.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER1,R30
; 0000 15B7             PORTA.0 = PORT_STER1.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x260
	CBI  0x1B,0
	RJMP _0x261
_0x260:
	SBI  0x1B,0
_0x261:
; 0000 15B8             PORTA.1 = PORT_STER1.bits.b1;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x2)
	BRNE _0x262
	CBI  0x1B,1
	RJMP _0x263
_0x262:
	SBI  0x1B,1
_0x263:
; 0000 15B9             PORTA.2 = PORT_STER1.bits.b2;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x4)
	BRNE _0x264
	CBI  0x1B,2
	RJMP _0x265
_0x264:
	SBI  0x1B,2
_0x265:
; 0000 15BA             PORTA.3 = PORT_STER1.bits.b3;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x8)
	BRNE _0x266
	CBI  0x1B,3
	RJMP _0x267
_0x266:
	SBI  0x1B,3
_0x267:
; 0000 15BB             PORTA.4 = PORT_STER1.bits.b4;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x10)
	BRNE _0x268
	CBI  0x1B,4
	RJMP _0x269
_0x268:
	SBI  0x1B,4
_0x269:
; 0000 15BC             PORTA.5 = PORT_STER1.bits.b5;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x20)
	BRNE _0x26A
	CBI  0x1B,5
	RJMP _0x26B
_0x26A:
	SBI  0x1B,5
_0x26B:
; 0000 15BD             PORTA.6 = PORT_STER1.bits.b6;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x40)
	BRNE _0x26C
	CBI  0x1B,6
	RJMP _0x26D
_0x26C:
	SBI  0x1B,6
_0x26D:
; 0000 15BE             PORTA.7 = PORT_STER1.bits.b7;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x80)
	BRNE _0x26E
	CBI  0x1B,7
	RJMP _0x26F
_0x26E:
	SBI  0x1B,7
_0x26F:
; 0000 15BF 
; 0000 15C0             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x270
; 0000 15C1                 PORTD.4 = 1;
	SBI  0x12,4
; 0000 15C2 
; 0000 15C3 
; 0000 15C4 
; 0000 15C5             cykl_sterownik_1 = 1;
_0x270:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x585
; 0000 15C6 
; 0000 15C7         break;
; 0000 15C8 
; 0000 15C9         case 1:
_0x25F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x273
; 0000 15CA 
; 0000 15CB             if(sek1 > 1)
	LDS  R26,_sek1
	LDS  R27,_sek1+1
	LDS  R24,_sek1+2
	LDS  R25,_sek1+3
	CALL SUBOPT_0xF9
	BRLT _0x274
; 0000 15CC                 {
; 0000 15CD 
; 0000 15CE                 PORTD.3 = 1;
	SBI  0x12,3
; 0000 15CF                 cykl_sterownik_1 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xFA
; 0000 15D0                 }
; 0000 15D1         break;
_0x274:
	RJMP _0x25E
; 0000 15D2 
; 0000 15D3 
; 0000 15D4         case 2:
_0x273:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x277
; 0000 15D5 
; 0000 15D6                if(sprawdz_pin0(PORTJJ,0x79) == 0)     //busy
	CALL SUBOPT_0x2B
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x278
; 0000 15D7                   {
; 0000 15D8 
; 0000 15D9                   PORTD.3 = 0;
	CBI  0x12,3
; 0000 15DA                   PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 15DB                   PORTD.4 = 0;
	CBI  0x12,4
; 0000 15DC                   sek1 = 0;
	CALL SUBOPT_0xF8
; 0000 15DD                   cykl_sterownik_1 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xFA
; 0000 15DE                   }
; 0000 15DF 
; 0000 15E0         break;
_0x278:
	RJMP _0x25E
; 0000 15E1 
; 0000 15E2         case 3:
_0x277:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x27D
; 0000 15E3 
; 0000 15E4                if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x2B
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x27E
; 0000 15E5                   {
; 0000 15E6 
; 0000 15E7                   sek1 = 0;
	CALL SUBOPT_0xF8
; 0000 15E8                   cykl_sterownik_1 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xFA
; 0000 15E9                   }
; 0000 15EA 
; 0000 15EB 
; 0000 15EC         break;
_0x27E:
	RJMP _0x25E
; 0000 15ED 
; 0000 15EE 
; 0000 15EF         case 4:
_0x27D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x25E
; 0000 15F0 
; 0000 15F1             if(sprawdz_pin0(PORTJJ,0x79) == 1)
	CALL SUBOPT_0x2B
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x280
; 0000 15F2                 {
; 0000 15F3 
; 0000 15F4                 cykl_sterownik_1 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x585:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
; 0000 15F5                 }
; 0000 15F6         break;
_0x280:
; 0000 15F7 
; 0000 15F8         }
_0x25E:
; 0000 15F9 
; 0000 15FA return cykl_sterownik_1;
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
	RJMP _0x20A0001
; 0000 15FB }
;
;
;int sterownik_2_praca(int PORT)
; 0000 15FF {
_sterownik_2_praca:
; 0000 1600 //PORTC.0   IN0  STEROWNIK2
; 0000 1601 //PORTC.1   IN1  STEROWNIK2
; 0000 1602 //PORTC.2   IN2  STEROWNIK2
; 0000 1603 //PORTC.3   IN3  STEROWNIK2
; 0000 1604 //PORTC.4   IN4  STEROWNIK2
; 0000 1605 //PORTC.5   IN5  STEROWNIK2
; 0000 1606 //PORTC.6   IN6  STEROWNIK2
; 0000 1607 //PORTC.7   IN7  STEROWNIK2
; 0000 1608 //PORTD.5   IN8 STEROWNIK2
; 0000 1609 
; 0000 160A 
; 0000 160B //PORTD.5  SETUP   STEROWNIK2
; 0000 160C //PORTD.6  DRIVE   STEROWNIK2
; 0000 160D 
; 0000 160E //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 160F //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 1610 
; 0000 1611  if(sprawdz_pin5(PORTLL,0x71) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0xEB
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x281
; 0000 1612     {
; 0000 1613     PORTD.7 = 1;
	CALL SUBOPT_0xF6
; 0000 1614     PORTE.2 = 0;
; 0000 1615     PORTE.3 = 0;  //szlifierki stop
; 0000 1616     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1617     PORTF = PORT_F.byte;
; 0000 1618 
; 0000 1619     while(1)
_0x288:
; 0000 161A         {
; 0000 161B         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 161C         komunikat_na_panel("Kolizja XY ukladu szczotki",adr1,adr2);
	__POINTW1FN _0x0,1878
	CALL SUBOPT_0x2D
; 0000 161D         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 161E         komunikat_na_panel("Kolizja XY ukladu szczotki",adr3,adr4);
	__POINTW1FN _0x0,1878
	CALL SUBOPT_0x97
; 0000 161F         }
	RJMP _0x288
; 0000 1620 
; 0000 1621     }
; 0000 1622 if(start == 1)
_0x281:
	CALL SUBOPT_0xF5
	SBIW R26,1
	BRNE _0x28B
; 0000 1623     {
; 0000 1624     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xF7
; 0000 1625     obsluga_nacisniecia_zatrzymaj();
; 0000 1626     }
; 0000 1627 switch(cykl_sterownik_2)
_0x28B:
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
; 0000 1628         {
; 0000 1629         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x28F
; 0000 162A 
; 0000 162B             sek3 = 0;
	CALL SUBOPT_0xFB
; 0000 162C             PORT_STER2.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER2,R30
; 0000 162D             PORTC.0 = PORT_STER2.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x290
	CBI  0x15,0
	RJMP _0x291
_0x290:
	SBI  0x15,0
_0x291:
; 0000 162E             PORTC.1 = PORT_STER2.bits.b1;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x2)
	BRNE _0x292
	CBI  0x15,1
	RJMP _0x293
_0x292:
	SBI  0x15,1
_0x293:
; 0000 162F             PORTC.2 = PORT_STER2.bits.b2;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x4)
	BRNE _0x294
	CBI  0x15,2
	RJMP _0x295
_0x294:
	SBI  0x15,2
_0x295:
; 0000 1630             PORTC.3 = PORT_STER2.bits.b3;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x8)
	BRNE _0x296
	CBI  0x15,3
	RJMP _0x297
_0x296:
	SBI  0x15,3
_0x297:
; 0000 1631             PORTC.4 = PORT_STER2.bits.b4;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x10)
	BRNE _0x298
	CBI  0x15,4
	RJMP _0x299
_0x298:
	SBI  0x15,4
_0x299:
; 0000 1632             PORTC.5 = PORT_STER2.bits.b5;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x20)
	BRNE _0x29A
	CBI  0x15,5
	RJMP _0x29B
_0x29A:
	SBI  0x15,5
_0x29B:
; 0000 1633             PORTC.6 = PORT_STER2.bits.b6;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x40)
	BRNE _0x29C
	CBI  0x15,6
	RJMP _0x29D
_0x29C:
	SBI  0x15,6
_0x29D:
; 0000 1634             PORTC.7 = PORT_STER2.bits.b7;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x80)
	BRNE _0x29E
	CBI  0x15,7
	RJMP _0x29F
_0x29E:
	SBI  0x15,7
_0x29F:
; 0000 1635             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x2A0
; 0000 1636                 PORTD.5 = 1;
	SBI  0x12,5
; 0000 1637 
; 0000 1638 
; 0000 1639             cykl_sterownik_2 = 1;
_0x2A0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x586
; 0000 163A 
; 0000 163B 
; 0000 163C         break;
; 0000 163D 
; 0000 163E         case 1:
_0x28F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2A3
; 0000 163F 
; 0000 1640             if(sek3 > 1)
	LDS  R26,_sek3
	LDS  R27,_sek3+1
	LDS  R24,_sek3+2
	LDS  R25,_sek3+3
	CALL SUBOPT_0xF9
	BRLT _0x2A4
; 0000 1641                 {
; 0000 1642                 PORTD.6 = 1;
	SBI  0x12,6
; 0000 1643                 cykl_sterownik_2 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xFC
; 0000 1644                 }
; 0000 1645         break;
_0x2A4:
	RJMP _0x28E
; 0000 1646 
; 0000 1647 
; 0000 1648         case 2:
_0x2A3:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2A7
; 0000 1649 
; 0000 164A                if(sprawdz_pin0(PORTLL,0x71) == 0)     //busy
	CALL SUBOPT_0xEB
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x2A8
; 0000 164B                   {
; 0000 164C                   PORTD.6 = 0;
	CBI  0x12,6
; 0000 164D                   PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 164E                   PORTD.5 = 0;
	CBI  0x12,5
; 0000 164F                   sek3 = 0;
	CALL SUBOPT_0xFB
; 0000 1650                   cykl_sterownik_2 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xFC
; 0000 1651                   }
; 0000 1652 
; 0000 1653         break;
_0x2A8:
	RJMP _0x28E
; 0000 1654 
; 0000 1655         case 3:
_0x2A7:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2AD
; 0000 1656 
; 0000 1657                if(sprawdz_pin3(PORTLL,0x71) == 0)
	CALL SUBOPT_0xEB
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x2AE
; 0000 1658                   {
; 0000 1659                   sek3 = 0;
	CALL SUBOPT_0xFB
; 0000 165A                   cykl_sterownik_2 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xFC
; 0000 165B                   }
; 0000 165C 
; 0000 165D 
; 0000 165E         break;
_0x2AE:
	RJMP _0x28E
; 0000 165F 
; 0000 1660 
; 0000 1661         case 4:
_0x2AD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x28E
; 0000 1662 
; 0000 1663             if(sprawdz_pin0(PORTLL,0x71) == 1)
	CALL SUBOPT_0xEB
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x2B0
; 0000 1664                 {
; 0000 1665                 cykl_sterownik_2 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x586:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
; 0000 1666                 }
; 0000 1667         break;
_0x2B0:
; 0000 1668 
; 0000 1669         }
_0x28E:
; 0000 166A 
; 0000 166B return cykl_sterownik_2;
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
	RJMP _0x20A0001
; 0000 166C }
;
;
;
;
;
;
;int sterownik_3_praca(int PORT)
; 0000 1674 {
_sterownik_3_praca:
; 0000 1675 //PORTF.0   IN0  STEROWNIK3
; 0000 1676 //PORTF.1   IN1  STEROWNIK3
; 0000 1677 //PORTF.2   IN2  STEROWNIK3
; 0000 1678 //PORTF.3   IN3  STEROWNIK3
; 0000 1679 //PORTF.7   IN4 STEROWNIK 3
; 0000 167A //PORTB.7   IN5 STEROWNIK 3
; 0000 167B 
; 0000 167C 
; 0000 167D 
; 0000 167E //PORTF.5   DRIVE  STEROWNIK3
; 0000 167F 
; 0000 1680 //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 1681 //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 1682 
; 0000 1683 if(sprawdz_pin7(PORTMM,0x77) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0x14
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x2B1
; 0000 1684      {
; 0000 1685      PORTD.7 = 1;
	CALL SUBOPT_0xF6
; 0000 1686      PORTE.2 = 0;
; 0000 1687      PORTE.3 = 0;  //szlifierki stop
; 0000 1688      PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1689      PORTF = PORT_F.byte;
; 0000 168A 
; 0000 168B      while(1)
_0x2B8:
; 0000 168C         {
; 0000 168D         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 168E         komunikat_na_panel("Kolizja krazka - wylacz i wlacz maszyne",adr1,adr2);
	__POINTW1FN _0x0,1905
	CALL SUBOPT_0x2D
; 0000 168F         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 1690         komunikat_na_panel("Kolizja krazka - wylacz i wlacz maszyne",adr3,adr4);
	__POINTW1FN _0x0,1905
	CALL SUBOPT_0x97
; 0000 1691         }
	RJMP _0x2B8
; 0000 1692      }
; 0000 1693 if(start == 1)
_0x2B1:
	CALL SUBOPT_0xF5
	SBIW R26,1
	BRNE _0x2BB
; 0000 1694     {
; 0000 1695     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xF7
; 0000 1696     obsluga_nacisniecia_zatrzymaj();
; 0000 1697 
; 0000 1698     }
; 0000 1699 switch(cykl_sterownik_3)
_0x2BB:
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
; 0000 169A         {
; 0000 169B         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x2BF
; 0000 169C 
; 0000 169D             PORT_STER3.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER3,R30
; 0000 169E             PORT_F.bits.b0 = PORT_STER3.bits.b0;
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0xFD
; 0000 169F             PORT_F.bits.b1 = PORT_STER3.bits.b1;
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFD
	CALL SUBOPT_0xFD
; 0000 16A0             PORT_F.bits.b2 = PORT_STER3.bits.b2;
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFB
	CALL SUBOPT_0xFD
; 0000 16A1             PORT_F.bits.b3 = PORT_STER3.bits.b3;
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
	CALL SUBOPT_0xFD
; 0000 16A2             PORT_F.bits.b7 = PORT_STER3.bits.b4;
	SWAP R30
	ANDI R30,LOW(0x1)
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0x7F
	OR   R30,R0
	CALL SUBOPT_0xFE
; 0000 16A3             PORTF = PORT_F.byte;
; 0000 16A4             PORTB.7 = PORT_STER3.bits.b5;
	LDS  R30,_PORT_STER3
	ANDI R30,LOW(0x20)
	BRNE _0x2C0
	CBI  0x18,7
	RJMP _0x2C1
_0x2C0:
	SBI  0x18,7
_0x2C1:
; 0000 16A5 
; 0000 16A6 
; 0000 16A7 
; 0000 16A8             sek2 = 0;
	CALL SUBOPT_0xFF
; 0000 16A9             cykl_sterownik_3 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x100
; 0000 16AA 
; 0000 16AB 
; 0000 16AC 
; 0000 16AD         break;
	RJMP _0x2BE
; 0000 16AE 
; 0000 16AF         case 1:
_0x2BF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2C2
; 0000 16B0 
; 0000 16B1 
; 0000 16B2             if(sek2 > 1)
	LDS  R26,_sek2
	LDS  R27,_sek2+1
	LDS  R24,_sek2+2
	LDS  R25,_sek2+3
	CALL SUBOPT_0xF9
	BRLT _0x2C3
; 0000 16B3                 {
; 0000 16B4 
; 0000 16B5                 PORT_F.bits.b5 = 1;
	LDS  R30,_PORT_F
	ORI  R30,0x20
	CALL SUBOPT_0xFE
; 0000 16B6                 PORTF = PORT_F.byte;
; 0000 16B7                 cykl_sterownik_3 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x100
; 0000 16B8                 }
; 0000 16B9         break;
_0x2C3:
	RJMP _0x2BE
; 0000 16BA 
; 0000 16BB 
; 0000 16BC         case 2:
_0x2C2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2C4
; 0000 16BD 
; 0000 16BE 
; 0000 16BF                if(sprawdz_pin0(PORTKK,0x75) == 0)
	CALL SUBOPT_0xE1
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x2C5
; 0000 16C0                   {
; 0000 16C1                   PORT_F.bits.b5 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xDF
	CALL SUBOPT_0xFE
; 0000 16C2                   PORTF = PORT_F.byte;
; 0000 16C3 
; 0000 16C4                   PORT_F.bits.b0 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0x101
; 0000 16C5                   PORT_F.bits.b1 = 0;
	ANDI R30,0xFD
	CALL SUBOPT_0x101
; 0000 16C6                   PORT_F.bits.b2 = 0;
	ANDI R30,0xFB
	CALL SUBOPT_0x101
; 0000 16C7                   PORT_F.bits.b3 = 0;
	ANDI R30,0XF7
	CALL SUBOPT_0x101
; 0000 16C8                   PORT_F.bits.b7 = 0;
	ANDI R30,0x7F
	CALL SUBOPT_0xFE
; 0000 16C9                   PORTF = PORT_F.byte;
; 0000 16CA                   PORTB.7 = 0;
	CBI  0x18,7
; 0000 16CB 
; 0000 16CC                   sek2 = 0;
	CALL SUBOPT_0xFF
; 0000 16CD                   cykl_sterownik_3 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x100
; 0000 16CE                   }
; 0000 16CF 
; 0000 16D0         break;
_0x2C5:
	RJMP _0x2BE
; 0000 16D1 
; 0000 16D2         case 3:
_0x2C4:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2C8
; 0000 16D3 
; 0000 16D4 
; 0000 16D5                if(sprawdz_pin3(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0xE1
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x2C9
; 0000 16D6                   {
; 0000 16D7                   sek2 = 0;
	CALL SUBOPT_0xFF
; 0000 16D8                   cykl_sterownik_3 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x100
; 0000 16D9                   }
; 0000 16DA 
; 0000 16DB 
; 0000 16DC         break;
_0x2C9:
	RJMP _0x2BE
; 0000 16DD 
; 0000 16DE 
; 0000 16DF         case 4:
_0x2C8:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2BE
; 0000 16E0 
; 0000 16E1               if(sprawdz_pin0(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0xE1
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x2CB
; 0000 16E2                 {
; 0000 16E3                 cykl_sterownik_3 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x100
; 0000 16E4 
; 0000 16E5 
; 0000 16E6                 switch(cykl_sterownik_3_wykonalem)
	LDS  R30,_cykl_sterownik_3_wykonalem
	LDS  R31,_cykl_sterownik_3_wykonalem+1
; 0000 16E7                     {
; 0000 16E8                     case 0:
	SBIW R30,0
	BRNE _0x2CF
; 0000 16E9                             cykl_sterownik_3_wykonalem = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R31
; 0000 16EA                     break;
	RJMP _0x2CE
; 0000 16EB 
; 0000 16EC                     case 1:
_0x2CF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2CE
; 0000 16ED                             cykl_sterownik_3_wykonalem = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R30
; 0000 16EE                     break;
; 0000 16EF 
; 0000 16F0                     }
_0x2CE:
; 0000 16F1 
; 0000 16F2 
; 0000 16F3                 }
; 0000 16F4         break;
_0x2CB:
; 0000 16F5 
; 0000 16F6         }
_0x2BE:
; 0000 16F7 
; 0000 16F8 return cykl_sterownik_3;
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
_0x20A0001:
	ADIW R28,2
	RET
; 0000 16F9 }
;
;//
;//int sterownik_4_praca(char f,char e,char d, char c, char b, char a)
;int sterownik_4_praca(int PORT,int p)
; 0000 16FE {
_sterownik_4_praca:
; 0000 16FF 
; 0000 1700 
; 0000 1701 //PORTB.0   IN0  STEROWNIK4
; 0000 1702 //PORTB.1   IN1  STEROWNIK4
; 0000 1703 //PORTB.2   IN2  STEROWNIK4
; 0000 1704 //PORTB.3   IN3  STEROWNIK4
; 0000 1705 //PORTE.4  IN4  STEROWNIK4
; 0000 1706 
; 0000 1707 
; 0000 1708 
; 0000 1709 //PORTB.4   SETUP  STEROWNIK4
; 0000 170A //PORTB.5   DRIVE  STEROWNIK4
; 0000 170B 
; 0000 170C //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 170D //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 170E 
; 0000 170F if(sprawdz_pin6(PORTMM,0x77) == 1)
;	PORT -> Y+2
;	p -> Y+0
	CALL SUBOPT_0x14
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x2D1
; 0000 1710     {
; 0000 1711     PORTD.7 = 1;
	CALL SUBOPT_0xF6
; 0000 1712     PORTE.2 = 0;
; 0000 1713     PORTE.3 = 0;
; 0000 1714     PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 1715     PORTF = PORT_F.byte;
; 0000 1716 
; 0000 1717     while(1)
_0x2D8:
; 0000 1718         {
; 0000 1719         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x2C
; 0000 171A         komunikat_na_panel("Kolizja szcz. drucianej - wylacz i wlacz maszyne",adr1,adr2);
	__POINTW1FN _0x0,1945
	CALL SUBOPT_0x2D
; 0000 171B         komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x96
; 0000 171C         komunikat_na_panel("Kolizja szcz. drucianej - wylacz i wlacz maszyne",adr3,adr4);
	__POINTW1FN _0x0,1945
	CALL SUBOPT_0x97
; 0000 171D         }
	RJMP _0x2D8
; 0000 171E 
; 0000 171F     }
; 0000 1720 if(start == 1)
_0x2D1:
	CALL SUBOPT_0xF5
	SBIW R26,1
	BRNE _0x2DB
; 0000 1721     {
; 0000 1722     obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xF7
; 0000 1723     obsluga_nacisniecia_zatrzymaj();
; 0000 1724     }
; 0000 1725 switch(cykl_sterownik_4)
_0x2DB:
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
; 0000 1726         {
; 0000 1727         case 0:
	SBIW R30,0
	BRNE _0x2DF
; 0000 1728 
; 0000 1729             PORT_STER4.byte = PORT;
	LDD  R30,Y+2
	STS  _PORT_STER4,R30
; 0000 172A             PORTB.0 = PORT_STER4.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x2E0
	CBI  0x18,0
	RJMP _0x2E1
_0x2E0:
	SBI  0x18,0
_0x2E1:
; 0000 172B             PORTB.1 = PORT_STER4.bits.b1;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x2)
	BRNE _0x2E2
	CBI  0x18,1
	RJMP _0x2E3
_0x2E2:
	SBI  0x18,1
_0x2E3:
; 0000 172C             PORTB.2 = PORT_STER4.bits.b2;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x4)
	BRNE _0x2E4
	CBI  0x18,2
	RJMP _0x2E5
_0x2E4:
	SBI  0x18,2
_0x2E5:
; 0000 172D             PORTB.3 = PORT_STER4.bits.b3;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x8)
	BRNE _0x2E6
	CBI  0x18,3
	RJMP _0x2E7
_0x2E6:
	SBI  0x18,3
_0x2E7:
; 0000 172E             PORTE.4 = PORT_STER4.bits.b4;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x10)
	BRNE _0x2E8
	CBI  0x3,4
	RJMP _0x2E9
_0x2E8:
	SBI  0x3,4
_0x2E9:
; 0000 172F 
; 0000 1730 
; 0000 1731             sek4 = 0;
	CALL SUBOPT_0x102
; 0000 1732             cykl_sterownik_4 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x587
; 0000 1733 
; 0000 1734         break;
; 0000 1735 
; 0000 1736         case 1:
_0x2DF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2EA
; 0000 1737 
; 0000 1738             if(sek4 > 1)
	LDS  R26,_sek4
	LDS  R27,_sek4+1
	LDS  R24,_sek4+2
	LDS  R25,_sek4+3
	CALL SUBOPT_0xF9
	BRLT _0x2EB
; 0000 1739                 {
; 0000 173A                 PORTB.5 = 1;
	SBI  0x18,5
; 0000 173B                 cykl_sterownik_4 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x103
; 0000 173C                 }
; 0000 173D         break;
_0x2EB:
	RJMP _0x2DE
; 0000 173E 
; 0000 173F 
; 0000 1740         case 2:
_0x2EA:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2EE
; 0000 1741 
; 0000 1742                if(sprawdz_pin4(PORTKK,0x75) == 0)
	CALL SUBOPT_0xE1
	CALL _sprawdz_pin4
	CPI  R30,0
	BRNE _0x2EF
; 0000 1743                   {
; 0000 1744                   PORTB.5 = 0;  //drive
	CBI  0x18,5
; 0000 1745 
; 0000 1746                   PORTB.0 = 0;
	CBI  0x18,0
; 0000 1747                   PORTB.1 = 0;
	CBI  0x18,1
; 0000 1748                   PORTB.2 = 0;
	CBI  0x18,2
; 0000 1749                   PORTB.3 = 0;
	CBI  0x18,3
; 0000 174A                   PORTE.4 = 0;
	CBI  0x3,4
; 0000 174B 
; 0000 174C 
; 0000 174D                   sek4 = 0;
	CALL SUBOPT_0x102
; 0000 174E                   cykl_sterownik_4 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x103
; 0000 174F                   }
; 0000 1750 
; 0000 1751         break;
_0x2EF:
	RJMP _0x2DE
; 0000 1752 
; 0000 1753         case 3:
_0x2EE:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2FC
; 0000 1754 
; 0000 1755                if(sprawdz_pin7(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0xE1
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x2FD
; 0000 1756                   {
; 0000 1757                   //if(p == 1)
; 0000 1758                   //  PORTE.2 = 1;  //wylaczam do testu
; 0000 1759 
; 0000 175A                   sek4 = 0;
	CALL SUBOPT_0x102
; 0000 175B                   cykl_sterownik_4 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x103
; 0000 175C                   }
; 0000 175D 
; 0000 175E 
; 0000 175F         break;
_0x2FD:
	RJMP _0x2DE
; 0000 1760 
; 0000 1761 
; 0000 1762         case 4:
_0x2FC:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2DE
; 0000 1763 
; 0000 1764               if(sprawdz_pin4(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0xE1
	CALL _sprawdz_pin4
	CPI  R30,LOW(0x1)
	BRNE _0x2FF
; 0000 1765                 {
; 0000 1766                 cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x587:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
; 0000 1767                 }
; 0000 1768         break;
_0x2FF:
; 0000 1769 
; 0000 176A         }
_0x2DE:
; 0000 176B 
; 0000 176C return cykl_sterownik_4;
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
	ADIW R28,4
	RET
; 0000 176D }
;
;
;void test_geometryczny()
; 0000 1771 {
_test_geometryczny:
; 0000 1772 int cykl_testu,d;
; 0000 1773 int ff[12];
; 0000 1774 int i;
; 0000 1775 d = 0;
	SBIW R28,24
	CALL __SAVELOCR6
;	cykl_testu -> R16,R17
;	d -> R18,R19
;	ff -> Y+6
;	i -> R20,R21
	__GETWRN 18,19,0
; 0000 1776 cykl_testu = 0;
	__GETWRN 16,17,0
; 0000 1777 
; 0000 1778 for(i=0;i<11;i++)
	__GETWRN 20,21,0
_0x301:
	__CPWRN 20,21,11
	BRGE _0x302
; 0000 1779      ff[i]=0;
	MOVW R30,R20
	CALL SUBOPT_0x104
	CALL SUBOPT_0x3E
	__ADDWRN 20,21,1
	RJMP _0x301
_0x302:
; 0000 177C manualny_wybor_zacisku = 145;
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	STS  _manualny_wybor_zacisku,R30
	STS  _manualny_wybor_zacisku+1,R31
; 0000 177D manualny_wybor_zacisku = odczytaj_parametr(48,128);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x18
	STS  _manualny_wybor_zacisku,R30
	STS  _manualny_wybor_zacisku+1,R31
; 0000 177E 
; 0000 177F if(manualny_wybor_zacisku != 145)
	LDS  R26,_manualny_wybor_zacisku
	LDS  R27,_manualny_wybor_zacisku+1
	CPI  R26,LOW(0x91)
	LDI  R30,HIGH(0x91)
	CPC  R27,R30
	BREQ _0x303
; 0000 1780     {
; 0000 1781     macierz_zaciskow[1] = manualny_wybor_zacisku;
	LDS  R30,_manualny_wybor_zacisku
	LDS  R31,_manualny_wybor_zacisku+1
	__PUTW1MN _macierz_zaciskow,2
; 0000 1782     macierz_zaciskow[2] = manualny_wybor_zacisku;
	__PUTW1MN _macierz_zaciskow,4
; 0000 1783     }
; 0000 1784 
; 0000 1785                                                                    //swiatlo czer       //swiatlo zolte & PORT_F.bits.b6 == 0
; 0000 1786 if(test_geometryczny_rzad_1 == 1 & test_geometryczny_rzad_2 == 0 & PORTD.7 == 0   &
_0x303:
; 0000 1787     il_zaciskow_rzad_1 > 1 & macierz_zaciskow[1]!=0 & sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x105
	CALL SUBOPT_0x84
	MOV  R0,R30
	CALL SUBOPT_0x106
	CALL SUBOPT_0x107
	CALL SUBOPT_0x108
	CALL SUBOPT_0x109
	CALL SUBOPT_0x10A
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
	JMP _0x304
; 0000 1788     {
; 0000 1789     while(test_geometryczny_rzad_1 == 1)
_0x305:
	CALL SUBOPT_0x105
	SBIW R26,1
	BREQ PC+3
	JMP _0x307
; 0000 178A         {
; 0000 178B         switch(cykl_testu)
	MOVW R30,R16
; 0000 178C             {
; 0000 178D              case 0:
	SBIW R30,0
	BRNE _0x30B
; 0000 178E 
; 0000 178F                wybor_linijek_sterownikow(1);
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x10B
; 0000 1790                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1791                cykl_sterownik_1 = 0;
; 0000 1792                cykl_sterownik_2 = 0;
; 0000 1793                cykl_sterownik_3 = 0;
; 0000 1794                cykl_sterownik_4 = 0;
; 0000 1795                wybor_linijek_sterownikow(1);
	CALL SUBOPT_0xC2
	CALL _wybor_linijek_sterownikow
; 0000 1796                cykl_testu = 1;
	__GETWRN 16,17,1
; 0000 1797 
; 0000 1798 
; 0000 1799 
; 0000 179A             break;
	RJMP _0x30A
; 0000 179B 
; 0000 179C             case 1:
_0x30B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x30E
; 0000 179D 
; 0000 179E             //na sam dol zjezdzamy pionami
; 0000 179F                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x30F
; 0000 17A0                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10D
; 0000 17A1                 if(cykl_sterownik_4 < 5)
_0x30F:
	CALL SUBOPT_0x10E
	SBIW R26,5
	BRGE _0x310
; 0000 17A2                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 17A3 
; 0000 17A4                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x310:
	CALL SUBOPT_0x110
	BREQ _0x311
; 0000 17A5                                         {
; 0000 17A6                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x111
; 0000 17A7                                         cykl_sterownik_4 = 0;
; 0000 17A8                                         cykl_testu = 2;
	__GETWRN 16,17,2
; 0000 17A9                                         }
; 0000 17AA 
; 0000 17AB 
; 0000 17AC 
; 0000 17AD             break;
_0x311:
	RJMP _0x30A
; 0000 17AE 
; 0000 17AF 
; 0000 17B0             case 2:
_0x30E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x312
; 0000 17B1 
; 0000 17B2                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x313
; 0000 17B3                                     cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x113
; 0000 17B4                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy
_0x313:
	CALL SUBOPT_0x114
	SBIW R26,5
	BRGE _0x314
; 0000 17B5                                     cykl_sterownik_2 = sterownik_2_praca(0x008);       //ster 2 ucieczka do zera (druciak)
	CALL SUBOPT_0x115
	CALL SUBOPT_0x116
; 0000 17B6 
; 0000 17B7                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x314:
	CALL SUBOPT_0x117
	BREQ _0x315
; 0000 17B8                                         {
; 0000 17B9                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 17BA                                         cykl_sterownik_2 = 0;
; 0000 17BB                                         cykl_sterownik_3 = 0;
; 0000 17BC                                         cykl_sterownik_4 = 0;
; 0000 17BD                                         cykl_testu = 3;
	__GETWRN 16,17,3
; 0000 17BE 
; 0000 17BF                                         }
; 0000 17C0 
; 0000 17C1             break;
_0x315:
	RJMP _0x30A
; 0000 17C2 
; 0000 17C3 
; 0000 17C4             case 3:
_0x312:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x316
; 0000 17C5 
; 0000 17C6                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x317
; 0000 17C7                                     cykl_sterownik_1 = sterownik_1_praca(a[0]); //ster 1 pod srodek zacisku
	CALL SUBOPT_0x119
	CALL SUBOPT_0x113
; 0000 17C8 
; 0000 17C9                                     if(cykl_sterownik_1 == 5)
_0x317:
	CALL SUBOPT_0x112
	SBIW R26,5
	BRNE _0x318
; 0000 17CA                                         {
; 0000 17CB                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 17CC                                         cykl_sterownik_2 = 0;
; 0000 17CD                                         cykl_sterownik_3 = 0;
; 0000 17CE                                         cykl_sterownik_4 = 0;
; 0000 17CF                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 17D0                                         }
; 0000 17D1 
; 0000 17D2             break;
_0x318:
	RJMP _0x30A
; 0000 17D3 
; 0000 17D4             case 4:
_0x316:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x319
; 0000 17D5 
; 0000 17D6                                    if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x31A
; 0000 17D7                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x11A
; 0000 17D8 
; 0000 17D9                                    if(cykl_sterownik_3 == 5)
_0x31A:
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRNE _0x31B
; 0000 17DA                                         {
; 0000 17DB                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 17DC                                         cykl_sterownik_2 = 0;
; 0000 17DD                                         cykl_sterownik_3 = 0;
; 0000 17DE                                         cykl_sterownik_4 = 0;
; 0000 17DF                                         cykl_testu = 5;
	__GETWRN 16,17,5
; 0000 17E0                                         }
; 0000 17E1 
; 0000 17E2             break;
_0x31B:
	RJMP _0x30A
; 0000 17E3 
; 0000 17E4             case 5:
_0x319:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x31C
; 0000 17E5                                    if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x31D
; 0000 17E6                                    {
; 0000 17E7                                      d = odczytaj_parametr(48,80);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x26
	MOVW R18,R30
; 0000 17E8                                         if(d == 0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x31E
; 0000 17E9                                             cykl_testu = 666;
	__GETWRN 16,17,666
; 0000 17EA 
; 0000 17EB                                         if(d == 2 & ff[2] == 0)
_0x31E:
	MOVW R26,R18
	CALL SUBOPT_0xF4
	MOV  R0,R30
	CALL SUBOPT_0x10
	BREQ _0x31F
; 0000 17EC                                             {
; 0000 17ED                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 17EE                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 17EF                                             }
; 0000 17F0                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
_0x31F:
	CALL SUBOPT_0x11C
	AND  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0xEA
	BREQ _0x320
; 0000 17F1                                             {
; 0000 17F2                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 17F3                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 17F4                                             }
; 0000 17F5                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
_0x320:
	MOVW R26,R18
	CALL SUBOPT_0xD1
	MOV  R0,R30
	CALL SUBOPT_0xCE
	AND  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0xEA
	BREQ _0x321
; 0000 17F6                                             {
; 0000 17F7                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 17F8                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 17F9                                             }
; 0000 17FA                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
_0x321:
	CALL SUBOPT_0x11D
	AND  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0xEA
	BREQ _0x322
; 0000 17FB                                             {
; 0000 17FC                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 17FD                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 17FE                                             }
; 0000 17FF                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
_0x322:
	CALL SUBOPT_0x11E
	AND  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0xEA
	BREQ _0x323
; 0000 1800                                             {
; 0000 1801                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 1802                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1803                                             }
; 0000 1804                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
_0x323:
	CALL SUBOPT_0x11F
	AND  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0xEA
	BREQ _0x324
; 0000 1805                                             {
; 0000 1806                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 1807                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1808                                             }
; 0000 1809                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
_0x324:
	CALL SUBOPT_0x120
	AND  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0xEA
	BREQ _0x325
; 0000 180A                                             {
; 0000 180B                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 180C                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 180D                                             }
; 0000 180E                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
_0x325:
	CALL SUBOPT_0x121
	AND  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CALL SUBOPT_0xEA
	BREQ _0x326
; 0000 180F                                             {
; 0000 1810                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 1811                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1812                                             }
; 0000 1813                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
_0x326:
	CALL SUBOPT_0x122
	AND  R0,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL SUBOPT_0xEA
	BREQ _0x327
; 0000 1814                                             {
; 0000 1815                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 1816                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 1817                                             }
; 0000 1818                                     }
_0x327:
; 0000 1819 
; 0000 181A             break;
_0x31D:
	RJMP _0x30A
; 0000 181B 
; 0000 181C             case 6:
_0x31C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x328
; 0000 181D                                      if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x329
; 0000 181E                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10D
; 0000 181F                                         if(cykl_sterownik_3 == 5)
_0x329:
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRNE _0x32A
; 0000 1820                                             {
; 0000 1821                                             cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1822                                             cykl_sterownik_2 = 0;
; 0000 1823                                             cykl_sterownik_3 = 0;
; 0000 1824                                             cykl_sterownik_4 = 0;
; 0000 1825                                             cykl_testu = 7;
	__GETWRN 16,17,7
; 0000 1826                                             }
; 0000 1827 
; 0000 1828             break;
_0x32A:
	RJMP _0x30A
; 0000 1829 
; 0000 182A             case 7:
_0x328:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x32B
; 0000 182B 
; 0000 182C                                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x32C
; 0000 182D                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
	CALL SUBOPT_0x123
; 0000 182E 
; 0000 182F                                     if(cykl_sterownik_1 == 5)
_0x32C:
	CALL SUBOPT_0x112
	SBIW R26,5
	BRNE _0x32D
; 0000 1830                                         {
; 0000 1831                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1832                                         cykl_sterownik_2 = 0;
; 0000 1833                                         cykl_sterownik_3 = 0;
; 0000 1834                                         cykl_sterownik_4 = 0;
; 0000 1835                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 1836                                         }
; 0000 1837 
; 0000 1838 
; 0000 1839             break;
_0x32D:
	RJMP _0x30A
; 0000 183A 
; 0000 183B 
; 0000 183C 
; 0000 183D 
; 0000 183E 
; 0000 183F 
; 0000 1840 
; 0000 1841             case 666:
_0x32B:
	CPI  R30,LOW(0x29A)
	LDI  R26,HIGH(0x29A)
	CPC  R31,R26
	BRNE _0x30A
; 0000 1842 
; 0000 1843                                         if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x32F
; 0000 1844                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10D
; 0000 1845                                         if(cykl_sterownik_3 == 5)
_0x32F:
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRNE _0x330
; 0000 1846                                             {
; 0000 1847                                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0x111
; 0000 1848                                             cykl_sterownik_4 = 0;
; 0000 1849                                             cykl_testu = 100;
	__GETWRN 16,17,100
; 0000 184A                                             test_geometryczny_rzad_1 = 0;
	LDI  R30,LOW(0)
	STS  _test_geometryczny_rzad_1,R30
	STS  _test_geometryczny_rzad_1+1,R30
; 0000 184B                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 184C                                             }
; 0000 184D 
; 0000 184E             break;
_0x330:
; 0000 184F 
; 0000 1850 
; 0000 1851 
; 0000 1852             }
_0x30A:
; 0000 1853 
; 0000 1854         }
	RJMP _0x305
_0x307:
; 0000 1855     }
; 0000 1856 
; 0000 1857 
; 0000 1858 
; 0000 1859                                                                    //swiatlo czer       //swiatlo zolte & PORT_F.bits.b6 == 0
; 0000 185A if(test_geometryczny_rzad_1 == 0 & test_geometryczny_rzad_2 == 1 & PORTD.7 == 0  &
_0x304:
; 0000 185B     il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0 & sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x105
	CALL SUBOPT_0x82
	CALL SUBOPT_0x106
	CALL SUBOPT_0x84
	AND  R0,R30
	CALL SUBOPT_0x108
	CALL SUBOPT_0x124
	CALL SUBOPT_0x125
	CALL SUBOPT_0x126
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
	JMP _0x333
; 0000 185C     {
; 0000 185D     while(test_geometryczny_rzad_2 == 1)
_0x334:
	CALL SUBOPT_0x106
	SBIW R26,1
	BREQ PC+3
	JMP _0x336
; 0000 185E         {
; 0000 185F         switch(cykl_testu)
	MOVW R30,R16
; 0000 1860             {
; 0000 1861              case 0:
	SBIW R30,0
	BRNE _0x33A
; 0000 1862 
; 0000 1863                wybor_linijek_sterownikow(2);
	CALL SUBOPT_0x127
	CALL SUBOPT_0x10B
; 0000 1864                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1865                cykl_sterownik_1 = 0;
; 0000 1866                cykl_sterownik_2 = 0;
; 0000 1867                cykl_sterownik_3 = 0;
; 0000 1868                cykl_sterownik_4 = 0;
; 0000 1869                wybor_linijek_sterownikow(2);
	CALL SUBOPT_0x127
	CALL _wybor_linijek_sterownikow
; 0000 186A                cykl_testu = 1;
	__GETWRN 16,17,1
; 0000 186B 
; 0000 186C 
; 0000 186D 
; 0000 186E             break;
	RJMP _0x339
; 0000 186F 
; 0000 1870             case 1:
_0x33A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x33D
; 0000 1871 
; 0000 1872             //na sam dol zjezdzamy pionami
; 0000 1873                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x33E
; 0000 1874                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10D
; 0000 1875                 if(cykl_sterownik_4 < 5)
_0x33E:
	CALL SUBOPT_0x10E
	SBIW R26,5
	BRGE _0x33F
; 0000 1876                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 1877 
; 0000 1878                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x33F:
	CALL SUBOPT_0x110
	BREQ _0x340
; 0000 1879                                         {
; 0000 187A                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x111
; 0000 187B                                         cykl_sterownik_4 = 0;
; 0000 187C                                         cykl_testu = 2;
	__GETWRN 16,17,2
; 0000 187D                                         }
; 0000 187E 
; 0000 187F 
; 0000 1880 
; 0000 1881             break;
_0x340:
	RJMP _0x339
; 0000 1882 
; 0000 1883 
; 0000 1884             case 2:
_0x33D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x341
; 0000 1885 
; 0000 1886                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x342
; 0000 1887                                     cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x113
; 0000 1888                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy rzad 2
_0x342:
	CALL SUBOPT_0x114
	SBIW R26,5
	BRGE _0x343
; 0000 1889                                     cykl_sterownik_2 = sterownik_2_praca(0x009);       //ster 2 ucieczka dla II rzedu (druciak)
	CALL SUBOPT_0x128
	CALL SUBOPT_0x116
; 0000 188A 
; 0000 188B                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x343:
	CALL SUBOPT_0x117
	BREQ _0x344
; 0000 188C                                         {
; 0000 188D                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 188E                                         cykl_sterownik_2 = 0;
; 0000 188F                                         cykl_sterownik_3 = 0;
; 0000 1890                                         cykl_sterownik_4 = 0;
; 0000 1891                                         cykl_testu = 3;
	__GETWRN 16,17,3
; 0000 1892 
; 0000 1893                                         }
; 0000 1894 
; 0000 1895             break;
_0x344:
	RJMP _0x339
; 0000 1896 
; 0000 1897 
; 0000 1898             case 3:
_0x341:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x345
; 0000 1899 
; 0000 189A                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x346
; 0000 189B                                     cykl_sterownik_1 = sterownik_1_praca(a[1]); //ster 1 pod srodek zacisku
	CALL SUBOPT_0x129
	CALL SUBOPT_0x113
; 0000 189C 
; 0000 189D                                     if(cykl_sterownik_1 == 5)
_0x346:
	CALL SUBOPT_0x112
	SBIW R26,5
	BRNE _0x347
; 0000 189E                                         {
; 0000 189F                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 18A0                                         cykl_sterownik_2 = 0;
; 0000 18A1                                         cykl_sterownik_3 = 0;
; 0000 18A2                                         cykl_sterownik_4 = 0;
; 0000 18A3                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 18A4                                         }
; 0000 18A5 
; 0000 18A6             break;
_0x347:
	RJMP _0x339
; 0000 18A7 
; 0000 18A8             case 4:
_0x345:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x348
; 0000 18A9 
; 0000 18AA                                    if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x349
; 0000 18AB                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x11A
; 0000 18AC 
; 0000 18AD                                    if(cykl_sterownik_3 == 5)
_0x349:
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRNE _0x34A
; 0000 18AE                                         {
; 0000 18AF                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 18B0                                         cykl_sterownik_2 = 0;
; 0000 18B1                                         cykl_sterownik_3 = 0;
; 0000 18B2                                         cykl_sterownik_4 = 0;
; 0000 18B3                                         cykl_testu = 5;
	__GETWRN 16,17,5
; 0000 18B4                                         }
; 0000 18B5 
; 0000 18B6             break;
_0x34A:
	RJMP _0x339
; 0000 18B7 
; 0000 18B8             case 5:
_0x348:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x34B
; 0000 18B9                                      if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BRNE PC+3
	JMP _0x34C
; 0000 18BA                                      {
; 0000 18BB                                      d = odczytaj_parametr(48,96);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x23
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 18BC                                         if(d == 0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x34D
; 0000 18BD                                             cykl_testu = 666;
	__GETWRN 16,17,666
; 0000 18BE 
; 0000 18BF 
; 0000 18C0 
; 0000 18C1 
; 0000 18C2                                         if(d == 2 & ff[2] == 0)
_0x34D:
	MOVW R26,R18
	CALL SUBOPT_0xF4
	MOV  R0,R30
	CALL SUBOPT_0x10
	BREQ _0x34E
; 0000 18C3                                             {
; 0000 18C4                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 18C5                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 18C6                                             }
; 0000 18C7                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
_0x34E:
	CALL SUBOPT_0x11C
	AND  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0xEA
	BREQ _0x34F
; 0000 18C8                                             {
; 0000 18C9                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 18CA                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 18CB                                             }
; 0000 18CC                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
_0x34F:
	MOVW R26,R18
	CALL SUBOPT_0xD1
	MOV  R0,R30
	CALL SUBOPT_0xCE
	AND  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0xEA
	BREQ _0x350
; 0000 18CD                                             {
; 0000 18CE                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 18CF                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 18D0                                             }
; 0000 18D1                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
_0x350:
	CALL SUBOPT_0x11D
	AND  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0xEA
	BREQ _0x351
; 0000 18D2                                             {
; 0000 18D3                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 18D4                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 18D5                                             }
; 0000 18D6                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
_0x351:
	CALL SUBOPT_0x11E
	AND  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0xEA
	BREQ _0x352
; 0000 18D7                                             {
; 0000 18D8                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 18D9                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 18DA                                             }
; 0000 18DB                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
_0x352:
	CALL SUBOPT_0x11F
	AND  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0xEA
	BREQ _0x353
; 0000 18DC                                             {
; 0000 18DD                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 18DE                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 18DF                                             }
; 0000 18E0                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
_0x353:
	CALL SUBOPT_0x120
	AND  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0xEA
	BREQ _0x354
; 0000 18E1                                             {
; 0000 18E2                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 18E3                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 18E4                                             }
; 0000 18E5                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
_0x354:
	CALL SUBOPT_0x121
	AND  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CALL SUBOPT_0xEA
	BREQ _0x355
; 0000 18E6                                             {
; 0000 18E7                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 18E8                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 18E9                                             }
; 0000 18EA                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
_0x355:
	CALL SUBOPT_0x122
	AND  R0,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL SUBOPT_0xEA
	BREQ _0x356
; 0000 18EB                                             {
; 0000 18EC                                             cykl_testu = 6;
	CALL SUBOPT_0x11B
; 0000 18ED                                             ff[d]=1;
	CALL SUBOPT_0x32
; 0000 18EE                                             }
; 0000 18EF 
; 0000 18F0                                       }
_0x356:
; 0000 18F1             break;
_0x34C:
	RJMP _0x339
; 0000 18F2 
; 0000 18F3             case 6:
_0x34B:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x357
; 0000 18F4                                      if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x358
; 0000 18F5                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10D
; 0000 18F6                                         if(cykl_sterownik_3 == 5)
_0x358:
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRNE _0x359
; 0000 18F7                                             {
; 0000 18F8                                             cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 18F9                                             cykl_sterownik_2 = 0;
; 0000 18FA                                             cykl_sterownik_3 = 0;
; 0000 18FB                                             cykl_sterownik_4 = 0;
; 0000 18FC                                             cykl_testu = 7;
	__GETWRN 16,17,7
; 0000 18FD                                             }
; 0000 18FE 
; 0000 18FF             break;
_0x359:
	RJMP _0x339
; 0000 1900 
; 0000 1901             case 7:
_0x357:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x35A
; 0000 1902 
; 0000 1903                                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x35B
; 0000 1904                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
	CALL SUBOPT_0x123
; 0000 1905 
; 0000 1906                                     if(cykl_sterownik_1 == 5)
_0x35B:
	CALL SUBOPT_0x112
	SBIW R26,5
	BRNE _0x35C
; 0000 1907                                         {
; 0000 1908                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1909                                         cykl_sterownik_2 = 0;
; 0000 190A                                         cykl_sterownik_3 = 0;
; 0000 190B                                         cykl_sterownik_4 = 0;
; 0000 190C                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 190D                                         }
; 0000 190E 
; 0000 190F 
; 0000 1910             break;
_0x35C:
	RJMP _0x339
; 0000 1911 
; 0000 1912 
; 0000 1913 
; 0000 1914             case 666:
_0x35A:
	CPI  R30,LOW(0x29A)
	LDI  R26,HIGH(0x29A)
	CPC  R31,R26
	BRNE _0x339
; 0000 1915 
; 0000 1916                                         if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x35E
; 0000 1917                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10D
; 0000 1918                                         if(cykl_sterownik_3 == 5)
_0x35E:
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRNE _0x35F
; 0000 1919                                             {
; 0000 191A                                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0x111
; 0000 191B                                             cykl_sterownik_4 = 0;
; 0000 191C                                             cykl_testu = 100;
	__GETWRN 16,17,100
; 0000 191D                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 191E                                             test_geometryczny_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _test_geometryczny_rzad_2,R30
	STS  _test_geometryczny_rzad_2+1,R30
; 0000 191F                                             }
; 0000 1920 
; 0000 1921             break;
_0x35F:
; 0000 1922 
; 0000 1923 
; 0000 1924 
; 0000 1925             }
_0x339:
; 0000 1926 
; 0000 1927         }
	RJMP _0x334
_0x336:
; 0000 1928     }
; 0000 1929 
; 0000 192A 
; 0000 192B 
; 0000 192C 
; 0000 192D }
_0x333:
	CALL __LOADLOCR6
	ADIW R28,30
	RET
;
;
;
;
;
;void kontrola_zoltego_swiatla()
; 0000 1934 {
_kontrola_zoltego_swiatla:
; 0000 1935 
; 0000 1936 
; 0000 1937 if(czas_pracy_szczotki_drucianej_h_17 >= czas_pracy_szczotki_drucianej_stala)
	CALL SUBOPT_0x12A
	CP   R26,R12
	CPC  R27,R13
	BRLT _0x362
; 0000 1938      {
; 0000 1939      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x12B
; 0000 193A      PORTF = PORT_F.byte;
; 0000 193B      komunikat_na_panel("                                                ",80,0);
	CALL SUBOPT_0x12C
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 193C      komunikat_na_panel("Wymien szczotke druciana 17-stke",80,0);
	__POINTW1FN _0x0,1994
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xBC
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 193D      }
; 0000 193E 
; 0000 193F if(czas_pracy_szczotki_drucianej_h_15 >= czas_pracy_szczotki_drucianej_stala)
_0x362:
	CALL SUBOPT_0x12D
	CP   R26,R12
	CPC  R27,R13
	BRLT _0x363
; 0000 1940      {
; 0000 1941      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x12B
; 0000 1942      PORTF = PORT_F.byte;
; 0000 1943      komunikat_na_panel("                                                ",80,0);
	CALL SUBOPT_0x12C
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 1944      komunikat_na_panel("Wymien szczotke druciana 15-stke",16,128);
	__POINTW1FN _0x0,2027
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB6
	CALL _komunikat_na_panel
; 0000 1945      }
; 0000 1946 
; 0000 1947 if(czas_pracy_krazka_sciernego_h_34 >= czas_pracy_krazka_sciernego_stala)
_0x363:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0x12E
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x364
; 0000 1948      {
; 0000 1949      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x12B
; 0000 194A      PORTF = PORT_F.byte;
; 0000 194B      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 194C      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 34",64,0);
	__POINTW1FN _0x0,2060
	CALL SUBOPT_0x130
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 194D      }
; 0000 194E 
; 0000 194F if(czas_pracy_krazka_sciernego_h_36 >= czas_pracy_krazka_sciernego_stala)
_0x364:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0x131
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x365
; 0000 1950      {
; 0000 1951      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x12B
; 0000 1952      PORTF = PORT_F.byte;
; 0000 1953      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 1954      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 36",64,0);
	__POINTW1FN _0x0,2107
	CALL SUBOPT_0x130
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 1955      }
; 0000 1956 
; 0000 1957 if(czas_pracy_krazka_sciernego_h_38 >= czas_pracy_krazka_sciernego_stala)
_0x365:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0x132
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x366
; 0000 1958      {
; 0000 1959      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x12B
; 0000 195A      PORTF = PORT_F.byte;
; 0000 195B      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 195C      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 38",64,0);
	__POINTW1FN _0x0,2154
	CALL SUBOPT_0x130
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 195D      }
; 0000 195E 
; 0000 195F if(czas_pracy_krazka_sciernego_h_41 >= czas_pracy_krazka_sciernego_stala)
_0x366:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0x133
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x367
; 0000 1960      {
; 0000 1961      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x12B
; 0000 1962      PORTF = PORT_F.byte;
; 0000 1963      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 1964      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 41",64,0);
	__POINTW1FN _0x0,2201
	CALL SUBOPT_0x130
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 1965      }
; 0000 1966 
; 0000 1967 if(czas_pracy_krazka_sciernego_h_43 >= czas_pracy_krazka_sciernego_stala)
_0x367:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0x134
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x368
; 0000 1968      {
; 0000 1969      PORT_F.bits.b6 = 1;
	CALL SUBOPT_0x12B
; 0000 196A      PORTF = PORT_F.byte;
; 0000 196B      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 196C      komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 43",64,0);
	__POINTW1FN _0x0,2248
	CALL SUBOPT_0x130
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 196D      }
; 0000 196E 
; 0000 196F 
; 0000 1970 
; 0000 1971 }
_0x368:
	RET
;
;void wymiana_szczotki_i_krazka()
; 0000 1974 {
_wymiana_szczotki_i_krazka:
; 0000 1975 int g,e,f,d,cykl_wymiany;
; 0000 1976 cykl_wymiany = 0;
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
; 0000 1977                       //30 //20
; 0000 1978 
; 0000 1979 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x369
; 0000 197A {
; 0000 197B g = odczytaj_parametr(48,32);  //szczotka druciana
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x30
	CALL _odczytaj_parametr
	MOVW R16,R30
; 0000 197C                     //30  //30
; 0000 197D f = odczytaj_parametr(48,48);  //krazek scierny
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1A
	CALL _odczytaj_parametr
	MOVW R20,R30
; 0000 197E }
; 0000 197F 
; 0000 1980 while(g == 1)
_0x369:
_0x36A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+3
	JMP _0x36C
; 0000 1981     {
; 0000 1982     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 1983     {
; 0000 1984     case 0:
	SBIW R30,0
	BRNE _0x370
; 0000 1985 
; 0000 1986                cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1987                cykl_sterownik_2 = 0;
; 0000 1988                cykl_sterownik_3 = 0;
; 0000 1989                cykl_sterownik_4 = 0;
; 0000 198A                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 198B                cykl_wymiany = 1;
	CALL SUBOPT_0xD0
; 0000 198C 
; 0000 198D 
; 0000 198E 
; 0000 198F     break;
	RJMP _0x36F
; 0000 1990 
; 0000 1991     case 1:
_0x370:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x373
; 0000 1992 
; 0000 1993             //na sam dol zjezdzamy pionami
; 0000 1994                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x374
; 0000 1995                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10D
; 0000 1996                 if(cykl_sterownik_4 < 5)
_0x374:
	CALL SUBOPT_0x10E
	SBIW R26,5
	BRGE _0x375
; 0000 1997                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 1998 
; 0000 1999                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x375:
	CALL SUBOPT_0x110
	BREQ _0x376
; 0000 199A 
; 0000 199B                             {
; 0000 199C                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x111
; 0000 199D                                         cykl_sterownik_4 = 0;
; 0000 199E                                         cykl_wymiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 199F                                         }
; 0000 19A0 
; 0000 19A1 
; 0000 19A2 
; 0000 19A3     break;
_0x376:
	RJMP _0x36F
; 0000 19A4 
; 0000 19A5 
; 0000 19A6 
; 0000 19A7     case 2:
_0x373:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x377
; 0000 19A8 
; 0000 19A9                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x378
; 0000 19AA                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0x135
	CALL SUBOPT_0x113
; 0000 19AB                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x378:
	CALL SUBOPT_0x114
	SBIW R26,5
	BRGE _0x379
; 0000 19AC                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x135
	CALL SUBOPT_0x116
; 0000 19AD 
; 0000 19AE                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x379:
	CALL SUBOPT_0x117
	BREQ _0x37A
; 0000 19AF                                         {
; 0000 19B0                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 19B1                                         cykl_sterownik_2 = 0;
; 0000 19B2                                         cykl_sterownik_3 = 0;
; 0000 19B3                                         cykl_sterownik_4 = 0;
; 0000 19B4                                          cykl_wymiany = 3;
	CALL SUBOPT_0x136
; 0000 19B5 
; 0000 19B6                                         }
; 0000 19B7 
; 0000 19B8     break;
_0x37A:
	RJMP _0x36F
; 0000 19B9 
; 0000 19BA 
; 0000 19BB 
; 0000 19BC     case 3:
_0x377:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x37B
; 0000 19BD 
; 0000 19BE             //na sam dol zjezdzamy pionami
; 0000 19BF                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x37C
; 0000 19C0                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x11A
; 0000 19C1                 if(cykl_sterownik_4 < 5)
_0x37C:
	CALL SUBOPT_0x10E
	SBIW R26,5
	BRGE _0x37D
; 0000 19C2                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
	CALL SUBOPT_0x127
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 19C3 
; 0000 19C4                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x37D:
	CALL SUBOPT_0x110
	BRNE PC+3
	JMP _0x37E
; 0000 19C5 
; 0000 19C6                             {
; 0000 19C7                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x111
; 0000 19C8                                         cykl_sterownik_4 = 0;
; 0000 19C9                                         d = odczytaj_parametr(48,32);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x30
	CALL _odczytaj_parametr
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 19CA 
; 0000 19CB                                         switch (d)
; 0000 19CC                                         {
; 0000 19CD                                         case 0:
	SBIW R30,0
	BRNE _0x382
; 0000 19CE 
; 0000 19CF                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x383
; 0000 19D0                                                 {
; 0000 19D1                                                 cykl_wymiany = 4;
	CALL SUBOPT_0x137
; 0000 19D2                                                 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 19D3                                                 }
; 0000 19D4                                              //jednak nie wymianiamy
; 0000 19D5 
; 0000 19D6                                         break;
_0x383:
	RJMP _0x381
; 0000 19D7 
; 0000 19D8                                         case 1:
_0x382:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x386
; 0000 19D9                                              cykl_wymiany = 3;
	CALL SUBOPT_0x136
; 0000 19DA                                              PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 19DB                                              //czekam z decyzja - w trakcie wymiany
; 0000 19DC                                         break;
	RJMP _0x381
; 0000 19DD 
; 0000 19DE                                         case 2:
_0x386:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x381
; 0000 19DF 
; 0000 19E0 
; 0000 19E1 
; 0000 19E2                                              PORT_F.bits.b6 = 0;   //zgas lampke
	LDS  R30,_PORT_F
	ANDI R30,0xBF
	CALL SUBOPT_0xFE
; 0000 19E3                                              PORTF = PORT_F.byte;
; 0000 19E4 
; 0000 19E5                                              if(srednica_wew_korpusu == 34 | srednica_wew_korpusu == 36)
	CALL SUBOPT_0x138
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x138
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x38A
; 0000 19E6                                              {
; 0000 19E7                                              czas_pracy_szczotki_drucianej_h_15 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_szczotki_drucianej_h_15,R30
	STS  _czas_pracy_szczotki_drucianej_h_15+1,R30
; 0000 19E8                                              wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_15,16,128);
	CALL SUBOPT_0xB5
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xB7
; 0000 19E9                                              wartosc_parametru_panelu_stala_pamiec(16,32,16,128);
	CALL SUBOPT_0x30
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xB8
; 0000 19EA                                              delay_ms(200);
; 0000 19EB                                              odczyt_parametru_panelu_stala_pamiec(16,32,16,128);
	CALL SUBOPT_0x30
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xA6
; 0000 19EC                                              delay_ms(200);
; 0000 19ED                                              }
; 0000 19EE 
; 0000 19EF                                              if(srednica_wew_korpusu == 38 | srednica_wew_korpusu == 41 | srednica_wew_korpusu == 43)
_0x38A:
	CALL SUBOPT_0x138
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x138
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	CALL __EQW12
	OR   R0,R30
	CALL SUBOPT_0x138
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x38B
; 0000 19F0                                              {
; 0000 19F1                                              czas_pracy_szczotki_drucianej_h_17 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_szczotki_drucianej_h_17,R30
	STS  _czas_pracy_szczotki_drucianej_h_17+1,R30
; 0000 19F2                                              wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_17,0,144);
	CALL SUBOPT_0xB1
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA8
; 0000 19F3                                              wartosc_parametru_panelu_stala_pamiec(0,96,0,144);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA5
; 0000 19F4                                              delay_ms(200);
; 0000 19F5                                              odczyt_parametru_panelu_stala_pamiec(0,96,0,144);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA6
; 0000 19F6                                              delay_ms(200);
; 0000 19F7                                              }
; 0000 19F8 
; 0000 19F9                                              komunikat_na_panel("                                                ",80,0);
_0x38B:
	CALL SUBOPT_0x12C
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 19FA 
; 0000 19FB                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x38C
; 0000 19FC                                                 {
; 0000 19FD                                                 cykl_wymiany = 4;
	CALL SUBOPT_0x137
; 0000 19FE                                                 PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 19FF                                                 }
; 0000 1A00                                              //wymianymy
; 0000 1A01                                         break;
_0x38C:
; 0000 1A02                                         }
_0x381:
; 0000 1A03                             }
; 0000 1A04 
; 0000 1A05 
; 0000 1A06 
; 0000 1A07 
; 0000 1A08 
; 0000 1A09 
; 0000 1A0A     break;
_0x37E:
	RJMP _0x36F
; 0000 1A0B 
; 0000 1A0C    case 4:
_0x37B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x36F
; 0000 1A0D 
; 0000 1A0E                       //na sam dol zjezdzamy pionami
; 0000 1A0F                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x390
; 0000 1A10                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10D
; 0000 1A11                 if(cykl_sterownik_4 < 5)
_0x390:
	CALL SUBOPT_0x10E
	SBIW R26,5
	BRGE _0x391
; 0000 1A12                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 1A13 
; 0000 1A14                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x391:
	CALL SUBOPT_0x110
	BREQ _0x392
; 0000 1A15                                         {
; 0000 1A16                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1A17                                         cykl_sterownik_2 = 0;
; 0000 1A18                                         cykl_sterownik_3 = 0;
; 0000 1A19                                         cykl_sterownik_4 = 0;
; 0000 1A1A                                         wartosc_parametru_panelu(0,48,32);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x30
	CALL _wartosc_parametru_panelu
; 0000 1A1B                                         PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 1A1C                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1A1D                                         g = 0;
	__GETWRN 16,17,0
; 0000 1A1E                                         }
; 0000 1A1F 
; 0000 1A20    break;
_0x392:
; 0000 1A21 
; 0000 1A22 
; 0000 1A23     }//switch
_0x36F:
; 0000 1A24 
; 0000 1A25    }//while
	RJMP _0x36A
_0x36C:
; 0000 1A26 
; 0000 1A27 
; 0000 1A28 while(f == 1)
_0x395:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ PC+3
	JMP _0x397
; 0000 1A29     {
; 0000 1A2A     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 1A2B     {
; 0000 1A2C     case 0:
	SBIW R30,0
	BRNE _0x39B
; 0000 1A2D 
; 0000 1A2E                cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1A2F                cykl_sterownik_2 = 0;
; 0000 1A30                cykl_sterownik_3 = 0;
; 0000 1A31                cykl_sterownik_4 = 0;
; 0000 1A32                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 1A33                cykl_wymiany = 1;
	CALL SUBOPT_0xD0
; 0000 1A34 
; 0000 1A35 
; 0000 1A36 
; 0000 1A37     break;
	RJMP _0x39A
; 0000 1A38 
; 0000 1A39     case 1:
_0x39B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x39E
; 0000 1A3A 
; 0000 1A3B             //na sam dol zjezdzamy pionami
; 0000 1A3C                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x39F
; 0000 1A3D                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10D
; 0000 1A3E                 if(cykl_sterownik_4 < 5)
_0x39F:
	CALL SUBOPT_0x10E
	SBIW R26,5
	BRGE _0x3A0
; 0000 1A3F                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 1A40 
; 0000 1A41                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x3A0:
	CALL SUBOPT_0x110
	BREQ _0x3A1
; 0000 1A42 
; 0000 1A43                             {
; 0000 1A44                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x111
; 0000 1A45                                         cykl_sterownik_4 = 0;
; 0000 1A46                                         cykl_wymiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1A47                                         }
; 0000 1A48 
; 0000 1A49 
; 0000 1A4A 
; 0000 1A4B     break;
_0x3A1:
	RJMP _0x39A
; 0000 1A4C 
; 0000 1A4D 
; 0000 1A4E 
; 0000 1A4F     case 2:
_0x39E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3A2
; 0000 1A50 
; 0000 1A51                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x3A3
; 0000 1A52                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0x135
	CALL SUBOPT_0x113
; 0000 1A53                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x3A3:
	CALL SUBOPT_0x114
	SBIW R26,5
	BRGE _0x3A4
; 0000 1A54                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x135
	CALL SUBOPT_0x116
; 0000 1A55 
; 0000 1A56                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x3A4:
	CALL SUBOPT_0x117
	BREQ _0x3A5
; 0000 1A57                                         {
; 0000 1A58                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1A59                                         cykl_sterownik_2 = 0;
; 0000 1A5A                                         cykl_sterownik_3 = 0;
; 0000 1A5B                                         cykl_sterownik_4 = 0;
; 0000 1A5C                                          cykl_wymiany = 3;
	CALL SUBOPT_0x136
; 0000 1A5D 
; 0000 1A5E                                         }
; 0000 1A5F 
; 0000 1A60     break;
_0x3A5:
	RJMP _0x39A
; 0000 1A61 
; 0000 1A62 
; 0000 1A63 
; 0000 1A64     case 3:
_0x3A2:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3A6
; 0000 1A65 
; 0000 1A66             //na sam dol zjezdzamy pionami
; 0000 1A67                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x3A7
; 0000 1A68                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x11A
; 0000 1A69                 if(cykl_sterownik_4 < 5)
_0x3A7:
	CALL SUBOPT_0x10E
	SBIW R26,5
	BRGE _0x3A8
; 0000 1A6A                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
	CALL SUBOPT_0x127
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 1A6B 
; 0000 1A6C                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x3A8:
	CALL SUBOPT_0x110
	BRNE PC+3
	JMP _0x3A9
; 0000 1A6D 
; 0000 1A6E                             {
; 0000 1A6F                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x111
; 0000 1A70                                         cykl_sterownik_4 = 0;
; 0000 1A71                                         e = odczytaj_parametr(48,48);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1A
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 1A72 
; 0000 1A73                                         switch (e)
	MOVW R30,R18
; 0000 1A74                                         {
; 0000 1A75                                         case 0:
	SBIW R30,0
	BRNE _0x3AD
; 0000 1A76 
; 0000 1A77                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x3AE
; 0000 1A78                                              {
; 0000 1A79                                              cykl_wymiany = 4;
	CALL SUBOPT_0x137
; 0000 1A7A                                              PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1A7B                                              }
; 0000 1A7C                                              //jednak nie wymianiamy
; 0000 1A7D 
; 0000 1A7E                                         break;
_0x3AE:
	RJMP _0x3AC
; 0000 1A7F 
; 0000 1A80                                         case 1:
_0x3AD:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3B1
; 0000 1A81                                              PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 1A82                                              cykl_wymiany = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x588
; 0000 1A83                                              //czekam z decyzja - w trakcie wymiany
; 0000 1A84                                         break;
; 0000 1A85 
; 0000 1A86                                         case 2:
_0x3B1:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3AC
; 0000 1A87 
; 0000 1A88 
; 0000 1A89 
; 0000 1A8A                                              PORT_F.bits.b6 = 0;   //zgas lampke
	LDS  R30,_PORT_F
	ANDI R30,0xBF
	CALL SUBOPT_0xFE
; 0000 1A8B                                              PORTF = PORT_F.byte;
; 0000 1A8C 
; 0000 1A8D                                              if(srednica_wew_korpusu == 34)
	CALL SUBOPT_0x138
	SBIW R26,34
	BRNE _0x3B5
; 0000 1A8E                                              {
; 0000 1A8F                                              czas_pracy_krazka_sciernego_h_34 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego_h_34,R30
	STS  _czas_pracy_krazka_sciernego_h_34+1,R30
; 0000 1A90                                              wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
	CALL SUBOPT_0xB9
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xA8
; 0000 1A91                                              wartosc_parametru_panelu_stala_pamiec(0,112,96,48);
	CALL SUBOPT_0xA9
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xA5
; 0000 1A92                                              delay_ms(200);
; 0000 1A93                                              odczyt_parametru_panelu_stala_pamiec(0,112,96,48);
	CALL SUBOPT_0xA9
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xA6
; 0000 1A94                                              delay_ms(200);
; 0000 1A95                                              }
; 0000 1A96 
; 0000 1A97                                              if(srednica_wew_korpusu == 36)
_0x3B5:
	CALL SUBOPT_0x138
	SBIW R26,36
	BRNE _0x3B6
; 0000 1A98                                              {
; 0000 1A99                                              czas_pracy_krazka_sciernego_h_36 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego_h_36,R30
	STS  _czas_pracy_krazka_sciernego_h_36+1,R30
; 0000 1A9A                                              wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA8
; 0000 1A9B                                              wartosc_parametru_panelu_stala_pamiec(0,128,96,64);
	CALL SUBOPT_0xB6
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA5
; 0000 1A9C                                              delay_ms(200);
; 0000 1A9D                                              odczyt_parametru_panelu_stala_pamiec(0,128,96,64);
	CALL SUBOPT_0xB6
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA6
; 0000 1A9E                                              delay_ms(200);
; 0000 1A9F                                              }
; 0000 1AA0 
; 0000 1AA1                                              if(srednica_wew_korpusu == 38)
_0x3B6:
	CALL SUBOPT_0x138
	SBIW R26,38
	BRNE _0x3B7
; 0000 1AA2                                              {
; 0000 1AA3                                              czas_pracy_krazka_sciernego_h_38 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego_h_38,R30
	STS  _czas_pracy_krazka_sciernego_h_38+1,R30
; 0000 1AA4                                              wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
	CALL SUBOPT_0xBB
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xA8
; 0000 1AA5                                              wartosc_parametru_panelu_stala_pamiec(0,144,96,80);
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x23
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xA5
; 0000 1AA6                                              delay_ms(200);
; 0000 1AA7                                              odczyt_parametru_panelu_stala_pamiec(0,144,96,80);
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x23
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xA6
; 0000 1AA8                                              delay_ms(200);
; 0000 1AA9                                              }
; 0000 1AAA 
; 0000 1AAB                                             if(srednica_wew_korpusu == 41)
_0x3B7:
	CALL SUBOPT_0x138
	SBIW R26,41
	BRNE _0x3B8
; 0000 1AAC                                             {
; 0000 1AAD                                             czas_pracy_krazka_sciernego_h_41 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego_h_41,R30
	STS  _czas_pracy_krazka_sciernego_h_41+1,R30
; 0000 1AAE                                             wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
	CALL SUBOPT_0xBD
	CALL SUBOPT_0x23
	CALL SUBOPT_0xB7
; 0000 1AAF                                             wartosc_parametru_panelu_stala_pamiec(16,0,96,96);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0xB8
; 0000 1AB0                                             delay_ms(200);
; 0000 1AB1                                             odczyt_parametru_panelu_stala_pamiec(16,0,96,96);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA6
; 0000 1AB2                                             delay_ms(200);
; 0000 1AB3                                             }
; 0000 1AB4 
; 0000 1AB5                                             if(srednica_wew_korpusu == 43)
_0x3B8:
	CALL SUBOPT_0x138
	SBIW R26,43
	BRNE _0x3B9
; 0000 1AB6                                             {
; 0000 1AB7                                             czas_pracy_krazka_sciernego_h_43 = 0;
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego_h_43,R30
	STS  _czas_pracy_krazka_sciernego_h_43+1,R30
; 0000 1AB8                                             wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
	CALL SUBOPT_0xBE
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xB7
; 0000 1AB9                                             wartosc_parametru_panelu_stala_pamiec(16,16,96,112);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xB8
; 0000 1ABA                                             delay_ms(200);
; 0000 1ABB                                             odczyt_parametru_panelu_stala_pamiec(16,16,96,112);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA9
	CALL SUBOPT_0xA6
; 0000 1ABC                                             delay_ms(200);
; 0000 1ABD                                             }
; 0000 1ABE 
; 0000 1ABF 
; 0000 1AC0                                              komunikat_na_panel("                                                ",64,0);
_0x3B9:
	CALL SUBOPT_0x12F
	CALL SUBOPT_0x9
	CALL _komunikat_na_panel
; 0000 1AC1                                              if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	POP  R26
	AND  R30,R26
	BREQ _0x3BA
; 0000 1AC2                                                      {
; 0000 1AC3                                                      PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
	SBI  0x18,6
; 0000 1AC4                                                      cykl_wymiany = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
_0x588:
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1AC5                                                      }
; 0000 1AC6                                              //wymianymy
; 0000 1AC7                                         break;
_0x3BA:
; 0000 1AC8                                         }
_0x3AC:
; 0000 1AC9                             }
; 0000 1ACA 
; 0000 1ACB 
; 0000 1ACC 
; 0000 1ACD 
; 0000 1ACE 
; 0000 1ACF 
; 0000 1AD0     break;
_0x3A9:
	RJMP _0x39A
; 0000 1AD1 
; 0000 1AD2    case 4:
_0x3A6:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x39A
; 0000 1AD3 
; 0000 1AD4                       //na sam dol zjezdzamy pionami
; 0000 1AD5                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x3BE
; 0000 1AD6                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10D
; 0000 1AD7                 if(cykl_sterownik_4 < 5)
_0x3BE:
	CALL SUBOPT_0x10E
	SBIW R26,5
	BRGE _0x3BF
; 0000 1AD8                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 1AD9 
; 0000 1ADA                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x3BF:
	CALL SUBOPT_0x110
	BREQ _0x3C0
; 0000 1ADB 
; 0000 1ADC                             {
; 0000 1ADD                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1ADE                                         cykl_sterownik_2 = 0;
; 0000 1ADF                                         cykl_sterownik_3 = 0;
; 0000 1AE0                                         cykl_sterownik_4 = 0;
; 0000 1AE1                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1AE2                                         wartosc_parametru_panelu(0,48,48);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1A
	CALL _wartosc_parametru_panelu
; 0000 1AE3                                         PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
	CBI  0x18,6
; 0000 1AE4                                         f = 0;
	__GETWRN 20,21,0
; 0000 1AE5                                         }
; 0000 1AE6 
; 0000 1AE7    break;
_0x3C0:
; 0000 1AE8 
; 0000 1AE9 
; 0000 1AEA     }//switch
_0x39A:
; 0000 1AEB 
; 0000 1AEC    }//while
	RJMP _0x395
_0x397:
; 0000 1AED 
; 0000 1AEE 
; 0000 1AEF 
; 0000 1AF0 
; 0000 1AF1 
; 0000 1AF2 
; 0000 1AF3 
; 0000 1AF4 
; 0000 1AF5 }
	CALL __LOADLOCR6
	ADIW R28,10
	RET
;
;
;void przypadek887()
; 0000 1AF9 {
_przypadek887:
; 0000 1AFA if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x139
	BRGE _0x3C3
; 0000 1AFB                         {
; 0000 1AFC                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x13A
; 0000 1AFD                         PORTF = PORT_F.byte;
; 0000 1AFE                         }
; 0000 1AFF 
; 0000 1B00 
; 0000 1B01                      if(rzad_obrabiany == 2)
_0x3C3:
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x3C4
; 0000 1B02                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1B03 
; 0000 1B04                     if(koniec_rzedu_10 == 1)
_0x3C4:
	CALL SUBOPT_0x13B
	BRNE _0x3C5
; 0000 1B05                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x13C
; 0000 1B06 
; 0000 1B07 
; 0000 1B08                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x3C5:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x13F
	BREQ _0x3C6
; 0000 1B09                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x140
; 0000 1B0A 
; 0000 1B0B                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x3C6:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x141
	BREQ _0x3C7
; 0000 1B0C                         {
; 0000 1B0D                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1B0E                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x143
; 0000 1B0F                         }
; 0000 1B10 
; 0000 1B11 
; 0000 1B12                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3C7:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x144
	AND  R30,R0
	BREQ _0x3C8
; 0000 1B13                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x145
; 0000 1B14 
; 0000 1B15                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3C8:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x146
	AND  R30,R0
	BREQ _0x3C9
; 0000 1B16                         {
; 0000 1B17                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1B18                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x147
; 0000 1B19                         }
; 0000 1B1A 
; 0000 1B1B                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3C9:
	CALL SUBOPT_0x148
	AND  R30,R0
	BREQ _0x3CA
; 0000 1B1C                         {
; 0000 1B1D                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1B1E                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x149
; 0000 1B1F                         }
; 0000 1B20 
; 0000 1B21                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1B22                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x3CA:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x14A
	AND  R30,R0
	BREQ _0x3CB
; 0000 1B23                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x14B
; 0000 1B24 
; 0000 1B25 
; 0000 1B26                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x3CB:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x14C
	AND  R30,R0
	BREQ _0x3CC
; 0000 1B27                         {
; 0000 1B28                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1B29                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x14D
; 0000 1B2A                         }
; 0000 1B2B 
; 0000 1B2C 
; 0000 1B2D 
; 0000 1B2E 
; 0000 1B2F 
; 0000 1B30 
; 0000 1B31 
; 0000 1B32                                                               //to nowy war, ostatni dzien w borg
; 0000 1B33                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3CC:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x107
	CALL SUBOPT_0x150
	CALL SUBOPT_0x107
	CALL SUBOPT_0x151
	BREQ _0x3CD
; 0000 1B34                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x152
	CALL SUBOPT_0x10F
; 0000 1B35 
; 0000 1B36                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3CD:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x153
	CALL SUBOPT_0x154
	BREQ _0x3CE
; 0000 1B37                         {
; 0000 1B38                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x155
	BRNE _0x3CF
; 0000 1B39                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 1B3A                         if(abs_ster4 == 0)
_0x3CF:
	CALL SUBOPT_0x157
	BRNE _0x3D0
; 0000 1B3B                             {
; 0000 1B3C                             szczotka_druc_cykl++;
	CALL SUBOPT_0x158
; 0000 1B3D                             abs_ster4 = 1;
; 0000 1B3E                             }
; 0000 1B3F                         else
	RJMP _0x3D1
_0x3D0:
; 0000 1B40                             {
; 0000 1B41                             abs_ster4 = 0;
	CALL SUBOPT_0x159
; 0000 1B42                             sek13 = 0;
; 0000 1B43                             }
_0x3D1:
; 0000 1B44                         }
; 0000 1B45 
; 0000 1B46                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3CE:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15B
	CALL SUBOPT_0x107
	CALL SUBOPT_0x15C
	BREQ _0x3D2
; 0000 1B47                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x85
	CALL SUBOPT_0x11A
; 0000 1B48 
; 0000 1B49 
; 0000 1B4A                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3D2:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15D
	CALL SUBOPT_0x15E
	BREQ _0x3D3
; 0000 1B4B                         {
; 0000 1B4C                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 1B4D                         if(abs_ster3 == 0)
	CALL SUBOPT_0x160
	BRNE _0x3D4
; 0000 1B4E                             {
; 0000 1B4F                             krazek_scierny_cykl++;
	CALL SUBOPT_0x161
; 0000 1B50                             abs_ster3 = 1;
; 0000 1B51                             }
; 0000 1B52                         else
	RJMP _0x3D5
_0x3D4:
; 0000 1B53                             abs_ster3 = 0;
	CALL SUBOPT_0x162
; 0000 1B54                         }
_0x3D5:
; 0000 1B55 
; 0000 1B56                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3D3:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15B
	CALL SUBOPT_0x84
	AND  R30,R0
	BREQ _0x3D6
; 0000 1B57                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x11A
; 0000 1B58 
; 0000 1B59                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x3D6:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x84
	CALL SUBOPT_0x163
	BREQ _0x3D7
; 0000 1B5A                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory
	CALL SUBOPT_0x164
	CALL SUBOPT_0x10F
; 0000 1B5B 
; 0000 1B5C 
; 0000 1B5D 
; 0000 1B5E                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1B5F 
; 0000 1B60                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonalem_komplet_okregow == 3)
_0x3D7:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15D
	CALL SUBOPT_0x165
	BREQ _0x3D8
; 0000 1B61                        {
; 0000 1B62                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 1B63                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x166
; 0000 1B64                        }
; 0000 1B65                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x3D8:
	CALL SUBOPT_0x167
	MOV  R0,R30
	CALL SUBOPT_0x15A
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3D9
; 0000 1B66                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x10D
; 0000 1B67 
; 0000 1B68                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x3D9:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x168
	AND  R30,R0
	BREQ _0x3DA
; 0000 1B69                        {
; 0000 1B6A                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x169
; 0000 1B6B                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1B6C                        }
; 0000 1B6D                    //////////////////////////////////////////////
; 0000 1B6E 
; 0000 1B6F 
; 0000 1B70 
; 0000 1B71                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1B72 
; 0000 1B73                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x3DA:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x153
	CALL SUBOPT_0x16A
	BREQ _0x3DD
; 0000 1B74                        {
; 0000 1B75                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1B76                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 1B77                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x16B
; 0000 1B78                        }
; 0000 1B79                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x3DD:
	CALL SUBOPT_0x16C
	MOV  R0,R30
	CALL SUBOPT_0x14E
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3E0
; 0000 1B7A                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 1B7B 
; 0000 1B7C                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x3E0:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x16D
	AND  R30,R0
	BREQ _0x3E1
; 0000 1B7D                        {
; 0000 1B7E                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x16E
; 0000 1B7F                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1B80                        }
; 0000 1B81                    //////////////////////////////////////////////
; 0000 1B82 
; 0000 1B83                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x3E1:
; 0000 1B84                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1B85                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1B86                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0 &  wykonalem_komplet_okregow == 3)
	CALL SUBOPT_0x16F
	CALL SUBOPT_0x170
	CALL SUBOPT_0x171
	CALL SUBOPT_0x172
	CALL SUBOPT_0x173
	CALL SUBOPT_0x174
	BREQ _0x3E4
; 0000 1B87                         {
; 0000 1B88                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x169
; 0000 1B89                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x16E
; 0000 1B8A                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1B8B                         cykl_sterownik_2 = 0;
; 0000 1B8C                         cykl_sterownik_3 = 0;
; 0000 1B8D                         cykl_sterownik_4 = 0;
; 0000 1B8E                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x175
; 0000 1B8F                         krazek_scierny_cykl = 0;
; 0000 1B90                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1B91                         wykonalem_komplet_okregow = 0;
; 0000 1B92                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1B93                         //PORTF = PORT_F.byte;
; 0000 1B94                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1B95                         cykl_glowny = 9;
; 0000 1B96                         }
; 0000 1B97 }
_0x3E4:
	RET
;
;
;
;void przypadek888()
; 0000 1B9C {
_przypadek888:
; 0000 1B9D 
; 0000 1B9E                  if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x139
	BRGE _0x3E7
; 0000 1B9F                         {
; 0000 1BA0                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x13A
; 0000 1BA1                         PORTF = PORT_F.byte;
; 0000 1BA2                         }
; 0000 1BA3 
; 0000 1BA4 
; 0000 1BA5                      if(rzad_obrabiany == 2)
_0x3E7:
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x3E8
; 0000 1BA6                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1BA7 
; 0000 1BA8                     if(koniec_rzedu_10 == 1)
_0x3E8:
	CALL SUBOPT_0x13B
	BRNE _0x3E9
; 0000 1BA9                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x13C
; 0000 1BAA 
; 0000 1BAB 
; 0000 1BAC                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x3E9:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x13F
	BREQ _0x3EA
; 0000 1BAD                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x140
; 0000 1BAE 
; 0000 1BAF                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x3EA:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x141
	BREQ _0x3EB
; 0000 1BB0                         {
; 0000 1BB1                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1BB2                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x143
; 0000 1BB3                         }
; 0000 1BB4 
; 0000 1BB5 
; 0000 1BB6                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3EB:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x144
	AND  R30,R0
	BREQ _0x3EC
; 0000 1BB7                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x145
; 0000 1BB8 
; 0000 1BB9                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3EC:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x146
	AND  R30,R0
	BREQ _0x3ED
; 0000 1BBA                         {
; 0000 1BBB                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1BBC                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x147
; 0000 1BBD                         }
; 0000 1BBE 
; 0000 1BBF                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x3ED:
	CALL SUBOPT_0x148
	AND  R30,R0
	BREQ _0x3EE
; 0000 1BC0                         {
; 0000 1BC1                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1BC2                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x149
; 0000 1BC3                         }
; 0000 1BC4 
; 0000 1BC5                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1BC6                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x3EE:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x14A
	AND  R30,R0
	BREQ _0x3EF
; 0000 1BC7                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x14B
; 0000 1BC8 
; 0000 1BC9 
; 0000 1BCA                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x3EF:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x14C
	AND  R30,R0
	BREQ _0x3F0
; 0000 1BCB                         {
; 0000 1BCC                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1BCD                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x14D
; 0000 1BCE                         }
; 0000 1BCF 
; 0000 1BD0 
; 0000 1BD1 
; 0000 1BD2 
; 0000 1BD3 
; 0000 1BD4 
; 0000 1BD5 
; 0000 1BD6                                                               //to nowy war, ostatni dzien w borg
; 0000 1BD7                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x3F0:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x107
	CALL SUBOPT_0x173
	CALL SUBOPT_0x151
	BREQ _0x3F1
; 0000 1BD8                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x152
	CALL SUBOPT_0x10F
; 0000 1BD9 
; 0000 1BDA                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x3F1:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x153
	CALL SUBOPT_0x154
	BREQ _0x3F2
; 0000 1BDB                         {
; 0000 1BDC                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x155
	BRNE _0x3F3
; 0000 1BDD                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 1BDE                         if(abs_ster4 == 0)
_0x3F3:
	CALL SUBOPT_0x157
	BRNE _0x3F4
; 0000 1BDF                             {
; 0000 1BE0                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x176
	BRNE _0x3F5
; 0000 1BE1                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1BE2                             szczotka_druc_cykl++;
_0x3F5:
	CALL SUBOPT_0x158
; 0000 1BE3                             abs_ster4 = 1;
; 0000 1BE4                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x177
	CP   R4,R26
	CPC  R5,R27
	BRNE _0x3F8
; 0000 1BE5                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0x13C
; 0000 1BE6                             }
_0x3F8:
; 0000 1BE7                         else
	RJMP _0x3F9
_0x3F4:
; 0000 1BE8                             {
; 0000 1BE9                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1BEA                             abs_ster4 = 0;
	CALL SUBOPT_0x159
; 0000 1BEB                             sek13 = 0;
; 0000 1BEC                             }
_0x3F9:
; 0000 1BED                         }
; 0000 1BEE 
; 0000 1BEF                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x3F2:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15B
	CALL SUBOPT_0x107
	CALL SUBOPT_0x15C
	BREQ _0x3FC
; 0000 1BF0                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x85
	CALL SUBOPT_0x11A
; 0000 1BF1 
; 0000 1BF2 
; 0000 1BF3                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x3FC:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15D
	CALL SUBOPT_0x15E
	BREQ _0x3FD
; 0000 1BF4                         {
; 0000 1BF5                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 1BF6                         if(abs_ster3 == 0)
	CALL SUBOPT_0x160
	BRNE _0x3FE
; 0000 1BF7                             {
; 0000 1BF8                             krazek_scierny_cykl++;
	CALL SUBOPT_0x161
; 0000 1BF9                             abs_ster3 = 1;
; 0000 1BFA                             }
; 0000 1BFB                         else
	RJMP _0x3FF
_0x3FE:
; 0000 1BFC                             abs_ster3 = 0;
	CALL SUBOPT_0x162
; 0000 1BFD                         }
_0x3FF:
; 0000 1BFE 
; 0000 1BFF                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x3FD:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15B
	CALL SUBOPT_0x84
	AND  R30,R0
	BREQ _0x400
; 0000 1C00                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x11A
; 0000 1C01 
; 0000 1C02                        if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x400:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x84
	CALL SUBOPT_0x163
	BREQ _0x401
; 0000 1C03                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x81
	CALL SUBOPT_0x178
	CALL SUBOPT_0x10F
; 0000 1C04 
; 0000 1C05                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1C06 
; 0000 1C07                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonalem_komplet_okregow == 3)
_0x401:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15D
	CALL SUBOPT_0x165
	BREQ _0x402
; 0000 1C08                        {
; 0000 1C09                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 1C0A                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x166
; 0000 1C0B                        }
; 0000 1C0C                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x402:
	CALL SUBOPT_0x167
	MOV  R0,R30
	CALL SUBOPT_0x15A
	CALL __LTW12
	AND  R30,R0
	BREQ _0x403
; 0000 1C0D                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x10D
; 0000 1C0E 
; 0000 1C0F                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x403:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x168
	AND  R30,R0
	BREQ _0x404
; 0000 1C10                        {
; 0000 1C11                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x169
; 0000 1C12                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1C13                        }
; 0000 1C14                    //////////////////////////////////////////////
; 0000 1C15 
; 0000 1C16 
; 0000 1C17 
; 0000 1C18                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1C19 
; 0000 1C1A                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x404:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x153
	CALL SUBOPT_0x16A
	BREQ _0x407
; 0000 1C1B                        {
; 0000 1C1C                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1C1D                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 1C1E                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x16B
; 0000 1C1F                        }
; 0000 1C20                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x407:
	CALL SUBOPT_0x16C
	MOV  R0,R30
	CALL SUBOPT_0x14E
	CALL __LTW12
	AND  R30,R0
	BREQ _0x40A
; 0000 1C21                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 1C22 
; 0000 1C23                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x40A:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x16D
	AND  R30,R0
	BREQ _0x40B
; 0000 1C24                        {
; 0000 1C25                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x16E
; 0000 1C26                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1C27                        }
; 0000 1C28                    //////////////////////////////////////////////
; 0000 1C29 
; 0000 1C2A                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x40B:
; 0000 1C2B                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1C2C                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1C2D                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0 &  wykonalem_komplet_okregow == 3)
	CALL SUBOPT_0x16F
	CALL SUBOPT_0x170
	CALL SUBOPT_0x171
	CALL SUBOPT_0x172
	CALL SUBOPT_0x173
	CALL SUBOPT_0x174
	BREQ _0x40E
; 0000 1C2E                         {
; 0000 1C2F                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x169
; 0000 1C30                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x16E
; 0000 1C31                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1C32                         cykl_sterownik_2 = 0;
; 0000 1C33                         cykl_sterownik_3 = 0;
; 0000 1C34                         cykl_sterownik_4 = 0;
; 0000 1C35                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x175
; 0000 1C36                         krazek_scierny_cykl = 0;
; 0000 1C37                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1C38                         wykonalem_komplet_okregow = 0;
; 0000 1C39                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1C3A                         //PORTF = PORT_F.byte;
; 0000 1C3B                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1C3C                         cykl_glowny = 9;
; 0000 1C3D                         }
; 0000 1C3E 
; 0000 1C3F  }
_0x40E:
	RET
;
;
;
;void przypadek997()
; 0000 1C44 
; 0000 1C45 {
_przypadek997:
; 0000 1C46 
; 0000 1C47            if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x139
	BRGE _0x411
; 0000 1C48                         {
; 0000 1C49                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x13A
; 0000 1C4A                         PORTF = PORT_F.byte;
; 0000 1C4B                         }
; 0000 1C4C 
; 0000 1C4D 
; 0000 1C4E                      if(rzad_obrabiany == 2)
_0x411:
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x412
; 0000 1C4F                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1C50 
; 0000 1C51                     if(koniec_rzedu_10 == 1)
_0x412:
	CALL SUBOPT_0x13B
	BRNE _0x413
; 0000 1C52                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x13C
; 0000 1C53                                                               //to nowy war, ostatni dzien w borg
; 0000 1C54                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x413:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x107
	CALL SUBOPT_0x173
	CALL SUBOPT_0x151
	BREQ _0x414
; 0000 1C55                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x152
	CALL SUBOPT_0x10F
; 0000 1C56 
; 0000 1C57                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x414:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x153
	CALL SUBOPT_0x154
	BREQ _0x415
; 0000 1C58                         {
; 0000 1C59                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x155
	BRNE _0x416
; 0000 1C5A                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 1C5B                         if(abs_ster4 == 0)
_0x416:
	CALL SUBOPT_0x157
	BRNE _0x417
; 0000 1C5C                             {
; 0000 1C5D                             szczotka_druc_cykl++;
	CALL SUBOPT_0x179
; 0000 1C5E                             //////////////////////
; 0000 1C5F                             if(statystyka == 1)
	CALL SUBOPT_0x17A
	BRNE _0x418
; 0000 1C60                                 {
; 0000 1C61                                 wartosc_parametru_panelu(szczotka_druc_cykl,96,128);
	CALL SUBOPT_0x17B
	CALL SUBOPT_0xB6
	CALL _wartosc_parametru_panelu
; 0000 1C62                                 wartosc_parametru_panelu(cykl_ilosc_zaciskow,128,80);  //pamietac ze zmienna cykl tak naprawde dodaje sie dalej w programie, czyli jak tu bedzie 7 to znaczy ze jestesmy na dolku 8
	CALL SUBOPT_0x17C
	CALL SUBOPT_0x17D
	CALL SUBOPT_0xBC
	CALL _wartosc_parametru_panelu
; 0000 1C63                                 }
; 0000 1C64                             //////////////////////////
; 0000 1C65                             abs_ster4 = 1;
_0x418:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R31
; 0000 1C66                             }
; 0000 1C67                        else
	RJMP _0x419
_0x417:
; 0000 1C68                             {
; 0000 1C69                             abs_ster4 = 0;
	CALL SUBOPT_0x159
; 0000 1C6A                             sek13 = 0;
; 0000 1C6B                             }
_0x419:
; 0000 1C6C                         }
; 0000 1C6D 
; 0000 1C6E                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x415:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15B
	CALL SUBOPT_0x107
	CALL SUBOPT_0x15C
	BREQ _0x41A
; 0000 1C6F                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x85
	CALL SUBOPT_0x11A
; 0000 1C70 
; 0000 1C71 
; 0000 1C72                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x41A:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15D
	CALL SUBOPT_0x15E
	BREQ _0x41B
; 0000 1C73                         {
; 0000 1C74                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 1C75                         if(abs_ster3 == 0)
	CALL SUBOPT_0x160
	BRNE _0x41C
; 0000 1C76                             {
; 0000 1C77                             krazek_scierny_cykl++;
	CALL SUBOPT_0x17E
; 0000 1C78                             //////////////////////
; 0000 1C79                             if(statystyka == 1)
	CALL SUBOPT_0x17A
	BRNE _0x41D
; 0000 1C7A                                 wartosc_parametru_panelu(krazek_scierny_cykl,128,96);
	CALL SUBOPT_0x17F
	CALL SUBOPT_0x23
	CALL _wartosc_parametru_panelu
; 0000 1C7B                             //////////////////////////
; 0000 1C7C                             abs_ster3 = 1;
_0x41D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R31
; 0000 1C7D                             }
; 0000 1C7E                         else
	RJMP _0x41E
_0x41C:
; 0000 1C7F                             abs_ster3 = 0;
	CALL SUBOPT_0x162
; 0000 1C80                         }
_0x41E:
; 0000 1C81 
; 0000 1C82                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x41B:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15B
	CALL SUBOPT_0x84
	AND  R30,R0
	BREQ _0x41F
; 0000 1C83                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x11A
; 0000 1C84 
; 0000 1C85 
; 0000 1C86                      if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x41F:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x84
	CALL SUBOPT_0x163
	BREQ _0x420
; 0000 1C87                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory kawaleczek
	CALL SUBOPT_0x164
	CALL SUBOPT_0x10F
; 0000 1C88 
; 0000 1C89                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1C8A 
; 0000 1C8B                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonano_powrot_przedwczesny_krazek_scierny == 0)
_0x420:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15D
	CALL SUBOPT_0x180
	AND  R0,R30
	LDS  R26,_wykonano_powrot_przedwczesny_krazek_scierny
	LDS  R27,_wykonano_powrot_przedwczesny_krazek_scierny+1
	CALL SUBOPT_0xEA
	BREQ _0x421
; 0000 1C8C                        {
; 0000 1C8D                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 1C8E                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x166
; 0000 1C8F 
; 0000 1C90                        //////////////////////
; 0000 1C91                        if(statystyka == 1)
	CALL SUBOPT_0x17A
	BRNE _0x422
; 0000 1C92                             wartosc_parametru_panelu(powrot_przedwczesny_krazek_scierny,128,112);
	CALL SUBOPT_0x181
	CALL SUBOPT_0xA9
	CALL _wartosc_parametru_panelu
; 0000 1C93                        //////////////////////////
; 0000 1C94                        sek21 = 0;   //liczenie wlaczenie krazek
_0x422:
	CALL SUBOPT_0x182
; 0000 1C95                        }
; 0000 1C96                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x421:
	CALL SUBOPT_0x167
	MOV  R0,R30
	CALL SUBOPT_0x15A
	CALL __LTW12
	AND  R30,R0
	BREQ _0x423
; 0000 1C97                        {
; 0000 1C98                        //if(sek21 > sek21_wylaczenie_szlif)
; 0000 1C99                        //     PORTE.3 = 0;  //szlifierka 2 (krazek scierny) - wylaczenie bo ocieralo
; 0000 1C9A 
; 0000 1C9B                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x10D
; 0000 1C9C                        }
; 0000 1C9D                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x423:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x168
	AND  R30,R0
	BREQ _0x424
; 0000 1C9E                        {
; 0000 1C9F                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x169
; 0000 1CA0                        wykonano_powrot_przedwczesny_krazek_scierny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonano_powrot_przedwczesny_krazek_scierny,R30
	STS  _wykonano_powrot_przedwczesny_krazek_scierny+1,R31
; 0000 1CA1                        //////////////////////
; 0000 1CA2                        if(statystyka == 1)
	CALL SUBOPT_0x17A
	BRNE _0x425
; 0000 1CA3                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_krazek_scierny,128,128);
	CALL SUBOPT_0x183
	CALL SUBOPT_0xB6
	CALL _wartosc_parametru_panelu
; 0000 1CA4                        //////////////////////////
; 0000 1CA5                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
_0x425:
	CBI  0x3,3
; 0000 1CA6                        }
; 0000 1CA7                    //////////////////////////////////////////////
; 0000 1CA8 
; 0000 1CA9 
; 0000 1CAA 
; 0000 1CAB                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1CAC 
; 0000 1CAD                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli & wykonano_powrot_przedwczesny_druciak == 0)
_0x424:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x153
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x184
	AND  R0,R30
	LDS  R26,_wykonano_powrot_przedwczesny_druciak
	LDS  R27,_wykonano_powrot_przedwczesny_druciak+1
	CALL SUBOPT_0xEA
	BREQ _0x428
; 0000 1CAE                        {
; 0000 1CAF                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1CB0                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 1CB1                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x16B
; 0000 1CB2                        //////////////////////
; 0000 1CB3                        if(statystyka == 1)
	CALL SUBOPT_0x17A
	BRNE _0x42B
; 0000 1CB4                             wartosc_parametru_panelu(powrot_przedwczesny_druciak,96,144);
	CALL SUBOPT_0x185
	CALL SUBOPT_0xA7
	CALL _wartosc_parametru_panelu
; 0000 1CB5                        //////////////////////////
; 0000 1CB6                        }
_0x42B:
; 0000 1CB7                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x428:
	CALL SUBOPT_0x16C
	MOV  R0,R30
	CALL SUBOPT_0x14E
	CALL __LTW12
	AND  R30,R0
	BREQ _0x42C
; 0000 1CB8                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 1CB9 
; 0000 1CBA                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x42C:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x16D
	AND  R30,R0
	BREQ _0x42D
; 0000 1CBB                        {
; 0000 1CBC                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x16E
; 0000 1CBD                        wykonano_powrot_przedwczesny_druciak = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonano_powrot_przedwczesny_druciak,R30
	STS  _wykonano_powrot_przedwczesny_druciak+1,R31
; 0000 1CBE                        ///////////////////////////////
; 0000 1CBF                        if(statystyka == 1)
	CALL SUBOPT_0x17A
	BRNE _0x42E
; 0000 1CC0                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_druciak,112,0);
	CALL SUBOPT_0x186
	CALL SUBOPT_0x9
	CALL _wartosc_parametru_panelu
; 0000 1CC1                        //////////////////////////////
; 0000 1CC2                        PORTE.2 = 0;  //wylacz szlifierke
_0x42E:
	CBI  0x3,2
; 0000 1CC3                        }
; 0000 1CC4                    ///////////////////////////////////////////////////////////////////////
; 0000 1CC5 
; 0000 1CC6                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x42D:
; 0000 1CC7                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1CC8                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1CC9                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0)
	CALL SUBOPT_0x16F
	CALL SUBOPT_0x170
	CALL SUBOPT_0x171
	CALL SUBOPT_0x172
	CALL SUBOPT_0x150
	CALL SUBOPT_0xEA
	BREQ _0x431
; 0000 1CCA                         {
; 0000 1CCB                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x169
; 0000 1CCC                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x16E
; 0000 1CCD                         wykonano_powrot_przedwczesny_krazek_scierny = 0;
	LDI  R30,LOW(0)
	STS  _wykonano_powrot_przedwczesny_krazek_scierny,R30
	STS  _wykonano_powrot_przedwczesny_krazek_scierny+1,R30
; 0000 1CCE                         wykonano_powrot_przedwczesny_druciak = 0;
	STS  _wykonano_powrot_przedwczesny_druciak,R30
	STS  _wykonano_powrot_przedwczesny_druciak+1,R30
; 0000 1CCF                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1CD0                         cykl_sterownik_2 = 0;
; 0000 1CD1                         cykl_sterownik_3 = 0;
; 0000 1CD2                         cykl_sterownik_4 = 0;
; 0000 1CD3                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x187
; 0000 1CD4                         krazek_scierny_cykl = 0;
; 0000 1CD5                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1CD6                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1CD7                         //PORTF = PORT_F.byte;
; 0000 1CD8                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1CD9 
; 0000 1CDA                         if(statystyka == 1)
	CALL SUBOPT_0x17A
	BRNE _0x434
; 0000 1CDB                             {
; 0000 1CDC                             wartosc_parametru_panelu(szczotka_druc_cykl,96,128);
	CALL SUBOPT_0x17B
	CALL SUBOPT_0xB6
	CALL _wartosc_parametru_panelu
; 0000 1CDD                             wartosc_parametru_panelu(krazek_scierny_cykl,128,96);
	CALL SUBOPT_0x17F
	CALL SUBOPT_0x23
	CALL _wartosc_parametru_panelu
; 0000 1CDE                             wartosc_parametru_panelu(powrot_przedwczesny_druciak,96,144);
	CALL SUBOPT_0x185
	CALL SUBOPT_0xA7
	CALL _wartosc_parametru_panelu
; 0000 1CDF                             wartosc_parametru_panelu(powrot_przedwczesny_krazek_scierny,128,112);
	CALL SUBOPT_0x181
	CALL SUBOPT_0xA9
	CALL _wartosc_parametru_panelu
; 0000 1CE0                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_druciak,112,0);
	CALL SUBOPT_0x186
	CALL SUBOPT_0x9
	CALL _wartosc_parametru_panelu
; 0000 1CE1                             wartosc_parametru_panelu(wykonano_powrot_przedwczesny_krazek_scierny,128,128);
	CALL SUBOPT_0x183
	CALL SUBOPT_0xB6
	CALL _wartosc_parametru_panelu
; 0000 1CE2                             }
; 0000 1CE3                         cykl_glowny = 9;
_0x434:
	CALL SUBOPT_0x188
; 0000 1CE4                         sek21 = 0;
	CALL SUBOPT_0x182
; 0000 1CE5                         }
; 0000 1CE6 
; 0000 1CE7 }
_0x431:
	RET
;
;void przypadek998()
; 0000 1CEA {
_przypadek998:
; 0000 1CEB 
; 0000 1CEC            if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x139
	BRGE _0x435
; 0000 1CED                         {
; 0000 1CEE                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x13A
; 0000 1CEF                         PORTF = PORT_F.byte;
; 0000 1CF0                         }
; 0000 1CF1 
; 0000 1CF2 
; 0000 1CF3                      if(rzad_obrabiany == 2)
_0x435:
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x436
; 0000 1CF4                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1CF5 
; 0000 1CF6                     if(koniec_rzedu_10 == 1)
_0x436:
	CALL SUBOPT_0x13B
	BRNE _0x437
; 0000 1CF7                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x13C
; 0000 1CF8 
; 0000 1CF9                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
_0x437:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x107
	CALL SUBOPT_0x173
	CALL SUBOPT_0x151
	BREQ _0x438
; 0000 1CFA                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x152
	CALL SUBOPT_0x10F
; 0000 1CFB 
; 0000 1CFC                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x438:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x153
	CALL SUBOPT_0x154
	BREQ _0x439
; 0000 1CFD                         {
; 0000 1CFE                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x155
	BRNE _0x43A
; 0000 1CFF                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 1D00                         if(abs_ster4 == 0)
_0x43A:
	CALL SUBOPT_0x157
	BRNE _0x43B
; 0000 1D01                             {
; 0000 1D02                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x176
	BRNE _0x43C
; 0000 1D03                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1D04                             szczotka_druc_cykl++;
_0x43C:
	CALL SUBOPT_0x158
; 0000 1D05                             abs_ster4 = 1;
; 0000 1D06                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x177
	CP   R4,R26
	CPC  R5,R27
	BRNE _0x43F
; 0000 1D07                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0x13C
; 0000 1D08                             }
_0x43F:
; 0000 1D09                         else
	RJMP _0x440
_0x43B:
; 0000 1D0A                             {
; 0000 1D0B                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1D0C                             abs_ster4 = 0;
	CALL SUBOPT_0x159
; 0000 1D0D                             sek13 = 0;
; 0000 1D0E                             }
_0x440:
; 0000 1D0F                         }
; 0000 1D10 
; 0000 1D11                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
_0x439:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15B
	CALL SUBOPT_0x107
	CALL SUBOPT_0x15C
	BREQ _0x443
; 0000 1D12                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	CALL SUBOPT_0x85
	CALL SUBOPT_0x11A
; 0000 1D13 
; 0000 1D14 
; 0000 1D15                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
_0x443:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15D
	CALL SUBOPT_0x15E
	BREQ _0x444
; 0000 1D16                         {
; 0000 1D17                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 1D18                         if(abs_ster3 == 0)
	CALL SUBOPT_0x160
	BRNE _0x445
; 0000 1D19                             {
; 0000 1D1A                             krazek_scierny_cykl++;
	CALL SUBOPT_0x161
; 0000 1D1B 
; 0000 1D1C                             abs_ster3 = 1;
; 0000 1D1D                             }
; 0000 1D1E                         else
	RJMP _0x446
_0x445:
; 0000 1D1F                             abs_ster3 = 0;
	CALL SUBOPT_0x162
; 0000 1D20                         }
_0x446:
; 0000 1D21 
; 0000 1D22                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x444:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15B
	CALL SUBOPT_0x84
	AND  R30,R0
	BREQ _0x447
; 0000 1D23                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x11A
; 0000 1D24 
; 0000 1D25                        if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x447:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x84
	CALL SUBOPT_0x163
	BREQ _0x448
; 0000 1D26                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x81
	CALL SUBOPT_0x178
	CALL SUBOPT_0x10F
; 0000 1D27 
; 0000 1D28 
; 0000 1D29 
; 0000 1D2A                    ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1D2B 
; 0000 1D2C                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x448:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15D
	CALL SUBOPT_0x180
	AND  R30,R0
	BREQ _0x449
; 0000 1D2D                        {
; 0000 1D2E                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 1D2F                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x166
; 0000 1D30                        }
; 0000 1D31                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x449:
	CALL SUBOPT_0x167
	MOV  R0,R30
	CALL SUBOPT_0x15A
	CALL __LTW12
	AND  R30,R0
	BREQ _0x44A
; 0000 1D32                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x10D
; 0000 1D33 
; 0000 1D34                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x44A:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x168
	AND  R30,R0
	BREQ _0x44B
; 0000 1D35                        {
; 0000 1D36                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x169
; 0000 1D37                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1D38                        }
; 0000 1D39                    //////////////////////////////////////////////
; 0000 1D3A 
; 0000 1D3B 
; 0000 1D3C 
; 0000 1D3D                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1D3E 
; 0000 1D3F                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
_0x44B:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x153
	CALL SUBOPT_0x16A
	BREQ _0x44E
; 0000 1D40                        {
; 0000 1D41                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1D42                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 1D43                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x16B
; 0000 1D44                        }
; 0000 1D45                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x44E:
	CALL SUBOPT_0x16C
	MOV  R0,R30
	CALL SUBOPT_0x14E
	CALL __LTW12
	AND  R30,R0
	BREQ _0x451
; 0000 1D46                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 1D47 
; 0000 1D48                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x451:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x16D
	AND  R30,R0
	BREQ _0x452
; 0000 1D49                        {
; 0000 1D4A                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x16E
; 0000 1D4B                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1D4C                        }
; 0000 1D4D                    //////////////////////////////////////////////
; 0000 1D4E 
; 0000 1D4F                     if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
_0x452:
; 0000 1D50                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1D51                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
; 0000 1D52                        powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0)
	CALL SUBOPT_0x16F
	CALL SUBOPT_0x170
	CALL SUBOPT_0x171
	CALL SUBOPT_0x172
	CALL SUBOPT_0x150
	CALL SUBOPT_0xEA
	BREQ _0x455
; 0000 1D53                         {
; 0000 1D54                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x169
; 0000 1D55                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x16E
; 0000 1D56                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1D57                         cykl_sterownik_2 = 0;
; 0000 1D58                         cykl_sterownik_3 = 0;
; 0000 1D59                         cykl_sterownik_4 = 0;
; 0000 1D5A                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x187
; 0000 1D5B                         krazek_scierny_cykl = 0;
; 0000 1D5C                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1D5D                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1D5E                         //PORTF = PORT_F.byte;
; 0000 1D5F                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1D60                         cykl_glowny = 9;
	CALL SUBOPT_0x188
; 0000 1D61                         }
; 0000 1D62 }
_0x455:
	RET
;
;
;void przypadek8()
; 0000 1D66 
; 0000 1D67 {
_przypadek8:
; 0000 1D68 
; 0000 1D69                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x139
	BRGE _0x458
; 0000 1D6A                         {
; 0000 1D6B                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x13A
; 0000 1D6C                         PORTF = PORT_F.byte;
; 0000 1D6D                         }
; 0000 1D6E 
; 0000 1D6F 
; 0000 1D70                      if(rzad_obrabiany == 2)
_0x458:
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x459
; 0000 1D71                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1D72 
; 0000 1D73 
; 0000 1D74 
; 0000 1D75                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x459:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x13F
	BREQ _0x45A
; 0000 1D76                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x140
; 0000 1D77                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x45A:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x141
	BREQ _0x45B
; 0000 1D78                         {
; 0000 1D79                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1D7A                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x143
; 0000 1D7B                         }
; 0000 1D7C 
; 0000 1D7D 
; 0000 1D7E                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x45B:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x144
	AND  R30,R0
	BREQ _0x45C
; 0000 1D7F                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x145
; 0000 1D80 
; 0000 1D81                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x45C:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x146
	AND  R30,R0
	BREQ _0x45D
; 0000 1D82                         {
; 0000 1D83                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1D84                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x147
; 0000 1D85                         }
; 0000 1D86 
; 0000 1D87                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x45D:
	CALL SUBOPT_0x148
	AND  R30,R0
	BREQ _0x45E
; 0000 1D88                         {
; 0000 1D89                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1D8A                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x149
; 0000 1D8B                         }
; 0000 1D8C 
; 0000 1D8D                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1D8E                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x45E:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x14A
	AND  R30,R0
	BREQ _0x45F
; 0000 1D8F                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x14B
; 0000 1D90 
; 0000 1D91 
; 0000 1D92                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x45F:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x14C
	AND  R30,R0
	BREQ _0x460
; 0000 1D93                         {
; 0000 1D94                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1D95                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x14D
; 0000 1D96                         }
; 0000 1D97 
; 0000 1D98                     if(cykl_sterownik_3 < 5 & wykonalem_komplet_okregow == 3)
_0x460:
	CALL SUBOPT_0x15A
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x174
	BREQ _0x461
; 0000 1D99                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV         //tu zmienienie INV, ¿eby szed³ w dol
	CALL SUBOPT_0x85
	CALL SUBOPT_0x11A
; 0000 1D9A 
; 0000 1D9B                      if(cykl_sterownik_3 == 5 & wykonalem_komplet_okregow == 3)
_0x461:
	CALL SUBOPT_0x15A
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x174
	BREQ _0x462
; 0000 1D9C                         {
; 0000 1D9D                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x189
; 0000 1D9E                         krazek_scierny_cykl++;
; 0000 1D9F 
; 0000 1DA0                         if(krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x18A
	BRNE _0x463
; 0000 1DA1                             {
; 0000 1DA2                             wykonalem_komplet_okregow = 4;
	CALL SUBOPT_0x18B
; 0000 1DA3                             }
; 0000 1DA4                         else
	RJMP _0x464
_0x463:
; 0000 1DA5                             wykonalem_komplet_okregow = 0;
	CALL SUBOPT_0x18C
; 0000 1DA6 
; 0000 1DA7                         cykl_sterownik_1 = 0;
_0x464:
	CALL SUBOPT_0x142
; 0000 1DA8                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 1DA9                         }
; 0000 1DAA 
; 0000 1DAB 
; 0000 1DAC 
; 0000 1DAD 
; 0000 1DAE 
; 0000 1DAF                     if(koniec_rzedu_10 == 1)
_0x462:
	CALL SUBOPT_0x13B
	BRNE _0x465
; 0000 1DB0                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x13C
; 0000 1DB1                                                               //to nowy war, ostatni dzien w borg
; 0000 1DB2                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze & koniec_rzedu_10 == 0)
_0x465:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x107
	CALL SUBOPT_0x173
	CALL SUBOPT_0x18D
	BREQ _0x466
; 0000 1DB3                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x152
	CALL SUBOPT_0x10F
; 0000 1DB4 
; 0000 1DB5                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x466:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x153
	CALL __LTW12
	AND  R0,R30
	CALL SUBOPT_0x173
	CALL SUBOPT_0x18E
	BREQ _0x467
; 0000 1DB6                         {
; 0000 1DB7                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x155
	BRNE _0x468
; 0000 1DB8                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 1DB9                         if(abs_ster4 == 0)
_0x468:
	CALL SUBOPT_0x157
	BRNE _0x469
; 0000 1DBA                             {
; 0000 1DBB                             szczotka_druc_cykl++;
	CALL SUBOPT_0x158
; 0000 1DBC                             abs_ster4 = 1;
; 0000 1DBD                             }
; 0000 1DBE                         else
	RJMP _0x46A
_0x469:
; 0000 1DBF                             {
; 0000 1DC0                             abs_ster4 = 0;
	CALL SUBOPT_0x159
; 0000 1DC1                             sek13 = 0;
; 0000 1DC2                             }
_0x46A:
; 0000 1DC3                         }
; 0000 1DC4 
; 0000 1DC5 
; 0000 1DC6                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x467:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x84
	AND  R0,R30
	CALL SUBOPT_0x173
	CALL SUBOPT_0x18E
	BREQ _0x46B
; 0000 1DC7                         cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory
	CALL SUBOPT_0x164
	CALL SUBOPT_0x10F
; 0000 1DC8 
; 0000 1DC9 
; 0000 1DCA                         ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1DCB 
; 0000 1DCC                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x46B:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15D
	CALL SUBOPT_0x180
	AND  R30,R0
	BREQ _0x46C
; 0000 1DCD                        {
; 0000 1DCE                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 1DCF                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x166
; 0000 1DD0                        }
; 0000 1DD1                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x46C:
	CALL SUBOPT_0x167
	MOV  R0,R30
	CALL SUBOPT_0x15A
	CALL __LTW12
	AND  R30,R0
	BREQ _0x46D
; 0000 1DD2                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x10D
; 0000 1DD3 
; 0000 1DD4                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x46D:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x168
	AND  R30,R0
	BREQ _0x46E
; 0000 1DD5                        {
; 0000 1DD6                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x169
; 0000 1DD7                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1DD8                        }
; 0000 1DD9                    //////////////////////////////////////////////
; 0000 1DDA 
; 0000 1DDB 
; 0000 1DDC 
; 0000 1DDD                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1DDE 
; 0000 1DDF                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
_0x46E:
	CALL SUBOPT_0x18F
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x190
	OR   R30,R0
	AND  R30,R1
	BREQ _0x471
; 0000 1DE0                        {
; 0000 1DE1                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1DE2                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 1DE3                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x16B
; 0000 1DE4                        }
; 0000 1DE5                   if(koniec_rzedu_10 == 0 & powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x471:
	CALL SUBOPT_0x18F
	CALL SUBOPT_0x16C
	AND  R0,R30
	CALL SUBOPT_0x14E
	CALL __LTW12
	AND  R30,R0
	BREQ _0x474
; 0000 1DE6                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 1DE7 
; 0000 1DE8                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x474:
	CALL SUBOPT_0x18F
	CALL SUBOPT_0x14E
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x16C
	AND  R30,R0
	BREQ _0x475
; 0000 1DE9                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x16E
; 0000 1DEA                    //////////////////////////////////////////////
; 0000 1DEB 
; 0000 1DEC                     if((wykonalem_komplet_okregow == 4 &
_0x475:
; 0000 1DED                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 1DEE                         cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0 & powrot_przedwczesny_krazek_scierny == 0) | (wykonalem_komplet_okregow == 4 & koniec_rzedu_10 == 1 & powrot_przedwczesny_krazek_scierny == 0) )
	CALL SUBOPT_0x191
	CALL SUBOPT_0x192
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x173
	CALL SUBOPT_0x15C
	CALL SUBOPT_0x193
	AND  R0,R30
	CALL SUBOPT_0x15C
	OR   R30,R1
	BREQ _0x476
; 0000 1DEF                         {
; 0000 1DF0                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x16E
; 0000 1DF1                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x169
; 0000 1DF2                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1DF3                         cykl_sterownik_2 = 0;
; 0000 1DF4                         cykl_sterownik_3 = 0;
; 0000 1DF5                         cykl_sterownik_4 = 0;
; 0000 1DF6                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x187
; 0000 1DF7                         krazek_scierny_cykl = 0;
; 0000 1DF8                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1DF9                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1DFA                         //PORTF = PORT_F.byte;
; 0000 1DFB                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1DFC                         cykl_glowny = 9;
	CALL SUBOPT_0x188
; 0000 1DFD                         }
; 0000 1DFE }
_0x476:
	RET
;                                                                                                //ster 1 - ruch po okregu
;                                                                                                //ster 2 - nic
;                                                                                                //ster 3 - krazek - gora dol
;                                                                                                //ster 4 - druciak - gora dol
;
;
;void przypadek88()
; 0000 1E06 {
_przypadek88:
; 0000 1E07 
; 0000 1E08                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x139
	BRGE _0x479
; 0000 1E09                         {
; 0000 1E0A                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x13A
; 0000 1E0B                         PORTF = PORT_F.byte;
; 0000 1E0C                         }
; 0000 1E0D 
; 0000 1E0E 
; 0000 1E0F                      if(rzad_obrabiany == 2)
_0x479:
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x47A
; 0000 1E10                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1E11 
; 0000 1E12 
; 0000 1E13 
; 0000 1E14                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
_0x47A:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x13E
	CALL SUBOPT_0x13F
	BREQ _0x47B
; 0000 1E15                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x140
; 0000 1E16                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
_0x47B:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x141
	BREQ _0x47C
; 0000 1E17                         {
; 0000 1E18                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1E19                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0x143
; 0000 1E1A                         }
; 0000 1E1B 
; 0000 1E1C 
; 0000 1E1D                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x47C:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x144
	AND  R30,R0
	BREQ _0x47D
; 0000 1E1E                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	CALL SUBOPT_0x145
; 0000 1E1F 
; 0000 1E20                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x47D:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x146
	AND  R30,R0
	BREQ _0x47E
; 0000 1E21                         {
; 0000 1E22                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1E23                         krazek_scierny_cykl_po_okregu++;
	CALL SUBOPT_0x147
; 0000 1E24                         }
; 0000 1E25 
; 0000 1E26                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
_0x47E:
	CALL SUBOPT_0x148
	AND  R30,R0
	BREQ _0x47F
; 0000 1E27                         {
; 0000 1E28                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1E29                         wykonalem_komplet_okregow = 2;
	CALL SUBOPT_0x149
; 0000 1E2A                         }
; 0000 1E2B 
; 0000 1E2C                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1E2D                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
_0x47F:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x14A
	AND  R30,R0
	BREQ _0x480
; 0000 1E2E                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	CALL SUBOPT_0x14B
; 0000 1E2F 
; 0000 1E30 
; 0000 1E31                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
_0x480:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x14C
	AND  R30,R0
	BREQ _0x481
; 0000 1E32                         {
; 0000 1E33                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 1E34                         wykonalem_komplet_okregow = 3;
	CALL SUBOPT_0x14D
; 0000 1E35                         }
; 0000 1E36 
; 0000 1E37                     if(cykl_sterownik_3 < 5 & wykonalem_komplet_okregow == 3)
_0x481:
	CALL SUBOPT_0x15A
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x174
	BREQ _0x482
; 0000 1E38                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV         //tu zmienienie INV, ¿eby szed³ w dol
	CALL SUBOPT_0x85
	CALL SUBOPT_0x11A
; 0000 1E39 
; 0000 1E3A                      if(cykl_sterownik_3 == 5 & wykonalem_komplet_okregow == 3)
_0x482:
	CALL SUBOPT_0x15A
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x174
	BREQ _0x483
; 0000 1E3B                         {
; 0000 1E3C                         krazek_scierny_cykl_po_okregu = 0;
	CALL SUBOPT_0x189
; 0000 1E3D                         krazek_scierny_cykl++;
; 0000 1E3E 
; 0000 1E3F                         if(krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x18A
	BRNE _0x484
; 0000 1E40                             {
; 0000 1E41                             wykonalem_komplet_okregow = 4;
	CALL SUBOPT_0x18B
; 0000 1E42                             }
; 0000 1E43                         else
	RJMP _0x485
_0x484:
; 0000 1E44                             wykonalem_komplet_okregow = 0;
	CALL SUBOPT_0x18C
; 0000 1E45 
; 0000 1E46                         cykl_sterownik_1 = 0;
_0x485:
	CALL SUBOPT_0x142
; 0000 1E47                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 1E48                         }
; 0000 1E49 
; 0000 1E4A 
; 0000 1E4B 
; 0000 1E4C 
; 0000 1E4D 
; 0000 1E4E                     if(koniec_rzedu_10 == 1)
_0x483:
	CALL SUBOPT_0x13B
	BRNE _0x486
; 0000 1E4F                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x13C
; 0000 1E50                                                               //to nowy war, ostatni dzien w borg
; 0000 1E51                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze & koniec_rzedu_10 == 0)
_0x486:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x107
	CALL SUBOPT_0x173
	CALL SUBOPT_0x18D
	BREQ _0x487
; 0000 1E52                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x152
	CALL SUBOPT_0x10F
; 0000 1E53 
; 0000 1E54                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x487:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x153
	CALL __LTW12
	AND  R0,R30
	CALL SUBOPT_0x173
	CALL SUBOPT_0x18E
	BREQ _0x488
; 0000 1E55                         {
; 0000 1E56                         if(koniec_rzedu_10 == 0)
	CALL SUBOPT_0x155
	BRNE _0x489
; 0000 1E57                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 1E58                         if(abs_ster4 == 0)
_0x489:
	CALL SUBOPT_0x157
	BRNE _0x48A
; 0000 1E59                             {
; 0000 1E5A                              if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x176
	BRNE _0x48B
; 0000 1E5B                                 PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1E5C                             szczotka_druc_cykl++;
_0x48B:
	CALL SUBOPT_0x158
; 0000 1E5D                             abs_ster4 = 1;
; 0000 1E5E                             if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
	CALL SUBOPT_0x177
	CP   R4,R26
	CPC  R5,R27
	BRNE _0x48E
; 0000 1E5F                                 cykl_sterownik_4 = 5;
	CALL SUBOPT_0x13C
; 0000 1E60                             }
_0x48E:
; 0000 1E61                          else
	RJMP _0x48F
_0x48A:
; 0000 1E62                             {
; 0000 1E63                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1E64                             abs_ster4 = 0;
	CALL SUBOPT_0x159
; 0000 1E65                             sek13 = 0;
; 0000 1E66                             }
_0x48F:
; 0000 1E67                         }
; 0000 1E68 
; 0000 1E69 
; 0000 1E6A 
; 0000 1E6B                         if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
_0x488:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x14F
	CALL SUBOPT_0x84
	AND  R0,R30
	CALL SUBOPT_0x173
	CALL SUBOPT_0x18E
	BREQ _0x492
; 0000 1E6C                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
	CALL SUBOPT_0x81
	CALL SUBOPT_0x178
	CALL SUBOPT_0x10F
; 0000 1E6D 
; 0000 1E6E                         ///////////////////////////////////////////////powrot przedwczesny krazek scierny
; 0000 1E6F 
; 0000 1E70                   if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
_0x492:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x15D
	CALL SUBOPT_0x180
	AND  R30,R0
	BREQ _0x493
; 0000 1E71                        {
; 0000 1E72                        cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 1E73                        powrot_przedwczesny_krazek_scierny = 1;
	CALL SUBOPT_0x166
; 0000 1E74                        }
; 0000 1E75                   if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)
_0x493:
	CALL SUBOPT_0x167
	MOV  R0,R30
	CALL SUBOPT_0x15A
	CALL __LTW12
	AND  R30,R0
	BREQ _0x494
; 0000 1E76                        cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x10D
; 0000 1E77 
; 0000 1E78                   if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
_0x494:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x168
	AND  R30,R0
	BREQ _0x495
; 0000 1E79                        {
; 0000 1E7A                        powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x169
; 0000 1E7B                        PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1E7C                        }
; 0000 1E7D                    //////////////////////////////////////////////
; 0000 1E7E 
; 0000 1E7F 
; 0000 1E80 
; 0000 1E81                    ///////////////////////////////////////////////powrot przedwczesny druciak
; 0000 1E82 
; 0000 1E83                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
_0x495:
	CALL SUBOPT_0x18F
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x190
	OR   R30,R0
	AND  R30,R1
	BREQ _0x498
; 0000 1E84                        {
; 0000 1E85                        PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1E86                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 1E87                        powrot_przedwczesny_druciak = 1;
	CALL SUBOPT_0x16B
; 0000 1E88                        }
; 0000 1E89                   if(koniec_rzedu_10 == 0 & powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x498:
	CALL SUBOPT_0x18F
	CALL SUBOPT_0x16C
	AND  R0,R30
	CALL SUBOPT_0x14E
	CALL __LTW12
	AND  R30,R0
	BREQ _0x49B
; 0000 1E8A                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 1E8B 
; 0000 1E8C                   if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x49B:
	CALL SUBOPT_0x18F
	CALL SUBOPT_0x14E
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x16C
	AND  R30,R0
	BREQ _0x49C
; 0000 1E8D                        powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x16E
; 0000 1E8E                    //////////////////////////////////////////////
; 0000 1E8F 
; 0000 1E90                     if((wykonalem_komplet_okregow == 4 &
_0x49C:
; 0000 1E91                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 1E92                         cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0 & powrot_przedwczesny_krazek_scierny == 0) | (wykonalem_komplet_okregow == 4 & koniec_rzedu_10 == 1 & powrot_przedwczesny_krazek_scierny == 0) )
	CALL SUBOPT_0x191
	CALL SUBOPT_0x192
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x173
	CALL SUBOPT_0x15C
	CALL SUBOPT_0x193
	AND  R0,R30
	CALL SUBOPT_0x15C
	OR   R30,R1
	BREQ _0x49D
; 0000 1E93                         {
; 0000 1E94                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x16E
; 0000 1E95                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x169
; 0000 1E96                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 1E97                         cykl_sterownik_2 = 0;
; 0000 1E98                         cykl_sterownik_3 = 0;
; 0000 1E99                         cykl_sterownik_4 = 0;
; 0000 1E9A                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x187
; 0000 1E9B                         krazek_scierny_cykl = 0;
; 0000 1E9C                         krazek_scierny_cykl_po_okregu = 0;
; 0000 1E9D                         //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
; 0000 1E9E                         //PORTF = PORT_F.byte;
; 0000 1E9F                         PORTE.2 = 0;  //wylacz szlifierke
; 0000 1EA0                         cykl_glowny = 9;
	CALL SUBOPT_0x188
; 0000 1EA1                         }
; 0000 1EA2 
; 0000 1EA3                                                                                                 //ster 1 - ruch po okregu
; 0000 1EA4                                                                                                 //ster 2 - nic
; 0000 1EA5                                                                                                 //ster 3 - krazek - gora dol
; 0000 1EA6                                                                                                 //ster 4 - druciak - gora dol
; 0000 1EA7 
; 0000 1EA8 
; 0000 1EA9 }
_0x49D:
	RET
;
;
;void main(void)
; 0000 1EAD {
_main:
; 0000 1EAE 
; 0000 1EAF // Input/Output Ports initialization
; 0000 1EB0 // Port A initialization
; 0000 1EB1 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1EB2 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1EB3 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 1EB4 DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 1EB5 
; 0000 1EB6 // Port B initialization
; 0000 1EB7 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1EB8 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1EB9 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 1EBA DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 1EBB 
; 0000 1EBC // Port C initialization
; 0000 1EBD // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1EBE // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1EBF PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 1EC0 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 1EC1 
; 0000 1EC2 // Port D initialization
; 0000 1EC3 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1EC4 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1EC5 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 1EC6 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 1EC7 
; 0000 1EC8 // Port E initialization
; 0000 1EC9 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1ECA // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1ECB PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 1ECC DDRE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 1ECD 
; 0000 1ECE // Port F initialization
; 0000 1ECF // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1ED0 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1ED1 PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 1ED2 DDRF=0xFF;
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 1ED3 
; 0000 1ED4 // Port G initialization
; 0000 1ED5 // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1ED6 // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1ED7 PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 1ED8 DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 1ED9 
; 0000 1EDA 
; 0000 1EDB 
; 0000 1EDC 
; 0000 1EDD 
; 0000 1EDE // Timer/Counter 0 initialization
; 0000 1EDF // Clock source: System Clock
; 0000 1EE0 // Clock value: 15,625 kHz
; 0000 1EE1 // Mode: Normal top=0xFF
; 0000 1EE2 // OC0 output: Disconnected
; 0000 1EE3 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 1EE4 TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 1EE5 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 1EE6 OCR0=0x00;
	OUT  0x31,R30
; 0000 1EE7 
; 0000 1EE8 // Timer/Counter 1 initialization
; 0000 1EE9 // Clock source: System Clock
; 0000 1EEA // Clock value: Timer1 Stopped
; 0000 1EEB // Mode: Normal top=0xFFFF
; 0000 1EEC // OC1A output: Discon.
; 0000 1EED // OC1B output: Discon.
; 0000 1EEE // OC1C output: Discon.
; 0000 1EEF // Noise Canceler: Off
; 0000 1EF0 // Input Capture on Falling Edge
; 0000 1EF1 // Timer1 Overflow Interrupt: Off
; 0000 1EF2 // Input Capture Interrupt: Off
; 0000 1EF3 // Compare A Match Interrupt: Off
; 0000 1EF4 // Compare B Match Interrupt: Off
; 0000 1EF5 // Compare C Match Interrupt: Off
; 0000 1EF6 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 1EF7 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 1EF8 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 1EF9 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 1EFA ICR1H=0x00;
	OUT  0x27,R30
; 0000 1EFB ICR1L=0x00;
	OUT  0x26,R30
; 0000 1EFC OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 1EFD OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 1EFE OCR1BH=0x00;
	OUT  0x29,R30
; 0000 1EFF OCR1BL=0x00;
	OUT  0x28,R30
; 0000 1F00 OCR1CH=0x00;
	STS  121,R30
; 0000 1F01 OCR1CL=0x00;
	STS  120,R30
; 0000 1F02 
; 0000 1F03 // Timer/Counter 2 initialization
; 0000 1F04 // Clock source: System Clock
; 0000 1F05 // Clock value: Timer2 Stopped
; 0000 1F06 // Mode: Normal top=0xFF
; 0000 1F07 // OC2 output: Disconnected
; 0000 1F08 TCCR2=0x00;
	OUT  0x25,R30
; 0000 1F09 TCNT2=0x00;
	OUT  0x24,R30
; 0000 1F0A OCR2=0x00;
	OUT  0x23,R30
; 0000 1F0B 
; 0000 1F0C // Timer/Counter 3 initialization
; 0000 1F0D // Clock source: System Clock
; 0000 1F0E // Clock value: Timer3 Stopped
; 0000 1F0F // Mode: Normal top=0xFFFF
; 0000 1F10 // OC3A output: Discon.
; 0000 1F11 // OC3B output: Discon.
; 0000 1F12 // OC3C output: Discon.
; 0000 1F13 // Noise Canceler: Off
; 0000 1F14 // Input Capture on Falling Edge
; 0000 1F15 // Timer3 Overflow Interrupt: Off
; 0000 1F16 // Input Capture Interrupt: Off
; 0000 1F17 // Compare A Match Interrupt: Off
; 0000 1F18 // Compare B Match Interrupt: Off
; 0000 1F19 // Compare C Match Interrupt: Off
; 0000 1F1A TCCR3A=0x00;
	STS  139,R30
; 0000 1F1B TCCR3B=0x00;
	STS  138,R30
; 0000 1F1C TCNT3H=0x00;
	STS  137,R30
; 0000 1F1D TCNT3L=0x00;
	STS  136,R30
; 0000 1F1E ICR3H=0x00;
	STS  129,R30
; 0000 1F1F ICR3L=0x00;
	STS  128,R30
; 0000 1F20 OCR3AH=0x00;
	STS  135,R30
; 0000 1F21 OCR3AL=0x00;
	STS  134,R30
; 0000 1F22 OCR3BH=0x00;
	STS  133,R30
; 0000 1F23 OCR3BL=0x00;
	STS  132,R30
; 0000 1F24 OCR3CH=0x00;
	STS  131,R30
; 0000 1F25 OCR3CL=0x00;
	STS  130,R30
; 0000 1F26 
; 0000 1F27 // External Interrupt(s) initialization
; 0000 1F28 // INT0: Off
; 0000 1F29 // INT1: Off
; 0000 1F2A // INT2: Off
; 0000 1F2B // INT3: Off
; 0000 1F2C // INT4: Off
; 0000 1F2D // INT5: Off
; 0000 1F2E // INT6: Off
; 0000 1F2F // INT7: Off
; 0000 1F30 EICRA=0x00;
	STS  106,R30
; 0000 1F31 EICRB=0x00;
	OUT  0x3A,R30
; 0000 1F32 EIMSK=0x00;
	OUT  0x39,R30
; 0000 1F33 
; 0000 1F34 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 1F35 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 1F36 
; 0000 1F37 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 1F38 
; 0000 1F39 
; 0000 1F3A // USART0 initialization
; 0000 1F3B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 1F3C // USART0 Receiver: On
; 0000 1F3D // USART0 Transmitter: On
; 0000 1F3E // USART0 Mode: Asynchronous
; 0000 1F3F // USART0 Baud Rate: 115200
; 0000 1F40 //UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
; 0000 1F41 //UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
; 0000 1F42 //UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
; 0000 1F43 //UBRR0H=0x00;
; 0000 1F44 //UBRR0L=0x08;
; 0000 1F45 
; 0000 1F46 // USART0 initialization
; 0000 1F47 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 1F48 // USART0 Receiver: On
; 0000 1F49 // USART0 Transmitter: On
; 0000 1F4A // USART0 Mode: Asynchronous
; 0000 1F4B // USART0 Baud Rate: 9600
; 0000 1F4C UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 1F4D UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 1F4E UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 1F4F UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 1F50 UBRR0L=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 1F51 
; 0000 1F52 
; 0000 1F53 
; 0000 1F54 
; 0000 1F55 
; 0000 1F56 // USART1 initialization
; 0000 1F57 // USART1 disabled
; 0000 1F58 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 1F59 
; 0000 1F5A // Analog Comparator initialization
; 0000 1F5B // Analog Comparator: Off
; 0000 1F5C // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 1F5D ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 1F5E SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 1F5F 
; 0000 1F60 // ADC initialization
; 0000 1F61 // ADC disabled
; 0000 1F62 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 1F63 
; 0000 1F64 // SPI initialization
; 0000 1F65 // SPI disabled
; 0000 1F66 SPCR=0x00;
	OUT  0xD,R30
; 0000 1F67 
; 0000 1F68 // TWI initialization
; 0000 1F69 // TWI disabled
; 0000 1F6A TWCR=0x00;
	STS  116,R30
; 0000 1F6B 
; 0000 1F6C //ciekawe, tej linijki brakowalo w medalach ,wyczailem w borgu
; 0000 1F6D // I2C Bus initialization
; 0000 1F6E i2c_init();
	CALL _i2c_init
; 0000 1F6F 
; 0000 1F70 // Global enable interrupts
; 0000 1F71 #asm("sei")
	sei
; 0000 1F72 
; 0000 1F73 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x194
; 0000 1F74 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x194
; 0000 1F75 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x194
; 0000 1F76 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x194
; 0000 1F77 
; 0000 1F78 //jak patrze na maszyne to ten po lewej to 1
; 0000 1F79 
; 0000 1F7A putchar(90);  //5A
	CALL SUBOPT_0x2
; 0000 1F7B putchar(165); //A5
; 0000 1F7C putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	CALL SUBOPT_0xD2
; 0000 1F7D putchar(128);  //80
; 0000 1F7E putchar(2);    //02
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
; 0000 1F7F putchar(16);   //10
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
; 0000 1F80 
; 0000 1F81 il_prob_odczytu = 1;    //100
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _il_prob_odczytu,R30
	STS  _il_prob_odczytu+1,R31
; 0000 1F82 start = 0;
	LDI  R30,LOW(0)
	STS  _start,R30
	STS  _start+1,R30
; 0000 1F83 rzad_obrabiany = 1;
	CALL SUBOPT_0x195
; 0000 1F84 jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 1F85 wykonalem_rzedow = 0;
	CALL SUBOPT_0x196
; 0000 1F86 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x197
; 0000 1F87 guzik1_przelaczania_zaciskow = 1;
	SET
	BLD  R2,0
; 0000 1F88 guzik2_przelaczania_zaciskow = 1;
	BLD  R2,1
; 0000 1F89 //PORTE.6 = 1;  //aby byl dostep do zaciskow rzad 1
; 0000 1F8A zmienna_przelaczanie_zaciskow = 1;
	BLD  R2,2
; 0000 1F8B czas_przedmuchu = 183;
	LDI  R30,LOW(183)
	LDI  R31,HIGH(183)
	STS  _czas_przedmuchu,R30
	STS  _czas_przedmuchu+1,R31
; 0000 1F8C predkosc_pion_szczotka = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 1F8D predkosc_pion_krazek = 100;
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 1F8E wejscie_krazka_sciernego_w_pow_boczna_cylindra = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 1F8F predkosc_ruchow_po_okregu_krazek_scierny = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 1F90 czas_druciaka_na_gorze = 100;  //1 sekundy dla druciaka na gorze aby dolek zrobil git (kiedyS), zmieniam na 3s
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _czas_druciaka_na_gorze,R30
	STS  _czas_druciaka_na_gorze+1,R31
; 0000 1F91 czas_zatrzymania_na_dole = 120;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	STS  _czas_zatrzymania_na_dole,R30
	STS  _czas_zatrzymania_na_dole+1,R31
; 0000 1F92 srednica_wew_korpusu_cyklowa = 0;
	LDI  R30,LOW(0)
	STS  _srednica_wew_korpusu_cyklowa,R30
	STS  _srednica_wew_korpusu_cyklowa+1,R30
; 0000 1F93 sek21_wylaczenie_szlif = 200;    //2*63, 63 nie
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	STS  _sek21_wylaczenie_szlif,R30
	STS  _sek21_wylaczenie_szlif+1,R31
; 0000 1F94 
; 0000 1F95 adr1 = 80;  //rzad 1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STS  _adr1,R30
	STS  _adr1+1,R31
; 0000 1F96 adr2 = 0;   //
	LDI  R30,LOW(0)
	STS  _adr2,R30
	STS  _adr2+1,R30
; 0000 1F97 adr3 = 64;  //rzad 2
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STS  _adr3,R30
	STS  _adr3+1,R31
; 0000 1F98 adr4 = 0;
	LDI  R30,LOW(0)
	STS  _adr4,R30
	STS  _adr4+1,R30
; 0000 1F99 
; 0000 1F9A //na sekunde
; 0000 1F9B //wartosci_wstepne_wgrac_tylko_raz(0);
; 0000 1F9C //
; 0000 1F9D //while(1)
; 0000 1F9E //{
; 0000 1F9F //}
; 0000 1FA0 
; 0000 1FA1 wartosci_wstepne_panelu();
	CALL _wartosci_wstepne_panelu
; 0000 1FA2 odpytaj_parametry_panelu();
	CALL _odpytaj_parametry_panelu
; 0000 1FA3 
; 0000 1FA4 wypozycjonuj_napedy_minimalistyczna();
	CALL _wypozycjonuj_napedy_minimalistyczna
; 0000 1FA5 sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 1FA6 
; 0000 1FA7 //SPRAWDZAM CO SIE DZIEJE CO CYKL, TO LICZENIE SZCZOTKI I KRAZKA
; 0000 1FA8 
; 0000 1FA9 while (1)
_0x4A0:
; 0000 1FAA       {
; 0000 1FAB         //to wylaczam tylko do testow w switniakch, wewnatrz tego wylaczam 4 pierwsze linijki
; 0000 1FAC       odpytaj_parametry_panelu();
	CALL _odpytaj_parametry_panelu
; 0000 1FAD       ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1FAE       przerzucanie_dociskow();
	CALL _przerzucanie_dociskow
; 0000 1FAF       kontrola_zoltego_swiatla();
	CALL _kontrola_zoltego_swiatla
; 0000 1FB0       wymiana_szczotki_i_krazka();
	CALL _wymiana_szczotki_i_krazka
; 0000 1FB1       zaktualizuj_parametry_panelu();
	CALL _zaktualizuj_parametry_panelu
; 0000 1FB2       obsluga_trybu_administratora();
	CALL _obsluga_trybu_administratora
; 0000 1FB3       test_geometryczny();
	CALL _test_geometryczny
; 0000 1FB4       sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 1FB5 
; 0000 1FB6       //zapis_probny_test();
; 0000 1FB7 
; 0000 1FB8 
; 0000 1FB9 
; 0000 1FBA       while((start == 1 & il_zaciskow_rzad_1 > 1 & il_zaciskow_rzad_2 != 1 & macierz_zaciskow[1]!=0  & (macierz_zaciskow[2]!=0 |  il_zaciskow_rzad_2 == 0)) | jestem_w_trakcie_czyszczenia_calosci == 1)
_0x4A3:
	CALL SUBOPT_0xF5
	CALL SUBOPT_0x84
	MOV  R0,R30
	CALL SUBOPT_0x109
	CALL SUBOPT_0x124
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	AND  R0,R30
	CALL SUBOPT_0x10A
	MOV  R1,R30
	CALL SUBOPT_0x126
	MOV  R0,R30
	CALL SUBOPT_0x124
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	OR   R30,R0
	AND  R30,R1
	MOV  R0,R30
	LDS  R26,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R27,_jestem_w_trakcie_czyszczenia_calosci+1
	CALL SUBOPT_0x84
	OR   R30,R0
	BRNE PC+3
	JMP _0x4A5
; 0000 1FBB             {
; 0000 1FBC             switch (cykl_glowny)
	LDS  R30,_cykl_glowny
	LDS  R31,_cykl_glowny+1
; 0000 1FBD             {
; 0000 1FBE             case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x4A9
; 0000 1FBF 
; 0000 1FC0 
; 0000 1FC1                     PORTB.6 = 1;   ////zielona lampka
	SBI  0x18,6
; 0000 1FC2                     if(jestem_w_trakcie_czyszczenia_calosci == 0)
	LDS  R30,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R31,_jestem_w_trakcie_czyszczenia_calosci+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x4AC
; 0000 1FC3                         {
; 0000 1FC4                         //PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
; 0000 1FC5 
; 0000 1FC6                         srednica_wew_korpusu_cyklowa = srednica_wew_korpusu;
	LDS  R30,_srednica_wew_korpusu
	LDS  R31,_srednica_wew_korpusu+1
	STS  _srednica_wew_korpusu_cyklowa,R30
	STS  _srednica_wew_korpusu_cyklowa+1,R31
; 0000 1FC7 
; 0000 1FC8                         wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA8
; 0000 1FC9                         wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA8
; 0000 1FCA 
; 0000 1FCB                         il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0000 1FCC                         il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
; 0000 1FCD 
; 0000 1FCE 
; 0000 1FCF                         szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64) - 1;  //wykonano zaciskow rzad1
	CALL SUBOPT_0x17
	SBIW R30,1
	MOVW R4,R30
; 0000 1FD0 
; 0000 1FD1                         tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1D
	MOVW R10,R30
; 0000 1FD2 
; 0000 1FD3                         if(tryb_pracy_szczotki_drucianej == 1)
	CALL SUBOPT_0x7D
	BRNE _0x4AD
; 0000 1FD4                             szczotka_druciana_ilosc_cykli = 1; //zmieniam bo teraz inny ruch szczotki drucianej, jeden schodek na dole
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 1FD5                         if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)
_0x4AD:
	CALL SUBOPT_0x80
	BREQ _0x4AE
; 0000 1FD6                             czas_druciaka_na_gorze = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _czas_druciaka_na_gorze,R30
	STS  _czas_druciaka_na_gorze+1,R31
; 0000 1FD7 
; 0000 1FD8                                                 //2090
; 0000 1FD9                         krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);  //wykonano zaciskow rzad1
_0x4AE:
	CALL SUBOPT_0x30
	CALL SUBOPT_0x20
	MOVW R6,R30
; 0000 1FDA                                                     //3000
; 0000 1FDB 
; 0000 1FDC                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x9
	CALL _odczytaj_parametr
	MOVW R8,R30
; 0000 1FDD 
; 0000 1FDE                         if(krazek_scierny_cykl_po_okregu_ilosc == 0)
	MOV  R0,R8
	OR   R0,R9
	BRNE _0x4AF
; 0000 1FDF                             {
; 0000 1FE0                             krazek_scierny_ilosc_cykli--;
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
; 0000 1FE1                             }
; 0000 1FE2 
; 0000 1FE3                         predkosc_pion_szczotka = odczytaj_parametr(32,80);
_0x4AF:
	CALL SUBOPT_0x30
	CALL SUBOPT_0x26
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 1FE4                                                 //2060
; 0000 1FE5                         predkosc_pion_krazek = odczytaj_parametr(32,96);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x23
	CALL _odczytaj_parametr
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 1FE6 
; 0000 1FE7                         wejscie_krazka_sciernego_w_pow_boczna_cylindra = odczytaj_parametr(48,16);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xA
	CALL _odczytaj_parametr
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 1FE8 
; 0000 1FE9                         predkosc_ruchow_po_okregu_krazek_scierny = odczytaj_parametr(32,112);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x1D
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 1FEA 
; 0000 1FEB                         srednica_krazka_sciernego = odczytaj_parametr(48,112);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x2A
; 0000 1FEC 
; 0000 1FED                         ruch_haos = odczytaj_parametr(48,144);
	CALL SUBOPT_0x20
	STS  _ruch_haos,R30
	STS  _ruch_haos+1,R31
; 0000 1FEE 
; 0000 1FEF                         statystyka = odczytaj_parametr(128,64);
	CALL SUBOPT_0xB6
	CALL SUBOPT_0x17
	STS  _statystyka,R30
	STS  _statystyka+1,R31
; 0000 1FF0 
; 0000 1FF1                         if(il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0)
	CALL SUBOPT_0x124
	CALL SUBOPT_0x198
	CALL SUBOPT_0x126
	AND  R30,R0
	BREQ _0x4B0
; 0000 1FF2                               il_zaciskow_rzad_2 = il_zaciskow_rzad_2;
	CALL SUBOPT_0x199
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
; 0000 1FF3                         else
	RJMP _0x4B1
_0x4B0:
; 0000 1FF4                               il_zaciskow_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R30
; 0000 1FF5 
; 0000 1FF6                         wybor_linijek_sterownikow(1);  //rzad 1
_0x4B1:
	CALL SUBOPT_0xC2
	CALL _wybor_linijek_sterownikow
; 0000 1FF7                         }
; 0000 1FF8 
; 0000 1FF9                     jestem_w_trakcie_czyszczenia_calosci = 1;
_0x4AC:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R31
; 0000 1FFA 
; 0000 1FFB                     if(rzad_obrabiany == 1)
	CALL SUBOPT_0x9E
	SBIW R26,1
	BRNE _0x4B2
; 0000 1FFC                     {
; 0000 1FFD                     PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
	CBI  0x3,6
; 0000 1FFE                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x4B5
; 0000 1FFF                         cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0x128
	CALL SUBOPT_0x113
; 0000 2000                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x4B5:
	CALL SUBOPT_0x114
	SBIW R26,5
	BRGE _0x4B6
; 0000 2001                         cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x9
	CALL SUBOPT_0x116
; 0000 2002                     }
_0x4B6:
; 0000 2003 
; 0000 2004                     if(rzad_obrabiany == 2)
_0x4B2:
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x4B7
; 0000 2005                     {
; 0000 2006                     ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 2007                     //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2 - na razie nie bo nie ma jeszcze oslon
; 0000 2008 
; 0000 2009                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x4B8
; 0000 200A                         cykl_sterownik_1 = sterownik_1_praca(0x008);
	CALL SUBOPT_0x115
	CALL SUBOPT_0x113
; 0000 200B                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x4B8:
	CALL SUBOPT_0x114
	SBIW R26,5
	BRGE _0x4B9
; 0000 200C                         cykl_sterownik_2 = sterownik_2_praca(0x001);       //ster 2 pod pin pozy rzad 2
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x116
; 0000 200D                     }
_0x4B9:
; 0000 200E 
; 0000 200F 
; 0000 2010                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x4B7:
	CALL SUBOPT_0x117
	BREQ _0x4BA
; 0000 2011                         {
; 0000 2012 
; 0000 2013                           if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x4BB
; 0000 2014                             {
; 0000 2015                             while(PORTE.6 == 0)
_0x4BC:
	SBIC 0x3,6
	RJMP _0x4BE
; 0000 2016                                 przerzucanie_dociskow();
	CALL _przerzucanie_dociskow
	RJMP _0x4BC
_0x4BE:
; 0000 2017 delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	CALL SUBOPT_0xC0
; 0000 2018                             }
; 0000 2019 
; 0000 201A                         delay_ms(2000);  //aby zdazyl przelozyc
_0x4BB:
	CALL SUBOPT_0x194
; 0000 201B                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 201C                         cykl_sterownik_2 = 0;
; 0000 201D                         cykl_sterownik_3 = 0;
; 0000 201E                         cykl_sterownik_4 = 0;
; 0000 201F                         cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x197
; 0000 2020                         koniec_rzedu_10 = 0;
	CALL SUBOPT_0x19A
; 0000 2021                         cykl_glowny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x19B
; 0000 2022                         }
; 0000 2023 
; 0000 2024             break;
_0x4BA:
	RJMP _0x4A8
; 0000 2025 
; 0000 2026 
; 0000 2027 
; 0000 2028             case 1:
_0x4A9:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4BF
; 0000 2029 
; 0000 202A 
; 0000 202B                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 1)
	CALL SUBOPT_0x19C
	CALL SUBOPT_0x19D
	AND  R30,R0
	BREQ _0x4C0
; 0000 202C                           {          //ster 1 nic
; 0000 202D                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 202E                           cykl_sterownik_2 = sterownik_2_praca(a[0]);        //ster 2 pod zacisk
	CALL SUBOPT_0x119
	CALL SUBOPT_0x116
; 0000 202F                           }                                                    //ster 4 na pozycje miedzy rzedzami
; 0000 2030 
; 0000 2031                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 2)
_0x4C0:
	CALL SUBOPT_0x19C
	CALL SUBOPT_0xA0
	AND  R30,R0
	BREQ _0x4C3
; 0000 2032                         {
; 0000 2033                         //cykl_sterownik_2 = sterownik_2_praca(0x5B,0);
; 0000 2034                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 2035                           ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 2036                           cykl_sterownik_2 = sterownik_2_praca(a[1]);
	CALL SUBOPT_0x129
	CALL SUBOPT_0x116
; 0000 2037                          }
; 0000 2038                      if(cykl_sterownik_4 < 5 & cykl_sterownik_2 == 5)
_0x4C3:
	CALL SUBOPT_0x14E
	CALL __LTW12
	CALL SUBOPT_0x19E
	AND  R30,R0
	BREQ _0x4C6
; 0000 2039                        // cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);
; 0000 203A                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 203B 
; 0000 203C                       if(cykl_sterownik_2 == 5 & cykl_sterownik_4 == 5)
_0x4C6:
	CALL SUBOPT_0x114
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x14E
	CALL __EQW12
	AND  R30,R0
	BREQ _0x4C7
; 0000 203D                         {
; 0000 203E                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 203F                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x19F
; 0000 2040                         cykl_sterownik_4 = 0;
; 0000 2041                         szczotka_druc_cykl = 0;
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
; 0000 2042                         cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x19B
; 0000 2043                         }
; 0000 2044 
; 0000 2045 
; 0000 2046             break;
_0x4C7:
	RJMP _0x4A8
; 0000 2047 
; 0000 2048 
; 0000 2049             case 2:
_0x4BF:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4C8
; 0000 204A                     if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x4C9
; 0000 204B                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 204C 
; 0000 204D                     if(cykl_sterownik_4 < 5)
_0x4C9:
	CALL SUBOPT_0x10E
	SBIW R26,5
	BRGE _0x4CA
; 0000 204E                           cykl_sterownik_4 = sterownik_4_praca(a[2],1);
	CALL SUBOPT_0x81
	CALL SUBOPT_0x178
	CALL SUBOPT_0x10F
; 0000 204F                     if(cykl_sterownik_4 == 5)
_0x4CA:
	CALL SUBOPT_0x10E
	SBIW R26,5
	BRNE _0x4CB
; 0000 2050                         {
; 0000 2051                         PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 2052                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 2053 
; 0000 2054                         //if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
; 0000 2055                         //     cykl_sterownik_4 = 5;
; 0000 2056 
; 0000 2057                         sek13 = 0;
	CALL SUBOPT_0x1A0
; 0000 2058                         cykl_glowny = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x19B
; 0000 2059                         }
; 0000 205A             break;
_0x4CB:
	RJMP _0x4A8
; 0000 205B 
; 0000 205C 
; 0000 205D             case 3:
_0x4C8:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4CE
; 0000 205E 
; 0000 205F                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x4CF
; 0000 2060                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 2061 
; 0000 2062                     if(cykl_sterownik_4 < 5 & sek13 > czas_druciaka_na_gorze & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x4CF:
	CALL SUBOPT_0x14E
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
	CALL SUBOPT_0x1A1
	BREQ _0x4D0
; 0000 2063                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x152
	CALL SUBOPT_0x10F
; 0000 2064 
; 0000 2065                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x4D0:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x153
	CALL __LTW12
	AND  R30,R0
	BREQ _0x4D1
; 0000 2066                         {
; 0000 2067                         szczotka_druc_cykl++;
	CALL SUBOPT_0x179
; 0000 2068                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 2069 
; 0000 206A                         if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
	MOVW R26,R10
	CALL SUBOPT_0xF4
	CALL SUBOPT_0x1A2
	MOVW R30,R4
	CALL SUBOPT_0x177
	CALL __EQW12
	AND  R30,R0
	BREQ _0x4D2
; 0000 206B                             cykl_sterownik_4 = 5;
	CALL SUBOPT_0x13C
; 0000 206C 
; 0000 206D 
; 0000 206E 
; 0000 206F                         if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x4D2:
	MOVW R26,R10
	CALL SUBOPT_0xF4
	CALL SUBOPT_0x1A2
	CALL SUBOPT_0x1A1
	BREQ _0x4D3
; 0000 2070                                {
; 0000 2071                                cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x19B
; 0000 2072                                if(tryb_pracy_szczotki_drucianej == 2)
	CALL SUBOPT_0x176
	BRNE _0x4D4
; 0000 2073                                    PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 2074                                }
_0x4D4:
; 0000 2075                         }
_0x4D3:
; 0000 2076 
; 0000 2077                     if(cykl_sterownik_4 < 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & tryb_pracy_szczotki_drucianej == 1)
_0x4D1:
	CALL SUBOPT_0x14E
	CALL __LTW12
	MOV  R0,R30
	MOVW R30,R4
	CALL SUBOPT_0x177
	CALL __EQW12
	AND  R0,R30
	MOVW R26,R10
	CALL SUBOPT_0x84
	AND  R30,R0
	BREQ _0x4D7
; 0000 2078                          cykl_sterownik_4 = sterownik_4_praca(0x03,0); //INV
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x152
	CALL SUBOPT_0x10F
; 0000 2079 
; 0000 207A 
; 0000 207B 
; 0000 207C                         if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
_0x4D7:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x153
	CALL __EQW12
	AND  R30,R0
	BREQ _0x4D8
; 0000 207D                             {
; 0000 207E                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 207F                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 2080                             cykl_glowny = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x19B
; 0000 2081                             }
; 0000 2082 
; 0000 2083             break;
_0x4D8:
	RJMP _0x4A8
; 0000 2084 
; 0000 2085             case 4:
_0x4CE:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4DB
; 0000 2086 
; 0000 2087 
; 0000 2088                       if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x4DC
; 0000 2089                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 208A 
; 0000 208B                      if(cykl_sterownik_4 < 5)
_0x4DC:
	CALL SUBOPT_0x10E
	SBIW R26,5
	BRGE _0x4DD
; 0000 208C                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 208D 
; 0000 208E                      if(cykl_sterownik_4 == 5)
_0x4DD:
	CALL SUBOPT_0x10E
	SBIW R26,5
	BRNE _0x4DE
; 0000 208F                         {
; 0000 2090                         PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 2091                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 2092                         ruch_zlozony = 0;
	LDI  R30,LOW(0)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R30
; 0000 2093                         cykl_glowny = 5;
	CALL SUBOPT_0x1A3
; 0000 2094                         }
; 0000 2095 
; 0000 2096             break;
_0x4DE:
	RJMP _0x4A8
; 0000 2097 
; 0000 2098             case 5:
_0x4DB:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4E1
; 0000 2099 
; 0000 209A 
; 0000 209B                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 1)
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x1A4
	CALL SUBOPT_0x19D
	AND  R30,R0
	BREQ _0x4E2
; 0000 209C                         cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x113
; 0000 209D                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 2)
_0x4E2:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x1A4
	CALL SUBOPT_0xA0
	AND  R30,R0
	BREQ _0x4E3
; 0000 209E                         cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x113
; 0000 209F 
; 0000 20A0                      if(rzad_obrabiany == 2)
_0x4E3:
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x4E4
; 0000 20A1                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 20A2 
; 0000 20A3                     if(cykl_sterownik_1 == 5 & ruch_zlozony == 0)
_0x4E4:
	CALL SUBOPT_0x13D
	CALL __EQW12
	CALL SUBOPT_0x1A5
	CALL SUBOPT_0xEA
	BREQ _0x4E5
; 0000 20A4                         {
; 0000 20A5                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 20A6                         ruch_zlozony = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 20A7                         }
; 0000 20A8 
; 0000 20A9                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 1)
_0x4E5:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x1A6
	CALL SUBOPT_0x84
	AND  R0,R30
	CALL SUBOPT_0x19D
	AND  R30,R0
	BREQ _0x4E6
; 0000 20AA                         cykl_sterownik_1 = sterownik_1_praca(a[0]);
	CALL SUBOPT_0x119
	CALL SUBOPT_0x113
; 0000 20AB                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 2)
_0x4E6:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x1A6
	CALL SUBOPT_0x84
	AND  R0,R30
	CALL SUBOPT_0xA0
	AND  R30,R0
	BREQ _0x4E7
; 0000 20AC                           cykl_sterownik_1 = sterownik_1_praca(a[1]);
	CALL SUBOPT_0x129
	CALL SUBOPT_0x113
; 0000 20AD 
; 0000 20AE 
; 0000 20AF                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 2)
_0x4E7:
	CALL SUBOPT_0x13D
	CALL SUBOPT_0x1A6
	CALL SUBOPT_0xF4
	AND  R30,R0
	BREQ _0x4E8
; 0000 20B0                         cykl_sterownik_1 = sterownik_1_praca(0x003);     ////////////////////////////////////////////////////////////
	CALL SUBOPT_0x123
; 0000 20B1 
; 0000 20B2                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 0)                                //ster 1 do pierwszego dolka
_0x4E8:
	CALL SUBOPT_0x19C
	CALL SUBOPT_0x18E
	BREQ _0x4E9
; 0000 20B3                         cykl_sterownik_2 = sterownik_2_praca(0x003);       //ster 2 pod nastpeny dolek
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x1A7
; 0000 20B4 
; 0000 20B5 
; 0000 20B6                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 1)
_0x4E9:
	CALL SUBOPT_0x19C
	CALL SUBOPT_0x1A8
	AND  R0,R30
	CALL SUBOPT_0x19D
	AND  R30,R0
	BREQ _0x4EA
; 0000 20B7                         cykl_sterownik_2 = sterownik_2_praca(0x008);      //ster 2 do samego tylu
	CALL SUBOPT_0x115
	CALL SUBOPT_0x116
; 0000 20B8                      if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 2)
_0x4EA:
	CALL SUBOPT_0x19C
	CALL SUBOPT_0x1A8
	AND  R0,R30
	CALL SUBOPT_0xA0
	AND  R30,R0
	BREQ _0x4EB
; 0000 20B9                         cykl_sterownik_2 = sterownik_2_praca(0x009);      //ster 2 do samego tylu
	CALL SUBOPT_0x128
	CALL SUBOPT_0x116
; 0000 20BA 
; 0000 20BB                     if((cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5 & ruch_zlozony == 1) | (cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5) & ruch_zlozony == 2)
_0x4EB:
	CALL SUBOPT_0x13D
	CALL __EQW12
	CALL SUBOPT_0x19E
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0x84
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0x13D
	CALL __EQW12
	CALL SUBOPT_0x19E
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0xF4
	AND  R30,R0
	OR   R30,R1
	BREQ _0x4EC
; 0000 20BC                         {
; 0000 20BD                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 20BE                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x19F
; 0000 20BF                         cykl_sterownik_4 = 0;
; 0000 20C0                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 20C1                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
	SBI  0x3,3
; 0000 20C2                         cykl_glowny = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x19B
; 0000 20C3                         }
; 0000 20C4 
; 0000 20C5             break;
_0x4EC:
	RJMP _0x4A8
; 0000 20C6 
; 0000 20C7             case 6:
_0x4E1:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4EF
; 0000 20C8 
; 0000 20C9                     if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x10C
	SBIW R26,5
	BRGE _0x4F0
; 0000 20CA                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs //krazek scierny do gory
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x11A
; 0000 20CB 
; 0000 20CC                     if(koniec_rzedu_10 == 1)
_0x4F0:
	CALL SUBOPT_0x13B
	BRNE _0x4F1
; 0000 20CD                         cykl_sterownik_4 = 5;
	CALL SUBOPT_0x13C
; 0000 20CE 
; 0000 20CF                     if(cykl_sterownik_4 < 5)
_0x4F1:
	CALL SUBOPT_0x10E
	SBIW R26,5
	BRGE _0x4F2
; 0000 20D0                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);    //ABS          //druciak do gory
	CALL SUBOPT_0x81
	CALL SUBOPT_0x178
	CALL SUBOPT_0x10F
; 0000 20D1 
; 0000 20D2                      if(rzad_obrabiany == 2)
_0x4F2:
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x4F3
; 0000 20D3                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 20D4 
; 0000 20D5 
; 0000 20D6                     if(cykl_sterownik_4 == 5 & cykl_sterownik_3 == 5)
_0x4F3:
	CALL SUBOPT_0x14E
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x15A
	CALL __EQW12
	AND  R30,R0
	BREQ _0x4F4
; 0000 20D7                         {
; 0000 20D8                         if((cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1 & rzad_obrabiany == 1) | (cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1 & rzad_obrabiany == 2))
	CALL SUBOPT_0x1A9
	MOV  R0,R30
	CALL SUBOPT_0x19D
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0x1AA
	MOV  R0,R30
	CALL SUBOPT_0xA0
	AND  R30,R0
	OR   R30,R1
	BREQ _0x4F5
; 0000 20D9                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 20DA 
; 0000 20DB                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
_0x4F5:
	SBI  0x3,3
; 0000 20DC                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x111
; 0000 20DD                         cykl_sterownik_4 = 0;
; 0000 20DE                         if(cykl_ilosc_zaciskow > 0)
	CALL SUBOPT_0x1AB
	CALL __CPW02
	BRGE _0x4FA
; 0000 20DF                                 {
; 0000 20E0                                 sek12 = 0;    //do przedmuchu
	CALL SUBOPT_0x1AC
; 0000 20E1                                 PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x1AD
; 0000 20E2                                 PORTF = PORT_F.byte;
; 0000 20E3                                 }
; 0000 20E4                         sek13 = 0;
_0x4FA:
	CALL SUBOPT_0x1A0
; 0000 20E5                         cykl_glowny = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x19B
; 0000 20E6                         }
; 0000 20E7 
; 0000 20E8            break;
_0x4F4:
	RJMP _0x4A8
; 0000 20E9 
; 0000 20EA 
; 0000 20EB            case 7:
_0x4EF:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4FB
; 0000 20EC 
; 0000 20ED 
; 0000 20EE                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x4FC
; 0000 20EF                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 20F0 
; 0000 20F1                         wykonalem_komplet_okregow = 0;
_0x4FC:
	CALL SUBOPT_0x18C
; 0000 20F2                         szczotka_druc_cykl = 0;
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
; 0000 20F3                         krazek_scierny_cykl_po_okregu = 0;
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
; 0000 20F4                         krazek_scierny_cykl = 0;
	STS  _krazek_scierny_cykl,R30
	STS  _krazek_scierny_cykl+1,R30
; 0000 20F5                         powrot_przedwczesny_krazek_scierny = 0;
	CALL SUBOPT_0x169
; 0000 20F6                         powrot_przedwczesny_druciak = 0;
	CALL SUBOPT_0x16E
; 0000 20F7 
; 0000 20F8                         abs_ster3 = 0;
	CALL SUBOPT_0x162
; 0000 20F9                         abs_ster4 = 0;
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
; 0000 20FA                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 20FB                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0x19F
; 0000 20FC                         cykl_sterownik_4 = 0;
; 0000 20FD                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 20FE 
; 0000 20FF                              if(krazek_scierny_cykl_po_okregu_ilosc > 0)
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BRGE _0x4FD
; 0000 2100                                 {
; 0000 2101                                 if(ruch_haos == 0 & tryb_pracy_szczotki_drucianej == 1)  //spr.
	CALL SUBOPT_0x83
	CALL SUBOPT_0x82
	MOVW R26,R10
	CALL SUBOPT_0x84
	AND  R30,R0
	BREQ _0x4FE
; 0000 2102                                     cykl_glowny = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x19B
; 0000 2103 
; 0000 2104                                 if(ruch_haos == 0 & (tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3))//spr.
_0x4FE:
	CALL SUBOPT_0x83
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	MOV  R1,R30
	CALL SUBOPT_0x80
	AND  R30,R1
	BREQ _0x4FF
; 0000 2105                                     cykl_glowny = 88;
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	CALL SUBOPT_0x19B
; 0000 2106 
; 0000 2107                                 if(ruch_haos == 1 & tryb_pracy_szczotki_drucianej == 1) //spr.
_0x4FF:
	CALL SUBOPT_0x83
	CALL SUBOPT_0x84
	MOV  R0,R30
	MOVW R26,R10
	CALL SUBOPT_0x84
	AND  R30,R0
	BREQ _0x500
; 0000 2108                                     cykl_glowny = 887;
	LDI  R30,LOW(887)
	LDI  R31,HIGH(887)
	CALL SUBOPT_0x19B
; 0000 2109 
; 0000 210A                                 if(ruch_haos == 1 & (tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3))// spr.
_0x500:
	CALL SUBOPT_0x83
	CALL SUBOPT_0x84
	MOV  R1,R30
	CALL SUBOPT_0x80
	AND  R30,R1
	BREQ _0x501
; 0000 210B                                     cykl_glowny = 888;
	LDI  R30,LOW(888)
	LDI  R31,HIGH(888)
	CALL SUBOPT_0x19B
; 0000 210C                                 }
_0x501:
; 0000 210D                              else
	RJMP _0x502
_0x4FD:
; 0000 210E                                 {
; 0000 210F                                 if(tryb_pracy_szczotki_drucianej == 1)  //spr
	CALL SUBOPT_0x7D
	BRNE _0x503
; 0000 2110                                     cykl_glowny = 997;
	LDI  R30,LOW(997)
	LDI  R31,HIGH(997)
	CALL SUBOPT_0x19B
; 0000 2111                                 if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)  //spr
_0x503:
	CALL SUBOPT_0x80
	BREQ _0x504
; 0000 2112                                     cykl_glowny = 998;
	LDI  R30,LOW(998)
	LDI  R31,HIGH(998)
	CALL SUBOPT_0x19B
; 0000 2113 
; 0000 2114                                 }
_0x504:
_0x502:
; 0000 2115 
; 0000 2116            break;
	RJMP _0x4A8
; 0000 2117 
; 0000 2118 
; 0000 2119            case 887:
_0x4FB:
	CPI  R30,LOW(0x377)
	LDI  R26,HIGH(0x377)
	CPC  R31,R26
	BRNE _0x505
; 0000 211A                     przypadek887();
	CALL _przypadek887
; 0000 211B            break;
	RJMP _0x4A8
; 0000 211C 
; 0000 211D             case 888:
_0x505:
	CPI  R30,LOW(0x378)
	LDI  R26,HIGH(0x378)
	CPC  R31,R26
	BRNE _0x506
; 0000 211E                    przypadek888();
	CALL _przypadek888
; 0000 211F            break;
	RJMP _0x4A8
; 0000 2120 
; 0000 2121            case 997:
_0x506:
	CPI  R30,LOW(0x3E5)
	LDI  R26,HIGH(0x3E5)
	CPC  R31,R26
	BRNE _0x507
; 0000 2122                    przypadek997();
	CALL _przypadek997
; 0000 2123            break;
	RJMP _0x4A8
; 0000 2124 
; 0000 2125            case 998:
_0x507:
	CPI  R30,LOW(0x3E6)
	LDI  R26,HIGH(0x3E6)
	CPC  R31,R26
	BRNE _0x508
; 0000 2126                     przypadek998();
	CALL _przypadek998
; 0000 2127            break;
	RJMP _0x4A8
; 0000 2128 
; 0000 2129             case 8:
_0x508:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x509
; 0000 212A                     przypadek8();
	RCALL _przypadek8
; 0000 212B             break;
	RJMP _0x4A8
; 0000 212C 
; 0000 212D             case 88:
_0x509:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x50A
; 0000 212E                     przypadek88();
	RCALL _przypadek88
; 0000 212F             break;
	RJMP _0x4A8
; 0000 2130 
; 0000 2131 
; 0000 2132 
; 0000 2133             case 9:                                          //cykl 3 == 5
_0x50A:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x50B
; 0000 2134 
; 0000 2135                          if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x139
	BRGE _0x50C
; 0000 2136                         {
; 0000 2137                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0x13A
; 0000 2138                         PORTF = PORT_F.byte;
; 0000 2139                         }
; 0000 213A 
; 0000 213B 
; 0000 213C 
; 0000 213D                          if(rzad_obrabiany == 1)
_0x50C:
	CALL SUBOPT_0x9E
	SBIW R26,1
	BRNE _0x50D
; 0000 213E                          {
; 0000 213F                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)    //////
	CALL SUBOPT_0x15A
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x1A9
	AND  R30,R0
	BREQ _0x50E
; 0000 2140                               {
; 0000 2141                               //if(sek21 > sek21_wylaczenie_szlif)
; 0000 2142                               //  PORTE.3 = 0;  //szlifierka 2 (krazek scierny) - wylaczenie bo ocieralo
; 0000 2143                               cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x10D
; 0000 2144                               }
; 0000 2145 
; 0000 2146                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_1 - 2)
_0x50E:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x1AE
	CALL SUBOPT_0x1AF
	BREQ _0x50F
; 0000 2147                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 2148 
; 0000 2149 
; 0000 214A                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)       //2 marca 2019 wykomentowuje ////////
_0x50F:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x1AE
	CALL SUBOPT_0x1B0
	BREQ _0x510
; 0000 214B                             {
; 0000 214C                             //if(sek21 > sek21_wylaczenie_szlif)
; 0000 214D                             //    PORTE.3 = 0;  //szlifierka 2 (krazek scierny) - wylaczenie bo ocieralo
; 0000 214E                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10D
; 0000 214F                             }
; 0000 2150 
; 0000 2151                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_1 - 2)
_0x510:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x1AE
	CALL SUBOPT_0x1B1
	BREQ _0x511
; 0000 2152                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 2153 
; 0000 2154                           }
_0x511:
; 0000 2155 
; 0000 2156 
; 0000 2157                          if(rzad_obrabiany == 2)
_0x50D:
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x512
; 0000 2158                          {
; 0000 2159                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
	CALL SUBOPT_0x15A
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x1AA
	AND  R30,R0
	BREQ _0x513
; 0000 215A                             {
; 0000 215B                             //if(sek21 > sek21_wylaczenie_szlif)
; 0000 215C                             //    PORTE.3 = 0;  //szlifierka 2 (krazek scierny) - wylaczenie bo ocieralo
; 0000 215D                             cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x10D
; 0000 215E                             }
; 0000 215F                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_2 - 2)
_0x513:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x1B2
	CALL SUBOPT_0x1AF
	BREQ _0x514
; 0000 2160                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xC2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 2161 
; 0000 2162                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x514:
	CALL SUBOPT_0x15A
	CALL SUBOPT_0x1B2
	CALL SUBOPT_0x1B0
	BREQ _0x515
; 0000 2163                             {
; 0000 2164                             //if(sek21 > sek21_wylaczenie_szlif)
; 0000 2165                             //    PORTE.3 = 0;  //szlifierka 2 (krazek scierny) - wylaczenie bo ocieralo
; 0000 2166                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10D
; 0000 2167                             }
; 0000 2168                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_2 - 2)
_0x515:
	CALL SUBOPT_0x14E
	CALL SUBOPT_0x1B2
	CALL SUBOPT_0x1B1
	BREQ _0x516
; 0000 2169                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10F
; 0000 216A 
; 0000 216B                            if(rzad_obrabiany == 2)
_0x516:
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x517
; 0000 216C                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 216D 
; 0000 216E                           }
_0x517:
; 0000 216F 
; 0000 2170 
; 0000 2171                           if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 & sek12 > czas_przedmuchu)
_0x512:
	CALL SUBOPT_0x15A
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x14E
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
	BREQ _0x518
; 0000 2172                             {
; 0000 2173                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 2174                             PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 2175                             //PORTB.6 = 0;  //wylacz przedmuchy
; 0000 2176                             PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0x13A
; 0000 2177                             PORTF = PORT_F.byte;
; 0000 2178                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0x156
; 0000 2179                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0x15F
; 0000 217A                             cykl_ilosc_zaciskow++;
	LDI  R26,LOW(_cykl_ilosc_zaciskow)
	LDI  R27,HIGH(_cykl_ilosc_zaciskow)
	CALL SUBOPT_0x1B3
; 0000 217B                             ruch_zlozony = 2;                       //il_zaciskow_rzad_1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 217C                             cykl_glowny = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x19B
; 0000 217D                             }
; 0000 217E 
; 0000 217F 
; 0000 2180             break;
_0x518:
	RJMP _0x4A8
; 0000 2181 
; 0000 2182 
; 0000 2183 
; 0000 2184             case 10:
_0x50B:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x51D
; 0000 2185 
; 0000 2186                                                //wywali ten warunek jak zadziala
; 0000 2187                      if(rzad_obrabiany == 1 & cykl_glowny != 0)
	CALL SUBOPT_0x19D
	CALL SUBOPT_0x1B4
	BRNE PC+3
	JMP _0x51E
; 0000 2188                             {
; 0000 2189                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,96);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x17C
	CALL SUBOPT_0x152
	CALL SUBOPT_0x23
	CALL _wartosc_parametru_panelu
; 0000 218A                             if(srednica_wew_korpusu_cyklowa == 38 | srednica_wew_korpusu_cyklowa == 41 | srednica_wew_korpusu_cyklowa == 43)
	CALL SUBOPT_0xAE
	MOV  R0,R30
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xB0
	BREQ _0x51F
; 0000 218B                             {
; 0000 218C                             czas_pracy_szczotki_drucianej_h_17++;
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h_17)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h_17)
	CALL SUBOPT_0x1B3
; 0000 218D                             if(czas_pracy_szczotki_drucianej_h_17 > 250)
	CALL SUBOPT_0x12A
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x520
; 0000 218E                                 czas_pracy_szczotki_drucianej_h_17 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x21
; 0000 218F                             }
_0x520:
; 0000 2190 
; 0000 2191                             if(srednica_wew_korpusu_cyklowa == 34 | srednica_wew_korpusu_cyklowa == 36)
_0x51F:
	CALL SUBOPT_0xB3
	MOV  R0,R30
	CALL SUBOPT_0xB4
	BREQ _0x521
; 0000 2192                             {
; 0000 2193                             czas_pracy_szczotki_drucianej_h_15++;
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h_15)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h_15)
	CALL SUBOPT_0x1B3
; 0000 2194                             if(czas_pracy_szczotki_drucianej_h_15 > 250)
	CALL SUBOPT_0x12D
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x522
; 0000 2195                                 czas_pracy_szczotki_drucianej_h_15 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x22
; 0000 2196                             }
_0x522:
; 0000 2197 
; 0000 2198 
; 0000 2199 
; 0000 219A 
; 0000 219B 
; 0000 219C                             if(srednica_wew_korpusu_cyklowa == 34)
_0x521:
	CALL SUBOPT_0xAD
	SBIW R26,34
	BRNE _0x523
; 0000 219D                                 {
; 0000 219E                                 czas_pracy_krazka_sciernego_h_34++;
	CALL SUBOPT_0x1B5
; 0000 219F                                 if(czas_pracy_krazka_sciernego_h_34 > 250)
	CALL SUBOPT_0x12E
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x524
; 0000 21A0                                     czas_pracy_krazka_sciernego_h_34 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x24
; 0000 21A1                                 }
_0x524:
; 0000 21A2 
; 0000 21A3 
; 0000 21A4                             if(srednica_wew_korpusu_cyklowa == 36)
_0x523:
	CALL SUBOPT_0xAD
	SBIW R26,36
	BRNE _0x525
; 0000 21A5                                 {
; 0000 21A6                                 czas_pracy_krazka_sciernego_h_36++;
	CALL SUBOPT_0x1B6
; 0000 21A7                                 if(czas_pracy_krazka_sciernego_h_36 > 250)
	CALL SUBOPT_0x131
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x526
; 0000 21A8                                     czas_pracy_krazka_sciernego_h_36 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x25
; 0000 21A9                                 }
_0x526:
; 0000 21AA                             if(srednica_wew_korpusu_cyklowa == 38)
_0x525:
	CALL SUBOPT_0xAD
	SBIW R26,38
	BRNE _0x527
; 0000 21AB                                 {
; 0000 21AC                                 czas_pracy_krazka_sciernego_h_38++;
	CALL SUBOPT_0x1B7
; 0000 21AD                                 if(czas_pracy_krazka_sciernego_h_38 > 250)
	CALL SUBOPT_0x132
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x528
; 0000 21AE                                     czas_pracy_krazka_sciernego_h_38 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x27
; 0000 21AF                                 }
_0x528:
; 0000 21B0                             if(srednica_wew_korpusu_cyklowa == 41)
_0x527:
	CALL SUBOPT_0xAD
	SBIW R26,41
	BRNE _0x529
; 0000 21B1                                 {
; 0000 21B2                                 czas_pracy_krazka_sciernego_h_41++;
	CALL SUBOPT_0x1B8
; 0000 21B3                                 if(czas_pracy_krazka_sciernego_h_41 > 250)
	CALL SUBOPT_0x133
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x52A
; 0000 21B4                                     czas_pracy_krazka_sciernego_h_41 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x28
; 0000 21B5                                 }
_0x52A:
; 0000 21B6                             if(srednica_wew_korpusu_cyklowa == 43)
_0x529:
	CALL SUBOPT_0xAD
	SBIW R26,43
	BRNE _0x52B
; 0000 21B7                                 {
; 0000 21B8                                 czas_pracy_krazka_sciernego_h_43++;
	CALL SUBOPT_0x1B9
; 0000 21B9                                 if(czas_pracy_krazka_sciernego_h_43 > 250)
	CALL SUBOPT_0x134
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x52C
; 0000 21BA                                     czas_pracy_krazka_sciernego_h_43 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x29
; 0000 21BB                                 }
_0x52C:
; 0000 21BC 
; 0000 21BD                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_1 - 1)
_0x52B:
	CALL SUBOPT_0x1BA
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x52D
; 0000 21BE                                 {
; 0000 21BF                                 cykl_glowny = 5;
	CALL SUBOPT_0x1A3
; 0000 21C0                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0x19A
; 0000 21C1                                 }
; 0000 21C2 
; 0000 21C3                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
_0x52D:
	CALL SUBOPT_0x1BA
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x52E
; 0000 21C4                                 {
; 0000 21C5                                 cykl_glowny = 5;
	CALL SUBOPT_0x1A3
; 0000 21C6                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x1BB
; 0000 21C7                                 }
; 0000 21C8 
; 0000 21C9                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 == 10)
_0x52E:
	CALL SUBOPT_0x1BC
	CALL __EQW12
	AND  R30,R0
	BREQ _0x52F
; 0000 21CA                                 {
; 0000 21CB                                 cykl_glowny = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x19B
; 0000 21CC                                 }
; 0000 21CD 
; 0000 21CE                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 != 10)  /////zmieniam + 1 20.02
_0x52F:
	CALL SUBOPT_0x1BC
	CALL __NEW12
	AND  R30,R0
	BREQ _0x530
; 0000 21CF                                 {
; 0000 21D0                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x19B
; 0000 21D1                                 }
; 0000 21D2                             }
_0x530:
; 0000 21D3 
; 0000 21D4 
; 0000 21D5                              if(rzad_obrabiany == 2)
_0x51E:
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x531
; 0000 21D6                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 21D7 
; 0000 21D8                             if(rzad_obrabiany == 2 & cykl_glowny != 0)
_0x531:
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x1B4
	BRNE PC+3
	JMP _0x532
; 0000 21D9                             {
; 0000 21DA                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,16);  //wykonano zaciskow rzad2
	CALL SUBOPT_0x17C
	CALL SUBOPT_0x152
	CALL SUBOPT_0xA
	CALL _wartosc_parametru_panelu
; 0000 21DB 
; 0000 21DC                             if(srednica_wew_korpusu_cyklowa == 38 | srednica_wew_korpusu_cyklowa == 41 | srednica_wew_korpusu_cyklowa == 43)
	CALL SUBOPT_0xAE
	MOV  R0,R30
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xB0
	BREQ _0x533
; 0000 21DD                             {
; 0000 21DE                             czas_pracy_szczotki_drucianej_h_17++;
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h_17)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h_17)
	CALL SUBOPT_0x1B3
; 0000 21DF                             if(czas_pracy_szczotki_drucianej_h_17 > 250)
	CALL SUBOPT_0x12A
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x534
; 0000 21E0                                 czas_pracy_szczotki_drucianej_h_17 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x21
; 0000 21E1                             }
_0x534:
; 0000 21E2 
; 0000 21E3                             if(srednica_wew_korpusu_cyklowa == 34 | srednica_wew_korpusu_cyklowa == 36)
_0x533:
	CALL SUBOPT_0xB3
	MOV  R0,R30
	CALL SUBOPT_0xB4
	BREQ _0x535
; 0000 21E4                             {
; 0000 21E5                             czas_pracy_szczotki_drucianej_h_15++;
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h_15)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h_15)
	CALL SUBOPT_0x1B3
; 0000 21E6                             if(czas_pracy_szczotki_drucianej_h_15 > 250)
	CALL SUBOPT_0x12D
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x536
; 0000 21E7                                 czas_pracy_szczotki_drucianej_h_15 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x22
; 0000 21E8                             }
_0x536:
; 0000 21E9 
; 0000 21EA 
; 0000 21EB                             if(srednica_wew_korpusu_cyklowa == 34)
_0x535:
	CALL SUBOPT_0xAD
	SBIW R26,34
	BRNE _0x537
; 0000 21EC                                 {
; 0000 21ED                                 czas_pracy_krazka_sciernego_h_34++;
	CALL SUBOPT_0x1B5
; 0000 21EE                                 if(czas_pracy_krazka_sciernego_h_34 > 250)
	CALL SUBOPT_0x12E
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x538
; 0000 21EF                                     czas_pracy_krazka_sciernego_h_34 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x24
; 0000 21F0                                 }
_0x538:
; 0000 21F1 
; 0000 21F2 
; 0000 21F3                             if(srednica_wew_korpusu_cyklowa == 36)
_0x537:
	CALL SUBOPT_0xAD
	SBIW R26,36
	BRNE _0x539
; 0000 21F4                                 {
; 0000 21F5                                 czas_pracy_krazka_sciernego_h_36++;
	CALL SUBOPT_0x1B6
; 0000 21F6                                 if(czas_pracy_krazka_sciernego_h_36 > 250)
	CALL SUBOPT_0x131
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x53A
; 0000 21F7                                     czas_pracy_krazka_sciernego_h_36 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x25
; 0000 21F8                                 }
_0x53A:
; 0000 21F9                             if(srednica_wew_korpusu_cyklowa == 38)
_0x539:
	CALL SUBOPT_0xAD
	SBIW R26,38
	BRNE _0x53B
; 0000 21FA                                 {
; 0000 21FB                                 czas_pracy_krazka_sciernego_h_38++;
	CALL SUBOPT_0x1B7
; 0000 21FC                                 if(czas_pracy_krazka_sciernego_h_38 > 250)
	CALL SUBOPT_0x132
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x53C
; 0000 21FD                                     czas_pracy_krazka_sciernego_h_38 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x27
; 0000 21FE                                 }
_0x53C:
; 0000 21FF                             if(srednica_wew_korpusu_cyklowa == 41)
_0x53B:
	CALL SUBOPT_0xAD
	SBIW R26,41
	BRNE _0x53D
; 0000 2200                                 {
; 0000 2201                                 czas_pracy_krazka_sciernego_h_41++;
	CALL SUBOPT_0x1B8
; 0000 2202                                 if(czas_pracy_krazka_sciernego_h_41 > 250)
	CALL SUBOPT_0x133
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x53E
; 0000 2203                                     czas_pracy_krazka_sciernego_h_41 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x28
; 0000 2204                                 }
_0x53E:
; 0000 2205                             if(srednica_wew_korpusu_cyklowa == 43)
_0x53D:
	CALL SUBOPT_0xAD
	SBIW R26,43
	BRNE _0x53F
; 0000 2206                                 {
; 0000 2207                                 czas_pracy_krazka_sciernego_h_43++;
	CALL SUBOPT_0x1B9
; 0000 2208                                 if(czas_pracy_krazka_sciernego_h_43 > 250)
	CALL SUBOPT_0x134
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLT _0x540
; 0000 2209                                     czas_pracy_krazka_sciernego_h_43 = 250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x29
; 0000 220A                                 }
_0x540:
; 0000 220B 
; 0000 220C 
; 0000 220D                             if(srednica_wew_korpusu_cyklowa == 34)
_0x53F:
	CALL SUBOPT_0xAD
	SBIW R26,34
	BRNE _0x541
; 0000 220E                                 czas_pracy_krazka_sciernego_h_34++;
	CALL SUBOPT_0x1B5
; 0000 220F                             if(srednica_wew_korpusu_cyklowa == 36)
_0x541:
	CALL SUBOPT_0xAD
	SBIW R26,36
	BRNE _0x542
; 0000 2210                                 czas_pracy_krazka_sciernego_h_36++;
	CALL SUBOPT_0x1B6
; 0000 2211                             if(srednica_wew_korpusu_cyklowa == 38)
_0x542:
	CALL SUBOPT_0xAD
	SBIW R26,38
	BRNE _0x543
; 0000 2212                                 czas_pracy_krazka_sciernego_h_38++;
	CALL SUBOPT_0x1B7
; 0000 2213                             if(srednica_wew_korpusu_cyklowa == 41)
_0x543:
	CALL SUBOPT_0xAD
	SBIW R26,41
	BRNE _0x544
; 0000 2214                                 czas_pracy_krazka_sciernego_h_41++;
	CALL SUBOPT_0x1B8
; 0000 2215                             if(srednica_wew_korpusu_cyklowa == 43)
_0x544:
	CALL SUBOPT_0xAD
	SBIW R26,43
	BRNE _0x545
; 0000 2216                                 czas_pracy_krazka_sciernego_h_43++;
	CALL SUBOPT_0x1B9
; 0000 2217 
; 0000 2218 
; 0000 2219                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_2 - 1)
_0x545:
	CALL SUBOPT_0x199
	SBIW R30,1
	CALL SUBOPT_0x1AB
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x546
; 0000 221A                                 {
; 0000 221B                                 cykl_glowny = 5;
	CALL SUBOPT_0x1A3
; 0000 221C                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0x19A
; 0000 221D                                 }
; 0000 221E 
; 0000 221F                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x546:
	CALL SUBOPT_0x199
	SBIW R30,1
	CALL SUBOPT_0x1AB
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x547
; 0000 2220                                 {
; 0000 2221                                 cykl_glowny = 5;
	CALL SUBOPT_0x1A3
; 0000 2222                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x1BB
; 0000 2223                                 }
; 0000 2224 
; 0000 2225                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 == 10)
_0x547:
	CALL SUBOPT_0x1BD
	CALL __EQW12
	AND  R30,R0
	BREQ _0x548
; 0000 2226                                 {
; 0000 2227                                 cykl_glowny = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x19B
; 0000 2228                                 }
; 0000 2229 
; 0000 222A 
; 0000 222B                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 != 10)   ///////////////////zmieniam + 1 20.02
_0x548:
	CALL SUBOPT_0x1BD
	CALL __NEW12
	AND  R30,R0
	BREQ _0x549
; 0000 222C                                 {
; 0000 222D                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x19B
; 0000 222E                                 }
; 0000 222F                             }
_0x549:
; 0000 2230 
; 0000 2231 
; 0000 2232 
; 0000 2233             break;
_0x532:
	RJMP _0x4A8
; 0000 2234 
; 0000 2235             case 11:
_0x51D:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x54A
; 0000 2236 
; 0000 2237                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x54B
; 0000 2238                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 2239 
; 0000 223A                              //ster 1 ucieka od szafy
; 0000 223B                              if(cykl_sterownik_1 < 5)
_0x54B:
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x54C
; 0000 223C                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x140
; 0000 223D 
; 0000 223E                              if(cykl_sterownik_2 < 5)
_0x54C:
	CALL SUBOPT_0x114
	SBIW R26,5
	BRGE _0x54D
; 0000 223F                                     cykl_sterownik_2 = sterownik_2_praca(0x190);     //pod dolek ostatni 10 do przedmuchu rzad 1
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0x1A7
; 0000 2240 
; 0000 2241                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x54D:
	CALL SUBOPT_0x117
	BREQ _0x54E
; 0000 2242                                     {
; 0000 2243                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x1AD
; 0000 2244                                     PORTF = PORT_F.byte;
; 0000 2245                                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 2246                                     sek12 = 0;
	CALL SUBOPT_0x1AC
; 0000 2247                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 2248                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x1BE
; 0000 2249                                     cykl_glowny = 13;
; 0000 224A                                     }
; 0000 224B             break;
_0x54E:
	RJMP _0x4A8
; 0000 224C 
; 0000 224D 
; 0000 224E             case 12:
_0x54A:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x551
; 0000 224F 
; 0000 2250                              if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x552
; 0000 2251                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 2252 
; 0000 2253                                //ster 1 ucieka od szafy
; 0000 2254                              if(cykl_sterownik_1 < 5)
_0x552:
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x553
; 0000 2255                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x140
; 0000 2256 
; 0000 2257                             if(cykl_sterownik_2 < 5)
_0x553:
	CALL SUBOPT_0x114
	SBIW R26,5
	BRGE _0x554
; 0000 2258                                     cykl_sterownik_2 = sterownik_2_praca(0x191);     //pod dolek ostatni 10 do przedmuchu rzad 2
	LDI  R30,LOW(401)
	LDI  R31,HIGH(401)
	CALL SUBOPT_0x1A7
; 0000 2259 
; 0000 225A                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x554:
	CALL SUBOPT_0x117
	BREQ _0x555
; 0000 225B                                     {
; 0000 225C                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x1AD
; 0000 225D                                     PORTF = PORT_F.byte;
; 0000 225E                                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 225F                                     sek12 = 0;
	CALL SUBOPT_0x1AC
; 0000 2260                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 2261                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x1BE
; 0000 2262                                     cykl_glowny = 13;
; 0000 2263                                     }
; 0000 2264 
; 0000 2265 
; 0000 2266             break;
_0x555:
	RJMP _0x4A8
; 0000 2267 
; 0000 2268             case 13:
_0x551:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x558
; 0000 2269 
; 0000 226A 
; 0000 226B                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x559
; 0000 226C                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 226D 
; 0000 226E                               if(sek12 > czas_przedmuchu)
_0x559:
	CALL SUBOPT_0x139
	BRGE _0x55A
; 0000 226F                                         {
; 0000 2270                                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0x13A
; 0000 2271                                         PORTF = PORT_F.byte;
; 0000 2272                                         PORTE.5 = 0;
	CBI  0x3,5
; 0000 2273                                         }
; 0000 2274 
; 0000 2275 
; 0000 2276                              if(cykl_sterownik_2 < 5)
_0x55A:
	CALL SUBOPT_0x114
	SBIW R26,5
	BRGE _0x55D
; 0000 2277                                     cykl_sterownik_2 = sterownik_2_praca(0x192);     //okrag
	LDI  R30,LOW(402)
	LDI  R31,HIGH(402)
	CALL SUBOPT_0x1A7
; 0000 2278                              if(cykl_sterownik_2 == 5)
_0x55D:
	CALL SUBOPT_0x114
	SBIW R26,5
	BRNE _0x55E
; 0000 2279                                     {
; 0000 227A 
; 0000 227B                                      if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x139
	BRGE _0x55F
; 0000 227C                                         {
; 0000 227D                                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0x13A
; 0000 227E                                         PORTF = PORT_F.byte;
; 0000 227F                                         PORTE.5 = 0;
	CBI  0x3,5
; 0000 2280                                         cykl_sterownik_2 = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
; 0000 2281                                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x19B
; 0000 2282                                         }
; 0000 2283                                     }
_0x55F:
; 0000 2284 
; 0000 2285             break;
_0x55E:
	RJMP _0x4A8
; 0000 2286 
; 0000 2287 
; 0000 2288 
; 0000 2289             case 14:
_0x558:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x562
; 0000 228A 
; 0000 228B 
; 0000 228C                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x563
; 0000 228D                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 228E 
; 0000 228F                     if(cykl_sterownik_1 < 5)
_0x563:
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x564
; 0000 2290                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek zeby przedmuchac
	CALL SUBOPT_0x123
; 0000 2291                     if(cykl_sterownik_1 == 5)
_0x564:
	CALL SUBOPT_0x112
	SBIW R26,5
	BRNE _0x565
; 0000 2292                         {
; 0000 2293                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x142
; 0000 2294                         sek12 = 0;
	CALL SUBOPT_0x1AC
; 0000 2295                         cykl_glowny = 15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x19B
; 0000 2296                         }
; 0000 2297 
; 0000 2298             break;
_0x565:
	RJMP _0x4A8
; 0000 2299 
; 0000 229A 
; 0000 229B 
; 0000 229C             case 15:
_0x562:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x566
; 0000 229D 
; 0000 229E                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0x9E
	SBIW R26,2
	BRNE _0x567
; 0000 229F                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 22A0 
; 0000 22A1                     //przedmuch
; 0000 22A2                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
_0x567:
	CALL SUBOPT_0x1AD
; 0000 22A3                     PORTF = PORT_F.byte;
; 0000 22A4 
; 0000 22A5                     if(start == 1)
	CALL SUBOPT_0xF5
	SBIW R26,1
	BRNE _0x568
; 0000 22A6                         {
; 0000 22A7                         obsluga_otwarcia_klapy_rzad();
	CALL SUBOPT_0xF7
; 0000 22A8                         obsluga_nacisniecia_zatrzymaj();
; 0000 22A9                         }
; 0000 22AA 
; 0000 22AB 
; 0000 22AC                     if(sek12 > czas_przedmuchu)
_0x568:
	CALL SUBOPT_0x139
	BRGE _0x569
; 0000 22AD                         {
; 0000 22AE                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x13A
; 0000 22AF                         PORTF = PORT_F.byte;
; 0000 22B0                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x19B
; 0000 22B1                         }
; 0000 22B2             break;
_0x569:
	RJMP _0x4A8
; 0000 22B3 
; 0000 22B4 
; 0000 22B5             case 16:
_0x566:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x56A
; 0000 22B6 
; 0000 22B7                      if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & wykonalem_rzedow == 0)  /////zmieniam + 1 20.02
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	CALL SUBOPT_0x1AB
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x1BF
	CALL SUBOPT_0xEA
	BREQ _0x56B
; 0000 22B8                                 {
; 0000 22B9                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x197
; 0000 22BA                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 22BB                                 if(il_zaciskow_rzad_2 > 0)
	CALL SUBOPT_0x124
	CALL __CPW02
	BRGE _0x56E
; 0000 22BC                                     {
; 0000 22BD 
; 0000 22BE                                     rzad_obrabiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
; 0000 22BF                                     wybor_linijek_sterownikow(2);  //rzad 2
	CALL SUBOPT_0x127
	CALL _wybor_linijek_sterownikow
; 0000 22C0                                     cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 22C1                                     }
; 0000 22C2                                 else
	RJMP _0x56F
_0x56E:
; 0000 22C3                                     cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x19B
; 0000 22C4 
; 0000 22C5                                 wykonalem_rzedow = 1;
_0x56F:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 22C6                                 }
; 0000 22C7 
; 0000 22C8                        if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 1)   ///////////////////zmieniam + 1 20.02
_0x56B:
	CALL SUBOPT_0x199
	CALL SUBOPT_0x1AB
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x124
	CALL SUBOPT_0x125
	CALL SUBOPT_0x1BF
	CALL SUBOPT_0x84
	AND  R30,R0
	BREQ _0x570
; 0000 22C9                                 {
; 0000 22CA                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 22CB                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x197
; 0000 22CC                                 cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x19B
; 0000 22CD                                 rzad_obrabiany = 1;
	CALL SUBOPT_0x195
; 0000 22CE                                 wykonalem_rzedow = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 22CF                                 }
; 0000 22D0 
; 0000 22D1 
; 0000 22D2                         if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 2)
_0x570:
	CALL SUBOPT_0x1C0
	CALL SUBOPT_0x124
	CALL SUBOPT_0x125
	CALL SUBOPT_0x1BF
	CALL SUBOPT_0xF4
	AND  R30,R0
	BREQ _0x573
; 0000 22D3                                   {
; 0000 22D4                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x195
; 0000 22D5                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0x196
; 0000 22D6                                   PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 22D7                                   //PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1 - tego na razie nie poki nie ma oslon
; 0000 22D8                                   //PORTB.6 = 0;   ////zielona lampka
; 0000 22D9                                   //wartosc_parametru_panelu(0,0,64);
; 0000 22DA                                   }
; 0000 22DB 
; 0000 22DC                             if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 == 0 & wykonalem_rzedow == 1)
_0x573:
	CALL SUBOPT_0x1C0
	CALL SUBOPT_0x124
	CALL SUBOPT_0x107
	CALL SUBOPT_0x1BF
	CALL SUBOPT_0x84
	AND  R30,R0
	BREQ _0x576
; 0000 22DD                                   {
; 0000 22DE                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x195
; 0000 22DF                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0x196
; 0000 22E0                                   //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
; 0000 22E1                                   }
; 0000 22E2 
; 0000 22E3 
; 0000 22E4 
; 0000 22E5             break;
_0x576:
	RJMP _0x4A8
; 0000 22E6 
; 0000 22E7 
; 0000 22E8             case 17:
_0x56A:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4A8
; 0000 22E9 
; 0000 22EA 
; 0000 22EB                                  if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x112
	SBIW R26,5
	BRGE _0x578
; 0000 22EC                                     cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0x128
	CALL SUBOPT_0x113
; 0000 22ED                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x578:
	CALL SUBOPT_0x114
	SBIW R26,5
	BRGE _0x579
; 0000 22EE                                     cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x9
	CALL SUBOPT_0x116
; 0000 22EF 
; 0000 22F0                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x579:
	CALL SUBOPT_0x117
	BRNE PC+3
	JMP _0x57A
; 0000 22F1                                         {
; 0000 22F2                                         PORTB.6 = 0;   ////zielona lampka
	CBI  0x18,6
; 0000 22F3                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x118
; 0000 22F4                                         cykl_sterownik_2 = 0;
; 0000 22F5                                         cykl_sterownik_3 = 0;
; 0000 22F6                                         cykl_sterownik_4 = 0;
; 0000 22F7                                         jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 22F8                                         PORTB.6 = 0;
	CBI  0x18,6
; 0000 22F9 
; 0000 22FA                                         if(odczytalem_w_trakcie_czyszczenia_drugiego_rzedu == 0)
	LDS  R30,_odczytalem_w_trakcie_czyszczenia_drugiego_rzedu
	LDS  R31,_odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1
	SBIW R30,0
	BRNE _0x57F
; 0000 22FB                                         {
; 0000 22FC                                         macierz_zaciskow[1]=0;
	__POINTW1MN _macierz_zaciskow,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 22FD                                         macierz_zaciskow[2]=0;
	__POINTW1MN _macierz_zaciskow,4
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 22FE 
; 0000 22FF                                         komunikat_na_panel("-------",0,80);  //rzad 1
	__POINTW1FN _0x0,2295
	CALL SUBOPT_0x152
	CALL SUBOPT_0xBC
	CALL _komunikat_na_panel
; 0000 2300                                         komunikat_na_panel("-------",0,32);  //rzad 2
	__POINTW1FN _0x0,2295
	CALL SUBOPT_0x152
	CALL SUBOPT_0x30
	CALL _komunikat_na_panel
; 0000 2301 
; 0000 2302                                         komunikat_na_panel("                                                ",128,144);
	CALL SUBOPT_0x12
; 0000 2303                                         komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",128,144);
	__POINTW1FN _0x0,2303
	CALL SUBOPT_0x13
; 0000 2304                                         komunikat_na_panel("                                                ",144,80);
	CALL SUBOPT_0xD
; 0000 2305                                         komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",144,80);
	__POINTW1FN _0x0,2303
	CALL SUBOPT_0xE
; 0000 2306                                         }
; 0000 2307 
; 0000 2308                                         odczytalem_w_trakcie_czyszczenia_drugiego_rzedu = 0;
_0x57F:
	LDI  R30,LOW(0)
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu,R30
	STS  _odczytalem_w_trakcie_czyszczenia_drugiego_rzedu+1,R30
; 0000 2309 
; 0000 230A 
; 0000 230B                                         //to ponizej dotyczy zapisu do pamieci stalej cykli szczotki i krazka
; 0000 230C 
; 0000 230D                                         tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1D
	MOVW R10,R30
; 0000 230E                                         szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1C
; 0000 230F                                         krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
; 0000 2310                                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
	CALL SUBOPT_0x9
	CALL _odczytaj_parametr
	MOVW R8,R30
; 0000 2311                                         czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
; 0000 2312                                         czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
	CALL SUBOPT_0x1F
; 0000 2313 
; 0000 2314                                         wartosci_wstepne_wgrac_tylko_raz(1); //to trwa 3s
	CALL SUBOPT_0xC2
	CALL _wartosci_wstepne_wgrac_tylko_raz
; 0000 2315                                         srednica_wew_korpusu_cyklowa = 0;
	LDI  R30,LOW(0)
	STS  _srednica_wew_korpusu_cyklowa,R30
	STS  _srednica_wew_korpusu_cyklowa+1,R30
; 0000 2316                                         wartosc_parametru_panelu(0,0,64);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xED
; 0000 2317                                         start = 0;
; 0000 2318                                         cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 2319                                         }
; 0000 231A 
; 0000 231B 
; 0000 231C 
; 0000 231D 
; 0000 231E             break;
_0x57A:
; 0000 231F 
; 0000 2320 
; 0000 2321 
; 0000 2322             }//switch
_0x4A8:
; 0000 2323 
; 0000 2324 
; 0000 2325   }//while
	RJMP _0x4A3
_0x4A5:
; 0000 2326 
; 0000 2327 
; 0000 2328 
; 0000 2329 }//while glowny
	RJMP _0x4A0
; 0000 232A 
; 0000 232B 
; 0000 232C 
; 0000 232D 
; 0000 232E }//koniec
_0x580:
	RJMP _0x580
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
	CALL SUBOPT_0x1B3
	ADIW R28,3
	RET
__print_G103:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x3E
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
	CALL SUBOPT_0x1C1
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x1C1
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
	CALL SUBOPT_0x1C2
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1C3
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x1C2
	CALL SUBOPT_0x1C4
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x1C2
	CALL SUBOPT_0x1C4
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
	CALL SUBOPT_0x1C2
	CALL SUBOPT_0x1C5
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
	CALL SUBOPT_0x1C2
	CALL SUBOPT_0x1C5
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
	CALL SUBOPT_0x1C1
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
	CALL SUBOPT_0x1C1
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
	CALL SUBOPT_0x1C3
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x1C1
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
	CALL SUBOPT_0x1C3
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
_sek80:
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
_sek21:
	.BYTE 0x4
_sek21_wylaczenie_szlif:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:75 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 277 TIMES, CODE SIZE REDUCTION:549 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 50 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xC:
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
SUBOPT_0xD:
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
SUBOPT_0xE:
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
SUBOPT_0xF:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x10:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x12:
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
SUBOPT_0x13:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 47 TIMES, CODE SIZE REDUCTION:273 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
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
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 49 TIMES, CODE SIZE REDUCTION:93 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
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
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	MOVW R12,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	CALL _odczytaj_parametr
	STS  _czas_pracy_krazka_sciernego_stala,R30
	STS  _czas_pracy_krazka_sciernego_stala+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	STS  _czas_pracy_szczotki_drucianej_h_17,R30
	STS  _czas_pracy_szczotki_drucianej_h_17+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	STS  _czas_pracy_szczotki_drucianej_h_15,R30
	STS  _czas_pracy_szczotki_drucianej_h_15+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 66 TIMES, CODE SIZE REDUCTION:127 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	STS  _czas_pracy_krazka_sciernego_h_34,R30
	STS  _czas_pracy_krazka_sciernego_h_34+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	STS  _czas_pracy_krazka_sciernego_h_36,R30
	STS  _czas_pracy_krazka_sciernego_h_36+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	STS  _czas_pracy_krazka_sciernego_h_38,R30
	STS  _czas_pracy_krazka_sciernego_h_38+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	STS  _czas_pracy_krazka_sciernego_h_41,R30
	STS  _czas_pracy_krazka_sciernego_h_41+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	STS  _czas_pracy_krazka_sciernego_h_43,R30
	STS  _czas_pracy_krazka_sciernego_h_43+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	STS  _srednica_krazka_sciernego,R30
	STS  _srednica_krazka_sciernego+1,R31
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(_PORTJJ)
	LDI  R31,HIGH(_PORTJJ)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:509 WORDS
SUBOPT_0x2C:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:403 WORDS
SUBOPT_0x2D:
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
SUBOPT_0x2E:
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
SUBOPT_0x2F:
	OR   R30,R0
	STS  _PORT_CZYTNIK,R30
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 152 TIMES, CODE SIZE REDUCTION:752 WORDS
SUBOPT_0x31:
	MOVW R30,R16
	LDI  R26,LOW(_macierz_zaciskow)
	LDI  R27,HIGH(_macierz_zaciskow)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 68 TIMES, CODE SIZE REDUCTION:265 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x36:
	CALL _komunikat_z_czytnika_kodow
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x37:
	CALL _komunikat_z_czytnika_kodow
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x39:
	CALL _komunikat_z_czytnika_kodow
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x3A:
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x3B:
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3C:
	CALL _komunikat_z_czytnika_kodow
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3D:
	ST   X+,R30
	ST   X,R31
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3F:
	CALL _komunikat_z_czytnika_kodow
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x40:
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	STS  _srednica_wew_korpusu,R30
	STS  _srednica_wew_korpusu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x41:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 136 TIMES, CODE SIZE REDUCTION:537 WORDS
SUBOPT_0x42:
	STS  _a,R30
	STS  _a+1,R31
	__POINTW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 104 TIMES, CODE SIZE REDUCTION:409 WORDS
SUBOPT_0x43:
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x44:
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
SUBOPT_0x45:
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x46:
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
SUBOPT_0x47:
	__POINTW1MN _a,18
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x48:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x49:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x47

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x4A:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x4B:
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x47

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x4C:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4D:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4E:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x4F:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x50:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x51:
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
SUBOPT_0x52:
	LDI  R26,LOW(29)
	LDI  R27,HIGH(29)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x53:
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x54:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x55:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x4C

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x56:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x57:
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
SUBOPT_0x58:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x59:
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
SUBOPT_0x5A:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5C:
	__POINTW1MN _a,8
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x4C

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5D:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:186 WORDS
SUBOPT_0x5E:
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
	RJMP SUBOPT_0x4B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5F:
	LDI  R26,LOW(27)
	LDI  R27,HIGH(27)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x60:
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
SUBOPT_0x61:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x4C

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x62:
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x63:
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x64:
	LDI  R26,LOW(22)
	LDI  R27,HIGH(22)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x65:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x4C

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x66:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x67:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x68:
	LDI  R26,LOW(20)
	LDI  R27,HIGH(20)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x69:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6A:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	LDI  R26,LOW(36)
	LDI  R27,HIGH(36)
	RJMP SUBOPT_0x69

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x6B:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6C:
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	RJMP SUBOPT_0x69

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6D:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6E:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP SUBOPT_0x69

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6F:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	RJMP SUBOPT_0x69

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x70:
	__POINTW1MN _a,8
	RJMP SUBOPT_0x52

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x71:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x6E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x72:
	__POINTW1MN _a,8
	LDI  R26,LOW(23)
	LDI  R27,HIGH(23)
	RJMP SUBOPT_0x69

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x73:
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x74:
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x75:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x76:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	RJMP SUBOPT_0x69

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x77:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x6C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x78:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x79:
	LDS  R30,_a
	LDS  R31,_a+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7A:
	__GETW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x7B:
	__GETW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x7C:
	ADIW R30,1
	__PUTW1MN _a,12
	__GETW1MN _a,12
	ADIW R30,1
	__PUTW1MN _a,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7E:
	__GETW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7F:
	__PUTW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x80:
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
SUBOPT_0x81:
	__GETW1MN _a,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x82:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x83:
	LDS  R26,_ruch_haos
	LDS  R27,_ruch_haos+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 107 TIMES, CODE SIZE REDUCTION:209 WORDS
SUBOPT_0x84:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x85:
	__GETW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x86:
	LDS  R26,_srednica_krazka_sciernego
	LDS  R27,_srednica_krazka_sciernego+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x87:
	LDS  R26,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R27,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x88:
	MOV  R0,R30
	RCALL SUBOPT_0x86
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x89:
	RCALL SUBOPT_0x87
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x8A:
	__PUTW1MN _a,10
	RJMP SUBOPT_0x7B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8B:
	RCALL SUBOPT_0x87
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8C:
	RCALL SUBOPT_0x87
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x8D:
	MOV  R0,R30
	RCALL SUBOPT_0x86
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8E:
	LDS  R26,_sek20
	LDS  R27,_sek20+1
	LDS  R24,_sek20+2
	LDS  R25,_sek20+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8F:
	__CPD2N 0x3D
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x90:
	LDI  R30,LOW(0)
	STS  _sek20,R30
	STS  _sek20+1,R30
	STS  _sek20+2,R30
	STS  _sek20+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x91:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	CALL _wartosc_parametru_panelu
	SBI  0x12,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x92:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _byla_wloczona_szlifierka_1,R30
	STS  _byla_wloczona_szlifierka_1+1,R31
	CBI  0x3,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x93:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _byla_wloczona_szlifierka_2,R30
	STS  _byla_wloczona_szlifierka_2+1,R31
	CBI  0x3,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x94:
	LDS  R30,_PORT_F
	ANDI R30,LOW(0x10)
	CPI  R30,LOW(0x10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x95:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:365 WORDS
SUBOPT_0x96:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:263 WORDS
SUBOPT_0x97:
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
SUBOPT_0x98:
	CBI  0x12,7
	LDS  R26,_byla_wloczona_szlifierka_1
	LDS  R27,_byla_wloczona_szlifierka_1+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x99:
	SBI  0x3,2
	LDI  R30,LOW(0)
	STS  _byla_wloczona_szlifierka_1,R30
	STS  _byla_wloczona_szlifierka_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9A:
	LDS  R26,_byla_wloczona_szlifierka_2
	LDS  R27,_byla_wloczona_szlifierka_2+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9B:
	SBI  0x3,3
	LDI  R30,LOW(0)
	STS  _byla_wloczona_szlifierka_2,R30
	STS  _byla_wloczona_szlifierka_2+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9C:
	LDS  R26,_byl_wloczony_przedmuch
	LDS  R27,_byl_wloczony_przedmuch+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x9D:
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
SUBOPT_0x9E:
	LDS  R26,_rzad_obrabiany
	LDS  R27,_rzad_obrabiany+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9F:
	MOV  R0,R30
	LDS  R26,_start
	LDS  R27,_start+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xA0:
	RCALL SUBOPT_0x9E
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA1:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA2:
	CALL _putchar
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0xA3:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:135 WORDS
SUBOPT_0xA4:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xA5:
	CALL _wartosc_parametru_panelu_stala_pamiec
	RJMP SUBOPT_0xA4

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:141 WORDS
SUBOPT_0xA6:
	CALL _odczyt_parametru_panelu_stala_pamiec
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0xA7:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0xA8:
	CALL _wartosc_parametru_panelu
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0xA9:
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xAA:
	LDS  R30,_czas_pracy_krazka_sciernego_stala
	LDS  R31,_czas_pracy_krazka_sciernego_stala+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xAB:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAC:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP SUBOPT_0xAB

;OPTIMIZER ADDED SUBROUTINE, CALLED 42 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0xAD:
	LDS  R26,_srednica_wew_korpusu_cyklowa
	LDS  R27,_srednica_wew_korpusu_cyklowa+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xAE:
	RCALL SUBOPT_0xAD
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xAF:
	RCALL SUBOPT_0xAD
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB0:
	OR   R0,R30
	RCALL SUBOPT_0xAD
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	CALL __EQW12
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB1:
	LDS  R30,_czas_pracy_szczotki_drucianej_h_17
	LDS  R31,_czas_pracy_szczotki_drucianej_h_17+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB2:
	RCALL SUBOPT_0xAD
	RJMP SUBOPT_0x82

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB3:
	RCALL SUBOPT_0xAD
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xB4:
	RCALL SUBOPT_0xAD
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL __EQW12
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB5:
	LDS  R30,_czas_pracy_szczotki_drucianej_h_15
	LDS  R31,_czas_pracy_szczotki_drucianej_h_15+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0xB6:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB7:
	CALL _wartosc_parametru_panelu
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xB8:
	CALL _wartosc_parametru_panelu_stala_pamiec
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB9:
	LDS  R30,_czas_pracy_krazka_sciernego_h_34
	LDS  R31,_czas_pracy_krazka_sciernego_h_34+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBA:
	LDS  R30,_czas_pracy_krazka_sciernego_h_36
	LDS  R31,_czas_pracy_krazka_sciernego_h_36+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBB:
	LDS  R30,_czas_pracy_krazka_sciernego_h_38
	LDS  R31,_czas_pracy_krazka_sciernego_h_38+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 50 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0xBC:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBD:
	LDS  R30,_czas_pracy_krazka_sciernego_h_41
	LDS  R31,_czas_pracy_krazka_sciernego_h_41+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBE:
	LDS  R30,_czas_pracy_krazka_sciernego_h_43
	LDS  R31,_czas_pracy_krazka_sciernego_h_43+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xBF:
	CALL _odczyt_parametru_panelu_stala_pamiec
	RJMP SUBOPT_0xA4

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0xC0:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC1:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0xC2:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC3:
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	MOVW R18,R30
	RJMP SUBOPT_0xBC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC4:
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	MOVW R20,R30
	RJMP SUBOPT_0xBC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC5:
	LDI  R30,LOW(147)
	LDI  R31,HIGH(147)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STD  Y+18,R30
	STD  Y+18+1,R31
	RJMP SUBOPT_0xBC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC6:
	LDI  R30,LOW(148)
	LDI  R31,HIGH(148)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP SUBOPT_0xBC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC7:
	LDI  R30,LOW(149)
	LDI  R31,HIGH(149)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP SUBOPT_0xBC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC8:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STD  Y+12,R30
	STD  Y+12+1,R31
	RJMP SUBOPT_0xBC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC9:
	LDI  R30,LOW(151)
	LDI  R31,HIGH(151)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP SUBOPT_0xBC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xCA:
	LDI  R30,LOW(152)
	LDI  R31,HIGH(152)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCB:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xCC:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCD:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xCE:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCF:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD1:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0xD2:
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(128)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xD3:
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP SUBOPT_0xC0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xD4:
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(16)
	RJMP SUBOPT_0xD3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD5:
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD6:
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD7:
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD8:
	LDI  R30,LOW(147)
	LDI  R31,HIGH(147)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD9:
	LDI  R30,LOW(148)
	LDI  R31,HIGH(148)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xDA:
	LDI  R30,LOW(149)
	LDI  R31,HIGH(149)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xDB:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xDC:
	LDI  R30,LOW(151)
	LDI  R31,HIGH(151)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0xDD:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xDE:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0xC0

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xDF:
	CALL _sprawdz_pin0
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE0:
	CALL _sprawdz_pin1
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xE1:
	LDI  R30,LOW(_PORTKK)
	LDI  R31,HIGH(_PORTKK)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(117)
	LDI  R31,HIGH(117)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xE2:
	CALL _sprawdz_pin3
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE3:
	CALL _sprawdz_pin7
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE4:
	SBI  0x12,7
	CBI  0x18,6
	CBI  0x18,4
	CBI  0x12,2
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE5:
	__POINTW1FN _0x0,1491
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE6:
	__POINTW1FN _0x0,1531
	RJMP SUBOPT_0x97

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE7:
	__POINTW1FN _0x0,1554
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE8:
	CALL _sprawdz_pin6
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xE9:
	LDI  R30,LOW(_PORTLL)
	LDI  R31,HIGH(_PORTLL)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xE2

;OPTIMIZER ADDED SUBROUTINE, CALLED 60 TIMES, CODE SIZE REDUCTION:174 WORDS
SUBOPT_0xEA:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0xEB:
	LDI  R30,LOW(_PORTLL)
	LDI  R31,HIGH(_PORTLL)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xEC:
	CALL _sprawdz_pin5
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xED:
	CALL _wartosc_parametru_panelu
	LDI  R30,LOW(0)
	STS  _start,R30
	STS  _start+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xEE:
	AND  R30,R26
	MOV  R0,R30
	LDS  R26,_czekaj_az_puszcze
	LDS  R27,_czekaj_az_puszcze+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xEF:
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
SUBOPT_0xF0:
	LDI  R30,LOW(0)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0xC0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF1:
	LDI  R30,LOW(0)
	STS  _sek11,R30
	STS  _sek11+1,R30
	STS  _sek11+2,R30
	STS  _sek11+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF2:
	LDS  R30,_il_prob_odczytu
	LDS  R31,_il_prob_odczytu+1
	LDS  R26,_odczytalem_zacisk
	LDS  R27,_odczytalem_zacisk+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF3:
	LDI  R26,LOW(_odczytalem_zacisk)
	LDI  R27,HIGH(_odczytalem_zacisk)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xF4:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xF5:
	LDS  R26,_start
	LDS  R27,_start+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xF6:
	SBI  0x12,7
	CBI  0x3,2
	CBI  0x3,3
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF7:
	CALL _obsluga_otwarcia_klapy_rzad
	JMP  _obsluga_nacisniecia_zatrzymaj

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xF8:
	LDI  R30,LOW(0)
	STS  _sek1,R30
	STS  _sek1+1,R30
	STS  _sek1+2,R30
	STS  _sek1+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xF9:
	__CPD2N 0x2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0xFA:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xFB:
	LDI  R30,LOW(0)
	STS  _sek3,R30
	STS  _sek3+1,R30
	STS  _sek3+2,R30
	STS  _sek3+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0xFC:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xFD:
	OR   R30,R0
	STS  _PORT_F,R30
	LDS  R30,_PORT_STER3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0xFE:
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xFF:
	LDI  R30,LOW(0)
	STS  _sek2,R30
	STS  _sek2+1,R30
	STS  _sek2+2,R30
	STS  _sek2+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x100:
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x101:
	STS  _PORT_F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x102:
	LDI  R30,LOW(0)
	STS  _sek4,R30
	STS  _sek4+1,R30
	STS  _sek4+2,R30
	STS  _sek4+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 50 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0x103:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x104:
	MOVW R26,R28
	ADIW R26,6
	RJMP SUBOPT_0x41

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x105:
	LDS  R26,_test_geometryczny_rzad_1
	LDS  R27,_test_geometryczny_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x106:
	LDS  R26,_test_geometryczny_rzad_2
	LDS  R27,_test_geometryczny_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:90 WORDS
SUBOPT_0x107:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x108:
	LDI  R26,0
	SBIC 0x12,7
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x109:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __GTW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10A:
	__GETW1MN _macierz_zaciskow,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x10B:
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
SUBOPT_0x10C:
	LDS  R26,_cykl_sterownik_3
	LDS  R27,_cykl_sterownik_3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x10D:
	CALL _sterownik_3_praca
	RJMP SUBOPT_0x100

;OPTIMIZER ADDED SUBROUTINE, CALLED 75 TIMES, CODE SIZE REDUCTION:145 WORDS
SUBOPT_0x10E:
	LDS  R26,_cykl_sterownik_4
	LDS  R27,_cykl_sterownik_4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x10F:
	CALL _sterownik_4_praca
	RJMP SUBOPT_0x103

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x110:
	RCALL SUBOPT_0x10C
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0x10E
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:253 WORDS
SUBOPT_0x111:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 59 TIMES, CODE SIZE REDUCTION:113 WORDS
SUBOPT_0x112:
	LDS  R26,_cykl_sterownik_1
	LDS  R27,_cykl_sterownik_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x113:
	CALL _sterownik_1_praca
	RJMP SUBOPT_0xFA

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x114:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x115:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x116:
	CALL _sterownik_2_praca
	RJMP SUBOPT_0xFC

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x117:
	RCALL SUBOPT_0x112
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0x114
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:227 WORDS
SUBOPT_0x118:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	RJMP SUBOPT_0x111

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x119:
	RCALL SUBOPT_0x79
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x11A:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x10D

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0x11B:
	__GETWRN 16,17,6
	MOVW R30,R18
	RJMP SUBOPT_0x104

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11C:
	MOVW R26,R18
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0xCF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11D:
	MOVW R26,R18
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0xCD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11E:
	MOVW R26,R18
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0xCC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11F:
	MOVW R26,R18
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0xCB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x120:
	MOVW R26,R18
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x121:
	MOVW R26,R18
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x122:
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x123:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x113

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x124:
	LDS  R26,_il_zaciskow_rzad_2
	LDS  R27,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x125:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x126:
	__GETW1MN _macierz_zaciskow,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x127:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x128:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x129:
	__GETW1MN _a,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12A:
	LDS  R26,_czas_pracy_szczotki_drucianej_h_17
	LDS  R27,_czas_pracy_szczotki_drucianej_h_17+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x12B:
	LDS  R30,_PORT_F
	ORI  R30,0x40
	RJMP SUBOPT_0xFE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12C:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xBC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12D:
	LDS  R26,_czas_pracy_szczotki_drucianej_h_15
	LDS  R27,_czas_pracy_szczotki_drucianej_h_15+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12E:
	LDS  R26,_czas_pracy_krazka_sciernego_h_34
	LDS  R27,_czas_pracy_krazka_sciernego_h_34+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x12F:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA3

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x130:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x131:
	LDS  R26,_czas_pracy_krazka_sciernego_h_36
	LDS  R27,_czas_pracy_krazka_sciernego_h_36+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x132:
	LDS  R26,_czas_pracy_krazka_sciernego_h_38
	LDS  R27,_czas_pracy_krazka_sciernego_h_38+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x133:
	LDS  R26,_czas_pracy_krazka_sciernego_h_41
	LDS  R27,_czas_pracy_krazka_sciernego_h_41+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x134:
	LDS  R26,_czas_pracy_krazka_sciernego_h_43
	LDS  R27,_czas_pracy_krazka_sciernego_h_43+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x135:
	LDI  R30,LOW(505)
	LDI  R31,HIGH(505)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x136:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x137:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBI  0x18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x138:
	LDS  R26,_srednica_wew_korpusu
	LDS  R27,_srednica_wew_korpusu+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x139:
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
SUBOPT_0x13A:
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	RJMP SUBOPT_0xFE

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x13B:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x13C:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0x103

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:59 WORDS
SUBOPT_0x13D:
	RCALL SUBOPT_0x112
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13E:
	CALL __LTW12
	MOV  R0,R30
	MOVW R26,R8
	RJMP SUBOPT_0x125

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x13F:
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xEA

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x140:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x113

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x141:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x13F

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x142:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x143:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x144:
	CALL __LTW12
	MOV  R0,R30
	MOVW R30,R8
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __LTW12
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x145:
	__GETW1MN _a,12
	RJMP SUBOPT_0x140

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x146:
	CALL __EQW12
	MOV  R0,R30
	MOVW R30,R8
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __LTW12
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x147:
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x148:
	MOVW R30,R8
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x149:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x14A:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xF4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14B:
	__GETW1MN _a,16
	RJMP SUBOPT_0x140

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x14C:
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xF4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14D:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 54 TIMES, CODE SIZE REDUCTION:103 WORDS
SUBOPT_0x14E:
	RCALL SUBOPT_0x10E
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x14F:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster4
	LDS  R27,_abs_ster4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x150:
	LDS  R26,_powrot_przedwczesny_druciak
	LDS  R27,_powrot_przedwczesny_druciak+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x151:
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
SUBOPT_0x152:
	ST   -Y,R31
	ST   -Y,R30
	JMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x153:
	CALL __EQW12
	MOV  R0,R30
	MOVW R30,R4
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x154:
	CALL __LTW12
	AND  R0,R30
	RCALL SUBOPT_0x150
	RJMP SUBOPT_0xEA

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x155:
	LDS  R30,_koniec_rzedu_10
	LDS  R31,_koniec_rzedu_10+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x156:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x157:
	LDS  R30,_abs_ster4
	LDS  R31,_abs_ster4+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x158:
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
SUBOPT_0x159:
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
	STS  _sek13,R30
	STS  _sek13+1,R30
	STS  _sek13+2,R30
	STS  _sek13+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 44 TIMES, CODE SIZE REDUCTION:83 WORDS
SUBOPT_0x15A:
	RCALL SUBOPT_0x10C
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x15B:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster3
	LDS  R27,_abs_ster3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x15C:
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0xEA

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x15D:
	CALL __EQW12
	MOV  R0,R30
	MOVW R30,R6
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15E:
	CALL __LTW12
	AND  R0,R30
	RJMP SUBOPT_0x15C

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x15F:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x160:
	LDS  R30,_abs_ster3
	LDS  R31,_abs_ster3+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x161:
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
SUBOPT_0x162:
	LDI  R30,LOW(0)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x163:
	AND  R0,R30
	RCALL SUBOPT_0x150
	RJMP SUBOPT_0xEA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x164:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xC2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x165:
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
SUBOPT_0x166:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _powrot_przedwczesny_krazek_scierny,R30
	STS  _powrot_przedwczesny_krazek_scierny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x167:
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x168:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x167

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x169:
	LDI  R30,LOW(0)
	STS  _powrot_przedwczesny_krazek_scierny,R30
	STS  _powrot_przedwczesny_krazek_scierny+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x16A:
	CALL __EQW12
	AND  R0,R30
	MOVW R30,R6
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x16B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x16C:
	RCALL SUBOPT_0x150
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16D:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x16C

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x16E:
	LDI  R30,LOW(0)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x16F:
	MOVW R30,R4
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RJMP SUBOPT_0x15D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x170:
	CALL __EQW12
	AND  R0,R30
	RJMP SUBOPT_0x15A

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x171:
	CALL __EQW12
	AND  R0,R30
	RJMP SUBOPT_0x14E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x172:
	CALL __EQW12
	AND  R0,R30
	LDS  R26,_powrot_przedwczesny_krazek_scierny
	LDS  R27,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x107

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x173:
	RCALL SUBOPT_0x150
	RJMP SUBOPT_0x107

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x174:
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x175:
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
SUBOPT_0x176:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x177:
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x178:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xC2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x179:
	LDI  R26,LOW(_szczotka_druc_cykl)
	LDI  R27,HIGH(_szczotka_druc_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x17A:
	LDS  R26,_statystyka
	LDS  R27,_statystyka+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17B:
	LDS  R30,_szczotka_druc_cykl
	LDS  R31,_szczotka_druc_cykl+1
	ST   -Y,R31
	ST   -Y,R30
	JMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17C:
	LDS  R30,_cykl_ilosc_zaciskow
	LDS  R31,_cykl_ilosc_zaciskow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17D:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xB6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17E:
	LDI  R26,LOW(_krazek_scierny_cykl)
	LDI  R27,HIGH(_krazek_scierny_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17F:
	LDS  R30,_krazek_scierny_cykl
	LDS  R31,_krazek_scierny_cykl+1
	RJMP SUBOPT_0x17D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x180:
	CALL __EQW12
	AND  R0,R30
	MOVW R30,R4
	RCALL SUBOPT_0x177
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x181:
	LDS  R30,_powrot_przedwczesny_krazek_scierny
	LDS  R31,_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x17D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x182:
	LDI  R30,LOW(0)
	STS  _sek21,R30
	STS  _sek21+1,R30
	STS  _sek21+2,R30
	STS  _sek21+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x183:
	LDS  R30,_wykonano_powrot_przedwczesny_krazek_scierny
	LDS  R31,_wykonano_powrot_przedwczesny_krazek_scierny+1
	RJMP SUBOPT_0x17D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x184:
	MOVW R30,R6
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x185:
	LDS  R30,_powrot_przedwczesny_druciak
	LDS  R31,_powrot_przedwczesny_druciak+1
	ST   -Y,R31
	ST   -Y,R30
	JMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x186:
	LDS  R30,_wykonano_powrot_przedwczesny_druciak
	LDS  R31,_wykonano_powrot_przedwczesny_druciak+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x187:
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
SUBOPT_0x188:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x189:
	LDI  R30,LOW(0)
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
	RJMP SUBOPT_0x17E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18A:
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	CP   R6,R26
	CPC  R7,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18B:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18C:
	LDI  R30,LOW(0)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x18D:
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
	RJMP SUBOPT_0xEA

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x18E:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0xEA

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x18F:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0x82

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x190:
	CALL __EQW12
	AND  R0,R30
	MOVW R30,R4
	RCALL SUBOPT_0x177
	CALL __EQW12
	AND  R30,R0
	MOV  R1,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	MOV  R0,R30
	RJMP SUBOPT_0x184

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x191:
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0xD1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x192:
	MOV  R22,R30
	MOV  R0,R30
	MOVW R30,R4
	RCALL SUBOPT_0x177
	RJMP SUBOPT_0x171

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x193:
	MOV  R1,R30
	MOV  R0,R22
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x194:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RJMP SUBOPT_0xC0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x195:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x196:
	LDI  R30,LOW(0)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x197:
	LDI  R30,LOW(0)
	STS  _cykl_ilosc_zaciskow,R30
	STS  _cykl_ilosc_zaciskow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x198:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x199:
	LDS  R30,_il_zaciskow_rzad_2
	LDS  R31,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19A:
	LDI  R30,LOW(0)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x19B:
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x19C:
	RCALL SUBOPT_0x114
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19D:
	RCALL SUBOPT_0x9E
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19E:
	MOV  R0,R30
	RCALL SUBOPT_0x114
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19F:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	RJMP SUBOPT_0x156

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A0:
	LDI  R30,LOW(0)
	STS  _sek13,R30
	STS  _sek13+1,R30
	STS  _sek13+2,R30
	STS  _sek13+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A1:
	MOVW R30,R4
	RCALL SUBOPT_0x177
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A2:
	MOV  R0,R30
	MOVW R26,R10
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	OR   R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A3:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0x19B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A4:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RJMP SUBOPT_0x107

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A5:
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A6:
	CALL __LTW12
	RJMP SUBOPT_0x1A5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A7:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x116

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A8:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	JMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A9:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1AA:
	RCALL SUBOPT_0x199
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x1AB:
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1AC:
	LDI  R30,LOW(0)
	STS  _sek12,R30
	STS  _sek12+1,R30
	STS  _sek12+2,R30
	STS  _sek12+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1AD:
	LDS  R30,_PORT_F
	ORI  R30,0x10
	RJMP SUBOPT_0xFE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1AE:
	CALL __LTW12
	MOV  R0,R30
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1AF:
	SBIW R30,2
	RCALL SUBOPT_0x1AB
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B0:
	SBIW R30,1
	RCALL SUBOPT_0x1AB
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B1:
	SBIW R30,2
	RCALL SUBOPT_0x1AB
	CALL __GEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B2:
	CALL __LTW12
	MOV  R0,R30
	RJMP SUBOPT_0x199

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x1B3:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B4:
	MOV  R0,R30
	LDS  R26,_cykl_glowny
	LDS  R27,_cykl_glowny+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B5:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_34)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_34)
	RJMP SUBOPT_0x1B3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B6:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_36)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_36)
	RJMP SUBOPT_0x1B3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B7:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_38)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_38)
	RJMP SUBOPT_0x1B3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B8:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_41)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_41)
	RJMP SUBOPT_0x1B3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B9:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h_43)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h_43)
	RJMP SUBOPT_0x1B3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1BA:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	RJMP SUBOPT_0x1AB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1BB:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1BC:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RCALL SUBOPT_0x1AB
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1BD:
	RCALL SUBOPT_0x199
	RCALL SUBOPT_0x1AB
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0x124
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1BE:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RJMP SUBOPT_0x19B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1BF:
	LDS  R26,_wykonalem_rzedow
	LDS  R27,_wykonalem_rzedow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C0:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	RJMP SUBOPT_0x198

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1C1:
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
SUBOPT_0x1C2:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C3:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C4:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	JMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C5:
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

__LTD12:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	LDI  R30,1
	BRLT __LTD12T
	CLR  R30
__LTD12T:
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
