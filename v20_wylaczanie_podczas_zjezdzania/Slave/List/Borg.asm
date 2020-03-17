
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
	.DEF _spr0=R5
	.DEF _spr1=R4

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
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

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
;
;
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
; 0000 0026 {

	.CSEG
_getchar1:
; 0000 0027 unsigned char status;
; 0000 0028 char data;
; 0000 0029 while (1)
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
_0x3:
; 0000 002A       {
; 0000 002B       while (((status=UCSR1A) & RX_COMPLETE)==0);
_0x6:
	LDS  R30,155
	MOV  R17,R30
	ANDI R30,LOW(0x80)
	BREQ _0x6
; 0000 002C       data=UDR1;
	LDS  R16,156
; 0000 002D       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x9
; 0000 002E          return data;
	MOV  R30,R16
	RJMP _0x2060001
; 0000 002F       }
_0x9:
	RJMP _0x3
; 0000 0030 }
;#pragma used-
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 0036 {
; 0000 0037 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
; 0000 0038 UDR1=c;
; 0000 0039 }
;#pragma used-
;
;
;
;#include <mega128.h>
;#include <delay.h>
;
;// Standard Input/Output functions
;#include <stdio.h>
;#include <string.h>
;
;
;char spr0,spr1;
;char odczyt[20];
;
;
;// Declare your global variables here
;
;
;void wyzeruj_odczyty()
; 0000 004E {
_wyzeruj_odczyty:
; 0000 004F int i;
; 0000 0050 
; 0000 0051 PORTA = 0x00;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0052 PORTB = 0x00;
	OUT  0x18,R30
; 0000 0053 spr0 = '0';
	LDI  R30,LOW(48)
	MOV  R5,R30
; 0000 0054 spr1 = '0';
	MOV  R4,R30
; 0000 0055 for(i=0;i<8;i++)
	__GETWRN 16,17,0
_0xE:
	__CPWRN 16,17,8
	BRGE _0xF
; 0000 0056     odczyt[i] = '0';
	LDI  R26,LOW(_odczyt)
	LDI  R27,HIGH(_odczyt)
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(48)
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0xE
_0xF:
; 0000 0057 }
_0x2060001:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;void wybierz_zacisk(char a,char b,char c,char d,char e,char f,char g)
; 0000 005B {
_wybierz_zacisk:
; 0000 005C 
; 0000 005D //////////////////////////////////////////////////////
; 0000 005E 
; 0000 005F if(
;	a -> Y+6
;	b -> Y+5
;	c -> Y+4
;	d -> Y+3
;	e -> Y+2
;	f -> Y+1
;	g -> Y+0
; 0000 0060 a == '8'&
; 0000 0061 b == '6'&
; 0000 0062 c == '-'&
; 0000 0063 d == '0'&
; 0000 0064 e == '1'&
; 0000 0065 f == '7'&
; 0000 0066 g == '0'
; 0000 0067 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	BREQ _0x10
; 0000 0068 {
; 0000 0069 PORTA = 0x01;
	LDI  R30,LOW(1)
	OUT  0x1B,R30
; 0000 006A }
; 0000 006B 
; 0000 006C ////////////////////////////////////////////////////////////////
; 0000 006D 
; 0000 006E 
; 0000 006F if(
_0x10:
; 0000 0070 a == '8'&
; 0000 0071 b == '6'&
; 0000 0072 c == '-'&
; 0000 0073 d == '1'&
; 0000 0074 e == '0'&
; 0000 0075 f == '4'&
; 0000 0076 g == '3'
; 0000 0077 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x1
	CALL SUBOPT_0x4
	BREQ _0x11
; 0000 0078 {
; 0000 0079 PORTA = 0x02;
	LDI  R30,LOW(2)
	OUT  0x1B,R30
; 0000 007A }
; 0000 007B 
; 0000 007C 
; 0000 007D ////////////////////////////////////////////////////////////////
; 0000 007E 
; 0000 007F 
; 0000 0080 if(
_0x11:
; 0000 0081 a == '8'&
; 0000 0082 b == '6'&
; 0000 0083 c == '-'&
; 0000 0084 d == '1'&
; 0000 0085 e == '6'&
; 0000 0086 f == '7'&
; 0000 0087 g == '5'
; 0000 0088 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
	BREQ _0x12
; 0000 0089 {
; 0000 008A PORTA = 0x03;
	LDI  R30,LOW(3)
	OUT  0x1B,R30
; 0000 008B }
; 0000 008C 
; 0000 008D ////////////////////////////////////////////////////////////////
; 0000 008E 
; 0000 008F 
; 0000 0090 if(
_0x12:
; 0000 0091 a == '8'&
; 0000 0092 b == '6'&
; 0000 0093 c == '-'&
; 0000 0094 d == '2'&
; 0000 0095 e == '0'&
; 0000 0096 f == '9'&
; 0000 0097 g == '8'
; 0000 0098 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	BREQ _0x13
; 0000 0099 {
; 0000 009A PORTA = 0x04;
	LDI  R30,LOW(4)
	OUT  0x1B,R30
; 0000 009B }
; 0000 009C 
; 0000 009D ////////////////////////////////////////////////////////////////
; 0000 009E 
; 0000 009F 
; 0000 00A0 if(
_0x13:
; 0000 00A1 a == '8'&
; 0000 00A2 b == '7'&
; 0000 00A3 c == '-'&
; 0000 00A4 d == '0'&
; 0000 00A5 e == '1'&
; 0000 00A6 f == '7'&
; 0000 00A7 g == '0'
; 0000 00A8 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	BREQ _0x14
; 0000 00A9 {
; 0000 00AA PORTA = 0x05;
	LDI  R30,LOW(5)
	OUT  0x1B,R30
; 0000 00AB }
; 0000 00AC 
; 0000 00AD ////////////////////////////////////////////////////////////////
; 0000 00AE 
; 0000 00AF 
; 0000 00B0 if(
_0x14:
; 0000 00B1 a == '8'&
; 0000 00B2 b == '7'&
; 0000 00B3 c == '-'&
; 0000 00B4 d == '1'&
; 0000 00B5 e == '0'&
; 0000 00B6 f == '4'&
; 0000 00B7 g == '3'
; 0000 00B8 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x1
	CALL SUBOPT_0x4
	BREQ _0x15
; 0000 00B9 {
; 0000 00BA PORTA = 0x06;
	LDI  R30,LOW(6)
	OUT  0x1B,R30
; 0000 00BB }
; 0000 00BC 
; 0000 00BD 
; 0000 00BE ////////////////////////////////////////////////////////////////
; 0000 00BF 
; 0000 00C0 
; 0000 00C1 if(
_0x15:
; 0000 00C2 a == '8'&
; 0000 00C3 b == '7'&
; 0000 00C4 c == '-'&
; 0000 00C5 d == '1'&
; 0000 00C6 e == '6'&
; 0000 00C7 f == '7'&
; 0000 00C8 g == '5'
; 0000 00C9 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
	BREQ _0x16
; 0000 00CA {
; 0000 00CB PORTA = 0x07;
	LDI  R30,LOW(7)
	OUT  0x1B,R30
; 0000 00CC }
; 0000 00CD 
; 0000 00CE ////////////////////////////////////////////////////////////////
; 0000 00CF 
; 0000 00D0 
; 0000 00D1 if(
_0x16:
; 0000 00D2 a == '8'&
; 0000 00D3 b == '7'&
; 0000 00D4 c == '-'&
; 0000 00D5 d == '2'&
; 0000 00D6 e == '0'&
; 0000 00D7 f == '9'&
; 0000 00D8 g == '8'
; 0000 00D9 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	BREQ _0x17
; 0000 00DA {
; 0000 00DB PORTA = 0x08;
	LDI  R30,LOW(8)
	OUT  0x1B,R30
; 0000 00DC }
; 0000 00DD 
; 0000 00DE ////////////////////////////////////////////////////////////////
; 0000 00DF 
; 0000 00E0 
; 0000 00E1 if(
_0x17:
; 0000 00E2 a == '8'&
; 0000 00E3 b == '6'&
; 0000 00E4 c == '-'&
; 0000 00E5 d == '0'&
; 0000 00E6 e == '1'&
; 0000 00E7 f == '9'&
; 0000 00E8 g == '2'
; 0000 00E9 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	BREQ _0x18
; 0000 00EA {
; 0000 00EB PORTA = 0x09;
	LDI  R30,LOW(9)
	OUT  0x1B,R30
; 0000 00EC }
; 0000 00ED 
; 0000 00EE ////////////////////////////////////////////////////////////////
; 0000 00EF 
; 0000 00F0 
; 0000 00F1 if(
_0x18:
; 0000 00F2 a == '8'&
; 0000 00F3 b == '6'&
; 0000 00F4 c == '-'&
; 0000 00F5 d == '1'&
; 0000 00F6 e == '0'&
; 0000 00F7 f == '5'&
; 0000 00F8 g == '4'
; 0000 00F9 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x1
	CALL SUBOPT_0xB
	BREQ _0x19
; 0000 00FA {
; 0000 00FB PORTA = 0x0A;
	LDI  R30,LOW(10)
	OUT  0x1B,R30
; 0000 00FC }
; 0000 00FD 
; 0000 00FE ////////////////////////////////////////////////////////////////
; 0000 00FF 
; 0000 0100 
; 0000 0101 if(
_0x19:
; 0000 0102 a == '8'&
; 0000 0103 b == '6'&
; 0000 0104 c == '-'&
; 0000 0105 d == '1'&
; 0000 0106 e == '6'&
; 0000 0107 f == '7'&
; 0000 0108 g == '6'
; 0000 0109 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0xC
	BREQ _0x1A
; 0000 010A {
; 0000 010B PORTA = 0x0B;
	LDI  R30,LOW(11)
	OUT  0x1B,R30
; 0000 010C }
; 0000 010D 
; 0000 010E 
; 0000 010F ////////////////////////////////////////////////////////////////
; 0000 0110 
; 0000 0111 
; 0000 0112 if(
_0x1A:
; 0000 0113 a == '8'&
; 0000 0114 b == '6'&
; 0000 0115 c == '-'&
; 0000 0116 d == '2'&
; 0000 0117 e == '1'&
; 0000 0118 f == '3'&
; 0000 0119 g == '2'
; 0000 011A )
	CALL SUBOPT_0x0
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	BREQ _0x1B
; 0000 011B {
; 0000 011C PORTA = 0x0C;
	LDI  R30,LOW(12)
	OUT  0x1B,R30
; 0000 011D }
; 0000 011E 
; 0000 011F ////////////////////////////////////////////////////////////////
; 0000 0120 
; 0000 0121 
; 0000 0122 if(
_0x1B:
; 0000 0123 a == '8'&
; 0000 0124 b == '7'&
; 0000 0125 c == '-'&
; 0000 0126 d == '0'&
; 0000 0127 e == '1'&
; 0000 0128 f == '9'&
; 0000 0129 g == '2'
; 0000 012A )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	BREQ _0x1C
; 0000 012B {
; 0000 012C PORTA = 0x0D;
	LDI  R30,LOW(13)
	OUT  0x1B,R30
; 0000 012D }
; 0000 012E 
; 0000 012F ////////////////////////////////////////////////////////////////
; 0000 0130 
; 0000 0131 
; 0000 0132 if(
_0x1C:
; 0000 0133 a == '8'&
; 0000 0134 b == '7'&
; 0000 0135 c == '-'&
; 0000 0136 d == '1'&
; 0000 0137 e == '0'&
; 0000 0138 f == '5'&
; 0000 0139 g == '4'
; 0000 013A )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x1
	CALL SUBOPT_0xB
	BREQ _0x1D
; 0000 013B {
; 0000 013C PORTA = 0x0E;
	LDI  R30,LOW(14)
	OUT  0x1B,R30
; 0000 013D }
; 0000 013E 
; 0000 013F ////////////////////////////////////////////////////////////////
; 0000 0140 
; 0000 0141 
; 0000 0142 if(
_0x1D:
; 0000 0143 a == '8'&
; 0000 0144 b == '7'&
; 0000 0145 c == '-'&
; 0000 0146 d == '1'&
; 0000 0147 e == '6'&
; 0000 0148 f == '7'&
; 0000 0149 g == '6'
; 0000 014A )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0xC
	BREQ _0x1E
; 0000 014B {
; 0000 014C PORTA = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x1B,R30
; 0000 014D }
; 0000 014E 
; 0000 014F ////////////////////////////////////////////////////////////////
; 0000 0150 
; 0000 0151 
; 0000 0152 if(
_0x1E:
; 0000 0153 a == '8'&
; 0000 0154 b == '7'&
; 0000 0155 c == '-'&
; 0000 0156 d == '2'&
; 0000 0157 e == '1'&
; 0000 0158 f == '3'&
; 0000 0159 g == '2'
; 0000 015A )
	CALL SUBOPT_0x8
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	BREQ _0x1F
; 0000 015B {
; 0000 015C PORTA = 0x10;
	LDI  R30,LOW(16)
	OUT  0x1B,R30
; 0000 015D }
; 0000 015E 
; 0000 015F 
; 0000 0160 ////////////////////////////////////////////////////////////////
; 0000 0161 
; 0000 0162 
; 0000 0163 if(
_0x1F:
; 0000 0164 a == '8'&
; 0000 0165 b == '6'&
; 0000 0166 c == '-'&
; 0000 0167 d == '0'&
; 0000 0168 e == '1'&
; 0000 0169 f == '9'&
; 0000 016A g == '3'
; 0000 016B )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	CALL SUBOPT_0x9
	CALL SUBOPT_0xF
	BREQ _0x20
; 0000 016C {
; 0000 016D PORTA = 0x11;
	LDI  R30,LOW(17)
	OUT  0x1B,R30
; 0000 016E }
; 0000 016F 
; 0000 0170 
; 0000 0171 ///////////////////////////////////////////////////////////////
; 0000 0172 
; 0000 0173 if(
_0x20:
; 0000 0174 a == '8'&
; 0000 0175 b == '6'&
; 0000 0176 c == '-'&
; 0000 0177 d == '1'&
; 0000 0178 e == '2'&
; 0000 0179 f == '1'&
; 0000 017A g == '6'
; 0000 017B )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x10
	BREQ _0x21
; 0000 017C {
; 0000 017D PORTA = 0x12;
	LDI  R30,LOW(18)
	OUT  0x1B,R30
; 0000 017E }
; 0000 017F 
; 0000 0180 
; 0000 0181 ///////////////////////////////////////////////////////////////
; 0000 0182 
; 0000 0183 if(
_0x21:
; 0000 0184 a == '8'&
; 0000 0185 b == '6'&
; 0000 0186 c == '-'&
; 0000 0187 d == '1'&
; 0000 0188 e == '8'&
; 0000 0189 f == '3'&
; 0000 018A g == '2'
; 0000 018B )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x11
	BREQ _0x22
; 0000 018C {
; 0000 018D PORTA = 0x13;
	LDI  R30,LOW(19)
	OUT  0x1B,R30
; 0000 018E }
; 0000 018F 
; 0000 0190 ///////////////////////////////////////////////////////////////
; 0000 0191 
; 0000 0192 if(
_0x22:
; 0000 0193 a == '8'&
; 0000 0194 b == '6'&
; 0000 0195 c == '-'&
; 0000 0196 d == '2'&
; 0000 0197 e == '1'&
; 0000 0198 f == '7'&
; 0000 0199 g == '4'
; 0000 019A )
	CALL SUBOPT_0x0
	CALL SUBOPT_0xD
	CALL SUBOPT_0x12
	BREQ _0x23
; 0000 019B {
; 0000 019C PORTA = 0x14;
	LDI  R30,LOW(20)
	OUT  0x1B,R30
; 0000 019D }
; 0000 019E 
; 0000 019F ///////////////////////////////////////////////////////////////
; 0000 01A0 
; 0000 01A1 if(
_0x23:
; 0000 01A2 a == '8'&
; 0000 01A3 b == '7'&
; 0000 01A4 c == '-'&
; 0000 01A5 d == '0'&
; 0000 01A6 e == '1'&
; 0000 01A7 f == '9'&
; 0000 01A8 g == '3'
; 0000 01A9 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	CALL SUBOPT_0x9
	CALL SUBOPT_0xF
	BREQ _0x24
; 0000 01AA {
; 0000 01AB PORTA = 0x15;
	LDI  R30,LOW(21)
	OUT  0x1B,R30
; 0000 01AC }
; 0000 01AD 
; 0000 01AE ///////////////////////////////////////////////////////////////
; 0000 01AF 
; 0000 01B0 if(
_0x24:
; 0000 01B1 a == '8'&
; 0000 01B2 b == '7'&
; 0000 01B3 c == '-'&
; 0000 01B4 d == '1'&
; 0000 01B5 e == '2'&
; 0000 01B6 f == '1'&
; 0000 01B7 g == '6'
; 0000 01B8 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x10
	BREQ _0x25
; 0000 01B9 {
; 0000 01BA PORTA = 0x16;
	LDI  R30,LOW(22)
	OUT  0x1B,R30
; 0000 01BB }
; 0000 01BC 
; 0000 01BD ///////////////////////////////////////////////////////////////
; 0000 01BE 
; 0000 01BF if(
_0x25:
; 0000 01C0 a == '8'&
; 0000 01C1 b == '7'&
; 0000 01C2 c == '-'&
; 0000 01C3 d == '1'&
; 0000 01C4 e == '8'&
; 0000 01C5 f == '3'&
; 0000 01C6 g == '2'
; 0000 01C7 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x11
	BREQ _0x26
; 0000 01C8 {
; 0000 01C9 PORTA = 0x17;
	LDI  R30,LOW(23)
	OUT  0x1B,R30
; 0000 01CA }
; 0000 01CB 
; 0000 01CC ///////////////////////////////////////////////////////////////
; 0000 01CD 
; 0000 01CE if(
_0x26:
; 0000 01CF a == '8'&
; 0000 01D0 b == '7'&
; 0000 01D1 c == '-'&
; 0000 01D2 d == '2'&
; 0000 01D3 e == '1'&
; 0000 01D4 f == '7'&
; 0000 01D5 g == '4'
; 0000 01D6 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0xD
	CALL SUBOPT_0x12
	BREQ _0x27
; 0000 01D7 {
; 0000 01D8 PORTA = 0x18;
	LDI  R30,LOW(24)
	OUT  0x1B,R30
; 0000 01D9 }
; 0000 01DA 
; 0000 01DB ///////////////////////////////////////////////////////////////
; 0000 01DC 
; 0000 01DD if(
_0x27:
; 0000 01DE a == '8'&
; 0000 01DF b == '6'&
; 0000 01E0 c == '-'&
; 0000 01E1 d == '0'&
; 0000 01E2 e == '1'&
; 0000 01E3 f == '9'&
; 0000 01E4 g == '4'
; 0000 01E5 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	CALL SUBOPT_0x9
	CALL SUBOPT_0x13
	BREQ _0x28
; 0000 01E6 {
; 0000 01E7 PORTA = 0x19;
	LDI  R30,LOW(25)
	OUT  0x1B,R30
; 0000 01E8 }
; 0000 01E9 
; 0000 01EA ///////////////////////////////////////////////////////////////
; 0000 01EB 
; 0000 01EC if(
_0x28:
; 0000 01ED a == '8'&
; 0000 01EE b == '6'&
; 0000 01EF c == '-'&
; 0000 01F0 d == '1'&
; 0000 01F1 e == '3'&
; 0000 01F2 f == '4'&
; 0000 01F3 g == '1'
; 0000 01F4 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	BREQ _0x29
; 0000 01F5 {
; 0000 01F6 PORTA = 0x1A;
	LDI  R30,LOW(26)
	OUT  0x1B,R30
; 0000 01F7 }
; 0000 01F8 
; 0000 01F9 
; 0000 01FA ///////////////////////////////////////////////////////////////
; 0000 01FB 
; 0000 01FC if(
_0x29:
; 0000 01FD a == '8'&
; 0000 01FE b == '6'&
; 0000 01FF c == '-'&
; 0000 0200 d == '1'&
; 0000 0201 e == '8'&
; 0000 0202 f == '3'&
; 0000 0203 g == '3'
; 0000 0204 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x16
	LDD  R26,Y+1
	CALL SUBOPT_0x14
	CALL SUBOPT_0x17
	BREQ _0x2A
; 0000 0205 {
; 0000 0206 PORTA = 0x1B;
	LDI  R30,LOW(27)
	OUT  0x1B,R30
; 0000 0207 }
; 0000 0208 
; 0000 0209 ///////////////////////////////////////////////////////////////
; 0000 020A 
; 0000 020B if(
_0x2A:
; 0000 020C a == '8'&
; 0000 020D b == '6'&
; 0000 020E c == '-'&
; 0000 020F d == '2'&
; 0000 0210 e == '1'&
; 0000 0211 f == '8'&
; 0000 0212 g == '0'
; 0000 0213 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0xD
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
	BREQ _0x2B
; 0000 0214 {
; 0000 0215 PORTA = 0x1C;
	LDI  R30,LOW(28)
	OUT  0x1B,R30
; 0000 0216 }
; 0000 0217 
; 0000 0218 ///////////////////////////////////////////////////////////////
; 0000 0219 
; 0000 021A if(
_0x2B:
; 0000 021B a == '8'&
; 0000 021C b == '7'&
; 0000 021D c == '-'&
; 0000 021E d == '0'&
; 0000 021F e == '1'&
; 0000 0220 f == '9'&
; 0000 0221 g == '4'
; 0000 0222 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	CALL SUBOPT_0x9
	CALL SUBOPT_0x13
	BREQ _0x2C
; 0000 0223 {
; 0000 0224 PORTA = 0x1D;
	LDI  R30,LOW(29)
	OUT  0x1B,R30
; 0000 0225 }
; 0000 0226 
; 0000 0227 ///////////////////////////////////////////////////////////////
; 0000 0228 
; 0000 0229 if(
_0x2C:
; 0000 022A a == '8'&
; 0000 022B b == '7'&
; 0000 022C c == '-'&
; 0000 022D d == '1'&
; 0000 022E e == '3'&
; 0000 022F f == '4'&
; 0000 0230 g == '1'
; 0000 0231 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	BREQ _0x2D
; 0000 0232 {
; 0000 0233 PORTA = 0x1E;
	LDI  R30,LOW(30)
	OUT  0x1B,R30
; 0000 0234 }
; 0000 0235 
; 0000 0236 ///////////////////////////////////////////////////////////////
; 0000 0237 
; 0000 0238 if(
_0x2D:
; 0000 0239 a == '8'&
; 0000 023A b == '7'&
; 0000 023B c == '-'&
; 0000 023C d == '1'&
; 0000 023D e == '8'&
; 0000 023E f == '3'&
; 0000 023F g == '3'
; 0000 0240 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x16
	LDD  R26,Y+1
	CALL SUBOPT_0x14
	CALL SUBOPT_0x17
	BREQ _0x2E
; 0000 0241 {
; 0000 0242 PORTA = 0x1F;
	LDI  R30,LOW(31)
	OUT  0x1B,R30
; 0000 0243 }
; 0000 0244 
; 0000 0245 ///////////////////////////////////////////////////////////////
; 0000 0246 
; 0000 0247 if(
_0x2E:
; 0000 0248 a == '8'&
; 0000 0249 b == '7'&
; 0000 024A c == '-'&
; 0000 024B d == '2'&
; 0000 024C e == '1'&
; 0000 024D f == '8'&
; 0000 024E g == '0'
; 0000 024F )
	CALL SUBOPT_0x8
	CALL SUBOPT_0xD
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
	BREQ _0x2F
; 0000 0250 {
; 0000 0251 PORTA = 0x20;
	LDI  R30,LOW(32)
	OUT  0x1B,R30
; 0000 0252 }
; 0000 0253 
; 0000 0254 ///////////////////////////////////////////////////////////////
; 0000 0255 
; 0000 0256 if(
_0x2F:
; 0000 0257 a == '8'&
; 0000 0258 b == '6'&
; 0000 0259 c == '-'&
; 0000 025A d == '0'&
; 0000 025B e == '6'&
; 0000 025C f == '6'&
; 0000 025D g == '3'
; 0000 025E )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	CALL SUBOPT_0x19
	BREQ _0x30
; 0000 025F {
; 0000 0260 PORTA = 0x21;
	LDI  R30,LOW(33)
	OUT  0x1B,R30
; 0000 0261 }
; 0000 0262 
; 0000 0263 ///////////////////////////////////////////////////////////////
; 0000 0264 
; 0000 0265 if(
_0x30:
; 0000 0266 a == '8'&
; 0000 0267 b == '6'&
; 0000 0268 c == '-'&
; 0000 0269 d == '1'&
; 0000 026A e == '3'&
; 0000 026B f == '4'&
; 0000 026C g == '9'
; 0000 026D )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1A
	BREQ _0x31
; 0000 026E {
; 0000 026F PORTA = 0x22;
	LDI  R30,LOW(34)
	OUT  0x1B,R30
; 0000 0270 }
; 0000 0271 
; 0000 0272 ///////////////////////////////////////////////////////////////
; 0000 0273 
; 0000 0274 if(
_0x31:
; 0000 0275 a == '8'&
; 0000 0276 b == '6'&
; 0000 0277 c == '-'&
; 0000 0278 d == '1'&
; 0000 0279 e == '8'&
; 0000 027A f == '3'&
; 0000 027B g == '4'
; 0000 027C )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x16
	LDD  R26,Y+1
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1B
	BREQ _0x32
; 0000 027D {
; 0000 027E PORTA = 0x23;
	LDI  R30,LOW(35)
	OUT  0x1B,R30
; 0000 027F }
; 0000 0280 
; 0000 0281 ///////////////////////////////////////////////////////////////
; 0000 0282 
; 0000 0283 if(
_0x32:
; 0000 0284 a == '8'&
; 0000 0285 b == '6'&
; 0000 0286 c == '-'&
; 0000 0287 d == '2'&
; 0000 0288 e == '2'&
; 0000 0289 f == '0'&
; 0000 028A g == '4'
; 0000 028B )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	LDD  R26,Y+1
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1B
	BREQ _0x33
; 0000 028C {
; 0000 028D PORTA = 0x24;
	LDI  R30,LOW(36)
	OUT  0x1B,R30
; 0000 028E }
; 0000 028F 
; 0000 0290 ///////////////////////////////////////////////////////////////
; 0000 0291 
; 0000 0292 if(
_0x33:
; 0000 0293 a == '8'&
; 0000 0294 b == '7'&
; 0000 0295 c == '-'&
; 0000 0296 d == '0'&
; 0000 0297 e == '6'&
; 0000 0298 f == '6'&
; 0000 0299 g == '3'
; 0000 029A )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	CALL SUBOPT_0x19
	BREQ _0x34
; 0000 029B {
; 0000 029C PORTA = 0x25;
	LDI  R30,LOW(37)
	OUT  0x1B,R30
; 0000 029D }
; 0000 029E 
; 0000 029F ///////////////////////////////////////////////////////////////
; 0000 02A0 
; 0000 02A1 if(
_0x34:
; 0000 02A2 a == '8'&
; 0000 02A3 b == '7'&
; 0000 02A4 c == '-'&
; 0000 02A5 d == '1'&
; 0000 02A6 e == '3'&
; 0000 02A7 f == '4'&
; 0000 02A8 g == '9'
; 0000 02A9 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1A
	BREQ _0x35
; 0000 02AA {
; 0000 02AB PORTA = 0x26;
	LDI  R30,LOW(38)
	OUT  0x1B,R30
; 0000 02AC }
; 0000 02AD 
; 0000 02AE ///////////////////////////////////////////////////////////////
; 0000 02AF 
; 0000 02B0 if(
_0x35:
; 0000 02B1 a == '8'&
; 0000 02B2 b == '7'&
; 0000 02B3 c == '-'&
; 0000 02B4 d == '1'&
; 0000 02B5 e == '8'&
; 0000 02B6 f == '3'&
; 0000 02B7 g == '4'
; 0000 02B8 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x16
	LDD  R26,Y+1
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1B
	BREQ _0x36
; 0000 02B9 {
; 0000 02BA PORTA = 0x27;
	LDI  R30,LOW(39)
	OUT  0x1B,R30
; 0000 02BB }
; 0000 02BC 
; 0000 02BD ///////////////////////////////////////////////////////////////
; 0000 02BE 
; 0000 02BF if(
_0x36:
; 0000 02C0 a == '8'&
; 0000 02C1 b == '7'&
; 0000 02C2 c == '-'&
; 0000 02C3 d == '2'&
; 0000 02C4 e == '2'&
; 0000 02C5 f == '0'&
; 0000 02C6 g == '4'
; 0000 02C7 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	LDD  R26,Y+1
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1B
	BREQ _0x37
; 0000 02C8 {
; 0000 02C9 PORTA = 0x28;
	LDI  R30,LOW(40)
	OUT  0x1B,R30
; 0000 02CA }
; 0000 02CB 
; 0000 02CC ///////////////////////////////////////////////////////////////
; 0000 02CD 
; 0000 02CE if(
_0x37:
; 0000 02CF a == '8'&
; 0000 02D0 b == '6'&
; 0000 02D1 c == '-'&
; 0000 02D2 d == '0'&
; 0000 02D3 e == '7'&
; 0000 02D4 f == '6'&
; 0000 02D5 g == '8'
; 0000 02D6 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1D
	BREQ _0x38
; 0000 02D7 {
; 0000 02D8 PORTA = 0x29;
	LDI  R30,LOW(41)
	OUT  0x1B,R30
; 0000 02D9 }
; 0000 02DA 
; 0000 02DB ///////////////////////////////////////////////////////////////
; 0000 02DC 
; 0000 02DD if(
_0x38:
; 0000 02DE a == '8'&
; 0000 02DF b == '6'&
; 0000 02E0 c == '-'&
; 0000 02E1 d == '1'&
; 0000 02E2 e == '3'&
; 0000 02E3 f == '5'&
; 0000 02E4 g == '7'
; 0000 02E5 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1E
	BREQ _0x39
; 0000 02E6 {
; 0000 02E7 PORTA = 0x2A;
	LDI  R30,LOW(42)
	OUT  0x1B,R30
; 0000 02E8 }
; 0000 02E9 
; 0000 02EA ///////////////////////////////////////////////////////////////
; 0000 02EB 
; 0000 02EC if(
_0x39:
; 0000 02ED a == '8'&
; 0000 02EE b == '6'&
; 0000 02EF c == '-'&
; 0000 02F0 d == '1'&
; 0000 02F1 e == '8'&
; 0000 02F2 f == '4'&
; 0000 02F3 g == '8'
; 0000 02F4 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1F
	BREQ _0x3A
; 0000 02F5 {
; 0000 02F6 PORTA = 0x2B;
	LDI  R30,LOW(43)
	OUT  0x1B,R30
; 0000 02F7 }
; 0000 02F8 
; 0000 02F9 
; 0000 02FA ///////////////////////////////////////////////////////////////
; 0000 02FB 
; 0000 02FC if(
_0x3A:
; 0000 02FD a == '8'&
; 0000 02FE b == '6'&
; 0000 02FF c == '-'&
; 0000 0300 d == '2'&
; 0000 0301 e == '2'&
; 0000 0302 f == '1'&
; 0000 0303 g == '2'
; 0000 0304 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x20
	BREQ _0x3B
; 0000 0305 {
; 0000 0306 PORTA = 0x2C;
	LDI  R30,LOW(44)
	OUT  0x1B,R30
; 0000 0307 }
; 0000 0308 
; 0000 0309 ///////////////////////////////////////////////////////////////
; 0000 030A 
; 0000 030B if(
_0x3B:
; 0000 030C a == '8'&
; 0000 030D b == '7'&
; 0000 030E c == '-'&
; 0000 030F d == '0'&
; 0000 0310 e == '7'&
; 0000 0311 f == '6'&
; 0000 0312 g == '8'
; 0000 0313 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1D
	BREQ _0x3C
; 0000 0314 {
; 0000 0315 PORTA = 0x2D;
	LDI  R30,LOW(45)
	OUT  0x1B,R30
; 0000 0316 }
; 0000 0317 
; 0000 0318 ///////////////////////////////////////////////////////////////
; 0000 0319 
; 0000 031A if(
_0x3C:
; 0000 031B a == '8'&
; 0000 031C b == '7'&
; 0000 031D c == '-'&
; 0000 031E d == '1'&
; 0000 031F e == '3'&
; 0000 0320 f == '5'&
; 0000 0321 g == '7'
; 0000 0322 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1E
	BREQ _0x3D
; 0000 0323 {
; 0000 0324 PORTA = 0x2E;
	LDI  R30,LOW(46)
	OUT  0x1B,R30
; 0000 0325 }
; 0000 0326 
; 0000 0327 ///////////////////////////////////////////////////////////////
; 0000 0328 
; 0000 0329 if(
_0x3D:
; 0000 032A a == '8'&
; 0000 032B b == '7'&
; 0000 032C c == '-'&
; 0000 032D d == '1'&
; 0000 032E e == '8'&
; 0000 032F f == '4'&
; 0000 0330 g == '8'
; 0000 0331 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1F
	BREQ _0x3E
; 0000 0332 {
; 0000 0333 PORTA = 0x2F;
	LDI  R30,LOW(47)
	OUT  0x1B,R30
; 0000 0334 }
; 0000 0335 
; 0000 0336 ///////////////////////////////////////////////////////////////
; 0000 0337 
; 0000 0338 if(
_0x3E:
; 0000 0339 a == '8'&
; 0000 033A b == '7'&
; 0000 033B c == '-'&
; 0000 033C d == '2'&
; 0000 033D e == '2'&
; 0000 033E f == '1'&
; 0000 033F g == '2'
; 0000 0340 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x20
	BREQ _0x3F
; 0000 0341 {
; 0000 0342 PORTA = 0x30;
	LDI  R30,LOW(48)
	OUT  0x1B,R30
; 0000 0343 }
; 0000 0344 
; 0000 0345 ///////////////////////////////////////////////////////////////
; 0000 0346 
; 0000 0347 if(
_0x3F:
; 0000 0348 a == '8'&
; 0000 0349 b == '6'&
; 0000 034A c == '-'&
; 0000 034B d == '0'&
; 0000 034C e == '8'&
; 0000 034D f == '0'&
; 0000 034E g == '0'
; 0000 034F )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	LDD  R26,Y+1
	CALL SUBOPT_0x1
	CALL SUBOPT_0x18
	BREQ _0x40
; 0000 0350 {
; 0000 0351 PORTA = 0x31;
	LDI  R30,LOW(49)
	OUT  0x1B,R30
; 0000 0352 }
; 0000 0353 
; 0000 0354 ///////////////////////////////////////////////////////////////
; 0000 0355 
; 0000 0356 if(
_0x40:
; 0000 0357 a == '8'&
; 0000 0358 b == '6'&
; 0000 0359 c == '-'&
; 0000 035A d == '1'&
; 0000 035B e == '3'&
; 0000 035C f == '6'&
; 0000 035D g == '3'
; 0000 035E )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x14
	CALL SUBOPT_0x21
	BREQ _0x41
; 0000 035F {
; 0000 0360 PORTA = 0x32;
	LDI  R30,LOW(50)
	OUT  0x1B,R30
; 0000 0361 }
; 0000 0362 
; 0000 0363 ///////////////////////////////////////////////////////////////
; 0000 0364 
; 0000 0365 if(
_0x41:
; 0000 0366 a == '8'&
; 0000 0367 b == '6'&
; 0000 0368 c == '-'&
; 0000 0369 d == '1'&
; 0000 036A e == '9'&
; 0000 036B f == '0'&
; 0000 036C g == '4'
; 0000 036D )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1B
	BREQ _0x42
; 0000 036E {
; 0000 036F PORTA = 0x33;
	LDI  R30,LOW(51)
	OUT  0x1B,R30
; 0000 0370 }
; 0000 0371 
; 0000 0372 ///////////////////////////////////////////////////////////////
; 0000 0373 
; 0000 0374 if(
_0x42:
; 0000 0375 a == '8'&
; 0000 0376 b == '6'&
; 0000 0377 c == '-'&
; 0000 0378 d == '2'&
; 0000 0379 e == '2'&
; 0000 037A f == '4'&
; 0000 037B g == '1'
; 0000 037C )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x15
	BREQ _0x43
; 0000 037D {
; 0000 037E PORTA = 0x34;
	LDI  R30,LOW(52)
	OUT  0x1B,R30
; 0000 037F }
; 0000 0380 
; 0000 0381 ///////////////////////////////////////////////////////////////
; 0000 0382 
; 0000 0383 if(
_0x43:
; 0000 0384 a == '8'&
; 0000 0385 b == '7'&
; 0000 0386 c == '-'&
; 0000 0387 d == '0'&
; 0000 0388 e == '8'&
; 0000 0389 f == '0'&
; 0000 038A g == '0'
; 0000 038B )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	LDD  R26,Y+1
	CALL SUBOPT_0x1
	CALL SUBOPT_0x18
	BREQ _0x44
; 0000 038C {
; 0000 038D PORTA = 0x35;
	LDI  R30,LOW(53)
	OUT  0x1B,R30
; 0000 038E }
; 0000 038F 
; 0000 0390 
; 0000 0391 ///////////////////////////////////////////////////////////////
; 0000 0392 
; 0000 0393 if(
_0x44:
; 0000 0394 a == '8'&
; 0000 0395 b == '7'&
; 0000 0396 c == '-'&
; 0000 0397 d == '1'&
; 0000 0398 e == '3'&
; 0000 0399 f == '6'&
; 0000 039A g == '3'
; 0000 039B )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x14
	CALL SUBOPT_0x21
	BREQ _0x45
; 0000 039C {
; 0000 039D PORTA = 0x36;
	LDI  R30,LOW(54)
	OUT  0x1B,R30
; 0000 039E }
; 0000 039F 
; 0000 03A0 ///////////////////////////////////////////////////////////////
; 0000 03A1 
; 0000 03A2 if(
_0x45:
; 0000 03A3 a == '8'&
; 0000 03A4 b == '7'&
; 0000 03A5 c == '-'&
; 0000 03A6 d == '1'&
; 0000 03A7 e == '9'&
; 0000 03A8 f == '0'&
; 0000 03A9 g == '4'
; 0000 03AA )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1B
	BREQ _0x46
; 0000 03AB {
; 0000 03AC PORTA = 0x37;
	LDI  R30,LOW(55)
	OUT  0x1B,R30
; 0000 03AD }
; 0000 03AE 
; 0000 03AF ///////////////////////////////////////////////////////////////
; 0000 03B0 
; 0000 03B1 if(
_0x46:
; 0000 03B2 a == '8'&
; 0000 03B3 b == '7'&
; 0000 03B4 c == '-'&
; 0000 03B5 d == '2'&
; 0000 03B6 e == '2'&
; 0000 03B7 f == '4'&
; 0000 03B8 g == '1'
; 0000 03B9 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x15
	BREQ _0x47
; 0000 03BA {
; 0000 03BB PORTA = 0x38;
	LDI  R30,LOW(56)
	OUT  0x1B,R30
; 0000 03BC }
; 0000 03BD 
; 0000 03BE 
; 0000 03BF 
; 0000 03C0 
; 0000 03C1 ///////////////////////////////////////////////////////////////
; 0000 03C2 
; 0000 03C3 if(
_0x47:
; 0000 03C4 a == '8'&
; 0000 03C5 b == '6'&
; 0000 03C6 c == '-'&
; 0000 03C7 d == '0'&
; 0000 03C8 e == '8'&
; 0000 03C9 f == '1'&
; 0000 03CA g == '1'
; 0000 03CB )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x23
	BREQ _0x48
; 0000 03CC {
; 0000 03CD PORTA = 0x39;
	LDI  R30,LOW(57)
	OUT  0x1B,R30
; 0000 03CE }
; 0000 03CF 
; 0000 03D0 ///////////////////////////////////////////////////////////////
; 0000 03D1 
; 0000 03D2 if(
_0x48:
; 0000 03D3 a == '8'&
; 0000 03D4 b == '6'&
; 0000 03D5 c == '-'&
; 0000 03D6 d == '1'&
; 0000 03D7 e == '5'&
; 0000 03D8 f == '2'&
; 0000 03D9 g == '3'
; 0000 03DA )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x24
	CALL SUBOPT_0x17
	BREQ _0x49
; 0000 03DB {
; 0000 03DC PORTA = 0x3A;
	LDI  R30,LOW(58)
	OUT  0x1B,R30
; 0000 03DD }
; 0000 03DE 
; 0000 03DF ///////////////////////////////////////////////////////////////
; 0000 03E0 
; 0000 03E1 if(
_0x49:
; 0000 03E2 a == '8'&
; 0000 03E3 b == '6'&
; 0000 03E4 c == '-'&
; 0000 03E5 d == '1'&
; 0000 03E6 e == '9'&
; 0000 03E7 f == '2'&
; 0000 03E8 g == '9'
; 0000 03E9 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	BREQ _0x4A
; 0000 03EA {
; 0000 03EB PORTA = 0x3B;
	LDI  R30,LOW(59)
	OUT  0x1B,R30
; 0000 03EC }
; 0000 03ED 
; 0000 03EE ///////////////////////////////////////////////////////////////
; 0000 03EF 
; 0000 03F0 if(
_0x4A:
; 0000 03F1 a == '8'&
; 0000 03F2 b == '6'&
; 0000 03F3 c == '-'&
; 0000 03F4 d == '2'&
; 0000 03F5 e == '2'&
; 0000 03F6 f == '6'&
; 0000 03F7 g == '1'
; 0000 03F8 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x27
	BREQ _0x4B
; 0000 03F9 {
; 0000 03FA PORTA = 0x3C;
	LDI  R30,LOW(60)
	OUT  0x1B,R30
; 0000 03FB }
; 0000 03FC 
; 0000 03FD ///////////////////////////////////////////////////////////////
; 0000 03FE 
; 0000 03FF if(
_0x4B:
; 0000 0400 a == '8'&
; 0000 0401 b == '7'&
; 0000 0402 c == '-'&
; 0000 0403 d == '0'&
; 0000 0404 e == '8'&
; 0000 0405 f == '1'&
; 0000 0406 g == '1'
; 0000 0407 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x23
	BREQ _0x4C
; 0000 0408 {
; 0000 0409 PORTA = 0x3D;
	LDI  R30,LOW(61)
	OUT  0x1B,R30
; 0000 040A }
; 0000 040B 
; 0000 040C ///////////////////////////////////////////////////////////////
; 0000 040D 
; 0000 040E if(
_0x4C:
; 0000 040F a == '8'&
; 0000 0410 b == '7'&
; 0000 0411 c == '-'&
; 0000 0412 d == '1'&
; 0000 0413 e == '5'&
; 0000 0414 f == '2'&
; 0000 0415 g == '3'
; 0000 0416 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x24
	CALL SUBOPT_0x17
	BREQ _0x4D
; 0000 0417 {
; 0000 0418 PORTA = 0x3E;
	LDI  R30,LOW(62)
	OUT  0x1B,R30
; 0000 0419 }
; 0000 041A 
; 0000 041B 
; 0000 041C ///////////////////////////////////////////////////////////////
; 0000 041D 
; 0000 041E if(
_0x4D:
; 0000 041F a == '8'&
; 0000 0420 b == '7'&
; 0000 0421 c == '-'&
; 0000 0422 d == '1'&
; 0000 0423 e == '9'&
; 0000 0424 f == '2'&
; 0000 0425 g == '9'
; 0000 0426 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	BREQ _0x4E
; 0000 0427 {
; 0000 0428 PORTA = 0x3F;
	LDI  R30,LOW(63)
	OUT  0x1B,R30
; 0000 0429 }
; 0000 042A 
; 0000 042B 
; 0000 042C ///////////////////////////////////////////////////////////////
; 0000 042D 
; 0000 042E if(
_0x4E:
; 0000 042F a == '8'&
; 0000 0430 b == '7'&
; 0000 0431 c == '-'&
; 0000 0432 d == '2'&
; 0000 0433 e == '2'&
; 0000 0434 f == '6'&
; 0000 0435 g == '1'
; 0000 0436 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x27
	BREQ _0x4F
; 0000 0437 {
; 0000 0438 PORTA = 0x40;
	LDI  R30,LOW(64)
	OUT  0x1B,R30
; 0000 0439 }
; 0000 043A 
; 0000 043B ///////////////////////////////////////////////////////////////
; 0000 043C 
; 0000 043D if(
_0x4F:
; 0000 043E a == '8'&
; 0000 043F b == '6'&
; 0000 0440 c == '-'&
; 0000 0441 d == '0'&
; 0000 0442 e == '8'&
; 0000 0443 f == '1'&
; 0000 0444 g == '4'
; 0000 0445 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x28
	BREQ _0x50
; 0000 0446 {
; 0000 0447 PORTA = 0x41;
	LDI  R30,LOW(65)
	OUT  0x1B,R30
; 0000 0448 }
; 0000 0449 
; 0000 044A ///////////////////////////////////////////////////////////////
; 0000 044B 
; 0000 044C if(
_0x50:
; 0000 044D a == '8'&
; 0000 044E b == '6'&
; 0000 044F c == '-'&
; 0000 0450 d == '1'&
; 0000 0451 e == '5'&
; 0000 0452 f == '3'&
; 0000 0453 g == '0'
; 0000 0454 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x29
	CALL SUBOPT_0x18
	BREQ _0x51
; 0000 0455 {
; 0000 0456 PORTA = 0x42;
	LDI  R30,LOW(66)
	OUT  0x1B,R30
; 0000 0457 }
; 0000 0458 
; 0000 0459 ///////////////////////////////////////////////////////////////
; 0000 045A 
; 0000 045B if(
_0x51:
; 0000 045C a == '8'&
; 0000 045D b == '6'&
; 0000 045E c == '-'&
; 0000 045F d == '1'&
; 0000 0460 e == '9'&
; 0000 0461 f == '3'&
; 0000 0462 g == '6'
; 0000 0463 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	BREQ _0x52
; 0000 0464 {
; 0000 0465 PORTA = 0x43;
	LDI  R30,LOW(67)
	OUT  0x1B,R30
; 0000 0466 }
; 0000 0467 
; 0000 0468 ///////////////////////////////////////////////////////////////
; 0000 0469 
; 0000 046A if(
_0x52:
; 0000 046B a == '8'&
; 0000 046C b == '6'&
; 0000 046D c == '-'&
; 0000 046E d == '2'&
; 0000 046F e == '2'&
; 0000 0470 f == '8'&
; 0000 0471 g == '5'
; 0000 0472 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2C
	BREQ _0x53
; 0000 0473 {
; 0000 0474 PORTA = 0x44;
	LDI  R30,LOW(68)
	OUT  0x1B,R30
; 0000 0475 }
; 0000 0476 
; 0000 0477 ///////////////////////////////////////////////////////////////
; 0000 0478 
; 0000 0479 if(
_0x53:
; 0000 047A a == '8'&
; 0000 047B b == '7'&
; 0000 047C c == '-'&
; 0000 047D d == '0'&
; 0000 047E e == '8'&
; 0000 047F f == '1'&
; 0000 0480 g == '4'
; 0000 0481 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x28
	BREQ _0x54
; 0000 0482 {
; 0000 0483 PORTA = 0x45;
	LDI  R30,LOW(69)
	OUT  0x1B,R30
; 0000 0484 }
; 0000 0485 
; 0000 0486 ///////////////////////////////////////////////////////////////
; 0000 0487 
; 0000 0488 if(
_0x54:
; 0000 0489 a == '8'&
; 0000 048A b == '7'&
; 0000 048B c == '-'&
; 0000 048C d == '1'&
; 0000 048D e == '5'&
; 0000 048E f == '3'&
; 0000 048F g == '0'
; 0000 0490 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x29
	CALL SUBOPT_0x18
	BREQ _0x55
; 0000 0491 {
; 0000 0492 PORTA = 0x46;
	LDI  R30,LOW(70)
	OUT  0x1B,R30
; 0000 0493 }
; 0000 0494 
; 0000 0495 ///////////////////////////////////////////////////////////////
; 0000 0496 
; 0000 0497 if(
_0x55:
; 0000 0498 a == '8'&
; 0000 0499 b == '7'&
; 0000 049A c == '-'&
; 0000 049B d == '1'&
; 0000 049C e == '9'&
; 0000 049D f == '3'&
; 0000 049E g == '6'
; 0000 049F )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	BREQ _0x56
; 0000 04A0 {
; 0000 04A1 PORTA = 0x47;
	LDI  R30,LOW(71)
	OUT  0x1B,R30
; 0000 04A2 }
; 0000 04A3 
; 0000 04A4 ///////////////////////////////////////////////////////////////
; 0000 04A5 
; 0000 04A6 if(
_0x56:
; 0000 04A7 a == '8'&
; 0000 04A8 b == '7'&
; 0000 04A9 c == '-'&
; 0000 04AA d == '2'&
; 0000 04AB e == '2'&
; 0000 04AC f == '8'&
; 0000 04AD g == '5'
; 0000 04AE )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2C
	BREQ _0x57
; 0000 04AF {
; 0000 04B0 PORTA = 0x48;
	LDI  R30,LOW(72)
	OUT  0x1B,R30
; 0000 04B1 }
; 0000 04B2 
; 0000 04B3 ///////////////////////////////////////////////////////////////
; 0000 04B4 
; 0000 04B5 if(
_0x57:
; 0000 04B6 a == '8'&
; 0000 04B7 b == '6'&
; 0000 04B8 c == '-'&
; 0000 04B9 d == '0'&
; 0000 04BA e == '8'&
; 0000 04BB f == '1'&
; 0000 04BC g == '5'
; 0000 04BD )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2D
	BREQ _0x58
; 0000 04BE {
; 0000 04BF PORTA = 0x49;
	LDI  R30,LOW(73)
	OUT  0x1B,R30
; 0000 04C0 }
; 0000 04C1 
; 0000 04C2 ///////////////////////////////////////////////////////////////
; 0000 04C3 
; 0000 04C4 if(
_0x58:
; 0000 04C5 a == '8'&
; 0000 04C6 b == '6'&
; 0000 04C7 c == '-'&
; 0000 04C8 d == '1'&
; 0000 04C9 e == '5'&
; 0000 04CA f == '5'&
; 0000 04CB g == '1'
; 0000 04CC )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x2E
	LDD  R26,Y+1
	CALL SUBOPT_0x2E
	LD   R26,Y
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x59
; 0000 04CD {
; 0000 04CE PORTA = 0x4A;
	LDI  R30,LOW(74)
	OUT  0x1B,R30
; 0000 04CF }
; 0000 04D0 
; 0000 04D1 ///////////////////////////////////////////////////////////////
; 0000 04D2 
; 0000 04D3 if(
_0x59:
; 0000 04D4 a == '8'&
; 0000 04D5 b == '6'&
; 0000 04D6 c == '-'&
; 0000 04D7 d == '1'&
; 0000 04D8 e == '9'&
; 0000 04D9 f == '4'&
; 0000 04DA g == '1'
; 0000 04DB )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x2F
	BREQ _0x5A
; 0000 04DC {
; 0000 04DD PORTA = 0x4B;
	LDI  R30,LOW(75)
	OUT  0x1B,R30
; 0000 04DE }
; 0000 04DF 
; 0000 04E0 ///////////////////////////////////////////////////////////////
; 0000 04E1 
; 0000 04E2 if(
_0x5A:
; 0000 04E3 a == '8'&
; 0000 04E4 b == '6'&
; 0000 04E5 c == '-'&
; 0000 04E6 d == '2'&
; 0000 04E7 e == '2'&
; 0000 04E8 f == '8'&
; 0000 04E9 g == '6'
; 0000 04EA )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2B
	BREQ _0x5B
; 0000 04EB {
; 0000 04EC PORTA = 0x4C;
	LDI  R30,LOW(76)
	OUT  0x1B,R30
; 0000 04ED }
; 0000 04EE 
; 0000 04EF ///////////////////////////////////////////////////////////////
; 0000 04F0 
; 0000 04F1 if(
_0x5B:
; 0000 04F2 a == '8'&
; 0000 04F3 b == '7'&
; 0000 04F4 c == '-'&
; 0000 04F5 d == '0'&
; 0000 04F6 e == '8'&
; 0000 04F7 f == '1'&
; 0000 04F8 g == '5'
; 0000 04F9 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2D
	BREQ _0x5C
; 0000 04FA {
; 0000 04FB PORTA = 0x4D;
	LDI  R30,LOW(77)
	OUT  0x1B,R30
; 0000 04FC }
; 0000 04FD 
; 0000 04FE ///////////////////////////////////////////////////////////////
; 0000 04FF 
; 0000 0500 if(
_0x5C:
; 0000 0501 a == '8'&
; 0000 0502 b == '7'&
; 0000 0503 c == '-'&
; 0000 0504 d == '1'&
; 0000 0505 e == '5'&
; 0000 0506 f == '5'&
; 0000 0507 g == '1'
; 0000 0508 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x2E
	LDD  R26,Y+1
	CALL SUBOPT_0x2E
	LD   R26,Y
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x5D
; 0000 0509 {
; 0000 050A PORTA = 0x4E;
	LDI  R30,LOW(78)
	OUT  0x1B,R30
; 0000 050B }
; 0000 050C 
; 0000 050D ///////////////////////////////////////////////////////////////
; 0000 050E 
; 0000 050F if(
_0x5D:
; 0000 0510 a == '8'&
; 0000 0511 b == '7'&
; 0000 0512 c == '-'&
; 0000 0513 d == '1'&
; 0000 0514 e == '9'&
; 0000 0515 f == '4'&
; 0000 0516 g == '1'
; 0000 0517 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x2F
	BREQ _0x5E
; 0000 0518 {
; 0000 0519 PORTA = 0x4F;
	LDI  R30,LOW(79)
	OUT  0x1B,R30
; 0000 051A }
; 0000 051B 
; 0000 051C ///////////////////////////////////////////////////////////////
; 0000 051D 
; 0000 051E if(
_0x5E:
; 0000 051F a == '8'&
; 0000 0520 b == '7'&
; 0000 0521 c == '-'&
; 0000 0522 d == '2'&
; 0000 0523 e == '2'&
; 0000 0524 f == '8'&
; 0000 0525 g == '6'
; 0000 0526 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2B
	BREQ _0x5F
; 0000 0527 {
; 0000 0528 PORTA = 0x50;
	LDI  R30,LOW(80)
	OUT  0x1B,R30
; 0000 0529 }
; 0000 052A 
; 0000 052B ///////////////////////////////////////////////////////////////
; 0000 052C 
; 0000 052D if(
_0x5F:
; 0000 052E a == '8'&
; 0000 052F b == '6'&
; 0000 0530 c == '-'&
; 0000 0531 d == '0'&
; 0000 0532 e == '8'&
; 0000 0533 f == '1'&
; 0000 0534 g == '6'
; 0000 0535 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x30
	BREQ _0x60
; 0000 0536 {
; 0000 0537 PORTA = 0x51;
	LDI  R30,LOW(81)
	OUT  0x1B,R30
; 0000 0538 }
; 0000 0539 
; 0000 053A ///////////////////////////////////////////////////////////////
; 0000 053B 
; 0000 053C if(
_0x60:
; 0000 053D a == '8'&
; 0000 053E b == '6'&
; 0000 053F c == '-'&
; 0000 0540 d == '1'&
; 0000 0541 e == '5'&
; 0000 0542 f == '5'&
; 0000 0543 g == '2'
; 0000 0544 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x2E
	LDD  R26,Y+1
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x31
	BREQ _0x61
; 0000 0545 {
; 0000 0546 PORTA = 0x52;
	LDI  R30,LOW(82)
	OUT  0x1B,R30
; 0000 0547 }
; 0000 0548 
; 0000 0549 ///////////////////////////////////////////////////////////////
; 0000 054A 
; 0000 054B if(
_0x61:
; 0000 054C a == '8'&
; 0000 054D b == '6'&
; 0000 054E c == '-'&
; 0000 054F d == '2'&
; 0000 0550 e == '0'&
; 0000 0551 f == '0'&
; 0000 0552 g == '7'
; 0000 0553 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x6
	LDD  R26,Y+1
	CALL SUBOPT_0x1
	CALL SUBOPT_0x32
	BREQ _0x62
; 0000 0554 {
; 0000 0555 PORTA = 0x53;
	LDI  R30,LOW(83)
	OUT  0x1B,R30
; 0000 0556 }
; 0000 0557 
; 0000 0558 ///////////////////////////////////////////////////////////////
; 0000 0559 
; 0000 055A if(
_0x62:
; 0000 055B a == '8'&
; 0000 055C b == '6'&
; 0000 055D c == '-'&
; 0000 055E d == '2'&
; 0000 055F e == '2'&
; 0000 0560 f == '9'&
; 0000 0561 g == '2'
; 0000 0562 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	LDD  R26,Y+1
	CALL SUBOPT_0xA
	BREQ _0x63
; 0000 0563 {
; 0000 0564 PORTA = 0x54;
	LDI  R30,LOW(84)
	OUT  0x1B,R30
; 0000 0565 }
; 0000 0566 
; 0000 0567 ///////////////////////////////////////////////////////////////
; 0000 0568 
; 0000 0569 if(
_0x63:
; 0000 056A a == '8'&
; 0000 056B b == '7'&
; 0000 056C c == '-'&
; 0000 056D d == '0'&
; 0000 056E e == '8'&
; 0000 056F f == '1'&
; 0000 0570 g == '6'
; 0000 0571 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x30
	BREQ _0x64
; 0000 0572 {
; 0000 0573 PORTA = 0x55;
	LDI  R30,LOW(85)
	OUT  0x1B,R30
; 0000 0574 }
; 0000 0575 
; 0000 0576 ///////////////////////////////////////////////////////////////
; 0000 0577 
; 0000 0578 if(
_0x64:
; 0000 0579 a == '8'&
; 0000 057A b == '7'&
; 0000 057B c == '-'&
; 0000 057C d == '1'&
; 0000 057D e == '5'&
; 0000 057E f == '5'&
; 0000 057F g == '2'
; 0000 0580 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x2E
	LDD  R26,Y+1
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x31
	BREQ _0x65
; 0000 0581 {
; 0000 0582 PORTA = 0x56;
	LDI  R30,LOW(86)
	OUT  0x1B,R30
; 0000 0583 }
; 0000 0584 
; 0000 0585 ///////////////////////////////////////////////////////////////
; 0000 0586 
; 0000 0587 if(
_0x65:
; 0000 0588 a == '8'&
; 0000 0589 b == '7'&
; 0000 058A c == '-'&
; 0000 058B d == '2'&
; 0000 058C e == '0'&
; 0000 058D f == '0'&
; 0000 058E g == '7'
; 0000 058F )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x6
	LDD  R26,Y+1
	CALL SUBOPT_0x1
	CALL SUBOPT_0x32
	BREQ _0x66
; 0000 0590 {
; 0000 0591 PORTA = 0x57;
	LDI  R30,LOW(87)
	OUT  0x1B,R30
; 0000 0592 }
; 0000 0593 
; 0000 0594 ///////////////////////////////////////////////////////////////
; 0000 0595 
; 0000 0596 if(
_0x66:
; 0000 0597 a == '8'&
; 0000 0598 b == '7'&
; 0000 0599 c == '-'&
; 0000 059A d == '2'&
; 0000 059B e == '2'&
; 0000 059C f == '9'&
; 0000 059D g == '2'
; 0000 059E )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x1C
	LDD  R26,Y+1
	CALL SUBOPT_0xA
	BREQ _0x67
; 0000 059F {
; 0000 05A0 PORTA = 0x58;
	LDI  R30,LOW(88)
	OUT  0x1B,R30
; 0000 05A1 }
; 0000 05A2 
; 0000 05A3 ///////////////////////////////////////////////////////////////
; 0000 05A4 
; 0000 05A5 if(
_0x67:
; 0000 05A6 a == '8'&
; 0000 05A7 b == '6'&
; 0000 05A8 c == '-'&
; 0000 05A9 d == '0'&
; 0000 05AA e == '8'&
; 0000 05AB f == '1'&
; 0000 05AC g == '7'
; 0000 05AD )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x33
	BREQ _0x68
; 0000 05AE {
; 0000 05AF PORTA = 0x59;
	LDI  R30,LOW(89)
	OUT  0x1B,R30
; 0000 05B0 }
; 0000 05B1 
; 0000 05B2 ///////////////////////////////////////////////////////////////
; 0000 05B3 
; 0000 05B4 if(
_0x68:
; 0000 05B5 a == '8'&
; 0000 05B6 b == '6'&
; 0000 05B7 c == '-'&
; 0000 05B8 d == '1'&
; 0000 05B9 e == '6'&
; 0000 05BA f == '0'&
; 0000 05BB g == '2'
; 0000 05BC )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x34
	CALL SUBOPT_0x31
	BREQ _0x69
; 0000 05BD {
; 0000 05BE PORTA = 0x5A;
	LDI  R30,LOW(90)
	OUT  0x1B,R30
; 0000 05BF }
; 0000 05C0 
; 0000 05C1 ///////////////////////////////////////////////////////////////
; 0000 05C2 
; 0000 05C3 if(
_0x69:
; 0000 05C4 a == '8'&
; 0000 05C5 b == '6'&
; 0000 05C6 c == '-'&
; 0000 05C7 d == '2'&
; 0000 05C8 e == '0'&
; 0000 05C9 f == '1'&
; 0000 05CA g == '7'
; 0000 05CB )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x6
	CALL SUBOPT_0x33
	BREQ _0x6A
; 0000 05CC {
; 0000 05CD PORTA = 0x5B;
	LDI  R30,LOW(91)
	OUT  0x1B,R30
; 0000 05CE }
; 0000 05CF 
; 0000 05D0 
; 0000 05D1 ///////////////////////////////////////////////////////////////
; 0000 05D2 
; 0000 05D3 if(
_0x6A:
; 0000 05D4 a == '8'&
; 0000 05D5 b == '6'&
; 0000 05D6 c == '-'&
; 0000 05D7 d == '2'&
; 0000 05D8 e == '3'&
; 0000 05D9 f == '8'&
; 0000 05DA g == '4'
; 0000 05DB )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x14
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1B
	BREQ _0x6B
; 0000 05DC {
; 0000 05DD PORTA = 0x5C;
	LDI  R30,LOW(92)
	OUT  0x1B,R30
; 0000 05DE }
; 0000 05DF 
; 0000 05E0 ///////////////////////////////////////////////////////////////
; 0000 05E1 
; 0000 05E2 if(
_0x6B:
; 0000 05E3 a == '8'&
; 0000 05E4 b == '7'&
; 0000 05E5 c == '-'&
; 0000 05E6 d == '0'&
; 0000 05E7 e == '8'&
; 0000 05E8 f == '1'&
; 0000 05E9 g == '7'
; 0000 05EA )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x33
	BREQ _0x6C
; 0000 05EB {
; 0000 05EC PORTA = 0x5D;
	LDI  R30,LOW(93)
	OUT  0x1B,R30
; 0000 05ED }
; 0000 05EE 
; 0000 05EF ///////////////////////////////////////////////////////////////
; 0000 05F0 
; 0000 05F1 if(
_0x6C:
; 0000 05F2 a == '8'&
; 0000 05F3 b == '7'&
; 0000 05F4 c == '-'&
; 0000 05F5 d == '1'&
; 0000 05F6 e == '6'&
; 0000 05F7 f == '0'&
; 0000 05F8 g == '2'
; 0000 05F9 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x34
	CALL SUBOPT_0x31
	BREQ _0x6D
; 0000 05FA {
; 0000 05FB PORTA = 0x5E;
	LDI  R30,LOW(94)
	OUT  0x1B,R30
; 0000 05FC }
; 0000 05FD 
; 0000 05FE ///////////////////////////////////////////////////////////////
; 0000 05FF 
; 0000 0600 if(
_0x6D:
; 0000 0601 a == '8'&
; 0000 0602 b == '7'&
; 0000 0603 c == '-'&
; 0000 0604 d == '2'&
; 0000 0605 e == '0'&
; 0000 0606 f == '1'&
; 0000 0607 g == '7'
; 0000 0608 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x6
	CALL SUBOPT_0x33
	BREQ _0x6E
; 0000 0609 {
; 0000 060A PORTA = 0x5F;
	LDI  R30,LOW(95)
	OUT  0x1B,R30
; 0000 060B }
; 0000 060C 
; 0000 060D ///////////////////////////////////////////////////////////////
; 0000 060E 
; 0000 060F if(
_0x6E:
; 0000 0610 a == '8'&
; 0000 0611 b == '7'&
; 0000 0612 c == '-'&
; 0000 0613 d == '2'&
; 0000 0614 e == '3'&
; 0000 0615 f == '8'&
; 0000 0616 g == '4'
; 0000 0617 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x14
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1B
	BREQ _0x6F
; 0000 0618 {
; 0000 0619 PORTA = 0x60;
	LDI  R30,LOW(96)
	OUT  0x1B,R30
; 0000 061A }
; 0000 061B 
; 0000 061C ///////////////////////////////////////////////////////////////
; 0000 061D 
; 0000 061E if(
_0x6F:
; 0000 061F a == '8'&
; 0000 0620 b == '6'&
; 0000 0621 c == '-'&
; 0000 0622 d == '0'&
; 0000 0623 e == '8'&
; 0000 0624 f == '4'&
; 0000 0625 g == '7'
; 0000 0626 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x35
	BREQ _0x70
; 0000 0627 {
; 0000 0628 PORTA = 0x61;
	LDI  R30,LOW(97)
	OUT  0x1B,R30
; 0000 0629 }
; 0000 062A 
; 0000 062B 
; 0000 062C ///////////////////////////////////////////////////////////////
; 0000 062D 
; 0000 062E if(
_0x70:
; 0000 062F a == '8'&
; 0000 0630 b == '6'&
; 0000 0631 c == '-'&
; 0000 0632 d == '1'&
; 0000 0633 e == '6'&
; 0000 0634 f == '2'&
; 0000 0635 g == '0'
; 0000 0636 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x36
	CALL SUBOPT_0x18
	BREQ _0x71
; 0000 0637 {
; 0000 0638 PORTA = 0x62;
	LDI  R30,LOW(98)
	OUT  0x1B,R30
; 0000 0639 }
; 0000 063A 
; 0000 063B 
; 0000 063C ///////////////////////////////////////////////////////////////
; 0000 063D 
; 0000 063E if(
_0x71:
; 0000 063F a == '8'&
; 0000 0640 b == '6'&
; 0000 0641 c == '-'&
; 0000 0642 d == '2'&
; 0000 0643 e == '0'&
; 0000 0644 f == '1'&
; 0000 0645 g == '9'
; 0000 0646 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x6
	CALL SUBOPT_0x37
	BREQ _0x72
; 0000 0647 {
; 0000 0648 PORTA = 0x63;
	LDI  R30,LOW(99)
	OUT  0x1B,R30
; 0000 0649 }
; 0000 064A 
; 0000 064B 
; 0000 064C ///////////////////////////////////////////////////////////////
; 0000 064D 
; 0000 064E if(
_0x72:
; 0000 064F a == '8'&
; 0000 0650 b == '6'&
; 0000 0651 c == '-'&
; 0000 0652 d == '2'&
; 0000 0653 e == '3'&
; 0000 0654 f == '8'&
; 0000 0655 g == '5'
; 0000 0656 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x14
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2C
	BREQ _0x73
; 0000 0657 {
; 0000 0658 PORTA = 0x64;
	LDI  R30,LOW(100)
	OUT  0x1B,R30
; 0000 0659 }
; 0000 065A 
; 0000 065B ///////////////////////////////////////////////////////////////
; 0000 065C 
; 0000 065D if(
_0x73:
; 0000 065E a == '8'&
; 0000 065F b == '7'&
; 0000 0660 c == '-'&
; 0000 0661 d == '0'&
; 0000 0662 e == '8'&
; 0000 0663 f == '4'&
; 0000 0664 g == '7'
; 0000 0665 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x35
	BREQ _0x74
; 0000 0666 {
; 0000 0667 PORTA = 0x65;
	LDI  R30,LOW(101)
	OUT  0x1B,R30
; 0000 0668 }
; 0000 0669 
; 0000 066A ///////////////////////////////////////////////////////////////
; 0000 066B 
; 0000 066C if(
_0x74:
; 0000 066D a == '8'&
; 0000 066E b == '7'&
; 0000 066F c == '-'&
; 0000 0670 d == '1'&
; 0000 0671 e == '6'&
; 0000 0672 f == '2'&
; 0000 0673 g == '0'
; 0000 0674 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x36
	CALL SUBOPT_0x18
	BREQ _0x75
; 0000 0675 {
; 0000 0676 PORTA = 0x66;
	LDI  R30,LOW(102)
	OUT  0x1B,R30
; 0000 0677 }
; 0000 0678 
; 0000 0679 
; 0000 067A ///////////////////////////////////////////////////////////////
; 0000 067B 
; 0000 067C if(
_0x75:
; 0000 067D a == '8'&
; 0000 067E b == '7'&
; 0000 067F c == '-'&
; 0000 0680 d == '2'&
; 0000 0681 e == '0'&
; 0000 0682 f == '1'&
; 0000 0683 g == '9'
; 0000 0684 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x6
	CALL SUBOPT_0x37
	BREQ _0x76
; 0000 0685 {
; 0000 0686 PORTA = 0x67;
	LDI  R30,LOW(103)
	OUT  0x1B,R30
; 0000 0687 }
; 0000 0688 
; 0000 0689 ///////////////////////////////////////////////////////////////
; 0000 068A 
; 0000 068B if(
_0x76:
; 0000 068C a == '8'&
; 0000 068D b == '7'&
; 0000 068E c == '-'&
; 0000 068F d == '2'&
; 0000 0690 e == '3'&
; 0000 0691 f == '8'&
; 0000 0692 g == '5'
; 0000 0693 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x14
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2C
	BREQ _0x77
; 0000 0694 {
; 0000 0695 PORTA = 0x68;
	LDI  R30,LOW(104)
	OUT  0x1B,R30
; 0000 0696 }
; 0000 0697 
; 0000 0698 ///////////////////////////////////////////////////////////////
; 0000 0699 
; 0000 069A if(
_0x77:
; 0000 069B a == '8'&
; 0000 069C b == '6'&
; 0000 069D c == '-'&
; 0000 069E d == '0'&
; 0000 069F e == '8'&
; 0000 06A0 f == '5'&
; 0000 06A1 g == '4'
; 0000 06A2 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0xB
	BREQ _0x78
; 0000 06A3 {
; 0000 06A4 PORTA = 0x69;
	LDI  R30,LOW(105)
	OUT  0x1B,R30
; 0000 06A5 }
; 0000 06A6 
; 0000 06A7 ///////////////////////////////////////////////////////////////
; 0000 06A8 
; 0000 06A9 if(
_0x78:
; 0000 06AA a == '8'&
; 0000 06AB b == '6'&
; 0000 06AC c == '-'&
; 0000 06AD d == '1'&
; 0000 06AE e == '6'&
; 0000 06AF f == '2'&
; 0000 06B0 g == '2'
; 0000 06B1 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x36
	CALL SUBOPT_0x31
	BREQ _0x79
; 0000 06B2 {
; 0000 06B3 PORTA = 0x6A;
	LDI  R30,LOW(106)
	OUT  0x1B,R30
; 0000 06B4 }
; 0000 06B5 
; 0000 06B6 ///////////////////////////////////////////////////////////////
; 0000 06B7 
; 0000 06B8 if(
_0x79:
; 0000 06B9 a == '8'&
; 0000 06BA b == '6'&
; 0000 06BB c == '-'&
; 0000 06BC d == '2'&
; 0000 06BD e == '0'&
; 0000 06BE f == '2'&
; 0000 06BF g == '8'
; 0000 06C0 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x6
	LDD  R26,Y+1
	CALL SUBOPT_0x1C
	LD   R26,Y
	LDI  R30,LOW(56)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x7A
; 0000 06C1 {
; 0000 06C2 PORTA = 0x6B;
	LDI  R30,LOW(107)
	OUT  0x1B,R30
; 0000 06C3 }
; 0000 06C4 
; 0000 06C5 ///////////////////////////////////////////////////////////////
; 0000 06C6 
; 0000 06C7 if(
_0x7A:
; 0000 06C8 a == '8'&
; 0000 06C9 b == '6'&
; 0000 06CA c == '-'&
; 0000 06CB d == '2'&
; 0000 06CC e == '4'&
; 0000 06CD f == '3'&
; 0000 06CE g == '7'
; 0000 06CF )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x38
	CALL SUBOPT_0x32
	BREQ _0x7B
; 0000 06D0 {
; 0000 06D1 PORTA = 0x6C;
	LDI  R30,LOW(108)
	OUT  0x1B,R30
; 0000 06D2 }
; 0000 06D3 
; 0000 06D4 ///////////////////////////////////////////////////////////////
; 0000 06D5 
; 0000 06D6 if(
_0x7B:
; 0000 06D7 a == '8'&
; 0000 06D8 b == '7'&
; 0000 06D9 c == '-'&
; 0000 06DA d == '0'&
; 0000 06DB e == '8'&
; 0000 06DC f == '5'&
; 0000 06DD g == '4'
; 0000 06DE )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0xB
	BREQ _0x7C
; 0000 06DF {
; 0000 06E0 PORTA = 0x6D;
	LDI  R30,LOW(109)
	OUT  0x1B,R30
; 0000 06E1 }
; 0000 06E2 
; 0000 06E3 ///////////////////////////////////////////////////////////////
; 0000 06E4 
; 0000 06E5 if(
_0x7C:
; 0000 06E6 a == '8'&
; 0000 06E7 b == '7'&
; 0000 06E8 c == '-'&
; 0000 06E9 d == '1'&
; 0000 06EA e == '6'&
; 0000 06EB f == '2'&
; 0000 06EC g == '2'
; 0000 06ED )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x36
	CALL SUBOPT_0x31
	BREQ _0x7D
; 0000 06EE {
; 0000 06EF PORTA = 0x6E;
	LDI  R30,LOW(110)
	OUT  0x1B,R30
; 0000 06F0 }
; 0000 06F1 
; 0000 06F2 ///////////////////////////////////////////////////////////////
; 0000 06F3 
; 0000 06F4 if(
_0x7D:
; 0000 06F5 a == '8'&
; 0000 06F6 b == '7'&
; 0000 06F7 c == '-'&
; 0000 06F8 d == '2'&
; 0000 06F9 e == '0'&
; 0000 06FA f == '2'&
; 0000 06FB g == '8'
; 0000 06FC )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x6
	LDD  R26,Y+1
	CALL SUBOPT_0x1C
	LD   R26,Y
	LDI  R30,LOW(56)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x7E
; 0000 06FD {
; 0000 06FE PORTA = 0x6F;
	LDI  R30,LOW(111)
	OUT  0x1B,R30
; 0000 06FF }
; 0000 0700 
; 0000 0701 ///////////////////////////////////////////////////////////////
; 0000 0702 
; 0000 0703 if(
_0x7E:
; 0000 0704 a == '8'&
; 0000 0705 b == '7'&
; 0000 0706 c == '-'&
; 0000 0707 d == '2'&
; 0000 0708 e == '4'&
; 0000 0709 f == '3'&
; 0000 070A g == '7'
; 0000 070B )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x38
	CALL SUBOPT_0x32
	BREQ _0x7F
; 0000 070C {
; 0000 070D PORTA = 0x70;
	LDI  R30,LOW(112)
	OUT  0x1B,R30
; 0000 070E }
; 0000 070F 
; 0000 0710 
; 0000 0711 ///////////////////////////////////////////////////////////////
; 0000 0712 
; 0000 0713 if(
_0x7F:
; 0000 0714 a == '8'&
; 0000 0715 b == '6'&
; 0000 0716 c == '-'&
; 0000 0717 d == '0'&
; 0000 0718 e == '8'&
; 0000 0719 f == '6'&
; 0000 071A g == '2'
; 0000 071B )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x39
	BREQ _0x80
; 0000 071C {
; 0000 071D PORTA = 0x71;
	LDI  R30,LOW(113)
	OUT  0x1B,R30
; 0000 071E }
; 0000 071F 
; 0000 0720 ///////////////////////////////////////////////////////////////
; 0000 0721 
; 0000 0722 if(
_0x80:
; 0000 0723 a == '8'&
; 0000 0724 b == '6'&
; 0000 0725 c == '-'&
; 0000 0726 d == '1'&
; 0000 0727 e == '6'&
; 0000 0728 f == '2'&
; 0000 0729 g == '5'
; 0000 072A )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x36
	CALL SUBOPT_0x2C
	BREQ _0x81
; 0000 072B {
; 0000 072C PORTA = 0x72;
	LDI  R30,LOW(114)
	OUT  0x1B,R30
; 0000 072D }
; 0000 072E 
; 0000 072F 
; 0000 0730 ///////////////////////////////////////////////////////////////
; 0000 0731 
; 0000 0732 if(
_0x81:
; 0000 0733 a == '8'&
; 0000 0734 b == '6'&
; 0000 0735 c == '-'&
; 0000 0736 d == '2'&
; 0000 0737 e == '0'&
; 0000 0738 f == '5'&
; 0000 0739 g == '2'
; 0000 073A )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x6
	LDD  R26,Y+1
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x31
	BREQ _0x82
; 0000 073B {
; 0000 073C PORTA = 0x73;
	LDI  R30,LOW(115)
	OUT  0x1B,R30
; 0000 073D }
; 0000 073E 
; 0000 073F ///////////////////////////////////////////////////////////////
; 0000 0740 
; 0000 0741 if(
_0x82:
; 0000 0742 a == '8'&
; 0000 0743 b == '6'&
; 0000 0744 c == '-'&
; 0000 0745 d == '2'&
; 0000 0746 e == '4'&
; 0000 0747 f == '9'&
; 0000 0748 g == '2'
; 0000 0749 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x3A
	BREQ _0x83
; 0000 074A {
; 0000 074B PORTA = 0x74;
	LDI  R30,LOW(116)
	OUT  0x1B,R30
; 0000 074C }
; 0000 074D 
; 0000 074E ///////////////////////////////////////////////////////////////
; 0000 074F 
; 0000 0750 if(
_0x83:
; 0000 0751 a == '8'&
; 0000 0752 b == '7'&
; 0000 0753 c == '-'&
; 0000 0754 d == '0'&
; 0000 0755 e == '8'&
; 0000 0756 f == '6'&
; 0000 0757 g == '2'
; 0000 0758 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x39
	BREQ _0x84
; 0000 0759 {
; 0000 075A PORTA = 0x75;
	LDI  R30,LOW(117)
	OUT  0x1B,R30
; 0000 075B }
; 0000 075C 
; 0000 075D ///////////////////////////////////////////////////////////////
; 0000 075E 
; 0000 075F if(
_0x84:
; 0000 0760 a == '8'&
; 0000 0761 b == '7'&
; 0000 0762 c == '-'&
; 0000 0763 d == '1'&
; 0000 0764 e == '6'&
; 0000 0765 f == '2'&
; 0000 0766 g == '5'
; 0000 0767 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x36
	CALL SUBOPT_0x2C
	BREQ _0x85
; 0000 0768 {
; 0000 0769 PORTA = 0x76;
	LDI  R30,LOW(118)
	OUT  0x1B,R30
; 0000 076A }
; 0000 076B 
; 0000 076C ///////////////////////////////////////////////////////////////
; 0000 076D 
; 0000 076E if(
_0x85:
; 0000 076F a == '8'&
; 0000 0770 b == '7'&
; 0000 0771 c == '-'&
; 0000 0772 d == '2'&
; 0000 0773 e == '0'&
; 0000 0774 f == '5'&
; 0000 0775 g == '2'
; 0000 0776 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x6
	LDD  R26,Y+1
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x31
	BREQ _0x86
; 0000 0777 {
; 0000 0778 PORTA = 0x77;
	LDI  R30,LOW(119)
	OUT  0x1B,R30
; 0000 0779 }
; 0000 077A 
; 0000 077B 
; 0000 077C ///////////////////////////////////////////////////////////////
; 0000 077D 
; 0000 077E if(
_0x86:
; 0000 077F a == '8'&
; 0000 0780 b == '7'&
; 0000 0781 c == '-'&
; 0000 0782 d == '2'&
; 0000 0783 e == '4'&
; 0000 0784 f == '9'&
; 0000 0785 g == '2'
; 0000 0786 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x3A
	BREQ _0x87
; 0000 0787 {
; 0000 0788 PORTA = 0x78;
	LDI  R30,LOW(120)
	OUT  0x1B,R30
; 0000 0789 }
; 0000 078A 
; 0000 078B ///////////////////////////////////////////////////////////////
; 0000 078C 
; 0000 078D if(
_0x87:
; 0000 078E a == '8'&
; 0000 078F b == '6'&
; 0000 0790 c == '-'&
; 0000 0791 d == '0'&
; 0000 0792 e == '9'&
; 0000 0793 f == '3'&
; 0000 0794 g == '5'
; 0000 0795 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2C
	BREQ _0x88
; 0000 0796 {
; 0000 0797 PORTA = 0x79;
	LDI  R30,LOW(121)
	OUT  0x1B,R30
; 0000 0798 }
; 0000 0799 
; 0000 079A ///////////////////////////////////////////////////////////////
; 0000 079B 
; 0000 079C if(
_0x88:
; 0000 079D a == '8'&
; 0000 079E b == '6'&
; 0000 079F c == '-'&
; 0000 07A0 d == '1'&
; 0000 07A1 e == '6'&
; 0000 07A2 f == '4'&
; 0000 07A3 g == '8'
; 0000 07A4 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x3B
	BREQ _0x89
; 0000 07A5 {
; 0000 07A6 PORTA = 0x7A;
	LDI  R30,LOW(122)
	OUT  0x1B,R30
; 0000 07A7 }
; 0000 07A8 
; 0000 07A9 ///////////////////////////////////////////////////////////////
; 0000 07AA 
; 0000 07AB if(
_0x89:
; 0000 07AC a == '8'&
; 0000 07AD b == '6'&
; 0000 07AE c == '-'&
; 0000 07AF d == '2'&
; 0000 07B0 e == '0'&
; 0000 07B1 f == '8'&
; 0000 07B2 g == '2'
; 0000 07B3 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x6
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x31
	BREQ _0x8A
; 0000 07B4 {
; 0000 07B5 PORTA = 0x7B;
	LDI  R30,LOW(123)
	OUT  0x1B,R30
; 0000 07B6 }
; 0000 07B7 
; 0000 07B8 
; 0000 07B9 ///////////////////////////////////////////////////////////////
; 0000 07BA 
; 0000 07BB if(
_0x8A:
; 0000 07BC a == '8'&
; 0000 07BD b == '6'&
; 0000 07BE c == '-'&
; 0000 07BF d == '2'&
; 0000 07C0 e == '5'&
; 0000 07C1 f == '0'&
; 0000 07C2 g == '0'
; 0000 07C3 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x2E
	LDD  R26,Y+1
	CALL SUBOPT_0x1
	CALL SUBOPT_0x18
	BREQ _0x8B
; 0000 07C4 {
; 0000 07C5 PORTA = 0x7C;
	LDI  R30,LOW(124)
	OUT  0x1B,R30
; 0000 07C6 }
; 0000 07C7 
; 0000 07C8 ///////////////////////////////////////////////////////////////
; 0000 07C9 
; 0000 07CA if(
_0x8B:
; 0000 07CB a == '8'&
; 0000 07CC b == '7'&
; 0000 07CD c == '-'&
; 0000 07CE d == '0'&
; 0000 07CF e == '9'&
; 0000 07D0 f == '3'&
; 0000 07D1 g == '5'
; 0000 07D2 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1
	LDD  R26,Y+2
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2C
	BREQ _0x8C
; 0000 07D3 {
; 0000 07D4 PORTA = 0x7D;
	LDI  R30,LOW(125)
	OUT  0x1B,R30
; 0000 07D5 }
; 0000 07D6 
; 0000 07D7 
; 0000 07D8 ///////////////////////////////////////////////////////////////
; 0000 07D9 
; 0000 07DA if(
_0x8C:
; 0000 07DB a == '8'&
; 0000 07DC b == '7'&
; 0000 07DD c == '-'&
; 0000 07DE d == '1'&
; 0000 07DF e == '6'&
; 0000 07E0 f == '4'&
; 0000 07E1 g == '8'
; 0000 07E2 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x3B
	BREQ _0x8D
; 0000 07E3 {
; 0000 07E4 PORTA = 0x7E;
	LDI  R30,LOW(126)
	OUT  0x1B,R30
; 0000 07E5 }
; 0000 07E6 
; 0000 07E7 ///////////////////////////////////////////////////////////////
; 0000 07E8 
; 0000 07E9 if(
_0x8D:
; 0000 07EA a == '8'&
; 0000 07EB b == '7'&
; 0000 07EC c == '-'&
; 0000 07ED d == '2'&
; 0000 07EE e == '0'&
; 0000 07EF f == '8'&
; 0000 07F0 g == '2'
; 0000 07F1 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x6
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x31
	BREQ _0x8E
; 0000 07F2 {
; 0000 07F3 PORTA = 0x7F;
	LDI  R30,LOW(127)
	OUT  0x1B,R30
; 0000 07F4 }
; 0000 07F5 
; 0000 07F6 
; 0000 07F7 ///////////////////////////////////////////////////////////////
; 0000 07F8 
; 0000 07F9 if(
_0x8E:
; 0000 07FA a == '8'&
; 0000 07FB b == '7'&
; 0000 07FC c == '-'&
; 0000 07FD d == '2'&
; 0000 07FE e == '5'&
; 0000 07FF f == '0'&
; 0000 0800 g == '0'
; 0000 0801 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x2E
	LDD  R26,Y+1
	CALL SUBOPT_0x1
	CALL SUBOPT_0x18
	BREQ _0x8F
; 0000 0802 {
; 0000 0803 PORTA = 0x80;
	LDI  R30,LOW(128)
	OUT  0x1B,R30
; 0000 0804 }
; 0000 0805 
; 0000 0806 ///////////////////////////////////////////////////////////////
; 0000 0807 
; 0000 0808 if(
_0x8F:
; 0000 0809 a == '8'&
; 0000 080A b == '6'&
; 0000 080B c == '-'&
; 0000 080C d == '1'&
; 0000 080D e == '0'&
; 0000 080E f == '1'&
; 0000 080F g == '9'
; 0000 0810 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x1
	CALL SUBOPT_0x37
	BREQ _0x90
; 0000 0811 {
; 0000 0812 PORTA = 0x81;
	LDI  R30,LOW(129)
	OUT  0x1B,R30
; 0000 0813 }
; 0000 0814 
; 0000 0815 
; 0000 0816 ///////////////////////////////////////////////////////////////
; 0000 0817 
; 0000 0818 if(
_0x90:
; 0000 0819 a == '8'&
; 0000 081A b == '6'&
; 0000 081B c == '-'&
; 0000 081C d == '1'&
; 0000 081D e == '6'&
; 0000 081E f == '4'&
; 0000 081F g == '9'
; 0000 0820 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x3C
	BREQ _0x91
; 0000 0821 {
; 0000 0822 PORTA = 0x82;
	LDI  R30,LOW(130)
	OUT  0x1B,R30
; 0000 0823 }
; 0000 0824 
; 0000 0825 
; 0000 0826 ///////////////////////////////////////////////////////////////
; 0000 0827 
; 0000 0828 if(
_0x91:
; 0000 0829 a == '8'&
; 0000 082A b == '6'&
; 0000 082B c == '-'&
; 0000 082C d == '2'&
; 0000 082D e == '0'&
; 0000 082E f == '8'&
; 0000 082F g == '3'
; 0000 0830 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x6
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	BREQ _0x92
; 0000 0831 {
; 0000 0832 PORTA = 0x83;
	LDI  R30,LOW(131)
	OUT  0x1B,R30
; 0000 0833 }
; 0000 0834 
; 0000 0835 ///////////////////////////////////////////////////////////////
; 0000 0836 
; 0000 0837 if(
_0x92:
; 0000 0838 a == '8'&
; 0000 0839 b == '6'&
; 0000 083A c == '-'&
; 0000 083B d == '2'&
; 0000 083C e == '5'&
; 0000 083D f == '8'&
; 0000 083E g == '5'
; 0000 083F )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x2E
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2C
	BREQ _0x93
; 0000 0840 {
; 0000 0841 PORTA = 0x84;
	LDI  R30,LOW(132)
	OUT  0x1B,R30
; 0000 0842 }
; 0000 0843 
; 0000 0844 ///////////////////////////////////////////////////////////////
; 0000 0845 
; 0000 0846 if(
_0x93:
; 0000 0847 a == '8'&
; 0000 0848 b == '7'&
; 0000 0849 c == '-'&
; 0000 084A d == '1'&
; 0000 084B e == '0'&
; 0000 084C f == '1'&
; 0000 084D g == '9'
; 0000 084E )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x1
	CALL SUBOPT_0x37
	BREQ _0x94
; 0000 084F {
; 0000 0850 PORTA = 0x85;
	LDI  R30,LOW(133)
	OUT  0x1B,R30
; 0000 0851 }
; 0000 0852 
; 0000 0853 ///////////////////////////////////////////////////////////////
; 0000 0854 
; 0000 0855 if(
_0x94:
; 0000 0856 a == '8'&
; 0000 0857 b == '7'&
; 0000 0858 c == '-'&
; 0000 0859 d == '1'&
; 0000 085A e == '6'&
; 0000 085B f == '4'&
; 0000 085C g == '9'
; 0000 085D )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x3C
	BREQ _0x95
; 0000 085E {
; 0000 085F PORTA = 0x86;
	LDI  R30,LOW(134)
	OUT  0x1B,R30
; 0000 0860 }
; 0000 0861 
; 0000 0862 
; 0000 0863 ///////////////////////////////////////////////////////////////
; 0000 0864 
; 0000 0865 if(
_0x95:
; 0000 0866 a == '8'&
; 0000 0867 b == '7'&
; 0000 0868 c == '-'&
; 0000 0869 d == '2'&
; 0000 086A e == '0'&
; 0000 086B f == '8'&
; 0000 086C g == '3'
; 0000 086D )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x6
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	BREQ _0x96
; 0000 086E {
; 0000 086F PORTA = 0x87;
	LDI  R30,LOW(135)
	OUT  0x1B,R30
; 0000 0870 }
; 0000 0871 
; 0000 0872 ///////////////////////////////////////////////////////////////
; 0000 0873 
; 0000 0874 if(
_0x96:
; 0000 0875 a == '8'&
; 0000 0876 b == '7'&
; 0000 0877 c == '-'&
; 0000 0878 d == '2'&
; 0000 0879 e == '6'&
; 0000 087A f == '2'&
; 0000 087B g == '4'
; 0000 087C )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x36
	CALL SUBOPT_0x1B
	BREQ _0x97
; 0000 087D {
; 0000 087E PORTA = 0x88;
	LDI  R30,LOW(136)
	OUT  0x1B,R30
; 0000 087F }
; 0000 0880 
; 0000 0881 ///////////////////////////////////////////////////////////////
; 0000 0882 
; 0000 0883 if(
_0x97:
; 0000 0884 a == '8'&
; 0000 0885 b == '6'&
; 0000 0886 c == '-'&
; 0000 0887 d == '1'&
; 0000 0888 e == '0'&
; 0000 0889 f == '2'&
; 0000 088A g == '7'
; 0000 088B )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x1
	LDD  R26,Y+1
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x32
	BREQ _0x98
; 0000 088C {
; 0000 088D PORTA = 0x89;
	LDI  R30,LOW(137)
	OUT  0x1B,R30
; 0000 088E }
; 0000 088F 
; 0000 0890 ///////////////////////////////////////////////////////////////
; 0000 0891 
; 0000 0892 if(
_0x98:
; 0000 0893 a == '8'&
; 0000 0894 b == '6'&
; 0000 0895 c == '-'&
; 0000 0896 d == '1'&
; 0000 0897 e == '6'&
; 0000 0898 f == '6'&
; 0000 0899 g == '9'
; 0000 089A )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3
	CALL SUBOPT_0x3D
	LDD  R26,Y+1
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x26
	BREQ _0x99
; 0000 089B {
; 0000 089C PORTA = 0x8A;
	LDI  R30,LOW(138)
	OUT  0x1B,R30
; 0000 089D }
; 0000 089E 
; 0000 089F ///////////////////////////////////////////////////////////////
; 0000 08A0 
; 0000 08A1 if(
_0x99:
; 0000 08A2 a == '8'&
; 0000 08A3 b == '6'&
; 0000 08A4 c == '-'&
; 0000 08A5 d == '2'&
; 0000 08A6 e == '0'&
; 0000 08A7 f == '8'&
; 0000 08A8 g == '7'
; 0000 08A9 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x6
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x32
	BREQ _0x9A
; 0000 08AA {
; 0000 08AB PORTA = 0x8B;
	LDI  R30,LOW(139)
	OUT  0x1B,R30
; 0000 08AC }
; 0000 08AD 
; 0000 08AE 
; 0000 08AF ///////////////////////////////////////////////////////////////
; 0000 08B0 
; 0000 08B1 if(
_0x9A:
; 0000 08B2 a == '8'&
; 0000 08B3 b == '6'&
; 0000 08B4 c == '-'&
; 0000 08B5 d == '2'&
; 0000 08B6 e == '6'&
; 0000 08B7 f == '2'&
; 0000 08B8 g == '4'
; 0000 08B9 )
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x36
	CALL SUBOPT_0x1B
	BREQ _0x9B
; 0000 08BA {
; 0000 08BB PORTA = 0x8C;
	LDI  R30,LOW(140)
	OUT  0x1B,R30
; 0000 08BC }
; 0000 08BD 
; 0000 08BE ///////////////////////////////////////////////////////////////
; 0000 08BF 
; 0000 08C0 if(
_0x9B:
; 0000 08C1 a == '8'&
; 0000 08C2 b == '7'&
; 0000 08C3 c == '-'&
; 0000 08C4 d == '1'&
; 0000 08C5 e == '0'&
; 0000 08C6 f == '2'&
; 0000 08C7 g == '7'
; 0000 08C8 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x1
	LDD  R26,Y+1
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x32
	BREQ _0x9C
; 0000 08C9 {
; 0000 08CA PORTA = 0x8D;
	LDI  R30,LOW(141)
	OUT  0x1B,R30
; 0000 08CB }
; 0000 08CC 
; 0000 08CD ///////////////////////////////////////////////////////////////
; 0000 08CE 
; 0000 08CF if(
_0x9C:
; 0000 08D0 a == '8'&
; 0000 08D1 b == '7'&
; 0000 08D2 c == '-'&
; 0000 08D3 d == '1'&
; 0000 08D4 e == '6'&
; 0000 08D5 f == '6'&
; 0000 08D6 g == '9'
; 0000 08D7 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x3
	CALL SUBOPT_0x3D
	LDD  R26,Y+1
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x26
	BREQ _0x9D
; 0000 08D8 {
; 0000 08D9 PORTA = 0x8E;
	LDI  R30,LOW(142)
	OUT  0x1B,R30
; 0000 08DA }
; 0000 08DB 
; 0000 08DC ///////////////////////////////////////////////////////////////
; 0000 08DD 
; 0000 08DE if(
_0x9D:
; 0000 08DF a == '8'&
; 0000 08E0 b == '7'&
; 0000 08E1 c == '-'&
; 0000 08E2 d == '2'&
; 0000 08E3 e == '0'&
; 0000 08E4 f == '8'&
; 0000 08E5 g == '7'
; 0000 08E6 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x6
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x32
	BREQ _0x9E
; 0000 08E7 {
; 0000 08E8 PORTA = 0x8F;
	LDI  R30,LOW(143)
	OUT  0x1B,R30
; 0000 08E9 }
; 0000 08EA 
; 0000 08EB 
; 0000 08EC ///////////////////////////////////////////////////////////////
; 0000 08ED 
; 0000 08EE if(
_0x9E:
; 0000 08EF a == '8'&
; 0000 08F0 b == '7'&
; 0000 08F1 c == '-'&
; 0000 08F2 d == '2'&
; 0000 08F3 e == '5'&
; 0000 08F4 f == '8'&
; 0000 08F5 g == '5'
; 0000 08F6 )
	CALL SUBOPT_0x8
	CALL SUBOPT_0x1C
	LDD  R26,Y+2
	CALL SUBOPT_0x2E
	LDD  R26,Y+1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2C
	BREQ _0x9F
; 0000 08F7 {
; 0000 08F8 PORTA = 0x90;
	LDI  R30,LOW(144)
	OUT  0x1B,R30
; 0000 08F9 }
; 0000 08FA 
; 0000 08FB }
_0x9F:
	ADIW R28,7
	RET
;
;
;void main(void)
; 0000 08FF {
_main:
; 0000 0900 
; 0000 0901 // Declare your local variables here
; 0000 0902 
; 0000 0903 // Input/Output Ports initialization
; 0000 0904 // Port A initialization
; 0000 0905 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0906 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0907 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0908 DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0909 
; 0000 090A // Port B initialization
; 0000 090B // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 090C // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 090D PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 090E DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 090F 
; 0000 0910 // Port C initialization
; 0000 0911 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0912 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0913 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0914 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0915 
; 0000 0916 // Port D initialization
; 0000 0917 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0918 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0919 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 091A DDRD=0x00;
	OUT  0x11,R30
; 0000 091B 
; 0000 091C // Port E initialization
; 0000 091D // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 091E // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 091F PORTE=0x00;
	OUT  0x3,R30
; 0000 0920 DDRE=0x00;
	OUT  0x2,R30
; 0000 0921 
; 0000 0922 // Port F initialization
; 0000 0923 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0924 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0925 PORTF=0x00;
	STS  98,R30
; 0000 0926 DDRF=0x00;
	STS  97,R30
; 0000 0927 
; 0000 0928 // Port G initialization
; 0000 0929 // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 092A // State4=T State3=T State2=T State1=T State0=T
; 0000 092B PORTG=0x00;
	STS  101,R30
; 0000 092C DDRG=0x00;
	STS  100,R30
; 0000 092D 
; 0000 092E // Timer/Counter 0 initialization
; 0000 092F // Clock source: System Clock
; 0000 0930 // Clock value: Timer 0 Stopped
; 0000 0931 // Mode: Normal top=0xFF
; 0000 0932 // OC0 output: Disconnected
; 0000 0933 ASSR=0x00;
	OUT  0x30,R30
; 0000 0934 TCCR0=0x00;
	OUT  0x33,R30
; 0000 0935 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0936 OCR0=0x00;
	OUT  0x31,R30
; 0000 0937 
; 0000 0938 // Timer/Counter 1 initialization
; 0000 0939 // Clock source: System Clock
; 0000 093A // Clock value: Timer1 Stopped
; 0000 093B // Mode: Normal top=0xFFFF
; 0000 093C // OC1A output: Discon.
; 0000 093D // OC1B output: Discon.
; 0000 093E // OC1C output: Discon.
; 0000 093F // Noise Canceler: Off
; 0000 0940 // Input Capture on Falling Edge
; 0000 0941 // Timer1 Overflow Interrupt: Off
; 0000 0942 // Input Capture Interrupt: Off
; 0000 0943 // Compare A Match Interrupt: Off
; 0000 0944 // Compare B Match Interrupt: Off
; 0000 0945 // Compare C Match Interrupt: Off
; 0000 0946 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0947 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0948 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0949 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 094A ICR1H=0x00;
	OUT  0x27,R30
; 0000 094B ICR1L=0x00;
	OUT  0x26,R30
; 0000 094C OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 094D OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 094E OCR1BH=0x00;
	OUT  0x29,R30
; 0000 094F OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0950 OCR1CH=0x00;
	STS  121,R30
; 0000 0951 OCR1CL=0x00;
	STS  120,R30
; 0000 0952 
; 0000 0953 // Timer/Counter 2 initialization
; 0000 0954 // Clock source: System Clock
; 0000 0955 // Clock value: Timer2 Stopped
; 0000 0956 // Mode: Normal top=0xFF
; 0000 0957 // OC2 output: Disconnected
; 0000 0958 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0959 TCNT2=0x00;
	OUT  0x24,R30
; 0000 095A OCR2=0x00;
	OUT  0x23,R30
; 0000 095B 
; 0000 095C // Timer/Counter 3 initialization
; 0000 095D // Clock source: System Clock
; 0000 095E // Clock value: Timer3 Stopped
; 0000 095F // Mode: Normal top=0xFFFF
; 0000 0960 // OC3A output: Discon.
; 0000 0961 // OC3B output: Discon.
; 0000 0962 // OC3C output: Discon.
; 0000 0963 // Noise Canceler: Off
; 0000 0964 // Input Capture on Falling Edge
; 0000 0965 // Timer3 Overflow Interrupt: Off
; 0000 0966 // Input Capture Interrupt: Off
; 0000 0967 // Compare A Match Interrupt: Off
; 0000 0968 // Compare B Match Interrupt: Off
; 0000 0969 // Compare C Match Interrupt: Off
; 0000 096A TCCR3A=0x00;
	STS  139,R30
; 0000 096B TCCR3B=0x00;
	STS  138,R30
; 0000 096C TCNT3H=0x00;
	STS  137,R30
; 0000 096D TCNT3L=0x00;
	STS  136,R30
; 0000 096E ICR3H=0x00;
	STS  129,R30
; 0000 096F ICR3L=0x00;
	STS  128,R30
; 0000 0970 OCR3AH=0x00;
	STS  135,R30
; 0000 0971 OCR3AL=0x00;
	STS  134,R30
; 0000 0972 OCR3BH=0x00;
	STS  133,R30
; 0000 0973 OCR3BL=0x00;
	STS  132,R30
; 0000 0974 OCR3CH=0x00;
	STS  131,R30
; 0000 0975 OCR3CL=0x00;
	STS  130,R30
; 0000 0976 
; 0000 0977 // External Interrupt(s) initialization
; 0000 0978 // INT0: Off
; 0000 0979 // INT1: Off
; 0000 097A // INT2: Off
; 0000 097B // INT3: Off
; 0000 097C // INT4: Off
; 0000 097D // INT5: Off
; 0000 097E // INT6: Off
; 0000 097F // INT7: Off
; 0000 0980 EICRA=0x00;
	STS  106,R30
; 0000 0981 EICRB=0x00;
	OUT  0x3A,R30
; 0000 0982 EIMSK=0x00;
	OUT  0x39,R30
; 0000 0983 
; 0000 0984 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0985 TIMSK=0x00;
	OUT  0x37,R30
; 0000 0986 
; 0000 0987 ETIMSK=0x00;
	STS  125,R30
; 0000 0988 
; 0000 0989 
; 0000 098A // USART0 initialization
; 0000 098B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 098C // USART0 Receiver: On
; 0000 098D // USART0 Transmitter: On
; 0000 098E // USART0 Mode: Asynchronous
; 0000 098F // USART0 Baud Rate: 115200
; 0000 0990 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 0991 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0992 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0993 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0994 UBRR0L=0x08;
	LDI  R30,LOW(8)
	OUT  0x9,R30
; 0000 0995 
; 0000 0996 // USART1 initialization
; 0000 0997 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0998 // USART1 Receiver: On
; 0000 0999 // USART1 Transmitter: On
; 0000 099A // USART1 Mode: Asynchronous
; 0000 099B // USART1 Baud Rate: 9600
; 0000 099C UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 099D UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(24)
	STS  154,R30
; 0000 099E UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 099F UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 09A0 UBRR1L=0x67;
	LDI  R30,LOW(103)
	STS  153,R30
; 0000 09A1 
; 0000 09A2 // Analog Comparator initialization
; 0000 09A3 // Analog Comparator: Off
; 0000 09A4 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 09A5 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 09A6 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 09A7 
; 0000 09A8 // ADC initialization
; 0000 09A9 // ADC disabled
; 0000 09AA ADCSRA=0x00;
	OUT  0x6,R30
; 0000 09AB 
; 0000 09AC // SPI initialization
; 0000 09AD // SPI disabled
; 0000 09AE SPCR=0x00;
	OUT  0xD,R30
; 0000 09AF 
; 0000 09B0 // TWI initialization
; 0000 09B1 // TWI disabled
; 0000 09B2 TWCR=0x00;
	STS  116,R30
; 0000 09B3 
; 0000 09B4 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x3E
; 0000 09B5 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x3E
; 0000 09B6 
; 0000 09B7 while (1)
_0xA0:
; 0000 09B8       {
; 0000 09B9       spr0 = getchar1();
	RCALL _getchar1
	MOV  R5,R30
; 0000 09BA 
; 0000 09BB       if(spr0 == '8')
	LDI  R30,LOW(56)
	CP   R30,R5
	BREQ PC+3
	JMP _0xA3
; 0000 09BC         {
; 0000 09BD         spr1 = getchar1();
	RCALL _getchar1
	MOV  R4,R30
; 0000 09BE         if(spr1 == '6' | spr1 == '7')
	MOV  R26,R4
	LDI  R30,LOW(54)
	CALL __EQB12
	MOV  R0,R30
	LDI  R30,LOW(55)
	CALL __EQB12
	OR   R30,R0
	BREQ _0xA4
; 0000 09BF             {
; 0000 09C0             odczyt[0]= spr0;
	STS  _odczyt,R5
; 0000 09C1             odczyt[1]= spr1;
	__PUTBMRN _odczyt,1,4
; 0000 09C2             odczyt[2] = getchar1();   //-
	RCALL _getchar1
	__PUTB1MN _odczyt,2
; 0000 09C3             odczyt[3] = getchar1();   //
	RCALL _getchar1
	__PUTB1MN _odczyt,3
; 0000 09C4             odczyt[4] = getchar1();
	RCALL _getchar1
	__PUTB1MN _odczyt,4
; 0000 09C5             odczyt[5] = getchar1();
	RCALL _getchar1
	__PUTB1MN _odczyt,5
; 0000 09C6             odczyt[6] = getchar1();
	RCALL _getchar1
	__PUTB1MN _odczyt,6
; 0000 09C7             odczyt[7] = getchar1();   //znak konca linia [enter]
	RCALL _getchar1
	__PUTB1MN _odczyt,7
; 0000 09C8 
; 0000 09C9             wybierz_zacisk(odczyt[0],odczyt[1],odczyt[2],odczyt[3],odczyt[4],odczyt[5],odczyt[6]);
	LDS  R30,_odczyt
	ST   -Y,R30
	__GETB1MN _odczyt,1
	ST   -Y,R30
	__GETB1MN _odczyt,2
	ST   -Y,R30
	__GETB1MN _odczyt,3
	ST   -Y,R30
	__GETB1MN _odczyt,4
	ST   -Y,R30
	__GETB1MN _odczyt,5
	ST   -Y,R30
	__GETB1MN _odczyt,6
	ST   -Y,R30
	RCALL _wybierz_zacisk
; 0000 09CA             delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 09CB             wyzeruj_odczyty();
	RCALL _wyzeruj_odczyty
; 0000 09CC 
; 0000 09CD 
; 0000 09CE 
; 0000 09CF 
; 0000 09D0             }
; 0000 09D1       }
_0xA4:
; 0000 09D2 
; 0000 09D3 
; 0000 09D4 
; 0000 09D5 
; 0000 09D6 
; 0000 09D7 
; 0000 09D8      }//while
_0xA3:
	RJMP _0xA0
; 0000 09D9 
; 0000 09DA 
; 0000 09DB 
; 0000 09DC 
; 0000 09DD 
; 0000 09DE 
; 0000 09DF 
; 0000 09E0 
; 0000 09E1 
; 0000 09E2 }
_0xA5:
	RJMP _0xA5
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

	.CSEG

	.CSEG

	.DSEG
_odczyt:
	.BYTE 0x14

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 72 TIMES, CODE SIZE REDUCTION:991 WORDS
SUBOPT_0x0:
	LDD  R26,Y+6
	LDI  R30,LOW(56)
	CALL __EQB12
	MOV  R0,R30
	LDD  R26,Y+5
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+4
	LDI  R30,LOW(45)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 70 TIMES, CODE SIZE REDUCTION:135 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(48)
	CALL __EQB12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2:
	LDD  R26,Y+2
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	LDI  R30,LOW(55)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(48)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 60 TIMES, CODE SIZE REDUCTION:174 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDD  R26,Y+1
	LDI  R30,LOW(52)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(51)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	LDI  R30,LOW(55)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(53)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:82 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(50)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+2
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LDD  R26,Y+1
	LDI  R30,LOW(57)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(56)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 72 TIMES, CODE SIZE REDUCTION:991 WORDS
SUBOPT_0x8:
	LDD  R26,Y+6
	LDI  R30,LOW(56)
	CALL __EQB12
	MOV  R0,R30
	LDD  R26,Y+5
	LDI  R30,LOW(55)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+4
	LDI  R30,LOW(45)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x9:
	LDD  R26,Y+2
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(57)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(50)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xB:
	LDD  R26,Y+1
	LDI  R30,LOW(53)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(52)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	LDI  R30,LOW(55)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(50)
	CALL __EQB12
	AND  R0,R30
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(51)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(50)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(57)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(51)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(50)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(56)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(55)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(52)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(57)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(52)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(51)
	CALL __EQB12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x15:
	LDD  R26,Y+1
	LDI  R30,LOW(52)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 42 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(56)
	CALL __EQB12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x17:
	LD   R26,Y
	LDI  R30,LOW(51)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x18:
	LD   R26,Y
	LDI  R30,LOW(48)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	LDD  R26,Y+2
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1A:
	LDD  R26,Y+1
	LDI  R30,LOW(52)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(57)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x1B:
	LD   R26,Y
	LDI  R30,LOW(52)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 58 TIMES, CODE SIZE REDUCTION:111 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(50)
	CALL __EQB12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+2
	LDI  R30,LOW(55)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(56)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	LDD  R26,Y+1
	LDI  R30,LOW(53)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(55)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1F:
	LDD  R26,Y+1
	LDI  R30,LOW(52)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(56)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	LDD  R26,Y+1
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(50)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	LDD  R26,Y+1
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(57)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	LDD  R26,Y+1
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(53)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(57)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x26:
	LD   R26,Y
	LDI  R30,LOW(57)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	LDD  R26,Y+1
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	LD   R26,Y
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x28:
	LDD  R26,Y+1
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R0,R30
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(53)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(57)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2B:
	LD   R26,Y
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x2C:
	LD   R26,Y
	LDI  R30,LOW(53)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2D:
	LDD  R26,Y+1
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R0,R30
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(53)
	CALL __EQB12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(57)
	CALL __EQB12
	AND  R0,R30
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x30:
	LDD  R26,Y+1
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R0,R30
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x31:
	LD   R26,Y
	LDI  R30,LOW(50)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x32:
	LD   R26,Y
	LDI  R30,LOW(55)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x33:
	LDD  R26,Y+1
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R0,R30
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x35:
	LDD  R26,Y+1
	LDI  R30,LOW(52)
	CALL __EQB12
	AND  R0,R30
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x37:
	LDD  R26,Y+1
	LDI  R30,LOW(49)
	CALL __EQB12
	AND  R0,R30
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	LDD  R26,Y+2
	LDI  R30,LOW(52)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x39:
	LDD  R26,Y+1
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+2
	LDI  R30,LOW(52)
	CALL __EQB12
	AND  R0,R30
	LDD  R26,Y+1
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	LDI  R30,LOW(54)
	CALL __EQB12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms


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

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

;END OF CODE MARKER
__END_OF_CODE:
