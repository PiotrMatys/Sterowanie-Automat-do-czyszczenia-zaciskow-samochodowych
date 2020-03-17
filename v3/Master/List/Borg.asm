
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
	.DEF _start=R12

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
	.DB  0x50,0x6F,0x7A,0x79,0x63,0x6A,0x6F,0x6E
	.DB  0x75,0x6A,0x65,0x20,0x75,0x6B,0x6C,0x61
	.DB  0x64,0x79,0x20,0x6C,0x69,0x6E,0x69,0x6F
	.DB  0x77,0x65,0x20,0x58,0x59,0x5A,0x0,0x53
	.DB  0x74,0x65,0x72,0x6F,0x77,0x6E,0x69,0x6B
	.DB  0x20,0x31,0x20,0x2D,0x20,0x77,0x79,0x70
	.DB  0x6F,0x7A,0x79,0x63,0x6A,0x6F,0x6E,0x6F
	.DB  0x77,0x61,0x6C,0x65,0x6D,0x0,0x53,0x74
	.DB  0x65,0x72,0x6F,0x77,0x6E,0x69,0x6B,0x20
	.DB  0x32,0x20,0x2D,0x20,0x77,0x79,0x70,0x6F
	.DB  0x7A,0x79,0x63,0x6A,0x6F,0x6E,0x6F,0x77
	.DB  0x61,0x6C,0x65,0x6D,0x0,0x53,0x74,0x65
	.DB  0x72,0x6F,0x77,0x6E,0x69,0x6B,0x20,0x33
	.DB  0x20,0x2D,0x20,0x77,0x79,0x70,0x6F,0x7A
	.DB  0x79,0x63,0x6A,0x6F,0x6E,0x6F,0x77,0x61
	.DB  0x6C,0x65,0x6D,0x0,0x53,0x74,0x65,0x72
	.DB  0x6F,0x77,0x6E,0x69,0x6B,0x20,0x34,0x20
	.DB  0x2D,0x20,0x77,0x79,0x70,0x6F,0x7A,0x79
	.DB  0x63,0x6A,0x6F,0x6E,0x6F,0x77,0x61,0x6C
	.DB  0x65,0x6D,0x0,0x41,0x6C,0x61,0x72,0x6D
	.DB  0x20,0x53,0x74,0x65,0x72,0x6F,0x77,0x6E
	.DB  0x69,0x6B,0x20,0x34,0x0,0x41,0x6C,0x61
	.DB  0x72,0x6D,0x20,0x53,0x74,0x65,0x72,0x6F
	.DB  0x77,0x6E,0x69,0x6B,0x20,0x33,0x0,0x41
	.DB  0x6C,0x61,0x72,0x6D,0x20,0x53,0x74,0x65
	.DB  0x72,0x6F,0x77,0x6E,0x69,0x6B,0x20,0x31
	.DB  0x0,0x41,0x6C,0x61,0x72,0x6D,0x20,0x53
	.DB  0x74,0x65,0x72,0x6F,0x77,0x6E,0x69,0x6B
	.DB  0x20,0x32,0x0,0x57,0x79,0x70,0x6F,0x7A
	.DB  0x79,0x63,0x6A,0x6F,0x6E,0x6F,0x77,0x61
	.DB  0x6E,0x6F,0x20,0x75,0x6B,0x6C,0x61,0x64
	.DB  0x79,0x20,0x6C,0x69,0x6E,0x69,0x6F,0x77
	.DB  0x65,0x20,0x58,0x59,0x5A,0x0,0x50,0x72
	.DB  0x7A,0x65,0x63,0x69,0x61,0x7A,0x65,0x6E
	.DB  0x69,0x61,0x20,0x4C,0x45,0x46,0x53,0x33
	.DB  0x32,0x5F,0x31,0x0,0x50,0x72,0x7A,0x65
	.DB  0x63,0x69,0x61,0x7A,0x65,0x6E,0x69,0x61
	.DB  0x20,0x4C,0x45,0x46,0x53,0x33,0x32,0x5F
	.DB  0x32,0x0,0x50,0x72,0x7A,0x65,0x63,0x69
	.DB  0x61,0x7A,0x65,0x6E,0x69,0x61,0x20,0x4C
	.DB  0x45,0x46,0x53,0x5F,0x58,0x59,0x5F,0x32
	.DB  0x0,0x50,0x72,0x7A,0x65,0x63,0x69,0x61
	.DB  0x7A,0x65,0x6E,0x69,0x61,0x20,0x4C,0x45
	.DB  0x46,0x53,0x5F,0x58,0x59,0x5F,0x31,0x0
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
;long int sek1,sek2,sek3,sek4,sek5,sek6,sek7,sek8,sek9,sek10,sek11,sek12;
;//int rzad;
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
;int wymieniono_szczotke_druciana,wymieniono_krazek_scierny;
;int predkosc_pion_szczotka, predkosc_pion_krazek;
;int wejscie_krazka_sciernego_w_pow_boczna_cylindra;
;int predkosc_ruchow_po_okregu_krazek_scierny;
;
;char sprawdz_pin0(BB PORT, int numer_pcf)
; 0000 00A7 {
_sprawdz_pin0:
; 0000 00A8 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00A9 i2c_write(numer_pcf);
; 0000 00AA PORT.byte = i2c_read(0);
; 0000 00AB i2c_stop();
; 0000 00AC 
; 0000 00AD 
; 0000 00AE return PORT.bits.b0;
	RJMP _0x20A0003
; 0000 00AF }
;
;char sprawdz_pin1(BB PORT, int numer_pcf)
; 0000 00B2 {
_sprawdz_pin1:
; 0000 00B3 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00B4 i2c_write(numer_pcf);
; 0000 00B5 PORT.byte = i2c_read(0);
; 0000 00B6 i2c_stop();
; 0000 00B7 
; 0000 00B8 
; 0000 00B9 return PORT.bits.b1;
	LSR  R30
	RJMP _0x20A0003
; 0000 00BA }
;
;
;char sprawdz_pin2(BB PORT, int numer_pcf)
; 0000 00BE {
_sprawdz_pin2:
; 0000 00BF i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00C0 i2c_write(numer_pcf);
; 0000 00C1 PORT.byte = i2c_read(0);
; 0000 00C2 i2c_stop();
; 0000 00C3 
; 0000 00C4 
; 0000 00C5 return PORT.bits.b2;
	LSR  R30
	LSR  R30
	RJMP _0x20A0003
; 0000 00C6 }
;
;char sprawdz_pin3(BB PORT, int numer_pcf)
; 0000 00C9 {
_sprawdz_pin3:
; 0000 00CA i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00CB i2c_write(numer_pcf);
; 0000 00CC PORT.byte = i2c_read(0);
; 0000 00CD i2c_stop();
; 0000 00CE 
; 0000 00CF 
; 0000 00D0 return PORT.bits.b3;
	LSR  R30
	LSR  R30
	LSR  R30
	RJMP _0x20A0003
; 0000 00D1 }
;
;char sprawdz_pin4(BB PORT, int numer_pcf)
; 0000 00D4 {
_sprawdz_pin4:
; 0000 00D5 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00D6 i2c_write(numer_pcf);
; 0000 00D7 PORT.byte = i2c_read(0);
; 0000 00D8 i2c_stop();
; 0000 00D9 
; 0000 00DA 
; 0000 00DB return PORT.bits.b4;
	SWAP R30
	RJMP _0x20A0003
; 0000 00DC }
;
;char sprawdz_pin5(BB PORT, int numer_pcf)
; 0000 00DF {
_sprawdz_pin5:
; 0000 00E0 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00E1 i2c_write(numer_pcf);
; 0000 00E2 PORT.byte = i2c_read(0);
; 0000 00E3 i2c_stop();
; 0000 00E4 
; 0000 00E5 
; 0000 00E6 return PORT.bits.b5;
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	RJMP _0x20A0003
; 0000 00E7 }
;
;char sprawdz_pin6(BB PORT, int numer_pcf)
; 0000 00EA {
_sprawdz_pin6:
; 0000 00EB i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00EC i2c_write(numer_pcf);
; 0000 00ED PORT.byte = i2c_read(0);
; 0000 00EE i2c_stop();
; 0000 00EF 
; 0000 00F0 
; 0000 00F1 return PORT.bits.b6;
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	RJMP _0x20A0003
; 0000 00F2 }
;
;char sprawdz_pin7(BB PORT, int numer_pcf)
; 0000 00F5 {
_sprawdz_pin7:
; 0000 00F6 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00F7 i2c_write(numer_pcf);
; 0000 00F8 PORT.byte = i2c_read(0);
; 0000 00F9 i2c_stop();
; 0000 00FA 
; 0000 00FB 
; 0000 00FC return PORT.bits.b7;
	ROL  R30
	LDI  R30,0
	ROL  R30
_0x20A0003:
	ANDI R30,LOW(0x1)
	ADIW R28,3
	RET
; 0000 00FD }
;
;int odczytaj_parametr(int adres1, int adres2)
; 0000 0100 {
_odczytaj_parametr:
; 0000 0101 int z;
; 0000 0102 z = 0;
	ST   -Y,R17
	ST   -Y,R16
;	adres1 -> Y+4
;	adres2 -> Y+2
;	z -> R16,R17
	__GETWRN 16,17,0
; 0000 0103 putchar(90);
	CALL SUBOPT_0x1
; 0000 0104 putchar(165);
; 0000 0105 putchar(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _putchar
; 0000 0106 putchar(131);
	LDI  R30,LOW(131)
	CALL SUBOPT_0x2
; 0000 0107 putchar(adres1);
; 0000 0108 putchar(adres2);
; 0000 0109 putchar(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar
; 0000 010A getchar();
	CALL SUBOPT_0x3
; 0000 010B getchar();
; 0000 010C getchar();
; 0000 010D getchar();
	CALL SUBOPT_0x3
; 0000 010E getchar();
; 0000 010F getchar();
; 0000 0110 getchar();
	CALL SUBOPT_0x3
; 0000 0111 getchar();
; 0000 0112 z = getchar();
	MOV  R16,R30
	CLR  R17
; 0000 0113 
; 0000 0114 
; 0000 0115 
; 0000 0116 
; 0000 0117 
; 0000 0118 
; 0000 0119 
; 0000 011A 
; 0000 011B 
; 0000 011C 
; 0000 011D 
; 0000 011E 
; 0000 011F return z;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0002
; 0000 0120 }
;
;
;
;int czekaj_na_guzik_start(int adres)
; 0000 0125 {
; 0000 0126 //48 to adres zmiennej 30
; 0000 0127 //16 to adres zmiennj 10
; 0000 0128 
; 0000 0129 int z;
; 0000 012A z = 0;
;	adres -> Y+2
;	z -> R16,R17
; 0000 012B putchar(90);
; 0000 012C putchar(165);
; 0000 012D putchar(4);
; 0000 012E putchar(131);
; 0000 012F putchar(0);
; 0000 0130 putchar(adres);  //adres zmiennej - 30
; 0000 0131 putchar(1);
; 0000 0132 getchar();
; 0000 0133 getchar();
; 0000 0134 getchar();
; 0000 0135 getchar();
; 0000 0136 getchar();
; 0000 0137 getchar();
; 0000 0138 getchar();
; 0000 0139 getchar();
; 0000 013A z = getchar();
; 0000 013B //itoa(z,dupa1);
; 0000 013C //lcd_puts(dupa1);
; 0000 013D 
; 0000 013E return z;
; 0000 013F }
;
;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0146 {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0147 // Place your code here
; 0000 0148 //16,384 ms
; 0000 0149 sek1++;     //Ster 1
	LDI  R26,LOW(_sek1)
	LDI  R27,HIGH(_sek1)
	CALL SUBOPT_0x4
; 0000 014A sek2++;     //ster 3
	LDI  R26,LOW(_sek2)
	LDI  R27,HIGH(_sek2)
	CALL SUBOPT_0x4
; 0000 014B 
; 0000 014C 
; 0000 014D sek3++;     //ster 2
	LDI  R26,LOW(_sek3)
	LDI  R27,HIGH(_sek3)
	CALL SUBOPT_0x4
; 0000 014E sek4++;     //ster 4
	LDI  R26,LOW(_sek4)
	LDI  R27,HIGH(_sek4)
	CALL SUBOPT_0x4
; 0000 014F 
; 0000 0150 
; 0000 0151 //sek10++;
; 0000 0152 
; 0000 0153 sek11++;  //do wyboru zacisku
	LDI  R26,LOW(_sek11)
	LDI  R27,HIGH(_sek11)
	CALL SUBOPT_0x4
; 0000 0154 sek12++;  //do czasu przedmuchu
	LDI  R26,LOW(_sek12)
	LDI  R27,HIGH(_sek12)
	CALL SUBOPT_0x4
; 0000 0155 }
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
; 0000 015E {
_komunikat_na_panel:
; 0000 015F int h;
; 0000 0160 
; 0000 0161 h = 0;
	ST   -Y,R17
	ST   -Y,R16
;	*fmtstr -> Y+6
;	adres2 -> Y+4
;	adres22 -> Y+2
;	h -> R16,R17
	__GETWRN 16,17,0
; 0000 0162 h = strlenf(fmtstr);
	CALL SUBOPT_0x5
	CALL _strlenf
	MOVW R16,R30
; 0000 0163 h = h + 3;
	__ADDWRN 16,17,3
; 0000 0164 
; 0000 0165 putchar(90);
	CALL SUBOPT_0x1
; 0000 0166 putchar(165);
; 0000 0167 putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL _putchar
; 0000 0168 putchar(130);  //82
	LDI  R30,LOW(130)
	CALL SUBOPT_0x2
; 0000 0169 putchar(adres2);    //
; 0000 016A putchar(adres22);  //
; 0000 016B printf(fmtstr);
	CALL SUBOPT_0x5
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 016C }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;
;void wartosc_parametru_panelu(int wartosc, int adres1, int adres2)
; 0000 016F {
_wartosc_parametru_panelu:
; 0000 0170 putchar(90);  //5A
;	wartosc -> Y+4
;	adres1 -> Y+2
;	adres2 -> Y+0
	CALL SUBOPT_0x1
; 0000 0171 putchar(165); //A5
; 0000 0172 putchar(5);//05
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL SUBOPT_0x6
; 0000 0173 putchar(130);  //82    /
; 0000 0174 putchar(adres1);    //00
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
; 0000 0175 putchar(adres2);   //40
	LD   R30,Y
	ST   -Y,R30
	CALL _putchar
; 0000 0176 putchar(0);    //00
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
; 0000 0177 putchar(wartosc);   //80
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _putchar
; 0000 0178 }
_0x20A0002:
	ADIW R28,6
	RET
;
;void komunikat_z_czytnika_kodow(char flash *fmtstr,int rzad, int na_plus_minus)
; 0000 017B {
_komunikat_z_czytnika_kodow:
; 0000 017C //na_plus_minus = 1;  to jest na plus
; 0000 017D //na_plus_minus = 0;  to jest na minus
; 0000 017E 
; 0000 017F int h, adres1,adres11,adres2,adres22;
; 0000 0180 
; 0000 0181 h = 0;
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
; 0000 0182 h = strlenf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOVW R16,R30
; 0000 0183 h = h + 3;
	__ADDWRN 16,17,3
; 0000 0184 
; 0000 0185 if(rzad == 1)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BRNE _0xD
; 0000 0186    {
; 0000 0187    adres1 = 0;
	__GETWRN 18,19,0
; 0000 0188    adres11 = 80;
	__GETWRN 20,21,80
; 0000 0189    adres2 = 80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 018A    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 018B    }
; 0000 018C if(rzad == 2)
_0xD:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,2
	BRNE _0xE
; 0000 018D    {
; 0000 018E    adres1 = 0;
	__GETWRN 18,19,0
; 0000 018F    adres11 = 32;
	__GETWRN 20,21,32
; 0000 0190    adres2 = 64;
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0191    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 0192    }
; 0000 0193 
; 0000 0194 putchar(90);
_0xE:
	CALL SUBOPT_0x1
; 0000 0195 putchar(165);
; 0000 0196 putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL SUBOPT_0x6
; 0000 0197 putchar(130);  //82
; 0000 0198 putchar(adres1);    //
	ST   -Y,R18
	CALL _putchar
; 0000 0199 putchar(adres11);  //
	ST   -Y,R20
	CALL _putchar
; 0000 019A printf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 019B 
; 0000 019C 
; 0000 019D if(rzad == 1 & macierz_zaciskow[rzad]==0)
	CALL SUBOPT_0x7
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0x8
	CALL __GETW1P
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	BREQ _0xF
; 0000 019E     {
; 0000 019F     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x9
; 0000 01A0     komunikat_na_panel("Zacisk nie zmierzony u Wykonawcy",adres2,adres22);
	__POINTW1FN _0x0,49
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
; 0000 01A1     }
; 0000 01A2 
; 0000 01A3 if(rzad == 1 & na_plus_minus == 1)
_0xF:
	CALL SUBOPT_0x7
	CALL SUBOPT_0xC
	BREQ _0x10
; 0000 01A4     {
; 0000 01A5     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x9
; 0000 01A6     komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
; 0000 01A7     }
; 0000 01A8 
; 0000 01A9 if(rzad == 1 & na_plus_minus == 0)
_0x10:
	CALL SUBOPT_0x7
	CALL SUBOPT_0xD
	BREQ _0x11
; 0000 01AA     {
; 0000 01AB     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x9
; 0000 01AC     komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
	__POINTW1FN _0x0,106
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
; 0000 01AD     }
; 0000 01AE 
; 0000 01AF 
; 0000 01B0 if(rzad == 2 & na_plus_minus == 1)
_0x11:
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC
	BREQ _0x12
; 0000 01B1     {
; 0000 01B2     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x9
; 0000 01B3     komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
	__POINTW1FN _0x0,106
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
; 0000 01B4     }
; 0000 01B5 
; 0000 01B6 if(rzad == 2 & na_plus_minus == 0)
_0x12:
	CALL SUBOPT_0xE
	CALL SUBOPT_0xD
	BREQ _0x13
; 0000 01B7     {
; 0000 01B8     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x9
; 0000 01B9     komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
; 0000 01BA     }
; 0000 01BB 
; 0000 01BC 
; 0000 01BD }
_0x13:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;
;
;
;
;void wyrrrjscia_i_wejscia_opis()
; 0000 01C3 {
; 0000 01C4 
; 0000 01C5 
; 0000 01C6 //IN0
; 0000 01C7 
; 0000 01C8 //komunikacja miedzy slave a master
; 0000 01C9 //sprawdz_pin0(PORTHH,0x73)
; 0000 01CA //sprawdz_pin1(PORTHH,0x73)
; 0000 01CB //sprawdz_pin2(PORTHH,0x73)
; 0000 01CC //sprawdz_pin3(PORTHH,0x73)
; 0000 01CD //sprawdz_pin4(PORTHH,0x73)
; 0000 01CE //sprawdz_pin5(PORTHH,0x73)
; 0000 01CF //sprawdz_pin6(PORTHH,0x73)
; 0000 01D0 //sprawdz_pin7(PORTHH,0x73)
; 0000 01D1 
; 0000 01D2 //IN1
; 0000 01D3 //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 01D4 //sprawdz_pin1(PORTJJ,0x79)  AREA   STEROWNIK1
; 0000 01D5 //sprawdz_pin2(PORTJJ,0x79)  SETON  STEROWNIK1
; 0000 01D6 //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 01D7 //sprawdz_pin4(PORTJJ,0x79)  SVRE   STEROWNIK1
; 0000 01D8 //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 01D9 //sprawdz_pin6(PORTJJ,0x79)  czujnik cisnienia
; 0000 01DA //sprawdz_pin7(PORTJJ,0x79)
; 0000 01DB 
; 0000 01DC //IN2
; 0000 01DD //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 01DE //sprawdz_pin1(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK3
; 0000 01DF //sprawdz_pin2(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK3
; 0000 01E0 //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 01E1 //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 01E2 //sprawdz_pin5(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK4
; 0000 01E3 //sprawdz_pin6(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK4
; 0000 01E4 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 01E5 
; 0000 01E6 //IN3
; 0000 01E7 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 01E8 //sprawdz_pin1(PORTLL,0x71)  AREA   STEROWNIK2
; 0000 01E9 //sprawdz_pin2(PORTLL,0x71)  SETON  STEROWNIK2
; 0000 01EA //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 01EB //sprawdz_pin4(PORTLL,0x71)  SVRE   STEROWNIK2
; 0000 01EC //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 01ED //sprawdz_pin6(PORTLL,0x71)  S6A przek³adanie rzedow
; 0000 01EE //sprawdz_pin7(PORTLL,0x71)  S6B przekladanie rzedow
; 0000 01EF 
; 0000 01F0 //IN4
; 0000 01F1 //sprawdz_pin0(PORTMM,0x77) J2  czujnik indukcyjny domkniecia pokrywy
; 0000 01F2 //sprawdz_pin1(PORTMM,0x77) J3  czujnik indukcyjny domkniecia pokrywy
; 0000 01F3 //sprawdz_pin2(PORTMM,0x77)
; 0000 01F4 //sprawdz_pin3(PORTMM,0x77)
; 0000 01F5 //sprawdz_pin4(PORTMM,0x77)
; 0000 01F6 //sprawdz_pin5(PORTMM,0x77)
; 0000 01F7 //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4      chyba na odwrot
; 0000 01F8 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 01F9 
; 0000 01FA 
; 0000 01FB 
; 0000 01FC 
; 0000 01FD //KARTA IN4 PRZEPINAM Z PORTE NA PORTF (BO RS232)
; 0000 01FE 
; 0000 01FF 
; 0000 0200 //sterownik 1
; 0000 0201 //sterownik 3 - szczotka papierowa
; 0000 0202 
; 0000 0203 //sterownik 2 - druciak
; 0000 0204 ///sterownik 4 - druciak
; 0000 0205 
; 0000 0206 
; 0000 0207 //OUT
; 0000 0208 //PORTA.0   IN0  STEROWNIK1        OUT 1
; 0000 0209 //PORTA.1   IN1  STEROWNIK1
; 0000 020A //PORTA.2   IN2  STEROWNIK1
; 0000 020B //PORTA.3   IN3  STEROWNIK1
; 0000 020C //PORTA.4   IN4  STEROWNIK1
; 0000 020D //PORTA.5   IN5  STEROWNIK1
; 0000 020E //PORTA.6   IN6  STEROWNIK1
; 0000 020F //PORTA.7   IN7  STEROWNIK1
; 0000 0210 
; 0000 0211 //str 83, pin 6 dodac do obu sterownikow
; 0000 0212 
; 0000 0213 
; 0000 0214 //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 0215 //PORTB.1   IN1  STEROWNIK4
; 0000 0216 //PORTB.2   IN2  STEROWNIK4
; 0000 0217 //PORTB.3   IN3  STEROWNIK4
; 0000 0218 //PORTB.4   4B CEWKA
; 0000 0219 //PORTB.5   DRIVE  STEROWNIK4
; 0000 021A //PORTB.6   ///////////////////////////////swiatlo zielone
; 0000 021B //PORTB.7   IN5 STEROWNIK 3
; 0000 021C 
; 0000 021D //PORTC.0   IN0  STEROWNIK2        OUT 3
; 0000 021E //PORTC.1   IN1  STEROWNIK2
; 0000 021F //PORTC.2   IN2  STEROWNIK2
; 0000 0220 //PORTC.3   IN3  STEROWNIK2
; 0000 0221 //PORTC.4   IN4  STEROWNIK2
; 0000 0222 //PORTC.5   IN5  STEROWNIK2
; 0000 0223 //PORTC.6   IN6  STEROWNIK2
; 0000 0224 //PORTC.7   IN7  STEROWNIK2
; 0000 0225 
; 0000 0226 //PORTD.0      SDA                 OUT 2
; 0000 0227 //PORTD.1      SCL
; 0000 0228 //PORTD.2  SETUP   STEROWNIK1 STEROWNIK 2 STEROIWNIK 3 STEROWNIK 4
; 0000 0229 //PORTD.3  DRIVE   STEROWNIK1
; 0000 022A //PORTD.4  IN8 STEROWNIK1
; 0000 022B //PORTD.5  IN8 STEROWNIK2
; 0000 022C //PORTD.6  DRIVE   STEROWNIK2
; 0000 022D //PORTD.7  ///////////////////////////////swiatlo czerwone - i jednoczesnie hold
; 0000 022E 
; 0000 022F //PORTE.0
; 0000 0230 //PORTE.1
; 0000 0231 //PORTE.2  1A CEWKA                     OUT 6
; 0000 0232 //PORTE.3  1B CEWKA
; 0000 0233 //PORTE.4  IN4  STEROWNIK4
; 0000 0234 //PORTE.5  IN5  STEROWNIK4
; 0000 0235 //PORTE.6  2A CEWKA
; 0000 0236 //PORTE.7  3A CEWKA
; 0000 0237 
; 0000 0238 //PORTF.0   IN0  STEROWNIK3             OUT 4
; 0000 0239 //PORTF.1   IN1  STEROWNIK3
; 0000 023A //PORTF.2   IN2  STEROWNIK3
; 0000 023B //PORTF.3   IN3  STEROWNIK3
; 0000 023C //PORTF.4   4A CEWKA
; 0000 023D //PORTF.5   DRIVE  STEROWNIK3
; 0000 023E //PORTF.6   /////////////////////////////////swiatlo zolte
; 0000 023F //PORTF.7   //IN4 STEROWNIK 3
; 0000 0240 
; 0000 0241 
; 0000 0242 //POPRAWIC STEROWNIK PRACE ZGODNIE Z OPISEM ZE STRONY 59 - POWINIENEM SPRAWDZIC CZY INP JEST ON A DOPIERO POTEM BUSY
; 0000 0243 //CZY SIE WYLACZYL
; 0000 0244 //FAJNIE ROBIE Z TYM CZEKAIEM 1S
; 0000 0245 
; 0000 0246 //PODPIAC JESZCZE HOLD WSZYSTKIE DO JEDNEGO
; 0000 0247 
; 0000 0248 
; 0000 0249 // macierz_zaciskow[rzad]=44; brak
; 0000 024A //macierz_zaciskow[rzad]=48; brak
; 0000 024B //macierz_zaciskow[rzad]=76  brak
; 0000 024C //macierz_zaciskow[rzad]=80; brak
; 0000 024D // macierz_zaciskow[rzad]=92;brak
; 0000 024E //  macierz_zaciskow[rzad]=96;  brak
; 0000 024F // macierz_zaciskow[rzad]=107; brak
; 0000 0250 //      macierz_zaciskow[rzad]=111; brak
; 0000 0251 
; 0000 0252 
; 0000 0253 
; 0000 0254 
; 0000 0255 /*
; 0000 0256 
; 0000 0257 //testy parzystych i nieparzystych IN0-IN8
; 0000 0258 //testy port/pin
; 0000 0259 //sterownik 3
; 0000 025A //PORTF.0   IN0  STEROWNIK3
; 0000 025B //PORTF.1   IN1  STEROWNIK3
; 0000 025C //PORTF.2   IN2  STEROWNIK3
; 0000 025D //PORTF.3   IN3  STEROWNIK3
; 0000 025E //PORTF.7   IN4 STEROWNIK 3
; 0000 025F //PORTB.7   IN5 STEROWNIK 3
; 0000 0260 
; 0000 0261 
; 0000 0262 PORT_F.bits.b0 = 0;
; 0000 0263 PORT_F.bits.b1 = 1;
; 0000 0264 PORT_F.bits.b2 = 0;
; 0000 0265 PORT_F.bits.b3 = 1;
; 0000 0266 PORT_F.bits.b7 = 0;
; 0000 0267 PORTF = PORT_F.byte;
; 0000 0268 PORTB.7 = 1;
; 0000 0269 
; 0000 026A //sterownik 4
; 0000 026B 
; 0000 026C //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 026D //PORTB.1   IN1  STEROWNIK4
; 0000 026E //PORTB.2   IN2  STEROWNIK4
; 0000 026F //PORTB.3   IN3  STEROWNIK4
; 0000 0270 //PORTE.4  IN4  STEROWNIK4
; 0000 0271 //PORTE.5  IN5  STEROWNIK4
; 0000 0272 
; 0000 0273 PORTB.0 = 0;
; 0000 0274 PORTB.1 = 1;
; 0000 0275 PORTB.2 = 0;
; 0000 0276 PORTB.3 = 1;
; 0000 0277 PORTE.4 = 0;
; 0000 0278 PORTE.5 = 1;
; 0000 0279 
; 0000 027A //ster 1
; 0000 027B PORTA.0 = 0;   //IN0  STEROWNIK1        OUT 1
; 0000 027C PORTA.1 = 1;  //IN1  STEROWNIK1
; 0000 027D PORTA.2 = 0;  // IN2  STEROWNIK1
; 0000 027E PORTA.3 = 1;  //IN3  STEROWNIK1
; 0000 027F PORTA.4 = 0;  // IN4  STEROWNIK1
; 0000 0280 PORTA.5 = 1;  //IN5  STEROWNIK1
; 0000 0281 PORTA.6 = 0;   //IN6  STEROWNIK1
; 0000 0282 PORTA.7 = 1;  //IN7  STEROWNIK1
; 0000 0283 PORTD.4 = 0; //IN8 STEROWNIK1
; 0000 0284 
; 0000 0285 
; 0000 0286 
; 0000 0287 //sterownik 2
; 0000 0288 PORTC.0 = 0;   //IN0  STEROWNIK2        OUT 3
; 0000 0289 PORTC.1  = 1;  //IN1  STEROWNIK2
; 0000 028A PORTC.2 = 0;    //IN2  STEROWNIK2
; 0000 028B PORTC.3= 1;   //IN3  STEROWNIK2
; 0000 028C PORTC.4 = 0;   // IN4  STEROWNIK2
; 0000 028D PORTC.5= 1;   //IN5  STEROWNIK2
; 0000 028E PORTC.6 = 0;   // IN6  STEROWNIK2
; 0000 028F PORTC.7= 1;   //IN7  STEROWNIK2
; 0000 0290 PORTD.5 = 0;  //IN8 STEROWNIK2
; 0000 0291 
; 0000 0292 */
; 0000 0293 
; 0000 0294 }
;
;void sprawdz_cisnienie()
; 0000 0297 {
_sprawdz_cisnienie:
; 0000 0298 int i;
; 0000 0299 //i = 0;
; 0000 029A i = 1;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,1
; 0000 029B 
; 0000 029C while(i == 0)
_0x14:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x16
; 0000 029D     {
; 0000 029E     if(sprawdz_pin6(PORTJJ,0x79) == 0)
	CALL SUBOPT_0xF
	RCALL _sprawdz_pin6
	CPI  R30,0
	BRNE _0x17
; 0000 029F         {
; 0000 02A0         i = 1;
	__GETWRN 16,17,1
; 0000 02A1         komunikat_na_panel("                                                ",adr1,adr2);
	__POINTW1FN _0x0,0
	RJMP _0x399
; 0000 02A2         }
; 0000 02A3     else
_0x17:
; 0000 02A4         {
; 0000 02A5         i = 0;
	__GETWRN 16,17,0
; 0000 02A6         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x10
; 0000 02A7         komunikat_na_panel("Cisnienie za male - mniejsze niz 6 bar",adr1,adr2);
	__POINTW1FN _0x0,132
_0x399:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
; 0000 02A8         }
; 0000 02A9     }
	RJMP _0x14
_0x16:
; 0000 02AA }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;int odczyt_wybranego_zacisku()
; 0000 02AD {                         //11
_odczyt_wybranego_zacisku:
; 0000 02AE int rzad;
; 0000 02AF 
; 0000 02B0 PORT_CZYTNIK.bits.b0 = sprawdz_pin0(PORTHH,0x73);
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	CALL SUBOPT_0x12
	RCALL _sprawdz_pin0
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFE
	CALL SUBOPT_0x13
; 0000 02B1 PORT_CZYTNIK.bits.b1 = sprawdz_pin1(PORTHH,0x73);
	RCALL _sprawdz_pin1
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFD
	CALL SUBOPT_0x13
; 0000 02B2 PORT_CZYTNIK.bits.b2 = sprawdz_pin2(PORTHH,0x73);
	RCALL _sprawdz_pin2
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFB
	CALL SUBOPT_0x13
; 0000 02B3 PORT_CZYTNIK.bits.b3 = sprawdz_pin3(PORTHH,0x73);
	RCALL _sprawdz_pin3
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0XF7
	CALL SUBOPT_0x13
; 0000 02B4 PORT_CZYTNIK.bits.b4 = sprawdz_pin4(PORTHH,0x73);
	RCALL _sprawdz_pin4
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xEF
	CALL SUBOPT_0x13
; 0000 02B5 PORT_CZYTNIK.bits.b5 = sprawdz_pin5(PORTHH,0x73);
	RCALL _sprawdz_pin5
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xDF
	CALL SUBOPT_0x13
; 0000 02B6 PORT_CZYTNIK.bits.b6 = sprawdz_pin6(PORTHH,0x73);
	RCALL _sprawdz_pin6
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xBF
	CALL SUBOPT_0x13
; 0000 02B7 PORT_CZYTNIK.bits.b7 = sprawdz_pin7(PORTHH,0x73);
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
; 0000 02B8 
; 0000 02B9 rzad = odczytaj_parametr(32,128);       //20,80
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	RCALL _odczytaj_parametr
	MOVW R16,R30
; 0000 02BA 
; 0000 02BB if(PORT_CZYTNIK.byte == 0x01)
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1)
	BRNE _0x19
; 0000 02BC     {
; 0000 02BD     macierz_zaciskow[rzad]=1;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
; 0000 02BE     komunikat_z_czytnika_kodow("86-0170",rzad,1);
	__POINTW1FN _0x0,171
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 02BF     }
; 0000 02C0 
; 0000 02C1 if(PORT_CZYTNIK.byte == 0x02)
_0x19:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2)
	BRNE _0x1A
; 0000 02C2     {
; 0000 02C3     macierz_zaciskow[rzad]=2;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
; 0000 02C4     komunikat_z_czytnika_kodow("86-1043",rzad,0);
	__POINTW1FN _0x0,179
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 02C5 
; 0000 02C6     }
; 0000 02C7 
; 0000 02C8 if(PORT_CZYTNIK.byte == 0x03)
_0x1A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3)
	BRNE _0x1B
; 0000 02C9     {
; 0000 02CA       macierz_zaciskow[rzad]=3;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   X+,R30
	ST   X,R31
; 0000 02CB       komunikat_z_czytnika_kodow("86-1675",rzad,0);
	__POINTW1FN _0x0,187
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 02CC     }
; 0000 02CD 
; 0000 02CE if(PORT_CZYTNIK.byte == 0x04)
_0x1B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4)
	BRNE _0x1C
; 0000 02CF     {
; 0000 02D0 
; 0000 02D1       macierz_zaciskow[rzad]=4;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   X+,R30
	ST   X,R31
; 0000 02D2       komunikat_z_czytnika_kodow("86-2098",rzad,0);
	__POINTW1FN _0x0,195
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 02D3 
; 0000 02D4     }
; 0000 02D5 if(PORT_CZYTNIK.byte == 0x05)
_0x1C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5)
	BRNE _0x1D
; 0000 02D6     {
; 0000 02D7       macierz_zaciskow[rzad]=5;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   X+,R30
	ST   X,R31
; 0000 02D8       komunikat_z_czytnika_kodow("87-0170",rzad,0);
	__POINTW1FN _0x0,203
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 02D9 
; 0000 02DA     }
; 0000 02DB if(PORT_CZYTNIK.byte == 0x06)
_0x1D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6)
	BRNE _0x1E
; 0000 02DC     {
; 0000 02DD       macierz_zaciskow[rzad]=6;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   X+,R30
	ST   X,R31
; 0000 02DE       komunikat_z_czytnika_kodow("87-1043",rzad,1);
	__POINTW1FN _0x0,211
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 02DF 
; 0000 02E0     }
; 0000 02E1 
; 0000 02E2 if(PORT_CZYTNIK.byte == 0x07)
_0x1E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7)
	BRNE _0x1F
; 0000 02E3     {
; 0000 02E4       macierz_zaciskow[rzad]=7;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   X+,R30
	ST   X,R31
; 0000 02E5       komunikat_z_czytnika_kodow("87-1675",rzad,1);
	__POINTW1FN _0x0,219
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 02E6 
; 0000 02E7     }
; 0000 02E8 
; 0000 02E9 if(PORT_CZYTNIK.byte == 0x08)
_0x1F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8)
	BRNE _0x20
; 0000 02EA     {
; 0000 02EB       macierz_zaciskow[rzad]=8;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   X+,R30
	ST   X,R31
; 0000 02EC       komunikat_z_czytnika_kodow("87-2098",rzad,1);
	__POINTW1FN _0x0,227
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 02ED 
; 0000 02EE     }
; 0000 02EF if(PORT_CZYTNIK.byte == 0x09)
_0x20:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x9)
	BRNE _0x21
; 0000 02F0     {
; 0000 02F1       macierz_zaciskow[rzad]=9;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   X+,R30
	ST   X,R31
; 0000 02F2       komunikat_z_czytnika_kodow("86-0192",rzad,0);
	__POINTW1FN _0x0,235
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 02F3 
; 0000 02F4     }
; 0000 02F5 if(PORT_CZYTNIK.byte == 0x0A)
_0x21:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xA)
	BRNE _0x22
; 0000 02F6     {
; 0000 02F7       macierz_zaciskow[rzad]=10;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   X+,R30
	ST   X,R31
; 0000 02F8       komunikat_z_czytnika_kodow("86-1054",rzad,0);
	__POINTW1FN _0x0,243
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 02F9 
; 0000 02FA     }
; 0000 02FB if(PORT_CZYTNIK.byte == 0x0B)
_0x22:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xB)
	BRNE _0x23
; 0000 02FC     {
; 0000 02FD       macierz_zaciskow[rzad]=11;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   X+,R30
	ST   X,R31
; 0000 02FE       komunikat_z_czytnika_kodow("86-1676",rzad,0);
	__POINTW1FN _0x0,251
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 02FF 
; 0000 0300     }
; 0000 0301 if(PORT_CZYTNIK.byte == 0x0C)
_0x23:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xC)
	BRNE _0x24
; 0000 0302     {
; 0000 0303       macierz_zaciskow[rzad]=12;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   X+,R30
	ST   X,R31
; 0000 0304       komunikat_z_czytnika_kodow("86-2132",rzad,1);
	__POINTW1FN _0x0,259
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0305 
; 0000 0306     }
; 0000 0307 if(PORT_CZYTNIK.byte == 0x0D)
_0x24:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xD)
	BRNE _0x25
; 0000 0308     {
; 0000 0309       macierz_zaciskow[rzad]=13;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   X+,R30
	ST   X,R31
; 0000 030A       komunikat_z_czytnika_kodow("87-0192",rzad,1);
	__POINTW1FN _0x0,267
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 030B 
; 0000 030C     }
; 0000 030D if(PORT_CZYTNIK.byte == 0x0E)
_0x25:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xE)
	BRNE _0x26
; 0000 030E     {
; 0000 030F       macierz_zaciskow[rzad]=14;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   X+,R30
	ST   X,R31
; 0000 0310       komunikat_z_czytnika_kodow("87-1054",rzad,1);
	__POINTW1FN _0x0,275
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0311 
; 0000 0312     }
; 0000 0313 
; 0000 0314 if(PORT_CZYTNIK.byte == 0x0F)
_0x26:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xF)
	BRNE _0x27
; 0000 0315     {
; 0000 0316       macierz_zaciskow[rzad]=15;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   X+,R30
	ST   X,R31
; 0000 0317       komunikat_z_czytnika_kodow("87-1676",rzad,1);
	__POINTW1FN _0x0,283
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0318 
; 0000 0319     }
; 0000 031A if(PORT_CZYTNIK.byte == 0x10)
_0x27:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x10)
	BRNE _0x28
; 0000 031B     {
; 0000 031C       macierz_zaciskow[rzad]=16;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   X+,R30
	ST   X,R31
; 0000 031D       komunikat_z_czytnika_kodow("87-2132",rzad,0);
	__POINTW1FN _0x0,291
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 031E 
; 0000 031F     }
; 0000 0320 
; 0000 0321 if(PORT_CZYTNIK.byte == 0x11)
_0x28:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x11)
	BRNE _0x29
; 0000 0322     {
; 0000 0323       macierz_zaciskow[rzad]=17;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   X+,R30
	ST   X,R31
; 0000 0324       komunikat_z_czytnika_kodow("86-0193",rzad,0);
	__POINTW1FN _0x0,299
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0325     }
; 0000 0326 
; 0000 0327 if(PORT_CZYTNIK.byte == 0x12)
_0x29:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x12)
	BRNE _0x2A
; 0000 0328     {
; 0000 0329       macierz_zaciskow[rzad]=18;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	ST   X+,R30
	ST   X,R31
; 0000 032A       komunikat_z_czytnika_kodow("86-1216",rzad,0);
	__POINTW1FN _0x0,307
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 032B 
; 0000 032C     }
; 0000 032D if(PORT_CZYTNIK.byte == 0x13)
_0x2A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x13)
	BRNE _0x2B
; 0000 032E     {
; 0000 032F       macierz_zaciskow[rzad]=19;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	ST   X+,R30
	ST   X,R31
; 0000 0330       komunikat_z_czytnika_kodow("86-1832",rzad,0);
	__POINTW1FN _0x0,315
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0331 
; 0000 0332     }
; 0000 0333 
; 0000 0334 if(PORT_CZYTNIK.byte == 0x14)
_0x2B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x14)
	BRNE _0x2C
; 0000 0335     {
; 0000 0336       macierz_zaciskow[rzad]=20;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   X+,R30
	ST   X,R31
; 0000 0337       komunikat_z_czytnika_kodow("86-2174",rzad,0);
	__POINTW1FN _0x0,323
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0338 
; 0000 0339     }
; 0000 033A if(PORT_CZYTNIK.byte == 0x15)
_0x2C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x15)
	BRNE _0x2D
; 0000 033B     {
; 0000 033C       macierz_zaciskow[rzad]=21;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	ST   X+,R30
	ST   X,R31
; 0000 033D       komunikat_z_czytnika_kodow("87-0193",rzad,1);
	__POINTW1FN _0x0,331
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 033E 
; 0000 033F     }
; 0000 0340 
; 0000 0341 if(PORT_CZYTNIK.byte == 0x16)
_0x2D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x16)
	BRNE _0x2E
; 0000 0342     {
; 0000 0343       macierz_zaciskow[rzad]=22;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	ST   X+,R30
	ST   X,R31
; 0000 0344       komunikat_z_czytnika_kodow("87-1216",rzad,1);
	__POINTW1FN _0x0,339
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0345 
; 0000 0346     }
; 0000 0347 if(PORT_CZYTNIK.byte == 0x17)
_0x2E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x17)
	BRNE _0x2F
; 0000 0348     {
; 0000 0349       macierz_zaciskow[rzad]=23;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	ST   X+,R30
	ST   X,R31
; 0000 034A       komunikat_z_czytnika_kodow("87-1832",rzad,1);
	__POINTW1FN _0x0,347
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 034B 
; 0000 034C     }
; 0000 034D 
; 0000 034E if(PORT_CZYTNIK.byte == 0x18)
_0x2F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x18)
	BRNE _0x30
; 0000 034F     {
; 0000 0350       macierz_zaciskow[rzad]=24;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	ST   X+,R30
	ST   X,R31
; 0000 0351       komunikat_z_czytnika_kodow("87-2174",rzad,1);
	__POINTW1FN _0x0,355
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0352 
; 0000 0353     }
; 0000 0354 if(PORT_CZYTNIK.byte == 0x19)
_0x30:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x19)
	BRNE _0x31
; 0000 0355     {
; 0000 0356       macierz_zaciskow[rzad]=25;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	ST   X+,R30
	ST   X,R31
; 0000 0357       komunikat_z_czytnika_kodow("86-0194",rzad,0);
	__POINTW1FN _0x0,363
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0358 
; 0000 0359     }
; 0000 035A 
; 0000 035B if(PORT_CZYTNIK.byte == 0x1A)
_0x31:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1A)
	BRNE _0x32
; 0000 035C     {
; 0000 035D       macierz_zaciskow[rzad]=26;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	ST   X+,R30
	ST   X,R31
; 0000 035E       komunikat_z_czytnika_kodow("86-1341",rzad,0);
	__POINTW1FN _0x0,371
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 035F 
; 0000 0360     }
; 0000 0361 if(PORT_CZYTNIK.byte == 0x1B)
_0x32:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1B)
	BRNE _0x33
; 0000 0362     {
; 0000 0363       macierz_zaciskow[rzad]=27;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(27)
	LDI  R31,HIGH(27)
	ST   X+,R30
	ST   X,R31
; 0000 0364       komunikat_z_czytnika_kodow("86-1833",rzad,0);
	__POINTW1FN _0x0,379
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0365 
; 0000 0366     }
; 0000 0367 if(PORT_CZYTNIK.byte == 0x1C)
_0x33:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1C)
	BRNE _0x34
; 0000 0368     {
; 0000 0369       macierz_zaciskow[rzad]=28;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	ST   X+,R30
	ST   X,R31
; 0000 036A       komunikat_z_czytnika_kodow("86-2180",rzad,1);
	__POINTW1FN _0x0,387
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 036B 
; 0000 036C     }
; 0000 036D if(PORT_CZYTNIK.byte == 0x1D)
_0x34:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1D)
	BRNE _0x35
; 0000 036E     {
; 0000 036F       macierz_zaciskow[rzad]=29;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	ST   X+,R30
	ST   X,R31
; 0000 0370       komunikat_z_czytnika_kodow("87-0194",rzad,1);
	__POINTW1FN _0x0,395
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0371 
; 0000 0372     }
; 0000 0373 
; 0000 0374 if(PORT_CZYTNIK.byte == 0x1E)
_0x35:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1E)
	BRNE _0x36
; 0000 0375     {
; 0000 0376       macierz_zaciskow[rzad]=30;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   X+,R30
	ST   X,R31
; 0000 0377       komunikat_z_czytnika_kodow("87-1341",rzad,1);
	__POINTW1FN _0x0,403
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0378 
; 0000 0379     }
; 0000 037A if(PORT_CZYTNIK.byte == 0x1F)
_0x36:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1F)
	BRNE _0x37
; 0000 037B     {
; 0000 037C       macierz_zaciskow[rzad]=31;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	ST   X+,R30
	ST   X,R31
; 0000 037D       komunikat_z_czytnika_kodow("87-1833",rzad,1);
	__POINTW1FN _0x0,411
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 037E 
; 0000 037F     }
; 0000 0380 
; 0000 0381 if(PORT_CZYTNIK.byte == 0x20)
_0x37:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x20)
	BRNE _0x38
; 0000 0382     {
; 0000 0383       macierz_zaciskow[rzad]=32;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   X+,R30
	ST   X,R31
; 0000 0384       komunikat_z_czytnika_kodow("87-2180",rzad,0);
	__POINTW1FN _0x0,419
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0385 
; 0000 0386     }
; 0000 0387 if(PORT_CZYTNIK.byte == 0x21)
_0x38:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x21)
	BRNE _0x39
; 0000 0388     {
; 0000 0389       macierz_zaciskow[rzad]=33;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	ST   X+,R30
	ST   X,R31
; 0000 038A       komunikat_z_czytnika_kodow("86-0663",rzad,1);
	__POINTW1FN _0x0,427
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 038B 
; 0000 038C     }
; 0000 038D 
; 0000 038E if(PORT_CZYTNIK.byte == 0x22)
_0x39:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x22)
	BRNE _0x3A
; 0000 038F     {
; 0000 0390       macierz_zaciskow[rzad]=34;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	ST   X+,R30
	ST   X,R31
; 0000 0391       komunikat_z_czytnika_kodow("86-1349",rzad,0);
	__POINTW1FN _0x0,435
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0392 
; 0000 0393     }
; 0000 0394 if(PORT_CZYTNIK.byte == 0x23)
_0x3A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x23)
	BRNE _0x3B
; 0000 0395     {
; 0000 0396       macierz_zaciskow[rzad]=35;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	ST   X+,R30
	ST   X,R31
; 0000 0397       komunikat_z_czytnika_kodow("86-1834",rzad,0);
	__POINTW1FN _0x0,443
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0398 
; 0000 0399     }
; 0000 039A if(PORT_CZYTNIK.byte == 0x24)
_0x3B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x24)
	BRNE _0x3C
; 0000 039B     {
; 0000 039C       macierz_zaciskow[rzad]=36;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	ST   X+,R30
	ST   X,R31
; 0000 039D       komunikat_z_czytnika_kodow("86-2204",rzad,0);
	__POINTW1FN _0x0,451
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 039E 
; 0000 039F     }
; 0000 03A0 if(PORT_CZYTNIK.byte == 0x25)
_0x3C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x25)
	BRNE _0x3D
; 0000 03A1     {
; 0000 03A2       macierz_zaciskow[rzad]=37;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(37)
	LDI  R31,HIGH(37)
	ST   X+,R30
	ST   X,R31
; 0000 03A3       komunikat_z_czytnika_kodow("87-0663",rzad,0);
	__POINTW1FN _0x0,459
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 03A4 
; 0000 03A5     }
; 0000 03A6 if(PORT_CZYTNIK.byte == 0x26)
_0x3D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x26)
	BRNE _0x3E
; 0000 03A7     {
; 0000 03A8       macierz_zaciskow[rzad]=38;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	ST   X+,R30
	ST   X,R31
; 0000 03A9       komunikat_z_czytnika_kodow("87-1349",rzad,1);
	__POINTW1FN _0x0,467
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 03AA 
; 0000 03AB     }
; 0000 03AC if(PORT_CZYTNIK.byte == 0x27)
_0x3E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x27)
	BRNE _0x3F
; 0000 03AD     {
; 0000 03AE       macierz_zaciskow[rzad]=39;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(39)
	LDI  R31,HIGH(39)
	ST   X+,R30
	ST   X,R31
; 0000 03AF       komunikat_z_czytnika_kodow("87-1834",rzad,1);
	__POINTW1FN _0x0,475
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 03B0 
; 0000 03B1     }
; 0000 03B2 if(PORT_CZYTNIK.byte == 0x28)
_0x3F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x28)
	BRNE _0x40
; 0000 03B3     {
; 0000 03B4       macierz_zaciskow[rzad]=40;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   X+,R30
	ST   X,R31
; 0000 03B5       komunikat_z_czytnika_kodow("87-2204",rzad,1);
	__POINTW1FN _0x0,483
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 03B6 
; 0000 03B7     }
; 0000 03B8 if(PORT_CZYTNIK.byte == 0x29)
_0x40:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x29)
	BRNE _0x41
; 0000 03B9     {
; 0000 03BA       macierz_zaciskow[rzad]=41;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	ST   X+,R30
	ST   X,R31
; 0000 03BB       komunikat_z_czytnika_kodow("86-0768",rzad,1);
	__POINTW1FN _0x0,491
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 03BC 
; 0000 03BD     }
; 0000 03BE if(PORT_CZYTNIK.byte == 0x2A)
_0x41:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2A)
	BRNE _0x42
; 0000 03BF     {
; 0000 03C0       macierz_zaciskow[rzad]=42;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   X+,R30
	ST   X,R31
; 0000 03C1       komunikat_z_czytnika_kodow("86-1357",rzad,0);
	__POINTW1FN _0x0,499
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 03C2 
; 0000 03C3     }
; 0000 03C4 if(PORT_CZYTNIK.byte == 0x2B)
_0x42:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2B)
	BRNE _0x43
; 0000 03C5     {
; 0000 03C6       macierz_zaciskow[rzad]=43;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	ST   X+,R30
	ST   X,R31
; 0000 03C7       komunikat_z_czytnika_kodow("86-1848",rzad,0);
	__POINTW1FN _0x0,507
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 03C8 
; 0000 03C9     }
; 0000 03CA if(PORT_CZYTNIK.byte == 0x2C)
_0x43:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2C)
	BRNE _0x44
; 0000 03CB     {
; 0000 03CC      macierz_zaciskow[rzad]=44;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x19
; 0000 03CD       macierz_zaciskow[rzad]=0;   ////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x1A
; 0000 03CE 
; 0000 03CF      komunikat_z_czytnika_kodow("86-2212",rzad,0);
	__POINTW1FN _0x0,515
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 03D0 
; 0000 03D1     }
; 0000 03D2 if(PORT_CZYTNIK.byte == 0x2D)
_0x44:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2D)
	BRNE _0x45
; 0000 03D3     {
; 0000 03D4       macierz_zaciskow[rzad]=45;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	ST   X+,R30
	ST   X,R31
; 0000 03D5       komunikat_z_czytnika_kodow("87-0768",rzad,0);
	__POINTW1FN _0x0,523
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 03D6 
; 0000 03D7     }
; 0000 03D8 if(PORT_CZYTNIK.byte == 0x2E)
_0x45:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2E)
	BRNE _0x46
; 0000 03D9     {
; 0000 03DA       macierz_zaciskow[rzad]=46;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	ST   X+,R30
	ST   X,R31
; 0000 03DB       komunikat_z_czytnika_kodow("87-1357",rzad,1);
	__POINTW1FN _0x0,531
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 03DC 
; 0000 03DD     }
; 0000 03DE if(PORT_CZYTNIK.byte == 0x2F)
_0x46:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2F)
	BRNE _0x47
; 0000 03DF     {
; 0000 03E0       macierz_zaciskow[rzad]=47;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	ST   X+,R30
	ST   X,R31
; 0000 03E1       komunikat_z_czytnika_kodow("87-1848",rzad,1);
	__POINTW1FN _0x0,539
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 03E2 
; 0000 03E3     }
; 0000 03E4 if(PORT_CZYTNIK.byte == 0x30)
_0x47:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x30)
	BRNE _0x48
; 0000 03E5     {
; 0000 03E6       macierz_zaciskow[rzad]=48;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x19
; 0000 03E7       macierz_zaciskow[rzad]=0;    /////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x1A
; 0000 03E8       komunikat_z_czytnika_kodow("87-2212",rzad,1);
	__POINTW1FN _0x0,547
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 03E9 
; 0000 03EA     }
; 0000 03EB if(PORT_CZYTNIK.byte == 0x31)
_0x48:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x31)
	BRNE _0x49
; 0000 03EC     {
; 0000 03ED       macierz_zaciskow[rzad]=49;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	ST   X+,R30
	ST   X,R31
; 0000 03EE       komunikat_z_czytnika_kodow("86-0800",rzad,0);
	__POINTW1FN _0x0,555
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 03EF 
; 0000 03F0     }
; 0000 03F1 if(PORT_CZYTNIK.byte == 0x32)
_0x49:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x32)
	BRNE _0x4A
; 0000 03F2     {
; 0000 03F3       macierz_zaciskow[rzad]=50;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   X+,R30
	ST   X,R31
; 0000 03F4       komunikat_z_czytnika_kodow("86-1363",rzad,0);
	__POINTW1FN _0x0,563
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 03F5 
; 0000 03F6     }
; 0000 03F7 if(PORT_CZYTNIK.byte == 0x33)
_0x4A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x33)
	BRNE _0x4B
; 0000 03F8     {
; 0000 03F9       macierz_zaciskow[rzad]=51;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	ST   X+,R30
	ST   X,R31
; 0000 03FA       komunikat_z_czytnika_kodow("86-1904",rzad,0);
	__POINTW1FN _0x0,571
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 03FB 
; 0000 03FC     }
; 0000 03FD if(PORT_CZYTNIK.byte == 0x34)
_0x4B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x34)
	BRNE _0x4C
; 0000 03FE     {
; 0000 03FF       macierz_zaciskow[rzad]=52;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	ST   X+,R30
	ST   X,R31
; 0000 0400       komunikat_z_czytnika_kodow("86-2241",rzad,1);
	__POINTW1FN _0x0,579
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0401 
; 0000 0402     }
; 0000 0403 if(PORT_CZYTNIK.byte == 0x35)
_0x4C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x35)
	BRNE _0x4D
; 0000 0404     {
; 0000 0405       macierz_zaciskow[rzad]=53;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(53)
	LDI  R31,HIGH(53)
	ST   X+,R30
	ST   X,R31
; 0000 0406       komunikat_z_czytnika_kodow("87-0800",rzad,1);
	__POINTW1FN _0x0,587
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0407 
; 0000 0408     }
; 0000 0409 
; 0000 040A if(PORT_CZYTNIK.byte == 0x36)
_0x4D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x36)
	BRNE _0x4E
; 0000 040B     {
; 0000 040C       macierz_zaciskow[rzad]=54;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	ST   X+,R30
	ST   X,R31
; 0000 040D       komunikat_z_czytnika_kodow("87-1363",rzad,1);
	__POINTW1FN _0x0,595
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 040E 
; 0000 040F     }
; 0000 0410 if(PORT_CZYTNIK.byte == 0x37)
_0x4E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x37)
	BRNE _0x4F
; 0000 0411     {
; 0000 0412       macierz_zaciskow[rzad]=55;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	ST   X+,R30
	ST   X,R31
; 0000 0413       komunikat_z_czytnika_kodow("87-1904",rzad,1);
	__POINTW1FN _0x0,603
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0414 
; 0000 0415     }
; 0000 0416 if(PORT_CZYTNIK.byte == 0x38)
_0x4F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x38)
	BRNE _0x50
; 0000 0417     {
; 0000 0418       macierz_zaciskow[rzad]=56;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	ST   X+,R30
	ST   X,R31
; 0000 0419       komunikat_z_czytnika_kodow("87-2241",rzad,0);
	__POINTW1FN _0x0,611
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 041A 
; 0000 041B     }
; 0000 041C if(PORT_CZYTNIK.byte == 0x39)
_0x50:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x39)
	BRNE _0x51
; 0000 041D     {
; 0000 041E       macierz_zaciskow[rzad]=57;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(57)
	LDI  R31,HIGH(57)
	ST   X+,R30
	ST   X,R31
; 0000 041F       komunikat_z_czytnika_kodow("86-0811",rzad,0);
	__POINTW1FN _0x0,619
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0420 
; 0000 0421     }
; 0000 0422 if(PORT_CZYTNIK.byte == 0x3A)
_0x51:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3A)
	BRNE _0x52
; 0000 0423     {
; 0000 0424       macierz_zaciskow[rzad]=58;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	ST   X+,R30
	ST   X,R31
; 0000 0425       komunikat_z_czytnika_kodow("86-1523",rzad,0);
	__POINTW1FN _0x0,627
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0426 
; 0000 0427     }
; 0000 0428 if(PORT_CZYTNIK.byte == 0x3B)
_0x52:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3B)
	BRNE _0x53
; 0000 0429     {
; 0000 042A       macierz_zaciskow[rzad]=59;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	ST   X+,R30
	ST   X,R31
; 0000 042B       komunikat_z_czytnika_kodow("86-1929",rzad,0);
	__POINTW1FN _0x0,635
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 042C 
; 0000 042D     }
; 0000 042E if(PORT_CZYTNIK.byte == 0x3C)
_0x53:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3C)
	BRNE _0x54
; 0000 042F     {
; 0000 0430       macierz_zaciskow[rzad]=60;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	ST   X+,R30
	ST   X,R31
; 0000 0431       komunikat_z_czytnika_kodow("86-2261",rzad,0);
	__POINTW1FN _0x0,643
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0432 
; 0000 0433     }
; 0000 0434 if(PORT_CZYTNIK.byte == 0x3D)
_0x54:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3D)
	BRNE _0x55
; 0000 0435     {
; 0000 0436       macierz_zaciskow[rzad]=61;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	ST   X+,R30
	ST   X,R31
; 0000 0437       komunikat_z_czytnika_kodow("87-0811",rzad,1);
	__POINTW1FN _0x0,651
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0438 
; 0000 0439     }
; 0000 043A if(PORT_CZYTNIK.byte == 0x3E)
_0x55:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3E)
	BRNE _0x56
; 0000 043B     {
; 0000 043C       macierz_zaciskow[rzad]=62;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	ST   X+,R30
	ST   X,R31
; 0000 043D       komunikat_z_czytnika_kodow("87-1523",rzad,1);
	__POINTW1FN _0x0,659
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 043E 
; 0000 043F     }
; 0000 0440 if(PORT_CZYTNIK.byte == 0x3F)
_0x56:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3F)
	BRNE _0x57
; 0000 0441     {
; 0000 0442       macierz_zaciskow[rzad]=63;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	ST   X+,R30
	ST   X,R31
; 0000 0443       komunikat_z_czytnika_kodow("87-1929",rzad,1);
	__POINTW1FN _0x0,667
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0444 
; 0000 0445     }
; 0000 0446 if(PORT_CZYTNIK.byte == 0x40)
_0x57:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x40)
	BRNE _0x58
; 0000 0447     {
; 0000 0448       macierz_zaciskow[rzad]=64;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   X+,R30
	ST   X,R31
; 0000 0449       komunikat_z_czytnika_kodow("87-2261",rzad,1);
	__POINTW1FN _0x0,675
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 044A 
; 0000 044B     }
; 0000 044C if(PORT_CZYTNIK.byte == 0x41)
_0x58:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x41)
	BRNE _0x59
; 0000 044D     {
; 0000 044E       macierz_zaciskow[rzad]=65;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   X+,R30
	ST   X,R31
; 0000 044F       komunikat_z_czytnika_kodow("86-0814",rzad,0);
	__POINTW1FN _0x0,683
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0450 
; 0000 0451     }
; 0000 0452 if(PORT_CZYTNIK.byte == 0x42)
_0x59:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x42)
	BRNE _0x5A
; 0000 0453     {
; 0000 0454       macierz_zaciskow[rzad]=66;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	ST   X+,R30
	ST   X,R31
; 0000 0455       komunikat_z_czytnika_kodow("86-1530",rzad,1);
	__POINTW1FN _0x0,691
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0456 
; 0000 0457     }
; 0000 0458 if(PORT_CZYTNIK.byte == 0x43)
_0x5A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x43)
	BRNE _0x5B
; 0000 0459     {
; 0000 045A       macierz_zaciskow[rzad]=67;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(67)
	LDI  R31,HIGH(67)
	ST   X+,R30
	ST   X,R31
; 0000 045B       komunikat_z_czytnika_kodow("86-1936",rzad,1);
	__POINTW1FN _0x0,699
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 045C 
; 0000 045D     }
; 0000 045E if(PORT_CZYTNIK.byte == 0x44)
_0x5B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x44)
	BRNE _0x5C
; 0000 045F     {
; 0000 0460       macierz_zaciskow[rzad]=68;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   X+,R30
	ST   X,R31
; 0000 0461       komunikat_z_czytnika_kodow("86-2285",rzad,1);
	__POINTW1FN _0x0,707
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0462 
; 0000 0463     }
; 0000 0464 if(PORT_CZYTNIK.byte == 0x45)
_0x5C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x45)
	BRNE _0x5D
; 0000 0465     {
; 0000 0466       macierz_zaciskow[rzad]=69;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(69)
	LDI  R31,HIGH(69)
	ST   X+,R30
	ST   X,R31
; 0000 0467       komunikat_z_czytnika_kodow("87-0814",rzad,1);
	__POINTW1FN _0x0,715
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0468 
; 0000 0469     }
; 0000 046A if(PORT_CZYTNIK.byte == 0x46)
_0x5D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x46)
	BRNE _0x5E
; 0000 046B     {
; 0000 046C       macierz_zaciskow[rzad]=70;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   X+,R30
	ST   X,R31
; 0000 046D       komunikat_z_czytnika_kodow("87-1530",rzad,0);
	__POINTW1FN _0x0,723
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 046E 
; 0000 046F     }
; 0000 0470 if(PORT_CZYTNIK.byte == 0x47)
_0x5E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x47)
	BRNE _0x5F
; 0000 0471     {
; 0000 0472       macierz_zaciskow[rzad]=71;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(71)
	LDI  R31,HIGH(71)
	ST   X+,R30
	ST   X,R31
; 0000 0473       komunikat_z_czytnika_kodow("87-1936",rzad,0);
	__POINTW1FN _0x0,731
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0474 
; 0000 0475     }
; 0000 0476 if(PORT_CZYTNIK.byte == 0x48)
_0x5F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x48)
	BRNE _0x60
; 0000 0477     {
; 0000 0478       macierz_zaciskow[rzad]=72;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	ST   X+,R30
	ST   X,R31
; 0000 0479       komunikat_z_czytnika_kodow("87-2285",rzad,0);
	__POINTW1FN _0x0,739
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 047A 
; 0000 047B     }
; 0000 047C if(PORT_CZYTNIK.byte == 0x49)
_0x60:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x49)
	BRNE _0x61
; 0000 047D     {
; 0000 047E       macierz_zaciskow[rzad]=73;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(73)
	LDI  R31,HIGH(73)
	ST   X+,R30
	ST   X,R31
; 0000 047F       komunikat_z_czytnika_kodow("86-0815",rzad,0);
	__POINTW1FN _0x0,747
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0480 
; 0000 0481     }
; 0000 0482 
; 0000 0483 if(PORT_CZYTNIK.byte == 0x4A)
_0x61:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4A)
	BRNE _0x62
; 0000 0484     {
; 0000 0485       macierz_zaciskow[rzad]=74;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	ST   X+,R30
	ST   X,R31
; 0000 0486       komunikat_z_czytnika_kodow("86-1551",rzad,0);
	__POINTW1FN _0x0,755
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0487 
; 0000 0488     }
; 0000 0489 if(PORT_CZYTNIK.byte == 0x4B)
_0x62:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4B)
	BRNE _0x63
; 0000 048A     {
; 0000 048B       macierz_zaciskow[rzad]=75;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	ST   X+,R30
	ST   X,R31
; 0000 048C       komunikat_z_czytnika_kodow("86-1941",rzad,0);
	__POINTW1FN _0x0,763
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 048D 
; 0000 048E     }
; 0000 048F if(PORT_CZYTNIK.byte == 0x4C)
_0x63:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4C)
	BRNE _0x64
; 0000 0490     {
; 0000 0491       macierz_zaciskow[rzad]=76;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x19
; 0000 0492       macierz_zaciskow[rzad]=0;    ////////////////////////////////brak zacisku
	CALL SUBOPT_0x1A
; 0000 0493       komunikat_z_czytnika_kodow("86-2286",rzad,0);
	__POINTW1FN _0x0,771
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0494 
; 0000 0495     }
; 0000 0496 if(PORT_CZYTNIK.byte == 0x4D)
_0x64:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4D)
	BRNE _0x65
; 0000 0497     {
; 0000 0498       macierz_zaciskow[rzad]=77;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(77)
	LDI  R31,HIGH(77)
	ST   X+,R30
	ST   X,R31
; 0000 0499       komunikat_z_czytnika_kodow("87-0815",rzad,1);
	__POINTW1FN _0x0,779
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 049A 
; 0000 049B     }
; 0000 049C if(PORT_CZYTNIK.byte == 0x4E)
_0x65:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4E)
	BRNE _0x66
; 0000 049D     {
; 0000 049E       macierz_zaciskow[rzad]=78;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	ST   X+,R30
	ST   X,R31
; 0000 049F       komunikat_z_czytnika_kodow("87-1551",rzad,1);
	__POINTW1FN _0x0,787
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 04A0 
; 0000 04A1     }
; 0000 04A2 if(PORT_CZYTNIK.byte == 0x4F)
_0x66:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4F)
	BRNE _0x67
; 0000 04A3     {
; 0000 04A4       macierz_zaciskow[rzad]=79;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(79)
	LDI  R31,HIGH(79)
	ST   X+,R30
	ST   X,R31
; 0000 04A5       komunikat_z_czytnika_kodow("87-1941",rzad,1);
	__POINTW1FN _0x0,795
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 04A6 
; 0000 04A7     }
; 0000 04A8 if(PORT_CZYTNIK.byte == 0x50)
_0x67:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x50)
	BRNE _0x68
; 0000 04A9     {
; 0000 04AA       macierz_zaciskow[rzad]=80;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x19
; 0000 04AB       macierz_zaciskow[rzad]=0;  ////////////////////////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x1A
; 0000 04AC       komunikat_z_czytnika_kodow("87-2286",rzad,0);
	__POINTW1FN _0x0,803
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 04AD 
; 0000 04AE     }
; 0000 04AF if(PORT_CZYTNIK.byte == 0x51)
_0x68:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x51)
	BRNE _0x69
; 0000 04B0     {
; 0000 04B1       macierz_zaciskow[rzad]=81;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(81)
	LDI  R31,HIGH(81)
	ST   X+,R30
	ST   X,R31
; 0000 04B2       komunikat_z_czytnika_kodow("86-0816",rzad,0);
	__POINTW1FN _0x0,811
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 04B3 
; 0000 04B4     }
; 0000 04B5 if(PORT_CZYTNIK.byte == 0x52)
_0x69:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x52)
	BRNE _0x6A
; 0000 04B6     {
; 0000 04B7       macierz_zaciskow[rzad]=82;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	ST   X+,R30
	ST   X,R31
; 0000 04B8       komunikat_z_czytnika_kodow("86-1552",rzad,0);
	__POINTW1FN _0x0,819
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 04B9 
; 0000 04BA     }
; 0000 04BB if(PORT_CZYTNIK.byte == 0x53)
_0x6A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x53)
	BRNE _0x6B
; 0000 04BC     {
; 0000 04BD       macierz_zaciskow[rzad]=83;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	ST   X+,R30
	ST   X,R31
; 0000 04BE       komunikat_z_czytnika_kodow("86-2007",rzad,1);
	__POINTW1FN _0x0,827
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 04BF 
; 0000 04C0     }
; 0000 04C1 if(PORT_CZYTNIK.byte == 0x54)
_0x6B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x54)
	BRNE _0x6C
; 0000 04C2     {
; 0000 04C3       macierz_zaciskow[rzad]=84;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	ST   X+,R30
	ST   X,R31
; 0000 04C4       komunikat_z_czytnika_kodow("86-2292",rzad,1);
	__POINTW1FN _0x0,835
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 04C5 
; 0000 04C6     }
; 0000 04C7 if(PORT_CZYTNIK.byte == 0x55)
_0x6C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x55)
	BRNE _0x6D
; 0000 04C8     {
; 0000 04C9       macierz_zaciskow[rzad]=85;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	ST   X+,R30
	ST   X,R31
; 0000 04CA       komunikat_z_czytnika_kodow("87-0816",rzad,1);
	__POINTW1FN _0x0,843
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 04CB 
; 0000 04CC      }
; 0000 04CD if(PORT_CZYTNIK.byte == 0x56)
_0x6D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x56)
	BRNE _0x6E
; 0000 04CE     {
; 0000 04CF       macierz_zaciskow[rzad]=86;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	ST   X+,R30
	ST   X,R31
; 0000 04D0       komunikat_z_czytnika_kodow("87-1552",rzad,1);
	__POINTW1FN _0x0,851
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 04D1 
; 0000 04D2     }
; 0000 04D3 if(PORT_CZYTNIK.byte == 0x57)
_0x6E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x57)
	BRNE _0x6F
; 0000 04D4     {
; 0000 04D5       macierz_zaciskow[rzad]=87;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(87)
	LDI  R31,HIGH(87)
	ST   X+,R30
	ST   X,R31
; 0000 04D6       komunikat_z_czytnika_kodow("87-2007",rzad,0);
	__POINTW1FN _0x0,859
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 04D7 
; 0000 04D8     }
; 0000 04D9 if(PORT_CZYTNIK.byte == 0x58)
_0x6F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x58)
	BRNE _0x70
; 0000 04DA     {
; 0000 04DB       macierz_zaciskow[rzad]=88;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	ST   X+,R30
	ST   X,R31
; 0000 04DC       komunikat_z_czytnika_kodow("87-2292",rzad,0);
	__POINTW1FN _0x0,867
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 04DD 
; 0000 04DE     }
; 0000 04DF if(PORT_CZYTNIK.byte == 0x59)
_0x70:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x59)
	BRNE _0x71
; 0000 04E0     {
; 0000 04E1       macierz_zaciskow[rzad]=89;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(89)
	LDI  R31,HIGH(89)
	ST   X+,R30
	ST   X,R31
; 0000 04E2       komunikat_z_czytnika_kodow("86-0817",rzad,0);
	__POINTW1FN _0x0,875
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 04E3 
; 0000 04E4     }
; 0000 04E5 if(PORT_CZYTNIK.byte == 0x5A)
_0x71:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5A)
	BRNE _0x72
; 0000 04E6     {
; 0000 04E7       macierz_zaciskow[rzad]=90;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   X+,R30
	ST   X,R31
; 0000 04E8       komunikat_z_czytnika_kodow("86-1602",rzad,1);
	__POINTW1FN _0x0,883
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 04E9 
; 0000 04EA     }
; 0000 04EB if(PORT_CZYTNIK.byte == 0x5B)
_0x72:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5B)
	BRNE _0x73
; 0000 04EC     {
; 0000 04ED       macierz_zaciskow[rzad]=91;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	ST   X+,R30
	ST   X,R31
; 0000 04EE       komunikat_z_czytnika_kodow("86-2017",rzad,1);
	__POINTW1FN _0x0,891
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 04EF 
; 0000 04F0     }
; 0000 04F1 if(PORT_CZYTNIK.byte == 0x5C)
_0x73:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5C)
	BRNE _0x74
; 0000 04F2     {
; 0000 04F3       macierz_zaciskow[rzad]=92;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x19
; 0000 04F4       macierz_zaciskow[rzad]=0;           /////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x1A
; 0000 04F5       komunikat_z_czytnika_kodow("86-2384",rzad,0);
	__POINTW1FN _0x0,899
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 04F6 
; 0000 04F7     }
; 0000 04F8 if(PORT_CZYTNIK.byte == 0x5D)
_0x74:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5D)
	BRNE _0x75
; 0000 04F9     {
; 0000 04FA       macierz_zaciskow[rzad]=93;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(93)
	LDI  R31,HIGH(93)
	ST   X+,R30
	ST   X,R31
; 0000 04FB       komunikat_z_czytnika_kodow("87-0817",rzad,1);
	__POINTW1FN _0x0,907
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 04FC 
; 0000 04FD     }
; 0000 04FE if(PORT_CZYTNIK.byte == 0x5E)
_0x75:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5E)
	BRNE _0x76
; 0000 04FF     {
; 0000 0500       macierz_zaciskow[rzad]=94;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	ST   X+,R30
	ST   X,R31
; 0000 0501       komunikat_z_czytnika_kodow("87-1602",rzad,0);
	__POINTW1FN _0x0,915
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0502 
; 0000 0503     }
; 0000 0504 if(PORT_CZYTNIK.byte == 0x5F)
_0x76:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5F)
	BRNE _0x77
; 0000 0505     {
; 0000 0506       macierz_zaciskow[rzad]=95;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(95)
	LDI  R31,HIGH(95)
	ST   X+,R30
	ST   X,R31
; 0000 0507       komunikat_z_czytnika_kodow("87-2017",rzad,0);
	__POINTW1FN _0x0,923
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0508 
; 0000 0509     }
; 0000 050A if(PORT_CZYTNIK.byte == 0x60)
_0x77:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x60)
	BRNE _0x78
; 0000 050B     {
; 0000 050C       macierz_zaciskow[rzad]=96;   ///////////////////////////////////////////////brak zacisku
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x19
; 0000 050D       macierz_zaciskow[rzad]=0;
	CALL SUBOPT_0x1A
; 0000 050E       komunikat_z_czytnika_kodow("87-2384",rzad,0);
	__POINTW1FN _0x0,931
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 050F 
; 0000 0510     }
; 0000 0511 
; 0000 0512 if(PORT_CZYTNIK.byte == 0x61)
_0x78:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x61)
	BRNE _0x79
; 0000 0513     {
; 0000 0514       macierz_zaciskow[rzad]=97;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(97)
	LDI  R31,HIGH(97)
	ST   X+,R30
	ST   X,R31
; 0000 0515       komunikat_z_czytnika_kodow("86-0847",rzad,0);
	__POINTW1FN _0x0,939
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0516 
; 0000 0517     }
; 0000 0518 
; 0000 0519 if(PORT_CZYTNIK.byte == 0x62)
_0x79:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x62)
	BRNE _0x7A
; 0000 051A     {
; 0000 051B       macierz_zaciskow[rzad]=98;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	ST   X+,R30
	ST   X,R31
; 0000 051C       komunikat_z_czytnika_kodow("86-1620",rzad,0);
	__POINTW1FN _0x0,947
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 051D 
; 0000 051E     }
; 0000 051F if(PORT_CZYTNIK.byte == 0x63)
_0x7A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x63)
	BRNE _0x7B
; 0000 0520     {
; 0000 0521       macierz_zaciskow[rzad]=99;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	ST   X+,R30
	ST   X,R31
; 0000 0522       komunikat_z_czytnika_kodow("86-2019",rzad,1);
	__POINTW1FN _0x0,955
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0523 
; 0000 0524     }
; 0000 0525 if(PORT_CZYTNIK.byte == 0x64)
_0x7B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x64)
	BRNE _0x7C
; 0000 0526     {
; 0000 0527       macierz_zaciskow[rzad]=100;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   X+,R30
	ST   X,R31
; 0000 0528       komunikat_z_czytnika_kodow("86-2385",rzad,0);
	__POINTW1FN _0x0,963
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0529 
; 0000 052A     }
; 0000 052B if(PORT_CZYTNIK.byte == 0x65)
_0x7C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x65)
	BRNE _0x7D
; 0000 052C     {
; 0000 052D       macierz_zaciskow[rzad]=101;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(101)
	LDI  R31,HIGH(101)
	ST   X+,R30
	ST   X,R31
; 0000 052E       komunikat_z_czytnika_kodow("87-0847",rzad,1);
	__POINTW1FN _0x0,971
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 052F 
; 0000 0530     }
; 0000 0531 if(PORT_CZYTNIK.byte == 0x66)
_0x7D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x66)
	BRNE _0x7E
; 0000 0532     {
; 0000 0533       macierz_zaciskow[rzad]=102;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	ST   X+,R30
	ST   X,R31
; 0000 0534       komunikat_z_czytnika_kodow("87-1620",rzad,1);
	__POINTW1FN _0x0,979
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0535 
; 0000 0536     }
; 0000 0537 if(PORT_CZYTNIK.byte == 0x67)
_0x7E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x67)
	BRNE _0x7F
; 0000 0538     {
; 0000 0539       macierz_zaciskow[rzad]=103;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	ST   X+,R30
	ST   X,R31
; 0000 053A       komunikat_z_czytnika_kodow("87-2019",rzad,0);
	__POINTW1FN _0x0,987
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 053B 
; 0000 053C     }
; 0000 053D if(PORT_CZYTNIK.byte == 0x68)
_0x7F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x68)
	BRNE _0x80
; 0000 053E     {
; 0000 053F       macierz_zaciskow[rzad]=104;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	ST   X+,R30
	ST   X,R31
; 0000 0540       komunikat_z_czytnika_kodow("87-2385",rzad,1);
	__POINTW1FN _0x0,995
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0541 
; 0000 0542     }
; 0000 0543 if(PORT_CZYTNIK.byte == 0x69)
_0x80:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x69)
	BRNE _0x81
; 0000 0544     {
; 0000 0545       macierz_zaciskow[rzad]=105;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(105)
	LDI  R31,HIGH(105)
	ST   X+,R30
	ST   X,R31
; 0000 0546       komunikat_z_czytnika_kodow("86-0854",rzad,0);
	__POINTW1FN _0x0,1003
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0547 
; 0000 0548     }
; 0000 0549 if(PORT_CZYTNIK.byte == 0x6A)
_0x81:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6A)
	BRNE _0x82
; 0000 054A     {
; 0000 054B       macierz_zaciskow[rzad]=106;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	ST   X+,R30
	ST   X,R31
; 0000 054C       komunikat_z_czytnika_kodow("86-1622",rzad,1);
	__POINTW1FN _0x0,1011
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 054D 
; 0000 054E     }
; 0000 054F if(PORT_CZYTNIK.byte == 0x6B)
_0x82:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6B)
	BRNE _0x83
; 0000 0550     {
; 0000 0551       macierz_zaciskow[rzad]=107;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(107)
	LDI  R31,HIGH(107)
	CALL SUBOPT_0x19
; 0000 0552       macierz_zaciskow[rzad]=0;          //brak zacisku
	CALL SUBOPT_0x1A
; 0000 0553       komunikat_z_czytnika_kodow("86-2028",rzad,0);
	__POINTW1FN _0x0,1019
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0554 
; 0000 0555     }
; 0000 0556 if(PORT_CZYTNIK.byte == 0x6C)
_0x83:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6C)
	BRNE _0x84
; 0000 0557     {
; 0000 0558       macierz_zaciskow[rzad]=108;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	ST   X+,R30
	ST   X,R31
; 0000 0559       komunikat_z_czytnika_kodow("86-2437",rzad,0);
	__POINTW1FN _0x0,1027
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 055A 
; 0000 055B     }
; 0000 055C if(PORT_CZYTNIK.byte == 0x6D)
_0x84:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6D)
	BRNE _0x85
; 0000 055D     {
; 0000 055E       macierz_zaciskow[rzad]=109;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(109)
	LDI  R31,HIGH(109)
	ST   X+,R30
	ST   X,R31
; 0000 055F       komunikat_z_czytnika_kodow("87-0854",rzad,1);
	__POINTW1FN _0x0,1035
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0560 
; 0000 0561     }
; 0000 0562 if(PORT_CZYTNIK.byte == 0x6E)
_0x85:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6E)
	BRNE _0x86
; 0000 0563     {
; 0000 0564       macierz_zaciskow[rzad]=110;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	ST   X+,R30
	ST   X,R31
; 0000 0565       komunikat_z_czytnika_kodow("87-1622",rzad,0);
	__POINTW1FN _0x0,1043
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0566 
; 0000 0567     }
; 0000 0568 
; 0000 0569 if(PORT_CZYTNIK.byte == 0x6F)
_0x86:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6F)
	BRNE _0x87
; 0000 056A     {
; 0000 056B       macierz_zaciskow[rzad]=111;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(111)
	LDI  R31,HIGH(111)
	CALL SUBOPT_0x19
; 0000 056C       macierz_zaciskow[rzad]=0;      //brak zacisku
	CALL SUBOPT_0x1A
; 0000 056D       komunikat_z_czytnika_kodow("87-2028",rzad,0);
	__POINTW1FN _0x0,1051
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 056E 
; 0000 056F     }
; 0000 0570 
; 0000 0571 if(PORT_CZYTNIK.byte == 0x70)
_0x87:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x70)
	BRNE _0x88
; 0000 0572     {
; 0000 0573       macierz_zaciskow[rzad]=112;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   X+,R30
	ST   X,R31
; 0000 0574       komunikat_z_czytnika_kodow("87-2437",rzad,1);
	__POINTW1FN _0x0,1059
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0575 
; 0000 0576     }
; 0000 0577 if(PORT_CZYTNIK.byte == 0x71)
_0x88:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x71)
	BRNE _0x89
; 0000 0578     {
; 0000 0579       macierz_zaciskow[rzad]=113;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   X+,R30
	ST   X,R31
; 0000 057A       komunikat_z_czytnika_kodow("86-0862",rzad,0);
	__POINTW1FN _0x0,1067
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 057B 
; 0000 057C     }
; 0000 057D if(PORT_CZYTNIK.byte == 0x72)
_0x89:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x72)
	BRNE _0x8A
; 0000 057E     {
; 0000 057F       macierz_zaciskow[rzad]=114;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	ST   X+,R30
	ST   X,R31
; 0000 0580       komunikat_z_czytnika_kodow("86-1625",rzad,0);
	__POINTW1FN _0x0,1075
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0581 
; 0000 0582     }
; 0000 0583 if(PORT_CZYTNIK.byte == 0x73)
_0x8A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x73)
	BRNE _0x8B
; 0000 0584     {
; 0000 0585       macierz_zaciskow[rzad]=115;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(115)
	LDI  R31,HIGH(115)
	ST   X+,R30
	ST   X,R31
; 0000 0586       komunikat_z_czytnika_kodow("86-2052",rzad,0);
	__POINTW1FN _0x0,1083
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0587 
; 0000 0588     }
; 0000 0589 if(PORT_CZYTNIK.byte == 0x74)
_0x8B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x74)
	BRNE _0x8C
; 0000 058A     {
; 0000 058B       macierz_zaciskow[rzad]=116;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	ST   X+,R30
	ST   X,R31
; 0000 058C       komunikat_z_czytnika_kodow("86-2492",rzad,1);
	__POINTW1FN _0x0,1091
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 058D 
; 0000 058E     }
; 0000 058F if(PORT_CZYTNIK.byte == 0x75)
_0x8C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x75)
	BRNE _0x8D
; 0000 0590     {
; 0000 0591       macierz_zaciskow[rzad]=117;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(117)
	LDI  R31,HIGH(117)
	ST   X+,R30
	ST   X,R31
; 0000 0592       komunikat_z_czytnika_kodow("87-0862",rzad,1);
	__POINTW1FN _0x0,1099
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0593 
; 0000 0594     }
; 0000 0595 if(PORT_CZYTNIK.byte == 0x76)
_0x8D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x76)
	BRNE _0x8E
; 0000 0596     {
; 0000 0597       macierz_zaciskow[rzad]=118;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	ST   X+,R30
	ST   X,R31
; 0000 0598       komunikat_z_czytnika_kodow("87-1625",rzad,1);
	__POINTW1FN _0x0,1107
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0599 
; 0000 059A     }
; 0000 059B if(PORT_CZYTNIK.byte == 0x77)
_0x8E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x77)
	BRNE _0x8F
; 0000 059C     {
; 0000 059D       macierz_zaciskow[rzad]=119;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   X+,R30
	ST   X,R31
; 0000 059E       komunikat_z_czytnika_kodow("87-2052",rzad,1);
	__POINTW1FN _0x0,1115
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 059F 
; 0000 05A0     }
; 0000 05A1 if(PORT_CZYTNIK.byte == 0x78)
_0x8F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x78)
	BRNE _0x90
; 0000 05A2     {
; 0000 05A3       macierz_zaciskow[rzad]=120;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   X+,R30
	ST   X,R31
; 0000 05A4       komunikat_z_czytnika_kodow("87-2492",rzad,0);
	__POINTW1FN _0x0,1123
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 05A5 
; 0000 05A6     }
; 0000 05A7 if(PORT_CZYTNIK.byte == 0x79)
_0x90:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x79)
	BRNE _0x91
; 0000 05A8     {
; 0000 05A9       macierz_zaciskow[rzad]=121;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   X+,R30
	ST   X,R31
; 0000 05AA       komunikat_z_czytnika_kodow("86-0935",rzad,0);
	__POINTW1FN _0x0,1131
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 05AB 
; 0000 05AC     }
; 0000 05AD if(PORT_CZYTNIK.byte == 0x7A)
_0x91:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7A)
	BRNE _0x92
; 0000 05AE     {
; 0000 05AF       macierz_zaciskow[rzad]=122;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	ST   X+,R30
	ST   X,R31
; 0000 05B0       komunikat_z_czytnika_kodow("86-1648",rzad,0);
	__POINTW1FN _0x0,1139
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 05B1 
; 0000 05B2     }
; 0000 05B3 if(PORT_CZYTNIK.byte == 0x7B)
_0x92:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7B)
	BRNE _0x93
; 0000 05B4     {
; 0000 05B5       macierz_zaciskow[rzad]=123;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(123)
	LDI  R31,HIGH(123)
	ST   X+,R30
	ST   X,R31
; 0000 05B6       komunikat_z_czytnika_kodow("86-2082",rzad,0);
	__POINTW1FN _0x0,1147
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 05B7 
; 0000 05B8     }
; 0000 05B9 if(PORT_CZYTNIK.byte == 0x7C)
_0x93:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7C)
	BRNE _0x94
; 0000 05BA     {
; 0000 05BB       macierz_zaciskow[rzad]=124;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	ST   X+,R30
	ST   X,R31
; 0000 05BC       komunikat_z_czytnika_kodow("86-2500",rzad,0);
	__POINTW1FN _0x0,1155
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 05BD 
; 0000 05BE     }
; 0000 05BF if(PORT_CZYTNIK.byte == 0x7D)
_0x94:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7D)
	BRNE _0x95
; 0000 05C0     {
; 0000 05C1       macierz_zaciskow[rzad]=125;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   X+,R30
	ST   X,R31
; 0000 05C2       komunikat_z_czytnika_kodow("87-0935",rzad,1);
	__POINTW1FN _0x0,1163
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 05C3 
; 0000 05C4     }
; 0000 05C5 if(PORT_CZYTNIK.byte == 0x7E)
_0x95:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7E)
	BRNE _0x96
; 0000 05C6     {
; 0000 05C7       macierz_zaciskow[rzad]=126;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	ST   X+,R30
	ST   X,R31
; 0000 05C8       komunikat_z_czytnika_kodow("87-1648",rzad,1);
	__POINTW1FN _0x0,1171
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 05C9 
; 0000 05CA     }
; 0000 05CB 
; 0000 05CC if(PORT_CZYTNIK.byte == 0x7F)
_0x96:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7F)
	BRNE _0x97
; 0000 05CD     {
; 0000 05CE       macierz_zaciskow[rzad]=127;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	ST   X+,R30
	ST   X,R31
; 0000 05CF       komunikat_z_czytnika_kodow("87-2082",rzad,1);
	__POINTW1FN _0x0,1179
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 05D0 
; 0000 05D1     }
; 0000 05D2 if(PORT_CZYTNIK.byte == 0x80)
_0x97:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x80)
	BRNE _0x98
; 0000 05D3     {
; 0000 05D4       macierz_zaciskow[rzad]=128;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   X+,R30
	ST   X,R31
; 0000 05D5       komunikat_z_czytnika_kodow("87-2500",rzad,1);
	__POINTW1FN _0x0,1187
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 05D6 
; 0000 05D7     }
; 0000 05D8 if(PORT_CZYTNIK.byte == 0x81)
_0x98:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x81)
	BRNE _0x99
; 0000 05D9     {
; 0000 05DA       macierz_zaciskow[rzad]=129;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(129)
	LDI  R31,HIGH(129)
	ST   X+,R30
	ST   X,R31
; 0000 05DB       komunikat_z_czytnika_kodow("86-1019",rzad,0);
	__POINTW1FN _0x0,1195
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 05DC 
; 0000 05DD     }
; 0000 05DE if(PORT_CZYTNIK.byte == 0x82)
_0x99:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x82)
	BRNE _0x9A
; 0000 05DF     {
; 0000 05E0       macierz_zaciskow[rzad]=130;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	ST   X+,R30
	ST   X,R31
; 0000 05E1       komunikat_z_czytnika_kodow("86-1649",rzad,0);
	__POINTW1FN _0x0,1203
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 05E2 
; 0000 05E3     }
; 0000 05E4 if(PORT_CZYTNIK.byte == 0x83)
_0x9A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x83)
	BRNE _0x9B
; 0000 05E5     {
; 0000 05E6       macierz_zaciskow[rzad]=131;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(131)
	LDI  R31,HIGH(131)
	ST   X+,R30
	ST   X,R31
; 0000 05E7       komunikat_z_czytnika_kodow("86-2083",rzad,1);
	__POINTW1FN _0x0,1211
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 05E8 
; 0000 05E9     }
; 0000 05EA if(PORT_CZYTNIK.byte == 0x84)
_0x9B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x84)
	BRNE _0x9C
; 0000 05EB     {
; 0000 05EC       macierz_zaciskow[rzad]=132;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	ST   X+,R30
	ST   X,R31
; 0000 05ED       komunikat_z_czytnika_kodow("86-2585",rzad,0);
	__POINTW1FN _0x0,1219
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 05EE 
; 0000 05EF     }
; 0000 05F0 if(PORT_CZYTNIK.byte == 0x85)
_0x9C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x85)
	BRNE _0x9D
; 0000 05F1     {
; 0000 05F2       macierz_zaciskow[rzad]=133;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(133)
	LDI  R31,HIGH(133)
	ST   X+,R30
	ST   X,R31
; 0000 05F3       komunikat_z_czytnika_kodow("87-1019",rzad,1);
	__POINTW1FN _0x0,1227
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 05F4 
; 0000 05F5     }
; 0000 05F6 if(PORT_CZYTNIK.byte == 0x86)
_0x9D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x86)
	BRNE _0x9E
; 0000 05F7     {
; 0000 05F8       macierz_zaciskow[rzad]=134;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	ST   X+,R30
	ST   X,R31
; 0000 05F9       komunikat_z_czytnika_kodow("87-1649",rzad,1);
	__POINTW1FN _0x0,1235
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 05FA 
; 0000 05FB     }
; 0000 05FC if(PORT_CZYTNIK.byte == 0x87)
_0x9E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x87)
	BRNE _0x9F
; 0000 05FD     {
; 0000 05FE       macierz_zaciskow[rzad]=135;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(135)
	LDI  R31,HIGH(135)
	ST   X+,R30
	ST   X,R31
; 0000 05FF       komunikat_z_czytnika_kodow("87-2083",rzad,0);
	__POINTW1FN _0x0,1243
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0600 
; 0000 0601     }
; 0000 0602 
; 0000 0603 if(PORT_CZYTNIK.byte == 0x88)
_0x9F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x88)
	BRNE _0xA0
; 0000 0604     {
; 0000 0605       macierz_zaciskow[rzad]=136;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	ST   X+,R30
	ST   X,R31
; 0000 0606       komunikat_z_czytnika_kodow("87-2624",rzad,1);
	__POINTW1FN _0x0,1251
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0607 
; 0000 0608     }
; 0000 0609 if(PORT_CZYTNIK.byte == 0x89)
_0xA0:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x89)
	BRNE _0xA1
; 0000 060A     {
; 0000 060B       macierz_zaciskow[rzad]=137;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(137)
	LDI  R31,HIGH(137)
	ST   X+,R30
	ST   X,R31
; 0000 060C       komunikat_z_czytnika_kodow("86-1027",rzad,0);
	__POINTW1FN _0x0,1259
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 060D 
; 0000 060E     }
; 0000 060F if(PORT_CZYTNIK.byte == 0x8A)
_0xA1:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8A)
	BRNE _0xA2
; 0000 0610     {
; 0000 0611       macierz_zaciskow[rzad]=138;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	ST   X+,R30
	ST   X,R31
; 0000 0612       komunikat_z_czytnika_kodow("86-1669",rzad,1);
	__POINTW1FN _0x0,1267
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0613 
; 0000 0614     }
; 0000 0615 if(PORT_CZYTNIK.byte == 0x8B)
_0xA2:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8B)
	BRNE _0xA3
; 0000 0616     {
; 0000 0617       macierz_zaciskow[rzad]=139;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(139)
	LDI  R31,HIGH(139)
	ST   X+,R30
	ST   X,R31
; 0000 0618       komunikat_z_czytnika_kodow("86-2087",rzad,1);
	__POINTW1FN _0x0,1275
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0619 
; 0000 061A     }
; 0000 061B if(PORT_CZYTNIK.byte == 0x8C)
_0xA3:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8C)
	BRNE _0xA4
; 0000 061C     {
; 0000 061D       macierz_zaciskow[rzad]=140;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	ST   X+,R30
	ST   X,R31
; 0000 061E       komunikat_z_czytnika_kodow("86-2624",rzad,0);
	__POINTW1FN _0x0,1283
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 061F 
; 0000 0620     }
; 0000 0621 if(PORT_CZYTNIK.byte == 0x8D)
_0xA4:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8D)
	BRNE _0xA5
; 0000 0622     {
; 0000 0623       macierz_zaciskow[rzad]=141;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(141)
	LDI  R31,HIGH(141)
	ST   X+,R30
	ST   X,R31
; 0000 0624       komunikat_z_czytnika_kodow("87-1027",rzad,1);
	__POINTW1FN _0x0,1291
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0625 
; 0000 0626     }
; 0000 0627 if(PORT_CZYTNIK.byte == 0x8E)
_0xA5:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8E)
	BRNE _0xA6
; 0000 0628     {
; 0000 0629       macierz_zaciskow[rzad]=142;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	ST   X+,R30
	ST   X,R31
; 0000 062A       komunikat_z_czytnika_kodow("87-1669",rzad,0);
	__POINTW1FN _0x0,1299
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 062B 
; 0000 062C     }
; 0000 062D if(PORT_CZYTNIK.byte == 0x8F)
_0xA6:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8F)
	BRNE _0xA7
; 0000 062E     {
; 0000 062F       macierz_zaciskow[rzad]=143;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(143)
	LDI  R31,HIGH(143)
	ST   X+,R30
	ST   X,R31
; 0000 0630       komunikat_z_czytnika_kodow("87-2087",rzad,0);
	__POINTW1FN _0x0,1307
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 0631 
; 0000 0632     }
; 0000 0633 if(PORT_CZYTNIK.byte == 0x90)
_0xA7:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x90)
	BRNE _0xA8
; 0000 0634     {
; 0000 0635       macierz_zaciskow[rzad]=144;
	MOVW R30,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   X+,R30
	ST   X,R31
; 0000 0636       komunikat_z_czytnika_kodow("87-2585",rzad,1);
	__POINTW1FN _0x0,1315
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0637 
; 0000 0638     }
; 0000 0639 
; 0000 063A 
; 0000 063B return rzad;
_0xA8:
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 063C }
;
;
;void wybor_linijek_sterownikow(int rzad_local)
; 0000 0640 {
_wybor_linijek_sterownikow:
; 0000 0641 //zaczynam od tego
; 0000 0642 //komentarz: celowo upraszam:
; 0000 0643 //  a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 0644 //a[4] = 0x21;    //ster3 ABS             //krazek scierny
; 0000 0645 
; 0000 0646 //legenda pierwotna
; 0000 0647             /*
; 0000 0648             a[0] = 0x05A;   //ster1
; 0000 0649             a[1] = a[0]+0x001;                                   //0x05B;   //ster2
; 0000 064A             a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 064B             a[3] = 0x11;    //ster4 INV             //druciak
; 0000 064C             a[4] = a[2];   //0x21;    //ster3 ABS             //krazek scierny
; 0000 064D             a[5] = 0x196;   //delta okrag
; 0000 064E             a[6] = a[5]+0x001;            //0x197;   //okrag
; 0000 064F             a[7] = 0x12;    //ster3 INV             krazek scierny
; 0000 0650             a[8] = a[6]+0x001;                0x198;   //-delta okrag
; 0000 0651             a[9] = 0;          //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0652             */
; 0000 0653 
; 0000 0654 
; 0000 0655 //macierz_zaciskow[rzad_local]
; 0000 0656 //macierz_zaciskow[rzad_local] = 140;
; 0000 0657 
; 0000 0658 
; 0000 0659 
; 0000 065A switch(macierz_zaciskow[rzad_local])
;	rzad_local -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x8
	CALL __GETW1P
; 0000 065B {
; 0000 065C     case 0:
	SBIW R30,0
	BRNE _0xAC
; 0000 065D 
; 0000 065E             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x10
; 0000 065F             komunikat_na_panel("Nie wczytano zacisku",adr1,adr2);
	__POINTW1FN _0x0,1323
	CALL SUBOPT_0x1B
; 0000 0660 
; 0000 0661     break;
	JMP  _0xAB
; 0000 0662 
; 0000 0663 
; 0000 0664      case 1:
_0xAC:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xAD
; 0000 0665 
; 0000 0666             a[0] = 0x0C8;   //ster1
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x1C
; 0000 0667             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0668             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x1E
; 0000 0669             a[5] = 0x196;   //delta okrag
; 0000 066A             a[7] = 0x11;    //ster3 INV krazek scierny
	JMP  _0x39A
; 0000 066B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 066C 
; 0000 066D             a[1] = a[0]+0x001;  //ster2
; 0000 066E             a[2] = a[4];        //ster4 ABS druciak
; 0000 066F             a[6] = a[5]+0x001;  //okrag
; 0000 0670             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0671 
; 0000 0672     break;
; 0000 0673 
; 0000 0674       case 2:
_0xAD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xAE
; 0000 0675 
; 0000 0676             a[0] = 0x110;   //ster1
	LDI  R30,LOW(272)
	LDI  R31,HIGH(272)
	CALL SUBOPT_0x1C
; 0000 0677             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0678             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x20
; 0000 0679             a[5] = 0x190;   //delta okrag
; 0000 067A             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x1F
; 0000 067B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x21
	JMP  _0x39B
; 0000 067C 
; 0000 067D             a[1] = a[0]+0x001;  //ster2
; 0000 067E             a[2] = a[4];        //ster4 ABS druciak
; 0000 067F             a[6] = a[5]+0x001;  //okrag
; 0000 0680             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0681 
; 0000 0682     break;
; 0000 0683 
; 0000 0684       case 3:
_0xAE:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xAF
; 0000 0685 
; 0000 0686             a[0] = 0x07A;   //ster1
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	CALL SUBOPT_0x1C
; 0000 0687             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0688             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x22
; 0000 0689             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x23
; 0000 068A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 068B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x39B
; 0000 068C 
; 0000 068D             a[1] = a[0]+0x001;  //ster2
; 0000 068E             a[2] = a[4];        //ster4 ABS druciak
; 0000 068F             a[6] = a[5]+0x001;  //okrag
; 0000 0690             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0691 
; 0000 0692     break;
; 0000 0693 
; 0000 0694       case 4:
_0xAF:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xB0
; 0000 0695 
; 0000 0696             a[0] = 0x102;   //ster1
	LDI  R30,LOW(258)
	LDI  R31,HIGH(258)
	CALL SUBOPT_0x1C
; 0000 0697             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0698             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x24
; 0000 0699             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x23
; 0000 069A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 069B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x39B
; 0000 069C 
; 0000 069D             a[1] = a[0]+0x001;  //ster2
; 0000 069E             a[2] = a[4];        //ster4 ABS druciak
; 0000 069F             a[6] = a[5]+0x001;  //okrag
; 0000 06A0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 06A1 
; 0000 06A2     break;
; 0000 06A3 
; 0000 06A4       case 5:
_0xB0:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xB1
; 0000 06A5 
; 0000 06A6             a[0] = 0x0B0;   //ster1
	LDI  R30,LOW(176)
	LDI  R31,HIGH(176)
	CALL SUBOPT_0x1C
; 0000 06A7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 06A8             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x1E
; 0000 06A9             a[5] = 0x196;   //delta okrag
; 0000 06AA             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 06AB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 06AC 
; 0000 06AD             a[1] = a[0]+0x001;  //ster2
; 0000 06AE             a[2] = a[4];        //ster4 ABS druciak
; 0000 06AF             a[6] = a[5]+0x001;  //okrag
; 0000 06B0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 06B1 
; 0000 06B2     break;
; 0000 06B3 
; 0000 06B4       case 6:
_0xB1:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xB2
; 0000 06B5 
; 0000 06B6             a[0] = 0x0FE;   //ster1
	LDI  R30,LOW(254)
	LDI  R31,HIGH(254)
	CALL SUBOPT_0x1C
; 0000 06B7             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 06B8             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x20
; 0000 06B9             a[5] = 0x190;   //delta okrag
; 0000 06BA             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x39A
; 0000 06BB             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 06BC 
; 0000 06BD             a[1] = a[0]+0x001;  //ster2
; 0000 06BE             a[2] = a[4];        //ster4 ABS druciak
; 0000 06BF             a[6] = a[5]+0x001;  //okrag
; 0000 06C0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 06C1 
; 0000 06C2     break;
; 0000 06C3 
; 0000 06C4 
; 0000 06C5       case 7:
_0xB2:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xB3
; 0000 06C6 
; 0000 06C7             a[0] = 0x078;   //ster1
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x1C
; 0000 06C8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 06C9             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x22
; 0000 06CA             a[5] = 0x196;   //delta okrag
	RJMP _0x39C
; 0000 06CB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 06CC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 06CD 
; 0000 06CE             a[1] = a[0]+0x001;  //ster2
; 0000 06CF             a[2] = a[4];        //ster4 ABS druciak
; 0000 06D0             a[6] = a[5]+0x001;  //okrag
; 0000 06D1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 06D2 
; 0000 06D3     break;
; 0000 06D4 
; 0000 06D5 
; 0000 06D6       case 8:
_0xB3:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xB4
; 0000 06D7 
; 0000 06D8             a[0] = 0x0C0;   //ster1
	LDI  R30,LOW(192)
	LDI  R31,HIGH(192)
	CALL SUBOPT_0x1C
; 0000 06D9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 06DA             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x24
; 0000 06DB             a[5] = 0x196;   //delta okrag
	RJMP _0x39C
; 0000 06DC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 06DD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 06DE 
; 0000 06DF             a[1] = a[0]+0x001;  //ster2
; 0000 06E0             a[2] = a[4];        //ster4 ABS druciak
; 0000 06E1             a[6] = a[5]+0x001;  //okrag
; 0000 06E2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 06E3 
; 0000 06E4     break;
; 0000 06E5 
; 0000 06E6 
; 0000 06E7       case 9:
_0xB4:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xB5
; 0000 06E8 
; 0000 06E9             a[0] = 0x018;   //ster1
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL SUBOPT_0x1C
; 0000 06EA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 06EB             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x24
; 0000 06EC             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x26
; 0000 06ED             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 06EE             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 06EF 
; 0000 06F0             a[1] = a[0]+0x001;  //ster2
; 0000 06F1             a[2] = a[4];        //ster4 ABS druciak
; 0000 06F2             a[6] = a[5]+0x001;  //okrag
; 0000 06F3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 06F4 
; 0000 06F5     break;
; 0000 06F6 
; 0000 06F7 
; 0000 06F8       case 10:
_0xB5:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xB6
; 0000 06F9 
; 0000 06FA             a[0] = 0x016;   //ster1
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CALL SUBOPT_0x1C
; 0000 06FB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 06FC             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x27
; 0000 06FD             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x23
; 0000 06FE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 06FF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0700 
; 0000 0701             a[1] = a[0]+0x001;  //ster2
; 0000 0702             a[2] = a[4];        //ster4 ABS druciak
; 0000 0703             a[6] = a[5]+0x001;  //okrag
; 0000 0704             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0705 
; 0000 0706     break;
; 0000 0707 
; 0000 0708 
; 0000 0709       case 11:
_0xB6:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xB7
; 0000 070A 
; 0000 070B             a[0] = 0x074;   //ster1
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	CALL SUBOPT_0x1C
; 0000 070C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 070D             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x28
; 0000 070E             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x23
; 0000 070F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0710             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0711 
; 0000 0712             a[1] = a[0]+0x001;  //ster2
; 0000 0713             a[2] = a[4];        //ster4 ABS druciak
; 0000 0714             a[6] = a[5]+0x001;  //okrag
; 0000 0715             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0716 
; 0000 0717     break;
; 0000 0718 
; 0000 0719 
; 0000 071A       case 12:
_0xB7:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xB8
; 0000 071B 
; 0000 071C             a[0] = 0x096;   //ster1
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x1C
; 0000 071D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 071E             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x29
; 0000 071F             a[5] = 0x199;   //delta okrag
	RJMP _0x39C
; 0000 0720             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0721             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0722 
; 0000 0723             a[1] = a[0]+0x001;  //ster2
; 0000 0724             a[2] = a[4];        //ster4 ABS druciak
; 0000 0725             a[6] = a[5]+0x001;  //okrag
; 0000 0726             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0727 
; 0000 0728     break;
; 0000 0729 
; 0000 072A 
; 0000 072B       case 13:
_0xB8:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xB9
; 0000 072C 
; 0000 072D             a[0] = 0x01A;   //ster1
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	CALL SUBOPT_0x1C
; 0000 072E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 072F             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x24
; 0000 0730             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x26
; 0000 0731             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0732             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0733 
; 0000 0734             a[1] = a[0]+0x001;  //ster2
; 0000 0735             a[2] = a[4];        //ster4 ABS druciak
; 0000 0736             a[6] = a[5]+0x001;  //okrag
; 0000 0737             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0738 
; 0000 0739     break;
; 0000 073A 
; 0000 073B 
; 0000 073C       case 14:
_0xB9:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xBA
; 0000 073D 
; 0000 073E             a[0] = 0x05E;   //ster1
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	CALL SUBOPT_0x1C
; 0000 073F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0740             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x27
; 0000 0741             a[5] = 0x199;   //delta okrag
	RJMP _0x39C
; 0000 0742             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0743             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0744 
; 0000 0745             a[1] = a[0]+0x001;  //ster2
; 0000 0746             a[2] = a[4];        //ster4 ABS druciak
; 0000 0747             a[6] = a[5]+0x001;  //okrag
; 0000 0748             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0749 
; 0000 074A     break;
; 0000 074B 
; 0000 074C 
; 0000 074D       case 15:
_0xBA:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xBB
; 0000 074E 
; 0000 074F             a[0] = 0x084;   //ster1
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	CALL SUBOPT_0x1C
; 0000 0750             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0751             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x28
; 0000 0752             a[5] = 0x199;   //delta okrag
	RJMP _0x39C
; 0000 0753             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0754             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0755 
; 0000 0756             a[1] = a[0]+0x001;  //ster2
; 0000 0757             a[2] = a[4];        //ster4 ABS druciak
; 0000 0758             a[6] = a[5]+0x001;  //okrag
; 0000 0759             a[8] = a[6]+0x001;  //-delta okrag
; 0000 075A 
; 0000 075B     break;
; 0000 075C 
; 0000 075D 
; 0000 075E       case 16:
_0xBB:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xBC
; 0000 075F 
; 0000 0760             a[0] = 0x0B8;   //ster1
	LDI  R30,LOW(184)
	LDI  R31,HIGH(184)
	CALL SUBOPT_0x1C
; 0000 0761             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0762             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x2A
; 0000 0763             a[5] = 0x199;   //delta okrag
; 0000 0764             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0765             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0766 
; 0000 0767             a[1] = a[0]+0x001;  //ster2
; 0000 0768             a[2] = a[4];        //ster4 ABS druciak
; 0000 0769             a[6] = a[5]+0x001;  //okrag
; 0000 076A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 076B 
; 0000 076C     break;
; 0000 076D 
; 0000 076E       case 17:
_0xBC:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xBD
; 0000 076F 
; 0000 0770             a[0] = 0x020;   //ster1
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x1C
; 0000 0771             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0772             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x1E
; 0000 0773             a[5] = 0x196;   //delta okrag
; 0000 0774             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0775             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0776 
; 0000 0777             a[1] = a[0]+0x001;  //ster2
; 0000 0778             a[2] = a[4];        //ster4 ABS druciak
; 0000 0779             a[6] = a[5]+0x001;  //okrag
; 0000 077A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 077B 
; 0000 077C     break;
; 0000 077D 
; 0000 077E 
; 0000 077F       case 18:
_0xBD:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xBE
; 0000 0780 
; 0000 0781             a[0] = 0x098;   //ster1
	LDI  R30,LOW(152)
	LDI  R31,HIGH(152)
	CALL SUBOPT_0x1C
; 0000 0782             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0783             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x2B
; 0000 0784             a[5] = 0x190;   //delta okrag
; 0000 0785             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x1F
; 0000 0786             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x21
	RJMP _0x39B
; 0000 0787 
; 0000 0788             a[1] = a[0]+0x001;  //ster2
; 0000 0789             a[2] = a[4];        //ster4 ABS druciak
; 0000 078A             a[6] = a[5]+0x001;  //okrag
; 0000 078B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 078C 
; 0000 078D     break;
; 0000 078E 
; 0000 078F 
; 0000 0790 
; 0000 0791       case 19:
_0xBE:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xBF
; 0000 0792 
; 0000 0793             a[0] = 0x0AA;   //ster1
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	CALL SUBOPT_0x1C
; 0000 0794             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0795             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x2C
; 0000 0796             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x2D
; 0000 0797             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0798             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0799 
; 0000 079A             a[1] = a[0]+0x001;  //ster2
; 0000 079B             a[2] = a[4];        //ster4 ABS druciak
; 0000 079C             a[6] = a[5]+0x001;  //okrag
; 0000 079D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 079E 
; 0000 079F     break;
; 0000 07A0 
; 0000 07A1 
; 0000 07A2       case 20:
_0xBF:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0xC0
; 0000 07A3 
; 0000 07A4             a[0] = 0x042;   //ster1
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	CALL SUBOPT_0x1C
; 0000 07A5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 07A6             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x2C
; 0000 07A7             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x2E
; 0000 07A8             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 07A9             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 07AA 
; 0000 07AB             a[1] = a[0]+0x001;  //ster2
; 0000 07AC             a[2] = a[4];        //ster4 ABS druciak
; 0000 07AD             a[6] = a[5]+0x001;  //okrag
; 0000 07AE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07AF 
; 0000 07B0     break;
; 0000 07B1 
; 0000 07B2 
; 0000 07B3       case 21:
_0xC0:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0xC1
; 0000 07B4 
; 0000 07B5             a[0] = 0x04E;   //ster1
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	CALL SUBOPT_0x1C
; 0000 07B6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 07B7             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x1E
; 0000 07B8             a[5] = 0x196;   //delta okrag
; 0000 07B9             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 07BA             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07BB 
; 0000 07BC             a[1] = a[0]+0x001;  //ster2
; 0000 07BD             a[2] = a[4];        //ster4 ABS druciak
; 0000 07BE             a[6] = a[5]+0x001;  //okrag
; 0000 07BF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07C0 
; 0000 07C1     break;
; 0000 07C2 
; 0000 07C3       case 22:
_0xC1:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0xC2
; 0000 07C4 
; 0000 07C5             a[0] = 0x0C2;   //ster1
	LDI  R30,LOW(194)
	LDI  R31,HIGH(194)
	CALL SUBOPT_0x1C
; 0000 07C6             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 07C7             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x2B
; 0000 07C8             a[5] = 0x190;   //delta okrag
; 0000 07C9             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x39A
; 0000 07CA             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07CB 
; 0000 07CC             a[1] = a[0]+0x001;  //ster2
; 0000 07CD             a[2] = a[4];        //ster4 ABS druciak
; 0000 07CE             a[6] = a[5]+0x001;  //okrag
; 0000 07CF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07D0 
; 0000 07D1     break;
; 0000 07D2 
; 0000 07D3 
; 0000 07D4       case 23:
_0xC2:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0xC3
; 0000 07D5 
; 0000 07D6             a[0] = 0x0CE;   //ster1
	LDI  R30,LOW(206)
	LDI  R31,HIGH(206)
	CALL SUBOPT_0x1C
; 0000 07D7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 07D8             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x2C
; 0000 07D9             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x39C
; 0000 07DA             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07DB             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07DC 
; 0000 07DD             a[1] = a[0]+0x001;  //ster2
; 0000 07DE             a[2] = a[4];        //ster4 ABS druciak
; 0000 07DF             a[6] = a[5]+0x001;  //okrag
; 0000 07E0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07E1 
; 0000 07E2     break;
; 0000 07E3 
; 0000 07E4 
; 0000 07E5       case 24:
_0xC3:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0xC4
; 0000 07E6 
; 0000 07E7             a[0] = 0x040;   //ster1
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL SUBOPT_0x1C
; 0000 07E8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 07E9             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x2C
; 0000 07EA             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x2E
; 0000 07EB             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 07EC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07ED 
; 0000 07EE             a[1] = a[0]+0x001;  //ster2
; 0000 07EF             a[2] = a[4];        //ster4 ABS druciak
; 0000 07F0             a[6] = a[5]+0x001;  //okrag
; 0000 07F1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07F2 
; 0000 07F3     break;
; 0000 07F4 
; 0000 07F5       case 25:
_0xC4:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0xC5
; 0000 07F6 
; 0000 07F7             a[0] = 0x02E;   //ster1
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	CALL SUBOPT_0x1C
; 0000 07F8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 07F9             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x27
; 0000 07FA             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x23
; 0000 07FB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07FC             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 07FD 
; 0000 07FE             a[1] = a[0]+0x001;  //ster2
; 0000 07FF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0800             a[6] = a[5]+0x001;  //okrag
; 0000 0801             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0802 
; 0000 0803     break;
; 0000 0804 
; 0000 0805       case 26:
_0xC5:
	CPI  R30,LOW(0x1A)
	LDI  R26,HIGH(0x1A)
	CPC  R31,R26
	BRNE _0xC6
; 0000 0806 
; 0000 0807             a[0] = 0x0FA;   //ster1
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x1C
; 0000 0808             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0809             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x2F
; 0000 080A             a[5] = 0x190;   //delta okrag
; 0000 080B             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 080C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 080D 
; 0000 080E             a[1] = a[0]+0x001;  //ster2
; 0000 080F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0810             a[6] = a[5]+0x001;  //okrag
; 0000 0811             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0812 
; 0000 0813     break;
; 0000 0814 
; 0000 0815 
; 0000 0816       case 27:
_0xC6:
	CPI  R30,LOW(0x1B)
	LDI  R26,HIGH(0x1B)
	CPC  R31,R26
	BRNE _0xC7
; 0000 0817 
; 0000 0818             a[0] = 0x06C;   //ster1
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	CALL SUBOPT_0x1C
; 0000 0819             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 081A             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x2A
; 0000 081B             a[5] = 0x199;   //delta okrag
; 0000 081C             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 081D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 081E 
; 0000 081F             a[1] = a[0]+0x001;  //ster2
; 0000 0820             a[2] = a[4];        //ster4 ABS druciak
; 0000 0821             a[6] = a[5]+0x001;  //okrag
; 0000 0822             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0823 
; 0000 0824     break;
; 0000 0825 
; 0000 0826 
; 0000 0827       case 28:
_0xC7:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BRNE _0xC8
; 0000 0828 
; 0000 0829             a[0] = 0x0A4;   //ster1
	LDI  R30,LOW(164)
	LDI  R31,HIGH(164)
	CALL SUBOPT_0x1C
; 0000 082A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 082B             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x29
; 0000 082C             a[5] = 0x199;   //delta okrag
	RJMP _0x39C
; 0000 082D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 082E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 082F 
; 0000 0830             a[1] = a[0]+0x001;  //ster2
; 0000 0831             a[2] = a[4];        //ster4 ABS druciak
; 0000 0832             a[6] = a[5]+0x001;  //okrag
; 0000 0833             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0834 
; 0000 0835     break;
; 0000 0836 
; 0000 0837       case 29:
_0xC8:
	CPI  R30,LOW(0x1D)
	LDI  R26,HIGH(0x1D)
	CPC  R31,R26
	BRNE _0xC9
; 0000 0838 
; 0000 0839             a[0] = 0x02A;   //ster1
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	CALL SUBOPT_0x1C
; 0000 083A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 083B             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x27
; 0000 083C             a[5] = 0x199;   //delta okrag
	RJMP _0x39C
; 0000 083D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 083E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 083F 
; 0000 0840             a[1] = a[0]+0x001;  //ster2
; 0000 0841             a[2] = a[4];        //ster4 ABS druciak
; 0000 0842             a[6] = a[5]+0x001;  //okrag
; 0000 0843             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0844 
; 0000 0845     break;
; 0000 0846 
; 0000 0847       case 30:
_0xC9:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0xCA
; 0000 0848 
; 0000 0849             a[0] = 0x094;   //ster1
	LDI  R30,LOW(148)
	LDI  R31,HIGH(148)
	CALL SUBOPT_0x1C
; 0000 084A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 084B             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x2F
; 0000 084C             a[5] = 0x190;   //delta okrag
; 0000 084D             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 084E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 084F 
; 0000 0850             a[1] = a[0]+0x001;  //ster2
; 0000 0851             a[2] = a[4];        //ster4 ABS druciak
; 0000 0852             a[6] = a[5]+0x001;  //okrag
; 0000 0853             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0854 
; 0000 0855     break;
; 0000 0856 
; 0000 0857       case 31:
_0xCA:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0xCB
; 0000 0858 
; 0000 0859             a[0] = 0x06E;   //ster1
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	CALL SUBOPT_0x1C
; 0000 085A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 085B             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x30
; 0000 085C             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x39C
; 0000 085D             a[7] = 0x12;  //ster3 INV krazek scierny
; 0000 085E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 085F 
; 0000 0860             a[1] = a[0]+0x001;  //ster2
; 0000 0861             a[2] = a[4];        //ster4 ABS druciak
; 0000 0862             a[6] = a[5]+0x001;  //okrag
; 0000 0863             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0864 
; 0000 0865     break;
; 0000 0866 
; 0000 0867 
; 0000 0868        case 32:
_0xCB:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xCC
; 0000 0869 
; 0000 086A             a[0] = 0x086;   //ster1
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	CALL SUBOPT_0x1C
; 0000 086B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 086C             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x29
; 0000 086D             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x23
; 0000 086E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 086F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0870 
; 0000 0871             a[1] = a[0]+0x001;  //ster2
; 0000 0872             a[2] = a[4];        //ster4 ABS druciak
; 0000 0873             a[6] = a[5]+0x001;  //okrag
; 0000 0874             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0875 
; 0000 0876     break;
; 0000 0877 
; 0000 0878        case 33:
_0xCC:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0xCD
; 0000 0879 
; 0000 087A             a[0] = 0x08E;   //ster1
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	CALL SUBOPT_0x1C
; 0000 087B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 087C             a[4] = 0x20;    //ster3 ABS krazek scierny
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	RJMP _0x39D
; 0000 087D             a[5] = 0x19C;   //delta okrag
; 0000 087E             a[7] = 0x12;    //ster3 INV krazek scierny
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
; 0000 0889     case 34: //86-1349
_0xCD:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0xCE
; 0000 088A 
; 0000 088B             a[0] = 0x05A;   //ster1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x1C
; 0000 088C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 088D             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x31
; 0000 088E             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x32
; 0000 088F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0890             a[9] = 0;       //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0891 
; 0000 0892             a[1] = a[0]+0x001;  //ster2
; 0000 0893             a[2] = a[4];        //ster4 ABS druciak
; 0000 0894             a[6] = a[5]+0x001;  //okrag
; 0000 0895             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0896 
; 0000 0897     break;
; 0000 0898 
; 0000 0899 
; 0000 089A     case 35:
_0xCE:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0xCF
; 0000 089B 
; 0000 089C             a[0] = 0x0DA;   //ster1
	LDI  R30,LOW(218)
	LDI  R31,HIGH(218)
	CALL SUBOPT_0x1C
; 0000 089D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 089E             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x33
; 0000 089F             a[5] = 0x190;   //delta okrag
; 0000 08A0             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 08A1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 08A2 
; 0000 08A3             a[1] = a[0]+0x001;  //ster2
; 0000 08A4             a[2] = a[4];        //ster4 ABS druciak
; 0000 08A5             a[6] = a[5]+0x001;  //okrag
; 0000 08A6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08A7 
; 0000 08A8     break;
; 0000 08A9 
; 0000 08AA          case 36:
_0xCF:
	CPI  R30,LOW(0x24)
	LDI  R26,HIGH(0x24)
	CPC  R31,R26
	BRNE _0xD0
; 0000 08AB 
; 0000 08AC             a[0] = 0x0A2;   //ster1
	LDI  R30,LOW(162)
	LDI  R31,HIGH(162)
	CALL SUBOPT_0x1C
; 0000 08AD             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x34
; 0000 08AE             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 08AF             a[5] = 0x196;   //delta okrag
; 0000 08B0             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x1F
; 0000 08B1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x21
	RJMP _0x39B
; 0000 08B2 
; 0000 08B3             a[1] = a[0]+0x001;  //ster2
; 0000 08B4             a[2] = a[4];        //ster4 ABS druciak
; 0000 08B5             a[6] = a[5]+0x001;  //okrag
; 0000 08B6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08B7 
; 0000 08B8     break;
; 0000 08B9 
; 0000 08BA          case 37:
_0xD0:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0xD1
; 0000 08BB 
; 0000 08BC             a[0] = 0x104;   //ster1
	LDI  R30,LOW(260)
	LDI  R31,HIGH(260)
	CALL SUBOPT_0x1C
; 0000 08BD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 08BE             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x31
; 0000 08BF             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x35
; 0000 08C0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08C1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 08C2 
; 0000 08C3             a[1] = a[0]+0x001;  //ster2
; 0000 08C4             a[2] = a[4];        //ster4 ABS druciak
; 0000 08C5             a[6] = a[5]+0x001;  //okrag
; 0000 08C6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08C7 
; 0000 08C8     break;
; 0000 08C9 
; 0000 08CA          case 38:
_0xD1:
	CPI  R30,LOW(0x26)
	LDI  R26,HIGH(0x26)
	CPC  R31,R26
	BRNE _0xD2
; 0000 08CB 
; 0000 08CC             a[0] = 0x036;   //ster1
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	CALL SUBOPT_0x1C
; 0000 08CD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 08CE             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x31
; 0000 08CF             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x39C
; 0000 08D0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08D1             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08D2 
; 0000 08D3             a[1] = a[0]+0x001;  //ster2
; 0000 08D4             a[2] = a[4];        //ster4 ABS druciak
; 0000 08D5             a[6] = a[5]+0x001;  //okrag
; 0000 08D6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08D7 
; 0000 08D8     break;
; 0000 08D9 
; 0000 08DA 
; 0000 08DB          case 39:
_0xD2:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0xD3
; 0000 08DC 
; 0000 08DD             a[0] = 0x118;   //ster1
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	CALL SUBOPT_0x1C
; 0000 08DE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 08DF             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x33
; 0000 08E0             a[5] = 0x190;   //delta okrag
; 0000 08E1             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 08E2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08E3 
; 0000 08E4             a[1] = a[0]+0x001;  //ster2
; 0000 08E5             a[2] = a[4];        //ster4 ABS druciak
; 0000 08E6             a[6] = a[5]+0x001;  //okrag
; 0000 08E7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08E8 
; 0000 08E9     break;
; 0000 08EA 
; 0000 08EB 
; 0000 08EC          case 40:
_0xD3:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0xD4
; 0000 08ED 
; 0000 08EE             a[0] = 0x0A6;   //ster1
	LDI  R30,LOW(166)
	LDI  R31,HIGH(166)
	CALL SUBOPT_0x1C
; 0000 08EF             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x34
; 0000 08F0             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 08F1             a[5] = 0x196;   //delta okrag
; 0000 08F2             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x39A
; 0000 08F3             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08F4 
; 0000 08F5             a[1] = a[0]+0x001;  //ster2
; 0000 08F6             a[2] = a[4];        //ster4 ABS druciak
; 0000 08F7             a[6] = a[5]+0x001;  //okrag
; 0000 08F8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08F9 
; 0000 08FA     break;
; 0000 08FB 
; 0000 08FC          case 41:
_0xD4:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0xD5
; 0000 08FD 
; 0000 08FE             a[0] = 0x01E;   //ster1
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x1C
; 0000 08FF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0900             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x24
; 0000 0901             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x26
; 0000 0902             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0903             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0904 
; 0000 0905             a[1] = a[0]+0x001;  //ster2
; 0000 0906             a[2] = a[4];        //ster4 ABS druciak
; 0000 0907             a[6] = a[5]+0x001;  //okrag
; 0000 0908             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0909 
; 0000 090A     break;
; 0000 090B 
; 0000 090C 
; 0000 090D          case 42:
_0xD5:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0xD6
; 0000 090E 
; 0000 090F             a[0] = 0x05C;   //ster1
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x1C
; 0000 0910             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0911             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x36
; 0000 0912             a[5] = 0x196;   //delta okrag
; 0000 0913             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0914             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0915 
; 0000 0916             a[1] = a[0]+0x001;  //ster2
; 0000 0917             a[2] = a[4];        //ster4 ABS druciak
; 0000 0918             a[6] = a[5]+0x001;  //okrag
; 0000 0919             a[8] = a[6]+0x001;  //-delta okrag
; 0000 091A 
; 0000 091B     break;
; 0000 091C 
; 0000 091D 
; 0000 091E          case 43:
_0xD6:
	CPI  R30,LOW(0x2B)
	LDI  R26,HIGH(0x2B)
	CPC  R31,R26
	BRNE _0xD7
; 0000 091F 
; 0000 0920             a[0] = 0x062;   //ster1
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL SUBOPT_0x1C
; 0000 0921             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0922             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x30
; 0000 0923             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x32
; 0000 0924             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0925             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0926 
; 0000 0927             a[1] = a[0]+0x001;  //ster2
; 0000 0928             a[2] = a[4];        //ster4 ABS druciak
; 0000 0929             a[6] = a[5]+0x001;  //okrag
; 0000 092A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 092B 
; 0000 092C     break;
; 0000 092D 
; 0000 092E 
; 0000 092F          case 44:
_0xD7:
	CPI  R30,LOW(0x2C)
	LDI  R26,HIGH(0x2C)
	CPC  R31,R26
	BRNE _0xD8
; 0000 0930 
; 0000 0931             a[0] = 0x;   //ster1
	CALL SUBOPT_0x37
; 0000 0932             a[3] = 0x;    //ster4 INV druciak
; 0000 0933             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0934             a[5] = 0x;   //delta okrag
; 0000 0935             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0936             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0937 
; 0000 0938             a[1] = a[0]+0x001;  //ster2
; 0000 0939             a[2] = a[4];        //ster4 ABS druciak
; 0000 093A             a[6] = a[5]+0x001;  //okrag
; 0000 093B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 093C 
; 0000 093D     break;
; 0000 093E 
; 0000 093F 
; 0000 0940          case 45:
_0xD8:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0xD9
; 0000 0941 
; 0000 0942             a[0] = 0x010;   //ster1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x1C
; 0000 0943             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0944             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x24
; 0000 0945             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x26
; 0000 0946             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0947             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0948 
; 0000 0949             a[1] = a[0]+0x001;  //ster2
; 0000 094A             a[2] = a[4];        //ster4 ABS druciak
; 0000 094B             a[6] = a[5]+0x001;  //okrag
; 0000 094C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 094D 
; 0000 094E     break;
; 0000 094F 
; 0000 0950 
; 0000 0951     case 46:
_0xD9:
	CPI  R30,LOW(0x2E)
	LDI  R26,HIGH(0x2E)
	CPC  R31,R26
	BRNE _0xDA
; 0000 0952 
; 0000 0953             a[0] = 0x050;   //ster1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x1C
; 0000 0954             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0955             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x36
; 0000 0956             a[5] = 0x196;   //delta okrag
; 0000 0957             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0958             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0959 
; 0000 095A             a[1] = a[0]+0x001;  //ster2
; 0000 095B             a[2] = a[4];        //ster4 ABS druciak
; 0000 095C             a[6] = a[5]+0x001;  //okrag
; 0000 095D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 095E 
; 0000 095F     break;
; 0000 0960 
; 0000 0961 
; 0000 0962     case 47:
_0xDA:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BRNE _0xDB
; 0000 0963 
; 0000 0964             a[0] = 0x068;   //ster1
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	CALL SUBOPT_0x1C
; 0000 0965             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0966             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x30
; 0000 0967             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x39C
; 0000 0968             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0969             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 096A 
; 0000 096B             a[1] = a[0]+0x001;  //ster2
; 0000 096C             a[2] = a[4];        //ster4 ABS druciak
; 0000 096D             a[6] = a[5]+0x001;  //okrag
; 0000 096E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 096F 
; 0000 0970     break;
; 0000 0971 
; 0000 0972 
; 0000 0973 
; 0000 0974     case 48:
_0xDB:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0xDC
; 0000 0975 
; 0000 0976             a[0] = 0x;   //ster1
	CALL SUBOPT_0x37
; 0000 0977             a[3] = 0x;    //ster4 INV druciak
; 0000 0978             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0979             a[5] = 0x;   //delta okrag
; 0000 097A             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 097B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 097C 
; 0000 097D             a[1] = a[0]+0x001;  //ster2
; 0000 097E             a[2] = a[4];        //ster4 ABS druciak
; 0000 097F             a[6] = a[5]+0x001;  //okrag
; 0000 0980             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0981 
; 0000 0982     break;
; 0000 0983 
; 0000 0984 
; 0000 0985     case 49:
_0xDC:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xDD
; 0000 0986 
; 0000 0987             a[0] = 0x024;   //ster1
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL SUBOPT_0x1C
; 0000 0988             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0989             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x24
; 0000 098A             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x23
; 0000 098B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 098C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 098D 
; 0000 098E             a[1] = a[0]+0x001;  //ster2
; 0000 098F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0990             a[6] = a[5]+0x001;  //okrag
; 0000 0991             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0992 
; 0000 0993     break;
; 0000 0994 
; 0000 0995 
; 0000 0996     case 50:
_0xDD:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0xDE
; 0000 0997 
; 0000 0998             a[0] = 0x014;   //ster1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x1C
; 0000 0999             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 099A             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x33
; 0000 099B             a[5] = 0x190;   //delta okrag
; 0000 099C             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 099D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 099E 
; 0000 099F             a[1] = a[0]+0x001;  //ster2
; 0000 09A0             a[2] = a[4];        //ster4 ABS druciak
; 0000 09A1             a[6] = a[5]+0x001;  //okrag
; 0000 09A2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09A3 
; 0000 09A4     break;
; 0000 09A5 
; 0000 09A6     case 51:
_0xDE:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0xDF
; 0000 09A7 
; 0000 09A8             a[0] = 0x082;   //ster1
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	CALL SUBOPT_0x1C
; 0000 09A9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 09AA             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x38
; 0000 09AB             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x35
; 0000 09AC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 09AD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 09AE 
; 0000 09AF             a[1] = a[0]+0x001;  //ster2
; 0000 09B0             a[2] = a[4];        //ster4 ABS druciak
; 0000 09B1             a[6] = a[5]+0x001;  //okrag
; 0000 09B2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09B3 
; 0000 09B4     break;
; 0000 09B5 
; 0000 09B6     case 52:
_0xDF:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0xE0
; 0000 09B7 
; 0000 09B8             a[0] = 0x106;   //ster1
	LDI  R30,LOW(262)
	LDI  R31,HIGH(262)
	CALL SUBOPT_0x1C
; 0000 09B9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 09BA             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x39
; 0000 09BB             a[5] = 0x190;   //delta okrag
; 0000 09BC             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 09BD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09BE 
; 0000 09BF             a[1] = a[0]+0x001;  //ster2
; 0000 09C0             a[2] = a[4];        //ster4 ABS druciak
; 0000 09C1             a[6] = a[5]+0x001;  //okrag
; 0000 09C2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09C3 
; 0000 09C4     break;
; 0000 09C5 
; 0000 09C6 
; 0000 09C7     case 53:
_0xE0:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0xE1
; 0000 09C8 
; 0000 09C9             a[0] = 0x04C;   //ster1
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x1C
; 0000 09CA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 09CB             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x24
; 0000 09CC             a[5] = 0x196;   //delta okrag
	RJMP _0x39C
; 0000 09CD             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 09CE             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09CF 
; 0000 09D0             a[1] = a[0]+0x001;  //ster2
; 0000 09D1             a[2] = a[4];        //ster4 ABS druciak
; 0000 09D2             a[6] = a[5]+0x001;  //okrag
; 0000 09D3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09D4 
; 0000 09D5     break;
; 0000 09D6 
; 0000 09D7 
; 0000 09D8     case 54:
_0xE1:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0xE2
; 0000 09D9 
; 0000 09DA             a[0] = 0x01C;   //ster1
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	CALL SUBOPT_0x1C
; 0000 09DB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 09DC             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x33
; 0000 09DD             a[5] = 0x190;   //delta okrag
; 0000 09DE             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 09DF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09E0 
; 0000 09E1             a[1] = a[0]+0x001;  //ster2
; 0000 09E2             a[2] = a[4];        //ster4 ABS druciak
; 0000 09E3             a[6] = a[5]+0x001;  //okrag
; 0000 09E4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09E5 
; 0000 09E6     break;
; 0000 09E7 
; 0000 09E8     case 55:
_0xE2:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0xE3
; 0000 09E9 
; 0000 09EA             a[0] = 0x114;   //ster1
	LDI  R30,LOW(276)
	LDI  R31,HIGH(276)
	CALL SUBOPT_0x1C
; 0000 09EB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 09EC             a[4] = 0x1A;    //ster3 ABS krazek scierny
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	RJMP _0x39D
; 0000 09ED             a[5] = 0x19C;   //delta okrag
; 0000 09EE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 09EF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09F0 
; 0000 09F1             a[1] = a[0]+0x001;  //ster2
; 0000 09F2             a[2] = a[4];        //ster4 ABS druciak
; 0000 09F3             a[6] = a[5]+0x001;  //okrag
; 0000 09F4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09F5 
; 0000 09F6     break;
; 0000 09F7 
; 0000 09F8 
; 0000 09F9     case 56:
_0xE3:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0xE4
; 0000 09FA 
; 0000 09FB             a[0] = 0x0EE;   //ster1
	LDI  R30,LOW(238)
	LDI  R31,HIGH(238)
	CALL SUBOPT_0x1C
; 0000 09FC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 09FD             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x39
; 0000 09FE             a[5] = 0x190;   //delta okrag
; 0000 09FF             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0A00             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0A01 
; 0000 0A02             a[1] = a[0]+0x001;  //ster2
; 0000 0A03             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A04             a[6] = a[5]+0x001;  //okrag
; 0000 0A05             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A06 
; 0000 0A07     break;
; 0000 0A08 
; 0000 0A09 
; 0000 0A0A     case 57:
_0xE4:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0xE5
; 0000 0A0B 
; 0000 0A0C             a[0] = 0x0F8;   //ster1
	LDI  R30,LOW(248)
	LDI  R31,HIGH(248)
	CALL SUBOPT_0x1C
; 0000 0A0D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0A0E             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3A
; 0000 0A0F             a[5] = 0x190;   //delta okrag
; 0000 0A10             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0A11             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0A12 
; 0000 0A13             a[1] = a[0]+0x001;  //ster2
; 0000 0A14             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A15             a[6] = a[5]+0x001;  //okrag
; 0000 0A16             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A17 
; 0000 0A18     break;
; 0000 0A19 
; 0000 0A1A 
; 0000 0A1B     case 58:
_0xE5:
	CPI  R30,LOW(0x3A)
	LDI  R26,HIGH(0x3A)
	CPC  R31,R26
	BRNE _0xE6
; 0000 0A1C 
; 0000 0A1D             a[0] = 0x0E4;   //ster1
	LDI  R30,LOW(228)
	LDI  R31,HIGH(228)
	CALL SUBOPT_0x1C
; 0000 0A1E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0A1F             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x30
; 0000 0A20             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x32
; 0000 0A21             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A22             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0A23 
; 0000 0A24             a[1] = a[0]+0x001;  //ster2
; 0000 0A25             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A26             a[6] = a[5]+0x001;  //okrag
; 0000 0A27             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A28 
; 0000 0A29     break;
; 0000 0A2A 
; 0000 0A2B 
; 0000 0A2C     case 59:
_0xE6:
	CPI  R30,LOW(0x3B)
	LDI  R26,HIGH(0x3B)
	CPC  R31,R26
	BRNE _0xE7
; 0000 0A2D 
; 0000 0A2E             a[0] = 0x052;   //ster1
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	CALL SUBOPT_0x1C
; 0000 0A2F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0A30             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0A31             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x2D
; 0000 0A32             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A33             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0A34 
; 0000 0A35             a[1] = a[0]+0x001;  //ster2
; 0000 0A36             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A37             a[6] = a[5]+0x001;  //okrag
; 0000 0A38             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A39 
; 0000 0A3A     break;
; 0000 0A3B 
; 0000 0A3C 
; 0000 0A3D     case 60:
_0xE7:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BRNE _0xE8
; 0000 0A3E 
; 0000 0A3F             a[0] = 0x090;   //ster1
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0x1C
; 0000 0A40             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0A41             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 0A42             a[5] = 0x190;   //delta okrag
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL SUBOPT_0x26
; 0000 0A43             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0A44             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0A45 
; 0000 0A46             a[1] = a[0]+0x001;  //ster2
; 0000 0A47             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A48             a[6] = a[5]+0x001;  //okrag
; 0000 0A49             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A4A 
; 0000 0A4B     break;
; 0000 0A4C 
; 0000 0A4D 
; 0000 0A4E     case 61:
_0xE8:
	CPI  R30,LOW(0x3D)
	LDI  R26,HIGH(0x3D)
	CPC  R31,R26
	BRNE _0xE9
; 0000 0A4F 
; 0000 0A50             a[0] = 0x0FC;   //ster1
	LDI  R30,LOW(252)
	LDI  R31,HIGH(252)
	CALL SUBOPT_0x1C
; 0000 0A51             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0A52             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x2F
; 0000 0A53             a[5] = 0x190;   //delta okrag
; 0000 0A54             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0A55             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A56 
; 0000 0A57             a[1] = a[0]+0x001;  //ster2
; 0000 0A58             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A59             a[6] = a[5]+0x001;  //okrag
; 0000 0A5A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A5B 
; 0000 0A5C     break;
; 0000 0A5D 
; 0000 0A5E 
; 0000 0A5F     case 62:
_0xE9:
	CPI  R30,LOW(0x3E)
	LDI  R26,HIGH(0x3E)
	CPC  R31,R26
	BRNE _0xEA
; 0000 0A60 
; 0000 0A61             a[0] = 0x028;   //ster1
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x1C
; 0000 0A62             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0A63             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x30
; 0000 0A64             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x39C
; 0000 0A65             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A66             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A67 
; 0000 0A68             a[1] = a[0]+0x001;  //ster2
; 0000 0A69             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A6A             a[6] = a[5]+0x001;  //okrag
; 0000 0A6B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A6C 
; 0000 0A6D     break;
; 0000 0A6E 
; 0000 0A6F 
; 0000 0A70     case 63:
_0xEA:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0xEB
; 0000 0A71 
; 0000 0A72             a[0] = 0x034;   //ster1
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	CALL SUBOPT_0x1C
; 0000 0A73             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0A74             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0A75             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x39C
; 0000 0A76             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A77             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A78 
; 0000 0A79             a[1] = a[0]+0x001;  //ster2
; 0000 0A7A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A7B             a[6] = a[5]+0x001;  //okrag
; 0000 0A7C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A7D 
; 0000 0A7E     break;
; 0000 0A7F 
; 0000 0A80 
; 0000 0A81     case 64:
_0xEB:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0xEC
; 0000 0A82 
; 0000 0A83             a[0] = 0x0EC;   //ster1
	LDI  R30,LOW(236)
	LDI  R31,HIGH(236)
	CALL SUBOPT_0x1C
; 0000 0A84             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0A85             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3A
; 0000 0A86             a[5] = 0x190;   //delta okrag
; 0000 0A87             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0A88             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A89 
; 0000 0A8A             a[1] = a[0]+0x001;  //ster2
; 0000 0A8B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A8C             a[6] = a[5]+0x001;  //okrag
; 0000 0A8D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A8E 
; 0000 0A8F     break;
; 0000 0A90 
; 0000 0A91 
; 0000 0A92     case 65:
_0xEC:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0xED
; 0000 0A93 
; 0000 0A94             a[0] = 0x0CC;   //ster1
	LDI  R30,LOW(204)
	LDI  R31,HIGH(204)
	CALL SUBOPT_0x1C
; 0000 0A95             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0A96             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 0A97             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x23
; 0000 0A98             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A99             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0A9A 
; 0000 0A9B             a[1] = a[0]+0x001;  //ster2
; 0000 0A9C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A9D             a[6] = a[5]+0x001;  //okrag
; 0000 0A9E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A9F 
; 0000 0AA0     break;
; 0000 0AA1 
; 0000 0AA2 
; 0000 0AA3     case 66:
_0xED:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0xEE
; 0000 0AA4 
; 0000 0AA5             a[0] = 0x0BC;   //ster1
	LDI  R30,LOW(188)
	LDI  R31,HIGH(188)
	CALL SUBOPT_0x1C
; 0000 0AA6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0AA7             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0AA8             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3E
; 0000 0AA9             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0AAA             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AAB 
; 0000 0AAC             a[1] = a[0]+0x001;  //ster2
; 0000 0AAD             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AAE             a[6] = a[5]+0x001;  //okrag
; 0000 0AAF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AB0 
; 0000 0AB1     break;
; 0000 0AB2 
; 0000 0AB3 
; 0000 0AB4     case 67:
_0xEE:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xEF
; 0000 0AB5 
; 0000 0AB6             a[0] = 0x09C;   //ster1
	LDI  R30,LOW(156)
	LDI  R31,HIGH(156)
	CALL SUBOPT_0x1C
; 0000 0AB7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0AB8             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0AB9             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x39C
; 0000 0ABA             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0ABB             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0ABC 
; 0000 0ABD             a[1] = a[0]+0x001;  //ster2
; 0000 0ABE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0ABF             a[6] = a[5]+0x001;  //okrag
; 0000 0AC0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AC1 
; 0000 0AC2     break;
; 0000 0AC3 
; 0000 0AC4 
; 0000 0AC5     case 68:
_0xEF:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0xF0
; 0000 0AC6 
; 0000 0AC7             a[0] = 0x07C;   //ster1
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	CALL SUBOPT_0x1C
; 0000 0AC8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0AC9             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x29
; 0000 0ACA             a[5] = 0x199;   //delta okrag
	RJMP _0x39C
; 0000 0ACB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0ACC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0ACD 
; 0000 0ACE             a[1] = a[0]+0x001;  //ster2
; 0000 0ACF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AD0             a[6] = a[5]+0x001;  //okrag
; 0000 0AD1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AD2 
; 0000 0AD3     break;
; 0000 0AD4 
; 0000 0AD5 
; 0000 0AD6     case 69:
_0xF0:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BRNE _0xF1
; 0000 0AD7 
; 0000 0AD8             a[0] = 0x0D2;   //ster1
	LDI  R30,LOW(210)
	LDI  R31,HIGH(210)
	CALL SUBOPT_0x1C
; 0000 0AD9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0ADA             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3D
; 0000 0ADB             a[5] = 0x193;   //delta okrag
	RJMP _0x39C
; 0000 0ADC             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0ADD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0ADE 
; 0000 0ADF             a[1] = a[0]+0x001;  //ster2
; 0000 0AE0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AE1             a[6] = a[5]+0x001;  //okrag
; 0000 0AE2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AE3 
; 0000 0AE4     break;
; 0000 0AE5 
; 0000 0AE6 
; 0000 0AE7     case 70:
_0xF1:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BRNE _0xF2
; 0000 0AE8 
; 0000 0AE9             a[0] = 0x0E6;   //ster1
	LDI  R30,LOW(230)
	LDI  R31,HIGH(230)
	CALL SUBOPT_0x1C
; 0000 0AEA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0AEB             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0AEC             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3E
; 0000 0AED             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0AEE             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0AEF 
; 0000 0AF0             a[1] = a[0]+0x001;  //ster2
; 0000 0AF1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AF2             a[6] = a[5]+0x001;  //okrag
; 0000 0AF3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AF4 
; 0000 0AF5     break;
; 0000 0AF6 
; 0000 0AF7 
; 0000 0AF8     case 71:
_0xF2:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BRNE _0xF3
; 0000 0AF9 
; 0000 0AFA             a[0] = 0x0B4;   //ster1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x1C
; 0000 0AFB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0AFC             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0AFD             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x32
; 0000 0AFE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AFF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0B00 
; 0000 0B01             a[1] = a[0]+0x001;  //ster2
; 0000 0B02             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B03             a[6] = a[5]+0x001;  //okrag
; 0000 0B04             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B05 
; 0000 0B06     break;
; 0000 0B07 
; 0000 0B08 
; 0000 0B09     case 72:
_0xF3:
	CPI  R30,LOW(0x48)
	LDI  R26,HIGH(0x48)
	CPC  R31,R26
	BRNE _0xF4
; 0000 0B0A 
; 0000 0B0B             a[0] = 0x0AC;   //ster1
	LDI  R30,LOW(172)
	LDI  R31,HIGH(172)
	CALL SUBOPT_0x1C
; 0000 0B0C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0B0D             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x29
; 0000 0B0E             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x23
; 0000 0B0F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B10             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0B11 
; 0000 0B12             a[1] = a[0]+0x001;  //ster2
; 0000 0B13             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B14             a[6] = a[5]+0x001;  //okrag
; 0000 0B15             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B16 
; 0000 0B17     break;
; 0000 0B18 
; 0000 0B19 
; 0000 0B1A     case 73:
_0xF4:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BRNE _0xF5
; 0000 0B1B 
; 0000 0B1C             a[0] = 0x012;   //ster1
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CALL SUBOPT_0x1C
; 0000 0B1D             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0B1E             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x38
; 0000 0B1F             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x32
; 0000 0B20             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B21             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0B22 
; 0000 0B23             a[1] = a[0]+0x001;  //ster2
; 0000 0B24             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B25             a[6] = a[5]+0x001;  //okrag
; 0000 0B26             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B27 
; 0000 0B28     break;
; 0000 0B29 
; 0000 0B2A 
; 0000 0B2B     case 74:
_0xF5:
	CPI  R30,LOW(0x4A)
	LDI  R26,HIGH(0x4A)
	CPC  R31,R26
	BRNE _0xF6
; 0000 0B2C 
; 0000 0B2D             a[0] = 0x0B2;   //ster1
	LDI  R30,LOW(178)
	LDI  R31,HIGH(178)
	CALL SUBOPT_0x1C
; 0000 0B2E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0B2F             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x24
; 0000 0B30             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x23
; 0000 0B31             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B32             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0B33 
; 0000 0B34             a[1] = a[0]+0x001;  //ster2
; 0000 0B35             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B36             a[6] = a[5]+0x001;  //okrag
; 0000 0B37             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B38 
; 0000 0B39     break;
; 0000 0B3A 
; 0000 0B3B 
; 0000 0B3C     case 75:
_0xF6:
	CPI  R30,LOW(0x4B)
	LDI  R26,HIGH(0x4B)
	CPC  R31,R26
	BRNE _0xF7
; 0000 0B3D 
; 0000 0B3E             a[0] = 0x10C;   //ster1
	LDI  R30,LOW(268)
	LDI  R31,HIGH(268)
	CALL SUBOPT_0x1C
; 0000 0B3F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0B40             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x31
; 0000 0B41             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x32
; 0000 0B42             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B43             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0B44 
; 0000 0B45             a[1] = a[0]+0x001;  //ster2
; 0000 0B46             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B47             a[6] = a[5]+0x001;  //okrag
; 0000 0B48             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B49 
; 0000 0B4A     break;
; 0000 0B4B 
; 0000 0B4C 
; 0000 0B4D     case 76:
_0xF7:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0xF8
; 0000 0B4E 
; 0000 0B4F             a[0] = 0x;   //ster1
	CALL SUBOPT_0x37
; 0000 0B50             a[3] = 0x;    //ster4 INV druciak
; 0000 0B51             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0B52             a[5] = 0x;   //delta okrag
; 0000 0B53             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0B54             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0B55 
; 0000 0B56             a[1] = a[0]+0x001;  //ster2
; 0000 0B57             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B58             a[6] = a[5]+0x001;  //okrag
; 0000 0B59             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B5A 
; 0000 0B5B     break;
; 0000 0B5C 
; 0000 0B5D 
; 0000 0B5E     case 77:
_0xF8:
	CPI  R30,LOW(0x4D)
	LDI  R26,HIGH(0x4D)
	CPC  R31,R26
	BRNE _0xF9
; 0000 0B5F 
; 0000 0B60             a[0] = 0x026;   //ster1
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL SUBOPT_0x1C
; 0000 0B61             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0B62             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x38
; 0000 0B63             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x39C
; 0000 0B64             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B65             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B66 
; 0000 0B67             a[1] = a[0]+0x001;  //ster2
; 0000 0B68             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B69             a[6] = a[5]+0x001;  //okrag
; 0000 0B6A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B6B 
; 0000 0B6C     break;
; 0000 0B6D 
; 0000 0B6E 
; 0000 0B6F     case 78:
_0xF9:
	CPI  R30,LOW(0x4E)
	LDI  R26,HIGH(0x4E)
	CPC  R31,R26
	BRNE _0xFA
; 0000 0B70 
; 0000 0B71             a[0] = 0x11C;   //ster1
	LDI  R30,LOW(284)
	LDI  R31,HIGH(284)
	CALL SUBOPT_0x1C
; 0000 0B72             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0B73             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 0B74             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x39C
; 0000 0B75             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B76             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B77 
; 0000 0B78             a[1] = a[0]+0x001;  //ster2
; 0000 0B79             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B7A             a[6] = a[5]+0x001;  //okrag
; 0000 0B7B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B7C 
; 0000 0B7D     break;
; 0000 0B7E 
; 0000 0B7F 
; 0000 0B80     case 79:
_0xFA:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0xFB
; 0000 0B81 
; 0000 0B82             a[0] = 0x112;   //ster1
	LDI  R30,LOW(274)
	LDI  R31,HIGH(274)
	CALL SUBOPT_0x1C
; 0000 0B83             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0B84             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x31
; 0000 0B85             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x39C
; 0000 0B86             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B87             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B88 
; 0000 0B89             a[1] = a[0]+0x001;  //ster2
; 0000 0B8A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B8B             a[6] = a[5]+0x001;  //okrag
; 0000 0B8C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B8D 
; 0000 0B8E     break;
; 0000 0B8F 
; 0000 0B90     case 80:
_0xFB:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0xFC
; 0000 0B91 
; 0000 0B92             a[0] = 0x;   //ster1
	CALL SUBOPT_0x37
; 0000 0B93             a[3] = 0x;    //ster4 INV druciak
; 0000 0B94             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0B95             a[5] = 0x;   //delta okrag
; 0000 0B96             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0B97             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0B98 
; 0000 0B99             a[1] = a[0]+0x001;  //ster2
; 0000 0B9A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B9B             a[6] = a[5]+0x001;  //okrag
; 0000 0B9C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B9D 
; 0000 0B9E     break;
; 0000 0B9F 
; 0000 0BA0     case 81:
_0xFC:
	CPI  R30,LOW(0x51)
	LDI  R26,HIGH(0x51)
	CPC  R31,R26
	BRNE _0xFD
; 0000 0BA1 
; 0000 0BA2             a[0] = 0x0EA;   //ster1
	LDI  R30,LOW(234)
	LDI  R31,HIGH(234)
	CALL SUBOPT_0x1C
; 0000 0BA3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0BA4             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0BA5             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x23
; 0000 0BA6             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BA7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0BA8 
; 0000 0BA9             a[1] = a[0]+0x001;  //ster2
; 0000 0BAA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BAB             a[6] = a[5]+0x001;  //okrag
; 0000 0BAC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BAD 
; 0000 0BAE     break;
; 0000 0BAF 
; 0000 0BB0 
; 0000 0BB1     case 82:
_0xFD:
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BRNE _0xFE
; 0000 0BB2 
; 0000 0BB3             a[0] = 0x0D8;   //ster1
	LDI  R30,LOW(216)
	LDI  R31,HIGH(216)
	CALL SUBOPT_0x1C
; 0000 0BB4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0BB5             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0BB6             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x23
; 0000 0BB7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BB8             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0BB9 
; 0000 0BBA             a[1] = a[0]+0x001;  //ster2
; 0000 0BBB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BBC             a[6] = a[5]+0x001;  //okrag
; 0000 0BBD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BBE 
; 0000 0BBF     break;
; 0000 0BC0 
; 0000 0BC1 
; 0000 0BC2     case 83:
_0xFE:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0xFF
; 0000 0BC3 
; 0000 0BC4             a[0] = 0x08C;   //ster1
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	CALL SUBOPT_0x1C
; 0000 0BC5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0BC6             a[4] = 0x22;    //ster3 ABS krazek scierny
	LDI  R26,LOW(34)
	LDI  R27,HIGH(34)
	CALL SUBOPT_0x42
; 0000 0BC7             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x39C
; 0000 0BC8             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BC9             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0BCA 
; 0000 0BCB             a[1] = a[0]+0x001;  //ster2
; 0000 0BCC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BCD             a[6] = a[5]+0x001;  //okrag
; 0000 0BCE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BCF 
; 0000 0BD0     break;
; 0000 0BD1 
; 0000 0BD2 
; 0000 0BD3     case 84:
_0xFF:
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x100
; 0000 0BD4 
; 0000 0BD5             a[0] = 0x0A0;   //ster1
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	CALL SUBOPT_0x1C
; 0000 0BD6             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0BD7             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0BD8             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x44
; 0000 0BD9             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x39A
; 0000 0BDA             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0BDB 
; 0000 0BDC             a[1] = a[0]+0x001;  //ster2
; 0000 0BDD             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BDE             a[6] = a[5]+0x001;  //okrag
; 0000 0BDF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BE0 
; 0000 0BE1     break;
; 0000 0BE2 
; 0000 0BE3 
; 0000 0BE4    case 85:
_0x100:
	CPI  R30,LOW(0x55)
	LDI  R26,HIGH(0x55)
	CPC  R31,R26
	BRNE _0x101
; 0000 0BE5 
; 0000 0BE6             a[0] = 0x0AE;   //ster1
	LDI  R30,LOW(174)
	LDI  R31,HIGH(174)
	CALL SUBOPT_0x1C
; 0000 0BE7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0BE8             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0BE9             a[5] = 0x193;   //delta okrag
	RJMP _0x39C
; 0000 0BEA             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BEB             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0BEC 
; 0000 0BED             a[1] = a[0]+0x001;  //ster2
; 0000 0BEE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BEF             a[6] = a[5]+0x001;  //okrag
; 0000 0BF0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BF1 
; 0000 0BF2     break;
; 0000 0BF3 
; 0000 0BF4     case 86:
_0x101:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BRNE _0x102
; 0000 0BF5 
; 0000 0BF6             a[0] = 0x0F6;   //ster1
	LDI  R30,LOW(246)
	LDI  R31,HIGH(246)
	CALL SUBOPT_0x1C
; 0000 0BF7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0BF8             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x41
; 0000 0BF9             a[5] = 0x190;   //delta okrag
	RJMP _0x39C
; 0000 0BFA             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BFB             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0BFC 
; 0000 0BFD             a[1] = a[0]+0x001;  //ster2
; 0000 0BFE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BFF             a[6] = a[5]+0x001;  //okrag
; 0000 0C00             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C01 
; 0000 0C02     break;
; 0000 0C03 
; 0000 0C04 
; 0000 0C05     case 87:
_0x102:
	CPI  R30,LOW(0x57)
	LDI  R26,HIGH(0x57)
	CPC  R31,R26
	BRNE _0x103
; 0000 0C06 
; 0000 0C07             a[0] = 0x0C4;   //ster1
	LDI  R30,LOW(196)
	LDI  R31,HIGH(196)
	CALL SUBOPT_0x1C
; 0000 0C08             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0C09             a[4] = 0x23;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x45
; 0000 0C0A             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x2D
; 0000 0C0B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C0C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0C0D 
; 0000 0C0E             a[1] = a[0]+0x001;  //ster2
; 0000 0C0F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C10             a[6] = a[5]+0x001;  //okrag
; 0000 0C11             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C12 
; 0000 0C13     break;
; 0000 0C14 
; 0000 0C15 
; 0000 0C16     case 88:
_0x103:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x104
; 0000 0C17 
; 0000 0C18             a[0] = 0x07E;   //ster1
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	CALL SUBOPT_0x1C
; 0000 0C19             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x43
; 0000 0C1A             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0C1B             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x44
; 0000 0C1C             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x1F
; 0000 0C1D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x21
	RJMP _0x39B
; 0000 0C1E 
; 0000 0C1F             a[1] = a[0]+0x001;  //ster2
; 0000 0C20             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C21             a[6] = a[5]+0x001;  //okrag
; 0000 0C22             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C23 
; 0000 0C24     break;
; 0000 0C25 
; 0000 0C26 
; 0000 0C27     case 89:
_0x104:
	CPI  R30,LOW(0x59)
	LDI  R26,HIGH(0x59)
	CPC  R31,R26
	BRNE _0x105
; 0000 0C28 
; 0000 0C29             a[0] = 0x02C;   //ster1
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x1C
; 0000 0C2A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0C2B             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 0C2C             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x32
; 0000 0C2D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C2E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0C2F 
; 0000 0C30             a[1] = a[0]+0x001;  //ster2
; 0000 0C31             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C32             a[6] = a[5]+0x001;  //okrag
; 0000 0C33             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C34 
; 0000 0C35     break;
; 0000 0C36 
; 0000 0C37 
; 0000 0C38     case 90:
_0x105:
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BRNE _0x106
; 0000 0C39 
; 0000 0C3A             a[0] = 0x0F0;   //ster1
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	CALL SUBOPT_0x1C
; 0000 0C3B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0C3C             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x1E
; 0000 0C3D             a[5] = 0x196;   //delta okrag
; 0000 0C3E             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0C3F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C40 
; 0000 0C41             a[1] = a[0]+0x001;  //ster2
; 0000 0C42             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C43             a[6] = a[5]+0x001;  //okrag
; 0000 0C44             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C45 
; 0000 0C46     break;
; 0000 0C47 
; 0000 0C48 
; 0000 0C49     case 91:
_0x106:
	CPI  R30,LOW(0x5B)
	LDI  R26,HIGH(0x5B)
	CPC  R31,R26
	BRNE _0x107
; 0000 0C4A 
; 0000 0C4B             a[0] = 0x0A8;   //ster1
	LDI  R30,LOW(168)
	LDI  R31,HIGH(168)
	CALL SUBOPT_0x1C
; 0000 0C4C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0C4D             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x30
; 0000 0C4E             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x39C
; 0000 0C4F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C50             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C51 
; 0000 0C52             a[1] = a[0]+0x001;  //ster2
; 0000 0C53             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C54             a[6] = a[5]+0x001;  //okrag
; 0000 0C55             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C56 
; 0000 0C57     break;
; 0000 0C58 
; 0000 0C59 
; 0000 0C5A     case 92:
_0x107:
	CPI  R30,LOW(0x5C)
	LDI  R26,HIGH(0x5C)
	CPC  R31,R26
	BRNE _0x108
; 0000 0C5B 
; 0000 0C5C             a[0] = 0x;   //ster1
	CALL SUBOPT_0x37
; 0000 0C5D             a[3] = 0x;    //ster4 INV druciak
; 0000 0C5E             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0C5F             a[5] = 0x;   //delta okrag
; 0000 0C60             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0C61             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0C62 
; 0000 0C63             a[1] = a[0]+0x001;  //ster2
; 0000 0C64             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C65             a[6] = a[5]+0x001;  //okrag
; 0000 0C66             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C67 
; 0000 0C68     break;
; 0000 0C69 
; 0000 0C6A 
; 0000 0C6B     case 93:
_0x108:
	CPI  R30,LOW(0x5D)
	LDI  R26,HIGH(0x5D)
	CPC  R31,R26
	BRNE _0x109
; 0000 0C6C 
; 0000 0C6D             a[0] = 0x030;   //ster1
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x1C
; 0000 0C6E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0C6F             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3C
; 0000 0C70             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x39C
; 0000 0C71             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C72             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C73 
; 0000 0C74             a[1] = a[0]+0x001;  //ster2
; 0000 0C75             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C76             a[6] = a[5]+0x001;  //okrag
; 0000 0C77             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C78 
; 0000 0C79     break;
; 0000 0C7A 
; 0000 0C7B 
; 0000 0C7C     case 94:
_0x109:
	CPI  R30,LOW(0x5E)
	LDI  R26,HIGH(0x5E)
	CPC  R31,R26
	BRNE _0x10A
; 0000 0C7D 
; 0000 0C7E             a[0] = 0x0F4;   //ster1
	LDI  R30,LOW(244)
	LDI  R31,HIGH(244)
	CALL SUBOPT_0x1C
; 0000 0C7F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0C80             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x1E
; 0000 0C81             a[5] = 0x196;   //delta okrag
; 0000 0C82             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0C83             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0C84 
; 0000 0C85             a[1] = a[0]+0x001;  //ster2
; 0000 0C86             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C87             a[6] = a[5]+0x001;  //okrag
; 0000 0C88             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C89 
; 0000 0C8A     break;
; 0000 0C8B 
; 0000 0C8C 
; 0000 0C8D     case 95:
_0x10A:
	CPI  R30,LOW(0x5F)
	LDI  R26,HIGH(0x5F)
	CPC  R31,R26
	BRNE _0x10B
; 0000 0C8E 
; 0000 0C8F             a[0] = 0x09E;   //ster1
	LDI  R30,LOW(158)
	LDI  R31,HIGH(158)
	CALL SUBOPT_0x1C
; 0000 0C90             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0C91             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x2A
; 0000 0C92             a[5] = 0x199;   //delta okrag
; 0000 0C93             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C94             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0C95 
; 0000 0C96             a[1] = a[0]+0x001;  //ster2
; 0000 0C97             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C98             a[6] = a[5]+0x001;  //okrag
; 0000 0C99             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C9A 
; 0000 0C9B     break;
; 0000 0C9C 
; 0000 0C9D     case 96:
_0x10B:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x10C
; 0000 0C9E 
; 0000 0C9F             a[0] = 0x;   //ster1
	CALL SUBOPT_0x37
; 0000 0CA0             a[3] = 0x;    //ster4 INV druciak
; 0000 0CA1             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0CA2             a[5] = 0x;   //delta okrag
; 0000 0CA3             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0CA4             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0CA5 
; 0000 0CA6             a[1] = a[0]+0x001;  //ster2
; 0000 0CA7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CA8             a[6] = a[5]+0x001;  //okrag
; 0000 0CA9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CAA 
; 0000 0CAB     break;
; 0000 0CAC 
; 0000 0CAD 
; 0000 0CAE     case 97:
_0x10C:
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BRNE _0x10D
; 0000 0CAF 
; 0000 0CB0             a[0] = 0x06A;   //ster1
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	CALL SUBOPT_0x1C
; 0000 0CB1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0CB2             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x29
; 0000 0CB3             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x23
; 0000 0CB4             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CB5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0CB6 
; 0000 0CB7             a[1] = a[0]+0x001;  //ster2
; 0000 0CB8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CB9             a[6] = a[5]+0x001;  //okrag
; 0000 0CBA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CBB 
; 0000 0CBC     break;
; 0000 0CBD 
; 0000 0CBE 
; 0000 0CBF     case 98:
_0x10D:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x10E
; 0000 0CC0 
; 0000 0CC1             a[0] = 0x0BE;   //ster1
	LDI  R30,LOW(190)
	LDI  R31,HIGH(190)
	CALL SUBOPT_0x1C
; 0000 0CC2             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0CC3             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x22
; 0000 0CC4             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x46
; 0000 0CC5             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0CC6             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0CC7 
; 0000 0CC8             a[1] = a[0]+0x001;  //ster2
; 0000 0CC9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CCA             a[6] = a[5]+0x001;  //okrag
; 0000 0CCB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CCC 
; 0000 0CCD     break;
; 0000 0CCE 
; 0000 0CCF 
; 0000 0CD0     case 99:
_0x10E:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x10F
; 0000 0CD1 
; 0000 0CD2             a[0] = 0x0BA;   //ster1
	LDI  R30,LOW(186)
	LDI  R31,HIGH(186)
	CALL SUBOPT_0x1C
; 0000 0CD3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0CD4             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 0CD5             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x39C
; 0000 0CD6             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CD7             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CD8 
; 0000 0CD9             a[1] = a[0]+0x001;  //ster2
; 0000 0CDA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CDB             a[6] = a[5]+0x001;  //okrag
; 0000 0CDC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CDD 
; 0000 0CDE     break;
; 0000 0CDF 
; 0000 0CE0 
; 0000 0CE1     case 100:
_0x10F:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRNE _0x110
; 0000 0CE2 
; 0000 0CE3             a[0] = 0x060;   //ster1
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x1C
; 0000 0CE4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0CE5             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x24
; 0000 0CE6             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x23
; 0000 0CE7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CE8             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0CE9 
; 0000 0CEA             a[1] = a[0]+0x001;  //ster2
; 0000 0CEB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CEC             a[6] = a[5]+0x001;  //okrag
; 0000 0CED             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CEE 
; 0000 0CEF     break;
; 0000 0CF0 
; 0000 0CF1 
; 0000 0CF2     case 101:
_0x110:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x111
; 0000 0CF3 
; 0000 0CF4             a[0] = 0x070;   //ster1
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	CALL SUBOPT_0x1C
; 0000 0CF5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0CF6             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x29
; 0000 0CF7             a[5] = 0x199;   //delta okrag
	RJMP _0x39C
; 0000 0CF8             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CF9             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CFA 
; 0000 0CFB             a[1] = a[0]+0x001;  //ster2
; 0000 0CFC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CFD             a[6] = a[5]+0x001;  //okrag
; 0000 0CFE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CFF 
; 0000 0D00     break;
; 0000 0D01 
; 0000 0D02 
; 0000 0D03     case 102:
_0x111:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BRNE _0x112
; 0000 0D04 
; 0000 0D05             a[0] = 0x08A;   //ster1
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	CALL SUBOPT_0x1C
; 0000 0D06             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0D07             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x22
; 0000 0D08             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x46
; 0000 0D09             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0D0A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D0B 
; 0000 0D0C             a[1] = a[0]+0x001;  //ster2
; 0000 0D0D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D0E             a[6] = a[5]+0x001;  //okrag
; 0000 0D0F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D10 
; 0000 0D11     break;
; 0000 0D12 
; 0000 0D13 
; 0000 0D14     case 103:
_0x112:
	CPI  R30,LOW(0x67)
	LDI  R26,HIGH(0x67)
	CPC  R31,R26
	BRNE _0x113
; 0000 0D15 
; 0000 0D16             a[0] = 0x080;   //ster1
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CALL SUBOPT_0x1C
; 0000 0D17             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0D18             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 0D19             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x2D
; 0000 0D1A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D1B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0D1C 
; 0000 0D1D             a[1] = a[0]+0x001;  //ster2
; 0000 0D1E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D1F             a[6] = a[5]+0x001;  //okrag
; 0000 0D20             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D21 
; 0000 0D22     break;
; 0000 0D23 
; 0000 0D24 
; 0000 0D25     case 104:
_0x113:
	CPI  R30,LOW(0x68)
	LDI  R26,HIGH(0x68)
	CPC  R31,R26
	BRNE _0x114
; 0000 0D26 
; 0000 0D27             a[0] = 0x0B6;   //ster1
	LDI  R30,LOW(182)
	LDI  R31,HIGH(182)
	CALL SUBOPT_0x1C
; 0000 0D28             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0D29             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x24
; 0000 0D2A             a[5] = 0x196;   //delta okrag
	RJMP _0x39C
; 0000 0D2B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D2C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D2D 
; 0000 0D2E             a[1] = a[0]+0x001;  //ster2
; 0000 0D2F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D30             a[6] = a[5]+0x001;  //okrag
; 0000 0D31             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D32 
; 0000 0D33     break;
; 0000 0D34 
; 0000 0D35 
; 0000 0D36     case 105:
_0x114:
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x115
; 0000 0D37 
; 0000 0D38             a[0] = 0x044;   //ster1
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	CALL SUBOPT_0x1C
; 0000 0D39             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0D3A             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 0D3B             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x2E
; 0000 0D3C             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0D3D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0D3E 
; 0000 0D3F             a[1] = a[0]+0x001;  //ster2
; 0000 0D40             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D41             a[6] = a[5]+0x001;  //okrag
; 0000 0D42             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D43 
; 0000 0D44     break;
; 0000 0D45 
; 0000 0D46 
; 0000 0D47     case 106:
_0x115:
	CPI  R30,LOW(0x6A)
	LDI  R26,HIGH(0x6A)
	CPC  R31,R26
	BRNE _0x116
; 0000 0D48 
; 0000 0D49             a[0] = 0x03A;   //ster1
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	CALL SUBOPT_0x1C
; 0000 0D4A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0D4B             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x33
; 0000 0D4C             a[5] = 0x190;   //delta okrag
; 0000 0D4D             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0D4E             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D4F 
; 0000 0D50             a[1] = a[0]+0x001;  //ster2
; 0000 0D51             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D52             a[6] = a[5]+0x001;  //okrag
; 0000 0D53             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D54 
; 0000 0D55     break;
; 0000 0D56 
; 0000 0D57 
; 0000 0D58     case 107:
_0x116:
	CPI  R30,LOW(0x6B)
	LDI  R26,HIGH(0x6B)
	CPC  R31,R26
	BRNE _0x117
; 0000 0D59 
; 0000 0D5A             a[0] = 0x;   //ster1
	CALL SUBOPT_0x37
; 0000 0D5B             a[3] = 0x;    //ster4 INV druciak
; 0000 0D5C             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0D5D             a[5] = 0x;   //delta okrag
; 0000 0D5E             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0D5F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0D60 
; 0000 0D61             a[1] = a[0]+0x001;  //ster2
; 0000 0D62             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D63             a[6] = a[5]+0x001;  //okrag
; 0000 0D64             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D65 
; 0000 0D66     break;
; 0000 0D67 
; 0000 0D68 
; 0000 0D69     case 108:
_0x117:
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BRNE _0x118
; 0000 0D6A 
; 0000 0D6B             a[0] = 0x0C6;   //ster1
	LDI  R30,LOW(198)
	LDI  R31,HIGH(198)
	CALL SUBOPT_0x1C
; 0000 0D6C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0D6D             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0D6E             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3E
; 0000 0D6F             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0D70             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0D71 
; 0000 0D72             a[1] = a[0]+0x001;  //ster2
; 0000 0D73             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D74             a[6] = a[5]+0x001;  //okrag
; 0000 0D75             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D76 
; 0000 0D77     break;
; 0000 0D78 
; 0000 0D79 
; 0000 0D7A     case 109:
_0x118:
	CPI  R30,LOW(0x6D)
	LDI  R26,HIGH(0x6D)
	CPC  R31,R26
	BRNE _0x119
; 0000 0D7B 
; 0000 0D7C             a[0] = 0x00A;   //ster1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x1C
; 0000 0D7D             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0D7E             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x20
; 0000 0D7F             a[5] = 0x190;   //delta okrag
; 0000 0D80             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x39A
; 0000 0D81             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D82 
; 0000 0D83             a[1] = a[0]+0x001;  //ster2
; 0000 0D84             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D85             a[6] = a[5]+0x001;  //okrag
; 0000 0D86             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D87 
; 0000 0D88     break;
; 0000 0D89 
; 0000 0D8A 
; 0000 0D8B     case 110:
_0x119:
	CPI  R30,LOW(0x6E)
	LDI  R26,HIGH(0x6E)
	CPC  R31,R26
	BRNE _0x11A
; 0000 0D8C 
; 0000 0D8D             a[0] = 0x032;   //ster1
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x1C
; 0000 0D8E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0D8F             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x33
; 0000 0D90             a[5] = 0x190;   //delta okrag
; 0000 0D91             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0D92             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0D93 
; 0000 0D94             a[1] = a[0]+0x001;  //ster2
; 0000 0D95             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D96             a[6] = a[5]+0x001;  //okrag
; 0000 0D97             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D98 
; 0000 0D99     break;
; 0000 0D9A 
; 0000 0D9B 
; 0000 0D9C     case 111:
_0x11A:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x11B
; 0000 0D9D 
; 0000 0D9E             a[0] = 0x;   //ster1
	CALL SUBOPT_0x37
; 0000 0D9F             a[3] = 0x;    //ster4 INV druciak
; 0000 0DA0             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0DA1             a[5] = 0x;   //delta okrag
; 0000 0DA2             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0DA3             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0DA4 
; 0000 0DA5             a[1] = a[0]+0x001;  //ster2
; 0000 0DA6             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DA7             a[6] = a[5]+0x001;  //okrag
; 0000 0DA8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DA9 
; 0000 0DAA     break;
; 0000 0DAB 
; 0000 0DAC 
; 0000 0DAD     case 112:
_0x11B:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x11C
; 0000 0DAE 
; 0000 0DAF             a[0] = 0x0E2;   //ster1
	LDI  R30,LOW(226)
	LDI  R31,HIGH(226)
	CALL SUBOPT_0x1C
; 0000 0DB0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0DB1             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0DB2             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3E
; 0000 0DB3             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0DB4             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DB5 
; 0000 0DB6             a[1] = a[0]+0x001;  //ster2
; 0000 0DB7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DB8             a[6] = a[5]+0x001;  //okrag
; 0000 0DB9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DBA 
; 0000 0DBB     break;
; 0000 0DBC 
; 0000 0DBD 
; 0000 0DBE     case 113:
_0x11C:
	CPI  R30,LOW(0x71)
	LDI  R26,HIGH(0x71)
	CPC  R31,R26
	BRNE _0x11D
; 0000 0DBF 
; 0000 0DC0             a[0] = 0x0D4;   //ster1
	LDI  R30,LOW(212)
	LDI  R31,HIGH(212)
	CALL SUBOPT_0x1C
; 0000 0DC1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0DC2             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0DC3             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3E
; 0000 0DC4             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0DC5             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0DC6 
; 0000 0DC7             a[1] = a[0]+0x001;  //ster2
; 0000 0DC8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DC9             a[6] = a[5]+0x001;  //okrag
; 0000 0DCA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DCB 
; 0000 0DCC     break;
; 0000 0DCD 
; 0000 0DCE 
; 0000 0DCF     case 114:
_0x11D:
	CPI  R30,LOW(0x72)
	LDI  R26,HIGH(0x72)
	CPC  R31,R26
	BRNE _0x11E
; 0000 0DD0 
; 0000 0DD1             a[0] = 0x04A;   //ster1
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	CALL SUBOPT_0x1C
; 0000 0DD2             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0DD3             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0DD4             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x44
; 0000 0DD5             a[7] = 0x0F;    //ster3 INV krazek scierny
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	CALL SUBOPT_0x25
; 0000 0DD6             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0DD7 
; 0000 0DD8             a[1] = a[0]+0x001;  //ster2
; 0000 0DD9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DDA             a[6] = a[5]+0x001;  //okrag
; 0000 0DDB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DDC 
; 0000 0DDD     break;
; 0000 0DDE 
; 0000 0DDF 
; 0000 0DE0     case 115:
_0x11E:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x11F
; 0000 0DE1 
; 0000 0DE2             a[0] = 0x076;   //ster1
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	CALL SUBOPT_0x1C
; 0000 0DE3             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x4A
; 0000 0DE4             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0DE5             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x26
; 0000 0DE6             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0DE7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0DE8 
; 0000 0DE9             a[1] = a[0]+0x001;  //ster2
; 0000 0DEA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DEB             a[6] = a[5]+0x001;  //okrag
; 0000 0DEC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DED 
; 0000 0DEE     break;
; 0000 0DEF 
; 0000 0DF0 
; 0000 0DF1     case 116:
_0x11F:
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BRNE _0x120
; 0000 0DF2 
; 0000 0DF3             a[0] = 0x092;   //ster1
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	CALL SUBOPT_0x1C
; 0000 0DF4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0DF5             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x31
; 0000 0DF6             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x39C
; 0000 0DF7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0DF8             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DF9 
; 0000 0DFA             a[1] = a[0]+0x001;  //ster2
; 0000 0DFB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DFC             a[6] = a[5]+0x001;  //okrag
; 0000 0DFD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DFE 
; 0000 0DFF     break;
; 0000 0E00 
; 0000 0E01 
; 0000 0E02 
; 0000 0E03     case 117:
_0x120:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x121
; 0000 0E04 
; 0000 0E05             a[0] = 0x11A;   //ster1
	LDI  R30,LOW(282)
	LDI  R31,HIGH(282)
	CALL SUBOPT_0x1C
; 0000 0E06             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0E07             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0E08             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3E
; 0000 0E09             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0E0A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E0B 
; 0000 0E0C             a[1] = a[0]+0x001;  //ster2
; 0000 0E0D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E0E             a[6] = a[5]+0x001;  //okrag
; 0000 0E0F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E10 
; 0000 0E11     break;
; 0000 0E12 
; 0000 0E13 
; 0000 0E14 
; 0000 0E15     case 118:
_0x121:
	CPI  R30,LOW(0x76)
	LDI  R26,HIGH(0x76)
	CPC  R31,R26
	BRNE _0x122
; 0000 0E16 
; 0000 0E17             a[0] = 0x056;   //ster1
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	CALL SUBOPT_0x1C
; 0000 0E18             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0E19             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0E1A             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3E
; 0000 0E1B             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0E1C             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E1D 
; 0000 0E1E             a[1] = a[0]+0x001;  //ster2
; 0000 0E1F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E20             a[6] = a[5]+0x001;  //okrag
; 0000 0E21             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E22 
; 0000 0E23     break;
; 0000 0E24 
; 0000 0E25 
; 0000 0E26     case 119:
_0x122:
	CPI  R30,LOW(0x77)
	LDI  R26,HIGH(0x77)
	CPC  R31,R26
	BRNE _0x123
; 0000 0E27 
; 0000 0E28             a[0] = 0x072;   //ster1
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	CALL SUBOPT_0x1C
; 0000 0E29             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x4A
; 0000 0E2A             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0E2B             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x26
; 0000 0E2C             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0E2D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E2E 
; 0000 0E2F             a[1] = a[0]+0x001;  //ster2
; 0000 0E30             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E31             a[6] = a[5]+0x001;  //okrag
; 0000 0E32             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E33 
; 0000 0E34     break;
; 0000 0E35 
; 0000 0E36 
; 0000 0E37     case 120:
_0x123:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x124
; 0000 0E38 
; 0000 0E39             a[0] = 0x0D0;   //ster1
	LDI  R30,LOW(208)
	LDI  R31,HIGH(208)
	CALL SUBOPT_0x1C
; 0000 0E3A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0E3B             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x31
; 0000 0E3C             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x32
; 0000 0E3D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0E3E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0E3F 
; 0000 0E40             a[1] = a[0]+0x001;  //ster2
; 0000 0E41             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E42             a[6] = a[5]+0x001;  //okrag
; 0000 0E43             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E44 
; 0000 0E45     break;
; 0000 0E46 
; 0000 0E47 
; 0000 0E48     case 121:
_0x124:
	CPI  R30,LOW(0x79)
	LDI  R26,HIGH(0x79)
	CPC  R31,R26
	BRNE _0x125
; 0000 0E49 
; 0000 0E4A             a[0] = 0x048;   //ster1
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	CALL SUBOPT_0x1C
; 0000 0E4B             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0E4C             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0E4D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3E
; 0000 0E4E             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0E4F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0E50 
; 0000 0E51             a[1] = a[0]+0x001;  //ster2
; 0000 0E52             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E53             a[6] = a[5]+0x001;  //okrag
; 0000 0E54             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E55 
; 0000 0E56     break;
; 0000 0E57 
; 0000 0E58 
; 0000 0E59     case 122:
_0x125:
	CPI  R30,LOW(0x7A)
	LDI  R26,HIGH(0x7A)
	CPC  R31,R26
	BRNE _0x126
; 0000 0E5A 
; 0000 0E5B             a[0] = 0x09A;   //ster1
	LDI  R30,LOW(154)
	LDI  R31,HIGH(154)
	CALL SUBOPT_0x1C
; 0000 0E5C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0E5D             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 0E5E             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x32
; 0000 0E5F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0E60             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0E61 
; 0000 0E62             a[1] = a[0]+0x001;  //ster2
; 0000 0E63             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E64             a[6] = a[5]+0x001;  //okrag
; 0000 0E65             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E66 
; 0000 0E67     break;
; 0000 0E68 
; 0000 0E69 
; 0000 0E6A     case 123:
_0x126:
	CPI  R30,LOW(0x7B)
	LDI  R26,HIGH(0x7B)
	CPC  R31,R26
	BRNE _0x127
; 0000 0E6B 
; 0000 0E6C             a[0] = 0x046;   //ster1
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL SUBOPT_0x1C
; 0000 0E6D             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0E6E             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0E6F             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x4C
; 0000 0E70             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0E71             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0E72 
; 0000 0E73             a[1] = a[0]+0x001;  //ster2
; 0000 0E74             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E75             a[6] = a[5]+0x001;  //okrag
; 0000 0E76             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E77 
; 0000 0E78     break;
; 0000 0E79 
; 0000 0E7A 
; 0000 0E7B 
; 0000 0E7C     case 124:
_0x127:
	CPI  R30,LOW(0x7C)
	LDI  R26,HIGH(0x7C)
	CPC  R31,R26
	BRNE _0x128
; 0000 0E7D 
; 0000 0E7E             a[0] = 0x0E0;   //ster1
	LDI  R30,LOW(224)
	LDI  R31,HIGH(224)
	CALL SUBOPT_0x1C
; 0000 0E7F             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x4D
; 0000 0E80             a[4] = 0x15;    //ster3 ABS krazek scierny
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL SUBOPT_0x42
; 0000 0E81             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x44
; 0000 0E82             a[7] = 0x13;    //ster3 INV krazek scierny
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	CALL SUBOPT_0x25
; 0000 0E83             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0E84 
; 0000 0E85             a[1] = a[0]+0x001;  //ster2
; 0000 0E86             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E87             a[6] = a[5]+0x001;  //okrag
; 0000 0E88             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E89 
; 0000 0E8A     break;
; 0000 0E8B 
; 0000 0E8C 
; 0000 0E8D     case 125:
_0x128:
	CPI  R30,LOW(0x7D)
	LDI  R26,HIGH(0x7D)
	CPC  R31,R26
	BRNE _0x129
; 0000 0E8E 
; 0000 0E8F             a[0] = 0x038;   //ster1
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	CALL SUBOPT_0x1C
; 0000 0E90             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0E91             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 0E92             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x3E
; 0000 0E93             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0E94             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E95 
; 0000 0E96             a[1] = a[0]+0x001;  //ster2
; 0000 0E97             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E98             a[6] = a[5]+0x001;  //okrag
; 0000 0E99             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E9A 
; 0000 0E9B     break;
; 0000 0E9C 
; 0000 0E9D 
; 0000 0E9E     case 126:
_0x129:
	CPI  R30,LOW(0x7E)
	LDI  R26,HIGH(0x7E)
	CPC  R31,R26
	BRNE _0x12A
; 0000 0E9F 
; 0000 0EA0             a[0] = 0x0CA;   //ster1
	LDI  R30,LOW(202)
	LDI  R31,HIGH(202)
	CALL SUBOPT_0x1C
; 0000 0EA1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0EA2             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3F
; 0000 0EA3             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x39C
; 0000 0EA4             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0EA5             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EA6 
; 0000 0EA7             a[1] = a[0]+0x001;  //ster2
; 0000 0EA8             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EA9             a[6] = a[5]+0x001;  //okrag
; 0000 0EAA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EAB 
; 0000 0EAC     break;
; 0000 0EAD 
; 0000 0EAE 
; 0000 0EAF     case 127:
_0x12A:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0x12B
; 0000 0EB0 
; 0000 0EB1             a[0] = 0x0DE;   //ster1
	LDI  R30,LOW(222)
	LDI  R31,HIGH(222)
	CALL SUBOPT_0x1C
; 0000 0EB2             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0EB3             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0EB4             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x4C
; 0000 0EB5             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0EB6             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EB7 
; 0000 0EB8             a[1] = a[0]+0x001;  //ster2
; 0000 0EB9             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EBA             a[6] = a[5]+0x001;  //okrag
; 0000 0EBB             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EBC 
; 0000 0EBD     break;
; 0000 0EBE 
; 0000 0EBF 
; 0000 0EC0     case 128:
_0x12B:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x12C
; 0000 0EC1 
; 0000 0EC2             a[0] = 0x116;   //ster1
	LDI  R30,LOW(278)
	LDI  R31,HIGH(278)
	CALL SUBOPT_0x1C
; 0000 0EC3             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0EC4             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x22
; 0000 0EC5             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0EC6             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x39A
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
; 0000 0ED1     case 129:
_0x12C:
	CPI  R30,LOW(0x81)
	LDI  R26,HIGH(0x81)
	CPC  R31,R26
	BRNE _0x12D
; 0000 0ED2 
; 0000 0ED3             a[0] = 0x0E8;   //ster1
	LDI  R30,LOW(232)
	LDI  R31,HIGH(232)
	CALL SUBOPT_0x1C
; 0000 0ED4             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x4D
; 0000 0ED5             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0ED6             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x4E
; 0000 0ED7             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0ED8             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0ED9 
; 0000 0EDA             a[1] = a[0]+0x001;  //ster2
; 0000 0EDB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EDC             a[6] = a[5]+0x001;  //okrag
; 0000 0EDD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EDE 
; 0000 0EDF     break;
; 0000 0EE0 
; 0000 0EE1 
; 0000 0EE2     case 130:
_0x12D:
	CPI  R30,LOW(0x82)
	LDI  R26,HIGH(0x82)
	CPC  R31,R26
	BRNE _0x12E
; 0000 0EE3 
; 0000 0EE4             a[0] = 0x0F2;   //ster1
	LDI  R30,LOW(242)
	LDI  R31,HIGH(242)
	CALL SUBOPT_0x1C
; 0000 0EE5             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x50
; 0000 0EE6             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0EE7             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x44
; 0000 0EE8             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x1F
; 0000 0EE9             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x21
	RJMP _0x39B
; 0000 0EEA 
; 0000 0EEB             a[1] = a[0]+0x001;  //ster2
; 0000 0EEC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EED             a[6] = a[5]+0x001;  //okrag
; 0000 0EEE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EEF 
; 0000 0EF0     break;
; 0000 0EF1 
; 0000 0EF2 
; 0000 0EF3     case 131:
_0x12E:
	CPI  R30,LOW(0x83)
	LDI  R26,HIGH(0x83)
	CPC  R31,R26
	BRNE _0x12F
; 0000 0EF4 
; 0000 0EF5             a[0] = 0x108;   //ster1
	LDI  R30,LOW(264)
	LDI  R31,HIGH(264)
	CALL SUBOPT_0x1C
; 0000 0EF6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0EF7             a[4] = 0x1F;    //ster3 ABS krazek scierny
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP _0x39D
; 0000 0EF8             a[5] = 0x19C;   //delta okrag
; 0000 0EF9             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0EFA             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0EFB 
; 0000 0EFC             a[1] = a[0]+0x001;  //ster2
; 0000 0EFD             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EFE             a[6] = a[5]+0x001;  //okrag
; 0000 0EFF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F00 
; 0000 0F01     break;
; 0000 0F02 
; 0000 0F03 
; 0000 0F04 
; 0000 0F05     case 132:
_0x12F:
	CPI  R30,LOW(0x84)
	LDI  R26,HIGH(0x84)
	CPC  R31,R26
	BRNE _0x130
; 0000 0F06 
; 0000 0F07             a[0] = 0x064;   //ster1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x1C
; 0000 0F08             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0F09             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3B
; 0000 0F0A             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x35
; 0000 0F0B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F0C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0F0D 
; 0000 0F0E             a[1] = a[0]+0x001;  //ster2
; 0000 0F0F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F10             a[6] = a[5]+0x001;  //okrag
; 0000 0F11             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F12 
; 0000 0F13     break;
; 0000 0F14 
; 0000 0F15 
; 0000 0F16     case 133:
_0x130:
	CPI  R30,LOW(0x85)
	LDI  R26,HIGH(0x85)
	CPC  R31,R26
	BRNE _0x131
; 0000 0F17 
; 0000 0F18             a[0] = 0x088;   //ster1
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	CALL SUBOPT_0x1C
; 0000 0F19             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x4D
; 0000 0F1A             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0F1B             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x4E
; 0000 0F1C             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0F1D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F1E 
; 0000 0F1F             a[1] = a[0]+0x001;  //ster2
; 0000 0F20             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F21             a[6] = a[5]+0x001;  //okrag
; 0000 0F22             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F23 
; 0000 0F24     break;
; 0000 0F25 
; 0000 0F26 
; 0000 0F27 
; 0000 0F28     case 134:
_0x131:
	CPI  R30,LOW(0x86)
	LDI  R26,HIGH(0x86)
	CPC  R31,R26
	BRNE _0x132
; 0000 0F29 
; 0000 0F2A             a[0] = 0x10E;   //ster1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x1C
; 0000 0F2B             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x50
; 0000 0F2C             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0F2D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x44
; 0000 0F2E             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x39A
; 0000 0F2F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F30 
; 0000 0F31             a[1] = a[0]+0x001;  //ster2
; 0000 0F32             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F33             a[6] = a[5]+0x001;  //okrag
; 0000 0F34             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F35 
; 0000 0F36     break;
; 0000 0F37 
; 0000 0F38                ////////////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 0F39      case 135:
_0x132:
	CPI  R30,LOW(0x87)
	LDI  R26,HIGH(0x87)
	CPC  R31,R26
	BRNE _0x133
; 0000 0F3A 
; 0000 0F3B             a[0] = 0x054;   //ster1
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CALL SUBOPT_0x1C
; 0000 0F3C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0F3D             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 0F3E             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x35
; 0000 0F3F             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F40             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0F41 
; 0000 0F42             a[1] = a[0]+0x001;  //ster2
; 0000 0F43             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F44             a[6] = a[5]+0x001;  //okrag
; 0000 0F45             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F46 
; 0000 0F47     break;
; 0000 0F48 
; 0000 0F49 
; 0000 0F4A      case 136:
_0x133:
	CPI  R30,LOW(0x88)
	LDI  R26,HIGH(0x88)
	CPC  R31,R26
	BRNE _0x134
; 0000 0F4B 
; 0000 0F4C             a[0] = 0x03E;   //ster1
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	CALL SUBOPT_0x1C
; 0000 0F4D             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0F4E             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x4F
; 0000 0F4F             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x51
; 0000 0F50             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x39A
; 0000 0F51             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F52 
; 0000 0F53             a[1] = a[0]+0x001;  //ster2
; 0000 0F54             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F55             a[6] = a[5]+0x001;  //okrag
; 0000 0F56             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F57 
; 0000 0F58     break;
; 0000 0F59 
; 0000 0F5A      case 137:
_0x134:
	CPI  R30,LOW(0x89)
	LDI  R26,HIGH(0x89)
	CPC  R31,R26
	BRNE _0x135
; 0000 0F5B 
; 0000 0F5C             a[0] = 0x00C;   //ster1
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x1C
; 0000 0F5D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0F5E             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x33
; 0000 0F5F             a[5] = 0x190;   //delta okrag
; 0000 0F60             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0F61             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0F62 
; 0000 0F63             a[1] = a[0]+0x001;  //ster2
; 0000 0F64             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F65             a[6] = a[5]+0x001;  //okrag
; 0000 0F66             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F67 
; 0000 0F68     break;
; 0000 0F69 
; 0000 0F6A 
; 0000 0F6B      case 138:
_0x135:
	CPI  R30,LOW(0x8A)
	LDI  R26,HIGH(0x8A)
	CPC  R31,R26
	BRNE _0x136
; 0000 0F6C 
; 0000 0F6D             a[0] = 0x0DC;   //ster1
	LDI  R30,LOW(220)
	LDI  R31,HIGH(220)
	CALL SUBOPT_0x1C
; 0000 0F6E             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0F6F             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x1E
; 0000 0F70             a[5] = 0x196;   //delta okrag
; 0000 0F71             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0F72             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F73 
; 0000 0F74             a[1] = a[0]+0x001;  //ster2
; 0000 0F75             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F76             a[6] = a[5]+0x001;  //okrag
; 0000 0F77             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F78 
; 0000 0F79     break;
; 0000 0F7A 
; 0000 0F7B 
; 0000 0F7C      case 139:
_0x136:
	CPI  R30,LOW(0x8B)
	LDI  R26,HIGH(0x8B)
	CPC  R31,R26
	BRNE _0x137
; 0000 0F7D 
; 0000 0F7E             a[0] = 0x058;   //ster1
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	CALL SUBOPT_0x1C
; 0000 0F7F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0F80             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0F81             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x39C
; 0000 0F82             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F83             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F84 
; 0000 0F85             a[1] = a[0]+0x001;  //ster2
; 0000 0F86             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F87             a[6] = a[5]+0x001;  //okrag
; 0000 0F88             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F89 
; 0000 0F8A     break;
; 0000 0F8B 
; 0000 0F8C 
; 0000 0F8D      case 140:
_0x137:
	CPI  R30,LOW(0x8C)
	LDI  R26,HIGH(0x8C)
	CPC  R31,R26
	BRNE _0x138
; 0000 0F8E 
; 0000 0F8F             a[0] = 0x03C;   //ster1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0x1C
; 0000 0F90             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0F91             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0F92             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x51
; 0000 0F93             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x1F
; 0000 0F94             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x21
	RJMP _0x39B
; 0000 0F95 
; 0000 0F96             a[1] = a[0]+0x001;  //ster2
; 0000 0F97             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F98             a[6] = a[5]+0x001;  //okrag
; 0000 0F99             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F9A 
; 0000 0F9B 
; 0000 0F9C 
; 0000 0F9D     break;
; 0000 0F9E 
; 0000 0F9F 
; 0000 0FA0      case 141:
_0x138:
	CPI  R30,LOW(0x8D)
	LDI  R26,HIGH(0x8D)
	CPC  R31,R26
	BRNE _0x139
; 0000 0FA1 
; 0000 0FA2             a[0] = 0x00E;   //ster1
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x1C
; 0000 0FA3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0FA4             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x33
; 0000 0FA5             a[5] = 0x190;   //delta okrag
; 0000 0FA6             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x39A
; 0000 0FA7             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FA8 
; 0000 0FA9             a[1] = a[0]+0x001;  //ster2
; 0000 0FAA             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FAB             a[6] = a[5]+0x001;  //okrag
; 0000 0FAC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FAD 
; 0000 0FAE     break;
; 0000 0FAF 
; 0000 0FB0 
; 0000 0FB1      case 142:
_0x139:
	CPI  R30,LOW(0x8E)
	LDI  R26,HIGH(0x8E)
	CPC  R31,R26
	BRNE _0x13A
; 0000 0FB2 
; 0000 0FB3             a[0] = 0x10A;   //ster1
	LDI  R30,LOW(266)
	LDI  R31,HIGH(266)
	CALL SUBOPT_0x1C
; 0000 0FB4             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x1F
; 0000 0FB5             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x1E
; 0000 0FB6             a[5] = 0x196;   //delta okrag
; 0000 0FB7             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x25
; 0000 0FB8             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0FB9 
; 0000 0FBA             a[1] = a[0]+0x001;  //ster2
; 0000 0FBB             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FBC             a[6] = a[5]+0x001;  //okrag
; 0000 0FBD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FBE 
; 0000 0FBF     break;
; 0000 0FC0 
; 0000 0FC1 
; 0000 0FC2 
; 0000 0FC3      case 143:
_0x13A:
	CPI  R30,LOW(0x8F)
	LDI  R26,HIGH(0x8F)
	CPC  R31,R26
	BRNE _0x13B
; 0000 0FC4 
; 0000 0FC5             a[0] = 0x022;   //ster1
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL SUBOPT_0x1C
; 0000 0FC6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0FC7             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 0FC8             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x32
; 0000 0FC9             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FCA             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x39B
; 0000 0FCB 
; 0000 0FCC             a[1] = a[0]+0x001;  //ster2
; 0000 0FCD             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FCE             a[6] = a[5]+0x001;  //okrag
; 0000 0FCF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FD0 
; 0000 0FD1     break;
; 0000 0FD2 
; 0000 0FD3 
; 0000 0FD4      case 144:
_0x13B:
	CPI  R30,LOW(0x90)
	LDI  R26,HIGH(0x90)
	CPC  R31,R26
	BRNE _0xAB
; 0000 0FD5 
; 0000 0FD6             a[0] = 0x066;   //ster1
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	CALL SUBOPT_0x1C
; 0000 0FD7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x1D
; 0000 0FD8             a[4] = 0x1C;    //ster3 ABS krazek scierny
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
_0x39D:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0FD9             a[5] = 0x19C;   //delta okrag
	__POINTW1MN _a,10
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
_0x39C:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0FDA             a[7] = 0x12;    //ster3 INV krazek scierny
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
_0x39A:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0FDB             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	__POINTW1MN _a,18
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
_0x39B:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0FDC 
; 0000 0FDD             a[1] = a[0]+0x001;  //ster2
	CALL SUBOPT_0x52
	ADIW R30,1
	__PUTW1MN _a,2
; 0000 0FDE             a[2] = a[4];        //ster4 ABS druciak
	CALL SUBOPT_0x53
	__PUTW1MN _a,4
; 0000 0FDF             a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x54
	CALL SUBOPT_0x55
; 0000 0FE0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FE1 
; 0000 0FE2     break;
; 0000 0FE3 
; 0000 0FE4 
; 0000 0FE5 }
_0xAB:
; 0000 0FE6 
; 0000 0FE7 if(predkosc_pion_szczotka == 50)   //zwolnienie predkosci pion
	LDS  R26,_predkosc_pion_szczotka
	LDS  R27,_predkosc_pion_szczotka+1
	SBIW R26,50
	BRNE _0x13D
; 0000 0FE8        {
; 0000 0FE9        a[3] = a[3] - 0x05;
	CALL SUBOPT_0x56
	SBIW R30,5
	__PUTW1MN _a,6
; 0000 0FEA        }
; 0000 0FEB if(predkosc_pion_krazek == 50)   //zwolnienie predkosci pion
_0x13D:
	LDS  R26,_predkosc_pion_krazek
	LDS  R27,_predkosc_pion_krazek+1
	SBIW R26,50
	BRNE _0x13E
; 0000 0FEC        {
; 0000 0FED        a[7] = a[7] - 0x05;
	__GETW1MN _a,14
	SBIW R30,5
	__PUTW1MN _a,14
; 0000 0FEE        }
; 0000 0FEF 
; 0000 0FF0 
; 0000 0FF1 //if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & predkosc_ruchow_po_okregu_krazek_scierny == 50)
; 0000 0FF2     //{
; 0000 0FF3     //nic
; 0000 0FF4     //}
; 0000 0FF5 
; 0000 0FF6 
; 0000 0FF7 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & predkosc_ruchow_po_okregu_krazek_scierny == 50)
_0x13E:
	CALL SUBOPT_0x57
	CALL SUBOPT_0x58
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x13F
; 0000 0FF8     {
; 0000 0FF9     a[5] = a[5] + 0x10;   //plus 16 dzesietnie
	CALL SUBOPT_0x54
	ADIW R30,16
	CALL SUBOPT_0x59
; 0000 0FFA     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x55
; 0000 0FFB     a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FFC     }
; 0000 0FFD 
; 0000 0FFE if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & predkosc_ruchow_po_okregu_krazek_scierny == 10)
_0x13F:
	CALL SUBOPT_0x57
	CALL SUBOPT_0x5A
	MOV  R0,R30
	LDS  R26,_predkosc_ruchow_po_okregu_krazek_scierny
	LDS  R27,_predkosc_ruchow_po_okregu_krazek_scierny+1
	CALL SUBOPT_0x5B
	BREQ _0x140
; 0000 0FFF     {
; 0000 1000     a[5] = a[5] + 0x20;   //plus 32 dzesietnie
	CALL SUBOPT_0x54
	ADIW R30,32
	CALL SUBOPT_0x59
; 0000 1001     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x55
; 0000 1002     a[8] = a[6]+0x001;  //-delta okrag
; 0000 1003     }
; 0000 1004 
; 0000 1005 
; 0000 1006 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & predkosc_ruchow_po_okregu_krazek_scierny == 10)
_0x140:
	CALL SUBOPT_0x57
	CALL SUBOPT_0x58
	CALL SUBOPT_0x5B
	BREQ _0x141
; 0000 1007     {
; 0000 1008     a[5] = a[5] + 0x30;   //plus 48 dzesietnie
	CALL SUBOPT_0x54
	ADIW R30,48
	CALL SUBOPT_0x59
; 0000 1009     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x55
; 0000 100A     a[8] = a[6]+0x001;  //-delta okrag
; 0000 100B     }
; 0000 100C 
; 0000 100D 
; 0000 100E 
; 0000 100F 
; 0000 1010 
; 0000 1011 
; 0000 1012 
; 0000 1013 
; 0000 1014      /*
; 0000 1015         a[0] = 0x05A;   //ster1
; 0000 1016             a[3] = 0x11;    //ster4 INV druciak
; 0000 1017             a[4] = 0x21;    //ster3 ABS krazek scierny
; 0000 1018             a[5] = 0x196;   //delta okrag
; 0000 1019             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 101A             a[9] = 0;       //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 101B 
; 0000 101C             a[1] = a[0]+0x001;  //ster2
; 0000 101D             a[2] = a[4];        //ster4 ABS druciak
; 0000 101E             a[6] = a[5]+0x001;  //okrag
; 0000 101F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1020         */
; 0000 1021 }
_0x141:
	ADIW R28,2
	RET
;
;
;void wartosci_wstepne_panelu()
; 0000 1025 {
_wartosci_wstepne_panelu:
; 0000 1026                                                       //3040
; 0000 1027 wartosc_parametru_panelu(szczotka_druciana_ilosc_cykli,48,64);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x5E
	CALL _wartosc_parametru_panelu
; 0000 1028                                                 //2090
; 0000 1029 wartosc_parametru_panelu(krazek_scierny_ilosc_cykli,32,144);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x60
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0x61
; 0000 102A                                                         //3000
; 0000 102B wartosc_parametru_panelu(krazek_scierny_cykl_po_okregu_ilosc,48,0);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x62
	CALL SUBOPT_0x5D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x61
; 0000 102C                                                 //2050
; 0000 102D wartosc_parametru_panelu(predkosc_pion_szczotka,32,80);
	LDS  R30,_predkosc_pion_szczotka
	LDS  R31,_predkosc_pion_szczotka+1
	CALL SUBOPT_0x60
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x61
; 0000 102E                                                 //2060
; 0000 102F wartosc_parametru_panelu(predkosc_pion_krazek,32,96);
	LDS  R30,_predkosc_pion_krazek
	LDS  R31,_predkosc_pion_krazek+1
	CALL SUBOPT_0x60
	CALL SUBOPT_0x63
; 0000 1030                                                                        //3010
; 0000 1031 wartosc_parametru_panelu(wejscie_krazka_sciernego_w_pow_boczna_cylindra,48,16);
	LDS  R30,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R31,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x64
; 0000 1032                                                                      //2070
; 0000 1033 wartosc_parametru_panelu(predkosc_ruchow_po_okregu_krazek_scierny,32,112);
	LDS  R30,_predkosc_ruchow_po_okregu_krazek_scierny
	LDS  R31,_predkosc_ruchow_po_okregu_krazek_scierny+1
	CALL SUBOPT_0x60
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	CALL SUBOPT_0x61
; 0000 1034 
; 0000 1035 }
	RET
;
;void wypozycjonuj_napedy_minimalistyczna()
; 0000 1038 {
_wypozycjonuj_napedy_minimalistyczna:
; 0000 1039 PORTD.2 = 1;   //setup wspolny
	SBI  0x12,2
; 0000 103A delay_ms(1000);
	CALL SUBOPT_0x65
; 0000 103B 
; 0000 103C 
; 0000 103D 
; 0000 103E 
; 0000 103F while(sprawdz_pin3(PORTJJ,0x79) == 1 | sprawdz_pin3(PORTLL,0x71) == 1 |
_0x144:
; 0000 1040       sprawdz_pin3(PORTKK,0x75) == 1 | sprawdz_pin7(PORTKK,0x75) == 1)
	CALL SUBOPT_0xF
	CALL SUBOPT_0x66
	PUSH R30
	CALL SUBOPT_0x67
	CALL SUBOPT_0x66
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x68
	CALL SUBOPT_0x66
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x68
	CALL SUBOPT_0x69
	POP  R26
	OR   R30,R26
	BRNE PC+3
	JMP _0x146
; 0000 1041       {
; 0000 1042       komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x10
; 0000 1043       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1344
	CALL SUBOPT_0x1B
; 0000 1044       komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x6A
; 0000 1045       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1344
	CALL SUBOPT_0x6B
; 0000 1046       delay_ms(1000);
	CALL SUBOPT_0x65
; 0000 1047 
; 0000 1048       if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0xF
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x147
; 0000 1049             {
; 0000 104A             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x10
; 0000 104B             komunikat_na_panel("Sterownik 1 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1375
	CALL SUBOPT_0x1B
; 0000 104C             delay_ms(1000);
	CALL SUBOPT_0x65
; 0000 104D             }
; 0000 104E       if(sprawdz_pin3(PORTLL,0x71) == 0)
_0x147:
	CALL SUBOPT_0x67
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x148
; 0000 104F             {
; 0000 1050             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x6A
; 0000 1051             komunikat_na_panel("Sterownik 2 - wypozycjonowalem",adr3,adr4);
	__POINTW1FN _0x0,1406
	CALL SUBOPT_0x6B
; 0000 1052             delay_ms(1000);
	CALL SUBOPT_0x65
; 0000 1053             }
; 0000 1054       if(sprawdz_pin3(PORTKK,0x75) == 0)
_0x148:
	CALL SUBOPT_0x68
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x149
; 0000 1055             {
; 0000 1056             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x10
; 0000 1057             komunikat_na_panel("Sterownik 3 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1437
	CALL SUBOPT_0x1B
; 0000 1058             delay_ms(1000);
	CALL SUBOPT_0x65
; 0000 1059             }
; 0000 105A       if(sprawdz_pin7(PORTKK,0x75) == 0)
_0x149:
	CALL SUBOPT_0x68
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x14A
; 0000 105B             {
; 0000 105C             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x6A
; 0000 105D             komunikat_na_panel("Sterownik 4 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1468
	CALL SUBOPT_0x1B
; 0000 105E             delay_ms(1000);
	CALL SUBOPT_0x65
; 0000 105F             }
; 0000 1060 
; 0000 1061 
; 0000 1062 
; 0000 1063        if(sprawdz_pin7(PORTMM,0x77) == 1)
_0x14A:
	CALL SUBOPT_0x6C
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x14B
; 0000 1064             PORTD.7 = 1;
	SBI  0x12,7
; 0000 1065 
; 0000 1066       if(sprawdz_pin6(PORTMM,0x77) == 1 |
_0x14B:
; 0000 1067          sprawdz_pin7(PORTMM,0x77) == 1 |
; 0000 1068          sprawdz_pin5(PORTJJ,0x79) == 1 |
; 0000 1069          sprawdz_pin5(PORTLL,0x71) == 1)
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
	PUSH R30
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x69
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0xF
	CALL SUBOPT_0x6E
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x67
	CALL SUBOPT_0x6E
	POP  R26
	OR   R30,R26
	BREQ _0x14E
; 0000 106A             {
; 0000 106B             PORTD.7 = 1;
	SBI  0x12,7
; 0000 106C             if(sprawdz_pin6(PORTMM,0x77) == 1)
	CALL SUBOPT_0x6C
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x151
; 0000 106D                 {
; 0000 106E                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x10
; 0000 106F                 komunikat_na_panel("Alarm Sterownik 4",adr1,adr2);
	__POINTW1FN _0x0,1499
	CALL SUBOPT_0x1B
; 0000 1070                 delay_ms(1000);
	CALL SUBOPT_0x65
; 0000 1071                 }
; 0000 1072             if(sprawdz_pin7(PORTMM,0x77) == 1)
_0x151:
	CALL SUBOPT_0x6C
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x152
; 0000 1073                 {
; 0000 1074                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x10
; 0000 1075                 komunikat_na_panel("Alarm Sterownik 3",adr1,adr2);
	__POINTW1FN _0x0,1517
	CALL SUBOPT_0x1B
; 0000 1076                 delay_ms(1000);
	CALL SUBOPT_0x65
; 0000 1077                 }
; 0000 1078             if(sprawdz_pin5(PORTJJ,0x79) == 1)
_0x152:
	CALL SUBOPT_0xF
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x153
; 0000 1079                 {
; 0000 107A                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x10
; 0000 107B                 komunikat_na_panel("Alarm Sterownik 1",adr1,adr2);
	__POINTW1FN _0x0,1535
	CALL SUBOPT_0x1B
; 0000 107C                 delay_ms(1000);
	CALL SUBOPT_0x65
; 0000 107D                 }
; 0000 107E             if(sprawdz_pin5(PORTLL,0x71) == 1)
_0x153:
	CALL SUBOPT_0x67
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x154
; 0000 107F                 {
; 0000 1080                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x10
; 0000 1081                 komunikat_na_panel("Alarm Sterownik 2",adr1,adr2);
	__POINTW1FN _0x0,1553
	CALL SUBOPT_0x1B
; 0000 1082                 delay_ms(1000);
	CALL SUBOPT_0x65
; 0000 1083                 }
; 0000 1084 
; 0000 1085             }
_0x154:
; 0000 1086 
; 0000 1087       //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 1088 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 1089       //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 108A        //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 108B 
; 0000 108C 
; 0000 108D 
; 0000 108E       }
_0x14E:
	RJMP _0x144
_0x146:
; 0000 108F 
; 0000 1090 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x10
; 0000 1091 komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1571
	CALL SUBOPT_0x1B
; 0000 1092 komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x6A
; 0000 1093 komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1571
	CALL SUBOPT_0x6B
; 0000 1094 
; 0000 1095 PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 1096 delay_ms(1000);
	CALL SUBOPT_0x65
; 0000 1097 
; 0000 1098 }
	RET
;
;int wypozycjonuj_LEFS32_300_1(int step)
; 0000 109B {
; 0000 109C //PORTF.0   IN0  STEROWNIK3
; 0000 109D //PORTF.1   IN1  STEROWNIK3
; 0000 109E //PORTF.2   IN2  STEROWNIK3
; 0000 109F //PORTF.3   IN3  STEROWNIK3
; 0000 10A0 
; 0000 10A1 //PORTF.4   SETUP  STEROWNIK3
; 0000 10A2 //PORTF.5   DRIVE  STEROWNIK3
; 0000 10A3 
; 0000 10A4 //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 10A5 //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 10A6 
; 0000 10A7 
; 0000 10A8 if(step == 0)
;	step -> Y+0
; 0000 10A9 {
; 0000 10AA switch(pozycjonowanie_LEFS32_300_1)
; 0000 10AB     {
; 0000 10AC     case 0:
; 0000 10AD             PORT_F.bits.b4 = 1;      // ////A9  SETUP
; 0000 10AE             PORTF = PORT_F.byte;
; 0000 10AF 
; 0000 10B0             if(sprawdz_pin0(PORTKK,0x75) == 1)  //BUSY
; 0000 10B1                 {
; 0000 10B2                 }
; 0000 10B3             else
; 0000 10B4                 {
; 0000 10B5                 pozycjonowanie_LEFS32_300_1 = 1;
; 0000 10B6                 }
; 0000 10B7 
; 0000 10B8     break;
; 0000 10B9 
; 0000 10BA     case 1:
; 0000 10BB             if(sprawdz_pin0(PORTKK,0x75) == 0)
; 0000 10BC                 {
; 0000 10BD                 }
; 0000 10BE             else
; 0000 10BF                 {
; 0000 10C0                 pozycjonowanie_LEFS32_300_1 = 2;
; 0000 10C1                 }
; 0000 10C2             if(sprawdz_pin7(PORTMM,0x77) == 1)     //alarm
; 0000 10C3                    {
; 0000 10C4                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 10C5                    komunikat_na_panel("Przeciazenia LEFS32_1",adr1,adr2);
; 0000 10C6                    }
; 0000 10C7 
; 0000 10C8     break;
; 0000 10C9 
; 0000 10CA     case 2:
; 0000 10CB 
; 0000 10CC             if(sprawdz_pin3(PORTKK,0x75) == 1)
; 0000 10CD                 {
; 0000 10CE                 }
; 0000 10CF             else
; 0000 10D0                 {
; 0000 10D1                 pozycjonowanie_LEFS32_300_1 = 3;
; 0000 10D2                 }
; 0000 10D3              if(sprawdz_pin7(PORTMM,0x77) == 1)     //alarm
; 0000 10D4                    {
; 0000 10D5                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 10D6                    komunikat_na_panel("Przeciazenia LEFS32_1",adr1,adr2);
; 0000 10D7                    }
; 0000 10D8 
; 0000 10D9     break;
; 0000 10DA 
; 0000 10DB     case 3:
; 0000 10DC 
; 0000 10DD             if(sprawdz_pin3(PORTKK,0x75) == 0)
; 0000 10DE                 {
; 0000 10DF                 PORT_F.bits.b4 = 0;      // ////A9  SETUP
; 0000 10E0                 PORTF = PORT_F.byte;
; 0000 10E1                 pozycjonowanie_LEFS32_300_1 = 4;
; 0000 10E2 
; 0000 10E3                 }
; 0000 10E4 
; 0000 10E5     break;
; 0000 10E6 
; 0000 10E7     }
; 0000 10E8 }
; 0000 10E9 
; 0000 10EA 
; 0000 10EB 
; 0000 10EC if(step == 1)
; 0000 10ED {
; 0000 10EE while(cykl < 5)
; 0000 10EF {
; 0000 10F0     switch(cykl)
; 0000 10F1         {
; 0000 10F2         case 0:
; 0000 10F3 
; 0000 10F4             sek2 = 0;
; 0000 10F5             PORT_F.bits.b0 = 1;
; 0000 10F6             PORT_F.bits.b1 = 1;         //STEP 0
; 0000 10F7             PORT_F.bits.b2 = 1;
; 0000 10F8             PORT_F.bits.b3 = 1;
; 0000 10F9             PORTF = PORT_F.byte;
; 0000 10FA             cykl = 1;
; 0000 10FB 
; 0000 10FC 
; 0000 10FD         break;
; 0000 10FE 
; 0000 10FF         case 1:
; 0000 1100 
; 0000 1101             if(sek2 > 1)
; 0000 1102                 {
; 0000 1103                 PORT_F.bits.b5 = 1;
; 0000 1104                 PORTF = PORT_F.byte;
; 0000 1105                 cykl = 2;
; 0000 1106                 delay_ms(1000);
; 0000 1107                 }
; 0000 1108         break;
; 0000 1109 
; 0000 110A 
; 0000 110B         case 2:
; 0000 110C 
; 0000 110D                if(sprawdz_pin0(PORTKK,0x75) == 0)
; 0000 110E                   {
; 0000 110F                   PORT_F.bits.b5 = 0;
; 0000 1110                   PORTF = PORT_F.byte;       //DRIVE koniec
; 0000 1111 
; 0000 1112                   PORT_F.bits.b0 = 0;
; 0000 1113                   PORT_F.bits.b1 = 0;         //STEP 1 koniec
; 0000 1114                   PORT_F.bits.b2 = 0;
; 0000 1115                   PORT_F.bits.b3 = 0;
; 0000 1116                   PORTF = PORT_F.byte;
; 0000 1117 
; 0000 1118                   delay_ms(1000);
; 0000 1119                   cykl = 3;
; 0000 111A                   }
; 0000 111B 
; 0000 111C         break;
; 0000 111D 
; 0000 111E         case 3:
; 0000 111F 
; 0000 1120                if(sprawdz_pin3(PORTKK,0x75) == 0)
; 0000 1121                   {
; 0000 1122                   sek2 = 0;
; 0000 1123                   cykl = 4;
; 0000 1124                   }
; 0000 1125               if(sprawdz_pin7(PORTMM,0x77) == 1)     //alarm
; 0000 1126                    {
; 0000 1127                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1128                    komunikat_na_panel("Przeciazenia LEFS32_1",adr1,adr2);
; 0000 1129                    }
; 0000 112A 
; 0000 112B         break;
; 0000 112C 
; 0000 112D 
; 0000 112E         case 4:
; 0000 112F 
; 0000 1130             if(sek2 > 50)
; 0000 1131                 {
; 0000 1132                 cykl = 5;
; 0000 1133                 }
; 0000 1134         break;
; 0000 1135 
; 0000 1136         }
; 0000 1137 }
; 0000 1138 
; 0000 1139 cykl = 0;
; 0000 113A }
; 0000 113B 
; 0000 113C 
; 0000 113D 
; 0000 113E 
; 0000 113F 
; 0000 1140 if(step == 0 & pozycjonowanie_LEFS32_300_1 == 4)
; 0000 1141     {
; 0000 1142     pozycjonowanie_LEFS32_300_1 = 0;
; 0000 1143     cykl = 0;
; 0000 1144     return 1;
; 0000 1145     }
; 0000 1146 if(step == 1)
; 0000 1147     return 2;
; 0000 1148 
; 0000 1149 
; 0000 114A 
; 0000 114B }
;
;
;int wypozycjonuj_LEFS32_300_2(int step)
; 0000 114F {
; 0000 1150 //PORTB.0   IN0  STEROWNIK4
; 0000 1151 //PORTB.1   IN1  STEROWNIK4
; 0000 1152 //PORTB.2   IN2  STEROWNIK4
; 0000 1153 //PORTB.3   IN3  STEROWNIK4
; 0000 1154 
; 0000 1155 //PORTB.4   SETUP  STEROWNIK4
; 0000 1156 //PORTB.5   DRIVE  STEROWNIK4
; 0000 1157 
; 0000 1158 //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 1159 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 115A 
; 0000 115B 
; 0000 115C if(step == 0)
;	step -> Y+0
; 0000 115D {
; 0000 115E switch(pozycjonowanie_LEFS32_300_2)
; 0000 115F     {
; 0000 1160     case 0:
; 0000 1161             PORTB.4 = 1;      // ////A9  SETUP
; 0000 1162 
; 0000 1163             if(sprawdz_pin4(PORTKK,0x75) == 1)  //BUSY
; 0000 1164                 {
; 0000 1165                 }
; 0000 1166             else
; 0000 1167                 pozycjonowanie_LEFS32_300_2 = 1;
; 0000 1168 
; 0000 1169     break;
; 0000 116A 
; 0000 116B     case 1:
; 0000 116C             if(sprawdz_pin4(PORTKK,0x75) == 0)
; 0000 116D                 {
; 0000 116E                 }
; 0000 116F             else
; 0000 1170                 pozycjonowanie_LEFS32_300_2 = 2;
; 0000 1171 
; 0000 1172              if(sprawdz_pin6(PORTMM,0x77) == 1)     //alarm
; 0000 1173                    {
; 0000 1174                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1175                    komunikat_na_panel("Przeciazenia LEFS32_2",adr3,adr4);
; 0000 1176                    }
; 0000 1177 
; 0000 1178     break;
; 0000 1179 
; 0000 117A     case 2:
; 0000 117B 
; 0000 117C             if(sprawdz_pin7(PORTKK,0x75) == 1)
; 0000 117D                 {
; 0000 117E                 }
; 0000 117F             else
; 0000 1180                 pozycjonowanie_LEFS32_300_2 = 3;
; 0000 1181 
; 0000 1182             if(sprawdz_pin6(PORTMM,0x77) == 1)     //alarm
; 0000 1183                    {
; 0000 1184                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1185                    komunikat_na_panel("Przeciazenia LEFS32_2",adr3,adr4);
; 0000 1186                    }
; 0000 1187 
; 0000 1188     break;
; 0000 1189 
; 0000 118A     case 3:
; 0000 118B 
; 0000 118C             if(sprawdz_pin7(PORTKK,0x75) == 0)
; 0000 118D                 {
; 0000 118E                 PORTB.4 = 0;      // ////A9  SETUP
; 0000 118F 
; 0000 1190                 pozycjonowanie_LEFS32_300_2 = 4;
; 0000 1191                 }
; 0000 1192 
; 0000 1193     break;
; 0000 1194 
; 0000 1195     }
; 0000 1196 }
; 0000 1197 
; 0000 1198 if(step == 1)
; 0000 1199 {
; 0000 119A while(cykl < 5)
; 0000 119B {
; 0000 119C     switch(cykl)
; 0000 119D         {
; 0000 119E         case 0:
; 0000 119F 
; 0000 11A0             sek4 = 0;
; 0000 11A1             PORTB.0 = 1;    //STEP 0
; 0000 11A2             PORTB.1 = 1;
; 0000 11A3             PORTB.2 = 1;
; 0000 11A4             PORTB.3 = 1;
; 0000 11A5 
; 0000 11A6             cykl = 1;
; 0000 11A7 
; 0000 11A8 
; 0000 11A9         break;
; 0000 11AA 
; 0000 11AB         case 1:
; 0000 11AC 
; 0000 11AD             if(sek4 > 1)
; 0000 11AE                 {
; 0000 11AF                 PORTB.5 = 1;
; 0000 11B0                 cykl = 2;
; 0000 11B1                 delay_ms(1000);
; 0000 11B2                 }
; 0000 11B3         break;
; 0000 11B4 
; 0000 11B5 
; 0000 11B6         case 2:
; 0000 11B7 
; 0000 11B8                if(sprawdz_pin4(PORTKK,0x75) == 0)
; 0000 11B9                   {
; 0000 11BA                   PORTB.5 = 0;
; 0000 11BB                       //DRIVE koniec
; 0000 11BC 
; 0000 11BD                   PORTB.0 = 0;    //STEP 0
; 0000 11BE                   PORTB.1 = 0;
; 0000 11BF                   PORTB.2 = 0;
; 0000 11C0                   PORTB.3 = 0;
; 0000 11C1 
; 0000 11C2 
; 0000 11C3                   delay_ms(1000);
; 0000 11C4                   cykl = 3;
; 0000 11C5                   }
; 0000 11C6 
; 0000 11C7         break;
; 0000 11C8 
; 0000 11C9         case 3:
; 0000 11CA 
; 0000 11CB                if(sprawdz_pin7(PORTKK,0x75) == 0)
; 0000 11CC                   {
; 0000 11CD                   sek4 = 0;
; 0000 11CE                   cykl = 4;
; 0000 11CF                   }
; 0000 11D0                if(sprawdz_pin6(PORTMM,0x77) == 1)     //alarm
; 0000 11D1                    {
; 0000 11D2                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 11D3                    komunikat_na_panel("Przeciazenia LEFS32_2",adr3,adr4);
; 0000 11D4                    }
; 0000 11D5 
; 0000 11D6 
; 0000 11D7         break;
; 0000 11D8 
; 0000 11D9 
; 0000 11DA         case 4:
; 0000 11DB 
; 0000 11DC             if(sek4 > 50)
; 0000 11DD                 cykl = 5;
; 0000 11DE         break;
; 0000 11DF 
; 0000 11E0         }
; 0000 11E1 }
; 0000 11E2 
; 0000 11E3 cykl = 0;
; 0000 11E4 }
; 0000 11E5 
; 0000 11E6 if(step == 0 & pozycjonowanie_LEFS32_300_2 == 4)
; 0000 11E7     {
; 0000 11E8     pozycjonowanie_LEFS32_300_2 = 0;
; 0000 11E9     cykl = 0;
; 0000 11EA     return 1;
; 0000 11EB     }
; 0000 11EC if(step == 1)
; 0000 11ED     return 2;
; 0000 11EE 
; 0000 11EF }
;
;
;
;
;
;
;int wypozycjonuj_LEFS40_1200_2_i_300_2()
; 0000 11F7 {
; 0000 11F8 //PORTC.0   IN0  STEROWNIK2
; 0000 11F9 //PORTC.1   IN1  STEROWNIK2
; 0000 11FA //PORTC.2   IN2  STEROWNIK2
; 0000 11FB //PORTC.3   IN3  STEROWNIK2
; 0000 11FC //PORTC.4   IN4  STEROWNIK2
; 0000 11FD //PORTC.5   IN5  STEROWNIK2
; 0000 11FE //PORTC.6   IN6  STEROWNIK2
; 0000 11FF //PORTC.7   IN7  STEROWNIK2
; 0000 1200 
; 0000 1201 //PORTD.5  SETUP   STEROWNIK2
; 0000 1202 //PORTD.6  DRIVE   STEROWNIK2
; 0000 1203 
; 0000 1204 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 1205 //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 1206 
; 0000 1207 PORTD.5 = 1;    //SETUP
; 0000 1208 
; 0000 1209 delay_ms(50);
; 0000 120A 
; 0000 120B while(sprawdz_pin0(PORTLL,0x71) == 1)  //kraze tu poki nie wywali busy
; 0000 120C         {
; 0000 120D 
; 0000 120E                    if(sprawdz_pin5(PORTLL,0x71) == 1)     //alarm
; 0000 120F                    {
; 0000 1210                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1211                    komunikat_na_panel("Przeciazenia LEFS_XY_2",adr3,adr4);
; 0000 1212                    }
; 0000 1213 
; 0000 1214         }
; 0000 1215 
; 0000 1216 delay_ms(50);
; 0000 1217 
; 0000 1218 while(sprawdz_pin0(PORTLL,0x71) == 0)  //wywala busy
; 0000 1219         {
; 0000 121A 
; 0000 121B                    if(sprawdz_pin5(PORTLL,0x71) == 1)     //alarm
; 0000 121C                    {
; 0000 121D                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 121E                    komunikat_na_panel("Przeciazenia LEFS_XY_2",adr3,adr4);
; 0000 121F                    }
; 0000 1220         }
; 0000 1221 
; 0000 1222 delay_ms(50);
; 0000 1223 
; 0000 1224 while(sprawdz_pin3(PORTLL,0x71) == 1)  //kraze tu dopoki nie wywali INP
; 0000 1225         {
; 0000 1226         }
; 0000 1227 
; 0000 1228 delay_ms(50);
; 0000 1229 
; 0000 122A if(sprawdz_pin3(PORTLL,0x71) == 0)  //wywala INP
; 0000 122B         {
; 0000 122C         PORTD.5 = 0;
; 0000 122D         putchar(90);  //5A
; 0000 122E         putchar(165); //A5
; 0000 122F         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 1230         putchar(128);  //80
; 0000 1231         putchar(2);    //02
; 0000 1232         putchar(16);   //10
; 0000 1233         }
; 0000 1234 else
; 0000 1235     {
; 0000 1236         putchar(90);  //5A
; 0000 1237         putchar(165); //A5
; 0000 1238         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 1239         putchar(128);  //80
; 0000 123A         putchar(2);    //02
; 0000 123B         putchar(16);   //10
; 0000 123C 
; 0000 123D         delay_ms(1000);     //wywalenie bledu
; 0000 123E         delay_ms(1000);
; 0000 123F 
; 0000 1240         putchar(90);  //5A
; 0000 1241         putchar(165); //A5
; 0000 1242         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 1243         putchar(128);  //80
; 0000 1244         putchar(2);    //02
; 0000 1245         putchar(16);   //10
; 0000 1246 
; 0000 1247     }
; 0000 1248 
; 0000 1249 delay_ms(1000);
; 0000 124A 
; 0000 124B while(cykl < 5)
; 0000 124C {
; 0000 124D     switch(cykl)
; 0000 124E         {
; 0000 124F         case 0:
; 0000 1250 
; 0000 1251             PORTC = 0xFF;   //STEP 0
; 0000 1252             cykl = 1;
; 0000 1253 
; 0000 1254         break;
; 0000 1255 
; 0000 1256         case 1:
; 0000 1257 
; 0000 1258             if(sek3 > 1)
; 0000 1259                 {
; 0000 125A                 PORTD.6 = 1;  //DRIVE
; 0000 125B                 cykl = 2;
; 0000 125C                 }
; 0000 125D         break;
; 0000 125E 
; 0000 125F 
; 0000 1260         case 2:
; 0000 1261 
; 0000 1262                if(sprawdz_pin0(PORTLL,0x71) == 0)
; 0000 1263                   {
; 0000 1264                   PORTD.6 = 0;
; 0000 1265                   PORTC = 0x00;        //STEP 1 koniec
; 0000 1266                   cykl = 3;
; 0000 1267                   }
; 0000 1268 
; 0000 1269         break;
; 0000 126A 
; 0000 126B         case 3:
; 0000 126C 
; 0000 126D                if(sprawdz_pin3(PORTLL,0x71) == 0)
; 0000 126E                   {
; 0000 126F                   sek3 = 0;
; 0000 1270                   cykl = 4;
; 0000 1271                   }
; 0000 1272 
; 0000 1273                    if(sprawdz_pin5(PORTLL,0x71) == 1)     //alarm
; 0000 1274                    {
; 0000 1275                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1276                    komunikat_na_panel("Przeciazenia LEFS_XY_2",adr3,adr4);
; 0000 1277                    }
; 0000 1278 
; 0000 1279 
; 0000 127A         break;
; 0000 127B 
; 0000 127C 
; 0000 127D         case 4:
; 0000 127E 
; 0000 127F             if(sek3 > 50)
; 0000 1280                 cykl = 5;
; 0000 1281         break;
; 0000 1282 
; 0000 1283         }
; 0000 1284 }
; 0000 1285 
; 0000 1286 cykl = 0;
; 0000 1287 return 1;
; 0000 1288 }
;
;
;
;
;int wypozycjonuj_LEFS40_1200_1_i_300_1()
; 0000 128E {
; 0000 128F //chyba nie wpiete A7
; 0000 1290 
; 0000 1291 //PORTA.0   IN0  STEROWNIK1
; 0000 1292 //PORTA.1   IN1  STEROWNIK1
; 0000 1293 //PORTA.2   IN2  STEROWNIK1
; 0000 1294 //PORTA.3   IN3  STEROWNIK1
; 0000 1295 //PORTA.4   IN4  STEROWNIK1
; 0000 1296 //PORTA.5   IN5  STEROWNIK1
; 0000 1297 //PORTA.6   IN6  STEROWNIK1
; 0000 1298 //PORTA.7   IN7  STEROWNIK1
; 0000 1299 
; 0000 129A //PORTD.2  SETUP   STEROWNIK1
; 0000 129B //PORTD.3  DRIVE   STEROWNIK1
; 0000 129C 
; 0000 129D //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 129E //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 129F 
; 0000 12A0 PORTD.2 = 1;    //SETUP
; 0000 12A1 
; 0000 12A2 delay_ms(50);
; 0000 12A3 
; 0000 12A4 while(sprawdz_pin0(PORTJJ,0x79) == 1)  //kraze tu poki nie wywali busy
; 0000 12A5         {
; 0000 12A6             if(sprawdz_pin5(PORTJJ,0x79) == 1)     //alarm
; 0000 12A7                    {
; 0000 12A8                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 12A9                    komunikat_na_panel("Przeciazenia LEFS_XY_1",adr1,adr2);
; 0000 12AA                    }
; 0000 12AB         }
; 0000 12AC 
; 0000 12AD delay_ms(50);
; 0000 12AE 
; 0000 12AF while(sprawdz_pin0(PORTJJ,0x79) == 0)  //wywala busy
; 0000 12B0         {
; 0000 12B1             if(sprawdz_pin5(PORTJJ,0x79) == 1)     //alarm
; 0000 12B2                    {
; 0000 12B3                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 12B4                    komunikat_na_panel("Przeciazenia LEFS_XY_1",adr1,adr2);
; 0000 12B5                    }
; 0000 12B6 
; 0000 12B7         }
; 0000 12B8 
; 0000 12B9 delay_ms(50);
; 0000 12BA 
; 0000 12BB while(sprawdz_pin3(PORTJJ,0x79) == 1)  //kraze tu dopoki nie wywali INP
; 0000 12BC         {
; 0000 12BD         }
; 0000 12BE 
; 0000 12BF delay_ms(50);
; 0000 12C0 
; 0000 12C1 if(sprawdz_pin3(PORTJJ,0x79) == 0)  //wywala INP
; 0000 12C2         {
; 0000 12C3         PORTD.2 = 0;
; 0000 12C4         putchar(90);  //5A
; 0000 12C5         putchar(165); //A5
; 0000 12C6         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 12C7         putchar(128);  //80
; 0000 12C8         putchar(2);    //02
; 0000 12C9         putchar(16);   //10
; 0000 12CA         }
; 0000 12CB else
; 0000 12CC     {
; 0000 12CD         putchar(90);  //5A
; 0000 12CE         putchar(165); //A5
; 0000 12CF         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 12D0         putchar(128);  //80
; 0000 12D1         putchar(2);    //02
; 0000 12D2         putchar(16);   //10
; 0000 12D3 
; 0000 12D4         delay_ms(1000);     //wywalenie bledu
; 0000 12D5         delay_ms(1000);
; 0000 12D6 
; 0000 12D7         putchar(90);  //5A
; 0000 12D8         putchar(165); //A5
; 0000 12D9         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 12DA         putchar(128);  //80
; 0000 12DB         putchar(2);    //02
; 0000 12DC         putchar(16);   //10
; 0000 12DD 
; 0000 12DE     }
; 0000 12DF 
; 0000 12E0 delay_ms(1000);
; 0000 12E1 
; 0000 12E2 while(cykl < 5)
; 0000 12E3 {
; 0000 12E4     switch(cykl)
; 0000 12E5         {
; 0000 12E6         case 0:
; 0000 12E7 
; 0000 12E8             PORTA = 0xFF;   //STEP 0
; 0000 12E9             cykl = 1;
; 0000 12EA 
; 0000 12EB         break;
; 0000 12EC 
; 0000 12ED         case 1:
; 0000 12EE 
; 0000 12EF             if(sek1 > 1)
; 0000 12F0                 {
; 0000 12F1                 PORTD.3 = 1;  //DRIVE
; 0000 12F2                 cykl = 2;
; 0000 12F3                 }
; 0000 12F4         break;
; 0000 12F5 
; 0000 12F6 
; 0000 12F7         case 2:
; 0000 12F8 
; 0000 12F9                if(sprawdz_pin0(PORTJJ,0x79) == 0)
; 0000 12FA                   {
; 0000 12FB                   PORTD.3 = 0;
; 0000 12FC                   PORTA = 0x00;        //STEP 1 koniec
; 0000 12FD                   cykl = 3;
; 0000 12FE                   }
; 0000 12FF 
; 0000 1300         break;
; 0000 1301 
; 0000 1302         case 3:
; 0000 1303 
; 0000 1304                if(sprawdz_pin3(PORTJJ,0x79) == 0)
; 0000 1305                   {
; 0000 1306                   sek1 = 0;
; 0000 1307                   cykl = 4;
; 0000 1308                   }
; 0000 1309 
; 0000 130A                if(sprawdz_pin5(PORTJJ,0x79) == 1)     //alarm
; 0000 130B                    {
; 0000 130C                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 130D                    komunikat_na_panel("Przeciazenia LEFS_XY_1",adr1,adr2);
; 0000 130E                    }
; 0000 130F 
; 0000 1310 
; 0000 1311         break;
; 0000 1312 
; 0000 1313 
; 0000 1314         case 4:
; 0000 1315 
; 0000 1316             if(sek1 > 50)
; 0000 1317                 cykl = 5;
; 0000 1318         break;
; 0000 1319 
; 0000 131A         }
; 0000 131B }
; 0000 131C 
; 0000 131D cykl = 0;
; 0000 131E return 1;
; 0000 131F }
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
; 0000 132A {
; 0000 132B //if(aaa == 0)
; 0000 132C //        {
; 0000 132D //        aaa = wypozycjonuj_LEFS40_1200_1_i_300_1();
; 0000 132E //        }
; 0000 132F if(bbb == 0)
; 0000 1330         {
; 0000 1331         bbb = wypozycjonuj_LEFS32_300_1(0);
; 0000 1332         }
; 0000 1333 if(bbb == 1)
; 0000 1334         {
; 0000 1335         bbb = wypozycjonuj_LEFS32_300_1(1);
; 0000 1336        }
; 0000 1337 
; 0000 1338 
; 0000 1339 //if(ccc == 0)
; 0000 133A //        {
; 0000 133B //        ccc = wypozycjonuj_LEFS40_1200_2_i_300_2();
; 0000 133C //        }
; 0000 133D //if(ddd == 0)
; 0000 133E //        {
; 0000 133F //        ddd = wypozycjonuj_LEFS32_300_2(0);
; 0000 1340 //       }
; 0000 1341 //if(ddd == 1)
; 0000 1342 //        {
; 0000 1343 //        ddd = wypozycjonuj_LEFS32_300_2(1);
; 0000 1344 //        }
; 0000 1345 
; 0000 1346 
; 0000 1347 
; 0000 1348 
; 0000 1349 
; 0000 134A 
; 0000 134B    /*
; 0000 134C 
; 0000 134D     if(ccc == 1 & bbb == 1)
; 0000 134E         ccc = wypozycjonuj_NL3_upgrade(1);
; 0000 134F 
; 0000 1350     if(bbb == 1 & ccc == 2)
; 0000 1351         bbb = wypozycjonuj_NL2_upgrade(1);
; 0000 1352 
; 0000 1353 
; 0000 1354     if(aaa == 1 & bbb == 2 & ccc == 2)
; 0000 1355         {
; 0000 1356         start = 1;
; 0000 1357         }
; 0000 1358 
; 0000 1359     */
; 0000 135A 
; 0000 135B //    if(aaa == 1 & bbb == 2 & ccc == 2 & ddd == 2)
; 0000 135C //        start = 1;
; 0000 135D 
; 0000 135E 
; 0000 135F }
;
;
;
;
;void przerzucanie_dociskow()
; 0000 1365 {
_przerzucanie_dociskow:
; 0000 1366    if(sprawdz_pin6(PORTLL,0x71) == 0 & sprawdz_pin7(PORTLL,0x71) == 0 & czekaj_az_puszcze == 0)
	CALL SUBOPT_0x67
	CALL _sprawdz_pin6
	LDI  R26,LOW(0)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0x67
	CALL _sprawdz_pin7
	LDI  R26,LOW(0)
	CALL __EQB12
	POP  R26
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x70
	AND  R30,R0
	BREQ _0x203
; 0000 1367            {
; 0000 1368            czekaj_az_puszcze = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 1369            //PORTB.6 = 1;
; 0000 136A            }
; 0000 136B        if(sprawdz_pin6(PORTLL,0x71) == 1 & sprawdz_pin7(PORTLL,0x71) == 1 & czekaj_az_puszcze == 1)
_0x203:
	CALL SUBOPT_0x67
	CALL SUBOPT_0x6D
	PUSH R30
	CALL SUBOPT_0x67
	CALL SUBOPT_0x69
	POP  R26
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x5A
	AND  R30,R0
	BREQ _0x204
; 0000 136C            {
; 0000 136D            czekaj_az_puszcze = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 136E            //PORTB.6 = 0;
; 0000 136F            }
; 0000 1370 
; 0000 1371        if(czekaj_az_puszcze == 2 & PORTE.6 == 1)
_0x204:
	CALL SUBOPT_0x71
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x205
; 0000 1372             {
; 0000 1373             PORTE.6 = 0;
	CBI  0x3,6
; 0000 1374             czekaj_az_puszcze = 0;
	CALL SUBOPT_0x72
; 0000 1375             delay_ms(100);
; 0000 1376             }
; 0000 1377 
; 0000 1378        if(czekaj_az_puszcze == 2 & PORTE.6 == 0)
_0x205:
	CALL SUBOPT_0x71
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x208
; 0000 1379            {
; 0000 137A             PORTE.6 = 1;
	SBI  0x3,6
; 0000 137B             czekaj_az_puszcze = 0;
	CALL SUBOPT_0x72
; 0000 137C             delay_ms(100);
; 0000 137D            }
; 0000 137E 
; 0000 137F }
_0x208:
	RET
;
;void ostateczny_wybor_zacisku()
; 0000 1382 {
_ostateczny_wybor_zacisku:
; 0000 1383 int rzad;
; 0000 1384 
; 0000 1385   if(sek11 > 60) //co 1s sekunde sprawdzam   //jak co 40 to sie wywala
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	LDS  R26,_sek11
	LDS  R27,_sek11+1
	LDS  R24,_sek11+2
	LDS  R25,_sek11+3
	__CPD2N 0x3D
	BRGE PC+3
	JMP _0x20B
; 0000 1386         {
; 0000 1387        sek11 = 0;
	CALL SUBOPT_0x73
; 0000 1388        if(odczytalem_zacisk < il_prob_odczytu &
; 0000 1389                                            (sprawdz_pin0(PORTHH,0x73) == 1 |
; 0000 138A                                             sprawdz_pin1(PORTHH,0x73) == 1 |
; 0000 138B                                             sprawdz_pin2(PORTHH,0x73) == 1 |
; 0000 138C                                             sprawdz_pin3(PORTHH,0x73) == 1 |
; 0000 138D                                             sprawdz_pin4(PORTHH,0x73) == 1 |
; 0000 138E                                             sprawdz_pin5(PORTHH,0x73) == 1 |
; 0000 138F                                             sprawdz_pin6(PORTHH,0x73) == 1 |
; 0000 1390                                             sprawdz_pin7(PORTHH,0x73) == 1))
	MOVW R30,R10
	MOVW R26,R8
	CALL __LTW12
	PUSH R30
	CALL SUBOPT_0x12
	CALL _sprawdz_pin0
	LDI  R26,LOW(1)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0x12
	CALL _sprawdz_pin1
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x12
	CALL _sprawdz_pin2
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x66
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x12
	CALL _sprawdz_pin4
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x6E
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x6D
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x69
	POP  R26
	OR   R30,R26
	POP  R26
	AND  R30,R26
	BREQ _0x20C
; 0000 1391         {
; 0000 1392         odczytalem_zacisk++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 1393         }
; 0000 1394         }
_0x20C:
; 0000 1395 
; 0000 1396 if(odczytalem_zacisk == il_prob_odczytu)
_0x20B:
	__CPWRR 10,11,8,9
	BRNE _0x20D
; 0000 1397         {
; 0000 1398         //PORTB = 0xFF;
; 0000 1399         rzad = odczyt_wybranego_zacisku();
	CALL _odczyt_wybranego_zacisku
	MOVW R16,R30
; 0000 139A         //sek10 = 0;
; 0000 139B         sek11 = 0;    //nowe
	CALL SUBOPT_0x73
; 0000 139C         odczytalem_zacisk++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 139D         if(rzad == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x20E
; 0000 139E             wartosc_parametru_panelu(2,32,128);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x60
	CALL SUBOPT_0x15
	CALL _wartosc_parametru_panelu
; 0000 139F         if(rzad == 2)
_0x20E:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x20F
; 0000 13A0             wartosc_parametru_panelu(1,32,128);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x60
	CALL SUBOPT_0x15
	CALL _wartosc_parametru_panelu
; 0000 13A1 
; 0000 13A2         }                                     //& sek10 > 1                //3s po odczytaniu dopiero sprawdzam port
_0x20F:
; 0000 13A3 if((odczytalem_zacisk == il_prob_odczytu + 1))        //183
_0x20D:
	MOVW R30,R10
	ADIW R30,1
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x210
; 0000 13A4         {
; 0000 13A5         odczytalem_zacisk = 0;
	CLR  R8
	CLR  R9
; 0000 13A6         }
; 0000 13A7 }
_0x210:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;
;int sterownik_1_praca(int PORT)
; 0000 13AC {
_sterownik_1_praca:
; 0000 13AD //PORTA.0   IN0  STEROWNIK1
; 0000 13AE //PORTA.1   IN1  STEROWNIK1
; 0000 13AF //PORTA.2   IN2  STEROWNIK1
; 0000 13B0 //PORTA.3   IN3  STEROWNIK1
; 0000 13B1 //PORTA.4   IN4  STEROWNIK1
; 0000 13B2 //PORTA.5   IN5  STEROWNIK1
; 0000 13B3 //PORTA.6   IN6  STEROWNIK1
; 0000 13B4 //PORTA.7   IN7  STEROWNIK1
; 0000 13B5 //PORTD.4   IN8 STEROWNIK1
; 0000 13B6 
; 0000 13B7 //PORTD.2  SETUP   STEROWNIK1
; 0000 13B8 //PORTD.3  DRIVE   STEROWNIK1
; 0000 13B9 
; 0000 13BA //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 13BB //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 13BC 
; 0000 13BD if(sprawdz_pin5(PORTJJ,0x79) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0xF
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x211
; 0000 13BE     PORTD.7 = 1;
	SBI  0x12,7
; 0000 13BF 
; 0000 13C0 switch(cykl_sterownik_1)
_0x211:
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
; 0000 13C1         {
; 0000 13C2         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x217
; 0000 13C3 
; 0000 13C4             sek1 = 0;
	CALL SUBOPT_0x74
; 0000 13C5             PORT_STER1.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER1,R30
; 0000 13C6             PORTA.0 = PORT_STER1.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x218
	CBI  0x1B,0
	RJMP _0x219
_0x218:
	SBI  0x1B,0
_0x219:
; 0000 13C7             PORTA.1 = PORT_STER1.bits.b1;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x2)
	BRNE _0x21A
	CBI  0x1B,1
	RJMP _0x21B
_0x21A:
	SBI  0x1B,1
_0x21B:
; 0000 13C8             PORTA.2 = PORT_STER1.bits.b2;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x4)
	BRNE _0x21C
	CBI  0x1B,2
	RJMP _0x21D
_0x21C:
	SBI  0x1B,2
_0x21D:
; 0000 13C9             PORTA.3 = PORT_STER1.bits.b3;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x8)
	BRNE _0x21E
	CBI  0x1B,3
	RJMP _0x21F
_0x21E:
	SBI  0x1B,3
_0x21F:
; 0000 13CA             PORTA.4 = PORT_STER1.bits.b4;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x10)
	BRNE _0x220
	CBI  0x1B,4
	RJMP _0x221
_0x220:
	SBI  0x1B,4
_0x221:
; 0000 13CB             PORTA.5 = PORT_STER1.bits.b5;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x20)
	BRNE _0x222
	CBI  0x1B,5
	RJMP _0x223
_0x222:
	SBI  0x1B,5
_0x223:
; 0000 13CC             PORTA.6 = PORT_STER1.bits.b6;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x40)
	BRNE _0x224
	CBI  0x1B,6
	RJMP _0x225
_0x224:
	SBI  0x1B,6
_0x225:
; 0000 13CD             PORTA.7 = PORT_STER1.bits.b7;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x80)
	BRNE _0x226
	CBI  0x1B,7
	RJMP _0x227
_0x226:
	SBI  0x1B,7
_0x227:
; 0000 13CE 
; 0000 13CF             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x228
; 0000 13D0                 PORTD.4 = 1;
	SBI  0x12,4
; 0000 13D1 
; 0000 13D2 
; 0000 13D3 
; 0000 13D4             cykl_sterownik_1 = 1;
_0x228:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x3A4
; 0000 13D5 
; 0000 13D6         break;
; 0000 13D7 
; 0000 13D8         case 1:
_0x217:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x22B
; 0000 13D9 
; 0000 13DA             if(sek1 > 1)
	LDS  R26,_sek1
	LDS  R27,_sek1+1
	LDS  R24,_sek1+2
	LDS  R25,_sek1+3
	CALL SUBOPT_0x75
	BRLT _0x22C
; 0000 13DB                 {
; 0000 13DC 
; 0000 13DD                 PORTD.3 = 1;
	SBI  0x12,3
; 0000 13DE                 cykl_sterownik_1 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x76
; 0000 13DF                 }
; 0000 13E0         break;
_0x22C:
	RJMP _0x216
; 0000 13E1 
; 0000 13E2 
; 0000 13E3         case 2:
_0x22B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x22F
; 0000 13E4 
; 0000 13E5                if(sprawdz_pin0(PORTJJ,0x79) == 0)     //busy
	CALL SUBOPT_0xF
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x230
; 0000 13E6                   {
; 0000 13E7 
; 0000 13E8                   PORTD.3 = 0;
	CBI  0x12,3
; 0000 13E9                   PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 13EA                   PORTD.4 = 0;
	CBI  0x12,4
; 0000 13EB                   sek1 = 0;
	CALL SUBOPT_0x74
; 0000 13EC                   cykl_sterownik_1 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x76
; 0000 13ED                   }
; 0000 13EE 
; 0000 13EF         break;
_0x230:
	RJMP _0x216
; 0000 13F0 
; 0000 13F1         case 3:
_0x22F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x235
; 0000 13F2 
; 0000 13F3                if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0xF
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x236
; 0000 13F4                   {
; 0000 13F5 
; 0000 13F6                   sek1 = 0;
	CALL SUBOPT_0x74
; 0000 13F7                   cykl_sterownik_1 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x76
; 0000 13F8                   }
; 0000 13F9 
; 0000 13FA 
; 0000 13FB         break;
_0x236:
	RJMP _0x216
; 0000 13FC 
; 0000 13FD 
; 0000 13FE         case 4:
_0x235:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x216
; 0000 13FF 
; 0000 1400             if(sprawdz_pin0(PORTJJ,0x79) == 1)
	CALL SUBOPT_0xF
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x238
; 0000 1401                 {
; 0000 1402 
; 0000 1403                 cykl_sterownik_1 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x3A4:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
; 0000 1404                 }
; 0000 1405         break;
_0x238:
; 0000 1406 
; 0000 1407         }
_0x216:
; 0000 1408 
; 0000 1409 return cykl_sterownik_1;
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
	RJMP _0x20A0001
; 0000 140A }
;
;
;int sterownik_2_praca(int PORT)
; 0000 140E {
_sterownik_2_praca:
; 0000 140F //PORTC.0   IN0  STEROWNIK2
; 0000 1410 //PORTC.1   IN1  STEROWNIK2
; 0000 1411 //PORTC.2   IN2  STEROWNIK2
; 0000 1412 //PORTC.3   IN3  STEROWNIK2
; 0000 1413 //PORTC.4   IN4  STEROWNIK2
; 0000 1414 //PORTC.5   IN5  STEROWNIK2
; 0000 1415 //PORTC.6   IN6  STEROWNIK2
; 0000 1416 //PORTC.7   IN7  STEROWNIK2
; 0000 1417 //PORTD.5   IN8 STEROWNIK2
; 0000 1418 
; 0000 1419 
; 0000 141A //PORTD.5  SETUP   STEROWNIK2
; 0000 141B //PORTD.6  DRIVE   STEROWNIK2
; 0000 141C 
; 0000 141D //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 141E //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 141F 
; 0000 1420  if(sprawdz_pin5(PORTLL,0x71) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0x67
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x239
; 0000 1421     PORTD.7 = 1;
	SBI  0x12,7
; 0000 1422 
; 0000 1423 switch(cykl_sterownik_2)
_0x239:
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
; 0000 1424         {
; 0000 1425         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x23F
; 0000 1426 
; 0000 1427             sek3 = 0;
	CALL SUBOPT_0x77
; 0000 1428             PORT_STER2.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER2,R30
; 0000 1429             PORTC.0 = PORT_STER2.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x240
	CBI  0x15,0
	RJMP _0x241
_0x240:
	SBI  0x15,0
_0x241:
; 0000 142A             PORTC.1 = PORT_STER2.bits.b1;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x2)
	BRNE _0x242
	CBI  0x15,1
	RJMP _0x243
_0x242:
	SBI  0x15,1
_0x243:
; 0000 142B             PORTC.2 = PORT_STER2.bits.b2;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x4)
	BRNE _0x244
	CBI  0x15,2
	RJMP _0x245
_0x244:
	SBI  0x15,2
_0x245:
; 0000 142C             PORTC.3 = PORT_STER2.bits.b3;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x8)
	BRNE _0x246
	CBI  0x15,3
	RJMP _0x247
_0x246:
	SBI  0x15,3
_0x247:
; 0000 142D             PORTC.4 = PORT_STER2.bits.b4;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x10)
	BRNE _0x248
	CBI  0x15,4
	RJMP _0x249
_0x248:
	SBI  0x15,4
_0x249:
; 0000 142E             PORTC.5 = PORT_STER2.bits.b5;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x20)
	BRNE _0x24A
	CBI  0x15,5
	RJMP _0x24B
_0x24A:
	SBI  0x15,5
_0x24B:
; 0000 142F             PORTC.6 = PORT_STER2.bits.b6;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x40)
	BRNE _0x24C
	CBI  0x15,6
	RJMP _0x24D
_0x24C:
	SBI  0x15,6
_0x24D:
; 0000 1430             PORTC.7 = PORT_STER2.bits.b7;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x80)
	BRNE _0x24E
	CBI  0x15,7
	RJMP _0x24F
_0x24E:
	SBI  0x15,7
_0x24F:
; 0000 1431             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x250
; 0000 1432                 PORTD.5 = 1;
	SBI  0x12,5
; 0000 1433 
; 0000 1434 
; 0000 1435             cykl_sterownik_2 = 1;
_0x250:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x3A5
; 0000 1436 
; 0000 1437 
; 0000 1438         break;
; 0000 1439 
; 0000 143A         case 1:
_0x23F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x253
; 0000 143B 
; 0000 143C             if(sek3 > 1)
	LDS  R26,_sek3
	LDS  R27,_sek3+1
	LDS  R24,_sek3+2
	LDS  R25,_sek3+3
	CALL SUBOPT_0x75
	BRLT _0x254
; 0000 143D                 {
; 0000 143E                 PORTD.6 = 1;
	SBI  0x12,6
; 0000 143F                 cykl_sterownik_2 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x78
; 0000 1440                 }
; 0000 1441         break;
_0x254:
	RJMP _0x23E
; 0000 1442 
; 0000 1443 
; 0000 1444         case 2:
_0x253:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x257
; 0000 1445 
; 0000 1446                if(sprawdz_pin0(PORTLL,0x71) == 0)     //busy
	CALL SUBOPT_0x67
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x258
; 0000 1447                   {
; 0000 1448                   PORTD.6 = 0;
	CBI  0x12,6
; 0000 1449                   PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 144A                   PORTD.5 = 0;
	CBI  0x12,5
; 0000 144B                   sek3 = 0;
	CALL SUBOPT_0x77
; 0000 144C                   cykl_sterownik_2 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x78
; 0000 144D                   }
; 0000 144E 
; 0000 144F         break;
_0x258:
	RJMP _0x23E
; 0000 1450 
; 0000 1451         case 3:
_0x257:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x25D
; 0000 1452 
; 0000 1453                if(sprawdz_pin3(PORTLL,0x71) == 0)
	CALL SUBOPT_0x67
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x25E
; 0000 1454                   {
; 0000 1455                   sek3 = 0;
	CALL SUBOPT_0x77
; 0000 1456                   cykl_sterownik_2 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x78
; 0000 1457                   }
; 0000 1458 
; 0000 1459 
; 0000 145A         break;
_0x25E:
	RJMP _0x23E
; 0000 145B 
; 0000 145C 
; 0000 145D         case 4:
_0x25D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x23E
; 0000 145E 
; 0000 145F             if(sprawdz_pin0(PORTLL,0x71) == 1)
	CALL SUBOPT_0x67
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x260
; 0000 1460                 {
; 0000 1461                 cykl_sterownik_2 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x3A5:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
; 0000 1462                 }
; 0000 1463         break;
_0x260:
; 0000 1464 
; 0000 1465         }
_0x23E:
; 0000 1466 
; 0000 1467 return cykl_sterownik_2;
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
	RJMP _0x20A0001
; 0000 1468 }
;
;
;
;
;
;
;int sterownik_3_praca(int PORT)
; 0000 1470 {
_sterownik_3_praca:
; 0000 1471 //PORTF.0   IN0  STEROWNIK3
; 0000 1472 //PORTF.1   IN1  STEROWNIK3
; 0000 1473 //PORTF.2   IN2  STEROWNIK3
; 0000 1474 //PORTF.3   IN3  STEROWNIK3
; 0000 1475 //PORTF.7   IN4 STEROWNIK 3
; 0000 1476 //PORTB.7   IN5 STEROWNIK 3
; 0000 1477 
; 0000 1478 
; 0000 1479 
; 0000 147A //PORTF.5   DRIVE  STEROWNIK3
; 0000 147B 
; 0000 147C //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 147D //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 147E 
; 0000 147F if(sprawdz_pin7(PORTMM,0x77) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0x6C
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x261
; 0000 1480      PORTD.7 = 1;
	SBI  0x12,7
; 0000 1481 
; 0000 1482 switch(cykl_sterownik_3)
_0x261:
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
; 0000 1483         {
; 0000 1484         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x267
; 0000 1485 
; 0000 1486             PORT_STER3.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER3,R30
; 0000 1487             PORT_F.bits.b0 = PORT_STER3.bits.b0;
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0x79
; 0000 1488             PORT_F.bits.b1 = PORT_STER3.bits.b1;
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFD
	CALL SUBOPT_0x79
; 0000 1489             PORT_F.bits.b2 = PORT_STER3.bits.b2;
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFB
	CALL SUBOPT_0x79
; 0000 148A             PORT_F.bits.b3 = PORT_STER3.bits.b3;
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
	CALL SUBOPT_0x79
; 0000 148B             PORT_F.bits.b7 = PORT_STER3.bits.b4;
	SWAP R30
	ANDI R30,LOW(0x1)
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0x7F
	OR   R30,R0
	CALL SUBOPT_0x7A
; 0000 148C             PORTF = PORT_F.byte;
; 0000 148D             PORTB.7 = PORT_STER3.bits.b5;
	LDS  R30,_PORT_STER3
	ANDI R30,LOW(0x20)
	BRNE _0x268
	CBI  0x18,7
	RJMP _0x269
_0x268:
	SBI  0x18,7
_0x269:
; 0000 148E 
; 0000 148F 
; 0000 1490 
; 0000 1491             sek2 = 0;
	CALL SUBOPT_0x7B
; 0000 1492             cykl_sterownik_3 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x7C
; 0000 1493 
; 0000 1494 
; 0000 1495 
; 0000 1496         break;
	RJMP _0x266
; 0000 1497 
; 0000 1498         case 1:
_0x267:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x26A
; 0000 1499 
; 0000 149A 
; 0000 149B             if(sek2 > 1)
	LDS  R26,_sek2
	LDS  R27,_sek2+1
	LDS  R24,_sek2+2
	LDS  R25,_sek2+3
	CALL SUBOPT_0x75
	BRLT _0x26B
; 0000 149C                 {
; 0000 149D 
; 0000 149E                 PORT_F.bits.b5 = 1;
	LDS  R30,_PORT_F
	ORI  R30,0x20
	CALL SUBOPT_0x7A
; 0000 149F                 PORTF = PORT_F.byte;
; 0000 14A0                 cykl_sterownik_3 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x7C
; 0000 14A1                 }
; 0000 14A2         break;
_0x26B:
	RJMP _0x266
; 0000 14A3 
; 0000 14A4 
; 0000 14A5         case 2:
_0x26A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x26C
; 0000 14A6 
; 0000 14A7 
; 0000 14A8                if(sprawdz_pin0(PORTKK,0x75) == 0)
	CALL SUBOPT_0x68
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x26D
; 0000 14A9                   {
; 0000 14AA                   PORT_F.bits.b5 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xDF
	CALL SUBOPT_0x7A
; 0000 14AB                   PORTF = PORT_F.byte;
; 0000 14AC 
; 0000 14AD                   PORT_F.bits.b0 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0x7D
; 0000 14AE                   PORT_F.bits.b1 = 0;
	ANDI R30,0xFD
	CALL SUBOPT_0x7D
; 0000 14AF                   PORT_F.bits.b2 = 0;
	ANDI R30,0xFB
	CALL SUBOPT_0x7D
; 0000 14B0                   PORT_F.bits.b3 = 0;
	ANDI R30,0XF7
	CALL SUBOPT_0x7D
; 0000 14B1                   PORT_F.bits.b7 = 0;
	ANDI R30,0x7F
	CALL SUBOPT_0x7A
; 0000 14B2                   PORTF = PORT_F.byte;
; 0000 14B3                   PORTB.7 = 0;
	CBI  0x18,7
; 0000 14B4 
; 0000 14B5                   sek2 = 0;
	CALL SUBOPT_0x7B
; 0000 14B6                   cykl_sterownik_3 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x7C
; 0000 14B7                   }
; 0000 14B8 
; 0000 14B9         break;
_0x26D:
	RJMP _0x266
; 0000 14BA 
; 0000 14BB         case 3:
_0x26C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x270
; 0000 14BC 
; 0000 14BD 
; 0000 14BE                if(sprawdz_pin3(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0x68
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x271
; 0000 14BF                   {
; 0000 14C0                   sek2 = 0;
	CALL SUBOPT_0x7B
; 0000 14C1                   cykl_sterownik_3 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x7C
; 0000 14C2                   }
; 0000 14C3 
; 0000 14C4 
; 0000 14C5         break;
_0x271:
	RJMP _0x266
; 0000 14C6 
; 0000 14C7 
; 0000 14C8         case 4:
_0x270:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x266
; 0000 14C9 
; 0000 14CA               if(sprawdz_pin0(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0x68
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x273
; 0000 14CB                 {
; 0000 14CC                 cykl_sterownik_3 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x7C
; 0000 14CD 
; 0000 14CE 
; 0000 14CF                 switch(cykl_sterownik_3_wykonalem)
	LDS  R30,_cykl_sterownik_3_wykonalem
	LDS  R31,_cykl_sterownik_3_wykonalem+1
; 0000 14D0                     {
; 0000 14D1                     case 0:
	SBIW R30,0
	BRNE _0x277
; 0000 14D2                             cykl_sterownik_3_wykonalem = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R31
; 0000 14D3                     break;
	RJMP _0x276
; 0000 14D4 
; 0000 14D5                     case 1:
_0x277:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x276
; 0000 14D6                             cykl_sterownik_3_wykonalem = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R30
; 0000 14D7                     break;
; 0000 14D8 
; 0000 14D9                     }
_0x276:
; 0000 14DA 
; 0000 14DB 
; 0000 14DC                 }
; 0000 14DD         break;
_0x273:
; 0000 14DE 
; 0000 14DF         }
_0x266:
; 0000 14E0 
; 0000 14E1 return cykl_sterownik_3;
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
	RJMP _0x20A0001
; 0000 14E2 }
;
;//
;//int sterownik_4_praca(char f,char e,char d, char c, char b, char a)
;int sterownik_4_praca(int PORT)
; 0000 14E7 {
_sterownik_4_praca:
; 0000 14E8 
; 0000 14E9 
; 0000 14EA //PORTB.0   IN0  STEROWNIK4
; 0000 14EB //PORTB.1   IN1  STEROWNIK4
; 0000 14EC //PORTB.2   IN2  STEROWNIK4
; 0000 14ED //PORTB.3   IN3  STEROWNIK4
; 0000 14EE //PORTE.4  IN4  STEROWNIK4
; 0000 14EF //PORTE.5  IN5  STEROWNIK4
; 0000 14F0 
; 0000 14F1 
; 0000 14F2 //PORTB.4   SETUP  STEROWNIK4
; 0000 14F3 //PORTB.5   DRIVE  STEROWNIK4
; 0000 14F4 
; 0000 14F5 //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 14F6 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 14F7 
; 0000 14F8 if(sprawdz_pin6(PORTMM,0x77) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0x6C
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x279
; 0000 14F9     PORTD.7 = 1;
	SBI  0x12,7
; 0000 14FA 
; 0000 14FB switch(cykl_sterownik_4)
_0x279:
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
; 0000 14FC         {
; 0000 14FD         case 0:
	SBIW R30,0
	BRNE _0x27F
; 0000 14FE 
; 0000 14FF             PORT_STER4.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER4,R30
; 0000 1500             PORTB.0 = PORT_STER4.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x280
	CBI  0x18,0
	RJMP _0x281
_0x280:
	SBI  0x18,0
_0x281:
; 0000 1501             PORTB.1 = PORT_STER4.bits.b1;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x2)
	BRNE _0x282
	CBI  0x18,1
	RJMP _0x283
_0x282:
	SBI  0x18,1
_0x283:
; 0000 1502             PORTB.2 = PORT_STER4.bits.b2;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x4)
	BRNE _0x284
	CBI  0x18,2
	RJMP _0x285
_0x284:
	SBI  0x18,2
_0x285:
; 0000 1503             PORTB.3 = PORT_STER4.bits.b3;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x8)
	BRNE _0x286
	CBI  0x18,3
	RJMP _0x287
_0x286:
	SBI  0x18,3
_0x287:
; 0000 1504             PORTE.4 = PORT_STER4.bits.b4;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x10)
	BRNE _0x288
	CBI  0x3,4
	RJMP _0x289
_0x288:
	SBI  0x3,4
_0x289:
; 0000 1505             PORTE.5 = PORT_STER4.bits.b5;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x20)
	BRNE _0x28A
	CBI  0x3,5
	RJMP _0x28B
_0x28A:
	SBI  0x3,5
_0x28B:
; 0000 1506 
; 0000 1507             sek4 = 0;
	CALL SUBOPT_0x7E
; 0000 1508             cykl_sterownik_4 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x3A6
; 0000 1509 
; 0000 150A         break;
; 0000 150B 
; 0000 150C         case 1:
_0x27F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x28C
; 0000 150D 
; 0000 150E             if(sek4 > 1)
	LDS  R26,_sek4
	LDS  R27,_sek4+1
	LDS  R24,_sek4+2
	LDS  R25,_sek4+3
	CALL SUBOPT_0x75
	BRLT _0x28D
; 0000 150F                 {
; 0000 1510                 PORTB.5 = 1;
	SBI  0x18,5
; 0000 1511                 cykl_sterownik_4 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x7F
; 0000 1512                 }
; 0000 1513         break;
_0x28D:
	RJMP _0x27E
; 0000 1514 
; 0000 1515 
; 0000 1516         case 2:
_0x28C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x290
; 0000 1517 
; 0000 1518                if(sprawdz_pin4(PORTKK,0x75) == 0)
	CALL SUBOPT_0x68
	CALL _sprawdz_pin4
	CPI  R30,0
	BRNE _0x291
; 0000 1519                   {
; 0000 151A                   PORTB.5 = 0;  //drive
	CBI  0x18,5
; 0000 151B 
; 0000 151C                   PORTB.0 = 0;
	CBI  0x18,0
; 0000 151D                   PORTB.1 = 0;
	CBI  0x18,1
; 0000 151E                   PORTB.2 = 0;
	CBI  0x18,2
; 0000 151F                   PORTB.3 = 0;
	CBI  0x18,3
; 0000 1520                   PORTE.4 = 0;
	CBI  0x3,4
; 0000 1521                   PORTE.5 = 0;
	CBI  0x3,5
; 0000 1522 
; 0000 1523                   sek4 = 0;
	CALL SUBOPT_0x7E
; 0000 1524                   cykl_sterownik_4 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x7F
; 0000 1525                   }
; 0000 1526 
; 0000 1527         break;
_0x291:
	RJMP _0x27E
; 0000 1528 
; 0000 1529         case 3:
_0x290:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2A0
; 0000 152A 
; 0000 152B                if(sprawdz_pin7(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0x68
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x2A1
; 0000 152C                   {
; 0000 152D                   sek4 = 0;
	CALL SUBOPT_0x7E
; 0000 152E                   cykl_sterownik_4 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x7F
; 0000 152F                   }
; 0000 1530 
; 0000 1531 
; 0000 1532         break;
_0x2A1:
	RJMP _0x27E
; 0000 1533 
; 0000 1534 
; 0000 1535         case 4:
_0x2A0:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x27E
; 0000 1536 
; 0000 1537               if(sprawdz_pin4(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0x68
	CALL _sprawdz_pin4
	CPI  R30,LOW(0x1)
	BRNE _0x2A3
; 0000 1538                 {
; 0000 1539                 cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x3A6:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
; 0000 153A                 }
; 0000 153B         break;
_0x2A3:
; 0000 153C 
; 0000 153D         }
_0x27E:
; 0000 153E 
; 0000 153F return cykl_sterownik_4;
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
_0x20A0001:
	ADIW R28,2
	RET
; 0000 1540 }
;
;
;void wymiana_szczotki_i_krazka()
; 0000 1544 {
_wymiana_szczotki_i_krazka:
; 0000 1545 int g,e,f,d,cykl_wymiany;
; 0000 1546 cykl_wymiany = 0;
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
; 0000 1547                       //30 //20
; 0000 1548 g = odczytaj_parametr(48,32);  //szczotka druciana
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x60
	CALL _odczytaj_parametr
	MOVW R16,R30
; 0000 1549                     //30  //30
; 0000 154A f = odczytaj_parametr(48,48);  //krazek scierny
	CALL SUBOPT_0x80
	CALL _odczytaj_parametr
	MOVW R20,R30
; 0000 154B 
; 0000 154C while(g == 1)
_0x2A4:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+3
	JMP _0x2A6
; 0000 154D     {
; 0000 154E     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 154F     {
; 0000 1550     case 0:
	SBIW R30,0
	BRNE _0x2AA
; 0000 1551 
; 0000 1552                cykl_sterownik_1 = 0;
	CALL SUBOPT_0x81
; 0000 1553                cykl_sterownik_2 = 0;
; 0000 1554                cykl_sterownik_3 = 0;
; 0000 1555                cykl_sterownik_4 = 0;
; 0000 1556                cykl_wymiany = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1557 
; 0000 1558 
; 0000 1559 
; 0000 155A     break;
	RJMP _0x2A9
; 0000 155B 
; 0000 155C     case 1:
_0x2AA:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2AB
; 0000 155D 
; 0000 155E             //na sam dol zjezdzamy pionami
; 0000 155F                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x82
	SBIW R26,5
	BRGE _0x2AC
; 0000 1560                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x83
	CALL SUBOPT_0x84
; 0000 1561                 if(cykl_sterownik_4 < 5)
_0x2AC:
	CALL SUBOPT_0x85
	SBIW R26,5
	BRGE _0x2AD
; 0000 1562                     cykl_sterownik_4 = sterownik_4_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x83
	CALL SUBOPT_0x86
; 0000 1563 
; 0000 1564                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2AD:
	CALL SUBOPT_0x87
	BREQ _0x2AE
; 0000 1565 
; 0000 1566                             {
; 0000 1567                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x88
; 0000 1568                                         cykl_sterownik_4 = 0;
; 0000 1569                                         cykl_wymiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 156A                                         }
; 0000 156B 
; 0000 156C 
; 0000 156D 
; 0000 156E     break;
_0x2AE:
	RJMP _0x2A9
; 0000 156F 
; 0000 1570 
; 0000 1571 
; 0000 1572     case 2:
_0x2AB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2AF
; 0000 1573 
; 0000 1574                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x89
	SBIW R26,5
	BRGE _0x2B0
; 0000 1575                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x8B
; 0000 1576                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x2B0:
	CALL SUBOPT_0x8C
	SBIW R26,5
	BRGE _0x2B1
; 0000 1577                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x8D
; 0000 1578 
; 0000 1579                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x2B1:
	CALL SUBOPT_0x8E
	BREQ _0x2B2
; 0000 157A                                         {
; 0000 157B                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x81
; 0000 157C                                         cykl_sterownik_2 = 0;
; 0000 157D                                         cykl_sterownik_3 = 0;
; 0000 157E                                         cykl_sterownik_4 = 0;
; 0000 157F                                          cykl_wymiany = 3;
	CALL SUBOPT_0x8F
; 0000 1580 
; 0000 1581                                         }
; 0000 1582 
; 0000 1583     break;
_0x2B2:
	RJMP _0x2A9
; 0000 1584 
; 0000 1585 
; 0000 1586 
; 0000 1587     case 3:
_0x2AF:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2B3
; 0000 1588 
; 0000 1589             //na sam dol zjezdzamy pionami
; 0000 158A                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x82
	SBIW R26,5
	BRGE _0x2B4
; 0000 158B                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	CALL SUBOPT_0x90
	CALL SUBOPT_0x84
; 0000 158C                 if(cykl_sterownik_4 < 5)
_0x2B4:
	CALL SUBOPT_0x85
	SBIW R26,5
	BRGE _0x2B5
; 0000 158D                     cykl_sterownik_4 = sterownik_4_praca(0x02);  //do pozycji wymiany
	CALL SUBOPT_0x90
	CALL SUBOPT_0x86
; 0000 158E 
; 0000 158F                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2B5:
	CALL SUBOPT_0x87
	BREQ _0x2B6
; 0000 1590 
; 0000 1591                             {
; 0000 1592                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x88
; 0000 1593                                         cykl_sterownik_4 = 0;
; 0000 1594                                         d = odczytaj_parametr(48,32);
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x60
	CALL _odczytaj_parametr
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 1595 
; 0000 1596                                         switch (d)
; 0000 1597                                         {
; 0000 1598                                         case 0:
	SBIW R30,0
	BRNE _0x2BA
; 0000 1599 
; 0000 159A                                              cykl_wymiany = 4;
	CALL SUBOPT_0x91
; 0000 159B                                              //jednak nie wymianiamy
; 0000 159C 
; 0000 159D                                         break;
	RJMP _0x2B9
; 0000 159E 
; 0000 159F                                         case 1:
_0x2BA:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2BB
; 0000 15A0                                              cykl_wymiany = 3;
	CALL SUBOPT_0x8F
; 0000 15A1                                              //czekam z decyzja - w trakcie wymiany
; 0000 15A2                                         break;
	RJMP _0x2B9
; 0000 15A3 
; 0000 15A4                                         case 2:
_0x2BB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2B9
; 0000 15A5                                              cykl_wymiany = 4;
	CALL SUBOPT_0x91
; 0000 15A6                                              wymieniono_szczotke_druciana = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wymieniono_szczotke_druciana,R30
	STS  _wymieniono_szczotke_druciana+1,R31
; 0000 15A7                                              //wymianymy
; 0000 15A8                                         break;
; 0000 15A9                                         }
_0x2B9:
; 0000 15AA                             }
; 0000 15AB 
; 0000 15AC 
; 0000 15AD 
; 0000 15AE 
; 0000 15AF 
; 0000 15B0 
; 0000 15B1     break;
_0x2B6:
	RJMP _0x2A9
; 0000 15B2 
; 0000 15B3    case 4:
_0x2B3:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2A9
; 0000 15B4 
; 0000 15B5                       //na sam dol zjezdzamy pionami
; 0000 15B6                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x82
	SBIW R26,5
	BRGE _0x2BE
; 0000 15B7                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x83
	CALL SUBOPT_0x84
; 0000 15B8                 if(cykl_sterownik_4 < 5)
_0x2BE:
	CALL SUBOPT_0x85
	SBIW R26,5
	BRGE _0x2BF
; 0000 15B9                     cykl_sterownik_4 = sterownik_4_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x83
	CALL SUBOPT_0x86
; 0000 15BA 
; 0000 15BB                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2BF:
	CALL SUBOPT_0x87
	BREQ _0x2C0
; 0000 15BC 
; 0000 15BD                             {
; 0000 15BE                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x81
; 0000 15BF                                         cykl_sterownik_2 = 0;
; 0000 15C0                                         cykl_sterownik_3 = 0;
; 0000 15C1                                         cykl_sterownik_4 = 0;
; 0000 15C2                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 15C3                                         g = 0;
	__GETWRN 16,17,0
; 0000 15C4                                         }
; 0000 15C5 
; 0000 15C6    break;
_0x2C0:
; 0000 15C7 
; 0000 15C8 
; 0000 15C9     }//switch
_0x2A9:
; 0000 15CA 
; 0000 15CB    }//while
	RJMP _0x2A4
_0x2A6:
; 0000 15CC 
; 0000 15CD f = odczytaj_parametr(48,48);  //krazek scierny
	CALL SUBOPT_0x80
	CALL _odczytaj_parametr
	MOVW R20,R30
; 0000 15CE cykl_wymiany = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 15CF 
; 0000 15D0 while(f == 1)
_0x2C1:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ PC+3
	JMP _0x2C3
; 0000 15D1     {
; 0000 15D2     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 15D3     {
; 0000 15D4     case 0:
	SBIW R30,0
	BRNE _0x2C7
; 0000 15D5 
; 0000 15D6                cykl_sterownik_1 = 0;
	CALL SUBOPT_0x81
; 0000 15D7                cykl_sterownik_2 = 0;
; 0000 15D8                cykl_sterownik_3 = 0;
; 0000 15D9                cykl_sterownik_4 = 0;
; 0000 15DA                cykl_wymiany = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 15DB 
; 0000 15DC 
; 0000 15DD 
; 0000 15DE     break;
	RJMP _0x2C6
; 0000 15DF 
; 0000 15E0     case 1:
_0x2C7:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2C8
; 0000 15E1 
; 0000 15E2             //na sam dol zjezdzamy pionami
; 0000 15E3                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x82
	SBIW R26,5
	BRGE _0x2C9
; 0000 15E4                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x83
	CALL SUBOPT_0x84
; 0000 15E5                 if(cykl_sterownik_4 < 5)
_0x2C9:
	CALL SUBOPT_0x85
	SBIW R26,5
	BRGE _0x2CA
; 0000 15E6                     cykl_sterownik_4 = sterownik_4_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x83
	CALL SUBOPT_0x86
; 0000 15E7 
; 0000 15E8                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2CA:
	CALL SUBOPT_0x87
	BREQ _0x2CB
; 0000 15E9 
; 0000 15EA                             {
; 0000 15EB                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x88
; 0000 15EC                                         cykl_sterownik_4 = 0;
; 0000 15ED                                         cykl_wymiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 15EE                                         }
; 0000 15EF 
; 0000 15F0 
; 0000 15F1 
; 0000 15F2     break;
_0x2CB:
	RJMP _0x2C6
; 0000 15F3 
; 0000 15F4 
; 0000 15F5 
; 0000 15F6     case 2:
_0x2C8:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2CC
; 0000 15F7 
; 0000 15F8                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x89
	SBIW R26,5
	BRGE _0x2CD
; 0000 15F9                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x8B
; 0000 15FA                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x2CD:
	CALL SUBOPT_0x8C
	SBIW R26,5
	BRGE _0x2CE
; 0000 15FB                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x8D
; 0000 15FC 
; 0000 15FD                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x2CE:
	CALL SUBOPT_0x8E
	BREQ _0x2CF
; 0000 15FE                                         {
; 0000 15FF                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x81
; 0000 1600                                         cykl_sterownik_2 = 0;
; 0000 1601                                         cykl_sterownik_3 = 0;
; 0000 1602                                         cykl_sterownik_4 = 0;
; 0000 1603                                          cykl_wymiany = 3;
	CALL SUBOPT_0x8F
; 0000 1604 
; 0000 1605                                         }
; 0000 1606 
; 0000 1607     break;
_0x2CF:
	RJMP _0x2C6
; 0000 1608 
; 0000 1609 
; 0000 160A 
; 0000 160B     case 3:
_0x2CC:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2D0
; 0000 160C 
; 0000 160D             //na sam dol zjezdzamy pionami
; 0000 160E                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x82
	SBIW R26,5
	BRGE _0x2D1
; 0000 160F                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	CALL SUBOPT_0x90
	CALL SUBOPT_0x84
; 0000 1610                 if(cykl_sterownik_4 < 5)
_0x2D1:
	CALL SUBOPT_0x85
	SBIW R26,5
	BRGE _0x2D2
; 0000 1611                     cykl_sterownik_4 = sterownik_4_praca(0x02);  //do pozycji wymiany
	CALL SUBOPT_0x90
	CALL SUBOPT_0x86
; 0000 1612 
; 0000 1613                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2D2:
	CALL SUBOPT_0x87
	BREQ _0x2D3
; 0000 1614 
; 0000 1615                             {
; 0000 1616                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x88
; 0000 1617                                         cykl_sterownik_4 = 0;
; 0000 1618                                         e = odczytaj_parametr(48,48);
	CALL SUBOPT_0x80
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 1619 
; 0000 161A                                         switch (e)
	MOVW R30,R18
; 0000 161B                                         {
; 0000 161C                                         case 0:
	SBIW R30,0
	BRNE _0x2D7
; 0000 161D 
; 0000 161E                                              cykl_wymiany = 4;
	CALL SUBOPT_0x91
; 0000 161F                                              //jednak nie wymianiamy
; 0000 1620 
; 0000 1621                                         break;
	RJMP _0x2D6
; 0000 1622 
; 0000 1623                                         case 1:
_0x2D7:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2D8
; 0000 1624                                              cykl_wymiany = 3;
	CALL SUBOPT_0x8F
; 0000 1625                                              //czekam z decyzja - w trakcie wymiany
; 0000 1626                                         break;
	RJMP _0x2D6
; 0000 1627 
; 0000 1628                                         case 2:
_0x2D8:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2D6
; 0000 1629                                              cykl_wymiany = 4;
	CALL SUBOPT_0x91
; 0000 162A                                              wymieniono_krazek_scierny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wymieniono_krazek_scierny,R30
	STS  _wymieniono_krazek_scierny+1,R31
; 0000 162B                                              //wymianymy
; 0000 162C                                         break;
; 0000 162D                                         }
_0x2D6:
; 0000 162E                             }
; 0000 162F 
; 0000 1630 
; 0000 1631 
; 0000 1632 
; 0000 1633 
; 0000 1634 
; 0000 1635     break;
_0x2D3:
	RJMP _0x2C6
; 0000 1636 
; 0000 1637    case 4:
_0x2D0:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2C6
; 0000 1638 
; 0000 1639                       //na sam dol zjezdzamy pionami
; 0000 163A                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x82
	SBIW R26,5
	BRGE _0x2DB
; 0000 163B                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x83
	CALL SUBOPT_0x84
; 0000 163C                 if(cykl_sterownik_4 < 5)
_0x2DB:
	CALL SUBOPT_0x85
	SBIW R26,5
	BRGE _0x2DC
; 0000 163D                     cykl_sterownik_4 = sterownik_4_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x83
	CALL SUBOPT_0x86
; 0000 163E 
; 0000 163F                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2DC:
	CALL SUBOPT_0x87
	BREQ _0x2DD
; 0000 1640 
; 0000 1641                             {
; 0000 1642                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x81
; 0000 1643                                         cykl_sterownik_2 = 0;
; 0000 1644                                         cykl_sterownik_3 = 0;
; 0000 1645                                         cykl_sterownik_4 = 0;
; 0000 1646                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1647                                         f = 0;
	__GETWRN 20,21,0
; 0000 1648                                         }
; 0000 1649 
; 0000 164A    break;
_0x2DD:
; 0000 164B 
; 0000 164C 
; 0000 164D     }//switch
_0x2C6:
; 0000 164E 
; 0000 164F    }//while
	RJMP _0x2C1
_0x2C3:
; 0000 1650 
; 0000 1651 
; 0000 1652 
; 0000 1653 
; 0000 1654 
; 0000 1655 
; 0000 1656 
; 0000 1657 }
	CALL __LOADLOCR6
	ADIW R28,10
	RET
;
;
;
;
;
;void main(void)
; 0000 165E {
_main:
; 0000 165F 
; 0000 1660 // Declare your local variables here
; 0000 1661 /*
; 0000 1662 // Input/Output Ports initialization
; 0000 1663 // Port A initialization
; 0000 1664 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 1665 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 1666 PORTA=0x00;
; 0000 1667 DDRA=0x00;
; 0000 1668 
; 0000 1669 // Port B initialization
; 0000 166A // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 166B // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 166C PORTB=0x00;
; 0000 166D DDRB=0xFF;
; 0000 166E 
; 0000 166F // Port C initialization
; 0000 1670 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1671 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1672 PORTC=0x00;
; 0000 1673 DDRC=0xFF;
; 0000 1674 
; 0000 1675 // Port D initialization
; 0000 1676 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 1677 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 1678 PORTD=0x00;
; 0000 1679 DDRD=0x00;
; 0000 167A 
; 0000 167B // Port E initialization
; 0000 167C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 167D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 167E PORTE=0x00;
; 0000 167F DDRE=0x00;
; 0000 1680 
; 0000 1681 // Port F initialization
; 0000 1682 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 1683 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 1684 PORTF=0x00;
; 0000 1685 DDRF=0x00;
; 0000 1686 
; 0000 1687 // Port G initialization
; 0000 1688 // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 1689 // State4=T State3=T State2=T State1=T State0=T
; 0000 168A PORTG=0x00;
; 0000 168B DDRG=0x00;
; 0000 168C */
; 0000 168D 
; 0000 168E 
; 0000 168F // Input/Output Ports initialization
; 0000 1690 // Port A initialization
; 0000 1691 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1692 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1693 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 1694 DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 1695 
; 0000 1696 // Port B initialization
; 0000 1697 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1698 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1699 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 169A DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 169B 
; 0000 169C // Port C initialization
; 0000 169D // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 169E // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 169F PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 16A0 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 16A1 
; 0000 16A2 // Port D initialization
; 0000 16A3 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 16A4 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 16A5 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 16A6 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 16A7 
; 0000 16A8 // Port E initialization
; 0000 16A9 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 16AA // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 16AB PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 16AC DDRE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 16AD 
; 0000 16AE // Port F initialization
; 0000 16AF // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 16B0 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 16B1 PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 16B2 DDRF=0xFF;
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 16B3 
; 0000 16B4 // Port G initialization
; 0000 16B5 // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 16B6 // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 16B7 PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 16B8 DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 16B9 
; 0000 16BA 
; 0000 16BB 
; 0000 16BC 
; 0000 16BD 
; 0000 16BE // Timer/Counter 0 initialization
; 0000 16BF // Clock source: System Clock
; 0000 16C0 // Clock value: 15,625 kHz
; 0000 16C1 // Mode: Normal top=0xFF
; 0000 16C2 // OC0 output: Disconnected
; 0000 16C3 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 16C4 TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 16C5 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 16C6 OCR0=0x00;
	OUT  0x31,R30
; 0000 16C7 
; 0000 16C8 // Timer/Counter 1 initialization
; 0000 16C9 // Clock source: System Clock
; 0000 16CA // Clock value: Timer1 Stopped
; 0000 16CB // Mode: Normal top=0xFFFF
; 0000 16CC // OC1A output: Discon.
; 0000 16CD // OC1B output: Discon.
; 0000 16CE // OC1C output: Discon.
; 0000 16CF // Noise Canceler: Off
; 0000 16D0 // Input Capture on Falling Edge
; 0000 16D1 // Timer1 Overflow Interrupt: Off
; 0000 16D2 // Input Capture Interrupt: Off
; 0000 16D3 // Compare A Match Interrupt: Off
; 0000 16D4 // Compare B Match Interrupt: Off
; 0000 16D5 // Compare C Match Interrupt: Off
; 0000 16D6 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 16D7 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 16D8 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 16D9 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 16DA ICR1H=0x00;
	OUT  0x27,R30
; 0000 16DB ICR1L=0x00;
	OUT  0x26,R30
; 0000 16DC OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 16DD OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 16DE OCR1BH=0x00;
	OUT  0x29,R30
; 0000 16DF OCR1BL=0x00;
	OUT  0x28,R30
; 0000 16E0 OCR1CH=0x00;
	STS  121,R30
; 0000 16E1 OCR1CL=0x00;
	STS  120,R30
; 0000 16E2 
; 0000 16E3 // Timer/Counter 2 initialization
; 0000 16E4 // Clock source: System Clock
; 0000 16E5 // Clock value: Timer2 Stopped
; 0000 16E6 // Mode: Normal top=0xFF
; 0000 16E7 // OC2 output: Disconnected
; 0000 16E8 TCCR2=0x00;
	OUT  0x25,R30
; 0000 16E9 TCNT2=0x00;
	OUT  0x24,R30
; 0000 16EA OCR2=0x00;
	OUT  0x23,R30
; 0000 16EB 
; 0000 16EC // Timer/Counter 3 initialization
; 0000 16ED // Clock source: System Clock
; 0000 16EE // Clock value: Timer3 Stopped
; 0000 16EF // Mode: Normal top=0xFFFF
; 0000 16F0 // OC3A output: Discon.
; 0000 16F1 // OC3B output: Discon.
; 0000 16F2 // OC3C output: Discon.
; 0000 16F3 // Noise Canceler: Off
; 0000 16F4 // Input Capture on Falling Edge
; 0000 16F5 // Timer3 Overflow Interrupt: Off
; 0000 16F6 // Input Capture Interrupt: Off
; 0000 16F7 // Compare A Match Interrupt: Off
; 0000 16F8 // Compare B Match Interrupt: Off
; 0000 16F9 // Compare C Match Interrupt: Off
; 0000 16FA TCCR3A=0x00;
	STS  139,R30
; 0000 16FB TCCR3B=0x00;
	STS  138,R30
; 0000 16FC TCNT3H=0x00;
	STS  137,R30
; 0000 16FD TCNT3L=0x00;
	STS  136,R30
; 0000 16FE ICR3H=0x00;
	STS  129,R30
; 0000 16FF ICR3L=0x00;
	STS  128,R30
; 0000 1700 OCR3AH=0x00;
	STS  135,R30
; 0000 1701 OCR3AL=0x00;
	STS  134,R30
; 0000 1702 OCR3BH=0x00;
	STS  133,R30
; 0000 1703 OCR3BL=0x00;
	STS  132,R30
; 0000 1704 OCR3CH=0x00;
	STS  131,R30
; 0000 1705 OCR3CL=0x00;
	STS  130,R30
; 0000 1706 
; 0000 1707 // External Interrupt(s) initialization
; 0000 1708 // INT0: Off
; 0000 1709 // INT1: Off
; 0000 170A // INT2: Off
; 0000 170B // INT3: Off
; 0000 170C // INT4: Off
; 0000 170D // INT5: Off
; 0000 170E // INT6: Off
; 0000 170F // INT7: Off
; 0000 1710 EICRA=0x00;
	STS  106,R30
; 0000 1711 EICRB=0x00;
	OUT  0x3A,R30
; 0000 1712 EIMSK=0x00;
	OUT  0x39,R30
; 0000 1713 
; 0000 1714 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 1715 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 1716 
; 0000 1717 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 1718 
; 0000 1719 
; 0000 171A // USART0 initialization
; 0000 171B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 171C // USART0 Receiver: On
; 0000 171D // USART0 Transmitter: On
; 0000 171E // USART0 Mode: Asynchronous
; 0000 171F // USART0 Baud Rate: 115200
; 0000 1720 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 1721 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 1722 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 1723 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 1724 UBRR0L=0x08;
	LDI  R30,LOW(8)
	OUT  0x9,R30
; 0000 1725 
; 0000 1726 // USART1 initialization
; 0000 1727 // USART1 disabled
; 0000 1728 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 1729 
; 0000 172A // Analog Comparator initialization
; 0000 172B // Analog Comparator: Off
; 0000 172C // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 172D ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 172E SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 172F 
; 0000 1730 // ADC initialization
; 0000 1731 // ADC disabled
; 0000 1732 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 1733 
; 0000 1734 // SPI initialization
; 0000 1735 // SPI disabled
; 0000 1736 SPCR=0x00;
	OUT  0xD,R30
; 0000 1737 
; 0000 1738 // TWI initialization
; 0000 1739 // TWI disabled
; 0000 173A TWCR=0x00;
	STS  116,R30
; 0000 173B 
; 0000 173C //ciekawe, tej linijki brakowalo w medalach ,wyczailem w borgu
; 0000 173D // I2C Bus initialization
; 0000 173E i2c_init();
	CALL _i2c_init
; 0000 173F 
; 0000 1740 // Global enable interrupts
; 0000 1741 #asm("sei")
	sei
; 0000 1742 
; 0000 1743 
; 0000 1744 //delay_ms(8000); //bo panel sie inicjalizuje
; 0000 1745 //delay_ms(2000); //bo panel sie inicjalizuje
; 0000 1746 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x92
; 0000 1747 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x92
; 0000 1748 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x92
; 0000 1749 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x92
; 0000 174A 
; 0000 174B //delay_ms(2000); //bo panel sie inicjalizuje
; 0000 174C //delay_ms(2000); //bo panel sie inicjalizuje
; 0000 174D //delay_ms(2000); //bo panel sie inicjalizuje
; 0000 174E //delay_ms(2000); //bo panel sie inicjalizuje
; 0000 174F 
; 0000 1750 //jak patrze na maszyne to ten po lewej to 1
; 0000 1751 
; 0000 1752 putchar(90);  //5A
	CALL SUBOPT_0x1
; 0000 1753 putchar(165); //A5
; 0000 1754 putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _putchar
; 0000 1755 putchar(128);  //80
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _putchar
; 0000 1756 putchar(2);    //02
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
; 0000 1757 putchar(16);   //10
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
; 0000 1758 
; 0000 1759 il_prob_odczytu = 1;    //100
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 175A start = 0;
	CLR  R12
	CLR  R13
; 0000 175B szczotka_druciana_ilosc_cykli = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _szczotka_druciana_ilosc_cykli,R30
	STS  _szczotka_druciana_ilosc_cykli+1,R31
; 0000 175C krazek_scierny_cykl_po_okregu_ilosc = 4;
	STS  _krazek_scierny_cykl_po_okregu_ilosc,R30
	STS  _krazek_scierny_cykl_po_okregu_ilosc+1,R31
; 0000 175D krazek_scierny_ilosc_cykli = 4;
	STS  _krazek_scierny_ilosc_cykli,R30
	STS  _krazek_scierny_ilosc_cykli+1,R31
; 0000 175E rzad_obrabiany = 1;
	CALL SUBOPT_0x93
; 0000 175F jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 1760 wykonalem_rzedow = 0;
	CALL SUBOPT_0x94
; 0000 1761 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x95
; 0000 1762 guzik1_przelaczania_zaciskow = 1;
	SET
	BLD  R2,0
; 0000 1763 guzik2_przelaczania_zaciskow = 1;
	BLD  R2,1
; 0000 1764 PORTE.6 = 1;  //aby byl dostep do zaciskow rzad 1
	SBI  0x3,6
; 0000 1765 zmienna_przelaczanie_zaciskow = 1;
	BLD  R2,2
; 0000 1766 czas_przedmuchu = 183;
	LDI  R30,LOW(183)
	LDI  R31,HIGH(183)
	STS  _czas_przedmuchu,R30
	STS  _czas_przedmuchu+1,R31
; 0000 1767 predkosc_pion_szczotka = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 1768 predkosc_pion_krazek = 100;
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 1769 wejscie_krazka_sciernego_w_pow_boczna_cylindra = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 176A predkosc_ruchow_po_okregu_krazek_scierny = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 176B 
; 0000 176C 
; 0000 176D adr1 = 80;  //rzad 1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STS  _adr1,R30
	STS  _adr1+1,R31
; 0000 176E adr2 = 0;   //
	LDI  R30,LOW(0)
	STS  _adr2,R30
	STS  _adr2+1,R30
; 0000 176F adr3 = 64;  //rzad 2
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STS  _adr3,R30
	STS  _adr3+1,R31
; 0000 1770 adr4 = 0;
	LDI  R30,LOW(0)
	STS  _adr4,R30
	STS  _adr4+1,R30
; 0000 1771 
; 0000 1772 
; 0000 1773 
; 0000 1774 //zapal lampki
; 0000 1775 //PORTB.6 = 1;
; 0000 1776 //PORTD.7 = 1;
; 0000 1777 //PORT_F.bits.b6 = 1;
; 0000 1778 //PORTF = PORT_F.byte;
; 0000 1779 
; 0000 177A //PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 177B //PORTF = PORT_F.byte;
; 0000 177C //PORTB.4 = 1;  //przedmuch osi
; 0000 177D //PORTE.2 = 1;  //szlifierka 1
; 0000 177E //PORTE.3 = 1;  //szlifierka 2
; 0000 177F //PORTE.6 = 0;  //zacisniety rzad 1
; 0000 1780 //PORTE.6 = 1;  //zacisniety rzad 2
; 0000 1781 //PORTE.7 = 0;    //zacisnij zaciski
; 0000 1782 
; 0000 1783 //zalozenie: nie mozna czytac kodow kreskowych jak juz dalem start i idzie, dopoki nie skonczy
; 0000 1784 
; 0000 1785 wartosci_wstepne_panelu();
	RCALL _wartosci_wstepne_panelu
; 0000 1786 wypozycjonuj_napedy_minimalistyczna();
	RCALL _wypozycjonuj_napedy_minimalistyczna
; 0000 1787 sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 1788 
; 0000 1789 
; 0000 178A //PORT_F.bits.b4 = 1;  //przedmuch zaciskow
; 0000 178B //PORTF = PORT_F.byte;
; 0000 178C 
; 0000 178D //mniejsze ziarno na krazku - dobry pomysl
; 0000 178E 
; 0000 178F 
; 0000 1790 while (1)
_0x2E0:
; 0000 1791       {
; 0000 1792       ostateczny_wybor_zacisku();
	RCALL _ostateczny_wybor_zacisku
; 0000 1793       start = odczytaj_parametr(0,64);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x5E
	CALL _odczytaj_parametr
	MOVW R12,R30
; 0000 1794       il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x15
	CALL SUBOPT_0x96
; 0000 1795       il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x97
; 0000 1796       przerzucanie_dociskow();
	RCALL _przerzucanie_dociskow
; 0000 1797       wymiana_szczotki_i_krazka();
	RCALL _wymiana_szczotki_i_krazka
; 0000 1798 
; 0000 1799 
; 0000 179A 
; 0000 179B 
; 0000 179C      //jak zle wczyta takiego co go nie ma to dac ilosc zaciskow = 0 w tym rzedzie
; 0000 179D 
; 0000 179E 
; 0000 179F 
; 0000 17A0       while((start == 1 & il_zaciskow_rzad_1 > 1 & il_zaciskow_rzad_2 != 1 & macierz_zaciskow[1]!=0  & (macierz_zaciskow[2]!=0 |  il_zaciskow_rzad_2 == 0)) | jestem_w_trakcie_czyszczenia_calosci == 1)
_0x2E3:
	MOVW R26,R12
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x98
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __GTW12
	AND  R0,R30
	CALL SUBOPT_0x99
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	AND  R0,R30
	__GETW1MN _macierz_zaciskow,2
	CALL SUBOPT_0x9A
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0x9B
	MOV  R0,R30
	CALL SUBOPT_0x99
	CALL SUBOPT_0x70
	OR   R30,R0
	AND  R30,R1
	MOV  R0,R30
	LDS  R26,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R27,_jestem_w_trakcie_czyszczenia_calosci+1
	CALL SUBOPT_0x5A
	OR   R30,R0
	BRNE PC+3
	JMP _0x2E5
; 0000 17A1             {
; 0000 17A2             switch (cykl_glowny)
	LDS  R30,_cykl_glowny
	LDS  R31,_cykl_glowny+1
; 0000 17A3             {
; 0000 17A4             case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x2E9
; 0000 17A5 
; 0000 17A6 
; 0000 17A7                     PORTB.6 = 1;   ////zielona lampka
	SBI  0x18,6
; 0000 17A8                     if(jestem_w_trakcie_czyszczenia_calosci == 0)
	LDS  R30,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R31,_jestem_w_trakcie_czyszczenia_calosci+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x2EC
; 0000 17A9                         {
; 0000 17AA                         wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x83
	CALL SUBOPT_0x83
	CALL SUBOPT_0x64
; 0000 17AB                         wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad2
	CALL SUBOPT_0x83
	CALL SUBOPT_0x83
	CALL SUBOPT_0x63
; 0000 17AC 
; 0000 17AD                         il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x15
	CALL SUBOPT_0x96
; 0000 17AE                         il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x97
; 0000 17AF 
; 0000 17B0                         szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x5E
	CALL _odczytaj_parametr
	STS  _szczotka_druciana_ilosc_cykli,R30
	STS  _szczotka_druciana_ilosc_cykli+1,R31
; 0000 17B1                                                 //2090
; 0000 17B2                         krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x14
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0x9D
	STS  _krazek_scierny_ilosc_cykli,R30
	STS  _krazek_scierny_ilosc_cykli+1,R31
; 0000 17B3                                                     //3000
; 0000 17B4                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x83
	CALL _odczytaj_parametr
	STS  _krazek_scierny_cykl_po_okregu_ilosc,R30
	STS  _krazek_scierny_cykl_po_okregu_ilosc+1,R31
; 0000 17B5 
; 0000 17B6                         predkosc_pion_szczotka = odczytaj_parametr(32,80);
	CALL SUBOPT_0x14
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x9D
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 17B7                                                 //2060
; 0000 17B8                         predkosc_pion_krazek = odczytaj_parametr(32,96);
	CALL SUBOPT_0x14
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x9D
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 17B9 
; 0000 17BA                         wejscie_krazka_sciernego_w_pow_boczna_cylindra = odczytaj_parametr(48,16);
	CALL SUBOPT_0x9C
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x9D
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 17BB 
; 0000 17BC                         predkosc_ruchow_po_okregu_krazek_scierny = odczytaj_parametr(32,112);
	CALL SUBOPT_0x14
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	CALL SUBOPT_0x9D
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 17BD 
; 0000 17BE                         if(il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0)
	CALL SUBOPT_0x9E
	MOV  R0,R30
	CALL SUBOPT_0x9B
	AND  R30,R0
	BREQ _0x2ED
; 0000 17BF                               il_zaciskow_rzad_2 = il_zaciskow_rzad_2;
	CALL SUBOPT_0x9F
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
; 0000 17C0                         else
	RJMP _0x2EE
_0x2ED:
; 0000 17C1                               il_zaciskow_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R30
; 0000 17C2 
; 0000 17C3                         wybor_linijek_sterownikow(1);  //rzad 1
_0x2EE:
	CALL SUBOPT_0xA0
	CALL _wybor_linijek_sterownikow
; 0000 17C4                         }
; 0000 17C5 
; 0000 17C6                     jestem_w_trakcie_czyszczenia_calosci = 1;
_0x2EC:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R31
; 0000 17C7 
; 0000 17C8                     if(rzad_obrabiany == 1)
	CALL SUBOPT_0xA1
	SBIW R26,1
	BRNE _0x2EF
; 0000 17C9                     {
; 0000 17CA                     PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
	CBI  0x3,6
; 0000 17CB                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x89
	SBIW R26,5
	BRGE _0x2F2
; 0000 17CC                         cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0xA2
	CALL SUBOPT_0x8B
; 0000 17CD                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x2F2:
	CALL SUBOPT_0x8C
	SBIW R26,5
	BRGE _0x2F3
; 0000 17CE                         cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8D
; 0000 17CF                     }
_0x2F3:
; 0000 17D0 
; 0000 17D1                     if(rzad_obrabiany == 2)
_0x2EF:
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x2F4
; 0000 17D2                     {
; 0000 17D3                     ostateczny_wybor_zacisku();
	RCALL _ostateczny_wybor_zacisku
; 0000 17D4                     //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2 - na razie nie bo nie ma jeszcze oslon
; 0000 17D5 
; 0000 17D6                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x89
	SBIW R26,5
	BRGE _0x2F5
; 0000 17D7                         cykl_sterownik_1 = sterownik_1_praca(0x008);
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0xA3
; 0000 17D8                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x2F5:
	CALL SUBOPT_0x8C
	SBIW R26,5
	BRGE _0x2F6
; 0000 17D9                         cykl_sterownik_2 = sterownik_2_praca(0x001);       //ster 2 pod pin pozy rzad 2
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x8D
; 0000 17DA                     }
_0x2F6:
; 0000 17DB 
; 0000 17DC 
; 0000 17DD                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x2F4:
	CALL SUBOPT_0x8E
	BREQ _0x2F7
; 0000 17DE                         {
; 0000 17DF 
; 0000 17E0                           if(rzad_obrabiany == 2)
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x2F8
; 0000 17E1                             {
; 0000 17E2                             while(PORTE.6 == 0)
_0x2F9:
	SBIC 0x3,6
	RJMP _0x2FB
; 0000 17E3                                 przerzucanie_dociskow();
	RCALL _przerzucanie_dociskow
	RJMP _0x2F9
_0x2FB:
; 0000 17E4 delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 17E5                             }
; 0000 17E6 
; 0000 17E7                         cykl_sterownik_1 = 0;
_0x2F8:
	CALL SUBOPT_0x81
; 0000 17E8                         cykl_sterownik_2 = 0;
; 0000 17E9                         cykl_sterownik_3 = 0;
; 0000 17EA                         cykl_sterownik_4 = 0;
; 0000 17EB                         cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x95
; 0000 17EC                         koniec_rzedu_10 = 0;
	CALL SUBOPT_0xA4
; 0000 17ED                         start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x5E
	CALL SUBOPT_0xA5
; 0000 17EE                         if(start_kontynuacja == 1)
	BRNE _0x2FC
; 0000 17EF                             cykl_glowny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0xA6
; 0000 17F0                         }
_0x2FC:
; 0000 17F1 
; 0000 17F2             break;
_0x2F7:
	RJMP _0x2E8
; 0000 17F3 
; 0000 17F4 
; 0000 17F5 
; 0000 17F6             case 1:
_0x2E9:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2FD
; 0000 17F7 
; 0000 17F8 
; 0000 17F9                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 1)
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x5A
	AND  R30,R0
	BREQ _0x2FE
; 0000 17FA                           {          //ster 1 nic
; 0000 17FB                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 17FC                           cykl_sterownik_2 = sterownik_2_praca(a[0]);        //ster 2 pod zacisk
	CALL SUBOPT_0x52
	CALL SUBOPT_0xA8
; 0000 17FD                           }                                                    //ster 4 na pozycje miedzy rzedzami
; 0000 17FE 
; 0000 17FF                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 2)
_0x2FE:
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA9
	BREQ _0x301
; 0000 1800                         {
; 0000 1801                         //cykl_sterownik_2 = sterownik_2_praca(0x5B,0);
; 0000 1802                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 1803                           ostateczny_wybor_zacisku();
	RCALL _ostateczny_wybor_zacisku
; 0000 1804                           cykl_sterownik_2 = sterownik_2_praca(a[1]);
	__GETW1MN _a,2
	CALL SUBOPT_0xA8
; 0000 1805                          }
; 0000 1806                      if(cykl_sterownik_4 < 5 & cykl_sterownik_2 == 5)
_0x301:
	CALL SUBOPT_0xAA
	CALL __LTW12
	CALL SUBOPT_0xAB
	AND  R30,R0
	BREQ _0x304
; 0000 1807                        // cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);
; 0000 1808                         cykl_sterownik_4 = sterownik_4_praca(0x01);
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x86
; 0000 1809 
; 0000 180A                       if(cykl_sterownik_2 == 5 & cykl_sterownik_4 == 5)
_0x304:
	CALL SUBOPT_0xAC
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0xAA
	CALL __EQW12
	AND  R30,R0
	BREQ _0x305
; 0000 180B                         {
; 0000 180C                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xAD
; 0000 180D                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0xAE
; 0000 180E                         cykl_sterownik_4 = 0;
; 0000 180F                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0xAF
; 0000 1810 
; 0000 1811 
; 0000 1812                         start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x5E
	CALL SUBOPT_0xA5
; 0000 1813                         if(start_kontynuacja == 1)
	BRNE _0x306
; 0000 1814                             cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xA6
; 0000 1815                         }
_0x306:
; 0000 1816 
; 0000 1817 
; 0000 1818             break;
_0x305:
	RJMP _0x2E8
; 0000 1819 
; 0000 181A 
; 0000 181B             case 2:
_0x2FD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x307
; 0000 181C                     if(rzad_obrabiany == 2)
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x308
; 0000 181D                         ostateczny_wybor_zacisku();
	RCALL _ostateczny_wybor_zacisku
; 0000 181E 
; 0000 181F                     if(cykl_sterownik_4 < 5)
_0x308:
	CALL SUBOPT_0x85
	SBIW R26,5
	BRGE _0x309
; 0000 1820                         //cykl_sterownik_4 = sterownik_4_praca(1,0,0,0,1,0);  //ABS  //tu blad w arkuszu exela
; 0000 1821                           cykl_sterownik_4 = sterownik_4_praca(a[2]);
	CALL SUBOPT_0xB0
; 0000 1822                     if(cykl_sterownik_4 == 5)
_0x309:
	CALL SUBOPT_0x85
	SBIW R26,5
	BRNE _0x30A
; 0000 1823                         {
; 0000 1824                         PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1825                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xB1
; 0000 1826                         start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x5E
	CALL SUBOPT_0xA5
; 0000 1827                         if(start_kontynuacja == 1)
	BRNE _0x30D
; 0000 1828                             cykl_glowny = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xA6
; 0000 1829                         }
_0x30D:
; 0000 182A 
; 0000 182B             break;
_0x30A:
	RJMP _0x2E8
; 0000 182C 
; 0000 182D 
; 0000 182E             case 3:
_0x307:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x30E
; 0000 182F 
; 0000 1830                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x30F
; 0000 1831                         ostateczny_wybor_zacisku();
	RCALL _ostateczny_wybor_zacisku
; 0000 1832 
; 0000 1833                     if(cykl_sterownik_4 < 5)
_0x30F:
	CALL SUBOPT_0x85
	SBIW R26,5
	BRGE _0x310
; 0000 1834                        //cykl_sterownik_4 = sterownik_4_praca(0,1,0,0,0,1); //INV
; 0000 1835                          cykl_sterownik_4 = sterownik_4_praca(a[3]); //INV
	CALL SUBOPT_0x56
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x86
; 0000 1836 
; 0000 1837                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x310:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xB2
	BREQ _0x311
; 0000 1838                         {
; 0000 1839                         szczotka_druc_cykl++;
	CALL SUBOPT_0xB3
; 0000 183A                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xB1
; 0000 183B 
; 0000 183C                         if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
	CALL SUBOPT_0xB4
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x312
; 0000 183D                             {
; 0000 183E                             start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x5E
	CALL SUBOPT_0xA5
; 0000 183F                             if(start_kontynuacja == 1)
	BRNE _0x313
; 0000 1840                                   cykl_glowny = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xA6
; 0000 1841                             }
_0x313:
; 0000 1842                         else
	RJMP _0x314
_0x312:
; 0000 1843                             {
; 0000 1844                             start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x5E
	CALL SUBOPT_0xA5
; 0000 1845                             if(start_kontynuacja == 1)
	BRNE _0x315
; 0000 1846                                 cykl_glowny = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xA6
; 0000 1847 
; 0000 1848 
; 0000 1849                             }
_0x315:
_0x314:
; 0000 184A                         }
; 0000 184B 
; 0000 184C 
; 0000 184D 
; 0000 184E             break;
_0x311:
	RJMP _0x2E8
; 0000 184F 
; 0000 1850             case 4:
_0x30E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x316
; 0000 1851 
; 0000 1852 
; 0000 1853                       if(rzad_obrabiany == 2)
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x317
; 0000 1854                             ostateczny_wybor_zacisku();
	RCALL _ostateczny_wybor_zacisku
; 0000 1855 
; 0000 1856                      if(cykl_sterownik_4 < 5)
_0x317:
	CALL SUBOPT_0x85
	SBIW R26,5
	BRGE _0x318
; 0000 1857                         //cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej
; 0000 1858                         cykl_sterownik_4 = sterownik_4_praca(0x01);
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x86
; 0000 1859 
; 0000 185A                      if(cykl_sterownik_4 == 5)
_0x318:
	CALL SUBOPT_0x85
	SBIW R26,5
	BRNE _0x319
; 0000 185B                         {
; 0000 185C                         PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 185D                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xB1
; 0000 185E                         start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x5E
	CALL SUBOPT_0xA5
; 0000 185F                         if(start_kontynuacja == 1)
	BRNE _0x31C
; 0000 1860                             {
; 0000 1861                             ruch_zlozony = 0;
	LDI  R30,LOW(0)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R30
; 0000 1862                             cykl_glowny = 5;
	CALL SUBOPT_0xB5
; 0000 1863                             }
; 0000 1864                         }
_0x31C:
; 0000 1865 
; 0000 1866             break;
_0x319:
	RJMP _0x2E8
; 0000 1867 
; 0000 1868             case 5:
_0x316:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x31D
; 0000 1869 
; 0000 186A 
; 0000 186B                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 1)
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xB7
	AND  R30,R0
	BREQ _0x31E
; 0000 186C                         cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8B
; 0000 186D                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 2)
_0x31E:
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xB8
	BREQ _0x31F
; 0000 186E                         cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x8B
; 0000 186F 
; 0000 1870                      if(rzad_obrabiany == 2)
_0x31F:
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x320
; 0000 1871                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1872 
; 0000 1873                     if(cykl_sterownik_1 == 5 & ruch_zlozony == 0)
_0x320:
	CALL SUBOPT_0xB9
	CALL __EQW12
	CALL SUBOPT_0xBA
	CALL SUBOPT_0x70
	AND  R30,R0
	BREQ _0x321
; 0000 1874                         {
; 0000 1875                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xAD
; 0000 1876                         ruch_zlozony = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 1877                         }
; 0000 1878 
; 0000 1879                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 1)
_0x321:
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xBB
	CALL SUBOPT_0x5A
	CALL SUBOPT_0xB7
	AND  R30,R0
	BREQ _0x322
; 0000 187A                         //cykl_sterownik_1 = sterownik_1_praca(0x5A,0);
; 0000 187B                         cykl_sterownik_1 = sterownik_1_praca(a[0]);
	CALL SUBOPT_0x52
	CALL SUBOPT_0xA3
; 0000 187C                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 2)
_0x322:
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xBB
	CALL SUBOPT_0x5A
	CALL SUBOPT_0xB8
	BREQ _0x323
; 0000 187D                         //cykl_sterownik_1 = sterownik_1_praca(0x5B,0);
; 0000 187E                           cykl_sterownik_1 = sterownik_1_praca(a[1]);
	__GETW1MN _a,2
	CALL SUBOPT_0xA3
; 0000 187F 
; 0000 1880 
; 0000 1881                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 2)
_0x323:
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xBB
	CALL SUBOPT_0xA9
	BREQ _0x324
; 0000 1882                         cykl_sterownik_1 = sterownik_1_praca(0x003);     ////////////////////////////////////////////////////////////
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xA3
; 0000 1883 
; 0000 1884                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 0)                                //ster 1 do pierwszego dolka
_0x324:
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xBC
	CALL SUBOPT_0x70
	AND  R30,R0
	BREQ _0x325
; 0000 1885                         cykl_sterownik_2 = sterownik_2_praca(0x003);       //ster 2 pod nastpeny dolek
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xA8
; 0000 1886 
; 0000 1887 
; 0000 1888                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 1)
_0x325:
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xBC
	CALL SUBOPT_0x5A
	CALL SUBOPT_0xB7
	AND  R30,R0
	BREQ _0x326
; 0000 1889                         cykl_sterownik_2 = sterownik_2_praca(0x008);      //ster 2 do samego tylu
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0xA8
; 0000 188A                      if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 2)
_0x326:
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xBC
	CALL SUBOPT_0x5A
	CALL SUBOPT_0xB8
	BREQ _0x327
; 0000 188B                         cykl_sterownik_2 = sterownik_2_praca(0x009);      //ster 2 do samego tylu
	CALL SUBOPT_0xA2
	CALL SUBOPT_0x8D
; 0000 188C 
; 0000 188D                     if((cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5 & ruch_zlozony == 1) | (cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5) & ruch_zlozony == 2)
_0x327:
	CALL SUBOPT_0xB9
	CALL __EQW12
	CALL SUBOPT_0xAB
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0x5A
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0xB9
	CALL __EQW12
	CALL SUBOPT_0xAB
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0xA9
	OR   R30,R1
	BREQ _0x328
; 0000 188E                         {
; 0000 188F                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xAD
; 0000 1890                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0xAE
; 0000 1891                         cykl_sterownik_4 = 0;
; 0000 1892                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xBD
; 0000 1893                         start_kontynuacja = odczytaj_parametr(0,64);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x5E
	CALL SUBOPT_0xA5
; 0000 1894                         if(start_kontynuacja == 1)
	BRNE _0x329
; 0000 1895                             {
; 0000 1896                             cykl_glowny = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0xA6
; 0000 1897                             }
; 0000 1898                         }
_0x329:
; 0000 1899 
; 0000 189A             break;
_0x328:
	RJMP _0x2E8
; 0000 189B 
; 0000 189C 
; 0000 189D 
; 0000 189E            case 6:
_0x31D:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x32A
; 0000 189F 
; 0000 18A0 
; 0000 18A1 
; 0000 18A2 
; 0000 18A3                     if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0x82
	SBIW R26,5
	BRGE _0x32B
; 0000 18A4                         //cykl_sterownik_3 = sterownik_3_praca(1,0,0,0,0,1);  //ABS          //krazek scierny do gory
; 0000 18A5                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
	CALL SUBOPT_0x53
	CALL SUBOPT_0xBE
; 0000 18A6 
; 0000 18A7                     if(koniec_rzedu_10 == 1)
_0x32B:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	SBIW R26,1
	BRNE _0x32C
; 0000 18A8                         cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x7F
; 0000 18A9 
; 0000 18AA                     if(cykl_sterownik_4 < 5)
_0x32C:
	CALL SUBOPT_0x85
	SBIW R26,5
	BRGE _0x32D
; 0000 18AB                         //cykl_sterownik_4 = sterownik_4_praca(1,0,0,0,1,0);  //ABS          //druciak do gory
; 0000 18AC                         cykl_sterownik_4 = sterownik_4_praca(a[2]);
	CALL SUBOPT_0xB0
; 0000 18AD 
; 0000 18AE                      if(rzad_obrabiany == 2)
_0x32D:
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x32E
; 0000 18AF                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 18B0 
; 0000 18B1 
; 0000 18B2                     if(cykl_sterownik_4 == 5 & cykl_sterownik_3 == 5)
_0x32E:
	CALL SUBOPT_0xAA
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0xBF
	CALL __EQW12
	AND  R30,R0
	BREQ _0x32F
; 0000 18B3                         {
; 0000 18B4                         if((cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1 & rzad_obrabiany == 1) | (cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1 & rzad_obrabiany == 2))
	CALL SUBOPT_0xC0
	MOV  R0,R30
	CALL SUBOPT_0xA1
	CALL SUBOPT_0x5A
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0xC1
	MOV  R0,R30
	CALL SUBOPT_0xA1
	CALL SUBOPT_0xA9
	OR   R30,R1
	BREQ _0x330
; 0000 18B5                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 18B6                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
_0x330:
	SBI  0x3,3
; 0000 18B7                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0x88
; 0000 18B8                         cykl_sterownik_4 = 0;
; 0000 18B9                         if(cykl_ilosc_zaciskow > 0)
	CALL SUBOPT_0xC2
	CALL __CPW02
	BRGE _0x335
; 0000 18BA                                 {
; 0000 18BB                                 sek12 = 0;    //do przedmuchu
	CALL SUBOPT_0xC3
; 0000 18BC                                 PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0xC4
; 0000 18BD                                 PORTF = PORT_F.byte;
; 0000 18BE                                 }
; 0000 18BF                         start_kontynuacja = odczytaj_parametr(0,64);
_0x335:
	CALL SUBOPT_0x83
	CALL SUBOPT_0x5E
	CALL SUBOPT_0xA5
; 0000 18C0                         if(start_kontynuacja == 1)
	BRNE _0x336
; 0000 18C1                             cykl_glowny = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0xA6
; 0000 18C2                         }
_0x336:
; 0000 18C3 
; 0000 18C4            break;
_0x32F:
	RJMP _0x2E8
; 0000 18C5 
; 0000 18C6 
; 0000 18C7            case 7:
_0x32A:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x337
; 0000 18C8                                                                                               //mini ruch do przygotowania do okregu
; 0000 18C9                     //while(1)
; 0000 18CA                     //    {
; 0000 18CB                     //    }
; 0000 18CC 
; 0000 18CD 
; 0000 18CE                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x89
	SBIW R26,5
	BRGE _0x338
; 0000 18CF                         //cykl_sterownik_1 = sterownik_1_praca(0x96,1);
; 0000 18D0                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x54
	CALL SUBOPT_0xA3
; 0000 18D1 
; 0000 18D2                      if(rzad_obrabiany == 2)
_0x338:
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x339
; 0000 18D3                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 18D4 
; 0000 18D5                     if(cykl_sterownik_1 == 5)
_0x339:
	CALL SUBOPT_0x89
	SBIW R26,5
	BRNE _0x33A
; 0000 18D6                         {
; 0000 18D7                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xAD
; 0000 18D8                         cykl_glowny = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0xA6
; 0000 18D9                         szczotka_druc_cykl = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0xAF
; 0000 18DA                         krazek_scierny_cykl_po_okregu = 0;
	LDI  R30,LOW(0)
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
; 0000 18DB                         wykonalem_komplet_okregow = 0;
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R30
; 0000 18DC                         abs_ster3 = 0;
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R30
; 0000 18DD                         abs_ster4 = 0;
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
; 0000 18DE                         }
; 0000 18DF 
; 0000 18E0 
; 0000 18E1 
; 0000 18E2            break;
_0x33A:
	RJMP _0x2E8
; 0000 18E3 
; 0000 18E4 
; 0000 18E5             case 8:
_0x337:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x33B
; 0000 18E6 
; 0000 18E7                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xC5
	BRGE _0x33C
; 0000 18E8                         {
; 0000 18E9                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xC6
; 0000 18EA                         PORTF = PORT_F.byte;
; 0000 18EB                         }
; 0000 18EC 
; 0000 18ED 
; 0000 18EE                      if(rzad_obrabiany == 2)
_0x33C:
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x33D
; 0000 18EF                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 18F0 
; 0000 18F1                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
_0x33D:
	CALL SUBOPT_0xB9
	CALL __LTW12
	CALL SUBOPT_0xC7
	AND  R30,R0
	BREQ _0x33E
; 0000 18F2                         //cykl_sterownik_1 = sterownik_1_praca(0x97,1);
; 0000 18F3                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	__GETW1MN _a,12
	CALL SUBOPT_0xA3
; 0000 18F4 
; 0000 18F5                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
_0x33E:
	CALL SUBOPT_0xB9
	CALL __EQW12
	CALL SUBOPT_0xC7
	AND  R30,R0
	BREQ _0x33F
; 0000 18F6                         {
; 0000 18F7                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xAD
; 0000 18F8                         krazek_scierny_cykl_po_okregu++;
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu)
	CALL SUBOPT_0xC8
; 0000 18F9                         }
; 0000 18FA 
; 0000 18FB                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
_0x33F:
	CALL SUBOPT_0x62
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL SUBOPT_0xC9
	CALL SUBOPT_0x70
	AND  R30,R0
	BREQ _0x340
; 0000 18FC                         {
; 0000 18FD                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xAD
; 0000 18FE                         wykonalem_komplet_okregow = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
; 0000 18FF                         }
; 0000 1900 
; 0000 1901                     if(koniec_rzedu_10 == 1)
_0x340:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	SBIW R26,1
	BRNE _0x341
; 0000 1902                         cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x7F
; 0000 1903 
; 0000 1904                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0)
_0x341:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xCA
	CALL SUBOPT_0x70
	AND  R30,R0
	BREQ _0x342
; 0000 1905                        //cykl_sterownik_4 = sterownik_4_praca(0,1,0,0,0,1); //INV               //szczotka druc
; 0000 1906                          cykl_sterownik_4 = sterownik_4_praca(a[3]); //INV               //szczotka druc
	CALL SUBOPT_0x56
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x86
; 0000 1907 
; 0000 1908                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x342:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xB2
	BREQ _0x343
; 0000 1909                         {
; 0000 190A                         if(koniec_rzedu_10 == 0)
	LDS  R30,_koniec_rzedu_10
	LDS  R31,_koniec_rzedu_10+1
	SBIW R30,0
	BRNE _0x344
; 0000 190B                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xB1
; 0000 190C                         if(abs_ster4 == 0)
_0x344:
	LDS  R30,_abs_ster4
	LDS  R31,_abs_ster4+1
	SBIW R30,0
	BRNE _0x345
; 0000 190D                             {
; 0000 190E                             szczotka_druc_cykl++;
	CALL SUBOPT_0xB3
; 0000 190F                             abs_ster4 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R31
; 0000 1910                             }
; 0000 1911                         else
	RJMP _0x346
_0x345:
; 0000 1912                             abs_ster4 = 0;
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
; 0000 1913                         }
_0x346:
; 0000 1914 
; 0000 1915                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0)
_0x343:
	CALL SUBOPT_0xBF
	CALL SUBOPT_0xCB
	CALL SUBOPT_0x70
	AND  R30,R0
	BREQ _0x347
; 0000 1916                        //cykl_sterownik_3 = sterownik_3_praca(0,1,0,0,1,0); //INV                   //krazek scierny
; 0000 1917                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	__GETW1MN _a,14
	CALL SUBOPT_0xBE
; 0000 1918 
; 0000 1919 
; 0000 191A                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli)
_0x347:
	CALL SUBOPT_0xBF
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0xCC
	CALL __LTW12
	AND  R30,R0
	BREQ _0x348
; 0000 191B                         {
; 0000 191C 
; 0000 191D                          cykl_sterownik_3 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0xBD
; 0000 191E                         if(abs_ster3 == 0)
	LDS  R30,_abs_ster3
	LDS  R31,_abs_ster3+1
	SBIW R30,0
	BRNE _0x349
; 0000 191F                             {
; 0000 1920                             krazek_scierny_cykl++;
	LDI  R26,LOW(_krazek_scierny_cykl)
	LDI  R27,HIGH(_krazek_scierny_cykl)
	CALL SUBOPT_0xC8
; 0000 1921                             abs_ster3 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R31
; 0000 1922                             }
; 0000 1923                         else
	RJMP _0x34A
_0x349:
; 0000 1924                             abs_ster3 = 0;
	LDI  R30,LOW(0)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R30
; 0000 1925                         }
_0x34A:
; 0000 1926 
; 0000 1927                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x348:
	CALL SUBOPT_0xBF
	CALL SUBOPT_0xCB
	CALL SUBOPT_0x5A
	AND  R30,R0
	BREQ _0x34B
; 0000 1928                         //cykl_sterownik_3 = sterownik_3_praca(1,0,0,0,0,1);  //ABS          //krazek scierny do gory
; 0000 1929                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x53
	CALL SUBOPT_0xBE
; 0000 192A 
; 0000 192B                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1)
_0x34B:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xCA
	CALL SUBOPT_0x5A
	AND  R30,R0
	BREQ _0x34C
; 0000 192C                         //cykl_sterownik_4 = sterownik_4_praca(1,0,0,0,1,0);  //ABS          //druciak do gory
; 0000 192D                         cykl_sterownik_4 = sterownik_4_praca(a[2]);  //ABS          //druciak do gory
	CALL SUBOPT_0xB0
; 0000 192E 
; 0000 192F                                                                                            //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1930                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 1)
_0x34C:
	CALL SUBOPT_0xB9
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	CALL SUBOPT_0x5A
	AND  R30,R0
	BREQ _0x34D
; 0000 1931                         //cykl_sterownik_1 = sterownik_1_praca(0x98,1);
; 0000 1932                          cykl_sterownik_1 = sterownik_1_praca(a[8]);                      ////////////////////////////////////////////////////
	__GETW1MN _a,16
	CALL SUBOPT_0xA3
; 0000 1933 
; 0000 1934 
; 0000 1935                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 1 &
_0x34D:
; 0000 1936                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 1937                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1938                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xC9
	CALL SUBOPT_0x5A
	AND  R0,R30
	CALL SUBOPT_0xB4
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0xCC
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0xBF
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0xAA
	CALL __EQW12
	AND  R30,R0
	BREQ _0x34E
; 0000 1939                         {
; 0000 193A                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x81
; 0000 193B                         cykl_sterownik_2 = 0;
; 0000 193C                         cykl_sterownik_3 = 0;
; 0000 193D                         cykl_sterownik_4 = 0;
; 0000 193E                         szczotka_druc_cykl = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0xAF
; 0000 193F                         krazek_scierny_cykl = 0;
	LDI  R30,LOW(0)
	STS  _krazek_scierny_cykl,R30
	STS  _krazek_scierny_cykl+1,R30
; 0000 1940                         krazek_scierny_cykl_po_okregu = 0;
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
; 0000 1941                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0xC6
; 0000 1942                         PORTF = PORT_F.byte;
; 0000 1943                         cykl_glowny = 9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL SUBOPT_0xA6
; 0000 1944                         }
; 0000 1945 
; 0000 1946                                                                                                 //ster 1 - ruch po okregu
; 0000 1947                                                                                                 //ster 2 - nic
; 0000 1948                                                                                                 //ster 3 - krazek - gora dol
; 0000 1949                                                                                                 //ster 4 - druciak - gora dol
; 0000 194A 
; 0000 194B             break;
_0x34E:
	RJMP _0x2E8
; 0000 194C 
; 0000 194D 
; 0000 194E             case 9:                                          //cykl 3 == 5
_0x33B:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x34F
; 0000 194F 
; 0000 1950 
; 0000 1951                          if(rzad_obrabiany == 1)
	CALL SUBOPT_0xA1
	SBIW R26,1
	BRNE _0x350
; 0000 1952                          {
; 0000 1953                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)
	CALL SUBOPT_0xBF
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0xC0
	AND  R30,R0
	BREQ _0x351
; 0000 1954                               cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x84
; 0000 1955 
; 0000 1956 
; 0000 1957                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_1 - 2)
_0x351:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xCD
	CALL SUBOPT_0xCE
	BREQ _0x352
; 0000 1958                             cykl_sterownik_4 = sterownik_4_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x86
; 0000 1959 
; 0000 195A 
; 0000 195B                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)       //2 marca 2019 wykomentowuje
_0x352:
	CALL SUBOPT_0xBF
	CALL SUBOPT_0xCD
	CALL SUBOPT_0xCF
	BREQ _0x353
; 0000 195C                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x83
	CALL SUBOPT_0x84
; 0000 195D 
; 0000 195E 
; 0000 195F                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_1 - 2)
_0x353:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xCD
	CALL SUBOPT_0xD0
	BREQ _0x354
; 0000 1960                             cykl_sterownik_4 = sterownik_4_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x83
	CALL SUBOPT_0x86
; 0000 1961 
; 0000 1962                           }
_0x354:
; 0000 1963 
; 0000 1964 
; 0000 1965                          if(rzad_obrabiany == 2)
_0x350:
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x355
; 0000 1966                          {
; 0000 1967                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
	CALL SUBOPT_0xBF
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0xC1
	AND  R30,R0
	BREQ _0x356
; 0000 1968                             cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x84
; 0000 1969 
; 0000 196A                          // if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
; 0000 196B                          //   cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej
; 0000 196C 
; 0000 196D                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_2 - 2)
_0x356:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xD1
	CALL SUBOPT_0xCE
	BREQ _0x357
; 0000 196E                             cykl_sterownik_4 = sterownik_4_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x86
; 0000 196F 
; 0000 1970                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x357:
	CALL SUBOPT_0xBF
	CALL SUBOPT_0xD1
	CALL SUBOPT_0xCF
	BREQ _0x358
; 0000 1971                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x83
	CALL SUBOPT_0x84
; 0000 1972 
; 0000 1973                          // if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
; 0000 1974                          //   cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
; 0000 1975 
; 0000 1976                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_2 - 2)
_0x358:
	CALL SUBOPT_0xAA
	CALL SUBOPT_0xD1
	CALL SUBOPT_0xD0
	BREQ _0x359
; 0000 1977                             cykl_sterownik_4 = sterownik_4_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x83
	CALL SUBOPT_0x86
; 0000 1978 
; 0000 1979                            if(rzad_obrabiany == 2)
_0x359:
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x35A
; 0000 197A                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 197B 
; 0000 197C                           }
_0x35A:
; 0000 197D 
; 0000 197E 
; 0000 197F                           if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x355:
	CALL SUBOPT_0x87
	BREQ _0x35B
; 0000 1980                             {
; 0000 1981                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1982                             PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1983                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xB1
; 0000 1984                             cykl_sterownik_3 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0xBD
; 0000 1985                             cykl_ilosc_zaciskow++;
	LDI  R26,LOW(_cykl_ilosc_zaciskow)
	LDI  R27,HIGH(_cykl_ilosc_zaciskow)
	CALL SUBOPT_0xC8
; 0000 1986                             ruch_zlozony = 2;                       //il_zaciskow_rzad_1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 1987                             cykl_glowny = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0xA6
; 0000 1988                             }
; 0000 1989 
; 0000 198A 
; 0000 198B             break;
_0x35B:
	RJMP _0x2E8
; 0000 198C 
; 0000 198D 
; 0000 198E 
; 0000 198F             case 10:
_0x34F:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x360
; 0000 1990 
; 0000 1991                                                //wywali ten warunek jak zadziala
; 0000 1992                      if(rzad_obrabiany == 1 & cykl_glowny != 0)
	CALL SUBOPT_0xA1
	CALL SUBOPT_0x5A
	CALL SUBOPT_0xD2
	BREQ _0x361
; 0000 1993                             {
; 0000 1994                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,16);  //wykonano zaciskow rzad1
	CALL SUBOPT_0xD3
	CALL SUBOPT_0x64
; 0000 1995                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_1 - 1)
	CALL SUBOPT_0xD4
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x362
; 0000 1996                                 {
; 0000 1997                                 cykl_glowny = 5;
	CALL SUBOPT_0xB5
; 0000 1998                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0xA4
; 0000 1999                                 }
; 0000 199A 
; 0000 199B                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
_0x362:
	CALL SUBOPT_0xD4
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x363
; 0000 199C                                 {
; 0000 199D                                 cykl_glowny = 5;
	CALL SUBOPT_0xB5
; 0000 199E                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0xD5
; 0000 199F                                 }
; 0000 19A0 
; 0000 19A1                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 == 10)
_0x363:
	CALL SUBOPT_0xD6
	CALL SUBOPT_0x5B
	BREQ _0x364
; 0000 19A2                                 {
; 0000 19A3                                 cykl_glowny = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0xA6
; 0000 19A4                                 }
; 0000 19A5 
; 0000 19A6                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 != 10)  /////zmieniam + 1 20.02
_0x364:
	CALL SUBOPT_0xD6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __NEW12
	AND  R30,R0
	BREQ _0x365
; 0000 19A7                                 {
; 0000 19A8                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0xA6
; 0000 19A9                                 }
; 0000 19AA                             }
_0x365:
; 0000 19AB 
; 0000 19AC 
; 0000 19AD                              if(rzad_obrabiany == 2)
_0x361:
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x366
; 0000 19AE                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 19AF 
; 0000 19B0                             if(rzad_obrabiany == 2 & cykl_glowny != 0)
_0x366:
	CALL SUBOPT_0xA1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	CALL SUBOPT_0xD2
	BREQ _0x367
; 0000 19B1                             {
; 0000 19B2                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,96);  //wykonano zaciskow rzad1
	CALL SUBOPT_0xD3
	CALL SUBOPT_0x63
; 0000 19B3                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_2 - 1)
	CALL SUBOPT_0x9F
	SBIW R30,1
	CALL SUBOPT_0xC2
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x368
; 0000 19B4                                 {
; 0000 19B5                                 cykl_glowny = 5;
	CALL SUBOPT_0xB5
; 0000 19B6                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0xA4
; 0000 19B7                                 }
; 0000 19B8 
; 0000 19B9                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x368:
	CALL SUBOPT_0x9F
	SBIW R30,1
	CALL SUBOPT_0xC2
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x369
; 0000 19BA                                 {
; 0000 19BB                                 cykl_glowny = 5;
	CALL SUBOPT_0xB5
; 0000 19BC                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0xD5
; 0000 19BD                                 }
; 0000 19BE 
; 0000 19BF                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 == 10)
_0x369:
	CALL SUBOPT_0xD7
	CALL SUBOPT_0x5B
	BREQ _0x36A
; 0000 19C0                                 {
; 0000 19C1                                 cykl_glowny = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0xA6
; 0000 19C2                                 }
; 0000 19C3 
; 0000 19C4 
; 0000 19C5                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 != 10)   ///////////////////zmieniam + 1 20.02
_0x36A:
	CALL SUBOPT_0xD7
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __NEW12
	AND  R30,R0
	BREQ _0x36B
; 0000 19C6                                 {
; 0000 19C7                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0xA6
; 0000 19C8                                 }
; 0000 19C9                             }
_0x36B:
; 0000 19CA 
; 0000 19CB 
; 0000 19CC 
; 0000 19CD             break;
_0x367:
	RJMP _0x2E8
; 0000 19CE 
; 0000 19CF 
; 0000 19D0 
; 0000 19D1             case 11:
_0x360:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x36C
; 0000 19D2 
; 0000 19D3                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x36D
; 0000 19D4                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 19D5 
; 0000 19D6                              //ster 1 ucieka od szafy
; 0000 19D7                              if(cykl_sterownik_1 < 5)
_0x36D:
	CALL SUBOPT_0x89
	SBIW R26,5
	BRGE _0x36E
; 0000 19D8                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0xA3
; 0000 19D9 
; 0000 19DA                              if(cykl_sterownik_2 < 5)
_0x36E:
	CALL SUBOPT_0x8C
	SBIW R26,5
	BRGE _0x36F
; 0000 19DB                                     //cykl_sterownik_2 = sterownik_2_praca(0x90,1);     //pod dolek ostatni 10 do przedmuchu rzad 1
; 0000 19DC                                     cykl_sterownik_2 = sterownik_2_praca(0x190);     //pod dolek ostatni 10 do przedmuchu rzad 1
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0xA8
; 0000 19DD 
; 0000 19DE                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x36F:
	CALL SUBOPT_0x8E
	BREQ _0x370
; 0000 19DF                                     {
; 0000 19E0                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0xC4
; 0000 19E1                                     PORTF = PORT_F.byte;
; 0000 19E2                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0xAD
; 0000 19E3                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0xD8
; 0000 19E4                                     cykl_glowny = 13;
; 0000 19E5                                     }
; 0000 19E6             break;
_0x370:
	RJMP _0x2E8
; 0000 19E7 
; 0000 19E8 
; 0000 19E9             case 12:
_0x36C:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x371
; 0000 19EA 
; 0000 19EB                              if(rzad_obrabiany == 2)
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x372
; 0000 19EC                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 19ED 
; 0000 19EE                                //ster 1 ucieka od szafy
; 0000 19EF                              if(cykl_sterownik_1 < 5)
_0x372:
	CALL SUBOPT_0x89
	SBIW R26,5
	BRGE _0x373
; 0000 19F0                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0xA3
; 0000 19F1 
; 0000 19F2                             if(cykl_sterownik_2 < 5)
_0x373:
	CALL SUBOPT_0x8C
	SBIW R26,5
	BRGE _0x374
; 0000 19F3                                     cykl_sterownik_2 = sterownik_2_praca(0x191);     //pod dolek ostatni 10 do przedmuchu rzad 2
	LDI  R30,LOW(401)
	LDI  R31,HIGH(401)
	CALL SUBOPT_0xA8
; 0000 19F4 
; 0000 19F5                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x374:
	CALL SUBOPT_0x8E
	BREQ _0x375
; 0000 19F6                                     {
; 0000 19F7                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0xC4
; 0000 19F8                                     PORTF = PORT_F.byte;
; 0000 19F9                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0xAD
; 0000 19FA                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0xD8
; 0000 19FB                                     cykl_glowny = 13;
; 0000 19FC                                     }
; 0000 19FD 
; 0000 19FE 
; 0000 19FF             break;
_0x375:
	RJMP _0x2E8
; 0000 1A00 
; 0000 1A01 
; 0000 1A02 
; 0000 1A03             case 13:
_0x371:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x376
; 0000 1A04 
; 0000 1A05 
; 0000 1A06                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x377
; 0000 1A07                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1A08 
; 0000 1A09                              if(cykl_sterownik_2 < 5)
_0x377:
	CALL SUBOPT_0x8C
	SBIW R26,5
	BRGE _0x378
; 0000 1A0A                                     cykl_sterownik_2 = sterownik_2_praca(0x192);     //okrag
	LDI  R30,LOW(402)
	LDI  R31,HIGH(402)
	CALL SUBOPT_0xA8
; 0000 1A0B                              if(cykl_sterownik_2 == 5)
_0x378:
	CALL SUBOPT_0x8C
	SBIW R26,5
	BRNE _0x379
; 0000 1A0C                                     {
; 0000 1A0D                                     PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0xC6
; 0000 1A0E                                     PORTF = PORT_F.byte;
; 0000 1A0F                                     cykl_sterownik_2 = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
; 0000 1A10                                     cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0xA6
; 0000 1A11                                     }
; 0000 1A12 
; 0000 1A13             break;
_0x379:
	RJMP _0x2E8
; 0000 1A14 
; 0000 1A15 
; 0000 1A16 
; 0000 1A17             case 14:
_0x376:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x37A
; 0000 1A18 
; 0000 1A19 
; 0000 1A1A                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x37B
; 0000 1A1B                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1A1C 
; 0000 1A1D                     if(cykl_sterownik_1 < 5)
_0x37B:
	CALL SUBOPT_0x89
	SBIW R26,5
	BRGE _0x37C
; 0000 1A1E                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek zeby przedmuchac
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xA3
; 0000 1A1F                     if(cykl_sterownik_1 == 5)
_0x37C:
	CALL SUBOPT_0x89
	SBIW R26,5
	BRNE _0x37D
; 0000 1A20                         {
; 0000 1A21                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xAD
; 0000 1A22                         sek12 = 0;
	CALL SUBOPT_0xC3
; 0000 1A23                         cykl_glowny = 15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0xA6
; 0000 1A24                         }
; 0000 1A25 
; 0000 1A26             break;
_0x37D:
	RJMP _0x2E8
; 0000 1A27 
; 0000 1A28 
; 0000 1A29 
; 0000 1A2A             case 15:
_0x37A:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x37E
; 0000 1A2B 
; 0000 1A2C                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0xA1
	SBIW R26,2
	BRNE _0x37F
; 0000 1A2D                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1A2E 
; 0000 1A2F                     //przedmuch
; 0000 1A30                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
_0x37F:
	CALL SUBOPT_0xC4
; 0000 1A31                     PORTF = PORT_F.byte;
; 0000 1A32                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xC5
	BRGE _0x380
; 0000 1A33                         {
; 0000 1A34                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xC6
; 0000 1A35                         PORTF = PORT_F.byte;
; 0000 1A36                         cykl_glowny = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0xA6
; 0000 1A37                         }
; 0000 1A38             break;
_0x380:
	RJMP _0x2E8
; 0000 1A39 
; 0000 1A3A 
; 0000 1A3B             case 16:
_0x37E:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x381
; 0000 1A3C 
; 0000 1A3D                      if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & wykonalem_rzedow == 0)  /////zmieniam + 1 20.02
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	CALL SUBOPT_0xC2
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0xD9
	CALL SUBOPT_0x70
	AND  R30,R0
	BREQ _0x382
; 0000 1A3E                                 {
; 0000 1A3F                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x95
; 0000 1A40                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1A41                                 if(il_zaciskow_rzad_2 > 0)
	CALL SUBOPT_0x99
	CALL __CPW02
	BRGE _0x385
; 0000 1A42                                     {
; 0000 1A43 
; 0000 1A44                                     rzad_obrabiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
; 0000 1A45                                     wybor_linijek_sterownikow(2);  //rzad 2
	CALL SUBOPT_0x90
	CALL _wybor_linijek_sterownikow
; 0000 1A46                                     cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 1A47                                     }
; 0000 1A48                                 else
	RJMP _0x386
_0x385:
; 0000 1A49                                     cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0xA6
; 0000 1A4A 
; 0000 1A4B                                 wykonalem_rzedow = 1;
_0x386:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 1A4C                                 }
; 0000 1A4D 
; 0000 1A4E                        if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 1)   ///////////////////zmieniam + 1 20.02
_0x382:
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xC2
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x9E
	AND  R0,R30
	CALL SUBOPT_0xD9
	CALL SUBOPT_0x5A
	AND  R30,R0
	BREQ _0x387
; 0000 1A4F                                 {
; 0000 1A50                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1A51                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0x95
; 0000 1A52                                 cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0xA6
; 0000 1A53                                 rzad_obrabiany = 1;
	CALL SUBOPT_0x93
; 0000 1A54                                 wykonalem_rzedow = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 1A55                                 }
; 0000 1A56 
; 0000 1A57 
; 0000 1A58 
; 0000 1A59 
; 0000 1A5A                         if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 2)
_0x387:
	CALL SUBOPT_0xDA
	CALL SUBOPT_0x9E
	AND  R0,R30
	CALL SUBOPT_0xD9
	CALL SUBOPT_0xA9
	BREQ _0x38A
; 0000 1A5B                                   {
; 0000 1A5C                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x93
; 0000 1A5D                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0x94
; 0000 1A5E                                   PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1A5F                                   //PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1 - tego na razie nie poki nie ma oslon
; 0000 1A60                                   PORTB.6 = 0;   ////zielona lampka
	CBI  0x18,6
; 0000 1A61                                   wartosc_parametru_panelu(0,0,64);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x83
	CALL SUBOPT_0x5E
	CALL _wartosc_parametru_panelu
; 0000 1A62                                   }
; 0000 1A63 
; 0000 1A64                             if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 == 0 & wykonalem_rzedow == 1)
_0x38A:
	CALL SUBOPT_0xDA
	CALL SUBOPT_0x99
	CALL SUBOPT_0x70
	AND  R0,R30
	CALL SUBOPT_0xD9
	CALL SUBOPT_0x5A
	AND  R30,R0
	BREQ _0x38F
; 0000 1A65                                   {
; 0000 1A66                                   rzad_obrabiany = 1;
	CALL SUBOPT_0x93
; 0000 1A67                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0x94
; 0000 1A68                                   PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
	SBI  0x3,6
; 0000 1A69                                   PORTB.6 = 0;   ////zielona lampka
	CBI  0x18,6
; 0000 1A6A                                   wartosc_parametru_panelu(0,0,64);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x83
	CALL SUBOPT_0x5E
	CALL _wartosc_parametru_panelu
; 0000 1A6B                                   }
; 0000 1A6C 
; 0000 1A6D 
; 0000 1A6E 
; 0000 1A6F             break;
_0x38F:
	RJMP _0x2E8
; 0000 1A70 
; 0000 1A71 
; 0000 1A72             case 17:
_0x381:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x2E8
; 0000 1A73 
; 0000 1A74 
; 0000 1A75                                  if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0x89
	SBIW R26,5
	BRGE _0x395
; 0000 1A76                                     cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0xA2
	CALL SUBOPT_0x8B
; 0000 1A77                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x395:
	CALL SUBOPT_0x8C
	SBIW R26,5
	BRGE _0x396
; 0000 1A78                                     cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8D
; 0000 1A79 
; 0000 1A7A                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x396:
	CALL SUBOPT_0x8E
	BREQ _0x397
; 0000 1A7B                                         {
; 0000 1A7C                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0x81
; 0000 1A7D                                         cykl_sterownik_2 = 0;
; 0000 1A7E                                         cykl_sterownik_3 = 0;
; 0000 1A7F                                         cykl_sterownik_4 = 0;
; 0000 1A80                                         jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 1A81                                         start = 0;
	CLR  R12
	CLR  R13
; 0000 1A82                                         cykl_glowny = 0;
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 1A83                                         }
; 0000 1A84 
; 0000 1A85 
; 0000 1A86 
; 0000 1A87 
; 0000 1A88             break;
_0x397:
; 0000 1A89 
; 0000 1A8A 
; 0000 1A8B             }//switch
_0x2E8:
; 0000 1A8C 
; 0000 1A8D 
; 0000 1A8E   }//while
	RJMP _0x2E3
_0x2E5:
; 0000 1A8F }//while glowny
	RJMP _0x2E0
; 0000 1A90 
; 0000 1A91 }//koniec
_0x398:
	RJMP _0x398
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
	CALL SUBOPT_0xC8
	ADIW R28,3
	RET
__print_G103:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x1A
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
	CALL SUBOPT_0xDB
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0xDB
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
	CALL SUBOPT_0xDC
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xDD
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xDE
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xDE
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
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xDF
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
	CALL SUBOPT_0xDC
	CALL SUBOPT_0xDF
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
	CALL SUBOPT_0xDB
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
	CALL SUBOPT_0xDB
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
	CALL SUBOPT_0xDD
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0xDB
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
	CALL SUBOPT_0xDD
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
	CALL SUBOPT_0x16
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 154 TIMES, CODE SIZE REDUCTION:609 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_macierz_zaciskow)
	LDI  R27,HIGH(_macierz_zaciskow)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x9:
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
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(_PORTJJ)
	LDI  R31,HIGH(_PORTJJ)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x10:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr1
	LDS  R31,_adr1+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr2
	LDS  R31,_adr2+1
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:97 WORDS
SUBOPT_0x11:
	LDS  R30,_adr1
	LDS  R31,_adr1+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr2
	LDS  R31,_adr2+1
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x12:
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
SUBOPT_0x13:
	OR   R30,R0
	STS  _PORT_CZYTNIK,R30
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 145 TIMES, CODE SIZE REDUCTION:285 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 69 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_z_czytnika_kodow

;OPTIMIZER ADDED SUBROUTINE, CALLED 75 TIMES, CODE SIZE REDUCTION:293 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_z_czytnika_kodow

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x19:
	ST   X+,R30
	ST   X,R31
	MOVW R30,R16
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 136 TIMES, CODE SIZE REDUCTION:537 WORDS
SUBOPT_0x1C:
	STS  _a,R30
	STS  _a+1,R31
	__POINTW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 106 TIMES, CODE SIZE REDUCTION:417 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x1E:
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
SUBOPT_0x1F:
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x20:
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
SUBOPT_0x21:
	__POINTW1MN _a,18
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x23:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x25:
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x26:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x27:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x29:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
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
SUBOPT_0x2C:
	LDI  R26,LOW(29)
	LDI  R27,HIGH(29)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x2E:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2F:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x30:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x31:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x32:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x33:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x34:
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
SUBOPT_0x35:
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x36:
	__POINTW1MN _a,8
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:186 WORDS
SUBOPT_0x37:
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
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	LDI  R26,LOW(27)
	LDI  R27,HIGH(27)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x39:
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
SUBOPT_0x3A:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x3B:
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	LDI  R26,LOW(22)
	LDI  R27,HIGH(22)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3E:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3F:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	LDI  R26,LOW(20)
	LDI  R27,HIGH(20)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x42:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x43:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	LDI  R26,LOW(36)
	LDI  R27,HIGH(36)
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x44:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x47:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	__POINTW1MN _a,8
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x47

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	__POINTW1MN _a,8
	LDI  R26,LOW(23)
	LDI  R27,HIGH(23)
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4D:
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4E:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	LDS  R30,_a
	LDS  R31,_a+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	__GETW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x54:
	__GETW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x55:
	ADIW R30,1
	__PUTW1MN _a,12
	__GETW1MN _a,12
	ADIW R30,1
	__PUTW1MN _a,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	__GETW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	LDS  R26,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R27,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x58:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_predkosc_ruchow_po_okregu_krazek_scierny
	LDS  R27,_predkosc_ruchow_po_okregu_krazek_scierny+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x59:
	__PUTW1MN _a,10
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x5A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5B:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5C:
	LDS  R30,_szczotka_druciana_ilosc_cykli
	LDS  R31,_szczotka_druciana_ilosc_cykli+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x5D:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5E:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5F:
	LDS  R30,_krazek_scierny_ilosc_cykli
	LDS  R31,_krazek_scierny_ilosc_cykli+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x60:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x61:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x62:
	LDS  R30,_krazek_scierny_cykl_po_okregu_ilosc
	LDS  R31,_krazek_scierny_cykl_po_okregu_ilosc+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	RJMP SUBOPT_0x61

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x64:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP SUBOPT_0x61

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x65:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x66:
	CALL _sprawdz_pin3
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x67:
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
SUBOPT_0x68:
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
SUBOPT_0x69:
	CALL _sprawdz_pin7
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x6A:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6B:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x6C:
	LDI  R30,LOW(_PORTMM)
	LDI  R31,HIGH(_PORTMM)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6D:
	CALL _sprawdz_pin6
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6E:
	CALL _sprawdz_pin5
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6F:
	AND  R30,R26
	MOV  R0,R30
	LDS  R26,_czekaj_az_puszcze
	LDS  R27,_czekaj_az_puszcze+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x70:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x71:
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
SUBOPT_0x72:
	LDI  R30,LOW(0)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x73:
	LDI  R30,LOW(0)
	STS  _sek11,R30
	STS  _sek11+1,R30
	STS  _sek11+2,R30
	STS  _sek11+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x74:
	LDI  R30,LOW(0)
	STS  _sek1,R30
	STS  _sek1+1,R30
	STS  _sek1+2,R30
	STS  _sek1+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x75:
	__CPD2N 0x2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x76:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x77:
	LDI  R30,LOW(0)
	STS  _sek3,R30
	STS  _sek3+1,R30
	STS  _sek3+2,R30
	STS  _sek3+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x78:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x79:
	OR   R30,R0
	STS  _PORT_F,R30
	LDS  R30,_PORT_STER3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x7A:
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7B:
	LDI  R30,LOW(0)
	STS  _sek2,R30
	STS  _sek2+1,R30
	STS  _sek2+2,R30
	STS  _sek2+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x7C:
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7D:
	STS  _PORT_F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7E:
	LDI  R30,LOW(0)
	STS  _sek4,R30
	STS  _sek4+1,R30
	STS  _sek4+2,R30
	STS  _sek4+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x7F:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x80:
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	RJMP SUBOPT_0x5D

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:141 WORDS
SUBOPT_0x81:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x82:
	LDS  R26,_cykl_sterownik_3
	LDS  R27,_cykl_sterownik_3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x83:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x84:
	CALL _sterownik_3_praca
	RJMP SUBOPT_0x7C

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x85:
	LDS  R26,_cykl_sterownik_4
	LDS  R27,_cykl_sterownik_4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x86:
	CALL _sterownik_4_praca
	RJMP SUBOPT_0x7F

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x87:
	RCALL SUBOPT_0x82
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0x85
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x88:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x89:
	LDS  R26,_cykl_sterownik_1
	LDS  R27,_cykl_sterownik_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8A:
	LDI  R30,LOW(505)
	LDI  R31,HIGH(505)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x8B:
	CALL _sterownik_1_praca
	RJMP SUBOPT_0x76

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x8C:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x8D:
	CALL _sterownik_2_praca
	RJMP SUBOPT_0x78

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x8E:
	RCALL SUBOPT_0x89
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0x8C
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8F:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x90:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x91:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x92:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x93:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x94:
	LDI  R30,LOW(0)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x95:
	LDI  R30,LOW(0)
	STS  _cykl_ilosc_zaciskow,R30
	STS  _cykl_ilosc_zaciskow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x96:
	CALL _odczytaj_parametr
	STS  _il_zaciskow_rzad_1,R30
	STS  _il_zaciskow_rzad_1+1,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0x5D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x97:
	CALL _odczytaj_parametr
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x98:
	MOV  R0,R30
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x99:
	LDS  R26,_il_zaciskow_rzad_2
	LDS  R27,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9A:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9B:
	__GETW1MN _macierz_zaciskow,4
	RJMP SUBOPT_0x9A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9C:
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9D:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9E:
	RCALL SUBOPT_0x99
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9F:
	LDS  R30,_il_zaciskow_rzad_2
	LDS  R31,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0xA1:
	LDS  R26,_rzad_obrabiany
	LDS  R27,_rzad_obrabiany+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA2:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA3:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA4:
	LDI  R30,LOW(0)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:60 WORDS
SUBOPT_0xA5:
	CALL _odczytaj_parametr
	STS  _start_kontynuacja,R30
	STS  _start_kontynuacja+1,R31
	LDS  R26,_start_kontynuacja
	LDS  R27,_start_kontynuacja+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0xA6:
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA7:
	RCALL SUBOPT_0x8C
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	RJMP SUBOPT_0xA1

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA8:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x8D

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xA9:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xAA:
	RCALL SUBOPT_0x85
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xAB:
	MOV  R0,R30
	RCALL SUBOPT_0x8C
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xAC:
	RCALL SUBOPT_0x8C
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xAD:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xAE:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAF:
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB0:
	__GETW1MN _a,4
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x86

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB1:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB2:
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0x5C
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB3:
	LDI  R26,LOW(_szczotka_druc_cykl)
	LDI  R27,HIGH(_szczotka_druc_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB4:
	RCALL SUBOPT_0x5C
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB5:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0xA6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xB6:
	RCALL SUBOPT_0x89
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RJMP SUBOPT_0x70

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB7:
	AND  R0,R30
	RCALL SUBOPT_0xA1
	RJMP SUBOPT_0x5A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB8:
	AND  R0,R30
	RCALL SUBOPT_0xA1
	RJMP SUBOPT_0xA9

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xB9:
	RCALL SUBOPT_0x89
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xBA:
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBB:
	CALL __LTW12
	RJMP SUBOPT_0xBA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xBC:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBD:
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBE:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xBF:
	RCALL SUBOPT_0x82
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC0:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC1:
	RCALL SUBOPT_0x9F
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xC2:
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC3:
	LDI  R30,LOW(0)
	STS  _sek12,R30
	STS  _sek12+1,R30
	STS  _sek12+2,R30
	STS  _sek12+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC4:
	LDS  R30,_PORT_F
	ORI  R30,0x10
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xC5:
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
SUBOPT_0xC6:
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xC7:
	MOV  R0,R30
	RCALL SUBOPT_0x62
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __LTW12
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x70

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC8:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC9:
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xCA:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster4
	LDS  R27,_abs_ster4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xCB:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster3
	LDS  R27,_abs_ster3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCC:
	RCALL SUBOPT_0x5F
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xCD:
	CALL __LTW12
	MOV  R0,R30
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCE:
	SBIW R30,2
	RCALL SUBOPT_0xC2
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCF:
	SBIW R30,1
	RCALL SUBOPT_0xC2
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD0:
	SBIW R30,2
	RCALL SUBOPT_0xC2
	CALL __GEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD1:
	CALL __LTW12
	MOV  R0,R30
	RJMP SUBOPT_0x9F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD2:
	MOV  R0,R30
	LDS  R26,_cykl_glowny
	LDS  R27,_cykl_glowny+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD3:
	LDS  R30,_cykl_ilosc_zaciskow
	LDS  R31,_cykl_ilosc_zaciskow+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x83

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD4:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	RJMP SUBOPT_0xC2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD5:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD6:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RCALL SUBOPT_0xC2
	CALL __EQW12
	RJMP SUBOPT_0x98

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD7:
	RCALL SUBOPT_0x9F
	RCALL SUBOPT_0xC2
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x99

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD8:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RJMP SUBOPT_0xA6

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD9:
	LDS  R26,_wykonalem_rzedow
	LDS  R27,_wykonalem_rzedow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xDA:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xDB:
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
SUBOPT_0xDC:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xDD:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xDE:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xDF:
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
