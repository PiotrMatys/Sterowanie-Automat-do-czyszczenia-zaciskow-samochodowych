
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
	.DEF _rzad=R12

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
	.DB  0x0,0x57,0x63,0x7A,0x79,0x74,0x61,0x6E
	.DB  0x6F,0x20,0x70,0x6F,0x70,0x72,0x61,0x77
	.DB  0x6E,0x79,0x20,0x7A,0x61,0x63,0x69,0x73
	.DB  0x6B,0x0,0x43,0x69,0x73,0x6E,0x69,0x65
	.DB  0x6E,0x69,0x65,0x20,0x7A,0x61,0x20,0x6D
	.DB  0x61,0x6C,0x65,0x20,0x2D,0x20,0x6D,0x6E
	.DB  0x69,0x65,0x6A,0x73,0x7A,0x65,0x20,0x6E
	.DB  0x69,0x7A,0x20,0x36,0x20,0x62,0x61,0x72
	.DB  0x0,0x38,0x36,0x2D,0x30,0x31,0x37,0x30
	.DB  0x0,0x38,0x36,0x2D,0x31,0x30,0x34,0x33
	.DB  0x0,0x38,0x36,0x2D,0x31,0x36,0x37,0x35
	.DB  0x0,0x38,0x36,0x2D,0x32,0x30,0x39,0x38
	.DB  0x0,0x38,0x37,0x2D,0x30,0x31,0x37,0x30
	.DB  0x0,0x38,0x37,0x2D,0x31,0x30,0x34,0x33
	.DB  0x0,0x38,0x37,0x2D,0x31,0x36,0x37,0x35
	.DB  0x0,0x38,0x37,0x2D,0x32,0x30,0x39,0x38
	.DB  0x0,0x38,0x36,0x2D,0x30,0x31,0x39,0x32
	.DB  0x0,0x38,0x36,0x2D,0x31,0x30,0x35,0x34
	.DB  0x0,0x38,0x36,0x2D,0x31,0x36,0x37,0x36
	.DB  0x0,0x38,0x36,0x2D,0x32,0x31,0x33,0x32
	.DB  0x0,0x38,0x37,0x2D,0x30,0x31,0x39,0x32
	.DB  0x0,0x38,0x37,0x2D,0x31,0x30,0x35,0x34
	.DB  0x0,0x38,0x37,0x2D,0x31,0x36,0x37,0x36
	.DB  0x0,0x38,0x37,0x2D,0x32,0x31,0x33,0x32
	.DB  0x0,0x38,0x36,0x2D,0x30,0x31,0x39,0x33
	.DB  0x0,0x38,0x36,0x2D,0x31,0x32,0x31,0x36
	.DB  0x0,0x38,0x36,0x2D,0x31,0x38,0x33,0x32
	.DB  0x0,0x38,0x36,0x2D,0x32,0x31,0x37,0x34
	.DB  0x0,0x38,0x37,0x2D,0x30,0x31,0x39,0x33
	.DB  0x0,0x38,0x37,0x2D,0x31,0x32,0x31,0x36
	.DB  0x0,0x38,0x37,0x2D,0x31,0x38,0x33,0x32
	.DB  0x0,0x38,0x37,0x2D,0x32,0x31,0x37,0x34
	.DB  0x0,0x38,0x36,0x2D,0x30,0x31,0x39,0x34
	.DB  0x0,0x38,0x36,0x2D,0x31,0x33,0x34,0x31
	.DB  0x0,0x38,0x36,0x2D,0x31,0x38,0x33,0x33
	.DB  0x0,0x38,0x36,0x2D,0x32,0x31,0x38,0x30
	.DB  0x0,0x38,0x37,0x2D,0x30,0x31,0x39,0x34
	.DB  0x0,0x38,0x37,0x2D,0x31,0x33,0x34,0x31
	.DB  0x0,0x38,0x37,0x2D,0x31,0x38,0x33,0x33
	.DB  0x0,0x38,0x37,0x2D,0x32,0x31,0x38,0x30
	.DB  0x0,0x38,0x36,0x2D,0x30,0x36,0x36,0x33
	.DB  0x0,0x38,0x36,0x2D,0x31,0x33,0x34,0x39
	.DB  0x0,0x38,0x36,0x2D,0x31,0x38,0x33,0x34
	.DB  0x0,0x38,0x36,0x2D,0x32,0x32,0x30,0x34
	.DB  0x0,0x38,0x37,0x2D,0x30,0x36,0x36,0x33
	.DB  0x0,0x38,0x37,0x2D,0x31,0x33,0x34,0x39
	.DB  0x0,0x38,0x37,0x2D,0x31,0x38,0x33,0x34
	.DB  0x0,0x38,0x37,0x2D,0x32,0x32,0x30,0x34
	.DB  0x0,0x38,0x36,0x2D,0x30,0x37,0x36,0x38
	.DB  0x0,0x38,0x36,0x2D,0x31,0x33,0x35,0x37
	.DB  0x0,0x38,0x36,0x2D,0x31,0x38,0x34,0x38
	.DB  0x0,0x38,0x36,0x2D,0x32,0x32,0x31,0x32
	.DB  0x0,0x38,0x37,0x2D,0x30,0x37,0x36,0x38
	.DB  0x0,0x38,0x37,0x2D,0x31,0x33,0x35,0x37
	.DB  0x0,0x38,0x37,0x2D,0x31,0x38,0x34,0x38
	.DB  0x0,0x38,0x37,0x2D,0x32,0x32,0x31,0x32
	.DB  0x0,0x38,0x36,0x2D,0x30,0x38,0x30,0x30
	.DB  0x0,0x38,0x36,0x2D,0x31,0x33,0x36,0x33
	.DB  0x0,0x38,0x36,0x2D,0x31,0x39,0x30,0x34
	.DB  0x0,0x38,0x36,0x2D,0x32,0x32,0x34,0x31
	.DB  0x0,0x38,0x37,0x2D,0x30,0x38,0x30,0x30
	.DB  0x0,0x38,0x37,0x2D,0x31,0x33,0x36,0x33
	.DB  0x0,0x38,0x37,0x2D,0x31,0x39,0x30,0x34
	.DB  0x0,0x38,0x37,0x2D,0x32,0x32,0x34,0x31
	.DB  0x0,0x38,0x36,0x2D,0x30,0x38,0x31,0x31
	.DB  0x0,0x38,0x36,0x2D,0x31,0x35,0x32,0x33
	.DB  0x0,0x38,0x36,0x2D,0x31,0x39,0x32,0x39
	.DB  0x0,0x38,0x36,0x2D,0x32,0x32,0x36,0x31
	.DB  0x0,0x38,0x37,0x2D,0x30,0x38,0x31,0x31
	.DB  0x0,0x38,0x37,0x2D,0x31,0x35,0x32,0x33
	.DB  0x0,0x38,0x37,0x2D,0x31,0x39,0x32,0x39
	.DB  0x0,0x38,0x37,0x2D,0x32,0x32,0x36,0x31
	.DB  0x0,0x38,0x36,0x2D,0x30,0x38,0x31,0x34
	.DB  0x0,0x38,0x36,0x2D,0x31,0x35,0x33,0x30
	.DB  0x0,0x38,0x36,0x2D,0x31,0x39,0x33,0x36
	.DB  0x0,0x38,0x36,0x2D,0x32,0x32,0x38,0x35
	.DB  0x0,0x38,0x37,0x2D,0x30,0x38,0x31,0x34
	.DB  0x0,0x38,0x37,0x2D,0x31,0x35,0x33,0x30
	.DB  0x0,0x38,0x37,0x2D,0x31,0x39,0x33,0x36
	.DB  0x0,0x38,0x37,0x2D,0x32,0x32,0x38,0x35
	.DB  0x0,0x38,0x36,0x2D,0x30,0x38,0x31,0x35
	.DB  0x0,0x38,0x36,0x2D,0x31,0x35,0x35,0x31
	.DB  0x0,0x38,0x36,0x2D,0x31,0x39,0x34,0x31
	.DB  0x0,0x38,0x36,0x2D,0x32,0x32,0x38,0x36
	.DB  0x0,0x38,0x37,0x2D,0x30,0x38,0x31,0x35
	.DB  0x0,0x38,0x37,0x2D,0x31,0x35,0x35,0x31
	.DB  0x0,0x38,0x37,0x2D,0x31,0x39,0x34,0x31
	.DB  0x0,0x38,0x37,0x2D,0x32,0x32,0x38,0x36
	.DB  0x0,0x38,0x36,0x2D,0x30,0x38,0x31,0x36
	.DB  0x0,0x38,0x36,0x2D,0x31,0x35,0x35,0x32
	.DB  0x0,0x38,0x36,0x2D,0x32,0x30,0x30,0x37
	.DB  0x0,0x38,0x36,0x2D,0x32,0x32,0x39,0x32
	.DB  0x0,0x38,0x37,0x2D,0x30,0x38,0x31,0x36
	.DB  0x0,0x38,0x37,0x2D,0x31,0x35,0x35,0x32
	.DB  0x0,0x38,0x37,0x2D,0x32,0x30,0x30,0x37
	.DB  0x0,0x38,0x37,0x2D,0x32,0x32,0x39,0x32
	.DB  0x0,0x38,0x36,0x2D,0x30,0x38,0x31,0x37
	.DB  0x0,0x38,0x36,0x2D,0x31,0x36,0x30,0x32
	.DB  0x0,0x38,0x36,0x2D,0x32,0x30,0x31,0x37
	.DB  0x0,0x38,0x36,0x2D,0x32,0x33,0x38,0x34
	.DB  0x0,0x38,0x37,0x2D,0x30,0x38,0x31,0x37
	.DB  0x0,0x38,0x37,0x2D,0x31,0x36,0x30,0x32
	.DB  0x0,0x38,0x37,0x2D,0x32,0x30,0x31,0x37
	.DB  0x0,0x38,0x37,0x2D,0x32,0x33,0x38,0x34
	.DB  0x0,0x38,0x36,0x2D,0x30,0x38,0x34,0x37
	.DB  0x0,0x38,0x36,0x2D,0x31,0x36,0x32,0x30
	.DB  0x0,0x38,0x36,0x2D,0x32,0x30,0x31,0x39
	.DB  0x0,0x38,0x36,0x2D,0x32,0x33,0x38,0x35
	.DB  0x0,0x38,0x37,0x2D,0x30,0x38,0x34,0x37
	.DB  0x0,0x38,0x37,0x2D,0x31,0x36,0x32,0x30
	.DB  0x0,0x38,0x37,0x2D,0x32,0x30,0x31,0x39
	.DB  0x0,0x38,0x37,0x2D,0x32,0x33,0x38,0x35
	.DB  0x0,0x38,0x36,0x2D,0x30,0x38,0x35,0x34
	.DB  0x0,0x38,0x36,0x2D,0x31,0x36,0x32,0x32
	.DB  0x0,0x38,0x36,0x2D,0x32,0x30,0x32,0x38
	.DB  0x0,0x38,0x36,0x2D,0x32,0x34,0x33,0x37
	.DB  0x0,0x38,0x37,0x2D,0x30,0x38,0x35,0x34
	.DB  0x0,0x38,0x37,0x2D,0x31,0x36,0x32,0x32
	.DB  0x0,0x38,0x37,0x2D,0x32,0x30,0x32,0x38
	.DB  0x0,0x38,0x37,0x2D,0x32,0x34,0x33,0x37
	.DB  0x0,0x38,0x36,0x2D,0x30,0x38,0x36,0x32
	.DB  0x0,0x38,0x36,0x2D,0x31,0x36,0x32,0x35
	.DB  0x0,0x38,0x36,0x2D,0x32,0x30,0x35,0x32
	.DB  0x0,0x38,0x36,0x2D,0x32,0x34,0x39,0x32
	.DB  0x0,0x38,0x37,0x2D,0x30,0x38,0x36,0x32
	.DB  0x0,0x38,0x37,0x2D,0x31,0x36,0x32,0x35
	.DB  0x0,0x38,0x37,0x2D,0x32,0x30,0x35,0x32
	.DB  0x0,0x38,0x37,0x2D,0x32,0x34,0x39,0x32
	.DB  0x0,0x38,0x36,0x2D,0x30,0x39,0x33,0x35
	.DB  0x0,0x38,0x36,0x2D,0x31,0x36,0x34,0x38
	.DB  0x0,0x38,0x36,0x2D,0x32,0x30,0x38,0x32
	.DB  0x0,0x38,0x36,0x2D,0x32,0x35,0x30,0x30
	.DB  0x0,0x38,0x37,0x2D,0x30,0x39,0x33,0x35
	.DB  0x0,0x38,0x37,0x2D,0x31,0x36,0x34,0x38
	.DB  0x0,0x38,0x37,0x2D,0x32,0x30,0x38,0x32
	.DB  0x0,0x38,0x37,0x2D,0x32,0x35,0x30,0x30
	.DB  0x0,0x38,0x36,0x2D,0x31,0x30,0x31,0x39
	.DB  0x0,0x38,0x36,0x2D,0x31,0x36,0x34,0x39
	.DB  0x0,0x38,0x36,0x2D,0x32,0x30,0x38,0x33
	.DB  0x0,0x38,0x36,0x2D,0x32,0x35,0x38,0x35
	.DB  0x0,0x38,0x37,0x2D,0x31,0x30,0x31,0x39
	.DB  0x0,0x38,0x37,0x2D,0x31,0x36,0x34,0x39
	.DB  0x0,0x38,0x37,0x2D,0x32,0x30,0x38,0x33
	.DB  0x0,0x38,0x37,0x2D,0x32,0x36,0x32,0x34
	.DB  0x0,0x38,0x36,0x2D,0x31,0x30,0x32,0x37
	.DB  0x0,0x38,0x36,0x2D,0x31,0x36,0x36,0x39
	.DB  0x0,0x38,0x36,0x2D,0x32,0x30,0x38,0x37
	.DB  0x0,0x38,0x36,0x2D,0x32,0x36,0x32,0x34
	.DB  0x0,0x38,0x37,0x2D,0x31,0x30,0x32,0x37
	.DB  0x0,0x38,0x37,0x2D,0x31,0x36,0x36,0x39
	.DB  0x0,0x38,0x37,0x2D,0x32,0x30,0x38,0x37
	.DB  0x0,0x38,0x37,0x2D,0x32,0x35,0x38,0x35
	.DB  0x0,0x4E,0x69,0x65,0x20,0x77,0x63,0x7A
	.DB  0x79,0x74,0x61,0x6E,0x6F,0x20,0x7A,0x61
	.DB  0x63,0x69,0x73,0x6B,0x75,0x0,0x50,0x6F
	.DB  0x7A,0x79,0x63,0x6A,0x6F,0x6E,0x75,0x6A
	.DB  0x65,0x20,0x75,0x6B,0x6C,0x61,0x64,0x79
	.DB  0x20,0x6C,0x69,0x6E,0x69,0x6F,0x77,0x65
	.DB  0x20,0x58,0x59,0x5A,0x0,0x53,0x74,0x65
	.DB  0x72,0x6F,0x77,0x6E,0x69,0x6B,0x20,0x31
	.DB  0x20,0x2D,0x20,0x77,0x79,0x70,0x6F,0x7A
	.DB  0x79,0x63,0x6A,0x6F,0x6E,0x6F,0x77,0x61
	.DB  0x6C,0x65,0x6D,0x0,0x53,0x74,0x65,0x72
	.DB  0x6F,0x77,0x6E,0x69,0x6B,0x20,0x32,0x20
	.DB  0x2D,0x20,0x77,0x79,0x70,0x6F,0x7A,0x79
	.DB  0x63,0x6A,0x6F,0x6E,0x6F,0x77,0x61,0x6C
	.DB  0x65,0x6D,0x0,0x53,0x74,0x65,0x72,0x6F
	.DB  0x77,0x6E,0x69,0x6B,0x20,0x33,0x20,0x2D
	.DB  0x20,0x77,0x79,0x70,0x6F,0x7A,0x79,0x63
	.DB  0x6A,0x6F,0x6E,0x6F,0x77,0x61,0x6C,0x65
	.DB  0x6D,0x0,0x53,0x74,0x65,0x72,0x6F,0x77
	.DB  0x6E,0x69,0x6B,0x20,0x34,0x20,0x2D,0x20
	.DB  0x77,0x79,0x70,0x6F,0x7A,0x79,0x63,0x6A
	.DB  0x6F,0x6E,0x6F,0x77,0x61,0x6C,0x65,0x6D
	.DB  0x0,0x57,0x79,0x70,0x6F,0x7A,0x79,0x63
	.DB  0x6A,0x6F,0x6E,0x6F,0x77,0x61,0x6E,0x6F
	.DB  0x20,0x75,0x6B,0x6C,0x61,0x64,0x79,0x20
	.DB  0x6C,0x69,0x6E,0x69,0x6F,0x77,0x65,0x20
	.DB  0x58,0x59,0x5A,0x0,0x50,0x72,0x7A,0x65
	.DB  0x63,0x69,0x61,0x7A,0x65,0x6E,0x69,0x61
	.DB  0x20,0x4C,0x45,0x46,0x53,0x33,0x32,0x5F
	.DB  0x31,0x0,0x50,0x72,0x7A,0x65,0x63,0x69
	.DB  0x61,0x7A,0x65,0x6E,0x69,0x61,0x20,0x4C
	.DB  0x45,0x46,0x53,0x33,0x32,0x5F,0x32,0x0
	.DB  0x50,0x72,0x7A,0x65,0x63,0x69,0x61,0x7A
	.DB  0x65,0x6E,0x69,0x61,0x20,0x4C,0x45,0x46
	.DB  0x53,0x5F,0x58,0x59,0x5F,0x32,0x0,0x50
	.DB  0x72,0x7A,0x65,0x63,0x69,0x61,0x7A,0x65
	.DB  0x6E,0x69,0x61,0x20,0x4C,0x45,0x46,0x53
	.DB  0x5F,0x58,0x59,0x5F,0x31,0x0
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
;// Get a character from the USART1 Receiver
;#pragma used+
;char getchar1(void)
; 0000 0023 {

	.CSEG
; 0000 0024 unsigned char status;
; 0000 0025 char data;
; 0000 0026 while (1)
;	status -> R17
;	data -> R16
; 0000 0027       {
; 0000 0028       while (((status=UCSR1A) & RX_COMPLETE)==0);
; 0000 0029       data=UDR1;
; 0000 002A       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
; 0000 002B          return data;
; 0000 002C       }
; 0000 002D }
;#pragma used-
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 0033 {
; 0000 0034 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
; 0000 0035 UDR1=c;
; 0000 0036 }
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
; 0000 0047 #endasm
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
;BB PORT_F;
;BB PORTHH,PORT_CZYTNIK;
;BB PORTJJ,PORTKK,PORTLL,PORTMM;
;BB PORT_STER3,PORT_STER4;
;int xxx;
;
;int nr_zacisku,odczytalem_zacisk,il_prob_odczytu;
;int macierz_zaciskow[3];
;long int sek1,sek2,sek3,sek4,sek5,sek6,sek7,sek8,sek9,sek10,sek11,sek12;
;int rzad;
;int start;
;int cykl;
;int aaa,bbb,ccc,ddd;
;int pozycjonowanie_LEFS32_300_1;
;int pozycjonowanie_LEFS32_300_2;
;int il_zaciskow_rzad_1,il_zaciskow_rzad_2;
;int cykl_sterownik_1,cykl_sterownik_3,cykl_sterownik_2,cykl_sterownik_4;
;int adr1,adr2,adr3,adr4;
;int cykl_sterownik_3_wykonalem;
;int szczotka_druciana_ilosc_cykli;
;int szczotka_druc_cykl;
;int cykl_glowny;
;int start_kontynuacja;
;int ruch_zlozony;
;int krazek_scierny_cykl_po_okregu;
;int krazek_scierny_cykl_po_okregu_ilosc;
;int krazek_scierny_cykl;
;int krazek_scierny_ilosc_cykli;
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
;
;char sprawdz_pin0(BB PORT, int numer_pcf)
; 0000 0083 {
_sprawdz_pin0:
; 0000 0084 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0085 i2c_write(numer_pcf);
; 0000 0086 PORT.byte = i2c_read(0);
; 0000 0087 i2c_stop();
; 0000 0088 
; 0000 0089 
; 0000 008A return PORT.bits.b0;
	RJMP _0x20A0004
; 0000 008B }
;
;char sprawdz_pin1(BB PORT, int numer_pcf)
; 0000 008E {
_sprawdz_pin1:
; 0000 008F i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0090 i2c_write(numer_pcf);
; 0000 0091 PORT.byte = i2c_read(0);
; 0000 0092 i2c_stop();
; 0000 0093 
; 0000 0094 
; 0000 0095 return PORT.bits.b1;
	LSR  R30
	RJMP _0x20A0004
; 0000 0096 }
;
;
;char sprawdz_pin2(BB PORT, int numer_pcf)
; 0000 009A {
_sprawdz_pin2:
; 0000 009B i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 009C i2c_write(numer_pcf);
; 0000 009D PORT.byte = i2c_read(0);
; 0000 009E i2c_stop();
; 0000 009F 
; 0000 00A0 
; 0000 00A1 return PORT.bits.b2;
	LSR  R30
	LSR  R30
	RJMP _0x20A0004
; 0000 00A2 }
;
;char sprawdz_pin3(BB PORT, int numer_pcf)
; 0000 00A5 {
_sprawdz_pin3:
; 0000 00A6 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00A7 i2c_write(numer_pcf);
; 0000 00A8 PORT.byte = i2c_read(0);
; 0000 00A9 i2c_stop();
; 0000 00AA 
; 0000 00AB 
; 0000 00AC return PORT.bits.b3;
	LSR  R30
	LSR  R30
	LSR  R30
	RJMP _0x20A0004
; 0000 00AD }
;
;char sprawdz_pin4(BB PORT, int numer_pcf)
; 0000 00B0 {
_sprawdz_pin4:
; 0000 00B1 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00B2 i2c_write(numer_pcf);
; 0000 00B3 PORT.byte = i2c_read(0);
; 0000 00B4 i2c_stop();
; 0000 00B5 
; 0000 00B6 
; 0000 00B7 return PORT.bits.b4;
	SWAP R30
	RJMP _0x20A0004
; 0000 00B8 }
;
;char sprawdz_pin5(BB PORT, int numer_pcf)
; 0000 00BB {
_sprawdz_pin5:
; 0000 00BC i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00BD i2c_write(numer_pcf);
; 0000 00BE PORT.byte = i2c_read(0);
; 0000 00BF i2c_stop();
; 0000 00C0 
; 0000 00C1 
; 0000 00C2 return PORT.bits.b5;
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	RJMP _0x20A0004
; 0000 00C3 }
;
;char sprawdz_pin6(BB PORT, int numer_pcf)
; 0000 00C6 {
_sprawdz_pin6:
; 0000 00C7 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00C8 i2c_write(numer_pcf);
; 0000 00C9 PORT.byte = i2c_read(0);
; 0000 00CA i2c_stop();
; 0000 00CB 
; 0000 00CC 
; 0000 00CD return PORT.bits.b6;
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	RJMP _0x20A0004
; 0000 00CE }
;
;char sprawdz_pin7(BB PORT, int numer_pcf)
; 0000 00D1 {
_sprawdz_pin7:
; 0000 00D2 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00D3 i2c_write(numer_pcf);
; 0000 00D4 PORT.byte = i2c_read(0);
; 0000 00D5 i2c_stop();
; 0000 00D6 
; 0000 00D7 
; 0000 00D8 return PORT.bits.b7;
	ROL  R30
	LDI  R30,0
	ROL  R30
_0x20A0004:
	ANDI R30,LOW(0x1)
	ADIW R28,3
	RET
; 0000 00D9 }
;
;int odczytaj_parametr(int adres1, int adres2)
; 0000 00DC {
_odczytaj_parametr:
; 0000 00DD int z;
; 0000 00DE z = 0;
	ST   -Y,R17
	ST   -Y,R16
;	adres1 -> Y+4
;	adres2 -> Y+2
;	z -> R16,R17
	__GETWRN 16,17,0
; 0000 00DF putchar(90);
	CALL SUBOPT_0x1
; 0000 00E0 putchar(165);
; 0000 00E1 putchar(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _putchar
; 0000 00E2 putchar(131);
	LDI  R30,LOW(131)
	CALL SUBOPT_0x2
; 0000 00E3 putchar(adres1);
; 0000 00E4 putchar(adres2);
; 0000 00E5 putchar(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar
; 0000 00E6 getchar();
	CALL SUBOPT_0x3
; 0000 00E7 getchar();
; 0000 00E8 getchar();
; 0000 00E9 getchar();
	CALL SUBOPT_0x3
; 0000 00EA getchar();
; 0000 00EB getchar();
; 0000 00EC getchar();
	CALL SUBOPT_0x3
; 0000 00ED getchar();
; 0000 00EE z = getchar();
	MOV  R16,R30
	CLR  R17
; 0000 00EF 
; 0000 00F0 
; 0000 00F1 
; 0000 00F2 
; 0000 00F3 
; 0000 00F4 
; 0000 00F5 
; 0000 00F6 
; 0000 00F7 
; 0000 00F8 
; 0000 00F9 
; 0000 00FA 
; 0000 00FB return z;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0003
; 0000 00FC }
;
;
;
;int czekaj_na_guzik_start(int adres)
; 0000 0101 {
; 0000 0102 //48 to adres zmiennej 30
; 0000 0103 //16 to adres zmiennj 10
; 0000 0104 
; 0000 0105 int z;
; 0000 0106 z = 0;
;	adres -> Y+2
;	z -> R16,R17
; 0000 0107 putchar(90);
; 0000 0108 putchar(165);
; 0000 0109 putchar(4);
; 0000 010A putchar(131);
; 0000 010B putchar(0);
; 0000 010C putchar(adres);  //adres zmiennej - 30
; 0000 010D putchar(1);
; 0000 010E getchar();
; 0000 010F getchar();
; 0000 0110 getchar();
; 0000 0111 getchar();
; 0000 0112 getchar();
; 0000 0113 getchar();
; 0000 0114 getchar();
; 0000 0115 getchar();
; 0000 0116 z = getchar();
; 0000 0117 //itoa(z,dupa1);
; 0000 0118 //lcd_puts(dupa1);
; 0000 0119 
; 0000 011A return z;
; 0000 011B }
;
;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0122 {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0123 // Place your code here
; 0000 0124 //16,384 ms
; 0000 0125 sek1++;     //Ster 1
	LDI  R26,LOW(_sek1)
	LDI  R27,HIGH(_sek1)
	CALL SUBOPT_0x4
; 0000 0126 sek2++;     //ster 3
	LDI  R26,LOW(_sek2)
	LDI  R27,HIGH(_sek2)
	CALL SUBOPT_0x4
; 0000 0127 
; 0000 0128 
; 0000 0129 sek3++;     //ster 2
	LDI  R26,LOW(_sek3)
	LDI  R27,HIGH(_sek3)
	CALL SUBOPT_0x4
; 0000 012A sek4++;     //ster 4
	LDI  R26,LOW(_sek4)
	LDI  R27,HIGH(_sek4)
	CALL SUBOPT_0x4
; 0000 012B 
; 0000 012C 
; 0000 012D //sek10++;
; 0000 012E 
; 0000 012F sek11++;  //do wyboru zacisku
	LDI  R26,LOW(_sek11)
	LDI  R27,HIGH(_sek11)
	CALL SUBOPT_0x4
; 0000 0130 sek12++;  //do czasu przedmuchu
	LDI  R26,LOW(_sek12)
	LDI  R27,HIGH(_sek12)
	CALL SUBOPT_0x4
; 0000 0131 }
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
; 0000 013A {
_komunikat_na_panel:
; 0000 013B int h;
; 0000 013C 
; 0000 013D h = 0;
	ST   -Y,R17
	ST   -Y,R16
;	*fmtstr -> Y+6
;	adres2 -> Y+4
;	adres22 -> Y+2
;	h -> R16,R17
	__GETWRN 16,17,0
; 0000 013E h = strlenf(fmtstr);
	CALL SUBOPT_0x5
	CALL _strlenf
	MOVW R16,R30
; 0000 013F h = h + 3;
	__ADDWRN 16,17,3
; 0000 0140 
; 0000 0141 putchar(90);
	CALL SUBOPT_0x1
; 0000 0142 putchar(165);
; 0000 0143 putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL _putchar
; 0000 0144 putchar(130);  //82
	LDI  R30,LOW(130)
	CALL SUBOPT_0x2
; 0000 0145 putchar(adres2);    //
; 0000 0146 putchar(adres22);  //
; 0000 0147 printf(fmtstr);
	CALL SUBOPT_0x5
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 0148 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;
;void wartosc_parametru_panelu(int wartosc, int adres1, int adres2)
; 0000 014B {
_wartosc_parametru_panelu:
; 0000 014C putchar(90);  //5A
;	wartosc -> Y+4
;	adres1 -> Y+2
;	adres2 -> Y+0
	CALL SUBOPT_0x1
; 0000 014D putchar(165); //A5
; 0000 014E putchar(5);//05
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL SUBOPT_0x6
; 0000 014F putchar(130);  //82    /
; 0000 0150 putchar(adres1);    //00
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
; 0000 0151 putchar(adres2);   //40
	LD   R30,Y
	ST   -Y,R30
	CALL _putchar
; 0000 0152 putchar(0);    //00
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
; 0000 0153 putchar(wartosc);   //80
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _putchar
; 0000 0154 }
_0x20A0003:
	ADIW R28,6
	RET
;
;void komunikat_z_czytnika_kodow(char flash *fmtstr,int rzad)
; 0000 0157 {
_komunikat_z_czytnika_kodow:
; 0000 0158 int h, adres1,adres11,adres2,adres22;
; 0000 0159 
; 0000 015A h = 0;
	SBIW R28,4
	CALL __SAVELOCR6
;	*fmtstr -> Y+12
;	rzad -> Y+10
;	h -> R16,R17
;	adres1 -> R18,R19
;	adres11 -> R20,R21
;	adres2 -> Y+8
;	adres22 -> Y+6
	__GETWRN 16,17,0
; 0000 015B h = strlenf(fmtstr);
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOVW R16,R30
; 0000 015C h = h + 3;
	__ADDWRN 16,17,3
; 0000 015D 
; 0000 015E if(rzad == 1)
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,1
	BRNE _0xD
; 0000 015F    {
; 0000 0160    adres1 = 0;
	__GETWRN 18,19,0
; 0000 0161    adres11 = 80;
	__GETWRN 20,21,80
; 0000 0162    adres2 = 80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0163    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 0164    }
; 0000 0165 if(rzad == 2)
_0xD:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,2
	BRNE _0xE
; 0000 0166    {
; 0000 0167    adres1 = 0;
	__GETWRN 18,19,0
; 0000 0168    adres11 = 32;
	__GETWRN 20,21,32
; 0000 0169    adres2 = 64;
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 016A    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 016B    }
; 0000 016C 
; 0000 016D putchar(90);
_0xE:
	CALL SUBOPT_0x1
; 0000 016E putchar(165);
; 0000 016F putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL SUBOPT_0x6
; 0000 0170 putchar(130);  //82
; 0000 0171 putchar(adres1);    //
	ST   -Y,R18
	CALL _putchar
; 0000 0172 putchar(adres11);  //
	ST   -Y,R20
	CALL _putchar
; 0000 0173 printf(fmtstr);
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 0174 
; 0000 0175 komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	CALL SUBOPT_0x8
	RCALL _komunikat_na_panel
; 0000 0176 komunikat_na_panel("Wczytano poprawny zacisk",adres2,adres22);
	__POINTW1FN _0x0,49
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	CALL SUBOPT_0x8
	RCALL _komunikat_na_panel
; 0000 0177 
; 0000 0178 }
	CALL __LOADLOCR6
	ADIW R28,14
	RET
;
;
;
;
;void wyrrrjscia_i_wejscia_opis()
; 0000 017E {
; 0000 017F 
; 0000 0180 
; 0000 0181 //IN0
; 0000 0182 
; 0000 0183 //komunikacja miedzy slave a master
; 0000 0184 //sprawdz_pin0(PORTHH,0x73)
; 0000 0185 //sprawdz_pin1(PORTHH,0x73)
; 0000 0186 //sprawdz_pin2(PORTHH,0x73)
; 0000 0187 //sprawdz_pin3(PORTHH,0x73)
; 0000 0188 //sprawdz_pin4(PORTHH,0x73)
; 0000 0189 //sprawdz_pin5(PORTHH,0x73)
; 0000 018A //sprawdz_pin6(PORTHH,0x73)
; 0000 018B //sprawdz_pin7(PORTHH,0x73)
; 0000 018C 
; 0000 018D //IN1
; 0000 018E //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 018F //sprawdz_pin1(PORTJJ,0x79)  AREA   STEROWNIK1
; 0000 0190 //sprawdz_pin2(PORTJJ,0x79)  SETON  STEROWNIK1
; 0000 0191 //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 0192 //sprawdz_pin4(PORTJJ,0x79)  SVRE   STEROWNIK1
; 0000 0193 //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 0194 //sprawdz_pin6(PORTJJ,0x79)  czujnik cisnienia
; 0000 0195 //sprawdz_pin7(PORTJJ,0x79)
; 0000 0196 
; 0000 0197 //IN2
; 0000 0198 //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 0199 //sprawdz_pin1(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK3
; 0000 019A //sprawdz_pin2(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK3
; 0000 019B //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 019C //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 019D //sprawdz_pin5(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK4
; 0000 019E //sprawdz_pin6(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK4
; 0000 019F //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 01A0 
; 0000 01A1 //IN3
; 0000 01A2 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 01A3 //sprawdz_pin1(PORTLL,0x71)  AREA   STEROWNIK2
; 0000 01A4 //sprawdz_pin2(PORTLL,0x71)  SETON  STEROWNIK2
; 0000 01A5 //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 01A6 //sprawdz_pin4(PORTLL,0x71)  SVRE   STEROWNIK2
; 0000 01A7 //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 01A8 //sprawdz_pin6(PORTLL,0x71)  S6A przek³adanie rzedow
; 0000 01A9 //sprawdz_pin7(PORTLL,0x71)  S6B przekladanie rzedow
; 0000 01AA 
; 0000 01AB //IN4
; 0000 01AC //sprawdz_pin0(PORTMM,0x77)
; 0000 01AD //sprawdz_pin1(PORTMM,0x77)
; 0000 01AE //sprawdz_pin2(PORTMM,0x77)
; 0000 01AF //sprawdz_pin3(PORTMM,0x77)
; 0000 01B0 //sprawdz_pin4(PORTMM,0x77)
; 0000 01B1 //sprawdz_pin5(PORTMM,0x77)
; 0000 01B2 //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 01B3 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 01B4 
; 0000 01B5 //KARTA IN4 PRZEPINAM Z PORTE NA PORTF (BO RS232)
; 0000 01B6 
; 0000 01B7 
; 0000 01B8 //sterownik 1
; 0000 01B9 //sterownik 3 - szczotka papierowa
; 0000 01BA 
; 0000 01BB //sterownik 2 - druciak
; 0000 01BC ///sterownik 4 - druciak
; 0000 01BD 
; 0000 01BE 
; 0000 01BF //OUT
; 0000 01C0 //PORTA.0   IN0  STEROWNIK1        OUT 1
; 0000 01C1 //PORTA.1   IN1  STEROWNIK1
; 0000 01C2 //PORTA.2   IN2  STEROWNIK1
; 0000 01C3 //PORTA.3   IN3  STEROWNIK1
; 0000 01C4 //PORTA.4   IN4  STEROWNIK1
; 0000 01C5 //PORTA.5   IN5  STEROWNIK1
; 0000 01C6 //PORTA.6   IN6  STEROWNIK1
; 0000 01C7 //PORTA.7   IN7  STEROWNIK1
; 0000 01C8 
; 0000 01C9 //str 83, pin 6 dodac do obu sterownikow
; 0000 01CA 
; 0000 01CB 
; 0000 01CC //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 01CD //PORTB.1   IN1  STEROWNIK4
; 0000 01CE //PORTB.2   IN2  STEROWNIK4
; 0000 01CF //PORTB.3   IN3  STEROWNIK4
; 0000 01D0 //PORTB.4   4B CEWKA
; 0000 01D1 //PORTB.5   DRIVE  STEROWNIK4
; 0000 01D2 //PORTB.6   ///////////////////////////////swiatlo zielone
; 0000 01D3 //PORTB.7   IN5 STEROWNIK 3
; 0000 01D4 
; 0000 01D5 //PORTC.0   IN0  STEROWNIK2        OUT 3
; 0000 01D6 //PORTC.1   IN1  STEROWNIK2
; 0000 01D7 //PORTC.2   IN2  STEROWNIK2
; 0000 01D8 //PORTC.3   IN3  STEROWNIK2
; 0000 01D9 //PORTC.4   IN4  STEROWNIK2
; 0000 01DA //PORTC.5   IN5  STEROWNIK2
; 0000 01DB //PORTC.6   IN6  STEROWNIK2
; 0000 01DC //PORTC.7   IN7  STEROWNIK2
; 0000 01DD 
; 0000 01DE //PORTD.0      SDA                 OUT 2
; 0000 01DF //PORTD.1      SCL
; 0000 01E0 //PORTD.2  SETUP   STEROWNIK1 STEROWNIK 2 STEROIWNIK 3 STEROWNIK 4
; 0000 01E1 //PORTD.3  DRIVE   STEROWNIK1
; 0000 01E2 //PORTD.4  IN8 STEROWNIK1
; 0000 01E3 //PORTD.5  IN8 STEROWNIK2
; 0000 01E4 //PORTD.6  DRIVE   STEROWNIK2
; 0000 01E5 //PORTD.7  ///////////////////////////////swiatlo czerwone
; 0000 01E6 
; 0000 01E7 //PORTE.0
; 0000 01E8 //PORTE.1
; 0000 01E9 //PORTE.2  1A CEWKA                     OUT 6
; 0000 01EA //PORTE.3  1B CEWKA
; 0000 01EB //PORTE.4  IN4  STEROWNIK4
; 0000 01EC //PORTE.5  IN5  STEROWNIK4
; 0000 01ED //PORTE.6  2A CEWKA
; 0000 01EE //PORTE.7  3A CEWKA
; 0000 01EF 
; 0000 01F0 //PORTF.0   IN0  STEROWNIK3             OUT 4
; 0000 01F1 //PORTF.1   IN1  STEROWNIK3
; 0000 01F2 //PORTF.2   IN2  STEROWNIK3
; 0000 01F3 //PORTF.3   IN3  STEROWNIK3
; 0000 01F4 //PORTF.4   4A CEWKA
; 0000 01F5 //PORTF.5   DRIVE  STEROWNIK3
; 0000 01F6 //PORTF.6   /////////////////////////////////swiatlo zolte
; 0000 01F7 //PORTF.7   //IN4 STEROWNIK 3
; 0000 01F8 
; 0000 01F9 
; 0000 01FA //POPRAWIC STEROWNIK PRACE ZGODNIE Z OPISEM ZE STRONY 59 - POWINIENEM SPRAWDZIC CZY INP JEST ON A DOPIERO POTEM BUSY
; 0000 01FB //CZY SIE WYLACZYL
; 0000 01FC //FAJNIE ROBIE Z TYM CZEKAIEM 1S
; 0000 01FD 
; 0000 01FE //PODPIAC JESZCZE HOLD WSZYSTKIE DO JEDNEGO
; 0000 01FF 
; 0000 0200 
; 0000 0201 // macierz_zaciskow[rzad]=44; brak
; 0000 0202 
; 0000 0203 //macierz_zaciskow[rzad]=48; brak
; 0000 0204 
; 0000 0205 //macierz_zaciskow[rzad]=76  brak
; 0000 0206 
; 0000 0207 //komunikat_z_czytnika_kodow("87-2286",rzad); brak
; 0000 0208 //macierz_zaciskow[rzad]=80;
; 0000 0209 
; 0000 020A // komunikat_z_czytnika_kodow("86-2384",rzad);
; 0000 020B // macierz_zaciskow[rzad]=92;
; 0000 020C 
; 0000 020D //  komunikat_z_czytnika_kodow("87-2384",rzad);
; 0000 020E //  macierz_zaciskow[rzad]=96;
; 0000 020F 
; 0000 0210 //      komunikat_z_czytnika_kodow("86-2028",rzad);
; 0000 0211 //      macierz_zaciskow[rzad]=107;
; 0000 0212 
; 0000 0213 //      komunikat_z_czytnika_kodow("87-2028",rzad);
; 0000 0214 //      macierz_zaciskow[rzad]=111;
; 0000 0215 
; 0000 0216 
; 0000 0217 
; 0000 0218 
; 0000 0219 /*
; 0000 021A 
; 0000 021B //testy parzystych i nieparzystych IN0-IN8
; 0000 021C //testy port/pin
; 0000 021D //sterownik 3
; 0000 021E //PORTF.0   IN0  STEROWNIK3
; 0000 021F //PORTF.1   IN1  STEROWNIK3
; 0000 0220 //PORTF.2   IN2  STEROWNIK3
; 0000 0221 //PORTF.3   IN3  STEROWNIK3
; 0000 0222 //PORTF.7   IN4 STEROWNIK 3
; 0000 0223 //PORTB.7   IN5 STEROWNIK 3
; 0000 0224 
; 0000 0225 
; 0000 0226 PORT_F.bits.b0 = 0;
; 0000 0227 PORT_F.bits.b1 = 1;
; 0000 0228 PORT_F.bits.b2 = 0;
; 0000 0229 PORT_F.bits.b3 = 1;
; 0000 022A PORT_F.bits.b7 = 0;
; 0000 022B PORTF = PORT_F.byte;
; 0000 022C PORTB.7 = 1;
; 0000 022D 
; 0000 022E //sterownik 4
; 0000 022F 
; 0000 0230 //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 0231 //PORTB.1   IN1  STEROWNIK4
; 0000 0232 //PORTB.2   IN2  STEROWNIK4
; 0000 0233 //PORTB.3   IN3  STEROWNIK4
; 0000 0234 //PORTE.4  IN4  STEROWNIK4
; 0000 0235 //PORTE.5  IN5  STEROWNIK4
; 0000 0236 
; 0000 0237 PORTB.0 = 0;
; 0000 0238 PORTB.1 = 1;
; 0000 0239 PORTB.2 = 0;
; 0000 023A PORTB.3 = 1;
; 0000 023B PORTE.4 = 0;
; 0000 023C PORTE.5 = 1;
; 0000 023D 
; 0000 023E //ster 1
; 0000 023F PORTA.0 = 0;   //IN0  STEROWNIK1        OUT 1
; 0000 0240 PORTA.1 = 1;  //IN1  STEROWNIK1
; 0000 0241 PORTA.2 = 0;  // IN2  STEROWNIK1
; 0000 0242 PORTA.3 = 1;  //IN3  STEROWNIK1
; 0000 0243 PORTA.4 = 0;  // IN4  STEROWNIK1
; 0000 0244 PORTA.5 = 1;  //IN5  STEROWNIK1
; 0000 0245 PORTA.6 = 0;   //IN6  STEROWNIK1
; 0000 0246 PORTA.7 = 1;  //IN7  STEROWNIK1
; 0000 0247 PORTD.4 = 0; //IN8 STEROWNIK1
; 0000 0248 
; 0000 0249 
; 0000 024A 
; 0000 024B //sterownik 2
; 0000 024C PORTC.0 = 0;   //IN0  STEROWNIK2        OUT 3
; 0000 024D PORTC.1  = 1;  //IN1  STEROWNIK2
; 0000 024E PORTC.2 = 0;    //IN2  STEROWNIK2
; 0000 024F PORTC.3= 1;   //IN3  STEROWNIK2
; 0000 0250 PORTC.4 = 0;   // IN4  STEROWNIK2
; 0000 0251 PORTC.5= 1;   //IN5  STEROWNIK2
; 0000 0252 PORTC.6 = 0;   // IN6  STEROWNIK2
; 0000 0253 PORTC.7= 1;   //IN7  STEROWNIK2
; 0000 0254 PORTD.5 = 0;  //IN8 STEROWNIK2
; 0000 0255 
; 0000 0256 */
; 0000 0257 
; 0000 0258 }
;
;void sprawdz_cisnienie()
; 0000 025B {
_sprawdz_cisnienie:
; 0000 025C int i;
; 0000 025D //i = 0;
; 0000 025E i = 1;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,1
; 0000 025F 
; 0000 0260 while(i == 0)
_0xF:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x11
; 0000 0261     {
; 0000 0262     if(sprawdz_pin6(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x9
	RCALL _sprawdz_pin6
	CPI  R30,0
	BRNE _0x12
; 0000 0263         {
; 0000 0264         i = 1;
	__GETWRN 16,17,1
; 0000 0265         komunikat_na_panel("                                                ",adr1,adr2);
	__POINTW1FN _0x0,0
	RJMP _0x27E
; 0000 0266         }
; 0000 0267     else
_0x12:
; 0000 0268         {
; 0000 0269         i = 0;
	__GETWRN 16,17,0
; 0000 026A         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x7
	CALL SUBOPT_0xA
; 0000 026B         komunikat_na_panel("Cisnienie za male - mniejsze niz 6 bar",adr1,adr2);
	__POINTW1FN _0x0,74
_0x27E:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xA
; 0000 026C         }
; 0000 026D     }
	RJMP _0xF
_0x11:
; 0000 026E }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void odczyt_wybranego_zacisku()
; 0000 0271 {                         //11
_odczyt_wybranego_zacisku:
; 0000 0272 
; 0000 0273 
; 0000 0274 PORT_CZYTNIK.bits.b0 = sprawdz_pin0(PORTHH,0x73);
	CALL SUBOPT_0xB
	RCALL _sprawdz_pin0
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFE
	CALL SUBOPT_0xC
; 0000 0275 PORT_CZYTNIK.bits.b1 = sprawdz_pin1(PORTHH,0x73);
	RCALL _sprawdz_pin1
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFD
	CALL SUBOPT_0xC
; 0000 0276 PORT_CZYTNIK.bits.b2 = sprawdz_pin2(PORTHH,0x73);
	RCALL _sprawdz_pin2
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFB
	CALL SUBOPT_0xC
; 0000 0277 PORT_CZYTNIK.bits.b3 = sprawdz_pin3(PORTHH,0x73);
	RCALL _sprawdz_pin3
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0XF7
	CALL SUBOPT_0xC
; 0000 0278 PORT_CZYTNIK.bits.b4 = sprawdz_pin4(PORTHH,0x73);
	RCALL _sprawdz_pin4
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xEF
	CALL SUBOPT_0xC
; 0000 0279 PORT_CZYTNIK.bits.b5 = sprawdz_pin5(PORTHH,0x73);
	RCALL _sprawdz_pin5
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xDF
	CALL SUBOPT_0xC
; 0000 027A PORT_CZYTNIK.bits.b6 = sprawdz_pin6(PORTHH,0x73);
	RCALL _sprawdz_pin6
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xBF
	CALL SUBOPT_0xC
; 0000 027B PORT_CZYTNIK.bits.b7 = sprawdz_pin7(PORTHH,0x73);
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
; 0000 027C 
; 0000 027D rzad = odczytaj_parametr(32,128);       //20,80
	CALL SUBOPT_0xD
	RCALL _odczytaj_parametr
	MOVW R12,R30
; 0000 027E 
; 0000 027F if(PORT_CZYTNIK.byte == 0x01)
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1)
	BRNE _0x14
; 0000 0280     {
; 0000 0281       komunikat_z_czytnika_kodow("86-0170",rzad);
	__POINTW1FN _0x0,113
	CALL SUBOPT_0xE
; 0000 0282       macierz_zaciskow[rzad]=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
; 0000 0283     }
; 0000 0284 
; 0000 0285 if(PORT_CZYTNIK.byte == 0x02)
_0x14:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2)
	BRNE _0x15
; 0000 0286     {
; 0000 0287       komunikat_z_czytnika_kodow("86-1043",rzad);
	__POINTW1FN _0x0,121
	CALL SUBOPT_0xE
; 0000 0288       macierz_zaciskow[rzad]=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
; 0000 0289     }
; 0000 028A 
; 0000 028B if(PORT_CZYTNIK.byte == 0x03)
_0x15:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3)
	BRNE _0x16
; 0000 028C     {
; 0000 028D       komunikat_z_czytnika_kodow("86-1675",rzad);
	__POINTW1FN _0x0,129
	CALL SUBOPT_0xE
; 0000 028E       macierz_zaciskow[rzad]=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   X+,R30
	ST   X,R31
; 0000 028F     }
; 0000 0290 
; 0000 0291 if(PORT_CZYTNIK.byte == 0x04)
_0x16:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4)
	BRNE _0x17
; 0000 0292     {
; 0000 0293       komunikat_z_czytnika_kodow("86-2098",rzad);
	__POINTW1FN _0x0,137
	CALL SUBOPT_0xE
; 0000 0294       macierz_zaciskow[rzad]=4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   X+,R30
	ST   X,R31
; 0000 0295     }
; 0000 0296 if(PORT_CZYTNIK.byte == 0x05)
_0x17:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5)
	BRNE _0x18
; 0000 0297     {
; 0000 0298       komunikat_z_czytnika_kodow("87-0170",rzad);
	__POINTW1FN _0x0,145
	CALL SUBOPT_0xE
; 0000 0299       macierz_zaciskow[rzad]=5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   X+,R30
	ST   X,R31
; 0000 029A     }
; 0000 029B if(PORT_CZYTNIK.byte == 0x06)
_0x18:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6)
	BRNE _0x19
; 0000 029C     {
; 0000 029D       komunikat_z_czytnika_kodow("87-1043",rzad);
	__POINTW1FN _0x0,153
	CALL SUBOPT_0xE
; 0000 029E       macierz_zaciskow[rzad]=6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   X+,R30
	ST   X,R31
; 0000 029F     }
; 0000 02A0 
; 0000 02A1 if(PORT_CZYTNIK.byte == 0x07)
_0x19:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7)
	BRNE _0x1A
; 0000 02A2     {
; 0000 02A3       komunikat_z_czytnika_kodow("87-1675",rzad);
	__POINTW1FN _0x0,161
	CALL SUBOPT_0xE
; 0000 02A4       macierz_zaciskow[rzad]=7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   X+,R30
	ST   X,R31
; 0000 02A5     }
; 0000 02A6 
; 0000 02A7 if(PORT_CZYTNIK.byte == 0x08)
_0x1A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8)
	BRNE _0x1B
; 0000 02A8     {
; 0000 02A9       komunikat_z_czytnika_kodow("87-2098",rzad);
	__POINTW1FN _0x0,169
	CALL SUBOPT_0xE
; 0000 02AA       macierz_zaciskow[rzad]=8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   X+,R30
	ST   X,R31
; 0000 02AB     }
; 0000 02AC if(PORT_CZYTNIK.byte == 0x09)
_0x1B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x9)
	BRNE _0x1C
; 0000 02AD     {
; 0000 02AE       komunikat_z_czytnika_kodow("86-0192",rzad);
	__POINTW1FN _0x0,177
	CALL SUBOPT_0xE
; 0000 02AF       macierz_zaciskow[rzad]=9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   X+,R30
	ST   X,R31
; 0000 02B0     }
; 0000 02B1 if(PORT_CZYTNIK.byte == 0x0A)
_0x1C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xA)
	BRNE _0x1D
; 0000 02B2     {
; 0000 02B3       komunikat_z_czytnika_kodow("86-1054",rzad);
	__POINTW1FN _0x0,185
	CALL SUBOPT_0xE
; 0000 02B4       macierz_zaciskow[rzad]=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   X+,R30
	ST   X,R31
; 0000 02B5     }
; 0000 02B6 if(PORT_CZYTNIK.byte == 0x0B)
_0x1D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xB)
	BRNE _0x1E
; 0000 02B7     {
; 0000 02B8       komunikat_z_czytnika_kodow("86-1676",rzad);
	__POINTW1FN _0x0,193
	CALL SUBOPT_0xE
; 0000 02B9       macierz_zaciskow[rzad]=11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   X+,R30
	ST   X,R31
; 0000 02BA     }
; 0000 02BB if(PORT_CZYTNIK.byte == 0x0C)
_0x1E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xC)
	BRNE _0x1F
; 0000 02BC     {
; 0000 02BD       komunikat_z_czytnika_kodow("86-2132",rzad);
	__POINTW1FN _0x0,201
	CALL SUBOPT_0xE
; 0000 02BE       macierz_zaciskow[rzad]=12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   X+,R30
	ST   X,R31
; 0000 02BF     }
; 0000 02C0 if(PORT_CZYTNIK.byte == 0x0D)
_0x1F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xD)
	BRNE _0x20
; 0000 02C1     {
; 0000 02C2       komunikat_z_czytnika_kodow("87-0192",rzad);
	__POINTW1FN _0x0,209
	CALL SUBOPT_0xE
; 0000 02C3       macierz_zaciskow[rzad]=13;
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   X+,R30
	ST   X,R31
; 0000 02C4     }
; 0000 02C5 if(PORT_CZYTNIK.byte == 0x0E)
_0x20:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xE)
	BRNE _0x21
; 0000 02C6     {
; 0000 02C7       komunikat_z_czytnika_kodow("87-1054",rzad);
	__POINTW1FN _0x0,217
	CALL SUBOPT_0xE
; 0000 02C8       macierz_zaciskow[rzad]=14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   X+,R30
	ST   X,R31
; 0000 02C9     }
; 0000 02CA 
; 0000 02CB if(PORT_CZYTNIK.byte == 0x0F)
_0x21:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xF)
	BRNE _0x22
; 0000 02CC     {
; 0000 02CD       komunikat_z_czytnika_kodow("87-1676",rzad);
	__POINTW1FN _0x0,225
	CALL SUBOPT_0xE
; 0000 02CE       macierz_zaciskow[rzad]=15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   X+,R30
	ST   X,R31
; 0000 02CF     }
; 0000 02D0 if(PORT_CZYTNIK.byte == 0x10)
_0x22:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x10)
	BRNE _0x23
; 0000 02D1     {
; 0000 02D2       komunikat_z_czytnika_kodow("87-2132",rzad);
	__POINTW1FN _0x0,233
	CALL SUBOPT_0xE
; 0000 02D3       macierz_zaciskow[rzad]=16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   X+,R30
	ST   X,R31
; 0000 02D4     }
; 0000 02D5 
; 0000 02D6 if(PORT_CZYTNIK.byte == 0x11)
_0x23:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x11)
	BRNE _0x24
; 0000 02D7     {
; 0000 02D8       komunikat_z_czytnika_kodow("86-0193",rzad);
	__POINTW1FN _0x0,241
	CALL SUBOPT_0xE
; 0000 02D9       macierz_zaciskow[rzad]=17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   X+,R30
	ST   X,R31
; 0000 02DA     }
; 0000 02DB 
; 0000 02DC if(PORT_CZYTNIK.byte == 0x12)
_0x24:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x12)
	BRNE _0x25
; 0000 02DD     {
; 0000 02DE       komunikat_z_czytnika_kodow("86-1216",rzad);
	__POINTW1FN _0x0,249
	CALL SUBOPT_0xE
; 0000 02DF       macierz_zaciskow[rzad]=18;
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	ST   X+,R30
	ST   X,R31
; 0000 02E0     }
; 0000 02E1 if(PORT_CZYTNIK.byte == 0x13)
_0x25:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x13)
	BRNE _0x26
; 0000 02E2     {
; 0000 02E3       komunikat_z_czytnika_kodow("86-1832",rzad);
	__POINTW1FN _0x0,257
	CALL SUBOPT_0xE
; 0000 02E4       macierz_zaciskow[rzad]=19;
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	ST   X+,R30
	ST   X,R31
; 0000 02E5     }
; 0000 02E6 
; 0000 02E7 if(PORT_CZYTNIK.byte == 0x14)
_0x26:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x14)
	BRNE _0x27
; 0000 02E8     {
; 0000 02E9       komunikat_z_czytnika_kodow("86-2174",rzad);
	__POINTW1FN _0x0,265
	CALL SUBOPT_0xE
; 0000 02EA       macierz_zaciskow[rzad]=20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   X+,R30
	ST   X,R31
; 0000 02EB     }
; 0000 02EC if(PORT_CZYTNIK.byte == 0x15)
_0x27:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x15)
	BRNE _0x28
; 0000 02ED     {
; 0000 02EE       komunikat_z_czytnika_kodow("87-0193",rzad);
	__POINTW1FN _0x0,273
	CALL SUBOPT_0xE
; 0000 02EF       macierz_zaciskow[rzad]=21;
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	ST   X+,R30
	ST   X,R31
; 0000 02F0     }
; 0000 02F1 
; 0000 02F2 if(PORT_CZYTNIK.byte == 0x16)
_0x28:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x16)
	BRNE _0x29
; 0000 02F3     {
; 0000 02F4       komunikat_z_czytnika_kodow("87-1216",rzad);
	__POINTW1FN _0x0,281
	CALL SUBOPT_0xE
; 0000 02F5       macierz_zaciskow[rzad]=22;
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	ST   X+,R30
	ST   X,R31
; 0000 02F6     }
; 0000 02F7 if(PORT_CZYTNIK.byte == 0x17)
_0x29:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x17)
	BRNE _0x2A
; 0000 02F8     {
; 0000 02F9       komunikat_z_czytnika_kodow("87-1832",rzad);
	__POINTW1FN _0x0,289
	CALL SUBOPT_0xE
; 0000 02FA       macierz_zaciskow[rzad]=23;
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	ST   X+,R30
	ST   X,R31
; 0000 02FB     }
; 0000 02FC 
; 0000 02FD if(PORT_CZYTNIK.byte == 0x18)
_0x2A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x18)
	BRNE _0x2B
; 0000 02FE     {
; 0000 02FF       komunikat_z_czytnika_kodow("87-2174",rzad);
	__POINTW1FN _0x0,297
	CALL SUBOPT_0xE
; 0000 0300       macierz_zaciskow[rzad]=24;
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	ST   X+,R30
	ST   X,R31
; 0000 0301     }
; 0000 0302 if(PORT_CZYTNIK.byte == 0x19)
_0x2B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x19)
	BRNE _0x2C
; 0000 0303     {
; 0000 0304       komunikat_z_czytnika_kodow("86-0194",rzad);
	__POINTW1FN _0x0,305
	CALL SUBOPT_0xE
; 0000 0305       macierz_zaciskow[rzad]=25;
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	ST   X+,R30
	ST   X,R31
; 0000 0306     }
; 0000 0307 
; 0000 0308 if(PORT_CZYTNIK.byte == 0x1A)
_0x2C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1A)
	BRNE _0x2D
; 0000 0309     {
; 0000 030A       komunikat_z_czytnika_kodow("86-1341",rzad);
	__POINTW1FN _0x0,313
	CALL SUBOPT_0xE
; 0000 030B       macierz_zaciskow[rzad]=26;
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	ST   X+,R30
	ST   X,R31
; 0000 030C     }
; 0000 030D if(PORT_CZYTNIK.byte == 0x1B)
_0x2D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1B)
	BRNE _0x2E
; 0000 030E     {
; 0000 030F       komunikat_z_czytnika_kodow("86-1833",rzad);
	__POINTW1FN _0x0,321
	CALL SUBOPT_0xE
; 0000 0310       macierz_zaciskow[rzad]=27;
	LDI  R30,LOW(27)
	LDI  R31,HIGH(27)
	ST   X+,R30
	ST   X,R31
; 0000 0311     }
; 0000 0312 if(PORT_CZYTNIK.byte == 0x1C)
_0x2E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1C)
	BRNE _0x2F
; 0000 0313     {
; 0000 0314       komunikat_z_czytnika_kodow("86-2180",rzad);
	__POINTW1FN _0x0,329
	CALL SUBOPT_0xE
; 0000 0315       macierz_zaciskow[rzad]=28;
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	ST   X+,R30
	ST   X,R31
; 0000 0316     }
; 0000 0317 if(PORT_CZYTNIK.byte == 0x1D)
_0x2F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1D)
	BRNE _0x30
; 0000 0318     {
; 0000 0319       komunikat_z_czytnika_kodow("87-0194",rzad);
	__POINTW1FN _0x0,337
	CALL SUBOPT_0xE
; 0000 031A       macierz_zaciskow[rzad]=29;
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	ST   X+,R30
	ST   X,R31
; 0000 031B     }
; 0000 031C 
; 0000 031D if(PORT_CZYTNIK.byte == 0x1E)
_0x30:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1E)
	BRNE _0x31
; 0000 031E     {
; 0000 031F       komunikat_z_czytnika_kodow("87-1341",rzad);
	__POINTW1FN _0x0,345
	CALL SUBOPT_0xE
; 0000 0320       macierz_zaciskow[rzad]=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   X+,R30
	ST   X,R31
; 0000 0321     }
; 0000 0322 if(PORT_CZYTNIK.byte == 0x1F)
_0x31:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1F)
	BRNE _0x32
; 0000 0323     {
; 0000 0324       komunikat_z_czytnika_kodow("87-1833",rzad);
	__POINTW1FN _0x0,353
	CALL SUBOPT_0xE
; 0000 0325       macierz_zaciskow[rzad]=31;
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	ST   X+,R30
	ST   X,R31
; 0000 0326     }
; 0000 0327 
; 0000 0328 if(PORT_CZYTNIK.byte == 0x20)
_0x32:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x20)
	BRNE _0x33
; 0000 0329     {
; 0000 032A       komunikat_z_czytnika_kodow("87-2180",rzad);
	__POINTW1FN _0x0,361
	CALL SUBOPT_0xE
; 0000 032B       macierz_zaciskow[rzad]=32;
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   X+,R30
	ST   X,R31
; 0000 032C     }
; 0000 032D if(PORT_CZYTNIK.byte == 0x21)
_0x33:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x21)
	BRNE _0x34
; 0000 032E     {
; 0000 032F       komunikat_z_czytnika_kodow("86-0663",rzad);
	__POINTW1FN _0x0,369
	CALL SUBOPT_0xE
; 0000 0330       macierz_zaciskow[rzad]=33;
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	ST   X+,R30
	ST   X,R31
; 0000 0331     }
; 0000 0332 
; 0000 0333 if(PORT_CZYTNIK.byte == 0x22)
_0x34:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x22)
	BRNE _0x35
; 0000 0334     {
; 0000 0335       komunikat_z_czytnika_kodow("86-1349",rzad);
	__POINTW1FN _0x0,377
	CALL SUBOPT_0xE
; 0000 0336       macierz_zaciskow[rzad]=34;
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	ST   X+,R30
	ST   X,R31
; 0000 0337     }
; 0000 0338 if(PORT_CZYTNIK.byte == 0x23)
_0x35:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x23)
	BRNE _0x36
; 0000 0339     {
; 0000 033A       komunikat_z_czytnika_kodow("86-1834",rzad);
	__POINTW1FN _0x0,385
	CALL SUBOPT_0xE
; 0000 033B       macierz_zaciskow[rzad]=35;
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	ST   X+,R30
	ST   X,R31
; 0000 033C     }
; 0000 033D if(PORT_CZYTNIK.byte == 0x24)
_0x36:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x24)
	BRNE _0x37
; 0000 033E     {
; 0000 033F       komunikat_z_czytnika_kodow("86-2204",rzad);
	__POINTW1FN _0x0,393
	CALL SUBOPT_0xE
; 0000 0340       macierz_zaciskow[rzad]=36;
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	ST   X+,R30
	ST   X,R31
; 0000 0341     }
; 0000 0342 if(PORT_CZYTNIK.byte == 0x25)
_0x37:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x25)
	BRNE _0x38
; 0000 0343     {
; 0000 0344       komunikat_z_czytnika_kodow("87-0663",rzad);
	__POINTW1FN _0x0,401
	CALL SUBOPT_0xE
; 0000 0345       macierz_zaciskow[rzad]=37;
	LDI  R30,LOW(37)
	LDI  R31,HIGH(37)
	ST   X+,R30
	ST   X,R31
; 0000 0346     }
; 0000 0347 if(PORT_CZYTNIK.byte == 0x26)
_0x38:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x26)
	BRNE _0x39
; 0000 0348     {
; 0000 0349       komunikat_z_czytnika_kodow("87-1349",rzad);
	__POINTW1FN _0x0,409
	CALL SUBOPT_0xE
; 0000 034A       macierz_zaciskow[rzad]=38;
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	ST   X+,R30
	ST   X,R31
; 0000 034B     }
; 0000 034C if(PORT_CZYTNIK.byte == 0x27)
_0x39:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x27)
	BRNE _0x3A
; 0000 034D     {
; 0000 034E       komunikat_z_czytnika_kodow("87-1834",rzad);
	__POINTW1FN _0x0,417
	CALL SUBOPT_0xE
; 0000 034F       macierz_zaciskow[rzad]=39;
	LDI  R30,LOW(39)
	LDI  R31,HIGH(39)
	ST   X+,R30
	ST   X,R31
; 0000 0350     }
; 0000 0351 if(PORT_CZYTNIK.byte == 0x28)
_0x3A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x28)
	BRNE _0x3B
; 0000 0352     {
; 0000 0353       komunikat_z_czytnika_kodow("87-2204",rzad);
	__POINTW1FN _0x0,425
	CALL SUBOPT_0xE
; 0000 0354       macierz_zaciskow[rzad]=40;
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   X+,R30
	ST   X,R31
; 0000 0355     }
; 0000 0356 if(PORT_CZYTNIK.byte == 0x29)
_0x3B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x29)
	BRNE _0x3C
; 0000 0357     {
; 0000 0358       komunikat_z_czytnika_kodow("86-0768",rzad);
	__POINTW1FN _0x0,433
	CALL SUBOPT_0xE
; 0000 0359       macierz_zaciskow[rzad]=41;
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	ST   X+,R30
	ST   X,R31
; 0000 035A     }
; 0000 035B if(PORT_CZYTNIK.byte == 0x2A)
_0x3C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2A)
	BRNE _0x3D
; 0000 035C     {
; 0000 035D       komunikat_z_czytnika_kodow("86-1357",rzad);
	__POINTW1FN _0x0,441
	CALL SUBOPT_0xE
; 0000 035E       macierz_zaciskow[rzad]=42;
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   X+,R30
	ST   X,R31
; 0000 035F     }
; 0000 0360 if(PORT_CZYTNIK.byte == 0x2B)
_0x3D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2B)
	BRNE _0x3E
; 0000 0361     {
; 0000 0362       komunikat_z_czytnika_kodow("86-1848",rzad);
	__POINTW1FN _0x0,449
	CALL SUBOPT_0xE
; 0000 0363       macierz_zaciskow[rzad]=43;
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	ST   X+,R30
	ST   X,R31
; 0000 0364     }
; 0000 0365 if(PORT_CZYTNIK.byte == 0x2C)
_0x3E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2C)
	BRNE _0x3F
; 0000 0366     {
; 0000 0367       komunikat_z_czytnika_kodow("86-2212",rzad);
	__POINTW1FN _0x0,457
	CALL SUBOPT_0xE
; 0000 0368       macierz_zaciskow[rzad]=44;
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	ST   X+,R30
	ST   X,R31
; 0000 0369     }
; 0000 036A if(PORT_CZYTNIK.byte == 0x2D)
_0x3F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2D)
	BRNE _0x40
; 0000 036B     {
; 0000 036C       komunikat_z_czytnika_kodow("87-0768",rzad);
	__POINTW1FN _0x0,465
	CALL SUBOPT_0xE
; 0000 036D       macierz_zaciskow[rzad]=45;
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	ST   X+,R30
	ST   X,R31
; 0000 036E     }
; 0000 036F if(PORT_CZYTNIK.byte == 0x2E)
_0x40:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2E)
	BRNE _0x41
; 0000 0370     {
; 0000 0371       komunikat_z_czytnika_kodow("87-1357",rzad);
	__POINTW1FN _0x0,473
	CALL SUBOPT_0xE
; 0000 0372       macierz_zaciskow[rzad]=46;
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	ST   X+,R30
	ST   X,R31
; 0000 0373     }
; 0000 0374 if(PORT_CZYTNIK.byte == 0x2F)
_0x41:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2F)
	BRNE _0x42
; 0000 0375     {
; 0000 0376       komunikat_z_czytnika_kodow("87-1848",rzad);
	__POINTW1FN _0x0,481
	CALL SUBOPT_0xE
; 0000 0377       macierz_zaciskow[rzad]=47;
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	ST   X+,R30
	ST   X,R31
; 0000 0378     }
; 0000 0379 if(PORT_CZYTNIK.byte == 0x30)
_0x42:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x30)
	BRNE _0x43
; 0000 037A     {
; 0000 037B       komunikat_z_czytnika_kodow("87-2212",rzad);
	__POINTW1FN _0x0,489
	CALL SUBOPT_0xE
; 0000 037C       macierz_zaciskow[rzad]=48;
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   X+,R30
	ST   X,R31
; 0000 037D     }
; 0000 037E if(PORT_CZYTNIK.byte == 0x31)
_0x43:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x31)
	BRNE _0x44
; 0000 037F     {
; 0000 0380       komunikat_z_czytnika_kodow("86-0800",rzad);
	__POINTW1FN _0x0,497
	CALL SUBOPT_0xE
; 0000 0381       macierz_zaciskow[rzad]=49;
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	ST   X+,R30
	ST   X,R31
; 0000 0382     }
; 0000 0383 if(PORT_CZYTNIK.byte == 0x32)
_0x44:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x32)
	BRNE _0x45
; 0000 0384     {
; 0000 0385       komunikat_z_czytnika_kodow("86-1363",rzad);
	__POINTW1FN _0x0,505
	CALL SUBOPT_0xE
; 0000 0386       macierz_zaciskow[rzad]=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   X+,R30
	ST   X,R31
; 0000 0387     }
; 0000 0388 if(PORT_CZYTNIK.byte == 0x33)
_0x45:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x33)
	BRNE _0x46
; 0000 0389     {
; 0000 038A       komunikat_z_czytnika_kodow("86-1904",rzad);
	__POINTW1FN _0x0,513
	CALL SUBOPT_0xE
; 0000 038B       macierz_zaciskow[rzad]=51;
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	ST   X+,R30
	ST   X,R31
; 0000 038C     }
; 0000 038D if(PORT_CZYTNIK.byte == 0x34)
_0x46:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x34)
	BRNE _0x47
; 0000 038E     {
; 0000 038F       komunikat_z_czytnika_kodow("86-2241",rzad);
	__POINTW1FN _0x0,521
	CALL SUBOPT_0xE
; 0000 0390       macierz_zaciskow[rzad]=52;
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	ST   X+,R30
	ST   X,R31
; 0000 0391     }
; 0000 0392 if(PORT_CZYTNIK.byte == 0x35)
_0x47:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x35)
	BRNE _0x48
; 0000 0393     {
; 0000 0394       komunikat_z_czytnika_kodow("87-0800",rzad);
	__POINTW1FN _0x0,529
	CALL SUBOPT_0xE
; 0000 0395       macierz_zaciskow[rzad]=53;
	LDI  R30,LOW(53)
	LDI  R31,HIGH(53)
	ST   X+,R30
	ST   X,R31
; 0000 0396     }
; 0000 0397 
; 0000 0398 if(PORT_CZYTNIK.byte == 0x36)
_0x48:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x36)
	BRNE _0x49
; 0000 0399     {
; 0000 039A       komunikat_z_czytnika_kodow("87-1363",rzad);
	__POINTW1FN _0x0,537
	CALL SUBOPT_0xE
; 0000 039B       macierz_zaciskow[rzad]=54;
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	ST   X+,R30
	ST   X,R31
; 0000 039C     }
; 0000 039D if(PORT_CZYTNIK.byte == 0x37)
_0x49:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x37)
	BRNE _0x4A
; 0000 039E     {
; 0000 039F       komunikat_z_czytnika_kodow("87-1904",rzad);
	__POINTW1FN _0x0,545
	CALL SUBOPT_0xE
; 0000 03A0       macierz_zaciskow[rzad]=55;
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	ST   X+,R30
	ST   X,R31
; 0000 03A1     }
; 0000 03A2 if(PORT_CZYTNIK.byte == 0x38)
_0x4A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x38)
	BRNE _0x4B
; 0000 03A3     {
; 0000 03A4       komunikat_z_czytnika_kodow("87-2241",rzad);
	__POINTW1FN _0x0,553
	CALL SUBOPT_0xE
; 0000 03A5       macierz_zaciskow[rzad]=56;
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	ST   X+,R30
	ST   X,R31
; 0000 03A6     }
; 0000 03A7 if(PORT_CZYTNIK.byte == 0x39)
_0x4B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x39)
	BRNE _0x4C
; 0000 03A8     {
; 0000 03A9       komunikat_z_czytnika_kodow("86-0811",rzad);
	__POINTW1FN _0x0,561
	CALL SUBOPT_0xE
; 0000 03AA       macierz_zaciskow[rzad]=57;
	LDI  R30,LOW(57)
	LDI  R31,HIGH(57)
	ST   X+,R30
	ST   X,R31
; 0000 03AB     }
; 0000 03AC if(PORT_CZYTNIK.byte == 0x3A)
_0x4C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3A)
	BRNE _0x4D
; 0000 03AD     {
; 0000 03AE       komunikat_z_czytnika_kodow("86-1523",rzad);
	__POINTW1FN _0x0,569
	CALL SUBOPT_0xE
; 0000 03AF       macierz_zaciskow[rzad]=58;
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	ST   X+,R30
	ST   X,R31
; 0000 03B0     }
; 0000 03B1 if(PORT_CZYTNIK.byte == 0x3B)
_0x4D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3B)
	BRNE _0x4E
; 0000 03B2     {
; 0000 03B3       komunikat_z_czytnika_kodow("86-1929",rzad);
	__POINTW1FN _0x0,577
	CALL SUBOPT_0xE
; 0000 03B4       macierz_zaciskow[rzad]=59;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	ST   X+,R30
	ST   X,R31
; 0000 03B5     }
; 0000 03B6 if(PORT_CZYTNIK.byte == 0x3C)
_0x4E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3C)
	BRNE _0x4F
; 0000 03B7     {
; 0000 03B8       komunikat_z_czytnika_kodow("86-2261",rzad);
	__POINTW1FN _0x0,585
	CALL SUBOPT_0xE
; 0000 03B9       macierz_zaciskow[rzad]=60;
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	ST   X+,R30
	ST   X,R31
; 0000 03BA     }
; 0000 03BB if(PORT_CZYTNIK.byte == 0x3D)
_0x4F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3D)
	BRNE _0x50
; 0000 03BC     {
; 0000 03BD       komunikat_z_czytnika_kodow("87-0811",rzad);
	__POINTW1FN _0x0,593
	CALL SUBOPT_0xE
; 0000 03BE       macierz_zaciskow[rzad]=61;
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	ST   X+,R30
	ST   X,R31
; 0000 03BF     }
; 0000 03C0 if(PORT_CZYTNIK.byte == 0x3E)
_0x50:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3E)
	BRNE _0x51
; 0000 03C1     {
; 0000 03C2       komunikat_z_czytnika_kodow("87-1523",rzad);
	__POINTW1FN _0x0,601
	CALL SUBOPT_0xE
; 0000 03C3       macierz_zaciskow[rzad]=62;
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	ST   X+,R30
	ST   X,R31
; 0000 03C4     }
; 0000 03C5 if(PORT_CZYTNIK.byte == 0x3F)
_0x51:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3F)
	BRNE _0x52
; 0000 03C6     {
; 0000 03C7       komunikat_z_czytnika_kodow("87-1929",rzad);
	__POINTW1FN _0x0,609
	CALL SUBOPT_0xE
; 0000 03C8       macierz_zaciskow[rzad]=63;
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	ST   X+,R30
	ST   X,R31
; 0000 03C9     }
; 0000 03CA if(PORT_CZYTNIK.byte == 0x40)
_0x52:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x40)
	BRNE _0x53
; 0000 03CB     {
; 0000 03CC       komunikat_z_czytnika_kodow("87-2261",rzad);
	__POINTW1FN _0x0,617
	CALL SUBOPT_0xE
; 0000 03CD       macierz_zaciskow[rzad]=64;
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   X+,R30
	ST   X,R31
; 0000 03CE     }
; 0000 03CF if(PORT_CZYTNIK.byte == 0x41)
_0x53:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x41)
	BRNE _0x54
; 0000 03D0     {
; 0000 03D1       komunikat_z_czytnika_kodow("86-0814",rzad);
	__POINTW1FN _0x0,625
	CALL SUBOPT_0xE
; 0000 03D2       macierz_zaciskow[rzad]=65;
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   X+,R30
	ST   X,R31
; 0000 03D3     }
; 0000 03D4 if(PORT_CZYTNIK.byte == 0x42)
_0x54:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x42)
	BRNE _0x55
; 0000 03D5     {
; 0000 03D6       komunikat_z_czytnika_kodow("86-1530",rzad);
	__POINTW1FN _0x0,633
	CALL SUBOPT_0xE
; 0000 03D7       macierz_zaciskow[rzad]=66;
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	ST   X+,R30
	ST   X,R31
; 0000 03D8     }
; 0000 03D9 if(PORT_CZYTNIK.byte == 0x43)
_0x55:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x43)
	BRNE _0x56
; 0000 03DA     {
; 0000 03DB       komunikat_z_czytnika_kodow("86-1936",rzad);
	__POINTW1FN _0x0,641
	CALL SUBOPT_0xE
; 0000 03DC       macierz_zaciskow[rzad]=67;
	LDI  R30,LOW(67)
	LDI  R31,HIGH(67)
	ST   X+,R30
	ST   X,R31
; 0000 03DD     }
; 0000 03DE if(PORT_CZYTNIK.byte == 0x44)
_0x56:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x44)
	BRNE _0x57
; 0000 03DF     {
; 0000 03E0       komunikat_z_czytnika_kodow("86-2285",rzad);
	__POINTW1FN _0x0,649
	CALL SUBOPT_0xE
; 0000 03E1       macierz_zaciskow[rzad]=68;
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   X+,R30
	ST   X,R31
; 0000 03E2     }
; 0000 03E3 if(PORT_CZYTNIK.byte == 0x45)
_0x57:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x45)
	BRNE _0x58
; 0000 03E4     {
; 0000 03E5       komunikat_z_czytnika_kodow("87-0814",rzad);
	__POINTW1FN _0x0,657
	CALL SUBOPT_0xE
; 0000 03E6       macierz_zaciskow[rzad]=69;
	LDI  R30,LOW(69)
	LDI  R31,HIGH(69)
	ST   X+,R30
	ST   X,R31
; 0000 03E7     }
; 0000 03E8 if(PORT_CZYTNIK.byte == 0x46)
_0x58:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x46)
	BRNE _0x59
; 0000 03E9     {
; 0000 03EA       komunikat_z_czytnika_kodow("87-1530",rzad);
	__POINTW1FN _0x0,665
	CALL SUBOPT_0xE
; 0000 03EB       macierz_zaciskow[rzad]=70;
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   X+,R30
	ST   X,R31
; 0000 03EC     }
; 0000 03ED if(PORT_CZYTNIK.byte == 0x47)
_0x59:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x47)
	BRNE _0x5A
; 0000 03EE     {
; 0000 03EF       komunikat_z_czytnika_kodow("87-1936",rzad);
	__POINTW1FN _0x0,673
	CALL SUBOPT_0xE
; 0000 03F0       macierz_zaciskow[rzad]=71;
	LDI  R30,LOW(71)
	LDI  R31,HIGH(71)
	ST   X+,R30
	ST   X,R31
; 0000 03F1     }
; 0000 03F2 if(PORT_CZYTNIK.byte == 0x48)
_0x5A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x48)
	BRNE _0x5B
; 0000 03F3     {
; 0000 03F4       komunikat_z_czytnika_kodow("87-2285",rzad);
	__POINTW1FN _0x0,681
	CALL SUBOPT_0xE
; 0000 03F5       macierz_zaciskow[rzad]=72;
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	ST   X+,R30
	ST   X,R31
; 0000 03F6     }
; 0000 03F7 if(PORT_CZYTNIK.byte == 0x49)
_0x5B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x49)
	BRNE _0x5C
; 0000 03F8     {
; 0000 03F9       komunikat_z_czytnika_kodow("86-0815",rzad);
	__POINTW1FN _0x0,689
	CALL SUBOPT_0xE
; 0000 03FA       macierz_zaciskow[rzad]=73;
	LDI  R30,LOW(73)
	LDI  R31,HIGH(73)
	ST   X+,R30
	ST   X,R31
; 0000 03FB     }
; 0000 03FC 
; 0000 03FD if(PORT_CZYTNIK.byte == 0x4A)
_0x5C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4A)
	BRNE _0x5D
; 0000 03FE     {
; 0000 03FF       komunikat_z_czytnika_kodow("86-1551",rzad);
	__POINTW1FN _0x0,697
	CALL SUBOPT_0xE
; 0000 0400       macierz_zaciskow[rzad]=74;
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	ST   X+,R30
	ST   X,R31
; 0000 0401     }
; 0000 0402 if(PORT_CZYTNIK.byte == 0x4B)
_0x5D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4B)
	BRNE _0x5E
; 0000 0403     {
; 0000 0404       komunikat_z_czytnika_kodow("86-1941",rzad);
	__POINTW1FN _0x0,705
	CALL SUBOPT_0xE
; 0000 0405       macierz_zaciskow[rzad]=75;
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	ST   X+,R30
	ST   X,R31
; 0000 0406     }
; 0000 0407 if(PORT_CZYTNIK.byte == 0x4C)
_0x5E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4C)
	BRNE _0x5F
; 0000 0408     {
; 0000 0409       komunikat_z_czytnika_kodow("86-2286",rzad);
	__POINTW1FN _0x0,713
	CALL SUBOPT_0xE
; 0000 040A       macierz_zaciskow[rzad]=76;
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	ST   X+,R30
	ST   X,R31
; 0000 040B     }
; 0000 040C if(PORT_CZYTNIK.byte == 0x4D)
_0x5F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4D)
	BRNE _0x60
; 0000 040D     {
; 0000 040E       komunikat_z_czytnika_kodow("87-0815",rzad);
	__POINTW1FN _0x0,721
	CALL SUBOPT_0xE
; 0000 040F       macierz_zaciskow[rzad]=77;
	LDI  R30,LOW(77)
	LDI  R31,HIGH(77)
	ST   X+,R30
	ST   X,R31
; 0000 0410     }
; 0000 0411 if(PORT_CZYTNIK.byte == 0x4E)
_0x60:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4E)
	BRNE _0x61
; 0000 0412     {
; 0000 0413       komunikat_z_czytnika_kodow("87-1551",rzad);
	__POINTW1FN _0x0,729
	CALL SUBOPT_0xE
; 0000 0414       macierz_zaciskow[rzad]=78;
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	ST   X+,R30
	ST   X,R31
; 0000 0415     }
; 0000 0416 if(PORT_CZYTNIK.byte == 0x4F)
_0x61:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4F)
	BRNE _0x62
; 0000 0417     {
; 0000 0418       komunikat_z_czytnika_kodow("87-1941",rzad);
	__POINTW1FN _0x0,737
	CALL SUBOPT_0xE
; 0000 0419       macierz_zaciskow[rzad]=79;
	LDI  R30,LOW(79)
	LDI  R31,HIGH(79)
	ST   X+,R30
	ST   X,R31
; 0000 041A     }
; 0000 041B if(PORT_CZYTNIK.byte == 0x50)
_0x62:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x50)
	BRNE _0x63
; 0000 041C     {
; 0000 041D       komunikat_z_czytnika_kodow("87-2286",rzad);
	__POINTW1FN _0x0,745
	CALL SUBOPT_0xE
; 0000 041E       macierz_zaciskow[rzad]=80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   X+,R30
	ST   X,R31
; 0000 041F     }
; 0000 0420 if(PORT_CZYTNIK.byte == 0x51)
_0x63:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x51)
	BRNE _0x64
; 0000 0421     {
; 0000 0422       komunikat_z_czytnika_kodow("86-0816",rzad);
	__POINTW1FN _0x0,753
	CALL SUBOPT_0xE
; 0000 0423       macierz_zaciskow[rzad]=81;
	LDI  R30,LOW(81)
	LDI  R31,HIGH(81)
	ST   X+,R30
	ST   X,R31
; 0000 0424     }
; 0000 0425 if(PORT_CZYTNIK.byte == 0x52)
_0x64:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x52)
	BRNE _0x65
; 0000 0426     {
; 0000 0427       komunikat_z_czytnika_kodow("86-1552",rzad);
	__POINTW1FN _0x0,761
	CALL SUBOPT_0xE
; 0000 0428       macierz_zaciskow[rzad]=82;
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	ST   X+,R30
	ST   X,R31
; 0000 0429     }
; 0000 042A if(PORT_CZYTNIK.byte == 0x53)
_0x65:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x53)
	BRNE _0x66
; 0000 042B     {
; 0000 042C       komunikat_z_czytnika_kodow("86-2007",rzad);
	__POINTW1FN _0x0,769
	CALL SUBOPT_0xE
; 0000 042D       macierz_zaciskow[rzad]=83;
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	ST   X+,R30
	ST   X,R31
; 0000 042E     }
; 0000 042F if(PORT_CZYTNIK.byte == 0x54)
_0x66:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x54)
	BRNE _0x67
; 0000 0430     {
; 0000 0431       komunikat_z_czytnika_kodow("86-2292",rzad);
	__POINTW1FN _0x0,777
	CALL SUBOPT_0xE
; 0000 0432       macierz_zaciskow[rzad]=84;
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	ST   X+,R30
	ST   X,R31
; 0000 0433     }
; 0000 0434 if(PORT_CZYTNIK.byte == 0x55)
_0x67:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x55)
	BRNE _0x68
; 0000 0435     {
; 0000 0436       komunikat_z_czytnika_kodow("87-0816",rzad);
	__POINTW1FN _0x0,785
	CALL SUBOPT_0xE
; 0000 0437       macierz_zaciskow[rzad]=85;
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	ST   X+,R30
	ST   X,R31
; 0000 0438      }
; 0000 0439 if(PORT_CZYTNIK.byte == 0x56)
_0x68:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x56)
	BRNE _0x69
; 0000 043A     {
; 0000 043B       komunikat_z_czytnika_kodow("87-1552",rzad);
	__POINTW1FN _0x0,793
	CALL SUBOPT_0xE
; 0000 043C       macierz_zaciskow[rzad]=86;
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	ST   X+,R30
	ST   X,R31
; 0000 043D     }
; 0000 043E if(PORT_CZYTNIK.byte == 0x57)
_0x69:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x57)
	BRNE _0x6A
; 0000 043F     {
; 0000 0440       komunikat_z_czytnika_kodow("87-2007",rzad);
	__POINTW1FN _0x0,801
	CALL SUBOPT_0xE
; 0000 0441       macierz_zaciskow[rzad]=87;
	LDI  R30,LOW(87)
	LDI  R31,HIGH(87)
	ST   X+,R30
	ST   X,R31
; 0000 0442     }
; 0000 0443 if(PORT_CZYTNIK.byte == 0x58)
_0x6A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x58)
	BRNE _0x6B
; 0000 0444     {
; 0000 0445       komunikat_z_czytnika_kodow("87-2292",rzad);
	__POINTW1FN _0x0,809
	CALL SUBOPT_0xE
; 0000 0446       macierz_zaciskow[rzad]=88;
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	ST   X+,R30
	ST   X,R31
; 0000 0447     }
; 0000 0448 if(PORT_CZYTNIK.byte == 0x59)
_0x6B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x59)
	BRNE _0x6C
; 0000 0449     {
; 0000 044A       komunikat_z_czytnika_kodow("86-0817",rzad);
	__POINTW1FN _0x0,817
	CALL SUBOPT_0xE
; 0000 044B       macierz_zaciskow[rzad]=89;
	LDI  R30,LOW(89)
	LDI  R31,HIGH(89)
	ST   X+,R30
	ST   X,R31
; 0000 044C     }
; 0000 044D if(PORT_CZYTNIK.byte == 0x5A)
_0x6C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5A)
	BRNE _0x6D
; 0000 044E     {
; 0000 044F       komunikat_z_czytnika_kodow("86-1602",rzad);
	__POINTW1FN _0x0,825
	CALL SUBOPT_0xE
; 0000 0450       macierz_zaciskow[rzad]=90;
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   X+,R30
	ST   X,R31
; 0000 0451     }
; 0000 0452 if(PORT_CZYTNIK.byte == 0x5B)
_0x6D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5B)
	BRNE _0x6E
; 0000 0453     {
; 0000 0454       komunikat_z_czytnika_kodow("86-2017",rzad);
	__POINTW1FN _0x0,833
	CALL SUBOPT_0xE
; 0000 0455       macierz_zaciskow[rzad]=91;
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	ST   X+,R30
	ST   X,R31
; 0000 0456     }
; 0000 0457 if(PORT_CZYTNIK.byte == 0x5C)
_0x6E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5C)
	BRNE _0x6F
; 0000 0458     {
; 0000 0459       komunikat_z_czytnika_kodow("86-2384",rzad);
	__POINTW1FN _0x0,841
	CALL SUBOPT_0xE
; 0000 045A       macierz_zaciskow[rzad]=92;
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	ST   X+,R30
	ST   X,R31
; 0000 045B     }
; 0000 045C if(PORT_CZYTNIK.byte == 0x5D)
_0x6F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5D)
	BRNE _0x70
; 0000 045D     {
; 0000 045E       komunikat_z_czytnika_kodow("87-0817",rzad);
	__POINTW1FN _0x0,849
	CALL SUBOPT_0xE
; 0000 045F       macierz_zaciskow[rzad]=93;
	LDI  R30,LOW(93)
	LDI  R31,HIGH(93)
	ST   X+,R30
	ST   X,R31
; 0000 0460     }
; 0000 0461 if(PORT_CZYTNIK.byte == 0x5E)
_0x70:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5E)
	BRNE _0x71
; 0000 0462     {
; 0000 0463       komunikat_z_czytnika_kodow("87-1602",rzad);
	__POINTW1FN _0x0,857
	CALL SUBOPT_0xE
; 0000 0464       macierz_zaciskow[rzad]=94;
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	ST   X+,R30
	ST   X,R31
; 0000 0465     }
; 0000 0466 if(PORT_CZYTNIK.byte == 0x5F)
_0x71:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5F)
	BRNE _0x72
; 0000 0467     {
; 0000 0468       komunikat_z_czytnika_kodow("87-2017",rzad);
	__POINTW1FN _0x0,865
	CALL SUBOPT_0xE
; 0000 0469       macierz_zaciskow[rzad]=95;
	LDI  R30,LOW(95)
	LDI  R31,HIGH(95)
	ST   X+,R30
	ST   X,R31
; 0000 046A     }
; 0000 046B if(PORT_CZYTNIK.byte == 0x60)
_0x72:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x60)
	BRNE _0x73
; 0000 046C     {
; 0000 046D       komunikat_z_czytnika_kodow("87-2384",rzad);
	__POINTW1FN _0x0,873
	CALL SUBOPT_0xE
; 0000 046E       macierz_zaciskow[rzad]=96;
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	ST   X+,R30
	ST   X,R31
; 0000 046F     }
; 0000 0470 
; 0000 0471 if(PORT_CZYTNIK.byte == 0x61)
_0x73:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x61)
	BRNE _0x74
; 0000 0472     {
; 0000 0473       komunikat_z_czytnika_kodow("86-0847",rzad);
	__POINTW1FN _0x0,881
	CALL SUBOPT_0xE
; 0000 0474       macierz_zaciskow[rzad]=97;
	LDI  R30,LOW(97)
	LDI  R31,HIGH(97)
	ST   X+,R30
	ST   X,R31
; 0000 0475     }
; 0000 0476 
; 0000 0477 if(PORT_CZYTNIK.byte == 0x62)
_0x74:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x62)
	BRNE _0x75
; 0000 0478     {
; 0000 0479       komunikat_z_czytnika_kodow("86-1620",rzad);
	__POINTW1FN _0x0,889
	CALL SUBOPT_0xE
; 0000 047A       macierz_zaciskow[rzad]=98;
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	ST   X+,R30
	ST   X,R31
; 0000 047B     }
; 0000 047C if(PORT_CZYTNIK.byte == 0x63)
_0x75:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x63)
	BRNE _0x76
; 0000 047D     {
; 0000 047E       komunikat_z_czytnika_kodow("86-2019",rzad);
	__POINTW1FN _0x0,897
	CALL SUBOPT_0xE
; 0000 047F       macierz_zaciskow[rzad]=99;
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	ST   X+,R30
	ST   X,R31
; 0000 0480     }
; 0000 0481 if(PORT_CZYTNIK.byte == 0x64)
_0x76:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x64)
	BRNE _0x77
; 0000 0482     {
; 0000 0483       komunikat_z_czytnika_kodow("86-2385",rzad);
	__POINTW1FN _0x0,905
	CALL SUBOPT_0xE
; 0000 0484       macierz_zaciskow[rzad]=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   X+,R30
	ST   X,R31
; 0000 0485     }
; 0000 0486 if(PORT_CZYTNIK.byte == 0x65)
_0x77:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x65)
	BRNE _0x78
; 0000 0487     {
; 0000 0488       komunikat_z_czytnika_kodow("87-0847",rzad);
	__POINTW1FN _0x0,913
	CALL SUBOPT_0xE
; 0000 0489       macierz_zaciskow[rzad]=101;
	LDI  R30,LOW(101)
	LDI  R31,HIGH(101)
	ST   X+,R30
	ST   X,R31
; 0000 048A     }
; 0000 048B if(PORT_CZYTNIK.byte == 0x66)
_0x78:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x66)
	BRNE _0x79
; 0000 048C     {
; 0000 048D       komunikat_z_czytnika_kodow("87-1620",rzad);
	__POINTW1FN _0x0,921
	CALL SUBOPT_0xE
; 0000 048E       macierz_zaciskow[rzad]=102;
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	ST   X+,R30
	ST   X,R31
; 0000 048F     }
; 0000 0490 if(PORT_CZYTNIK.byte == 0x67)
_0x79:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x67)
	BRNE _0x7A
; 0000 0491     {
; 0000 0492       komunikat_z_czytnika_kodow("87-2019",rzad);
	__POINTW1FN _0x0,929
	CALL SUBOPT_0xE
; 0000 0493       macierz_zaciskow[rzad]=103;
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	ST   X+,R30
	ST   X,R31
; 0000 0494     }
; 0000 0495 if(PORT_CZYTNIK.byte == 0x68)
_0x7A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x68)
	BRNE _0x7B
; 0000 0496     {
; 0000 0497       komunikat_z_czytnika_kodow("87-2385",rzad);
	__POINTW1FN _0x0,937
	CALL SUBOPT_0xE
; 0000 0498       macierz_zaciskow[rzad]=104;
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	ST   X+,R30
	ST   X,R31
; 0000 0499     }
; 0000 049A if(PORT_CZYTNIK.byte == 0x69)
_0x7B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x69)
	BRNE _0x7C
; 0000 049B     {
; 0000 049C       komunikat_z_czytnika_kodow("86-0854",rzad);
	__POINTW1FN _0x0,945
	CALL SUBOPT_0xE
; 0000 049D       macierz_zaciskow[rzad]=105;
	LDI  R30,LOW(105)
	LDI  R31,HIGH(105)
	ST   X+,R30
	ST   X,R31
; 0000 049E     }
; 0000 049F if(PORT_CZYTNIK.byte == 0x6A)
_0x7C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6A)
	BRNE _0x7D
; 0000 04A0     {
; 0000 04A1       komunikat_z_czytnika_kodow("86-1622",rzad);
	__POINTW1FN _0x0,953
	CALL SUBOPT_0xE
; 0000 04A2       macierz_zaciskow[rzad]=106;
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	ST   X+,R30
	ST   X,R31
; 0000 04A3     }
; 0000 04A4 if(PORT_CZYTNIK.byte == 0x6B)
_0x7D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6B)
	BRNE _0x7E
; 0000 04A5     {
; 0000 04A6       komunikat_z_czytnika_kodow("86-2028",rzad);
	__POINTW1FN _0x0,961
	CALL SUBOPT_0xE
; 0000 04A7       macierz_zaciskow[rzad]=107;
	LDI  R30,LOW(107)
	LDI  R31,HIGH(107)
	ST   X+,R30
	ST   X,R31
; 0000 04A8     }
; 0000 04A9 if(PORT_CZYTNIK.byte == 0x6C)
_0x7E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6C)
	BRNE _0x7F
; 0000 04AA     {
; 0000 04AB       komunikat_z_czytnika_kodow("86-2437",rzad);
	__POINTW1FN _0x0,969
	CALL SUBOPT_0xE
; 0000 04AC       macierz_zaciskow[rzad]=108;
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	ST   X+,R30
	ST   X,R31
; 0000 04AD     }
; 0000 04AE if(PORT_CZYTNIK.byte == 0x6D)
_0x7F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6D)
	BRNE _0x80
; 0000 04AF     {
; 0000 04B0       komunikat_z_czytnika_kodow("87-0854",rzad);
	__POINTW1FN _0x0,977
	CALL SUBOPT_0xE
; 0000 04B1       macierz_zaciskow[rzad]=109;
	LDI  R30,LOW(109)
	LDI  R31,HIGH(109)
	ST   X+,R30
	ST   X,R31
; 0000 04B2     }
; 0000 04B3 if(PORT_CZYTNIK.byte == 0x6E)
_0x80:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6E)
	BRNE _0x81
; 0000 04B4     {
; 0000 04B5       komunikat_z_czytnika_kodow("87-1622",rzad);
	__POINTW1FN _0x0,985
	CALL SUBOPT_0xE
; 0000 04B6       macierz_zaciskow[rzad]=110;
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	ST   X+,R30
	ST   X,R31
; 0000 04B7     }
; 0000 04B8 
; 0000 04B9 if(PORT_CZYTNIK.byte == 0x6F)
_0x81:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6F)
	BRNE _0x82
; 0000 04BA     {
; 0000 04BB       komunikat_z_czytnika_kodow("87-2028",rzad);
	__POINTW1FN _0x0,993
	CALL SUBOPT_0xE
; 0000 04BC       macierz_zaciskow[rzad]=111;
	LDI  R30,LOW(111)
	LDI  R31,HIGH(111)
	ST   X+,R30
	ST   X,R31
; 0000 04BD     }
; 0000 04BE 
; 0000 04BF if(PORT_CZYTNIK.byte == 0x70)
_0x82:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x70)
	BRNE _0x83
; 0000 04C0     {
; 0000 04C1       komunikat_z_czytnika_kodow("87-2437",rzad);
	__POINTW1FN _0x0,1001
	CALL SUBOPT_0xE
; 0000 04C2       macierz_zaciskow[rzad]=112;
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   X+,R30
	ST   X,R31
; 0000 04C3     }
; 0000 04C4 if(PORT_CZYTNIK.byte == 0x71)
_0x83:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x71)
	BRNE _0x84
; 0000 04C5     {
; 0000 04C6       komunikat_z_czytnika_kodow("86-0862",rzad);
	__POINTW1FN _0x0,1009
	CALL SUBOPT_0xE
; 0000 04C7       macierz_zaciskow[rzad]=113;
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   X+,R30
	ST   X,R31
; 0000 04C8     }
; 0000 04C9 if(PORT_CZYTNIK.byte == 0x72)
_0x84:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x72)
	BRNE _0x85
; 0000 04CA     {
; 0000 04CB       komunikat_z_czytnika_kodow("86-1625",rzad);
	__POINTW1FN _0x0,1017
	CALL SUBOPT_0xE
; 0000 04CC       macierz_zaciskow[rzad]=114;
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	ST   X+,R30
	ST   X,R31
; 0000 04CD     }
; 0000 04CE if(PORT_CZYTNIK.byte == 0x73)
_0x85:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x73)
	BRNE _0x86
; 0000 04CF     {
; 0000 04D0       komunikat_z_czytnika_kodow("86-2052",rzad);
	__POINTW1FN _0x0,1025
	CALL SUBOPT_0xE
; 0000 04D1       macierz_zaciskow[rzad]=115;
	LDI  R30,LOW(115)
	LDI  R31,HIGH(115)
	ST   X+,R30
	ST   X,R31
; 0000 04D2     }
; 0000 04D3 if(PORT_CZYTNIK.byte == 0x74)
_0x86:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x74)
	BRNE _0x87
; 0000 04D4     {
; 0000 04D5       komunikat_z_czytnika_kodow("86-2492",rzad);
	__POINTW1FN _0x0,1033
	CALL SUBOPT_0xE
; 0000 04D6       macierz_zaciskow[rzad]=116;
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	ST   X+,R30
	ST   X,R31
; 0000 04D7     }
; 0000 04D8 if(PORT_CZYTNIK.byte == 0x75)
_0x87:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x75)
	BRNE _0x88
; 0000 04D9     {
; 0000 04DA       komunikat_z_czytnika_kodow("87-0862",rzad);
	__POINTW1FN _0x0,1041
	CALL SUBOPT_0xE
; 0000 04DB       macierz_zaciskow[rzad]=117;
	LDI  R30,LOW(117)
	LDI  R31,HIGH(117)
	ST   X+,R30
	ST   X,R31
; 0000 04DC     }
; 0000 04DD if(PORT_CZYTNIK.byte == 0x76)
_0x88:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x76)
	BRNE _0x89
; 0000 04DE     {
; 0000 04DF       komunikat_z_czytnika_kodow("87-1625",rzad);
	__POINTW1FN _0x0,1049
	CALL SUBOPT_0xE
; 0000 04E0       macierz_zaciskow[rzad]=118;
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	ST   X+,R30
	ST   X,R31
; 0000 04E1     }
; 0000 04E2 if(PORT_CZYTNIK.byte == 0x77)
_0x89:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x77)
	BRNE _0x8A
; 0000 04E3     {
; 0000 04E4       komunikat_z_czytnika_kodow("87-2052",rzad);
	__POINTW1FN _0x0,1057
	CALL SUBOPT_0xE
; 0000 04E5       macierz_zaciskow[rzad]=119;
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   X+,R30
	ST   X,R31
; 0000 04E6     }
; 0000 04E7 if(PORT_CZYTNIK.byte == 0x78)
_0x8A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x78)
	BRNE _0x8B
; 0000 04E8     {
; 0000 04E9       komunikat_z_czytnika_kodow("87-2492",rzad);
	__POINTW1FN _0x0,1065
	CALL SUBOPT_0xE
; 0000 04EA       macierz_zaciskow[rzad]=120;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   X+,R30
	ST   X,R31
; 0000 04EB     }
; 0000 04EC if(PORT_CZYTNIK.byte == 0x79)
_0x8B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x79)
	BRNE _0x8C
; 0000 04ED     {
; 0000 04EE       komunikat_z_czytnika_kodow("86-0935",rzad);
	__POINTW1FN _0x0,1073
	CALL SUBOPT_0xE
; 0000 04EF       macierz_zaciskow[rzad]=121;
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   X+,R30
	ST   X,R31
; 0000 04F0     }
; 0000 04F1 if(PORT_CZYTNIK.byte == 0x7A)
_0x8C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7A)
	BRNE _0x8D
; 0000 04F2     {
; 0000 04F3       komunikat_z_czytnika_kodow("86-1648",rzad);
	__POINTW1FN _0x0,1081
	CALL SUBOPT_0xE
; 0000 04F4       macierz_zaciskow[rzad]=122;
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	ST   X+,R30
	ST   X,R31
; 0000 04F5     }
; 0000 04F6 if(PORT_CZYTNIK.byte == 0x7B)
_0x8D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7B)
	BRNE _0x8E
; 0000 04F7     {
; 0000 04F8       komunikat_z_czytnika_kodow("86-2082",rzad);
	__POINTW1FN _0x0,1089
	CALL SUBOPT_0xE
; 0000 04F9       macierz_zaciskow[rzad]=123;
	LDI  R30,LOW(123)
	LDI  R31,HIGH(123)
	ST   X+,R30
	ST   X,R31
; 0000 04FA     }
; 0000 04FB if(PORT_CZYTNIK.byte == 0x7C)
_0x8E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7C)
	BRNE _0x8F
; 0000 04FC     {
; 0000 04FD       komunikat_z_czytnika_kodow("86-2500",rzad);
	__POINTW1FN _0x0,1097
	CALL SUBOPT_0xE
; 0000 04FE       macierz_zaciskow[rzad]=124;
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	ST   X+,R30
	ST   X,R31
; 0000 04FF     }
; 0000 0500 if(PORT_CZYTNIK.byte == 0x7D)
_0x8F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7D)
	BRNE _0x90
; 0000 0501     {
; 0000 0502       komunikat_z_czytnika_kodow("87-0935",rzad);
	__POINTW1FN _0x0,1105
	CALL SUBOPT_0xE
; 0000 0503       macierz_zaciskow[rzad]=125;
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   X+,R30
	ST   X,R31
; 0000 0504     }
; 0000 0505 if(PORT_CZYTNIK.byte == 0x7E)
_0x90:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7E)
	BRNE _0x91
; 0000 0506     {
; 0000 0507       komunikat_z_czytnika_kodow("87-1648",rzad);
	__POINTW1FN _0x0,1113
	CALL SUBOPT_0xE
; 0000 0508       macierz_zaciskow[rzad]=126;
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	ST   X+,R30
	ST   X,R31
; 0000 0509     }
; 0000 050A 
; 0000 050B if(PORT_CZYTNIK.byte == 0x7F)
_0x91:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7F)
	BRNE _0x92
; 0000 050C     {
; 0000 050D       komunikat_z_czytnika_kodow("87-2082",rzad);
	__POINTW1FN _0x0,1121
	CALL SUBOPT_0xE
; 0000 050E       macierz_zaciskow[rzad]=127;
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	ST   X+,R30
	ST   X,R31
; 0000 050F     }
; 0000 0510 if(PORT_CZYTNIK.byte == 0x80)
_0x92:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x80)
	BRNE _0x93
; 0000 0511     {
; 0000 0512       komunikat_z_czytnika_kodow("87-2500",rzad);
	__POINTW1FN _0x0,1129
	CALL SUBOPT_0xE
; 0000 0513       macierz_zaciskow[rzad]=128;
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   X+,R30
	ST   X,R31
; 0000 0514     }
; 0000 0515 if(PORT_CZYTNIK.byte == 0x81)
_0x93:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x81)
	BRNE _0x94
; 0000 0516     {
; 0000 0517       komunikat_z_czytnika_kodow("86-1019",rzad);
	__POINTW1FN _0x0,1137
	CALL SUBOPT_0xE
; 0000 0518       macierz_zaciskow[rzad]=129;
	LDI  R30,LOW(129)
	LDI  R31,HIGH(129)
	ST   X+,R30
	ST   X,R31
; 0000 0519     }
; 0000 051A if(PORT_CZYTNIK.byte == 0x82)
_0x94:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x82)
	BRNE _0x95
; 0000 051B     {
; 0000 051C       komunikat_z_czytnika_kodow("86-1649",rzad);
	__POINTW1FN _0x0,1145
	CALL SUBOPT_0xE
; 0000 051D       macierz_zaciskow[rzad]=130;
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	ST   X+,R30
	ST   X,R31
; 0000 051E     }
; 0000 051F if(PORT_CZYTNIK.byte == 0x83)
_0x95:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x83)
	BRNE _0x96
; 0000 0520     {
; 0000 0521       komunikat_z_czytnika_kodow("86-2083",rzad);
	__POINTW1FN _0x0,1153
	CALL SUBOPT_0xE
; 0000 0522       macierz_zaciskow[rzad]=131;
	LDI  R30,LOW(131)
	LDI  R31,HIGH(131)
	ST   X+,R30
	ST   X,R31
; 0000 0523     }
; 0000 0524 if(PORT_CZYTNIK.byte == 0x84)
_0x96:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x84)
	BRNE _0x97
; 0000 0525     {
; 0000 0526       komunikat_z_czytnika_kodow("86-2585",rzad);
	__POINTW1FN _0x0,1161
	CALL SUBOPT_0xE
; 0000 0527       macierz_zaciskow[rzad]=132;
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	ST   X+,R30
	ST   X,R31
; 0000 0528     }
; 0000 0529 if(PORT_CZYTNIK.byte == 0x85)
_0x97:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x85)
	BRNE _0x98
; 0000 052A     {
; 0000 052B       komunikat_z_czytnika_kodow("87-1019",rzad);
	__POINTW1FN _0x0,1169
	CALL SUBOPT_0xE
; 0000 052C       macierz_zaciskow[rzad]=133;
	LDI  R30,LOW(133)
	LDI  R31,HIGH(133)
	ST   X+,R30
	ST   X,R31
; 0000 052D     }
; 0000 052E if(PORT_CZYTNIK.byte == 0x86)
_0x98:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x86)
	BRNE _0x99
; 0000 052F     {
; 0000 0530       komunikat_z_czytnika_kodow("87-1649",rzad);
	__POINTW1FN _0x0,1177
	CALL SUBOPT_0xE
; 0000 0531       macierz_zaciskow[rzad]=134;
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	ST   X+,R30
	ST   X,R31
; 0000 0532     }
; 0000 0533 if(PORT_CZYTNIK.byte == 0x87)
_0x99:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x87)
	BRNE _0x9A
; 0000 0534     {
; 0000 0535       komunikat_z_czytnika_kodow("87-2083",rzad);
	__POINTW1FN _0x0,1185
	CALL SUBOPT_0xE
; 0000 0536       macierz_zaciskow[rzad]=135;
	LDI  R30,LOW(135)
	LDI  R31,HIGH(135)
	ST   X+,R30
	ST   X,R31
; 0000 0537     }
; 0000 0538 
; 0000 0539 if(PORT_CZYTNIK.byte == 0x88)
_0x9A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x88)
	BRNE _0x9B
; 0000 053A     {
; 0000 053B       komunikat_z_czytnika_kodow("87-2624",rzad);
	__POINTW1FN _0x0,1193
	CALL SUBOPT_0xE
; 0000 053C       macierz_zaciskow[rzad]=136;
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	ST   X+,R30
	ST   X,R31
; 0000 053D     }
; 0000 053E if(PORT_CZYTNIK.byte == 0x89)
_0x9B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x89)
	BRNE _0x9C
; 0000 053F     {
; 0000 0540       komunikat_z_czytnika_kodow("86-1027",rzad);
	__POINTW1FN _0x0,1201
	CALL SUBOPT_0xE
; 0000 0541       macierz_zaciskow[rzad]=137;
	LDI  R30,LOW(137)
	LDI  R31,HIGH(137)
	ST   X+,R30
	ST   X,R31
; 0000 0542     }
; 0000 0543 if(PORT_CZYTNIK.byte == 0x8A)
_0x9C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8A)
	BRNE _0x9D
; 0000 0544     {
; 0000 0545       komunikat_z_czytnika_kodow("86-1669",rzad);
	__POINTW1FN _0x0,1209
	CALL SUBOPT_0xE
; 0000 0546       macierz_zaciskow[rzad]=138;
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	ST   X+,R30
	ST   X,R31
; 0000 0547     }
; 0000 0548 if(PORT_CZYTNIK.byte == 0x8B)
_0x9D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8B)
	BRNE _0x9E
; 0000 0549     {
; 0000 054A       komunikat_z_czytnika_kodow("86-2087",rzad);
	__POINTW1FN _0x0,1217
	CALL SUBOPT_0xE
; 0000 054B       macierz_zaciskow[rzad]=139;
	LDI  R30,LOW(139)
	LDI  R31,HIGH(139)
	ST   X+,R30
	ST   X,R31
; 0000 054C     }
; 0000 054D if(PORT_CZYTNIK.byte == 0x8C)
_0x9E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8C)
	BRNE _0x9F
; 0000 054E     {
; 0000 054F       komunikat_z_czytnika_kodow("86-2624",rzad);
	__POINTW1FN _0x0,1225
	CALL SUBOPT_0xE
; 0000 0550       macierz_zaciskow[rzad]=140;
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	ST   X+,R30
	ST   X,R31
; 0000 0551     }
; 0000 0552 if(PORT_CZYTNIK.byte == 0x8D)
_0x9F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8D)
	BRNE _0xA0
; 0000 0553     {
; 0000 0554       komunikat_z_czytnika_kodow("87-1027",rzad);
	__POINTW1FN _0x0,1233
	CALL SUBOPT_0xE
; 0000 0555       macierz_zaciskow[rzad]=141;
	LDI  R30,LOW(141)
	LDI  R31,HIGH(141)
	ST   X+,R30
	ST   X,R31
; 0000 0556     }
; 0000 0557 if(PORT_CZYTNIK.byte == 0x8E)
_0xA0:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8E)
	BRNE _0xA1
; 0000 0558     {
; 0000 0559       komunikat_z_czytnika_kodow("87-1669",rzad);
	__POINTW1FN _0x0,1241
	CALL SUBOPT_0xE
; 0000 055A       macierz_zaciskow[rzad]=142;
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	ST   X+,R30
	ST   X,R31
; 0000 055B     }
; 0000 055C if(PORT_CZYTNIK.byte == 0x8F)
_0xA1:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8F)
	BRNE _0xA2
; 0000 055D     {
; 0000 055E       komunikat_z_czytnika_kodow("87-2087",rzad);
	__POINTW1FN _0x0,1249
	CALL SUBOPT_0xE
; 0000 055F       macierz_zaciskow[rzad]=143;
	LDI  R30,LOW(143)
	LDI  R31,HIGH(143)
	ST   X+,R30
	ST   X,R31
; 0000 0560     }
; 0000 0561 if(PORT_CZYTNIK.byte == 0x90)
_0xA2:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x90)
	BRNE _0xA3
; 0000 0562     {
; 0000 0563       komunikat_z_czytnika_kodow("87-2585",rzad);
	__POINTW1FN _0x0,1257
	CALL SUBOPT_0xE
; 0000 0564       macierz_zaciskow[rzad]=144;
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   X+,R30
	ST   X,R31
; 0000 0565     }
; 0000 0566 }
_0xA3:
	RET
;
;
;void wybor_linijek_sterownikow()
; 0000 056A {
_wybor_linijek_sterownikow:
; 0000 056B //zaczynam od tego
; 0000 056C //86-1349
; 0000 056D 
; 0000 056E switch(macierz_zaciskow[1])
	__GETW1MN _macierz_zaciskow,2
; 0000 056F     {
; 0000 0570     case 0:
	SBIW R30,0
	BRNE _0xA7
; 0000 0571 
; 0000 0572             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x7
	CALL SUBOPT_0xA
; 0000 0573             komunikat_na_panel("Nie wczytano zacisku",adr1,adr2);
	CALL SUBOPT_0xF
; 0000 0574 
; 0000 0575     break;
	RJMP _0xA6
; 0000 0576 
; 0000 0577 
; 0000 0578     case 34:
_0xA7:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0xA6
; 0000 0579 
; 0000 057A             a[0] = 0x5A;
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	STS  _a,R30
	STS  _a+1,R31
; 0000 057B             a[1] = 0;
	__POINTW1MN _a,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 057C             a[2] = 0x5B;
	__POINTW1MN _a,4
	LDI  R26,LOW(91)
	LDI  R27,HIGH(91)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 057D             a[3] = 0;;
	__POINTW1MN _a,6
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 057E 
; 0000 057F     break;
; 0000 0580 
; 0000 0581 
; 0000 0582 
; 0000 0583 
; 0000 0584     }
_0xA6:
; 0000 0585 
; 0000 0586 
; 0000 0587 
; 0000 0588 switch(macierz_zaciskow[2])
	__GETW1MN _macierz_zaciskow,4
; 0000 0589     {
; 0000 058A     case 0:
	SBIW R30,0
	BRNE _0xAB
; 0000 058B 
; 0000 058C             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x10
; 0000 058D             komunikat_na_panel("Nie wczytano zacisku",adr1,adr2);
	CALL SUBOPT_0xF
; 0000 058E 
; 0000 058F     break;
; 0000 0590     }
_0xAB:
; 0000 0591 
; 0000 0592 }
	RET
;
;void wypozycjonuj_napedy_minimalistyczna()
; 0000 0595 {
_wypozycjonuj_napedy_minimalistyczna:
; 0000 0596 PORTD.2 = 1;   //setup wspolny
	SBI  0x12,2
; 0000 0597 delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 0598 
; 0000 0599 while(sprawdz_pin3(PORTJJ,0x79) == 1 | sprawdz_pin3(PORTLL,0x71) == 1 |
_0xAF:
; 0000 059A       sprawdz_pin3(PORTKK,0x75) == 1 | sprawdz_pin7(PORTKK,0x75) == 1)
	CALL SUBOPT_0x9
	CALL SUBOPT_0x12
	PUSH R30
	CALL SUBOPT_0x13
	CALL SUBOPT_0x12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	POP  R26
	OR   R30,R26
	BRNE PC+3
	JMP _0xB1
; 0000 059B       {
; 0000 059C       komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x7
	CALL SUBOPT_0xA
; 0000 059D       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1286
	CALL SUBOPT_0x16
; 0000 059E       komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x10
; 0000 059F       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1286
	CALL SUBOPT_0x17
; 0000 05A0       delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 05A1 
; 0000 05A2       if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x9
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0xB2
; 0000 05A3             {
; 0000 05A4             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x7
	CALL SUBOPT_0xA
; 0000 05A5             komunikat_na_panel("Sterownik 1 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1317
	CALL SUBOPT_0x16
; 0000 05A6             delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 05A7             }
; 0000 05A8       if(sprawdz_pin3(PORTLL,0x71) == 0)
_0xB2:
	CALL SUBOPT_0x13
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0xB3
; 0000 05A9             {
; 0000 05AA             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x10
; 0000 05AB             komunikat_na_panel("Sterownik 2 - wypozycjonowalem",adr3,adr4);
	__POINTW1FN _0x0,1348
	CALL SUBOPT_0x17
; 0000 05AC             delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 05AD             }
; 0000 05AE       if(sprawdz_pin3(PORTKK,0x75) == 0)
_0xB3:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0xB4
; 0000 05AF             {
; 0000 05B0             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x7
	CALL SUBOPT_0xA
; 0000 05B1             komunikat_na_panel("Sterownik 3 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1379
	CALL SUBOPT_0x16
; 0000 05B2             delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 05B3             }
; 0000 05B4       if(sprawdz_pin7(PORTKK,0x75) == 0)
_0xB4:
	CALL SUBOPT_0x14
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0xB5
; 0000 05B5             {
; 0000 05B6             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x10
; 0000 05B7             komunikat_na_panel("Sterownik 4 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1410
	CALL SUBOPT_0x16
; 0000 05B8             delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 05B9             }
; 0000 05BA 
; 0000 05BB 
; 0000 05BC       }
_0xB5:
	RJMP _0xAF
_0xB1:
; 0000 05BD 
; 0000 05BE komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x7
	CALL SUBOPT_0xA
; 0000 05BF komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1441
	CALL SUBOPT_0x16
; 0000 05C0 komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x10
; 0000 05C1 komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1441
	CALL SUBOPT_0x17
; 0000 05C2 
; 0000 05C3 PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 05C4 delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 05C5 
; 0000 05C6 }
	RET
;
;int wypozycjonuj_LEFS32_300_1(int step)
; 0000 05C9 {
; 0000 05CA //PORTF.0   IN0  STEROWNIK3
; 0000 05CB //PORTF.1   IN1  STEROWNIK3
; 0000 05CC //PORTF.2   IN2  STEROWNIK3
; 0000 05CD //PORTF.3   IN3  STEROWNIK3
; 0000 05CE 
; 0000 05CF //PORTF.4   SETUP  STEROWNIK3
; 0000 05D0 //PORTF.5   DRIVE  STEROWNIK3
; 0000 05D1 
; 0000 05D2 //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 05D3 //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 05D4 
; 0000 05D5 
; 0000 05D6 if(step == 0)
;	step -> Y+0
; 0000 05D7 {
; 0000 05D8 switch(pozycjonowanie_LEFS32_300_1)
; 0000 05D9     {
; 0000 05DA     case 0:
; 0000 05DB             PORT_F.bits.b4 = 1;      // ////A9  SETUP
; 0000 05DC             PORTF = PORT_F.byte;
; 0000 05DD 
; 0000 05DE             if(sprawdz_pin0(PORTKK,0x75) == 1)  //BUSY
; 0000 05DF                 {
; 0000 05E0                 }
; 0000 05E1             else
; 0000 05E2                 {
; 0000 05E3                 pozycjonowanie_LEFS32_300_1 = 1;
; 0000 05E4                 }
; 0000 05E5 
; 0000 05E6     break;
; 0000 05E7 
; 0000 05E8     case 1:
; 0000 05E9             if(sprawdz_pin0(PORTKK,0x75) == 0)
; 0000 05EA                 {
; 0000 05EB                 }
; 0000 05EC             else
; 0000 05ED                 {
; 0000 05EE                 pozycjonowanie_LEFS32_300_1 = 2;
; 0000 05EF                 }
; 0000 05F0             if(sprawdz_pin7(PORTMM,0x77) == 1)     //alarm
; 0000 05F1                    {
; 0000 05F2                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 05F3                    komunikat_na_panel("Przeciazenia LEFS32_1",adr1,adr2);
; 0000 05F4                    }
; 0000 05F5 
; 0000 05F6     break;
; 0000 05F7 
; 0000 05F8     case 2:
; 0000 05F9 
; 0000 05FA             if(sprawdz_pin3(PORTKK,0x75) == 1)
; 0000 05FB                 {
; 0000 05FC                 }
; 0000 05FD             else
; 0000 05FE                 {
; 0000 05FF                 pozycjonowanie_LEFS32_300_1 = 3;
; 0000 0600                 }
; 0000 0601              if(sprawdz_pin7(PORTMM,0x77) == 1)     //alarm
; 0000 0602                    {
; 0000 0603                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 0604                    komunikat_na_panel("Przeciazenia LEFS32_1",adr1,adr2);
; 0000 0605                    }
; 0000 0606 
; 0000 0607     break;
; 0000 0608 
; 0000 0609     case 3:
; 0000 060A 
; 0000 060B             if(sprawdz_pin3(PORTKK,0x75) == 0)
; 0000 060C                 {
; 0000 060D                 PORT_F.bits.b4 = 0;      // ////A9  SETUP
; 0000 060E                 PORTF = PORT_F.byte;
; 0000 060F                 pozycjonowanie_LEFS32_300_1 = 4;
; 0000 0610 
; 0000 0611                 }
; 0000 0612 
; 0000 0613     break;
; 0000 0614 
; 0000 0615     }
; 0000 0616 }
; 0000 0617 
; 0000 0618 
; 0000 0619 
; 0000 061A if(step == 1)
; 0000 061B {
; 0000 061C while(cykl < 5)
; 0000 061D {
; 0000 061E     switch(cykl)
; 0000 061F         {
; 0000 0620         case 0:
; 0000 0621 
; 0000 0622             PORTE.7 = 1;  ////////////////////////////////////////////////////////////////////czasowo aby pokazac
; 0000 0623             sek2 = 0;
; 0000 0624             PORT_F.bits.b0 = 1;
; 0000 0625             PORT_F.bits.b1 = 1;         //STEP 0
; 0000 0626             PORT_F.bits.b2 = 1;
; 0000 0627             PORT_F.bits.b3 = 1;
; 0000 0628             PORTF = PORT_F.byte;
; 0000 0629             cykl = 1;
; 0000 062A 
; 0000 062B 
; 0000 062C         break;
; 0000 062D 
; 0000 062E         case 1:
; 0000 062F 
; 0000 0630             if(sek2 > 1)
; 0000 0631                 {
; 0000 0632                 PORT_F.bits.b5 = 1;
; 0000 0633                 PORTF = PORT_F.byte;
; 0000 0634                 cykl = 2;
; 0000 0635                 delay_ms(1000);
; 0000 0636                 }
; 0000 0637         break;
; 0000 0638 
; 0000 0639 
; 0000 063A         case 2:
; 0000 063B 
; 0000 063C                if(sprawdz_pin0(PORTKK,0x75) == 0)
; 0000 063D                   {
; 0000 063E                   PORT_F.bits.b5 = 0;
; 0000 063F                   PORTF = PORT_F.byte;       //DRIVE koniec
; 0000 0640 
; 0000 0641                   PORT_F.bits.b0 = 0;
; 0000 0642                   PORT_F.bits.b1 = 0;         //STEP 1 koniec
; 0000 0643                   PORT_F.bits.b2 = 0;
; 0000 0644                   PORT_F.bits.b3 = 0;
; 0000 0645                   PORTF = PORT_F.byte;
; 0000 0646 
; 0000 0647                   delay_ms(1000);
; 0000 0648                   cykl = 3;
; 0000 0649                   }
; 0000 064A 
; 0000 064B         break;
; 0000 064C 
; 0000 064D         case 3:
; 0000 064E 
; 0000 064F                if(sprawdz_pin3(PORTKK,0x75) == 0)
; 0000 0650                   {
; 0000 0651                   sek2 = 0;
; 0000 0652                   cykl = 4;
; 0000 0653                   }
; 0000 0654               if(sprawdz_pin7(PORTMM,0x77) == 1)     //alarm
; 0000 0655                    {
; 0000 0656                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 0657                    komunikat_na_panel("Przeciazenia LEFS32_1",adr1,adr2);
; 0000 0658                    }
; 0000 0659 
; 0000 065A         break;
; 0000 065B 
; 0000 065C 
; 0000 065D         case 4:
; 0000 065E 
; 0000 065F             if(sek2 > 50)
; 0000 0660                 {
; 0000 0661                 cykl = 5;
; 0000 0662                 }
; 0000 0663         break;
; 0000 0664 
; 0000 0665         }
; 0000 0666 }
; 0000 0667 
; 0000 0668 cykl = 0;
; 0000 0669 }
; 0000 066A 
; 0000 066B 
; 0000 066C 
; 0000 066D 
; 0000 066E 
; 0000 066F if(step == 0 & pozycjonowanie_LEFS32_300_1 == 4)
; 0000 0670     {
; 0000 0671     pozycjonowanie_LEFS32_300_1 = 0;
; 0000 0672     cykl = 0;
; 0000 0673     return 1;
; 0000 0674     }
; 0000 0675 if(step == 1)
; 0000 0676     return 2;
; 0000 0677 
; 0000 0678 
; 0000 0679 
; 0000 067A }
;
;
;int wypozycjonuj_LEFS32_300_2(int step)
; 0000 067E {
; 0000 067F //PORTB.0   IN0  STEROWNIK4
; 0000 0680 //PORTB.1   IN1  STEROWNIK4
; 0000 0681 //PORTB.2   IN2  STEROWNIK4
; 0000 0682 //PORTB.3   IN3  STEROWNIK4
; 0000 0683 
; 0000 0684 //PORTB.4   SETUP  STEROWNIK4
; 0000 0685 //PORTB.5   DRIVE  STEROWNIK4
; 0000 0686 
; 0000 0687 //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 0688 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 0689 
; 0000 068A 
; 0000 068B if(step == 0)
;	step -> Y+0
; 0000 068C {
; 0000 068D switch(pozycjonowanie_LEFS32_300_2)
; 0000 068E     {
; 0000 068F     case 0:
; 0000 0690             PORTB.4 = 1;      // ////A9  SETUP
; 0000 0691 
; 0000 0692             if(sprawdz_pin4(PORTKK,0x75) == 1)  //BUSY
; 0000 0693                 {
; 0000 0694                 }
; 0000 0695             else
; 0000 0696                 pozycjonowanie_LEFS32_300_2 = 1;
; 0000 0697 
; 0000 0698     break;
; 0000 0699 
; 0000 069A     case 1:
; 0000 069B             if(sprawdz_pin4(PORTKK,0x75) == 0)
; 0000 069C                 {
; 0000 069D                 }
; 0000 069E             else
; 0000 069F                 pozycjonowanie_LEFS32_300_2 = 2;
; 0000 06A0 
; 0000 06A1              if(sprawdz_pin6(PORTMM,0x77) == 1)     //alarm
; 0000 06A2                    {
; 0000 06A3                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 06A4                    komunikat_na_panel("Przeciazenia LEFS32_2",adr3,adr4);
; 0000 06A5                    }
; 0000 06A6 
; 0000 06A7     break;
; 0000 06A8 
; 0000 06A9     case 2:
; 0000 06AA 
; 0000 06AB             if(sprawdz_pin7(PORTKK,0x75) == 1)
; 0000 06AC                 {
; 0000 06AD                 }
; 0000 06AE             else
; 0000 06AF                 pozycjonowanie_LEFS32_300_2 = 3;
; 0000 06B0 
; 0000 06B1             if(sprawdz_pin6(PORTMM,0x77) == 1)     //alarm
; 0000 06B2                    {
; 0000 06B3                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 06B4                    komunikat_na_panel("Przeciazenia LEFS32_2",adr3,adr4);
; 0000 06B5                    }
; 0000 06B6 
; 0000 06B7     break;
; 0000 06B8 
; 0000 06B9     case 3:
; 0000 06BA 
; 0000 06BB             if(sprawdz_pin7(PORTKK,0x75) == 0)
; 0000 06BC                 {
; 0000 06BD                 PORTB.4 = 0;      // ////A9  SETUP
; 0000 06BE 
; 0000 06BF                 pozycjonowanie_LEFS32_300_2 = 4;
; 0000 06C0                 }
; 0000 06C1 
; 0000 06C2     break;
; 0000 06C3 
; 0000 06C4     }
; 0000 06C5 }
; 0000 06C6 
; 0000 06C7 if(step == 1)
; 0000 06C8 {
; 0000 06C9 while(cykl < 5)
; 0000 06CA {
; 0000 06CB     switch(cykl)
; 0000 06CC         {
; 0000 06CD         case 0:
; 0000 06CE 
; 0000 06CF             sek4 = 0;
; 0000 06D0             PORTB.0 = 1;    //STEP 0
; 0000 06D1             PORTB.1 = 1;
; 0000 06D2             PORTB.2 = 1;
; 0000 06D3             PORTB.3 = 1;
; 0000 06D4 
; 0000 06D5             cykl = 1;
; 0000 06D6 
; 0000 06D7 
; 0000 06D8         break;
; 0000 06D9 
; 0000 06DA         case 1:
; 0000 06DB 
; 0000 06DC             if(sek4 > 1)
; 0000 06DD                 {
; 0000 06DE                 PORTB.5 = 1;
; 0000 06DF                 cykl = 2;
; 0000 06E0                 delay_ms(1000);
; 0000 06E1                 }
; 0000 06E2         break;
; 0000 06E3 
; 0000 06E4 
; 0000 06E5         case 2:
; 0000 06E6 
; 0000 06E7                if(sprawdz_pin4(PORTKK,0x75) == 0)
; 0000 06E8                   {
; 0000 06E9                   PORTB.5 = 0;
; 0000 06EA                       //DRIVE koniec
; 0000 06EB 
; 0000 06EC                   PORTB.0 = 0;    //STEP 0
; 0000 06ED                   PORTB.1 = 0;
; 0000 06EE                   PORTB.2 = 0;
; 0000 06EF                   PORTB.3 = 0;
; 0000 06F0 
; 0000 06F1 
; 0000 06F2                   delay_ms(1000);
; 0000 06F3                   cykl = 3;
; 0000 06F4                   }
; 0000 06F5 
; 0000 06F6         break;
; 0000 06F7 
; 0000 06F8         case 3:
; 0000 06F9 
; 0000 06FA                if(sprawdz_pin7(PORTKK,0x75) == 0)
; 0000 06FB                   {
; 0000 06FC                   sek4 = 0;
; 0000 06FD                   cykl = 4;
; 0000 06FE                   }
; 0000 06FF                if(sprawdz_pin6(PORTMM,0x77) == 1)     //alarm
; 0000 0700                    {
; 0000 0701                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 0702                    komunikat_na_panel("Przeciazenia LEFS32_2",adr3,adr4);
; 0000 0703                    }
; 0000 0704 
; 0000 0705 
; 0000 0706         break;
; 0000 0707 
; 0000 0708 
; 0000 0709         case 4:
; 0000 070A 
; 0000 070B             if(sek4 > 50)
; 0000 070C                 cykl = 5;
; 0000 070D         break;
; 0000 070E 
; 0000 070F         }
; 0000 0710 }
; 0000 0711 
; 0000 0712 cykl = 0;
; 0000 0713 }
; 0000 0714 
; 0000 0715 if(step == 0 & pozycjonowanie_LEFS32_300_2 == 4)
; 0000 0716     {
; 0000 0717     pozycjonowanie_LEFS32_300_2 = 0;
; 0000 0718     cykl = 0;
; 0000 0719     return 1;
; 0000 071A     }
; 0000 071B if(step == 1)
; 0000 071C     return 2;
; 0000 071D 
; 0000 071E }
;
;
;
;
;
;
;int wypozycjonuj_LEFS40_1200_2_i_300_2()
; 0000 0726 {
; 0000 0727 //PORTC.0   IN0  STEROWNIK2
; 0000 0728 //PORTC.1   IN1  STEROWNIK2
; 0000 0729 //PORTC.2   IN2  STEROWNIK2
; 0000 072A //PORTC.3   IN3  STEROWNIK2
; 0000 072B //PORTC.4   IN4  STEROWNIK2
; 0000 072C //PORTC.5   IN5  STEROWNIK2
; 0000 072D //PORTC.6   IN6  STEROWNIK2
; 0000 072E //PORTC.7   IN7  STEROWNIK2
; 0000 072F 
; 0000 0730 //PORTD.5  SETUP   STEROWNIK2
; 0000 0731 //PORTD.6  DRIVE   STEROWNIK2
; 0000 0732 
; 0000 0733 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 0734 //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 0735 
; 0000 0736 PORTD.5 = 1;    //SETUP
; 0000 0737 
; 0000 0738 delay_ms(50);
; 0000 0739 
; 0000 073A while(sprawdz_pin0(PORTLL,0x71) == 1)  //kraze tu poki nie wywali busy
; 0000 073B         {
; 0000 073C 
; 0000 073D                    if(sprawdz_pin5(PORTLL,0x71) == 1)     //alarm
; 0000 073E                    {
; 0000 073F                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 0740                    komunikat_na_panel("Przeciazenia LEFS_XY_2",adr3,adr4);
; 0000 0741                    }
; 0000 0742 
; 0000 0743         }
; 0000 0744 
; 0000 0745 delay_ms(50);
; 0000 0746 
; 0000 0747 while(sprawdz_pin0(PORTLL,0x71) == 0)  //wywala busy
; 0000 0748         {
; 0000 0749 
; 0000 074A                    if(sprawdz_pin5(PORTLL,0x71) == 1)     //alarm
; 0000 074B                    {
; 0000 074C                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 074D                    komunikat_na_panel("Przeciazenia LEFS_XY_2",adr3,adr4);
; 0000 074E                    }
; 0000 074F         }
; 0000 0750 
; 0000 0751 delay_ms(50);
; 0000 0752 
; 0000 0753 while(sprawdz_pin3(PORTLL,0x71) == 1)  //kraze tu dopoki nie wywali INP
; 0000 0754         {
; 0000 0755         }
; 0000 0756 
; 0000 0757 delay_ms(50);
; 0000 0758 
; 0000 0759 if(sprawdz_pin3(PORTLL,0x71) == 0)  //wywala INP
; 0000 075A         {
; 0000 075B         PORTD.5 = 0;
; 0000 075C         putchar(90);  //5A
; 0000 075D         putchar(165); //A5
; 0000 075E         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 075F         putchar(128);  //80
; 0000 0760         putchar(2);    //02
; 0000 0761         putchar(16);   //10
; 0000 0762         }
; 0000 0763 else
; 0000 0764     {
; 0000 0765         putchar(90);  //5A
; 0000 0766         putchar(165); //A5
; 0000 0767         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 0768         putchar(128);  //80
; 0000 0769         putchar(2);    //02
; 0000 076A         putchar(16);   //10
; 0000 076B 
; 0000 076C         delay_ms(1000);     //wywalenie bledu
; 0000 076D         delay_ms(1000);
; 0000 076E 
; 0000 076F         putchar(90);  //5A
; 0000 0770         putchar(165); //A5
; 0000 0771         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 0772         putchar(128);  //80
; 0000 0773         putchar(2);    //02
; 0000 0774         putchar(16);   //10
; 0000 0775 
; 0000 0776     }
; 0000 0777 
; 0000 0778 delay_ms(1000);
; 0000 0779 
; 0000 077A while(cykl < 5)
; 0000 077B {
; 0000 077C     switch(cykl)
; 0000 077D         {
; 0000 077E         case 0:
; 0000 077F 
; 0000 0780             PORTC = 0xFF;   //STEP 0
; 0000 0781             cykl = 1;
; 0000 0782 
; 0000 0783         break;
; 0000 0784 
; 0000 0785         case 1:
; 0000 0786 
; 0000 0787             if(sek3 > 1)
; 0000 0788                 {
; 0000 0789                 PORTD.6 = 1;  //DRIVE
; 0000 078A                 cykl = 2;
; 0000 078B                 }
; 0000 078C         break;
; 0000 078D 
; 0000 078E 
; 0000 078F         case 2:
; 0000 0790 
; 0000 0791                if(sprawdz_pin0(PORTLL,0x71) == 0)
; 0000 0792                   {
; 0000 0793                   PORTD.6 = 0;
; 0000 0794                   PORTC = 0x00;        //STEP 1 koniec
; 0000 0795                   cykl = 3;
; 0000 0796                   }
; 0000 0797 
; 0000 0798         break;
; 0000 0799 
; 0000 079A         case 3:
; 0000 079B 
; 0000 079C                if(sprawdz_pin3(PORTLL,0x71) == 0)
; 0000 079D                   {
; 0000 079E                   sek3 = 0;
; 0000 079F                   cykl = 4;
; 0000 07A0                   }
; 0000 07A1 
; 0000 07A2                    if(sprawdz_pin5(PORTLL,0x71) == 1)     //alarm
; 0000 07A3                    {
; 0000 07A4                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 07A5                    komunikat_na_panel("Przeciazenia LEFS_XY_2",adr3,adr4);
; 0000 07A6                    }
; 0000 07A7 
; 0000 07A8 
; 0000 07A9         break;
; 0000 07AA 
; 0000 07AB 
; 0000 07AC         case 4:
; 0000 07AD 
; 0000 07AE             if(sek3 > 50)
; 0000 07AF                 cykl = 5;
; 0000 07B0         break;
; 0000 07B1 
; 0000 07B2         }
; 0000 07B3 }
; 0000 07B4 
; 0000 07B5 cykl = 0;
; 0000 07B6 return 1;
; 0000 07B7 }
;
;
;
;
;int wypozycjonuj_LEFS40_1200_1_i_300_1()
; 0000 07BD {
; 0000 07BE //chyba nie wpiete A7
; 0000 07BF 
; 0000 07C0 //PORTA.0   IN0  STEROWNIK1
; 0000 07C1 //PORTA.1   IN1  STEROWNIK1
; 0000 07C2 //PORTA.2   IN2  STEROWNIK1
; 0000 07C3 //PORTA.3   IN3  STEROWNIK1
; 0000 07C4 //PORTA.4   IN4  STEROWNIK1
; 0000 07C5 //PORTA.5   IN5  STEROWNIK1
; 0000 07C6 //PORTA.6   IN6  STEROWNIK1
; 0000 07C7 //PORTA.7   IN7  STEROWNIK1
; 0000 07C8 
; 0000 07C9 //PORTD.2  SETUP   STEROWNIK1
; 0000 07CA //PORTD.3  DRIVE   STEROWNIK1
; 0000 07CB 
; 0000 07CC //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 07CD //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 07CE 
; 0000 07CF PORTD.2 = 1;    //SETUP
; 0000 07D0 
; 0000 07D1 delay_ms(50);
; 0000 07D2 
; 0000 07D3 while(sprawdz_pin0(PORTJJ,0x79) == 1)  //kraze tu poki nie wywali busy
; 0000 07D4         {
; 0000 07D5             if(sprawdz_pin5(PORTJJ,0x79) == 1)     //alarm
; 0000 07D6                    {
; 0000 07D7                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 07D8                    komunikat_na_panel("Przeciazenia LEFS_XY_1",adr1,adr2);
; 0000 07D9                    }
; 0000 07DA         }
; 0000 07DB 
; 0000 07DC delay_ms(50);
; 0000 07DD 
; 0000 07DE while(sprawdz_pin0(PORTJJ,0x79) == 0)  //wywala busy
; 0000 07DF         {
; 0000 07E0             if(sprawdz_pin5(PORTJJ,0x79) == 1)     //alarm
; 0000 07E1                    {
; 0000 07E2                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 07E3                    komunikat_na_panel("Przeciazenia LEFS_XY_1",adr1,adr2);
; 0000 07E4                    }
; 0000 07E5 
; 0000 07E6         }
; 0000 07E7 
; 0000 07E8 delay_ms(50);
; 0000 07E9 
; 0000 07EA while(sprawdz_pin3(PORTJJ,0x79) == 1)  //kraze tu dopoki nie wywali INP
; 0000 07EB         {
; 0000 07EC         }
; 0000 07ED 
; 0000 07EE delay_ms(50);
; 0000 07EF 
; 0000 07F0 if(sprawdz_pin3(PORTJJ,0x79) == 0)  //wywala INP
; 0000 07F1         {
; 0000 07F2         PORTD.2 = 0;
; 0000 07F3         putchar(90);  //5A
; 0000 07F4         putchar(165); //A5
; 0000 07F5         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 07F6         putchar(128);  //80
; 0000 07F7         putchar(2);    //02
; 0000 07F8         putchar(16);   //10
; 0000 07F9         }
; 0000 07FA else
; 0000 07FB     {
; 0000 07FC         putchar(90);  //5A
; 0000 07FD         putchar(165); //A5
; 0000 07FE         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 07FF         putchar(128);  //80
; 0000 0800         putchar(2);    //02
; 0000 0801         putchar(16);   //10
; 0000 0802 
; 0000 0803         delay_ms(1000);     //wywalenie bledu
; 0000 0804         delay_ms(1000);
; 0000 0805 
; 0000 0806         putchar(90);  //5A
; 0000 0807         putchar(165); //A5
; 0000 0808         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 0809         putchar(128);  //80
; 0000 080A         putchar(2);    //02
; 0000 080B         putchar(16);   //10
; 0000 080C 
; 0000 080D     }
; 0000 080E 
; 0000 080F delay_ms(1000);
; 0000 0810 
; 0000 0811 while(cykl < 5)
; 0000 0812 {
; 0000 0813     switch(cykl)
; 0000 0814         {
; 0000 0815         case 0:
; 0000 0816 
; 0000 0817             PORTA = 0xFF;   //STEP 0
; 0000 0818             cykl = 1;
; 0000 0819 
; 0000 081A         break;
; 0000 081B 
; 0000 081C         case 1:
; 0000 081D 
; 0000 081E             if(sek1 > 1)
; 0000 081F                 {
; 0000 0820                 PORTD.3 = 1;  //DRIVE
; 0000 0821                 cykl = 2;
; 0000 0822                 }
; 0000 0823         break;
; 0000 0824 
; 0000 0825 
; 0000 0826         case 2:
; 0000 0827 
; 0000 0828                if(sprawdz_pin0(PORTJJ,0x79) == 0)
; 0000 0829                   {
; 0000 082A                   PORTD.3 = 0;
; 0000 082B                   PORTA = 0x00;        //STEP 1 koniec
; 0000 082C                   cykl = 3;
; 0000 082D                   }
; 0000 082E 
; 0000 082F         break;
; 0000 0830 
; 0000 0831         case 3:
; 0000 0832 
; 0000 0833                if(sprawdz_pin3(PORTJJ,0x79) == 0)
; 0000 0834                   {
; 0000 0835                   sek1 = 0;
; 0000 0836                   cykl = 4;
; 0000 0837                   }
; 0000 0838 
; 0000 0839                if(sprawdz_pin5(PORTJJ,0x79) == 1)     //alarm
; 0000 083A                    {
; 0000 083B                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 083C                    komunikat_na_panel("Przeciazenia LEFS_XY_1",adr1,adr2);
; 0000 083D                    }
; 0000 083E 
; 0000 083F 
; 0000 0840         break;
; 0000 0841 
; 0000 0842 
; 0000 0843         case 4:
; 0000 0844 
; 0000 0845             if(sek1 > 50)
; 0000 0846                 cykl = 5;
; 0000 0847         break;
; 0000 0848 
; 0000 0849         }
; 0000 084A }
; 0000 084B 
; 0000 084C cykl = 0;
; 0000 084D return 1;
; 0000 084E }
;
;
;
;
;
;
;
;
;
;void wypozycjonuj_napedy()
; 0000 0859 {
; 0000 085A //if(aaa == 0)
; 0000 085B //        {
; 0000 085C //        aaa = wypozycjonuj_LEFS40_1200_1_i_300_1();
; 0000 085D //        }
; 0000 085E if(bbb == 0)
; 0000 085F         {
; 0000 0860         bbb = wypozycjonuj_LEFS32_300_1(0);
; 0000 0861         }
; 0000 0862 if(bbb == 1)
; 0000 0863         {
; 0000 0864         bbb = wypozycjonuj_LEFS32_300_1(1);
; 0000 0865        }
; 0000 0866 
; 0000 0867 
; 0000 0868 //if(ccc == 0)
; 0000 0869 //        {
; 0000 086A //        ccc = wypozycjonuj_LEFS40_1200_2_i_300_2();
; 0000 086B //        }
; 0000 086C //if(ddd == 0)
; 0000 086D //        {
; 0000 086E //        ddd = wypozycjonuj_LEFS32_300_2(0);
; 0000 086F //       }
; 0000 0870 //if(ddd == 1)
; 0000 0871 //        {
; 0000 0872 //        ddd = wypozycjonuj_LEFS32_300_2(1);
; 0000 0873 //        }
; 0000 0874 
; 0000 0875 
; 0000 0876 
; 0000 0877 
; 0000 0878 
; 0000 0879 
; 0000 087A    /*
; 0000 087B 
; 0000 087C     if(ccc == 1 & bbb == 1)
; 0000 087D         ccc = wypozycjonuj_NL3_upgrade(1);
; 0000 087E 
; 0000 087F     if(bbb == 1 & ccc == 2)
; 0000 0880         bbb = wypozycjonuj_NL2_upgrade(1);
; 0000 0881 
; 0000 0882 
; 0000 0883     if(aaa == 1 & bbb == 2 & ccc == 2)
; 0000 0884         {
; 0000 0885         start = 1;
; 0000 0886         }
; 0000 0887 
; 0000 0888     */
; 0000 0889 
; 0000 088A //    if(aaa == 1 & bbb == 2 & ccc == 2 & ddd == 2)
; 0000 088B //        start = 1;
; 0000 088C 
; 0000 088D 
; 0000 088E }
;
;
;
;void przerzucanie_dociskow()
; 0000 0893 {
_przerzucanie_dociskow:
; 0000 0894    if(sprawdz_pin6(PORTLL,0x71) == 0 & sprawdz_pin7(PORTLL,0x71) == 0 & czekaj_az_puszcze == 0)
	CALL SUBOPT_0x13
	CALL _sprawdz_pin6
	LDI  R26,LOW(0)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0x13
	CALL _sprawdz_pin7
	LDI  R26,LOW(0)
	CALL __EQB12
	POP  R26
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	AND  R30,R0
	BREQ _0x166
; 0000 0895            {
; 0000 0896            czekaj_az_puszcze = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 0897            PORTB.6 = 1;
	SBI  0x18,6
; 0000 0898            }
; 0000 0899        if(sprawdz_pin6(PORTLL,0x71) == 1 & sprawdz_pin7(PORTLL,0x71) == 1 & czekaj_az_puszcze == 1)
_0x166:
	CALL SUBOPT_0x13
	CALL _sprawdz_pin6
	LDI  R26,LOW(1)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0x13
	CALL SUBOPT_0x15
	POP  R26
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	AND  R30,R0
	BREQ _0x169
; 0000 089A            {
; 0000 089B            czekaj_az_puszcze = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 089C            PORTB.6 = 0;
	CBI  0x18,6
; 0000 089D            }
; 0000 089E 
; 0000 089F        if(czekaj_az_puszcze == 2 & PORTE.6 == 1)
_0x169:
	CALL SUBOPT_0x1B
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x16C
; 0000 08A0             {
; 0000 08A1             PORTE.6 = 0;
	CBI  0x3,6
; 0000 08A2             czekaj_az_puszcze = 0;
	CALL SUBOPT_0x1C
; 0000 08A3             delay_ms(100);
; 0000 08A4             }
; 0000 08A5 
; 0000 08A6        if(czekaj_az_puszcze == 2 & PORTE.6 == 0)
_0x16C:
	CALL SUBOPT_0x1B
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x16F
; 0000 08A7            {
; 0000 08A8             PORTE.6 = 1;
	SBI  0x3,6
; 0000 08A9             czekaj_az_puszcze = 0;
	CALL SUBOPT_0x1C
; 0000 08AA             delay_ms(100);
; 0000 08AB            }
; 0000 08AC 
; 0000 08AD }
_0x16F:
	RET
;
;void ostateczny_wybor_zacisku()
; 0000 08B0 {
_ostateczny_wybor_zacisku:
; 0000 08B1   if(sek11 > 40) //co 1s sekunde sprawdzam
	LDS  R26,_sek11
	LDS  R27,_sek11+1
	LDS  R24,_sek11+2
	LDS  R25,_sek11+3
	__CPD2N 0x29
	BRGE PC+3
	JMP _0x172
; 0000 08B2         {
; 0000 08B3        sek11 = 0;
	CALL SUBOPT_0x1D
; 0000 08B4        if(odczytalem_zacisk < il_prob_odczytu &
; 0000 08B5                                            (sprawdz_pin0(PORTHH,0x73) == 1 |
; 0000 08B6                                             sprawdz_pin1(PORTHH,0x73) == 1 |
; 0000 08B7                                             sprawdz_pin2(PORTHH,0x73) == 1 |
; 0000 08B8                                             sprawdz_pin3(PORTHH,0x73) == 1 |
; 0000 08B9                                             sprawdz_pin4(PORTHH,0x73) == 1 |
; 0000 08BA                                             sprawdz_pin5(PORTHH,0x73) == 1 |
; 0000 08BB                                             sprawdz_pin6(PORTHH,0x73) == 1 |
; 0000 08BC                                             sprawdz_pin7(PORTHH,0x73) == 1))
	MOVW R30,R10
	MOVW R26,R8
	CALL __LTW12
	PUSH R30
	CALL SUBOPT_0xB
	CALL _sprawdz_pin0
	LDI  R26,LOW(1)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0xB
	CALL _sprawdz_pin1
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0xB
	CALL _sprawdz_pin2
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0x12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0xB
	CALL _sprawdz_pin4
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0xB
	CALL _sprawdz_pin5
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0xB
	CALL _sprawdz_pin6
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0x15
	POP  R26
	OR   R30,R26
	POP  R26
	AND  R30,R26
	BREQ _0x173
; 0000 08BD         {
; 0000 08BE         odczytalem_zacisk++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 08BF         }
; 0000 08C0         }
_0x173:
; 0000 08C1 
; 0000 08C2 if(odczytalem_zacisk == il_prob_odczytu)
_0x172:
	__CPWRR 10,11,8,9
	BRNE _0x174
; 0000 08C3         {
; 0000 08C4         //PORTB = 0xFF;
; 0000 08C5         odczyt_wybranego_zacisku();
	CALL _odczyt_wybranego_zacisku
; 0000 08C6         //sek10 = 0;
; 0000 08C7         sek11 = 0;    //nowe
	CALL SUBOPT_0x1D
; 0000 08C8         odczytalem_zacisk++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 08C9         if(rzad == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x175
; 0000 08CA             wartosc_parametru_panelu(2,32,128);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x285
; 0000 08CB         else
_0x175:
; 0000 08CC             wartosc_parametru_panelu(1,32,128);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x285:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xD
	CALL _wartosc_parametru_panelu
; 0000 08CD 
; 0000 08CE         }                                     //& sek10 > 1                //3s po odczytaniu dopiero sprawdzam port
; 0000 08CF if((odczytalem_zacisk == il_prob_odczytu + 1))        //183
_0x174:
	MOVW R30,R10
	ADIW R30,1
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x177
; 0000 08D0         {
; 0000 08D1         odczytalem_zacisk = 0;
	CLR  R8
	CLR  R9
; 0000 08D2         }
; 0000 08D3 }
_0x177:
	RET
;
;
;
;int sterownik_1_praca(int PORT, int a)
; 0000 08D8 {
_sterownik_1_praca:
; 0000 08D9 //PORTA.0   IN0  STEROWNIK1
; 0000 08DA //PORTA.1   IN1  STEROWNIK1
; 0000 08DB //PORTA.2   IN2  STEROWNIK1
; 0000 08DC //PORTA.3   IN3  STEROWNIK1
; 0000 08DD //PORTA.4   IN4  STEROWNIK1
; 0000 08DE //PORTA.5   IN5  STEROWNIK1
; 0000 08DF //PORTA.6   IN6  STEROWNIK1
; 0000 08E0 //PORTA.7   IN7  STEROWNIK1
; 0000 08E1 //PORTD.4   IN8 STEROWNIK1
; 0000 08E2 
; 0000 08E3 //PORTD.2  SETUP   STEROWNIK1
; 0000 08E4 //PORTD.3  DRIVE   STEROWNIK1
; 0000 08E5 
; 0000 08E6 //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 08E7 //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 08E8 
; 0000 08E9 switch(cykl_sterownik_1)
;	PORT -> Y+2
;	a -> Y+0
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
; 0000 08EA         {
; 0000 08EB         case 0:
	SBIW R30,0
	BRNE _0x17B
; 0000 08EC 
; 0000 08ED             sek1 = 0;
	CALL SUBOPT_0x1E
; 0000 08EE             PORTA = PORT;
	LDD  R30,Y+2
	OUT  0x1B,R30
; 0000 08EF             PORTD.4 = a;
	LD   R30,Y
	CPI  R30,0
	BRNE _0x17C
	CBI  0x12,4
	RJMP _0x17D
_0x17C:
	SBI  0x12,4
_0x17D:
; 0000 08F0 
; 0000 08F1             cykl_sterownik_1 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x286
; 0000 08F2 
; 0000 08F3         break;
; 0000 08F4 
; 0000 08F5         case 1:
_0x17B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x17E
; 0000 08F6 
; 0000 08F7             if(sek1 > 1)
	LDS  R26,_sek1
	LDS  R27,_sek1+1
	LDS  R24,_sek1+2
	LDS  R25,_sek1+3
	CALL SUBOPT_0x1F
	BRLT _0x17F
; 0000 08F8                 {
; 0000 08F9 
; 0000 08FA                 PORTD.3 = 1;
	SBI  0x12,3
; 0000 08FB                 cykl_sterownik_1 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x20
; 0000 08FC                 }
; 0000 08FD         break;
_0x17F:
	RJMP _0x17A
; 0000 08FE 
; 0000 08FF 
; 0000 0900         case 2:
_0x17E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x182
; 0000 0901 
; 0000 0902                if(sprawdz_pin0(PORTJJ,0x79) == 0)     //busy
	CALL SUBOPT_0x9
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x183
; 0000 0903                   {
; 0000 0904 
; 0000 0905                   PORTD.3 = 0;
	CBI  0x12,3
; 0000 0906                   PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0907                   PORTD.4 = 0;
	CBI  0x12,4
; 0000 0908                   sek1 = 0;
	CALL SUBOPT_0x1E
; 0000 0909                   cykl_sterownik_1 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x20
; 0000 090A                   }
; 0000 090B 
; 0000 090C         break;
_0x183:
	RJMP _0x17A
; 0000 090D 
; 0000 090E         case 3:
_0x182:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x188
; 0000 090F 
; 0000 0910                if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x9
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x189
; 0000 0911                   {
; 0000 0912 
; 0000 0913                   sek1 = 0;
	CALL SUBOPT_0x1E
; 0000 0914                   cykl_sterownik_1 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x20
; 0000 0915                   }
; 0000 0916 
; 0000 0917 
; 0000 0918         break;
_0x189:
	RJMP _0x17A
; 0000 0919 
; 0000 091A 
; 0000 091B         case 4:
_0x188:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x17A
; 0000 091C 
; 0000 091D             if(sprawdz_pin0(PORTJJ,0x79) == 1)
	CALL SUBOPT_0x9
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x18B
; 0000 091E                 {
; 0000 091F 
; 0000 0920                 cykl_sterownik_1 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x286:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
; 0000 0921                 }
; 0000 0922         break;
_0x18B:
; 0000 0923 
; 0000 0924         }
_0x17A:
; 0000 0925 
; 0000 0926 return cykl_sterownik_1;
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
	RJMP _0x20A0002
; 0000 0927 }
;
;
;int sterownik_2_praca(int PORT, int a)
; 0000 092B {
_sterownik_2_praca:
; 0000 092C //PORTC.0   IN0  STEROWNIK2
; 0000 092D //PORTC.1   IN1  STEROWNIK2
; 0000 092E //PORTC.2   IN2  STEROWNIK2
; 0000 092F //PORTC.3   IN3  STEROWNIK2
; 0000 0930 //PORTC.4   IN4  STEROWNIK2
; 0000 0931 //PORTC.5   IN5  STEROWNIK2
; 0000 0932 //PORTC.6   IN6  STEROWNIK2
; 0000 0933 //PORTC.7   IN7  STEROWNIK2
; 0000 0934 //PORTD.5   IN8 STEROWNIK2
; 0000 0935 
; 0000 0936 
; 0000 0937 //PORTD.5  SETUP   STEROWNIK2
; 0000 0938 //PORTD.6  DRIVE   STEROWNIK2
; 0000 0939 
; 0000 093A //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 093B //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 093C 
; 0000 093D 
; 0000 093E switch(cykl_sterownik_2)
;	PORT -> Y+2
;	a -> Y+0
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
; 0000 093F         {
; 0000 0940         case 0:
	SBIW R30,0
	BRNE _0x18F
; 0000 0941 
; 0000 0942             sek3 = 0;
	CALL SUBOPT_0x21
; 0000 0943             PORTC = PORT;
	LDD  R30,Y+2
	OUT  0x15,R30
; 0000 0944             PORTD.5 = a;
	LD   R30,Y
	CPI  R30,0
	BRNE _0x190
	CBI  0x12,5
	RJMP _0x191
_0x190:
	SBI  0x12,5
_0x191:
; 0000 0945 
; 0000 0946             cykl_sterownik_2 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x287
; 0000 0947 
; 0000 0948 
; 0000 0949         break;
; 0000 094A 
; 0000 094B         case 1:
_0x18F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x192
; 0000 094C 
; 0000 094D             if(sek3 > 1)
	LDS  R26,_sek3
	LDS  R27,_sek3+1
	LDS  R24,_sek3+2
	LDS  R25,_sek3+3
	CALL SUBOPT_0x1F
	BRLT _0x193
; 0000 094E                 {
; 0000 094F                 PORTD.6 = 1;
	SBI  0x12,6
; 0000 0950                 cykl_sterownik_2 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x22
; 0000 0951                 }
; 0000 0952         break;
_0x193:
	RJMP _0x18E
; 0000 0953 
; 0000 0954 
; 0000 0955         case 2:
_0x192:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x196
; 0000 0956 
; 0000 0957                if(sprawdz_pin0(PORTLL,0x71) == 0)     //busy
	CALL SUBOPT_0x13
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x197
; 0000 0958                   {
; 0000 0959                   PORTD.6 = 0;
	CBI  0x12,6
; 0000 095A                   PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 095B                   PORTD.5 = 0;
	CBI  0x12,5
; 0000 095C                   sek3 = 0;
	CALL SUBOPT_0x21
; 0000 095D                   cykl_sterownik_2 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x22
; 0000 095E                   }
; 0000 095F 
; 0000 0960         break;
_0x197:
	RJMP _0x18E
; 0000 0961 
; 0000 0962         case 3:
_0x196:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x19C
; 0000 0963 
; 0000 0964                if(sprawdz_pin3(PORTLL,0x71) == 0)
	CALL SUBOPT_0x13
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x19D
; 0000 0965                   {
; 0000 0966                   sek3 = 0;
	CALL SUBOPT_0x21
; 0000 0967                   cykl_sterownik_2 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x22
; 0000 0968                   }
; 0000 0969 
; 0000 096A 
; 0000 096B         break;
_0x19D:
	RJMP _0x18E
; 0000 096C 
; 0000 096D 
; 0000 096E         case 4:
_0x19C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x18E
; 0000 096F 
; 0000 0970             if(sprawdz_pin0(PORTLL,0x71) == 1)
	CALL SUBOPT_0x13
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x19F
; 0000 0971                 {
; 0000 0972                 cykl_sterownik_2 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x287:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
; 0000 0973                 }
; 0000 0974         break;
_0x19F:
; 0000 0975 
; 0000 0976         }
_0x18E:
; 0000 0977 
; 0000 0978 return cykl_sterownik_2;
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
_0x20A0002:
	ADIW R28,4
	RET
; 0000 0979 }
;
;
;
;
;
;
;int sterownik_3_praca(char f,char e,char d, char c, char b, char a)
; 0000 0981 {
_sterownik_3_praca:
; 0000 0982 //PORTF.0   IN0  STEROWNIK3
; 0000 0983 //PORTF.1   IN1  STEROWNIK3
; 0000 0984 //PORTF.2   IN2  STEROWNIK3
; 0000 0985 //PORTF.3   IN3  STEROWNIK3
; 0000 0986 //PORTF.7   IN4 STEROWNIK 3
; 0000 0987 //PORTB.7   IN5 STEROWNIK 3
; 0000 0988 
; 0000 0989 
; 0000 098A 
; 0000 098B //PORTF.5   DRIVE  STEROWNIK3
; 0000 098C 
; 0000 098D //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 098E //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 098F 
; 0000 0990 switch(cykl_sterownik_3)
;	f -> Y+5
;	e -> Y+4
;	d -> Y+3
;	c -> Y+2
;	b -> Y+1
;	a -> Y+0
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
; 0000 0991         {
; 0000 0992         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x1A3
; 0000 0993 
; 0000 0994             PORT_F.bits.b0 = a;
	LD   R30,Y
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	OR   R30,R0
	STS  _PORT_F,R30
; 0000 0995             PORT_F.bits.b1 = b;
	LDD  R30,Y+1
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFD
	OR   R30,R0
	STS  _PORT_F,R30
; 0000 0996             PORT_F.bits.b2 = c;
	LDD  R30,Y+2
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFB
	OR   R30,R0
	STS  _PORT_F,R30
; 0000 0997             PORT_F.bits.b3 = d;
	LDD  R30,Y+3
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0XF7
	OR   R30,R0
	STS  _PORT_F,R30
; 0000 0998             PORT_F.bits.b7 = e;
	LDD  R30,Y+4
	ANDI R30,LOW(0x1)
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0x7F
	OR   R30,R0
	CALL SUBOPT_0x23
; 0000 0999             PORTF = PORT_F.byte;
; 0000 099A             PORTB.7 = f;
	LDD  R30,Y+5
	CPI  R30,0
	BRNE _0x1A4
	CBI  0x18,7
	RJMP _0x1A5
_0x1A4:
	SBI  0x18,7
_0x1A5:
; 0000 099B 
; 0000 099C             sek2 = 0;
	CALL SUBOPT_0x24
; 0000 099D             cykl_sterownik_3 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x25
; 0000 099E 
; 0000 099F         break;
	RJMP _0x1A2
; 0000 09A0 
; 0000 09A1         case 1:
_0x1A3:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1A6
; 0000 09A2 
; 0000 09A3             if(sek2 > 1)
	LDS  R26,_sek2
	LDS  R27,_sek2+1
	LDS  R24,_sek2+2
	LDS  R25,_sek2+3
	CALL SUBOPT_0x1F
	BRLT _0x1A7
; 0000 09A4                 {
; 0000 09A5                 PORT_F.bits.b5 = 1;
	LDS  R30,_PORT_F
	ORI  R30,0x20
	CALL SUBOPT_0x23
; 0000 09A6                 PORTF = PORT_F.byte;
; 0000 09A7                 cykl_sterownik_3 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x25
; 0000 09A8                 }
; 0000 09A9         break;
_0x1A7:
	RJMP _0x1A2
; 0000 09AA 
; 0000 09AB 
; 0000 09AC         case 2:
_0x1A6:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1A8
; 0000 09AD 
; 0000 09AE                if(sprawdz_pin0(PORTKK,0x75) == 0)
	CALL SUBOPT_0x14
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x1A9
; 0000 09AF                   {
; 0000 09B0                   PORT_F.bits.b5 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xDF
	CALL SUBOPT_0x23
; 0000 09B1                   PORTF = PORT_F.byte;
; 0000 09B2 
; 0000 09B3                   PORT_F.bits.b0 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0x26
; 0000 09B4                   PORT_F.bits.b1 = 0;
	ANDI R30,0xFD
	CALL SUBOPT_0x26
; 0000 09B5                   PORT_F.bits.b2 = 0;
	ANDI R30,0xFB
	CALL SUBOPT_0x26
; 0000 09B6                   PORT_F.bits.b3 = 0;
	ANDI R30,0XF7
	CALL SUBOPT_0x26
; 0000 09B7                   PORT_F.bits.b7 = 0;
	ANDI R30,0x7F
	CALL SUBOPT_0x23
; 0000 09B8                   PORTF = PORT_F.byte;
; 0000 09B9                   PORTB.7 = 0;
	CBI  0x18,7
; 0000 09BA 
; 0000 09BB                   sek2 = 0;
	CALL SUBOPT_0x24
; 0000 09BC                   cykl_sterownik_3 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x25
; 0000 09BD                   }
; 0000 09BE 
; 0000 09BF         break;
_0x1A9:
	RJMP _0x1A2
; 0000 09C0 
; 0000 09C1         case 3:
_0x1A8:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1AC
; 0000 09C2 
; 0000 09C3                if(sprawdz_pin3(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0x14
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x1AD
; 0000 09C4                   {
; 0000 09C5                   sek2 = 0;
	CALL SUBOPT_0x24
; 0000 09C6                   cykl_sterownik_3 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x25
; 0000 09C7                   }
; 0000 09C8 
; 0000 09C9 
; 0000 09CA         break;
_0x1AD:
	RJMP _0x1A2
; 0000 09CB 
; 0000 09CC 
; 0000 09CD         case 4:
_0x1AC:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1A2
; 0000 09CE 
; 0000 09CF               if(sprawdz_pin0(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0x14
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x1AF
; 0000 09D0                 {
; 0000 09D1                 cykl_sterownik_3 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x25
; 0000 09D2 
; 0000 09D3 
; 0000 09D4                 switch(cykl_sterownik_3_wykonalem)
	LDS  R30,_cykl_sterownik_3_wykonalem
	LDS  R31,_cykl_sterownik_3_wykonalem+1
; 0000 09D5                     {
; 0000 09D6                     case 0:
	SBIW R30,0
	BRNE _0x1B3
; 0000 09D7                             cykl_sterownik_3_wykonalem = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R31
; 0000 09D8                     break;
	RJMP _0x1B2
; 0000 09D9 
; 0000 09DA                     case 1:
_0x1B3:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1B2
; 0000 09DB                             cykl_sterownik_3_wykonalem = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R30
; 0000 09DC                     break;
; 0000 09DD 
; 0000 09DE                     }
_0x1B2:
; 0000 09DF 
; 0000 09E0 
; 0000 09E1                 }
; 0000 09E2         break;
_0x1AF:
; 0000 09E3 
; 0000 09E4         }
_0x1A2:
; 0000 09E5 
; 0000 09E6 return cykl_sterownik_3;
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
	RJMP _0x20A0001
; 0000 09E7 }
;
;
;int sterownik_4_praca(char f,char e,char d, char c, char b, char a)
; 0000 09EB {
_sterownik_4_praca:
; 0000 09EC 
; 0000 09ED 
; 0000 09EE 
; 0000 09EF 
; 0000 09F0 //PORTB.0   IN0  STEROWNIK4
; 0000 09F1 //PORTB.1   IN1  STEROWNIK4
; 0000 09F2 //PORTB.2   IN2  STEROWNIK4
; 0000 09F3 //PORTB.3   IN3  STEROWNIK4
; 0000 09F4 //PORTE.4  IN4  STEROWNIK4
; 0000 09F5 //PORTE.5  IN5  STEROWNIK4
; 0000 09F6 
; 0000 09F7 
; 0000 09F8 //PORTB.4   SETUP  STEROWNIK4
; 0000 09F9 //PORTB.5   DRIVE  STEROWNIK4
; 0000 09FA 
; 0000 09FB //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 09FC //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 09FD 
; 0000 09FE 
; 0000 09FF 
; 0000 0A00 switch(cykl_sterownik_4)
;	f -> Y+5
;	e -> Y+4
;	d -> Y+3
;	c -> Y+2
;	b -> Y+1
;	a -> Y+0
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
; 0000 0A01         {
; 0000 0A02         case 0:
	SBIW R30,0
	BRNE _0x1B8
; 0000 0A03 
; 0000 0A04             PORTB.0 = a;
	LD   R30,Y
	CPI  R30,0
	BRNE _0x1B9
	CBI  0x18,0
	RJMP _0x1BA
_0x1B9:
	SBI  0x18,0
_0x1BA:
; 0000 0A05             PORTB.1 = b;
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x1BB
	CBI  0x18,1
	RJMP _0x1BC
_0x1BB:
	SBI  0x18,1
_0x1BC:
; 0000 0A06             PORTB.2 = c;
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x1BD
	CBI  0x18,2
	RJMP _0x1BE
_0x1BD:
	SBI  0x18,2
_0x1BE:
; 0000 0A07             PORTB.3 = d;
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x1BF
	CBI  0x18,3
	RJMP _0x1C0
_0x1BF:
	SBI  0x18,3
_0x1C0:
; 0000 0A08             PORTE.4 = e;
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x1C1
	CBI  0x3,4
	RJMP _0x1C2
_0x1C1:
	SBI  0x3,4
_0x1C2:
; 0000 0A09             PORTE.5 = f;
	LDD  R30,Y+5
	CPI  R30,0
	BRNE _0x1C3
	CBI  0x3,5
	RJMP _0x1C4
_0x1C3:
	SBI  0x3,5
_0x1C4:
; 0000 0A0A 
; 0000 0A0B             sek4 = 0;
	CALL SUBOPT_0x27
; 0000 0A0C             cykl_sterownik_4 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x288
; 0000 0A0D 
; 0000 0A0E         break;
; 0000 0A0F 
; 0000 0A10         case 1:
_0x1B8:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1C5
; 0000 0A11 
; 0000 0A12             if(sek4 > 1)
	LDS  R26,_sek4
	LDS  R27,_sek4+1
	LDS  R24,_sek4+2
	LDS  R25,_sek4+3
	CALL SUBOPT_0x1F
	BRLT _0x1C6
; 0000 0A13                 {
; 0000 0A14                 PORTB.5 = 1;
	SBI  0x18,5
; 0000 0A15                 cykl_sterownik_4 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x28
; 0000 0A16                 }
; 0000 0A17         break;
_0x1C6:
	RJMP _0x1B7
; 0000 0A18 
; 0000 0A19 
; 0000 0A1A         case 2:
_0x1C5:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1C9
; 0000 0A1B 
; 0000 0A1C                if(sprawdz_pin4(PORTKK,0x75) == 0)
	CALL SUBOPT_0x14
	CALL _sprawdz_pin4
	CPI  R30,0
	BRNE _0x1CA
; 0000 0A1D                   {
; 0000 0A1E                   PORTB.5 = 0;  //drive
	CBI  0x18,5
; 0000 0A1F 
; 0000 0A20                   PORTB.0 = a;
	LD   R30,Y
	CPI  R30,0
	BRNE _0x1CD
	CBI  0x18,0
	RJMP _0x1CE
_0x1CD:
	SBI  0x18,0
_0x1CE:
; 0000 0A21                   PORTB.1 = b;
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x1CF
	CBI  0x18,1
	RJMP _0x1D0
_0x1CF:
	SBI  0x18,1
_0x1D0:
; 0000 0A22                   PORTB.2 = c;
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x1D1
	CBI  0x18,2
	RJMP _0x1D2
_0x1D1:
	SBI  0x18,2
_0x1D2:
; 0000 0A23                   PORTB.3 = d;
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x1D3
	CBI  0x18,3
	RJMP _0x1D4
_0x1D3:
	SBI  0x18,3
_0x1D4:
; 0000 0A24                   PORTE.4 = e;
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x1D5
	CBI  0x3,4
	RJMP _0x1D6
_0x1D5:
	SBI  0x3,4
_0x1D6:
; 0000 0A25                   PORTE.5 = f;
	LDD  R30,Y+5
	CPI  R30,0
	BRNE _0x1D7
	CBI  0x3,5
	RJMP _0x1D8
_0x1D7:
	SBI  0x3,5
_0x1D8:
; 0000 0A26 
; 0000 0A27                   sek4 = 0;
	CALL SUBOPT_0x27
; 0000 0A28                   cykl_sterownik_4 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x28
; 0000 0A29                   }
; 0000 0A2A 
; 0000 0A2B         break;
_0x1CA:
	RJMP _0x1B7
; 0000 0A2C 
; 0000 0A2D         case 3:
_0x1C9:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1D9
; 0000 0A2E 
; 0000 0A2F                if(sprawdz_pin7(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0x14
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x1DA
; 0000 0A30                   {
; 0000 0A31                   sek4 = 0;
	CALL SUBOPT_0x27
; 0000 0A32                   cykl_sterownik_4 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x28
; 0000 0A33                   }
; 0000 0A34 
; 0000 0A35 
; 0000 0A36         break;
_0x1DA:
	RJMP _0x1B7
; 0000 0A37 
; 0000 0A38 
; 0000 0A39         case 4:
_0x1D9:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1B7
; 0000 0A3A 
; 0000 0A3B               if(sprawdz_pin4(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0x14
	CALL _sprawdz_pin4
	CPI  R30,LOW(0x1)
	BRNE _0x1DC
; 0000 0A3C                 {
; 0000 0A3D                 cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x288:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
; 0000 0A3E                 }
; 0000 0A3F         break;
_0x1DC:
; 0000 0A40 
; 0000 0A41         }
_0x1B7:
; 0000 0A42 
; 0000 0A43 return cykl_sterownik_4;
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
_0x20A0001:
	ADIW R28,6
	RET
; 0000 0A44 }
;
;
;
;
;
;void main(void)
; 0000 0A4B {
_main:
; 0000 0A4C 
; 0000 0A4D // Declare your local variables here
; 0000 0A4E /*
; 0000 0A4F // Input/Output Ports initialization
; 0000 0A50 // Port A initialization
; 0000 0A51 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0A52 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0A53 PORTA=0x00;
; 0000 0A54 DDRA=0x00;
; 0000 0A55 
; 0000 0A56 // Port B initialization
; 0000 0A57 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0A58 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0A59 PORTB=0x00;
; 0000 0A5A DDRB=0xFF;
; 0000 0A5B 
; 0000 0A5C // Port C initialization
; 0000 0A5D // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0A5E // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0A5F PORTC=0x00;
; 0000 0A60 DDRC=0xFF;
; 0000 0A61 
; 0000 0A62 // Port D initialization
; 0000 0A63 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0A64 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0A65 PORTD=0x00;
; 0000 0A66 DDRD=0x00;
; 0000 0A67 
; 0000 0A68 // Port E initialization
; 0000 0A69 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0A6A // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0A6B PORTE=0x00;
; 0000 0A6C DDRE=0x00;
; 0000 0A6D 
; 0000 0A6E // Port F initialization
; 0000 0A6F // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0A70 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0A71 PORTF=0x00;
; 0000 0A72 DDRF=0x00;
; 0000 0A73 
; 0000 0A74 // Port G initialization
; 0000 0A75 // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0A76 // State4=T State3=T State2=T State1=T State0=T
; 0000 0A77 PORTG=0x00;
; 0000 0A78 DDRG=0x00;
; 0000 0A79 */
; 0000 0A7A 
; 0000 0A7B 
; 0000 0A7C // Input/Output Ports initialization
; 0000 0A7D // Port A initialization
; 0000 0A7E // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0A7F // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0A80 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0A81 DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0A82 
; 0000 0A83 // Port B initialization
; 0000 0A84 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0A85 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0A86 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0A87 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0A88 
; 0000 0A89 // Port C initialization
; 0000 0A8A // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0A8B // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0A8C PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0A8D DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0A8E 
; 0000 0A8F // Port D initialization
; 0000 0A90 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0A91 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0A92 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0A93 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0A94 
; 0000 0A95 // Port E initialization
; 0000 0A96 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0A97 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0A98 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0A99 DDRE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 0A9A 
; 0000 0A9B // Port F initialization
; 0000 0A9C // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0A9D // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0A9E PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 0A9F DDRF=0xFF;
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 0AA0 
; 0000 0AA1 // Port G initialization
; 0000 0AA2 // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0AA3 // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0AA4 PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 0AA5 DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 0AA6 
; 0000 0AA7 
; 0000 0AA8 
; 0000 0AA9 
; 0000 0AAA 
; 0000 0AAB // Timer/Counter 0 initialization
; 0000 0AAC // Clock source: System Clock
; 0000 0AAD // Clock value: 15,625 kHz
; 0000 0AAE // Mode: Normal top=0xFF
; 0000 0AAF // OC0 output: Disconnected
; 0000 0AB0 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0AB1 TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 0AB2 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0AB3 OCR0=0x00;
	OUT  0x31,R30
; 0000 0AB4 
; 0000 0AB5 // Timer/Counter 1 initialization
; 0000 0AB6 // Clock source: System Clock
; 0000 0AB7 // Clock value: Timer1 Stopped
; 0000 0AB8 // Mode: Normal top=0xFFFF
; 0000 0AB9 // OC1A output: Discon.
; 0000 0ABA // OC1B output: Discon.
; 0000 0ABB // OC1C output: Discon.
; 0000 0ABC // Noise Canceler: Off
; 0000 0ABD // Input Capture on Falling Edge
; 0000 0ABE // Timer1 Overflow Interrupt: Off
; 0000 0ABF // Input Capture Interrupt: Off
; 0000 0AC0 // Compare A Match Interrupt: Off
; 0000 0AC1 // Compare B Match Interrupt: Off
; 0000 0AC2 // Compare C Match Interrupt: Off
; 0000 0AC3 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0AC4 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0AC5 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0AC6 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0AC7 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0AC8 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0AC9 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0ACA OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0ACB OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0ACC OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0ACD OCR1CH=0x00;
	STS  121,R30
; 0000 0ACE OCR1CL=0x00;
	STS  120,R30
; 0000 0ACF 
; 0000 0AD0 // Timer/Counter 2 initialization
; 0000 0AD1 // Clock source: System Clock
; 0000 0AD2 // Clock value: Timer2 Stopped
; 0000 0AD3 // Mode: Normal top=0xFF
; 0000 0AD4 // OC2 output: Disconnected
; 0000 0AD5 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0AD6 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0AD7 OCR2=0x00;
	OUT  0x23,R30
; 0000 0AD8 
; 0000 0AD9 // Timer/Counter 3 initialization
; 0000 0ADA // Clock source: System Clock
; 0000 0ADB // Clock value: Timer3 Stopped
; 0000 0ADC // Mode: Normal top=0xFFFF
; 0000 0ADD // OC3A output: Discon.
; 0000 0ADE // OC3B output: Discon.
; 0000 0ADF // OC3C output: Discon.
; 0000 0AE0 // Noise Canceler: Off
; 0000 0AE1 // Input Capture on Falling Edge
; 0000 0AE2 // Timer3 Overflow Interrupt: Off
; 0000 0AE3 // Input Capture Interrupt: Off
; 0000 0AE4 // Compare A Match Interrupt: Off
; 0000 0AE5 // Compare B Match Interrupt: Off
; 0000 0AE6 // Compare C Match Interrupt: Off
; 0000 0AE7 TCCR3A=0x00;
	STS  139,R30
; 0000 0AE8 TCCR3B=0x00;
	STS  138,R30
; 0000 0AE9 TCNT3H=0x00;
	STS  137,R30
; 0000 0AEA TCNT3L=0x00;
	STS  136,R30
; 0000 0AEB ICR3H=0x00;
	STS  129,R30
; 0000 0AEC ICR3L=0x00;
	STS  128,R30
; 0000 0AED OCR3AH=0x00;
	STS  135,R30
; 0000 0AEE OCR3AL=0x00;
	STS  134,R30
; 0000 0AEF OCR3BH=0x00;
	STS  133,R30
; 0000 0AF0 OCR3BL=0x00;
	STS  132,R30
; 0000 0AF1 OCR3CH=0x00;
	STS  131,R30
; 0000 0AF2 OCR3CL=0x00;
	STS  130,R30
; 0000 0AF3 
; 0000 0AF4 // External Interrupt(s) initialization
; 0000 0AF5 // INT0: Off
; 0000 0AF6 // INT1: Off
; 0000 0AF7 // INT2: Off
; 0000 0AF8 // INT3: Off
; 0000 0AF9 // INT4: Off
; 0000 0AFA // INT5: Off
; 0000 0AFB // INT6: Off
; 0000 0AFC // INT7: Off
; 0000 0AFD EICRA=0x00;
	STS  106,R30
; 0000 0AFE EICRB=0x00;
	OUT  0x3A,R30
; 0000 0AFF EIMSK=0x00;
	OUT  0x39,R30
; 0000 0B00 
; 0000 0B01 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0B02 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 0B03 
; 0000 0B04 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 0B05 
; 0000 0B06 
; 0000 0B07 // USART0 initialization
; 0000 0B08 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0B09 // USART0 Receiver: On
; 0000 0B0A // USART0 Transmitter: On
; 0000 0B0B // USART0 Mode: Asynchronous
; 0000 0B0C // USART0 Baud Rate: 115200
; 0000 0B0D UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 0B0E UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0B0F UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0B10 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0B11 UBRR0L=0x08;
	LDI  R30,LOW(8)
	OUT  0x9,R30
; 0000 0B12 
; 0000 0B13 // USART1 initialization
; 0000 0B14 // USART1 disabled
; 0000 0B15 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 0B16 
; 0000 0B17 // Analog Comparator initialization
; 0000 0B18 // Analog Comparator: Off
; 0000 0B19 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0B1A ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0B1B SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0B1C 
; 0000 0B1D // ADC initialization
; 0000 0B1E // ADC disabled
; 0000 0B1F ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0B20 
; 0000 0B21 // SPI initialization
; 0000 0B22 // SPI disabled
; 0000 0B23 SPCR=0x00;
	OUT  0xD,R30
; 0000 0B24 
; 0000 0B25 // TWI initialization
; 0000 0B26 // TWI disabled
; 0000 0B27 TWCR=0x00;
	STS  116,R30
; 0000 0B28 
; 0000 0B29 //ciekawe, tej linijki brakowalo w medalach ,wyczailem w borgu
; 0000 0B2A // I2C Bus initialization
; 0000 0B2B i2c_init();
	CALL _i2c_init
; 0000 0B2C 
; 0000 0B2D // Global enable interrupts
; 0000 0B2E #asm("sei")
	sei
; 0000 0B2F 
; 0000 0B30 
; 0000 0B31 //delay_ms(8000); //bo panel sie inicjalizuje
; 0000 0B32 //delay_ms(2000); //bo panel sie inicjalizuje
; 0000 0B33 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x29
; 0000 0B34 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x29
; 0000 0B35 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x29
; 0000 0B36 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x29
; 0000 0B37 
; 0000 0B38 //delay_ms(2000); //bo panel sie inicjalizuje
; 0000 0B39 //delay_ms(2000); //bo panel sie inicjalizuje
; 0000 0B3A //delay_ms(2000); //bo panel sie inicjalizuje
; 0000 0B3B //delay_ms(2000); //bo panel sie inicjalizuje
; 0000 0B3C 
; 0000 0B3D //jak patrze na maszyne to ten po lewej to 1
; 0000 0B3E 
; 0000 0B3F putchar(90);  //5A
	CALL SUBOPT_0x1
; 0000 0B40 putchar(165); //A5
; 0000 0B41 putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _putchar
; 0000 0B42 putchar(128);  //80
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _putchar
; 0000 0B43 putchar(2);    //02
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
; 0000 0B44 putchar(16);   //10
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
; 0000 0B45 
; 0000 0B46 il_prob_odczytu = 1;    //100
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 0B47 start = 0;
	LDI  R30,LOW(0)
	STS  _start,R30
	STS  _start+1,R30
; 0000 0B48 szczotka_druciana_ilosc_cykli = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _szczotka_druciana_ilosc_cykli,R30
	STS  _szczotka_druciana_ilosc_cykli+1,R31
; 0000 0B49 krazek_scierny_cykl_po_okregu_ilosc = 4;
	STS  _krazek_scierny_cykl_po_okregu_ilosc,R30
	STS  _krazek_scierny_cykl_po_okregu_ilosc+1,R31
; 0000 0B4A krazek_scierny_ilosc_cykli = 4;
	STS  _krazek_scierny_ilosc_cykli,R30
	STS  _krazek_scierny_ilosc_cykli+1,R31
; 0000 0B4B rzad_obrabiany = 1;
	CALL SUBOPT_0x2A
; 0000 0B4C jestem_w_trakcie_czyszczenia_calosci = 0;
	CALL SUBOPT_0x2B
; 0000 0B4D wykonalem_rzedow = 0;
	CALL SUBOPT_0x2C
; 0000 0B4E cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x2D
; 0000 0B4F guzik1_przelaczania_zaciskow = 1;
	SET
	BLD  R2,0
; 0000 0B50 guzik2_przelaczania_zaciskow = 1;
	BLD  R2,1
; 0000 0B51 PORTE.6 = 1;  //aby byl dostep do zaciskow rzad 1
	SBI  0x3,6
; 0000 0B52 zmienna_przelaczanie_zaciskow = 1;
	BLD  R2,2
; 0000 0B53 czas_przedmuchu = 183;
	LDI  R30,LOW(183)
	LDI  R31,HIGH(183)
	STS  _czas_przedmuchu,R30
	STS  _czas_przedmuchu+1,R31
; 0000 0B54 
; 0000 0B55 
; 0000 0B56 adr1 = 80;  //rzad 1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STS  _adr1,R30
	STS  _adr1+1,R31
; 0000 0B57 adr2 = 0;   //
	LDI  R30,LOW(0)
	STS  _adr2,R30
	STS  _adr2+1,R30
; 0000 0B58 adr3 = 64;  //rzad 2
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STS  _adr3,R30
	STS  _adr3+1,R31
; 0000 0B59 adr4 = 0;
	LDI  R30,LOW(0)
	STS  _adr4,R30
	STS  _adr4+1,R30
; 0000 0B5A 
; 0000 0B5B 
; 0000 0B5C 
; 0000 0B5D //zapal lampki
; 0000 0B5E //PORTB.6 = 1;
; 0000 0B5F //PORTD.7 = 1;
; 0000 0B60 //PORT_F.bits.b6 = 1;
; 0000 0B61 //PORTF = PORT_F.byte;
; 0000 0B62 
; 0000 0B63 //PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 0B64 //PORTF = PORT_F.byte;
; 0000 0B65 //PORTB.4 = 1;  //przedmuch osi
; 0000 0B66 //PORTE.2 = 1;  //szlifierka 1
; 0000 0B67 //PORTE.3 = 1;  //szlifierka 2
; 0000 0B68 //PORTE.6 = 0;  //zacisniety rzad 1
; 0000 0B69 //PORTE.6 = 1;  //zacisniety rzad 2
; 0000 0B6A //PORTE.7 = 0;    //zacisnij zaciski
; 0000 0B6B 
; 0000 0B6C //zalozenie: nie mozna czytac kodow kreskowych jak juz dalem start i idzie, dopoki nie skonczy
; 0000 0B6D 
; 0000 0B6E 
; 0000 0B6F wypozycjonuj_napedy_minimalistyczna();
	RCALL _wypozycjonuj_napedy_minimalistyczna
; 0000 0B70 sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 0B71 
; 0000 0B72 while (1)
_0x1DF:
; 0000 0B73       {
; 0000 0B74       ostateczny_wybor_zacisku();
	RCALL _ostateczny_wybor_zacisku
; 0000 0B75       start = odczytaj_parametr(0,64);
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	STS  _start,R30
	STS  _start+1,R31
; 0000 0B76       il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
	CALL SUBOPT_0x2E
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STS  _il_zaciskow_rzad_1,R30
	STS  _il_zaciskow_rzad_1+1,R31
; 0000 0B77       il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x2E
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczytaj_parametr
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
; 0000 0B78       przerzucanie_dociskow();
	RCALL _przerzucanie_dociskow
; 0000 0B79       wybor_linijek_sterownikow();
	RCALL _wybor_linijek_sterownikow
; 0000 0B7A 
; 0000 0B7B 
; 0000 0B7C       while((start == 1 & il_zaciskow_rzad_1 > 0) | jestem_w_trakcie_czyszczenia_calosci == 1)
_0x1E2:
	LDS  R26,_start
	LDS  R27,_start+1
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	LDS  R26,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R27,_jestem_w_trakcie_czyszczenia_calosci+1
	CALL SUBOPT_0x1A
	OR   R30,R0
	BRNE PC+3
	JMP _0x1E4
; 0000 0B7D             {
; 0000 0B7E             switch (cykl_glowny)
	LDS  R30,_cykl_glowny
	LDS  R31,_cykl_glowny+1
; 0000 0B7F             {
; 0000 0B80             case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x1E8
; 0000 0B81 
; 0000 0B82 
; 0000 0B83                     PORTB.6 = 1;   ////zielona lampka
	SBI  0x18,6
; 0000 0B84                     if(jestem_w_trakcie_czyszczenia_calosci == 0)
	LDS  R30,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R31,_jestem_w_trakcie_czyszczenia_calosci+1
	SBIW R30,0
	BRNE _0x1EB
; 0000 0B85                         {
; 0000 0B86                         wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x32
; 0000 0B87                         wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad2
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x33
; 0000 0B88                         }
; 0000 0B89 
; 0000 0B8A                     jestem_w_trakcie_czyszczenia_calosci = 1;
_0x1EB:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R31
; 0000 0B8B 
; 0000 0B8C                     if(rzad_obrabiany == 1)
	CALL SUBOPT_0x34
	SBIW R26,1
	BRNE _0x1EC
; 0000 0B8D                     {
; 0000 0B8E                     PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
	CBI  0x3,6
; 0000 0B8F                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x35
	BRGE _0x1EF
; 0000 0B90                         cykl_sterownik_1 = sterownik_1_praca(0x09,0);
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
; 0000 0B91                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x1EF:
	CALL SUBOPT_0x38
	BRGE _0x1F0
; 0000 0B92                         cykl_sterownik_2 = sterownik_2_praca(0x00,0);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x39
; 0000 0B93                     }
_0x1F0:
; 0000 0B94 
; 0000 0B95                     if(rzad_obrabiany == 2)
_0x1EC:
	CALL SUBOPT_0x34
	SBIW R26,2
	BRNE _0x1F1
; 0000 0B96                     {
; 0000 0B97                     PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
	SBI  0x3,6
; 0000 0B98                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x35
	BRGE _0x1F4
; 0000 0B99                         cykl_sterownik_1 = sterownik_1_praca(0x08,0);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x37
; 0000 0B9A                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x1F4:
	CALL SUBOPT_0x38
	BRGE _0x1F5
; 0000 0B9B                         cykl_sterownik_2 = sterownik_2_praca(0x01,0);       //ster 2 pod pin pozy rzad 2
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x39
; 0000 0B9C                     }
_0x1F5:
; 0000 0B9D 
; 0000 0B9E 
; 0000 0B9F                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x1F1:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	AND  R30,R0
	BREQ _0x1F6
; 0000 0BA0                         {
; 0000 0BA1 
; 0000 0BA2                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x3E
; 0000 0BA3                         cykl_sterownik_2 = 0;
; 0000 0BA4                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x3F
; 0000 0BA5                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x40
; 0000 0BA6                         cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x2D
; 0000 0BA7                         koniec_rzedu_10 = 0;
	CALL SUBOPT_0x41
; 0000 0BA8                         start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x42
; 0000 0BA9                         if(start_kontynuacja == 1)
	BRNE _0x1F7
; 0000 0BAA                             cykl_glowny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x43
; 0000 0BAB                         }
_0x1F7:
; 0000 0BAC 
; 0000 0BAD             break;
_0x1F6:
	RJMP _0x1E7
; 0000 0BAE 
; 0000 0BAF 
; 0000 0BB0 
; 0000 0BB1             case 1:
_0x1E8:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x1F8
; 0000 0BB2 
; 0000 0BB3 
; 0000 0BB4                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 1)
	CALL SUBOPT_0x44
	CALL SUBOPT_0x1A
	AND  R30,R0
	BREQ _0x1F9
; 0000 0BB5                         //cykl_sterownik_2 = sterownik_2_praca(0x5A,0);         //ster 1 nic
; 0000 0BB6                           cykl_sterownik_2 = sterownik_2_praca(a[0],a[1]);        //ster 2 pod zacisk
	LDS  R30,_a
	LDS  R31,_a+1
	ST   -Y,R31
	ST   -Y,R30
	__GETW1MN _a,2
	CALL SUBOPT_0x45
; 0000 0BB7                                                                               //ster 4 na pozycje miedzy rzedzami
; 0000 0BB8 
; 0000 0BB9                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 2)
_0x1F9:
	CALL SUBOPT_0x44
	CALL SUBOPT_0x46
	BREQ _0x1FA
; 0000 0BBA                         //cykl_sterownik_2 = sterownik_2_praca(0x5B,0);
; 0000 0BBB                           cykl_sterownik_2 = sterownik_2_praca(a[2],a[3]);
	__GETW1MN _a,4
	ST   -Y,R31
	ST   -Y,R30
	__GETW1MN _a,6
	CALL SUBOPT_0x45
; 0000 0BBC 
; 0000 0BBD                      if(cykl_sterownik_4 < 5 & cykl_sterownik_2 == 5)
_0x1FA:
	CALL SUBOPT_0x47
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x48
	AND  R30,R0
	BREQ _0x1FB
; 0000 0BBE                         cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);
	CALL SUBOPT_0x49
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
; 0000 0BBF 
; 0000 0BC0 
; 0000 0BC1                       if(cykl_sterownik_2 == 5 & cykl_sterownik_4 == 5)
_0x1FB:
	CALL SUBOPT_0x48
	MOV  R0,R30
	CALL SUBOPT_0x47
	CALL __EQW12
	AND  R30,R0
	BREQ _0x1FC
; 0000 0BC2                         {
; 0000 0BC3                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x3E
; 0000 0BC4                         cykl_sterownik_2 = 0;
; 0000 0BC5                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x40
; 0000 0BC6                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0x4B
; 0000 0BC7 
; 0000 0BC8 
; 0000 0BC9                         start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x42
; 0000 0BCA                         if(start_kontynuacja == 1)
	BRNE _0x1FD
; 0000 0BCB                             cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x43
; 0000 0BCC                         }
_0x1FD:
; 0000 0BCD 
; 0000 0BCE 
; 0000 0BCF             break;
_0x1FC:
	RJMP _0x1E7
; 0000 0BD0 
; 0000 0BD1 
; 0000 0BD2             case 2:
_0x1F8:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1FE
; 0000 0BD3 
; 0000 0BD4                     if(cykl_sterownik_4 < 5)
	CALL SUBOPT_0x4C
	BRGE _0x1FF
; 0000 0BD5                         cykl_sterownik_4 = sterownik_4_praca(1,0,0,0,1,0);  //ABS
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4E
; 0000 0BD6                     if(cykl_sterownik_4 == 5)
_0x1FF:
	CALL SUBOPT_0x4C
	BRNE _0x200
; 0000 0BD7                         {
; 0000 0BD8                         PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 0BD9                         cykl_sterownik_4 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4F
; 0000 0BDA                         start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x42
; 0000 0BDB                         if(start_kontynuacja == 1)
	BRNE _0x203
; 0000 0BDC                             cykl_glowny = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x43
; 0000 0BDD                         }
_0x203:
; 0000 0BDE 
; 0000 0BDF             break;
_0x200:
	RJMP _0x1E7
; 0000 0BE0 
; 0000 0BE1 
; 0000 0BE2             case 3:
_0x1FE:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x204
; 0000 0BE3                     if(cykl_sterownik_4 < 5)
	CALL SUBOPT_0x4C
	BRGE _0x205
; 0000 0BE4                        cykl_sterownik_4 = sterownik_4_praca(0,1,0,0,0,1); //INV
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 0BE5 
; 0000 0BE6                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x205:
	CALL SUBOPT_0x47
	CALL SUBOPT_0x52
	BREQ _0x206
; 0000 0BE7                         {
; 0000 0BE8                         szczotka_druc_cykl++;
	CALL SUBOPT_0x53
; 0000 0BE9                         cykl_sterownik_4 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x40
; 0000 0BEA 
; 0000 0BEB                         if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
	CALL SUBOPT_0x54
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x207
; 0000 0BEC                             {
; 0000 0BED                             start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x42
; 0000 0BEE                             if(start_kontynuacja == 1)
	BRNE _0x208
; 0000 0BEF                                   cykl_glowny = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x43
; 0000 0BF0                             }
_0x208:
; 0000 0BF1                         else
	RJMP _0x209
_0x207:
; 0000 0BF2                             {
; 0000 0BF3                             start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x42
; 0000 0BF4                             if(start_kontynuacja == 1)
	BRNE _0x20A
; 0000 0BF5                                 cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x43
; 0000 0BF6 
; 0000 0BF7 
; 0000 0BF8                             }
_0x20A:
_0x209:
; 0000 0BF9                         }
; 0000 0BFA 
; 0000 0BFB 
; 0000 0BFC 
; 0000 0BFD             break;
_0x206:
	RJMP _0x1E7
; 0000 0BFE 
; 0000 0BFF             case 4:
_0x204:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20B
; 0000 0C00 
; 0000 0C01                      if(cykl_sterownik_4 < 5)
	CALL SUBOPT_0x4C
	BRGE _0x20C
; 0000 0C02                         cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	CALL SUBOPT_0x51
; 0000 0C03 
; 0000 0C04                      if(cykl_sterownik_4 == 5)
_0x20C:
	CALL SUBOPT_0x4C
	BRNE _0x20D
; 0000 0C05                         {
; 0000 0C06                         PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 0C07                         cykl_sterownik_4 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4F
; 0000 0C08                         start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x42
; 0000 0C09                         if(start_kontynuacja == 1)
	BRNE _0x210
; 0000 0C0A                             {
; 0000 0C0B                             ruch_zlozony = 0;
	LDI  R30,LOW(0)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R30
; 0000 0C0C                             cykl_glowny = 5;
	CALL SUBOPT_0x55
; 0000 0C0D                             }
; 0000 0C0E                         }
_0x210:
; 0000 0C0F 
; 0000 0C10             break;
_0x20D:
	RJMP _0x1E7
; 0000 0C11 
; 0000 0C12             case 5:
_0x20B:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x211
; 0000 0C13 
; 0000 0C14 
; 0000 0C15                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 1)
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x56
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x212
; 0000 0C16                         cykl_sterownik_1 = sterownik_1_praca(0x00,0);
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x37
; 0000 0C17                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 2)
_0x212:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x56
	CALL SUBOPT_0x58
	BREQ _0x213
; 0000 0C18                         cykl_sterownik_1 = sterownik_1_praca(0x01,0);
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x37
; 0000 0C19 
; 0000 0C1A 
; 0000 0C1B 
; 0000 0C1C                     if(cykl_sterownik_1 == 5 & ruch_zlozony == 0)
_0x213:
	CALL SUBOPT_0x3C
	CALL __EQW12
	CALL SUBOPT_0x59
	CALL SUBOPT_0x19
	AND  R30,R0
	BREQ _0x214
; 0000 0C1D                         {
; 0000 0C1E                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x5A
; 0000 0C1F                         ruch_zlozony = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 0C20                         }
; 0000 0C21 
; 0000 0C22                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 1)
_0x214:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x215
; 0000 0C23                         cykl_sterownik_1 = sterownik_1_praca(0x5A,0);
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x37
; 0000 0C24                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 2)
_0x215:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x58
	BREQ _0x216
; 0000 0C25                         cykl_sterownik_1 = sterownik_1_praca(0x5B,0);
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x37
; 0000 0C26 
; 0000 0C27 
; 0000 0C28 
; 0000 0C29                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 2)
_0x216:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x46
	BREQ _0x217
; 0000 0C2A                         cykl_sterownik_1 = sterownik_1_praca(0x03,0);
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x37
; 0000 0C2B 
; 0000 0C2C                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 0)                                //ster 1 do pierwszego dolka
_0x217:
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x19
	AND  R30,R0
	BREQ _0x218
; 0000 0C2D                         cykl_sterownik_2 = sterownik_2_praca(0x03,0);       //ster 2 pod nastpeny dolek
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x39
; 0000 0C2E 
; 0000 0C2F 
; 0000 0C30                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 1)
_0x218:
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x219
; 0000 0C31                         cykl_sterownik_2 = sterownik_2_praca(0x08,0);      //ster 2 do samego tylu
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x39
; 0000 0C32                      if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 2)
_0x219:
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x58
	BREQ _0x21A
; 0000 0C33                         cykl_sterownik_2 = sterownik_2_praca(0x09,0);      //ster 2 do samego tylu
	CALL SUBOPT_0x36
	CALL SUBOPT_0x39
; 0000 0C34 
; 0000 0C35                     if((cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5 & ruch_zlozony == 1) | (cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5) & ruch_zlozony == 2)
_0x21A:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0x1A
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0x46
	OR   R30,R1
	BREQ _0x21B
; 0000 0C36                         {
; 0000 0C37                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x3E
; 0000 0C38                         cykl_sterownik_2 = 0;
; 0000 0C39                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x40
; 0000 0C3A                         cykl_sterownik_3 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3F
; 0000 0C3B                         sek12 = 0;    //do przedmuchu
	CALL SUBOPT_0x5F
; 0000 0C3C                         start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x42
; 0000 0C3D                         if(start_kontynuacja == 1)
	BRNE _0x21C
; 0000 0C3E                             {
; 0000 0C3F                             if(cykl_ilosc_zaciskow > 0)
	CALL SUBOPT_0x60
	CALL __CPW02
	BRGE _0x21D
; 0000 0C40                                 {
; 0000 0C41                                 PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x61
; 0000 0C42                                 PORTF = PORT_F.byte;
; 0000 0C43                                 }
; 0000 0C44                             cykl_glowny = 6;
_0x21D:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x43
; 0000 0C45                             }
; 0000 0C46                         }
_0x21C:
; 0000 0C47 
; 0000 0C48             break;
_0x21B:
	RJMP _0x1E7
; 0000 0C49 
; 0000 0C4A 
; 0000 0C4B 
; 0000 0C4C            case 6:
_0x211:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x21E
; 0000 0C4D 
; 0000 0C4E 
; 0000 0C4F                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x62
	BRGE _0x21F
; 0000 0C50                         {
; 0000 0C51                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x63
; 0000 0C52                         PORTF = PORT_F.byte;
; 0000 0C53                         }
; 0000 0C54 
; 0000 0C55                     if(cykl_sterownik_3 < 5)
_0x21F:
	CALL SUBOPT_0x64
	SBIW R26,5
	BRGE _0x220
; 0000 0C56                         cykl_sterownik_3 = sterownik_3_praca(1,0,0,0,0,1);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x49
	CALL SUBOPT_0x65
; 0000 0C57 
; 0000 0C58                     if(koniec_rzedu_10 == 1)
_0x220:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	SBIW R26,1
	BRNE _0x221
; 0000 0C59                         cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x28
; 0000 0C5A 
; 0000 0C5B                     if(cykl_sterownik_4 < 5)
_0x221:
	CALL SUBOPT_0x4C
	BRGE _0x222
; 0000 0C5C                         cykl_sterownik_4 = sterownik_4_praca(1,0,0,0,1,0);  //ABS          //druciak do gory
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4E
; 0000 0C5D 
; 0000 0C5E                     if(cykl_sterownik_4 == 5 & cykl_sterownik_3 == 5)
_0x222:
	CALL SUBOPT_0x47
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x66
	CALL __EQW12
	AND  R30,R0
	BREQ _0x223
; 0000 0C5F                         {
; 0000 0C60                         if((cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1 & rzad_obrabiany == 1) | (cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1 & rzad_obrabiany == 2))
	CALL SUBOPT_0x67
	MOV  R0,R30
	CALL SUBOPT_0x34
	CALL SUBOPT_0x1A
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0x68
	MOV  R0,R30
	CALL SUBOPT_0x34
	CALL SUBOPT_0x46
	OR   R30,R1
	BREQ _0x224
; 0000 0C61                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 0C62                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
_0x224:
	SBI  0x3,3
; 0000 0C63                         cykl_sterownik_3 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3F
; 0000 0C64                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x4F
; 0000 0C65                         start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x42
; 0000 0C66                         if(start_kontynuacja == 1)
	BRNE _0x229
; 0000 0C67                             cykl_glowny = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x43
; 0000 0C68                         }
_0x229:
; 0000 0C69 
; 0000 0C6A            break;
_0x223:
	RJMP _0x1E7
; 0000 0C6B 
; 0000 0C6C 
; 0000 0C6D            case 7:
_0x21E:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x22A
; 0000 0C6E                                                                                               //mini ruch do przygotowania do okregu
; 0000 0C6F                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x35
	BRGE _0x22B
; 0000 0C70                         cykl_sterownik_1 = sterownik_1_praca(0x96,1);
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x69
; 0000 0C71 
; 0000 0C72                     if(cykl_sterownik_1 == 5)
_0x22B:
	CALL SUBOPT_0x35
	BRNE _0x22C
; 0000 0C73                         {
; 0000 0C74                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x5A
; 0000 0C75                         cykl_glowny = 8;
	CALL SUBOPT_0x6A
; 0000 0C76                         szczotka_druc_cykl = 0;
; 0000 0C77                         krazek_scierny_cykl_po_okregu = 0;
	LDI  R30,LOW(0)
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
; 0000 0C78                         wykonalem_komplet_okregow = 0;
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R30
; 0000 0C79                         abs_ster3 = 0;
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R30
; 0000 0C7A                         abs_ster4 = 0;
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
; 0000 0C7B                         }
; 0000 0C7C 
; 0000 0C7D 
; 0000 0C7E 
; 0000 0C7F            break;
_0x22C:
	RJMP _0x1E7
; 0000 0C80 
; 0000 0C81 
; 0000 0C82             case 8:
_0x22A:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x22D
; 0000 0C83 
; 0000 0C84 
; 0000 0C85 
; 0000 0C86 
; 0000 0C87                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
	CALL SUBOPT_0x3C
	CALL __LTW12
	CALL SUBOPT_0x6B
	AND  R30,R0
	BREQ _0x22E
; 0000 0C88                         cykl_sterownik_1 = sterownik_1_praca(0x97,1);
	LDI  R30,LOW(151)
	LDI  R31,HIGH(151)
	CALL SUBOPT_0x69
; 0000 0C89 
; 0000 0C8A                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
_0x22E:
	CALL SUBOPT_0x3C
	CALL __EQW12
	CALL SUBOPT_0x6B
	AND  R30,R0
	BREQ _0x22F
; 0000 0C8B                         {
; 0000 0C8C                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x5A
; 0000 0C8D                         krazek_scierny_cykl_po_okregu++;
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu)
	CALL SUBOPT_0x6C
; 0000 0C8E                         }
; 0000 0C8F 
; 0000 0C90                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
_0x22F:
	LDS  R30,_krazek_scierny_cykl_po_okregu_ilosc
	LDS  R31,_krazek_scierny_cykl_po_okregu_ilosc+1
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x19
	AND  R30,R0
	BREQ _0x230
; 0000 0C91                         {
; 0000 0C92                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x5A
; 0000 0C93                         wykonalem_komplet_okregow = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
; 0000 0C94                         }
; 0000 0C95 
; 0000 0C96                     if(koniec_rzedu_10 == 1)
_0x230:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	SBIW R26,1
	BRNE _0x231
; 0000 0C97                         cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x28
; 0000 0C98 
; 0000 0C99                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0)
_0x231:
	CALL SUBOPT_0x47
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x19
	AND  R30,R0
	BREQ _0x232
; 0000 0C9A                        cykl_sterownik_4 = sterownik_4_praca(0,1,0,0,0,1); //INV               //szczotka druc
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 0C9B 
; 0000 0C9C                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x232:
	CALL SUBOPT_0x47
	CALL SUBOPT_0x52
	BREQ _0x233
; 0000 0C9D                         {
; 0000 0C9E                         if(koniec_rzedu_10 == 0)
	LDS  R30,_koniec_rzedu_10
	LDS  R31,_koniec_rzedu_10+1
	SBIW R30,0
	BRNE _0x234
; 0000 0C9F                             cykl_sterownik_4 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x40
; 0000 0CA0                         if(abs_ster4 == 0)
_0x234:
	LDS  R30,_abs_ster4
	LDS  R31,_abs_ster4+1
	SBIW R30,0
	BRNE _0x235
; 0000 0CA1                             {
; 0000 0CA2                             szczotka_druc_cykl++;
	CALL SUBOPT_0x53
; 0000 0CA3                             abs_ster4 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R31
; 0000 0CA4                             }
; 0000 0CA5                         else
	RJMP _0x236
_0x235:
; 0000 0CA6                             abs_ster4 = 0;
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
; 0000 0CA7                         }
_0x236:
; 0000 0CA8 
; 0000 0CA9                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0)
_0x233:
	CALL SUBOPT_0x66
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x19
	AND  R30,R0
	BREQ _0x237
; 0000 0CAA                        cykl_sterownik_3 = sterownik_3_praca(0,1,0,0,1,0); //INV                   //krazek scierny
	CALL SUBOPT_0x50
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x70
; 0000 0CAB 
; 0000 0CAC 
; 0000 0CAD                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli)
_0x237:
	CALL SUBOPT_0x66
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x71
	CALL __LTW12
	AND  R30,R0
	BREQ _0x238
; 0000 0CAE                         {
; 0000 0CAF 
; 0000 0CB0                          cykl_sterownik_3 = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
; 0000 0CB1                         if(abs_ster3 == 0)
	LDS  R30,_abs_ster3
	LDS  R31,_abs_ster3+1
	SBIW R30,0
	BRNE _0x239
; 0000 0CB2                             {
; 0000 0CB3                             krazek_scierny_cykl++;
	LDI  R26,LOW(_krazek_scierny_cykl)
	LDI  R27,HIGH(_krazek_scierny_cykl)
	CALL SUBOPT_0x6C
; 0000 0CB4                             abs_ster3 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R31
; 0000 0CB5                             }
; 0000 0CB6                         else
	RJMP _0x23A
_0x239:
; 0000 0CB7                             abs_ster3 = 0;
	LDI  R30,LOW(0)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R30
; 0000 0CB8                         }
_0x23A:
; 0000 0CB9 
; 0000 0CBA                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x238:
	CALL SUBOPT_0x66
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x1A
	AND  R30,R0
	BREQ _0x23B
; 0000 0CBB                         cykl_sterownik_3 = sterownik_3_praca(1,0,0,0,0,1);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x49
	CALL SUBOPT_0x65
; 0000 0CBC 
; 0000 0CBD                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1)
_0x23B:
	CALL SUBOPT_0x47
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x1A
	AND  R30,R0
	BREQ _0x23C
; 0000 0CBE                         cykl_sterownik_4 = sterownik_4_praca(1,0,0,0,1,0);  //ABS          //druciak do gory
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4E
; 0000 0CBF 
; 0000 0CC0 
; 0000 0CC1                                                                                            //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 0CC2                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 1)
_0x23C:
	CALL SUBOPT_0x3C
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	CALL SUBOPT_0x1A
	AND  R30,R0
	BREQ _0x23D
; 0000 0CC3                         cykl_sterownik_1 = sterownik_1_praca(0x98,1);
	LDI  R30,LOW(152)
	LDI  R31,HIGH(152)
	CALL SUBOPT_0x69
; 0000 0CC4 
; 0000 0CC5 
; 0000 0CC6                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 1 &
_0x23D:
; 0000 0CC7                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 0CC8                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x1A
	AND  R0,R30
	CALL SUBOPT_0x54
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x71
	CALL __EQW12
	AND  R30,R0
	BREQ _0x23E
; 0000 0CC9                         {
; 0000 0CCA                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x3E
; 0000 0CCB                         cykl_sterownik_2 = 0;
; 0000 0CCC                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x3F
; 0000 0CCD                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0x40
; 0000 0CCE                         cykl_glowny = 8;
	CALL SUBOPT_0x6A
; 0000 0CCF                         szczotka_druc_cykl = 0;
; 0000 0CD0                         krazek_scierny_cykl = 0;
	LDI  R30,LOW(0)
	STS  _krazek_scierny_cykl,R30
	STS  _krazek_scierny_cykl+1,R30
; 0000 0CD1                         krazek_scierny_cykl_po_okregu = 0;
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
; 0000 0CD2                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0x63
; 0000 0CD3                         PORTF = PORT_F.byte;
; 0000 0CD4                         cykl_glowny = 9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL SUBOPT_0x43
; 0000 0CD5                         }
; 0000 0CD6 
; 0000 0CD7                                                                                                 //ster 1 - ruch po okregu
; 0000 0CD8                                                                                                 //ster 2 - nic
; 0000 0CD9                                                                                                 //ster 3 - krazek - gora dol
; 0000 0CDA                                                                                                 //ster 4 - druciak - gora dol
; 0000 0CDB 
; 0000 0CDC             break;
_0x23E:
	RJMP _0x1E7
; 0000 0CDD 
; 0000 0CDE 
; 0000 0CDF             case 9:
_0x22D:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x23F
; 0000 0CE0 
; 0000 0CE1 
; 0000 0CE2                          if(rzad_obrabiany == 1)
	CALL SUBOPT_0x34
	SBIW R26,1
	BRNE _0x240
; 0000 0CE3                          {
; 0000 0CE4                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)
	CALL SUBOPT_0x66
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x67
	AND  R30,R0
	BREQ _0x241
; 0000 0CE5                             cykl_sterownik_3 = sterownik_3_praca(0,0,0,0,0,1);  //do pozycji bazowej
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x65
; 0000 0CE6 
; 0000 0CE7                           //if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)
; 0000 0CE8                           //  cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej
; 0000 0CE9 
; 0000 0CEA                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_1 - 2)
_0x241:
	CALL SUBOPT_0x47
	CALL SUBOPT_0x72
	CALL SUBOPT_0x73
	BREQ _0x242
; 0000 0CEB                             cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	CALL SUBOPT_0x51
; 0000 0CEC 
; 0000 0CED 
; 0000 0CEE                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
_0x242:
	CALL SUBOPT_0x66
	CALL SUBOPT_0x72
	CALL SUBOPT_0x74
	BREQ _0x243
; 0000 0CEF                             cykl_sterownik_3 = sterownik_3_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	CALL SUBOPT_0x70
; 0000 0CF0 
; 0000 0CF1                           //if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
; 0000 0CF2                          //   cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
; 0000 0CF3 
; 0000 0CF4                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_1 - 2)
_0x243:
	CALL SUBOPT_0x47
	CALL SUBOPT_0x72
	CALL SUBOPT_0x75
	BREQ _0x244
; 0000 0CF5                             cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	RCALL _sterownik_4_praca
	CALL SUBOPT_0x28
; 0000 0CF6 
; 0000 0CF7                           }
_0x244:
; 0000 0CF8 
; 0000 0CF9 
; 0000 0CFA                          if(rzad_obrabiany == 2)
_0x240:
	CALL SUBOPT_0x34
	SBIW R26,2
	BRNE _0x245
; 0000 0CFB                          {
; 0000 0CFC                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
	CALL SUBOPT_0x66
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x68
	AND  R30,R0
	BREQ _0x246
; 0000 0CFD                             cykl_sterownik_3 = sterownik_3_praca(0,0,0,0,0,1);  //do pozycji bazowej
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x65
; 0000 0CFE 
; 0000 0CFF                          // if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
; 0000 0D00                          //   cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej
; 0000 0D01 
; 0000 0D02                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_2 - 2)
_0x246:
	CALL SUBOPT_0x47
	CALL SUBOPT_0x76
	CALL SUBOPT_0x73
	BREQ _0x247
; 0000 0D03                             cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	CALL SUBOPT_0x51
; 0000 0D04 
; 0000 0D05                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x247:
	CALL SUBOPT_0x66
	CALL SUBOPT_0x76
	CALL SUBOPT_0x74
	BREQ _0x248
; 0000 0D06                             cykl_sterownik_3 = sterownik_3_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	CALL SUBOPT_0x70
; 0000 0D07 
; 0000 0D08                          // if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
; 0000 0D09                          //   cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
; 0000 0D0A 
; 0000 0D0B                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_2 - 2)
_0x248:
	CALL SUBOPT_0x47
	CALL SUBOPT_0x76
	CALL SUBOPT_0x75
	BREQ _0x249
; 0000 0D0C                             cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	CALL SUBOPT_0x49
	RCALL _sterownik_4_praca
	CALL SUBOPT_0x28
; 0000 0D0D 
; 0000 0D0E                           }
_0x249:
; 0000 0D0F 
; 0000 0D10 
; 0000 0D11                           if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x245:
	CALL SUBOPT_0x66
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x47
	CALL __EQW12
	AND  R30,R0
	BREQ _0x24A
; 0000 0D12                             {
; 0000 0D13                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 0D14                             PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 0D15                             cykl_sterownik_4 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x40
; 0000 0D16                             cykl_sterownik_3 = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
; 0000 0D17                             cykl_ilosc_zaciskow++;
	LDI  R26,LOW(_cykl_ilosc_zaciskow)
	LDI  R27,HIGH(_cykl_ilosc_zaciskow)
	CALL SUBOPT_0x6C
; 0000 0D18                             ruch_zlozony = 2;                       //il_zaciskow_rzad_1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 0D19                             cykl_glowny = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x43
; 0000 0D1A                             }
; 0000 0D1B 
; 0000 0D1C 
; 0000 0D1D             break;
_0x24A:
	RJMP _0x1E7
; 0000 0D1E 
; 0000 0D1F 
; 0000 0D20 
; 0000 0D21             case 10:
_0x23F:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x24F
; 0000 0D22 
; 0000 0D23                                                //wywali ten warunek jak zadziala
; 0000 0D24                      if(rzad_obrabiany == 1 & cykl_glowny != 0)
	CALL SUBOPT_0x34
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x77
	BREQ _0x250
; 0000 0D25                             {
; 0000 0D26                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,16);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x78
	CALL SUBOPT_0x32
; 0000 0D27                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_1 - 1)
	CALL SUBOPT_0x79
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x251
; 0000 0D28                                 {
; 0000 0D29                                 cykl_glowny = 5;
	CALL SUBOPT_0x55
; 0000 0D2A                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0x41
; 0000 0D2B                                 }
; 0000 0D2C 
; 0000 0D2D                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
_0x251:
	CALL SUBOPT_0x79
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x252
; 0000 0D2E                                 {
; 0000 0D2F                                 cykl_glowny = 5;
	CALL SUBOPT_0x55
; 0000 0D30                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x7A
; 0000 0D31                                 }
; 0000 0D32 
; 0000 0D33                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 == 10)
_0x252:
	CALL SUBOPT_0x7B
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x253
; 0000 0D34                                 {
; 0000 0D35                                 cykl_glowny = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x43
; 0000 0D36                                 }
; 0000 0D37 
; 0000 0D38                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 != 10)  /////zmieniam + 1 20.02
_0x253:
	CALL SUBOPT_0x7B
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __NEW12
	AND  R30,R0
	BREQ _0x254
; 0000 0D39                                 {
; 0000 0D3A                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x43
; 0000 0D3B                                 }
; 0000 0D3C                             }
_0x254:
; 0000 0D3D 
; 0000 0D3E 
; 0000 0D3F                             if(rzad_obrabiany == 2 & cykl_glowny != 0)
_0x250:
	CALL SUBOPT_0x34
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	CALL SUBOPT_0x77
	BREQ _0x255
; 0000 0D40                             {
; 0000 0D41                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,96);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x78
	CALL SUBOPT_0x33
; 0000 0D42                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_2 - 1)
	CALL SUBOPT_0x7C
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x256
; 0000 0D43                                 {
; 0000 0D44                                 cykl_glowny = 5;
	CALL SUBOPT_0x55
; 0000 0D45                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0x41
; 0000 0D46                                 }
; 0000 0D47 
; 0000 0D48                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x256:
	CALL SUBOPT_0x7C
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x257
; 0000 0D49                                 {
; 0000 0D4A                                 cykl_glowny = 5;
	CALL SUBOPT_0x55
; 0000 0D4B                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x7A
; 0000 0D4C                                 }
; 0000 0D4D 
; 0000 0D4E                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 == 10)
_0x257:
	CALL SUBOPT_0x7D
	CALL __EQW12
	AND  R30,R0
	BREQ _0x258
; 0000 0D4F                                 {
; 0000 0D50                                 cykl_glowny = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x43
; 0000 0D51                                 }
; 0000 0D52 
; 0000 0D53 
; 0000 0D54                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 != 10)   ///////////////////zmieniam + 1 20.02
_0x258:
	CALL SUBOPT_0x7D
	CALL __NEW12
	AND  R30,R0
	BREQ _0x259
; 0000 0D55                                 {
; 0000 0D56                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x43
; 0000 0D57                                 }
; 0000 0D58                             }
_0x259:
; 0000 0D59 
; 0000 0D5A 
; 0000 0D5B 
; 0000 0D5C             break;
_0x255:
	RJMP _0x1E7
; 0000 0D5D 
; 0000 0D5E 
; 0000 0D5F 
; 0000 0D60             case 11:
_0x24F:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x25A
; 0000 0D61 
; 0000 0D62                              //ster 1 ucieka od szafy
; 0000 0D63                              if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x35
	BRGE _0x25B
; 0000 0D64                                     cykl_sterownik_1 = sterownik_1_praca(0x07,0);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x37
; 0000 0D65 
; 0000 0D66                              if(cykl_sterownik_2 < 5)
_0x25B:
	CALL SUBOPT_0x38
	BRGE _0x25C
; 0000 0D67                                     cykl_sterownik_2 = sterownik_2_praca(0x90,1);     //pod dolek ostatni 10 do przedmuchu rzad 1
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0x7E
; 0000 0D68 
; 0000 0D69                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x25C:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	AND  R30,R0
	BREQ _0x25D
; 0000 0D6A                                     {
; 0000 0D6B                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x61
; 0000 0D6C                                     PORTF = PORT_F.byte;
; 0000 0D6D                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0x5A
; 0000 0D6E                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x7F
; 0000 0D6F                                     cykl_glowny = 13;
; 0000 0D70                                     }
; 0000 0D71             break;
_0x25D:
	RJMP _0x1E7
; 0000 0D72 
; 0000 0D73 
; 0000 0D74             case 12:
_0x25A:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x25E
; 0000 0D75 
; 0000 0D76                                //ster 1 ucieka od szafy
; 0000 0D77                              if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x35
	BRGE _0x25F
; 0000 0D78                                     cykl_sterownik_1 = sterownik_1_praca(0x07,0);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x37
; 0000 0D79 
; 0000 0D7A                             if(cykl_sterownik_2 < 5)
_0x25F:
	CALL SUBOPT_0x38
	BRGE _0x260
; 0000 0D7B                                     cykl_sterownik_2 = sterownik_2_praca(0x91,1);     //pod dolek ostatni 10 do przedmuchu rzad 2
	LDI  R30,LOW(145)
	LDI  R31,HIGH(145)
	CALL SUBOPT_0x7E
; 0000 0D7C 
; 0000 0D7D                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x260:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	AND  R30,R0
	BREQ _0x261
; 0000 0D7E                                     {
; 0000 0D7F                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x61
; 0000 0D80                                     PORTF = PORT_F.byte;
; 0000 0D81                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0x5A
; 0000 0D82                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x7F
; 0000 0D83                                     cykl_glowny = 13;
; 0000 0D84                                     }
; 0000 0D85 
; 0000 0D86 
; 0000 0D87             break;
_0x261:
	RJMP _0x1E7
; 0000 0D88 
; 0000 0D89 
; 0000 0D8A 
; 0000 0D8B             case 13:
_0x25E:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x262
; 0000 0D8C 
; 0000 0D8D 
; 0000 0D8E                              if(cykl_sterownik_2 < 5)
	CALL SUBOPT_0x38
	BRGE _0x263
; 0000 0D8F                                     cykl_sterownik_2 = sterownik_2_praca(0x92,1);     //okrag
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	CALL SUBOPT_0x7E
; 0000 0D90                              if(cykl_sterownik_2 == 5)
_0x263:
	CALL SUBOPT_0x38
	BRNE _0x264
; 0000 0D91                                     {
; 0000 0D92                                     PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0x63
; 0000 0D93                                     PORTF = PORT_F.byte;
; 0000 0D94                                     cykl_sterownik_2 = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
; 0000 0D95                                     cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x43
; 0000 0D96                                     }
; 0000 0D97 
; 0000 0D98             break;
_0x264:
	RJMP _0x1E7
; 0000 0D99 
; 0000 0D9A 
; 0000 0D9B 
; 0000 0D9C             case 14:
_0x262:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x265
; 0000 0D9D 
; 0000 0D9E 
; 0000 0D9F                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x35
	BRGE _0x266
; 0000 0DA0                         cykl_sterownik_1 = sterownik_1_praca(0x03,0);     //pod nastepny dolek zeby przedmuchac
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x37
; 0000 0DA1                     if(cykl_sterownik_1 == 5)
_0x266:
	CALL SUBOPT_0x35
	BRNE _0x267
; 0000 0DA2                         {
; 0000 0DA3                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x5A
; 0000 0DA4                         sek12 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5F
; 0000 0DA5                         cykl_glowny = 15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x43
; 0000 0DA6                         }
; 0000 0DA7 
; 0000 0DA8             break;
_0x267:
	RJMP _0x1E7
; 0000 0DA9 
; 0000 0DAA 
; 0000 0DAB 
; 0000 0DAC             case 15:
_0x265:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x268
; 0000 0DAD 
; 0000 0DAE                     //przedmuch
; 0000 0DAF                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0x61
; 0000 0DB0                     PORTF = PORT_F.byte;
; 0000 0DB1                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0x62
	BRGE _0x269
; 0000 0DB2                         {
; 0000 0DB3                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0x63
; 0000 0DB4                         PORTF = PORT_F.byte;
; 0000 0DB5                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x43
; 0000 0DB6                         }
; 0000 0DB7             break;
_0x269:
	RJMP _0x1E7
; 0000 0DB8 
; 0000 0DB9 
; 0000 0DBA             case 16:
_0x268:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x26A
; 0000 0DBB 
; 0000 0DBC                      if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & wykonalem_rzedow == 0)  /////zmieniam + 1 20.02
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	CALL SUBOPT_0x60
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x80
	CALL SUBOPT_0x19
	AND  R30,R0
	BREQ _0x26B
; 0000 0DBD                                 {
; 0000 0DBE                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x2D
; 0000 0DBF 
; 0000 0DC0                                 if(il_zaciskow_rzad_2 > 0)
	CALL SUBOPT_0x81
	CALL __CPW02
	BRGE _0x26C
; 0000 0DC1                                     {
; 0000 0DC2                                     rzad_obrabiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
; 0000 0DC3                                     cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 0DC4                                     }
; 0000 0DC5                                 else
	RJMP _0x26D
_0x26C:
; 0000 0DC6                                     cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x43
; 0000 0DC7 
; 0000 0DC8                                 wykonalem_rzedow = 1;
_0x26D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 0DC9                                 }
; 0000 0DCA 
; 0000 0DCB                        if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 1)   ///////////////////zmieniam + 1 20.02
_0x26B:
	LDS  R30,_il_zaciskow_rzad_2
	LDS  R31,_il_zaciskow_rzad_2+1
	CALL SUBOPT_0x60
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x81
	CALL SUBOPT_0x31
	CALL SUBOPT_0x80
	CALL SUBOPT_0x1A
	AND  R30,R0
	BREQ _0x26E
; 0000 0DCC                                 {
; 0000 0DCD                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x2D
; 0000 0DCE                                 cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x43
; 0000 0DCF                                 rzad_obrabiany = 1;
	CALL SUBOPT_0x2A
; 0000 0DD0                                 wykonalem_rzedow = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 0DD1                                 }
; 0000 0DD2 
; 0000 0DD3 
; 0000 0DD4 
; 0000 0DD5 
; 0000 0DD6                         if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 2)
_0x26E:
	CALL SUBOPT_0x82
	CALL SUBOPT_0x31
	CALL SUBOPT_0x80
	CALL SUBOPT_0x46
	BREQ _0x26F
; 0000 0DD7                                   {
; 0000 0DD8                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x2A
; 0000 0DD9                                   wykonalem_rzedow = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x2C
; 0000 0DDA                                   PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
	CBI  0x3,6
; 0000 0DDB                                   PORTB.6 = 0;   ////zielona lampka
	CBI  0x18,6
; 0000 0DDC                                   wartosc_parametru_panelu(0,0,64);
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x83
; 0000 0DDD                                   }
; 0000 0DDE 
; 0000 0DDF                             if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 == 0 & wykonalem_rzedow == 1)
_0x26F:
	CALL SUBOPT_0x82
	CALL SUBOPT_0x19
	AND  R0,R30
	CALL SUBOPT_0x80
	CALL SUBOPT_0x1A
	AND  R30,R0
	BREQ _0x274
; 0000 0DE0                                   {
; 0000 0DE1                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x2A
; 0000 0DE2                                   wykonalem_rzedow = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x2C
; 0000 0DE3                                   PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
	SBI  0x3,6
; 0000 0DE4                                   PORTB.6 = 0;   ////zielona lampka
	CBI  0x18,6
; 0000 0DE5                                   wartosc_parametru_panelu(0,0,64);
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x83
; 0000 0DE6                                   }
; 0000 0DE7 
; 0000 0DE8 
; 0000 0DE9 
; 0000 0DEA             break;
_0x274:
	RJMP _0x1E7
; 0000 0DEB 
; 0000 0DEC 
; 0000 0DED             case 17:
_0x26A:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x1E7
; 0000 0DEE 
; 0000 0DEF 
; 0000 0DF0                                  if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x35
	BRGE _0x27A
; 0000 0DF1                                     cykl_sterownik_1 = sterownik_1_praca(0x09,0);
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
; 0000 0DF2                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x27A:
	CALL SUBOPT_0x38
	BRGE _0x27B
; 0000 0DF3                                     cykl_sterownik_2 = sterownik_2_praca(0x00,0);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x39
; 0000 0DF4 
; 0000 0DF5                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x27B:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	AND  R30,R0
	BREQ _0x27C
; 0000 0DF6                                         {
; 0000 0DF7                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x5A
; 0000 0DF8                                         cykl_sterownik_2 = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
; 0000 0DF9                                         jestem_w_trakcie_czyszczenia_calosci = 0;
	CALL SUBOPT_0x2B
; 0000 0DFA                                         start = 0;
	STS  _start,R30
	STS  _start+1,R30
; 0000 0DFB                                         }
; 0000 0DFC 
; 0000 0DFD 
; 0000 0DFE 
; 0000 0DFF 
; 0000 0E00             break;
_0x27C:
; 0000 0E01 
; 0000 0E02 
; 0000 0E03             }//switch
_0x1E7:
; 0000 0E04 
; 0000 0E05 
; 0000 0E06   }//while
	RJMP _0x1E2
_0x1E4:
; 0000 0E07 }//while glowny
	RJMP _0x1DF
; 0000 0E08 
; 0000 0E09 }//koniec
_0x27D:
	RJMP _0x27D
;
;
;
;//odrzuty
; /*
;      putchar(90);
;      putchar(165);
;      putchar(10);       //ilosc liter 8 + 3, tu moze byc faza bo jade przez putchar a nie printf, moze byc wiecej znakow
;      putchar(130);  //82
;      putchar(0);    //0
;      putchar(80);  //adres 90 - 144   , nowy adres to 50 czyli 80
;      putchar('8');
;      putchar('6');
;      putchar('-');
;      putchar('0');
;      putchar('1');
;      putchar('9');
;      putchar('3');
;      */
;
;
;
;
;//odrzuty
;/*
;  while(cykl_sterownik_2 != 5)
;        {
;        if(cykl_sterownik_2 < 5)
;                cykl_sterownik_2 = sterownik_2_praca(0x00,0);
;
;        }
;
;        if(cykl_sterownik_2 == 5)
;              cykl_sterownik_2 = 0;
;
;        while(cykl_sterownik_2 != 5)
;        {
;        xxx = 1;
;        PORTB.6 = 0;  //zielona lampka
;        if(cykl_sterownik_2 < 5)
;                cykl_sterownik_2 = sterownik_2_praca(0x5A,0);
;
;        }
;
;
;        while(1)
;            {
;            }
;
;*/
;
; /*
;        if(cykl_sterownik_3 < 5 & cykl_sterownik_3_wykonalem == 0)
;                cykl_sterownik_3 = sterownik_3_praca(0,0,1,0,1,0);
;        if(cykl_sterownik_3 == 5)
;              cykl_sterownik_3 = 0;
;        if(cykl_sterownik_3 < 5 & cykl_sterownik_3_wykonalem == 1)
;                cykl_sterownik_3 = sterownik_3_praca(0,0,1,0,1,1);
;
;        */
;
;
; /*
;             if(cykl_sterownik_1 != 5)
;                cykl_sterownik_1 = sterownik_1_praca(0x00);
;             if(cykl_sterownik_3 != 5)
;                cykl_sterownik_3 = sterownik_3_praca(0,0,0,0);
;             */
;
;
;//interrupt [TIM2_OVF] void timer2_ovf_isr(void)
;//{
;
;/*
;if(odczytalem_zacisk < il_prob_odczytu & (PINA.0 == 1 | PINA.1 == 1 | PINA.2 == 1 | PINA.3 == 1 | PINA.4 == 1 | PINA.5 == 1 | PINA.6 == 1 | PINA.7 == 1))
;    {
;    //PORT_CZYTNIK.byte = PORTHH.byte;
;
;    PORT_CZYTNIK.bits.b0 = PINA.0;
;    PORT_CZYTNIK.bits.b1 = PINA.1;
;    PORT_CZYTNIK.bits.b2 = PINA.2;
;    PORT_CZYTNIK.bits.b3 = PINA.3;
;    PORT_CZYTNIK.bits.b4 = PINA.4;
;    PORT_CZYTNIK.bits.b5 = PINA.5;
;    PORT_CZYTNIK.bits.b6 = PINA.6;
;    PORT_CZYTNIK.bits.b7 = PINA.7;
;
;    odczytalem_zacisk++;
;    }
;
;
;*/
;
;/*
;if(odczytalem_zacisk < il_prob_odczytu &
;                                           (sprawdz_pin0(PORTHH,0x73) == 1 |
;                                            sprawdz_pin1(PORTHH,0x73) == 1 |
;                                            sprawdz_pin2(PORTHH,0x73) == 1 |
;                                            sprawdz_pin3(PORTHH,0x73) == 1 |
;                                            sprawdz_pin4(PORTHH,0x73) == 1 |
;                                            sprawdz_pin5(PORTHH,0x73) == 1 |
;                                            sprawdz_pin6(PORTHH,0x73) == 1 |
;                                            sprawdz_pin7(PORTHH,0x73) == 1))
;        {
;        //PORTB = 0xFF;
;        odczytalem_zacisk++;
;        }
;
;*/
;
;//}
;
;
;/*
;
;
;                         if(rzad_obrabiany == 1)
;                         {
;                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != 2)
;                            cykl_sterownik_3 = sterownik_3_praca(0,0,0,0,0,1);  //do pozycji bazowej
;
;                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow != 2)
;                            cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej
;
;
;                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == 2)
;                            cykl_sterownik_3 = sterownik_3_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
;
;                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow == 2)
;                            cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
;                          }
;
;
;*/

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
	CALL SUBOPT_0x6C
	ADIW R28,3
	RET
__print_G103:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
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
	CALL SUBOPT_0x84
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x84
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
	CALL SUBOPT_0x85
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x86
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x85
	CALL SUBOPT_0x87
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x85
	CALL SUBOPT_0x87
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
	CALL SUBOPT_0x85
	CALL SUBOPT_0x88
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
	CALL SUBOPT_0x85
	CALL SUBOPT_0x88
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
	CALL SUBOPT_0x84
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
	CALL SUBOPT_0x84
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
	CALL SUBOPT_0x86
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x84
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
	CALL SUBOPT_0x86
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
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
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
_start:
	.BYTE 0x2
_cykl:
	.BYTE 0x2
_bbb:
	.BYTE 0x2
_pozycjonowanie_LEFS32_300_1:
	.BYTE 0x2
_pozycjonowanie_LEFS32_300_2:
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
_szczotka_druciana_ilosc_cykli:
	.BYTE 0x2
_szczotka_druc_cykl:
	.BYTE 0x2
_cykl_glowny:
	.BYTE 0x2
_start_kontynuacja:
	.BYTE 0x2
_ruch_zlozony:
	.BYTE 0x2
_krazek_scierny_cykl_po_okregu:
	.BYTE 0x2
_krazek_scierny_cykl_po_okregu_ilosc:
	.BYTE 0x2
_krazek_scierny_cykl:
	.BYTE 0x2
_krazek_scierny_ilosc_cykli:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(90)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(165)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	CALL _putchar
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _putchar
	LDD  R30,Y+2
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	CALL _getchar
	CALL _getchar
	JMP  _getchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x4:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL _putchar
	LDI  R30,LOW(130)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x7:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(_PORTJJ)
	LDI  R31,HIGH(_PORTJJ)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:153 WORDS
SUBOPT_0xA:
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
SUBOPT_0xB:
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
SUBOPT_0xC:
	OR   R30,R0
	STS  _PORT_CZYTNIK,R30
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 144 TIMES, CODE SIZE REDUCTION:1570 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R13
	ST   -Y,R12
	CALL _komunikat_z_czytnika_kodow
	MOVW R30,R12
	LDI  R26,LOW(_macierz_zaciskow)
	LDI  R27,HIGH(_macierz_zaciskow)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	__POINTW1FN _0x0,1265
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x10:
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	CALL _sprawdz_pin3
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(_PORTLL)
	LDI  R31,HIGH(_PORTLL)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(_PORTKK)
	LDI  R31,HIGH(_PORTKK)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(117)
	LDI  R31,HIGH(117)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	CALL _sprawdz_pin7
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	AND  R30,R26
	MOV  R0,R30
	LDS  R26,_czekaj_az_puszcze
	LDS  R27,_czekaj_az_puszcze+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
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
SUBOPT_0x1C:
	LDI  R30,LOW(0)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(0)
	STS  _sek11,R30
	STS  _sek11+1,R30
	STS  _sek11+2,R30
	STS  _sek11+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	STS  _sek1,R30
	STS  _sek1+1,R30
	STS  _sek1+2,R30
	STS  _sek1+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1F:
	__CPD2N 0x2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x20:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(0)
	STS  _sek3,R30
	STS  _sek3+1,R30
	STS  _sek3+2,R30
	STS  _sek3+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x22:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x23:
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(0)
	STS  _sek2,R30
	STS  _sek2+1,R30
	STS  _sek2+2,R30
	STS  _sek2+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x25:
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	STS  _PORT_F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(0)
	STS  _sek4,R30
	STS  _sek4+1,R30
	STS  _sek4+2,R30
	STS  _sek4+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x28:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(0)
	STS  _cykl_ilosc_zaciskow,R30
	STS  _cykl_ilosc_zaciskow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 41 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	MOV  R0,R30
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x34:
	LDS  R26,_rzad_obrabiany
	LDS  R27,_rzad_obrabiany+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x35:
	LDS  R26,_cykl_sterownik_1
	LDS  R27,_cykl_sterownik_1+1
	SBIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x37:
	CALL _sterownik_1_praca
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x38:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	SBIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x39:
	CALL _sterownik_2_praca
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x3C:
	LDS  R26,_cykl_sterownik_1
	LDS  R27,_cykl_sterownik_1+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x3D:
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3F:
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x40:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	LDI  R30,LOW(0)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x42:
	STS  _start_kontynuacja,R30
	STS  _start_kontynuacja+1,R31
	LDS  R26,_start_kontynuacja
	LDS  R27,_start_kontynuacja+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x43:
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x44:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x45:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x46:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x47:
	LDS  R26,_cykl_sterownik_4
	LDS  R27,_cykl_sterownik_4+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x49:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4A:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _sterownik_4_praca
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	LDI  R30,LOW(0)
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4C:
	LDS  R26,_cykl_sterownik_4
	LDS  R27,_cykl_sterownik_4+1
	SBIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4D:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4E:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _sterownik_4_praca
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	RCALL SUBOPT_0x40
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP SUBOPT_0x4D

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x51:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP SUBOPT_0x4A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x52:
	CALL __EQW12
	MOV  R0,R30
	LDS  R30,_szczotka_druciana_ilosc_cykli
	LDS  R31,_szczotka_druciana_ilosc_cykli+1
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x53:
	LDI  R26,LOW(_szczotka_druc_cykl)
	LDI  R27,HIGH(_szczotka_druc_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	LDS  R30,_szczotka_druciana_ilosc_cykli
	LDS  R31,_szczotka_druciana_ilosc_cykli+1
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x55:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x56:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x57:
	AND  R0,R30
	RCALL SUBOPT_0x34
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x58:
	AND  R0,R30
	RCALL SUBOPT_0x34
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x59:
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x5A:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5B:
	CALL __LTW12
	RJMP SUBOPT_0x59

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5C:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x5C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x5E:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5F:
	STS  _sek12,R30
	STS  _sek12+1,R30
	STS  _sek12+2,R30
	STS  _sek12+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x60:
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x61:
	LDS  R30,_PORT_F
	ORI  R30,0x10
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x62:
	LDS  R30,_czas_przedmuchu
	LDS  R31,_czas_przedmuchu+1
	LDS  R26,_sek12
	LDS  R27,_sek12+1
	LDS  R24,_sek12+2
	LDS  R25,_sek12+3
	CALL __CWD1
	CALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x63:
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x64:
	LDS  R26,_cykl_sterownik_3
	LDS  R27,_cykl_sterownik_3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x65:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _sterownik_3_praca
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x66:
	RCALL SUBOPT_0x64
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x67:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	RCALL SUBOPT_0x60
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x68:
	LDS  R30,_il_zaciskow_rzad_2
	LDS  R31,_il_zaciskow_rzad_2+1
	SBIW R30,1
	RCALL SUBOPT_0x60
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x69:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x37

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6A:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x43
	RJMP SUBOPT_0x4B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6B:
	MOV  R0,R30
	LDS  R30,_krazek_scierny_cykl_po_okregu_ilosc
	LDS  R31,_krazek_scierny_cykl_po_okregu_ilosc+1
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __LTW12
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6C:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6D:
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6E:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster4
	LDS  R27,_abs_ster4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6F:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster3
	LDS  R27,_abs_ster3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x70:
	CALL _sterownik_3_praca
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x71:
	LDS  R30,_krazek_scierny_ilosc_cykli
	LDS  R31,_krazek_scierny_ilosc_cykli+1
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x72:
	CALL __LTW12
	MOV  R0,R30
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	SBIW R30,2
	RCALL SUBOPT_0x60
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x74:
	SBIW R30,1
	RCALL SUBOPT_0x60
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x75:
	SBIW R30,2
	RCALL SUBOPT_0x60
	CALL __GEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x76:
	CALL __LTW12
	MOV  R0,R30
	LDS  R30,_il_zaciskow_rzad_2
	LDS  R31,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x77:
	MOV  R0,R30
	LDS  R26,_cykl_glowny
	LDS  R27,_cykl_glowny+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x78:
	LDS  R30,_cykl_ilosc_zaciskow
	LDS  R31,_cykl_ilosc_zaciskow+1
	RJMP SUBOPT_0x5C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x79:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	RJMP SUBOPT_0x60

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7B:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RCALL SUBOPT_0x60
	CALL __EQW12
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7C:
	LDS  R30,_il_zaciskow_rzad_2
	LDS  R31,_il_zaciskow_rzad_2+1
	SBIW R30,1
	RJMP SUBOPT_0x60

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7D:
	LDS  R30,_il_zaciskow_rzad_2
	LDS  R31,_il_zaciskow_rzad_2+1
	RCALL SUBOPT_0x60
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_il_zaciskow_rzad_2
	LDS  R27,_il_zaciskow_rzad_2+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7E:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7F:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x80:
	LDS  R26,_wykonalem_rzedow
	LDS  R27,_wykonalem_rzedow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x81:
	LDS  R26,_il_zaciskow_rzad_2
	LDS  R27,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x82:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	MOV  R0,R30
	RJMP SUBOPT_0x81

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x83:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x84:
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
SUBOPT_0x85:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x86:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x87:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x88:
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
